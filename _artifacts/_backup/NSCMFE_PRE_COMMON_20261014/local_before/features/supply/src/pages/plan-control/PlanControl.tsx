import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useTabBtnPermissions, useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { EngineRunGrid } from './components/EngineRunGrid';
import { PlanControlForm } from './components/PlanControlForm';
import { PlanControlGrid } from './components/PlanControlGrid';
import { usePlanControlCellActions } from './hooks/usePlanControlCellActions';
import { usePlanControlPolling } from './hooks/usePlanControlPolling';
import {
  COMBO,
  GM_DIVISION_LOOKUP_TYPE,
  LBL,
  MENU_ID,
  MSG,
  OWNER_BYPASS_GROUP_IDS,
  RESPONSE_SET,
  SHEETS,
} from './plan-control.constants';
import type { EngineRunRow, PlanControlRow } from './plan-control.types';
import styles from './PlanControl.module.scss';
import { usePlanControlStore } from './usePlanControlStore';
import { buildDivisionOptions, resolvePlanStartYyyymmdd, str } from './utils/planControl.activity';

// SCP0123 Plan Control — Plan Group·Plan Date 별 Activity 실행 콘솔(design 00~03).
//   상 spdMain(Activity 목록, CONFIRM 버튼셀로 실행) | 하 Status 탭(Engine Run 진행, 2초 폴링).
//   툴바에서 실동작하는 버튼은 Search 뿐이고 저장은 그리드 CONFIRM 셀이 수행한다(01_layout §2.3).
export const PlanControl = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const mainGridRef = useRef<FlexGrid<PlanControlRow>>();
  const subGridRef = useRef<FlexGrid<EngineRunRow>>();
  const mainFilterRef = useRef<FlexGridFilter>();
  const subFilterRef = useRef<FlexGridFilter>();

  const searchParams = usePlanControlStore(state => state.searchParams);
  const filters = usePlanControlStore(state => state.filters);
  const staticColumns = usePlanControlStore(state => state.staticColumns);
  const masterValidation = usePlanControlStore(state => state.masterValidation);
  const openSearchArea = usePlanControlStore(state => state.openSearchArea);
  const setFilters = usePlanControlStore(state => state.setFilters);
  const clearFilters = usePlanControlStore(state => state.clearFilters);
  const fetchStaticColumns = usePlanControlStore(state => state.fetchStaticColumns);
  const setOpenSearchArea = usePlanControlStore(state => state.setOpenSearchArea);

  // R18 — 사용자가 포커스한 그리드로 SubTitle 의 동작 대상(Excel/Sort/Filter)이 따라간다.
  //   건수 배지는 상단 고정(countGrid)이다.
  const [focusSub, setFocusSub] = useState(false);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const setAlert = useMessageStore(state => state.setAlert);

  // X21 owner 분기 — ADMIN/SCM PI Admin 은 userId 를 '' 로 보내 owner 필터를 우회한다.
  //   GROUP_ID 축이 아니라 USER_ID 축임에 주의(hook #128).
  const session = useSessionStore(state => state.session);
  const searchInfoFilters = useMemo(
    () => ({
      userId: OWNER_BYPASS_GROUP_IDS.includes(session.groupId ?? '') ? '' : (session.userId ?? ''),
    }),
    [session.groupId, session.userId]
  );

  // 조회조건 원천 3 + 판정 집합 1. 전건 "필터 방식"이라 콤보 파라미터에 divisionId 를 싣지 않는다
  //   (쿼리 키 고정 + FE 필터 — design 02 §3). 정렬은 서버 순서를 유지한다(sortBy 미지정).
  //   gmDivisions 는 lookup 훅(admin/lookup)이 아니라 LookupCommon 콤보로 받는다 — 전자는 응답 컬럼명을
  //   SCM_ADM_LOOKUP_MASTER.SEGMENT1 헤더값으로 동적 생성해 이 룩업에서는 CODE 대신 DIVISION_ID 가
  //   내려오고, 그러면 아래 배타 토글 판정이 영구 false 가 된다(design 02 §5 데이터계약 #4).
  const [divisions, planDates, gmDivisions] = useTabComboQueries({
    filters: [
      { comboId: COMBO.DIVISION, mnuId: MENU_ID },
      COMBO.PLAN_DATE_WEEKLY,
      { comboId: COMBO.LOOKUP_COMMON, lookupType: GM_DIVISION_LOOKUP_TYPE },
    ],
  });

  // Plan Group 은 콤보 레지스트리가 아니라 searchInfo SP 의 4번째 커서다(X14).
  const { data: searchInfoData } = useTabProcQuery<MENU_ID, SHEETS.SEARCH_INFO>({
    menuId: MENU_ID,
    sheetName: SHEETS.SEARCH_INFO,
    tabId,
    filters: searchInfoFilters,
    enabled: true,
  });
  const planGroups = searchInfoData?.[RESPONSE_SET.SEARCH_INFO];

  // F01 — Division 후보는 planGroupList 의 DIVISION_ID 집합과 교집합이다(cascade 역방향 의존).
  const divisionOptions = useMemo(
    () => buildDivisionOptions(divisions, planGroups),
    [divisions, planGroups]
  );
  // R07 게이트(mount) — AS-IS cs:174-175 는 **F01 교집합 적용 전** 권한 Division(dtMyDivision) 이
  //   0건일 때만 조회영역을 잠그고 안내한다. 교집합 결과가 아니라 권한 목록 자체를 본다.
  const noAuthDivision = divisions !== undefined && divisions.length === 0;
  // R08 게이트(Search, AS-IS X04 DataUtil.cs:390-404) — 이쪽은 **F01 적용 후** 콤보 후보 수를 본다.
  //   두 축을 하나로 합치면 "권한 Division 은 있는데 Plan Group 보유 Division 과 교집합이 0" 인 계정에서
  //   AS-IS 와 달라진다(AS-IS 는 진입 시 잠금·알림 없이 Search 때만 막는다).
  const cannotSearch =
    divisions !== undefined && planGroups !== undefined && divisionOptions.length === 0;

  // R01~R03 — Plan Date 모드 배타 판정. AS-IS 가 같은 판정식을 6곳에 중복 작성한 것을 단일 파생값으로
  //   통합한다(의미 동일 — 축소 아님).
  const isDailyPlanDateMode = useMemo(
    () => (gmDivisions ?? []).some(row => str(row.CODE) === searchParams.divisionId),
    [gmDivisions, searchParams.divisionId]
  );
  const planStartYyyymmdd = resolvePlanStartYyyymmdd(searchParams, isDailyPlanDateMode);

  const {
    data: planControlData,
    isFetching: isMainFetching,
  } = useTabProcQuery<MENU_ID, SHEETS.PLAN_CONTROL>({
    menuId: MENU_ID,
    sheetName: SHEETS.PLAN_CONTROL,
    tabId,
    filters: filters[SHEETS.PLAN_CONTROL],
    enabled: !!filters[SHEETS.PLAN_CONTROL],
  });

  const rows = useMemo(
    () => planControlData?.[RESPONSE_SET.PLAN_CONTROL] ?? [],
    [planControlData]
  );

  // 진입 자동 조회 금지 — MDI keep-alive 탭에 남은 이전 filters 가 자동 발사되는 것을 막는다.
  //   컬럼 메타는 mount 시 2시트 모두 로드한다.
  useEffect(() => {
    clearFilters();
    void fetchStaticColumns();
  }, [tabId, clearFilters, fetchStaticColumns]);

  const { engineRunRows } = usePlanControlPolling({ tabId, gridRef: mainGridRef, rows });

  const { handleGridClick, handleGridDoubleClick, handleCellEditEnded } = usePlanControlCellActions({
    tabId,
    gridRef: mainGridRef,
    rows,
    planStartYyyymmdd,
    hasSavePermission: hasButton('SAVE'),
    isBusy: isMainFetching,
  });

  // R08 — 선택 가능한 Division 후보가 0건이면 조회를 발사하지 않는다(R07 과 같은 메시지, 다른 시점·다른 원천).
  const handleSearch = () => {
    if (cannotSearch) {
      void setAlert({ type: 'alert', content: t(MSG.NO_AUTH_DIVISION, '_No authority assigned.') });
      return;
    }
    setFilters(planStartYyyymmdd);
    void fetchStaticColumns();
  };

  // 확정 hotkeyConfig(01_layout §2.3 R10~R15). insert/delete/save 를 **생략하면** 공용 SubTitle 의
  //   기본 GridAction.addRow/removeRow 가 살아나 AS-IS 에 없던 행 추가·삭제가 실제로 동작한다.
  //   AS-IS override 본문이 비어 있고(NO-OP) admin 메타에도 미등록이라 두 축이 "이 화면 기능 아님"으로
  //   일치하므로 false 로 노출 자체를 막는다. 저장은 툴바가 아니라 그리드 CONFIRM 셀이 한다(R12).
  //   sort/filter/condition/resetCondition 은 키를 생략해 공용 기본 동작을 쓴다.
  //   excel 은 admin 메타(MNU_BTN_CD='EXCEL', iter-2 등록)를 제어축으로 둔다 — 권한이 있으면 키를
  //   생략해 공용 DefaultButtonActions.excelDownload 를 그대로 쓰고, 없으면 false 로 감춘다.
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: false,
    delete: false,
    save: false,
    manual: false,
    upload: false,
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
        <PlanControlForm
          onSearch={handleSearch}
          divisionOptions={divisionOptions}
          noAuthDivision={noAuthDivision}
          planGroups={planGroups}
          planDates={planDates}
          isDailyPlanDateMode={isDailyPlanDateMode}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={focusSub ? subGridRef : mainGridRef}
        gridFilter={focusSub ? subFilterRef : mainFilterRef}
        countGrid={mainGridRef}
        dataCount={rows.length}
        excelFileName='PlanControl'
        useHotkey
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      {/* AS-IS splitContainer1 은 Orientation=Horizontal = 상/하 2분할이다. react-resizable-panels 는
          orientation='vertical' 이 상/하라 용어가 반대다 — 이름대로 옮기면 좌우로 갈라진다.
          비율 56:44 = AS-IS spdMain 341px : spdSub 265px 환산. */}
      <PanelGroup className={styles.tableWrapper} orientation='vertical'>
        <Panel defaultSize={56} minSize={20}>
          <PlanControlGrid
            gridRef={mainGridRef}
            gridFilterRef={mainFilterRef}
            data={rows}
            staticColumns={staticColumns[SHEETS.PLAN_CONTROL] ?? []}
            masterValidation={masterValidation}
            click={handleGridClick}
            dblClick={handleGridDoubleClick}
            cellEditEnded={handleCellEditEnded}
            gotFocus={() => setFocusSub(false)}
          />
        </Panel>
        <PanelSeparator className={styles.splitBar} />
        <Panel defaultSize={44} minSize={15}>
          {/* 하단만 탭스트립(AS-IS siSub.VisibleTab(true)). 상단은 cs:306 에서 주석 처리돼 탭이 없다. */}
          <div className={styles.lowerGrid}>
            <TabWrapper persist>
              <TabItem label={t(LBL.STATUS, '_Status')}>
                <EngineRunGrid
                  gridRef={subGridRef}
                  gridFilterRef={subFilterRef}
                  data={engineRunRows}
                  staticColumns={staticColumns[SHEETS.ENGINE_RUN] ?? []}
                  gotFocus={() => setFocusSub(true)}
                />
              </TabItem>
            </TabWrapper>
          </div>
        </Panel>
      </PanelGroup>
    </>
  );
};
