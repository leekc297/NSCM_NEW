import type { MENU_ID, ProductGroup, SHEETS } from './capa-line-master.constants';

// 그리드 행 — procedures.d.ts(SSOT) 기반. 5시트 모두 같은 계층 컬럼 집합의 부분집합이라 하나로 다룬다.
//   SCP0114 는 generated procedures.d.ts 에 아직 없어(PKG 미배포) Base index-signature 로 loose 해석된다
//   (자매 SCP0033/SSP0024/SSP0025 와 동일 — 생성 SSOT 파일은 건드리지 않는다, convert-core §2.2 Hard Boundary /
//    memory procedures-dts-base-index-fallback: 미배포 MENU_ID 는 type-check 통과, 결함 아님).
export type CapaLineRow = ResponseData<MENU_ID, SHEETS.LEVEL1>;

// 조회조건 (Form 입력 상태 — design 02 §1): Division 단일 콤보 + Product Group 단일선택.
//   cascade 없음(독립 2축, design 02 §3). 필수 = Division(design 02 §6 #1).
export interface SearchCondition {
  divisionId: string; // cboDivision (Division_SCP, ATTRIBUTE3='EE' 제외 후 단일선택)
  shopGroupId: ProductGroup; // rgrpSearchLevel -> _shopgroupId (E/A/P), 기본 'E'
}

// 드릴다운 컨텍스트 — AS-IS `_siteId/_siteName/_companyId/...` 필드 캐시 (cs:1757~1831).
//   하위 레벨 조회 파라미터 + 신규행 부모키 상속의 단일 원천(design 03 §3.3 / §4.2).
export interface DrillContext {
  SITE_ID?: string;
  SITE_NAME?: string;
  COMPANY_ID?: string;
  COMPANY_NAME?: string;
  PLANT_ID?: string;
  PLANT_NAME?: string;
  FACTORY_ID?: string;
  FACTORY_NAME?: string;
}
