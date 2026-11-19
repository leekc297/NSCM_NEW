// SSP0014 사용자명 파생 — USER_ID/PART_LEADER/TEAM_LEADER 셀 직접 키인·붙여넣기 시 짝 이름 컬럼을
//   채운다. 팝업(SsoUserModal) 선택 경로(handleUserSelected)가 ID+이름을 동시에 세팅하는 것과
//   동일한 사용자 소스를 쓰기 위해 팝업과 같은 프로시저(COM0010/ssoUser, ssoUserYn='N' = 등록
//   사용자 SCM_ADM_USER_M)를 재사용한다 — user 파라미터로 조회 후 USER_ID 정확일치 행의 이름을 채택.
//   (AS-IS 부재 동작이 아니라 TO-BE 팝업 동작을 키인·삭제로 확장한 것 — 사용자 지시 2026-09-29.)

import { apiClient } from '@foundation/apis';
import { BUTTON_TYPE } from '@foundation/constants';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// USER_ID 조회 결과 상태:
//   - 'match'  : 정확히 일치하는 사용자 → 호출부가 짝 이름 컬럼을 언어(KO/EN)에 맞춰 세팅
//   - 'nomatch': 조회 성공했으나 일치 사용자 없음(잘못된 ID) 또는 ID 빈값(삭제) → 이름 비움
//   - 'defer'  : 조회 자체 실패(네트워크/인터셉터 throw) → 판단 보류(기존 이름 유지, console 금지)
export type UserNameLookup =
  | { status: 'match'; name: string }
  | { status: 'nomatch' }
  | { status: 'defer' };

/**
 * USER_ID 로 사용자명을 조회한다 — 팝업과 동일한 COM0010/ssoUser(SEARCH) 를 호출하고, USER_ID
 * 정확일치(대소문자 무시) 첫 행의 이름을 언어에 맞춰 반환한다(KO=USER_NM / 그 외=USER_ENG_NM,
 * handleUserSelected 와 동일 규칙). ID 가 비면 조회 없이 'nomatch'(호출부가 이름을 비운다).
 */
export const lookupUserName = async (userId: string, langCd: string): Promise<UserNameLookup> => {
  const id = str(userId).trim();
  if (!id) return { status: 'nomatch' };
  try {
    const res = await apiClient.callProc('COM0010', 'ssoUser', BUTTON_TYPE.SEARCH, {
      user: id,
      ssoUserYn: 'N',
    });
    const rows = res.result?.o_rc ?? [];
    const idu = id.toUpperCase();
    const exact = rows.find(r => str(r.USER_ID).toUpperCase() === idu);
    if (!exact) return { status: 'nomatch' };
    return { status: 'match', name: str(langCd === 'KO' ? exact.USER_NM : exact.USER_ENG_NM) };
  } catch {
    // 조회 실패(네트워크/인터셉터 throw) = 판단 보류 — 기존 이름 유지.
    return { status: 'defer' };
  }
};
