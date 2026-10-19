import dayjs from '@foundation/dayjs';
import type { FlexGridColumnConfig } from '@foundation/models';

import { ASSIGN_PRIORITY_SUFFIX, PERIOD_PREFIX } from '../capa-speed-plan.constants';
import type { SpreadTitleRow } from '../capa-speed-plan.types';

/**
 * 동적 기간 컬럼 조립 — `PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE` 결과를 3단 헤더로 만든다(03 §2).
 *
 * 컬럼명 규약이 저장 계약과 직결된다:
 *   월 `M_01` + `yyyymm` (예 `M_01202510`) / 연 `Y_` + `yyyy`.
 *   **`M_` 뒤 `01` 두 자리를 빠뜨리면 저장 파싱이 전부 깨진다** — SAVE SP 가 `SUBSTRING(name,5,6)`
 *   으로 yyyymm 을 뽑기 때문이다(03 V-13). 이름은 SP 가 준 `COLUMN_NAME` 을 그대로 쓴다.
 */

/** 기간 컬럼(짝 우선순위 컬럼 포함)인가. */
export const isPeriodColumn = (columnName: string): boolean =>
  columnName.startsWith(PERIOD_PREFIX.MONTH) || columnName.startsWith(PERIOD_PREFIX.YEAR);

/** 편집/저장 대상이 되는 순수 기간 컬럼(`*_ASSIGN_PRIORITY` 제외) 인가. */
export const isEditablePeriodColumn = (columnName: string): boolean =>
  isPeriodColumn(columnName) && !columnName.endsWith(ASSIGN_PRIORITY_SUFFIX);

/** 기간 셀의 잠금 판정에 쓰는 짝 컬럼 키(03 §2.6). */
export const assignPriorityKeyOf = (columnName: string): string =>
  `${columnName}${ASSIGN_PRIORITY_SUFFIX}`;

/**
 * `p_from_yyyymm` — 선택한 Plan Month(`VER_ID`, yyyyMM) **+1개월**(AS-IS `_from_yyyymm` cs:243~264).
 * Version 이 비었으면 빈 문자열을 돌려 호출부가 헤더 조회를 건너뛰게 한다.
 */
export const toFromYyyymm = (version: string): string => {
  if (!/^\d{6}$/.test(version)) return '';
  return dayjs(`${version}01`, 'YYYYMMDD').add(1, 'month').format('YYYYMM');
};

// SP 가 주는 `SORT_ORDER_NO` 는 `'012025100101'` 처럼 자릿수가 고정된 문자열이라 문자열 정렬이 곧
//   AS-IS 표시 순서다(`_ASSIGN_PRIORITY` 복제본은 `99` 접두라 자동으로 뒤로 몰린다, 03 §2.3).
const sortBySortOrder = (rows: readonly SpreadTitleRow[]): SpreadTitleRow[] =>
  [...rows].sort((a, b) =>
    String(a.SORT_ORDER_NO ?? '').localeCompare(String(b.SORT_ORDER_NO ?? ''))
  );

/** 우선순위 컬럼을 뺀 순수 기간 컬럼명 목록 — 저장 직렬화 순서의 원천(03 §4.3). */
export const toPeriodColumnNames = (rows: readonly SpreadTitleRow[]): string[] =>
  sortBySortOrder(rows)
    .map(row => row.COLUMN_NAME)
    .filter(name => !!name && isEditablePeriodColumn(name));

