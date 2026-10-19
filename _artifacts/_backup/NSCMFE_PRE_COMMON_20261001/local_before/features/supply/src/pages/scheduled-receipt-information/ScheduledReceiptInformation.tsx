import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import {
  useProcMutation,
  useSaveWithValidation,
  useTabBtnPermissions,
  useTabComboQueries,
  useTabProcQuery,
} from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { ScheduledReceiptInformationForm } from './components/ScheduledReceiptInformationForm';
import { ScheduledReceiptInformationMainGrid } from './components/ScheduledReceiptInformationMainGrid';
import { ScheduledReceiptInformationVirtualBomGrid } from './components/ScheduledReceiptInformationVirtualBomGrid';
import {
  COLUMN_SHEET_NAME,
  COMBO,
  MENU_ID,
  MSG,
  SHEETS,
} from './scheduled-receipt-information.constants';
import type { ScheduledReceiptRow, VirtualBomRow } from './scheduled-receipt-information.types';
import { useScheduledReceiptInformationStore } from './useScheduledReceiptInformationStore';
import {
  scheduledReceiptInsertDefaults,
  virtualBomInsertDefaults,
} from './utils/scheduledReceiptInformationEditLock';
import {
  findDuplicateScheduledReceiptRows,
  validateScheduledReceiptRow,
} from './utils/scheduledReceiptInformationSaveValidation';

// 시트 인덱스 — design/00_checklist.md §3(gridSignal#4 `ChangeActiveSheet(sht01VirtualBom)`) 근거로
//   Virtual Bom 이 초기 활성 시트(design/03_grid-columns.md §4 "초기 진입" 확정).
enum SHEET_INDEX {
  VIRTUAL_BOM = 0,
  SCHEDULED_RECEIPT = 1,
}

const SHEET_LABEL: Record<SHEET_INDEX, string> = {
  [SHEET_INDEX.VIRTUAL_BOM]: COLUMN_SHEET_NAME[SHEETS.VIRTUAL_BOM],
  [SHEET_INDEX.SCHEDULED_RECEIPT]: COLUMN_SHEET_NAME[SHEETS.SCHEDULED_RECEIPT],
};

/**
 * SCP0130 Scheduled Receipt Information — 2 sheetNm 정적 그리드(pivot 아님, master-detail 아님).
 *
 * 신규(NEW) 판정 — convert-flow/goal.md ①. domain=SCP(형제 트리 실측 + namespace, 00_checklist.md
 * §0). nscmPath 는 goal.md ①에서 확정한 `features/supply/src/pages/scheduled-receipt-information/`.
 *
 * 버튼 5종 판정(design/01_layout.md §2 동적 규칙표):
 *   - FindButton/SaveButton/DeleteButton/EditButton = 실동작 확정(SP 호출·gridSignals 근거).
 *   - InsertButton = 화면설계서(GSCM_DE_화면설계서_SCP0130) "3.화면설계_이벤트항목" 시트에 "Virtual
 *     BOM/SCHEDULED RECIEPT INFORMATION 정보의 신규 데이터를 입력한다"로 명시 — **실동작 확정**
 *     (design/01_layout.md §2 #5 가 Roslyn 만으로는 "확인 필요"로 남긴 항목을 AS-IS 화면설계서
 *     원본으로 해소, 값의 원천은 엑셀 화면설계서이지 .cs 소스가 아니라는 점을 __asis-mapping__.md
 *     에 명시).
 *
 * PKG_SCP0130 는 TO-BE 미배포(all_objects 0건, goal.md ②) — 화면 구현은 진행하되 실제 조회·저장은
 * SP 배포(convert-sp 후속) 전까지 동작하지 않는다.
 *
 * 조회조건 Site/Child Material 2개는 comboId 미확정으로 필드 골격만 노출(SafetyStock/
 * DemandException 선례와 동일 처리, __asis-mapping__.md 참조).
 */
