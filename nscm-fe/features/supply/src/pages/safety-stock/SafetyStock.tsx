import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { SafetyStockForm } from './components/SafetyStockForm';
import { SafetyStockGrid } from './components/SafetyStockGrid';
import { MENU_ID, MSG, SHEETS } from './safety-stock.constants';
import { useSafetyStockStore } from './useSafetyStockStore';
import { missingRequiredSearchLabel, toGridDate } from './utils/safety-stock.util';
import { safetyStockInsertDefaults } from './utils/safetyStockEditLock';
import { submitSafetyStockSave } from './utils/safetyStockSaveRequest';
import { findDuplicateSafetyStockRows, validateSafetyStockRow } from './utils/safetyStockSaveValidation';

/**
 * SCP0128 Safety Stock — 단일 그리드 CRUD 마스터(SCP0122/SCP0127 계열 구조).
 *
 * 신규(NEW) 판정 — convert-flow/goal.md ①. domain=SCP(형제 트리 실측 + namespace + SCP0122
 * 선례 3중 근거, 00_checklist.md §0). nscmPath 는 goal.md ①에서 확정한 `features/supply/src/
 * pages/safety-stock/`.
 *
 * 버튼 4건 NO-OP/실동작 판정(design/01_layout.md §2 NO-OP/실동작 판정표) — 순수 NO-OP 0건:
 *   - FindButton/SaveButton/DeleteButton/InsertButton = 전건 실동작 확정(SP 호출·gridSignals 근거).
 *   - EditButton = TO-BE 미이식(asis_to_tobe.md §11 전 화면 공통 결정, SCP0127 과 달리 "확인
 *     필요"가 아니라 명시적 제외) — hotkeyConfig 에 edit 키 자체를 두지 않는다(공용 기본핸들러
 *     미보유라 생략해도 부작용 없음, 01_layout.md §2 NO-OP/실동작 판정표 하단 주의).
 *
 * PKG_SCP0128 배포 완료(PACKAGE+BODY VALID, 2026-10-11 ora.py 실측). 저장 SP 는 CLOB-per-column
 * (activeFlag/valueType/...)이라 공용 useProcMutation({data:[rows]}) 로는 BE 가 top-level camelCase
 * 키를 못 찾아 전부 null 바인딩 → 루프 0회 → SUCCESS 반환하나 DB 미반영(조용한 no-op)이었다(자매
 * SCP0127 과 동일 결함, 2026-10-12). 전용 조립 util(utils/safetyStockSaveRequest.ts)로 ^-fold
 * payload 를 직접 POST 해 저장을 성립시킨다 — SCP0006/SCP0011 정본 패턴.
 *
 * 조회조건 Plan Group/Site/Type/Stage/Valid 전건 노출·배선. Site/Type/Stage 는 전용 SP
 * PKG_SCP0128.P_SCP0128_GET_SEARCH_INFO(init 시트) 다중커서 원천(safety-stock.constants COMBO 주석).
 */
