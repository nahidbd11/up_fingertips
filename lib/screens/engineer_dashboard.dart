import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../widgets/common_widgets.dart';

class EngineerDashboard extends StatefulWidget {
  const EngineerDashboard({super.key});

  @override
  State<EngineerDashboard> createState() => _EngineerDashboardState();
}

class _EngineerDashboardState extends State<EngineerDashboard> {
  int _selectedIndex = 0;

  final _drawerItems = const [
    DrawerItem('Dashboard', 'ড্যাশবোর্ড', Icons.dashboard_outlined),
    DrawerItem('Duplicate Check', 'সদৃশ প্রকল্প যাচাই', Icons.manage_search_outlined),
    DrawerItem('Create Project', 'প্রকল্প তৈরি', Icons.add_circle_outline),
    DrawerItem('My Projects', 'আমার প্রকল্প', Icons.folder_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UPAppBar(
        title: 'UP@Fingertips',
        subtitle: 'Engineer Dashboard • প্রকৌশলী ড্যাশবোর্ড',
        notificationCount: 1,
      ),
      drawer: UPDrawer(
        roleName: 'Upazila Engineer',
        roleNameBangla: 'উপজেলা প্রকৌশলী',
        userName: 'Eng. Md. Shahidul Islam',
        userID: 'ENG-FAT-001',
        items: _drawerItems,
        selectedIndex: _selectedIndex,
        onItemSelected: (i) => setState(() => _selectedIndex = i),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _EngineerHome(onNavigate: (i) => setState(() => _selectedIndex = i)),
          const _DuplicateCheckMap(),
          const _CreateProjectForm(),
          const _MyProjects(),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => setState(() => _selectedIndex = 2),
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const Text('New Project', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            )
          : null,
    );
  }
}

// ─── HOME ────────────────────────────────────────────────────

class _EngineerHome extends StatelessWidget {
  final void Function(int) onNavigate;
  const _EngineerHome({required this.onNavigate});

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
              gradient: const LinearGradient(colors: [Color(0xFF0D47A1), AppColors.primary], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fatullah Upazila', style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 12.sp)),
                Text('Eng. Md. Shahidul Islam', style: TextStyle(color: Colors.white, fontSize: 17.sp, fontWeight: FontWeight.w700)),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    _QuickActionBtn(Icons.manage_search_outlined, 'Duplicate Check', () => onNavigate(1)),
                    SizedBox(width: 10.w),
                    _QuickActionBtn(Icons.add_circle_outline, 'Create Project', () => onNavigate(2)),
                  ],
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
              StatCard(label: 'Created by Me', banglalabel: 'আমার তৈরি', value: '$totalProjects', icon: Icons.engineering_outlined, color: AppColors.primary, bgColor: AppColors.statusUpcomingBg),
              StatCard(label: 'Ongoing', banglalabel: 'চলমান', value: '$ongoingProjects', icon: Icons.construction_outlined, color: AppColors.statusOngoing, bgColor: AppColors.statusOngoingBg),
              StatCard(label: 'Completed', banglalabel: 'সম্পন্ন', value: '$completedProjects', icon: Icons.check_circle_outline, color: AppColors.success, bgColor: AppColors.successLight),
              StatCard(label: 'Draft', banglalabel: 'খসড়া', value: '1', icon: Icons.drafts_outlined, color: AppColors.statusDraft, bgColor: AppColors.statusDraftBg),
            ],
          ),
          SizedBox(height: 20.h),

          SectionHeader(title: 'My Recent Projects', banglaTitle: 'সাম্প্রতিক প্রকল্পসমূহ', actionLabel: 'All', onAction: () => onNavigate(3)),
          SizedBox(height: 12.h),
          ...mockProjects.take(3).map((p) => ProjectTile(
                project: p,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _EngineerProjectDetail(project: p))),
              )),
        ],
      ),
    );
  }
}

