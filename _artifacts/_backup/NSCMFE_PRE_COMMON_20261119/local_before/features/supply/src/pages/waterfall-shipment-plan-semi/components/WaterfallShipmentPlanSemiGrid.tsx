import { DataType } from '@mescius/wijmo';
import {
  AllowMerging,
  type CellRange,
  CellType,
  type FlexGrid,
  type GridPanel,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';
import { useEffect, useMemo, useRef } from 'react';

import type { FlexGridColumnConfig } from '@foundation/models';
import { CustomMergeManager } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { useWaterfallShipmentPlanSemiStore } from '../useWaterfallShipmentPlanSemiStore';
import { BUCKET_TYPE, kindOf, MENU_ID } from '../waterfall-shipment-plan-semi.constants';
import type { SpreadTitleRow, WaterfallRow } from '../waterfall-shipment-plan-semi.types';

// SCP0018 메인 그리드 — AS-IS spdMain('Waterfall Shipment Plan' 단일 시트) 1:1 조회 전용.
//   정적 24열 = SCM_MST_SHEET_COLUMNS(PROGRAM_ID='SCP0018', 03_grid-columns.md §1) 하드코딩 금지.
//   동적 pivot D_/W_/M_/B_(hidden)/ISO = 캘린더 SP(PKG_SCP0009, 미배포) 응답 기반 (§2).
//   Bucket×Sum visible 매트릭스(§2.5) — 서버 재조회 없이 클라 컬럼 visible 토글만 수행.
//   Set_SumValues 파생(D_→W_/M_ 재계산, INVENTORY=잔고 마지막값) 은 §3.2 — BE/SP 미배포 상태라
//   이 게이트는 SP 응답이 실제로 들어올 때까지 실행 검증 불가(ERROR, 04_react-gap.md 명시).

// 다단 헤더 총 높이 48px 표준(자매 waterfall-shipment-plan-fg #93 동일). 버킷에 따라 tier 수가
//   달라도(Daily=3단 월/주/일, Monthly=1단) 총 높이를 고정해 그리드 헤더 높이가 들쭉날쭉하지 않게 한다.
const HEADER_TOTAL_HEIGHT = 48;

interface DynColMeta {
  binding: string;
  kind: 'D' | 'W' | 'M' | 'B';
  large: string;
  small: string;
  leaf: string;
  mmdd: string;
  dayCode: string;
}

// Set_SumValues(AS-IS cs:739~827) 파생 — AS-IS 는 일(D_) 값만 서버 취득 후 주/월(W_/M_)을 FE 재합산한다.
//   measure != INVENTORY : W_/M_ = 소속 D_ 의 합
//   measure == INVENTORY : W_/M_ = 소속 D_ 중 마지막(최신) 값(합 아님 — 재고성 잔고 지표, design 03 §3 R8)
//   (SCM_MST_SHEET_MEASURE 실측: SCP0018 재고 measure COLUMN_NAME='INVENTORY'. 자매 FG SCP0016 는 'BALANCE'.)
const BALANCE_MEASURE = 'INVENTORY';

const toNum = (v: string | number | undefined): number => {
  const n = Number(v ?? 0);
  return Number.isFinite(n) ? n : 0;
};

// Daily 날짜 헤더 주말 글자색(AS-IS SetSpreadHeaderSpan — 토=파랑/일=빨강). 캘린더 SP 가 D_ 컬럼에
//   DAY_CODE(DAYOFWEEK)를 내려주면 그걸 쓰고, 없으면 바인딩 D_YYYYMMDD 에서 요일을 계산한다(견고성).
const SAT_COLOR = '#1565c0';
const SUN_COLOR = '#c62828';
const weekendColorOf = (binding: string, dayCode: string): string | null => {
  const dc = (dayCode ?? '').toUpperCase();
  if (dc === 'SAT') return SAT_COLOR;
  if (dc === 'SUN') return SUN_COLOR;
  if (!binding.startsWith('D_')) return null;
  const ymd = binding.slice(2, 10);
  if (!/^\d{8}$/.test(ymd)) return null;
  const dow = new Date(Number(ymd.slice(0, 4)), Number(ymd.slice(4, 6)) - 1, Number(ymd.slice(6, 8))).getDay();
  if (dow === 6) return SAT_COLOR; // 토
  if (dow === 0) return SUN_COLOR; // 일
  return null;
};

// 기간컬럼 소속 — 컬럼 정렬순(M_→W_→D_ 인터리브)을 좌→우로 훑어 각 D_ 를 직전 W_/M_ 에 귀속한다.
//   'B'(숨김 헬퍼)·'W'/'M' 자신은 멤버가 아니다(D_ 만 귀속). ISO 주처럼 소속 D_ 0 이면 서버값 유지.
const buildPeriodMembership = (
  metas: DynColMeta[]
): { weekOf: Map<string, string[]>; monthOf: Map<string, string[]> } => {
  const weekOf = new Map<string, string[]>();
  const monthOf = new Map<string, string[]>();
  let week: string | null = null;
  let month: string | null = null;
  metas.forEach(m => {
    if (m.kind === 'M') {
      month = m.binding;
      if (!monthOf.has(month)) monthOf.set(month, []);
    } else if (m.kind === 'W') {
      week = m.binding;
      if (!weekOf.has(week)) weekOf.set(week, []);
    } else if (m.kind === 'D') {
      if (week) weekOf.get(week)?.push(m.binding);
      if (month) monthOf.get(month)?.push(m.binding);
    }
  });
  return { weekOf, monthOf };
};

const derivePeriodSums = (rows: WaterfallRow[], metas: DynColMeta[]): WaterfallRow[] => {
  if (rows.length === 0 || metas.length === 0) return rows;
  const { weekOf, monthOf } = buildPeriodMembership(metas);
  if (weekOf.size === 0 && monthOf.size === 0) return rows;
  return rows.map(row => {
    const isBalance = String(row.MEASURE ?? '') === BALANCE_MEASURE;
    const next: WaterfallRow = { ...row };
    const apply = (members: string[], periodBinding: string): void => {
      if (members.length === 0) return; // 소속 D_ 없음 → 서버값 유지
      next[periodBinding] = isBalance
        ? toNum(row[members[members.length - 1]]) // 재고 = 기간 마지막(최신) D_
        : members.reduce((sum, dayBinding) => sum + toNum(row[dayBinding]), 0); // 그 외 = 합
    };
    weekOf.forEach(apply);
    monthOf.forEach(apply);
    return next;
  });
};

interface WaterfallShipmentPlanSemiGridProps {
  gridRef: MutableRefObject<FlexGrid<WaterfallRow> | undefined>;
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  data: WaterfallRow[];
  spreadTitle: SpreadTitleRow[];
}

// 01_layout.md §2 트리거A/B, 03_grid-columns.md §3.1 — Division 접두 EE 여부로 3컬럼 visible 토글.
//   admin staticColumns 의 다른 속성(폭/정렬 등)은 그대로 두고 이 3컬럼의 visible 만 화면 로컬 규칙으로
//   덮어쓴다 — 나머지 컬럼은 admin 메타 리터럴을 그대로 보존(CLAUDE.md §2 항목4).
const EE_TOGGLE_COLUMNS = ['ELECTRODE_TYPE', 'ORIGIN_FROM_DIVISION_ID', 'ORIGIN_TO_DIVISION_ID'];

// 세로 병합 대상 컬럼 = Measure 이전의 정적 식별/경로열(SCM_MST_SHEET_COLUMNS SORT_ORDER 1~14).
//   Measure(15)·그 이후·동적 기간 셀은 병합하지 않는다. 실제 병합 범위는 아래 매니저의 restricted +
//   빈 셀 끊김 규칙이 정한다(사용자 2026-11-03: 왼쪽 값이 있으면 뒤 컬럼까지 계속, 비면 그 전까지만).
const MERGE_ELIGIBLE_BINDINGS = new Set([
  'KEY_IDX',
  'DIVISION_ID',
  'OPERATION_GROUP_NAME',
  'ITEM_ID',
  'NICK_NAME',
  'ELECTRODE_TYPE',
  'ORIGIN_FROM_DIVISION_ID',
  'FROM_SITE_NAME',
  'BOH',
  'ORIGIN_TO_DIVISION_ID',
  'TO_SITE_NAME',
  'TRANSPORT_MODE',
  'LT_DAY',
  'VERSION_NO',
]);

const isBlankCell = (value: unknown): boolean =>
  value === null || value === undefined || (typeof value === 'string' && value.trim() === '');

// AS-IS SmartColMerge(FPMerge.Restricted) 세로 병합 재현 — 왼쪽 식별열이 병합된 구간에서만 오른쪽도
//   병합되고, 어느 컬럼이든 값이 비면 그 지점에서 체인이 끊겨 뒤 컬럼은 병합되지 않는다(사용자 2026-11-03).
//   예) From Site 에 값이 있으면 BOH~Version 까지 값이 같은 만큼 계속 병합, From Site 가 비면 그 전
//   (Origin From Div)까지만 병합. 공용 CustomMergeManager 의 좌→우 누적 키가 "왼쪽 값이 모두 같음"을
//   보장하므로, 여기서는 왼쪽 visible 식별/경로열 중 빈 셀이 있으면 끊고 나머지는 super 에 위임한다.
//   Measure 이후·동적 기간 셀(MERGE_ELIGIBLE 아님)은 병합하지 않는다. 헤더(기간 다단) 병합은 super 그대로.
//   공용 DataGrid 가 정적 컬럼 allowMerging 을 grid 레벨 값으로 덮어 컬럼 단위 제어가 불가능하므로
//   col.allowMerging 대신 매니저에서 직접 게이트한다.
class WaterfallSemiMergeManager extends CustomMergeManager<WaterfallRow> {
  override getMergedRange(panel: GridPanel, row: number, col: number): CellRange | null {
    if (panel.cellType !== CellType.Cell) return super.getMergedRange(panel, row, col);
    if (!MERGE_ELIGIBLE_BINDINGS.has(panel.columns[col]?.binding ?? '')) return null;
    // restricted 끊김 — 이 컬럼 왼쪽의 visible 식별/경로열 중 하나라도 빈 값이면 병합하지 않는다.
    for (let k = 0; k < col; k += 1) {
      const left = panel.columns[k];
      if (left?.visible === false) continue;
      if (!MERGE_ELIGIBLE_BINDINGS.has(left?.binding ?? '')) continue;
      if (isBlankCell(panel.getCellData(row, k, false))) return null;
    }
    return super.getMergedRange(panel, row, col);
  }
}

export const WaterfallShipmentPlanSemiGrid = ({
  gridRef,
  gridFilterRef,
  data,
  spreadTitle,
}: WaterfallShipmentPlanSemiGridProps) => {
  const searchParams = useWaterfallShipmentPlanSemiStore(state => state.searchParams);
  const rawStaticColumns = useWaterfallShipmentPlanSemiStore(state => state.staticColumns);

  const bucket = searchParams.bucket;
  const isWeeklyIso = bucket === BUCKET_TYPE.WEEKLY_ISO;
  const isEE = searchParams.divisionId.trim().toUpperCase().startsWith('EE');

  // 그리드 재생성 4트리거(Form_Load/조회/Measure팝업OK/Bucket변경) 마다 재계산 — mount 1회 고정 금지.
  const staticColumns = useMemo(
    () =>
      rawStaticColumns.map(col =>
        EE_TOGGLE_COLUMNS.includes(col.colNm) ? { ...col, visible: isEE } : col
      ),
    [rawStaticColumns, isEE]
  );

  // 동적 pivot 컬럼 메타 — 03_grid-columns.md §2.2 (SP 컬럼 계약, 확인 필요 — SP 본문 ERROR).
  const dynColMetas = useMemo<DynColMeta[]>(() => {
    return (spreadTitle ?? [])
      .map(r => {
        const binding = String(r.COLUMN_NAME ?? '');
        const kind = kindOf(binding);
        if (!kind) return null;
        return {
          binding,
          kind,
          large: String(r.LARGE_CLASS_LABEL_NAME ?? ''),
          small: String(r.SMALL_CLASS_LABEL_NAME ?? ''),
          leaf: String(r.COLUMN_LABEL_NAME ?? ''),
          mmdd: String(r.MMDD_LABEL_NAME ?? ''),
          dayCode: String(r.DAY_CODE ?? '').toUpperCase(),
        } as DynColMeta;
      })
      .filter((m): m is DynColMeta => m !== null);
  }, [spreadTitle]);

  // Set_SumValues 파생 — D_ 만 신뢰하고 W_/M_ 를 FE 재합산(measure!=INVENTORY=합, INVENTORY=기간 마지막값).
  //   서버가 W_/M_ 를 plain SUM 으로 줘도 FE 재합산이 덮어써 재고(INVENTORY) 행을 잔고로 교정한다.
  const gridData = useMemo(() => derivePeriodSums(data, dynColMetas), [data, dynColMetas]);

  // Bucket×Sum visible 매트릭스 — 03_grid-columns.md §2.5 표 그대로.
  const dynVisible = (kind: DynColMeta['kind']): boolean => {
    if (kind === 'B') return false; // B_ 숨김 헬퍼 컬럼 — Bucket 전환과 무관하게 항상 숨김
    if (isWeeklyIso) return kind === 'W'; // WEEKLY_ISO: D_/M_ 항상 숨김, W_(ISO)만 표시
    if (bucket === BUCKET_TYPE.WEEKLY)
      return kind === 'W' || (kind === 'M' && searchParams.isSumChecked);
    if (bucket === BUCKET_TYPE.MONTHLY) return kind === 'M';
    // DAILY(기본) — D_ 항상 표시, W_/M_ 은 Sum 체크 연동
    return kind === 'D' || ((kind === 'W' || kind === 'M') && searchParams.isSumChecked);
  };

  // 동적 컬럼 nested(3단 — ISO: MMDD/주차/SUM, NotISO: 월/주/SUM) — 03_grid-columns.md §2.3/2.4.
  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    if (dynColMetas.length === 0) return [];
    if (isWeeklyIso) {
      return dynColMetas
        .filter(m => m.kind === 'W')
        .map(m => ({
          // 1단 = 날짜범위(AS-IS "09.07 ~ 09.13"). AS-IS ISO(03_grid-columns.md §2.3)는 row0 =
          //   MMDD_LABEL_NAME(주차 시작~끝 날짜범위)이다 → mmdd 우선. 단, TO-BE 공통 캘린더 SP
          //   (PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN)가 아직 MMDD_LABEL_NAME 미반환이라
          //   mmdd 가 비면 large(=MONTH_NAME 월)→small→binding 로 폴백한다(SP 가 날짜범위를 내보내면
          //   자동으로 AS-IS 등가로 전환 — SP 보강은 DB/role#2, BASIS_START_DATE/END_DATE 원천 확인 완료).
          header: m.mmdd || m.large || m.small || m.binding,
          align: 'center',
          allowSorting: false,
          columns: [
            {
              // 2단 = 주차(W37). COLUMN_LABEL_NAME(leaf) 우선.
              header: m.leaf || m.small || 'SUM',
              align: 'center',
              allowSorting: false,
              columns: [
                {
                  binding: m.binding,
                  header: 'SUM',
                  align: 'right',
                  format: 'n0',
                  isReadOnly: true,
                  allowSorting: false,
                  visible: dynVisible(m.kind),
                  // 1단 헤더가 날짜범위("MM.DD ~ MM.DD", 11자)라 기본 폭이면 눌린다 — AS-IS ISO 컬럼폭
                  //   100px 과 동일하게 고정(SCP0018...cs:342 colWidth=100).
                  width: 100,
                },
              ],
            },
          ],
        }));
    }
    const largeMap = new Map<string, { label: string; subs: Map<string, DynColMeta[]> }>();
    dynColMetas.forEach(m => {
      const ymKey = m.large || m.binding.slice(2, 8);
      let group = largeMap.get(ymKey);
      if (!group) {
        group = { label: m.large || ymKey, subs: new Map() };
        largeMap.set(ymKey, group);
      }
      const subKey = m.kind === 'M' ? 'SUM' : m.small || 'SUM';
      if (!group.subs.has(subKey)) group.subs.set(subKey, []);
      group.subs.get(subKey)?.push(m);
    });
    return [...largeMap.values()].map(group => ({
      header: group.label,
      align: 'center',
      allowSorting: false,
      columns: [...group.subs.entries()].map(([subLabel, metas]) => ({
        header: subLabel,
        align: 'center',
        allowSorting: false,
        columns: metas.map(m => ({
          binding: m.binding,
          // B_ 컬럼은 항상 숨김 텍스트 — 나머지는 리프 라벨.
          header: m.kind === 'D' ? m.leaf || m.binding : 'SUM',
          align: m.kind === 'B' ? 'left' : 'right',
          format: m.kind === 'B' ? undefined : 'n0',
          dataType: m.kind === 'B' ? DataType.String : undefined,
          isReadOnly: true,
          allowSorting: false,
          visible: dynVisible(m.kind),
          width: m.kind === 'B' ? 0 : undefined,
        })),
      })),
    }));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [dynColMetas, isWeeklyIso, bucket, searchParams.isSumChecked]);

  // ── Bucket·Sum 가시성 + 헤더 더블클릭 드릴(접기/펼치기) — AS-IS SetDblClickColumnShowHide 파리티,
  //    자매 SCP0016 WaterfallShipmentPlanFgGrid 와 동형. drillVisRef = 사용자가 더블클릭으로 덮어쓴
  //    컬럼별 가시성(없으면 dynVisible 기본값, §2.5 매트릭스). applyDynVisibility 를 updatedLayout 에 걸어
  //    columnGroups 재대입·invalidate 뒤에도 가시성이 유지되게 한다(변경 있을 때만 invalidate — 재발화 없음).
  const drillVisRef = useRef<Map<string, boolean>>(new Map());
  const applyDynVisibilityRef = useRef<(() => void) | null>(null);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    // bucket/sum/조회(동적 메타) 변경 = AS-IS SetSpreadColumn 재실행 등가 — 드릴 상태 리셋.
    drillVisRef.current.clear();
    const applyDynVisibility = () => {
      let changed = false;
      for (let i = 0; i < g.columns.length; i += 1) {
        const col = g.columns[i];
        const kind = kindOf(col.binding ?? '');
        if (!kind) continue;
        const want = drillVisRef.current.get(col.binding ?? '') ?? dynVisible(kind);
        if (col.visible !== want) {
          col.visible = want;
          changed = true;
        }
      }
      if (changed) g.invalidate(true);
    };
    applyDynVisibilityRef.current = applyDynVisibility;
    g.updatedLayout.addHandler(applyDynVisibility);
    applyDynVisibility();
    return () => {
      try {
        g.updatedLayout?.removeHandler(applyDynVisibility);
        applyDynVisibilityRef.current = null;
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [gridRef, dynamicColumns, bucket, searchParams.isSumChecked]);

  // 헤더 더블클릭 드릴다운(접기/펼치기) — AS-IS SpdMain_CellDoubleClick → SetDblClickColumnShowHide
  //   (SpreadInfo.cs L13648). WeeklyISO 는 월구분 없이 주별만 보이므로 무동작(AS-IS cs:975 가드).
  //   M_(월) SUM 헤더 = 그 달 구간(다음 M_ 전까지) W_ 토글 + 보이는 D_ 접기(hideOnly) /
  //   W_(주) SUM 헤더 = 그 주 구간(다음 W_/M_ 전까지) D_ 토글. 표시순서(g.columns)로 구간을 walk.
  useEffect(() => {
    const g = gridRef.current;
    if (!g?.hostElement) return;
    const host = g.hostElement;
    const onDblClick = (ev: MouseEvent) => {
      if (isWeeklyIso) return;
      const hit = g.hitTest(ev);
      if (hit.cellType !== CellType.ColumnHeader) return;
      const clicked = g.columns[hit.col]?.binding ?? '';
      const clickedKind = kindOf(clicked);
      if (clickedKind !== 'M' && clickedKind !== 'W') return; // leaf(일)는 접을 하위 없음
      const dyn: string[] = [];
      for (let i = 0; i < g.columns.length; i += 1) {
        const b = g.columns[i].binding ?? '';
        if (kindOf(b) !== null) dyn.push(b);
      }
      const idx = dyn.indexOf(clicked);
      if (idx < 0) return;
      const flip = (target: string, hideOnly: boolean) => {
        const col = g.columns.getColumn(target);
        if (!col) return;
        if (hideOnly && !col.visible) return; // M 드릴: 보이는 D_ 만 접는다(AS-IS 동일)
        drillVisRef.current.set(target, hideOnly ? false : !col.visible);
      };
      for (let i = idx + 1; i < dyn.length; i += 1) {
        const t = dyn[i];
        const tk = kindOf(t);
        if (clickedKind === 'M') {
          if (tk === 'M') break;
          if (tk === 'W') flip(t, false);
          else if (tk === 'D') flip(t, true);
        } else {
          if (tk === 'W' || tk === 'M') break;
          if (tk === 'D') flip(t, false);
        }
      }
      applyDynVisibilityRef.current?.();
    };
    host.addEventListener('dblclick', onDblClick);
    return () => host.removeEventListener('dblclick', onDblClick);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [gridRef, dynamicColumns, bucket, isWeeklyIso]);

  // 세로 병합 매니저 교체 — restricted + 빈 셀 끊김(위 WaterfallSemiMergeManager). col.allowMerging 는
  //   공용 DataGrid 가 grid 레벨 값으로 덮어써 컬럼 단위 제어가 안 되므로 매니저 자체를 교체한다(자매
  //   DMF0053 동형). DataGrid 가 updatedLayout 마다 TopLeft(No 코너) 병합으로 다시 감싸므로 두 동작 모두
  //   유지된다. 컬럼 재생성 4트리거마다 재적용.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    if (g.mergeManager instanceof WaterfallSemiMergeManager) return;
    g.mergeManager = new WaterfallSemiMergeManager(g);
    g.invalidate(true);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [gridRef, staticColumns, dynamicColumns, bucket, searchParams.isSumChecked]);

  // 헤더 높이 자급 — 총 48px 를 보이는 헤더 tier 수로 나눠 강제(버킷별 단수 Daily 3단/Monthly 1단이 달라도
  //   총 높이 일정). 주의: updatedLayout 핸들러 안에서 invalidate 하면 중첩 컬럼그룹 헤더가 매 레이아웃마다
  //   높이를 되돌려 self-retrigger 무한루프(= 메인 스레드 먹통 → 조회버튼 반응 없음)가 난다. 그래서
  //   컬럼/버킷/Sum 변경 시 rAF 로 레이아웃 완료 후 1회만 적용한다(자가 재발화 없음).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const id = requestAnimationFrame(() => {
      const rows = g.columnHeaders?.rows;
      if (!rows || rows.length === 0) return;
      const targetHeight = HEADER_TOTAL_HEIGHT / rows.length;
      for (let i = 0; i < rows.length; i += 1) rows[i].height = targetHeight;
      rows.defaultSize = targetHeight;
      g.invalidate();
    });
    return () => cancelAnimationFrame(id);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [gridRef, staticColumns, dynamicColumns, bucket, searchParams.isSumChecked]);

  // 그리드 색상(AS-IS 등가, formatItem):
  //   1) Daily 날짜 헤더 주말 글자색 — D_ 컬럼 헤더 토=파랑/일=빨강(SetSpreadHeaderSpan cs:427).
  //   2) 음수 셀 빨강 — AS-IS NumberCellType.NegativeRed=true(SpreadInfo.cs, 전 수치 셀 공통,
  //      SetReNumerCellType cs:346/415/423). 셀 재활용 대비 비음수는 색을 초기화한다.
  const dayCodeByBinding = useMemo(() => {
    const m = new Map<string, string>();
    dynColMetas.forEach(d => {
      if (d.kind === 'D') m.set(d.binding, d.dayCode);
    });
    return m;
  }, [dynColMetas]);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const handler = (
      sender: FlexGrid<WaterfallRow>,
      e: { panel: GridPanel; row: number; col: number; cell: HTMLElement }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (e.panel.cellType === CellType.ColumnHeader) {
        if (!binding.startsWith('D_')) return;
        const color = weekendColorOf(binding, dayCodeByBinding.get(binding) ?? '');
        if (color) e.cell.style.color = color;
        return;
      }
      if (e.panel.cellType !== CellType.Cell) return;
      // 음수 = 빨강(그 외 수치/텍스트 셀은 기본색으로 초기화 — Wijmo 셀 재활용 잔색 방지).
      const raw = (sender.rows[e.row]?.dataItem as WaterfallRow | undefined)?.[binding];
      const n = typeof raw === 'number' ? raw : raw != null && raw !== '' ? Number(raw) : NaN;
      e.cell.style.color = Number.isFinite(n) && n < 0 ? SUN_COLOR : '';
    };
    g.formatItem.addHandler(handler);
    return () => {
      try {
        g.formatItem.removeHandler(handler);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, dayCodeByBinding]);

  return (
    <DataGrid<WaterfallRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={gridData}
      staticColumns={staticColumns}
      dynamicColumns={dynamicColumns}
      comboParams={{ mnuId: `'${MENU_ID}'` }}
      isReadOnly
      // 03_grid-columns.md §3.3 — SmartColMerge(프레임워크 공통, 4트리거) 대응. 그리드 레벨은 All 로 열고
      //   (헤더 다단 병합·식별열 세로 병합 활성), 실제 세로 병합 범위는 위 WaterfallSemiMergeManager 가
      //   restricted + 빈 셀 끊김 규칙으로 정한다(사용자 확인 2026-11-03).
      allowMerging={AllowMerging.All}
      headerRowHeight={dynColMetas.length === 0 ? HEADER_TOTAL_HEIGHT : HEADER_TOTAL_HEIGHT / 3}
      alternatingRowStep={1}
      useHotkey
    />
  );
};
