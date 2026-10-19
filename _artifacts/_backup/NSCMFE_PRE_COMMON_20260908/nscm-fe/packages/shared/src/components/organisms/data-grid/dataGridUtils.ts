import {
  Tooltip,
  addClass,
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

    // ⭐ [2026-08-22] FPTextModal 도 돋보기 아이콘을 단다 — 텍스트 입력이 되더라도 모달이 있다는
    //   사실이 보여야 한다(AS-IS `TextCellType.BackgroundImage = ImagePopUp` 파리티).
    toggleClass(
      formatItemEventArgs.cell,
      'is-popup',
      (cellCtrlType === CELL_CONTROL_TYPE.MODAL ||
        cellCtrlType === CELL_CONTROL_TYPE.TEXT_MODAL) &&
        isEditableCell
    );
  };

  const formatSortableColumns = (grid: FlexGrid<T>, event: FormatItemEventArgs) => {
    const panel = event.panel;
    const binding = grid.columns[event.col]?.binding;
    const allowSorting = grid.columns[event.col]?.allowSorting ?? false;

    const isSortable =
      allowSorting &&
      panel.cellType === CellType.ColumnHeader &&
      !grid.collectionView.sortDescriptions.some(
        sortDescription => sortDescription.property === binding
      );

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
  };

  const formatEditableColumns = (grid: FlexGrid<T>, formatItemEventArgs: FormatItemEventArgs) => {
    const row = formatItemEventArgs.row;
    const col = formatItemEventArgs.col;
    const cell = formatItemEventArgs.cell;
    const cellType = formatItemEventArgs.panel.cellType;

    if (cellType === CellType.RowHeader) {
      const rowHeaderCell = formatItemEventArgs.cell;

      if (col === 0) {
        const rowNum = row + 1;
        cell.textContent = rowNum.toString();

        // 현재 선택된 행 표시 - No 컬럼(col===0)은 read-only 그리드에도 항상 있어 여기서
        //   처리해야 편집/읽기전용 모두 동작한다. col===1(CRUD 상태)은 편집 그리드에만
        //   있는 별도 컬럼이라 read-only 화면엔 표시가 안 된다.
        //   grid.selection.row 는 "선택 anchor"가 아니라 가장 최근 range 의 커서 이동
        //   끝점 하나뿐이라 다중 행 선택을 못 잡는다 - 드래그/Shift 연속 선택은 grid.selection
        //   자체가 topRow~bottomRow 전체를 덮는 range 인데 .row 단일 비교로는 나머지가
        //   빠지고, MultiRange 에서 Ctrl+클릭으로 비연속 선택하면 이전 range 는
        //   grid.selectedRanges 로 넘어가 grid.selection 만 봐선 아예 안 잡힌다.
        //   grid.selectedRanges = [grid.selection, ...Ctrl+클릭 range] 전체에서 containsRow
        //   로 판정해야 단일 셀/연속 다중 행/비연속 다중 행을 모두 커버한다.
        //   기존 옅은 선택색(teal 계열, wj-sel-bkg)과 겹쳐 잘 안 보이던 문제라, 배경은
        //   흰색으로 두고 테두리만 보색 계열(진한 주황) 1px 로 둘러 구분한다.
        //   cell.style 로 직접 지정해야 wijmo 기본 셀 테두리/zebra 배경(인라인 style)보다
        //   우선 적용된다. 해제 시에는 빈 문자열로 되돌려 기본 테두리를 살린다.
        const isFocusedRow = grid.selectedRanges.some(
          range => range.isValid && range.containsRow(row)
        );
        cell.style.color = '';
        if (isFocusedRow) {
          cell.style.backgroundColor = '#FFFFFF';
          cell.style.border = '1px solid #FF8A00';
        } else {
          cell.style.backgroundColor = rowNum % 2 === 0 ? '#F7F7F8' : '#FFFFFF';
          cell.style.border = '';
        }
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

      toggleClass(
        cell,
        'wj-cell-popup',
        (columnGroupProps?._ctrlType === CELL_CONTROL_TYPE.MODAL ||
          columnGroupProps?._ctrlType === CELL_CONTROL_TYPE.TEXT_MODAL) &&
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

      // ⛔ 모달 전용 셀만 직접 편집을 막는다.
      //   ⭐ [2026-08-22] `FPTextModal` 은 **막지 않는다** — 타이핑과 모달을 둘 다 허용하는 값이다
      //     (AS-IS 파리티). 여기에 TEXT_MODAL 을 함께 넣으면 신설 값의 존재 이유가 사라진다.
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

      if (!mouseEvent.ctrlKey) {
        // AscDescNone 3-state 순환: 미정렬 → 오름 → 내림 → 미정렬
        // - 미정렬(sortDescription 없음): 오름차순
        // - 오름차순: 내림차순
        // - 내림차순: 정렬 해제(push 하지 않음)
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

  return {
    setSummaryTooltip,
    setCellTooltip,
    setAggregationRow,
    setCheckbox,
    formatPopupIcon,
    formatEditableColumns,
    formatSortableColumns,
    setEditableColumns,
    setMoveCellByTab,
    setMoveByMetakey,
    setSortableColumnHeaderClick,
    setResultColumn,
    setHandleUppercase,
  };
};
