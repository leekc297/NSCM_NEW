import { CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { type MutableRefObject, useEffect, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { PrecedeSafetyStockDayRow } from '../precede-safety-stock-day.types';
import { isMainCellEditable } from '../utils/precedeSafetyStockDayEditLock';

interface Props {
  gridRef: MutableRefObject<FlexGridType<PrecedeSafetyStockDayRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<PrecedeSafetyStockDayRow> | undefined>;
  data: PrecedeSafetyStockDayRow[];
  staticColumns: RawFlexGridColumnConfig[];
  isEditMode: boolean;
  divisionId: string;
  itemModalOpen: boolean;
  onItemModalOpenChange: (open: boolean) => void;
}

/**
 * 메인 그리드 — 이중 잠금 구조(design/03_grid-columns.md §4.2·§4.3, G-01 iter-2 갱신):
 *   (1) 조회 직후 전 칼럼 read-only, `isEditMode`(Edit 토글 아님 — `hasButton('EDIT')` 화면
 *       Load 시점 편집권한, memory ssp0025-no-edit-toggle-always-editable)가 true 일 때만 해제.
 *   (2) 신규행은 isEditMode 무관 편집가능 10칼럼 즉시 활성 — DIVISION_ID·감사4칼럼만 잠금.
 * 판정 로직은 utils/precedeSafetyStockDayEditLock.ts `isMainCellEditable` 단일 진실원(공용
 * `isCellEditable` prop 부재, DataGrid 는 조건부 편집을 `beginningEdit`/`pastingCell` 로 위임).
 *
 * ITEM_ID 셀 더블클릭 → 품목 팝업(`MaterialByDivisionModal`, design/03_grid-columns.md §4.2·
 * 00_checklist.md gridSignals#13 SetText) — 조회조건(§4.6)과 별개 인스턴스. buttonGuards#4·#5
 * (00_checklist.md §4d — 헤더 더블클릭 제외 / 잠금 또는 (신규아님&&비편집모드) 시 팝업 차단)를
 * 재현한다. dblClick 은 DataGrid 공용 prop(hostElement 네이티브 리스너)을 쓴다 — MaterialByDivision
 * Modal 자체의 그리드 더블클릭 처리와 동일 패턴(hitTest 로 셀 판별).
 *
 * 셀 콤보 5칼럼(VALUE_TYPE/OPMZ_PLAN_GR_ID/SCM_SITE_ID/STAGE/VALID_YN) 중 4칼럼(VALUE_TYPE/
 * SCM_SITE_ID/STAGE/VALID_YN)은 `SCM_ADM_CMBO_SQL_M` 미등록 상태(G-03, 03_grid-columns.md §6.3,
 * iter-2 재실측 동일 — PlanGroup 1건만 등록 확인). `staticColumns`(admin fetch)를 그대로 반영하면
 * `cellCboDataTp` 는 있으나 `SCM_ADM_CMBO_SQL_M` 조회가 0건이라 드롭다운이 비어 렌더된다
 * (콤보 등록은 admin 소관, 화면이 하드코딩으로 메우지 않는다 — convert-core §2.3/§2.6).
 *
 * G-04(iter-2) — AS-IS `SmartColMerge()`(gridSignals#12, line897, `SpdMain_TopChange` 경로)에
 * 대응하는 셀 병합(allowMerging/MergeManager) 배선이 이 컴포넌트에 없다. 병합 대상 칼럼은
 * AS-IS `.cs` 원본(GSCM 미러 SCP0127 폴더 부재, 이번 회차도 재확인 — 여전히 파일 없음) 없이는
 * 확정할 수 없다 — grep 0건을 "병합 없음"으로 단정하지 않고(guides/grid-behavior-parity.md 원칙)
 * "확인 필요(원본 미접근)" 상태를 이 주석으로 명시한다. 원본 확보 시 재작업 대상.
 */
export const PrecedeSafetyStockDayGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
  staticColumns,
  isEditMode,
  divisionId,
  itemModalOpen,
  onItemModalOpenChange,
}: Props) => {
  const isEditModeRef = useRef(isEditMode);
  isEditModeRef.current = isEditMode;

  const dblClickRowRef = useRef<PrecedeSafetyStockDayRow | undefined>(undefined);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 편집 진입 가부 — 이중 잠금 판정(위 컴포넌트 헤더 주석 참조).
    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as WijmoRowItem | undefined;
      if (!row || !isMainCellEditable(binding, row, isEditModeRef.current)) {
        e.cancel = true;
        return;
      }
      // ITEM_ID 는 팝업 셀 — 인라인 편집이 아니라 더블클릭 팝업으로만 채운다(nscm-patterns.md
      //   §5-16 팝업 셀 편집취소 의무). beginningEdit 을 취소해 기본 텍스트 편집을 막는다.
      if (binding === 'ITEM_ID') {
        e.cancel = true;
      }
    };
    g.beginningEdit.addHandler(beginningEditHandler);
    g.pastingCell.addHandler(beginningEditHandler as never);

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastingCell?.removeHandler(beginningEditHandler as never);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns]);

  // buttonGuards#4 — 헤더 더블클릭 제외(00_checklist.md §4d).
  // buttonGuards#5 — 잠금 또는 (신규아님&&비편집모드) 시 품목팝업 오픈 차단.
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell || ht.col < 0) return;
    const binding = grid.columns[ht.col]?.binding ?? '';
    if (binding !== 'ITEM_ID') return;
    const row = GridUtils.getRow(grid, ht.row);
    if (!row) return;
    const isNewRow = row.CRUD_TYPE === 'I' || row.CRUD_TYPE === 'C';
    if (!isNewRow && !isEditModeRef.current) return; // 잠금 시 차단
    dblClickRowRef.current = row;
    onItemModalOpenChange(true);
  };

  return (
    <>
      <DataGrid<PrecedeSafetyStockDayRow>
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
        preSearchParams={{ divisionId, scpModuleType: 'SCP0127' }}
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
