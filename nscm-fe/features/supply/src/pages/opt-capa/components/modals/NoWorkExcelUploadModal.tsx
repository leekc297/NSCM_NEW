import { useEffect, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, DataGrid } from '@shared/components';
import { Button, FileUploader, FormItem, Label, ProgressIndicator, TextField } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { useMessageStore } from '@shared/stores';

import { ADMIN_SHEET_NAME, EXCEL_FORM_HEADER_TOKENS, LBL, MENU_ID, MSG, SHEETS } from '../../opt-capa.constants';

import styles from './NoWorkExcelUploadModal.module.scss';

/**
 * No Work Excel 업로드 — AS-IS `BtnExcelUpload_Click`(cs:3833-3839)의 `ExcelUploadForm("SCP0126","No Work")`
 * 2-phase 재현. 자매 stock-osp `ExcelUploadModal` 과 동일 형태.
 *
 * 흐름(AS-IS ExcelUploadForm): 파일 선택 → [즉시] 검증(mode=0, `UPLOAD/excel-upload`) →
 *   Upload Result(Success/Error/Total) + Error Detail 그리드(오류행) 표시 →
 *   `btnOK.Enabled = (Success>0 && Error==0)` 로 OK 활성 → OK 클릭 → 적재(mode=1, `UPLOAD_SAVE/call-proc`) →
 *   '저장하였습니다'(MSG00002) → 닫고 부모 재조회.
 *   AS-IS `SaveExceptError=false`(cs:3836) = 오류행 존재 시 전량 저장 차단(게이트). 라우팅 2버튼은 ora.py 실측
 *   (SCP0126,'No Work',UPLOAD / UPLOAD_SAVE → SCP0126_noWork_UPLOAD, USE_YN='Y').
 *
 * 주의: `shtNm` 은 proc 라우팅 키(`noWork`)가 아니라 컬럼/엑셀 메타 시트명(`ADMIN_SHEET_NAME`='No Work')이다 —
 *   `FileController.checkMenuBtnAuth` 와 `SCM_ADM_EXCEL_COLUMNS.SHEET_NAME=#{shtNm}` 조회가 이 값을 키로 쓴다.
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
  // OK(mode=1) 저장 콜백 — 검증 통과분 DB 적재. { ok, message } 반환. 미제공 시 검증만 하고 저장하지 않는다.
  onSave?: () => Promise<{ ok: boolean; message?: string }>;
}

const pick = (row: Record<string, unknown>, key: string): string => {
  const v = row[key];
  return typeof v === 'string' || typeof v === 'number' ? String(v) : '';
};

const str = (v: unknown): string =>
  typeof v === 'string' || typeof v === 'number' ? String(v) : '';

// 오류 행 배경색(AS-IS ExcelUploadForm 오류 하이라이트).
const ERROR_ROW_COLOR = '#ffd7d7';

// 엑셀 양식 헤더(필수표시 * 제거) — 결과 그리드 ATTRIBUTE1..n 라벨.
const EXCEL_UPLOAD_HEADER_LABELS = EXCEL_FORM_HEADER_TOKENS.map(h => h.replace(/\*$/, ''));

// O_CUR_LIST 행 키 대소문자 방어.
const getCI = (row: Record<string, unknown>, key: string): unknown => {
  if (key in row) return row[key];
  const lower = key.toLowerCase();
  const hit = Object.keys(row).find(k => k.toLowerCase() === lower);
  return hit === undefined ? undefined : row[hit];
};

// 오류 행(O_CUR_LIST) → 결과 그리드 행. ATTRIBUTE1..n(양식 컬럼) + MESSAGE_TEXT(검증 메시지).
const toErrorRow = (row: Record<string, unknown>): WijmoRowItem => {
  const out: WijmoRowItem = { MESSAGE_TEXT: str(getCI(row, 'MESSAGE_TEXT')) };
  EXCEL_UPLOAD_HEADER_LABELS.forEach((_, i) => {
    const key = `ATTRIBUTE${i + 1}`;
    out[key] = str(getCI(row, key));
  });
  return out;
};

// AS-IS Error Detail 컬럼 순서: 양식 컬럼(Div~Fix) 다음 Message 마지막.
const RESULT_COLUMNS: RawFlexGridColumnConfig[] = [
  ...EXCEL_UPLOAD_HEADER_LABELS.map((label, i) => ({
    colNm: `ATTRIBUTE${i + 1}`,
    colLblNm: label,
    horzAlgnCd: 'C' as const,
    colWth: 110,
    display: true,
    visible: true,
    cellColor: ERROR_ROW_COLOR,
  })),
  {
    colNm: 'MESSAGE_TEXT',
    colLblNm: 'Message',
    horzAlgnCd: 'L',
    colWth: 240,
    display: true,
    visible: true,
    cellColor: ERROR_ROW_COLOR,
  },
];

export const NoWorkExcelUploadModal = ({ open, modalClose, onUploaded, onSave }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;

  const [files, setFiles] = useState<FileInfo[]>([]);
  const [uploading, setUploading] = useState(false);
  const uploadingRef = useRef(false);
  const [result, setResult] = useState({ success: '', error: '', total: '' });
  // 검증 오류 행 상세(Error Detail 그리드).
  const [errorRows, setErrorRows] = useState<WijmoRowItem[]>([]);
  // 검증 완료 여부 — OK 활성 조건.
  const [classified, setClassified] = useState(false);
  const savingRef = useRef(false);

  const resetResult = () => {
    setResult({ success: '', error: '', total: '' });
    setErrorRows([]);
    setClassified(false);
  };

  // AS-IS btnOK.Enabled = (Success>0 && Error==0). 검증 완료 + 성공 1건↑ + 오류 0건.
  const canSave =
    classified && Number(result.success || 0) > 0 && Number(result.error || 0) === 0;

  // 확인 없이 닫기 — 저장 성공 직후 전용.
  const doClose = () => {
    setFiles([]);
    resetResult();
    modalClose();
  };

  // 수동 닫기 — 저장 가능 상태에서 미저장이면 취소 확인(AS-IS OnClose_Click).
  const handleClose = async () => {
    if (canSave) {
      const ok = await setAlert({
        type: 'confirm',
        content: t('MSG00684', '_Are you sure you want to cancel?'),
      });
      if (!ok) return;
    }
    doClose();
  };

  // 파일 선택 즉시 검증(mode=0) — AS-IS OnOpen_Click.
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
            t('MSG00618', '_An error occurred while uploading.'),
        });
        return;
      }
      const r = res.data?.result ?? {};
      const cntRows = (r.O_CUR_CNT ?? r.o_cur_cnt ?? []) as Record<string, unknown>[];
      const cnt = cntRows[0] ?? {};
      const success = pick(cnt, 'SUCCESS_COUNT');
      const error = pick(cnt, 'ERROR_COUNT');
      setResult({ success, error, total: pick(cnt, 'TOTAL_COUNT') });
      // 오류 행 상세(O_CUR_LIST) → Error Detail 그리드.
      const listRows = (r.O_CUR_LIST ?? r.o_cur_list ?? []) as Record<string, unknown>[];
      setErrorRows(listRows.map(toErrorRow));
      setClassified(true);
      // 검증(mode=0)만 끝난 상태 — 실제 적재는 OK(handleSave → onSave mode=1)가 한다.
      //   전량 게이트(AS-IS SaveExceptError=false): 오류 행이 있으면 저장 차단.
      if (Number(error || 0) > 0) {
        void setAlert({
          type: 'alert',
          content: t('MSG00657', '_Cannot save while error rows exist. Please fix the file and re-upload.'),
        });
        return;
      }
      if (Number(success || 0) === 0) {
        void setAlert({ type: 'alert', content: t('MSG00152', '_No data to save.') });
        return;
      }
      void setToast({
        message: t('MSG00659', '_Validation complete. Review results then press OK to save.'),
        type: 'default',
      });
    } catch (error) {
      void setAlert({
        type: 'alert',
        content:
          error instanceof Error
            ? error.message
            : t('MSG00618', '_An error occurred while uploading.'),
      });
    } finally {
      uploadingRef.current = false;
      setUploading(false);
    }
  };

  // 파일을 고르면 바로 검증(AS-IS OnOpen_Click).
  useEffect(() => {
    if (!files[0]?.file || classified || uploadingRef.current) return;
    void handleUpload();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [files]);

  // OK — 검증 통과분 적재(mode=1) 후 닫고 재조회.
  const handleSave = async () => {
    if (!onSave || !canSave || savingRef.current) return;
    savingRef.current = true;
    setUploading(true);
    try {
      const saved = await onSave();
      if (!saved.ok) {
        void setAlert({
          type: 'alert',
          content: saved.message?.trim() || t('MSG00618', '_An error occurred while saving.'),
        });
        return;
      }
      void setToast({ message: t('MSG00002', '_Saved successfully.'), type: 'success' });
      doClose();
      onUploaded();
    } finally {
      savingRef.current = false;
      setUploading(false);
    }
  };

  return (
    <CustomDialog
      size={640}
      type='modaless'
      position='basic'
      open={open}
      handleClose={() => void handleClose()}
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
                disabled={uploading || !canSave}
                onClick={() => void handleSave()}
              >
                {t(LBL.OK, 'OK')}
              </Button>
              <Button priority='normal' appearance='outlined' onClick={() => void handleClose()}>
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
          {errorRows.length > 0 && (
            <div className={styles.resultGridWrap}>
              <DataGrid
                isReadOnly
                useContextMenu={false}
                staticColumns={RESULT_COLUMNS}
                itemsSource={errorRows}
              />
            </div>
          )}
        </div>
      }
    />
  );
};
