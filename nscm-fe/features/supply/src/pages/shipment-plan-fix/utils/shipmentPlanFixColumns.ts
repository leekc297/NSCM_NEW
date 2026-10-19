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
  return base.map(c => {
    // O_RC1 반환 키는 대문자다(PKG_SCP0025: `AS DIVISION_NAME`/`AS BIZ_TYPE_NAME`/`AS MEASURE` + `IA.DIVISION_ID`
    //   등 Oracle 기본 대문자 — ora.py 소스 실측). 그런데 admin 메타(SCM_MST_SHEET_COLUMNS)·fallback 의
    //   colNm 은 소문자(division_id/measure/...)라 바인딩이 데이터 키와 안 붙어 고정 컬럼이 전부 공란이 됐다.
    //   자매 SCP0024 는 대문자 키를 쓴다 — 바인딩 케이스를 데이터에 맞춰 정규화한다(라벨·가시성·순서는 admin 유지).
    const colNm = c.colNm.toUpperCase();
    return {
      ...c,
      colNm,
      // 기본 가시성(admin VISIBLE_FLAG 또는 fallback visible) AND EE 조건 가시성.
      visible: c.visible !== false && isFixedColumnVisible(colNm, ctx),
    };
  });
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
  // 바인딩 union 추출 — bucket·chkSum 과 무관하게 D_/W_/M_ 전량을 build(= 구조 고정). 표시는 아래 leaf 의
  //   visible(isPivotVisible bucket×chkSum)로만 제어한다. 안 보이는 kind 도 build 해 둬야 (1) SUM 토글이
  //   dynamicColumns 를 재생성하지 않아 헤더 깜빡임이 없고(자매 SSP0015 동형), (2) 헤더 더블클릭 드릴다운
  //   (Monthly→주, 주→일 펼침)의 대상 컬럼이 존재한다(AS-IS GET SP 가 bucket 무관 D_/W_/M_ 전량 반환 — design 03
  //   §2.2 / SetDblClickColumnShowHide). 안 보이는 leaf 는 Wijmo 가 렌더하지 않아 구조(계층)에만 기여한다.
  const bindings = new Set<string>();
  for (const r of rows) {
    for (const k of Object.keys(r)) {
      if (pivotKind(k) !== null) bindings.add(k);
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
    // leaf 헤더: D_ 는 일(DD), W_·M_ 롤업은 전부 'SUM'. AS-IS SCP0025.cs L389/395/403/414 가 주/월
    //   롤업 컬럼 헤더를 ColumnHeaderSpan(..., "SUM", ...) 로 다는 것과 1:1 — 주 식별은 상위 그룹
    //   (row1 = Wxx)이 맡고, 그 아래 롤업 leaf 는 "SUM"이다. 종전 W_ leaf=Wxx 는 오표기(사용자 신고
    //   2026-10-01 "SUM 이 아니라 W40/W41 로 뜸").
    const leafHeader = kind === 'D' ? tag.slice(6, 8) : 'SUM';
    week.leaves.push({
      binding,
      header: leafHeader,
      align: 'right',
      // format:'n0' 를 두지 않는다 — 공용 normalizeDynamicColumns 가 숫자 포맷 컬럼에 dataType=Number 를
      //   자동 부여해 같은 컬럼의 Fix Reason 텍스트(사유)를 숫자로 강제→공란이 된다(AS-IS 는 셀타입을
      //   SetCellTypeText 로 바꿔 혼용). 대신 Ship Plan 숫자 n0 포맷은 그리드 formatItem 에서 직접 처리한다.
      width: 70,
      allowMerging: false,
      allowSorting: false,
      allowResizing: true,
      // 초기 visible = 현재 chkSum 기준. SUM 토글 시엔 컬럼 재생성 없이 그리드가 col.visible 를 imperative
      //   flip 한다(ShipmentPlanFixGrid applyPivotVisibility) — W_/M_ SUM 롤업만 켜고 끈다.
      visible: isPivotVisible(binding, bucket, chkSum),
      // 전건 read-only(design 03 §3 R-G LockColumn all).
      _inputEditType: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
      _dynamic: true,
    });
  }

  return [...months.values()].map<FlexGridColumnConfig>(month => {
    // AS-IS SCP0025.cs L389/395 는 SUM 을 블록의 시작(iLargeStartCol/iSmallStartCol)에 단다 →
    //   (1) 월 SUM(M_) 그룹을 월 맨 앞으로, (2) 각 주 그룹 안에서 주 SUM(W_) leaf 를 일자(D_) 앞으로.
    //   SUM 그룹 식별 = label==='SUM'(M_ 전용 weekLabel). 나머지 주(Wxx)는 삽입 순서(=sorted 바인딩,
    //   날짜 오름차순)가 이미 연대순이라 그대로 둔다.
    const weekGroups = [
      ...[...month.weeks.values()].filter(w => w.label === 'SUM'),
      ...[...month.weeks.values()].filter(w => w.label !== 'SUM'),
    ];
    for (const w of weekGroups) {
      w.leaves.sort((a, b) => {
        const ba = a.binding ?? '';
        const bb = b.binding ?? '';
        const ra = pivotKind(ba) === 'D' ? 1 : 0; // D_(일자)는 뒤, W_/M_ SUM 은 앞
        const rb = pivotKind(bb) === 'D' ? 1 : 0;
        return ra - rb || ba.localeCompare(bb);
      });
    }
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
