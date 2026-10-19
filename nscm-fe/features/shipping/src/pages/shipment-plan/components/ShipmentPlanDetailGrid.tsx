import { Aggregate } from '@mescius/wijmo';
import {
  AllowMerging,
  CellType,
  GroupRow,
  type FlexGrid as FlexGridType,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils, paintNegativeText, toGridNumber } from '@foundation/utils';
import { DataGrid, TabItem, TabWrapper } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  FOOTER_SUM_RANGE,
  MENU_ID,
  MSG,
  SHEETS,
  SO_GROUP_PROPAGATE_COLUMNS,
} from '../shipment-plan.constants';
import { useShipmentPlanStore } from '../useShipmentPlanStore';
import { createSameCellDblClickGuard } from '../utils/shipment-plan.dblClickGuard';
import { DETAIL_SHEETS } from '../utils/shipment-plan.detailSheets';
import {
  buildBtnNewLockedBindings,
  isDetailCellEditable,
} from '../utils/shipment-plan.editLock';
import {
  LOOKUP_COLUMN,
  stripComboMeta,
  useShipmentPlanLookups,
} from '../utils/shipment-plan.lookups';

import type { OrderDetailContext } from './modals/OrderDetailModal';

interface Props {
  rowsBySheet: Partial<Record<SHEETS, WijmoRowItem[]>>;
  gridRefs: Partial<Record<SHEETS, MutableRefObject<FlexGridType | undefined>>>;
  gridFilterRefs: Partial<Record<SHEETS, MutableRefObject<FlexGridFilter | undefined>>>;
  editTrackerRefs: Partial<Record<SHEETS, MutableRefObject<EditTracker | undefined>>>;
  staticColumns: Partial<Record<SHEETS, RawFlexGridColumnConfig[]>>;
  // Detail 편집 가능 여부 = canEdit(hasButton('EDIT'))·최신Plan(realFlag). 셀 단위 범위는 isDetailCellEditable.
  //   AS-IS EditButton 토글 미이식(convert-core §2.4) — 편집 기본 ON, 권한은 마운트 1회 판정.
  editable: boolean;
  // 셀 상호작용 콜백 (03 §3-D) — 페이지가 모달 오픈 소유
  onItemCellSearch: (row: WijmoRowItem) => void; // ITEM_ID 더블클릭(신규행 한정)
  onProjectCellSearch: (row: WijmoRowItem) => void; // PROJECT_CODE 더블클릭(신규행 한정)
  onConfirmDetail: (changeReqNo: string) => void; // CHANGE_REQ_NO 클릭
  onOrderDetail: (ctx: OrderDetailContext) => void; // ERP_SO_NO 더블클릭(SSP0300)
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// Detail 헤더 행 최소 높이(px) — 자동 측정값이 이보다 작아도 이 아래로는 줄이지 않는다.
//   공용 1단 헤더 표준(`HEIGHT_BY_COLUMN_DEPTH.ONE_DEPTH`)과 같은 48 이 기본이고(사용자 지시
//   2026-10-06 "24면 48로 다시"), 라벨이 더 필요하면 자동 측정값이 이 위로 올라간다(짤림 0).
const MIN_HEADER_ROW_HEIGHT = 48;

// 합계행 좌하단 라벨 — AS-IS `ColumnFooter.Cells[0,1].Value = "Sum"`(cs L803).
const FOOTER_SUM_LABEL = 'Sum';

// 가로 스크롤바 높이(px) — Sum 푸터를 바닥 고정할 때 이만큼 위로 올려 스크롤바 자리를 비운다.
//   스크롤바가 안 떠 있을 땐 실측(offsetHeight-clientHeight)이 0 이라 이 표준값으로 예약한다.
const HSCROLLBAR_HEIGHT = 17;

// Detail 8-sheet(탭 노출 7) 그리드 — sheet별 컬럼셋은 admin SCM_MST_SHEET_COLUMNS 메타(196컬럼 실측)가
//   단일 원천(#130 — 수기 전사 금지). 편집 화이트리스트/파생/SO그룹 전파는 코드 재현(03 §3-B/C).
//   탭 전환은 조회를 자동 발사하지 않는다 — 2차 Search 버튼/Main 드릴다운만 조회 트리거(AS-IS parity, hook #81).
export const ShipmentPlanDetailGrid = ({
  rowsBySheet,
  gridRefs,
  gridFilterRefs,
  editTrackerRefs,
  staticColumns,
  editable,
  onItemCellSearch,
  onProjectCellSearch,
  onConfirmDetail,
  onOrderDetail,
}: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const activeDetailSheet = useShipmentPlanStore(s => s.activeDetailSheet);
  const setActiveDetailSheet = useShipmentPlanStore(s => s.setActiveDetailSheet);
  const setActiveGrid = useShipmentPlanStore(s => s.setActiveGrid);

  const editableRef = useRef(editable);
  editableRef.current = editable;

  // 셀 콤보 lookup code->name (runtime-parity §3.2 H2) — 표시 3종 formatItem, 편집 CHANGE_REASON_CODE 는 DataMap.
  const { fcstTypeMap, shipmentStatusMap, stockStatusMap, changeReasonDataMap } =
    useShipmentPlanLookups();
  const fcstTypeMapRef = useRef(fcstTypeMap);
  fcstTypeMapRef.current = fcstTypeMap;
  const shipmentStatusMapRef = useRef(shipmentStatusMap);
  shipmentStatusMapRef.current = shipmentStatusMap;
  const stockStatusMapRef = useRef(stockStatusMap);
  stockStatusMapRef.current = stockStatusMap;

  // lookup 주입 컬럼의 자동 콤보 메타를 벗긴다 — 빈 dataMap(@lookupType 미해소)이 화면 주입
  //   formatItem/DataMap 과 충돌(로딩 중 공백 깜빡임 등)하는 것을 막는다. PlanDetail 3종 + oWMS 1종.
  const columnsBySheet = useMemo(() => {
    const out: Partial<Record<SHEETS, RawFlexGridColumnConfig[]>> = { ...staticColumns };
    out[SHEETS.PLAN_DETAIL] = stripComboMeta(
      staticColumns[SHEETS.PLAN_DETAIL],
      new Set([
        LOOKUP_COLUMN.FCST_TYPE,
        LOOKUP_COLUMN.SHIPMENT_STATUS,
        LOOKUP_COLUMN.CHANGE_REASON_CODE,
      ])
    );
    out[SHEETS.OWMS_DETAIL] = stripComboMeta(
      staticColumns[SHEETS.OWMS_DETAIL],
      new Set([LOOKUP_COLUMN.STOCK_STATUS])
    );
    return out;
  }, [staticColumns]);

  const activeIndex = Math.max(DETAIL_SHEETS.indexOf(activeDetailSheet), 0);

  // PlanDetail 전용 이벤트 배선 (03 §3-B/C/D)
  const planDetailGridRef = gridRefs[SHEETS.PLAN_DETAIL];
  const planDetailColumns = staticColumns[SHEETS.PLAN_DETAIL];
  useEffect(() => {
    const g = planDetailGridRef?.current;
    if (!g) return;

    // 더블클릭 판정기 — 수명이 아래 click/dblclick 리스너와 같아야 하므로 effect 안에서 만든다.
    const dblClickGuard = createSameCellDblClickGuard();

    const propagateSet = new Set<string>(SO_GROUP_PROPAGATE_COLUMNS);
    // BtnNew 신규행 잠금 스팬 — admin 메타 컬럼 순서로 산출(J1). 메타 미로딩이면 null(7컬럼 폴백).
    const btnNewLocked = buildBtnNewLockedBindings((planDetailColumns ?? []).map(c => c.colNm));

    // 편집 잠금 + ERP 게이트 (03 §3-B — sErpStatus=='C' 이면 MSG01401 로 차단).
    //   판정은 e.cancel 전체대입 — 컬럼 메타 INPUT_TP_CD 전건 'S'(03 갭#1)라 공용 wrapper 의
    //   beginningEdit/pastingCell 게이트(isEditableCell)가 화이트리스트 7컬럼까지 취소하는데,
    //   wijmo Event 는 등록 순서 호출이므로 나중에 등록된 화면 핸들러의 대입이 최종 판정이 된다
    //   (iter-2 신규 발견 — cancel-only 배선이던 iter-1 은 클릭 편집도 wrapper 취소에 막혔다).
    const beginningEditHandler = (
      sender: FlexGridType,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      const cellEditable = isDetailCellEditable(
        SHEETS.PLAN_DETAIL,
        row,
        binding,
        editableRef.current,
        btnNewLocked
      );
      e.cancel = !cellEditable;
      if (!cellEditable) {
        if (row && str(row.ERP_STATUS) === 'C' && editableRef.current) {
          void setAlert({
            type: 'alert',
            content: t(MSG.ERP_DO_BLOCK, {
              defaultValue:
                '_ERP D/O (Delivery Order) has been created for the plan, so the SSP plan cannot be changed.',
            }),
          });
        }
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // 붙여넣기 게이트 (I22 — AS-IS SpdDetail_ClipboardPasted L1395~ 는 잠금해제 셀 붙여넣기를 허용):
    //   클릭 편집과 동일 판정을 pastingCell 에 전체대입(공용 게이트의 'S' 전면차단을 화이트리스트만 해제).
    const pastingCellHandler = (
      sender: FlexGridType,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      e.cancel = !isDetailCellEditable(
        SHEETS.PLAN_DETAIL,
        row,
        binding,
        editableRef.current,
        btnNewLocked
      );
    };
    g.pastingCell.addHandler(pastingCellHandler);

    // 편집가능 셀 시각 계층 (gap-audit J5 — memory sheet-columns-input-tp-all-search-only-grid-readonly:
    //   INPUT_TP_CD 전건 'S' 화면은 클릭/paste/저장검증과 함께 시각 계층까지 4계층 세트 배선).
    //   공용 wrapper formatItem 이 메타('S') 기준으로 wj-cell-editable 을 전부 끄므로, 나중에 등록된
    //   이 핸들러가 화이트리스트 판정으로 클래스를 재대입한다(등록 순서 호출 — 최종 판정).
    const formatItemHandler = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel !== sender.cells) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      // 표시전용 셀 콤보 code->name (FCST_TYPE/SHIPMENT_STATUS) — 마지막 등록 핸들러라 최종 확정.
      if (binding === LOOKUP_COLUMN.FCST_TYPE || binding === LOOKUP_COLUMN.SHIPMENT_STATUS) {
        const code = str(row?.[binding]);
        if (code) {
          const map =
            binding === LOOKUP_COLUMN.FCST_TYPE
              ? fcstTypeMapRef.current
              : shipmentStatusMapRef.current;
          e.cell.textContent = map[code] ?? code;
        }
      }
      e.cell.classList.toggle(
        'wj-cell-editable',
        isDetailCellEditable(SHEETS.PLAN_DETAIL, row, binding, editableRef.current, btnNewLocked)
      );
    };
    g.formatItem.addHandler(formatItemHandler);

    // 파생/전파 (03 §3-B/C):
    //   - CHANGE_REASON_DETAIL: CODE 가 '-'/공백이면 입력 되돌림 + MSG01291 (전파 안 함)
    //   - CHANGE_REASON_CODE: '-'/공백이면 DETAIL 클리어(SO 공백이면 EDIT_MAIN 세팅 없이 종료)
    //   - 7컬럼 공통: ERP_SO_NO 공백 → 현재행만 / 비공백 → 동일 SO그룹 全행 전파 + EDIT_MAIN='Y'
    const cellEditEndedHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (!propagateSet.has(binding)) return;
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      if (!row) return;
      const value = row[binding];
      const soNo = str(row.ERP_SO_NO).trim();

      if (binding === 'CHANGE_REASON_DETAIL') {
        const code = str(row.CHANGE_REASON_CODE).trim();
        if (code === '' || code === '-') {
          row.CHANGE_REASON_DETAIL = '';
          void setAlert({
            type: 'alert',
            content: t(MSG.REASON_CODE_FIRST, '__Please enter Reason Code.'),
          });
          sender.collectionView?.refresh();
          return;
        }
      }

      if (binding === 'CHANGE_REASON_CODE') {
        const code = str(value).trim();
        if (code === '' || code === '-') {
          row.CHANGE_REASON_DETAIL = '';
          if (soNo === '') {
            sender.collectionView?.refresh();
            return; // SO 공백 — EDIT_MAIN 세팅 없이 종료 (03 §3-B)
          }
        }
      }

      row.EDIT_MAIN = 'Y';
      if (soNo !== '') {
        // 동일 SO그룹 전파 — CHANGE_REASON 은 CODE+DETAIL 동시 (03 §3-B)
        const source = (sender.collectionView?.sourceCollection ?? []) as Record<
          string,
          unknown
        >[];
        source.forEach(other => {
          if (other === row) return;
          if (str(other.ERP_SO_NO).trim() !== soNo) return;
          other[binding] = value;
          if (binding === 'CHANGE_REASON_CODE') {
            other.CHANGE_REASON_DETAIL = row.CHANGE_REASON_DETAIL;
          }
          other.EDIT_MAIN = 'Y';
          if (!str(other.CRUD_TYPE)) other.CRUD_TYPE = 'M';
        });
      }
      sender.collectionView?.refresh();
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);
    // 붙여넣기도 동일 파생/전파 (AS-IS shtDetail_Change 는 데이터모델 Changed 라 paste 경로 포함)
    g.pastedCell.addHandler(cellEditEndedHandler);

    // 더블클릭/클릭 — ITEM_ID·PROJECT_CODE(신규행 한정, 가드는 페이지 콜백에서 MSG00013) /
    //   CHANGE_REQ_NO(비공백 시 ConfirmDetail 팝업) / ERP_SO_NO(비공백 시 OrderDetail 팝업, SSP0300).
    //   가드: 직전 두 클릭이 같은 셀일 때만 더블클릭으로 인정한다(Main 그리드와 동일 사유 —
    //   셀을 바꿔 가며 클릭하면 dblclick 이 공통 조상에 디스패치돼 팝업이 임의로 열렸다).
    const dblClickHandler = (ev: MouseEvent) => {
      if (g.rows.length === 0) return;
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      if (!dblClickGuard.accepts({ row: ht.row, col: ht.col })) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      const row = GridUtils.getRow(g, ht.row) as WijmoRowItem | undefined;
      if (!row) return;
      if (binding === 'ITEM_ID' && str(row.CRUD_TYPE) === 'I') {
        onItemCellSearch(row);
      } else if (binding === 'PROJECT_CODE' && str(row.CRUD_TYPE) === 'I') {
        onProjectCellSearch(row);
      } else if (binding === 'ERP_SO_NO') {
        // AS-IS SpdDetail_CellDoubleClick(cs L1797~1812): ERP_SO_NO 가 ""·null 이 아닐 때만
        //   SSP0300_OrderDetailPopup.Form_Load(DIVISION_ID, ERP_SO_NO, CONFIRM_ID, ITEM_ID, "N").
        //   5번째 electrode_yn 은 이 화면에서 상수 "N" 이고 TO-BE proc
        //   P_SSP0300_GET_ORDER_DETAIL 의 IN 파라미터는 4개(ALL_ARGUMENTS 실측)라 전달하지 않는다.
        //
        // SO 없는 행은 공백이 아니라 '-' 다 — `PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN_DETAIL`
        //   Plan 분기(L4491 `'-' AS ERP_SO_NO`, 같은 블록의 ERP_DO_NO·REQUESTOR 등도 동일)가
        //   SO 미존재를 '-' 로 채운다. 그래서 공백만 거르면 '-' 행에서 빈 팝업이 열렸다
        //   (2026-10-12 사용자 보고). 이 화면은 CHANGE_REASON_CODE/DETAIL 에서도 ''·'-' 를 같은
        //   "값 없음"으로 보고 있어(L231·L244, ShipmentPlan.tsx:520) 그 규약을 따른다.
        //   AS-IS 가드는 ""·null 만 보므로 '-' 에서도 팝업이 열렸다 — 사용자 지시로 개선한다.
        const erpSoNo = str(row.ERP_SO_NO).trim();
        if (erpSoNo === '' || erpSoNo === '-') return;
        onOrderDetail({
          divisionId: str(row.DIVISION_ID),
          erpSoNo,
          confirmId: str(row.CONFIRM_ID),
          itemId: str(row.ITEM_ID),
        });
      }
    };
    g.hostElement.addEventListener('dblclick', dblClickHandler);

    const clickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      // 필수: early return 보다 먼저 기록한다(Main 그리드 clickHandler 와 동일 이유).
      const isCell = ht.cellType === CellType.Cell;
      dblClickGuard.track(isCell ? { row: ht.row, col: ht.col } : null);
      if (g.rows.length === 0 || !isCell) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      if (binding !== 'CHANGE_REQ_NO') return;
      const row = GridUtils.getRow(g, ht.row) as WijmoRowItem | undefined;
      const changeReqNo = str(row?.CHANGE_REQ_NO).trim();
      if (changeReqNo === '') return; // buttonGuard #34
      onConfirmDetail(changeReqNo);
    };
    g.hostElement.addEventListener('click', clickHandler);

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastingCell?.removeHandler(pastingCellHandler);
        g.formatItem?.removeHandler(formatItemHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(cellEditEndedHandler);
        g.hostElement?.removeEventListener('dblclick', dblClickHandler);
        g.hostElement?.removeEventListener('click', clickHandler);
      } catch {
        // unmount race
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [planDetailColumns, rowsBySheet[SHEETS.PLAN_DETAIL]]);

  // HoldStock 편집 잠금 (03 §1.3 — Edit 모드 전행 3컬럼). 판정 전체대입 + paste 동일 게이트(I22 —
  //   메타 'S' 전면차단을 화이트리스트 3컬럼만 해제. PlanDetail 배선과 동일 근거).
  const holdStockGridRef = gridRefs[SHEETS.HOLD_STOCK];
  const holdStockColumns = staticColumns[SHEETS.HOLD_STOCK];
  useEffect(() => {
    const g = holdStockGridRef?.current;
    if (!g) return;
    const editGateHandler = (
      sender: FlexGridType,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      e.cancel = !isDetailCellEditable(SHEETS.HOLD_STOCK, row, binding, editableRef.current);
    };
    g.beginningEdit.addHandler(editGateHandler);
    g.pastingCell.addHandler(editGateHandler);
    // 편집가능 셀 시각 계층 (J5 — PlanDetail 배선과 동일 근거, 3컬럼 화이트리스트 기준)
    const formatItemHandler = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel !== sender.cells) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      e.cell.classList.toggle(
        'wj-cell-editable',
        isDetailCellEditable(SHEETS.HOLD_STOCK, row, binding, editableRef.current)
      );
    };
    g.formatItem.addHandler(formatItemHandler);
    return () => {
      try {
        g.beginningEdit?.removeHandler(editGateHandler);
        g.pastingCell?.removeHandler(editGateHandler);
        g.formatItem?.removeHandler(formatItemHandler);
      } catch {
        // unmount race
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [holdStockColumns, rowsBySheet[SHEETS.HOLD_STOCK]]);

  // PlanDetail CHANGE_REASON_CODE(편집) DataMap 주입 — 드롭다운 + 'CODE : 명' 표시. 자동 콤보 메타는
  //   벗겨 뒀다(columnsBySheet). columnGroups 재생성·lookup 비동기 도착 시 재적용 + FCST/STATUS 재도색.
  useEffect(() => {
    const g = planDetailGridRef?.current;
    if (!g) return;
    const col = g.columns.getColumn(LOOKUP_COLUMN.CHANGE_REASON_CODE);
    if (col) col.dataMap = changeReasonDataMap;
    g.invalidate();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [planDetailColumns, changeReasonDataMap, fcstTypeMap, shipmentStatusMap]);

  // 음수 = 빨간 글자 — Detail 7시트 **전체**에 배선한다.
  //   AS-IS 는 화면 코드가 아니라 프레임워크가 전역으로 한다:
  //   GSCM/01.Framework/GSCM.Windows.Forms/Class/SpreadInfo.cs 가 NumberCellType 을 만들 때마다
  //   `NegativeRed = true`(L2675·2904·3087·3680·3860·4058 …) + SpreadExtension.cs:38.
  //   그래서 SSP0060 .cs 에 NegativeRed 가 0 hit 인 것은 "없다"가 아니라 "프레임워크 소관"이다.
  //   시트별 formatItem 에 끼워 넣지 않고 한곳에서 전 그리드에 붙인다 — 7시트 중복 배선과
  //   조기 return 뒤에 묻히는 실수를 막는다(oWMS 핸들러는 STOCK_STATUS 아니면 즉시 return 한다).
  //   deps 가 staticColumns 인 이유: 탭이 늦게 마운트되면 그 시점에 grid ref 가 생기므로,
  //   컬럼 메타가 채워질 때 재실행해 새로 생긴 그리드에도 붙여야 한다.
  useEffect(() => {
    const paintNegative = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel !== sender.cells) return;
      // 값 원천은 실제 그리는 원값(getCellData false) — 문자/코드/날짜 셀은 toGridNumber 가 0 을
      //   돌려 음수 판정에서 자연히 빠진다. 해제까지 paintNegativeText 가 담당(셀 DOM 재사용 잔상).
      paintNegativeText(e.cell, toGridNumber(sender.cells.getCellData(e.row, e.col, false)));
    };
    const attached = DETAIL_SHEETS.map(sheet => gridRefs[sheet]?.current).filter(
      (g): g is FlexGridType => !!g
    );
    attached.forEach(g => g.formatItem.addHandler(paintNegative));
    return () => {
      attached.forEach(g => {
        try {
          g.formatItem?.removeHandler(paintNegative);
        } catch {
          // unmount race
        }
      });
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns]);

  // oWMS Detail STOCK_STATUS code->name 표시(OWMS_STOCK_STATUS lookup, 읽기전용).
  const owmsGridRef = gridRefs[SHEETS.OWMS_DETAIL];
  const owmsColumns = staticColumns[SHEETS.OWMS_DETAIL];
  useEffect(() => {
    const g = owmsGridRef?.current;
    if (!g) return;
    const fmt = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel !== sender.cells) return;
      if ((sender.columns[e.col]?.binding ?? '') !== LOOKUP_COLUMN.STOCK_STATUS) return;
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      const code = str(row?.[LOOKUP_COLUMN.STOCK_STATUS]);
      if (code) e.cell.textContent = stockStatusMapRef.current[code] ?? code;
    };
    g.formatItem.addHandler(fmt);
    g.invalidate();
    return () => {
      try {
        g.formatItem?.removeHandler(fmt);
      } catch {
        // unmount race
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [owmsColumns, stockStatusMap, rowsBySheet[SHEETS.OWMS_DETAIL]]);

  // Detail ColumnFooter 합계 (I16 — AS-IS InitSpreadFooterSum L764~853): 시트별 수치 구간에
  //   Sum 집계(SumIgnoreHidden 등가 — wijmo Aggregate 는 visible 무관 소스 집계라 hidden 컬럼도
  //   합산되나 대상 구간이 수치 컬럼 한정이라 실효 동일).
  //   합계행(GroupRow) 자체는 공용 `useAggregationRow` prop 이 그리드 초기화 때 1회 넣는다 —
  //   여기서 수동 push 하던 종전 방식은 효과가 없었다(사용자 신고 2026-10-06 "Sum 도 없어").
  //   남은 일은 **집계 대상 컬럼 지정뿐인데, 이것이 유실되는 게 핵심 버그였다**:
  //   wijmo 의 `set columnGroups` 는 Column 을 통째로 재생성하므로 컬럼 메타가 바뀌거나 레이아웃이
  //   갱신될 때마다 `col.aggregate` 가 기본값(None)으로 돌아간다. 1회성 대입으로는 남지 않는다.
  //   → 시트별 집계 대상(sumSet)을 ref 에 두고 `updatedLayout` 마다 재적용한다(폭·dataMap 복원과
  //   동일 처방, DataGrid.tsx updatedLayout 주석 참조). 목표값과 같으면 skip — 무한 루프 방지.
  const sumSetsRef = useRef(new Map<SHEETS, Set<string>>());
  const footerHookedRef = useRef(new Set<SHEETS>());
  useEffect(() => {
    DETAIL_SHEETS.forEach(sheet => {
      const g = gridRefs[sheet]?.current;
      const columns = staticColumns[sheet];
      const range = FOOTER_SUM_RANGE[sheet];
      if (!g || !columns || columns.length === 0 || !range) return;
      const order = columns.map(c => c.colNm);
      const from = order.indexOf(range.afterCol);
      if (from < 0) return;
      const toIdx = range.beforeCol ? order.indexOf(range.beforeCol) : order.length;
      sumSetsRef.current.set(
        sheet,
        new Set(order.slice(from + 1, toIdx < 0 ? order.length : toIdx))
      );
      const applyAggregates = () => {
        const sumSet = sumSetsRef.current.get(sheet);
        if (!sumSet) return;
        // 합계행(= wijmo columnFooters GroupRow)은 공용 `useAggregationRow` prop 이 그리드 초기화
        //   때 넣지만, 그 1회가 어떤 이유로든 비어 있으면 Sum 행 자체가 안 보인다. 여기서 한 번 더
        //   보장한다(이미 있으면 no-op). columnFooters 는 wijmo 가 그리드 하단에 고정 배치하는
        //   패널이라(`footer.top = clientBottom - columnFooters.height`, 행이 적어도 바닥에 붙는다)
        //   AS-IS FarPoint `ColumnFooter.Visible=true`(cs L802)와 같은 자리다.
        if (g.columnFooters.rows.length === 0) g.columnFooters.rows.push(new GroupRow());
        // 합계행 라벨 — 공용 setAggregationRow 는 'Σ' 를 쓰지만 AS-IS 는 "Sum" 이다
        //   (cs L803 `ColumnFooter.Cells[0,1].Value = "Sum"`, 사용자 요청 2026-10-06).
        //   좌하단 셀은 columnGroups 재대입으로 지워질 수 있어 레이아웃 갱신마다 되살린다.
        if (g.bottomLeftCells.getCellData(0, 0, false) !== FOOTER_SUM_LABEL) {
          g.bottomLeftCells.setCellData(0, 0, FOOTER_SUM_LABEL);
        }
        g.columns.forEach(col => {
          const want = sumSet.has(col.binding ?? '') ? Aggregate.Sum : Aggregate.None;
          if (col.aggregate !== want) col.aggregate = want;
        });
      };
      // Sum 행을 **그리드 바닥**에 고정 — 데이터 0건이어도 맨 아래(사용자 요청 2026-10-06).
      //   wijmo 는 columnFooters 를 바닥이 아니라 "마지막 데이터 행 바로 아래"에 둔다. 실측
      //   (`@mescius/wijmo.grid` es5-esm `FlexGrid.prototype._updateLayout`):
      //     o = footerRows.getTotalSize(); n = rows.getTotalSize() + o; s = _heightBrowser + i - o;
      //     setCss(this._eCFtr, { top: s, height: o })   // s = 헤더높이 + 데이터행 총높이
      //   즉 0행이면 헤더 바로 밑에 붙는다 — AS-IS FarPoint `ColumnFooter`(컨트롤 하단 고정,
      //   cs L802)와 다르다. wijmo 에 바닥 고정 옵션이 없어, 레이아웃 갱신 뒤 푸터 패널(_eCFtr)과
      //   그 좌측 라벨 패널(_eBL)의 top 만 눌러준다. 그리드 상태를 건드리지 않으므로(순수 DOM)
      //   재레이아웃을 유발하지 않는다. 내용이 뷰포트보다 길면(스크롤 발생) wijmo 기본 위치를 둔다.
      const pinFooterToBottom = () => {
        const footerPanel = g.columnFooters.hostElement?.parentElement;
        const scrollRoot = footerPanel?.parentElement;
        const footerHeight = g.columnFooters.height;
        if (!footerPanel || !scrollRoot || footerHeight <= 0) return;
        // 가로 콘텐츠가 뷰포트보다 넓으면(가로 스크롤 필요) 바닥에 스크롤바 높이만큼 자리를 비운다 —
        //   안 비우면 바닥 고정한 Sum 푸터가 스크롤바를 덮어 스크롤이 사라진다(신고 2026-10-13: 행이
        //   적을 때 자매 SSP0021 은 이 bottom-pin 이 안 걸려 스크롤바가 보였다). scrollSize/clientSize 는
        //   wijmo 가 계산한 콘텐츠·뷰포트 크기다. 실측 스크롤바 높이(0이면 숨은 상태)는 표준값으로 폴백.
        const hScrollReserve =
          g.scrollSize.width > g.clientSize.width
            ? scrollRoot.offsetHeight - scrollRoot.clientHeight || HSCROLLBAR_HEIGHT
            : 0;
        const pinnedTop = scrollRoot.clientHeight - footerHeight - hScrollReserve;
        if (pinnedTop <= footerPanel.offsetTop) return; // 내용이 더 길다 → 기본 위치 유지
        footerPanel.style.top = `${pinnedTop}px`;
        const bottomLeftPanel = g.bottomLeftCells.hostElement?.parentElement;
        if (bottomLeftPanel) bottomLeftPanel.style.top = `${pinnedTop}px`;
      };

      applyAggregates();
      pinFooterToBottom();
      if (!footerHookedRef.current.has(sheet)) {
        footerHookedRef.current.add(sheet);
        g.updatedLayout.addHandler(applyAggregates);
        g.updatedLayout.addHandler(pinFooterToBottom);
      }
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns, rowsBySheet, activeDetailSheet]);

  // Detail 헤더 높이 — 공용 48px 바닥 + **내용에 맞춘 자동 측정**(글자 짤림 0).
  //   Detail 7시트는 class 라벨이 전부 NULL 이라 공용 매핑이 ONE_DEPTH 로 판정하고 각 컬럼에
  //   `height: 48`(HEIGHT_BY_COLUMN_DEPTH.ONE_DEPTH)을 박는다 → 라벨이 두 줄로 흘러 "헤더가 2줄"
  //   (신고 2026-10-06). 그래서 28px 로 고정했더니 이번엔 두 줄짜리 라벨이 잘렸고(재신고), 결국
  //   **공용 표준 48px 로 되돌리되 짤림만 막는 것**으로 확정됐다(사용자 지시 2026-10-06 "24면 48로 다시").
  //   고정값 하나로는 컬럼 폭·라벨 길이·언어를 다 못 맞추므로, 48 을 바닥으로 두고 wijmo
  //   `autoSizeRows(…, header=true)` 로 실제 렌더 높이를 **1회 측정**해 둘 중 큰 값을 쓴다.
  //   (= 평소엔 공용과 같은 48, 라벨이 더 길면 그만큼만 커진다.)
  //   공용 `headerRowHeight`(= `rows.defaultSize`)는
  //   컬럼에 명시 height 가 있으면 무시되므로 선례(CustFcstWaterfallGrid·DemandPlanWaterfallGrid)처럼
  //   화면이 헤더 row 높이를 직접 강제한다. 공용 컴포넌트는 건드리지 않는다(convert-core §2.2).
  //   측정값은 시트별로 캐시해 `updatedLayout`(= columnGroups 재대입으로 48 로 되돌아갈 때)마다
  //   되돌린다 — 캐시가 있으면 비교·대입만 하므로 재측정·무한 루프가 없다.
  const headerHookedRef = useRef(new Set<SHEETS>());
  const headerHeightRef = useRef(new Map<SHEETS, number>());
  useEffect(() => {
    // 컬럼 메타가 바뀌면 측정값을 버린다(라벨·폭이 달라지면 필요한 높이도 달라진다).
    headerHeightRef.current.clear();
    DETAIL_SHEETS.forEach(sheet => {
      const g = gridRefs[sheet]?.current;
      if (!g) return;
      const applyHeaderHeight = () => {
        const rows = g.columnHeaders?.rows;
        if (!rows || rows.length === 0) return;
        let target = headerHeightRef.current.get(sheet);
        if (target == null) {
          // 숨은 탭은 wijmo 가 셀을 측정하지 못한다(autoSize 는 그리드가 보일 때만 유효) —
          //   그 탭은 활성화될 때 이 effect 가 다시 돌면서 측정된다.
          if (!g.hostElement?.offsetHeight) return;
          g.autoSizeRows(0, rows.length - 1, true);
          let measured = 0;
          for (let i = 0; i < rows.length; i += 1) {
            measured = Math.max(measured, rows[i].renderHeight ?? 0);
          }
          if (measured <= 0) return;
          target = Math.max(Math.ceil(measured), MIN_HEADER_ROW_HEIGHT);
          headerHeightRef.current.set(sheet, target);
        }
        let changed = false;
        for (let i = 0; i < rows.length; i += 1) {
          if (Math.round(rows[i].height ?? rows.defaultSize) !== target) {
            rows[i].height = target;
            changed = true;
          }
        }
        if (Math.round(rows.defaultSize) !== target) {
          rows.defaultSize = target;
          changed = true;
        }
        if (changed) g.invalidate(true);
      };
      applyHeaderHeight();
      if (!headerHookedRef.current.has(sheet)) {
        headerHookedRef.current.add(sheet);
        g.updatedLayout.addHandler(applyHeaderHeight);
      }
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns, activeDetailSheet]);

  // 읽기전용 5-sheet 는 isReadOnly — 어떤 액션으로도 편집 UI 미노출 (03 §5-8)
  const isReadOnlySheet = (sheet: SHEETS): boolean =>
    sheet !== SHEETS.PLAN_DETAIL && sheet !== SHEETS.HOLD_STOCK;

  return (
    <TabWrapper
      persist
      activeTabIndex={activeIndex}
      setActiveTabIndex={index => setActiveDetailSheet(DETAIL_SHEETS[index])}
    >
      {DETAIL_SHEETS.map(sheet => (
        <TabItem key={sheet} label={ADMIN_SHEET_NAME[sheet] ?? sheet}>
          <DataGrid
            gridRef={gridRefs[sheet]}
            gridFilterRef={gridFilterRefs[sheet]}
            editTrackerRef={isReadOnlySheet(sheet) ? undefined : editTrackerRefs[sheet]}
            isReadOnly={isReadOnlySheet(sheet)}
            itemsSource={rowsBySheet[sheet] ?? []}
            staticColumns={columnsBySheet[sheet] ?? []}
            comboParams={{ mnuId: `'${MENU_ID}'` }}
            allowMerging={AllowMerging.Cells}
            // AS-IS InitSpreadFooterSum(L764~853)이 Detail 8시트 전부에 ColumnFooter 를 켜고
            //   'Sum' 행을 조회 전부터 보여준다(AS-IS 캡처 하단 Sum 행) — 공용 합계행으로 동일 재현.
            useAggregationRow
            gotFocus={() => {
              // 활성 그리드 전환 — AS-IS 프레임워크 BaseForm.FpSpread_CellClick(L2303~2305)이
              //   모든 스프레드 클릭에서 fps 를 무조건 전환한다(iter-2 실측 — 01 R5 "sticky" 는
              //   화면 코드만 본 판정이라 정정). Main 쪽 복귀 배선은 MainGrid 참조.
              setActiveGrid('detail');
            }}
          />
        </TabItem>
      ))}
    </TabWrapper>
  );
};
