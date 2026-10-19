import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { COMBO, LBL, LOOKUP, MENU_ID } from '../shipment-change-request-plan.constants';
import type { RequestInfo } from '../shipment-change-request-plan.types';

interface Props {
  requestInfo: RequestInfo;
  /** 편집모드 기본 ON — 권한(EDIT)이 없을 때만 읽기전용이다(convert-core §2.4). */
  canEdit: boolean;
  /** 승인자 검색 버튼 노출 권한. 권한 없으면 버튼 자체를 렌더하지 않는다(V-22). */
  canSearchApproval: boolean;
  onChange: (p: Partial<RequestInfo>) => void;
  onApprovalSearch: () => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

/**
 * 요청정보 폼 (design 01 §1.2 — layoutControlGroup3, 좌표순 배치).
 *   `Request No` 입력란은 런타임 상시 숨김(cs:459 / L-126) — 렌더하지 않고 store 에만 값을 둔다.
 *   필수 4항목(Approval · Title · Change Reason · Reason Detail)의 라벨 텍스트가 곧 검증 메시지 인자다.
 *   AS-IS `SetChangeRequestInfo` ReadOnly 토글(E17/E18)은 호출 0건이라 dead — 미이식(Δ5).
 */
export const RequestInfoPanel = ({
  requestInfo,
  canEdit,
  canSearchApproval,
  onChange,
  onApprovalSearch,
}: Props) => {
  const { t } = useTranslation();
  // Change Reason* — CHANGE_REASON_CODE_ALL(CMBO_SQL). 선두에 '-' 더미가 함께 온다(§4.2 참고).
  //   필수: @lookupType/@mnuId. 미전달이면 후보가 '-' 1행뿐이라 필수 4항목을 만족시킬 수 없다.
  const [changeReasons] = useTabComboQueries({
    filters: [{ comboId: COMBO.CHANGE_REASON, mnuId: MENU_ID, lookupType: LOOKUP.CHANGE_REASON_CODE }],
  });
  const reasonOptions = (changeReasons ?? []).map(r => ({
    label: str(r.NAME) || str(r.CODE),
    value: str(r.CODE),
  }));

  return (
    <Grid container spacing={1}>
      {/* Requestor — 세션 사용자명(언어별). 읽기전용. */}
      <Grid size={4}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.REQUESTOR, '_Requestor')}
          labelAlign='right'
          render={() => <InputField fullWidth disabled value={requestInfo.requestor} />}
        />
      </Grid>

      {/* Dept Name (요청부서) — 원천은 세션 축 콤보다: store.fetchRequestorDept() 가
          `SalesPlanUserDept`(@sesUserId -> SCM_ADM_USER_M.DEPT_ID)로 부서ID 를 받고
          `Dept` 콤보 CODE 완전일치로 부서명을 해석한다. 읽기전용.
          금지: 조회 커서 o_rc2 로 이 칸을 채우지 마라 — o_rc2 는 모델 담당자(승인자 기본값) 축이다. */}
      <Grid size={4}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.DEPT_NAME, '_Dept Name')}
          labelAlign='right'
          render={() => <InputField fullWidth disabled value={requestInfo.requestDeptName} />}
        />
      </Grid>

      <Grid size={4} />

      {/* Approval* — 팝업 선택 또는 조회 o_rc2 자동채움(L-152). 직접 입력은 하지 않는다. */}
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
                endAdornment: canSearchApproval ? (
                  <Button
                    appearance='outlined'
                    priority='normal'
                    disabled={!canEdit}
                    iconComponent={
                      <FunctionSearchIcon appearance='lined' onClick={onApprovalSearch} />
                    }
                  />
                ) : undefined,
              }}
            />
          )}
        />
      </Grid>

      {/* Dept Name (승인부서) — 읽기전용 파생. */}
      <Grid size={4}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.DEPT_NAME, '_Dept Name')}
          labelAlign='right'
          render={() => <InputField fullWidth disabled value={requestInfo.appDeptName} />}
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
              fullWidth
              disabled={!canEdit}
              value={requestInfo.title}
              onChange={e => onChange({ title: e.target.value })}
            />
          )}
        />
      </Grid>

      {/* Change Reason* — index 0(ALL)·'-' 는 미선택으로 본다. */}
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
              disabled={!canEdit}
              onChange={(_, picked) => onChange({ changeReason: String(picked ?? '') })}
            />
          )}
        />
      </Grid>

      <Grid size={4} />

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
              disabled={!canEdit}
              value={requestInfo.reasonDetail}
              onChange={e => onChange({ reasonDetail: e.target.value })}
            />
          )}
        />
      </Grid>
    </Grid>
  );
};
