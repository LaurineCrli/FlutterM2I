import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/album_service.dart';
import '../models/album.dart';
import '../widgets/album_preview.dart';
import '../providers/reading_list_provider.dart';

class AlbumsMaster extends StatelessWidget {
  const AlbumsMaster({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Albums'),
      ),
      body: FutureBuilder<List<Album>>(
        future: AlbumService.fetchAlbums(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No albums available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final album = snapshot.data![index];
                return AlbumPreview(album: album);
              },
            );
          }
        },
      ),
    );
  }
}
