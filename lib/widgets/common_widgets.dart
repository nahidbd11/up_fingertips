import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';

// ─── STAT CARD ───────────────────────────────────────────────

class StatCard extends StatelessWidget {
  final String label;
  final String banglalabel;
  final String value;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.label,
    required this.banglalabel,
    required this.value,
    required this.icon,
    required this.color,
    required this.bgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 175;
        final pad = compact ? 12.0.w : 16.0.w;
        final iconPad = compact ? 8.0.w : 10.0.w;
        final iconSize = compact ? 18.0.sp : 22.0.sp;
        final valueSize = compact ? 22.0.sp : 28.0.sp;
        final spacing = compact ? 8.0.h : 12.0.h;
        final labelSize = compact ? 11.0.sp : 13.0.sp;
        final banglaSize = compact ? 10.0.sp : 11.0.sp;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(pad),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.divider, width: 1),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 8.r,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(iconPad),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(icon, color: color, size: iconSize),
                    ),
                    Flexible(
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: valueSize,
                          fontWeight: FontWeight.w700,
                          color: color,
                          height: 1,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: labelSize,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  banglalabel,
                  style: TextStyle(fontSize: banglaSize, color: AppColors.textHint),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── STATUS BADGE ────────────────────────────────────────────

class StatusBadge extends StatelessWidget {
  final ProjectStatus status;
  final bool compact;

  const StatusBadge({super.key, required this.status, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final config = _statusConfig(status);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8.w : 10.w,
        vertical: compact ? 3.h : 5.h,
      ),
      decoration: BoxDecoration(
        color: config.bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(color: config.color, shape: BoxShape.circle),
          ),
          SizedBox(width: 5.w),
          Text(
            compact ? config.shortLabel : config.label,
            style: TextStyle(
              fontSize: compact ? 10.sp : 11.sp,
              fontWeight: FontWeight.w600,
              color: config.color,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _statusConfig(ProjectStatus s) {
    switch (s) {
      case ProjectStatus.upcoming:
        return _StatusConfig('Upcoming', 'আসন্ন', AppColors.statusUpcoming, AppColors.statusUpcomingBg, 'Upcoming');
      case ProjectStatus.ongoing:
        return _StatusConfig('Ongoing', 'চলমান', AppColors.statusOngoing, AppColors.statusOngoingBg, 'Ongoing');
      case ProjectStatus.awaitingApproval:
        return _StatusConfig('Awaiting Approval', 'অনুমোদনের অপেক্ষায়', AppColors.statusAwaiting, AppColors.statusAwaitingBg, 'Awaiting');
      case ProjectStatus.completed:
        return _StatusConfig('Completed', 'সম্পন্ন', AppColors.statusCompleted, AppColors.statusCompletedBg, 'Done');
      case ProjectStatus.revisionNeeded:
        return _StatusConfig('Revision Needed', 'সংশোধন প্রয়োজন', AppColors.statusRevision, AppColors.statusRevisionBg, 'Revision');
      case ProjectStatus.draft:
        return _StatusConfig('Draft', 'খসড়া', AppColors.statusDraft, AppColors.statusDraftBg, 'Draft');
    }
  }
}

class _StatusConfig {
  final String label;
  final String banglaLabel;
  final Color color;
  final Color bgColor;
  final String shortLabel;
  _StatusConfig(this.label, this.banglaLabel, this.color, this.bgColor, this.shortLabel);
}

// ─── PROJECT TYPE BADGE ──────────────────────────────────────

class TypeBadge extends StatelessWidget {
  final ProjectType type;
  const TypeBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withAlpha(25),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        _label(type),
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  String _label(ProjectType t) {
    switch (t) {
      case ProjectType.road: return 'Road • রাস্তা';
      case ProjectType.drainage: return 'Drainage • ড্রেন';
      case ProjectType.mosque: return 'Mosque • মসজিদ';
      case ProjectType.culvert: return 'Culvert • কালভার্ট';
      case ProjectType.earthwork: return 'Earthwork • মাটি কাজ';
      case ProjectType.other: return 'Other • অন্যান্য';
    }
  }
}

// ─── PROJECT LIST TILE ───────────────────────────────────────

class ProjectTile extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;
  final String? actionLabel;
  final Color? actionColor;

  const ProjectTile({
    super.key,
    required this.project,
    required this.onTap,
    this.actionLabel,
    this.actionColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(color: AppColors.cardShadow, blurRadius: 6.r, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.id,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.textHint,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        project.name,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                StatusBadge(status: project.status, compact: true),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 14.sp, color: AppColors.textHint),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    '${project.union} • ${project.ward}',
                    style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TypeBadge(type: project.type),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 13.sp, color: AppColors.textHint),
                SizedBox(width: 4.w),
                Text(
                  project.financialYear,
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                ),
                SizedBox(width: 12.w),
                Icon(Icons.monetization_on_outlined, size: 13.sp, color: AppColors.textHint),
                SizedBox(width: 4.w),
                Text(
                  '৳ ${_formatCost(project.costBDT)}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (actionLabel != null) ...[
              SizedBox(height: 10.h),
              const Divider(height: 1),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.arrow_forward_ios_rounded, size: 14.sp, color: AppColors.textHint),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: (actionColor ?? AppColors.primary).withAlpha(20),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      actionLabel!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: actionColor ?? AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatCost(double cost) {
    if (cost >= 100000) return '${(cost / 100000).toStringAsFixed(1)}L';
    return cost.toStringAsFixed(0);
  }
}

// ─── SECTION HEADER ──────────────────────────────────────────

class SectionHeader extends StatelessWidget {
  final String title;
  final String? banglaTitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.banglaTitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              if (banglaTitle != null)
                Text(
                  banglaTitle!,
                  style: TextStyle(fontSize: 11.sp, color: AppColors.textHint),
                ),
            ],
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

// ─── INFO ROW ────────────────────────────────────────────────

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final bool isLast;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16.sp, color: AppColors.textHint),
                SizedBox(width: 8.w),
              ],
              Flexible(
                flex: 4,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Flexible(
                flex: 6,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1),
      ],
    );
  }
}

