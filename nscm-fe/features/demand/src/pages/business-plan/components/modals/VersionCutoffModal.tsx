import {
  CellType,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, DataGrid, SearchArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { CUTOFF_VER_TYPE, MENU_ID, MSG, SHEETS } from '../../business-plan.constants';
import type { CutoffVersionRow } from '../../business-plan.types';
import styles from '../../BusinessPlan.module.scss';
import { callCutoff } from '../../utils/business-plan.api';

interface Props {
  open: boolean;
  modalClose: () => void;
  divisionId: string;
  period: { from: string; to: string }; // yyyymm
}

// 버전 목록 grid 컬럼 (DMF0042_GET_DM_PLN_BP_CUTOFF_VERSION 커서 — 조회 전용)
const VERSION_COLUMNS = [
  { key: 'DIVISION_ID', header: 'Division', width: 80 },
  { key: 'VERSION_NO', header: 'Version No', width: 140 },
  { key: 'VERSION_DESCRIPTION', header: 'Description', width: 260 },
  { key: 'VERSION_TYPE', header: 'Type', width: 80 },
  { key: 'CREATED_BY', header: 'Created By', width: 110 },
  { key: 'CREATION_DATE', header: 'Creation Date', width: 140 },
];

// ⭐ Ver. Cutoff 모달 — AS-IS VersionCutOffPopUp(610줄) 1:1: 기존 버전 목록 조회
//   (DMF0042_GET_DM_PLN_BP_CUTOFF_VERSION, versionType='BP_M') + 설명 입력 + Cutoff 실행
//   (DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF — division 단일, createdBy BE주입).
//   완료 안내 = MSG00675 '[Division ID : {0}] {1}' (AS-IS 00151). 권한 게이트 = 부모 hasButton('CUTOFF').
export const VersionCutoffModal = ({ open, modalClose, divisionId, period }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const gridRef = useRef<FlexGridType<CutoffVersionRow>>(undefined);

  const [yyyymmFrom, setYyyymmFrom] = useState(period.from);
  const [yyyymmTo, setYyyymmTo] = useState(period.to);
  const [description, setDescription] = useState('');
  const [running, setRunning] = useState(false);

  useEffect(() => {
    if (open) {
      setYyyymmFrom(period.from);
      setYyyymmTo(period.to);
      setDescription('');
      setRunning(false);
    }
  }, [open, period]);

  const sesUserId = useSessionStore.getState().session.userId ?? '';
  const filters = useMemo(
    () => ({
      divisionId,
      yyyymmFrom,
      yyyymmTo,
      versionType: CUTOFF_VER_TYPE, // 'BP_M' 고정 (AS-IS LoadDataDiv L2857)
      userId: sesUserId,
      mnuId: MENU_ID,
    }),
    [divisionId, yyyymmFrom, yyyymmTo, sesUserId]
  );
  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.CUTOFF_VERSION>({
    menuId: MENU_ID,
    sheetName: SHEETS.CUTOFF_VERSION,
    tabId: MENU_ID,
    filters,
    enabled: open,
  });
  const versionRows = useMemo<CutoffVersionRow[]>(
    () => (data as { data?: CutoffVersionRow[] } | undefined)?.data ?? [],
    [data]
  );

  const gridStaticColumns = useMemo<RawFlexGridColumnConfig[]>(
    () =>
      VERSION_COLUMNS.map(
        (c): RawFlexGridColumnConfig => ({
          colNm: c.key,
          colLblNm: c.header,
          colWth: c.width,
          fixed: false,
          visible: true,
          display: true,
          inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
        })
      ),
    []
  );

  // No. 코너 헤더 (hook #108)
  useEffect(() => {
    const g = gridRef.current;
    if (!g || !g.columnHeaders) return;
    const formatHandler = (_s: unknown, e: FormatItemEventArgs) => {
      if (e.panel.cellType === CellType.TopLeft) {
        if (e.panel.getCellData(0, 0, false) !== 'No.') e.panel.setCellData(0, 0, 'No.');
        e.cell.style.textAlign = 'center';
      }
    };
    g.formatItem.addHandler(formatHandler);
    return () => {
      try {
        g.formatItem?.removeHandler(formatHandler);
      } catch {
        /* unmount race */
      }
    };
  }, [open, versionRows]);

  // ⭐ Cutoff 실행 — confirm 후 SP 호출 (division 단일. 결과 passthrough + MSG00675 완료 안내)
  const handleCutoff = async () => {
    if (running) return;
    const confirmed = await setAlert({
      type: 'confirm',
      content: `Manual Cutoff (${divisionId})?`,
    });
    if (!confirmed) return;
    setRunning(true);
    void setToast({ message: t('LBL00665', '_Loading...'), type: 'default', duration: 3000 });
    try {
      const res = await callCutoff(divisionId, description.trim(), CUTOFF_VER_TYPE);
      if (!res.ok) {
        void setAlert({
          type: 'alert',
          content: res.message || t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.'),
        });
        return;
      }
      // 완료 안내 — MSG00675 'Manual Cutoff가 완료되었습니다.[Division ID : {0}] {1}' (AS-IS 00151)
      void setAlert({
        type: 'alert',
        content: t(MSG.CUTOFF_DONE, '_Manual Cutoff가 완료되었습니다.[Division ID : {0}] {1}')
          .replace('{0}', divisionId)
          .replace('{1}', res.message ?? ''),
      });
      setDescription('');
      void refetch?.();
    } finally {
      setRunning(false);
    }
  };

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      size={900}
      handleClose={modalClose}
      disableButtonCancel
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>Ver. Cutoff</h2>
        </div>
      }
      customContentArea={
        <div className={styles.modalContentWrapper}>
          <SearchArea
            searchButtonLabel={t('LBL00664', 'Search')}
            onSearch={() => void refetch?.()}
            conditions={
              <>
                <Grid size={4}>
                  <FormItem
                    label={t('LBL00663', 'Div')}
                    labelAlign='right'
                    render={() => <InputField value={divisionId} disabled />}
                  />
                </Grid>
                <Grid size={8}>
                  <FormItem
                    label={t('LBL00013', 'Period')}
                    labelAlign='right'
                    render={() => (
                      <div className={styles.modalFieldRow}>
                        <InputField
                          value={yyyymmFrom}
                          onChange={e => setYyyymmFrom(e.target.value)}
                          placeholder='YYYYMM'
                        />
                        <span>~</span>
                        <InputField
                          value={yyyymmTo}
                          onChange={e => setYyyymmTo(e.target.value)}
                          placeholder='YYYYMM'
                        />
                      </div>
                    )}
                  />
                </Grid>
              </>
            }
          />

          <div className={styles.modalGridWrapper}>
            <DataGrid<CutoffVersionRow>
              gridRef={gridRef}
              itemsSource={versionRows}
              staticColumns={gridStaticColumns}
              autoGenerateColumns={false}
              allowSorting={false}
            />
          </div>

          <div className={styles.modalFieldRow}>
            <span>Description</span>
            <InputField
              value={description}
              onChange={e => setDescription(e.target.value)}
              placeholder='Version description'
            />
          </div>

          <div className={styles.modalButtonWrapper}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='Cutoff'
              disabled={running}
              onClick={() => void handleCutoff()}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Close'
              onClick={modalClose}
            />
          </div>
        </div>
      }
    />
  );
};
