// AS-IS SSP0026 btnExcelUpload → ExcelUploadForm2 파리티(자매 SSP0023/distribution-route 동형).
//   공통 FileController excel-upload 체인(POST /{mnuId}/{shtNm}/UPLOAD/excel-upload, multipart 'file')은
//   mode=0(검증·분류)만 수행 → 오류 0건이면 onSave(mode=1, UPLOAD_SAVE/call-proc)가 실제 적재한다(2-phase).
//   주의: shtNm 은 proc 매핑 키가 아니라 SCM_ADM_EXCEL_COLUMNS.SHEET_NAME(엑셀/컬럼 메타 키)이다.
//   SSP0026 UPLOAD_SAVE SP 는 미배포(설계 iter-5~6) — 적재(mode=1)는 배포 후에만 실동작(현재는 알림).
import { useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, DataGrid } from '@shared/components';
import { Button, FileUploader, FormItem, Label, ProgressIndicator, TextField } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { useMessageStore } from '@shared/stores';

import { LBL, MENU_ID } from '../shipment-request-pack.constants';

import styles from './ExcelUploadModal.module.scss';

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
  // 업로드/검증 대상 SHEET_NAME(SCM_ADM_EXCEL_COLUMNS.SHEET_NAME) — FileController 가 이 값을 키로 쓴다.
  sheetName: string;
  // 오류 행 상세 그리드 컬럼 라벨(ATTRIBUTE1..n 대응) — admin 엑셀시트 컬럼에서 파생해 주입.
  headerLabels: string[];
  // mode=1 적재 콜백 — 검증(mode=0) 통과분 DB 반영. 미제공 시 검증만.
  onSave?: () => Promise<{ ok: boolean; message?: string }>;
}

const ERROR_ROW_COLOR = '#ffd7d7';

const str = (v: unknown): string =>
  typeof v === 'string' || typeof v === 'number' ? String(v) : '';

const getCI = (row: Record<string, unknown>, key: string): unknown => {
  if (key in row) return row[key];
  const lower = key.toLowerCase();
  const hit = Object.keys(row).find(k => k.toLowerCase() === lower);
  return hit === undefined ? undefined : row[hit];
};

const pick = (row: Record<string, unknown>, key: string): string => {
  const v = row[key];
  return typeof v === 'string' || typeof v === 'number' ? String(v) : '';
};

