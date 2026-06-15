import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { FlexGridXlsxConverter } from '@mescius/wijmo.grid.xlsx';
import { ItemByDivisionModal, ProjectByDivisionModal } from 'features/master/src/components';
import { useEffect, useRef, useState } from 'react';

import _ from '@foundation/lodash';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { Alert, MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { FcstUploadModal } from '../../components';

import { CustomerFcstUploadForm } from './components/CustomerFcstUploadForm';
import { CustomerFcstUploadGrid } from './components/CustomerFcstUploadGrid';
import { MENU_ID, MSG, SHEETS } from './customer-fcst-upload.constant';
import { useCustomerFcstUploadValidation } from './hooks/useCustomerFcstUploadValidation';
import type { CustomerFcstUploadRow } from './customer-fcst-upload.types';
import { useCustomerFcstUploadStore } from './useCustomerFcstUploadStore';

// AS-IS DMF0014_CustFcstUpload.cs (1,275줄) — Customer FCST Upload
//   - PKG_DMF0014: 5 SP (메인 GET / SPREAD_TITLE / SAVE / EXCEL_UPLOAD 1,541줄 / EXCEL_UPLOAD_SM)
//   - 12 events / 20 validation / Sheet 1 + 동적 시간축
//   - 분석서: Doc/_analysis/domain_DM/screens/DMF0014_CustFcstUpload/ (8 MD 기존)
//   - __asis-mapping__.md: 본 폴더 (4축 100%)
//   - 메타: _artifacts/_deploy_packages/DMF0014/03_META/010_DMF0014_meta.sql
//
// ⭐ 2026-06-07 정식 완성 보강:
//   - MENU_ID 소문자 'dmf0014' → 'DMF0014' (자매 표준 + 메타 case 일치)
//   - useCustomerFcstUploadValidation hook 신규 (20 검증)
//   - handleSave (F7) wiring — P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA (17 IN)
//   - handleDelete (F9) — EditFlag 'D' 마킹
//   - Viewer 권한 시 Excel Upload button hide (AS-IS DefineProperty L310~314)
export const CustomerFcstUpload = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGrid<CustomerFcstUploadRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;

  // 세션 — Viewer 권한 확인 (AS-IS DefineProperty L310~314)
  //   NowGroupID 에 'Viewer' 포함 → btnExcelUpload hide
  const groupId = useSessionStore(state => state.session?.groupId ?? '');
  const isViewer = groupId.toLowerCase().includes('viewer');

  const isOpenSearchArea = useCustomerFcstUploadStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useCustomerFcstUploadStore(state => state.setOpenSearchArea);
  const searchParams = useCustomerFcstUploadStore(state => state.searchParams);
  const filters = useCustomerFcstUploadStore(state => state.filters);
  const setFilters = useCustomerFcstUploadStore(state => state.setFilters);
  const initialized = useCustomerFcstUploadStore(state => state.initialized);
  const fetchStaticColumns = useCustomerFcstUploadStore(state => state.fetchStaticColumns);

  const validate = useCustomerFcstUploadValidation();

  const [openPrjByDivisionModal, setOpenPrjByDivisionModal] = useState<boolean>(false);
  const [openModelByDivisionModal, setOpenModelByDivisionModal] = useState<boolean>(false);
  const [openFcstUploadModal, setOpenFcstUploadModal] = useState<boolean>(false);

  const { data, refetch } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.CUSTOMER_FCST_UPLOAD,
    tabId,
    filters,
    enabled: !!filters,
  });

  // F7 Save — SP P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA (17 IN + 1 OUT)
  //   AS-IS .cs L460+ SaveData — ^-delim multi-row 일괄 저장
  const saveMutation = useProcMutation<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.CUSTOMER_FCST_UPLOAD,
    mnuBtnCd: 'SAVE',
  });

  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
  }, [tabId]);

  // F5 Search — 검증 + setFilters + refetch
  const handleSubmit = () => {
    const v = validate.validateFind(searchParams);
    if (!v.ok) return;
    if (_.isEqual(searchParams, filters)) void refetch();
    else setFilters();
  };

  // F7 Save — AS-IS SaveData (L460+)
  //   1) Grid 의 dirty row 추출 (CRUD_TYPE in 'I'/'U'/'D')
  //   2) Zod schema validation
  //   3) ^-delim multi-row payload 빌드
  //   4) saveMutation 호출 → 성공 시 refetch
  const handleSave = async () => {
    const g = gridRef.current;
    if (!g) return;
    const allRows = (g.itemsSource as CustomerFcstUploadRow[]) ?? [];
    const dirtyRows = allRows.filter(r => r.CRUD_TYPE === 'I' || r.CRUD_TYPE === 'U' || r.EDIT_FLAG === 'D');

    const v = validate.validateSaveRows(dirtyRows);
    if (!v.ok) return;

    const ok = await setAlert({ type: 'confirm', content: `[${MSG.CONFIRM_SAVE}] 저장하시겠습니까?` });
    if (!ok) return;

    void setToast({ message: '저장 중입니다...', type: 'default', duration: 2000 });

    // ^-delim payload (17 IN params) — AS-IS SP signature 매칭
    const j = (key: keyof CustomerFcstUploadRow): string =>
      dirtyRows.map(r => String(r[key] ?? '')).join('^');
    const payload: Record<string, string> = {
      activeFlag:          dirtyRows.map(r => r.EDIT_FLAG ?? r.CRUD_TYPE ?? 'U').join('^'),
      divisionId:          j('DIVISION_ID'),
      scmSiteId:           j('SCM_SITE_ID'),
      customerProjectCode: j('CUSTOMER_PROJECT_CODE'),
      customerModel:       j('CUSTOMER_MODEL'),
      incoterms:           j('INCOTERMS'),
      fcstType:            j('FCST_TYPE'),
      domExp:              j('DOM_EXP'),
      measureGroup:        j('MEASURE_GROUP'),
      measure:             j('MEASURE'),
      plantSiteId:         j('PLANT_SITE_ID'),
      uploadUom:           j('UPLOAD_UOM'),
      projectCode:         j('PROJECT_CODE'),
      itemId:              j('ITEM_ID'),
      yyyymmdd:            j('YYYYMMDD'),
      qty:                 j('QTY'),
      // sesUserId 는 BE 자동 채움
    };

    try {
      await saveMutation.mutateAsync(payload as never);
      void setToast({ message: '저장되었습니다.', type: 'success', duration: 2000 });
      void refetch();
    } catch (e) {
      void setAlert({ type: 'alert', content: `저장 실패: ${String(e)}` });
    }
  };

  // F9 Delete — 선택 행 EditFlag 'D' 마킹 (실 삭제는 F7 Save 시 일괄)
  //   AS-IS DeleteButton (BaseForm default)
  const handleDelete = async () => {
    const g = gridRef.current;
    if (!g) return;
    const sel = g.selectedItems as CustomerFcstUploadRow[] | undefined;
    const v = validate.validateDelete(sel ?? []);
    if (!v.ok) return;

    const ok = await setAlert({ type: 'confirm', content: `[${MSG.CONFIRM_DELETE}] 선택 행을 삭제 마킹하시겠습니까?` });
    if (!ok) return;

    sel?.forEach(row => {
      row.CRUD_TYPE = 'D';
      row.EDIT_FLAG = 'D';
    });
    g.refresh();
    void setToast({ message: '삭제 마킹되었습니다. F7 Save 로 확정.', type: 'default', duration: 2000 });
  };

  // F12 Excel — AS-IS L496~540 SimplexelService.ExportFpSpread → Wijmo FlexGridXlsxConverter
  //   (Option A 정정: 이전 'excel: false' → AS-IS 는 ExcelButton override 실제 구현 있음)
  const handleExcel = async () => {
    const g = gridRef.current;
    if (!g) return;
    const fileName = `DMF0014_CustFcstUpload_${new Date().toISOString().slice(0, 19).replace(/[-:T]/g, '')}.xlsx`;
    try {
      await FlexGridXlsxConverter.saveAsync(g, {
        includeColumnHeaders: true,
        includeRowHeaders: false,
        includeStyles: true,
      } as never, fileName);
      void setToast({ message: 'Excel 다운로드 완료', type: 'success', duration: 2000 });
    } catch (e) {
      void setAlert({ content: `Excel 다운로드 실패: ${String(e)}` });
    }
  };

  // hotkeyConfig — CRUD 활성 + Viewer 권한 시 upload hide (AS-IS L310~314)
  //   AS-IS Insert (L786~792) : MSG00380 alert 만 (실 코드 주석 — Excel Upload 사용 권장)
  //   AS-IS Delete (L451~457) : Insert 'I' 행만 즉시 제거 (영구 삭제 X)
  //   AS-IS Save  (L652~784) : 모든 dirty row ActionFlag='M' (수정만)
  //   AS-IS Excel (L496~540) : SimplexelService → Wijmo XlsxConverter (handleExcel 신규)
  const hotkeyConfig: HotkeyConfig = {
    search: handleSubmit,
    save: handleSave,
    delete: handleDelete,
    excel: handleExcel,
    manual: false,
    upload: isViewer ? false : () => setOpenFcstUploadModal(true),
    insert: async () => {
      // AS-IS InsertRow L786~792: MSG00380 "insert 사용 불가" alert (실 코드 주석 처리 — Excel Upload 사용 권장)
      await setAlert({
        content: '[MSG00380] Insert 사용 불가. Excel Upload 를 사용해주세요.',
      });
    },
  };

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <CustomerFcstUploadForm
        onSubmit={handleSubmit}
        setOpenPrjByDivisionModal={setOpenPrjByDivisionModal}
        setOpenModelByDivisionModal={setOpenModelByDivisionModal}
      />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={data?.o_rc1?.length ?? 0}
        excelFileName='Customer-Fcst-Upload'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <CustomerFcstUploadGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        data={(data?.o_rc1 ?? []) as never}
      />
      <ProjectByDivisionModal
        open={openPrjByDivisionModal}
        modalClose={() => setOpenPrjByDivisionModal(false)}
        setSelectedValue={() => {}}
        preSearchParams={{
          deptId:      searchParams.team || 'ALL',
          divisionId:  searchParams.divisionId,
          endCustomer: searchParams.endCustomer || 'ALL',
          etc: '',
          projectCode: searchParams.project || '',
          salesSite:   searchParams.salesSite || 'ALL',
        }}
        callFromCell={false}
      />
      <ItemByDivisionModal
        open={openModelByDivisionModal}
        modalClose={() => setOpenModelByDivisionModal(false)}
        setSelectedValue={() => {}}
        preSearchParams={{
          deptId:      searchParams.team || 'ALL',
          divisionId:  searchParams.divisionId,
          endCustomer: searchParams.endCustomer || 'ALL',
          salesSite:   searchParams.salesSite || 'ALL',
          projectCode: searchParams.project || '',
          itemId:      searchParams.modelNickname || '',
          activeFlag:  'Y',
        }}
        callFromCell={false}
      />
      <FcstUploadModal
        open={openFcstUploadModal}
        modalClose={() => setOpenFcstUploadModal(false)}
      />
      <Alert />
    </>
  );
};
