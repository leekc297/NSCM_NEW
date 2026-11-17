import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SsoUserModal, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useTabBtnPermissions, useTabComboQueryResults, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { DelegateForm } from './components/DelegateForm';
import { DelegateGrid } from './components/DelegateGrid';
import {
  BTN,
  COMBO,
  DELEGATED_COLUMNS,
  DELEGATE_COLUMNS,
  MENU_ID,
  MSG,
  SHEETS,
} from './delegate.constants';
import styles from './Delegate.module.scss';
import type { DelegatedRow, DelegateRow } from './delegate.types';
import { useDelegateValidation } from './hooks/useDelegateValidation';
import { useDelegateStore } from './useDelegateStore';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// yyyymmdd — 날짜 표시문자열('2026-09-22' 등)의 숫자만 8자리 추출.
const toYmd = (v: unknown): string => str(v).replace(/\D/g, '').slice(0, 8);

// "이름(id)" 표시문자열의 괄호 안 id 파싱 (AS-IS UNSET 키 도출, design 03 §4-4). raw hidden 키가
//   없을 때만 사용 — DELEGATEE 는 hidden DELEGATEE_ID 우선, LAST_UPDATED_BY 는 표시문자열만이라 파싱.
const parseIdInParen = (v: unknown): string => {
  const s = str(v);
  const l = s.lastIndexOf('(');
  const r = s.lastIndexOf(')');
  return l >= 0 && r > l ? s.slice(l + 1, r) : s;
};

