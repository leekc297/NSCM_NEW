// SCP0125 파생(Auto-Sync) D1~D4 — **행 단위 순수함수**.
//   콤보 선택(`cellEditEnded` ← AS-IS ComboSelChange G45~G48)과 붙여넣기(`pastedCell` ←
//   AS-IS ClipboardPasted G42~G44) **양쪽에서 같은 함수**를 부른다. 콤보 경로만 구현하면
//   Paste 경로가 조용히 죽는다(03 §5.4 P-2/P-6 이 그 축을 검사한다).
//
// AS-IS 근거 (SCP0125_Workbench.cs)
//   D1 `FCST_TYPE_NAME` → `FCST_TYPE`     : cs:2247(paste G42) · cs:2306(combo G45)
//   D2 `STOCK_TYPE_NAME` → `STOCK_TYPE`   : cs:2264(G43) · cs:2315(G46) · cs:2369(G48, 2nd OCV)
//   D3 `SCM_SITE_ID` → Line 후보 재계산   : cs:2318~2333 — 셀 값 출력이 없다(후보만 바뀜).
//                                           TO-BE 는 컬럼 메타 ATTRIBUTE2 행 단위 좁힘이 대신한다.
//   D4 `LINE_ID` → `OPERATION_ID`        : cs:2352~2362(G47 콤보) · cs:2272~2293(G44 Paste) ·
//                                           `GetOperationByLine` cs:2377~2398 (F24·F26·F27)
//      **`PLANT_SITE_ID` 트리거는 AS-IS 에 없다**(2026-09-26 정정 — cs:2335~2350 의 PlantSite 분기는
//      `dtLine` 후보만 갱신하고 `OPERATION_ID` 에 `SetValue` 하지 않는다. Paste 경로도 `LINE_ID` 만).
//      TO-BE 가 이 트리거를 더한 것은 설계 `03_grid-columns.md §3.3 D4`(:409)가 "`LINE_ID` 변경 /
//      `PLANT_SITE_ID` 변경(Elec. Demand)" 둘 다로 규정했고, :411 이 AS-IS 의 전역 `dtLine` 순서의존
//      결함(Plant Site 를 먼저 안 고르면 `OPERATION_ID` 공백)을 **행 단위 계산으로 없애라**고 지시한
//      데 따른 **의도적 상이**다(§5.4 P-5). 부수효과: Plant Site 를 바꾸면 이전 Line 이 새 plant 에
//      없을 때 `OPERATION_ID` 가 비워지고 저장 필수검증에 걸린다 — AS-IS 는 불일치 쌍을 그대로
//      저장했으므로 이쪽이 데이터 정합성에 유리하다고 보아 유지한다.
//
// 역변환 방향 주의: AS-IS 는 **표시명(NAME) → 코드(CODE)** 로 되돌린다(`NAME == 셀텍스트` 인 첫 행).
//   즉 표시값이 곧 키다. lookup NAME 중복이 있으면 오매핑되는데 실측상 중복 0건(03 §1.7).

import type { ComboResponse } from '@foundation/models';

import { COL, TABS } from '../workbench.constants';

const str = (value: unknown): string =>
  typeof value === 'string' ? value : typeof value === 'number' ? String(value) : '';

/** 표시명 → 코드 역변환(D1·D2 공통). 후보에 없으면 빈 문자열 — AS-IS `First()` 실패와 동일 취급. */
const codeByName = (rows: ComboResponse[], name: string): string => {
  if (!name) return '';
  const matched = rows.find(row => str(row.NAME) === name);
  return matched ? str(matched.CODE) : '';
};

/**
 * D4 — `GetOperationByLine(division, plantSiteId, lineId)` 재현.
 * (1) `PLANT_SITE_ID` → `dtPlantSite.PLANT_ID`(F24·F26) (2) `dtLine ⋂ (division, plantId, lineId)`
 * → `OPERATION_ID`(F27). 어느 단계든 못 찾으면 빈 문자열이고, 그때 저장 시 필수검증에 걸린다.
 */