/**
 * 3단 동적 컬럼 그룹 — 1단 `LARGE_CLASS_LABEL_NAME` > 2단 `SMALL_CLASS_LABEL_NAME`(연도) >
 * 3단 `COLUMN_LABEL_NAME`(`2025-10` / `2028`).
 *
 * SCP0105 는 lookup `SCP_CAPA_RPT_CODE` 에 행이 없어 **1단 라벨이 항상 빈 값**이다 —
 * AS-IS 패리티이므로 임의로 채우지 않는다(03 §2.2-5, C-11).
 *
 * `*_ASSIGN_PRIORITY` 는 컬럼으로 만들지 않는다. AS-IS 는 폭0 + Resizable=false 로 숨기지만,
 * Wijmo 에서는 컬럼을 만들면 우클릭 Filter/Sort/Hide 목록과 컬럼설정 모달에 노출된다(R-03 취지 위반).
 * 잠금 판정은 컬럼이 아니라 **행 데이터**(`row[name + '_ASSIGN_PRIORITY']`)를 읽으므로 데이터는 유지된다.
 *
 * 주의: 컬럼 정의에 `height` 를 넣지 않는다 — wijmo 가 각 헤더 row 에 명시 height 를 박아
 * 3단 전체가 1단 높이로 벌어진다. 높이는 DataGrid `headerRowHeight` prop 단일 출처(hook #93).
 */
export const buildPeriodColumns = (
  rows: readonly SpreadTitleRow[] | undefined,
  columnWidth = 120
): FlexGridColumnConfig[] => {
  const leaves = sortBySortOrder(rows ?? []).filter(
    row => !!row.COLUMN_NAME && isEditablePeriodColumn(row.COLUMN_NAME)
  );
  if (leaves.length === 0) return [];

  type Group = { header: string; columns: FlexGridColumnConfig[] };
  const largeGroups: { header: string; subs: Map<string, Group> }[] = [];
  const largeIndex = new Map<string, number>();

  for (const row of leaves) {
    const largeLabel = String(row.LARGE_CLASS_LABEL_NAME ?? '');
    const smallLabel = String(row.SMALL_CLASS_LABEL_NAME ?? '');
    let index = largeIndex.get(largeLabel);
    if (index === undefined) {
      index = largeGroups.length;
      largeIndex.set(largeLabel, index);
      largeGroups.push({ header: largeLabel, subs: new Map() });
    }
    const subs = largeGroups[index].subs;
    let sub = subs.get(smallLabel);
    if (!sub) {
      sub = { header: smallLabel, columns: [] };
      subs.set(smallLabel, sub);
    }
    sub.columns.push({
      binding: row.COLUMN_NAME,
      header: String(row.COLUMN_LABEL_NAME ?? row.COLUMN_NAME),
      align: 'right',
      width: columnWidth,
      allowDragging: false,
      allowMerging: false,
      allowResizing: true,
      allowSorting: false,
      visible: true,
      _display: true,
      _dynamic: true,
    });
  }

  return largeGroups.map(group => ({
    header: group.header,
    align: 'center',
    visible: true,
    columns: [...group.subs.values()].map(sub => ({
      header: sub.header,
      align: 'center',
      visible: true,
      columns: sub.columns,
    })),
  }));
};

/** 컬럼셋 재조립 억제용 서명 — 조회마다 배열 참조가 바뀌어도 내용이 같으면 rebuild 하지 않는다. */
export const periodColumnSignature = (rows: readonly SpreadTitleRow[] | undefined): string =>
  (rows ?? []).map(row => row.COLUMN_NAME).join(',');

/**
 * 헤더 조회 payload — `SCP0104_GET_SPREAD_TITLE` 는 SCP0104/0105/0106/0107/0108 **공용** SP 라
 * `programId + sheetName + fromYyyymm` 이 전부 캐시 키에 들어가야 다른 화면/다른 버전의 헤더가
 * 서빙되지 않는다(hook #115). 공용 `useTabProcQuery` 의 queryKey 가 `[tabId, sheetName, action,
 * {...filters}]` 라, 아래 3개를 filters 에 실으면 세 축이 모두 키에 포함된다.
 * `p_sheet_name` 은 AS-IS 가 빈 문자열을 넘긴다 — 이 SP 는 시트별로 결과가 다르지 않다(03 §2.1).
 */
export const buildSpreadTitleFilters = (
  fromYyyymm: string,
  programId: string
): Record<string, string> => ({
  p_from_yyyymm: fromYyyymm,
  p_program_id: programId,
  p_sheet_name: '',
});
