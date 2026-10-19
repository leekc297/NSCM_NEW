import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { MaterialByDivisionModal } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction, GridUtils } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import {
  useTabBtnPermissions,
  useTabComboQueries,
  useTabLookupQueries,
  useTabProcQuery,
} from '@shared/hooks';
import { useMessageStore, useSessionStore } from '@shared/stores';

import { IntegrationPsiForm } from './components/IntegrationPsiForm';
import { IntegrationPsiGrid } from './components/IntegrationPsiGrid';
import {
  COMBO,
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

  // Plan HORIZON_END — 신규행(I) 삽입 월 범위의 **상한**. AS-IS SetChangedPeriod(cs:267~278)가 읽는 값과 같고,
  //   저장 시 AS-IS 가 `Data.Common(CalendarMonth, plan_start월, _toDate월)`(cs:1510~1511)로 월 전체를 뽑는 근거다.
  //   `SCPPlanPeriod_SCP` 등록 SQL 실측: `SELECT HORIZON_START_DATE, HORIZON_END_DATE, PLAN_CYCLE, ...
  //    FROM SCM_MST_PLAN WHERE PLAN_NAME = @planName AND DIVISION_ID = @divisionId AND PLAN_CYCLE = 'WEEKLY'`
  //   → 파라미터 키는 `planName`/`divisionId` 와 정확히 같아야 치환된다(BE makeComboQuery 는 raw 치환).
  //   **저장 경로 전용**이다 — 화면 기간 입력은 공통 PeriodRangePicker(자유 달력)라 상한을 쓰지 않는다.
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
      planStartYyyymmdd: sc.planStartYyyymmdd,
      horizonEndYyyymmdd,
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

  const hotkeyConfig: HotkeyConfig = {
    // 조회는 무해하므로 항상 허용(design 01 R13).
    search: handleSearch,
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
      />

      {/* 영역3 그리드 — 고정 24열(admin 메타) + 서버측 동적 YYYYMM PIVOT + 편집잠금 L1~L23 + 조건색 C1/C2 +
          LINE_ID 신규행 셀콤보(§2-D). division/auth 조합으로 셀 단위 잠금을 beginningEdit 에서 재현(편집모드 없음).
          essPackLineRows(분기 A ESS Pack Line): 원천이 CMBO 아닌 SP(P_SCP0111_GET_ESS_PACK_LINE, IN 0개 +
          O_RC/O_RESULT_CURSOR)라 콤보 훅으로 못 붙는다. NSCM proc 호출은 {menuId}/{sheet}/{action}/call-proc
          3-키 라우팅이고 BE 가 그 3-키로 SCM_ADM_PROC_M/API 매핑을 찾아 SP 를 실행하는데, 이 SP 는 (sheet,action)
          매핑에 미등록이다(05_register.sql: SEARCH/SAVE/SAVEDETAIL 3종만 API 배선, GET_ESS_PACK_LINE 은 미배선).
          즉 FE 단독 배선 불가 — API_M/버튼(별도 action)/그룹권한 DB 등록(메타소유자 채번·배포)이 선행돼야 한다.
          확정 전까지 빈 배열 유지(분기 A 후보 0건, design 03 §6 확인필요). 분기 B(LineByOperationPlantId_SCP_ALL)는
          그리드 내부에서 직접 로드한다. */}
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
        essPackLineRows={[]}
        onDerivMismatch={() =>
          setToast({
            type: 'warning',
            message: t(MSG.DERIV_MISMATCH, '수량 불일치'),
          })
        }
        onFocus={() => undefined}
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
