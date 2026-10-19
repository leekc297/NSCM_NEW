import { useEffect } from 'react';

import { apiClient } from '@foundation/apis';
import { i18n, I18nextProvider } from '@foundation/i18n';
import type { UserSession } from '@foundation/models';
import {
  queryClient,
  setQueryErrorHandler,
  QueryClientProvider,
  PersistQueryClientProvider,
  idbPersister,
  shouldPersistQuery,
  CACHE_MAX_AGE,
} from '@foundation/query-client';
import { ThemeSwitchProvider } from '@shared/lges';
import { useMessageStore, useSessionStore } from '@shared/stores';

// 공통 캐시(IndexedDB 영속화) 사용 여부. 테스트를 위해 임시로 끈 상태다.
// true 로 되돌리면 PersistQueryClientProvider 로 IndexedDB persist/restore 가 다시 붙는다.
// false 면 인메모리 쿼리 캐시만 남고 IndexedDB 읽기/쓰기는 일어나지 않는다.
const PERSIST_CACHE_ENABLED: boolean = false;

// 세션 만료 처리 — 두 경로가 하나의 플로우(processAuthFailure)를 공유한다:
//   (1) 유휴 확인(useIdleSessionCheck): 서버 세션은 8시간 무활동에 만료된다(MSG01146). 사용자
//       활동마다 타이머를 리셋하고, 8시간 무활동에 도달하면 세션을 확인해 로그인 화면으로 유도한다.
//       주의: 서버를 주기적으로 찌르지 않는다 — 그러면 유휴 타이머가 리셋돼 만료 자체가 안 일어난다.
//   (2) 반응형(401): 조회가 401 을 던지면 즉시 확인한다. 단 401 이 곧 세션 만료는 아니다 —
//       진짜 인가 실패(권한 없음)도 401 이라, 세션을 실제로 확인해 분기한다.
//   세션이 끊겼으면 MSG01146 → 로그인 화면(서버 세션 종료 + 로컬 정리 + '/' 재이동).
//   세션이 살아있으면(=권한 문제) 로그아웃하지 않고 오류만 알린다.
//   동시 다발(콤보·컬럼 401 폭주 / 유휴 확인 겹침)에 안내가 여러 번 뜨지 않도록 1회 가드한다.
const SESSION_IDLE_TIMEOUT_MS = 8 * 60 * 60 * 1000; // 서버 세션 유휴 만료(8시간)와 동일

let handlingAuthError = false;

// 인터셉터가 401 을 그대로 reject 하므로(axios-interceptors default 분기) 여기엔 AxiosError 가 온다.
// axios 를 직접 의존하지 않고 response.status 만 본다.
const isUnauthorized = (error: Error): boolean =>
  (error as { response?: { status?: number } }).response?.status === 401;

// 세션 살아있는지 실제 확인. /user/session 은 useQuery 가 아니라 직접 호출이라 이 핸들러를
// 재귀로 다시 트리거하지 않는다. 요청 자체가 실패(세션 없음)하면 catch 로 false.
const isSessionAlive = async (): Promise<boolean> => {
  try {
    const res = await apiClient.get<UserSession>('/user/session');
    return !!res.data?.result?.userId;
  } catch {
    return false;
  }
};

// 세션 확인 → 끊겼으면 로그인 화면 유도. message 가 있으면(401 반응 경로) 세션이 살아있을 때
// 권한 오류로 그 메시지를 알린다. 주기 확인 경로는 message 없이 호출한다(세션 정상이면 무동작).
const processAuthFailure = async (message?: string): Promise<void> => {
  if (handlingAuthError) return;
  handlingAuthError = true;
  try {
    if (await isSessionAlive()) {
      // 세션 유효 → 세션 만료가 아니라 권한/인가 문제. 로그아웃하지 않는다.
      if (message) void useMessageStore.getState().setAlert({ type: 'alert', content: message });
      return;
    }
    // 통보문(질문 아님)이라 alert(확인 버튼만) — 확인을 누르면 로그인 화면으로 보낸다.
    await useMessageStore.getState().setAlert({
      type: 'alert',
      content: i18n.t('MSG01146', '_8시간 동안 이벤트가 없어 SCM 세션이 끊겼습니다.'),
    });
    await useSessionStore.getState().logout(); // 서버 세션 종료(실패해도 로컬은 로그아웃)
    sessionStorage.clear(); // 영속 세션/열린 탭 제거 → 재로드 후 로그인 폼 노출
    globalThis.window.location.assign('/'); // 홈(미로그인 시 로그인 화면)으로 전체 재이동
  } finally {
    handlingAuthError = false;
  }
};

