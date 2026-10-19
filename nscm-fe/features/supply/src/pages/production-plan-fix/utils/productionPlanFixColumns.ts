import dayjs from 'dayjs';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';

import type { BUCKET_TYPE } from '../production-plan-fix.constants';
import { FIXED_COLUMNS, type FixedColumnMeta } from '../production-plan-fix.constants';

import { isoWeek } from './productionPlanFixDerive';
import {
  isFixedColumnVisible,
  isPivotVisible,
  pivotKind,
  type VisibilityContext,
} from './productionPlanFixEditLock';

const fallbackToRaw = (c: FixedColumnMeta): RawFlexGridColumnConfig => ({
  colNm: c.key,
  colLblNm: c.header,
  horzAlgnCd: c.align ?? 'C',
  colWth: c.width ?? 100,
  fixed: c.fixed === true,
  visible: c.visible !== false,
  display: true,
  // 고정 컬럼은 전건 표시전용(INPUT_TP_CD='S') — 편집은 D_ pivot 셀(Prod Plan 행)만.
  inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
});

// 고정 컬럼 빌드 — admin(SCM_MST_SHEET_COLUMNS 'Model') 등록본 우선, 없으면 constants fallback.
//   두 경로 모두 EE division 조건 가시성(design 03 §2.5)을 런타임 override 로 적용한다.
//   속성 리터럴(visible=true 등) 덮어쓰기 금지(CLAUDE.md §2-4) — admin visible AND 조건 가시성만 곱한다.
export const buildFixedColumns = (
  adminCols: RawFlexGridColumnConfig[] | undefined,
  ctx: VisibilityContext
): RawFlexGridColumnConfig[] => {
  const base: RawFlexGridColumnConfig[] =
    adminCols && adminCols.length > 0 ? adminCols : FIXED_COLUMNS.map(fallbackToRaw);
  return base.map(c => ({
    ...c,
    // 기본 가시성(admin VISIBLE_FLAG 또는 fallback visible) AND EE 조건 가시성.
    visible: c.visible !== false && isFixedColumnVisible(c.colNm, ctx),
  }));
};

// 주 라벨: D_ 는 날짜의 ISO 주, W_ 는 colId 뒤 2자리 ISO_WEEK 그대로, M_ 는 'SUM'(월 롤업).
//   주의: W_ 태그('BASIS_YYYYMM'+'ISO_WEEK', 예 20260937)는 날짜가 아니다 — isoWeek() 로 파싱하면
//   일자 롤오버(9월 37일 → 10월)로 주차가 틀어져 W_ SUM 컬럼이 엉뚱한 주 그룹에 붙는다
//   (gap-resolve iter-2 G24, SCM_SYS_CALENDAR_M ISO_WEEK 2자리 실측. Grid dailyKeysOfWeek 파싱과 동일식).
const weekLabelOf = (binding: string): string => {
  const kind = pivotKind(binding);
  const tag = binding.slice(2);
  if (kind === 'M') return 'SUM';
  if (kind === 'W') return `W${Number(tag.slice(6)) || Number(tag.slice(4, 6))}`;
  return `W${isoWeek(tag)}`;
};

// 헤더 병합 판정 키 — 월(yyyymm)과 주 라벨. M_(월 합계)의 sub 는 'SUM'.
export const pivotHeaderKey = (binding: string): { ym: string; sub: string } => ({
  ym: binding.slice(2, 8),
  sub: weekLabelOf(binding),
});

