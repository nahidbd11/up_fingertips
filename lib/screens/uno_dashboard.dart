import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../widgets/common_widgets.dart';
import 'duplicate_alert_detail.dart';

class UNODashboard extends StatefulWidget {
  const UNODashboard({super.key});

  @override
  State<UNODashboard> createState() => _UNODashboardState();
}

class _UNODashboardState extends State<UNODashboard> {
  int _selectedIndex = 0;

  final _drawerItems = const [
    DrawerItem('Dashboard', 'ড্যাশবোর্ড', Icons.dashboard_outlined),
    DrawerItem('All Projects', 'সকল প্রকল্প', Icons.folder_copy_outlined),
    DrawerItem('Duplicate Alerts', 'সদৃশ সতর্কতা', Icons.warning_amber_outlined),
    DrawerItem('Meeting Minutes', 'সভার কার্যবিবরণী', Icons.description_outlined),
    DrawerItem('Reports', 'রিপোর্ট', Icons.bar_chart_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UPAppBar(
        title: 'UP@Fingertips',
        subtitle: 'UNO Dashboard • ইউএনও ড্যাশবোর্ড',
        notificationCount: 2,
      ),
      drawer: UPDrawer(
        roleName: 'UNO',
        roleNameBangla: 'ইউএনও',
        userName: 'Md. Shafiqur Rahman',
        userID: 'UNO-FAT-001',
        items: _drawerItems,
        selectedIndex: _selectedIndex,
        onItemSelected: (i) => setState(() => _selectedIndex = i),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _UNOHome(onNavigate: (i) => setState(() => _selectedIndex = i)),
          const _UNOProjects(),
          const _UNODuplicateAlerts(),
          const _UNOMeetingMinutes(),
          const _UNOReports(),
        ],
      ),
    );
  }
}

// ─── HOME ────────────────────────────────────────────────────

class _UNOHome extends StatelessWidget {
  final void Function(int) onNavigate;
  const _UNOHome({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Upazila info card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.primaryDark, Color(0xFF1976D2)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good Morning,', style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 12.sp)),
                      Text('Md. Shafiqur Rahman', style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w700)),
                      SizedBox(height: 2.h),
                      Text('UNO, Fatullah Upazila', style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 12.sp)),
                      SizedBox(height: 8.h),
                      Text('Narayanganj District', style: TextStyle(color: Colors.white70, fontSize: 11.sp)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(color: Colors.white.withAlpha(25), shape: BoxShape.circle),
                  child: Icon(Icons.supervisor_account_rounded, color: Colors.white, size: 32.sp),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // NOTE: Monitoring only banner
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(10),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.primary.withAlpha(40)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.primary, size: 16.sp),
                SizedBox(width: 8.w),
                const Expanded(
                  child: Text(
                    'Monitoring Role — Project approvals happen offline. This system shows approved projects only.',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Stats
          SectionHeader(title: 'Upazila Overview', banglaTitle: 'উপজেলা সংক্ষিপ্ত বিবরণ'),
          SizedBox(height: 12.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: MediaQuery.of(context).size.width < 390 ? 1.2 : 1.3,
            children: [
              StatCard(label: 'Total Projects', banglalabel: 'মোট প্রকল্প', value: '$totalProjects', icon: Icons.folder_outlined, color: AppColors.primary, bgColor: AppColors.statusUpcomingBg),
              StatCard(label: 'Ongoing', banglalabel: 'চলমান', value: '$ongoingProjects', icon: Icons.construction_outlined, color: AppColors.statusOngoing, bgColor: AppColors.statusOngoingBg),
              StatCard(label: 'Completed', banglalabel: 'সম্পন্ন', value: '$completedProjects', icon: Icons.check_circle_outline, color: AppColors.success, bgColor: AppColors.successLight),
              StatCard(label: 'Duplicate Alerts', banglalabel: 'সদৃশ সতর্কতা', value: '$duplicateAlerts', icon: Icons.warning_amber_outlined, color: AppColors.error, bgColor: AppColors.errorLight),
            ],
          ),
          SizedBox(height: 20.h),

          // Recent Activity Feed
          SectionHeader(title: 'Recent Activity', banglaTitle: 'সাম্প্রতিক কার্যক্রম'),
          SizedBox(height: 12.h),
          _ActivityFeed(),
          SizedBox(height: 20.h),

          // Recent Projects
          SectionHeader(title: 'Projects', banglaTitle: 'প্রকল্প', actionLabel: 'View All', onAction: () => onNavigate(1)),
          SizedBox(height: 12.h),
          ...mockProjects.take(3).map((p) => ProjectTile(project: p, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _UNOProjectDetail(project: p))))),
        ],
      ),
    );
  }
}

