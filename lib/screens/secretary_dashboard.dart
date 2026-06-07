import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../widgets/common_widgets.dart';

class SecretaryDashboard extends StatefulWidget {
  const SecretaryDashboard({super.key});

  @override
  State<SecretaryDashboard> createState() => _SecretaryDashboardState();
}

class _SecretaryDashboardState extends State<SecretaryDashboard> {
  int _selectedIndex = 0;

  final _drawerItems = const [
    DrawerItem('Dashboard', 'ড্যাশবোর্ড', Icons.dashboard_outlined),
    DrawerItem('My Projects', 'আমার প্রকল্প', Icons.folder_outlined),
    DrawerItem(
      'Meeting Minutes',
      'সভার কার্যবিবরণী',
      Icons.description_outlined,
    ),
    DrawerItem('Reports', 'রিপোর্ট', Icons.bar_chart_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UPAppBar(
        title: 'UP@Fingertips',
        subtitle: 'Secretary Dashboard • সচিব ড্যাশবোর্ড',
        notificationCount: 2,
      ),
      drawer: UPDrawer(
        roleName: 'UP Secretary',
        roleNameBangla: 'ইউপি সচিব',
        userName: 'Md. Anwar Hossain',
        userID: 'SEC-FAT-UP01',
        items: _drawerItems,
        selectedIndex: _selectedIndex,
        onItemSelected: (i) => setState(() => _selectedIndex = i),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _SecretaryHome(onNavigate: (i) => setState(() => _selectedIndex = i)),
          const _SecretaryProjects(),
          const _SecretaryMeetingMinutes(),
          const _SecretaryReports(),
        ],
      ),
    );
  }
}

// ─── HOME ────────────────────────────────────────────────────

