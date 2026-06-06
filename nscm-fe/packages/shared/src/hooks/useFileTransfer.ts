/* @refresh reload */
import { useState } from 'react';

import { apiClient } from '@foundation/apis';

/**
 * G5 File Transfer hook (Phase 7 A1, 2026-06-04)
 *
 * AS-IS DataService.FP_DataPull / FP_DataPush / FP_FileDataClient (147~159) 매핑.
 * BE: FileController.fileUpload / fileDownload / fileDelete (`/{mnuId}/{shtNm}/file-{action}`)
 * Storage: BE 의 application.yml file.storage.path (default: ${user.home}/.nscm/files)
 * Metadata: SCM_SYS_FILE 테이블 (_artifacts/G5_file_transfer_metadata.sql)
 *
 * 사용 예:
 * ```typescript
 * const { upload, download, remove, isUploading, progress } = useFileTransfer(MENU_ID, SHEETS.MAIN);
 *
 * const handleUpload = async (file: File) => {
 *   const result = await upload(file);
 *   console.log('uploaded fileId:', result.fileId);
 * };
 *
 * const handleDownload = async (fileId: string, fileName: string) => {
 *   await download(fileId, fileName);
 * };
 * ```
 */
export const useFileTransfer = (menuId: string, sheetName: string) => {
  const [isUploading, setIsUploading] = useState(false);
  const [progress, setProgress] = useState(0);

  const upload = async (
    file: File
  ): Promise<{ fileId: string; fileName: string; fileSize: number; mimeType: string }> => {
    setIsUploading(true);
    setProgress(0);
    try {
      const formData = new FormData();
      formData.append('file', file);

      const response = await apiClient.post<{
        fileId: string;
        fileName: string;
        fileSize: number;
        mimeType: string;
      }>(`/${menuId}/${sheetName}/file-upload`, formData, {
        headers: { 'Content-Type': 'multipart/form-data' },
        onUploadProgress: e => {
          if (e.total) setProgress(e.loaded / e.total);
        },
      });

      return response.data.result;
    } finally {
      setIsUploading(false);
    }
  };

  const download = async (fileId: string, fileName: string): Promise<void> => {
    const response = await apiClient.get(`/${menuId}/${sheetName}/file-download/${fileId}`, {
      responseType: 'blob',
    });

    // blob → 임시 anchor 로 download trigger
    const url = window.URL.createObjectURL(new Blob([response.data as BlobPart]));
    const link = document.createElement('a');
    link.href = url;
    link.setAttribute('download', fileName);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    window.URL.revokeObjectURL(url);
  };

  const remove = async (fileId: string): Promise<{ success: boolean; fileId: string }> => {
    const response = await apiClient.delete<{ success: boolean; fileId: string }>(
      `/${menuId}/${sheetName}/file-delete/${fileId}`
    );
    return response.data.result;
  };

  return { upload, download, remove, isUploading, progress };
};
