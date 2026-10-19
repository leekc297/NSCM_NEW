import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import {
  useInvalidateCombos,
  useSaveWithValidation,
  useTabBtnPermissions,
  useTabProcQuery,
} from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { PlanGroupInfoModal } from './components/modals/PlanGroupInfoModal';
import { PlanGroupMasterForm } from './components/PlanGroupMasterForm';
import { PlanGroupMasterGrid } from './components/PlanGroupMasterGrid';
import { usePlanGroupMasterValidation } from './hooks/usePlanGroupMasterValidation';
import {
  COLUMNS,
  INSERT_COPY_COLUMNS,
  MENU_ID,
  MSG,
  PLAN_GROUP_COMBO_ID,
  SHEETS,
} from './plan-group-master.constants';
import type { LineInfoRow, PlanGroupRow, SearchInfoRow } from './plan-group-master.types';
import { usePlanGroupMasterStore } from './usePlanGroupMasterStore';
import type { ActionRow } from './utils/plan-group-master.save';
import { buildActionRows, buildSavePayload } from './utils/plan-group-master.save';

export const PlanGroupMaster = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGrid<PlanGroupRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker<PlanGroupRow>>();
  const savingRef = useRef<boolean>(false);

  const initialized = usePlanGroupMasterStore(state => state.initialized);
  const filters = usePlanGroupMasterStore(state => state.filters);
  const searchInfoFilters = usePlanGroupMasterStore(state => state.searchInfoFilters);
  const staticColumns = usePlanGroupMasterStore(state => state.staticColumns);
  const searchParams = usePlanGroupMasterStore(state => state.searchParams);
  const openSearchArea = usePlanGroupMasterStore(state => state.openSearchArea);
  const setOpenSearchArea = usePlanGroupMasterStore(state => state.setOpenSearchArea);
  const setMainFilters = usePlanGroupMasterStore(state => state.setMainFilters);
  const loadSearchInfo = usePlanGroupMasterStore(state => state.loadSearchInfo);
  const fetchStaticColumns = usePlanGroupMasterStore(state => state.fetchStaticColumns);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  // 편집 모드 토글 미이식(convert-core §2.4 / 01_layout R4·R5) — mount 1회 canEdit 만. 모드 상태 신설 금지.
  const canEdit = hasButton('EDIT');

  const { setToast, setAlert } = useMessageStore.getState();
  const sessionUserId = useSessionStore(state => state.session.userId);
  const invalidateCombos = useInvalidateCombos();
  const { validate } = usePlanGroupMasterValidation();
  const { saveWithValidation } = useSaveWithValidation();

  const [openRegModal, setOpenRegModal] = useState<boolean>(false);

  // 조회조건 6커서 공급 — mount 1회 (Search 게이트와 분리). userId='' (BE 세션 보정).
  const { data: searchInfoData, refetch: refetchSearchInfo } = useTabProcQuery<
    MENU_ID,
    SHEETS.SEARCH_INFO
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.SEARCH_INFO,
    tabId,
    filters: searchInfoFilters[SHEETS.SEARCH_INFO],
    enabled: !!searchInfoFilters[SHEETS.SEARCH_INFO],
  });

  // 그리드 조회 — Search 게이트(filters[MAIN]) 로만 발사. SP MISSING(convert-sp 후속) → 런타임 미동작.
  const { data: mainData, refetch: refetchMain } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });

  const operationRows = useMemo<SearchInfoRow[]>(
    () => searchInfoData?.operationList ?? [],
    [searchInfoData]
  );
  const plantRows = useMemo<SearchInfoRow[]>(
    () => searchInfoData?.plantList ?? [],
    [searchInfoData]
  );
  const buildingRows = useMemo<SearchInfoRow[]>(
    () => searchInfoData?.factoryList ?? [],
    [searchInfoData]
  );
  const lineRows = useMemo<LineInfoRow[]>(() => searchInfoData?.lineList ?? [], [searchInfoData]);
  const planGroupRows = useMemo<SearchInfoRow[]>(
    () => searchInfoData?.planGroupList ?? [],
    [searchInfoData]
  );

  // itemsSource 참조 안정화 (매 렌더 새 `?? []` 로 신규행이 사라지는 것 방지, nscm-patterns §5-4).
  const rows = useMemo(
    () => (mainData as { o_rc1?: PlanGroupRow[] })?.o_rc1 ?? [],
    [mainData]
  );

  // mount 1회 — 컬럼 메타 + 조회조건 공급 로드.
  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
    loadSearchInfo();
  }, [tabId]);

  const handleSearch = () => {
    setMainFilters();
  };

  // Insert (W5/W6, AUTH-05) — 현재 선택행 키 1~7 복사 + 신규행. 복사원본 없으면(빈 그리드/미선택) 삽입 가드
  //   재현(convert-core §2.4, `?? 기본값` 폴백 금지). canEdit 아니면 비활성(hotkeyConfig 에서 차단).
  const handleInsert = () => {
    const grid = gridRef.current;
    if (!grid) return;
    const source = grid.selectedItems[0] as PlanGroupRow | undefined;
    if (!source) return; // 복사원본 필수 — 미조회/미선택 삽입 방지.
    const defaults: Partial<PlanGroupRow> = {};
    for (const col of INSERT_COPY_COLUMNS) {
      (defaults as Record<string, unknown>)[col] = source[col];
    }
    // 신규행 Plan Group/Model 은 빈값, PRE_* 는 빈값(신규 판정 = pre 둘 다 공백).
    (defaults as Record<string, unknown>)[COLUMNS.OPMZ_PLAN_GR_ID] = '';
    (defaults as Record<string, unknown>)[COLUMNS.OPMZ_PLAN_GR_ITEM_ID] = '';
    (defaults as Record<string, unknown>)[COLUMNS.PRE_PLAN_GR_ID] = '';
    (defaults as Record<string, unknown>)[COLUMNS.PRE_PLAN_GR_ITEM_ID] = '';
    GridAction.addRow(grid, defaults, 'above', true);
  };

  // ^-결합 payload → call-proc 실제 저장 (SP MISSING — convert-sp 후속). false-success 판별(§5-10).
  const performSave = async (actionRows: ActionRow[]) => {
    const payload = buildSavePayload(actionRows, sessionUserId ?? '');
    savingRef.current = true;
    try {
      const res = await apiClient.post<{ code?: string | number; message?: string }>(
        `/${MENU_ID}/main/SAVE/call-proc`,
        payload
      );
      // false-success 판별 (nscm-patterns §5-10) — 인터셉터가 500/에러를 resolve 할 수 있다.
      if (res.status >= 400 || Number(res.data?.code)) {
        // AS-IS W14: SP 반환 에러문자열을 그대로 노출, 없으면 MSG00618 표준 저장오류 문구.
        void setAlert({
          type: 'alert',
          content: res.data?.message ?? t(MSG.SAVE_FAIL, '_An error occurred while saving.'),
        });
        return;
      }
      void setToast({
        type: 'success',
        // MSG00672 "{0} data saved." — i18next 보간 미사용, 호출부 .replace (MSG-03).
        message: t(MSG.SAVE_SUCCESS, '_{0} data saved.').replace('{0}', String(actionRows.length)),
      });
      editTrackerRef.current?.clearChanges();
      void refetchMain();
    } finally {
      savingRef.current = false;
    }
  };

  // Save (R6 가드 + W9~W15) — 그리드 소스 dirty 행 → I/M/D → 검증 → ^-결합 payload → call-proc.
  //   AS-IS(cs:509-846)에는 저장 확인창이 없다 — MSG00001 재사용 확인창 제거(GAP-02).
  const handleSave = () => {
    const grid = gridRef.current;
    if (!grid) return; // R6: 그리드 미생성 가드.
    if (savingRef.current) return;
    grid.finishEditing();

    // wijmo sourceCollection 은 무타입(any[]) — 런타임 PlanGroupRow 형상 확정이라 unknown 경유 변환.
    const source = (grid.collectionView?.sourceCollection ?? []) as unknown as PlanGroupRow[];
    const dirty = source.filter(r => (r as { CRUD_TYPE?: string }).CRUD_TYPE);
    const actionRows = buildActionRows(dirty);
    if (actionRows.length === 0) {
      void setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_No changes to save.') });
      return;
    }

    // 커스텀 검증 W9~W12 — 변경행을 그리드 전체(source=dtmain)와 대조(GAP-03, AS-IS cs:688-745).
    if (!validate(actionRows, source).ok) return;

    // 공용 필수검증(useSaveWithValidation) 병행 — 메타 M/IM 추가 시 enforce(GAP-05). 통과 시에만 저장.
    saveWithValidation(dirty, staticColumns, () => void performSave(actionRows));
  };

  // btnPlanGroupReg OK → GET_SEARCH_INFO 재조회 + PlanGroup 조회/셀콤보 후보 재적재 (R3, 02 §4.6).
  const handlePlanGroupRegistered = () => {
    void refetchSearchInfo();
    void invalidateCombos([PLAN_GROUP_COMBO_ID]);
  };

  const hotkeyConfig: HotkeyConfig = {
    // Edit 모드토글 키 미설정(§2.4) — 편집 기본 ON, canEdit 로만 읽기전용 결정.
    search: hasButton('SEARCH') ? handleSearch : false,
    save: hasButton('SAVE') && canEdit ? handleSave : false,
    insert: hasButton('INSERT') && canEdit ? handleInsert : false,
    // Delete 미노출(false) — AS-IS entryPoints(00 §4)=Find/Save/Edit/Insert 4개뿐, DeleteButton override 없음.
    //   기존행 삭제는 Plan Group 공백화('D' 저장판정, 03_grid §3-d)로만 수행(GAP-06, __asis-mapping__ §2).
    delete: false,
    manual: false,
    upload: false,
  };

  const divisionText = useMemo(() => {
    const row = planGroupRows.find(r => String(r.DIVISION_ID) === searchParams.divisionId);
    return row ? String(row.DIVISION_ID) : searchParams.divisionId;
  }, [planGroupRows, searchParams.divisionId]);

  // btnPlanGroupReg — 그룹 하드코딩 금지(AUTH-11). 버튼권한 메타로 노출 판정, false 면 렌더 생략.
  const canReg = hasButton('PLAN_GROUP_REG');
  const customButtons = canReg
    ? [
        {
          label: t('_SCP0121_PLAN_GROUP_REG', '_Plan Group Reg.'),
          action: () => setOpenRegModal(true),
        },
      ]
    : undefined;

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <PlanGroupMasterForm
        operationRows={operationRows}
        plantRows={plantRows}
        buildingRows={buildingRows}
        lineRows={lineRows}
        planGroupRows={planGroupRows}
        onSearch={handleSearch}
      />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='Plan Group Master'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams as unknown as Record<keyof object, string>}
        customButtons={customButtons}
      />
      <PlanGroupMasterGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        rows={rows}
        staticColumns={staticColumns}
        canEdit={canEdit}
      />
      <PlanGroupInfoModal
        open={openRegModal}
        division={searchParams.divisionId}
        divisionText={divisionText}
        modalClose={() => setOpenRegModal(false)}
        onRegistered={handlePlanGroupRegistered}
      />
    </>
  );
};
