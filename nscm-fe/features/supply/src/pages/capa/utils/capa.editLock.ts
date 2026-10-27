import dayjs from '@foundation/dayjs';

import {
  EDIT_AUTH_GROUP,
  LANE_QTY_OPERATIONS,
  PLANNER_GROUP,
  REQUEST_CHK_BINDING,
  USER_AUTH_PRIORITY_GROUPS,
} from '../capa.constants';
import type { CapaRow } from '../capa.types';

/**
 * 편집 판정 컨텍스트 — Version 상태·세션 사용자·권한 그룹·LANE_QTY 후보 수.
 * EDIT 모드 토글은 미이식(convert-core §2.4, asis_to_tobe §11): editMode state 없이 아래 종합식만 사용.
 */
export interface EditContext {
  isCurrentVersion: boolean; // bRealFlag 등가 — Version='Current' 선택 시에만 편집 전제 성립
  userId: string;
  /** 보유 그룹 이름(USER_GR_NM) 목록 — session.groups. 세션에 현재 그룹(groupId)은 없다. */
  groups: readonly string[];
  /** 행 LANE_QTY 셀 콤보 후보 수(>0 이어야 개방). 미배선 시 0. */
  laneQtyCandidateCountOf: (row: CapaRow) => number;
  /** 승인 Planner 판정(GoEdit ②③④). 미배선·조회 실패면 NONE_PLANNER_AUTH(갈래 ① 만). */
  planner?: PlannerAuth;
}

/**
 * 승인 Planner 판정 결과 — AS-IS PlannerTypeLogic(cs:499-561) · LoadAuthority(cs:563-656) ·
 *   FP 인스턴스 목록(cs:2056-2080) 을 조회 Division 기준으로 묶은 값.
 *   super = (SCP 또는 CAPA Planner 승인) ∧ FP Planner 승인 → 갈래 ②.
 *   scpSide / fpSide = Side Planner(둘 중 하나만 승인) 이면서 보유 그룹(session.groups)에 해당 Planner 그룹이
 *   있을 때 → 갈래 ③ / ④. AS-IS 는 로그인 그룹 하나(_CurrentGroupID)로 둘 중 하나만 탔으나 TO-BE 에는
 *   현재 그룹이 없어(2026-09-21 요건) 보유 그룹 전체로 판정하고, 둘 다 해당하면 범위를 합친다.
 */
export interface PlannerAuth {
  super: boolean;
  scpSide: boolean;
  fpSide: boolean;
  /** LocationGroupByCapa 콤보 CODE(공정 ID) — _OperGroupList(cs:589-594). */
  operGroupList: readonly string[];
  /** FP 인스턴스 PLANT_ID_FACTORY_ID_SHOP_GROUP_ID(대문자) — _List_FP_CategoryId(cs:2062-2073). 비면 bFP_Instance=false. */
  fpCategoryIds: ReadonlySet<string>;
}

export const NONE_PLANNER_AUTH: PlannerAuth = {
  super: false,
  scpSide: false,
  fpSide: false,
  operGroupList: [],
  fpCategoryIds: new Set<string>(),
};

/** 내 승인 권한 목록 행(PKG_SYS0011.P_SYS0011_GET_MY_AUTH_DATA o_rc — USER_GR_ID·APPROVAL_RESULT·DIVISION_ID). */
export interface MyAuthRow {
  USER_GR_ID?: unknown;
  APPROVAL_RESULT?: unknown;
  DIVISION_ID?: unknown;
}

/** FP 인스턴스 권한 행(PR_UI_FP01886_AUTHORITY_REQUEST SELECT_MAIN o_rc). */
export interface FpInstanceRow {
  DIVISION_ID?: unknown;
  PLANT_ID?: unknown;
  FACTORY_ID?: unknown;
  SHOP_GROUP_ID?: unknown;
  MENU_AUTHORITY_ID?: unknown;
  APPROVAL_FLAG?: unknown;
}

const str = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

const isApproved = (rows: readonly MyAuthRow[], groupId: string, divisionId: string): boolean =>
  rows.some(
    r =>
      str(r.USER_GR_ID) === groupId &&
      str(r.APPROVAL_RESULT) === 'APPROVED' &&
      str(r.DIVISION_ID) === divisionId
  );

/** 행의 FP 분류 키 — PLANT_ID_FACTORY_ID_공정그룹명 첫 글자(대문자)(cs:912-918). */
export const fpCategoryOf = (row: CapaRow): string =>
  `${str(row.PLANT_ID)}_${str(row.FACTORY_ID)}_${str(row.OPERATION_GROUP_NAME).slice(0, 1).toUpperCase()}`;

const USER_ID_KEYS = [
  'USER_ID_1',
  'USER_ID_2',
  'USER_ID_3',
  'USER_ID_4',
  'USER_ID_5',
  'USER_ID_6',
  'USER_ID_7',
  'USER_ID_8',
  'USER_ID_9',
  'USER_ID_10',
] as const;

const normGroup = (g: string): string => g.trim().toUpperCase();

