enum ProjectStatus { upcoming, ongoing, awaitingApproval, completed, revisionNeeded, draft }

enum ProjectType { road, drainage, mosque, culvert, earthwork, other }

class Project {
  final String id;
  final String name;
  final ProjectType type;
  final ProjectStatus status;
  final String district;
  final String upazila;
  final String union;
  final String upCode;
  final String ward;
  final String financialYear;
  final double costBDT;
  final String startDate;
  final String? expectedCompletion;
  final String? contractor;
  final String? contractorMobile;
  final double? estimatedBudget;
  final String entryDate;
  final String createdByEngineer;
  final double startLat;
  final double startLng;
  final double endLat;
  final double endLng;
  final String locationName;
  final List<CommitteeMember> committee;
  final int photoCount;
  final List<String> documentNames;
  final String? secretaryRemark;

  const Project({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.district,
    required this.upazila,
    required this.union,
    required this.upCode,
    required this.ward,
    required this.financialYear,
    required this.costBDT,
    required this.startDate,
    this.expectedCompletion,
    this.contractor,
    this.contractorMobile,
    this.estimatedBudget,
    required this.entryDate,
    required this.createdByEngineer,
    required this.startLat,
    required this.startLng,
    required this.endLat,
    required this.endLng,
    required this.locationName,
    this.committee = const [],
    this.photoCount = 0,
    this.documentNames = const [],
    this.secretaryRemark,
  });
}

class CommitteeMember {
  final String name;
  final String designation;
  final String mobile;
  final String ward;

  const CommitteeMember({
    required this.name,
    required this.designation,
    required this.mobile,
    required this.ward,
  });
}

class DuplicateAlert {
  final String alertId;
  final String newProjectName;
  final String newLocation;
  final String conflictingProjectName;
  final String conflictingDate;
  final String distance;
  final String union;
  final String ward;
  final bool resolved;

  const DuplicateAlert({
    required this.alertId,
    required this.newProjectName,
    required this.newLocation,
    required this.conflictingProjectName,
    required this.conflictingDate,
    required this.distance,
    required this.union,
    required this.ward,
    this.resolved = false,
  });
}

class MeetingMinutes {
  final String id;
  final String unionName;
  final String meetingDate;
  final String meetingType;
  final String submittedBy;
  final String attendees;
  final String discussion;
  final String decision;

  const MeetingMinutes({
    required this.id,
    required this.unionName,
    required this.meetingDate,
    required this.meetingType,
    required this.submittedBy,
    required this.attendees,
    required this.discussion,
    required this.decision,
  });
}

class PhotoPhase {
  final String label;
  final String banglaLabel;
  final int count;
  final String lastUploadedBy;
  final String lastUploadDate;

  const PhotoPhase({
    required this.label,
    required this.banglaLabel,
    required this.count,
    required this.lastUploadedBy,
    required this.lastUploadDate,
  });
}

// ─── MOCK DATA ───────────────────────────────────────────────

const mockCommittee1 = [
  CommitteeMember(name: 'Md. Karim Uddin', designation: 'Chairperson', mobile: '01711-234567', ward: 'Ward-3'),
  CommitteeMember(name: 'Fatema Begum', designation: 'Member Secretary', mobile: '01817-345678', ward: 'Ward-3'),
  CommitteeMember(name: 'Abdul Haque', designation: 'Member', mobile: '01911-456789', ward: 'Ward-4'),
];

const mockCommittee2 = [
  CommitteeMember(name: 'Rahim Mia', designation: 'Chairperson', mobile: '01711-111222', ward: 'Ward-5'),
  CommitteeMember(name: 'Salma Khatun', designation: 'Member Secretary', mobile: '01817-222333', ward: 'Ward-5'),
];

