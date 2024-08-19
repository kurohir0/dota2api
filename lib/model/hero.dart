class Heros {
  final int id;
  final String name;
  final String localizedName;
  final String primaryAttr;
  final String attackType;
  final List<String> roles;
  final String img;
  final String icon;
  final int baseHealth;
  final int baseMana;
  final int baseArmor;
  final int baseStr;
  final int baseAgi;
  final int baseInt;

  Heros({
    required this.id,
    required this.name,
    required this.localizedName,
    required this.primaryAttr,
    required this.attackType,
    required this.roles,
    required this.img,
    required this.icon,
    required this.baseHealth,
    required this.baseMana,
    required this.baseArmor,
    required this.baseStr,
    required this.baseAgi,
    required this.baseInt,
  });

  factory Heros.fromJson(Map<String, dynamic> json) {
    return Heros(
      id: json['id'],
      name: json['name'],
      localizedName: json['localized_name'],
      primaryAttr: json['primary_attr'],
      attackType: json['attack_type'],
      roles: List<String>.from(json['roles']),
      img: json['img'],
      icon: json['icon'],
      baseHealth: json['base_health'],
      baseMana: json['base_mana'],
      baseArmor: json['base_armor'],
      baseStr: json['base_str'],
      baseAgi: json['base_agi'],
      baseInt: json['base_int'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'localized_name': localizedName,
      'primary_attr': primaryAttr,
      'attack_type': attackType,
      'roles': roles,
      'img': img,
      'icon': icon,
      'base_health': baseHealth,
      'base_mana': baseMana,
      'base_armor': baseArmor,
      'base_str': baseStr,
      'base_agi': baseAgi,
      'base_int': baseInt,
    };
  }
}
