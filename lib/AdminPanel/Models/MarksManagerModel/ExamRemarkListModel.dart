class ExamRemarkList{

  final int Id;
  final int sequence;
  final String examremark;
  ExamRemarkList({required this.examremark,required this.Id,required this.sequence});

  factory ExamRemarkList.fromJson(Map<String, dynamic> json) {
    return ExamRemarkList(
      Id: json['id'] ?? 0,
      sequence: json['sequence'] ?? 0,
        examremark:json['examremark'] ?? ''
    );
  }

  @override
  String toString() {
    return '{Id:$Id,Sequence:$sequence,ExamRemak:$examremark}';
  }
}