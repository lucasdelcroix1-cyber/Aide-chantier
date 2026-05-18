import cors from 'cors';
import express from 'express';

import { compareProducts } from './services/compare.service.js';

const app = express();

app.use(cors());
app.use(express.json());

app.get('/health', (_, response) => {
  response.json({
    ok: true,
  });
});

app.post('/api/compare', async (request, response) => {
  try {
    const result = await compareProducts(request.body);

    response.json(result);
  } catch (error) {
    response.status(500).json({
      error: 'COMPARE_FAILED',
      details: String(error),
    });
  }
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`RénovPrix API running on port ${PORT}`);
});
