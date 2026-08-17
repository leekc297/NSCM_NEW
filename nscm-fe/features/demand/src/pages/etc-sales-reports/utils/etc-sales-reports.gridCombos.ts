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
