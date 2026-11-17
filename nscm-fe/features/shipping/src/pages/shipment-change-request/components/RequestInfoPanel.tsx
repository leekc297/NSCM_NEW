import type { ReactNode } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { COMBO, LBL, LOOKUP, MENU_ID } from '../shipment-change-request.constants';
import type { RequestInfo } from '../shipment-change-request.types';

interface Props {
  requestInfo: RequestInfo;
  // EDIT 권한 축 — 편집모드 토글이 아니다(AS-IS SwitchLock 미이식, convert-core §2.4). 권한이 없으면 폼 비활성.
  canEdit: boolean;
  onChange: (p: Partial<RequestInfo>) => void;
  onApprovalSearch: () => void;
  /** 액션 버튼(Request Complete/Cancel) — Reason Detail 옆 빈칸(size 4)에 렌더한다(2026-11-12, 자매 SSP0200 패턴). */
  actionSlot?: ReactNode;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// design 01 §1 panel1 "Request Info" — 변경요청 완료(BtnChangeRe) 시 필수 4항목(Title/Approval/
//   ChangeReason/ReasonDetail, R14 checkRequired). Requestor/Dept 는 세션 읽기전용. RequestNo hidden(R5).
export const RequestInfoPanel = ({
  requestInfo,
  canEdit,
  onChange,
  onApprovalSearch,
  actionSlot,
}: Props) => {
  const { t } = useTranslation();
  const disabled = !canEdit;
  // Change Reason* — CHANGE_REASON_CODE_ALL(CMBO_SQL, design 03 §1.3-A / 01 §1).
  //   필수: @lookupType/@mnuId. 종전엔 comboId 만 넘겨(`filters: ['CHANGE_REASON_CODE_ALL']`)
  //   콤보 본문의 `WHERE A.LOOKUP_TYPE = @lookupType` 가 '' 로 치환돼 후보가 더미 '-' 1행뿐이었다
  //   (ora.py 실측 2026-10-13: 전달 8행 vs 미전달 1행). 요청완료 필수항목이라 선택 자체가 불가능했다.
  const [changeReasons] = useTabComboQueries({
    filters: [{ comboId: COMBO.CHANGE_REASON, mnuId: MENU_ID, lookupType: LOOKUP.CHANGE_REASON_CODE }],
  });
  // 콤보는 더미행(CODE='-', NAME=NULL) + T01~T07(NAME="T01 : 물류이슈"…)을 준다. AS-IS 는
  //   `setListBoxEx(dt, cbo, true, …)` 의 true 로 맨 앞에 'ALL' 행을 강제 삽입한다(CControl.cs:379~400).
  //   더미행(NAME 없음)은 버리고 실제 사유코드만 옵션으로 만든다 — 선두 'ALL'(value '')은
  //   CustomDropdown 의 `allOption` 이 공급한다. 직접 value '' 로 ALL 을 만들어 넣으면
  //   CustomDropdown 의 센티널 제거 규칙(''/'-'/'--' 옵션 숨김, 2026-08-18 전역 확정)이 걸러
  //   목록에 안 떴다. ALL=미선택('') 의미는 그대로라 요청완료 필수검증(changeReason '' 차단)과 일치.
  const reasonOptions = (changeReasons ?? [])
    .map(r => ({ label: str(r.NAME), value: str(r.CODE) }))
    .filter(o => o.label);

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
    // 입력칸 높이 축소(사용자 지시 2026-11-12) — 한 줄 입력칸·콤보를 모두 30px 로 낮춘다(멀티라인 Reason
    //   Detail 만 제외). 자매 SSP0200 과 두께를 맞춘다. 두 방해 규칙이 모두 !important 라 특이성으로 이겨야
    //   하므로 `body &` + `[class*="_formItem"]` 속성셀렉터로 특이성을 올려 소스순서와 무관하게 30px 를
    //   확정 승리시킨다([[emotion-important-order-dep-vs-specificity]], SSP0200 VDI 실사고 선례).
    <Grid
      container
      columnSpacing={0.5}
      // 행 간 세로 간격을 최소화(사용자 지시 2026-11-12 추가 축소) — rowSpacing 0.25(2px)로는 체감이 약해
      //   0 으로 두고, Grid 가 rowSpacing 을 아이템 padding-top 으로 주입하는 분까지 sx 로 직접 눌러 바짝 붙인다
      //   (자매 SSP0200 과 동일). 가로 간격은 유지(columnSpacing 0.5).
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
        //   같은 값으로 맞춘다. 사용자 지시(2026-11-12 추가)로 6px -> 0 으로 줄여 상단 그리드와 완전히 붙인다(자매 SSP0200 과 동일).
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
        'body & [class*="_formItem"] .MuiInputBase-root:not(.MuiInputBase-multiline):not(.MuiAutocomplete-inputRoot)':
          {
            height: '28px !important',
            minHeight: '28px !important',
          },
        'body & .MuiInputBase-root:not(.MuiInputBase-multiline):not(.MuiAutocomplete-inputRoot)': {
          height: '28px !important',
          minHeight: '28px !important',
        },
        // 콤보(Change Reason) — Autocomplete 입력부. min-height:36px 를 28px 로 누른다.
        'body & .MuiAutocomplete-inputRoot': {
          height: '28px !important',
          minHeight: '28px !important',
        },
        // 승인부서 Dept Name 칸의 돋보기 버튼 — DS 가 36px 로 고정하는 것을 입력칸(28px)에 맞춰 낮춘다.
        'body & [class*="popupSearchField"] .MuiButton-root': {
          height: '28px !important',
          minHeight: '28px !important',
          minWidth: '28px !important',
          width: '28px !important',
        },
      }}
    >
      {/* 섹션 헤더 'Request Info' 는 사용자 지시(2026-11-12)로 삭제됨 — 첫 행은 Requestor 부터 시작한다
          (2026-10-08 이식했던 usrLabel2 장식 라벨을 다시 제거, 자매 SSP0200 과 동일). */}

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
                    iconComponent={<FunctionSearchIcon appearance='lined' />}
                    onClick={onApprovalSearch}
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
              allOption
              value={requestInfo.changeReason}
              options={reasonOptions}
              disabled={disabled}
              onChange={(_, picked) => onChange({ changeReason: String(picked ?? '') })}
            />
          )}
        />
      </Grid>

      <Grid size={4} />

      {/* Reason Detail — AS-IS `txtReasonDetail.Multiline = true`(Designer:1279)로 두 열을 가로지른다.
          type='textarea' 는 multiline 인데 행 상한이 없으면 입력 줄수만큼 무한히 커져 고정 폼
          패널(overflow:hidden) 밖으로 글자가 삐져나온다(사용자 신고 2026-11-02). height 로 칸 높이를
          고정해 2줄 표시(사용자 지시 2026-11-12, 자매 SSP0200 과 동일 — 78 -> 56) + 초과분은
          네이티브 스크롤로 막는다. sx 로 textarea 를 칸 안에 가둔다 — 없으면 textarea 가 줄 수만큼 늘어
          패널을 넘치고 브라우저가 커서를 보이려 패널을 스크롤해 화면이 밀려 올라간다.
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
              // 멀티라인 제외 표식 — panel sx 의 단행 28px 규칙이 이 칸을 건드리지 않도록
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
              disabled={disabled}
              value={requestInfo.reasonDetail}
              onChange={e => onChange({ reasonDetail: e.target.value })}
            />
          )}
        />
      </Grid>

      {/* 액션 버튼(Request Complete/Cancel) — Reason Detail 옆 우측 빈칸(size 4)에 배치
          (사용자 지시 2026-11-12, 자매 SSP0200 과 동일). Reason Detail 과 같은 행이라 세로로 아래 정렬해
          textarea 하단에 맞춘다. pl:12px 로 Reason Detail 과 바짝 붙지 않게 살짝 띄운다 — ml 은 셀
          바깥폭에 더해져 size 4+8=12 를 넘겨 줄바꿈을 일으키므로 셀 안쪽 패딩(pl)으로 띄운다. */}
      <Grid size={4} sx={{ display: 'flex', alignItems: 'flex-end', justifyContent: 'flex-start', pl: '12px' }}>
        {actionSlot}
      </Grid>
    </Grid>
  );
};
