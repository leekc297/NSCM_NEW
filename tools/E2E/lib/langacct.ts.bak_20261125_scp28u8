// langacct — 언어 전환 시험 전용 계정 고르기(2026-11-19 사용자 지시)
//   "minyonglee1 과 사업부 권한이 같은 ADMIN 권한자 목록을 관리하고, 언어 전환 시험 때 다른 세션이 쓰지 않는 사용자로 로그인해서 사용"
//   언어는 서버 계정 설정(SCM_ADM_USER_M.LANG_CD)이라 같은 계정을 쓰는 다른 화면 시험까지 바뀐다(T200) → 종전엔 다른 화면 E2E 가 끝날 때까지 기다렸다(I2 6분 상한 · 측정 실패).
//   목록 = users.json adminPool.users. 고르지 않는 계정 = 기본 계정(e2e.config defaultAccount·forceAccount·E2E_ACCOUNT) · users.json 의 다른 시험 계정(영역 명부·화면 지정·GUEST)
//   · 다른 실행이 잡은 계정(잠금 Doc/e2e/_run.langacct.<USER>.lock · 주인 생존).
//   잠금에는 그 사용자의 원래 언어(orig)를 적는다. 시험이 끊겨 원래 언어로 못 돌렸으면 잠금을 남기고(restored false), 다음에 그 계정을 잡는 실행이 원래 언어로 먼저 되돌린다.
import * as fs from 'fs';
import * as path from 'path';

const ROOT = path.join(__dirname, '..', '..', '..');
const DIR = path.join(ROOT, 'Doc', 'e2e');
const LK = (u: string) => path.join(DIR, `_run.langacct.${u.replace(/[^A-Za-z0-9._-]/g, '_')}.lock`);
type Lock = { pid: number; at: number; tag: string; user: string; orig: string; restored?: boolean };
export type LangAcct = { user: string; staleOrig: string };

const alive = (pid: number) => { try { process.kill(pid, 0); return true; } catch (e) { return (e as NodeJS.ErrnoException).code === 'EPERM'; } };
const readJson = (p: string): any => { try { return JSON.parse(fs.readFileSync(p, 'utf8').replace(/^﻿/, '')); } catch { return null; } };  // eslint-disable-line @typescript-eslint/no-explicit-any

/** users.json 에서 다른 시험이 로그인하는 계정(영역 명부·화면 지정·GUEST)과 기본 계정 */
export function reservedAccounts(): Set<string> {
  const out = new Set<string>(); const uj = readJson(path.join(ROOT, 'tools', 'E2E', 'users.json')) || {}; const cfg = readJson(path.join(ROOT, 'tools', 'E2E', 'e2e.config.json')) || {};
  const walk = (v: unknown) => { if (typeof v === 'string') { if (v.trim()) out.add(v.trim().toLowerCase()); } else if (Array.isArray(v)) v.forEach(walk); else if (v && typeof v === 'object') for (const [k, x] of Object.entries(v as Record<string, unknown>)) { if (!/^_|note|doc|updated|mode|conds|extracted|appliesTo|roles|groupDisabled/i.test(k)) walk(x); } };
  for (const a of Object.values((uj.areas || {}) as Record<string, { divisions?: unknown; admins?: unknown }>)) { walk(a.divisions); walk(a.admins); }
  for (const s of Object.values((uj.screens || {}) as Record<string, { accounts?: unknown; extra?: unknown }>)) { walk(s.accounts); walk(s.extra); }
  walk(uj.guestAccount);
  for (const k of ['defaultAccount', 'forceAccount']) if (cfg[k]) out.add(String(cfg[k]).toLowerCase());
  if (process.env.E2E_ACCOUNT) out.add(process.env.E2E_ACCOUNT.toLowerCase());
  if (uj.adminPool && uj.adminPool.default) out.add(String(uj.adminPool.default).toLowerCase());
  return out;
}

/** 후보 계정 — adminPool.users 중 예약 계정 제외(순서 유지) */
export function langCandidates(): string[] {
  const uj = readJson(path.join(ROOT, 'tools', 'E2E', 'users.json')) || {}; const rs = reservedAccounts();
  return ((uj.adminPool && uj.adminPool.users) || []).map((u: unknown) => String(u)).filter((u: string) => u && !rs.has(u.toLowerCase()));
}

/** 다른 실행이 쓰지 않는 계정 하나를 잡는다 — 없으면 null(호출부는 종전 방식: 기본 계정 + 다른 화면 대기) */
export function takeLangAccount(tag: string): LangAcct | null {
  fs.mkdirSync(DIR, { recursive: true });
  for (const u of langCandidates()) {
    const lk = LK(u); const me: Lock = { pid: process.pid, at: Date.now(), tag, user: u, orig: '' };
    try { fs.writeFileSync(lk, JSON.stringify(me), { flag: 'wx' }); return { user: u, staleOrig: '' }; } catch { /* 이미 있음 */ }
    const l = readJson(lk) as Lock | null;
    if (l && (l.pid === process.pid || alive(l.pid))) continue;         // 다른 실행이 쓰는 중 · 이 실행이 이미 잡은 계정(2026-11-19 실측: 같은 프로세스가 두 번 잡으면 같은 계정이 나옴)
    // 주인이 죽은 잠금 = 낡은 잠금. 원래 언어(orig)가 남아 있으면 그대로 넘겨받아 먼저 되돌린다
    const orig = l && !l.restored ? String(l.orig || '') : '';
    try { fs.writeFileSync(lk, JSON.stringify({ ...me, orig })); } catch { continue; }
    const back = readJson(lk) as Lock | null; if (!back || back.pid !== process.pid) continue;  // 동시에 낡은 잠금을 가져간 실행이 있으면 다음 후보
    return { user: u, staleOrig: orig };
  }
  return null;
}

/** 원래 언어 기록(처음 한 번만 — 넘겨받은 원래 언어가 있으면 유지) */
export function markLangOrig(user: string, code: string): void {
  const lk = LK(user); const l = readJson(lk) as Lock | null; if (!l || l.pid !== process.pid || l.orig || !code) return;
  try { fs.writeFileSync(lk, JSON.stringify({ ...l, orig: code, at: Date.now() })); } catch { /* 기록 실패 — 원복은 finally 가 시도 */ }
}

/** 시험 끝 — 원래 언어로 되돌렸으면 잠금 삭제 · 못 되돌렸으면 잠금을 남겨 다음 실행이 되돌리게 한다 */
export function releaseLangAccount(user: string, restored: boolean): void {
  const lk = LK(user); const l = readJson(lk) as Lock | null; if (!l || l.pid !== process.pid) return;
  if (restored || !l.orig) { try { fs.unlinkSync(lk); } catch { /* 없음 */ } return; }
  try { fs.writeFileSync(lk, JSON.stringify({ ...l, restored: false, at: Date.now() })); } catch { /* 없음 */ }
  console.log(`[langacct] ${user}: 원래 언어 ${l.orig} 로 못 되돌림 — 잠금 남김(다음에 이 계정을 잡는 실행이 먼저 되돌림)`);
}
