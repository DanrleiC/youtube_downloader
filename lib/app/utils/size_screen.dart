import 'package:flutter/material.dart';

class SizeScreen {
  /// Calcula a altura da tela com base em uma porcentagem fornecida.
  ///
  /// [percentage] é a porcentagem da altura da tela desejada, com valor padrão de 100.0
  static double sizeHeight (BuildContext context, {double percentage = 100.0}) => (_size(context).height * percentage);

  /// Calcula a largura da tela com base em uma porcentagem fornecida.
  ///
  /// [percentage] é a porcentagem da largura da tela desejada, com valor padrão de 100.0
  static double sizeWidth(BuildContext context, {double percentage = 100.0}) => (_size(context).width * percentage);

  static Size _size(BuildContext context) => MediaQuery.of(context).size;
}