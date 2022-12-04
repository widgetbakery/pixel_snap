// ignore_for_file: avoid_print

import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:args/args.dart';
import 'package:pixel_perfect_generator/generator.dart';

void main(List<String> args) {
  final parser = ArgParser();
  parser.addOption(
    'input',
    abbr: 'i',
    help: 'Path to input file (widgets_in.dart)',
  );
  parser.addOption(
    'output',
    abbr: 'o',
    help: 'Folder for writing generated files',
  );
  final parsed = parser.parse(args);
  final input = parsed['input'] as String?;
  final output = parsed['output'] as String?;
  if (input == null || output == null) {
    print('Usage:\n${parser.usage}');
    exit(1);
  }
  final inputFile = path.normalize(path.absolute(input));
  final outputPath = path.normalize(path.absolute(output));

  if (File(inputFile).statSync().type != FileSystemEntityType.file) {
    print('Input file does not exist');
    exit(1);
  }

  if (File(outputPath).statSync().type != FileSystemEntityType.directory) {
    print('Output folder does not exist');
    exit(1);
  }

  print('Input: $inputFile');
  print('Output: $outputPath');
  generate(
    inputFile: inputFile,
    outputPath: outputPath,
  );
}
