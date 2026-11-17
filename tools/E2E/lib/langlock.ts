// langlock — 언어 전환 시험 동안 다른 실행이 화면을 열지 않게 하는 잠금(2026-11-10 T189).
//   TO-BE 언어는 브라우저가 아니라 서버 사용자 설정(/user/session/lang-cd → SCM_ADM_USER_M)이라 같은 계정으로 동시에 도는
//   다른 화면 실행까지 언어가 바뀐다(SSP0024 v5 팝업 첫 컬럼 '序号' · 건수 '9,616' 을 검색값으로 넣은 허위 FAIL 3건 — 같은 시각 SCP0033 시나리오 ENG→CHN).
//   언어를 바꾸는 시험(I2 문구 덤프 · 시나리오 lang 단계)은 acquireLang → 바꾸고 → 원래 언어로 되돌린 뒤 releaseLang.
//   다른 시험은 openScreen 에서 waitLangFree 로 잠금이 풀릴 때까지 기다린다(같은 프로세스 잠금은 무시 · 주인 프로세스가 죽었거나 30분 넘은 잠금은 낡은 잠금).
import * as fs from 'fs';
import * as path from 'path';

const LOCK = path.join(__dirname, '..', '..', '..', 'Doc', 'e2e', '_run.lang.lock');
const STALE_MS = 30 * 60_000;
type L = { pid: number; at: number; tag: string };

const alive = (pid: number) => { try { process.kill(pid, 0); return true; } catch (e) { return (e as NodeJS.ErrnoException).code === 'EPERM'; } };
const read = (): L | null => { try { return JSON.parse(fs.readFileSync(LOCK, 'utf8')) as L; } catch { return null; } };
const stale = (l: L) => !alive(l.pid) || Date.now() - l.at > STALE_MS;
const sleep = (ms: number) => new Promise(r => setTimeout(r, ms));

/** 언어 전환 잠금 획득 — 최대 maxMs 기다림. 반환 = 기다린 ms(획득 실패 시 -1) */
export async function acquireLang(tag: string, maxMs = 30 * 60_000): Promise<number> {
  const t0 = Date.now();
  for (;;) {
    try { fs.writeFileSync(LOCK, JSON.stringify({ pid: process.pid, at: Date.now(), tag }), { flag: 'wx' }); return Date.now() - t0; } catch { /* 이미 있음 */ }
    const l = read();
    if (l && l.pid === process.pid) { fs.writeFileSync(LOCK, JSON.stringify({ pid: process.pid, at: Date.now(), tag })); return Date.now() - t0; }
    if (!l || stale(l)) { try { fs.unlinkSync(LOCK); } catch { /* 경합 */ } continue; }
    if (Date.now() - t0 > maxMs) return -1;
    await sleep(2_000);
  }
}

/** 2026-11-10 T200: 지금 E2E 를 돌리는 다른 화면(runlock 'verify <ID>' 잠금 · 주인 생존) — 언어 전환은 서버 계정 설정이라 이미 화면을 연 다른 실행까지 바꾼다(SSP0060 16:42 KOR 화면 측정) */
// 2026-11-10 T208(교착 18:34 실측 — SSP0021·SSP0060·SSP0015 셋 다 '다른 화면 E2E 실행 중' 으로 서로를 기다림 · I2 3건 10.0분 시간 초과):
//   언어 전환을 기다리는 실행은 화면을 측정하지 않으므로 '실행 중' 에서 뺀다 — 대기 표식 _run.langwait.<ID>.lock(pid) · 주인 생존 시만 유효
const WAIT = (id: string) => path.join(path.dirname(LOCK), `_run.langwait.${id.toUpperCase()}.lock`);
function waiting(id: string): boolean { try { const l = JSON.parse(fs.readFileSync(WAIT(id), 'utf8')) as { pid?: number }; return !!l.pid && alive(l.pid); } catch { return false; } }
export function othersRunning(myId: string): string[] {
  const dir = path.dirname(LOCK); const out: string[] = [];
  try { for (const f of fs.readdirSync(dir)) { const m = /^_run\.verify\.(.+)\.lock$/.exec(f); if (!m || m[1].toUpperCase() === myId.toUpperCase()) continue; try { const l = JSON.parse(fs.readFileSync(path.join(dir, f), 'utf8')) as { pid?: number }; if (l.pid && alive(l.pid) && !waiting(m[1])) out.push(m[1]); } catch { /* 깨진 잠금 */ } } } catch { /* 폴더 없음 */ }
  return out;
}

