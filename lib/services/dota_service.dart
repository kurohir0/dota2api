import 'dart:convert';

import 'package:dwi_dota2/model/hero.dart';
import 'package:http/http.dart' as http;

class HeroService {
  static const String baseUrl = 'https://api.opendota.com/api';
  static Future<List<Heros>> fetchHero() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/heroStats'));
      final body = response.body;
      final result = jsonDecode(body);
      List<Heros> heroes = List<Heros>.from(
        result.map(
          (hero) => Heros.fromJson(hero),
        ),
      );
      return heroes;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
