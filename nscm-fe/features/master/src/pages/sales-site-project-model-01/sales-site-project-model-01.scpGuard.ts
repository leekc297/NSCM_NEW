import { safeString } from '@foundation/utils';

/**
 * SCP Planner 권한 가드 — AS-IS DMF0005_SaleSite_PjtModelMapping.cs(정본 GSCM.DM.Forms.UIL,
 * Roslyn 추출 .atlas/gscm-design/DMF0005/roslyn/screen-analysis.json) 두 가드 1:1.
 *   · InsertButton(정본 L590): NowGroupID == "SCP Planner" 이면 MSG00096 안내 후 종료.
 *   · EditButton(정본 L618): 사업부 앞 두 자리가 81 또는 82 이고 NowGroupID == "SCP Planner" 이면
 *     편집 전환을 막는다(40 은 허용).
 *
 * 왜 화면에서 막는가. TO-BE 편집 가부는 조회 SP(PKG_DMF0005)가 행마다 내려주는 EDIT_FLAG 뿐인데,
 *   그 값을 정하는 관리자 기준 룩업 GET_ADMIN_GROUP(SEGMENT2='ALL')에 SCP Planner 가 2025-05-19
 *   등록돼 있어 SCP Planner 에게 전 행이 'Y' 로 내려온다. 그 룩업은 19개 SP 가 함께 쓰므로 여기서
 *   건드리지 않고, AS-IS 와 같이 화면이 그룹을 보고 막는다(사용자 결정 2026-10-07).
 *
 * 그룹 판정 원천은 세션의 보유 그룹 목록(session.groups — BE UserSession, SCM_ADM_USER_GR_M.USER_GR_NM
 *   합집합)이다. AS-IS 는 단일 "현재 그룹"(NowGroupID)을 봤지만 TO-BE 세션에는 현재 그룹이 없다
 *   (session.groupId 는 유령 필드 — auth-button AUTH-11). 그래서 겸직자는 Mkt Fcst 화면과 같은
 *   예외를 둔다: ADMIN / DM ADMIN / DM Planner / DM Planner (W/S) 를 함께 가진 계정은 막지 않는다
 *   (운영 요구 2026-09-10, mkt-fcst.constants SCP_EDIT_ALLOW_GROUPS 와 같은 목록).
 *
 * 주의: 그룹명 리터럴은 AUTH-11 이 금지하는 형태다. 이 정책은 어떤 룩업에도 등록돼 있지 않아 코드
 *   상수로 두었고, 룩업으로 옮기려면 관리자 메타 등록(배포 SQL)이 먼저 필요하다. 그 결정은 보고로
 *   남긴다. 비교 문자열은 .cs 원문과 SCM_ADM_USER_GR_M 실등록 명칭을 그대로 쓴다(공백·괄호 포함).
 *
 * 비교 값은 그룹 "이름"(USER_GR_NM)이다. session.groups 는 BE User.xml retrieveUserGroups 가
 *   SCM_ADM_USER_GR_M.USER_GR_NM 을 내려준 것이라 ADMIN 은 'System Administrator', DM ADMIN 은
 *   'DM Administrator' 로 들어온다. 종전에 예외 목록을 그룹 ID('ADMIN', 'DM ADMIN')로 적어 두 그룹을
 *   겸직한 계정(예: jaeuk.shin)까지 막혔다(2026-10-12 테스트 지적). ID 와 이름이 같은 그룹
 *   (SCP Planner, DM Planner, DM Planner (W/S))은 영향이 없었다. 세션이 ID 를 내려주게 바뀌어도
 *   깨지지 않도록 ID 표기도 함께 둔다.
 */
export const SCP_BLOCK_GROUP = 'SCP Planner';

export const SCP_BLOCK_EXEMPT_GROUPS = [
  'System Administrator', // USER_GR_ID 'ADMIN'
  'ADMIN',
  'DM Administrator', // USER_GR_ID 'DM ADMIN'
  'DM ADMIN',
  'DM Planner',
  'DM Planner (W/S)',
] as const;

/** 편집 전환이 막히는 사업부 — 앞 두 자리 비교(81_HD/81_HM 같은 하위 코드 포함, 82). */
export const SCP_BLOCK_DIVISION_PREFIXES = ['81', '82'] as const;

/**
 * 이 사용자가 SCP Planner 가드 대상인가.
 *   · 보유 그룹에 SCP Planner 가 있고 예외 그룹을 하나도 갖지 않을 때만 true.
 *   · 그룹 목록이 없으면(구버전 세션 저장분 등) 판정할 수 없으므로 막지 않는다 — AS-IS 도
 *     NowGroupID 가 SCP Planner 일 때만 막았다.
 */
export const isScpBlockedUser = (groups: readonly string[] | undefined): boolean => {
  if (!groups || groups.length === 0) return false;
  const set = new Set(groups.map(g => safeString(g).trim()));
  if (!set.has(SCP_BLOCK_GROUP)) return false;
  return !SCP_BLOCK_EXEMPT_GROUPS.some(g => set.has(g));
};

/** 사업부가 편집 차단 대상(81 계열·82)인가. */
export const isScpBlockedDivision = (divisionId: unknown): boolean => {
  const prefix = safeString(divisionId).trim().slice(0, 2);
  return (SCP_BLOCK_DIVISION_PREFIXES as readonly string[]).includes(prefix);
};

type EditLockRow = { DIVISION_ID?: unknown; EDIT_FLAG?: unknown };

/**
 * 가드 대상 사용자의 81·82 행을 EDIT_FLAG='N' 사본으로 바꾼다 — 공용 편집 판정(GridUtils.isEditableCell),
 * 저장 검증(useSaveWithValidation), 행 추가 가드(GridAction.addRow)가 모두 EDIT_FLAG 를 보므로 한 곳에서
 * 셀 편집·붙여넣기·저장이 함께 막힌다. 40 행과 가드 대상이 아닌 사용자의 행은 원본 참조 그대로 둔다.
 *   blocked=false 면 입력 배열을 그대로 돌려준다(참조 동일 — itemsSource 안정화 메모와 호환).
 */
export const applyScpEditLock = <T extends EditLockRow>(rows: T[], blocked: boolean): T[] => {
  if (!blocked) return rows;
  let changed = false;
  const next = rows.map(row => {
    if (!isScpBlockedDivision(row.DIVISION_ID) || safeString(row.EDIT_FLAG) === 'N') return row;
    changed = true;
    return { ...row, EDIT_FLAG: 'N' };
  });
  return changed ? next : rows;
};
