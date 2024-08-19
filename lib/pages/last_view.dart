import 'package:flutter/material.dart';
import 'package:dwi_dota2/model/hero.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LastViewedHeroPage extends StatefulWidget {
  const LastViewedHeroPage({super.key});

  @override
  _LastViewedHeroPageState createState() => _LastViewedHeroPageState();
}

class _LastViewedHeroPageState extends State<LastViewedHeroPage> {
  Heros? _lastViewedHero;

  @override
  void initState() {
    super.initState();
    _loadLastViewedHero();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Last Viewed Hero'),
      ),
      body: _lastViewedHero == null
          ? const Center(child: Text('No hero viewed recently.'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(
                      'https://cdn.akamai.steamstatic.com${_lastViewedHero!.img}',
                      height: 250,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                            child: Text('Failed to load image'));
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _lastViewedHero!.localizedName,
                  ),
                  const SizedBox(height: 8),
                  Text('Primary Attribute: ${_lastViewedHero!.primaryAttr}'),
                  const SizedBox(height: 8),
                  Text('Attack Type: ${_lastViewedHero!.attackType}'),
                  const SizedBox(height: 8),
                  Text('Roles: ${_lastViewedHero!.roles.join(', ')}'),
                  const SizedBox(height: 8),
                  Text('Base Health: ${_lastViewedHero!.baseHealth}'),
                  Text('Base Mana: ${_lastViewedHero!.baseMana}'),
                  Text('Base Strength: ${_lastViewedHero!.baseStr}'),
                  Text('Base Agility: ${_lastViewedHero!.baseAgi}'),
                  Text('Base Intelligence: ${_lastViewedHero!.baseInt}'),
                ],
              ),
            ),
    );
  }
}