// ─── CUSTOM APP BAR ──────────────────────────────────────────

class UPAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final List<Widget>? actions;
  final bool showNotification;
  final int notificationCount;
  final VoidCallback? onNotification;

  const UPAppBar({
    super.key,
    required this.title,
    required this.subtitle,
    this.actions,
    this.showNotification = true,
    this.notificationCount = 3,
    this.onNotification,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      titleSpacing: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w700),
          ),
          Text(
            subtitle,
            style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 11.sp, fontWeight: FontWeight.w400),
          ),
        ],
      ),
      actions: [
        if (showNotification)
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_outlined, color: Colors.white, size: 24.sp),
                onPressed: onNotification ?? () => _showNotificationPanel(context),
              ),
              if (notificationCount > 0)
                Positioned(
                  right: 8.w,
                  top: 8.h,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    constraints: BoxConstraints(minWidth: 18.w, minHeight: 18.w),
                    child: Text(
                      '$notificationCount',
                      style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ...?actions,
        SizedBox(width: 4.w),
      ],
    );
  }

  void _showNotificationPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const NotificationPanel(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// ─── NOTIFICATION PANEL ──────────────────────────────────────

class NotificationPanel extends StatelessWidget {
  const NotificationPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      _Notif('Road Repair Ward-3 marked as Finished', 'Awaiting your approval', Icons.check_circle_outline, AppColors.statusAwaiting, '2 hrs ago'),
      _Notif('New progress photos uploaded', 'Committee Member: Karim Uddin • Ward-3', Icons.photo_library_outlined, AppColors.primary, '5 hrs ago'),
      _Notif('Duplicate Alert Detected', 'Road Repair Near Bazar • Ward-3', Icons.warning_amber_outlined, AppColors.error, '1 day ago'),
    ];

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            SizedBox(height: 12.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2.r)),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Notifications', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700)),
                  Text('বিজ্ঞপ্তি', style: TextStyle(fontSize: 13.sp, color: AppColors.textHint)),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            const Divider(),
            Expanded(
              child: ListView.builder(
                controller: controller,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: notifications.length,
                itemBuilder: (_, i) => _NotifTile(notif: notifications[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Notif {
  final String title, subtitle, time;
  final IconData icon;
  final Color color;
  const _Notif(this.title, this.subtitle, this.icon, this.color, this.time);
}

class _NotifTile extends StatelessWidget {
  final _Notif notif;
  const _NotifTile({required this.notif});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: notif.color.withAlpha(12),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: notif.color.withAlpha(40)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(color: notif.color.withAlpha(25), shape: BoxShape.circle),
            child: Icon(notif.icon, color: notif.color, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notif.title, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                SizedBox(height: 3.h),
                Text(notif.subtitle, style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
                SizedBox(height: 4.h),
                Text(notif.time, style: TextStyle(fontSize: 11.sp, color: AppColors.textHint)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── DRAWER BUILDER ──────────────────────────────────────────

class UPDrawer extends StatelessWidget {
  final String roleName;
  final String roleNameBangla;
  final String userName;
  final String userID;
  final List<DrawerItem> items;
  final int selectedIndex;
  final void Function(int) onItemSelected;

  const UPDrawer({
    super.key,
    required this.roleName,
    required this.roleNameBangla,
    required this.userName,
    required this.userID,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20.h,
              left: 20.w,
              right: 20.w,
              bottom: 24.h,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryDark, AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(30),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withAlpha(80), width: 2.w),
                  ),
                  child: Icon(Icons.person_rounded, color: Colors.white, size: 30.sp),
                ),
                SizedBox(height: 12.h),
                Text(userName, style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w700)),
                SizedBox(height: 2.h),
                Text(userID, style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 12.sp)),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(30),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    '$roleName • $roleNameBangla',
                    style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final item = items[i];
                final selected = selectedIndex == i;
                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    onItemSelected(i);
                  },
                  borderRadius: BorderRadius.circular(12.r),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary.withAlpha(20) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Icon(item.icon, size: 22.sp, color: selected ? AppColors.primary : AppColors.grey),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.label,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                                  color: selected ? AppColors.primary : AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                item.banglaLabel,
                                style: TextStyle(fontSize: 10.sp, color: AppColors.textHint),
                              ),
                            ],
                          ),
                        ),
                        if (selected)
                          Container(
                            width: 4.w,
                            height: 36.h,
                            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2.r)),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.switch_account_outlined, color: AppColors.textSecondary, size: 22.sp),
            title: Text('Switch Role', style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
            },
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}

