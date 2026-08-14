// ⭐ SDM1010 권한관리 팝업 — 리스트 조작·요청 처리 순수함수 (테스트 대상. 설계서 '권한관리 팝업' 기능상세)
//   ⭐ 신본 계약 (§8~§13 — 2026-08-13 재배선):
//   - 도메인 = WRITE(입력)/READ(조회) (구 I/R 폐지). 리스트 행 = §8/§9 커서 7컬럼 (DPJT_AUTH_TYPE 컬럼
//     없음 — 소속 리스트가 곧 권한 유형).
//   - 저장 = replace-set (§11/§12): OK 시 각 리스트의 **최종 USER_ID 전체 목록** '^' 전달 —
//     포함=CONFIRM(요청 승인 = 목록에 넣어 저장) / 요청자 제외=REJECT / 무요청 제외=NULL 소거.
//   - 반려 = §13 단건 (dpjtKey+userId) 반복 — decisions 의 REJECT 목록.
//   - 요청 행 식별 = USER_ID (§10 커서 — REQ_SEQ 없음. dpjtKey 스코프 내 유일).
//   pending 원칙: 모든 조작은 로컬 리스트/결정만 변경, OK 시점 SP 확정 (설계 2.2.1/2.3.1).
import { AUTH_TYPE, MSG, REQ_DECISION, type ReqDecision } from '../project-reg.constants';
import type { Pop1AuthRow, Pop1ReqRow, Pop1UserRow } from '../project-reg.types';

// 권한 도메인 (ADMIN 은 §11·§12 MERGE 보호 대상 — 모달 편집 불가·리스트 비노출)
export type AuthDomain = typeof AUTH_TYPE.WRITE | typeof AUTH_TYPE.READ;

export interface AuthDecision {
  status: ReqDecision;
  /** APPROVE 시 부여 도메인 — 목업 [✓입력][✓조회] (요청과 다른 권한 승인 허용, 설계 2.4) */
  authType?: AuthDomain;
}
// key = USER_ID (§10 요청 행 식별자)
export type DecisionMap = Record<string, AuthDecision>;

export interface ListOpResult {
  ok: boolean;
  msgId?: string;
  inputList: Pop1AuthRow[];
  readList: Pop1AuthRow[];
  decisions: DecisionMap;
}

// 요청 승인으로 추가된 pending 행 식별 필드 (결정 변경 시 원복용 — 값 = 요청자 USER_ID)
const REQ_USER_FIELD = '_reqUser';

const userOf = (row: { USER_ID?: unknown }): string => String(row.USER_ID ?? '');

// 사용자/요청 행 → 리스트 행 (§8/§9 커서 형상 — DPJT_KEY 는 pending 추가분에선 빈 값,
//   OK payload 는 USER_ID 만 소비하므로 무해)
export const toAuthRow = (
  u: Pick<Pop1UserRow, 'USER_ID' | 'USER_NAME' | 'JOB_CODE' | 'JOB_NAME' | 'DEPT_ID' | 'DEPT_NAME'> & {
    DPJT_KEY?: string;
  },
  reqUser?: string
): Pop1AuthRow =>
  ({
    DPJT_KEY: String(u.DPJT_KEY ?? ''),
    USER_ID: String(u.USER_ID ?? ''),
    USER_NAME: String(u.USER_NAME ?? ''),
    JOB_CODE: String(u.JOB_CODE ?? ''),
    JOB_NAME: String(u.JOB_NAME ?? ''),
    DEPT_ID: String(u.DEPT_ID ?? ''),
    DEPT_NAME: String(u.DEPT_NAME ?? ''),
    ...(reqUser ? { [REQ_USER_FIELD]: reqUser } : {}),
  }) as Pop1AuthRow;

// (+) — 체크 사용자를 대상 리스트에 추가 (중복 = MSG00716/717, 설계 메시지 코드)
export const addUsersToList = (
  state: { inputList: Pop1AuthRow[]; readList: Pop1AuthRow[]; decisions: DecisionMap },
  users: Pop1UserRow[],
  domain: AuthDomain
): ListOpResult => {
  const isWrite = domain === AUTH_TYPE.WRITE;
  const target = isWrite ? state.inputList : state.readList;
  if (users.length === 0) return { ...state, ok: false, msgId: MSG.NO_CHECKED };
  const existing = new Set(target.map(userOf));
  if (users.some(u => existing.has(userOf(u)))) {
    return { ...state, ok: false, msgId: isWrite ? MSG.AUTH_INPUT_DUP : MSG.AUTH_READ_DUP };
  }
  const added = [...target, ...users.map(u => toAuthRow(u))];
  return {
    ...state,
    ok: true,
    inputList: isWrite ? added : state.inputList,
    readList: isWrite ? state.readList : added,
  };
};

