import { AllowMerging, CellType, Column, type FlexGrid } from '@mescius/wijmo.grid';
import type { XlsxFormatItemEventArgs } from '@mescius/wijmo.grid.xlsx';
import { FlexGridXlsxConverter } from '@mescius/wijmo.grid.xlsx';
import {
  BorderStyle,
  HAlign,
  VAlign,
  WorkbookBorder,
  WorkbookBorderSetting,
  WorkbookCell,
  WorkbookFill,
  WorkbookFont,
  WorkbookFrozenPane,
  WorkbookRow,
  WorkbookStyle,
} from '@mescius/wijmo.xlsx';

import dayjs from '@foundation/dayjs';
import type { FlexGridColumnConfig } from '@foundation/models';

import type { CapaMobilityItRow, CapaRowItem } from '../capa-mobility-it.types';

import { kindOf } from './capa-mobility-it.dynamicColumns';
import { isCellEditable } from './capa-mobility-it.editLock';

/** 수정가능 셀 배경색 — 화면 $wj-editable-cell(#fff8cd) 과 동일(AS-IS 편집영역 노란색 파리티). */
const EDITABLE_FILL = '#fff8cd';

/** AS-IS FPC0109_ExcelSelect_Popup 3옵션. */
export interface ExcelExportOptions {
  merge: boolean; // 본문 좌측 키컬럼 세로 병합(Merged Column) / off=Seperated(평탄)
  border: boolean; // 헤더·본문 셀 테두리(Show Cell Border) / off=없음
  zero: boolean; // 본문 숫자 0 표시 / off=공백(Hide 0, 화면 표시와 동일)
}

const thinBorder = (): WorkbookBorder => {
  const side = () => {
    const s = new WorkbookBorderSetting();
    s.style = BorderStyle.Thin;
    s.color = '#000000';
    return s;
  };
  const b = new WorkbookBorder();
  b.top = side();
  b.bottom = side();
  b.left = side();
  b.right = side();
  return b;
};

/**
 * SCP0098 전용 Excel 내보내기 — AS-IS ExcelButton(FPC0109 옵션 팝업 + SimplexelService.ExportFpSpread) 대체.
 *   공통 GridAction.excelDownload 의 "columnGroups 평탄화 + 다단헤더 수동 재구성" 기법을 이식한다(wijmo 변환기의
 *   columnGroups+includeColumnHeaders 조합 버그 = 상위 N행 데이터 누락 회피). 여기에 FPC0109 3옵션을 반영한다:
 *   - Merge  : 좌측 키컬럼(정적) 세로 병합 유지(off=평탄). 다단 헤더 병합은 항상 유지(가독).
 *   - Border : 헤더·본문 전 셀 얇은 검정 테두리(off=없음).
 *   - Zero   : 본문 0/'0' 공백 처리(off=Hide 0, 화면 formatItem 과 동일).
 *   파일명·타임스탬프(yyyyMMddHHmmss)는 AS-IS(.cs:557)와 동일. 배경색은 미포함(공통 excelDownload 정책).
 */
