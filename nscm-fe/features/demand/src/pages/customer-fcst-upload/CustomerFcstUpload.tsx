import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ItemByDivisionModal, ProjectByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import type { EditTracker } from '@foundation/utils';
import { Alert, MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { FcstUploadModal } from '../../components';

import { CustomerFcstUploadForm } from './components/CustomerFcstUploadForm';
import { CustomerFcstUploadGrid } from './components/CustomerFcstUploadGrid';
import { MENU_ID, MSG, SAVE_KEYS, SHEETS } from './customer-fcst-upload.constant';
import type { CustomerFcstUploadRow, SaveEntry, SpreadTitleRow } from './customer-fcst-upload.types';
import { useCustomerFcstUploadStore } from './useCustomerFcstUploadStore';

// AS-IS DMF0014_CustFcstUpload (Demand > Demand Plan > Customer FCST Upload).
//   편집형 화면 — 데이터 유입 주 경로 = Excel 업로드 (공통 FileController excel-upload 체인,
//   사내 최초 소비 화면). 직접 INSERT 는 AS-IS InsertRow 가 MSG00380 차단 (.cs L786~818 1:1).
//   그리드 편집 = EDIT_FLAG='Y' 행의 동적 D_ 기간 셀만 (AS-IS EditButton SwitchLock 판정 1:1 —
//   F2 토글은 TO-BE 표준(mkt-fcst)대로 상시 판정으로 대체, __asis-mapping__ 기록).
//   SP: PKG_DMF0014.P_DMF0014_GET_CUST_FCST_UPLOAD_DATA(메인) + P_DMF0014_GET_SPREAD_TITLE(기간 헤더)
//       + PR_GET_DAY_RANGE(기본 조회구간) + P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA(저장 '^' 17키).
export const CustomerFcstUpload = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGrid<CustomerFcstUploadRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  // ⭐ 그리드 공용 EditTracker — 변경 셀의 단일 진실원('M' 표기와 동일 출처). 저장 payload 는 여기서 도출.
  const editTrackerRef = useRef<EditTracker<CustomerFcstUploadRow>>();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const queryClient = useQueryClient();

  const isOpenSearchArea = useCustomerFcstUploadStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useCustomerFcstUploadStore(state => state.setOpenSearchArea);
  const searchParams = useCustomerFcstUploadStore(state => state.searchParams);
  const setSearchParams = useCustomerFcstUploadStore(state => state.setSearchParams);
  const filters = useCustomerFcstUploadStore(state => state.filters);
  const setFilters = useCustomerFcstUploadStore(state => state.setFilters);
  const clearFilters = useCustomerFcstUploadStore(state => state.clearFilters);
  const fetchStaticColumns = useCustomerFcstUploadStore(state => state.fetchStaticColumns);
  const dayRangeApplied = useCustomerFcstUploadStore(state => state.dayRangeApplied);
  const applyDayRange = useCustomerFcstUploadStore(state => state.applyDayRange);

  // ui-dynamic-property-management — Menu Button 권한 동적 fetch
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // ⭐ 명시 조회 게이트 — persist 된 stale filters 자동 발사 차단 (DMF0048 선례)
  const [hasSearched, setHasSearched] = useState(false);

  const [openPrjByDivisionModal, setOpenPrjByDivisionModal] = useState<boolean>(false);
  const [openModelByDivisionModal, setOpenModelByDivisionModal] = useState<boolean>(false);
  const [openFcstUploadModal, setOpenFcstUploadModal] = useState<boolean>(false);

  // ⭐ SetSaveData 1:1 — 변경 D_ 셀 수집 (dedup 키 = 식별 10 + yyyymmdd, 동일 키 = qty 덮어쓰기)
  const saveEntriesRef = useRef<Map<string, SaveEntry>>(new Map());

  // 메인 그리드 SP — PKG_DMF0014.P_DMF0014_GET_CUST_FCST_UPLOAD_DATA (13 IN + 세션 2 + O_RC1/O_RESULT)
  const { data, isFetching } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: hasSearched && !!filters[SHEETS.MAIN],
  });

  // 동적 기간 헤더 SP — PKG_DMF0014.P_DMF0014_GET_SPREAD_TITLE (3 IN + 세션 2 + O_RC1)
  const { data: spreadTitleData } = useTabProcQuery<MENU_ID, SHEETS.SPREAD_TITLE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SPREAD_TITLE,
    tabId,
    filters: filters[SHEETS.SPREAD_TITLE],
    enabled: hasSearched && !!filters[SHEETS.SPREAD_TITLE],
  });
  const spreadTitleRows = (spreadTitleData as { o_rc1?: SpreadTitleRow[] })?.o_rc1 ?? [];

  // ⭐ 기본 조회구간 — PR_GET_DAY_RANGE (AS-IS GetDayRange p_month=6, .cs L1229~1243 1:1.
  //   적용 여부는 store persist — 탭 수명 내 1회, 사용자가 변경한 Period 미덮음. DMF0048 A-4)
  const dayRangeFilters = useMemo(() => ({ createdBy: '', month: '6' }), []);
  const { data: dayRangeData } = useTabProcQuery<MENU_ID, SHEETS.DAY_RANGE>({
    menuId: MENU_ID,
    sheetName: SHEETS.DAY_RANGE,
    tabId,
    filters: dayRangeFilters,
    enabled: !dayRangeApplied,
  });
  useEffect(() => {
    const range = (dayRangeData as { o_rc2?: { DAY_RANGE?: string }[] })?.o_rc2?.[0]?.DAY_RANGE;
    if (!range) return;
    applyDayRange(range);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [dayRangeData]);

  // mount 시 1회 admin 메타 fetch + persist 된 이전 filters 무효화 (NULL payload SP 자동호출 방지)
  useEffect(() => {
    clearFilters();
    saveEntriesRef.current.clear();
    editTrackerRef.current?.clearChanges();
    void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // ----- 조회 validation (AS-IS FindData L564~590 1:1) -----
  const validateFind = (): boolean => {
    if (isFetching) return false;
    // MSG00097 — Division 필수 (.cs L566~571)
    if (!searchParams.divisionId) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRE_DIVISION, '_Please select Division.') });
      return false;
    }
    // MSG00108 — 기간 역전 (.cs L577~581)
    if (Number(searchParams.startYyyymmdd) > Number(searchParams.endYyyymmdd)) {
      void setAlert({ type: 'alert', content: t(MSG.PERIOD_INVERTED, '_Invalid period (start > end).') });
      return false;
    }
    // MSG00164 — 기간 상한 2년 (.cs L583~590: Value1.AddYears(2) < Value2 — 문구(3년)/조건(2년)
    //   불일치는 AS-IS 자체 상태 1:1 보존)
    const limit = `${Number(searchParams.startYyyymmdd.slice(0, 4)) + 2}${searchParams.startYyyymmdd.slice(4)}`;
    if (Number(searchParams.endYyyymmdd) > Number(limit)) {
      void setAlert({ type: 'alert', content: t(MSG.PERIOD_MAX, '_Please enter a period within 3 years.') });
      return false;
    }
    return true;
  };

  // F5 Search — refetch?.() 직접 호출 금지 (stale closure — setFilter + invalidateQueries 표준)
  const handleSearch = () => {
    if (!validateFind()) return;
    void setToast({ message: t('LBL00665', '_Loading...'), type: 'default', duration: 2000 });
    setHasSearched(true);
    saveEntriesRef.current.clear(); // AS-IS FindData dtSave.Clear() 1:1
    editTrackerRef.current?.clearChanges();
    setFilters();
    void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
    void fetchStaticColumns();
  };

  // ----- spdMain_Changed 1:1 — D_ 셀 편집 → 필수 11건 검증(MSG00429 {label}) + SetSaveData 수집 -----
  const requiredChecks: { key: keyof CustomerFcstUploadRow; label: string }[] = [
    { key: 'DIVISION_ID', label: 'Division*' },
    { key: 'SCM_SITE_ID', label: 'Sales Site*' },
    { key: 'CUSTOMER_PROJECT_CODE', label: 'Customer Project*' },
    { key: 'CUSTOMER_MODEL', label: 'Customer Model*' },
    { key: 'INCOTERMS', label: 'Incoterms*' },
    { key: 'FCST_TYPE', label: 'FCST Type*' },
    { key: 'DOM_EXP', label: 'Customs Handbook*' },
    { key: 'MEASURE_GROUP', label: 'Measure Group*' },
    { key: 'MEASURE', label: 'Measure*' },
    // PLANT_SITE_ID 는 Division 81 만 필수 (.cs L1077~1082) — 아래에서 조건 분기
    { key: 'UPLOAD_UOM', label: 'Upload UOM*' },
  ];

  const handleCellEdited = (item: CustomerFcstUploadRow, binding: string) => {
    const s = (v: unknown): string =>
      typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
    // 필수 11건 (AS-IS spdMain_Changed L1022~1088 순서 1:1 — MSG00429 = AS-IS MSG00002 의미)
    for (const chk of requiredChecks) {
      if (s(item[chk.key]) === '') {
        void setAlert({
          type: 'alert',
          content: t(MSG.REQUIRED_VALUE, '_{0} value is required.').replace('{0}', chk.label),
        });
        return;
      }
    }
    if (s(item.PLANT_SITE_ID) === '' && s(item.DIVISION_ID) === '81') {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_VALUE, '_{0} value is required.').replace('{0}', 'Plant Site*'),
      });
      return;
    }

    // SetSaveData (.cs L1113~1159 1:1) — dedup 키 11 + qty 갱신
    const qtyRaw = s(item[binding]).replace(/,/g, '');
    const qty = qtyRaw === '' ? '0' : String(parseInt(qtyRaw, 10) || 0);
    const entry: SaveEntry = {
      divisionId: s(item.DIVISION_ID),
      scmSiteId: s(item.SCM_SITE_ID),
      customerProjectCode: s(item.CUSTOMER_PROJECT_CODE),
      customerModel: s(item.CUSTOMER_MODEL),
      incoterms: s(item.INCOTERMS),
      fcstType: s(item.FCST_TYPE),
      domExp: s(item.DOM_EXP),
      measureGroup: s(item.MEASURE_GROUP),
      measure: s(item.MEASURE),
      plantSiteId: s(item.PLANT_SITE_ID),
      uploadUom: s(item.UPLOAD_UOM),
      projectCode: s(item.PROJECT_CODE),
      itemId: s(item.ITEM_ID),
      yyyymmdd: binding.replace('D_', ''),
      qty,
    };
    const dedupKey = [
      entry.divisionId,
      entry.scmSiteId,
      entry.customerProjectCode,
      entry.customerModel,
      entry.incoterms,
      entry.fcstType,
      entry.domExp,
      entry.measureGroup,
      entry.measure,
      entry.plantSiteId,
      entry.yyyymmdd,
    ].join('|');
    saveEntriesRef.current.set(dedupKey, entry);
  };

  // ----- F7 Save — AS-IS SaveData 1:1: 'M' 고정 + 17 키 '^'delim payload -----
  //   ^delim 다건이므로 apiClient.post 직접 (useProcMutation array unfold 안 함 — 표준 선례)
  const handleSave = async () => {
    // ⭐ 근본 수정 (2026-07-08) — 저장 payload 를 그리드 공용 EditTracker 에서 직접 도출한다.
    //   기존 별도 수집 ref(saveEntriesRef)는 편집↔저장 사이 재렌더/재등록 타이밍에 취약해
    //   2행 이후 편집분이 유실("저장할 데이터 없음") → EditTracker('M' 표기와 동일·안정 출처)로 일원화.
    //   (1) 열린 편집기 강제 커밋 → (2) EditTracker 변경맵 순회로 D_ 기간 셀 net 변경만 수집.
    gridRef.current?.finishEditing(true);

    const toStr = (v: unknown): string =>
      typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
    const changed = editTrackerRef.current?.getOriginalValues();
    const entries: SaveEntry[] = [];
    if (changed) {
      for (const [item, fields] of changed) {
        const rec = item as unknown as Record<string, unknown>;
        for (const binding of Object.keys(fields)) {
          if (!/^D_\d{8}$/.test(binding)) continue; // 편집 가능 셀 = 동적 D_ 기간 셀만
          // 필수 11건 검증 (AS-IS spdMain_Changed 1:1) — 저장 시점 재검증
          for (const chk of requiredChecks) {
            if (toStr(item[chk.key]) === '') {
              void setAlert({
                type: 'alert',
                content: t(MSG.REQUIRED_VALUE, '_{0} value is required.').replace('{0}', chk.label),
              });
              return;
            }
          }
          if (toStr(item.PLANT_SITE_ID) === '' && toStr(item.DIVISION_ID) === '81') {
            void setAlert({
              type: 'alert',
              content: t(MSG.REQUIRED_VALUE, '_{0} value is required.').replace('{0}', 'Plant Site*'),
            });
            return;
          }
          const qtyRaw = toStr(rec[binding]).replace(/,/g, '');
          const qty = qtyRaw === '' ? '0' : String(parseInt(qtyRaw, 10) || 0);
          entries.push({
            divisionId: toStr(item.DIVISION_ID),
            scmSiteId: toStr(item.SCM_SITE_ID),
            customerProjectCode: toStr(item.CUSTOMER_PROJECT_CODE),
            customerModel: toStr(item.CUSTOMER_MODEL),
            incoterms: toStr(item.INCOTERMS),
            fcstType: toStr(item.FCST_TYPE),
            domExp: toStr(item.DOM_EXP),
            measureGroup: toStr(item.MEASURE_GROUP),
            measure: toStr(item.MEASURE),
            plantSiteId: toStr(item.PLANT_SITE_ID),
            uploadUom: toStr(item.UPLOAD_UOM),
            projectCode: toStr(item.PROJECT_CODE),
            itemId: toStr(item.ITEM_ID),
            yyyymmdd: binding.replace('D_', ''),
            qty,
          });
        }
      }
    }
    if (entries.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.NO_SAVE_DATA, '_No data to save.') });
      return;
    }
    const ok = await setAlert({ type: 'confirm', content: t(MSG.CONFIRM_SAVE, '_Save the changes?') });
    if (!ok) return;

    const sesUserId = useSessionStore.getState().session.userId ?? '';
    // ⭐ createdByList — BE 가 가로채지 않는 키명 (createdBy 는 BE 세션 단일값으로 덮여 '^'×N 배열이
    //   1토큰으로 붕괴 → SP split 2행째부터 CREATED_BY NULL → ORA-01400. DMF0020 선례 동일, 2026-07-08).
    const rows = entries.map(e => ({ ...e, activeFlag: 'M', createdByList: sesUserId }));
    const payload = Object.fromEntries(
      SAVE_KEYS.map(k => [k, rows.map(r => r[k]).join('^')])
    );

    void setToast({ message: t('LBL00665', '_Loading...'), type: 'default', duration: 3000 });
    try {
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`,
        payload
      );
      if (res.status >= 400 || Number(res.data?.code)) {
        const reason =
          (res.data as { message?: string })?.message?.trim() ||
          t('MSG00618', '_An error occurred while saving.');
        void setAlert({ type: 'alert', content: reason });
        return;
      }
      void setToast({ message: t('MSG00606', '_Saved.'), type: 'success' });
      saveEntriesRef.current.clear();
      editTrackerRef.current?.clearChanges();
      // AS-IS SaveData 성공 후 FindButton() 재조회 1:1
      void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
    } catch (e) {
      const msg = e instanceof Error ? e.message : t('MSG00618', '_An error occurred while saving.');
      void setAlert({ type: 'alert', content: msg });
    }
  };

  // F8 Insert — AS-IS InsertRow 1:1: 직접 INSERT 차단 안내 (MSG00380, 원 행추가 로직은 주석 데드코드)
  const handleInsert = () => {
    void setAlert({
      type: 'alert',
      content: t(MSG.INSERT_BLOCKED, '_Direct Insert is not allowed. Please use Excel Upload.'),
    });
  };

  // F9 Delete — AS-IS DeleteButton 1:1: Action='I'(신규) 행만 삭제. 신규행 경로가 차단된 화면이므로
  //   실질 no-op (AS-IS 도 기존 행에서 무반응) — 버튼은 AS-IS 대로 표시.
  const handleDelete = () => undefined;

  // SubTitle 공통버튼 — hasButton 권한 분기. excel/sort/filter/condition = DefaultButtonActions 자동.
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    delete: hasButton('DELETE') ? handleDelete : false,
    save: hasButton('SAVE') ? handleSave : false,
    manual: false,
    upload: hasButton('UPLOAD') ? () => setOpenFcstUploadModal(true) : false,
  };

  const rows = (data as { o_rc1?: CustomerFcstUploadRow[] })?.o_rc1 ?? [];

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <CustomerFcstUploadForm
        onSubmit={handleSearch}
        setOpenPrjByDivisionModal={setOpenPrjByDivisionModal}
        setOpenModelByDivisionModal={setOpenModelByDivisionModal}
      />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='Customer-Fcst-Upload'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <CustomerFcstUploadGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        data={rows}
        spreadTitle={spreadTitleRows}
        onCellEdited={handleCellEdited}
      />
      {/* AS-IS btnProject_Click (.cs L923~942) — SCM0002_ProjectbyDivisionPopupEx 1:1 */}
      <ProjectByDivisionModal
        open={openPrjByDivisionModal}
        modalClose={() => setOpenPrjByDivisionModal(false)}
        setSelectedValue={projects => setSearchParams({ project: projects })}
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
      {/* AS-IS btmItem_Click (.cs L944~969) — DM0002_ItembyDivisionPopupEx 1:1 */}
      <ItemByDivisionModal
        open={openModelByDivisionModal}
        modalClose={() => setOpenModelByDivisionModal(false)}
        setSelectedValue={items => setSearchParams({ modelNickname: items })}
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
      {/* AS-IS btnExcelUpload_Click — 공통 ExcelUploadForm("DMF0014", 'FCST Upload') 1:1.
          ⭐ 2-Step (사용자 요구 2026-07-10): [Upload]=검증·분류 / [OK]=저장(onSave — mode=1 call-proc).
          SP 게이트 복원(P_MODE>0)으로 mode=0 은 검증만, mode=1 이 DM_PLN_CUSTOMER_PSI 적재. 전량 게이트. */}
      <FcstUploadModal
        open={openFcstUploadModal}
        modalClose={() => setOpenFcstUploadModal(false)}
        onSave={async () => {
          // PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD(mode=1) — 검증 통과분 적재.
          //   createdBy=BE 세션 자동 · V_CREATION_DATE=MAX(최신 배치 자동 선택).
          const sesUserId = useSessionStore.getState().session.userId ?? '';
          try {
            const res = await apiClient.post<Record<string, unknown>>(
              `/${MENU_ID}/${SHEETS.MAIN}/UPLOAD_SAVE/call-proc`,
              { mode: 1, createdBy: sesUserId, programId: MENU_ID, sheetName: SHEETS.MAIN }
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
        }}
        onUploaded={() => {
          void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
        }}
      />
      <Alert />
    </>
  );
};
