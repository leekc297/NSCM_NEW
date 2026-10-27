import { useEffect, useRef, useState } from 'react';

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
} from '../../shipment-plan-electrode.constants';

import styles from './ExcelUploadModal.module.scss';

// AS-IS SSP0023 btnExcel_Upload → ExcelUploadForm2("SSP0023", sheet) 파리티 (정본 SCP0005/distribution-route).
//   업로드 SP PKG_SSP0023.P_SSP0023_SHIPMENT_PLAN_EXCEL_UPLOAD 은 2-phase(mode=0 검증·분류만 / mode>0 원장 적재).
//   공통 FileController excel-upload 체인(POST /{mnuId}/{shtNm}/UPLOAD/excel-upload, multipart 'file')은
//   mode=0(검증)만 호출하므로, 실제 적재는 onSave(mode=1) 2번째 호출이 해야 한다(정본 DMF0074 규약).
//   흐름(AS-IS ExcelUploadForm 2단계): 파일 선택 → 검증(mode=0) 결과 표시 → OK → onSave(mode=1) → 닫기.
//   재조회 확인(MSG00265)은 AS-IS 처럼 팝업이 닫힌 뒤 페이지(modalClose)가 처리한다.
//   주의: shtNm 은 proc 매핑 SHT_NM('main')이 아니라 컬럼/엑셀메타 SHEET_NAME(ADMIN_SHEET_NAME[SHEETS.MAIN]=
//   'Shipment Plan(Electrode)')이다 — FileController checkMenuBtnAuth 와 SCM_ADM_EXCEL_COLUMNS.SHEET_NAME=
//   #{shtNm} 조회가 이 값을 키로 쓴다(DB 실측 2026-10-14, UPLOAD/UPLOAD_SAVE 버튼메타 SHT_NM 동일값 등록).

interface FileInfo {
  name: string;
  size: number;
  url: string;
  file?: File;
}

interface Props {
  open: boolean;
  modalClose: () => void;
  // 미사용: 재조회는 닫힘 후 페이지 modalClose 가 MSG00265 확인으로 처리(AS-IS btnExcelUpload_Click).
  onUploaded?: () => void;
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

export const ExcelUploadModal = ({ open, modalClose, onSave }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const setToast = useMessageStore.getState().setToast;

  const [files, setFiles] = useState<FileInfo[]>([]);
  const [uploading, setUploading] = useState(false);
  const uploadingRef = useRef(false);
  const [result, setResult] = useState({ success: '', error: '', total: '' });
  // 검증(mode=0) 오류 행 상세 — Upload Result 아래 그리드에 표시(AS-IS ExcelUploadForm2 Error Detail 파리티).
  const [errorRows, setErrorRows] = useState<WijmoRowItem[]>([]);
  // 검증(mode=0) 완료 여부 — OK(적재) 버튼 활성 조건.
  const [classified, setClassified] = useState(false);
  const savingRef = useRef(false);

  const resetResult = () => {
    setResult({ success: '', error: '', total: '' });
    setErrorRows([]);
    setClassified(false);
  };

  // AS-IS btnOK.Enabled — 검증 완료 · 성공 1건 이상 · 오류 0건(SP mode>0 이 오류 1건이라도 있으면 적재하지 않음).
  const canSave =
    classified && Number(result.success || 0) > 0 && Number(result.error || 0) === 0;

  // 확인 없이 닫기 — 저장 성공 직후 전용.
  const doClose = () => {
    setFiles([]);
    resetResult();
    modalClose();
  };

  // 수동 닫기(Cancel / X) — AS-IS OnClose_Click: 저장 가능 상태에서 미저장이면 취소 확인(MSG00684).
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
        `/${MENU_ID}/${ADMIN_SHEET_NAME[SHEETS.MAIN]}/UPLOAD/excel-upload`,
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
      setClassified(true);
      // 검증(mode=0)만 끝난 상태 — 실제 적재는 OK(handleSave → onSave mode=1)가 한다.
      //   전량 게이트: 오류 행이 있으면 저장 차단(SP mode>0 내부 게이트와 동일).
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
      // 이전 1단계 흐름(검증 직후 바로 적재) — AS-IS 2단계(결과 확인 후 OK)로 전환하며 handleSave 로 이동.
      // if (onSave) {
      //   const saved = await onSave();
      //   if (!saved.ok) {
      //     void setAlert({
      //       type: 'alert',
      //       content: saved.message?.trim() || t('MSG00618', '_An error occurred while uploading.'),
      //     });
      //     return;
      //   }
      // }
      // void setToast({
      //   message: t('MSG00265', '_Excel upload completed. Reloading data.'),
      //   type: 'success',
      // });
      // onUploaded();
      // handleClose();
      void setToast({
        message: t('MSG00659', '_Validation complete. Review results then press OK to save.'),
        type: 'default',
      });
    } catch (e) {
      const msg = e instanceof Error ? e.message : t('MSG00618', '_An error occurred while uploading.');
      void setAlert({ type: 'alert', content: msg });
    } finally {
      uploadingRef.current = false;
      setUploading(false);
    }
  };

  // AS-IS OnOpen_Click — 파일을 고르면 바로 검증(mode=0)한다. 새 파일이면 resetResult 로 classified=false.
  useEffect(() => {
    if (!files[0]?.file || classified || uploadingRef.current) return;
    void handleUpload();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [files]);

  // AS-IS OnSave_Click — 검증 통과분 적재(mode=1) 후 저장 완료 안내하고 닫는다.
  const handleSave = async () => {
    if (!onSave || !canSave || savingRef.current) return;
    savingRef.current = true;
    setUploading(true);
    try {
      const saved = await onSave();
      if (!saved.ok) {
        void setAlert({
          type: 'alert',
          content: saved.message?.trim() || t('MSG00618', '_An error occurred while uploading.'),
        });
        return;
      }
      void setToast({ message: t('MSG00002', '_Saved successfully.'), type: 'success' });
      doClose();
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
                          'Only one file is allowed. Remove the existing file first.'
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
                disabled={uploading || !canSave}
                onClick={() => void handleSave()}
              >
                {t(LBL.OK, '_OK')}
              </Button>
              <Button priority='normal' appearance='outlined' onClick={() => void handleClose()}>
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
