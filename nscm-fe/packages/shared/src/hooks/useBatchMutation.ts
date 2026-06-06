/* @refresh reload */
import { useState } from 'react';

import { apiClient } from '@foundation/apis';
import { useMutation, useQueryClient } from '@foundation/query-client';
import { useMessageStore } from '@shared/stores';

/**
 * G4 — Batch Mutation hook (Phase 5 신규 구현, 2026-06-03)
 *
 * AS-IS DataService.CommonPseudoBatch2 동등.
 * 대량 row (1000+) 를 chunk 단위로 분할 + 진행률 표시.
 *
 * BE: 기존 callMutationProc 호출 N 회 또는 신규 `POST /api/batch/{menuId}/{sheetName}` (후속).
 *
 * 사용 예 (DMF0008 / DMF0020 같은 대량 저장 화면):
 * ```typescript
 * const { mutate, isPending, progress } = useBatchMutation<MENU_ID, SHEETS.MAIN>({
 *   menuId: MENU_ID,
 *   sheetName: SHEETS.MAIN,
 *   tabId,
 *   chunkSize: 100,
 * });
 *
 * const handleSave = () => {
 *   const saveData = data?.o_rc1?.filter(row => row.CRUD_TYPE) ?? [];
 *   mutate(saveData);
 * };
 *
 * return <div>{isPending && `Saving... ${Math.round(progress * 100)}%`}</div>;
 * ```
 */
export const useBatchMutation = <
  M extends MenuId,
  S extends SheetName<M> = SheetName<M>,
  RS extends ResponseKeys<M, S> = ResponseKeys<M, S>,
>({
  menuId,
  sheetName,
  procedureAction = 'SAVE',
  tabId,
  chunkSize = 100,
  onProgress,
  onSuccess,
  onError,
}: {
  menuId: M;
  sheetName: S;
  procedureAction?: string;
  tabId: string;
  chunkSize?: number;
  onProgress?: (progress: number) => void;
  onSuccess?: () => void;
  onError?: (error?: Error) => void;
}) => {
  const queryClient = useQueryClient();
  const { setToast, setAlert } = useMessageStore.getState();
  const { t } = useTranslation();
  const [progress, setProgress] = useState(0);

  const mutation = useMutation({
    mutationFn: async (data: ResponseData<M, S, RS>[]) => {
      if (!data.length) {
        throw new Error(t('MSG00004', '_수정한 내용이 없습니다.'));
      }

      const chunks: ResponseData<M, S, RS>[][] = [];
      for (let i = 0; i < data.length; i += chunkSize) {
        chunks.push(data.slice(i, i + chunkSize));
      }

      setProgress(0);
      const results = [];
      for (let i = 0; i < chunks.length; i++) {
        const r = await apiClient.callMutationProc<M, S, RS>(menuId, sheetName, procedureAction, chunks[i]);
        results.push(r);
        const p = (i + 1) / chunks.length;
        setProgress(p);
        onProgress?.(p);
      }

      return results;
    },
    onSuccess: onSuccess ?? (() => {
      void queryClient.invalidateQueries({ queryKey: [tabId] });
      setToast({ type: 'success', message: t('MSG00002', '_성공적으로 저장되었습니다!') });
    }),
    onError: onError ?? (error => {
      void setAlert({
        type: 'alert',
        content: error.message ?? t('MSG00003', '_저장에 실패하였습니다.'),
      });
    }),
  });

  return {
    ...mutation,
    progress,
  };
};
