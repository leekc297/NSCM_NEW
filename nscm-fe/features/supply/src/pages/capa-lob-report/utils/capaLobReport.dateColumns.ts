import dayjs from '@foundation/dayjs';
import type { FlexGridColumnConfig } from '@foundation/models';

import {
  HEADER_LOOKUP_SHEET_NAME,
  MENU_ID,
  PERIOD_COLUMN_WIDTH,
  PERIOD_NUMBER_FORMAT,
  PERIOD_PREFIX,
} from '../capa-lob-report.constants';
import type { SpreadTitleFilters, SpreadTitleRow } from '../capa-lob-report.types';

/**
 * 동적 기간 컬럼 조립 — `PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE` 결과를 3단 헤더로 만든다(03 §2).
 *
 * 컬럼명 규약: 월 `M_01` + `yyyymm`(예 `M_01202511`) / 연 `Y_` + `yyyy`.
 * **`M_` 뒤 `01` 두 자리를 임의로 축약하지 않는다**(03 V-14) — 이름은 SP 가 준 `COLUMN_NAME` 그대로 쓴다.
 *
 * SCP0108 에 없는 것(자매 화면에서 복사하면 죽은 코드가 된다):
 *  - `*_ASSIGN_PRIORITY` 컬럼 — TVF 가 SCP0105/0106 에서만 생성한다. SCP0108 실측 0건(03 §2.3 / R-07).
 *  - `M_00` 개선율 컬럼 — SCP0106 전용이며 TVF 본문 전체가 주석처리돼 있다(03 §2.2).
 */

/** 기간 컬럼인가 — 월/연 접두 2종. */
export const isPeriodColumn = (columnName: string): boolean =>
  columnName.startsWith(PERIOD_PREFIX.MONTH) || columnName.startsWith(PERIOD_PREFIX.YEAR);

/**
 * `p_from_yyyymm` — 선택한 Plan Month(`VER_ID`, yyyyMM) **+1개월**(AS-IS `_from_yyyymm` cs:291~312).
 *
 * AS-IS 는 파싱 실패를 빈 `catch` 로 삼켜 `_version` 기본값 `"-"` 를 그대로 SP 로 보낸다 —
 * TVF 의 `CONVERT(INT, SUBSTRING("-",1,4))` 가 변환오류를 낸다(03 §2.1). 빈 catch 를 이식하지 않고
 * **6자리 숫자 가드**로 빈 문자열을 돌려 호출부가 헤더 조회 자체를 건너뛰게 한다(03 V-16).
 */
export const toFromYyyymm = (verId: string): string => {
  if (!/^\d{6}$/.test(verId)) return '';
  return dayjs(`${verId}01`, 'YYYYMMDD').add(1, 'month').format('YYYYMM');
};

/**
 * 헤더 조회 payload.
 * `p_sheet_name` 은 **`'MAIN'` 리터럴**이다 — `sheetName`(CURRENT/CUTOFF)을 넘기면 lookup 매칭이
 * 0행이 되어 1단 라벨이 사라진다(`SCM_ADM_LOOKUP_MASTER_DETAIL` 실측: `SCP_CAPA_RPT_CODE` 에
 * `SCP0108/MAIN/ETC` 1행만 존재, 2026-09-25 / 03 §2.2 / V-12).
 * 같은 SP 를 5개 화면이 공유하므로 `programId + sheetName + fromYyyymm` 3요소가 전부 filters 에
 * 실려야 캐시 키(`[tabId, sheetName, action, {...filters}]`)로 화면 간 오염이 차단된다(hook #115 / V-13).
 *
 * **키는 camelCase 다** — `SCM_ADM_PROC_M.COL_NM` 이 이 키와 정확히 일치해야 바인딩된다(불일치는
 * 에러 없이 NULL 바인딩, 메모리 `generic-callproc-param-key-must-match-proc-m-colnm`). SCP 도메인
 * 등록 실측이 camelCase 다(`ora.py` 2026-09-25: `PKG_SCP0100.P_SCP0100_GET_GLOBAL_PSI_REPORT` /
 * `..._GET_PLAN_DATE` = `divisionId`·`programId`·`bucket`, cursor 는 `o_rc1`).
 * 주의(미해소 — 화면 경계 밖): 같은 공용 proc 을 쓰는 자매 `capa-speed-plan`/`capa-loss-plan` 은
 * snake(`p_from_yyyymm`)로 보낸다. `PKG_SCP0104` 미배포 + `PROC_M` 0행이라 아직 어느 쪽도 깨지지
 * 않았지만, 배포 시 `COL_NM` 은 한 벌뿐이므로 한쪽은 NULL 바인딩된다 — `convert-sp` 가
 * `all_arguments` 실측으로 확정할 사항이며 자매 화면 수정은 Hard Boundary 밖이다(iter-1 G-07).
 */