/** 다른 화면 E2E 가 하나도 없을 때만 언어 잠금 획득 — 최대 maxMs 기다리고 못 얻으면 -1(호출부는 언어 전환을 생략하고 측정 실패로 남긴다) */
export async function acquireLangExclusive(tag: string, myId: string, maxMs = 15 * 60_000): Promise<{ waited: number; others: string[] }> {
  const t0 = Date.now(); let said = false;
  try { fs.writeFileSync(WAIT(myId), JSON.stringify({ pid: process.pid, at: Date.now(), tag })); } catch { /* 표식 실패 — 종전 동작 */ }
  const done = (r: { waited: number; others: string[] }) => { try { fs.unlinkSync(WAIT(myId)); } catch { /* 없음 */ } return r; };
  for (;;) {
    const o = othersRunning(myId);
    if (!o.length) { const w = await acquireLang(tag, Math.max(1, maxMs - (Date.now() - t0))); if (w >= 0) { if (othersRunning(myId).length === 0) return done({ waited: Date.now() - t0, others: [] }); releaseLang(); } }
    if (Date.now() - t0 > maxMs) return done({ waited: -1, others: othersRunning(myId) });
    if (!said) { console.log(`[langlock] ${tag}: 다른 화면 E2E 실행 중(${o.join(',')}) — 끝날 때까지 언어 전환 대기`); said = true; }
    await sleep(5_000);
  }
}

// 2026-11-12 T251(2차 묶음 실측 — 9개 화면 80행이 중국어 화면을 측정: 팝업 첫 컬럼 '序号' H6 FAIL 42 · 필터 G1 FAIL 19 등):
//   언어를 바꾼 시험이 시간 초과로 끊기면(SCP0111·SSP0003·SSP0005·SSP0014·SCP0084 '문서 시나리오' 15~22분 초과 · SCP0041 I2 10분 초과) finally 의 원복이 돌지 못해
//   서버 계정 언어가 바뀐 채 남고, 주인 프로세스가 죽어 잠금은 낡은 잠금으로 풀린다 → 이후 같은 계정의 모든 측정이 그 언어로 나온다.
//   → 언어를 바꾸기 직전에 '원래 언어' 를 기록(journal)하고 원복을 확인한 뒤에만 지운다. 기록이 남아 있는데 주인이 죽었으면 다음 화면 열기(nscm.openScreen)가 원래 언어로 되돌린다.
const JOURNAL = path.join(path.dirname(LOCK), '_run.lang.journal.json');
export type LangJournal = { pid: number; at: number; tag: string; code: string; name: string };
/** 언어 전환 직전에 호출 — code = 언어 버튼 id(KO|EN|CN) · name = 머리글 표시(KOR|ENG|CHN). 이미 기록이 있으면(끊긴 전환) 그 원래 언어를 유지한다 */
export function markLangChanging(tag: string, code: string, name: string): void {
  if (!code || !name) return;
  let prev: LangJournal | null = null;
  try { prev = JSON.parse(fs.readFileSync(JOURNAL, 'utf8')) as LangJournal; } catch { /* 없음 */ }
  const keep = prev && prev.code && prev.name ? { code: prev.code, name: prev.name } : { code, name };
  try { fs.writeFileSync(JOURNAL, JSON.stringify({ pid: process.pid, at: Date.now(), tag, ...keep })); } catch { /* 기록 실패 — 종전 동작 */ }
}
/** 원복을 확인한 뒤 호출(nowName = 지금 머리글 표시). 원래 언어와 같을 때만 기록을 지운다 */
export function langRestored(nowName: string): boolean {
  try { const j = JSON.parse(fs.readFileSync(JOURNAL, 'utf8')) as LangJournal; if (j.name !== nowName) return false; fs.unlinkSync(JOURNAL); return true; } catch { return true; }
}
/** 끊긴 언어 전환(기록은 있는데 주인 프로세스가 죽음)이 있으면 그 기록 — 없으면 null. 주인이 살아 있으면(전환 중) null */
export function pendingLangRestore(): LangJournal | null {
  try { const j = JSON.parse(fs.readFileSync(JOURNAL, 'utf8')) as LangJournal; if (!j.code || !j.name) return null; if (j.pid !== process.pid && alive(j.pid)) return null; if (j.pid === process.pid) return null; return j; } catch { return null; }
}

export function releaseLang(): void { const l = read(); if (l && l.pid === process.pid) { try { fs.unlinkSync(LOCK); } catch { /* 없음 */ } } }

/** 다른 프로세스의 언어 전환이 끝날 때까지 기다림. 반환 = 기다린 ms */
export async function waitLangFree(maxMs = 20 * 60_000): Promise<number> {
  const t0 = Date.now(); let said = false;
  for (;;) {
    const l = read();
    if (!l || l.pid === process.pid || stale(l)) return Date.now() - t0;
    if (!said) { console.log(`[langlock] 다른 실행(${l.tag} · pid ${l.pid})이 언어 전환 중 — 끝날 때까지 대기`); said = true; }
    if (Date.now() - t0 > maxMs) { console.log(`[langlock] ${Math.round(maxMs / 60_000)}분 대기 초과 — 진행(언어가 바뀐 상태일 수 있음)`); return Date.now() - t0; }
    await sleep(2_000);
  }
}
