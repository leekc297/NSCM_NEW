import {
  CellType,
  type CellEditEndingEventArgs,
  type CellRangeEventArgs,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import {
  forwardRef,
  useImperativeHandle,
  useMemo,
  useRef,
  useState,
  type MutableRefObject,
} from 'react';
import { createPortal } from 'react-dom';
import { useTranslation } from 'react-i18next';

import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE, CRUD_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { Tag, type TagColorType } from '@shared/lges';
import { useMessageStore } from '@shared/stores';

import { AuthManagementPopup } from '../../../components/auth-management-popup';
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

const ROW_NO_BINDING = 'ROW_NO';

const TAG_COLOR_TYPES: TagColorType[] = [
  'confirmed',
  'error',
  'warning-minor',
  'warning-major',
  'done',
  'colorA',
  'colorB',
  'colorC',
  'colorD',
  'secondary',
  'primary',
];

const buildRowNoColumn = (header: string): RawFlexGridColumnConfig => ({
  colNm: ROW_NO_BINDING,
  colLblNm: header,
  horzAlgnCd: 'C',
  cellCtrlObjTpCd: CELL_CONTROL_TYPE.TEXT,
  cellCboDataTp: 'string',
  inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
  colWth: 56,
  fixed: false,
  uppercase: false,
  visible: true,
  display: true,
});

// sales-site SOLDTO_CUSTOMER 와 같은 이유(관리자 메타에 아직 attribute2 가 없음)로 FE 에서
// 임시로 얹는 셀 콤보 행 단위 필터 — parseComboFilterBindings 문법 '행컬럼:콤보컬럼'.
//   실제 콤보가 바인딩된 컬럼은 *_NAME 표시 컬럼이 아니라 코드 컬럼 자체다(09_SDM1010_project_grid_combo_fix.sql
//   — STACK_METHOD 는 FPComboBox, STACK_METHOD_NAME 은 FPText+숨김으로 등록됨. END_CUSTOMER 도 admin 메타상
//   콤보 바인딩 컬럼이 END_CUSTOMER_NAME 이 아니라 END_CUSTOMER 자체).
//   END_CUSTOMER: 콤보 후보를 행의 DIVISION_ID 로 좁힌다(요청 3).
//   STACK_METHOD: 콤보 후보를 행의 DIVISION_ID·CELL_TYPE 으로 좁힌다(요청 5).
//   CELL_TYPE: 콤보 후보를 행의 DIVISION_ID 로 좁힌다 — CellTypeByDivision SQL 이 @divisionId
//     바인드를 받도록 만들어져 있지만, 09_SDM1010_project_grid_combo_fix.sql 의 admin 메타
//     UPDATE 가 엉뚱하게 DPJT_CLASS_NAME 컬럼을 대상으로 나가 있어(복붙 실수) CELL_TYPE 자체엔
//     ATTRIBUTE2 가 비어 있었다(2026-08-20 확인·SQL 수정). DB 재실행 전까지의 안전망 겸
//     STACK_METHOD 와 동일하게 이중 방어(!column.attribute2 가드라 DB 값이 이미 있으면 no-op).
// 추후 admin UI Category Setup 에 attribute2 가 등록되면 이 patch는 제거한다.
const COMBO_ROW_FILTER_BY_COLNM: Record<string, string> = {
  END_CUSTOMER: 'DIVISION_ID:DIVISION_ID',
  STACK_METHOD_NAME: 'DIVISION_ID:DIVISION_ID,CELL_TYPE:CELL_TYPE',
  CELL_TYPE_NAME: 'DIVISION_ID:DIVISION_ID',
};

/**
 * 서버에서 내려온 COLOR_TYPE이
 * TagColorType에 해당하는 값인지 검사한다.
 *
 * 잘못된 값이면 secondary 사용.
 */
const normalizeTagColorType = (value: unknown): TagColorType => {
  if (typeof value === 'string' && TAG_COLOR_TYPES.includes(value as TagColorType)) {
    return value as TagColorType;
  }

  return 'secondary';
};

/* =========================================================
 * Tag Layer
 * ========================================================= */

interface TagInfo {
  label: string;
  colorType: TagColorType;
  mount: HTMLDivElement;
}

export interface TagLayerHandle {
  apply: (cell: HTMLElement, label: string, colorType: unknown) => void;

  clear: (cell: HTMLElement) => void;
}

/**
 * Wijmo Cell 안에 LGES Tag를 Portal로 렌더링한다.
 *
 * createRoot를 사용하지 않는 이유:
 * 별도 React Root를 생성하면 LGES Design System이 사용하는
 * Theme Context가 끊길 수 있다.
 *
 * createPortal은 현재 React Tree의 Context를 그대로 유지한다.
 */
export const TagLayer = forwardRef<TagLayerHandle>((_props, ref) => {
  const [tags, setTags] = useState(() => new Map<HTMLElement, TagInfo>());

  /**
   * React Portal key용 Cell ID
   */
  const cellIdsRef = useRef(new WeakMap<HTMLElement, number>());

  const nextCellIdRef = useRef(0);

  const getCellId = (cell: HTMLElement) => {
    let id = cellIdsRef.current.get(cell);

    if (id === undefined) {
      id = nextCellIdRef.current++;

      cellIdsRef.current.set(cell, id);
    }

    return id;
  };

  useImperativeHandle(
    ref,
    () => ({
      apply: (cell: HTMLElement, label: string, colorTypeValue: unknown) => {
        const colorType = normalizeTagColorType(colorTypeValue);

        setTags(prev => {
          const current = prev.get(cell);

          /**
           * 기존 mount가 실제로 Wijmo Cell에 남아있는지 검사.
           *
           * Wijmo는 refresh / virtual scroll 과정에서
           * Cell 내부 DOM을 다시 만들 수 있기 때문에
           * React state에 있다고 해서 DOM에도 있다고 볼 수 없다.
           */
          const mountExists = current?.mount.parentElement === cell;

          /**
           * 기존 Mount가 정상적으로 존재
           */
          if (current && mountExists) {
            /**
             * 같은 데이터라면 다시 setState하지 않는다.
             */
            if (current.label === label && current.colorType === colorType) {
              return prev;
            }

            const next = new Map(prev);

            next.set(cell, {
              ...current,
              label,
              colorType,
            });

            return next;
          }

          /**
           * state에는 있지만 Wijmo가 mount DOM을 제거한 경우
           */
          const next = new Map(prev);

          if (current) {
            next.delete(cell);
          }

          /**
           * Tag 전용 DOM 생성
           */
          const mount = document.createElement('div');

          mount.dataset.projectStatusTag = 'true';

          /**
           * 중요:
           *
           * cell.style.position은 절대로 변경하지 않는다.
           *
           * Wijmo Cell은 자체 position 값을 이용해
           * Row / Column 위치를 계산하기 때문에
           * relative로 변경하면 Grid Layout이 깨질 수 있다.
           */
          mount.style.position = 'absolute';
          mount.style.left = '0';
          mount.style.top = '0';
          mount.style.right = '0';
          mount.style.bottom = '0';

          mount.style.display = 'flex';
          mount.style.alignItems = 'center';
          mount.style.justifyContent = 'center';

          mount.style.boxSizing = 'border-box';

          mount.style.pointerEvents = 'none';

          /**
           * Wijmo 기본 문자열보다 위에 표시
           */
          mount.style.zIndex = '1';

          /**
           * 셀의 배경색을 사용해
           * Wijmo 원본 문자열을 가린다.
           *
           * cell.textContent = ''처럼 직접 지우지 않기 때문에
           * Wijmo가 Cell Layout을 다시 계산하는 문제를 피한다.
           */
          const backgroundColor = window.getComputedStyle(cell).backgroundColor;

          mount.style.backgroundColor = backgroundColor;

          cell.appendChild(mount);

          next.set(cell, {
            label,
            colorType,
            mount,
          });

          return next;
        });
      },

      clear: (cell: HTMLElement) => {
        setTags(prev => {
          const current = prev.get(cell);

          if (!current) {
            return prev;
          }

          /**
           * mount가 아직 Cell 안에 존재하면 제거
           */
          if (current.mount.parentElement === cell) {
            current.mount.remove();
          }

          const next = new Map(prev);

          next.delete(cell);

          return next;
        });
      },
    }),
    []
  );

  return (
    <>
      {[...tags.entries()].map(([cell, tag]) =>
        createPortal(
          <Tag colorType={tag.colorType} appearance='boxing'>
            {tag.label}
          </Tag>,
          tag.mount,
          String(getCellId(cell))
        )
      )}
    </>
  );
});

TagLayer.displayName = 'TagLayer';

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

  /**
   * No 컬럼 + 서버 컬럼(콤보 행 필터 patch 포함)
   */
  const columns = useMemo(
    () => [
      buildRowNoColumn(t('LBL00674', '_No')),
      ...staticColumns.map((column: RawFlexGridColumnConfig) =>
        COMBO_ROW_FILTER_BY_COLNM[column.colNm] && !column.attribute2
          ? { ...column, attribute2: COMBO_ROW_FILTER_BY_COLNM[column.colNm] }
          : column
      ),
    ],
    [staticColumns, t]
  );

  // 엑셀 내보내기(FlexGridXlsxConverter)는 formatItem 이 그린 화면상 텍스트가 아니라
  // itemsSource 의 실제 바인딩 값을 읽는다 — ROW_NO 컬럼은 handleFormatItem 에서 DOM 만
  // 갱신하고 row 데이터엔 값이 없어(row.ROW_NO === undefined) 엑셀에는 빈 값으로 저장되던 결함.
  // auth-request(withRowNo)와 동일하게 itemsSource 에 ROW_NO 를 직접 채운다.
  const rows = useMemo(
    () => data.map((row, index) => ({ ...row, [ROW_NO_BINDING]: index + 1 })),
    [data]
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
     * Row No
     * =================================================== */

    if (binding === ROW_NO_BINDING) {
      event.cell.textContent = String(event.row + 1);
    }

    /* ===================================================
     * Division
     * =================================================== */

    if ((binding === 'DIVISION_ID' || binding === 'DIVISION_NAME') && !isEditing) {
      event.cell.textContent = String(row?.DIVISION_ID ?? '');
    }

    /* ===================================================
     * SOP Date
     * =================================================== */

    if (binding === 'SOP_DATE' && !isNewRow && !isEditing) {
      event.cell.textContent = formatSopDate(row?.SOP_DATE);
    }

    if (binding === 'REG_REQ_DATE' && !isNewRow && !isEditing) {
      event.cell.textContent = formatSopDate(row?.SOP_DATE);
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
        itemsSource={rows}
        staticColumns={columns}
        useCheckbox
        excludeFromDirtyCheck={excludeFromDirtyCheck}
        gotFocus={handleFocus}
        click={handleGridClick}
        formatItem={handleFormatItem}
        cellEditEnding={handleSopDateEditEnding}
        cellEditEnded={handleCellEditEnded}
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
