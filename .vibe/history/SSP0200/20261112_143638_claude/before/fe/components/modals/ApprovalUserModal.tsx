import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import { useCallback, useEffect, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import { CustomDialog, DataGrid } from '@shared/components';
import { Button, InputField } from '@shared/lges';
import { useSessionStore } from '@shared/stores';

import { LBL, MENU_ID, SHEETS } from '../../shipment-change-request-plan.constants';

import styles from './ApprovalUserModal.module.scss';

interface Props {
  open: boolean;
  modalClose: () => void;
  /**
   * 선택 사용자 1건 반환 — 공용 SsoUserModal 의 setSelectedValue 와 같은 인자 순서를 유지한다
   * (호출부 배선을 그대로 쓰기 위함). deptNm 은 Dept 텍스트박스 표시, deptId 는 저장용이다.
   */
  setSelectedValue: (
    userId: string,
    userName: string,
    userEngName: string,
    deptNm: string,
    deptId: string
  ) => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

interface ApprovalUserRow {
  USERID: string;
  USERNAME: string;
  USERNAME_E: string;
  DEPT_NAME: string;
  DEPT_ID: string;
}

/**
 * SSP0200 승인자(Approval) 검색 팝업 — AS-IS `SSP0002_UserInfoPopup` 등가.
 *
 * 조회원은 **AS-IS 원본 SP** `PKG_SSP0002.P_SSP0002_GET_USER_INFO_LIST` 다.
 *   AS-IS `FindData()`(cs:176~179)가 FoxDataRequest "SSP.SSP0002_GET_USER_INFO_LIST" 에
 *   Search/Language/SSOUserYN 3건을 넘긴다 -> TO-BE 파라미터 userId/language/ssoUserYn
 *   (`SCM_ADM_PROC_M` COL_NM 실측). 배선은 design/15_register_approval_user_proc.sql(2026-10-06 적용).
 *   선례: 같은 proc 을 쓰는 자매 SSP0024 `useShipmentMasterElectrodeValidation.checkEditPermission`.
 *
 * 주의: 첫 파라미터 이름이 `userId` 지만 SP 실인자는 `P_SEARCH`(검색어)다 — 세션 사용자 ID 가 아니다.
 *   SP 는 ID·한글명·영문명 3컬럼을 OR LIKE 로 훑는다(body L111~114).
 *   검색어는 SP 내부에서 **12자로 절단**된다(`V_SEARCH := SUBSTR(P_SEARCH,1,12)`) — AS-IS 동일.
 *
 * 후보는 권한 그룹 3종으로 한정된다 — SP body L116~117:
 *   `UPPER(USER_GR_ID) IN ('SSP PLANNER','ADMIN','SCM PI ADMIN') AND USE_YN='Y'`(실측 298명).
 *   호출부 주석(cs:3150~3152)은 "SSP Planner 권한만 조회되게 팝업 변경" 이지만 **실제 필터는 3그룹**이다.
 *   권한 판정 조인은 `SCM_ADM_USER_GR_UNIT_AUTH_MPG_M`(AS-IS `TB_FX_UserGroupAuthExtention`)이고
 *   `SCM_ADM_USER_GR_MPG_M`(AS-IS `TB_FX_UserGroupInfo`)이 아니다 — 후자는 AS-IS 가 GrpName 표시용으로만
 *   쓴다. 종전 화면 전용 콤보(`SSP0200_ApprovalUserList`)가 이 테이블을 권한 판정에 써서 집합이 어긋났다.
 *
 * 공용 SsoUserModal 을 쓰지 않는 이유: **AS-IS 가 전사 공용 팝업을 쓰지 않는다.** 사용자 선택 팝업이
 * 도메인별로 나뉘고 SSP 계열 4화면(SSP0002·SSP0050·SSP0200·SSP0201)이 `SSP0002_UserInfoPopup`
 * 하나를 공유한다. 공용 `SsoUserModal`(COM0010)의 SP 분기에는 권한 필터가 없어 전체 사용자
 * (실측 9,197명)를 돌려주고, 반환 컬럼명도 `USER_ID/USER_NM/...` 로 이 SP(`USERID/USERNAME/...`)와 다르다.
 */
// AS-IS 컬럼셋은 `SSOUserYN`/`SingleSelectYn` 분기다(`InitSpread` cs:133~151). SSP0200 호출부는
//   `SSOUserYN=false, SingleSelectYn=true`(cs:3158~3159)라 `!SSOUserYN && !SingleSelectYn` 가 false ->
//   **선택 체크박스·Email·UseYN 3개가 빠진다.** 남는 가시 컬럼은 아래 4열이 전부다(폭도 AS-IS 그대로).
//   DEPT_ID(cs:145, visible=false)는 AS-IS 가 Dept_ID 를 담아 두는 **데이터 운반용 숨김 컬럼**이라
//   TO-BE 에서는 컬럼으로 선언하지 않는다 — itemsSource 행이 이미 값을 들고 있어 숨김 컬럼이 불필요하다.
// 하드코딩 staticColumns 는 `display`·`visible` 을 **둘 다 명시**해야 한다. 하나라도 빠지면
//   그리드가 데이터 컬럼 없이(행번호 열만) 뜬다 — 2026-10-06 실사용 신고 2회의 원인이다.
//   · `display` 누락 -> `DataGrid.tsx:979` 의 `filter(column => column.display)` 에서 전건 탈락
//   · `visible` 누락 -> `columnMapping.ts:701` 이 `visible: undefined` 를 그대로 Wijmo 로 넘기고
//     `Column.visible` 이 falsy 로 해석해 숨긴다. 정규화(`normalizeRequiredMark`)는 기본값을 주지 않는다.
//   admin 메타 경로는 BE 가 DISPLAY_FLAG/VISIBLE_FLAG 로 채워주므로 이 함정이 없다.
//   정본 선례: `features/admin/src/pages/batch-log/batch-log.constants.ts` (둘 다 명시 + horzAlgnCd).
// 남은 과제: 팝업 컬럼 하드코딩 자체가 금지 패턴이다(메모리 popup-grid-columns-admin-meta-not-hardcoded,
//   사용자 지시 2026-09-22). `SCM_MST_SHEET_COLUMNS` 에 팝업 sheetNm 으로 등록해 메타 구동으로 바꿔야 한다.
const POPUP_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'USERID', colLblNm: 'User ID', horzAlgnCd: 'L', colWth: 80, visible: true, display: true },
  {
    colNm: 'USERNAME',
    colLblNm: 'User Name',
    horzAlgnCd: 'L',
    colWth: 120,
    visible: true,
    display: true,
  },
  {
    colNm: 'USERNAME_E',
    colLblNm: 'English Name',
    horzAlgnCd: 'L',
    colWth: 120,
    visible: true,
    display: true,
  },
  {
    colNm: 'DEPT_NAME',
    colLblNm: 'Dept Name',
    horzAlgnCd: 'L',
    colWth: 240,
    visible: true,
    display: true,
  },
];

