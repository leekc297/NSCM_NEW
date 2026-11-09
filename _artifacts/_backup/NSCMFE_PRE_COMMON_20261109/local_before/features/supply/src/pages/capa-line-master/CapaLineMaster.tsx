import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import { apiClient } from '@foundation/apis';
import { CRUD_MSG } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore, useSessionStore } from '@shared/stores';

import {
  COLUMN_LABEL,
  LEVELS,
  MENU_ID,
  MSG,
  SAVE_NOT_APPLICABLE,
  SAVE_VALID_YN,
  SHEETS,
  SHEET_BY_LEVEL,
  type LevelNo,
} from './capa-line-master.constants';
import type { CapaLineRow } from './capa-line-master.types';
import styles from './CapaLineMaster.module.scss';
import { CapaLineMasterForm } from './components/CapaLineMasterForm';
import { CapaLineMasterLevelGrid } from './components/CapaLineMasterLevelGrid';
import { useCapaLineMasterValidation } from './hooks/useCapaLineMasterValidation';
import { useCapaLineMasterStore } from './useCapaLineMasterStore';
import { buildInsertRow, hasParentContext } from './utils/capaLineMaster.editLock';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// AS-IS GSCM.SCP.Forms.UIL Master/SCP0114_CAPA_LineMaster — 5 그리드 계층 마스터.
//   설계: .atlas/gscm-design/SCP0114/design/00~03,07. 상세 매핑: __asis-mapping__.md. 도메인 SCP(features/supply).
//   상단 3분할(L1 Site | L2 Company | L3 Plant) / 하단 2분할(L4 Building | L5 Line) — design 01 §1.
//   공통 Insert/Delete/Edit/Save 는 포커스된 1개 그리드에만 작용한다(AS-IS fps/spreadNow, hook #97).
//   편집모드는 5그리드 중 동시 1개만(AS-IS IsEditModes + editCnt>1 되돌림, cs:490~502).
//   SP 미배포(goal.md 2): PKG_SCP0114 -> 조회/저장 런타임 미완(convert-sp 후속).
export const CapaLineMaster = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  const sessionUserId = useSessionStore(s => s.session.userId);
  const { saveWithValidation } = useSaveWithValidation();
  const { findMissingIdOrName } = useCapaLineMasterValidation();
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const grid1 = useRef<FlexGrid | undefined>(undefined);
  const grid2 = useRef<FlexGrid | undefined>(undefined);
  const grid3 = useRef<FlexGrid | undefined>(undefined);
  const grid4 = useRef<FlexGrid | undefined>(undefined);
  const grid5 = useRef<FlexGrid | undefined>(undefined);
  const filter1 = useRef<FlexGridFilter | undefined>(undefined);
  const filter2 = useRef<FlexGridFilter | undefined>(undefined);
  const filter3 = useRef<FlexGridFilter | undefined>(undefined);
  const filter4 = useRef<FlexGridFilter | undefined>(undefined);
  const filter5 = useRef<FlexGridFilter | undefined>(undefined);
  const tracker1 = useRef<EditTracker | undefined>(undefined);
  const tracker2 = useRef<EditTracker | undefined>(undefined);
  const tracker3 = useRef<EditTracker | undefined>(undefined);
  const tracker4 = useRef<EditTracker | undefined>(undefined);
  const tracker5 = useRef<EditTracker | undefined>(undefined);
  const savingRef = useRef(false);

  const gridRefs: Record<LevelNo, typeof grid1> = { 1: grid1, 2: grid2, 3: grid3, 4: grid4, 5: grid5 };
  const filterRefs: Record<LevelNo, typeof filter1> = {
    1: filter1,
    2: filter2,
    3: filter3,
    4: filter4,
    5: filter5,
  };
  const trackerRefs: Record<LevelNo, typeof tracker1> = {
    1: tracker1,
    2: tracker2,
    3: tracker3,
    4: tracker4,
    5: tracker5,
  };

  const sc = useCapaLineMasterStore(s => s.searchCondition);
  const applied = useCapaLineMasterStore(s => s.applied);
  const filters = useCapaLineMasterStore(s => s.filters);
  const drill = useCapaLineMasterStore(s => s.drill);
  const setFilter = useCapaLineMasterStore(s => s.setFilter);
  const clearFilters = useCapaLineMasterStore(s => s.clearFilters);
  const resetForProductGroup = useCapaLineMasterStore(s => s.resetForProductGroup);
  const clearBelowLevel = useCapaLineMasterStore(s => s.clearBelowLevel);
  const drillDown = useCapaLineMasterStore(s => s.drillDown);
  const activeLevel = useCapaLineMasterStore(s => s.activeLevel);
  const setActiveLevel = useCapaLineMasterStore(s => s.setActiveLevel);
  const editingLevel = useCapaLineMasterStore(s => s.editingLevel);
  const toggleEditingLevel = useCapaLineMasterStore(s => s.toggleEditingLevel);
  const clearEditingLevel = useCapaLineMasterStore(s => s.clearEditingLevel);
  const openSearchArea = useCapaLineMasterStore(s => s.openSearchArea);
  const setOpenSearchArea = useCapaLineMasterStore(s => s.setOpenSearchArea);
  const staticColumns = useCapaLineMasterStore(s => s.staticColumns);
  const fetchStaticColumns = useCapaLineMasterStore(s => s.fetchStaticColumns);
  const initialized = useCapaLineMasterStore(s => s.initialized);

  // 레벨별 조회 — 각 시트가 자기 filters 참조로만 발사된다(명시 Search/드릴다운으로만 채워짐).
  const query1 = useTabProcQuery<MENU_ID, SHEETS.LEVEL1>({
    menuId: MENU_ID,
    sheetName: SHEETS.LEVEL1,
    tabId,
    filters: filters[SHEETS.LEVEL1],
    enabled: !!filters[SHEETS.LEVEL1],
  });
  const query2 = useTabProcQuery<MENU_ID, SHEETS.LEVEL2>({
    menuId: MENU_ID,
    sheetName: SHEETS.LEVEL2,
    tabId,
    filters: filters[SHEETS.LEVEL2],
    enabled: !!filters[SHEETS.LEVEL2],
  });
  const query3 = useTabProcQuery<MENU_ID, SHEETS.LEVEL3>({
    menuId: MENU_ID,
    sheetName: SHEETS.LEVEL3,
    tabId,
    filters: filters[SHEETS.LEVEL3],
    enabled: !!filters[SHEETS.LEVEL3],
  });
  const query4 = useTabProcQuery<MENU_ID, SHEETS.LEVEL4>({
    menuId: MENU_ID,
    sheetName: SHEETS.LEVEL4,
    tabId,
    filters: filters[SHEETS.LEVEL4],
    enabled: !!filters[SHEETS.LEVEL4],
  });
  const query5 = useTabProcQuery<MENU_ID, SHEETS.LEVEL5>({
    menuId: MENU_ID,
    sheetName: SHEETS.LEVEL5,
    tabId,
    filters: filters[SHEETS.LEVEL5],
    enabled: !!filters[SHEETS.LEVEL5],
  });

  // itemsSource 참조 안정화 — 매 렌더 새 배열이면 memo(DataGrid)가 무력화된다(nscm-patterns §5-4).
  const rows1 = useMemo<CapaLineRow[]>(() => query1.data?.o_rc1 ?? [], [query1.data]);
  const rows2 = useMemo<CapaLineRow[]>(() => query2.data?.o_rc1 ?? [], [query2.data]);
  const rows3 = useMemo<CapaLineRow[]>(() => query3.data?.o_rc1 ?? [], [query3.data]);
  const rows4 = useMemo<CapaLineRow[]>(() => query4.data?.o_rc1 ?? [], [query4.data]);
  const rows5 = useMemo<CapaLineRow[]>(() => query5.data?.o_rc1 ?? [], [query5.data]);
  const rowsByLevel: Record<LevelNo, CapaLineRow[]> = {
    1: rows1,
    2: rows2,
    3: rows3,
    4: rows4,
    5: rows5,
  };
  const refetchByLevel: Record<LevelNo, () => void> = {
    1: () => void query1.refetch?.(),
    2: () => void query2.refetch?.(),
    3: () => void query3.refetch?.(),
    4: () => void query4.refetch?.(),
    5: () => void query5.refetch?.(),
  };

  const clearAllTrackers = () => {
    tracker1.current?.clearChanges();
    tracker2.current?.clearChanges();
    tracker3.current?.clearChanges();
    tracker4.current?.clearChanges();
    tracker5.current?.clearChanges();
  };

  useEffect(() => {
    // 진입 자동조회 금지 — keep-alive 잔여 filters 무효화(§5-7) + 컬럼메타 1회 fetch.
    clearFilters();
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 조회조건 변경 시 초기화 — 두 축의 범위가 다르다. 한 키로 묶으면 Product Group 변경까지
  //   5그리드를 비우게 되고(과초기화), 사용자가 L1~L3 드릴다운을 처음부터 다시 밟아야 한다.
  //   - Division 변경   : grid 전체 (design 01 §2 L4 — AS-IS FindData(1) -> InitSpread(1~5))
  //   - ProductGroup 변경: grid L4·L5 만 (design 01 §2 L5 / 02 §3 — AS-IS FindData(4) -> InitSpread(4),(5))
  //   사용자 확정(2026-09-23): 어느 축이든 변경 즉시 재조회하지 않는다 — 초기화만 하고 재조회는
  //   명시 Search/드릴다운으로만(goal.md 6 #5). 컬럼 메타는 division 스코프라 division 변경 시에만 재조회한다.
  const prevDivisionRef = useRef(sc.divisionId);
  const prevShopGroupRef = useRef(sc.shopGroupId);
  useEffect(() => {
    if (prevDivisionRef.current !== sc.divisionId) {
      prevDivisionRef.current = sc.divisionId;
      prevShopGroupRef.current = sc.shopGroupId;
      clearAllTrackers();
      clearFilters();
      void fetchStaticColumns(sc.divisionId);
      return;
    }
    if (prevShopGroupRef.current !== sc.shopGroupId) {
      prevShopGroupRef.current = sc.shopGroupId;
      // 비우는 시트의 편집 마킹만 걷어낸다 — L1~L3 은 유지되므로 그 tracker 도 건드리지 않는다.
      tracker4.current?.clearChanges();
      tracker5.current?.clearChanges();
      resetForProductGroup();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId, sc.shopGroupId]);

  // 조회(F5) — AS-IS FindButton -> FindData(1, division, "") (cs:346~351). Level1 부터 다시 시작.
  const handleSearch = () => {
    // Division 은 필수 조회조건(사람설계서 1.3 R42 / design 02 §6 #1). AS-IS 는 DropDownList 라 항상 값이
    //   있었지만 TO-BE 는 미선택 상태로 시작하므로 여기서 게이트한다.
    if (!sc.divisionId) {
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRE_DIVISION, '_Please select Division.'),
      });
      return;
    }
    clearAllTrackers();
    setFilter();
    void fetchStaticColumns(sc.divisionId);
  };

  // Edit — 활성 그리드의 편집모드 토글. AS-IS EditButton(cs:462~502):
  //   (1) 활성 그리드에 'I'/'M' 행이 남아 있으면 return(미저장 편집 중 토글 차단, cs:478~486)
  //   (2) 토글 후 편집중 레벨이 2개 이상이면 되돌리고 return(동시 1개만, cs:498~502) -> store 가 담당
  const handleEdit = () => {
    const grid = gridRefs[activeLevel].current;
    const source = (grid?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
    if (source.some(row => row.CRUD_TYPE === 'I' || row.CRUD_TYPE === 'M')) return;
    toggleEditingLevel(activeLevel);
  };

  // Insert — 활성 그리드에 신규행 추가. AS-IS InsertRow(cs:1196~1296):
  //   사전조건 `spreadLevel.IsLock(SheetName) == false` = 그 레벨이 편집모드여야 한다(cs:1202).
  //   신규행 기본값 = 부모키 상속 + VALID_YN='Y' + DUMMY_YN='Y' + SORT_ORDER=Max+1.
  //   부모키는 드릴다운으로 확정된 컨텍스트에서만 온다 — 빈 값 폴백 금지(convert-core §2.4).
  const handleInsert = () => {
    const grid = gridRefs[activeLevel].current;
    if (!grid) return;
    const guideAlert = () =>
      void setAlert({
        type: 'alert',
        content: t(MSG.EDIT_AFTER_SEARCH, '_Edit mode is available after search.'),
      });
    // AS-IS 는 IsLock 시 조용히 아무것도 하지 않는다. TO-BE 는 동작(삽입 안 함)은 같게 두고 안내만 더한다.
    if (editingLevel !== activeLevel) return guideAlert();
    if (!applied) return guideAlert();
    // 부모 컨텍스트 미확정(= 해당 레벨을 드릴다운으로 연 적 없음) 상태의 삽입은 데이터 결함이다.
    if (!hasParentContext(activeLevel, drill)) return guideAlert();
    GridAction.addRow(
      grid,
      buildInsertRow(
        activeLevel,
        applied.divisionId,
        applied.shopGroupId,
        drill,
        rowsByLevel[activeLevel] as unknown as Record<string, unknown>[]
      ) as unknown as Partial<WijmoRowItem>
    );
  };

  // Delete — AS-IS DeleteButton(cs:358~384). 가드 3종(활성그리드 없음/빈그리드/미선택) 전부 무동작이고,
  //   선택행이 신규행('I')일 때만 로컬 제거한다. 기존행은 삭제 불가(메시지 없이 return, hook #138).
  const handleDelete = () => {
    const grid = gridRefs[activeLevel].current;
    if (!grid) return;
    if (grid.rows.length === 0) return;
    if (!grid.selectedRows?.length) return;
    GridAction.removeRow(grid, true);
    grid.invalidate();
  };

  // 저장 전송 — 활성 레벨 1시트만, CRUD 마킹행(I/M)을 `^` 병렬배열로 실어 보낸다(design 03 §4.3).
  //   파라미터 이름·순서는 AS-IS SAVE 호출(cs:910~926) 그대로다. PKG_SCP0114 미배포라 PROC_M 파라미터
  //   메타는 convert-sp 가 배포 후 all_arguments 실측으로 확정한다.
  const doSave = (level: LevelNo, dirty: Record<string, unknown>[]) => {
    void (async () => {
      if (savingRef.current) return;
      const shopGroupId = applied?.shopGroupId ?? '';
      const userId = sessionUserId ?? '';
      const na = SAVE_NOT_APPLICABLE;
      const acc: Record<string, string[]> = {
        p_active_flag: [],
        p_spreadSeq: [],
        p_division_id: [],
        p_site_id: [],
        p_site_name: [],
        p_company_id: [],
        p_company_name: [],
        p_plant_id: [],
        p_plant_name: [],
        p_factory_id: [],
        p_factory_name: [],
        p_line_id: [],
        p_line_name: [],
        p_shop_group_id: [],
        p_valid_yn: [],
        p_created_by: [],
        p_last_updated_by: [],
      };
      for (const row of dirty) {
        acc.p_active_flag.push(str(row.CRUD_TYPE) || 'M');
        acc.p_spreadSeq.push(String(level));
        acc.p_division_id.push(str(row.DIVISION_ID));
        acc.p_site_id.push(str(row.SITE_ID));
        acc.p_site_name.push(str(row.SITE_NAME));
        // 레벨별 미해당 컬럼은 '-' 로 채운다(cs:832~892).
        acc.p_company_id.push(level >= 2 ? str(row.COMPANY_ID) : na);
        acc.p_company_name.push(level >= 2 ? str(row.COMPANY_NAME) : na);
        acc.p_plant_id.push(level >= 3 ? str(row.PLANT_ID) : na);
        acc.p_plant_name.push(level >= 3 ? str(row.PLANT_NAME) : na);
        acc.p_factory_id.push(level >= 4 ? str(row.FACTORY_ID) : na);
        acc.p_factory_name.push(level >= 4 ? str(row.FACTORY_NAME) : na);
        acc.p_line_id.push(level >= 5 ? str(row.LINE_ID) : na);
        acc.p_line_name.push(level >= 5 ? str(row.LINE_NAME) : na);
        acc.p_shop_group_id.push(level >= 4 ? shopGroupId : na);
        // 주의: AS-IS 는 그리드 VALID_YN 편집값을 보내지 않고 전 레벨 'Y' 를 하드코딩한다
        //   (cs:841/854/867/880/893). 2026-09-23 사용자 확정 (a) AS-IS 재현 — 실값 전송 금지.
        acc.p_valid_yn.push(SAVE_VALID_YN);
        acc.p_created_by.push(userId);
        acc.p_last_updated_by.push(userId);
      }
      const payload: Record<string, string> = {};
      for (const [key, values] of Object.entries(acc)) payload[key] = values.join('^');

      savingRef.current = true;
      try {
        const res = await apiClient.post<Record<string, unknown>>(
          `/${MENU_ID}/${SHEET_BY_LEVEL[level]}/SAVE/call-proc`,
          payload
        );
        // false-success 차단(nscm-patterns §5-10) — 인터셉터가 500/CODE≠0 도 resolve 할 수 있다.
        if (res.status >= 400 || Number(res.data?.code)) {
          void setAlert({
            type: 'alert',
            content:
              (res.data as { message?: string })?.message?.trim() ||
              t(MSG.SAVE_FAIL, '_Failed to save.'),
          });
          return;
        }
        // SAVE SP 는 `SELECT result_code, result_cnt` 를 돌려주고 AS-IS 는 첫 행 [0]=='S' 만 성공으로 본다
        //   (cs:930). 'S' 가 아닌 유일한 경로가 중복 THROW 99020 이다(07 §3 S3) — 서버 메시지를 그대로
        //   표면화하고, 메시지가 비면 중복 안내로 대체한다.
        const body = res.data?.result as Record<string, unknown> | undefined;
        const firstSet = body
          ? (Object.values(body).find(Array.isArray) as Record<string, unknown>[] | undefined)
          : undefined;
        const head = firstSet?.[0];
        const resultCode = head ? str(head.result_code ?? head.RESULT_CODE) : '';
        if (resultCode && resultCode !== 'S') {
          void setAlert({
            type: 'alert',
            content:
              (res.data as { message?: string })?.message?.trim() ||
              t(MSG.DUP_KEY, '_Duplicate key exists.'),
          });
          return; // 편집 유지 — 사용자가 수정 후 재저장.
        }
        const savedCount = head ? str(head.result_cnt ?? head.RESULT_CNT) : '';
        // 주의: i18next 기본 보간자는 `{{ }}` 라 DB 메시지의 `{0}` 은 옵션 전달로 치환되지 않는다.
        //   같은 파일 REQUIRED_FIELD 경로와 동일하게 replace 로 치환해야 "{0} data saved." 가 그대로 노출되지 않는다.
        void setToast({
          type: 'success',
          message: t(MSG.SAVE_SUCCESS, '_{0} data saved.').replace(
            '{0}',
            String(savedCount || dirty.length)
          ),
        });
        trackerRefs[level].current?.clearChanges();
        clearEditingLevel();
        // 저장 성공 후 AS-IS 는 FindData(activeLevel)(cs:935~954)을 부른다 — 활성 레벨 재조회 +
        //   InitSpread(activeLevel..5)로 하위 레벨 비움(cs:689~721). 하위를 남기면 방금 바뀐 부모
        //   기준으로는 맞지 않는 행이 그대로 보인다. 하위 레벨의 편집 마킹도 함께 걷어낸다.
        for (const candidate of LEVELS) {
          if (candidate > level) trackerRefs[candidate].current?.clearChanges();
        }
        clearBelowLevel(level);
        refetchByLevel[level]();
      } catch (e) {
        void setAlert({
          type: 'alert',
          content:
            e instanceof Error ? e.message : t(MSG.SAVE_FAIL, '_Failed to save.'),
        });
      } finally {
        savingRef.current = false;
      }
    })();
  };

  // Save — AS-IS SaveButton -> SaveData(cs:669~672, 763~). 활성 레벨 1시트만 저장한다.
  const handleSave = () => {
    const level = activeLevel;
    const grid = gridRefs[level].current;
    grid?.finishEditing();
    const source = (grid?.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
    // AS-IS 는 I/M/D 를 모두 담지만(cs:813) 이 화면은 D 를 만들지 않는다 — 삭제는 신규행 로컬 제거뿐.
    const dirty = source.filter(row => row.CRUD_TYPE === 'I' || row.CRUD_TYPE === 'M');
    if (dirty.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_DATA, '_No changes to save.') });
      return;
    }
    // AS-IS 는 저장 직전에도 `IsLock == false`(편집모드) 를 확인한다(cs:784). 편집모드가 아니면 마킹행이
    //   생길 수 없으므로 실질 no-op 이지만 파리티로 유지한다.
    if (editingLevel !== level) return;

    // 화면 커스텀 필수검증 — AS-IS CheckDummyDuplication(cs:769, 공백 검사) 등가.
    //   admin 이 INPUT_TP_CD 를 전건 'S' 로 등록하면 공용 검증이 사문화되므로 이 경로를 함께 건다
    //   (memory input-tp-cd-search-only-kills-save-validation).
    const missing = findMissingIdOrName(level, dirty);
    if (missing) {
      void setAlert({
        type: 'alert',
        content: t(CRUD_MSG.REQUIRED_FIELD.id, CRUD_MSG.REQUIRED_FIELD.fallback).replace(
          '{0}',
          `[${COLUMN_LABEL[missing] ?? missing}]`
        ),
      });
      return;
    }
    // 공용 메타 기반 필수검증(INPUT_TP_CD=M/IM 또는 라벨 `*`) — 커스텀만 두면 SCP0020 실사고 재현.
    saveWithValidation(dirty, staticColumns[SHEET_BY_LEVEL[level]], rows => doSave(level, rows));
  };

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: hasButton('INSERT') ? handleInsert : false,
    delete: hasButton('DELETE') ? handleDelete : false,
    save: hasButton('SAVE') ? handleSave : false,
    manual: false,
    upload: false,
  };

  const renderGrid = (level: LevelNo) => (
    <CapaLineMasterLevelGrid
      level={level}
      rows={rowsByLevel[level]}
      gridRef={gridRefs[level]}
      gridFilterRef={filterRefs[level]}
      editTrackerRef={trackerRefs[level]}
      editingLevel={editingLevel}
      adminColumns={staticColumns[SHEET_BY_LEVEL[level]]}
      onDrillDown={row => drillDown(level, row)}
      onFocus={() => setActiveLevel(level)}
    />
  );

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      {openSearchArea && <CapaLineMasterForm onSearch={handleSearch} />}
      <SubTitle
        menuId={MENU_ID}
        grid={gridRefs[activeLevel]}
        gridFilter={filterRefs[activeLevel]}
        dataCount={rowsByLevel[activeLevel].length}
        excelFileName='CapaLineMaster'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={
          hasButton('EDIT')
            ? [
                {
                  // Edit 라벨 = LBL00414(EN 'Edit'). LBL00654 는 등록문구 'M$' 라 재사용 금지(hook #114).
                  // 금지: buttonLabel 을 넘기지 않는다. SubTitle 은 `buttonLabel={label}` 뒤에
                  //   `{...buttonProps}` 를 전개하므로(SubTitle.tsx:307~309) 화면이 buttonLabel 을 주면
                  //   그 값이 label 을 덮어쓴다. 빈 문자열을 주면 텍스트 없는 빈 버튼이 되고, 이 화면은
                  //   Edit 가 유일한 편집모드 진입점이라 Insert/Save/셀편집이 전부 도달 불가해진다.
                  //   buttonLabel:'' 은 iconComponent 를 함께 주는 아이콘 전용 버튼에서만 쓰는 관용구다.
                  label: t('LBL00414', '_Edit'),
                  title: t('LBL00414', '_Edit'),
                  action: handleEdit,
                },
              ]
            : []
        }
      />

      {/* design 01 §1 — splitContainer1(Horizontal): 상단 L1|L2|L3 3분할 / 하단 L4|L5 2분할. */}
      <PanelGroup className={styles.tableWrapper} orientation='vertical'>
        <Panel defaultSize={50} minSize={20}>
          <PanelGroup className={styles.rowGroup} orientation='horizontal'>
            <Panel defaultSize={34} minSize={10}>
              {renderGrid(1)}
            </Panel>
            <PanelSeparator className={styles.colSplitBar} />
            <Panel defaultSize={33} minSize={10}>
              {renderGrid(2)}
            </Panel>
            <PanelSeparator className={styles.colSplitBar} />
            <Panel defaultSize={33} minSize={10}>
              {renderGrid(3)}
            </Panel>
          </PanelGroup>
        </Panel>
        <PanelSeparator className={styles.splitBar} />
        <Panel defaultSize={50} minSize={20}>
          <PanelGroup className={styles.rowGroup} orientation='horizontal'>
            <Panel defaultSize={50} minSize={10}>
              {renderGrid(4)}
            </Panel>
            <PanelSeparator className={styles.colSplitBar} />
            <Panel defaultSize={50} minSize={10}>
              {renderGrid(5)}
            </Panel>
          </PanelGroup>
        </Panel>
      </PanelGroup>
    </>
  );
};
