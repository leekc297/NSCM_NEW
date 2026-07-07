/* @refresh reload */
import { useRef, useEffect } from 'react';

import { apiClient } from '@foundation/apis';
import { BUTTON_TYPE } from '@foundation/constants';
import type { ComboParam, LookupParam, ComboResponse, LookupResponse } from '@foundation/models';
import { useQuery, useMutation, useQueryClient, useQueries } from '@foundation/query-client';
import type { UseQueryOptions } from '@foundation/query-client';
import { useMessageStore } from '@shared/stores';

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
  const { setToast, setAlert } = useMessageStore.getState();
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
        void setAlert({
          type: 'alert',
          content: error.message ?? t('MSG00003', '_저장에 실패하였습니다.'),
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
  const queryKey = buildTabQueryKey('combo', '', '', filters);

  return useQuery<ComboResponse[]>({
    queryKey,
    queryFn: () => apiClient.getCombo(filters),
    enabled: enabled,
    persister: queryOptions?.persister ?? undefined,
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
  return useQueries({
    queries: filters.map(filter => ({
      queryKey: buildTabQueryKey(
        'combo',
        '',
        '',
        typeof filter === 'string' ? { comboId: filter } : filter
      ),
      queryFn: () => apiClient.getCombo(typeof filter === 'string' ? { comboId: filter } : filter),
      enabled: enabled,
      persister: queryOptions?.persister ?? undefined,
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
      ...queryOptions,
    })),
  }).map(item => item.data);
};
