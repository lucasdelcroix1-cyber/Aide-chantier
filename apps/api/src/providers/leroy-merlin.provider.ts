import { chromium } from '@playwright/test';

import { buildCacheKey, TtlCache } from '../cache.js';
import { CompareItem, ProductOffer } from '../types.js';
import { PriceProvider } from './price-provider.js';

const cache = new TtlCache<ProductOffer[]>(15 * 60 * 1000);

function parsePrice(value: string): number {
  const normalized = value
    .replace(/\s/g, '')
    .replace(',', '.')
    .replace(/[^0-9.]/g, '');

  const price = Number.parseFloat(normalized);

  return Number.isFinite(price) ? price : 0;
}

function absoluteUrl(url: string, baseUrl: string): string {
  try {
    return new URL(url, baseUrl).toString();
  } catch {
    return baseUrl;
  }
}

export class LeroyMerlinProvider implements PriceProvider {
  store = 'leroy_merlin';

  async search(item: CompareItem): Promise<ProductOffer[]> {
    const cacheKey = buildCacheKey([this.store, item.query]);
    const cached = cache.get(cacheKey);

    if (cached) {
      return cached.map((offer) => ({ ...offer, source: 'cache' }));
    }

    const browser = await chromium.launch({ headless: true });
    const page = await browser.newPage({
      userAgent:
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124 Safari/537.36',
    });

    const searchUrl = `https://www.leroymerlin.fr/recherche?q=${encodeURIComponent(item.query)}`;

    await page.goto(searchUrl, { waitUntil: 'networkidle', timeout: 30000 });

    const rawOffers = await page.evaluate(() => {
      const cardSelectors = [
        '[data-testid*="product"]',
        '[class*="product"]',
        'article',
        'li',
      ];

      const priceRegex = /\d+[\s\d]*(?:[,.]\d{1,2})?\s*€/;
      const candidates = Array.from(
        document.querySelectorAll(cardSelectors.join(',')),
      );

      return candidates
        .map((card) => {
          const text = (card.textContent || '').replace(/\s+/g, ' ').trim();
          const link = card.querySelector('a[href]')?.getAttribute('href') || '';
          const image = card.querySelector('img')?.getAttribute('src') || '';
          const priceText = text.match(priceRegex)?.[0] || '';
          const title =
            card.querySelector('h2, h3, [class*="title"], [class*="name"]')
              ?.textContent?.replace(/\s+/g, ' ')
              .trim() || text.slice(0, 140);

          return { title, priceText, link, image, text };
        })
        .filter((offer) => offer.link && offer.priceText && offer.title)
        .slice(0, 12);
    });

    await browser.close();

    const checkedAt = new Date().toISOString();
    const offers: ProductOffer[] = rawOffers.map((offer) => ({
      store: this.store,
      title: offer.title,
      price: parsePrice(offer.priceText),
      availability: 'unknown',
      productUrl: absoluteUrl(offer.link, 'https://www.leroymerlin.fr'),
      imageUrl: offer.image
        ? absoluteUrl(offer.image, 'https://www.leroymerlin.fr')
        : undefined,
      checkedAt,
      source: 'live',
    }));

    if (offers.length === 0) {
      offers.push({
        store: this.store,
        title: `Recherche Leroy Merlin : ${item.query}`,
        price: 0,
        availability: 'unknown',
        productUrl: searchUrl,
        checkedAt,
        source: 'failed',
      });
    }

    cache.set(cacheKey, offers);
    return offers;
  }
}
