/**
 * DMF0015 BOD (Bill of Delivery — 배송경로 마스터) 상수
 * AS-IS: GSCM/06.UIL/GSCM.DM.Master.UIL/DM0015_BOD.cs
 * Phase 6 PoC — 룰셋 v2 검증
 */
export const MENU_ID = 'DMF0015' as const;
export type MENU_ID = typeof MENU_ID;

/**
 * Sheet 이름 (FE 가 BE 요청 시 사용)
 * AS-IS SpdSheet 매핑: shtMain="Bod" → 'main' (메모리 룰 — 단일 master sheet 표준)
 *                     shtSub ="Bod Item" → 'bodItem'
 */
export enum SHEETS {
  MAIN = 'main',
  BOD_ITEM = 'bodItem',
}

/**
 * BE response key (의미있는 이름)
 */
export enum RESPONSE_SET {
  MAIN = 'bod',
  BOD_ITEM = 'bodItem',
}

/**
 * Sheet 인덱스 (gridRefs[] array 매핑)
 */
export enum SHEET_INDEX {
  MAIN,
  BOD_ITEM,
}
