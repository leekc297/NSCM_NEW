import { CellType, type FlexGrid, type FormatItemEventArgs } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, type MutableRefObject } from 'react';

import { DataGrid } from '@shared/components';

import type { NoticeSetupRow } from '../notice-setup.types';
import { useNoticeSetupStore } from '../useNoticeSetupStore';

import styles from './NoticeSetupGrid.module.scss';

interface NoticeSetupGridProps {
  gridRef: MutableRefObject<FlexGrid<NoticeSetupRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: NoticeSetupRow[];
}

export const NoticeSetupGrid = ({ gridRef, gridFilterRef, data }: NoticeSetupGridProps) => {
  const { t } = useTranslation();

  const staticColumns = useNoticeSetupStore(state => state.staticColumns);
  const openEditEditor = useNoticeSetupStore(state => state.openEditEditor);
  const openPreview = useNoticeSetupStore(state => state.openPreview);

  const handleGridClick = (event: MouseEvent) => {
    const grid = gridRef.current;
    const eventTarget = event.target;
    if (!grid || !(eventTarget instanceof Element)) return;

    const actionButton = eventTarget.closest<HTMLButtonElement>('button[data-notice-action]');
    if (!actionButton) return;

    const hitTest = grid.hitTest(event);
    if (hitTest.cellType !== CellType.Cell) return;

    const notice = grid.rows[hitTest.row]?.dataItem as NoticeSetupRow | undefined;
    if (!notice) return;

    event.preventDefault();
    event.stopPropagation();

    if (actionButton.dataset.noticeAction === 'edit') openEditEditor(notice);
    if (actionButton.dataset.noticeAction === 'preview') openPreview(notice);
  };

  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    const formatActions = (sender: FlexGrid<NoticeSetupRow>, event: FormatItemEventArgs) => {
      if (event.panel.cellType !== CellType.Cell) return;
      if (sender.columns[event.col]?.binding !== 'ACTION') return;

      const actionWrapper = globalThis.document.createElement('div');
      actionWrapper.className = styles.actions;

      const editButton = globalThis.document.createElement('button');
      editButton.type = 'button';
      editButton.className = styles.actionButton;
      editButton.dataset.noticeAction = 'edit';
      editButton.textContent = t('LBL00414', '_Edit');
      editButton.setAttribute('aria-label', t('LBL00414', '_Edit'));

      const separator = globalThis.document.createElement('span');
      separator.className = styles.actionSeparator;
      separator.textContent = '|';

      const previewButton = globalThis.document.createElement('button');
      previewButton.type = 'button';
      previewButton.className = styles.actionButton;
      previewButton.dataset.noticeAction = 'preview';
      previewButton.textContent = t('LBL00385', '_Preview');
      previewButton.setAttribute('aria-label', t('LBL00385', '_Preview'));

      actionWrapper.append(editButton, separator, previewButton);
      event.cell.replaceChildren(actionWrapper);
    };

    grid.formatItem.addHandler(formatActions);
    grid.invalidate();

    return () => grid.formatItem.removeHandler(formatActions);
  }, [data, gridRef, t]);

  return (
    <div className={styles.gridSection}>
      <div className={styles.gridWrapper}>
        <DataGrid<NoticeSetupRow>
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          itemsSource={data}
          staticColumns={staticColumns}
          isReadOnly
          useSummaryTooltip={false}
          click={handleGridClick}
          headerRowHeight={28}
        />
      </div>
    </div>
  );
};
