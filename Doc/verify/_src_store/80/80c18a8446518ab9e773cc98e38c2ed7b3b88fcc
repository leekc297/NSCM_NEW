// 2026-11-20 CheckList 속도 개선 B1: page → 그 page 의 조회 응답 기록. probe.waitRows 가 '서버가 0행을 돌려준 뒤'인지 알기 위해 쓴다(nscm.ts 와 순환 import 를 피하려고 따로 둠)
import type { Page } from '@playwright/test';

export type ProcLite = { btn: string; at?: string; rows: number | null; rowsSure?: boolean; done?: boolean; doneAt?: number };
/** 2026-11-20 20261120162234_SELF: waitRows 대기 1회 기록. why = 마지막 사유(waitReason 값 또는 emptyThenRows), sec = 대기 초, rows = 결과 행 수, capSec = 상한 초, capHit = 상한 도달 */
export type WaitWhy = { why: string; sec: number; rows: number; capSec: number; capHit: boolean };
export type PageProc = { allCalls: ProcLite[]; pendingProc: number; lastProcReqAt: number; waitWhy?: WaitWhy[]; waitWhyDrop?: number };
export const pageReg = new WeakMap<Page, PageProc>();
/** 시험 1건(page 1개)에 남기는 대기 기록 상한. 넘으면 waitWhyDrop 에 건수만 더함 */
export const WAIT_WHY_MAX = 40;

/** emptyAnswered 가 false 인 이유(true 면 'empty'). 판정 순서와 조건은 emptyAnswered 와 같다.
 *  noReg 기록 없음 · early 시작 2.5초 안 · pending 진행 중 요청 · reqGap 마지막 요청 2.5초 안 · noResp 최근 조회 응답 없음 ·
 *  notDone 응답 처리 중 · notSure 행 수 확실히 못 셈 · rows 행 있는 응답 · settle 마지막 응답 1초 안 · empty 0행 확정 */
export function waitReason(p: Page, t0: number): string {
  const r = pageReg.get(p); const now = Date.now();
  if (!r) return 'noReg';
  if (now - t0 < 2500) return 'early';
  if (r.pendingProc > 0) return 'pending';
  if (now - r.lastProcReqAt < 2500) return 'reqGap';
  const recent = r.allCalls.filter(c => !/SAVE|INS|UPD|DEL/i.test(c.btn) && c.at && Date.parse(c.at) >= t0 - 60_000);
  if (!recent.length) return 'noResp';
  if (recent.some(c => c.done !== true)) return 'notDone';
  if (recent.some(c => c.rowsSure !== true)) return 'notSure';
  if (recent.some(c => c.rows !== 0)) return 'rows';
  if (recent.some(c => now - (c.doneAt || now) < 1000)) return 'settle';
  return 'empty';
}

/** 대기 기록 1건을 page 기록에 쌓는다. 기록 없는 page 는 남기지 않음 */
export function noteWait(p: Page, w: WaitWhy): void {
  const r = pageReg.get(p); if (!r) return;
  const a = r.waitWhy || (r.waitWhy = []);
  if (a.length < WAIT_WHY_MAX) a.push(w); else r.waitWhyDrop = (r.waitWhyDrop || 0) + 1;
}

/** 조회 응답이 끝났고 전부 0행인가. 조건(모두 만족해야 true):
 *  - waitRows 시작 뒤 2.5초 지남(버튼을 누른 직후 요청이 아직 안 나간 경우 대비)
 *  - 진행 중인 call-proc 요청 0개, 마지막 요청 뒤 2.5초 동안 새 요청 없음
 *  - waitRows 시작 60초 전부터 받은 조회 응답(SAVE·INS·UPD·DEL 제외)이 1건 이상이고, 전부 행 수를 확실히 셌고(rowsSure) 0행이며, 마지막 응답 뒤 1초 지남
 *  하나라도 모르면 false = 종전처럼 상한까지 기다린다 */
export function emptyAnswered(p: Page, t0: number): boolean {
  const r = pageReg.get(p); const now = Date.now();
  if (!r || now - t0 < 2500 || r.pendingProc > 0 || now - r.lastProcReqAt < 2500) return false;
  const recent = r.allCalls.filter(c => !/SAVE|INS|UPD|DEL/i.test(c.btn) && c.at && Date.parse(c.at) >= t0 - 60_000);
  if (!recent.length) return false;
  return recent.every(c => c.done === true && c.rowsSure === true && c.rows === 0 && now - (c.doneAt || now) >= 1000);
}
