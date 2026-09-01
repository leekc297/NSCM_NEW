import type { FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useRef, useState } from 'react';

import { DataGrid, CustomDialog, SearchArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { MENU_ID, SHEETS } from '../../mkt-fcst.constants';
import styles from '../../MktFcst.module.scss';
import { toCellStr } from '../../utils/mkt-fcst.prContext';

import { PR_HISTORY_COLUMNS } from './mkt-fcst-modals.constants';

// ⭐ DMF0003 PRHistoryPopup (AS-IS DMF0003_PRHistoryPopup.cs).
//   트리거: 메인 grid 우클릭 contextMenu View_History (.cs L5739 — BNPIn measure + D_ 단일 셀).
//   GET: prHistory sheet SEARCH → DMF0003_GET_PR_HISTORY_POPUP (13 IN + O_RC1 grid / O_RC2 header).
//   ⭐ 격차③ (2026-07-03) — AS-IS 헤더 5필드(SetChangeRequestInfo L265~272: Project Code /
//     YYYY-MM-DD / Model / Item Name / PR Header) + 행 클릭 시 클릭행의 숨김 PR_HEADER 표시(L275~293).
export interface PrHistoryParams {
  divisionId: string;
  projectCode: string;
  scmSiteId: string;
  itemId: string;
  domExp: string;
  fcstType: string;
  incoterms: string;
  plantSiteId: string;
  yyyymmdd: string;
  planQty: string;
}

interface PrHistoryModalProps {
  open: boolean;
  modalClose: () => void;
  params: PrHistoryParams | null;
}

export const PrHistoryModal = ({ open, modalClose, params }: PrHistoryModalProps) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.PR_HISTORY>>>();
  const setAlert = useMessageStore.getState().setAlert;

  // 행 클릭 시 선택행의 PR_HEADER 표시 (AS-IS L275~293 — 초기값 = O_RC2 헤더의 PR_HEADER).
  const [selectedPrHeader, setSelectedPrHeader] = useState<string | null>(null);

  const filters = {
    popupType: 'View_History',
    divisionId: params?.divisionId ?? '',
    requestNo: '',
    projectCode: params?.projectCode ?? '',
    scmSiteId: params?.scmSiteId ?? '',
    itemId: params?.itemId ?? '',
    domExp: params?.domExp ?? '',
    fcstType: params?.fcstType ?? '',
    incoterms: params?.incoterms ?? '',
    plantSiteId: params?.plantSiteId ?? '',
    yyyymmdd: params?.yyyymmdd ?? '',
    planQty: params?.planQty ?? '',
  };

  const { data } = useTabProcQuery<MENU_ID, SHEETS.PR_HISTORY>({
    menuId: MENU_ID,
    sheetName: SHEETS.PR_HISTORY,
    tabId: 'PrHistoryModal',
    filters,
    enabled: open && !!params,
  });

  const rows = data?.o_rc1 ?? [];
  const header = data?.o_rc2?.[0] as Record<string, unknown> | undefined;

  // 이력 0건 → 안내 후 닫기 (AS-IS SP ERR_MSG 'HISTORY가 존재하지 않습니다', SP body L58).
  useEffect(() => {
    if (open && params && data && rows.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00652', '_No history found.') });
      modalClose();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [data, open]);

  // 재오픈/재조회 시 선택 PR_HEADER 초기화.
  useEffect(() => {
    setSelectedPrHeader(null);
  }, [open, data]);

  // ⭐ 행 클릭 → 클릭행의 숨김 PR_HEADER 를 하단 필드에 표시 (AS-IS CellClick L275~293).
  useEffect(() => {
    const g = gridRef.current;
    if (!g || !open) return;
    const onSelection = () => {
      const item = g.selectedItems?.[0] as Record<string, unknown> | undefined;
      if (item) setSelectedPrHeader(toCellStr(item.PR_HEADER));
    };
    g.selectionChanged.addHandler(onSelection);
    return () => {
      try {
        g.selectionChanged?.removeHandler(onSelection);
      } catch {
        /* unmount race */
      }
    };
  }, [open, rows.length]);

  const headerStr = (k: string) => toCellStr(header?.[k]);

  return (
    <CustomDialog
      size={1000}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00700', '_PR History')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.modalContentWrapper}>
          {/* ⭐ 격차③ — 헤더 5필드 (O_RC2, 표시 전용): Project Code / YYYY-MM-DD / Model / Item Name / PR Header */}
          <SearchArea
            conditions={
              <>
                <Grid size={3}>
                  <FormItem
                    label={t('LBL00748', '_Project Code')}
                    labelAlign='right'
                    render={() => (
                      <InputField fullWidth disabled value={headerStr('PROJECT_CODE')} />
                    )}
                  />
                </Grid>
                <Grid size={3}>
                  <FormItem
                    label={t('LBL00749', '_YYYY-MM-DD')}
                    labelAlign='right'
                    render={() => <InputField fullWidth disabled value={headerStr('YYYYMMDD')} />}
                  />
                </Grid>
                <Grid size={3}>
                  <FormItem
                    label={t('LBL00750', '_Model')}
                    labelAlign='right'
                    render={() => <InputField fullWidth disabled value={headerStr('ITEM_ID')} />}
                  />
                </Grid>
                <Grid size={3}>
                  <FormItem
                    label={t('LBL00751', '_Item Name')}
                    labelAlign='right'
                    render={() => <InputField fullWidth disabled value={headerStr('ITEM_NAME')} />}
                  />
                </Grid>
                <Grid size={12}>
                  <FormItem
                    label={t('LBL00697', '_PR Header')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        disabled
                        value={selectedPrHeader ?? headerStr('PR_HEADER')}
                      />
                    )}
                  />
                </Grid>
              </>
            }
          />
          <div className={styles.modalGridWrapper}>
            <DataGrid<ResponseData<MENU_ID, SHEETS.PR_HISTORY>>
              gridRef={gridRef}
              isReadOnly
              staticColumns={PR_HISTORY_COLUMNS}
              itemsSource={rows}
            />
          </div>
          <div className={styles.modalButtonWrapper}>
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