export const ApprovalUserModal = ({ open, modalClose, setSelectedValue }: Props) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGridType>();
  const [keyword, setKeyword] = useState('');
  const [rows, setRows] = useState<ApprovalUserRow[]>([]);
  const langCd = useSessionStore(s => s.session.langCd);

  /**
   * AS-IS `FindData()`(cs:166~187) 등가. `useTabProcQuery` 를 쓰지 않는 이유는 `procedureAction` 이
   *   `BUTTON_TYPE` 열거로 묶여 있어 `USER_CHECK` 를 표현할 수 없기 때문이다 — `USER_CHECK` 는
   *   `call-proc` 직호출이 프로젝트 표준 경로다(`configs/types/procedures.d.ts:8385` 주석, 자매
   *   SSP0014·SSP0020·SSP0024·SSP0025 전부 동일).
   *
   * 빈 검색어를 **그대로 보낸다** — 콤보 경로와 달리 방어가 필요 없다. SP 는
   *   `V_SEARCH IS NULL OR ... LIKE` 이고 Oracle 은 빈 문자열 = NULL 이라 빈 값이 곧 전체 조회다.
   *   (콤보 경로는 BE `makeComboQuery` 의 `@키` raw 치환이 빈 값으로 유효 리터럴을 못 만들어
   *    `-9994 Sql Error` 가 났고, 그래서 키를 아예 빼는 우회가 필요했다.)
   */
  const findData = useCallback(
    async (search: string) => {
      try {
        const res = await apiClient.post<Record<string, unknown>[]>(
          `/${MENU_ID}/${SHEETS.MAIN}/USER_CHECK/call-proc`,
          { userId: search, language: langCd ?? '', ssoUserYn: 'N' }
        );
        if (res.status >= 400 || Number(res.data?.code)) {
          setRows([]);
          return;
        }
        const result = res.data?.result as { o_rc1?: unknown[] } | unknown[] | undefined;
        const raw = Array.isArray(result) ? result : (result?.o_rc1 ?? []);
        setRows(
          raw
            .filter((r): r is Record<string, unknown> => r != null)
            .map(r => ({
              USERID: str(r.USERID),
              USERNAME: str(r.USERNAME),
              USERNAME_E: str(r.USERNAME_E),
              DEPT_NAME: str(r.DEPT_NAME),
              DEPT_ID: str(r.DEPT_ID),
            }))
        );
      } catch {
        setRows([]);
      }
    },
    [langCd]
  );

  /**
   * 열 때마다 초기 상태로 되돌린다 — AS-IS `Form_Load`(cs:88~98) 등가.
   *   AS-IS 는 `popup.ShowDialog()` 마다 `new SSP0002_UserInfoPopup()` 으로 **새 인스턴스**를 만든다.
   *   SSP0200 호출부(cs:3153~3161)는 초기 검색어를 넘기지 않으므로 **빈 검색어 + 전체 조회**가
   *   연 직후의 정상 상태다. TO-BE 는 컴포넌트가 언마운트되지 않고 `open` 만 토글돼 **직전 검색어와
   *   결과가 그대로 남았다**(2026-10-06 실사용 신고: '이민용' 조회 후 닫았다 열면 그대로 보인다).
   */
  useEffect(() => {
    if (!open) return;
    setKeyword('');
    void findData('');
  }, [open, findData]);

  const handleSelect = () => {
    const g = gridRef.current;
    if (!g) return;
    const row = GridUtils.getRow(g, g.selection?.row ?? -1) as ApprovalUserRow | undefined;
    if (!row) return;
    setSelectedValue(row.USERID, row.USERNAME, row.USERNAME_E, row.DEPT_NAME, row.DEPT_ID);
    modalClose();
  };

  return (
    <CustomDialog
      open={open}
      type='modal'
      position='basic'
      // AS-IS cs:3155~3156 popup.Width=500 / Height=400. **height 를 반드시 준다** —
      //   없으면 다이얼로그가 내용만큼 늘어나 전건 조회 시 하단 버튼이 화면 밖으로 잘린다.
      size={500}
      height={400}
      handleClose={modalClose}
      disableButtonCancel
      disableScale
      title={t(LBL.APPROVAL, '_Approval')}
      customContentArea={
        <div className={styles.dialogContentWrapper}>
          <div className={styles.searchRow}>
            <InputField
              fullWidth
              value={keyword}
              onChange={e => setKeyword(e.target.value)}
              onKeyDown={e => e.key === 'Enter' && void findData(keyword)}
            />
            <Button appearance='contained' priority='primary' onClick={() => void findData(keyword)}>
              {t(LBL.SEARCH, '_Search')}
            </Button>
          </div>
          {/* flex:1 + min-height:0 이라 그리드가 남은 높이만 쓰고 내부 스크롤이 생긴다(SCSS 주석 참조). */}
          <div className={styles.gridWrapper}>
            <DataGrid
              gridRef={gridRef}
              isReadOnly
              itemsSource={rows as unknown as WijmoRowItem[]}
              staticColumns={POPUP_COLUMNS}
              dblClick={handleSelect}
            />
          </div>
          {/* 하단 버튼 — 액션 먼저, 닫기 마지막 (nscm-patterns §3.7).
              AS-IS 는 SingleSelectYn 일 때 OK 버튼을 숨기고 더블클릭만 받지만(cs:116~121),
              웹 모달은 명시 확정 수단이 필요해 Confirm 을 남긴다(더블클릭도 동일 동작). */}
          <div className={styles.buttonWrapper}>
            <Button appearance='contained' priority='primary' onClick={handleSelect}>
              {t(LBL.CONFIRM, '_확인')}
            </Button>
            <Button appearance='outlined' priority='normal' onClick={modalClose}>
              {t(LBL.CANCEL, '_취소')}
            </Button>
          </div>
        </div>
      }
    />
  );
};
