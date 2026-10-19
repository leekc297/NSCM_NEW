import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { ItemByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabLookupQueries, useTabProcQuery } from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { IntegrationPsiForm } from './components/IntegrationPsiForm';
import { IntegrationPsiGrid } from './components/IntegrationPsiGrid';
import {
  LINE_ID_EMPTY,
  MEASURE,
  MENU_ID,
  MSG,
  MULTI_CHILD_ITEM_LOOKUP,
  SHEETS,
} from './integration-psi.constants';
import type { MainRow, SaveMode } from './integration-psi.types';
import { useIntegrationPsiStore } from './useIntegrationPsiStore';
import { callSaveIntegrationPsi } from './utils/integrationPsiApi';
import { fixedBindingSet } from './utils/integrationPsiColumns';
import type { AuthContext } from './utils/integrationPsiEditLock';
import {
  buildAdminPayload,
  buildGeneralPayload,
  unfoldSaveCells,
} from './utils/integrationPsiSave';

// 신규행 SEQ_FLAG 파생 (design 03 §3-Value V2 cs:1002-1052): 앵커행 SEQ_FLAG 첫 글자 + "50".
//   앵커가 없거나 SEQ_FLAG 공백이면 파생 불가 → 빈값(사용자 입력/저장검증에 위임).
const seqFlagForInsert = (anchor: Record<string, unknown> | undefined): string => {
  const seq = anchor && typeof anchor.SEQ_FLAG === 'string' ? anchor.SEQ_FLAG : '';
  return seq ? `${seq[0]}50` : '';
};

// 신규행 중복 판정 (design 03 §5 MSG00260) — created 행과 식별키가 같은 다른 행이 그리드에 있으면 true.
//   식별키 = SAVE 배열 식별컬럼(§4-저장). 확인필요: AS-IS 중복 키 조합 미열거 → 보수적으로 전 식별컬럼 일치.
const INSERT_KEY_COLS = [
  'DIVISION_ID',
  'COMPANY_ID',
  'PLANT_ID',
  'OPERATION_GROUP',
  'MEASURE',
  'CELL_ITEM_ID',
  'ITEM_ID',
  'TO_SITE',
  'TO_PRODUCT',
  'LINE_ID',
  'SEQ_FLAG',
] as const;
const sVal = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
const isDuplicateInsertRow = (grid: FlexGrid, created: Record<string, unknown>): boolean => {
  const keyOf = (r: Record<string, unknown>): string =>
    INSERT_KEY_COLS.map(c => sVal(r[c])).join('');
  const target = keyOf(created);
  const src = (grid.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];
  return src.some(r => r !== created && keyOf(r) === target);
};