class _QuickActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickActionBtn(this.icon, this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(color: Colors.white.withAlpha(30), borderRadius: BorderRadius.circular(10.r)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16.sp),
            SizedBox(width: 6.w),
            Text(label, style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// ─── DUPLICATE CHECK MAP ─────────────────────────────────────

class _DuplicateCheckMap extends StatefulWidget {
  const _DuplicateCheckMap();

  @override
  State<_DuplicateCheckMap> createState() => _DuplicateCheckMapState();
}

class _DuplicateCheckMapState extends State<_DuplicateCheckMap> {
  String _projectType = 'Road';
  String _ward = 'Ward-3';
  String _radius = '500m';
  String _yearRange = 'Last 3 Years';
  bool _searched = false;

  final _types = ['Road', 'Drainage', 'Mosque', 'Culvert', 'Earthwork', 'Other'];
  final _wards = ['Ward-1', 'Ward-2', 'Ward-3', 'Ward-4', 'Ward-5', 'Ward-6', 'Ward-7', 'Ward-8', 'Ward-9'];
  final _radii = ['100m', '250m', '500m', '1km'];
  final _yearRanges = ['Last 1 Year', 'Last 3 Years', 'Last 5 Years'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppColors.warningLight,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.warning.withAlpha(60)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.warning, size: 16.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Manual lookup tool — use while reviewing paper project requests. Projects in the system are already approved.',
                    style: TextStyle(fontSize: 11.sp, color: AppColors.warning),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          const SectionHeader(title: 'Search Parameters', banglaTitle: 'অনুসন্ধান মানদণ্ড'),
          SizedBox(height: 12.h),

          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _SmallLabel('Project Type', 'প্রকল্পের ধরন'),
                          SizedBox(height: 6.h),
                          FilterDropdown(label: 'Type', value: _projectType, items: _types, onChanged: (v) => setState(() => _projectType = v!)),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _SmallLabel('Ward', 'ওয়ার্ড'),
                          SizedBox(height: 6.h),
                          FilterDropdown(label: 'Ward', value: _ward, items: _wards, onChanged: (v) => setState(() => _ward = v!)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _SmallLabel('Search Radius', 'অনুসন্ধান ব্যাসার্ধ'),
                          SizedBox(height: 6.h),
                          FilterDropdown(label: 'Radius', value: _radius, items: _radii, onChanged: (v) => setState(() => _radius = v!)),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _SmallLabel('Year Range', 'বছরের পরিসর'),
                          SizedBox(height: 6.h),
                          FilterDropdown(label: 'Years', value: _yearRange, items: _yearRanges, onChanged: (v) => setState(() => _yearRange = v!)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => setState(() => _searched = true),
                    icon: Icon(Icons.search_rounded, size: 18.sp),
                    label: const Text('Search Nearby Projects • নিকটবর্তী প্রকল্প খুঁজুন'),
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 14.h)),
                  ),
                ),
              ],
            ),
          ),

          if (_searched) ...[
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.warningLight,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.warning.withAlpha(80)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 18.sp),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      '2 similar projects found within $_radius in $_yearRange',
                      style: TextStyle(fontSize: 12.sp, color: AppColors.warning, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            MapPlaceholder(height: 220, label: '$_ward — $_radius radius', showCircle: true),
            SizedBox(height: 12.h),

            // Results table
            Container(
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14.r), border: Border.all(color: AppColors.divider)),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                    decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.vertical(top: Radius.circular(14.r))),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: Text('Project Name', style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: AppColors.textSecondary))),
                        Expanded(flex: 2, child: Text('Date', style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: AppColors.textSecondary))),
                        Expanded(flex: 1, child: Text('Dist.', style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: AppColors.textSecondary))),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  for (final p in mockProjects.where((p) => p.type == ProjectType.road).take(2))
                    _ResultRow(project: p),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Row(children: [
                      const Icon(Icons.send_outlined, color: Colors.white, size: 16),
                      SizedBox(width: 8.w),
                      const Expanded(
                        child: Text(
                          'Duplicate alert sent to UNO for review. UNO will be notified immediately.',
                        ),
                      ),
                    ]),
                    backgroundColor: AppColors.warning,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    duration: const Duration(seconds: 4),
                  ));
                },
                icon: Icon(Icons.report_problem_outlined, size: 18.sp),
                label: const Text('Alert UNO — Duplicate Project Found'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warning,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
              ),
            ),
          ],
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

class _SmallLabel extends StatelessWidget {
  final String label;
  final String bangla;
  const _SmallLabel(this.label, this.bangla);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const Spacer(),
        Text(bangla, style: TextStyle(fontSize: 10.sp, color: AppColors.textHint)),
      ],
    );
  }
}

