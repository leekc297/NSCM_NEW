import { QueryClient, useIsFetching, useIsMutating } from '@tanstack/react-query';
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

export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      gcTime: 1000 * 60 * 60, // 메모리 유지시간 5분
      staleTime: Infinity, // 항상 stale한것으로 간주
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
