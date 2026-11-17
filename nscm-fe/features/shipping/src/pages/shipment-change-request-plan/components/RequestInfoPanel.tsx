import { ArrowChevronIcon, ListPinIcon } from '@lges/design-system/icon';
import type { ReactNode } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { COMBO, LBL, LOOKUP, MENU_ID } from '../shipment-change-request-plan.constants';
import type { RequestInfo } from '../shipment-change-request-plan.types';

import styles from './RequestInfoPanel.module.scss';

interface Props {
  requestInfo: RequestInfo;
  /** 편집모드 기본 ON — 권한(EDIT)이 없을 때만 읽기전용이다(convert-core §2.4). */
  canEdit: boolean;
  /** 승인자 검색 버튼 노출 권한. 권한 없으면 버튼 자체를 렌더하지 않는다(V-22). */
  canSearchApproval: boolean;
  onChange: (p: Partial<RequestInfo>) => void;
  onApprovalSearch: () => void;
  /** 접힘 여부 — true 면 머리줄만 렌더한다(입력값은 store 에 그대로 남는다). */
  collapsed: boolean;
  /** 고정 여부 — 고정 중에는 접기/펼치기 버튼을 비활성화한다. */
  pinned: boolean;
  onToggleCollapsed: () => void;
  onTogglePin: () => void;
  /** 머리줄 오른쪽 액션(Request Complete / Cancel) — 접힌 상태에서도 보인다. */
  actions?: ReactNode;
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
  collapsed,
  pinned,
  onToggleCollapsed,
  onTogglePin,
  actions,
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
    // 영역 레이아웃(사용자 지시 2026-11-12): 테두리 박스 1개 = [영역 Header] + [입력 2행].
    //   영역 Header 는 DMF0008(erp-edi-master) `.sectionTitle`(Summary / List of SCM Master Data…) 와 같은
    //   모양 — 좌측 파란 띠 + 연회색 바탕 + 왼쪽 정렬 제목. 테두리는 같은 화면 `.gridContainer` 규격.
    //   입력 배치: 1행 = Requestor · Dept Name(요청) · Approval · Dept Name(승인+검색) /
    //   2행 = Title · Change Reason · Reason Detail. 패널 높이는 페이지가 이 박스의 실측 높이로 맞춘다.
    <div className={styles.section}>
      {/* 영역 Header — AS-IS `usrLabel2.Text="Request Info"`(Designer:1397). 사용자 지시 2026-10-08 로 이식,
          2026-11-12 DMF0008 영역 Header 모양으로 교체. 제목 옆 = 접기/펼치기·고정(핀), 오른쪽 끝 = 액션 버튼. */}
      <div className={styles.sectionTitle}>
        <span className={styles.titleText}>{t(LBL.REQUEST_INFO, '_Request Info')}</span>
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
        <div className={styles.headerActions}>{actions}</div>
      </div>

      {!collapsed && (
        <div className={styles.sectionBody}>
          <Grid container spacing={0.5}>
            {/* Requestor — 세션 사용자명(언어별). 읽기전용. */}
            <Grid size={3}>
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
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.DEPT_NAME, '_Dept Name')}
                labelAlign='right'
                render={() => <InputField size='small' fullWidth disabled value={requestInfo.requestDeptName} />}
              />
            </Grid>

            {/* Approval* — 팝업 선택 또는 조회 o_rc2 자동채움(L-152). 직접 입력은 하지 않는다.
                검색 버튼은 이 칸이 아니라 **승인부서 Dept Name 칸 옆**에 둔다(아래) — AS-IS 좌표가 그렇다. */}
            <Grid size={3}>
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
            <Grid size={3}>
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
                          iconComponent={<FunctionSearchIcon appearance='lined' />}
                          onClick={onApprovalSearch}
                        />
                      ) : undefined,
                    }}
                  />
                )}
              />
            </Grid>

            {/* Title* */}
            <Grid size={3}>
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
            <Grid size={3}>
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

            {/* Reason Detail* — 여러 줄 입력(textarea). AS-IS 사유 상세는 장문 입력 칸이다.
                필수: type='textarea'. InputField 는 type 으로 분기해 기본값('text')이면 size 별 고정 높이를
                걸어 multiline 만 줘서는 칸이 안 커지고 글자가 넘친다('textarea' 분기라야 height 가 먹는다,
                sales-reports TextboxModal 선례). height 로 칸 높이를 준다.
                2026-11-12: Title·Change Reason 과 한 행에 두므로 높이 44 -> 36(조회조건 표준 높이)·폭 size 6.
                필수: styles.reasonDetail 로 textarea 를 칸 안에 가둔다(종전 sx 와 같은 규칙을 SCSS 로 이동).
                없으면 textarea 가 줄 수만큼 늘어 overflow:hidden 패널을 넘치고, 브라우저가 커서를 보이려고
                패널을 스크롤해 화면이 밀려 올라간다. 긴 사유는 칸 안에서 스크롤된다. */}
            <Grid size={6}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.REASON_DETAIL, '_Reason Detail')}
                labelAlign='right'
                required
                render={() => (
                  <InputField
                    type='textarea'
                    fullWidth
                    height={36}
                    className={styles.reasonDetail}
                    disabled={!canEdit}
                    value={requestInfo.reasonDetail}
                    onChange={e => onChange({ reasonDetail: e.target.value })}
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
