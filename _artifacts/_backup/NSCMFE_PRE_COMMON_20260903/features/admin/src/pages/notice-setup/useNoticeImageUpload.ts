import { apiClient } from '@foundation/apis';
import { useMutation } from '@foundation/query-client';

import type { NoticeImageUploadResult } from './notice-setup.types';

export const useNoticeImageUpload = () =>
  useMutation({
    mutationFn: async (file: File) => {
      const formData = new FormData();
      formData.append('file', file);
      formData.append('fileKdnCd', 'NOTICE');

      const response = await apiClient.post<NoticeImageUploadResult>(
        '/file/image-upload',
        formData
      );

      if (response.status >= 400 || Number(response.data?.code)) {
        throw new Error(response.data?.message?.trim());
      }

      const result = response.data?.result;
      if (!result?.fileId) throw new Error();

      return result;
    },
  });
