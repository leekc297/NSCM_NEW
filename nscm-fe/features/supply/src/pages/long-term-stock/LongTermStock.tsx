import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore, useUIStore } from '@shared/stores';

import { LongTermStockForm } from './components/LongTermStockForm';
import { LongTermStockGrid } from './components/LongTermStockGrid';
import { useLongTermStockValidation } from './hooks/useLongTermStockValidation';
import { MENU_ID, MSG, SHEETS } from './long-term-stock.constants';
import type { LongTermStockRow } from './long-term-stock.types';
import { useLongTermStockStore } from './useLongTermStockStore';

// AS-IS: SCP0084_LongTermStock.cs — 조회 리포트 + MEMO 단일 컬럼 Edit-토글 편집 + 저장 + 엑셀.
export const LongTermStock = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGrid<LongTermStockRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();

  // TO-BE 요건(사용자 결정 2026-10-12): 진입(조회) 즉시 MEMO 수정모드 — AS-IS Edit 토글 제거.
  //   MEMO 는 데이터 로드 시 바로 편집 가능(상시 editable), 별도 토글 state 없음.
  const isOpenSearchArea = useLongTermStockStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useLongTermStockStore(state => state.setOpenSearchArea);
  const searchParams = useLongTermStockStore(state => state.searchParams);
  const filters = useLongTermStockStore(state => state.filters);
  const setFilters = useLongTermStockStore(state => state.setFilters);
  const clearFilters = useLongTermStockStore(state => state.clearFilters);
  const initialized = useLongTermStockStore(state => state.initialized);
  const fetchStaticColumns = useLongTermStockStore(state => state.fetchStaticColumns);
  const loadSavedCondition = useLongTermStockStore(state => state.loadSavedCondition);
  const noDivisionAuth = useLongTermStockStore(state => state.noDivisionAuth);

  const { t } = useTranslation();
  const setAlert = useMessageStore(state => state.setAlert);
  const setToast = useMessageStore(state => state.setToast);
  const setProgress = useUIStore(state => state.setProgress);
  const queryClient = useQueryClient();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const { validateFind } = useLongTermStockValidation();

  const { data } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });

  const rows = useMemo(
    () => (filters[SHEETS.MAIN] ? (data?.o_rc1 ?? []) : []),
    [data, filters]
  );

  const handleSearch = () => {
    if (!validateFind(searchParams)) return;
    setFilters();
    void fetchStaticColumns();
  };

  // 저장(MEMO 전용) — SAVE proc(P_SCP0084_SAVE_LONG_TERM_STOCK_MEMO_ROW_DATASET)은 컬럼별 CLOB
  //   파라미터라(SCM_ADM_PROC_M 실측: yyyymm/plantId/divisionId/itemId/charg/devaluationAge/memo=CLOB,
  //   userId/programId/debugMode=VARCHAR) FE 가 CRUD_TYPE 행을 컬럼별 '^' 폴딩해 call-proc 로 보낸다
  //   (WorkingTime/SalesFuturePrice 선례). 표준 useProcMutation 은 CLOB 미폴딩이라 부적합
  //   (save-proc-per-column-caret-fold). 키명=COL_NM(camelCase), 값은 매칭키 6종+MEMO 컬럼. 성공
  //   MSG00002 / 오류 MSG00003 / 변경 0건 MSG00004(=No changes). 성공 후 Find_Data 재조회(invalidate).
  const handleSave = async () => {
    const g = gridRef.current;
    if (!g) return;
    g.finishEditing();
    const dirty = ((g.collectionView?.sourceCollection ?? []) as WijmoRowItem[]).filter(
      row => !!row.CRUD_TYPE
    );
    if (dirty.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00004', '_저장할 변경 내용이 없습니다.') });
      return;
    }
    // yyyymm 값은 저장키 raw(YYYYMM_VAL) — 화면표시 YYYYMM 포맷문자열이 아님(design 03 §4.3).
    const fold = (colNm: string): string => dirty.map(r => String(r[colNm] ?? '')).join('^');
    const payload = {
      yyyymm: fold('YYYYMM_VAL'),
      plantId: fold('PLANT_ID'),
      divisionId: fold('DIVISION_ID'),
      itemId: fold('ITEM_ID'),
      charg: fold('CHARG'),
      devaluationAge: fold('DEVALUATION_AGE'),
      memo: fold('MEMO'),
      userId: useSessionStore.getState().session.userId ?? '',
      programId: MENU_ID,
      debugMode: 'F',
    };
    try {
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`,
        payload
      );
      // false-success 차단 — 전역 interceptor 가 500/CODE≠0 을 resolve 로 넘기므로 직접 판별.
      if (res.status >= 400 || Number(res.data?.code)) {
        const reason =
          (res.data as { message?: string })?.message?.trim() ||
          t('MSG00003', '_저장 중 오류가 발생했습니다.');
        void setAlert({ type: 'alert', content: reason });
        return;
      }
      setToast({ type: 'success', message: t('MSG00002', '_성공적으로 저장되었습니다!') });
      void queryClient.invalidateQueries({ queryKey: [tabId] });
    } catch (e) {
      const msg = e instanceof Error ? e.message : t('MSG00003', '_저장 중 오류가 발생했습니다.');
      void setAlert({ type: 'alert', content: msg });
    }
  };

  // Excel — 조회 0건 가드 후 공용 다운로드. 화면 5쌍 컬럼→*_XLS 고정밀 치환(W9)·콤보→텍스트(W10)·
  //   Footer(W12)·MSG00100 "저장않고 열기" 확인은 이번 회차 미구현 — 04_react-gap.md 확인필요(사용자
  //   축) 기록(공용 excelDownload 에 per-export 정밀도 스왑 훅 없음 + SP 미배포로 런타임 검증 불가).
  const handleExcel = () => {
    if (rows.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.EXCEL_NO_DATA, 'No data have been retrieved.') });
      return;
    }
    if (gridRef.current) {
      void GridAction.excelDownload(gridRef.current, 'LongTermStock', setProgress);
    }
  };

  // 진입 시 이전 filters 무효화(stale payload 자동발사 방지) + 컬럼 메타 1회 fetch.
  useEffect(() => {
    clearFilters();
    if (!initialized) {
      void fetchStaticColumns();
      void loadSavedCondition(); // 저장된 조회조건 복원(Month 제외) — F6 로 저장한 Division/Plant/Type
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 버튼 게이트 — search=hasButton('SEARCH')+권한0행 차단(R8) / save=hasButton('SAVE')(진입 즉시
  //   수정모드라 editable 게이트 없음) / excel=실동작 / insert·delete=표시만(no-op) — 사용자 요청
  //   2026-10-12 "안 쓰지만 달아놔": 버튼은 노출하되 행추가/삭제는 미사용(핸들러 무동작) /
  //   manual·upload=미사용. Edit 버튼 제거(진입 즉시 수정모드).
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') && !noDivisionAuth ? handleSearch : false,
    save: hasButton('SAVE') ? () => void handleSave() : false,
    excel: handleExcel,
    insert: () => undefined, // 표시만(no-op) — 이 화면은 행 추가 미사용
    delete: () => undefined, // 표시만(no-op) — 이 화면은 행 삭제 미사용
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
      <LongTermStockForm onSearch={handleSearch} />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='LongTermStock'
        hotkeyConfig={hotkeyConfig}
        // 조회조건 저장(F6)·복원은 Month 제외 — 월은 월범위/기본값(최신월) 로직이 소유(사용자 요청 2026-10-12).
        searchParam={{
          divisionId: searchParams.divisionId,
          plantId: searchParams.plantId,
          longTermTypeCode: searchParams.longTermTypeCode,
        }}
      />
      <LongTermStockGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        data={rows}
        editable
      />
    </>
  );
};
