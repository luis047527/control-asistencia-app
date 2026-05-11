import 'package:flutter/material.dart';

import '../../services/attendance_service.dart';
import '../../services/session_service.dart';
import '../shared/app_shell.dart';
import '../shared/design_bottom_nav.dart';

const int _requiredMinutesPerDay = 8 * 60;

enum _HistoryFilter { today, week, month, custom }

enum _HistoryStatus {
  completed,
  working,
  late,
  missing,
  permission,
  vacation,
  incomplete,
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  _HistoryFilter _filter = _HistoryFilter.week;
  DateTime _anchorDate = DateTime.now();
  DateTimeRange? _customRange;
  List<_HistoryRecord> _records = [];
  _HistorySummary _summary = const _HistorySummary(
    workedMinutes: 0,
    requiredMinutes: 0,
  );
  bool _loading = false;

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTimeRange get _currentRange {
    final date = DateTime(_anchorDate.year, _anchorDate.month, _anchorDate.day);

    switch (_filter) {
      case _HistoryFilter.today:
        return DateTimeRange(start: date, end: date);
      case _HistoryFilter.week:
        final start = date.subtract(Duration(days: date.weekday - 1));
        return DateTimeRange(start: start, end: start.add(const Duration(days: 6)));
      case _HistoryFilter.month:
        return DateTimeRange(
          start: DateTime(date.year, date.month, 1),
          end: DateTime(date.year, date.month + 1, 0),
        );
      case _HistoryFilter.custom:
        return _customRange ?? DateTimeRange(start: date, end: date);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void reassemble() {
    super.reassemble();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final range = _currentRange;

    try {
      setState(() => _loading = true);

      final user = await SessionService.getUser();
      final userId = int.tryParse(user?["id"]?.toString() ?? '');

      if (user == null || userId == null) {
        if (!mounted) return;
        setState(() {
          _records = [];
          _summary = const _HistorySummary(workedMinutes: 0, requiredMinutes: 0);
          _loading = false;
        });
        return;
      }

      final response = await AttendanceService.getAttendanceHistory(
        userId: userId,
        startDate: _dateKey(range.start),
        endDate: _dateKey(range.end),
      );

      final rows = response["attendances"];
      final byDate = <String, Map<String, dynamic>>{};

      if (rows is List) {
        for (final item in rows) {
          if (item is! Map) continue;
          final row = Map<String, dynamic>.from(item);
          final date = row["attendance_date"]?.toString();
          if (date != null && date.isNotEmpty) {
            byDate[date] = row;
          }
        }
      }

      final records = _buildRecords(range, byDate);
      final summary = _buildSummary(range, byDate);

      if (!mounted || !_sameRange(range, _currentRange)) return;
      setState(() {
        _records = records;
        _summary = summary;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo cargar el historial'),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  List<_HistoryRecord> _buildRecords(
    DateTimeRange range,
    Map<String, Map<String, dynamic>> byDate,
  ) {
    final records = <_HistoryRecord>[];
    final today = _today;

    for (var date = range.end;
        !date.isBefore(range.start);
        date = date.subtract(const Duration(days: 1))) {
      final normalizedDate = DateTime(date.year, date.month, date.day);
      if (normalizedDate.isAfter(today)) continue;

      final row = byDate[_dateKey(normalizedDate)];
      if (row != null) {
        records.add(_HistoryRecord.fromAttendance(normalizedDate, row));
        continue;
      }

      if (normalizedDate.weekday != DateTime.sunday &&
          normalizedDate.isBefore(today)) {
        records.add(_HistoryRecord.missing(normalizedDate));
      }
    }

    return records;
  }

  _HistorySummary _buildSummary(
    DateTimeRange range,
    Map<String, Map<String, dynamic>> byDate,
  ) {
    var workedMinutes = 0;
    var requiredDays = 0;
    final today = _today;

    for (var date = range.start;
        !date.isAfter(range.end);
        date = date.add(const Duration(days: 1))) {
      final normalizedDate = DateTime(date.year, date.month, date.day);
      if (normalizedDate.isAfter(today)) continue;
      if (normalizedDate.weekday == DateTime.sunday) continue;

      requiredDays++;
      final row = byDate[_dateKey(normalizedDate)];
      if (row != null) {
        workedMinutes += _workedMinutesFromRow(row);
      }
    }

    return _HistorySummary(
      workedMinutes: workedMinutes,
      requiredMinutes: requiredDays * _requiredMinutesPerDay,
    );
  }

  void _selectFilter(_HistoryFilter filter) async {
    if (filter == _HistoryFilter.custom) {
      final picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2020),
        lastDate: _today,
        initialDateRange: _safeInitialRange(_customRange ?? _currentRange),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: AppColors.brown,
                    onPrimary: Colors.white,
                  ),
            ),
            child: child!,
          );
        },
      );

      if (picked == null) return;
      setState(() {
        _filter = filter;
        _customRange = picked;
        _anchorDate = picked.start;
      });
      await _loadHistory();
      return;
    }