/**
 * 승인 Planner 판정(cs:499-561 PlannerTypeLogic + cs:617-656 · 2056-2080 FP 인스턴스).
 *   divisionId = 조회에 쓴 Division(AS-IS FindData_Main 끝에서 PlannerTypeLogic(pDivisionId) 재판정, cs:2083).
 */
export const buildPlannerAuth = (
  myAuthList: readonly MyAuthRow[],
  fpInstanceRows: readonly FpInstanceRow[],
  groups: readonly string[],
  operGroupList: readonly string[],
  divisionId: string
): PlannerAuth => {
  const fp = isApproved(myAuthList, PLANNER_GROUP.FP, divisionId);
  const scpCapa =
    isApproved(myAuthList, PLANNER_GROUP.SCP, divisionId) ||
    isApproved(myAuthList, PLANNER_GROUP.CAPA, divisionId);
  const held = new Set(groups.map(normGroup));
  const side = scpCapa !== fp;
  return {
    super: scpCapa && fp,
    scpSide:
      side && (held.has(normGroup(PLANNER_GROUP.SCP)) || held.has(normGroup(PLANNER_GROUP.CAPA))),
    fpSide: side && held.has(normGroup(PLANNER_GROUP.FP)),
    operGroupList,
    fpCategoryIds: new Set(
      fpInstanceRows
        .filter(
          r =>
            str(r.MENU_AUTHORITY_ID) === 'PLANNER' &&
            str(r.APPROVAL_FLAG) === 'Y' &&
            str(r.DIVISION_ID) === divisionId
        )
        .map(r => `${str(r.PLANT_ID)}_${str(r.FACTORY_ID)}_${str(r.SHOP_GROUP_ID).toUpperCase()}`)
    ),
  };
};

/**
 * 조회 인자 userAuth — 보유 그룹 중 ADMIN(System Administrator)·SCP Planner·SCM PI Admin 이 있으면 그 값,
 *   없으면 첫 그룹, 그룹이 없으면 ''. 프로시저는 값 하나만 받는다(USER_AUTH_PRIORITY_GROUPS 주석).
 */
export const toUserAuth = (groups: readonly string[] | undefined): string => {
  const list = (groups ?? []).map(g => g.trim()).filter(g => g !== '');
  const upper = new Set(list.map(normGroup));
  const hit = USER_AUTH_PRIORITY_GROUPS.find(([name]) => upper.has(name));
  return hit ? hit[1] : (list[0] ?? '');
};

/** 행 담당자 권한 — 보유 그룹에 SCM PI Admin 이 있거나 사용자가 USER_ID_1~10 에 포함(cs:568-572). */
export const hasRowEditAuth = (row: CapaRow, ctx: EditContext): boolean => {
  if (ctx.groups.some(g => normGroup(g) === normGroup(EDIT_AUTH_GROUP))) return true;
  const uid = ctx.userId.trim();
  if (uid === '') return false;
  return USER_ID_KEYS.some(k => String(row[k] ?? '').trim() === uid);
};

const kindOfPeriod = (binding: string): 'D' | 'M' | 'Y' | null =>
  /^D_\d{8}$/.test(binding) ? 'D' : /^M_\d{6}$/.test(binding) ? 'M' : /^Y_\d{4}$/.test(binding) ? 'Y' : null;

/**
 * 기간칼럼 편집 판정(§3 L7~L10) — 행 DATA_TABLE 별 경계.
 *   WORK_CALENDAR 행: M_ ≥ 당월+3(cs:861 AddMonths(3) — +4 는 cs:860 주석 처리된 옛 값) · D_ ≥ 당일 · Y_ 개방
 *   LOSS(SCM_LOSS_M) 행: M_·Y_ 만(D_ 불가 — L10)
 *   그 외(LINE ASSIGN·TACT·YIELD): 전 기간 개방
 */
const isPeriodCellEditable = (row: CapaRow, binding: string, today: dayjs.Dayjs): boolean => {
  const kind = kindOfPeriod(binding);
  if (!kind) return false;
  const dataTable = String(row.DATA_TABLE ?? '');
  if (dataTable === 'SCM_WORK_CALENDAR_M') {
    if (kind === 'Y') return true;
    if (kind === 'M') return binding.slice(2, 8) >= today.add(3, 'month').format('YYYYMM');
    return binding.slice(2) >= today.format('YYYYMMDD'); // D_ ≥ 당일
  }
  if (dataTable === 'SCM_LOSS_M') return kind !== 'D'; // LOSS 행은 D_ 불가
  return true; // LINE ASSIGN / TACT / YIELD 행 — 전 기간
};

/** BEF 실적 영역(조회 전용) — 편집 차단(§3 종합식 주석 · §5-3). */
const isBefColumn = (binding: string): boolean => binding.startsWith('BEF_');

/** 갈래별 편집 범위 — 한 행에서 어느 갈래라도 연 칸이면 편집 가능. */
interface BranchScope {
  laneQty: boolean;
  /** 근무 달력·손실 경계 위에 TACT(SCM_TACT_TIME_M) D_ 도 잠근다(cs:1167·1245·1344·1427·1495). */
  lockTactDaily: boolean;
}

