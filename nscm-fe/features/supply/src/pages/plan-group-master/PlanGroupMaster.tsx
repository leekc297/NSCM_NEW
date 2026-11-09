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
import {
  buildActionRows,
  buildSavePayload,
  toSaveErrorMessage,
} from './utils/plan-group-master.save';

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
  const restoreSearchConditions = usePlanGroupMasterStore(state => state.restoreSearchConditions);

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

  // mount 1회 — 컬럼 메타 로드 + F6 저장 조회조건 복원(basic-check #3).
  //   복원은 searchParams 만 patch 하고 filters 는 불변이라 진입 자동조회 게이트는 유지된다
  //   (저장측은 아래 SubTitle `searchParam={searchParams}`).
  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
    void restoreSearchConditions();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 조회조건 6커서 공급 시드 + F10 자가복구(basic-check #4). mount([tabId])가 아니라 값 축
  //   (searchInfoFilters)으로 둔다 — F10(공용 SubTitle resetSearchCondition → store reset())은
  //   searchInfoFilters 를 {} 로 비우는데(공용 PRESERVED_ON_CONDITION_RESET 밖 화면 로컬 키), 그러면
  //   GET_SEARCH_INFO 쿼리 enabled 가 false 로 떨어지고 queryKey 가 빈 filters 로 갈려 searchInfoData 가
  //   사라져 5개 멀티셀렉트(Operation/Plant/Building/Line/Plan Group) 공급 커서가 공란이 된다. [tabId]
  //   마운트 effect 는 F10 후 재발화하지 않으니 비면 재시드해 자가복구한다(loadSearchInfo 내부 가드로
  //   1회만 세팅 — 재진입 전까지 콤보 소실 방지, f10-wipes-combo-seeded-auth-gate-flags 패턴).
  useEffect(() => {
    loadSearchInfo();
  }, [searchInfoFilters, loadSearchInfo]);

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
    const added = GridAction.addRow(grid, defaults, 'above', true);
    // 선택을 새 행으로 옮긴다 — 원래 행에 남으면 바로 Delete 할 때 새 행이 아니라 원래 행이 삭제 대상이 된다.
    const addedRow = grid.rows.findIndex(row => row.dataItem === added);
    if (addedRow >= 0) grid.select(addedRow, Math.max(grid.selection.col, 0));
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
    } catch (error) {
      // 저장 거부(결과 커서 CODE ≠ 0) — 공용 응답 처리가 오류로 던진다. 변경 표시는 그대로 둔다(갭분석 C-20).
      void setAlert({
        type: 'alert',
        content: toSaveErrorMessage(error) ?? t(MSG.SAVE_FAIL, '_An error occurred while saving.'),
      });
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
    // Delete 미이식 — AS-IS SCP0121 에는 Delete 버튼이 없다(DeleteButton 오버라이드 없음). 삭제는
    //   기존행 Plan Group 공백화 후 저장 시 'D' 처리뿐(cs:584-588). 전용 Delete 버튼 금지(AS-IS 일치,
    //   사용자 지시 2026-11-03).
    //   필수: false 로 명시한다 — 키를 생략하면 공용 SubTitle 의 DefaultButtonActions(F9=removeRow)가
    //   스프레드 머지에서 그대로 살아남아 버튼이 노출·동작한다(delete===false 일 때만 숨김, SubTitle:420).
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
          // 사용자 요청(2026-10-14): Plan Group Reg 는 다국어 처리하지 않고 영문 고정.
          label: 'Plan Group Reg.',
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
