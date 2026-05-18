type CacheEntry<T> = {
  value: T;
  expiresAt: number;
};

export class TtlCache<T> {
  private entries = new Map<string, CacheEntry<T>>();

  constructor(private readonly ttlMs: number) {}

  get(key: string): T | null {
    const entry = this.entries.get(key);

    if (!entry) {
      return null;
    }

    if (Date.now() > entry.expiresAt) {
      this.entries.delete(key);
      return null;
    }

    return entry.value;
  }

  set(key: string, value: T) {
    this.entries.set(key, {
      value,
      expiresAt: Date.now() + this.ttlMs,
    });
  }

  clear() {
    this.entries.clear();
  }
}

export function buildCacheKey(parts: Array<string | number | undefined>) {
  return parts
    .filter((part) => part !== undefined && part !== '')
    .map((part) => String(part).trim().toLowerCase())
    .join(':');
}
