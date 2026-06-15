import { useState } from 'react';

import { CustomDialog } from '@shared/components';
import { useMessageStore } from '@shared/stores';

interface Props {
  open: boolean;
  onClose: () => void;
  popupType?: 'Request_PR' | 'Add_History' | 'View_PR';
  requestNo?: string;
  divisionId: string;
  projectCode?: string;
  itemId?: string;
  yyyymmdd?: string;
  planQty?: number;
}

// AS-IS DMF0003_PRPopup.cs (615 lines) — Purchase Request 생성
//   - 호출: Context Menu 우클릭 + Button click (dual entry)
//   - SP : DMF0003_GET_PRPOPUP (12 IN) + DMF0003_SAVE_PRPOPUP (20 IN, 596 lines SP body)
//   - POPUP_TYPE 분기: "Request_PR" / "Add_History" / "View_PR"
//   - 편집: STORAGE_PLANT_ID / SLOC / ITEM_DETAIL (Add_History 시 QTY 추가)
//   - SLOC 동적 바인딩: Plant 선택 변경 시 SLOC 재조회
//
// memory feedback_popup_asis_precision

export const PrModal = ({
  open, onClose,
  popupType = 'Request_PR',
  requestNo,
  divisionId: _divisionId,
  projectCode,
  itemId,
  yyyymmdd: _yyyymmdd,
  planQty,
}: Props) => {
  const setToast = useMessageStore.getState().setToast;
  const [saving, setSaving] = useState(false);

  const handleSave = () => {
    setSaving(true);
    void setToast({ message: 'PR 저장 중...', type: 'default' });
    // SP DMF0003_SAVE_PRPOPUP 호출 (20 IN — Phase 5 보강)
    setSaving(false);
    onClose();
  };

  const titleByType = {
    Request_PR: 'PR 신규 생성',
    Add_History: 'PR History 추가',
    View_PR: 'PR 조회',
  };

  return (
    <CustomDialog
      open={open}
      handleClose={onClose}
      handleSubmit={popupType === 'View_PR' ? undefined : handleSave}
      customHeaderTitle={titleByType[popupType] || 'Purchase Request'}
      size={1000}
      type='modal'
      position='basic'
      disableButtonCancel={saving}
      customContentArea={
        <div style={{ padding: 16 }}>
          <div>Request No: {requestNo ?? '신규'}</div>
          <div>Project: {projectCode ?? '-'} / Item: {itemId ?? '-'}</div>
          <div>Plan Qty: {planQty ?? 0}</div>
          {/* Phase 5 보강: form + grid + POPUP_TYPE 분기 */}
        </div>
      }
    />
  );
};
