import { API_CONFIG } from '@foundation/constants';

// 운영(VITE_ENV=prod)은 SSO 로만 로그인한다. 미로그인 사용자는 ID 로그인 폼 대신 SSO 로 보낸다.
// 운영 ID 로그인 입구(백도어)는 없앴다(사용자 지시 2026-11-09). BE 도 prd 에서 /user/login 을 막는다(config-prd.yml).
// local/dev/stage 는 기존처럼 홈에서 ID 로그인 폼을 쓴다.
export const IS_SSO_ONLY = import.meta.env.VITE_ENV === 'prod';

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
 * 부팅 시 서버 세션이 없을 때 호출한다. 운영이면 SSO 로 보낸다.
 * 주의: 부팅 때만 자동으로 보낸다. 로그아웃 직후에도 보내면 SSO 쿠키로 곧바로 재로그인되어 로그아웃이 안 된다.
 * 반복 한도에 걸리면 보내지 않고, 홈의 SSO 로그인 버튼으로 수동 진입하게 둔다.
 */
export const redirectToSsoOnBoot = () => {
  if (!IS_SSO_ONLY) return;
  if (!passRedirectGuard()) return;
  goSsoLogin();
};
