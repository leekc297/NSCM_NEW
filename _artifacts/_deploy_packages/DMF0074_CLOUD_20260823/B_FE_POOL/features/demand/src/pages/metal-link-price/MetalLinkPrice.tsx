import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ItemByDivisionModal, ProjectByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { Alert, MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { FcstUploadModal } from '../../components';

import { MetalLinkPriceForm } from './components/MetalLinkPriceForm';
import { MetalLinkPriceGrid } from './components/MetalLinkPriceGrid';
import { MetalLinkTemplateModal } from './components/modals/MetalLinkTemplateModal';
import { MetalLinkVersionModal } from './components/modals/MetalLinkVersionModal';
import {
  MAIN_EXCEL_PREFIX,
  MENU_ID,
  MSG,
  SHEETS,
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
  const [openTemplateModal, setOpenTemplateModal] = useState<boolean>(false);
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

  // 커스텀 버튼 — 'Excel Form'(템플릿 다운로드 모달). Division 미선택 시 진입 차단 (AS-IS MSG00097)
  const handleOpenTemplate = () => {
    if (!searchParams.divisionId) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRE_DIVISION, '_Please select Division.'),
      });
      return;
    }
    setOpenTemplateModal(true);
  };

  // SubTitle customButtons 표준 — {label, action, ...ButtonProps} (subtitle-button-actions-mandatory)
  //   ⭐ Excel 아이콘 leading (사용자 요구 2026-07-10)
  const customButtons = useMemo(
    () =>
      hasButton('SEARCH')
        ? [
            {
              label: t('LBL00762', 'Excel Form'),
              action: handleOpenTemplate,
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
        onApply={versionIds => setSearchParams({ version: versionIds })}
      />
      {/* ⭐ AS-IS btnTemplate 'Excel Form' (.cs L704~713) — 전용 MetalLinkPricePopup 1:1
          (조회 그리드 + Excel export = 템플릿 다운로드) */}
      <MetalLinkTemplateModal
        open={openTemplateModal}
        modalClose={() => setOpenTemplateModal(false)}
        divisionId={searchParams.divisionId}
      />
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
