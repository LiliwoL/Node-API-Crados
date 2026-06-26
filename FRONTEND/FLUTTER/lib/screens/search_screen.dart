import 'package:flutter/material.dart';
import '../models/crados.dart';
import '../services/api_service.dart';
import '../widgets/crados_list.dart';
import '../widgets/retro_app_bar.dart';
import '../widgets/retro_text_field.dart';
import '../widgets/retro_button.dart';

// Écran pour rechercher des Crados par nom
class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Crados> _searchResults = [];
  bool _isLoading = false;
  String _errorMessage = '';
  final TextEditingController _searchController = TextEditingController();

  Future<void> _searchCrados() async {
    final query = _searchController.text.trim();
    
    if (query.isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez entrer un nom pour rechercher';
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final results = await ApiService.searchCradosByName(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
        if (results.isEmpty) {
          _errorMessage = 'Aucun Crados trouvé avec ce nom';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Échec de la recherche: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: RetroAppBar(
        title: 'RECHERCHER CRADOS',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Champ de recherche
            RetroTextField(
              controller: _searchController,
              hintText: 'Entrez un nom de Crados...',
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() {
                    _searchResults = [];
                    _errorMessage = '';
                  });
                }
              },
            ),
            const SizedBox(height: 16.0),
            
            // Bouton de recherche
            RetroButton(
              text: 'RECHERCHER',
              onPressed: _searchCrados,
              backgroundColor: Colors.pink,
              textColor: Colors.white,
            ),
            
            // Message d'erreur
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'Courier',
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            
            // Indicateur de chargement
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: CircularProgressIndicator(
                  color: Colors.pink,
                  backgroundColor: Colors.black,
                ),
              ),
            
            // Résultats de la recherche
            if (!_isLoading && _searchResults.isNotEmpty)
              Expanded(
                child: CradosList(
                  cradosList: _searchResults,
                  showImages: true,
                  showDescriptions: true,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
