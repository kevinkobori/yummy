class SectionItem {
  SectionItem({this.image, this.brand});

  SectionItem.fromMap(Map<String, dynamic> map) {
    image = map['image'] as String;
    brand = map['brand'] as String;
  }

  dynamic image;
  String brand;

  SectionItem clone() {
    return SectionItem(
      image: image,
      brand: brand,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'brand': brand,
    };
  }

  @override
  String toString() {
    return 'SectionItem{image: $image, brand: $brand}';
  }
}
