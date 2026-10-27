import { Aggregate } from '@mescius/wijmo';
import {
  AllowMerging,
  CellType,
  GroupRow,
  type FlexGrid as FlexGridType,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils, paintNegativeText, toGridNumber } from '@foundation/utils';
import { DataGrid, TabItem, TabWrapper } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import { attachDashDateFormat } from '../../../hooks/usePinDashDateFormat';
import {
  ADMIN_SHEET_NAME,
  FOOTER_SUM_RANGE,
  MENU_ID,
  MSG,
  SHEETS,
  SO_GROUP_PROPAGATE_COLUMNS,
} from '../shipment-plan-electrode.constants';
import type { DetailSheet } from '../shipment-plan-electrode.types';
import { useShipmentPlanElectrodeStore } from '../useShipmentPlanElectrodeStore';
import { createSameCellDblClickGuard } from '../utils/shipment-plan-electrode.dblClickGuard';
import { isDetailCellEditable } from '../utils/shipment-plan-electrode.editLock';

import type { OrderDetailContext } from './modals/OrderDetailModal';

// 하단 detail 3-sheet(PlanDetail 편집 / StockDetail·ShipmentResult 읽기전용) 전환 목록.
const DETAIL_SHEETS: DetailSheet[] = [
  SHEETS.PLAN_DETAIL,
  SHEETS.STOCK_DETAIL,
  SHEETS.SHIPMENT_RESULT,
];

