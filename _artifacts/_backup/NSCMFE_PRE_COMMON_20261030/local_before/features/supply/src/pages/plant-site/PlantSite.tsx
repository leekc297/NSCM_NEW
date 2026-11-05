import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import {
  useInvalidateCombos,
  useProcMutation,
  useSaveWithValidation,
  useTabBtnPermissions,
  useTabComboQueries,
  useTabProcQuery,
} from '@shared/hooks';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore } from '@shared/stores';

import { PlantSiteCustomerGrid } from './components/PlantSiteCustomerGrid';
import { PlantSiteForm } from './components/PlantSiteForm';
import { PlantSiteGrid } from './components/PlantSiteGrid';
import { PlantSiteLocationGrid } from './components/PlantSiteLocationGrid';
import { PlantSiteLocationOspGrid } from './components/PlantSiteLocationOspGrid';
import { CONST, LBL, MENU_ID, MSG, SHEET_INDEX, SHEETS } from './plant-site.constants';
import styles from './PlantSite.module.scss';
import { usePlantSiteStore } from './usePlantSiteStore';
import {
  COMBO,
  DEFAULT_PERIOD_LOOKUP_TYPE,
  PLANT_SITE_STALE_COMBO_IDS,
} from './utils/plant-site.plantSiteCombo';
import {
  defaultPeriodOf,
  str,
  validateCustomerSave,
  validateLocationSave,
} from './utils/plant-site.util';

