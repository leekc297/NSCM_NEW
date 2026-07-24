import { QueryClient, QueryCache, useIsFetching, useIsMutating } from '@tanstack/react-query';
import { type Persister, type PersistedClient } from '@tanstack/react-query-persist-client';
import { get, set, del } from 'idb-keyval';

export { PersistQueryClientProvider } from '@tanstack/react-query-persist-client';
export {
  type UseQueryOptions,
  QueryClientProvider,
  useQueryClient,
  useMutation,
  useQuery,
  useQueries,
  type UseQueryResult,
} from '@tanstack/react-query';

const SESSION_ID_KEY = 'rq-session-id';
let sessionId = sessionStorage.getItem(SESSION_ID_KEY);

if (!sessionId) {
  sessionId = Math.random().toString(36).substring(2, 9);
  sessionStorage.setItem(SESSION_ID_KEY, sessionId);
}

const IDB_STORAGE_KEY = `react-query-cache-${sessionId}`;

/**
 * 캐시 유지시간(8시간).
 * gcTime 과 PersistQueryClientProvider 의 persist maxAge 를 동일하게 유지해야
 * 영속화가 정상 동작한다(react-query: persist 하려면 gcTime >= maxAge 필요).
 * Providers.tsx 의 maxAge 로도 이 상수를 재사용한다.
 */
export const CACHE_MAX_AGE = 1000 * 60 * 60 * 8;

export const idbPersister: Persister = {
  persistClient: async (client: PersistedClient) => {
    await set(IDB_STORAGE_KEY, client);
  },
  restoreClient: async (): Promise<PersistedClient | undefined> => {
    const client = await get<PersistedClient>(IDB_STORAGE_KEY);
    return client;
  },
  removeClient: async () => {
    await del(IDB_STORAGE_KEY);
  },
};

window.addEventListener('unload', () => {
  void del(IDB_STORAGE_KEY);
});

/**
 * 조회(useQuery) 실패의 전역 핸들러.
 * 타임아웃/네트워크 오류 등은 개별 화면이 아니라 여기서 한 번에 사용자에게 알려야 한다.
 * foundation 은 UI(메시지 스토어)를 모르므로(레이어 규칙: foundation < shared < app)
 * 앱 레이어(Providers)에서 setQueryErrorHandler 로 주입한다.
 * 저장 계열(useProcMutation)은 자체 onError 알림이 있으므로 QueryCache 에만 적용.
 */
type QueryErrorHandler = (error: Error) => void;
let queryErrorHandler: QueryErrorHandler | undefined;
export const setQueryErrorHandler = (handler: QueryErrorHandler) => {
  queryErrorHandler = handler;
};

export const queryClient = new QueryClient({
  queryCache: new QueryCache({
    onError: error => queryErrorHandler?.(error),
  }),
  defaultOptions: {
    queries: {
      gcTime: CACHE_MAX_AGE, // 탭 전환으로 페이지가 unmount 돼도 이 시간 동안 캐시 유지(= persist maxAge)
      staleTime: Infinity, // 명시적 검색/저장(invalidateQueries) 시에만 갱신 → 탭 전환 시 DB 재조회 방지
      refetchOnWindowFocus: false,
      retry: 1,
      networkMode: 'offlineFirst',
    },
    mutations: {
      retry: 1,
    },
  },
});

export const useIsBusy = (key: string[]) => {
  const isFetching = useIsFetching({ queryKey: key }); // 현재 실행 중인 GET 쿼리 수
  const isMutating = useIsMutating({ mutationKey: key }); // 현재 실행 중인 POST/PUT/DELETE 수

  // 하나라도 0보다 크면 true를 반환
  return isFetching > 0 || isMutating > 0;
};