const operationByLine = (
  lineAll: ComboResponse[],
  plantSiteAll: ComboResponse[],
  divisionId: string,
  plantSiteId: string,
  lineId: string
): string => {
  if (!divisionId || !plantSiteId || !lineId) return '';
  const site = plantSiteAll.find(
    row => str(row[COL.DIVISION_ID]) === divisionId && str(row.CODE) === plantSiteId
  );
  const plantId = site ? str(site[COL.PLANT_ID]) : '';
  if (!plantId) return '';

  const line = lineAll.find(
    row =>
      str(row[COL.DIVISION_ID]) === divisionId &&
      str(row[COL.PLANT_ID]) === plantId &&
      str(row.CODE) === lineId
  );
  return line ? str(line[COL.OPERATION_ID]) : '';
};

export interface DeriveSources {
  fcstTypeRows: ComboResponse[];
  stockTypeRows: ComboResponse[];
  lineAll: ComboResponse[];
  plantSiteAll: ComboResponse[];
}

/**
 * 한 셀 변경에 따른 파생 결과 — `{ 컬럼: 값 }`. 변경 없으면 빈 객체.
 * 호출부(그리드 핸들러)가 이 결과를 EditTracker 에 기록하고 행에 반영한다.
 */
export const deriveOnCellChange = (
  tab: TABS,
  binding: string,
  row: Record<string, unknown>,
  sources: DeriveSources
): Record<string, string> => {
  // 빈값 가드 — AS-IS 붙여넣기 3분기 전건이 `Cells[iRow,iCol].Text != ""` 를 먼저 본다
  //   (cs:2243 D1 · cs:2261 D2 · cs:2278 D4). 없으면 공백을 붙여넣었을 때 숨김 코드 컬럼이
  //   `''` 로 덮여 "이름은 비었는데 코드도 사라지는" 재현 차이가 난다.
  //   콤보 경로(ComboSelChange cs:2300~)에는 AS-IS 가드가 없으나 거기서 빈값이 오면 AS-IS 는
  //   `FirstOrDefault()["CODE"]` 에서 NullReference 로 죽는다 — 그 결함은 재현하지 않는다.
  if (!str(row[binding])) return {};

  // D1 — MKT FCST 전용
  if (tab === TABS.MKT_FCST && binding === COL.FCST_TYPE_NAME)
    return { [COL.FCST_TYPE]: codeByName(sources.fcstTypeRows, str(row[COL.FCST_TYPE_NAME])) };

  // D2 — STOCK · Stock(Elec. Plant) · Stock(2nd OCV) 공통
  if (
    (tab === TABS.STOCK || tab === TABS.STOCK_ELEC || tab === TABS.STOCK_2ND_OCV) &&
    binding === COL.STOCK_TYPE_NAME
  )
    return { [COL.STOCK_TYPE]: codeByName(sources.stockTypeRows, str(row[COL.STOCK_TYPE_NAME])) };

  // D4 — Elec. Demand: Line 또는 Plant Site 가 바뀌면 Operation 을 다시 계산한다.
  if (
    tab === TABS.ELEC_DEMAND &&
    (binding === COL.LINE_ID || binding === COL.PLANT_SITE_ID)
  )
    return {
      [COL.OPERATION_ID]: operationByLine(
        sources.lineAll,
        sources.plantSiteAll,
        str(row[COL.DIVISION_ID]),
        str(row[COL.PLANT_SITE_ID]),
        str(row[COL.LINE_ID])
      ),
    };

  // D3 은 셀 출력이 없다 — STOCK `SCM_SITE_ID` 변경 시 Line 후보만 좁혀지고(메타 ATTRIBUTE2),
  //   AS-IS 도 이미 입력된 Line 값을 지우지 않는다. 재현 유지.
  return {};
};
