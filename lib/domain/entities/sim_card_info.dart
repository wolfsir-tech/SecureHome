class SimCardInfo {
  const SimCardInfo({
    required this.subscriptionId,
    required this.displayName,
    required this.carrierName,
    required this.slotIndex,
    this.number,
  });

  final int subscriptionId;
  final String displayName;
  final String carrierName;
  final int slotIndex;
  final String? number;

  String get label {
    final name = displayName.trim().isNotEmpty ? displayName : 'SIM ${slotIndex + 1}';
    if (carrierName.trim().isEmpty) return name;
    return '$name · $carrierName';
  }
}
