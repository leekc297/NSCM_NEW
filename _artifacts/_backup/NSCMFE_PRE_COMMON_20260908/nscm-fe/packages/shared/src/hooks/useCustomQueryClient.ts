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

/**
 * src 는 요청 출처 표식이다(예: 'grid' — gridComboSrc 참조). 키에 넣지 않으면 같은 콤보를
 * 검색조건과 그리드가 함께 쓸 때 요청이 하나로 접혀 Network 탭에서 출처를 가릴 수 없다.
 *
 * 끝에 붙인다 — useInvalidateCombos 가 queryKey[2] 를 ComboParam 으로 읽으므로 중간에 끼우면
 * 무효화가 조용히 깨진다. 없을 때도 '' 로 자리를 잡아 키 모양을 하나로 유지한다. 콤보는
 * 영속 대상이 아니고(shouldPersistQuery) staleTime 0 이라 키가 갈려도 치를 비용이 없다.
 */
const buildComboQueryKey = (scope: string, param: ComboParam, src?: string) =>
  ['combo', scope, { ...param }, src ?? ''] as const;

const toComboParam = (filter: ComboParam | string): ComboParam =>
  typeof filter === 'string' ? { comboId: filter } : filter;

const buildTabQueryKey = <M extends MenuId, S extends SheetName<M>>(
  tabId: string,
  sheetName: S,
  procedureAction: BUTTON_TYPE | '',
  filters?: ProcRequest<M, S> | ComboParam | LookupParam
) => [tabId, sheetName, procedureAction, { ...filters }] as const;

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
    // filters 가 비워지는 중간 전이(조회조건 리셋 등)는 무시한다 — prevKeyRef 를 건드리면
    // 그 직전까지의 "실제 조회 조건"을 잃어버려, 이후 같은 조건으로 재조회해도 동일 조건
    // 판정(위 removeQueries 분기)이 깨져 캐시된 이전 데이터가 로딩 없이 그대로 노출된다.
    if (!filters) return;
    if (prevKeyRef.current === filters) return;

    // 조회조건이 바뀔 때마다(같은 값으로 되돌아온 경우 포함) 그리드는 항상 비워졌다가 새로
    // 채워져야 한다. 새 조건에 예전에 조회했던 캐시가 남아있으면(재방문) 그 캐시부터 지우고,
    // 더 이상 관측되지 않는 이전 조건 캐시도 함께 지운다. removeQueries 는 그 자체로 fetch 를
    // 일으키지 않고, 지금 이 queryKey 를 구독 중인 useQuery(이번 렌더에서 이미 생성됨)만 즉시
    // 빈 상태에서 다시 fetch 하게 만든다 — 이전 조건 쪽은 구독이 끊긴 뒤라 삭제해도 아무
    // 요청도 나가지 않는다(예전 invalidateQueries(refetchType:'none')이 막던 "옛 조건으로 즉시
    // 재조회" 사고, DMF0042·DMF0020 도 이 메커니즘상 재발하지 않는다).
    const prevQueryKey = buildTabQueryKey(
      tabId,
      sheetName,
      procedureAction,
      prevKeyRef.current ?? {}
    );
    queryClient.removeQueries({ queryKey, exact: true });
    queryClient.removeQueries({ queryKey: prevQueryKey, exact: true });

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
 * 콤보 키가 ['combo', scope, param, src] 이라 comboId 는 prefix 매칭으로 잡히지 않는다 — 세션
 * 스코프가 중간에 끼어 있다. 그래서 predicate 로 고른다. 스코프와 src 는 구분하지 않는다: 다른
 * 계정의 잔여 캐시를 같이 버려도 손해가 없고, 검색조건(src 없음)과 그리드(src='grid')가 같은
 * 콤보를 볼 때 한쪽만 비우면 두 목록이 어긋난다. 실제 재조회는 활성 쿼리(= 지금 세션의 화면)에만
 * 일어난다.
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
  src,
}: {
  filters: (ComboParam | string)[];
  enabled?: boolean;
  queryOptions?: Omit<UseQueryOptions<ComboResponse[]>, 'queryKey' | 'queryFn'>;
  /**
   * 요청 출처 표식. URL 쿼리(`admin/combo?src=grid`)와 쿼리 키에만 붙고 본문에는 안 실린다 —
   * 본문 키는 BE makeComboQuery 가 등록 SQL 의 @키 로 치환하는 대상이다. 값은 호출부 상수로
   * 둘 것(그리드는 gridComboSrc 의 GRID_COMBO_SRC).
   */
  src?: string;
}) => {
  const scope = useComboScope();

  return useQueries({
    queries: filters.map(filter => ({
      queryKey: buildComboQueryKey(scope ?? '', toComboParam(filter), src),
      queryFn: () => apiClient.getCombo(toComboParam(filter), src),
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
