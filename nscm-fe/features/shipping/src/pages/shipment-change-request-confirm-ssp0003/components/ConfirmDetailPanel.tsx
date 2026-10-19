import commonStyles from '@foundation/styles/common-styles.module.scss';
import { FormItem, InputField } from '@shared/lges';
import { Box, Grid } from '@shared/mui';

import { LBL } from '../shipment-change-request-confirm-ssp0003.constants';
import type { ConfirmDetail } from '../shipment-change-request-confirm-ssp0003.types';

interface Props {
  detail: ConfirmDetail;
  rejectReason: string;
  // rejectReason 입력 가능 여부 — 액션(Reject/SelfReject) 대상 행 선택 시에만 활성.
  rejectEnabled: boolean;
  onRejectReasonChange: (v: string) => void;
}

// design 01 §2-C 상세 폼 — 마스터 더블클릭 시 detail GET SP o_rc2 바인딩(design 03 §4.3).
//   8필드 전부 읽기전용(Request No/Title/Requestor/Req Dept/Approval/App Dept/Change Reason/Reason Detail),
//   rejectReason 만 입력(반려/자기반려 사유, 가드 MSG00181 G4/G9).
export const ConfirmDetailPanel = ({
  detail,
  rejectReason,
  rejectEnabled,
  onRejectReasonChange,
}: Props) => {
  const { t } = useTranslation();

  return (
    // 2열 배치 — AS-IS Designer 좌표 그대로다(SSP0003_ShipmentChangeRequestConfirm.Designer.cs).
    //   x 는 101(좌) / 453(우) 두 값뿐이고 3열이 없다. 자매 SSP0202 와 좌표가 완전히 같다:
    //     y= 36  txtRequestNo(101, 644x24)                      <- 전폭(두 열을 가로지름)
    //     y= 64  txtRequestor(101, 259)   | txtRequestDeptName(453, 292)
    //     y= 92  txtApproval(101, 259)    | txtAppDeptName(453, 292)
    //     y=120  txtTitle(101, 259)       | txtChangeReason(453, 292)
    //     y=148  txtReasonDetail(101, Multiline=true, 644x24)    <- 전폭
    //     y=176  txtRejectReason(101, 644x24)                    <- 전폭. Multiline 없음(단행)
    //   전폭 3필드가 모두 644 로 **같은 폭**이라 size={8}(=4+4, 두 열) 로 맞춘다 — Reject Reason 만
    //   size={12} 로 더 넓던 종전 배치는 AS-IS 와 다르다.
    //   종전 TO-BE 는 3열을 꽉 채워 Request No/Title/Requestor 가 한 줄에 오는 등 행·열이 어긋났다
    //   (사용자 지시 2026-10-08: SSP0202 와 동일 LAYOUT 으로 교정).
    //   우측 1/3 은 빈 칸(`<Grid size={4} />`)으로 비워 2열을 유지한다.
    //   ReadOnly: AS-IS 는 txtRejectReason 을 뺀 전 필드가 ReadOnly=true 다.
    <Grid container spacing={0.5}>
      {/* 섹션 헤더 — AS-IS `usrLabel2.Text="Request Confirm Detail"`(Designer:993, Location 12,12).
          종전 미이식(정적 장식 라벨 판정)이었으나 사용자 지시 2026-10-08 로 이식한다. */}
      <Grid size={12}>
        <Box sx={{ fontWeight: 700, fontSize: 16, color: '#292d32', lineHeight: 1.4, textAlign: 'center' }}>
          {t(LBL.REQUEST_CONFIRM_DETAIL, '_Request Confirm Detail')}
        </Box>
      </Grid>

      {/* Request No (읽기전용) — 전폭 */}
      <Grid size={8}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.REQUEST_NO, '_Request No')}
          labelAlign='right'
          render={() => <InputField size='small' fullWidth disabled value={detail.requestNo} />}
        />
      </Grid>

      <Grid size={4} />

      {/* Requestor (읽기전용) */}
      <Grid size={4}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.REQUESTOR, '_Requestor')}
          labelAlign='right'
          render={() => <InputField size='small' fullWidth disabled value={detail.requestor} />}
        />
      </Grid>

      {/* Requestor Dept Name (읽기전용) */}
      <Grid size={4}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.DEPT_NAME, '_Dept Name')}
          labelAlign='right'
          render={() => (
            <InputField size='small' fullWidth disabled value={detail.requestDeptName} />
          )}
        />
      </Grid>

      <Grid size={4} />

      {/* Approval (읽기전용) */}
      <Grid size={4}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.APPROVAL, '_Approval')}
          labelAlign='right'
          render={() => <InputField size='small' fullWidth disabled value={detail.approval} />}
        />
      </Grid>

      {/* Approval Dept Name (읽기전용) */}
      <Grid size={4}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.DEPT_NAME, '_Dept Name')}
          labelAlign='right'
          render={() => <InputField size='small' fullWidth disabled value={detail.appDeptName} />}
        />
      </Grid>

      <Grid size={4} />

      {/* Title (읽기전용) */}
      <Grid size={4}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.TITLE, '_Title')}
          labelAlign='right'
          render={() => <InputField size='small' fullWidth disabled value={detail.title} />}
        />
      </Grid>

      {/* Change Reason (읽기전용) — AS-IS 도 콤보가 아니라 TextBox 다(승인자 화면이라 표시전용). */}
      <Grid size={4}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.CHANGE_REASON, '_Change Reason')}
          labelAlign='right'
          render={() => (
            <InputField size='small' fullWidth disabled value={detail.changeReason} />
          )}
        />
      </Grid>

      <Grid size={4} />

      {/* Reason Detail (읽기전용) — 전폭. AS-IS `txtReasonDetail.Multiline = true`.
          필수: type='textarea' — InputField 는 type 으로 분기해 기본값('text')이면 size 별 고정 높이를
          걸어 multiline 만으로는 칸이 안 커진다(SSP0200/SSP0202 와 동일 처리). */}
      <Grid size={8}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.REASON_DETAIL, '_Reason Detail')}
          labelAlign='right'
          render={() => (
            <InputField
              type='textarea'
              fullWidth
              height={44}
              disabled
              value={detail.reasonDetail}
            />
          )}
        />
      </Grid>

      <Grid size={4} />

      {/* Reject Reason — 유일 입력 필드(반려/자기반려 사유, §2-C3). 행 선택 전에는 비활성.
          AS-IS 는 이 칸만 ReadOnly 가 아니고, Multiline 도 없어 단행이다. */}
      <Grid size={8}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.REJECT_REASON, '_Reject Reason')}
          labelAlign='right'
          render={() => (
            <InputField
              size='small'
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
