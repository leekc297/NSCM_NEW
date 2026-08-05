import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';

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
}: MailReceiverPanelProps) => {
  const { t } = useTranslation();

  const receiverSearchParams = useMailSetupStore(state => state.receiverSearchParams);
  const setReceiverSearchParams = useMailSetupStore(state => state.setReceiverSearchParams);
  const allReceiverColumns = useMailSetupStore(state => state.allReceiverColumns);
  const selReceiverColumns = useMailSetupStore(state => state.selReceiverColumns);

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
          />
        </div>
      </div>

      <div className={styles.transferButtons}>
        <Button size='small' onClick={onAddReceiver} aria-label={t('LBL00109', '_Add Row')}>
          {'▶'}
        </Button>
        <Button size='small' onClick={onRemoveReceiver} aria-label={t('LBL00407', '_Remove')}>
          {'◀'}
        </Button>
      </div>

      <div className={styles.receiverSide}>
        <div className={styles.receiverGrid}>
          <DataGrid<SelReceiverRow>
            gridRef={selGridRef}
            gridFilterRef={selGridFilterRef}
            itemsSource={selReceivers}
            staticColumns={selReceiverColumns}
            useSummaryTooltip={false}
          />
        </div>
      </div>
    </div>
  );
};