export const PlantSite = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRefs = [useRef<FlexGrid>(), useRef<FlexGrid>(), useRef<FlexGrid>(), useRef<FlexGrid>()];
  const gridFilterRefs = [
    useRef<FlexGridFilter>(),
    useRef<FlexGridFilter>(),
    useRef<FlexGridFilter>(),
    useRef<FlexGridFilter>(),
  ];

  const initialized = usePlantSiteStore(state => state.initialized);
  const filters = usePlantSiteStore(state => state.filters);
  // 조회조건 저장(F6)·복원 대상 = 조회 폼 값. 실행된 filters.site(SP 파라미터)가 아니다 — 그걸
  //   저장하면 조회 전엔 undefined 라 저장이 무동작이고, 키(plantId/scmSiteId)도 복원 키
  //   (plantVendor/plantSite)와 어긋난다. searchParams 를 저장하면 폼과 1:1로 round-trip 된다.
  const searchParams = usePlantSiteStore(state => state.searchParams);
  const selectedSite = usePlantSiteStore(state => state.selectedSite);
  const staticColumns = usePlantSiteStore(state => state.staticColumns);
  const fetchStaticColumns = usePlantSiteStore(state => state.fetchStaticColumns);
  const setPlantSiteFilters = usePlantSiteStore(state => state.setPlantSiteFilters);
  const openSearchArea = usePlantSiteStore(state => state.openSearchArea);
  const setOpenSearchArea = usePlantSiteStore(state => state.setOpenSearchArea);

  const [activeTab, setActiveTab] = useState<SHEET_INDEX>(SHEET_INDEX.SITE);
  // 하단 TabWrapper 제어 인덱스(0=Location,1=Customer,2=Location(OSP)) — R-32 탭 전환 차단(G8)을 위해 제어형.
  const [lowerTabIndex, setLowerTabIndex] = useState<number>(0);

  const { saveWithValidation } = useSaveWithValidation();
  const { setToast, setAlert } = useMessageStore.getState();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const invalidateCombos = useInvalidateCombos();

  // site 신규행 기본값 원천 lookup(AS-IS dtPlanPeriod=LookupCommon DEFAULT_PERIOD, cs:56·1439~1452).
  //   design 03 §4.3·§5-8: 기본값은 lookup 조회 경유(하드코딩 0/0/0 금지).
  const [defaultPeriods] = useTabComboQueries({
    filters: [
      { comboId: COMBO.LOOKUP_COMMON, lookupType: DEFAULT_PERIOD_LOOKUP_TYPE, mnuId: MENU_ID },
    ],
  });

  const { data: siteData } = useTabProcQuery<MENU_ID, SHEETS.SITE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SITE,
    tabId,
    filters: filters[SHEETS.SITE],
    enabled: !!filters[SHEETS.SITE],
  });
  const { data: locationData } = useTabProcQuery<MENU_ID, SHEETS.LOCATION>({
    menuId: MENU_ID,
    sheetName: SHEETS.LOCATION,
    tabId,
    filters: filters[SHEETS.LOCATION],
    enabled: !!filters[SHEETS.LOCATION],
  });
  const { data: customerData } = useTabProcQuery<MENU_ID, SHEETS.CUSTOMER>({
    menuId: MENU_ID,
    sheetName: SHEETS.CUSTOMER,
    tabId,
    filters: filters[SHEETS.CUSTOMER],
    enabled: !!filters[SHEETS.CUSTOMER],
  });
  const { data: locationOspData } = useTabProcQuery<MENU_ID, SHEETS.LOCATION_OSP>({
    menuId: MENU_ID,
    sheetName: SHEETS.LOCATION_OSP,
    tabId,
    filters: filters[SHEETS.LOCATION_OSP],
    enabled: !!filters[SHEETS.LOCATION_OSP],
  });

  const { mutate: mutateSite } = useProcMutation<MENU_ID, SHEETS.SITE>({
    menuId: MENU_ID,
    sheetName: SHEETS.SITE,
    tabId,
  });
  const { mutate: mutateLocation } = useProcMutation<MENU_ID, SHEETS.LOCATION>({
    menuId: MENU_ID,
    sheetName: SHEETS.LOCATION,
    tabId,
  });
  const { mutate: mutateCustomer } = useProcMutation<MENU_ID, SHEETS.CUSTOMER>({
    menuId: MENU_ID,
    sheetName: SHEETS.CUSTOMER,
    tabId,
  });
  const { mutate: mutateLocationOsp } = useProcMutation<MENU_ID, SHEETS.LOCATION_OSP>({
    menuId: MENU_ID,
    sheetName: SHEETS.LOCATION_OSP,
    tabId,
  });

  // division 변경 시 그리드 비움 — searchParams.divisionId 를 deps 로 참조 안정화(§5-5).
  const divisionKey = filters[SHEETS.SITE]?.divisionId ?? '';
  const siteRows = useMemo(
    () => siteData?.o_rc1 ?? [],
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [siteData, divisionKey]
  );
  const locationRows = useMemo(() => locationData?.o_rc1 ?? [], [locationData]);
  const customerRows = useMemo(() => customerData?.o_rc1 ?? [], [customerData]);
  const locationOspRows = useMemo(() => locationOspData?.o_rc1 ?? [], [locationOspData]);

  const dataCountByTab: Record<number, number> = {
    [SHEET_INDEX.SITE]: siteRows.length,
    [SHEET_INDEX.LOCATION]: locationRows.length,
    [SHEET_INDEX.CUSTOMER]: customerRows.length,
    [SHEET_INDEX.LOCATION_OSP]: locationOspRows.length,
  };

  // 신규행(R-07~10) — 상단 site 는 기본값 세트, 하단 3시트는 마스터 선택 필수(P-06 — TO-BE 의도적 추가,
  //   AS-IS InsertRow(cs:1415~1508)에는 이 가드가 없다. selectedSite.divisionId 등 마스터 컨텍스트
  //   복사가 selectedSite 존재를 전제하므로 방어적으로 신설했다. gap-resolve iter-2 독립 감사 ID-01 정정.
  const handleInsert = () => {
    const grid = gridRefs[activeTab].current;
    if (!grid) return;

    if (activeTab === SHEET_INDEX.SITE) {
      // R-07 기본값 — SHIP/PROD_FROZEN 은 lookup DEFAULT_PERIOD 조회값, FP_PLAN_PERIOD 는 PROD_FROZEN
      //   값 복사(AS-IS cs:1439~1452 — sFpPlanFeriod 행은 주석처리돼 prodFrozen 을 넣는다).
      const shipFrozen = defaultPeriodOf(defaultPeriods, 'SHIP_FROZEN');
      const prodFrozen = defaultPeriodOf(defaultPeriods, 'PROD_FROZEN');
      GridAction.addRow(grid, {
        DIVISION_ID: CONST.AUTOMOTIVE_DIVISION,
        OSP_YN: 'Y',
        OPERATION_GROUP: 'P',
        VALID_YN: 'Y',
        NEW_YN: 'Y',
        SHIP_FROZEN: shipFrozen,
        PROD_FROZEN: prodFrozen,
        FP_PLAN_PERIOD: prodFrozen,
        BUILD_AHEAD: '0',
        PACKER_LINE_ACTIVE_YN: 'N',
      });
      return;
    }

    // 하단 sub 시트 — 마스터 미선택이면 Insert 차단(P-06, TO-BE 방어적 추가 — AS-IS 재현 아님).
    if (!selectedSite) {
      setToast({ type: 'error', message: t(MSG.NO_MASTER_SELECTED, '_마스터 행을 먼저 선택하세요.') });
      return;
    }
    // OSP 배타(AS-IS cs:559-575, R-06②③): 외주(OSP_YN='Y') 마스터는 Location 등록 불가, 내주(='N')
    //   마스터는 Location(OSP) 등록 불가. 편집 차단(sub 그리드 beginningEdit)과 동일 규칙을 Insert 에도
    //   적용해 빈 시트에 못 넣게 한다.
    if (activeTab === SHEET_INDEX.LOCATION && selectedSite.ospYn === 'Y') {
      void setAlert({
        type: 'alert',
        content: t(MSG.NO_LOCATION_FOR_OSP, '_Outsourcing Vendor는 Location을 등록할 수 없습니다.'),
      });
      return;
    }
    if (activeTab === SHEET_INDEX.LOCATION_OSP && selectedSite.ospYn !== 'Y') {
      void setAlert({
        type: 'alert',
        content: t(MSG.ONLY_OSP_LOCATION, '_Outsourcing Vendor만 Location(OSP)을 등록할 수 있습니다.'),
      });
      return;
    }
    if (activeTab === SHEET_INDEX.LOCATION) {
      // R-08 + 마스터 컨텍스트(divisionId/scmSiteId/plantId, locationSeq null).
      GridAction.addRow(grid, {
        VALID_YN: 'Y',
        LOCATION_SEQ: null,
        DIVISION_ID: selectedSite.divisionId,
        SCM_SITE_ID: selectedSite.scmSiteId,
        PLANT_ID: selectedSite.plantId,
      });
    } else if (activeTab === SHEET_INDEX.CUSTOMER) {
      // R-09: 마스터 DIVISION_ID/SCM_SITE_ID 복사 + REP='N'/VALID='Y'.
      GridAction.addRow(grid, {
        REP_YN: 'N',
        VALID_YN: 'Y',
        EDIT_FLAG: 'Y',
        DIVISION_ID: selectedSite.divisionId,
        SCM_SITE_ID: selectedSite.scmSiteId,
      });
    } else if (activeTab === SHEET_INDEX.LOCATION_OSP) {
      // R-10: 마스터 DIVISION_ID/SCM_SITE_ID/SITE_DESCRIPTION 복사(GS-071~073).
      GridAction.addRow(grid, {
        VALID_YN: 'Y',
        DIVISION_ID: selectedSite.divisionId,
        SCM_SITE_ID: selectedSite.scmSiteId,
        SITE_DESCRIPTION: selectedSite.siteDescription,
      });
    }
  };

  // R-03: Delete = 신규행('I') 전용 제거(기존행 무반응 — VALID_YN soft delete 화면).
  const handleDelete = () => {
    const grid = gridRefs[activeTab].current;
    if (!grid) return;
    GridAction.removeRow(grid, true);
  };

  // 특정 시트 그리드에 미저장(CRUD_TYPE) 행이 있는지 — live 로 collectionView 를 읽는다.
  const hasDirty = (sheet: SHEET_INDEX): boolean => {
    const src = (gridRefs[sheet].current?.collectionView?.sourceCollection ?? []) as {
      CRUD_TYPE?: string;
    }[];
    return src.some(row => row.CRUD_TYPE);
  };
  // R-06①(G6): 상단 site 그리드 dirty 여부 — 하단 sub 편집 배타 판정 원천(sub 그리드에 콜백 전달).
  const isMainDirty = () => hasDirty(SHEET_INDEX.SITE);

  // 하단 탭 순서(0=Location,1=Customer,2=Location(OSP))와 동일한 순서의 [라벨키, fallback] — 차단 메시지 {0} 치환용.
  const LOWER_SHEET_LABEL: [string, string][] = [
    [LBL.TAB_LOCATION, '_Location'],
    [LBL.TAB_CUSTOMER, '_Customer'],
    [LBL.TAB_LOCATION_OSP, '_Location(OSP)'],
  ];

  // R-32(G8): 하단 탭 전환 시 현재 탭에 미저장 변경이 있으면 차단(AS-IS spdSub_ActiveSheetChanging).
  // AS-IS 는 Yes/No 확인이 아니라 확인 버튼 하나뿐인 하드 블록이다(캡처로 실측 확인).
  const handleLowerTabChange = (next: number) => {
    const currentSheet = (lowerTabIndex + 1) as SHEET_INDEX; // Location=1,Customer=2,Location(OSP)=3
    if (hasDirty(currentSheet)) {
      const [labelKey, labelFallback] = LOWER_SHEET_LABEL[lowerTabIndex];
      const sheetName = t(labelKey, labelFallback);
      void setAlert({
        type: 'alert',
        content: t(MSG.SHEET_CHANGE_BLOCKED, {
          defaultValue: 'You are modifying {0} and can not change the sheet.',
        }).replace('{0}', sheetName),
      });
      return;
    }
    setLowerTabIndex(next);
    setActiveTab((next + 1) as SHEET_INDEX);
  };

  const handleSave = () => {
    const grid = gridRefs[activeTab].current;
    grid?.finishEditing();
    const source = (grid?.collectionView?.sourceCollection ?? []) as { CRUD_TYPE?: string }[];
    const dirty = source.filter(row => row.CRUD_TYPE);
    if (dirty.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_수정한 내용이 없습니다.') });
      return;
    }

    switch (activeTab) {
      case SHEET_INDEX.SITE: {
        const src = (grid?.collectionView?.sourceCollection ?? []) as NonNullable<
          typeof siteData
        >['o_rc1'];
        // vmiYn='N' 고정(AS-IS cs:963) + FlagD 행 validYn='N'(soft delete, design 03 §4.2).
        const saveData = src
          .filter(item => item.CRUD_TYPE)
          .map(item => ({
            ...item,
            VMI_YN: 'N',
            VALID_YN: str(item.CRUD_TYPE) === 'D' ? 'N' : item.VALID_YN,
          }));
        // site 는 다수 셀콤보(plant/site 후보)의 원천이라 저장 성공 후 콤보 재조회(MDI keep-alive).
        saveWithValidation(saveData, staticColumns.site, rows =>
          mutateSite(rows, {
            onSuccess: () => void invalidateCombos([...PLANT_SITE_STALE_COMBO_IDS]),
          })
        );
        break;
      }
      case SHEET_INDEX.LOCATION: {
        const src = (grid?.collectionView?.sourceCollection ?? []) as NonNullable<
          typeof locationData
        >['o_rc1'];
        // R-33 필수(STORAGE 공백행 Factory/Operation) + R-34 중복(Storage 또는 Factory+Operation) — 저장 차단.
        const error = validateLocationSave(src, staticColumns.location);
        if (error) {
          void setAlert({
            type: 'alert',
            content: t(error.code, '_필수 입력값을 확인하세요.', { 0: error.args?.[0] ?? '' }),
          });
          return;
        }
        saveWithValidation(src.filter(item => item.CRUD_TYPE), staticColumns.location, mutateLocation);
        break;
      }
      case SHEET_INDEX.CUSTOMER: {
        const src = (grid?.collectionView?.sourceCollection ?? []) as NonNullable<
          typeof customerData
        >['o_rc1'];
        // R-38: 신규행 SoldTo/ShipTo 공백 검사 — 저장 차단.
        const error = validateCustomerSave(src);
        if (error) {
          void setAlert({
            type: 'alert',
            content: t(error.code, '_Sold-To, Ship-To 는 필수 입력입니다.'),
          });
          return;
        }
        saveWithValidation(src.filter(item => item.CRUD_TYPE), staticColumns.customer, mutateCustomer);
        break;
      }
      case SHEET_INDEX.LOCATION_OSP: {
        const src = (grid?.collectionView?.sourceCollection ?? []) as NonNullable<
          typeof locationOspData
        >['o_rc1'];
        saveWithValidation(
          src.filter(item => item.CRUD_TYPE),
          staticColumns.locationOsp,
          mutateLocationOsp
        );
        break;
      }
    }
  };

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH')
      ? () => {
          setPlantSiteFilters();
          void fetchStaticColumns();
        }
      : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    save: hasButton('SAVE') ? handleSave : false,
    delete: hasButton('DELETE') ? handleDelete : false,
    manual: false,
    upload: false,
  };

  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <PlantSiteForm />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRefs[activeTab]}
        gridFilter={gridFilterRefs[activeTab]}
        dataCount={dataCountByTab[activeTab] ?? 0}
        excelFileName='Plant Site'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <PanelGroup className={styles.tableWrapper} orientation='vertical'>
        <Panel defaultSize={58} minSize={20}>
          <PlantSiteGrid
            gridRef={gridRefs[SHEET_INDEX.SITE]}
            gridFilterRef={gridFilterRefs[SHEET_INDEX.SITE]}
            data={siteRows}
            setActiveTab={setActiveTab}
          />
        </Panel>
        <PanelSeparator className={styles.splitBar} />
        <Panel defaultSize={42} minSize={15}>
          <div className={styles.lowerGrid}>
            <TabWrapper
              persist
              activeTabIndex={lowerTabIndex}
              setActiveTabIndex={handleLowerTabChange}
            >
              <TabItem label={t(LBL.TAB_LOCATION, '_Location')}>
                <PlantSiteLocationGrid
                  gridRef={gridRefs[SHEET_INDEX.LOCATION]}
                  gridFilterRef={gridFilterRefs[SHEET_INDEX.LOCATION]}
                  data={locationRows}
                  setActiveTab={setActiveTab}
                  isMainDirty={isMainDirty}
                />
              </TabItem>
              <TabItem label={t(LBL.TAB_CUSTOMER, '_Customer')}>
                <PlantSiteCustomerGrid
                  gridRef={gridRefs[SHEET_INDEX.CUSTOMER]}
                  gridFilterRef={gridFilterRefs[SHEET_INDEX.CUSTOMER]}
                  data={customerRows}
                  setActiveTab={setActiveTab}
                  isMainDirty={isMainDirty}
                />
              </TabItem>
              <TabItem label={t(LBL.TAB_LOCATION_OSP, '_Location(OSP)')}>
                <PlantSiteLocationOspGrid
                  gridRef={gridRefs[SHEET_INDEX.LOCATION_OSP]}
                  gridFilterRef={gridFilterRefs[SHEET_INDEX.LOCATION_OSP]}
                  data={locationOspRows}
                  setActiveTab={setActiveTab}
                  isMainDirty={isMainDirty}
                />
              </TabItem>
            </TabWrapper>
          </div>
        </Panel>
      </PanelGroup>
    </>
  );
};
