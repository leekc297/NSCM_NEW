import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import { apiClient } from '@foundation/apis';
import { BUTTON_TYPE } from '@foundation/constants';
import { t } from '@foundation/i18n';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery, useProcMutation, useSaveWithValidation } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { CustomerModelMappingForm } from './components/CustomerModelMappingForm';
import { CustomerModelMappingGrid } from './components/CustomerModelMappingGrid';
import { CONVERT_QTY_BINDINGS, MENU_ID, SHEETS } from './customer-model-mapping.constants';
import {
  duplicateAlertContent,
  findGridDuplicate,
  findLedgerDuplicate,
} from './customer-model-mapping.duplicateCheck';
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
  const { setAlert } = useMessageStore.getState();

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
      // Convert Qty 3컬럼 + KW/h(CAPACITY) 기본값 0 (AS-IS defaultData.Add
      //   CONVERT_QTY_PACK/MODULE/CELL/CAPACITY "0"). 입력 없이 저장해도 빈칸이 아닌 0 으로 나가게 한다.
      [CONVERT_QTY_BINDINGS.PACK]: '0',
      [CONVERT_QTY_BINDINGS.MODULE]: '0',
      [CONVERT_QTY_BINDINGS.CELL]: '0',
      CAPACITY: '0',
    });
  };

  // VALID_YN 으로 사용 여부를 관리하는 그리드라 삭제는 신규행 제거 전용으로만 쓴다.
  // removeRow 두 번째 인자 deleteOnlyNew=true 로 기존행에 D flag 를 찍지 않는다
  //   (기존 매핑 비활성은 VALID_YN='N' 으로 처리).
  const handleDelete = () => {
    if (!gridRef.current) return;
    GridAction.removeRow(gridRef.current, true);
  };

  // 신규 행 4키(Division, Sales Site, Customer PJT, Customer Model)로 원장을 읽는다 — 조회 화면과 같은
  //   SP(SEARCH). 조회 SP 는 PJT / Model 을 UPPER LIKE 로 거르므로 정확 일치 판정은 duplicateCheck 가 한다.
  //   사용여부(activeFlag)는 'ALL' — AS-IS 중복 검사(.cs L518~528)가 VALID_YN 을 보지 않았고, 비활성
  //   매핑도 PK 를 차지해 신규로 넣으면 SP 가 덮어쓴다.
  const fetchLedgerRows = async (row: ResponseData<MENU_ID, SHEETS>) => {
    const res = await apiClient.callProc(MENU_ID, SHEETS.CUSTOMER_MODEL_MAPPING, BUTTON_TYPE.SEARCH, {
      divisionId: String(row.DIVISION_ID ?? ''),
      deptId: 'ALL',
      endCustomer: 'ALL',
      salesSite: String(row.SCM_SITE_ID ?? ''),
      customerPJT: String(row.CUSTOMER_PROJECT_CODE ?? ''),
      customerModel: String(row.CUSTOMER_MODEL ?? ''),
      projectCode: '',
      itemId: '',
      activeFlag: 'ALL',
    });
    return res.result?.o_rc1 ?? [];
  };

  const handleSave = async () => {
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

    // PJT Code 필수(AS-IS .cs L497~515, 40 외 사업부)는 코드가 아니라 컬럼 메타가 건다 — PROJECT_CODE 행
    //   입력 구분 M + DIVISION_ID 사업부 목록. 스토어가 컬럼 조회에 사업부를 넘기므로 40 에는 그 컬럼이
    //   내려오지 않고, 81·82 에는 M 으로 내려와 아래 saveWithValidation 의 공용 필수 검증이 MSG00429 로
    //   막는다(2026-10-07 사용자 결정 — 메타 UPDATE 는 _artifacts/_deploy_packages/DMF0006_PJT_CODE_REQUIRED_20261007).

    // 신규 행 중복 검사 — AS-IS .cs L518~535 1:1(MSG00060 후 저장 중단). 사유와 두 겹(그리드 안 / 원장)
    //   규칙은 customer-model-mapping.duplicateCheck 참조. 저장 SP 신규 분기가 같은 키를 지우고 다시
    //   넣어 기존 매핑을 덮어쓰므로, 여기서 막지 않으면 데이터가 조용히 바뀐다.
    const gridDuplicate = findGridDuplicate(gridRows);
    if (gridDuplicate) {
      void setAlert({
        type: 'alert',
        content: duplicateAlertContent(t('MSG00060', '_중복된 키가 존재합니다.'), gridDuplicate.row),
      });
      return;
    }
    const ledgerCheck = await findLedgerDuplicate(dirtyRows, fetchLedgerRows);
    if (ledgerCheck.status === 'duplicate') {
      void setAlert({
        type: 'alert',
        content: duplicateAlertContent(t('MSG00060', '_중복된 키가 존재합니다.'), ledgerCheck.hit.row),
      });
      return;
    }
    if (ledgerCheck.status === 'error') {
      // 원장을 읽지 못하면 중복 여부를 알 수 없다 — SP 가 덮어쓰기 때문에 저장을 보내지 않는다.
      void setAlert({ type: 'alert', content: t('MSG00618', '_저장 중 오류가 발생했습니다.') });
      return;
    }
    saveWithValidation(dirtyRows, staticColumn, mutate);
  };

  useEffect(() => {
    // 최초 진입도 현재 조회조건 사업부 기준으로 컬럼 메타를 받는다(사업부별 컬럼·필수 설정 적용).
    if (!initialized) void fetchStaticColumns(searchParams.divisionId);
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
