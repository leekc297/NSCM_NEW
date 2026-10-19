import dayjs from '@foundation/dayjs';
import type { FlexGridColumnConfig } from '@foundation/models';

import {
  ASSIGN_PRIORITY_SUFFIX,
  COLUMN_WIDTH_EDIT,
  COLUMN_WIDTH_VIEW,
  PERIOD_PREFIX,
  type SheetStatus,
} from '../capa-loss-plan.constants';
import type { SpreadTitleRow } from '../capa-loss-plan.types';

/**
 * 동적 기간 컬럼 조립 — `PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE` 결과를 3단 헤더로 만든다(03 §2).
 *
 * 컬럼명 규약이 저장 계약과 직결된다:
 *   월 `M_01` + `yyyymm`(예 `M_01202603`) / 연 `Y_` + `yyyy`(예 `Y_2029`).
 *   **`M_` 뒤 `01` 두 자리를 빠뜨리면 저장 파싱이 전부 깨진다** — SAVE SP 가
 *   `SUBSTRING(COL_NAME,3,2)='01'` 로 월 컬럼을 거르기 때문이다(03 V-13).
 *   이름은 SP 가 준 `COLUMN_NAME` 을 **그대로** 쓴다(재조립 금지).
 *
 * `M_00`(개선율) 블록은 TVF 가 **0건 생성하는 사문**이다(03 §2.2, C-09) — 이식하지 않는다.
 * 그래서 `chkShowRate` 토글도 실효 무동작이 AS-IS 파리티다(R-02, V-19).
 */

/**
 * 저장 직렬화 대상 판정용 — AS-IS `SetQueryInfoSave` 의 `Substring(0,2)` 조건 그대로다(03 §3.5).
 * `M_00` 까지 포함하는 넓은 조건인 것이 AS-IS 원문이라 좁히지 않는다(실제 생성은 `M_01`/`Y_` 뿐).
 */
export const isPeriodColumn = (columnName: string): boolean =>
  columnName.startsWith('M_') || columnName.startsWith(PERIOD_PREFIX.YEAR);

/** 편집/저장 대상이 되는 순수 기간 컬럼(`*_ASSIGN_PRIORITY` 제외) 인가. */
export const isEditablePeriodColumn = (columnName: string): boolean =>
  isPeriodColumn(columnName) && !columnName.endsWith(ASSIGN_PRIORITY_SUFFIX);

// AS-IS 는 재계산 진입을 **컬럼 태그** 3갈래(`BASE_QTY` / `Y_` / `M_01`)로 나눈다(03 R-19).
//   TO-BE 는 `isMonthColumn`/`isYearColumn` 같은 판별 함수를 따로 두지 않는다 — 산식이 월/연으로
//   갈리지 않고(같은 7단계), 자릿수가 의미를 갖는 두 지점은 아래 `toPeriodKey` 의 **길이**로
//   판정하기 때문이다: `DAY_CNT` 매칭(6자리 월만 존재 -> 연은 기본 30, C-15)과
//   생산확정기간 잠금(6자리만 대상, V-29). 판별 함수를 두면 같은 규칙이 두 군데로 갈린다.

/**
 * 컬럼명에서 기간 키를 뽑는다 — AS-IS `colName.Replace("M_01","").Replace("Y_","")`(03 R-06).
 * 월이면 6자리(`202603`), 연이면 4자리(`2029`). **자릿수가 판정에 쓰인다**:
 * 생산확정기간 잠금은 6자리(월)에만 적용되고 `Y_yyyy` 는 대상이 아니다(V-29).
 */
export const toPeriodKey = (columnName: string): string =>
  columnName.replace(PERIOD_PREFIX.MONTH, '').replace(PERIOD_PREFIX.YEAR, '');

/** 기간 셀의 잠금 판정에 쓰는 짝 컬럼 키(03 R-27). */
export const assignPriorityKeyOf = (columnName: string): string =>
  `${columnName}${ASSIGN_PRIORITY_SUFFIX}`;

/**
 * `p_from_yyyymm` — 선택한 Plan Month(`VER_ID`, yyyyMM) **+1개월**(03 §2.1, V-11).
 * 그냥 Plan Month 를 넘기면 첫 달이 통째로 어긋난다.
 * Version 이 비었으면 빈 문자열을 돌려 호출부가 헤더 조회를 건너뛰게 한다.
 */
export const toFromYyyymm = (version: string): string => {
  if (!/^\d{6}$/.test(version)) return '';
  return dayjs(`${version}01`, 'YYYYMMDD').add(1, 'month').format('YYYYMM');
};

