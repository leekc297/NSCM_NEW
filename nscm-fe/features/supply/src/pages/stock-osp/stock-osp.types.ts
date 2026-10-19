import type { MENU_ID, SHEETS } from './stock-osp.constants';

// 그리드 행 — procedures.d.ts(SSOT)에 SCP0041 미생성 상태라 Base index fallback(WijmoRowItem)으로 해석된다
//   (자매 SCP0053 scp-bom 동일 방식, memory procedures-dts-base-index-fallback — SSOT 편집 금지).
//   Osp o_rc 14필드 / Pack o_rc 15필드(design 03 §1)는 Record 접근 헬퍼(s())로 읽는다.
export type OspStockRow = ResponseData<MENU_ID, SHEETS.OSP>;
export type PackHoldStockRow = ResponseData<MENU_ID, SHEETS.PACK>;

// 조회조건 (Form 입력 상태 — searchParams). design 02 §1 인벤토리 7건:
//   Division(단일, 권한 첫 항목 기본) / PlantSite(탭별 콤보 상이 — Osp 다중, Pack 다중) /
//   Model(Item popup 텍스트) / Period(from~to) / Inspection·Status·Cutoff(Pack 탭 전용).
export interface SearchCondition {
  divisionId: string;
  plantSiteIds: string[]; // Osp: OSP1∪SaleSite1 / Pack: PackerHoldStock1 — 전체선택 시 빈 배열(NULL 전달)
  itemId: string; // ItemByDivisionModal 팝업 선택값(Model)
  fromYyyymmdd: string;
  toYyyymmdd: string;
  inspectionId: string; // Pack 전용
  status: string; // Pack 전용 — PACKER_HOLD_STATUS lookup value(HOLD/RELEASE), 기본 '' = 전체
  cutoffFromYyyymmdd: string; // Pack 전용
  cutoffToYyyymmdd: string; // Pack 전용
}