class DrawerItem {
  final String label;
  final String banglaLabel;
  final IconData icon;
  const DrawerItem(this.label, this.banglaLabel, this.icon);
}

// ─── INFO CARD ───────────────────────────────────────────────

class InfoCard extends StatelessWidget {
  final String title;
  final String? banglaTitle;
  final List<Widget> children;
  final Widget? trailing;

  const InfoCard({
    super.key,
    required this.title,
    this.banglaTitle,
    required this.children,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.divider),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 6.r, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      if (banglaTitle != null)
                        Text(banglaTitle!, style: TextStyle(fontSize: 11.sp, color: AppColors.textHint)),
                    ],
                  ),
                ),
                ?trailing,
              ],
            ),
          ),
          SizedBox(height: 8.h),
          const Divider(height: 1),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

// ─── UPLOAD AREA ─────────────────────────────────────────────

class UploadArea extends StatelessWidget {
  final String label;
  final String banglaLabel;
  final String hint;
  final IconData icon;
  final bool required;

  const UploadArea({
    super.key,
    required this.label,
    required this.banglaLabel,
    required this.hint,
    this.icon = Icons.cloud_upload_outlined,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            if (required) Text(' *', style: TextStyle(color: AppColors.error, fontSize: 13.sp, fontWeight: FontWeight.w700)),
            const Spacer(),
            Text(banglaLabel, style: TextStyle(fontSize: 11.sp, color: AppColors.textHint)),
          ],
        ),
        SizedBox(height: 8.h),
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 24.h),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary.withAlpha(80), width: 1.5, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(12.r),
              color: AppColors.primary.withAlpha(8),
            ),
            child: Column(
              children: [
                Icon(icon, color: AppColors.primary.withAlpha(180), size: 32.sp),
                SizedBox(height: 8.h),
                Text(hint, style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary), textAlign: TextAlign.center),
                SizedBox(height: 6.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text('Choose File • ফাইল বেছে নিন',
                      style: TextStyle(fontSize: 12.sp, color: AppColors.primary, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── FORM FIELD LABEL ────────────────────────────────────────

class FormFieldLabel extends StatelessWidget {
  final String label;
  final String banglaLabel;
  final bool required;

  const FormFieldLabel({
    super.key,
    required this.label,
    required this.banglaLabel,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          ),
          if (required) Text(' *', style: TextStyle(color: AppColors.error, fontSize: 13.sp, fontWeight: FontWeight.w700)),
          SizedBox(width: 8.w),
          Text(banglaLabel, style: TextStyle(fontSize: 11.sp, color: AppColors.textHint)),
        ],
      ),
    );
  }
}

// ─── PHOTO PHASE WIDGET ──────────────────────────────────────

class PhotoPhaseWidget extends StatefulWidget {
  final List<PhotoPhase> phases;
  final bool canUpload;
  final bool isVideo;
  const PhotoPhaseWidget({super.key, required this.phases, this.canUpload = false, this.isVideo = false});

  @override
  State<PhotoPhaseWidget> createState() => _PhotoPhaseWidgetState();
}

class _PhotoPhaseWidgetState extends State<PhotoPhaseWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.phases.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textHint,
          indicatorColor: AppColors.primary,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
          unselectedLabelStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
          tabAlignment: TabAlignment.start,
          tabs: widget.phases.map((p) => Tab(text: '${p.label}\n${p.banglaLabel}')).toList(),
        ),
        const Divider(height: 1),
        SizedBox(
          height: 180.h,
          child: TabBarView(
            controller: _tabController,
            children: widget.phases.map((phase) => _PhaseContent(phase: phase, canUpload: widget.canUpload, isVideo: widget.isVideo)).toList(),
          ),
        ),
      ],
    );
  }
}

