import { CustomDialog } from '@shared/components';

interface Props {
  open: boolean;
  modalClose: () => void;
  defaultDivision: string;
  defaultPeriod: { start: string; end: string };
}

// AS-IS DMF0020_SalesPriceRangePopUp — Phase 4 MVP 단계 stub.
// 분석서: Doc/_analysis/domain_DM/screens/DMF0020_SalesFuturePrice_POPUP_DMF0020_SalesPriceRange/
// 후속 phase 에서 보강 — Sales Price 적용 기간 범위 설정 + SAVE_PRICE_PERIOD SP 호출
export const SalesPriceRangeModal = ({ open, modalClose, defaultDivision, defaultPeriod }: Props) => (
  <CustomDialog
    open={open}
    handleClose={modalClose}
    customHeaderTitle='Sales Price Range'
    size={600}
    type='modal'
    position='basic'
    disableButtonCancel
    customContentArea={
      <div style={{ padding: 16 }}>
        <p>Sales Price 적용 기간 범위 설정 (Phase 4 MVP — 후속 보강)</p>
        <ul>
          <li>Division: {defaultDivision}</li>
          <li>Period: {defaultPeriod.start} ~ {defaultPeriod.end}</li>
        </ul>
      </div>
    }
  />
);
