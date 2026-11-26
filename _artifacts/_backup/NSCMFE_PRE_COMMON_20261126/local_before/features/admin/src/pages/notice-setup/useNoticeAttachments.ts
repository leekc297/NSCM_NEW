import { apiClient } from '@foundation/apis';
import { useMutation, useQuery } from '@foundation/query-client';

import type { NoticeAttachment } from './notice-setup.types';

// 공지의 첨부 목록 조회. noticeId 가 없으면(신규 작성) 조회하지 않는다.
export const useNoticeAttachmentsQuery = (noticeId: string, enabled: boolean) =>
  useQuery({
    queryKey: ['notice-attachments', noticeId],
    enabled: enabled && !!noticeId,
    // 창 포커스마다 재조회되며 리렌더를 유발하지 않도록 끈다. 401 등에서 재시도 폭주도 막는다.
    // (staleTime/refetchOnMount 는 두지 않는다 — 저장 후 재조회에서 스테일 캐시가 보이면 안 됨.)
    refetchOnWindowFocus: false,
    retry: false,
    queryFn: async () => {
      const response = await apiClient.get<NoticeAttachment[]>(
        `/notice/${encodeURIComponent(noticeId)}/attachments`
      );
      return response.data?.result ?? [];
    },
  });

// 공지의 첨부 집합을 fileIds 로 치환 저장.
export const useSaveNoticeAttachments = () =>
  useMutation({
    mutationFn: async ({ noticeId, fileIds }: { noticeId: string; fileIds: string[] }) => {
      const response = await apiClient.put(`/notice/${encodeURIComponent(noticeId)}/attachments`, {
        fileIds,
      });
      if (response.status >= 400 || Number(response.data?.code)) {
        throw new Error(response.data?.message?.trim());
      }
      return true;
    },
  });
