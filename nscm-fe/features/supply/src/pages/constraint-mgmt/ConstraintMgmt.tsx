import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import _ from '@foundation/lodash';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import type { EditTracker } from '@foundation/utils';
import { GridAction, GridUtils } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import {
  useProcMutation,
  useSaveWithValidation,
  useTabBtnPermissions,
  useTabComboQueries,
  useTabProcQuery,
} from '@shared/hooks';
import { TitleArea } from '@shared/lges';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore } from '@shared/stores';

import { ConstraintMgmtDetailGrid } from './components/ConstraintMgmtDetailGrid';
import { ConstraintMgmtForm } from './components/ConstraintMgmtForm';
import { ConstraintMgmtMasterGrid } from './components/ConstraintMgmtMasterGrid';
import {
  ADMIN_YN_TRUE,
  COMBO,
  LBL,
  MASTER_DUPLICATE_KEY_COLUMNS,
  MENU_ID,
  MSG,
  SHEETS,
} from './constraint-mgmt.constants';
import type { DetailRow, MasterRow } from './constraint-mgmt.types';
import styles from './ConstraintMgmt.module.scss';
import { useConstraintMgmtStore } from './useConstraintMgmtStore';
import {
  buildDynamicDetailColumns,
  EMPTY_DETAIL_ROW,
  EMPTY_MASTER_ROW,
  filterDetailRowsByPlanGroup,
  findDuplicateRow,
  isValidDisplaySeq,
  pickSaveTarget,
  sanitizeDetailRow,
} from './utils/constraintMgmt.utils';

