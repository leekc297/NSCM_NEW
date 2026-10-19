import {
  CellType,
  type CellEditEndingEventArgs,
  type CellRangeEventArgs,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useCallback, useRef, useState, type MutableRefObject } from 'react';
import { createPortal } from 'react-dom';
import { useTranslation } from 'react-i18next';

import { CRUD_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { Button } from '@shared/lges';
import { useMessageStore } from '@shared/stores';

import { AuthManagementPopup } from '../../../components/auth-management-popup';
import { TagLayer, type TagLayerHandle } from '../../../components/tag-layer';
import { attachComboCascadeAutoFill } from '../../../lib/comboCascadeAutoFill';
import { DataGrid, keepDivisionCodeDisplay, keepServerComboOrder } from '../../../lib/grid';
import { RESPONSE_SET, SHEET_INDEX } from '../project-registration.constants';
import { formatSopDate, getProjectComboIdBinding } from '../project-registration.grid-utils';
import {
  isDraftRegStatus,
  isPendingRegStatus,
  type ProjectRow,
} from '../project-registration.types';
import gridStyles from '../ProjectRegistration.module.scss';
import { useProjectRegistrationStore } from '../useProjectRegistrationStore';

// 등록요청/요청취소 행 버튼 컬럼 — SDM5010 REG_COL 과 같은 메타 계약(admin Category Setup 에서
//   ATTRIBUTE1='ACTION' 으로 등록, SP 커서는 '' 반환). 컬럼명은 하드코딩하지 않고 메타로 판정.
const REG_ACTION_ATTR = 'ACTION';

interface ProjectGridProps {
  gridRef: MutableRefObject<FlexGrid<ProjectRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ProjectRow[];
  setActiveTab: (tab: SHEET_INDEX) => void;
  onAuthSaved: () => void;
  onRequest: (row: ProjectRow) => void;
  onCancelRequest: (row: ProjectRow) => void;
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
  onRequest,
  onCancelRequest,
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

  // 행 버튼 portal 컨테이너 — DPJT_KEY 별 1개 (SDM5010 ProjectMasterTab1Grid 와 동일 방식)
  const actionPortalsRef = useRef<Map<string, HTMLDivElement>>(new Map());
  const [, setPortalTick] = useState(0);

  // ⭐ SDM 공통 — 상위 셀 변경 시 종속 콤보(ATTRIBUTE2) 첫 후보 자동 입력 (CELL_TYPE→STACK_METHOD 등).
  //   DataGrid 는 initialized 를 내부 핸들러(EditTracker/stale clear) 등록이 끝난 뒤 마지막에
  //   호출하므로 여기 등록이 항상 공용 정리보다 뒤에 돈다. 그리드 폐기 시 핸들러도 함께 사라져
  //   별도 detach 는 불필요.
  const handleGridInitialized = useCallback(
    (grid: FlexGrid<ProjectRow>) => {
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
     * 등록요청/요청취소 행 버튼 (REG_ACTION) — 셀당 portal 컨테이너 1개, 버튼은 아래 JSX 가 렌더
     * =================================================== */

    if (row && columnsRef.current.find(c => c.colNm === binding)?.attribute1 === REG_ACTION_ATTR) {
      const key = String(row.DPJT_KEY ?? '');
      const existing = actionPortalsRef.current.get(key);
      if (existing) {
        if (event.cell.firstElementChild !== existing) event.cell.replaceChildren(existing);
        return;
      }
      const container = globalThis.document.createElement('div');
      container.className = gridStyles.regButtons;
      event.cell.replaceChildren(container);
      actionPortalsRef.current.set(key, container);
      setPortalTick(tick => tick + 1);
      return;
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
        initialized={handleGridInitialized}
        excludeFromDirtyCheck={excludeFromDirtyCheck}
        gotFocus={handleFocus}
        click={handleGridClick}
        formatItem={handleFormatItem}
        cellEditEnding={handleSopDateEditEnding}
        cellEditEnded={handleCellEditEnded}
        // 붙여넣기도 NAME 콤보 → 코드 컬럼(BIZ_TYPE 등) 동기화를 태운다 — 없으면 코드가 빈 채로
        // 남아 저장 검증에서 필수값 알림이 뜬다 (직접 편집은 cellEditEnded 경로).
        pastedCell={handleCellEditEnded}
        beginningEdit={preventLockedRowEdit}
        pastingCell={preventLockedRowEdit}
      />

      {/* 행 버튼 — 작성중(신규 행 포함)=등록요청, 승인대기/변경요청=요청취소. 그 외 상태는 빈 셀.
          미저장 변경 행 포함 저장·필수값 검증은 REQUEST SP 내부 처리 — FE 는 SAVE 파라미터 전달만. */}
      {[...actionPortalsRef.current.entries()].flatMap(([key, container]) => {
        const row = data.find(item => String(item.DPJT_KEY ?? '') === key);
        if (!row) return [];
        return [
          createPortal(
            <>
              {isDraftRegStatus(row.DPJT_REG_STATUS) && (
                <Button
                  appearance='contained'
                  priority='primary'
                  size='small'
                  buttonLabel={t('LBL00865', '_등록요청')}
                  onClick={() => onRequest(row)}
                />
              )}
              {isPendingRegStatus(row.DPJT_REG_STATUS) && (
                <Button
                  appearance='outlined'
                  priority='primary'
                  size='small'
                  buttonLabel={t('LBL00422', '_요청취소')}
                  onClick={() => onCancelRequest(row)}
                />
              )}
            </>,
            container,
            key
          ),
        ];
      })}

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