const mockProjects = [
  Project(
    id: 'PM-2026-W03-001',
    name: 'Road Repair Near Fatullah Bazar',
    type: ProjectType.road,
    status: ProjectStatus.ongoing,
    district: 'Narayanganj',
    upazila: 'Fatullah',
    union: 'Fatullah Union',
    upCode: 'BD-NAR-FAT-UP01',
    ward: 'Ward-3',
    financialYear: '2025-26',
    costBDT: 1250000,
    startDate: '2026-03-15',
    expectedCompletion: '2026-06-30',
    contractor: 'M/S Rahman Construction',
    contractorMobile: '01711-999001',
    estimatedBudget: 1200000,
    entryDate: '2026-03-01 10:30',
    createdByEngineer: 'Eng. Md. Shahidul Islam',
    startLat: 23.6234,
    startLng: 90.4987,
    endLat: 23.6256,
    endLng: 90.5012,
    locationName: 'Near Fatullah Bazar, Ward-3',
    committee: mockCommittee1,
    photoCount: 14,
    documentNames: ['Work Order.pdf', 'Agreement.pdf', 'Running Bill 1.pdf'],
  ),
  Project(
    id: 'PM-2026-W05-002',
    name: 'Drainage Construction Ward-5',
    type: ProjectType.drainage,
    status: ProjectStatus.upcoming,
    district: 'Narayanganj',
    upazila: 'Fatullah',
    union: 'Fatullah Union',
    upCode: 'BD-NAR-FAT-UP01',
    ward: 'Ward-5',
    financialYear: '2025-26',
    costBDT: 875000,
    startDate: '2026-06-20',
    entryDate: '2026-06-01 09:15',
    createdByEngineer: 'Eng. Md. Shahidul Islam',
    startLat: 23.6189,
    startLng: 90.4963,
    endLat: 23.6201,
    endLng: 90.4978,
    locationName: 'South Fatullah, Ward-5',
    committee: mockCommittee2,
    photoCount: 3,
    documentNames: ['Approved Letter.pdf', 'Specification.pdf'],
  ),
  Project(
    id: 'PM-2025-W02-015',
    name: 'Mosque Renovation Ward-2',
    type: ProjectType.mosque,
    status: ProjectStatus.completed,
    district: 'Narayanganj',
    upazila: 'Fatullah',
    union: 'Fatullah Union',
    upCode: 'BD-NAR-FAT-UP01',
    ward: 'Ward-2',
    financialYear: '2024-25',
    costBDT: 650000,
    startDate: '2025-09-10',
    expectedCompletion: '2025-12-15',
    contractor: 'M/S Hossain Builders',
    contractorMobile: '01811-888002',
    estimatedBudget: 640000,
    entryDate: '2025-08-28 11:00',
    createdByEngineer: 'Eng. Md. Shahidul Islam',
    startLat: 23.6210,
    startLng: 90.4945,
    endLat: 23.6210,
    endLng: 90.4945,
    locationName: 'Central Mosque Area, Ward-2',
    committee: mockCommittee1,
    photoCount: 22,
    documentNames: ['Completion Report.pdf', 'Final Photos.zip', 'প্রত্যয়ন পত্র.pdf'],
    secretaryRemark: 'Project completed within budget and timeline.',
  ),
  Project(
    id: 'PM-2026-W07-003',
    name: 'Culvert Construction Main Road',
    type: ProjectType.culvert,
    status: ProjectStatus.awaitingApproval,
    district: 'Narayanganj',
    upazila: 'Fatullah',
    union: 'Fatullah Union',
    upCode: 'BD-NAR-FAT-UP01',
    ward: 'Ward-7',
    financialYear: '2025-26',
    costBDT: 980000,
    startDate: '2026-02-01',
    expectedCompletion: '2026-05-30',
    contractor: 'M/S Alam Engineering',
    contractorMobile: '01911-777003',
    estimatedBudget: 950000,
    entryDate: '2026-01-20 14:45',
    createdByEngineer: 'Eng. Md. Shahidul Islam',
    startLat: 23.6270,
    startLng: 90.5034,
    endLat: 23.6285,
    endLng: 90.5051,
    locationName: 'Main Road Junction, Ward-7',
    committee: mockCommittee2,
    photoCount: 18,
    documentNames: ['Inspection Report.pdf', 'Final Photos.zip', 'প্রত্যয়ন পত্র.pdf'],
    secretaryRemark: 'All work completed. Awaiting Chairman approval.',
  ),
  Project(
    id: 'PM-2026-W01-004',
    name: 'Earthwork at Low-lying Area Ward-1',
    type: ProjectType.earthwork,
    status: ProjectStatus.draft,
    district: 'Narayanganj',
    upazila: 'Fatullah',
    union: 'Fatullah Union',
    upCode: 'BD-NAR-FAT-UP01',
    ward: 'Ward-1',
    financialYear: '2025-26',
    costBDT: 420000,
    startDate: '2026-07-01',
    entryDate: '2026-06-06 16:00',
    createdByEngineer: 'Eng. Md. Shahidul Islam',
    startLat: 23.6155,
    startLng: 90.4922,
    endLat: 23.6168,
    endLng: 90.4938,
    locationName: 'North Ward-1, Near School',
    photoCount: 2,
    documentNames: ['Draft Specification.pdf'],
  ),
];

