import { useState } from 'react';

import { CustomDialog } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import type { MktFcstRow } from '../../mkt-forecast-master.types';

interface Props {
  open: boolean;
  onClose: () => void;
  selectedRows?: MktFcstRow[];
  divisionId: string;
}

// AS-IS DMF0003_MatsterChgPopup.cs (891 lines) — Incoterms 일괄 변경
//   - 호출: DMF0003_1_MktFcst.cs L5609 btnIncotermsChg_Click
//   - SP : DM.DMF0000_GET_MASTER_CHG_POPUP (Find) + DM.DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE (Save)
//   - UI : Multi-select grid + New Incoterms/FcstType/DOM_EXP/PlantSite 편집 컬럼
//   - 권한: Division==40 시 NewDomExp 비활성
//   - Validation: fnValidation2 (중복 저장 방지) + fnValidation (데이터 일관성)
//
// memory feedback_popup_asis_precision — CustomDialog + SCSS module + setAlert/confirm

export const MasterChgModal = ({ open, onClose, selectedRows: _selectedRows, divisionId: _divisionId }: Props) => {
  const setToast = useMessageStore.getState().setToast;
  const [saving, setSaving] = useState(false);

  const handleSave = async () => {
    setSaving(true);
    void setToast({ message: 'Master Change 저장 중...', type: 'default' });
    // SP DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE 호출 (13 IN — Phase 5 보강)
    setSaving(false);
    onClose();
  };

  return (
    <CustomDialog
      open={open}
      onClose={onClose}
      title='Incoterms 일괄변경 (Master Change)'
      width={1200}
      height={600}
      buttons={[
        { label: '저장', onClick: handleSave, disabled: saving },
        { label: '닫기', onClick: onClose },
      ]}
    >
      <div style={{ padding: 16 }}>
        <div>선택된 행: {_selectedRows?.length ?? 0}건</div>
        <div>편집 가능 컬럼: New Incoterms / New FCST Type / New DOM_EXP / New Plant Site</div>
        {/* Phase 5 보강: grid + form 작성 */}
      </div>
    </CustomDialog>
  );
};
