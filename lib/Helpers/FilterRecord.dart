List<T> FilterRecord<T>({
  required List<T> data,
  required String query,
  List<String Function(T)>? modelFields, // for models
  List<String>? mapFields,               // for maps
}) {
  final lowerQuery = query.toLowerCase();

  return data.where((item) {
    if (item is Map<String, dynamic> && mapFields != null) {
      for (var field in mapFields) {
        final value = item[field]?.toString().toLowerCase();
        if (value != null && value.contains(lowerQuery)) return true;
      }
      return false;
    }

    if (modelFields != null) {
      for (var getter in modelFields) {
        final value = getter(item)?.toLowerCase() ?? '';
        if (value.contains(lowerQuery)) return true;
      }
    }

    return false;
  }).toList();
}
