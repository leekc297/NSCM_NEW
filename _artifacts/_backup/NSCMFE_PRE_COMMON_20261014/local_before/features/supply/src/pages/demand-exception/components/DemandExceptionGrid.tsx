import { toggleClass } from '@mescius/wijmo';
import { CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { type MutableRefObject, useEffect, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import { MSG } from '../demand-exception.constants';
import type { MainRow } from '../demand-exception.types';
import { isMainCellEditable } from '../utils/demandExceptionEditLock';

interface Props {
  gridRef: MutableRefObject<FlexGridType<MainRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<MainRow> | undefined>;
  data: MainRow[];
  staticColumns: RawFlexGridColumnConfig[];
  divisionId: string;
  itemModalOpen: boolean;
  onItemModalOpenChange: (open: boolean) => void;
}

/**
 * 메인 그리드 — design/03_grid-columns.md §3 white-list 재현. TO-BE 는 EditButton 편집모드 토글을
 * 이식하지 않으므로(asis_to_tobe.md §11) 기존행은 상시 read-only, 신규행만 편집 가능(판정 로직은
 * utils/demandExceptionEditLock.ts `isMainCellEditable` 단일 진실원 — 공용 `isCellEditable` prop
 * 부재, DataGrid 는 조건부 편집을 `beginningEdit`/`pastingCell` 로 위임).
 *
 * ITEM_ID 셀 더블클릭 → 품목 팝업(`MaterialByDivisionModal`, design/02_search-combo.md §4.6 확정
 * 재사용) — gridSignals#13 SetText 재현. buttonGuards#4·#5(헤더 더블클릭 제외 / 잠금 또는
 * (신규아님&&비편집모드) 시 팝업 차단)를 재현하되, TO-BE 는 "비편집모드" 축이 상시 참(Edit
 * 미이식)이라 실질 조건은 "신규행만 허용"으로 단순화된다(SCP0128 SafetyStock 선례와 동일).
 *
 * 날짜 역전 리셋(gridSignals#14, From>To 시 TO_YYYYMMDD 공백 리셋)은 cellEditEnded 에서 재현.
 *
 * 셀 콤보 4칼럼(OPMZ_PLAN_GR_ID/SCM_SITE_ID/STAGE/VALID_YN)은 `SCM_ADM_CMBO_SQL_M` 전건 미등록
 * 상태(design 03 §1) — STOCK_EXCEPTION(`YesOrNo`)만 실제 등록됨. `staticColumns`(admin fetch)를
 * 그대로 반영하면 미등록 4종은 드롭다운 후보가 비어 렌더될 수 있다(콤보 등록은 admin 소관, 화면이
 * 하드코딩으로 메우지 않는다 — convert-core §2.3/§2.6).
 *
 * SmartColMerge(design 03 §3 규칙#12, line868) — 병합 대상 컬럼이 AS-IS 원본 소스 부재로 미확정
 * (`guides/grid-behavior-parity.md` §1.1 — grep/원문 모두 대상 컬럼 리터럴이 없다). 확인 필요로
 * 명시하고 `allowMerging` 은 배선하지 않는다(임의 컬럼 추정 금지).
 *
 * 신규행 편집가능 셀 시각 강조(`wj-cell-editable`) — 공용 `formatItem`(dataGridUtils
 * formatEditableColumns)은 컬럼메타 INPUT_TP_CD(이 화면 전건 'S')로만 판정해 실제 편집 가능한
 * 신규행 셀에도 클래스가 붙지 않는다(편집 자체는 정상 동작하나 시각 단서만 공백). 화면이
 * `isMainCellEditable` 단일 진실원으로 자체 `formatItem` 핸들러를 추가 배선해 보정한다.
 */
export const DemandExceptionGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
  staticColumns,
  divisionId,
  itemModalOpen,
  onItemModalOpenChange,
}: Props) => {
  const dblClickRowRef = useRef<MainRow | undefined>(undefined);
  const { t } = useTranslation();
  const setAlert = useMessageStore(state => state.setAlert);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as WijmoRowItem | undefined;
      if (!row || !isMainCellEditable(binding, row)) {
        e.cancel = true;
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);
    g.pastingCell.addHandler(beginningEditHandler as never);

    // 공용 formatItem(dataGridUtils formatEditableColumns) 은 컬럼메타 INPUT_TP_CD(전건 'S')로만
    //   wj-cell-editable 을 판정해 신규행 편집가능 셀에도 시각 단서가 붙지 않는다(편집 자체는
    //   beginningEditHandler 가 isMainCellEditable 로 정상 허용). 화면이 같은 단일 진실원으로
    //   재판정해 시각 단서를 보정한다(DataGrid 가 공용 핸들러를 먼저 붙이므로 이 핸들러가 나중에
    //   같은 클래스를 재설정 — addHandler 는 등록 순서대로 실행됨).
    const formatItemHandler = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel !== sender.cells) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as WijmoRowItem | undefined;
      toggleClass(e.cell, 'wj-cell-editable', isMainCellEditable(binding, row));
    };
    g.formatItem.addHandler(formatItemHandler);

    // gridSignals#14(design 03 §3 규칙#14, line998/999) — From>To 역전 시 TO_YYYYMMDD 공백 리셋.
    const cellEditEndedHandler = (
      sender: FlexGridType<MainRow>,
      e: { row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== 'FROM_YYYYMMDD') return;
      const row = GridUtils.getRow(sender, e.row);
      if (!row) return;
      const from = String(row.FROM_YYYYMMDD ?? '');
      const to = String(row.TO_YYYYMMDD ?? '');
      if (!from || !to || from <= to) return;
      void setAlert({ type: 'alert', content: t(MSG.DATE_RANGE_INVALID, '_Invalid period (start > end).') });
      editTrackerRef.current?.storeChange(row, 'TO_YYYYMMDD', row.TO_YYYYMMDD, '');
      row.TO_YYYYMMDD = '';
      sender.invalidate();
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler as never);

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastingCell?.removeHandler(beginningEditHandler as never);
        g.formatItem?.removeHandler(formatItemHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler as never);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns]);

  // buttonGuards#4 — 헤더 더블클릭 제외. buttonGuards#5(신규행만 허용 — 위 헤더 주석 참조).
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell || ht.col < 0) return;
    const binding = grid.columns[ht.col]?.binding ?? '';
    if (binding !== 'ITEM_ID') return;
    const row = GridUtils.getRow(grid, ht.row);
    if (!row) return;
    if (row.CRUD_TYPE !== 'I' && row.CRUD_TYPE !== 'C') return; // 기존행 = 팝업 차단(Edit 미이식)
    dblClickRowRef.current = row;
    onItemModalOpenChange(true);
  };

  return (
    <>
      <DataGrid<MainRow>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={data}
        staticColumns={staticColumns}
        dblClick={handleDblClick}
      />
      <MaterialByDivisionModal
        open={itemModalOpen}
        modalClose={() => onItemModalOpenChange(false)}
        preSearchParams={{ divisionId, scpModuleType: 'SCP0129' }}
        setSelectedValue={items => {
          const row = dblClickRowRef.current;
          if (row) {
            // gridSignals#13 SetText(e.Row, ITEM_ID, sItemId) 재현.
            editTrackerRef.current?.storeChange(row, 'ITEM_ID', row.ITEM_ID, items);
            row.ITEM_ID = items;
            gridRef.current?.invalidate();
          }
          onItemModalOpenChange(false);
        }}
      />
    </>
  );
};
