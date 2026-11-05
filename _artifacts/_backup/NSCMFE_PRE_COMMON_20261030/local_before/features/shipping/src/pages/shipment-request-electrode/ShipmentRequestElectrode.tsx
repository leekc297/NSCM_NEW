import { FileExceluploadIcon } from '@lges/design-system/icon';
import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal, MeasureSelectModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { IcMeasureSelect } from '@foundation/assets';
import { CRUD_MSG } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useMutation } from '@foundation/query-client';
import { GridAction, type EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { FileExceldownloadIcon } from '@shared/lges-icons';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { ExcelUploadModal } from './components/ExcelUploadModal';

import { ShipmentRequestElectrodeDetailBar } from './components/ShipmentRequestElectrodeDetailBar';
import { ShipmentRequestElectrodeDetailGrid } from './components/ShipmentRequestElectrodeDetailGrid';
import { ShipmentRequestElectrodeForm } from './components/ShipmentRequestElectrodeForm';
import { ShipmentRequestElectrodeMainGrid } from './components/ShipmentRequestElectrodeMainGrid';
import { ShipmentRequestElectrodeStockGrid } from './components/ShipmentRequestElectrodeStockGrid';
import { ADMIN_SHEET_NAME, LBL, MENU_ID, MSG, SHEETS } from './shipment-request-electrode.constants';
import type {
  RequestDetailRow,
  ShipmentPsiRow,
  StockDetailRow,
} from './shipment-request-electrode.types';
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

  const gridRefMain = useRef<FlexGrid<ShipmentPsiRow>>();
  const gridFilterRefMain = useRef<FlexGridFilter>();
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
  // Measure 설정(btnMeasure) / Excel Upload(btnExcelUpload) 팝업 열림 상태.
  const [openMeasure, setOpenMeasure] = useState(false);
  const [openExcelUpload, setOpenExcelUpload] = useState(false);

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

  // R1: Find 버튼(상단 툴바/SearchArea) — 가드 없이 전체 재조회(design 01 R1).
  const handleSearch = () => {
    const isSame = setFilters();
    if (isSame) {
      void refetchMain();
      void refetchRequestDetail();
    }
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

  // R6: Insert — 요청상세 탭 + 편집권한(canEdit) 가드, 미충족 시 조용히 무시(AS-IS InsertRow 선행가드 cs:1449 등가).
  //   신규행 DIVISION_ID 자동세팅 + EDIT_FLAG='N'(buildNewRow), CRUD_TYPE='I' 는 GridAction.addRow 가 부여하고
  //   5컬럼 lock(INSERT_LOCK_COLUMNS)은 editLock 이 isNewRow 로 처리한다(design 01 R6 / 03 §3 규칙#8).
  //   한계(04 후속): FROM_SITE/TO_SITE 런타임 셀콤보 주입·ITEM_ID BOD 팝업 조회는 미배선(아래 C1~C4 선행 가드만 반영).
  const handleInsert = () => {
    if (!canEdit || activeDetailTab !== 'requestDetail') return;
    const grid = gridRefRequest.current;
    if (!grid) return;
    GridAction.addRow(grid, buildNewRow(searchParams.divisionId) as never, 'above', true);
  };

  // R7: Delete — 완전 NO-OP(명시적 무동작 함수, false/키생략 금지, design 01 R7).
  const handleDelete = () => undefined;

  // C1~C4: ITEM_ID 셀 팝업 선행필수(design 01 §2 / 03 §1.2, AS-IS cs:1015~1042). From Site→To Site→Incoterms→
  //   Trans Mode 순으로 첫 번째 빈 칸을 "First, select {0}"(MSG01126 — AS-IS MSG00098 미등록 등가)로 차단한다.
  //   선행값 충족 시 BOD/Item 팝업 조회로 이어가야 하나(04 후속), 선행필수 validation 은 우선 반영한다.
  const handleItemCellDoubleClick = (row: RequestDetailRow) => {
    if (!canEdit) return;
    const missing = firstMissingPrerequisite(row as SaveRow);
    if (!missing) return;
    const label = gridRefRequest.current?.getColumn(missing)?.header ?? missing;
    void setAlert({
      type: 'alert',
      content: t(MSG.PREREQUISITE, 'First, select {0}.').replace('{0}', label),
    });
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
      // S7: 'X' = 표준정보 미등록(route/BOD NULL) — AS-IS MSG00324(TO-BE 미등록 → 영문 fallback).
      if (result.code === 'X') {
        void setAlert({
          type: 'alert',
          content:
            result.message ||
            t(MSG.STANDARD_INFO, 'Standard information is not registered. Please check the references.'),
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

  const hotkeyConfig: HotkeyConfig = {
    search: () => handleSearch(),
    insert: hasButton('INSERT') ? handleInsert : (() => undefined),
    delete: () => handleDelete(),
    save: hasButton('SAVE') ? () => void handleSave() : (() => undefined),
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
        grid={gridRefMain}
        gridFilter={gridFilterRefMain}
        dataCount={mainRowsShown.length}
        excelFileName='Shipment Request(Electrode)'
        useHotkey
        hotkeyConfig={hotkeyConfig}
        customButtons={customButtons}
        searchParam={conditionSaveParam}
      />
      <PanelGroup orientation='vertical'>
        <Panel defaultSize={50} minSize={20}>
          <ShipmentRequestElectrodeMainGrid
            rows={mainRowsShown}
            gridRef={gridRefMain}
            gridFilterRef={gridFilterRefMain}
            staticColumns={staticColumns[SHEETS.MAIN]}
            bohMode={bohMode}
            bucketType={searchParams.bucketType}
            sumChecked={searchParams.sumChecked}
            pastPeriodChecked={searchParams.pastPeriodChecked}
            planDate={searchParams.planDate}
            spreadTitle={spreadTitleRows}
            onFocus={() => setActiveGrid('spdMain')}
          />
        </Panel>
        <PanelSeparator />
        <Panel defaultSize={50} minSize={20}>
          {/* 2차 조회조건 바(usrLayoutControl3) — Material[팝업]·Nick Name·Lot ID·Search. 활성 Detail 탭 재조회. */}
          <ShipmentRequestElectrodeDetailBar
            onDetailSearch={handleDetailSearch}
            onItemSearch2={() => setOpenDetailItem(true)}
            onModelSearch2={() => setOpenDetailModel(true)}
          />
          {/* AS-IS 탭 순서(CreateSpread cs:574-575, 기본 활성 cs:595): Stock Detail(0) → Shipment Request Detail(1). */}
          <TabWrapper
            persist
            onTabClick={index => setActiveDetailTab(index === 0 ? 'stockDetail' : 'requestDetail')}
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
                isEditMode={canEdit}
                onFocus={() => setActiveGrid('spdDetail')}
                onItemCellDoubleClick={handleItemCellDoubleClick}
              />
            </TabItem>
          </TabWrapper>
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
          // 업로드 후 현재 조회조건으로 재조회(AS-IS FindData). bare refetchMain 은 아직 Search 전이면
          //   store filters 가 undefined 라 빈 body(content-length 0)로 나가 0건이 된다(2026-10-27 실측).
          //   setFilters 로 현재 searchParams 를 조건에 싣는 handleSearch 를 써야 업로드분이 보인다.
          setActiveDetailTab('requestDetail');
          handleSearch();
        }}
      />
    </>
  );
};
