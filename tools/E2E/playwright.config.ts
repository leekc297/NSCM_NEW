import { defineConfig } from '@playwright/test';
import * as fs from 'node:fs';
import * as path from 'node:path';
const cfg = JSON.parse(fs.readFileSync(path.join(__dirname, 'e2e.config.json'), 'utf8').replace(/^\uFEFF/, ''));
const results = process.env.E2E_RESULTS || cfg.resultsDir;
export default defineConfig({
  testDir: process.env.E2E_SPECS || cfg.specsDir,
  timeout: 180_000,
  expect: { timeout: 20_000 },
  retries: 1,
  workers: 2,
  fullyParallel: false,
  reporter: [['list'], ['json', { outputFile: path.join(results, 'results.json') }], ['html', { outputFolder: path.join(results, 'html'), open: 'never' }]],
  use: {
    baseURL: process.env.E2E_FE || cfg.feUrl,
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
    video: 'off',
    viewport: { width: 1600, height: 900 },
    locale: 'ko-KR',
  },
  outputDir: path.join(results, 'artifacts'),
  // 브라우저: 노트북에 설치된 Chrome(channel 'chrome')을 쓴다 — Playwright chromium 다운로드(외부망) 불필요. Edge 로 바꾸려면 E2E_CHANNEL=msedge
  projects: [{ name: 'chromium', use: { browserName: 'chromium', channel: process.env.E2E_CHANNEL || 'chrome' } }],
});
