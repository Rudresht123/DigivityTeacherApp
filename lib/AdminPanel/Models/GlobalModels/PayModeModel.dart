class PaymodeModel{

  final int id;
  final String paymode;

  PaymodeModel({required this.id,required this.paymode});

  factory PaymodeModel.fromJson(Map<String,dynamic> json){
    return PaymodeModel(id: json['id'], paymode: json['paymode']);
  }


  @override
  String toString() {
    return '{id:$id,paymode:$paymode}';
  }
}