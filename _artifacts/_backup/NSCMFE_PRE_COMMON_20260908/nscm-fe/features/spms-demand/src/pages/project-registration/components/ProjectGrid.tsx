import {
  CellType,
  type CellEditEndingEventArgs,
  type CellRangeEventArgs,
  Column,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useCallback, useRef, useState, type MutableRefObject } from 'react';
import { useTranslation } from 'react-i18next';

import { CRUD_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import { AuthManagementPopup } from '../../../components/auth-management-popup';
import { TagLayer, type TagLayerHandle } from '../../../components/tag-layer';
import { attachComboCascadeAutoFill } from '../../../lib/comboCascadeAutoFill';
import {
  keepDivisionCodeDisplay,
  keepServerComboOrder,
  restoreMultiRangeSelection,
} from '../../../lib/grid';
import { RESPONSE_SET, SHEET_INDEX } from '../project-registration.constants';
import { formatSopDate, getProjectComboIdBinding } from '../project-registration.grid-utils';
import { isDraftRegStatus, type ProjectRow } from '../project-registration.types';
import gridStyles from '../ProjectRegistration.module.scss';
import { useProjectRegistrationStore } from '../useProjectRegistrationStore';

interface ProjectGridProps {
  gridRef: MutableRefObject<FlexGrid<ProjectRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ProjectRow[];
  setActiveTab: (tab: SHEET_INDEX) => void;
  onAuthSaved: () => void;
  /** MY_PROJECT(TAB2) 가 활성일 때만 true — PROJECT 는 조회조건을 공유해도 별개(peer) 탭이라
   *  TAB2 조회가 TAB1 의 미저장 편집(insert 등)까지 물어서 dirty confirm 을 띄우면 안 된다. */
  excludeFromDirtyCheck?: boolean;
}

/* =========================================================
 * ProjectGrid
 * ========================================================= */

export const ProjectGrid = ({
  gridRef,
  gridFilterRef,
  data,
  setActiveTab,
  onAuthSaved,
  excludeFromDirtyCheck,
}: ProjectGridProps) => {
  const { t } = useTranslation();

  const setAlert = useMessageStore(state => state.setAlert);

  const editTrackerRef = useRef<EditTracker<ProjectRow> | undefined>();

  /**
   * Tag Layer Handle
   */
  const tagLayerRef = useRef<TagLayerHandle>(null);

  /**
   * 서버 Grid Column
   */
  const staticColumns = useProjectRegistrationStore(
    state => state.staticColumns[RESPONSE_SET.PROJECT]
  );

  // 핸들러(initialized 시 1회 등록)가 최신 컬럼 메타를 보도록 ref 로 미러
  //   콤보 행 필터(ATTRIBUTE2)는 admin Column param2 단일 원천 — FE patch 없음
  const columnsRef = useRef(staticColumns);
  columnsRef.current = staticColumns;

  // ⭐ SDM 공통 — 상위 셀 변경 시 종속 콤보(ATTRIBUTE2) 첫 후보 자동 입력 (CELL_TYPE→STACK_METHOD 등).
  //   DataGrid 는 initialized 를 내부 핸들러(EditTracker/stale clear) 등록이 끝난 뒤 마지막에
  //   호출하므로 여기 등록이 항상 공용 정리보다 뒤에 돈다. 그리드 폐기 시 핸들러도 함께 사라져
  //   별도 detach 는 불필요.
  const handleGridInitialized = useCallback(
    (grid: FlexGrid<ProjectRow>) => {
      restoreMultiRangeSelection(grid);
      // 행 필터(ATTRIBUTE2) 콤보는 그 행으로 좁힌 서버 순서로 복원 (사업부 중복 NAME 섞임 방지)
      keepServerComboOrder(
        grid,
        binding => columnsRef.current?.find(c => c.colNm === binding)?.attribute2
      );
      keepDivisionCodeDisplay(grid);
      attachComboCascadeAutoFill({
        grid,
        getColumns: () => columnsRef.current,
        getEditTracker: () => editTrackerRef.current,
      });
    },
    [editTrackerRef]
  );

  const formatRowHeader = useCallback(
    (grid: FlexGrid<ProjectRow>, event: FormatItemEventArgs) => {
      const row = GridUtils.getRow(grid, event.row);
      if (event.panel.cellType === CellType.RowHeader && event.col === 1) {
        delete event.cell.dataset.status;
        event.cell.textContent = String(event.row + 1);
      } else if (event.panel.cellType === CellType.RowHeader && event.col === 2) {
        delete event.cell.dataset.status;
        event.cell.textContent = '';
        if (row?.CRUD_TYPE) event.cell.dataset.status = String(row.CRUD_TYPE);
      } else if (event.panel.cellType === CellType.TopLeft && event.col === 1) {
        event.cell.textContent = t('LBL00674', '_No');
        event.cell.style.textAlign = 'center';
      }
    },
    [t]
  );

  const handleLoadedRows = useCallback(
    (grid: FlexGrid<ProjectRow>) => {
      // loadedRows가 DataGrid initialized 완료 전에 올 수 있어 Selector/상태 컬럼 생성 뒤로 미룬다.
      globalThis.queueMicrotask(() => {
        if (!grid.hostElement.isConnected || grid.rowHeaders.columns.length < 2) return;
        if (grid.rowHeaders.columns.length === 2) {
          grid.rowHeaders.columns.insert(1, new Column({ align: 'center', width: 40 }));
        }
        grid.rowHeaders.columns[1].width = 40;
        grid.rowHeaders.columns[2].width = 24;
        grid.formatItem.removeHandler(formatRowHeader);
        grid.formatItem.addHandler(formatRowHeader);
        grid.invalidate(true);
      });
    },
    [formatRowHeader]
  );

  /* =====================================================
   * Auth Management Popup
   * ===================================================== */

  const [authPopupOpen, setAuthPopupOpen] = useState(false);

  const [authPopupPjtKey, setAuthPopupPjtKey] = useState('');

  const [authPopupProjectName, setAuthPopupProjectName] = useState('');

  /* =====================================================
   * Focus
   * ===================================================== */

  const handleFocus = () => {
    setActiveTab(SHEET_INDEX.PROJECT);
  };

  /* =====================================================
   * Edit 제한
   * ===================================================== */

  const preventLockedRowEdit = (_grid: FlexGrid<ProjectRow>, event: CellRangeEventArgs) => {
    const row = gridRef.current?.rows[event.row]?.dataItem as ProjectRow | undefined;

    if (row && row.CRUD_TYPE !== CRUD_TYPE.CREATE && !isDraftRegStatus(row.DPJT_REG_STATUS)) {
      event.cancel = true;
    }
  };

  /* =====================================================
   * SOP Date 검증 — 오늘 이전 날짜로 바뀌면 커밋 전에 폐기한다.
   *   ContributeMainGrid 의 cellEditEnding+cancel 패턴과 동일: previousData(편집 전 값)와
   *   activeEditor.value(막 입력한 값)를 비교해 "실제로 바뀐" 경우에만 검사한다 — 그래야 이미
   *   저장된 과거 SOP_DATE 행을 달력만 열었다 닫아도(값 안 바뀜) 알림이 뜨지 않는다.
   * ===================================================== */

  const handleSopDateEditEnding = (grid: FlexGrid<ProjectRow>, event: CellEditEndingEventArgs) => {
    if (grid.columns[event.col]?.binding !== 'SOP_DATE') {
      return;
    }

    const newValue = String(grid.activeEditor?.value ?? event.data ?? '');
    const previousValue = String(event.previousData ?? '');
    const parsed = dayjs(newValue);
    const prevParsed = dayjs(previousValue);
    const changed =
      parsed.isValid() !== prevParsed.isValid() ||
      (parsed.isValid() && !parsed.isSame(prevParsed, 'day'));

    if (!changed || !parsed.isValid() || !parsed.isBefore(dayjs().startOf('day'))) {
      return;
    }

    event.cancel = true;
    // cellEditEnding 안에서 바로 alert 를 열면 wijmo 가 editor 를 정리하기 전에 포커스를
    // 뺏겨 editor 가 남는다 (ContributeMainGrid.tsx 의 rejectWithNotice 와 동일 이유).
    globalThis.setTimeout(() => {
      void setAlert({
        type: 'alert',
        content: t('MSG00714', '_SOP Date는 오늘 이전 날짜를 입력할 수 없습니다.'),
      });
    }, 0);
  };

  /* =====================================================
   * Combo ID 변경
   * ===================================================== */

  const handleCellEditEnded = (grid: FlexGrid<ProjectRow>, event: CellRangeEventArgs) => {
    const binding = grid.columns[event.col]?.binding;

    const row = GridUtils.getRow<ProjectRow>(grid, event.row);

    if (!row) {
      return;
    }

    const idBinding = binding ? getProjectComboIdBinding(binding) : undefined;

    if (!idBinding) {
      return;
    }

    const selectedId = String(grid.getCellData(event.row, event.col, false) ?? '');

    editTrackerRef.current?.storeChange(row, idBinding, row[idBinding], selectedId);

    row[idBinding] = selectedId;
  };

  /* =====================================================
   * Wijmo formatItem
   * ===================================================== */

  const handleFormatItem = (grid: FlexGrid<ProjectRow>, event: FormatItemEventArgs) => {
    const row = GridUtils.getRow(grid, event.row);
    const isNewRow = row?.CRUD_TYPE === CRUD_TYPE.INSERT || row?.CRUD_TYPE === CRUD_TYPE.CREATE;

    if (event.panel.cellType === CellType.RowHeader && event.col === 0) {
      const checkbox = event.cell.querySelector<HTMLInputElement>('input[type="checkbox"]');

      if (isNewRow) grid.rows[event.row].isSelected = false;
      event.cell.classList.toggle('wj-state-disabled', isNewRow);
      event.cell.style.pointerEvents = isNewRow ? 'none' : '';
      if (checkbox) checkbox.disabled = isNewRow;
      return;
    }

    /**
     * 일반 Data Cell만 처리
     */
    if (event.panel.cellType !== CellType.Cell) {
      return;
    }

    const binding = grid.columns[event.col]?.binding;

    const isEditing = grid.editRange?.contains(event.row, event.col) ?? false;

    /* ===================================================
     * Tag Column 여부
     * =================================================== */

    const isProjectStatus = binding === 'DPJT_REG_STATUS_NAME';

    const isAuthStatus = binding === 'DPJT_ATUH_REG_STATUS_NAME';

    const isTagColumn = isProjectStatus || isAuthStatus;

    /**
     * Wijmo는 Cell DOM을 다른 Row / Column 용도로
     * 재사용할 수 있으므로,
     *
     * 현재 Tag 컬럼이 아니거나 Editing 중이면
     * 과거 Tag를 제거한다.
     */
    if (!isTagColumn || isEditing) {
      tagLayerRef.current?.clear(event.cell);
    }

    /* ===================================================
     * SOP Date
     * =================================================== */

    // 신규 행도 포맷한다 — 붙여넣기로 들어온 "YYYY-MM-DD HH:mm:ss" 문자열이 시분초째 노출되는 문제.
    if (binding === 'SOP_DATE' && !isEditing) {
      event.cell.textContent = formatSopDate(row?.SOP_DATE);
    }

    if (binding === 'REG_REQ_DATE' && !isNewRow && !isEditing) {
      event.cell.textContent = formatSopDate(row?.REG_REQ_DATE);
    }
    /* ===================================================
     * 프로젝트 등록 상태
     * =================================================== */

    if (isProjectStatus && !isEditing && row?.DPJT_REG_STATUS_NAME) {
      tagLayerRef.current?.apply(
        event.cell,
        row.DPJT_REG_STATUS_NAME,
        row.DPJT_REG_STATUS_COLOR_TYPE
      );
    } else if (isAuthStatus && !isEditing && row?.DPJT_ATUH_REG_STATUS_NAME) {
      /* ===================================================
       * 권한 등록 상태
       * =================================================== */
      tagLayerRef.current?.apply(
        event.cell,
        row.DPJT_ATUH_REG_STATUS_NAME,
        row.DPJT_ATUH_REG_STATUS_COLOR_TYPE
      );
    } else if (isTagColumn) {
      /* ===================================================
       * Tag 컬럼이지만 값 없음
       * =================================================== */
      tagLayerRef.current?.clear(event.cell);
    }

    /* ===================================================
     * Auth Management Link
     * =================================================== */

    event.cell.classList.toggle(gridStyles.authRegistrationLink, binding === 'DPJT_ATUH_REG_STR');
  };

  /* =====================================================
   * Grid Click
   * ===================================================== */

  const handleGridClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;

    if (!grid) {
      return;
    }

    const hitTest = grid.hitTest(mouseEvent);

    if (hitTest.cellType !== CellType.Cell) {
      return;
    }

    const dataItem = GridUtils.getRow(grid, hitTest.row);

    const binding = GridUtils.getBinding(grid, hitTest.col);

    if (!dataItem || binding !== 'DPJT_ATUH_REG_STR') {
      return;
    }

    /**
     * 미저장 신규 Row는
     * Project Key가 없으므로 Popup Open 불가
     */
    if (!dataItem.DPJT_KEY) {
      return;
    }

    setAuthPopupPjtKey(dataItem.DPJT_KEY);

    setAuthPopupProjectName(dataItem.DPJT_NAME);

    setAuthPopupOpen(true);
  };

  /* =====================================================
   * Render
   * ===================================================== */

  return (
    <>
      {/*
       * DataGrid보다 먼저 Mount한다.
       *
       * formatItem 최초 호출 시에도
       * tagLayerRef.current가 존재하도록 한다.
       */}
      <TagLayer ref={tagLayerRef} />

      <DataGrid<ProjectRow>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={data}
        staticColumns={staticColumns}
        useCheckbox
        initialized={handleGridInitialized}
        excludeFromDirtyCheck={excludeFromDirtyCheck}
        gotFocus={handleFocus}
        click={handleGridClick}
        formatItem={handleFormatItem}
        loadedRows={handleLoadedRows}
        cellEditEnding={handleSopDateEditEnding}
        cellEditEnded={handleCellEditEnded}
        // 붙여넣기도 NAME 콤보 → 코드 컬럼(BIZ_TYPE 등) 동기화를 태운다 — 없으면 코드가 빈 채로
        // 남아 저장 검증에서 필수값 알림이 뜬다 (직접 편집은 cellEditEnded 경로).
        pastedCell={handleCellEditEnded}
        beginningEdit={preventLockedRowEdit}
        pastingCell={preventLockedRowEdit}
      />

      <AuthManagementPopup
        open={authPopupOpen}
        pjtKey={authPopupPjtKey}
        projectName={authPopupProjectName}
        onClose={() => setAuthPopupOpen(false)}
        onSaved={onAuthSaved}
      />
    </>
  );
};
