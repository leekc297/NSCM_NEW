import { Clipboard, SortDescription } from '@mescius/wijmo';
import type { Column, FlexGrid } from '@mescius/wijmo.grid';
import { CellRange, CellType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';

import { t } from '@foundation/i18n';
import { GridUtils } from '@foundation/utils';

/**
 * 그리드 공통 컨텍스트(우클릭) 메뉴.
 *
 * DataGrid 가 초기화 시 자동 설치한다 — 화면 코드 무수정으로 전 화면 적용.
 * 헤더 우클릭: Pin / Filter / Sort ↑↓ / Autosize This·All
 * 바디 우클릭: Copy / Copy with Headers(All·Line) / Export
 * 화면 전용 항목은 DataGrid 의 `contextMenuItems` prop 으로 주입한다.
 *
 * wingui `applyGridContextMenu`(단일 메뉴 + 위치별 enable) 구조를 참조하되
 * 요구사항대로 헤더/바디 메뉴를 분리했다. UI 는 React 밖의 경량 DOM 메뉴 —
 * Wijmo 이벤트 시점에 즉석 생성하고 닫힐 때 제거하므로 리렌더와 무관하다.
 */

export interface GridContextMenuContext {
  grid: FlexGrid;
  /** 우클릭 지점의 행 인덱스 (헤더면 -1) */
  hitRow: number;
  /** 우클릭 지점의 컬럼 인덱스 */
  hitCol: number;
}

export interface GridContextMenuItem {
  /** 표시 라벨 (번역된 문자열) */
  label: string;
  action: (context: GridContextMenuContext) => void;
  disabled?: (context: GridContextMenuContext) => boolean;
  /** 이 항목 위에 구분선 표시 */
  separatorBefore?: boolean;
}

export interface GridContextMenuOptions {
  /** F4 필터 인스턴스 접근자 — 없으면 Filter 항목 비활성 */
  getFilter: () => FlexGridFilter | undefined;
  /** Export 항목 동작 (GridAction.excelDownload 래핑) */
  onExport: (context: GridContextMenuContext) => void;
  /** 화면 전용 추가 항목 (바디 메뉴 하단에 구분선과 함께 붙는다). 우클릭 지점 context 를 받아
   *   셀 조건부(예: 특정 measure 행에서만 항목 노출)로 반환할 수 있다. */
  getCustomItems?: (context: GridContextMenuContext) => GridContextMenuItem[] | undefined;
  /**
   * 레이아웃 개인화 항목 (Save/Load/Reset Layout) — DataGrid 가 layoutKey 지정 시 제공.
   * 헤더/바디 메뉴 양쪽 하단에 구분선과 함께 붙는다 (wingui 단일 메뉴의 SAVE/LOAD_GRID_LAYOUT 대응).
   */
  getLayoutItems?: () => GridContextMenuItem[] | undefined;
  /** Autosize 로 폭이 바뀐 컬럼 통지 — DataGrid 가 사용자 폭 기억(userColumnWidths)에 반영 */
  onWidthChanged?: (binding: string, width: number) => void;
  /** 컬럼 숨기기 (wingui COLUMN_HIDE 대응) — 지정 시 헤더 메뉴에 Hide/Unhide 항목 표시 */
  onHideColumn?: (binding: string) => void;
  onUnhideAllColumns?: () => void;
  hasHiddenColumns?: () => boolean;
}

/* ------------------------------------------------------------------ */
/* 메뉴 DOM — 전역에 한 번에 하나만 열린다                                */
/* ------------------------------------------------------------------ */

const MENU_STYLE: Partial<CSSStyleDeclaration> = {
  position: 'fixed',
  zIndex: '10000',
  minWidth: '220px',
  padding: '4px 0',
  background: '#fff',
  border: '1px solid #d0d0d0',
  borderRadius: '4px',
  boxShadow: '0 4px 14px rgba(0, 0, 0, 0.18)',
  fontSize: '13px',
  color: '#222',
  userSelect: 'none',
};

const ITEM_STYLE: Partial<CSSStyleDeclaration> = {
  display: 'block',
  width: '100%',
  padding: '7px 16px',
  border: 'none',
  background: 'none',
  textAlign: 'left',
  font: 'inherit',
  color: 'inherit',
  cursor: 'pointer',
};

let openedMenu: HTMLElement | null = null;
let removeGlobalClosers: (() => void) | null = null;

const closeMenu = () => {
  openedMenu?.remove();
  openedMenu = null;
  removeGlobalClosers?.();
  removeGlobalClosers = null;
};

const showMenu = (
  items: GridContextMenuItem[],
  context: GridContextMenuContext,
  x: number,
  y: number
) => {
  closeMenu();

  const menu = document.createElement('div');
  Object.assign(menu.style, MENU_STYLE);

  for (const item of items) {
    if (item.separatorBefore) {
      const hr = document.createElement('div');
      Object.assign(hr.style, { borderTop: '1px solid #e3e3e3', margin: '4px 0' });
      menu.append(hr);
    }

    const button = document.createElement('button');
    button.type = 'button';
    button.textContent = item.label;
    Object.assign(button.style, ITEM_STYLE);

    const disabled = item.disabled?.(context) ?? false;
    if (disabled) {
      Object.assign(button.style, { color: '#b0b0b0', cursor: 'default' });
    } else {
      button.addEventListener('mouseenter', () => (button.style.background = '#f0f4ff'));
      button.addEventListener('mouseleave', () => (button.style.background = 'none'));
      button.addEventListener('click', () => {
        closeMenu();
        item.action(context);
      });
    }
    menu.append(button);
  }

  document.body.append(menu);
  openedMenu = menu;

  // 화면 밖으로 나가지 않게 위치 보정
  const rect = menu.getBoundingClientRect();
  menu.style.left = `${Math.min(x, globalThis.window.innerWidth - rect.width - 4)}px`;
  menu.style.top = `${Math.min(y, globalThis.window.innerHeight - rect.height - 4)}px`;

  // 바깥 클릭/우클릭/휠/Escape/창 크기 변경 시 닫기
  const onMouseDown = (event: MouseEvent) => {
    if (!menu.contains(event.target as Node)) closeMenu();
  };
  const onKeyDown = (event: KeyboardEvent) => {
    if (event.key === 'Escape') closeMenu();
  };
  document.addEventListener('mousedown', onMouseDown, true);
  document.addEventListener('wheel', closeMenu, true);
  document.addEventListener('keydown', onKeyDown, true);
  globalThis.window.addEventListener('resize', closeMenu);
  removeGlobalClosers = () => {
    document.removeEventListener('mousedown', onMouseDown, true);
    document.removeEventListener('wheel', closeMenu, true);
    document.removeEventListener('keydown', onKeyDown, true);
    globalThis.window.removeEventListener('resize', closeMenu);
  };
};

/* ------------------------------------------------------------------ */
/* 항목 구성                                                            */
/* ------------------------------------------------------------------ */

/** 데이터 전체 범위 (0,0 ~ 마지막행,마지막열) */
const fullRange = (grid: FlexGrid) =>
  new CellRange(0, 0, grid.rows.length - 1, grid.columns.length - 1);

/**
 * 클립보드 복사 — 반드시 그리드에 포커스를 준 뒤 복사한다.
 *
 * Wijmo Clipboard.copy 는 임시 textarea 를 "현재 활성요소" 기준 위치에 붙여 select() 후
 * execCommand('copy') 한다. 우클릭 메뉴는 그리드에 포커스를 주지 않으므로, Copy 를 누르는 순간
 * 활성요소가 (닫힌) 메뉴 버튼 → body 가 되고 textarea 가 모달 focus-trap 바깥(body)에 붙는다.
 * 그러면 MUI FocusTrap 이 그 focus 를 곧바로 모달 안으로 되돌려 select() 가 무력화되고 빈
 * 문자열이 복사된다(붙여넣기 빈값 — DMF0020 Exchange Rate 팝업에서 재현).
 * Wijmo 자체 Ctrl+C 는 복사 직전 grid._eFocus.focus() 를 호출해 이 문제를 피한다 — 같은 방식으로 맞춘다.
 * (clip 문자열은 호출부에서 focus 이전에 이미 만들어 넘기므로 selection 에는 영향이 없다.)
 */
const copyToClipboard = (grid: FlexGrid, text: string) => {
  grid.focus();
  Clipboard.copy(text);
};

/** 현재 선택의 행 범위를 전체 컬럼 폭으로 확장. 선택이 없으면 우클릭 행 */
const lineRange = (grid: FlexGrid, hitRow: number) => {
  const selection = grid.selection;
  const [row1, row2] =
    selection.isValid && selection.row >= 0
      ? [Math.min(selection.row, selection.row2), Math.max(selection.row, selection.row2)]
      : [hitRow, hitRow];
  return new CellRange(row1, 0, row2, grid.columns.length - 1);
};

/** 헤더 클릭 정렬(dataGridUtils.setSortableColumnHeaderClick)과 동일한 제외 규칙 — 동적(주차/월/일) 컬럼 제외 */
const isSortableColumn = ({ grid, hitCol }: GridContextMenuContext): boolean => {
  const column = grid.columns[hitCol];
  if (!column?.binding) return false;
  return !GridUtils.getColumn(grid, hitCol)?._dynamic;
};

const applySort = ({ grid, hitCol }: GridContextMenuContext, ascending: boolean) => {
  const binding = grid.columns[hitCol]?.binding;
  if (!binding) return;
  grid.collectionView.sortDescriptions.clear();
  grid.collectionView.sortDescriptions.push(new SortDescription(binding, ascending));
  // 헤더 클릭 정렬과 동일한 후처리 — 선택 해제 후 맨 위로
  grid.select(-1, -1);
  grid.scrollIntoView(0, 0, true);
};

const notifyWidth = (options: GridContextMenuOptions, column: Column | undefined) => {
  if (column?.binding) options.onWidthChanged?.(column.binding, column.renderWidth);
};

const buildHeaderItems = (options: GridContextMenuOptions): GridContextMenuItem[] => [
  {
    label: t('CTX_PIN_COLUMN', 'Pin Column'),
    // 이미 고정 범위 안이면 라벨만으로는 구분이 안 되므로 Unpin 항목을 별도 제공
    action: ({ grid, hitCol }) => {
      grid.frozenColumns = hitCol + 1;
    },
  },
  {
    label: t('CTX_UNPIN_COLUMNS', 'Unpin Columns'),
    disabled: ({ grid }) => grid.frozenColumns === 0,
    action: ({ grid }) => {
      grid.frozenColumns = 0;
    },
  },
  {
    label: t('CTX_FILTER', 'Filter'),
    separatorBefore: true,
    disabled: ({ grid, hitCol }) => !options.getFilter() || !grid.columns[hitCol]?.binding,
    action: ({ grid, hitCol }) => {
      const filter = options.getFilter();
      const column = grid.columns[hitCol];
      if (!filter || !column?.binding) return;
      // F4 토글과 동일 규약 — 필터 대상 컬럼에 없으면 추가 후 에디터를 연다
      if (!filter.filterColumns.includes(column.binding)) filter.filterColumns.push(column.binding);
      filter.editColumnFilter(column);
    },
  },
  {
    label: t('CTX_SORT_ASC', 'Sort Ascending'),
    separatorBefore: true,
    disabled: context => !isSortableColumn(context),
    action: context => applySort(context, true),
  },
  {
    label: t('CTX_SORT_DESC', 'Sort Descending'),
    disabled: context => !isSortableColumn(context),
    action: context => applySort(context, false),
  },
  {
    label: t('CTX_AUTOSIZE_THIS', 'Autosize This Column'),
    separatorBefore: true,
    action: ({ grid, hitCol }) => {
      grid.autoSizeColumn(hitCol);
      notifyWidth(options, grid.columns[hitCol]);
    },
  },
  {
    label: t('CTX_AUTOSIZE_ALL', 'Autosize All Columns'),
    action: ({ grid }) => {
      grid.autoSizeColumns();
      for (let i = 0; i < grid.columns.length; i++) notifyWidth(options, grid.columns[i]);
    },
  },
  ...(options.onHideColumn
    ? ([
        {
          label: t('CTX_HIDE_COLUMN', 'Hide Column'),
          separatorBefore: true,
          // 필수(라벨 '*') 컬럼과 마지막 남은 표시 컬럼은 숨김 금지 (ColumnLayoutModal 규칙과 동일)
          disabled: ({ grid, hitCol }) => {
            const column = grid.columns[hitCol];
            if (!column?.binding) return true;
            if (
              String(column.header ?? '')
                .trim()
                .endsWith('*')
            )
              return true;
            let visibleCount = 0;
            for (let i = 0; i < grid.columns.length; i++) {
              if (grid.columns[i].visible && grid.columns[i].binding) visibleCount += 1;
            }
            return visibleCount <= 1;
          },
          action: ({ grid, hitCol }) => {
            const binding = grid.columns[hitCol]?.binding;
            if (binding) options.onHideColumn?.(binding);
          },
        },
        {
          label: t('CTX_UNHIDE_ALL', 'Unhide All Columns'),
          disabled: () => !options.hasHiddenColumns?.(),
          action: () => options.onUnhideAllColumns?.(),
        },
      ] satisfies GridContextMenuItem[])
    : []),
];

const buildBodyItems = (
  options: GridContextMenuOptions,
  context: GridContextMenuContext
): GridContextMenuItem[] => {
  const items: GridContextMenuItem[] = [
    {
      label: t('CTX_COPY', 'Copy'),
      action: ({ grid }) => {
        copyToClipboard(grid, grid.getClipString());
      },
    },
    {
      label: t('CTX_COPY_HEADERS_ALL', 'Copy with Headers (Copy All)'),
      action: ({ grid }) => {
        copyToClipboard(grid, grid.getClipString(fullRange(grid), false, true));
      },
    },
    {
      label: t('CTX_COPY_HEADERS_LINE', 'Copy with Headers (Line)'),
      action: ({ grid, hitRow }) => {
        copyToClipboard(grid, grid.getClipString(lineRange(grid, hitRow), false, true));
      },
    },
    {
      label: t('CTX_EXPORT', 'Export'),
      separatorBefore: true,
      action: context => options.onExport(context),
    },
  ];

  const customItems = options.getCustomItems?.(context);
  if (customItems?.length) {
    items.push(
      ...customItems.map((item, index) => ({
        ...item,
        separatorBefore: index === 0 ? true : item.separatorBefore,
      }))
    );
  }
  return items;
};

/* ------------------------------------------------------------------ */
/* 설치                                                                 */
/* ------------------------------------------------------------------ */

/**
 * 그리드에 컨텍스트 메뉴를 설치한다. 반환 함수로 해제.
 * 허용 영역: 컬럼 헤더(그룹 헤더 포함) / 데이터 셀.
 * rowHeader(No·상태)·corner·빈 영역은 브라우저 기본 메뉴를 유지한다.
 */
export const attachGridContextMenu = (
  grid: FlexGrid,
  options: GridContextMenuOptions
): (() => void) => {
  const handler = (event: MouseEvent) => {
    const hit = grid.hitTest(event);

    if (hit.col < 0) return;

    const context: GridContextMenuContext = { grid, hitRow: hit.row, hitCol: hit.col };
    let items: GridContextMenuItem[];
    if (hit.cellType === CellType.ColumnHeader) {
      items = buildHeaderItems(options);
    } else if (hit.cellType === CellType.Cell && hit.row >= 0) {
      items = buildBodyItems(options, context);
    } else {
      return;
    }

    // 레이아웃 개인화 항목 — 헤더/바디 공통 하단 섹션
    const layoutItems = options.getLayoutItems?.();
    if (layoutItems?.length) {
      items = [
        ...items,
        ...layoutItems.map((item, index) => ({
          ...item,
          separatorBefore: index === 0 ? true : item.separatorBefore,
        })),
      ];
    }

    event.preventDefault();
    event.stopPropagation();
    showMenu(items, context, event.clientX, event.clientY);
  };

  grid.hostElement.addEventListener('contextmenu', handler);
  return () => {
    closeMenu();
    grid.hostElement?.removeEventListener('contextmenu', handler);
  };
};
