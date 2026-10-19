// SCP0015 RUN/CONFIRM 버튼셀 잠금 + btnStop enable 판정 (AS-IS SetGridButtonEnabled L531-640,
//   FindData_Engin L820-827 — design 03 §3 R7~R10, design 01 §2 행3~4).
// 순수 함수 단위로 분리 — 그리드 formatItem/click 과 페이지가 같은 판정을 공유한다.
import { PLAN_STATUS } from '../plan-management.constants';
import type { PlanRow } from '../plan-management.types';

const cell = (v: unknown): string =>
  (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '').trim();

/** 잠금 판정 컨텍스트 — 행 밖 조건(조회 시점 주차/전행 스캔) */
export interface PlanLockContext {
  /** 조회 시점의 PlanWeek 가 현재 주차(콤보 첫 값)였는가 — 아니면 RUN/CONFIRM 전행 잠금(R9) */
  weekCurrent: boolean;
  /** 그리드 전행 중 실행중(0)/종료중(-2) 행 존재 — 있으면 RUN 전행 잠금(R8 isPossibleRun) */
  anyRunning: boolean;
}

/** R8 전행 스캔 — 실행중(0)/종료중(-2) 행이 하나라도 있으면 true */
export const hasRunningPlan = (rows: readonly PlanRow[]): boolean =>
  rows.some(r => {
    const s = cell(r.PLAN_STATUS);
    return s === PLAN_STATUS.RUNNING || s === PLAN_STATUS.STOPPING;
  });

/** R10 — PLAN_TYPE/MODELING_ID 공백이면 RUN/CONFIRM 공통 강제 잠금 */
const hasRequiredKeys = (row: PlanRow): boolean =>
  cell(row.PLAN_TYPE) !== '' && cell(row.MODELING_ID) !== '';

/**
 * RUN 버튼셀 잠금(R8+R9+R10) — RUN_AUTH='Y' 이고 전행 중 실행/종료중 없음 이고
 * 현재 주차 조회이고 필수값 비공백일 때만 unlock.
 */
export const isRunLocked = (row: PlanRow, ctx: PlanLockContext): boolean => {
  if (!ctx.weekCurrent) return true; // R9
  if (!hasRequiredKeys(row)) return true; // R10
  if (cell(row.RUN_AUTH) !== 'Y') return true; // R8 권한
  return ctx.anyRunning; // R8 전행 스캔
};

/**
 * CONFIRM 버튼셀 잠금(R7+R9+R10) — CONFIRM_AUTH='Y' 이고 PLAN_STATUS=1(정상종료)이고
 * 현재 주차 조회이고 필수값 비공백일 때만 unlock.
 */
export const isConfirmLocked = (row: PlanRow, ctx: PlanLockContext): boolean => {
  if (!ctx.weekCurrent) return true; // R9
  if (!hasRequiredKeys(row)) return true; // R10
  if (cell(row.CONFIRM_AUTH) !== 'Y') return true; // R7 권한
  return cell(row.PLAN_STATUS) !== PLAN_STATUS.DONE; // R7 상태(0/-2/-1/기타 전부 잠금)
};

/**
 * btnStop enable — 선택 행 PLAN_STATUS='0'(실행중)일 때만 true (design 01 §2 행4.
 * AS-IS 는 초기값(RUN Locked 기반)과 최종값(PLAN_STATUS 기반) 이중 계산이나 최종 실행이
 * 항상 PLAN_STATUS 기반이라 이 로직만 재현 — design 01 §5-2 참조).
 */
export const isStopEnabled = (planStatus: string | undefined): boolean =>
  cell(planStatus) === PLAN_STATUS.RUNNING;