const mockDuplicateAlerts = [
  DuplicateAlert(
    alertId: 'ALT-001',
    newProjectName: 'Road Repair Near Bazar',
    newLocation: 'Ward-3, Near Old Market',
    conflictingProjectName: 'Road Repair Near Fatullah Bazar',
    conflictingDate: '2026-03-01',
    distance: '85m',
    union: 'Fatullah Union',
    ward: 'Ward-3',
    resolved: false,
  ),
  DuplicateAlert(
    alertId: 'ALT-002',
    newProjectName: 'Drainage Near School Ward-5',
    newLocation: 'Ward-5, School Road',
    conflictingProjectName: 'Drainage Construction Ward-5',
    conflictingDate: '2026-06-01',
    distance: '120m',
    union: 'Fatullah Union',
    ward: 'Ward-5',
    resolved: true,
  ),
];

const mockMeetingMinutes = [
  MeetingMinutes(
    id: 'MM-2026-05',
    unionName: 'Fatullah Union',
    meetingDate: '2026-05-28',
    meetingType: 'Monthly',
    submittedBy: 'Md. Anwar Hossain (Secretary)',
    attendees:
        'Chairman: Md. Jalal Uddin\nWard Members: All 9 present\nSecretary: Md. Anwar Hossain',
    discussion:
        '১। চলমান প্রকল্পের অগ্রগতি পর্যালোচনা করা হয়।\n২। ওয়ার্ড-৩ রাস্তা মেরামত প্রকল্পের বর্তমান অবস্থা আলোচনা করা হয়।\n৩। নতুন প্রকল্পের প্রস্তাব পর্যালোচনা করা হয়।',
    decision:
        '১। ওয়ার্ড-৫ ড্রেনেজ নির্মাণ প্রকল্প অনুমোদন করা হয়।\n২। পরবর্তী সভা ২৮ জুন, ২০২৬ তারিখে অনুষ্ঠিত হবে।',
  ),
  MeetingMinutes(
    id: 'MM-2026-04',
    unionName: 'Fatullah Union',
    meetingDate: '2026-04-25',
    meetingType: 'Monthly',
    submittedBy: 'Md. Anwar Hossain (Secretary)',
    attendees: 'Chairman: Md. Jalal Uddin\nWard Members: 8 present, 1 absent\nSecretary: Md. Anwar Hossain',
    discussion: '১। গত মাসের কার্যবিবরণী অনুমোদন করা হয়।\n২। কালভার্ট নির্মাণ প্রকল্পের অগ্রগতি পর্যালোচনা।',
    decision: '১। কালভার্ট প্রকল্পের শেষ কিস্তি ছাড় করার সিদ্ধান্ত নেওয়া হয়।',
  ),
];

const mockPhotoPhases = [
  PhotoPhase(
    label: 'First',
    banglaLabel: 'প্রথম',
    count: 4,
    lastUploadedBy: 'Karim Uddin',
    lastUploadDate: '2026-03-16',
  ),
  PhotoPhase(
    label: 'Middle-1',
    banglaLabel: 'মধ্যবর্তী ১',
    count: 6,
    lastUploadedBy: 'Fatema Begum',
    lastUploadDate: '2026-04-10',
  ),
  PhotoPhase(
    label: 'Middle-2',
    banglaLabel: 'মধ্যবর্তী ২',
    count: 4,
    lastUploadedBy: 'Abdul Haque',
    lastUploadDate: '2026-05-22',
  ),
  PhotoPhase(
    label: 'Last',
    banglaLabel: 'শেষ',
    count: 0,
    lastUploadedBy: '—',
    lastUploadDate: '—',
  ),
];

const mockVideoPhases = [
  PhotoPhase(
    label: 'First',
    banglaLabel: 'প্রথম',
    count: 2,
    lastUploadedBy: 'Karim Uddin',
    lastUploadDate: '2026-03-16',
  ),
  PhotoPhase(
    label: 'Middle-1',
    banglaLabel: 'মধ্যবর্তী ১',
    count: 1,
    lastUploadedBy: 'Fatema Begum',
    lastUploadDate: '2026-04-10',
  ),
  PhotoPhase(
    label: 'Middle-2',
    banglaLabel: 'মধ্যবর্তী ২',
    count: 0,
    lastUploadedBy: '—',
    lastUploadDate: '—',
  ),
  PhotoPhase(
    label: 'Last',
    banglaLabel: 'শেষ',
    count: 0,
    lastUploadedBy: '—',
    lastUploadDate: '—',
  ),
];

// Summary stats helpers
int get totalProjects => mockProjects.length;
int get ongoingProjects => mockProjects.where((p) => p.status == ProjectStatus.ongoing).length;
int get completedProjects => mockProjects.where((p) => p.status == ProjectStatus.completed).length;
int get upcomingProjects => mockProjects.where((p) => p.status == ProjectStatus.upcoming).length;
int get awaitingProjects => mockProjects.where((p) => p.status == ProjectStatus.awaitingApproval).length;
int get duplicateAlerts => mockDuplicateAlerts.where((a) => !a.resolved).length;
