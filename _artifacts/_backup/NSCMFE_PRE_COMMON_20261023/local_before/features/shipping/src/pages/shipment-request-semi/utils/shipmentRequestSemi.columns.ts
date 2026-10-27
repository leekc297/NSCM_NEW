// SSP0045 동적 기간칼럼 구성 — 3단 헤더 / Bucket×Sum 가시성 매트릭스 / 드릴다운 / BOH SUM 치환.
//   설계 근거: design 03 §2.1~§2.6, §3.1 R01~R07, §3.2 R16.
//   공급원 이원화: 헤더·순서 = CALENDAR SP(3SPAN), 값 = GET SP 의 동적 PIVOT alias.

import type { FlexGridColumnConfig } from '@foundation/models';

import {
  BOH_MEASURES,
  BUCKET_TYPE,
  COLUMN,
  PIVOT_COLUMN_WIDTH,
  PIVOT_PREFIX,
} from '../shipment-request-semi.constants';
import type { CalendarSpanRow } from '../shipment-request-semi.types';

import { isPivotBinding } from './shipmentRequestSemi.editLock';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

export type PivotKind = 'M' | 'W' | 'D';

/** 동적 기간칼럼 1개의 메타 (CALENDAR SP 반환 1행). */
export interface PivotCol {
  binding: string;
  kind: PivotKind;
  large: string; // 1단 = 월 라벨
  small: string; // 2단 = 주 라벨
  leaf: string; // 3단 = 일자 라벨
  dayCode: string; // 'SAT' / 'SUN'
  sort: number;
}

export const pivotKindOf = (binding: string): PivotKind | null => {
  if (binding.startsWith(PIVOT_PREFIX.MONTH)) return 'M';
  if (binding.startsWith(PIVOT_PREFIX.WEEK)) return 'W';
  if (binding.startsWith(PIVOT_PREFIX.DAY)) return 'D';
  return null;
};

/**
 * CALENDAR SP 반환행 → PivotCol[]. 정렬은 SP 의 `SORT_ORDER_NO`(M_ 01 < W_ 21 < D_ 31)를 그대로 쓴다.
 *   이 순서가 곧 "월/주 SUM 이 해당 일자들보다 좌측" 배치이며(design 03 §2.3), 드릴다운(R06)·BOH 치환(R16)의 전제다.
 *   금지: FE 재정렬. SUM 을 우측으로 옮기면 세 규칙이 전부 깨진다.
 */
export const toPivotCols = (rows: readonly CalendarSpanRow[] | undefined): PivotCol[] =>
  (rows ?? [])
    .map(r => {
      const binding = str(r.COLUMN_NAME);
      return {
        binding,
        kind: pivotKindOf(binding),
        large: str(r.LARGE_CLASS_LABEL_NAME),
        small: str(r.SMALL_CLASS_LABEL_NAME),
        leaf: str(r.COLUMN_LABEL_NAME),
        dayCode: str(r.DAY_CODE).toUpperCase(),
        sort: Number(r.SORT_ORDER_NO ?? 0),
      };
    })
    .filter((c): c is PivotCol => c.kind !== null)
    .sort((a, b) => a.sort - b.sort || a.binding.localeCompare(b.binding));

/** 같은 월 그룹 안에서의 표시 순위 — `M_` SUM → `W_` SUM → `D_` 일자(= SP 의 SORT_ORDER_NO 01/21/31 계약). */
const KIND_RANK: Record<PivotKind, number> = { M: 0, W: 1, D: 2 };

