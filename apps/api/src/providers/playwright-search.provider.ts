import { chromium } from '@playwright/test';

import { CompareItem, ProductOffer } from '../types.js';
import { PriceProvider } from './price-provider.js';

export class PlaywrightSearchProvider implements PriceProvider {
  store = 'generic';

  async search(item: CompareItem): Promise<ProductOffer[]> {
    const browser = await chromium.launch({
      headless: true,
    });

    const page = await browser.newPage();

    const searchUrl = `https://www.google.com/search?q=${encodeURIComponent(item.query)}`;

    await page.goto(searchUrl, {
      waitUntil: 'domcontentloaded',
    });

    await browser.close();

    return [
      {
        store: this.store,
        title: item.query,
        price: 0,
        availability: 'unknown',
        productUrl: searchUrl,
        checkedAt: new Date().toISOString(),
        source: 'live',
      },
    ];
  }
}
