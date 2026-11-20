import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { PeriodField } from 'features/master/src/components';
import { useEffect, useMemo, useRef } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { attachRowNoHeader } from '@foundation/utils';
import { CustomDialog, CustomDropdown, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { MENU_ID, MSG, SHEETS } from '../../metal-link-price.constants';

import styles from './MetalLinkVersionModal.module.scss';
import { useMetalLinkVersionModalStore } from './metalLinkVersionModalStore';

// AS-IS DMF0074_MetalLinkPrice.cs btnSPVer_Click (.cs L673~702):
//   popVersion.Form_Load(true, "SP", division, 오늘-3M, 오늘+3M) — DMF0073_VersionBySalesPricePopup.
//   반환 콤마연결 버전 — 3개+ = MSG00255 미반영 / 1~2개 = txtVersion 반영. 'Current' 수동 입력 유효.
//   SP = DMF0073_GET_VERSION_SALESPRICE (PROC_M 9행 공유 — DMF0020 version 시트와 동일 계약).
//   ⭐ versionType 'SP_W' 고정 — AS-IS 'SP' 는 카테고리(체크박스로 _W 등 선택)였으나 TO-BE SP 는
//     정확 토큰 매칭이라 'SP' 0행. DMF0020 검증 동작 1:1 (사용자 지시 2026-07-10)

interface VersionPopupRow {
  CODE?: string;
  VERSION_NO?: string;
  VERSION_DESCRIPTION?: string;
  VERSION_TYPE?: string;
  MONTHLY_ROLLING_FCST?: string;
  CREATED_BY?: string;
  CREATION_DATE?: string;
  EDIT_YN?: string;
}

interface MetalLinkVersionModalProps {
  open: boolean;
  modalClose: () => void;
  defaultDivision: string;
  // 메인 화면 조회조건 기간(YYYYMM). 팝업 open 시 from=해당월 1일 / to=해당월 말일로 변환해 Period 에 세팅.
  mainPeriodFrom?: string;
  mainPeriodTo?: string;
  onApply: (versionIds: string) => void;
}

// YYYYMM(6) → 해당 월 1일 YYYYMMDD(8). from 용.
const ymToFirstDay = (ym: string): string =>
  ym && ym.length >= 6 ? `${ym.slice(0, 6)}01` : '';
// YYYYMM(6) → 해당 월 말일 YYYYMMDD(8). to 용 (2/윤달 자동 처리).
const ymToLastDay = (ym: string): string =>
  ym && ym.length >= 6
    ? dayjs(`${ym.slice(0, 4)}-${ym.slice(4, 6)}-01`).endOf('month').format('YYYYMMDD')
    : '';

const VERSION_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'VERSION_NO', colLblNm: 'Version', colWth: 240 },
  { colNm: 'VERSION_DESCRIPTION', colLblNm: 'Details', colWth: 300 },
  { colNm: 'VERSION_TYPE', colLblNm: 'Type', colWth: 90 },
  { colNm: 'MONTHLY_ROLLING_FCST', colLblNm: 'Monthly Rolling Forecast', colWth: 170 },
  { colNm: 'CREATED_BY', colLblNm: 'Create By', colWth: 110 },
  { colNm: 'CREATION_DATE', colLblNm: 'Create Date', colWth: 150 },
].map(c => ({
  ...c,
  fixed: false,
  visible: true,
  display: true,
  inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
})) as RawFlexGridColumnConfig[];

