import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import { attachRowNoHeader } from '@foundation/utils';
import { DataGrid, CustomDialog, ResultArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button } from '@shared/lges';

import { MENU_ID, SHEETS } from '../../mkt-fcst.constants';
import styles from '../../MktFcst.module.scss';

import { SSP_COMPARE_COLUMNS } from './mkt-fcst-modals.constants';

// ⭐ DMF0003 SspSyncComparePopUp (AS-IS DMF0003_SspSyncComparePopUp.cs).
//   트리거: 메인 grid CellDblClick (Div40 & MEASURE='MKT_FCST_RP' & 셀 동기화색[ATTR1 A/P], .cs L2628~2683)
//           → DMF0003_GET_MKT_FCST_COMPARE_POPUP 조회 → SSP↔MKT 비교 (read-only).
//   SP: sspCompare sheet SEARCH → DMF0003_GET_MKT_FCST_COMPARE_POPUP (8 IN + O_RC1).
export interface SspSyncCompareParams {
  divisionId: string;
  scmSiteId: string;
  projectCode: string;
  itemId: string;
  domExp: string;
  fcstType: string;
  incoterms: string;
  yyyymmdd: string;
}

interface SspSyncCompareModalProps {
  open: boolean;
  modalClose: () => void;
  params: SspSyncCompareParams | null;
}

export const SspSyncCompareModal = ({ open, modalClose, params }: SspSyncCompareModalProps) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.SSP_COMPARE>>>();
  // ResultArea 가 F4/헤더 필터 적용 후 실제 표시 건수를 "총 N건"에 반영하려면 이 ref 가 필요하다.
  const gridFilterRef = useRef<FlexGridFilter | undefined>();

  // useTabProcQuery 는 filters 참조가 바뀌면 캐시를 버리고 재조회한다. params 가
  // null 인 동안 fallback 객체를 매 렌더 새로 만들면 값이 그대로여도 참조가 계속
  // 바뀌므로 useMemo 로 참조를 params 에 고정한다.
  const filters = useMemo(
    () =>
      params ?? {
        divisionId: '',
        scmSiteId: '',
        projectCode: '',
        itemId: '',
        domExp: '',
        fcstType: '',
        incoterms: '',
        yyyymmdd: '',
      },
    [params]
  );

  const { data } = useTabProcQuery<MENU_ID, SHEETS.SSP_COMPARE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SSP_COMPARE,
    tabId: 'SspSyncCompareModal',
    filters,
    enabled: open && !!params,
  });

  const itemsSource = data?.o_rc1 ?? [];

  useEffect(() => {
    if (gridRef.current) attachRowNoHeader(gridRef.current, t('LBL00674', 'No'));
  }, [gridRef, t, itemsSource]);

  return (
    <CustomDialog
      size={1000}
      type='modaless'
      position='basic'
      open={open}
      handleClose={modalClose}
      // 컬럼 필터 팝업(FlexGridFilter)이 MuiDialog-container 밖에 append 돼 MUI FocusTrap 과
      // 충돌한다 — 필터 팝업의 Search 입력이 클릭/타이핑해도 반응 없어 보이는 원인. CustomDialog.tsx
      // 상단 주석(DMF0082 ExchangeRateModal) 과 동일 원인.
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00694', '_SSP Sync Compare')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.modalContentWrapper}>
          <div className={styles.modalGridWrapper}>
            <ResultArea
              title=''
              count={itemsSource.length}
              gridRef={gridRef}
              gridFilterRef={gridFilterRef}
            >
              <DataGrid<ResponseData<MENU_ID, SHEETS.SSP_COMPARE>>
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                isReadOnly
                staticColumns={SSP_COMPARE_COLUMNS}
                itemsSource={itemsSource}
              />
            </ResultArea>
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
