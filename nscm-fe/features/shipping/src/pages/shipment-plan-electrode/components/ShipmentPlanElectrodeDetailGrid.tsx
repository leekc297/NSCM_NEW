import { Aggregate } from '@mescius/wijmo';
import {
  AllowMerging,
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
} from '../shipment-plan-electrode.constants';
import type { DetailSheet } from '../shipment-plan-electrode.types';
import { useShipmentPlanElectrodeStore } from '../useShipmentPlanElectrodeStore';
import { isDetailCellEditable } from '../utils/shipment-plan-electrode.editLock';

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
}: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const activeDetailSheet = useShipmentPlanElectrodeStore(s => s.activeDetailSheet);
  const setActiveDetailSheet = useShipmentPlanElectrodeStore(s => s.setActiveDetailSheet);
  const setActiveGrid = useShipmentPlanElectrodeStore(s => s.setActiveGrid);

  const editableRef = useRef(editable);
  editableRef.current = editable;

  const activeIndex = Math.max(DETAIL_SHEETS.indexOf(activeDetailSheet), 0);

  // PlanDetail 전용 이벤트 배선 (03 §3.1/§3.2)
  const planDetailGridRef = gridRefs[SHEETS.PLAN_DETAIL];
  const planDetailColumns = staticColumns[SHEETS.PLAN_DETAIL];
  useEffect(() => {
    const g = planDetailGridRef?.current;
    if (!g) return;

    const propagateSet = new Set<string>(SO_GROUP_PROPAGATE_COLUMNS);

    // 편집 잠금 + ERP 게이트 (03 §3.1 — ERP_STATUS=='C' 이면 MSG01401 차단).
    //   판정은 e.cancel 전체대입 — INPUT_TP_CD 전건 'S'(갭#5) wrapper 게이트를 화이트리스트만 해제.
    //   wijmo Event 등록 순서 호출이라 나중 등록된 화면 핸들러 대입이 최종 판정.
    const beginningEditHandler = (
      sender: FlexGridType,
      e: { row: number; col: number; cancel: boolean }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      const cellEditable = isDetailCellEditable(SHEETS.PLAN_DETAIL, row, binding, editableRef.current);
      e.cancel = !cellEditable;
      if (!cellEditable && row && str(row.ERP_STATUS) === 'C' && editableRef.current) {
        void setAlert({
          type: 'alert',
          content: t(MSG.ERP_DO_BLOCK, {
            defaultValue:
              '_ERP D/O (Delivery Order) has been created for the plan, so the plan cannot be changed.',
          }),
        });
      }
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

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastingCell?.removeHandler(pastingCellHandler);
        g.formatItem?.removeHandler(formatItemHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(cellEditEndedHandler);
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

  // PlanDetail 외 2-sheet 는 read-only — 어떤 액션으로도 편집 UI 미노출 (03 §1)
  const isReadOnlySheet = (sheet: DetailSheet): boolean => sheet !== SHEETS.PLAN_DETAIL;

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
