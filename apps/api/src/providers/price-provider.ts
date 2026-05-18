import { CompareItem, ProductOffer } from '../types.js';

export interface PriceProvider {
  store: string;

  search(item: CompareItem): Promise<ProductOffer[]>;
}
