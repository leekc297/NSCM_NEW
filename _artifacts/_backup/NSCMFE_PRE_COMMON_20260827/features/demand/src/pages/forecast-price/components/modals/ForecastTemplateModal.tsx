import { useEffect, useMemo, useState } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { GridAction } from '@foundation/utils';
import { CustomDialog, CustomDropdown, DataGrid, SearchArea } from '@shared/components';
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
//   [Excel Download] 정적 메타 컬럼 + M4~M16(빈칸) 평탄 헤더.
//   ⚠ 토큰 10개와 'M4'~'M16' 은 **원형 유지 의무** — BE cvtListUploadRows 가 HEADER_CONTENT 문자열
//   일치로 컬럼을 찾는다. 정보성 컬럼은 HEADER_CONTENT 에 없어 업로드 시 무시된다(자유 추가 가능).
//   그리드/미리보기 라벨에만 실월(당월+4~+16) 병기.
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

/** [E20260820-XLSWEEKLY] 주 시작일 헤더(YYYYMMDD) → 미리보기 라벨 'YYYY-MM-DD' */
const weekLabel = (token: string): string =>
  /^\d{8}$/.test(token) ? `${token.slice(0, 4)}-${token.slice(4, 6)}-${token.slice(6)}` : token;

export const ForecastTemplateModal = ({
  open,
  modalClose,
  divisionId,
  filters,
}: ForecastTemplateModalProps) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

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
  // [E20260820-XLSWEEKLY] SP WEEK_LIST — 기간(주차) 동적 컬럼의 단일 원천
  const [weekList, setWeekList] = useState<string[]>([]);
  const [isFetching, setIsFetching] = useState(false);
  useEffect(() => {
    if (!open) {
      setRows([]);
      setIsFetching(false);
    }
  }, [open]);

  // ⭐ 양식 컬럼 = 단가 테이블 축 고정(토큰 10) + Project/Owner 정보성 + 동적 주차 [E20260825-XLSPRICECOL]
  //   토큰 헤더는 HEADER_CONTENT 원형 문자열(BE 이름 매핑). 정보성 컬럼은 업로드 시 무시된다.
  //   [E20260825-XLSPRJ] 전 행이 빈 정보성 컬럼은 숨김(토큰·주차 보존) — 그리드·다운로드 동일 목록.
  const formColumns = useMemo(
    () => pruneEmptyInfoColumns(buildExcelFormColumns(weekList), rows),
    [weekList, rows]
  );

  // 미리보기 그리드 = 다운로드 결과와 1:1 (조회 전/후 컬럼이 갈리지 않는다)
  const gridColumns = useMemo<RawFlexGridColumnConfig[]>(
    () => toPreviewColumns(formColumns, weekLabel),
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
    void fetchExcelFormData(filters ?? buildFallbackFilters())
      .then(({ ok, message, pivot, weekList: wks }) => {
        setRows(ok ? pivot : []);
        setWeekList(ok ? wks : []);
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

  // ⭐ 양식 다운로드 — 평탄 1행 헤더(토큰 원형) + 정보성 컬럼. M4~M16 은 입력용 빈칸.
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
              searchButtonLabel={
                isFetching ? t('LBL00665', 'Loading...') : t('LBL00112', '_Search')
              }
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
