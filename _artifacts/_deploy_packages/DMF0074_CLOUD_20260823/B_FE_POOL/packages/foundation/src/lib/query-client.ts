import {
  QueryClient,
  QueryCache,
  useIsFetching,
  useIsMutating,
  defaultShouldDehydrateQuery,
  type Query,
} from '@tanstack/react-query';
import { type Persister, type PersistedClient } from '@tanstack/react-query-persist-client';
import { get, set, del, keys, delMany } from 'idb-keyval';

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

const IDB_KEY_PREFIX = 'react-query-cache-';
const IDB_STORAGE_KEY = `${IDB_KEY_PREFIX}${sessionId}`;

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

/**
 * 영속 캐시(IndexedDB) 레코드 삭제.
 *
 * 로그아웃 정리(useClearAppData)와 탭 종료 시 호출한다. 이 호출이 없으면 이전 계정의 그리드
 * 데이터가 담긴 레코드가 디스크에 남는다 — queryClient.clear() 가 removed 이벤트마다
 * PersistQueryClientProvider 구독자를 깨워 "빈 상태"를 덮어쓰긴 하지만, 그건 라이브러리
 * 부수효과라 레코드 자체는 사라지지 않는다.
 *
 * 필수: queryClient.clear() 보다 뒤에 호출한다. 순서가 바뀌면 clear() 가 유발한 write 가
 * 삭제된 레코드를 되살린다.
 */
export const clearPersistedCache = () => del(IDB_STORAGE_KEY);

/**
 * 남아있는 모든 세션의 영속 캐시 레코드 삭제 — 로그인 시점(useSessionStore.login) 정리용.
 *
 * 현재 세션 키만 지우면 소용이 없다. 캐시 키의 시드(rq-session-id)는 탭별 sessionStorage 라
 * 로그인하는 탭은 대개 새 키를 갖고, 정작 남아있는 건 크래시/탭 강제종료로 로그아웃 정리와
 * unload 핸들러를 모두 놓친 이전 세션의 레코드다. 그래서 prefix 로 전부 훑어 회수한다.
 *
 * 다른 탭이 열려 있으면 그 탭의 레코드도 지워진다 — 의도한 동작이다. 서버 세션은 쿠키 기반이라
 * 이 탭에서 새로 로그인하면 다른 탭의 신원도 함께 바뀌고, 거기 남은 캐시는 현재 신원과 다른
 * 사용자의 데이터가 된다. 그 탭은 메모리 캐시로 계속 동작하고 다음 캐시 이벤트에 레코드를 다시 쓴다.
 *
 * 금지: 앱 부팅 시점에 호출하지 말 것. 새로고침마다 돌아서 영속 복원이 죽고 캐시 영속화가 무의미해진다.
 */
export const clearAllPersistedCaches = async () => {
  const staleKeys = (await keys()).filter(
    (key): key is string => typeof key === 'string' && key.startsWith(IDB_KEY_PREFIX)
  );
  if (staleKeys.length === 0) return;
  await delMany(staleKeys);
};

// 탭 종료 시 정리. unload 중 비동기 IDB 트랜잭션은 완료가 보장되지 않으므로(bfcache/모바일/크래시)
// 이것만으로는 부족하다 — 로그아웃 경로에서도 clearPersistedCache 를 명시적으로 부른다.
window.addEventListener('unload', () => {
  void clearPersistedCache();
});

/**
 * 콤보/룩업 쿼리 키의 첫 요소. 이 둘만 아래 캐시 정책/영속 제외 대상이다.
 *
 * 배경: 콤보는 코드·마스터 데이터를 비추므로 그리드 proc 결과와 캐시 등급이 다르다.
 * 그런데 전역 기본값(staleTime: Infinity + gcTime 8h + IndexedDB 영속)을 그대로 상속하고
 * 콤보 키를 무효화하는 코드도 없어서, 한 번 받은 목록이 로그아웃 전까지 갱신되지 않았다.
 */
const VOLATILE_QUERY_PREFIXES = ['combo', 'lookup'] as const;

/**
 * 콤보/룩업 전용 캐시 정책 — useCustomQueryClient 의 콤보/룩업 훅에서 스프레드한다.
 *
 * staleTime: 0 = 화면을 새로 열 때(fresh mount)마다 다시 받는다. MDI 는 keep-alive 라
 * 이미 열린 탭은 리마운트되지 않으므로 탭 전환만으로는 요청이 나가지 않는다.
 * 즉 갱신 시점은 "탭을 닫았다 다시 열 때"와 "새로고침(영속 제외)" 두 가지다.
 *
 * gcTime 은 전역값(8h)을 그대로 쓴다. 탭을 다시 열면 캐시된 값으로 즉시 그리고
 * 뒤에서 재조회하므로 콤보가 빈 채로 깜빡이지 않는다.
 *
 * 주의: 훅에서 스프레드할 때 반드시 호출부의 queryOptions 보다 앞에 둔다. 순서가 바뀌면
 * 화면이 넘긴 staleTime 재정의가 조용히 무시된다.
 */
export const VOLATILE_QUERY_OPTIONS = { staleTime: 0 } as const;

const isVolatileQueryKey = (queryKey: readonly unknown[]) =>
  (VOLATILE_QUERY_PREFIXES as readonly unknown[]).includes(queryKey[0]);

/**
 * IndexedDB 영속 대상 필터(PersistQueryClientProvider 의 dehydrateOptions).
 * 기본 규칙(성공한 쿼리만 영속)은 유지하고, 콤보/룩업만 제외한다.
 * 제외하지 않으면 새로고침해도 옛날 콤보가 복원돼 위 staleTime 설정이 무의미해진다.
 */
export const shouldPersistQuery = (query: Query) =>
  defaultShouldDehydrateQuery(query) && !isVolatileQueryKey(query.queryKey);

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
