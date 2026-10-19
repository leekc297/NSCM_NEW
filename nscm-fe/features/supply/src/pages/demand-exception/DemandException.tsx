import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useMutation, useQueryClient } from '@foundation/query-client';
import type { EditTracker } from '@foundation/utils';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { DemandExceptionForm } from './components/DemandExceptionForm';
import { DemandExceptionGrid } from './components/DemandExceptionGrid';
import { MENU_ID, MSG, SHEETS } from './demand-exception.constants';
import { useDemandExceptionStore } from './useDemandExceptionStore';
import { toGridDate } from './utils/demand-exception.util';
import { demandExceptionInsertDefaults } from './utils/demandExceptionEditLock';
import { submitDemandExceptionSave } from './utils/demandExceptionSaveRequest';
import {
  findSafetyStockBlockedRows,
  validateDemandExceptionRow,
} from './utils/demandExceptionSaveValidation';

/**
 * SCP0129 Demand Exception — 단일 그리드 CRUD 마스터(SCP0122/SCP0127/SCP0128 계열 구조).
 *
 * 신규(NEW) 판정 — convert-flow/goal.md ①. domain=SCP(형제 트리 실측 + namespace, 00_checklist.md
 * §0). nscmPath 는 goal.md ①에서 확정한 `features/supply/src/pages/demand-exception/`.
 *
 * 버튼 5건 NO-OP/실동작 판정(design/01_layout.md §2) — 순수 NO-OP 0건:
 *   - FindButton/SaveButton = 실 SP 호출 존재로 실동작 확정.
 *   - DeleteButton = buttonGuards#1(`fps==null`) 재현, 무메시지 조용한 return.
 *   - InsertButton = gridSignals#8~#11(결과 로직) 실동작 확정, override 사전조건 가드는 확인
 *     필요(AS-IS 원본 소스 부재) — 보수적으로 조회 전에도 허용(SCP0122/SCP0128 선례).
 *   - EditButton = TO-BE 미이식(asis_to_tobe.md §11 전 화면 공통 결정) — hotkeyConfig 에 edit 키
 *     자체를 두지 않는다(공용 기본핸들러 미보유라 생략해도 부작용 없음).
 *
 * PKG_SCP0129 배포 완료(PACKAGE+BODY VALID, 2026-10-13 ora.py 실측) — 조회·저장 동작.
 *
 * 조회조건 7종 전건 데이터 배선 완료(Division/Site/PlanGroup/Stage/ValidYn/ItemId/Period) — AS-IS .cs
 * + DB 실측 2026-10-13 확정. PlanGroup/Site/Stage 는 SCP0128 GET_SEARCH_INFO init SP 재사용
 * (demand-exception.constants COMBO·INIT_SET 주석).
 */
