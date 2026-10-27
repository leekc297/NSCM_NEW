import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';

import type { BUCKET_TYPE } from '../production-plan-line.constants';
import { FIXED_COLUMNS, type FixedColumnMeta } from '../production-plan-line.constants';

import { isoWeek } from './productionPlanLineDerive';
import {
  type DrilldownState,
  EMPTY_DRILLDOWN,
  isPivotVisibleWithDrilldown,
} from './productionPlanLineDrilldown';
import {
  isFixedColumnVisible,
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
//   1단 = 월(yyyy-MM) / 2단 = 주(Wxx, ISO) / 3단(leaf) = 일(MMDD, Daily) 또는 'SUM'(Weekly). AS-IS 3단
//   헤더(월/주/SUM, design 03 §2.3)와 동일하게 Weekly 전월을 균일한 3단으로 맞춘다. Monthly 는 월>SUM 2단.
//   조회 결과가 비면 [] — 그리드는 고정 컬럼만 렌더(버튼 메타 3행 배선됨, design 03 §6).
export const buildPivotColumns = (
  rows: Record<string, unknown>[],
  bucket: BUCKET_TYPE,
  chkSum: boolean,
  drilldown: DrilldownState = EMPTY_DRILLDOWN
): FlexGridColumnConfig[] => {
  if (rows.length === 0) return [];
  // 가시 pivot 바인딩 union 추출 — bucket 기본 가시성 + 드릴다운 오버라이드(월→주→일 전개분 포함).
  const bindings = new Set<string>();
  for (const r of rows) {
    for (const k of Object.keys(r)) {
      if (isPivotVisibleWithDrilldown(k, bucket, chkSum, drilldown)) bindings.add(k);
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
    // 주 라벨: W_ 는 바인딩에 박힌 ISO_WEEK 를 그대로 쓴다(W_ 컬럼명 = 'W_'||BASIS_YYYYMM||ISO_WEEK,
    //   PKG_SCP0013 실측). tag.slice(6)=ISO_WEEK. 과거 isoWeek(tag) 는 tag(yyyymm+주차)를 날짜로 파싱해
    //   주차(33~36 등)를 '일'로 오인→월말 롤오버로 한 달 전체가 같은 주차로 뭉쳤다(예: 8월 전주 W36).
    //   D_(일) 는 소속 주 계산이 필요하므로 isoWeek(yyyymmdd) 유지. M_ 는 'SUM'.
    const weekLabel =
      kind === 'M' ? 'SUM' : kind === 'W' ? `W${tag.slice(6)}` : `W${isoWeek(tag)}`;
    let week = month.weeks.get(weekLabel);
    if (!week) {
      week = { label: weekLabel, leaves: [] };
      month.weeks.set(weekLabel, week);
    }
    // leaf(3단) 헤더: D_ 는 DD(일자만 — 월은 상단 tier 'YYYY-MM', AS-IS 일별 헤더와 동일), W_·M_ 는
    //   'SUM'(AS-IS 3단 = SUM). W_ leaf 를 주라벨로 두면 단일주 월이 isSingleTier 로 접혀 월마다 헤더
    //   단수가 달라진다 — 'SUM' 고정으로 Weekly 전월 3단 균일화.
    const leafHeader = kind === 'D' ? tag.slice(6, 8) : 'SUM';
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
      // QTY measure 는 0 이상 정수(format 'n0') — 음수·소수 입력 차단(positiveOnly/integerOnly)은 Wijmo Column 에
      //   직접 실으면 안 된다: 다단(그룹) 헤더의 ColumnGroup 파싱이 "Unknown property" 로 assert 크래시한다
      //   (Daily 등 동적 컬럼이 그룹으로 생성될 때 화면 깨짐). 대신 ProductionPlanLineGrid 가 DataGrid 의
      //   numberRules prop(binding 키)으로 전달해 resolveNumberRule 이 소비한다. AS-IS 음수저장 거부(MSG00084)·
      //   W_ 음수 일합계원복은 저장측 검증(useProductionPlanLineValidation) 백스톱으로 유지.
      // pivot 셀 baseline readOnly — 편집가능 셀은 그리드 beginningEdit 가 명시 해제.
      _inputEditType: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
      _dynamic: true,
    });
  }

  return [...months.values()].map<FlexGridColumnConfig>(month => {
    const weekGroups = [...month.weeks.values()];
    // 월 아래 주가 'SUM' 1개뿐이면(= Monthly: M_ 만, 또는 월합계 전용) 월>SUM 2단으로 접는다. Weekly 는 leaf
    //   가 'SUM'(≠ 주라벨 'Wxx')이라 이 조건이 성립하지 않아 접히지 않는다 → 전월 3단 균일(AS-IS 패리티).
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
