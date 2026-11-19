import commonStyles from '@foundation/styles/common-styles.module.scss';
import { FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

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
    <Grid
      container
      columnSpacing={0.5}
      // 행 간 세로 간격 축소(사용자 지시 2026-11-12) — 입력칸 30px 축소에 맞춰 줄 간격도 좁힌다. rowSpacing
      //   0.25(2px)로는 체감이 약해(사용자 신고) Grid 아이템 상단 패딩(=rowSpacing 주입분)을 sx 로 직접 0 으로
      //   눌러 행을 바짝 붙인다. rowSpacing 은 0 으로 두고 FormItem 세로 패딩만 남긴다.
      rowSpacing={0}
      sx={{
        // Grid rowSpacing 이 아이템 padding-top 으로 들어가도 전역 reset 과 겹쳐 체감이 약하다 — 행(아이템)의
        //   상단 패딩을 직접 0 으로 눌러 줄 간격을 없앤다(멀티라인/빈칸 포함 전 아이템 동일).
        '& > .MuiGrid-root': { paddingTop: '0 !important' },
        // FormItem 셀 높이로 행 간격을 조절한다(사용자 지시 2026-11-12, 자매 SSP0200/0201 과 동일). _formItem
        //   그리드는 align-items:center 라 셀이 36px 로 남으면 28px 입력칸이 위·아래로 떠 행 간격이 벌어지고,
        //   28px 로 바짝 누르면 완전히 붙어 보인다 — 32px 로 입력칸(28px) 위·아래 2px 씩만 남겨 적당히 띄운다.
        //   단행 행만 겨냥한다: 멀티라인(Reason Detail) 셀은 2줄 textarea 라 32px 로 누르면 삐져나온다 — 그 부모
        //   Grid 에 reasonDetailCell 표식을 달아 [class*="reasonDetailCell"] 하위를 제외한다(reasonDetailField 는
        //   입력칸에만 있어 셀 셀렉터로 못 잡음 · emotion :has 미사용, 2026-11-12). body & 로 특이성을 올려 DS 를 이긴다.
        'body & .MuiGrid-root:not([class*="reasonDetailCell"]) > [class*="_formItem"]': {
          minHeight: '32px !important',
          height: '32px !important',
        },
        // 멀티라인(Reason Detail) 셀 높이 — 32px press 에서 제외만 하면(height:auto) 상·하 여유가 0 이 돼
        //   위·아래 행(Change Reason / Reject Reason)과 간격 없이 붙는다(사용자 신고 2026-11-13). 자매 SSP0200/0201 은
        //   Reason Detail 이 폼 마지막 행이라 아래가 비어 안 드러났지만, SSP0003 은 그 밑에 Reject Reason 이 한 행 더
        //   있어 드러난다. _formItem 은 align-items:center 라 셀을 키운 만큼 label·textarea 가 함께 세로 중앙으로
        //   내려와, 60px 로 주면 위 행(Change Reason) label 과의 간격이 다른 행(32px) 리듬보다 벌어져 보인다
        //   (사용자 신고 2026-11-13). 2줄 textarea 자체 높이(~56px)에 맞춰 56px 로 꽉 채워 상·하 여유를 없애면
        //   위 label 과의 간격이 다른 행들과 같아진다(자매 SSP0200/0201 실측 reasonDetailCell ~55.99px 와 일치).
        //   body & 로 특이성을 올려 DS 를 이긴다.
        'body & [class*="reasonDetailCell"] > [class*="_formItem"]': {
          minHeight: '56px !important',
          height: '56px !important',
        },
        // Title 라벨 트랙 축소(사용자 지시 2026-11-13) — _formItem 기본 minmax(70px,140px) 는 라벨이
        //   140px 까지 확장돼 입력칸을 과하게 먹는다. titleCell 에서만 72px 고정으로 좁혀 라벨을 줄이고,
        //   auto 인 입력칸(텍스트박스)이 그만큼 넓어진다. body & 로 특이성을 올려 DS 기본을 이긴다.
        'body & [class*="titleCell"] > [class*="_formItem"]': {
          gridTemplateColumns: '72px auto !important',
        },
        // 단행 입력칸 높이 36px -> 28px(사용자 지시 2026-11-12, 자매 SSP0200/0201 과 두께를 맞춘다 — 30 에서
        //   28 로 추가 축소). 방해 규칙 `body ._formItem_… .MuiOutlinedInput-root { height:36px !important }`
        //   와 둘 다 !important 라 특이성으로 이겨야 한다 — _formItem 해시를 [class*="_formItem"] 속성셀렉터로
        //   끼워 특이성을 올려 소스순서와 무관하게 확정 승리시킨다(SSP0200 VDI 실사고 선례 —
        //   [[emotion-important-order-dep-vs-specificity]]). 멀티라인(Reason Detail)은 제외해야 하는데 emotion
        //   sx 에서 :has() 는 스타일시트에 삽입되지 않아(실측 2026-11-12) 안 먹는다 — Reason Detail 에
        //   reasonDetailField 클래스를 달고 [class*="reasonDetailField"] 속성셀렉터로 제외한다(:has 미사용).
        'body & .MuiTextField-root:not([class*="reasonDetailField"])': {
          height: '28px !important',
          minHeight: '28px !important',
        },
        // 자매 SSP0200(RequestInfoPanel)과 셀렉터를 1:1 로 맞춘다 — :not(.MuiAutocomplete-inputRoot) 를
        //   추가해 특이성을 (0,5,1)->(0,6,1, & 치환 포함)로 올리고, SSP0200 이 VDI 에서 검증된 정답이므로
        //   같은 셀렉터·특이성이면 SSP0003 도 번들 주입순서와 무관하게 28px 로 확정 승리한다
        //   ([[emotion-important-order-dep-vs-specificity]], VDI 전용 간격붕괴 수렴 2026-11-13).
        'body & [class*="_formItem"] .MuiInputBase-root:not(.MuiInputBase-multiline):not(.MuiAutocomplete-inputRoot)':
          {
            height: '28px !important',
            minHeight: '28px !important',
          },
        'body & .MuiInputBase-root:not(.MuiInputBase-multiline):not(.MuiAutocomplete-inputRoot)': {
          height: '28px !important',
          minHeight: '28px !important',
        },
      }}
    >
      {/* 섹션 헤더 'Request Confirm Detail' 은 사용자 지시(2026-11-12)로 삭제됨 — 첫 행은 Request No 부터 시작한다
          (2026-10-08 이식했던 usrLabel2 장식 라벨을 다시 제거). */}

      {/* 1행: Request No + Title + Change Reason (사용자 지시 2026-11-13 — 첫 줄에 3개).
          size 2+3+3 = 8 로, 아래 Requestor/Dept Name(size4+size4=8) 입력 블록과 가로 폭을 정확히 맞춘다
          (사용자 지시 2026-11-13 — 브라우저 폭이 바뀌어도 그리드 비율로 따라가 오른쪽 끝이 아래 Dept Name
          끝과 늘 정렬된다). 뒤 빈칸 size 4 로 12 를 채운다. 종전 비대칭 트릭(Title marginLeft -6.25%,
          Change Reason input 57%, Request No input 75%, label 고정폭)은 % 기반이라 리사이즈 시 어긋나
          정렬이 왔다갔다 해(사용자 신고 2026-11-13) 전부 제거하고 순수 그리드 비율로 정렬한다.
          Request No size3 + Title size3 + Change Reason size2. 라벨 트랙은 전부
          DS 기본(minmax(70px,140px))이라 Request No 라벨 높이·폭이 아래 Requestor 와 동일하다. */}
      {/* Request No (읽기전용) */}
      <Grid size={3}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.REQUEST_NO, '_Request No')}
          labelAlign='right'
          render={() => <InputField size='small' fullWidth disabled value={detail.requestNo} />}
        />
      </Grid>

      {/* Title (읽기전용) — titleCell 표식: 라벨 트랙을 DS 기본(minmax(70px,140px))보다 좁은 72px 고정으로
          눌러 라벨폭을 줄이고, auto 인 입력칸이 그만큼 넓어진다(사용자 지시 2026-11-13). panel sx 에서 지정. */}
      <Grid size={3} className='titleCell'>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.TITLE, '_Title')}
          labelAlign='right'
          render={() => <InputField size='small' fullWidth disabled value={detail.title} />}
        />
      </Grid>

      {/* Change Reason (읽기전용) — AS-IS 도 콤보가 아니라 TextBox 다(승인자 화면이라 표시전용).
          오른쪽 끝이 size3+size3+size2=col8 로 아래 Dept Name 끝(col8)과 정렬된다. */}
      <Grid size={2}>
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

      {/* Reason Detail (읽기전용) — 전폭. AS-IS `txtReasonDetail.Multiline = true`.
          자매 SSP0200(RequestInfoPanel) 과 동일 방식으로 상자 높이·동작을 맞춘다(사용자 지시 2026-11-13):
          height={56} 로 상자를 2줄 높이로 직접 고정하고, textarea 를 height:100%·minHeight:0·overflow:auto 로
          칸 안에 가둔다. design-system 이 textarea 입력에 minHeight 72px 를 강제하므로 rows 만으로는 상자가
          2줄로 안 줄어 sx 로 바닥값을 푼다 — height 로 직접 56px 를 주는 SSP0200 방식이 더 확정적이다.
          className='reasonDetailCell' — 부모 Grid 에 표식을 달아, 단행 FormItem 셀을 32px 로 눌러 행 간격을
          맞추는 panel sx 규칙(_formItem 셀 높이)이 이 멀티라인 셀을 건드리지 않게 제외한다(:has 미사용
          우회 — reasonDetailField 는 입력칸에만 있어 셀 셀렉터로는 못 잡는다, 2026-11-12, 자매 SSP0200/0201 과 동일). */}
      <Grid size={8} className='reasonDetailCell'>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.REASON_DETAIL, '_Reason Detail')}
          labelAlign='right'
          render={() => (
            <InputField
              type='textarea'
              fullWidth
              height={56}
              disabled
              // 멀티라인 제외 표식 — panel sx 의 단행 28px 규칙이 이 칸을 건드리지 않도록
              //   [class*="reasonDetailField"] 로 제외한다(:has 미사용 우회, 2026-11-12).
              className='reasonDetailField'
              value={detail.reasonDetail}
              sx={{
                '& .MuiInputBase-root': { height: '100%' },
                '& textarea': {
                  height: '100% !important',
                  minHeight: '0 !important',
                  overflow: 'auto !important',
                },
              }}
            />
          )}
        />
      </Grid>

      <Grid size={4} />

      {/* Reject Reason — 유일 입력 필드(반려/자기반려 사유, §2-C3). 행 선택 전에는 비활성.
          AS-IS 는 이 칸만 ReadOnly 가 아니고, Multiline 도 없어 단행이다.
          길이 제한 150: 저장 SP(PKG_SSP0003 P_SSP0003_SAVE_REQ_CONFIRM BODY:2007)가 입력 사유를
          per-row SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE.ATTRIBUTE3(VARCHAR2(150 CHAR), AS-IS nvarchar(150)
          동일)에 직접 쓴다. 공용 InputField 기본 maxLength 500 이면 151~500 자에서 ORA-12899 로
          저장 실패(사용자 신고 2026-11-02). limited 로 입력 자체를 DB 컬럼 길이에 맞춘다. */}
      {/* Reject Reason 행만 위로 살짝 띄운다(사용자 지시 2026-11-13) — 위 Reason Detail 과 찰싹 붙어
          보여 mt 로 간격을 준다. 다른 행은 container 가 rowSpacing 0 + paddingTop 0 이라 붙어 있어도
          이 행만 marginTop 으로 분리한다(paddingTop 0 !important 규칙과 충돌 없이 margin 으로 띄움). */}
      <Grid size={8} sx={{ mt: '6px' }}>
        <FormItem
          className={commonStyles.formItem}
          label={t(LBL.REJECT_REASON, '_Reject Reason')}
          labelAlign='right'
          render={() => (
            <InputField
              size='small'
              fullWidth
              limited={150}
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
