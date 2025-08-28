class Examtermmodel{
  final int examtermId;
  final String examTerm;

  Examtermmodel({required this.examtermId,required this.examTerm});


  factory Examtermmodel.fromJson(Map<String, dynamic> json) {
    return Examtermmodel(
      examtermId: json['key'] ?? '',
      examTerm: json['value'] ?? '',
    );
  }

  @override
  String toString() {
    return '{examtermId:$examtermId,examTerm:$examTerm}';
  }
}