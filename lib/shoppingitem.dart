class ShoppingItem {
  String text;
  bool isChecked;
  ShoppingItem(this.text, this.isChecked);

  @override
  toString() {
    return 'text: $text, isChecked: $isChecked';
  }

  Map<String, dynamic> toJson() => {
    'text': this.text, 'isChecked': this.isChecked
  };
  factory ShoppingItem.fromJson(Map<String, dynamic> listItem) =>
      ShoppingItem(listItem['text'], listItem['isChecked']);
}