class _ActivityFeed extends StatelessWidget {
  final _activities = const [
    _Activity('Road Repair Ward-3 marked Completed', 'Fatullah Union • 2 hours ago', Icons.check_circle_outline, AppColors.success),
    _Activity('New progress photos uploaded', 'Drainage Ward-5 • Committee Member Karim • 5 hours ago', Icons.photo_library_outlined, AppColors.primary),
    _Activity('Duplicate alert detected', 'Road Repair Near Bazar • Ward-3 • 1 day ago', Icons.warning_amber_outlined, AppColors.error),
    _Activity('Meeting minutes submitted', 'Fatullah Union • May 2026 • 2 days ago', Icons.description_outlined, AppColors.purple),
  ];

  const _ActivityFeed();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          for (int i = 0; i < _activities.length; i++) ...[
            _ActivityTile(activity: _activities[i]),
            if (i < _activities.length - 1) const Divider(height: 1, indent: 54),
          ],
        ],
      ),
    );
  }
}

class _Activity {
  final String title, subtitle;
  final IconData icon;
  final Color color;
  const _Activity(this.title, this.subtitle, this.icon, this.color);
}

class _ActivityTile extends StatelessWidget {
  final _Activity activity;
  const _ActivityTile({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(color: activity.color.withAlpha(20), shape: BoxShape.circle),
            child: Icon(activity.icon, color: activity.color, size: 16.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.title, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                SizedBox(height: 2.h),
                Text(activity.subtitle, style: TextStyle(fontSize: 11.sp, color: AppColors.textHint)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── ALL PROJECTS ────────────────────────────────────────────

class _UNOProjects extends StatefulWidget {
  const _UNOProjects();

  @override
  State<_UNOProjects> createState() => _UNOProjectsState();
}

class _UNOProjectsState extends State<_UNOProjects> {
  // ── filter state (Page 3b: Union → Ward → Type → Status → Year + Search) ──
  String _selectedUnion = 'All Unions';
  String _selectedWard = 'All Wards';
  String _selectedType = 'All Types';
  String _selectedStatus = 'All';
  String _selectedYear = 'All Years';
  String _searchQuery = '';
  bool _showFilters = false;
  final _searchCtrl = TextEditingController();

  int get _activeFilters => [
        _selectedUnion != 'All Unions',
        _selectedWard != 'All Wards',
        _selectedType != 'All Types',
        _selectedStatus != 'All',
        _selectedYear != 'All Years',
      ].where((b) => b).length;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Project> get _filtered => mockProjects.where((p) {
        if (_selectedUnion != 'All Unions' && p.union != _selectedUnion) return false;
        if (_selectedWard != 'All Wards' && p.ward != _selectedWard) return false;
        if (_selectedStatus != 'All') {
          if (_selectedStatus == 'Upcoming' && p.status != ProjectStatus.upcoming) return false;
          if (_selectedStatus == 'Ongoing' && p.status != ProjectStatus.ongoing) return false;
          if (_selectedStatus == 'Awaiting' && p.status != ProjectStatus.awaitingApproval) return false;
          if (_selectedStatus == 'Completed' && p.status != ProjectStatus.completed) return false;
        }
        if (_selectedYear != 'All Years' && p.financialYear != _selectedYear) return false;
        if (_searchQuery.isNotEmpty && !p.name.toLowerCase().contains(_searchQuery.toLowerCase())) return false;
        return true;
      }).toList();

  void _clearAll() => setState(() {
        _selectedUnion = 'All Unions';
        _selectedWard = 'All Wards';
        _selectedType = 'All Types';
        _selectedStatus = 'All';
        _selectedYear = 'All Years';
        _searchQuery = '';
        _searchCtrl.clear();
      });

  @override
  Widget build(BuildContext context) {
    final projects = _filtered;
    return Column(
      children: [
        Container(
          color: AppColors.surface,
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Search + toggle
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 38.h,
                      child: TextField(
                        controller: _searchCtrl,
                        onChanged: (v) => setState(() => _searchQuery = v),
                        decoration: InputDecoration(
                          hintText: 'Search projects...',
                          hintStyle: TextStyle(fontSize: 12.sp),
                          prefixIcon: Icon(Icons.search, size: 18.sp, color: AppColors.textHint),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? GestureDetector(
                                  onTap: () => setState(() { _searchQuery = ''; _searchCtrl.clear(); }),
                                  child: Icon(Icons.clear, size: 16.sp, color: AppColors.textHint),
                                )
                              : null,
                          contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                          filled: true,
                          fillColor: AppColors.background,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: AppColors.divider)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: AppColors.divider)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: AppColors.primary)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: () => setState(() => _showFilters = !_showFilters),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: _activeFilters > 0 ? AppColors.primary : AppColors.background,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: _activeFilters > 0 ? AppColors.primary : AppColors.divider),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.filter_list_rounded, size: 16.sp, color: _activeFilters > 0 ? Colors.white : AppColors.textSecondary),
                          SizedBox(width: 4.w),
                          Text(_activeFilters > 0 ? '$_activeFilters Active' : 'Filters', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: _activeFilters > 0 ? Colors.white : AppColors.textSecondary)),
                          SizedBox(width: 4.w),
                          Icon(_showFilters ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 16.sp, color: _activeFilters > 0 ? Colors.white : AppColors.textSecondary),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Expanded filter rows (Union → Ward → Type → Status → Year)
              if (_showFilters) ...[
                SizedBox(height: 10.h),
                const Divider(height: 1),
                SizedBox(height: 10.h),
                // Row 2: Union + Ward
                Row(
                  children: [
                    Expanded(child: FilterDropdown(label: 'Union', value: _selectedUnion, items: const ['All Unions', 'Fatullah Union', 'Enayetnagar Union', 'Kanchan Union'], onChanged: (v) => setState(() => _selectedUnion = v!))),
                    SizedBox(width: 8.w),
                    Expanded(child: FilterDropdown(label: 'Ward', value: _selectedWard, items: const ['All Wards', 'Ward-1', 'Ward-2', 'Ward-3', 'Ward-4', 'Ward-5', 'Ward-6', 'Ward-7', 'Ward-8', 'Ward-9'], onChanged: (v) => setState(() => _selectedWard = v!))),
                  ],
                ),
                SizedBox(height: 8.h),
                // Row 3: Type + Status
                Row(
                  children: [
                    Expanded(child: FilterDropdown(label: 'Type', value: _selectedType, items: const ['All Types', 'Road', 'Drainage', 'Mosque', 'Culvert', 'Earthwork', 'Other'], onChanged: (v) => setState(() => _selectedType = v!))),
                    SizedBox(width: 8.w),
                    Expanded(child: FilterDropdown(label: 'Status', value: _selectedStatus, items: const ['All', 'Upcoming', 'Ongoing', 'Awaiting', 'Completed'], onChanged: (v) => setState(() => _selectedStatus = v!))),
                  ],
                ),
                SizedBox(height: 8.h),
                // Row 4: Year + buttons
                Row(
                  children: [
                    Expanded(child: FilterDropdown(label: 'Year', value: _selectedYear, items: const ['All Years', '2025-26', '2024-25', '2023-24'], onChanged: (v) => setState(() => _selectedYear = v!))),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _clearAll,
                        icon: Icon(Icons.clear_all, size: 16.sp),
                        label: Text('Clear All', style: TextStyle(fontSize: 12.sp)),
                        style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 10.h), side: const BorderSide(color: AppColors.divider), foregroundColor: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 4.h),
          child: Row(children: [
            Text('${projects.length} projects', style: TextStyle(fontSize: 12.sp, color: AppColors.textHint)),
            const Spacer(),
            Text('Read-only monitoring', style: TextStyle(fontSize: 11.sp, color: AppColors.primary, fontStyle: FontStyle.italic)),
          ]),
        ),
        Expanded(
          child: projects.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off_outlined, size: 40.sp, color: AppColors.textHint),
                      SizedBox(height: 10.h),
                      Text('No projects match the filters', style: TextStyle(fontSize: 13.sp, color: AppColors.textHint)),
                      SizedBox(height: 6.h),
                      TextButton(onPressed: _clearAll, child: const Text('Clear filters')),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 16.h),
                  itemCount: projects.length,
                  itemBuilder: (_, i) => ProjectTile(
                    project: projects[i],
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _UNOProjectDetail(project: projects[i]))),
                  ),
                ),
        ),
      ],
    );
  }
}

