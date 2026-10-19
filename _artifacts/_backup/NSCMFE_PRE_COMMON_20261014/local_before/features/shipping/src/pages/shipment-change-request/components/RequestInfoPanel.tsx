import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { LBL, META_COMBO } from '../shipment-change-request.constants';
import type { RequestInfo } from '../shipment-change-request.types';

interface Props {
  requestInfo: RequestInfo;
  disabled: boolean; // 편집모드 아니면 폼 비활성
  onChange: (p: Partial<RequestInfo>) => void;
  onApprovalSearch: () => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// design 01 §1 panel1 "Request Info" — 변경요청 완료(BtnChangeRe) 시 필수 4항목(Title/Approval/
//   ChangeReason/ReasonDetail, R14 checkRequired). Requestor/Dept 는 세션 읽기전용. RequestNo hidden(R5).
export const RequestInfoPanel = ({ requestInfo, disabled, onChange, onApprovalSearch }: Props) => {
  const { t } = useTranslation();
  // Change Reason* — CHANGE_REASON_CODE_ALL(CMBO_SQL, design 03 §1.3-A / 01 §1).
  const [changeReasons] = useTabComboQueries({ filters: [META_COMBO.CHANGE_REASON_CODE] });
  const reasonOptions = (changeReasons ?? []).map(r => ({
    label: str(r.NAME) || str(r.CODE),
    value: str(r.CODE),
  }));

  return (
    <Grid container spacing={1}>
      {/* Title* */}
      <Grid size={4}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.TITLE, '_Title')}
          labelAlign='right'
          required
          render={() => (
            <InputField
              fullWidth
              disabled={disabled}
              value={requestInfo.title}
              onChange={e => onChange({ title: e.target.value })}
            />
          )}
        />
      </Grid>

      {/* Requestor (읽기전용, 세션) */}
      <Grid size={4}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.REQUESTOR, '_Requestor')}
          labelAlign='right'
          render={() => <InputField fullWidth disabled value={requestInfo.requestor} />}
        />
      </Grid>

      {/* Requestor Dept Name (읽기전용) */}
      <Grid size={4}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.DEPT_NAME, '_Dept Name')}
          labelAlign='right'
          render={() => <InputField fullWidth disabled value={requestInfo.requestDeptName} />}
        />
      </Grid>

      {/* Approval* — btnApprovalUser 팝업(SSP0002_UserInfoPopup)으로 채움, 읽기전용. */}
      <Grid size={4}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.APPROVAL, '_Approval')}
          labelAlign='right'
          required
          render={() => (
            <InputField
              fullWidth
              disabled
              className={commonStyles.popupSearchField}
              value={requestInfo.approval}
              InputProps={{
                endAdornment: (
                  <Button
                    appearance='outlined'
                    priority='normal'
                    disabled={disabled}
                    iconComponent={
                      <FunctionSearchIcon appearance='lined' onClick={onApprovalSearch} />
                    }
                  />
                ),
              }}
            />
          )}
        />
      </Grid>

      {/* Approval Dept Name (읽기전용) */}
      <Grid size={4}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.DEPT_NAME, '_Dept Name')}
          labelAlign='right'
          render={() => <InputField fullWidth disabled value={requestInfo.appDeptName} />}
        />
      </Grid>

      {/* Change Reason* — CHANGE_REASON_CODE_ALL 콤보 */}
      <Grid size={4}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.CHANGE_REASON, '_Change Reason')}
          labelAlign='right'
          required
          render={() => (
            <CustomDropdown
              value={requestInfo.changeReason}
              options={reasonOptions}
              disabled={disabled}
              onChange={(_, picked) => onChange({ changeReason: String(picked ?? '') })}
            />
          )}
        />
      </Grid>

      {/* Reason Detail* */}
      <Grid size={8}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.REASON_DETAIL, '_Reason Detail')}
          labelAlign='right'
          required
          render={() => (
            <InputField
              fullWidth
              disabled={disabled}
              value={requestInfo.reasonDetail}
              onChange={e => onChange({ reasonDetail: e.target.value })}
            />
          )}
        />
      </Grid>
    </Grid>
  );
};
