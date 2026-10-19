import type { MENU_ID, SHEETS } from './shipment-requestor-pic.constants';

// 그리드 행 — procedures.d.ts(SSOT) 기반. GET SP 반환 19컬럼 (design 03 §1/§4).
//   SSP0025 는 generated procedures.d.ts 에 아직 없어(SP 미배포) Base index-signature 로 loose 해석된다
//   (자매 SSP0014/SSP0024 와 동일 — 생성 SSOT 파일은 건드리지 않는다, convert-core §2.2 Hard Boundary /
//    memory procedures-dts-base-index-fallback: 미배포 MENU_ID 는 type-check 통과, 오탐 아님).
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN>;

// 조회조건 (Form 입력 상태 — design 02 §1):
//   Division*(단일,필수) / PlantSite(다중 CheckedList) / Material(다건 콤마) / NickName(단일) / Model(다건 콤마).
export interface SearchCondition {
  divisionId: string;
  plantSiteIds: string[]; // clbFromSite 체크값 (다중, CMBO PlantCell)
  itemId: string; // txtItemId 다건 (개행/콤마) — btnItemId 팝업이 채움
  nickName: string; // txtNickName 단일
  modelId: string; // txtModelId 다건 (개행/콤마) — btnModelId 팝업이 채움
}

// Material/Model 팝업(SSP0025_ItembyDivisionPopup, SP P_SSP0025_GET_ITEM_BY_DIVISION_POPUP) 반환 행.
//   resultProps: ItemId/DivisionId/ElectrodeType/ModelId/NickName/CellType (roslyn SSP0025_ItembyDivisionPopup.json).
//   조회조건 버튼 = ItemId/ModelId 만 추출 / 그리드 셀(R12) = 6칸 일괄 채움(design 03 §3 R12).
export interface PopupRow {
  DIVISION_ID?: string;
  ITEM_ID?: string;
  ELECTRODE_TYPE?: string;
  MODEL_ID?: string;
  NICK_NAME?: string;
  CELL_TYPE?: string;
}
