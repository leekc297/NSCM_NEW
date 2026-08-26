import { i18n, I18nextProvider } from '@foundation/i18n';
import {
  queryClient,
  setQueryErrorHandler,
  PersistQueryClientProvider,
  idbPersister,
  shouldPersistQuery,
  CACHE_MAX_AGE,
} from '@foundation/query-client';
import { ThemeSwitchProvider } from '@shared/lges';
import { useMessageStore } from '@shared/stores';

// 조회(useQuery) 실패 전역 알림 — 타임아웃/네트워크 오류 등이 조용히 사라지지 않도록
// 공통 메시지 박스(Alert)로 노출한다. (저장 계열은 useProcMutation 자체 onError 가 담당)
setQueryErrorHandler(error => {
  void useMessageStore.getState().setAlert({ type: 'alert', content: error.message });
});

interface ProvidersProps {
  children: React.ReactNode;
}

export const Providers = ({ children }: ProvidersProps) => {
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
      <I18nextProvider i18n={i18n}>
        <ThemeSwitchProvider initialThemeMode='system'>{children}</ThemeSwitchProvider>
      </I18nextProvider>
    </PersistQueryClientProvider>
  );
};
