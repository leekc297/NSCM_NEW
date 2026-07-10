import { useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, DataGrid } from '@shared/components';
import { Button, FileUploader, FormItem, Label, TextField } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { useMessageStore } from '@shared/stores';

import styles from './FcstUploadModal.module.scss';

// FileUploader onFileChange 항목 (@lges FileInfoType — file 원본 포함)
interface FileInfo {
  name: string;
  size: number;
  url: string;
  file?: File;
}

interface FcstUploadModalProps {
  open: boolean;
  modalClose: () => void;
  // 업로드 체인 키 — FileController /{mnuId}/{shtNm}/{mnuBtnCd}/excel-upload + SCM_ADM_EXCEL_COLUMNS
  //   SHEET_NAME=#{shtNm} 조회 (DMF0014 = 'FCST Upload' 기존 등록명)
  menuId?: string;
  sheetName?: string;
  // 업로드 성공 후 메인 재조회 트리거
  onUploaded?: () => void;
  // Error Detail grid 라벨 — SCM_ADM_EXCEL_COLUMNS.HEADER_CONTENT 순서 (O_CUR_LIST 의
  //   ATTRIBUTE1~n 이 이 순서와 1:1 — G6 스모크 실측 2026-07-04)
  attributeHeaders?: string[];
}

// DMF0014 HEADER_CONTENT 기본값 (사내 SCM_ADM_EXCEL_COLUMNS 실측 — AS-IS 원본 보존분)
const DMF0014_HEADERS = [
  'Division*',
  'Sales Site*',
  'Plant Site*',
  'Customer Project*',
  'Customer Model*',
  'Incoterms*',
  'FCST Type*',
  'DOM/EXP*',
  'Measure Group*',
  'Measure*',
  'Upload UOM*',
  'Project',
  'Model',
];

interface UploadResultState {
  success: string;
  error: string;
  total: string;
}

