import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Box, Grid } from '@shared/mui';

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
  // 콤보(CHANGE_REASON_CODE_ALL)는 더미행(CODE='-', NAME=NULL) + T01~T07(NAME="T01 : 물류이슈"…)을 준다.
  //   AS-IS 는 `setListBoxEx(dt, cbo, true, …)` 의 true 로 맨 앞에 'ALL' 행(FlagAll)을 강제 삽입한다
  //   (CControl.cs:379~400). TO-BE 는 그 prepend 가 없어 더미행이 '-' 로 보였다 — 더미행(NAME 빈값)을
  //   'ALL' 라벨 + 빈 value 로 매핑해 목록·초기표시를 AS-IS 와 일치시킨다(store 기본 changeReason='' 와 같음).
  //   검증(checkRequestInfoRequired)은 ''/'ALL'/'-' 를 모두 미선택으로 보므로 필수판정은 그대로다.
  const reasonOptions = (changeReasons ?? []).map(r => {
    const name = str(r.NAME);
    return name ? { label: name, value: str(r.CODE) } : { label: 'ALL', value: '' };
  });

  return (
    // 컴팩트 배치(사용자 지시 2026-09-29) — 고정 폼 패널(FORM_PANEL_SIZE) 안에 스크롤 없이 담기도록 간격 축소.
    <Grid container spacing={0.5}>
      {/* 섹션 헤더 — AS-IS `usrLabel2.Text="Request Info"`(Designer:1397, Location 12,12).
          종전엔 '정적 장식 라벨'로 보고 미이식(L-012·L-013)했으나 사용자 지시 2026-10-08 로 이식한다.
          고정 높이 패널(FORM_PANEL_SIZE)이라 한 줄 분량만 쓰도록 폰트·여백을 최소로 둔다. */}
      <Grid size={12}>
        <Box sx={{ fontWeight: 700, fontSize: 16, color: '#292d32', lineHeight: 1.4, textAlign: 'center' }}>
          {t(LBL.REQUEST_INFO, '_Request Info')}
        </Box>
      </Grid>

      {/* Requestor — 세션 사용자명(언어별). 읽기전용. */}
      <Grid size={4}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.REQUESTOR, '_Requestor')}
          labelAlign='right'
          render={() => <InputField size='small' fullWidth disabled value={requestInfo.requestor} />}
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
          render={() => <InputField size='small' fullWidth disabled value={requestInfo.requestDeptName} />}
        />
      </Grid>

      <Grid size={4} />

      {/* Approval* — 팝업 선택 또는 조회 o_rc2 자동채움(L-152). 직접 입력은 하지 않는다.
          검색 버튼은 이 칸이 아니라 **승인부서 Dept Name 칸 옆**에 둔다(아래) — AS-IS 좌표가 그렇다. */}
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

      {/* Dept Name (승인부서) — 읽기전용 파생 + **승인자 검색(UserInfo) 버튼**.
          AS-IS Designer 좌표: `lcApproval`(txtApproval) X=0 / `layoutControlItem9`(txtAppDeptName) X=335 /
          **`lcAppDept`(btnApprovalUser) X=697** — 버튼이 Approval 이 아니라 Dept Name 뒤에 붙는다
          (항목명 자체가 `lcAppDept` 다). 종전 TO-BE 는 Approval 칸 endAdornment 에 달아 위치가 달랐다
          — 사용자 지시 2026-10-08 로 AS-IS 자리로 옮긴다. */}
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

      {/* Reason Detail* — 여러 줄 입력(textarea). AS-IS 사유 상세는 장문 입력 칸이다.
          필수: type='textarea'. InputField 는 type 으로 분기해 기본값('text')이면 size 별 고정 높이를
          걸어 multiline 만 줘서는 칸이 안 커지고 글자가 넘친다('textarea' 분기라야 height 가 먹는다,
          sales-reports TextboxModal 선례). height 로 3줄 정도 높이를 준다. */}
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
