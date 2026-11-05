import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';

import type { BUCKET_TYPE, FixedColumnMeta } from '../production-plan.constants';

import { isoWeek, weekNoOf } from './productionPlanDerive';
import {
  type DrilldownState,
  EMPTY_DRILLDOWN,
  isPivotVisibleWithDrilldown,
} from './productionPlanDrilldown';
import { isFixedColumnVisible, pivotKind } from './productionPlanEditLock';

const fallbackToRaw = (c: FixedColumnMeta): RawFlexGridColumnConfig => ({
  colNm: c.key,
  colLblNm: c.header,
  horzAlgnCd: c.align ?? 'C',
  colWth: c.width ?? 100,
  fixed: c.fixed === true,
  visible: c.visible !== false,
  display: true,
  // 고정 컬럼 전건 표시전용(INPUT_TP_CD='S') — 편집은 pivot 셀만.
  inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
});

// 고정 컬럼 빌드 — admin(SCM_MST_SHEET_COLUMNS 'Model'/'Line') 등록본 우선, 없으면 constants fallback.
//   EE 전용 컬럼(eeOnly: ORIGIN_DIVISION_ID/ELECTRODE_TYPE)은 EE 사업부에서만 표시(design 03 §3 R2).
//   admin 경로는 eeOnly 메타가 없으므로 fallback 맵에서 eeOnly 키 집합을 넘겨 런타임 가시성 override.
export const buildFixedColumns = (
  adminCols: RawFlexGridColumnConfig[] | undefined,
  fallback: FixedColumnMeta[],
  division: string
): RawFlexGridColumnConfig[] => {
  const eeOnlyKeys = new Set(fallback.filter(c => c.eeOnly).map(c => c.key));
  const base: RawFlexGridColumnConfig[] =
    adminCols && adminCols.length > 0 ? adminCols : fallback.map(fallbackToRaw);
  return base.map(c => ({
    ...c,
    visible: c.visible !== false && isFixedColumnVisible(eeOnlyKeys.has(c.colNm), division),
  }));
};

// 동적 pivot 컬럼 빌드 — GET 결과 행 키(D_/W_/M_)에서 bucket×chkSum 가시분만 추출해 3단 헤더로 구성.
//   1단=월(yyyy-MM) / 2단=주(Wxx) / 3단(leaf)=일(DD, Daily) 또는 'SUM'(Weekly). AS-IS 3단 헤더(design 03 §2.2).
export const buildPivotColumns = (
  rows: Record<string, unknown>[],
  bucket: BUCKET_TYPE,
  chkSum: boolean,
  drilldown: DrilldownState = EMPTY_DRILLDOWN
): FlexGridColumnConfig[] => {
  if (rows.length === 0) return [];
  const bindings = new Set<string>();
  for (const r of rows) {
    for (const k of Object.keys(r)) {
      if (isPivotVisibleWithDrilldown(k, bucket, chkSum, drilldown)) bindings.add(k);
    }
  }
  if (bindings.size === 0) return [];
  const sorted = [...bindings].sort();

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
    // 주 라벨: W_ 는 바인딩 ISO_WEEK(tag.slice(6)), D_ 는 소속 주 계산, M_ 는 'SUM'.
    const weekLabel =
      kind === 'M' ? 'SUM' : kind === 'W' ? `W${tag.slice(6)}` : `W${isoWeek(tag)}`;
    // 묶음 키는 주차 숫자 — W_ 라벨('W05')과 D_ 계산 라벨('W5')이 달라도 같은 주로 묶는다.
    const weekKey = kind === 'M' ? 'SUM' : kind === 'W' ? `W${weekNoOf(binding)}` : weekLabel;
    let week = month.weeks.get(weekKey);
    if (!week) {
      week = { label: weekLabel, leaves: [] };
      month.weeks.set(weekKey, week);
    }
    if (kind === 'W') week.label = weekLabel;
    const leafHeader = kind === 'D' ? tag.slice(6, 8) : 'SUM';
    // SUM 은 묶음 왼쪽 — AS-IS 는 주 SUM 이 그 주 일자 앞(사용자 확인 2026-10-13). 월 SUM 은 아래에서 맨 앞으로.
    // week.leaves.push({
    week.leaves[kind === 'W' ? 'unshift' : 'push']({
      binding,
      header: leafHeader,
      align: 'right',
      format: 'n0',
      width: 70,
      allowMerging: false,
      allowSorting: false,
      allowResizing: true,
      visible: true,
      _inputEditType: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
      _dynamic: true,
    });
  }

  return [...months.values()].map<FlexGridColumnConfig>(month => {
    // const weekGroups = [...month.weeks.values()];
    // 월 SUM(M_) 묶음을 그 달 맨 앞에 둔다(AS-IS 월 SUM 왼쪽).
    const monthSum = month.weeks.get('SUM');
    const weekGroups = [
      ...(monthSum ? [monthSum] : []),
      ...[...month.weeks.entries()].filter(([k]) => k !== 'SUM').map(([, w]) => w),
    ];
    const allLeaves = weekGroups.flatMap(w => w.leaves);
    const isSingleTier =
      weekGroups.length === 1 &&
      weekGroups[0].leaves.length === allLeaves.length &&
      weekGroups[0].leaves.every(l => l.header === weekGroups[0].label);
    if (isSingleTier) return { header: month.label, align: 'center', columns: allLeaves };
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
