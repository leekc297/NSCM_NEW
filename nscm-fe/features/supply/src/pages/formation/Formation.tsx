import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import {
  useProcMutation,
  useSaveWithValidation,
  useTabBtnPermissions,
  useTabProcQuery,
} from '@shared/hooks';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore } from '@shared/stores';

import { FormationExceptGrid } from './components/FormationExceptGrid';
import { FormationExceptLtGrid } from './components/FormationExceptLtGrid';
import { FormationForm } from './components/FormationForm';
import { FormationGrid } from './components/FormationGrid';
import {
  COLUMN_SHEET_NAME,
  MENU_ID,
  MSG,
  RESPONSE_SET,
  SHEET_INDEX,
  SHEETS,
} from './formation.constants';
import styles from './Formation.module.scss';
import { useFormationStore } from './useFormationStore';

// 하단(Except/Except_LT) 기간 검증용 — FPDateText 값(yyyyMMdd·yyyy-MM-dd 등)을 숫자만 남겨
//   yyyyMMdd 8자리로 정규화한다. 형식이 달라도 8자리 문자열 비교가 곧 날짜 순서 비교다.
//   8자리 미만(빈값·형식오류)이면 '' 를 돌려 비교 대상에서 뺀다(빈값은 저장 필수검증 몫).
const toYmd8 = (v: string | number | null | undefined): string => {
  const digits = String(v ?? '').replace(/\D/g, '');
  return digits.length >= 8 ? digits.slice(0, 8) : '';
};

// 실제 달력에 있는 날짜인지(예: 20261232 차단). SCP0006 N8-format 과 동일 판정.
const isValidYmd8 = (ymd8: string): boolean => {
  const y = Number(ymd8.slice(0, 4));
  const m = Number(ymd8.slice(4, 6));
  const d = Number(ymd8.slice(6, 8));
  const dt = new Date(Date.UTC(y, m - 1, d));
  return dt.getUTCFullYear() === y && dt.getUTCMonth() === m - 1 && dt.getUTCDate() === d;
};

// 컬럼 메타 바인딩은 대문자(FORMATION_START/END_DATE)이나 SP 응답 케이싱은 소문자일 수 있어 양쪽을 읽는다.
const readYmd = (row: Record<string, unknown>, edge: 'start' | 'end'): string => {
  const raw =
    edge === 'start'
      ? (row.FORMATION_START_DATE ?? row.formation_start_date)
      : (row.FORMATION_END_DATE ?? row.formation_end_date);
  return toYmd8(raw as string | number | null | undefined);
};

const rowKey = (row: Record<string, unknown>): string =>
  [
    row.DIVISION_ID ?? row.division_id,
    row.PLANT_SITE_ID ?? row.plant_site_id,
    row.ITEM_ID ?? row.item_id,
  ].join('|');

// 하단(Except/Except_LT) 저장 전 기간 겹침 검사 — 같은 키(division/plant/item)에서 두 예외 기간이
//   겹치면 저장을 막는다(AS-IS checkValidN5 → MSG00105). 서버 SAVE_EXCEPT 도 99010 rollback 으로
//   무결성을 보장하지만, 불필요한 서버 왕복을 피하고 AS-IS 인라인 피드백 패리티를 맞추기 위해 클라에서
//   선차단한다. 삭제행('D')·기간 미입력행은 제외한다. 8자리 문자열 비교가 곧 날짜 순서 비교다.
const hasPeriodOverlap = (rows: Record<string, unknown>[]): boolean => {
  const groups = new Map<string, { s: string; e: string }[]>();
  for (const row of rows) {
    if ((row.CRUD_TYPE as string | undefined) === CRUD_TYPE.DELETE) continue;
    const s = readYmd(row, 'start');
    const e = readYmd(row, 'end');
    if (!s || !e) continue;
    const bucket = groups.get(rowKey(row)) ?? [];
    bucket.push({ s, e });
    groups.set(rowKey(row), bucket);
  }
  for (const bucket of groups.values()) {
    for (let i = 0; i < bucket.length; i += 1) {
      for (let j = i + 1; j < bucket.length; j += 1) {
        // [s1,e1] 과 [s2,e2] 가 겹치면 s1<=e2 && s2<=e1.
        if (bucket[i].s <= bucket[j].e && bucket[j].s <= bucket[i].e) return true;
      }
    }
  }
  return false;
};

