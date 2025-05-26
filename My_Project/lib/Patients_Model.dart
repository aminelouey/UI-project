class Patient {
  final int id;
  final String fullName;
  final String? phoneNumber;
  final int age;
  final String appointmentDate;
  final String? diagnosis;
  final String? treatment;

  Patient({
    required this.id,
    required this.fullName,
    this.phoneNumber,
    required this.age,
    required this.appointmentDate,
    this.diagnosis,
    this.treatment,
  });

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'],
      fullName: map['Full_Name'],
      phoneNumber: map['Phone_Number'],
      age: map['Age'],
      appointmentDate: map['Date'],
      diagnosis: map['Diagnosis'],
      treatment: map['Treatment'],
    );
  }
}
