import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabProcQuery } from '@shared/hooks';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore } from '@shared/stores';

import { FormationExceptGrid } from './components/FormationExceptGrid';
import { FormationExceptLtGrid } from './components/FormationExceptLtGrid';
import { FormationForm } from './components/FormationForm';
import { FormationGrid } from './components/FormationGrid';
import { MENU_ID, RESPONSE_SET, SHEET_INDEX, SHEETS } from './formation.constants';
import styles from './Formation.module.scss';
import { useFormationStore } from './useFormationStore';

// 하단(Except/Except_LT) 기간 검증용 — FPDateText 값(yyyyMMdd·yyyy-MM-dd 등)을 숫자만 남겨
//   yyyyMMdd 8자리로 정규화한다. 형식이 달라도 8자리 문자열 비교가 곧 날짜 순서 비교다.
//   8자리 미만(빈값·형식오류)이면 '' 를 돌려 비교 대상에서 뺀다(빈값은 저장 필수검증 몫).
const toYmd8 = (v: string | number | null | undefined): string => {
  const digits = String(v ?? '').replace(/\D/g, '');
  return digits.length >= 8 ? digits.slice(0, 8) : '';
};

export const Formation = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRefs = [useRef<FlexGrid>(), useRef<FlexGrid>(), useRef<FlexGrid>()];
  const gridFilterRefs = [
    useRef<FlexGridFilter>(),
    useRef<FlexGridFilter>(),
    useRef<FlexGridFilter>(),
  ];

  const initialized = useFormationStore(state => state.initialized);
  const filters = useFormationStore(state => state.filters);
  const setFilters = useFormationStore(state => state.setFilters);
  const staticColumns = useFormationStore(state => state.staticColumns);
  const fetchStaticColumns = useFormationStore(state => state.fetchStaticColumns);
  const searchParams = useFormationStore(state => state.searchParams);
  const openSearchArea = useFormationStore(state => state.openSearchArea);
  const setOpenSearchArea = useFormationStore(state => state.setOpenSearchArea);

  // 지금 포커스된 그리드(Main / Except / Except_LT). 각 그리드가 gotFocus 에서 갱신한다(AS-IS fps).
  const [activeTab, setActiveTab] = useState<SHEET_INDEX>(SHEET_INDEX.FORMATION);

  const { saveWithValidation } = useSaveWithValidation();
  const { setToast, setAlert } = useMessageStore.getState();

  const { data: formationData } = useTabProcQuery<MENU_ID, SHEETS.FORMATION>({
    menuId: MENU_ID,
    sheetName: SHEETS.FORMATION,
    tabId,
    filters: filters[SHEETS.FORMATION],
    enabled: !!filters[SHEETS.FORMATION],
  });
  const { data: exceptData } = useTabProcQuery<MENU_ID, SHEETS.EXCEPT>({
    menuId: MENU_ID,
    sheetName: SHEETS.EXCEPT,
    tabId,
    filters: filters[SHEETS.EXCEPT],
    enabled: !!filters[SHEETS.EXCEPT],
  });
  const { data: exceptLtData } = useTabProcQuery<MENU_ID, SHEETS.EXCEPT_LT>({
    menuId: MENU_ID,
    sheetName: SHEETS.EXCEPT_LT,
    tabId,
    filters: filters[SHEETS.EXCEPT_LT],
    enabled: !!filters[SHEETS.EXCEPT_LT],
  });

  const { mutate: mutateFormation } = useProcMutation<MENU_ID, SHEETS.FORMATION>({
    menuId: MENU_ID,
    sheetName: SHEETS.FORMATION,
    tabId,
  });
  const { mutate: mutateExcept } = useProcMutation<MENU_ID, SHEETS.EXCEPT, RESPONSE_SET.EXCEPT>({
    menuId: MENU_ID,
    sheetName: SHEETS.EXCEPT,
    tabId,
  });
  const { mutate: mutateExceptLt } = useProcMutation<
    MENU_ID,
    SHEETS.EXCEPT_LT,
    RESPONSE_SET.EXCEPT_LT
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.EXCEPT_LT,
    tabId,
  });

  // itemsSource 참조 안정화(sales-site 규약) — 조회 전 신규행이 리렌더에 사라지지 않게 memo.
  //   division 이 바뀌면 새 [] 로 그리드를 비운다(deps 에 divisionId).
  const formationRows = useMemo(
    () => formationData?.formation ?? [],
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [formationData, searchParams.divisionId]
  );
  const exceptRows = useMemo(
    () => exceptData?.formationExcept ?? [],
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [exceptData, searchParams.divisionId]
  );
  const exceptLtRows = useMemo(
    () => exceptLtData?.formationExceptLt ?? [],
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [exceptLtData, searchParams.divisionId]
  );

  const countByTab: Record<number, number> = {
    [SHEET_INDEX.FORMATION]: formationRows.length,
    [SHEET_INDEX.EXCEPT]: exceptRows.length,
    [SHEET_INDEX.EXCEPT_LT]: exceptLtRows.length,
  };
  const focusedTab = activeTab;

  // Insert 는 하단(Except / Except_LT)만. Main 선택행의 키/값을 상속한 신규행을 추가한다(AS-IS InsertRow).
  //   Main 미선택이면 MSG00071(선택된 행이 없습니다).
  const handleInsert = () => {
    if (activeTab === SHEET_INDEX.FORMATION) return;
    const mainGrid = gridRefs[SHEET_INDEX.FORMATION].current;
    const selected = mainGrid?.selectedItems?.[0] as Record<string, unknown> | undefined;
    if (!selected) {
      setToast({ type: 'error', message: t('MSG00071', '_선택된 행이 없습니다.') });
      return;
    }
    const target = gridRefs[focusedTab].current;
    if (!target) return;

    const inherited =
      activeTab === SHEET_INDEX.EXCEPT
        ? {
            FORMATION_YIELD: selected.FORMATION_YIELD,
            CHAR_YIELD: selected.CHAR_YIELD,
            FORMATION_TOTAL_YIELD: selected.FORMATION_TOTAL_YIELD,
          }
        : {
            LT_FORMATION: selected.LT_FORMATION,
            ADD_LT_FORMATION: selected.ADD_LT_FORMATION,
          };

    GridAction.addRow(target, {
      DIVISION_ID: selected.DIVISION_ID,
      PLANT_SITE_ID: selected.PLANT_SITE_ID,
      PLANT_SITE_NAME: selected.PLANT_SITE_NAME,
      ITEM_ID: selected.ITEM_ID,
      NICK_NAME: selected.NICK_NAME,
      ...inherited,
    });
  };

  const handleDelete = () => {
    if (activeTab === SHEET_INDEX.FORMATION) return; // Main 삭제 없음
    const target = gridRefs[focusedTab].current;
    if (target) GridAction.removeRow(target);
  };

  const handleSave = () => {
    const grid = gridRefs[focusedTab].current;
    grid?.finishEditing();

    const dirtyRows = (
      (grid?.collectionView?.sourceCollection ?? []) as { CRUD_TYPE?: string }[]
    ).filter(row => row.CRUD_TYPE);
    if (dirtyRows.length === 0) {
      setToast({ type: 'error', message: t('MSG_NO_CHANGE', '_수정한 내용이 없습니다.') });
      return;
    }

    // 하단(Except/Except_LT) 기간 검증 — 종료일이 시작일보다 빠르면 저장 차단(MSG00108).
    //   컬럼 메타 바인딩은 대문자(FORMATION_START/END_DATE)이고 SP 응답 케이싱은 소문자일 수
    //   있어 양쪽을 모두 읽는다. 둘 다 8자리(yyyyMMdd)로 정규화된 경우에만 비교한다.
    if (focusedTab === SHEET_INDEX.EXCEPT || focusedTab === SHEET_INDEX.EXCEPT_LT) {
      const badPeriod = dirtyRows.some(row => {
        const r = row as Record<string, unknown>;
        const start = toYmd8(
          (r.FORMATION_START_DATE ?? r.formation_start_date) as string | number | null | undefined
        );
        const end = toYmd8(
          (r.FORMATION_END_DATE ?? r.formation_end_date) as string | number | null | undefined
        );
        return !!start && !!end && end < start;
      });
      if (badPeriod) {
        void setAlert({
          type: 'alert',
          content: t('MSG00108', '_조회 기간이 잘못되었습니다 (시작일 > 종료일).'),
        });
        return;
      }
    }

    switch (focusedTab) {
      case SHEET_INDEX.FORMATION: {
        const src = (grid?.collectionView?.sourceCollection ?? []) as NonNullable<
          typeof formationData
        >['formation'];
        saveWithValidation(
          src.filter(item => item.CRUD_TYPE),
          staticColumns[RESPONSE_SET.FORMATION],
          mutateFormation
        );
        break;
      }
      case SHEET_INDEX.EXCEPT: {
        const src = (grid?.collectionView?.sourceCollection ?? []) as NonNullable<
          typeof exceptData
        >['formationExcept'];
        saveWithValidation(
          src.filter(item => item.CRUD_TYPE),
          staticColumns[RESPONSE_SET.EXCEPT],
          mutateExcept
        );
        break;
      }
      case SHEET_INDEX.EXCEPT_LT: {
        const src = (grid?.collectionView?.sourceCollection ?? []) as NonNullable<
          typeof exceptLtData
        >['formationExceptLt'];
        saveWithValidation(
          src.filter(item => item.CRUD_TYPE),
          staticColumns[RESPONSE_SET.EXCEPT_LT],
          mutateExceptLt
        );
        break;
      }
    }
  };

  const hotkeyConfig: HotkeyConfig = {
    insert: handleInsert,
    save: handleSave,
    delete: handleDelete,
    search: () => {
      setFilters();
      void fetchStaticColumns();
    },
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
      <FormationForm />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRefs[focusedTab]}
        gridFilter={gridFilterRefs[focusedTab]}
        dataCount={countByTab[focusedTab] ?? 0}
        excelFileName='Formation'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <PanelGroup className={styles.tableWrapper} orientation='vertical'>
        <Panel defaultSize={55} minSize={20}>
          <FormationGrid
            gridRef={gridRefs[SHEET_INDEX.FORMATION]}
            gridFilterRef={gridFilterRefs[SHEET_INDEX.FORMATION]}
            data={formationRows}
            setActiveTab={setActiveTab}
          />
        </Panel>
        <PanelSeparator className={styles.splitBar} />
        <Panel defaultSize={45} minSize={15}>
          <div className={styles.lowerGrid}>
            <TabWrapper persist>
              <TabItem label='Formation Except'>
                <FormationExceptGrid
                  gridRef={gridRefs[SHEET_INDEX.EXCEPT]}
                  gridFilterRef={gridFilterRefs[SHEET_INDEX.EXCEPT]}
                  data={exceptRows}
                  setActiveTab={setActiveTab}
                />
              </TabItem>
              <TabItem label='Formation Except LT'>
                <FormationExceptLtGrid
                  gridRef={gridRefs[SHEET_INDEX.EXCEPT_LT]}
                  gridFilterRef={gridFilterRefs[SHEET_INDEX.EXCEPT_LT]}
                  data={exceptLtRows}
                  setActiveTab={setActiveTab}
                />
              </TabItem>
            </TabWrapper>
          </div>
        </Panel>
      </PanelGroup>
    </>
  );
};
