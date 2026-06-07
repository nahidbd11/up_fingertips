import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../widgets/common_widgets.dart';

/// Full-page view showing both the current project and the conflicting
/// past project side-by-side with all available details.
class DuplicateAlertDetailPage extends StatelessWidget {
  final DuplicateAlert alert;
  const DuplicateAlertDetailPage({super.key, required this.alert});

  // ── helpers ──────────────────────────────────────────────────

  /// Find the new/current project in mockProjects by ward + name similarity.
  Project? get _newProject {
    final words = alert.newProjectName.toLowerCase().split(' ').take(2).toList();
    try {
      return mockProjects.firstWhere(
        (p) =>
            p.ward == alert.ward &&
            words.any((w) => p.name.toLowerCase().contains(w)),
      );
    } catch (_) {
      return null;
    }
  }

  // ── build ─────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final p = _newProject;
    final isActive = !alert.resolved;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: isActive ? AppColors.error : AppColors.success,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Duplicate Alert',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: Colors.white),
            ),
            Text(
              alert.alertId,
              style: TextStyle(fontSize: 11.sp, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 12.w),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(30),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.white.withAlpha(60)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isActive ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                  color: Colors.white,
                  size: 14.sp,
                ),
                SizedBox(width: 5.w),
                Text(
                  isActive ? 'Active Alert' : 'Resolved',
                  style: TextStyle(fontSize: 11.sp, color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // ── Alert Summary Card ──────────────────────────────
          _AlertSummaryCard(alert: alert),
          SizedBox(height: 14.h),

          // ── Map Placeholder ─────────────────────────────────
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.divider),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                MapPlaceholder(
                  label: '${alert.union} — ${alert.ward}',
                  showCircle: true,
                  height: 200,
                ),
                // Legend overlay
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(230),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Map Legend', style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        SizedBox(height: 5.h),
                        _LegendDot(color: AppColors.primary, label: 'Current Project'),
                        SizedBox(height: 3.h),
                        _LegendDot(color: AppColors.error, label: 'Conflicting Project'),
                        SizedBox(height: 3.h),
                        _LegendDot(color: AppColors.warning, label: '${alert.distance} apart'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),

          // ── Section label ───────────────────────────────────
          _ComparisonLabel(),
          SizedBox(height: 12.h),

          // ── Current / New Project Card ──────────────────────
          _ProjectDetailCard(
            tag: 'CURRENT PROJECT',
            tagColor: AppColors.primary,
            tagBg: AppColors.primary.withAlpha(15),
            borderColor: AppColors.primary.withAlpha(80),
            icon: Icons.add_circle_outline,
            projectName: alert.newProjectName,
            location: alert.newLocation,
            alert: alert,
            project: p,
            isNew: true,
          ),
          SizedBox(height: 12.h),

          // ── Divider with distance ───────────────────────────
          Row(
            children: [
              Expanded(child: Divider(color: AppColors.divider, thickness: 1.h)),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12.w),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: AppColors.error.withAlpha(80)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.straighten, size: 14.sp, color: AppColors.error),
                    SizedBox(width: 5.w),
                    Text(
                      '${alert.distance} apart',
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: AppColors.error),
                    ),
                  ],
                ),
              ),
              Expanded(child: Divider(color: AppColors.divider, thickness: 1.h)),
            ],
          ),
          SizedBox(height: 12.h),

          // ── Conflicting Past Project Card ───────────────────
          _ProjectDetailCard(
            tag: 'CONFLICTING PAST PROJECT',
            tagColor: AppColors.error,
            tagBg: AppColors.errorLight,
            borderColor: AppColors.error.withAlpha(80),
            icon: Icons.history,
            projectName: alert.conflictingProjectName,
            location: '${alert.union} • ${alert.ward}',
            alert: alert,
            project: p, // same project data, shown as historical
            isNew: false,
          ),
          SizedBox(height: 14.h),

          // ── Comparison Table ────────────────────────────────
          _ComparisonTable(alert: alert, project: p),
          SizedBox(height: 14.h),

          // ── Action buttons ──────────────────────────────────
          if (isActive) ...[
            _ActionButtons(alert: alert),
            SizedBox(height: 8.h),
          ] else ...[
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.success.withAlpha(60)),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline, color: AppColors.success, size: 20.sp),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Alert Resolved', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: AppColors.success)),
                        Text('This duplicate alert has been reviewed and resolved.', style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
          ],
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

// ─── ALERT SUMMARY CARD ───────────────────────────────────────

class _AlertSummaryCard extends StatelessWidget {
  final DuplicateAlert alert;
  const _AlertSummaryCard({required this.alert});

