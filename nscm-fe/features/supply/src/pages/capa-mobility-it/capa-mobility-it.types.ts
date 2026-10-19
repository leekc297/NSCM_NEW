import type { MENU_ID, SHEETS } from './capa-mobility-it.constants';

/** 조회조건 입력 상태 (SearchArea 가 읽고 쓰는 "입력 중" 값). design 02 §1/§4. */
export interface CapaMobilityItSearchParams {
  divisionId: string; // 고정 '40'
  plantIds: string[]; // 다중 (PlantByDivisionOperation)
  lineIds: string[]; // 다중 (LineByOperation, '-' 포함)
  startYyyymmdd: string; // Period From
  endYyyymmdd: string; // Period To
  itemId: string; // Model/Nickname (메1 팝업 결과)
}

/** 메인 그리드 행 — pivot(정적 19 + 동적 D_/W_/M_/PR_M_). SSOT = procedures.d.ts SCP0098.main.o_rc. */
export type CapaMobilityItRow = ResponseData<MENU_ID, SHEETS.MAIN, 'o_rc'>;

/** 그리드 셀 조작을 위한 느슨한 행 타입(wijmo dataItem 접근). */
export type CapaRowItem = Record<string, unknown> & { CRUD_TYPE?: string };
