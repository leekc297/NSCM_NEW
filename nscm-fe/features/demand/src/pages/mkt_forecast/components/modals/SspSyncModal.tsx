import { CustomDialog } from '@shared/components';

interface SspSyncRow {
  MEASURE: string;
  END_CUSTOMER: string;
  SCM_SITE_ID: string;
  ITEM_ID: string;
  INCOTERMS: string;
  FCST_TYPE: string;
  DOM_EXP: string;
  YYYYMMDD: string;
  SYNC_QTY: number;
  DP_QTY: number;
}

interface Props {
  open: boolean;
  onClose: () => void;
  rows?: SspSyncRow[];
  divisionId: string;
}

// AS-IS DMF0003_SspSyncPopUp.cs (184 lines) — SSP 동기화
//   - 호출: Context Menu (동기화 행)
//   - SP : 없음 (부모 SP `DMF0003_GET_MKT_FCST_COMPARE_POPUP` 결과의 Tables[1] 직접 전달)
//   - 이력: 2020-10-22 추가 → 2020-10-29 원복 → 2020-12-28 재활성화 (색상처리, save 함수)
//   - UI : MEASURE 컬럼 기준 SmartColMerge (행 그룹화)
//   - Read-only grid (Sync Qty / DP Qty 비교)

export const SspSyncModal = ({
  open, onClose,
  rows,
  divisionId: _divisionId,
}: Props) => {
  return (
    <CustomDialog
      open={open}
      handleClose={onClose}
      customHeaderTitle='SSP 동기화 (Sync vs DP Qty)'
      size={1000}
      type='modal'
      position='basic'
      disableButtonCancel
      customContentArea={
        <div style={{ padding: 16 }}>
          <div>동기화 데이터: {rows?.length ?? 0}건</div>
          {/* Phase 5 보강: SmartColMerge grid (MEASURE 기준 병합) */}
        </div>
      }
    />
  );
};
