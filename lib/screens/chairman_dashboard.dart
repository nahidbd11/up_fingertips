import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../widgets/common_widgets.dart';

class ChairmanDashboard extends StatefulWidget {
  const ChairmanDashboard({super.key});

  @override
  State<ChairmanDashboard> createState() => _ChairmanDashboardState();
}

class _ChairmanDashboardState extends State<ChairmanDashboard> {
  int _selectedIndex = 0;

  final _drawerItems = const [
    DrawerItem('Dashboard', 'ড্যাশবোর্ড', Icons.dashboard_outlined),
    DrawerItem('All Projects', 'সকল প্রকল্প', Icons.folder_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UPAppBar(
        title: 'UP@Fingertips',
        subtitle: 'Chairman Dashboard • চেয়ারম্যান ড্যাশবোর্ড',
        notificationCount: awaitingProjects,
      ),
      drawer: UPDrawer(
        roleName: 'UP Chairman',
        roleNameBangla: 'ইউপি চেয়ারম্যান',
        userName: 'Md. Jalal Uddin',
        userID: 'CHR-FAT-UP01',
        items: _drawerItems,
        selectedIndex: _selectedIndex,
        onItemSelected: (i) => setState(() => _selectedIndex = i),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _ChairmanHome(onNavigate: (i) => setState(() => _selectedIndex = i)),
          const _ChairmanProjects(),
        ],
      ),
    );
  }
}

// ─── HOME ────────────────────────────────────────────────────

class _ChairmanHome extends StatelessWidget {
  final void Function(int) onNavigate;
  const _ChairmanHome({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final awaitingList = mockProjects.where((p) => p.status == ProjectStatus.awaitingApproval).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.primaryDark, AppColors.primary], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good Morning,', style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 12.sp)),
                      Text('Md. Jalal Uddin', style: TextStyle(color: Colors.white, fontSize: 17.sp, fontWeight: FontWeight.w700)),
                      SizedBox(height: 2.h),
                      Text('Chairman, Fatullah Union', style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 12.sp)),
                      SizedBox(height: 4.h),
                      Text('UP Code: BD-NAR-FAT-UP01', style: TextStyle(color: Colors.white.withAlpha(160), fontSize: 11.sp)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(color: Colors.white.withAlpha(25), shape: BoxShape.circle),
                  child: Icon(Icons.how_to_vote_rounded, color: Colors.white, size: 30.sp),
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
            childAspectRatio: MediaQuery.of(context).size.width < 390 ? 1.2 : 1.3,
            children: [
              StatCard(label: 'Total Projects', banglalabel: 'মোট প্রকল্প', value: '$totalProjects', icon: Icons.folder_outlined, color: AppColors.primary, bgColor: AppColors.statusUpcomingBg),
              StatCard(label: 'Ongoing', banglalabel: 'চলমান', value: '$ongoingProjects', icon: Icons.construction_outlined, color: AppColors.statusOngoing, bgColor: AppColors.statusOngoingBg),
              StatCard(label: 'Completed', banglalabel: 'সম্পন্ন', value: '$completedProjects', icon: Icons.check_circle_outline, color: AppColors.success, bgColor: AppColors.successLight),
              StatCard(label: 'Awaiting My Approval', banglalabel: 'অনুমোদনের অপেক্ষায়', value: '$awaitingProjects', icon: Icons.pending_actions_outlined, color: AppColors.statusAwaiting, bgColor: AppColors.statusAwaitingBg),
            ],
          ),
          SizedBox(height: 20.h),

          // Awaiting approval - priority section
          if (awaitingList.isNotEmpty) ...[
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.statusAwaitingBg,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: AppColors.statusAwaiting.withAlpha(80)),
              ),
              child: Row(
                children: [
                  Icon(Icons.notification_important_outlined, color: AppColors.statusAwaiting, size: 22.sp),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${awaitingList.length} Project${awaitingList.length > 1 ? 's' : ''} Awaiting Your Final Approval',
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.statusAwaiting),
                        ),
                        Text('চূড়ান্ত অনুমোদনের জন্য অপেক্ষারত', style: TextStyle(fontSize: 11.sp, color: AppColors.textHint)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            ...awaitingList.map((p) => _AwaitingCard(
                  project: p,
                  onReview: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _ChairmanReview(project: p))),
                )),
            SizedBox(height: 8.h),
          ],

          // All Projects
          SectionHeader(title: 'All Projects', banglaTitle: 'সকল প্রকল্প', actionLabel: 'View All', onAction: () => onNavigate(1)),
          SizedBox(height: 12.h),
          ...mockProjects.take(3).map((p) => ProjectTile(
                project: p,
                onTap: () => p.status == ProjectStatus.awaitingApproval
                    ? Navigator.push(context, MaterialPageRoute(builder: (_) => _ChairmanReview(project: p)))
                    : Navigator.push(context, MaterialPageRoute(builder: (_) => _ChairmanProjectView(project: p))),
              )),
        ],
      ),
    );
  }
}

