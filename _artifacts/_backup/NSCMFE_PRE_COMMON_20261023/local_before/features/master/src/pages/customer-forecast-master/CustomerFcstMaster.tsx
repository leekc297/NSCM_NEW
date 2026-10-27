import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import {
  useTabProcQuery,
  useProcMutation,
  useSaveWithValidation,
  useTabBtnPermissions,
  useTabComboQueries,
} from '@shared/hooks';

import { CustomerFcstMasterFcstGrid } from './componenets/CustomerFcstMasterFcstGrid';
import { CustomerFcstMasterForm } from './componenets/CustomerFcstMasterForm';
import { MENU_ID, SHEET_NAME } from './customer-fcst-master.constants';
import { useCustomerFcstMasterStore } from './useCustomerFcstMasterStore';

export const CustomerFcstMaster = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEET_NAME, 'o_rc1'>> | undefined>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEET_NAME>>>();

  const initialized = useCustomerFcstMasterStore(state => state.initialized);
  const filters = useCustomerFcstMasterStore(state => state.filters);
  const dateColumns = useCustomerFcstMasterStore(state => state.dateColumns);
  const setFilter = useCustomerFcstMasterStore(state => state.setFilter);
  const staticColumn = useCustomerFcstMasterStore(state => state.staticColumns);
  const fetchStaticColumns = useCustomerFcstMasterStore(state => state.fetchStaticColumns);
  const fetchDateColumns = useCustomerFcstMasterStore(state => state.fetchDateColumns);
  const searchParams = useCustomerFcstMasterStore(state => state.searchParams);
  const setSearchParams = useCustomerFcstMasterStore(state => state.setSearchParams);
  const openSearchArea = useCustomerFcstMasterStore(state => state.openSearchArea);
  const setOpenSearchArea = useCustomerFcstMasterStore(state => state.setOpenSearchArea);
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // Division 기본 선택. 비어 있을 때만 채움 - 기존 값은 유지. store 초기값이 빈 값이라
  //   (initSearchParams) 진입 시, 서버 저장 검색조건(/search-conditions)이 division 을 복원했으면
  //   그 값을 그대로 두고(복원값 우선), 없어서 여전히 비어 있을 때만 아래 fallback 이 채운다.
  //   fallback 순서: 이 화면의 원래 기본은 81 계열이므로, 조회된 목록에 81 계열(startsWith('81') —
  //   '81_UC' 등 코드가 '81' 정확값이 아닐 수 있어 === 비교 금지, 프로젝트 규칙)이 있으면 그 첫
  //   코드, 없으면 목록 첫 행. initialized 를 기다려 복원 기회를 먼저 준다.
  const [myDivisions] = useTabComboQueries({ filters: ['FilterMyDivision'] });
  useEffect(() => {
    if (!initialized) return;
    if (searchParams.divisionId) return;
    const codes = (myDivisions ?? []).map(r => String(r.CODE ?? '')).filter(Boolean);
    if (codes.length === 0) return;
    const div81 = codes.find(c => c.startsWith('81'));
    setSearchParams({ divisionId: div81 ?? codes[0] });
  }, [initialized, myDivisions, searchParams.divisionId, setSearchParams]);

  const { saveWithValidation } = useSaveWithValidation();

  const { data: fcstData } = useTabProcQuery<MENU_ID, SHEET_NAME>({
    menuId: MENU_ID,
    sheetName: SHEET_NAME,
    tabId,
    filters: filters,
    enabled: !!filters,
  });

  const { mutate: saveMutation } = useProcMutation<MENU_ID, SHEET_NAME>({
    menuId: MENU_ID,
    sheetName: SHEET_NAME,
    tabId,
  });

  const handleSearch = () => {
    setFilter();
    fetchDateColumns();
    editTrackerRef.current?.clearChanges();
    gridRef.current?.invalidate();
  };

  const handleInsert = () => {
    if (!gridRef.current) return;

    const dateBindings = Object.fromEntries(
      dateColumns
        .map(item => item.columns?.[0]?.binding)
        .filter(Boolean)
        .map(binding => [binding, 'Y'])
    ) as Record<string, string>;

    // 신규행은 조회조건에서 선택한 값(searchParams)을 따른다. filters 는 조회를 눌러야 채워지므로,
    //   조회 전 행추가 때 filters 를 쓰면 undefined 로 빠져 하드코딩 기본값(구 '81')이 들어가던 버그.
    GridAction.addRow(gridRef.current, {
      DIVISION_ID: searchParams.divisionId,
      SUMMARY_BUCKET_TYPE: searchParams.bucketType,
      MEASURE_GROUP: 'CUST_FCST',
      MEASURE: 'Customer Fcst',
      EDI_FCST_YN: 'Y',
      VALID_YN: 'Y',
      ...dateBindings,
    });
  };

  // VALID_YN 으로 사용 여부를 관리하는 그리드라 삭제는 신규행 제거 전용으로만 쓴다.
  // removeRow 두 번째 인자 deleteOnlyNew=true 로 기존행에 D flag 를 찍지 않는다
  //   (기존 항목 비활성은 VALID_YN='N' 으로 처리).
  const handleDelete = () => {
    if (!gridRef.current) return;
    GridAction.removeRow(gridRef.current, true);
  };

  const handleSave = () => {
    if (!gridRef.current || !editTrackerRef.current) return;

    // 저장 검증을 DMF0006(Customer Model Mapping) 과 동일한 규약으로 통일한다 — 신규/수정 원본 행을
    //   saveWithValidation 에 넘겨 필수입력을 먼저 검사한다(신규행 필수 미입력 → "[필드] 필수입니다").
    //   dirty 행은 그리드 소스(collectionView.sourceCollection)에서 읽는다 — 신규행(GridAction.addRow)은
    //   그 배열에 splice 되는데 조회 전엔 fcstData 가 undefined 라 fcstData.o_rc1 로는 안 잡힌다.
    //   그리드 소스로 읽어야 "그냥 저장(변경없음)"과 "신규행 저장"이 구분돼 신규행일 때 검증이 걸린다.
    const editMap = editTrackerRef.current.getOriginalValues();
    const gridRows = gridRef.current.collectionView?.sourceCollection ?? [];
    const dirtyRows = gridRows.filter(row => row.CRUD_TYPE);

    // 변경/신규 행이 없으면 "수정한 내용이 없습니다" — 필수값 입력 안내가 아니다.
    if (dirtyRows.length === 0) {
      saveMutation([]);
      return;
    }

    saveWithValidation(dirtyRows, staticColumn, rows => {
      const saveData: ResponseData<MENU_ID, SHEET_NAME>[] = [];
      rows.forEach(row => {
        Object.keys(row).forEach(key => {
          if (!key.startsWith('D_')) return;

          const changeMap = editMap.get(row);
          if (row.CRUD_TYPE === CRUD_TYPE.MODIFY && (!changeMap || !(key in changeMap))) return;

          const pivotedData = {
            PLAN_WEEK: row.PLAN_WEEK,
            DIVISION_ID: row.DIVISION_ID,
            DEPT_ID: row.DEPT_ID,
            CUSTOMER_CODE: row.CUSTOMER_CODE,
            SCM_SITE_ID: row.SCM_SITE_ID,
            MEASURE_GROUP: row.MEASURE_GROUP,
            MEASURE: row.MEASURE,
            EDI_FCST_YN: row.EDI_FCST_YN ?? 'Y',
            UPLOAD_UOM: row.UPLOAD_UOM,
            UPLOAD_BUCKET_TYPE: row.UPLOAD_BUCKET_TYPE,
            VALID_YN: row.VALID_YN,
            UPLOAD_ORDER: row.UPLOAD_ORDER,
            EDIT_FLAG: row.EDIT_FLAG,
            CRUD_TYPE: row.CRUD_TYPE ?? CRUD_TYPE.MODIFY,
            CUSTOMER_PSI: '',
            SUMMARY_BUCKET_TYPE: row.SUMMARY_BUCKET_TYPE,
            SUMMARY_BUCKET_VALUE: key.split('_')[1],
            SUMMARY_BUCKET_YN: row[key] ?? 'N',
          };

          saveData.push(pivotedData);
        });
      });

      saveMutation(saveData);
    });
  };

  const hotkeyConfig: HotkeyConfig = {
    // 버튼 노출은 그룹 버튼 권한(SCM_ADM_USER_GR_MNU_BTN_MPG_M)으로 정한다 — 공용 훅 표준 패턴(AUTH-02).
    //   종전엔 핸들러를 조건 없이 넘겨 SAVE 권한이 없는 SCP Planner 에게도 저장 버튼이 보였고, 누르면
    //   서버(CustomAuthorizationManager)가 거부해 실패 안내만 뜨고 고친 값이 사라졌다(2026-10-07 리포트).
    //   AS-IS 는 그룹명 검사가 없었으므로 그룹명 분기는 두지 않고 권한 등록만 읽는다.
    //   INSERT/DELETE 는 customerFcst 시트 버튼 메타가 함께 등록돼야 보인다 — 배포 SQL
    //   _artifacts/_deploy_packages/DMF0007_BTN_INSERT_DELETE_20261007/ (SAVE 보유 그룹에 동일 부여).
    search: handleSearch,
    insert: hasButton('INSERT') ? handleInsert : false,
    save: hasButton('SAVE') ? handleSave : false,
    delete: hasButton('DELETE') ? handleDelete : false,
    manual: false,
    upload: false,
  };

  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
  }, [tabId]);

  // itemsSource 참조 안정화 — 조회 전(fcstData undefined)엔 매 렌더 새 `?? []` 가 만들어져, 리렌더가
  //   나면 방금 addRow 한 신규행이 담긴 배열째 교체돼 신규행이 사라진다. 참조를 고정해 신규행이
  //   유지되게 한다(handleSave 가 그리드 소스에서 신규행을 읽으려면 이 안정성이 필요).
  //   단, division 이 바뀌면 새 `[]` 를 만들어(deps 에 divisionId) 그리드를 비운다 — 조회 전
  //   addRow 한 신규행은 fcstData 가 계속 undefined 라 참조가 고정돼 남아 있었는데, division 을
  //   바꾸면 그 신규행이 초기화되어야 한다. fcstData 만 deps 일 때는 이 초기화가 안 됐다.
  const rows = useMemo(
    () => fcstData?.o_rc1 ?? [],
    // divisionId 는 memo 본문에서 읽지 않지만, 바뀌면 새 [] 를 만들어 그리드를 비우는 리셋 트리거다.
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [fcstData, searchParams.divisionId]
  );

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <CustomerFcstMasterForm onSubmit={handleSearch} />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='Customer FCST Master'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <CustomerFcstMasterFcstGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        data={rows}
      />
    </>
  );
};
