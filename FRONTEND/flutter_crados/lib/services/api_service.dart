import 'dart:convert';
//import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/crados.dart';

import 'dart:developer' as developer;

// Service pour interagir avec l'API CradosDex
class ApiService {
  // URL de base de l'API (chargée depuis .env)
  static late String _apiUrl;
  static late String _imagesUrl;

  // Initialisation du service avec les variables d'environnement
  static Future<void> init() async {
    await dotenv.load(fileName: '.env');
    _apiUrl = dotenv.get('API_URL', fallback: 'http://localhost:5001');
    _imagesUrl = dotenv.get('CRADOS_IMAGES_URL',
        fallback: 'http://localhost/Node-API-Crados/BACKEND/FILES/');
  }

  // Getter pour l'URL des images
  static String get imagesUrl => _imagesUrl;

  // Récupère tous les Crados
  static Future<List<Crados>> fetchAllCrados() async {
    try {
      final response = await http.get(Uri.parse('$_apiUrl/api/v1/crados'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Crados.fromJson(json)).toList();
      } else {
        throw Exception(
            'Échec du chargement des Crados: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des Crados: $e');
    }
  }

  // Récupère un Crados aléatoire
  static Future<Crados> fetchRandomCrados() async {
    try {
      final response = await http.get(Uri.parse('$_apiUrl/api/v1/random'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Crados.fromJson(data);
      } else {
        throw Exception(
            'Échec du chargement du Crados aléatoire: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération du Crados aléatoire: $e');
    }
  }

  // Récupère un Crados par son ID
  static Future<Crados> fetchCradosById(int id) async {
    try {
      final response =
          await http.get(Uri.parse('$_apiUrl/api/v1/crados/id/$id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Crados.fromJson(data);
      } else {
        throw Exception(
            'Échec du chargement du Crados avec ID $id: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Erreur lors de la récupération du Crados avec ID $id: $e');
    }
  }

  // Récupère un Crados par son nom
  static Future<Crados> fetchCradosByName(String name) async {
    try {
      final response =
          await http.get(Uri.parse('$_apiUrl/api/v1/crados/name/$name'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Crados.fromJson(data);
      } else {
        throw Exception(
            'Échec du chargement du Crados avec nom $name: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Erreur lors de la récupération du Crados avec nom $name: $e');
    }
  }

  // Recherche des Crados par nom (filtre côté client)
  static Future<List<Crados>> searchCradosByName(String query) async {
    final allCrados = await fetchAllCrados();
    return allCrados.where((crados) {
      final fullName = '${crados.firstName} ${crados.name}'.toLowerCase();
      return fullName.contains(query.toLowerCase());
    }).toList();
  }

  // Construit l'URL complète pour une image de Crados
  static String getImageUrl(int cradosId) {
    String padded = cradosId.toString().padLeft(3, '0');
    developer.log('$_imagesUrl$padded.jpg');
    return '$_imagesUrl$padded.jpg';
  }
}
