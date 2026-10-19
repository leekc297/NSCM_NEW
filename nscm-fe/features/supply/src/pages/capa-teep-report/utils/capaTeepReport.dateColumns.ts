import dayjs from '@foundation/dayjs';
import type { FlexGridColumnConfig } from '@foundation/models';

import {
  MENU_ID,
  PERIOD_COLUMN_WIDTH,
  PERIOD_PREFIX,
  SCALE_DEFAULT,
  type GridSheet,
} from '../capa-teep-report.constants';
import type { SpreadTitleFilters, SpreadTitleRow } from '../capa-teep-report.types';

/**
 * 동적 기간 컬럼 조립 — `PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE` 결과를 3단 헤더로 만든다(03 §2).
 *
 * 컬럼명 규약: 월 `M_01` + `yyyymm`(예 `M_01202602`) / 연 `Y_` + `yyyy`(예 `Y_2029`).
 * **SP 가 준 `COLUMN_NAME` 을 그대로 바인딩에 쓴다**(재조립 금지, V-12) — `M_` 뒤 `01` 두 자리를
 * 축약하면 SP 응답 키와 어긋나 전 기간 셀이 빈다.
 *
 * SCP0107 에 **없는 것**(자매 화면에서 복사하면 죽은 코드가 된다):
 *  - `*_ASSIGN_PRIORITY` — TVF 가 `SCP0105`/`SCP0106` 에만 만든다. SCP0107 은 0건 생성(03 §2.7 / V-13).
 *  - `M_00`(개선율) — SCP0106 전용이며 TVF 본문이 전면 주석 처리돼 있다.
 *  - `D_`/`W_` 버킷 — 버킷 선택 UI 가 없고 TVF 어느 분기에도 없다(03 §2.6).
 */

/** 기간 컬럼인가 — 월/연 접두 2종(03 §2.2). */
export const isPeriodColumn = (columnName: string): boolean =>
  columnName.startsWith(PERIOD_PREFIX.MONTH) || columnName.startsWith(PERIOD_PREFIX.YEAR);

/**
 * `p_from_yyyymm` — 선택한 Plan Month(`VER_ID`, yyyyMM) **+1개월**(03 §2.1 / V-10).
 *
 * **이 화면만 +1개월이다.** 자매 SCP0106 은 `_version` 을 그대로 넘긴다(goal S-9) — 그냥 Plan Month 를
 * 넘기면 기간 컬럼셋의 첫 달이 통째로 어긋난다. GET SP 도 내부에서 `DATEADD(MM,1,...)` 로 같은 값을
 * 재계산하므로(03 §2.1 마지막 행) 헤더와 데이터가 같은 기준을 쓴다.
 * 6자리 숫자가 아니면 빈 문자열을 돌려 호출부가 헤더 조회를 건너뛰게 한다(SCP0106 `toFromYyyymm` 선례).
 */
export const toFromYyyymm = (verId: string): string => {
  if (!/^\d{6}$/.test(verId)) return '';
  return dayjs(`${verId}01`, 'YYYYMMDD').add(1, 'month').format('YYYYMM');
};

/**
 * 헤더 조회 payload.
 *
 * `p_sheet_name` 은 **`ASSEMBLY` | `ELTR`** 이다 — lookup `SCP_CAPA_RPT_CODE` 에 `SEGMENT1='SCP0107'`
 * 기준 2행(`SEGMENT2 ∈ {ASSEMBLY, ELTR}`)이 있어 1단 라벨 `Operation Plan` 이 그 키로 매칭된다
 * (ora.py 실측 2026-09-25). 자매 SCP0108 은 `'MAIN'` 리터럴, SCP0106 은 `_sheet_status` 4값이라
 * **셋 다 다르다 — 복사 금지**(03 §2.2 / V-16).
 *
 * 같은 SP 를 5개 화면이 공유하므로 `programId + sheetName + fromYyyymm` 3요소가 전부 filters 에 실려야
 * 캐시 키(`[tabId, sheetName, action, {...filters}]`)로 화면 간 오염이 차단된다(hook #115 / V-18d).
 * 키는 camelCase 다 — 근거는 `capa-teep-report.types.ts` 의 `CapaTeepFilters` 주석 참조.
 */
export const buildSpreadTitleFilters = (
  fromYyyymm: string,
  sheetName: GridSheet
): SpreadTitleFilters => ({
  fromYyyymm,
  programId: MENU_ID,
  sheetName,
});