class _AwaitingCard extends StatelessWidget {
  final Project project;
  final VoidCallback onReview;
  const _AwaitingCard({required this.project, required this.onReview});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.statusAwaiting.withAlpha(80), width: 1.5.w),
        boxShadow: [BoxShadow(color: AppColors.statusAwaiting.withAlpha(20), blurRadius: 8.r)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.pending_actions_outlined, color: AppColors.statusAwaiting, size: 18.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  project.name,
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text('${project.ward} • FY ${project.financialYear}', style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
          if (project.contractor != null)
            Text('Contractor: ${project.contractor}', style: TextStyle(fontSize: 12.sp, color: AppColors.textHint)),
          SizedBox(height: 10.h),
          Text('Secretary has submitted completion. Awaiting your review.', style: TextStyle(fontSize: 12.sp, color: AppColors.statusAwaiting.withAlpha(220), fontStyle: FontStyle.italic)),
          SizedBox(height: 10.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onReview,
              icon: Icon(Icons.rate_review_outlined, size: 16.sp),
              label: const Text('Review & Approve • পর্যালোচনা ও অনুমোদন'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.statusAwaiting,
                padding: EdgeInsets.symmetric(vertical: 10.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── ALL PROJECTS ────────────────────────────────────────────

class _ChairmanProjects extends StatelessWidget {
  const _ChairmanProjects();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.surface,
          padding: EdgeInsets.all(12.w),
          child: Row(children: [
            Expanded(child: _SimpleFilter(label: 'All Status', items: const ['All Status', 'Upcoming', 'Ongoing', 'Awaiting Approval', 'Completed'])),
            SizedBox(width: 10.w),
            Expanded(child: _SimpleFilter(label: 'All Wards', items: const ['All Wards', 'Ward-1', 'Ward-2', 'Ward-3', 'Ward-4', 'Ward-5'])),
          ]),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: mockProjects.length,
            itemBuilder: (_, i) {
              final p = mockProjects[i];
              return ProjectTile(
                project: p,
                actionLabel: p.status == ProjectStatus.awaitingApproval ? 'Review Now' : null,
                actionColor: AppColors.statusAwaiting,
                onTap: () => p.status == ProjectStatus.awaitingApproval
                    ? Navigator.push(context, MaterialPageRoute(builder: (_) => _ChairmanReview(project: p)))
                    : Navigator.push(context, MaterialPageRoute(builder: (_) => _ChairmanProjectView(project: p))),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SimpleFilter extends StatefulWidget {
  final String label;
  final List<String> items;
  const _SimpleFilter({required this.label, required this.items});

  @override
  State<_SimpleFilter> createState() => _SimpleFilterState();
}

class _SimpleFilterState extends State<_SimpleFilter> {
  late String _value;

  @override
  void initState() {
    super.initState();
    _value = widget.items.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(border: Border.all(color: AppColors.divider), borderRadius: BorderRadius.circular(10.r), color: AppColors.surface),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _value,
          items: widget.items.map((s) => DropdownMenuItem(value: s, child: Text(s, style: TextStyle(fontSize: 12.sp)))).toList(),
          onChanged: (v) => setState(() => _value = v!),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded, size: 18.sp, color: AppColors.textHint),
          style: TextStyle(fontSize: 12.sp, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

// ─── PROJECT REVIEW (KEY ACTION SCREEN) ─────────────────────

class _ChairmanReview extends StatefulWidget {
  final Project project;
  const _ChairmanReview({required this.project});

  @override
  State<_ChairmanReview> createState() => _ChairmanReviewState();
}

class _ChairmanReviewState extends State<_ChairmanReview> {
  final _commentController = TextEditingController();
  final _revisionController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    _revisionController.dispose();
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
            Text('Final Review', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: Colors.white)),
            Text('চূড়ান্ত পর্যালোচনা', style: TextStyle(fontSize: 11.sp, color: Colors.white70)),
          ],
        ),
        backgroundColor: AppColors.statusAwaiting,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // Status banner
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.statusAwaiting, AppColors.statusAwaiting.withAlpha(200)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(Icons.how_to_vote_outlined, color: Colors.white, size: 18.sp),
                  SizedBox(width: 8.w),
                  Text('Your Approval Required', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w700)),
                ]),
                SizedBox(height: 4.h),
                Text('Secretary has submitted this project for your final review.', style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 12.sp)),
              ],
            ),
          ),
          SizedBox(height: 12.h),

          // A: Project Summary
          InfoCard(
            title: 'A. Project Summary',
            banglaTitle: 'প্রকল্পের সারসংক্ষেপ',
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: HierarchyBreadcrumb(district: p.district, upazila: p.upazila, union: p.union, ward: p.ward, upCode: p.upCode),
              ),
              const Divider(height: 1),
              InfoRow(label: 'Project Name', value: p.name),
              InfoRow(label: 'Project Type', value: p.type.name.toUpperCase()),
              InfoRow(label: 'Financial Year', value: p.financialYear),
              InfoRow(label: 'Project Cost', value: '৳ ${p.costBDT.toStringAsFixed(0)}'),
              if (p.contractor != null) InfoRow(label: 'Contractor', value: p.contractor!),
              if (p.estimatedBudget != null) InfoRow(label: 'Contract Budget', value: '৳ ${p.estimatedBudget!.toStringAsFixed(0)}'),
              InfoRow(label: 'Start Date', value: p.startDate),
              InfoRow(label: 'Expected Completion', value: p.expectedCompletion ?? '—', isLast: true),
            ],
          ),
          SizedBox(height: 12.h),

          // B: Progress Photos
          InfoCard(
            title: 'B. Progress Photos (All Phases)',
            banglaTitle: 'সকল পর্যায়ের ছবি',
            children: [PhotoPhaseWidget(phases: mockPhotoPhases)],
          ),
          SizedBox(height: 12.h),

          // B2: Progress Videos
          InfoCard(
            title: 'B2. Progress Videos (All Phases)',
            banglaTitle: 'সকল পর্যায়ের ভিডিও',
            children: [PhotoPhaseWidget(phases: mockVideoPhases, isVideo: true)],
          ),
          SizedBox(height: 12.h),

          // C: Completion Documents
          InfoCard(
            title: 'C. Completion Documents',
            banglaTitle: 'সমাপ্তির নথিপত্র',
            children: [
              _CompletionDocRow(label: 'Final Inspection Report', icon: Icons.assignment_turned_in_outlined, color: AppColors.primary),
              _CompletionDocRow(label: 'Final Project Photos', icon: Icons.photo_library_outlined, color: AppColors.statusOngoing),
              _CompletionDocRow(label: 'প্রত্যয়ন পত্র (Signed)', icon: Icons.verified_outlined, color: AppColors.success),
              if (p.secretaryRemark != null) ...[
                const Divider(height: 16),
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8.r)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Secretary's Remarks", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.textHint)),
                      SizedBox(height: 4.h),
                      Text(p.secretaryRemark!, style: TextStyle(fontSize: 13.sp, color: AppColors.textPrimary, fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 12.h),

          // D: Chairman Comment
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
                Text('D. Chairman\'s Comment (Optional)', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                Text('চেয়ারম্যানের মন্তব্য (ঐচ্ছিক)', style: TextStyle(fontSize: 11.sp, color: AppColors.textHint)),
                SizedBox(height: 12.h),
                TextField(
                  controller: _commentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Add a comment or note for the record...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: AppColors.divider)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: AppColors.divider)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: AppColors.primary)),
                    filled: true,
                    fillColor: AppColors.background,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // E: Final Decision
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.divider, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(Icons.gavel_rounded, color: AppColors.textPrimary, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text('E. Final Decision', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const Spacer(),
                  Text('চূড়ান্ত সিদ্ধান্ত', style: TextStyle(fontSize: 11.sp, color: AppColors.textHint)),
                ]),
                SizedBox(height: 16.h),

                // Approve Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showApprovalDialog(context),
                    icon: Icon(Icons.check_circle_rounded, size: 20.sp),
                    label: Text('Mark as Completed\nসম্পন্ন হিসেবে চিহ্নিত করুন', textAlign: TextAlign.center, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),

                // Request Changes Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showRevisionDialog(context),
                    icon: Icon(Icons.edit_outlined, size: 18.sp),
                    label: Text('Request Changes\nপরিবর্তন অনুরোধ করুন', textAlign: TextAlign.center, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.warning,
                      side: const BorderSide(color: AppColors.warning, width: 1.5),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  void _showApprovalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Row(children: [
          Icon(Icons.check_circle_rounded, color: AppColors.success, size: 28.sp),
          SizedBox(width: 10.w),
          Expanded(child: Text('Confirm Completion?', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700))),
        ]),
        content: Text(
          'This will mark the project as Completed.\n\nAll parties will be notified:\n• Upazila Engineer\n• UP Secretary\n• UNO\n• DDLG\n\nএই প্রকল্প সম্পন্ন হিসেবে চিহ্নিত হবে।',
          style: TextStyle(fontSize: 13.sp),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: AppColors.textHint))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Row(children: [
                  Icon(Icons.check_circle_rounded, color: Colors.white, size: 18.sp),
                  SizedBox(width: 8.w),
                  const Text('Project marked as Completed! All parties notified.'),
                ]),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                duration: const Duration(seconds: 3),
              ));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h)),
            child: const Text('Confirm Completion', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showRevisionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Row(children: [
          Icon(Icons.edit_outlined, color: AppColors.warning, size: 26.sp),
          SizedBox(width: 10.w),
          Text('Request Changes?', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700)),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Please specify what needs to be corrected:', style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary)),
            SizedBox(height: 10.h),
            TextField(
              controller: _revisionController,
              maxLines: 4,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Describe what needs to be changed...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: AppColors.warning, width: 2)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: AppColors.textHint))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Revision requested. Secretary has been notified.'),
                backgroundColor: AppColors.warning,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning, padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h)),
            child: const Text('Send Revision Request', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _CompletionDocRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _CompletionDocRow({required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(color: color.withAlpha(20), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 18.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(child: Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500))),
        TextButton.icon(
          onPressed: () {},
          icon: Icon(Icons.download_outlined, size: 14.sp),
          label: Text('Download', style: TextStyle(fontSize: 12.sp)),
          style: TextButton.styleFrom(foregroundColor: AppColors.primary, padding: EdgeInsets.symmetric(horizontal: 8.w)),
        ),
      ]),
    );
  }
}

