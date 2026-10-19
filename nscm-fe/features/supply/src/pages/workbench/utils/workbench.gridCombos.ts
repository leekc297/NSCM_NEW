// SCP0125 그리드 셀 콤보 후보 — AS-IS 와 동일한 "mount 1회 전량 로드 + 클라 필터" 경로.
//
// 왜 CMBO_SQL 재사용/신규등록이 아니라 화면 주입인가 (design 03_grid-columns.md §1.6 / 02 §2.8c):
//   · AS-IS `CELL_COMBO_DATA_TYPE` 는 `SetComBoParam` 의 **클라 레지스트리 키**이고 TO-BE 에서는
//     `SCM_ADM_CMBO_SQL_M.SQL_ID` 다 — 축이 다르다. 값을 그대로 두면 `SalesSite`/`PlantSite`/
//     `EndCustomer`/`Location`/`Plant`(전부 DM 도메인, 의미 상이)로 해소되어 후보가 조용히 틀린다
//     (silent drift, convert-core §2.6). `StockType`/`ScmSite`/`Line` 은 아예 미등록(0행 실측).
//   · 그 5종은 FE 소비자가 2곳 이상인 **공유 SQL_ID** 라 본문 수정이 금지된다(hook #117 §3).
//   → 후보 원천을 AS-IS 와 동일하게 `init`(GET_SEARCH_INFO) 결과셋 + lookup 으로 잡고, division
//     좁힘(F04~F08)과 2단 cascade(F22~F27)를 여기서 순수함수로 재현한다. 메타는 `05_register.sql`
//     에서 `CELL_CONTROL_OBJECT_TYPE_CODE='FPComboBox'` 만 채우고 `CELL_COMBO_DATA_TYPE` 는 비운다
//     (비어 있으면 공용 DataGrid 의 자동 콤보 경로가 이 dataMap 을 덮지 않는다 — DataGrid
//      applyComboDataMaps 가 `!cellCboDataTp` 컬럼을 건너뛴다).
//   · 메타 자동 콤보로 남기는 것은 `YesOrNo`('Y'/'N') **1종**뿐이다 — CODE=NAME 이라 셀 커밋값과
//     표시값이 같아 어긋날 여지가 없다. `FcstType`(SALES_TYPE_CODE)은 의미는 1:1 이지만 CODE≠NAME
//     이라 자동 콤보가 셀에 코드를 커밋해 파생이 깨지므로(아래 `asDisplayKeyRows` 주석) 화면 주입으로
//     옮겼고, `05_register.sql` 이 그 컬럼의 `CELL_COMBO_DATA_TYPE` 를 비운다.
//
// AS-IS 근거: cs:292~300(RefreshSiteByDivision) · cs:206~219(dtPlantIDAll 합성 B17) ·
//             cs:362~366(Incoterms 선두 '-' 삽입 B18/X1) · cs:2318~2362(셀 cascade D3/D4)

import type { ComboResponse } from '@foundation/models';

import { COL } from '../workbench.constants';
import type { WorkbenchInitData } from '../workbench.types';

const str = (value: unknown): string =>
  typeof value === 'string' ? value : typeof value === 'number' ? String(value) : '';

/** F04~F08 공통 — 후보를 조회조건 division 으로 좁힌다(AS-IS `DBUtils.Filter(dt, "DIVISION_ID = ...")`). */
const byDivision = (rows: ComboResponse[], divisionId: string): ComboResponse[] =>
  rows.filter(row => str(row[COL.DIVISION_ID]) === divisionId);

/** CODE 중복 제거 — 같은 코드가 부가 컬럼별로 여러 행 내려오면 드롭다운에 중복 표시된다. */
const dedupeByCode = (rows: ComboResponse[]): ComboResponse[] => [
  ...new Map(rows.map(row => [str(row.CODE), row])).values(),
];

/**
 * Incoterms 선두 `'-'` 행(B18/X1) — AS-IS 는 `InsertAt(0)` 한 DataTable 을 MKT FCST·STOCK·
 * Stock(Elec. Plant) 3시트가 **공유 참조**로 쓰므로 3시트 모두 `'-'` 가 보인다(실동작 기준).
 */
const withLeadingDash = (rows: ComboResponse[]): ComboResponse[] =>
  rows.some(row => str(row.CODE) === '-') ? rows : [{ CODE: '-', NAME: '-' }, ...rows];

/** lookup 응답(SEGMENT1/2) → 콤보 후보(CODE/NAME). `useTabLookupQueries` 는 이미 CODE/NAME 별칭이다. */
export const toComboRows = (rows: Record<string, string>[] | undefined): ComboResponse[] =>
  (rows ?? []).map(row => ({
    ...row,
    CODE: str(row.CODE ?? row.SEGMENT1),
    NAME: str(row.NAME ?? row.SEGMENT2),
  }));

