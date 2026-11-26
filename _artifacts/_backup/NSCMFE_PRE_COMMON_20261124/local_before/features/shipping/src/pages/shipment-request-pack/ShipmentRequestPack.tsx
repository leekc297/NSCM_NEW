import { FileExceluploadIcon } from '@lges/design-system/icon';
import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MeasureSelectModal, ModelByDivisionPopup } from 'features/master/src/components';
import { type RefObject, useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { IcMeasureSelect } from '@foundation/assets';
import dayjs from '@foundation/dayjs';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import {
  useTabBtnPermissions,
  useTabComboQueries,
  useTabLookupQueries,
  useTabProcQuery,
} from '@shared/hooks';
import { FileExceldownloadIcon } from '@shared/lges-icons';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore, useSessionStore, useUIStore } from '@shared/stores';

import { ExcelUploadModal } from './components/ExcelUploadModal';
import { BodItemRouteModal, type BodItemReturn } from './components/modals/BodItemRouteModal';
import { ShipmentRequestPackDetailGrid } from './components/ShipmentRequestPackDetailGrid';
import { ShipmentRequestPackDetailSearch } from './components/ShipmentRequestPackDetailSearch';
import { ShipmentRequestPackForm } from './components/ShipmentRequestPackForm';
import { ShipmentRequestPackMainGrid } from './components/ShipmentRequestPackMainGrid';
import {
  ADMIN_SHEET_NAME,
  COMBO,
  LBL,
  MAX_PERIOD_LABEL_DAYS,
  MEASURE,
  MENU_ID,
  PERIOD_MSG,
  SHEETS,
} from './shipment-request-pack.constants';
import type {
  CellRow,
  PackRow,
  RequestDetailRow,
  ResultDetailRow,
} from './shipment-request-pack.types';
import styles from './ShipmentRequestPack.module.scss';
import { useShipmentRequestPackStore } from './useShipmentRequestPackStore';
import {
  buildSaveCellPayload,
  buildSavePackPayload,
  buildSaveRequestDetailPayload,
  collectPivotChanges,
  collectRequestDetailChanges,
  findDuplicateNewRequestDetailKey,
  findDuplicateNewRowKey,
  findFirstMissingRequired,
  findInvalidShipmentDate,
} from './utils/shipment-request-pack.save';
import type { SaveResultRow } from './utils/shipment-request-pack.save';
import type { SpreadTitleRow } from './utils/shipment-request-pack.spreadHeader';

