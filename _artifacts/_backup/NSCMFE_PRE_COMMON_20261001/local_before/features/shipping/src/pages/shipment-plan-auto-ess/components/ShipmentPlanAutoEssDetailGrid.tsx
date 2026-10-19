import { Aggregate } from '@mescius/wijmo';
import {
  AllowMerging,
  CellType,
  DataMap,
  GroupRow,
  type FlexGrid as FlexGridType,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, type MutableRefObject } from 'react';

import type { ComboResponse, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid, TabItem, TabWrapper } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  CELL_COMBO,
  CELL_LOOKUP_TYPE,
  FOOTER_SUM_RANGE,
  MENU_ID,
  MSG,
  SHEETS,
  SO_GROUP_PROPAGATE_COLUMNS,
} from '../shipment-plan-auto-ess.constants';
import { useShipmentPlanAutoEssStore } from '../useShipmentPlanAutoEssStore';
import { DETAIL_SHEETS } from '../utils/shipment-plan-auto-ess.detailSheets';
import { isDetailCellEditable } from '../utils/shipment-plan-auto-ess.editLock';

interface Props {
  rowsBySheet: Partial<Record<SHEETS, WijmoRowItem[]>>;
  gridRefs: Partial<Record<SHEETS, MutableRefObject<FlexGridType | undefined>>>;
  gridFilterRefs: Partial<Record<SHEETS, MutableRefObject<FlexGridFilter | undefined>>>;
  editTrackerRefs: Partial<Record<SHEETS, MutableRefObject<EditTracker | undefined>>>;
  staticColumns: Partial<Record<SHEETS, RawFlexGridColumnConfig[]>>;
  // Detail 편집 = canEdit(hasButton('EDIT'))·최신Plan(realFlag). 셀 단위 범위는 isDetailCellEditable.
  editable: boolean;
  onItemCellSearch: (row: WijmoRowItem) => void; // ITEM_ID 더블클릭(신규행 한정)
  onProjectCellSearch: (row: WijmoRowItem) => void; // PROJECT_CODE 더블클릭(신규행 한정)
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// Detail 7-sheet 그리드 — sheet별 컬럼셋은 admin SCM_MST_SHEET_COLUMNS 메타(191컬럼 실측)가 단일 원천.
//   편집 화이트리스트/SO그룹 전파는 shtPlanDetail 만 코드 재현(design 03 §3). 나머지 시트(Hold stock 포함)
//   는 읽기전용(Hold stock 은 SAVE SP 미배포 — 표시전용, goal.md ②).
//   탭 전환은 조회를 자동 발사하지 않는다 — 2차 Search 버튼/Main 드릴다운만 조회 트리거(hook #81).
export const ShipmentPlanAutoEssDetailGrid = ({
  rowsBySheet,
  gridRefs,
  gridFilterRefs,
  editTrackerRefs,
  staticColumns,
  editable,
  onItemCellSearch,
  onProjectCellSearch,
}: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const activeDetailSheet = useShipmentPlanAutoEssStore(s => s.activeDetailSheet);
  const setActiveDetailSheet = useShipmentPlanAutoEssStore(s => s.setActiveDetailSheet);
  const setActiveGrid = useShipmentPlanAutoEssStore(s => s.setActiveGrid);

  const editableRef = useRef(editable);
  editableRef.current = editable;

  const activeIndex = Math.max(DETAIL_SHEETS.indexOf(activeDetailSheet), 0);

  // 셀 콤보 dataMap 원천 (G1 — design 03 §6-1/2). @lookupType 를 FE 가 직접 실어 조회한다
  //   (공용 DataGrid 자동 셀콤보는 ATTRIBUTE1 공란이라 @lookupType 미전송 → 코드 원문/저장 차단).
  const [shipmentStatusRows, fcstTypeRows, changeReasonRows] = useTabComboQueries({
    filters: [
      { comboId: CELL_COMBO.LOOKUP_COMMON, mnuId: MENU_ID, lookupType: CELL_LOOKUP_TYPE.SHIPMENT_STATUS },
      { comboId: CELL_COMBO.LOOKUP_COMMON, mnuId: MENU_ID, lookupType: CELL_LOOKUP_TYPE.SALES_TYPE_CODE },
      {
        comboId: CELL_COMBO.CHANGE_REASON_CODE_ALL,
        mnuId: MENU_ID,
        lookupType: CELL_LOOKUP_TYPE.CHANGE_REASON_CODE,
      },
    ],
  });
  // oWMS STOCK_STATUS — LOOKUP_TYPE DB 부재(0행 실측). 빈 목록이면 dataMap 미주입(원문 노출, 04 확인필요).
  const [stockStatusRows] = useTabComboQueries({
    filters: [{ comboId: CELL_COMBO.LOOKUP_COMMON3, mnuId: MENU_ID, lookupType: CELL_LOOKUP_TYPE.STOCK_STATUS }],
  });

  const buildMap = (rows: ComboResponse[] | undefined): DataMap | undefined => {
    if (!rows || rows.length === 0) return undefined;
    return new DataMap(
      rows.map(r => ({ CODE: str(r.CODE), NAME: str(r.NAME) || str(r.CODE) })),
      'CODE',
      'NAME'
    );
  };
  const shipmentStatusMap = useMemo(() => buildMap(shipmentStatusRows), [shipmentStatusRows]);
  const fcstTypeMap = useMemo(() => buildMap(fcstTypeRows), [fcstTypeRows]);
  const changeReasonMap = useMemo(() => buildMap(changeReasonRows), [changeReasonRows]);
  const stockStatusMap = useMemo(() => buildMap(stockStatusRows), [stockStatusRows]);

  // PlanDetail 전용 이벤트 배선 (design 03 §3.2/§3.3/§3.7)
  const planDetailGridRef = gridRefs[SHEETS.PLAN_DETAIL];
  const planDetailColumns = staticColumns[SHEETS.PLAN_DETAIL];

  // 셀 콤보 dataMap 주입 (G1). 공용 DataGrid 가 매 렌더 columnGroups 재생성으로 메타 콤보맵을 덮으므로
  //   updatedLayout 마다 재부착한다([[wijmo-columngroups-recreate-datamap]]). 빈 맵은 부착하지 않는다.
  const owmsGridRef = gridRefs[SHEETS.OWMS_DETAIL];
  const owmsColumns = staticColumns[SHEETS.OWMS_DETAIL];
  useEffect(() => {
    const attach = (
      grid: FlexGridType | undefined,
      maps: Record<string, DataMap | undefined>
    ): (() => void) => {
      if (!grid) return () => undefined;
      const apply = () => {
        Object.entries(maps).forEach(([binding, map]) => {
          if (!map) return;
          const col = grid.columns.getColumn(binding);
          if (col && col.dataMap !== map) col.dataMap = map;
        });
      };
      grid.updatedLayout.addHandler(apply);
      apply();
      return () => {
        try {
          grid.updatedLayout?.removeHandler(apply);
        } catch {
          // unmount race
        }
      };
    };
    const detachPlan = attach(planDetailGridRef?.current, {
      SHIPMENT_STATUS: shipmentStatusMap,
      FCST_TYPE: fcstTypeMap,
      CHANGE_REASON_CODE: changeReasonMap,
    });
    const detachOwms = attach(owmsGridRef?.current, { STOCK_STATUS: stockStatusMap });
    return () => {
      detachPlan();
      detachOwms();
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [
    planDetailColumns,
    owmsColumns,
    shipmentStatusMap,
    fcstTypeMap,
    changeReasonMap,
    stockStatusMap,
  ]);
  useEffect(() => {
    const g = planDetailGridRef?.current;
    if (!g) return;

    const propagateSet = new Set<string>(SO_GROUP_PROPAGATE_COLUMNS);

    // 편집 잠금 + ERP 게이트 (design 03 §3.3 — ERP_STATUS=='C' 이면 MSG01401 로 차단).
    //   메타 INPUT_TP_CD 전건 'S' 라 공용 wrapper 게이트가 화이트리스트까지 취소하므로, 나중에 등록된
    //   화면 핸들러의 e.cancel 대입이 최종 판정이 된다(wijmo 등록 순서 호출).
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
        editableRef.current
      );
      e.cancel = !cellEditable;
      if (!cellEditable && row && str(row.ERP_STATUS) === 'C' && editableRef.current) {
        void setAlert({
          type: 'alert',
          content: t(MSG.ERP_DO_BLOCK, {
            defaultValue:
              '_ERP D/O (Delivery Order) has been created for the plan, so the SSP plan cannot be changed.',
          }),
        });
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // 붙여넣기 게이트 (design 03 §3.3 — 잠금해제 셀만 허용)
    const pastingCellHandler = (
      sender: FlexGridType,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      e.cancel = !isDetailCellEditable(SHEETS.PLAN_DETAIL, row, binding, editableRef.current);
    };
    g.pastingCell.addHandler(pastingCellHandler);

    // 편집가능 셀 시각 계층 — 공용 wrapper 가 메타('S') 기준으로 wj-cell-editable 을 끄므로, 나중에
    //   등록된 이 핸들러가 화이트리스트 판정으로 재대입한다(등록 순서 호출 — 최종 판정).
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

    // 파생/전파 (design 03 §3.2/§3.3):
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
            return; // SO 공백 — EDIT_MAIN 세팅 없이 종료 (design 03 §3.3)
          }
        }
      }

      row.EDIT_MAIN = 'Y';
      if (soNo !== '') {
        // 동일 SO그룹 전파 — CHANGE_REASON 은 CODE+DETAIL 동시 (design 03 §3.2)
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
    g.pastedCell.addHandler(cellEditEndedHandler);

    // 더블클릭 — ITEM_ID·PROJECT_CODE(신규행 한정, 가드는 페이지 콜백에서 MSG00013).
    //   CHANGE_REQ_NO(SCM0002_ShipmentPlanRequestPopup)·ERP_SO_NO(SSP0300 OrderDetail) 팝업은 TO-BE
    //   부재로 미배선 — 04_react-gap.md 확인필요(사용자 축).
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

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastingCell?.removeHandler(pastingCellHandler);
        g.formatItem?.removeHandler(formatItemHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(cellEditEndedHandler);
        g.hostElement?.removeEventListener('dblclick', dblClickHandler);
      } catch {
        // unmount race
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [planDetailColumns, rowsBySheet[SHEETS.PLAN_DETAIL]]);

  // Detail ColumnFooter 합계 (design 03 §1.4~1.10 — 시트별 수치 구간 Sum 집계)
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

  // 읽기전용 6-sheet(Hold stock 포함) 는 isReadOnly — 편집 UI 미노출 (design 03 §1.4~1.10)
  const isReadOnlySheet = (sheet: SHEETS): boolean => sheet !== SHEETS.PLAN_DETAIL;

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
            // Detail 7시트는 AS-IS 병합 신호 0 (merge 전건 spdMain 전용 — design 03 §3.5). 세로 병합 금지(G7).
            allowMerging={AllowMerging.None}
            gotFocus={() => setActiveGrid('detail')}
          />
        </TabItem>
      ))}
    </TabWrapper>
  );
};