// (−) — 체크 행 리스트에서 제외 (요청 승인 추가분이면 결정도 원복.
//   ⚠ 기존 권한자 제외 확정은 OK 시 replace-set 이 처리 — 목록에서 빠지면 서버가 소거/반려 §11·§12)
export const removeUsersFromList = (
  state: { inputList: Pop1AuthRow[]; readList: Pop1AuthRow[]; decisions: DecisionMap },
  picked: Pop1AuthRow[],
  domain: AuthDomain
): ListOpResult => {
  const isWrite = domain === AUTH_TYPE.WRITE;
  const target = isWrite ? state.inputList : state.readList;
  if (picked.length === 0) return { ...state, ok: false, msgId: MSG.NO_CHECKED };
  const pickedSet = new Set(picked);
  const nextDecisions = { ...state.decisions };
  picked.forEach(r => {
    const reqUser = String((r as Record<string, unknown>)[REQ_USER_FIELD] ?? '');
    if (reqUser !== '' && nextDecisions[reqUser]?.status === REQ_DECISION.APPROVE) {
      delete nextDecisions[reqUser];
    }
  });
  const next = target.filter(r => !pickedSet.has(r));
  return {
    ok: true,
    decisions: nextDecisions,
    inputList: isWrite ? next : state.inputList,
    readList: isWrite ? state.readList : next,
  };
};

// ∨∧ — 입력↔조회 리스트 간 이동 (도착 리스트 중복 가드 — 소속 리스트가 권한 유형이므로 행 필드 무변경)
export const moveUsersBetweenLists = (
  state: { inputList: Pop1AuthRow[]; readList: Pop1AuthRow[]; decisions: DecisionMap },
  picked: Pop1AuthRow[],
  toDomain: AuthDomain
): ListOpResult => {
  const toWrite = toDomain === AUTH_TYPE.WRITE;
  const from = toWrite ? state.readList : state.inputList;
  const to = toWrite ? state.inputList : state.readList;
  if (picked.length === 0) return { ...state, ok: false, msgId: MSG.NO_CHECKED };
  const existing = new Set(to.map(userOf));
  if (picked.some(r => existing.has(userOf(r)))) {
    return { ...state, ok: false, msgId: toWrite ? MSG.AUTH_INPUT_DUP : MSG.AUTH_READ_DUP };
  }
  const pickedSet = new Set(picked);
  const nextFrom = from.filter(r => !pickedSet.has(r));
  const nextTo = [...to, ...picked];
  return {
    ...state,
    ok: true,
    inputList: toWrite ? nextTo : nextFrom,
    readList: toWrite ? nextFrom : nextTo,
  };
};

// 요청 처리 버튼 — [✓입력]/[✓조회] 승인(해당 리스트 pending 추가 — OK 시 목록 포함 저장=CONFIRM §11)
//   / [x반려](OK 시 §13 단건 호출). 결정 변경 시 이전 승인 추가분 원복.
//   중복(승인 대상 리스트 기존재) = MSG00716/717 + 결정 미변경.
export const applyRequestDecision = (
  state: { inputList: Pop1AuthRow[]; readList: Pop1AuthRow[]; decisions: DecisionMap },
  req: Pop1ReqRow,
  act: AuthDomain | 'REJECT'
): ListOpResult => {
  const reqUser = userOf(req);
  if (reqUser === '') return { ...state, ok: false };
  // ① 이전 pending 승인 추가분 제거 (동일 요청자 마킹 행)
  const strip = (list: Pop1AuthRow[]) =>
    list.filter(r => String((r as Record<string, unknown>)[REQ_USER_FIELD] ?? '') !== reqUser);
  const inputList = strip(state.inputList);
  const readList = strip(state.readList);
  const decisions = { ...state.decisions };

  if (act === 'REJECT') {
    decisions[reqUser] = { status: REQ_DECISION.REJECT };
    return { ok: true, inputList, readList, decisions };
  }
  // ② 승인 — 부여 도메인 리스트에 pending 추가 (중복 가드)
  const isWrite = act === AUTH_TYPE.WRITE;
  const target = isWrite ? inputList : readList;
  if (target.some(r => userOf(r) === reqUser)) {
    // 결정/리스트 원상 유지 (이전 상태 그대로 반환)
    return { ...state, ok: false, msgId: isWrite ? MSG.AUTH_INPUT_DUP : MSG.AUTH_READ_DUP };
  }
  const added = [...target, toAuthRow(req, reqUser)];
  decisions[reqUser] = { status: REQ_DECISION.APPROVE, authType: act };
  return {
    ok: true,
    decisions,
    inputList: isWrite ? added : inputList,
    readList: isWrite ? readList : added,
  };
};

// OK 페이로드 ①② — 리스트별 최종 USER_ID 목록 (replace-set §11/§12 — 중복·빈 값 제거,
//   '^' join 은 api 헬퍼 담당. USER_ID 는 항상 값 = 빈 토큰 행밀림 없음)
export const buildAuthUserIds = (list: Pop1AuthRow[]): string[] => {
  const seen = new Set<string>();
  const out: string[] = [];
  for (const r of list) {
    const id = userOf(r);
    if (id === '' || seen.has(id)) continue;
    seen.add(id);
    out.push(id);
  }
  return out;
};

// OK 페이로드 ③ — 반려 대상 USER_ID 목록 (§13 단건 반복 호출용. 승인은 목록 포함이 곧 확정 — 미동봉)
export const buildRejectUserIds = (decisions: DecisionMap): string[] =>
  Object.entries(decisions)
    .filter(([, d]) => d.status === REQ_DECISION.REJECT)
    .map(([userId]) => userId);
