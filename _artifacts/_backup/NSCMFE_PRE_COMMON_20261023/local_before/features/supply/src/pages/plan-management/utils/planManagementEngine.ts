// SCP0015 Engine Run 진행 색상(STEP_PROCESS1~4) 상태 계산 (AS-IS SetColorStatus L1601-1650 —
//   design 03 §3 R20~R22). 폴링(2초)마다 행별 "칠해진 칸 수"를 갱신하는 순수 로직.
//   서버 값이 아니라 클라 로컬 카운터다 — STEP_PROCESS 셀 값은 SP 가 항상 '' 를 반환한다.
import { PLAN_STATUS } from '../plan-management.constants';
import type { EngineRow } from '../plan-management.types';

export const STEP_PROCESS_BINDINGS = [
  'STEP_PROCESS1',
  'STEP_PROCESS2',
  'STEP_PROCESS3',
  'STEP_PROCESS4',
] as const;

const cell = (v: unknown): string =>
  (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '').trim();

/** 행 식별 키 — Engine 그리드는 4단계 고정 행이라 STEP_NAME(10/20/30/40 단계명)으로 식별 */
export const engineRowKey = (row: EngineRow): string =>
  `${cell(row.MODELING_ID)}|${cell(row.PLAN_SEQ)}|${cell(row.STEP_NAME)}`;

/**
 * 폴링 1회분 진행 칸 수 갱신.
 * - STEP_STATUS='1'(완료): 4칸 일괄(R20)
 * - STEP_STATUS='0'(진행중): 이전 값에서 1칸씩 순차 증가, 4칸을 넘으면 리셋 후 1부터(R21/R22 —
 *   애니메이션형 진행바. 이전 사이클 잔재 4칸이면 전체 리셋)
 * - 그 외(-1 등): 0칸
 */
export const nextProgress = (prev: number, stepStatus: string): number => {
  const status = cell(stepStatus);
  if (status === PLAN_STATUS.DONE) return STEP_PROCESS_BINDINGS.length;
  if (status !== PLAN_STATUS.RUNNING) return 0;
  if (prev >= STEP_PROCESS_BINDINGS.length) return 1; // R21 리셋 후 첫 칸
  return prev + 1; // R22 순차 채움
};

/** 폴링 응답 전행에 nextProgress 적용 — 새 Map 반환(이전 Map 은 불변) */
export const advanceProgress = (
  prev: ReadonlyMap<string, number>,
  rows: readonly EngineRow[]
): Map<string, number> => {
  const next = new Map<string, number>();
  for (const row of rows) {
    const key = engineRowKey(row);
    next.set(key, nextProgress(prev.get(key) ?? 0, cell(row.STEP_STATUS)));
  }
  return next;
};

/** 폴링 지속 여부 — 실행중(0)/종료중(-2)일 때만 계속, 정상(1)/에러(-1) 종료 시 중지(design 03 §4.4) */
export const shouldKeepPolling = (planStatus: string | undefined): boolean => {
  const status = cell(planStatus);
  return status === PLAN_STATUS.RUNNING || status === PLAN_STATUS.STOPPING;
};