class _PhaseContent extends StatelessWidget {
  final PhotoPhase phase;
  final bool canUpload;
  final bool isVideo;
  const _PhaseContent({required this.phase, required this.canUpload, this.isVideo = false});

  @override
  Widget build(BuildContext context) {
    if (phase.count == 0) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isVideo ? Icons.videocam_off_outlined : Icons.photo_library_outlined,
              size: 36.sp,
              color: AppColors.textHint,
            ),
            SizedBox(height: 8.h),
            Text(
              isVideo ? 'No videos yet' : 'No photos yet',
              style: TextStyle(color: AppColors.textHint, fontSize: 13.sp),
            ),
            if (canUpload) ...[
              SizedBox(height: 10.h),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(isVideo ? Icons.videocam_outlined : Icons.add_a_photo_outlined, size: 16.sp),
                label: Text(isVideo ? 'Record Video' : 'Upload Photos', style: TextStyle(fontSize: 13.sp)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                ),
              ),
            ],
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(12.w),
      scrollDirection: Axis.horizontal,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: phase.count,
      itemBuilder: (_, i) => ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          color: isVideo ? Colors.blueGrey.withAlpha(30) : AppColors.primary.withAlpha(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Icon(
                isVideo ? Icons.play_circle_outline_rounded : Icons.image_outlined,
                color: isVideo ? Colors.blueGrey : AppColors.primary,
                size: 32.sp,
              ),
              Positioned(
                bottom: 4,
                left: 4,
                right: 4,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(120),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    phase.lastUploadedBy,
                    style: TextStyle(color: Colors.white, fontSize: 8.sp),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── MAP PLACEHOLDER ─────────────────────────────────────────

class MapPlaceholder extends StatelessWidget {
  final double height;
  final String label;
  final bool showCircle;

  const MapPlaceholder({
    super.key,
    this.height = 220,
    this.label = 'Project Location',
    this.showCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFE8EFF5),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: _GoogleMapTileGrid()),
          if (showCircle)
            Center(
              child: Container(
                width: 140.w,
                height: 140.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withAlpha(20),
                  border: Border.all(color: AppColors.primary.withAlpha(100), width: 2),
                ),
              ),
            ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: AppColors.primary.withAlpha(80), blurRadius: 8.r)],
                  ),
                  child: Icon(Icons.location_on, color: Colors.white, size: 24.sp),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 4.r)],
                  ),
                  child: Text(label, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 8.h,
            right: 8.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(220),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text('© Google Maps', style: TextStyle(fontSize: 9.sp, color: AppColors.textHint)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── GOOGLE MAPS TILE GRID ────────────────────────────────────
// Renders a 3×2 grid of real Google Maps tiles for Fatullah,
// Narayanganj, Bangladesh (zoom 13 — centre tile x=6155, y=3543).
// Falls back to a plain grey fill if network is unavailable.

class _GoogleMapTileGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 3 columns × 2 rows of adjacent tiles around the project area
    const int zoom = 13;
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [6154, 6155, 6156]
                .map((x) => Expanded(child: _MapTile(x: x, y: 3542, zoom: zoom)))
                .toList(),
          ),
        ),
        Expanded(
          child: Row(
            children: [6154, 6155, 6156]
                .map((x) => Expanded(child: _MapTile(x: x, y: 3543, zoom: zoom)))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _MapTile extends StatelessWidget {
  final int x, y, zoom;
  const _MapTile({required this.x, required this.y, required this.zoom});

  @override
  Widget build(BuildContext context) {
    // Distribute requests across mt0–mt3 mirrors
    final server = (x + y) % 4;
    final url = 'https://mt$server.google.com/vt/lyrs=m&hl=en&x=$x&y=$y&z=$zoom';
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, _, _) =>
          Container(color: const Color(0xFFE0E8F0)),
      loadingBuilder: (_, child, progress) =>
          progress == null ? child : Container(color: const Color(0xFFE8EFF5)),
    );
  }
}