/**
 * `*_NAME` 컬럼(표시명이 곧 셀 값인 컬럼)용 후보 재구성 — **CODE = NAME = 표시명**.
 *
 * 왜 필요한가: 공용 DataGrid 의 dataMap 은 `new DataMap(rows,'CODE','NAME')`(columnMapping:508)라
 *   화면에는 NAME 을 보여주고 셀에는 **CODE 를 커밋**한다. 그런데 이 화면의 `FCST_TYPE_NAME`·
 *   `STOCK_TYPE_NAME` 은 조회 SP 가 `SEGMENT2 AS *_TYPE_NAME`(즉 **표시명**)을 내려주는 컬럼이고
 *   (`PKG_SCP0125` BODY:359·1653·1944·2418·2635·2908), AS-IS 도 셀 텍스트를 NAME 으로 두고
 *   NAME→CODE 로 역변환해 숨김 코드 컬럼을 채운다(cs:2247·2264·2306·2315·2369).
 *   후보를 그대로(CODE=SEGMENT1) 넘기면 두 가지가 동시에 깨진다:
 *     (1) 콤보로 고른 셀에 코드가 커밋되어 `workbench.derive.codeByName`(NAME 매칭)이 미스 →
 *         숨김 `FCST_TYPE`/`STOCK_TYPE` 가 공백 저장 + 중복검사 F13·F17·F20 무력화
 *     (2) 조회로 내려온 기존행 값은 표시명인데 dataMap 색인은 CODE 축이라 라벨이 깨진다
 *   → `buildPlantIdRows`(아래, AS-IS `dtPlantIDAll` 합성)와 같은 형태로 CODE=NAME 으로 재구성한다.
 *
 * 전제: 표시명이 후보 안에서 유일해야 역변환이 1:1 이다 — 실측 `STOCK_TYPE` 5행 / `SALES_TYPE_CODE`
 *   14행 전건 `SEGMENT2` 중복 0건(ora.py 2026-09-26, design §1.7 과 일치).
 * 주의: 역변환용 원본 후보(CODE=SEGMENT1)는 `DeriveSources` 가 그대로 들고 있어야 한다 —
 *   여기서 바꾼 행을 파생에 넘기면 코드를 되찾을 수 없다.
 */
const asDisplayKeyRows = (rows: ComboResponse[]): ComboResponse[] =>
  rows.map(row => ({ ...row, CODE: str(row.NAME), NAME: str(row.NAME) }));

/**
 * Plant ID 후보(2nd OCV `PLANT_ID`) — AS-IS `dtPlantIDAll` 클라 합성(B17/X3).
 * `dtPlantSiteAll.PLANT_ID` 를 **CODE = NAME = PLANT_ID** 로 재구성한다. TO-BE 공유 CMBO `Plant` 는
 * `NAME=PLANT_NAME` 이라 표시 문자열이 달라진다 → 재사용 금지(§1.6 F-4).
 */
const buildPlantIdRows = (
  plantSiteAll: ComboResponse[],
  divisionId: string
): ComboResponse[] =>
  dedupeByCode(
    byDivision(plantSiteAll, divisionId)
      .filter(row => str(row[COL.PLANT_ID]) !== '')
      .map(row => ({
        CODE: str(row[COL.PLANT_ID]),
        NAME: str(row[COL.PLANT_ID]),
        [COL.DIVISION_ID]: str(row[COL.DIVISION_ID]),
      }))
  );

/**
 * STOCK `LINE_ID` 후보 — AS-IS 2단 cascade D3(F22·F23): 행의 `SCM_SITE_ID` → `dtPlantSite.PLANT_ID`
 * → `dtLineAll ⋂ (DIVISION_ID, PLANT_ID)`.
 *
 * AS-IS 는 `dtLine` 이 **화면 전역 1개 가변 상태**라 상위 셀을 안 고르고 Line 부터 붙여넣으면 이전
 * 행 기준 후보가 남는 결함이 있다(§6 U7). TO-BE 는 후보에 `SCM_SITE_ID` 를 미리 붙여 두고 컬럼 메타
 * `ATTRIBUTE2='SCM_SITE_ID:SCM_SITE_ID'` 로 **행 단위** 좁힘을 맡긴다 — 전역 가변 상태가 사라진다.
 */
const buildStockLineRows = (
  lineAll: ComboResponse[],
  plantSiteAll: ComboResponse[],
  divisionId: string
): ComboResponse[] => {
  // PLANT_ID -> 그 plant 를 가진 SCM_SITE_ID 목록(같은 division 안에서)
  const siteIdsByPlant = new Map<string, string[]>();
  for (const site of byDivision(plantSiteAll, divisionId)) {
    const plantId = str(site[COL.PLANT_ID]);
    if (!plantId) continue;
    const bucket = siteIdsByPlant.get(plantId) ?? [];
    bucket.push(str(site.CODE));
    siteIdsByPlant.set(plantId, bucket);
  }

  const rows: ComboResponse[] = [];
  for (const line of byDivision(lineAll, divisionId)) {
    const siteIds = siteIdsByPlant.get(str(line[COL.PLANT_ID])) ?? [];
    for (const siteId of siteIds) rows.push({ ...line, [COL.SCM_SITE_ID]: siteId });
  }
  return rows;
};

