import 'package:flutter/material.dart';

class DynamicDimensions extends StatelessWidget {
  final bool withColumn;
  final Widget Function(double w, double h) renderWidget;
  final int? flex;

  DynamicDimensions(
      {required this.renderWidget, this.withColumn = true, this.flex});

  @override
  Widget build(BuildContext context) {
    return withColumn
        ? Column(
            children: [
              Expanded(
                flex: flex ?? 1,
                child: Row(
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return renderWidget(
                              constraints.maxWidth, constraints.maxHeight);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : Expanded(
            flex: flex ?? 1,
            child: Row(
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return renderWidget(
                          constraints.maxWidth, constraints.maxHeight);
                    },
                  ),
                ),
              ],
            ),
          );
  }
}
