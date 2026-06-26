import 'package:flutter/material.dart';
import '../models/crados.dart';
import '../services/api_service.dart';

// Widget pour afficher une carte de Crados avec un style années 80
class CradosCard extends StatelessWidget {
  final Crados crados;
  final bool showImage;
  final bool showDescription;

  const CradosCard({
    Key? key,
    required this.crados,
    this.showImage = true,
    this.showDescription = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: _getFamilyColor(crados.family),
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec ID et nom
            Row(
              children: [
                // Badge ID avec style rétro
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(color: Colors.white, width: 1.0),
                  ),
                  child: Text(
                    '#${crados.id.toString().padLeft(3, '0')}',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Courier',
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                // Nom du Crados
                Expanded(
                  child: Text(
                    crados.fullName,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: _getFamilyColor(crados.family),
                      fontFamily: 'Arial',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            
            // Famille et version
            Row(
              children: [
                Text(
                  crados.family,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  crados.version,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            
            // Description
            if (showDescription)
              Text(
                crados.description,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 14.0,
                ),
              ),
            const SizedBox(height: 8.0),
            
            // Image
            if (showImage && crados.image != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    ApiService.getImageUrl(crados.image!),
                    height: 200.0,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200.0,
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                            color: _getFamilyColor(crados.family),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200.0,
                      color: Colors.grey[200],
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50.0,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Couleur en fonction de la famille (style années 80)
  Color _getFamilyColor(String family) {
    switch (family.toLowerCase()) {
      case 'degueulos':
        return const Color(0xFF00FF00); // Vert fluo
      case 'bizarres':
        return const Color(0xFFFF00FF); // Magenta
      case 'flippants':
        return const Color(0xFF00FFFF); // Cyan
      case 'chelous':
        return const Color(0xFFFF6600); // Orange
      case 'dégueulasses':
        return const Color(0xFF800080); // Violet
      default:
        return const Color(0xFFFF0000); // Rouge
    }
  }
}
