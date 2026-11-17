import { ArrowChevronIcon, ListPinIcon } from '@lges/design-system/icon';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { Button, FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { LBL } from '../shipment-change-request-confirm.constants';
import type { ConfirmDetail } from '../shipment-change-request-confirm.types';

import styles from './ConfirmDetailPanel.module.scss';

interface Props {
  detail: ConfirmDetail;
  rejectReason: string;
  // rejectReason 입력 가능 여부 — 액션(Reject/SelfReject) 대상 행 선택 시에만 활성.
  rejectEnabled: boolean;
  onRejectReasonChange: (v: string) => void;
  /** 접힘 여부 — true 면 머리줄만 렌더한다(입력값은 store 에 그대로 남는다). */
  collapsed: boolean;
  /** 고정 여부 — 고정 중에는 접기/펼치기 버튼을 비활성화한다. */
  pinned: boolean;
  onToggleCollapsed: () => void;
  onTogglePin: () => void;
}

// design 01 §2 B1/B4 "Request Info" 디테일 폼 — 마스터 더블클릭 시 detail GET SP Tables[1] 바인딩.
//   8필드 전부 읽기전용(Request No/Title/Requestor/Req Dept/Approval/App Dept/Change Reason/Reason Detail),
//   rejectReason 만 입력(반려/자기반려 사유, 가드 MSG00181).
//   ReadOnly: AS-IS 는 txtRejectReason 을 뺀 전 필드가 ReadOnly=true 다(Designer 906·914·922·955·998).
export const ConfirmDetailPanel = ({
  detail,
  rejectReason,
  rejectEnabled,
  onRejectReasonChange,
  collapsed,
  pinned,
  onToggleCollapsed,
  onTogglePin,
}: Props) => {
  const { t } = useTranslation();

  return (
    // 영역 레이아웃(사용자 지시 2026-11-12 — 자매 SSP0200 Request Info 와 같은 형태):
    //   테두리 박스 1개 = [영역 Header(접기/펼치기·고정)] + [입력 3행].
    //   영역 Header 는 DMF0008(erp-edi-master) `.sectionTitle` 모양 — 좌측 파란 띠 + 연회색 바탕 + 왼쪽 정렬 제목.
    //   입력 배치(SSP0200 과 같은 행 구성):
    //     1행 = Requestor · Dept Name(요청) · Approval · Dept Name(승인)   (size 3 ×4)
    //     2행 = Title · Change Reason · Reason Detail                     (3 · 3 · 6)
    //     3행 = Request No · Reject Reason                                (3 · 9)
    //   SSP0200 은 Request No 가 런타임 숨김이라 없지만 SSP0202 는 AS-IS 에서 **보인다**(txtRequestNo y=36,
    //   런타임 숨김 조작 없음) — 누락 금지라 3행 첫 칸에 두고, 유일 입력칸 Reject Reason 을 같은 행 나머지 폭에 둔다.
    //   종전 배치(AS-IS Designer 좌표 2열: x=101/453, 전폭 3필드 644)는 사용자 지시로 이 형태로 바꾼다.
    <div className={styles.section}>
      {/* 영역 Header — AS-IS `usrLabel2.Text="Request Confirm Detail"`(Designer:991, Location 12,12).
          사용자 지시 2026-10-08 로 이식(종전 가운데 정렬 굵은 글씨), 2026-11-12 DMF0008 영역 Header 모양으로 교체.
          제목 옆 = 접기/펼치기·고정(핀). 액션(Approval/Reject/Self Reject)은 종전대로 SubTitle customButtons 에 둔다. */}
      <div className={styles.sectionTitle}>
        <span className={styles.titleText}>
          {t(LBL.REQUEST_CONFIRM_DETAIL, '_Request Confirm Detail')}
        </span>
        <div className={styles.headerTools}>
          <Button
            size='small'
            appearance='outlined'
            priority='normal'
            disabled={pinned}
            iconComponent={
              <ArrowChevronIcon direction={collapsed ? 'down' : 'up'} appearance='single' iconSize={16} />
            }
            onClick={onToggleCollapsed}
          />
          <Button
            size='small'
            appearance='outlined'
            priority='normal'
            iconComponent={
              <ListPinIcon status='pin' appearance={pinned ? 'filled' : 'lined'} iconSize={16} />
            }
            onClick={onTogglePin}
          />
        </div>
      </div>

      {!collapsed && (
        <div className={styles.sectionBody}>
          <Grid container spacing={0.5}>
            {/* Requestor (읽기전용) */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.REQUESTOR, '_Requestor')}
                labelAlign='right'
                render={() => (
                  <InputField size='small' fullWidth disabled value={detail.requestor} />
                )}
              />
            </Grid>

            {/* Requestor Dept Name (읽기전용) */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.DEPT_NAME, '_Dept Name')}
                labelAlign='right'
                render={() => (
                  <InputField size='small' fullWidth disabled value={detail.requestDeptName} />
                )}
              />
            </Grid>

            {/* Approval (읽기전용) */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.APPROVAL, '_Approval')}
                labelAlign='right'
                render={() => <InputField size='small' fullWidth disabled value={detail.approval} />}
              />
            </Grid>

            {/* Approval Dept Name (읽기전용) */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.DEPT_NAME, '_Dept Name')}
                labelAlign='right'
                render={() => (
                  <InputField size='small' fullWidth disabled value={detail.appDeptName} />
                )}
              />
            </Grid>

            {/* Title (읽기전용) */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.TITLE, '_Title')}
                labelAlign='right'
                render={() => <InputField size='small' fullWidth disabled value={detail.title} />}
              />
            </Grid>

            {/* Change Reason (읽기전용) — AS-IS 도 콤보가 아니라 TextBox 다(승인자 화면이라 표시전용). */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.CHANGE_REASON, '_Change Reason')}
                labelAlign='right'
                render={() => (
                  <InputField size='small' fullWidth disabled value={detail.changeReason} />
                )}
              />
            </Grid>

            {/* Reason Detail (읽기전용) — AS-IS `txtReasonDetail.Multiline = true`(Designer:953).
                2026-11-12: Title·Change Reason 과 한 행에 두므로 SSP0200 과 같이 높이 36(조회조건 표준 높이)·폭 size 6.
                필수: type='textarea' + styles.reasonDetail 로 textarea 를 칸 안에 가둔다 — 없으면 저장된 사유
                줄수만큼 상자가 커져 폼 밖으로 삐져나온다(SSP0201 동일 신고 2026-11-02). 긴 사유는 칸 안에서 스크롤. */}
            <Grid size={6}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.REASON_DETAIL, '_Reason Detail')}
                labelAlign='right'
                render={() => (
                  <InputField
                    type='textarea'
                    fullWidth
                    height={36}
                    className={styles.reasonDetail}
                    disabled
                    value={detail.reasonDetail}
                  />
                )}
              />
            </Grid>

            {/* Request No (읽기전용) — AS-IS 에서 보이는 칸(SSP0201/SSP0200 과 달리 숨김 조작 없음). */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                // GAP-01: LBL01110='Revision' 오매핑 -> LBL00744='Request No'(실측).
                label={t(LBL.REQUEST_NO, '_Request No')}
                labelAlign='right'
                render={() => (
                  <InputField size='small' fullWidth disabled value={detail.requestNo} />
                )}
              />
            </Grid>

            {/* Reject Reason — 유일 입력 필드(반려/자기반려 사유, B4). 행 선택 전에는 비활성.
                AS-IS 는 이 칸만 ReadOnly 가 아니고, Multiline 도 없어 단행이다(Designer:1004~1006).
                길이 제한 1000: 저장 SP(PKG_SSP0202 P_SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM BODY:827/835)는
                입력 사유를 헤더 SSP_ANL_SHIP_CONFIRM_CHG_REQ.REJECT_REASON(VARCHAR2(1000 CHAR), AS-IS
                nvarchar(1000) 동일)에만 쓴다 — SSP0003 과 달리 per-row ATTRIBUTE3(150)에는 쓰지 않아
                바인딩 제한이 1000 이다. 공용 기본 maxLength 500 을 DB 컬럼 길이(1000)에 맞춘다. */}
            <Grid size={9}>
              <FormItem
                className={commonStyles.formItem}
                // GAP-01: LBL01109='Result Type' 오매핑 -> LBL00628='Reject Reason'(실측).
                label={t(LBL.REJECT_REASON, '_Reject Reason')}
                labelAlign='right'
                render={() => (
                  <InputField
                    size='small'
                    fullWidth
                    limited={1000}
                    disabled={!rejectEnabled}
                    value={rejectReason}
                    onChange={e => onRejectReasonChange(e.target.value)}
                  />
                )}
              />
            </Grid>
          </Grid>
        </div>
      )}
    </div>
  );
};