// ─── MAP PIN PICKER ──────────────────────────────────────────
// Interactive pin-on-map widget for geocoding. Tap anywhere to drop a pin
// and auto-generate mock coordinates relative to Fatullah Union centre.

class MapPinPicker extends StatefulWidget {
  final String label;
  final String banglaLabel;
  final bool required;
  final Color pinColor;

  const MapPinPicker({
    super.key,
    required this.label,
    required this.banglaLabel,
    this.required = false,
    this.pinColor = AppColors.primary,
  });

  @override
  State<MapPinPicker> createState() => _MapPinPickerState();
}

class _MapPinPickerState extends State<MapPinPicker> {
  Offset? _pinOffset;
  String? _lat;
  String? _lng;

  // Fatullah Union centre
  static const _baseLat = 23.6177;
  static const _baseLng = 90.5003;

  void _placePinAt(Offset localPos, Size mapSize) {
    final latDelta = (mapSize.height / 2 - localPos.dy) * 0.0001;
    final lngDelta = (localPos.dx - mapSize.width / 2) * 0.0001;
    setState(() {
      _pinOffset = localPos;
      _lat = (_baseLat + latDelta).toStringAsFixed(6);
      _lng = (_baseLng + lngDelta).toStringAsFixed(6);
    });
  }

  void _clearPin() => setState(() { _pinOffset = null; _lat = null; _lng = null; });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label row
        Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
              ),
              if (widget.required)
                Text(' *', style: TextStyle(color: AppColors.error, fontSize: 13.sp, fontWeight: FontWeight.w700)),
              SizedBox(width: 8.w),
              Text(widget.banglaLabel, style: TextStyle(fontSize: 11.sp, color: AppColors.textHint)),
            ],
          ),
        ),

        // Interactive map
        LayoutBuilder(builder: (ctx, constraints) {
          final mapW = constraints.maxWidth;
          final mapH = 190.h;
          return Container(
            height: mapH,
            decoration: BoxDecoration(
              color: const Color(0xFFE8EFF5),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: _pinOffset != null
                    ? widget.pinColor.withAlpha(120)
                    : AppColors.divider,
                width: 1.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Stack(
                children: [
                  // Google Maps tile background
                  SizedBox(width: mapW, height: mapH, child: _GoogleMapTileGrid()),

                  // Tap area
                  GestureDetector(
                    onTapUp: (d) => _placePinAt(d.localPosition, Size(mapW, mapH)),
                    child: Container(width: mapW, height: mapH, color: Colors.transparent),
                  ),

                  // Hint when no pin placed
                  if (_pinOffset == null)
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(14.w),
                            decoration: BoxDecoration(
                              color: widget.pinColor.withAlpha(20),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.touch_app_rounded, color: widget.pinColor, size: 28.sp),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Tap to place pin',
                            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: widget.pinColor),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'ট্যাপ করে পিন সেট করুন',
                            style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),

                  // Draggable pin marker
                  if (_pinOffset != null)
                    Positioned(
                      left: (_pinOffset!.dx - 14.w).clamp(0, mapW - 28.w),
                      top: (_pinOffset!.dy - 36.h).clamp(0, mapH - 40.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(7.w),
                            decoration: BoxDecoration(
                              color: widget.pinColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: widget.pinColor.withAlpha(100),
                                  blurRadius: 8.r,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Icon(Icons.location_on, color: Colors.white, size: 14.sp),
                          ),
                          Container(width: 2.w, height: 6.h, color: widget.pinColor),
                        ],
                      ),
                    ),

                  // Coordinate bubble at bottom
                  if (_lat != null)
                    Positioned(
                      bottom: 8.h,
                      left: 8.w,
                      right: 40.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(230),
                          borderRadius: BorderRadius.circular(8.r),
                          boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 4.r)],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.my_location, size: 12.sp, color: widget.pinColor),
                            SizedBox(width: 6.w),
                            Flexible(
                              child: Text(
                                '$_lat, $_lng',
                                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Clear pin button
                  if (_pinOffset != null)
                    Positioned(
                      bottom: 8.h,
                      right: 8.w,
                      child: GestureDetector(
                        onTap: _clearPin,
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(230),
                            borderRadius: BorderRadius.circular(6.r),
                            boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 4.r)],
                          ),
                          child: Icon(Icons.close_rounded, size: 14.sp, color: AppColors.textHint),
                        ),
                      ),
                    ),

                  // OSM attribution (only when no pin)
                  if (_pinOffset == null)
                    Positioned(
                      bottom: 8.h,
                      right: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(200),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text('© OpenStreetMap', style: TextStyle(fontSize: 8.sp, color: AppColors.textHint)),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

// ─── HIERARCHY BREADCRUMB ────────────────────────────────────

class HierarchyBreadcrumb extends StatelessWidget {
  final String district;
  final String upazila;
  final String union;
  final String ward;
  final String? upCode;

  const HierarchyBreadcrumb({
    super.key,
    required this.district,
    required this.upazila,
    required this.union,
    required this.ward,
    this.upCode,
  });

  @override
  Widget build(BuildContext context) {
    final items = [district, upazila, union, ?upCode, ward];
    return Wrap(
      spacing: 4.w,
      runSpacing: 4.h,
      children: [
        for (int i = 0; i < items.length; i++) ...[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(15),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(items[i], style: TextStyle(fontSize: 11.sp, color: AppColors.primary, fontWeight: FontWeight.w600)),
          ),
          if (i < items.length - 1)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 3.h),
              child: Icon(Icons.chevron_right, size: 14.sp, color: AppColors.textHint),
            ),
        ],
      ],
    );
  }
}

