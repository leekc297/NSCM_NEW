import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { IcExchangeRate, IcGridColumnSetup, IcMeasureSelect } from '@foundation/assets';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import {
  INSERT_MEASURE_COMBO_ID,
  INSERT_ROW_DEFAULTS,
  MENU_ID,
  MSG,
  SHEETS,
} from './business-plan.constants';
import type { BusinessPlanRow, SpreadTitleRow } from './business-plan.types';
import styles from './BusinessPlan.module.scss';
import { BusinessPlanForm } from './components/BusinessPlanForm';
import { BusinessPlanGrid } from './components/BusinessPlanGrid';
import { type BusinessPlanModalKey, BusinessPlanModals } from './components/BusinessPlanModals';
import { useBusinessPlanStore, thisWeekMonday } from './useBusinessPlanStore';
import { callSaveBusinessPlan, callSetPrice } from './utils/business-plan.api';
import { buildCutoff, buildValidWindow, dynKindOf } from './utils/business-plan.editLock';
import { measureBlockOf } from './utils/business-plan.gridCombos';
import { buildSavePayload, buildUnfoldRows } from './utils/business-plan.save';
import { useBusinessPlanValidation } from './utils/business-plan.validate';

// AS-IS DMF0042_1_BizPlan (Demand > Demand Plan > Business Plan / 사업계획 — 3,477줄 정본 1:1).
//   Division 3종(40/81*/82) 단일 화면 — 조회 = DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA(16 IN + 커서 2:
//   data/calendar[40 유효구간]) / 저장 = PKG_DMF0042.P_DMF0042_SAVE_DM_PLN_BP_FCST(19키 '^' bulk —
//   CAR/CELL/ENERGY·금액 파생은 SP 내장, FE 재구현 금지 — F-2 ①) / 동적 3단(연/분기/월) = GET_SPREAD_TITLE.
//   구조 골격 = sales-plan(DMF0021) — 2026-07-15 플랜 §E 확정.
//   SubTitle 공통버튼: search/insert/delete/save + excel/filter/sort/condition/reset(자동, hook #64) +
//   커스텀 6종(Set Price / Exchange Rate / Ver. Cutoff / Replace + Column Setting / Measure Select —
//   전부 노출 F-2 ②). EDIT(F2)는 상시편집 + editLock 으로 대체.
export const BusinessPlan = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGridType<BusinessPlanRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);
  const editTrackerRef = useRef<EditTracker>(undefined);

  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const queryClient = useQueryClient();

  const sc = useBusinessPlanStore(s => s.searchCondition);
  const setSearchCondition = useBusinessPlanStore(s => s.setSearchCondition);
  const filters = useBusinessPlanStore(s => s.filters);
  const setFilter = useBusinessPlanStore(s => s.setFilter);
  const clearFilters = useBusinessPlanStore(s => s.clearFilters);
  const openSearchArea = useBusinessPlanStore(s => s.openSearchArea);
  const setOpenSearchArea = useBusinessPlanStore(s => s.setOpenSearchArea);
  const staticColumns = useBusinessPlanStore(s => s.staticColumns);
  const fetchStaticColumns = useBusinessPlanStore(s => s.fetchStaticColumns);
  const fetchStaticMeasures = useBusinessPlanStore(s => s.fetchStaticMeasures);
  const setCutoffWindow = useBusinessPlanStore(s => s.setCutoffWindow);
  const cutoffWindow = useBusinessPlanStore(s => s.cutoffWindow);
  const dayRangeApplied = useBusinessPlanStore(s => s.dayRangeApplied);
  const applyDayRange = useBusinessPlanStore(s => s.applyDayRange);

  // ui-dynamic-property-management — Menu Button 권한 동적 fetch
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // ⭐ 명시 조회 게이트 (persist 안 됨 — 컴포넌트 로컬). Search 클릭 후에만 enable (DMF0003 계보).
  const [hasSearched, setHasSearched] = useState(false);

  // ⭐ 기본 Period — PR_GET_DAY_RANGE o_rc2 (당월 1일~+7개월 말일. AS-IS GetDayRange p_month=7 L308)
  const dayRangeFilters = useMemo(() => ({ createdBy: '', month: '7' }), []);
  const { data: dayRangeData } = useTabProcQuery<MENU_ID, SHEETS.DAY_RANGE>({
    menuId: MENU_ID,
    sheetName: SHEETS.DAY_RANGE,
    tabId,
    filters: dayRangeFilters,
    enabled: !dayRangeApplied,
  });
  useEffect(() => {
    const range = (dayRangeData as { o_rc2?: { DAY_RANGE?: string }[] })?.o_rc2?.[0]?.DAY_RANGE;
    if (range) applyDayRange(range);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [dayRangeData]);

  // 메인 그리드 SP — DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA (16 IN + 커서 2). wide format.
  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: hasSearched && !!filters[SHEETS.MAIN],
  });

  // 동적 3단(연/분기/월) 헤더 SP — DMF0042_GET_SPREAD_TITLE.
  const { data: spreadTitleData } = useTabProcQuery<MENU_ID, SHEETS.SPREAD_TITLE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SPREAD_TITLE,
    tabId,
    filters: filters[SHEETS.SPREAD_TITLE],
    enabled: hasSearched && !!filters[SHEETS.SPREAD_TITLE],
  });
  const spreadTitleRows = (spreadTitleData as { data?: SpreadTitleRow[] } | undefined)?.data ?? [];

  // ⭐ Insert Measure 블록 원천 — CMBO 'DMF0042_BP_Measure' (AS-IS dtMeasure 1:1. division 토큰 클라 필터)
  const [measureComboRows] = useTabComboQueries({ filters: [INSERT_MEASURE_COMBO_ID] });

  // ⭐ P_USERINFO 권한 그룹 — 세션 그룹 부재(유령 필드) → CMBO 'BizPlanUserAuthGroup'(P5) 1행 주입.
  const [authGroupCombo] = useTabComboQueries({ filters: ['BizPlanUserAuthGroup'] });
  const setAuthGroup = useBusinessPlanStore(s => s.setAuthGroup);
  const authGroup = useBusinessPlanStore(s => s.authGroup);
  useEffect(() => {
    const first = (authGroupCombo ?? [])[0] as { CODE?: string } | undefined;
    if (first?.CODE) setAuthGroup(String(first.CODE));
  }, [authGroupCombo, setAuthGroup]);
  // ⭐ race 방어 (DMF0021 2026-07-15 사고 계보): 콤보 도착 전 조회가 이미 나갔으면 그룹 확정 시
  //   filters 재생성(setFilter — 새 queryKey)으로 자동 재조회.
  useEffect(() => {
    if (authGroup && filters[SHEETS.MAIN]) setFilter();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [authGroup]);

  // 신규 행 추적 (CRUD_TYPE='I' — Measure 블록 단위)
  const [insertedRows, setInsertedRows] = useState<BusinessPlanRow[]>([]);

  // ⭐ MAIN 커서 2 (40 편집 유효구간 — 81/82 NULL 방어) 를 store 에 보관.
  type Cal = NonNullable<typeof cutoffWindow>;
  const mainData = data as { data?: BusinessPlanRow[]; calendar?: Cal[] | Cal } | undefined;
  useEffect(() => {
    if (!mainData) return;
    const pick = <T,>(v: T[] | T | undefined): T | null =>
      Array.isArray(v) ? (v[0] ?? null) : (v ?? null);
    setCutoffWindow(pick(mainData.calendar));
    // 재조회 = pending insert reset + EditTracker clear (hook #97)
    setInsertedRows([]);
    editTrackerRef.current?.clearChanges();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [mainData]);

  // ⭐ mount 시 1회 admin 메타 fetch + persist 된 이전 filters 무효화.
  useEffect(() => {
    clearFilters();
    void fetchStaticColumns();
    void fetchStaticMeasures();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // ⭐ editLock cutoff — 금주 월요일 (조회 p_now_yyyymmdd 동일 원천) + 40 유효구간(커서 2)
  const cutoff = useMemo(() => buildCutoff(thisWeekMonday()), []);
  const validWindow = useMemo(() => buildValidWindow(cutoffWindow ?? null), [cutoffWindow]);

  // 셀 모달 state (PROJECT 81·82 / ITEM 전 division — AS-IS spdMain_CellDoubleClick L1640~1797)
  const [openProject, setOpenProject] = useState(false);
  const [openItem, setOpenItem] = useState(false);
  const [popupGroupId, setPopupGroupId] = useState<string | null>(null);

  // 모달 open state — Column/Measure/Exchange/Cutoff/Replace
  const [openColumnSetting, setOpenColumnSetting] = useState(false);
  const [openMeasureSelect, setOpenMeasureSelect] = useState(false);
  const [openExchangeRate, setOpenExchangeRate] = useState(false);
  const [openCutoff, setOpenCutoff] = useState(false);
  const [openReplace, setOpenReplace] = useState(false);
  const [replaceRange, setReplaceRange] = useState<{ from: string; to: string }>({
    from: '',
    to: '',
  });

  // ----- validation (조회 V-S1~S3 / Bucket V-E3 / 저장 V-V1 / pending 차단) -----
  const validation = useBusinessPlanValidation();

  // 변경분 존재 여부 — Bucket 변경(MSG00227)·커스텀 버튼 pending 차단(MSG00680) 입력
  const hasPendingChanges = () =>
    insertedRows.length > 0 || (editTrackerRef.current?.getOriginalValues()?.size ?? 0) > 0;

  // F5 Search — AS-IS FindData(L684~799) 1:1 검증(V-S1~S3) 후 조회.
  //   ⚠ refetch?.() 직접 호출 금지 — stale closure NULL payload 사고 (memory feedback_search_refetch_stale_closure).
  const handleSearch = () => {
    const vr = validation.validateFind(sc);
    if (!vr.ok) {
      // V-S3 — 6년 초과 시 종료일 = 시작일+6년 보정 (AS-IS L711 Value2 보정 후 차단)
      if (vr.adjustedEnd) setSearchCondition({ endYyyymmdd: vr.adjustedEnd });
      return;
    }
    void setToast({ message: t('LBL00665', '_Loading...'), type: 'default', duration: 2000 });
    setInsertedRows([]);
    setHasSearched(true);
    setFilter();
    void fetchStaticColumns();
    void fetchStaticMeasures();
  };

  // ⭐ Division 변경 = Grid 초기화(비움) + CRUD reset 의무 (memory feedback_division_change_grid_reset)
  const handleDivisionChange = () => {
    setInsertedRows([]);
    editTrackerRef.current?.clearChanges();
    setHasSearched(false);
    clearFilters();
    void fetchStaticColumns();
    void fetchStaticMeasures();
  };

  // F8 Insert — AS-IS InsertRow(L1150~1417) 1:1: Measure 블록(division별 measure 전 행) 삽입.
  //   콤보 미적재(0건) = MSG00113 차단 (메타 주도 — 하드코딩 fallback 금지).
  const handleInsert = () => {
    const measures = measureBlockOf(
      (measureComboRows ?? []) as unknown as Record<string, unknown>[],
      sc.divisionId
    );
    if (measures.length === 0) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_COLUMN, '_필수 입력 컬럼이 없습니다.'),
      });
      return;
    }
    const gid = `I_${Date.now()}`;
    const block: BusinessPlanRow[] = measures.map(measure => ({
      CRUD_TYPE: 'I',
      INSERT_GROUP_ID: gid,
      DIVISION_ID: sc.divisionId,
      MEASURE: measure,
      ...INSERT_ROW_DEFAULTS,
    }));
    setInsertedRows(prev => [...block, ...prev]);
  };

  // F9 Delete — AS-IS DeleteButton(L525~537) 1:1 — Action='I' Measure 블록 전체 삭제.
  //   DB 조회행은 무동작(silent).
  const handleDelete = () => {
    const g = gridRef.current;
    if (!g) return;
    const sel = g.selectedItems[0] as BusinessPlanRow | undefined;
    if (!sel || sel.CRUD_TYPE !== 'I') return; // silent (AS-IS L527)
    const gid = sel.INSERT_GROUP_ID;
    if (gid) setInsertedRows(prev => prev.filter(r => r.INSERT_GROUP_ID !== gid));
    else setInsertedRows(prev => prev.filter(r => r !== sel));
  };

  // F7 Save — AS-IS SaveData(L801~1148) 1:1. 검증(V-V1) → 19키 '^' bulk 조립(중복 MSG00043) →
  //   PKG SAVE 직접 호출 → 결과 passthrough → 성공 MSG00002 + 재조회(스크롤 복원).
  const handleSave = async () => {
    const savedScroll = gridRef.current?.scrollPosition ?? null;
    const changedMap =
      (editTrackerRef.current?.getOriginalValues() as
        | Map<BusinessPlanRow, Record<string, unknown>>
        | undefined) ?? new Map<BusinessPlanRow, Record<string, unknown>>();
    const editedRows = [...changedMap.keys()].filter(r => r.CRUD_TYPE !== 'I');

    // (0) 변경 0건 + 필수값 division 분기 (MSG00004 / MSG00429 {0})
    const vr = validation.validateSaveRows([...insertedRows, ...editedRows], sc.divisionId);
    if (!vr.ok) return;

    // (1) (행 × M_ 기간셀) unfold — 빈값→'0'→'D', 중복 키 검증(MSG00043)
    const build = buildUnfoldRows({
      insertedRows,
      editedChanges: changedMap,
      divisionId: sc.divisionId,
      msg: { duplicateKey: MSG.DUPLICATE_KEY },
    });
    if (build.error) {
      void setAlert({
        type: 'alert',
        content: t(build.error.msgId, `_${build.error.msgId}`).replace(
          '{0}',
          build.error.param ?? ''
        ),
      });
      return;
    }
    const payload = buildSavePayload(build.rows);
    if (!payload) {
      // 저장 대상 0건 (AS-IS L1087 MSG00275 → MSG00676)
      void setAlert({
        type: 'alert',
        content: t(MSG.NO_SAVE_TARGET, '_저장할 대상 데이터가 없습니다.'),
      });
      return;
    }

    void setToast({ message: t('LBL00665', '_Loading...'), type: 'default', duration: 3000 });
    try {
      const res = await callSaveBusinessPlan(payload);
      if (!res.ok) {
        // SP 오류문 passthrough (AS-IS L1138 sRet MessageBox 1:1)
        void setAlert({
          type: 'alert',
          content: res.message || t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.'),
        });
        return;
      }
      void setToast({ message: t(MSG.SAVED, '_성공적으로 저장되었습니다.'), type: 'success' });
      setInsertedRows([]);
      editTrackerRef.current?.clearChanges();
      void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
      await (refetch?.() ?? Promise.resolve());
      if (savedScroll) {
        window.requestAnimationFrame(() => {
          const g = gridRef.current;
          if (g) g.scrollPosition = savedScroll;
        });
      }
    } catch (e) {
      const msg =
        e instanceof Error ? e.message : t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.');
      void setAlert({ type: 'alert', content: msg });
    }
  };

  // ⭐ Set Price — 가격→금액 환산 (AS-IS btnSetPrice: MSG00678 confirm → SP → 재조회)
  const handleSetPrice = async () => {
    // [개선] pending 차단 (2026-07-21 사용자 승인 — AS-IS 는 가드 전무라 미저장 변경이 재조회로 소실.
    //   Exchange/Cutoff/Replace 와 MSG00680 통일. 파리티 이탈 의도 명시.)
    if (!validation.validateNoPending(hasPendingChanges()).ok) return;
    const confirmed = await setAlert({
      type: 'confirm',
      content: t(MSG.SET_PRICE_CONFIRM, '_변경된 환율을 적용하시겠습니까?'),
    });
    if (!confirmed) return;
    void setToast({ message: t('LBL00665', '_Loading...'), type: 'default', duration: 3000 });
    const res = await callSetPrice(sc.divisionId);
    // 반환 메시지 passthrough (AS-IS L3133 GMessageBox 1:1)
    if (res.message) {
      void setAlert({ type: 'alert', content: res.message });
    }
    if (res.ok) await (refetch?.() ?? Promise.resolve());
  };

  // ⭐ Exchange Rate — pending 변경 시 차단(AS-IS L2989 MSG00142 → MSG00680) → 모달 → 닫으면 재조회
  const handleExchangeRate = () => {
    if (!validation.validateNoPending(hasPendingChanges()).ok) return;
    setOpenExchangeRate(true);
  };

  // ⭐ Ver. Cutoff — ADMIN·DM ADMIN 게이트(P4 — hasButton) + pending 차단 (AS-IS L2840~2866)
  const handleCutoff = () => {
    if (!validation.validateNoPending(hasPendingChanges()).ok) return;
    setOpenCutoff(true);
  };

  // ⭐ Replace — 게이트 + pending 차단 + 조회 0행 차단 + 선택 M_ 범위 → from/to (AS-IS L3382~3474)
  const handleReplace = () => {
    if (!validation.validateNoPending(hasPendingChanges()).ok) return;
    const spRowsNow = mainData?.data ?? [];
    if (spRowsNow.length === 0) {
      // AS-IS L3408 인라인 리터럴 1:1
      void setAlert({ type: 'alert', content: '데이터 조회 후 다시 시도해 주시기 바랍니다.' });
      return;
    }
    // 선택 셀 범위의 M_ 태그 → from/to yyyymm (미선택/비 M_ = 조회기간 전체 — AS-IS L3422~3450)
    const g = gridRef.current;
    let from = sc.startYyyymmdd.slice(0, 6);
    let to = sc.endYyyymmdd.slice(0, 6);
    if (g) {
      const selection = g.selection;
      const tags: string[] = [];
      for (
        let c = Math.min(selection.col, selection.col2);
        c <= Math.max(selection.col, selection.col2);
        c++
      ) {
        const b = g.columns[c]?.binding ?? '';
        if (dynKindOf(b) === 'M') tags.push(b.slice(2));
      }
      if (tags.length > 0) {
        tags.sort();
        from = tags[0];
        to = tags[tags.length - 1];
      }
    }
    setReplaceRange({ from, to });
    setOpenReplace(true);
  };

  // SubTitle 공통버튼 — 미명시(sort/filter/condition/resetCondition/excel)는 DefaultButtonActions 자동.
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    delete: hasButton('DELETE') ? handleDelete : false,
    save: hasButton('SAVE') ? () => void handleSave() : false,
    manual: false,
    upload: false,
  };

  // 커스텀 버튼 6종 — Set Price/Ver. Cutoff/Ver. Replace(F-2 ② 전부 노출 — 권한은 P4 hasButton)
  //   + Exchange Rate/Column Setting/Measure Select (icon-only). 라벨 = 기존 LBL 재사용, 부재 시 영문
  //   리터럴 (신규 LBL 채번 금지 — DMF0021 확정 승계).
  //   ⭐ 배치 규약 (hook #120, 사용자 명시 2026-07-30): 텍스트 버튼 먼저, 그 뒤 아이콘 버튼을
  //      왼쪽부터 **환율 → Grid Column Set → Measure** 순서로 고정. 환율은 항상 아이콘 형태.
  const customButtons = [
    ...(hasButton('SET_PRICE')
      ? [
          {
            label: 'Set Price',
            title: 'Set Price',
            action: () => void handleSetPrice(),
            buttonLabel: 'Set Price',
          },
        ]
      : []),
    ...(hasButton('CUTOFF')
      ? [
          {
            label: 'Ver. Cutoff',
            title: 'Ver. Cutoff',
            action: handleCutoff,
            buttonLabel: 'Ver. Cutoff',
          },
        ]
      : []),
    ...(hasButton('REPLACE')
      ? [
          {
            label: 'Ver. Replace',
            title: 'Ver. Replace',
            action: handleReplace,
            buttonLabel: 'Ver. Replace',
          },
        ]
      : []),
    ...(hasButton('EXCHANGE_RATE')
      ? [
          {
            label: t('LBL00661', 'Exchange Rate'),
            title: t('LBL00661', 'Exchange Rate'),
            action: handleExchangeRate,
            iconComponent: <IcExchangeRate />,
            buttonLabel: '',
          },
        ]
      : []),
    ...(hasButton('COLUMN_SETUP')
      ? [
          {
            label: t('LBL00605', 'Column Setting'),
            title: t('LBL00605', 'Column Setting'),
            action: () => setOpenColumnSetting(true),
            iconComponent: <IcGridColumnSetup />,
            buttonLabel: '',
          },
        ]
      : []),
    ...(hasButton('MEASURE_SELECT')
      ? [
          {
            label: t('LBL00712', '_Measure'),
            title: t('LBL00712', '_Measure'),
            action: () => setOpenMeasureSelect(true),
            iconComponent: <IcMeasureSelect />,
            buttonLabel: '',
          },
        ]
      : []),
  ];

  const spRows = useMemo<BusinessPlanRow[]>(() => mainData?.data ?? [], [mainData]);
  // ⭐ measure 행 필터는 서버(TITLESET 'M') 단일 출처 — 모달 OK 의 saveTitleSet('M') + invalidate 재조회.
  const rows: BusinessPlanRow[] = useMemo(
    () => [...insertedRows, ...spRows],
    [insertedRows, spRows]
  );

  return (
    <div className={styles.container}>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />

      {openSearchArea && (
        <BusinessPlanForm
          onSearch={handleSearch}
          onDivisionChange={handleDivisionChange}
          hasPendingChanges={hasPendingChanges}
          validation={validation}
        />
      )}

      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='BusinessPlan'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={customButtons}
      />

      <BusinessPlanGrid
        rows={rows}
        gridRef={gridRef as never}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        divisionId={sc.divisionId}
        bucketType={sc.bucketType}
        sumYn={sc.sumYn}
        staticColumns={staticColumns}
        spreadTitle={spreadTitleRows}
        cutoff={cutoff}
        validWindow={validWindow}
        onPopupCellDblClick={(modalKey, row) => {
          setPopupGroupId(row.INSERT_GROUP_ID ?? null);
          if (modalKey === 'ITEM') setOpenItem(true);
          else setOpenProject(true);
        }}
      />

      {/* 모달 7종 — 셀 PROJECT/ITEM + Column/Measure + Exchange/Cutoff/Replace (components 분리 의무) */}
      <BusinessPlanModals
        divisionId={sc.divisionId}
        period={{ start: sc.startYyyymmdd, end: sc.endYyyymmdd }}
        replaceRange={replaceRange}
        openProject={openProject}
        openItem={openItem}
        openColumnSetting={openColumnSetting}
        openMeasureSelect={openMeasureSelect}
        openExchangeRate={openExchangeRate}
        openCutoff={openCutoff}
        openReplace={openReplace}
        onClose={(key: BusinessPlanModalKey) => {
          const closers: Record<BusinessPlanModalKey, (v: boolean) => void> = {
            PROJECT: setOpenProject,
            ITEM: setOpenItem,
            COLUMN: setOpenColumnSetting,
            MEASURE: setOpenMeasureSelect,
            EXCHANGE: setOpenExchangeRate,
            CUTOFF: setOpenCutoff,
            REPLACE: setOpenReplace,
          };
          closers[key](false);
        }}
        onRefetch={() => void (refetch?.() ?? Promise.resolve())}
        applyToInsertBlock={patch => {
          // 셀 모달 반영 — 같은 Measure 블록(INSERT_GROUP_ID) 전 행에 키 컬럼 patch (AS-IS 블록 공유 키)
          if (!popupGroupId) return;
          setInsertedRows(prev =>
            prev.map(r => (r.INSERT_GROUP_ID === popupGroupId ? { ...r, ...patch } : r))
          );
          setPopupGroupId(null);
        }}
      />
    </div>
  );
};
