class User {
  final String userId;
  final String email;
  //final String nombre;
  //final String apellido;

  User({
    this.email,
    this.userId,
    /*this.nombre, this.apellido*/
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      //'nombre': nombre,
      //'apellido': apellido,
    };
  }

  User.fromFirestore(Map<String, dynamic> firestore)
      : userId = firestore['userId'],
        email = firestore['email'];
  //nombre = firestore['nombre'],
  //apellido = firestore['apellido'];
}
