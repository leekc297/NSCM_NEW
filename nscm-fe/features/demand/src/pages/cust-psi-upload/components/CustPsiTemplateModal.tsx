import { type FlexGrid as TFlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { attachRowNoHeader, GridAction } from '@foundation/utils';
import { CustomDialog, CustomDropdown, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, Tooltip } from '@shared/lges';
import { FileExceldownloadIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { MSG } from '../cust-psi-upload.constant';
import { fetchExcelFormData } from '../utils/cust-psi-upload.api';
import {
  buildExcelFormColumns,
  buildExcelFormRows,
  EXCEL_FILL,
  extractPeriodBuckets,
  toPreviewColumns,
  uploadableWeekTokens,
} from '../utils/cust-psi-upload.excelForm';
import type { ExcelFormRow, StaticColumnLike } from '../utils/cust-psi-upload.excelForm';

import styles from './CustPsiTemplateModal.module.scss';

/**
 * DMF0013 Excel Form — 업로드 양식 다운로드 (hook #135 `excel-form-upload-standard`).
 *   정본 = DMF0082 ForecastTemplateModal / 사내 승계 DMF0014 CustomerFcstTemplateModal 1:1.
 *
 * [조회] `FORM_DATA` 배선 — SP 는 헤더 캐리어 1행(식별 컬럼 NULL + PERIOD_BUCKETS)만 반환 —
 *   양식은 데이터 없이 헤더만 생성한다.
 *   - IN = 메인 조회(PSI Upload)와 동일 축·동일 이름 → store.filters 를 가공 없이 전달
 * [Excel Download] 정적 메타 컬럼(토큰 13) + 조회구간 버킷 일자 컬럼(빈칸) 평탄 1행 헤더.
 *   토큰 문자열은 원형 유지 의무(*  포함). 값 컬럼 헤더 = 버킷 일자 YYYYMMDD.
 */
interface CustPsiTemplateModalProps {
  open: boolean;
  modalClose: () => void;
  /** 부모 화면 조회 division 고정 표기 */
  divisionId: string;
  /** 메인 그리드 조회조건(store.filters[MAIN]) 원본 — 가공 없이 그대로 SP 로 전달한다. */
  filters?: Record<string, unknown>;
  /** 메인 정적 컬럼 메타(admin `/column`) — 양식 컬럼의 단일 원천. */
  staticColumns?: StaticColumnLike[];
}

export const CustPsiTemplateModal = ({
  open,
  modalClose,
  divisionId,
  filters,
  staticColumns = [],
}: CustPsiTemplateModalProps) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  // Div 표기 — 메인 화면 조회조건 고정(수정 불가)
  const [myDivisions] = useTabComboQueries({ filters: ['MyDivision'] });
  const divisionOptions = useMemo<Array<{ value: string; label: string }>>(() => {
    const arr = (myDivisions ?? []) as Array<{ CODE?: string; NAME?: string }>;
    return arr.map(r => {
      const code = String(r.CODE ?? '');
      const name = String(r.NAME ?? code);
      return { value: code, label: code === name || name === '' ? code : `${code} (${name})` };
    });
  }, [myDivisions]);

  const gridRef = useRef<TFlexGrid>();
  // ResultArea 가 F4/헤더 필터 적용 후 실제 표시 건수를 "총 N건"에 반영하려면 이 ref 가 필요하다.
  const gridFilterRef = useRef<FlexGridFilter | undefined>();
  const [rows, setRows] = useState<ExcelFormRow[]>([]);
  const [isFetching, setIsFetching] = useState(false);
  useEffect(() => {
    if (!open) {
      setRows([]);
      setIsFetching(false);
    }
  }, [open]);

  // VALID_YN='Y' 로 표기한 주차 칸만 색칠 — 행별 판정이라 wijmo formatItem 으로 셀 단위 적용.
  //   1단 헤더 전환 후 컬럼 키 = 버킷 일자라 환산 없이 그대로 대조한다.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const paint = (
      _s: unknown,
      e: { panel: { cellType: number }; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel !== g.cells) return;
      const binding = g.columns[e.col]?.binding ?? '';
      if (!/^\d{8}$/.test(binding)) return;
      const item = g.rows[e.row]?.dataItem as ExcelFormRow | undefined;
      const ok = uploadableWeekTokens(item).has(binding);
      // 셀 배경 = 공통 표준(hook #95) 클래스만. 입력 가능 = wj-cell-editable / 입력 불가 = wj-cell-non-editable.
      e.cell.classList.toggle('wj-cell-editable', ok);
      e.cell.classList.toggle('wj-cell-non-editable', !ok);
      e.cell.title = ok ? '' : '입력 불가 — 해당 기간의 기준데이터 없음';
    };
    g.formatItem.addHandler(paint);
    g.invalidate();
    return () => {
      try {
        g.formatItem.removeHandler(paint);
      } catch {
        /* unmount race */
      }
    };
  }, [rows]);

  // 양식 컬럼 = [정적 메타(표시 대상)] + [조회구간 버킷 일자 컬럼(빈칸)]
  const periodBuckets = useMemo(() => extractPeriodBuckets(rows), [rows]);
  // SP 는 식별 컬럼 전부 NULL 인 헤더 캐리어 1행만 내려준다 → 컬럼(PERIOD_BUCKETS) 생성에만 쓰고
  //   미리보기·다운로드의 데이터행에는 넣지 않는다 → 양식 = 헤더 1행 + 빈 시트.
  const headerOnly = rows.length > 0 && rows.every(r => !r['SCM_SITE_ID']);
  const dataRows = useMemo(() => (headerOnly ? [] : rows), [headerOnly, rows]);

  useEffect(() => {
    if (gridRef.current) attachRowNoHeader(gridRef.current, t('LBL00674', 'No'));
  }, [gridRef, t, dataRows]);
  const formColumns = useMemo(
    () => buildExcelFormColumns(staticColumns, periodBuckets),
    [staticColumns, periodBuckets]
  );
  const gridColumns = useMemo<RawFlexGridColumnConfig[]>(
    () => toPreviewColumns(formColumns),
    [formColumns]
  );

  // Search — 메인 조회조건(filters)을 그대로 전달.
  const handleFind = () => {
    if (isFetching) return;
    if (!filters) {
      void setAlert({
        type: 'alert',
        content: t(MSG.EXCEL_FORM_EMPTY, '_No data found for the search conditions.'),
      });
      return;
    }
    setIsFetching(true);
    void fetchExcelFormData(filters)
      .then(({ ok, message, rows: found }) => {
        setRows(ok ? found : []);
        if (!ok) {
          void setAlert({
            type: 'alert',
            content: message || t(MSG.EXCEL_FORM_EMPTY, '_Search failed.'),
          });
          return;
        }
        if (found.length === 0) {
          void setAlert({
            type: 'alert',
            content: t(MSG.EXCEL_FORM_EMPTY, '_No data found for the search conditions.'),
          });
        }
      })
      .finally(() => setIsFetching(false));
  };

  // 오픈 시 자동조회 없음 — 모달을 연 뒤 [Search] 를 눌러야 조회한다. 닫으면 rows 초기화(위 effect).

  // 양식 다운로드 — 평탄 1행 헤더(식별=토큰 원형 / 값=버킷 일자) + 정보성 컬럼. 값 칸은 입력용 빈칸.
  const handleExcel = () => {
    if (formColumns.length === 0) {
      void setAlert({
        type: 'alert',
        content: t(MSG.EXCEL_FORM_EMPTY, '_No data found for the search conditions.'),
      });
      return;
    }
    const exportRows = buildExcelFormRows(dataRows, formColumns);
    const valueSlots = new Set(formColumns.filter(c => c.isValueSlot).map(c => c.key));
    void GridAction.flatExcelDownload(
      exportRows,
      formColumns.map(c => ({ header: c.header, key: c.key })),
      'DMF0013_Template',
      (_row, column, rowIndex) => {
        if (!valueSlots.has(column.key)) return undefined;
        return uploadableWeekTokens(dataRows[rowIndex]).has(column.key)
          ? EXCEL_FILL.UPLOADABLE
          : EXCEL_FILL.BLOCKED;
      }
    ).catch(() => {
      void setAlert({ type: 'alert', content: t(MSG.EXCEL_FORM_EMPTY, '_Excel download failed.') });
    });
  };

  return (
    <CustomDialog
      open={open}
      size={1400}
      type='modal'
      position='basic'
      handleClose={modalClose}
      // 컬럼 필터 팝업(FlexGridFilter)이 MuiDialog-container 밖에 append 돼 MUI FocusTrap 과
      // 충돌한다 — 필터 팝업의 Search 입력이 클릭/타이핑해도 반응 없어 보이는 원인. CustomDialog.tsx
      // 상단 주석(DMF0082 ExchangeRateModal) 과 동일 원인.
      disableEnforceFocus
      disableButtonCancel
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00762', 'Excel Form')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContent}>
          <div className={styles.searchWrapper}>
            <SearchArea
              searchButtonLabel={t('LBL00664', 'Search')}
              onSearch={handleFind}
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
                </>
              }
            />
          </div>
          {/* 조회 전 = 식별 컬럼만 / 조회 후 = 식별 컬럼 + 조회구간 버킷 일자 컬럼 (데이터행 없음 — HDRONLY) */}
          <div className={styles.gridWrapper}>
            <ResultArea
              title=''
              count={dataRows.length}
              gridRef={gridRef}
              gridFilterRef={gridFilterRef}
            >
              <DataGrid
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                isReadOnly
                staticColumns={gridColumns}
                itemsSource={dataRows as WijmoRowItem[]}
              />
            </ResultArea>
          </div>
          {/* 하단 — Excel Download 아이콘 버튼 + Close 맨 오른쪽 */}
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