// ─── CHAIRMAN PROJECT VIEW (read-only) ───────────────────────

class _ChairmanProjectView extends StatelessWidget {
  final Project project;
  const _ChairmanProjectView({required this.project});

  @override
  Widget build(BuildContext context) {
    final p = project;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(p.name, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: Colors.white)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14.r), border: Border.all(color: AppColors.divider)),
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
                  p.financialYear,
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          InfoCard(title: 'Project Details', banglaTitle: 'প্রকল্পের বিবরণ', children: [
            InfoRow(label: 'Ward', value: p.ward),
            InfoRow(label: 'Cost (BDT)', value: '৳ ${p.costBDT.toStringAsFixed(0)}'),
            InfoRow(label: 'Contractor', value: p.contractor ?? 'Not yet assigned'),
            InfoRow(label: 'Start Date', value: p.startDate, isLast: true),
          ]),
          SizedBox(height: 12.h),
          InfoCard(title: 'Progress Photos', banglaTitle: 'অগ্রগতি ছবি', children: [PhotoPhaseWidget(phases: mockPhotoPhases)]),
          SizedBox(height: 12.h),
          InfoCard(title: 'Progress Videos', banglaTitle: 'অগ্রগতি ভিডিও', children: [PhotoPhaseWidget(phases: mockVideoPhases, isVideo: true)]),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14.r), border: Border.all(color: AppColors.divider)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Send Instruction', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700)),
              SizedBox(height: 10.h),
              TextField(maxLines: 3, decoration: InputDecoration(hintText: 'Write instruction for Secretary or Committee...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: AppColors.divider)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: AppColors.divider)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: AppColors.primary)), filled: true, fillColor: AppColors.background)),
              SizedBox(height: 10.h),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, child: const Text('Send Instruction'))),
            ]),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
