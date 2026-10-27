import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CRUD_MSG, CRUD_TYPE } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction, type EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { DemandManagerForm } from './components/DemandManagerForm';
import { DemandManagerGrid } from './components/DemandManagerGrid';
import { VersionPopupModal } from './components/modals';
import {
  INSERT_ROW_DEFAULTS,
  MEASURE_PAIR,
  MENU_ID,
  MSG,
  SHEETS,
} from './demand-manager.constants';
import type { DemandManagerRow, LookupProjectRow } from './demand-manager.types';
import { useDemandManagerStore } from './useDemandManagerStore';
import { callDeleteOrderList, callSaveOrderList } from './utils/demand-manager.api';
import { groupKeyOf } from './utils/demand-manager.insertAnchor';
import { buildMonthColumns } from './utils/demand-manager.months';
import { buildSaveRows, collectDeleteGroupKeys, newRowKey } from './utils/demand-manager.save';
import { validateFind } from './utils/demand-manager.validate';

// AS-IS DMF0068_DemandManager40 (Demand > Demand Waterfall > Demand Manager — 정본 1,337행 1:1).
//   Division 40 전용. 한 건 = Measure 2행 1세트(QTY(Cell) / Sales Amt.(KRW))로, 추가·수정·삭제가
//   모두 짝 단위로 움직인다. 조회 기간이 그리드 월 컬럼(M1..Mn)의 개수와 헤더를 결정한다.
//   TO-BE 표준에 따라 조회 직후부터 바로 편집 가능하다(AS-IS 의 Edit 모드 토글은 이관하지 않는다).
export const DemandManager = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  // 공용 DataGrid 제네릭에 그대로 물리는 ref 3종 — mkt-fcst / forecast-price 와 같은 배선이라
  //   화면 쪽 캐스팅(as never)이 필요 없다.
  const gridRef = useRef<FlexGridType<DemandManagerRow>>(undefined);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);
  const editTrackerRef = useRef<EditTracker<DemandManagerRow>>(undefined);

  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;

  const sc = useDemandManagerStore(s => s.searchCondition);
  const setSearchCondition = useDemandManagerStore(s => s.setSearchCondition);
  const filters = useDemandManagerStore(s => s.filters);
  const setFilter = useDemandManagerStore(s => s.setFilter);
  const clearFilters = useDemandManagerStore(s => s.clearFilters);
  const openSearchArea = useDemandManagerStore(s => s.openSearchArea);
  const setOpenSearchArea = useDemandManagerStore(s => s.setOpenSearchArea);
  const staticColumns = useDemandManagerStore(s => s.staticColumns);
  const fetchStaticColumns = useDemandManagerStore(s => s.fetchStaticColumns);
  const restoreSearchConditions = useDemandManagerStore(s => s.restoreSearchConditions);
  const appliedFrom = useDemandManagerStore(s => s.appliedFrom);
  const appliedTo = useDemandManagerStore(s => s.appliedTo);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // 명시 조회 게이트 — Search 를 눌러야 조회한다
  const [hasSearched, setHasSearched] = useState(false);
  const [openVersionModal, setOpenVersionModal] = useState(false);
  const [deletedKeys, setDeletedKeys] = useState<string[]>([]);
  // GridAction.addRowSet/removeRow 는 itemsSource 배열을 직접 splice/remove 하고 setState 를
  //   호출하지 않는다 — React 리렌더가 안 일어나면 이 컴포넌트가 렌더에서 파생하는 값(SubTitle
  //   의 dataCount 등)이 Insert/Delete 이후에도 그 이전 렌더 시점 값에 멈춰 있는다.
  //   handleInsert/handleDelete 끝에서 이 카운터를 올려 강제로 한 번 리렌더시킨다.
  const [, forceGridRerender] = useState(0);

  // 메인 조회 — PKG_DMF0068.P_DMF0068_GET_ORDERLIST
  //   ⭐ filters 는 store 참조를 그대로 넘긴다 (인라인 객체 금지 — 무한 재조회 방지)
  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: hasSearched && !!filters[SHEETS.MAIN],
  });

  // Project 셀 콤보 — PKG_DMF0068.P_DMF0068_GET_LOOKUPPROJECT (버전 단위)
  const { data: projectData } = useTabProcQuery<MENU_ID, SHEETS.LOOKUP_PROJECT>({
    menuId: MENU_ID,
    sheetName: SHEETS.LOOKUP_PROJECT,
    tabId,
    filters: filters[SHEETS.LOOKUP_PROJECT],
    enabled: hasSearched && !!filters[SHEETS.LOOKUP_PROJECT],
  });
  const projectOptions = useMemo<LookupProjectRow[]>(
    () => (projectData as { o_rc1?: LookupProjectRow[] } | undefined)?.o_rc1 ?? [],
    [projectData]
  );

  // ⭐ useTabProcQuery 는 응답의 result 를 그대로 돌려준다 → 커서 키는 PROC_M 의 COL_NM(=o_rc1)
  const mainData = data as { o_rc1?: DemandManagerRow[] } | undefined;
  useEffect(() => {
    if (!mainData) return;
    // 재조회 = 대기 중인 삭제 표시 초기화 + 변경 추적 비우기 (hook #97). 대기 중인 신규행은
    //   spRows(=grid.collectionView.sourceCollection) 자체가 새 배열로 바뀌면서 자연히
    //   사라진다 — 별도 초기화가 필요 없다.
    setDeletedKeys([]);
    editTrackerRef.current?.clearChanges();
  }, [mainData]);

  // mount 시 1회 admin 메타 fetch + persist 된 filters 무효화
  //   필수: F6 저장 조회조건 복원을 컬럼 메타 fetch 보다 먼저 await 한다 — 복원된 조회조건이
  //   그리드 렌더보다 먼저 자리잡도록 한다(순서가 뒤집혀도 이 화면은 division 40 하드코딩이라
  //   컬럼은 영향받지 않지만, 다른 전환 화면과 배선을 맞춰 둔다).
  useEffect(() => {
    clearFilters();
    void (async () => {
      await restoreSearchConditions();
      await fetchStaticColumns();
    })();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // ⭐ 월 컬럼 — 조회에 실제로 사용된 기간에서만 산출한다
  const monthColumns = useMemo(
    () => buildMonthColumns(appliedFrom, appliedTo),
    [appliedFrom, appliedTo]
  );

  const spRows = useMemo<DemandManagerRow[]>(() => mainData?.o_rc1 ?? [], [mainData]);
  // 삭제 표시된 행도 그리드에 남긴다 — 행 헤더에 'D' 가 찍혀 무엇이 지워질지 보인다.
  //   앱 공통 규약(GridAction.removeRow)과 동일: 신규 행만 실제로 빼고, 저장된 행은 CRUD_TYPE='D' 표시.
  // 신규 세트는 GridAction.addRowSet 이 spRows(=grid.collectionView.sourceCollection)에
  //   직접 splice 하므로 별도 병합이 필요 없다 — spRows 자체가 조회행+신규행이다.
  const rows = spRows;

  // ⭐ 편집 가능 판정 = 버튼 권한(SAVE) + 행의 EDIT_YN(서버 판정).
  //   세션에는 그룹 ID 가 없고(groupId 는 빈 값) groups 는 표시명이라 화면에서 그룹명을 비교하지 않는다.
  const canEdit = hasButton('SAVE');
  const msgText = (msgId: string, fallback: string, param?: string) =>
    param ? t(msgId, fallback).replace('{0}', param) : t(msgId, fallback);
  const alert = (msgId: string, fallback: string, param?: string) =>
    void setAlert({ type: 'alert', content: msgText(msgId, fallback, param) });

  // F5 Search — 버전 → 기간 필수 → 형식 → 대소 순으로 확인한 뒤 조회한다
  const handleSearch = () => {
    const v = validateFind(sc.versionNo, sc.periodFrom, sc.periodTo);
    if (!v.ok) {
      alert(v.msgId!, '_조회 조건을 확인해 주세요.', v.param);
      return;
    }
    setDeletedKeys([]);
    setHasSearched(true);
    setFilter();
    void fetchStaticColumns();
  };

  // F8 Insert — 언제나 2행 한 세트. 두 행에 같은 그룹 키를 주고 Measure 를 고정 배정한다.
  //   앵커·정렬 고정·세트 경계는 GridAction.addRowSet(groupKey=groupKeyOf) 이 전부 처리한다
  //   — 앵커를 선택 행 자체로 잡으면 짝 행(Sales Amt.)을 눌렀을 때 QTY/Sales Amt. 사이에 끼는
  //   문제, 정렬이 걸려도 세트가 앵커 옆에 붙어 있게 하는 문제, 같은 자리에 연속 Insert 하면
  //   누른 순서대로 쌓이는 문제를 공용 함수가 그룹 키 하나로 해결한다.
  const handleInsert = () => {
    const grid = gridRef.current;
    if (!grid) return;
    const gid = newRowKey();
    const block: Partial<DemandManagerRow>[] = MEASURE_PAIR.map(m => ({
      ...INSERT_ROW_DEFAULTS,
      INSERT_GROUP_ID: gid,
      KEYVALUE2: gid,
      KEYVALUE: newRowKey(),
      MEASURE: m.name,
      MEASURE2: m.code,
    }));
    const added = GridAction.addRowSet(grid, block, 'above', {
      groupKey: groupKeyOf,
      preserveMergeManager: true,
    });
    const target = added?.[0];
    if (!target) return;
    // Insert 직후 새 행으로 포커스·스크롤 이동 — addRowSet 은 itemsSource 참조를 바꾸지
    //   않으므로(같은 배열에 splice) CollectionView 가 재생성되지 않고, 여기서 한 번만
    //   선택을 옮겨도 그대로 유지된다.
    for (let i = 0; i < grid.rows.length; i++) {
      if (grid.rows[i]?.dataItem !== target) continue;
      grid.select(i, Math.max(0, grid.selection.col));
      grid.scrollIntoView(i, -1);
      break;
    }
    // addRowSet 이 setState 를 호출하지 않으므로 강제 리렌더 — SubTitle dataCount 등을 최신
    //   rows 로 다시 계산시킨다.
    forceGridRerender(v => v + 1);
  };

  // F9 Delete — 선택한 행이 속한 세트를 지운다. 신규 세트는 GridAction.removeRow(groupKey)로
  //   화면에서 바로 빼고(병합 안 된 컬럼을 클릭해 세트의 한 행만 선택돼도 groupKey 로 짝 행까지
  //   함께 지운다), 저장된 행은 CRUD_TYPE='D' 로 표시만 해 두었다가 저장 시 프로시저가 짝까지
  //   지운다.
  const handleDelete = () => {
    const grid = gridRef.current;
    const sel = grid?.selectedItems?.[0] as DemandManagerRow | undefined;
    if (!grid || !sel) return;
    if (sel.CRUD_TYPE === CRUD_TYPE.INSERT) {
      GridAction.removeRow(grid, true, true, { groupKey: groupKeyOf });
      forceGridRerender(v => v + 1);
      return;
    }
    const key = String(sel.KEYVALUE2 ?? sel.INSERT_GROUP_ID ?? '');
    if (!key) return;
    // 세트 단위 표시 — 한 행만 골라도 짝 행까지 함께 지워진다(SP 가 그룹 키로 세트 전체를 삭제).
    //   실제 'D' 스탬프는 아래 effect 가 deletedKeys 에서 파생시킨다.
    setDeletedKeys(prev => (prev.includes(key) ? prev : [...prev, key]));
  };

  // 삭제 표시를 행 객체에 반영 — 행 헤더의 'D' 는 공통 DataGrid 가 dataItem.CRUD_TYPE 을
  //   그대로 읽어 찍는다(dataGridUtils). deletedKeys 를 단일 원천으로 두고 여기서만 스탬프하므로
  //   조회/저장으로 deletedKeys 가 비면 표시도 함께 사라진다(두 갈래 drift 없음).
  //   'M'(편집 추적) 은 건드리지 않는다 — 'D' 만 세운다/지운다.
  useEffect(() => {
    spRows.forEach(r => {
      const key = String(r.KEYVALUE2 ?? '');
      if (deletedKeys.includes(key)) r.CRUD_TYPE = CRUD_TYPE.DELETE;
      else if (r.CRUD_TYPE === CRUD_TYPE.DELETE) delete r.CRUD_TYPE;
    });
    gridRef.current?.invalidate();
  }, [spRows, deletedKeys]);

  // F7 Save — 변경·신규 행을 저장하고 삭제 표시된 세트를 지운다. 하나라도 성공하면 다시 조회한다.
  const handleSave = async () => {
    // EditTracker 가 화면 행 타입으로 제네릭이 잡혀 있어 캐스팅 없이 그대로 쓴다.
    const changedMap =
      editTrackerRef.current?.getOriginalValues() ??
      new Map<DemandManagerRow, Record<string, WijmoPrimitive>>();

    // 변경·신규가 속한 세트를 통째로 보낸다 (짝 행의 기간이 함께 움직여야 하므로).
    //   ⭐ 삭제 표시된 세트는 제외 — 그리드에 남아 있으므로(‘D’ 표시) 편집 이력이 있으면
    //     저장과 삭제가 동시에 나갈 수 있다.
    const dirtyKeys = new Set<string>();
    rows.forEach(r => {
      const k = String(r.KEYVALUE2 ?? r.INSERT_GROUP_ID ?? '');
      if (!k || deletedKeys.includes(k)) return;
      if (r.CRUD_TYPE === CRUD_TYPE.INSERT || changedMap.has(r)) dirtyKeys.add(k);
    });
    const targets = rows.filter(r => dirtyKeys.has(String(r.KEYVALUE2 ?? r.INSERT_GROUP_ID ?? '')));
    const deleteKeys = collectDeleteGroupKeys(
      spRows.filter(r => deletedKeys.includes(String(r.KEYVALUE2 ?? '')))
    );

    if (targets.length === 0 && deleteKeys.length === 0) {
      // 변경/신규 없음 → toast + 공통 문구 (DMF0003~0007/0020/0072 과 동일 규약.
      //   필수·검증 실패는 modal alert 유지). MSG00004 '수정한 내용이 없습니다'.
      void setToast({ type: 'error', message: msgText('MSG00004', '_수정한 내용이 없습니다.') });
      return;
    }

    const savedScroll = gridRef.current?.scrollPosition ?? null;
    let reload = false;

    // 저장·삭제 성공 여부만 모아서 토스트 1개로 띄운다 (앱 공통 setToast success).
    //   확인 버튼이 필요한 실패·검증만 알럼으로 남긴다.
    //   성공 메시지는 message-id.ts 공통 원장(CRUD_MSG.SAVED)을 그대로 쓴다.
    let hasSuccess = false;

    try {
      if (targets.length > 0) {
        const build = buildSaveRows(targets);
        if (build.error) {
          alert(build.error.msgId!, '_저장 조건을 확인해 주세요.', build.error.param);
          return;
        }
        const res = await callSaveOrderList(build.rows, sc.versionNo);
        if (res.ok) {
          hasSuccess = true;
          reload = true;
        } else if (res.code === 'DUPLICATE') {
          alert(MSG.PERIOD_OVERLAP, '_중첩된 기간이 있습니다.');
          return;
        } else {
          alert(MSG.DUPLICATED, res.message ?? '_중복된 조합이 존재합니다.');
          return;
        }
      }

      if (deleteKeys.length > 0) {
        const res = await callDeleteOrderList(deleteKeys);
        if (res.ok) {
          hasSuccess = true;
          reload = true;
        } else {
          // 실패는 확인이 필요하므로 알럼. 성공 토스트와 채널이 달라 서로 덮지 않는다.
          alert(MSG.EXEC_ERROR, res.message ?? '_저장 중 오류가 발생했습니다.');
        }
      }

      if (hasSuccess)
        void setToast({ type: 'success', message: t(CRUD_MSG.SAVED.id, CRUD_MSG.SAVED.fallback) });

      if (reload) {
        // 저장 후 재조회 구간은 그리드 렌더를 멈춰 둔다.
        //   이 구간에서 itemsSource 가 두 번 바뀐다 — (1) 대기 중이던 신규행 제거,
        //   (2) 재조회 데이터 도착. wijmo 는 itemsSourceChanged 마다 컬럼 필터를 통째로
        //   비우고(FlexGridFilter 생성자가 clear 를 건다) 공용 DataGrid 가 바로 뒤에서
        //   되돌리는데(DataGrid.handleInitialized capture/restore 한 쌍), 그 사이나 두 번의
        //   왕복 사이에 페인트가 끼면 "필터가 풀린 전체 그리드" 가 스쳐 보인다
        //   (2026-08-27 사용자 지적). beginUpdate/endUpdate 는 그 구간의 렌더를 눌러
        //   마지막 상태를 한 번만 그리게 한다 — 필터 복원 로직 자체는 그대로 돌아간다.
        //   필수: endUpdate 는 finally 에서 부른다. 재조회가 던지면 그리드가 멈춰 있는 채로 남는다.
        const g = gridRef.current;
        try {
          g?.beginUpdate();
          setDeletedKeys([]);
          editTrackerRef.current?.clearChanges();
          await (refetch?.() ?? Promise.resolve());
        } finally {
          try {
            g?.endUpdate();
          } catch {
            /* unmount race */
          }
        }
        if (savedScroll && gridRef.current) gridRef.current.scrollPosition = savedScroll;
      }
    } catch (e) {
      const msg =
        e instanceof Error ? e.message : t(MSG.EXEC_ERROR, '_저장 중 오류가 발생했습니다.');
      void setAlert({ type: 'alert', content: msg });
    }
  };

  // SubTitle 공통 버튼 — 미지정 항목은 공통 기본 동작을 따른다 (hook #64)
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    delete: hasButton('DELETE') ? handleDelete : false,
    save: hasButton('SAVE') ? () => void handleSave() : false,
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

      {openSearchArea && (
        <DemandManagerForm
          onSearch={handleSearch}
          onOpenVersionModal={() => setOpenVersionModal(true)}
          onChangeVersion={v => setSearchCondition({ versionNo: v })}
        />
      )}

      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='DemandManager'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
      />

      <DemandManagerGrid
        rows={rows}
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        staticColumns={staticColumns}
        monthColumns={monthColumns}
        projectOptions={projectOptions}
        canEdit={canEdit}
      />

      <VersionPopupModal
        open={openVersionModal}
        modalClose={() => setOpenVersionModal(false)}
        onSelect={versionNo => setSearchCondition({ versionNo })}
      />
    </>
  );
};
