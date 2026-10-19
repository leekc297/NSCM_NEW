import { useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, DataGrid } from '@shared/components';
import { Button, FileUploader, FormItem, Label, ProgressIndicator, TextField } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { useMessageStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  EXCEL_UPLOAD_HEADER_LABELS,
  LBL,
  MENU_ID,
  SHEETS,
} from '../../distribution-route.constants';

import styles from './ExcelUploadModal.module.scss';

// AS-IS SCP0005 btnEaxel_Upload → ExcelUploadForm2("SCP0005", sheet) (design 01 §2-E1 / P1).
//   업로드 SP PKG_SCP0005.P_SCP0005_EXCEL_UPLOAD 은 2-phase(mode=0 검증·분류만 / mode>0 원장 적재).
//   공통 FileController excel-upload 체인(POST /{mnuId}/{shtNm}/UPLOAD/excel-upload, multipart 'file')은
//   mode=0(검증)만 호출하므로, 실제 적재는 onSave(mode=1) 2번째 호출이 해야 한다(정본 DMF0074 규약).
//   흐름: OK → 검증(mode=0) → 오류 0건이면 onSave(mode=1, UPLOAD_SAVE/call-proc) → 재조회. onUploaded 재조회.
//   주의: shtNm 은 proc 매핑 SHT_NM('route')이 아니라 컬럼/엑셀메타 SHEET_NAME(ADMIN_SHEET_NAME='Distribution
//   Route')이다 — FileController checkMenuBtnAuth 와 SCM_ADM_EXCEL_COLUMNS.SHEET_NAME=#{shtNm} 조회가
//   이 값을 키로 쓴다(rule #91 등록명 그대로 · DB 실측 2026-09-21). 'route' 로 보내면 권한/헤더 0건.

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
  // 2번째 호출(mode=1) 저장 콜백 — 검증(mode=0) 통과분 DB 반영. { ok, message } 반환(FcstUploadModal 규약).
  //   미제공 시 검증만 하고 저장하지 않는다(레거시 폴백).
  onSave?: () => Promise<{ ok: boolean; message?: string }>;
}

const pick = (row: Record<string, unknown>, key: string): string => {
  const v = row[key];
  return typeof v === 'string' || typeof v === 'number' ? String(v) : '';
};

// AS-IS ExcelUploadForm2 오류 행 빨간 하이라이트(ErrorColor) 대응 셀 배경.
const ERROR_ROW_COLOR = '#ffd7d7';

// O_CUR_LIST 행 키 대소문자 방어(CustomMap 매핑 케이스 차이) — 필요한 키만 정규화한다.
const getCI = (row: Record<string, unknown>, key: string): unknown => {
  if (key in row) return row[key];
  const lower = key.toLowerCase();
  const hit = Object.keys(row).find(k => k.toLowerCase() === lower);
  return hit === undefined ? undefined : row[hit];
};

const str = (v: unknown): string =>
  typeof v === 'string' || typeof v === 'number' ? String(v) : '';

// 공통 SP PR_GET_EXCEL_UPLOAD_RESULT 의 O_CUR_LIST(오류 행) → 결과 그리드 행. Check(=MESSAGE_TEXT) +
//   데이터 컬럼(ATTRIBUTE1..n = EXCEL_UPLOAD_HEADER_LABELS 위치 매핑). 행번호는 그리드 기본 행헤더(No)가 담당.
const toErrorRow = (row: Record<string, unknown>): WijmoRowItem => {
  const out: WijmoRowItem = { MESSAGE_TEXT: str(getCI(row, 'MESSAGE_TEXT')) };
  EXCEL_UPLOAD_HEADER_LABELS.forEach((_, i) => {
    const key = `ATTRIBUTE${i + 1}`;
    out[key] = str(getCI(row, key));
  });
  return out;
};

// 결과 그리드 컬럼 — 헤더는 다국어(t) 를 쓰지 않고 admin 등록 라벨 그대로(평문). 오류 행만 오므로 전 컬럼 빨간 배경.
//   Check = 오류 사유(MESSAGE_TEXT, AS-IS ExcelUploadForm2 의 Check 컬럼), 이후 엑셀 데이터 컬럼.
const RESULT_COLUMNS: RawFlexGridColumnConfig[] = [
  {
    colNm: 'MESSAGE_TEXT',
    colLblNm: 'Check',
    horzAlgnCd: 'L',
    colWth: 240,
    display: true,
    visible: true,
    cellColor: ERROR_ROW_COLOR,
  },
  ...EXCEL_UPLOAD_HEADER_LABELS.map((label, i) => ({
    colNm: `ATTRIBUTE${i + 1}`,
    colLblNm: label,
    horzAlgnCd: 'C' as const,
    colWth: 110,
    display: true,
    visible: true,
    cellColor: ERROR_ROW_COLOR,
  })),
];

export const ExcelUploadModal = ({ open, modalClose, onUploaded, onSave }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;

  const [files, setFiles] = useState<FileInfo[]>([]);
  const [uploading, setUploading] = useState(false);
  const uploadingRef = useRef(false);
  const [result, setResult] = useState({ success: '', error: '', total: '' });
  // 검증(mode=0) 오류 행 상세 — Upload Result 아래 그리드에 표시(AS-IS ExcelUploadForm2 Error Detail 파리티).
  const [errorRows, setErrorRows] = useState<WijmoRowItem[]>([]);

  const resetResult = () => {
    setResult({ success: '', error: '', total: '' });
    setErrorRows([]);
  };

  const handleClose = () => {
    setFiles([]);
    resetResult();
    modalClose();
  };

  const handleUpload = async () => {
    if (uploadingRef.current) return; // 동기 가드 — 이중발사 방지
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
        `/${MENU_ID}/${ADMIN_SHEET_NAME[SHEETS.ROUTE]}/UPLOAD/excel-upload`,
        formData
      );
      // 저장 false-success 판별 (nscm-patterns §5-10 — 인터셉터가 500 도 resolve).
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
      const success = pick(cnt, 'SUCCESS_COUNT');
      const error = pick(cnt, 'ERROR_COUNT');
      setResult({ success, error, total: pick(cnt, 'TOTAL_COUNT') });
      // 오류 행 상세(O_CUR_LIST — SP 가 UPLOAD_STATUS_CODE='ERROR' 행만 반환).
      const listRows = (r.O_CUR_LIST ?? r.o_cur_list ?? []) as Record<string, unknown>[];
      setErrorRows(listRows.map(toErrorRow));
      // 검증(mode=0)만 끝난 상태 — 실제 적재는 onSave(mode=1) 2번째 호출이 한다.
      //   전량 게이트: 오류 행이 있으면 저장 차단(SP mode>0 내부 게이트와 동일). 통과분만 저장한다.
      if (Number(error || 0) > 0) {
        void setAlert({
          type: 'alert',
          content: t(
            'MSG00657',
            '_Cannot save while error rows exist. Please fix the file and re-upload.'
          ),
        });
        return;
      }
      if (Number(success || 0) === 0) {
        void setAlert({ type: 'alert', content: t('MSG00152', '_No data to save.') });
        return;
      }
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
              label={t(LBL.EXCEL_FILE, '_Excel File')}
              labelAlign='right'
              render={() => (
                <FileUploader
                  placeholder=''
                  acceptFiles={['.xlsx', '.xls']}
                  multiple={false}
                  selectedFiles={files}
                  onFileChange={value => {
                    // @lges FileUploader 는 multiple=false 여도 append 하므로 2개 이상이면 반려(FcstUploadModal 규약).
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
