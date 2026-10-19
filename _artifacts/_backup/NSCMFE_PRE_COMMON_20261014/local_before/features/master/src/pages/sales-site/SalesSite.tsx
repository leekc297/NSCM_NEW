import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { ComboResponse, HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import {
  useInvalidateCombos,
  useProcMutation,
  useSaveWithValidation,
  useTabProcQuery,
} from '@shared/hooks';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore } from '@shared/stores';

import { SalesSiteBucketGrid } from './components/SalesSiteBucketGrid';
import { SalesSiteCustomerGrid } from './components/SalesSiteCustomerGrid';
import { SalesSiteForm } from './components/SalesSiteForm';
import { SalesSiteGrid } from './components/SalesSiteGrid';
import { SalesSiteLocationGrid } from './components/SalesSiteLocationGrid';
import type { RESPONSE_SET } from './sales-site.constants';
import { MENU_ID, SHEET_INDEX, SHEETS } from './sales-site.constants';
import styles from './SalesSite.module.scss';
import { useSalesSiteStore } from './useSalesSiteStore';
import { SALES_SITE_STALE_COMBO_IDS } from './utils/sales-site.salesSiteCombo';
import { resolveComboCodeByDivision } from './utils/sales-site.util';

export const SalesSite = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRefs = [useRef<FlexGrid>(), useRef<FlexGrid>(), useRef<FlexGrid>(), useRef<FlexGrid>()];
  const gridFilterRefs = [
    useRef<FlexGridFilter>(),
    useRef<FlexGridFilter>(),
    useRef<FlexGridFilter>(),
    useRef<FlexGridFilter>(),
  ];

  const initialized = useSalesSiteStore(state => state.initialized);
  const filters = useSalesSiteStore(state => state.filters);
  const setSiteFilters = useSalesSiteStore(state => state.setSiteFilters);
  const staticColumns = useSalesSiteStore(state => state.staticColumns);
  const fetchStaticColumns = useSalesSiteStore(state => state.fetchStaticColumns);
  const searchParams = useSalesSiteStore(state => state.searchParams);
  const openSearchArea = useSalesSiteStore(state => state.openSearchArea);
  const setOpenSearchArea = useSalesSiteStore(state => state.setOpenSearchArea);

  const [activeTab, setActiveTab] = useState<SHEET_INDEX>(SHEET_INDEX.SITE);
  const [openDetailGrid, setOpenDetailGrid] = useState<boolean>(true);

  const { saveWithValidation } = useSaveWithValidation();
  const { setToast } = useMessageStore.getState();
  const invalidateCombos = useInvalidateCombos();

  const { data: siteData } = useTabProcQuery<MENU_ID, SHEETS.SITE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SITE,
    tabId,
    filters: filters[SHEETS.SITE],
    enabled: !!filters[SHEETS.SITE],
  });

  const { data: detailData } = useTabProcQuery<MENU_ID, SHEETS.CUSTOMER>({
    menuId: MENU_ID,
    sheetName: SHEETS.CUSTOMER,
    tabId,
    filters: filters[SHEETS.CUSTOMER],
    enabled: !!filters[SHEETS.CUSTOMER],
  });

  const { mutate: mutateSite } = useProcMutation<MENU_ID, SHEETS.SITE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SITE,
    tabId,
  });

  const { mutate: mutateCustomer } = useProcMutation<
    MENU_ID,
    SHEETS.CUSTOMER,
    RESPONSE_SET.CUSTOMER
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.CUSTOMER,
    tabId,
  });

  const { mutate: mutateLocation } = useProcMutation<
    MENU_ID,
    SHEETS.LOCATION,
    RESPONSE_SET.LOCATION
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.LOCATION,
    tabId,
  });

  const { mutate: mutateBucket } = useProcMutation<MENU_ID, SHEETS.BUCKET, RESPONSE_SET.BUCKET>({
    menuId: MENU_ID,
    sheetName: SHEETS.BUCKET,
    tabId,
  });

  // itemsSource 참조 안정화 — 조회 전 매 렌더 새 `?? []` 로 신규행이 리렌더에 사라지는 것 방지
  //   (handleSave 가 그리드 소스에서 신규행을 읽으려면 필요). DMF0006/DMF0007 과 동일.
  //   단, division 이 바뀌면 새 `[]` 를 만들어(deps 에 divisionId) 상/하단 그리드를 비운다 —
  //   조회 전 addRow 한 신규행은 데이터가 계속 undefined 라 참조가 고정돼 남아 있었는데,
  //   division 을 바꾸면 초기화되어야 한다.
  // divisionId 는 memo 본문에서 읽지 않지만, 바뀌면 새 [] 를 만들어 그리드를 비우는 리셋 트리거다.
  const siteRows = useMemo(
    () => siteData?.salesSite ?? [],
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [siteData, searchParams.divisionId]
  );
  const customerRows = useMemo(
    () => detailData?.salesCustomer ?? [],
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [detailData, searchParams.divisionId]
  );
  const locationRows = useMemo(
    () => detailData?.salesLocation ?? [],
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [detailData, searchParams.divisionId]
  );
  const bucketRows = useMemo(
    () => detailData?.salesBucket ?? [],
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [detailData, searchParams.divisionId]
  );

  const detailDataCountByTab: Record<number, number> = {
    [SHEET_INDEX.SITE]: siteRows.length,
    [SHEET_INDEX.CUSTOMER]: customerRows.length,
    [SHEET_INDEX.LOCATION]: locationRows.length,
    [SHEET_INDEX.BUCKET]: bucketRows.length,
  };

  const handleInsert = () => {
    if (!gridRefs[activeTab].current) return;

    const scmSiteId =
      activeTab === SHEET_INDEX.SITE ? undefined : filters[SHEETS.CUSTOMER]?.salesSite;

    // 신규행 division 은 조회조건에서 선택한 값(searchParams.divisionId)을 따른다. filters 는
    //   조회를 눌러야 채워지므로, 조회 전 행추가 때 filters 를 쓰면 undefined 로 빠져 하드코딩
    //   기본값(구 '81')이 들어가던 버그가 있었다 — 상/하단 그리드 공통 handleInsert 라 전 탭에 영향.
    // Rep 기본값은 N. Y 로 바꿀 때의 중복 검사는 Customer 그리드 cellEditEnded 에서 처리한다.
    GridAction.addRow(gridRefs[activeTab].current, {
      DIVISION_ID: searchParams.divisionId,
      SCM_SITE_ID: scmSiteId,
      VMI_YN: 'N',
      VALID_YN: 'Y',
      REP_YN: 'N',
      SHIP_PLAN_AUTO: 'N',
    });
  };

  // VALID_YN 으로 사용 여부를 관리하는 그리드라 삭제는 신규행 제거 전용으로만 쓴다.
  // removeRow 두 번째 인자 deleteOnlyNew=true 로 기존행에 D flag 를 찍지 않는다
  //   (기존 항목 비활성은 VALID_YN='N' 으로 처리). activeTab 기준이라 전 탭 공통 적용된다.
  const handleDelete = () => {
    if (!gridRefs[activeTab].current) return;
    GridAction.removeRow(gridRefs[activeTab].current, true);
  };

  const handleSave = () => {
    const grid = gridRefs[activeTab].current;
    grid?.finishEditing();

    // 변경/신규 행이 없으면 "수정한 내용이 없습니다" toast — 저장 훅의 빈배열 가드를 컴포넌트로
    //   앞당긴다(변경 없음 = toast, 필수·검증 실패 = modal alert. DMF0005/0006/0007 과 동일 규약).
    //   dirty 행은 그리드 소스(collectionView.sourceCollection)에서 읽는다 — 신규행(addRow)은 조회
    //   전 쿼리 데이터가 undefined 라 그쪽으로는 안 잡힌다.
    const dirtyRows = (
      (grid?.collectionView?.sourceCollection ?? []) as { CRUD_TYPE?: string }[]
    ).filter(row => row.CRUD_TYPE);
    if (dirtyRows.length === 0) {
      setToast({ type: 'error', message: t('MSG_NO_CHANGE', '_수정한 내용이 없습니다.') });
      return;
    }

    // dirty 행은 그리드 소스(collectionView.sourceCollection)에서 읽는다 — 신규행(GridAction.addRow)은
    //   그 배열에 splice 되고 조회 전엔 쿼리 데이터가 undefined 라 그쪽으로는 안 잡힌다. 그리드
    //   소스로 읽어야 신규행 저장 시 필수검증이 걸린다(DMF0006/DMF0007 과 동일 규약).
    switch (activeTab) {
      case SHEET_INDEX.SITE: {
        const endCustomerRows = (grid?.columns.getColumn('END_CUSTOMER')?.dataMap?.collectionView
          .items ?? []) as ComboResponse[];
        const soldToCustomerRows = (grid?.columns.getColumn('SOLDTO_CUSTOMER')?.dataMap
          ?.collectionView.items ?? []) as ComboResponse[];
        const src = (grid?.collectionView?.sourceCollection ?? []) as NonNullable<
          typeof siteData
        >['salesSite'];
        const saveData = src
          .filter(item => item.CRUD_TYPE)
          .map(item => ({
            ...item,
            END_CUSTOMER: resolveComboCodeByDivision(
              endCustomerRows,
              String(item.DIVISION_ID ?? ''),
              String(item.END_CUSTOMER ?? '')
            ),
            SOLDTO_CUSTOMER: resolveComboCodeByDivision(
              soldToCustomerRows,
              String(item.DIVISION_ID ?? ''),
              String(item.SOLDTO_CUSTOMER ?? '')
            ),
          }));
        const staticColumn = staticColumns.salesSite;
        // 이 그리드가 조회조건 Sales Site 콤보의 원천이다 — 저장으로 사이트가 늘거나(신규)
        //   Active 가 바뀌면 콤보 목록도 달라지므로 저장 성공 직후 콤보를 다시 받는다.
        //   mutate 호출 단위 onSuccess 는 훅 기본 onSuccess(토스트 + 그리드 재조회) 다음에 이어서 실행된다.
        saveWithValidation(saveData, staticColumn, rows =>
          mutateSite(rows, {
            onSuccess: () => void invalidateCombos([...SALES_SITE_STALE_COMBO_IDS]),
          })
        );
        break;
      }
      case SHEET_INDEX.CUSTOMER: {
        const src = (grid?.collectionView?.sourceCollection ?? []) as NonNullable<
          typeof detailData
        >['salesCustomer'];
        const saveData = src.filter(item => item.CRUD_TYPE);
        saveWithValidation(saveData, staticColumns.salesCustomer, mutateCustomer);
        break;
      }
      case SHEET_INDEX.LOCATION: {
        const src = (grid?.collectionView?.sourceCollection ?? []) as NonNullable<
          typeof detailData
        >['salesLocation'];
        const saveData = src.filter(item => item.CRUD_TYPE);
        saveWithValidation(saveData, staticColumns.salesLocation, mutateLocation);
        break;
      }
      case SHEET_INDEX.BUCKET: {
        const src = (grid?.collectionView?.sourceCollection ?? []) as NonNullable<
          typeof detailData
        >['salesBucket'];
        const saveData = src.filter(item => item.CRUD_TYPE);
        saveWithValidation(saveData, staticColumns.salesBucket, mutateBucket);
        break;
      }
    }
  };

  const hotkeyConfig: HotkeyConfig = {
    insert: handleInsert,
    save: handleSave,
    delete: handleDelete,
    search: () => {
      setSiteFilters();
      void fetchStaticColumns();
    },
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
      <SalesSiteForm
        setActiveTab={setActiveTab}
        openDetailGrid={openDetailGrid}
        setOpenDetailGrid={setOpenDetailGrid}
      />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRefs[activeTab]}
        gridFilter={gridFilterRefs[activeTab]}
        dataCount={detailDataCountByTab[activeTab] ?? 0}
        excelFileName='Sales Site'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      {/* 상하 드래그 분할 — 초기 비율은 기존 flex-grow 5:3 을 그대로 옮긴 62.5 : 37.5.
          Detail 체크 해제 시 아래 Panel/Separator 가 통째로 빠져 상단이 100% 를 차지한다. */}
      <PanelGroup className={styles.tableWrapper} orientation='vertical'>
        <Panel defaultSize={62.5} minSize={20}>
          <SalesSiteGrid
            gridRef={gridRefs[SHEET_INDEX.SITE]}
            gridFilterRef={gridFilterRefs[SHEET_INDEX.SITE]}
            data={siteRows}
            setActiveTab={setActiveTab}
          />
        </Panel>

        {openDetailGrid && <PanelSeparator className={styles.splitBar} />}
        {openDetailGrid && (
          <Panel defaultSize={37.5} minSize={15}>
            <div className={styles.lowerGrid}>
              <TabWrapper persist>
                <TabItem label={t('LBL00314', '_Sales Customer')}>
                  <SalesSiteCustomerGrid
                    gridRef={gridRefs[SHEET_INDEX.CUSTOMER]}
                    gridFilterRef={gridFilterRefs[SHEET_INDEX.CUSTOMER]}
                    data={customerRows}
                    setActiveTab={setActiveTab}
                  />
                </TabItem>
                <TabItem label={t('LBL00315', '_Sales Location')}>
                  <SalesSiteLocationGrid
                    gridRef={gridRefs[SHEET_INDEX.LOCATION]}
                    gridFilterRef={gridFilterRefs[SHEET_INDEX.LOCATION]}
                    data={locationRows}
                    setActiveTab={setActiveTab}
                  />
                </TabItem>
                <TabItem label={t('LBL00032', '_Sales Bucket')}>
                  <SalesSiteBucketGrid
                    gridRef={gridRefs[SHEET_INDEX.BUCKET]}
                    gridFilterRef={gridFilterRefs[SHEET_INDEX.BUCKET]}
                    data={bucketRows}
                    setActiveTab={setActiveTab}
                  />
                </TabItem>
              </TabWrapper>
            </div>
          </Panel>
        )}
      </PanelGroup>
    </>
  );
};
