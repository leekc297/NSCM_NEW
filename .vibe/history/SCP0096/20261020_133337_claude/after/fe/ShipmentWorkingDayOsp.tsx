import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { type EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ShipmentWorkingDayOspForm } from './components/ShipmentWorkingDayOspForm';
import { ShipmentWorkingDayOspGrid } from './components/ShipmentWorkingDayOspGrid';
import { useShipmentWorkingDayOspInputValue } from './hooks/useShipmentWorkingDayOspInputValue';
import {
  LBL,
  MEASURE_CONST,
  MENU_ID,
  MSG,
  RESPONSE_SET,
  SAVE_KEYS,
  SHEETS,
  WTD_RANGE,
} from './shipment-working-day-osp.constants';
import { buildDynDayColumns } from './shipment-working-day-osp.dynamic-columns';
import type {
  DynColumnMeta,
  DynDayColumn,
  SaveEntry,
  ShipmentWorkingDayOspRow,
} from './shipment-working-day-osp.types';
import { useShipmentWorkingDayOspStore } from './useShipmentWorkingDayOspStore';

// AS-IS GSCM.SCP.Forms.UIL Master SCP0096_Shipment_Working_Day_OSP (Supply > Supply Master > Shipment Working Day(OSP)).
//   조회형+편집형 마스터 — 조회(GET SP 4 IN, O_RC1 데이터 + O_RESULT_CURSOR 상태) 후 EditButton(SwitchLock)
//   편집모드에서 WORKING_TIME_DEFAULT + 동적 D_ 일자 셀(Y/N)만 개방(03 §3-a). SAVE SP 로 '^' 배열 저장.
//   GET SP 단일 호출로 데이터(O_RC1)와 컬럼 메타(o_rc1_columns)를 함께 받는다 — 시트는 MAIN 하나뿐,
//   동적 D_/W_/M_ 은 o_rc1_columns 에서 도출한다(타이틀 커서 없음, SCP0019 동형).
//   버튼: SEARCH/SAVE + EDIT(권한 게이트) + btnInput. Insert/Delete = AS-IS NO-OP(01_layout §2-a).
//   SCP0019 대비 델타: 정적 6컬럼 / 편집 = INPUT_TP_CD 메타 + EDIT 권한 / D_ 셀 Y/N 콤보.
//   chkSum(SUM 토글)은 AS-IS Designer Visible=false(:346) + GET SP 에 W_/M_ 컬럼 없음(AS-IS MSSQL·사내 Oracle 모두 D_ 만 PIVOT)
//   = 살아있는 동작 없음(#138) → 버튼 비노출, Grid 의 SUM 처리 코드는 비활성 보존(2026-10-20 정정, 원장 S96-13).
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
  const dayRangeApplied = useShipmentWorkingDayOspStore(state => state.dayRangeApplied);
  const applyDayRange = useShipmentWorkingDayOspStore(state => state.applyDayRange);

  // ui-dynamic-property-management — Menu Button 권한 동적 fetch
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // 명시 조회 게이트 — persist 된 stale filters 자동 발사 차단 (DMF0014/DMF0048 선례)
  const [hasSearched, setHasSearched] = useState(false);
  // 저장 in-flight — 재진입(더블클릭) 차단. SalesPlan(DMF0021) isPending 표준 1:1.
  const [isPending, setIsPending] = useState(false);
  // 편집 권한 — mount 1회 판정(convert-core §2.4 / 선례 SCP0120·SSP0025). AS-IS EditButton(SwitchLock)
  //   토글은 미채용: 권한 있으면 조회 직후 WORKING_TIME_DEFAULT+D_ 편집 가능, 없으면 읽기전용.
  const canEdit = hasButton('EDIT');
  // chkSum — AS-IS DefineProperty chkSum.Checked=false(.cs:121)에 더해 Designer `this.chkSum.Visible = false`(:346)라
  //   사용자가 켤 수 없고, GET SP 도 W_/M_ SUM 컬럼을 만들지 않는다 → SUM 열은 항상 숨김(토글 UI 없음). Grid 의 showSum 은 고정 false.

  // 기본 조회기간 — 서버 dayRange(사내 배선 SCP0096 / dayRange / SEARCH → PKG_COM0000.P_SCM0001_GET_SCP_MONTH_PERIOD).
  //   AS-IS InitControls `dCalendar.InitValue = GetDayRange()`(.cs:137,840-846 → DateUtil.GetDayRange(cboDivision,'DAILY')
  //   → SCP.SCM0001_GET_SCP_MONTH_PERIOD, DateUtil.cs:330) 1:1 — 프레임워크 유틸 호출이라 flow.csv 에 없다(DoD B24).
  //   응답 o_rc1[0].PERIOD('yyyymmdd:yyyymmdd')를 1회 적용(BusinessPlan dayRange 정본 패턴). filters 는 useMemo(인라인 리터럴 금지).
  //   키 5개 = 사내 PROC_M COL_NM(proc_params.csv · DoD B22). 값 = AS-IS DateUtil.GetDayRange(cboDivision,"DAILY") 실전송값
  //   (sPlanDate=''·sOffsetMonth='12' 기본인자). timeZone 은 TO-BE UserSession 에 타임존 필드가 없어 ''(자매 shipping 화면 동일) —
  //   SP 가 FN_MULTY_TIME('') 로 오늘 기준 산출. 사내 실측 2026-10-20: '' → '20261020:20271017' / 'Asia/Seoul' → NULL 이므로 빈값이 정답.
  //   Reset Condition(F10) 후 재적용: reset() 이 dayRangeApplied 를 false 로 되돌려도 쿼리 캐시 참조는 그대로라 data 만으론
  //   effect 가 다시 돌지 않는다 — dayRangeApplied 를 deps 에 두어 캐시된 서버 구간을 다시 적용한다.
  const dayRangeFilters = useMemo(
    () => ({
      divisionId: searchParams.divisionId, // 1 P_DIVISION_ID (AS-IS cboDivision.ControlValues)
      planCycle: 'DAILY', //                  2 P_PLAN_CYCLE  (AS-IS "DAILY")
      fromDate: '', //                        3 P_FROM_DATE   (AS-IS sPlanDate 기본 '')
      offsetMonth: '12', //                   4 P_OFFSET_MONTH(AS-IS sOffsetMonth 기본 "12")
      timeZone: '', //                        5 P_TIMEZONE    (세션 타임존 없음 → '' = SP 오늘 기준)
    }),
    [searchParams.divisionId]
  );
  const { data: dayRangeData } = useTabProcQuery<MENU_ID, SHEETS.DAY_RANGE>({
    menuId: MENU_ID,
    sheetName: SHEETS.DAY_RANGE,
    tabId,
    filters: dayRangeFilters,
    enabled: !dayRangeApplied,
  });
  useEffect(() => {
    if (dayRangeApplied) return;
    const range = (dayRangeData as Record<string, { PERIOD?: string }[]>)?.[RESPONSE_SET.MAIN]?.[0]?.PERIOD;
    if (range) applyDayRange(range);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [dayRangeData, dayRangeApplied]);

  // 메인 그리드 SP — PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP (4 IN + O_RC1 데이터 + O_RESULT_CURSOR 상태).
  //   단일 호출로 데이터(o_rc1)와 그 컬럼 메타(o_rc1_columns)를 반환하므로 rows·동적컬럼을 이 응답에서 도출한다.
  const { data, isFetching } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: hasSearched && !!filters[SHEETS.MAIN],
  });

  // 참조 고정 필수: useMemo 없이 ?? [] 로 만들면 조회조건 타이핑/드롭다운마다 부모가 리렌더될 때 매번 새
  //   배열이 되어 Grid data/dynColumns prop 참조가 바뀐다 → grid dynamicColumns useMemo 재계산(깜빡임).
  //   data(react-query 캐시)가 실제로 바뀔 때만 새 참조가 되도록 고정한다.
  const rows = useMemo<ShipmentWorkingDayOspRow[]>(
    () => (data as Record<string, ShipmentWorkingDayOspRow[]>)?.[RESPONSE_SET.MAIN] ?? [],
    [data]
  );
  // 동적 컬럼 메타 원본 — o_rc1_columns(BE ResultSetMetaData). D_ 일자열·W_/M_ SUM 열 파생 원천.
  //   rows 와 같은 단일 `as` 로 좁힌다(`as unknown as` 금지 #73 — SCP0096 은 procedures.d.ts 미등재라 응답 제네릭이 느슨, GEN_NOTES 8).
  const dynColumnMeta = useMemo<DynColumnMeta[]>(
    () => (data as Record<string, DynColumnMeta[]>)?.[RESPONSE_SET.DYN_COLUMNS] ?? [],
    [data]
  );
  // 동적 D_ 일자열 — o_rc1_columns 의 D_yyyymmdd 이름에서 파생. 3단 머지헤더(월/주/일) 그룹은 커서가
  //   주지 않으므로 yyyymmdd 로 클라이언트 계산한다(3SPAN 헤더 원리 재현). 데이터 커서에 타이틀 메타 없음.
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

  // ----- 조회 validation (AS-IS FindData_Main `DataUtil.checkRequiredOfSearch(this.Controls)` .cs:432 —
  //   Designer 필수 표식 "Division*"(:545) · "Period*"(:532) 2건) -----
  const validateFind = (): boolean => {
    if (isFetching) return false;
    // Division 필수 (cboDivision 단일 필수, 02_search-combo §1) — MSG00097 "Division 을 선택하세요."
    if (!searchParams.divisionId) {
      void setAlert({ type: 'alert', content: t(MSG.DIVISION_REQUIRED, '_Please select Division.') });
      return false;
    }
    // Period 필수 (dCalendar "Period*") — 시작·종료 8자리 모두 있어야 한다. MSG00429 "{0} 값은 필수 입력 항목입니다."
    //   (2026-10-20 추가 — 이전에는 역전만 검사해 빈 기간이 SP 로 전송됐다, 원장 S96-9.)
    if (!/^\d{8}$/.test(searchParams.startYyyymmdd) || !/^\d{8}$/.test(searchParams.endYyyymmdd)) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_VALUE, '_{0} value is required.').replace('{0}', t(LBL.PERIOD, '_Period')),
      });
      return false;
    }
    // 기간 역전 차단 (from > to) — MSG00108 "조회 기간이 잘못되었습니다 (시작일 > 종료일)."
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
        // 행 타입의 index signature([key]: string|number|null)로 동적 D_ 셀을 직접 읽는다(`as unknown as` 금지 #73).
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
            shipmentYn: isDefault ? '' : toStr(item[binding]).toUpperCase(),
            // WORKING_TIME_DEFAULT 값 — 콤마 제거(FPNumber 표시서식). D_ 저장분기면 미사용.
            workingTimeDefault: isDefault ? toStr(item[binding]).replace(/,/g, '') : '',
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
    // WORKING_TIME_DEFAULT 제약 — AS-IS SetReNumerCellType(…, 소수 0, 최소 0, 최대 7)(.cs:163)은 셀 타입이 입력 단계에서 막던 것.
    //   TO-BE 공용 DataGrid 숫자 편집기는 범위를 모르므로 저장 직전에 판정한다(사내 SAVE SP F_TO_NUM 도 범위 검사 없음).
    //   빈값('')은 AS-IS "0" 치환(.cs:567) = SP F_TO_NUM(NULL)=0 과 동등이라 통과시킨다. (2026-10-20 추가, 원장 S96-8)
    for (const e of entries) {
      if (e.isSaveDefault !== 'Y' || e.workingTimeDefault === '') continue;
      const n = Number(e.workingTimeDefault);
      if (!Number.isInteger(n)) {
        void setAlert({ type: 'alert', content: t(MSG.WTD_INTEGER, '_Only integer values can be entered!') });
        return;
      }
      if (n < WTD_RANGE.MIN || n > WTD_RANGE.MAX) {
        void setAlert({
          type: 'alert',
          content: t(MSG.WTD_RANGE, '_Please enter a number between {0} and {1}.')
            .replace('{0}', String(WTD_RANGE.MIN))
            .replace('{1}', String(WTD_RANGE.MAX)),
        });
        return;
      }
    }
    // 저장 confirm 없음(표준화) — 저장은 되돌릴 수 있고 결과는 Toast 로 알린다. WorkingTime/DMF0014 동일.
    const sesUserId = useSessionStore.getState().session.userId ?? '';
    // userIdList — BE 가 가로채지 않는 키명. userId 는 BE 세션 단일값으로 덮여 '^'×N 배열이 1토큰으로
    //   붕괴 → SP split 2행째부터 NULL. List 접미로 배열 붕괴 방지(WorkingTime/DMF0014 선례).
    const arr = entries.map(e => ({ ...e, userIdList: sesUserId }));
    const payload = Object.fromEntries(SAVE_KEYS.map(k => [k, arr.map(r => r[k]).join('^')]));

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
      //   응답 키 = BE BaseService 가 PROC_M COL_NM 그대로 쓰는 소문자 'o_result_cursor'(proc_params.csv SAVE 9번째 행 ·
      //   RESPONSE_SET.STATUS). 이전 대문자 'O_RESULT_CURSOR' 는 항상 undefined 라 'F' 를 못 잡았다(2026-10-20 정정, 원장 S96-12).
      type SaveResultRow = { RESULT_CODE?: string; RESULT_CNT?: number | string; ERR_MESSAGE?: string };
      const resultRow = (
        (res.data as { result?: Record<string, SaveResultRow[]> })?.result?.[RESPONSE_SET.STATUS] ?? []
      )[0];
      if (resultRow?.RESULT_CODE?.trim().toUpperCase() === 'F') {
        void setAlert({
          type: 'alert',
          content: resultRow.ERR_MESSAGE?.trim() || t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.'),
        });
        return;
      }
      // 성공 — AS-IS MSG00004("{0}개의 데이터가 저장되었습니다", iCount .cs:622) = TO-BE MSG00672. {0} = SP RESULT_CNT(없으면 전송 건수).
      const savedCount = String(resultRow?.RESULT_CNT ?? entries.length);
      void setToast({
        message: t(MSG.SAVED_COUNT, '_{0} data saved.').replace('{0}', savedCount),
        type: 'success',
      });
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

  // SubTitle 공통버튼 — hasButton 권한 분기. Insert/Delete = AS-IS InsertButton/DeleteButton 본문 공백(.cs:274-280)
  //   = 기능 비활성(10_RULES_KEEP F1 "빈 본문 override = 비활성" · screen-completion-gate G2 "() => undefined 빈 핸들러 0건")
  //   + 사내 SCM_ADM_MNU_BTN_MPG_M(SCP0096) 정의 = EDIT/SAVE/SEARCH 뿐(2026-10-20 ZIOUI1 실측, INSERT/DELETE 행 없음)
  //   → menu-button-dynamic-fetch §1.1 "정의 자체 없음 = Visible ❌". false 명시(키 생략 시 공통 addRow/removeRow 부활 — 금지).
  //   (2026-10-20 정정: 이전 '() => undefined 노출·무동작' 은 위 두 룰과 admin 메타에 어긋났다.)
  //   Edit 는 Hotkeys enum 에 없어(hotkey.ts) hotkeyConfig 로는 배선 불가 — canEdit 권한으로 대체(mount 1회).
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    save: canEdit && hasButton('SAVE') ? () => void handleSave() : false,
    insert: false,
    delete: false,
    manual: false,
    upload: false,
  };

  // btnInput(값입력) — AS-IS BtnInput_Click(.cs:684-809) 6가드 + 3분기 SetText. 본문은 hooks/useShipmentWorkingDayOspInputValue.ts
  //   (진입 Page ≤400 라인 규약 #9·게이트 R16 으로 2026-10-20 분리, 본문 무변경 이식). gridRef/EditTracker 는 이 컴포넌트가 보유.
  const handleInputValue = useShipmentWorkingDayOspInputValue({
    gridRef,
    editTrackerRef,
    dynColumns,
    hasSearched,
    canEdit,
    dayWeekCode: searchParams.dayWeekCode,
    inputValue: searchParams.inputValue,
  });

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <ShipmentWorkingDayOspForm
        onSubmit={handleSearch}
        onDivisionChange={resetGrid}
        onInput={handleInputValue}
      />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='Shipment-Working-Day-OSP'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      {/* AS-IS Edit(SwitchLock) 토글은 미채용(convert-core §2.4) — canEdit 권한으로 대체. Sum 커스텀 버튼은 AS-IS 비노출 컨트롤이라 두지 않는다. */}
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
    </>
  );
};
