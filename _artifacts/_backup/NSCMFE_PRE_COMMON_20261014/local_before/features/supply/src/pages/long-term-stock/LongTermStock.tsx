import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import {
  useSaveWithValidation,
  useProcMutation,
  useTabBtnPermissions,
  useTabProcQuery,
} from '@shared/hooks';
import { useMessageStore, useUIStore } from '@shared/stores';

import { LongTermStockForm } from './components/LongTermStockForm';
import { LongTermStockGrid } from './components/LongTermStockGrid';
import { useLongTermStockValidation } from './hooks/useLongTermStockValidation';
import { LBL, MENU_ID, MSG, SHEETS } from './long-term-stock.constants';
import type { LongTermStockRow } from './long-term-stock.types';
import { useLongTermStockStore } from './useLongTermStockStore';

// AS-IS: SCP0084_LongTermStock.cs — 조회 리포트 + MEMO 단일 컬럼 Edit-토글 편집 + 저장 + 엑셀.
export const LongTermStock = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGrid<LongTermStockRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();

  // Edit 버튼 토글 상태 — 조회 직후 전 셀 읽기전용, Edit 클릭 시 MEMO 편집 개시(AS-IS EditButton).
  const [editable, setEditable] = useState(false);

  const isOpenSearchArea = useLongTermStockStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useLongTermStockStore(state => state.setOpenSearchArea);
  const searchParams = useLongTermStockStore(state => state.searchParams);
  const filters = useLongTermStockStore(state => state.filters);
  const setFilters = useLongTermStockStore(state => state.setFilters);
  const clearFilters = useLongTermStockStore(state => state.clearFilters);
  const initialized = useLongTermStockStore(state => state.initialized);
  const fetchStaticColumns = useLongTermStockStore(state => state.fetchStaticColumns);
  const staticColumns = useLongTermStockStore(state => state.staticColumns);
  const noDivisionAuth = useLongTermStockStore(state => state.noDivisionAuth);

  const { t } = useTranslation();
  const setAlert = useMessageStore(state => state.setAlert);
  const setToast = useMessageStore(state => state.setToast);
  const setProgress = useUIStore(state => state.setProgress);
  const queryClient = useQueryClient();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const { saveWithValidation } = useSaveWithValidation();
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

  // 저장(MEMO 전용) — CRUD_TYPE I/M/D 행만 전송(6키+MEMO). 성공 시 재조회 + 편집모드 해제(AS-IS
  //   SaveData_Memo→Find_Data 재조회로 전셀 재잠금, cs:405~). 표준 useProcMutation 경로(convert-core
  //   §2.4). 성공 MSG00002 / 오류 MSG00003 = TO-BE 표준(AS-IS MSG00004 임의 재사용 금지, hook #114).
  const { mutate } = useProcMutation<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: [tabId] });
      setToast({ type: 'success', message: t('MSG00002', '_성공적으로 저장되었습니다!') });
      setEditable(false);
    },
  });

  const handleSearch = () => {
    if (!validateFind(searchParams)) return;
    setEditable(false); // 재조회 = 전셀 재잠금(AS-IS Find_Data 후 LockColumn, R2)
    setFilters();
    void fetchStaticColumns();
  };

  // Edit 토글 — AS-IS EditButton 가드: fps==null(R4)·RowCount==0(R5) 무동작. Action(String) 컬럼
  //   hidden 가드(R6)는 NSCM 등가 없음(공용 그리드는 별도 CRUD 플래그 표시 컬럼이 없고 EditTracker
  //   가 CRUD_TYPE 을 추적) → 미해당(__asis-mapping__ 기록). SwitchLock 왕복 = editable 토글.
  const handleEditToggle = () => {
    if (!gridRef.current) return; // R4 fps==null
    if (rows.length === 0) return; // R5 RowCount==0 (빈 그리드 편집 금지)
    setEditable(prev => !prev);
  };

  // 저장 — 편집 중 셀 커밋 후 CRUD_TYPE 행만 수집. 필수검증 대상 0건(MEMO 비필수)이나 표준 배선
  //   (useSaveWithValidation) 의무(convert-core §2.4). CRUD_TYPE 전용 판정(자체 상태필드 신설 금지).
  const handleSave = () => {
    const g = gridRef.current;
    if (!g) return;
    g.finishEditing();
    const gridRows = (g.collectionView?.sourceCollection ?? []);
    const dirtyRows = gridRows.filter(row => (row as WijmoRowItem).CRUD_TYPE);
    saveWithValidation(dirtyRows, staticColumns, mutate);
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
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 버튼 게이트 — search=hasButton('SEARCH')+권한0행 차단(R8) / save=hasButton('SAVE')&&editable /
  //   excel=실동작 / insert·delete=미노출(행추가/삭제 미제공) / manual·upload=미사용.
  //   Edit 는 공용 Hotkeys enum 에 키가 없어(F2='_F2_Unused') hotkeyConfig 로 표현 불가 →
  //   customButtons 로 노출(SAVE 권한 대리 게이트, BOD/SCP0007 선례). __asis-mapping__ 기록.
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') && !noDivisionAuth ? handleSearch : false,
    save: hasButton('SAVE') && editable ? handleSave : false,
    excel: handleExcel,
    insert: false,
    delete: false,
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
        searchParam={searchParams}
        customButtons={
          hasButton('SAVE')
            ? [
                {
                  label: t(LBL.EDIT, 'Edit'),
                  appearance: editable ? 'contained' : 'outlined',
                  action: handleEditToggle,
                },
              ]
            : undefined
        }
      />
      <LongTermStockGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        data={rows}
        editable={editable}
      />
    </>
  );
};