export const MetalLinkVersionModal = ({
  open,
  modalClose,
  defaultDivision,
  mainPeriodFrom,
  mainPeriodTo,
  onApply,
}: MetalLinkVersionModalProps) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore(s => s.setAlert);
  const gridRef = useRef<FlexGridType<VersionPopupRow> | null>(null);
  // ResultArea 가 F4/헤더 필터 적용 후 실제 표시 건수를 "총 N건"에 반영하려면 이 ref 가 필요하다.
  const gridFilterRef = useRef<FlexGridFilter | undefined>();

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

  // Period 기본값 = 메인 화면 조회조건(fromYyyymm~toYyyymm)을 물려받는다 (사용자 지시 2026-09-16).
  //   from = 해당 월 1일 / to = 해당 월 말일 (YYYYMMDD). 메인 값이 없으면 AS-IS 기본(오늘±3M)으로 폴백.
  //   ('오늘±3M 고정 / 부모 날짜 폐기'였던 2026-08-10 규칙을 이 화면 한정으로 되돌림 — DMF0020 과는 이제 다름.)
  const { divisionId, periodFrom, periodTo, description } = useMetalLinkVersionModalStore(
    state => state.searchParams
  );
  const setSearchParams = useMetalLinkVersionModalStore(state => state.setSearchParams);
  const resetSearchParams = useMetalLinkVersionModalStore(state => state.resetSearchParams);

  // popup open 시 default value reset — 메인 조회조건 기간을 1일~말일로 변환해 물려준다.
  useEffect(() => {
    if (!open) return;
    const from = ymToFirstDay(mainPeriodFrom ?? '');
    const to = ymToLastDay(mainPeriodTo ?? '');
    resetSearchParams(defaultDivision, from && to ? { from, to } : undefined);
  }, [open, defaultDivision, mainPeriodFrom, mainPeriodTo, resetSearchParams]);

  // DMF0073_GET_VERSION_SALESPRICE (9-arg — sesUserId/mnuId BE 자동).
  // ⭐ versionType 'SP_W' 고정 (2026-07-10 실측 정정 — SP 필터는 VERSION_TYPE 정확 토큰 매칭
  //   (fn_string_split L89)이라 AS-IS 카테고리 'SP' 는 0행. 실데이터 = 'SP_W'.
  //   DMF0020 SalesPriceVersionModal 검증 동작 1:1 — 사용자 지시 2026-07-10)
  const filters = useMemo(
    () =>
      open
        ? {
            startYyyymmdd: periodFrom,
            endYyyymmdd: periodTo,
            createdBy: '',
            divisionId,
            versionType: 'SP_W',
            description,
          }
        : undefined,
    [open, divisionId, periodFrom, periodTo, description]
  );

  const { data, refetch, isLoading, isFetching } = useTabProcQuery<MENU_ID, SHEETS.VERSION>({
    menuId: MENU_ID,
    sheetName: SHEETS.VERSION,
    tabId: MENU_ID,
    filters,
    enabled: !!filters, // open 시 자동조회 (SalesPriceVersionModal 선례)
  });

  const rows = useMemo<VersionPopupRow[]>(() => (data?.o_rc1 ?? []) as VersionPopupRow[], [data]);
  const loading = isLoading || isFetching;

  const handleFind = () => {
    void refetch?.();
  };

  // AS-IS 반환 규칙 (.cs L688~700) — 3개+ = MSG00255 미반영 / 1~2개 반영
  const handleApply = () => {
    const g = gridRef.current;
    if (!g) return;
    const selectedItems = g.selectedItems as VersionPopupRow[];
    if (!selectedItems || selectedItems.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRE_VERSION, '_Please select Version.') });
      return;
    }
    if (selectedItems.length > 2) {
      void setAlert({
        type: 'alert',
        content: t(MSG.VERSION_MAX, '_You can select up to 2 versions.'),
      });
      return;
    }
    const versionNos = selectedItems.map(r => String(r.VERSION_NO ?? r.CODE ?? '')).filter(Boolean);
    if (versionNos.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRE_VERSION, '_Please select Version.') });
      return;
    }
    onApply(versionNos.join(','));
    modalClose();
  };

  // #70 — initialized deprecated → useEffect + gridRef. 읽기전용 + 다중선택 + 더블클릭 적용
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    g.isReadOnly = true;
    const onDbl = () => handleApply();
    g.hostElement?.addEventListener('dblclick', onDbl);
    return () => g.hostElement?.removeEventListener('dblclick', onDbl);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [rows]);

  useEffect(() => {
    if (gridRef.current) attachRowNoHeader(gridRef.current, t('LBL00674', 'No'));
  }, [gridRef, t, rows]);

  return (
    <CustomDialog
      open={open}
      size={1200}
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
          <h2 className='headerTitle'>{t('LBL00739', 'Sales Price Version')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContent}>
          <SearchArea
            searchButtonLabel={t('LBL00664', 'Search')}
            onSearch={handleFind}
            conditions={
              <>
                <Grid size={3}>
                  <FormItem
                    className={commonStyles.formItem}
                    label={t('LBL00001', 'Div.')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        disabled // 메인 화면 조회 division 고정 (AS-IS ctor division 1:1)
                        value={divisionId}
                        options={divisionOptions}
                        onChange={(_, option) => setSearchParams({ divisionId: String(option) })}
                      />
                    )}
                  />
                </Grid>
                <PeriodField
                  gridSize={4}
                  start={periodFrom}
                  end={periodTo}
                  onChange={(start, end) => setSearchParams({ periodFrom: start, periodTo: end })}
                />
                <Grid size={3}>
                  <FormItem
                    className={commonStyles.formItem}
                    label={t('LBL00608', 'Description')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={description}
                        onChange={e => setSearchParams({ description: e.target.value })}
                      />
                    )}
                  />
                </Grid>
              </>
            }
          />
          <div className={styles.gridWrapper}>
            <ProgressIndicator
              shape='circular'
              apprearance='infinite'
              open={loading}
              placement='parent'
            />
            <ResultArea title='' count={rows.length} gridRef={gridRef} gridFilterRef={gridFilterRef}>
              <DataGrid
                gridRef={gridRef as never}
                gridFilterRef={gridFilterRef}
                // prop 으로 줘야 한다 - 위 effect 의 g.isReadOnly 는 이미 늦다. DataGrid 는
                //   초기화 시점에 prop 을 보고 rowHeaders 에 CRUD 상태 컬럼을 넣을지 정하는데,
                //   그 컬럼이 생기면 코너(TopLeft)가 2칸이 되어 attachRowNoHeader 가 'No' 를
                //   두 번 찍는다.
                isReadOnly
                itemsSource={rows as unknown as WijmoRowItem[]}
                staticColumns={VERSION_COLUMNS}
                autoGenerateColumns={false}
                className={styles.grid}
              />
            </ResultArea>
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='contained'
              priority='primary'
              size='medium'
              buttonLabel='OK'
              iconComponent={<ControlConfirmIcon size='small' />}
              iconPosition='leading'
              disabled={loading}
              onClick={handleApply}
            />
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
