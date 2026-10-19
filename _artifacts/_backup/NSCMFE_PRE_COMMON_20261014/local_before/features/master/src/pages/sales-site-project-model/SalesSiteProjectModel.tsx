import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import { t } from '@foundation/i18n';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useSaveWithValidation, useTabProcQuery } from '@shared/hooks';
import { Panel, PanelGroup } from '@shared/panel';
import { useMessageStore } from '@shared/stores';

import { SalesSiteProjectModelForm } from './componenets/SalesSiteProjectModelForm';
import { SalesSiteProjectModelGrid } from './componenets/SalesSiteProjectModelGrid';
import { SalesSiteProjectModelPurchaseGrid } from './componenets/SalesSiteProjectModelPurchaseGrid';
import {
  MENU_ID,
  SAVE_STALE_COMBO_IDS,
  SHEET_INDEX,
  SHEETS,
} from './sales-site-project-model.constants';
import styles from './SalesSiteProjectModel.module.scss';
import { useSalesSiteProjectModelSave } from './useSalesSiteProjectModelSave';
import { useSalesSiteProjectModelStore } from './useSalesSiteProjectModelStore';

export const SalesSiteProjectModel = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { saveWithValidation } = useSaveWithValidation();
  const queryClient = useQueryClient();
  const { setAlert, setToast } = useMessageStore.getState();

  // 저장 성공 시 이 화면(DMF0005)의 Team 조회조건 콤보만 다시 받는다.
  //   공통 useInvalidateCombos 는 comboId 만 보고 무효화해서, 같은 FilterTeambyDivision 을 쓰는
  //   다른 열린 화면(business-plan / mkt-fcst 등, MDI keep-alive)의 콤보까지 전부 재조회한다.
  //   콤보 키 param 에는 mnuId 가 실려 화면마다 캐시가 갈리므로, mnuId 로 이 화면 것만 고른다.
  const refetchStaleCombos = () =>
    void queryClient.invalidateQueries({
      predicate: query => {
        if (query.queryKey[0] !== 'combo') return false;
        const param = query.queryKey[2] as { comboId?: string; mnuId?: string } | undefined;
        return (
          param?.mnuId === MENU_ID &&
          (SAVE_STALE_COMBO_IDS as readonly string[]).includes(param?.comboId ?? '')
        );
      },
    });

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

  // itemsSource 참조 안정화 — 조회 전 매 렌더 새 `?? []` 로 신규행이 리렌더에 사라지는 것 방지
  //   (handleSave 가 그리드 소스에서 신규행을 읽으려면 필요). DMF0006/DMF0007 과 동일.
  //   단, division 이 바뀌면 새 [] 를 만들어(deps 에 divisionId) 두 그리드를 비운다 — 조회 전
  //   addRow 한 신규행은 데이터가 계속 undefined 라 참조가 고정돼 남아 있었는데, division 을
  //   바꾸면 초기화되어야 한다.
  const productionRows = useMemo(
    () => productionData?.production ?? [],
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [productionData, searchParams.divisionId]
  );
  const purchaseRows = useMemo(
    () => purchaseData?.purchase ?? [],
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [purchaseData, searchParams.divisionId]
  );

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
    const grid = gridRefs[activeTab].current;
    grid?.finishEditing();

    // 변경/신규 행이 없으면 "수정한 내용이 없습니다" — 저장 훅의 빈배열 가드를 여기(컴포넌트)로
    //   공통화했다. dirty 행은 그리드 소스(collectionView.sourceCollection)에서 읽는다 — 신규행
    //   (addRow)은 그 배열에 splice 되고 조회 전엔 쿼리 데이터가 undefined 라 그쪽으로는 안 잡힌다
    //   (DMF0006/DMF0007 과 동일). 그래야 신규행 저장 시 필수검증이 걸린다.
    const dirtyRows = (
      (grid?.collectionView?.sourceCollection ?? []) as { CRUD_TYPE?: string }[]
    ).filter(row => row.CRUD_TYPE);
    if (dirtyRows.length === 0) {
      // 다른 화면(useProcMutation onError)과 동일하게 toast 로 알린다(변경 없음 = toast, 검증 실패 = alert).
      setToast({ type: 'error', message: t('MSG_NO_CHANGE', '_수정한 내용이 없습니다.') });
      return;
    }

    if (activeTab === SHEET_INDEX.PRODUCTION) {
      // ⭐ 신규행 PROJECT_CODE 보정 — SCM_MST_SITE_ITEM.PROJECT_CODE 는 NOT NULL 이다.
      //   GridAction.addRow 는 시드한 키만으로 행을 만들어서, 사용자가 안 건드린 컬럼은 저장 JSON 에
      //   키조차 없다 → 프로시저가 NULL 을 넣어 ORA-01400 으로 깨진다(수정행은 조회 컬럼이 전부
      //   실려 있어 무사했다).
      //   Division 40 은 화면에 Project 개념이 없어(더블클릭 Project 팝업도 40 제외) 사용자가 채울
      //   방법이 없다 → DMF0042 AS-IS 관례대로 End Customer 를 project 슬롯으로 쓴다
      //   (features/demand/.../business-plan.division.ts L34·L39).
      //   그 외 division 은 Project 팝업으로 직접 고르는 값이라 임의로 채우지 않고 저장을 막는다.
      const src = (grid?.collectionView?.sourceCollection ?? []) as NonNullable<
        typeof productionData
      >['production'];
      const saveData = src
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
      // 저장 성공 시 Team 조회조건 콤보를 다시 받는다 — 훅 기본 onSuccess(토스트 + 그리드 재조회)
      //   뒤에 이어서 실행된다.
      saveWithValidation(saveData, staticColumn, rows =>
        mutateProduction(rows, {
          onSuccess: () => refetchStaleCombos(),
        })
      );
    } else if (activeTab === SHEET_INDEX.PURCHASE) {
      const src = (grid?.collectionView?.sourceCollection ?? []) as NonNullable<
        typeof purchaseData
      >['purchase'];
      const saveData = src.filter(item => item.CRUD_TYPE);
      const staticColumn = staticColumns.purchase;
      saveWithValidation(saveData, staticColumn, rows =>
        mutatePurchase(rows, {
          onSuccess: () => refetchStaleCombos(),
        })
      );
    }
  };

  // 하단(Purchase) 미저장 변경 여부 — 저장 대상 판정과 같은 기준(CRUD_TYPE).
  // 상단 더블클릭이 하단을 재조회하는 시점에만 호출한다.
  const hasPurchaseChanges = () => (purchaseData?.purchase ?? []).some(item => !!item.CRUD_TYPE);

  const handleDelete = () => {
    if (!gridRefs[activeTab].current) return;

    // 이 화면은 삭제 기능이 없다(기존 저장행은 삭제 대상이 아니다). deleteOnlyNew=true 로
    //   신규행만 그리드에서 제거하고, 기존 행은 삭제 버튼을 눌러도 CRUD_TYPE='D' 로 바뀌지 않는다.
    GridAction.removeRow(gridRefs[activeTab].current, true);
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
          activeTab === SHEET_INDEX.PRODUCTION ? productionRows.length : purchaseRows.length
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
            data={productionRows}
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
              data={purchaseRows}
              setActiveTab={setActiveTab}
            />
          </Panel>
        )}
      </PanelGroup>
    </>
  );
};
