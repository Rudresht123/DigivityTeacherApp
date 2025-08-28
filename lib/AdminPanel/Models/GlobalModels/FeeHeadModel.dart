class Feeheadmodel{

  final int id;
  final String fee_head;

  Feeheadmodel({required this.id,required this.fee_head});

  factory Feeheadmodel.fromJson(Map<String,dynamic> json){
    return Feeheadmodel(id: json['id'], fee_head: json['fee_head']);
  }


  @override
  String toString() {
    return '{id:$id,fee_head:$fee_head}';
  }
}