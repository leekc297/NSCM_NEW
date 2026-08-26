// ⭐ DMF0044 — Grid 셀 콤보 dataMap 헬퍼 (hook #59 §5-G — business-plan.gridCombos 동형 축약).
//   AS-IS cascade: spdMain_Changed M-6/M-7 (L1174~1293) — DEPARTMENT_ID→DEPT_ID 콤보,
//   DEPT_ID→고객/제품군 콤보 연동 (CMBO 'DMF0044_MDF_DEPARTMENT'/'DMF0044_DEPARTMENT_TEAM2' 원천).
import { DataMap } from '@mescius/wijmo.grid';

import type { SalesReportRow } from '../sales-reports.types';

export const toCellStr = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 행 컨텍스트 cascade 필터 (관대 통과: 공란/'ALL' = 통과)
export const filterComboRowsByRow = (
  src: Record<string, unknown>[],
  row: SalesReportRow,
  cascade: { rowKey: string; comboKey: string }[]
): Record<string, unknown>[] => {
  const rowRec = row as Record<string, unknown>;
  const filtered = src.filter(cr =>
    cascade.every(({ rowKey, comboKey }) => {
      const rv = toCellStr(rowRec[rowKey]).trim();
      const cv = toCellStr(cr[comboKey]).trim();
      return !rv || rv === 'ALL' || !cv || rv === cv;
    })
  );
  return [
    ...new Map(
      filtered.map(cr => [`${toCellStr(cr.DIVISION_ID)}|${toCellStr(cr.CODE)}`, cr])
    ).values(),
  ];
};

// 콤보 rows → DataMap (0건 = null — 메타 주도, 하드코딩 fallback 금지)
export const buildDataMap = (rows: Record<string, unknown>[]): DataMap | null =>
  rows.length > 0 ? new DataMap(rows, 'CODE', 'NAME') : null;

// Grid 행 cascade 정의 — DEPARTMENT_ID → DEPT_ID (AS-IS ComboSelChange M-6)
export const GRID_CASCADE_FILTERS: Record<string, { rowKey: string; comboKey: string }[]> = {
  DEPT_ID: [{ rowKey: 'DEPARTMENT_ID', comboKey: 'DEPARTMENT_ID' }],
};

// ============================================================================
// ⭐ 그리드 행별 콤보 (2026-08-09 이관 — AS-IS `.cs` 런타임 `SetCellTypeCombo` 분)
//   AS-IS 는 SHEET_COLUMNS 메타가 아니라 `.cs` 가 행마다 콤보를 붙인다. 메타에는 AS-IS 도 없다.
//   TO-BE 등가 = 원천 콤보를 화면 단위로 받아 `beginningEdit` 에서 행 컨텍스트로 골라 스왑(hook #59 §5-G).
// ============================================================================

/** DEPARTMENT_ID 의 '기타' 센티널 (AS-IS L1178 `sDEPT_NAME != "기타"` 분기) — 내부 전용 */
const ETC_DEPARTMENT = '기타';

/** 행별 콤보 원천 — 그리드가 화면 진입 시 한 번에 받는다 */
export const ROW_COMBO_IDS = {
  /** DEPARTMENT_ID 미입력 시의 DEPT_ID 후보 (AS-IS InsertRow L990 — Param1='' 분기) */
  DEPT_DEFAULT: 'DMF0044_DEPARTMENT_TEAM2',
  /** DEPARTMENT_ID 입력 시 (AS-IS Changed L1180 — UPPER_DEPT_ID 필터). 부모키 컬럼 동반 반환 */
  DEPT_BY_DEPARTMENT: 'DMF0044_DEPARTMENT_TEAM',
  /** DEPARTMENT_ID='기타' 시 (AS-IS Changed L1195) */
  DEPT_ETC: 'DMF0044_ETC_SALE_RESULT_TYPE_40',
  /** DEPT_ID 변경 시 CUST_REPORT (AS-IS Changed L1244) */
  CUST_REPORT: 'DMF0005_REPORT_GROUP2',
  /** DEPT_ID 변경 시 PRODUCT_GROUP (AS-IS Changed L1225 `GetLookupData("REPORT_GROUP3")`) */
  PRODUCT_GROUP: 'DMF0005_REPORT_GROUP3',
} as const;

/**
 * DEPT_ID 후보 행 해석 — AS-IS 3분기 1:1 (L990 / L1180 / L1195).
 *   미입력 → TEAM2 · '기타' → ETC · 그 외 → TEAM 을 DEPARTMENT_ID 로 필터
 * ⚠ 필터는 `filterComboRowsByRow` 와 같은 관대 규약(공란/'ALL' 통과)을 쓴다.
 */
