import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../widgets/common_widgets.dart';

// ─── MOCK WARD MEMBER PROFILE ─────────────────────────────────

class _WardProfile {
  final String name, banglName, ward, union, upCode, mobile, memberId;
  const _WardProfile({
    required this.name,
    required this.banglName,
    required this.ward,
    required this.union,
    required this.upCode,
    required this.mobile,
    required this.memberId,
  });
}

const _kMember = _WardProfile(
  name: 'Md. Rafiq Uddin',
  banglName: 'মো. রফিক উদ্দিন',
  ward: 'Ward-3',
  union: 'Fatullah Union',
  upCode: 'BD-NAR-FAT-UP01',
  mobile: '01711-654321',
  memberId: 'WM-FAT-W03-001',
);

// ─── MOCK WARD NOTICES ────────────────────────────────────────

class _WardNotice {
  final String id, title, banglaTitle, body, date, category, issuedBy;
  const _WardNotice({
    required this.id,
    required this.title,
    required this.banglaTitle,
    required this.body,
    required this.date,
    required this.category,
    required this.issuedBy,
  });
}

const _mockNotices = [
  _WardNotice(
    id: 'N-001',
    title: 'Monthly Committee Meeting — June 2026',
    banglaTitle: 'মাসিক কমিটি সভা — জুন ২০২৬',
    body:
        'All Ward-3 Scheme Supervision Committee members are requested to attend the monthly review meeting on 15th June 2026 at 10:00 AM at the UP office.',
    date: '2026-06-08',
    category: 'Meeting',
    issuedBy: 'UP Secretary — Md. Anwar Hossain',
  ),
  _WardNotice(
    id: 'N-002',
    title: 'Progress Photo Submission Reminder',
    banglaTitle: 'অগ্রগতি ছবি জমার অনুস্মারক',
    body:
        'Please submit Middle-2 phase progress photos for "Road Repair Near Fatullah Bazar Ward-3" by 20th June 2026. Photos must be taken at the work site.',
    date: '2026-06-07',
    category: 'Reminder',
    issuedBy: 'Upazila Engineer — Eng. Md. Shahidul Islam',
  ),
  _WardNotice(
    id: 'N-003',
    title: 'Ward-3 Project Site Inspection',
    banglaTitle: 'ওয়ার্ড-৩ প্রকল্পস্থল পরিদর্শন',
    body:
        'UNO office will conduct a surprise inspection of the road repair site on Ward-3 within the next 7 days. Ensure all committee members are available.',
    date: '2026-06-05',
    category: 'Inspection',
    issuedBy: 'UNO Office — Fatullah Upazila',
  ),
  _WardNotice(
    id: 'N-004',
    title: 'প্রত্যয়ন পত্র Preparation Notice',
    banglaTitle: 'প্রত্যয়ন পত্র প্রস্তুতির নোটিশ',
    body:
        'Ward Member signature is required on the প্রত্যয়ন পত্র before the Secretary submits project completion. Please contact the UP office at your earliest.',
    date: '2026-05-30',
    category: 'Document',
    issuedBy: 'UP Secretary — Md. Anwar Hossain',
  ),
];

// ─── MAIN DASHBOARD ───────────────────────────────────────────

class WardMemberDashboard extends StatefulWidget {
  const WardMemberDashboard({super.key});

  @override
  State<WardMemberDashboard> createState() => _WardMemberDashboardState();
}

class _WardMemberDashboardState extends State<WardMemberDashboard> {
  int _selectedIndex = 0;

  final _drawerItems = const [
    DrawerItem('Dashboard', 'ড্যাশবোর্ড', Icons.home_outlined),
    DrawerItem('My Projects', 'আমার প্রকল্প', Icons.folder_outlined),
    DrawerItem('Upload Photos', 'ছবি আপলোড', Icons.camera_alt_outlined),
    DrawerItem('Notices', 'নোটিশ', Icons.notifications_outlined),
  ];

