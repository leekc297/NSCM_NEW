import { CellType, type FlexGrid as FlexGridType, type FormatItemEventArgs } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, DataGrid, SearchArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { CUTOFF_VER_TYPE, MENU_ID, MSG, SHEETS } from '../../business-plan.constants';
import type { MdfVersionRow } from '../../business-plan.types';
import styles from '../../BusinessPlan.module.scss';
import { callReplaceByCutoff } from '../../utils/business-plan.api';

interface Props {
  open: boolean;
  // applied=true 시 부모가 메인 재조회 (컷오프본 대체 반영)
  modalClose: (applied: boolean) => void;
  divisionId: string;
  // 부모(BusinessPlan.tsx)가 산출한 선택 M_ 범위 (미선택 = 조회기간 전체 — AS-IS L3422~3450)
  range: { from: string; to: string }; // yyyymm
}

// 버전 목록 grid 컬럼 (DMF0042_GET_DM_MDF_VERSION 커서 — 행 선택 = Replace 대상 버전)
const VERSION_COLUMNS = [
  { key: 'DIVISION_ID', header: 'Division', width: 80 },
  { key: 'VERSION_NO', header: 'Version No', width: 140 },
  { key: 'VERSION_DESCRIPTION', header: 'Description', width: 260 },
  { key: 'VERSION_TYPE', header: 'Type', width: 80 },
  { key: 'CREATED_BY', header: 'Created By', width: 110 },
  { key: 'CREATION_DATE', header: 'Creation Date', width: 140 },
];

// ⭐ Replace by Cutoff 모달 — AS-IS ReplaceByCutOffPopUp(562줄) 1:1: 버전 목록 조회
//   (DMF0042_GET_DM_MDF_VERSION, versionType='BP_M') → 버전 선택 → 기간(from/to) 확인 → Replace 실행
//   (DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF — createdBy BE주입). 권한 게이트 = 부모 hasButton('REPLACE').
export const ReplaceByCutoffModal = ({ open, modalClose, divisionId, range }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const gridRef = useRef<FlexGridType<MdfVersionRow>>(undefined);

  const [yyyymmFrom, setYyyymmFrom] = useState(range.from);
  const [yyyymmTo, setYyyymmTo] = useState(range.to);
  const [running, setRunning] = useState(false);
  const [appliedAny, setAppliedAny] = useState(false);

  useEffect(() => {
    if (open) {
      setYyyymmFrom(range.from);
      setYyyymmTo(range.to);
      setRunning(false);
      setAppliedAny(false);
    }
  }, [open, range]);

  const sesUserId = useSessionStore.getState().session.userId ?? '';
  const filters = useMemo(
    () => ({
      divisionId,
      versionDescription: '',
      versionType: CUTOFF_VER_TYPE, // 'BP_M' 고정 (AS-IS LoadDataDiv L3465)
      fromYyyymmdd: `${yyyymmFrom}01`,
      toYyyymmdd: `${yyyymmTo}31`,
      userId: sesUserId,
      mnuId: MENU_ID,
    }),
    [divisionId, yyyymmFrom, yyyymmTo, sesUserId]
  );
  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.MDF_VERSION>({
    menuId: MENU_ID,
    sheetName: SHEETS.MDF_VERSION,
    tabId: MENU_ID,
    filters,
    enabled: open,
  });
  const versionRows = useMemo<MdfVersionRow[]>(
    () => ((data as { data?: MdfVersionRow[] } | undefined)?.data ?? []),
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

  // ⭐ Replace 실행 — 선택 버전 필수 + confirm → SP 호출 (결과 passthrough)
  const handleReplace = async () => {
    if (running) return;
    const sel = gridRef.current?.selectedItems[0] as MdfVersionRow | undefined;
    const versionNo = sel ? String(sel.VERSION_NO ?? '') : '';
    if (!versionNo) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRED_COLUMN, '_필수 입력 컬럼이 없습니다.') });
      return;
    }
    const confirmed = await setAlert({
      type: 'confirm',
      content: `Replace by Cutoff (${divisionId} / ${versionNo} / ${yyyymmFrom}~${yyyymmTo})?`,
    });
    if (!confirmed) return;
    setRunning(true);
    void setToast({ message: t('LBL00665', '_Loading...'), type: 'default', duration: 3000 });
    try {
      const res = await callReplaceByCutoff({
        divisionId,
        versionType: CUTOFF_VER_TYPE,
        yyyymmFrom,
        yyyymmTo,
        versionNo,
      });
      if (!res.ok) {
        void setAlert({
          type: 'alert',
          content: res.message || t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.'),
        });
        return;
      }
      void setToast({ message: t(MSG.SAVED, '_성공적으로 저장되었습니다.'), type: 'success' });
      setAppliedAny(true);
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
      handleClose={() => modalClose(appliedAny)}
      disableButtonCancel
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>Replace by Cutoff</h2>
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
            <DataGrid<MdfVersionRow>
              gridRef={gridRef}
              itemsSource={versionRows}
              staticColumns={gridStaticColumns}
              autoGenerateColumns={false}
              allowSorting={false}
              selectionMode='Row'
            />
          </div>

          <div className={styles.modalButtonWrapper}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='Replace'
              disabled={running}
              onClick={() => void handleReplace()}
            />
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel='Close'
              onClick={() => modalClose(appliedAny)}
            />
          </div>
        </div>
      }
    />
  );
};
