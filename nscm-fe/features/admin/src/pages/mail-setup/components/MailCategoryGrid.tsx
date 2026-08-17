import { toggleClass } from '@mescius/wijmo';
import { CellType, type FlexGrid, type FormatItemEventArgs } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, type MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';

import { VIEW_BINDING } from '../mail-setup.constants';
import type { CategoryRow } from '../mail-setup.types';
import { useMailSetupStore } from '../useMailSetupStore';

import styles from './MailCategoryGrid.module.scss';

interface MailCategoryGridProps {
  gridRef: MutableRefObject<FlexGrid<CategoryRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: CategoryRow[];
  onOpenSqlDialog: (row: CategoryRow) => void;
}

export const MailCategoryGrid = ({
  gridRef,
  gridFilterRef,
  data,
  onOpenSqlDialog,
}: MailCategoryGridProps) => {
  const { t } = useTranslation();

  const categoryColumns = useMailSetupStore(state => state.categoryColumns);
  const selectCategory = useMailSetupStore(state => state.selectCategory);

  // 행 선택 → Message / 수신자 디테일 조회 (AS-IS: Category 행 선택 시 두 탭 동시 갱신)
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    const handleSelectionChanged = (sender: FlexGrid<CategoryRow>) => {
      const row = sender.selectedItems?.[0] as CategoryRow | undefined;
      selectCategory(row);
    };

    grid.selectionChanged.addHandler(handleSelectionChanged);
    return () => grid.selectionChanged.removeHandler(handleSelectionChanged);
  }, [gridRef, selectCategory, categoryColumns]);

  /**
   * SQL VIEW 셀을 AS-IS 처럼 버튼으로 렌더 (공통 그리드에 FPButton 렌더링 구현이 없어 화면에서 직접 그린다).
   *
   * 컬럼설정이 `FPModal` + `inputTpCd='O'` 라 공통 wrapper 가 `wj-cell-editable`(노란 배경)과
   * `wj-cell-popup`(↗ 아이콘)을 자동으로 붙인다. 그런데 FPModal 셀은 `beginningEdit` 가 항상 취소되어
   * **실제로는 편집이 불가능**하므로 노란 배경은 오해만 부른다 → 둘 다 끄고 편집불가 색 + 버튼만 남긴다.
   * (mkt-fcst 가 같은 충돌을 동일 방식으로 해결 — MktFcstGrid `.popup-icon`)
   *
   * 버튼 마크업·스타일·클릭 판정은 NoticeSetupGrid 의 ACTION 컬럼과 동일 규약을 따른다.
   *
   * DataGrid 가 등록한 formatItem 핸들러보다 뒤에 추가되므로 클래스 토글은 이쪽이 최종 승자다.
   */
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    const handleFormatItem = (sender: FlexGrid<CategoryRow>, event: FormatItemEventArgs) => {
      if (event.panel.cellType !== CellType.Cell) return;
      if (sender.columns[event.col]?.binding !== VIEW_BINDING) return;

      const cell = event.cell;
      toggleClass(cell, 'wj-cell-editable', false);
      toggleClass(cell, 'wj-cell-popup', false);
      // 편집 불가를 앱 공통 색으로 표기 — 흰 배경으로 두면 노란 편집 컬럼들 사이에서 의미 없이 튄다.
      toggleClass(cell, 'wj-cell-non-editable', true);

      // 저장 전 신규 행은 CATEGORY_ID 가 없어 조회할 SQL 자체가 없다 (오픈 가드와 동일 조건).
      const row = sender.rows[event.row]?.dataItem as CategoryRow | undefined;
      if (!row?.CATEGORY_ID) {
        cell.replaceChildren();
        return;
      }

      const viewWrapper = globalThis.document.createElement('div');
      viewWrapper.className = styles.viewCell;

      const viewButton = globalThis.document.createElement('button');
      viewButton.type = 'button';
      viewButton.className = styles.viewButton;
      viewButton.dataset.mailAction = 'sql-view';
      viewButton.textContent = 'VIEW';
      viewButton.setAttribute('aria-label', t('LBL00780', '_SQL VIEW'));

      viewWrapper.append(viewButton);
      cell.replaceChildren(viewWrapper);
    };

    grid.formatItem.addHandler(handleFormatItem);
    grid.invalidate();
    return () => grid.formatItem.removeHandler(handleFormatItem);
  }, [data, gridRef, categoryColumns, t]);

  const openSqlDialogAt = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;

    const hitTest = grid.hitTest(mouseEvent);
    if (hitTest.cellType !== CellType.Cell) return;
    if (grid.columns[hitTest.col]?.binding !== VIEW_BINDING) return;

    const row = grid.rows[hitTest.row]?.dataItem as CategoryRow | undefined;
    if (!row?.CATEGORY_ID) return;

    onOpenSqlDialog(row);
  };

  // 버튼을 직접 눌렀을 때만 연다 — 셀 여백 클릭은 행 선택으로 남겨둔다.
  const handleClick = (mouseEvent: MouseEvent) => {
    const eventTarget = mouseEvent.target;
    if (!(eventTarget instanceof Element)) return;
    if (!eventTarget.closest('button[data-mail-action="sql-view"]')) return;

    mouseEvent.preventDefault();
    mouseEvent.stopPropagation();
    openSqlDialogAt(mouseEvent);
  };

  // AS-IS 는 버튼 클릭이지만, 기존 더블클릭 동작도 유지 (다이얼로그 오픈은 멱등).
  const handleDoubleClick = (mouseEvent: MouseEvent) => openSqlDialogAt(mouseEvent);

  return (
    <div className={styles.gridSection}>
      <div className={styles.gridWrapper}>
        <DataGrid<CategoryRow>
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          itemsSource={data}
          staticColumns={categoryColumns}
          useSummaryTooltip={false}
          click={handleClick}
          dblClick={handleDoubleClick}
        />
      </div>
    </div>
  );
};