/**
 * CALENDAR 0건 폴백 — 조회 결과 행의 키 union 에서 기간칼럼만 뽑는다(mkt-fcst/global-psi-report 폴백 규약).
 *   라벨 원천이 없어 월 스팬만 접두 파싱으로 근사한다. CALENDAR SP 배포 후에는 이 경로를 타지 않는다.
 *
 *   필수: 정렬은 `toPivotCols`(SORT_ORDER_NO 경로)와 **같은 순서 계약**을 지켜야 한다 —
 *   월(`binding.slice(2,8)`) 오름차순 → 같은 달 안에서 `M_` → `W_` → `D_` → binding 오름차순.
 *   금지: 기본 `sort()`(사전순). 'D_'(0x44) < 'M_'(0x4D) < 'W_'(0x57) 이라 모든 SUM 이 일자 **우측**으로
 *   밀려 (a) design 03 §2.3 "월·주 SUM 이 해당 일자보다 좌측" 위반 (b) `applyBohSumValues` 가
 *   "SUM 뒤의 첫 D_" 를 못 찾아 R16/K14 가 조용히 무동작 (c) `buildDrilldownPatch` 의 인접 전제 붕괴 —
 *   세 결함이 한꺼번에 난다(react-gap-audit iter-1 G-25).
 */
export const pivotColsFromRows = (
  rows: readonly Record<string, unknown>[] | undefined
): PivotCol[] => {
  const set = new Set<string>();
  for (const r of rows ?? []) {
    for (const k of Object.keys(r)) if (isPivotBinding(k)) set.add(k);
  }
  return [...set]
    .map(binding => ({
      binding,
      kind: pivotKindOf(binding) as PivotKind,
      large: `${binding.slice(2, 6)}-${binding.slice(6, 8)}`,
      small: '',
      leaf: binding.slice(2),
      dayCode: '',
      sort: 0,
    }))
    .sort(
      (a, b) =>
        a.binding.slice(2, 8).localeCompare(b.binding.slice(2, 8)) ||
        KIND_RANK[a.kind] - KIND_RANK[b.kind] ||
        a.binding.localeCompare(b.binding)
    );
};

/**
 * 기간칼럼 원천 판정 **1벌** — CALENDAR SP 우선, 변환 결과가 0건이면 조회행 키 union 폴백.
 *
 *   필수: 판정식을 `toPivotCols(...)` 의 **변환 후 개수**로 둔다. `calendarRows.length` 로 재면
 *   CALENDAR SP 가 `M_`/`W_`/`D_` 접두가 아닌 `COLUMN_NAME` 을 돌려줄 때(= `toPivotCols` 가
 *   `kind !== null` 로 전건 탈락시킬 때) 호출부마다 결과가 갈린다 — 한쪽은 빈 배열을 받아
 *   `applyBohSumValues`(R16/K14)가 조용히 무동작하고, 다른 쪽은 폴백으로 컬럼을 그려
 *   화면만 정상으로 보인다(react-gap-audit iter-3 N-09).
 *   금지: 호출부에서 이 식을 다시 쓰는 것. 페이지가 한 번 계산해 그리드에 내린다(K2 "판정 1벌").
 */
export const resolvePivotCols = (
  calendarRows: readonly CalendarSpanRow[] | undefined,
  rows: readonly Record<string, unknown>[] | undefined
): PivotCol[] => {
  const fromSp = toPivotCols(calendarRows);
  return fromSp.length > 0 ? fromSp : pivotColsFromRows(rows);
};

/**
 * Bucket × Sum 2축 가시성 매트릭스 — **1벌**(design 03 §2.5 R07 / G12).
 *   AS-IS E03(Bucket 변경)·E09(Sum 체크)가 같은 `SetSpreadColumn` 을 부르므로 조건 분기를 2벌로 나누지 않는다.
 *
 *   Daily   : D_ 표시 / W_·M_ = Sum 체크  (S38 의 `W_=true` 는 S39 가 덮어쓴다 — 최종값은 chkSum)
 *   Weekly  : D_ 숨김 / W_ 표시 / M_ = Sum 체크
 *   Monthly : D_·W_ 숨김 / M_ 표시
 *
 *   미재현 1건(U3): AS-IS Monthly 의 `else` 분기는 판정 범위가 `MEASURE+1` 부터라 hidden 메타컬럼
 *   (`BOD_FROM/TO_YYYYMMDD`)까지 `Visible=true` 로 켠다. 이 결함은 재현하지 않고 `VISIBLE_FLAG='N'` 을 존중한다.
 */
