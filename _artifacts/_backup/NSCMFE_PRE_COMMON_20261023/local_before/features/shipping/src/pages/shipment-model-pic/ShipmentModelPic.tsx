import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { CRUD_MSG } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SsoUserModal, SubTitle } from '@shared/components';
import {
  useSaveWithValidation,
  useTabBtnPermissions,
  useTabComboQueryResults,
  useTabProcQuery,
} from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ShipmentModelPicForm } from './components/ShipmentModelPicForm';
import { ShipmentModelPicGrid } from './components/ShipmentModelPicGrid';
import { useShipmentModelPicValidation } from './hooks/useShipmentModelPicValidation';
import {
  COMBO,
  MENU_ID,
  MSG,
  SAVE_RESULT,
  SHEETS,
  USER_POPUP_NAME_COLUMN,
} from './shipment-model-pic.constants';
import type { MainRow, SaveRequest, SaveResultRow } from './shipment-model-pic.types';
import styles from './ShipmentModelPic.module.scss';
import { useShipmentModelPicStore } from './useShipmentModelPicStore';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// AS-IS GSCM.SSP.Plan.UIL SSP0014_ShipmentModelPIC — 단일 그리드(spdMain) Shipment Model PIC.
//   설계: .atlas/gscm-design/SSP0014/design/00~03. 상세 매핑: __asis-mapping__.md.
//   편집 상태기계: 조회=전체 lock(뷰) -> Edit(SwitchLock)=편집진입 -> Save 성공 후 뷰 복귀.
//   Insert/Delete = NO-OP(cs:254/259 override 주석) -> 툴바 Search/Save/Edit 만.
export const ShipmentModelPic = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  const sessionUserId = useSessionStore(s => s.session.userId);
  const langCd = useSessionStore(s => s.session.langCd);
  const { saveWithValidation } = useSaveWithValidation();
  const { checkUsersRegistered } = useShipmentModelPicValidation();

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker>();
  const savingRef = useRef(false);
  // 이미지셀 팝업 대상 셀(더블클릭한 행/컬럼) 기억 — 팝업 setSelectedValue 가 이 셀에 write.
  const popupTargetRef = useRef<{ row: Record<string, unknown>; binding: string } | null>(null);

  const sc = useShipmentModelPicStore(s => s.searchCondition);
  const setSearchCondition = useShipmentModelPicStore(s => s.setSearchCondition);
  const filters = useShipmentModelPicStore(s => s.filters);
  const setFilter = useShipmentModelPicStore(s => s.setFilter);
  const clearFilters = useShipmentModelPicStore(s => s.clearFilters);
  const openSearchArea = useShipmentModelPicStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentModelPicStore(s => s.setOpenSearchArea);
  const staticColumns = useShipmentModelPicStore(s => s.staticColumns);
  const fetchStaticColumns = useShipmentModelPicStore(s => s.fetchStaticColumns);
  const initialized = useShipmentModelPicStore(s => s.initialized);
  const staticColumnsError = useShipmentModelPicStore(s => s.staticColumnsError);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  // AS-IS 는 팝업·편집을 `siMain.IsLock(SheetName)==false` 단일 가드로 묶는다(cs:628). 편집모드 토글은
  //   미이식이므로(convert-core §2.4) 그 가드를 **권한축**으로 치환한다 — `EDIT` 는 API 없이 권한만
  //   등록된 버튼이다(`SCM_ADM_MNU_BTN_MPG_M` main/EDIT, API_ID NULL 실측. design 00 §4d-4).
  //   "조회모드면 차단" 형태로 옮기면 편집 기본 ON 에서 기능이 영구 차단된다(design 03 §3 R4 경고).
  const canEdit = hasButton('EDIT');
  const [openItem, setOpenItem] = useState(false);
  const [openUser, setOpenUser] = useState(false);
  const noAuthAlertedRef = useRef(false);
  const metaErrorAlertedRef = useRef(false);
  // B-2 — 저장 진행 표시. ref 는 재진입 차단용(동기 판정), state 는 그리드 잠금 렌더용.
  const [saving, setSaving] = useState(false);
  // 편집 가능 실효 조건 = EDIT 권한 ∧ 저장중 아님 ∧ 컬럼메타 신뢰 가능.
  //   메타 실패(B-6) 시에도 잠근다 — INPUT_TP_CD 를 모르면 편집 가부·필수검증이 둘 다 무근거가 된다.
  const canEditNow = canEdit && !saving && !staticColumnsError;

  // Division 콤보(MyDivision) — 권한 Division 0건 게이트용으로 페이지가 직접 구독한다.
  //   같은 queryKey 라 Form 의 조회와 중복 호출되지 않는다(react-query 캐시). 자매 delegate 동일 패턴.
  const [divisionResult] = useTabComboQueryResults({
    filters: [{ comboId: COMBO.DIVISION, mnuId: MENU_ID }],
  });
  // CMBO SQL 이 이미 ATTRIBUTE3<>'EE' 로 거르고 CODE/NAME 만 반환하므로 아래 필터는 방어용 no-op
  //   이다(AS-IS @Code='MyDivision' 본문에도 A.ATTRIBUTE3 <> 'EE' 존재 — asis.py 실측 2026-09-28).
  // 정렬: AS-IS 는 SP `ORDER BY ATTRIBUTE1` 뒤 C# 이 .OrderBy(CODE) 로 덮어쓴다(DataService.cs:5210).
  const divisionOptions = useMemo(
    () =>
      (divisionResult?.data ?? [])
        .filter(r => str(r.ATTRIBUTE3) !== 'EE')
        .map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }))
        .sort((a, b) => a.value.localeCompare(b.value)),
    [divisionResult?.data]
  );
  // AS-IS cs:178-179 `if (dtMyDivision.Rows.Count == 0) SetDivisionAuthCheck(usrLayoutControl2)`
  //   → BF:5269-5277 조회조건 전체 Enabled=false + 경고. 로딩중(isPending)과 0행을 구분해야
  //   초기 1프레임 오탐이 없다(design 01 §2 R2).
  // "권한 없음" 은 **정상 응답인데 0건**일 때만이다. 로딩중(isPending)·오류(isError)는 권한 없음이
  //   아니다 — 오류를 0건으로 취급하면 네트워크 실패가 "권한 없음" 안내로 잘못 나간다(A-4 재확인).
  const divisionErrored = !!divisionResult?.isError;
  const noAuth = !divisionResult?.isPending && !divisionErrored && divisionOptions.length === 0;
  // 콤보가 신뢰 가능한 상태(정상 응답)인지 — 조회 게이트와 초기값 보정이 이 값을 본다.
  const divisionReady = !divisionResult?.isPending && !divisionErrored;

  // R2 — 무권한이면 안내 1회. MSG00667="권한을 가진 Division이 없습니다."(MSG00097 재사용 금지 —
  //   TO-BE MSG00097 은 "Please select Division." 로 조회 필수 축이다).
  useEffect(() => {
    if (noAuth && !noAuthAlertedRef.current) {
      noAuthAlertedRef.current = true;
      void setAlert({
        type: 'alert',
        content: t(MSG.NO_DIVISION_AUTH, '_No authority assigned.'),
      });
    }
  }, [noAuth, setAlert, t]);

  // B-4 — 초기값 보정(clamp). 기본 divisionId 는 세션 division 후보인데, 권한 목록에 없으면
  //   CustomDropdown 은 값을 clamp 하지 않아 "콤보는 비어 보이는데 조회는 그 값으로 나가는" 상태가 된다.
  //   콤보가 **정상 로드된 뒤에만** 판정하고(로딩중 보정 금지 — 매 진입 첫 프레임에 값이 날아간다),
  //   목록에 없으면 첫 옵션으로 바꾸고 From Site 선택을 초기화한다(division 종속 cascade).
  //   목록에 있는 세션값은 그대로 둔다. 0건이면 빈값 — 이때는 noAuth 게이트가 조회를 막는다.
  useEffect(() => {
    if (!divisionReady) return;
    if (sc.divisionId && divisionOptions.some(o => o.value === sc.divisionId)) return;
    const next = divisionOptions[0]?.value ?? '';
    if (next === sc.divisionId) return;
    setSearchCondition({ divisionId: next, fromSiteIds: [] });
  }, [divisionReady, divisionOptions, sc.divisionId, setSearchCondition]);

  // 보정이 끝났는지 — 끝나기 전에는 조회를 막는다(목록 밖 값으로 GET 이 나가는 것을 원천 차단).
  const divisionSettled =
    divisionReady && (!sc.divisionId || divisionOptions.some(o => o.value === sc.divisionId));

  // B-6 — 컬럼 메타 로드 실패 안내 1회. 정상 0건(미등록)은 fallback 이 정답이라 안내하지 않는다.
  useEffect(() => {
    if (staticColumnsError && !metaErrorAlertedRef.current) {
      metaErrorAlertedRef.current = true;
      void setAlert({
        type: 'alert',
        content: t(MSG.INQUIRY_ERROR, '_An error has occurred when inquiring.'),
      });
    }
    if (!staticColumnsError) metaErrorAlertedRef.current = false;
  }, [staticColumnsError, setAlert, t]);

  // A-4 보강 — 콤보 요청 자체가 실패한 경우의 안내(권한 없음과 다른 문구).
  useEffect(() => {
    if (divisionErrored && !noAuthAlertedRef.current) {
      noAuthAlertedRef.current = true;
      void setAlert({
        type: 'alert',
        content: t(MSG.INQUIRY_ERROR, '_An error has occurred when inquiring.'),
      });
    }
  }, [divisionErrored, setAlert, t]);

  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    // A-3 — 자동조회(keep-alive 재마운트 포함)도 조회 게이트를 탄다. filters 만 보면 권한이 없거나
    //   보정 전인 상태에서도 GET 이 발사된다(권한 없는 계정의 GET 0회 요구).
    enabled:
      !!filters[SHEETS.MAIN] && hasButton('SEARCH') && divisionSettled && !noAuth && !saving,
  });

  const rows = useMemo<MainRow[]>(() => data?.o_rc1 ?? [], [data]);

  // FROM_SITE 콤보 dataMap(code->name, PlantSiteByDivision @divisionId)은 **현재 로드된 데이터의
  //   division** 기준이어야 한다. 조회조건 division(sc.divisionId)에 바로 묶으면, 조회 후 division
  //   드롭다운만 바꿔도 콤보가 새 division 사이트맵으로 갈아엎어져 이미 로드된(옛 division) 행의
  //   FROM_SITE 가 name 을 못 찾아 코드로 보인다. 조회 시점에 확정된 filters 의 division 을 쓴다
  //   (조회 전엔 행이 없으므로 sc.divisionId fallback). 실제 재조회 때만 filters 가 바뀌어 맵·행이 함께 갱신된다.
  const gridDivision = filters[SHEETS.MAIN]?.divisionId ?? sc.divisionId;

  useEffect(() => {
    // 진입 자동조회 금지 — keep-alive 잔여 filters 무효화(§5-7) + 컬럼메타 1회 fetch.
    clearFilters();
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  const handleSearch = () => {
    // A-3 — 조회 진입점이 여럿이라(SubTitle F5 / SearchArea 버튼·F5 / Model·User Enter / 저장 후 refetch)
    //   공통 함수 첫 줄에 방어를 모아둔다. 버튼 경로의 권한은 호출측에서 이미 걸리지만, 여기서도
    //   막아야 재마운트·프로그램 호출 경로가 새지 않는다.
    if (!hasButton('SEARCH')) return;
    if (saving) return; // B-2 저장 중 조회 금지(전송값과 화면이 갈린다).
    if (!divisionReady) return; // 콤보 미도착 — 아직 판정 불가.
    if (!divisionSettled) return; // B-4 보정 전 — 목록 밖 값으로 조회 금지.
    // R3 — 조회축 권한 게이트. AS-IS 는 로드축(cs:178)·조회축(DU:397 Items.Count==0) 2중으로 막는다.
    //   한쪽만 구현하면 콤보가 나중에 비는 경우를 놓친다(design 01 §2 R3).
    if (noAuth) {
      void setAlert({
        type: 'alert',
        content: t(MSG.NO_DIVISION_AUTH, '_No authority assigned.'),
      });
      return;
    }
    // 권한 목록 밖 Division 차단 — 기본값이 `session.div` 이고 store 가 탭 단위로 persist 되므로,
    //   권한이 바뀌었거나 다른 화면에서 온 값이 남아 있으면 AS-IS 콤보에는 없는 division 으로 조회가
    //   나갈 수 있다(AS-IS 는 콤보 선택값만 넘길 수 있어 구조적으로 불가능한 경로). GET SP 에도
    //   권한 predicate 가 없어(`PKG_SSP0014` BODY `AND A.DIVISION_ID = V_DIVISION_ID`) FE 가 막아야 한다.
    if (sc.divisionId && !divisionOptions.some(o => o.value === sc.divisionId)) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_DIVISION, '_Please select Division.\', 0: \'Division'),
      });
      return;
    }
    // Division 필수 (design 02 §6, checkRequiredOfSearch cs:300).
    if (!sc.divisionId) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_DIVISION, '__Division is required.\', 0: \'Division'),
      });
      return;
    }
    setFilter();
    void fetchStaticColumns();
  };

  // 이미지셀 팝업(UserInfoPopup) 오픈 — 더블클릭한 셀 기억.
  const handleUserCellDblClick = (row: Record<string, unknown>, binding: string) => {
    popupTargetRef.current = { row, binding };
    setOpenUser(true);
  };

  // 팝업 선택 -> 대상 셀에 UserID SetValue(AS-IS cs:649 등) + EditTracker 'M' 마킹.
  //   ID 컬럼(USER_ID/PART_LEADER/TEAM_LEADER)은 짝 이름 컬럼(USER_NAME 등)도 함께 채운다 —
  //   AS-IS UserInfoPopup 이 선택 시 ID+Name 을 동시에 SetValue 하는 동작 재현(언어별 KO/EN).
  //   이름 컬럼은 조회전용('S')이라 SAVE payload 에는 포함되지 않고 표시 목적으로만 갱신한다.
  const handleUserSelected = (userId: string, userNm: string, userEngNm: string) => {
    const target = popupTargetRef.current;
    const grid = gridRef.current;
    if (!target) return;
    // A-2/B-2 — 팝업이 열려 있는 동안 권한이 회수되거나 저장이 시작됐을 수 있다. 반영 직전 재검사.
    if (!canEdit || savingRef.current || staticColumnsError) {
      popupTargetRef.current = null;
      return;
    }
    const prev = target.row[target.binding];
    if (prev !== userId) {
      editTrackerRef.current?.storeChange(target.row as never, target.binding, prev as never, userId as never);
      target.row[target.binding] = userId;
      const nameCol = USER_POPUP_NAME_COLUMN[target.binding];
      if (nameCol) target.row[nameCol] = (langCd === 'KO' ? userNm : userEngNm) ?? '';
      grid?.invalidate();
    }
    popupTargetRef.current = null;
  };

  // 변경행만 ^-delim CLOB 조립 -> SAVE SP (design 03 §4, DMF0020 handleSave 경로).
  const runSave = async (
    originalRows: Record<string, unknown>[],
    dirty: Record<string, unknown>[]
  ): Promise<void> => {
    {
      // 저장 전 그룹권한 검증(GET_USER_ID_CHECK) — 미통과 시 MSG01261 중단(design 03 §4).
      const check = await checkUsersRegistered(dirty);
      if (!check.ok) {
        if (check.invalidUser) {
          void setAlert({
            type: 'alert',
            // MSG01261 은 `{0}` 단일 중괄호 플레이스홀더라 i18next 보간({{ }})으로는 치환되지
            //   않는다 — 공통 SAVE_SUCCESS 와 동일하게 .replace('{0}', ...) 로 직접 치환한다.
            //   (개행 "\n\r" 은 i18n 로더 unescapeControlChars 가 실제 개행으로 되돌린다.)
            //   fallback 은 EN 등록 문구(KO 문구 하드코딩 금지) — {0} 없으면 replace 는 no-op.
            content: t(MSG.USER_NOT_REGISTERED, {
              defaultValue: 'This user does not have permission to the SSP Planner.',
            }).replace('{0}', check.invalidUser),
          });
        } else {
          // 검증 호출 실패(엔드포인트 미등록/네트워크) — false-success 방지, 저장 중단.
          void setAlert({
            type: 'alert',
            content: t(MSG.SAVE_FAIL, '__Save failed (user check unavailable).'),
          });
        }
        return;
      }

      // 변경행 키(division/from_site/item_id) + 편집값(user/valid/leader/mail) ^-delim 누적.
      const acc: Record<string, string[]> = {
        activeFlag: [],
        divisionId: [],
        fromSite: [],
        itemId: [],
        userId: [],
        validYn: [],
        partLeader: [],
        teamLeader: [],
        mailUser1: [],
        mailUser2: [],
        mailUser3: [],
        mailUser4: [],
        mailUser5: [],
      };
      for (const r of dirty) {
        acc.activeFlag.push(str(r.CRUD_TYPE) || 'M');
        acc.divisionId.push(str(r.DIVISION_ID));
        acc.fromSite.push(str(r.FROM_SITE));
        acc.itemId.push(str(r.ITEM_ID));
        acc.userId.push(str(r.USER_ID));
        acc.validYn.push(str(r.VALID_YN));
        acc.partLeader.push(str(r.PART_LEADER));
        acc.teamLeader.push(str(r.TEAM_LEADER));
        acc.mailUser1.push(str(r.MAIL_USER1));
        acc.mailUser2.push(str(r.MAIL_USER2));
        acc.mailUser3.push(str(r.MAIL_USER3));
        acc.mailUser4.push(str(r.MAIL_USER4));
        acc.mailUser5.push(str(r.MAIL_USER5));
      }
      // createId = SAVE SP P_CREATE_ID(VARCHAR2 단일 스칼라). SP 본문이 CREATED_BY/LAST_UPDATED_BY 에
      //   그대로 넣으므로 '^' 다행 join 금지(다건 저장 시 "user^user" 감사컬럼 오염). AS-IS 도 단일값
      //   p_create_id=UserInfo.UserId(cs:401,507). BE 가 가로채는 createdBy 키명 회피(nscm-patterns §5-11).
      // 명시 필드 객체로 만든다 — Record 조립 + 캐스팅은 키 오타를 컴파일에서 놓친다(B-7).
      const payload: SaveRequest = {
        activeFlag: acc.activeFlag.join('^'),
        divisionId: acc.divisionId.join('^'),
        fromSite: acc.fromSite.join('^'),
        itemId: acc.itemId.join('^'),
        userId: acc.userId.join('^'),
        validYn: acc.validYn.join('^'),
        createId: sessionUserId ?? '',
        partLeader: acc.partLeader.join('^'),
        teamLeader: acc.teamLeader.join('^'),
        mailUser1: acc.mailUser1.join('^'),
        mailUser2: acc.mailUser2.join('^'),
        mailUser3: acc.mailUser3.join('^'),
        mailUser4: acc.mailUser4.join('^'),
        mailUser5: acc.mailUser5.join('^'),
      };

      try {
        const res = await apiClient.post<Record<string, unknown>, SaveRequest>(
          `/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`,
          payload
        );
        // ① 봉투 판정 — false-success 차단(nscm-patterns §5-10). 인터셉터가 500/CODE≠0 도 resolve 할 수 있다.
        if (res.status >= 400 || Number(res.data?.code)) {
          const reason =
            (res.data as { message?: string })?.message?.trim() ||
            t(MSG.SAVE_FAIL, '__Save failed.');
          void setAlert({ type: 'alert', content: reason });
          return; // 편집 유지 — 사용자가 수정 후 재저장.
        }

        // ② A-1 결과커서 판정 — AS-IS 는 저장 응답 첫 값이 'S' 일 때만 성공으로 본다(cs:520~543).
        //   HTTP 200 + code=0 이어도 SP 는 실패했을 수 있다(EXCEPTION 경로도 커서를 열고 정상 반환).
        //   컬럼 **이름**으로 읽는다 — 행의 키 순서는 보장되지 않으므로 "첫 값" 으로 읽으면 안 된다.
        const result = res.data?.result ?? {};
        const cursor = result[SAVE_RESULT.CURSOR_KEY] ?? result[SAVE_RESULT.CURSOR_KEY_LOWER];
        const head = (Array.isArray(cursor) ? cursor[0] : undefined) as SaveResultRow | undefined;
        const code = head?.[SAVE_RESULT.CODE_COLUMN];
        // 커서 부재·빈 배열·상태 공백/이상값은 전부 실패로 본다 — SP 본문이 성공·실패 양 경로에서
        //   반드시 커서를 OPEN 하므로(645·690행) "성공인데 커서 없음" 은 존재하지 않는다.
        if (String(code ?? '').trim().toUpperCase() !== SAVE_RESULT.SUCCESS) {
          const reason =
            head?.ERR_MESSAGE?.trim() ||
            head?.MSG?.trim() ||
            t(MSG.SAVE_FAIL, '__Save failed.');
          void setAlert({ type: 'alert', content: reason });
          return; // 편집·변경표시 유지, 재조회 없음.
        }

        // ③ B-5 성공 안내 — 로케일 문구가 `{0}` 자리표시자라 i18next `{{ }}` 보간으로는 치환되지 않는다.
        //   건수는 실측 컬럼 RESULT_CNT(=V_MAX_LOOP_CNT). 0 도 그대로 표시한다(`|| dirty.length` 금지 —
        //   0 이 전송 행 수로 조용히 바뀌면 "저장 안 됐는데 n건 저장" 이 된다).
        //   주의: RESULT_CNT 의 SP 상 의미는 "처리 루프 상한(=전송 행 수)" 이라 실제 DB 반영 건수와
        //   같다고 단정하지 않는다. 컬럼이 없으면 전송 행 수로 대체한다.
        const rawCnt = head?.[SAVE_RESULT.COUNT_COLUMN];
        const count = rawCnt === undefined || rawCnt === null ? dirty.length : Number(rawCnt);
        void setToast({
          type: 'success',
          message: t(MSG.SAVE_SUCCESS, '_{0} data saved.').replace(
            '{0}',
            String(Number.isFinite(count) ? count : dirty.length)
          ),
        });

        // ④ B-3 저장 확정 후 정리 — 전송한 **원본 행**의 CRUD_TYPE 을 지운다. 남겨두면 재조회가
        //   실패했을 때 이미 저장된 행이 dirty 로 남아 다시 Save 하면 중복 전송된다.
        for (const r of originalRows) delete r.CRUD_TYPE;
        editTrackerRef.current?.clearChanges();

        // ⑤ B-3 재조회 — 마지막 조회조건으로 되읽는다. 실패는 **저장 실패가 아니다**(저장은 커밋됨).
        //   react-query refetch 는 reject 하지 않고 결과 객체로 오류를 알리므로 isError 로 판정한다.
        const re = await refetch?.();
        if (re?.isError) {
          void setAlert({
            type: 'alert',
            content: t(MSG.INQUIRY_ERROR, '_An error has occurred when inquiring.'),
          });
        }
      } catch (e) {
        const msg = e instanceof Error ? e.message : t(MSG.SAVE_FAIL, '__Save failed.');
        void setAlert({ type: 'alert', content: msg });
      }
    }
  };

  // 실제 저장 절차 — 잠금·스냅샷은 호출자(doSave)가 책임진다.
  const doSave = (dirty: Record<string, unknown>[]) => {
    void (async () => {
      // B-1 — 중복 진입 차단은 **USER_CHECK 호출 전**에 세운다. 응답 뒤에 세우면 왕복 동안 Save 를
      //   두 번 눌러 USER_CHECK·SAVE 가 2회 나간다(같은 행이 두 번 저장될 수 있다).
      if (savingRef.current) return;
      savingRef.current = true;
      // B-2 — 저장~후속 재조회가 끝날 때까지 그리드 쓰기(셀·붙여넣기·팝업)와 조회를 잠근다.
      //   잠그지 않으면 "검증한 값" 과 "전송한 값" 이 갈리고, 대기 중 새로 만든 편집이 재조회로 사라진다.
      setSaving(true);
      try {
        // B-2 — 잠근 직후 값 스냅샷. 이후 모든 단계(USER_CHECK·payload)가 **같은 스냅샷**을 쓴다.
        //   dirty 는 그리드 행 객체의 참조라 그대로 쓰면 비동기 사이 변경이 끼어들 수 있다.
        //   원본 참조(dirty)는 저장 성공 후 CRUD_TYPE 정리(B-3)에만 쓴다.
        const snapshot = dirty.map(r => ({ ...r }));
        await runSave(dirty, snapshot);
      } finally {
        savingRef.current = false;
        setSaving(false);
      }
    })();
  };

  const handleSave = () => {
    // A-2 재검사 — 저장 시작 시점의 권한·상태를 다시 본다(버튼 숨김만으로는 단축키·늦은 권한 응답을
    //   못 막는다). SAVE 와 EDIT 을 모두 요구한다 — 편집할 수 없는 사용자의 저장은 성립하지 않는다.
    if (!hasButton('SAVE') || !canEdit) return;
    if (saving) return; // B-1 연타 차단(동기 경로).
    // B-6 — 메타를 못 읽었으면 필수검증이 무근거라 저장을 막는다(검증 없는 저장 금지).
    if (staticColumnsError) {
      void setAlert({
        type: 'alert',
        content: t(MSG.INQUIRY_ERROR, '_An error has occurred when inquiring.'),
      });
      return;
    }
    const grid = gridRef.current;
    grid?.finishEditing();
    const src = (grid?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
    const dirty = src.filter(r => r.CRUD_TYPE);
    if (dirty.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGES, '__No changes to save.') });
      return;
    }
    // A-5 — USER_ID 공백 행 차단. 공용 검증(useSaveWithValidation)은 컬럼 메타가 'M' 일 때만 발동하므로
    //   메타가 0건/fallback 이면 검사 0건이 된다. 담당자 없는 행 저장은 AS-IS 가 공통 필수검증
    //   (cs:393)과 사용자검증(cs:441,574~601) 2중으로 막던 것이라 화면에서도 독립 가드를 둔다.
    //   (Delete 키로 담당자를 비우는 경로는 이 화면에 없다 — iter-2 에서 AS-IS 부재 근거로 제거됨.)
    if (dirty.some(r => !str(r.USER_ID).trim())) {
      void setAlert({
        type: 'alert',
        content: t(CRUD_MSG.REQUIRED_FIELD.id, { defaultValue: CRUD_MSG.REQUIRED_FIELD.fallback })
          .replace('{0}', '[User ID]'),
      });
      return;
    }
    // 공통 필수검증(useSaveWithValidation) 배선 후 doSave — 메타 M/IM 컬럼 자동 차단.
    //   AS-IS checkRequiredOfSpread(cs:393) 등가. SHEET_COLUMNS 실측 USER_ID='M'(라벨 'User ID*')
    //   이라 정상 메타에서는 위 A-5 가드와 이중으로 걸린다(메타 실패 대비 방어가 목적).
    saveWithValidation(dirty, staticColumns[SHEETS.MAIN], doSave);
  };

  // Edit 토글 제거 — 그리드는 조회 직후부터 기본 편집 가능(별도 Edit 진입 없음, 사용자 지시).
  //   Insert/Delete = AS-IS override 공란(no-op) 재현 — 버튼은 노출하되 클릭 시 아무 동작 안 함.
  //     AS-IS: protected override void InsertButton() { //InsertRow(); } / DeleteButton 동일(첨부).
  //   주의: hotkeyConfig 에서 insert/delete 를 생략하면 공용 SubTitle 기본값(addRow/removeRow)이
  //     그대로 살아 버튼이 실제 동작한다 — no-op 로 만들려면 반드시 () => undefined 를 명시한다
  //     (false 로 두면 버튼 자체가 숨는다 — AS-IS 는 버튼 노출 + 무동작이라 no-op 이 정답).
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    // A-2 — 편집 권한이 없거나 아직 권한 응답이 안 왔거나 메타를 못 읽었으면 Save 를 숨긴다.
    //   `canEditNow` 대신 `canEdit`(+메타)만 본다 — 저장 중에는 버튼이 사라지는 대신 handleSave 가
    //   재진입을 막는다(버튼이 깜빡이며 사라지면 사용자가 상태를 오해한다).
    save: hasButton('SAVE') && canEdit && !staticColumnsError ? handleSave : false,
    insert: () => undefined,
    delete: () => undefined,
    manual: false,
    upload: false,
  };

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && (
        <ShipmentModelPicForm
          // A-3 — SEARCH 권한이 없으면 undefined: SearchArea 가 버튼도 F5 도 달지 않는다.
          onSearch={hasButton('SEARCH') ? handleSearch : undefined}
          onItemSearch={() => setOpenItem(true)}
          divisionOptions={divisionOptions}
          // 권한 Division 0건(확정) 또는 콤보 오류일 때만 조회조건 비활성(AS-IS SetDivisionAuthCheck,
          //   design 01 §2 R2). 로딩중(isPending)엔 비활성하지 않는다 — 그래야 새로고침 때 조회조건이
          //   잠깐 disable 됐다 풀리는 깜빡임이 없다("권한 0건" 요건이지 "로딩중"이 아니다). 권한 게이트가
          //   없는 화면(SCP0005 등)과도 정합. 조회 자체는 handleSearch 의 divisionReady/noAuth 가 별도로 막는다.
          disabled={noAuth || divisionErrored}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ShipmentModelPic'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
      />

      <div className={styles.gridWrapper}>
        <ShipmentModelPicGrid
          rows={rows}
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          editTrackerRef={editTrackerRef}
          division={gridDivision}
          adminColumns={staticColumns[SHEETS.MAIN]}
          // B-2/B-6 — 저장 중이거나 컬럼메타를 못 읽은 동안에는 그리드 전체를 잠근다(셀 편집·붙여넣기·
          //   팝업 오픈이 한 번에 막힌다). iter-2 가 세운 isReadOnly 경로를 그대로 쓴다.
          canEdit={canEditNow}
          onUserCellDblClick={handleUserCellDblClick}
          onFocus={() => undefined}
        />
      </div>

      {/* 이미지셀 사용자 검색 — 공용 SsoUserModal (AS-IS UserInfoPopup, SingleSelectYn). */}
      <SsoUserModal
        open={openUser}
        modalClose={() => setOpenUser(false)}
        setSelectedValue={(userId, userNm, userEngNm) => handleUserSelected(userId, userNm, userEngNm)}
        ssoUserYn='N'
      />

      {/* Model/Nickname 검색 — 공용 MaterialByDivisionModal(COM0013, SCP0013 정합, 사용자 지시 2026-10-12).
          종전 ModelByDivisionPopup(SCM0002 Item-by-division)에서 교체. 팝업 행 선택 결과 ITEM_ID(콤마결합)를
          itemId(GET P_ITEM_ID)로 채운다. SSP0014 GET SP 에는 nick_name 파라미터가 없어 nickName 은 서버
          필터로 쓰지 않는다(표시/선택만). 빈 선택이면 기존 입력을 덮지 않는다(AS-IS cs:855 파리티). */}
      <MaterialByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={items => {
          if (items) setSearchCondition({ itemId: items });
        }}
        preSearchParams={{
          divisionId: sc.divisionId,
          scpModuleType: MENU_ID,
          operationGroup: '',
          itemId: sc.itemId,
        }}
      />
    </>
  );
};
