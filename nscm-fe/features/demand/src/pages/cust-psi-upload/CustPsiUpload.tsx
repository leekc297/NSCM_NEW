import { FileExceluploadIcon } from '@lges/design-system/icon';
import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ItemByDivisionModal, ProjectByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { type EditTracker, GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { FileExceldownloadIcon } from '@shared/lges-icons';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { FcstUploadModal } from '../../components';

import { CustPsiTemplateModal } from './components/CustPsiTemplateModal';
import { CustPsiUploadForm } from './components/CustPsiUploadForm';
import { CustPsiUploadGrid } from './components/CustPsiUploadGrid';
import {
  MEASURE_GROUP_FIXED,
  MENU_ID,
  MSG,
  SAVE_KEYS,
  SHEETS,
} from './cust-psi-upload.constant';
import type { CustPsiUploadRow, SaveEntry, SpreadTitleRow } from './cust-psi-upload.types';
import { useCustPsiUploadStore } from './useCustPsiUploadStore';

// Excel Upload 모달 Error Detail grid 라벨 — ATTRIBUTE1~13 순서 (SCM_ADM_EXCEL_COLUMNS.HEADER_CONTENT).
//   DMF0013 은 DMF0014 를 복제한 화면이라 컬럼 헤더가 동일하다 (원장 §0.3).
const PSI_UPLOAD_HEADERS = [
  'Division*',
  'Sales Site*',
  'Plant Site*',
  'Customer Project*',
  'Customer Model*',
  'Incoterms*',
  'FCST Type*',
  'DOM/EXP*',
  'Measure Group*',
  'Measure*',
  'Upload UOM*',
  'Project',
  'Model',
];

// AS-IS DMF0013_CustPsiUpload (Demand > Demand Plan > Customer PSI Upload).
//   DMF0014_CustFcstUpload 를 복제·파생한 편집형 화면 (원장 §0.3) — MeasureGroup 고정값만 "PSI".
//   데이터 유입 = Excel 업로드(공통 FileController excel-upload) + 그리드 직접 입력 + F8 행 삽입.
//   주의: DMF0013 은 AS-IS InsertRow(F8) 가 활성이다(원장 §E12) — DMF0014 가 데드코드로 버린
//     삽입·Division81 분기를 존치한다(portspec §8-1 오케스트레이터 결정 (b), 이관 기본값).
//   그리드 편집 = EDIT_FLAG='Y' 행/신규행의 동적 D_ 기간 셀 + 신규행 속성 셀(부분 개방).
//   SP: DM.DMF0013_GET_CUST_PSI_UPLOAD_DATA(메인) + DM.DMF0014_GET_SPREAD_TITLE(공유 기간 헤더)
//       + PR_GET_DAY_RANGE(기본 조회구간) + DM.DMF0013_SAVE_CUST_PSI_UPLOAD_DATA(저장 '^' 17키).
export const CustPsiUpload = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGrid<CustPsiUploadRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  // 그리드 공용 EditTracker — 변경 셀의 단일 진실원('M' 표기와 동일 출처). 저장 payload 는 여기서 도출.
  const editTrackerRef = useRef<EditTracker<CustPsiUploadRow>>();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;
  const queryClient = useQueryClient();

  const isOpenSearchArea = useCustPsiUploadStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useCustPsiUploadStore(state => state.setOpenSearchArea);
  const searchParams = useCustPsiUploadStore(state => state.searchParams);
  const setSearchParams = useCustPsiUploadStore(state => state.setSearchParams);
  const filters = useCustPsiUploadStore(state => state.filters);
  const setFilters = useCustPsiUploadStore(state => state.setFilters);
  const clearFilters = useCustPsiUploadStore(state => state.clearFilters);
  const staticColumn = useCustPsiUploadStore(state => state.staticColumn);
  const fetchStaticColumns = useCustPsiUploadStore(state => state.fetchStaticColumns);
  const dayRangeApplied = useCustPsiUploadStore(state => state.dayRangeApplied);
  const applyDayRange = useCustPsiUploadStore(state => state.applyDayRange);

  // ui-dynamic-property-management — Menu Button 권한 동적 fetch
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // 명시 조회 게이트 — persist 된 stale filters 자동 발사 차단
  const [hasSearched, setHasSearched] = useState(false);
  // 저장 in-flight — 재진입(더블클릭) 차단용
  const [isPending, setIsPending] = useState(false);

  const [openPrjByDivisionModal, setOpenPrjByDivisionModal] = useState<boolean>(false);
  const [openModelByDivisionModal, setOpenModelByDivisionModal] = useState<boolean>(false);
  const [openFcstUploadModal, setOpenFcstUploadModal] = useState<boolean>(false);
  const [openTemplateModal, setOpenTemplateModal] = useState<boolean>(false);

  // SetSaveData 1:1 — 변경 D_ 셀 수집 (dedup 키 = 식별 11 + yyyymmdd, 동일 키 = qty 덮어쓰기)
  const saveEntriesRef = useRef<Map<string, SaveEntry>>(new Map());

  // 메인 그리드 SP — DM.DMF0013_GET_CUST_PSI_UPLOAD_DATA (13 IN + 세션 2 + O_RC1)
  const { data, isFetching } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: hasSearched && !!filters[SHEETS.MAIN],
  });

  // 동적 기간 헤더 SP — 공유 DM.DMF0014_GET_SPREAD_TITLE (3 IN + 세션 2 + O_RC1)
  const { data: spreadTitleData } = useTabProcQuery<MENU_ID, SHEETS.SPREAD_TITLE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SPREAD_TITLE,
    tabId,
    filters: filters[SHEETS.SPREAD_TITLE],
    enabled: hasSearched && !!filters[SHEETS.SPREAD_TITLE],
  });
  const spreadTitleRows = (spreadTitleData as { o_rc1?: SpreadTitleRow[] })?.o_rc1 ?? [];

  // 기본 조회구간 — PR_GET_DAY_RANGE (AS-IS GetDayRange p_month=6). 적용 여부는 store persist.
  const dayRangeFilters = useMemo(() => ({ createdBy: '', month: '6' }), []);
  const { data: dayRangeData } = useTabProcQuery<MENU_ID, SHEETS.DAY_RANGE>({
    menuId: MENU_ID,
    sheetName: SHEETS.DAY_RANGE,
    tabId,
    filters: dayRangeFilters,
    enabled: !dayRangeApplied,
  });
  useEffect(() => {
    const range = (dayRangeData as { o_rc1?: { DAY_RANGE?: string }[] })?.o_rc1?.[0]?.DAY_RANGE;
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

  // ----- 조회 validation (AS-IS FindData L396~420 1:1) -----
  const validateFind = (): boolean => {
    if (isFetching) return false;
    // MSG00097 — Division 필수 (원장 §E10 L398)
    if (!searchParams.divisionId) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRE_DIVISION, '_Please select Division.'),
      });
      return false;
    }
    // MSG00108 — 기간 역전 (원장 §E10 L409)
    if (Number(searchParams.startYyyymmdd) > Number(searchParams.endYyyymmdd)) {
      void setAlert({
        type: 'alert',
        content: t(MSG.PERIOD_INVERTED, '_Invalid period (start > end).'),
      });
      return false;
    }
    // MSG00164 — 기간 상한 2년 (원장 §E10 L413: AddYears(2) < Value2. 문구/조건 불일치는 AS-IS 상태 1:1 보존)
    const limit = `${Number(searchParams.startYyyymmdd.slice(0, 4)) + 2}${searchParams.startYyyymmdd.slice(4)}`;
    if (Number(searchParams.endYyyymmdd) > Number(limit)) {
      void setAlert({
        type: 'alert',
        content: t(MSG.PERIOD_MAX, '_Please enter a period within 2 years.'),
      });
      return false;
    }
    return true;
  };

  // F5 Search — refetch 직접 호출 금지 (stale closure). setFilter + invalidateQueries([tabId]) 표준.
  const handleSearch = () => {
    if (!validateFind()) return;
    void setToast({ message: t('LBL00665', '_Loading...'), type: 'default', duration: 2000 });
    setHasSearched(true);
    saveEntriesRef.current.clear(); // AS-IS FindData dtSave.Clear() 1:1
    editTrackerRef.current?.clearChanges();
    setFilters();
    void queryClient.invalidateQueries({ queryKey: [tabId] });
    void fetchStaticColumns();
  };

  // Grid 초기화 규약 — Division 변경 시 결과·미저장 편집 폐기. 자동 재조회하지 않는다(Search 로만).
  const resetGrid = () => {
    saveEntriesRef.current.clear();
    editTrackerRef.current?.clearChanges();
    setHasSearched(false);
    clearFilters();
  };

  // ----- spdMain_Changed 1:1 — D_ 셀 편집 → 필수 11건 검증(MSG00429 {label}) + SetSaveData 수집 -----
  const requiredChecks: { key: keyof CustPsiUploadRow; label: string }[] = [
    { key: 'DIVISION_ID', label: 'Division*' },
    { key: 'SCM_SITE_ID', label: 'Sales Site*' },
    { key: 'CUSTOMER_PROJECT_CODE', label: 'Customer Project*' },
    { key: 'CUSTOMER_MODEL', label: 'Customer Model*' },
    { key: 'INCOTERMS', label: 'Incoterms*' },
    { key: 'FCST_TYPE', label: 'FCST Type*' },
    { key: 'DOM_EXP', label: 'Customs Handbook*' },
    { key: 'MEASURE_GROUP', label: 'Measure Group*' },
    { key: 'MEASURE', label: 'Measure*' },
    // PLANT_SITE_ID 는 Division 81 만 필수 (원장 §E16 L840) — 아래에서 조건 분기
    { key: 'UPLOAD_UOM', label: 'Upload UOM*' },
  ];

  const handleCellEdited = (item: CustPsiUploadRow, binding: string) => {
    const s = (v: unknown): string =>
      typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
    // 필수 11건 (AS-IS spdMain_Changed 순서 1:1 — MSG00429 = AS-IS MSG00002 의미)
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

    // SetSaveData (원장 §E16 SetSaveData) — dedup 키 11 + qty 갱신
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

  // F8 Insert — AS-IS InsertButton → InsertRow (원장 §E12 L615~636). 신규행 삽입 + 기본값 세팅.
  //   Division = 조회 division / MeasureGroup = 'PSI' 고정 / EDIT_FLAG='Y'(신규행 수량 편집 개방).
  //   속성 셀 부분 개방(콤보/텍스트)은 그리드 IO 컬럼 + beginningEdit Division81 게이트가 담당.
  const handleInsert = () => {
    const grid = gridRef.current;
    if (!grid) return;
    GridAction.addRow(grid, {
      DIVISION_ID: searchParams.divisionId,
      MEASURE_GROUP: MEASURE_GROUP_FIXED, // AS-IS L631 "PSI" 고정 (이후 잠금)
      EDIT_FLAG: 'Y', // 신규행 수량 셀 편집 개방 (색·게이트)
    });
  };

  // F9 Delete — AS-IS DeleteButton (원장 §E13 L339~344). 신규행('I')만 삭제. DB행 삭제 불가.
  const handleDelete = () => {
    const grid = gridRef.current;
    if (!grid) return;
    GridAction.removeRow(grid, true); // deleteOnlyNew=true — 신규행만 제거
  };

  // ----- F7 Save — AS-IS SaveData 1:1: 'M' 고정 + 17 키 '^'delim payload -----
  const handleSave = async () => {
    // 재진입 가드 — 조회/저장이 아직 돌고 있으면 차단(더블클릭 이중 저장 방지)
    if (isFetching || isPending) {
      void setAlert({
        type: 'alert',
        content: t(MSG.WORK_IN_PROGRESS, '_이전 작업이 아직 실행 중입니다.'),
      });
      return;
    }
    // 저장 payload 를 그리드 공용 EditTracker 에서 직접 도출한다 (편집↔저장 사이 재렌더에 안정).
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
          // 필수 11건 검증 (저장 시점 재검증)
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
              content: t(MSG.REQUIRED_VALUE, '_{0} value is required.').replace(
                '{0}',
                'Plant Site*'
              ),
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
    const sesUserId = useSessionStore.getState().session.userId ?? '';
    // createdByList — BE 가 가로채지 않는 키명 (createdBy 는 세션 단일값으로 덮여 배열 붕괴 → ORA-01400).
    // activeFlag 는 AS-IS SaveData 전건 'M' 직렬화(원장 §E14 L514/534) 1:1.
    const rows = entries.map(e => ({ ...e, activeFlag: 'M', createdByList: sesUserId }));
    const payload = Object.fromEntries(SAVE_KEYS.map(k => [k, rows.map(r => r[k]).join('^')]));

    void setToast({ message: t('LBL00665', '_Loading...'), type: 'default', duration: 3000 });
    setIsPending(true);
    try {
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`,
        payload
      );
      if (res.status >= 400 || Number(res.data?.code)) {
        const reason =
          (res.data as { message?: string })?.message?.trim() ||
          t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.');
        void setAlert({ type: 'alert', content: reason });
        return;
      }
      void setToast({ message: t(MSG.SAVED, '_성공적으로 저장되었습니다.'), type: 'success' });
      saveEntriesRef.current.clear();
      editTrackerRef.current?.clearChanges();
      // AS-IS SaveData 성공 후 FindButton() 재조회 1:1. 저장은 filters 불변이라 invalidate 가 유일 트리거.
      void queryClient.invalidateQueries({ queryKey: [tabId] });
    } catch (e) {
      const msg =
        e instanceof Error ? e.message : t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.');
      void setAlert({ type: 'alert', content: msg });
    } finally {
      setIsPending(false);
    }
  };

  // SubTitle 공통버튼 — hasButton 권한 분기. excel/sort/filter/condition = DefaultButtonActions 자동.
  //   insert/delete 활성 (DMF0013 은 F8 삽입 존치 — portspec §8-1). manual/upload = 명시 false.
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    delete: hasButton('DELETE') ? handleDelete : false,
    save: hasButton('SAVE') ? () => void handleSave() : false,
    manual: false,
    // Excel 2종은 customButtons 로 배치한다 (표준 upload 슬롯은 customButtons 뒤에 렌더되어 순서가 깨짐).
    upload: false,
  };

  // Excel Form → Excel Upload 순 (hook #135 §6)
  const customButtons = [
    ...(hasButton('FORM_DATA')
      ? [
          {
            label: t('LBL00762', 'Excel Form'),
            action: () => {
              // 메인 조회 전에 열어도 양식이 조회되도록 filters 를 먼저 확정한다(store 단일 출처).
              if (!filters[SHEETS.MAIN]) setFilters();
              setOpenTemplateModal(true);
            },
            iconComponent: <FileExceldownloadIcon />,
            iconPosition: 'leading' as const,
          },
        ]
      : []),
    ...(hasButton('UPLOAD')
      ? [
          {
            label: t('LBL00346', 'Excel Upload'),
            action: () => setOpenFcstUploadModal(true),
            iconComponent: <FileExceluploadIcon />,
            iconPosition: 'leading' as const,
          },
        ]
      : []),
  ];

  const rows = (data as { o_rc1?: CustPsiUploadRow[] })?.o_rc1 ?? [];

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <CustPsiUploadForm
        onSubmit={handleSearch}
        onDivisionChange={resetGrid}
        setOpenPrjByDivisionModal={setOpenPrjByDivisionModal}
        setOpenModelByDivisionModal={setOpenModelByDivisionModal}
      />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='Cust-Psi-Upload'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        customButtons={customButtons}
        searchParam={searchParams}
      />
      <CustPsiUploadGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        data={rows}
        spreadTitle={spreadTitleRows}
        onCellEdited={handleCellEdited}
      />
      {/* AS-IS btnProject_Click (원장 §E07) — SCM0002_ProjectbyDivisionPopupEx 1:1 */}
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
      {/* AS-IS btmItem_Click (원장 §E08) — SCM0002_ItembyDivisionPopupEx 1:1. 오픈 게이트(MSG00147)는
          공용 ItemByDivisionModal 내부 규약 승계 (portspec §7·§8-8). */}
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
      {/* Excel Form — 업로드 양식 다운로드 (hook #135). filters[MAIN] 을 가공 없이 넘긴다. */}
      <CustPsiTemplateModal
        open={openTemplateModal}
        modalClose={() => setOpenTemplateModal(false)}
        divisionId={searchParams.divisionId}
        filters={filters[SHEETS.MAIN] as Record<string, unknown> | undefined}
        staticColumns={staticColumn}
      />
      {/* AS-IS btnExcelUpload_Click (원장 §E09) — 공통 ExcelUploadForm("DMF0013", 'PSI Upload') 1:1.
          2-Step: [Upload]=검증·분류 / [OK]=저장(onSave — mode=1 call-proc). */}
      <FcstUploadModal
        open={openFcstUploadModal}
        modalClose={() => setOpenFcstUploadModal(false)}
        menuId={MENU_ID}
        sheetName={SHEETS.MAIN}
        attributeHeaders={PSI_UPLOAD_HEADERS}
        confirmBeforeSave={false}
        onSave={async () => {
          const sesUserId = useSessionStore.getState().session.userId ?? '';
          try {
            const res = await apiClient.post<Record<string, unknown>>(
              `/${MENU_ID}/${SHEETS.MAIN}/UPLOAD_SAVE/call-proc`,
              { mode: 1, createdBy: sesUserId, programId: MENU_ID, sheetName: SHEETS.MAIN }
            );
            const code = Number((res.data as { code?: string })?.code ?? 0);
            const inner = (
              res.data?.result as { o_result_cursor?: { CODE?: string; MSG?: string }[] }
            )?.o_result_cursor?.[0];
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
          // 업로드 후 재조회 (portspec §8-8: AS-IS 는 재조회 부재였으나 DMF0014 개선 승계)
          void queryClient.invalidateQueries({ queryKey: [tabId] });
        }}
      />
    </>
  );
};
