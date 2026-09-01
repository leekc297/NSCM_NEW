/* @refresh reload */
import { useRef, useLayoutEffect, useCallback } from 'react';

import { apiClient } from '@foundation/apis';
import { BUTTON_TYPE } from '@foundation/constants';
import type { ComboParam, LookupParam, ComboResponse, LookupResponse } from '@foundation/models';
import {
  useQuery,
  useMutation,
  useQueryClient,
  useQueries,
  VOLATILE_QUERY_OPTIONS,
} from '@foundation/query-client';
import type { UseQueryOptions } from '@foundation/query-client';
import { useMessageStore, useSessionStore } from '@shared/stores';

/**
 * combo 캐시 키에 붙일 세션 스코프. 세션이 없으면(로그인 전 / 로그아웃 직후) null.
 *
 * 서버는 combo SQL(SCM_ADM_CMBO_SQL_M)의 @sesUserId / @sesLangCd 를 로그인 세션 값으로 치환해
 * 결과를 만든다(LookupServiceImpl.retrieveCombo). 즉 같은 comboId 라도 계정/언어가 다르면 결과가 다르다.
 * 전역 기본값이 staleTime: Infinity + gcTime 8h + IndexedDB 영속이라, 키에 계정이 없으면
 * 재로그인 후에도 이전 계정의 combo 가 그대로 서빙된다. 그래서 키를 세션 단위로 분리한다.
 *
 * 세션이 없을 때 null 인 이유 — 로그아웃은 세션을 비우는데(useSessionStore.logout), MDI 는
 * keep-alive 라 그 순간에도 화면(DataGrid)이 마운트된 채로 남아 있다. 스코프가 빈 문자열이면
 * 그것도 유효한 키라서 콤보 전부가 캐시 미스 → 컬럼 수만큼 즉시 재조회되고, 서버 세션은 이미
 * 끊긴 뒤라 전부 401 이 된다(retry:1 이라 요청은 2배, 전역 onError 알림까지 뜬다).
 * 세션 없이는 애초에 조회할 값이 없으므로 스코프를 null 로 두고 아래에서 enabled 를 막는다.
 */
const useComboScope = () =>
  useSessionStore(state =>
    state.session?.userId ? `${state.session.userId}:${state.session.langCd ?? ''}` : null
  );

const buildComboQueryKey = (scope: string, param: ComboParam) =>
  ['combo', scope, { ...param }] as const;

const toComboParam = (filter: ComboParam | string): ComboParam =>
  typeof filter === 'string' ? { comboId: filter } : filter;

const buildTabQueryKey = <M extends MenuId, S extends SheetName<M>>(
  tabId: string,
  sheetName: S,
  procedureAction: BUTTON_TYPE | '',
  filters?: ProcRequest<M, S> | ComboParam | LookupParam
) => [tabId, sheetName, procedureAction, { ...filters }] as const;

// react-query 기본 해시(hashKey)와 동일한 방식(객체 key 정렬 후 직렬화)으로 두 쿼리 키가
// 같은 캐시 엔트리로 해시되는지 판정한다 — 참조는 달라도 값이 같으면 true.
const stableStringify = (value: unknown): string =>
  JSON.stringify(value, (_key: string, val: unknown): unknown =>
    val && typeof val === 'object' && !Array.isArray(val)
      ? Object.keys(val as Record<string, unknown>)
          .sort()
          .reduce<Record<string, unknown>>((acc, k) => {
            acc[k] = (val as Record<string, unknown>)[k];
            return acc;
          }, {})
      : val
  );

/**
 * filters 는 매 렌더 새로 만들지 말 것 — 아래 useLayoutEffect 는 filters 참조가 바뀌면
 * 값이 같아도 "사용자가 재조회했다"로 판정해 캐시를 비운다. store selector / useState 값 /
 * useMemo / 모듈 상수처럼 실제 조건이 바뀔 때만 참조가 바뀌는 값을 넘길 것 — 렌더 본문에
 * 객체·배열 리터럴을 직접 써서 넘기지 말 것.
 */
