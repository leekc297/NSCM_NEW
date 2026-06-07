import { CustomDialog } from '@shared/components';

interface Props {
  open: boolean;
  onClose: () => void;
  requestNo?: string;
  divisionId: string;
  projectCode?: string;
  itemId?: string;
}

// AS-IS DMF0003_PRHistoryPopup.cs (296 lines) — PR 변경 이력 조회
//   - 호출: Context Menu
//   - SP : DMF0003_GET_PR_HISTORY_POPUP (12 IN + 2 OUT)
//   - UI : Read-only grid (Request No / Date / By / Qty / Item Detail)
//   - Row click 시 PR Header 표시 (하단 텍스트박스)

export const PrHistoryModal = ({
  open, onClose,
  requestNo,
  divisionId: _divisionId,
  projectCode,
  itemId,
}: Props) => {
  return (
    <CustomDialog
      open={open}
      onClose={onClose}
      title='PR 변경 이력'
      width={900}
      height={500}
      buttons={[{ label: '닫기', onClick: onClose }]}
    >
      <div style={{ padding: 16 }}>
        <div>Request No: {requestNo ?? '-'}</div>
        <div>Project: {projectCode ?? '-'} / Item: {itemId ?? '-'}</div>
        {/* Phase 5 보강: PR history grid (read-only) */}
      </div>
    </CustomDialog>
  );
};
