// 2026-11-20 CheckList 속도 개선 B1: page → 그 page 의 조회 응답 기록. probe.waitRows 가 '서버가 0행을 돌려준 뒤'인지 알기 위해 쓴다(nscm.ts 와 순환 import 를 피하려고 따로 둠)
import type { Page } from '@playwright/test';

export type ProcLite = { btn: string; at?: string; rows: number | null; rowsSure?: boolean; done?: boolean; doneAt?: number };
export type PageProc = { allCalls: ProcLite[]; pendingProc: number; lastProcReqAt: number };
export const pageReg = new WeakMap<Page, PageProc>();

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
