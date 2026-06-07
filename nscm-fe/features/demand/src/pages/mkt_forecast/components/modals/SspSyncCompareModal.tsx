import { CustomDialog } from '@shared/components';

interface SspCompareRow {
  END_CUSTOMER: string;
  SCM_SITE_ID: string;
  ITEM_ID: string;
  INCOTERMS: string;
  FCST_TYPE: string;
  MEASURE: string;
  CONFIRM_ID: string;
  SO_NO: string;
  QTY: number;
  RESULT_QTY: number;
}

interface Props {
  open: boolean;
  onClose: () => void;
  rows?: SspCompareRow[];
  divisionId: string;
}

// AS-IS DMF0003_SspSyncComparePopUp.cs (194 lines) — SSP 동기화 상세 비교
//   - 호출: SspSync 행 Double-Click (drill-down)
//   - SP : 없음 (부모 SP 결과의 Tables[2] 직접 전달)
//   - UI : SO No / Qty / Shipment Result Qty 상세 비교
//   - SmartColMerge 동일 패턴

export const SspSyncCompareModal = ({
  open, onClose,
  rows,
  divisionId: _divisionId,
}: Props) => {
  return (
    <CustomDialog
      open={open}
      onClose={onClose}
      title='SSP 동기화 상세 비교 (SO / Shipment Result)'
      width={1200}
      height={600}
      buttons={[{ label: '닫기', onClick: onClose }]}
    >
      <div style={{ padding: 16 }}>
        <div>비교 데이터: {rows?.length ?? 0}건</div>
        {/* Phase 5 보강: SmartColMerge grid */}
      </div>
    </CustomDialog>
  );
};
