// ⭐ DMF0049 — Grid 셀 콤보 dataMap 헬퍼 (hook #59 §5-G — sales-reports.gridCombos 동형 축약).
//   AS-IS cascade: spdMain_Changed CellsUpdated (L1260~1300) — DEPARTMENT_ID → DEPT_ID 콤보 재바인딩.
import { DataMap } from '@mescius/wijmo.grid';

import type { EtcSalesReportRow } from '../etc-sales-reports.types';

import { isDiv40 } from './etc-sales-reports.division';

export const toCellStr = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 콤보 rows → DataMap (0건 = null — 메타 주도, 하드코딩 fallback 금지)
export const buildDataMap = (rows: Record<string, unknown>[]): DataMap | null =>
  rows.length > 0 ? new DataMap(rows, 'CODE', 'NAME') : null;

// ============================================================================
// ⚠ 구 `GRID_CASCADE_FILTERS` + `filterComboRowsByRow`(DMF0044 이식분)은 제거했다 —
//   DMF0049 의 DEPT_ID 는 메타상 `DMF0044_DEPARTMENT_TEAM2`(lookup, CODE/NAME 2컬럼)에 묶여 있어
//   부모키 `DEPARTMENT_ID` 컬럼 자체가 없다. 그러면 관대 규약(콤보값 공란=통과)에 걸려
//   **필터가 통째로 무효**가 된다(2026-08-10 실측). AS-IS 의 부모키 필터는 아래로 이관한다.
// ============================================================================
// ⭐ DEPT_ID 행별 콤보 (2026-08-10 이관 — AS-IS `.cs` 런타임 `SetCellTypeCombo` 분)
//   AS-IS L1260~1300 CellsUpdated(DEPARTMENT_ID):
//     · division 40 && DEPARTMENT 표시명 ≠ '기타' → `DMF0044_DEPARTMENT_TEAM`(param1=부모 DEPARTMENT_ID)
//     · 그 외(40 && '기타' / 비40)             → `DMF0044_DEPARTMENT_TEAM2`(division 단위 lookup)
//   ⚠ DMF0044 는 '기타' 분기가 `DMF0044_ETC_SALE_RESULT_TYPE_40` 이지만 **DMF0049 는 다르다**
//     — AS-IS L1293 이 그 줄을 주석 처리하고 L1294 로 TEAM2 를 쓴다. 형제 화면이라도 원문 그대로 따른다.
// ============================================================================

/** DEPARTMENT 표시명의 '기타' 센티널 (AS-IS L1267 `ssDEPARTMENT_NAME != "기타"`) — 내부 전용 */
const ETC_DEPARTMENT = '기타';

/** 행별 콤보 원천 — 그리드가 화면 진입 시 한 번에 받는다 */
export const ROW_COMBO_IDS = {
  /** 40 && ≠'기타' 시 (AS-IS L1268) — 부모키 `DEPARTMENT_ID` 컬럼 동반 반환 */
  DEPT_BY_DEPARTMENT: 'DMF0044_DEPARTMENT_TEAM',
  /**
   * CUST_REPORT 행별 콤보 (2026-08-11 신설 — 미배선 결함 정정).
   *   AS-IS `DMF0049_Sales_ETC_Reports.cs` L1346·L1367·L1597:
   *     `Data.Common(Data.Type.DMF0005_REPORT_GROUP2, false, "", "")` → SetCellTypeCombo(CUST_REPORT)
   *   ⚠ 파라미터 없음(division 무관). 메타(`SHEET_COLUMNS`)에는 CUST_REPORT 의 CELL_CONTROL/COMBO 가
   *     **비어 있다** — AS-IS 도 동일하며, `.cs` 가 런타임에 붙이는 행별 콤보이기 때문이다.
   *     ⇒ DMF0044 와 같은 계통(hook #59 §5-G) 으로 화면이 구독해 `beginningEdit` 에서 스왑한다.
   */
  CUST_REPORT: 'DMF0005_REPORT_GROUP2',
} as const;

/**
 * DEPT_ID 후보 행 해석 — AS-IS 2분기 1:1 (L1268 / L1294).
 * @param deptDefault  메타 콤보(`DMF0044_DEPARTMENT_TEAM2`) 결과 — division 단위
 * @param deptByDepartment  `DMF0044_DEPARTMENT_TEAM` 결과 — 부모키 동반
 */
export const resolveDeptIdRows = (
  row: EtcSalesReportRow | undefined,
  divisionId: string,
  src: {
    deptDefault: Record<string, unknown>[];
    deptByDepartment: Record<string, unknown>[];
  }
): Record<string, unknown>[] => {
  const rec = row as Record<string, unknown> | undefined;
  // 표시명 원천 = GET SP 의 `T_DEPARTMENT_NAME`(BODY L471 — 원장값 우선, 없으면 lookup SEGMENT2).
  //   AS-IS 는 `GetText(DEPARTMENT_ID 셀)` = 콤보 표시명이므로 같은 값이다.
  const departmentName = toCellStr(rec?.T_DEPARTMENT_NAME ?? rec?.DEPARTMENT_NAME).trim();
  const departmentId = toCellStr(rec?.DEPARTMENT_ID).trim();
  if (!isDiv40(divisionId) || departmentName === ETC_DEPARTMENT || !departmentId) {
    return src.deptDefault;
  }
  return src.deptByDepartment.filter(cr => toCellStr(cr.DEPARTMENT_ID).trim() === departmentId);
};

