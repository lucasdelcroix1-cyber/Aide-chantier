class SeedProduct {
  const SeedProduct({
    required this.name,
    required this.category,
    required this.store,
    required this.unit,
    required this.price,
    required this.quality,
    required this.url,
  });

  final String name;
  final String category;
  final String store;
  final String unit;
  final double price;
  final String quality;
  final String url;
}

const seedProducts = <SeedProduct>[
  SeedProduct(
    name: 'Carrelage grès cérame 45x45',
    category: 'carrelage',
    store: 'Leroy Merlin',
    unit: 'm²',
    price: 18.90,
    quality: 'standard',
    url: 'https://www.leroymerlin.fr',
  ),
  SeedProduct(
    name: 'Carrelage premier prix',
    category: 'carrelage',
    store: 'Brico Dépôt',
    unit: 'm²',
    price: 10.90,
    quality: 'economique',
    url: 'https://www.bricodepot.fr',
  ),
  SeedProduct(
    name: 'Parquet stratifié chêne',
    category: 'parquet',
    store: 'Castorama',
    unit: 'm²',
    price: 14.90,
    quality: 'standard',
    url: 'https://www.castorama.fr',
  ),
  SeedProduct(
    name: 'Peinture blanche murs et plafonds',
    category: 'peinture',
    store: 'ManoMano',
    unit: 'L',
    price: 7.90,
    quality: 'standard',
    url: 'https://www.manomano.fr',
  ),
];
