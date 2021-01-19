class ListItem {
  String text;
  bool isChecked;
  ListItem(this.text, this.isChecked);

  @override
  toString() {
    return 'text: $text, isChecked: $isChecked';
  }

  Map<String, dynamic> toJson() => {
    'text': this.text, 'isChecked': this.isChecked
  };
  factory ListItem.fromJson(Map<String, dynamic> listItem) =>
      ListItem(listItem['text'], listItem['isChecked']);
}
