import type { MENU_ID, SHEETS } from './shipment-master-electrode.constants';

// 그리드 행 — procedures.d.ts(SSOT) 기반. GET SP 반환 25컬럼 (design 03 §1/§4).
//   SSP0024 는 generated procedures.d.ts 에 아직 없어(SP 미배포) Base index-signature 로 loose 해석된다
//   (SSP0014 자매와 동일 — 생성 SSOT 파일은 건드리지 않는다, convert-core §2.2 Hard Boundary /
//    memory procedures-dts-base-index-fallback: 미배포 MENU_ID 는 type-check 통과, 오탐 아님).
export type MainRow = ResponseData<MENU_ID, SHEETS.MAIN>;

// 조회조건 (Form 입력 상태 — design 02 §1):
//   Division*(단일,필수) / PlantSite(다중 CheckedList) / Material(다건 ^) / NickName(단일) / Model(다건 ^).
export interface SearchCondition {
  divisionId: string;
  scmSiteIds: string[]; // cboPlantSite 체크값 (다중)
  materialId: string; // txtMaterialId 다건 (개행/콤마) — btnMaterialId 팝업이 채움
  nickName: string; // txtNickName 단일
  modelId: string; // txtModelId 다건 (개행/콤마) — btnModelId 팝업이 채움
}

// Material/Model 팝업(SSP0024_ItembyDivisionPopup, SP P_SSP0024_GET_ITEM_BY_DIVISION_POPUP) 반환 행.
//   원천 SCP_MST_FINAL_ITEM (design 02 §4.6 / 03 §3.2, 07_human-doc §2). 10 프로퍼티 — 셀팝업 시 신규행 일괄 채움.
export interface PopupRow {
  DIVISION_ID?: string;
  PLANT_SITE_CODE?: string;
  PLANT_SITE_ID?: string;
  MATERIAL_ID?: string;
  MODEL_ID?: string;
  CELL_TYPE?: string;
  NICK_NAME?: string;
  ELECTRODE_TYPE?: string;
  ITEM_UOM?: string;
  UOM_CONVERT_IN_TACT_TIME?: string | number;
}
