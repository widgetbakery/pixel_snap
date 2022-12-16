import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer/file_system/physical_file_system.dart';

// ignore: implementation_imports
import 'package:analyzer/src/dart/ast/utilities.dart' show NodeLocator2;
import 'package:collection/collection.dart';

class Field {
  Field({
    required this.type,
    required this.name,
    required this.docString,
    required this.nullable,
    required this.fromSuperClass,
    required this.named,
    this.defaultValue,
  });

  final String type;
  final String name;
  final String? docString;
  final bool nullable;
  final bool named;
  final bool fromSuperClass;
  final String? defaultValue;
}

class Constructor {
  Constructor({
    required this.docString,
    required this.code,
  });

  final String? docString;
  final String code;

  @override
  String toString() {
    return code;
  }
}

enum ChildType {
  nullable,
  nonNulable,
  none,
}

class Class {
  Class({
    required this.constructors,
    required this.fields,
    required this.docString,
    required this.className,
    required this.childType,
  });

  @override
  String toString() {
    final b = StringBuffer();
    b.writeln('Class $className (${constructors.length} constructors)');
    for (final f in fields) {
      b.writeln('  Field ${f.type}${f.nullable ? '?' : ''} ${f.name}');
    }
    return b.toString();
  }

  final List<Constructor> constructors;
  final List<Field> fields;
  final String? docString;
  final String className;
  final ChildType childType;
}

class ForkedClass {
  ForkedClass({
    required this.className,
    required this.contents,
  });

  final String className;
  final String contents;
}

class ParseException implements Exception {
  ParseException(this.message);

  final String message;
}

class Contents {
  Contents({
    required this.classes,
    required this.forkedClasses,
  });

  final List<Class> classes;
  final List<ForkedClass> forkedClasses;
}

class Parser {
  Parser(this.rootPath) : _context = _createAnalysisContext(path: rootPath);

  Future<Contents> parse() async {
    final rootUnit = await _resolveUnit(rootPath);
    await _processRootUnit(rootUnit);
    return Contents(
      classes: _classes,
      forkedClasses: _forkedClasses,
    );
  }

  Future<void> _processRootUnit(ResolvedUnitResult unit) async {
    final e = unit.libraryElement.children.first as CompilationUnitElement;

    final f = e.functions.first;
    for (final annotation in f.metadata) {
      final value = annotation.computeConstantValue();
      final type = value!.type as InterfaceType;
      if (type.element.name == "GeneratePixelSnap") {
        await _processClass(type.typeArguments.first as InterfaceType);
      } else if (type.element.name == "GeneratePixelSnapFork") {
        await _processFork(type.typeArguments.first as InterfaceType);
      }
    }
  }

  void _gatherFields(
    InterfaceType instanceType,
    List<Field> fields,
    bool isSuperClass,
  ) {
    for (final accessor in instanceType.accessors) {
      if (!accessor.isSynthetic) {
        // Only interested in synthetic accessor (for final fields)
        continue;
      }
      final variable = accessor.variable;
      final name = accessor.name;

      // We want nullability inside,but not the nullable suffix
      final type = variable.type
          .getDisplayString(withNullability: true)
          .replaceAll(RegExp('\\?\$'), '');

      final nullable =
          variable.type.nullabilitySuffix == NullabilitySuffix.question;

      final constructor = instanceType.constructors.first;

      final parameter =
          constructor.parameters.firstWhereOrNull((p) => p.name == name);

      fields.add(Field(
        type: type,
        name: name,
        docString: variable.documentationComment,
        nullable: nullable,
        named: parameter?.isNamed ?? false,
        fromSuperClass: isSuperClass,
        defaultValue: parameter?.defaultValueCode,
      ));
    }
  }

  Future<void> _processFork(InterfaceType type) async {
    final contents = StringBuffer();
    contents.write(await _elementToString(type.element, includeComments: true));
    if (type.element.name == 'Image') {
      final cu = type.element.enclosingElement;
      final state = cu.getClass("_ImageState");
      if (state != null) {
        contents.write(await _elementToString(state, includeComments: true));
      }
    }
    _forkedClasses.add(
      ForkedClass(
        className: type.element.name,
        contents: contents.toString(),
      ),
    );
  }

  Future<void> _processClass(
    InterfaceType type,
  ) async {
    final constructors = <Constructor>[];
    for (final c in type.constructors) {
      constructors.add(Constructor(
        docString: c.documentationComment,
        code: await _elementToString(c, includeComments: false),
      ));
    }
    final fields = <Field>[];
    _gatherFields(type, fields, false);
    if (type.superclass!.element.name != 'Widget') {
      _gatherFields(type.superclass!, fields, true);
    }

    var childType = ChildType.none;
    final constructor = type.constructors.first;
    final childParameter = constructor.parameters
        .firstWhereOrNull((element) => element.name == 'child');
    if (childParameter != null) {
      final type = childParameter.type;
      if (type.nullabilitySuffix == NullabilitySuffix.question) {
        childType = ChildType.nullable;
      } else {
        childType = ChildType.nonNulable;
      }
    }

    _classes.add(Class(
      constructors: constructors,
      fields: fields,
      docString: type.element.documentationComment,
      className: type.element.name,
      childType: childType,
    ));
  }

  Future<String> _elementToString(
    Element element, {
    required bool includeComments,
  }) async {
    final source = element.source!;
    final unit = await _resolveUnit(source.fullName);
    final locator = NodeLocator2(element.nameOffset);
    var node = locator.searchWithin(unit.unit);
    if (node is SimpleIdentifier) {
      node = node.parent;
    }
    if (includeComments) {
      final content = source.contents.data;
      final substring = content.substring(node!.offset, node.end);
      return substring;
    } else {
      return node!.toSource();
    }
  }

  Future<ResolvedUnitResult> _resolveUnit(String path) async {
    var unit = _resolvedUnits[path];
    if (unit == null) {
      final resolved = await _context.currentSession.getResolvedUnit(path);
      if (resolved is ResolvedUnitResult) {
        unit = resolved;
        _resolvedUnits[path] = unit;
      } else {
        _error("Unexpected resolve unit $resolved");
      }
    }
    return unit!;
  }

  void _error(String message) {
    throw ParseException(message);
  }

  final _classes = <Class>[];
  final _forkedClasses = <ForkedClass>[];
  final _resolvedUnits = <String, ResolvedUnitResult>{};
  final AnalysisContext _context;
  final String rootPath;

  static AnalysisContext _createAnalysisContext({
    required String path,
    ResourceProvider? resourceProvider,
  }) {
    AnalysisContextCollection collection = AnalysisContextCollection(
      includedPaths: <String>[path],
      resourceProvider: resourceProvider ?? PhysicalResourceProvider.INSTANCE,
    );
    List<AnalysisContext> contexts = collection.contexts;
    if (contexts.length != 1) {
      throw ArgumentError('path must be an absolute path to a single file');
    }
    return contexts[0];
  }
}
