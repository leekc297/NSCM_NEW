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

import { WorkingTimeForm } from './components/WorkingTimeForm';
import { WorkingTimeGrid } from './components/WorkingTimeGrid';
import { useWorkingTimeStore } from './useWorkingTimeStore';
import {
  DAY_WEEK_SELECT_DAY,
  MENU_ID,
  MSG,
  RESPONSE_SET,
  SAVE_KEYS,
  SHEETS,
  WORKING_TIME_RANGE,
} from './working-time.constants';
import { buildDynDayColumns } from './working-time.dynamic-columns';
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
  const filters = useWorkingTimeStore(state => state.filters);
  const setFilters = useWorkingTimeStore(state => state.setFilters);
  const clearFilters = useWorkingTimeStore(state => state.clearFilters);
  const fetchStaticColumns = useWorkingTimeStore(state => state.fetchStaticColumns);
  const restoreSearchConditions = useWorkingTimeStore(state => state.restoreSearchConditions);

  // ui-dynamic-property-management — Menu Button 권한 동적 fetch
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // 명시 조회 게이트 — persist 된 stale filters 자동 발사 차단 (DMF0014/DMF0048 선례)
  const [hasSearched, setHasSearched] = useState(false);
  // 저장 in-flight — 재진입(더블클릭) 차단. SalesPlan(DMF0021) isPending 표준 1:1.
  const [isPending, setIsPending] = useState(false);

  // 메인 그리드 SP — PKG_SCP0019.P_SCP0019_GET_WORKING_TIME (7 IN + 세션 2 + O_RC1 데이터 + O_RESULT_CURSOR 상태).
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
  const rows = useMemo<WorkingTimeRow[]>(
    () => (data as Record<string, WorkingTimeRow[]>)?.[RESPONSE_SET.MAIN] ?? [],
    [data]
  );
  // 동적 D_ 컬럼 — o_rc1_columns(BE ResultSetMetaData)의 D_yyyymmdd 이름에서 파생. 요일 그룹은 커서가
  //   주지 않으므로 yyyymmdd 로 클라이언트 계산(SP "칸 펼치기" 원리). 데이터 커서에 타이틀 메타 없음.
  const dynColumns = useMemo<DynDayColumn[]>(
    () =>
      buildDynDayColumns(
        (data as unknown as Record<string, DynColumnMeta[]>)?.[RESPONSE_SET.DYN_COLUMNS] ?? []
      ),
    [data]
  );

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
      void setAlert({ type: 'alert', content: t(MSG.NOT_SEARCHED, '_Please select Division.') });
      return false;
    }
    // 기간 역전 차단 (from > to)
    if (Number(searchParams.startYyyymmdd) > Number(searchParams.endYyyymmdd)) {
      void setAlert({ type: 'alert', content: t(MSG.INVALID_FORMAT, '_Invalid period (start > end).') });
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
    // userIdList — BE 가 가로채지 않는 키명. userId 는 BE 세션 단일값으로 덮여 '^'×N 배열이 1토큰으로
    //   붕괴 → SP split 2행째부터 NULL. List 접미로 배열 붕괴 방지(DMF0014 createdByList 선례).
    const arr = entries.map(e => ({ ...e, userIdList: sesUserId }));
    const payload = Object.fromEntries(
      SAVE_KEYS.map(k => [k, arr.map(r => r[k]).join('^')])
    );

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

  // btnInput(값입력) — txtInpuValue 를 선택 D_ 셀(OSP_YN='Y' 행)에 일괄 써넣는다(01_layout §1·§2-c).
  //   gridRef 를 이 컴포넌트가 이미 보유하므로 imperative handle 없이 여기서 선택영역을 읽고 EditTracker
  //   를 경유해 setCellData 로 write 한다(저장 payload 는 EditTracker 단일 출처 그대로 도출).
  //   가드 순서(AS-IS btnInput_Click): #1 조회 전(MSG00135) → #3 SelectDay(무시) → #4 셀 미선택
  //   (MSG00134) → 형식/범위(MSG00050/00203). SelectDay 는 Form 버튼 disabled 로 1차 차단.
  const handleInputValue = useCallback((): void => {
    // #1 조회 전 차단 — persist 된 stale 화면에 값입력 금지.
    if (!hasSearched) {
      void setAlert({ type: 'alert', content: t(MSG.NOT_SEARCHED, '_Please search first.') });
      return;
    }
    // #3 SelectDay — 대상 요일 미지정이면 무시(Form 이 이미 disabled 하나 방어적 재확인).
    if (searchParams.dayWeekCode === DAY_WEEK_SELECT_DAY) return;

    const g = gridRef.current;
    const sel = g?.selectedRanges;
    // #4 셀 미선택 — 선택영역이 없으면 대상 없음.
    if (!g || !sel || sel.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.NO_CELL_SELECTED, '_Please select cell(s).') });
      return;
    }

    // 형식 검증 — 정수만(Form 이 숫자만 수용하나 빈값·형식 재확인, MSG00050).
    const raw = searchParams.inputValue.trim();
    if (raw === '' || !/^\d+$/.test(raw)) {
      void setAlert({ type: 'alert', content: t(MSG.INVALID_FORMAT, '_Invalid input value.') });
      return;
    }
    const num = Number(raw);
    // 범위 검증 — btnInput 은 동적 D_ 일자 셀에만 쓴다(아래 write 루프가 D_ 컬럼으로 한정). 따라서
    //   D_ 셀 범위 0~1440(분, AS-IS SCP0019_WorkingTime.cs:890)을 적용한다. WORKING_TIME_DEFAULT
    //   (0~7)는 셀 직접 편집 경로라 이 값입력 대상이 아니다(MSG00203).
    if (num < WORKING_TIME_RANGE.DAY_MIN || num > WORKING_TIME_RANGE.DAY_MAX) {
      void setAlert({ type: 'alert', content: t(MSG.OUT_OF_RANGE, '_Value out of range.') });
      return;
    }

    // 선택 영역의 편집 가능 셀(D_ 컬럼 × OSP_YN='Y' 행)에만 write. setCellData 는 프로그램적 쓰기라
    //   grid 편집 이벤트(cellEditEnded)를 발화하지 않으므로 EditTracker 가 자동 추적하지 못한다 —
    //   원본값을 먼저 읽어 storeChange 로 명시 기록해야 저장 payload·M 표기에 반영된다(editTracker 규약).
    const tracker = editTrackerRef.current;
    let wrote = 0;
    for (const range of sel) {
      const r = range;
      for (let row = r.topRow; row <= r.bottomRow; row++) {
        const item = (g.rows[row] as { dataItem?: WorkingTimeRow } | undefined)?.dataItem;
        if (!item || String(item.OSP_YN ?? '').toUpperCase() !== 'Y') continue;
        for (let col = r.leftCol; col <= r.rightCol; col++) {
          const binding = g.columns[col]?.binding ?? '';
          if (!/^D_\d{8}$/.test(binding)) continue;
          const original = g.getCellData(row, col, false) as WijmoPrimitive;
          g.setCellData(row, col, num, true);
          tracker?.storeChange(item, binding, original, num);
          wrote += 1;
        }
      }
    }
    if (wrote === 0) {
      void setAlert({ type: 'alert', content: t(MSG.NO_CELL_SELECTED, '_Please select editable cell(s).') });
      return;
    }
    g.invalidate(true);
  }, [hasSearched, searchParams.dayWeekCode, searchParams.inputValue, gridRef, editTrackerRef, setAlert, t]);

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
        onInput={handleInputValue}
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
      />
      <WorkingTimeGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        data={rows}
        dynColumns={dynColumns}
      />
    </>
  );
};
