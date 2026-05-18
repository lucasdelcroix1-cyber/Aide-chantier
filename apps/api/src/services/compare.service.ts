import { PlaywrightSearchProvider } from '../providers/playwright-search.provider.js';
import { CompareRequest } from '../types.js';

const providers = [new PlaywrightSearchProvider()];

export async function compareProducts(input: CompareRequest) {
  const results = [];

  for (const item of input.items) {
    for (const provider of providers) {
      const offers = await provider.search(item);

      results.push({
        item,
        provider: provider.store,
        offers,
      });
    }
  }

  return {
    checkedAt: new Date().toISOString(),
    results,
  };
}
