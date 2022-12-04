library generator;

import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:dart_style/dart_style.dart';
import 'package:pixel_perfect_generator/parser.dart';

class GeneratorException implements Exception {
  GeneratorException(this.message);

  final String message;
}

class Generator {
  Generator(this._classes);

  final List<String> _ourCustomWidgets = [
    'Flex',
    'Row',
    'Column',
    'Text',
    'RichText',
    'Center',
  ];

  String generateWidgets() {
    _buffer.clear();
    _buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    // There are still some asserts in Flutter code
    _buffer.writeln("// ignore_for_file: unnecessary_null_comparison");

    final classes = _ourCustomWidgets.join(', ');
    _buffer.writeln('import \'../pixel_snap.dart\';');
    _buffer.writeln('import \'../widgets/pixel_snap_size.dart\';');
    _buffer.writeln('import \'package:flutter/widgets.dart\';');
    _buffer.writeln('import \'package:flutter/widgets.dart\' as widgets;');
    _buffer.writeln('export \'package:flutter/widgets.dart\' hide $classes;');
    _buffer.writeln('import \'package:flutter/foundation.dart\';');
    _buffer.writeln('import \'dart:io\' show File;');

    for (final c in _classes) {
      _buffer.writeln();
      _writeClass(c);
    }

    return _buffer.toString();
  }

  String generatePackage(String name) {
    _buffer.clear();
    _buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    final classes =
        [..._ourCustomWidgets, ..._classes.map((e) => e.className)].join(', ');

    _buffer.writeln('export \'package:flutter/$name.dart\' hide $classes;');
    _buffer.writeln('export \'widgets.dart\';');

    return _buffer.toString();
  }

  void _writeClass(Class c) {
    if (c.docString != null) {
      _buffer.writeln(c.docString);
    }
    _buffer.writeln('class ${c.className} extends StatelessWidget {');

    for (final constructor in c.constructors) {
      if (constructor.docString != null) {
        _buffer.writeln(constructor.docString);
      }
      var code = constructor.code.replaceAll('super.child', 'this.child');
      for (final f in c.fields) {
        if (f.fromSuperClass) {
          final defaultCode =
              f.defaultValue != null ? ' = ${f.defaultValue!}' : '';
          code =
              code.replaceAll('super.${f.name}', 'this.${f.name} $defaultCode');
        }
      }
      if (c.className == 'AnimatedCrossFade') {
        code = code.replaceAll('defaultLayoutBuilder',
            'widgets.AnimatedCrossFade.defaultLayoutBuilder');
      }
      _buffer.writeln(code);
    }

    if (c.fields.any((element) => element.name == 'child') == false) {
      if (c.childType != ChildType.none) {
        _buffer.writeln();
        _buffer.writeln('/// {@macro flutter.widgets.ProxyWidget.child}');
        final suffix = c.childType == ChildType.nullable ? '?' : '';
        _buffer.writeln('final Widget$suffix child;');
      }
    }

    for (final field in c.fields) {
      if (field.docString != null) {
        _buffer.writeln(field.docString);
      }
      _buffer.writeln(
          'final ${field.type}${field.nullable ? '?' : ''} ${field.name};');
    }

    _buffer.writeln();
    _buffer.writeln('@override');
    _buffer.writeln('Widget build(BuildContext context) {');
    _buffer.writeln('Widget res = widgets.${c.className}(');
    for (final field in c.fields) {
      if (field.name == 'child') {
        continue;
      }
      const pixelSnapWhitelist = [
        'double',
        'EdgeInsetsGeometry',
        'Size',
        'Decoration',
        'BoxConstraints',
        'AlignmentGeometry',
        'BorderRadius',
      ];
      const pixelSnapBlackList = [
        'widthFactor',
        'heightFactor',
        'fill',
        'weight',
        'grade',
        'opticalSize',
      ];
      var pixelSnapSuffix = '';
      if (pixelSnapWhitelist.contains(field.type) &&
          !pixelSnapBlackList.contains(field.name)) {
        pixelSnapSuffix = '.pixelSnap()';
      }
      if (pixelSnapSuffix.isNotEmpty && field.nullable) {
        pixelSnapSuffix = '?$pixelSnapSuffix';
      }
      if (field.named) {
        _buffer.write('${field.name}: ');
      }
      _buffer.writeln('${field.name}$pixelSnapSuffix,');
    }
    if (c.childType != ChildType.none) {
      _buffer.writeln('child: child,');
    }
    _buffer.writeln(');');
    if (c.className == 'Image') {
      _buffer.writeln(
          'if (width == null || height == null) { res = PixelSnapSize(child:res); }');
    }
    if (c.className == 'ImageIcon') {
      _buffer.writeln('if (size == null) { res = PixelSnapSize(child:res); }');
    }
    _buffer.writeln('return res;');
    _buffer.writeln('}');

    _buffer.writeln('}');
  }

  final _buffer = StringBuffer();
  final List<Class> _classes;
}

void generate({
  required String inputFile,
  required String outputPath,
}) async {
  final parser = Parser(inputFile);
  final classes = await parser.parse();

  final widgets = Generator(classes).generateWidgets();
  final material = Generator(classes).generatePackage('material');
  final cupertino = Generator(classes).generatePackage('cupertino');

  final formatter = DartFormatter();

  File(path.join(outputPath, 'widgets.dart'))
      .writeAsStringSync(formatter.format(widgets));
  File(path.join(outputPath, 'material.dart'))
      .writeAsStringSync(formatter.format(material));
  File(path.join(outputPath, 'cupertino.dart'))
      .writeAsStringSync(formatter.format(cupertino));
}