// ─── DUPLICATE ALERTS ────────────────────────────────────────

class _UNODuplicateAlerts extends StatefulWidget {
  const _UNODuplicateAlerts();

  @override
  State<_UNODuplicateAlerts> createState() => _UNODuplicateAlertsState();
}

class _UNODuplicateAlertsState extends State<_UNODuplicateAlerts> {
  // Page 3c spec: Union | Ward | Status (Active / Resolved)
  String _selectedUnion = 'All Unions';
  String _selectedWard = 'All Wards';
  String _selectedResolution = 'All Alerts';

  List<DuplicateAlert> get _filtered => mockDuplicateAlerts.where((a) {
        if (_selectedResolution == 'Active' && a.resolved) return false;
        if (_selectedResolution == 'Resolved' && !a.resolved) return false;
        return true;
      }).toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter bar
        Container(
          color: AppColors.surface,
          padding: EdgeInsets.all(12.w),
          child: Column(
            children: [
              // Row 1: Union + Ward
              Row(
                children: [
                  Expanded(child: FilterDropdown(label: 'Union', value: _selectedUnion, items: const ['All Unions', 'Fatullah Union', 'Enayetnagar Union', 'Kanchan Union'], onChanged: (v) => setState(() => _selectedUnion = v!))),
                  SizedBox(width: 8.w),
                  Expanded(child: FilterDropdown(label: 'Ward', value: _selectedWard, items: const ['All Wards', 'Ward-1', 'Ward-2', 'Ward-3', 'Ward-4', 'Ward-5', 'Ward-6', 'Ward-7', 'Ward-8', 'Ward-9'], onChanged: (v) => setState(() => _selectedWard = v!))),
                ],
              ),
              SizedBox(height: 8.h),
              // Row 2: Status (Active / Resolved)
              FilterDropdown(label: 'Alert Status', value: _selectedResolution, items: const ['All Alerts', 'Active', 'Resolved'], onChanged: (v) => setState(() => _selectedResolution = v!)),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('${_filtered.length} alert${_filtered.length != 1 ? "s" : ""}', style: TextStyle(fontSize: 12.sp, color: AppColors.textHint)),
                    const Spacer(),
                    Text('within 500m radius, last 3 yrs', style: TextStyle(fontSize: 11.sp, color: AppColors.textHint, fontStyle: FontStyle.italic)),
                  ],
                ),
                SizedBox(height: 12.h),
                ..._filtered.map((a) => DuplicateAlertCard(
                      alert: a,
                      onViewBoth: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DuplicateAlertDetailPage(alert: a))),
                    )),
                SizedBox(height: 20.h),
                const MapPlaceholder(label: 'Duplicate Projects Map', showCircle: true),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── MEETING MINUTES ─────────────────────────────────────────

