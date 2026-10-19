import type { LINE_MODE, MENU_ID, SHEETS } from './line-master.constants';

// 그리드 행 — procedures.d.ts(SSOT) 기반. SCP0002 는 generated 파일에 아직 없어(PKG 미배포·codegen 전)
//   Base index-signature 로 loose(WijmoRowItem) 해석된다 — 자매 SCP0114 와 동일(생성 SSOT 는 건드리지 않는다,
//   convert-core §2.2 Hard Boundary / memory procedures-dts-base-index-fallback: 미배포 MENU_ID 는 type-check 통과, 결함 아님).
export type PlantRow = ResponseData<MENU_ID, SHEETS.PLANT>;
export type PackerRow = ResponseData<MENU_ID, SHEETS.PACKER>;

// spdMain 은 Plant/Packer 두 시트를 한 그리드에서 전환 — 행 형상은 union 이나 편집/파생은 Packer 만.
export type MainRow = PlantRow  ;

// 조회조건 (Form 입력 상태 — design 02 §1 인벤토리 controls 6개):
//   division(단일 root) / plantSite(다중) / building(다중, Plant 전용) / operation(다중, Plant 전용) /
//   line(다중 leaf) / valid(독립). mode = spdMain 활성 시트(Plant/Packer — 공급 콤보·조회 SP 분기).
export interface SearchCondition {
  divisionId: string;
  plantSiteIds: string[];
  buildingIds: string[];
  operationIds: string[];
  lineIds: string[];
  valid: string;
  mode: LINE_MODE;
}
