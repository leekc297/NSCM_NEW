import { useEffect } from 'react';

import { i18n, I18nextProvider } from '@foundation/i18n';
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

// 조회(useQuery) 실패 전역 알림 — 타임아웃/네트워크 오류 등이 조용히 사라지지 않도록
// 공통 메시지 박스(Alert)로 노출한다. (저장 계열은 useProcMutation 자체 onError 가 담당)
setQueryErrorHandler(error => {
  void useMessageStore.getState().setAlert({ type: 'alert', content: error.message });
});

interface ProvidersProps {
  children: React.ReactNode;
}

export const Providers = ({ children }: ProvidersProps) => {
  // i18next 언어 = 세션 langCd 단방향 동기화. 언어 버튼(useSessionStore.changeLanguage)은
  // 서버 세션/DB 의 langCd 만 바꾸고 fetchSession 으로 스토어를 갱신할 뿐이라,
  // 실제 리소스 전환(/locales/{lng}.json 재로드)은 여기서만 일어난다.
  // 로그인 직후 / 새로고침(sessionStorage rehydrate) / 언어 변경 세 경로가 모두 이 한 곳을 탄다.
  // 주의: i18n init 에 lng 옵션도 LanguageDetector 도 없어 초기 언어는 항상 fallbackLng('KO') 다.
  //   따라서 새로고침 뒤에도 이 effect 가 세션 언어로 다시 되돌려 놓아야 한다.
  const langCd = useSessionStore(state => state.session?.langCd);
  useEffect(() => {
    if (langCd && i18n.language !== langCd) void i18n.changeLanguage(langCd);
  }, [langCd]);

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
