import { type FlexGrid as TFlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useMemo, useRef, useState } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { GridAction } from '@foundation/utils';
import { CustomDialog, CustomDropdown, DataGrid, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, Tooltip } from '@shared/lges';
import { FileExceldownloadIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { MSG } from '../customer-fcst-upload.constant';
import { fetchExcelFormData } from '../utils/customer-fcst-upload.api';
import {
  buildExcelFormColumns,
  buildExcelFormRows,
  EXCEL_FILL,
  extractPeriodBuckets,
  toPreviewColumns,
  uploadableWeekTokens,
} from '../utils/customer-fcst-upload.excelForm';
import type { ExcelFormRow, StaticColumnLike } from '../utils/customer-fcst-upload.excelForm';

import styles from './CustomerFcstTemplateModal.module.scss';

/**
 * ⭐ DMF0014 Excel Form — 업로드 양식 다운로드 (hook #135 `excel-form-upload-standard`).
 *
 * 정본 = DMF0082 `ForecastTemplateModal` 1:1 (사용자 명시 2026-08-14:
 *   "EXCEL UPLOAD 기능이 있는 경우 DMF0082 의 EXCEL FORM/EXCEL UPLOAD 양식을 기본 RULE 로").
 *
 * [조회] `FORM_DATA` 배선 — BTN_MPG 'FORM_DATA' → API 'DMF0014_GET_EXCEL_FORM'
 *   → `PKG_DMF0014.P_DMF0014_GET_EXCEL_FORM_DATA`. **화면 조회조건에 걸린 데이터 전체**를 양식으로 준다.
 *   - IN = 메인 조회(FCST Upload)와 동일 축·동일 이름 → `store.filters` 를 가공 없이 전달
 *   - 값은 업로드 검증이 기대하는 표기로 SP 가 이미 내려준다 → FE 콤보 변환 없음(§3-3)
 *
 * [Excel Download] 정적 메타 컬럼(토큰 13) + **조회구간 버킷 일자 컬럼(빈칸)** 평탄 1행 헤더.
 *   ⚠ 토큰 문자열은 **원형 유지 의무** — BE `cvtListUploadRows` 가 `HEADER_CONTENT` 문자열
 *   일치로 컬럼을 찾는다. DMF0014 토큰은 `*` 를 **포함**한다(DMF0082 와 다름 — §4-2).
 *   ⭐ 값 컬럼은 **조회구간 버킷 일자(`YYYYMMDD`) 자체가 헤더**다 — 1단 헤더(사용자 지시 2026-08-14).
 *   기본구간 6개월 = 26주 → 26칸. 업로드 SP 는 타이틀행 ATTRIBUTE14~ 에서 이 날짜를 읽는다.
 */
interface CustomerFcstTemplateModalProps {
  open: boolean;
  modalClose: () => void;
  /** 부모 화면 조회 division 고정 표기 */
  divisionId: string;
  /** ⭐ 메인 그리드 조회조건(store.filters[MAIN]) 원본 — 가공 없이 그대로 SP 로 전달한다. */
  filters?: Record<string, unknown>;
  /** 메인 정적 컬럼 메타(admin `/column`) — 양식 컬럼의 단일 원천. */
  staticColumns?: StaticColumnLike[];
}

export const CustomerFcstTemplateModal = ({
  open,
  modalClose,
  divisionId,
  filters,
  staticColumns = [],
}: CustomerFcstTemplateModalProps) => {
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
  const [rows, setRows] = useState<ExcelFormRow[]>([]);
  const [isFetching, setIsFetching] = useState(false);
  useEffect(() => {
    if (!open) {
      setRows([]);
      setIsFetching(false);
    }
  }, [open]);

  // ⭐ [컬러링 2026-08-14] DMF0007 이 VALID_YN='Y' 로 표기한 주차 칸만 색칠 —
  //   "UPLOAD 시 사용자가 적용가능한 COLUMN 만 정확하게 인지" (사용자 요구).
  //   행별 판정이라 컬럼 단위 스타일로는 불가 → wijmo `formatItem` 으로 셀 단위 적용.
  //   1단 헤더 전환 후 컬럼 키 = 버킷 일자라 **환산 없이 그대로 대조**한다(구 ISO 주차 환산 폐기).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const paint = (_s: unknown, e: { panel: { cellType: number }; row: number; col: number; cell: HTMLElement }) => {
      // 데이터 셀만 (헤더 제외)
      if (e.panel !== g.cells) return;
      // 값 컬럼(= 버킷 일자 컬럼)만 대상. 1단 헤더라 binding 이 곧 `YYYYMMDD`.
      const binding = g.columns[e.col]?.binding ?? '';
      if (!/^\d{8}$/.test(binding)) return;
      const item = g.rows[e.row]?.dataItem as ExcelFormRow | undefined;
      const ok = uploadableWeekTokens(item).has(binding);
      e.cell.classList.toggle(styles.uploadableCell, ok);
      // ⭐ [2026-08-14] 해당 주차에 DMF0007 기준데이터가 없으면 **입력 불가**로 명시한다
      //   (사용자 지시: "기간에 대한 데이터가 없으면 입력 불가로 표시").
      //   색칠 없음(=중립)과 입력 불가를 구분하지 않으면 사용자가 빈칸을 "입력해도 되는 칸"으로 읽는다.
      e.cell.classList.toggle(styles.blockedCell, !ok);
      e.cell.title = ok ? '' : '입력 불가 — 해당 기간의 기준데이터(DMF0007) 없음';
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

  // ⭐ 양식 컬럼 = [정적 메타(표시 대상)] + [조회구간 버킷 일자 컬럼(빈칸)]
  //   기본구간(6개월 WEEKLY) = 26주 → 값 컬럼 26개. 구 `W27~W31` 5칸 고정은 폐기(사용자 지시 2026-08-14).
  //   버킷 목록은 SP `PERIOD_BUCKETS`(조회구간 전량, VALID_YN 무관) — 조회 전에는 값 컬럼이 없다.
  const periodBuckets = useMemo(() => extractPeriodBuckets(rows), [rows]);
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
      // 메인이 아직 조회되지 않았다 — 조회조건 확정 전에는 양식 대상이 정의되지 않는다.
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

  // ⭐ [2026-08-14 사용자 지시] 오픈 시 **자동조회 없음** — 모달을 연 뒤 [Search] 를 눌러야 조회한다.
  //   (AS-IS 팝업류 표준 = 진입 시 자동조회 없음 · Search 명시 게이트. DMF0082 도 동일하게 전환)
  //   모달을 닫으면 rows 초기화(위 effect)라 다음 오픈은 항상 빈 양식에서 시작한다.

  // 양식 다운로드 — 평탄 1행 헤더(식별=토큰 원형 / 값=버킷 일자) + 정보성 컬럼. 값 칸은 입력용 빈칸.
  const handleExcel = () => {
    if (formColumns.length === 0) {
      void setAlert({
        type: 'alert',
        content: t(MSG.EXCEL_FORM_EMPTY, '_No data found for the search conditions.'),
      });
      return;
    }
    const exportRows = buildExcelFormRows(rows, formColumns);
    // ⭐ [2026-08-14] 미리보기 배경색을 **파일에도** 유지한다. 양식에서 배경색은 장식이 아니라
    //   "여기에 입력하라"는 유일한 표식이라, 화면에만 칠하면 파일을 연 순간 인지 수단이 사라진다.
    //   exportRows 와 rows 는 같은 순서·같은 길이(1단 헤더 = 일자행 없음)라 index 로 원본 행을 찾는다.
    //   ⚠ 공용 F11 Excel Download(`GridAction.excelDownload`)와 다른 화면의 호출부는 그대로다
    //     — `cellFill` 은 선택 인자이고 여기서만 전달한다(사용자 지시 2026-08-14).
    const valueSlots = new Set(formColumns.filter(c => c.isValueSlot).map(c => c.key));
    void GridAction.flatExcelDownload(
      exportRows,
      formColumns.map(c => ({ header: c.header, key: c.key })),
      'DMF0014_Template',
      (_row, column, rowIndex) => {
        if (!valueSlots.has(column.key)) return undefined;
        return uploadableWeekTokens(rows[rowIndex]).has(column.key)
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
      disableButtonCancel
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00762', 'Excel Form')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContent}>
          {/* 표준 SearchArea — Search 버튼 상단 (Div = 메인 화면 division 고정).
              searchWrapper = flex 축소 금지 (없으면 그리드가 조회조건을 0 높이로 눌러 덮는다). */}
          <div className={styles.searchWrapper}>
            <SearchArea
              searchButtonLabel={isFetching ? t('LBL00665', 'Loading...') : t('LBL00112', '_Search')}
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
          {/* 조회 전 = 업로드 양식 미리보기(헤더만) / 조회 후 = 조회조건에 걸린 키 조합 */}
          <div className={styles.gridWrapper}>
            <DataGrid
              gridRef={gridRef}
              isReadOnly
              staticColumns={gridColumns}
              itemsSource={rows as WijmoRowItem[]}
            />
          </div>
          {/* 하단 — Excel Download 아이콘 버튼 + Close 맨 오른쪽 (정본 동일) */}
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
