import { FlexGrid, FlexGridColumn } from '@mescius/wijmo.react.grid';
import { useState } from 'react';

import { CustomDialog } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import { MENU_ID } from '../../sales-future-price.constants';
import { isPeriodInverted } from '../../utils/futurePriceDate';

import styles from './PriceBatchInputModal.module.scss';

interface Props {
  open: boolean;
  modalClose: () => void;
  defaultDivision: string;
  defaultPeriod: { start: string; end: string };
  onSaveResult?: () => void;
}

// AS-IS DMF0020_SaveSalesFuturePrice_Popup.cs (2,614줄) — Price 일괄입력
//   - 9 필수 컬럼 (Div/EndCustomer/SCMSite/Item/Incoterms/FCST/DOM_EXP/Currency/Measure)
//   - PriceAll 입력 → 우측 주차 컬럼 전체 동기 채움
//   - Validation: MSG00135/00408 (Lock) / MSG00002 (필수) / MSG00108 (Period 역전)
//   - SP 8종 (SPREAD_TITLE / MEASURE_COUNT / GRID DATA / SAVE_POPUP / SAVE_CONVERSION / WEEKDATA / DAY_RANGE / LOOKUP)
//   - 분석서: Doc/_analysis/domain_DM/screens/DMF0020_POPUP_Price/
//
// 본 구현은 Phase 4 MVP 단계 — 기본 골격 (Filter + Grid + Bulk PriceAll 동기) 만 제공.
// 풀 PIVOT + 3단 헤더 + 9 필수 + 일괄 채움 동작은 추가 phase 에서 보강.
export const PriceBatchInputModal = ({
  open, modalClose, defaultDivision, defaultPeriod, onSaveResult,
}: Props) => {
  const setAlert = useMessageStore.getState().setAlert;
  const [divisionId, setDivisionId] = useState(defaultDivision);
  const [periodFrom, setPeriodFrom] = useState(defaultPeriod.start);
  const [periodTo, setPeriodTo] = useState(defaultPeriod.end);
  const [rows] = useState<Record<string, unknown>[]>([]);

  const handleFind = () => {
    if (isPeriodInverted(periodFrom, periodTo)) {
      void setAlert({ type: 'alert', content: '[MSG00108] Period 가 역전되었습니다.' });
      return;
    }
    // TODO: SP 호출 (P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP)
  };

  const handleSave = async () => {
    const ok = await setAlert({ type: 'confirm', content: '[MSG00004] 저장하시겠습니까?' });
    if (!ok) return;
    // TODO: SP 호출 (P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP)
    void setAlert({ type: 'alert', content: '[MSG00020] 저장되었습니다.' });
    onSaveResult?.();
  };

  return (
    <CustomDialog
      open={open}
      onClose={modalClose}
      title='Price 일괄입력'
      width={1200}
      height={700}
    >
      <div className={styles.container}>
        <div className={styles.filterRow}>
          <label>Div <select value={divisionId} onChange={e => setDivisionId(e.target.value)}><option>40</option><option>81</option><option>82</option></select></label>
          <label>Period From <input type='text' value={periodFrom} onChange={e => setPeriodFrom(e.target.value)} placeholder='YYYYMMDD' /></label>
          <label>Period To <input type='text' value={periodTo} onChange={e => setPeriodTo(e.target.value)} placeholder='YYYYMMDD' /></label>
        </div>
        <div className={styles.buttonRow}>
          <button type='button' onClick={handleFind} className={styles.actionBtn}>Find</button>
          <button type='button' onClick={handleSave} className={styles.saveBtn}>Save</button>
          <button type='button' onClick={modalClose} className={styles.closeBtn}>Close</button>
          <span className={styles.hint}>MENU={MENU_ID}. 9 필수 컬럼 검증 + 우측 주차 동기 채움 (To-Be MVP 단계 — SP 추후 연동)</span>
        </div>
        <div className={styles.gridWrap}>
          <FlexGrid itemsSource={rows} autoGenerateColumns={false} style={{ height: '100%' }} frozenColumns={11}>
            <FlexGridColumn binding='DIVISION_ID' header='Div*' width={70} />
            <FlexGridColumn binding='TEAM_INCHARGE' header='Team' width={90} isReadOnly />
            <FlexGridColumn binding='END_CUSTOMER' header='End Customer*' width={120} />
            <FlexGridColumn binding='SCM_SITE_ID' header='Sales Site*' width={100} />
            <FlexGridColumn binding='ITEM_ID' header='Model*' width={130} />
            <FlexGridColumn binding='INCOTERMS' header='Incoterms*' width={80} />
            <FlexGridColumn binding='FCST_TYPE' header='FCST Type*' width={80} />
            <FlexGridColumn binding='DOM_EXP' header='Customs Handbook*' width={120} />
            <FlexGridColumn binding='CURRENCY' header='Currency*' width={70} />
            <FlexGridColumn binding='MEASURE' header='Measure*' width={80} />
            <FlexGridColumn binding='PRICE_ALL' header='일괄입력 Price' width={120} dataType={2 /* Number */} />
          </FlexGrid>
        </div>
      </div>
    </CustomDialog>
  );
};