interface Props {
  rowsBySheet: Partial<Record<SHEETS, WijmoRowItem[]>>;
  gridRefs: Partial<Record<SHEETS, MutableRefObject<FlexGridType | undefined>>>;
  gridFilterRefs: Partial<Record<SHEETS, MutableRefObject<FlexGridFilter | undefined>>>;
  editTrackerRefs: Partial<Record<SHEETS, MutableRefObject<EditTracker | undefined>>>;
  staticColumns: Partial<Record<SHEETS, RawFlexGridColumnConfig[]>>;
  // Detail 편집 가능 여부 = canEdit(편집계 권한 INSERT||SAVE)·최신Plan(realFlag). 셀 단위 범위는 isDetailCellEditable.
  editable: boolean;
  // ERP_SO_NO(PO No) 셀 더블클릭 → SSP0300 Order Detail 팝업(AS-IS SpdDetail_CellDoubleClick).
  onOrderDetail: (ctx: OrderDetailContext) => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// Detail 3-sheet 그리드 — sheet별 컬럼셋은 admin SCM_MST_SHEET_COLUMNS 메타가 단일 원천(수기 전사 금지).
//   PlanDetail 편집 화이트리스트/SO그룹 전파/CHANGE_REASON 클리어는 코드 재현(03 §3.1/§3.2).
//   탭 전환은 조회를 자동 발사하지 않는다 — 2차 Search/Main 드릴다운만 조회 트리거(AS-IS parity).
export const ShipmentPlanElectrodeDetailGrid = ({
  rowsBySheet,
  gridRefs,
  gridFilterRefs,
  editTrackerRefs,
  staticColumns,
  editable,
  onOrderDetail,
}: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const activeDetailSheet = useShipmentPlanElectrodeStore(s => s.activeDetailSheet);
  const setActiveDetailSheet = useShipmentPlanElectrodeStore(s => s.setActiveDetailSheet);
  const setActiveGrid = useShipmentPlanElectrodeStore(s => s.setActiveGrid);

  const editableRef = useRef(editable);
  editableRef.current = editable;

  // onOrderDetail 을 ref 로 미러 — PlanDetail 이벤트 effect 는 columns/rows 에만 의존하므로
  //   콜백이 바뀌어도 리스너를 재등록하지 않는다(dblClickGuard 상태 보존).
  const onOrderDetailRef = useRef(onOrderDetail);
  onOrderDetailRef.current = onOrderDetail;

  const activeIndex = Math.max(DETAIL_SHEETS.indexOf(activeDetailSheet), 0);

  // PlanDetail 전용 이벤트 배선 (03 §3.1/§3.2)
  const planDetailGridRef = gridRefs[SHEETS.PLAN_DETAIL];
  const planDetailColumns = staticColumns[SHEETS.PLAN_DETAIL];
  useEffect(() => {
    const g = planDetailGridRef?.current;
    if (!g) return;

    const propagateSet = new Set<string>(SO_GROUP_PROPAGATE_COLUMNS);

    // 더블클릭 판정기 — 수명이 아래 click/dblclick 리스너와 같아야 하므로 effect 안에서 만든다.
    const dblClickGuard = createSameCellDblClickGuard();

    // 편집 잠금 (03 §3.1) — 판정은 e.cancel 전체대입. INPUT_TP_CD 전건 'S'(갭#5) wrapper 게이트를
    //   화이트리스트만 해제. wijmo Event 등록 순서 호출이라 나중 등록된 화면 핸들러 대입이 최종 판정.
    //   주의: ERP D/O 알림(MSG01401/AS-IS MSG00189)은 여기(편집 진입)에서 내지 않는다. AS-IS 는
    //   shtPlanDetail_Change(셀 값이 실제로 바뀌는 CellsUpdated)에서만 경고하는데, ERP_STATUS=='C' 행의
    //   편집 셀은 isDetailCellEditable 에서 이미 잠겨(SHIPMENT_STATUS=='C' && ERP_STATUS!='C') 값이 바뀔
    //   길이 없으므로 재현 대상이 없다. 진입 시점에 띄우면 값을 바꾸지 않고 더블클릭만 해도 과발화한다
    //   (2026-10-16 신고 — AS-IS 는 클릭/더블클릭만으로는 뜨지 않음). 진입 취소(e.cancel)로 잠금은 유지.
    const beginningEditHandler = (
      sender: FlexGridType,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      e.cancel = !isDetailCellEditable(SHEETS.PLAN_DETAIL, row, binding, editableRef.current);
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // 붙여넣기 게이트 — 클릭 편집과 동일 판정 전체대입
    const pastingCellHandler = (
      sender: FlexGridType,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      e.cancel = !isDetailCellEditable(SHEETS.PLAN_DETAIL, row, binding, editableRef.current);
    };
    g.pastingCell.addHandler(pastingCellHandler);

    // 편집가능 셀 시각 계층 (INPUT_TP_CD 전건 'S' 화면 4계층 세트 — 클릭/paste/저장검증/시각).
    const formatItemHandler = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel !== sender.cells) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      e.cell.classList.toggle(
        'wj-cell-editable',
        isDetailCellEditable(SHEETS.PLAN_DETAIL, row, binding, editableRef.current)
      );
    };
    g.formatItem.addHandler(formatItemHandler);

    // 파생/전파 (03 §3.2):
    //   - CHANGE_REASON_DETAIL: CODE 가 '-'/공백이면 입력 되돌림 + MSG01291
    //   - CHANGE_REASON_CODE: '-'/공백이면 DETAIL 클리어(SO 공백이면 EDIT_MAIN 세팅 없이 종료)
    //   - SO그룹 전파: ERP_SO_NO 비공백 시 동일 SO 全행 전파 + EDIT_MAIN='Y'
    const cellEditEndedHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (!propagateSet.has(binding) && binding !== 'CHANGE_REASON_CODE' && binding !== 'CHANGE_REASON_DETAIL')
        return;
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

      // SO 그룹 전파 대상 컬럼(TRANSPORT_MODE/DOM_EXP/FACTORY_ID/PACKAGE_TYPE) 또는 CHANGE_REASON.
      if (!propagateSet.has(binding) && binding !== 'CHANGE_REASON_CODE') {
        sender.collectionView?.refresh();
        return;
      }

      row.EDIT_MAIN = 'Y';
      if (soNo !== '') {
        const source = (sender.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
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
    g.pastedCell.addHandler(cellEditEndedHandler);

    // ERP_SO_NO(PO No) 더블클릭 → SSP0300 Order Detail 팝업 (AS-IS SpdDetail_CellDoubleClick).
    //   Wijmo 그리드 이벤트가 아니라 hostElement DOM dblclick 에 건다(자매 shipment-plan 정본과 동일).
    //   가드: 직전 두 클릭이 같은 셀일 때만 더블클릭으로 인정한다 — 셀을 바꿔 가며 클릭하면 dblclick 이
    //   공통 조상(hostElement)에 디스패치돼 팝업이 임의로 열린다(2026-10-12 자매 보고).
    const dblClickHandler = (ev: MouseEvent) => {
      if (g.rows.length === 0) return;
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      if (!dblClickGuard.accepts({ row: ht.row, col: ht.col })) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      if (binding !== 'ERP_SO_NO') return;
      const row = GridUtils.getRow(g, ht.row) as Record<string, unknown> | undefined;
      if (!row) return;
      // AS-IS 가드는 ""·null 만 보지만, SO 없는 행은 SP 가 '-' 로 채우므로('-' AS ERP_SO_NO 플레이스홀더)
      //   ''·'-' 둘 다 "값 없음" 으로 보고 걸러 빈 팝업을 막는다(자매 SSP0060 선례).
      const erpSoNo = str(row.ERP_SO_NO).trim();
      if (erpSoNo === '' || erpSoNo === '-') return;
      onOrderDetailRef.current({
        divisionId: str(row.DIVISION_ID),
        erpSoNo,
        confirmId: str(row.CONFIRM_ID),
        itemId: str(row.ITEM_ID),
      });
    };
    g.hostElement.addEventListener('dblclick', dblClickHandler);

    // 클릭 — 더블클릭 가드 기록 전용. early return 보다 먼저 track() 한다(헤더·빈영역도 null 기록해야
    //   "헤더 클릭 → 셀 클릭" 이 같은 셀로 오인되지 않는다).
    const clickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      const isCell = ht.cellType === CellType.Cell;
      dblClickGuard.track(isCell ? { row: ht.row, col: ht.col } : null);
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

  // Detail ColumnFooter 합계 (03 §3.4) — 시트별 수치 구간 Sum 집계.
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
      const sumSet = new Set(order.slice(from + 1, toIdx < 0 ? order.length : toIdx));
      if (g.columnFooters.rows.length === 0) g.columnFooters.rows.push(new GroupRow());
      g.columns.forEach(col => {
        col.aggregate = sumSet.has(col.binding ?? '') ? Aggregate.Sum : Aggregate.None;
      });
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns, rowsBySheet, activeDetailSheet]);

  // 음수 = 빨간 글자 + 수량 셀 천단위 콤마 (AS-IS 프레임워크 NumberCellType.NegativeRed=true·ShowSeparator=true
  //   가 전 수치 셀에 공통 적용, SSP0023 .cs 에 개별 코드가 없는 것은 프레임워크 기본값이라서다). detail 3-sheet
  //   전부 대상 — 수치 셀만 음수가 되고 문자/코드 셀은 toGridNumber 가 0 으로 떨어뜨려 음수판정에서 빠진다.
  //   콤마·소수: AS-IS 화면은 수량 셀을 소수 3자리 고정(.000)으로 렌더한다(라이브 실측, 2026-10-16 —
  //   메인과 동일 관례, footer `{0:#,##0.###}` 3자리 cs:5668 도 뒷받침). 천단위 콤마 + 소수 3자리 고정. 대상은 메타 우측정렬(horzAlgnCd='R')
  //   컬럼이면서 값이 순수 숫자형인 셀로 한정 — 코드/문자·하이픈 날짜는 정규식에서, 8자리 yyyymmdd 날짜는
  //   명시 가드로 제외해 콤마 오염을 막는다. 공용 paintNegativeText 는 비음수면 color 를 지워 셀 DOM 재사용
  //   잔류를 막고, important 라 편집/잠금 셀 글자색보다 우선한다.
  useEffect(() => {
    const handlers: { g: FlexGridType; h: (s: FlexGridType, e: { panel: unknown; row: number; col: number; cell: HTMLElement }) => void }[] = [];
    DETAIL_SHEETS.forEach(sheet => {
      const g = gridRefs[sheet]?.current;
      if (!g) return;
      // 우측정렬(숫자 관행) 컬럼 집합 — admin 메타 horzAlgnCd='R'. 소수부 유지 콤마의 대상 후보.
      const numericSet = new Set(
        (staticColumns[sheet] ?? []).filter(c => c.horzAlgnCd === 'R').map(c => c.colNm)
      );
      const negativeHandler = (
        sender: FlexGridType,
        e: { panel: unknown; row: number; col: number; cell: HTMLElement }
      ) => {
        if (e.panel !== sender.cells) return;
        const binding = sender.columns[e.col]?.binding ?? '';
        const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
        if (!row) return;
        paintNegativeText(e.cell, toGridNumber(row[binding]));
        // 수량 셀 천단위 콤마 + 소수 3자리 고정 (AS-IS 화면 .000 재현).
        if (!numericSet.has(binding)) return;
        const raw = (e.cell.textContent ?? '').trim().replace(/,/g, '');
        if (/^(19|20)\d{6}$/.test(raw)) return; // yyyymmdd 날짜 — 포맷 제외
        if (/^-?\d+(\.\d+)?$/.test(raw)) {
          e.cell.textContent = Number(raw).toLocaleString('en-US', {
            minimumFractionDigits: 3,
            maximumFractionDigits: 3,
          });
        }
      };
      g.formatItem.addHandler(negativeHandler);
      handlers.push({ g, h: negativeHandler });
    });
    return () => {
      handlers.forEach(({ g, h }) => {
        try {
          g.formatItem?.removeHandler(h);
        } catch {
          // unmount race
        }
      });
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns, rowsBySheet, activeDetailSheet]);

  // PlanDetail 외 2-sheet 는 read-only — 어떤 액션으로도 편집 UI 미노출 (03 §1)
  const isReadOnlySheet = (sheet: DetailSheet): boolean => sheet !== SHEETS.PLAN_DETAIL;

  // 날짜 컬럼 형식을 조회값과 같은 대시(yyyy-MM-dd)로 고정 — 공용 getFormat 은 점 형식(yyyy.MM.dd)을 준다.
  //   조회값은 문자열이라 대시로 보이지만, 달력으로 고친 셀은 Date 가 되어 점 형식으로 표시·커밋된다.
  //   시트별 그리드가 여러 개라 단일 ref 훅 대신 전 시트에 한 번에 붙인다(SSP0015 Detail 과 같은 처방).
  //   탭은 persist 로 전부 마운트되어 있어 비활성 탭도 함께 적용된다. 컬럼 재생성은 updatedLayout 이 따라간다.
  useEffect(() => {
    const cleanups = DETAIL_SHEETS.map(sheet => gridRefs[sheet]?.current)
      .filter((g): g is FlexGridType => !!g)
      .map(g => attachDashDateFormat(g));
    return () => cleanups.forEach(fn => fn());
  }, [gridRefs, staticColumns, activeDetailSheet]);

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
            staticColumns={staticColumns[sheet] ?? []}
            comboParams={{ mnuId: `'${MENU_ID}'` }}
            // AllowMerging.Cells 만 주면 컬럼 헤더 병합이 꺼져 정적 컬럼의 단일 라벨이 그룹 헤더행+leaf
            //   행에 각각 찍혀 "같은 텍스트가 여러 줄"로 보인다(2단 헤더 StockDetail 신고 2026-10-11,
            //   memory datagrid-allowmerging-cells-breaks-header-merge). .All 이어야 헤더 병합(정적 컬럼
            //   세로 span)과 데이터 셀 병합(SO 그룹)이 둘 다 동작 — 메인 그리드와 동일.
            allowMerging={AllowMerging.All}
            gotFocus={() => setActiveGrid('detail')}
          />
        </TabItem>
      ))}
    </TabWrapper>
  );
};
