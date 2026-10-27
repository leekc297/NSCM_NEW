import { toggleClass } from '@mescius/wijmo';
import { AllowMerging, CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, type MutableRefObject } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils, paintNegativeText, toGridNumber } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import {
  BUCKET_TYPE,
  LBL,
  MAIN_EDITABLE_MEASURE,
  MAIN_GROUP_MERGE_COLUMNS,
  MAIN_GROUP_MERGE_KEYS,
  MENU_ID,
} from '../shipment-plan-mobility-it.constants';
import type { CalendarRow, MainRow } from '../shipment-plan-mobility-it.types';
import { useShipmentPlanMobilityItStore } from '../useShipmentPlanMobilityItStore';
import { isMainCellEditable } from '../utils/shipment-plan-mobility-it.editLock';
import { ShipmentPsiMergeManager } from '../utils/shipment-plan-mobility-it.merge';

interface Props {
  rows: MainRow[];
  calendar: CalendarRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  adminColumns?: RawFlexGridColumnConfig[];
  bucketType: BUCKET_TYPE;
  chkSum: boolean;
  // 편집 가능 = canEdit(hasButton('EDIT')) — AS-IS EditButton 토글 미이식(convert-core §2.4).
  editable: boolean;
  // Plan Date yyyymmdd(=plan start). 확정구간(회색) 경계는 이 값 + 행별 SHIP_FROZEN 으로 계산한다
  //   (AS-IS Re_Design/proc: SHIP_FROZEN=0 → planDate, >0 → planDate+SHIP_FROZEN-1). 고정 +20 아님.
  planDate: string;
  // 기간셀 더블클릭 드릴다운 (design 03 §3.F) — 페이지가 detail sheet 전환 + 재조회
  onDrilldown: (row: MainRow) => void;
  // BOH 'FIGURE' 정적열 더블클릭 드릴 (AS-IS L8109-8173) — measure 기준 Hold/Stock Detail 조회.
  onFigureDrilldown?: (row: MainRow) => void;
  // Memo(우클릭 코멘트, 엑셀 메모형) — WH_IN 행 D_ 셀에 코멘트 존재 여부(그리드 인디케이터/툴팁).
  memoOf?: (row: MainRow, binding: string) => string | undefined;
  // Production(PROD_PLAN) 노트 — 표시전용(파란 마커/툴팁). 값 있으면 생산수량(PRODUCT_QTY) 반환.
  prodNoteOf?: (row: MainRow, binding: string) => string | undefined;
  // WH_IN 행 D_ 셀 우클릭 "Memo" → 부모가 모달 오픈(셀 컨텍스트 전달).
  onMemo?: (cell: { row: MainRow; binding: string; whInQty: string; prodQty: string }) => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

type DynKind = 'D' | 'W' | 'M' | 'B';
const kindOf = (binding: string): DynKind | undefined =>
  binding.startsWith('D_')
    ? 'D'
    : binding.startsWith('W_')
      ? 'W'
      : binding.startsWith('M_')
        ? 'M'
        : binding.startsWith('B_')
          ? 'B'
          : undefined;

// Bucket/chkSum 표시규칙 (design 03 §2 — D_/W_/M_ 토글, B_ 텍스트는 항상 표시)
const isDynVisible = (kind: DynKind, bucket: BUCKET_TYPE, chkSum: boolean): boolean => {
  if (kind === 'B') return true;
  if (bucket === BUCKET_TYPE.DAILY) return kind === 'D' ? true : chkSum;
  if (bucket === BUCKET_TYPE.WEEKLY) return kind === 'D' ? false : kind === 'W' ? true : chkSum;
  return kind === 'M';
};

// master PSI 그리드 — base 프레임 17열(admin 메타) + D_/W_/M_/B_ 동적(서버 wide + calendar 3단 헤더).
//   편집 표면 = WH_IN 측정치 행의 D_ 기간셀만(design 03 §3.A). W_/M_ Sum·B_ 텍스트는 잠금.
export const ShipmentPsiMainGrid = ({
  rows,
  calendar,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  adminColumns,
  bucketType,
  chkSum,
  editable,
  planDate,
  onDrilldown,
  onFigureDrilldown,
  memoOf,
  prodNoteOf,
  onMemo,
}: Props) => {
  const { t } = useTranslation();
  const columns = adminColumns ?? [];

  // Sum 토글은 컬럼 재생성 없이 imperative 로 반영(스크롤/폭 보존, 헤더 SUM 병합 유지) —
  //   빌드 시점 초기 visible 계산만 최신값을 참조하고, 토글 자체는 아래 applyDynVisibility 가 flip.
  //   (MktFcstGrid sumYnRef 동일 패턴 — chkSum 을 dynamicColumns dep 에 두면 매 토글 전 컬럼 재생성.)
  const chkSumRef = useRef(chkSum);
  chkSumRef.current = chkSum;

  const dynColMetas = useMemo(() => {
    const titleRows = calendar.filter(r => !!kindOf(str(r.COLUMN_NAME)));
    if (titleRows.length > 0) {
      return titleRows
        .map(r => ({
          binding: str(r.COLUMN_NAME),
          kind: kindOf(str(r.COLUMN_NAME)) as DynKind,
          large: str(r.LARGE_CLASS_LABEL_NAME),
          small: str(r.SMALL_CLASS_LABEL_NAME),
          leaf: str(r.COLUMN_LABEL_NAME),
          dayCode: str(r.DAY_CODE),
          sort: str(r.SORT_ORDER_NO),
        }))
        .sort((a, b) => a.sort.localeCompare(b.sort));
    }
    const set = new Set<string>();
    rows.forEach(r => {
      Object.keys(r).forEach(k => {
        if (kindOf(k)) set.add(k);
      });
    });
    return [...set].sort().map(b => ({
      binding: b,
      kind: kindOf(b) as DynKind,
      large: b.slice(2, 8),
      small: '',
      leaf: b.slice(8),
      dayCode: '',
      sort: b,
    }));
  }, [calendar, rows]);

  // 토(Blue)/일(Red) 헤더색 (design 03 §3.C)
  const dayColorRef = useRef<Map<string, string>>(new Map());
  dayColorRef.current = useMemo(() => {
    const m = new Map<string, string>();
    dynColMetas.forEach(meta => {
      if (meta.kind !== 'D') return;
      const code = meta.dayCode.toUpperCase();
      if (code.startsWith('SAT') || code === '7') m.set(meta.binding, 'blue');
      else if (code.startsWith('SUN') || code === '1') m.set(meta.binding, 'red');
    });
    return m;
  }, [dynColMetas]);

  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    if (dynColMetas.length === 0) return [];
    type LeafCol = FlexGridColumnConfig & { binding: string };
    const largeMap = new Map<string, { label: string; subs: Map<string, LeafCol[]>; order: number }>();
    const kindRank: Record<DynKind, number> = { M: 0, W: 1, D: 2, B: 3 };
    dynColMetas.forEach((m, idx) => {
      const ymKey = m.binding.slice(2, 8);
      let bucket = largeMap.get(ymKey);
      if (!bucket) {
        bucket = { label: m.large || ymKey, subs: new Map(), order: idx };
        largeMap.set(ymKey, bucket);
      }
      const subKey = m.kind === 'M' ? 'SUM' : (m.small || 'SUM').trim() || 'SUM';
      if (!bucket.subs.has(subKey)) bucket.subs.set(subKey, []);
      bucket.subs.get(subKey)?.push({
        binding: m.binding,
        header: m.kind === 'D' ? m.leaf || 'SUM' : m.kind === 'B' ? m.leaf : 'SUM',
        align: m.kind === 'B' ? 'left' : 'right',
        width: 80,
        allowMerging: false,
        allowSorting: false,
        visible: isDynVisible(m.kind, bucketType, chkSumRef.current),
        _inputEditType: CELL_INPUT_EDIT_TYPE.OPTIONAL,
        _display: true,
      });
    });
    const subOrder = (k: string): number => (k === 'SUM' ? Number.NEGATIVE_INFINITY : Number(k.replace(/\D/g, '') || 0));
    const leafKind = (b: string): DynKind => kindOf(b) ?? 'D';
    return [...largeMap.values()]
      .sort((a, b) => a.order - b.order)
      .map(bucket => ({
        header: bucket.label,
        align: 'center',
        allowSorting: false,
        allowMerging: false,
        columns: [...bucket.subs.entries()]
          .sort(([a], [b]) => subOrder(a) - subOrder(b))
          .map(([subLabel, leafCols]) => ({
            header: subLabel,
            align: 'center',
            allowSorting: false,
            allowMerging: false,
            columns: leafCols.sort(
              (a, b) =>
                kindRank[leafKind(a.binding)] - kindRank[leafKind(b.binding)] ||
                a.binding.localeCompare(b.binding)
            ),
          })),
      }));
    // chkSum 은 의도적으로 제외(chkSumRef 로 초기값만 참조) — Sum 토글은 applyDynVisibility 가 재생성 없이 flip.
  }, [dynColMetas, bucketType]);

  // 동적 컬럼 binding 순서(드릴다운 span 보행 기준 — SP 수신/정렬 순서 그대로, M/W/D interleave).
  const dynBindings = useMemo<string[]>(() => dynColMetas.map(m => m.binding), [dynColMetas]);
  // 헤더 더블클릭 드릴 오버라이드(binding → visible). bucket/chkSum 변경 시 리셋(AS-IS SetSpreadColumn 재실행).
  const drillVisRef = useRef<Map<string, boolean>>(new Map());
  const applyDynVisibilityRef = useRef<(() => void) | null>(null);
  // 동적 헤더 SUM 병합 매니저 설치 표식 — grid 인스턴스당 1회만 래핑(체인 무한 증식 방지).
  const mergeWrappedRef = useRef<FlexGridType | null>(null);

  const setActiveGrid = useShipmentPlanMobilityItStore(s => s.setActiveGrid);
  const setActiveGridRef = useRef(setActiveGrid);
  setActiveGridRef.current = setActiveGrid;
  const editableRef = useRef(editable);
  editableRef.current = editable;
  // 확정구간(회색) — AS-IS Re_Design SetBGColor2(startIdx~D_confirmDay) 밴드. 경계(confirmDay)는 고정
  //   +20 이 아니라 행별 SHIP_FROZEN 으로 정한다(사내 proc CASE L5040-5043 / Re_Design L2794와 동일):
  //     SHIP_FROZEN = 0 → confirmDay = planDate,  > 0 → planDate + SHIP_FROZEN - 1.
  //   SP 컬럼순(dynBindings)에서 confirmDay 이하 마지막 D_ index 까지(사이 W_/M_ Sum·B_ 포함) 회색.
  //   binding → dynBindings index.
  const dynIndexMap = useMemo(() => {
    const m = new Map<string, number>();
    dynBindings.forEach((b, i) => m.set(b, i));
    return m;
  }, [dynBindings]);
  const dynIndexMapRef = useRef(dynIndexMap);
  dynIndexMapRef.current = dynIndexMap;
  // D_ 컬럼의 (index, yyyymmdd) — confirmDay 이하 마지막 index(회색 cutoff) 계산용.
  const dynDList = useMemo(
    () =>
      dynBindings
        .map((b, i) => ({ i, d: b.startsWith('D_') ? b.slice(2) : '' }))
        .filter(x => x.d !== ''),
    [dynBindings]
  );
  const dynDListRef = useRef(dynDList);
  dynDListRef.current = dynDList;
  const planDateRef = useRef(planDate);
  planDateRef.current = planDate;
  // confirmDay(yyyymmdd) → 회색 cutoff index 캐시(행별 SHIP_FROZEN 종류가 적어 재사용).
  //   dynDList(컬럼 구성) 바뀌면 render 중 동기 무효화 — 같은 렌더의 formatItem 이 stale cutoff 를 쓰지 않도록.
  const greyCutoffCacheRef = useRef<Map<string, number>>(new Map());
  const dynDListIdRef = useRef(dynDList);
  if (dynDListIdRef.current !== dynDList) {
    dynDListIdRef.current = dynDList;
    greyCutoffCacheRef.current = new Map();
  }
  // planDate + days → yyyymmdd (확정구간 경계 산정).
  const addYmd = (ymd: string, days: number): string => {
    if (!/^\d{8}$/.test(ymd)) return ymd;
    const dt = new Date(Number(ymd.slice(0, 4)), Number(ymd.slice(4, 6)) - 1, Number(ymd.slice(6, 8)));
    dt.setDate(dt.getDate() + days);
    const mm = String(dt.getMonth() + 1).padStart(2, '0');
    const dd = String(dt.getDate()).padStart(2, '0');
    return `${dt.getFullYear()}${mm}${dd}`;
  };
  // 행 SHIP_FROZEN → confirmDay → 회색 cutoff index.
  const greyCutoffForRow = (shipFrozen: number): number => {
    const pd = planDateRef.current;
    if (!pd) return -1;
    const confirmDay = shipFrozen > 0 ? addYmd(pd, shipFrozen - 1) : pd;
    const cache = greyCutoffCacheRef.current;
    const hit = cache.get(confirmDay);
    if (hit !== undefined) return hit;
    let cut = -1;
    for (const { i, d } of dynDListRef.current) if (d <= confirmDay) cut = Math.max(cut, i);
    cache.set(confirmDay, cut);
    return cut;
  };
  const onDrilldownRef = useRef(onDrilldown);
  onDrilldownRef.current = onDrilldown;
  const onFigureDrilldownRef = useRef(onFigureDrilldown);
  onFigureDrilldownRef.current = onFigureDrilldown;
  const memoOfRef = useRef(memoOf);
  memoOfRef.current = memoOf;
  const prodNoteOfRef = useRef(prodNoteOf);
  prodNoteOfRef.current = prodNoteOf;
  const onMemoRef = useRef(onMemo);
  onMemoRef.current = onMemo;

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 병합 매니저 — DataGrid 공용 매니저를 감싸 (a) 선행 식별 컬럼 데이터셀 계층 세로병합
    //   (b) 동적 M_/W_/D_ 헤더 병합(년월/주차 가로 · M_ SUM 세로) 전담. 정적 헤더·그 외는 delegate.
    //   (DM MktFcst HierarchicalMergeManager 1:1 — 사용자 요구 "DM 화면과 동일" 2026-09-30). grid 인스턴스당 1회 래핑.
    if (mergeWrappedRef.current !== g) {
      g.mergeManager = new ShipmentPsiMergeManager(g.mergeManager);
      mergeWrappedRef.current = g;
    }
    const mergeManager = g.mergeManager as ShipmentPsiMergeManager;
    mergeManager.groupBindings = MAIN_GROUP_MERGE_COLUMNS;
    mergeManager.groupKeyBindings = MAIN_GROUP_MERGE_KEYS;

    // 병합 대상 컬럼(allowMerging) + 계층 키(fixedBindings) 갱신 — 동적(M_/W_/D_/B_)·MEASURE(측정치 행라벨)를
    //   제외한 선행 식별 컬럼(Div/From Site/Model/Nick Name/BOH/TYPE/FIGURE …)을 값이 같은 연속 행끼리 세로병합한다.
    //   updatedLayout 마다 재적용(컬럼 재구성·division 전환 대응).
    //   FIGURE(BOH)도 병합한다 — AS-IS: TYPE 비면 FIGURE 도 비고 TYPE/FIGURE 병합(사용자 확인 2026-10-08).
    //   stock 행(TYPE=Hold 등)은 TYPE 값이 달라 병합 체인이 끊겨 자기 셀이 되므로 FIGURE 더블클릭 드릴은
    //   그 행을 그대로 짚는다(hitTest 는 병합 셀 안에서도 실제 행 index 를 돌려준다).
    const applyMerge = () => {
      const fixed: string[] = [];
      g.columns.forEach(col => {
        const b = col.binding ?? '';
        const mergeable = !!b && !/^[MWDB]_/.test(b) && b !== 'MEASURE';
        col.allowMerging = mergeable;
        if (mergeable) fixed.push(b);
      });
      mergeManager.fixedBindings = fixed;
    };
    g.updatedLayout.addHandler(applyMerge);
    applyMerge();

    const beginningEditHandler = (
      sender: FlexGridType,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      if (!isMainCellEditable(row, binding, editableRef.current)) {
        e.cancel = true;
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // 붙여넣기도 동일 게이트 — 공용 pastingCell(setEditableColumns)은 _inputEditType=OPTIONAL 이라
    //   W_/M_ 합계·과거 셀까지 허용한다. 편집 불가 셀에 값이 덮이는 것을 막는다(편집 게이트와 세트).
    const pastingCellHandler = (
      sender: FlexGridType,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      if (!isMainCellEditable(row, binding, editableRef.current)) {
        e.cancel = true;
      }
    };
    g.pastingCell.addHandler(pastingCellHandler);

    const formatItemHandler = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (e.panel === sender.columnHeaders) {
        const color = dayColorRef.current.get(binding);
        if (color) e.cell.style.color = color;
        return;
      }
      if (e.panel !== sender.cells) return;
      // 음수 = 빨간 글자 (AS-IS NegativeRed 전역 파리티 — 전 셀 공통. 정본 paintNegativeText).
      //   필수: 분기 return 앞에서 전 셀에 1회 적용해야 재활용 잔상이 안 남는다. 값 원천은 실제
      //   그리는 원값(getCellData false). 문자/코드/날짜 셀은 toGridNumber 가 0 을 돌려 음수판정에서 빠진다.
      paintNegativeText(e.cell, toGridNumber(sender.cells.getCellData(e.row, e.col, false)));
      // Model(ITEM_ID) 그룹 경계선 — ITEM_ID 가 이전 행과 다른 행 상단에만 검정 1px 실선을 ITEM_ID 열부터
      //   끝까지 긋는다 (AS-IS SSP0015.cs L2781-2787 Border=BevelBorder 검정 top 1px). 그룹 '사이'만 —
      //   최상단(첫 행)·최하단 바깥엣지는 긋지 않는다(사용자 요구 2026-10-08, AS-IS 는 첫 행도 그음).
      //   ITEM_ID 왼쪽 식별열은 제외(AS-IS 동일, 그쪽은 세로병합으로 구분). 경계 아닌 셀은 지운다(재사용 잔상 방지).
      const itemCol = sender.getColumn('ITEM_ID');
      const itemIdx = itemCol ? itemCol.index : -1;
      if (itemIdx >= 0 && e.col >= itemIdx) {
        const curItem = str(
          (GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined)?.ITEM_ID
        );
        const prevItem =
          e.row > 0
            ? str((GridUtils.getRow(sender, e.row - 1) as Record<string, unknown> | undefined)?.ITEM_ID)
            : undefined;
        if (e.row > 0 && prevItem !== curItem) e.cell.style.borderTop = '1px solid #000';
        else e.cell.style.removeProperty('border-top');
      }
      // BOH FIGURE — TYPE 이 빈 행은 FIGURE 도 빈칸 (AS-IS: TYPE 없으면 FIGURE 없음·TYPE/FIGURE 병합).
      //   SP 가 FIGURE 에 "0" 을 채워 와도 TYPE 가 공백이면 숨긴다(BOH 없음). TYPE 값이 있으면 그대로 표시.
      if (binding === 'FIGURE') {
        const figRow = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
        if (str(figRow?.TYPE).trim() === '') e.cell.textContent = '';
        return;
      }
      // 동적 기간 컬럼(D_/W_/M_/B_)만 편집표시/회색을 관리한다 — 정적 17열은 공용 formatEditableColumns
      //   (INPUT_TP_CD 기준)에 맡긴다(정적 편집컬럼의 표시를 덮어쓰지 않도록).
      if (!kindOf(binding)) return;
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      // 회색(확정구간) — 행별 SHIP_FROZEN 기반 confirmDay cutoff index 까지. 이 셀 binding index 가 그
      //   이하면 회색(AS-IS Re_Design 밴드). SHIP_FROZEN 없으면 0 → confirmDay=planDate.
      const shipFrozen = Number(str(row?.SHIP_FROZEN)) || 0;
      const greyCutoff = greyCutoffForRow(shipFrozen);
      const myDynIdx = dynIndexMapRef.current.get(binding) ?? -1;
      const isGrey = myDynIdx >= 0 && greyCutoff >= 0 && myDynIdx <= greyCutoff;
      const cellEditable = isMainCellEditable(row, binding, editableRef.current);
      // 편집 가능 = Yellow(wj-cell-editable) 우선 — WH_IN 행 D_ 는 과거(확정구간)여도 편집 가능하므로 노란색
      //   (AS-IS WH_IN 행 전 기간 unlock, 사용자 요구 2026-09-30 "회색말고 노란색"). 회색(wj-cell-non-editable,
      //   확정구간+SUM)은 편집 불가 셀에만. 공용 formatEditableColumns 가 전 동적셀에 붙인 editable 클래스를 재지정.
      toggleClass(e.cell, 'wj-cell-editable', cellEditable);
      toggleClass(e.cell, 'wj-cell-non-editable', isGrey && !cellEditable);
      // Memo(엑셀 메모형) — WH_IN 행 D_ 셀에만 코너 마커(wj-cell-memo) + hover 툴팁.
      //   코멘트 키(DIVISION/SITE/ITEM/YYYYMMDD)에 MEASURE 가 없어 memoOf 는 같은 날짜의 모든 측정치 행에
      //   매칭된다 → 반드시 WH_IN 행으로 한정해야 한다(저장/우클릭 대상과 동일 측정치).
      const isMemoRow = str(row?.MEASURE) === MAIN_EDITABLE_MEASURE;
      const memo = isMemoRow ? memoOfRef.current?.(row as unknown as MainRow, binding) : undefined;
      const hasMemo = !!memo;
      toggleClass(e.cell, 'wj-cell-memo', hasMemo);
      if (hasMemo) e.cell.title = memo ?? '';
      // Production(PROD_PLAN) 노트 — 표시전용 파란 코너 마커(wj-cell-prodnote) + 툴팁(PRODUCT_QTY).
      //   AS-IS SetProdNote_Display(L2994, NoteIndicatorColor=Blue): 등록 없이 생산수량을 노트로만 보여준다
      //   (WH_IN 빨간 메모와 달리 읽기전용). 키(DIVISION/SITE/ITEM/YYYYMMDD) 특성상 PROD_PLAN 행으로 한정.
      const isProdNoteRow = str(row?.MEASURE) === 'PROD_PLAN';
      const prodNote = isProdNoteRow
        ? prodNoteOfRef.current?.(row as unknown as MainRow, binding)
        : undefined;
      const hasProdNote = !!prodNote;
      toggleClass(e.cell, 'wj-cell-prodnote', hasProdNote);
      if (hasProdNote) e.cell.title = prodNote ?? '';
      // PROD_DATE/LOT 측정치 행 특수 셀표시 (design 03 §2·§3.C L2670/2674/2678 — gap-resolve I14).
      //   PROD_DATE = 날짜텍스트(center), LOT = 텍스트(center)이며 빈값/"0" 은 공백표시.
      //   Production(PROD_PLAN)/Production Date(PROD_DATE) 는 데이터 없음(빈/"0")을 공백으로 둔다 —
      //   AS-IS 는 no-data 가 null 이라 공백(날짜/FPNumber), TO-BE SP 가 0 을 채워 와 0 으로 보이던 것을
      //   표시단에서 공백 처리(사용자 요구 2026-10-08). 수량 0 과 무데이터를 구분하지 않는다(PSI 표기 관행).
      const measure = str(row?.MEASURE);
      if (measure === 'LOT') {
        e.cell.style.textAlign = 'center';
        const txt = (e.cell.textContent ?? '').trim();
        if (txt === '' || txt === '0') e.cell.textContent = '';
      } else if (measure === 'PROD_DATE') {
        e.cell.style.textAlign = 'center';
        const txt = (e.cell.textContent ?? '').trim();
        if (txt === '' || txt === '0') e.cell.textContent = '';
      } else if (kindOf(binding) !== 'B') {
        // 숫자 측정치 셀(D_/W_/M_, LOT/PROD_DATE·B_텍스트 제외) — 천단위 콤마 표시.
        //   정수부에만 콤마를 넣고 소수부는 원본 유지(toLocaleString 기본 3자리 반올림 회피).
        const raw = (e.cell.textContent ?? '').trim().replace(/,/g, '');
        if (measure === 'PROD_PLAN' && (raw === '' || raw === '0')) {
          e.cell.textContent = '';
        } else if (/^-?\d+(\.\d+)?$/.test(raw)) {
          const [intPart, decPart] = raw.split('.');
          const withComma = intPart.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
          e.cell.textContent = decPart !== undefined ? `${withComma}.${decPart}` : withComma;
        }
      }
    };
    g.formatItem.addHandler(formatItemHandler);

    // 더블클릭 — (1) 컬럼 헤더: 기간 드릴다운 / (2) 데이터 셀: detail 드릴다운.
    const dblClickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);

      // (1) 헤더 더블클릭 → 기간 드릴다운 (AS-IS SetDblClickColumnShowHide, SpreadInfo.cs L10838~10885 1:1):
      //   M_ 헤더 = 그 달 구간(다음 M_ 전까지) W_ 토글 + 보이는 D_ 접기 / W_ 헤더 = 그 주 구간 D_ 토글.
      //   Monthly bucket 에서 M_ 헤더를 더블클릭하면 해당 월의 주(W_)가 펼쳐진다.
      if (ht.cellType === CellType.ColumnHeader) {
        const hb = g.columns[ht.col]?.binding ?? '';
        const hk = kindOf(hb);
        if (hk !== 'M' && hk !== 'W') return;
        const idx = dynBindings.indexOf(hb);
        if (idx < 0) return;
        const flip = (target: string, hideOnly: boolean) => {
          const col = g.getColumn(target);
          if (!col) return;
          if (hideOnly && !col.visible) return; // M 드릴: 보이는 D_ 만 접는다(AS-IS 동일)
          drillVisRef.current.set(target, hideOnly ? false : !col.visible);
        };
        for (let i = idx + 1; i < dynBindings.length; i++) {
          const t = dynBindings[i];
          const tk = kindOf(t);
          if (hk === 'M') {
            if (tk === 'M') break;
            if (tk === 'W') flip(t, false);
            else if (tk === 'D') flip(t, true);
          } else {
            if (tk === 'W' || tk === 'M') break;
            if (tk === 'D') flip(t, false);
          }
        }
        applyDynVisibilityRef.current?.();
        return;
      }

      // (2) 기간셀 더블클릭 → measure 분기 drill/memo (design 03 §3.F / AS-IS SpdMain_CellDoubleClick).
      //   AS-IS 는 IsLock==true(잠긴 셀)에서만 drill/memo 하고 unlock 셀의 더블클릭은 편집이다. TO-BE 는
      //   EditButton lock 토글 미이식(convert-core §2.4)이라 "그 셀이 편집 가능한가"로 대체한다 —
      //   편집 가능 셀(= WH_IN 최신 Plan D_)만 Wijmo 편집에 맡기고(return), 그 외 잠긴 셀은 drill/memo.
      //   주의: 전역 editable 로 끊으면 SHIP_CONFIRM 등 '편집 불가'인데도 최신 Plan 에서 drill 이 막힌다
      //   (실사고 2026-10-08 — 사용자: Shipment Confirm 더블클릭 조회 안됨). 반드시 per-cell 판정으로 끊는다.
      if (g.rows.length === 0) return;
      if (ht.cellType !== CellType.Cell) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      const row = GridUtils.getRow(g, ht.row) as MainRow | undefined;
      if (!row) return;
      // BOH 'FIGURE' 정적열 더블클릭 → measure 기준 stock detail 드릴 (AS-IS L8109-8173). TYPE=Hold 행
      //   (= MES_FCS_RELEASE)→Hold stock, WH_STOCK/BALANCE→Stock Detail. FIGURE 는 정적열이라 항상 잠김 →
      //   편집 모드 무관(AS-IS IsLock 기본 잠금과 동일). figureDrilldownOf 미매핑 measure 는 페이지에서 no-op.
      if (binding === 'FIGURE') {
        onFigureDrilldownRef.current?.(row);
        return;
      }
      if (!kindOf(binding)) return;
      if (isMainCellEditable(row, binding, editableRef.current)) return; // 편집 가능 셀 = 편집(드릴/메모 아님)
      // WH_IN(WH in Plan) 잠긴 기간셀(이전 Plan·EDIT 권한없음) 더블클릭 → Comments(memo) 팝업 (AS-IS
      //   SpdMain_CellDoubleClick L8177 — WH_IN 은 drill 이 아니라 코멘트 팝업). 우클릭 Memo 와 동일 경로. D_ 만.
      if (str(row.MEASURE) === MAIN_EDITABLE_MEASURE && binding.startsWith('D_') && onMemoRef.current) {
        const whInQty = str(g.getCellData(ht.row, ht.col, false));
        const prodQty = str(g.getCellData(ht.row + 1, ht.col, false));
        onMemoRef.current({ row, binding, whInQty, prodQty });
        return;
      }
      onDrilldownRef.current(row);
    };
    g.hostElement.addEventListener('dblclick', dblClickHandler);

    const clickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      setActiveGridRef.current('main');
    };
    g.hostElement.addEventListener('click', clickHandler);

    return () => {
      try {
        g.updatedLayout?.removeHandler(applyMerge);
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastingCell?.removeHandler(pastingCellHandler);
        g.formatItem?.removeHandler(formatItemHandler);
        g.hostElement?.removeEventListener('dblclick', dblClickHandler);
        g.hostElement?.removeEventListener('click', clickHandler);
      } catch {
        // unmount race
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns, dynamicColumns]);

  // 드릴 상태 리셋 — bucket 변경(= AS-IS SetSpreadColumn 재실행)에만. Sum 토글은 드릴을 보존한다
  //   (Monthly 에서 드릴 펼친 뒤 Sum 체크하면 Monthly 로 접히던 문제 교정 — 2026-09-29).
  useEffect(() => {
    drillVisRef.current.clear();
  }, [bucketType, dynBindings]);

  // 코멘트(memoOf) 로드/변경 시 그리드 재도색 — formatItem 이 메모 인디케이터/툴팁을 다시 반영한다
  //   (코멘트 조회가 master 조회와 별개로 늦게 도착해도 마커가 뜨도록).
  useEffect(() => {
    gridRef.current?.invalidate();
  }, [memoOf, gridRef]);

  // Sum 체크박스 + 헤더 드릴다운 통합 적용 (AS-IS SetSpreadColumn + SetDblClickColumnShowHide 1:1).
  //   규칙: isDynVisible(base) 위에 드릴 오버라이드(drillVisRef) 우선. 컬럼 재생성 없이 imperative flip
  //   이라 스크롤/컬럼폭 보존. DataGrid 의 columnGroups 재적용이 visible 을 덮을 수 있어 updatedLayout
  //   마다 재적용하고, 바뀐 게 있으면 invalidate 로 헤더 SUM 병합까지 다시 그린다(MktFcstGrid 동일 패턴).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const dynSet = new Set(dynBindings);
    const applyDynVisibility = () => {
      let changed = false;
      for (let i = 0; i < g.columns.length; i++) {
        const col = g.columns[i];
        const b = col.binding ?? '';
        if (!dynSet.has(b)) continue;
        const base = isDynVisible(kindOf(b) as DynKind, bucketType, chkSum);
        const want = drillVisRef.current.get(b) ?? base;
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
        // unmount race
      }
    };
  }, [bucketType, chkSum, dynBindings, gridRef]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      dynamicColumns={dynamicColumns}
      comboParams={{ mnuId: `'${MENU_ID}'` }}
      // 우클릭 컨텍스트 메뉴 — WH_IN 행 D_ 셀에서만 "Memo"(엑셀 메모형) 추가. 그 외 셀은 공용 메뉴 그대로.
      contextMenuItems={ctx => {
        const b = ctx.grid.columns[ctx.hitCol]?.binding ?? '';
        if (!b.startsWith('D_')) return [];
        const row = GridUtils.getRow(ctx.grid, ctx.hitRow) as MainRow | undefined;
        if (!row || str(row.MEASURE) !== MAIN_EDITABLE_MEASURE || !onMemoRef.current) return [];
        return [
          {
            label: t(LBL.MEMO, 'Memo'),
            action: () => {
              const whInQty = str(ctx.grid.getCellData(ctx.hitRow, ctx.hitCol, false));
              const prodQty = str(ctx.grid.getCellData(ctx.hitRow + 1, ctx.hitCol, false));
              onMemoRef.current?.({ row, binding: b, whInQty, prodQty });
            },
          },
        ];
      }}
      // Cells 만 주면 컬럼 헤더 병합이 꺼져(CustomMergeManager 는 grid.allowMerging 정확일치로 판정)
      //   self-label 그룹(Div/Div…)이 부모·자식 2행으로 중복되고 BOH 그룹이 갈라진다. All 이어야
      //   헤더 병합(그룹 셀 span) + 셀 병합(TYPE/PSI_NAME 세로병합, col.allowMerging) 둘 다 동작.
      allowMerging={AllowMerging.All}
    />
  );
};
