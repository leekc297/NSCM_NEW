import { defineConfig } from '@playwright/test';
import * as fs from 'node:fs';
import * as path from 'node:path';
const cfg = JSON.parse(fs.readFileSync(path.join(__dirname, 'e2e.config.json'), 'utf8').replace(/^\uFEFF/, ''));
const results = process.env.E2E_RESULTS || cfg.resultsDir;
// 2026-10-21: 경로 대소문자 통일 — VS Code(Vibe_Manager)가 'c:\…' 로 실행하면 설정의 'C:\…' 스펙 폴더와 드라이브 문자가 달라
//   @playwright/test 가 두 경로로 두 번 로드돼 "Requiring @playwright/test second time" 로 시작조차 못 했다(SCP0100 체인).
//   testDir 은 이 파일(__dirname) 기준 상대경로로 다시 만들어 같은 표기를 쓴다.
const sameCase = (abs: string) => { const repo = path.resolve(__dirname, '..', '..'); const rel = path.relative(repo, abs); return rel && !rel.startsWith('..') && !path.isAbsolute(rel) ? path.join(repo, rel) : abs; };
export default defineConfig({
  testDir: process.env.E2E_SPECS || sameCase(cfg.specsDir),
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
