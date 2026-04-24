class CardModel {
  final String id;
  final String cardHolder;
  final String lastFour;
  final String expiryDate;
  final String brand; // Visa, Mastercard, etc.

  CardModel({
    required this.id,
    required this.cardHolder,
    required this.lastFour,
    required this.expiryDate,
    required this.brand,
  });

  factory CardModel.fromFirestore(Map<String, dynamic> data, String id) {
    return CardModel(
      id: id,
      cardHolder: data['cardHolder'] ?? '',
      lastFour: data['lastFour'] ?? '',
      expiryDate: data['expiryDate'] ?? '',
      brand: data['brand'] ?? 'Visa',
    );
  }
}