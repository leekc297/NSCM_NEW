import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { PrecedeSafetyStockDayForm } from './components/PrecedeSafetyStockDayForm';
import { PrecedeSafetyStockDayGrid } from './components/PrecedeSafetyStockDayGrid';
import { MENU_ID, MSG, SHEETS } from './precede-safety-stock-day.constants';
import { usePrecedeSafetyStockDayStore } from './usePrecedeSafetyStockDayStore';
import { missingRequiredSearchLabel, toGridDate } from './utils/precede-safety-stock-day.util';
import { precedeSafetyStockDayInsertDefaults } from './utils/precedeSafetyStockDayEditLock';
import { submitPrecedeSafetyStockDaySave } from './utils/precedeSafetyStockDaySaveRequest';
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
 *   - EditButton = AS-IS 편집모드 토글(SwitchLock 잠금 토글)은 이식하지 않는다(asis_to_tobe.md
 *     §11 전 화면 공통 결정). 편집가능 여부는 신규/기존행 구분 없이 컬럼 white-list 로 판정하며
 *     (precedeSafetyStockDayEditLock.ts), DIVISION_ID·감사4칼럼을 뺀 10칼럼은 조회 직후부터
 *     기존행도 즉시 편집된다 — 자매 SCP0128 동형. 주의: 이전에 `hasButton('EDIT')` 편집권한
 *     게이트로 기존행 편집을 막았으나, 그 EDIT 버튼은 SCM_ADM_MNU_BTN_MPG_M 미등록이라 항상
 *     false → 기존행 전건 read-only("노란 셀이 편집 안 됨")로 역전됐었다(사용자 신고 2026-10-11,
 *     memory scp0048-edit-gate-uses-nonexistent-edit-permission).
 *   - InsertButton = 확인 필요(근거 불충분). 원본 대조 전까지 명시적 무동작 함수로 안전측
 *     배선(`false`/키 생략 금지, convert-core §2.1 #11 원칙) — SCP0124 선례 동일 패턴.
 *
 * PKG_SCP0127 PACKAGE/BODY 배포 완료(2026-10-12 ora.py 실측). 저장은 SP 가 CLOB-per-column
 * (activeFlag/valueType/...)이라 공용 useProcMutation({data:[rows]}) 로는 BE 가 top-level camelCase
 * 키를 못 찾아 전부 null 바인딩 → 루프 0회 → SUCCESS 반환하나 DB 미반영(조용한 no-op)이었다
 * (2026-10-12 사용자 신고). 전용 조립 util(utils/precedeSafetyStockDaySaveRequest.ts)로 ^-fold
 * payload 를 직접 POST 해 저장을 성립시킨다 — 자매 SCP0006/SCP0011 정본 패턴.
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
  const restoreSearchConditions = usePrecedeSafetyStockDayStore(
    state => state.restoreSearchConditions
  );
  const searchParams = usePrecedeSafetyStockDayStore(state => state.searchParams);

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
  //   (셀값이 문자열이면 InputDate 가 비어 뜸 — PrecedeSafetyStockDayGrid dataType=Date 와 짝).
  //   저장(submit)·검증은 toYmd8 로 Date/문자열을 'YYYYMMDD' 8자리로 되돌려 처리한다.
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

  // mount 시 1회: F6 저장 조회조건 복원(restoreSearchConditions, conditionsRestored 가드) + admin 컬럼
  //   메타 fetch. 복원은 조회조건 state 만 바꾸고 fetchStaticColumns 는 division 비의존이라 순서 무관.
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

  // InsertButton — AS-IS InsertButton→Insert_Row(.cs:352·504) 재현. 신규행 추가 후 기본값 세팅
  //   (DIVISION_ID=조회조건 division, VALID_YN='Y' — precedeSafetyStockDayInsertDefaults). AS-IS 는
  //   siMain.IsLock 시 무동작이나 TO-BE 는 상시편집(§11)이라 잠금축 없음. INSERT 버튼 메타 등록 완료.
  const onInsert = () => {
    if (!gridRef.current) return;
    GridAction.addRow(gridRef.current, precedeSafetyStockDayInsertDefaults(searchParams.divisionId));
  };

  // buttonGuards#1 — fps==null(선택 행 없음) 시 무동작 return(design/01_layout.md §2 #3).
  const onDelete = () => {
    if (!gridRef.current) return;
    if ((gridRef.current.selection?.row ?? -1) < 0) return;
    GridAction.removeRow(gridRef.current, false);
  };

  // 조립된 ^-fold payload 를 SAVE call-proc 로 보내고 결과를 판정한다. SP 는 CLOB-per-column 이라
  //   공용 useProcMutation({data:[rows]}) 로는 전부 null 바인딩돼 조용히 no-op 된다 — 전용 조립 util 로
  //   보내야 실제 저장된다(utils/precedeSafetyStockDaySaveRequest.ts).
  const submitSave = async (dirtyRows: ResponseData<MENU_ID, SHEETS.MAIN>[]) => {
    const result = await submitPrecedeSafetyStockDaySave(
      dirtyRows,
      editTrackerRef.current,
      sessionUserId ?? ''
    );
    if (!result.ok) {
      void setAlert({ type: 'alert', content: result.message ?? t('MSG00003', '_저장에 실패하였습니다.') });
      return;
    }
    setToast({ type: 'success', message: t('MSG00002', '_성공적으로 저장되었습니다!') });
    editTrackerRef.current?.clearChanges();
    void refetch();
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
    save: hasButton('SAVE') ? onSave : false,
    delete: hasButton('DELETE') ? onDelete : false,
    // InsertButton — AS-IS Insert_Row 실동작 확정(GSCM SCP0127.cs:352·504 실측). INSERT 권한 등록 완료.
    insert: hasButton('INSERT') ? onInsert : false,
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
      <PrecedeSafetyStockDayForm tabId={tabId} />
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
        divisionId={searchParams.divisionId}
        itemModalOpen={itemModalOpen}
        onItemModalOpenChange={setItemModalOpen}
      />
    </>
  );
};