/**
 * Elec. Demand `LINE_ID` 후보 — AS-IS 2단 cascade D4(F24·F25): 행의 `PLANT_SITE_ID` → `PLANT_ID`
 * → `dtLineAll ⋂ (DIVISION_ID, PLANT_ID)`. 좁힘은 메타 `ATTRIBUTE2='PLANT_SITE_ID:PLANT_SITE_ID'`.
 */
const buildElecDemandLineRows = (
  lineAll: ComboResponse[],
  plantSiteAll: ComboResponse[],
  divisionId: string
): ComboResponse[] => {
  const siteIdsByPlant = new Map<string, string[]>();
  for (const site of byDivision(plantSiteAll, divisionId)) {
    const plantId = str(site[COL.PLANT_ID]);
    if (!plantId) continue;
    const bucket = siteIdsByPlant.get(plantId) ?? [];
    bucket.push(str(site.CODE));
    siteIdsByPlant.set(plantId, bucket);
  }

  const rows: ComboResponse[] = [];
  for (const line of byDivision(lineAll, divisionId)) {
    const siteIds = siteIdsByPlant.get(str(line[COL.PLANT_ID])) ?? [];
    for (const siteId of siteIds) rows.push({ ...line, [COL.PLANT_SITE_ID]: siteId });
  }
  return rows;
};

/** 컬럼별 셀 콤보 후보 — `binding` -> 후보 행. 여기에 없는 컬럼은 admin 메타 자동 콤보 또는 텍스트다. */
export type CellComboRows = Readonly<Record<string, ComboResponse[]>>;

/**
 * 시트별 셀 콤보 후보 전건(F04~F08 + 2단 cascade 원천 결합).
 * division 이 비면 전부 빈 목록 — AS-IS 도 division 이 없으면 후보가 0건이다.
 */
export const buildCellComboRows = (
  init: WorkbenchInitData,
  divisionId: string,
  lookups: { fcstType: ComboResponse[]; stockType: ComboResponse[]; incoterms: ComboResponse[] }
): {
  mktFcst: CellComboRows;
  stock: CellComboRows;
  stockElec: CellComboRows;
  elecDemand: CellComboRows;
  stock2ndOcv: CellComboRows;
} => {
  const salesSite = dedupeByCode(byDivision(init.salesSiteAll, divisionId)); // F04
  const plantSite = dedupeByCode(byDivision(init.plantSiteAll, divisionId)); // F05
  const scmSite = dedupeByCode(byDivision(init.scmSiteAll, divisionId)); // F06
  const incoterms = withLeadingDash(lookups.incoterms); // B18/X1
  // `*_TYPE_NAME` 2종은 표시명이 곧 셀 값이다 — CODE=NAME 으로 재구성한다(asDisplayKeyRows 주석).
  const stockType = asDisplayKeyRows(lookups.stockType);
  const fcstType = asDisplayKeyRows(lookups.fcstType);

  return {
    mktFcst: {
      [COL.SCM_SITE_ID]: salesSite,
      [COL.FCST_TYPE_NAME]: fcstType,
      [COL.INCOTERMS]: incoterms,
      [COL.PLANT_SITE_ID]: plantSite,
      [COL.CELL_PROD_SITE_ID]: plantSite,
      [COL.PROJECT_CODE_40]: init.projectCode40All,
    },
    stock: {
      [COL.STOCK_TYPE_NAME]: stockType,
      [COL.INCOTERMS]: incoterms,
      [COL.SCM_SITE_ID]: scmSite,
      [COL.LINE_ID]: buildStockLineRows(init.lineAll, init.plantSiteAll, divisionId), // F22·F23
    },
    stockElec: {
      [COL.STOCK_TYPE_NAME]: stockType,
      [COL.INCOTERMS]: incoterms,
      [COL.SCM_SITE_ID]: scmSite,
      [COL.LOCATION_CODE]: init.locationAll,
    },
    elecDemand: {
      [COL.PLANT_SITE_ID]: plantSite,
      [COL.LINE_ID]: buildElecDemandLineRows(init.lineAll, init.plantSiteAll, divisionId), // F24·F25
    },
    stock2ndOcv: {
      [COL.STOCK_TYPE_NAME]: stockType,
      [COL.PLANT_ID]: buildPlantIdRows(init.plantSiteAll, divisionId), // F08 + B17
    },
  };
};