export const DemandException = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.MAIN>>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEETS.MAIN>>>();

  const isOpenSearchArea = useDemandExceptionStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useDemandExceptionStore(state => state.setOpenSearchArea);
  const filters = useDemandExceptionStore(state => state.filters);
  const setFilters = useDemandExceptionStore(state => state.setFilters);
  const staticColumns = useDemandExceptionStore(state => state.staticColumns);
  const fetchStaticColumns = useDemandExceptionStore(state => state.fetchStaticColumns);
  const restoreSearchConditions = useDemandExceptionStore(state => state.restoreSearchConditions);
  const searchParams = useDemandExceptionStore(state => state.searchParams);

  const [itemModalOpen, setItemModalOpen] = useState(false);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const { saveWithValidation } = useSaveWithValidation();
  const { setToast, setAlert } = useMessageStore.getState();
  const sessionUserId = useSessionStore(s => s.session.userId);
  const queryClient = useQueryClient();

  const { data } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters,
    enabled: !!filters,
  });

  // FROM/TO_YYYYMMDD 를 Date 로 변환해 FPDate 달력 편집과 'yyyy-MM-dd' 표시가 성립하게 한다(셀값이
  //   문자열이면 InputDate 가 비어 뜸 — DemandExceptionGrid dataType=Date 와 짝). 저장·검증은
  //   toYmd8 로 Date/문자열을 'YYYYMMDD' 8자리로 되돌려 처리한다. 형제 SCP0127/SCP0128 동형.
  const rows = useMemo(
    () =>
      (data?.o_rc1 ?? []).map(row => ({
        ...row,
        FROM_YYYYMMDD: toGridDate(row.FROM_YYYYMMDD) as unknown as string,
        TO_YYYYMMDD: toGridDate(row.TO_YYYYMMDD) as unknown as string,
      })),
    [data]
  );

  // mount 시 1회: 개인화 조회조건 복원(F6 저장분) + admin 컬럼 메타 fetch. 조회 전에도 그리드 헤더가
  //   렌더되고 Insert(신규행)가 편집 가능해야 하므로 staticColumns 를 진입 시점에 확보한다(형제 SCP0128
  //   파리티 — 이전엔 Search 때만 fetch 해 진입 직후 그리드가 비었음). 재조회는 Search 에서 refetch.
  useEffect(() => {
    void restoreSearchConditions();
    void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  const onSearch = () => {
    setFilters();
    void fetchStaticColumns();
  };

  // InsertButton — 실동작(design 01 §2 규칙#9, gridSignals#8~#11). 사전조건 가드는 확인 필요
  //   (buttonGuards 미포착) — 보수적으로 조회 전에도 허용(SCP0122/SCP0128 선례).
  const onInsert = () => {
    if (!gridRef.current) return;
    GridAction.addRow(gridRef.current, demandExceptionInsertDefaults(searchParams.divisionId));
  };

  // buttonGuards#1 — fps==null(선택 행 없음) 시 무동작 return(design 01 §2 규칙#5).
  const onDelete = () => {
    if (!gridRef.current) return;
    if ((gridRef.current.selection?.row ?? -1) < 0) return;
    GridAction.removeRow(gridRef.current, false);
  };

  // 조립된 ^-fold payload 를 SAVE call-proc 로 보내는 저장 — useMutation 으로 감싼다. 이유 2가지:
  //   (1) 전역 스피너 — raw apiClient.post 는 react-query 밖이라 isMutating 이 안 잡혀 스피너가 안 돈다.
  //       useMutation 으로 감싸야 공용 전역 로딩 인디케이터가 저장 중 표시된다.
  //   (2) 저장 후 재조회 — onSuccess 의 invalidateQueries([tabId]) 가 활성 SEARCH 쿼리를 무효화해
  //       자동 refetch 시킨다(useProcMutation 기본 동작과 동일). SP 는 CLOB-per-column 이라 공용
  //       useProcMutation({data:[rows]}) 로는 null 바인딩 no-op 이므로 전용 조립 util 을 mutationFn 으로
  //       쓴다(utils/demandExceptionSaveRequest.ts). submit 은 {ok} 를 돌려주므로 onSuccess 에서 분기한다.
  const saveMutation = useMutation({
    mutationKey: [tabId, SHEETS.MAIN, 'SAVE'],
    mutationFn: (saveRows: ResponseData<MENU_ID, SHEETS.MAIN>[]) =>
      submitDemandExceptionSave(saveRows, editTrackerRef.current, sessionUserId ?? ''),
    onSuccess: result => {
      if (!result.ok) {
        void setAlert({
          type: 'alert',
          content: result.message ?? t('MSG00003', '_저장에 실패하였습니다.'),
        });
        return;
      }
      setToast({ type: 'success', message: t('MSG00002', '_성공적으로 저장되었습니다!') });
      editTrackerRef.current?.clearChanges();
      void queryClient.invalidateQueries({ queryKey: [tabId] });
    },
    onError: error => {
      void setAlert({
        type: 'alert',
        content: error.message ?? t('MSG00003', '_저장에 실패하였습니다.'),
      });
    },
  });

  const onSave = () => {
    const dirtyRows = (gridRef.current?.collectionView?.sourceCollection ?? []).filter(
      row => row.CRUD_TYPE
    );
    if (dirtyRows.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_수정한 내용이 없습니다.') });
      return;
    }

    // design 01 §2 규칙#1(MSG00260, 안전재고 존재 시 저장 차단) — 신규행이 이미 조회된 기존행과
    //   7컬럼 완전일치하면 저장 차단(클라 로컬 비교, PKG_SCP0129 미배포로 서버측 대사는 후속).
    const blocked = findSafetyStockBlockedRows(dirtyRows, rows);
    if (blocked) {
      void setAlert({ type: 'alert', content: t(blocked.msgId, blocked.message) });
      return;
    }
    for (const row of dirtyRows) {
      const violation = validateDemandExceptionRow(row);
      if (violation) {
        void setAlert({ type: 'alert', content: t(violation.msgId, violation.message) });
        return;
      }
    }

    saveWithValidation(dirtyRows, staticColumns, saveRows => saveMutation.mutate(saveRows), dirtyRows);
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
      <DemandExceptionForm />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='DemandException'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <DemandExceptionGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        data={rows}
        staticColumns={staticColumns}
        divisionId={searchParams.divisionId}
        itemModalOpen={itemModalOpen}
        onItemModalOpenChange={setItemModalOpen}
      />
    </>
  );
};
