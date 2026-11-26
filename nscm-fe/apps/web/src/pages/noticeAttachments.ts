import { apiClient } from '@foundation/apis';
import { API_CONFIG } from '@foundation/constants';
import { useQuery } from '@foundation/query-client';

/**
 * 홈 공지 첨부파일 목록 · 다운로드 URL 유틸.
 * apps/web 는 admin 피처를 프로젝트 참조하지 않아(@admin import 시 rootDir 위반) 여기서 처리한다.
 */

export interface HomeNoticeAttachment {
  fileId: string;
  fileName: string;
  size: number;
  ext: string;
}

export const getAttachmentDownloadUrl = (fileId: string) => {
  const baseUrl = String(API_CONFIG.BASE_URL ?? '').replace(/\/$/, '');
  return `${baseUrl}/file/download/${encodeURIComponent(fileId)}`;
};

export const useHomeNoticeAttachments = (noticeId: string) =>
  useQuery({
    queryKey: ['home-notice-attachments', noticeId],
    enabled: !!noticeId,
    queryFn: async () => {
      const response = await apiClient.get<HomeNoticeAttachment[]>(
        `/notice/${encodeURIComponent(noticeId)}/attachments`
      );
      return response.data.result ?? [];
    },
  });
