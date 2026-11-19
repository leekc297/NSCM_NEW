import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { CapaNewModelPopup } from 'features/master/src/components';
import { type RefObject, useCallback, useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction, safeString } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import {
  formatTotalCases,
  useSaveWithValidation,
  useTabBtnPermissions,
  useTabComboQueries,
  useTabProcQuery,
  useTitleAreaLanguage,
} from '@shared/hooks';
import { TitleArea } from '@shared/lges';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore, useSessionStore, useUIStore } from '@shared/stores';

import { ProjectRouteListSaveModal } from './components/modals/ProjectRouteListSaveModal';
import { ProjectRouteBomGrid } from './components/ProjectRouteBomGrid';
import { ProjectRouteForm } from './components/ProjectRouteForm';
import { ProjectRouteMainGrid } from './components/ProjectRouteMainGrid';
import { ProjectRoutePlantGrid } from './components/ProjectRoutePlantGrid';
import { useProjectRouteValidation } from './hooks/useProjectRouteValidation';
import {
  COLUMN_SHEET_NAME,
  COMBO,
  EXCLUDE_EE_DIVISION,
  LBL,
  MENU_ID,
  MSG,
  RESPONSE_SET,
  SHEETS,
} from './project-route.constants';
import type { BomRow, PlantRow, SiteRow } from './project-route.types';
import styles from './ProjectRoute.module.scss';
import { useProjectRouteStore } from './useProjectRouteStore';
import { buildMonthColumns } from './utils/projectRoute.calendar';
import { clearPlantInvalidCells, markPlantInvalidCells, syncOrgDates } from './utils/projectRoute.plantDerive';
import { submitPlantSaveRequest } from './utils/projectRoute.plantSaveRequest';

