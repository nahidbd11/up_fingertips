import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../widgets/common_widgets.dart';

class CommitteeDashboard extends StatelessWidget {
  const CommitteeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UPAppBar(
        title: 'UP@Fingertips',
        subtitle: 'Committee Member • কমিটি সদস্য',
        notificationCount: 1,
      ),
      drawer: UPDrawer(
        roleName: 'Committee Member',
        roleNameBangla: 'কমিটি সদস্য',
        userName: 'Md. Karim Uddin',
        userID: 'CMT-FAT-W03-001',
        items: const [
          DrawerItem('My Projects', 'আমার প্রকল্প', Icons.folder_outlined),
        ],
        selectedIndex: 0,
        onItemSelected: (_) {},
      ),
      body: const _CommitteeHome(),
    );
  }
}

// ─── HOME ────────────────────────────────────────────────────

class _CommitteeHome extends StatelessWidget {
  const _CommitteeHome();

  @override
  Widget build(BuildContext context) {
    final assignedProjects = mockProjects.where((p) =>
        p.status == ProjectStatus.ongoing || p.status == ProjectStatus.upcoming).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile card - simple
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF0D47A1), AppColors.primary], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28.r,
                  backgroundColor: Colors.white.withAlpha(30),
                  child: Text('K', style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.w700)),
                ),
                SizedBox(width: 14.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Md. Karim Uddin', style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w700)),
                    Text('Scheme Supervision Committee', style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 12.sp)),
                    Text('Ward-3 • Fatullah Union', style: TextStyle(color: Colors.white.withAlpha(170), fontSize: 11.sp)),
                    SizedBox(height: 6.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(30),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '${assignedProjects.length} Active Projects Assigned',
                        style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          SectionHeader(title: 'My Assigned Projects', banglaTitle: 'আমার নিয়োগকৃত প্রকল্পসমূহ'),
          SizedBox(height: 4.h),
          Text(
            'You may be assigned to projects in your ward or adjacent wards.',
            style: TextStyle(fontSize: 11.sp, color: AppColors.textHint),
          ),
          SizedBox(height: 12.h),

          ...assignedProjects.map((p) => _AssignedProjectCard(
                project: p,
                onUpload: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _PhotoUploadPage(project: p))),
                onView: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _CommitteeProjectView(project: p))),
              )),

          SizedBox(height: 20.h),

          // Completed projects
          SectionHeader(title: 'Completed Projects', banglaTitle: 'সম্পন্ন প্রকল্পসমূহ'),
          SizedBox(height: 12.h),
          ...mockProjects.where((p) => p.status == ProjectStatus.completed).map((p) => ProjectTile(
                project: p,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _CommitteeProjectView(project: p))),
              )),
        ],
      ),
    );
  }
}

