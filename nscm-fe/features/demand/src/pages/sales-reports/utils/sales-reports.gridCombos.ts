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

/**
 * DEPARTMENT_ID 코드의 '기타' 센티널 — 내부 전용.
 *
 * AS-IS L1176~1178 은 `GetValue`(=표시명이 아니라 **코드**)로 '기타' 를 본다. DMF0049 가
 *   `GetText`(표시명)로 보는 것과 반대이므로 그대로 따라간다 — 실제로 갈린다.
 *   AS-IS DB 실측(2026-08-31) 룩업 `MDF_DEPARTMENT` 에는 SEGMENT1='기타' 행이 있는 한편
 *   SEGMENT2(표시명)만 '기타' 인 행도 셋(58461689/58519609/58607727) 있어, 표시명으로 보면
 *   그 셋까지 '기타' 분기로 잘못 넘어간다.
 */
const ETC_DEPARTMENT = '기타';

/** 행별 콤보 원천 — 그리드가 화면 진입 시 한 번에 받는다 */
export const ROW_COMBO_IDS = {
  /**
   * DEPT_ID(Team) 기본 후보 — DEPARTMENT_ID 미입력 상태 (AS-IS InsertRow L989~991).
   *   콤보 SQL 이 LOOKUP_TYPE 을 division 으로 분기한다:
   *     'DMF0044_DEPARTMENT_TEAM2' + (division='40' ? '' : '_' + division)
   *   이는 AS-IS 조회 SP `DMF0044_GET_SALES_REPORTS_DATA` L487/L605 의 LK2 조인 규칙과 동일하다.
   */
  DEPT_DEFAULT: 'DMF0044_DEPARTMENT_TEAM2',
  /**
   * DEPT_ID(Team) — DEPARTMENT_ID 가 '기타' 가 아닐 때 (AS-IS L1178~1181).
   *   AS-IS 원천 SQL(`UP_FX_GetCommonDataList` @Code='DMF0044_DEPARTMENT_TEAM'):
   *     SELECT DEPT_ID AS CODE, DEPT_NAME_KO AS NAME FROM SCM_MST_SSO_DEPT_INFO
   *      WHERE UPPER_DEPT_ID = @Param1 AND VALID_YN = 'Y'
   *   즉 그 부서의 하위 팀이다. TO-BE 등록본은 파라미터 없이 부모키 `DEPARTMENT_ID` 를 함께
   *   내려주는 superset 이라, 행 컨텍스트 필터는 FE 가 한다(`resolveDeptIdRows`).
   */
  DEPT_BY_DEPARTMENT: 'DMF0044_DEPARTMENT_TEAM',
  /**
   * DEPT_ID(Team) — DEPARTMENT_ID 가 '기타' 일 때 (AS-IS L1193~1196). 파라미터 없음.
   *   AS-IS 실측 유효행은 '기타'/'기타' 하나뿐이다(나머지 ESR01~ESR08 은 VALID_YN='N').
   */
  DEPT_ETC: 'DMF0044_ETC_SALE_RESULT_TYPE_40',
  /** DEPT_ID 변경 시 CUST_REPORT (AS-IS Changed L1244) */
  CUST_REPORT: 'DMF0005_REPORT_GROUP2',
  /** DEPT_ID 변경 시 PRODUCT_GROUP (AS-IS Changed L1225 `GetLookupData("REPORT_GROUP3")`) */
  PRODUCT_GROUP: 'DMF0005_REPORT_GROUP3',
} as const;

/** DEPT_ID 후보의 세 원천 — AS-IS 3분기와 1:1 */
export interface DeptIdComboSource {
  /** `DMF0044_DEPARTMENT_TEAM2` — division 단위 */
  deptDefault: Record<string, unknown>[];
  /** `DMF0044_DEPARTMENT_TEAM` — 부모키 `DEPARTMENT_ID` 동반 superset */
  deptByDepartment: Record<string, unknown>[];
  /** `DMF0044_ETC_SALE_RESULT_TYPE_40` — 파라미터 없음 */
  deptEtc: Record<string, unknown>[];
}

/**
 * DEPT_ID 후보 행 해석 — AS-IS 3분기 1:1.
 *
 * | 행의 DEPARTMENT_ID(코드) | 후보 | AS-IS |
 * |---|---|---|
 * | 공란(아직 미선택)        | `DMF0044_DEPARTMENT_TEAM2`         | InsertRow L989~991 |
 * | '기타'                   | `DMF0044_ETC_SALE_RESULT_TYPE_40`  | Changed L1193~1196 |
 * | 그 외                    | `DMF0044_DEPARTMENT_TEAM`(그 부서) | Changed L1178~1181 |
 *
 * 주의: division 가드가 없다. DMF0049 는 `if (gsDivision_id == "40")` 로 비40 을 통째로
 *   비켜가지만 DMF0044 에는 그 가드가 없다 — 형제 화면이라도 원문 그대로 따른다.
 */
export const resolveDeptIdRows = (
  row: SalesReportRow | undefined,
  src: DeptIdComboSource
): Record<string, unknown>[] => {
  const departmentId = toCellStr(
    (row as Record<string, unknown> | undefined)?.DEPARTMENT_ID
  ).trim();
  if (!departmentId) return src.deptDefault;
  if (departmentId === ETC_DEPARTMENT) return src.deptEtc;
  return src.deptByDepartment.filter(cr => toCellStr(cr.DEPARTMENT_ID).trim() === departmentId);
};

