import type { MENU_ID, SHEETS } from './shipment-semi-dept-day.constants';

// 그리드 행 — procedures.d.ts(SSOT) 기반. GET SP Table[0] 반환 11컬럼 (design 03 §1/§4.1).
//   SCP0033 은 generated procedures.d.ts 에 아직 없어(SP 미배포) Base index-signature 로 loose 해석된다
//   (자매 SSP0024/SSP0025 와 동일 — 생성 SSOT 파일은 건드리지 않는다, convert-core §2.2 Hard Boundary /
//    memory procedures-dts-base-index-fallback: 미배포 MENU_ID 는 type-check 통과, 오탐 아님).
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN>;

// 조회조건 (Form 입력 상태 — design 02 §1):
//   Division(다중 체크리스트, Division_SCP) / Model(단일 텍스트 prefix) / Valid(단일 드롭다운 YesOrNo).
//   cascade 없음(SelectedIndexChanged 주석, design 02 §3). 필수 조회조건 없음(전건 허용, design 02 §4).
export interface SearchCondition {
  divisionIds: string[]; // clbDivision 체크값 (다중, Division_SCP). 조회 payload = 콤마 join
  itemId: string; // txtItemId 단일 텍스트 (prefix 검색, 라벨 'Model')
  valid: string; // cboValidYN 단일 (Y/N/'' 전체)
}

// GET SP Table[1](중복체크 원장 dsValiChkBinding, design 03 §3.6/§4.1) — DIVISION_ID+ITEM_ID 전건.
export interface DupLedgerRow {
  DIVISION_ID?: string;
  ITEM_ID?: string;
}

// SCM0002 Item by Division 팝업 반환 행 (design 03 §3.2 cs:487~488 — ItemID/NickName).
//   신규행 확정 시 ITEM_ID + NICK_NAME 동반 세팅.
export interface PopupRow {
  ITEM_ID?: string;
  NICK_NAME?: string;
  MODEL_ID?: string;
  DIVISION_ID?: string;
}