// AS-IS 공통 ExcelUploadForm("DMF0014", 'FCST Upload') 1:1 기능화 (2026-07-04) —
//   POST /{mnuId}/{shtNm}/UPLOAD/excel-upload (multipart 'file')
//   → FileServiceImpl: SCM_ADM_EXCEL_COLUMNS(HEADER_CONTENT 매핑) → PR_SAVE_EXCEL_UPLOAD(스테이징)
//   → ${validProc}=PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD(mode=0) → PR_GET_EXCEL_UPLOAD_RESULT.
//   응답 키 = OUT 파라미터명 '@' 제거 (BaseService L82~86): O_CUR_CNT / O_CUR_LIST / O_RESULT_CURSOR.
export const FcstUploadModal = ({
  open,
  modalClose,
  menuId = 'DMF0014',
  sheetName = 'FCST Upload',
  onUploaded,
  attributeHeaders = DMF0014_HEADERS,
}: FcstUploadModalProps) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;

  const [files, setFiles] = useState<FileInfo[]>([]);
  const [uploading, setUploading] = useState(false);
  // ⭐ 이중발사 동기 가드 (2026-07-08 사고) — `disabled={uploading}`(state)는 리렌더 후에야 반영되므로
  //   같은 tick 내 빠른 더블클릭/합성 이벤트로 handleUpload 가 2회 실행됨 → 스테이징 2배 적재 →
  //   같은 초(CREATION_DATE) 내 동일 업무키 중복 → SP 'Duplication Key' 전량 실패. ref 는 즉시 반영.
  const uploadingRef = useRef(false);
  const [result, setResult] = useState<UploadResultState>({ success: '', error: '', total: '' });
  const [errorRows, setErrorRows] = useState<WijmoRowItem[]>([]);

  // ATTRIBUTEn → HEADER_CONTENT 라벨 / EXCEL_ROW 선두 (O_CUR_LIST 실측 키 순서는 비보장 — 정렬)
  const labelOf = (k: string): string => {
    if (k === 'EXCEL_ROW') return 'Row';
    const m = /^ATTRIBUTE(\d+)$/.exec(k);
    if (m) return attributeHeaders[Number(m[1]) - 1] ?? k;
    return k;
  };
  const orderOf = (k: string): number => {
    if (k === 'EXCEL_ROW') return -1;
    const m = /^ATTRIBUTE(\d+)$/.exec(k);
    return m ? Number(m[1]) : 999;
  };
  const errorColumns: RawFlexGridColumnConfig[] =
    errorRows.length > 0
      ? Object.keys(errorRows[0])
          .sort((a, b) => orderOf(a) - orderOf(b))
          .map(k => ({
            colNm: k,
            colLblNm: labelOf(k),
            colWth: k === 'EXCEL_ROW' ? 60 : 140,
            horzAlgnCd: 'L',
            visible: true,
            display: true,
            inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
          }))
      : [];

  // 결과 카운트 — PR_GET_EXCEL_UPLOAD_RESULT O_CUR_CNT 실측 키 (G6 HTTP 스모크 2026-07-04:
  //   SUCCESS_COUNT / ERROR_COUNT / TOTAL_COUNT + *_TITLE 라벨 컬럼)
  const pickCount = (row: Record<string, unknown>, key: string): string => {
    const v = row[key];
    return typeof v === 'string' || typeof v === 'number' ? String(v) : '';
  };

  const handleUpload = async () => {
    if (uploadingRef.current) return; // ⭐ 동기 가드 — 진행 중이면 즉시 차단(이중발사 방지)
    const file = files[0]?.file;
    if (!file) {
      void setAlert({ type: 'alert', content: t('MSG00113', '_Required column not found.') });
      return;
    }
    uploadingRef.current = true;
    setUploading(true);
    try {
      const formData = new FormData();
      formData.append('file', file);
      const res = await apiClient.post<Record<string, unknown>>(
        `/${menuId}/${sheetName}/UPLOAD/excel-upload`,
        formData
      );
      if (res.status >= 400 || Number(res.data?.code)) {
        const reason =
          (res.data as { message?: string })?.message?.trim() ||
          t('MSG00618', '_An error occurred while saving.');
        void setAlert({ type: 'alert', content: reason });
        return;
      }
      const r = res.data?.result ?? {};
      const cntRows = (r.O_CUR_CNT ?? r.o_cur_cnt ?? []) as Record<string, unknown>[];
      const listRows = (r.O_CUR_LIST ?? r.o_cur_list ?? []) as WijmoRowItem[];
      const cnt = cntRows[0] ?? {};
      const success = pickCount(cnt, 'SUCCESS_COUNT');
      const error = pickCount(cnt, 'ERROR_COUNT');
      const total = pickCount(cnt, 'TOTAL_COUNT') || String(listRows.length || '');
      setResult({ success, error, total });
      setErrorRows(listRows);
      void setToast({
        message: t('MSG00265', '_Excel upload completed. Reloading data.'),
        type: 'success',
      });
      onUploaded?.();
    } catch (e) {
      const msg = e instanceof Error ? e.message : t('MSG00618', '_An error occurred while saving.');
      void setAlert({ type: 'alert', content: msg });
    } finally {
      uploadingRef.current = false;
      setUploading(false);
    }
  };

  const handleClose = () => {
    setFiles([]);
    setResult({ success: '', error: '', total: '' });
    setErrorRows([]);
    modalClose();
  };

  return (
    <CustomDialog
      size={1000}
      type='modaless'
      position='basic'
      open={open}
      handleClose={handleClose}
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00346', '_Excel Upload')}</h2>
        </div>
      }
      customContentArea={
        <>
          <div className={styles.inputContainer}>
            <FormItem
              label={t('LBL00759', '_Excel File')}
              labelAlign='right'
              render={() => (
                <div className={styles.uploadFile}>
                  <FileUploader
                    placeholder=''
                    acceptFiles={['.xlsx', '.xls']}
                    selectedFiles={files}
                    onFileChange={value => setFiles(value)}
                    containerBoxProps={{
                      width: '480px', // 기존 240px → 2배 (사용자 요구 2026-07-07)
                    }}
                  />
                </div>
              )}
            />
            <div className={styles.buttonGroup}>
              <Button priority='normal' appearance='outlined' onClick={handleClose}>
                {t('LBL00717', '_Cancel')}
              </Button>
              <Button
                iconComponent={<ControlConfirmIcon size='default' />}
                priority='normal'
                disabled={uploading}
                onClick={() => void handleUpload()}
              >
                {t('LBL00716', '_OK')}
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
              render={() => (
                <TextField className={styles.statusInput} value={result.success} fullWidth />
              )}
              sx={{ marginLeft: '8px' }}
            />
            <FormItem
              label={t('LBL00756', '_Error')}
              labelAlign='left'
              render={() => (
                <TextField className={styles.statusInput} value={result.error} fullWidth />
              )}
              sx={{ marginLeft: '8px' }}
            />
            <FormItem
              label={t('LBL00757', '_Total')}
              labelAlign='left'
              render={() => (
                <TextField className={styles.statusInput} value={result.total} fullWidth />
              )}
              sx={{ marginLeft: '8px' }}
            />
          </div>
          <Label
            labelText={t('LBL00758', '_Error Detail')}
            sx={{ lineHeight: '150%', fontSize: '14px', marginBottom: '10px' }}
          />
          <DataGrid isReadOnly staticColumns={errorColumns} itemsSource={errorRows} />
        </>
      }
    />
  );
};