  @override
  Widget build(BuildContext context) {
    final isActive = !alert.resolved;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: isActive ? AppColors.error.withAlpha(60) : AppColors.success.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isActive ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                color: isActive ? AppColors.error : AppColors.success,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Alert Summary',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              Text(
                '  সতর্কতার সারসংক্ষেপ',
                style: TextStyle(fontSize: 11.sp, color: AppColors.textHint),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _SummaryRow(label: 'Alert ID', value: alert.alertId),
          _SummaryRow(label: 'Status', value: isActive ? 'Active — Needs Review' : 'Resolved'),
          _SummaryRow(label: 'Union', value: alert.union),
          _SummaryRow(label: 'Ward', value: alert.ward),
          _SummaryRow(label: 'Distance', value: alert.distance),
          _SummaryRow(
            label: 'Conflict Type',
            value: 'Same type project within 500m radius',
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label, value;
  final bool isLast;
  const _SummaryRow({required this.label, required this.value, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90.w,
            child: Text(label, style: TextStyle(fontSize: 12.sp, color: AppColors.textHint, fontWeight: FontWeight.w500)),
          ),
          Text('  :  ', style: TextStyle(fontSize: 12.sp, color: AppColors.divider)),
          Expanded(
            child: Text(value, style: TextStyle(fontSize: 12.sp, color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// ─── COMPARISON LABEL ─────────────────────────────────────────

class _ComparisonLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 4.w, height: 20.h, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2.r))),
        SizedBox(width: 8.w),
        Text('Project Comparison', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        Text('  প্রকল্প তুলনা', style: TextStyle(fontSize: 11.sp, color: AppColors.textHint)),
      ],
    );
  }
}

// ─── PROJECT DETAIL CARD ──────────────────────────────────────

class _ProjectDetailCard extends StatelessWidget {
  final String tag, projectName, location;
  final Color tagColor, tagBg, borderColor;
  final IconData icon;
  final DuplicateAlert alert;
  final Project? project;
  final bool isNew;

  const _ProjectDetailCard({
    required this.tag,
    required this.tagColor,
    required this.tagBg,
    required this.borderColor,
    required this.icon,
    required this.projectName,
    required this.location,
    required this.alert,
    required this.project,
    required this.isNew,
  });

  @override
  Widget build(BuildContext context) {
    final p = project;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor, width: 1.5.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tag header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: tagBg,
              borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
            ),
            child: Row(
              children: [
                Icon(icon, color: tagColor, size: 16.sp),
                SizedBox(width: 8.w),
                Text(
                  tag,
                  style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w800, color: tagColor, letterSpacing: 0.5),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project name
                Text(
                  isNew ? projectName : (p?.name ?? projectName),
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                SizedBox(height: 4.h),
                Text(location, style: TextStyle(fontSize: 11.sp, color: AppColors.textHint)),
                SizedBox(height: 12.h),

                if (isNew && p != null) ...[
                  // Full project details from mockProjects
                  _DetailRow(label: 'Project ID', value: p.id),
                  _DetailRow(label: 'Type', value: p.type.name),
                  _DetailRow(label: 'Status', valueWidget: StatusBadge(status: p.status, compact: true)),
                  _DetailRow(label: 'District', value: p.district),
                  _DetailRow(label: 'Upazila', value: p.upazila),
                  _DetailRow(label: 'Union', value: p.union),
                  _DetailRow(label: 'UP Code', value: p.upCode),
                  _DetailRow(label: 'Ward', value: p.ward),
                  _DetailRow(label: 'Cost', value: '৳ ${p.costBDT.toStringAsFixed(0)}'),
                  _DetailRow(label: 'Start Date', value: p.startDate),
                  _DetailRow(label: 'Year', value: p.financialYear),
                  _DetailRow(label: 'Created By', value: p.createdByEngineer, isLast: true),
                ] else if (!isNew && p != null) ...[
                  // Historical project shown as a past project
                  _DetailRow(label: 'Project ID', value: 'PM-2023-HIST-001'),
                  _DetailRow(label: 'Type', value: p.type.name),
                  _DetailRow(label: 'Status', valueWidget: _HistoricalBadge()),
                  _DetailRow(label: 'District', value: p.district),
                  _DetailRow(label: 'Upazila', value: p.upazila),
                  _DetailRow(label: 'Union', value: alert.union),
                  _DetailRow(label: 'Ward', value: alert.ward),
                  _DetailRow(label: 'Recorded Date', value: alert.conflictingDate),
                  _DetailRow(label: 'Distance', value: '${alert.distance} from current project', isLast: true),
                ] else ...[
                  // Fallback — show only alert data
                  _DetailRow(label: 'Location', value: location),
                  _DetailRow(label: 'Ward', value: alert.ward),
                  _DetailRow(label: 'Union', value: alert.union),
                  if (!isNew) _DetailRow(label: 'Date', value: alert.conflictingDate, isLast: true)
                  else _DetailRow(label: 'Distance', value: alert.distance, isLast: true),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? valueWidget;
  final bool isLast;
  const _DetailRow({required this.label, this.value, this.valueWidget, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 88.w,
            child: Text(label, style: TextStyle(fontSize: 11.sp, color: AppColors.textHint, fontWeight: FontWeight.w500)),
          ),
          Text('  :  ', style: TextStyle(fontSize: 11.sp, color: AppColors.divider)),
          Expanded(
            child: valueWidget ??
                Text(
                  value ?? '—',
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                ),
          ),
        ],
      ),
    );
  }
}

class _HistoricalBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.textHint.withAlpha(20),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        'Historical Record',
        style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: AppColors.textHint),
      ),
    );
  }
}

