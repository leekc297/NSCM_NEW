import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';

import type { BUCKET_TYPE } from '../production-plan-line.constants';
import { FIXED_COLUMNS, type FixedColumnMeta } from '../production-plan-line.constants';

import { isoWeek } from './productionPlanLineDerive';
import {
  isFixedColumnVisible,
  isPivotVisible,
  pivotKind,
  type VisibilityContext,
} from './productionPlanLineEditLock';

const fallbackToRaw = (c: FixedColumnMeta): RawFlexGridColumnConfig => ({
  colNm: c.key,
  colLblNm: c.header,
  horzAlgnCd: c.align ?? 'C',
  colWth: c.width ?? 100,
  fixed: c.fixed === true,
  visible: c.visible !== false,
  display: true,
  // 고정 컬럼은 전건 표시전용(INPUT_TP_CD='S') — 편집은 pivot 셀만.
  inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
});

// 고정 컬럼 빌드 — admin(SCM_MST_SHEET_COLUMNS 'Line') 등록본 우선, 없으면 constants fallback.
//   두 경로 모두 div/opGroup 조건 가시성(design 03 §1 VISIBLE)을 런타임 override 로 적용한다.
export const buildFixedColumns = (
  adminCols: RawFlexGridColumnConfig[] | undefined,
  ctx: VisibilityContext
): RawFlexGridColumnConfig[] => {
  const base: RawFlexGridColumnConfig[] =
    adminCols && adminCols.length > 0 ? adminCols : FIXED_COLUMNS.map(fallbackToRaw);
  return base.map(c => ({
    ...c,
    // 기본 가시성(admin VISIBLE_FLAG 또는 fallback visible) AND 조건 가시성.
    visible: c.visible !== false && isFixedColumnVisible(c.colNm, ctx),
  }));
};

// 동적 pivot 컬럼 빌드 — GET 결과 행 키(D_/W_/M_)에서 bucket×chkSum 가시분만 추출해 3단 헤더로 구성.
//   1단 = 월(yyyy-MM) / 2단 = 주(Wxx, ISO) / 3단(leaf) = 일(MMDD). Monthly 는 1단(월)만, Weekly 는 2단(월>주).
//   조회 결과가 비면 [] — 그리드는 고정 컬럼만 렌더(버튼 메타 3행 배선됨, design 03 §6).
export const buildPivotColumns = (
  rows: Record<string, unknown>[],
  bucket: BUCKET_TYPE,
  chkSum: boolean
): FlexGridColumnConfig[] => {
  if (rows.length === 0) return [];
  // 가시 pivot 바인딩 union 추출.
  const bindings = new Set<string>();
  for (const r of rows) {
    for (const k of Object.keys(r)) {
      if (isPivotVisible(k, bucket, chkSum)) bindings.add(k);
    }
  }
  if (bindings.size === 0) return [];
  const sorted = [...bindings].sort();

  // 월(yyyymm) → 주(Wxx) → 일 leaf 계층 구성.
  type WeekGroup = { label: string; leaves: FlexGridColumnConfig[] };
  type MonthGroup = { label: string; weeks: Map<string, WeekGroup> };
  const months = new Map<string, MonthGroup>();

  for (const binding of sorted) {
    const kind = pivotKind(binding);
    if (kind === null || kind === 'B') continue;
    const tag = binding.slice(2);
    const ym = tag.slice(0, 6);
    const monthLabel = `${ym.slice(0, 4)}-${ym.slice(4, 6)}`;
    let month = months.get(ym);
    if (!month) {
      month = { label: monthLabel, weeks: new Map() };
      months.set(ym, month);
    }
    // 주 라벨: D_ 는 소속 주(ISO), W_ 는 자신, M_ 는 'SUM'.
    const weekLabel =
      kind === 'M' ? 'SUM' : kind === 'W' ? `W${isoWeek(tag)}` : `W${isoWeek(tag)}`;
    let week = month.weeks.get(weekLabel);
    if (!week) {
      week = { label: weekLabel, leaves: [] };
      month.weeks.set(weekLabel, week);
    }
    // leaf 헤더: D_ 는 MMDD, W_/M_ 는 SUM/주 라벨.
    const leafHeader = kind === 'D' ? tag.slice(4, 8) : kind === 'W' ? weekLabel : 'SUM';
    week.leaves.push({
      binding,
      header: leafHeader,
      align: 'right',
      format: 'n0',
      width: 70,
      allowMerging: false,
      allowSorting: false,
      allowResizing: true,
      visible: true,
      // pivot 셀 baseline readOnly — 편집가능 셀은 그리드 beginningEdit 가 명시 해제.
      _inputEditType: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
      _dynamic: true,
    });
  }

  return [...months.values()].map<FlexGridColumnConfig>(month => {
    const weekGroups = [...month.weeks.values()];
    // 월 아래 주가 1개(SUM 만)이고 leaf 도 그 주면 2단으로 접는다(Monthly/Weekly).
    const allLeaves = weekGroups.flatMap(w => w.leaves);
    const isSingleTier = weekGroups.length === 1 && weekGroups[0].leaves.length === allLeaves.length &&
      weekGroups[0].leaves.every(l => l.header === weekGroups[0].label);
    if (isSingleTier) {
      return { header: month.label, align: 'center', columns: allLeaves };
    }
    return {
      header: month.label,
      align: 'center',
      columns: weekGroups.map<FlexGridColumnConfig>(w => ({
        header: w.label,
        align: 'center',
        columns: w.leaves,
      })),
    };
  });
};
