import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ItemByDivisionModal, ProjectByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import {
  captureGridFilter,
  captureGridSort,
  GridAction,
  restoreGridFilter,
  restoreGridSort,
} from '@foundation/utils';
import { Alert, MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore, useUIStore } from '@shared/stores';

import { FcstUploadModal } from '../../components';

import { MetalLinkPriceForm } from './components/MetalLinkPriceForm';
import { MetalLinkPriceGrid } from './components/MetalLinkPriceGrid';
// Excel Form 팝업은 쓰지 않는다 — customButtons 액션이 직접 다운로드한다(handleExcelFormDownload).
// import { MetalLinkTemplateModal } from './components/modals/MetalLinkTemplateModal';
import { MetalLinkVersionModal } from './components/modals/MetalLinkVersionModal';
import {
  MAIN_EXCEL_PREFIX,
  MENU_ID,
  MSG,
  SHEETS,
  TEMPLATE_EXCEL_PREFIX,
  UPLOAD_FORM_ID,
  UPLOAD_HEADERS_DEFAULT,
  UPLOAD_HEADERS_DIV40,
} from './metal-link-price.constants';
import type { MetalLinkPriceRow } from './metal-link-price.types';
import { useMetalLinkPriceStore } from './useMetalLinkPriceStore';