class _SecretaryHome extends StatelessWidget {
  final void Function(int) onNavigate;
  const _SecretaryHome({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A237E), AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning,',
                        style: TextStyle(
                          color: Colors.white.withAlpha(180),
                          fontSize: 12.sp,
                        ),
                      ),
                      Text(
                        'Md. Anwar Hossain',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'UP Secretary, Fatullah Union',
                        style: TextStyle(
                          color: Colors.white.withAlpha(200),
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'UP Code: BD-NAR-FAT-UP01',
                        style: TextStyle(
                          color: Colors.white.withAlpha(160),
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.manage_accounts_rounded,
                    color: Colors.white,
                    size: 30.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Stats
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: MediaQuery.of(context).size.width < 390
                ? 1.2
                : 1.3,
            children: [
              StatCard(
                label: 'Total Projects',
                banglalabel: 'মোট প্রকল্প',
                value: '$totalProjects',
                icon: Icons.folder_outlined,
                color: AppColors.primary,
                bgColor: AppColors.statusUpcomingBg,
              ),
              StatCard(
                label: 'Upcoming',
                banglalabel: 'আসন্ন',
                value: '$upcomingProjects',
                icon: Icons.upcoming_outlined,
                color: AppColors.primary,
                bgColor: AppColors.statusUpcomingBg,
              ),
              StatCard(
                label: 'Ongoing',
                banglalabel: 'চলমান',
                value: '$ongoingProjects',
                icon: Icons.construction_outlined,
                color: AppColors.statusOngoing,
                bgColor: AppColors.statusOngoingBg,
              ),
              StatCard(
                label: 'Awaiting Approval',
                banglalabel: 'অনুমোদনের অপেক্ষায়',
                value: '$awaitingProjects',
                icon: Icons.hourglass_empty_outlined,
                color: AppColors.statusAwaiting,
                bgColor: AppColors.statusAwaitingBg,
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Action Required
          SectionHeader(
            title: 'Action Required',
            banglaTitle: 'পদক্ষেপ প্রয়োজন',
          ),
          SizedBox(height: 12.h),
          _ActionCard(
            title: 'Road Repair Ward-3',
            subtitle: 'Contractor not yet assigned — needs Details Extension',
            banglaSubtitle: 'চুক্তি বিস্তারিত যোগ করুন',
            color: AppColors.warning,
            bgColor: AppColors.warningLight,
            actionLabel: 'Add Details',
            icon: Icons.edit_note_outlined,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const _ProjectExtendForm(projectName: 'Road Repair Ward-3'),
              ),
            ),
          ),
          _ActionCard(
            title: 'Culvert Construction Ward-7',
            subtitle: 'All work complete — ready for final submission',
            banglaSubtitle: 'সমাপ্তি জমা দিন',
            color: AppColors.success,
            bgColor: AppColors.successLight,
            actionLabel: 'Submit Completion',
            icon: Icons.check_circle_outline,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const _CompletionForm(
                  projectName: 'Culvert Construction Ward-7',
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),

          SectionHeader(
            title: 'All Projects',
            banglaTitle: 'সকল প্রকল্প',
            actionLabel: 'View All',
            onAction: () => onNavigate(1),
          ),
          SizedBox(height: 12.h),
          ...mockProjects.take(3).map((p) {
            String? actionLabel;
            Color? actionColor;
            if (p.status == ProjectStatus.upcoming && p.contractor == null) {
              actionLabel = 'Add Details';
              actionColor = AppColors.warning;
            } else if (p.status == ProjectStatus.ongoing) {
              actionLabel = 'View Progress';
              actionColor = AppColors.primary;
            } else if (p.status == ProjectStatus.awaitingApproval) {
              actionLabel = 'Awaiting Chairman';
              actionColor = AppColors.statusAwaiting;
            }
            return ProjectTile(
              project: p,
              actionLabel: actionLabel,
              actionColor: actionColor,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => _SecretaryProjectView(project: p),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String banglaSubtitle;
  final Color color;
  final Color bgColor;
  final String actionLabel;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.banglaSubtitle,
    required this.color,
    required this.bgColor,
    required this.actionLabel,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: color.withAlpha(60)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    banglaSubtitle,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                actionLabel,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── PROJECT LIST ────────────────────────────────────────────

class _SecretaryProjects extends StatefulWidget {
  const _SecretaryProjects();

  @override
  State<_SecretaryProjects> createState() => _SecretaryProjectsState();
}

class _SecretaryProjectsState extends State<_SecretaryProjects> {
  // Page 5b spec: Ward | Status | Action Required | Search
  String _selectedWard = 'All Wards';
  String _selectedStatus = 'All';
  String _searchQuery = '';
  bool _showFilters = false;
  final _searchCtrl = TextEditingController();

  int get _activeFilters => [
        _selectedWard != 'All Wards',
        _selectedStatus != 'All',
      ].where((b) => b).length;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Project> get _filtered => mockProjects.where((p) {
        if (_selectedWard != 'All Wards' && p.ward != _selectedWard) return false;
        if (_selectedStatus != 'All') {
          if (_selectedStatus == 'Upcoming' && p.status != ProjectStatus.upcoming) return false;
          if (_selectedStatus == 'Ongoing' && p.status != ProjectStatus.ongoing) return false;
          if (_selectedStatus == 'Awaiting Approval' && p.status != ProjectStatus.awaitingApproval) return false;
          if (_selectedStatus == 'Completed' && p.status != ProjectStatus.completed) return false;
        }
        if (_searchQuery.isNotEmpty && !p.name.toLowerCase().contains(_searchQuery.toLowerCase())) return false;
        return true;
      }).toList();

  void _clearAll() => setState(() {
        _selectedWard = 'All Wards';
        _selectedStatus = 'All';
        _searchQuery = '';
        _searchCtrl.clear();
      });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter bar (Page 5b spec)
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
                          hintText: 'Search projects... প্রকল্প খুঁজুন',
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
              if (_showFilters) ...[
                SizedBox(height: 10.h),
                const Divider(height: 1),
                SizedBox(height: 10.h),
                // Row 2: Ward + Status
                Row(
                  children: [
                    Expanded(child: FilterDropdown(label: 'Ward', value: _selectedWard, items: const ['All Wards', 'Ward-1', 'Ward-2', 'Ward-3', 'Ward-4', 'Ward-5', 'Ward-6', 'Ward-7', 'Ward-8', 'Ward-9'], onChanged: (v) => setState(() => _selectedWard = v!))),
                    SizedBox(width: 8.w),
                    Expanded(child: FilterDropdown(label: 'Status', value: _selectedStatus, items: const ['All', 'Upcoming', 'Ongoing', 'Awaiting Approval', 'Completed'], onChanged: (v) => setState(() => _selectedStatus = v!))),
                  ],
                ),
                SizedBox(height: 8.h),
                // Row 3: Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _clearAll,
                        icon: Icon(Icons.clear_all, size: 16.sp),
                        label: Text('Clear All', style: TextStyle(fontSize: 12.sp)),
                        style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 10.h), side: const BorderSide(color: AppColors.divider), foregroundColor: AppColors.textSecondary),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => setState(() => _showFilters = false),
                        icon: Icon(Icons.check, size: 16.sp),
                        label: Text('Apply', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700)),
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
          child: Row(children: [
            Text('${_filtered.length} projects', style: TextStyle(fontSize: 12.sp, color: AppColors.textHint)),
            const Spacer(),
            if (_activeFilters > 0)
              GestureDetector(
                onTap: _clearAll,
                child: Text('Clear filters', style: TextStyle(fontSize: 12.sp, color: AppColors.error)),
              ),
          ]),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: _filtered.length,
            itemBuilder: (_, i) {
              final p = _filtered[i];
              String? actionLabel;
              Color? actionColor;
              if (p.status == ProjectStatus.upcoming && p.contractor == null) {
                actionLabel = 'Add Details';
                actionColor = AppColors.warning;
              } else if (p.status == ProjectStatus.ongoing) {
                actionLabel = 'View Progress';
                actionColor = AppColors.primary;
              } else if (p.status == ProjectStatus.awaitingApproval) {
                actionLabel = 'Submit Completion';
                actionColor = AppColors.statusAwaiting;
              }

              return ProjectTile(
                project: p,
                actionLabel: actionLabel,
                actionColor: actionColor,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => _SecretaryProjectView(project: p),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─── PROJECT VIEW (Secretary hub for all sub-actions) ────────

class _SecretaryProjectView extends StatelessWidget {
  final Project project;
  const _SecretaryProjectView({required this.project});

  @override
  Widget build(BuildContext context) {
    final p = project;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Project',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Text(
              p.ward,
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.white.withAlpha(180),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
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
                  p.id,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textHint,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          InfoCard(
            title: p.name,
            banglaTitle: 'FY ${p.financialYear}',
            children: [
              InfoRow(label: 'Ward', value: p.ward),
              InfoRow(
                label: 'Project Cost',
                value: '৳ ${p.costBDT.toStringAsFixed(0)}',
              ),
              InfoRow(label: 'Start Date', value: p.startDate),
              InfoRow(
                label: 'Engineer',
                value: p.createdByEngineer,
                isLast: true,
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Action buttons based on status
          if (p.status == ProjectStatus.upcoming)
            _SecretaryActionButton(
              title: 'Add Project Details (Post-Tender)',
              banglaTitle: 'প্রকল্পের বিস্তারিত যোগ করুন (টেন্ডারের পরে)',
              subtitle:
                  'Enter contractor, budget, and timeline after offline tender',
              color: AppColors.warning,
              icon: Icons.edit_note_outlined,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => _ProjectExtendForm(projectName: p.name),
                ),
              ),
            ),

          if (p.status == ProjectStatus.ongoing) ...[
            _SecretaryActionButton(
              title: 'View Project Progress',
              banglaTitle: 'প্রকল্পের অগ্রগতি দেখুন',
              subtitle: 'View photos, upload documents',
              color: AppColors.primary,
              icon: Icons.timeline_outlined,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => _ProgressView(project: p)),
              ),
            ),
            SizedBox(height: 2.h),
            _SecretaryActionButton(
              title: 'Submit Completion',
              banglaTitle: 'সমাপ্তি জমা দিন',
              subtitle: 'Upload inspection report and প্রত্যয়ন পত্র',
              color: AppColors.success,
              icon: Icons.check_circle_outline,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => _CompletionForm(projectName: p.name),
                ),
              ),
            ),
          ],

          if (p.status == ProjectStatus.awaitingApproval)
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.statusAwaitingBg,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: AppColors.statusAwaiting.withAlpha(60),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.hourglass_top_outlined,
                    color: AppColors.statusAwaiting,
                    size: 22.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Awaiting Chairman Approval',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.statusAwaiting,
                          ),
                        ),
                        Text(
                          'Submitted for final review. You will be notified once the Chairman approves.',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

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
            children: [
              PhotoPhaseWidget(phases: mockVideoPhases, isVideo: true),
            ],
          ),
          SizedBox(height: 12.h),
          InfoCard(
            title: 'Committee Members',
            banglaTitle: 'কমিটি সদস্যগণ',
            children: [
              for (int i = 0; i < p.committee.length; i++)
                CommitteeMemberTile(
                  member: p.committee[i],
                  isLast: i == p.committee.length - 1,
                ),
            ],
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

class _SecretaryActionButton extends StatelessWidget {
  final String title, banglaTitle, subtitle;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;
  const _SecretaryActionButton({
    required this.title,
    required this.banglaTitle,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: color.withAlpha(10),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: color.withAlpha(60)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  Text(
                    banglaTitle,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.textHint,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}

// ─── PROJECT EXTENSION FORM (Post-Tender) ────────────────────

class _ProjectExtendForm extends StatefulWidget {
  final String projectName;
  const _ProjectExtendForm({required this.projectName});

  @override
  State<_ProjectExtendForm> createState() => _ProjectExtendFormState();
}

class _ProjectExtendFormState extends State<_ProjectExtendForm> {
  final List<CommitteeMember> _secretaryMembers = [];
  bool _showAddForm = false;
  final _nameCtrl = TextEditingController();
  final _designCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _designCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _saveMember() {
    final name = _nameCtrl.text.trim();
    final design = _designCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    if (name.isEmpty || design.isEmpty) return;
    setState(() {
      _secretaryMembers.add(
        CommitteeMember(
          name: name,
          designation: design,
          ward: 'Ward-3',
          mobile: phone.isEmpty ? '—' : phone,
        ),
      );
      _nameCtrl.clear();
      _designCtrl.clear();
      _phoneCtrl.clear();
      _showAddForm = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Details Extension',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Text(
              'Post-Tender • টেন্ডারের পরে',
              style: TextStyle(fontSize: 11.sp, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.warningLight,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.warning.withAlpha(60)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.warning,
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Tender done offline. Enter contractor details selected on paper.\nProject: ${widget.projectName}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // A: Contractor Details
            _ExtendSection(
              title: 'A. Contractor Details',
              banglaTitle: 'ঠিকাদারের বিবরণ',
              children: [
                const _ExtField(
                  'Contractor Name',
                  'ঠিকাদারের নাম',
                  required: true,
                ),
                const _ExtField('Business Name', 'ব্যবসার নাম'),
                const _ExtField(
                  'Mobile Number',
                  'মোবাইল নম্বর',
                  required: true,
                  keyboard: TextInputType.phone,
                ),
                const _ExtField('Trade License No.', 'ট্রেড লাইসেন্স নম্বর'),
                const _ExtField('Vendor ID (if registered)', 'ভেন্ডর আইডি'),
              ],
            ),
            SizedBox(height: 16.h),

            // B: Budget & Timeline
            _ExtendSection(
              title: 'B. Budget & Timeline',
              banglaTitle: 'বাজেট ও সময়সীমা',
              children: [
                const _ExtField(
                  'Estimated Budget (BDT)',
                  'আনুমানিক বাজেট',
                  required: true,
                  keyboard: TextInputType.number,
                  prefix: '৳ ',
                ),
                Row(
                  children: [
                    const Expanded(
                      child: _ExtField(
                        'Duration',
                        'সময়কাল',
                        required: true,
                        keyboard: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: FilterDropdown(
                        label: 'Unit',
                        value: 'Days',
                        items: const ['Days', 'Weeks', 'Months'],
                        onChanged: (_) {},
                      ),
                    ),
                  ],
                ),
                const _ExtField(
                  'Date of Project Start',
                  'কাজ শুরুর তারিখ',
                  required: true,
                  suffix: Icons.calendar_today_outlined,
                ),
                const _ExtField(
                  'Expected Completion',
                  'আনুমানিক সমাপ্তি',
                  required: true,
                  suffix: Icons.event_outlined,
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // C: Ward Member
            _ExtendSection(
              title: 'C. Ward Member',
              banglaTitle: 'ওয়ার্ড সদস্য',
              children: [
                const FormFieldLabel(
                  label: 'Ward Member',
                  banglaLabel: 'ওয়ার্ড সদস্য',
                  required: true,
                ),
                FilterDropdown(
                  label: 'Member',
                  value: 'Md. Rafiq (Ward-3)',
                  items: const ['Md. Rafiq (Ward-3)', 'Nur Islam (Ward-3)'],
                  onChanged: (_) {},
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // D: Committee confirmation
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.success.withAlpha(60)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Icon(
                        Icons.group_outlined,
                        color: AppColors.success,
                        size: 16.sp,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'D. Scheme Supervision Committee',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'স্কিম তদারকি কমিটি',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textHint,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Engineer-added members (read-only)
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: AppColors.success.withAlpha(40),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lock_outline,
                              size: 12.sp,
                              color: AppColors.textHint,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Engineer-added — read only',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: AppColors.textHint,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        for (int i = 0; i < mockCommittee1.length; i++)
                          CommitteeMemberTile(
                            member: mockCommittee1[i],
                            isLast: i == mockCommittee1.length - 1,
                          ),
                      ],
                    ),
                  ),

                  // Secretary-added members
                  if (_secretaryMembers.isNotEmpty) ...[
                    SizedBox(height: 10.h),
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: AppColors.primary.withAlpha(40),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.person_add_outlined,
                                size: 12.sp,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'Secretary-added members',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: AppColors.primary,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          for (int i = 0; i < _secretaryMembers.length; i++)
                            CommitteeMemberTile(
                              member: _secretaryMembers[i],
                              isLast: i == _secretaryMembers.length - 1,
                            ),
                        ],
                      ),
                    ),
                  ],

                  SizedBox(height: 10.h),

                  // Inline Add-Member Form
                  if (_showAddForm) ...[
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: AppColors.primary.withAlpha(60),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'New Member Details',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          TextField(
                            controller: _nameCtrl,
                            decoration: InputDecoration(
                              labelText: 'Full Name • পূর্ণ নাম',
                              labelStyle: TextStyle(fontSize: 12.sp),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              filled: true,
                              fillColor: AppColors.surface,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 10.h,
                              ),
                            ),
                            style: TextStyle(fontSize: 13.sp),
                          ),
                          SizedBox(height: 8.h),
                          TextField(
                            controller: _designCtrl,
                            decoration: InputDecoration(
                              labelText: 'Designation • পদবি',
                              labelStyle: TextStyle(fontSize: 12.sp),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              filled: true,
                              fillColor: AppColors.surface,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 10.h,
                              ),
                            ),
                            style: TextStyle(fontSize: 13.sp),
                          ),
                          SizedBox(height: 8.h),
                          TextField(
                            controller: _phoneCtrl,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Phone • মোবাইল (optional)',
                              labelStyle: TextStyle(fontSize: 12.sp),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              filled: true,
                              fillColor: AppColors.surface,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 10.h,
                              ),
                            ),
                            style: TextStyle(fontSize: 13.sp),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () =>
                                      setState(() => _showAddForm = false),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.textSecondary,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.h,
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(fontSize: 13.sp),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _saveMember,
                                  icon: Icon(Icons.check_rounded, size: 16.sp),
                                  label: Text(
                                    'Save Member',
                                    style: TextStyle(fontSize: 13.sp),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.h,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                  ],

                  // Add More Members button
                  if (!_showAddForm)
                    OutlinedButton.icon(
                      onPressed: () => setState(() => _showAddForm = true),
                      icon: Icon(Icons.person_add_outlined, size: 14.sp),
                      label: Text(
                        '+ Add More Members',
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 8.h,
                        ),
                        side: const BorderSide(color: AppColors.success),
                        foregroundColor: AppColors.success,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _confirm(context),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  backgroundColor: AppColors.primary,
                ),
                child: Text(
                  'Submit Extension • বিস্তারিত জমা দিন',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  void _confirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text('Submit Extension?', style: TextStyle(fontSize: 16.sp)),
        content: Text(
          'Status will change to Ongoing. Ward Member and Committee members will be notified.\n\nওয়ার্ড সদস্য ও কমিটি সদস্যরা অবহিত হবেন।',
          style: TextStyle(fontSize: 13.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Extension submitted! Project is now Ongoing.',
                  ),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

class _ExtendSection extends StatelessWidget {
  final String title, banglaTitle;
  final List<Widget> children;
  const _ExtendSection({
    required this.title,
    required this.banglaTitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            banglaTitle,
            style: TextStyle(fontSize: 11.sp, color: AppColors.textHint),
          ),
          SizedBox(height: 12.h),
          const Divider(height: 1),
          SizedBox(height: 12.h),
          ...children,
        ],
      ),
    );
  }
}

class _ExtField extends StatelessWidget {
  final String label, banglaLabel;
  final bool required;
  final TextInputType keyboard;
  final String? prefix;
  final IconData? suffix;
  const _ExtField(
    this.label,
    this.banglaLabel, {
    this.required = false,
    this.keyboard = TextInputType.text,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormFieldLabel(
            label: label,
            banglaLabel: banglaLabel,
            required: required,
          ),
          TextField(
            keyboardType: keyboard,
            decoration: InputDecoration(
              prefixText: prefix,
              suffixIcon: suffix != null
                  ? Icon(suffix, size: 16.sp, color: AppColors.textHint)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── PROGRESS VIEW ───────────────────────────────────────────

class _ProgressView extends StatefulWidget {
  final Project project;
  const _ProgressView({required this.project});

  @override
  State<_ProgressView> createState() => _ProgressViewState();
}

class _ProgressViewState extends State<_ProgressView> {
  bool _showUploadModal = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Project Progress',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Text(
              'অগ্রগতি',
              style: TextStyle(fontSize: 11.sp, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress bar
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ProgressStep(label: 'Started', active: true, done: true),
                      _ProgressConnector(done: true),
                      _ProgressStep(
                        label: 'In Progress',
                        active: true,
                        done: false,
                      ),
                      _ProgressConnector(done: false),
                      _ProgressStep(
                        label: 'Completed',
                        active: false,
                        done: false,
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: const LinearProgressIndicator(
                      value: 0.6,
                      minHeight: 8,
                      backgroundColor: AppColors.background,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.statusOngoing,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '60% Complete',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.statusOngoing,
                        ),
                      ),
                      Text(
                        'Est. Completion: Jun 30, 2026',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Photos by phase
            InfoCard(
              title: 'Progress Photos by Phase',
              banglaTitle: 'পর্যায় অনুযায়ী ছবি',
              children: [PhotoPhaseWidget(phases: mockPhotoPhases)],
            ),
            SizedBox(height: 16.h),

            // Videos by phase
            InfoCard(
              title: 'Progress Videos by Phase',
              banglaTitle: 'পর্যায় অনুযায়ী ভিডিও',
              children: [PhotoPhaseWidget(phases: mockVideoPhases, isVideo: true)],
            ),
            SizedBox(height: 16.h),

            // Documents
            InfoCard(
              title: 'Uploaded Documents',
              banglaTitle: 'আপলোডকৃত নথি',
              trailing: GestureDetector(
                onTap: () =>
                    setState(() => _showUploadModal = !_showUploadModal),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(15),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.upload_outlined,
                        size: 14.sp,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Upload',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              children: [
                for (final doc in widget.project.documentNames)
                  _DocRow(name: doc),
                if (_showUploadModal) ...[
                  const Divider(height: 16),
                  const SectionHeader(
                    title: 'Upload Document',
                    banglaTitle: 'নথি আপলোড',
                  ),
                  SizedBox(height: 10.h),
                  const FormFieldLabel(
                    label: 'Document Name',
                    banglaLabel: 'নথির নাম',
                  ),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'e.g. Running Bill 2',
                    ),
                  ),
                  SizedBox(height: 10.h),
                  const FormFieldLabel(
                    label: 'Document Type',
                    banglaLabel: 'নথির ধরন',
                  ),
                  FilterDropdown(
                    label: 'Type',
                    value: 'Running Bill',
                    items: const [
                      'Running Bill',
                      'Finished Bill',
                      'Other Document',
                    ],
                    onChanged: (_) {},
                  ),
                  SizedBox(height: 10.h),
                  const UploadArea(
                    label: 'File',
                    banglaLabel: 'ফাইল',
                    hint: 'PDF or JPG — max 10MB',
                    required: true,
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Upload Document'),
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 24.h),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        _CompletionForm(projectName: widget.project.name),
                  ),
                ),
                icon: Icon(Icons.check_circle_outline, size: 18.sp),
                label: Text(
                  'Submit Completion • সমাপ্তি জমা দিন',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  backgroundColor: AppColors.success,
                ),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}

class _ProgressStep extends StatelessWidget {
  final String label;
  final bool active, done;
  const _ProgressStep({
    required this.label,
    required this.active,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    final color = done
        ? AppColors.success
        : active
        ? AppColors.statusOngoing
        : AppColors.textHint;
    return Column(
      children: [
        Container(
          width: 28.w,
          height: 28.h,
          decoration: BoxDecoration(
            color: done
                ? AppColors.success
                : active
                ? AppColors.statusOngoingBg
                : AppColors.greyLight,
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2.w),
          ),
          child: Icon(
            done ? Icons.check : Icons.circle,
            size: 14.sp,
            color: color,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 9.sp,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ProgressConnector extends StatelessWidget {
  final bool done;
  const _ProgressConnector({required this.done});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2.h,
        margin: EdgeInsets.only(bottom: 16.h),
        color: done ? AppColors.success : AppColors.divider,
      ),
    );
  }
}

class _DocRow extends StatelessWidget {
  final String name;
  const _DocRow({required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(
            Icons.picture_as_pdf_outlined,
            size: 18.sp,
            color: AppColors.error,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(name, style: TextStyle(fontSize: 13.sp)),
          ),
          Icon(Icons.download_outlined, size: 18.sp, color: AppColors.primary),
        ],
      ),
    );
  }
}

// ─── COMPLETION FORM ─────────────────────────────────────────

class _CompletionForm extends StatefulWidget {
  final String projectName;
  const _CompletionForm({required this.projectName});

  @override
  State<_CompletionForm> createState() => _CompletionFormState();
}

class _CompletionFormState extends State<_CompletionForm> {
  bool _certificateSigned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Completion Submission',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Text(
              'সমাপ্তি জমা • Final Step',
              style: TextStyle(fontSize: 11.sp, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.success.withAlpha(60)),
              ),
              child: Text(
                'Project: ${widget.projectName}\n\nThis is the final step before Chairman review. All documents must be ready.',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // A: Inspection Report
            _ExtendSection(
              title: 'A. Final Inspection Report',
              banglaTitle: 'চূড়ান্ত পরিদর্শন রিপোর্ট',
              children: [
                const UploadArea(
                  label: 'Inspection Report (PDF)',
                  banglaLabel: 'পরিদর্শন রিপোর্ট',
                  hint: 'Upload the last inspection report PDF',
                  required: true,
                  icon: Icons.upload_file_outlined,
                ),
                SizedBox(height: 12.h),
                const _ExtField(
                  'Inspection Date',
                  'পরিদর্শনের তারিখ',
                  required: true,
                  suffix: Icons.calendar_today_outlined,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Inspector Name • পরিদর্শকের নাম',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Md. Anwar Hossain (Secretary)',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Icon(
                        Icons.lock_outlined,
                        size: 14.sp,
                        color: AppColors.textHint,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // B: Final Photos
            _ExtendSection(
              title: 'B. Final Situation Photos',
              banglaTitle: 'চূড়ান্ত অবস্থার ছবি',
              children: [
                const UploadArea(
                  label: 'Final Photos',
                  banglaLabel: 'চূড়ান্ত ছবি',
                  hint:
                      'Upload min. 2 photos showing the finished project\nJPG, PNG — multiple allowed',
                  required: true,
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // C: প্রত্যয়ন পত্র
            _ExtendSection(
              title: 'C. প্রত্যয়ন পত্র',
              banglaTitle: 'Completion Certificate',
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.warningLight,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColors.warning.withAlpha(60)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_outlined,
                        color: AppColors.warning,
                        size: 16.sp,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'Must be physically signed by Ward Member + all Scheme Supervision Committee members BEFORE scanning and uploading.',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                const UploadArea(
                  label: 'Scanned প্রত্যয়ন পত্র',
                  banglaLabel: 'স্ক্যান করা প্রত্যয়ন পত্র',
                  hint: 'Upload signed scanned copy\nPDF or JPG — max 10MB',
                  required: true,
                  icon: Icons.document_scanner_outlined,
                ),
                SizedBox(height: 12.h),
                InkWell(
                  onTap: () =>
                      setState(() => _certificateSigned = !_certificateSigned),
                  borderRadius: BorderRadius.circular(10.r),
                  child: Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: _certificateSigned
                          ? AppColors.successLight
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: _certificateSigned
                            ? AppColors.success
                            : AppColors.divider,
                        width: 1.5.w,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _certificateSigned
                              ? Icons.check_box_rounded
                              : Icons.check_box_outline_blank_rounded,
                          color: _certificateSigned
                              ? AppColors.success
                              : AppColors.textHint,
                          size: 22.sp,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            'I confirm the প্রত্যয়ন পত্র has been physically signed by the Ward Member and all Scheme Supervision Committee members.',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // D: Remarks
            _ExtendSection(
              title: 'D. Secretary\'s Remarks',
              banglaTitle: 'সচিবের মন্তব্য',
              children: [
                TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText:
                        'Optional remarks about the project completion...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: const BorderSide(color: AppColors.divider),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: const BorderSide(color: AppColors.divider),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                    filled: true,
                    fillColor: AppColors.background,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _certificateSigned
                    ? () => _submitCompletion(context)
                    : null,
                icon: Icon(Icons.flag_outlined, size: 18.sp),
                label: Text(
                  'Mark as Finished • সম্পন্ন হিসেবে চিহ্নিত করুন',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  backgroundColor: AppColors.success,
                  disabledBackgroundColor: AppColors.greyLight,
                ),
              ),
            ),
            if (!_certificateSigned)
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Text(
                    'Please confirm the প্রত্যয়ন পত্র is signed before submitting',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textHint,
                    ),
                  ),
                ),
              ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  void _submitCompletion(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            const Icon(Icons.flag_outlined, color: AppColors.success),
            SizedBox(width: 8.w),
            Text(
              'Submit for Chairman Review?',
              style: TextStyle(fontSize: 15.sp),
            ),
          ],
        ),
        content: Text(
          'This cannot be undone. The project will be sent to the UP Chairman for final approval.\n\nচেয়ারম্যান অবহিত হবেন।',
          style: TextStyle(fontSize: 13.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Sent to Chairman for final approval! Status: Awaiting Approval',
                  ),
                  backgroundColor: AppColors.statusAwaiting,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

// ─── MEETING MINUTES FORM ────────────────────────────────────

class _SecretaryMeetingMinutes extends StatelessWidget {
  const _SecretaryMeetingMinutes();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Submit Meeting Minutes',
            banglaTitle: 'সভার কার্যবিবরণী জমা দিন',
          ),
          SizedBox(height: 16.h),
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
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FormFieldLabel(
                            label: 'Meeting Date',
                            banglaLabel: 'সভার তারিখ',
                            required: true,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Select date',
                              suffixIcon: Icon(
                                Icons.calendar_today_outlined,
                                size: 16.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FormFieldLabel(
                            label: 'Meeting Type',
                            banglaLabel: 'সভার ধরন',
                            required: true,
                          ),
                          FilterDropdown(
                            label: 'Type',
                            value: 'Monthly',
                            items: const ['Monthly', 'Emergency', 'Special'],
                            onChanged: (_) {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                const FormFieldLabel(
                  label: 'Attendees',
                  banglaLabel: 'উপস্থিত সদস্যগণ',
                  required: true,
                ),
                TextFormField(
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'List all present members...',
                  ),
                ),
                SizedBox(height: 14.h),
                const FormFieldLabel(
                  label: 'Discussion / আলোচনা',
                  banglaLabel: 'আলোচনা',
                  required: true,
                ),
                TextFormField(
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText:
                        '১। প্রথম আলোচনার বিষয়...\n২। দ্বিতীয় আলোচনার বিষয়...',
                  ),
                ),
                SizedBox(height: 14.h),
                const FormFieldLabel(
                  label: 'Decision / সিদ্ধান্ত',
                  banglaLabel: 'সিদ্ধান্ত',
                  required: true,
                ),
                TextFormField(
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: '১। প্রথম সিদ্ধান্ত...\n২। দ্বিতীয় সিদ্ধান্ত...',
                  ),
                ),
                SizedBox(height: 14.h),
                const UploadArea(
                  label: 'Attach Document (Optional)',
                  banglaLabel: 'নথি সংযুক্ত করুন',
                  hint: 'PDF, DOC, JPG — optional attachment',
                  icon: Icons.attach_file_outlined,
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                        child: const Text('Save Draft'),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                        child: const Text('Submit Minutes • জমা দিন'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          const SectionHeader(
            title: 'Past Minutes',
            banglaTitle: 'আগের কার্যবিবরণী',
          ),
          SizedBox(height: 12.h),
          for (final m in mockMeetingMinutes)
            Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: AppColors.purple.withAlpha(15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.description_outlined,
                      color: AppColors.purple,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${m.meetingType} Meeting',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          m.meetingDate,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.visibility_outlined,
                          color: AppColors.primary,
                          size: 20.sp,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.download_outlined,
                          color: AppColors.textHint,
                          size: 20.sp,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

// ─── REPORTS ─────────────────────────────────────────────────

class _SecretaryReports extends StatelessWidget {
  const _SecretaryReports();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Reports', banglaTitle: 'রিপোর্ট'),
          SizedBox(height: 16.h),
          for (final item in [
            [
              'Project Summary',
              'প্রকল্প সারসংক্ষেপ',
              'All project statuses for current FY',
              Icons.folder_outlined,
            ],
            [
              'Ward-wise Projects',
              'ওয়ার্ড ভিত্তিক প্রকল্প',
              'Projects sorted by ward',
              Icons.location_city_outlined,
            ],
            [
              'Meeting Minutes Archive',
              'সভার কার্যবিবরণী আর্কাইভ',
              'All submitted minutes',
              Icons.archive_outlined,
            ],
          ])
            Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(15),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      item[3] as IconData,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item[0] as String,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          item[1] as String,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.textHint,
                          ),
                        ),
                        Text(
                          item[2] as String,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.download_outlined, color: AppColors.primary),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