class _UNOMeetingMinutes extends StatelessWidget {
  const _UNOMeetingMinutes();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter bar (Page 3d spec: Union | Month | Year | Search)
        Container(
          color: AppColors.surface,
          padding: EdgeInsets.all(12.w),
          child: Column(
            children: [
              // Row 1: Union + Month
              Row(
                children: [
                  Expanded(child: FilterDropdown(label: 'Union', value: 'All Unions', items: const ['All Unions', 'Fatullah Union', 'Enayetnagar Union'], onChanged: (_) {})),
                  SizedBox(width: 8.w),
                  Expanded(child: FilterDropdown(label: 'Month', value: 'All Months', items: const ['All Months', 'June 2026', 'May 2026', 'April 2026', 'March 2026'], onChanged: (_) {})),
                ],
              ),
              SizedBox(height: 8.h),
              // Row 2: Year + Search
              Row(
                children: [
                  Expanded(child: FilterDropdown(label: 'Year', value: 'All Years', items: const ['All Years', '2026', '2025', '2024'], onChanged: (_) {})),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: SizedBox(
                      height: 38.h,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search minutes...',
                          hintStyle: TextStyle(fontSize: 12.sp),
                          prefixIcon: Icon(Icons.search, size: 18.sp, color: AppColors.textHint),
                          contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                          filled: true,
                          fillColor: AppColors.background,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: AppColors.divider)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: AppColors.divider)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: AppColors.primary)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: mockMeetingMinutes.length,
            itemBuilder: (_, i) => _MinutesTile(minutes: mockMeetingMinutes[i], onTap: () => _showMinutesDetail(context, mockMeetingMinutes[i])),
          ),
        ),
      ],
    );
  }

  void _showMinutesDetail(BuildContext context, MeetingMinutes m) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _MinutesDetailSheet(minutes: m),
    );
  }
}

