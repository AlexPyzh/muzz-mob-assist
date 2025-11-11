class FinInfo {
  FinInfo({
    this.price,
    this.shareQuantity,
    this.sharePrice,
    this.percentForSale,
    this.soldPercent,
  });

  double? price;
  int? shareQuantity;
  double? sharePrice;
  double? percentForSale;
  double? soldPercent;

  factory FinInfo.fromJson(Map<String, dynamic> json) {
    return FinInfo(
      price: json["price"] == null ? null : json["price"] + .0,
      shareQuantity: json["shareQuantity"] ?? 0,
      sharePrice: json["sharePrice"] == null ? null : json["sharePrice"] + .0,
      percentForSale:
          json["percentForSale"] == null ? null : json["percentForSale"] + .0,
      soldPercent:
          json["soldPercent"] == null ? null : json["soldPercent"] + .0,
    );
  }

  Map<String, dynamic> toJson() => {
        "price": price,
        "shareQuantity": shareQuantity,
        "sharePrice": sharePrice,
        "percentForSale": percentForSale,
        "soldPercent": soldPercent
      };
}