// SP 가 주는 `SORT_ORDER_NO` 는 12자리 고정폭 문자열이라 **문자열 정렬**이 곧 AS-IS 표시 순서다
//   (`_ASSIGN_PRIORITY` 복제본은 `99` 접두라 자동으로 뒤로 몰린다, 03 §2.2·V-14). 숫자 캐스팅 금지.
const sortBySortOrder = (rows: readonly SpreadTitleRow[]): SpreadTitleRow[] =>
  [...rows].sort((a, b) =>
    String(a.SORT_ORDER_NO ?? '').localeCompare(String(b.SORT_ORDER_NO ?? ''))
  );

/** 우선순위 컬럼을 뺀 순수 기간 컬럼명 목록 — 저장 직렬화 순서의 원천(03 §3.5). */
export const toPeriodColumnNames = (rows: readonly SpreadTitleRow[]): string[] =>
  sortBySortOrder(rows)
    .map(row => row.COLUMN_NAME)
    .filter(name => !!name && isEditablePeriodColumn(name));

/**
 * 헤더 조회 payload — `SCP0104_GET_SPREAD_TITLE` 는 SCP0104/0105/0106/0107/0108 **공용** SP 라
 * `programId + sheetName + fromYyyymm` 이 전부 캐시 키에 들어가야 다른 화면/다른 버전의 헤더가
 * 서빙되지 않는다(hook #115, 03 V-16). 공용 `useTabProcQuery` 의 queryKey 가
 * `[tabId, sheetName, action, {...filters}]` 라, 아래 3개를 filters 에 실으면 세 축이 키에 포함된다.
 *
 * **`p_sheet_name` 은 `_sheet_status`(4값)다** — 컬럼설정 팝업이 쓰는 `_sheet_name`(8값)과 축이 다르다.
 * 접미사를 붙이면 SP 가 매칭을 못 해 기간 컬럼이 0건이 된다(03 V-12). SCP0105 는 빈 문자열을
 * 넘기지만 이 화면은 상태별로 결과가 갈리므로 그대로 베끼면 안 된다.
 */
export const buildSpreadTitleFilters = (
  fromYyyymm: string,
  programId: string,
  sheetStatus: SheetStatus
): Record<string, string> => ({
  p_from_yyyymm: fromYyyymm,
  p_program_id: programId,
  p_sheet_name: sheetStatus,
});

/**
 * 3단 동적 컬럼 그룹 — 1단 `LARGE_CLASS_LABEL_NAME`(`Operation Plan`) > 2단
 * `SMALL_CLASS_LABEL_NAME`(연도) > 3단 `COLUMN_LABEL_NAME`(`2026-03` / `2029`).
 *
 * SCP0105 와 달리 이 화면은 lookup `SCP_CAPA_RPT_CODE` 에 행이 있어 **1단에 `Operation Plan` 이
 * 실제로 온다** — 빈 값이면 오류다(03 V-17). 값을 코드로 채우지 않는다(하드코딩 금지, 메타가 원천).
 *
 * `*_ASSIGN_PRIORITY` 는 컬럼으로 만들지 않는다. AS-IS 는 폭0 + Resizable=false 로 숨기지만,
 * Wijmo 에서는 컬럼을 만들면 우클릭 Filter/Sort/Hide 목록과 컬럼설정 모달에 노출된다(03 V-15).
 * 잠금 판정은 컬럼이 아니라 **행 데이터**(`row[name + '_ASSIGN_PRIORITY']`)를 읽으므로 데이터는 유지된다.
 *
 * 주의: 컬럼 정의에 `height` 를 넣지 않는다 — wijmo 가 각 헤더 row 에 명시 height 를 박아
 * 3단 전체가 1단 높이로 벌어진다. 높이는 DataGrid `headerRowHeight` prop 단일 출처(hook #93).
 */
export const buildPeriodColumns = (
  rows: readonly SpreadTitleRow[] | undefined,
  isEditMode = false
): FlexGridColumnConfig[] => {
  const leaves = sortBySortOrder(rows ?? []).filter(
    row => !!row.COLUMN_NAME && isEditablePeriodColumn(row.COLUMN_NAME)
  );
  if (leaves.length === 0) return [];

  // 폭 2모드 — 조회 80 / 편집 140(03 R-04, V-32).
  const columnWidth = isEditMode ? COLUMN_WIDTH_EDIT : COLUMN_WIDTH_VIEW;

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
      // 수치 셀은 병합 대상이 아니다 — 좌측 키 컬럼만 병합한다(03 R-14).
      allowMerging: false,
      allowResizing: true,
      // 우클릭 Filter/Sort/Hide 는 동작해야 한다(03 V-20). 기본 정렬만 막지 않는다.
      allowSorting: true,
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
