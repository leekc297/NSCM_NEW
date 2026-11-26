import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { useNavigate } from 'react-router-dom';

import { apiClient } from '@foundation/apis';
import { BUTTON_TYPE } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useMutation } from '@foundation/query-client';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useTabBtnPermissions, useTabLookupQueries } from '@shared/hooks';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { MasterValidationDetailGrid } from './components/MasterValidationDetailGrid';
import { MasterValidationForm } from './components/MasterValidationForm';
import { MasterValidationMasterGrid } from './components/MasterValidationMasterGrid';
import type {
  SHEETS} from './master-validation.constants';
import {
  isDivisionSkipped,
  isPlanGroupLocked,
  MASTER_LOOKUP_TYPE,
  MENU_ID,
  VALIDATION_MAP,
} from './master-validation.constants';
import type { DetailRow, MasterValidationRow } from './master-validation.types';
import styles from './MasterValidation.module.scss';
import { useMasterValidationStore } from './useMasterValidationStore';

// SCP0039 Master Validation — read-only 검증 대시보드(design 00~03).
//   좌 마스터목록(lookup MASTER_VALIDATION) | 우 detail(검증유형별 SP 결과). QUERY 셀 = 데이터 구동
//   dispatch(행 코드 -> PKG_SCP0039 멤버 SP), OPEN 셀 = PROGRAM_ID 네비게이션.
export const MasterValidation = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const findMenuPath = useSessionStore(state => state.findMenuPath);
  const { setAlert } = useMessageStore.getState();

  const masterGridRef = useRef<FlexGrid<MasterValidationRow>>();
  const detailGridRef = useRef<FlexGrid<DetailRow>>();
  const masterFilterRef = useRef<FlexGridFilter>();
  const detailFilterRef = useRef<FlexGridFilter>();

  const searchParams = useMasterValidationStore(state => state.searchParams);
  const masterColumns = useMasterValidationStore(state => state.masterColumns);
  const staticColumns = useMasterValidationStore(state => state.staticColumns);
  const setPlanGroupLocked = useMasterValidationStore(state => state.setPlanGroupLocked);
  const fetchMasterColumns = useMasterValidationStore(state => state.fetchMasterColumns);
  const fetchDetailColumns = useMasterValidationStore(state => state.fetchDetailColumns);
  const openSearchArea = useMasterValidationStore(state => state.openSearchArea);
  const setOpenSearchArea = useMasterValidationStore(state => state.setOpenSearchArea);
  const restoreSearchConditions = useMasterValidationStore(state => state.restoreSearchConditions);

  // 검증유형별 조회결과 캐시 — AS-IS siProjectRoute 는 검증유형마다 독립 sheet(탭)를 두고 각 sheet 가
  //   자기 조회결과를 보존한다(cs:649 ChangeActiveSheet). TO-BE 도 sheet 별로 담아 탭 전환 시 유지한다.
  const [detailRowsBySheet, setDetailRowsBySheet] = useState<Partial<Record<SHEETS, DetailRow[]>>>({});
  const [activeSheet, setActiveSheet] = useState<SHEETS | null>(null);
  const [focusDetail, setFocusDetail] = useState(false);
  // 기존 로직 주석 보존 (2026-10-28) 시작: 마지막 조회 결과 건수 기준 총 N건
  // const [lastQueryCount, setLastQueryCount] = useState(0);
  // 기존 로직 주석 보존 (2026-10-28) 끝

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // 조회 SP 호출을 react-query mutation 으로 감싼다 — raw apiClient.callProc 는 react-query 밖이라
  //   MDIContainer 의 useIsBusy([tabId]) 공통 로딩 스피너가 뜨지 않는다(전체조회 F5·개별 QUERY 모두
  //   "조회 중" 표시 없음, 테스터 지적 2026-11-16). mutationKey 를 [tabId] 로 두어 조회 동안 전역
  //   프로그래스가 표시되게 한다(ShipmentPlanFg 선례). 조회는 멱등이라 재시도는 무해하나 중복 호출을
  //   피하려 retry:0 — 성패 분기(토스트/알럿)는 호출부 callValidationSp 가 res 로 종전과 동일 처리.
  const { mutateAsync: callProcAsync } = useMutation({
    mutationKey: [tabId],
    retry: 0,
    mutationFn: (sheet: SHEETS) =>
      apiClient.callProc<MENU_ID, SHEETS.BOM>(MENU_ID, sheet as SHEETS.BOM, BUTTON_TYPE.SEARCH, {
        divisionId: searchParams.divisionId,
        searchType: '',
        // ALL(빈 배열) -> '' (전체). 다중선택은 콤마 결합.
        planGroupId: searchParams.planGroupIds.length ? searchParams.planGroupIds.join(',') : '',
        itemId: searchParams.itemId,
      }),
  });

  // 마스터 목록 = lookup MASTER_VALIDATION(admin/lookup). AS-IS InsertBaseRow 는 Form_Load 에 목록을
  //   seed 하므로(조회조건 무관) mount 시 로드. 비활성행(PROCEDURE_NAME='-' = Sales Site)은 제외(R11).
  const [lookupData] = useTabLookupQueries({ filters: [{ lookupType: MASTER_LOOKUP_TYPE }] });

  // 마스터 "Validation Info" 컬럼 메타는 admin fetch(하드코딩 금지). mount 1회 + F10 리셋 자가복구.
  //   masterColumns 는 공용 PRESERVED_ON_CONDITION_RESET(useGloablStore)에 없는 화면 로컬 키라
  //   F10(resetSearchCondition→store reset()→initState)이 []로 비운다(staticColumns 만 보존됨).
  //   masterColumns.length 를 dep 에 넣어 비면 재조회 — fetchMasterColumns 의 length 가드로 중복 fetch 방지.
  useEffect(() => {
    void fetchMasterColumns();
  }, [fetchMasterColumns, masterColumns.length]);

  // 개인화 조회조건 복원(F6 저장분, 1회) — 저장분 있으면 적용, 없으면 기본값 유지(형제 shipment-plan-fix 파리티,
  //   basic-check #3). 새로고침/재진입 시 createPersistedStoreWithTab 이 새 store(가드 false) → 재복원.
  useEffect(() => {
    void restoreSearchConditions();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  const masterRows = useMemo(
    () =>
      ((lookupData ?? []) as unknown as MasterValidationRow[])
        .filter(row => (row.PROCEDURE_NAME ?? '').trim() !== '' && row.PROCEDURE_NAME !== '-')
        .map(row => ({ ...row, COUNT: '' })),
    [lookupData]
  );

  // 디테일 탭 목록 — 마스터 행(활성 검증유형) 그대로. label=SHEET_NAME(표시명, 그리드 "Validation Type"과
  //   동일 표기), sheet=VALIDATION_MAP dispatch. AS-IS siProjectRoute 12 sheet 탭(cs:999~1001)과 등가.
  const tabs = useMemo(
    () =>
      masterRows
        .map(row => {
          const spec = VALIDATION_MAP[row.VALIDATION_TYPE];
          return spec
            ? { sheet: spec.sheet, adminSheetName: spec.adminSheetName, label: row.SHEET_NAME }
            : null;
        })
        .filter((tab): tab is { sheet: SHEETS; adminSheetName: string; label: string } => tab !== null),
    [masterRows]
  );

  // 초기 활성 탭 = 첫 검증유형(AS-IS 진입 시 첫 sheet). 탭 로드 후 1회 세팅 + 컬럼 메타 프리페치.
  useEffect(() => {
    if (activeSheet || tabs.length === 0) return;
    setActiveSheet(tabs[0].sheet);
    void fetchDetailColumns(tabs[0].sheet, tabs[0].adminSheetName);
  }, [tabs, activeSheet, fetchDetailColumns]);

  const activeTabIndex = Math.max(
    tabs.findIndex(tab => tab.sheet === activeSheet),
    0
  );

  // 행 COUNT 를 그리드 dataItem 에 직접 갱신 + refresh — itemsSource 재생성 없이(선택/스크롤 보존).
  const setRowCount = useCallback((code: string, count: string) => {
    const row = masterRows.find(item => item.VALIDATION_TYPE === code);
    if (row) row.COUNT = count;
    masterGridRef.current?.collectionView?.refresh();
  }, [masterRows]);

  // Division/PlanGroup 변경 = ClearSheet(AS-IS ClbDivision_SelectedIndexChanged cs:1268 -> ClearSheet
  //   cs:1219). detail 행·activeSheet·전 행 COUNT(cs:1224) 초기화 — stale COUNT·detail 잔존 방지
  //   (design 01 §3, 03 §3 #9, GAP-03).
  const clearResults = useCallback(() => {
    masterRows.forEach(row => {
      row.COUNT = '';
    });
    masterGridRef.current?.collectionView?.refresh();
    // 조회결과만 비운다 — 탭(sheet) 구성과 활성 탭은 유지(AS-IS ClearSheet 는 데이터만 clear, cs:1219).
    setDetailRowsBySheet({});
  }, [masterRows]);

  useEffect(() => {
    clearResults();
  }, [searchParams.divisionId, searchParams.planGroupIds, clearResults]);

  // 검증유형 SP 호출(공통) — 성공 시 결과 행 반환, 실패 시 null.
  const callValidationSp = useCallback(
    async (row: MasterValidationRow): Promise<DetailRow[] | null> => {
      const spec = VALIDATION_MAP[row.VALIDATION_TYPE];
      if (!spec) return null;
      try {
        // callProcAsync(mutationKey=[tabId]) 경유 — 전역 로딩 스피너 트리거(payload 는 mutationFn 이 구성).
        const res = await callProcAsync(spec.sheet);
        if (res.code !== '0') {
          void setAlert({ type: 'alert', content: res.message ?? t('MSG01052', '_An error has occurred when inquiring.') });
          return null;
        }
        return (res.result?.o_rc1 ?? []) as DetailRow[];
      } catch {
        void setAlert({ type: 'alert', content: t('MSG01052', '_An error has occurred when inquiring.') });
        return null;
      }
    },
    [callProcAsync, setAlert, t]
  );

  // QUERY 셀 클릭 — 해당 행 검증유형 SP dispatch -> COUNT 갱신 + detail 바인딩(design 03 §3 R13).
  const handleQuery = useCallback(
    async (row: MasterValidationRow) => {
      const spec = VALIDATION_MAP[row.VALIDATION_TYPE];
      if (!spec) return;
      await fetchDetailColumns(spec.sheet, spec.adminSheetName);
      const rows = await callValidationSp(row);
      if (rows === null) return;
      setActiveSheet(spec.sheet);
      setDetailRowsBySheet(prev => ({ ...prev, [spec.sheet]: rows }));
      setRowCount(row.VALIDATION_TYPE, String(rows.length));
      // setLastQueryCount(rows.length);
    },
    [callValidationSp, fetchDetailColumns, setRowCount]
  );

  // OPEN 셀 클릭 — PROGRAM_ID(SEGMENT4) 네비게이션(design 03 §3 white-list R14).
  //   http 시작 = 외부 URL / 그 외 = MDI 화면(권한 있는 메뉴만).
  const handleOpen = useCallback(
    (row: MasterValidationRow) => {
      const programId = (row.PROGRAM_ID ?? '').trim();
      if (!programId) return;
      if (/^https?:\/\//i.test(programId)) {
        window.open(programId, '_blank', 'noopener,noreferrer');
        return;
      }
      if (!findMenuPath(programId)) return;
      void navigate(`/view/${encodeURIComponent(programId)}`);
    },
    [findMenuPath, navigate]
  );

  // 마스터 행 선택(QUERY/OPEN 외 셀) — CONSTRAINTS01 파싱으로 PlanGroup 조건 잠금(R18) +
  //   detail sheet 프리뷰 전환(조회 없이 뷰만, R15).
  const handleRowSelect = useCallback(
    (row: MasterValidationRow) => {
      setPlanGroupLocked(isPlanGroupLocked(row.CONSTRAINTS01));
      const spec = VALIDATION_MAP[row.VALIDATION_TYPE];
      if (!spec) return;
      void fetchDetailColumns(spec.sheet, spec.adminSheetName);
      // 셀 클릭 = 디테일 탭 프리뷰 전환(조회 없이, AS-IS cs:1000~1001 ChangeActiveSheet). 기존 조회결과는 보존.
      setActiveSheet(spec.sheet);
    },
    [fetchDetailColumns, setPlanGroupLocked]
  );

  // 디테일 탭 전환 — 해당 sheet 로 활성 전환 + 컬럼 메타 확보(AS-IS sheet 탭 클릭 등가, 조회는 QUERY 로만).
  const handleTabChange = useCallback(
    (index: number) => {
      const tab = tabs[index];
      if (!tab) return;
      setActiveSheet(tab.sheet);
      void fetchDetailColumns(tab.sheet, tab.adminSheetName);
    },
    [tabs, fetchDetailColumns]
  );

  // 전체조회(F5/FindDataAll) — 행마다 SP 호출해 COUNT + 해당 sheet 데이터를 채운다(AS-IS FindDataAll
  //   cs:534~558 → FindData cs:646~651: ChangeActiveSheet + Query 로 각 sheet 에 결과 바인딩). COUNT 만
  //   채우면 탭 전환 시 데이터가 비어 보인다. Div 종속행(Div:82/40)은 현재 division 과 다르면 skip(R22).
  const handleSearch = useCallback(() => {
    void Promise.allSettled(
      masterRows.map(async row => {
        const spec = VALIDATION_MAP[row.VALIDATION_TYPE];
        if (!spec) return;
        if (isDivisionSkipped(row.CONSTRAINTS01, searchParams.divisionId)) {
          setRowCount(row.VALIDATION_TYPE, '');
          setDetailRowsBySheet(prev => ({ ...prev, [spec.sheet]: [] }));
          return;
        }
        await fetchDetailColumns(spec.sheet, spec.adminSheetName);
        const rows = await callValidationSp(row);
        if (rows !== null) {
          setRowCount(row.VALIDATION_TYPE, String(rows.length));
          setDetailRowsBySheet(prev => ({ ...prev, [spec.sheet]: rows }));
          // 병렬 호출이라 가장 늦게 끝난 조회 건수가 남는다(AS-IS 도 마지막 완료분).
          // setLastQueryCount(rows.length);
        }
      })
    );
  }, [callValidationSp, fetchDetailColumns, masterRows, searchParams.divisionId, setRowCount]);

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    // read-only 뷰어 — AS-IS Insert/Edit/Delete/Save override 는 본문 공백 NO-OP(design 00 §4d)라
    //   당초 노출+무동작으로 배선했으나, 사용자 지시(2026-11-16)로 버튼 자체를 제거한다. false =
    //   SubTitle 에서 해당 버튼 미렌더(buttonActions.<key>===false 분기) + 공용 addRow/removeRow 도
    //   재활성되지 않는다(명시적 비활성이라 키 생략과 달리 안전).
    insert: false,
    save: false,
    delete: false,
    manual: false,
    upload: false,
  };

  const focusedGrid = focusDetail ? detailGridRef : masterGridRef;
  const focusedFilter = focusDetail ? detailFilterRef : masterFilterRef;
  // 기존 로직 주석 보존 (2026-10-28) 시작: 포커스 그리드 행 수 기준 총 N건
  // const focusedCount = focusDetail
  //   ? (activeSheet ? (detailRowsBySheet[activeSheet]?.length ?? 0) : 0)
  //   : masterRows.length;
  // 기존 로직 주석 보존 (2026-10-28) 끝
  // 기존 로직 주석 보존 (2026-10-28) 시작: 열린 디테일 탭 건수 기준 총 N건
  // const activeTabCount = activeSheet ? (detailRowsBySheet[activeSheet]?.length ?? 0) : 0;
  // 기존 로직 주석 보존 (2026-10-28) 끝
  // 총 N건 = 좌측 COUNT 합계(검증유형별 결과 건수 합). 그리드 필터와 무관하게 고정한다.
  const totalValidationCount = Object.values(detailRowsBySheet).reduce(
    (sum, rows) => sum + (rows?.length ?? 0),
    0
  );
  // 빈 ref 를 건수 기준 그리드로 넘겨 SubTitle 의 필터 건수 대체를 끈다.
  const noCountGridRef = useRef<FlexGrid>();

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && <MasterValidationForm onSearch={handleSearch} />}
      <SubTitle
        menuId={MENU_ID}
        grid={focusedGrid}
        gridFilter={focusedFilter}
        countGrid={noCountGridRef}
        dataCount={totalValidationCount}
        excelFileName='MasterValidation'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      {/* 좌 마스터목록 | 우 detail 2-pane. AS-IS 우측 4분할·빈 3그리드는 dead layout 미재현(design 01 §1.1).
          마스터 패널 기본폭은 마스터 그리드 가시 컬럼(No~45 + Validation Type 150 + Count 60 + QUERY 70 +
          OPEN 70 = 약 395px, SCM_MST_SHEET_COLUMNS 실측)에 맞춰 px 고정 — 빈 여백 없이 detail 이 나머지를
          다 써 12개 탭이 잘리지 않는다. react-resizable-panels v4 는 "NNpx" 지원(ShipmentPlan 선례). */}
      <PanelGroup className={styles.tableWrapper} orientation='horizontal'>
        <Panel defaultSize='420px' minSize='260px'>
          <MasterValidationMasterGrid
            gridRef={masterGridRef}
            gridFilterRef={masterFilterRef}
            data={masterRows}
            staticColumns={masterColumns}
            onQuery={handleQuery}
            onOpen={handleOpen}
            onRowSelect={handleRowSelect}
            gotFocus={() => setFocusDetail(false)}
          />
        </Panel>
        <PanelSeparator className={styles.splitBar} />
        <Panel minSize={20}>
          {/* 디테일 = 검증유형별 탭(AS-IS siProjectRoute 12 sheet). 비활성 탭은 언마운트(비-persist)라
              활성 탭 그리드 1개만 detailGridRef 에 잡힌다 — SubTitle 엑셀/필터 대상 정합. */}
          <div className={styles.detailTabs}>
            <TabWrapper activeTabIndex={activeTabIndex} setActiveTabIndex={handleTabChange}>
              {tabs.map(tab => (
                <TabItem key={tab.sheet} label={tab.label}>
                  <MasterValidationDetailGrid
                    gridRef={detailGridRef}
                    gridFilterRef={detailFilterRef}
                    data={detailRowsBySheet[tab.sheet] ?? []}
                    staticColumns={staticColumns[tab.sheet] ?? []}
                    gotFocus={() => setFocusDetail(true)}
                  />
                </TabItem>
              ))}
            </TabWrapper>
          </div>
        </Panel>
      </PanelGroup>
    </>
  );
};
