import 'package:flutter/material.dart';
import '../models/crados.dart';
import 'crados_card.dart';

// Widget pour afficher une liste de Crados avec un style années 80
class CradosList extends StatelessWidget {
  final List<Crados> cradosList;
  final bool showImages;
  final bool showDescriptions;
  final VoidCallback? onRefresh;

  const CradosList({
    Key? key,
    required this.cradosList,
    this.showImages = true,
    this.showDescriptions = true,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (cradosList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sentiment_very_dissatisfied,
              size: 64.0,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16.0),
            Text(
              'Aucun Crados trouvé',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[600],
                fontFamily: 'Courier',
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (onRefresh != null) {
          onRefresh!();
        }
      },
      color: Colors.pink,
      backgroundColor: Colors.black,
      child: ListView.builder(
        itemCount: cradosList.length,
        itemBuilder: (context, index) {
          final crados = cradosList[index];
          return CradosCard(
            crados: crados,
            showImage: showImages,
            showDescription: showDescriptions,
          );
        },
      ),
    );
  }
}

// Widget pour afficher une grille de Crados (style années 80)
class CradosGrid extends StatelessWidget {
  final List<Crados> cradosList;
  final bool showImages;
  final bool showDescriptions;
  final VoidCallback? onRefresh;

  const CradosGrid({
    Key? key,
    required this.cradosList,
    this.showImages = true,
    this.showDescriptions = false,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (cradosList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.grid_view,
              size: 64.0,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16.0),
            Text(
              'Aucun Crados trouvé',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[600],
                fontFamily: 'Courier',
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (onRefresh != null) {
          onRefresh!();
        }
      },
      color: Colors.pink,
      backgroundColor: Colors.black,
      child: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: cradosList.length,
        itemBuilder: (context, index) {
          final crados = cradosList[index];
          return CradosCard(
            crados: crados,
            showImage: showImages,
            showDescription: showDescriptions,
          );
        },
      ),
    );
  }
}
