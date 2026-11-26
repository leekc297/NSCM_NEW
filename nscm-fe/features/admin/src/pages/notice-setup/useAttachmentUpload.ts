import { apiClient } from '@foundation/apis';
import { useMutation } from '@foundation/query-client';

import type { NoticeAttachment } from './notice-setup.types';

interface AttachmentUploadResult extends NoticeAttachment {
  url: string;
}

/**
 * 임의 종류 파일(실행형 제외·최대 500MB)을 범용 업로드 엔드포인트로 올린다.
 * 본문 이미지(useNoticeImageUpload, /file/image-upload)와 달리 첨부파일 전용(/file/upload)이다.
 */
export const useAttachmentUpload = () =>
  useMutation({
    mutationFn: async (file: File) => {
      const formData = new FormData();
      formData.append('file', file);
      formData.append('fileKdnCd', 'NOTICE');

      const response = await apiClient.post<AttachmentUploadResult>('/file/upload', formData);

      if (response.status >= 400 || Number(response.data?.code)) {
        throw new Error(response.data?.message?.trim());
      }

      const result = response.data?.result;
      if (!result?.fileId) throw new Error();

      return result;
    },
  });