export const exportCapaExcel = async (
  grid: FlexGrid<CapaMobilityItRow>,
  fileNamePrefix: string,
  opt: ExcelExportOptions
): Promise<void> => {
  const fileName = `${fileNamePrefix}_${dayjs().format('YYYYMMDDHHmmss')}.xlsx`;

  grid.beginUpdate();
  const clonedAllowMerging = grid.allowMerging;
  const clonedColumnGroups = [...(grid.columnGroups as FlexGridColumnConfig[])];
  const clonedHeaderHeights: (number | null)[] = [];
  for (let i = 0; i < grid.columnHeaders.rows.length; i++) {
    clonedHeaderHeights.push(grid.columnHeaders.rows[i].height);
  }

  // 화면에 실제 보이는 컬럼만(런타임 bucket 가시성 반영).
  const visibleBindings = new Set<string>();
  for (let i = 0; i < grid.columns.length; i++) {
    const c = grid.columns[i];
    if (c?.visible && c.binding) visibleBindings.add(c.binding);
  }

  const fullFlat = clonedColumnGroups
    .flatMap(g => g.columns ?? [g])
    .flatMap(g => g.columns ?? [g]);
  const flat = fullFlat.filter(c => !c.binding || visibleBindings.has(c.binding));

  // columnGroups 평탄화 — 변환기 버그 회피. 본문은 항상 평탄 추출(그리드 CustomMergeManager 는 뷰포트
  //   기준이라 전체 export 에서 병합이 깨진다) → Merged Column 은 아래에서 전체 데이터 기준으로 직접 계산.
  grid.columns.clear();
  grid.columnGroups = [];
  flat.forEach(c =>
    grid.columns.push(
      new Column({
        binding: c.binding,
        header: c.header,
        align: c.align,
        allowMerging: false,
        visible: c.visible,
        width: c.width,
      })
    )
  );
  grid.allowMerging = AllowMerging.None;

  // Merged Column 대상 — 좌측 정적 키컬럼(동적 기간컬럼·생산준비율 제외, 화면 CapaHeaderMergeManager 와 동일).
  const mergeColIdx = opt.merge
    ? flat.reduce<number[]>((acc, c, i) => {
        if (!kindOf(c.binding ?? '') && c.binding !== 'PRODUCT_READY') acc.push(i);
        return acc;
      }, [])
    : [];

  // 스타일.
  const headerFont = new WorkbookFont();
  headerFont.family = 'Spoqa Han Sans Neo';
  headerFont.size = 12;
  headerFont.bold = true;
  const bodyFont = new WorkbookFont();
  bodyFont.family = 'Spoqa Han Sans Neo';
  bodyFont.size = 12;

  const columnHeaderStyle = new WorkbookStyle();
  columnHeaderStyle.wordWrap = true;
  columnHeaderStyle.vAlign = VAlign.Center;
  columnHeaderStyle.hAlign = HAlign.Center;
  columnHeaderStyle.font = headerFont;
  if (opt.border) columnHeaderStyle.borders = thinBorder();

  const cellStyle = new WorkbookStyle();
  cellStyle.vAlign = VAlign.Center;
  cellStyle.font = bodyFont;
  if (opt.border) cellStyle.borders = thinBorder();

  // 편집가능 셀 노란 배경(AS-IS 편집영역 파리티) — isCellEditable 과 동일 판정(정적=PRODUCT_READY만, 동적=measure별).
  const staticBindings = new Set(
    flat.filter(c => !kindOf(c.binding ?? '')).map(c => c.binding ?? '')
  );
  const editFill = new WorkbookFill();
  editFill.color = EDITABLE_FILL;

  const headerDepth = clonedColumnGroups.reduce((d, g) => {
    const gd = g.columns?.some(s => !!s.columns?.length) ? 3 : g.columns?.length ? 2 : 1;
    return Math.max(d, gd);
  }, 1);

  const visibleLeafCount = (node: FlexGridColumnConfig): number =>
    node.columns?.length
      ? node.columns.reduce((sum, c) => sum + visibleLeafCount(c), 0)
      : !node.binding || visibleBindings.has(node.binding)
        ? 1
        : 0;
  const singleVisibleLeaf = (node: FlexGridColumnConfig): FlexGridColumnConfig | null => {
    if (!node.columns?.length) return node;
    const vis = node.columns.filter(c => visibleLeafCount(c) > 0);
    return vis.length === 1 ? singleVisibleLeaf(vis[0]) : null;
  };

  const restore = () => {
    grid.allowMerging = clonedAllowMerging;
    grid.columns.clear();
    grid.columnGroups = clonedColumnGroups;
    const hr = grid.columnHeaders.rows;
    for (let i = 0; i < hr.length && i < clonedHeaderHeights.length; i++) {
      hr[i].height = clonedHeaderHeights[i];
    }
    grid.endUpdate();
  };

  const convertOptions = {
    includeStyles: false,
    includeColumnHeaders: false, // 헤더는 아래에서 수동 구성(다단 병합)
    includeRowHeaders: false,
    formatItem: (args: XlsxFormatItemEventArgs) => {
      if (args.panel.cellType !== CellType.Cell) return;
      const binding = args.panel.columns[args.col]?.binding ?? '';
      const row = args.panel.rows[args.row]?.dataItem as CapaRowItem | undefined;

      // 편집가능 셀 노란 배경.
      const style = { ...args.xlsxCell.style, ...cellStyle };
      if (isCellEditable(binding, row, staticBindings)) style.fill = editFill;
      args.xlsxCell.style = style;

      // 0 처리 — 숫자 데이터 셀(생산준비율 + 동적 기간컬럼)만. AS-IS AmendNullToZero:
      //   Hide 0 해제(opt.zero) → 빈값을 0 으로 표시 / Hide 0 체크(!opt.zero) → 0·빈값을 공백.
      const isNumericData = binding === 'PRODUCT_READY' || kindOf(binding) !== null;
      if (!isNumericData) return;
      const v: unknown = args.panel.getCellData(args.row, args.col, false);
      const empty = v === null || v === undefined || v === '';
      if (opt.zero) {
        if (empty) args.xlsxCell.value = 0;
      } else if (empty || v === 0 || v === '0') {
        args.xlsxCell.value = '';
      }
    },
  };

  await new Promise<void>((resolve, reject) => {
    try {
      const workbook = FlexGridXlsxConverter.save(grid, convertOptions);
      const sheet = workbook.sheets[0];
      if (!sheet) throw new Error('xlsx sheet missing');

      // Merged Column — 전체 데이터 기준 세로 병합(누적키: 0..c 중 하나라도 바뀌면 끊김, 화면 로직 동일).
      //   includeColumnHeaders=false 라 sheet.rows 는 본문 데이터만. anchor 에 rowSpan, 가린 셀은 비운다.
      if (mergeColIdx.length > 0) {
        const body = sheet.rows;
        const val = (r: number, c: number): string => String(body[r]?.cells?.[c]?.value ?? '');
        // changeAt[r] = r 과 r-1 이 처음으로 달라지는 컬럼(없으면 Infinity). 동적 값 변화는 큰 인덱스라 좌측 병합 유지.
        const totalCols = flat.length;
        const changeAt: number[] = new Array<number>(body.length).fill(Number.POSITIVE_INFINITY);
        for (let r = 1; r < body.length; r++) {
          for (let c = 0; c < totalCols; c++) {
            if (val(r, c) !== val(r - 1, c)) {
              changeAt[r] = c;
              break;
            }
          }
        }
        for (const c of mergeColIdx) {
          let start = 0;
          for (let r = 1; r <= body.length; r++) {
            const broken = r === body.length || changeAt[r] <= c;
            if (!broken) continue;
            const span = r - start;
            if (span > 1 && body[start]?.cells?.[c]) {
              body[start].cells[c].rowSpan = span;
              for (let k = start + 1; k < r; k++) {
                if (body[k]?.cells?.[c]) body[k].cells[c].value = '';
              }
            }
            start = r;
          }
        }
      }

      const headerRows = Array.from({ length: headerDepth }, () => new WorkbookRow());
      const makeCell = (value: string, colSpan: number, rowSpan: number): WorkbookCell => {
        const cell = new WorkbookCell();
        cell.value = value;
        if (colSpan > 1) cell.colSpan = colSpan;
        if (rowSpan > 1) cell.rowSpan = rowSpan;
        cell.style = columnHeaderStyle;
        return cell;
      };
      let colIdx = 0;
      const walk = (node: FlexGridColumnConfig, level: number) => {
        const leafSpan = visibleLeafCount(node);
        if (leafSpan === 0) return;
        if (node.columns?.length) {
          const only = leafSpan === 1 ? singleVisibleLeaf(node) : null;
          if (only && String(only.header ?? '') === String(node.header ?? '')) {
            headerRows[level].cells[colIdx] = makeCell(String(node.header ?? ''), 1, headerDepth - level);
            colIdx += 1;
            return;
          }
          headerRows[level].cells[colIdx] = makeCell(String(node.header ?? ''), leafSpan, 1);
          node.columns.forEach(c => walk(c, level + 1));
        } else {
          headerRows[level].cells[colIdx] = makeCell(String(node.header ?? ''), 1, headerDepth - level);
          colIdx += 1;
        }
      };
      clonedColumnGroups.forEach(g => walk(g, 0));

      // 병합 anchor 외 빈 셀 densify(sparse 직렬화 회피).
      headerRows.forEach(rowCells => {
        for (let i = 0; i < colIdx; i++) {
          if (!rowCells.cells[i]) {
            const empty = new WorkbookCell();
            empty.style = columnHeaderStyle;
            rowCells.cells[i] = empty;
          }
        }
      });
      sheet.rows.unshift(...headerRows);

      // 틀고정 — 헤더 depth 행 + 좌측 정적(비동적) 컬럼.
      const frozenCols = flat.findIndex(c => kindOf(c.binding ?? ''));
      const frozenPane = new WorkbookFrozenPane();
      frozenPane.rows = headerDepth;
      frozenPane.columns = frozenCols > 0 ? frozenCols : 0;
      sheet.frozenPane = frozenPane;

      workbook.saveAsync(
        fileName,
        () => {
          restore();
          resolve();
        },
        (reason?: unknown) => {
          restore();
          reject(reason instanceof Error ? reason : new Error('xlsx save failed'));
        }
      );
    } catch (reason) {
      restore();
      reject(reason instanceof Error ? reason : new Error(String(reason)));
    }
  });
};
