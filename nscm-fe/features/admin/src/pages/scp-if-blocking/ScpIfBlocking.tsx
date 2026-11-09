import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useMutation, useQueryClient } from '@foundation/query-client';
import { MainTitle, SubTitle } from '@shared/components';
import {
  useSaveWithValidation,
  useTabBtnPermissions,
  useTabComboQueryResults,
  useTabProcQuery,
} from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ScpIfBlockingForm } from './components/ScpIfBlockingForm';
import { ScpIfBlockingGrid } from './components/ScpIfBlockingGrid';
import { BTN, COMBO, MENU_ID, MSG, SHEETS } from './scp-if-blocking.constants';
import { useScpIfBlockingStore } from './useScpIfBlockingStore';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// AS-IS GSCM.SCM.Master.UIL SCM0019_SCP_Interface_Blocking — SCP 인터페이스 블로킹.
//   설계: .atlas/gscm-design/SCM0019/design/00~03. domain=Common(Admin) → features/admin.
//   조회조건 Division(다중, EE 포함) + Period(필수) / 단일 그리드(YN 3컬럼 편집, Insert/Delete NO-OP).
//   편집모드 토글 미이식(convert-core §2.4) — canEdit=hasButton('EDIT') 1회 치환.
//   SP = PKG_SCM0019 (GET/SAVE) MISSING → convert-sp 후속, FE 선배선(조회/저장은 SP 배포 후 end-to-end).
export const ScpIfBlocking = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore(s => s.setAlert);
  const setToast = useMessageStore(s => s.setToast);
  const queryClient = useQueryClient();

  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.MAIN>>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const noAuthAlertedRef = useRef(false);
  // 저장 성공 토스트 MSG00672 "{0} data saved." 의 {0} = 저장(UPDATE)한 행수. onSave 에서 세팅.
  const savedCountRef = useRef(0);

  const search = useScpIfBlockingStore(s => s.search);
  const filters = useScpIfBlockingStore(s => s.filters);
  const setFilters = useScpIfBlockingStore(s => s.setFilters);
  const clearFilters = useScpIfBlockingStore(s => s.clearFilters);
  const staticColumns = useScpIfBlockingStore(s => s.staticColumns);
  const fetchStaticColumns = useScpIfBlockingStore(s => s.fetchStaticColumns);
  const isOpenSearchArea = useScpIfBlockingStore(s => s.isOpenSearchArea);
  const setOpenSearchArea = useScpIfBlockingStore(s => s.setOpenSearchArea);
  const applyPeriodDefault = useScpIfBlockingStore(s => s.applyPeriodDefault);
  const setAuthDivisions = useScpIfBlockingStore(s => s.setAuthDivisions);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  // AS-IS 편집모드 토글 미이식(convert-core §2.4): 편집모드 상태 신설 금지. EDIT 권한축 1회 치환.
  const canEdit = hasButton(BTN.EDIT);

  const { saveWithValidation } = useSaveWithValidation();

  // SAVE SP 의 P_USER_ID(감사컬럼) — /call-proc 은 세션을 주입하지 않으므로 FE 가 싣는다(workbench 선례).
  const sessionUserId = useSessionStore(s => s.session.userId);

  // Division 콤보(MyDivisionInEE_SCP — EE 포함·권한필터·@mnuId) + Period 기본값 프리셋(PERIOD_DEFAULT).
  const [divisionResult, periodResult] = useTabComboQueryResults({
    filters: [{ comboId: COMBO.DIVISION, mnuId: MENU_ID }, COMBO.PERIOD_DEFAULT],
  });

  // EE 미제외 — 공통 MyDivision 과 달리 InEE 콤보는 EE(전극) division 을 포함한다(design 02 §2.1, 클라 필터 없음).
  const divisionOptions = useMemo(
    () =>
      (divisionResult?.data ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) })),
    [divisionResult?.data]
  );
  // R1 — 권한 Division 0건이면 조회영역 disable + 안내(AS-IS SetDivisionAuthCheck, design 01 §2 R1).
  const noAuth = !divisionResult?.isPending && divisionOptions.length === 0;

  // 권한 Division 코드를 store 로 올린다 — Division 미선택 조회 시 setFilters 가 'ALL'(권한 밖 노출) 대신
  //   이 코드를 열거해 IN(auth) 가드를 태운다(인가 우회 차단, AS-IS GetCheckedListValue 2-arg 등가).
  useEffect(() => {
    setAuthDivisions(divisionOptions.map(o => o.value));
  }, [divisionOptions, setAuthDivisions]);

  const { data } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters,
    enabled: filters !== undefined,
  });

  // AS-IS SaveData(cs:303-318): 성공 시 저장 건수 메시지 + 재조회(FindData), 실패 시 실패 알림.
  // SAVE SP = PKG_SCM0019.P_SCM0019_SAVE 는 행축 전건 '^'-결합 CLOB 평면 파라미터
  //   (activeFlag/divisionId/planStartYyyymmdd/fpTargetYn/mrpTargetYn/dmRtfYn) + sesUserId(VARCHAR 스칼라)다.
  //   공용 useProcMutation 은 {data: rows} 를 보내는데 BE makeProcedure 는 params.get(COL_NM) 로 평면 키를
  //   찾으므로 전 파라미터가 NULL 바인딩된다(0건 UPDATE 인데 성공 반환 → "저장 안 됨" 오탐, SCP0125 workbench 선례
  //   [[save-proc-per-column-caret-fold-fe]]). → 컬럼별 '^' payload 를 /call-proc 에 직접 전송한다.
  //   sesUserId 는 /call-proc 이 세션 미주입이라 FE 가 싣는다. false-success 판별: 인터셉터가 500/code≠0 도
  //   resolve 하므로 status·code 를 직접 확인해 onError 로 유도(성공=MSG00672 건수, 실패=MSG00006).
  const { mutate } = useMutation({
    mutationKey: [tabId],
    mutationFn: async (rows: ResponseData<MENU_ID, SHEETS.MAIN>[]) => {
      if (rows.length === 0) throw new Error(t('MSG00004', '_수정한 내용이 없습니다.'));
      if (!sessionUserId) throw new Error(t(MSG.SAVE_FAIL, '_Failed to save.'));
      const fold = (pick: (r: ResponseData<MENU_ID, SHEETS.MAIN>) => unknown): string =>
        rows.map(r => str(pick(r))).join('^');
      const payload = {
        activeFlag: fold(r => r.CRUD_TYPE), // 'M'(수정)만 — 신규/삭제 없음(키 잠금)
        divisionId: fold(r => r.DIVISION_ID),
        planStartYyyymmdd: fold(r => r.PLAN_START_YYYYMMDD),
        fpTargetYn: fold(r => r.FP_TARGET_YN),
        mrpTargetYn: fold(r => r.MRP_TARGET_YN),
        dmRtfYn: fold(r => r.DM_RTF_YN),
        sesUserId: sessionUserId,
      };
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/${SHEETS.MAIN}/${BTN.SAVE}/call-proc`,
        payload
      );
      if (res.status >= 400 || Number(res.data?.code)) {
        throw new Error((res.data?.message ?? '').trim() || t(MSG.SAVE_FAIL, '_Failed to save.'));
      }
      return res;
    },
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: [tabId] });
      void setToast({
        type: 'success',
        message: t(MSG.SAVE_SUCCESS, '_{0} data saved.').replace('{0}', String(savedCountRef.current)),
      });
    },
    onError: (error: Error) => {
      void setAlert({ type: 'alert', content: error?.message ?? t(MSG.SAVE_FAIL, '_Failed to save.') });
    },
  });

  useEffect(() => {
    // 진입 자동조회 금지(nscm-patterns §5-7) — keep-alive 잔여 filters 무효화 + 컬럼메타 1회 fetch.
    clearFilters();
    void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // Period 기본값 1회 적용(PERIOD_DEFAULT FROM_VALUE:TO_VALUE). 이후 사용자 입력 보존(store periodApplied 가드).
  useEffect(() => {
    const row = periodResult?.data?.[0] as Record<string, unknown> | undefined;
    const from = str(row?.FROM_VALUE);
    const to = str(row?.TO_VALUE);
    if (from && to) applyPeriodDefault(from, to);
  }, [periodResult?.data, applyPeriodDefault]);

  // R1 — 무권한이면 안내 1회(design 01 §2 R1, BaseForm.SetDivisionAuthCheck 등가).
  useEffect(() => {
    if (noAuth && !noAuthAlertedRef.current) {
      noAuthAlertedRef.current = true;
      void setAlert({ type: 'alert', content: t(MSG.REQUIRE_DIVISION, '_Please select Division.') });
    }
  }, [noAuth, setAlert, t]);

  // R5/R6 — 조회. 필수 조회조건 Period 미입력 시 alert·차단(AS-IS checkRequiredOfSearch cs:170).
  const handleSearch = () => {
    if (noAuth) return;
    if (!search.fromYyyymmdd || !search.toYyyymmdd) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRE_FIELD, '_Please enter the required fields.') });
      return;
    }
    setFilters();
  };

  // R7 — 저장. 변경(CRUD_TYPE='M') 행만 → YN 3컬럼 UPDATE. 신규/삭제 없음(키 잠금). 공용 필수검증 훅 경유(STR-23).
  //   PLAN_START 는 잠금 키컬럼이라 GET 반환값(8자리) 그대로 — 클라 변환 불요(design 03 W6).
  const onSave = () => {
    const saveData = data?.o_rc1?.filter?.(item => item.CRUD_TYPE) ?? [];
    savedCountRef.current = saveData.length; // MSG00672 {0} = 저장 행수(AS-IS iCount 등가)
    saveWithValidation(saveData, staticColumns, mutate);
  };

  // 툴바: Find/Save = 실동작(권한 조건부). Insert/Delete = 화면 미노출(false) — 이 화면은 키 잠금 편집 전용
  //   (기존 행 YN 수정만, 행 추가/삭제 없음)이라 사용자 요청으로 버튼을 숨긴다. false 는 버튼을 렌더하지
  //   않으면서(SubTitle === false 가드) 공용 addRow/removeRow·F8/F9 단축키도 함께 차단한다(AUTH-04 유지).
  //   DB 버튼 메타(SCM_ADM_MNU_BTN_MPG_M)는 유지 — FE 노출만 끈다. manual/upload 미사용.
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton(BTN.SEARCH) ? handleSearch : false,
    save: hasButton(BTN.SAVE) && canEdit ? onSave : false,
    insert: false,
    delete: false,
    manual: false,
    upload: false,
  };

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <ScpIfBlockingForm onSearch={handleSearch} disabled={noAuth} divisionOptions={divisionOptions} />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={data?.o_rc1?.length ?? 0}
        excelFileName='ScpInterfaceBlocking'
        hotkeyConfig={hotkeyConfig}
        searchParam={search}
      />
      <ScpIfBlockingGrid gridRef={gridRef} gridFilterRef={gridFilterRef} data={data?.o_rc1 ?? []} />
    </>
  );
};