class _ResultRow extends StatelessWidget {
  final Project project;
  const _ResultRow({required this.project});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(project.name, style: TextStyle(fontSize: 12.sp, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis)),
          Expanded(flex: 2, child: Text(project.entryDate.split(' ')[0], style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary))),
          Expanded(flex: 1, child: Text('85m', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.warning))),
        ],
      ),
    );
  }
}

// ─── CREATE PROJECT FORM ─────────────────────────────────────

class _CreateProjectForm extends StatefulWidget {
  const _CreateProjectForm();

  @override
  State<_CreateProjectForm> createState() => _CreateProjectFormState();
}

class _CreateProjectFormState extends State<_CreateProjectForm> {
  final _formKey = GlobalKey<FormState>();
  String _union = 'Fatullah Union';
  String _ward = 'Ward-3';
  String _projectType = 'Road';
  String _financialYear = '2025-26';
  int _memberCount = 1;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status note
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.success.withAlpha(60)),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline, color: AppColors.success, size: 16.sp),
                  SizedBox(width: 8.w),
                  Expanded(child: Text('System entry point — UNO has already approved this project offline.', style: TextStyle(fontSize: 11.sp, color: AppColors.success))),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Section A: Basic Info
            _FormSection(title: 'A. Basic Information', banglaTitle: 'মৌলিক তথ্য', children: [
              FormFieldLabel(label: 'Project Name (Formal)', banglaLabel: 'প্রকল্পের নাম', required: true),
              TextFormField(decoration: const InputDecoration(hintText: 'e.g. Road Repair Near Fatullah Bazar, Ward-3')),
              SizedBox(height: 14.h),

              FormFieldLabel(label: 'Project Type', banglaLabel: 'প্রকল্পের ধরন', required: true),
              FilterDropdown(label: 'Type', value: _projectType, items: const ['Road', 'Drainage', 'Mosque', 'Culvert', 'Earthwork', 'Other'], onChanged: (v) => setState(() => _projectType = v!)),
              SizedBox(height: 14.h),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormFieldLabel(label: 'Financial Year', banglaLabel: 'আর্থিক বছর', required: true),
                        FilterDropdown(label: 'Year', value: _financialYear, items: const ['2025-26', '2026-27', '2024-25'], onChanged: (v) => setState(() => _financialYear = v!)),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FormFieldLabel(label: 'Cost (BDT)', banglaLabel: 'ব্যয় (টাকা)', required: true),
                        TextFormField(keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: '1,250,000', prefixText: '৳ ')),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              const FormFieldLabel(label: 'Description', banglaLabel: 'বিবরণ'),
              TextFormField(maxLines: 3, decoration: const InputDecoration(hintText: 'Optional project description...')),
            ]),
            SizedBox(height: 16.h),

            // Section B: Location
            _FormSection(title: 'B. Location', banglaTitle: 'অবস্থান', children: [
              // Auto-filled fields
              _ReadOnlyField(label: 'District', banglaLabel: 'জেলা', value: 'Narayanganj'),
              SizedBox(height: 10.h),
              _ReadOnlyField(label: 'Upazila', banglaLabel: 'উপজেলা', value: 'Fatullah'),
              SizedBox(height: 14.h),

              FormFieldLabel(label: 'Union', banglaLabel: 'ইউনিয়ন', required: true),
              FilterDropdown(label: 'Union', value: _union, items: const ['Fatullah Union', 'Enayetnagar Union'], onChanged: (v) => setState(() => _union = v!)),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(8.r)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_outline, color: AppColors.success, size: 14.sp),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Wrap(
                        spacing: 4.w,
                        runSpacing: 2.h,
                        children: [
                          Text('UP Code: BD-NAR-FAT-UP01', style: TextStyle(fontSize: 11.sp, color: AppColors.success, fontWeight: FontWeight.w600)),
                          Text('— Chairman & Secretary roles auto-assigned', style: TextStyle(fontSize: 11.sp, color: AppColors.success)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),

              FormFieldLabel(label: 'Ward No.', banglaLabel: 'ওয়ার্ড নম্বর', required: true),
              FilterDropdown(label: 'Ward', value: _ward, items: const ['Ward-1', 'Ward-2', 'Ward-3', 'Ward-4', 'Ward-5', 'Ward-6', 'Ward-7', 'Ward-8', 'Ward-9'], onChanged: (v) => setState(() => _ward = v!)),
              SizedBox(height: 14.h),

              MapPinPicker(
                label: 'Start Point',
                banglaLabel: 'শুরুর অবস্থান',
                required: true,
                pinColor: AppColors.success,
              ),
              SizedBox(height: 14.h),
              MapPinPicker(
                label: 'End Point',
                banglaLabel: 'শেষের অবস্থান',
                required: true,
                pinColor: AppColors.error,
              ),
              SizedBox(height: 14.h),
              const FormFieldLabel(label: 'Location Name', banglaLabel: 'অবস্থানের নাম'),
              TextFormField(decoration: const InputDecoration(hintText: 'e.g. Near Fatullah Bazar, Ward-3')),
            ]),
            SizedBox(height: 16.h),

            // Section C: Date
            _FormSection(title: 'C. Date & Timing', banglaTitle: 'তারিখ ও সময়', children: [
              _ReadOnlyField(label: 'Date & Time of Entry', banglaLabel: 'এন্ট্রির তারিখ ও সময়', value: 'Jun 7, 2026 — 11:42 AM (Auto-filled)'),
            ]),
            SizedBox(height: 16.h),

            // Section D: Media Upload
            _FormSection(title: 'D. Pre-Project Media', banglaTitle: 'প্রাক-প্রকল্প মিডিয়া', children: [
              UploadArea(label: 'Photos of Current Situation', banglaLabel: 'বর্তমান অবস্থার ছবি', hint: 'Upload min. 1 photo showing current condition\nJPG, PNG up to 10MB each', required: true),
              SizedBox(height: 14.h),
              UploadArea(label: 'Videos (Optional)', banglaLabel: 'ভিডিও (ঐচ্ছিক)', hint: 'MP4, MOV up to 100MB each', icon: Icons.videocam_outlined),
            ]),
            SizedBox(height: 16.h),

            // Section E: Documents
            _FormSection(title: 'E. Document Upload', banglaTitle: 'নথিপত্র আপলোড', children: [
              UploadArea(label: 'Related Documents', banglaLabel: 'সংশ্লিষ্ট নথিপত্র', hint: 'Scanned copies of approved letter, specification, etc.\nPDF, DOC, JPG — multiple files allowed', icon: Icons.upload_file_outlined),
            ]),
            SizedBox(height: 16.h),

            // Section F: Committee
            _FormSection(title: 'F. Scheme Supervision Committee', banglaTitle: 'স্কিম সুপারভিশন কমিটি', children: [
              for (int i = 0; i < _memberCount; i++) _CommitteeMemberRow(index: i),
              SizedBox(height: 10.h),
              OutlinedButton.icon(
                onPressed: () => setState(() => _memberCount++),
                icon: Icon(Icons.person_add_outlined, size: 16.sp),
                label: const Text('Add Another Member • আরেকজন সদস্য যোগ করুন'),
                style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 10.h)),
              ),
            ]),
            SizedBox(height: 16.h),

            SizedBox(height: 8.h),

            // Submit Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.save_outlined, size: 16.sp),
                    label: const Text('Save Draft'),
                    style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 14.h)),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () => _showSubmitConfirmation(context),
                    icon: Icon(Icons.send_rounded, size: 16.sp),
                    label: const Text('Submit & Create Project'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      backgroundColor: AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  void _showSubmitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Row(
          children: [
            Icon(Icons.check_circle_outline, color: AppColors.success),
            SizedBox(width: 8.w),
            Text('Submit Project', style: TextStyle(fontSize: 17.sp)),
          ],
        ),
        content: Text('Create this project? Chairman and Secretary will be notified automatically.\n\nএই প্রকল্পটি তৈরি করবেন? চেয়ারম্যান ও সচিব স্বয়ংক্রিয়ভাবে অবহিত হবেন।', style: TextStyle(fontSize: 13.sp)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Project created! Notifications sent to Chairman & Secretary.'),
                  backgroundColor: AppColors.success,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

class _FormSection extends StatelessWidget {
  final String title;
  final String banglaTitle;
  final List<Widget> children;

  const _FormSection({required this.title, required this.banglaTitle, required this.children});

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
          Text(title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          Text(banglaTitle, style: TextStyle(fontSize: 11.sp, color: AppColors.textHint)),
          SizedBox(height: 12.h),
          const Divider(height: 1),
          SizedBox(height: 12.h),
          ...children,
        ],
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String label;
  final String banglaLabel;
  final String value;
  const _ReadOnlyField({required this.label, required this.banglaLabel, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
              Row(
                children: [
                  Text(label, style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
                  SizedBox(width: 4.w),
                  Text('($banglaLabel)', style: TextStyle(fontSize: 10.sp, color: AppColors.textHint)),
                ],
              ),
              SizedBox(height: 2.h),
              Text(value, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            ],
          ),
          const Spacer(),
          Icon(Icons.lock_outlined, size: 14.sp, color: AppColors.textHint),
        ],
      ),
    );
  }
}

