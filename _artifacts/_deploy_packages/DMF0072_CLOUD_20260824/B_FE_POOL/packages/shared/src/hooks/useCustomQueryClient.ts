/* @refresh reload */
import { useRef, useEffect } from 'react';

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

  useEffect(() => {
    if (tabIdRef.current !== tabId) {
      tabIdRef.current = tabId;
      return;
    }
    const isKeyChanged = prevKeyRef.current !== filters;

    if (isKeyChanged) {
      void queryClient.invalidateQueries({
        queryKey: [tabId, sheetName, procedureAction, prevKeyRef.current],
        exact: false,
      });

      prevKeyRef.current = filters;
    }
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
