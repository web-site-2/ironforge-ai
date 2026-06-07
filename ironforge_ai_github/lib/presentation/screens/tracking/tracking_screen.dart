// lib/presentation/screens/tracking/tracking_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/app_providers.dart';
import '../../widgets/common/gradient_button.dart';
import '../../../data/models/workout_model.dart';
import 'package:uuid/uuid.dart';

class TrackingScreen extends ConsumerStatefulWidget {
  const TrackingScreen({super.key});

  @override
  ConsumerState<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends ConsumerState<TrackingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('TRACKING'),
        backgroundColor: AppColors.background,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'HISTORY'),
            Tab(text: 'PROGRESS'),
            Tab(text: 'RECORDS'),
            Tab(text: 'BODY'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _HistoryTab(),
          _ProgressTab(),
          _RecordsTab(),
          _BodyTab(),
        ],
      ),
    );
  }
}

class _HistoryTab extends ConsumerWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(workoutLogsProvider);

    if (logs.isEmpty) {
      return const EmptyState(
        emoji: '📋',
        title: 'No workout history yet',
        subtitle: 'Complete your first workout to see it here.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _WorkoutHistoryCard(log: log)
              .animate(delay: Duration(milliseconds: index * 40))
              .fadeIn(),
        );
      },
    );
  }
}

class _WorkoutHistoryCard extends StatelessWidget {
  final WorkoutLogModel log;
  const _WorkoutHistoryCard({required this.log});

  @override
  Widget build(BuildContext context) {
    final duration = Duration(seconds: log.durationSeconds);
    final durationStr = duration.inHours > 0
        ? '${duration.inHours}h ${duration.inMinutes.remainder(60)}m'
        : '${duration.inMinutes}m';

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.fitness_center_rounded, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(log.workoutName, style: const TextStyle(
                      fontFamily: 'Rajdhani', fontSize: 17, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    )),
                    Text(DateFormat('EEE, MMM d · h:mm a').format(log.startTime),
                        style: const TextStyle(fontFamily: 'Exo2', fontSize: 12, color: AppColors.textTertiary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _LogStat(Icons.timer_outlined, durationStr, AppColors.primary),
              const SizedBox(width: 16),
              _LogStat(Icons.repeat_rounded, '${log.totalSets} sets', AppColors.secondary),
              const SizedBox(width: 16),
              _LogStat(Icons.fitness_center_rounded, '${(log.totalVolume / 1000).toStringAsFixed(1)}t', AppColors.warning),
            ],
          ),
          if (log.exercises.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6, runSpacing: 4,
              children: log.exercises.take(4).map((ex) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: AppColors.surfaceVariant,
                ),
                child: Text(ex.exerciseName, style: const TextStyle(
                  fontFamily: 'Exo2', fontSize: 10, color: AppColors.textTertiary,
                )),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _LogStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;
  const _LogStat(this.icon, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(value, style: TextStyle(fontFamily: 'Exo2', fontSize: 13, color: color, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _ProgressTab extends ConsumerWidget {
  const _ProgressTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(workoutLogsProvider);
    final measurements = ref.watch(bodyMeasurementsProvider);

    if (logs.isEmpty) {
      return const EmptyState(
        emoji: '📈',
        title: 'No data yet',
        subtitle: 'Complete workouts to see your progress charts.',
      );
    }

    // Weekly volume data
    final now = DateTime.now();
    final weeklyData = <String, double>{};
    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final key = DateFormat('E').format(day);
      weeklyData[key] = logs
          .where((l) =>
              l.startTime.year == day.year &&
              l.startTime.month == day.month &&
              l.startTime.day == day.day)
          .fold(0.0, (s, l) => s + l.totalVolume);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        // Weekly volume chart
        _ChartCard(
          title: 'Weekly Volume (kg)',
          child: SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                backgroundColor: Colors.transparent,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1000,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: AppColors.border.withOpacity(0.5), strokeWidth: 0.5,
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final keys = weeklyData.keys.toList();
                        if (value.toInt() < keys.length) {
                          return Text(keys[value.toInt()], style: const TextStyle(
                            fontFamily: 'Exo2', fontSize: 10, color: AppColors.textTertiary,
                          ));
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        value >= 1000 ? '${(value / 1000).toStringAsFixed(1)}k' : value.toInt().toString(),
                        style: const TextStyle(fontFamily: 'Exo2', fontSize: 9, color: AppColors.textTertiary),
                      ),
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                barGroups: weeklyData.values.toList().asMap().entries.map((e) => BarChartGroupData(
                  x: e.key,
                  barRods: [BarChartRodData(
                    toY: e.value,
                    color: e.value > 0 ? AppColors.primary : AppColors.border,
                    width: 20,
                    borderRadius: BorderRadius.circular(4),
                  )],
                )).toList(),
              ),
            ),
          ),
        ).animate().fadeIn(delay: 100.ms),

        const SizedBox(height: 16),

        // Workout frequency chart
        _ChartCard(
          title: 'Workouts per Week',
          child: SizedBox(
            height: 160,
            child: _WorkoutFrequencyChart(logs: logs),
          ),
        ).animate().fadeIn(delay: 200.ms),

        const SizedBox(height: 16),

        // Weight progress (if measurements exist)
        if (measurements.isNotEmpty)
          _ChartCard(
            title: 'Body Weight (kg)',
            child: SizedBox(
              height: 160,
              child: _WeightChart(measurements: measurements),
            ),
          ).animate().fadeIn(delay: 300.ms),
      ],
    );
  }
}

