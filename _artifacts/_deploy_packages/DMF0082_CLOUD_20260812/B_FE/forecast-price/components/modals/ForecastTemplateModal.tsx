import { useEffect, useMemo, useState } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { CustomDialog, CustomDropdown, DataGrid, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, Tooltip } from '@shared/lges';
import { FileExceldownloadIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { MSG, TEMPLATE_EXCEL_PREFIX, UPLOAD_HEADERS } from '../../forecast-price.constants';
import type { UploadPreviewRow } from '../../utils/forecast-price.api';
import { fetchUploadPreview } from '../../utils/forecast-price.api';

import styles from './ForecastTemplateModal.module.scss';

// ⭐ Excel Form — ⭐ division 40 전용 (SP 검증 'Invalid Division(40 Only)' 실측).
//   metal-link MetalLinkTemplateModal 레이아웃 1:1: 상단 SearchArea(Div 고정) /
//   하단 [Excel Download 아이콘] + [Close].
//
//   [조회 — 2026-08-12 보완] Search = UPLOAD_DATA 배선(BTN_MPG 'UPLOAD_DATA' → API 'DMF0082_GET_UPLOAD_DATA'
//   → PKG_DMF0082.P_DMF0082_GET_EXCEL_UPLOAD_DATA, BODY L4963). 본인 최종 업로드 성공분을 Daily 로
//   풀어(월별 M4~M16 → BUCKET 일할 분배) 미리보기하는 SP 정본 계약:
//   - IN = createdBy 단일 (PROC_M 실측). ⭐ 화면 Bucket 조회조건을 받을 파라미터는 계약에 없음 —
//     BUCKET 은 SP 내부에서 업로드 division 기준 DM_MST_BUCKET_CONVERSION(L5203·L5391) +
//     LOOKUP 'DEFAULT_BUCKET_DAY'(L5250·L5449) 마스터로 자동 수급 (임의 파라미터 추가 금지).
//   - 그리드 = o_rc2 PIVOT (키 10컬럼 + 동적 D{yyyymmdd} 일자 컬럼 — "Daily 로 풀어서 보여주는" 목적 원문).
//   - 0건 = MSG00705 (SP L5040 'NO EXCEL DATA' 의미역 — 신규 채번 2026-08-12).
//
//   [Excel Download] 업로드 양식 23컬럼(HEADER_CONTENT 1:1 = UPLOAD_HEADERS) 평탄 헤더로 다운로드.
//   ⚠ 엑셀 헤더 'M4'~'M16' **원형 유지 의무** — BE cvtListUploadRows 가 HEADER_CONTENT 문자열 일치로
//   컬럼을 매핑한다. 그리드/미리보기 라벨에만 실월(당월+4~+16 — SP v_start/end_yyyymm 계약) 병기.
//   조회 데이터가 있으면 양식에 값을 채워 export:
//   - 키 컬럼 = 업로드 검증이 기대하는 표기(실측): End Customer=NAME(L4368 EC.NAME) /
//     Sales Site=코드(L4434) / FCST Type=NAME(L4592) / Cell Prod Site=NAME(L4668 ATTRIBUTE1) /
//     Measure=NAME(L4718 SEGMENT4) → o_rc2 의 *_NAME 컬럼 사용.
//   - M4~M16 월값 복원 = MEASURE 'LOC' 는 월내 복제값(첫 값 — L5567~5593 replic) /
//     그 외(MKT_FCST)는 월합계(주간 L5336·일간 L5482~5483 잔여 보정으로 총량 보존 — 정확 복원).
//   데이터 없으면 기존처럼 빈 양식(헤더 1행)만 내려준다.
interface ForecastTemplateModalProps {
  open: boolean;
  modalClose: () => void;
  // 부모 화면 조회 division 고정 전달 (metal-link 동일 패턴)
  divisionId: string;
  // ⭐ 부모 화면 Bucket 조회조건 승계 표시 (2026-08-12 사용자 지시 — 비활성 고정).
  //   BUCKET 은 SP 내부 자동 수급(DM_MST_BUCKET_CONVERSION + DEFAULT_BUCKET_DAY lookup)이라
  //   파라미터로 보내지 않는다 — 연동 사실을 UI 로 보여주는 표시 전용.
  bucketType: string;
}

/** o_rc2 커서 → 업로드 양식 키 10컬럼 매핑 (커서 실측 2026-08-12 — BE 는 NULL 값 컬럼 생략) */
const PREVIEW_KEY_COLUMNS: { header: (typeof UPLOAD_HEADERS)[number]; field: string }[] = [
  { header: 'Div', field: 'DIVISION_ID' },
  { header: 'End Customer', field: 'END_CUSTOMER_NAME' },
  { header: 'Sales Site', field: 'SCM_SITE_ID' },
  { header: 'Model', field: 'ITEM_ID' },
  { header: 'Incoterms', field: 'INCOTERMS' },
  { header: 'FCST Type', field: 'FCST_TYPE_NAME' },
  { header: 'Customs Handbook', field: 'DOM_EXP' },
  { header: 'Cell Prod Site', field: 'CELL_PROD_SITE_NAME' },
  { header: 'Currency', field: 'CURRENCY' },
  { header: 'Measure', field: 'MEASURE_NAME' },
];

/** 'M{n}' → 대상 월 yyyyMM (SP v_start/end = ADD_MONTHS(SYSDATE, 4~16) 계약 1:1) */
const ymOfOffset = (offset: number): string => {
  const now = new Date();
  const dt = new Date(now.getFullYear(), now.getMonth() + offset, 1);
  return `${dt.getFullYear()}${String(dt.getMonth() + 1).padStart(2, '0')}`;
};

export const ForecastTemplateModal = ({
  open,
  modalClose,
  divisionId,
  bucketType,
}: ForecastTemplateModalProps) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  // Div·Bucket 표기 — 메인 화면 조회조건 고정 (수정 불가 · metal-link MetalLinkTemplateModal 동일)
  const [myDivisions, bucketTypeCombo] = useTabComboQueries({
    filters: ['MyDivision', 'BucketType'],
  });
  const divisionOptions = useMemo<Array<{ value: string; label: string }>>(() => {
    const arr = (myDivisions ?? []) as Array<{ CODE?: string; NAME?: string }>;
    return arr.map(r => {
      const code = String(r.CODE ?? '');
      const name = String(r.NAME ?? code);
      const label = code === name || name === '' ? code : `${code} (${name})`;
      return { value: code, label };
    });
  }, [myDivisions]);
  const bucketOptions = useMemo<Array<{ value: string; label: string }>>(() => {
    const arr = (bucketTypeCombo ?? []) as Array<{ CODE?: string; NAME?: string }>;
    return arr.map(r => ({ value: String(r.CODE ?? ''), label: String(r.NAME ?? r.CODE ?? '') }));
  }, [bucketTypeCombo]);

  // 조회 상태 — AS-IS 팝업류 표준: 진입 시 자동조회 없음, Search 명시 게이트 (모달 닫으면 초기화)
  const [rows, setRows] = useState<UploadPreviewRow[]>([]);
  const [isFetching, setIsFetching] = useState(false);
  useEffect(() => {
    if (!open) {
      setRows([]);
      setIsFetching(false);
    }
  }, [open]);

  // 업로드 양식 컬럼 = UPLOAD_HEADERS 원형 (엑셀 헤더 = BE HEADER_CONTENT 매핑 키 — 변형 금지)
  const uploadColumns = useMemo(
    () => UPLOAD_HEADERS.map((header, i) => ({ header, key: `COL${i}` })),
    []
  );

  // o_rc2 동적 D{yyyymmdd} 컬럼 — 전 행 union·오름차순 (BE 가 NULL 컬럼을 생략하므로 행별 키가 다름)
  const dailyCols = useMemo<string[]>(() => {
    const set = new Set<string>();
    rows.forEach(row => {
      Object.keys(row).forEach(k => {
        if (/^D\d{8}$/.test(k)) set.add(k);
      });
    });
    return [...set].sort();
  }, [rows]);

  // 그리드 컬럼 — 조회 전: 업로드 양식 23컬럼 미리보기(M4~M16 라벨에 실월 병기) /
  //             조회 후: 키 10컬럼 + Daily 동적 컬럼 (SP "Daily 로 풀어서 보여주는" 목적 원문)
  const gridColumns = useMemo<RawFlexGridColumnConfig[]>(() => {
    if (rows.length === 0) {
      return uploadColumns.map(({ header, key }) => {
        const m = /^M(\d+)$/.exec(header);
        const ym = m ? ymOfOffset(Number(m[1])) : '';
        return {
          colNm: key,
          colLblNm: m ? `${header} (${ym})` : header,
          colWth: 120,
          horzAlgnCd: 'L',
          visible: true,
          display: true,
          inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
        };
      });
    }
    const keyCols: RawFlexGridColumnConfig[] = PREVIEW_KEY_COLUMNS.map(({ header, field }) => ({
      colNm: field,
      colLblNm: header,
      colWth: 120,
      horzAlgnCd: 'L',
      visible: true,
      display: true,
      inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
    }));
    const dCols: RawFlexGridColumnConfig[] = dailyCols.map(colNm => ({
      colNm,
      colLblNm: `${colNm.slice(1, 5)}-${colNm.slice(5, 7)}-${colNm.slice(7, 9)}`,
      colWth: 90,
      horzAlgnCd: 'R',
      visible: true,
      display: true,
      inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
    }));
    return [...keyCols, ...dCols];
  }, [rows.length, uploadColumns, dailyCols]);

  // Search — UPLOAD_DATA call-proc (createdBy 단일 파라미터 — SP 계약. Bucket 은 SP 내부 자동 수급)
  //   silent = 오픈 자동조회 경로(0건이어도 alert 없이 빈 양식 유지 — alert 는 명시 Search 시에만)
  const handleFind = (silent = false) => {
    if (isFetching) return;
    setIsFetching(true);
    void fetchUploadPreview()
      .then(({ ok, message, pivot }) => {
        setRows(ok ? pivot : []);
        if (!ok) {
          if (!silent) {
            void setAlert({
              type: 'alert',
              content: message || t(MSG.SAVE_ERROR, '_Search failed.'),
            });
          }
          return;
        }
        if (pivot.length === 0 && !silent) {
          // SP L5040 'NO EXCEL DATA' — 본인 최종 업로드 성공분 부재
          void setAlert({
            type: 'alert',
            content: t(MSG.UPLOAD_PREVIEW_EMPTY, '_No uploaded Excel data. Please run Excel Upload first.'),
          });
        }
      })
      .finally(() => setIsFetching(false));
  };

  // ⭐ 오픈 시 자동 조회 (2026-08-12 사용자 "조회 되도록 보완" — 팝업 자동조회가 화면 표준.
  //   통합테스트 No.61-② 'Project 팝업 오픈 시 자동조회 안 됨' 과 동일 계보). 0건은 조용히 빈 양식.
  useEffect(() => {
    if (open) handleFind(true);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  // ⭐ 템플릿 다운로드 — 업로드 양식 그대로의 평탄 헤더(M4~M16 원형). 조회 데이터가 있으면 값 복원 채움.
  const handleExcel = () => {
    let exportRows: Record<string, string>[] = [];
    if (rows.length > 0) {
      exportRows = rows.map(row => {
        const out: Record<string, string> = {};
        PREVIEW_KEY_COLUMNS.forEach(({ field }, i) => {
          out[`COL${i}`] = String(row[field] ?? '');
        });
        const isLoc = String(row['MEASURE'] ?? '') === 'LOC';
        for (let m = 4; m <= 16; m += 1) {
          const ym = ymOfOffset(m);
          const monthCols = dailyCols.filter(c => c.startsWith(`D${ym}`));
          let value = '';
          if (isLoc) {
            // LOC = 월내 복제값 (SP L5567~5593 — bucket 요일/1일자에 동일 단가 복제) → 첫 값
            const first = monthCols.map(c => row[c]).find(v => v !== null && v !== undefined && v !== '');
            value = first !== undefined ? String(first) : '';
          } else {
            // MKT_FCST = 월합계 (주간 L5336·일간 L5482~5483 잔여 보정 — 월총량 보존, 정확 복원)
            let sum = 0;
            let has = false;
            monthCols.forEach(c => {
              const v = row[c];
              if (v !== null && v !== undefined && v !== '') {
                sum += Number(v);
                has = true;
              }
            });
            value = has ? String(sum) : '';
          }
          out[`COL${10 + (m - 4)}`] = value;
        }
        return out;
      });
    }
    void GridAction.flatExcelDownload(exportRows, uploadColumns, TEMPLATE_EXCEL_PREFIX).catch(
      (error: unknown) => {
        void setAlert({
          type: 'alert',
          content: error instanceof Error ? error.message : 'Excel download failed.',
        });
      }
    );
  };

  return (
    <CustomDialog
      open={open}
      size={1400}
      type='modal'
      position='basic'
      handleClose={modalClose}
      disableButtonCancel
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00762', 'Excel Form')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContent}>
          {/* ⭐ 표준 SearchArea — Search 버튼 상단 (Div = 메인 화면 division 고정) */}
          <SearchArea
            searchButtonLabel={isFetching ? t('LBL00665', 'Loading...') : t('LBL00112', '_Search')}
            onSearch={() => handleFind(false)}
            conditions={
              <>
                <Grid size={3}>
                  <FormItem
                    label={t('LBL00001', 'Div.')}
                    labelAlign='right'
                    className={commonStyles.formItem}
                    render={() => (
                      <CustomDropdown disabled value={divisionId} options={divisionOptions} />
                    )}
                  />
                </Grid>
                {/* ⭐ Bucket — 메인 화면 조회조건 승계 표시(비활성 고정 — 2026-08-12 사용자 지시).
                    SP 는 BUCKET 을 내부 마스터로 자동 수급하므로 파라미터 전달 없음(표시 전용) */}
                <Grid size={3}>
                  <FormItem
                    label={t('LBL00710', '_bucket')}
                    labelAlign='right'
                    className={commonStyles.formItem}
                    render={() => (
                      <CustomDropdown disabled value={bucketType} options={bucketOptions} />
                    )}
                  />
                </Grid>
              </>
            }
          />
          {/* 조회 전 = 업로드 양식 미리보기(헤더만) / 조회 후 = 최종 업로드분 Daily 분배 미리보기 */}
          <div className={styles.gridWrapper}>
            <DataGrid isReadOnly staticColumns={gridColumns} itemsSource={rows} />
          </div>
          {/* ⭐ 하단 — Excel Download 아이콘 버튼 + Close 맨 오른쪽 (metal-link 동일) */}
          <div className={styles.buttonWrapper}>
            <Tooltip followCursor title={t('LBL00763', 'Excel Download')} placement='bottom'>
              <div>
                <Button
                  appearance='outlined'
                  priority='normal'
                  size='medium'
                  iconComponent={<FileExceldownloadIcon />}
                  onClick={handleExcel}
                />
              </div>
            </Tooltip>
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('LBL00627', 'Close')}
              onClick={modalClose}
            />
          </div>
        </div>
      }
    />
  );
};