// 동적 pivot 컬럼 빌드 — 월(yyyy-MM) > [M_ SUM leaf, 주(Wxx, ISO) > [W_ SUM leaf, D_ 일(DD) leaf]] 3단 헤더.
//   AS-IS 는 bucket 과 무관하게 항상 3단이고 bucket 은 컬럼 가시성만 바꾼다(SetSpreadColumn cs:703-745).
//   그래서 D_/W_/M_ 전량으로 트리를 만들고 leaf visible 만 bucket×chkSum 으로 정한다.
//   조회 결과가 비면 [] — 그리드는 고정 컬럼만 렌더(design 03 §4.1 조회 전 빈 상태).
export const buildPivotColumns = (
  rows: Record<string, unknown>[],
  bucket: BUCKET_TYPE,
  chkSum: boolean,
  searchRange?: { fromYyyymmdd: string; toYyyymmdd: string }
): FlexGridColumnConfig[] => {
  if (rows.length === 0) return [];
  const bindings = new Set<string>();
  for (const r of rows) {
    for (const k of Object.keys(r)) {
      if (pivotKind(k) !== null) bindings.add(k);
    }
  }
  // GET SP 는 조회기간의 D_(일자) 컬럼을 캘린더 기준으로 항상 전량 생성하지만, 값이 NULL인 셀은
  //   서버 공용 매핑(BaseService#callProc2 "null 은 담지 않음")이 행 JSON에서 키 자체를 제거한다.
  //   자재 단건 등으로 필터링해 특정 일자 전건이 NULL(Unfix 로 삭제)이면 어느 행에도 그 키가 남지
  //   않아 Object.keys 합집합에서 컬럼이 통째로 빠진다(사용자 신고 2026-10-12 — Unfix 후 그 날짜
  //   컬럼이 사라지고 다음 유값 날짜로 그리드가 시작). D_ 바인딩은 날짜 문자열로 결정적이므로
  //   조회기간(searchRange)으로 보강해 데이터 유무와 무관하게 항상 렌더한다.
  if (searchRange) {
    let d = dayjs(searchRange.fromYyyymmdd, 'YYYYMMDD');
    const to = dayjs(searchRange.toYyyymmdd, 'YYYYMMDD');
    while (d.isValid() && to.isValid() && !d.isAfter(to)) {
      bindings.add(`D_${d.format('YYYYMMDD')}`);
      d = d.add(1, 'day');
    }
  }
  if (bindings.size === 0) return [];
  const sorted = [...bindings].sort();

  type MonthGroup = {
    label: string;
    monthSums: FlexGridColumnConfig[];
    weeks: Map<string, FlexGridColumnConfig[]>;
  };
  const months = new Map<string, MonthGroup>();

  for (const binding of sorted) {
    const kind = pivotKind(binding);
    if (kind === null) continue;
    const { ym } = pivotHeaderKey(binding);
    let month = months.get(ym);
    if (!month) {
      month = { label: `${ym.slice(0, 4)}-${ym.slice(4, 6)}`, monthSums: [], weeks: new Map() };
      months.set(ym, month);
    }
    const leaf: FlexGridColumnConfig = {
      binding,
      // leaf 헤더: D_ 는 일자 2자리(DD), W_/M_ 는 SUM.
      header: kind === 'D' ? binding.slice(8, 10) : 'SUM',
      align: 'right',
      format: 'n0',
      width: 70,
      allowMerging: false,
      allowSorting: false,
      allowResizing: true,
      visible: isPivotVisible(binding, bucket, chkSum),
      // pivot 셀 baseline readOnly — 편집가능 셀(D_×Prod Plan)은 그리드 beginningEdit 가 명시 해제.
      _inputEditType: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
      _dynamic: true,
    };
    if (kind === 'M') {
      month.monthSums.push(leaf);
      continue;
    }
    const weekLabel = weekLabelOf(binding);
    const leaves = month.weeks.get(weekLabel) ?? [];
    month.weeks.set(weekLabel, leaves);
    // 주 그룹 안에서는 W_ 합계가 일자(D_)보다 앞에 온다(AS-IS 정렬키 접미 21 < 31).
    if (kind === 'W') leaves.unshift(leaf);
    else leaves.push(leaf);
  }

  return [...months.entries()]
    .sort(([a], [b]) => a.localeCompare(b))
    .map<FlexGridColumnConfig>(([, month]) => ({
      header: month.label,
      align: 'center',
      allowMerging: false,
      columns: [
        ...month.monthSums,
        ...[...month.weeks.entries()].map<FlexGridColumnConfig>(([label, leaves]) => ({
          header: label,
          align: 'center',
          columns: leaves,
        })),
      ],
    }));
};
