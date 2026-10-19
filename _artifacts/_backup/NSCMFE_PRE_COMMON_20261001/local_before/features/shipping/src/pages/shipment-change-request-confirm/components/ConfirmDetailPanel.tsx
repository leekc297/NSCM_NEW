import commonStyles from '@foundation/styles/common-styles.module.scss';
import { FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import type { ConfirmDetail } from '../shipment-change-request-confirm.types';

interface Props {
  detail: ConfirmDetail;
  rejectReason: string;
  // rejectReason 입력 가능 여부 — 액션(Reject/SelfReject) 대상 행 선택 시에만 활성.
  rejectEnabled: boolean;
  onRejectReasonChange: (v: string) => void;
}

// design 01 §2 B1/B4 "Request Info" 디테일 폼 — 마스터 더블클릭 시 detail GET SP Tables[1] 바인딩.
//   8필드 전부 읽기전용(Request No/Title/Requestor/Req Dept/Approval/App Dept/Change Reason/Reason Detail),
//   rejectReason 만 입력(반려/자기반려 사유, 가드 MSG00181).
export const ConfirmDetailPanel = ({
  detail,
  rejectReason,
  rejectEnabled,
  onRejectReasonChange,
}: Props) => {
  const { t } = useTranslation();

  return (
    <Grid container spacing={1}>
      {/* Request No (읽기전용) */}
      <Grid size={4}>
        <FormItem
          className={commonStyles.formItem}
          // GAP-01: LBL01110='Revision' 오매핑 -> LBL00744='Request No'(실측).
          label={t('LBL00744', { defaultValue: 'Request No' })}
          labelAlign='right'
          render={() => <InputField fullWidth disabled value={detail.requestNo} />}
        />
      </Grid>

      {/* Title (읽기전용) */}
      <Grid size={4}>
        <FormItem
          className={commonStyles.formItem}
          label={t('LBL01125', { defaultValue: 'Title' })}
          labelAlign='right'
          render={() => <InputField fullWidth disabled value={detail.title} />}
        />
      </Grid>

      {/* Requestor (읽기전용) */}
      <Grid size={4}>
        <FormItem
          className={commonStyles.formItem}
          label={t('LBL01108', { defaultValue: 'Requestor' })}
          labelAlign='right'
          render={() => <InputField fullWidth disabled value={detail.requestor} />}
        />
      </Grid>

      {/* Requestor Dept Name (읽기전용) */}
      <Grid size={4}>
        <FormItem
          className={commonStyles.formItem}
          label={t('LBL01071', { defaultValue: 'Dept Name' })}
          labelAlign='right'
          render={() => <InputField fullWidth disabled value={detail.requestDeptName} />}
        />
      </Grid>

      {/* Approval (읽기전용) */}
      <Grid size={4}>
        <FormItem
          className={commonStyles.formItem}
          label={t('LBL01052', { defaultValue: 'Approval' })}
          labelAlign='right'
          render={() => <InputField fullWidth disabled value={detail.approval} />}
        />
      </Grid>

      {/* Approval Dept Name (읽기전용) */}
      <Grid size={4}>
        <FormItem
          className={commonStyles.formItem}
          label={t('LBL01071', { defaultValue: 'Dept Name' })}
          labelAlign='right'
          render={() => <InputField fullWidth disabled value={detail.appDeptName} />}
        />
      </Grid>

      {/* Change Reason (읽기전용) */}
      <Grid size={4}>
        <FormItem
          className={commonStyles.formItem}
          label={t('LBL01060', { defaultValue: 'Change Reason' })}
          labelAlign='right'
          render={() => <InputField fullWidth disabled value={detail.changeReason} />}
        />
      </Grid>

      {/* Reason Detail (읽기전용) */}
      <Grid size={8}>
        <FormItem
          className={commonStyles.formItem}
          label={t('LBL01104', { defaultValue: 'Reason Detail' })}
          labelAlign='right'
          render={() => <InputField fullWidth disabled value={detail.reasonDetail} />}
        />
      </Grid>

      {/* Reject Reason — 유일 입력 필드(반려/자기반려 사유, B4). 행 선택 전에는 비활성. */}
      <Grid size={12}>
        <FormItem
          className={commonStyles.formItem}
          // GAP-01: LBL01109='Result Type' 오매핑 -> LBL00628='Reject Reason'(실측).
          label={t('LBL00628', { defaultValue: 'Reject Reason' })}
          labelAlign='right'
          render={() => (
            <InputField
              fullWidth
              disabled={!rejectEnabled}
              value={rejectReason}
              onChange={e => onRejectReasonChange(e.target.value)}
            />
          )}
        />
      </Grid>
    </Grid>
  );
};
