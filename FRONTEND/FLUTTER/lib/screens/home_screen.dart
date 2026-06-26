import 'package:flutter/material.dart';
import '../models/crados.dart';
import '../services/api_service.dart';
import '../widgets/crados_list.dart';
import '../widgets/retro_app_bar.dart';
import '../widgets/retro_text_field.dart';
import '../widgets/retro_button.dart';

// Écran d'accueil avec la liste des Crados
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Crados> _cradosList = [];
  List<Crados> _filteredCradosList = [];
  bool _isLoading = true;
  String _errorMessage = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCrados();
  }

  Future<void> _fetchCrados() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final cradosList = await ApiService.fetchAllCrados();
      setState(() {
        _cradosList = cradosList;
        _filteredCradosList = cradosList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Échec du chargement des Crados: $e';
        _isLoading = false;
      });
    }
  }

  void _filterCrados(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredCradosList = _cradosList;
      });
    } else {
      setState(() {
        _filteredCradosList = _cradosList.where((crados) {
          final fullName = '${crados.firstName} ${crados.name}'.toLowerCase();
          return fullName.contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: RetroAppBar(
        title: 'CRADOS DEX',
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchCrados,
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RetroTextField(
              controller: _searchController,
              hintText: 'Rechercher un Crados...',
              onChanged: _filterCrados,
              textInputAction: TextInputAction.search,
            ),
          ),
          
          // Message d'erreur
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                _errorMessage,
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'Courier',
                  fontSize: 14.0,
                ),
              ),
            ),
          
          // Indicateur de chargement
          if (_isLoading)
            Expanded(
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.pink,
                  backgroundColor: Colors.black,
                ),
              ),
            ),
          
          // Liste des Crados
          if (!_isLoading && _errorMessage.isEmpty)
            Expanded(
              child: CradosList(
                cradosList: _filteredCradosList,
                showImages: true,
                showDescriptions: true,
                onRefresh: _fetchCrados,
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