class _CommitteeMemberRow extends StatelessWidget {
  final int index;
  const _CommitteeMemberRow({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Member ${index + 1} • সদস্য ${index + 1}', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.primary)),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(child: TextFormField(decoration: InputDecoration(hintText: 'Member Name *', contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h)))),
              SizedBox(width: 8.w),
              Expanded(child: TextFormField(decoration: InputDecoration(hintText: 'Designation', contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h)))),
            ],
          ),
          SizedBox(height: 8.h),
          TextFormField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Mobile Number * (01XXX-XXXXXX)',
              prefixIcon: Icon(Icons.phone_outlined, size: 16.sp),
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── MY PROJECTS ─────────────────────────────────────────────

class _MyProjects extends StatelessWidget {
  const _MyProjects();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.surface,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Row(
            children: [
              Expanded(child: FilterDropdown(label: 'Status', value: 'All', items: const ['All', 'Draft', 'Upcoming', 'Ongoing', 'Completed'], onChanged: (_) {})),
              SizedBox(width: 10.w),
              Expanded(child: FilterDropdown(label: 'Year', value: '2025-26', items: const ['2025-26', '2024-25'], onChanged: (_) {})),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: mockProjects.length,
            itemBuilder: (_, i) => ProjectTile(
              project: mockProjects[i],
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _EngineerProjectDetail(project: mockProjects[i]))),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── PROJECT DETAIL (Engineer) ───────────────────────────────

class _EngineerProjectDetail extends StatelessWidget {
  final Project project;
  const _EngineerProjectDetail({required this.project});

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
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
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
                  'FY ${p.financialYear}',
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          InfoCard(title: 'Overview', banglaTitle: 'সংক্ষিপ্ত বিবরণ', children: [
            InfoRow(label: 'Project ID', value: p.id),
            InfoRow(label: 'Ward', value: p.ward),
            InfoRow(label: 'Cost (BDT)', value: '৳ ${p.costBDT.toStringAsFixed(0)}'),
            InfoRow(label: 'Entry Date', value: p.entryDate, isLast: true),
          ]),
          SizedBox(height: 12.h),
          const MapPlaceholder(),
          SizedBox(height: 12.h),
          if (p.contractor != null)
            InfoCard(title: 'Contractor (Added by Secretary)', banglaTitle: 'ঠিকাদার (সচিব কর্তৃক যোগকৃত)', children: [
              InfoRow(label: 'Contractor', value: p.contractor!),
              InfoRow(label: 'Budget', value: '৳ ${p.estimatedBudget?.toStringAsFixed(0) ?? "—"}', isLast: true),
            ]),
          SizedBox(height: 12.h),
          InfoCard(title: 'Progress Photos', banglaTitle: 'অগ্রগতি ছবি', children: [PhotoPhaseWidget(phases: mockPhotoPhases)]),
          SizedBox(height: 12.h),
          InfoCard(title: 'Progress Videos', banglaTitle: 'অগ্রগতি ভিডিও', children: [PhotoPhaseWidget(phases: mockVideoPhases, isVideo: true)]),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14.r), border: Border.all(color: AppColors.divider)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Technical Comments', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700)),
                SizedBox(height: 10.h),
                TextField(maxLines: 3, decoration: InputDecoration(hintText: 'Add technical comment or inspection remark...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: AppColors.divider)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: AppColors.divider)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: AppColors.primary)), filled: true, fillColor: AppColors.background)),
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
