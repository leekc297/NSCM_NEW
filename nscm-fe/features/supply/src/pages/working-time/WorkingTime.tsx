import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { type EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { WorkingTimeForm } from './components/WorkingTimeForm';
import { WorkingTimeGrid } from './components/WorkingTimeGrid';
import { WorkingTimeInputModal } from './components/WorkingTimeInputModal';
import { useWorkingTimeStore } from './useWorkingTimeStore';
import {
  DAY_WEEK,
  MAX_PERIOD_DAYS,
  MENU_ID,
  MSG,
  RESPONSE_SET,
  SAVE_KEYS,
  SHEETS,
  WORKING_TIME_RANGE,
} from './working-time.constants';
import {
  buildDynDayColumns,
  buildPeriodDayColumnMeta,
  deriveDayColumnMeta,
} from './working-time.dynamic-columns';
import type { DynColumnMeta, DynDayColumn, SaveEntry, WorkingTimeRow } from './working-time.types';

// AS-IS GSCM.SCP.Forms.UIL Master SCP0019_WorkingTime (Supply > Supply Master > Work Calendar(OSP)).
//   조회형+편집형 마스터 — 조회(GET SP 7 IN, O_RC1 데이터 + O_RESULT_CURSOR 상태) 후 OSP_YN='Y' 행만
//   편집(WORKING_TIME_DEFAULT + 동적 D_ 일자 셀), SAVE SP 로 '^' 구분 배열 저장(WORKING_TIME_HIST 이력).
//   GET SP 단일 호출로 데이터(O_RC1)와 그 컬럼 메타(o_rc1_columns)를 함께 받는다(04_impl-gap-audit #1 실측) —
//   시트는 MAIN 하나뿐, 동적 D_ 컬럼은 o_rc1_columns 에서 도출한다(타이틀 커서 없음).
//   버튼 메타 실측 = SEARCH/SAVE 2건만. Insert/Delete = AS-IS NO-OP(미등록, 01_layout §2-a).
export const WorkingTime = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGrid<WorkingTimeRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  // 그리드 공용 EditTracker — 변경 셀의 단일 진실원('M' 표기와 동일 출처). 저장 payload 는 여기서 도출.
  const editTrackerRef = useRef<EditTracker<WorkingTimeRow>>();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const queryClient = useQueryClient();

  const isOpenSearchArea = useWorkingTimeStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useWorkingTimeStore(state => state.setOpenSearchArea);
  const searchParams = useWorkingTimeStore(state => state.searchParams);
  const setSearchParams = useWorkingTimeStore(state => state.setSearchParams);
  const filters = useWorkingTimeStore(state => state.filters);
  const setFilters = useWorkingTimeStore(state => state.setFilters);
  // 사용자 세션 — Period 기본값 SP 호출에 등록 timezone(tmzCd)을 넘긴다.
  const session = useSessionStore(state => state.session);
  const clearFilters = useWorkingTimeStore(state => state.clearFilters);
  const fetchStaticColumns = useWorkingTimeStore(state => state.fetchStaticColumns);
  const restoreSearchConditions = useWorkingTimeStore(state => state.restoreSearchConditions);

  // ui-dynamic-property-management — Menu Button 권한 동적 fetch
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // 명시 조회 게이트 — persist 된 stale filters 자동 발사 차단 (DMF0014/DMF0048 선례)
  const [hasSearched, setHasSearched] = useState(false);
  // 저장 in-flight — 재진입(더블클릭) 차단. SalesPlan(DMF0021) isPending 표준 1:1.
  const [isPending, setIsPending] = useState(false);
  // 값입력 팝업(WorkingTimeInputModal) — 버튼영역 '입력' 버튼이 연다(2026-10-15 사용자 지시, 자매 SCP0096).
  const [inputModalOpen, setInputModalOpen] = useState(false);

  // 메인 그리드 SP — PKG_SCP0019.P_SCP0019_GET_WORKING_TIME (7 IN + 세션 2 + O_RC1 데이터 + O_RESULT_CURSOR 상태).
  //   단일 호출로 데이터(o_rc1)와 그 컬럼 메타(o_rc1_columns)를 반환하므로 rows·동적컬럼을 이 응답에서 도출한다.
  const { data, isFetching } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: hasSearched && !!filters[SHEETS.MAIN],
  });

  // Period 기본값 — AS-IS dCalendar.InitValue = DateUtil.GetDayRange(division, bucket) 재현.
  //   AS-IS 는 서버 SP SCM0001_GET_SCP_MONTH_PERIOD 에 사용자 등록 timezone(UserInfoContext.TimeZone)을 넘겨
  //   오늘/기간을 timezone + 달력테이블(SCM_SYS_CALENDAR_M) 기준으로 계산했다(브라우저 dayjs 근사는 기기 OS
  //   timezone 의존이라 사용자 등록 timezone 과 날짜경계에서 어긋날 수 있었다 — 사용자 지시 2026-11-12 로 복원).
  //   SP ELSE 분기(fromDate 공란)는 division/planCycle 미사용 — timeZone+offset(12)+달력만 쓰므로 mount 1회로 충분.
  //   응답 o_rc1[0].PERIOD = 'YYYYMMDD:YYYYMMDD'(from:to). 실패/빈값이면 store 의 dayjs initPeriod 가 폴백으로 남는다.
  const periodFilters = useMemo(
    () => ({ divisionId: '', planCycle: '', fromDate: '', offsetMonth: '12', timeZone: session.tmzCd ?? '' }),
    [session.tmzCd]
  );
  const periodQuery = useTabProcQuery<MENU_ID, SHEETS.PERIOD>({
    menuId: MENU_ID,
    sheetName: SHEETS.PERIOD,
    tabId,
    filters: periodFilters,
    enabled: !!session.tmzCd,
  });
  // SP 결과를 기본 Period 로 1회 반영(ref 가드). working-time 은 날짜를 F6 저장조건에서 제외하므로
  //   restoreSearchConditions 와 충돌하지 않는다(날짜 축은 이 경로만 세팅).
  const periodAppliedRef = useRef(false);
  useEffect(() => {
    if (periodAppliedRef.current) return;
    const period = (periodQuery.data as Record<string, Array<{ PERIOD?: string }>> | undefined)?.[
      RESPONSE_SET.MAIN
    ]?.[0]?.PERIOD;
    if (!period) return;
    const [from, to] = period.split(':');
    if (from?.length === 8 && to?.length === 8) {
      setSearchParams({ startYyyymmdd: from, endYyyymmdd: to });
    }
    periodAppliedRef.current = true;
  }, [periodQuery.data, setSearchParams]);

  // 참조 고정 필수: useMemo 없이 ?? [] 로 만들면 조회조건 타이핑/드롭다운마다 부모가 리렌더될 때 매번 새
  //   배열이 되어 Grid data/dynColumns prop 참조가 바뀐다 → grid dynamicColumns useMemo 재계산(깜빡임).
  //   data(react-query 캐시)가 실제로 바뀔 때만 새 참조가 되도록 고정한다.
  const rows = useMemo<WorkingTimeRow[]>(
    () => (data as Record<string, WorkingTimeRow[]>)?.[RESPONSE_SET.MAIN] ?? [],
    [data]
  );
  // 동적 D_ 컬럼 — D_yyyymmdd 이름에서 파생. 요일 그룹은 커서가 주지 않으므로 yyyymmdd 로 클라이언트
  //   계산(SP "칸 펼치기" 원리). 표준 call-proc 응답에는 o_rc1_columns 사이드카가 없으므로(DynamicQuery
  //   경로 전용) 데이터 행(o_rc1)의 키에서 직접 컬럼명을 수집한다. 사이드카가 있으면 그것을 우선 사용.
  const dynColumns = useMemo<DynDayColumn[]>(() => {
    const sidecar = (data as unknown as Record<string, DynColumnMeta[]>)?.[RESPONSE_SET.DYN_COLUMNS];
    // return buildDynDayColumns(sidecar?.length ? sidecar : deriveDayColumnMeta(rows));
    // 데이터 키만 쓰면 빈 기간은 날짜 칸이 없어 입력 불가. 조회한 기간 전체 날짜와 합친다(중복은 이름으로 제거)
    const dataMeta = sidecar?.length ? sidecar : deriveDayColumnMeta(rows);
    const f = filters[SHEETS.MAIN] as Record<string, string | undefined> | undefined;
    const periodMeta =
      data && f ? buildPeriodDayColumnMeta(f.fromYyyymmdd ?? '', f.toYyyymmdd ?? '') : [];
    const seen = new Set<string>();
    const merged = [...periodMeta, ...dataMeta].filter(m => !seen.has(m.name) && !!seen.add(m.name));
    return buildDynDayColumns(merged);
  }, [data, rows, filters]);

  // mount 시 1회 admin 메타 fetch + persist 된 이전 filters 무효화 (NULL payload SP 자동호출 방지)
  //   F6 저장 조회조건 복원도 mount 1회(store conditionsRestored 가드). 새로고침=새 store 라 재복원,
  //   조건만 searchParams 로 되살리고 그리드는 비운 채 둔다(자동조회 안 함 — IntegrationPsi 파리티).
  useEffect(() => {
    clearFilters();
    editTrackerRef.current?.clearChanges();
    void fetchStaticColumns();
    void restoreSearchConditions();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // ----- 조회 validation (AS-IS FindData_Main — Division 필수) -----
  const validateFind = (): boolean => {
    if (isFetching) return false;
    // Division 필수 (cboDivision 단일 필수, 02_search-combo §1)
    if (!searchParams.divisionId) {
      void setAlert({ type: 'alert', content: t(MSG.DIVISION_REQUIRED, '_Please select Division.') });
      return false;
    }
    // 기간 역전 차단 (from > to)
    if (Number(searchParams.startYyyymmdd) > Number(searchParams.endYyyymmdd)) {
      void setAlert({ type: 'alert', content: t(MSG.INVALID_FORMAT, '_Invalid period (start > end).') });
      return false;
    }
    // 기간 상한 초과 차단 (To > From + MAX_PERIOD_DAYS)
    const from = dayjs(searchParams.startYyyymmdd, 'YYYYMMDD');
    const to = dayjs(searchParams.endYyyymmdd, 'YYYYMMDD');
    if (to.diff(from, 'day') > MAX_PERIOD_DAYS) {
      void setAlert({
        type: 'alert',
        content: t(MSG.PERIOD_MAX, '_Maximum Period is From Date + {0}.').replace(
          '{0}',
          String(MAX_PERIOD_DAYS)
        ),
      });
      return false;
    }
    return true;
  };

  // F5 Search — refetch?.() 직접 호출 금지 (stale closure — setFilters + invalidateQueries 표준).
  //   invalidate 키는 tabId — useTabProcQuery queryKey 는 [tabId, sheetName, action, filters].
  const handleSearch = () => {
    if (!validateFind()) return;
    setHasSearched(true);
    editTrackerRef.current?.clearChanges();
    setFilters();
    void queryClient.invalidateQueries({ queryKey: [tabId] });
    void fetchStaticColumns();
  };

  // Grid 초기화 규약 — Division 이 바뀌면 화면에 남은 결과는 새 전제와 어긋나므로 비운다. 미저장 편집도
  //   함께 버린다(남기면 바뀐 전제로 저장). clearFilters() 가 filters 를 없애면 MAIN useTabProcQuery 가
  //   disabled 되어 rows·헤더가 비고, hasSearched=false 로 명시 조회 게이트도 되돌아간다. 자동 재조회
  //   하지 않는다 — 사용자가 Search 를 다시 눌러 새 Division 으로 조회한다(nscm-patterns §5).
  const resetGrid = () => {
    editTrackerRef.current?.clearChanges();
    setHasSearched(false);
    clearFilters();
  };

  // ----- F7 Save — 편집(OSP_YN='Y' 행)의 D_ 일자 셀 + WORKING_TIME_DEFAULT net 변경을 '^' 배열로 -----
  //   SAVE SP P_SCP0019_SAVE_WORKING_TIME_ROW 는 CLOB '^' 구분 배열이므로 apiClient.post 직접
  //   (useProcMutation array unfold 안 함 — DMF0014 표준 선례).
  const handleSave = async () => {
    // 재진입 가드 (SalesPlan blockIfWorking 1:1) — 조회/저장이 아직 돌고 있으면 차단.
    if (isFetching || isPending) {
      void setAlert({ type: 'alert', content: t(MSG.WORK_IN_PROGRESS, '_이전 작업이 아직 실행 중입니다.') });
      return;
    }
    // 저장 payload 는 그리드 공용 EditTracker 에서 직접 도출한다(편집↔저장 사이 재렌더에 안전한 단일 출처).
    //   (1) 열린 편집기 강제 커밋 → (2) 변경맵 순회로 D_ 일자 셀·WORKING_TIME_DEFAULT net 변경만 수집.
    gridRef.current?.finishEditing(true);

    const toStr = (v: unknown): string =>
      typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
    const changed = editTrackerRef.current?.getOriginalValues();
    const entries: SaveEntry[] = [];
    if (changed) {
      for (const [item, fields] of changed) {
        // OSP_YN='Y' 행만 편집 대상 — 그 외 행은 그리드에서 잠겨 변경될 수 없으나 방어적으로 재확인.
        if (toStr(item.OSP_YN).toUpperCase() !== 'Y') continue;
        const rec = item as unknown as Record<string, unknown>;
        for (const binding of Object.keys(fields)) {
          // 편집 가능 셀 = 동적 D_ 일자 셀 또는 WORKING_TIME_DEFAULT.
          const isDay = /^D_\d{8}$/.test(binding);
          const isDefault = binding === 'WORKING_TIME_DEFAULT';
          if (!isDay && !isDefault) continue;
          const rawValue = toStr(rec[binding]).replace(/,/g, '');
          const value = rawValue === '' ? '0' : rawValue;
          // 저장 범위검증 — AS-IS SaveData_Main(cs:832-852) 파리티. WORKING_TIME_DEFAULT 0~7 / D_ 일자셀 0~1440.
          //   AS-IS 는 입력·편집 시점이 아니라 저장 시점에만 범위를 본다(D_ 셀 타입에 max 없음, cs:330) → 범위초과값은
          //   셀엔 들어가되 저장에서 차단. 첫 위반에서 MSG00203 표시 후 저장 중단(AS-IS GMessageBox+return 파리티).
          const num = Number(value);
          const max = isDefault ? WORKING_TIME_RANGE.DEFAULT_MAX : WORKING_TIME_RANGE.DAY_MAX;
          if (Number.isNaN(num) || num < WORKING_TIME_RANGE.DEFAULT_MIN || num > max) {
            void setAlert({
              type: 'alert',
              content: t(MSG.OUT_OF_RANGE, '_Please enter a number between {0} and {1}.')
                .replace('{0}', '0')
                .replace('{1}', isDefault ? '7.0' : '1440'),
            });
            return;
          }
          entries.push({
            activeFlag: 'M', // 편집 = Modify (03_grid-columns §4 SAVE)
            divisionId: toStr(item.DIVISION_ID),
            plantSiteId: toStr(item.PLANT_SITE_ID),
            factoryId: toStr(item.FACTORY_ID),
            operationId: toStr(item.OPERATION_ID),
            lineId: toStr(item.LINE_ID),
            // isSaveDefault='Y' 이면 WORKING_TIME_DEFAULT 저장(yyyymmdd 미사용), 아니면 D_ 일자값.
            yyyymmdd: isDefault ? '' : binding.replace('D_', ''),
            workingTime: isDefault ? '' : value,
            isSaveDefault: isDefault ? 'Y' : 'N',
            workingTimeDefault: isDefault ? value : '',
          });
        }
      }
    }
    if (entries.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.NO_SAVE_DATA, '_No data to save.') });
      return;
    }
    // 저장 confirm 없음(표준화) — 저장은 되돌릴 수 있고 결과는 Toast 로 알린다. DMF0014/DMF0021 동일.
    const sesUserId = useSessionStore.getState().session.userId ?? '';
    // '^' delim CLOB 배열 param(1~10). userId(param 11)는 스칼라라 아래에서 따로 싣는다.
    const payload: Record<string, string> = Object.fromEntries(
      SAVE_KEYS.map(k => [k, entries.map(r => r[k]).join('^')])
    );
    // P_USER_ID(PROC_M COL_NM='userId', VARCHAR 단일) — 저장은 /call-proc(makeProcedure) 경로라 BE 가
    //   세션사용자를 주입하지 않는다(GeneralController.callProc 은 mnuId/shtNm/mnuBtnCd/sesSystemCd 만 주입).
    //   따라서 FE 가 PROC_M COL_NM 과 같은 'userId' 키로 단일값을 보내야 CREATED_BY/LAST_UPDATED_BY(NOT NULL)
    //   가 채워진다('^' 배열로 보내면 스칼라 바인드라 "u^u^u" 1토큰이 되므로 배열 join 대상에서 제외).
    payload.userId = sesUserId;
    // PROC_M COL_NM 이 userIdList 로 등록돼 userId 만 보내면 P_USER_ID 가 NULL(ORA-01400 CREATED_BY). 둘 다 보낸다
    payload.userIdList = sesUserId;

    setIsPending(true);
    try {
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`,
        payload
      );
      if (res.status >= 400 || Number(res.data?.code)) {
        const reason =
          (res.data as { message?: string })?.message?.trim() ||
          t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.');
        void setAlert({ type: 'alert', content: reason });
        return;
      }
      // SP 는 예외 시 롤백 후 O_RESULT_CURSOR 에 RESULT_CODE='F' + ERR_MESSAGE 를 주고 code 0 으로 끝난다. 'S' 만 성공
      const body = res.data?.result as Record<string, unknown> | undefined;
      const firstSet = body
        ? (Object.values(body).find(Array.isArray) as Record<string, unknown>[] | undefined)
        : undefined;
      const head = firstSet?.[0];
      const resultCode = head ? toStr(head.result_code ?? head.RESULT_CODE) : '';
      if (resultCode && resultCode !== 'S') {
        const errMsg = head ? toStr(head.err_message ?? head.ERR_MESSAGE) : '';
        void setAlert({
          type: 'alert',
          content: errMsg || t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.'),
        });
        return;
      }
      void setToast({ message: t(MSG.SAVED, '_성공적으로 저장되었습니다.'), type: 'success' });
      editTrackerRef.current?.clearChanges();
      // AS-IS SaveData 성공 후 FindData_Main 재조회 1:1. 저장은 filters 가 그대로라 키가 안 바뀌므로
      //   invalidate 가 유일한 재조회 트리거다(prefix 는 tabId — MENU_ID 로는 매칭되지 않음).
      void queryClient.invalidateQueries({ queryKey: [tabId] });
    } catch (e) {
      const msg = e instanceof Error ? e.message : t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.');
      void setAlert({ type: 'alert', content: msg });
    } finally {
      setIsPending(false);
    }
  };

  // SubTitle 공통버튼 — hasButton 권한 분기. Insert/Delete = AS-IS NO-OP(미등록, 01_layout §2-a):
  //   false 로 명시해 미노출(undefined 면 공통 SubTitle 기본 addRow/removeRow 가 그려짐).
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    save: hasButton('SAVE') ? () => void handleSave() : false,
    insert: false, // AS-IS //InsertRow(); 주석뿐 — 미등록·미노출
    delete: false, // AS-IS //siMain.Delete(); 주석뿐 — 미등록·미노출
    manual: false,
    upload: false,
  };

  // '입력' 버튼(버튼영역) 클릭 — 값입력 팝업 오픈 가드. 조회 전이면 차단(persist 된 stale 화면 값입력 금지,
  //   AS-IS BtnInput_Click 가드 #1 MSG00135). 편집 권한(hasButton('SAVE'))은 버튼 노출 자체를 막으므로
  //   여기선 조회 여부만 본다. 실제 Day of the week·Input Value 는 팝업(WorkingTimeInputModal)이 받는다.
  const handleInputOpen = useCallback((): void => {
    if (!hasSearched) {
      void setAlert({ type: 'alert', content: t(MSG.NOT_SEARCHED, '_Edit mode is available after search.') });
      return;
    }
    setInputModalOpen(true);
  }, [hasSearched, setAlert, t]);

  // 값입력 확정(팝업 OK) — Day of the week + Input Value 를 선택/요일 D_ 셀에 일괄 써넣는다. AS-IS
  //   BtnInput_Click(SCP0019_WorkingTime.cs:1231~) SetText 3분기 그대로: SelectDay=선택영역 D_ 셀 /
  //   EveryDay=전행×전 D_ / Mon~Sun=전행×해당 요일 D_ 컬럼(DynDayColumn.weekday 매칭). OSP_YN='Y' 행만
  //   대상(화면 편집잠금 규약 — 비OSP 행은 저장에서도 제외). 값 검증은 AS-IS 와 동일하게 형식(int)만 —
  //   빈 값은 공란 write(셀 비움), 범위(0~1440)는 입력이 아니라 저장 시점(handleSave)에서 검사. setCellData 는 cellEditEnded 를
  //   발화하지 않으므로 원본을 먼저 읽어 storeChange 로 명시 기록한다(EditTracker 단일 출처). true=성공(팝업
  //   닫기)/false=가드 실패(팝업 유지). 자매 SCP0096 shipment-working-day-osp handleInputConfirm 동형.
  const handleInputConfirm = useCallback(
    (dayWeekCode: string, inputValue: string): boolean => {
      // 편집 권한 없으면 값입력 금지(방어 — 버튼이 숨겨져 정상경로 미도달).
      if (!hasButton('SAVE')) return false;

      // 형식 검증 — 정수만. 빈 값은 공란 write 로 허용(AS-IS int.Parse 공란→"0" 통과 후 strValue 공란 write 파리티).
      const raw = inputValue.trim();
      if (raw !== '' && !/^\d+$/.test(raw)) {
        // AS-IS BtnInput_Click MSG00050("유효한 숫자 형식이 아닙니다. {0}") 파리티 — {0}=입력값(raw) 치환.
        void setAlert({
          type: 'alert',
          content: t(MSG.INVALID_INPUT_VALUE, '_This is not a valid numeric format. {0}').replace('{0}', raw),
        });
        return false;
      }
      // 범위검증 없음 — AS-IS BtnInput_Click(cs:1230~)은 형식(MSG00050)만 보고 SetText 로 바로 쓴다(0~1440
      //   상한 미검사). D_ 셀은 셀 타입에도 max 가 없어(cs:330 SetReNumerCellType min=0,dec=0) 2222 같은 값이
      //   셀에 들어가고, 범위는 저장 시점(handleSave)에만 MSG00203 으로 차단한다 — AS-IS SaveData_Main(cs:845) 파리티.
      const writeVal: WijmoPrimitive = raw === '' ? '' : Number(raw);

      const g = gridRef.current;
      if (!g) {
        void setAlert({ type: 'alert', content: t(MSG.NO_CELL_SELECTED, '_Please select cell(s).') });
        return false;
      }

      const isSelectDay = dayWeekCode === DAY_WEEK.SELECT_DAY;
      const isEveryDay = dayWeekCode === DAY_WEEK.EVERY_DAY;
      const targetWeekday = dayWeekCode.toUpperCase(); // Mon~Sun → MON~SUN (DynDayColumn.weekday 매칭, AS-IS ToUpper 비교)
      const dayByBinding = new Map<string, DynDayColumn>(dynColumns.map(d => [d.binding, d]));
      const tracker = editTrackerRef.current;
      let wrote = 0;

      // D_ 일자 셀 × OSP_YN='Y' 행만 write(비OSP 행은 그리드 잠금·저장 제외).
      const writeCell = (row: number, col: number): void => {
        const item = (g.rows[row] as { dataItem?: WorkingTimeRow } | undefined)?.dataItem;
        if (!item || String(item.OSP_YN ?? '').toUpperCase() !== 'Y') return;
        const binding = g.columns[col]?.binding ?? '';
        if (!/^D_\d{8}$/.test(binding)) return;
        const original = g.getCellData(row, col, false) as WijmoPrimitive;
        g.setCellData(row, col, writeVal, true);
        tracker?.storeChange(item, binding, original, writeVal);
        wrote += 1;
      };

      if (isSelectDay) {
        // SelectDay — 선택영역의 D_ 셀만. 선택영역이 없으면 대상 없음(AS-IS 가드 #4 MSG00134).
        const sel = g.selectedRanges;
        if (!sel || sel.length === 0) {
          void setAlert({ type: 'alert', content: t(MSG.NO_CELL_SELECTED, '_Please select cell(s).') });
          return false;
        }
        for (const range of sel) {
          for (let row = range.topRow; row <= range.bottomRow; row++) {
            for (let col = range.leftCol; col <= range.rightCol; col++) writeCell(row, col);
          }
        }
      } else {
        // EveryDay=전행×전 D_ / Mon~Sun=전행×해당 요일 D_ 컬럼.
        for (let row = 0; row < g.rows.length; row++) {
          for (let col = 0; col < g.columns.length; col++) {
            const binding = g.columns[col]?.binding ?? '';
            const dayCol = dayByBinding.get(binding);
            if (!dayCol) continue;
            if (!isEveryDay && dayCol.weekday.toUpperCase() !== targetWeekday) continue;
            writeCell(row, col);
          }
        }
      }

      if (wrote === 0) {
        void setAlert({ type: 'alert', content: t(MSG.NO_CELL_SELECTED, '_Please select editable cell(s).') });
        return false;
      }
      g.invalidate(true);
      return true;
    },
    [hasButton, dynColumns, gridRef, editTrackerRef, setAlert, t]
  );

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <WorkingTimeForm
        onSubmit={handleSearch}
        onDivisionChange={resetGrid}
      />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='Working-Time'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
        // 'Bulk Update'(btnInput) — AS-IS 조회조건의 Input 버튼을 버튼영역으로 이동(2026-10-15 사용자 지시, 자매 SCP0096).
        //   라벨은 자매 SCP0098(capa-mobility-it) 과 동일하게 평문 'Bulk Update'(LBL 코드 미등록 — 평문 라벨 재사용).
        //   SAVE 권한일 때만 노출(SCP0019 는 EDIT 메타 미등록 — SAVE 가 편집권한 축). 클릭 → 조회 가드 후 팝업 오픈.
        customButtons={hasButton('SAVE') ? [{ label: 'Bulk Update', action: handleInputOpen }] : []}
      />
      <WorkingTimeGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        data={rows}
        dynColumns={dynColumns}
      />
      <WorkingTimeInputModal
        open={inputModalOpen}
        onClose={() => setInputModalOpen(false)}
        onConfirm={handleInputConfirm}
      />
    </>
  );
};
