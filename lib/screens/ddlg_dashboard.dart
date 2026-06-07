import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../widgets/common_widgets.dart';
import 'duplicate_alert_detail.dart';

class DDLGDashboard extends StatefulWidget {
  const DDLGDashboard({super.key});

  @override
  State<DDLGDashboard> createState() => _DDLGDashboardState();
}

class _DDLGDashboardState extends State<DDLGDashboard> {
  int _selectedIndex = 0;

  final _drawerItems = const [
    DrawerItem('Dashboard', 'ড্যাশবোর্ড', Icons.dashboard_outlined),
    DrawerItem('Projects', 'প্রকল্প তালিকা', Icons.folder_outlined),
    DrawerItem('Map View', 'মানচিত্র দৃশ্য', Icons.map_outlined),
    DrawerItem('Reports', 'রিপোর্ট', Icons.bar_chart_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UPAppBar(
        title: 'UP@Fingertips',
        subtitle: 'DDLG Dashboard • ডিডিএলজি ড্যাশবোর্ড',
        notificationCount: duplicateAlerts + 1,
      ),
      drawer: UPDrawer(
        roleName: 'DDLG',
        roleNameBangla: 'ডিডিএলজি',
        userName: 'Md. Rafiqul Islam',
        userID: 'DDLG-NAR-001',
        items: _drawerItems,
        selectedIndex: _selectedIndex,
        onItemSelected: (i) => setState(() => _selectedIndex = i),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _DDLGHome(onNavigate: (i) => setState(() => _selectedIndex = i)),
          const _DDLGProjects(),
          const _DDLGMapView(),
          const _DDLGReports(),
        ],
      ),
    );
  }
}

// ─── HOME ────────────────────────────────────────────────────

class _DDLGHome extends StatelessWidget {
  final void Function(int) onNavigate;
  const _DDLGHome({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.primaryDark, AppColors.primary], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Good Morning,', style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 13.sp)),
                Text('Md. Rafiqul Islam', style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w700)),
                SizedBox(height: 4.h),
                Text('DDLG, Narayanganj District', style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 12.sp)),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    _BannerChip(Icons.location_city_outlined, 'Narayanganj'),
                    SizedBox(width: 8.w),
                    _BannerChip(Icons.calendar_today_outlined, 'FY 2025-26'),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // Stat Cards
          SectionHeader(title: 'Project Overview', banglaTitle: 'প্রকল্পের সংক্ষিপ্ত বিবরণ', actionLabel: 'See All', onAction: () => onNavigate(1)),
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

          // Quick Filter strip (Page 2a spec: below stat cards)
          _DDLGHomeQuickFilter(onApply: () => onNavigate(1)),
          SizedBox(height: 20.h),

          // Recent Projects
          SectionHeader(title: 'Recent Projects', banglaTitle: 'সাম্প্রতিক প্রকল্প', actionLabel: 'All Projects', onAction: () => onNavigate(1)),
          SizedBox(height: 12.h),
          ...mockProjects.take(3).map((p) => ProjectTile(
                project: p,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _DDLGProjectDetail(project: p))),
              )),

          SizedBox(height: 20.h),

          // Duplicate Alerts section
          SectionHeader(title: 'Duplicate Alerts', banglaTitle: 'সদৃশ প্রকল্প সতর্কতা'),
          SizedBox(height: 12.h),
          ...mockDuplicateAlerts.take(2).map((a) => DuplicateAlertCard(
                alert: a,
                onViewBoth: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DuplicateAlertDetailPage(alert: a))),
              )),
        ],
      ),
    );
  }
}

// ─── HOME QUICK FILTER (Page 2a spec) ────────────────────────
// Collapsible filter strip below stat cards on DDLG Home page.
// District → Upazila → Union → Ward → Status → Financial Year → [Apply]

class _DDLGHomeQuickFilter extends StatefulWidget {
  final VoidCallback onApply;
  const _DDLGHomeQuickFilter({required this.onApply});

  @override
  State<_DDLGHomeQuickFilter> createState() => _DDLGHomeQuickFilterState();
}

class _DDLGHomeQuickFilterState extends State<_DDLGHomeQuickFilter> {
  String _upazila = 'All Upazilas';
  String _union = 'All Unions';
  String _ward = 'All Wards';
  String _status = 'All Status';
  String _year = 'All Years';
  bool _expanded = false;