export const isPivotVisible = (kind: PivotKind, bucket: BUCKET_TYPE, showSum: boolean): boolean => {
  if (bucket === BUCKET_TYPE.MONTHLY) return kind === 'M';
  if (bucket === BUCKET_TYPE.WEEKLY) {
    if (kind === 'D') return false;
    if (kind === 'W') return true;
    return showSum; // M_
  }
  // DAILY
  if (kind === 'D') return true;
  return showSum; // M_ / W_
};

/**
 * 헤더 더블클릭 드릴다운 (design 03 §2.6 R06 / S15) — 컬럼 add/remove 없이 표시 rank 만 바꾼다(hook #103).
 *   · 월 SUM(M_) 더블클릭 : 그 달 범위의 W_ 는 토글, D_ 는 **숨김만**(단방향 접기).
 *   · 주 SUM(W_) 더블클릭 : 그 주 범위의 D_ 토글.
 *   범위 종료 조건은 AS-IS 와 동일하게 "다음 M_(월 클릭) / 다음 M_ 또는 W_(주 클릭)".
 *   반환 = binding → visible 오버라이드 패치. Bucket/Sum 재계산 시 호출부가 전체 초기화한다(버킷 변경 > 드릴다운).
 */
export const buildDrilldownPatch = (
  cols: readonly PivotCol[],
  clickedBinding: string,
  currentVisible: (binding: string) => boolean
): Map<string, boolean> => {
  const patch = new Map<string, boolean>();
  const startIndex = cols.findIndex(c => c.binding === clickedBinding);
  if (startIndex < 0) return patch;
  const clicked = cols[startIndex];
  if (clicked.kind === 'D') return patch; // 일자 헤더는 드릴다운 대상이 아니다

  // 토글 방향은 범위 내 첫 대상의 현재 상태에서 한 번만 정한다(대상마다 뒤집히지 않게).
  let toggleTo: boolean | null = null;
  for (let i = startIndex + 1; i < cols.length; i += 1) {
    const c = cols[i];
    if (c.kind === 'M') break;
    if (clicked.kind === 'W' && c.kind === 'W') break;

    if (clicked.kind === 'M') {
      if (c.kind === 'W') {
        toggleTo ??= !currentVisible(c.binding);
        patch.set(c.binding, toggleTo);
      } else if (currentVisible(c.binding)) {
        patch.set(c.binding, false); // 월 SUM 은 D_ 를 접기만 한다(비대칭 — AS-IS 의도된 드릴다운)
      }
      continue;
    }
    // clicked.kind === 'W'
    if (c.kind === 'D') {
      toggleTo ??= !currentVisible(c.binding);
      patch.set(c.binding, toggleTo);
    }
  }
  return patch;
};

/**
 * 3단 헤더(월 > 주 > 일) 그룹 컬럼 생성 (design 03 §2.4 / R02).
 *   · 1단 = 월 라벨(LARGE_CLASS_LABEL_NAME)
 *   · 2단 = 주 라벨(SMALL_CLASS_LABEL_NAME). 월 SUM(M_)은 자기 'SUM' 그룹으로 분리.
 *   · 3단(leaf) = 일자 라벨. SUM 컬럼(M_/W_)의 leaf 라벨은 'SUM'.
 *   `<FlexGridColumnGroup>` 단일 child 는 React 19 에서 크래시하므로 빈 그룹은 만들지 않는다(convert-core §2.4).
 *   SUM/일자 전부 편집 게이트는 그리드의 `beginningEdit` 가 담당한다 — 여기서 isReadOnly 를 박지 않는다.
 */
