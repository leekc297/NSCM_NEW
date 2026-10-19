// CAPA New Model 팝업 행/셀 편집 권한 판정 — AS-IS LoadAuthority/PlannerTypeLogic/EditButton
//   (cs L309-403, L936-995, L565-837) 순수함수 이식. AS-IS 는 SP #5(PR_UI_FP01886_AUTHORITY_REQUEST)·
//   #6(UP_FX_GetReqAuthMyListAdded) 원본 데이터만 서버에서 받고, SuperPlanner/SidePlanner/None 판정과
//   행별 잠금은 전부 클라이언트에서 계산한다 — 이 파일이 그 계산을 그대로 옮긴다(서버판정 방식 아님,
//   사용자 결정 A안, 2026-09-22).
//
// "현재 그룹"(AS-IS UserInfoContext.Current["NowGroupID"])은 TO-BE session.groupId 로 읽지 않는다 —
//   sales-plan.auth.ts 가 이미 문서화한 유령 필드 사고(2026-07-15, session.groupId 참조 금지)와 같은
//   함정이라, 대신 division별 승인 플래그(scpApproved/fpApproved)만으로 판정한다: SidePlanner 는
//   정의상 둘 중 하나만 승인된 상태라 "현재 어느 그룹으로 동작 중인가"는 그 승인 플래그 자체로
//   모호함 없이 결정된다(승인 안 된 역할로 "현재 동작 중"일 수 없다).
// "CAPA Planner"(AS-IS SCP_CAPA_bool 판정에 SCP Planner 와 OR 로 동일 취급)는 TO-BE
//   SCM_ADM_USER_GR_M 에 등록이 없어(2026-09-22 ora.py 확인) 뺀다 — 사용자 확인(SCP Planner 로 흡수).
import type { ComboResponse } from '@foundation/models';
import { safeString } from '@foundation/utils';

import { AUTH_GROUP, DefColumns } from './capa-new-model-popup.constants';

export interface CapaAuthListRow {
  GROUP_ID?: unknown;
  APPROVAL_RESULT?: unknown;
  DIVISION_ID?: unknown;
}

export interface CapaFpInstanceRow {
  DIVISION_ID?: unknown;
  PLANT_ID?: unknown;
  FACTORY_ID?: unknown;
  MENU_AUTHORITY_ID?: unknown;
  APPROVAL_FLAG?: unknown;
}

const isApproved = (rows: CapaAuthListRow[], groupId: string, divisionId: string): boolean =>
  rows.some(
    r =>
      safeString(r.GROUP_ID) === groupId &&
      safeString(r.APPROVAL_RESULT) === 'APPROVED' &&
      safeString(r.DIVISION_ID) === divisionId
  );

export interface CapaAuthContext {
  scpApproved: boolean;
  fpApproved: boolean;
  isPiAdmin: boolean;
  operGroupList: string[];
  fpCategoryIds: Set<string>;
}

// LoadAuthority(cs L309-403) + PlannerTypeLogic(cs L936-995, division 스코프)를 합쳐 화면이 한 번에
//   쓸 컨텍스트로 만든다. divisionId 는 검색에 실제 사용된 division(폼의 현재값이 아니다 — cs FindData
//   가 조회 시점 division 으로 재판정하는 것과 동일).
export const buildCapaAuthContext = (
  myAuthList: CapaAuthListRow[],
  fpInstanceRows: CapaFpInstanceRow[],
  myGroupIds: string[],
  operGroupList: string[],
  divisionId: string
): CapaAuthContext => ({
  scpApproved: isApproved(myAuthList, AUTH_GROUP.SCP_PLANNER, divisionId),
  fpApproved: isApproved(myAuthList, AUTH_GROUP.FP_PLANNER, divisionId),
  isPiAdmin: myGroupIds.includes(AUTH_GROUP.PI_ADMIN),
  operGroupList,
  fpCategoryIds: new Set(
    fpInstanceRows
      .filter(
        r =>
          safeString(r.MENU_AUTHORITY_ID) === 'PLANNER' &&
          safeString(r.APPROVAL_FLAG) === 'Y' &&
          safeString(r.DIVISION_ID) === divisionId
      )
      .map(r => `${safeString(r.PLANT_ID)}_${safeString(r.FACTORY_ID).toUpperCase()}`)
  ),
});

