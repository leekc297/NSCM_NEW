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
  type ProductGroup,
} from './capa-line-master.constants';
import type { CapaLineRow } from './capa-line-master.types';
import styles from './CapaLineMaster.module.scss';
import { CapaLineMasterForm } from './components/CapaLineMasterForm';
import { CapaLineMasterLevelGrid } from './components/CapaLineMasterLevelGrid';
import { CapaLineMasterProductGroupBar } from './components/CapaLineMasterProductGroupBar';
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
  const setSearchCondition = useCapaLineMasterStore(s => s.setSearchCondition);
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
  // AS-IS 수정(Edit) 모드 토글은 미이식한다(asis_to_tobe.md §11, 전 화면 공통 2026-09-23 사용자 결정).
  //   편집은 EDIT 버튼 권한(canEdit) 단일 축 — 권한이 있으면 조회 직후부터 편집가능 셀이 상시 열린다.
  const canEdit = hasButton('EDIT');
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

  const clearTrackersBelow = (level: LevelNo) => {
    for (const candidate of LEVELS) {
      if (candidate > level) trackerRefs[candidate].current?.clearChanges();
    }
  };

  // 멀티그리드 편집 배타(AS-IS 파리티) — AS-IS 는 "한 그리드만 edit 모드"가 원칙이다: 시트는 기본 잠김
  //   (SpreadInfo.AddSheet ht=true)이고 Insert/Save 가 IsLock==false(=edit 모드)를 요구하며(.cs:1202·784),
  //   EditButton 이 editCnt>1 을 되돌려(.cs:498) 동시 2그리드 편집을 막고, 미저장 그리드는 edit 모드를
  //   빠져나오지도 못한다(.cs:478~486). 그래서 두 그리드가 동시에 미저장이 될 수 없어, 저장후 하위 재조회
  //   (FindData→InitSpread, .cs:935~954·689~721)가 다른 그리드 입력을 지우는 일이 AS-IS 엔 없다.
  //   TO-BE 는 수정모드 토글을 미이식([[editbutton-toggle-not-ported]])해 5그리드 상시 편집이 되면서 이
  //   유실이 회귀로 생겼다(SCP0114 수정요청 2026-11-11). 복원: edit 모드 토글이 없으니 "다른 그리드에
  //   미저장(CRUD_TYPE)이 있으면 이 그리드의 편집/Insert 시작을 차단"으로 AS-IS 배타를 재현한다.
  //   주의: tracker.hasChanges() 는 수정(M)만 보고 신규행(I)은 못 본다(editTracker.ts:125) — 신규행까지
  //   잡으려 그리드 소스의 CRUD_TYPE 으로 판정한다.
  const hasPending = (level: LevelNo): boolean => {
    const source = (gridRefs[level].current?.collectionView?.sourceCollection ??
      []) as Record<string, unknown>[];
    return source.some(row => row.CRUD_TYPE === 'I' || row.CRUD_TYPE === 'M');
  };
  const hasPendingOther = (level: LevelNo): boolean => LEVELS.some(l => l !== level && hasPending(l));
  const hasPendingBelow = (level: LevelNo): boolean => LEVELS.some(l => l > level && hasPending(l));

  // 미저장 작업 안내 — 등록 confirm 문구(MSG00703/00704)는 '조회/닫기' 전제라 안 맞아, 맥락 중립 차단 문구
  //   MSG01210("작업중인 데이터가 있습니다. 작업 완료후 사용하세요.")을 쓴다(동일 유형 화면의 차단 패턴과 정합).
  const alertUnsavedWork = () =>
    void setAlert({
      type: 'alert',
      content: t('MSG01210', '_작업중인 데이터가 있습니다. 작업 완료후 사용하세요.'),
    });

  // 편집/Insert 시작 배타 — 다른 그리드에 미저장이 있으면 차단하고 안내(true=차단).
  //   beginningEdit·pastingCell(그리드 컴포넌트)·handleInsert 공용.
  const blockIfOtherGridDirty = (level: LevelNo): boolean => {
    if (!hasPendingOther(level)) return false;
    alertUnsavedWork();
    return true;
  };

  // 드릴다운 — AS-IS CellDoubleClick(cs:1743~1814). 하위 레벨 재조회로 하위 미저장이 사라지므로, 편집 중인
  //   그리드를 둔 채 부모를 드릴하는 경로는 차단·안내한다(배타로 드문 경우지만 유실 차단은 남긴다).
  const handleDrillDown = (level: LevelNo, row: Record<string, unknown>) => {
    if (hasPendingBelow(level)) {
      alertUnsavedWork();
      return;
    }
    clearTrackersBelow(level);
    drillDown(level, row);
  };

  // Product Group 라디오 변경 — effect(resetForProductGroup)가 L4·L5 를 비운다. L1~L3 은 보존되므로
  //   하위(>3=L4·L5)에 미저장이 있을 때만 차단·안내하고 shopGroupId 를 바꾸지 않는다(라디오 controlled 자동 유지).
  const handleChangeShopGroup = (value: ProductGroup) => {
    if (sc.shopGroupId === value) return;
    if (hasPendingBelow(3)) {
      alertUnsavedWork();
      return;
    }
    setSearchCondition({ shopGroupId: value });
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

  // Insert — 활성 그리드에 신규행 추가. AS-IS InsertRow(cs:1196~1296):
  //   AS-IS 사전조건 `spreadLevel.IsLock(SheetName) == false`(수정 모드)는 미이식(§11) — 대신 조회(applied)
  //   + 부모 컨텍스트 확정만 본다. 신규행 기본값 = 부모키 상속 + VALID_YN='Y' + DUMMY_YN='Y' + SORT_ORDER=Max+1.
  //   부모키는 드릴다운으로 확정된 컨텍스트에서만 온다 — 빈 값 폴백 금지(convert-core §2.4).
  const handleInsert = () => {
    const grid = gridRefs[activeLevel].current;
    if (!grid) return;
    // 편집 배타(AS-IS 파리티) — 다른 그리드에 미저장이 있으면 Insert 차단. AS-IS 는 한 그리드만 edit 모드라
    //   다른 그리드가 미저장이면 이 그리드가 edit 모드(IsLock==false)에 들어갈 수 없어 Insert 자체가 안 됐다.
    if (blockIfOtherGridDirty(activeLevel)) return;
    const guideAlert = () =>
      void setAlert({
        type: 'alert',
        content: t(MSG.EDIT_AFTER_SEARCH, '_Edit mode is available after search.'),
      });
    // 미조회(applied 없음) 상태 삽입 차단 — AS-IS 는 무언 return, TO-BE 는 동작 동일 + 안내만 더한다.
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
        // SAVE SP 는 결과 커서로 { RESULT_CODE, RESULT_CNT | ERR_MESSAGE } 를 돌려준다. 성공만 'S' 이고
        //   (cs:930), TO-BE SP 는 중복 시 THROW 가 아니라 RESULT_CODE='N' + ERR_MESSAGE('중복 데이터가
        //   있습니다.') + ROLLBACK 을 반환한다(PKG_SCP0114 line 505~523, 2026-11-02 실측). 예외는 'F'.
        //   BaseResponse.code/message 는 SP 예외가 없으면 늘 "0"/"success" 라, 성공 판정을 top-level 로
        //   하면 중복이 success 로 샌다 — 성공 판정은 오직 이 RESULT_CODE 로 한다.
        //   주의: result 에는 빈 DATARESULT:[] 와 복수 커서(o_rc1·o_result_cursor)가 섞여 온다. '첫 배열'
        //   (find(Array.isArray))을 쓰면 빈 DATARESULT 를 잡아 RESULT_CODE 가 비고, 중복이 success 로
        //   새는 실결함이 있었다(2026-11-02 네트워크 실측). 전 커서를 펼쳐 RESULT_CODE 를 담은 행을 찾는다.
        const body = res.data?.result as Record<string, unknown> | undefined;
        const resultRows = body
          ? (Object.values(body).filter(Array.isArray) as Record<string, unknown>[][]).flat()
          : [];
        const head = resultRows.find(row => row && (row.result_code != null || row.RESULT_CODE != null));
        const resultCode = head ? str(head.result_code ?? head.RESULT_CODE) : '';
        if (resultCode !== 'S') {
          // 성공('S')이 아니면 전부 실패 — 중복('N')은 DUP_KEY, 그 외('F'·결과미반환)는 SAVE_FAIL 로 대체.
          //   서버 ERR_MESSAGE(커서 컬럼)가 있으면 그걸 우선 표면화한다(top-level message="success" 는 안 쓴다).
          const serverMsg = head ? str(head.err_message ?? head.ERR_MESSAGE).trim() : '';
          void setAlert({
            type: 'alert',
            content:
              serverMsg ||
              (resultCode === 'N'
                ? t(MSG.DUP_KEY, '_Duplicate key exists.')
                : t(MSG.SAVE_FAIL, '_Failed to save.')),
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
        // 저장 성공 후 AS-IS 는 FindData(activeLevel)(cs:935~954)을 부른다 — 활성 레벨 재조회 +
        //   InitSpread(activeLevel..5)로 하위 레벨 비움(cs:689~721). 하위를 남기면 방금 바뀐 부모
        //   기준으로는 맞지 않는 행이 그대로 보인다. 하위 레벨의 편집 마킹도 함께 걷어낸다 — 편집 배타
        //   (blockIfOtherGridDirty)로 하위엔 미저장이 있을 수 없어 여기서 지울 입력이 애초에 없다(AS-IS 동일).
        clearTrackersBelow(level);
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
    // 저장 시점에는 하위 미저장 가드를 두지 않는다 — 편집 배타(blockIfOtherGridDirty)로 활성 레벨 외 다른
    //   그리드가 미저장일 수 없으므로, 저장 성공 후 clearBelowLevel+재조회가 지울 미저장이 애초에 없다(AS-IS 동일).
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
      canEdit={canEdit}
      adminColumns={staticColumns[SHEET_BY_LEVEL[level]]}
      onDrillDown={row => handleDrillDown(level, row)}
      onFocus={() => setActiveLevel(level)}
      guardEditStart={() => blockIfOtherGridDirty(level)}
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
      />

      {/* design 01 §1 — splitContainer1(Horizontal): 상단 L1|L2|L3 3분할 / 하단 L4|L5 2분할. */}
      <PanelGroup className={styles.tableWrapper} orientation='vertical'>
        <Panel defaultSize={50} minSize={20}>
          {/* AS-IS Panel1: L1 고정 468 | L2 고정 454 | L3 Fill(나머지) → 넓은 화면 기준 ~25/25/50
              (Designer.cs splitContainer1, 01_layout.md §1). L3(Plant)이 가장 넓다. */}
          <PanelGroup className={styles.rowGroup} orientation='horizontal'>
            <Panel defaultSize={25} minSize={10}>
              {renderGrid(1)}
            </Panel>
            <PanelSeparator className={styles.colSplitBar} />
            <Panel defaultSize={25} minSize={10}>
              {renderGrid(2)}
            </Panel>
            <PanelSeparator className={styles.colSplitBar} />
            <Panel defaultSize={50} minSize={10}>
              {renderGrid(3)}
            </Panel>
          </PanelGroup>
        </Panel>
        <PanelSeparator className={styles.splitBar} />
        <Panel defaultSize={50} minSize={20}>
          {/* 하단 영역 = Product Group 조회조건 바 + L4|L5 그리드. AS-IS 는 Product Group(rgrpSearchLevel)이
              Level1~3 과 Level4~5 사이에 위치(design 01 §1) — 바를 하단 Panel 최상단에 둬 재현한다. */}
          <div className={styles.bottomPane}>
            <CapaLineMasterProductGroupBar onChangeShopGroup={handleChangeShopGroup} />
            {/* AS-IS Panel2: L4 고정 468 | L5 Fill(나머지) → 넓은 화면 기준 ~25/75. L5(Line, 5컬럼)가 넓다. */}
            <PanelGroup className={styles.bottomRowGroup} orientation='horizontal'>
              <Panel defaultSize={25} minSize={10}>
                {renderGrid(4)}
              </Panel>
              <PanelSeparator className={styles.colSplitBar} />
              <Panel defaultSize={75} minSize={10}>
                {renderGrid(5)}
              </Panel>
            </PanelGroup>
          </div>
        </Panel>
      </PanelGroup>
    </>
  );
};
