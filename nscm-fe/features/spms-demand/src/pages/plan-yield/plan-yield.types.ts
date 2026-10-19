// SDM2020 — 화면 전용 타입. 커서 컬럼 구조는 procedures.d.ts SDM2020 블록이 단일 원천 (로컬 재정의 금지).
import type { MENU_ID, RESPONSE_SET, SHEETS } from './plan-yield.constants';

export type TreeRow = ResponseData<MENU_ID, SHEETS.TREE, RESPONSE_SET.DATA>;
export type ProcessRow = ResponseData<MENU_ID, SHEETS.PROCESS, RESPONSE_SET.DATA>;
export type BuildRow = ResponseData<MENU_ID, SHEETS.BUILD, RESPONSE_SET.DATA>;
export type PlantRow = ResponseData<MENU_ID, SHEETS.BUILD, RESPONSE_SET.PLANT>;
export type YieldRow = ResponseData<MENU_ID, SHEETS.YIELD, RESPONSE_SET.DATA>;

/**
 * 샘플 요청 법인 패널에서 선택된 **공정 그룹**(구분 컬럼) — 수율/Loss 그리드 조회 필터의 원천.
 * 조회 단위가 공정 1건이 아니라 구분 1블록이다 (요청 2026-09-04) — 우측 그리드는 그 구분에 속한
 * 전 공정의 행을 함께 보여준다. 법인·공정은 그룹 안에서 행마다 다르므로 여기에 담지 않는다.
 */
export interface SelectedOperationGroup {
  operationGroup: string; // 공정 그룹 코드 (E/A/P)
  mgmtType: string; // 양음극 (C/A/-) — 양극·음극은 OPERATION_GROUP 이 같아 필수 키
  operationGroupName: string; // 구분 표시명 (양극/음극/조립/모듈·팩)
}

/** 요청법인 확인 진행률 (구분 단위 — 도넛 표시) */
export interface PlantProgress {
  confirmed: number;
  total: number;
  percent: number;
}