    setState(() => _filter = filter);
    await _loadHistory();
  }

  void _movePeriod(int direction) {
    setState(() {
      switch (_filter) {
        case _HistoryFilter.today:
          _anchorDate = _anchorDate.add(Duration(days: direction));
          break;
        case _HistoryFilter.week:
          _anchorDate = _anchorDate.add(Duration(days: direction * 7));
          break;
        case _HistoryFilter.month:
          _anchorDate = DateTime(
            _anchorDate.year,
            _anchorDate.month + direction,
            1,
          );
          break;
        case _HistoryFilter.custom:
          final range = _currentRange;
          final days = range.duration.inDays + 1;
          final shifted = DateTimeRange(
            start: range.start.add(Duration(days: direction * days)),
            end: range.end.add(Duration(days: direction * days)),
          );
          _customRange = shifted;
          _anchorDate = shifted.start;
          break;
      }
    });
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    final range = _currentRange;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF7),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.page,
                14,
                AppSpacing.page,
                0,
              ),
              child: _Header(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page,
                  0,
                  AppSpacing.page,
                  AppSpacing.bottomPadding,
                ),
                children: [
                  _ShellCard(
                    child: Column(
                      children: [
                        _Tabs(
                          selected: _filter,
                          onChanged: _selectFilter,
                        ),
                        const SizedBox(height: 16),
                        _PeriodSelector(
                          label: _periodLabel(range),
                          onPrevious: () => _movePeriod(-1),
                          onNext: () => _movePeriod(1),
                        ),
                        if (_loading) ...[
                          const SizedBox(height: 12),
                          const LinearProgressIndicator(
                            minHeight: 2,
                            color: AppColors.brown,
                            backgroundColor: Color(0xFFF3E6DD),
                          ),
                        ],
                        const SizedBox(height: 14),
                        if (_records.isEmpty && !_loading)
                          const _EmptyHistoryCard()
                        else
                          ..._records.map((record) => _RecordCard(record: record)),
                        const SizedBox(height: 8),
                        _PeriodSummary(
                          rangeLabel: _summaryRangeLabel(range),
                          summary: _summary,
                        ),
                        const SizedBox(height: 16),
                        const _CorrectionCard(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const DesignBottomNav(activeIndex: 1),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Historial',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBrown,
            ),
          ),
        ),
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.brown.withOpacity(0.08),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.filter_alt_outlined,
            color: AppColors.brown,
          ),
        ),
      ],
    );
  }
}

class _ShellCard extends StatelessWidget {
  final Widget child;

