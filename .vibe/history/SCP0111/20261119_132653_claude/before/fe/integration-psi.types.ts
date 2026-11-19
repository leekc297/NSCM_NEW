import type { MENU_ID, SHEETS } from './integration-psi.constants';

// 그리드 행 — procedures.d.ts(SSOT) 기반. SCP0111 은 procedures.d.ts 미등재라 Base 인덱스시그니처
//   fallback(Record<string, WijmoRowItem> & { CRUD_TYPE?: string })으로 해석된다(자매 SCP0013 동일).
//   PIVOT 값/편집판정에 쓰는 컬럼(MEASURE/SEQ_FLAG/CELL_CF/D_·W_·M_ 등)은 GET SP 반환에 포함(design 03 §4).
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN>;

// 조회조건 (Form 입력 상태 — searchCondition). design 02 §1 인벤토리 + §4.4 10-param 매핑.
export interface SearchCondition {
  divisionId: string; // cboDivision 최상위(cascade). EE division 제외 콤보(design 02 §2 #1)
  planStartYyyymmdd: string; // cboPlanDate 단일선택. Division·SE/FN PlanType PLANDATE 교집합(design 02 §3.1)
  planType: string; // cboPlanType(현재 AS-IS 자동재조회 비활성). 조회 파라미터는 "" 고정(design 02 §4.4)
  fromYyyymm: string; // cmbFromMonth SelectedValue(YYYYMM). PlanDate 시작월(design 02 §3.2)
  toYyyymm: string; // cmbToMonth SelectedValue(YYYYMM). 시작 + (기본기간-1)월 or HORIZON_END_DATE
  qtyYn: boolean; // chkQty — 음수 Qty Item 만 조회(p_qty_yn, design 02 §2.1)
  nickName: string; // txtNickName (btnNickName 팝업이 채움)
  cellItemId: string; // txtCellItemId (btnCellItem_Id 팝업 AS-IS NO-OP — design 02 §6)
  itemId: string; // txtItemId (btnItemId 팝업이 채움)
}

// 저장 실행 분기 (design 03 §4-저장): 일반(SAVE_INTEGRATION_PSI) / ADMIN(SAVE_PSI_ADMIN, +p_boh_qty).
export type SaveMode = 'GENERAL' | 'ADMIN';

// 파생검증 D1/D2 불일치 경고 메시지 재료 (design 03 §3-Deriv, AS-IS cs:2051-2056 / 2120-2125).
//   그리드가 계산해 page 로 올리고, page 가 분기별 문구(라벨·줄 순서)로 조립해 경고창에 표시한다.
export interface DerivMismatchDetail {
  kind: 'D1' | 'D2'; // D1=Pack Prod Plan 수정 / D2=Cell In-house Moving 수정
  itemId: string; // 수정행 모델(ITEM_ID)
  counterpartId: string; // 대응 아이템 — D1: In-house 행 ITEM_ID / D2: To Product(Pack)
  prodQty: number; // Prod plan 합(원시, CELL_CF 곱 전)
  inhouseQty: number; // In-house moving 합
  shouldBe: number; // 기대값 — D1: prodQty×CELL_CF / D2: inhouseQty÷CELL_CF
}
