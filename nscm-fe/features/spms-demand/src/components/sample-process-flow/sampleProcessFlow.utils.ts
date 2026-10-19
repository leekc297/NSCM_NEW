// SPMS 공통 — 샘플 현황 Process 커서 순수함수 (테스트 대상 — JSX 없는 파일로 분리).
//   커서 계약 = P_SDMxxxx_GET_PJT_SAMPLE_PROCESS (사내 DB 실측 2026-08-31):
//   DPJT_BUILD_PROCESS(코드 — lookup SPMS_DPJT_BUILD_PROCESS) / DPJT_BUILD_PROCESS_NAME /
//   PROCESS_STATUS(DONE·INPROGRESS·STANDBY·DISABLED — 서버 확정값, FE 재파생 금지) / PROGRESS_CNT / TARGET_CNT /
//   ATTRIBUTE1(단계가 열리는 화면 메뉴 ID — 예 SDM2010 / SDM2020. 단계 클릭 이동의 단일 원천).
import type { ProcessTabDataProps } from '@shared/lges';

import { toText } from '../../lib/call-proc';

/** 샘플 현황 Process 커서 1행 */
export interface SampleProcessRow {
  DPJT_BUILD_PROCESS: string;
  DPJT_BUILD_PROCESS_NAME: string;
  PROCESS_STATUS: string;
  PROGRESS_CNT: string | number;
  TARGET_CNT: string | number;
  /** 단계가 열리는 화면 메뉴 ID — lookup SPMS_DPJT_BUILD_PROCESS.ATTRIBUTE1 (미등재 단계는 빈 값) */
  ATTRIBUTE1?: string;
  [key: string]: string | number | undefined;
}

export type StepStatus = ProcessTabDataProps['item']['status'];

// 서버 상태 문자열 → LGES ProcessTab status. 미지정/미지 값은 대기(standBy)
const STATUS_MAP: Record<string, StepStatus> = {
  DONE: 'done',
  INPROGRESS: 'inProgress',
  STANDBY: 'standBy',
  DISABLED: 'disabled',
};

export const toStepStatus = (status: unknown): StepStatus =>
  STATUS_MAP[toText(status).trim().toUpperCase()] ?? 'standBy';

// ⭐ 잠정 — DISABLED 단계도 클릭으로 이동시킨다 (요청 2026-09-04).
//   LGES ProcessTabItem 은 status==='disabled' 이면 onClick 자체를 호출하지 않는다(라이브러리 내부
//   `i && n !== 'disabled' && i()`). 클릭을 살리는 유일한 레버가 status 라서 표시 상태를 대기로 낮춘다.
//   ⚠ 그 결과 "해당 없음(disabled)"과 "대기(standBy)"가 화면에서 구분되지 않는다. 구분이 다시
//   필요해지면 이 매핑만 지우면 원복된다 (toStepStatus 는 서버 계약 그대로 유지).
const toClickableStatus = (status: StepStatus): StepStatus =>
  status === 'disabled' ? 'standBy' : status;

/** 커서 행 → LGES ProcessTab 데이터 (단계명·건수·상태 = 커서 단일 원천) */
export const toProcessTabData = (rows: SampleProcessRow[]): ProcessTabDataProps[] =>
  rows.map((row, index) => ({
    id: index,
    item: {
      status: toClickableStatus(toStepStatus(row.PROCESS_STATUS)),
      tabName: toText(row.DPJT_BUILD_PROCESS_NAME) || toText(row.DPJT_BUILD_PROCESS),
      currentAmount: Number(toText(row.PROGRESS_CNT) || '0'),
      totalAmount: Number(toText(row.TARGET_CNT) || '0'),
      delay: 0,
    },
    contents: null,
  }));

/**
 * 단계 → 그 단계가 열리는 화면 메뉴 ID (lookup SPMS_DPJT_BUILD_PROCESS.ATTRIBUTE1).
 * 값이 없으면 '' — 호출부는 이동하지 않는다 (메뉴가 아직 안 붙은 단계).
 */
export const toProcessMenuId = (row: SampleProcessRow | undefined): string =>
  toText(row?.ATTRIBUTE1).trim();

/** 현재 화면 단계 코드 → 선택 인덱스 (없으면 undefined) */
export const findProcessIndex = (
  rows: SampleProcessRow[],
  currentProcess?: string
): number | undefined => {
  if (!currentProcess) return undefined;
  const index = rows.findIndex(row => toText(row.DPJT_BUILD_PROCESS) === currentProcess);
  return index >= 0 ? index : undefined;
};