  List<Project> get _wardProjects =>
      mockProjects.where((p) => p.ward == _kMember.ward).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UPAppBar(
        title: 'UP@Fingertips',
        subtitle: 'Ward Member • ওয়ার্ড সদস্য',
        notificationCount: 2,
      ),
      drawer: UPDrawer(
        roleName: 'Ward Member',
        roleNameBangla: 'ওয়ার্ড সদস্য',
        userName: _kMember.name,
        userID: _kMember.memberId,
        items: _drawerItems,
        selectedIndex: _selectedIndex,
        onItemSelected: (i) => setState(() => _selectedIndex = i),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _WardHome(
            projects: _wardProjects,
            onNavigate: (i) => setState(() => _selectedIndex = i),
          ),
          _WardProjectList(projects: _wardProjects),
          _WardPhotoSelector(
            wardProjects: _wardProjects
                .where((p) => p.status == ProjectStatus.ongoing)
                .toList(),
          ),
          const _WardNoticesPage(),
        ],
      ),
    );
  }
}

// ─── PAGE 1 : HOME ────────────────────────────────────────────

class _WardHome extends StatelessWidget {
  final List<Project> projects;
  final void Function(int) onNavigate;
  const _WardHome({required this.projects, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final ongoing = projects
        .where((p) => p.status == ProjectStatus.ongoing)
        .length;
    final completed = projects
        .where((p) => p.status == ProjectStatus.completed)
        .length;
    final upcoming = projects
        .where((p) => p.status == ProjectStatus.upcoming)
        .length;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28.r,
                  backgroundColor: Colors.white.withAlpha(40),
                  child: Text(
                    _kMember.name[0],
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _kMember.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _kMember.banglName,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 12.sp,
                            color: Colors.white70,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${_kMember.ward} • ${_kMember.union}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(30),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.white.withAlpha(60)),
                  ),
                  child: Text(
                    'Ward Member\nওয়ার্ড সদস্য',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Stat cards
          SectionHeader(
            title: 'My Ward Projects',
            banglaTitle: '${_kMember.ward} প্রকল্প সমূহ',
          ),
          SizedBox(height: 10.h),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.3,
            children: [
              StatCard(
                label: 'Total',
                banglalabel: 'মোট',
                value: '${projects.length}',
                icon: Icons.folder_outlined,
                color: AppColors.primary,
                bgColor: AppColors.primaryLight.withAlpha(30),
                onTap: () => onNavigate(1),
              ),
              StatCard(
                label: 'Ongoing',
                banglalabel: 'চলমান',
                value: '$ongoing',
                icon: Icons.construction_outlined,
                color: AppColors.statusOngoing,
                bgColor: AppColors.statusOngoingBg,
                onTap: () => onNavigate(1),
              ),
              StatCard(
                label: 'Completed',
                banglalabel: 'সম্পন্ন',
                value: '$completed',
                icon: Icons.check_circle_outline,
                color: AppColors.statusCompleted,
                bgColor: AppColors.statusCompletedBg,
                onTap: () => onNavigate(1),
              ),
              StatCard(
                label: 'Upcoming',
                banglalabel: 'আসন্ন',
                value: '$upcoming',
                icon: Icons.upcoming_outlined,
                color: AppColors.statusUpcoming,
                bgColor: AppColors.statusUpcomingBg,
                onTap: () => onNavigate(1),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Quick actions
          SectionHeader(title: 'Quick Actions', banglaTitle: 'দ্রুত কার্যক্রম'),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: _QuickActionCard(
                  icon: Icons.camera_alt_outlined,
                  label: 'Upload Photos',
                  banglaLabel: 'ছবি আপলোড',
                  color: AppColors.primary,
                  onTap: () => onNavigate(2),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _QuickActionCard(
                  icon: Icons.notifications_outlined,
                  label: 'View Notices',
                  banglaLabel: 'নোটিশ দেখুন',
                  color: const Color(0xFF7B1FA2),
                  onTap: () => onNavigate(3),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Pending action banner (if ongoing projects exist)
          if (ongoing > 0) ...[
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.warningLight,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.warning.withAlpha(80)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withAlpha(25),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.warning,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Photos Required',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.warning,
                          ),
                        ),
                        Text(
                          '$ongoing ongoing project${ongoing > 1 ? "s" : ""} need progress photos',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onNavigate(2),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warning,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Upload',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
          ],

          // Recent projects
          SectionHeader(
            title: 'Ward Projects',
            banglaTitle: '${_kMember.ward} প্রকল্প তালিকা',
          ),
          SizedBox(height: 10.h),
          if (projects.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Text(
                  'No projects in ${_kMember.ward}',
                  style: TextStyle(fontSize: 13.sp, color: AppColors.textHint),
                ),
              ),
            )
          else
            ...projects.map(
              (p) => _WardProjectTile(
                project: p,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => _WardProjectDetail(project: p),
                  ),
                ),
                onUpload: p.status == ProjectStatus.ongoing
                    ? () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => _WardPhotoUploadPage(project: p),
                        ),
                      )
                    : null,
              ),
            ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

// ─── PAGE 2 : PROJECT LIST ────────────────────────────────────

class _WardProjectList extends StatefulWidget {
  final List<Project> projects;
  const _WardProjectList({required this.projects});

  @override
  State<_WardProjectList> createState() => _WardProjectListState();
}

class _WardProjectListState extends State<_WardProjectList> {
  String _filter = 'All';
  final _filters = ['All', 'Ongoing', 'Upcoming', 'Completed', 'Awaiting'];

  List<Project> get _filtered {
    if (_filter == 'All') return widget.projects;
    return widget.projects.where((p) {
      switch (_filter) {
        case 'Ongoing':
          return p.status == ProjectStatus.ongoing;
        case 'Upcoming':
          return p.status == ProjectStatus.upcoming;
        case 'Completed':
          return p.status == ProjectStatus.completed;
        case 'Awaiting':
          return p.status == ProjectStatus.awaitingApproval;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter bar
        Container(
          color: AppColors.surface,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_kMember.ward} — ${_kMember.union}',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Showing ${_filtered.length} project${_filtered.length != 1 ? "s" : ""}',
                style: TextStyle(fontSize: 11.sp, color: AppColors.textHint),
              ),
              SizedBox(height: 8.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((f) {
                    final selected = _filter == f;
                    return GestureDetector(
                      onTap: () => setState(() => _filter = f),
                      child: Container(
                        margin: EdgeInsets.only(right: 8.w),
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primary
                              : AppColors.background,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: selected
                                ? AppColors.primary
                                : AppColors.divider,
                          ),
                        ),
                        child: Text(
                          f,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: selected
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // List
        Expanded(
          child: _filtered.isEmpty
              ? Center(
                  child: Text(
                    'No $_filter projects in ${_kMember.ward}',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textHint,
                    ),
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: _filtered.length,
                  separatorBuilder: (_, _) => SizedBox(height: 12.h),
                  itemBuilder: (_, i) {
                    final p = _filtered[i];
                    return _WardProjectTile(
                      project: p,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => _WardProjectDetail(project: p),
                        ),
                      ),
                      onUpload: p.status == ProjectStatus.ongoing
                          ? () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    _WardPhotoUploadPage(project: p),
                              ),
                            )
                          : null,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// ─── PAGE 3 : PHOTO UPLOAD SELECTOR ──────────────────────────

class _WardPhotoSelector extends StatelessWidget {
  final List<Project> wardProjects;
  const _WardPhotoSelector({required this.wardProjects});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info banner
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(12),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.primary.withAlpha(60)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.primary, size: 16.sp),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select a project to upload photos',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        'Only ongoing projects are listed below • ক্যামেরা ব্যবহার করে ছবি তুলুন',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          SectionHeader(
            title: 'Ongoing Projects',
            banglaTitle: 'চলমান প্রকল্প সমূহ',
          ),
          SizedBox(height: 10.h),

          if (wardProjects.isEmpty)
            Container(
              padding: EdgeInsets.all(32.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.divider),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 44.sp,
                      color: AppColors.textHint,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'No ongoing projects in ${_kMember.ward}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textHint,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            ...wardProjects.map(
              (p) => _UploadSelectCard(
                project: p,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => _WardPhotoUploadPage(project: p),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── PAGE 4 : NOTICES ────────────────────────────────────────

class _WardNoticesPage extends StatefulWidget {
  const _WardNoticesPage();

  @override
  State<_WardNoticesPage> createState() => _WardNoticesPageState();
}

class _WardNoticesPageState extends State<_WardNoticesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.surface,
          child: TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textHint,
            indicatorColor: AppColors.primary,
            labelStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
            unselectedLabelStyle: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
            tabs: [
              Tab(text: 'Notices • নোটিশ'),
              Tab(text: 'Meeting Minutes'),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [_NoticesList(), _MeetingMinutesList()],
          ),
        ),
      ],
    );
  }
}

class _NoticesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: _mockNotices.length,
      separatorBuilder: (_, _) => SizedBox(height: 12.h),
      itemBuilder: (_, i) {
        final n = _mockNotices[i];
        final categoryColor = _categoryColor(n.category);
        return GestureDetector(
          onTap: () => _showNoticeDetail(context, n),
          child: Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.divider),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 6.r,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: categoryColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        n.category,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: categoryColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 11.sp,
                      color: AppColors.textHint,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      n.date,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  n.title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  n.banglaTitle,
                  style: TextStyle(fontSize: 11.sp, color: AppColors.textHint),
                ),
                SizedBox(height: 6.h),
                Text(
                  n.body,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 12.sp,
                      color: AppColors.textHint,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        n.issuedBy,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textHint,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      'Read more →',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'Meeting':
        return AppColors.primary;
      case 'Reminder':
        return AppColors.warning;
      case 'Inspection':
        return AppColors.statusOngoing;
      case 'Document':
        return const Color(0xFF7B1FA2);
      default:
        return AppColors.textSecondary;
    }
  }

  void _showNoticeDetail(BuildContext context, _WardNotice n) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        builder: (_, ctrl) => Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                width: 36.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: ctrl,
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: _categoryColor(n.category).withAlpha(25),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        n.category,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: _categoryColor(n.category),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      n.title,
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      n.banglaTitle,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textHint,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    const Divider(),
                    SizedBox(height: 12.h),
                    Text(
                      n.body,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 14.sp,
                            color: AppColors.textHint,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Issued by',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: AppColors.textHint,
                                  ),
                                ),
                                Text(
                                  n.issuedBy,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Date',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: AppColors.textHint,
                                ),
                              ),
                              Text(
                                n.date,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MeetingMinutesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: mockMeetingMinutes.length,
      separatorBuilder: (_, _) => SizedBox(height: 12.h),
      itemBuilder: (_, i) {
        final m = mockMeetingMinutes[i];
        return GestureDetector(
          onTap: () => _showMinutesDetail(context, m),
          child: Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.divider),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 6.r,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(15),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.description_outlined,
                    color: AppColors.primary,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${m.meetingType} Meeting Minutes',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        m.unionName,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textHint,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 11.sp,
                            color: AppColors.textHint,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            m.meetingDate,
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
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textHint,
                  size: 20.sp,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMinutesDetail(BuildContext context, MeetingMinutes m) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        builder: (_, ctrl) => Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                width: 36.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: ctrl,
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
                  children: [
                    Text(
                      '${m.meetingType} Meeting Minutes',
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'সভার কার্যবিবরণী',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textHint,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    InfoRow(label: 'Union', value: m.unionName),
                    InfoRow(label: 'Meeting Date', value: m.meetingDate),
                    InfoRow(label: 'Submitted By', value: m.submittedBy),
                    SizedBox(height: 12.h),
                    const Divider(),
                    SizedBox(height: 10.h),
                    Text(
                      'Attendees / উপস্থিতি',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      m.attendees,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Text(
                      'Discussion / আলোচনা',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      m.discussion,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Text(
                      'Decision / সিদ্ধান্ত',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      m.decision,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── WARD PROJECT DETAIL ──────────────────────────────────────

class _WardProjectDetail extends StatelessWidget {
  final Project project;
  const _WardProjectDetail({required this.project});

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
              'Project Details',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Text(
              p.ward,
              style: TextStyle(fontSize: 11.sp, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          if (p.status == ProjectStatus.ongoing)
            TextButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => _WardPhotoUploadPage(project: p),
                ),
              ),
              icon: Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
                size: 18.sp,
              ),
              label: Text(
                'Upload',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // Status + type strip
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
                  style: TextStyle(fontSize: 11.sp, color: AppColors.textHint),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),

          // Project Overview
          InfoCard(
            title: p.name,
            banglaTitle: 'FY ${p.financialYear}',
            children: [
              InfoRow(label: 'Project ID', value: p.id),
              InfoRow(label: 'District', value: p.district),
              InfoRow(label: 'Upazila', value: p.upazila),
              InfoRow(label: 'Union', value: p.union),
              InfoRow(label: 'UP Code', value: p.upCode),
              InfoRow(label: 'Ward', value: p.ward),
              InfoRow(
                label: 'Project Cost',
                value: '৳ ${p.costBDT.toStringAsFixed(0)}',
              ),
              InfoRow(label: 'Start Date', value: p.startDate),
              InfoRow(
                label: 'Created By',
                value: p.createdByEngineer,
                isLast: true,
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Contractor (if assigned)
          if (p.contractor != null)
            InfoCard(
              title: 'Contractor',
              banglaTitle: 'ঠিকাদার',
              children: [
                InfoRow(label: 'Name', value: p.contractor!),
                InfoRow(label: 'Mobile', value: p.contractorMobile ?? '—'),
                InfoRow(
                  label: 'Budget',
                  value: p.estimatedBudget != null
                      ? '৳ ${p.estimatedBudget!.toStringAsFixed(0)}'
                      : '—',
                  isLast: true,
                ),
              ],
            ),
          if (p.contractor != null) SizedBox(height: 12.h),

          // Committee
          InfoCard(
            title: 'Scheme Supervision Committee',
            banglaTitle: 'স্কিম তদারকি কমিটি',
            children: p.committee.isEmpty
                ? [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Text(
                        'No committee assigned yet',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textHint,
                        ),
                      ),
                    ),
                  ]
                : [
                    for (int i = 0; i < p.committee.length; i++)
                      CommitteeMemberTile(
                        member: p.committee[i],
                        isLast: i == p.committee.length - 1,
                      ),
                  ],
          ),
          SizedBox(height: 12.h),

          // Progress Photos
          InfoCard(
            title: 'Progress Photos',
            banglaTitle: 'অগ্রগতি ছবি',
            children: [PhotoPhaseWidget(phases: mockPhotoPhases)],
          ),
          SizedBox(height: 12.h),

          // Progress Videos
          InfoCard(
            title: 'Progress Videos',
            banglaTitle: 'অগ্রগতি ভিডিও',
            children: [
              PhotoPhaseWidget(phases: mockVideoPhases, isVideo: true),
            ],
          ),
          SizedBox(height: 12.h),

          // Documents
          InfoCard(
            title: 'Uploaded Documents',
            banglaTitle: 'আপলোডকৃত নথিপত্র',
            children: p.documentNames.isEmpty
                ? [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Text(
                        'No documents yet',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textHint,
                        ),
                      ),
                    ),
                  ]
                : [
                    for (int i = 0; i < p.documentNames.length; i++)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Row(
                          children: [
                            Icon(
                              Icons.picture_as_pdf_outlined,
                              color: AppColors.error,
                              size: 18.sp,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                p.documentNames[i],
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.download_outlined,
                              color: AppColors.primary,
                              size: 18.sp,
                            ),
                          ],
                        ),
                      ),
                  ],
          ),
          SizedBox(height: 24.h),

          // Upload button (if ongoing)
          if (p.status == ProjectStatus.ongoing)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => _WardPhotoUploadPage(project: p),
                  ),
                ),
                icon: Icon(Icons.camera_alt_outlined, size: 18.sp),
                label: Text(
                  'Upload Progress Photos • ছবি আপলোড করুন',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                ),
              ),
            ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

// ─── WARD PHOTO UPLOAD PAGE ───────────────────────────────────

class _WardPhotoUploadPage extends StatefulWidget {
  final Project project;
  const _WardPhotoUploadPage({required this.project});

  @override
  State<_WardPhotoUploadPage> createState() => _WardPhotoUploadPageState();
}

class _WardPhotoUploadPageState extends State<_WardPhotoUploadPage> {
  String _selectedPhase = 'Middle / মধ্যবর্তী';
  int _capturedPhotoCount = 0;
  int _capturedVideoCount = 0;
  bool _uploading = false;

  final _phases = ['First / প্রথম', 'Middle / মধ্যবর্তী', 'Last / শেষ'];

  void _capturePhoto() {
    setState(() => _capturedPhotoCount++);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Photo captured ($_capturedPhotoCount total)',
          style: TextStyle(fontSize: 13.sp),
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  void _recordVideo() {
    setState(() => _capturedVideoCount++);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Video recorded ($_capturedVideoCount total)',
          style: TextStyle(fontSize: 13.sp),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  void _upload() async {
    if (_capturedPhotoCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please capture at least 1 photo first',
            style: TextStyle(fontSize: 13.sp),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      );
      return;
    }
    setState(() => _uploading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() => _uploading = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 18,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Media uploaded to $_selectedPhase! $_capturedPhotoCount photo(s), $_capturedVideoCount video(s). Secretary & UNO notified.',
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
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
              'Upload Photos',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Text(
              'ছবি আপলোড করুন',
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
            // Project info
            Container(
              padding: EdgeInsets.all(14.w),
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
                      Icon(
                        Icons.info_outline,
                        size: 14.sp,
                        color: AppColors.textHint,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'A. Project Info',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    widget.project.name,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  HierarchyBreadcrumb(
                    district: widget.project.district,
                    upazila: widget.project.upazila,
                    union: widget.project.union,
                    ward: widget.project.ward,
                  ),
                  SizedBox(height: 6.h),
                  Wrap(
                    spacing: 6.w,
                    runSpacing: 4.h,
                    children: [
                      TypeBadge(type: widget.project.type),
                      StatusBadge(status: widget.project.status, compact: true),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Existing photos
            InfoCard(
              title: 'B. Existing Photos',
              banglaTitle: 'পূর্বের আপলোডকৃত ছবি',
              children: [PhotoPhaseWidget(phases: mockPhotoPhases)],
            ),
            SizedBox(height: 16.h),

            // Upload section
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.primary.withAlpha(60),
                  width: 1.5.w,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.add_a_photo_outlined,
                        color: AppColors.primary,
                        size: 18.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'C. Upload New Photos',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'নতুন ছবি আপলোড',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  const Divider(height: 1),
                  SizedBox(height: 14.h),

                  // Phase selector
                  const FormFieldLabel(
                    label: 'Select Phase',
                    banglaLabel: 'পর্যায় বেছে নিন',
                    required: true,
                  ),
                  SizedBox(height: 6.h),
                  Column(
                    children: _phases
                        .map(
                          (phase) => GestureDetector(
                            onTap: () => setState(() => _selectedPhase = phase),
                            child: Container(
                              margin: EdgeInsets.only(bottom: 8.h),
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 12.h,
                              ),
                              decoration: BoxDecoration(
                                color: _selectedPhase == phase
                                    ? AppColors.primary.withAlpha(15)
                                    : AppColors.background,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: _selectedPhase == phase
                                      ? AppColors.primary
                                      : AppColors.divider,
                                  width: _selectedPhase == phase ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _selectedPhase == phase
                                        ? Icons.radio_button_checked_rounded
                                        : Icons.radio_button_off_rounded,
                                    color: _selectedPhase == phase
                                        ? AppColors.primary
                                        : AppColors.textHint,
                                    size: 20.sp,
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    phase,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: _selectedPhase == phase
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: _selectedPhase == phase
                                          ? AppColors.primary
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: 14.h),

                  // Camera-only photo capture
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            size: 14.sp,
                            color: AppColors.textHint,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Capture Photos',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '*',
                            style: TextStyle(
                              color: AppColors.error,
                              fontSize: 13.sp,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'ছবি তোলা (ক্যামেরা)',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      if (_capturedPhotoCount > 0)
                        Container(
                          margin: EdgeInsets.only(bottom: 8.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.successLight,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: AppColors.success.withAlpha(60),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                size: 16.sp,
                                color: AppColors.success,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                '$_capturedPhotoCount photo${_capturedPhotoCount > 1 ? "s" : ""} captured',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _capturePhoto,
                          icon: Icon(Icons.camera_alt_rounded, size: 18.sp),
                          label: Text(
                            '📷 Take Photo with Camera',
                            style: TextStyle(fontSize: 13.sp),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            side: const BorderSide(color: AppColors.primary),
                            foregroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'Camera only — gallery selection not allowed',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.textHint,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),

                  // Camera-only video capture
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.videocam_outlined,
                            size: 14.sp,
                            color: AppColors.textHint,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Record Video',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '(Optional)',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.textHint,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'ভিডিও ধারণ (ক্যামেরা)',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      if (_capturedVideoCount > 0)
                        Container(
                          margin: EdgeInsets.only(bottom: 8.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(15),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: AppColors.primary.withAlpha(60),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.videocam_outlined,
                                size: 16.sp,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                '$_capturedVideoCount video${_capturedVideoCount > 1 ? "s" : ""} recorded',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _recordVideo,
                          icon: Icon(Icons.videocam_rounded, size: 18.sp),
                          label: Text(
                            '🎥 Record Video with Camera',
                            style: TextStyle(fontSize: 13.sp),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            side: BorderSide(color: Colors.blueGrey.shade300),
                            foregroundColor: Colors.blueGrey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'Camera only — gallery selection not allowed',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.textHint,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),

                  // Notes
                  const FormFieldLabel(
                    label: 'Notes / মন্তব্য',
                    banglaLabel: 'ঐচ্ছিক নোট',
                  ),
                  SizedBox(height: 6.h),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText:
                          'Brief note about this site visit... (optional)\nযেমন: আজকের পরিদর্শনে কাজ ভালো চলছে।',
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
                  SizedBox(height: 16.h),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _uploading ? null : _upload,
                      icon: _uploading
                          ? SizedBox(
                              width: 16.w,
                              height: 16.h,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Icon(Icons.cloud_upload_outlined, size: 18.sp),
                      label: Text(
                        _uploading
                            ? 'Uploading...'
                            : 'Submit Media • আপলোড করুন',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Rules
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upload Rules',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'আপলোডের নিয়মাবলী',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.textHint,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  for (final rule in [
                    'At least 1 photo required per upload',
                    'Multiple photos allowed per phase',
                    'Camera only — no gallery picker',
                    'Your name and timestamp are recorded automatically',
                    'Secretary & UNO are notified after each upload',
                  ])
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: AppColors.success,
                            size: 14.sp,
                          ),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Text(
                              rule,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}

// ─── SHARED SMALL WIDGETS ─────────────────────────────────────

class _WardProjectTile extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;
  final VoidCallback? onUpload;
  const _WardProjectTile({
    required this.project,
    required this.onTap,
    this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    final p = project;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 6.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(15),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.construction_outlined,
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
                            p.name,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '${p.union} • ${p.ward}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textHint,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Wrap(
                            spacing: 6.w,
                            runSpacing: 4.h,
                            children: [
                              StatusBadge(status: p.status, compact: true),
                              TypeBadge(type: p.type),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Icon(
                      Icons.attach_money_outlined,
                      size: 13.sp,
                      color: AppColors.textHint,
                    ),
                    Text(
                      '৳ ${(p.costBDT / 100000).toStringAsFixed(1)}L',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 12.sp,
                      color: AppColors.textHint,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      p.startDate,
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
          const Divider(height: 1),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onTap,
                    icon: Icon(Icons.visibility_outlined, size: 16.sp),
                    label: Text(
                      'View Details',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      side: const BorderSide(color: AppColors.divider),
                      foregroundColor: AppColors.textSecondary,
                    ),
                  ),
                ),
                if (onUpload != null) ...[
                  SizedBox(width: 10.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onUpload,
                      icon: Icon(Icons.camera_alt_outlined, size: 16.sp),
                      label: Text(
                        'Upload',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadSelectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;
  const _UploadSelectCard({required this.project, required this.onTap});

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
          border: Border.all(color: AppColors.primary.withAlpha(60)),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 6.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.camera_alt_outlined,
                color: AppColors.primary,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '${project.ward} • ${project.union}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textHint,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      StatusBadge(status: project.status, compact: true),
                      SizedBox(width: 6.w),
                      Text(
                        '${project.photoCount} photos uploaded',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label, banglaLabel;
  final Color color;
  final VoidCallback onTap;
  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.banglaLabel,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: color.withAlpha(12),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: color.withAlpha(60)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: color.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              banglaLabel,
              style: TextStyle(fontSize: 10.sp, color: AppColors.textHint),
            ),
          ],
        ),
      ),
    );
  }
}