// ─── ALERT CARD ──────────────────────────────────────────────

class DuplicateAlertCard extends StatelessWidget {
  final DuplicateAlert alert;
  final VoidCallback onViewBoth;

  const DuplicateAlertCard({super.key, required this.alert, required this.onViewBoth});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: alert.resolved ? AppColors.successLight : AppColors.errorLight,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: alert.resolved ? AppColors.success.withAlpha(60) : AppColors.error.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                alert.resolved ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                color: alert.resolved ? AppColors.success : AppColors.error,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                alert.alertId,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: alert.resolved ? AppColors.success : AppColors.error,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: alert.resolved ? AppColors.success.withAlpha(30) : AppColors.error.withAlpha(30),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  alert.resolved ? 'Resolved' : 'Active',
                  style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700, color: alert.resolved ? AppColors.success : AppColors.error),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          _AlertRow(icon: Icons.add_circle_outline, label: 'New Project', value: alert.newProjectName, color: AppColors.textPrimary),
          SizedBox(height: 6.h),
          _AlertRow(icon: Icons.history, label: 'Conflicts With', value: alert.conflictingProjectName, color: AppColors.textSecondary),
          SizedBox(height: 6.h),
          Row(
            children: [
              Icon(Icons.straighten, size: 14.sp, color: AppColors.textHint),
              SizedBox(width: 4.w),
              Text('Distance: ${alert.distance}', style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
              SizedBox(width: 16.w),
              Icon(Icons.location_on_outlined, size: 14.sp, color: AppColors.textHint),
              SizedBox(width: 4.w),
              Text(alert.ward, style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
            ],
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onViewBoth,
              icon: Icon(
                alert.resolved ? Icons.visibility_outlined : Icons.compare_arrows,
                size: 16.sp,
              ),
              label: Text(
                alert.resolved ? 'View Alert Details' : 'View Both Projects',
                style: TextStyle(fontSize: 13.sp),
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                side: BorderSide(
                  color: alert.resolved
                      ? AppColors.success.withAlpha(100)
                      : AppColors.error.withAlpha(100),
                ),
                foregroundColor: alert.resolved ? AppColors.success : AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _AlertRow({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14.sp, color: AppColors.textHint),
        SizedBox(width: 6.w),
        SizedBox(
          width: 80.w,
          child: Text(label, style: TextStyle(fontSize: 12.sp, color: AppColors.textHint)),
        ),
        Expanded(child: Text(value, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: color))),
      ],
    );
  }
}