/**
 * `SORT_ORDER_NO` 는 `CONCAT('01', MIN(BASIS_START_DATE), '01')` = **12자리 고정폭 문자열**이라
 * 문자열 정렬이 곧 표시 순서다(03 §2.2). 숫자 캐스팅 금지 — SCP0106 `capaLossPlan.dateColumns.ts`
 * 와 동일 규약이다.
 */
const sortBySortOrder = (rows: readonly SpreadTitleRow[]): SpreadTitleRow[] =>
  [...rows].sort((a, b) =>
    String(a.SORT_ORDER_NO ?? '').localeCompare(String(b.SORT_ORDER_NO ?? ''))
  );

// `toPeriodColumnNames`(기간 컬럼명 목록) 를 두지 않는다 — 자매 SCP0106 은 저장 직렬화 순서의 원천으로,
//   SCP0108 은 Bottleneck 커서 병합축으로 쓰지만 **SCP0107 에는 저장 경로도 2번째 커서도 없다**
//   (03 §4.4 / §1.6). 소비처 없는 export 는 두지 않는다(convert-core §4.2 util 정의-참조 게이트 —
//   "배선 누락" 이 아니라 "이 화면에 그 축이 없다" 는 dead 판정이며 근거를 04 리포트에 남겼다).

/**
 * 3단 헤더의 3단 라벨 — AS-IS `HeaderDateFormatType.MM` 재현(su:691~697 / V-18).
 * SP 가 주는 `COLUMN_LABEL_NAME` 은 월 컬럼이 `'2026-02'`(7자)인데 AS-IS 는 7자 이상이면
 * `Substring(5,2)` 로 잘라 **`02`** 두 자리만 보여준다. 연 컬럼은 `'2029'`(4자)라 그대로 둔다.
 * 자매 SCP0106/SCP0108 은 원문을 그대로 쓰므로 그 코드를 복사하면 3단이 `2026-02` 로 길어진다.
 */
export const toPeriodHeaderLabel = (label: string): string =>
  label.length >= 7 ? label.slice(5, 7) : label;

/**
 * 3단 동적 컬럼 그룹 — 1단 `LARGE_CLASS_LABEL_NAME`(`Operation Plan`) > 2단
 * `SMALL_CLASS_LABEL_NAME`(연도) > 3단 `COLUMN_LABEL_NAME`(월 2자리 / 연 4자리).
 *
 * 폭은 **80** 이다(AS-IS `RefreshSpreadDateColumn(..., 80, ...)`) — SCP0104 의 40 을 복사하지 말 것(V-14).
 * 기본 소수 1자리(`SCALE_DEFAULT`)를 컬럼 `format` 으로 깔고, 행마다 다른 자릿수는 `formatItem` 이
 * 덮어쓴다(03 §3.2 G-13 — 컬럼 단위로는 행별 규칙을 표현할 수 없다).
 *
 * 주의: 컬럼 정의에 `height` 를 넣지 않는다 — wijmo 가 각 헤더 row 에 명시 height 를 박아 3단 전체가
 * 1단 높이로 벌어진다. 높이는 DataGrid `headerRowHeight` prop 단일 출처다(hook #93 / V-18c).
 */
export const buildPeriodColumns = (
  rows: readonly SpreadTitleRow[] | undefined
): FlexGridColumnConfig[] => {
  const leaves = sortBySortOrder(rows ?? []).filter(
    row => !!row.COLUMN_NAME && isPeriodColumn(row.COLUMN_NAME)
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
      header: toPeriodHeaderLabel(String(row.COLUMN_LABEL_NAME ?? row.COLUMN_NAME)),
      align: 'right',
      format: `n${SCALE_DEFAULT}`,
      width: PERIOD_COLUMN_WIDTH,
      allowDragging: false,
      // 수치가 세로로 묶이면 안 된다 — 병합은 좌측 정적 컬럼 전용이다(03 §3.4 / V-27).
      allowMerging: false,
      allowResizing: true,
      // 정렬·필터·숨김은 기간 컬럼에서도 동작해야 한다(공통 QA "우측 동적영역 포함").
      allowSorting: true,
      // 전 셀 비편집 — `INPUT_TP_CD='S'` 50행 전건이자 조회 직후 전열 잠금(03 G-08 / V-28).
      isReadOnly: true,
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