  int get _active => [
        _upazila != 'All Upazilas',
        _union != 'All Unions',
        _ward != 'All Wards',
        _status != 'All Status',
        _year != 'All Years',
      ].where((b) => b).length;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: _active > 0 ? AppColors.primary.withAlpha(80) : AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header — always visible
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
              child: Row(
                children: [
                  Icon(Icons.filter_list_rounded, size: 16.sp, color: AppColors.primary),
                  SizedBox(width: 8.w),
                  Text('Quick Filter', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  Text('  দ্রুত ফিল্টার', style: TextStyle(fontSize: 11.sp, color: AppColors.textHint)),
                  const Spacer(),
                  if (_active > 0)
                    Container(
                      margin: EdgeInsets.only(right: 8.w),
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10.r)),
                      child: Text('$_active active', style: TextStyle(fontSize: 10.sp, color: Colors.white, fontWeight: FontWeight.w700)),
                    ),
                  Icon(_expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 20.sp, color: AppColors.textHint),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const Divider(height: 1),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                children: [
                  // Row: Upazila + Union (District = Narayanganj, implicit)
                  Row(
                    children: [
                      Expanded(child: _FilterDropdown(label: 'Upazila', value: _upazila, items: const ['All Upazilas', 'Fatullah Upazila', 'Sonargaon Upazila', 'Araihazar Upazila'], onChanged: (v) => setState(() => _upazila = v!))),
                      SizedBox(width: 8.w),
                      Expanded(child: _FilterDropdown(label: 'Union', value: _union, items: const ['All Unions', 'Fatullah Union', 'Enayetnagar Union', 'Kanchan Union'], onChanged: (v) => setState(() => _union = v!))),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  // Row: Ward + Status
                  Row(
                    children: [
                      Expanded(child: _FilterDropdown(label: 'Ward', value: _ward, items: const ['All Wards', 'Ward-1', 'Ward-2', 'Ward-3', 'Ward-4', 'Ward-5', 'Ward-6', 'Ward-7', 'Ward-8', 'Ward-9'], onChanged: (v) => setState(() => _ward = v!))),
                      SizedBox(width: 8.w),
                      Expanded(child: _FilterDropdown(label: 'Status', value: _status, items: const ['All Status', 'Upcoming', 'Ongoing', 'Awaiting', 'Completed'], onChanged: (v) => setState(() => _status = v!))),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  // Row: Year + Apply
                  Row(
                    children: [
                      Expanded(child: _FilterDropdown(label: 'Year', value: _year, items: const ['All Years', '2025-26', '2024-25', '2023-24'], onChanged: (v) => setState(() => _year = v!))),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: widget.onApply,
                          icon: Icon(Icons.search, size: 16.sp),
                          label: Text('Apply & View All', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700)),
                          style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 10.h)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BannerChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _BannerChip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(30),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: Colors.white),
          SizedBox(width: 4.w),
          Text(label, style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ─── PROJECTS LIST ───────────────────────────────────────────

class _DDLGProjects extends StatefulWidget {
  const _DDLGProjects();

  @override
  State<_DDLGProjects> createState() => _DDLGProjectsState();
}

class _DDLGProjectsState extends State<_DDLGProjects> {
  // ── filter state ─────────────────────────────────────────────
  String _selectedUpazila = 'All Upazilas';
  String _selectedUnion = 'All Unions';
  String _selectedWard = 'All Wards';
  String _selectedType = 'All Types';
  String _selectedStatus = 'All Status';
  String _selectedYear = 'All Years';
  String _searchQuery = '';
  bool _showFilters = false;
  final _searchCtrl = TextEditingController();

  int get _activeFilters => [
        _selectedUpazila != 'All Upazilas',
        _selectedUnion != 'All Unions',
        _selectedWard != 'All Wards',
        _selectedType != 'All Types',
        _selectedStatus != 'All Status',
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
        if (_selectedStatus != 'All Status') {
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
        _selectedUpazila = 'All Upazilas';
        _selectedUnion = 'All Unions';
        _selectedWard = 'All Wards';
        _selectedType = 'All Types';
        _selectedStatus = 'All Status';
        _selectedYear = 'All Years';
        _searchQuery = '';
        _searchCtrl.clear();
      });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Filter panel ──────────────────────────────────────
        Container(
          color: AppColors.surface,
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
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
                          hintText: 'Search projects... প্রকল্প খুঁজুন',
                          hintStyle: TextStyle(fontSize: 12.sp),
                          prefixIcon: Icon(Icons.search, size: 18.sp, color: AppColors.textHint),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? GestureDetector(
                                  onTap: () => setState(() {
                                    _searchQuery = '';
                                    _searchCtrl.clear();
                                  }),
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
                  // Filters toggle button
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
                          Text(
                            _activeFilters > 0 ? '$_activeFilters Active' : 'Filters',
                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: _activeFilters > 0 ? Colors.white : AppColors.textSecondary),
                          ),
                          SizedBox(width: 4.w),
                          Icon(_showFilters ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 16.sp, color: _activeFilters > 0 ? Colors.white : AppColors.textSecondary),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Expanded filter rows (District → Upazila → Union → Ward → Status → Year)
              if (_showFilters) ...[
                SizedBox(height: 10.h),
                const Divider(height: 1),
                SizedBox(height: 10.h),
                // Row 2: Upazila + Union  (District implicit: Narayanganj)
                Row(
                  children: [
                    Expanded(
                      child: _FilterDropdown(
                        label: 'Upazila',
                        value: _selectedUpazila,
                        items: const ['All Upazilas', 'Fatullah Upazila', 'Sonargaon Upazila', 'Araihazar Upazila'],
                        onChanged: (v) => setState(() => _selectedUpazila = v!),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _FilterDropdown(
                        label: 'Union',
                        value: _selectedUnion,
                        items: const ['All Unions', 'Fatullah Union', 'Enayetnagar Union', 'Kanchan Union'],
                        onChanged: (v) => setState(() => _selectedUnion = v!),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                // Row 3: Ward + Type
                Row(
                  children: [
                    Expanded(
                      child: _FilterDropdown(
                        label: 'Ward',
                        value: _selectedWard,
                        items: const ['All Wards', 'Ward-1', 'Ward-2', 'Ward-3', 'Ward-4', 'Ward-5', 'Ward-6', 'Ward-7', 'Ward-8', 'Ward-9'],
                        onChanged: (v) => setState(() => _selectedWard = v!),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _FilterDropdown(
                        label: 'Type',
                        value: _selectedType,
                        items: const ['All Types', 'Road', 'Drainage', 'Mosque', 'Culvert', 'Earthwork', 'Other'],
                        onChanged: (v) => setState(() => _selectedType = v!),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                // Row 4: Status + Year
                Row(
                  children: [
                    Expanded(
                      child: _FilterDropdown(
                        label: 'Status',
                        value: _selectedStatus,
                        items: const ['All Status', 'Upcoming', 'Ongoing', 'Awaiting', 'Completed'],
                        onChanged: (v) => setState(() => _selectedStatus = v!),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _FilterDropdown(
                        label: 'Year',
                        value: _selectedYear,
                        items: const ['All Years', '2025-26', '2024-25', '2023-24'],
                        onChanged: (v) => setState(() => _selectedYear = v!),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                // Row 5: Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _clearAll,
                        icon: Icon(Icons.clear_all, size: 16.sp),
                        label: Text('Clear All', style: TextStyle(fontSize: 12.sp)),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          side: const BorderSide(color: AppColors.divider),
                          foregroundColor: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => setState(() => _showFilters = false),
                        icon: Icon(Icons.check, size: 16.sp),
                        label: Text('Apply Filters', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700)),
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 10.h)),
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
          child: Row(
            children: [
              Text('${_filtered.length} projects found', style: TextStyle(fontSize: 12.sp, color: AppColors.textHint, fontWeight: FontWeight.w500)),
              const Spacer(),
              if (_activeFilters > 0)
                GestureDetector(
                  onTap: _clearAll,
                  child: Text('Clear filters', style: TextStyle(fontSize: 12.sp, color: AppColors.error)),
                )
              else ...[
                Icon(Icons.sort_outlined, size: 16.sp, color: AppColors.textHint),
                SizedBox(width: 4.w),
                Text('Sort', style: TextStyle(fontSize: 12.sp, color: AppColors.textHint)),
              ],
            ],
          ),
        ),
        Expanded(
          child: _filtered.isEmpty
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
                  itemCount: _filtered.length,
                  itemBuilder: (_, i) => ProjectTile(
                    project: _filtered[i],
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _DDLGProjectDetail(project: _filtered[i]))),
                  ),
                ),
        ),
      ],
    );
  }
}

// ─── MAP VIEW ────────────────────────────────────────────────

class _DDLGMapView extends StatelessWidget {
  const _DDLGMapView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filters (Page 2d spec: District → Upazila → Union → Ward → Status → Financial Year)
        Container(
          color: AppColors.surface,
          padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
          child: Column(
            children: [
              // Row 1: Upazila + Union
              Row(
                children: [
                  Expanded(child: _FilterDropdown(label: 'Upazila', value: 'All Upazilas', items: const ['All Upazilas', 'Fatullah Upazila', 'Sonargaon Upazila'], onChanged: (_) {})),
                  SizedBox(width: 8.w),
                  Expanded(child: _FilterDropdown(label: 'Union', value: 'All Unions', items: const ['All Unions', 'Fatullah Union', 'Enayetnagar Union', 'Kanchan Union'], onChanged: (_) {})),
                ],
              ),
              SizedBox(height: 8.h),
              // Row 2: Ward + Status
              Row(
                children: [
                  Expanded(child: _FilterDropdown(label: 'Ward', value: 'All Wards', items: const ['All Wards', 'Ward-1', 'Ward-2', 'Ward-3', 'Ward-4', 'Ward-5', 'Ward-6', 'Ward-7', 'Ward-8', 'Ward-9'], onChanged: (_) {})),
                  SizedBox(width: 8.w),
                  Expanded(child: _FilterDropdown(label: 'Status', value: 'All', items: const ['All', 'Upcoming', 'Ongoing', 'Completed', 'Alert'], onChanged: (_) {})),
                ],
              ),
              SizedBox(height: 8.h),
              // Row 3: Year + Apply
              Row(
                children: [
                  Expanded(child: _FilterDropdown(label: 'Year', value: 'All Years', items: const ['All Years', '2025-26', '2024-25', '2023-24'], onChanged: (_) {})),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.map_outlined, size: 16.sp),
                      label: Text('Apply', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700)),
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 10.h)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // Map
        Expanded(
          child: Stack(
            children: [
              const MapPlaceholder(height: double.infinity, label: 'Narayanganj District — Fatullah Upazila'),
              // Legend
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(230),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Legend', style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700)),
                      SizedBox(height: 6.h),
                      _LegendRow(AppColors.statusUpcoming, 'Upcoming'),
                      _LegendRow(AppColors.statusOngoing, 'Ongoing'),
                      _LegendRow(AppColors.statusCompleted, 'Completed'),
                      _LegendRow(AppColors.error, 'Duplicate Alert'),
                    ],
                  ),
                ),
              ),
              // Project count chip
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [BoxShadow(color: AppColors.primary.withAlpha(80), blurRadius: 8.r)],
                    ),
                    child: Text(
                      '${mockProjects.length} Projects • ${mockDuplicateAlerts.where((a) => !a.resolved).length} Alerts',
                      style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendRow(this.color, this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Container(width: 10.w, height: 10.h, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          SizedBox(width: 6.w),
          Text(label, style: TextStyle(fontSize: 10.sp, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

// ─── REPORTS ─────────────────────────────────────────────────

class _DDLGReports extends StatelessWidget {
  const _DDLGReports();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Reports', banglaTitle: 'রিপোর্ট'),
          SizedBox(height: 16.h),
          _ReportCard(icon: Icons.assessment_outlined, title: 'Project Summary Report', bangla: 'প্রকল্প সারসংক্ষেপ', subtitle: 'All projects by status and union'),
          _ReportCard(icon: Icons.bar_chart_outlined, title: 'Financial Year Report', bangla: 'আর্থিক বছরের রিপোর্ট', subtitle: 'Budget vs. actual cost analysis'),
          _ReportCard(icon: Icons.warning_amber_outlined, title: 'Duplicate Alert Report', bangla: 'সদৃশ প্রকল্প রিপোর্ট', subtitle: 'All flagged duplicate projects'),
          _ReportCard(icon: Icons.location_city_outlined, title: 'Ward-wise Progress', bangla: 'ওয়ার্ড অনুযায়ী অগ্রগতি', subtitle: 'Project completion by ward'),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String bangla;
  final String subtitle;
  const _ReportCard({required this.icon, required this.title, required this.bangla, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(color: AppColors.primary.withAlpha(15), borderRadius: BorderRadius.circular(12.r)),
            child: Icon(icon, color: AppColors.primary, size: 24.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                Text(bangla, style: TextStyle(fontSize: 11.sp, color: AppColors.textHint)),
                Text(subtitle, style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Icon(Icons.download_outlined, color: AppColors.primary, size: 22.sp),
        ],
      ),
    );
  }
}

// ─── PROJECT DETAIL ──────────────────────────────────────────

class _DDLGProjectDetail extends StatefulWidget {
  final Project project;
  const _DDLGProjectDetail({required this.project});

  @override
  State<_DDLGProjectDetail> createState() => _DDLGProjectDetailState();
}

class _DDLGProjectDetailState extends State<_DDLGProjectDetail> {
  final _commentController = TextEditingController();
  final _comments = [
    _CommentEntry('Md. Rafiqul Islam (DDLG)', 'Please ensure the road surface quality meets the standard specification before completion.', '2 days ago'),
    _CommentEntry('Md. Rafiqul Islam (DDLG)', 'I reviewed the progress photos — work is progressing well.', '1 week ago'),
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
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
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.download_outlined), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // Status bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 6.w,
                    runSpacing: 4.h,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      StatusBadge(status: p.status),
                      TypeBadge(type: p.type),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'FY ${p.financialYear}',
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textHint, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),

          // A: Project Overview
          InfoCard(
            title: 'Project Overview',
            banglaTitle: 'প্রকল্পের সংক্ষিপ্ত বিবরণ',
            children: [
              InfoRow(label: 'Project Name', value: p.name, icon: Icons.folder_outlined),
              InfoRow(label: 'Created By', value: p.createdByEngineer, icon: Icons.engineering_outlined),
              InfoRow(label: 'Entry Date', value: p.entryDate, icon: Icons.access_time_outlined),
              InfoRow(label: 'Start Date', value: p.startDate, icon: Icons.event_outlined),
              InfoRow(label: 'Cost (BDT)', value: '৳ ${p.costBDT.toStringAsFixed(0)}', icon: Icons.monetization_on_outlined, isLast: true),
            ],
          ),
          SizedBox(height: 12.h),

          // B: Location Hierarchy
          InfoCard(
            title: 'Location',
            banglaTitle: 'অবস্থান',
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: HierarchyBreadcrumb(
                  district: p.district,
                  upazila: p.upazila,
                  union: p.union,
                  ward: p.ward,
                  upCode: p.upCode,
                ),
              ),
              const Divider(height: 1),
              InfoRow(label: 'Location Name', value: p.locationName, isLast: false),
              InfoRow(label: 'Start Coords', value: '${p.startLat.toStringAsFixed(4)}, ${p.startLng.toStringAsFixed(4)}', icon: Icons.gps_fixed, isLast: false),
              InfoRow(label: 'End Coords', value: '${p.endLat.toStringAsFixed(4)}, ${p.endLng.toStringAsFixed(4)}', icon: Icons.gps_not_fixed, isLast: true),
            ],
          ),
          SizedBox(height: 8.h),
          const MapPlaceholder(label: 'Project Route on Map'),
          SizedBox(height: 12.h),

          // C: Contractor
          if (p.contractor != null)
            InfoCard(
              title: 'Contractor Details',
              banglaTitle: 'ঠিকাদারের বিবরণ',
              children: [
                InfoRow(label: 'Contractor', value: p.contractor!, icon: Icons.business_outlined),
                InfoRow(label: 'Mobile', value: p.contractorMobile ?? '—', icon: Icons.phone_outlined),
                InfoRow(label: 'Budget (BDT)', value: '৳ ${p.estimatedBudget?.toStringAsFixed(0) ?? "—"}', icon: Icons.monetization_on_outlined, isLast: true),
              ],
            ),

          SizedBox(height: 12.h),

          // D: Committee
          InfoCard(
            title: 'Scheme Supervision Committee',
            banglaTitle: 'স্কিম সুপারভিশন কমিটি',
            children: [
              for (int i = 0; i < p.committee.length; i++)
                CommitteeMemberTile(member: p.committee[i], isLast: i == p.committee.length - 1),
            ],
          ),
          SizedBox(height: 12.h),

          // E: Progress Photos
          InfoCard(
            title: 'Progress Photos',
            banglaTitle: 'অগ্রগতি ছবি',
            children: [
              PhotoPhaseWidget(phases: mockPhotoPhases),
            ],
          ),
          SizedBox(height: 12.h),

          // E2: Progress Videos
          InfoCard(
            title: 'Progress Videos',
            banglaTitle: 'অগ্রগতি ভিডিও',
            children: [
              PhotoPhaseWidget(phases: mockVideoPhases, isVideo: true),
            ],
          ),
          SizedBox(height: 12.h),

          // F: Documents
          InfoCard(
            title: 'Uploaded Documents',
            banglaTitle: 'আপলোডকৃত নথিপত্র',
            children: [
              for (int i = 0; i < p.documentNames.length; i++)
                _DocumentRow(name: p.documentNames[i], isLast: i == p.documentNames.length - 1),
            ],
          ),
          SizedBox(height: 12.h),

          // H: DDLG Comment Box
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.primary.withAlpha(60)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.comment_outlined, size: 16.sp, color: AppColors.primary),
                    SizedBox(width: 8.w),
                    Text('Instruction / Comment', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const Spacer(),
                    Text('নির্দেশনা / মন্তব্য', style: TextStyle(fontSize: 11.sp, color: AppColors.textHint)),
                  ],
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: _commentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Write instruction or comment... নির্দেশনা বা মন্তব্য লিখুন',
                    hintStyle: TextStyle(fontSize: 13.sp),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: AppColors.divider)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: AppColors.divider)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide(color: AppColors.primary, width: 2.w)),
                    filled: true,
                    fillColor: AppColors.background,
                  ),
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _comments.insert(0, _CommentEntry('Md. Rafiqul Islam (DDLG)', _commentController.text.isNotEmpty ? _commentController.text : 'Please review the project progress carefully.', 'Just now'));
                        _commentController.clear();
                      });
                    },
                    icon: Icon(Icons.send_outlined, size: 16.sp),
                    label: const Text('Submit Comment • মন্তব্য জমা দিন'),
                  ),
                ),
                SizedBox(height: 16.h),
                Text('Previous Comments', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                SizedBox(height: 8.h),
                ..._comments.map((c) => _CommentTile(comment: c)),
              ],
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

class _DocumentRow extends StatelessWidget {
  final String name;
  final bool isLast;
  const _DocumentRow({required this.name, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            children: [
              Icon(Icons.picture_as_pdf_outlined, size: 18.sp, color: AppColors.error),
              SizedBox(width: 10.w),
              Expanded(child: Text(name, style: TextStyle(fontSize: 13.sp, color: AppColors.textPrimary))),
              GestureDetector(
                onTap: () {},
                child: Icon(Icons.download_outlined, size: 18.sp, color: AppColors.primary),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1),
      ],
    );
  }
}

class _CommentEntry {
  final String author;
  final String text;
  final String time;
  const _CommentEntry(this.author, this.text, this.time);
}

class _CommentTile extends StatelessWidget {
  final _CommentEntry comment;
  const _CommentTile({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(8),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.primary.withAlpha(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12.r,
                backgroundColor: AppColors.primary.withAlpha(30),
                child: Text(comment.author[0], style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700, color: AppColors.primary)),
              ),
              SizedBox(width: 8.w),
              Expanded(child: Text(comment.author, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
              Text(comment.time, style: TextStyle(fontSize: 10.sp, color: AppColors.textHint)),
            ],
          ),
          SizedBox(height: 6.h),
          Text(comment.text, style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

// FilterDropdown is defined in common_widgets.dart
typedef _FilterDropdown = FilterDropdown;
