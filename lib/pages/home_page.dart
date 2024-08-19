import 'package:flutter/material.dart';
import 'package:dwi_dota2/model/hero.dart';
import 'package:dwi_dota2/services/dota_service.dart';
import 'package:dwi_dota2/pages/last_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Heros> _heroes = [];
  String _searchQuery = '';
  Heros? _lastViewedHero;

  @override
  void initState() {
    super.initState();
    _loadLastViewedHero();
    HeroService.fetchHero().then((heroes) {
      setState(() {
        _heroes = heroes;
      });
    });
  }

  Future<void> _loadLastViewedHero() async {
    final prefs = await SharedPreferences.getInstance();
    final lastViewedHeroJson = prefs.getString('last_viewed_hero');
    if (lastViewedHeroJson != null) {
      setState(() {
        _lastViewedHero = Heros.fromJson(json.decode(lastViewedHeroJson));
      });
    }
  }

  Future<void> _saveLastViewedHero(Heros hero) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_viewed_hero', json.encode(hero.toJson()));
  }

  @override
  Widget build(BuildContext context) {
    // Filter heroes berdasarkan input pencarian
    final filteredHeroes = _heroes.where((hero) {
      return hero.localizedName
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dota 2 Heroes'),
        actions: [
          if (_lastViewedHero != null)
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LastViewedHeroPage(),
                  ),
                );
              },
              tooltip: 'Last viewed hero',
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              decoration: InputDecoration(
                labelText: 'Search Hero',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredHeroes.length,
              itemBuilder: (context, index) {
                final hero = filteredHeroes[index];
                final imageUrl =
                    'https://cdn.akamai.steamstatic.com${hero.icon}';

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(imageUrl),
                      onBackgroundImageError: (_, __) {
                        debugPrint('Failed to load image: $imageUrl');
                      },
                    ),
                    title: Text(hero.localizedName),
                    subtitle: Text('Roles: ${hero.roles.join(', ')}'),
                    onTap: () {
                      _saveLastViewedHero(hero);
                      _showHeroDetails(hero);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showHeroDetails(Heros hero) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(hero.localizedName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Image.network(
                'https://cdn.akamai.steamstatic.com${hero.img}',
                height: 250,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Text('Failed to load image'));
                },
              ),
            ),
            const SizedBox(height: 16),
            Text('Primary Attribute: ${hero.primaryAttr}'),
            const SizedBox(height: 8),
            Text('Attack Type: ${hero.attackType}'),
            const SizedBox(height: 8),
            Text('Roles: ${hero.roles.join(', ')}'),
            Text('Base Health: ${hero.baseHealth}'),
            Text('Base Mana: ${hero.baseMana}'),
            Text('Base Strength: ${hero.baseStr}'),
            Text('Base Agility: ${hero.baseAgi}'),
            Text('Base Intelligence: ${hero.baseInt}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
