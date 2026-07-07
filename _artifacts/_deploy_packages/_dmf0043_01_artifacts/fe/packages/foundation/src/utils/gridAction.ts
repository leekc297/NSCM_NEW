import { CollectionView } from '@mescius/wijmo';
import { AllowMerging, CellType, Column, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { IFlexGridXlsxOptions, XlsxFormatItemEventArgs } from '@mescius/wijmo.grid.xlsx';
import { FlexGridXlsxConverter } from '@mescius/wijmo.grid.xlsx';
import {
  HAlign,
  VAlign,
  WorkbookCell,
  WorkbookFont,
  WorkbookRow,
  WorkbookStyle,
} from '@mescius/wijmo.xlsx';
import dayjs from 'dayjs';

import { apiClient } from '@foundation/apis';
import { CELL_CONTROL_TYPE, CRUD_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig } from '@foundation/models';

import { GridUtils } from './gridUtils';
import { CustomMergeManager } from './mergeManager';

export const GridAction = {
  GridAction: {},

  clear: <T extends WijmoRowItem = WijmoRowItem>(
    funcSetGridData: (gridData: CollectionView<T>) => void,
    funcSetDataCount: (dataCount: number) => void,
    grid: FlexGrid<T>,
    gridFilter?: FlexGridFilter
  ) => {
    funcSetGridData(new CollectionView());
    funcSetDataCount(0);
    grid.select(-1, -1);
    grid.mergeManager = new CustomMergeManager(grid);
    gridFilter?.clear();
  },

  // F1: Open manual
  getManual: (manualUrl: string) => {
    // TODO: 화면 별 manual file (pdf or ppt) - 강민재
    console.error(manualUrl);
  },

  // F2: Toggle edit mode - deprecated
  toggleEditMode: <T extends WijmoRowItem = WijmoRowItem>(grid: FlexGrid<T>) => {
    grid.isReadOnly = !grid.isReadOnly;
    grid.invalidate();
  },

  // F3: Toggle sort property of columns
  toggleColumnSort: <T extends WijmoRowItem = WijmoRowItem>(grid: FlexGrid<T>) => {
    const selection = grid?.selection;
    const minCol = Math.min(selection.col, selection.col2);
    const maxCol = Math.max(selection.col, selection.col2);

    for (let selectedCol = minCol; selectedCol <= maxCol; selectedCol++) {
      const binding = grid.columns[selectedCol].binding;
      if (!grid.collectionView.sortDescriptions.some(sd => sd.property === binding))
        grid.columns[selectedCol].allowSorting = !grid.columns[selectedCol].allowSorting;
    }

    grid.invalidate();
  },

  // F4 : Toggle filter
  toggleColumnFilter: <T extends WijmoRowItem = WijmoRowItem>(
    grid: FlexGrid<T>,
    gridFilter: FlexGridFilter
  ) => {
    const selection = grid.selection;
    const minCol = Math.min(selection.col, selection.col2);
    const maxCol = Math.max(selection.col, selection.col2);

    for (let selectedCol = minCol; selectedCol <= maxCol; selectedCol++) {
      const binding = grid.columns[selectedCol].binding ?? '';
      const bindingIndex = gridFilter.filterColumns.indexOf(binding);

      if (bindingIndex === -1) gridFilter.filterColumns.push(binding);
      else gridFilter.filterColumns.splice(bindingIndex, 1);
    }

    grid.invalidate();
  },

  // F6: Save personalized condition
  //   ⚠️ BE SearchCondition.paramCtn 은 String — 값이 배열(multi-select)/불리언이면 그대로 보내면
  //      Jackson 역직렬화 실패(400)로 저장이 조용히 안 됨. → payload 는 항상 문자열로 coerce.
  //      (배열=콤마 join / null·undefined='' / 그 외 String). string 값 화면은 무변경(회귀 0).
  personalizeCondition: async (menuId: string, searchParam: Record<string, unknown>) => {
    await apiClient.post(
      `/admin/menu/${menuId}/search-conditions`,
      Object.entries(searchParam)
        .map(([key, data]) => {
          let paramCtn: string;
          if (Array.isArray(data)) paramCtn = data.join(',');
          else if (data == null) paramCtn = '';
          else paramCtn = String(data as string | number | boolean);
          return { paramNm: key, paramCtn };
        })
        // 빈값 제외 — 저장 SP(P_SCM0000_SAVE_SRCH_COND)가 빈 PRAM_CTN 을 어차피 skip 하므로 무손실.
        //   동시에 payload 축소로 SP 디버그 청크로깅(v_description VARCHAR2(500)) 오버플로(ORA-06502) 회피.
        .filter(item => item.paramCtn !== '')
    );
  },

  // F8: Add row
  addRow: <T extends WijmoRowItem = WijmoRowItem>(
    grid: FlexGrid<T>,
    defaultCopyProps: Partial<T>,
    placement: 'below' | 'top' | 'bottom' | 'above' = 'above'
  ) => {
    if (grid.isReadOnly) return;
    const itemsSource = grid.itemsSource as T[];
    const editFlag = itemsSource.every(item => item?.EDIT_FLAG === 'N');
    // TODO: 조회 없이 (그리드에 데이터 없이) 추가할 때 handle 추가적으로 필요  - 강민재
    if (itemsSource.length !== 0 && editFlag) return;

    let insertRowIndex: number = 0;
    const newRow = {
      ...defaultCopyProps,
      CRUD_TYPE: 'I',
    } as unknown as T;

    switch (placement) {
      case 'below':
        insertRowIndex = grid.collectionView.items.length > 0 ? (grid?.selection.row ?? -1) : 0;
        break;
      case 'bottom':
        insertRowIndex = grid?.collectionView.items.length;
        break;
      case 'top':
      case 'above':
        // Insert the new row above of the current selected row
        insertRowIndex = -1;
        if (grid.collectionView.items.length) {
          insertRowIndex = (grid?.selection.row ?? 0) - 1;
        }
        break;
      default:
        break;
    }

    grid.collectionView.sourceCollection.splice(insertRowIndex + 1, 0, newRow);
    (grid.collectionView as CollectionView).itemsAdded.push(newRow);

    grid.mergeManager = new CustomMergeManager(grid);
    grid.collectionView.refresh();
    grid.invalidate();
  },

  // F9: Remove row
  removeRow: <T extends WijmoRowItem = WijmoRowItem>(
    grid: FlexGrid<T>,
    deleteOnlyNew: boolean = false
  ) => {
    if (grid.isReadOnly) return false;

    const rows = GridUtils.getSelectedRows(grid);
    if (!rows?.length) return false;

    rows.forEach(row => {
      if (row.CRUD_TYPE === CRUD_TYPE.CREATE || row.CRUD_TYPE === CRUD_TYPE.INSERT)
        grid.editableCollectionView.remove(row);
      else if (!deleteOnlyNew) row['CRUD_TYPE'] = CRUD_TYPE.DELETE;
    });

    grid.editableCollectionView.commitEdit();
    grid.mergeManager = new CustomMergeManager(grid);
    grid.invalidate();

    return true;
  },

  // F10: Reset personalized condition
  resetPersonalizedCondition: async (menuId: string) => {
    await apiClient.post(`/admin/menu/${menuId}/search-conditions/reset`);
  },

  // F11 : Excel download
  excelDownload: <T extends WijmoRowItem = WijmoRowItem>(
    grid: FlexGrid<T>,
    menuName: string,
    setProgress?: (progress: number) => void
  ) => {
    grid.beginUpdate();

    const fileName = `${menuName}_${dayjs().format('YYYYMMDD_hhmmss')}`;

    const clonedAllowMerging = grid.allowMerging;
    const clonedColumnGroups = [...(grid.columnGroups as FlexGridColumnConfig[])];
    const clonedColumnHeaderHeight = grid.columnHeaders.rows[0].height;
    // 화면에 실제 표시중인 컬럼 binding 집합 (grid.columns.clear() 이전 = 원본 상태).
    //   컬럼설정 팝업으로 런타임 숨김한 컬럼까지 정확히 반영(정적 display + 런타임 visible 모두).
    const visibleBindings = new Set<string>();
    for (let i = 0; i < grid.columns.length; i++) {
      const liveColumn = grid.columns[i];
      if (liveColumn?.visible && liveColumn.binding) visibleBindings.add(liveColumn.binding);
    }

    const flatColumnGroups = clonedColumnGroups
      .flatMap(largeGroup => largeGroup.columns ?? [largeGroup])
      .flatMap(smallGroup => smallGroup.columns ?? [smallGroup])
      // 숨긴 컬럼은 엑셀 export 에서 제외 (2026-07-01 사용자 요구 — 전체 화면 공통).
      .filter(columnGroup => !columnGroup.binding || visibleBindings.has(columnGroup.binding));

    /**
     * TODO: 현재 Wijmo 버전에서는 columnGroups 사용시,
     * includeStyles: false, includeColumnHeaders: true
     * 위 속성들과 호환이 되지 않음 (컬럼헤더의 로우 개수만큼 데이터의 상위 n개가 엑셀에 불러와지지 않음... formatItem에서 애초에 index를 찍을 때 스킵되는 버그)
     */
    grid.columns.clear();
    grid.columnGroups = [];
    // grid.columnHeaders.rows.clear();

    flatColumnGroups.forEach(columnGroup =>
      grid.columns.push(
        new Column({
          binding: columnGroup.binding,
          header: columnGroup.header,
          align: columnGroup.align,
          allowMerging: false,
          visible: columnGroup.visible,
          width: columnGroup.width,
        })
      )
    );

    grid.allowMerging = AllowMerging.None;
    grid.columnHeaders.rows[0].height = 48;

    const headerFontStyle = new WorkbookFont();
    headerFontStyle.family = 'Spoqa Han Sans Neo';
    headerFontStyle.size = 12;
    headerFontStyle.bold = true;

    const fontStyle = new WorkbookFont();
    fontStyle.family = 'Spoqa Han Sans Neo';
    fontStyle.size = 12;
    fontStyle.bold = false;

    const columnHeaderStyle = new WorkbookStyle();
    columnHeaderStyle.wordWrap = true;
    columnHeaderStyle.vAlign = VAlign.Center;
    columnHeaderStyle.hAlign = HAlign.Center;
    columnHeaderStyle.font = headerFontStyle;

    const cellStyle = new WorkbookStyle();
    cellStyle.vAlign = VAlign.Center;
    cellStyle.font = fontStyle;

    // ⭐ 다단 헤더 depth (2026-07-04 사용자 요구 — 2단/3단 헤더 유지 다운로드).
    //   depth 1 = 기존 경로 그대로 (회귀 0). depth>1 = 데이터만 변환 후 헤더 행을 수동 구성(병합).
    //   (wijmo 변환기의 columnGroups+includeColumnHeaders 조합 버그 회피 — 아래 TODO 참조)
    const headerDepth = clonedColumnGroups.reduce((depth, group) => {
      const groupDepth = group.columns?.some(sub => !!sub.columns?.length)
        ? 3
        : group.columns?.length
          ? 2
          : 1;
      return Math.max(depth, groupDepth);
    }, 1);

    const convertOptions: IFlexGridXlsxOptions = {
      includeStyles: false,
      includeColumnHeaders: headerDepth === 1,
      includeRowHeaders: false,
      formatItem: (xlsxFormatItemEventArgs: XlsxFormatItemEventArgs) => {
        const cellType = xlsxFormatItemEventArgs.panel.cellType;
        const xlsxCell = xlsxFormatItemEventArgs.xlsxCell;
        const col = xlsxFormatItemEventArgs.col;

        /**
         * TODO: 느려지는 원인 (window에서 실제로 보이는 style을 가져오는 작업)
         * const cellEelement = xlsxFormatItemEventArgs.panel.getCellElement(row, col);
         * const computedStyle = window.getComputedStyle(cellEelement);
         */

        if (cellType === CellType.ColumnHeader)
          xlsxCell.style = { ...xlsxCell.style, ...columnHeaderStyle };
        else if (cellType === CellType.Cell) {
          // BACKCOLOR 처리 제외 (2026-07-01 사용자 요구 — 전체 화면 공통): fill 미설정 → 셀 배경색 없음.
          xlsxCell.style = {
            ...xlsxCell.style,
            ...cellStyle,
          };

          const dataType = flatColumnGroups[col]._ctrlType;
          xlsxCell.isDate = dataType === CELL_CONTROL_TYPE.DATE; // TODO: CELL_CONTROL_TYPE DATE 타입 추가 시 조건 변경 필요 - 강민재
          xlsxCell.isNumber = dataType === CELL_CONTROL_TYPE.NUMBER;
        }
      },
    };

    const resetGridProps = () => {
      grid.allowMerging = clonedAllowMerging;
      grid.columns.clear();
      grid.columnGroups = clonedColumnGroups;
      grid.columnHeaders.rows[0].height = clonedColumnHeaderHeight;
      grid.endUpdate();
    };

    // 기존 평탄화(1단 헤더) 저장 경로 — depth 1 기본 + 다단 구성 실패 시 공통 폴백.
    //   폴백은 헤더 포함 옵션으로 저장 (includeColumnHeaders:false 였다면 헤더 없는 파일 방지).
    const saveFlat = (resolve: () => void, reject: (reason?: unknown) => void) => {
      FlexGridXlsxConverter.saveAsync(
        grid,
        { ...convertOptions, includeColumnHeaders: true },
        fileName,
        () => {
          resetGridProps();
          resolve();
        },
        reason => {
          resetGridProps();
          reject(reason instanceof Error ? reason : new Error(String(reason)));
        },
        setProgress,
        true,
        50
      );
    };

    // ⭐ depth>1 — 데이터만 변환(includeColumnHeaders:false) 후, columnGroups 트리를 걸어
    //   다단 헤더 행을 Workbook 앞에 수동 삽입 (colSpan=하위 leaf 수 / 얕은 컬럼·leaf 는
    //   rowSpan 으로 세로 병합 — 그리드 다단 헤더 1:1). 숨김 컬럼은 visibleBindings 로 제외.
    //   ⭐ 안전장치 (공통 적용 — 타 화면 오류 0 보장): 다단 구성이 어떤 이유로든 실패하거나
    //   헤더 leaf 수 ≠ 데이터 컬럼 수(구조 불일치)면 기존 평탄화 경로로 자동 폴백.
    if (headerDepth > 1) {
      return new Promise<void>((resolve, reject) => {
        try {
          const workbook = FlexGridXlsxConverter.save(grid, convertOptions);
          const sheet = workbook.sheets[0];

          // WorkbookRow.cells 는 readonly lazy-init getter — 반환 배열을 index/push 로 변이해 채운다
          const headerRows: WorkbookRow[] = Array.from(
            { length: headerDepth },
            () => new WorkbookRow()
          );
          const makeCell = (value: string, colSpan: number, rowSpan: number): WorkbookCell => {
            const cell = new WorkbookCell();
            cell.value = value;
            if (colSpan > 1) cell.colSpan = colSpan;
            if (rowSpan > 1) cell.rowSpan = rowSpan;
            cell.style = columnHeaderStyle;
            return cell;
          };
          const visibleLeafCount = (node: FlexGridColumnConfig): number =>
            node.columns?.length
              ? node.columns.reduce((sum, child) => sum + visibleLeafCount(child), 0)
              : !node.binding || visibleBindings.has(node.binding)
                ? 1
                : 0;

          let colIdx = 0;
          // 단일 visible leaf 를 따라 내려가며 반환(분기=leaf 2개 이상이면 null).
          const singleVisibleLeaf = (
            node: FlexGridColumnConfig
          ): FlexGridColumnConfig | null => {
            if (!node.columns?.length) return node;
            const vis = node.columns.filter(child => visibleLeafCount(child) > 0);
            if (vis.length !== 1) return null;
            return singleVisibleLeaf(vis[0]);
          };
          const walk = (node: FlexGridColumnConfig, level: number) => {
            const leafSpan = visibleLeafCount(node);
            if (leafSpan === 0) return; // 전부 숨김 그룹 — 헤더 미출력
            if (node.columns?.length) {
              // ⭐ 같은 라벨의 degenerate single-leaf 체인 = '실질 flat 컬럼'(예: UI Category Setup 에서
              //   LARGE(대분류) 라벨 공란 → SMALL=colLbl 만 존재 → single-leaf group 으로 매핑된 정적 컬럼)
              //   → 세로 병합 1셀로 collapse. UI(HierarchicalMergeManager content-merge)가 이미 세로 병합하므로
              //   export 도 동일하게 재현(라벨 값 유무 무관). leafSpan≥2 정상 다단 그룹은 미영향. 2026-07-07.
              const only = leafSpan === 1 ? singleVisibleLeaf(node) : null;
              if (only && String(only.header ?? '') === String(node.header ?? '')) {
                headerRows[level].cells[colIdx] = makeCell(
                  String(node.header ?? ''),
                  1,
                  headerDepth - level // 남은 행 세로 병합
                );
                colIdx += 1;
                return;
              }
              headerRows[level].cells[colIdx] = makeCell(String(node.header ?? ''), leafSpan, 1);
              node.columns.forEach(child => walk(child, level + 1));
            } else {
              // leaf (얕은 정적 컬럼 포함) — 남은 행을 세로 병합
              headerRows[level].cells[colIdx] = makeCell(
                String(node.header ?? ''),
                1,
                headerDepth - level
              );
              colIdx += 1;
            }
          };
          clonedColumnGroups.forEach(group => walk(group, 0));

          // 무결성 가드 — 헤더 leaf 수 ≠ 데이터 컬럼 수면 위치가 어긋나므로 폴백
          if (colIdx !== flatColumnGroups.length || !sheet) {
            saveFlat(resolve, reject);
            return;
          }

          // 병합 anchor 외 위치는 빈 셀로 densify (sparse 배열 직렬화 회피)
          headerRows.forEach(row => {
            for (let i = 0; i < colIdx; i++) {
              if (!row.cells[i]) {
                const empty = new WorkbookCell();
                empty.style = columnHeaderStyle;
                row.cells[i] = empty;
              }
            }
          });

          // WorkSheet.rows 도 readonly getter — unshift 로 헤더 행을 데이터 앞에 삽입
          sheet.rows.unshift(...headerRows);
          workbook.saveAsync(
            fileName,
            () => {
              resetGridProps();
              resolve();
            },
            () => {
              // 다단 workbook 저장 실패 → 평탄화 폴백 1회 (타 화면 오류 0 보장)
              saveFlat(resolve, reject);
            },
            setProgress
          );
        } catch {
          // 다단 구성 자체가 실패 → 기존 평탄화 경로 폴백
          saveFlat(resolve, reject);
        }
      });
    }

    return new Promise<void>((resolve, reject) => {
      saveFlat(resolve, reject);
    });
  },
};
