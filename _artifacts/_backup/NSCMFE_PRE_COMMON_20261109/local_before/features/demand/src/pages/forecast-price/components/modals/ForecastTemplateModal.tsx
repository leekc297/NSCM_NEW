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

import { MSG, TEMPLATE_EXCEL_PREFIX } from '../../forecast-price.constants';
import { useForecastPriceStore } from '../../useForecastPriceStore';
import type { UploadPreviewRow } from '../../utils/forecast-price.api';
import { fetchExcelFormData } from '../../utils/forecast-price.api';
import {
  buildExcelFormColumns,
  buildExcelFormRows,
  pruneEmptyInfoColumns,
  toPreviewColumns,
} from '../../utils/forecast-price.excelForm';

import styles from './ForecastTemplateModal.module.scss';

// ⭐ Excel Form — ⭐ division 81 계열 전용 [E20260819-XLS81LOC] (SP 검증 'Invalid Division(81 Only)' + Form 가드 MSG01014 실측. 대상 measure LOC 한정).
//   metal-link MetalLinkTemplateModal 레이아웃 1:1: 상단 SearchArea(Div 고정) /
//   하단 [Excel Download 아이콘] + [Close].
//
//   [조회 — E20260813-EXCELFORM] Search = FORM_DATA 배선(BTN_MPG 'FORM_DATA' → API 'DMF0082_GET_EXCEL_FORM'
//   → PKG_DMF0082.P_DMF0082_GET_EXCEL_FORM_DATA). **화면 조회조건에 걸린 현재 데이터 전체**를 양식으로 내려준다.
//   - IN = 메인 조회(FcstNPrice)와 동일 축·동일 이름 → store.filters 를 가공 없이 전달
//   - 1행 = 키 조합 × 입력 가능 measure 1종 (화면 measure 개인화와 무관 — SP 가 LOOKUP 으로 확장)
//   - 값은 **업로드 검증이 기대하는 표기**로 SP 가 이미 변환해 내려준다 → FE 콤보 변환 없음
//   - 0건 = MSG01023 (MSG00705 는 '업로드분 없음' 이라 의미가 반대라 재사용 금지)
//     ⚠ 구 코드 MSG00718 은 2026-08-21 클라우드 동기화로 '권한 요청을 반려하시겠습니까?' 로 재정의됨
//
//   [Excel Download] ⭐ [E20260921-XLSFORMASIS] AS-IS DMF0020 파리티 — 평탄 1행 헤더 19컬럼:
//     Div / Team / End Customer / Project Code / Currency / Model / M0 ... M12
//   컬럼 정의 원천 = admin 메타 `SCM_MST_SHEET_COLUMNS`(DMF0082, 'Sales Price Template') 19행.
//   주의: 헤더 문자열은 원형 유지 의무 — BE cvtListUploadRows 가 HEADER_CONTENT 문자열 일치로 컬럼을 찾는다.
//   ⭐ M0~M12 는 **조회해도 항상 빈칸**이다 (사용자 지시 2026-09-21 · AS-IS SP 도 `'' AS M0..M12`).
//     SP 측에서도 구 LOC 단가 프리필을 제거했고, FE 도 buildExcelFormRows 가 월 컬럼을 비운다(이중 보장).
interface ForecastTemplateModalProps {
  open: boolean;
  modalClose: () => void;
  // 부모 화면 조회 division 고정 전달 (metal-link 동일 패턴)
  divisionId: string;
  /** 메인 그리드 조회조건(store.filters) 원본 — 있으면 그대로 SP 로 전달.
   *  [E20260825-XLSPRICECOL] 없으면(MAIN 미조회) 조회조건 기본값(searchParams)으로 자체 구성 —
   *  Excel Form 은 MAIN 조회와 무관하게 열고 Search 로 조회할 수 있다 (사용자 지시 2026-08-25). */
  filters?: Record<string, unknown>;
}

