import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Box, Grid } from '@shared/mui';

import { LBL, META_COMBO } from '../shipment-change-request.constants';
import type { RequestInfo } from '../shipment-change-request.types';

interface Props {
  requestInfo: RequestInfo;
  // EDIT 권한 축 — 편집모드 토글이 아니다(AS-IS SwitchLock 미이식, convert-core §2.4). 권한이 없으면 폼 비활성.
  canEdit: boolean;
  onChange: (p: Partial<RequestInfo>) => void;
  onApprovalSearch: () => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// design 01 §1 panel1 "Request Info" — 변경요청 완료(BtnChangeRe) 시 필수 4항목(Title/Approval/
//   ChangeReason/ReasonDetail, R14 checkRequired). Requestor/Dept 는 세션 읽기전용. RequestNo hidden(R5).
export const RequestInfoPanel = ({ requestInfo, canEdit, onChange, onApprovalSearch }: Props) => {
  const { t } = useTranslation();
  const disabled = !canEdit;
  // Change Reason* — CHANGE_REASON_CODE_ALL(CMBO_SQL, design 03 §1.3-A / 01 §1).
  const [changeReasons] = useTabComboQueries({ filters: [META_COMBO.CHANGE_REASON_CODE] });
  const reasonOptions = (changeReasons ?? []).map(r => ({
    label: str(r.NAME) || str(r.CODE),
    value: str(r.CODE),
  }));

  return (
    // 2열 배치 — AS-IS Designer 좌표 그대로다(SSP0201_ShipmentChangeRequest.Designer.cs).
    //   x 는 107(좌) / 442(우) 두 값뿐이고 3열이 없다:
    //     y= 36  txtRequestNo(107)                      <- 런타임 상시 숨김(R5) — 렌더하지 않는다
    //     y= 64  txtRequestor(107)      | txtRequestDeptName(442)
    //     y= 92  txtApproval(107)       | txtAppDeptName(442)
    //     y=120  txtTitle(107)          | cboChangeReason(442)
    //     y=148  txtReasonDetail(107, Multiline=true, 641x24 — 두 열을 가로지른다)
    //   종전 TO-BE 는 Title 을 맨 앞에 두고 3열을 꽉 채워 AS-IS 와 행·열이 모두 어긋났다.
    //   자매 SSP0200(shipment-change-request-plan/RequestInfoPanel.tsx)이 이미 이 배치라
    //   사용자 지시(2026-10-08 "SSP0200 과 동일하게")와 AS-IS 좌표가 같은 답을 가리킨다.
    //   우측 1/3 은 빈 칸(`<Grid size={4} />`)으로 비워 2열을 유지한다 — 비우지 않으면
    //   다음 필드가 올라붙어 3열이 된다.
    <Grid container spacing={0.5}>
      {/* 섹션 헤더 — AS-IS `usrLabel2.Text="Request Info"`(Designer:1351, Location 12,12).
          종전 미이식(정적 장식 라벨 판정)이었으나 사용자 지시 2026-10-08 로 이식한다. */}
      <Grid size={12}>
        <Box sx={{ fontWeight: 700, fontSize: 16, color: '#292d32', lineHeight: 1.4, textAlign: 'center' }}>
          {t(LBL.REQUEST_INFO, '_Request Info')}
        </Box>
      </Grid>

      {/* Requestor (읽기전용, 세션) */}
      <Grid size={4}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.REQUESTOR, '_Requestor')}
          labelAlign='right'
          render={() => (
            <InputField size='small' fullWidth disabled value={requestInfo.requestor} />
          )}
        />
      </Grid>

      {/* Requestor Dept Name (읽기전용) */}
      <Grid size={4}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.DEPT_NAME, '_Dept Name')}
          labelAlign='right'
          render={() => (
            <InputField size='small' fullWidth disabled value={requestInfo.requestDeptName} />
          )}
        />
      </Grid>

      <Grid size={4} />

      {/* Approval* — btnApprovalUser 팝업(SSP0002_UserInfoPopup)이 채우는 읽기전용 칸.
          돋보기는 이 칸이 아니라 **오른쪽 Dept Name 칸**에 붙는다(아래 참조). */}
      <Grid size={4}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.APPROVAL, '_Approval')}
          labelAlign='right'
          required
          render={() => (
            <InputField size='small' fullWidth disabled value={requestInfo.approval} />
          )}
        />
      </Grid>

      {/* Approval Dept Name (읽기전용) + 사용자검색 돋보기(btnApprovalUser).
          AS-IS Designer 좌표가 버튼의 소속을 정한다(SSP0201_ShipmentChangeRequest.Designer.cs, y=92 행):
            txtApproval     Location(107, 92) Size(236,24)  -> 107~343
            txtAppDeptName  Location(442, 92) Size(263,24)  -> 442~**705**
            btnApprovalUser Location(709, 92) Size( 39,24)  -> **709**~748
          버튼 x=709 는 Dept Name 의 오른쪽 끝(705)에 바로 붙어 있고 Approval(343)과는 멀다.
          즉 AS-IS 는 **Dept Name 칸 옆** 버튼이다 — 종전 TO-BE 는 Approval 칸에 달아 두었다
          (사용자 지시 2026-10-08 로 정정). 동작(onApprovalSearch -> SsoUserModal)은 그대로이고,
          선택 결과는 변함없이 approval/appDeptName 두 칸을 함께 채운다. */}
      <Grid size={4}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.DEPT_NAME, '_Dept Name')}
          labelAlign='right'
          render={() => (
            <InputField
              size='small'
              fullWidth
              disabled
              className={commonStyles.popupSearchField}
              value={requestInfo.appDeptName}
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

      <Grid size={4} />

      {/* Title* */}
      <Grid size={4}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.TITLE, '_Title')}
          labelAlign='right'
          required
          render={() => (
            <InputField
              size='small'
              fullWidth
              disabled={disabled}
              value={requestInfo.title}
              onChange={e => onChange({ title: e.target.value })}
            />
          )}
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

      <Grid size={4} />

      {/* Reason Detail* — AS-IS `txtReasonDetail.Multiline = true`(Designer:1279), 641x24 로 두 열을
          가로지르는 장문 칸이다. 필수: type='textarea' — InputField 는 type 으로 분기해 기본값('text')
          이면 size 별 고정 높이를 걸어 multiline 만으로는 칸이 안 커진다(SSP0200 선례 주석). */}
      <Grid size={8}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.REASON_DETAIL, '_Reason Detail')}
          labelAlign='right'
          required
          render={() => (
            <InputField
              type='textarea'
              fullWidth
              height={44}
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
