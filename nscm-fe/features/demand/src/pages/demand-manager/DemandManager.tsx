import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CRUD_MSG, CRUD_TYPE } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
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
import {
  findGroupTopIndex,
  mergeInsertedRows,
  removePendingGroup,
  type PendingInsert,
} from './utils/demand-manager.insertAnchor';
import { buildMonthColumns } from './utils/demand-manager.months';
import { buildSaveRows, collectDeleteGroupKeys, newRowKey } from './utils/demand-manager.save';
import { validateFind } from './utils/demand-manager.validate';

// Insert 포커스를 붙들 프레임 수 — 그리드 쪽 필터 복원이 다음 프레임에 CollectionView 를
//   다시 계산하며 선택을 되돌리므로, 그 뒤까지 같은 행을 다시 잡아 준다.
const FOCUS_SETTLE_FRAMES = 3;

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
  const appliedFrom = useDemandManagerStore(s => s.appliedFrom);
  const appliedTo = useDemandManagerStore(s => s.appliedTo);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  // 명시 조회 게이트 — Search 를 눌러야 조회한다
  const [hasSearched, setHasSearched] = useState(false);
  const [versionLabel, setVersionLabel] = useState('');
  const [openVersionModal, setOpenVersionModal] = useState(false);
  // 신규 세트(CRUD_TYPE='I') — 각 행이 표시 위치를 정하는 앵커를 함께 든다.
  //   앵커 = Insert 를 누른 시점에 선택된 행이 속한 세트의 첫 행 (utils/demand-manager.insertAnchor.ts).
  const [insertedRows, setInsertedRows] = useState<PendingInsert[]>([]);
  const [deletedKeys, setDeletedKeys] = useState<string[]>([]);
  // Insert 직후 포커스를 옮길 신규행 — rows 재계산 후 아래 effect 가 소비하고 비운다.
  const focusRowRef = useRef<DemandManagerRow | null>(null);

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
    // 재조회 = 대기 중인 추가·삭제 표시 초기화 + 변경 추적 비우기 (hook #97)
    setInsertedRows([]);
    setDeletedKeys([]);
    editTrackerRef.current?.clearChanges();
  }, [mainData]);

  // mount 시 1회 admin 메타 fetch + persist 된 filters 무효화
  useEffect(() => {
    clearFilters();
    void fetchStaticColumns();
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
  // 조회행 + 신규행 병합 — 신규 세트는 앵커(선택 세트의 첫 행) 바로 위에 놓는다.
  //   앵커가 없으면(선택 없이 Insert) 맨 위 — 예전 동작과 같다.
  const rows = useMemo<DemandManagerRow[]>(
    () => mergeInsertedRows(spRows, insertedRows),
    [insertedRows, spRows]
  );

  // Insert 직후 새 행으로 포커스·스크롤 이동 — 신규 세트가 그리드 중간(선택 세트 바로 위)에
  //   생기므로 이동이 없으면 사용자가 새 행을 찾아 스크롤해야 한다.
  //   필수: 한 번 맞추고 끝내지 않는다. itemsSource 가 바뀌면 wijmo 가 CollectionView 를 새로
  //   만들며 선택을 초기화하는데, 이 effect 시점에 grid.rows 가 아직 새 배열을 반영하지 않았으면
  //   탐색이 -1 이라 화면이 그대로 머문다. 반대로 탐색에 성공해 선택을 옮겨 놓아도, 그리드 쪽
  //   필터 복원(FlexGridFilter.apply -> CollectionView 재계산)이 다음 프레임에 돌면서 선택을
  //   행 참조가 아닌 인덱스 기준으로 되돌려 커서가 엉뚱한 행에 남는다.
  //   그래서 몇 프레임 동안 같은 행을 다시 붙든다. 이미 그 행이 선택돼 있으면 select 를 부르지 않아
  //   사용자 조작을 빼앗지 않는다.
  useEffect(() => {
    const target = focusRowRef.current;
    if (!target) return;

    const focusTarget = (): boolean => {
      const g = gridRef.current;
      if (!g) return false;
      for (let i = 0; i < g.rows.length; i++) {
        if (g.rows[i]?.dataItem !== target) continue;
        if (g.selection.row !== i) g.select(i, g.selection.col >= 0 ? g.selection.col : 0);
        g.scrollIntoView(i, -1);
        return true;
      }
      return false;
    };

    let raf = 0;
    let frames = 0;
    const tick = () => {
      focusTarget();
      if (++frames < FOCUS_SETTLE_FRAMES) raf = window.requestAnimationFrame(tick);
      else focusRowRef.current = null;
    };
    tick();
    return () => window.cancelAnimationFrame(raf);
  }, [rows]);

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
    // void setToast({ message: t('LBL00665', '_Loading...'), type: 'default', duration: 2000 });
    setInsertedRows([]);
    setDeletedKeys([]);
    setHasSearched(true);
    setFilter();
    void fetchStaticColumns();
  };

  /**
   * Insert 앵커 — 선택 셀이 속한 세트의 첫 행. 선택이 없으면 null(맨 위).
   *
   * 금지: wijmo 컬렉션(g.rows)에 .map/.filter 사용 — Array 상속이라 새 ObservableArray 가
   *   만들어져 결과가 깨진다. 인덱스 루프로 순수 배열에 복사한다.
   */
  const anchorRowOf = (): DemandManagerRow | null => {
    const g = gridRef.current;
    const index = g?.selection?.row ?? -1;
    if (!g || index < 0) return null;
    const gridRowItems: (DemandManagerRow | undefined)[] = [];
    for (let i = 0; i < g.rows.length; i++) {
      gridRowItems.push(g.rows[i]?.dataItem as DemandManagerRow | undefined);
    }
    return gridRowItems[findGroupTopIndex(gridRowItems, index)] ?? null;
  };

  // F8 Insert — 언제나 2행 한 세트. 두 행에 같은 그룹 키를 주고 Measure 를 고정 배정한다
  const handleInsert = () => {
    const gid = newRowKey();
    const block: DemandManagerRow[] = MEASURE_PAIR.map(m => ({
      ...INSERT_ROW_DEFAULTS,
      CRUD_TYPE: 'I',
      INSERT_GROUP_ID: gid,
      KEYVALUE2: gid,
      KEYVALUE: newRowKey(),
      MEASURE: m.name,
      MEASURE2: m.code,
    }));
    // 앵커 = 선택 셀이 속한 세트의 첫 행 — 신규 세트를 그 바로 위에 통째로 놓는다.
    //   앵커를 선택 행 자체로 잡으면 짝 행(Sales Amt.)을 눌렀을 때 QTY / Sales Amt. 사이에 낀다.
    //   배열 끝에 붙여 누른 순서를 유지한다(같은 자리에 연속 Insert 하면 위에서 아래로 쌓인다).
    const anchor = anchorRowOf();
    setInsertedRows(prev => [...prev, ...block.map(row => ({ row, anchor }))]);
    focusRowRef.current = block[0] ?? null;
  };

  // F9 Delete — 선택한 행이 속한 세트를 지운다. 신규 세트는 화면에서 바로 빼고,
  //   저장된 행은 CRUD_TYPE='D' 로 표시만 해 두었다가 저장 시 프로시저가 짝까지 지운다.
  const handleDelete = () => {
    const sel = gridRef.current?.selectedItems?.[0] as DemandManagerRow | undefined;
    if (!sel) return;
    const key = String(sel.KEYVALUE2 ?? sel.INSERT_GROUP_ID ?? '');
    if (!key) return;
    if (sel.CRUD_TYPE === CRUD_TYPE.INSERT) {
      // 지우는 세트를 앵커로 삼던 신규행이 있으면 그 앵커를 승계시킨다(맨 위로 튀지 않게).
      setInsertedRows(prev => removePendingGroup(prev, key));
      return;
    }
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
      alert('MSG00004', '_수정한 내용이 없습니다.');
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
        setInsertedRows([]);
        setDeletedKeys([]);
        editTrackerRef.current?.clearChanges();
        await (refetch?.() ?? Promise.resolve());
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
          versionLabel={versionLabel}
          onChangeVersion={v => {
            // 직접 입력값이 곧 조회에 쓰이는 VERSION_NO. 팝업 라벨은 해제한다.
            setVersionLabel('');
            setSearchCondition({ versionNo: v });
          }}
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
        onSelect={(versionNo, label) => {
          setSearchCondition({ versionNo });
          setVersionLabel(label);
        }}
      />
    </>
  );
};