class _AssignedProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onUpload;
  final VoidCallback onView;

  const _AssignedProjectCard({
    required this.project,
    required this.onUpload,
    required this.onView,
  });

  String get _currentPhase {
    final uploaded = mockPhotoPhases.where((p) => p.count > 0).length;
    if (uploaded == 0) return 'First Phase Expected';
    if (uploaded < mockPhotoPhases.length - 1) return 'Middle Phase Ongoing';
    return 'All Phases Done';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
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
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    StatusBadge(status: project.status, compact: true),
                    SizedBox(width: 8.w),
                    TypeBadge(type: project.type),
                    const Spacer(),
                    Text(project.ward, style: TextStyle(fontSize: 11.sp, color: AppColors.textHint, fontWeight: FontWeight.w500)),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  project.name,
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                Row(children: [
                  Icon(Icons.photo_library_outlined, size: 14.sp, color: AppColors.textHint),
                  SizedBox(width: 4.w),
                  Text('${project.photoCount} photos uploaded', style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
                  SizedBox(width: 12.w),
                  Icon(Icons.flag_outlined, size: 14.sp, color: AppColors.textHint),
                  SizedBox(width: 4.w),
                  Text(_currentPhase, style: TextStyle(fontSize: 12.sp, color: AppColors.primary, fontWeight: FontWeight.w500)),
                ]),
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
                    onPressed: onView,
                    icon: Icon(Icons.visibility_outlined, size: 14.sp),
                    label: const Text('View Details'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      side: const BorderSide(color: AppColors.divider),
                      foregroundColor: AppColors.textSecondary,
                      textStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: onUpload,
                    icon: Icon(Icons.add_a_photo_outlined, size: 14.sp),
                    label: const Text('Upload Photos • ছবি আপলোড'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      textStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── PHOTO UPLOAD PAGE ───────────────────────────────────────

class _PhotoUploadPage extends StatefulWidget {
  final Project project;
  const _PhotoUploadPage({required this.project});

  @override
  State<_PhotoUploadPage> createState() => _PhotoUploadPageState();
}

class _PhotoUploadPageState extends State<_PhotoUploadPage> {
  String _selectedPhase = 'Middle / মধ্যবর্তী';
  bool _uploading = false;
  int _capturedPhotoCount = 0;
  int _capturedVideoCount = 0;

  final _phases = [
    'First / প্রথম',
    'Middle / মধ্যবর্তী',
    'Last / শেষ',
  ];

  void _capturePhoto() {
    // Camera-only capture: ImageSource.camera (no gallery access)
    setState(() => _capturedPhotoCount++);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Photo captured ($_capturedPhotoCount total)', style: TextStyle(fontSize: 13.sp)),
      backgroundColor: AppColors.success,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
    ));
  }

  void _recordVideo() {
    // Camera-only video: ImageSource.camera with video mode (no gallery access)
    setState(() => _capturedVideoCount++);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Video recorded ($_capturedVideoCount total)', style: TextStyle(fontSize: 13.sp)),
      backgroundColor: AppColors.primary,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Upload Photos', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: Colors.white)),
            Text('ছবি আপলোড করুন', style: TextStyle(fontSize: 11.sp, color: Colors.white70)),
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
            // Section A: Project Info (read-only header)
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
                  Row(children: [
                    Icon(Icons.info_outline, size: 14.sp, color: AppColors.textHint),
                    SizedBox(width: 6.w),
                    Text('A. Project Info', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: AppColors.textHint)),
                  ]),
                  SizedBox(height: 8.h),
                  Text(widget.project.name, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  SizedBox(height: 4.h),
                  HierarchyBreadcrumb(
                    district: widget.project.district,
                    upazila: widget.project.upazila,
                    union: widget.project.union,
                    ward: widget.project.ward,
                  ),
                  SizedBox(height: 6.h),
                  Row(children: [
                    TypeBadge(type: widget.project.type),
                    SizedBox(width: 8.w),
                    StatusBadge(status: widget.project.status, compact: true),
                    SizedBox(width: 8.w),
                    Text('৳ ${(widget.project.costBDT / 100000).toStringAsFixed(1)}L', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  ]),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Section B: Existing Photos (read-only)
            InfoCard(
              title: 'B. Existing Photos',
              banglaTitle: 'পূর্বের আপলোডকৃত ছবি',
              children: [PhotoPhaseWidget(phases: mockPhotoPhases)],
            ),
            SizedBox(height: 12.h),

            // Section B2: Existing Videos (read-only)
            InfoCard(
              title: 'B2. Existing Videos',
              banglaTitle: 'পূর্বের আপলোডকৃত ভিডিও',
              children: [PhotoPhaseWidget(phases: mockVideoPhases, isVideo: true)],
            ),
            SizedBox(height: 16.h),

            // Section C: Upload New Photos
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.primary.withAlpha(60), width: 1.5.w),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.add_a_photo_outlined, color: AppColors.primary, size: 18.sp),
                    SizedBox(width: 8.w),
                    Text('C. Upload New Photos', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    const Spacer(),
                    Text('নতুন ছবি আপলোড', style: TextStyle(fontSize: 11.sp, color: AppColors.textHint)),
                  ]),
                  SizedBox(height: 14.h),
                  const Divider(height: 1),
                  SizedBox(height: 14.h),

                  // Phase selector
                  const FormFieldLabel(label: 'Select Phase', banglaLabel: 'পর্যায় বেছে নিন', required: true),
                  SizedBox(height: 6.h),
                  Column(
                    children: _phases.map((phase) => GestureDetector(
                      onTap: () => setState(() => _selectedPhase = phase),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 8.h),
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: _selectedPhase == phase ? AppColors.primary.withAlpha(15) : AppColors.background,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: _selectedPhase == phase ? AppColors.primary : AppColors.divider,
                            width: _selectedPhase == phase ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _selectedPhase == phase ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                              color: _selectedPhase == phase ? AppColors.primary : AppColors.textHint,
                              size: 20.sp,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              phase,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: _selectedPhase == phase ? FontWeight.w700 : FontWeight.w500,
                                color: _selectedPhase == phase ? AppColors.primary : AppColors.textPrimary,
                              ),
                            ),
                            if (_selectedPhase == phase && phase.contains('Middle')) ...[
                              const Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text('New Middle-3', style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ],
                        ),
                      ),
                    )).toList(),
                  ),
                  SizedBox(height: 14.h),

                  // Photo capture (camera only — no gallery)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Icon(Icons.camera_alt_outlined, size: 14.sp, color: AppColors.textHint),
                        SizedBox(width: 6.w),
                        Text('Capture Photos', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        SizedBox(width: 4.w),
                        Text('*', style: TextStyle(color: AppColors.error, fontSize: 13.sp)),
                        const Spacer(),
                        Text('ছবি তোলা (ক্যামেরা)', style: TextStyle(fontSize: 10.sp, color: AppColors.textHint)),
                      ]),
                      SizedBox(height: 6.h),
                      if (_capturedPhotoCount > 0)
                        Container(
                          margin: EdgeInsets.only(bottom: 8.h),
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: AppColors.successLight,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: AppColors.success.withAlpha(60)),
                          ),
                          child: Row(children: [
                            Icon(Icons.check_circle_outline, size: 16.sp, color: AppColors.success),
                            SizedBox(width: 8.w),
                            Text('$_capturedPhotoCount photo${_capturedPhotoCount > 1 ? "s" : ""} captured', style: TextStyle(fontSize: 12.sp, color: AppColors.success, fontWeight: FontWeight.w600)),
                          ]),
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _capturePhoto,
                          icon: Icon(Icons.camera_alt_rounded, size: 18.sp),
                          label: Text('📷 Take Photo with Camera', style: TextStyle(fontSize: 13.sp)),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            side: const BorderSide(color: AppColors.primary),
                            foregroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text('Camera only — gallery selection not allowed', style: TextStyle(fontSize: 10.sp, color: AppColors.textHint, fontStyle: FontStyle.italic)),
                    ],
                  ),
                  SizedBox(height: 14.h),

                  // Video capture (camera only — no gallery)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Icon(Icons.videocam_outlined, size: 14.sp, color: AppColors.textHint),
                        SizedBox(width: 6.w),
                        Text('Record Video', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        SizedBox(width: 4.w),
                        Text('(Optional)', style: TextStyle(fontSize: 10.sp, color: AppColors.textHint)),
                        const Spacer(),
                        Text('ভিডিও ধারণ (ক্যামেরা)', style: TextStyle(fontSize: 10.sp, color: AppColors.textHint)),
                      ]),
                      SizedBox(height: 6.h),
                      if (_capturedVideoCount > 0)
                        Container(
                          margin: EdgeInsets.only(bottom: 8.h),
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(15),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: AppColors.primary.withAlpha(60)),
                          ),
                          child: Row(children: [
                            Icon(Icons.videocam_outlined, size: 16.sp, color: AppColors.primary),
                            SizedBox(width: 8.w),
                            Text('$_capturedVideoCount video${_capturedVideoCount > 1 ? "s" : ""} recorded', style: TextStyle(fontSize: 12.sp, color: AppColors.primary, fontWeight: FontWeight.w600)),
                          ]),
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _recordVideo,
                          icon: Icon(Icons.videocam_rounded, size: 18.sp),
                          label: Text('🎥 Record Video with Camera', style: TextStyle(fontSize: 13.sp)),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            side: BorderSide(color: Colors.blueGrey.shade300),
                            foregroundColor: Colors.blueGrey,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text('Camera only — gallery selection not allowed', style: TextStyle(fontSize: 10.sp, color: AppColors.textHint, fontStyle: FontStyle.italic)),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Notes
                  const FormFieldLabel(label: 'Notes / মন্তব্য', banglaLabel: 'ঐচ্ছিক নোট'),
                  SizedBox(height: 6.h),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Brief note about this site visit... (optional)\nযেমন: আজকের পরিদর্শনে কাজ ভালো চলছে।',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: AppColors.divider)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: AppColors.divider)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: AppColors.primary)),
                      filled: true,
                      fillColor: AppColors.background,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Upload button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _uploading ? null : () => _upload(context),
                      icon: _uploading
                          ? SizedBox(width: 16.w, height: 16.h, child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Icon(Icons.cloud_upload_outlined, size: 18.sp),
                      label: Text(_uploading ? 'Uploading...' : 'Submit Media • আপলোড করুন', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700)),
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 14.h)),
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
                  Text('Upload Rules', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  Text('আপলোডের নিয়মাবলী', style: TextStyle(fontSize: 10.sp, color: AppColors.textHint)),
                  SizedBox(height: 10.h),
                  for (final rule in [
                    'At least 1 photo required per upload session',
                    'Multiple photos allowed per phase',
                    'Multiple Committee Members can upload to the same phase',
                    'Your name and timestamp are recorded automatically',
                  ])
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_circle_outline, color: AppColors.success, size: 14.sp),
                          SizedBox(width: 6.w),
                          Expanded(child: Text(rule, style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary))),
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

  void _upload(BuildContext context) async {
    setState(() => _uploading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() => _uploading = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: [
          const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
          SizedBox(width: 8.w),
          Expanded(child: Text('Media uploaded to $_selectedPhase! $_capturedPhotoCount photo(s), $_capturedVideoCount video(s). Secretary & UNO notified.')),
        ]),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        duration: const Duration(seconds: 3),
      ));
    }
  }
}

