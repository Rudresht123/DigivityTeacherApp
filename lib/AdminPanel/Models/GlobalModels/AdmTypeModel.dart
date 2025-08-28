class AdmTypeModel{
  final int id;
  final String admission_type;

  AdmTypeModel({required this.id,required this.admission_type});

  factory AdmTypeModel.jsonFrom(Map<String,dynamic> json){
    return AdmTypeModel(id: json['id'], admission_type: json['admission_type']);
  }

  @override
  String toString(){
    return '{id:$id;admission_type:$admission_type}';
  }

}