export const ConstraintMgmt = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore(state => state.setAlert);
  const setToast = useMessageStore(state => state.setToast);
  const queryClient = useQueryClient();
  const { saveWithValidation } = useSaveWithValidation();

  const masterGridRef = useRef<FlexGrid<MasterRow>>();
  const masterGridFilterRef = useRef<FlexGridFilter>();
  const masterEditTrackerRef = useRef<EditTracker<MasterRow>>();
  const detailGridRef = useRef<FlexGrid<DetailRow>>();
  const detailGridFilterRef = useRef<FlexGridFilter>();
  const detailEditTrackerRef = useRef<EditTracker<DetailRow>>();

  const searchParams = useConstraintMgmtStore(state => state.searchParams);
  const filters = useConstraintMgmtStore(state => state.filters);
  const isOpenSearchArea = useConstraintMgmtStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useConstraintMgmtStore(state => state.setOpenSearchArea);
  const activeGrid = useConstraintMgmtStore(state => state.activeGrid);
  const mainLookupType = useConstraintMgmtStore(state => state.mainLookupType);
  const planGroupColumn = useConstraintMgmtStore(state => state.planGroupColumn);
  const appliedPlanGroupNames = useConstraintMgmtStore(state => state.appliedPlanGroupNames);
  const dynamicColumnLabels = useConstraintMgmtStore(state => state.dynamicColumnLabels);
  const hiddenSubColumns = useConstraintMgmtStore(state => state.hiddenSubColumns);
  const masterStaticColumns = useConstraintMgmtStore(state => state.staticColumns.lookupMaster);
  const detailBaseColumns = useConstraintMgmtStore(state => state.staticColumns.lookupDetail);
  const setFilters = useConstraintMgmtStore(state => state.setFilters);
  const setAppliedAdminYn = useConstraintMgmtStore(state => state.setAppliedAdminYn);
  const clearFilters = useConstraintMgmtStore(state => state.clearFilters);
  const clearDetail = useConstraintMgmtStore(state => state.clearDetail);
  const fetchStaticColumns = useConstraintMgmtStore(state => state.fetchStaticColumns);
  const restoreSearchParams = useConstraintMgmtStore(state => state.restoreSearchParams);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  /**
   * 편집 가능은 기본값이고 "누가 편집할 수 있는가"만 화면 오픈 시 1회 판정한다
   * (decisions.md §2 — AS-IS EditButton 모드토글은 전 화면 공통 미이식).
   * 금지: Edit 버튼(customButtons)·editMode 토글 state 를 다시 만들지 마라. 사용자 결정으로 뺀 것이다.
   * 권한 로딩 중에는 hasButton 이 false 라 읽기전용으로 시작한다(안전 기본값).
   */
  const canEdit = hasButton('EDIT');

  /**
   * 관리자 판정과 Plan Group 후보를 같은 콤보 훅으로 받는다 — 조회조건 Form 과 같은 queryKey 라
   * react-query 가 중복 호출을 합친다. 그룹명 리터럴을 FE 에 두지 않으려고 판정 자체를
   * 서버 SQL(AdminYn_SCP0120)에 맡겼다.
   */
  const [adminYnRows, planGroupRows] = useTabComboQueries({
    filters: [COMBO.ADMIN_YN, COMBO.PLAN_GROUP],
  });
  const isAdmin = String(adminYnRows?.[0]?.CODE ?? '') === ADMIN_YN_TRUE;
  const ownedPlanGroupNames = useMemo(
    () => planGroupRows?.map(item => String(item.NAME ?? '')) ?? [],
    [planGroupRows]
  );

  const { data: masterData, refetch: refetchMaster } = useTabProcQuery<
    MENU_ID,
    SHEETS.LOOKUP_MASTER
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.LOOKUP_MASTER,
    tabId,
    filters: filters[SHEETS.LOOKUP_MASTER],
    enabled: !!filters[SHEETS.LOOKUP_MASTER],
  });

  // 하단은 row-context lazy fetch — 마스터를 더블클릭해 filters 가 세팅될 때만 발사한다.
  const { data: detailData } = useTabProcQuery<MENU_ID, SHEETS.LOOKUP_DETAIL>({
    menuId: MENU_ID,
    sheetName: SHEETS.LOOKUP_DETAIL,
    tabId,
    filters: filters[SHEETS.LOOKUP_DETAIL],
    enabled: !!filters[SHEETS.LOOKUP_DETAIL],
  });

  /**
   * 참조를 useMemo 로 고정한다 — 조회 전에는 masterData 가 undefined 라 렌더마다 새 `[]` 가
   * 만들어지고, 그때마다 itemsSource 가 갈려 GridAction.addRow 로 splice 한 신규행이 담긴
   * 배열째 교체된다(메모리 datagrid-save-read-from-grid-source).
   *
   * 원본을 slice 로 복사해 넘긴다 — GridAction.addRowSet 은 화면이 넘긴 배열 자체에 splice 하므로
   * 응답 배열을 그대로 주면 react-query 캐시 배열이 신규행으로 오염된 채 남는다(하단과 대칭).
   */
  const masterRows = useMemo(() => (masterData?.o_rc ?? []).slice(), [masterData]);

  /**
   * Plan Group 권한 필터(AS-IS F-01) 적용 결과가 곧 하단 바인딩 소스다.
   * 참조를 useMemo 로 고정한다 — 단일 Lookup Type 최대 28,757행이라 렌더마다 새 배열을 만들면
   * Wijmo 가 컬럼까지 재생성한다.
   *
   * 비교값은 조회조건 원본이 아니라 조회 발사 시점 스냅샷(appliedPlanGroupNames)이다 —
   * 체크박스를 건드리는 것만으로 재필터되면 미저장 신규행이 사라진다(AS-IS 는 FindData_Sub
   * 안에서 그 시점 한 번만 읽는다). 뒤집어 말하면 마스터를 다시 고를 때마다 스냅샷 참조가
   * 새로 만들어져 이 배열도 새로 만들어지고, 그게 곧 AS-IS InitSpread(siSub) = 하단 pending
   * 초기화다. 언제나 원본을 slice 로 복사해 두므로 addRow 의 splice 가 react-query 캐시
   * 배열을 오염시키지도 않는다.
   */
  const detailRows = useMemo(
    () =>
      filterDetailRowsByPlanGroup((detailData?.o_rc ?? []).slice(), {
        isAdmin,
        planGroupColumn,
        picked: appliedPlanGroupNames,
        owned: ownedPlanGroupNames,
      }),
    [detailData, isAdmin, planGroupColumn, appliedPlanGroupNames, ownedPlanGroupNames]
  );

  /**
   * Sub 동적 3축(숨김/라벨/필수 `*`)이 얹힌 파생 컬럼셋 — 그리드 렌더와 저장 필수검증이
   * 반드시 같은 것을 써야 해서 그리드 컴포넌트가 아니라 여기서 만든다(G-01).
   */
  const detailColumns = useMemo(
    () => buildDynamicDetailColumns(detailBaseColumns, dynamicColumnLabels, hiddenSubColumns),
    [detailBaseColumns, dynamicColumnLabels, hiddenSubColumns]
  );

  /** 저장 성공 토스트의 {0} 에 넣을 건수 — mutate 직전 전송 행 수를 담아 둔다. */
  const savedCountRef = useRef(0);

  const toastSaved = () => {
    setToast({
      type: 'success',
      message: t(MSG.SAVE_SUCCESS, '_{0} data saved.').replace(
        '{0}',
        String(savedCountRef.current)
      ),
    });
  };

  const { mutate: mutateMaster } = useProcMutation<MENU_ID, SHEETS.LOOKUP_MASTER>({
    menuId: MENU_ID,
    sheetName: SHEETS.LOOKUP_MASTER,
    tabId,
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: [tabId] });
      // AS-IS 는 Main 저장 후 FindData_Main 이 돌아 Sub 를 비운다(cs:421 경로 동일).
      clearDetail();
      toastSaved();
    },
  });

  const { mutate: mutateDetail } = useProcMutation<MENU_ID, SHEETS.LOOKUP_DETAIL>({
    menuId: MENU_ID,
    sheetName: SHEETS.LOOKUP_DETAIL,
    tabId,
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: [tabId] });
      toastSaved();
    },
  });

  useEffect(() => {
    // 진입 자동조회 금지(AS-IS FindWhenOpen 미설정) — keep-alive 잔여 filters 를 먼저 무효화한다.
    clearFilters();
    void fetchStaticColumns();
    // F6 로 저장한 조회조건을 폼에 복원한다(새로고침 생존은 이 GET 뿐 — store 는 비영속).
    void restoreSearchParams();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  /**
   * 관리자 판정이 조회보다 늦게 도착한 경우의 복구 — AdminYn_SCP0120 콤보는 비동기라
   * 응답 전에 Search 를 누르면 isAdmin=false 가 filters.adminYn='N' 으로 굳는다. filters 는
   * 다음 Search 전까지 다시 안 도므로, 관리자에게 SEGMENT10='Y' 행이 계속 은닉된 채 남는다.
   * AS-IS 는 NowGroupID 를 동기로 읽어(cs:384~391) 이 창 자체가 없다 — 판정이 바뀌면 그 시점에
   * 같은 조회조건으로 다시 발사해 등가를 맞춘다. 값이 같으면 아무것도 하지 않아 루프가 없다.
   * 갈아끼우는 것은 adminYn 하나뿐이다 — setFilters 를 쓰면 조회조건을 폼 현재값에서 다시 읽어
   * 사용자가 Search 를 누르지 않은 조건이 적용된다(감사 G-20).
   */
  useEffect(() => {
    const applied = filters[SHEETS.LOOKUP_MASTER];
    if (!applied) return;
    const nextAdminYn = isAdmin ? 'Y' : 'N';
    if (applied.adminYn === nextAdminYn) return;
    setAppliedAdminYn(nextAdminYn);
    // Main 결과셋이 갈리므로 하단은 Search 와 같게 비운다(AS-IS FindData_Main cs:421).
    clearDetail();
  }, [isAdmin, filters, setAppliedAdminYn, clearDetail]);

  const handleSearch = () => {
    /**
     * 조회권한 게이트는 핸들러 안에 둔다 — SearchArea 의 조회 버튼에는 권한 검사가 없어
     * hotkeyConfig 만 막으면 그 버튼으로 그대로 조회된다(공용 컴포넌트라 경계 밖이라 못 고친다).
     * AS-IS R-29 도 CanSelect 불통과 시 안내 후 return 이다.
     */
    if (!hasButton('SEARCH')) {
      void setAlert({
        type: 'alert',
        content: t(MSG.NO_PERMISSION, '_You do not have permission.'),
      });
      return;
    }
    const next = {
      lookupType: String(searchParams.lookupType ?? '').trim(),
      validYn: searchParams.validYn === 'ALL' ? '' : String(searchParams.validYn ?? ''),
      adminYn: isAdmin ? 'Y' : 'N',
    };
    // 조건이 그대로면 filters 참조를 바꿔도 queryKey 가 같아 재조회가 안 된다 — AS-IS 는 매번
    // 다시 조회하므로 그 경우에만 refetch 를 쓴다(SYS0010 Lookup.tsx:143 과 동일 분기).
    if (_.isEqual(next, filters[SHEETS.LOOKUP_MASTER])) void refetchMaster();
    else setFilters(next.adminYn);
    // 재조회 분기에서도 하단은 항상 비운다.
    clearDetail();
    // admin 이 컬럼 메타를 바꿨으면 Search 시점에 반영한다.
    void fetchStaticColumns();
  };

  const handleInsert = () => {
    if (activeGrid === 'sub') {
      if (!detailGridRef.current) return;
      // AS-IS 엔 없는 가드다. 마스터 미선택 상태로 넣으면 LOOKUP_TYPE 이 빈 행이 만들어져
      // 저장 경로까지 흘러간다 — SYS0010 선례대로 안내 후 막는다(근거는 __asis-mapping__.md).
      if (!mainLookupType) {
        void setAlert({
          type: 'alert',
          content: t(MSG.SELECT_LOOKUP_TYPE, '_Please select a Lookup Type first.'),
        });
        return;
      }
      GridAction.addRow(detailGridRef.current, {
        ...EMPTY_DETAIL_ROW,
        LOOKUP_TYPE: mainLookupType,
        CRUD_TYPE: 'I',
      });
      return;
    }
    if (!masterGridRef.current) return;
    // Main 은 AS-IS InsertButton 에 early-return 가드가 0건이라 임의 가드를 두지 않는다.
    GridAction.addRow(masterGridRef.current, { ...EMPTY_MASTER_ROW, CRUD_TYPE: 'I' });
  };

  /**
   * 삭제는 AS-IS DeleteButton(cs:333~341, spdMain/spdSub 판별 후 siMain/siSub.Delete())과
   * 동형으로 신규행·기존행 모두 삭제한다(2026-09-29 사용자 지시로 decisions.md Q-01 "신규행만"
   * 번복 — AS-IS 물리삭제 패리티 복원). removeRow(ref) 는 신규행('I')은 뷰에서 제거하고 기존행은
   * CRUD_TYPE='D' 로 마킹하며, 저장 시 SAVE SP 의 D 분기(P_SCP0120_SAVE_LOOKUP_*.CRUD_TYPE='D'
   * → 내부 P_SCP0120_DELETE_LOOKUP_*)가 물리 삭제한다. D 마킹 행은 저장·재조회 전까지 그리드에
   * 남는다(NSCM mark-then-save 규약).
   */
  const handleDelete = () => {
    // 두 그리드의 행 타입이 달라 ref 를 삼항으로 합치면 FlexGrid 제네릭이 union 이 되어 좁혀지지
    // 않는다(TS2345) — 시트별로 분기해 각 ref 를 그대로 넘긴다(as 캐스팅 금지).
    if (activeGrid === 'sub') {
      if (!detailGridRef.current) return;
      GridAction.removeRow(detailGridRef.current);
      return;
    }
    if (!masterGridRef.current) return;
    GridAction.removeRow(masterGridRef.current);
  };

  const alertDuplicate = () => {
    void setAlert({ type: 'alert', content: t(MSG.DUPLICATE, '_Duplicate key exists.') });
  };

  // Main 은 키가 LOOKUP_TYPE 하나라 컬럼명을 넣은 문구로 안내한다.
  const alertDuplicateMaster = () => {
    void setAlert({
      type: 'alert',
      content: t(MSG.DUPLICATE_MASTER, '_The same {0} exists.').replace(
        '{0}',
        t(LBL.LOOKUP_TYPE, '_Lookup Type')
      ),
    });
  };

  /**
   * 검증 순서는 AS-IS 와 같게 필수 -> 중복이다(cs:546~548 Main · cs:659~661 Sub).
   * saveWithValidation 이 필수검증을 먼저 돌리고 통과분만 콜백으로 넘기므로, 중복·DISPLAY_SEQ
   * 검사를 콜백 안에 두면 두 검사가 동시에 걸렸을 때 AS-IS 와 같은 메시지가 뜬다.
   */
  const saveMaster = (rows: MasterRow[]) => {
    // LOOKUP_TYPE_KEY 는 조회 SP 가 LOOKUP_TYPE AS LOOKUP_TYPE_KEY 로 함께 내려주므로 응답 행을
    // 그대로 보내면 개명한 행도 원래 이름으로 대상을 찾는다 — 화면이 키를 만들지 않는다.
    saveWithValidation(rows, masterStaticColumns, payload => {
      // 중복 비교 모집단은 변경분이 아니라 그리드에 실린 전 행이다(masterRows = itemsSource 배열,
      // addRow 의 splice 도 이 배열에 들어간다) — AS-IS CheckValidation 안쪽 루프에 action 필터가
      // 없는 것과 같다. 변경행끼리만 보면 기존 행과 충돌하는 신규행을 SP 가 ORA-00001 로 받는다.
      // if (findDuplicateRow(payload, masterRows)) return alertDuplicate();
      // Main 은 원장 PK 와 같게 LOOKUP_TYPE 만 본다.
      if (findDuplicateRow(payload, masterRows, MASTER_DUPLICATE_KEY_COLUMNS)) {
        // return alertDuplicate();
        return alertDuplicateMaster();
      }
      savedCountRef.current = payload.length;
      mutateMaster(payload);
    });
  };

  const saveDetail = (rows: DetailRow[]) => {
    // SEGMENT*_KEY 는 GET SP 가 원본을 직접 내려주므로 손대지 않고 그대로 재전송한다
    // (편집값을 넣으면 UPDATE 가 0행으로 끝나고 오류도 없이 사라진다).
    // 필수검증은 동적 라벨이 얹힌 detailColumns 로 한다 — 정적 메타를 넘기면 SEGMENT1~9 가
    // inputTpCd='O' + 라벨 `*` 없음이라 필수검증이 통째로 무발동된다.
    saveWithValidation(rows.map(sanitizeDetailRow), detailColumns, payload => {
      // 모집단은 하단 그리드에 실린 전 행(detailRows). sanitizeDetailRow 가 만든 복사본도
      // 11키 값은 원본과 같아 키 카운트 비교가 그대로 성립한다(saveMaster 주석 참조).
      if (findDuplicateRow(payload, detailRows)) return alertDuplicate();
      // SP 가 비정수·범위밖 DISPLAY_SEQ 에 ORA-20002 를 던진다 — 원문 노출 전에 FE 가 막는다.
      if (payload.some(row => !isValidDisplaySeq(row.DISPLAY_SEQ))) {
        void setAlert({
          type: 'alert',
          content: t(MSG.INTEGER_ONLY, '_Only integer values can be entered!'),
        });
        return;
      }
      savedCountRef.current = payload.length;
      mutateDetail(payload);
    });
  };

  const handleSave = () => {
    // dirty 는 react-query 데이터가 아니라 그리드 소스에서 읽는다 — GridAction.addRow 는
    // sourceCollection 에 splice 만 하고 React state 를 건드리지 않아, 응답 데이터로 읽으면
    // 조회 전에 넣은 신규행이 통째로 빠진다(메모리 datagrid-save-read-from-grid-source).
    const masterDirty = GridUtils.getChangedRows(masterGridRef.current);
    const detailDirty = GridUtils.getChangedRows(detailGridRef.current);

    // 변경 0건은 "읽고 넘어가야 하는 실패"가 아니라 정상 조작이라 modal 이 아니라 toast 다
    // (메모리 datagrid-nochange-save-toast-standard). 공용 훅의 빈배열 reject 에 기대지 않는다.
    if (masterDirty.length === 0 && detailDirty.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGES, '_No changes to save.') });
      return;
    }

    const { target, otherHasChanges } = pickSaveTarget(
      masterDirty.length,
      detailDirty.length,
      activeGrid
    );
    const run = () => (target === 'sub' ? saveDetail(detailDirty) : saveMaster(masterDirty));

    if (!otherHasChanges) return run();

    void (async () => {
      // 한 번에 한 영역만 저장된다(저장 SP 가 시트별로 갈린다) — 남는 쪽이 있음을 먼저 알린다.
      // 전용 MSG 미등록이라 기존 MSG01059 를 재사용한다(신규 채번 요청 대상).
      const proceed = await setAlert({
        type: 'confirm',
        content: t(MSG.UNSAVED_DATA, '_There are unsaved data.'),
      });
      if (proceed) run();
    })();
  };

  /**
   * 편집계 버튼(Insert/Delete/Save)은 버튼권한 + 편집권한(canEdit) 둘 다 있어야 노출한다.
   * NO-OP 무동작 함수가 필요한 버튼은 0건이다 — AS-IS override 5종이 전부 실동작이고,
   * Edit 만 버튼으로 내보내지 않는다(decisions.md §2). hotkeyConfig.edit 은 Hotkeys enum 에
   * 없는 사문 키라 쓰지 않는다. Excel 은 SubTitle 공용 기본을 그대로 둔다(AS-IS 도 공용 제공).
   */
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    insert: canEdit && hasButton('INSERT') ? handleInsert : false,
    delete: canEdit && hasButton('DELETE') ? handleDelete : false,
    save: canEdit && hasButton('SAVE') ? handleSave : false,
    manual: false,
    upload: false,
  };

  // 건수는 영역별 제목 줄에 따로 표시한다 — 상단 툴바 줄이 곧 Lookup Type 제목 줄이라
  // 포커스에 따라 숫자가 바뀌면 제목과 어긋난다. 하단은 Plan Group 필터 "후" 행 수다.
  const masterCount = masterRows.length;
  const detailCount = detailRows.length;

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <ConstraintMgmtForm onSearch={handleSearch} />
      <SubTitle
        menuId={MENU_ID}
        title={t(LBL.LOOKUP_TYPE, '_Lookup Type')}
        depth='h4'
        grid={activeGrid === 'sub' ? detailGridRef : masterGridRef}
        gridFilter={activeGrid === 'sub' ? detailGridFilterRef : masterGridFilterRef}
        countGrid={masterGridRef}
        dataCount={masterCount}
        excelFileName='ConstraintMgmt'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      {/* AS-IS SplitContainer 는 Orientation=Horizontal = 상/하 분할이다 — 이름대로 'horizontal'
          을 주면 좌우로 갈라진다. 406/658 = 61.7% 라 62:38 로 둔다. */}
      <PanelGroup className={styles.tableWrapper} orientation='vertical'>
        <Panel defaultSize={62} minSize={20}>
          <ConstraintMgmtMasterGrid
            gridRef={masterGridRef}
            gridFilterRef={masterGridFilterRef}
            editTrackerRef={masterEditTrackerRef}
            data={masterRows}
            canEdit={canEdit}
          />
        </Panel>
        <PanelSeparator className={styles.splitBar} />
        <Panel defaultSize={38} minSize={15}>
          <div className={styles.innerModule}>
            <TitleArea
              isSubTitle
              title={t(LBL.LOOKUP_VALUES, '_Lookup Values')}
              depth='h4'
              totalCases={detailCount === 0 ? undefined : detailCount}
            />
            <ConstraintMgmtDetailGrid
              gridRef={detailGridRef}
              gridFilterRef={detailGridFilterRef}
              editTrackerRef={detailEditTrackerRef}
              data={detailRows}
              staticColumns={detailColumns}
              canEdit={canEdit}
            />
          </div>
        </Panel>
      </PanelGroup>
    </>
  );
};
