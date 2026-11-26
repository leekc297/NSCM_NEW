import { AllowMerging, CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { type EditTracker, paintNegativeText, toGridNumber } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import { MAIN_COLUMNS, DIVISION_40_ONLY_COLUMNS, DIVISION_EE_ONLY_COLUMNS, FREEZE_ANCHOR_COLUMN } from '../shipment-plan-fg.columns';
import { BUCKET_TYPE, MEASURE, MSG, QTY_MAX, WEEKEND_HEADER_COLOR } from '../shipment-plan-fg.constants';
import type { FixInfoRow, MainColumnMeta, MainRow, PlanStatusRow } from '../shipment-plan-fg.types';
import { buildColumns } from '../utils/shipment-plan-fg.buildColumns';
import { computeDrillToggles } from '../utils/shipment-plan-fg.drilldown';
import { computeIsEditable, dynColKindOf, isMainCellEditable, type MainEditContext } from '../utils/shipment-plan-fg.editLock';
import { buildFixedCellSet, type FixedCellSet, isCellFixed } from '../utils/shipment-plan-fg.fix';
import { type HeaderKey, ShipmentPlanFgHeaderMergeManager } from '../utils/shipment-plan-fg.headerMerge';
import { canOpenBodPopup } from '../utils/shipment-plan-fg.insert';

export interface SpreadTitleRow {
  COLUMN_NAME?: string;
  LARGE_CLASS_LABEL_NAME?: string;
  SMALL_CLASS_LABEL_NAME?: string;
  COLUMN_LABEL_NAME?: string;
  SORT_ORDER_NO?: number;
  BASIS_START_DATE?: string;
  DAY_CODE?: string;
}

interface Props {
  rows: MainRow[];
  spreadTitle: SpreadTitleRow[];
  fixInfoRows: FixInfoRow[];
  planStatusRows: PlanStatusRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  fixCellsRef: MutableRefObject<FixedCellSet | undefined>; // Fix/Unfix 대상 판정용 — 부모가 읽는다
  adminColumns?: RawFlexGridColumnConfig[];
  division: string;
  planStartYyyymmdd: string;
  fromYyyymmdd: string;
  toYyyymmdd: string;
  bucketType: BUCKET_TYPE;
  chkSum: boolean;
  planType: string;
  planSeq: string;
  onFocus: () => void;
  onBodCellClick?: (row: MainRow) => void; // BOD Master 팝업 열기(TRANSPORT_MODE/FROM_SITE_NAME 셀 클릭)
}

const HEADER_TOTAL_HEIGHT = 48;

// 헤더 Bold 대상(AS-IS .cs:666-667 — From Site·Trans Mode 컬럼 헤더만 Bold).
const BOLD_HEADER_BINDINGS = new Set(['FROM_SITE_NAME', 'TRANSPORT_MODE']);

const s = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

export const ShipmentPlanFgGrid = ({
  rows,
  spreadTitle,
  fixInfoRows,
  planStatusRows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  fixCellsRef,
  adminColumns,
  division,
  planStartYyyymmdd,
  fromYyyymmdd,
  toYyyymmdd,
  bucketType,
  chkSum,
  planType,
  planSeq,
  onFocus,
  onBodCellClick,
}: Props) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;

  // 정보컬럼 — admin 메타 우선, division 조건부 hidden 은 런타임 오버레이(design 03 §1.A R-A/R-B)
  const infoColumns = useMemo<MainColumnMeta[]>(() => {
    const isEE = division.startsWith('EE');
    const is40 = division === '40';
    return MAIN_COLUMNS.map(c => {
      if ((DIVISION_40_ONLY_COLUMNS as readonly string[]).includes(c.key)) {
        return { ...c, visible: is40 };
      }
      if ((DIVISION_EE_ONLY_COLUMNS as readonly string[]).includes(c.key)) {
        return { ...c, visible: isEE };
      }
      return c;
    });
  }, [division]);
  const staticColumns = useMemo(() => buildColumns(infoColumns, adminColumns), [infoColumns, adminColumns]);

  // 동적 D_/W_/M_ pivot 컬럼 — 헤더구조는 spreadTitle(calendar SP, Bucket 무관 항상 전체) 기준(design 03 §2.1~§2.3)
  // 주 시작일: calendar SP(P_SCP0009_GET_SHEET_CALENDAR_3SPAN)는 BASIS_START_DATE 를 반환하지 않으므로,
  //   W_ 행은 SORT_ORDER_NO 앞 8자리(주 시작일 + '21')에서, D_ 행은 대/소분류 라벨이 같은 W_ 행에서 가져온다.
  //   M_ 행의 SORT_ORDER_NO 앞 8자리는 월 시작일이 아니라 조회 시작일이라 쓰지 않는다.
  const dynColMetas = useMemo(() => {
    const weekStartByLabel = new Map<string, string>();
    spreadTitle.forEach(r => {
      if (dynColKindOf(s(r.COLUMN_NAME)) === 'W') {
        weekStartByLabel.set(
          `${s(r.LARGE_CLASS_LABEL_NAME)}|${s(r.SMALL_CLASS_LABEL_NAME)}`,
          s(r.SORT_ORDER_NO).slice(0, 8)
        );
      }
    });
    return spreadTitle
      .map(r => {
        const binding = s(r.COLUMN_NAME);
        const kind = dynColKindOf(binding);
        if (!kind) return null;
        const large = s(r.LARGE_CLASS_LABEL_NAME);
        const small = s(r.SMALL_CLASS_LABEL_NAME);
        const derivedWeekStart =
          kind === 'W'
            ? s(r.SORT_ORDER_NO).slice(0, 8)
            : kind === 'D'
              ? (weekStartByLabel.get(`${large}|${small}`) ?? '')
              : '';
        return {
          binding,
          kind,
          large,
          small,
          leaf: s(r.COLUMN_LABEL_NAME) || binding,
          sort: Number(r.SORT_ORDER_NO ?? 0),
          weekStart: s(r.BASIS_START_DATE) || derivedWeekStart,
        };
      })
      .filter((m): m is NonNullable<typeof m> => m !== null);
  }, [spreadTitle]);

  const weekOrMonthStart = useMemo(() => {
    const map = new Map<string, string>();
    dynColMetas.forEach(m => {
      if (m.weekStart) map.set(m.binding, m.weekStart);
    });
    return map;
  }, [dynColMetas]);

  // 일자 헤더 주말 색 판정용 binding -> 'SAT' | 'SUN' (AS-IS .cs:907). D_ 컬럼만 담는다.
  const weekendByBinding = useMemo(() => {
    const map = new Map<string, 'SAT' | 'SUN'>();
    spreadTitle.forEach(r => {
      const binding = s(r.COLUMN_NAME);
      if (dynColKindOf(binding) !== 'D') return;
      const code = s(r.DAY_CODE).trim().toUpperCase();
      if (code === 'SAT' || code === 'SUN') map.set(binding, code);
    });
    return map;
  }, [spreadTitle]);

  // Bucket x chkSum -> visible 토글(design 03 §2.4) — 재조회 없는 클라 토글
  const isDynVisible = (kind: 'D' | 'W' | 'M'): boolean => {
    if (bucketType === BUCKET_TYPE.DAILY) return kind === 'D' || chkSum;
    if (bucketType === BUCKET_TYPE.WEEKLY) return kind === 'W' || (kind === 'M' && chkSum);
    return kind === 'M'; // Monthly — M_ 만
  };

  // 3-span 헤더(대/소/일) — Wijmo 중첩 columns 가 병합 메커니즘(forecast-price/sales-plan 패턴)
  //   AS-IS 파리티(design 03 §2.3): 대분류는 월 단위(binding 의 yyyymm), 합계 컬럼(W_/M_)의 맨 아래 단 라벨은 'SUM',
  //   월 합계(M_)는 소분류 그룹 없이 월 그룹 바로 아래 리프로 둔다 — 단수가 얕은 컬럼은 Wijmo 가 남은 헤더 행을
  //   세로로 채우므로 Monthly 가 AS-IS 처럼 2단(월 / SUM)으로 보인다.
  const dynamicColumns = useMemo(() => {
    type LeafCol = { binding: string; header: string; sort: number; visible: boolean };
    type LargeBucket = {
      label: string;
      order: number;
      monthSums: LeafCol[];
      subs: Map<string, LeafCol[]>;
    };
    const toLeafConfig = (l: LeafCol) => ({
      binding: l.binding,
      header: l.header,
      align: 'right',
      width: 90,
      allowDragging: false,
      allowMerging: false,
      allowSorting: false,
      visible: l.visible,
      // 소수자리(design 03 §2.2): SHIP_PLAN_ENERGY/_AMEND_ENERGY 행 3자리, 나머지 2자리 —
      //   Wijmo 컬럼 format 은 컬럼 단위라 행(MEASURE)별 전환이 안 된다. 선택 3자리 포맷
      //   '#,##0.###' 하나로 양쪽을 수용(트레일링 0 은 자동 생략되어 2자리 값도 그대로 표시).
      format: '#,##0.###',
    });
    const largeMap = new Map<string, LargeBucket>();
    dynColMetas.forEach(m => {
      const largeKey = m.binding.slice(2, 8);
      const bucket: LargeBucket = largeMap.get(largeKey) ?? {
        label: m.large,
        order: m.sort,
        monthSums: [],
        subs: new Map<string, LeafCol[]>(),
      };
      largeMap.set(largeKey, bucket);
      const leaf: LeafCol = {
        binding: m.binding,
        header: m.kind === 'D' ? m.leaf : 'SUM',
        sort: m.sort,
        visible: isDynVisible(m.kind),
      };
      if (m.kind === 'M') {
        bucket.monthSums.push(leaf);
        return;
      }
      const subKey = m.small || 'SUM';
      const leafCols: LeafCol[] = bucket.subs.get(subKey) ?? [];
      bucket.subs.set(subKey, leafCols);
      leafCols.push(leaf);
    });
    return [...largeMap.values()]
      .sort((a, b) => a.order - b.order)
      .map(bucket => ({
        header: bucket.label,
        align: 'center',
        allowSorting: false,
        allowMerging: false,
        columns: [
          ...bucket.monthSums.sort((a, b) => a.sort - b.sort).map(toLeafConfig),
          ...[...bucket.subs.entries()]
            .sort((a, b) => (a[1][0]?.sort ?? 0) - (b[1][0]?.sort ?? 0))
            .map(([subLabel, leafCols]) => ({
              header: subLabel,
              align: 'center',
              columns: leafCols.sort((a, b) => a.sort - b.sort).map(toLeafConfig),
            })),
        ],
      }));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [dynColMetas, bucketType, chkSum]);

  // 정수 입력제한 — AS-IS 버킷컬럼 SetReNumerCellType(cs:905, DecimalPlaces=0). 편집 가능한 행은
  //   SHIP_PLAN_AMEND 뿐이라 ENERGY 행의 3자리(표시 전용 SetCellType cs:4143)와 충돌하지 않는다.
  //   동적 컬럼 config 에 integerOnly 를 실으면 wijmo Column 생성이 깨지므로 numberRules prop 으로 건다.
  const numberRules = useMemo(() => {
    const rules: Record<string, { integerOnly: true }> = {};
    dynColMetas.forEach(m => {
      rules[m.binding] = { integerOnly: true };
    });
    return rules;
  }, [dynColMetas]);

  // Fix 정보(O_RC3) — 행(KEY_IDX+FROM_SITE+INCOTERMS+BOD_ID) × 일자 단위 셀 판정(design 03 §2.5, AS-IS
  //   Set_FixCellColor .cs:1655-1731). Weekly 시 W_ 셀은 Fix된 일자가 속한 주를 weekOrMonthStart 로 역추적한다.
  //   calendar SP 가 주 시작일을 채우지 않으면(확인 필요) W_ 판정 집합은 비어 D_ 셀만 칠해진다(안전 degrade).
  //   부모(ShipmentPlanFg)가 Fix/Unfix 대상 판정에 같은 집합을 쓰도록 ref 로 넘긴다.
  const fixedCells = useMemo(() => buildFixedCellSet(fixInfoRows, weekOrMonthStart), [fixInfoRows, weekOrMonthStart]);
  fixCellsRef.current = fixedCells;

  // Plan 전체 편집가능 게이트(AS-IS GetIsEditable, design 03 §3.1 R-K 상위 게이트) — SHIP_PLAN_AMEND
  //   행이라도 더 나중 단계 Plan(PR→MA→SE→FN)이 이미 생성돼 있으면 전체 잠금(2026-10-21 추가 구현).
  //   O_RC2 가 비면(Daily 조회) AS-IS cs:1568 처럼 판정값을 갱신하지 않고 직전 값을 유지한다 —
  //   초기값은 AS-IS _IsEditable 기본값 "N"(cs:287)이라 처음부터 Daily 로 조회하면 전체 잠금.
  const isEditableRef = useRef(false);
  const isEditable = useMemo(() => {
    if (planStatusRows.length > 0) isEditableRef.current = computeIsEditable(planStatusRows, planType, planSeq);
    return isEditableRef.current;
  }, [planStatusRows, planType, planSeq]);

  const editCtxRef = useRef<MainEditContext>({
    bucketType,
    division,
    planStartYyyymmdd,
    queryFromYyyymmdd: fromYyyymmdd,
    queryToYyyymmdd: toYyyymmdd,
    weekOrMonthStart,
    isEditable,
  });
  editCtxRef.current = {
    bucketType,
    division,
    planStartYyyymmdd,
    queryFromYyyymmdd: fromYyyymmdd,
    queryToYyyymmdd: toYyyymmdd,
    weekOrMonthStart,
    isEditable,
  };

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 편집잠금(§0 정보컬럼 전건 잠금 + R-K SHIP_PLAN_AMEND 판정) — beginningEdit 게이트.
    // 주의(R1 결함 수정, gap-resolve iter-1): 공용 DataGrid wrapper 의 setEditableColumns 가
    //   먼저 등록하는 beginningEdit 핸들러(dataGridUtils.ts)는 admin 메타 INPUT_TP_CD 기준으로
    //   cancel=true 를 세운다(이 화면은 전 정보컬럼 'S', 동적 pivot 컬럼은 메타 자체가 없어 역시 default
    //   분기로 cancel=true). wijmo Event 는 등록 순서대로 같은 EventArgs 를 누적 판정하므로(FIFO),
    //   editable 로 판정된 분기에서도 명시적으로 e.cancel=false 로 되돌리지 않으면 wrapper 의 1차
    //   취소가 그대로 유지되어 편집모드 진입 자체가 막힌다(SalesFuturePriceGrid.tsx L594-616 동일 패턴
    //   참조 — "FIFO 마지막 핸들러 → e.cancel 명시 설정이 wrapper 보다 우선").
    const beginningEditHandler = (sender: FlexGridType, e: { cancel: boolean; row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      e.cancel = !row || !isMainCellEditable(binding, row, editCtxRef.current);
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // 붙여넣기 게이트(R1 수정) — wrapper 의 pastingCell 핸들러(dataGridUtils.ts:385)도 동일하게
    //   admin 메타 기준 cancel=true 만 세우고 화면이 되돌리지 않아 붙여넣기가 항상 차단돼 있었다.
    //   beginningEdit 와 동일 판정 로직을 paste 경로에도 적용한다.
    const pastingCellHandler = (sender: FlexGridType, e: { cancel: boolean; row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      e.cancel = !row || !isMainCellEditable(binding, row, editCtxRef.current);
    };
    g.pastingCell.addHandler(pastingCellHandler);

    // 저장 값 검증(cellEditEnded) — 음수/상한 초과(design 03 §4.3, MSG 코드는 gap-resolve iter-1
    //   NEW8 — 원 AS-IS 코드 MSG00084/MSG00317 는 TO-BE 미등록이라 production-plan-line 이 미러링한
    //   대체 등록코드(MSG.QTY_NEGATIVE=MSG00225/MSG.QTY_MAX=MSG00165)를 그대로 재사용한다).
    const cellEditEndedHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (!binding.startsWith('D_') && !binding.startsWith('W_') && !binding.startsWith('M_')) return;
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      const qty = Number(row[binding]);
      if (!Number.isFinite(qty)) return;
      if (qty < 0) {
        setToast({ type: 'error', message: t(MSG.QTY_NEGATIVE, '_Value must not be negative.') });
        row[binding] = 0;
      } else if (qty > QTY_MAX) {
        setToast({ type: 'error', message: t(MSG.QTY_MAX, '_Value exceeds maximum(99999999).') });
        row[binding] = QTY_MAX;
      }
      sender.invalidate();
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);
    g.pastedCell.addHandler(cellEditEndedHandler);

    // Fix 하이라이트(행×일자 셀 단위, design 03 §2.5) + SHIP_PLAN_AMEND 편집밴드(R-G, 노란 공통표준) — formatItem.
    //   W_ 셀은 Weekly Bucket 일 때만 칠한다(AS-IS .cs:1710).
    const formatItemHandler = (
      sender: FlexGridType,
      e: {
        panel: { cellType: CellType; columns: { binding: string }[]; rows: { dataItem: unknown }[] };
        col: number;
        row: number;
        cell: HTMLElement;
      }
    ) => {
      const binding = e.panel?.columns?.[e.col]?.binding ?? '';
      // 주말 헤더 색 — 일자(leaf) 행만. 월/주 그룹 행도 leaf binding 을 돌려줘 구분하지 않으면 그룹 블록 전체가 물든다.
      if (e.panel?.cellType === CellType.ColumnHeader) {
        // From Site·Trans Mode 헤더 Bold(AS-IS .cs:666-667). 공통 CSS 의 font-weight:400 !important 를 넘으려면
        //   inline !important 가 필요하다(자매 화면 ShipmentPlanSemiGrid 동일).
        if (BOLD_HEADER_BINDINGS.has(binding)) e.cell.style.setProperty('font-weight', 'bold', 'important');
        if (e.row !== e.panel.rows.length - 1) return;
        const weekend = weekendByBinding.get(binding);
        if (weekend) e.cell.style.color = WEEKEND_HEADER_COLOR[weekend];
        return;
      }
      const kind = dynColKindOf(binding);
      const dataItem = e.panel?.rows?.[e.row]?.dataItem as Record<string, unknown> | undefined;
      // 데이터 셀 음수 = 빨강 (AS-IS NumberCellType.NegativeRed — 전 수치 셀 공통, 형제 FG 화면 동형).
      //   전 Measure 행 대상(아래 SHIP_PLAN_AMEND 게이트보다 먼저). 문자/코드 셀은 toGridNumber 가 0 으로
      //   떨어져 제외되고, 양수면 색을 원복한다(Wijmo 셀 DOM 재사용 색 누수 방지 — 공용 헬퍼 규약).
      if (e.panel?.cellType === CellType.Cell && dataItem) {
        paintNegativeText(e.cell, toGridNumber(dataItem[binding]));
      }
      if (!dataItem || s(dataItem.MEASURE) !== MEASURE.SHIP_PLAN_AMEND || !kind) return;
      if ((kind === 'D' || (kind === 'W' && bucketType === BUCKET_TYPE.WEEKLY)) && isCellFixed(fixedCells, dataItem, binding)) {
        // Fix 초록이 편집 노랑보다 우선 — DOM 재사용으로 남은 wj-cell-editable 잔상을 지우고 인라인 초록을 칠한다
        //   (foundation .wj-cell-editable 는 !important 가 없어 인라인이 이기지만, 잔상 클래스는 명시 제거).
        e.cell.classList.remove('wj-cell-editable');
        e.cell.style.backgroundColor = 'rgb(188,229,92)';
        return;
      }
      // 편집가능 셀 배경 — 전 화면 공통 노란 표준(공용 wj-cell-editable = $wj-editable-cell #fff8cd)으로 통일한다.
      //   종전에는 AS-IS FarPoint 입력밴드 색(회색 rgb(234,234,234), design 03 §2.2 R-G)을 재현했으나, 편집가능
      //   셀은 전 화면 공통으로 노란색이 표준(asis-parity-default-keep-common-standardization — 공통 표준은
      //   단일 화면만 AS-IS 로 되돌리지 않음)이라 노랑으로 맞춘다(사용자 지시 2026-11-12). 잠금 구간은 무색 유지
      //   (R-K 판정 false → 클래스 제거). 형제 화면 ShipmentPlanMainGrid(SSP) 와 동일한 클래스 토글 관용.
      e.cell.style.backgroundColor = '';
      e.cell.classList.toggle('wj-cell-editable', isMainCellEditable(binding, dataItem, editCtxRef.current));
    };
    g.formatItem.addHandler(formatItemHandler as never);

    // 인접 정보컬럼 세로 병합(SmartColMerge, R-I) — Freeze 경계(MEASURE_LABEL) 이전까지만.
    g.columns.forEach(col => {
      const binding = col.binding ?? '';
      col.allowMerging = binding !== '' && binding !== FREEZE_ANCHOR_COLUMN && !dynColKindOf(binding);
    });
    g.invalidate(true);

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastingCell?.removeHandler(pastingCellHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(cellEditEndedHandler);
        g.formatItem?.removeHandler(formatItemHandler as never);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns, dynamicColumns, bucketType, fixedCells, weekOrMonthStart, weekendByBinding]);

  // 월/주 SUM 헤더 더블클릭 드릴다운(G24) — AS-IS SpdMain_CellDoubleClick -> SpreadInfo.SetDblClickColumnShowHide(.cs:3783).
  //   컬럼을 재생성하지 않고 col.visible 만 덮는다. 오버라이드는 Bucket 변경/새 조회(dynColMetas 재생성) 시 비운다.
  //   AS-IS 는 클릭한 헤더 셀 텍스트가 'SUM' 일 때만 동작하므로 대/소분류 행 클릭은 무시한다.
  //   chkAll 가드(.cs:3771)는 TO-BE 가 chkAll 을 항상 true 로 고정해 구현하지 않는다.
  const drillVisRef = useRef<Map<string, boolean>>(new Map());
  const onBodCellClickRef = useRef(onBodCellClick);
  onBodCellClickRef.current = onBodCellClick;

  useEffect(() => {
    drillVisRef.current.clear();
  }, [bucketType, dynColMetas]);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 공용 DataGrid 가 컬럼 구성을 다시 적용하면 visible 이 기본값으로 돌아갈 수 있어 updatedLayout 마다 재적용한다.
    const applyDrill = () => {
      if (drillVisRef.current.size === 0) return;
      let changed = false;
      g.columns.forEach(col => {
        const want = drillVisRef.current.get(col.binding ?? '');
        if (want === undefined || col.visible === want) return;
        col.visible = want;
        changed = true;
      });
      if (changed) g.invalidate(true);
    };
    g.updatedLayout.addHandler(applyDrill);
    applyDrill();

    const dblClickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.ColumnHeader) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      const kind = dynColKindOf(binding);
      if (kind !== 'M' && kind !== 'W') return;
      if (String(ht.panel.getCellData(ht.row, ht.col, true) ?? '').toUpperCase() !== 'SUM') return;
      const dynCols = g.columns
        .filter(c => dynColKindOf(c.binding ?? '') !== null)
        .map(c => ({ binding: c.binding ?? '', visible: c.visible }));
      computeDrillToggles(binding, dynCols).forEach((visible, key) => drillVisRef.current.set(key, visible));
      applyDrill();
    };
    g.hostElement.addEventListener('dblclick', dblClickHandler);

    // TRANSPORT_MODE / FROM_SITE_NAME 셀 클릭 -> BOD Master 팝업(AS-IS SpdMain_CellClick .cs:1185-1209).
    //   Plan 편집가능 + Bucket != Monthly 일 때만. 시트 잠금(FN/TE·최신 SEQ 아님)은 부모가 본다.
    const clickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      const row = g.rows[ht.row]?.dataItem as MainRow | undefined;
      if (!row || !onBodCellClickRef.current) return;
      if (!editCtxRef.current.isEditable || editCtxRef.current.bucketType === String(BUCKET_TYPE.MONTHLY)) return;
      if (!canOpenBodPopup(row as Record<string, unknown>, binding)) return;
      onBodCellClickRef.current(row);
    };
    g.hostElement.addEventListener('click', clickHandler);

    return () => {
      try {
        g.updatedLayout?.removeHandler(applyDrill);
        g.hostElement?.removeEventListener('dblclick', dblClickHandler);
        g.hostElement?.removeEventListener('click', clickHandler);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, staticColumns, dynamicColumns]);

  // 동적 헤더 병합 키 — 매니저는 1회만 생성(super 가 grid 이벤트를 바인딩)하고 ref 로 최신 맵을 전달한다.
  const headerKeyMap = useMemo(() => {
    const map = new Map<string, HeaderKey>();
    dynColMetas.forEach(m => {
      map.set(m.binding, { ym: m.binding.slice(2, 8), sub: m.kind === 'M' ? 'SUM' : m.small || 'SUM' });
    });
    return map;
  }, [dynColMetas]);
  const headerKeyRef = useRef(headerKeyMap);
  headerKeyRef.current = headerKeyMap;

  useEffect(() => {
    const g = gridRef.current;
    if (!g || g.mergeManager instanceof ShipmentPlanFgHeaderMergeManager) return;
    g.mergeManager = new ShipmentPlanFgHeaderMergeManager(g as FlexGridType<WijmoRowItem>, () => headerKeyRef.current);
    g.invalidate(true);
  }, [gridRef, staticColumns, dynamicColumns]);

  // 헤더 총높이 고정 — 조회 전 1단, 조회 후 3단으로 바뀌어도 AS-IS 와 같은 총 48px 를 유지한다.
  //   공용 DataGrid 의 headerRowHeight 는 rows.defaultSize 만 세팅해 단수가 늘면 높이가 단수배로 커지므로,
  //   실제 헤더 행 수로 나눠 모든 헤더 행에 직접 적용한다(waterfall-shipment-plan-fg 동일 패턴).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const applyHeaderHeight = () => {
      const headerRows = g.columnHeaders?.rows;
      if (!headerRows || headerRows.length === 0) return;
      const targetHeight = HEADER_TOTAL_HEIGHT / headerRows.length;
      let changed = false;
      for (let i = 0; i < headerRows.length; i += 1) {
        if (Math.round(headerRows[i].height ?? headerRows.defaultSize) !== Math.round(targetHeight)) {
          headerRows[i].height = targetHeight;
          changed = true;
        }
      }
      if (Math.round(headerRows.defaultSize) !== Math.round(targetHeight)) {
        headerRows.defaultSize = targetHeight;
        changed = true;
      }
      if (changed) g.invalidate(true);
    };
    applyHeaderHeight();
    g.updatedLayout.addHandler(applyHeaderHeight);
    return () => {
      try {
        g.updatedLayout?.removeHandler(applyHeaderHeight);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, staticColumns, dynamicColumns]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={staticColumns}
      dynamicColumns={dynamicColumns as unknown as FlexGridColumnConfig[]}
      numberRules={numberRules}
      allowMerging={AllowMerging.All}
      gotFocus={onFocus}
    />
  );
};