// ─── COMMITTEE PROJECT VIEW (read-only) ──────────────────────

class _CommitteeProjectView extends StatelessWidget {
  final Project project;
  const _CommitteeProjectView({required this.project});

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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _PhotoUploadPage(project: p))),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_a_photo_outlined, color: Colors.white),
        label: const Text('Upload Photos', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 90.h),
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14.r), border: Border.all(color: AppColors.divider)),
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
          SizedBox(height: 12.h),
          InfoCard(title: 'Project Details', banglaTitle: 'প্রকল্পের বিবরণ', children: [
            InfoRow(label: 'Ward', value: p.ward),
            InfoRow(label: 'Financial Year', value: p.financialYear),
            InfoRow(label: 'Project Cost', value: '৳ ${p.costBDT.toStringAsFixed(0)}'),
            InfoRow(label: 'Start Date', value: p.startDate),
            InfoRow(label: 'Photos', value: '${p.photoCount} uploaded', isLast: true),
          ]),
          SizedBox(height: 12.h),
          InfoCard(title: 'Progress Photos', banglaTitle: 'অগ্রগতি ছবি', children: [PhotoPhaseWidget(phases: mockPhotoPhases, canUpload: true)]),
          SizedBox(height: 12.h),
          InfoCard(title: 'Your Committee', banglaTitle: 'কমিটির সদস্যগণ', children: [
            for (int i = 0; i < p.committee.length; i++)
              CommitteeMemberTile(member: p.committee[i], isLast: i == p.committee.length - 1),
          ]),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
