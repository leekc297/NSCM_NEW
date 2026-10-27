import type { UserSession } from '../models';

/**
 * SP 의 `p_time_zone`(또는 콤보 `@timeZone`) 인자로 보낼 사용자 타임존 코드.
 *
 * AS-IS 는 로그인 때 `TB_FX_User.TimeZone` 을 `UserInfoContext` 에 담아 모든 저장 SP 에
 *   `p_time_zone` 으로 넘겼다. TO-BE 는 세션에 타임존 필드가 없던 시절 `timeZone: ''` 로
 *   하드코딩했고, 2026-10-26 `UserSession.tmzCd`(SCM_ADM_USER_M.TMZ_CD — 헤더 Personal
 *   Setting 으로 변경, 커밋 05397544) 가 들어오면서 그 잔여를 걷어냈다.
 *
 * 변환은 전부 Oracle `FN_MULTY_TIME(코드)` 하나가 한다 — UTC + offset(+서머타임).
 *   코드별 offset·서머타임 규칙은 `SCM_ADM_LOOKUP_MASTER_DETAIL`(LOOKUP_TYPE='TIME_ZONE')
 *   의 ATTRIBUTE 컬럼에서 읽는다 — 함수에 하드코딩된 CASE 가 아니라 **데이터 구동**이다.
 *   그래서 타임존이 추가되면 FE·SP 코드 변경 없이 lookup 등록만으로 동작한다.
 *   여기서 코드 화이트리스트를 두면 그 신규 코드를 FE 가 거꾸로 막는다 — 그래서 통과시킨다.
 *
 * DB 실측(2026-10-26 12:17 KST 기준):
 *   AM073 America/USA    → 2026-10-25 23:17 (-5, DST)
 *   AS054 Asia/Korea     → 2026-10-26 12:17 (+9, = SYSDATE)
 *   AS055 Asia/China     → 2026-10-26 11:17 (+8)
 *   EU042 Europe/Poland  → 2026-10-26 04:17 (+1, DST)
 *   NULL·공란            → 2026-10-26 12:17 (= AS054 한국)
 *
 * 빈 문자열 폴백은 **안전하다** — FN_MULTY_TIME 본문 30행이 `NVL(P_TIME_ZONE,'AS054')` 이고,
 *   Oracle 에서 빈 문자열은 NULL 이므로 종전 하드코딩 동작(한국 기준)과 정확히 같다.
 *   즉 세션에 tmzCd 가 아직 없는 사용자도 동작이 바뀌지 않는다.
 */
export const sessionTimeZone = (session: Pick<UserSession, 'tmzCd'> | undefined): string =>
  session?.tmzCd ?? '';
