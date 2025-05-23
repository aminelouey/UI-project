class Patient {
  final int id;
  final String name;
  final int age;
  final String lastVisit;
  final String? phone; // nouveau champ optionnel

  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.lastVisit,
    this.phone, // optionnel car certains patients peuvent ne pas l’avoir encore
  });

  // Méthode pour créer un Patient à partir d'un Map
  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'],
      name: map['name'],
      age: map['age'],

      lastVisit: map['lastVisit'],
      phone: map['phone'], // nouveau champ
    );
  }

  get treatment => null;

  // Méthode pour convertir un Patient en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'lastVisit': lastVisit,
      'phone': phone, // nouveau champ
    };
  }
}