export const ScheduledReceiptInformation = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRefs = [useRef<FlexGrid>(), useRef<FlexGrid>()];
  const gridFilterRefs = [useRef<FlexGridFilter>(), useRef<FlexGridFilter>()];
  const editTrackerRefs: [
    MutableRefObject<EditTracker<VirtualBomRow> | undefined>,
    MutableRefObject<EditTracker<ScheduledReceiptRow> | undefined>,
  ] = [useRef<EditTracker<VirtualBomRow>>(), useRef<EditTracker<ScheduledReceiptRow>>()];

  const isOpenSearchArea = useScheduledReceiptInformationStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useScheduledReceiptInformationStore(state => state.setOpenSearchArea);
  const filters = useScheduledReceiptInformationStore(state => state.filters);
  const setFilters = useScheduledReceiptInformationStore(state => state.setFilters);
  const staticColumns = useScheduledReceiptInformationStore(state => state.staticColumns);
  const fetchStaticColumns = useScheduledReceiptInformationStore(state => state.fetchStaticColumns);
  const searchParams = useScheduledReceiptInformationStore(state => state.searchParams);

  // ClipboardPasted(OPMZ_PLAN_GR_ID NAME→CODE 변환, SCP0130-10) — ScheduledReceiptInformationForm
  //   이 조회조건 PlanGroup 드롭다운에 쓰는 것과 같은 콤보를 공유(react-query 캐시 재사용, 중복 호출
  //   없음). 두 시트 그리드(§1.1/§1.2 #2)가 함께 필요해 여기서 조회해 내려보낸다.
  const [planGroupsAll] = useTabComboQueries({ filters: [COMBO.PLAN_GROUP] });

  // 시트 전환(design 01 §2 #7/#8) + 편집모드 토글(design 01 §2 #4, EditButton→SwitchLock 재현).
  const [activeTab, setActiveTab] = useState<SHEET_INDEX>(SHEET_INDEX.VIRTUAL_BOM);
  const [isEditMode, setIsEditMode] = useState(false);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const { saveWithValidation } = useSaveWithValidation();
  const { setToast, setAlert } = useMessageStore.getState();

  const { data: virtualBomData } = useTabProcQuery<MENU_ID, SHEETS.VIRTUAL_BOM>({
    menuId: MENU_ID,
    sheetName: SHEETS.VIRTUAL_BOM,
    tabId,
    filters: filters[SHEETS.VIRTUAL_BOM],
    enabled: !!filters[SHEETS.VIRTUAL_BOM],
  });
  const { data: scheduledReceiptData } = useTabProcQuery<MENU_ID, SHEETS.SCHEDULED_RECEIPT>({
    menuId: MENU_ID,
    sheetName: SHEETS.SCHEDULED_RECEIPT,
    tabId,
    filters: filters[SHEETS.SCHEDULED_RECEIPT],
    enabled: !!filters[SHEETS.SCHEDULED_RECEIPT],
  });

  const { mutate: mutateVirtualBom } = useProcMutation<MENU_ID, SHEETS.VIRTUAL_BOM>({
    menuId: MENU_ID,
    sheetName: SHEETS.VIRTUAL_BOM,
    tabId,
  });
  const { mutate: mutateScheduledReceipt } = useProcMutation<MENU_ID, SHEETS.SCHEDULED_RECEIPT>({
    menuId: MENU_ID,
    sheetName: SHEETS.SCHEDULED_RECEIPT,
    tabId,
  });

  const virtualBomRows = useMemo(
    () => virtualBomData?.o_rc1 ?? [],
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [virtualBomData, searchParams.divisionId]
  );
  const scheduledReceiptRows = useMemo(
    () => scheduledReceiptData?.o_rc1 ?? [],
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [scheduledReceiptData, searchParams.divisionId]
  );

  const countByTab: Record<SHEET_INDEX, number> = {
    [SHEET_INDEX.VIRTUAL_BOM]: virtualBomRows.length,
    [SHEET_INDEX.SCHEDULED_RECEIPT]: scheduledReceiptRows.length,
  };

  const onSearch = () => {
    setFilters();
    void fetchStaticColumns();
  };

  // InsertButton — 실동작(화면설계서 "3.화면설계_이벤트항목" 시트, 위 헤더 주석 참조). 신규행 기본값은
  //   design 01 §2 #6(gridSignals#14/17 defaultData) 확인 필요 각주대로 조회조건 Division 기준.
  // AS-IS `Insert_Row()`(.cs:669)는 `siMain.IsLock(...)==false`(Edit모드 ON)일 때만 삽입을 허용하고
  //   그 외에는 메시지 없이 조용히 무시한다(react-gap-audit iter-3 ④ #1) — 동일하게 재현.
  const onInsert = () => {
    if (!isEditMode) return;
    const grid = gridRefs[activeTab].current;
    if (!grid) return;
    const defaults =
      activeTab === SHEET_INDEX.VIRTUAL_BOM
        ? virtualBomInsertDefaults(searchParams.divisionId)
        : scheduledReceiptInsertDefaults(searchParams.divisionId);
    GridAction.addRow(grid, defaults);
  };

  // buttonGuards#1 — fps==null(선택 행 없음) 시 무동작 return(design/01_layout.md §2 #3,
  //   메시지 없이 조용히 무시).
  const onDelete = () => {
    const grid = gridRefs[activeTab].current;
    if (!grid) return;
    if ((grid.selection?.row ?? -1) < 0) return;
    GridAction.removeRow(grid, false);
  };

  // EditButton — design/01_layout.md §2 #4(gridSignals#7 SwitchLock, 라인 경계로 EditButton 본문
  //   소속 확정). SP 호출 없는 순수 클라 상태 토글.
  const onEdit = () => {
    setIsEditMode(prev => !prev);
  };

  // AS-IS `SaveData()`(.cs:706)는 `siMain.IsLock(...)==true`(Edit모드 OFF, 잠긴 상태)면 저장 자체를
  //   메시지 없이 조용히 무시한다(react-gap-audit iter-3 ④ #2) — 동일하게 재현.
  const onSave = () => {
    if (!isEditMode) return;
    const grid = gridRefs[activeTab].current;
    grid?.finishEditing();

    const dirtyRows = (
      (grid?.collectionView?.sourceCollection ?? []) as { CRUD_TYPE?: string }[]
    ).filter(row => row.CRUD_TYPE);
    if (dirtyRows.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_수정한 내용이 없습니다.') });
      return;
    }

    // design/03_grid-columns.md §3.1/§4 저장 게이트 — 중복(MSG00260)은 행 조합 대사,
    //   나머지(필수값/수량 3중검증)는 행별 가드. 두 시트 공통 재현(§1 상단 각주).
    const duplicate = findDuplicateScheduledReceiptRows(dirtyRows as WijmoRowItem[]);
    if (duplicate) {
      void setAlert({ type: 'alert', content: t(duplicate.msgId, duplicate.message) });
      return;
    }
    for (const row of dirtyRows) {
      const violation = validateScheduledReceiptRow(row as WijmoRowItem);
      if (violation) {
        void setAlert({ type: 'alert', content: t(violation.msgId, violation.message) });
        return;
      }
    }

    if (activeTab === SHEET_INDEX.VIRTUAL_BOM) {
      const src = (grid?.collectionView?.sourceCollection ?? []) as VirtualBomRow[];
      saveWithValidation(
        src.filter(item => item.CRUD_TYPE),
        staticColumns[SHEETS.VIRTUAL_BOM],
        mutateVirtualBom
      );
    } else {
      const src = (grid?.collectionView?.sourceCollection ?? []) as ScheduledReceiptRow[];
      saveWithValidation(
        src.filter(item => item.CRUD_TYPE),
        staticColumns[SHEETS.SCHEDULED_RECEIPT],
        mutateScheduledReceipt
      );
    }
  };

  // AS-IS spdSub_ActiveSheetChanging(.cs:1509-1518) — 편집모드(Edit모드 ON, IsLock==false)에서는
  //   시트 전환 자체를 취소하고 MSG00129 로 안내한다(gap-resolve/iter-1 G12, react-gap-audit
  //   iteration 8 SCP0130-09 — "UX 결정 대기"에서 "AS-IS 실동작 미구현"으로 재분류).
  const onSheetChange = (index: number) => {
    if (isEditMode) {
      setToast({
        type: 'error',
        message: t(MSG.SHEET_EDIT_LOCK, {
          defaultValue: '{0} is being edited, so you cannot change sheets.',
        }).replace('{0}', SHEET_LABEL[activeTab]),
      });
      return;
    }
    setActiveTab(index as SHEET_INDEX);
  };

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? onSearch : false,
    insert: hasButton('INSERT') ? onInsert : false,
    delete: hasButton('DELETE') ? onDelete : false,
    save: hasButton('SAVE') ? onSave : false,
    manual: false,
    upload: false,
  };

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <ScheduledReceiptInformationForm />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRefs[activeTab]}
        gridFilter={gridFilterRefs[activeTab]}
        dataCount={countByTab[activeTab] ?? 0}
        excelFileName='ScheduledReceiptInformation'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
        customButtons={
          hasButton('EDIT')
            ? [
                {
                  // design/01_layout.md §2 #4 — EditButton(gridSignals#7 SwitchLock) 편집모드 토글.
                  //   Edit 라벨은 LBL00414(EN 'Edit') 재사용 — 금지: buttonLabel 을 넘기지 않는다
                  //   (SubTitle 이 buttonLabel={label} 뒤에 {...buttonProps} 를 전개해 덮어쓴다).
                  label: t('LBL00414', { defaultValue: 'Edit' }),
                  title: t('LBL00414', { defaultValue: 'Edit' }),
                  action: onEdit,
                },
              ]
            : []
        }
      />
      <TabWrapper persist activeTabIndex={activeTab} setActiveTabIndex={onSheetChange}>
        <TabItem label='Virtual Bom'>
          <ScheduledReceiptInformationVirtualBomGrid
            gridRef={gridRefs[SHEET_INDEX.VIRTUAL_BOM]}
            gridFilterRef={gridFilterRefs[SHEET_INDEX.VIRTUAL_BOM]}
            editTrackerRef={editTrackerRefs[SHEET_INDEX.VIRTUAL_BOM]}
            data={virtualBomRows}
            staticColumns={staticColumns[SHEETS.VIRTUAL_BOM]}
            divisionId={searchParams.divisionId}
            planGroupOptions={planGroupsAll ?? []}
            isEditMode={isEditMode}
            onFocus={() => setActiveTab(SHEET_INDEX.VIRTUAL_BOM)}
          />
        </TabItem>
        <TabItem label='Scheduled Reciept Information'>
          <ScheduledReceiptInformationMainGrid
            gridRef={gridRefs[SHEET_INDEX.SCHEDULED_RECEIPT]}
            gridFilterRef={gridFilterRefs[SHEET_INDEX.SCHEDULED_RECEIPT]}
            editTrackerRef={editTrackerRefs[SHEET_INDEX.SCHEDULED_RECEIPT]}
            data={scheduledReceiptRows}
            staticColumns={staticColumns[SHEETS.SCHEDULED_RECEIPT]}
            planGroupOptions={planGroupsAll ?? []}
            isEditMode={isEditMode}
            onFocus={() => setActiveTab(SHEET_INDEX.SCHEDULED_RECEIPT)}
          />
        </TabItem>
      </TabWrapper>
    </>
  );
};
