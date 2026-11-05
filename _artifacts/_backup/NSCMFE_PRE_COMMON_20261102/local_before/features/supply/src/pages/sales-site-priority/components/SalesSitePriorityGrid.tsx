import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { type MutableRefObject, useEffect, useMemo, useState } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';

import { COMBO, SITE_TYPE } from '../sales-site-priority.constants';
import type { SalesSitePriorityRow } from '../sales-site-priority.types';
import { findPlanGroupCodeByName, toCascadeSource } from '../utils/sales-site-priority.cascadeCombo';
import { applyItemSelect, isCellEditable, isItemPopupCell, s } from '../utils/sales-site-priority.editLock';

interface Props {
  rows: SalesSitePriorityRow[];
  gridRef: MutableRefObject<FlexGrid | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  adminColumns?: RawFlexGridColumnConfig[];
  onFocus: () => void;
}

// design 03 §1.1: 그리드 셀콤보 SQL_ID 리터럴 3종(PlanGroup/ScmSite/ValidYn)이 admin 메타
//   CELL_COMBO_DATA_TYPE 에 실려 있으면 공용 DataGrid 자동콤보 경로가 처리한다(§04 콤보_TO-BE.md §4).
//   OPMZ_PLAN_GR_ID(filterCalls#6)·SCM_SITE_ID 둘 다 division cascade PARAM2='DIVISION_ID:DIVISION_ID'
//   가 admin 메타(SCM_MST_SHEET_COLUMNS.ATTRIBUTE2)에 등록돼 있다(gap-resolve iter-1, ora.py 실측 확인).
export const SalesSitePriorityGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  adminColumns,
  onFocus,
}: Props) => {
  const [openItem, setOpenItem] = useState(false);
  const [clickedRow, setClickedRow] = useState<number>(-1);

  // Plan Group 붙여넣기 NAME->CODE 역변환용 원본(AS-IS dtPlanGroupAll, l1062). 조회조건과 별도로
  //   그리드 단독 fetch — 화면 전역 division 이 아니라 붙여넣기 대상 행의 DIVISION_ID 로 좁힌다.
  const [planGroupsRaw] = useTabComboQueries({ filters: [COMBO.PLAN_GROUP] });
  const planGroupSource = useMemo(() => toCascadeSource(planGroupsRaw), [planGroupsRaw]);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 편집 white-list — DIVISION_ID·감사4칸·PRE_KEY_VALUES 항상 잠금, ITEM_ID 는 인라인 입력 허용(AS-IS 동일).
    const beginningEditHandler = (
      sender: FlexGrid,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (!isCellEditable(binding)) {
        e.cancel = true;
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // 붙여넣기 Plan Group 표시명(NAME) -> 코드(CODE) 변환(AS-IS SpdMain_ClipboardPasted l1050~1070,
    //   validations#10~#12/events#5 — 원본 확인 결과 붙여넣기 이벤트가 하는 일은 이 변환뿐이다.
    //   From/To 검증은 붙여넣기 경로에 없다, __asis-mapping__.md 갱신).
    const pastedCellHandler = (sender: FlexGrid, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== 'OPMZ_PLAN_GR_ID') return;
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      const pastedName = s(row.OPMZ_PLAN_GR_ID);
      if (!pastedName) return;
      const matchedCode = findPlanGroupCodeByName(planGroupSource, s(row.DIVISION_ID), pastedName);
      if (matchedCode !== undefined) {
        row.OPMZ_PLAN_GR_ID = matchedCode;
        GridUtils.refreshRow(sender, e.row);
      }
    };
    g.pastedCell.addHandler(pastedCellHandler);

    // ITEM_ID 셀 더블클릭 -> MaterialByDivisionModal(design 02 §4.6, gridSignals#13).
    const dblclickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      if (!isItemPopupCell(binding)) return;
      setClickedRow(ht.row);
      setOpenItem(true);
    };
    g.hostElement.addEventListener('dblclick', dblclickHandler);

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastedCell?.removeHandler(pastedCellHandler);
        g.hostElement?.removeEventListener('dblclick', dblclickHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [adminColumns, planGroupSource]);

  return (
    <>
      <DataGrid<SalesSitePriorityRow>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={rows as unknown as WijmoRowItem[]}
        staticColumns={adminColumns ?? []}
        // SCM_SITE_ID 그리드 셀 콤보(SiteMasterAll_SCP)는 @siteType 필수 등호 조건이라
        //   comboParams 미전달 시 '' 로 치환돼 0건이 된다(runtime-parity-gate SCP0131 v1 §3.2).
        comboParams={{ siteType: `'${SITE_TYPE}'` }}
        gotFocus={onFocus}
      />
      {/* 그리드 셀 Item 팝업 — MaterialByDivisionModal(COM0013), 조회영역과 동일 팝업 재사용(design 02 §4.6). */}
      <MaterialByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={items => {
          const row = GridUtils.getRow(gridRef.current, clickedRow) as
            | Record<string, unknown>
            | undefined;
          if (!row) return;
          applyItemSelect(row, items);
          GridUtils.refreshRow(gridRef.current, clickedRow);
        }}
        preSearchParams={{
          divisionId: s(
            (GridUtils.getRow(gridRef.current, clickedRow) as Record<string, unknown> | undefined)
              ?.DIVISION_ID
          ),
          itemId: '',
        }}
      />
    </>
  );
};