  const _ShellCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.brown.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _Tabs extends StatelessWidget {
  final _HistoryFilter selected;
  final ValueChanged<_HistoryFilter> onChanged;

  const _Tabs({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TabItem(
            label: 'Hoy',
            selected: selected == _HistoryFilter.today,
            onTap: () => onChanged(_HistoryFilter.today),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _TabItem(
            label: 'Semana',
            selected: selected == _HistoryFilter.week,
            onTap: () => onChanged(_HistoryFilter.week),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _TabItem(
            label: 'Mes',
            selected: selected == _HistoryFilter.month,
            onTap: () => onChanged(_HistoryFilter.month),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _TabItem(
            label: 'Personalizado',
            trailing: Icons.calendar_month_outlined,
            selected: selected == _HistoryFilter.custom,
            onTap: () => onChanged(_HistoryFilter.custom),
          ),
        ),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool selected;
  final IconData? trailing;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.onTap,
    this.selected = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  colors: [Color(0xFF6F3A28), Color(0xFF9B5B3D)],
                )
              : null,
          color: selected ? null : const Color(0xFFFBF5F1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.darkBrown,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 5),
              Icon(
                trailing,
                size: 18,
                color: selected ? Colors.white : AppColors.brown,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  final String label;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _PeriodSelector({
    required this.label,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF5F1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_month_outlined, color: AppColors.brown),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, color: AppColors.darkBrown),
            ),
          ),
          IconButton(
            onPressed: onPrevious,
            icon: const Icon(Icons.chevron_left, color: AppColors.darkBrown),
          ),
          IconButton(
            onPressed: onNext,
            icon: const Icon(Icons.chevron_right, color: AppColors.darkBrown),
          ),
        ],
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  final _HistoryRecord record;

  const _RecordCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEDFD8)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${record.day} - ${record.date}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _StatusBadge(record: record),
              const Icon(Icons.chevron_right, color: Colors.black54, size: 22),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _TimeColumn(
                  icon: Icons.schedule,
                  iconColor: AppColors.green,
                  label: 'Entrada',
                  value: record.entry,
                ),
              ),
              Expanded(
                child: _TimeColumn(
                  icon: Icons.schedule,
                  iconColor: AppColors.red,
                  label: 'Salida',
                  value: record.exit,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 12, color: AppColors.muted),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      record.total,
                      style: TextStyle(
                        color: record.highlightTotal
                            ? AppColors.brown
                            : Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeColumn extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _TimeColumn({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final _HistoryRecord record;

  const _StatusBadge({required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: record.statusBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(record.statusIcon, color: record.statusColor, size: 17),
          const SizedBox(width: 5),
          Text(
            record.statusLabel,
            style: TextStyle(
              color: record.statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHistoryCard extends StatelessWidget {
  const _EmptyHistoryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEDFD8)),
      ),
      child: const Row(
        children: [
          Icon(Icons.history, color: AppColors.muted),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'No hay registros para este periodo',
              style: TextStyle(color: AppColors.muted),
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodSummary extends StatelessWidget {
  final String rangeLabel;
  final _HistorySummary summary;

  const _PeriodSummary({
    required this.rangeLabel,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final balance = summary.balanceMinutes;
    final balanceColor = balance >= 0 ? AppColors.green : AppColors.red;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen del periodo',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(rangeLabel, style: const TextStyle(color: AppColors.muted)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _SummaryBox(
                  icon: Icons.schedule,
                  iconColor: AppColors.green,
                  label: 'Trabajadas',
                  value: _formatDuration(summary.workedMinutes),
                ),
              ),
              Expanded(
                child: _SummaryBox(
                  icon: Icons.history,
                  iconColor: const Color(0xFFE27A22),
                  label: 'Requeridas',
                  value: _formatDuration(summary.requiredMinutes),
                ),
              ),
              Expanded(
                child: _SummaryBox(
                  icon: Icons.trending_up,
                  iconColor: balanceColor,
                  label: 'Balance',
                  value: _formatDuration(balance, showSign: true),
                  valueColor: balanceColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryBox extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryBox({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 28),
        const SizedBox(height: 10),
        Text(label, textAlign: TextAlign.center),
        const SizedBox(height: 7),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _CorrectionCard extends StatelessWidget {
  const _CorrectionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Color(0xFFFFE2D1),
            child: Icon(Icons.lightbulb_outline, color: AppColors.brown),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ves un error en tus registros?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  'Comunicate con tu administrador para solicitar una correccion.',
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.darkBrown),
        ],
      ),
    );
  }
}

class _HistorySummary {
  final int workedMinutes;
  final int requiredMinutes;

  const _HistorySummary({
    required this.workedMinutes,
    required this.requiredMinutes,
  });

  int get balanceMinutes => workedMinutes - requiredMinutes;
}

class _HistoryRecord {
  final DateTime recordDate;
  final String entry;
  final String exit;
  final String total;
  final _HistoryStatus status;
  final bool highlightTotal;

  const _HistoryRecord({
    required this.recordDate,
    required this.entry,
    required this.exit,
    required this.total,
    required this.status,
    this.highlightTotal = false,
  });

  factory _HistoryRecord.fromAttendance(
    DateTime date,
    Map<String, dynamic> row,
  ) {
    final status = _statusFromRow(row);
    final workedMinutes = _workedMinutesFromRow(row);

    return _HistoryRecord(
      recordDate: date,
      entry: _formatBackendTime(row["check_in"]),
      exit: _formatBackendTime(row["check_out"]),
      total: _formatDuration(workedMinutes),
      status: status,
      highlightTotal: workedMinutes >= _requiredMinutesPerDay,
    );
  }

  factory _HistoryRecord.missing(DateTime date) {
    return _HistoryRecord(
      recordDate: date,
      entry: '--:--',
      exit: '--:--',
      total: '00h 00m',
      status: _HistoryStatus.missing,
    );
  }

  String get day => _weekdayName(recordDate);

  String get dateLabel => _shortDateLabel(recordDate);

  String get statusLabel {
    switch (status) {
      case _HistoryStatus.completed:
        return 'Completo';
      case _HistoryStatus.working:
        return 'En jornada';
      case _HistoryStatus.late:
        return 'Tardanza';
      case _HistoryStatus.missing:
        return 'Sin registro';
      case _HistoryStatus.permission:
        return 'Permiso';
      case _HistoryStatus.vacation:
        return 'Vacaciones';
      case _HistoryStatus.incomplete:
        return 'Incompleto';
    }
  }

  String get date => dateLabel;

  Color get statusColor {
    switch (status) {
      case _HistoryStatus.completed:
        return AppColors.green;
      case _HistoryStatus.working:
        return AppColors.brown;
      case _HistoryStatus.late:
      case _HistoryStatus.incomplete:
        return const Color(0xFFE27A22);
      case _HistoryStatus.missing:
        return Colors.black54;
      case _HistoryStatus.permission:
        return const Color(0xFF8E5DCC);
      case _HistoryStatus.vacation:
        return const Color(0xFF3D7DFF);
    }
  }

  Color get statusBg {
    switch (status) {
      case _HistoryStatus.completed:
        return const Color(0xFFE8F5E9);
      case _HistoryStatus.working:
        return const Color(0xFFFFF1DF);
      case _HistoryStatus.late:
      case _HistoryStatus.incomplete:
        return const Color(0xFFFFF1DF);
      case _HistoryStatus.missing:
        return const Color(0xFFF0ECEB);
      case _HistoryStatus.permission:
        return const Color(0xFFF0E8FF);
      case _HistoryStatus.vacation:
        return const Color(0xFFE9F0FF);
    }
  }

  IconData get statusIcon {
    switch (status) {
      case _HistoryStatus.completed:
        return Icons.check_circle_outline;
      case _HistoryStatus.working:
        return Icons.work_history_outlined;
      case _HistoryStatus.late:
        return Icons.error_outline;
      case _HistoryStatus.missing:
        return Icons.remove_circle_outline;
      case _HistoryStatus.permission:
        return Icons.event_available;
      case _HistoryStatus.vacation:
        return Icons.beach_access;
      case _HistoryStatus.incomplete:
        return Icons.schedule;
    }
  }
}

_HistoryStatus _statusFromRow(Map<String, dynamic> row) {
  final status = row["status"]?.toString().toLowerCase().trim();
  final hasCheckIn = _hasValue(row["check_in"]);
  final hasCheckOut = _hasValue(row["check_out"]);

  switch (status) {
    case 'completed':
    case 'complete':
      return _HistoryStatus.completed;
    case 'working':
    case 'in_progress':
    case 'in progress':
      return _HistoryStatus.working;
    case 'late':
    case 'tardanza':
      return _HistoryStatus.late;
    case 'missing':
    case 'falta':
      return _HistoryStatus.missing;
    case 'permission':
    case 'permiso':
      return _HistoryStatus.permission;
    case 'vacation':
    case 'vacaciones':
      return _HistoryStatus.vacation;
    case 'incomplete':
    case 'incompleto':
      return _HistoryStatus.incomplete;
    default:
      if (hasCheckIn && hasCheckOut) return _HistoryStatus.completed;
      if (hasCheckIn) return _HistoryStatus.working;
      return _HistoryStatus.missing;
  }
}

bool _hasValue(dynamic value) {
  if (value == null) return false;
  if (value is String) return value.trim().isNotEmpty;
  return true;
}

int _workedMinutesFromRow(Map<String, dynamic> row) {
  final rawMinutes = row["worked_minutes"];
  final storedMinutes = rawMinutes is int
      ? rawMinutes
      : rawMinutes is num
          ? rawMinutes.toInt()
          : int.tryParse(rawMinutes?.toString() ?? '') ?? 0;

  if (storedMinutes > 0) return storedMinutes;

  final checkIn = _parseBackendDateTime(row["check_in"]);
  final checkOut = _parseBackendDateTime(row["check_out"]);
  if (checkIn == null || checkOut == null) return 0;

  return checkOut.difference(checkIn).inMinutes;
}

DateTime? _parseBackendDateTime(dynamic value) {
  if (!_hasValue(value)) return null;
  return DateTime.tryParse(value.toString().trim().replaceFirst(' ', 'T'));
}

String _formatBackendTime(dynamic value) {
  final date = _parseBackendDateTime(value);
  if (date == null) return '--:--';
  final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
  final minute = date.minute.toString().padLeft(2, '0');
  final period = date.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $period';
}

String _formatDuration(int minutes, {bool showSign = false}) {
  final sign = minutes < 0 ? '-' : (showSign && minutes > 0 ? '+' : '');
  final absolute = minutes.abs();
  final hours = absolute ~/ 60;
  final remainingMinutes = absolute % 60;
  return '$sign${hours.toString().padLeft(2, '0')}h '
      '${remainingMinutes.toString().padLeft(2, '0')}m';
}

String _dateKey(DateTime date) {
  return '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}

String _periodLabel(DateTimeRange range) {
  if (_isSameDay(range.start, range.end)) {
    return _longDateLabel(range.start);
  }

  return '${_longDateLabel(range.start)} - ${_longDateLabel(range.end)}';
}

String _summaryRangeLabel(DateTimeRange range) {
  if (_isSameDay(range.start, range.end)) {
    return '(${_shortDateLabel(range.start)})';
  }

  return '(${_shortDateLabel(range.start)} - ${_shortDateLabel(range.end)})';
}

bool _isSameDay(DateTime first, DateTime second) {
  return first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}

bool _sameRange(DateTimeRange first, DateTimeRange second) {
  return _isSameDay(first.start, second.start) &&
      _isSameDay(first.end, second.end);
}

DateTimeRange _safeInitialRange(DateTimeRange range) {
  final today = DateTime.now();
  final firstDate = DateTime(2020);
  final normalizedToday = DateTime(today.year, today.month, today.day);
  var start = range.start.isAfter(normalizedToday)
      ? normalizedToday
      : DateTime(range.start.year, range.start.month, range.start.day);
  var end = range.end.isAfter(normalizedToday)
      ? normalizedToday
      : DateTime(range.end.year, range.end.month, range.end.day);

  if (start.isBefore(firstDate)) start = firstDate;
  if (end.isBefore(firstDate)) end = firstDate;

  if (start.isAfter(end)) {
    return DateTimeRange(start: normalizedToday, end: normalizedToday);
  }

  return DateTimeRange(start: start, end: end);
}

String _longDateLabel(DateTime date) {
  return '${date.day} de ${_monthName(date.month)} de ${date.year}';
}

String _shortDateLabel(DateTime date) {
  return '${date.day} ${_shortMonthName(date.month)}';
}

String _weekdayName(DateTime date) {
  const weekdays = [
    'Lunes',
    'Martes',
    'Miercoles',
    'Jueves',
    'Viernes',
    'Sabado',
    'Domingo',
  ];

  return weekdays[date.weekday - 1];
}

String _monthName(int month) {
  const months = [
    '',
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];

  return months[month];
}

String _shortMonthName(int month) {
  const months = [
    '',
    'Ene',
    'Feb',
    'Mar',
    'Abr',
    'May',
    'Jun',
    'Jul',
    'Ago',
    'Sep',
    'Oct',
    'Nov',
    'Dic',
  ];

  return months[month];
}
