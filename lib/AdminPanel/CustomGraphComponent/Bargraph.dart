import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Bargraph extends StatelessWidget {
  final List<String> labels;
  final List<List<double>> stackedData; // Each list is a dataset
  final List<Color>? colors;
  final List<String>? stackLabels;
  const Bargraph({
    Key? key,
    required this.labels,
    required this.stackedData,
    this.colors,
    this.stackLabels
  }) : super(key: key);

  bool isStacked(List<List<double>> data) {
    return data.any((d) => d.length > 1);
  }

  @override
  Widget build(BuildContext context) {
    if (stackedData.any((list) => list.length != labels.length)) {
      throw Exception("Each dataset in stackedData must have the same length as labels");
    }

    final defaultColors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
    ];

    final stacked = isStacked(stackedData);

    return
     Column(
       children: [
       SizedBox(
         width: labels.length * 60,
         height: 270,
         child: SingleChildScrollView(
           scrollDirection: Axis.horizontal,
           child: SizedBox(
             width: labels.length * 60,
             child: BarChart(
               BarChartData(
                 alignment: BarChartAlignment.spaceAround,
                 barTouchData: BarTouchData(
                   enabled: true,
                   touchTooltipData: BarTouchTooltipData(
                     tooltipPadding: const EdgeInsets.all(10),
                     tooltipMargin: 10,
                     fitInsideVertically: true,
                     fitInsideHorizontally: true,
                     getTooltipItem: (group, groupIndex, rod, rodIndex) {
                       final sectionNames = ["Male", "Female"]; // Or make this dynamic if more stacks

                       // Breakdown of each stack
                       String breakdown = '';
                       for (int i = 0; i < rod.rodStackItems.length; i++) {
                         final stack = rod.rodStackItems[i];
                         final value = (stack.toY - stack.fromY).toStringAsFixed(0);
                         final label = (i < sectionNames.length) ? sectionNames[i] : 'Data $i';
                         breakdown += '• $label: $value\n';
                       }

                       return BarTooltipItem(
                         '${labels[group.x]}\n$breakdown',
                         const TextStyle(
                           color: Colors.white,
                           fontWeight: FontWeight.bold,
                         ),
                       );
                     },
                   ),
                 ),
                 titlesData: FlTitlesData(
                   bottomTitles: AxisTitles(
                     sideTitles: SideTitles(
                       showTitles: true,
                       getTitlesWidget: (value, _) {
                         int index = value.toInt();
                         if (index >= 0 && index < labels.length) {
                           return Padding(
                             padding: const EdgeInsets.only(top: 8.0),
                             child: Text(
                               labels[index],
                               style: const TextStyle(fontSize: 12),
                             ),
                           );
                         }
                         return const SizedBox.shrink();
                       },
                     ),
                   ),
                   leftTitles: AxisTitles(
                     sideTitles: SideTitles(
                       showTitles: true,
                       reservedSize: 20,
                       getTitlesWidget: (value, _) => Text(
                         '${value.toInt()}',
                         style: const TextStyle(fontSize: 10),
                       ),
                     ),
                   ),
                   topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                   rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                 ),
                 barGroups: List.generate(labels.length, (index) {
                   if (stacked) {
                     double startY = 0;
                     final stackItems = <BarChartRodStackItem>[];

                     for (int i = 0; i < stackedData.length; i++) {
                       double value = stackedData[i][index];
                       stackItems.add(BarChartRodStackItem(
                         startY,
                         startY + value,
                         colors != null && i < colors!.length
                             ? colors![i]
                             : defaultColors[i % defaultColors.length],
                       ));
                       startY += value;
                     }

                     return BarChartGroupData(x: index, barRods: [
                       BarChartRodData(
                         toY: startY,
                         rodStackItems: stackItems,
                         width: 20,
                         borderRadius: const BorderRadius.only(
                           topLeft: Radius.circular(10),
                           topRight: Radius.circular(10),
                         ),
                       ),
                     ]);
                   } else {
                     return BarChartGroupData(
                       x: index,
                       barRods: List.generate(stackedData.length, (i) {
                         return BarChartRodData(
                           toY: stackedData[i][index],
                           width: 10,
                           color: colors != null && i < colors!.length
                               ? colors![i]
                               : defaultColors[i % defaultColors.length],
                           borderRadius: const BorderRadius.only(
                             topLeft: Radius.circular(4),
                             topRight: Radius.circular(4),
                           ),
                         );
                       }),
                       barsSpace: 4,
                     );
                   }
                 }),
                 gridData: FlGridData(show: false),
                 borderData: FlBorderData(show: false),
               ),
             ),
           ),
         ),
       ),


         if (stackLabels != null && stackLabels!.isNotEmpty)
           Padding(
             padding: const EdgeInsets.only(top: 12.0, left: 8),
             child: Wrap(
               spacing: 12,
               runSpacing: 8,
               children: List.generate(stackLabels!.length, (i) {
                 return Row(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     Container(
                       width: 14,
                       height: 14,
                       decoration: BoxDecoration(
                         color: colors != null && i < colors!.length
                             ? colors![i]
                             : defaultColors[i % defaultColors.length],
                         borderRadius: BorderRadius.circular(3),
                       ),
                     ),
                     const SizedBox(width: 6),
                     Text(
                       stackLabels![i],
                       style: const TextStyle(fontSize: 12),
                     ),
                   ],
                 );
               }),
             ),
           ),

       ],
     );

  }
}