// 날짜 하한(17530101) 미만 검사 — AS-IS checkValidN0 → MSG00048.
const DATE_LOWER_BOUND = '17530101';
const hasBelowLowerBound = (rows: Record<string, unknown>[]): boolean =>
  rows.some(row => {
    if ((row.CRUD_TYPE as string | undefined) === CRUD_TYPE.DELETE) return false;
    const s = readYmd(row, 'start');
    const e = readYmd(row, 'end');
    return (!!s && s < DATE_LOWER_BOUND) || (!!e && e < DATE_LOWER_BOUND);
  });

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
  const divisionAuthorized = useFormationStore(state => state.divisionAuthorized);

  // 지금 포커스된 그리드(Main / Except / Except_LT). 각 그리드가 gotFocus 에서 갱신한다(AS-IS fps).
  const [activeTab, setActiveTab] = useState<SHEET_INDEX>(SHEET_INDEX.FORMATION);

  const { saveWithValidation } = useSaveWithValidation();
  const { setToast, setAlert } = useMessageStore.getState();

  // 버튼 노출은 admin 버튼권한 메타(SCM_ADM_MNU_BTN_MPG_M/USER_GR_...BTN_MPG_M)로 구동한다(하드코딩 금지).
  //   INSERT/DELETE 는 하단 Except/ExceptLT 시트에만 등록되어 있고 hasButton 은 메뉴 단위 집계라
  //   버튼은 노출되며, Main 포커스 시엔 handleInsert/handleDelete 가 자체 가드로 no-op 한다.
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // 하단 탭(Except=0 / Except_LT=1) 활성 인덱스 — 편집중 전환 가드(MSG01149)를 위해 controlled.
  const [lowerTabIndex, setLowerTabIndex] = useState(0);

  // 서버 SAVE_EXCEPT/_LT 는 기간 겹침 시 99010(RAISE_APPLICATION_ERROR -20010)으로 rollback 한다.
  //   클라 pre-check 로 대부분 선차단하지만, 놓친 경우 제네릭 오류 대신 MSG00700(중첩된 기간) 메시지로 매핑한다.
  const handleExceptError = (error?: Error) => {
    const message = error?.message ?? '';
    void setAlert({
      type: 'alert',
      content: /99010|20010|overlap|중첩/i.test(message)
        ? t('MSG00700', '_중첩된 기간이 있습니다.')
        : message || t('MSG00003', '_저장에 실패하였습니다.'),
    });
  };

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
    onError: handleExceptError,
  });
  const { mutate: mutateExceptLt } = useProcMutation<
    MENU_ID,
    SHEETS.EXCEPT_LT,
    RESPONSE_SET.EXCEPT_LT
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.EXCEPT_LT,
    tabId,
    onError: handleExceptError,
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
  //   Main 미선택이면 MSG01104(선택된 행이 없습니다 — AS-IS MSG00071).
  const handleInsert = () => {
    if (activeTab === SHEET_INDEX.FORMATION) return;
    const mainGrid = gridRefs[SHEET_INDEX.FORMATION].current;
    const selected = mainGrid?.selectedItems?.[0] as Record<string, unknown> | undefined;
    if (!selected) {
      setToast({ type: 'error', message: t('MSG01104', '_선택된 행이 없습니다.') });
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

  // 하단 탭(Except↔Except_LT) 전환 가드 — 현재 시트가 편집중(dirty)이면 전환을 막고 MSG01149 경고.
  //   AS-IS 시트 전환 가드 패턴(SCP0125/0126 등 SpdExcept_ActiveSheetChanging) 재현. controlled TabWrapper.
  const handleLowerTabChange = (nextIndex: number) => {
    if (nextIndex === lowerTabIndex) return;
    const currentSheet = lowerTabIndex === 0 ? SHEET_INDEX.EXCEPT : SHEET_INDEX.EXCEPT_LT;
    const currentGrid = gridRefs[currentSheet].current;
    currentGrid?.finishEditing();
    const dirty = (
      (currentGrid?.collectionView?.sourceCollection ?? []) as { CRUD_TYPE?: string }[]
    ).some(row => row.CRUD_TYPE);
    if (dirty) {
      // MSG01149: "{0}를 수정 중이어서 시트를 변경 할 수 없습니다." {0}=편집 중인 시트명.
      const currentSheetName =
        lowerTabIndex === 0
          ? COLUMN_SHEET_NAME[RESPONSE_SET.EXCEPT]
          : COLUMN_SHEET_NAME[RESPONSE_SET.EXCEPT_LT];
      void setAlert({
        type: 'alert',
        content: t('MSG01149', '_{0}를 수정 중이어서 시트를 변경 할 수 없습니다.').replace(
          '{0}',
          currentSheetName
        ),
      });
      return;
    }
    setLowerTabIndex(nextIndex);
    setActiveTab(nextIndex === 0 ? SHEET_INDEX.EXCEPT : SHEET_INDEX.EXCEPT_LT);
  };

  const handleSave = () => {
    const grid = gridRefs[focusedTab].current;
    grid?.finishEditing();

    const dirtyRows = (
      (grid?.collectionView?.sourceCollection ?? []) as { CRUD_TYPE?: string }[]
    ).filter(row => row.CRUD_TYPE);
    if (dirtyRows.length === 0) {
      setToast({ type: 'error', message: t('MSG00004', '_수정한 내용이 없습니다.') });
      return;
    }

    // 하단(Except/Except_LT) 기간 검증. 시작>종료(MSG01135)는 편집행만, 하한(MSG01080)·겹침(MSG00700)은
    //   같은 키의 전체 행 기준으로 본다 — 편집행이 미변경 기존행과 겹칠 수 있어서다.
    if (focusedTab === SHEET_INDEX.EXCEPT || focusedTab === SHEET_INDEX.EXCEPT_LT) {
      const allRows = (grid?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];

      // 날짜 형식(달력에 없는 날짜) 차단 — SCP0006 N8-format 과 동일(MSG00611).
      const badFormat = dirtyRows.some(row => {
        const r = row as Record<string, unknown>;
        const start = readYmd(r, 'start');
        const end = readYmd(r, 'end');
        return (!!start && !isValidYmd8(start)) || (!!end && !isValidYmd8(end));
      });
      if (badFormat) {
        void setAlert({
          type: 'alert',
          content: t(MSG.INVALID_DATE_FORMAT, '_유효한 날짜 형식이 아닙니다. (YYYYMMDD)'),
        });
        return;
      }

      const badPeriod = dirtyRows.some(row => {
        const r = row as Record<string, unknown>;
        const start = readYmd(r, 'start');
        const end = readYmd(r, 'end');
        return !!start && !!end && end < start;
      });
      if (badPeriod) {
        void setAlert({
          type: 'alert',
          content: t('MSG01135', '_시작일자가 종료일자보다 늦을 수 없습니다.'),
        });
        return;
      }

      // 날짜 하한 17530101 미만 차단(AS-IS checkValidN0 → MSG00048).
      if (hasBelowLowerBound(allRows)) {
        void setAlert({
          type: 'alert',
          content: t('MSG01080', '_처리가능한 날짜 범위가 아닙니다. {0}').replace(
            '{0}',
            DATE_LOWER_BOUND
          ),
        });
        return;
      }

      // 같은 키에서 예외 기간이 겹치면 저장 전 차단(AS-IS checkValidN5 → MSG00105).
      if (hasPeriodOverlap(allRows)) {
        void setAlert({ type: 'alert', content: t('MSG00700', '_중첩된 기간이 있습니다.') });
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
    // Insert/Delete 는 버튼 메타에 없어 권한 게이팅 대상이 아니다(design 01 §2.6) — 상시 노출,
    // 동작 가드는 handleInsert/handleDelete 의 activeTab·선택행 조건으로 제어(memory scp0022-insert-only-on-lower-except-grid).
    insert: handleInsert,
    save: hasButton('SAVE') ? handleSave : false,
    delete: handleDelete,
    search: hasButton('SEARCH')
      ? () => {
          // 권한 division 0건이면 조회 차단 + 안내(AS-IS SetDivisionAuthCheck, R2). FormationForm onSearch 와 동일 규약.
          if (!divisionAuthorized) {
            void setAlert({
              type: 'alert',
              content: t('MSG00667', '_권한을 가진 Division이 없습니다.'),
            });
            return;
          }
          setFilters();
          void fetchStaticColumns();
        }
      : false,
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
        <Panel defaultSize={74} minSize={20}>
          <FormationGrid
            gridRef={gridRefs[SHEET_INDEX.FORMATION]}
            gridFilterRef={gridFilterRefs[SHEET_INDEX.FORMATION]}
            data={formationRows}
            setActiveTab={setActiveTab}
          />
        </Panel>
        <PanelSeparator className={styles.splitBar} />
        <Panel defaultSize={26} minSize={15}>
          <div className={styles.lowerGrid}>
            <TabWrapper
              persist
              activeTabIndex={lowerTabIndex}
              setActiveTabIndex={handleLowerTabChange}
            >
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
