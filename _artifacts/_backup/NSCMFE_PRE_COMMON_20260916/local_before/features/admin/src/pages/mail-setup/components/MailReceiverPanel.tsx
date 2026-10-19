import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';

import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { Button, FormItem, InputField } from '@shared/lges';

import type { AllReceiverRow, SelReceiverRow } from '../mail-setup.types';
import { useMailSetupStore } from '../useMailSetupStore';

import styles from './MailTabGrid.module.scss';

interface MailReceiverPanelProps {
  allGridRef: MutableRefObject<FlexGrid<AllReceiverRow> | undefined>;
  allGridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  selGridRef: MutableRefObject<FlexGrid<SelReceiverRow> | undefined>;
  selGridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  allReceivers: AllReceiverRow[];
  selReceivers: SelReceiverRow[];
  onSearchReceiver: () => void;
  onAddReceiver: () => void;
  onRemoveReceiver: () => void;
  /** 좌측(전체) 그리드 더블클릭 — 그 행 하나만 추가 */
  onAddReceiverRow: (row: AllReceiverRow) => void;
  /** 우측(선택) 그리드 더블클릭 — 그 행 하나만 제거 */
  onRemoveReceiverRow: (row: SelReceiverRow) => void;
}

export const MailReceiverPanel = ({
  allGridRef,
  allGridFilterRef,
  selGridRef,
  selGridFilterRef,
  allReceivers,
  selReceivers,
  onSearchReceiver,
  onAddReceiver,
  onRemoveReceiver,
  onAddReceiverRow,
  onRemoveReceiverRow,
}: MailReceiverPanelProps) => {
  const { t } = useTranslation();

  const receiverSearchParams = useMailSetupStore(state => state.receiverSearchParams);
  const setReceiverSearchParams = useMailSetupStore(state => state.setReceiverSearchParams);
  const allReceiverColumns = useMailSetupStore(state => state.allReceiverColumns);
  const selReceiverColumns = useMailSetupStore(state => state.selReceiverColumns);

  // 좌측 그리드 더블클릭 → 그 행만 우측으로 추가
  const handleAllGridDblClick = (mouseEvent: MouseEvent) => {
    const grid = allGridRef.current;
    if (!grid) return;

    const hitTest = grid.hitTest(mouseEvent);
    if (hitTest.cellType !== CellType.Cell) return;

    const row = GridUtils.getRow(grid, hitTest.row);
    if (!row) return;

    onAddReceiverRow(row);
  };

  // 우측 그리드 더블클릭 → 그 행만 제거
  const handleSelGridDblClick = (mouseEvent: MouseEvent) => {
    const grid = selGridRef.current;
    if (!grid) return;

    const hitTest = grid.hitTest(mouseEvent);
    if (hitTest.cellType !== CellType.Cell) return;

    const row = GridUtils.getRow(grid, hitTest.row);
    if (!row) return;

    onRemoveReceiverRow(row);
  };

  return (
    <div className={styles.receiverPanel}>
      <div className={styles.receiverSide}>
        <div className={styles.receiverSearch}>
          <FormItem
            label={t('LBL00615', '_Department')}
            labelAlign='right'
            render={() => (
              <InputField
                value={receiverSearchParams.dept}
                onChange={event => setReceiverSearchParams({ dept: event.target.value })}
              />
            )}
          />
          <FormItem
            label={t('LBL00339', '_User ID(Name)')}
            labelAlign='right'
            render={() => (
              <InputField
                value={receiverSearchParams.user}
                onChange={event => setReceiverSearchParams({ user: event.target.value })}
              />
            )}
          />
          <Button size='small' onClick={onSearchReceiver}>
            {t('LBL00112', '_Search')}
          </Button>
        </div>
        <div className={styles.receiverGrid}>
          <DataGrid<AllReceiverRow>
            gridRef={allGridRef}
            gridFilterRef={allGridFilterRef}
            itemsSource={allReceivers}
            staticColumns={allReceiverColumns}
            useSummaryTooltip={false}
            isReadOnly
            dblClick={handleAllGridDblClick}
          />
        </div>
      </div>

      <div className={styles.transferButtons}>
        <Button size='small' onClick={onAddReceiver} aria-label={t('LBL00109', '_Add Row')}>
          ▶
        </Button>
        <Button size='small' onClick={onRemoveReceiver} aria-label={t('LBL00407', '_Remove')}>
          ◀
        </Button>
      </div>

      <div className={styles.receiverSide}>
        {/* 좌측 검색줄과 높이를 맞추기 위한 spacer — 좌측 그리드와 시작 y 좌표를 정렬한다 */}
        <div className={styles.receiverSearch} aria-hidden style={{ visibility: 'hidden' }}>
          <FormItem
            label={t('LBL00615', '_Department')}
            labelAlign='right'
            render={() => <InputField value='' onChange={() => {}} tabIndex={-1} />}
          />
          <Button size='small' tabIndex={-1}>
            {t('LBL00112', '_Search')}
          </Button>
        </div>
        <div className={styles.receiverGrid}>
          <DataGrid<SelReceiverRow>
            gridRef={selGridRef}
            gridFilterRef={selGridFilterRef}
            itemsSource={selReceivers}
            staticColumns={selReceiverColumns}
            useSummaryTooltip={false}
            dblClick={handleSelGridDblClick}
          />
        </div>
      </div>
    </div>
  );
};
