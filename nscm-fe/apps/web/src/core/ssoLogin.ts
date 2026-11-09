import { API_CONFIG } from '@foundation/constants';

// 운영(VITE_ENV=prod)은 SSO 가 정문이다. 미로그인 사용자는 ID 로그인 폼 대신 SSO 로 보낸다.
// ID 로그인 폼은 BACKDOOR_PATH 에서만 노출한다. 짐작하기 어렵게 /backdoor 대신 무작위 문자열을 쓴다(사용자 지시 2026-11-06).
// 주의: 주소만 분리했고 IP 제한은 없다(사용자 지시 2026-11-05). 주소는 JS 번들에 그대로 들어가므로 비밀이 아니다.
// local/dev/stage 는 기존처럼 홈에서 ID 로그인 폼을 쓴다.
export const IS_SSO_ONLY = import.meta.env.VITE_ENV === 'prod';

export const BACKDOOR_PATH = '/k7q2m9';

// BE SSO 진입점. SSO 쿠키가 없으면 SSO 포탈 로그인으로, 있으면 세션 생성 후 FE 로 redirect 한다.
const SSO_LOGIN_URL = `${API_CONFIG.BASE_URL}/sso/login_exec`;

// 무한 redirect 방지. SSO 를 다녀왔는데도 세션이 안 잡히면(쿠키 미전달 등) 짧은 시간에 반복된다.
const REDIRECT_GUARD_KEY = 'sso-redirect-guard';
const REDIRECT_GUARD_WINDOW_MS = 30 * 1000;
const REDIRECT_GUARD_MAX = 2;

export const goSsoLogin = () => {
  globalThis.window.location.assign(SSO_LOGIN_URL);
};

const passRedirectGuard = (): boolean => {
  const now = Date.now();
  let history: number[] = [];
  try {
    history = (JSON.parse(sessionStorage.getItem(REDIRECT_GUARD_KEY) ?? '[]') as number[]).filter(
      time => now - time < REDIRECT_GUARD_WINDOW_MS
    );
  } catch {
    history = [];
  }
  if (history.length >= REDIRECT_GUARD_MAX) return false;
  sessionStorage.setItem(REDIRECT_GUARD_KEY, JSON.stringify([...history, now]));
  return true;
};

/**
 * 부팅 시 서버 세션이 없을 때 호출한다. 운영이고 BACKDOOR_PATH 가 아니면 SSO 로 보낸다.
 * 주의: 부팅 때만 자동으로 보낸다. 로그아웃 직후에도 보내면 SSO 쿠키로 곧바로 재로그인되어 로그아웃이 안 된다.
 * 반복 한도에 걸리면 보내지 않고, 홈의 SSO 로그인 버튼으로 수동 진입하게 둔다.
 */
export const redirectToSsoOnBoot = () => {
  if (!IS_SSO_ONLY) return;
  if (globalThis.window.location.pathname === BACKDOOR_PATH) return;
  if (!passRedirectGuard()) return;
  goSsoLogin();
};
