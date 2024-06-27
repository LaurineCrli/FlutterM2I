import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/album.dart';
import '../providers/reading_list_provider.dart';

class AlbumDetails extends StatelessWidget {
  final Album album;

  const AlbumDetails({
    Key? key,
    required this.album,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(album.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Expanded(
                flex: 1,
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text('Titre: ${album.title}', style: TextStyle(fontSize: 20)),
                    Text('Année: ${album.year}', style: TextStyle(fontSize: 20)),
                    Text('Numéro: ${album.numero}', style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 16),
                    Text(album.resume, style: TextStyle(fontSize: 16)),
                ],
                ),
            ),
            const SizedBox(height: 16),
            Expanded(
                flex: 1,
                child: album.image.isNotEmpty
                    ? Image.asset('img/${album.image}', fit: BoxFit.cover)
                    : const Icon(Icons.image_not_supported, size: 100),
            ),
            
            
            ],
        ),
      ),

      floatingActionButton: Consumer<ReadingListProvider>(
        builder: (context, readingList, child) {
          final isInPlaylist = readingList.isInReadingList(album);
          return FloatingActionButton(
            onPressed: () {
              if (isInPlaylist) {
                readingList.removeAlbum(album);
              } else {
                readingList.addAlbum(album);
              }
              Navigator.pop(context);
            },
            child: Icon(
              isInPlaylist ? Icons.playlist_add_check : Icons.playlist_add,
            ),
          );
        },
      ),
    );
  }
}
