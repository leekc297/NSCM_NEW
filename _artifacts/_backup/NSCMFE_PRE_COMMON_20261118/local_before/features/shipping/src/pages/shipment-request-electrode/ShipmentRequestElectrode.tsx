import { FileExceluploadIcon } from '@lges/design-system/icon';
import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal, MeasureSelectModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { IcMeasureSelect } from '@foundation/assets';
import { CRUD_MSG } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useMutation, useQuery } from '@foundation/query-client';
import { GridAction, type EditTracker } from '@foundation/utils';
import { MainTitle, SsoUserModal, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { FileExceldownloadIcon } from '@shared/lges-icons';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ExcelUploadModal } from './components/ExcelUploadModal';
import { BodItemModal, type BodItemSelection } from './components/modals/BodItemModal';
import { ShipmentRequestInsertModal } from './components/modals/ShipmentRequestInsertModal';
import { ShipmentRequestElectrodeDetailBar } from './components/ShipmentRequestElectrodeDetailBar';
import { ShipmentRequestElectrodeDetailGrid } from './components/ShipmentRequestElectrodeDetailGrid';
import { ShipmentRequestElectrodeForm } from './components/ShipmentRequestElectrodeForm';
import { ShipmentRequestElectrodeMainGrid } from './components/ShipmentRequestElectrodeMainGrid';
import { ShipmentRequestElectrodeStockGrid } from './components/ShipmentRequestElectrodeStockGrid';
import {
  ADMIN_SHEET_NAME,
  LBL,
  MENU_ID,
  MSG,
  SHEETS,
  STANDARD_MANUAL_URL,
  USER_CHECK_BTN,
} from './shipment-request-electrode.constants';
import type {
  RequestDetailRow,
  ShipmentPsiRow,
  StockDetailRow,
} from './shipment-request-electrode.types';
import styles from './ShipmentRequestElectrode.module.scss';
import { useShipmentRequestElectrodeStore } from './useShipmentRequestElectrodeStore';
import {
  buildNewRow,
  checkPeriodRange,
  collectChangedRows,
  findConfirmDayViolation,
  findInvalidShipmentDate,
  firstMissingPrerequisite,
  hasDuplicate,
  MAX_PERIOD_LABEL_DAYS,
  type PeriodError,
  type SaveRow,
  type SaveResult,
  str,
  submitMainSave,
  submitShipmentRequestSave,
} from './utils/shipment-request-electrode.save';
import type { SpreadTitleRow } from './utils/shipment-request-electrode.spreadHeader';

