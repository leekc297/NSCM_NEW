import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { ComboResponse, HotkeyConfig, PageProps } from '@foundation/models';
import { useMutation } from '@foundation/query-client';
import type { EditTracker } from '@foundation/utils';
import { GridAction, GridUtils } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import {
  useTabBtnPermissions,
  useTabComboQueries,
  useTabLookupQueries,
  useTabProcQuery,
} from '@shared/hooks';
import {
  confirmIfDirtyKey,
  tabDirtyKey,
  useMessageStore,
  useSessionStore,
} from '@shared/stores';

import { IntegrationPsiForm } from './components/IntegrationPsiForm';
import { IntegrationPsiGrid } from './components/IntegrationPsiGrid';
import {
  ADMIN_GROUP_NAME,
  COMBO,
  DIVISION_ESS,
  LINE_ID_EMPTY,
  MEASURE,
  MENU_ID,
  MSG,
  MULTI_CHILD_ITEM_LOOKUP,
  PI_ADMIN_GROUP_NAME,
  PLANNER_GROUP_NAME,
  REQUIRED_SAVE_FIELDS,
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

// AS-IS InsertRow V2(cs:1002~1050)가 **현재 선택행에서 복사**하는 식별필드 17건. 컬럼명은
//   SCM_MST_SHEET_COLUMNS('Integration PSI') 24행 실측과 1:1 대응한다(2026-10-13 ora.py).
//   주의(이 화면의 기존 주석이 틀렸다): `GridAction.addRow`/`addRowSet` 은 **앵커행을 복사하지 않는다**.
//   `{ ...defaultCopyProps, CRUD_TYPE: 'I' }` 로 넘긴 값만 넣는다(gridAction.ts addRowSet) —
//   파라미터 이름이 defaultCopyProps 라 복사처럼 읽히지만 앵커는 삽입 "위치" 계산에만 쓰인다.
//   그래서 복사가 필요한 필드는 여기서 명시적으로 긁어 overrides 에 실어야 한다.
//   (AS-IS 가 복사하지 않는 MEASURE_COLOR/MEASURE_ORDER_NO 는 제외 — 고정값 5건은 handleInsert 참고)
const INSERT_COPY_COLS = [
  'PLAN_TYPE',
  'DIVISION_ID',
  'OPERATION_GROUP',
  'CELL_MODEL_NICK_NAME',
  'CELL_ITEM_ID',
  'NICK_NAME',
  'ITEM_ID',
  'CELL_CF',
  'COMPANY_ID',
  'PLANT_ID',
  'VALUE_TYPE',
  'TO_PRODUCT',
  'TO_SITE',
  'INCOTERMS',
  'UOM',
  // PLANT_ID/TO_SITE 는 코드, *_DESCRIPTION 은 화면 표시용(AS-IS 2025-02-03 변경 cs:1023/1048). 둘 다 복사.
  'PLANT_ID_DESCRIPTION',
  'TO_SITE_DESCRIPTION',
] as const;

// 신규행 중복 판정 (MSG00260) — AS-IS 는 **저장 버튼을 눌렀을 때** 검사한다(cs:1473~1497).
//   `dtPSI = DBUtils.Filter(dtPSIAll, sb, true); if (dtPSI.Rows.Count > 0) { MSG00260; return; }`
//   - 비교 대상: `dtPSIAll` = **조회결과(이미 저장된 행)**. 신규행끼리 비교하는 것이 아니다.
//   - 비교 컬럼 13개(cs:1476~1488). **SEQ_FLAG 는 비교에 쓰지 않는다** — cs:1462 에서 값은 읽지만
//     필터 문자열에 넣지 않는다. 반대로 PLAN_TYPE·VALUE_TYPE·INCOTERMS 는 포함된다.
//   - 중복이면 **저장 전체를 중단**한다(행을 지우지 않는다).
//
//   종전 TO-BE 는 (1) Insert 시점에 검사하고 (2) 걸리면 **방금 넣은 행을 removeRow 로 지웠다**.
//   그래서 Insert 를 눌러도 행이 곧바로 사라져 "추가가 안 된다"로 보이고, 이어서 Save 를 누르면
//   변경행이 없어 MSG00004("변경 없음")만 떴다 — SP 호출 로그에도 흔적이 남지 않는다
//   (사용자 신고 2026-10-13). 비교 컬럼도 SEQ_FLAG 포함 / PLAN_TYPE 등 누락으로 AS-IS 와 달랐다.
const INSERT_DUP_COLS = [
  'PLAN_TYPE',
  'DIVISION_ID',
  'COMPANY_ID',
  'PLANT_ID',
  'OPERATION_GROUP',
  'CELL_ITEM_ID',
  'ITEM_ID',
  'MEASURE',
  'LINE_ID',
  'VALUE_TYPE',
  'TO_PRODUCT',
  'TO_SITE',
  'INCOTERMS',
] as const;
const sVal = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
// 구분자를 넣어 이어붙인다 — 종전처럼 빈 문자열로 이으면 값 경계가 밀려 오탐이 난다.
const dupKeyOf = (r: Record<string, unknown>): string =>
  INSERT_DUP_COLS.map(c => sVal(r[c])).join('|');
const hasDuplicateInsertRow = (source: Record<string, unknown>[]): boolean => {
  // 조회결과(저장된 행)만 모아 키 집합을 만든다 — AS-IS dtPSIAll 과 같은 범위.
  const saved = new Set(source.filter(r => sVal(r.CRUD_TYPE) !== 'I').map(dupKeyOf));
  return source.some(r => sVal(r.CRUD_TYPE) === 'I' && saved.has(dupKeyOf(r)));
};

// 그리드 gotFocus 용 no-op — 렌더마다 새 화살표(`() => undefined`)를 내리면 그 참조가 gotFocus prop 으로
//   바뀌어 memo(DataGrid) 가 매 렌더 재렌더된다. 하는 일이 없으므로 모듈 상수로 고정해 참조를 안정화한다.
const NOOP = (): void => undefined;

// AS-IS GSCM.SCP.Forms.UIL Analysis/SCP0111_IntegrationPSI — 조회조건 패널(pnlCondition) + 단일 PSI
//   그리드(spdMain) + 서버측 동적 PIVOT. 설계: .atlas/gscm-design/SCP0111/design/00~03(DB 실측 PASS).
//   레이아웃/버튼 판정: design/01_layout.md §2(R1~R14)·§2.1. 상세 매핑: __asis-mapping__.md(후속).
//   버튼 판정(design 01 §2.1): FindButton/SaveButton/InsertButton 실동작, DeleteButton 은 AS-IS NO-OP.
//     AS-IS EditButton(SwitchLock 편집모드 토글)은 TO-BE 에서 제거 — 편집모드 없이 권한으로 셀 입력 결정.
//     - search = handleSearch(조회는 무해 → 항상 허용)
//     - save   = hasButton('SAVE') ? handleSave : false (일반/ADMIN 저장 분기 — Task#4)
//     - insert = hasButton('SAVE') ? handleInsert : false (신규행 V1/V2 — Task#3)
//     - delete = hasButton('SAVE') ? handleDelete : false — AS-IS 는 본문 공백(cs:536~539)이라 NO-OP 였으나
//       사용자 지시(2026-10-13)로 **미저장 신규행만 삭제**하도록 바꿨다(handleDelete 주석에 근거).
//   메뉴/버튼/컬럼 메타는 SCM_ADM_MNU_M 0건(design 00 실측) → 05_register.sql 신규 등록(Task#5).
export const IntegrationPsi = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;
  const setAlert = useMessageStore.getState().setAlert;
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const gridRef = useRef<FlexGrid>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker>();

  // TO-BE 는 AS-IS EditButton(SwitchLock) 편집모드를 두지 않는다 — 권한(auth)으로 셀 입력 여부를
  //   바로 결정한다. 셀 잠금은 measure/seqFlag/division/권한 조합으로 그리드 beginningEdit 에서 판정하고,
  //   편집 권한 전용 컬럼(SEQ_FLAG/MEASURE/PLANT_ID/TO_SITE) 노출도 권한 기준으로 결정한다(design 03 §3-Lock).

  // Model/Nickname 단일 팝업 — 입력칸 통합(2026-10-12)으로 target 구분이 사라져 boolean 하나로 충분하다.
  //   btnCellItem_Id 는 AS-IS NO-OP(§4.6) — 팝업 미배선(Form 텍스트 입력만).
  const [openItemModal, setOpenItemModal] = useState(false);

  const sc = useIntegrationPsiStore(s => s.searchCondition);
  const setSearchCondition = useIntegrationPsiStore(s => s.setSearchCondition);
  const filters = useIntegrationPsiStore(s => s.filters);
  const setFilter = useIntegrationPsiStore(s => s.setFilter);
  const openSearchArea = useIntegrationPsiStore(s => s.openSearchArea);
  const setOpenSearchArea = useIntegrationPsiStore(s => s.setOpenSearchArea);
  const fetchStaticColumns = useIntegrationPsiStore(s => s.fetchStaticColumns);
  const fetchStaticMeasures = useIntegrationPsiStore(s => s.fetchStaticMeasures);
  const restoreSearchConditions = useIntegrationPsiStore(s => s.restoreSearchConditions);
  const resetConditionValues = useIntegrationPsiStore(s => s.resetConditionValues);
  const initialized = useIntegrationPsiStore(s => s.initialized);
  // 고정 24열 admin 메타(SCM_MST_SHEET_COLUMNS 'Integration PSI') — 그리드 staticColumns 원천.
  const staticColumns = useIntegrationPsiStore(s => s.staticColumns[SHEETS.MAIN]);
  // SCM_MST_SHEET_MEASURE 7행 — MEASURE_LABEL 셀콤보 원천(label↔code). 신규행 MEASURE 선택용(Wave1).
  const staticMeasures = useIntegrationPsiStore(s => s.staticMeasures);

  const { data } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters: filters[SHEETS.MAIN],
    enabled: !!filters[SHEETS.MAIN],
  });

  // GET 응답 grid PIVOT 데이터 = O_RC(표준 key 'o_rc1'). O_RESULT_CURSOR(상태봉투)는 무시(design 03 §2-C).
  const rows = useMemo<MainRow[]>(() => (data as { o_rc1?: MainRow[] })?.o_rc1 ?? [], [data]);

  // ESS(div82) 신규행 LINE_ID 셀콤보 분기 A 원천 — P_SCP0111_GET_ESS_PACK_LINE(IN 0개) call-proc 조회.
  //   SP·API·버튼·그룹권한·PROC 매핑이 전부 DB 반영 실측(2026-11-17 ora.py): SCM_ADM_API_M/MNU_BTN_MPG_M
  //   essPackLine/SEARCH(USE_YN='Y'), SCM_ADM_PROC_M o_rc1 CURSOR. 라우트 'SCP0111/essPackLine/SEARCH/call-proc'.
  //   반환 o_rc1 = {DIVISION_ID, SCM_SITE_ID, SITE_DESCRIPTION, COMPANY_ID, CODE(=LINE_ID), NAME(=LINE_NAME),
  //   OPERATION_ID}(div82·VALID_YN='Y' 고정). 콤보는 이 풀을 **현재행 COMPANY_ID** 로 필터한다(분기 A).
  //   division 82 일 때만 조회한다 — 그 외 division 은 분기 B(LineByOperationPlantId_SCP_ALL)만 쓰므로 불필요.
  const { data: essPackLineData } = useTabProcQuery<MENU_ID, 'essPackLine'>({
    menuId: MENU_ID,
    sheetName: 'essPackLine',
    tabId,
    enabled: sc.divisionId === DIVISION_ESS,
  });
  const essPackLineRows = useMemo<ComboResponse[]>(
    () => (essPackLineData as { o_rc1?: ComboResponse[] })?.o_rc1 ?? [],
    [essPackLineData]
  );

  // 권한(ADMIN / SCM PI Admin / SCP Planner) = AS-IS NowGroupID 3분기. TO-BE 는 USER_ID 기준이어야 하며
  //   (hook#128 auth-by-userid-not-groupid), session.groupId(단일 유령 필드) 는 참조 금지. 대신 session.groups
  //   (USER_GR_NM 배열, nscm-be User.xml retrieveUserGroups)로 보유 그룹을 판정한다 — plan-control /
  //   sales-site-project-model 등 전환 선례와 동일 규약(그룹 "이름"으로 비교, ID 아님).
  //   세 그룹명은 DB 실측(SCM_ADM_USER_GR_M, 2026-11-16): ADMIN→'System Administrator', 나머지 둘은 ID==NM.
  //   - isAdmin  = NowGroupID=='ADMIN' 재현 → 신규행 Insert V1(빈행·DIVISION_ID만) + 전열/BOH 편집 + ADMIN 저장.
  //   - isPiAdmin/isPlanner = AS-IS BOH 편집 2-분기(cs:564-565)의 나머지 축 — INV(measureFlag=6) 행 BOH 편집만
  //     추가 허용한다. 관리컬럼 노출·ADMIN 저장·Insert V1 은 isAdmin 전용이다(AS-IS SetVisibleSheetColumns 가
  //     ADMIN 분기 cs:594 에서만 호출 / 저장·Insert 분기도 nowGroupID=='ADMIN' 단독 — hasEditAuth=isAdmin).
  const sessionGroups = useSessionStore(s => s.session.groups);
  // System Admin 권한 "보유" 여부 — 관리자편집 진입 자격. ADMIN 저장(P_SCP0111_SAVE_PSI_ADMIN)·관리컬럼은
  //   AS-IS NowGroupID=='ADMIN'(=USER_GR_NM 'System Administrator') 전용이라 이 세션 그룹에 묶인다.
  //   버튼 "노출"은 표준대로 hasButton('EDIT')가 게이트하고(아래 SubTitle, AUTH-01), 이 플래그는 토글이 실제
  //   관리자편집으로 전환되는지를 결정한다 — EDIT 권한은 ADMIN 그룹에만 부여되어 둘은 같은 그룹으로 정렬되나,
  //   안전을 위해 모드 활성(adminMode)도 이 자격과 AND 한다(오등록 시에도 잘못된 ADMIN 저장 방지).
  //   배경: AS-IS EditButton(편집모드 토글)을 TO-BE 가 제거하고 "권한=자동 관리자편집"으로 바꿨으나(이 파일 상단
  //   주석), 사용자 요청(2026-11-19)으로 admin 전용 편집모드 토글을 되살린다 — admin 도 기본은 일반편집.
  const isSystemAdmin = (sessionGroups ?? []).includes(ADMIN_GROUP_NAME);
  // Admin Edit 모드 활성 상태(기본 OFF). isSystemAdmin 이 아니면 토글이 노출되지 않아 항상 false 로 남는다.
  const [adminMode, setAdminMode] = useState(false);
  const auth = useMemo<AuthContext>(
    () => ({
      // auth.isAdmin = "지금 관리자편집 중"의 유효 플래그 — 권한 보유(isSystemAdmin) && 모드 활성(adminMode).
      //   editLock/Grid/handleSave/handleInsert 는 전부 이 플래그로 분기하므로, 둘을 AND 하면 기본 일반편집 /
      //   토글 시 관리자편집으로 하위 로직 전체가 자동 전환된다(하위 모듈 무수정).
      isAdmin: isSystemAdmin && adminMode,
      isPiAdmin: (sessionGroups ?? []).includes(PI_ADMIN_GROUP_NAME),
      isPlanner: (sessionGroups ?? []).includes(PLANNER_GROUP_NAME),
    }),
    [sessionGroups, isSystemAdmin, adminMode]
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
  //   F6 저장 조회조건 복원도 mount 1회(conditionsRestored 가드). 새로고침 시 새 store → 재복원(global-psi-elec 파리티).
  useEffect(() => {
    void restoreSearchConditions();
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

  // Reset Condition(F10) — 공용 SubTitle F10 은 2026-10-14 이후 서버 저장분만 초기화하고 화면 조회조건은
  //   건드리지 않는다(AS-IS 파리티). 사용자 지시(2026-10-19)로 이 화면은 화면 조회조건 값 초기화를 되살린다.
  //   서버 저장분 삭제(resetPersonalizedCondition) + 화면 값 초기화(resetConditionValues)를 함께 수행하되
  //   MSG00009 확인 → MSG00011 안내의 공용 F10 UX 를 유지한다. Division·그리드(filters)는 보존한다.
  const handleResetCondition = async () => {
    const ok = await setAlert({
      type: 'confirm',
      content: t('MSG00009', '_저장된 검색조건을 초기화 하겠습니까?'),
    });
    if (!ok) return;
    await GridAction.resetPersonalizedCondition(MENU_ID);
    resetConditionValues();
    void setAlert({ type: 'alert', content: t('MSG00011', '_검색조건이 초기화 되었습니다.') });
  };

  // Plan HORIZON_END — 신규행(I) 삽입 월 범위의 **상한**. AS-IS SetChangedPeriod(cs:267~278)가 읽는 값과 같고,
  //   저장 시 AS-IS 가 `Data.Common(CalendarMonth, plan_start월, _toDate월)`(cs:1510~1511)로 월 전체를 뽑는 근거다.
  //   `SCPPlanPeriod_SCP` 등록 SQL 실측: `SELECT HORIZON_START_DATE, HORIZON_END_DATE, PLAN_CYCLE, ...
  //    FROM SCM_MST_PLAN WHERE PLAN_NAME = @planName AND DIVISION_ID = @divisionId AND PLAN_CYCLE = 'WEEKLY'`
  //   → 파라미터 키는 `planName`/`divisionId` 와 정확히 같아야 치환된다(BE makeComboQuery 는 raw 치환).
  //   **저장 경로 전용**이다 — 화면 기간 입력은 표준 PeriodField mode='month'(월 피커)라 상한을 쓰지 않는다.
  //   종전에는 "렌더된 pivot 컬럼"(=화면 조회기간)을 삽입 월로 썼는데, 그러면 Plan 전체 개월수보다 좁아
  //   **행이 모자라게 등록된다**(실측: 20개월 Plan 에 6개월만 생성 — 사용자 신고 2026-10-13).
  const [planPeriodRows] = useTabComboQueries({
    filters: [
      {
        comboId: COMBO.SCP_PLAN_PERIOD,
        planName: sc.planStartYyyymmdd,
        divisionId: sc.divisionId,
      },
    ],
    enabled: !!sc.planStartYyyymmdd && !!sc.divisionId,
  });
  const horizonEndYyyymmdd = sVal(planPeriodRows?.[0]?.HORIZON_END_DATE);

  // 저장 SP 호출을 useMutation 으로 감싼다 — callSaveIntegrationPsi 는 '^'delim bulk payload 때문에
  //   raw apiClient.post 로 react-query 밖에서 호출되는데, 그러면 MDIContainer 의 useIsBusy([activeTabId])
  //   (=useIsMutating/useIsFetching) 공통 로딩 스피너(프로그래스)가 저장 중 뜨지 않는다. mutationKey 를
  //   [tabId,...] 로 두어 저장 트랜잭션 동안 전역 프로그래스가 표시되게 한다(ShipmentPlanFg/SCP0134 선례).
  //   성패 분기(토스트/알럿)는 호출부(handleSave)에서 SaveResult 로 종전과 동일하게 처리하므로 payload 계약·
  //   false-success 차단(integrationPsiApi) 은 불변이다. 저장은 비멱등이라 재시도 금지(retry:0).
  const { mutateAsync: saveIntegrationPsiAsync } = useMutation({
    mutationKey: [tabId, SHEETS.MAIN, 'SAVE'],
    retry: 0,
    mutationFn: (args: { mode: SaveMode; payload: Record<string, string> }) =>
      callSaveIntegrationPsi(args.mode, args.payload),
  });

  // 저장 — 변경셀(수정 M / 신규 I) unfold → 19키 '^'delim payload → call-proc 직접 호출.
  //   권한(ADMIN)이면 ADMIN 저장(+p_boh_qty), 아니면 일반 저장. 검증: OPERATION_GROUP lookup 부재
  //   (MSG00001) / 신규행 Line 미지정("-") 저장 확인(MSG00453). false-success 는 API 헬퍼가 차단.
  const handleSave = async () => {
    const g = gridRef.current;
    if (!g) return;
    g.finishEditing();
    const source = (g.collectionView?.sourceCollection ?? []) as Record<string, unknown>[];

    const { cells, opGroupLookupMissing, hasEmptyLineInsert, missingRequiredField } =
      unfoldSaveCells({
        source,
        tracker: editTrackerRef.current,
        fixedBindings: fixedBindingSet(staticColumns),
        planStartYyyymmdd: sc.planStartYyyymmdd,
        horizonEndYyyymmdd,
        // ADMIN 저장은 수정셀 modiQty 를 절대값으로 보낸다(일반은 가감값) — SP 비대칭 계약. unfoldSaveCells 주석 참고.
        isAdmin: auth.isAdmin,
      });

    // OPERATION_GROUP NAME->CODE 역변환 실패 = 저장 차단(추측 코드 저장 금지, design 03 §4 cs:1207-1219).
    //   값은 있으나 무효 → 유효값(Pack/Cell/Electrode)을 직접 안내한다(AS-IS 전용 리터럴 등가 roslyn L1217).
    if (opGroupLookupMissing) {
      void setAlert({
        type: 'alert',
        content: t(MSG.OP_GROUP_INVALID, 'Operation 은 Pack / Cell / Electrode 중 하나로 입력하세요.'),
      });
      return;
    }
    // 15필수 공백검증 (AS-IS roslyn L1237) — 어느 필드가 비었는지 이름으로 안내(MSG00429 "{0} 값은 필수 입력 항목").
    if (missingRequiredField) {
      const label =
        REQUIRED_SAVE_FIELDS.find(f => f.binding === missingRequiredField)?.label ??
        missingRequiredField;
      void setAlert({
        type: 'alert',
        content: t(MSG.REQUIRED_FIELD, '_{0} value is required.').replace('{0}', label),
      });
      return;
    }
    if (cells.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGES, '_No changes.') });
      return;
    }
    // 신규행 중복 — AS-IS cs:1493~1497 은 조회결과에 같은 13컬럼 행이 있으면 MSG00260 후 저장 전체를 중단한다.
    //   Line 확인(MSG00453)보다 **먼저** 본다(AS-IS 순서 동일 — cs:1493 → cs:1500).
    if (hasDuplicateInsertRow(source)) {
      void setAlert({ type: 'alert', content: t(MSG.DUPLICATE_ROW, '_Duplicate row.') });
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

    // 저장 실행은 반드시 try/catch 로 감싼다 — apiClient 인터셉터(axios-interceptors)는 403/500 만
    //   resolve 하고 그 외(401/404/연결오류 등)는 reject 한다. try/catch 가 없으면 이 reject 가 통째로
    //   삼켜져 **성공·실패 어떤 피드백도 안 뜬다**(사용자 신고 2026-10-19: Confirm 후 네트워크는 가는데 화면 무반응).
    try {
      const res = await saveIntegrationPsiAsync({ mode, payload });
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
    } catch (e) {
      const detail =
        (e as { response?: { data?: { message?: string } } })?.response?.data?.message ??
        (e as Error)?.message ??
        '';
      void setAlert({
        type: 'alert',
        content: [t(MSG.SAVE_FAIL, '_Save failed.'), detail].filter(Boolean).join('\n'),
      });
    }
  };

  // 신규행 삽입 (design 03 §3-Value V1/V2). 삽입 자체는 SAVE 권한(hotkeyConfig)으로 게이트한다 —
  //   TO-BE 는 편집모드가 없으므로 AS-IS InsertButton IsLock(편집모드) 가드는 두지 않는다.
  //   V1(ADMIN, cs:967-976): 빈 신규행 + DIVISION_ID=조회 division 만 세팅(DIVISION_ID 셀잠금은 그리드 lockCtx).
  //   V2(일반, cs:986-1052): 현재행 식별필드 17건 **복사**(INSERT_COPY_COLS) + 고정값 5건 —
  //     MEASURE_LABEL="Prod Plan"/MEASURE="PROD_PLAN"/LINE_ID="-"(sentinel)/BOH_QTY=0/
  //     SEQ_FLAG=현재행 seq[0]+"50". 합 22건이 AS-IS defaultData 키 목록과 일치한다(cs:1027~1049).
  //     복사를 명시적으로 하는 이유는 INSERT_COPY_COLS 주석 참고 — addRow 는 앵커를 복사하지 않는다.
  //   중복검사(MSG00260): 삽입 후 식별키(division/company/plant/operationGroup/measure/cellItem/item/toSite/
  //     toProduct/lineId/seqFlag) 동일 행이 이미 있으면 삽입 취소 + 경고(신규행 자기 자신 제외).
  const handleInsert = () => {
    const grid = gridRef.current;
    if (!grid) return;

    // 앵커행(현재행) — V2 는 이 행을 복사하고 SEQ_FLAG 를 파생한다. 없으면 V1(빈 신규행).
    const anchor = grid.collectionView?.currentItem as Record<string, unknown> | undefined;

    // V2 복사분 — 앵커행의 식별필드를 긁는다. 앵커가 없으면(조회 전/선택 없음) 빈 객체 → 사실상 V1 과 같아진다.
    const copied: Record<string, unknown> = {};
    if (anchor) {
      for (const col of INSERT_COPY_COLS) {
        if (anchor[col] !== undefined) copied[col] = anchor[col];
      }
    }

    const overrides: Record<string, unknown> = auth.isAdmin
      ? { CRUD_TYPE: CRUD_TYPE.INSERT, DIVISION_ID: sc.divisionId } // V1 — DIVISION_ID 만, 나머지 공백
      : {
          // V2 — 앵커행 식별필드 복사 + PROD_PLAN 신규 고정값. LINE_ID sentinel("-") 저장 시 MSG00453 확인.
          //   순서 주의: 고정값이 복사분을 덮어야 한다(MEASURE/SEQ_FLAG/BOH_QTY/LINE_ID 는 앵커값이 아니다).
          ...copied,
          CRUD_TYPE: CRUD_TYPE.INSERT,
          MEASURE_LABEL: 'Prod Plan',
          MEASURE: MEASURE.PROD_PLAN,
          LINE_ID: LINE_ID_EMPTY,
          BOH_QTY: 0,
          SEQ_FLAG: seqFlagForInsert(anchor),
        };

    // 중복검사는 여기서 하지 않는다 — AS-IS 는 **저장 시점**에 조회결과와 대조한다(hasDuplicateInsertRow 주석).
    //   삽입 직후 지워 버리면 Line 을 고를 기회조차 없고(신규행에서 Line 은 유일한 편집칸) "추가가 안 된다"가 된다.
    GridAction.addRow(grid, overrides as unknown as Partial<MainRow>, 'below');
  };

  // Delete — AS-IS `DeleteButton()` 은 **본문이 비어 있다**(cs:536~539). 즉 AS-IS 에서는 아무 일도 일어나지 않는다.
  //   사용자 지시(2026-10-13)로 TO-BE 는 **미저장 신규행(CRUD_TYPE='I')만** 제거한다 — Insert 후 Save 전까지.
  //   저장된 행을 지우지 않는 것은 선택이 아니라 제약이다: SAVE SP 에 행 삭제 경로가 없다
  //   (P_SCP0111_SAVE_INTEGRATION_PSI action 은 'I'|'M' 뿐이고 activeFlag 는 'Y' 고정 —
  //    PKG_SCP0111 BODY 의 DELETE 는 전부 GT_* 임시테이블 정리다, 2026-10-13 ora.py 실측).
  //   그래서 `removeRow(grid, deleteOnlyNew=true)` 를 쓴다 — 저장된 행에 'D' 마킹을 남기지 않는다
  //   (마킹해도 SP 가 처리할 수 없어 사용자에게는 "지워진 듯 보이지만 저장되지 않는" 상태가 된다).
  const handleDelete = () => {
    const grid = gridRef.current;
    if (!grid) return;

    const selected = (GridUtils.getSelectedRows(grid) ?? []) as Record<string, unknown>[];
    const pending = selected.filter(r => sVal(r.CRUD_TYPE) === CRUD_TYPE.INSERT);
    // 저장된 행만 선택한 경우 조용히 끝내지 않고 알린다 — 아무 반응이 없으면 "버튼이 고장났다"로 읽힌다.
    if (pending.length === 0) {
      void setAlert({
        type: 'alert',
        content: t(MSG.DELETE_ONLY_NEW, '_Only newly inserted rows can be deleted.'),
      });
      return;
    }
    GridAction.removeRow(grid, true);
  };

  // F6 개인화 저장 payload — 공용 표준을 따른다: searchCondition 을 그대로 넘기면 공용 personalizeCondition 이
  //   날짜키(planStartYyyymmdd/from·toYyyymm)를 EXCLUDED_DATE_PARAM(gridAction.ts L660)으로 **저장에서 제외**한다.
  //   "PlanDate·조회구간(Period)은 조회조건 저장 제외"가 공통 원칙이고 AS-IS ConditionNotUseList(cboPlanDate 제외)
  //   와도 일치한다(사용자 지시 2026-11-16 — 2026-10-19 의 별칭 저장 우회 철회). 재진입 시 PlanDate·Period 는
  //   Form 의 기본선택 effect 가 다시 도출한다. 자매 Capa/OptCapa 도 raw searchParams 를 그대로 넘긴다(표준 파리티).

  // Admin mode 토글 — System Admin 전용. 관리자편집(ADMIN 저장=절대값·관리컬럼 노출·Insert V1·BOH 전행편집)과
  //   일반편집은 저장 payload 계약이 비대칭(ADMIN 절대값 vs 일반 가감값 — handleSave 주석)이라 모드를 섞으면
  //   수량이 깨진다. 그래서 전환 전 미저장 변경이 있으면 조회 가드와 동일하게 confirm(MSG00704) 후 **버리고**,
  //   새 모드 기준으로 재조회해 그리드를 깨끗이 재구성한다(관리컬럼 가시성·신규행 V1/V2 규칙이 모드에 따라 다름).
  //   confirmIfDirtyKey 는 dirty 아니면 즉시 true, 확인 시 등록된 변경을 되돌려(discard) 재진입 시 부활도 막는다.
  const handleToggleAdminMode = async () => {
    const ok = await confirmIfDirtyKey(tabDirtyKey(tabId), 'search');
    if (!ok) return;
    setAdminMode(prev => !prev);
    setFilter(); // 새 모드 기준 재조회 — 그리드를 재구성한다(FindData_Main refetch).
  };

  const hotkeyConfig: HotkeyConfig = {
    // 조회는 무해하므로 항상 허용(design 01 R13).
    search: handleSearch,
    // Reset Condition(F10) — 화면 조회조건 값 초기화(공용 F10 은 서버 저장분만 지움, 2026-10-14~).
    resetCondition: handleResetCondition,
    // 신규/저장 = 화면 update 권한(SAVE)으로 게이트(design 01 R11/R14).
    insert: hasButton('SAVE') ? handleInsert : false,
    save: hasButton('SAVE') ? handleSave : false,
    // Delete — AS-IS 는 NO-OP(본문 공백 cs:536~539)지만 사용자 지시로 "미저장 신규행 삭제"만 허용한다.
    //   Insert 와 같은 SAVE 권한으로 게이트한다(권한 없는 사용자는 Insert 자체가 불가 → 지울 신규행도 없다).
    delete: hasButton('SAVE') ? handleDelete : false,
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
        onItemSearch={() => setOpenItemModal(true)}
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
        // Admin mode 토글 — 표준 버튼 게이팅(AUTH-01): customButtons 는 hasButton(BTN_CD)로 판정한다.
        //   'EDIT' 는 AS-IS EditButton 대응으로 05_register.sql 에 이미 등록된 버튼 코드이고, System Administrator
        //   그룹(USER_GR_ID='ADMIN')에만 권한을 남겨(SCP Planner EDIT 는 USE_YN='N' 회수) System Admin 만 노출된다.
        //   활성 시 contained 로 강조해 현재 관리자편집 중임을 색으로 구분한다(비활성=outlined).
        //   라벨은 다국어 처리하지 않고 영문 'Admin mode' 고정(사용자 지시 2026-11-19) — t()/LBL 미사용.
        customButtons={
          hasButton('EDIT')
            ? [
                {
                  label: 'Admin mode',
                  appearance: adminMode ? 'contained' : 'outlined',
                  action: handleToggleAdminMode,
                },
              ]
            : undefined
        }
      />

      {/* 영역3 그리드 — 고정 24열(admin 메타) + 서버측 동적 YYYYMM PIVOT + 편집잠금 L1~L23 + 조건색 C1/C2 +
          LINE_ID 신규행 셀콤보(§2-D). division/auth 조합으로 셀 단위 잠금을 beginningEdit 에서 재현(편집모드 없음).
          essPackLineRows(분기 A ESS Pack Line): 원천이 CMBO 아닌 SP(P_SCP0111_GET_ESS_PACK_LINE, IN 0개 +
          O_RC/O_RESULT_CURSOR)라 콤보 훅이 아니라 useTabProcQuery(essPackLine/SEARCH)로 조회한다. BE 는
          {menuId}/{sheet}/{action}/call-proc 3-키로 SCM_ADM_PROC_M/API 매핑을 찾아 SP 를 실행하는데, 이 SP 의
          (sheet=essPackLine, action=SEARCH) 매핑·그룹권한이 2026-11-17 DB 반영 실측으로 확인됐다(design U-1 해소).
          division 82 일 때만 조회(위 essPackLineRows). 분기 B(LineByOperationPlantId_SCP_ALL)는 그리드 내부 로드. */}
      {/* fromYyyymm/toYyyymm — 조회 전에도 기간 월이 컬럼으로 생성되도록 검색조건의 **현재 선택값**을 넘긴다.
          AS-IS 는 Form_Load → CreateSpread → InitSpread → SetCalendar(cs:174/303/334)로 데이터와 무관하게
          From/To 월 컬럼을 먼저 만들고, PlanDate 변경(cs:1862)·조회(cs:853)마다 재생성한다. */}
      <IntegrationPsiGrid
        rows={rows}
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        adminColumns={staticColumns}
        division={sc.divisionId}
        fromYyyymm={sc.fromYyyymm}
        toYyyymm={sc.toYyyymm}
        auth={auth}
        multiChildItems={multiChildItems}
        measures={staticMeasures}
        essPackLineRows={essPackLineRows}
        onDerivMismatch={detail => {
          // AS-IS MessageHelper.GMessageBox(cs:2051-2056 / 2120-2125) 파리티 — 수정 즉시 뜨는 블로킹 경고창.
          //   검증 실패 범주라 Toast 가 아니라 Alert 가 표준(규칙 UI-09). 저장은 막지 않는다(읽고 확인).
          //   머리말은 MSG.DERIV_MISMATCH(MSG01502) 문구, 상세 수치 줄은 AS-IS 라벨 그대로 조립한다.
          const head = t(MSG.DERIV_MISMATCH, '수량 불일치');
          const body =
            detail.kind === 'D1'
              ? `${detail.itemId} Prod plan Qty : ${detail.prodQty}\n` +
                `${detail.counterpartId} In-house moving Qty : ${detail.inhouseQty}\n` +
                `${detail.counterpartId} In-house moving Qty Should be ${detail.shouldBe}`
              : `${detail.itemId} In-house moving Qty : ${detail.inhouseQty}\n` +
                `${detail.counterpartId} Prod plan Qty : ${detail.prodQty}\n` +
                `${detail.counterpartId} Prod plan Qty Should be ${detail.shouldBe}`;
          setAlert({ type: 'alert', content: `${head}\n${body}` });
        }}
        onFocus={NOOP}
      />

      {/* Model/Nickname 팝업 — MaterialByDivisionModal(COM0013), 사용자 지시 2026-10-12.
          AS-IS 는 btnNickName/btnItemId 두 버튼이 각각 `SCM0002_ItembyDivisionPopup` 을 열어
            (cs L1877 / L1916 — 둘 다 Form_Load(true, division, "", "", ...)) 반환을 서로 다른 필드에
            넣었다. 입력칸을 하나로 합쳤으므로 팝업도 하나만 둔다.
          **의도적 AS-IS 이탈**: `SCM0002_ItembyDivisionPopup` 의 TO-BE 대응은 `ModelByDivisionPopup`
            (SCM0002/ModelPopup)이고, COM0013 은 SP·그리드 컬럼이 다른 별개 팝업이다. 사용자 결정으로
            COM0013 을 채택했다(자매 SSP0021 과 동일 결정).
          반환 계약 주의: master 계약은 (itemId, itemName, itemClassName, **nickName**) 로 NickName 이
            **4번째**다(종전 ItemByDivisionModal 은 5번째). 여기서는 Model 코드(1번째)만 쓴다. */}
      <MaterialByDivisionModal
        open={openItemModal}
        modalClose={() => setOpenItemModal(false)}
        setSelectedValue={items => setSearchCondition({ itemId: String(items ?? '') })}
        preSearchParams={{
          divisionId: sc.divisionId,
          scpModuleType: MENU_ID,
          operationGroup: '',
          itemId: sc.itemId,
        }}
      />
    </>
  );
};
