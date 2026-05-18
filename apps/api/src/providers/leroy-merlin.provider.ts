import { chromium } from '@playwright/test';

import { buildCacheKey, TtlCache } from '../cache.js';
import { CompareItem, ProductOffer } from '../types.js';
import { PriceProvider } from './price-provider.js';

const cache = new TtlCache<ProductOffer[]>(15 * 60 * 1000);

export class LeroyMerlinProvider implements PriceProvider {
  store = 'leroy_merlin';

  async search(item: CompareItem): Promise<ProductOffer[]> {
    const cacheKey = buildCacheKey([
      this.store,
      item.query,
    ]);

    const cached = cache.get(cacheKey);

    if (cached) {
      return cached.map((offer) => ({
        ...offer,
        source: 'cache',
      }));
    }

    const browser = await chromium.launch({
      headless: true,
    });

    const page = await browser.newPage();

    const searchUrl = `https://www.leroymerlin.fr/recherche?q=${encodeURIComponent(item.query)}`;

    await page.goto(searchUrl, {
      waitUntil: 'domcontentloaded',
    });

    const title = await page.title();

    await browser.close();

    const offers: ProductOffer[] = [
      {
        store: this.store,
        title,
        price: 0,
        availability: 'unknown',
        productUrl: searchUrl,
        checkedAt: new Date().toISOString(),
        source: 'live',
      },
    ];

    cache.set(cacheKey, offers);

    return offers;
  }
}
