class ShoppingItem {
  final String text;
  bool isChecked;

  ShoppingItem({this.text = '', this.isChecked = false});

  ShoppingItem copyWith({String text = '', bool isChecked = false}) {
    return ShoppingItem(
      text: text ?? this.text,
      isChecked: isChecked ?? this.isChecked,
    );
  }

  @override
  String toString() {
    return 'text: $text, isChecked: $isChecked';
  }

  Map<String, dynamic> toJson() => {
    'text': text,
    'isChecked': isChecked,
  };

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    String text = json['text'] as String ?? '';
    bool isChecked = json['isChecked'] as bool ?? false;

    return ShoppingItem(
      text: text,
      isChecked: isChecked,
    );
  }
}