import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Piechart extends StatefulWidget {
  final List<String> sections;
  final List<double> values;
  final List<Color>? colors;

  const Piechart({
    Key? key,
    required this.sections,
    required this.values,
    this.colors,
  }) : super(key: key);

  @override
  State<Piechart> createState() => _PiechartState();
}

class _PiechartState extends State<Piechart> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    final defaultColors = [
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
    ];

    if (widget.sections.length != widget.values.length) {
      throw Exception("Sections and values length must match.");
    }

    bool allZero = widget.values.every((v) => v == 0.0);
    if (allZero) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "No data available to display",
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

 // Debugging: Check if color list is passed

    // === Updated section list generation ===
    final List<PieChartSectionData> sections = [];

    for (int index = 0; index < widget.values.length; index++) {
      if (widget.values[index] == 0.0) continue;

      final color = (widget.colors != null && index < widget.colors!.length)
          ? widget.colors![index]
          : defaultColors[index % defaultColors.length];

      final isTouched = index == touchedIndex;

      sections.add(PieChartSectionData(
        value: widget.values[index],
        title: isTouched
            ? '${widget.sections[index]}\n(${widget.values[index].toStringAsFixed(0)})'
            : '',
        color: color,
        radius: isTouched ? 70 : 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    }

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = null;
                      return;
                    }
                    touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              sections: sections,
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: List.generate(widget.sections.length, (index) {
            if (widget.values[index] == 0.0) return const SizedBox();

            final color = (widget.colors != null && index < widget.colors!.length)
                ? widget.colors![index]
                : defaultColors[index % defaultColors.length];

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text('${widget.sections[index]} (${widget.values[index].toStringAsFixed(1)})'),
              ],
            );
          }),
        ),
      ],
    );
  }
}