// AS-IS DMF0074_MetalLinkPrice (Demand > Demand Plan > Metal Link Price · 메탈 판가 연동).
//   조회전용 화면 — 저장 = Excel Upload 스테이징 단일 경로 (DIV=40 은 formId 'DMF0074_40').
//   Insert/Delete/Edit/Save = AS-IS 빈 override → hotkeyConfig false (버튼 미노출).
//   편집제어 = 단일 division-gate: SP 가 SCM_ADM_USER_MNU_EDIT_AUTH_V INNER JOIN 으로 행 하드필터
//   (PKG BODY L452/L837 — FE 중복 필터 불요. EDIT_YN 은 표시용).
//   SP: PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRICE(메인 12 IN) + P_DMF0074_GET_METAL_LINK_TEMPLATE
//       (템플릿 — Excel Form 모달) + P_DMF0074_EXCEL_UPLOAD(업로드 validProc 5-arg).
export const MetalLinkPrice = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGrid<MetalLinkPriceRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const queryClient = useQueryClient();

  const isOpenSearchArea = useMetalLinkPriceStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useMetalLinkPriceStore(state => state.setOpenSearchArea);
  const searchParams = useMetalLinkPriceStore(state => state.searchParams);
  const setSearchParams = useMetalLinkPriceStore(state => state.setSearchParams);
  const filters = useMetalLinkPriceStore(state => state.filters);
  const setFilters = useMetalLinkPriceStore(state => state.setFilters);
  const clearFilters = useMetalLinkPriceStore(state => state.clearFilters);
  const fetchStaticColumns = useMetalLinkPriceStore(state => state.fetchStaticColumns);

  // ui-dynamic-property-management — Menu Button 권한 동적 fetch (하드코딩 금지)
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // ⭐ 명시 조회 게이트 — persist 된 stale filters 자동 발사 차단 (DMF0014/0048 선례)
  const [hasSearched, setHasSearched] = useState(false);

  const [openPrjByDivisionModal, setOpenPrjByDivisionModal] = useState<boolean>(false);
  const [openModelByDivisionModal, setOpenModelByDivisionModal] = useState<boolean>(false);
  const [openVersionModal, setOpenVersionModal] = useState<boolean>(false);
  // Excel Form 팝업 상태는 더 이상 쓰지 않는다(직다운로드로 대체).
  // const [openTemplateModal, setOpenTemplateModal] = useState<boolean>(false);
  const [openUploadModal, setOpenUploadModal] = useState<boolean>(false);

  // 메인 그리드 SP — PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRICE (10 IN + 세션 2 + O_RC1/O_RESULT)
  const { data, isFetching } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: hasSearched && !!filters[SHEETS.MAIN],
  });

  // mount 시 1회 admin 메타 fetch + persist 된 이전 filters 무효화 (NULL payload SP 자동호출 방지)
  useEffect(() => {
    clearFilters();
    void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // Division 기본 선택 (DMF0021/DMF0045/DMF0053 정본 통일). 초기 divisionId(세션 div ?? '40')가
  //   FilterMyDivision 목록에 없으면 목록 첫 행으로 보정한다 (AS-IS 진입 시 콤보 첫 항목 자동선택
  //   파리티). 콤보 로드 후 1회만 — didFallbackRef 로 사용자 선택·복원값 재보정을 막는다.
  const [divisionRows] = useTabComboQueries({ filters: ['FilterMyDivision'] });
  const didFallbackRef = useRef(false);
  useEffect(() => {
    if (didFallbackRef.current) return;
    const codes = (divisionRows ?? []).map(r => String(r.CODE ?? '')).filter(Boolean);
    if (codes.length === 0) return;
    didFallbackRef.current = true;
    if (!codes.includes(searchParams.divisionId)) {
      setSearchParams({ divisionId: codes[0] });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisionRows]);

  // Division(조회조건) 변경 시 컬럼 재조회 + 그리드 초기화 — 조회 버튼 없이 즉시 반영 (SalesFuturePrice 선례).
  //   초기 마운트/persist 복원은 제외 — 실제 division '변경' 시에만 동작.
  //   clearFilters() → filters[MAIN] 제거 → useTabProcQuery enabled=false → rows 비움 (이전 division 결과 잔존 방지).
  const prevDivisionRef = useRef(searchParams.divisionId);
  useEffect(() => {
    if (prevDivisionRef.current === searchParams.divisionId) return;
    prevDivisionRef.current = searchParams.divisionId;
    clearFilters();
    void fetchStaticColumns(); // fetchStaticColumns 는 store 의 searchParams.divisionId 를 내부에서 읽음
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [searchParams.divisionId, clearFilters]);

  // ----- 조회 validation (AS-IS FindData L361~421 순서 1:1) -----
  const validateFind = (): boolean => {
    // MSG00137 — blnWork 이중실행 가드 (.cs L370): TanStack isFetching 1:1
    if (isFetching) {
      void setAlert({ type: 'alert', content: t(MSG.BUSY, '_Previous request is still running.') });
      return false;
    }
    // MSG00283 — Version 공란 (.cs L377)
    if (!searchParams.version.trim()) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRE_VERSION, '_Please select Version.') });
      return false;
    }
    // MSG00614 — Plan Date 공란 (.cs L387: AS-IS MSG00002 의미 1:1. 날짜 파싱 실패 MSG00049 는
    //   TO-BE 월 피커로 도달 불가 — __asis-mapping__ 격차 명기)
    if (!searchParams.fromYyyymm || !searchParams.toYyyymm) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_VALUE, '_{0} value is required.').replace('{0}', 'Plan Date'),
      });
      return false;
    }
    // MSG00108 — 기간 역전 (.cs L403)
    if (Number(searchParams.fromYyyymm) > Number(searchParams.toYyyymm)) {
      void setAlert({
        type: 'alert',
        content: t(MSG.PERIOD_INVERTED, '_Invalid period (start > end).'),
      });
      return false;
    }
    // MSG00097 — Division 공란 (.cs L421)
    if (!searchParams.divisionId) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRE_DIVISION, '_Please select Division.'),
      });
      return false;
    }
    return true;
  };

  // F5 Search — refetch?.() 직접 호출 금지 (stale closure — setFilter + invalidateQueries 표준)
  const handleSearch = () => {
    if (!validateFind()) return;
    // void setToast({ message: t('LBL00665', '_Loading...'), type: 'default', duration: 2000 });
    setHasSearched(true);
    setFilters();
    void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
    void fetchStaticColumns();
  };

  // hook #92 — 컬럼 표시 기준 division = "조회한" division (조회 전 컬럼 이동 방지)
  const searchedDivision = filters[SHEETS.MAIN]?.divisionId ?? '';

  // Excel Upload — AS-IS btnExcelUpload_Click (.cs L715~737) 1:1: DIV=40 → formId 'DMF0074_40'
  const uploadFormId =
    searchParams.divisionId === '40' ? UPLOAD_FORM_ID.DIV40 : UPLOAD_FORM_ID.DEFAULT;
  const uploadHeaders =
    searchParams.divisionId === '40' ? UPLOAD_HEADERS_DIV40 : UPLOAD_HEADERS_DEFAULT;

  // SubTitle 공통버튼 — hasButton 권한 분기. 조회전용: insert/delete/save = false (AS-IS 빈 override)
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: false,
    delete: false,
    save: false,
    manual: false,
    upload: hasButton('UPLOAD') ? () => setOpenUploadModal(true) : false,
  };

  const rows = (data as { o_rc1?: MetalLinkPriceRow[] })?.o_rc1 ?? [];

  // Excel Form — 팝업 없이 버튼 클릭 즉시 다운로드한다.
  // ⭐ [2026-09-14 사용자 확정 — 기존 GSCM 양식 캡처 대조] 양식 = 메인 그리드 Excel Download 와
  //   똑같은 헤더 구조(메탈 42 = Key/Period(Fr)/Period(To)/Contract Price(/kg)/Change Price(/kg)/
  //   Metal Index (kg/Biz type) 6그룹 × Ni/Co/Li2CO3/LIOH/Al/Mn/Cu 2단 그룹헤더)에서 데이터만 뺀 것.
  //   AS-IS DMF0074_MetalLinkPricePopup 도 동일 사유 1:1 — 팝업 그리드가 메인과 동일 카탈로그
  //   (DM.DMF0000_GET_COMMON_SPREAD_TITLE p_program_id='DMF0074')를 쓰고, Excel 버튼이 곧
  //   SimplexelService.ExportFpSpread(메인 Excel 버튼과 동일 export 경로)로 저장 = "템플릿 다운로드".
  //   그래서 정적 UPLOAD_COLUMNS_* 평탄 헤더로 별도 조립하지 않고, 메인 그리드(gridRef)를 그대로
  //   GridAction.excelDownload 로 내보내되 그 순간만 데이터를 비운다.
  //   ⚠ 주의(잔존 격차) — SCM_ADM_EXCEL_COLUMNS.HEADER_CONTENT(DB 실측)는 여전히 평탄 토큰
  //   (Key_Ni/PeriodFr_Ni/...)이다. 이 2단 헤더 파일을 그대로 재업로드하면 메탈 42열이 BE 헤더명
  //   매핑에서 어긋날 수 있다(hook #135 §4) — 실제 재업로드 여부는 별도 검증 필요.
  const handleExcelFormDownload = () => {
    if (!searchParams.divisionId) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRE_DIVISION, '_Please select Division.'),
      });
      return;
    }
    const grid = gridRef.current;
    if (!grid) return;

    // 그리드 데이터만 순간적으로 비웠다 되돌린다 — excelDownload 내부에서 컬럼을 clear/rebuild 하는
    //   기존 패턴과 동일 idiom(동기 구간에서 끝나 화면엔 보이지 않는다). 사용자가 걸어둔 정렬/필터는
    //   itemsSource 교체로 끊기므로 캡처 후 복원한다.
    const originalItemsSource = grid.itemsSource;
    const sortSnapshot = captureGridSort(grid);
    const filterDefinition = captureGridFilter(gridFilterRef.current);
    grid.itemsSource = [];
    // 헤더 셀 전 방향 테두리 + 배경 #E7E6E6(Excel "밝은회색 배경2" 표준 테마색) + 비볼드 —
    //   사용자 확정 2026-09-14, Excel Form 전용(공용 excelDownload 는 기본값 무변화).
    void GridAction.excelDownload(
      grid,
      TEMPLATE_EXCEL_PREFIX,
      useUIStore.getState().setProgress,
      { border: true, fillColor: '#E7E6E6', bold: false }
    )
      .catch((error: unknown) => {
        void setAlert({
          type: 'alert',
          content: error instanceof Error ? error.message : 'Excel download failed.',
        });
      })
      .finally(() => {
        grid.itemsSource = originalItemsSource;
        restoreGridSort(grid, sortSnapshot);
        restoreGridFilter(grid, gridFilterRef.current, filterDefinition);
      });
  };

  // SubTitle customButtons 표준 — {label, action, ...ButtonProps} (subtitle-button-actions-mandatory)
  //   ⭐ Excel 아이콘 leading (사용자 요구 2026-07-10)
  const customButtons = useMemo(
    () =>
      hasButton('SEARCH')
        ? [
            {
              label: t('LBL00762', 'Excel Form'),
              // 팝업 방식(원본)은 아래처럼 열었다 — 참고용으로 남겨둔다.
              // setOpenTemplateModal(true);
              action: handleExcelFormDownload,
              // ⭐ Excel Download 아이콘 leading (FileExcelIcon 은 런타임 미표시 — 사용자 확인 2026-07-10 원복)
              // iconComponent: <FileExceldownloadIcon />,
              iconPosition: 'leading' as const,
            },
          ]
        : undefined,
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [searchParams.divisionId, hasButton, t]
  );

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <MetalLinkPriceForm
        onSubmit={handleSearch}
        setOpenPrjByDivisionModal={setOpenPrjByDivisionModal}
        setOpenModelByDivisionModal={setOpenModelByDivisionModal}
        setOpenVersionModal={setOpenVersionModal}
      />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName={MAIN_EXCEL_PREFIX}
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
        customButtons={customButtons}
      />
      <MetalLinkPriceGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        data={rows}
        searchedDivision={searchedDivision}
      />
      {/* AS-IS btnProject_Click (.cs L639) — SCM0002_ProjectbyDivisionPopupEx 1:1 (빈 반환 시 유지) */}
      <ProjectByDivisionModal
        open={openPrjByDivisionModal}
        modalClose={() => setOpenPrjByDivisionModal(false)}
        setSelectedValue={projects => {
          if (projects) setSearchParams({ project: projects });
        }}
        preSearchParams={{
          deptId: searchParams.team || 'ALL',
          divisionId: searchParams.divisionId,
          endCustomer: searchParams.endCustomer || 'ALL',
          etc: '',
          projectCode: searchParams.project,
          salesSite: searchParams.salesSite || 'ALL',
        }}
        callFromCell={false}
      />
      {/* AS-IS btmItem_Click (.cs L663) — DM0002_ItembyDivisionPopupEx. ⭐ 취소(빈 반환) 시 기존값
          유지 — AS-IS 는 빈값 덮임(quirk), TO-BE 개선 (__asis-mapping__ 명기) */}
      <ItemByDivisionModal
        open={openModelByDivisionModal}
        modalClose={() => setOpenModelByDivisionModal(false)}
        setSelectedValue={items => {
          if (items) setSearchParams({ modelNickname: items });
        }}
        preSearchParams={{
          deptId: searchParams.team || 'ALL',
          divisionId: searchParams.divisionId,
          endCustomer: searchParams.endCustomer || 'ALL',
          salesSite: searchParams.salesSite || 'ALL',
          projectCode: searchParams.project,
          itemId: searchParams.modelNickname,
          activeFlag: 'Y',
        }}
        callFromCell={false}
      />
      {/* AS-IS btnSPVer_Click (.cs L673~702) — DMF0073_VersionBySalesPricePopup 1:1 (versionType 'SP') */}
      <MetalLinkVersionModal
        open={openVersionModal}
        modalClose={() => setOpenVersionModal(false)}
        defaultDivision={searchParams.divisionId}
        // 메인 조회조건 기간(YYYYMM)을 팝업 Period 로 물려준다 — 팝업이 1일~말일(YYYYMMDD)로 변환.
        mainPeriodFrom={searchParams.fromYyyymm}
        mainPeriodTo={searchParams.toYyyymm}
        onApply={versionIds => setSearchParams({ version: versionIds })}
      />
      {/* Excel Form 팝업은 쓰지 않는다 — customButtons 의 'Excel Form' 이 handleExcelFormDownload 로
          즉시 다운로드한다. 컴포넌트는 삭제하지 않고 보존한다. */}
      {/* <MetalLinkTemplateModal
        open={openTemplateModal}
        modalClose={() => setOpenTemplateModal(false)}
        divisionId={searchParams.divisionId}
      /> */}
      {/* AS-IS btnExcelUpload_Click (.cs L715~737) — 공통 ExcelUploadForm 1:1.
          ⭐ 2-Step (사용자 확정 2026-07-10): [Upload]=검증·분류 / [OK]=저장(onSave — P_MODE=1 call-proc).
          전량 게이트 = Error 0 일 때만 OK 활성 (모달 내부 + SP L2649 이중 게이트). 저장 후 refetch. */}
      <FcstUploadModal
        open={openUploadModal}
        modalClose={() => setOpenUploadModal(false)}
        menuId={uploadFormId}
        sheetName={SHEETS.MAIN}
        attributeHeaders={uploadHeaders}
        onSave={async () => {
          // ⭐ PKG_DMF0074.P_DMF0074_EXCEL_UPLOAD(P_MODE=1) — 검증 통과분 DB 반영.
          //   P_PROGRAM_ID='DMF0074' (LIKE 'DMF0074%' 로 DMF0074_40 스테이징도 포괄) ·
          //   P_CREATED_BY=BE 세션 자동(createdBy) · V_CREATION_DATE=MAX(최신 배치 자동 선택).
          const sesUserId = useSessionStore.getState().session.userId ?? '';
          try {
            const res = await apiClient.post<Record<string, unknown>>(
              `/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`,
              { mode: 1, createdBy: sesUserId, programId: uploadFormId, sheetName: SHEETS.MAIN }
            );
            const code = Number((res.data as { code?: string })?.code ?? 0);
            const inner = (
              res.data?.result as { o_result_cursor?: { CODE?: string; MSG?: string }[] }
            )?.o_result_cursor?.[0];
            // SP 반환 CODE!='0' = 실패 (전량 게이트 위반 등) — MSG passthrough
            if (res.status >= 400 || code || (inner && inner.CODE !== '0')) {
              return {
                ok: false,
                message: inner?.MSG || (res.data as { message?: string })?.message,
              };
            }
            return { ok: true };
          } catch (e) {
            return { ok: false, message: e instanceof Error ? e.message : undefined };
          }
        }}
        onUploaded={() => {
          // ⭐ [2026-08-18 사용자 확정 A안] 업로드 저장 성공 = Version 을 'Current' 로 리셋 후 재조회.
          //   업로드분은 Current 원장(DM_BPS_METAL_LINK_PRICE)에 적재되는데, Version 칸에 특정
          //   버전(예: SP_W_..._V001)이 남아 있으면 _C 스냅샷을 읽어 방금 저장분이 안 보인다
          //   (실사고 2026-08-18 21:45 — SP 교차검증: 특정버전 0행 / Current 2행).
          setSearchParams({ version: 'Current' });
          if (hasSearched) {
            // setFilters 가 최신 searchParams(Current)로 필터를 재조립 → query key 변경 = 자동 재조회.
            //   (invalidateQueries 는 구 필터(특정 버전)로 재요청하므로 여기선 부적합)
            setFilters();
          }
        }}
      />
      <Alert />
    </>
  );
};
