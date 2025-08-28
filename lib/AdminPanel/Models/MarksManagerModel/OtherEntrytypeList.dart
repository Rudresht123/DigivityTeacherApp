class OtherEntrytypeList{
  final int Id;
  final int Sequence;
  final String Otherentrykeys;
  final String Otherentry;
  final String? Alias;
  final String? Description;
  final int IsActive;


  OtherEntrytypeList({
    required this.Id,
    required this.Otherentry,
    required this.Otherentrykeys,
    required this.Sequence,
    this.Alias,
    this.Description,
    required this.IsActive,
});

  factory OtherEntrytypeList.fromJson(Map<String,dynamic> json){
    return OtherEntrytypeList(Id: json['id'], Otherentry: json['otherentry'], Otherentrykeys: json['otherentrykeys'], Sequence: json['sequence'], IsActive: json['is_active']);
  }

  @override
  String toString() {
    return '{'
        'id:$Id,Otherentry:$Otherentry,Otherentrykeys:$Otherentrykeys,Sequence:$Sequence,Alias:$Alias,Description:$Description,IsActive:$IsActive}';
  }
}