class Album {
  final String title;
  final int numero;
  final int year;
  final String image;
  final String resume;

  Album({
    required this.title,
    required this.numero,
    required this.year,
    required this.image,
    required this.resume,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      title: json['titre'] as String,
      numero: json['numero'] as int,
      year: json['parution'] as int,
      image: json['image'] as String,
      resume: json['resume'] as String,
    );
  }

  @override
  String toString() {
    return 'Album{title: $title, numero: $numero, year: $year, image: $image, resume: $resume}';
  }

  String toJson() {
    return '''{
      "title": "$title",
      "numero": $numero,
      "year": $year,
      "image": "$image",
      "resume": "$resume"
    }''';
  }
}
