import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { type EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ShipmentWorkingDayOspForm } from './components/ShipmentWorkingDayOspForm';
import { ShipmentWorkingDayOspGrid } from './components/ShipmentWorkingDayOspGrid';
import { ShipmentWorkingDayOspInputModal } from './components/ShipmentWorkingDayOspInputModal';
import {
  DAY_WEEK,
  INPUT_VALUE_SET,
  MEASURE_CONST,
  MENU_ID,
  MSG,
  RESPONSE_SET,
  SAVE_KEYS,
  SHEETS,
  WEEKDAY_CODE_TO_INDEX,
} from './shipment-working-day-osp.constants';
import { buildDynDayColumns } from './shipment-working-day-osp.dynamic-columns';
import type {
  CalendarColumnRow,
  DynColumnMeta,
  DynDayColumn,
  SaveEntry,
  ShipmentWorkingDayOspRow,
} from './shipment-working-day-osp.types';
import { useShipmentWorkingDayOspStore } from './useShipmentWorkingDayOspStore';

// AS-IS GSCM.SCP.Forms.UIL Master SCP0096_Shipment_Working_Day_OSP (Supply > Supply Master > Shipment Working Day(OSP)).
//   조회형+편집형 마스터 — 조회(GET SP 4 IN, O_RC1 데이터 + O_RESULT_CURSOR 상태) 후 EditButton(SwitchLock)
//   편집모드에서 WORKING_TIME_DEFAULT + 동적 D_ 일자 셀(Y/N)만 개방(03 §3-a). SAVE SP 로 '^' 배열 저장.
//   데이터는 GET O_RC1(동적 PIVOT), 동적 D_/W_/M_ 컬럼 목록은 별도 CALENDAR(3SPAN) SP 응답에서 도출한다.
//   AS-IS GetSpdTitle(3SPAN) 2콜 재현 — call-proc 경로는 O_RC1 컬럼 메타 사이드카를 안 주기 때문(03 §4).
//   버튼: SEARCH/SAVE + EDIT(실동작 편집모드) + btnInput. Insert/Delete = AS-IS NO-OP(01_layout §2-a).
//   SCP0019 대비 델타: 정적 6컬럼 / 명시 편집모드(행 게이트 아님) / D_ 셀 Y/N 콤보 / SUM 열 chkSum 토글.
export const ShipmentWorkingDayOsp = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGrid<ShipmentWorkingDayOspRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  // 그리드 공용 EditTracker — 변경 셀의 단일 진실원('M' 표기와 동일 출처). 저장 payload 는 여기서 도출.
  const editTrackerRef = useRef<EditTracker<ShipmentWorkingDayOspRow>>();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const queryClient = useQueryClient();

  const isOpenSearchArea = useShipmentWorkingDayOspStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useShipmentWorkingDayOspStore(state => state.setOpenSearchArea);
  const searchParams = useShipmentWorkingDayOspStore(state => state.searchParams);
  const filters = useShipmentWorkingDayOspStore(state => state.filters);
  const setFilters = useShipmentWorkingDayOspStore(state => state.setFilters);
  const clearFilters = useShipmentWorkingDayOspStore(state => state.clearFilters);
  const fetchStaticColumns = useShipmentWorkingDayOspStore(state => state.fetchStaticColumns);
  // F6 개인화 조회조건 복원(저장분 되불러오기) — mount 1회(conditionsRestored 가드).
  const restoreSearchConditions = useShipmentWorkingDayOspStore(
    state => state.restoreSearchConditions
  );

  // ui-dynamic-property-management — Menu Button 권한 동적 fetch
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // 명시 조회 게이트 — persist 된 stale filters 자동 발사 차단 (DMF0014/DMF0048 선례)
  const [hasSearched, setHasSearched] = useState(false);
  // 저장 in-flight — 재진입(더블클릭) 차단. SalesPlan(DMF0021) isPending 표준 1:1.
  const [isPending, setIsPending] = useState(false);
  // 값입력 팝업(ShipmentWorkingDayOspInputModal) — 버튼영역 '입력' 버튼이 연다(2026-10-15 사용자 지시).
  const [inputModalOpen, setInputModalOpen] = useState(false);
  // 편집 권한 — mount 1회 판정(convert-core §2.4 / 선례 SCP0120·SSP0025). AS-IS EditButton(SwitchLock)
  //   토글은 미채용: 권한 있으면 조회 직후 WORKING_TIME_DEFAULT+D_ 편집 가능, 없으면 읽기전용.
  const canEdit = hasButton('EDIT');
  // W_/M_ SUM 열은 항상 숨김(showSum=false 고정). AS-IS 는 SUM 토글을 chkSum "체크박스"(영역1)로 두었고
  //   별도 Sum "버튼"은 없다 → SubTitle Sum 버튼 제거(2026-10-13 사용자 지시). 버킷은 Daily 고정(03 §6.4)이라
  //   W_/M_ 값도 GET 에 없어 토글 무의미. 체크박스가 필요해지면 영역1 Form 에 재도입한다.

  // 메인 그리드 SP — PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP (4 IN + O_RC1 데이터 + O_RESULT_CURSOR 상태).
  //   O_RC1 은 동적 PIVOT 데이터(행마다 D_yyyymmdd 값)지만, call-proc 경로는 커서의 컬럼 메타(o_rc1_columns)
  //   를 함께 발행하지 않는다 → 동적 컬럼 목록은 아래 CALENDAR(3SPAN) 응답에서 도출한다(AS-IS 2콜 재현).
  const { data, isFetching } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: hasSearched && !!filters[SHEETS.MAIN],
  });
  // 동적 pivot 헤더 SP — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN(공용, 조회기간→D_/W_/M_ 컬럼셋).
  //   AS-IS GetSpdTitle(3SPAN) 2콜 재현(03 §4): 이 커서의 COLUMN_NAME 이 동적 컬럼 목록의 단일 원천이다.
  //   데이터 커서(o_rc1)는 희소(값 없는 행은 D_ 키 자체가 없음)+컬럼 메타 미발행이라 컬럼을 못 주기 때문.
  const { data: calendarData } = useTabProcQuery<MENU_ID, SHEETS.CALENDAR>({
    menuId: MENU_ID,
    sheetName: SHEETS.CALENDAR,
    tabId,
    filters: filters[SHEETS.CALENDAR],
    enabled: hasSearched && !!filters[SHEETS.CALENDAR],
  });

  // 참조 고정 필수: useMemo 없이 ?? [] 로 만들면 조회조건 타이핑/드롭다운마다 부모가 리렌더될 때 매번 새
  //   배열이 되어 Grid data/dynColumns prop 참조가 바뀐다 → grid dynamicColumns useMemo 재계산(깜빡임).
  //   data(react-query 캐시)가 실제로 바뀔 때만 새 참조가 되도록 고정한다.
  const rows = useMemo<ShipmentWorkingDayOspRow[]>(
    () => (data as Record<string, ShipmentWorkingDayOspRow[]>)?.[RESPONSE_SET.MAIN] ?? [],
    [data]
  );
  // 동적 컬럼 메타 — CALENDAR(3SPAN) o_rc1 의 COLUMN_NAME(D_/W_/M_). D_ 일자열·W_/M_ SUM 열 파생 원천.
  //   컬럼명만 취하면 기존 파생(buildDynDayColumns/buildDynSumColumns)이 yyyymmdd 로 3단 헤더·요일색을
  //   재현한다(03 §1-b). 데이터는 MAIN o_rc1 의 동명 키에서 바인딩된다.
  const dynColumnMeta = useMemo<DynColumnMeta[]>(
    () =>
      ((calendarData as unknown as Record<string, CalendarColumnRow[]>)?.[RESPONSE_SET.CALENDAR] ?? [])
        .map(r => ({
          name: String(r.COLUMN_NAME ?? ''),
          // 3SPAN SP 라벨 — 월/주차 머지헤더 그룹·라벨의 정본(SCM_SYS_CALENDAR_M ISO 주차). 03 §1-b.
          weekName: r.SMALL_CLASS_LABEL_NAME != null ? String(r.SMALL_CLASS_LABEL_NAME) : undefined,
          monthName: r.LARGE_CLASS_LABEL_NAME != null ? String(r.LARGE_CLASS_LABEL_NAME) : undefined,
          dayCode: r.DAY_CODE != null ? String(r.DAY_CODE) : undefined,
        }))
        .filter(c => c.name !== ''),
    [calendarData]
  );
  // 동적 D_ 일자열 — CALENDAR(3SPAN) COLUMN_NAME 의 D_yyyymmdd 에서 파생. 3단 머지헤더(월/주/일) 그룹은
  //   라벨 커서를 쓰지 않고 yyyymmdd 로 클라이언트 계산한다(기존 로직 유지, 03 §1-b).
  const dynColumns = useMemo<DynDayColumn[]>(() => buildDynDayColumns(dynColumnMeta), [dynColumnMeta]);

  // mount 시 1회 admin 메타 fetch + persist 된 이전 filters 무효화 (NULL payload SP 자동호출 방지)
  useEffect(() => {
    clearFilters();
    editTrackerRef.current?.clearChanges();
    void fetchStaticColumns();
    // F6 저장조건 복원 — 새로고침/재진입(새 store) 시 저장분을 searchParams 에 1회 주입(가드 self).
    void restoreSearchConditions();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // ----- 조회 validation (AS-IS FindData_Main → checkRequiredOfSearch .cs:435 — Division/기간 필수) -----
  const validateFind = (): boolean => {
    if (isFetching) return false;
    // Division 필수 (cboDivision 단일 필수, 02_search-combo §1)
    if (!searchParams.divisionId) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRED, '_Please select Division.') });
      return false;
    }
    // 기간(Period) 필수 — AS-IS checkRequiredOfSearch 는 Division 과 함께 기간도 필수 체크한다(.cs:435).
    //   Division 선택 시 dayRange SP 로 기본기간이 자동 세팅되나, 사용자가 비우면 공란이 될 수 있어 방어.
    if (!searchParams.startYyyymmdd || !searchParams.endYyyymmdd) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRED, '_Please enter the Period.') });
      return false;
    }
    // 기간 역전 차단 (from > to)
    if (Number(searchParams.startYyyymmdd) > Number(searchParams.endYyyymmdd)) {
      void setAlert({ type: 'alert', content: t(MSG.INVALID_PERIOD, '_Invalid period (start > end).') });
      return false;
    }
    return true;
  };

  // F5 Search — refetch?.() 직접 호출 금지 (stale closure — setFilters + invalidateQueries 표준).
  //   invalidate 키는 tabId — useTabProcQuery queryKey 는 [tabId, sheetName, action, filters].
  //   (편집모드 토글 미채용이라 조회 후 잠금 복귀 단계 없음 — 미저장 편집은 clearChanges 로 버린다.)
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
  //   disabled 되어 rows·헤더가 비고, hasSearched=false 로 명시 조회 게이트도 되돌아간다. 편집모드도 해제.
  const resetGrid = () => {
    editTrackerRef.current?.clearChanges();
    setHasSearched(false);
    clearFilters();
  };

  // ----- F7 Save — 편집(편집모드 개방분)의 D_ 일자 셀 + WORKING_TIME_DEFAULT net 변경을 '^' 배열로 -----
  //   SAVE SP P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP 는 7 CLOB '^' 구분 배열이므로 apiClient.post 직접
  //   (useProcMutation array unfold 안 함 — WorkingTime/DMF0014 표준 선례). M-only 전송(03 §6-1: I/D 없음).
  const handleSave = async () => {
    // 재진입 가드 (SalesPlan blockIfWorking 1:1) — 조회/저장이 아직 돌고 있으면 차단.
    if (isFetching || isPending) {
      void setAlert({ type: 'alert', content: t(MSG.WORK_IN_PROGRESS, '_이전 작업이 아직 실행 중입니다.') });
      return;
    }
    // 저장 payload 는 그리드 공용 EditTracker 에서 직접 도출한다(편집↔저장 사이 재렌더에 안전한 단일 출처).
    //   (1) 열린 편집기 강제 커밋 → (2) 변경맵 순회로 D_ 일자 셀(Y/N)·WORKING_TIME_DEFAULT net 변경만 수집.
    gridRef.current?.finishEditing(true);

    const toStr = (v: unknown): string =>
      typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
    const changed = editTrackerRef.current?.getOriginalValues();
    const entries: SaveEntry[] = [];
    if (changed) {
      for (const [item, fields] of changed) {
        const rec = item as unknown as Record<string, unknown>;
        for (const binding of Object.keys(fields)) {
          // 편집 가능 셀 = 동적 D_ 일자 셀(Y/N) 또는 WORKING_TIME_DEFAULT(FPNumber).
          const isDay = /^D_\d{8}$/.test(binding);
          const isDefault = binding === 'WORKING_TIME_DEFAULT';
          if (!isDay && !isDefault) continue;
          entries.push({
            divisionId: toStr(item.DIVISION_ID),
            plantSiteId: toStr(item.PLANT_SITE_ID),
            // isSaveDefault='Y'(WORKING_TIME_DEFAULT 저장)면 yyyymmdd 미사용, 아니면 D_ 일자.
            yyyymmdd: isDefault ? '' : binding.replace('D_', ''),
            // MEASURE 고정 — GET 이 O_RC1 에 채우는 'SHIPMENT WORKING DAY' 그대로 전송(03 §4 P_MEASURE).
            measure: MEASURE_CONST,
            // D_ 셀 Y/N (WORKING_TIME_DEFAULT 저장분기면 미사용).
            shipmentYn: isDefault ? '' : toStr(rec[binding]).toUpperCase(),
            // WORKING_TIME_DEFAULT 값 — 콤마 제거(FPNumber 표시서식). D_ 저장분기면 미사용.
            workingTimeDefault: isDefault ? toStr(rec[binding]).replace(/,/g, '') : '',
            // 'Y'=WORKING_TIME_DEFAULT 저장 / 'N'=D_ 일자셀 저장(is_save_defalut 분기, 03 §4).
            isSaveDefault: isDefault ? 'Y' : 'N',
          } as SaveEntry);
        }
      }
    }
    if (entries.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.NO_SAVE_DATA, '_No data to save.') });
      return;
    }
    // 저장 confirm 없음(표준화) — 저장은 되돌릴 수 있고 결과는 Toast 로 알린다. WorkingTime/DMF0014 동일.
    const sesUserId = useSessionStore.getState().session.userId ?? '';
    // payload — 7 CLOB 은 '^' 구분 다건 배열(SAVE_KEYS), P_USER_ID 는 단일 VARCHAR.
    //   SAVE SP all_arguments 실측(SCM_ADM_PROC_M): userId=VARCHAR IN(단일), 나머지 7=CLOB IN(배열).
    //   그래서 userId 는 '^' 배열이 아니라 세션 userId 단일값으로 보낸다 — 전행 공통 LAST_UPDATED_BY/
    //   CREATED_BY 채움(배열/List 접미로 보내면 COL_NM 'userId' 미매핑 → P_USER_ID NULL → ORA-01407).
    const payload = {
      ...Object.fromEntries(SAVE_KEYS.map(k => [k, entries.map(e => e[k]).join('^')])),
      userId: sesUserId,
    };

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
      // SP 응답계약(03 §4): O_RESULT_CURSOR.RESULT_CODE='F' 는 내부 예외를 캐치해 정상 200 커서로
      //   반환한다(axios 전역 인터셉터는 필드명 CODE 만 검사해 이 필드를 못 잡음) — 여기서 직접 분기.
      //   주의: BE 는 OUT 커서명을 소문자화해 응답 키로 쓴다(BaseService) → 'o_result_cursor'(=RESPONSE_SET.STATUS).
      //   대문자 'O_RESULT_CURSOR' 로 읽으면 항상 undefined → RESULT_CODE='F' 실패를 놓쳐 거짓 성공 처리되고
      //   AS-IS GMessageBoxForException(cs:632·644) 상당 에러 알럿이 안 뜬다(2026-10-13 실사고).
      const resultRow = (
        (res.data as { result?: Record<string, { RESULT_CODE?: string; ERR_MESSAGE?: string }[]> })
          ?.result?.[RESPONSE_SET.STATUS] ?? []
      )[0];
      if (resultRow?.RESULT_CODE?.trim().toUpperCase() === 'F') {
        void setAlert({
          type: 'alert',
          content: resultRow.ERR_MESSAGE?.trim() || t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.'),
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

  // SubTitle 공통버튼 — hasButton 권한 분기. Insert/Delete = AS-IS NO-OP(01_layout §2 #7·#8, .cs:274-280 본문
  //   공백): 버튼은 노출하되 클릭 무동작. 무동작 함수 () => undefined 로 배선한다 — false 면 버튼이 숨겨지고
  //   (SubTitle 은 insert/delete === false 일 때만 렌더 생략), 키 생략이면 공통 SubTitle 기본 addRow/removeRow 가
  //   부활한다. 둘 다 설계 금지(03_grid-columns §4·§5).
  //   Edit 는 Hotkeys enum 에 없어(hotkey.ts) hotkeyConfig 로는 배선 불가 — customButtons 로 노출한다.
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    save: canEdit && hasButton('SAVE') ? () => void handleSave() : false,
    insert: false, // () => undefined, // AS-IS NO-OP — 버튼 노출 + 클릭 무동작(.cs:274-276 공백) 
    delete: false, // () => undefined, // AS-IS NO-OP — 버튼 노출 + 클릭 무동작(.cs:278-280 공백)
    manual: false,
    upload: false,
  };

  // '입력' 버튼(버튼영역) 클릭 — 팝업 오픈 가드. 조회 전이면 차단(persist 된 stale 화면 값입력 금지, MSG00135).
  //   편집 권한(canEdit)은 버튼 노출 자체를 막으므로(customButtons 조건) 여기선 조회 여부만 본다.
  const handleInputOpen = useCallback((): void => {
    if (!hasSearched) {
      void setAlert({ type: 'alert', content: t(MSG.SEARCH_FIRST, '_Please search first.') });
      return;
    }
    setInputModalOpen(true);
  }, [hasSearched, setAlert, t]);

  // 값입력 확정(팝업 OK) — Day of the week + Input Value(Y/N)를 선택/요일 D_ 셀에 일괄 써넣는다(03 §3-b SetText).
  //   EditTracker 를 경유해 setCellData 로 write 한다(저장 payload 는 EditTracker 단일 출처 그대로 도출).
  //   true = 성공(팝업 닫기) / false = 가드 실패(팝업 유지) — 샘플 capa-mobility-it handleBulkConfirm 동형.
  //   일괄입력 3분기(03 §3-b): SelectDay=선택셀 / EveryDay=전체 D_ / 요일별=해당 weekday D_.
  const handleInputConfirm = useCallback(
    (dayWeekCode: string, inputValue: string): boolean => {
      // 편집 권한 없으면 값입력 금지(방어 — 버튼이 숨겨져 정상경로 미도달).
      if (!canEdit) return false;

      // 형식 검증 — Y/N 만(cboInputValue YesOrNo 소스라 정상경로는 항상 통과, 빈값·오염 방어, MSG00050).
      const raw = inputValue.trim().toUpperCase();
      if (!INPUT_VALUE_SET.includes(raw)) {
        void setAlert({ type: 'alert', content: t(MSG.INVALID_FORMAT, '_Invalid input value.') });
        return false;
      }

      const g = gridRef.current;
      if (!g) {
        void setAlert({ type: 'alert', content: t(MSG.NO_CELL_SELECTED, '_Please select cell(s).') });
        return false;
      }
      const isSelectDay = dayWeekCode === DAY_WEEK.SELECT_DAY;
      const isEveryDay = dayWeekCode === DAY_WEEK.EVERY_DAY;
      // 요일별 분기 대상 weekday(0=일~6=토). EveryDay/SelectDay 면 미사용.
      const targetWeekday = WEEKDAY_CODE_TO_INDEX[dayWeekCode];

      // 대상 D_ 컬럼 판정 — SelectDay 는 선택영역만, 그 외는 요일 규칙(전행 × 규칙 D_ 컬럼).
      const dayByBinding = new Map<string, DynDayColumn>(dynColumns.map(d => [d.binding, d]));
      const tracker = editTrackerRef.current;
      let wrote = 0;

      const writeCell = (row: number, col: number): void => {
        const item = (g.rows[row] as { dataItem?: ShipmentWorkingDayOspRow } | undefined)?.dataItem;
        const binding = g.columns[col]?.binding ?? '';
        if (!item || !/^D_\d{8}$/.test(binding)) return;
        const original = g.getCellData(row, col, false) as WijmoPrimitive;
        g.setCellData(row, col, raw, true);
        tracker?.storeChange(item, binding, original, raw);
        wrote += 1;
      };

      if (isSelectDay) {
        // SelectDay — 선택 셀에만. 선택영역의 D_ 셀만 write. 선택영역이 없으면 대상 없음(MSG00134).
        const sel = g.selectedRanges;
        if (!sel || sel.length === 0) {
          void setAlert({
            type: 'alert',
            content: t(MSG.NO_CELL_SELECTED, '_Please select cell(s).'),
          });
          return false;
        }
        for (const range of sel) {
          for (let row = range.topRow; row <= range.bottomRow; row++) {
            for (let col = range.leftCol; col <= range.rightCol; col++) writeCell(row, col);
          }
        }
      } else {
        // EveryDay=전체 D_ / 요일별=해당 weekday D_. 전행 × 규칙 D_ 컬럼.
        for (let row = 0; row < g.rows.length; row++) {
          for (let col = 0; col < g.columns.length; col++) {
            const binding = g.columns[col]?.binding ?? '';
            const dayCol = dayByBinding.get(binding);
            if (!dayCol) continue;
            if (!isEveryDay && dayCol.weekday !== targetWeekday) continue;
            writeCell(row, col);
          }
        }
      }

      if (wrote === 0) {
        void setAlert({
          type: 'alert',
          content: t(MSG.NO_CELL_SELECTED, '_Please select editable cell(s).'),
        });
        return false;
      }
      g.invalidate(true);
      return true;
    },
    [canEdit, dynColumns, gridRef, editTrackerRef, setAlert, t]
  );

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <ShipmentWorkingDayOspForm onSubmit={handleSearch} onDivisionChange={resetGrid} />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='Shipment-Working-Day-OSP'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
        // 'Bulk Update'(btnInput) — AS-IS 조회조건의 Input 버튼을 버튼영역으로 이동(2026-10-15 사용자 지시).
        //   편집 권한(canEdit)일 때만 노출. 클릭 → 조회 가드 후 값입력 팝업 오픈(샘플 capa-mobility-it Bulk Update 동형).
        //   라벨은 샘플 BulkUpdateModal 과 동일하게 'Bulk Update' 리터럴(2026-11-04 사용자 지시).
        customButtons={canEdit ? [{ label: 'Bulk Update', action: handleInputOpen }] : []}
      />
      <ShipmentWorkingDayOspGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        data={rows}
        dynColumns={dynColumns}
        dynColumnMeta={dynColumnMeta}
        editMode={canEdit}
        showSum={false}
      />
      {/* 값입력 팝업 — Day of the week + Input Value 를 받아 선택/요일 D_ 셀에 일괄 입력(OK 성공 시 닫힘). */}
      <ShipmentWorkingDayOspInputModal
        open={inputModalOpen}
        onClose={() => setInputModalOpen(false)}
        onConfirm={handleInputConfirm}
      />
    </>
  );
};