export const ProjectRoute = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  // 건수 표기 언어(총/건 ↔ Total/rows) — 공용 SubTitle · ResultArea 와 같은 규칙(useTitleAreaLanguage 주석).
  const titleAreaLanguage = useTitleAreaLanguage();
  const { setAlert, setToast } = useMessageStore.getState();
  const setProgress = useUIStore.getState().setProgress;
  const sessionUserId = useSessionStore(s => s.session.userId);

  const mainGridRef = useRef<FlexGrid<SiteRow>>();
  const bomGridRef = useRef<FlexGrid<BomRow>>();
  const plantGridRef = useRef<FlexGrid<PlantRow>>();
  const mainFilterRef = useRef<FlexGridFilter>();
  const bomFilterRef = useRef<FlexGridFilter>();
  const plantFilterRef = useRef<FlexGridFilter>();
  const plantEditTrackerRef = useRef<EditTracker<PlantRow>>();

  // 3 그리드(Main/BOM/Plant)가 한 화면에 공존한다. 메인화면 그리드는 DataGrid 가 F3/F4 를 자체
  //   등록하지 않고(scopeId===null → DataGrid.tsx 참조) SubTitle 이 F4 를 전담하는데, SubTitle 은
  //   넘겨받은 grid 하나만 대상으로 하고 그 grid.containsFocus() 일 때만 F4 가 동작한다. 따라서
  //   SubTitle 에 넘기는 grid/gridFilter 를 "지금 포커스된 그리드" 로 바꿔줘야 F4 가 포커스 그리드에
  //   걸린다(Formation 동일 패턴). 각 그리드 gotFocus 로 activeSheet 를 갱신 → 재렌더로 반영.
  const [activeSheet, setActiveSheet] = useState<RESPONSE_SET>(RESPONSE_SET.SITE);
  const gridRefs: Record<RESPONSE_SET, RefObject<FlexGrid | undefined>> = {
    [RESPONSE_SET.SITE]: mainGridRef,
    [RESPONSE_SET.BOM]: bomGridRef,
    [RESPONSE_SET.PLANT]: plantGridRef,
  };
  const gridFilterRefs: Record<RESPONSE_SET, RefObject<FlexGridFilter | undefined>> = {
    [RESPONSE_SET.SITE]: mainFilterRef,
    [RESPONSE_SET.BOM]: bomFilterRef,
    [RESPONSE_SET.PLANT]: plantFilterRef,
  };

  const initialized = useProjectRouteStore(s => s.initialized);
  const filters = useProjectRouteStore(s => s.filters);
  const searchParams = useProjectRouteStore(s => s.searchParams);
  const siteKey = useProjectRouteStore(s => s.siteKey);
  const bomKey = useProjectRouteStore(s => s.bomKey);
  const isBomClicked = useProjectRouteStore(s => s.isBomClicked);
  const staticColumns = useProjectRouteStore(s => s.staticColumns);
  const openSearchArea = useProjectRouteStore(s => s.openSearchArea);
  const setOpenSearchArea = useProjectRouteStore(s => s.setOpenSearchArea);
  const setFilters = useProjectRouteStore(s => s.setFilters);
  const applySiteKey = useProjectRouteStore(s => s.applySiteKey);
  const applyBomKey = useProjectRouteStore(s => s.applyBomKey);
  const fetchStaticColumns = useProjectRouteStore(s => s.fetchStaticColumns);
  const resetKeepPeriod = useProjectRouteStore(s => s.resetKeepPeriod);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const { validatePlantSave } = useProjectRouteValidation();
  const { saveWithValidation } = useSaveWithValidation();

  // Input All 버튼 disabled 판정용(design/01 R1). 콤보 조회는 ProjectRouteForm 과 동일
  //   queryKey 를 공유해 react-query 캐시가 재사용되므로 추가 네트워크 요청은 없다.
  // ProjectRouteForm 과 동일 EE 제외 후처리(project-route.constants.ts COMBO.DIVISION 주석) — 같은
  //   queryKey 라 react-query 캐시를 공유, 추가 네트워크 요청 없음.
  const [divisionsRaw] = useTabComboQueries({ filters: [COMBO.DIVISION] });
  const divisions = useMemo(() => divisionsRaw?.filter(EXCLUDE_EE_DIVISION), [divisionsRaw]);
  const noDivisionAuth = divisions !== undefined && divisions.length === 0;

  // ---- 3 시트 조회(연쇄 enabled 게이트) ----
  const { data: siteData } = useTabProcQuery<MENU_ID, SHEETS.SITE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SITE,
    tabId,
    filters: filters[SHEETS.SITE],
    enabled: !!filters[SHEETS.SITE],
  });
  const { data: bomData, refetch: refetchBom } = useTabProcQuery<MENU_ID, SHEETS.BOM>({
    menuId: MENU_ID,
    sheetName: SHEETS.BOM,
    tabId,
    filters: filters[SHEETS.BOM],
    enabled: !!filters[SHEETS.BOM],
  });
  const { data: plantData, refetch: refetchPlant } = useTabProcQuery<MENU_ID, SHEETS.PLANT>({
    menuId: MENU_ID,
    sheetName: SHEETS.PLANT,
    tabId,
    filters: filters[SHEETS.PLANT],
    enabled: !!filters[SHEETS.PLANT],
  });

  // 참조 안정화(nscm-patterns §5-4). division 변경 시 새 [] 로 비운다.
  const siteRows = useMemo(
    () => siteData?.site ?? [],
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [siteData, searchParams.divisionId]
  );
  const bomRows = useMemo(() => bomData?.bom ?? [], [bomData]);
  const plantRows = useMemo(() => plantData?.plant ?? [], [plantData]);

  // 동적 월 컬럼 = Period From/To 파생(design/03 §2). Period 변경 시 재빌드.
  const monthColumns = useMemo(
    () => buildMonthColumns(searchParams.fromYyyymm, searchParams.toYyyymm),
    [searchParams.fromYyyymm, searchParams.toYyyymm]
  );

  // R11(design/03 §3.2) — BOM reload 시 Main 해당 행 PLANT_PER_ITEM = nInput/nTot 파생표시.
  //   nTot=BOM 행수, nInput=PRIMARY_PLANT 비어있지 않은 행수. 재조회 없이 해당 행만 갱신.
  useEffect(() => {
    if (!siteKey || bomRows.length === 0) return;
    const nTot = bomRows.length;
    const nInput = bomRows.filter(r => String(r.PRIMARY_PLANT ?? '').trim() !== '').length;
    const grid = mainGridRef.current;
    const source = grid?.collectionView?.sourceCollection as unknown as SiteRow[] | undefined;
    const target = source?.find(
      r =>
        String(r.DIVISION_ID ?? '') === siteKey.divisionId &&
        String(r.SCM_SITE_ID ?? '') === siteKey.scmSiteId &&
        String(r.ITEM_ID ?? '') === siteKey.itemId &&
        String(r.PROJECT_CODE ?? '') === siteKey.projectCode
    );
    if (target) {
      (target as Record<string, unknown>).PLANT_PER_ITEM = `${nInput}/${nTot}`;
      grid?.collectionView?.refresh();
    }
  }, [bomRows, siteKey]);

  // R-RESTORE(design/03 §3 R-RESTORE, cs L618-629) — AfterFindDataBOM 이후 이전에 더블클릭했던
  //   Main/BOM 셀 위치로 스크롤·선택을 복원한다(Plant 는 AS-IS 도 복원 없음 — 매 조회 최상단 유지).
  //   G9 교정(04_impl-gap-audit): BOM 재조회(Main 더블클릭 후 최초 진입 + Save 후 refetchBom 공통)
  //   마다 Main/BOM 그리드의 선택 표시를 siteKey/bomKey 로 되돌린다.
  useEffect(() => {
    if (!siteKey) return;
    const grid = mainGridRef.current;
    if (!grid) return;
    const idx = grid.rows.findIndex(row => {
      const r = row?.dataItem as SiteRow | undefined;
      return (
        !!r &&
        String(r.DIVISION_ID ?? '') === siteKey.divisionId &&
        String(r.SCM_SITE_ID ?? '') === siteKey.scmSiteId &&
        String(r.ITEM_ID ?? '') === siteKey.itemId &&
        String(r.PROJECT_CODE ?? '') === siteKey.projectCode
      );
    });
    if (idx >= 0) {
      grid.select(idx, Math.max(0, grid.selection.col));
      grid.scrollIntoView(idx, -1);
    }
  }, [bomRows, siteKey]);

  useEffect(() => {
    if (!bomKey) return;
    const grid = bomGridRef.current;
    if (!grid) return;
    const idx = grid.rows.findIndex(row => {
      const r = row?.dataItem as BomRow | undefined;
      return (
        !!r &&
        String(r.ITEM_ID ?? '') === bomKey.itemId &&
        String(r.OPERATION_GROUP_ID ?? '') === bomKey.operationId
      );
    });
    if (idx >= 0) {
      grid.select(idx, Math.max(0, grid.selection.col));
      grid.scrollIntoView(idx, -1);
    }
  }, [bomRows, bomKey]);

  // CELL_TYPE 이 'CA' 로 시작하면 Plant 추가/편집 불가.
  // const plantReadOnly = (bomKey?.cellType ?? '').toUpperCase() === 'CA1';
  const plantReadOnly = (bomKey?.cellType ?? '').toUpperCase().startsWith('CA');

  // ---- mount 1회 컬럼 메타 fetch(admin 즉시반영 baseline) ----
  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // ---- Button 핸들러 ----
  const handleSearch = useCallback(() => {
    setFilters();
    void fetchStaticColumns();
  }, [setFilters, fetchStaticColumns]);

  // Reset Condition(F10) — 공용 기본 동작(SubTitle DefaultButtonActions)은 store 를 통째로
  //   initState() 로 되돌려 Period 도 함께 초기화된다. 사용자 지시(2026-09-23)로 이 화면만 Period 는
  //   보존하도록 재정의 — 확인 다이얼로그·서버 저장조건 삭제(resetPersonalizedCondition)는 공용
  //   동작과 동일, store 리셋만 resetKeepPeriod 로 대체한다.
  const handleResetCondition = () => {
    void (async () => {
      if (
        await setAlert({
          type: 'confirm',
          content: t('MSG00009', '_저장된 검색조건을 초기화 하겠습니까?'),
        })
      ) {
        await GridAction.resetPersonalizedCondition(MENU_ID).then(() => {
          void setAlert({
            type: 'alert',
            content: t('MSG00011', '_검색조건이 초기화 되었습니다.'),
          });
          resetKeepPeriod();
        });
      }
    })();
  };

  // Insert(design/03 R-INS-DEF) — BOM 더블클릭 선행 필수(MSG00116). 신규행 기본값 5종 세팅.
  //   CELL_TYPE 이 CA* 이면 메시지 없이 무시한다.
  const handleInsert = () => {
    if (plantReadOnly) return;
    if (!isBomClicked || !siteKey || !bomKey || !bomKey.itemId) {
      void setAlert({
        type: 'alert',
        content: t(MSG.INSERT_NEED_BOM, '_BOM Item 을 먼저 더블클릭하세요.'),
      });
      return;
    }
    const grid = plantGridRef.current;
    if (!grid) return;
    GridAction.addRow(grid, {
      DIVISION_ID: siteKey.divisionId,
      SCM_SITE_ID: siteKey.scmSiteId,
      PROJECT_CODE: siteKey.projectCode,
      ITEM_ID: bomKey.itemId,
      VALID_YN: 'Y',
    });
  };

  // 저장검증 실패 셀 하이라이트(design/03 §3.4 SetBGColor, AS-IS IS_PASS_N* 그리드 paint 파리티).
  //   실패 셀을 행 객체에 플래그로 심고(markPlantInvalidCells) 그리드 formatItem 이 셀을 (재)그릴 때마다
  //   읽어 칠한다(ProjectRoutePlantGrid). 스크롤/refresh 로 셀 DOM 이 재활용돼도 다시 칠해져 지워지지
  //   않는다 — 종전 DOM 직접 칠하기(getCellElement().style)가 가상 스크롤에 지워지던 gap 교정.

  // 이전 검증 실패 마킹 제거(AS-IS 매 checkValidN* 시작의 BG UnLockColor 리셋). 안 지우면 재시도 때
  //   현재 오류와 무관한 옛 빨강이 남아 오해를 준다. 플래그를 지우고 grid 를 invalidate 해 재칠하게 한다.
  const clearPlantInvalidMarks = () => {
    const grid = plantGridRef.current;
    const source = (grid?.collectionView?.sourceCollection ?? []) as unknown[];
    clearPlantInvalidCells(source);
    grid?.invalidate();
  };

  // 저장검증 실패 셀 하이라이트(design/03 §3.4 SetBGColor). 실패 셀을 행 객체에 플래그로 심고 grid 를
  //   invalidate 하면 formatItem 이 #ffd7d7 로 칠한다 — 영구 유지(스크롤 후에도).
  const markInvalidCells = (cells: { row: PlantRow; column: string }[]) => {
    const grid = plantGridRef.current;
    if (!grid) return;
    markPlantInvalidCells(cells);
    grid.invalidate();
  };

  // 실제 SAVE_PLANT 호출(payload 조립 + false-success 판별, utils/projectRoute.plantSaveRequest 공용).
  //   saveWithValidation 의 메타 필수검증 통과 후에만 호출된다. Input All 팝업의 Save 도 동일 유틸 사용
  //   (AS-IS 도 같은 SP `SCP.SCP0006_SAVE_PROJECT_ROUTE_PLANT` 를 호출 — Roslyn 실측).
  const submitPlantSave = async (changed: PlantRow[]) => {
    const result = await submitPlantSaveRequest(changed, sessionUserId ?? '');
    if (!result.ok) {
      void setAlert({
        type: 'alert',
        content: result.message ?? t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.'),
      });
      return;
    }
    void setToast({ type: 'success', message: t(MSG.SAVE_RESULT, '_저장되었습니다.') });
    plantEditTrackerRef.current?.clearChanges();
    // 저장 후 BOM+Plant 동시 재조회(design/03 §4.5 — AS-IS SaveData()가 SAVE_PLANT+GET_BOM+GET_PLANT
    //   를 한 배치로 실행. BOM 의 PRIMARY_PLANT 갱신 → R11 파생(PLANT_PER_ITEM)의 최신화 근거).
    //   G3 교정(04_impl-gap-audit): 개별 fire-and-forget 2회는 원자성이 약해 과도기적으로 BOM/Plant가
    //   서로 다른 시점의 데이터를 보일 수 있었다 — Promise.all 로 두 재조회를 함께 대기한다.
    void Promise.all([refetchBom(), refetchPlant()]);
  };

  // Save(design/03 §4.4) — AS-IS CheckChangedValues(cs L941-955) 순서를 그대로 지킨다:
  //   ① 필수값 체크(checkRequiredOfSpread) → ② N1~N9 → ③ SAVE_PLANT(^-delim CLOB).
  //   공용 saveWithValidation 이 ①(미입력 필수셀 → "[항목] 값은 필수 입력 항목입니다" alert)을
  //   담당하므로 먼저 태우고, 그 통과 콜백 안에서 ②를 돈다.
  //   주의(2026-11-13 교정): ①②를 거꾸로 두면 빈 FROM/TO 가 ②의 N8-a(AS-IS 가 메시지 없이 막는
  //   무언 차단)에 먼저 가로채여, 사용자에게 "필수" 메시지 없이 아무 반응 없이 저장만 막히는
  //   것처럼 보였다 — AS-IS 는 ①이 먼저라 필수 메시지가 뜬다. 순서를 AS-IS 로 되돌려 교정.
  const handleSave = () => {
    const grid = plantGridRef.current;
    if (!grid) return;
    grid.finishEditing();
    const source = (grid.collectionView?.sourceCollection ?? []) as unknown as PlantRow[];
    const changed = source.filter(r => r.CRUD_TYPE === 'I' || r.CRUD_TYPE === 'M');
    if (changed.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.NO_CHANGE, '_수정한 내용이 없습니다.') });
      return;
    }

    // 검증 직전 ORG_*/MERGE_DATE 를 현재 화면값으로 재동기화(syncOrgDates) — 붙여넣기/채우기 편집은
    //   cellEditEnded 를 안 거쳐 ORG 가 stale 해지고, 그러면 화면엔 같은 날짜인데도 검증이 옛 ORG 로
    //   비교해 N1 을 오탐한다(AS-IS 는 모델 Changed 로 전건 재파생 — 파리티 복원, 2026-11-12).
    syncOrgDates(source);

    // ① 필수값 체크(통과 시에만 콜백). ② 콜백 안에서 N1~N9. ③ 통과 시 SAVE.
    saveWithValidation(changed, staticColumns[RESPONSE_SET.PLANT], validRows => {
      // 재검증 전 이전 실패 마킹을 먼저 지운다(AS-IS 매 검사 BG 리셋) — 재시도 시 옛 빨강 잔존 방지.
      clearPlantInvalidMarks();
      // 검증은 화면 전체 VALID_YN='Y' 행 대비(design/03 §3.4 중첩/연속성 등).
      const v = validatePlantSave(source);
      if (!v.ok) {
        markInvalidCells(v.invalidCells);
        // N8-a(design/03 §3)는 AS-IS 가 메시지 없이 조용히 저장을 막는 유일한 분기 — alert 생략.
        if (!v.silent) {
          void setAlert({ type: 'alert', content: t(v.msgId ?? MSG.SAVE_ERROR, '_저장 검증 실패') });
        }
        return;
      }
      void submitPlantSave(validRows);
    });
  };

  // Input All(btnAllFind, design/01 R5) — SCM0002_ProjectRouteListSavePopup 일괄등록 팝업.
  //   AS-IS 소스(GSCM/06.UIL/GSCM.SCM.Popup.UIL/SCM0002_ProjectRouteListSavePopup.cs) 실측 반영.
  const [openInputAllModal, setOpenInputAllModal] = useState(false);
  const handleInputAll = () => setOpenInputAllModal(true);

  // A5(design/03, cs L1389-1446) — Plant Assign 더블클릭 → CAPA New Model 팝업(공용 컴포넌트,
  //   SCP0049_CAPA/SCP0201_CAPA 와 공유 — .atlas/gscm-design/SCP0049 참고). 팝업 자체는 UI 만
  //   완성된 상태(SP 미배포, capa-new-model-popup.constants.ts 헤더 참고).
  const [capaPopupParams, setCapaPopupParams] = useState<{
    divisionId: string;
    plantId: string;
    groupId: string;
    operationId: string;
    itemId: string;
  } | null>(null);
  const handlePlantDblClick = (row: PlantRow) => {
    const rec = row as Record<string, unknown>;
    setCapaPopupParams({
      divisionId: siteKey?.divisionId ?? '',
      plantId: safeString(rec.PLANT_ID),
      groupId: safeString(rec.OPERATION_GROUP_ID),
      operationId: safeString(rec.OPERATION_ID),
      itemId: safeString(rec.ITEM_ID),
    });
  };

  // Excel Download 대상(AS-IS BaseForm.ExcelButton, GSCM 01.Framework/GSCM.Windows.Forms/UI/BaseForm.cs:4151
  //   실측) 재현 — AS-IS 는 포커스된 Spread 를 내보내고, 포커스가 없으면 보이는 첫 Spread(Main)를 쓴다.
  //   SubTitle 기본 동작은 grid prop(Plant) 고정이라, Main만 조회하고 바로 Excel 을 누르면(Plant 미선택)
  //   빈 파일이 나가는 AS-IS 대비 회귀가 있었다 — 여기서 focus 우선/Main 폴백으로 override 한다.
  const handleExcelDownload = () => {
    const target =
      [mainGridRef.current, bomGridRef.current, plantGridRef.current].find(g =>
        g?.containsFocus()
      ) ?? mainGridRef.current;
    if (!target) return;
    void GridAction.excelDownload(target, 'ProjectRoute', setProgress);
  };

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    save: hasButton('SAVE') ? handleSave : false,
    // Delete 버튼은 쓰지 않는다(테스트 지적 「Delete 버튼 필요없으므로 제거」, 2026-10-21). AS-IS 에는
    //   신규 행만 지우는 Delete 가 있었으나(SCP0006_ProjectRoute.cs DeleteButton) 업무 요청으로 뺀다.
    //   버튼 메타(SCM_ADM_MNU_BTN_MPG_M plant · DELETE)가 남아 있어도 화면에 나오지 않는다.
    delete: false,
    resetCondition: handleResetCondition,
    excel: handleExcelDownload,
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
      {openSearchArea && <ProjectRouteForm onSearch={handleSearch} />}
      {/* 3 그리드(Main/BOM Explosion/Plant Assign)가 항상 동시에 보이므로, 상단 툴바 줄의 건수
          배지는 어느 그리드인지 모호해 숨기고 각 그리드 제목 줄에서 나눠 표시한다
          (GroupUser.tsx/AuthRequest.tsx 동일 패턴 — hideTotalCases). 툴바 동작 대상은 그대로 Plant. */}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRefs[activeSheet]}
        gridFilter={gridFilterRefs[activeSheet]}
        dataCount={plantRows.length}
        hideTotalCases
        excelFileName='ProjectRoute'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
        customButtons={[
          // Input All(btnAllFind, design/01 R5) — 검색영역이 아닌 그리드 툴바(Save 좌측)로 배치.
          {
            label: t(LBL.INPUT_ALL, '_Input All'),
            action: handleInputAll,
            disabled: noDivisionAuth,
          },
        ]}
      />
      <PanelGroup className={styles.tableWrapper} orientation='vertical'>
        <Panel defaultSize={40} minSize={15}>
          {/* 그리드별 건수 표시(위 hideTotalCases 참고). Main 은 화면의 주 그리드라 제목 없이 건수만. */}
          <div className={styles.gridSection}>
            <TitleArea
              isSubTitle
              title=''
              depth='h4'
              totalCases={formatTotalCases(siteRows.length === 0 ? undefined : siteRows.length)}
              language={titleAreaLanguage}
            />
            <ProjectRouteMainGrid
              gridRef={mainGridRef}
              gridFilterRef={mainFilterRef}
              data={siteRows}
              staticColumns={staticColumns[RESPONSE_SET.SITE]}
              monthColumns={monthColumns}
              divisionId={searchParams.divisionId}
              onRowDblClick={applySiteKey}
              gotFocus={() => setActiveSheet(RESPONSE_SET.SITE)}
            />
          </div>
        </Panel>
        <PanelSeparator className={styles.splitBarRow} />
        <Panel defaultSize={60} minSize={20}>
          <PanelGroup orientation='horizontal'>
            <Panel defaultSize={50} minSize={20}>
              <div className={styles.gridSection}>
                <TitleArea
                  isSubTitle
                  title={COLUMN_SHEET_NAME[RESPONSE_SET.BOM]}
                  depth='h4'
                  totalCases={formatTotalCases(bomRows.length === 0 ? undefined : bomRows.length)}
                  language={titleAreaLanguage}
                />
                <ProjectRouteBomGrid
                  gridRef={bomGridRef}
                  gridFilterRef={bomFilterRef}
                  data={bomRows}
                  staticColumns={staticColumns[RESPONSE_SET.BOM]}
                  onRowDblClick={applyBomKey}
                  gotFocus={() => setActiveSheet(RESPONSE_SET.BOM)}
                />
              </div>
            </Panel>
            <PanelSeparator className={styles.splitBarCol} />
            <Panel defaultSize={50} minSize={20}>
              <div className={styles.gridSection}>
                <TitleArea
                  isSubTitle
                  title={COLUMN_SHEET_NAME[RESPONSE_SET.PLANT]}
                  depth='h4'
                  totalCases={formatTotalCases(
                    plantRows.length === 0 ? undefined : plantRows.length
                  )}
                  language={titleAreaLanguage}
                />
                <ProjectRoutePlantGrid
                  gridRef={plantGridRef}
                  gridFilterRef={plantFilterRef}
                  editTrackerRef={plantEditTrackerRef}
                  data={plantRows}
                  staticColumns={staticColumns[RESPONSE_SET.PLANT]}
                  siteKey={siteKey}
                  bomKey={bomKey}
                  readOnly={plantReadOnly}
                  onRowDblClick={handlePlantDblClick}
                  gotFocus={() => setActiveSheet(RESPONSE_SET.PLANT)}
                />
              </div>
            </Panel>
          </PanelGroup>
        </Panel>
      </PanelGroup>
      <ProjectRouteListSaveModal
        open={openInputAllModal}
        onClose={() => setOpenInputAllModal(false)}
        divisionId={searchParams.divisionId}
        divisionName={divisions?.find(d => d.CODE === searchParams.divisionId)?.NAME}
        onSaved={handleSearch}
      />
      <CapaNewModelPopup
        open={!!capaPopupParams}
        onClose={() => setCapaPopupParams(null)}
        params={capaPopupParams ?? undefined}
      />
    </>
  );
};