export const useTabProcQuery = <M extends MenuId, S extends SheetName<M> = SheetName<M>>({
  menuId,
  sheetName,
  procedureAction = BUTTON_TYPE.SEARCH,
  tabId,
  filters,
  enabled = false,
  queryOptions,
}: {
  menuId: M;
  sheetName: S;
  procedureAction?: BUTTON_TYPE;
  tabId: string;
  filters?: ProcRequest<M, S>;
  enabled?: boolean;
  queryOptions?: Omit<UseQueryOptions<ProcResponse<M, S>>, 'queryKey' | 'queryFn'>;
}) => {
  const { t } = useTranslation();
  const { setAlert } = useMessageStore.getState();

  const queryKey = buildTabQueryKey(tabId, sheetName, procedureAction, filters ?? {});
  const queryClient = useQueryClient();
  const prevKeyRef = useRef(filters);
  const tabIdRef = useRef(tabId);

  const queryResult = useQuery<ProcResponse<M, S>>({
    queryKey, // eslint-disable-line tanstack-query/exhaustive-deps
    queryFn: async () => {
      const response = await apiClient.callProc<M, S>(menuId, sheetName, procedureAction, filters);
      if (response.code !== '0')
        void setAlert({
          type: 'alert',
          content: response.message ?? t('', '_데이터 조회 실패.'),
        });
      return response.result;
    },
    enabled: enabled,
    persister: queryOptions?.persister ?? undefined,
    ...queryOptions,
  });

  // ⚠️ useLayoutEffect(passive useEffect 아님) — 아래 removeQueries 가 트리거하는 재렌더가
  //   브라우저 페인트 전에 반영되어야, 동일 조건 재조회 시 옛 rows 가 한 프레임이라도 그려지지
  //   않고 조건 변경 재조회와 동일하게 "비었다가 채워짐"으로 보인다.
  useLayoutEffect(() => {
    if (tabIdRef.current !== tabId) {
      tabIdRef.current = tabId;
      return;
    }
    if (prevKeyRef.current === filters) return;

    const prevQueryKey = buildTabQueryKey(tabId, sheetName, procedureAction, prevKeyRef.current ?? {});
    const isSameConditions = stableStringify(prevQueryKey) === stableStringify(queryKey);

    if (isSameConditions) {
      // 동일 조건 재조회 — filters 참조는 매 Search 마다 바뀌지만 값은 같아 queryKey 해시가
      // 이전과 동일하다. react-query 는 같은 queryKey 재조회 시 이전 data 를 유지한 채
      // 백그라운드로만 갱신해 옛 rows 가 잠깐 남아있다가 스왑된다. 캐시를 완전히 비워
      // 조건 변경 재조회(다른 queryKey)와 동일하게 그리드가 비었다가 새로 채워지게 한다.
      queryClient.removeQueries({ queryKey: prevQueryKey, exact: true });
    } else {
      // 조건이 실제로 바뀐 경우 — 더 이상 관측되지 않는 이전 조건 캐시만 정리(기존 동작).
      //   재방문 시 캐시된 값을 먼저 보여주고 백그라운드로 갱신하는 동작은 그대로 유지한다.
      void queryClient.invalidateQueries({ queryKey: prevQueryKey, exact: false });
    }

    prevKeyRef.current = filters;
  }, [filters, queryClient]);

  return queryResult;
};

export const useProcMutation = <
  M extends MenuId,
  S extends SheetName<M> = SheetName<M>,
  RS extends ResponseKeys<M, S> = ResponseKeys<M, S>,
>({
  menuId,
  sheetName,
  procedureAction = BUTTON_TYPE.SAVE,
  tabId,
  onSuccess,
  onError,
}: {
  menuId: M;
  sheetName: S;
  procedureAction?: BUTTON_TYPE;
  tabId: string;
  onSuccess?: () => void;
  onError?: (error?: Error) => void;
}) => {
  const { t } = useTranslation();
  const { setToast } = useMessageStore.getState();
  const queryKey = buildTabQueryKey(tabId, sheetName, procedureAction);
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (data: ResponseData<M, S, RS>[]) => {
      if (!data.length)
        return Promise.reject(new Error(t('MSG_NO_CHANGE', '_수정한 내용이 없습니다.')));
      return apiClient.callMutationProc<M, S, RS>(menuId, sheetName, procedureAction, data);
    },
    mutationKey: queryKey,

    onSuccess:
      onSuccess ??
      (() => {
        void queryClient.invalidateQueries({ queryKey: [tabId] });
        setToast({ type: 'success', message: t('MSG00002', '_성공적으로 저장되었습니다!') });
      }),
    onError:
      onError ??
      (error => {
        // void setAlert({
        //   type: 'alert',
        //   content: error.message ?? t('MSG00003', '_저장에 실패하였습니다.'),
        // });
        setToast({
          type: 'error',
          message: error.message ?? t('MSG00003', '_저장에 실패하였습니다.'),
        });
      }),
  });
};

