import 'package:flutter/material.dart';
import '../models/crados.dart';
import '../services/api_service.dart';
import '../widgets/crados_card.dart';
import '../widgets/retro_app_bar.dart';
import '../widgets/retro_button.dart';

// Écran pour afficher un Crados aléatoire
class RandomScreen extends StatefulWidget {
  const RandomScreen({Key? key}) : super(key: key);

  @override
  _RandomScreenState createState() => _RandomScreenState();
}

class _RandomScreenState extends State<RandomScreen> {
  Crados? _randomCrados;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchRandomCrados();
  }

  Future<void> _fetchRandomCrados() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final crados = await ApiService.fetchRandomCrados();
      setState(() {
        _randomCrados = crados;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Échec du chargement du Crados aléatoire: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: RetroAppBar(
        title: 'CRADOS ALÉATOIRE',
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchRandomCrados,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Message d'erreur
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'Courier',
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              
              // Indicateur de chargement
              if (_isLoading)
                CircularProgressIndicator(
                  color: Colors.pink,
                  backgroundColor: Colors.black,
                ),
              
              // Carte du Crados aléatoire
              if (!_isLoading && _errorMessage.isEmpty && _randomCrados != null)
                Expanded(
                  child: SingleChildScrollView(
                    child: CradosCard(
                      crados: _randomCrados!,
                      showImage: true,
                      showDescription: true,
                    ),
                  ),
                ),
              
              // Bouton pour obtenir un autre Crados aléatoire
              const SizedBox(height: 20.0),
              RetroButton(
                text: 'UN AUTRE !',
                onPressed: _fetchRandomCrados,
                backgroundColor: Colors.pink,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