/**
 * DEPT_ID 컬럼 DataMap — 표시는 컬럼 전체(superset)로 고정하고, 드롭다운 후보만 행 컨텍스트로 좁힌다.
 *
 * 금지: `beginningEdit` 에서 `column.dataMap` 을 행별 콤보로 갈아끼우지 말 것.
 *   dataMap 은 셀이 아니라 **컬럼** 속성이라 한 셀이 편집에 들어가는 순간 그 컬럼 전 행이 좁혀진
 *   맵을 타고, 후보에 없는 코드가 전부 원 코드로 드러난다
 *   (규약 전문 = `.atlas/wiki/wijmo-column-datamap-not-per-cell.md`).
 * 대신 wijmo 가 후보 목록 전용으로 제공하는 `DataMap.getDisplayValues(dataItem)` 를 쓴다 —
 *   공용 컬럼 매핑(`packages/foundation/src/utils/columnMapping.ts` getRowParamDataMap)과
 *   자매 화면 DMF0049(`etc-sales-reports.gridCombos.ts` buildDeptIdDataMap)의 처방과 같다.
 *
 * 표시명 우선순위는 먼저 넣은 `deptDefault` 다 — DataMap 내부 색인이 같은 CODE 의 첫 항목만
 *   담으므로, 세 원천에 같은 코드가 겹쳐도 편집 전후로 글자가 갈리지 않는다.
 */
export const buildDeptIdDataMap = (src: DeptIdComboSource): DataMap | null => {
  const superset = [...src.deptDefault, ...src.deptByDepartment, ...src.deptEtc];
  if (superset.length === 0) return null;
  const dataMap = new DataMap(superset, 'CODE', 'NAME');
  dataMap.getDisplayValues = (rowItem?: unknown): string[] =>
    resolveDeptIdRows(rowItem as SalesReportRow | undefined, src).map(cr =>
      dataMap.getDisplayValue(toCellStr(cr.CODE))
    );
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

/**
 * DEPT_ID 의 'MDF' 센티널 (AS-IS L1396 `sTEAM_NAME != "MDF"` 분기) — 내부 전용.
 *
 * 주의: AS-IS DB 실측(2026-08-31) 결과 세 원천 어디에도 'MDF' 후보가 없다.
 *   · `DMF0044_DEPARTMENT_TEAM2` 의 SEGMENT1='MDF' 행은 VALID_YN='N' 이고 콤보 SQL 이 'Y' 로 거른다.
 *   · `DMF0044_DEPARTMENT_TEAM` 의 `SELECT 'MDF' AS CODE` UNION 은 AS-IS 원천 SQL 에서 주석 처리다
 *     (`UP_FX_GetCommonDataList` 변경이력 2019/08/19 "DMF0044_DEPARTMENT_TEAM > MDF 제거").
 *   · `DMF0044_ETC_SALE_RESULT_TYPE_40` 의 유효행은 '기타' 하나뿐이다.
 *   따라서 아래 분기는 사실상 항상 비MDF 쪽으로 간다. AS-IS 도 같은 원천/같은 코드 비교라
 *   동작 파리티는 유지된다 — 규칙을 없애지 않고 그대로 둔다.
 */
const MDF_TEAM = 'MDF';

/** 비MDF 팀의 MODEL 강제값 (AS-IS L1405~1406). 이 값이면 Item 팝업도 열리지 않는다(M-8 L93) */
export const ETC_SALES_ITEM = '기타매출';

/** DEPT_ID 변경 시 clear 대상 (AS-IS L1407~1409 / L1424~1426 / L1450~1452 — 3분기 공통) */
export const DEPT_CHANGE_CLEAR = ['END_CUST_REPORT', 'CUST_REPORT', 'PRODUCT_GROUP'] as const;

/**
 * DEPT_ID(팀) 변경 cascade — AS-IS spdMain_Changed L1370~1452 의 값 세팅분 1:1.
 *
 *   · DEPARTMENT_ID 공란            → 하위 3컬럼만 clear. MODEL 은 건드리지 않는다 (else 분기 L1444~1452)
 *   · DEPARTMENT_ID 있고 팀 != 'MDF' → MODEL/모델명 = '기타매출' 강제 + 3컬럼 clear (L1396~1409)
 *   · DEPARTMENT_ID 있고 팀 == 'MDF' → MODEL/모델명 clear + 3컬럼 clear (L1411~1426)
 *
 * 비MDF 팀은 모델을 고를 수 없다는 뜻이다 — 강제된 '기타매출' 값 자체가 Item 팝업 진입을 막는
 *   가드(`SalesReportsGrid` dblclick, AS-IS L1314)와 같은 열쇠라 두 규칙이 한 값으로 맞물린다.
 *
 * 판정값: AS-IS 는 팀 셀의 `GetValue`(=코드)로 'MDF' 를 본다. 다만 콤보 등재에 따라 'MDF' 가
 *   코드가 아니라 표시명 쪽일 수 있어 `teamNameOf` 로 표시명도 함께 본다(코드 우선).
 *
 * @returns 값이 바뀐 binding 목록 — 호출부가 Insert 세트 동기화(syncInsertSet)에 그대로 넘긴다.
 */
export const applyDeptIdChange = (
  row: SalesReportRow,
  teamNameOf?: (code: string) => string
): string[] => {
  const rec = row as Record<string, unknown>;
  const changed: string[] = [...DEPT_CHANGE_CLEAR];
  DEPT_CHANGE_CLEAR.forEach(col => {
    rec[col] = '';
  });

  if (!toCellStr(rec.DEPARTMENT_ID).trim()) return changed;

  const team = toCellStr(rec.DEPT_ID).trim();
  const isMdf = team === MDF_TEAM || (teamNameOf?.(team) ?? '').trim() === MDF_TEAM;
  const model = isMdf ? '' : ETC_SALES_ITEM;
  rec.ITEM_ID = model;
  rec.NICK_NAME = model;
  changed.push('ITEM_ID', 'NICK_NAME');
  return changed;
};
