import {
  Tooltip,
  addClass,
  DataType,
  Globalize,
  isNumber,
  Rect,
  SortDescription,
  toggleClass,
} from '@mescius/wijmo';
import type {
  CellRangeEventArgs,
  Column,
  FormatItemEventArgs,
  FlexGrid,
} from '@mescius/wijmo.grid';
import { CellRange, CellType, GroupRow } from '@mescius/wijmo.grid';
import { Selector } from '@mescius/wijmo.grid.selector';
import dayjs from 'dayjs';
import isoWeek from 'dayjs/plugin/isoWeek';
import type { MutableRefObject } from 'react';

import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE, CRUD_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';

dayjs.extend(isoWeek);

interface SummaryInfo {
  cnt: number;
  cntAll: number;
  sum: number;
  avg: number;
}

export const useDataGridUtils = <T extends WijmoRowItem = WijmoRowItem>() => {
  const _aggregateRange = (
    tally: SummaryInfo,
    grid: FlexGrid<T>,
    ranges: CellRange[],
    rangeIndex: number
  ) => {
    const range = ranges[rangeIndex];
    if (range.topRow === range.bottomRow && range.leftCol === range.rightCol) return;

    for (let row = range.topRow; row <= range.bottomRow; row++) {
      for (let col = range.leftCol; col <= range.rightCol; col++) {
        const isOverlapped = ranges.slice(0, rangeIndex).some(range => range.contains(row, col));
        const cellData = grid.getCellData(row, col, false) as WijmoPrimitive;

        if (isOverlapped || !grid.getColumn(col).visible) continue;
        if (!cellData || cellData === '' || !isNumber(cellData)) continue;

        const value = Number(cellData.toFixed(2));

        tally.cntAll++;
        tally.cnt++;
        tally.sum += value;
      }
    }

    tally.avg = Number.parseFloat(
      (tally?.cnt ?? 0) > 0 ? ((tally?.sum ?? 0) / (tally?.cnt ?? 0)).toFixed(2) : '0'
    );
  };

  const _showAreaInfo = (grid: FlexGrid<T>): SummaryInfo => {
    const tally: SummaryInfo = { cnt: 0, cntAll: 0, sum: 0, avg: 0 };
    const ranges: CellRange[] = grid.selectedRanges;

    for (let rangeIndex = 0; rangeIndex < ranges.length; rangeIndex++)
      _aggregateRange(tally, grid, ranges, rangeIndex);

    return tally;
  };

  const setSummaryTooltip = (grid: FlexGrid<T>) => {
    const tooltip = new Tooltip();

    grid.addEventListener(grid.hostElement, 'mouseup', (mouseEvent: MouseEvent) => {
      const ht = grid.hitTest(mouseEvent);

      if (ht.cellType === CellType.Cell) {
        const areaData = _showAreaInfo(grid);

        if (areaData && areaData.cntAll > 1) {
          const { cntAll, avg, sum } = areaData;
          const content = `
              <div class='grid_summary_popup'>
                <div class='grid_summary_popup_area'>
                  <div class='grid_summary_popup_title'>Count</div>
                  <div class='grid_summary_popup_cnt'>${Globalize.formatNumber(cntAll, 'n0')}</div>
                  <div class='grid_summary_popup_title'>Average</div>
                  <div class='grid_summary_popup_avg'>${Globalize.formatNumber(avg, 'G2')}</div>
                  <div class='grid_summary_popup_title'>Sum</div>
                  <div class='grid_summary_popup_sum'>${Globalize.formatNumber(sum, 'G2')}</div>
                </div>
              </div>`;
          tooltip.show(
            grid.hostElement,
            content,
            new Rect(mouseEvent.clientX, mouseEvent.clientY, 0, 0)
          );

          return;
        }
      }
    });

    grid.scrollPositionChanged.addHandler(() => tooltip.hide());
    grid.selectionChanging.addHandler(() => tooltip.hide());
  };

  // 셀 데이터에 마우스오버 시 전체 값을 툴팁으로 표시(공통).
  // formatItem 에서 cell 의 title 속성 설정 → 브라우저 네이티브 툴팁.
  // 내용이 잘린 셀도 전체 값 확인 가능. 값이 없으면 title 제거.
  const setCellTooltip = (grid: FlexGrid<T>) => {
    grid.formatItem.addHandler((_sender, event: FormatItemEventArgs) => {
      if (event.panel.cellType !== CellType.Cell) return;

      const text = event.cell.textContent ?? '';
      if (text) event.cell.title = text;
      else event.cell.removeAttribute('title');
    });
  };

  const setAggregationRow = (grid: FlexGrid<T>, placement: 'above' | 'below') => {
    if (placement === 'below') {
      grid.columnFooters.rows.push(new GroupRow());
      grid.bottomLeftCells.setCellData(0, 0, 'Σ');
    } else if (placement === 'above') {
      // TODO: aggregation row above 처리 (wijmo demo 참고), 필요없을 시 구현 X - 강민재
    }
  };

  // TODO: checkbox 컬럼, 필요시 추가 구현 필요 - 강민재
  const setCheckbox = (grid: FlexGrid<T>) => new Selector(grid, {});

  const formatPopupIcon = (grid: FlexGrid<T>, formatItemEventArgs: FormatItemEventArgs) => {
    const row = formatItemEventArgs.row;
    const col = formatItemEventArgs.col;
    const cellType = formatItemEventArgs.panel.cellType;
    const dataItem = grid.rows[row]?.dataItem as WijmoRowItem;
    const columnConfig = GridUtils.getColumn(grid, col);

    if (!dataItem || !columnConfig) return;
    if (cellType !== CellType.Cell) return;

    const cellCtrlType = columnConfig._ctrlType;
    const cellInputEditType = columnConfig._inputEditType;
    const cellCrudType = dataItem['CRUD_TYPE'];

    const isEditableCell =
      (cellCrudType === CRUD_TYPE.INSERT &&
        (cellInputEditType === CELL_INPUT_EDIT_TYPE.MANDATORY_INSERT_ONLY ||
          cellInputEditType === CELL_INPUT_EDIT_TYPE.OPTIONAL_INSERT_ONLY)) ||
      cellInputEditType === CELL_INPUT_EDIT_TYPE.MANDATORY ||
      cellInputEditType === CELL_INPUT_EDIT_TYPE.OPTIONAL;

    // 팝업(돋보기/OpenInNew) 아이콘은 FPModal 과 FPTextModal 둘 다에 붙인다.
    //   FPTextModal 은 키인 + 모달 동시 허용 셀이라 FPModal 과 동일한 오픈 아이콘을 보여야 한다.
    const isModalCtrl =
      cellCtrlType === CELL_CONTROL_TYPE.MODAL ||
      cellCtrlType === CELL_CONTROL_TYPE.TEXT_MODAL;

    toggleClass(formatItemEventArgs.cell, 'is-popup', isModalCtrl && isEditableCell);
  };

  const formatSortableColumns = (grid: FlexGrid<T>, event: FormatItemEventArgs) => {
    const panel = event.panel;
    const column = grid.columns[event.col];
    const binding = column?.binding;
    const allowSorting = column?.allowSorting ?? false;
    // 그룹핑된(2단 이상) 헤더는 상위 그룹 행도 같은 event.col 로 들어와 leaf 컬럼과 동일한
    //   binding 을 참조한다 — 그대로 두면 그룹 행에도 ◆/화살표가 겹쳐 그려진다(사용자 보고
    //   2026-09-04, Sales Future Price 주차 그룹 컬럼). 실제 라벨이 있는 최하단 leaf 헤더
    //   행에만 정렬 아이콘을 적용한다.
    //   단순 `event.row === 마지막행` 비교는 안 된다 — 같은 그리드에 섞인 1단(정적) 컬럼은
    //   전체 헤더 높이(3단이면 row0~row2)를 세로 머지해 앵커가 row0 에 찍히므로(formatEditableColumns
    //   의 isVerticalMerge 처리와 동일 이유) 그 컬럼만 아이콘이 사라진다. 머지 범위의 "아래쪽 끝
    //   행"이 마지막 행과 같은지로 판정해야 세로 머지 컬럼과 순수 leaf 컬럼 모두 잡히고, 위로만
    //   퍼지는 그룹 헤더(row2===row)는 제외된다.
    const mergedRange = grid.getMergedRange(panel, event.row, event.col);
    const headerCellBottomRow = mergedRange ? mergedRange.row2 : event.row;
    const isLeafHeaderRow = headerCellBottomRow === grid.columnHeaders.rows.length - 1;
    const isHeaderCell = panel.cellType === CellType.ColumnHeader && isLeafHeaderRow;
    const isActivelySorted = grid.collectionView.sortDescriptions.some(
      sortDescription => sortDescription.property === binding
    );

    // F3 로 정렬 기능을 다시 켠 직후 표시: 이미 정렬돼 있던 컬럼이라도 재정렬(헤더 클릭)
    //   전까지는 ◆(미정렬) 아이콘을 보여준다 — gridAction.toggleColumnSort 가 세우고,
    //   setSortableColumnHeaderClick 이 실제 정렬 클릭 시 내린다. Column 인스턴스 플래그는
    //   columnGroups 재대입으로 사라질 수 있어(gridAction.toggleColumnSort 주석 참고) grid
    //   인스턴스에 binding 기준으로 적어둔 Set 을 우선 신뢰한다.
    const pendingBindings = (grid as unknown as { _userSortIconPendingBindings?: Set<string> })
      ._userSortIconPendingBindings;
    const sortIconPending =
      (!!binding && !!pendingBindings?.has(binding)) ||
      !!(column as unknown as { _sortIconPending?: boolean } | undefined)?._sortIconPending;

    const isSortable = allowSorting && isHeaderCell && (!isActivelySorted || sortIconPending);

    toggleClass(event.cell, 'is-sortable', isSortable);

    if (isSortable) {
      const existingIcon = event.cell.querySelector('.wj-sort-unsorted-icon');
      if (!existingIcon) {
        const iconSpan = document.createElement('span');
        iconSpan.className = 'wj-sort-unsorted-icon';
        event.cell.appendChild(iconSpan);
      }
    } else {
      const unsortedIcon = event.cell.querySelector('.wj-sort-unsorted-icon');
      if (unsortedIcon) {
        unsortedIcon.remove();
      }
    }

    // Wijmo 기본 정렬 화살표(Column.currentSort 기반이라 allowSorting과 무관하게 그려짐)를
    //   숨겨야 하는 두 경우 — sortDescriptions/행 순서는 그대로 두되:
    //   1) F3로 정렬 기능을 끈 컬럼 (!allowSorting)
    //   2) F3로 다시 켠 직후라 위에서 ◆를 대신 그린 컬럼 (sortIconPending) — 화살표와
    //      ◆가 동시에 보이면 안 되므로 이 경우에도 화살표를 숨긴다.
    toggleClass(
      event.cell,
      'is-sort-disabled',
      isHeaderCell && isActivelySorted && (!allowSorting || sortIconPending)
    );
  };

  // 콤보 컬럼인데 아직 dataMap 이 안 붙은(콤보 조회가 진행 중인) 셀은 원본 코드값 대신 빈 텍스트로
  //   그린다. 그리드 컬럼 구조(columnGroups)는 동기로 만들어지고 콤보 옵션은 비동기라, 아무 처리
  //   없으면 응답 오기 전까지 코드값("KO" 등)이 그대로 보인다 — pendingComboBindingsRef 는 DataGrid
  //   가 매 렌더 최신 pending 여부로 갱신한다(콤보 조회 완료/실패 시 그 binding 은 Set 에서 빠짐).
  //   반드시 setCellTooltip 보다 먼저 등록해야 한다 — 그쪽이 이 함수가 비운 뒤의 textContent 를
  //   읽어 title 을 세우므로, 순서가 바뀌면 텍스트는 비어도 툴팁엔 원본 코드가 남는다.
  const formatPendingComboColumns = (
    grid: FlexGrid<T>,
    event: FormatItemEventArgs,
    pendingComboBindingsRef: MutableRefObject<Set<string>>
  ) => {
    if (event.panel.cellType !== CellType.Cell) return;
    const binding = grid.columns[event.col]?.binding;
    if (binding && pendingComboBindingsRef.current.has(binding)) {
      event.cell.textContent = '';
    }
  };

  // 텍스트 셀(FPText/FPTextBox → dataType String)인데 원본 값이 number 로 내려오는 경우
  //   (예: ROUTE_ID 가 Oracle NUMBER) Wijmo 는 컬럼 dataType 과 무관하게 숫자 원본을
  //   Globalize.format 으로 포맷해 천단위 콤마("61,386")를 붙인다. 표시 텍스트만 원본 문자열로
  //   되돌린다 — 소스 데이터·저장 payload·EditTracker 원복 판정(number 원본 유지)은 건드리지 않는다.
  //   setCellTooltip 보다 먼저 등록해야 툴팁도 교정된 텍스트를 읽는다(formatPendingComboColumns 동일).
  const formatTextTypeColumns = (grid: FlexGrid<T>, event: FormatItemEventArgs) => {
    if (event.panel.cellType !== CellType.Cell) return;
    if (grid.columns[event.col]?.dataType !== DataType.String) return;
    const value = grid.getCellData(event.row, event.col, false);
    if (isNumber(value)) event.cell.textContent = (value as number).toString();
  };

  // RowHeader col 0(행번호 또는 체크박스) 셀에 선택 행 표시.
  //   grid.selection 은 "선택 anchor" 가 아니라 가장 최근 range 의 커서 이동 끝점 하나뿐이라
  //   다중 행 선택을 못 잡는다 - 드래그/Shift 연속 선택은 grid.selection 자체가 topRow~bottomRow
  //   전체를 덮는 range 인데 .row 단일 비교로는 나머지가 빠지고, MultiRange 에서 Ctrl+클릭으로
  //   비연속 선택하면 이전 range 는 grid.selectedRanges 로 넘어가 grid.selection 만 봐선 아예
  //   안 잡힌다. grid.selectedRanges = [grid.selection, ...Ctrl+클릭 range] 전체에서 containsRow
  //   로 판정해야 단일 셀/연속 다중 행/비연속 다중 행을 모두 커버한다.
  //   기존 옅은 선택색(teal 계열, wj-sel-bkg)과 겹쳐 잘 안 보이던 문제라, 배경은 흰색으로 두고
  //   테두리만 보색 계열(진한 주황) 1px 로 둘러 구분한다. cell.style 로 직접 지정해야 wijmo 기본
  //   셀 테두리/zebra 배경(인라인 style)보다 우선 적용된다. 해제 시에는 빈 문자열로 되돌려
  //   기본 테두리를 살린다.
  const paintRowNoSelectionStyle = (grid: FlexGrid<T>, cell: HTMLElement, row: number): void => {
    const rowNum = row + 1;
    const isFocusedRow = grid.selectedRanges.some(range => range.isValid && range.containsRow(row));
    cell.style.color = '';
    if (isFocusedRow) {
      cell.style.backgroundColor = '#FFFFFF';
      cell.style.border = '1px solid #FF8A00';
    } else {
      cell.style.backgroundColor = rowNum % 2 === 0 ? '#F7F7F8' : '#FFFFFF';
      cell.style.border = '';
    }
  };

  const formatEditableColumns = (
    grid: FlexGrid<T>,
    formatItemEventArgs: FormatItemEventArgs,
    hasCheckboxColumn = false
  ) => {
    const row = formatItemEventArgs.row;
    const col = formatItemEventArgs.col;
    const cell = formatItemEventArgs.cell;
    const cellType = formatItemEventArgs.panel.cellType;

    if (cellType === CellType.RowHeader) {
      const rowHeaderCell = formatItemEventArgs.cell;

      // useCheckbox 그리드는 rowHeader col 0 을 wijmo Selector 가 체크박스로 전용한다
      //   (gridRowNo.ts 주석 — 체크박스 그리드는 별도 No 데이터컬럼(buildNoColumn)을 쓴다).
      //   행번호 텍스트(cell.textContent)는 Selector 가 그린 체크박스 DOM 을 지우므로 건드리지
      //   않지만, 배경/테두리(cell.style)는 체크박스 DOM 과 별개(자식 노드만 지우는 게 아니라
      //   셀 자체의 인라인 스타일이라 Selector 의 checkbox insertBefore 와 충돌하지 않는다)라
      //   체크박스 그리드에도 그대로 적용해 선택 행 표시를 살린다.
      if (col === 0) {
        if (!hasCheckboxColumn) cell.textContent = (row + 1).toString();
        paintRowNoSelectionStyle(grid, cell, row);
      } else if (!grid.isReadOnly && col === 1) {
        delete rowHeaderCell.dataset.status;
        const dataItem = GridUtils.getRow(grid, row);
        if (!dataItem || !dataItem.CRUD_TYPE) return;

        rowHeaderCell.dataset.status = dataItem['CRUD_TYPE'];
      }
    } else if (cellType === CellType.Cell) {
      toggleClass(cell, 'wj-cell-editable', GridUtils.isEditableCell(grid, row, col));

      const crudType = GridUtils.getRow(grid, row)?.CRUD_TYPE;
      const columnGroupProps = GridUtils.getColumn(grid, col);

      // FPModal 뿐 아니라 FPTextModal(키인 + 모달 동시 허용) 셀에도 동일한 팝업 아이콘을 붙인다.
      const isModalCtrlType =
        columnGroupProps?._ctrlType === CELL_CONTROL_TYPE.MODAL ||
        columnGroupProps?._ctrlType === CELL_CONTROL_TYPE.TEXT_MODAL;

      toggleClass(
        cell,
        'wj-cell-popup',
        isModalCtrlType &&
          (columnGroupProps?._inputEditType === CELL_INPUT_EDIT_TYPE.MANDATORY ||
            columnGroupProps?._inputEditType === CELL_INPUT_EDIT_TYPE.OPTIONAL ||
            (columnGroupProps?._inputEditType?.startsWith('I') && crudType === CRUD_TYPE.INSERT))
      );
    } else if (cellType === CellType.ColumnHeader) {
      // 필수(빨간 점)는 "실제 컬럼 라벨이 표시되는 헤더 셀"에만 적용한다.
      //   - 단일/leaf 컬럼: 라벨은 맨 아래 헤더 행에 있음 (row === last).
      //   - 좌측 고정 필수컬럼(3단 헤더에서 세로 머지): Wijmo 가 머지 셀을 맨 위(row 0) 앵커로 렌더 →
      //     기존 `row === last` 가드에 걸려 누락(재조회 시 빨간 점 소실 사고). 세로 머지 앵커면 행 무관 적용.
      //   - 그룹(상위) 헤더 셀은 가로 머지(row2===row)라 아래 두 조건 모두 불충족 → 오탐 없음.
      const mergedRange = grid.getMergedRange(formatItemEventArgs.panel, row, col);
      const isVerticalMerge = !!mergedRange && mergedRange.row2 > mergedRange.row;
      const isLastHeaderRow = row === grid.columnHeaders.rows.length - 1;
      if (!isLastHeaderRow && !isVerticalMerge) return;

      const columnConfig = GridUtils.getColumn(grid, col);
      const inputEditType = columnConfig?._inputEditType;
      // `_requiredMark` = 관리자 메타 라벨이 `*` 로 필수를 표기하던 화면(DMF0082 등). columnMapping 이
      // 라벨에서 `*` 를 떼고 넘겨주므로, inputTpCd=M/IM 로 등록된 화면과 동일하게 빨간점으로 그린다.
      const isMandatory =
        columnConfig?._requiredMark === true ||
        inputEditType === CELL_INPUT_EDIT_TYPE.MANDATORY ||
        inputEditType === CELL_INPUT_EDIT_TYPE.MANDATORY_INSERT_ONLY;

      toggleClass(formatItemEventArgs.cell, 'is-required', isMandatory);
    } else if (cellType === CellType.TopLeft) {
      // 왼쪽 상단 숫자 위 구석에 No 텍스트 삽입
      if (row === 0 && col === 0) {
        cell.textContent = 'No';
        cell.style.textAlign = 'center';
        cell.style.verticalAlign = 'middle';
      }
    }
  };

  const setEditableColumns = (grid: FlexGrid<T>) => {
    const defaultEditHandler = (sender: FlexGrid, cellRangeEventArgs: CellRangeEventArgs) => {
      const row = cellRangeEventArgs.row;
      const col = cellRangeEventArgs.col;

      cellRangeEventArgs.cancel = !GridUtils.isEditableCell(grid, row, col);
    };

    const cellEditHandler = (sender: FlexGrid, cellRangeEventArgs: CellRangeEventArgs) => {
      const column = GridUtils.getColumn(sender, cellRangeEventArgs.col);
      const ctrlType = column?._ctrlType;

      if (ctrlType === CELL_CONTROL_TYPE.MODAL) {
        cellRangeEventArgs.cancel = true;
        return;
      }

      defaultEditHandler(sender, cellRangeEventArgs);
    };

    grid.pastingCell.addHandler(defaultEditHandler);
    grid.beginningEdit.addHandler(cellEditHandler);
  };

  const setHandleUppercase = (grid: FlexGrid<T>) => {
    // TOOD: uppercase handling - 강민재
    grid.cellEditEnded.addHandler((sender: FlexGrid, cellRangeEventArgs: CellRangeEventArgs) => {
      const row = cellRangeEventArgs.row;
      const col = cellRangeEventArgs.col;
      const cellValue = sender.getCellData(row, col, false) as WijmoPrimitive;
      const uppercase = GridUtils.getColumn(grid, col)?._uppercase;
      if (cellValue && typeof cellValue === 'string' && uppercase) {
        sender.setCellData(row, col, cellValue.toUpperCase(), true);
      }
    });
  };

  const setMoveCellByTab = (grid: FlexGrid<T>) => {
    grid.hostElement.addEventListener('keydown', (keyboardEvent: KeyboardEvent) => {
      if (keyboardEvent.code !== 'Tab' || keyboardEvent.key !== 'Tab') return;
      if (keyboardEvent.altKey || keyboardEvent.ctrlKey || keyboardEvent.metaKey) return;

      keyboardEvent.preventDefault();

      const selection = grid.selection;
      if (!selection || selection.row < 0 || selection.col < 0) return;

      let nextRow = selection.row;
      let nextCol = selection.col + 1;

      while (
        nextRow < grid.rows.length &&
        nextCol < grid.rows.length &&
        !grid.columns[nextCol]?.isVisible
      ) {
        if (nextCol + 1 >= grid.columns.length) {
          nextRow += 1;
          nextCol = 0;
        } else nextCol += 1;
      }

      while (nextCol < grid.columns.length && !grid.columns[nextCol]?.isVisible) nextCol += 1;

      if (nextCol >= grid.columns.length) {
        nextRow = selection.row + 1;
        nextCol = 0;
      }

      if (nextRow < grid.rows.length) grid.select(nextRow, nextCol);
    });
  };

  // TODO: border column handle 필요
  const setMoveByMetakey = (grid: FlexGrid<T>, border: number = 0) => {
    grid.hostElement.addEventListener('keydown', (keyboardEvent: KeyboardEvent) => {
      if (!keyboardEvent.ctrlKey) return;
      if (!keyboardEvent.key.startsWith('Arrow')) return;

      const findLastVisibleColumnIndex = (columns: Column[]) => {
        for (let columnIndex = columns.length - 1; columnIndex >= 0; columnIndex--) {
          if (columns[columnIndex]?.isVisible) {
            return columnIndex;
          }
        }
        return columns.length - 1;
      };

      const selection: CellRange = grid.selection;
      const row = selection.row;
      const col = selection.col;
      const row2 = selection.row2;
      const col2 = selection.col2;
      let newRow: number = selection.row;
      let newCol: number = selection.col;

      switch (keyboardEvent.key) {
        case 'ArrowUp':
          newRow = 0;
          break;
        case 'ArrowDown':
          newRow = grid.rows.length - 1;
          break;
        case 'ArrowLeft':
          newCol = border > 0 && newCol >= border ? border : 0;
          break;
        case 'ArrowRight':
          newCol =
            border > 0 && newCol < border ? border - 1 : findLastVisibleColumnIndex(grid.columns);
          break;
        default:
          return;
      }

      keyboardEvent.preventDefault();

      if (keyboardEvent.shiftKey)
        grid.select(
          new CellRange(newRow >= row ? row2 : row, newCol >= col ? col2 : col, newRow, newCol),
          true
        );
      else grid.select(new CellRange(newRow, newCol));

      grid.scrollIntoView(newRow, newCol, true);
    });
  };

  const setSortableColumnHeaderClick = (grid: FlexGrid<T>) => {
    // 컬럼 너비 조절/컬럼 이동 드래그는 mouseup 후 click 도 함께 발생시켜서
    // 그대로 두면 드래그 끝에 의도치 않게 정렬이 걸린다.
    // → mousedown 지점과 비교해 임계값 이상 움직였으면 클릭으로 보지 않는다.
    const DRAG_THRESHOLD_PX = 3;
    let mouseDownPoint: { x: number; y: number } | null = null;

    grid.hostElement.addEventListener('mousedown', (mouseEvent: MouseEvent) => {
      mouseDownPoint = { x: mouseEvent.clientX, y: mouseEvent.clientY };
    });

    grid.hostElement.addEventListener('click', (mouseEvent: MouseEvent) => {
      const dragged =
        !!mouseDownPoint &&
        (Math.abs(mouseEvent.clientX - mouseDownPoint.x) > DRAG_THRESHOLD_PX ||
          Math.abs(mouseEvent.clientY - mouseDownPoint.y) > DRAG_THRESHOLD_PX);
      mouseDownPoint = null;
      if (dragged) return;

      const target = mouseEvent.target as HTMLElement;
      const ht = grid.hitTest(mouseEvent);
      const column = grid.columns[ht.col];
      if (ht.cellType !== CellType.ColumnHeader || !column) return;

      // 정렬은 F3(GridAction.toggleColumnSort)로 켠 컬럼에서만 걸린다 — 헤더를 클릭했다는
      //   이유만으로 바로 정렬되는 동작은 금지. 단축키가 정렬 스위치이고, 클릭은 그 스위치가
      //   켜진 컬럼에서만 오름/내림/해제를 순환시킨다.
      // 전제: 정적 컬럼은 columnMapping.toLeafColumn 이 allowSorting:false 로 만들어 준다
      //   (wijmo Column.allowSorting 기본값은 true — 화면이 직접 만든 컬럼은 켜진 채로 오지만
      //   그런 컬럼은 아래 _dynamic 가드에서 걸린다).
      if (!column.allowSorting) return;

      // 동적(주차/월/일) 컬럼도 정렬은 켠다 — 아래 select(-1,-1)+scrollIntoView(0,0) 리셋만
      //   건너뛴다(이유는 그 호출부 주석). 판정은 DataGrid 가 dynamicColumns leaf 에 채우는
      //   _dynamic — 컬럼의 allowSorting 은 F3 로 켜질 수 있고, 헤더 라벨은 관리자 메타(변경
      //   가능)라 둘 다 판정에 쓸 수 없다.
      const isDynamicColumn = !!GridUtils.getColumn(grid, ht.col)?._dynamic;

      // 헤더 셀 아무 곳이나 클릭하면 정렬(아이콘/글자 무관).
      // 단, 필터 아이콘 클릭은 제외 — 필터 팝업이 정상적으로 열려야 하므로.
      const clickedFilterIcon = !!target?.closest('.wj-elem-filter, .wj-glyph-filter');
      if (clickedFilterIcon) return;

      mouseEvent.preventDefault();
      mouseEvent.stopPropagation();

      const binding = column.binding;
      const sortDescription = grid.collectionView.sortDescriptions.find(
        sd => sd.property === binding
      );

      grid.collectionView.sortDescriptions.clear();

      // 헤더를 실제로 클릭해 정렬했으므로, F3 재활성화 직후의 ◆ 표시 유예는 여기서 끝난다
      //   — 이후 화살표(▲/▼)만 순환한다. Column 인스턴스 플래그와 grid 레벨 Set(gridAction.
      //   toggleColumnSort 주석 참고) 둘 다 내려야 columnGroups 재대입 여부와 무관하게 꺼진다.
      (column as unknown as { _sortIconPending?: boolean })._sortIconPending = false;
      if (binding) {
        (
          grid as unknown as { _userSortIconPendingBindings?: Set<string> }
        )._userSortIconPendingBindings?.delete(binding);
      }

      if (!mouseEvent.ctrlKey) {
        // 3-state 순환: 미정렬 → 오름 → 내림 → 미정렬 → ... (사용자 요구 2026-09-07 — 세 번째
        //   클릭에서 다시 미정렬로 돌아가야 한다). null = 미정렬 복귀(push 생략, ◆ 재표시는
        //   sortDescriptions 에서 빠져 isActivelySorted 가 false 가 되면서 자연히 처리된다).
        const nextAscending = !sortDescription ? true : sortDescription.ascending ? false : null;
        if (nextAscending !== null) {
          grid.collectionView.sortDescriptions.push(
            new SortDescription(binding ?? '', nextAscending)
          );
        }
      }

      // 동적 컬럼은 select(-1,-1)+scrollIntoView(0,0) 리셋을 건너뛴다 — 그리드를 맨 앞으로
      //   끌어당기면 화면들이 이 헤더의 더블클릭에 쓰는 드릴다운의 뒤이은 dblclick hitTest 가
      //   앞쪽 컬럼을 집어 드릴다운이 깨진다.
      if (!isDynamicColumn) {
        grid.select(-1, -1);
        grid.scrollIntoView(0, 0, true);
      }

      // sortDescriptions 변경은 collectionView 내부적으로는 즉시 반영되지만, 화면 재도색은 별도다.
      //   select(-1,-1)+scrollIntoView(0,0) 가 정적 컬럼에선 이 재도색을 겸해 왔고(선택 이동 시
      //   그리드가 invalidate 되므로), 동적 컬럼은 그 호출을 건너뛰므로 명시적으로 invalidate 해야
      //   한다 — 안 하면 정렬 아이콘만 바뀌고 행 순서는 그대로인 상태로 보인다.
      grid.invalidate(true);
    });
  };

  const setResultColumn = (grid: FlexGrid<T>) => {
    const lastWeekSunday = dayjs().startOf('isoWeek').subtract(1, 'day');
    const year = lastWeekSunday.get('year');
    const month = String(lastWeekSunday.get('month') + 1).padStart(2, '0');

    const monthBinding = `M_${year}${month}`;
    const weekBinding = `W_${year}${month}${String(lastWeekSunday.isoWeek()).padStart(2, '0')}`;
    const dayBinding = `D_${lastWeekSunday.format('YYYYMMDD')}`;

    const _borderForLastResultColumn = (
      sender: FlexGrid<T>,
      formatItemEventArgs: FormatItemEventArgs
    ) => {
      const col = formatItemEventArgs.col;
      const cellType = formatItemEventArgs.panel.cellType;
      const binding = sender.columns[col]?.binding;
      const isVisible = sender.columns[col]?.visible;
      const rootColumnGroups = (sender.columnGroups as FlexGridColumnConfig[]).flatMap(
        e => e.columns
      );

      if (!rootColumnGroups) return;

      if (binding && cellType === CellType.Cell && isVisible) {
        if (binding === dayBinding && sender.columns[col]?.visible)
          addClass(formatItemEventArgs.cell, 'last-result-column');
        else if (binding === weekBinding) {
          const weekColumnGroups = rootColumnGroups.find(cg => cg?.binding === monthBinding);
          const weekCollapsed = weekColumnGroups?.columns?.find(
            cg => cg?.binding === weekBinding
          )?.isCollapsed;
          if (weekCollapsed) addClass(formatItemEventArgs.cell, 'last-result-column');
        } else if (binding === monthBinding) {
          const monthCollapsed = rootColumnGroups.find(
            cg => cg?.binding === monthBinding
          )?.isCollapsed;
          if (monthCollapsed) addClass(formatItemEventArgs.cell, 'last-result-column');
        }
      }
    };

    grid.formatItem.addHandler(_borderForLastResultColumn);
  };

  // TODO: cell input에 따른 cell combo 실시간 필터링 - 강민재
  // const setCellDropdownFilter = (grid: FlexGrid<T>) => {
  //   grid.prepareCellForEdit.addHandler(
  //     (sender: FlexGrid<T>, cellRangeEventArgs: CellRangeEventArgs) => {
  //       const row = cellRangeEventArgs.row;
  //       const col = cellRangeEventArgs.col;
  //       const column = GridUtils.getColumn(sender, col);
  //       if (
  //         column?._ctrlType !== CELL_CONTROL_TYPE.COMBO ||
  //         !column.dataMap ||
  //         !sender.activeEditor
  //       )
  //         return;
  //       const cellCombo = Control.getControl(
  //         sender.activeEditor.closest('.wj-control')
  //       ) as ComboBox;
  //       if (!(cellCombo instanceof ComboBox)) return;
  //       const cellComboCollectionView = cellCombo.itemsSource as CollectionView;
  //       if (!(cellComboCollectionView instanceof CollectionView)) return;
  //       cellCombo.textChanged.removeAllHandlers();
  //       cellCombo.textChanged.addHandler(() => {
  //         const textInput = cellCombo.text?.toLowerCase();
  //         const displayPath = (column.dataMap as DataMap).displayMemberPath;
  //         cellComboCollectionView.filter = item => {
  //           if (!textInput) return true;
  //           return (item[displayPath]?.toString().toLowerCase() || '').includes(textInput);
  //         };
  //       });
  //     }
  //   );
  // };

  // 헤더 드래그로 여러 컬럼을 선택한 상태에서 그중 하나를 리사이즈하면, 선택된 다른 컬럼들도
  //   같은 비율로 함께 줄어들게(또는 늘어나게) 한다. wijmo 기본 동작은 드래그한 컬럼 하나만 바뀐다.
  //   드래그 중(resizingColumn)에는 시작 폭만 가볍게 기억하고, 실제 다중 컬럼 폭 반영은
  //   mouseup 확정 시점(resizedColumn) 1회로 제한해 드래그 중 렌더 부하가 없게 한다.
  const setMultiColumnResize = (
    grid: FlexGrid<T>,
    userColumnWidthsRef: MutableRefObject<Map<string, number>>
  ) => {
    const resizeStartWidths = new Map<number, number>(); // key: column.index

    grid.resizingColumn.addHandler((_sender, e) => {
      const column = e.getColumn();
      if (!column || resizeStartWidths.has(column.index)) return;
      resizeStartWidths.set(column.index, column.renderWidth);
    });

    grid.resizedColumn.addHandler((_sender, e) => {
      const column = e.getColumn();
      if (!column) return;

      const startWidth = resizeStartWidths.get(column.index);
      resizeStartWidths.delete(column.index);
      if (!startWidth || startWidth <= 0 || column.renderWidth === startWidth) return;

      // 다중 컬럼이 선택된 범위(col !== col2)에 지금 리사이즈한 컬럼이 포함될 때만 관여한다.
      const range = grid.selectedRanges.find(
        range => range.col !== range.col2 && range.containsColumn(column.index)
      );
      if (!range) return;

      const ratio = column.renderWidth / startWidth;

      for (let c = range.leftCol; c <= range.rightCol; c++) {
        if (c === column.index) continue; // 드래그한 컬럼 자신은 wijmo 가 이미 처리
        const other = grid.columns[c];
        if (!other || other.binding == null) continue; // rowHeader 등 binding 없는 컬럼 제외

        const newWidth = Math.max(Math.round(other.width * ratio), other.minWidth || 20);
        other.width = newWidth;
        userColumnWidthsRef.current.set(other.binding, newWidth);
      }
    });
  };

  return {
    setSummaryTooltip,
    setCellTooltip,
    setAggregationRow,
    setCheckbox,
    formatPopupIcon,
    formatEditableColumns,
    formatSortableColumns,
    formatPendingComboColumns,
    formatTextTypeColumns,
    setEditableColumns,
    setMoveCellByTab,
    setMoveByMetakey,
    setSortableColumnHeaderClick,
    setResultColumn,
    setHandleUppercase,
    setMultiColumnResize,
  };
};