// 유휴 세션 확인 — 로그인 중일 때만. 사용자 활동마다 8시간 타이머를 리셋하고, 8시간 무활동에
// 도달하면 세션을 확인한다(끊겼으면 로그인 유도, 살아있으면 무동작). 서버를 주기적으로 찌르지
// 않으므로 서버의 유휴 만료를 방해하지 않는다.
const useIdleSessionCheck = () => {
  const isLogin = useSessionStore(state => state.isLogin);
  useEffect(() => {
    if (!isLogin) return;
    let timer = 0;
    const arm = () => {
      globalThis.window.clearTimeout(timer);
      timer = globalThis.window.setTimeout(() => void processAuthFailure(), SESSION_IDLE_TIMEOUT_MS);
    };
    // 사용자 활동(= 서버로 요청을 유발하는 조작)마다 유휴 타이머 리셋.
    const events: Array<keyof WindowEventMap> = ['pointerdown', 'keydown'];
    events.forEach(e => globalThis.window.addEventListener(e, arm, { passive: true }));
    arm();
    return () => {
      globalThis.window.clearTimeout(timer);
      events.forEach(e => globalThis.window.removeEventListener(e, arm));
    };
  }, [isLogin]);
};

// 조회(useQuery) 실패 전역 처리 — 401 은 세션/권한 판별, 그 외(타임아웃/네트워크 등)는 공통 Alert.
// (저장 계열은 useProcMutation 자체 onError 가 담당)
setQueryErrorHandler(error => {
  if (isUnauthorized(error)) {
    void processAuthFailure(error.message);
    return;
  }
  void useMessageStore.getState().setAlert({ type: 'alert', content: error.message });
});

interface ProvidersProps {
  children: React.ReactNode;
}

export const Providers = ({ children }: ProvidersProps) => {
  // i18next 언어 = 세션 langCd 단방향 동기화. 언어 버튼(useSessionStore.changeLanguage)은
  // 서버 세션/DB 의 langCd 만 바꾸고 fetchSession 으로 스토어를 갱신할 뿐이라,
  // 실제 리소스 전환(DB /admin/message → SCM_ADM_MSG_M 재로드, i18n.ts backend.request)은
  // 여기서만 일어난다. 정적 public/locales/*.json 은 런타임에서 참조하지 않는다(사용자 지시 2026-09-29).
  // 로그인 직후 / 새로고침(sessionStorage rehydrate) / 언어 변경 세 경로가 모두 이 한 곳을 탄다.
  // 주의: i18n init 에 lng 옵션도 LanguageDetector 도 없어 초기 언어는 항상 fallbackLng('KO') 다.
  //   따라서 새로고침 뒤에도 이 effect 가 세션 언어로 다시 되돌려 놓아야 한다.
  const langCd = useSessionStore(state => state.session?.langCd);
  useEffect(() => {
    if (langCd && i18n.language !== langCd) void i18n.changeLanguage(langCd);
  }, [langCd]);

  // 부팅 시 서버 세션을 진실로 삼아 세션/메뉴를 재취득한다 — 메뉴 취득을 로그인 액션과 분리.
  // - 서버 세션 생존(쿠키): sessionStorage 유무와 무관하게 isLogin=true + 최신 권한 메뉴로 갱신
  //   (새 탭/브라우저 재시작에도 로그인 유지, 권한 변경분 반영)
  // - 서버 세션 없음: isLogin=false → 로그인 폼 (만료 세션의 스테일 isLogin=true 도 여기서 정리)
  useEffect(() => {
    void useSessionStore.getState().fetchSession();
  }, []);

  // 유휴 세션 확인 — 8시간 무활동이면 서버 세션이 끊기므로, 그 시점에 확인해 로그인 화면으로 유도한다.
  useIdleSessionCheck();

  const inner = (
    <I18nextProvider i18n={i18n}>
      <ThemeSwitchProvider initialThemeMode='system'>{children}</ThemeSwitchProvider>
    </I18nextProvider>
  );

  // 공통 캐시 비활성 — IndexedDB persist/restore 없이 인메모리 쿼리 캐시만 사용한다.
  if (!PERSIST_CACHE_ENABLED) {
    return <QueryClientProvider client={queryClient}>{inner}</QueryClientProvider>;
  }

  return (
    <PersistQueryClientProvider
      client={queryClient}
      persistOptions={{
        persister: idbPersister,
        maxAge: CACHE_MAX_AGE,
        // 콤보/룩업은 영속 제외 — 새로고침하면 항상 서버에서 다시 받는다. shouldPersistQuery 주석 참고.
        dehydrateOptions: { shouldDehydrateQuery: shouldPersistQuery },
      }}
    >
      {inner}
    </PersistQueryClientProvider>
  );
};