/**
 * DEPT_ID 컬럼 DataMap — 표시는 컬럼 전체(superset)로 고정하고, 드롭다운 후보만 행 컨텍스트로 좁힌다.
 *
 * 금지: `beginningEdit` 에서 `column.dataMap` 을 행별 콤보로 갈아끼우지 말 것 (2026-08-21 결함).
 *   wijmo 는 셀 표시 글자를 `Column.dataMap.getDisplayValue(key)` 로 만들고, 그 함수는 맵에 없는
 *   키를 만나면 **원값(코드)을 그대로** 돌려준다(`@mescius/wijmo.grid` DataMap 구현).
 *   dataMap 은 셀이 아니라 **컬럼** 속성이라, 한 셀이 편집에 들어간 순간 그 컬럼 전 행이 좁혀진
 *   맵을 타고 후보에 없는 코드가 전부 원 코드('소형.마케팅.IM.IM1팀')로 바뀐다. 편집이 끝나면
 *   원복되므로 사용자에게는 "Team 에 포커스만 가면 코드로 보였다 이름으로 돌아온다"로 보였다.
 * 대신 wijmo 가 후보 목록 전용으로 제공하는 `DataMap.getDisplayValues(dataItem)` 를 쓴다 —
 *   공용 컬럼 매핑(`packages/foundation/src/utils/columnMapping.ts` getDataMap)과 같은 처방이다.
 *
 * 표시명 우선순위는 **메타 콤보(deptDefault)** 다. 같은 CODE 가 양쪽 원천에 있으면 먼저 넣은 쪽이
 *   이기므로(DataMap 내부 색인이 첫 항목만 담는다) 편집 전후 글자가 갈리지 않는다. 후보 라벨도
 *   같은 맵을 거쳐 만들어 드롭다운과 셀이 같은 이름 체계를 쓴다.
 */
export const buildDeptIdDataMap = (
  src: {
    deptDefault: Record<string, unknown>[];
    deptByDepartment: Record<string, unknown>[];
  },
  divisionId: string
): DataMap | null => {
  const superset = [...src.deptDefault, ...src.deptByDepartment];
  if (superset.length === 0) return null;
  const dataMap = new DataMap(superset, 'CODE', 'NAME');
  dataMap.getDisplayValues = (rowItem?: unknown): string[] =>
    resolveDeptIdRows(rowItem as EtcSalesReportRow | undefined, divisionId, src).map(cr =>
      dataMap.getDisplayValue(toCellStr(cr.CODE))
    );
  return dataMap;
};

const CLEAR_FULL5 = ['ITEM_ID', 'NICK_NAME', 'END_CUST_REPORT', 'CUST_REPORT', 'PRODUCT_GROUP'];
const CLEAR_REPORT3 = ['END_CUST_REPORT', 'CUST_REPORT', 'PRODUCT_GROUP'];

/**
 * cascade clear 대상 — AS-IS 원문 매트릭스 1:1 (2026-08-10 `.cs` 직접 대조로 확정).
 *
 * **DEPARTMENT_ID 변경 — division 40 에서만 동작**(L1265 `if (gsDivision_id == "40")`,
 * 블록 끝 주석 `// 40 department 끝` L1326 이 확증. 비40 은 아무 것도 하지 않는다):
 * | 표시명 | Action | clear |
 * |---|---|---|
 * | ≠'기타' | 'M'   | CUST_REPORT (L1276~1279 [C20210125-000207]) |
 * | ≠'기타' | 그 외 | 5컬럼 (L1281~1287) |
 * | '기타'  | 'M'   | **없음** — 콤보만 dtNull 로 교체 (L1306~1309) |
 * | '기타'  | 그 외 | 5컬럼 (L1316~1320) |
 *
 * **DEPT_ID 변경 — division 무관**(L1331~1405):
 * | DEPARTMENT_ID | Action | clear |
 * |---|---|---|
 * | ≠''  | 'M'   | **없음** — CUST_REPORT 콤보만 재설정 (L1344~1352) |
 * | ≠''  | 그 외 | 5컬럼 (L1374~1378) |
 * | ''   | 'M'   | CUST_REPORT (L1391~1393) |
 * | ''   | 그 외 | 3컬럼 (L1398~1400) — ITEM_ID·NICK_NAME 은 건드리지 않는다 |
 */
export const cascadeClearColumns = (
  binding: string,
  row: EtcSalesReportRow | undefined,
  divisionId: string
): readonly string[] => {
  const rec = row as Record<string, unknown> | undefined;
  if (!rec) return [];
  const isM = toCellStr(rec.CRUD_TYPE) === 'M';
  const departmentId = toCellStr(rec.DEPARTMENT_ID).trim();

  if (binding === 'DEPARTMENT_ID') {
    if (!isDiv40(divisionId)) return []; // 비40 = AS-IS 무동작
    const isEtc = toCellStr(rec.T_DEPARTMENT_NAME ?? rec.DEPARTMENT_NAME).trim() === ETC_DEPARTMENT;
    if (!isM) return CLEAR_FULL5;
    return isEtc ? [] : ['CUST_REPORT'];
  }
  if (binding === 'DEPT_ID') {
    if (departmentId !== '') return isM ? [] : CLEAR_FULL5;
    return isM ? ['CUST_REPORT'] : CLEAR_REPORT3;
  }
  return [];
};
