class ShoppingList {
  final String id;
  final String name;
  final List<String> items;

  ShoppingList({this.id, this.name, this.items});

  factory ShoppingList.fromJson(Map<String, dynamic> json) {
    return ShoppingList(
      id: json['id'],
      name: json['name'],
      items: json['items'],
    );
  }
}