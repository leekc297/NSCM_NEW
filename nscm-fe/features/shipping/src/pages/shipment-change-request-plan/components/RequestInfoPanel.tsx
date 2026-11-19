import type { ReactNode } from 'react';

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
  /** 액션 버튼(Request Complete/Cancel) — Reason Detail 옆 빈칸(size 4)에 렌더한다(2026-11-12). */
  actionSlot?: ReactNode;
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
  actionSlot,
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
    // 입력칸 높이 축소(사용자 지시 2026-11-12) — 한 줄 입력칸(Requestor·Dept Name·Title·Approval)과
    //   Change Reason 콤보를 모두 30px 로 낮춘다. 멀티라인(Reason Detail)만 제외한다(2줄 표시 height={56}).
    //   필수: 특이성 싸움을 이겨야 30px 가 실제로 먹는다. 두 방해 규칙이 모두 !important 라 특이성으로 이겨야 한다 —
    //     1) 텍스트칸: 프로젝트 _formItem 모듈의 `body ._formItem_… .MuiOutlinedInput-root { height:36px !important }`
    //        (body+클래스2). → sx 셀렉터 앞에 `body` 를 붙여 특이성을 넘긴다(`& .MuiInputBase-root` → `body & …`).
    //     2) 콤보: `.css-…Autocomplete-root .MuiFormControl-root .MuiOutlinedInput-root { min-height:36px; height:auto }`
    //        (클래스3). → 콤보의 Autocomplete-inputRoot 를 따로 겨냥해 min-height/height 를 30px 로 눌러야 한다
    //        (일반 InputBase 규칙은 Autocomplete 를 제외하므로 콤보엔 안 먹는다).
    <Grid
      container
      columnSpacing={0.5}
      // 행 간 세로 간격을 최소화(사용자 지시 2026-11-12 추가 축소) — rowSpacing 0.25(2px)로는 체감이 약해
      //   0 으로 두고, Grid 가 rowSpacing 을 아이템 padding-top 으로 주입하는 분까지 sx 로 직접 눌러 바짝 붙인다
      //   (자매 SSP0003 ConfirmDetailPanel 선례). 가로 간격은 유지(columnSpacing 0.5).
      rowSpacing={0}
      sx={{
        // Grid rowSpacing 이 아이템 padding-top 으로 들어가도 전역 reset 과 겹쳐 체감이 약하다 — 행(아이템)의
        //   상단 패딩을 직접 0 으로 눌러 줄 간격을 없앤다(멀티라인/빈칸 포함 전 아이템 동일).
        '& > .MuiGrid-root': { paddingTop: '0 !important' },
        // FormItem 셀 높이로 행 간격을 조절한다(사용자 지시 2026-11-12). _formItem 그리드는 align-items:center
        //   라 셀이 36px 로 남으면 28px 입력칸이 위·아래로 떠 행 간격이 벌어지고, 28px 로 바짝 누르면 완전히
        //   붙어 보인다(사용자 신고) — 32px 로 입력칸(28px) 위·아래 2px 씩만 남겨 적당히 띄운다. 단행 행만
        //   겨냥한다: 멀티라인(Reason Detail) 셀은 56px 입력이라 눌리면 textarea 가 삐져나온다 — 그 부모 Grid 에
        //   reasonDetailCell 표식을 달아 [class*="reasonDetailCell"] 하위를 제외한다(reasonDetailField 는
        //   입력칸에만 있어 셀 셀렉터로 못 잡음 · emotion :has 미사용, 2026-11-12). body & 로 특이성을 올려 DS 를 이긴다.
        'body & .MuiGrid-root:not([class*="reasonDetailCell"]) > [class*="_formItem"]': {
          minHeight: '32px !important',
          height: '32px !important',
        },
        // 상·하단 여백(사용자 지시 2026-11-12) — 'Request Info' 헤더를 삭제하면서 상단 그리드와 Info 영역이
        //   너무 붙어 보인다. container 상·하단 패딩으로 Info 영역 위(상단 그리드)·아래(하단 그리드) 간격을
        //   같은 값으로 맞춘다. 사용자 지시(2026-11-12 추가)로 6px -> 2px -> 0 으로 더 줄여 상단 그리드와 완전히 붙인다.
        pt: '0',
        pb: '0',
        // 단행 입력칸 래퍼(FormControl/TextField)를 28px 로(사용자 지시 2026-11-12, 30->28). DS 기본
        //   (.css-…MuiTextField-root{height:36px})이 래퍼를 36px 로 못박아 안쪽 입력칸 위·아래로 떠 행 간격이
        //   벌어진다. body & 로 특이성을 올려 이긴다. 멀티라인(Reason Detail)은 56px 라 제외해야 하는데, emotion
        //   sx 에서 :has() 셀렉터는 스타일시트에 삽입되지 않아(실측 2026-11-12) 안 먹는다 — Reason Detail 에
        //   reasonDetailField 클래스를 달고 [class*="reasonDetailField"] 속성셀렉터로 제외한다(:has 미사용).
        'body & .MuiTextField-root:not([class*="reasonDetailField"])': {
          height: '28px !important',
          minHeight: '28px !important',
        },
        // 텍스트칸 30px — 방해 규칙 `body ._formItem_… .MuiOutlinedInput-root { height:36px !important }`
        //   (specificity body+클래스2)를 특이성으로 이겨야 한다. 둘 다 !important 라 특이성·소스순서가 승부다.
        //   필수: _formItem 클래스를 셀렉터에 명시해(해시라 [class*="_formItem"] 속성셀렉터로) 특이성을
        //   (body+속성1+클래스1=클래스2 동률)을 넘어 (속성1+클래스2) 이상으로 올린다 — 소스순서에 기대지
        //   않고 확정적으로 이긴다. VDI 처럼 번들 주입순서가 달라도 30px 가 깨지지 않는다(2026-11-12 VDI 실사고:
        //   순서로만 이기던 로컬과 달리 VDI 에선 _formItem 36px 가 뒤에 와 텍스트칸만 36px 로 튀었다).
        'body & [class*="_formItem"] .MuiInputBase-root:not(.MuiInputBase-multiline):not(.MuiAutocomplete-inputRoot)':
          {
            height: '28px !important',
            minHeight: '28px !important',
          },
        // 승인부서 Dept Name 등 _formItem 으로 안 감싼 입력칸이 있을 경우를 위한 보강(특이성 낮음 — 순서 의존).
        'body & .MuiInputBase-root:not(.MuiInputBase-multiline):not(.MuiAutocomplete-inputRoot)': {
          height: '28px !important',
          minHeight: '28px !important',
        },
        // 콤보(Change Reason) — Autocomplete 입력부. min-height:36px(3클래스)를 눌러 28px 로.
        'body & .MuiAutocomplete-inputRoot': {
          height: '28px !important',
          minHeight: '28px !important',
        },
        // 승인부서 Dept Name 칸의 돋보기(검색) 버튼 — 디자인시스템이 height:36px·min-width:36px 로
        //   고정해 혼자 36px 로 튄다(사용자 지시 2026-11-12). 입력칸(30px)에 맞춰 버튼도 30px 로 낮춘다.
        //   버튼이 걸린 칸은 commonStyles.popupSearchField(런타임 _popupSearchField_…) 다 — sx 에선 해시를
        //   못 쓰니 [class*="popupSearchField"] 속성셀렉터로 그 칸의 버튼만 겨냥한다(액션바 버튼은 제외).
        //   body & 로 특이성을 올려 DS 규칙(.css-…-MuiButton-root { height:36px·min-width:36px })을 넘긴다.
        'body & [class*="popupSearchField"] .MuiButton-root': {
          height: '28px !important',
          minHeight: '28px !important',
          minWidth: '28px !important',
          width: '28px !important',
        },
      }}
    >
      {/* 섹션 헤더 'Request Info' 는 사용자 지시(2026-11-12)로 삭제됨 — 첫 행은 Requestor 부터 시작한다. */}

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
                    iconComponent={<FunctionSearchIcon appearance='lined' />}
                    onClick={onApprovalSearch}
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
          sales-reports TextboxModal 선례). height 로 칸 높이를 준다 — 2줄 표시(사용자 지시 2026-11-12, 56 -> 78 -> 56).
          필수: sx 로 textarea 를 칸 안에 가둔다. 없으면 textarea 가 줄 수만큼 늘어 overflow:hidden 고정
          패널을 넘치고, 브라우저가 커서를 보이려고 패널을 스크롤해 화면이 밀려 올라간다.
          className='reasonDetailCell' — 부모 Grid 에 표식을 달아, 단행 FormItem 셀을 32px 로 눌러 행 간격을
          맞추는 panel sx 규칙(_formItem 셀 높이)이 이 멀티라인(56px) 셀을 건드리지 않게 제외한다(:has 미사용
          우회 — reasonDetailField 는 입력칸에만 있어 셀 셀렉터로는 못 잡는다, 2026-11-12). */}
      <Grid size={8} className='reasonDetailCell'>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.REASON_DETAIL, '_Reason Detail')}
          labelAlign='right'
          required
          render={() => (
            <InputField
              type='textarea'
              fullWidth
              height={56}
              // 멀티라인 제외 표식 — panel sx 의 단행 30px 규칙이 이 칸을 건드리지 않도록
              //   [class*="reasonDetailField"] 로 제외한다(:has 미사용 우회, 2026-11-12).
              className='reasonDetailField'
              sx={{
                '& .MuiInputBase-root': { height: '100%' },
                '& textarea': {
                  height: '100% !important',
                  minHeight: '0 !important',
                  overflow: 'auto !important',
                },
              }}
              disabled={!canEdit}
              value={requestInfo.reasonDetail}
              onChange={e => onChange({ reasonDetail: e.target.value })}
            />
          )}
        />
      </Grid>

      {/* 액션 버튼(Request Complete/Cancel) — Reason Detail 옆 우측 빈칸(size 4)에 배치
          (사용자 지시 2026-11-12). Reason Detail 과 같은 행이라 세로로 아래 정렬해 textarea 하단에 맞춘다.
          justifyContent:flex-start — 버튼을 셀 좌측(= Reason Detail 쪽)에 둔다. pl:12px 로 Reason Detail 과
          바짝 붙지 않게 살짝 띄운다 — ml 은 셀 바깥폭에 더해져 size 4+8=12 를 넘겨 줄바꿈을 일으키므로
          셀 안쪽 패딩(pl)으로 띄운다(사용자 지시 2026-11-12). */}
      <Grid size={4} sx={{ display: 'flex', alignItems: 'flex-end', justifyContent: 'flex-start', pl: '12px' }}>
        {actionSlot}
      </Grid>
    </Grid>
  );
};
