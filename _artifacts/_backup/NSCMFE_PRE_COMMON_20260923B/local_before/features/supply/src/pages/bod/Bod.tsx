import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { BUTTON_TYPE, CRUD_MSG } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useMutation } from '@foundation/query-client';
import { GridAction, GridUtils } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { BOD_COLUMN, DAY_OF_WEEK_COLUMNS, MENU_ID, SHEETS } from './bod.constants';
import type { BodSaveErrorRow } from './bod.types';
import { validateBodRows } from './bod.util';
import { BodForm } from './components/BodForm';
import { BodGrid } from './components/BodGrid';
import { BodDistributionRoutePopup, type RouteRow } from './components/modals/BodDistributionRoutePopup';
import { useBodStore } from './useBodStore';

export const Bod = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS>>>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const [routePopup, setRoutePopup] = useState<{
    open: boolean;
    row?: ResponseData<MENU_ID, SHEETS>;
    rowIndex?: number;
  }>({ open: false });

  // 저장 검증 실패(99030 기간중복 등) 위반 행 — BodGrid 가 이 행을 배경 강조한다(AS-IS SetBGColor).
  const [saveError, setSaveError] = useState<BodSaveErrorRow | null>(null);

  const isOpenSearchArea = useBodStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useBodStore(state => state.setOpenSearchArea);
  const filters = useBodStore(state => state.filters);
  const setFilters = useBodStore(state => state.setFilters);
  const initialized = useBodStore(state => state.initialized);
  const fetchStaticColumns = useBodStore(state => state.fetchStaticColumns);
  const staticColumn = useBodStore(state => state.staticColumn);
  const searchParams = useBodStore(state => state.searchParams);

  const { t } = useTranslation();
  const setAlert = useMessageStore(state => state.setAlert);
  const setToast = useMessageStore(state => state.setToast);
  const { saveWithValidation } = useSaveWithValidation();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.BOD>({
    menuId: MENU_ID,
    sheetName: SHEETS.BOD,
    tabId,
    filters,
    enabled: !!filters,
  });

  // Country/City 캐시 — AS-IS GetData_Country()(SCP0007_BOD.cs L604-638) 는 조회조건 division 으로
  // p_scm_site_id='' 를 넘겨 전 SITE 를 1회 캐시(dtCountryCity)한다. SetCityCode 가 이 캐시로
  // From/To Site 셀 변경마다 client-side lookup 한다(서버 재조회 없음). BOD 조회와 같은 시점에
  // 함께 트리거(같은 filters/enabled 게이트) — division 없이는 캐시도 무의미하다.
  // 확인필요(DB 접속 불가): SCM_ADM_MNU_BTN_MPG_M 에 SCP0007/countryCity/SEARCH 버튼 배선이
  // 05_register.sql 로 작성됐으나 이번 세션에서 DB 미적용 — 적용 전에는 -9997 No Permission.
  const countryCityFilters = useMemo(
    () => (filters ? { divisionId: filters.divisionId, scmSiteId: '' } : undefined),
    [filters]
  );
  const { data: countryCityData } = useTabProcQuery<MENU_ID, SHEETS.COUNTRY_CITY>({
    menuId: MENU_ID,
    sheetName: SHEETS.COUNTRY_CITY,
    tabId,
    filters: countryCityFilters,
    enabled: !!countryCityFilters,
  });
  const countryCityRows = useMemo(() => countryCityData?.o_rc1 ?? [], [countryCityData]);

  // 저장 SP 호출 — apiClient.post 를 useMutation 으로 감싼다. 두 가지 이유:
  //   1) AS-IS SaveData_Main(L811 p_input_status) 이 조회조건 Input Status 를 저장 SP 로도 함께
  //      보낸다. 공용 useProcMutation(callMutationProc)은 body 로 `{ data }` 배열 1개만 전송하는
  //      통로라 inputStatus 를 못 싣는다 — DMF0020 패턴(convert-core §3.2)으로 data/inputStatus 를
  //      직접 보낸다(PROC_M 등록 97_SCP0007_main_proc_api_registration.sql BLOCK 2 순서와 동일).
  //      sesUserId 는 BE(NDaoInterface)가 세션에서 자동 주입하므로 FE 가 보내지 않는다.
  //   2) 전역 로딩 스피너 — MDIContainer 의 useIsBusy([tabId]) 는 tabId 로 시작하는 query/mutation
  //      만 세므로, apiClient.post 를 직접 부르면 저장 중 스피너가 돌지 않는다(ContributeMain 과 동일).
  //   mutationKey 는 useProcMutation 규약과 같은 [tabId, sheetName, SAVE, {}]. 저장은 멱등하지 않아
  //   재시도 금지(retry:0) — 전역 기본값 retry:1 로 두면 실패분 재전송이 중복 반영으로 이어진다.
  const { mutateAsync: saveBod } = useMutation({
    mutationKey: [tabId, SHEETS.BOD, BUTTON_TYPE.SAVE, {}],
    retry: 0,
    mutationFn: (payload: { data: ResponseData<MENU_ID, SHEETS.BOD>[]; inputStatus: string }) =>
      apiClient.post<{ O_RESULT_CURSOR?: BodSaveErrorRow[] }>(
        `/${MENU_ID}/${SHEETS.BOD}/SAVE/call-proc`,
        payload
      ),
  });

  const mutate = async (dirtyRows: ResponseData<MENU_ID, SHEETS.BOD>[]) => {
    if (dirtyRows.length === 0) {
      void setToast({ type: 'error', message: t(CRUD_MSG.NO_CHANGES.id, CRUD_MSG.NO_CHANGES.fallback) });
      return;
    }
    setSaveError(null); // 새 저장 시도 — 이전 오류 행 강조 해제
    try {
      const res = await saveBod({ data: dirtyRows, inputStatus: searchParams.inputStatus });
      // 여기 도달 = SP 성공(O_RESULT_CURSOR CODE='0'). 저장검증 실패(CODE='-1')는 응답 인터셉터가
      // throw 하므로 아래 catch 에서 처리한다(status 403/500 등만 여기서 code 검사로 걸린다).
      if (res.status >= 400 || Number(res.data?.code)) {
        const reason =
          res.data?.message?.trim() || t(CRUD_MSG.SAVE_ERROR.id, CRUD_MSG.SAVE_ERROR.fallback);
        void setAlert({ type: 'alert', content: reason });
        return;
      }
      void setToast({ type: 'success', message: t(CRUD_MSG.SAVED.id, CRUD_MSG.SAVED.fallback) });
      await refetch();
    } catch (error) {
      // SP 저장검증 실패(99030 기간중복 등) — 인터셉터가 O_RESULT_CURSOR 오류 행을 error.cause 로 전달.
      // MSG00043('저장시 중복 오류가 발생하였습니다. {0}') + SP 상세메시지 표출 + 위반 행 강조(BodGrid).
      const cause = error instanceof Error ? error.cause : undefined;
      if (cause && typeof cause === 'object' && 'RESULT_CODE' in cause) {
        const errorRow = cause as BodSaveErrorRow;
        const detail = errorRow.ERR_MESSAGE || errorRow.MSG || '';
        void setAlert({
          type: 'alert',
          content: t('MSG00043', '_저장시 중복 오류가 발생하였습니다. {0}').replace('{0}', detail),
        });
        setSaveError(errorRow);
        return;
      }
      const message = error instanceof Error ? error.message : undefined;
      void setAlert({
        type: 'alert',
        content: message || t(CRUD_MSG.SAVE_FAIL.id, CRUD_MSG.SAVE_FAIL.fallback),
      });
    }
  };

  // 신규행 기본값 — AS-IS InsertButton(SCP0007_BOD.cs L367-432).
  //   Input Status='R'(Required) 일 때는 입력 자체를 막는다(L370-374, MSG00159).
  //   Division 이 단일 선택(2자리 코드)일 때만 DIVISION_ID 기본값을 채운다(L408-412).
  // TODO(미포팅): L414-420 의 CUSTOMER/FROM_CITY/TO_CITY/SAFETY_STOCK/ROUTE_CNT/ROUTE_ID~BOD_ID/
  //   ROUTE_VALID~끝 행 단위 잠금 — Route 팝업으로 값이 채워지기 전까지 대부분 컬럼이 읽기전용이어야
  //   하나, VMI_YN→SAFETY_STOCK 과 같은 다건 행단위 잠금 인프라 확장이 필요해 이번 라운드 범위 밖.
  const handleInsert = () => {
    if (!gridRef.current) return;
    if (searchParams.inputStatus === 'R') {
      void setAlert({
        type: 'alert',
        content: t('MSG00159', '_Input Status가 Completed일때만 입력이 가능합니다.'),
      });
      return;
    }

    const today = new Date();
    const monday = new Date(today);
    monday.setDate(today.getDate() - ((today.getDay() + 6) % 7));
    const fromYyyymmdd = `${monday.getFullYear()}-${String(monday.getMonth() + 1).padStart(2, '0')}-${String(monday.getDate()).padStart(2, '0')}`;

    const defaultRow: Record<string, unknown> = {
      [BOD_COLUMN.VMI_YN]: 'N',
      [BOD_COLUMN.BOD_VALID]: 'Y',
      [BOD_COLUMN.BEFORE_LEAD_TIME]: 0,
      [BOD_COLUMN.AFTER_LEAD_TIME]: 0,
      [BOD_COLUMN.FROM_YYYYMMDD]: fromYyyymmdd,
      [BOD_COLUMN.TO_YYYYMMDD]: '2099-12-27',
    };
    if (searchParams.divisionId.length === 2) {
      defaultRow[BOD_COLUMN.DIVISION_ID] = searchParams.divisionId;
    }

    GridAction.addRow(gridRef.current, defaultRow as Partial<ResponseData<MENU_ID, SHEETS>>);
  };

  // AS-IS DeleteButton(SCP0007_BOD.cs L361-365) — action(CRUD_TYPE) != 'I' 이면 silent return.
  // 저장된 기존 행은 이 버튼으로 삭제되지 않는다(BOD_VALID 토글 등 별도 경로 추정, 01_layout.md §5
  // 확인 필요 — SP 본문 미확인). deleteOnlyNew=true 로 신규 추가행(CRUD_TYPE='I')만 즉시 제거하고,
  // 기존 행 선택 시에는 GridAction.removeRow 자체가 아무 것도 하지 않는다(메시지 없음, AS-IS 동일).
  const handleDelete = () => {
    if (!gridRef.current) return;
    GridAction.removeRow(gridRef.current, true);
  };

  const handleRouteCellDblClick = (row: ResponseData<MENU_ID, SHEETS>, rowIndex: number) => {
    setRoutePopup({ open: true, row, rowIndex });
  };

  // 선택 → BOD 그리드 주입 — AS-IS spdMain_CellDoubleClick(SCP0007_BOD.cs L1077-1091).
  //   EditTracker 미배선 상태라 원복 추적은 못하지만 CRUD_TYPE 직접 세팅으로 저장 대상엔 포함된다
  //   (GridAction.addRow 가 신규행에 CRUD_TYPE='I' 를 직접 세팅하는 것과 동일 방식).
  const handleRouteSelect = (route: RouteRow) => {
    const { row, rowIndex } = routePopup;
    if (!row || rowIndex === undefined) return;
    const target = row as unknown as Record<string, unknown>;
    target[BOD_COLUMN.ROUTE_ID] = route.ROUTE_ID;
    // BOD 그리드의 TRANSPORT_MODE 컬럼에 route 의 TRANSPORT_MODE_NAME 을 싣는다
    // (AS-IS L1078 — 필드명이 다르다: BOD 는 TRANSPORT_MODE, route 응답은 TRANSPORT_MODE_NAME).
    target[BOD_COLUMN.TRANSPORT_MODE] = route.TRANSPORT_MODE_NAME;
    target[BOD_COLUMN.PRIORITY] = route.PRIORITY;
    for (const day of DAY_OF_WEEK_COLUMNS) target[day] = route[day];
    target[BOD_COLUMN.ROUTE_VALID] = route.VALID_YN;
    target.DIS_TOTAL_LEAD_TIME = route.LT_SUM;
    target[BOD_COLUMN.LT_TYPE] = route.LT_TYPE;
    target[BOD_COLUMN.BOD_VALID] = 'Y'; // AS-IS L1091 고정
    if (!target.CRUD_TYPE) target.CRUD_TYPE = 'M';
    GridUtils.refreshRow(gridRef.current, rowIndex);
  };

  // 저장 전 BOD 고유 업무 검증 — AS-IS SaveData_Main(L677-782) 중 필수값 이외 규칙(bod.util.ts
  // validateBodRows 참고). 공통 필수값 검증(useSaveWithValidation)보다 먼저 돈다 — AS-IS 도
  // checkRequiredOfSpread 를 통과한 뒤 이 규칙들을 본다(L677 이후 흐름과 동일 순서).
  const handleSave = () => {
    if (!gridRef.current) return;
    // 편집 중인 셀을 먼저 커밋 — 값을 입력하고 Enter/포커스 이동 없이 바로 저장을 눌러도
    //   그 셀의 변경이 dirty 집계·저장 payload 에 잡히게 한다(SalesSite.handleSave 와 동일 규약).
    gridRef.current.finishEditing();
    const gridRows = gridRef.current.collectionView?.sourceCollection ?? [];
    const dirtyRows = gridRows.filter(row => row.CRUD_TYPE);
    if (dirtyRows.length === 0) {
      mutate([]);
      return;
    }

    const validationError = validateBodRows(dirtyRows);
    if (validationError) {
      const content = (validationError.params ?? []).reduce(
        (message, param, index) => message.replace(`{${index}}`, param),
        t(validationError.id, validationError.fallback)
      );
      void setAlert({ type: 'alert', content });
      gridRef.current.refresh();
      return;
    }

    saveWithValidation(dirtyRows, staticColumn, mutate);
  };

  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
  }, [tabId]);

  // 버튼권한 게이트 — AS-IS Insert/Delete/Edit 는 별도 SP 호출 없는 순수 로컬 그리드 액션이고
  // 저장은 SaveButton 이 일괄 처리한다(00_checklist.md §4d entryPoints 집계, buttonGuards #1·#2).
  // 별도 CanInsert/CanDelete AS-IS 권한이 없어 화면 update 권한(=SAVE)로 통일한다 — INSERT/DELETE
  // MNU_BTN_CD 는 SCM_ADM_MNU_BTN_MPG_M 에 등록된 적이 없어(97_SCP0007_main_proc_api_registration.sql
  // 은 SEARCH/SAVE 2건만 등록) hasButton('INSERT')/hasButton('DELETE') 로 게이트하면 상시 차단된다
  // (ProductionPlanLine H1 사고와 동일 유형, gap-resolve iter-1 G11 고위험). SEARCH 는 이미 등록돼
  // 있어(동일 SQL BLOCK4) hasButton('SEARCH')로 게이트한다(project-route.tsx 표준 패턴).
  const hotkeyConfig: HotkeyConfig = {
    insert: hasButton('SAVE') ? handleInsert : false,
    delete: hasButton('SAVE') ? handleDelete : false,
    search: hasButton('SEARCH') ? setFilters : false,
    save: hasButton('SAVE') ? handleSave : false,
    manual: false,
    upload: false,
  };

  const rows = useMemo(
    () => data?.o_rc1 ?? [],
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [data, searchParams.divisionId]
  );

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <BodForm />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='BOD'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <BodGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        data={rows}
        countryCityRows={countryCityRows}
        onRouteCellDblClick={handleRouteCellDblClick}
        saveError={saveError}
      />
      <BodDistributionRoutePopup
        open={routePopup.open}
        modalClose={() => setRoutePopup({ open: false })}
        preSearchParams={{
          fromCountry: String(routePopup.row?.FROM_COUNTRY ?? ''),
          fromCity: String(routePopup.row?.FROM_CITY ?? ''),
          toCountry: String(routePopup.row?.TO_COUNTRY ?? ''),
          toCity: String(routePopup.row?.TO_CITY ?? ''),
          // 공백(빈 TRANSPORT_MODE)도 'ALL' 로 — 팝업 Trans Mode 콤보가 ALL 을 선택하도록.
          transMode: String(routePopup.row?.TRANSPORT_MODE ?? '').trim() || 'ALL',
        }}
        onSelect={handleRouteSelect}
      />
    </>
  );
};
