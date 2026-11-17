import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, type MutableRefObject } from 'react';

import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { SHEETS } from '../constraint-mgmt.constants';
import type { MasterRow } from '../constraint-mgmt.types';
import { useConstraintMgmtStore } from '../useConstraintMgmtStore';
import { applyCanEditGuard } from '../utils/constraintMgmt.editGuard';

interface ConstraintMgmtMasterGridProps {
  gridRef: MutableRefObject<FlexGrid<MasterRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<MasterRow> | undefined>;
  data: MasterRow[];
  canEdit: boolean;
  /** 하단 미저장 변경을 버리고 진행해도 되는지. 변경이 없으면 바로 true 다. */
  confirmDiscardDetail: () => Promise<boolean>;
  /** LOOKUP_TYPE 컬럼 더블클릭 재조회(2026-11-09). 권한 게이트·미저장 변경 확인은 상위에서 처리한다. */
  onRefresh: () => void;
}

/** 상단 Lookup Type 그리드. LOOKUP_TYPE 컬럼 더블클릭이 하단의 컬럼 사전과 조회 키를 동시에 만든다. */
export const ConstraintMgmtMasterGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
  canEdit,
  confirmDiscardDetail,
  onRefresh,
}: ConstraintMgmtMasterGridProps) => {
  const staticColumns = useConstraintMgmtStore(state => state.staticColumns.lookupMaster);
  const setActiveGrid = useConstraintMgmtStore(state => state.setActiveGrid);
  const setSubFilters = useConstraintMgmtStore(state => state.setSubFilters);
  const applyDynamicSubColumns = useConstraintMgmtStore(state => state.applyDynamicSubColumns);
  const mainLookupType = useConstraintMgmtStore(state => state.mainLookupType);
  const mainLookupTypeRef = useRef(mainLookupType);
  mainLookupTypeRef.current = mainLookupType;

  const canEditRef = useRef(canEdit);
  canEditRef.current = canEdit;

  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    return applyCanEditGuard(grid, canEditRef);
  }, [gridRef, staticColumns]);

  const handleGotFocus = () => {
    setActiveGrid('main');
  };

  /**
   * 더블클릭 -> Sub 컬럼 재구성 + Sub 조회(drill-down) 또는 재조회, LOOKUP_TYPE 컬럼 한정
   * (2026-11-09, 단일 클릭 선택도 LOOKUP_TYPE 더블클릭으로 좁히라는 추가 지시로 click 핸들러를
   * 여기로 합쳤다). 다른 컬럼(설명·사용여부 등) 더블클릭은 편집 동작과 섞이지 않도록 아무
   * 것도 하지 않는다 — AS-IS spdMain.CellDoubleClick(cs:849~864)과 다시 같은 트리거다.
   *
   * 더블클릭한 행이 이미 선택된 LOOKUP_TYPE 이면 "같은 걸 또 더블클릭" = 재조회 의도로 보고
   * onRefresh(상/하단 재조회, 2026-11-09)를 부른다. 다른 LOOKUP_TYPE 이면 drill-down이다 —
   * 하단에 미저장 변경이 있으면 confirmDiscardDetail 로 먼저 묻는다.
   *
   * AS-IS 가드 3개 중 첫 번째(`siMain.IsLock==true` 일 때만 = Main 이 조회모드일 때만)는
   * 이식하지 않는다 — 편집이 기본값인 TO-BE 에서는 그 가드가 Sub 조회를 영구 차단한다
   * (decisions.md §2). 나머지 2개(행 존재 / LOOKUP_TYPE 비어있지 않음)는 유지한다.
   *
   * LOOKUP_TYPE 셀이 편집 가능한 행이면 Wijmo 기본 동작상 이 더블클릭 자체가 먼저 셀 편집을
   * 연다 — 그 직후 isDirty 가 activeEditor 존재만으로 dirty 로 보기 때문에(gridUtils.ts 주석)
   * 아무 입력도 안 했는데 "수정 중인 데이터가 있습니다" 확인창이 매번 뜬다(2026-11-09 사용자
   * 보고). 이 더블클릭이 연 편집은 새로고침/선택 의도일 뿐이라 commit 하지 않고 취소한다 —
   * 그 전에 이미 커밋된 진짜 변경분은 CRUD_TYPE 으로 남아 isDirty 가 여전히 잡아낸다.
   */
  const handleDblClick = async (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const hitTest = grid.hitTest(mouseEvent);
    if (hitTest.cellType !== CellType.Cell) return;
    if (GridUtils.getBinding(grid, hitTest.col) !== 'LOOKUP_TYPE') return;
    if (grid.activeEditor) grid.finishEditing(true);

    const dataItem = GridUtils.getRow(grid, hitTest.row);
    if (!dataItem) return;
    const lookupType = String(dataItem.LOOKUP_TYPE ?? '');
    if (!lookupType) return;

    if (lookupType === mainLookupTypeRef.current) {
      onRefresh();
      return;
    }
    if (!(await confirmDiscardDetail())) return;
    applyDynamicSubColumns(dataItem);
    setSubFilters(lookupType);
  };

  return (
    <DataGrid<MasterRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns}
      sheetName={SHEETS.LOOKUP_MASTER}
      gotFocus={handleGotFocus}
      dblClick={mouseEvent => void handleDblClick(mouseEvent)}
    />
  );
};
