import { useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { CustomDialog } from '@shared/components';
import { Button, FileUploader, FormItem, Label, ProgressIndicator, TextField } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { useMessageStore } from '@shared/stores';

import { ADMIN_SHEET_NAME, LBL, MENU_ID, MSG, SHEETS } from '../../opt-capa.constants';

import styles from './NoWorkExcelUploadModal.module.scss';

/**
 * No Work Excel 업로드 — AS-IS `BtnExcelUpload_Click`(cs:3833-3839)의 `ExcelUploadForm` 대체.
 *
 * 공통 FileController 체인(`POST /{mnuId}/{shtNm}/UPLOAD/excel-upload`, multipart `file`)을 쓴다.
 * 자매 SCP0005 `distribution-route/components/modals/ExcelUploadModal.tsx` 와 동일 형태다.
 *
 * 주의: `shtNm` 은 proc 라우팅 키(`noWork`)가 아니라 **컬럼/엑셀 메타 시트명**
 * (`ADMIN_SHEET_NAME` = `'No Work'`)이다 — `FileController.checkMenuBtnAuth` 와
 * `SCM_ADM_EXCEL_COLUMNS.SHEET_NAME = #{shtNm}` 조회가 이 값을 키로 쓴다(DB 실측 1행).
 * `noWork` 로 보내면 권한/헤더가 0건이 된다.
 *
 * AS-IS `frm.SaveExceptError = false`(cs:3836) = 오류행 제외 저장 **금지**(전량 롤백)인데, TO-BE
 * 공용 업로드 경로에 그 동등 옵션이 노출돼 있지 않다 — 04 리포트에 "확인 필요(사용자 축)" 로
 * 남겼다(design 01 §5 V-5). 화면에서 임의 옵션을 만들지 않는다.
 */
interface FileInfo {
  name: string;
  size: number;
  url: string;
  file?: File;
}

interface Props {
  open: boolean;
  modalClose: () => void;
  onUploaded: () => void;
}

const pick = (row: Record<string, unknown>, key: string): string => {
  const value = row[key];
  return typeof value === 'string' || typeof value === 'number' ? String(value) : '';
};

export const NoWorkExcelUploadModal = ({ open, modalClose, onUploaded }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;

  const [files, setFiles] = useState<FileInfo[]>([]);
  const [uploading, setUploading] = useState(false);
  const uploadingRef = useRef(false);
  const [result, setResult] = useState({ success: '', error: '', total: '' });

  const resetResult = () => setResult({ success: '', error: '', total: '' });

  const handleClose = () => {
    setFiles([]);
    resetResult();
    modalClose();
  };

  const handleUpload = async () => {
    if (uploadingRef.current) return; // 동기 가드 — 이중발사 방지
    const file = files[0]?.file;
    if (!file) {
      void setAlert({
        type: 'alert',
        content: t(MSG.UPLOAD_FILE_REQUIRED, {
          defaultValue: 'There is no selected file information.',
        }),
      });
      return;
    }
    uploadingRef.current = true;
    setUploading(true);
    try {
      const formData = new FormData();
      formData.append('file', file);
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/${ADMIN_SHEET_NAME[SHEETS.NO_WORK]}/UPLOAD/excel-upload`,
        formData
      );
      // false-success 판별(nscm-patterns §5-10 — 인터셉터가 500 도 resolve).
      if (res.status >= 400 || Number(res.data?.code)) {
        void setAlert({
          type: 'alert',
          content:
            (res.data as { message?: string })?.message?.trim() ||
            t(MSG.UPLOAD_FAIL, '_File upload failed.'),
        });
        return;
      }
      const body = res.data?.result ?? {};
      const countRows = (body.O_CUR_CNT ?? body.o_cur_cnt ?? []) as Record<string, unknown>[];
      const count = countRows[0] ?? {};
      setResult({
        success: pick(count, 'SUCCESS_COUNT'),
        error: pick(count, 'ERROR_COUNT'),
        total: pick(count, 'TOTAL_COUNT'),
      });
      void setToast({
        type: 'success',
        message: t(MSG.UPLOAD_DONE, '_Excel upload completed. Reloading data.'),
      });
      onUploaded();
    } catch (error) {
      void setAlert({
        type: 'alert',
        content:
          error instanceof Error
            ? error.message
            : t(MSG.UPLOAD_FAIL, '_File upload failed.'),
      });
    } finally {
      uploadingRef.current = false;
      setUploading(false);
    }
  };

  return (
    <CustomDialog
      size={640}
      type='modaless'
      position='basic'
      open={open}
      handleClose={handleClose}
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t(LBL.EXCEL_UPLOAD, 'Excel Upload')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.contentWrap}>
          <ProgressIndicator
            shape='circular'
            apprearance='infinite'
            open={uploading}
            placement='parent'
          />
          <div className={styles.inputContainer}>
            <FormItem
              label={t(LBL.EXCEL_FILE, 'Excel File')}
              labelAlign='right'
              render={() => (
                <FileUploader
                  placeholder=''
                  acceptFiles={['.xlsx', '.xls']}
                  multiple={false}
                  selectedFiles={files}
                  onFileChange={value => {
                    // @lges FileUploader 는 multiple=false 여도 append 하므로 2개 이상이면 반려.
                    if (value.length > 1) {
                      void setAlert({
                        type: 'alert',
                        content: t(MSG.UPLOAD_FILE_REQUIRED, {
                          defaultValue: 'There is no selected file information.',
                        }),
                      });
                      setFiles(files.length > 0 ? files : value.slice(0, 1));
                      return;
                    }
                    setFiles(value);
                    resetResult();
                  }}
                  containerBoxProps={{ width: '420px' }}
                />
              )}
            />
            <div className={styles.buttonGroup}>
              <Button
                iconComponent={<ControlConfirmIcon size='default' />}
                priority='normal'
                disabled={uploading}
                onClick={() => void handleUpload()}
              >
                {t(LBL.OK, 'OK')}
              </Button>
              <Button priority='normal' appearance='outlined' onClick={handleClose}>
                {t(LBL.CANCEL, 'Cancel')}
              </Button>
            </div>
          </div>
          <Label
            className={styles.resultLabel}
            labelText={t(LBL.UPLOAD_RESULT, 'Upload Result')}
          />
          <div className={styles.statusContainer}>
            <FormItem
              label={t(LBL.UPLOAD_SUCCESS, 'Success')}
              labelAlign='left'
              render={() => (
                <TextField className={styles.statusInput} value={result.success} fullWidth />
              )}
            />
            <FormItem
              label={t(LBL.UPLOAD_ERROR, 'Error')}
              labelAlign='left'
              render={() => (
                <TextField className={styles.statusInput} value={result.error} fullWidth />
              )}
            />
            <FormItem
              label={t(LBL.UPLOAD_TOTAL, 'Total')}
              labelAlign='left'
              render={() => (
                <TextField className={styles.statusInput} value={result.total} fullWidth />
              )}
            />
          </div>
        </div>
      }
    />
  );
};
