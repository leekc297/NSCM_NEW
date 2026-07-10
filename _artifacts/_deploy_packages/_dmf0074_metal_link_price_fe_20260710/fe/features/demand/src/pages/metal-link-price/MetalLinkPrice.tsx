import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ItemByDivisionModal, ProjectByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { Alert, MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

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
      void setAlert({ type: 'alert', content: t(MSG.PERIOD_INVERTED, '_Invalid period (start > end).') });
      return false;
    }
    // MSG00097 — Division 공란 (.cs L421)
    if (!searchParams.divisionId) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRE_DIVISION, '_Please select Division.') });
      return false;
    }
    return true;
  };

  // F5 Search — refetch?.() 직접 호출 금지 (stale closure — setFilter + invalidateQueries 표준)
  const handleSearch = () => {
    if (!validateFind()) return;
    void setToast({ message: t('LBL00665', '_Loading...'), type: 'default', duration: 2000 });
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
      void setAlert({ type: 'alert', content: t(MSG.REQUIRE_DIVISION, '_Please select Division.') });
      return;
    }
    setOpenTemplateModal(true);
  };

  // SubTitle customButtons 표준 — {label, action} (subtitle-button-actions-mandatory)
  const customButtons = useMemo(
    () =>
      hasButton('SEARCH')
        ? [{ label: t('LBL00762', 'Excel Form'), action: handleOpenTemplate }]
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
          닫힘 후 재조회 confirm (MSG00265 Yes→refetch) */}
      <FcstUploadModal
        open={openUploadModal}
        modalClose={() => setOpenUploadModal(false)}
        menuId={uploadFormId}
        sheetName={SHEETS.MAIN}
        attributeHeaders={uploadHeaders}
        onUploaded={() => {
          void (async () => {
            const ok = await setAlert({
              type: 'confirm',
              content: t(MSG.UPLOAD_DONE, '_Excel upload completed. Refresh now?'),
            });
            if (ok && hasSearched) {
              void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
            }
          })();
        }}
      />
      <Alert />
    </>
  );
};
