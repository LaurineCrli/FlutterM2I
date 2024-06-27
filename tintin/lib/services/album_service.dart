import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/album.dart';

class AlbumService {
  static Future<List<Album>> fetchAlbums() async {
    final String response = await rootBundle.loadString('data/albums.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Album.fromJson(json)).toList();
  }
}