class _MinutesTile extends StatelessWidget {
  final MeetingMinutes minutes;
  final VoidCallback onTap;
  const _MinutesTile({required this.minutes, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.purple.withAlpha(20),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(minutes.meetingType, style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700, color: AppColors.purple)),
                ),
                const Spacer(),
                Text(minutes.meetingDate, style: TextStyle(fontSize: 12.sp, color: AppColors.textHint)),
              ],
            ),
            SizedBox(height: 8.h),
            Text(minutes.unionName, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            SizedBox(height: 4.h),
            Text(minutes.submittedBy, style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
            SizedBox(height: 10.h),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: onTap,
                  icon: Icon(Icons.visibility_outlined, size: 14.sp),
                  label: Text('View', style: TextStyle(fontSize: 12.sp)),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                    side: const BorderSide(color: AppColors.primary),
                    foregroundColor: AppColors.primary,
                  ),
                ),
                SizedBox(width: 8.w),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.download_outlined, size: 14.sp),
                  label: Text('PDF', style: TextStyle(fontSize: 12.sp)),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                    side: const BorderSide(color: AppColors.divider),
                    foregroundColor: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MinutesDetailSheet extends StatelessWidget {
  final MeetingMinutes minutes;
  const _MinutesDetailSheet({required this.minutes});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            SizedBox(height: 12.h),
            Container(width: 40.w, height: 4.h, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2.r))),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(minutes.unionName, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700)),
                      Text('${minutes.meetingType} Meeting • ${minutes.meetingDate}', style: TextStyle(fontSize: 12.sp, color: AppColors.textHint)),
                    ],
                  ),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.download_outlined, color: AppColors.primary), onPressed: () {}),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                controller: controller,
                padding: EdgeInsets.all(16.w),
                children: [
                  _MinutesSection(title: 'Attendees • উপস্থিত', content: minutes.attendees),
                  SizedBox(height: 16.h),
                  _MinutesSection(title: 'Discussion • আলোচনা', content: minutes.discussion),
                  SizedBox(height: 16.h),
                  _MinutesSection(title: 'Decision • সিদ্ধান্ত', content: minutes.decision),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MinutesSection extends StatelessWidget {
  final String title;
  final String content;
  const _MinutesSection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: AppColors.primary)),
          SizedBox(height: 8.h),
          Text(content, style: TextStyle(fontSize: 13.sp, color: AppColors.textPrimary, height: 1.6)),
        ],
      ),
    );
  }
}

// ─── REPORTS ─────────────────────────────────────────────────

