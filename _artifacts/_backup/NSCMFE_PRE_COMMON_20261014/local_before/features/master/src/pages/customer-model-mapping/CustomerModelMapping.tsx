import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery, useProcMutation, useSaveWithValidation } from '@shared/hooks';

import { CustomerModelMappingForm } from './components/CustomerModelMappingForm';
import { CustomerModelMappingGrid } from './components/CustomerModelMappingGrid';
import { MENU_ID, SHEETS } from './customer-model-mapping.constants';
import { useCustomerModelMappingStore } from './useCustomerModelMappingStore';

export const CustomerModelMapping = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS>>>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const isOpenSearchArea = useCustomerModelMappingStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useCustomerModelMappingStore(state => state.setOpenSearchArea);
  const filters = useCustomerModelMappingStore(state => state.filters);
  const setFilters = useCustomerModelMappingStore(state => state.setFilters);
  const initialized = useCustomerModelMappingStore(state => state.initialized);
  const fetchStaticColumns = useCustomerModelMappingStore(state => state.fetchStaticColumns);
  const staticColumn = useCustomerModelMappingStore(state => state.staticColumn);
  const searchParams = useCustomerModelMappingStore(state => state.searchParams);

  const { saveWithValidation } = useSaveWithValidation();

  const { data } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.CUSTOMER_MODEL_MAPPING,
    tabId,
    filters,
    enabled: !!filters,
  });

  const { mutate } = useProcMutation<MENU_ID, SHEETS.CUSTOMER_MODEL_MAPPING>({
    menuId: MENU_ID,
    sheetName: SHEETS.CUSTOMER_MODEL_MAPPING,
    tabId,
  });

  const handleInsert = () => {
    if (!gridRef.current) return;

    GridAction.addRow(gridRef.current, {
      DIVISION_ID: searchParams.divisionId,
      // 신규행 사용여부 기본값 Y (AS-IS 와 동일 — 저장 시 NULL 로 나가지 않도록)
      VALID_YN: 'Y',
    });
  };

  // VALID_YN 으로 사용 여부를 관리하는 그리드라 삭제는 신규행 제거 전용으로만 쓴다.
  // removeRow 두 번째 인자 deleteOnlyNew=true 로 기존행에 D flag 를 찍지 않는다
  //   (기존 매핑 비활성은 VALID_YN='N' 으로 처리).
  const handleDelete = () => {
    if (!gridRef.current) return;
    GridAction.removeRow(gridRef.current, true);
  };

  const handleSave = () => {
    if (!gridRef.current) return;
    // dirty 행은 그리드 소스(collectionView.sourceCollection)에서 읽는다 — 신규행(GridAction.addRow)은
    //   그 배열에 splice 되는데 조회 전엔 data 가 undefined 라 data.o_rc1 로는 안 잡힌다. 그리드
    //   소스로 읽어야 "그냥 저장(변경없음)"과 "신규행 저장"이 구분돼 신규행일 때 필수검증이 걸린다
    //   (DMF0007 과 동일 규약 — data.o_rc1 로 읽던 예전엔 신규행+저장이 "수정한 내용이 없습니다"로 샜다).
    const gridRows = gridRef.current.collectionView?.sourceCollection ?? [];
    const dirtyRows = gridRows.filter(row => row.CRUD_TYPE);
    // 변경/신규 행이 없으면 "수정한 내용이 없습니다" — 필수값 입력 안내가 아니다.
    if (dirtyRows.length === 0) {
      mutate([]);
      return;
    }
    saveWithValidation(dirtyRows, staticColumn, mutate);
  };

  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
  }, [tabId]);

  const hotkeyConfig: HotkeyConfig = {
    insert: handleInsert,
    delete: handleDelete,
    search: setFilters,
    save: handleSave,
    manual: false,
    upload: false,
  };

  // itemsSource 참조 안정화 — 조회 전 매 렌더 새 `?? []` 로 신규행이 리렌더에 사라지는 것 방지
  //   (handleSave 가 그리드 소스에서 신규행을 읽으려면 필요). DMF0007 과 동일.
  //   단, division 이 바뀌면 새 [] 를 만들어(deps 에 divisionId) 그리드를 비운다 — 조회 전
  //   addRow 한 신규행은 data 가 계속 undefined 라 참조가 고정돼 남아 있었는데, division 을
  //   바꾸면 초기화되어야 한다.
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
      <CustomerModelMappingForm />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='Customer-Model-Mapping'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <CustomerModelMappingGrid gridRef={gridRef} gridFilterRef={gridFilterRef} data={rows} />
    </>
  );
};