class _WorkoutFrequencyChart extends StatelessWidget {
  final List<WorkoutLogModel> logs;
  const _WorkoutFrequencyChart({required this.logs});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final data = <int, int>{};
    for (int i = 7; i >= 0; i--) {
      final weekStart = now.subtract(Duration(days: now.weekday - 1 + i * 7));
      final weekEnd = weekStart.add(const Duration(days: 7));
      data[i] = logs.where((l) => l.startTime.isAfter(weekStart) && l.startTime.isBefore(weekEnd)).length;
    }

    return LineChart(
      LineChartData(
        backgroundColor: Colors.transparent,
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        titlesData: const FlTitlesData(
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 24,
            getTitlesWidget: _leftTitle,
          )),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: data.entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
                .toList(),
            isCurved: true,
            color: AppColors.secondary,
            barWidth: 2.5,
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.secondary.withOpacity(0.1),
            ),
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
                radius: 4, color: AppColors.secondary,
                strokeWidth: 0, strokeColor: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _leftTitle(double value, TitleMeta meta) {
  return Text(value.toInt().toString(), style: const TextStyle(
    fontFamily: 'Exo2', fontSize: 10, color: AppColors.textTertiary,
  ));
}

class _WeightChart extends StatelessWidget {
  final List<dynamic> measurements;
  const _WeightChart({required this.measurements});

  @override
  Widget build(BuildContext context) {
    final spots = measurements.reversed.toList().asMap().entries
        .map((e) => FlSpot(e.key.toDouble(), (e.value.weightKg as double)))
        .toList();

    return LineChart(
      LineChartData(
        backgroundColor: Colors.transparent,
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true, drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(color: AppColors.border.withOpacity(0.5), strokeWidth: 0.5),
        ),
        titlesData: const FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(
            showTitles: true, reservedSize: 32,
            getTitlesWidget: _leftTitle,
          )),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.primary,
            barWidth: 2.5,
            belowBarData: BarAreaData(
              show: true, color: AppColors.primary.withOpacity(0.1),
            ),
            dotData: FlDotData(
              show: true,
              getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                radius: 4, color: AppColors.primary,
                strokeWidth: 0, strokeColor: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _ChartCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(
            fontFamily: 'Rajdhani', fontSize: 16, fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          )),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _RecordsTab extends ConsumerWidget {
  const _RecordsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prs = ref.watch(personalRecordsProvider);

    if (prs.isEmpty) {
      return const EmptyState(
        emoji: '🏆',
        title: 'No personal records yet',
        subtitle: 'Complete workouts and set new PRs to see them here.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: prs.length,
      itemBuilder: (context, index) {
        final pr = prs[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GlassCard(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('🏆', style: TextStyle(fontSize: 22)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pr.exerciseName, style: const TextStyle(
                        fontFamily: 'Rajdhani', fontSize: 17, fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      )),
                      Text(DateFormat('MMM d, yyyy').format(pr.achievedAt),
                          style: const TextStyle(fontFamily: 'Exo2', fontSize: 11, color: AppColors.textTertiary)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${pr.weightKg}kg × ${pr.reps}', style: const TextStyle(
                      fontFamily: 'Rajdhani', fontSize: 18, fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    )),
                    Text('1RM ≈ ${pr.estimatedOneRM.toStringAsFixed(1)}kg', style: const TextStyle(
                      fontFamily: 'Exo2', fontSize: 11, color: AppColors.textTertiary,
                    )),
                  ],
                ),
              ],
            ),
          ).animate(delay: Duration(milliseconds: index * 40)).fadeIn(),
        );
      },
    );
  }
}