/** LANE_QTY 공정 조건 — LINE ASSIGN 이면서 E2000·E3000·E4000(cs:961-962·1036-1037·1290-1291). */
const isLaneQtyRow = (row: CapaRow): boolean =>
  String(row.CATEGORY_ID ?? '') === 'LINE ASSIGN' &&
  (LANE_QTY_OPERATIONS as readonly string[]).includes(String(row.OPERATION_ID ?? ''));

/**
 * 행이 받는 갈래 범위 목록(GoEdit cs:852-1543). 빈 배열이면 전 칸 잠금.
 *   ① 행 담당자·SCM PI Admin(cs:944-1012) — CONFIRM · LANE · 기간 전체.
 *   ② Super Planner(cs:1015-1266) — 전 공정 행. FP 인스턴스 블록(cs:1099-1257)에 걸리는 행은 TACT D_ 잠금
 *      (메인 공정 LINE ASSIGN 행 제외 — cs:1105 「LINE ASSIGN != 」 조건이라 그 행은 블록을 타지 않음).
 *   ③ Side + SCP/CAPA Planner(cs:1271-1355) — LocationGroupByCapa 공정 행만. TACT D_ 잠금.
 *   ④ Side + FP Planner + FP 인스턴스(cs:1356-1510) — FP 인스턴스 해당 행만(메인·서브 공정 무관). LANE 잠금 · TACT D_ 잠금.
 *   CONFIRM_FLAG 「라인+공정+전극+분류+손실 열쇠가 바뀌는 첫 행」(p_backValue_LineOper) = ROW_RANKING 1
 *   (P_GET_CAPA RANK() PARTITION BY 사업부·법인·사이트·Plant·Factory·Line·전극·공정·손실 ORDER BY ITEM_ID).
 */
const branchScopesOf = (row: CapaRow, ctx: EditContext): BranchScope[] => {
  const scopes: BranchScope[] = [];
  if (hasRowEditAuth(row, ctx)) scopes.push({ laneQty: true, lockTactDaily: false });
  const p = ctx.planner ?? NONE_PLANNER_AUTH;
  if (!p.super && !p.scpSide && !p.fpSide) return scopes;

  const inOperGroup = p.operGroupList.includes(String(row.OPERATION_ID ?? ''));
  const inFpCategory = p.fpCategoryIds.size > 0 && p.fpCategoryIds.has(fpCategoryOf(row));
  const isLineAssign = String(row.CATEGORY_ID ?? '') === 'LINE ASSIGN';

  if (p.super) {
    scopes.push({ laneQty: true, lockTactDaily: inFpCategory && !(inOperGroup && isLineAssign) });
  }
  if (p.scpSide && inOperGroup) scopes.push({ laneQty: true, lockTactDaily: true });
  if (p.fpSide && inFpCategory) scopes.push({ laneQty: false, lockTactDaily: true });
  return scopes;
};

/**
 * 셀 편집 허용 종합식(03 §3 — beginningEdit / formatItem 공용).
 * INPUT_TP_CD 는 전 컬럼 'S' 라 메타 단독 판정 불가(hook #130) — 이 함수가 행×셀 실시간 판정.
 */
export const isCellEditable = (row: CapaRow, binding: string, ctx: EditContext): boolean => {
  // 전제 3종: bRealFlag(Current) ∧ EDITORBLE_YN='Y' ∧ LOSS_CODE≠'LA999'.
  if (!ctx.isCurrentVersion) return false;
  if (String(row.EDITORBLE_YN ?? '') !== 'Y') return false;
  if (String(row.LOSS_CODE ?? '') === 'LA999') return false;
  // ESS Virtual Plant 행은 전 칸 잠금(cs:888·902-905 [PJ2025F254]).
  if (String(row.PLANT_TYPE ?? '') === 'VIRTUAL') return false;

  // REQUEST_CHK — LA001/LA002/LA003 행만(권한 무관, cs:563-566). 
  if (binding === REQUEST_CHK_BINDING) {
    //return (REQUEST_CHK_LOSS_CODES as readonly string[]).includes(String(row.LOSS_CODE ?? '')); -- 26.10.19 TO-BE MailReq 안쓰는다고 해서 false 처리.
    return false;
  }

  if (isBefColumn(binding)) return false;

  // 이하 갈래 ①~④ 중 하나라도 연 행에서만 개방.
  const scopes = branchScopesOf(row, ctx);
  if (scopes.length === 0) return false;

  if (binding === 'CONFIRM_FLAG') return String(row.ROW_RANKING ?? '') === '1';
  if (binding === 'LANE_QTY') {
    return isLaneQtyRow(row) && scopes.some(sc => sc.laneQty) && ctx.laneQtyCandidateCountOf(row) > 0;
  }
  if (!isPeriodCellEditable(row, binding, dayjs())) return false;
  // TACT D_ 는 그 잠금이 없는 갈래가 하나라도 있으면 열린다.
  if (String(row.DATA_TABLE ?? '') === 'SCM_TACT_TIME_M' && kindOfPeriod(binding) === 'D') {
    return scopes.some(sc => !sc.lockTactDaily);
  }
  return true;
};
