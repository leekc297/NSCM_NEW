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
import { GridUtils } from '@foundation/utils';
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
import { DETAIL_SHEETS } from '../utils/shipment-plan.detailSheets';
import {
  buildBtnNewLockedBindings,
  isDetailCellEditable,
} from '../utils/shipment-plan.editLock';

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
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

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
}: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const activeDetailSheet = useShipmentPlanStore(s => s.activeDetailSheet);
  const setActiveDetailSheet = useShipmentPlanStore(s => s.setActiveDetailSheet);
  const setActiveGrid = useShipmentPlanStore(s => s.setActiveGrid);

  const editableRef = useRef(editable);
  editableRef.current = editable;

  const activeIndex = Math.max(DETAIL_SHEETS.indexOf(activeDetailSheet), 0);

  // PlanDetail 전용 이벤트 배선 (03 §3-B/C/D)
  const planDetailGridRef = gridRefs[SHEETS.PLAN_DETAIL];
  const planDetailColumns = staticColumns[SHEETS.PLAN_DETAIL];
  useEffect(() => {
    const g = planDetailGridRef?.current;
    if (!g) return;

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
            content: t(MSG.REASON_CODE_FIRST, { defaultValue: '_Please enter Reason Code.' }),
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
    //   CHANGE_REQ_NO(비공백 시 ConfirmDetail 팝업). ERP_SO_NO(OrderDetail, SSP0300)는 TO-BE
    //   팝업 부재로 미배선 — 04_react-gap.md 확인필요(사용자 축).
    const dblClickHandler = (ev: MouseEvent) => {
      if (g.rows.length === 0) return;
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      const row = GridUtils.getRow(g, ht.row) as WijmoRowItem | undefined;
      if (!row) return;
      if (binding === 'ITEM_ID' && str(row.CRUD_TYPE) === 'I') {
        onItemCellSearch(row);
      } else if (binding === 'PROJECT_CODE' && str(row.CRUD_TYPE) === 'I') {
        onProjectCellSearch(row);
      }
    };
    g.hostElement.addEventListener('dblclick', dblClickHandler);

    const clickHandler = (ev: MouseEvent) => {
      if (g.rows.length === 0) return;
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
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

  // Detail ColumnFooter 합계 (I16 — AS-IS InitSpreadFooterSum L764~853): 시트별 수치 구간에
  //   Sum 집계(SumIgnoreHidden 등가 — wijmo Aggregate 는 visible 무관 소스 집계라 hidden 컬럼도
  //   합산되나 대상 구간이 수치 컬럼 한정이라 실효 동일). 'Sum' 라벨 셀·LightGray 배경은 공용
  //   footer 스타일을 따른다(시각 축 — 사용자 확인).
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
            staticColumns={staticColumns[sheet] ?? []}
            comboParams={{ mnuId: `'${MENU_ID}'` }}
            allowMerging={AllowMerging.Cells}
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