class _BodyTab extends ConsumerStatefulWidget {
  const _BodyTab();

  @override
  ConsumerState<_BodyTab> createState() => _BodyTabState();
}

class _BodyTabState extends ConsumerState<_BodyTab> {
  final _weightController = TextEditingController();
  final _chestController = TextEditingController();
  final _waistController = TextEditingController();
  final _hipsController = TextEditingController();
  final _armController = TextEditingController();
  final _thighController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _chestController.dispose();
    _waistController.dispose();
    _hipsController.dispose();
    _armController.dispose();
    _thighController.dispose();
    super.dispose();
  }

  Future<void> _addMeasurement() async {
    final weight = double.tryParse(_weightController.text);
    if (weight == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your weight')),
      );
      return;
    }

    final m = BodyMeasurementModel(
      id: const Uuid().v4(),
      date: DateTime.now(),
      weightKg: weight,
      chestCm: double.tryParse(_chestController.text),
      waistCm: double.tryParse(_waistController.text),
      hipsCm: double.tryParse(_hipsController.text),
      leftArmCm: double.tryParse(_armController.text),
      leftThighCm: double.tryParse(_thighController.text),
    );

    await ref.read(bodyMeasurementsProvider.notifier).addMeasurement(m);
    _weightController.clear();
    _chestController.clear();
    _waistController.clear();
    _hipsController.clear();
    _armController.clear();
    _thighController.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Measurements saved!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final measurements = ref.watch(bodyMeasurementsProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        // Add measurement form
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('LOG MEASUREMENTS', style: TextStyle(
                fontFamily: 'Rajdhani', fontSize: 16, fontWeight: FontWeight.w700,
                color: AppColors.textPrimary, letterSpacing: 1,
              )),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: _MeasurementField('Weight (kg) *', _weightController, isRequired: true)),
                  const SizedBox(width: 10),
                  Expanded(child: _MeasurementField('Chest (cm)', _chestController)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _MeasurementField('Waist (cm)', _waistController)),
                  const SizedBox(width: 10),
                  Expanded(child: _MeasurementField('Hips (cm)', _hipsController)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _MeasurementField('Arm (cm)', _armController)),
                  const SizedBox(width: 10),
                  Expanded(child: _MeasurementField('Thigh (cm)', _thighController)),
                ],
              ),
              const SizedBox(height: 14),
              GradientButton(
                onPressed: _addMeasurement,
                label: 'SAVE MEASUREMENTS',
                height: 44,
              ),
            ],
          ),
        ).animate().fadeIn(delay: 100.ms),

        const SizedBox(height: 20),

        if (measurements.isNotEmpty) ...[
          const SectionHeader(title: 'History'),
          const SizedBox(height: 12),
          ...measurements.take(10).asMap().entries.map((e) {
            final m = e.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GlassCard(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(DateFormat('MMM d, yyyy').format(m.date), style: const TextStyle(
                            fontFamily: 'Rajdhani', fontSize: 16, fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          )),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 10, runSpacing: 4,
                            children: [
                              if (m.chestCm != null) _MeasurementPill('Chest', m.chestCm!),
                              if (m.waistCm != null) _MeasurementPill('Waist', m.waistCm!),
                              if (m.hipsCm != null) _MeasurementPill('Hips', m.hipsCm!),
                              if (m.leftArmCm != null) _MeasurementPill('Arm', m.leftArmCm!),
                              if (m.leftThighCm != null) _MeasurementPill('Thigh', m.leftThighCm!),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text('${m.weightKg}', style: const TextStyle(
                      fontFamily: 'Rajdhani', fontSize: 28, fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    )),
                    const Text(' kg', style: TextStyle(
                      fontFamily: 'Exo2', fontSize: 12, color: AppColors.textTertiary,
                    )),
                  ],
                ),
              ).animate(delay: Duration(milliseconds: e.key * 40)).fadeIn(),
            );
          }),
        ],
      ],
    );
  }
}

class _MeasurementField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isRequired;

  const _MeasurementField(this.label, this.controller, {this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(color: AppColors.textPrimary, fontFamily: 'Exo2', fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontFamily: 'Exo2', fontSize: 12,
          color: isRequired ? AppColors.primary : AppColors.textTertiary,
        ),
      ),
    );
  }
}

class _MeasurementPill extends StatelessWidget {
  final String label;
  final double value;
  const _MeasurementPill(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Text('$label: ${value.toStringAsFixed(1)}cm', style: const TextStyle(
      fontFamily: 'Exo2', fontSize: 11, color: AppColors.textTertiary,
    ));
  }
}
