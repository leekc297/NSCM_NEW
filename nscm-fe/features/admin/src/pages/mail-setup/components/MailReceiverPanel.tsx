import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';

import type { EditTracker } from '@foundation/utils';
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
  selEditTrackerRef: MutableRefObject<EditTracker<SelReceiverRow> | undefined>;
  allReceivers: AllReceiverRow[];
  selReceivers: SelReceiverRow[];
  onSearchReceiver: () => void;
  onAddReceiver: () => void;
  onRemoveReceiver: () => void;
  /** 좌측(검색조건+All Receiver) 포커스 — F5 를 사용자 조회로 분기 (AS-IS Tx_Click E13) */
  onFocusAllArea: () => void;
  /** 우측(Sel Receiver) 포커스 — F5 마스터 조회 복귀 + F9 삭제 라우팅 */
  onFocusSelArea: () => void;
}

export const MailReceiverPanel = ({
  allGridRef,
  allGridFilterRef,
  selGridRef,
  selGridFilterRef,
  selEditTrackerRef,
  allReceivers,
  selReceivers,
  onSearchReceiver,
  onAddReceiver,
  onRemoveReceiver,
  onFocusAllArea,
  onFocusSelArea,
}: MailReceiverPanelProps) => {
  const { t } = useTranslation();

  const receiverSearchParams = useMailSetupStore(state => state.receiverSearchParams);
  const setReceiverSearchParams = useMailSetupStore(state => state.setReceiverSearchParams);
  const allReceiverColumns = useMailSetupStore(state => state.allReceiverColumns);
  const selReceiverColumns = useMailSetupStore(state => state.selReceiverColumns);

  // All Receiver 데이터 셀 더블클릭 → ▶ 와 동일한 이동 공통 경로 (AS-IS CellDoubleClick E14)
  const handleAllDoubleClick = (mouseEvent: MouseEvent) => {
    const grid = allGridRef.current;
    if (!grid) return;

    const hitTest = grid.hitTest(mouseEvent);
    if (hitTest.cellType !== CellType.Cell) return;

    onAddReceiver();
  };

  return (
    <div className={styles.receiverPanel}>
      {/* 좌측 클릭(검색 입력 포함) = All Receiver 포커스 — Find 가 사용자 조회로 분기 (E13) */}
      <div className={styles.receiverSide} onClickCapture={onFocusAllArea}>
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
            dblClick={handleAllDoubleClick}
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

      <div className={styles.receiverSide} onClickCapture={onFocusSelArea}>
        <div className={styles.receiverGrid}>
          <DataGrid<SelReceiverRow>
            gridRef={selGridRef}
            gridFilterRef={selGridFilterRef}
            editTrackerRef={selEditTrackerRef}
            itemsSource={selReceivers}
            staticColumns={selReceiverColumns}
            useSummaryTooltip={false}
          />
        </div>
      </div>
    </div>
  );
};