class _UNOReports extends StatelessWidget {
  const _UNOReports();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Reports', banglaTitle: 'রিপোর্ট'),
          SizedBox(height: 16.h),
          _ReportTile(icon: Icons.calendar_month_outlined, title: 'Monthly Report', subtitle: 'Project summary by month', bangla: 'মাসিক রিপোর্ট'),
          _ReportTile(icon: Icons.bar_chart_outlined, title: 'Yearly Report', subtitle: 'Annual progress overview', bangla: 'বার্ষিক রিপোর্ট'),
          _ReportTile(icon: Icons.location_city_outlined, title: 'Union-wise Report', subtitle: 'Projects by Union Parishad', bangla: 'ইউনিয়ন ভিত্তিক রিপোর্ট'),
          _ReportTile(icon: Icons.warning_amber_outlined, title: 'Duplicate Projects', subtitle: 'Last 3 years analysis', bangla: 'সদৃশ প্রকল্প রিপোর্ট'),
        ],
      ),
    );
  }
}

class _ReportTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String bangla;
  const _ReportTile({required this.icon, required this.title, required this.subtitle, required this.bangla});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(color: AppColors.primary.withAlpha(15), borderRadius: BorderRadius.circular(12.r)),
            child: Icon(icon, color: AppColors.primary, size: 22.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
              Text(bangla, style: TextStyle(fontSize: 11.sp, color: AppColors.textHint)),
              Text(subtitle, style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
            ]),
          ),
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.download_outlined, size: 14.sp),
            label: Text('Export', style: TextStyle(fontSize: 12.sp)),
            style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h)),
          ),
        ],
      ),
    );
  }
}

// ─── PROJECT DETAIL (READ-ONLY for UNO) ──────────────────────

class _UNOProjectDetail extends StatelessWidget {
  final Project project;
  const _UNOProjectDetail({required this.project});

  @override
  Widget build(BuildContext context) {
    final p = project;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Project Detail', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: Colors.white)),
            Text(p.id, style: TextStyle(fontSize: 11.sp, color: Colors.white.withAlpha(180))),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(10),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.primary.withAlpha(40)),
            ),
            child: Row(
              children: [
                Icon(Icons.visibility_outlined, color: AppColors.primary, size: 16.sp),
                SizedBox(width: 8.w),
                Text('Read-only monitoring view • শুধুমাত্র পর্যবেক্ষণ', style: TextStyle(fontSize: 12.sp, color: AppColors.primary, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          InfoCard(
            title: p.name,
            banglaTitle: p.id,
            children: [
              InfoRow(label: 'Status', value: '', icon: Icons.circle_outlined),
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: StatusBadge(status: p.status),
              ),
              const Divider(height: 1),
              InfoRow(label: 'Ward', value: p.ward),
              InfoRow(label: 'Financial Year', value: p.financialYear),
              InfoRow(label: 'Project Cost', value: '৳ ${p.costBDT.toStringAsFixed(0)}'),
              InfoRow(label: 'Start Date', value: p.startDate),
              InfoRow(label: 'Contractor', value: p.contractor ?? 'Not yet assigned', isLast: true),
            ],
          ),
          SizedBox(height: 12.h),
          const MapPlaceholder(),
          SizedBox(height: 12.h),
          InfoCard(
            title: 'Progress Photos',
            banglaTitle: 'অগ্রগতি ছবি',
            children: [PhotoPhaseWidget(phases: mockPhotoPhases)],
          ),
          SizedBox(height: 12.h),
          InfoCard(
            title: 'Progress Videos',
            banglaTitle: 'অগ্রগতি ভিডিও',
            children: [PhotoPhaseWidget(phases: mockVideoPhases, isVideo: true)],
          ),
          SizedBox(height: 12.h),

          // UNO can comment
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add Comment • মন্তব্য যোগ করুন',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                SizedBox(height: 10.h),
                TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Write comment or instruction...',
                    hintStyle: TextStyle(fontSize: 13.sp),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: AppColors.divider)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: AppColors.divider)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: AppColors.primary)),
                    filled: true,
                    fillColor: AppColors.background,
                  ),
                ),
                SizedBox(height: 10.h),
                SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, child: const Text('Submit Comment'))),
              ],
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