// SSP0022 Shipment Request(Electrode) — AS-IS SSP0022_ShipmentRequestElectrode 1:1 골격 전환.
//   조회 = PKG_SSP0022.P_SSP0022_GET_SHIPMENT_PSI / GET_REQUEST_DETAIL / GET_STOCK_DETAIL.
//   저장 = PKG_SSP0022.P_SSP0022_SAVE_SHIPMENT_REQUEST(spdMain/spdDetail 공용, 컨텍스트로 분기).
//
// 정직 보고(convert-core §4.3): PKG_SSP0022/PKG_DM0003/PKG_SSP0002 전부 TO-BE 미배포(all_objects
// 0건, 2026-09-26 ora.py 실측) — 이 화면의 조회/저장/Edit 권한체크/Bucket 콤보는 FE 배선만
// 완비되고 런타임 실행체인은 미완이다(convert-sp 후속). 아래 handleSave/handleEdit 등은 SP 응답
// 형상을 검증하지 못한 상태로 design 02/03 문서의 소비부 역산치를 그대로 반영했다.
export const ShipmentRequestElectrode = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const { setAlert, setToast } = useMessageStore();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const { saveWithValidation } = useSaveWithValidation();
  const session = useSessionStore(state => state.session);
  // 편집 가부 = SAVE 권한축(convert-core §2.4 — TO-BE 는 Edit 모드 토글 없이 권한으로만 편집을 연다.
  //   이 화면엔 EDIT 버튼이 없어 SAVE 권한으로 가른다). AS-IS EditButton 의 GetSSPUserCheck(MSG00251)는
  //   TO-BE 버튼권한 모델로 대체되고, Stock Detail 읽기전용(MSG00109)은 isStockDetailCellEditable=false 로 상시 적용.
  const canEdit = hasButton('SAVE');

  // bRealFlag(AS-IS cs:3743-3750) — 최신 Plan Date(index0) 선택 여부. Form PlanDate 핸들러가 세팅.
  const realFlag = useShipmentRequestElectrodeStore(state => state.realFlag);

  // GetSSPUserCheck(AS-IS EditButton 가드①, cs:1482-1489) — SSP0002_GET_USER_INFO_LIST 로 SSP 등록 사용자 확인.
  //   o_rc1 0행 or 403(USER_CHECK 권한 없음) 이면 비SSP → 편집 차단(MSG01261). 체크 전(undefined)엔 낙관적 허용.
  //   백엔드 실측(2026-11-04): PKG_SSP0002 proc·공용 API P_SSP0200_USER_CHECK 는 배포돼 있고, SSP0022 에만
  //   USER_CHECK 버튼+그룹권한 2행이 미등록이라 현재 403 → isSspUser=false. 그 메타 2행 등록 시 자동 동작(자매 SSP0021 동형).
  const { data: sspUserCheck } = useQuery({
    queryKey: [tabId, 'sspUserCheck', session.userId],
    queryFn: async () => {
      try {
        const res = await apiClient.post<{ o_rc1?: unknown[] }>(
          `/${MENU_ID}/${SHEETS.MAIN}/${USER_CHECK_BTN}/call-proc`,
          { userId: session.userId ?? '', language: session.langCd ?? '', ssoUserYn: 'N' }
        );
        if (res.status >= 400 || Number(res.data?.code)) return false;
        const rows = res.data?.result?.o_rc1 ?? [];
        return rows.length > 0;
      } catch {
        return false;
      }
    },
    enabled: !!session.userId,
    staleTime: Infinity,
  });
  const isSspUser = sspUserCheck !== false;

  // 메인 pivot 편집 전역 게이트 — 편집계 권한(canEdit=SAVE) · 최신 Plan(realFlag) · SSP 등록(isSspUser).
  //   AS-IS EditButton 모드토글은 미이식(convert-core §2.4) — 진입 즉시 이 조건이면 편집 가능. 셀 범위는 editLock.
  const mainEditable = canEdit && realFlag && isSspUser;
  // 하단 요청상세 편집 게이트 — 상단과 동일 축. AS-IS EditButton 은 GetSSPUserCheck(cs:1482, fps 분기 前 공통)와
  //   bRealFlag(cs:1672, spdDetail 분기)를 요청상세 편집에도 적용한다. 재고상세 읽기전용은 editLock 이 상시 처리.
  const detailEditable = canEdit && realFlag && isSspUser;

  const gridRefMain = useRef<FlexGrid<ShipmentPsiRow>>();
  const gridFilterRefMain = useRef<FlexGridFilter>();
  const editTrackerRefMain = useRef<EditTracker<ShipmentPsiRow>>();
  const gridRefRequest = useRef<FlexGrid<RequestDetailRow>>();
  const gridFilterRefRequest = useRef<FlexGridFilter>();
  const editTrackerRefRequest = useRef<EditTracker<RequestDetailRow>>();
  const gridRefStock = useRef<FlexGrid<StockDetailRow>>();
  const gridFilterRefStock = useRef<FlexGridFilter>();

  const searchParams = useShipmentRequestElectrodeStore(state => state.searchParams);
  const restoreSearchConditions = useShipmentRequestElectrodeStore(
    state => state.restoreSearchConditions
  );
  const filters = useShipmentRequestElectrodeStore(state => state.filters);
  const requestDetailFilters = useShipmentRequestElectrodeStore(state => state.requestDetailFilters);
  const stockDetailFilters = useShipmentRequestElectrodeStore(state => state.stockDetailFilters);
  const spreadTitleFilters = useShipmentRequestElectrodeStore(state => state.spreadTitleFilters);
  const isOpenSearchArea = useShipmentRequestElectrodeStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useShipmentRequestElectrodeStore(state => state.setOpenSearchArea);
  const setFilters = useShipmentRequestElectrodeStore(state => state.setFilters);
  const setDetailFilters = useShipmentRequestElectrodeStore(state => state.setDetailFilters);
  const clearFilters = useShipmentRequestElectrodeStore(state => state.clearFilters);
  const bohMode = useShipmentRequestElectrodeStore(state => state.bohMode);
  const staticColumns = useShipmentRequestElectrodeStore(state => state.staticColumns);
  const fetchStaticColumns = useShipmentRequestElectrodeStore(state => state.fetchStaticColumns);
  const fetchStaticMeasures = useShipmentRequestElectrodeStore(state => state.fetchStaticMeasures);
  const activeDetailTab = useShipmentRequestElectrodeStore(state => state.activeDetailTab);
  const setActiveDetailTab = useShipmentRequestElectrodeStore(state => state.setActiveDetailTab);
  const setActiveGrid = useShipmentRequestElectrodeStore(state => state.setActiveGrid);
  const setSearchParams = useShipmentRequestElectrodeStore(state => state.setSearchParams);
  const activeGrid = useShipmentRequestElectrodeStore(state => state.activeGrid);
  const staticMeasures = useShipmentRequestElectrodeStore(state => state.staticMeasures);
  const visibleMeasures = useShipmentRequestElectrodeStore(state => state.visibleMeasures);
  const applyVisibleMeasures = useShipmentRequestElectrodeStore(state => state.applyVisibleMeasures);

  // 조회조건 검색 모달 — 공용 MaterialByDivisionModal(COM0013, SSP0023 동일). 상단 Material/Model·Nickname,
  //   하단 2차 Material. Division 단일이라 multiDivision 불요. 빈 반환 시 기존값 유지.
  const [openItem, setOpenItem] = useState(false);
  const [openModel, setOpenModel] = useState(false);
  const [openDetailItem, setOpenDetailItem] = useState(false);
  const [openDetailModel, setOpenDetailModel] = useState(false);
  // Requestor 팝업(btnRequestor, 요청상세 탭 전용) — 공용 SsoUserModal(AS-IS UserInfoPopup).
  const [openRequestor, setOpenRequestor] = useState(false);
  // Measure 설정(btnMeasure) / Excel Upload(btnExcelUpload) 팝업 열림 상태.
  const [openMeasure, setOpenMeasure] = useState(false);
  const [openExcelUpload, setOpenExcelUpload] = useState(false);
  // ETA 요청 입력 팝업(메인 pivot R_SHIP_REQ_ETA 셀 더블클릭, AS-IS SSP0022_ShipmentRequestPopup).
  const [openRequestInsert, setOpenRequestInsert] = useState(false);
  const [requestInsertRow, setRequestInsertRow] = useState<ShipmentPsiRow | null>(null);
  // 요청상세 ITEM_ID 더블클릭 → BOD/Item 선택 팝업(AS-IS SSP0022_BodItemPopup). 선택 행으로 ITEM_ID~CONFIRM_DAY 채움.
  const [openBodItem, setOpenBodItem] = useState(false);
  const [bodItemRow, setBodItemRow] = useState<RequestDetailRow | null>(null);

  // mount — SubTitle F6 저장 조회조건 복원(1회, conditionsRestored 가드).
  useEffect(() => {
    void restoreSearchConditions();
  }, [restoreSearchConditions]);

  // Division/Company 변경 = 그리드 초기화 의무(nscm-patterns.md §5-5).
  const prevKeyRef = useRef(`${searchParams.divisionId}:${searchParams.companyId}`);
  useEffect(() => {
    const key = `${searchParams.divisionId}:${searchParams.companyId}`;
    if (prevKeyRef.current === key) return;
    prevKeyRef.current = key;
    editTrackerRefRequest.current?.clearChanges();
    clearFilters();
  }, [searchParams.divisionId, searchParams.companyId, clearFilters]);

  useEffect(() => {
    fetchStaticColumns();
    fetchStaticMeasures();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [searchParams.divisionId]);

  const { data: mainData, refetch: refetchMain } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters,
    enabled: filters !== undefined,
  });
  const { data: requestDetailData, refetch: refetchRequestDetail } = useTabProcQuery<
    MENU_ID,
    SHEETS.REQUEST_DETAIL
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.REQUEST_DETAIL,
    tabId,
    filters: requestDetailFilters,
    enabled: requestDetailFilters !== undefined,
  });
  const { data: stockDetailData, refetch: refetchStockDetail } = useTabProcQuery<
    MENU_ID,
    SHEETS.STOCK_DETAIL
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.STOCK_DETAIL,
    tabId,
    filters: stockDetailFilters,
    enabled: stockDetailFilters !== undefined,
  });
  // GET_SHEET_CALENDAR_3SPAN(배포됨) — 상단 pivot 3단 병합 헤더(년월/주차/일) 라벨 소스. 기간(fromYyyymmdd/
  //   toYyyymmdd) 기반이라 sheetName/BOH축 무관 1건을 조회해 MainGrid 에 전달한다(자매 SSP0026 동일).
  const { data: spreadTitleData } = useTabProcQuery<MENU_ID, SHEETS.SPREAD_TITLE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SPREAD_TITLE,
    tabId,
    filters: spreadTitleFilters,
    enabled: spreadTitleFilters !== undefined,
  });

  const mainRows = useMemo(() => (mainData as { o_rc1?: ShipmentPsiRow[] })?.o_rc1 ?? [], [mainData]);
  // Measure 설정(btnMeasure) 반영 — 표시 measure 코드(null=전체)로 메인 행(MEASURE) 필터. 그리드 표시·건수용.
  const mainRowsShown = useMemo(() => {
    const vis = visibleMeasures;
    return vis
      ? mainRows.filter(r => vis.includes(String((r as { MEASURE?: string | number }).MEASURE ?? '')))
      : mainRows;
  }, [mainRows, visibleMeasures]);

  // Excel Form(양식 다운로드, AS-IS FindData_Request_Detail_DownLoad) — 현재 조회조건으로
  //   P_SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN(배포됨, 21 IN) 조회 → REQUEST_DETAIL_EXCEL(9컬럼) 양식 다운.
  //   파라미터 매핑은 메인 setFilters 관례 동일(joinComma/yn/nonChk/realFlag='Y'). lotId/requestorId 는 2차 조건.
  const excelFilters = useMemo<ProcRequest<MENU_ID, SHEETS.REQUEST_DETAIL_EXCEL>>(() => {
    const sp = searchParams;
    const joinComma = (a: string[]) => (a.length === 0 ? 'ALL' : a.join(','));
    const yn = (b: boolean) => (b ? 'Y' : 'N');
    const nonChk =
      !sp.myModelChk && !sp.partLeaderChk && !sp.teamLeaderChk && !sp.delegateModelChk ? 'Y' : 'N';
    return {
      divisionId: sp.divisionId,
      companyId: sp.companyId,
      planStartYyyymmdd: sp.planDate,
      fromYyyymmdd: sp.fromYyyymmdd,
      toYyyymmdd: sp.toYyyymmdd,
      plantId: joinComma(sp.plantSiteIds),
      cellType: joinComma(sp.cellTypes),
      lotId: sp.lotId,
      itemId: sp.itemId,
      modelId: sp.modelId,
      nickName: sp.nickName,
      sesUserId: session.userId ?? '',
      requestorId: sp.requestor,
      mnuId: MENU_ID,
      sheetName: ADMIN_SHEET_NAME[SHEETS.REQUEST_DETAIL_EXCEL] ?? '',
      realFlag: 'Y',
      nonChk,
      myModelChk: yn(sp.myModelChk),
      delegateChk: yn(sp.delegateModelChk),
      partLeaderChk: yn(sp.partLeaderChk),
      teamLeaderChk: yn(sp.teamLeaderChk),
    };
  }, [searchParams, session.userId]);
  const { refetch: refetchExcelForm } = useTabProcQuery<MENU_ID, SHEETS.REQUEST_DETAIL_EXCEL>({
    menuId: MENU_ID,
    sheetName: SHEETS.REQUEST_DETAIL_EXCEL,
    tabId,
    filters: excelFilters,
    enabled: false,
  });
  // 참조 고정(useMemo) 필수 — spreadTitle prop 참조가 매 렌더 바뀌면 동적 헤더 columnGroups 재생성(깜빡임).
  const spreadTitleRows = useMemo<SpreadTitleRow[]>(
    () => (spreadTitleData as { o_rc1?: SpreadTitleRow[] })?.o_rc1 ?? [],
    [spreadTitleData]
  );
  const requestDetailRows = useMemo(
    () => (requestDetailData as { o_rc1?: RequestDetailRow[] })?.o_rc1 ?? [],
    [requestDetailData]
  );
  const stockDetailRows = useMemo(
    () => (stockDetailData as { o_rc1?: StockDetailRow[] })?.o_rc1 ?? [],
    [stockDetailData]
  );

  // Condition(F6) 저장 제외 — 하단 2차 기간(fromYyyymmdd2/toYyyymmdd2)은 이 화면에서 저장하지 않는다
  //   (사용자 지시 2026-10-27, SSP0026 동일). 공용 personalizeCondition 이 빈 값(paramCtn='')을 저장에서
  //   거르므로 두 키를 빈값으로 넘겨 제외한다(상단 기간 fromYyyymmdd/toYyyymmdd 는 공용 EXCLUDED_DATE_PARAM 로 이미 제외).
  const conditionSaveParam = useMemo(
    () => ({ ...searchParams, fromYyyymmdd2: '', toYyyymmdd2: '' }),
    [searchParams]
  );

  // 신규행 FROM_SITE/TO_SITE 셀콤보 필터(@segment5=division, @segment4=company) — AS-IS InsertRow 가 clbDivision/
  //   clbCompany 로 PlantByElectordeShipFromSite/ToSite 를 조회한 것 등가(cs:1454-1455). 신규행 DIVISION_ID=
  //   buildNewRow(searchParams.divisionId)와 정합. 참조 고정(useMemo)으로 DataGrid 콤보 재조회 깜빡임 방지.
  const detailComboParams = useMemo(
    () => ({ segment5: searchParams.divisionId, segment4: searchParams.companyId }),
    [searchParams.divisionId, searchParams.companyId]
  );

  // R1: Find 버튼(상단 툴바/SearchArea) — AS-IS FindButton()→FindData_Main() 과 동일하게 상단 메인
  //   pivot(+spreadTitle 헤더)만 재조회한다. 상세(요청/재고)는 하단 2차 Search(handleDetailSearch)·엑셀
  //   업로드 경로에서만 조회한다(상단 Find 로 하단까지 딸려 조회되던 AS-IS 이탈 교정 2026-11-03, 자매 SSP0023 동일).
  const handleSearch = () => {
    const isSame = setFilters();
    if (isSame) void refetchMain();
  };

  // 하단 2차 Search 버튼(btnSearch) — AS-IS BtnSearch_Click(cs:3785-3803)은 활성 상세 시트만 재조회한다
  //   (ActiveSheetIndex 0=Stock→FindData_Detail / 1=Request→FindData_Request_Detail). 상단 main 그리드는
  //   건드리지 않는다(refetchMain 금지 — 하단 검색이 상단을 재조회하던 오동작 교정, 2026-10-26).
  // 기간 범위 오류 안내(AS-IS DateUtil.Check_PeriodDate) — 공백/역순/상한초과를 등가 MSG 로 띄운다.
  const alertPeriodError = (err: PeriodError) => {
    const content =
      err === 'EMPTY'
        ? t(MSG.PERIOD_EMPTY, 'Please enter the search period.')
        : err === 'ORDER'
          ? t(MSG.PERIOD_ORDER, 'Invalid period (start > end).')
          : t(MSG.PERIOD_MAX, 'Maximum Period is From Date + {0}.').replace(
              '{0}',
              String(MAX_PERIOD_LABEL_DAYS)
            );
    void setAlert({ type: 'alert', content });
  };

  const handleDetailSearch = () => {
    // Shipment ETA(2차, drpPeriod2) 기간 범위 검증 — AS-IS Check_PeriodDate(cs:2251, FindData_Request_Detail).
    //   요청상세 탭만 기간축을 쓴다(재고상세는 Lot ID 기반이라 대상 아님). 상한 = From + 1년 + 7일(윤년 보정).
    if (activeDetailTab === 'requestDetail') {
      const periodErr = checkPeriodRange(searchParams.fromYyyymmdd2, searchParams.toYyyymmdd2);
      if (periodErr) {
        alertPeriodError(periodErr);
        return;
      }
    }
    // 활성 상세 탭의 filter 만 재구성한다(setDetailFilters(activeDetailTab)) → 상단 main·spreadTitle 과 비활성
    //   상세 탭의 filters 참조가 불변이라 그 그리드들은 재조회되지 않는다. 활성 상세만 재조회(내용 불변이면 수동
    //   refetch, 변경이면 참조 변경으로 자동).
    const { sameReq, sameStock } = setDetailFilters(activeDetailTab);
    if (activeDetailTab === 'requestDetail') {
      if (sameReq) void refetchRequestDetail();
    } else if (sameStock) {
      void refetchStockDetail();
    }
  };

  // R6: Insert — 요청상세 탭 + 편집게이트(detailEditable) 가드, 미충족 시 조용히 무시(AS-IS InsertRow 선행가드 cs:1449 등가).
  //   신규행 DIVISION_ID 자동세팅(buildNewRow, EDIT_FLAG 는 설정 안 함 — addRowSet 차단 회피), CRUD_TYPE='I' 는
  //   GridAction.addRow 가 부여하고 5컬럼 lock(INSERT_LOCK_COLUMNS)은 editLock 이 isNewRow 로 처리한다(design 01 R6 / 03 §3 규칙#8).
  //   한계(04 후속): FROM_SITE/TO_SITE 런타임 셀콤보 주입·ITEM_ID BOD 팝업 조회는 미배선(아래 C1~C4 선행 가드만 반영).
  const handleInsert = () => {
    if (!detailEditable || activeDetailTab !== 'requestDetail') return;
    const grid = gridRefRequest.current;
    if (!grid) return;
    // 공용 addRow 의 "전 행 EDIT_FLAG='N' → 추가 차단" 가드를 건너뛴다(skipEditFlagGuard). 이 화면의 요청상세는
    //   조회 데이터가 전부 EDIT_FLAG='N'(신규 미확정)로 내려올 수 있는데(2026-11-04 네트워크 실측), AS-IS InsertRow
    //   (cs:1447-1472)에는 그런 가드가 없어 항상 삽입된다. addRow 대신 addRowSet 을 직접 호출해 플래그를 넘긴다.
    GridAction.addRowSet(grid, [buildNewRow(searchParams.divisionId) as never], 'above', {
      preserveMergeManager: true,
      skipEditFlagGuard: true,
    });
  };

  // R7: Delete — AS-IS DeleteButton() 은 빈 override(기능 없음, cs:1476-1478). 기능 없는 버튼은 노출하지 않는
  //   원칙(auth-button.md AUTH-03/04)에 따라 admin 버튼메타에서 main/DELETE 등록을 제거(05_register.sql +
  //   07_remove_delete_button.sql)하고, 노출은 hasButton 으로만 제어한다 — 미등록이면 hasButton('DELETE')=false 라
  //   SubTitle 이 Delete 버튼을 렌더하지 않는다(design 01 R7 의 "inert 버튼 상시 노출"에서 2026-11-05 변경).
  const handleDelete = () => undefined;

  // C1~C4: ITEM_ID 셀 팝업 선행필수(design 01 §2 / 03 §1.2, AS-IS cs:1015~1042). From Site→To Site→Incoterms→
  //   Trans Mode 순으로 첫 번째 빈 칸을 "First, select {0}"(MSG01126 — AS-IS MSG00098 미등록 등가)로 차단한다.
  //   선행값 충족 시 BOD/Item 팝업 조회로 이어가야 하나(04 후속), 선행필수 validation 은 우선 반영한다.
  const handleItemCellDoubleClick = (row: RequestDetailRow) => {
    if (!detailEditable) return;
    // AS-IS SpdDetail_CellDoubleClick(cs:1046)은 action=='I'(신규행)에서만 BOD/Item 팝업을 연다.
    if (str(row.CRUD_TYPE) !== 'I') return;
    // C1~C4 선행필수(From Site→To Site→Incoterms→Trans Mode) — 미충족 시 "First, select {0}" 후 차단(cs:1015-1042).
    const missing = firstMissingPrerequisite(row as SaveRow);
    if (missing) {
      const label = gridRefRequest.current?.getColumn(missing)?.header ?? missing;
      void setAlert({
        type: 'alert',
        content: t(MSG.PREREQUISITE, 'First, select {0}.').replace('{0}', label),
      });
      return;
    }
    // 선행 충족 → BOD/Item 선택 팝업(SSP0022_BodItemPopup).
    setBodItemRow(row);
    setOpenBodItem(true);
  };

  // BOD/Item 팝업 선택 확정 — AS-IS cs:1063-1068(ITEM_ID/MODEL_ID SetValue) + FindData_BOD(INCOTERMS/TRANSPORT/BOD_ID/
  //   CONFIRM_DAY). 전용 BodItemModal 이 GET_ITEM_POPUP(route 조회) 행으로 6칸을 모두 담아 돌려주므로 선택 1회로 채운다.
  //   값은 행 객체에 직접 써 setCellData coerce 경로를 피하고 invalidate(신규행 CRUD='I' 라 EditTracker/저장이 그대로 수집).
  const handleBodItemSelected = (picked: BodItemSelection) => {
    const r = bodItemRow as Record<string, unknown> | null;
    if (!r) return;
    r.ITEM_ID = picked.ITEM_ID;
    r.MODEL_ID = picked.MODEL_ID;
    r.INCOTERMS = picked.INCOTERMS;
    r.TRANSPORT_MODE = picked.TRANSPORT_MODE;
    r.BOD_ID = picked.BOD_ID;
    r.CONFIRM_DAY = picked.CONFIRM_DAY;
    gridRefRequest.current?.invalidate();
  };

  // 메인 pivot Shipment Request ETA(R_SHIP_REQ_ETA) 셀 더블클릭 → ETA 요청 입력 팝업(AS-IS SpdMain_CellDoubleClick
  //   → ShipmentRequestPopup). measure 행 가드는 MainGrid 가 적용하고, 여기서 AS-IS bRealFlag + 편집권한 가드를 건다.
  //   bRealFlag(실시간 Plan Date) 는 이 화면의 realFlag 가 현재 'Y' 고정(store setFilters)이라 canEdit 로만 가른다
  //   — 과거 Plan Date 미실시간 판정(MSG00312)은 realFlag 배선과 함께 후속(화면 공통 미완, 범위 밖).
  const handleMainCellDoubleClick = (row: ShipmentPsiRow) => {
    if (!canEdit) return;
    // AS-IS SpdMain_CellDoubleClick(cs:1368-1372) — bRealFlag==false(과거/CutOff Plan Date)면 MSG00312 후 차단.
    //   AS-IS 는 더블클릭(명시 제스처) 시 알럿을 띄웠다 — 인라인 편집 차단(무알럿)과 달리 여기선 그대로 재현한다.
    if (!realFlag) {
      void setAlert({ type: 'alert', content: t(MSG.NOT_REAL_TIME, 'It is not real time data.') });
      return;
    }
    setRequestInsertRow(row);
    setOpenRequestInsert(true);
  };

  // 요청상세 저장 mutation — call-proc 이 '^'-폴딩 단일 객체를 받는 특수형태라 useMutation 으로 직접 배선하고
  //   mutationKey 를 [tabId,...] 로 둬 공통 로딩 스피너(MDIContainer useIsBusy)가 저장 중 뜨게 한다(자매 SSP0021 동일).
  //   성공 판정은 SP 반환코드(o_rc1 RESULT_CODE)까지 본다 — HTTP 200·code:0 이어도 'S' 가 아니면 미저장이다.
  const { mutate: mutateSave } = useMutation({
    mutationKey: [tabId, SHEETS.REQUEST_DETAIL, 'SAVE'],
    mutationFn: (rows: SaveRow[]) =>
      submitShipmentRequestSave(rows, {
        companyId: searchParams.companyId,
        userId: str(session.userId),
      }),
    onSuccess: (result: SaveResult) => {
      // S6: 'S' 성공 — 공용 CRUD_MSG.SAVED(MSG00002). AS-IS MSG00004 는 TO-BE "No changes" 라 성공에 쓰지 않는다.
      if (result.code === 'S') {
        void setToast({ type: 'success', message: t(CRUD_MSG.SAVED.id, CRUD_MSG.SAVED.fallback) });
        GridAction.discardChanges(gridRefRequest.current, editTrackerRefRequest.current);
        void refetchRequestDetail();
        return;
      }
      // S7: 'X' = 기준정보(route/BOD) 미등록 — AS-IS SaveData_Detail(cs:2736)은 MSG00324 를 예/아니오로 띄우고
      //   '예' 면 base.AddHelpButton("Standard Information SSP Manual") 로 매뉴얼을 연다. TO-BE 는 MSG01321
      //   (예/아니오) + onConfirm 으로 매뉴얼 새 탭(선례 ShipmentPlan, 팝업과 동형).
      if (result.code === 'X') {
        void setAlert({
          type: 'confirm',
          content: t(MSG.STANDARD_INFO, 'Standard information is not registered. Would you like to view the reference?'),
          onConfirm: () => window.open(STANDARD_MANUAL_URL, '_blank', 'noopener,noreferrer'),
        });
        return;
      }
      // S8: 'F'/그 외 = 서버 예외 — 서버 MSG 우선, 없으면 시스템오류(AS-IS MSG00042, TO-BE 미등록 → 영문 fallback).
      void setAlert({
        type: 'alert',
        content:
          result.message ||
          t(MSG.SYSTEM_ERROR, 'A system error occurred. Capture the screen and contact the administrator.'),
      });
    },
    onError: () => {
      void setAlert({ type: 'alert', content: t(CRUD_MSG.SAVE_FAIL.id, CRUD_MSG.SAVE_FAIL.fallback) });
    },
  });

  // R8/R11: Save(요청상세 = 유일한 편집 대상 시트) — AS-IS SaveData_Detail(cs:2520~2728) 순서 이식:
  //   필수(공용 useSaveWithValidation=MSG00429) → 날짜형식(S3 MSG00611) → 출하일<확정일(S4) → 입력중복(S2 MSG00043)
  //   → 저장확인(S5 CRUD_MSG.SAVE_CONFIRM) → SP 저장 → 반환코드 분기(S6/S7/S8). spdMain 피벗은 편집 미배선이라 대상 아님.
  const handleSave = () => {
    const grid = gridRefRequest.current;
    if (!grid) return;
    grid.finishEditing();
    const source = (grid.collectionView?.sourceCollection ?? []) as SaveRow[];
    const changed = collectChangedRows(source);
    if (changed.length === 0) {
      void setAlert({ type: 'alert', content: t(CRUD_MSG.NO_CHANGES.id, CRUD_MSG.NO_CHANGES.fallback) });
      return;
    }
    // S1 필수(메타 INPUT_TP_CD M/IM OR 라벨 '*')은 공용 훅이 먼저 검사(MSG00429) 후 콜백 실행 — 하드코딩 금지(convert-core hook#130).
    saveWithValidation(
      changed,
      staticColumns[SHEETS.REQUEST_DETAIL],
      rows => {
        void (async () => {
          // S3 출하일 날짜형식
          if (findInvalidShipmentDate(rows)) {
            void setAlert({ type: 'alert', content: t(MSG.INVALID_DATE, 'Invalid date format. (YYYYMMDD)') });
            return;
          }
          // S4 출하일 < 확정일(ConfirmDay)
          const cdViolation = findConfirmDayViolation(rows);
          if (cdViolation) {
            void setAlert({
              type: 'alert',
              content: t(MSG.CONFIRM_DAY_BEFORE, 'Shipment date cannot be entered before {0}').replace(
                '{0}',
                cdViolation.confirmDay
              ),
            });
            return;
          }
          // S2 입력 중복(신규행 6키) — AS-IS 는 전 행을 훑으므로 source 전체로 판정한다.
          if (hasDuplicate(source)) {
            void setAlert({ type: 'alert', content: t(CRUD_MSG.DUPLICATE.id, CRUD_MSG.DUPLICATE.fallback) });
            return;
          }
          // S5 저장확인(Yes/No) — AS-IS MSG00012 는 TO-BE "Maximum of 10 tabs allowed." 라 공용 SAVE_CONFIRM 사용.
          const confirmed = await setAlert({
            type: 'confirm',
            content: t(CRUD_MSG.SAVE_CONFIRM.id, CRUD_MSG.SAVE_CONFIRM.fallback),
          });
          if (!confirmed) return;
          mutateSave(rows);
        })();
      },
      changed as never
    );
  };

  // R8/R12: Save(메인 pivot = spdMain) — AS-IS SaveData(cs:2729-2924). **확인창 없이** 변경 X_D_ 셀을 즉시 저장한다
  //   (요청상세 SaveData_Detail 과 달리 Yes/No 확인창 없음 — 통일 금지, design 01 R12). 변경 0건이면 MSG00005.
  //   수집 단위는 셀(= R_SHIP_REQ_ETA 행 × 변경된 X_D_ 일 셀, EditTracker 변경맵). 결과 S/X/else 분기는 요청상세와 동형.
  const handleMainSave = () => {
    const grid = gridRefMain.current;
    if (!grid) return;
    grid.finishEditing();
    const source = (grid.collectionView?.sourceCollection ?? []) as SaveRow[];
    const changed = (editTrackerRefMain.current?.getOriginalValues() ?? new Map()) as ReadonlyMap<
      object,
      Record<string, unknown>
    >;
    void (async () => {
      const { result, count } = await submitMainSave(source, changed, {
        companyId: searchParams.companyId,
        userId: str(session.userId),
      });
      // 변경 셀 0건 — AS-IS iCount==0 → MSG00005(cs:2905-2908).
      if (count === 0) {
        void setAlert({
          type: 'alert',
          content: t(CRUD_MSG.NO_CHANGES.id, CRUD_MSG.NO_CHANGES.fallback),
        });
        return;
      }
      if (!result.ok) {
        void setAlert({
          type: 'alert',
          content: result.message || t(CRUD_MSG.SAVE_FAIL.id, CRUD_MSG.SAVE_FAIL.fallback),
        });
        return;
      }
      // 'S' 성공 — MSG00004 저장건수 대신 공용 SAVED(요청상세 저장과 동일 방침). 성공 후 메인 재조회(cs:2863-2865).
      if (result.code === 'S') {
        void setToast({ type: 'success', message: t(CRUD_MSG.SAVED.id, CRUD_MSG.SAVED.fallback) });
        GridAction.discardChanges(gridRefMain.current, editTrackerRefMain.current);
        const isSameMain = setFilters();
        if (isSameMain) void refetchMain();
        return;
      }
      // 'X' = 표준정보(route/BOD) 미등록 — AS-IS MSG00324(예 → 매뉴얼). TO-BE MSG01321 + onConfirm 매뉴얼 탭(요청상세 동형).
      if (result.code === 'X') {
        void setAlert({
          type: 'confirm',
          content: t(MSG.STANDARD_INFO, 'Standard information is not registered. Would you like to view the reference?'),
          onConfirm: () => window.open(STANDARD_MANUAL_URL, '_blank', 'noopener,noreferrer'),
        });
        return;
      }
      // 'N'/'F'/그 외 = 서버 오류(AS-IS 서버 메시지 패스스루 / MSG00042).
      void setAlert({
        type: 'alert',
        content:
          result.message ||
          t(MSG.SYSTEM_ERROR, 'A system error occurred. Capture the screen and contact the administrator.'),
      });
    })();
  };

  // Save 라우팅(design 01 R8, cs:1772-1783) — 활성 그리드가 메인 pivot(spdMain)이면 메인 저장(확인창 없음),
  //   상세(spdDetail)면 요청상세 저장(확인창 있음). 활성 그리드 미확정이면 요청상세 경로(편집 대상 기본 시트).
  const handleSaveRouted = () => {
    if (activeGrid === 'spdMain') handleMainSave();
    else void handleSave();
  };

  // btnMeasure(design 01 R13) — spdDetail 활성이면 no-op(AS-IS), 그 외 Measure 설정 팝업.
  const handleMeasure = () => {
    if (activeGrid === 'spdDetail') return;
    setOpenMeasure(true);
  };

  // btnExcelFormDownload — 현재 조회조건으로 조회해 채운 9컬럼 엑셀 양식을 내려보낸다.
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
    await GridAction.flatExcelDownload(rows, columns, 'SSP0022_Request_Detail');
  };

  // Excel Upload 적재(mode=1) — 검증(mode=0) 통과분 DB 반영(2-phase, SSP0026 동형).
  //   엑셀 메타(SCM_ADM_EXCEL_COLUMNS)·업로드 proc 는 MAIN 시트명('Shipment Request(Electrode)') 키로 등록됨.
  const handleExcelUploadSave = async (): Promise<{ ok: boolean; message?: string }> => {
    try {
      const res = await apiClient.post<Record<string, unknown>>(
        // 라우팅/권한 shtNm = SHEETS.MAIN('main') — SSP0022 는 버튼(main/EXCEL)·권한이 'main' 으로 등록돼
        //   URL shtNm 도 'main' 이어야 PR_CHECK_MNU_BTN_AUTH 를 통과한다(admin 표시명 아님). 적재 proc
        //   라우팅은 main/EXCEL → API_ID(P_SSP0022_SHIPMENT_REQUEST_EXCEL_UPLOAD) 매핑 전제.
        `/${MENU_ID}/${SHEETS.MAIN}/EXCEL/call-proc`,
        {
          mode: 1,
          createdBy: session.userId ?? '',
          programId: MENU_ID,
          sheetName: SHEETS.MAIN,
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

  // SubTitle 커스텀 버튼 — Measure 설정(btnMeasure) + Excel Form(formDown) + Excel Upload(btnExcelUpload).
  //   전극 화면은 단일 메인 시트라 Cell Biz 숨김 분기(AS-IS SSP0026) 없이 항상 노출.
  const customButtons = [
    {
      label: t(LBL.MEASURE, '_Measure'),
      title: t(LBL.MEASURE, '_Measure'),
      action: handleMeasure,
      iconComponent: <IcMeasureSelect />,
      buttonLabel: '',
    },
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
  ];

  // Sort(F3)/Filter(F4) 대상 그리드 라우팅 — 상단 툴바(SubTitle)의 grid/gridFilter 는 **포커스된 그리드**를
  //   따른다(코드베이스 표준: SSP0026 pack `grid={activeMainSheet===…}`, SSP0060 ProductionPlan
  //   `grid={focusedSheet===MAIN?…}`, SalesSite `grid={gridRefs[activeTab]}`). 상단 메인 pivot 은 그 자체로
  //   툴바를 쓰고, 하단 상세(Stock/Request)는 전용 툴바가 없어 종전엔 sort/filter 가 닿지 않았다. activeGrid
  //   (각 그리드 onFocus 가 세팅)이 spdDetail 이면 현재 활성 상세 탭(activeDetailTab)의 그리드로 라우팅한다.
  const activeDetailGridRef =
    activeDetailTab === 'stockDetail' ? gridRefStock : gridRefRequest;
  const activeDetailFilterRef =
    activeDetailTab === 'stockDetail' ? gridFilterRefStock : gridFilterRefRequest;
  const toolbarGridRef = activeGrid === 'spdDetail' ? activeDetailGridRef : gridRefMain;
  const toolbarFilterRef = activeGrid === 'spdDetail' ? activeDetailFilterRef : gridFilterRefMain;

  const hotkeyConfig: HotkeyConfig = {
    search: () => handleSearch(),
    insert: hasButton('INSERT') ? handleInsert : (() => undefined),
    delete: hasButton('DELETE') ? handleDelete : false,
    save: hasButton('SAVE') ? handleSaveRouted : (() => undefined),
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
      {isOpenSearchArea && (
        <ShipmentRequestElectrodeForm
          onSearch={handleSearch}
          onItemSearch={() => setOpenItem(true)}
          onModelSearch={() => setOpenModel(true)}
        />
      )}
      <SubTitle
        menuId={MENU_ID}
        grid={toolbarGridRef}
        gridFilter={toolbarFilterRef}
        // 건수 배지는 포커스와 무관하게 항상 메인 pivot 기준으로 고정(SubTitle countGrid 용도) —
        //   grid 가 하단으로 라우팅돼도 상단 툴바 줄의 건수는 메인 조회 건수를 가리킨다.
        countGrid={gridRefMain}
        dataCount={mainRowsShown.length}
        excelFileName='Shipment Request(Electrode)'
        useHotkey
        hotkeyConfig={hotkeyConfig}
        customButtons={customButtons}
        searchParam={conditionSaveParam}
      />
      <PanelGroup className={styles.bodyPanelGroup} orientation='vertical'>
        <Panel defaultSize={50} minSize={20}>
          <div className={styles.gridArea}>
            <ShipmentRequestElectrodeMainGrid
              rows={mainRowsShown}
              gridRef={gridRefMain}
              gridFilterRef={gridFilterRefMain}
              editTrackerRef={editTrackerRefMain}
              staticColumns={staticColumns[SHEETS.MAIN]}
              mainEditable={mainEditable}
              periodStart={searchParams.fromYyyymmdd}
              periodEnd={searchParams.toYyyymmdd}
              bohMode={bohMode}
              bucketType={searchParams.bucketType}
              sumChecked={searchParams.sumChecked}
              pastPeriodChecked={searchParams.pastPeriodChecked}
              planDate={searchParams.planDate}
              spreadTitle={spreadTitleRows}
              onFocus={() => setActiveGrid('spdMain')}
              onCellDoubleClick={handleMainCellDoubleClick}
            />
          </div>
        </Panel>
        <PanelSeparator />
        <Panel defaultSize={50} minSize={20}>
          {/* .gridArea(flex column + height:100% + overflow:hidden) 로 감싸야 TabWrapper/FlexGrid 높이가
              제약되어 wijmo 가 ColumnFooter(Sum) 공간을 확보·바닥 고정한다(자매 SSP0026 동일). */}
          <div className={styles.gridArea}>
            {/* 2차 조회조건 바(usrLayoutControl3) — Material[팝업]·Model/Nickname[팝업]·Search 공통 +
                탭별 토글: 요청상세 = Shipment ETA·Requestor[팝업] / 재고상세 = Lot ID(AS-IS cs:1357-1382). */}
            <ShipmentRequestElectrodeDetailBar
              onDetailSearch={handleDetailSearch}
              onItemSearch2={() => setOpenDetailItem(true)}
              onModelSearch2={() => setOpenDetailModel(true)}
              onRequestorSearch={() => setOpenRequestor(true)}
            />
            {/* AS-IS 탭 순서(CreateSpread cs:574-575, 기본 활성 cs:595): Stock Detail(0) → Shipment Request Detail(1). */}
            <TabWrapper
              persist
              onTabClick={index =>
                setActiveDetailTab(index === 0 ? 'stockDetail' : 'requestDetail')
              }
            >
              <TabItem label={t(LBL.TAB_STOCK_DETAIL, 'Stock Detail')}>
                <ShipmentRequestElectrodeStockGrid
                  rows={stockDetailRows}
                  gridRef={gridRefStock}
                  gridFilterRef={gridFilterRefStock}
                  staticColumns={staticColumns[SHEETS.STOCK_DETAIL]}
                  onFocus={() => setActiveGrid('spdDetail')}
                />
              </TabItem>
              <TabItem label={t(LBL.TAB_REQUEST_DETAIL, 'Shipment Request Detail')}>
                <ShipmentRequestElectrodeDetailGrid
                  rows={requestDetailRows}
                  gridRef={gridRefRequest}
                  gridFilterRef={gridFilterRefRequest}
                  editTrackerRef={editTrackerRefRequest}
                  staticColumns={staticColumns[SHEETS.REQUEST_DETAIL]}
                  isEditMode={detailEditable}
                  comboParams={detailComboParams}
                  onFocus={() => setActiveGrid('spdDetail')}
                  onItemCellDoubleClick={handleItemCellDoubleClick}
                />
              </TabItem>
            </TabWrapper>
          </div>
        </Panel>
      </PanelGroup>

      {/* Material 검색(상단 btnItemId) — 공용 MaterialByDivisionModal(COM0013, SSP0023 동일). 단건, 빈 반환 시
          기존값 유지. 한계: 이 모달엔 Site 축이 없어 AS-IS 가 넘기던 From Site 사전필터는 빠진다(SSP0003 기록 동일). */}
      <MaterialByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={items => {
          if (items) setSearchParams({ itemId: items });
        }}
        preSearchParams={{
          divisionId: searchParams.divisionId,
          operationGroup: '',
          scpModuleType: MENU_ID,
          itemId: searchParams.itemId,
        }}
      />

      {/* Model/Nickname 검색(상단 돋보기) — 공용 MaterialByDivisionModal. 선택 → 품번(ITEM_ID)=modelId +
          첫 행 NICK_NAME=nickName 둘 다 세팅(메인 GET SP p_model_id + p_nick_name). 빈 반환 시 기존값 유지. */}
      <MaterialByDivisionModal
        open={openModel}
        modalClose={() => setOpenModel(false)}
        setSelectedValue={(items, _itemName, _itemClassName, nickName) => {
          if (items) setSearchParams({ modelId: items, nickName: nickName ?? '' });
        }}
        preSearchParams={{
          divisionId: searchParams.divisionId,
          operationGroup: '',
          scpModuleType: MENU_ID,
          itemId: searchParams.modelId,
        }}
      />

      {/* 2차 Material 검색(하단 btnItemID2) — 공용 MaterialByDivisionModal. 요청/재고 상세 공통 itemId2. */}
      <MaterialByDivisionModal
        open={openDetailItem}
        modalClose={() => setOpenDetailItem(false)}
        setSelectedValue={items => {
          if (items) setSearchParams({ itemId2: items });
        }}
        preSearchParams={{
          divisionId: searchParams.divisionId,
          operationGroup: '',
          scpModuleType: MENU_ID,
          itemId: searchParams.itemId2,
        }}
      />

      {/* 2차 Model/Nickname 검색(하단 돋보기) — 공용 MaterialByDivisionModal. 선택 → 품번(ITEM_ID)=modelId2 +
          첫 행 NICK_NAME=nickName2 둘 다 세팅(요청상세 SP p_model_id + p_nick_name). 빈 반환 시 기존값 유지. */}
      <MaterialByDivisionModal
        open={openDetailModel}
        modalClose={() => setOpenDetailModel(false)}
        setSelectedValue={(items, _itemName, _itemClassName, nickName) => {
          if (items) setSearchParams({ modelId2: items, nickName2: nickName ?? '' });
        }}
        preSearchParams={{
          divisionId: searchParams.divisionId,
          operationGroup: '',
          scpModuleType: MENU_ID,
          itemId: searchParams.modelId2,
        }}
      />

      {/* Requestor 검색(하단 btnRequestor, 요청상세 탭 전용) — 공용 SsoUserModal(AS-IS UserInfoPopup, SSP0026 동일).
          선택 사용자 "이름"(언어별 KO/EN)을 requestor 에 반영 — 그 이름 문자열이 조회 파라미터(P_REQUESTOR_ID,
          design 02 §4.6 주의 — ID 아님). ssoUserYn='N'(등록 사용자 SCM_ADM_USER_M 기준). */}
      <SsoUserModal
        open={openRequestor}
        modalClose={() => setOpenRequestor(false)}
        setSelectedValue={(userId, userNm, userEngNm) => {
          setSearchParams({ requestor: (session.langCd === 'KO' ? userNm : userEngNm) || userId });
          setOpenRequestor(false);
        }}
        ssoUserYn='N'
      />

      {/* Measure 설정 팝업(btnMeasure) — OK 시 visibleMeasures 반영 → 메인 행(MEASURE) 필터. 공용 MeasureSelectModal. */}
      <MeasureSelectModal
        open={openMeasure}
        modalClose={() => setOpenMeasure(false)}
        measures={staticMeasures}
        visibleMeasures={visibleMeasures}
        onApply={codes => {
          applyVisibleMeasures(codes);
          setOpenMeasure(false);
        }}
      />

      {/* Excel Upload 팝업(btnExcelUpload) — 검증(mode=0) → 적재(mode=1) 2-phase. 엑셀/업로드 메타는
          MAIN 시트명('Shipment Request(Electrode)') 키로 등록됨. 업로드 후 메인+요청상세 재조회. */}
      <ExcelUploadModal
        open={openExcelUpload}
        modalClose={() => setOpenExcelUpload(false)}
        sheetName={SHEETS.MAIN}
        headerLabels={(staticColumns[SHEETS.REQUEST_DETAIL_EXCEL] ?? []).map(
          c => c.colLblNm ?? c.colNm
        )}
        onSave={handleExcelUploadSave}
        onUploaded={() => {
          // 업로드 후 재조회 — AS-IS btnExcelUpload(R3, cs:4195-4197)은 FindData_Request_Detail()+FindData_Main()
          //   을 함께 부른다. 상단 Find(handleSearch)는 이제 메인만 조회하므로, 업로드 경로는 요청상세
          //   (setDetailFilters)까지 명시 재조회한다. bare refetch 는 Search 전이면 filters undefined 라 빈 body
          //   (0건)로 나가므로(2026-10-27 실측) setFilters/setDetailFilters 로 현재 조건을 싣는다.
          setActiveDetailTab('requestDetail');
          const isSameMain = setFilters();
          if (isSameMain) void refetchMain();
          const { sameReq } = setDetailFilters('requestDetail');
          if (sameReq) void refetchRequestDetail();
        }}
      />

      {/* ETA 요청 입력 팝업(메인 pivot Shipment Request ETA 셀 더블클릭) — AS-IS SSP0022_ShipmentRequestPopup.
          더블클릭한 레인(Div/Model/Material/From/To/Incoterms/TransMode) 고정 + Shipment Date·Qty 입력 → 저장
          (P_SSP0022_SAVE_SHIPMENT_REQUEST, active_flag='M'). 성공 시 메인 재조회. */}
      <ShipmentRequestInsertModal
        open={openRequestInsert}
        modalClose={() => setOpenRequestInsert(false)}
        row={requestInsertRow}
        companyId={searchParams.companyId}
        planDate={searchParams.planDate}
        onSaved={() => {
          setOpenRequestInsert(false);
          const isSameMain = setFilters();
          if (isSameMain) void refetchMain();
        }}
      />

      {/* 요청상세 ITEM_ID 더블클릭 → BOD/Item 선택 팝업(AS-IS "Model by DivisionPopup" = SSP0022_BodItemPopup).
          화면 전용 모달(shipping 표준 — SSP0024/0025/0045/0026 동형): GET_ITEM_POPUP route(From+To Site) 조회로
          Item+Model+BOD 후보를 보이고, 선택 1회로 ITEM_ID/MODEL_ID/INCOTERMS/TRANSPORT_MODE/BOD_ID/CONFIRM_DAY 채움
          (AS-IS cs:1063-1068 + FindData_BOD 등가). 신규행('I')에서만 진입. 공용 MaterialByDivisionModal/ModelByDivisionPopup
          은 각각 자재/모델 한 코드만·site 결합이 달라 SSP0022 결합·route 동작과 1:1 이 아니라 전용으로 둔다. */}
      <BodItemModal
        open={openBodItem}
        modalClose={() => setOpenBodItem(false)}
        row={bodItemRow}
        planDate={searchParams.planDate}
        onSelect={handleBodItemSelected}
      />
    </>
  );
};