export const SafetyStock = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.MAIN>>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEETS.MAIN>>>();

  const isOpenSearchArea = useSafetyStockStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useSafetyStockStore(state => state.setOpenSearchArea);
  const filters = useSafetyStockStore(state => state.filters);
  const setFilters = useSafetyStockStore(state => state.setFilters);
  const staticColumns = useSafetyStockStore(state => state.staticColumns);
  const fetchStaticColumns = useSafetyStockStore(state => state.fetchStaticColumns);
  const restoreSearchConditions = useSafetyStockStore(state => state.restoreSearchConditions);
  const searchParams = useSafetyStockStore(state => state.searchParams);

  const [itemModalOpen, setItemModalOpen] = useState(false);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const { saveWithValidation } = useSaveWithValidation();
  const { setToast, setAlert } = useMessageStore.getState();
  const sessionUserId = useSessionStore(s => s.session.userId);

  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters,
    enabled: !!filters,
  });

  // FROM/TO_YYYYMMDD 를 Date 로 변환해 FPDate 달력 편집과 'yyyy-MM-dd' 표시가 성립하게 한다
  //   (셀값이 문자열이면 InputDate 가 비어 뜸 — SafetyStockGrid dataType=Date 와 짝). 저장·검증은
  //   toYmd8 로 Date/문자열을 'YYYYMMDD' 8자리로 되돌려 처리한다. 자매 SCP0127 동형.
  const rows = useMemo(
    () =>
      (data?.o_rc1 ?? []).map(row => ({
        ...row,
        // 생성 계약은 string 이지만 그리드에선 FPDate(Date)로 다룬다 — 저장/검증은 toYmd8 로 재정규화.
        FROM_YYYYMMDD: toGridDate(row.FROM_YYYYMMDD) as unknown as string,
        TO_YYYYMMDD: toGridDate(row.TO_YYYYMMDD) as unknown as string,
      })),
    [data]
  );

  // mount 시 1회 admin 컬럼 메타 fetch — 조회 전에도 그리드 헤더가 렌더되고 Insert(신규행)가
  //   편집 가능해야 하므로(조회 전 Insert 허용, SafetyStock.tsx onInsert) staticColumns 를
  //   진입 시점에 확보한다(자매 working-time/constraint-mgmt 표준). 재조회는 Search 에서 refetch.
  useEffect(() => {
    void restoreSearchConditions();
    void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  const onSearch = () => {
    // AS-IS checkRequired(Designer "*": Division/Period) — 비면 필드별 MSG00614 로 차단.
    const missLbl = missingRequiredSearchLabel(searchParams);
    if (missLbl) {
      void setAlert({
        type: 'alert',
        content: t('MSG00614', '_{0} 값은 필수 입력입니다.').replace('{0}', `[${t(missLbl, '')}]`),
      });
      return;
    }
    setFilters();
    void fetchStaticColumns();
  };

  // InsertButton — 실동작(design 01 §2 L5, gridSignals#7~#10). 사전조건 가드는 확인 필요
  //   (buttonGuards 미포착) — 보수적으로 조회 전에도 허용(SCP0122 선례, __asis-mapping__.md 확인필요).
  const onInsert = () => {
    if (!gridRef.current) return;
    GridAction.addRow(gridRef.current, safetyStockInsertDefaults(searchParams.divisionId));
  };

  // buttonGuards#1 — fps==null(선택 행 없음) 시 무동작 return(design/01_layout.md §2 L4).
  const onDelete = () => {
    if (!gridRef.current) return;
    if ((gridRef.current.selection?.row ?? -1) < 0) return;
    GridAction.removeRow(gridRef.current, false);
  };

  // 조립된 ^-fold payload 를 SAVE call-proc 로 보내고 결과를 판정한다. SP 는 CLOB-per-column 이라
  //   공용 useProcMutation({data:[rows]}) 로는 전부 null 바인딩돼 조용히 no-op 된다 — 전용 조립 util 로
  //   보내야 실제 저장된다(utils/safetyStockSaveRequest.ts).
  const submitSave = async (dirtyRows: ResponseData<MENU_ID, SHEETS.MAIN>[]) => {
    const result = await submitSafetyStockSave(dirtyRows, editTrackerRef.current, sessionUserId ?? '');
    if (!result.ok) {
      void setAlert({ type: 'alert', content: result.message ?? t('MSG00003', '_저장에 실패하였습니다.') });
      return;
    }
    setToast({ type: 'success', message: t('MSG00002', '_성공적으로 저장되었습니다!') });
    editTrackerRef.current?.clearChanges();
    void refetch();
  };

  const onSave = () => {
    const dirtyRows = (gridRef.current?.collectionView?.sourceCollection ?? []).filter(
      row => row.CRUD_TYPE
    );
    if (dirtyRows.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_수정한 내용이 없습니다.') });
      return;
    }

    // design/03_grid-columns.md §3.2/00_checklist.md §4d 검증 재현 — 중복은 행 조합 대사,
    //   나머지는 행별 가드.
    const duplicate = findDuplicateSafetyStockRows(dirtyRows);
    if (duplicate) {
      void setAlert({ type: 'alert', content: t(duplicate.msgId, duplicate.message) });
      return;
    }
    for (const row of dirtyRows) {
      const violation = validateSafetyStockRow(row);
      if (violation) {
        // field 가 있으면 필드별 메시지(MSG00614 {0}=[컬럼 라벨]). 라벨은 admin 컬럼메타(colLblNm, '*' 제거),
        //   표준 서식대로 대괄호로 감싼다(mkt-fcst 등 선례).
        const colLabel = (
          staticColumns.find(c => c.colNm === violation.field)?.colLblNm ??
          violation.field ??
          ''
        ).replace(/\*\s*$/, '');
        // field 없는 MSG00085("{0} 이상의 값만 입력 가능합니다.")는 최소값 {0}=0 치환(AS-IS MSG00085 {"0"}).
        //   field-less 메시지 중 {0} 를 가진 건 MSG00085 뿐이라 나머지엔 영향 없음.
        const content = violation.field
          ? t(violation.msgId, violation.message).replace('{0}', `[${colLabel}]`)
          : t(violation.msgId, violation.message).replace('{0}', '0');
        void setAlert({ type: 'alert', content });
        return;
      }
    }

    saveWithValidation(dirtyRows, staticColumns, rows => void submitSave(rows), dirtyRows);
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
      <SafetyStockForm tabId={tabId} />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='SafetyStock'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <SafetyStockGrid
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
