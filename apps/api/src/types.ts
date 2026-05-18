export type CompareRequest = {
  postalCode?: string;
  items: CompareItem[];
};

export type CompareItem = {
  category: string;
  query: string;
  quantity: number;
  unit: string;
};

export type ProductOffer = {
  store: string;
  title: string;
  price: number;
  unitPrice?: number;
  unit?: string;
  availability?: string;
  productUrl: string;
  imageUrl?: string;
  checkedAt: string;
  source: 'live' | 'cache' | 'failed';
};
