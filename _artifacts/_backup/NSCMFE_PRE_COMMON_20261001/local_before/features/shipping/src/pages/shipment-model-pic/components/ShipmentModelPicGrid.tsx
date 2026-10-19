import { AllowMerging, CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabLookupQueries } from '@shared/hooks';

import {
  LOOKUP,
  MAIN_COLUMNS,
  MENU_ID,
  OPERATION_GROUP_WARRANTY_CODE,
  OPERATION_GROUP_WARRANTY_NAME,
  USER_POPUP_NAME_COLUMN,
} from '../shipment-model-pic.constants';
import type { MainRow } from '../shipment-model-pic.types';
import { buildColumns } from '../utils/shipmentModelPicColumns';
import { isInlineEditable, isUserPopupColumn } from '../utils/shipmentModelPicEditLock';

interface Props {
  rows: MainRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  division: string;
  adminColumns?: RawFlexGridColumnConfig[];
  // 이미지셀(USER 계열 7) 더블클릭 -> 페이지가 UserInfoPopup 오픈(row/binding 기억). design 03 §1.1.
  onUserCellDblClick: (row: Record<string, unknown>, binding: string) => void;
  onFocus: () => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// AS-IS spdMain "Shipment Model PIC" (단일 그리드 21열). 조회=전체 lock, Edit=SwitchLock 편집셀만 unlock.
export const ShipmentModelPicGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  division,
  adminColumns,
  onUserCellDblClick,
  onFocus,
}: Props) => {
  const columns = useMemo(() => buildColumns(MAIN_COLUMNS, adminColumns), [adminColumns]);

  // 자동 콤보 셀(FROM_SITE=PlantSiteByDivision @divisionId, VALID_YN=YesOrNo)의 @토큰 해소.
  //   getCombo funnel 이 인용 처리(pre-quote idempotent, nscm-patterns §3.3).
  const comboParams = useMemo(
    () => ({ mnuId: `'${MENU_ID}'`, divisionId: `'${division}'` }),
    [division]
  );

  // OPERATION_GROUP 표시 매핑 — lookup NAME(P/A/E) + 클라 W=Warranty (AS-IS cs:183-187 하드코딩).
  const [operationGroupData] = useTabLookupQueries({
    filters: [{ lookupType: LOOKUP.OPERATION_GROUP }],
  });
  const opGroupNameMap = useMemo(() => {
    const m = new Map<string, string>();
    (operationGroupData ?? []).forEach(r => m.set(str(r.CODE), str(r.NAME)));
    m.set(OPERATION_GROUP_WARRANTY_CODE, OPERATION_GROUP_WARRANTY_NAME);
    return m;
  }, [operationGroupData]);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // OPERATION_GROUP 셀 표시 — 코드 -> NAME(W->Warranty), center (design 03 §3 W->Warranty).
    const formatItemHandler = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel !== sender.cells) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      if (binding !== 'OPERATION_GROUP') return;
      const raw = str(sender.getCellData(e.row, e.col, false));
      if (!raw) return;
      e.cell.textContent = opGroupNameMap.get(raw) ?? raw;
      e.cell.style.textAlign = 'center';
    };
    g.formatItem.addHandler(formatItemHandler);

    // 편집 게이트 — VALID_YN(콤보)만 인라인 편집 허용. USER 계열 7은 인라인 편집 취소(팝업 전용,
    //   nscm-patterns §5-16), 13열은 lock 유지(cs:274-278). 그리드는 기본 편집 가능(Edit 토글 없음).
    //   화면 로직이 최종 판정(e.cancel 명시 지정) — 공용 DataGrid 의 defaultEditHandler(dataGridUtils
    //   setEditableColumns)는 컬럼메타 INPUT_TP_CD 로 cancel 을 정하므로, 화면이 cancel 을 재지정한다.
    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      e.cancel = !isInlineEditable(binding);
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // Delete 키로 팝업셀(USER 계열) 값 비우기 — 팝업으로 넣은 배정을 제거하는 수단(인라인 편집은
    //   팝업 전용이라 막혀 있어 키로 직접 비운다). 짝 이름 컬럼도 함께 비우고 EditTracker 'M' 마킹 →
    //   저장 시 USER_ID='' 로 UPDATE(배정 제거). 선택 범위 내 USER 계열 셀만 대상(VALID_YN 등 미관여).
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key !== 'Delete') return;
      const sel = g.selection;
      if (!sel || sel.row < 0) return;
      let changed = false;
      for (let r = sel.topRow; r <= sel.bottomRow; r += 1) {
        const row = GridUtils.getRow(g, r) as Record<string, unknown> | undefined;
        if (!row) continue;
        for (let c = sel.leftCol; c <= sel.rightCol; c += 1) {
          const binding = g.columns[c]?.binding ?? '';
          if (!isUserPopupColumn(binding)) continue;
          const prev = row[binding];
          if (prev === '' || prev == null) continue;
          editTrackerRef.current?.storeChange(row as never, binding, prev as never, '' as never);
          row[binding] = '';
          const nameCol = USER_POPUP_NAME_COLUMN[binding];
          if (nameCol) row[nameCol] = '';
          changed = true;
        }
      }
      if (changed) {
        e.preventDefault();
        g.invalidate();
      }
    };
    g.hostElement.addEventListener('keydown', handleKeyDown);

    return () => {
      try {
        g.formatItem?.removeHandler(formatItemHandler);
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.hostElement?.removeEventListener('keydown', handleKeyDown);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns, opGroupNameMap]);

  // 이미지셀(USER 계열 7) 더블클릭 -> 팝업. 그리드가 기본 편집 가능이라 조회 직후 바로 동작.
  const handleDblClick = (e: MouseEvent) => {
    const g = gridRef.current;
    if (!g) return;
    const ht = g.hitTest(e);
    if (ht.cellType !== CellType.Cell) return;
    const binding = g.columns[ht.col]?.binding ?? '';
    if (!isUserPopupColumn(binding)) return;
    const row = GridUtils.getRow(g, ht.row) as Record<string, unknown> | undefined;
    if (!row) return;
    onUserCellDblClick(row, binding);
  };

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      isReadOnly={false}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      comboParams={comboParams}
      // AS-IS SmartColMerge(cs:223,364,622) 재현 — 동일값 셀 세로 병합. CustomMergeManager 는
      //   좌→우 누적 키라 Division -> Operation Group -> From Site 계층으로 병합되고(상위 컬럼이
      //   모두 같아야 하위가 붙는다), Model 이하 값이 다른 컬럼은 실제로 병합되지 않는다(design 03 §3).
      allowMerging={AllowMerging.Cells}
      dblClick={handleDblClick}
      gotFocus={onFocus}
    />
  );
};