// AS-IS GSCM.SCP.Forms.UIL Analysis/SCP0111_IntegrationPSI — 조회조건 패널(pnlCondition) + 단일 PSI
//   그리드(spdMain) + 서버측 동적 PIVOT. 설계: .atlas/gscm-design/SCP0111/design/00~03(DB 실측 PASS).
//   레이아웃/버튼 판정: design/01_layout.md §2(R1~R14)·§2.1. 상세 매핑: __asis-mapping__.md(후속).
//   버튼 판정(design 01 §2.1): FindButton/SaveButton/InsertButton/EditButton 실동작, DeleteButton NO-OP.
//     - search = handleSearch(조회는 무해 → 항상 허용)
//     - save   = hasButton('SAVE') ? handleSave : false (일반/ADMIN 저장 분기 — Task#4)
//     - insert = hasButton('SAVE') ? handleInsert : false (신규행 V1/V2 — Task#3)
//     - delete = () => undefined (NO-OP — AS-IS DeleteButton 본문 공백 cs:536-539. false/키생략 금지)
//   메뉴/버튼/컬럼 메타는 SCM_ADM_MNU_M 0건(design 00 실측) → 05_register.sql 신규 등록(Task#5).
export const IntegrationPsi = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker>();

  // 편집모드 토글 — AS-IS EditButton(SwitchLock). 편집모드 진입 시에만 그리드 셀 잠금이 measure/seqFlag/
  //   division/권한 조합으로 해제된다(design 03 §3-Lock L1). editMode 값을 그리드로 전달해 셀 잠금·
  //   편집모드 전용 컬럼(SEQ_FLAG/MEASURE/PLANT_ID/TO_SITE) 노출을 제어한다.
  const [editMode, setEditMode] = useState(false);

  // SCM0002 ItemByDivisionModal — btnNickName/btnItemId 공용 팝업. 반환 반영 대상 필드로 target 구분(design 02 §4.6).
  //   btnCellItem_Id 는 AS-IS NO-OP(§4.6) — 팝업 미배선(Form 텍스트 입력만).
  const [itemModalTarget, setItemModalTarget] = useState<'nickName' | 'itemId' | null>(null);

  const sc = useIntegrationPsiStore(s => s.searchCondition);
  const setSearchCondition = useIntegrationPsiStore(s => s.setSearchCondition);
  const filters = useIntegrationPsiStore(s => s.filters);
  const setFilter = useIntegrationPsiStore(s => s.setFilter);
  const openSearchArea = useIntegrationPsiStore(s => s.openSearchArea);
  const setOpenSearchArea = useIntegrationPsiStore(s => s.setOpenSearchArea);
  const fetchStaticColumns = useIntegrationPsiStore(s => s.fetchStaticColumns);
  const fetchStaticMeasures = useIntegrationPsiStore(s => s.fetchStaticMeasures);
  const initialized = useIntegrationPsiStore(s => s.initialized);
  // 고정 24열 admin 메타(SCM_MST_SHEET_COLUMNS 'Integration PSI') — 그리드 staticColumns 원천.
  const staticColumns = useIntegrationPsiStore(s => s.staticColumns[SHEETS.MAIN]);

  const { data } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });

  // GET 응답 grid PIVOT 데이터 = O_RC(표준 key 'o_rc1'). O_RESULT_CURSOR(상태봉투)는 무시(design 03 §2-C).
  const rows = useMemo<MainRow[]>(() => (data as { o_rc1?: MainRow[] })?.o_rc1 ?? [], [data]);

  // 권한(ADMIN / SCM PI Admin / SCP Planner) = AS-IS NowGroupID 3분기. TO-BE 는 USER_ID 기준이어야 하며
  //   (hook#128 auth-by-userid-not-groupid), session.groupId 는 유령 필드라 참조 금지(sales-plan 정본).
  //   확인필요: SCP0111 전용 권한 CMBO(sales-plan 의 'SalesPlanUserAuthGroup' 등가)가 미정·미등록이다.
  //   원천 콤보가 확정될 때까지 안전 기본값(전부 false = BOH 편집 잠금·정보열 잠금 유지)로 주입한다.
  //   BOH_QTY 편집(L8/L12/L17)·ADMIN 정보열(L3/L5/L20)은 이 auth 확정 후 활성화된다(design 03 §3 / 05_register).
  const auth = useMemo<AuthContext>(
    () => ({ isAdmin: false, isPiAdmin: false, isPlanner: false }),
    []
  );

  // MULTI_CHILD_ITEM lookup NAME 목록(design 03 §1-L / L7 모듈 반제품 편집 예외).
  //   AS-IS 는 Data.Common(LookupCommon,"MULTI_CHILD_ITEM") 후 ITEM_ID == Rows[i]["NAME"] 대조(cs:622-643).
  //   Data.Common 의 NAME 컬럼 = SCM_ADM_LOOKUP_MASTER_DETAIL.SEGMENT2 → SEGMENT2 값으로 Set 구성.
  const [multiChildLookup] = useTabLookupQueries({ filters: [MULTI_CHILD_ITEM_LOOKUP] });
  const multiChildItems = useMemo<ReadonlySet<string>>(
    () =>
      new Set(
        (multiChildLookup ?? [])
          .map(r => (typeof r.SEGMENT2 === 'string' ? r.SEGMENT2.trim() : ''))
          .filter(Boolean)
      ),
    [multiChildLookup]
  );

  // admin 동적 메타(SCM_MST_SHEET_COLUMNS 24열 + SCM_MST_SHEET_MEASURE 7행) — mount 1회 fetch.
  //   Division 변경/Search 시 refetch 는 Task#2(cascade)·handleSearch 에서 배선한다(division body 전송).
  useEffect(() => {
    if (!initialized) {
      void fetchStaticColumns();
      void fetchStaticMeasures();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 조회 — 필수값 가드(Division/Plan-date, design 01 R9) + 조회기간(from<=to)은 Task#2 검증으로 확장한다.
  //   조회 시 컬럼/measure 메타 refetch(admin 동적 속성관리 — mount + Search 시마다).
  const handleSearch = () => {
    setFilter();
    void fetchStaticColumns();
    void fetchStaticMeasures();
  };

  // 조회기간 YYYYMM 목록 — 그리드에 실제 렌더된 pivot 컬럼(6자리 숫자 바인딩)에서 도출한다.
  //   신규행(I) 삽입 시 저장 대상 월 집합. 날짜 산술 대신 렌더된 컬럼셋을 원천으로 삼아 GET 반환월과 정합.
  const gridPeriodMonths = (): string[] => {
    const g = gridRef.current;
    if (!g) return [];
    const out: string[] = [];
    for (let i = 0; i < g.columns.length; i++) {
      const b = g.columns[i].binding ?? '';
      if (/^\d{6}$/.test(b)) out.push(b);
    }
    return out;
  };

  // 저장 — 변경셀(수정 M / 신규 I) unfold → 19키 '^'delim payload → call-proc 직접 호출.
  //   권한(ADMIN)이면 ADMIN 저장(+p_boh_qty), 아니면 일반 저장. 검증: OPERATION_GROUP lookup 부재
  //   (MSG00001) / 신규행 Line 미지정("-") 저장 확인(MSG00453). false-success 는 API 헬퍼가 차단.
  const handleSave = async () => {
    const g = gridRef.current;
    if (!g) return;
    g.finishEditing();
    const source = (g.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];

    const { cells, opGroupLookupMissing, hasEmptyLineInsert } = unfoldSaveCells({
      source,
      tracker: editTrackerRef.current,
      fixedBindings: fixedBindingSet(staticColumns),
      periodMonths: gridPeriodMonths(),
    });

    // OPERATION_GROUP NAME->CODE 역변환 실패 = 저장 차단(추측 코드 저장 금지, design 03 §4 cs:1207-1219).
    if (opGroupLookupMissing) {
      void setAlert({ type: 'alert', content: t(MSG.OP_GROUP_LOOKUP_MISSING, 'OPERATION_GROUP') });
      return;
    }
    if (cells.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGES, '_No changes.') });
      return;
    }
    // 신규행 Line 미지정("-") — AS-IS 는 저장 전 확인 후 진행(MSG00453 confirm). 취소 시 저장 중단.
    if (hasEmptyLineInsert) {
      const proceed = await setAlert({
        type: 'confirm',
        content: t(MSG.LINE_REQUIRED, '_Line is not specified. Continue?'),
      });
      if (!proceed) return;
    }

    const mode: SaveMode = auth.isAdmin ? 'ADMIN' : 'GENERAL';
    const planStart = sc.planStartYyyymmdd;
    const userId = useSessionStore.getState().session.userId ?? '';
    const payload =
      mode === 'ADMIN'
        ? buildAdminPayload(cells, planStart, userId)
        : buildGeneralPayload(cells, planStart, userId);
    if (payload === null) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGES, '_No changes.') });
      return;
    }

    const res = await callSaveIntegrationPsi(mode, payload);
    if (res.ok) {
      setToast({ type: 'success', message: t(MSG.SAVE_SUCCESS, '_Saved.') });
      setFilter(); // 저장 후 FindData_Main 재조회 (design 03 §4 — filters 재생성으로 refetch)
      return;
    }
    void setAlert({
      type: 'alert',
      content: res.msgCode
        ? [t(res.msgCode, res.msgCode), res.addMessage].filter(Boolean).join('\n')
        : (res.addMessage ?? t(MSG.SAVE_FAIL, '_Save failed.')),
    });
  };

  // 신규행 삽입 (design 03 §3-Value V1/V2). 편집모드에서만(AS-IS InsertButton IsLock 가드).
  //   V1(ADMIN, cs:967-976): 빈 신규행 + DIVISION_ID=조회 division 만 세팅(DIVISION_ID 셀잠금은 그리드 lockCtx).
  //   V2(일반, cs:986-1052): 현재행(_currRowIdx) 22필드 복사 + 고정값 — MEASURE_LABEL="Prod Plan"/
  //     MEASURE="PROD_PLAN"/LINE_ID="-"(sentinel)/BOH_QTY=0/SEQ_FLAG=현재행 seq[0]+"50". addRow 가 앵커행을
  //     복사하므로(placement 'below'=_currRowIdx+1) 고정값만 override 로 넘긴다.
  //   중복검사(MSG00260): 삽입 후 식별키(division/company/plant/operationGroup/measure/cellItem/item/toSite/
  //     toProduct/lineId/seqFlag) 동일 행이 이미 있으면 삽입 취소 + 경고(신규행 자기 자신 제외).
  const handleInsert = () => {
    const grid = gridRef.current;
    if (!grid) return;
    if (!editMode) {
      setToast({ type: 'error', message: t(MSG.NO_ROW_SELECTED, '_Enter edit mode first.') });
      return;
    }

    // 앵커행(현재행) — V2 는 이 행을 복사하고 SEQ_FLAG 를 파생한다. 없으면 V1(빈 신규행).
    const anchor = grid.collectionView?.currentItem as Record<string, unknown> | undefined;

    const overrides: Record<string, unknown> = auth.isAdmin
      ? { CRUD_TYPE: 'I', DIVISION_ID: sc.divisionId } // V1 — DIVISION_ID 만, 나머지 공백
      : {
          // V2 — 앵커행 복사 + PROD_PLAN 신규 고정값. LINE_ID sentinel("-") 저장 시 MSG00453 확인.
          CRUD_TYPE: 'I',
          MEASURE_LABEL: 'Prod Plan',
          MEASURE: MEASURE.PROD_PLAN,
          LINE_ID: LINE_ID_EMPTY,
          BOH_QTY: 0,
          SEQ_FLAG: seqFlagForInsert(anchor),
        };

    const created = GridAction.addRow(
      grid,
      overrides as unknown as Partial<MainRow>,
      'below'
    ) as unknown as Record<string, unknown> | undefined;
    if (!created) return;

    // 중복검사 — 삽입행과 식별키가 같은 다른 행이 있으면 취소(design 03 §5 MSG00260).
    //   확인필요: AS-IS 중복 키 필드 조합이 design 에 미열거 → SAVE 식별키(§4-저장 배열컬럼)로 보수적 판정.
    if (isDuplicateInsertRow(grid, created)) {
      GridAction.removeRow(grid, true);
      grid.invalidate();
      void setAlert({ type: 'alert', content: t(MSG.DUPLICATE_ROW, '_Duplicate row.') });
    }
  };

  // AS-IS EditButton — SwitchLock 편집모드 토글. 권한 3분기(ADMIN/SCM PI Admin/SCP Planner)별 셀 잠금은
  //   Task#3 에서 USER_ID 기준 재현(design 01 R12 / auth-by-userid-not-groupid). 스켈레톤은 상태 토글만.
  const handleEdit = () => {
    setEditMode(prev => !prev);
  };

  const hotkeyConfig: HotkeyConfig = {
    // 조회는 무해하므로 항상 허용(design 01 R13).
    search: handleSearch,
    // 신규/저장 = 화면 update 권한(SAVE)으로 게이트(design 01 R11/R14).
    insert: hasButton('SAVE') ? handleInsert : false,
    save: hasButton('SAVE') ? handleSave : false,
    // DeleteButton NO-OP — AS-IS 본문 공백(design 01 R10). false(숨김)/키생략(공용 removeRow 부활) 금지.
    delete: () => undefined,
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
      {/* 영역2 조회조건 Form(Division/PlanDate/PlanType/기간 + cascade + 팝업) — design 02 §5.1. */}
      <IntegrationPsiForm
        onSearch={handleSearch}
        onNickNameSearch={() => setItemModalTarget('nickName')}
        onItemSearch={() => setItemModalTarget('itemId')}
      />

      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='IntegrationPsi'
        useHotkey={true}
        hotkeyConfig={hotkeyConfig}
        searchParam={sc}
        customButtons={[
          // Edit(EditButton SwitchLock) — 편집모드 토글(design 01 R12). Hotkeys enum 에 edit 값이 없어
          //   customButtons 로 노출한다(shipment-working-day-osp 선례). hasButton 조건부(하드코딩 금지).
          ...(hasButton('EDIT')
            ? [
                {
                  label: t('LBL00414', { defaultValue: 'Edit' }),
                  title: t('LBL00414', { defaultValue: 'Edit' }),
                  action: handleEdit,
                },
              ]
            : []),
        ]}
      />

      {/* 영역3 그리드 — 고정 24열(admin 메타) + 서버측 동적 YYYYMM PIVOT + 편집잠금 L1~L23 + 조건색 C1/C2 +
          LINE_ID 신규행 셀콤보(§2-D). editMode/division/auth 조합으로 셀 단위 잠금을 beginningEdit 에서 재현.
          essPackLineRows(분기 A ESS Pack Line): 원천이 CMBO 아닌 SP(P_SCP0111_GET_ESS_PACK_LINE, IN 0개 +
          O_RC/O_RESULT_CURSOR)라 콤보 훅으로 못 붙는다. NSCM proc 호출은 {menuId}/{sheet}/{action}/call-proc
          3-키 라우팅이고 BE 가 그 3-키로 SCM_ADM_PROC_M/API 매핑을 찾아 SP 를 실행하는데, 이 SP 는 (sheet,action)
          매핑에 미등록이다(05_register.sql: SEARCH/SAVE/SAVEDETAIL 3종만 API 배선, GET_ESS_PACK_LINE 은 미배선).
          즉 FE 단독 배선 불가 — API_M/버튼(별도 action)/그룹권한 DB 등록(메타소유자 채번·배포)이 선행돼야 한다.
          확정 전까지 빈 배열 유지(분기 A 후보 0건, design 03 §6 확인필요). 분기 B(LineByOperationPlantId_SCP_ALL)는
          그리드 내부에서 직접 로드한다. */}
      <IntegrationPsiGrid
        rows={rows}
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        adminColumns={staticColumns}
        division={sc.divisionId}
        editMode={editMode}
        auth={auth}
        multiChildItems={multiChildItems}
        essPackLineRows={[]}
        onDerivMismatch={() =>
          setToast({
            type: 'warning',
            message: t(MSG.DERIV_MISMATCH, '수량 불일치'),
          })
        }
        onFocus={() => undefined}
      />

      {/* SCM0002 Item-by-Division 공용 팝업 — btnNickName/btnItemId 반환값을 target 필드에 반영(design 02 §4.6).
          division 파라미터는 조회조건 Division 을 넘긴다(AS-IS cboDivision.ControlValues). */}
      <ItemByDivisionModal
        open={itemModalTarget !== null}
        modalClose={() => setItemModalTarget(null)}
        // btnNickName 은 반환 NickName(5번째 인자, AS-IS popItem.NickName → txtNickName), btnItemId 는
        //   반환 ItemID(1번째 인자, popItem.ItemID → txtItemId) 를 반영한다(design 02 §4.6).
        setSelectedValue={(items, _itemName, _itemClassName, _itemType, nickName) =>
          setSearchCondition(
            itemModalTarget === 'nickName' ? { nickName: nickName ?? '' } : { itemId: items }
          )
        }
        preSearchParams={{
          divisionId: sc.divisionId,
          itemId: itemModalTarget === 'nickName' ? sc.nickName : sc.itemId,
        }}
        callFromCell={false}
      />
    </>
  );
};
