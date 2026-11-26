// 2026-11-20 D1 한 화면 안 E2E 동시 실행(사용자 지시: "E2E 테스트의 경우에도 간섭이 없는 범위에서 동시 수행" · 정합성이 같은 대체 방법만)
//
// 간섭 기준 = 서버 상태를 바꾸는 요청. 이것을 보내는 시험(쓰기 시험)은 동시 실행하지 않는다.
//   - 저장 계열 call-proc(SAVE·INS·UPD·DEL 버튼) 가 실제 서버로 간 경우(VERIFY_NO_SAVE·CL_FAKE_SAVE 가짜 응답은 서버를 바꾸지 않으므로 제외)
//   - call-proc 이 아닌 /api/ 의 GET 이 아닌 요청 중 읽기 목록(READ_API)에 없는 것 전부(언어 /user/session/lang-cd · 시간대 tmz-cd · 즐겨찾기 /admin/menu/favorite · 개인화 저장 등)
//     모르는 요청은 쓰기로 본다(동시 실행에서 빠질 뿐 판정은 같다)
// 기록: 시험마다 Doc/verify/<ID>/e2e_test_kind.jsonl 에 {run, file, title, write, urls} 한 줄. run_verify.py 가 다음 실행 때 이 기록으로 읽기 시험만 동시에 돌린다
// 보호: E2E_PHASE=read(동시 실행 단계)에서 쓰기 요청이 나오면 서버로 보내지 않고 끊는다(abort) → 그 시험은 위반으로 기록되고 run_verify 가 차례 실행 단계에서 다시 돈다(결과는 행 단위로 덮어씀)
import * as fs from 'node:fs';
import * as path from 'node:path';
import type { Page, Request, Route } from '@playwright/test';

const ROOT = path.join(__dirname, '..', '..', '..');
const RUN = process.env.VERIFY_RUN_ID || new Date().toISOString();
export const PHASE = (process.env.E2E_PHASE || '').toLowerCase();
const FAKE_SAVE = !!(process.env.VERIFY_NO_SAVE || process.env.CL_FAKE_SAVE);
// 상태를 바꾸지 않는 POST 경로(로그인·조회형). 모르면 쓰기
// 2026-11-20 사용자 지시(E2E 시간 단축): admin/lookup(-muti) = 조회만(LookupController.java:52 → LookupServiceImpl selectList) · admin/log/menu-access = 화면을 처음 열 때 접속 기록 1건(LogController.java:80 · 시험이 확인하는 화면 데이터와 무관)
//   종전엔 이 두 주소 때문에 화면을 열기만 해도 모든 시험이 쓰기로 분류돼 동시 실행이 한 번도 없었음(SCP0028 97/97 · SSP0014 118/118 · SCP0005 108/108)
const READ_API = /\/api\/(?:user\/(?:login|session)(?:\?|$)|sso\/dev-login|admin\/combo(?:-muti)?(?:\?|$)|admin\/lookup(?:-muti)?(?:\?|$)|admin\/log\/menu-access(?:\?|$)|admin\/menu\/(?!favorite))/i;  // 로그인(lib/nscm.ts loginAs) · 콤보(admin/combo, combo-muti) · 메뉴 조회(즐겨찾기 제외). 근거 2026-11-20 nscm.ts:79,121
const PROC = /\/call-proc(?:-stream)?(?:\?|$)/i;
const PROC_WRITE = /\/(SAVE|INS|UPD|DEL)[^/]*\/call-proc/i;

/** 이 요청이 서버 상태를 바꾸는가. fakeSaved = 저장 call-proc 을 가짜 응답으로 돌리는 실행인가 */
export function isWrite(method: string, url: string, fakeSaved = FAKE_SAVE): boolean {
  if (!/\/api\//i.test(url) || /^(GET|HEAD|OPTIONS)$/i.test(method)) return false;
  if (PROC.test(url)) return PROC_WRITE.test(url) && !fakeSaved;
  return !READ_API.test(url);
}

export type Guard = { writes: string[]; blocked: string[] };
/** page 에 감시 설치. 동시 실행 단계면 쓰기 요청을 끊는다 */
export async function installWriteGuard(page: Page): Promise<Guard> {
  const g: Guard = { writes: [], blocked: [] };
  const note = (rq: Request) => { const u = rq.url().replace(/^.*?\/api\//, '/api/').slice(0, 160); if (!g.writes.includes(u)) g.writes.push(u); return u; };
  if (PHASE === 'read') {
    await page.route(/\/api\//, async (route: Route) => {
      const rq = route.request();
      if (isWrite(rq.method(), rq.url())) { const u = note(rq); g.blocked.push(u); console.log(`[동시 실행 보호] 쓰기 요청을 보내지 않음 ${rq.method()} ${u} — 이 시험은 차례 실행 단계에서 다시 돈다`); await route.abort('blockedbyclient'); return; }
      await route.fallback();
    });
  } else {
    page.on('request', rq => { if (isWrite(rq.method(), rq.url())) note(rq); });
  }
  return g;
}

/** 시험 1건 기록 */
export function recordKind(file: string, title: string, g: Guard) {
  const vid = (process.env.VERIFY_ID || '').toUpperCase(); if (!vid || process.env.CL_MUTATE) return;  // 변이 실행(CL_MUTATE)만 뺀다. eg 검사기(CL_SELFTEST_BASE)도 기록해야 eg_chain 이 동시 실행을 판단한다
  try {
    const d = path.join(ROOT, 'Doc', 'verify', vid); fs.mkdirSync(d, { recursive: true });
    fs.appendFileSync(path.join(d, 'e2e_test_kind.jsonl'), JSON.stringify({ run: RUN, phase: PHASE || 'serial', file: path.basename(file), title, write: g.writes.length > 0, blocked: g.blocked.length > 0, urls: g.writes.slice(0, 8), at: new Date().toISOString() }) + '\n', 'utf8');
  } catch { /* 기록 실패 = 다음 실행에서 이 시험을 모름 → 차례 실행(안전한 쪽) */ }
}

/** 여러 작업자 프로세스가 같은 파일을 읽고 고쳐 쓰는 구간 잠금(동시 실행 단계용). 잠금 파일 생성(wx)으로 30초까지 기다린다 */
export function withFileLock<T>(file: string, fn: () => T): T {
  const lk = file + '.lock'; const t0 = Date.now(); let fd = -1;
  for (;;) {
    try { fd = fs.openSync(lk, 'wx'); break; } catch {
      try { if (Date.now() - fs.statSync(lk).mtimeMs > 60_000) { fs.unlinkSync(lk); continue; } } catch { /* 이미 지워짐 */ }
      if (Date.now() - t0 > 30_000) break;  // 30초 넘으면 잠금 없이 진행(종전 동작) — 기록이 멈추는 것보다 낫다
      Atomics.wait(new Int32Array(new SharedArrayBuffer(4)), 0, 0, 50);
    }
  }
  try { return fn(); } finally { if (fd >= 0) { try { fs.closeSync(fd); fs.unlinkSync(lk); } catch { /* 정리 실패 무시 */ } } }
}