// dtLaneQtyOfLineAssign 존재검증(cs L629-635 등, EditButton 전용 — CODE 값 매칭 없이 "후보가 있는가"만
//   본다. SaveData 검증(handleSave 의 buildSaveEntries)은 CODE==현재값까지 매칭하는 별도 축이다).
export const hasLaneQtyCandidate = (
  row: Record<string, unknown>,
  laneQtyRows: ComboResponse[]
): boolean =>
  laneQtyRows.some(
    l =>
      safeString(l.DIVISION_ID) === safeString(row[DefColumns.DIVISION_ID]) &&
      safeString(l.COMPANY_ID) === safeString(row[DefColumns.COMPANY_ID]) &&
      safeString(l.SITE_ID) === safeString(row[DefColumns.SITE_ID]) &&
      safeString(l.LINE_ID) === safeString(row[DefColumns.LINE_ID]) &&
      safeString(l.OPERATION_ID) === safeString(row[DefColumns.OPERATION_ID]) &&
      safeString(l.ELECTRODE_TYPE) === safeString(row[DefColumns.ELECTRODE_TYPE]) &&
      safeString(l.ITEM_ID) === safeString(row[DefColumns.ITEM_ID])
  );

export interface CapaRowEditability {
  rowEditable: boolean;
  laneQtyEditable: boolean;
}

const USER_ID_COLUMNS = [
  DefColumns.USER_ID_1,
  DefColumns.USER_ID_2,
  DefColumns.USER_ID_3,
  DefColumns.USER_ID_4,
  DefColumns.USER_ID_5,
  DefColumns.USER_ID_6,
  DefColumns.USER_ID_7,
  DefColumns.USER_ID_8,
  DefColumns.USER_ID_9,
  DefColumns.USER_ID_10,
];

// EditButton(cs L579-825) 행별 판정. isGroupElectrode = 조회조건 Group 에 'E' 포함 여부(그리드 LANE_QTY
//   컬럼 표시조건 buildCapaNewModelColumns 와 동일 값 재사용, AS-IS pGroupId=="E" 대응).
export const resolveCapaRowEditability = (
  row: Record<string, unknown>,
  sessionUserId: string,
  isGroupElectrode: boolean,
  ctx: CapaAuthContext,
  laneQtyCandidateExists: boolean
): CapaRowEditability => {
  const opId = safeString(row[DefColumns.OPERATION_ID]);
  const isResponsible =
    ctx.isPiAdmin || USER_ID_COLUMNS.some(col => safeString(row[col]) === sessionUserId);

  // SCM PI Admin·행 책임자(USER_ID_1~10) — 월(Priority) 셀은 무조건 편집가능, LANE_QTY 는
  // E그룹+E2000(Dam Mixing) 조합일 때만(cs L616-650).
  if (isResponsible) {
    const laneQtyGate = isGroupElectrode && opId === 'E2000';
    return { rowEditable: true, laneQtyEditable: laneQtyGate && laneQtyCandidateExists };
  }

  if (!ctx.scpApproved && !ctx.fpApproved) {
    return { rowEditable: false, laneQtyEditable: false };
  }

  const fpCate = `${safeString(row[DefColumns.PLANT_ID])}_${safeString(
    row[DefColumns.FACTORY_ID]
  ).toUpperCase()}`;
  const inOperGroup = ctx.operGroupList.includes(opId);
  const inFpCategory = ctx.fpCategoryIds.has(fpCate);

  let rowEditable: boolean;
  if (ctx.scpApproved && ctx.fpApproved) {
    rowEditable = inOperGroup || inFpCategory; // SuperPlanner(cs L741-819)
  } else if (ctx.scpApproved) {
    rowEditable = inOperGroup; // SidePlanner — SCP Planner 경로(cs L654-690)
  } else {
    rowEditable = inFpCategory && inOperGroup; // SidePlanner — FP Planner 경로(cs L691-733)
  }

  return { rowEditable, laneQtyEditable: rowEditable && laneQtyCandidateExists };
};

// Mail Req 체크박스 — 권한 무관 항상 편집가능(cs 전 분기 공통 LockRange(REQUEST_CHK,...,false)).
export const isAlwaysEditableBinding = (binding: string): boolean => binding === DefColumns.REQUEST_CHK;

// 식별 컬럼 — 전 분기 공통 최초 LockRange(DIVISION_ID..ELECTRODE_TYPE, true), 어떤 권한으로도 풀리지
//   않는다(LANE_QTY 만 이 구간 안에서 조건부로 재잠금해제된다 — resolveCapaRowEditability 가 별도 처리).
const LOCKED_IDENTITY_COLUMNS: string[] = [
  DefColumns.DIVISION_ID,
  DefColumns.COMPANY_ID,
  DefColumns.SITE_ID,
  DefColumns.PLANT_ID,
  DefColumns.FACTORY_ID,
  DefColumns.LINE_ID,
  DefColumns.LINE_NAME,
  DefColumns.OPERATION_ID,
  DefColumns.ITEM_ID,
  DefColumns.NICK_NAME,
  DefColumns.ELECTRODE_TYPE,
];
export const isLockedIdentityBinding = (binding: string): boolean =>
  LOCKED_IDENTITY_COLUMNS.includes(binding);