// ─── EMPTY STATE ─────────────────────────────────────────────

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String label;
  final String banglaLabel;

  const EmptyState({super.key, required this.icon, required this.label, required this.banglaLabel});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48.sp, color: AppColors.primary.withAlpha(120)),
          ),
          SizedBox(height: 16.h),
          Text(label, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          SizedBox(height: 4.h),
          Text(banglaLabel, style: TextStyle(fontSize: 13.sp, color: AppColors.textHint)),
        ],
      ),
    );
  }
}

// ─── FILTER DROPDOWN ─────────────────────────────────────────

class FilterDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final void Function(String?) onChanged;

  const FilterDropdown({super.key, required this.label, required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.surface,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: items.map((s) => DropdownMenuItem(value: s, child: Text(s, style: TextStyle(fontSize: 12.sp)))).toList(),
          onChanged: onChanged,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded, size: 18.sp, color: AppColors.textHint),
          style: TextStyle(fontSize: 12.sp, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

// ─── COMMITTEE MEMBER TILE ───────────────────────────────────

class CommitteeMemberTile extends StatelessWidget {
  final CommitteeMember member;
  final bool isLast;

  const CommitteeMemberTile({super.key, required this.member, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: AppColors.primary.withAlpha(20),
                child: Text(
                  member.name[0],
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(member.name, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
                    Text('${member.designation} • ${member.ward}', style: TextStyle(fontSize: 11.sp, color: AppColors.textHint)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(15),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.phone_outlined, size: 16.sp, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1),
      ],
    );
  }
}
