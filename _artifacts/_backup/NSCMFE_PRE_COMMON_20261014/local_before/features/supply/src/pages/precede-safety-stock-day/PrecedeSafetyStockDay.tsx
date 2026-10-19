import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { PrecedeSafetyStockDayForm } from './components/PrecedeSafetyStockDayForm';
import { PrecedeSafetyStockDayGrid } from './components/PrecedeSafetyStockDayGrid';
import { MENU_ID, MSG, SHEETS } from './precede-safety-stock-day.constants';
import { usePrecedeSafetyStockDayStore } from './usePrecedeSafetyStockDayStore';
import {
  findDuplicatePrecedeSafetyStockDayRows,
  validatePrecedeSafetyStockDayRow,
} from './utils/precedeSafetyStockDaySaveValidation';

/**
 * SCP0127 Precede/Safety Stock Day — 단일 그리드 CRUD 마스터(SCP0122 계열 구조).
 *
 * 보완(iter-2 gap-resolve) 판정 — convert-flow/goal.md ①. domain 은 이번 회차
 * `05_register.sql` 실행으로 `SCM_ADM_MNU_M`(UPPR_MNU_ID='Supply_Master') 등록 후
 * 재실측(`Supply_Master`→`Supply`)으로 **Supply(SCP)** 확정.
 *
 * 버튼 NO-OP/실동작 판정(01_layout.md §2):
 *   - FindButton/SaveButton/DeleteButton = 실동작 확정(SP 호출·순수가드 근거).
 *   - EditButton = G-01 해소(iter-2). AS-IS `.cs` 원본 접근 불가(GSCM 미러 SCP0127 폴더
 *     부재) 지속 + `05_register.sql`이 EDIT/INSERT 버튼권한을 의도적으로 미등록 상태로
 *     유지한 것과 정합시켜, 메모리 `ssp0025-no-edit-toggle-always-editable`(2026-09-23
 *     사용자 결정, SSP0025/SCP0033 선례) 을 기본값으로 적용한다 — Edit 토글 버튼을 없애고
 *     `hasButton('EDIT')` 을 "화면 Load 시점 편집권한 판정"으로만 쓴다(버튼 노출 용도 아님).
 *     주의: 이 기본값은 라이브 사용자 확인 없이 채택했다 — 원본 `.cs` 366~380 라인 확보 시
 *     재검토 대상(design/04_react-gap.md G-01 참조).
 *   - InsertButton = 확인 필요(근거 불충분). 원본 대조 전까지 명시적 무동작 함수로 안전측
 *     배선(`false`/키 생략 금지, convert-core §2.1 #11 원칙) — SCP0124 선례 동일 패턴.
 *
 * PKG_SCP0127 는 TO-BE 미배포(all_objects 0건, goal.md ②) — 화면 구현은 진행하되 실제
 * 조회·저장은 SP 배포(convert-sp 후속) 전까지 동작하지 않는다.
 */
export const PrecedeSafetyStockDay = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.MAIN>>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEETS.MAIN>>>();

  const isOpenSearchArea = usePrecedeSafetyStockDayStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = usePrecedeSafetyStockDayStore(state => state.setOpenSearchArea);
  const filters = usePrecedeSafetyStockDayStore(state => state.filters);
  const setFilters = usePrecedeSafetyStockDayStore(state => state.setFilters);
  const staticColumns = usePrecedeSafetyStockDayStore(state => state.staticColumns);
  const fetchStaticColumns = usePrecedeSafetyStockDayStore(state => state.fetchStaticColumns);
  const searchParams = usePrecedeSafetyStockDayStore(state => state.searchParams);

  const [itemModalOpen, setItemModalOpen] = useState(false);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  // G-01(iter-2) — Edit 토글 버튼 없이 hasButton('EDIT')을 화면 Load 시점 편집권한 판정으로만
  // 사용한다(memory ssp0025-no-edit-toggle-always-editable). 권한 있으면 조회 직후부터 편집
  // 가능 10칼럼이 즉시 열리고, 권한 없으면 그리드 전체가 읽기전용이다.
  const isEditMode = hasButton('EDIT');
  const { saveWithValidation } = useSaveWithValidation();
  const { setToast, setAlert } = useMessageStore.getState();

  const { data } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters,
    enabled: !!filters,
  });

  const { mutate } = useProcMutation<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
  });

  const rows = useMemo(() => data?.o_rc1 ?? [], [data]);

  const onSearch = () => {
    setFilters();
    void fetchStaticColumns();
  };

  // buttonGuards#1 — fps==null(선택 행 없음) 시 무동작 return(design/01_layout.md §2 #3).
  const onDelete = () => {
    if (!gridRef.current) return;
    if ((gridRef.current.selection?.row ?? -1) < 0) return;
    GridAction.removeRow(gridRef.current, false);
  };

  const onSave = () => {
    const dirtyRows = (
      (gridRef.current?.collectionView?.sourceCollection ?? [])
    ).filter(row => row.CRUD_TYPE);
    if (dirtyRows.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_수정한 내용이 없습니다.') });
      return;
    }

    // 00_checklist.md §3b 커스텀 검증 13건 재현 — #2(중복) 는 행 조합 대사, 나머지는 행별 가드.
    const duplicate = findDuplicatePrecedeSafetyStockDayRows(dirtyRows);
    if (duplicate) {
      void setAlert({ type: 'alert', content: t(duplicate.msgId, duplicate.message) });
      return;
    }
    for (const row of dirtyRows) {
      const violation = validatePrecedeSafetyStockDayRow(row);
      if (violation) {
        void setAlert({ type: 'alert', content: t(violation.msgId, violation.message) });
        return;
      }
    }

    saveWithValidation(dirtyRows, staticColumns, mutate, dirtyRows);
  };

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? onSearch : false,
    save: hasButton('SAVE') ? onSave : false,
    delete: hasButton('DELETE') ? onDelete : false,
    // InsertButton — AS-IS override NO-OP/실동작 확인 필요(01_layout.md §2 #5, 근거 불충분).
    //   확정 전까지 명시적 무동작 함수로 안전측 배선한다(`false`/키 생략 금지 — 생략하면 공용
    //   SubTitle 기본 addRow 핸들러가 살아남아 AS-IS 에 없던 동작이 생긴다, convert-core §2.1 #11
    //   / plan.md 4-5). 원본 `.cs` 352~360 라인 대조 후 실동작으로 교체 검토.
    insert: () => undefined,
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
      <PrecedeSafetyStockDayForm />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='PrecedeSafetyStockDay'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <PrecedeSafetyStockDayGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        data={rows}
        staticColumns={staticColumns}
        isEditMode={isEditMode}
        divisionId={searchParams.divisionId}
        itemModalOpen={itemModalOpen}
        onItemModalOpenChange={setItemModalOpen}
      />
    </>
  );
};
