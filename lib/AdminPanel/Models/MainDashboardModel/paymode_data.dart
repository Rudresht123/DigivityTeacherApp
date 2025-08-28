class PaymodeData {
  final int id;
  final String paymode;
  final String paymodeIcon;
  final String total;

  PaymodeData({
    required this.id,
    required this.paymode,
    required this.paymodeIcon,
    required this.total,
  });

  factory PaymodeData.fromJson(Map<String, dynamic> json) {
    return PaymodeData(
      id: json['id'],
      paymode: json['paymode'] ?? '',
      paymodeIcon: json['paymode_icon'] ?? '',
      total: json['total']?.toString() ?? '0',
    );
  }
}