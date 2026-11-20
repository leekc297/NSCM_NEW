import { defineConfig } from '@playwright/test';
import * as fs from 'node:fs';
import * as path from 'node:path';
// 2026-11-12 T275: 결과 파일 쓰기가 간헐적으로 'UNKNOWN: unknown error, open …' 로 실패해 측정 결과가 사라졌다
//   (주기 1 시험 화면 SCP0028 17:12~17:50 실측 4건 — e2e_results.json 2 · combo_cascade.json 1 · popup_results.json 1 · 실패 원인 미확인).
//   설정 파일은 실행기·작업 프로세스 모두 스펙보다 먼저 읽으므로, 여기서 node:fs 의 쓰기 함수에 재시도를 건다(최대 8회 · 0.25초씩 늘림). 끝내 실패하면 원래 오류를 그대로 던진다.
{
  const realFs = require('node:fs') as Record<string, unknown>;
  const RETRY_CODES = new Set(['UNKNOWN', 'EBUSY', 'EPERM', 'EACCES', 'EINVAL']);
  const nap = (ms: number) => { Atomics.wait(new Int32Array(new SharedArrayBuffer(4)), 0, 0, ms); };
  for (const name of ['writeFileSync', 'appendFileSync', 'renameSync', 'copyFileSync']) {
    const orig = realFs[name] as ((...a: unknown[]) => unknown) & { __nscmRetry?: boolean };
    if (typeof orig !== 'function' || orig.__nscmRetry) continue;
    const wrapped = function (this: unknown, ...a: unknown[]) {
      for (let i = 0; ; i++) {
        try { return orig.apply(this, a); } catch (e) {
          const code = String((e as { code?: string }).code || '');
          if (i >= 8 || !RETRY_CODES.has(code)) throw e;
          if (i === 0) console.log(`[파일 쓰기 재시도] ${name} ${String(a[0]).slice(-80)} — ${code}`);
          nap(250 * (i + 1));
        }
      }
    } as typeof orig;
    wrapped.__nscmRetry = true;
    realFs[name] = wrapped;
  }
}
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
    // 2026-10-31: 1600 폭에서는 SCP0111 처럼 메타 FIXED_FLAG 로 정적 컬럼 21개(1415px)가 전부 고정되는 그리드의 스크롤 영역이 0 에 가까워(client 1383)
    //   월 컬럼이 렌더되지 않아 D1/E1/H13 동적 컬럼 측정이 불가했다(viewRange c-1~-1). 사용자 모니터(FHD+)에 맞춰 넓게 — 고정 폭 ↔ 뷰포트 경고는 H12 가 따로 낸다
    //   2026-10-31 2560 은 그리드 프로브·K1·W4c 가 극단적으로 느려져 타임아웃 → FHD(1920×1080). 고정 영역이 가시 폭을 넘는 그리드는 probe.unfreezeIfNeeded 가 측정 동안 고정을 푼다
    viewport: { width: Number(process.env.E2E_VIEWPORT_W || 1920), height: Number(process.env.E2E_VIEWPORT_H || 1080) },
    locale: 'ko-KR',
    // 2026-11-06(SCP0131 smoke 2번 20분 타임아웃 2일 연속): timeout 없는 click()/fill() 이 가려진·불안정한 요소에서 테스트 타임아웃(20분)까지 매달리고 재시도로 2배 —
    //   모든 액션의 기본 상한을 둔다(명시한 timeout 이 우선). 긴 대기는 waitForResponse/waitFor 에 timeout 을 명시해 두었다.
    actionTimeout: 20_000,
    navigationTimeout: 60_000,
  },
  outputDir: path.join(results, 'artifacts'),
  // 2026-11-06 플랜 3-2: 스냅샷 골든 위치 — toHaveScreenshot('<ID>/snap/golden/<key>.png') → Doc/verify/<ID>/snap/golden/<key>.png (testDir=Doc/e2e/specs 기준 ../../verify)
  //   승인은 snap_approve.py 가 한다(--update-snapshots 금지 · 승인 게이트 우회)
  snapshotPathTemplate: '{testDir}/../../verify/{arg}{ext}',
  // 브라우저: 노트북에 설치된 Chrome(channel 'chrome')을 쓴다 — Playwright chromium 다운로드(외부망) 불필요. Edge 로 바꾸려면 E2E_CHANNEL=msedge
  projects: [{ name: 'chromium', use: { browserName: 'chromium', channel: process.env.E2E_CHANNEL || 'chrome' } }],
});
