import { Aggregate, Globalize } from '@mescius/wijmo';
import {
  AllowMerging,
  CellType,
  GroupRow,
  type FlexGrid as FlexGridType,
  type GridPanel,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useCallback, useEffect, useRef, type MutableRefObject } from 'react';

import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils, paintNegativeText, toGridNumber } from '@foundation/utils';
import { DataGrid, TabItem, TabWrapper } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  FOOTER_FORMAT,
  LBL,
  MENU_ID,
  MSG,
  SHEETS,
  SO_GROUP_PROPAGATE_COLUMNS,
} from '../shipment-plan-mobility-it.constants';
import { useShipmentPlanMobilityItStore } from '../useShipmentPlanMobilityItStore';
import { detailSheetsFor, FOOTER_SUM_COLUMNS } from '../utils/shipment-plan-mobility-it.detailSheets';
import { isDetailCellEditable } from '../utils/shipment-plan-mobility-it.editLock';
import { toValidYmd } from '../utils/shipment-plan-mobility-it.save';

interface Props {
  rowsBySheet: Partial<Record<SHEETS, WijmoRowItem[]>>;
  gridRefs: Partial<Record<SHEETS, MutableRefObject<FlexGridType | undefined>>>;
  gridFilterRefs: Partial<Record<SHEETS, MutableRefObject<FlexGridFilter | undefined>>>;
  editTrackerRefs: Partial<Record<SHEETS, MutableRefObject<EditTracker | undefined>>>;
  staticColumns: Partial<Record<SHEETS, RawFlexGridColumnConfig[]>>;
  // 편집 가능 = canEdit(hasButton('EDIT')) — AS-IS EditButton 토글 미이식(convert-core §2.4).
  editable: boolean;
  onConfirmDetail: (changeReqNo: string) => void; // CHANGE_REQ_NO 클릭(아이콘셀 popup)
  // ERP_SO_NO 더블클릭 → OrderDetail(SSP0300) 팝업 (AS-IS SpdDetail_CellDoubleClick L1331-1347)
  onOrderDetail: (ctx: {
    divisionId: string;
    erpSoNo: string;
    confirmId: string;
    itemId: string;
  }) => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// detail 편집/읽기전용 시트 판정 (design 03 §1.E)
const EDITABLE_SHEETS = new Set<SHEETS>([SHEETS.CONFIRM_DETAIL, SHEETS.HOLD_STOCK, SHEETS.MES_STOCK]);

// 안정 참조 — DataGrid props 에 매 렌더 새 배열/객체를 넘기면(아래 `?? []`·inline obj) 부모가
//   staticColumns fetch(시트별 ~13회 순차 도착)마다 재렌더될 때 그리드가 매번 재처리돼 과도한 깜빡임이 난다.
//   빈 fallback·comboParams 는 모듈 상수로 고정한다(값이 불변이라 안전).
// 같은 SO 행에 값은 복사하지 않고 변경 표시(EDIT_MAIN)만 하는 컬럼 (AS-IS SSP0015.cs L7488~7550)
const MARK_ONLY_COLUMNS = new Set<string>([
  'SHIPMENT_CONFIRM_QTY',
  'TRANSPORT_MODE',
  'REMARKS',
  'REMARKS2',
]);

const EMPTY_COLS: RawFlexGridColumnConfig[] = [];
const EMPTY_ROWS: WijmoRowItem[] = [];
const DETAIL_COMBO_PARAMS = { mnuId: `'${MENU_ID}'` } as const;

export const ShipmentPsiDetailGrid = ({
  rowsBySheet,
  gridRefs,
  gridFilterRefs,
  editTrackerRefs,
  staticColumns,
  editable,
  onConfirmDetail,
  onOrderDetail,
}: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const onOrderDetailRef = useRef(onOrderDetail);
  onOrderDetailRef.current = onOrderDetail;

  // Confirm Detail ERP_SO_NO 셀 더블클릭(값 있을 때) → OrderDetail 팝업 (AS-IS L1331-1347).
  //   안정 참조(useCallback) — DataGrid 에 매 렌더 새 함수가 가면 재바인딩/재처리로 깜빡임 유발.
  const handleConfirmDblClick = useCallback(
    (ev: MouseEvent) => {
      const g = gridRefs[SHEETS.CONFIRM_DETAIL]?.current;
      if (!g) return;
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      if ((g.columns[ht.col]?.binding ?? '') !== 'ERP_SO_NO') return;
      const row = GridUtils.getRow(g, ht.row) as Record<string, unknown> | undefined;
      if (!row) return;
      const erpSoNo = str(row.ERP_SO_NO).trim();
      if (!erpSoNo) return;
      onOrderDetailRef.current({
        divisionId: str(row.DIVISION_ID),
        erpSoNo,
        confirmId: str(row.CONFIRM_ID),
        itemId: str(row.ITEM_ID),
      });
    },
    [gridRefs]
  );

  const activeDetailSheet = useShipmentPlanMobilityItStore(s => s.activeDetailSheet);
  const setActiveDetailSheet = useShipmentPlanMobilityItStore(s => s.setActiveDetailSheet);
  const setActiveGrid = useShipmentPlanMobilityItStore(s => s.setActiveGrid);
  const mainSheet = useShipmentPlanMobilityItStore(s => s.mainSheet);

  // 활성 그리드 포커스 표식 — 안정 참조(매 렌더 새 화살표함수 방지).
  const handleGotFocus = useCallback(() => setActiveGrid('detail'), [setActiveGrid]);

  const editableRef = useRef(editable);
  editableRef.current = editable;
  // Packer 탭 여부 — Confirm Detail Ship to 편집 가드(isDetailCellEditable isPacker)용. 핸들러가 1회
  //   등록돼 stale closure 가 되므로 ref 로 최신값 참조.
  const isPackerRef = useRef(mainSheet === 'packer');
  isPackerRef.current = mainSheet === 'packer';

  // 상단 시트(Main/Packer)별 노출 detail 탭 (AS-IS SpdMain_ActiveSheetChanged).
  const visibleSheets = detailSheetsFor(mainSheet);

  // 상단 시트 전환으로 활성 detail 탭이 숨겨지면 첫 탭(Confirm Detail)으로 리셋.
  useEffect(() => {
    if (!visibleSheets.includes(activeDetailSheet)) setActiveDetailSheet(visibleSheets[0]);
  }, [visibleSheets, activeDetailSheet, setActiveDetailSheet]);

  const activeIndex = Math.max(visibleSheets.indexOf(activeDetailSheet), 0);

  // Shipment Confirm Detail — 편집잠금 + ERP 게이트 + SO그룹 전파 (design 03 §3.A/§3.B)
  const confirmGridRef = gridRefs[SHEETS.CONFIRM_DETAIL];
  const confirmColumns = staticColumns[SHEETS.CONFIRM_DETAIL];
  useEffect(() => {
    const g = confirmGridRef?.current;
    if (!g) return;
    const propagateSet = new Set<string>(SO_GROUP_PROPAGATE_COLUMNS);

    const gateHandler = (
      sender: FlexGridType,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      const cellEditable = isDetailCellEditable(SHEETS.CONFIRM_DETAIL, row, binding, editableRef.current, isPackerRef.current);
      e.cancel = !cellEditable;
      if (!cellEditable && row && str(row.ERP_STATUS) === 'C' && editableRef.current) {
        void setAlert({
          type: 'alert',
          content: t(MSG.READONLY_SHEET, '__This row cannot be changed.'),
        });
      }
    };
    g.beginningEdit.addHandler(gateHandler);
    g.pastingCell.addHandler(gateHandler);

    const formatItemHandler = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel !== sender.cells) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      e.cell.classList.toggle(
        'wj-cell-editable',
        isDetailCellEditable(SHEETS.CONFIRM_DETAIL, row, binding, editableRef.current, isPackerRef.current)
      );
    };
    g.formatItem.addHandler(formatItemHandler);

    // 편집마킹(EDIT_MAIN='Y'→CRUD_TYPE) + SO그룹 전파 (design 03 §3.B)
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
            return;
          }
        }
      }

      row.EDIT_MAIN = 'Y';
      // 기존행 수정 → CRUD_TYPE='M'(AS-IS action='M'). 저장 폴딩의 activeFlag 원천 — 공란이면 proc 가 행을 건너뛴다.
      if (!str(row.CRUD_TYPE)) row.CRUD_TYPE = 'M';
      if (soNo !== '') {
        const source = (sender.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
        source.forEach(other => {
          if (other === row) return;
          if (str(other.ERP_SO_NO).trim() !== soNo) return;
          // other[binding] = value;
          // 수량, Trans Mode, Remarks 는 같은 SO 행에 값을 복사하지 않고 변경 표시만 한다(AS-IS 동일).
          if (!MARK_ONLY_COLUMNS.has(binding)) other[binding] = value;
          if (binding === 'CHANGE_REASON_CODE') other.CHANGE_REASON_DETAIL = row.CHANGE_REASON_DETAIL;
          other.EDIT_MAIN = 'Y';
          if (!str(other.CRUD_TYPE)) other.CRUD_TYPE = 'M';
        });
      }
      sender.collectionView?.refresh();
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);
    g.pastedCell.addHandler(cellEditEndedHandler);

    // paste 경로 날짜 파생 + SO그룹 전파 (AS-IS SSP0015_ShipmentPSI.cs L8995-9029 — gap-resolve I09).
    //   비대칭(design 03 §3.B): interactive 편집은 서버(SP)가 NEW_ETD/ETA 산정, paste 경로만 클라가 선산정.
    //   AS-IS 는 날짜를 "yyyy-MM-dd" 로 정규화(sDate)하고 NEW_ETA=sDate+NEW_LT_DAY 를 계산한 뒤,
    //   ERP_SO_NO 가 있으면 동일 SO 전행에, 없으면 편집행에만 5개 필드를 세팅한다.
    const pastedDateHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== 'SHIPMENT_DATE') return;
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      if (!row) return;
      const raw = str(row.SHIPMENT_DATE).trim();
      if (raw === '') return;
      const iso = raw.length === 8 ? `${raw.slice(0, 4)}-${raw.slice(4, 6)}-${raw.slice(6, 8)}` : raw;
      const parsed = dayjs(iso);
      if (!parsed.isValid()) return;
      const sDate = parsed.format('YYYY-MM-DD'); // AS-IS "yyyy-MM-dd" 정규화
      const ltDay = Number(str(row.NEW_LT_DAY) || 0);
      const sEta = parsed.add(Number.isNaN(ltDay) ? 0 : ltDay, 'day').format('YYYY-MM-DD');
      const applyDerived = (target: Record<string, unknown>) => {
        target.SHIPMENT_DATE = sDate;
        target.NEW_ETD = sDate;
        target.NEW_ETA = sEta;
        target.NEW_SHIPMENT_DATE = sDate;
        target.EDIT_MAIN = 'Y';
        if (!str(target.CRUD_TYPE)) target.CRUD_TYPE = 'M';
      };
      const soNo = str(row.ERP_SO_NO).trim();
      if (soNo === '') {
        applyDerived(row);
      } else {
        const source = (sender.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
        source.forEach(other => {
          if (str(other.ERP_SO_NO).trim() === soNo) applyDerived(other);
        });
      }
      sender.collectionView?.refresh();
    };
    g.pastedCell.addHandler(pastedDateHandler);

    // 아이콘셀 popup — CHANGE_REQ_NO 클릭(비공백 시 ConfirmDetail 팝업, design 03 §3.C·§4d #26·27).
    //   INCOTERMS 아이콘셀·ERP_SO_NO(OrderDetail SSP0300)·Comments sticky note 는 TO-BE 팝업 부재로
    //   미배선 — 04_react-gap.md 확인필요.
    const clickHandler = (ev: MouseEvent) => {
      if (g.rows.length === 0) return;
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      if (binding !== 'CHANGE_REQ_NO') return;
      const row = GridUtils.getRow(g, ht.row) as WijmoRowItem | undefined;
      const changeReqNo = str(row?.CHANGE_REQ_NO).trim();
      // '-' 는 빈값과 동일(변경요청 없음) — 팝업 열지 않음(사용자 피드백 2026-10-07).
      if (changeReqNo === '' || changeReqNo === '-') return;
      onConfirmDetail(changeReqNo);
    };
    g.hostElement.addEventListener('click', clickHandler);

    return () => {
      try {
        g.beginningEdit?.removeHandler(gateHandler);
        g.pastingCell?.removeHandler(gateHandler);
        g.formatItem?.removeHandler(formatItemHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(pastedDateHandler);
        g.hostElement?.removeEventListener('click', clickHandler);
      } catch {
        // unmount race
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [confirmColumns, rowsBySheet[SHEETS.CONFIRM_DETAIL]]);

  // Hold stock / MES Stock 편집 게이트 (design 03 §3.A — 전행 화이트리스트 컬럼).
  //   dep 은 변수로 추출(react-hooks/exhaustive-deps complex-expression 경고 회피).
  const holdCols = staticColumns[SHEETS.HOLD_STOCK];
  const mesCols = staticColumns[SHEETS.MES_STOCK];
  const holdRows = rowsBySheet[SHEETS.HOLD_STOCK];
  const mesRows = rowsBySheet[SHEETS.MES_STOCK];
  useEffect(() => {
    const cleanups: (() => void)[] = [];
    ([SHEETS.HOLD_STOCK, SHEETS.MES_STOCK] as const).forEach(sheet => {
      const g = gridRefs[sheet]?.current;
      if (!g) return;
      const gate = (sender: FlexGridType, e: { row: number; col: number; cancel: boolean }) => {
        const binding = sender.columns[e.col]?.binding ?? '';
        const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
        e.cancel = !isDetailCellEditable(sheet, row, binding, editableRef.current, isPackerRef.current);
      };
      g.beginningEdit.addHandler(gate);
      g.pastingCell.addHandler(gate);
      const fmt = (
        sender: FlexGridType,
        e: { panel: unknown; row: number; col: number; cell: HTMLElement }
      ) => {
        if (e.panel !== sender.cells) return;
        const binding = sender.columns[e.col]?.binding ?? '';
        const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
        e.cell.classList.toggle(
          'wj-cell-editable',
          isDetailCellEditable(sheet, row, binding, editableRef.current, isPackerRef.current)
        );
        // USER_MOD Blue (design 03 §3.C L3945/4506 — gap-resolve I15): MES Stock 의
        //   USER_MOD_RELEASE_DATE 가 사용자 수정값(2999-12-31 sentinel 아님·비공백)이면 파란 글씨.
        if (sheet === SHEETS.MES_STOCK && binding === 'USER_MOD_RELEASE_DATE') {
          const v = str(row?.USER_MOD_RELEASE_DATE).trim();
          if (v !== '' && v !== '2999-12-31' && v !== '29991231') e.cell.style.color = 'blue';
        }
      };
      g.formatItem.addHandler(fmt);
      // Hold stock End Date - 없는 날짜면 비우고 알린다. 맞는 날짜는 YYYY-MM-DD 로 맞춘다.
      const dateCheck = (sender: FlexGridType, e: { row: number; col: number }) => {
        if (sheet !== SHEETS.HOLD_STOCK) return;
        if ((sender.columns[e.col]?.binding ?? '') !== 'RELEASE_YYYYMMDD') return;
        const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
        if (!row) return;
        const raw = str(row.RELEASE_YYYYMMDD).trim();
        if (raw === '') return;
        const ymd = toValidYmd(raw);
        if (ymd) {
          const iso = `${ymd.slice(0, 4)}-${ymd.slice(4, 6)}-${ymd.slice(6, 8)}`;
          if (iso === raw) return;
          row.RELEASE_YYYYMMDD = iso;
        } else {
          row.RELEASE_YYYYMMDD = '';
          void setAlert({
            type: 'alert',
            content: t(MSG.INVALID_DATE_FORMAT, '__This is not a valid date format.'),
          });
        }
        sender.invalidate();
      };
      g.cellEditEnded.addHandler(dateCheck);
      g.pastedCell.addHandler(dateCheck);
      cleanups.push(() => {
        try {
          g.beginningEdit?.removeHandler(gate);
          g.pastingCell?.removeHandler(gate);
          g.formatItem?.removeHandler(fmt);
          g.cellEditEnded?.removeHandler(dateCheck);
          g.pastedCell?.removeHandler(dateCheck);
        } catch {
          // unmount race
        }
      });
    });
    return () => cleanups.forEach(fn => fn());
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [holdCols, mesCols, holdRows, mesRows]);

  // 하단 SUM footer (AS-IS InitSpreadFooterSum L987/9328) — 6개 detail 시트.
  //   데이터 없으면 footer 숨김(사용자 요청 2026-09-30 — 빈 그리드에 헤더만; sibling CustFcstWaterfall 동일).
  //   합산 대상 = FOOTER_SUM_COLUMNS(가시 FPNumber, AS-IS 범위 실측). "Sum" 라벨 = AS-IS ColumnFooter[0,1].
  useEffect(() => {
    (Object.keys(FOOTER_SUM_COLUMNS) as SHEETS[]).forEach(sheet => {
      const g = gridRefs[sheet]?.current;
      if (!g) return;
      const hasData = (rowsBySheet[sheet]?.length ?? 0) > 0;
      if (!hasData) {
        if (g.columnFooters.rows.length > 0) g.columnFooters.rows.clear();
        return;
      }
      if (g.columnFooters.rows.length === 0) g.columnFooters.rows.push(new GroupRow());
      const sumSet = new Set<string>(FOOTER_SUM_COLUMNS[sheet] ?? []);
      g.columns.forEach(col => {
        col.aggregate = sumSet.has(col.binding ?? '') ? Aggregate.Sum : Aggregate.None;
      });
      g.columnFooters.setCellData(0, 0, t(LBL.SUM, '_Sum'));
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [rowsBySheet, staticColumns, activeDetailSheet]);

  // footer 셀 서식 — 회색 배경(AS-IS BackColor LightGray L1068) + 합산셀 숫자 서식 {0:#,##0.###}(L1066).
  useEffect(() => {
    const cleanups: (() => void)[] = [];
    (Object.keys(FOOTER_SUM_COLUMNS) as SHEETS[]).forEach(sheet => {
      const g = gridRefs[sheet]?.current;
      if (!g) return;
      const sumSet = new Set<string>(FOOTER_SUM_COLUMNS[sheet] ?? []);
      const fmt = (
        sender: FlexGridType,
        e: { panel: GridPanel; row: number; col: number; cell: HTMLElement }
      ) => {
        if (e.panel.cellType !== CellType.ColumnFooter) return;
        e.cell.style.backgroundColor = '#d3d3d3';
        const binding = sender.columns[e.col]?.binding ?? '';
        if (!sumSet.has(binding)) return;
        const n = toGridNumber(e.panel.getCellData(e.row, e.col, false));
        if (n !== null) e.cell.textContent = Globalize.format(n, FOOTER_FORMAT);
      };
      g.formatItem.addHandler(fmt);
      cleanups.push(() => {
        try {
          g.formatItem?.removeHandler(fmt);
        } catch {
          // unmount race
        }
      });
    });
    return () => cleanups.forEach(fn => fn());
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns]);

  // 시트별 grid 인스턴스 확보 — 부모 gridRefs 는 7개 시트만 담고 drill 서브시트(WH_IN_PLAN_DETAIL·
  //   WH_STOCK_DETAIL·HOLD_STOCK_DETAIL)는 ref 가 없다. 그 시트들도 음수색 등 공통 핸들러를 걸어야 하므로
  //   로컬 ref 로 보강한다(부모가 준 시트는 그대로 그 ref 사용).
  const localGridRefs = useRef<Partial<Record<SHEETS, MutableRefObject<FlexGridType | undefined>>>>({});
  const resolveGridRef = (sheet: SHEETS): MutableRefObject<FlexGridType | undefined> =>
    gridRefs[sheet] ?? (localGridRefs.current[sheet] ??= { current: undefined });

  // 음수 = 빨간 글자 (AS-IS NegativeRed 전역 파리티 — 모든 detail 시트 공통. 정본 paintNegativeText).
  //   시트별 formatItem(편집마킹·MES Blue 등)과 별개로 전 그리드(읽기전용·drill 서브시트 포함)·데이터셀·
  //   footer 합계 셀에 건다. MES USER_MOD_RELEASE_DATE 는 Blue 날짜 전용이라 음수판정에서 제외(color 보존).
  //   staticColumns/rowsBySheet/activeDetailSheet 변경(시트 순차 도착·division 전환·탭 전환)마다 재부착해
  //   늦게 mount 된 그리드(persist 지연·탭 활성화)도 덮는다. ref 원천은 resolveGridRef(부모+로컬 병합).
  useEffect(() => {
    const cleanups: (() => void)[] = [];
    visibleSheets.forEach(sheet => {
      const g = resolveGridRef(sheet).current;
      if (!g) return;
      const paint = (
        sender: FlexGridType,
        e: { panel: GridPanel; row: number; col: number; cell: HTMLElement }
      ) => {
        if (e.panel.cellType !== CellType.Cell && e.panel.cellType !== CellType.ColumnFooter) return;
        if ((sender.columns[e.col]?.binding ?? '') === 'USER_MOD_RELEASE_DATE') return;
        paintNegativeText(e.cell, toGridNumber(e.panel.getCellData(e.row, e.col, false)));
      };
      g.formatItem.addHandler(paint);
      g.invalidate(); // 이미 그려진 셀(탭 활성 상태로 늦게 핸들러가 붙는 경우) 재도색
      cleanups.push(() => {
        try {
          g.formatItem?.removeHandler(paint);
        } catch {
          // unmount race
        }
      });
    });
    return () => cleanups.forEach(fn => fn());
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns, rowsBySheet, visibleSheets, activeDetailSheet]);

  const isReadOnlySheet = (sheet: SHEETS): boolean => !EDITABLE_SHEETS.has(sheet);

  return (
    <TabWrapper
      persist
      activeTabIndex={activeIndex}
      setActiveTabIndex={index => setActiveDetailSheet(visibleSheets[index])}
    >
      {visibleSheets.map(sheet => (
        <TabItem key={sheet} label={ADMIN_SHEET_NAME[sheet] ?? sheet}>
          <DataGrid
            gridRef={resolveGridRef(sheet)}
            gridFilterRef={gridFilterRefs[sheet]}
            editTrackerRef={isReadOnlySheet(sheet) ? undefined : editTrackerRefs[sheet]}
            isReadOnly={isReadOnlySheet(sheet)}
            itemsSource={rowsBySheet[sheet] ?? EMPTY_ROWS}
            staticColumns={staticColumns[sheet] ?? EMPTY_COLS}
            comboParams={DETAIL_COMBO_PARAMS}
            allowMerging={AllowMerging.None}
            dblClick={sheet === SHEETS.CONFIRM_DETAIL ? handleConfirmDblClick : undefined}
            gotFocus={handleGotFocus}
          />
        </TabItem>
      ))}
    </TabWrapper>
  );
};
