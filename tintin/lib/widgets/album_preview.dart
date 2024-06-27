import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/album.dart';
import '../screens/album_details.dart';
import '../providers/reading_list_provider.dart';

class AlbumPreview extends StatelessWidget {
  final Album album;

  const AlbumPreview({
    Key? key,
    required this.album,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ReadingListProvider>(
      builder: (context, readingList, child) {
        final isInPlaylist = readingList.isInReadingList(album);
        return ListTile(
          leading: album.image.isNotEmpty
              ? Image.asset('img/${album.image}', width: 50, height: 50, fit: BoxFit.cover)
              : const Icon(Icons.image_not_supported),
          title: Text(album.title),
          trailing: Icon(
            isInPlaylist ? Icons.playlist_add_check : Icons.search,
            color: isInPlaylist ? Colors.green : null,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AlbumDetails(album: album),
              ),
            );
          },
        );
      },
    );
  }
}
