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

/** 행별 콤보 원천 — 그리드가 화면 진입 시 한 번에 받는다 */
export const ROW_COMBO_IDS = {
  // DEPT_ID(Team) 콤보 3종(DMF0044_DEPARTMENT_TEAM2 / _TEAM / ETC_SALE_RESULT_TYPE_40)은 제거 —
  //   사용자 지시 2026-08-28 (REQ:CHAT-20260828-05): 메타에 콤보 미설정 컬럼이라 코드 그대로 표시·입력.
  /** DEPT_ID 변경 시 CUST_REPORT (AS-IS Changed L1244) */
  CUST_REPORT: 'DMF0005_REPORT_GROUP2',
  /** DEPT_ID 변경 시 PRODUCT_GROUP (AS-IS Changed L1225 `GetLookupData("REPORT_GROUP3")`) */
  PRODUCT_GROUP: 'DMF0005_REPORT_GROUP3',
} as const;

/** DEPARTMENT_ID 변경 시 clear 대상 (AS-IS L1187~1191 / L1211~1215 — 양 분기 동일 5컬럼) */
export const DEPARTMENT_CHANGE_CLEAR = [
  'ITEM_ID',
  'NICK_NAME',
  'END_CUST_REPORT',
  'CUST_REPORT',
  'PRODUCT_GROUP',
] as const;

/** DEPT_ID 의 'MDF' 센티널 (AS-IS L1396 `sTEAM_NAME != "MDF"` 분기) — 내부 전용 */
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