export const buildPivotColumns = (
  cols: readonly PivotCol[],
  isVisible: (binding: string) => boolean
): FlexGridColumnConfig[] => {
  const visibleCols = cols.filter(c => isVisible(c.binding));
  if (visibleCols.length === 0) return [];

  const leafOf = (c: PivotCol): FlexGridColumnConfig => ({
    header: c.kind === 'D' ? c.leaf || c.binding.slice(2) : 'SUM',
    binding: c.binding,
    align: 'right',
    format: 'n0', // DATA_SCALE_NUMBER 전건 NULL → 정수 표시(design 03 §5.1 V-C5)
    width: PIVOT_COLUMN_WIDTH,
    allowMerging: false,
    allowSorting: false,
    allowResizing: true,
    // admin 속성 덮어쓰기가 아니다 — 동적 기간칼럼은 `SCM_MST_SHEET_COLUMNS` 에 **행 자체가 없다**
    //   (SP05 구동, 조회 기간마다 컬럼셋이 바뀐다). 덮을 메타값이 없으므로 CLAUDE.md §2 체크4
    //   ("VISIBLE_FLAG 등 admin 관리 속성 리터럴 덮어쓰기 금지") 대상이 아니다.
    //   실제 가시성은 이 함수 진입부의 `isVisible`(Bucket×Sum 매트릭스 + 드릴다운)이 결정한다.
    visible: true,
    _dynamic: true,
  });

  const groups: FlexGridColumnConfig[] = [];
  let largeKey: string | null = null;
  let smallKey: string | null = null;
  let largeGroup: FlexGridColumnConfig | null = null;
  let smallGroup: FlexGridColumnConfig | null = null;

  for (const c of visibleCols) {
    const ym = c.binding.slice(2, 8);
    if (largeGroup === null || ym !== largeKey) {
      largeKey = ym;
      smallKey = null;
      smallGroup = null;
      largeGroup = { header: c.large || ym, align: 'center', columns: [] };
      groups.push(largeGroup);
    }
    // 월 SUM 은 주 그룹에 속하지 않는다 — 'SUM' 전용 2단 그룹으로 분리(AS-IS 1단 월SUM 스팬 = S06).
    const sub = c.kind === 'M' ? 'SUM' : c.small || 'SUM';
    if (smallGroup === null || sub !== smallKey) {
      smallKey = sub;
      smallGroup = { header: sub, align: 'center', columns: [] };
      largeGroup.columns?.push(smallGroup);
    }
    smallGroup.columns?.push(leafOf(c));
  }
  return groups;
};

/**
 * BOH SUM 값 클라 치환 (design 03 §3.2 R16 / G09 — K14).
 *   measure ∈ {WH_BOH_PLAN, WH_BOH_REQ} 행에 한해, `M_`/`W_` 칸에 **합계가 아니라 뒤따르는 첫 `D_` 값**
 *   (기초재고)을 복사한다. 누락하면 BOH 행의 SUM 이 "합계"로 잘못 보인다.
 *   조회 응답 후처리이며 행 객체를 제자리 변환한다(itemsSource 참조를 유지해야 CollectionView 가 재생성되지 않는다).
 */
export const applyBohSumValues = (
  rows: readonly Record<string, unknown>[] | undefined,
  cols: readonly PivotCol[]
): void => {
  if (!rows || rows.length === 0 || cols.length === 0) return;
  // 각 SUM 컬럼에 대해 "자기 뒤에 처음 나오는 D_ 컬럼" 을 미리 구해 둔다(좌→우 스캔 1회).
  const firstDayAfter = new Map<string, string>();
  for (let i = 0; i < cols.length; i += 1) {
    if (cols[i].kind === 'D') continue;
    for (let j = i + 1; j < cols.length; j += 1) {
      if (cols[j].kind === 'D') {
        firstDayAfter.set(cols[i].binding, cols[j].binding);
        break;
      }
    }
  }
  if (firstDayAfter.size === 0) return;
  for (const row of rows) {
    if (!BOH_MEASURES.includes(str(row[COLUMN.MEASURE]))) continue;
    firstDayAfter.forEach((dayBinding, sumBinding) => {
      row[sumBinding] = row[dayBinding] ?? null;
    });
  }
};
