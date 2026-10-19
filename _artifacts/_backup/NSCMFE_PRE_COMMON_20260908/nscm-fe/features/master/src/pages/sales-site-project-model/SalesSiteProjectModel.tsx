import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import { t } from '@foundation/i18n';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useSaveWithValidation, useTabProcQuery } from '@shared/hooks';
import { Panel, PanelGroup } from '@shared/panel';
import { useMessageStore } from '@shared/stores';

import { SalesSiteProjectModelForm } from './componenets/SalesSiteProjectModelForm';
import { SalesSiteProjectModelGrid } from './componenets/SalesSiteProjectModelGrid';
import { SalesSiteProjectModelPurchaseGrid } from './componenets/SalesSiteProjectModelPurchaseGrid';
import { MENU_ID, SHEET_INDEX, SHEETS } from './sales-site-project-model.constants';
import styles from './SalesSiteProjectModel.module.scss';
import { useSalesSiteProjectModelSave } from './useSalesSiteProjectModelSave';
import { useSalesSiteProjectModelStore } from './useSalesSiteProjectModelStore';

export const SalesSiteProjectModel = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { saveWithValidation } = useSaveWithValidation();
  const { setAlert } = useMessageStore.getState();

  const gridRefs = [useRef<FlexGrid>(), useRef<FlexGrid>()];
  const gridFilterRefs = [useRef<FlexGridFilter>(), useRef<FlexGridFilter>()];

  const initialized = useSalesSiteProjectModelStore(state => state.initialized);
  const filters = useSalesSiteProjectModelStore(state => state.filters);
  const openPurchaseGrid = useSalesSiteProjectModelStore(state => state.openPurchaseGrid);
  const staticColumns = useSalesSiteProjectModelStore(state => state.staticColumns);
  const fetchStaticColumns = useSalesSiteProjectModelStore(state => state.fetchStaticColumns);
  const setProductionFilter = useSalesSiteProjectModelStore(state => state.setProductionFilter);
  const searchParams = useSalesSiteProjectModelStore(state => state.searchParams);
  const openSearchArea = useSalesSiteProjectModelStore(state => state.openSearchArea);
  const setOpenSearchArea = useSalesSiteProjectModelStore(state => state.setOpenSearchArea);

  const [activeTab, setActiveTab] = useState<SHEET_INDEX>(SHEET_INDEX.PRODUCTION);

  const { data: productionData } = useTabProcQuery<MENU_ID, SHEETS.PRODUCTION>({
    menuId: MENU_ID,
    sheetName: SHEETS.PRODUCTION,
    tabId,
    filters: filters[SHEETS.PRODUCTION],
    enabled: !!filters[SHEETS.PRODUCTION],
  });

  const { data: purchaseData } = useTabProcQuery<MENU_ID, SHEETS.PURCHASE>({
    menuId: MENU_ID,
    sheetName: SHEETS.PURCHASE,
    tabId,
    filters: filters[SHEETS.PURCHASE],
    enabled: !!filters[SHEETS.PURCHASE],
  });

  // ⭐ 공통 useProcMutation 대신 화면 전용 훅 — 저장 실패(HTTP 500)가 성공 토스트 + 재조회로
  //   흘러가던 문제 때문. 사유는 useSalesSiteProjectModelSave 주석 참조.
  const { mutate: mutateProduction } = useSalesSiteProjectModelSave<SHEETS.PRODUCTION>({
    sheetName: SHEETS.PRODUCTION,
    tabId,
  });

  const { mutate: mutatePurchase } = useSalesSiteProjectModelSave<SHEETS.PURCHASE>({
    // ⚠️ 기존 동작 그대로 유지 — 하단(Purchase) 저장이 production 시트로 나간다(별건 이슈).
    sheetName: SHEETS.PRODUCTION as SHEETS.PURCHASE,
    // 저장 시트가 어긋나 있어도 재조회는 화면 그대로 하단만 한다.
    refetchSheetName: SHEETS.PURCHASE,
    tabId,
  });

  const handleSubmit = () => {
    setProductionFilter();
    void fetchStaticColumns();
    setActiveTab(SHEET_INDEX.PRODUCTION);
  };

  const handleInsert = () => {
    if (activeTab !== SHEET_INDEX.PRODUCTION) return;
    if (!gridRefs[activeTab].current) return;

    GridAction.addRow(gridRefs[activeTab].current, {
      DIVISION_ID: searchParams.divisionId,
      VALID_YN: 'Y',
    });
  };

  const handleSave = () => {
    gridRefs[activeTab].current?.finishEditing();
    if (activeTab === SHEET_INDEX.PRODUCTION) {
      // ⭐ 신규행 PROJECT_CODE 보정 — SCM_MST_SITE_ITEM.PROJECT_CODE 는 NOT NULL 이다.
      //   GridAction.addRow 는 시드한 키만으로 행을 만들어서, 사용자가 안 건드린 컬럼은 저장 JSON 에
      //   키조차 없다 → 프로시저가 NULL 을 넣어 ORA-01400 으로 깨진다(수정행은 조회 컬럼이 전부
      //   실려 있어 무사했다).
      //   Division 40 은 화면에 Project 개념이 없어(더블클릭 Project 팝업도 40 제외) 사용자가 채울
      //   방법이 없다 → DMF0042 AS-IS 관례대로 End Customer 를 project 슬롯으로 쓴다
      //   (features/demand/.../business-plan.division.ts L34·L39).
      //   그 외 division 은 Project 팝업으로 직접 고르는 값이라 임의로 채우지 않고 저장을 막는다.
      const saveData = (productionData?.production ?? [])
        .filter(item => item.CRUD_TYPE)
        .map(item =>
          item.CRUD_TYPE === CRUD_TYPE.INSERT && !item.PROJECT_CODE && item.DIVISION_ID === '40'
            ? { ...item, PROJECT_CODE: item.END_CUSTOMER }
            : item
        );

      // 보정 후에도 비어 있으면 NOT NULL 위반이 확정이다 — 500 을 맞기 전에 여기서 막는다.
      // 40 은 End Customer 가 곧 project 슬롯이라 안내 문구가 다르다.
      const noProjectRow = saveData.find(
        item => item.CRUD_TYPE === CRUD_TYPE.INSERT && !item.PROJECT_CODE
      );

      if (noProjectRow) {
        void setAlert({
          type: 'alert',
          // 백엔드 메시지 코드가 아직 없어 임시 키 + 기본문구로 둔다(MSG_NO_CHANGE 와 같은 방식).
          content:
            noProjectRow.DIVISION_ID === '40'
              ? t('MSG_END_CUSTOMER_REQUIRED', 'End Customer 를 입력하세요.')
              : t('MSG_PROJECT_REQUIRED', 'Project 를 선택하세요.'),
        });
        return;
      }

      const staticColumn = staticColumns.production;
      saveWithValidation(saveData, staticColumn, mutateProduction);
    } else if (activeTab === SHEET_INDEX.PURCHASE) {
      const saveData = purchaseData?.purchase?.filter(item => item.CRUD_TYPE) ?? [];
      const staticColumn = staticColumns.purchase;
      saveWithValidation(saveData, staticColumn, mutatePurchase);
    }
  };

  // 하단(Purchase) 미저장 변경 여부 — 저장 대상 판정과 같은 기준(CRUD_TYPE).
  // 상단 더블클릭이 하단을 재조회하는 시점에만 호출한다.
  const hasPurchaseChanges = () => (purchaseData?.purchase ?? []).some(item => !!item.CRUD_TYPE);

  const handleDelete = () => {
    if (!gridRefs[activeTab].current) return;

    GridAction.removeRow(gridRefs[activeTab].current);
  };

  const hotkeyConfig: HotkeyConfig = {
    insert: handleInsert,
    save: handleSave,
    search: handleSubmit,
    delete: handleDelete,
    manual: false,
    upload: false,
  };

  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
  }, [tabId]);

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <SalesSiteProjectModelForm onSubmit={handleSubmit} setActiveTab={setActiveTab} />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRefs[activeTab]}
        gridFilter={gridFilterRefs[activeTab]}
        dataCount={
          activeTab === SHEET_INDEX.PRODUCTION
            ? (productionData?.production ?? []).length
            : (purchaseData?.purchase ?? []).length
        }
        excelFileName='Sales-Site-Project-Model'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <PanelGroup className={styles.customPanelGroup} orientation='vertical'>
        <Panel>
          <SalesSiteProjectModelGrid
            gridRef={gridRefs[SHEET_INDEX.PRODUCTION]}
            gridFilterRef={gridFilterRefs[SHEET_INDEX.PRODUCTION]}
            data={productionData?.production ?? []}
            setActiveTab={setActiveTab}
            // 상단 더블클릭 조회가 하단을 갈아끼우므로, 하단 미저장 변경이면 막는다.
            hasPurchaseChanges={hasPurchaseChanges}
          />
        </Panel>
        {openPurchaseGrid && searchParams.divisionId !== '40' && (
          <Panel>
            <SalesSiteProjectModelPurchaseGrid
              gridRef={gridRefs[SHEET_INDEX.PURCHASE]}
              gridFilterRef={gridFilterRefs[SHEET_INDEX.PURCHASE]}
              data={purchaseData?.purchase ?? []}
              setActiveTab={setActiveTab}
            />
          </Panel>
        )}
      </PanelGroup>
    </>
  );
};
