import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import {
  useSaveWithValidation,
  useTabBtnPermissions,
  useTabComboQueryResults,
  useTabProcQuery,
} from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ShipmentWorkingDayForm } from './components/ShipmentWorkingDayForm';
import { ShipmentWorkingDayGrid } from './components/ShipmentWorkingDayGrid';
import {
  ALL,
  COMBO,
  DAY_WEEK,
  DEBUG_MODE,
  LBL,
  MENU_ID,
  MSG,
  RESPONSE_SET,
  SHEETS,
} from './shipment-working-day.constants';
import type {
  CalendarColumnRow,
  SaveEntry,
  ShipmentWorkingDayRow,
} from './shipment-working-day.types';
import styles from './ShipmentWorkingDay.module.scss';
import { useShipmentWorkingDayStore } from './useShipmentWorkingDayStore';
import { applyBulkInput, hasCellRangeSelection } from './utils/shipmentWorkingDayBulkInput';
import { toDayCodeMap, toDayColumns } from './utils/shipmentWorkingDayColumns';
import { buildSaveEntries, toCaretPayload } from './utils/shipmentWorkingDaySave';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// AS-IS GSCM.SSP.Plan.UIL SSP0005_ShipmentWorkingDay — 출하 근무일 달력 마스터(단일 그리드).
//   조회영역 5조건 + Input 액션버튼 / 그리드 = 정적 2열 + 동적 D_YYYYMMDD N열(3단 머지헤더).
//   AS-IS 라인 매핑·미이식 근거는 __asis-mapping__.md, 설계는 .atlas/gscm-design/SSP0005/design/.
//
//   편집 상태기계 미이식(convert-core §2.4): AS-IS 는 "조회 직후 전열 잠금 -> Edit 버튼(SwitchLock)
//   으로 해제" 였으나 editMode store 를 만들지 않는다. mount 시 canEdit = hasButton('EDIT') 하나만
//   두고, 컬럼 단위 잠금은 메타 INPUT_TP_CD='S' 가 담당한다.
export const ShipmentWorkingDay = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const queryClient = useQueryClient();
  const { saveWithValidation } = useSaveWithValidation();

  const gridRef = useRef<FlexGrid<ShipmentWorkingDayRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker<ShipmentWorkingDayRow>>();
  // 저장 in-flight 재진입 차단(동기 판정) — AS-IS CanModelChange 가드의 저장측 등가.
  const savingRef = useRef(false);
  // btnInput 대량 write 재진입 차단 — AS-IS cs:681 / cs:720 의 중복 CanModelChange 가드를
  //   1회로 합쳤다(두 지점 사이에 플래그를 바꾸는 코드가 없어 두 번째 검사는 항상 같은 결과다).
  const inputRunningRef = useRef(false);
  const noAuthAlertedRef = useRef(false);

  const sc = useShipmentWorkingDayStore(s => s.searchCondition);
  const filters = useShipmentWorkingDayStore(s => s.filters);
  const calendarFilters = useShipmentWorkingDayStore(s => s.calendarFilters);
  const setFilters = useShipmentWorkingDayStore(s => s.setFilters);
  const syncCalendarFilters = useShipmentWorkingDayStore(s => s.syncCalendarFilters);
  const clearFilters = useShipmentWorkingDayStore(s => s.clearFilters);
  const openSearchArea = useShipmentWorkingDayStore(s => s.openSearchArea);
  const setOpenSearchArea = useShipmentWorkingDayStore(s => s.setOpenSearchArea);
  const staticColumns = useShipmentWorkingDayStore(s => s.staticColumns);
  const staticColumnsError = useShipmentWorkingDayStore(s => s.staticColumnsError);
  const fetchStaticColumns = useShipmentWorkingDayStore(s => s.fetchStaticColumns);
  const fetchDayRange = useShipmentWorkingDayStore(s => s.fetchDayRange);
  // divisionId='ALL' 전개 재료. handleSearch 가 "전개 결과가 빌 수 있는 창" 을 막는 데 쓴다.
  const divisionCodes = useShipmentWorkingDayStore(s => s.divisionCodes);
  const dayRangeApplied = useShipmentWorkingDayStore(s => s.dayRangeApplied);
  // F6 저장 조회조건 복원(fetchStaticColumns) 완료 신호 — 기간 기본값 SP 를 복원 뒤로 미루는 게이트.
  const initialized = useShipmentWorkingDayStore(s => s.initialized);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  // AS-IS EditButton(SwitchLock) 은 미이식. EDIT 는 API 없이 권한만 등록된 버튼코드라
  //   "편집 가능한가" 의 유일한 축으로 쓴다(01 R05/R13, 03 §3-a).
  //   메타 실패 시에도 잠근다 — INPUT_TP_CD 를 모르면 편집 가부와 필수검증이 둘 다 무근거가 된다.
  const canEdit = hasButton('EDIT') && !staticColumnsError;

  // R01/R02 권한 게이트 — Division 콤보를 페이지가 직접 구독한다(Form 과 같은 queryKey 라
  //   중복 호출이 아니다). 주의: 공용 withMenuId 가 탭 menuId 를 자동으로 싣는다(02 §2.1 ④-b
  //   의 "미전송" 서술은 실현 불가 — 실측은 04_react-gap.md Δ7).
  const [divisionResult] = useTabComboQueryResults({ filters: [COMBO.DIVISION] });
  const divisionCount = divisionResult?.data?.length ?? 0;
  // "권한 없음" 은 정상 응답인데 0건일 때만이다. 로딩중(isPending)·오류(isError)를 0건으로
  //   취급하면 첫 프레임 오탐과 네트워크 실패가 "권한 없음" 안내로 새어나간다(01 V-3).
  const noAuth = !divisionResult?.isPending && !divisionResult?.isError && divisionCount === 0;

  // divisionId='ALL' 전개 재료를 페이지가 직접 공급한다. Form 만 공급하면 조회조건 영역을 접은
  //   상태(Form 언마운트)에서 F5 를 누를 때 divisionCodes 가 비어 (2) 가드가 조회를 막는다.
  //   Form 과 같은 queryKey 라 중복 호출이 아니고, setDivisionCodes 는 값이 같으면 no-op 이다.
  //   deps 에 divisionCodes.length 를 넣는 이유: F10(조회조건 초기화)은 페이지를 리마운트하지 않고
  //   store.reset() 만 부르는데(useGloablStore.resetSearchCondition), react-query 는 구조 공유로
  //   data 참조를 그대로 유지하므로 data 축 deps 만으로는 effect 가 다시 돌지 않는다 -> divisionCodes
  //   가 빈 채로 굳어 'ALL' 조회가 MSG00137 로 영구 차단된다. 재공급 후에는 join 비교가 같아 no-op 다.
  const setDivisionCodes = useShipmentWorkingDayStore(s => s.setDivisionCodes);
  useEffect(() => {
    const codes = (divisionResult?.data ?? [])
      .map(row => str((row as Record<string, unknown>).CODE))
      .filter(Boolean);
    if (codes.length > 0) setDivisionCodes(codes);
  }, [divisionResult?.data, divisionCodes.length, setDivisionCodes]);

  // ----- 조회 -----
  const { data, isFetching } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    // 버튼 경로만 막으면 재마운트 시 GET 이 샌다 — enabled 에도 권한 게이트를 건다(01 R02).
    enabled: !!filters[SHEETS.MAIN] && !noAuth,
  });

  // 헤더 3단 컬럼셋 — 공용 PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN.
  //   조회 전에도 1회 돌려 정적 2열 + 초기 기간 D_ 열을 만든다(AS-IS InitSpread 등가, 03 §4-d).
  const { data: calendarData } = useTabProcQuery<MENU_ID, SHEETS.CALENDAR>({
    menuId: MENU_ID,
    sheetName: SHEETS.CALENDAR,
    tabId,
    filters: calendarFilters,
    enabled: !!calendarFilters,
    // 컬럼 생성용 구조적 fetch — 조회 전 마운트에도 도므로(AS-IS InitSpread 등가) 전역 탭 busy
    //   스피너에서 제외한다(useIsBusy 가 meta.background 를 거른다). 진입마다 스피너가 반짝이던 현상
    //   제거(2026-09-30). 조회(Search) 시 스피너는 MAIN 쿼리가 담당하므로 사용자 조회 피드백은 유지된다.
    queryOptions: { meta: { background: true } },
  });

  const rows = useMemo<ShipmentWorkingDayRow[]>(
    () => (data as Record<string, ShipmentWorkingDayRow[]>)?.[RESPONSE_SET.MAIN] ?? [],
    [data]
  );
  const dayColumns = useMemo(
    () =>
      toDayColumns(
        (calendarData as unknown as Record<string, CalendarColumnRow[]>)?.[RESPONSE_SET.CALENDAR] ??
        []
      ),
    [calendarData]
  );
  const dayCodeByBinding = useMemo(() => toDayCodeMap(dayColumns), [dayColumns]);
  const mainStaticColumns = staticColumns[SHEETS.MAIN];

  // mount — keep-alive 탭에 남은 이전 filters 자동 발사 차단 + 컬럼 메타 + 기간 기본값.
  //   AS-IS Form_Load 에도 자동 조회가 없다(cs:127-135).
  useEffect(() => {
    clearFilters();
    editTrackerRef.current?.clearChanges();
    void fetchStaticColumns();
    // 기간 기본값은 아래 dayRangeApplied effect 가 단독으로 책임진다 — 여기서도 부르면 마운트
    //   시점에 두 호출이 같은 커밋에서 나가 fetchDayRange 의 dayRangeApplied 가드를 둘 다 통과한다.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 기간 기본값(SP)이 적용되면 3SPAN 을 단 1회 발사한다 — 조회 전 초기 형상(AS-IS InitSpread 등가).
  //   금지: deps 에 sc.fromYyyymmdd/sc.toYyyymmdd 를 넣으면 사용자가 기간을 고치는 순간 컬럼셋이
  //   재구성돼 미저장 편집이 조용히 날아간다. AS-IS 도 drpPeriod 에 이벤트 배선이 0건이고, 컬럼셋
  //   재구성 트리거는 조회 발사 시점 스냅샷(setFilters) 하나여야 한다(03 §2-a).
  // 기간 기본값은 "아직 적용된 적 없을 때" 다시 채운다 — F10(조회조건 초기화)이 store.reset() 으로
  //   dayRangeApplied 를 false 로 되돌리는데, fetchDayRange 를 마운트 effect 에서만 부르면 기간이
  //   빈 채로 남아 (4) 빈값 가드가 조회를 영구 차단한다. fetchDayRange 자체가 dayRangeApplied 가드를
  //   가지고 있으므로, 사용자가 손으로 지운 기간(플래그는 true 유지)은 되살리지 않는다.
  useEffect(() => {
    // 복원(fetchStaticColumns)이 끝난 뒤에만 기간 기본값을 판정한다 — F6 저장조건이 기간을 복원했으면
    //   dayRangeApplied 가 이미 true 라 아래에서 skip 되어 기본기간이 저장기간을 덮지 않는다. 저장기간이
    //   없으면(dayRangeApplied false) 기본기간 SP 가 채운다. F10(초기화)은 dayRangeApplied 를 false 로
    //   되돌리므로(initialized 는 보존) 여기서 기본기간을 다시 채운다.
    if (!initialized) return;
    if (dayRangeApplied) return;
    void fetchDayRange();
  }, [initialized, dayRangeApplied, fetchDayRange]);

  const calendarInitRef = useRef(false);
  useEffect(() => {
    if (!dayRangeApplied || calendarInitRef.current) return;
    calendarInitRef.current = true;
    syncCalendarFilters();
  }, [dayRangeApplied, syncCalendarFilters]);

  // R01 — 권한 Division 0건이면 안내 1회. MSG00667("권한을 가진 Division이 없습니다").
  //   AS-IS MSG00097 을 그대로 쓰면 TO-BE 에서는 "Please select Division." 이 뜬다(hook #114).
  useEffect(() => {
    if (!noAuth || noAuthAlertedRef.current) return;
    noAuthAlertedRef.current = true;
    void setAlert({
      type: 'alert',
      content: t(MSG.NO_DIVISION_AUTH, '_No authority assigned.'),
    });
  }, [noAuth, setAlert, t]);

  // ----- F5 Search -----
  const handleSearch = () => {
    // (1) AS-IS DU:405-416 등가 — Division 옵션 0건이면 조회 차단(R01 과 별개의 2번째 게이트).
    if (noAuth) {
      void setAlert({
        type: 'alert',
        content: t(MSG.NO_DIVISION_AUTH, '_No authority assigned.'),
      });
      return;
    }
    // (2) divisionId='ALL' 전개 재료가 아직 없으면 조회를 미룬다.
    //   store.setFilters 는 'ALL' 을 권한 코드 콤마 목록으로 치환하는데(02 §4.4), 콤보가 pending
    //   인 창에서는 그 목록이 빈 배열이라 divisionId 가 빈 문자열로 나간다. TO-BE SP 는
    //   `:B_DIVISION_YN IS NULL OR UPPER(:B_DIVISION_YN)='ALL'` 로 빈값을 "필터 없음"으로 읽어
    //   권한 밖 Division 행까지 반환한다 — AS-IS 에 없는 권한 우회다(02 §7 E-2).
    //   noAuth 는 isPending 동안 false 라 (1) 이 이 창을 막지 못한다. 기간 기본값 SP 는
    //   콤보와 병렬 발사되므로 "기간은 채워졌고 콤보는 pending" 상태가 실제로 존재한다.
    if (divisionResult?.isPending || (sc.divisionId === ALL && divisionCodes.length === 0)) {
      void setAlert({
        type: 'alert',
        content: t(MSG.WORK_IN_PROGRESS, {
          defaultValue: 'Previous task is still running. Please try again later.',
        }),
      });
      return;
    }
    // (3) companyId 빈값 차단 — divisionId 와 같은 축의 방어다. TO-BE SP 는
    //   `:B_COMPANY_YN IS NULL OR UPPER(:B_COMPANY_YN)='ALL'` 로 빈값을 "필터 없음"으로 읽어
    //   전 회사 행을 반환한다(PKG_SSP0005 BODY L206-209 실측). Company 콤보는 ALL 옵션이 없는
    //   단일 선택이라 "전 회사"는 화면 사양에 없는 상태다. 기본값은 콤보 응답 뒤 Form effect 가
    //   1회 넣으므로(Form.tsx 의 companyDefaultedRef) 콤보가 pending·isError 인 창에서 빈값이
    //   나갈 수 있다 — AS-IS 는 DataSource 바인딩이 동기라 이 창 자체가 없었다.
    if (!sc.companyId) {
      void setAlert({
        type: 'alert',
        content: t(MSG.SELECT_REQUIRED, '_Select {0}.').replace(
          '{0}',
          t(LBL.COMPANY, '_Company')
        ),
      });
      return;
    }
    // (4) 의도적 강화(사용자 확정 2026-09-29, Q4) — AS-IS 는 UsrDateRangePicker 브랜치가 없어
    //   Period* 필수검증이 사문이었다. TO-BE 는 기간을 비울 수 있고, 빈값이면 SP 가 전기간을
    //   스캔한다(AS-IS 가 CommandTimeout=600 을 걸었던 이유). 차이는 04_react-gap.md 에 기재.
    if (!sc.fromYyyymmdd || !sc.toYyyymmdd) {
      void setAlert({
        type: 'alert',
        content: t(MSG.SELECT_REQUIRED, '_Select {0}.').replace(
          '{0}',
          t(LBL.PERIOD, '_Period')
        ),
      });
      return;
    }
    // refetch() 직접 호출 금지 — filters 참조 교체로만 재조회한다(stale closure 사고).
    setFilters();
    void fetchStaticColumns();
  };

  // ----- F7 Save — '^' 평면 CLOB 전송 -----
  //   useProcMutation 은 배열을 결합하지 않아 전 파라미터가 NULL 바인딩된다 -> apiClient.post 직접.
  const postSave = async (entries: SaveEntry[]) => {
    // /call-proc 은 세션을 주입하지 않는다 — 원장 LAST_UPDATED_BY 가 NOT NULL 이라 빈값으로
    //   보내면 Oracle 이 ''를 NULL 로 읽어 ORA-01400 -> SP 의 ROLLBACK TO SAVEPOINT -> 전건
    //   미저장이 된다(03 §4-e #4). 보내고 실패하느니 보내기 전에 원인을 알린다.
    const lastUpdatedBy = useSessionStore.getState().session.userId ?? '';
    if (!lastUpdatedBy) {
      void setAlert({
        type: 'alert',
        content: t(MSG.SAVE_ERROR, '_An error occurred while saving.'),
      });
      return;
    }
    savingRef.current = true;
    try {
      const payload = toCaretPayload(entries, {
        lastUpdatedBy,
        // TO-BE UserSession 에 타임존 필드가 없다. SP 에서도 인자만 남은 미사용 파라미터다.
        timeZone: '',
        debugMode: DEBUG_MODE,
      });
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`,
        payload
      );
      // false-success 판별 필수 — 인터셉터가 500/403 도 resolve 한다.
      if (res.status >= 400 || Number(res.data?.code)) {
        const reason =
          (res.data as { message?: string })?.message?.trim() ||
          t(MSG.SAVE_ERROR, '_An error occurred while saving.');
        void setAlert({ type: 'alert', content: reason });
        return;
      }
      // 건수는 FE 카운트가 아니라 SP RESULT_CNT 를 쓴다(실제 갱신 행수 — 03 §4-f).
      const status = (res.data.result as Record<string, Record<string, unknown>[]> | undefined)?.[
        RESPONSE_SET.STATUS
      ]?.[0];
      const savedCount = str(status?.RESULT_CNT) || String(entries.length);
      void setToast({
        message: t(MSG.SAVED, '_{0} data saved.').replace('{0}', savedCount),
        type: 'success',
      });
      editTrackerRef.current?.clearChanges();
      // 저장 후 같은 조회조건으로 재조회(hook #131). filters 가 그대로라 invalidate 가 유일한
      //   재조회 트리거다(prefix 는 tabId — useTabProcQuery queryKey 첫 원소).
      void queryClient.invalidateQueries({ queryKey: [tabId] });
    } catch (error) {
      void setAlert({
        type: 'alert',
        content:
          error instanceof Error
            ? error.message
            : t(MSG.SAVE_ERROR, '_An error occurred while saving.'),
      });
    } finally {
      savingRef.current = false;
    }
  };

  const handleSave = () => {
    if (isFetching || savingRef.current) {
      void setAlert({
        type: 'alert',
        content: t(MSG.WORK_IN_PROGRESS, {
          defaultValue: 'Previous task is still running. Please try again later.',
        }),
      });
      return;
    }
    // 열린 편집기를 먼저 커밋해야 마지막 셀 변경이 EditTracker 에 들어온다.
    gridRef.current?.finishEditing(true);
    const { entries, skippedBlank } = buildSaveEntries(editTrackerRef.current?.getOriginalValues());

    // 빈 값으로 지운 D_ 셀은 전송하지 않는다 — SP 가 NULL 로 UPDATE 하면 WORKDAY_YN NOT NULL
    //   제약에 걸려 ORA-01400 -> ROLLBACK TO SAVEPOINT -> 전건 미저장이 된다(03 §4-e #5).
    //   안내 문구는 원인(비운 일자 셀) 축이어야 한다 — 조회조건 Input Value 를 가리키면
    //   사용자가 엉뚱한 곳을 고친다(MSG00614 "The {0} value is required." + LBL00069 'Date').
    if (skippedBlank > 0) {
      void setAlert({
        type: 'alert',
        content: t(MSG.BLANK_DAY_CELL, '_The {0} value is required.').replace(
          '{0}',
          t(LBL.DATE, '_Date')
        ),
      });
      return;
    }
    if (entries.length === 0) {
      void setAlert({
        type: 'alert',
        content: t(MSG.NO_SAVE_DATA, '_No data to save.'),
      });
      return;
    }

    // 변경된 원본 행 — 메타 필수컬럼 검증 대상(payload 는 셀 단위라 행 필드가 없다).
    const changedRows = Array.from(
      editTrackerRef.current?.getOriginalValues().keys() ?? []
    ) as WijmoRowItem[];

    // 필수: 공용 useSaveWithValidation 경유. 커스텀 검증만 두면 메타 필수컬럼이 비어도 저장이
    //   통과한다(SCP0020 실사고). AS-IS DataUtil.checkRequiredOfSpread(cs:456) 등가.
    saveWithValidation<SaveEntry>(
      entries,
      mainStaticColumns,
      saveData => void postSave(saveData),
      changedRows
    );
  };

  // ----- btnInput 일괄입력 (AS-IS BtnInput_Click cs:671-822) -----
  const handleInputValue = () => {
    // 가드 #1 — AS-IS 는 Action 컬럼 표시여부로 "편집모드인가" 를 봤으나(cs:673) 그 축은 폐기됐다.
    //   TO-BE 의 실제 전제는 "조회했는가" 다(사용자 확정 2026-09-29, Q1 -> MSG00719).
    if (rows.length === 0) {
      void setAlert({
        type: 'alert',
        content: t(MSG.NOT_SEARCHED, '_No data have been retrieved.'),
      });
      return;
    }
    // 가드 #2 — 재진입(cs:681 / cs:720 중복 CanModelChange 를 1회로 합침).
    if (inputRunningRef.current) return;
    // 권한축 치환 — 버튼도 disabled 지만 클릭 경로에도 게이트를 둔다(01 R08).
    if (!canEdit) return;
    // 가드 #3 — Input Value 미선택(cs:684-690). 인자는 화면 라벨과 같은 LBL 키를 쓴다.
    if (!sc.inputValue) {
      void setAlert({
        type: 'alert',
        content: t(MSG.SELECT_REQUIRED, '_Select {0}.').replace(
          '{0}',
          t(LBL.INPUT_VALUE, '_Input Value')
        ),
      });
      return;
    }
    const grid = gridRef.current;
    if (!grid) return;
    // 가드 #4 — SelectDay 인데 셀 범위 선택이 없다(cs:696-701).
    //   selectedRanges.length 로 판정하면 안 된다 — Wijmo 는 현재 셀 하나만 있어도 범위 1개를
    //   돌려주므로 그 조건은 영구 false 다. AS-IS FarPoint GetSelections() 는 드래그/헤더 선택만
    //   돌려주고 단일 셀 클릭은 빈 배열이었으므로, 2셀 이상 덮는 범위를 요구해 등가를 만든다.
    if (sc.dayWeekCode === DAY_WEEK.SELECT_DAY && !hasCellRangeSelection(grid)) {
      void setAlert({
        type: 'alert',
        content: t(MSG.NO_CELL_SELECTED, '_Select a date and enter it.'),
      });
      return;
    }
    // 가드 #5 — 요일 미선택이면 조용히 return(cs:703-706). 요일 콤보는 빈값이 될 수 없어
    //   실사용상 도달하지 않지만, 제거하면 요일을 비울 수 있게 바뀔 때 구멍이 된다.
    if (!sc.dayWeekCode) return;

    inputRunningRef.current = true;
    try {
      const written = applyBulkInput({
        grid,
        tracker: editTrackerRef.current,
        dayWeekCode: sc.dayWeekCode,
        value: sc.inputValue,
        dayCodeByBinding,
      });
      if (written === 0) {
        void setAlert({
          type: 'alert',
          content: t(MSG.NO_CELL_SELECTED, '_Select a date and enter it.'),
        });
        return;
      }
      grid.invalidate(true);
    } finally {
      inputRunningRef.current = false;
    }
  };

  // 툴바 — AS-IS toolbarOverride 5건 판정(01 §2.1 R17).
  //   Insert/Delete 는 AS-IS override 본문이 주석 1줄뿐인 NO-OP 다. 버튼은 그대로 보이므로
  //   () => undefined 로 배선한다 — false 면 버튼이 숨겨지고(AS-IS 는 보인다), 키를 생략하면
  //   공용 SubTitle 기본 핸들러 addRow/removeRow 가 살아나 AS-IS 에 없던 동작이 생긴다.
  //   단 NO-OP 노출도 버튼 권한 축을 타야 한다 — SubTitle 은 권한을 보지 않으므로(hasButton grep 0)
  //   admin 이 INSERT/DELETE 를 끄면 화면이 직접 false 로 숨겨야 한다(CLAUDE.md §2 체크3, hook #66/#24).
  //   edit 키는 두지 않는다 — Hotkeys enum 에 없어 SubTitle 이 무시하는 죽은 키다.
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    save: hasButton('SAVE') && canEdit ? handleSave : false,
    insert: hasButton('INSERT') ? () => undefined : false,
    delete: hasButton('DELETE') ? () => undefined : false,
    manual: false,
    upload: false,
    // excel 은 공용 SubTitle 기본 핸들러가 채우므로 키를 주지 않으면 무조건 노출된다.
    //   AS-IS 도 BaseForm.InitForm(BaseForm.cs:449)이 Excel 버튼을 무조건 만들었으므로 노출 자체는
    //   패리티다 — 다만 admin 이 끌 수 있어야 하므로 권한 축만 얹는다(05_register.sql §7 로 EXCEL
    //   버튼코드를 등록했다. 권한 그룹이 기존 2그룹과 같아 보이는 상태는 변하지 않는다).
    ...(hasButton('EXCEL') ? {} : { excel: false as const }),
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
        <ShipmentWorkingDayForm
          onSearch={handleSearch}
          onInput={handleInputValue}
          disabled={noAuth}
          canEdit={canEdit}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='Shipment-Working-Day'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
      />
      <div className={styles.gridWrapper}>
        <ShipmentWorkingDayGrid
          rows={rows}
          gridRef={gridRef}
          gridFilterRef={gridFilterRef}
          editTrackerRef={editTrackerRef}
          staticColumns={mainStaticColumns}
          dayColumns={dayColumns}
          canEdit={canEdit}
        />
      </div>
    </>
  );
};
