import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';

import type { BUCKET_TYPE } from '../shipment-plan-fix.constants';
import { FIXED_COLUMNS, type FixedColumnMeta } from '../shipment-plan-fix.constants';

import { isoWeek } from './shipmentPlanFixDerive';
import {
  isFixedColumnVisible,
  isPivotVisible,
  pivotKind,
  type VisibilityContext,
} from './shipmentPlanFixVisibility';

const fallbackToRaw = (c: FixedColumnMeta): RawFlexGridColumnConfig => ({
  colNm: c.key,
  colLblNm: c.header,
  horzAlgnCd: c.align ?? 'C',
  colWth: c.width ?? 100,
  fixed: c.fixed === true,
  visible: c.visible !== false,
  display: true,
  // 전건 표시전용(INPUT_TP_CD='S') — SCP0025 는 read-only 조회 그리드(편집 없음, design 03 §3-보강).
  inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
});

// 고정 컬럼 빌드 — admin(SCM_MST_SHEET_COLUMNS 'Shipment Plan Fix' 20행) 등록본 우선, 없으면 constants fallback.
//   두 경로 모두 EE division 조건 가시성(design 03 §2.7)을 런타임 override 로 적용한다.
//   속성 리터럴(visible=true 등) 덮어쓰기 금지(CLAUDE.md §2-4) — admin visible AND EE 조건 가시성만 곱한다.
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

// 동적 pivot 컬럼 빌드 — GET 결과 행 키(D_/W_/M_)에서 bucket×chkSum 가시분만 추출해 3단 헤더로 구성.
//   1단 = 월(yyyy-MM) / 2단 = 주(Wxx, ISO) / 3단(leaf) = 일(MMDD). Monthly 는 1단(월)만, Weekly 는 2단(월>주).
//   조회 결과가 비면 [] — 그리드는 고정 컬럼만 렌더(design 03 §4.1 조회 전 빈 상태).
//   전건 read-only(SEARCH_ONLY) — Ship Plan 행은 number(n0), Fix Reason 행 셀은 텍스트값을 그대로 표시.
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
    if (kind === null) continue;
    const tag = binding.slice(2);
    const ym = tag.slice(0, 6);
    const monthLabel = `${ym.slice(0, 4)}-${ym.slice(4, 6)}`;
    let month = months.get(ym);
    if (!month) {
      month = { label: monthLabel, weeks: new Map() };
      months.set(ym, month);
    }
    // 주 라벨(design 03 §2.2 / GET SP L168 colId 규칙 실측):
    //   W_ colId = 'W_' || BASIS_YYYYMM(6) || ISO_WEEK(2) → 주 번호는 인코딩된 tag.slice(6,8)(=ISO_WEEK) 를 그대로 쓴다.
    //   D_ colId = 'D_' || BASIS_YYYYMMDD(8, 유효 날짜) → isoWeek(날짜) 로 소속 주 계산(그룹핑용).
    //   (react-gap-audit ④''' — 종전 W_ 도 isoWeek(tag) 에 넘겨 tag='YYYYMM+ISO_WEEK'(8자리)를 날짜로 오인,
    //    WEEKLY 헤더/DAILY+chkSum W_ 그룹 주번호가 어긋났다. 두 ISO 주번호는 동일 주에서 일치 → D_ 그룹핑 무영향.)
    const weekNum = kind === 'W' ? Number(tag.slice(6, 8)) : isoWeek(tag);
    const weekLabel = kind === 'M' ? 'SUM' : `W${weekNum}`;
    let week = month.weeks.get(weekLabel);
    if (!week) {
      week = { label: weekLabel, leaves: [] };
      month.weeks.set(weekLabel, week);
    }
    // leaf 헤더: D_ 는 MMDD, W_ 는 주 라벨, M_ 는 SUM.
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
      // 전건 read-only(design 03 §3 R-G LockColumn all).
      _inputEditType: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
      _dynamic: true,
    });
  }

  return [...months.values()].map<FlexGridColumnConfig>(month => {
    const weekGroups = [...month.weeks.values()];
    // 월 아래 주가 1개이고 leaf 라벨이 그 주 라벨과 같으면 2단으로 접는다(Monthly/Weekly).
    const allLeaves = weekGroups.flatMap(w => w.leaves);
    const isSingleTier =
      weekGroups.length === 1 &&
      weekGroups[0].leaves.length === allLeaves.length &&
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