// AS-IS GSCM.SSP.Plan.UIL SSP0020_Delegate — 위임 설정(Delegate/Delegated List 2시트).
//   설계: .atlas/gscm-design/SSP0020/design/00~03,07. 상세 매핑: __asis-mapping__.md.
//   GET(2커서)/SAVE/UNSET/USER_CHECK SP = PKG_SSP0020 (2026-10-15 실측: PACKAGE/BODY VALID,
//   멤버 4종 배포 + SCM_ADM_PROC_M 등록 완료 — 설계문서의 "MISSING" 서술은 낡았다).
//   조회=SubTitle SEARCH(+SearchArea Search). 저장/해제=SearchArea SAVE/UnSet(툴바 Insert/Delete/Save 숨김).
export const Delegate = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  const langCd = useSessionStore(s => s.session.langCd);
  const { validateSave, searchDelegatee } = useDelegateValidation();

  const delegateGridRef = useRef<FlexGrid>();
  const delegatedGridRef = useRef<FlexGrid>();
  const delegateFilterRef = useRef<FlexGridFilter>();
  const delegatedFilterRef = useRef<FlexGridFilter>();
  const savingRef = useRef(false);
  const allCheckedInitRef = useRef(false);
  const noAuthAlertedRef = useRef(false);

  const input = useDelegateStore(s => s.input);
  const setInput = useDelegateStore(s => s.setInput);
  const filters = useDelegateStore(s => s.filters);
  const setFilter = useDelegateStore(s => s.setFilter);
  const clearFilters = useDelegateStore(s => s.clearFilters);
  const openSearchArea = useDelegateStore(s => s.openSearchArea);
  const setOpenSearchArea = useDelegateStore(s => s.setOpenSearchArea);
  const activeSheet = useDelegateStore(s => s.activeSheet);
  const setActiveSheet = useDelegateStore(s => s.setActiveSheet);
  const staticColumns = useDelegateStore(s => s.staticColumns);
  const fetchStaticColumns = useDelegateStore(s => s.fetchStaticColumns);
  const initialized = useDelegateStore(s => s.initialized);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const [openUser, setOpenUser] = useState(false);

  // Division 콤보 (MyDivisionInEE_SCP — EE 포함·권한필터·ALL 없음). @sesUserId/@mnuId 세션·자동.
  const [divisionResult] = useTabComboQueryResults({
    filters: [{ comboId: COMBO.DIVISION, mnuId: MENU_ID }],
  });
  // AS-IS InitControls(cs:137) — 콤보 MyDivisionInEE_SCP 는 SP 레벨에서 EE(전극) division 을 포함하나,
  //   화면이 바인딩 직전 `dtMyDivision.Where(CODE != "EE")` 로 EE 를 클라에서 제외한다. 이 후처리 필터는
  //   이관 CMBO SQL 에 없어(Roslyn filterCalls 가 인라인 LINQ 를 놓쳐 "EE 포함"으로 오판정 — design 02
  //   §2.1/§6·03 §0) convert-core §2.6/AGENT.md 규칙3 대로 화면에서 재현한다. 무권한 판정(hasDivisionAuth/
  //   noAuth)도 EE 제외 후 집합 기준이다(cs:139 dtMyDivision.Rows.Count==0 → AS-IS MSG00097
  //   = TO-BE MSG00667).
  // useMemo — divisionResult?.data ?? [] 는 매 렌더 새 배열이라 아래 useMemo 들의 deps 가 불안정.
  const divisionRows = useMemo(
    () => (divisionResult?.data ?? []).filter(r => str(r.CODE) !== 'EE'),
    [divisionResult?.data]
  );
  const divisionOptions = useMemo(
    () => divisionRows.map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) })),
    [divisionRows]
  );
  const allDivisionCodes = useMemo(() => divisionRows.map(r => str(r.CODE)), [divisionRows]);
  // R3 — 권한 division(EE 제외 0건) 없으면 헤더 폼 disable + 무권한 안내 (design 01 §2 R3).
  const hasDivisionAuth = !divisionResult?.isPending && divisionOptions.length > 0;
  const noAuth = !divisionResult?.isPending && divisionOptions.length === 0;

  // GET(2커서): sheetName=Delegate 로 1회 호출 → o_rc1(Delegate) + o_rc2(Delegated List).
  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.DELEGATE>({
    menuId: MENU_ID,
    sheetName: SHEETS.DELEGATE,
    tabId,
    filters: filters[SHEETS.DELEGATE],
    enabled: !!filters[SHEETS.DELEGATE],
  });
  const delegateRows = useMemo<DelegateRow[]>(() => data?.o_rc1 ?? [], [data]);
  const delegatedRows = useMemo<DelegatedRow[]>(() => data?.o_rc2 ?? [], [data]);

  useEffect(() => {
    // 진입 자동조회 금지 — keep-alive 잔여 filters 무효화(§5-7) + 컬럼메타 1회 fetch(2시트).
    clearFilters();
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // R5 — 최초 진입 시 "All"(권한 division 전건) 체크 (design 01 §2 R5, 03 §3 chkAll).
  useEffect(() => {
    if (allCheckedInitRef.current) return;
    if (allDivisionCodes.length === 0) return;
    allCheckedInitRef.current = true;
    if (input.divisionIds.length === 0) setInput({ divisionIds: allDivisionCodes });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [allDivisionCodes]);

  // R3 — 무권한이면 안내 1회 (design 01 §2 R3, BaseForm.SetDivisionAuthCheck).
  //   AS-IS MSG00097("권한을 가진 Division이 없습니다") = TO-BE MSG00667. "Division 을 선택하세요"
  //   (TO-BE MSG00097)를 쓰면 선택할 Division 이 없는 사용자에게 엉뚱한 안내가 된다.
  useEffect(() => {
    if (noAuth && !noAuthAlertedRef.current) {
      noAuthAlertedRef.current = true;
      void setAlert({
        type: 'alert',
        content: t(MSG.NO_DIVISION_AUTH, 'No authority assigned.'),
      });
    }
  }, [noAuth, setAlert, t]);

  const handleSearch = () => {
    // GET 은 입력영역과 무관(p_user_id/p_language) — 명시 Search 게이트로 발사(design 02 §5, §5-7).
    setFilter();
    void fetchStaticColumns();
  };

  // btnDelegatee 팝업 선택 → Delegatee 필드 + 확정 id 세팅 (design 02 §4.6).
  const handleUserSelected = (userId: string, userNm: string, userEngNm: string) => {
    const name = (langCd === 'KO' ? userNm : userEngNm) || userId;
    setInput({ delegatee: name, delegateeId: userId });
  };

  // 위임 저장 (btnSave → SaveData → SAVE_DELEGATE, design 03 §4-3).
  const handleSave = () => {
    void (async () => {
      if (savingRef.current) return;

      // 위임자 실존 검증(UserName_Search, cs:341/776-817). 팝업(SsoUserModal SingleSelect)이 유효 id 를
      //   보장하는 경우는 AS-IS 의 이름 재검색을 생략한다(의도적 차이 — 확정 id 가 이름 재검색보다 견고).
      //   수기입력(팝업 미경유)이면 AS-IS 그대로: 1건 통과 / 다건 MSG00302 / 0건 MSG00301 로 검색창 유도.
      let delegateeId = input.delegateeId;
      if (!delegateeId && input.delegatee.trim()) {
        const found = await searchDelegatee(input.delegatee);
        if (found.status === 'one') {
          delegateeId = found.userId;
          setInput({ delegateeId: found.userId });
        } else if (found.status === 'many' || found.status === 'none') {
          // AS-IS: 다건=MSG00302 / 0건=MSG00301 "검색창 여시겠습니까?" Yes → 팝업 오픈.
          const key = found.status === 'many' ? MSG.DELEGATEE_MULTI : MSG.DELEGATEE_NOTFOUND;
          const def =
            found.status === 'many'
              ? 'This is a multiple-searched User. Open search box?'
              : 'No user were found. Open search box?';
          const openIt = await setAlert({ type: 'confirm', content: t(key, { defaultValue: def }) });
          if (openIt) setOpenUser(true);
          return;
        } else {
          // 호출 실패(네트워크·권한 등) — 검증 불가로 저장 중단(false-success 방지).
          void setAlert({
            type: 'alert',
            content: t(MSG.EXEC_ERROR, 'Error occurred during execution.'),
          });
          return;
        }
      }

      // Validation_Check (298/305/134/219/097/105/296/297) — rs1 hidden 키로 중첩 판정 (design 03 §4-3).
      const v = validateSave({ ...input, delegateeId }, delegateRows);
      if (!v.ok) {
        // 동적 key(v.msgKey) — 일반 string key 오버로드는 defaultValue 를 2번째 위치 인자(string)로 받는다.
        void setAlert({ type: 'alert', content: t(v.msgKey ?? '', v.msgDefault ?? '') });
        return;
      }

      // AS-IS BtnSave_Click(cs:352)은 확인 다이얼로그 없이 SaveData 직접 호출 — 저장 confirm 없음.
      // SAVE_DELEGATE payload — division ^-join(다중) × delegatee × period (design 03 §4-3).
      //   COL_NM(camelCase) = PROC_M 계약(P_ 제거 + snake→camel). p_user_id 는 BE 세션 주입.
      const payload = {
        divisionId: input.divisionIds.join('^'),
        delegateeId,
        fromDate: input.fromDate,
        toDate: input.toDate,
        language: langCd ?? '',
        debugMode: 'F',
      };

      savingRef.current = true;
      try {
        const res = await apiClient.post<Record<string, unknown>>(
          `/${MENU_ID}/${SHEETS.DELEGATE}/${BTN.SAVE}/call-proc`,
          payload
        );
        // false-success 차단(§5-10) — 인터셉터가 500/CODE≠0 도 resolve 할 수 있다.
        if (res.status >= 400 || Number(res.data?.code)) {
          const reason =
            (res.data as { message?: string })?.message?.trim() ||
            t(MSG.EXEC_ERROR, 'Error occurred during execution.');
          void setAlert({ type: 'alert', content: reason });
          return;
        }
        // MSG00672='{0} data saved.' 의 {0} 는 i18next 보간자({{ }})가 아니라 수동 치환 대상이다
        //   (자매 선례 ShipmentChangeRequest.tsx — t() 의 보간 options 로 넘기면 치환되지 않는다).
        void setToast({
          type: 'success',
          message: t(MSG.SAVE_SUCCESS, { defaultValue: '{0} data saved.' }).replace(
            '{0}',
            String(input.divisionIds.length)
          ),
        });
        void refetch?.();
      } catch (e) {
        const msg =
          e instanceof Error ? e.message : t(MSG.EXEC_ERROR, 'Error occurred during execution.');
        void setAlert({ type: 'alert', content: msg });
      } finally {
        savingRef.current = false;
      }
    })();
  };

  // 현재 Delegate 그리드의 CHK 선택행(Selector row.isSelected) 수집.
  const collectChecked = (): DelegateRow[] => {
    const grid = delegateGridRef.current;
    if (!grid) return [];
    const out: DelegateRow[] = [];
    for (const r of grid.rows) if (r?.isSelected) out.push(r.dataItem as DelegateRow);
    return out;
  };

  // 위임 해제 (btnUnSet → UnSet → SAVE_UNSET, design 03 §4-4). Delegate 시트 CHK 선택행 soft-delete.
  const handleUnset = () => {
    void (async () => {
      if (savingRef.current) return;
      // 사전조건: 활성시트 행 존재 + CHK 선택 ≥1 (R9, cs:549/576). 미선택 시 MSG00300.
      if (delegateRows.length === 0) return;
      const checked = collectChecked();
      if (checked.length === 0) {
        void setAlert({
          type: 'alert',
          content: t(MSG.UNSET_NONE_SELECTED, 'Please select it from the list and unset it.'),
        });
        return;
      }

      // AS-IS BtnUnSet_Click(cs:562-573)은 선택행 존재 시 확인 다이얼로그 없이 UnSet 직접 실행 — 해제 confirm 없음.
      // UNSET payload — AS-IS UnSet(cs:611-760) 의 **동일키 ^-배칭**을 그대로 재현한다(design 03 §4-4).
      //   필수: P_SAVE_UNSET 은 P_DIVISION_ID 만 '^' 로 분해해 루프하고(PKG_SSP0020 body 309-317
      //   SCM_ARR_SPL_CNT/VAL), from/to/delegate/lastUpdateBy 는 스칼라로 WHERE 에 그대로 쓴다(326-334).
      //   그 넷까지 '^' 로 이어 보내면 WHERE 가 어떤 행에도 맞지 않아 **0건 UPDATE 로 조용히 성공**한다
      //   (2026-10-15 DB 실측으로 확인). 따라서 (delegate+from+to+lastUpdateBy) 키로 묶어 키별 1회
      //   호출하고 division 만 '^' 로 잇는다. lastUpdateDate 는 SP 가 받기만 하고 쓰지 않는다(body 269).
      //   delegate=hidden DELEGATEE_ID(raw), lastUpdateBy=표시문자열 "이름(id)" 괄호 파싱
      //   (GET rs1 raw 미반환 — SP 반환 확장은 convert-sp §6 #1). sheetName='Delegate'.
      const groups = new Map<string, { divisionIds: string[]; payload: Record<string, string> }>();
      for (const r of checked) {
        const delegate = str(r.DELEGATEE_ID) || parseIdInParen(r.DELEGATEE);
        const fromDate = toYmd(r.FROM_DATE);
        const toDate = toYmd(r.TO_DATE);
        const lastUpdateBy = parseIdInParen(r.LAST_UPDATED_BY);
        // 구분자 — id·날짜에 나타나지 않는 '|' 로 묶어 키 경계 충돌을 막는다(AS-IS 는 단순 연결).
        const key = [delegate, fromDate, toDate, lastUpdateBy].join('|');
        const found = groups.get(key);
        if (found) {
          found.divisionIds.push(str(r.DIVISION_ID));
          continue;
        }
        groups.set(key, {
          divisionIds: [str(r.DIVISION_ID)],
          payload: {
            fromDate,
            toDate,
            sheetName: SHEETS.DELEGATE,
            delegate,
            lastUpdateBy,
            lastUpdateDate: str(r.LAST_UPDATE_DATE),
            language: langCd ?? '',
          },
        });
      }

      savingRef.current = true;
      try {
        for (const { divisionIds, payload } of groups.values()) {
          const res = await apiClient.post<Record<string, unknown>>(
            `/${MENU_ID}/${SHEETS.DELEGATE}/${BTN.UNSET}/call-proc`,
            { ...payload, divisionId: divisionIds.join('^') }
          );
          if (res.status >= 400 || Number(res.data?.code)) {
            const reason =
              (res.data as { message?: string })?.message?.trim() ||
              t(MSG.EXEC_ERROR, 'Error occurred during execution.');
            void setAlert({ type: 'alert', content: reason });
            void refetch?.(); // 앞선 키가 이미 커밋됐을 수 있다(SP 가 키별로 COMMIT) — 화면 동기화
            return;
          }
        }
        void setToast({
          type: 'success',
          message: t(MSG.SAVE_SUCCESS, { defaultValue: '{0} data saved.' }).replace(
            '{0}',
            String(checked.length)
          ),
        });
        void refetch?.();
      } catch (e) {
        const msg =
          e instanceof Error ? e.message : t(MSG.EXEC_ERROR, 'Error occurred during execution.');
        void setAlert({ type: 'alert', content: msg });
      } finally {
        savingRef.current = false;
      }
    })();
  };

  const isDelegateSheet = activeSheet === SHEETS.DELEGATE;
  const activeGridRef = isDelegateSheet ? delegateGridRef : delegatedGridRef;
  const activeFilterRef = isDelegateSheet ? delegateFilterRef : delegatedFilterRef;
  const activeCount = isDelegateSheet ? delegateRows.length : delegatedRows.length;

  // 툴바 공통버튼: SEARCH(F5 조회)만 유지. 저장/해제는 SearchArea 버튼으로 이동, Insert/Delete/Save 는
  //   사용자 지시로 툴바에서 숨김(false — no-op 노출도 하지 않음, design 01 toolbar override 는 원래 no-op).
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton(BTN.SEARCH) ? handleSearch : false,
    save: false,
    insert: false,
    delete: false,
    // AUTH-03 — manual/upload 는 명시 필수(미명시면 핸들러 없는 Upload 버튼이 렌더된다).
    //   SSP0020 은 AS-IS 에 매뉴얼/업로드 기능이 없고 MANUAL/UPLOAD 버튼 메타도 미등록
    //   (2026-10-15 SCM_ADM_MNU_BTN_MPG_M 실측 4행 = SEARCH/SAVE/UNSET/USER_CHECK) → false 고정.
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
        <DelegateForm
          onSearch={handleSearch}
          onSave={handleSave}
          onUnset={handleUnset}
          onDelegateeSearch={() => setOpenUser(true)}
          // R1/R2 — 권한(hasButton) 보유 시 SAVE/UnSet 렌더(버튼그룹 폭 고정), Delegate 시트에서만 활성.
          //   Delegated List 시트에선 visibility:hidden 로 자리만 유지(시트 전환 시 조회영역 폭 반동 방지).
          //   AUTH-01 — SAVE·UnSet 은 버튼마다 독립 판정한다(한쪽 권한만 있는 그룹에서 다른 쪽이 새지 않게).
          canSave={hasButton(BTN.SAVE)}
          canUnset={hasButton(BTN.UNSET)}
          actionsActive={isDelegateSheet}
          disabled={!hasDivisionAuth}
          divisionOptions={divisionOptions}
          allDivisionCodes={allDivisionCodes}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={activeGridRef}
        gridFilter={activeFilterRef}
        dataCount={activeCount}
        excelFileName='Delegate'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={input}
      />

      <div className={styles.gridWrapper}>
        <TabWrapper
          activeTabIndex={isDelegateSheet ? 0 : 1}
          setActiveTabIndex={idx => setActiveSheet(idx === 0 ? SHEETS.DELEGATE : SHEETS.DELEGATED)}
        >
          <TabItem label={SHEETS.DELEGATE}>
            <DelegateGrid
              rows={delegateRows as unknown as WijmoRowItem[]}
              gridRef={delegateGridRef}
              gridFilterRef={delegateFilterRef}
              columnMeta={DELEGATE_COLUMNS}
              adminColumns={staticColumns[SHEETS.DELEGATE]}
              useCheckbox
            />
          </TabItem>
          <TabItem label={SHEETS.DELEGATED}>
            <DelegateGrid
              rows={delegatedRows as unknown as WijmoRowItem[]}
              gridRef={delegatedGridRef}
              gridFilterRef={delegatedFilterRef}
              columnMeta={DELEGATED_COLUMNS}
              adminColumns={staticColumns[SHEETS.DELEGATED]}
              useCheckbox={false}
            />
          </TabItem>
        </TabWrapper>
      </div>

      {/* 위임자 검색 — 공용 SsoUserModal (AS-IS UserInfoPopup, SingleSelectYn=true, SSOUserYN=false). */}
      <SsoUserModal
        open={openUser}
        modalClose={() => setOpenUser(false)}
        initialUser={input.delegatee}
        setSelectedValue={handleUserSelected}
        ssoUserYn='N'
      />
    </>
  );
};
