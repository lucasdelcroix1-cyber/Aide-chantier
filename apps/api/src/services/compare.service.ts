import { CastoramaProvider } from '../providers/castorama.provider.js';
import { LeroyMerlinProvider } from '../providers/leroy-merlin.provider.js';
import { CompareRequest } from '../types.js';

const providers = [
  new LeroyMerlinProvider(),
  new CastoramaProvider(),
];

export async function compareProducts(input: CompareRequest) {
  const results = [];

  for (const item of input.items) {
    for (const provider of providers) {
      try {
        const offers = await provider.search(item);

        results.push({
          item,
          provider: provider.store,
          offers,
        });
      } catch (error) {
        results.push({
          item,
          provider: provider.store,
          offers: [],
          error: String(error),
        });
      }
    }
  }

  return {
    checkedAt: new Date().toISOString(),
    results,
  };
}