export const buildSpreadTitleFilters = (fromYyyymm: string): SpreadTitleFilters => ({
  fromYyyymm,
  programId: MENU_ID,
  sheetName: HEADER_LOOKUP_SHEET_NAME,
});

/**
 * `SORT_ORDER_NO` 는 `'012025110101'` 처럼 12자리 고정폭 문자열이라 **문자열 정렬이 곧 표시 순서**다
 * (연 컬럼 `012028…` 이 월 컬럼 `012027…` 뒤로 자연 정렬된다). 날짜 파싱 정렬로 바꾸지 않는다(03 V-15).
 */
const sortBySortOrder = (rows: readonly SpreadTitleRow[]): SpreadTitleRow[] =>
  [...rows].sort((a, b) =>
    String(a.SORT_ORDER_NO ?? '').localeCompare(String(b.SORT_ORDER_NO ?? ''))
  );

/** 기간 컬럼명 목록 — Bottleneck 병합·엑셀 등에서 "그리드가 가진 기간 축"의 단일 출처. */
export const toPeriodColumnNames = (rows: readonly SpreadTitleRow[] | undefined): string[] =>
  sortBySortOrder(rows ?? [])
    .map(row => row.COLUMN_NAME)
    .filter(name => !!name && isPeriodColumn(name));

/**
 * 3단 동적 컬럼 그룹 — 1단 `LARGE_CLASS_LABEL_NAME`(`Operation Plan`) > 2단
 * `SMALL_CLASS_LABEL_NAME`(연도) > 3단 `COLUMN_LABEL_NAME`(`2025-11` / `2028`).
 *
 * 숫자 축이라 `align:'right'` 다 — 메타 `HORIZONTAL_ALIGN_CODE`('L')는 정적 컬럼용이고 기간컬럼에는
 * 행이 없다(03 §1.0 / V-08). 포맷은 `n1`(소수 1자리 + 천단위, 03 R-08).
 *
 * 주의: 컬럼 정의에 `height` 를 넣지 않는다 — wijmo 가 각 헤더 row 에 명시 height 를 박아 3단 전체가
 * 1단 높이로 벌어진다. 높이는 DataGrid `headerRowHeight` prop 단일 출처다(hook #93 / V-19).
 */
export const buildPeriodColumns = (
  rows: readonly SpreadTitleRow[] | undefined,
  columnWidth = PERIOD_COLUMN_WIDTH
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
      header: String(row.COLUMN_LABEL_NAME ?? row.COLUMN_NAME),
      align: 'right',
      format: PERIOD_NUMBER_FORMAT,
      width: columnWidth,
      allowDragging: false,
      // 수치가 세로로 묶이면 안 된다. 병합은 좌측 고정영역 전용이다(03 R-13).
      allowMerging: false,
      allowResizing: true,
      // 정렬·필터·숨김은 기간컬럼에서도 동작해야 한다(03 V-38 — 공통 QA "우측 동적영역 포함").
      allowSorting: true,
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
