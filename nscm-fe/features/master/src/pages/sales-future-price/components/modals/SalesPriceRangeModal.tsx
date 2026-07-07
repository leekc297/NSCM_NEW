import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import { useEffect, useRef } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, DataGrid } from '@shared/components';
import { Button } from '@shared/lges';

import styles from './SalesPriceRangeModal.module.scss';

// AS-IS DMF0020_SalesPriceRangePopUp (Title 'Range Rate', 907×324 — 분석서 v6.5)
//   저장 후 SAVE SP(DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL) 의 O_RC1 이 반환하는
//   "입력 Price 가 주변 주차 대비 Range Rate(LOOKUP SALES_PRICE_RANGE_RATE 배율) 초과" 리스트를 표시.
//   AS-IS SaveData L1939: ds.Tables[2].Rows.Count > 0 → popup.LoadData(ds.Tables[2]) → ShowDialog.
//   표준: CustomDialog + 표준 header + gridWrapper(read-only DataGrid) + buttonWrapper(Close).
//   커서 컬럼(SP W_RETURN): V_ROWNUM / END_CUSTOMER / PROJECT_CODE / SCM_SITE_ID / ITEM_ID / INCOTERMS /
//   FCST_TYPE / CURRENCY / DIVISION_ID / PLANT_SITE_ID / MEASURE / DOM_EXP /
//   CH_YYYYMMDD·CH_PRICE(입력) / ST_YYYYMMDD·ST_PRICE(기준 인접 주차).
export interface SalesPriceRangeRow {
  V_ROWNUM?: number | string;
  END_CUSTOMER?: string;
  PROJECT_CODE?: string;
  SCM_SITE_ID?: string;
  ITEM_ID?: string;
  INCOTERMS?: string;
  FCST_TYPE?: string;
  CURRENCY?: string;
  DIVISION_ID?: string;
  PLANT_SITE_ID?: string;
  MEASURE?: string;
  DOM_EXP?: string;
  CH_YYYYMMDD?: string;
  CH_PRICE?: number | string;
  ST_YYYYMMDD?: string;
  ST_PRICE?: number | string;
}

interface Props {
  open: boolean;
  modalClose: () => void;
  rows: SalesPriceRangeRow[];
}

const RANGE_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'DIVISION_ID', colLblNm: 'Div.', colWth: 60, horzAlgnCd: 'C' },
  { colNm: 'END_CUSTOMER', colLblNm: 'End Customer', colWth: 120 },
  { colNm: 'PROJECT_CODE', colLblNm: 'Project Code', colWth: 110 },
  { colNm: 'SCM_SITE_ID', colLblNm: 'Sales Site', colWth: 140 },
  { colNm: 'ITEM_ID', colLblNm: 'Model', colWth: 150 },
  { colNm: 'INCOTERMS', colLblNm: 'Incoterms', colWth: 80, horzAlgnCd: 'C' },
  { colNm: 'FCST_TYPE', colLblNm: 'FCST Type', colWth: 90, horzAlgnCd: 'C' },
  { colNm: 'DOM_EXP', colLblNm: 'Customs Handbook', colWth: 110, horzAlgnCd: 'C' },
  { colNm: 'CURRENCY', colLblNm: 'Currency', colWth: 80, horzAlgnCd: 'C' },
  { colNm: 'CH_YYYYMMDD', colLblNm: 'Input Week', colWth: 100, horzAlgnCd: 'C' },
  { colNm: 'CH_PRICE', colLblNm: 'Input Price', colWth: 110, horzAlgnCd: 'R' },
  { colNm: 'ST_YYYYMMDD', colLblNm: 'Near Week', colWth: 100, horzAlgnCd: 'C' },
  { colNm: 'ST_PRICE', colLblNm: 'Near Price', colWth: 110, horzAlgnCd: 'R' },
].map(c => ({
  ...c,
  fixed: false,
  visible: true,
  display: true,
  inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
})) as RawFlexGridColumnConfig[];

export const SalesPriceRangeModal = ({ open, modalClose, rows }: Props) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGridType<SalesPriceRangeRow> | null>(null);

  // ⭐ #70 — DataGrid `initialized` deprecated → useEffect + gridRef. read-only 고정.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    g.isReadOnly = true;
  }, [rows]);

  return (
    <CustomDialog
      open={open}
      size={1200}
      type='modal'
      position='basic'
      handleClose={modalClose}
      disableButtonCancel
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>Range Rate</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContent}>
          {/* 안내 — 입력가가 인접 주차 기준가 대비 허용 배율(Range Rate) 초과 (저장은 완료된 상태, AS-IS 동일) */}
          <div className={styles.notice}>
            {t(
              'MSG00619',
              '_입력한 Price 가 인접 주차 대비 Range Rate 를 초과했습니다. 아래 내역을 확인하세요. (저장은 완료됨)'
            )}
          </div>

          {/* Grid — SAVE SP O_RC1 초과 리스트 (read-only) */}
          <div className={styles.gridWrapper}>
            <DataGrid
              gridRef={gridRef as never}
              itemsSource={rows as unknown as WijmoRowItem[]}
              staticColumns={RANGE_COLUMNS}
              autoGenerateColumns={false}
              className={styles.grid}
            />
          </div>

          {/* Action — 표준 buttonWrapper */}
          <div className={styles.buttonWrapper}>
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('LBL00627', 'Close')}
              onClick={modalClose}
            />
          </div>
        </div>
      }
    />
  );
};