export const resolveDeptIdRows = (
  row: SalesReportRow | undefined,
  src: {
    deptDefault: Record<string, unknown>[];
    deptByDepartment: Record<string, unknown>[];
    deptEtc: Record<string, unknown>[];
  }
): Record<string, unknown>[] => {
  const department = toCellStr((row as Record<string, unknown>)?.DEPARTMENT_ID).trim();
  if (!department) return src.deptDefault;
  if (department === ETC_DEPARTMENT) return src.deptEtc;
  return src.deptByDepartment.filter(cr => toCellStr(cr.DEPARTMENT_ID).trim() === department);
};

/**
 * DEPT_ID 컬럼 DataMap — 표시는 컬럼 전체(superset)로 고정하고, 드롭다운 후보만 행 컨텍스트로 좁힌다.
 *
 * 금지: `beginningEdit` 에서 `column.dataMap` 을 행별/cascade 콤보로 갈아끼우지 말 것
 *   (2026-08-21 결함 — DMF0049 Team 에서 먼저 잡혔고 이 화면도 같은 구조였다).
 *   wijmo 는 셀 표시 글자를 `Column.dataMap.getDisplayValue(key)` 로 만들고, 그 함수는 맵에 없는
 *   키를 만나면 **원값(코드)을 그대로** 돌려준다(`@mescius/wijmo.grid` DataMap 구현).
 *   dataMap 은 셀이 아니라 **컬럼** 속성이라, 한 셀이 편집에 들어가면 그 컬럼 전 행이 좁혀진 맵을
 *   타고 후보에 없는 코드가 전부 원 코드로 드러난다. 편집이 끝나면 원복되므로 사용자에게는
 *   "Team 에 포커스만 가면 코드로 보였다 이름으로 돌아온다"로 보인다.
 * 대신 wijmo 가 후보 목록 전용으로 제공하는 `DataMap.getDisplayValues(dataItem)` 를 쓴다 —
 *   공용 컬럼 매핑(`packages/foundation/src/utils/columnMapping.ts` getDataMap)과 같은 처방이다.
 *
 * 후보 우선순위는 옛 `beginningEdit` 분기 1:1 이다 — 행별 콤보 3분기(`resolveDeptIdRows`)가
 *   0건일 때만 메타 콤보를 상위 셀 값으로 거른다(AS-IS ComboSelChange M-6).
 * 표시명 우선순위는 **메타 콤보(metaRows)** 다. 같은 CODE 가 여러 원천에 있으면 먼저 넣은 쪽이
 *   이기므로(DataMap 내부 색인이 첫 항목만 담는다) 편집 전후 글자가 갈리지 않는다. 후보 라벨도
 *   같은 맵을 거쳐 만들어 드롭다운과 셀이 같은 이름 체계를 쓴다.
 *
 * 규약 전문 = `.atlas/wiki/wijmo-column-datamap-not-per-cell.md`.
 */
export const buildDeptIdDataMap = (src: {
  /** 메타 콤보(`cellCboDataTp`) rows — 표시명 원천이자 cascade fallback */
  metaRows: Record<string, unknown>[];
  deptDefault: Record<string, unknown>[];
  deptByDepartment: Record<string, unknown>[];
  deptEtc: Record<string, unknown>[];
}): DataMap | null => {
  const superset = [...src.metaRows, ...src.deptDefault, ...src.deptEtc, ...src.deptByDepartment];
  if (superset.length === 0) return null;
  const dataMap = new DataMap(superset, 'CODE', 'NAME');
  dataMap.getDisplayValues = (rowItem?: unknown): string[] => {
    const row = rowItem as SalesReportRow | undefined;
    const rowScoped = resolveDeptIdRows(row, src);
    const candidates =
      rowScoped.length > 0
        ? rowScoped
        : row
          ? filterComboRowsByRow(src.metaRows, row, GRID_CASCADE_FILTERS.DEPT_ID)
          : src.metaRows;
    return candidates.map(cr => dataMap.getDisplayValue(toCellStr(cr.CODE)));
  };
  return dataMap;
};

/** DEPARTMENT_ID 변경 시 clear 대상 (AS-IS L1187~1191 / L1211~1215 — 양 분기 동일 5컬럼) */
export const DEPARTMENT_CHANGE_CLEAR = [
  'ITEM_ID',
  'NICK_NAME',
  'END_CUST_REPORT',
  'CUST_REPORT',
  'PRODUCT_GROUP',
] as const;
