import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class MaterialSymbolsIcons {
  static final MaterialSymbolsIcons _instance =
      MaterialSymbolsIcons._internal();
  factory MaterialSymbolsIcons() => _instance;
  MaterialSymbolsIcons._internal();

  IconData get menu => Symbols.menu;
  IconData get navLeft => Symbols.chevron_left;
  IconData get navRight => Symbols.chevron_right;
}

final gIcons = MaterialSymbolsIcons();
