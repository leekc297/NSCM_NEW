import { CustomDialog } from '@shared/components';

interface Props {
  open: boolean;
  modalClose: () => void;
  defaultDivision: string;
}

// AS-IS DMF0020_SalesPriceTemplatePopup — Phase 4 MVP 단계 stub.
// 분석서: Doc/_analysis/domain_DM/screens/DMF0020_SalesFuturePrice_POPUP_DMF0020_SalesPriceTemplate/
// 후속 phase 에서 보강 — Sales Price Template (ESS Battery div=81 전용) Excel Form
// AS-IS L205, L2581 — btnTemplate.Visible = (div==81)
export const SalesPriceTemplateModal = ({ open, modalClose, defaultDivision }: Props) => (
  <CustomDialog
    open={open}
    handleClose={modalClose}
    customHeaderTitle='Sales Price Template (Excel Form)'
    size={600}
    type='modal'
    position='basic'
    disableButtonCancel
    customContentArea={
      <div style={{ padding: 16 }}>
        <p>Sales Price Template — ESS Battery (div=81) 전용 Excel Form (Phase 4 MVP — 후속 보강)</p>
        <ul>
          <li>Division: {defaultDivision}</li>
        </ul>
      </div>
    }
  />
);
