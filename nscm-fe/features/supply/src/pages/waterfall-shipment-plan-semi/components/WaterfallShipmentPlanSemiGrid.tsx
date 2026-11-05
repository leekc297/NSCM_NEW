import { DataType } from '@mescius/wijmo';
import { AllowMerging, CellType, type FlexGrid, type GridPanel } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';
import { useEffect, useMemo } from 'react';

import type { FlexGridColumnConfig } from '@foundation/models';
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

  // Bucket 전환 시(§2.5 매트릭스 재계산) — 컬럼 visible 재적용 트리거.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    g.columns.forEach(col => {
      const kind = kindOf(col.binding ?? '');
      if (!kind) return;
      col.visible = dynVisible(kind);
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [gridRef, dynamicColumns, bucket, searchParams.isSumChecked]);

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
      // 03_grid-columns.md §3.3 — SmartColMerge(프레임워크 공통, 4트리거) 대응. 정확한 병합 대상열은
      //   확인 필요(FIXED_FLAG=Y measure_label 컬럼 + 좌측 키컬럼군 추정, §6#6) — 잠정 All 적용.
      allowMerging={AllowMerging.All}
      headerRowHeight={dynColMetas.length === 0 ? HEADER_TOTAL_HEIGHT : HEADER_TOTAL_HEIGHT / 3}
      alternatingRowStep={1}
      useHotkey
    />
  );
};
