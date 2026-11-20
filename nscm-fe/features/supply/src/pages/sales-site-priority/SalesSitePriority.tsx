import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { GridAction } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { SalesSitePriorityForm } from './components/SalesSitePriorityForm';
import { SalesSitePriorityGrid } from './components/SalesSitePriorityGrid';
import { useSalesSitePriorityValidation } from './hooks/useSalesSitePriorityValidation';
import { MENU_ID, MSG, SHEETS } from './sales-site-priority.constants';
import type { SalesSitePriorityRow } from './sales-site-priority.types';
import { useSalesSitePriorityStore } from './useSalesSitePriorityStore';
import { insertDefaults, s } from './utils/sales-site-priority.editLock';
import { submitMainSave, toGridDate } from './utils/salesSitePriority.saveRequest';

// AS-IS GSCM.SCP.Master.UIL SCP0131_SalesSitePriority — 단일 그리드 마스터 CRUD(pivot 없음).
//   설계: .atlas/gscm-design/SCP0131/design/00~03. 상세 매핑: __asis-mapping__.md.
//   NSCM 표준(자매 SCP0037 operation-lt): 그리드 상시 편집 — 별도 Edit 토글(SwitchLock) 미배선.
//   셀별 편집가부는 editLock 화이트리스트가 판정. 2026-09-26 iter-3 AS-IS 원본 확보 후 확정:
//   EditButton(SwitchLock, l369~380)은 실동작이나 TO-BE 등록 버튼(SEARCH/INSERT/SAVE/DELETE 4종)에
//   EDIT 이 없어 이 대체가 최종 설계다(__asis-mapping__.md 근거 갱신).
export const SalesSitePriority = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  const { validateSaveRows } = useSalesSitePriorityValidation();
  // 필수 컬럼(메타 M/IM) 저장검증 — 전 화면 공통. 이 화면 INPUT_TP_CD 전 'S' 라 필수는 validateSaveRows 가 병행.
  const { saveWithValidation } = useSaveWithValidation();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const queryClient = useQueryClient();
  const sesUserId = useSessionStore.getState().session.userId ?? '';

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker>();

  const filters = useSalesSitePriorityStore(st => st.filters);
  const setFilter = useSalesSitePriorityStore(st => st.setFilter);
  const clearFilters = useSalesSitePriorityStore(st => st.clearFilters);
  const openSearchArea = useSalesSitePriorityStore(st => st.openSearchArea);
  const setOpenSearchArea = useSalesSitePriorityStore(st => st.setOpenSearchArea);
  const staticColumns = useSalesSitePriorityStore(st => st.staticColumns);
  const fetchStaticColumns = useSalesSitePriorityStore(st => st.fetchStaticColumns);
  const restoreSearchCondition = useSalesSitePriorityStore(st => st.restoreSearchCondition);
  const initialized = useSalesSitePriorityStore(st => st.initialized);
  const searchCondition = useSalesSitePriorityStore(st => st.searchCondition);

  // Condition(F6) 저장에서 period(fromDate/toDate) 는 제외한다(사용자 지시 2026-11-19 — 기간은 저장 안 함).
  //   공통 personalizeCondition 의 EXCLUDED_DATE_PARAM 정규식이 fromDate/toDate 네이밍을 걸러내지 못해
  //   그대로 저장되던 것을 이 화면에서 제거한다. 복원(restoreSearchCondition)에서도 period 는 미복원.
  const conditionParam = useMemo(() => {
    const { fromDate: _fromDate, toDate: _toDate, ...rest } = searchCondition;
    return rest;
  }, [searchCondition]);

  const { data } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });
  // FROM/TO 는 GET 이 "YYYY-MM-DD 00:00:00"(Oracle DATE 직렬화) 문자열로 내려온다. 문자열 그대로 두면
  //   FPDate(InputDate 달력) 에디터가 Date 에 못 묶여, 특히 빈 셀(신규행)을 열 때 직전에 편집한 다른
  //   행의 Date 가 에디터에 남아 입력 없이 Tab 해도 그 날짜가 새어든다(No.9). 행을 Date 로 들면 빈값은
  //   ''(null 등가)이라 에디터가 비어 열리고, SalesSitePriorityGrid 의 dataType=Date+format 으로
  //   'yyyy-MM-dd' 표시·달력 편집이 성립한다(형제 demand-exception/SCP0127/0128 동형). 저장·검증은
  //   ymd8 이 Date/문자열 모두 'YYYYMMDD' 로 환원한다.
  const rows = useMemo<SalesSitePriorityRow[]>(() => {
    const list = data?.o_rc1 ?? [];
    return list.map(r => {
      const o = r as Record<string, unknown>;
      return {
        ...o,
        FROM_YYYYMMDD: toGridDate(o.FROM_YYYYMMDD) as unknown as string,
        TO_YYYYMMDD: toGridDate(o.TO_YYYYMMDD) as unknown as string,
      };
    }) as unknown as SalesSitePriorityRow[];
  }, [data]);

  // 저장 — SCP 표준 util(컬럼별 '^'-fold + POST + false-success 가드)로 저장하고, 성공 시 [tabId]
  //   무효화로 활성 조회를 재조회한다. 공용 useProcMutation({data:[rows]}) 은 이 SAVE SP 계약(전
  //   파라미터 CLOB)에서 activeFlag·pre* 가 NULL 바인딩 → UPDATE/DELETE 0행 no-op + 성공 토스트라
  //   쓰지 않는다(메모리 save-proc-per-column-caret-fold-fe, 자매 SCP0133).
  const persistSave = async (saveRows: Record<string, unknown>[]) => {
    const result = await submitMainSave(saveRows, sesUserId);
    if (!result.ok) {
      void setAlert({ type: 'alert', content: result.message ?? t('MSG00003', '_Failed to save.') });
      return;
    }
    // MSG00672 "{0} data saved." — AS-IS MSG00004(저장 건수)처럼 {0}를 실제 저장 건수로 치환한다.
    //   건수 원천은 SP o_rc1[0].RESULT_CNT, 없으면 제출 행수로 폴백.
    const savedCount = result.count ?? saveRows.length;
    setToast({
      type: 'success',
      message: t(MSG.SAVE_SUCCESS, '{0} data saved.').replace('{0}', String(savedCount)),
    });
    // 저장 성공 후 EditTracker clear — 안 하면 hasChanges()가 계속 true 라 행이 dirty(노란색)로 남는다.
    //   이어지는 invalidate 재조회가 clean 행으로 그리드를 리바인드한다(SCP0133 persistSave 패턴).
    editTrackerRef.current?.clearChanges();
    void queryClient.invalidateQueries({ queryKey: [tabId] });
  };

  // mount 1회 + Search 마다 admin 컬럼 메타 fetch. keep-alive 탭 stale filters 자동발사 방지(clearFilters).
  //   F6 로 저장한 조회조건을 폼에 복원한다(새로고침 생존은 이 GET 뿐 — store 는 비영속, 기본점검 #3).
  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
    clearFilters();
    void restoreSearchCondition();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  const handleSearch = () => {
    // Division 필수(design 02 §2-1 조회조건 카탈로그, cascade 트리거이자 GET SP 필수 파라미터).
    if (searchCondition.divisionId === '') {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_SELECT, '_Select {0}.').replace('{0}', 'Division'),
      });
      return;
    }
    setFilter();
    void fetchStaticColumns();
  };

  // 신규행(design 01 §2#6 / 03 §3.2, AS-IS Insert_Row l503~521): DIVISION_ID 항상잠금 + VALID_YN='Y'
  //   기본값(AS-IS defaultData 그대로). 기준 division 은 AS-IS 와 동일하게 현재 폼에 선택된 Division
  //   (cboDivision.ControlValues, .cs:512)에서 가져온다 — 조회(filters) 선행은 AS-IS 조건이 아니다.
  //   AS-IS 는 Insert_Row 가 IsLock==false(편집모드) 아니면 메시지 없이 조용히 무시하므로(.cs:505),
  //   기준 division 이 없으면(미선택/다중) 알림 없이 return 한다. Division 은 진입 시 첫 값 자동선택
  //   (SalesSitePriorityForm firstDivision)이라 통상 값이 있다. __asis-mapping__.md G06 참조.
  const handleInsert = () => {
    const grid = gridRef.current;
    if (!grid) return;
    const division = s(searchCondition.divisionId);
    // Division 은 단일 선택(design 02 주1) — 미선택/콤마 다중이면 신규행 기본값 확정 불가, 조용히 무시.
    if (division === '' || division.includes(',')) return;
    GridAction.addRow(grid, insertDefaults(division));
  };

  // 삭제(design 01 §2#3 buttonGuards#1): `fps==null` early-return 재현 — 메시지 없이 조용히 무시.
  const handleDelete = () => {
    const grid = gridRef.current;
    if (!grid) return;
    const selected = grid.selectedItems[0] as Record<string, unknown> | undefined;
    if (!selected) return;
    GridAction.removeRow(grid);
  };

  const handleSave = () => {
    const grid = gridRef.current;
    grid?.finishEditing();
    const src = (grid?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
    const dirty = src.filter(r => r.CRUD_TYPE);
    if (dirty.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_No changes to save.') });
      return;
    }
    // 필수값 + PRIO_RANK>=1 + From<=To 검증(design 00 §4a validations 저장시점분, §3 참조).
    if (!validateSaveRows(src).ok) return;
    // 필수 컬럼 메타검증(saveWithValidation) 통과 시 util(persistSave)이 컬럼별 '^'-fold 로 실저장.
    saveWithValidation(dirty, staticColumns[SHEETS.MAIN], saveRows =>
      void persistSave(saveRows)
    );
  };

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    save: hasButton('SAVE') ? handleSave : false,
    delete: hasButton('DELETE') ? handleDelete : false,
    manual: false,
    upload: false,
  };

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && <SalesSitePriorityForm onSearch={handleSearch} />}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='SalesSitePriority'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={conditionParam}
      />
      <SalesSitePriorityGrid
        rows={rows}
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        adminColumns={staticColumns[SHEETS.MAIN]}
        onFocus={() => undefined}
      />
    </>
  );
};
