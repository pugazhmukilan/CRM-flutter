class Campaign {
  final String id;
  final String name;
  final List<dynamic> pipeline;
  final DateTime? createdAt;
  final List<dynamic> customers;
  final String status;
  final int leads; // Number of customers/leads

  Campaign({
    required this.id,
    required this.name,
    required this.pipeline,
    this.createdAt,
    required this.customers,
    required this.status,
    required this.leads,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Unnamed Campaign',
      pipeline: json['pipeline'] ?? [],
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      customers: json['customers'] ?? [],
      status: json['status'] ?? 'Unknown',
      leads: (json['customers'] as List?)?.length ?? 0, // Use customers array length
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'pipeline': pipeline,
      'created_at': createdAt?.toIso8601String(),
      'customers': customers,
      'status': status,
    };
  }
}