// SSP0026 Shipment Request Pack — AS-IS SSP0026_ShipmentRequestPack(Forms.UIL 정본, controls 76)
//   1:1 골격 전환(iter-1). 조회 = PKG_SSP0026.P_SSP0026_GET_SHIPMENT_REQUEST_PACK/_CELL(Pack/Cell) +
//   GET_REQUEST_DETAIL_PACK/GET_RESULT_DETAIL(상세). 저장 = SAVE_SHIP_REQ_PACK/_CELL/_DETAIL_PACK/_DETAIL_CELL
//   (활성 그리드별 분기, design 01 R12).
//
// 정직 보고(convert-core §4.3): PKG_SSP0026 13개 대상 SP 중 7건(메인 그리드 조회 2 + 저장 4 +
//   Detail Cell 조회 1) 이 TO-BE 미배포(all_objects 0건, 2026-09-26 ora.py 실측, goal.md ②) —
//   메인 그리드 조회/저장 핵심 플로우는 FE 배선만 완비되고 런타임 실행체인이 미완이다(convert-sp 후속).
//   Request/Result Detail 조회·엑셀다운로드·BOD자동세팅·pivot헤더 SP 6건은 배포돼 실행 가능하다.
//
// iter-3(react-gap-audit 재시도 1) 갱신: Bucket Type 콤보 SQL_ID 불일치(신규발견, 고) 해소 —
//   'DM0003_GET_BUCKET_TYPE_CODE'는 미등록 오기재였고 ora.py 재실측으로 'BucketType' 확정(constants.ts).
//   Delete no-op(§6, 고) 해소 — GridAction.removeRow(grid, true)로 활성 그리드의 신규행('I')만 제거하도록
//   배선. Insert도 GridAction.addRow로 Cell Biz/Request Detail 신규행 생성(기본값 Division/SHIP_REQ/'-')까지
//   배선했으나, 행/컬럼 단위 화이트리스트 unlock(R9/R10 세분화)은 여전히 미완(그리드 전체 isEditMode 단위만).
//
// 이번 회차(iter-3) 미완 — 04_react-gap.md 참조(임의 구현 금지, 다음 회차 이월):
//   - Cell Biz 탭 권한 게이트(dtPgmAuthId, R1) DB 실측 미완 — 이번 회차는 항상 2탭 노출
//   - Auto-Sync 3방향 배분(D↔W↔M, 03_grid-columns.md R20) — 가장 복잡한 로직, 미착수
//   - Measure=="SHIP_REQ" 행 확정구간 이후만 unlock 하는 행/컬럼 세분화(R7), Measure 4색 배경(R18)
//   - Insert 화이트리스트 unlock(R9/R10 컬럼 단위), BOD_ID 자동세팅(R10/R14), 엑셀 업/다운로드(§4.4)
//   - Save 실제 API 호출(SP 미배포로 호출부만 자리표시), Model 팝업(SSP0026_ItembyDivisionPopup) 내부
//     설계·구현(goal.md ①부기, plan.md 1번 항목), 그리드 셀콤보 5종(TransportMode/Incoterms/FCST_TYPE/
//     Measure/FromSite·ToSite·ShipToCode) 배선
//   - 메뉴 등록(2.7)·컬럼/Measure 메타(2.75)·콤보/Lookup 메타(2.76)·권한 입력(2.8) DB 적용
export const ShipmentRequestPack = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const { setAlert, setToast } = useMessageStore();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const gridRefPack = useRef<FlexGrid<PackRow>>();
  const gridFilterRefPack = useRef<FlexGridFilter>();
  const editTrackerRefPack = useRef<EditTracker<PackRow>>();
  const gridRefCell = useRef<FlexGrid<CellRow>>();
  const gridFilterRefCell = useRef<FlexGridFilter>();
  const editTrackerRefCell = useRef<EditTracker<CellRow>>();
  const gridRefRequest = useRef<FlexGrid<RequestDetailRow>>();
  const gridFilterRefRequest = useRef<FlexGridFilter>();
  const editTrackerRefRequest = useRef<EditTracker<RequestDetailRow>>();
  const gridRefResult = useRef<FlexGrid<ResultDetailRow>>();
  const gridFilterRefResult = useRef<FlexGridFilter>();

  const searchParams = useShipmentRequestPackStore(state => state.searchParams);
  const setSearchParams = useShipmentRequestPackStore(state => state.setSearchParams);
  const filters = useShipmentRequestPackStore(state => state.filters);
  const cellFilters = useShipmentRequestPackStore(state => state.cellFilters);
  const requestDetailFilters = useShipmentRequestPackStore(state => state.requestDetailFilters);
  const resultDetailFilters = useShipmentRequestPackStore(state => state.resultDetailFilters);
  const spreadTitleFilters = useShipmentRequestPackStore(state => state.spreadTitleFilters);
  const isOpenSearchArea = useShipmentRequestPackStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useShipmentRequestPackStore(state => state.setOpenSearchArea);
  const setMainFilters = useShipmentRequestPackStore(state => state.setMainFilters);
  const setDetailFilters = useShipmentRequestPackStore(state => state.setDetailFilters);
  const drillDetailFromMain = useShipmentRequestPackStore(state => state.drillDetailFromMain);
  const clearFilters = useShipmentRequestPackStore(state => state.clearFilters);
  const staticColumns = useShipmentRequestPackStore(state => state.staticColumns);
  const fetchStaticColumns = useShipmentRequestPackStore(state => state.fetchStaticColumns);
  const fetchStaticMeasures = useShipmentRequestPackStore(state => state.fetchStaticMeasures);
  const staticMeasures = useShipmentRequestPackStore(state => state.staticMeasures);
  const visibleMeasures = useShipmentRequestPackStore(state => state.visibleMeasures);
  const applyVisibleMeasures = useShipmentRequestPackStore(state => state.applyVisibleMeasures);
  const restoreSearchConditions = useShipmentRequestPackStore(
    state => state.restoreSearchConditions
  );
  const activeMainSheet = useShipmentRequestPackStore(state => state.activeMainSheet);
  const setActiveMainSheet = useShipmentRequestPackStore(state => state.setActiveMainSheet);
  const activeDetailSheet = useShipmentRequestPackStore(state => state.activeDetailSheet);
  const setActiveDetailSheet = useShipmentRequestPackStore(state => state.setActiveDetailSheet);
  const activeGrid = useShipmentRequestPackStore(state => state.activeGrid);
  const setActiveGrid = useShipmentRequestPackStore(state => state.setActiveGrid);

  // Measure 설정 팝업(btnMeasure) / Excel Upload 팝업(btnExcelUpload) 열림 상태.
  const [openMeasure, setOpenMeasure] = useState(false);
  const [openExcelUpload, setOpenExcelUpload] = useState(false);
  // Request Detail MODEL_ID 셀 더블클릭 대상 행 — Model 팝업(검색조건 동일, 행 FROM_SITE 기준) 오픈 상태.
  const [modelCellRow, setModelCellRow] = useState<RequestDetailRow | null>(null);
  // Cell Biz 메인 그리드 신규행 Model 셀 더블클릭 대상 행 — AS-IS cellTypeImage Item 팝업(GAP-G 해소).
  const [cellModelRow, setCellModelRow] = useState<CellRow | null>(null);
  // Cell Biz 메인 그리드 신규행 Trans Mode 셀 더블클릭 대상 행 — BOD 팝업(DMF0045 파리티, 2026-11-04).
  const [bodPopupRow, setBodPopupRow] = useState<CellRow | null>(null);
  // 활성 spdMain 시트를 SHEETS enum 키로(ActiveMainSheet 문자열 ↔ SHEETS enum 구분) — measure 메타 인덱싱용.
  const activeSheetKey = activeMainSheet === 'pack' ? SHEETS.PACK : SHEETS.CELL;

  // 편집권한은 화면 오픈 시 1회만 판정한다(convert-core §2.4) — AS-IS Edit 모드토글 미이식.
  //   권한 없으면 처음부터 읽기전용으로 열린다. Main/Detail 두 그리드 모두 이 canEdit 하나로 통일.
  const canEdit = hasButton('EDIT');

  // Cell Biz 탭 권한 게이트(design 01 R1, AS-IS Form_Load cs:267/338) — LookupCommon 'PGM_AUTH_ID' 의
  //   PROGRAM_ID=SSP0026 행 AUTH_ID(허용 그룹명)에 내 그룹(groupId/groups)이 포함될 때만 Cell Biz 탭을 노출한다.
  //   AS-IS 는 drPgmAuthId(CODE='SSP0026' AND NAME=NowGroupID) 존재 시에만 AddSheet(shtCell). 허용행 0건이면 비노출.
  //   주의: /api/admin/lookup 실측 응답 필드는 PROGRAM_ID/AUTH_ID 다(AS-IS LookupCommon 의 CODE/NAME 아님,
  //   2026-11-04 네트워크 실측). 종전 r.CODE/r.NAME 참조는 항상 undefined → allowed 공란 → 탭이 누구에게도
  //   안 뜨던 버그였다. 필드명을 실측값으로 바로잡아 허용 그룹 사용자에게 Cell Biz 탭을 노출한다.
  const [pgmAuthLookup] = useTabLookupQueries({ filters: [{ lookupType: 'PGM_AUTH_ID' }] });
  const sessionGroupId = useSessionStore(s => s.session.groupId);
  const sessionGroups = useSessionStore(s => s.session.groups);
  const canSeeCellBiz = useMemo(() => {
    const allowed = (pgmAuthLookup ?? [])
      .filter(r => String((r as { PROGRAM_ID?: unknown }).PROGRAM_ID) === MENU_ID)
      .map(r => String((r as { AUTH_ID?: unknown }).AUTH_ID));
    if (allowed.length === 0) return false;
    const mine = new Set([sessionGroupId, ...(sessionGroups ?? [])].filter(Boolean));
    return allowed.some(name => mine.has(name));
  }, [pgmAuthLookup, sessionGroupId, sessionGroups]);

  // Division 은 고정값이라 실질 변경 없음 — 화면 재진입/탭 전환 시 그리드 초기화 의무만 유지
  // (nscm-patterns.md §5-5 준용).
  const prevKeyRef = useRef(searchParams.divisionId);
  useEffect(() => {
    if (prevKeyRef.current === searchParams.divisionId) return;
    prevKeyRef.current = searchParams.divisionId;
    editTrackerRefRequest.current?.clearChanges();
    clearFilters();
  }, [searchParams.divisionId, clearFilters]);

  useEffect(() => {
    fetchStaticColumns();
    fetchStaticMeasures();
    // F6 개인화 저장분 복원(SubTitle searchParam={searchParams} 저장 side 와 짝) — 1회 가드 store 내부.
    void restoreSearchConditions();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // Period 기본값 — AS-IS InitControls 가 Data_SCP.Common(Plan_InforPacker) 1행의 FROM_DATE/TO_DATE 로
  //   drpPeriod(메인 조회기간)·drpPeriod2(상세 Shipment Date)를 세팅한다(design 02 §2.7). 콤보 반환은
  //   YYYY-MM-DD 라 하이픈 제거해 YYYYMMDD 로 쓴다. 비어 있을 때만 채워 사용자/F6 복원값을 덮지 않는다.
  const [planPeriod] = useTabComboQueries({ filters: [COMBO.PLAN_PERIOD] });
  // 확정일(design 01 R7/R18) — 같은 Plan_InforPacker_SCP 1행에서 Pack=NAME(오늘)·Cell=CONFIRM_DAY(실측)
  //   을 yyyymmdd 로 뽑아 메인 그리드에 전달(확정구간 회색+잠금 기준). 미조회면 빈값(확정구간 미표시).
  const planRow = planPeriod?.[0] as Record<string, string> | undefined;
  const confirmDayPack = String(planRow?.NAME ?? '').replace(/-/g, '');
  const confirmDayCell = String(planRow?.CONFIRM_DAY ?? '').replace(/-/g, '');

  // 기본요일(DEFAULT_BUCKET_DAY) — W→D/M→D 배분 기준 요일(AS-IS DefaultBucketDay, cs:2665/2727). division별
  //   요일(40=MON, 81/82=FRI). 전 division 에 WEEKLY=MONTHLY 동일 요일이라 활성 bucketType 으로 한 번 조회.
  //   CODE/NAME 동일(요일코드 MON 등). 메인 그리드(Cell Biz)의 Auto-Sync W→D/M→D 가 이 요일에 배분한다.
  const [defaultBucketDayRows] = useTabComboQueries({
    filters: [
      {
        comboId: COMBO.DEFAULT_BUCKET_DAY,
        divisionId: searchParams.divisionId,
        bucketType: searchParams.bucketType,
      },
    ],
  });
  const defaultBucketDay =
    (defaultBucketDayRows?.[0] as { CODE?: string } | undefined)?.CODE ?? '';

  // 그리드 셀 콤보 바인드 파라미터(@divisionId/@mnuId) — 공용 DataGrid 가 콤보 SQL @키 치환에 쓴다.
  //   값은 인용 포함(working 예시 customer-fcst-upload GRID_COMBO_PARAMS 동형). 미전달 시 @divisionId
  //   콤보(FromSite/ToSite/ShipToCode)가 빈 결과가 된다(2026-10-20 실사고).
  const gridComboParams = useMemo(
    () => ({ divisionId: `'${searchParams.divisionId}'`, mnuId: `'${MENU_ID}'` }),
    [searchParams.divisionId]
  );
  // Condition(F6) 저장 제외 — 하단 2차 기간(fromYyyymmdd2/toYyyymmdd2)은 이 화면에서 저장하지 않는다
  //   (사용자 지시 2026-10-27). 공용 personalizeCondition 이 빈 값(paramCtn='')을 저장에서 거르므로
  //   두 키를 빈값으로 넘겨 제외한다(상단 기간 fromYyyymmdd/toYyyymmdd 는 공용 EXCLUDED_DATE_PARAM 로 이미 제외).
  const conditionSaveParam = useMemo(
    () => ({ ...searchParams, fromYyyymmdd2: '', toYyyymmdd2: '' }),
    [searchParams]
  );
  // 기간 기본값 적용 — 비어 있을 때만 채운다(사용자 입력·F6 복원값은 덮지 않는다). 과거의 1회 가드(ref)를
  //   제거해 F10(resetConditionOnClient) 으로 조회조건이 초기화돼 기간이 비워지면 다시 Plan 기본값으로
  //   되돌아오게 한다(2026-11-04 사용자 요청 — F10 직후 화면이 "fresh-open" 기본값으로 복귀). 빈값 가드가
  //   사용자/복원값 보존을 그대로 담보하므로 searchParams 변화로 재실행돼도 멱등하다(채워진 뒤엔 no-op).
  useEffect(() => {
    const row = planPeriod?.[0] as Record<string, string> | undefined;
    if (!row) return;
    const from = String(row.FROM_DATE ?? '').replace(/-/g, '');
    const to = String(row.TO_DATE ?? '').replace(/-/g, '');
    if (from.length !== 8 || to.length !== 8) return;
    if (!searchParams.fromYyyymmdd) setSearchParams({ fromYyyymmdd: from, toYyyymmdd: to });
    if (!searchParams.fromYyyymmdd2) setSearchParams({ fromYyyymmdd2: from, toYyyymmdd2: to });
  }, [planPeriod, searchParams, setSearchParams]);

  const { data: packData, refetch: refetchPack } = useTabProcQuery<MENU_ID, SHEETS.PACK>({
    menuId: MENU_ID,
    sheetName: SHEETS.PACK,
    tabId,
    filters,
    enabled: filters !== undefined && activeMainSheet === 'pack',
  });
  const { data: cellData, refetch: refetchCell } = useTabProcQuery<MENU_ID, SHEETS.CELL>({
    menuId: MENU_ID,
    sheetName: SHEETS.CELL,
    tabId,
    filters: cellFilters,
    enabled: cellFilters !== undefined && activeMainSheet === 'cell',
  });
  const { data: requestDetailData, refetch: refetchRequestDetail } = useTabProcQuery<
    MENU_ID,
    SHEETS.REQUEST_DETAIL
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.REQUEST_DETAIL,
    tabId,
    filters: requestDetailFilters,
    enabled: requestDetailFilters !== undefined && activeDetailSheet === 'requestDetail',
  });
  const { data: resultDetailData, refetch: refetchResultDetail } = useTabProcQuery<
    MENU_ID,
    SHEETS.RESULT_DETAIL
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.RESULT_DETAIL,
    tabId,
    filters: resultDetailFilters,
    enabled: resultDetailFilters !== undefined && activeDetailSheet === 'resultDetail',
  });
  // GET_SPREAD_TITLE(배포됨) — 동적 pivot 3단 병합 헤더(년월/주차/일) 라벨 소스(R17). 동적 부분은
  //   sheetName 무관 캘린더 기반이라 활성 시트 조건으로 1건만 조회해 Pack/Cell 두 그리드에 공용 전달한다.
  const { data: spreadTitleData } = useTabProcQuery<MENU_ID, SHEETS.SPREAD_TITLE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SPREAD_TITLE,
    tabId,
    filters: spreadTitleFilters,
    enabled: spreadTitleFilters !== undefined,
  });

  // Excel Form(양식 다운로드, design 01 R14 formDown, AS-IS FindData_Request_Detail_DownLoad cs:4353) —
  //   **메인 조회조건**(division/메인 Model·PlantSite·SalesSite)으로 GET_REQUEST_DETAIL_PACK_EXCEL_DOWN
  //   를 조회해 10컬럼 flat 양식을 채워 내려보낸다. 기간은 from=확정일(sConfirmDay=Pack NAME), to=메인
  //   Period To. PROC_M 키가 일반 detail(modelId/sesUserId/mnuId)과 달라(itemId/userId/programId/
  //   sheetName) 그대로 재사용하면 빈값→0행이라 실측 키로 맞춘다. 다중선택 ALL 은 '' 전송(AS-IS 동일).
  const excelFilters = useMemo<ProcRequest<MENU_ID, SHEETS.REQUEST_DETAIL_EXCEL>>(() => {
    const siteOrEmpty = (ids: string[]) => (ids.length === 0 ? '' : ids.join(','));
    return {
      divisionId: searchParams.divisionId,
      fromYyyymmdd: confirmDayPack || searchParams.fromYyyymmdd,
      toYyyymmdd: searchParams.toYyyymmdd,
      plantSiteId: siteOrEmpty(searchParams.plantSiteIds),
      scmSiteId: siteOrEmpty(searchParams.salesSiteIds),
      lotId: '',
      itemId: searchParams.modelId.toUpperCase(),
      nickName: searchParams.nickName2.toUpperCase(),
      userId: useSessionStore.getState().session.userId ?? '',
      requestorId: searchParams.requestor.toUpperCase(),
      programId: MENU_ID,
      sheetName: ADMIN_SHEET_NAME[SHEETS.REQUEST_DETAIL_EXCEL],
    };
  }, [searchParams, confirmDayPack]);
  const { refetch: refetchExcelForm } = useTabProcQuery<MENU_ID, SHEETS.REQUEST_DETAIL_EXCEL>({
    menuId: MENU_ID,
    sheetName: SHEETS.REQUEST_DETAIL_EXCEL,
    tabId,
    filters: excelFilters,
    enabled: false,
  });

  const packRows = useMemo(() => (packData as { o_rc1?: PackRow[] })?.o_rc1 ?? [], [packData]);
  const cellRows = useMemo(() => (cellData as { o_rc1?: CellRow[] })?.o_rc1 ?? [], [cellData]);
  // 참조 고정(useMemo) 필수 — spreadTitle prop 참조가 매 렌더 바뀌면 동적 헤더 columnGroups 재생성(깜빡임).
  const spreadTitleRows = useMemo<SpreadTitleRow[]>(
    () => (spreadTitleData as { o_rc1?: SpreadTitleRow[] })?.o_rc1 ?? [],
    [spreadTitleData]
  );
  const requestDetailRows = useMemo(
    () => (requestDetailData as { o_rc1?: RequestDetailRow[] })?.o_rc1 ?? [],
    [requestDetailData]
  );
  const resultDetailRows = useMemo(
    () => (resultDetailData as { o_rc1?: ResultDetailRow[] })?.o_rc1 ?? [],
    [resultDetailData]
  );
  // Measure 설정(btnMeasure) 반영 — 표시 measure 코드(null=전체)로 행(MEASURE) 필터. 그리드 표시·건수용이며
  //   저장 collect(handleSave)는 full packRows/cellRows 를 쓴다(숨긴 measure 행은 편집 불가라 변경분 없음).
  const packRowsShown = useMemo(() => {
    const vis = visibleMeasures[SHEETS.PACK];
    return vis
      ? packRows.filter(r => vis.includes(String((r as { MEASURE?: string | number }).MEASURE ?? '')))
      : packRows;
  }, [packRows, visibleMeasures]);
  const cellRowsShown = useMemo(() => {
    const vis = visibleMeasures[SHEETS.CELL];
    return vis
      ? cellRows.filter(r => vis.includes(String((r as { MEASURE?: string | number }).MEASURE ?? '')))
      : cellRows;
  }, [cellRows, visibleMeasures]);
  const activeRows = activeMainSheet === 'pack' ? packRowsShown : cellRowsShown;

  // 상단 Search/F5(entryPoints FindButton) — **현재 활성 상단 탭(Pack/Cell) 그리드만** 조회한다
  //   (design 02 §4.1/§8-5, SSP0015 동작 참고). 하단(Request/Result Detail)은 건드리지 않는다.
  //   setMainFilters 가 활성 시트 필터를 새로 세팅(쿼리키 변경 시 자동 재조회) + 동일 조건 재검색도
  //   즉시 재조회되게 활성 시트만 명시 refetch. 비활성 시트·하단은 자기 Search 전까지 조회 안 됨.
  const handleSearch = () => {
    setMainFilters();
    if (activeMainSheet === 'pack') void refetchPack();
    else void refetchCell();
  };

  // 조회 기간 검증(AS-IS DateUtil.Check_PeriodDate) — 미입력 / from>to / 최대기간(From+1캘린더년+7일) 초과.
  //   경계는 371일 고정이 아니라 연 가산 후 7일(윤년 보정, shipment-request-semi 선례). 메시지 {0}=371 라벨.
  const validatePeriod = (from: string, to: string): boolean => {
    if (!from || !to) {
      void setAlert({ type: 'alert', content: t(PERIOD_MSG.EMPTY, '_Please enter the search period.') });
      return false;
    }
    if (from > to) {
      void setAlert({ type: 'alert', content: t(PERIOD_MSG.ORDER, '_Invalid period (start > end).') });
      return false;
    }
    const toDay = (ymd: string) => dayjs(`${ymd.slice(0, 4)}-${ymd.slice(4, 6)}-${ymd.slice(6, 8)}`);
    const limit = toDay(from).add(1, 'year').add(7, 'day').format('YYYYMMDD');
    if (to >= limit) {
      void setAlert({
        type: 'alert',
        content: t(PERIOD_MSG.MAX, '_Maximum Period is From Date + {0}.').replace(
          '{0}',
          String(MAX_PERIOD_LABEL_DAYS)
        ),
      });
      return false;
    }
    return true;
  };

  // 하단 Search(btnSearch, design 02 §1-#14) — **현재 활성 하단 탭(Request/Result Detail) 그리드만**
  //   조회. 상단 그리드와 무관. AS-IS 는 Shipment Date(drpPeriod2) 를 Check_PeriodDate 로 선검증한다.
  const handleDetailSearch = () => {
    if (!validatePeriod(searchParams.fromYyyymmdd2, searchParams.toYyyymmdd2)) return;
    setDetailFilters();
    if (activeDetailSheet === 'resultDetail') void refetchResultDetail();
    else void refetchRequestDetail();
  };

  // 메인(Pack) 그리드 Measure/날짜 셀 더블클릭 → 하단 Request Detail 을 그 행 item/toSite(+날짜)로 재조회
  //   (AS-IS SpdMain_CellDoubleClick→FindData_Detail_DblClick). 필터 세팅으로 쿼리키가 바뀌면 react-query
  //   가 자동 재조회하므로 별도 refetch 를 부르지 않는다(부르면 call-proc 가 2번 나간다).
  const handleDrillDetail = (modelId: string, scmSiteId: string, date: string | null) => {
    drillDetailFromMain(modelId, scmSiteId, date);
  };

  // Request Detail MODEL_ID 셀 더블클릭 → Model 팝업. AS-IS SpdDetail_CellDoubleClick(cs:3372~)은
  //   신규행에서 From Site/To Site 가 모두 채워져야만 팝업을 연다(각각 MSG00098 "먼저 {0}을(를)
  //   선택하십시오"). 미설정이면 팝업을 막아 행 FROM_SITE 가 항상 팝업 조회조건(scmSiteId)으로 넘어가게 한다.
  //   MSG00098 은 TO-BE SCM_ADM_MSG_M 미존재(실측 0행) → 문구 동일 MSG01126 재매핑(convert-core §4.1, 자매 선례).
  const handleModelCellDblClick = (row: RequestDetailRow) => {
    const selectFirst = (term: string) =>
      setAlert({
        type: 'alert',
        content: t('MSG01126', '_First, select {0}.').replace('{0}', term),
      });
    if (!String(row.FROM_SITE ?? '').trim()) {
      void selectFirst(t('LBL00022', 'From Site'));
      return;
    }
    if (!String(row.TO_SITE ?? '').trim()) {
      void selectFirst(t('LBL00023', 'To Site'));
      return;
    }
    setModelCellRow(row);
  };

  // Cell Biz 메인 그리드 신규행 Model 셀 더블클릭 → Item 팝업(AS-IS SpdMain_CellDoubleClick Cell 분기
  //   cs:3848-3909). AS-IS 와 동일하게 From Site/To Site 가 모두 채워진 신규행에서만 열고(각각 MSG00098→
  //   문구 동일 MSG01126 재매핑), 선택 품번을 그 행 MODEL_ID 에 반영한다.
  const handleCellModelDblClick = (row: CellRow) => {
    const rec = row as unknown as Record<string, string | undefined>;
    const selectFirst = (term: string) =>
      setAlert({ type: 'alert', content: t('MSG01126', '_First, select {0}.').replace('{0}', term) });
    if (!String(rec.FROM_SITE ?? '').trim()) {
      void selectFirst(t('LBL00022', 'From Site'));
      return;
    }
    if (!String(rec.TO_SITE ?? '').trim()) {
      void selectFirst(t('LBL00023', 'To Site'));
      return;
    }
    setCellModelRow(row);
  };

  // Cell Biz 메인 그리드 신규행 Trans Mode 셀 더블클릭 → BOD 팝업(DMF0045 파리티). SCP0030 BOD 팝업은
  //   division/itemId 로 조회하므로 Model(MODEL_ID) 이 선행돼야 한다 — 미설정이면 MSG00098(→문구 동일
  //   MSG01126) 로 Model 선택을 먼저 유도한다(DMF0045 canOpenBodPopup 전제와 동형).
  const handleBodCellDblClick = (row: CellRow) => {
    const rec = row as unknown as Record<string, string | undefined>;
    if (!String(rec.MODEL_ID ?? '').trim()) {
      void setAlert({
        type: 'alert',
        content: t('MSG01126', '_First, select {0}.').replace('{0}', t('LBL00669', 'Model')),
      });
      return;
    }
    setBodPopupRow(row);
  };

  // AS-IS FindData_BOD(cs:4132) — TR_MODE/INCOTERMS 변경·Model 선택 시 행의 Div/From/To/Model 로
  //   P_SSP0026_GET_BOD_ITEM 를 조회해 BOD_ID 를 세팅하고, 매칭 BOD 가 없으면 공란으로 클리어한다
  //   (SP 는 Trans Mode/Incoterms 를 받지 않는다 — PROC_M 실측 키 divisionId/fromSiteId/toSiteId/itemId/bodId).
  //   BOD 가 없으면 저장 시 'X'(BOD 부적합)로 막히므로 조기에 BOD_ID 를 채워 사용자에게 반영한다.
  const refreshRowBod = async (row: RequestDetailRow) => {
    const record = row as unknown as Record<string, string | number | null | undefined>;
    const fromSiteId = String(record.FROM_SITE ?? '').trim();
    const toSiteId = String(record.TO_SITE ?? '').trim();
    const itemId = String(record.MODEL_ID ?? '').trim();
    if (!fromSiteId || !toSiteId || !itemId) return; // 전제값 미충족이면 조회 안 함(AS-IS 동일)
    try {
      const res = await apiClient.callProc(MENU_ID, SHEETS.BOD_ITEM, 'SEARCH', {
        divisionId: searchParams.divisionId,
        fromSiteId,
        toSiteId,
        itemId,
        bodId: '',
      });
      const rows = (res.result as { o_rc1?: { BOD_ID?: string | number }[] })?.o_rc1 ?? [];
      record.BOD_ID = String(rows[0]?.BOD_ID ?? '');
      gridRefRequest.current?.invalidate();
    } catch {
      /* 조회 실패 시 BOD_ID 는 건드리지 않는다 — 저장 SP 가 최종 검증 */
    }
  };

  // btnMeasure(design 01 R13) — spdMain(Pack/Cell) 활성일 때만 Measure 설정 팝업. spdDetail 활성이면
  //   조용히 no-op(AS-IS 그대로). 활성 그리드 미확정(null)이면 메인 기준으로 연다.
  const handleMeasure = () => {
    if (activeGrid === 'spdDetail') return;
    setOpenMeasure(true);
  };

  // btnExcelFormDownload(design 01 R14) — 현재 상세검색 조건으로 조회해 채운 엑셀 양식을 내려보낸다.
  const handleExcelFormDownload = async () => {
    const { data } = await refetchExcelForm();
    const rows = (data as { o_rc1?: Record<string, string | number>[] })?.o_rc1 ?? [];
    const columns = (staticColumns[SHEETS.REQUEST_DETAIL_EXCEL] ?? []).map(c => ({
      header: c.colLblNm ?? c.colNm,
      key: c.colNm,
    }));
    if (columns.length === 0) {
      await setAlert({ type: 'alert', content: t('MSG00618', '_An error occurred.') });
      return;
    }
    await GridAction.flatExcelDownload(rows, columns, 'SSP0026_Request_Detail');
  };

  // Excel Upload 적재(mode=1) — 검증(mode=0) 통과분 DB 반영(2-phase, 자매 SSP0023 onSave 동형).
  //   주의: SSP0026 UPLOAD_SAVE SP 는 미배포(설계 iter-5~6) — 배포 전까지 적재는 실패 알림만.
  const handleExcelUploadSave = async (): Promise<{ ok: boolean; message?: string }> => {
    try {
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/${ADMIN_SHEET_NAME[SHEETS.REQUEST_DETAIL_EXCEL]}/UPLOAD_SAVE/call-proc`,
        {
          mode: 1,
          createdBy: useSessionStore.getState().session.userId ?? '',
          programId: MENU_ID,
          sheetName: ADMIN_SHEET_NAME[SHEETS.REQUEST_DETAIL_EXCEL],
        }
      );
      const code = Number((res.data as { code?: string })?.code ?? 0);
      const inner = (res.data?.result as { o_result_cursor?: { CODE?: string; MSG?: string }[] })
        ?.o_result_cursor?.[0];
      if (res.status >= 400 || code || (inner && inner.CODE !== '0')) {
        return { ok: false, message: inner?.MSG || (res.data as { message?: string })?.message };
      }
      return { ok: true };
    } catch (e) {
      return { ok: false, message: e instanceof Error ? e.message : undefined };
    }
  };

  // SubTitle 커스텀 버튼 — MeasureSetting(btnMeasure) + Excel Form(formDown) + Excel Upload(btnExcelUpload).
  //   자매 SSP0023 customButtons 패턴과 동형. Excel Upload 적재(mode=1)는 SAVE SP 미배포로 배선만(동작은 배포 후).
  const customButtons = [
    {
      label: t(LBL.MEASURE, '_Measure'),
      title: t(LBL.MEASURE, '_Measure'),
      action: handleMeasure,
      iconComponent: <IcMeasureSelect />,
      buttonLabel: '',
    },
    // Excel Form/Upload — AS-IS SpdMain_ActiveSheetChanged(cs:3747/3777): Cell Biz 면 숨김
    //   (layoutControlItem12=formDown / 13=btnExcelUpload, Visibility=Never), Pack Biz 에서만 노출.
    ...(activeMainSheet === 'pack'
      ? [
          {
            label: t(LBL.EXCEL_FORM, '_Excel Form'),
            action: () => void handleExcelFormDownload(),
            iconComponent: <FileExceldownloadIcon />,
            iconPosition: 'leading' as const,
          },
          {
            label: t(LBL.EXCEL_UPLOAD, '_Excel Upload'),
            action: () => setOpenExcelUpload(true),
            iconComponent: <FileExceluploadIcon />,
            iconPosition: 'leading' as const,
          },
        ]
      : []),
  ];

  // R9/R10: Insert — spdMain Pack Biz 는 no-op(고위험 로직 미착수), Cell Biz/Request Detail만
  //   신규행 대상(design 01 R9/R10). 기본값 Division/Measure="SHIP_REQ"/ShipToCode="-"(goal.md ⑤-4).
  //   행/컬럼 단위 화이트리스트 unlock(INSERT_EDITABLE_COLUMNS_MAIN/REQUEST_DETAIL_EDIT_COLUMNS 셀 단위
  //   isCellEditable 예측자 배선)은 이번 회차 미완 — 04_react-gap.md 이월(그리드 전체 isEditMode 단위만 반영).
  const handleInsert = () => {
    const insertDefaults = {
      CRUD_TYPE: 'I',
      DIVISION_ID: searchParams.divisionId,
      MEASURE: MEASURE.SHIP_REQ,
      // 컬럼 바인딩은 SHIPTO_CODE(design 03 §1.3 #7) — AS-IS 신규행 ShipToCode 기본값 '-'(goal.md ⑤-4).
      //   필수('Ship to*') 셀이라 기본값이 실제 바인딩에 실려야 필수값 체크를 통과한다.
      SHIPTO_CODE: '-',
    };
    if (activeGrid === 'spdMain') {
      if (activeMainSheet === 'pack') return; // Pack Biz no-op(R9)
      const grid = gridRefCell.current;
      if (!grid) return;
      GridAction.addRow(grid, insertDefaults as unknown as Partial<CellRow>);
      return;
    }
    if (activeGrid === 'spdDetail' && activeDetailSheet === 'requestDetail') {
      const grid = gridRefRequest.current;
      if (!grid) return;
      GridAction.addRow(grid, insertDefaults as unknown as Partial<RequestDetailRow>);
    }
    // Result Detail은 항상 읽기전용이라 Insert 대상이 아니다(R8).
  };

  // R11: Delete — CRUD_TYPE=='I'(신규행)만 즉시 삭제, 기존행은 조용히 무반응(가드 메시지 없음,
  //   convert-core §2.4 그대로 일치. GridAction.removeRow(grid, true)의 deleteOnlyNew 가 기존행을
  //   그대로 건너뛰므로 Pack Biz(Insert no-op라 신규행 자체가 없음)에서 호출해도 부작용이 없다.
  const handleDelete = () => {
    if (activeGrid === 'spdMain') {
      if (activeMainSheet === 'pack') {
        if (gridRefPack.current) GridAction.removeRow(gridRefPack.current, true);
        return;
      }
      if (gridRefCell.current) GridAction.removeRow(gridRefCell.current, true);
      return;
    }
    if (activeGrid === 'spdDetail' && activeDetailSheet === 'requestDetail' && gridRefRequest.current) {
      GridAction.removeRow(gridRefRequest.current, true);
    }
  };

  // R12: Save — 활성 그리드(메인/상세)별 저장 API 분기(design 03 §4.2). PKG_SSP0026.
  //   SAVE_SHIP_REQ_PACK/_CELL/_DETAIL_PACK 3종은 배포·PL/SQL 본문 실측 완료(ora.py ALL_SOURCE,
  //   2026-09-26) — 결과코드 계약은 design 문서의 AS-IS S/N/X/Y 서술과 달리 실제 TO-BE 본문 기준
  //   'S'(성공)/'X'(BOD 부적합)/'F'(시스템 예외) + Detail Pack 전용 'Y'(확정구간 경고) 로 확정된다
  //   (shipment-request-pack.save.ts 상단 주석 참조). Detail Cell(SAVE_SHIP_REQ_DETAIL_CELL)은
  //   여전히 미배포라 자리표시 유지.
  //
  //   주의(04_react-gap.md 신규 발견, 2026-09-26): `SCM_ADM_PROC_M`에 SSP0026 전 프로시저(GET 포함)
  //   등록행이 0건이다(ora.py 실측) — call-proc 라우팅(`PKG_NSCM_UI_COMM.PR_GET_PROC_INFO_LIST`)이
  //   이 메타 없이는 파라미터 없는 빈 호출을 만들어 런타임에 실패한다. 이 등록은 convert-sp 소관
  //   (Hard Boundary, convert-core §2.2) — 이 회차는 FE 배선만 완비하고 PROC_M 등록은 손대지 않는다.
  const handleSaveError = async (error: unknown) => {
    const message = error instanceof Error ? error.message : String(error);
    await setAlert({ type: 'alert', content: message || t('MSG00003', '_Save error.') });
  };

  const interpretSaveResult = async (
    result: { o_rc1?: SaveResultRow[]; o_rc2?: SaveResultRow[] } | undefined,
    onSuccess: () => void
  ) => {
    const row = result?.o_rc1?.[0];
    const code = String(row?.RESULT_CODE ?? '');
    if (code === 'S') {
      setToast({ type: 'success', message: t('MSG00002', '_Saved successfully.') });
      onSuccess();
      return;
    }
    if (code === 'X') {
      // AS-IS MSG00293("Div, From Site, To Site 에 해당되는 BOD 정보가 유효하지 않습니다")은 TO-BE
      //   SCM_ADM_MSG_M 미등록('_' fallback) → 문구 동일 MSG01296 재매핑(convert-core §4.1 문구 역조회).
      await setAlert({
        type: 'alert',
        content: t('MSG01296', '_BOD (Trans mode, Incoterms) information corresponding to Div, From Site, To Site is invalid.'),
      });
      return;
    }
    if (code === 'Y') {
      // 확정(동결)구간 차단 — Shipment Date 가 SYSDATE+SHIP_FROZEN(확정일) 이전이면 저장 롤백(SP line 4071~4088,
      //   AS-IS ConfirmDayCheck). AS-IS MSG00323 은 TO-BE 에서 MSG01320("{0} 이전 출하일은 입력할 수 없습니다")
      //   으로 재매핑된다(사용자 확인 2026-10-21, SYS0001 메시지관리).
      const confirmDay = String(row?.CONFIRM_DAY ?? '');
      await setAlert({
        type: 'alert',
        content: t('MSG01320', '_Shipment date cannot be entered before {0}.').replace('{0}', confirmDay),
      });
      return;
    }
    const detail = String(result?.o_rc2?.[0]?.ERR_MESSAGE ?? '');
    await setAlert({ type: 'alert', content: detail || t('MSG00042', '_System error occurred.') });
  };

  // 메인(Pack/Cell) 저장 선검증(AS-IS SaveData cs:1581/1584/1637) — 필수값(V4)·중복입력(V5)·음수수량(V6).
  //   메시지 코드는 TO-BE SCM_ADM_MSG_M 실측 확정: 필수=MSG00429, 중복=MSG00043, 음수=MSG00699
  //   (AS-IS MSG00002/MSG00043/MSG00084 의 TO-BE 등가 — 2026-10-23 ora.py 문구 역조회). 통과=true.
  const validateMainSave = async (
    sheet: SHEETS.PACK | SHEETS.CELL,
    allRows: (PackRow | CellRow)[],
    changedRows: (PackRow | CellRow)[],
    changes: { qty: string }[]
  ): Promise<boolean> => {
    // V4 필수값 — admin 메타 라벨 '*' 컬럼(Request Detail 과 동일한 공통 파생)
    const missing = findFirstMissingRequired(changedRows, staticColumns[sheet] ?? []);
    if (missing) {
      await setAlert({
        type: 'alert',
        content: t('MSG00429', '_{0} value is required.').replace('{0}', `[${missing.label}]`),
      });
      return false;
    }
    // V5 중복입력 — 신규행이 기존/他신규행과 Div+From+Model+Incoterms+TrMode+To 까지 동일
    const dupKey = findDuplicateNewRowKey(allRows);
    if (dupKey) {
      await setAlert({
        type: 'alert',
        content: t('MSG00043', '_Duplicate error on save. {0}').replace('{0}', dupKey),
      });
      return false;
    }
    // V6 음수 수량 — Auto-Sync 가 W/M 음수는 하위 D 합계로 원복하므로 D 음수만 잔존(AS-IS nDayQty<0).
    //   표준상 셀 색칠 없이 알림만(validation-fail-alert-only).
    if (changes.some(c => Number(String(c.qty).replace(/,/g, '')) < 0)) {
      await setAlert({ type: 'alert', content: t('MSG00699', '_Please enter an integer greater than 0.') });
      return false;
    }
    return true;
  };

  const handleSave = async () => {
    const userId = useSessionStore.getState().session.userId ?? '';

    if (activeGrid === 'spdMain' && activeMainSheet === 'pack') {
      const tracker = editTrackerRefPack.current;
      if (!tracker) return;
      const changes = collectPivotChanges(packRows, tracker, searchParams.divisionId);
      if (changes.length === 0) {
        await setAlert({ type: 'alert', content: t('MSG00004', '_No changes to save.') });
        return;
      }
      const packOriginals = tracker.getOriginalValues();
      const packChangedRows = packRows.filter(r => r.CRUD_TYPE === 'I' || packOriginals.has(r));
      if (!(await validateMainSave(SHEETS.PACK, packRows, packChangedRows, changes))) return;
      try {
        const res = await apiClient.post<{ o_rc1?: SaveResultRow[]; o_rc2?: SaveResultRow[] }>(
          `/${MENU_ID}/pack/SAVE/call-proc`,
          buildSavePackPayload(changes, userId)
        );
        await interpretSaveResult(res.data?.result, () => {
          tracker.clearChanges();
          void refetchPack();
        });
      } catch (error) {
        await handleSaveError(error);
      }
      return;
    }

    if (activeGrid === 'spdMain' && activeMainSheet === 'cell') {
      const tracker = editTrackerRefCell.current;
      if (!tracker) return;
      const changes = collectPivotChanges(cellRows, tracker, searchParams.divisionId);
      if (changes.length === 0) {
        await setAlert({ type: 'alert', content: t('MSG00004', '_No changes to save.') });
        return;
      }
      const cellOriginals = tracker.getOriginalValues();
      const cellChangedRows = cellRows.filter(r => r.CRUD_TYPE === 'I' || cellOriginals.has(r));
      if (!(await validateMainSave(SHEETS.CELL, cellRows, cellChangedRows, changes))) return;
      try {
        const res = await apiClient.post<{ o_rc1?: SaveResultRow[]; o_rc2?: SaveResultRow[] }>(
          `/${MENU_ID}/cell/SAVE/call-proc`,
          buildSaveCellPayload(changes, userId)
        );
        await interpretSaveResult(res.data?.result, () => {
          tracker.clearChanges();
          void refetchCell();
        });
      } catch (error) {
        await handleSaveError(error);
      }
      return;
    }

    if (activeGrid === 'spdDetail' && activeDetailSheet === 'requestDetail') {
      const tracker = editTrackerRefRequest.current;
      if (!tracker) return;
      const changes = collectRequestDetailChanges(requestDetailRows, tracker, searchParams.divisionId);
      if (changes.length === 0) {
        await setAlert({ type: 'alert', content: t('MSG00004', '_No changes to save.') });
        return;
      }
      // 필수값 체크(AS-IS SaveData_Detail checkRequiredOfSpread, cs:1853) — SP 호출 전 차단. 저장 대상
      //   행(신규 'I' + 수정)의 필수 셀(admin 메타 라벨 '*')이 비면 첫 결손 필드로 MSG00429 알림 후 중단.
      const originals = tracker.getOriginalValues();
      const changedRows = requestDetailRows.filter(r => r.CRUD_TYPE === 'I' || originals.has(r));
      const missing = findFirstMissingRequired(
        changedRows,
        staticColumns[SHEETS.REQUEST_DETAIL] ?? []
      );
      if (missing) {
        await setAlert({
          type: 'alert',
          content: t('MSG00429', '_{0} value is required.').replace('{0}', `[${missing.label}]`),
        });
        return;
      }
      // V5 중복입력 체크(사용자 지시 2026-10-23 — 하단 Request Detail 에도 적용, AS-IS deviation). 신규행이
      //   기존/他신규행과 Div+From+To+ShipTo+Model+FcstType+ShipmentDate+TrMode+Incoterms 까지 동일하면 차단.
      //   그리드 전체 행 대상(신규행이 기존행과 겹치는 경우 포함) — Shipment Date 는 ymd8 정규화 후 비교.
      const dupDetailKey = findDuplicateNewRequestDetailKey(requestDetailRows);
      if (dupDetailKey) {
        await setAlert({
          type: 'alert',
          content: t('MSG00043', '_Duplicate error on save. {0}').replace('{0}', dupDetailKey),
        });
        return;
      }
      // V13 Shipment Date 형식검증(AS-IS SaveData_Detail cs:1901) — 값은 있으나 8자리 유효 날짜가
      //   아니면 차단. MSG01081 = AS-IS MSG00049 의 TO-BE 등가(문구 동일, 2026-10-23 ora.py 실측).
      const badDate = findInvalidShipmentDate(changedRows);
      if (badDate !== null) {
        await setAlert({
          type: 'alert',
          content: t('MSG01081', '_This is not a valid date format. {0}').replace('{0}', badDate),
        });
        return;
      }
      // V14 저장 전 확인(AS-IS SaveData_Detail cs:1942). AS-IS MSG00012 는 TO-BE 에서 "탭 10개 제한"
      //   으로 의미 반전이라, 동일 문구 MSG00001("Would you like to save it?")로 재매핑(2026-10-23 실측).
      const confirmed = await setAlert({ type: 'confirm', content: t('MSG00001', '_Would you like to save it?') });
      if (!confirmed) return;
      try {
        const res = await apiClient.post<{ o_rc1?: SaveResultRow[]; o_rc2?: SaveResultRow[] }>(
          `/${MENU_ID}/requestDetail/SAVE/call-proc`,
          buildSaveRequestDetailPayload(changes, userId)
        );
        await interpretSaveResult(res.data?.result, () => {
          tracker.clearChanges();
          void refetchRequestDetail();
        });
      } catch (error) {
        await handleSaveError(error);
      }
      return;
    }

    // Result Detail(읽기전용)·Cell Biz Request Detail(SAVE_SHIP_REQ_DETAIL_CELL 미배포) — 자리표시 유지.
    await setAlert({
      type: 'alert',
      content: 'SP not deployed yet — save execution deferred to convert-sp.',
    });
  };

  // item 3(공통버튼 하단 그리드 미작동) — 공통 툴바 Sort(F3)/Filter(F4) 와 키보드 단축키 가드는 SubTitle
  //   의 grid/gridFilter prop 을 대상으로 삼는데, 종전엔 메인(pack/cell)에 고정돼 하단 Request/Result
  //   Detail 에서 동작하지 않았다. 포커스된 그리드(activeGrid: onFocus/gotFocus 추적)로 grid/gridFilter 를
  //   메인↔하단으로 라우팅한다(SSP0201/0202/DMF0008 focusedSheet 패턴 동형). 건수(countGrid)·Excel 은
  //   메인에 고정해 포커스로 인한 회귀를 막는다(Insert/Delete/Save 는 아래 hotkeyConfig 가 activeGrid 로 분기).
  const mainGridRef = activeMainSheet === 'pack' ? gridRefPack : gridRefCell;
  const mainGridFilterRef = activeMainSheet === 'pack' ? gridFilterRefPack : gridFilterRefCell;
  const focusedGridRef = (
    activeGrid === 'spdDetail'
      ? activeDetailSheet === 'requestDetail'
        ? gridRefRequest
        : gridRefResult
      : mainGridRef
  ) as RefObject<FlexGrid | undefined>;
  const focusedGridFilterRef = (
    activeGrid === 'spdDetail'
      ? activeDetailSheet === 'requestDetail'
        ? gridFilterRefRequest
        : gridFilterRefResult
      : mainGridFilterRef
  ) as RefObject<FlexGridFilter | undefined>;

  // 편집계 버튼(Insert/Delete/Save)은 버튼권한 + 편집권한(canEdit) 둘 다 있어야 노출한다
  //   (convert-core §2.4 — 편집 기본 ON, 권한은 화면 오픈 시 1회).
  const hotkeyConfig: HotkeyConfig = {
    search: () => handleSearch(),
    insert: canEdit && hasButton('INSERT') ? handleInsert : (() => undefined),
    delete: canEdit && hasButton('DELETE') ? handleDelete : (() => undefined),
    save: canEdit && hasButton('SAVE') ? () => void handleSave() : (() => undefined),
    // Excel 다운로드는 포커스와 무관하게 항상 활성 메인 그리드(pack/cell)를 받는다 — grid prop 이 포커스로
    //   바뀌어 하단 그리드가 다운로드되는 회귀 방지(SSP0202 선례). 파일명은 SubTitle 기본과 동일.
    excel: () => {
      const g = mainGridRef.current as FlexGrid | undefined;
      if (g) void GridAction.excelDownload(g, 'Shipment Request Pack', useUIStore.getState().setProgress);
    },
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
      {isOpenSearchArea && <ShipmentRequestPackForm onSearch={handleSearch} />}
      <SubTitle
        menuId={MENU_ID}
        // item 3: Sort(F3)/Filter(F4)·키보드 가드를 포커스된 그리드(메인↔하단 Request/Result Detail)로 라우팅.
        grid={focusedGridRef}
        gridFilter={focusedGridFilterRef}
        // 건수 배지는 활성 메인 그리드에 고정(포커스가 하단으로 가도 메인 건수 유지).
        countGrid={mainGridRef as RefObject<FlexGrid | undefined>}
        dataCount={activeRows.length}
        excelFileName='Shipment Request Pack'
        useHotkey
        hotkeyConfig={hotkeyConfig}
        searchParam={conditionSaveParam}
        // F10(조회조건 초기화) 직후 화면 조회조건도 즉시 기본값으로 되돌린다(사용자 요청 2026-11-04).
        //   프레임워크 기본(false)은 서버 저장(개인화)분만 지우므로, 한 번 눌러 화면이 바로 초기화되도록
        //   opt-in 한다(자매 SSP0003/confirm 동일). staticColumns·visibleMeasures 는 MotherStore 가 보존.
        resetConditionOnClient
        customButtons={customButtons}
      />
      <PanelGroup className={styles.bodyPanelGroup} orientation='vertical'>
        <Panel defaultSize={40} minSize={20}>
          <div className={styles.gridArea}>
            <TabWrapper persist onTabClick={index => setActiveMainSheet(index === 0 ? 'pack' : 'cell')}>
            {[
            <TabItem key='pack' label={t('LBL_PACK_BIZ', 'Pack Biz')}>
              <ShipmentRequestPackMainGrid<PackRow>
                sheet={SHEETS.PACK}
                rows={packRowsShown}
                gridRef={gridRefPack}
                gridFilterRef={gridFilterRefPack}
                editTrackerRef={editTrackerRefPack}
                staticColumns={staticColumns[SHEETS.PACK]}
                measures={staticMeasures[SHEETS.PACK]}
                spreadTitle={spreadTitleRows}
                bucketType={searchParams.bucketType}
                isEditMode={canEdit}
                confirmDay={confirmDayPack}
                onDrillDetail={handleDrillDetail}
                onFocus={() => setActiveGrid('spdMain')}
              />
            </TabItem>,
            /* Cell Biz 탭 — PGM_AUTH_ID 게이트(canSeeCellBiz)가 참일 때만 노출(AS-IS AddSheet(shtCell) 조건) */
            ...(canSeeCellBiz
              ? [
              <TabItem key='cell' label={t('LBL_CELL_BIZ', 'Cell Biz')}>
                <ShipmentRequestPackMainGrid<CellRow>
                  sheet={SHEETS.CELL}
                  rows={cellRowsShown}
                  gridRef={gridRefCell}
                  gridFilterRef={gridFilterRefCell}
                  editTrackerRef={editTrackerRefCell}
                  staticColumns={staticColumns[SHEETS.CELL]}
                  measures={staticMeasures[SHEETS.CELL]}
                  spreadTitle={spreadTitleRows}
                  bucketType={searchParams.bucketType}
                  isEditMode={canEdit}
                  confirmDay={confirmDayCell}
                  comboParams={gridComboParams}
                  defaultBucketDay={defaultBucketDay}
                  onFocus={() => setActiveGrid('spdMain')}
                  onCellModelDblClick={handleCellModelDblClick}
                  onBodCellDblClick={handleBodCellDblClick}
                />
              </TabItem>,
                ]
              : []),
            ]}
            </TabWrapper>
          </div>
        </Panel>
        {/* Pack↔Cell 전환 시 하단영역 토글(design 01 R14, "collapse 가 아니라 조건부 렌더 권장").
            Cell Biz 활성 시 Separator/Panel 을 통째로 제거해 상단 메인 그리드가 100% 를 차지한다
            (빈 Panel 잔존 방지 — SalesSite 표준 동일). */}
        {activeMainSheet === 'pack' && <PanelSeparator />}
        {activeMainSheet === 'pack' && (
          <Panel defaultSize={60} minSize={20}>
            <div className={styles.gridArea}>
              <ShipmentRequestPackDetailSearch onSearch={handleDetailSearch} />
              <TabWrapper
                persist
                onTabClick={index =>
                  setActiveDetailSheet(index === 0 ? 'requestDetail' : 'resultDetail')
                }
              >
                <TabItem label={t('LBL_REQUEST_DETAIL', 'Shipment Request Detail')}>
                  <ShipmentRequestPackDetailGrid<RequestDetailRow>
                    sheet={SHEETS.REQUEST_DETAIL}
                    rows={requestDetailRows}
                    gridRef={gridRefRequest}
                    gridFilterRef={gridFilterRefRequest}
                    editTrackerRef={editTrackerRefRequest}
                    staticColumns={staticColumns[SHEETS.REQUEST_DETAIL]}
                    isEditMode={canEdit}
                    comboParams={gridComboParams}
                    onModelCellDblClick={handleModelCellDblClick}
                    onBodCellChange={row => void refreshRowBod(row)}
                    onFocus={() => setActiveGrid('spdDetail')}
                  />
                </TabItem>
                <TabItem label={t('LBL_RESULT_DETAIL', 'Shipment Result Detail')}>
                  <ShipmentRequestPackDetailGrid<ResultDetailRow>
                    sheet={SHEETS.RESULT_DETAIL}
                    rows={resultDetailRows}
                    gridRef={gridRefResult}
                    gridFilterRef={gridFilterRefResult}
                    staticColumns={staticColumns[SHEETS.RESULT_DETAIL]}
                    isEditMode={false}
                    onFocus={() => setActiveGrid('spdDetail')}
                  />
                </TabItem>
              </TabWrapper>
            </div>
          </Panel>
        )}
      </PanelGroup>

      {/* Measure 설정 팝업(btnMeasure, design 01 R13) — 활성 spdMain 시트(Pack/Cell)의 measure 표시 선택.
          OK 시 visibleMeasures 에 반영 → 그리드 행(MEASURE) 필터. 공용 MeasureSelectModal(SSP0023 동형). */}
      <MeasureSelectModal
        open={openMeasure}
        modalClose={() => setOpenMeasure(false)}
        measures={staticMeasures[activeSheetKey]}
        visibleMeasures={visibleMeasures[activeSheetKey]}
        onApply={codes => {
          applyVisibleMeasures(activeSheetKey, codes);
          setOpenMeasure(false);
        }}
      />

      {/* Excel Upload 팝업(btnExcelUpload, design 01 R14) — 검증(mode=0) → 적재(mode=1) 2-phase.
          업로드/검증 대상 SHEET_NAME = REQUEST_DETAIL_EXCEL(엑셀메타 키), 오류행 그리드 라벨은 admin 엑셀컬럼 파생.
          UPLOAD_SAVE SP 미배포(설계 iter-5~6)라 적재는 배포 후 실동작(현재는 실패 알림). */}
      <ExcelUploadModal
        open={openExcelUpload}
        modalClose={() => setOpenExcelUpload(false)}
        sheetName={ADMIN_SHEET_NAME[SHEETS.REQUEST_DETAIL_EXCEL]}
        headerLabels={(staticColumns[SHEETS.REQUEST_DETAIL_EXCEL] ?? []).map(c => c.colLblNm ?? c.colNm)}
        onSave={handleExcelUploadSave}
        onUploaded={() => {
          // AS-IS btnExcelUpload_Click(cs:4437) 업로드 후 재조회 — 하단을 Request Detail 탭으로 전환 +
          //   활성 메인 그리드 재조회(FindData) + 상세 그리드 재조회(FindData_Detail).
          setActiveDetailSheet('requestDetail');
          if (activeMainSheet === 'pack') void refetchPack();
          else void refetchCell();
          void refetchRequestDetail();
        }}
      />
      {/* Request Detail MODEL_ID 셀 더블클릭 → 검색조건과 동일한 Model 팝업(행 FROM_SITE 기준,
          AS-IS SSP0026_ItembyDivisionPopup). 선택 시 그 행 MODEL_ID 반영. */}
      <ModelByDivisionPopup
        open={!!modelCellRow}
        onClose={() => setModelCellRow(null)}
        onSelect={selected => {
          if (modelCellRow) {
            modelCellRow.MODEL_ID = selected.itemId;
            gridRefRequest.current?.invalidate();
            // Model 확정 후 BOD 재조회(AS-IS FindData_BOD) — 그 행의 From/To/Model 로 BOD_ID 세팅/클리어.
            void refreshRowBod(modelCellRow);
          }
          setModelCellRow(null);
        }}
        params={{
          divisionId: searchParams.divisionId,
          scmSiteId: modelCellRow?.FROM_SITE ?? '',
          projectCode: '',
          itemId: modelCellRow?.MODEL_ID ?? '',
        }}
      />
      {/* Cell Biz 메인 그리드 신규행 Model 셀 더블클릭 → Item 팝업(AS-IS SpdMain_CellDoubleClick Cell 분기,
          SSP0026_ItembyDivisionPopup). 행 FROM_SITE 기준 조회, 선택 품번을 그 행 MODEL_ID 에 반영. */}
      <ModelByDivisionPopup
        open={!!cellModelRow}
        onClose={() => setCellModelRow(null)}
        onSelect={selected => {
          if (cellModelRow) {
            // DMF0045 ITEM 모달셀 파리티 — 선택 품번으로 Model + Nick Name 2컬럼을 함께 채운다
            //   (ModelByDivisionPopup 은 nickName 을 반환한다, ShipmentRequestModals setSelectedValue 동형).
            const rec = cellModelRow as unknown as Record<string, unknown>;
            rec.MODEL_ID = selected.itemId;
            rec.NICK_NAME = selected.nickName ?? '';
            gridRefCell.current?.invalidate();
          }
          setCellModelRow(null);
        }}
        params={{
          divisionId: searchParams.divisionId,
          scmSiteId: (cellModelRow as unknown as { FROM_SITE?: string } | null)?.FROM_SITE ?? '',
          projectCode: '',
          itemId: (cellModelRow as unknown as { MODEL_ID?: string } | null)?.MODEL_ID ?? '',
        }}
      />
      {/* Cell Biz 메인 그리드 신규행 Trans Mode 셀 더블클릭 → BOD 팝업(DMF0045 파리티, SCP0030 백엔드).
          선택(단건/다건 첫 건) 시 그 행 From/To/Incoterms/TrMode/BOD_ID 를 일괄 세팅한다. */}
      <BodItemRouteModal
        open={!!bodPopupRow}
        modalClose={() => setBodPopupRow(null)}
        preSearchParams={{
          divisionId: searchParams.divisionId,
          itemId: (bodPopupRow as unknown as { MODEL_ID?: string } | null)?.MODEL_ID ?? '',
        }}
        setSelectedValue={(selected: BodItemReturn[]) => {
          const pick = selected[0];
          if (bodPopupRow && pick) {
            const rec = bodPopupRow as unknown as Record<string, unknown>;
            rec.FROM_SITE = pick.c_FROM_SITE;
            rec.TO_SITE = pick.c_TO_SITE;
            rec.INCOTERMS = pick.c_INCOTERMS;
            rec.TR_MODE = pick.c_TRANSPORT_MODE;
            rec.BOD_ID = pick.c_BOD_ID;
            gridRefCell.current?.invalidate();
          }
          setBodPopupRow(null);
        }}
      />
    </>
  );
};