// ─── COMPARISON TABLE ─────────────────────────────────────────

class _ComparisonTable extends StatelessWidget {
  final DuplicateAlert alert;
  final Project? project;
  const _ComparisonTable({required this.alert, required this.project});

  @override
  Widget build(BuildContext context) {
    final p = project;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 8.h),
            child: Row(
              children: [
                Icon(Icons.compare_arrows, color: AppColors.primary, size: 16.sp),
                SizedBox(width: 8.w),
                Text('Side-by-Side Comparison', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              ],
            ),
          ),
          const Divider(height: 1),
          // Table header
          _TableRow(isHeader: true, label: 'Field', left: 'Current Project', right: 'Conflicting Project'),
          const Divider(height: 1),
          _TableRow(label: 'Name', left: alert.newProjectName, right: alert.conflictingProjectName),
          _TableRow(label: 'Ward', left: alert.ward, right: alert.ward, highlight: true),
          _TableRow(label: 'Union', left: alert.union, right: alert.union, highlight: true),
          _TableRow(
            label: 'Type',
            left: p?.type.name ?? '—',
            right: p?.type.name ?? '—',
            highlight: true,
          ),
          _TableRow(
            label: 'Status',
            left: p != null ? _statusLabel(p.status) : '—',
            right: 'Historical',
          ),
          _TableRow(label: 'Date', left: p?.startDate ?? '—', right: alert.conflictingDate),
          _TableRow(label: 'Distance', left: '—', right: alert.distance, isLast: true),
        ],
      ),
    );
  }

  String _statusLabel(ProjectStatus s) {
    switch (s) {
      case ProjectStatus.upcoming: return 'Upcoming';
      case ProjectStatus.ongoing: return 'Ongoing';
      case ProjectStatus.completed: return 'Completed';
      case ProjectStatus.awaitingApproval: return 'Awaiting';
      default: return 'Unknown';
    }
  }
}

class _TableRow extends StatelessWidget {
  final String label, left, right;
  final bool isHeader, highlight, isLast;
  const _TableRow({
    required this.label,
    required this.left,
    required this.right,
    this.isHeader = false,
    this.highlight = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isHeader
        ? AppColors.primary.withAlpha(12)
        : highlight
            ? AppColors.errorLight.withAlpha(60)
            : Colors.transparent;
    return Container(
      color: bgColor,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
      child: Row(
        children: [
          SizedBox(
            width: 68.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: isHeader ? 11.sp : 11.sp,
                fontWeight: isHeader ? FontWeight.w700 : FontWeight.w500,
                color: isHeader ? AppColors.primary : AppColors.textHint,
              ),
            ),
          ),
          Container(width: 1, height: 18.h, color: AppColors.divider),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                left,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: isHeader ? FontWeight.w700 : FontWeight.w600,
                  color: isHeader ? AppColors.primary : AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(width: 1, height: 18.h, color: AppColors.divider),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                right,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: isHeader ? FontWeight.w700 : FontWeight.w600,
                  color: isHeader ? AppColors.error : AppColors.error.withAlpha(200),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── ACTION BUTTONS (active alerts only) ─────────────────────

class _ActionButtons extends StatelessWidget {
  final DuplicateAlert alert;
  const _ActionButtons({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                  title: Text('Mark as Resolved?', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700)),
                  content: Text(
                    'Confirm that "${alert.alertId}" has been reviewed and the projects are not actual duplicates.',
                    style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Row(children: [
                            const Icon(Icons.check_circle_outline, color: Colors.white, size: 16),
                            SizedBox(width: 8.w),
                            Text('${alert.alertId} marked as resolved.'),
                          ]),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                          duration: const Duration(seconds: 3),
                        ));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                      child: const Text('Mark Resolved', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(Icons.check_circle_outline, size: 18.sp),
            label: Text('Mark as Resolved', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700)),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              side: BorderSide(color: AppColors.success.withAlpha(120)),
              foregroundColor: AppColors.success,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── SMALL HELPERS ────────────────────────────────────────────

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8.w, height: 8.w, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        SizedBox(width: 5.w),
        Text(label, style: TextStyle(fontSize: 10.sp, color: AppColors.textSecondary)),
      ],
    );
  }
}