/**
 * 콤보 캐시 무효화 — 콤보의 원천 마스터를 저장한 화면이 저장 성공 직후 호출한다.
 *
 * 콤보는 staleTime 0 이지만 그건 "화면을 새로 열 때 다시 받는다"는 뜻이다. MDI 는 keep-alive 라
 * 저장한 그 화면은 리마운트되지 않으므로, 방금 등록한 값이 조회조건 콤보에 나타나지 않는다.
 * (예: DMF0004 Sales Site 신규 저장 → 조회조건 Sales Site 드롭다운은 저장 전 목록 그대로)
 *
 * 콤보 키가 ['combo', scope, param] 이라 comboId 는 prefix 매칭으로 잡히지 않는다 — 세션 스코프가
 * 중간에 끼어 있다. 그래서 predicate 로 고른다. 스코프는 구분하지 않는다: 다른 계정의 잔여 캐시를
 * 같이 버려도 손해가 없고, 실제 재조회는 활성 쿼리(= 지금 세션의 화면)에만 일어난다.
 */
export const useInvalidateCombos = () => {
  const queryClient = useQueryClient();

  return useCallback(
    (comboIds: string[]) => {
      if (comboIds.length === 0) return Promise.resolve();
      const targets = new Set(comboIds);
      return queryClient.invalidateQueries({
        predicate: query =>
          query.queryKey[0] === 'combo' &&
          targets.has((query.queryKey[2] as ComboParam | undefined)?.comboId ?? ''),
      });
    },
    [queryClient]
  );
};

/**
 * @deprecated
 * useTabComboQueries를 사용하세요
 */
export const useTabComboQuery = ({
  filters,
  enabled = true,
  queryOptions,
}: {
  filters: ComboParam;
  enabled?: boolean;
  queryOptions?: Omit<UseQueryOptions<ComboResponse[]>, 'queryKey' | 'queryFn'>;
}) => {
  const scope = useComboScope();
  const queryKey = buildComboQueryKey(scope ?? '', filters);

  return useQuery<ComboResponse[]>({
    queryKey,
    queryFn: () => apiClient.getCombo(filters),
    enabled: enabled && scope !== null,
    persister: queryOptions?.persister ?? undefined,
    ...VOLATILE_QUERY_OPTIONS,
    ...queryOptions,
  });
};

export const useTabComboQueries = ({
  filters,
  enabled = true,
  queryOptions,
}: {
  filters: (ComboParam | string)[];
  enabled?: boolean;
  queryOptions?: Omit<UseQueryOptions<ComboResponse[]>, 'queryKey' | 'queryFn'>;
}) => {
  const scope = useComboScope();

  return useQueries({
    queries: filters.map(filter => ({
      queryKey: buildComboQueryKey(scope ?? '', toComboParam(filter)),
      queryFn: () => apiClient.getCombo(toComboParam(filter)),
      enabled: enabled && scope !== null,
      persister: queryOptions?.persister ?? undefined,
      ...VOLATILE_QUERY_OPTIONS,
      ...queryOptions,
    })),
  }).map(item => item.data);
};

/**
 * @deprecated
 * useTabLookupQueries 사용하세요
 */
export const useTabLookupQuery = ({
  filters,
  enabled = true,
  queryOptions,
}: {
  filters: LookupParam;
  enabled?: boolean;
  queryOptions?: Omit<UseQueryOptions<LookupResponse[]>, 'queryKey' | 'queryFn'>;
}) => {
  const queryKey = buildTabQueryKey('lookup', '', '', filters);

  return useQuery<LookupResponse[]>({
    queryKey,
    queryFn: () => apiClient.getLookup(filters),
    enabled: enabled,
    persister: queryOptions?.persister ?? undefined,
    ...VOLATILE_QUERY_OPTIONS,
    ...queryOptions,
  });
};

export const useTabLookupQueries = ({
  filters,
  enabled = true,
  queryOptions,
}: {
  filters: (LookupParam | string)[];
  enabled?: boolean;
  queryOptions?: Omit<UseQueryOptions<LookupResponse[]>, 'queryKey' | 'queryFn'>;
}) => {
  return useQueries({
    queries: filters.map(filter => ({
      queryKey: buildTabQueryKey(
        'lookup',
        '',
        '',
        typeof filter === 'string' ? { lookupType: filter } : filter
      ),
      queryFn: () =>
        apiClient.getLookup(typeof filter === 'string' ? { lookupType: filter } : filter),
      enabled: enabled,
      persister: queryOptions?.persister ?? undefined,
      ...VOLATILE_QUERY_OPTIONS,
      ...queryOptions,
    })),
  }).map(item => item.data);
};
