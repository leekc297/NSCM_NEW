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
    //   PKG_SCP0013 실측). tag.slice(6)=ISO_WEEK(2자리 zero-pad, DB WEEK_NAME='W01' 형식). 과거 isoWeek(tag) 는
    //   tag(yyyymm+주차)를 날짜로 파싱해 주차(33~36 등)를 '일'로 오인→월말 롤오버로 한 달 전체가 같은 주차로 뭉쳤다.
    //   D_(일) 는 소속 주 계산이 필요하므로 isoWeek(yyyymmdd) 유지하되, 2자리 zero-pad 로 W_ 와 라벨을 일치시킨다
    //   — 안 그러면 W1~W9(한자리 주차)에서 일그룹 'W1' ≠ SUM그룹 'W01' 로 쪼개져 주 SUM 이 주차 뒤로 분리된다
    //   (DB WEEK_NAME='W01' 2자리 포맷 실측). M_ 는 'SUM'.
    const weekLabel =
      kind === 'M' ? 'SUM' : kind === 'W' ? `W${tag.slice(6)}` : `W${String(isoWeek(tag)).padStart(2, '0')}`;
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

  // 월 그룹을 yyyymm 오름차순으로 명시 정렬 — months Map 삽입순은 sorted 바인딩 순(D_<M_<W_)을 따르므로,
  //   드릴다운으로 늦은 달의 D_ 가 앞 달의 W_/M_ 보다 먼저 삽입되면 달 순서가 뒤집힌다(늦은 달이 앞으로).
  const orderedMonths = [...months.entries()].sort(([a], [b]) => a.localeCompare(b));
  return orderedMonths.map<FlexGridColumnConfig>(([, month]) => {
    // SUM 을 블록의 시작에 둔다(AS-IS iLargeStartCol/iSmallStartCol, 자매 SCP0025 동형):
    //   (1) 월 SUM(M_) 그룹을 월 맨 앞으로, (2) 각 주 그룹 안에서 주 SUM(W_)·월 SUM(M_) leaf 를 일(D_) 앞으로.
    //   Weekly 는 이미 M_('SUM' 그룹)이 앞(정렬상 M_<W_)이라 동작 불변 — Daily 에서 W_ 주합계가 일자 뒤에,
    //   M_ 월합계 그룹이 월 끝에 붙던 것(sorted 순 D_<M_<W_)을 교정해 두 버킷을 '합계-앞' 정렬로 통일한다
    //   (사용자 지시 2026-10-13 — Daily+Sum 의 SUM 컬럼을 Weekly 처럼 합계대상 앞쪽으로).
    //   주 SUM('SUM') 뒤의 상세 주(Wxx)는 삽입순이 아니라 ISO 주차로 명시 정렬한다 — 그러지 않으면 드릴다운으로
    //   펼친 주(그 주 D_ 가 먼저 삽입)가 아직 접힌 앞 주(W_ SUM 만 존재, 정렬상 뒤)보다 먼저 생성돼 앞으로 튄다
    //   (예: Weekly+SUM 에서 W38 을 펼치면 W38 이 W37 앞으로). 연말 월은 W52/53 과 다음 해 W01 이 섞일 수
    //   있어 작은 주차(≤5)를 뒤로 보낸다.
    const weekNumOf = (w: WeekGroup): number => Number(w.label.slice(1)) || 0;
    const detailWeeks = [...month.weeks.values()].filter(w => w.label !== 'SUM');
    const wrap = detailWeeks.some(w => weekNumOf(w) >= 48) && detailWeeks.some(w => weekNumOf(w) <= 5);
    const weekSortKey = (w: WeekGroup): number => weekNumOf(w) + (wrap && weekNumOf(w) <= 5 ? 53 : 0);
    detailWeeks.sort((a, b) => weekSortKey(a) - weekSortKey(b));
    const weekGroups = [
      ...[...month.weeks.values()].filter(w => w.label === 'SUM'),
      ...detailWeeks,
    ];
    for (const w of weekGroups) {
      w.leaves.sort((a, b) => {
        const ba = a.binding ?? '';
        const bb = b.binding ?? '';
        const ra = pivotKind(ba) === 'D' ? 1 : 0; // D_(일)는 뒤, W_/M_ SUM 은 앞
        const rb = pivotKind(bb) === 'D' ? 1 : 0;
        return ra - rb || ba.localeCompare(bb);
      });
    }
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