/** [E20260907-XLSMONTH] 미리보기 라벨 — AS-IS DMF0020 템플릿처럼 월 토큰(M4..M16) 원형 그대로 표시.
 *  (참고용 실제 월은 monthTokenLabel 로 산출 가능 — 현재는 AS-IS 파리티로 토큰 표기 우선.) */
const monthLabel = (token: string): string => token;

export const ForecastTemplateModal = ({
  open,
  modalClose,
  divisionId,
  filters,
}: ForecastTemplateModalProps) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;
  const gridRef = useRef<TFlexGrid>();
  // ResultArea 가 F4/헤더 필터 적용 후 실제 표시 건수를 "총 N건"에 반영하려면 이 ref 가 필요하다.
  const gridFilterRef = useRef<FlexGridFilter | undefined>();

  // Div 표기 — 메인 화면 조회조건 고정 (수정 불가 · metal-link MetalLinkTemplateModal 동일)
  const [myDivisions] = useTabComboQueries({ filters: ['MyDivision'] });
  const divisionOptions = useMemo<Array<{ value: string; label: string }>>(() => {
    const arr = (myDivisions ?? []) as Array<{ CODE?: string; NAME?: string }>;
    return arr.map(r => {
      const code = String(r.CODE ?? '');
      const name = String(r.NAME ?? code);
      const label = code === name || name === '' ? code : `${code} (${name})`;
      return { value: code, label };
    });
  }, [myDivisions]);

  // 조회 상태 — AS-IS 팝업류 표준: 진입 시 자동조회 없음, Search 명시 게이트 (모달 닫으면 초기화)
  const [rows, setRows] = useState<UploadPreviewRow[]>([]);
  const [isFetching, setIsFetching] = useState(false);
  useEffect(() => {
    if (!open) {
      setRows([]);
      setIsFetching(false);
    }
  }, [open]);

  useEffect(() => {
    if (gridRef.current) attachRowNoHeader(gridRef.current, t('LBL00674', 'No'));
  }, [gridRef, t, rows]);

  // ⭐ [E20260921-XLSFORMASIS] 양식 컬럼 = **admin 메타 주도** (SHEET_NAME='Sales Price Template').
  //   AS-IS DMF0020_SalesPriceTemplatePopup 이 DMF0000_GET_COMMON_SPREAD_TITLE 로 메타 헤더를
  //   가져와 CreateSheetHeaderColumn 하는 구조와 동일([PJ2024-50611]). 컬럼 변경은 DB 메타만 고친다.
  //   헤더 문자열 = 메타 COLUMN_LABEL_NAME = SCM_ADM_EXCEL_COLUMNS.HEADER_CONTENT 토큰 (1:1 의무).
  //   메타 조회 실패/미적재 시 buildExcelFormColumns 가 FALLBACK_TEMPLATE_COLUMNS 로 폴백한다.
  const templateColumns = useForecastPriceStore(s => s.templateColumns);
  const fetchTemplateColumns = useForecastPriceStore(s => s.fetchTemplateColumns);
  useEffect(() => {
    if (open && divisionId) fetchTemplateColumns(divisionId);
  }, [open, divisionId, fetchTemplateColumns]);

  const formColumns = useMemo(
    () => pruneEmptyInfoColumns(buildExcelFormColumns(templateColumns), rows),
    [templateColumns, rows]
  );

  // 미리보기 그리드 = 다운로드 결과와 1:1 (조회 전/후 컬럼이 갈리지 않는다)
  const gridColumns = useMemo<RawFlexGridColumnConfig[]>(
    () => toPreviewColumns(formColumns, monthLabel),
    [formColumns]
  );

  // Search — [E20260813-EXCELFORM] FORM_DATA 배선. 메인 조회조건(filters)을 그대로 전달한다.
  //   silent = 오픈 자동조회 경로(0건이어도 alert 없이 빈 양식 유지 — alert 는 명시 Search 시에만)
  // [E20260825-XLSPRICECOL] MAIN 미조회(filters 부재) 시 조회조건 기본값으로 자체 구성 —
  //   행 원천이 단가 마스터라 MAIN 조회 여부와 무관하다. 기간·division 은 화면 조회조건 상태 그대로.
  //   (createPersistedStoreWithTab 훅은 selector 전용 — getState 미제공)
  const storeSearchParams = useForecastPriceStore(s => s.searchParams);
  const storeAuthGroup = useForecastPriceStore(s => s.authGroup);
  const buildFallbackFilters = (): Record<string, unknown> => {
    const sp = storeSearchParams;
    return {
      divisionId,
      deptId: '',
      endCustomer: '',
      bizType: '',
      fromYyyymmdd: sp.startYyyymmdd,
      toYyyymmdd: sp.endYyyymmdd,
      salesSite: '',
      itemId: '',
      versionType: sp.versionType,
      qtyYn: sp.qtyYn ? 'Y' : 'N',
      userGroup: storeAuthGroup || '',
      plantSiteId: '',
      projectCode: '',
      owner: '',
      senderCode: '',
    };
  };

  const handleFind = (silent = false) => {
    if (isFetching) return;
    setIsFetching(true);
    // [E20260907-XLSMONTH] SP 는 양식 행(o_rc1 = 키 조합 × measure)만 쓰고, 기간 컬럼은
    //   기간 컬럼은 고정 월 토큰(M4~M16)이라 SP 응답의 WEEK_LIST 는 더 이상 소비하지 않는다.
    void fetchExcelFormData(filters ?? buildFallbackFilters())
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
          void setAlert({
            type: 'alert',
            content: t(MSG.EXCEL_FORM_EMPTY, '_No data found for the search conditions.'),
          });
        }
      })
      .finally(() => setIsFetching(false));
  };

  // [E20260825-XLSPRICECOL] 오픈 시 자동 조회 없음 — Search 명시 게이트 (사용자 지시 2026-08-25:
  //   "OPEN 후 조회 클릭하면 조회". AS-IS 팝업류 표준과 동일). MAIN 조회 여부와도 무관.

  // 양식 다운로드 — 평탄 1행 헤더(토큰 원형) + 정보성 컬럼 + 월 버킷(입력용 빈칸).
  const handleExcel = () => {
    if (formColumns.length === 0) {
      void setAlert({
        type: 'alert',
        content: t(MSG.EXCEL_FORM_EMPTY, '_No data found for the search conditions.'),
      });
      return;
    }
    const exportRows = buildExcelFormRows(rows, formColumns);
    void GridAction.flatExcelDownload(
      exportRows,
      formColumns.map(c => ({ header: c.header, key: c.key })),
      TEMPLATE_EXCEL_PREFIX
    ).catch(() => {
      void setAlert({ type: 'alert', content: t(MSG.SAVE_ERROR, '_Excel download failed.') });
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
          {/* ⭐ 표준 SearchArea — Search 버튼 상단 (Div = 메인 화면 division 고정).
              searchWrapper = flex 축소 금지. 없으면 조회 후 그리드(flex:1)가 커지며 조회조건을
              0 높이로 눌러 덮어버린다 (2026-08-14 실사고). */}
          <div className={styles.searchWrapper}>
            <SearchArea
              searchButtonLabel={t('LBL00664', 'Search')}
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
                </>
              }
            />
          </div>
          {/* 조회 전 = 업로드 양식 미리보기(헤더만) / 조회 후 = 최종 업로드분 Daily 분배 미리보기 */}
          <div className={styles.gridWrapper}>
            <ResultArea title='' count={rows.length} gridRef={gridRef} gridFilterRef={gridFilterRef}>
              <DataGrid
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                isReadOnly
                staticColumns={gridColumns}
                itemsSource={rows}
              />
            </ResultArea>
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