export const ExcelUploadModal = ({
  open,
  modalClose,
  onUploaded,
  sheetName,
  headerLabels,
  onSave,
}: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;

  const [files, setFiles] = useState<FileInfo[]>([]);
  const [uploading, setUploading] = useState(false);
  const uploadingRef = useRef(false);
  const [result, setResult] = useState({ success: '', error: '', total: '' });
  const [errorRows, setErrorRows] = useState<WijmoRowItem[]>([]);

  // 공통 SP PR_GET_EXCEL_UPLOAD_RESULT O_CUR_LIST(오류 행) → 결과 그리드 행(Check=MESSAGE_TEXT + ATTRIBUTE 매핑).
  const toErrorRow = (row: Record<string, unknown>): WijmoRowItem => {
    const out: WijmoRowItem = { MESSAGE_TEXT: str(getCI(row, 'MESSAGE_TEXT')) };
    headerLabels.forEach((_, i) => {
      const key = `ATTRIBUTE${i + 1}`;
      out[key] = str(getCI(row, key));
    });
    return out;
  };

  const resultColumns: RawFlexGridColumnConfig[] = [
    {
      colNm: 'MESSAGE_TEXT',
      colLblNm: 'Check',
      horzAlgnCd: 'L',
      colWth: 240,
      display: true,
      visible: true,
      cellColor: ERROR_ROW_COLOR,
    },
    ...headerLabels.map((label, i) => ({
      colNm: `ATTRIBUTE${i + 1}`,
      colLblNm: label,
      horzAlgnCd: 'C' as const,
      colWth: 110,
      display: true,
      visible: true,
      cellColor: ERROR_ROW_COLOR,
    })),
  ];

  const resetResult = () => {
    setResult({ success: '', error: '', total: '' });
    setErrorRows([]);
  };

  const handleClose = () => {
    setFiles([]);
    resetResult();
    modalClose();
  };

  // AS-IS(SSP0026 btnExcelUpload_Click, frm.SaveExceptError=true)는 2단계다: ①파일 업로드=검증(mode=0,
  //   Success/Error 집계+오류행 표시) → ②Save(mode=1)로 **Success 행만** 저장(오류행 있어도 스킵, SP가
  //   UPLOAD_STATUS_CODE='SUCCESS' 만 적재). 오류가 있다고 전체를 막지 않는다.
  const canSave = Number(result.success || 0) > 0;

  // ① 검증만 — 스테이징 + mode=0 집계. 저장/닫기 없음(결과·오류행 노출 후 사용자가 Save 판단).
  const handleValidate = async () => {
    if (uploadingRef.current) return;
    const file = files[0]?.file;
    if (!file) {
      void setAlert({ type: 'alert', content: t('MSG00113', '_Please select a file.') });
      return;
    }
    uploadingRef.current = true;
    setUploading(true);
    try {
      const formData = new FormData();
      formData.append('file', file);
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/${sheetName}/UPLOAD/excel-upload`,
        formData
      );
      if (res.status >= 400 || Number(res.data?.code)) {
        const reason =
          (res.data as { message?: string })?.message?.trim() ||
          t('MSG00618', '_An error occurred while uploading.');
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
      const listRows = (r.O_CUR_LIST ?? r.o_cur_list ?? []) as Record<string, unknown>[];
      setErrorRows(listRows.map(toErrorRow));
    } catch (e) {
      const msg = e instanceof Error ? e.message : t('MSG00618', '_An error occurred while uploading.');
      void setAlert({ type: 'alert', content: msg });
    } finally {
      uploadingRef.current = false;
      setUploading(false);
    }
  };

  // ② 저장 — 검증 통과(Success>0) 행만 저장(mode=1). 오류행은 SP가 스킵(SaveExceptError). 저장 후 닫고 재조회.
  const handleSave = async () => {
    if (uploadingRef.current) return;
    if (!canSave) {
      void setAlert({ type: 'alert', content: t('MSG00152', '_No data to save.') });
      return;
    }
    uploadingRef.current = true;
    setUploading(true);
    try {
      if (onSave) {
        const saved = await onSave();
        if (!saved.ok) {
          void setAlert({
            type: 'alert',
            content: saved.message?.trim() || t('MSG00618', '_An error occurred while uploading.'),
          });
          return;
        }
      }
      void setToast({
        message: t('MSG00265', '_Excel upload completed. Reloading data.'),
        type: 'success',
      });
      onUploaded();
      handleClose();
    } catch (e) {
      const msg = e instanceof Error ? e.message : t('MSG00618', '_An error occurred while uploading.');
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
              label={t('LBL00759', '_Excel File')}
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
                disabled={uploading || !files[0]?.file}
                onClick={() => void handleValidate()}
              >
                Upload
              </Button>
              <Button
                iconComponent={<ControlConfirmIcon size='default' />}
                priority='normal'
                disabled={uploading || !canSave}
                onClick={() => void handleSave()}
              >
                Save
              </Button>
              <Button priority='normal' appearance='outlined' onClick={handleClose}>
                Cancel
              </Button>
            </div>
          </div>
          <Label
            labelText={t('LBL00754', '_Upload Result')}
            sx={{ lineHeight: '150%', fontSize: '14px', marginBottom: '10px' }}
          />
          <div className={styles.statusContainer}>
            <FormItem
              label={t('LBL00755', '_Success')}
              labelAlign='left'
              render={() => <TextField className={styles.statusInput} value={result.success} fullWidth />}
            />
            <FormItem
              label={t('LBL00756', '_Error')}
              labelAlign='left'
              render={() => <TextField className={styles.statusInput} value={result.error} fullWidth />}
            />
            <FormItem
              label={t('LBL00757', '_Total')}
              labelAlign='left'
              render={() => <TextField className={styles.statusInput} value={result.total} fullWidth />}
            />
          </div>
          {errorRows.length > 0 && (
            <div className={styles.resultGridWrap}>
              <DataGrid
                isReadOnly
                useContextMenu={false}
                staticColumns={resultColumns}
                itemsSource={errorRows}
              />
            </div>
          )}
        </div>
      }
    />
  );
};
