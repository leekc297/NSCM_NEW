import { useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { CustomDialog } from '@shared/components';
import { Button, FileUploader, FormItem, Label, ProgressIndicator, TextField } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { useMessageStore } from '@shared/stores';

import { ADMIN_SHEET_NAME, LBL, MENU_ID, MSG } from '../../capa.constants';

import styles from './CapaExcelUploadModal.module.scss';

/**
 * GAP-04 엑셀 업로드 — AS-IS `btnExcelUpload_Click`(cs:2603) `ExcelUploadForm("SCP0049", "CAPA")`.
 * 공통 FileController excel-upload 체인(POST /{mnuId}/{shtNm}/UPLOAD/excel-upload, multipart 'file')
 * — 업로드 SP = `PKG_SCP0049.P_CAPA_EXCEL_UPLOAD`(DB 실측 배포, SCM_ADM_EXCEL_COLUMNS SHEET_NAME='CAPA').
 * shtNm 은 그 테이블의 SHEET_NAME 값('CAPA' = ADMIN_SHEET_NAME) — SEARCH/SAVE 라우팅의 camelCase
 * SHEETS.CAPA('capa')와는 다른 네임스페이스(stock-osp 동일 패턴, rule #91 등록명 그대로).
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
  const v = row[key];
  return typeof v === 'string' || typeof v === 'number' ? String(v) : '';
};

export const CapaExcelUploadModal = ({ open, modalClose, onUploaded }: Props) => {
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
      void setAlert({ type: 'alert', content: t(MSG.UPLOAD_NO_FILE, '_There is no selected file information.') });
      return;
    }
    uploadingRef.current = true;
    setUploading(true);
    try {
      const formData = new FormData();
      formData.append('file', file);
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/${ADMIN_SHEET_NAME}/UPLOAD/excel-upload`,
        formData
      );
      // 저장 false-success 판별 (nscm-patterns §5-10 — 인터셉터가 500 도 resolve).
      if (res.status >= 400 || Number(res.data?.code)) {
        const reason =
          (res.data as { message?: string })?.message?.trim() ||
          t(MSG.UPLOAD_ERROR, '_Error occurred during execution.');
        void setAlert({ type: 'alert', content: reason });
        return;
      }
      const r = res.data?.result ?? {};
      const cntRows = (r.O_CUR_CNT ?? r.o_cur_cnt ?? []) as Record<string, unknown>[];
      const cnt = cntRows[0] ?? {};
      setResult({
        success: pick(cnt, 'SUCCESS_COUNT'),
        error: pick(cnt, 'ERROR_COUNT'),
        total: pick(cnt, 'TOTAL_COUNT'),
      });
      void setToast({
        message: t(MSG.EXCEL_RELOAD_CONFIRM, '_Excel upload completed. Reloading data.'),
        type: 'success',
      });
      onUploaded();
    } catch (e) {
      const msg = e instanceof Error ? e.message : t(MSG.UPLOAD_ERROR, '_Error occurred during execution.');
      void setAlert({ type: 'alert', content: msg });
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
          <h2 className='headerTitle'>{t(LBL.EXCEL_UPLOAD, '_Excel Upload')}</h2>
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
              label={t(LBL.EXCEL_FILE, '_Excel File')}
              labelAlign='right'
              render={() => (
                <FileUploader
                  placeholder=''
                  acceptFiles={['.xlsx', '.xls']}
                  multiple={false}
                  selectedFiles={files}
                  onFileChange={value => {
                    if (value.length > 1) {
                      void setAlert({
                        type: 'alert',
                        content: t(
                          'FE_EXCEL_UPLOAD_SINGLE_FILE_ONLY',
                          '_Only one file is allowed. Remove the existing file first.'
                        ),
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
                {t(LBL.OK, '_OK')}
              </Button>
              <Button priority='normal' appearance='outlined' onClick={handleClose}>
                {t(LBL.CANCEL, '_Cancel')}
              </Button>
            </div>
          </div>
          <Label
            labelText={t(LBL.UPLOAD_RESULT, '_Upload Result')}
            sx={{ lineHeight: '150%', fontSize: '14px', marginBottom: '10px' }}
          />
          <div className={styles.statusContainer}>
            <FormItem
              label={t(LBL.SUCCESS, '_Success')}
              labelAlign='left'
              render={() => <TextField className={styles.statusInput} value={result.success} fullWidth />}
            />
            <FormItem
              label={t(LBL.ERROR, '_Error')}
              labelAlign='left'
              render={() => <TextField className={styles.statusInput} value={result.error} fullWidth />}
            />
            <FormItem
              label={t(LBL.TOTAL, '_Total')}
              labelAlign='left'
              render={() => <TextField className={styles.statusInput} value={result.total} fullWidth />}
            />
          </div>
        </div>
      }
    />
  );
};
