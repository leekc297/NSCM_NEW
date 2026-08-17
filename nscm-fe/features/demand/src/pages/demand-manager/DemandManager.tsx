import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
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
import styles from './DemandManager.module.scss';
import { useDemandManagerStore } from './useDemandManagerStore';
import { callDeleteOrderList, callSaveOrderList } from './utils/demand-manager.api';
import { buildMonthColumns } from './utils/demand-manager.months';
import { buildSaveRows, collectDeleteGroupKeys, newRowKey } from './utils/demand-manager.save';
import { validateFind } from './utils/demand-manager.validate';

// AS-IS DMF0068_DemandManager40 (Demand > Demand Waterfall > Demand Manager — 정본 1,337행 1:1).
//   Division 40 전용. 한 건 = Measure 2행 1세트(QTY(Cell) / Sales Amt.(KRW))로, 추가·수정·삭제가
//   모두 짝 단위로 움직인다. 조회 기간이 그리드 월 컬럼(M1..Mn)의 개수와 헤더를 결정한다.
//   TO-BE 표준에 따라 조회 직후부터 바로 편집 가능하다(AS-IS 의 Edit 모드 토글은 이관하지 않는다).
export const DemandManager = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGridType<DemandManagerRow>>(null);
  const gridFilterRef = useRef<FlexGridFilter>(undefined);
  const editTrackerRef = useRef<EditTracker>(undefined);

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
  const [insertedRows, setInsertedRows] = useState<DemandManagerRow[]>([]);
  const [deletedKeys, setDeletedKeys] = useState<string[]>([]);

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
  const rows = useMemo<DemandManagerRow[]>(
    () => [...insertedRows, ...spRows],
    [insertedRows, spRows]
  );

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
    void setToast({ message: t('LBL00665', '_Loading...'), type: 'default', duration: 2000 });
    setInsertedRows([]);
    setDeletedKeys([]);
    setHasSearched(true);
    setFilter();
    void fetchStaticColumns();
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
    setInsertedRows(prev => [...block, ...prev]);
  };

  // F9 Delete — 선택한 행이 속한 세트를 지운다. 신규 세트는 화면에서 바로 빼고,
  //   저장된 행은 CRUD_TYPE='D' 로 표시만 해 두었다가 저장 시 프로시저가 짝까지 지운다.
  const handleDelete = () => {
    const sel = gridRef.current?.selectedItems?.[0] as DemandManagerRow | undefined;
    if (!sel) return;
    const key = String(sel.KEYVALUE2 ?? sel.INSERT_GROUP_ID ?? '');
    if (!key) return;
    if (sel.CRUD_TYPE === CRUD_TYPE.INSERT) {
      setInsertedRows(prev => prev.filter(r => String(r.INSERT_GROUP_ID ?? '') !== key));
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
    const changedMap =
      (editTrackerRef.current?.getOriginalValues() as
        | Map<DemandManagerRow, Record<string, unknown>>
        | undefined) ?? new Map<DemandManagerRow, Record<string, unknown>>();

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

    // 저장·삭제 성공 결과는 모아서 토스트 1개로 띄운다 (앱 공통 setToast success).
    //   확인 버튼이 필요한 실패·검증만 알럼으로 남긴다.
    //   'ADD / MODIFY : ' / 'DELETE : ' 접두어는 화면이 붙이는 게 아니라 SP 가 결과 커서의
    //     EVENT 컬럼에 담아 내려준다(demand-manager.api.ts toResult → count). 메시지 원장은
    //     '{0}개의 데이터가 저장되었습니다.' 한 건이며, 삭제용 메시지 ID 는 따로 필요 없다.
    //   구분자는 공백 — 토스트 본문도 string 한 줄이라 '\n' 은 줄바꿈으로 렌더되지 않는다.
    const results: string[] = [];

    try {
      if (targets.length > 0) {
        const build = buildSaveRows(targets);
        if (build.error) {
          alert(build.error.msgId!, '_저장 조건을 확인해 주세요.', build.error.param);
          return;
        }
        const res = await callSaveOrderList(build.rows, sc.versionNo);
        if (res.ok) {
          results.push(
            msgText(MSG.SAVED_COUNT, '_{0}개의 데이터가 저장되었습니다.', res.count ?? '0')
          );
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
          results.push(
            msgText(MSG.SAVED_COUNT, '_{0}개의 데이터가 저장되었습니다.', res.count ?? '0')
          );
          reload = true;
        } else {
          // 실패는 확인이 필요하므로 알럼. 성공 토스트와 채널이 달라 서로 덮지 않는다.
          alert(MSG.EXEC_ERROR, res.message ?? '_저장 중 오류가 발생했습니다.');
        }
      }

      if (results.length > 0) void setToast({ type: 'success', message: results.join(' ') });

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
    <div className={styles.container}>
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
        gridRef={gridRef as never}
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
    </div>
  );
};
