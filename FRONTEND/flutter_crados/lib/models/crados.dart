// Modèle pour un Crados
class Crados {
  final int id;
  final String version;
  final String family;
  final String name;
  final String firstName;
  final String description;
  final String? image;

  Crados({
    required this.id,
    required this.version,
    required this.family,
    required this.name,
    required this.firstName,
    required this.description,
    this.image,
  });

  // Conversion depuis JSON
  factory Crados.fromJson(Map<String, dynamic> json) {
    return Crados(
      id: json['id'] ?? 0,
      version: json['version'] ?? '',
      family: json['family'] ?? '',
      name: json['name'] ?? '',
      firstName: json['first_name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'],
    );
  }

  // Conversion vers JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'version': version,
      'family': family,
      'name': name,
      'first_name': firstName,
      'description': description,
      'image': image,
    };
  }

  // Getter pour le nom complet
  String get fullName => '$name';

  @override
  String toString() {
    return 'Crados(id: $id, name: $fullName, family: $family)';
  }
}
