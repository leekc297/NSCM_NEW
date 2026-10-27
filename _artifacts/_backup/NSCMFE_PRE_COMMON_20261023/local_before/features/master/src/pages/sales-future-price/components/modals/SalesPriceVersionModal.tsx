import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { attachRowNoHeader } from '@foundation/utils';
import { CustomDialog, CustomDropdown, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { PeriodField } from '../../../../components';
import { MENU_ID, SHEETS } from '../../sales-future-price.constants';

import styles from './SalesPriceVersionModal.module.scss';
import { useSalesPriceVersionModalStore } from './salesPriceVersionModalStore';

// AS-IS DMF0020_SalesFuturePrice.cs btnSPVer_Click (.cs L3895~)
//   DMF0073_VersionBySalesPricePopup popVersion = new DMF0073_VersionBySalesPricePopup();
//   popVersion.Form_Load(true, "SP", sDivision, sStartDate, sEndDate);
//   popVersion.ShowDialog();
//
// AS-IS DMF0073_VersionBySalesPricePopup.cs (Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Master.UIL/POPUP/):
//   - SP : DMF0073_GET_VERSION_SALESPRICE
//   - Validation: MSG00255 (선택 > 2개 — Sales Price 최대 2개)
//
// ⭐ 2026-07-02 UI 보완 (사용자 요구):
//   - Design 표준 적용 — 형제 PriceBatchInputModal 동일 (SearchArea + FormItem/CustomDropdown + PeriodField)
//   - Div 라벨 = LBL00001 'Div.' + 수정 불가(disabled — 메인 화면 division 고정)
//   - Day/Week/Manual 체크박스 삭제 → versionType 'SP_W' 고정 (Sales Price Week)
//   - 상태바("N행 조회됨…" 설명란) 삭제
//   - Grid 컬럼 = Version / Details / Type / Monthly Rolling Forecast / Create By / Create Date 만 순서대로

// SP body 결과 SELECT 절 실제 컬럼:
//   CODE / VERSION_NO / VERSION_DESCRIPTION / VERSION_TYPE / EDI_APPLY / VER_CRE_SEQ /
//   YYYYMMDD / CREATED_BY / CREATION_DATE / MONTHLY_ROLLING_FCST / EDITABLE / EDIT_YN
interface VersionPopupRow {
  CODE?: string;
  VERSION_NO?: string;
  VERSION_DESCRIPTION?: string;
  VERSION_TYPE?: string;
  EDI_APPLY?: string;
  VER_CRE_SEQ?: number | string;
  YYYYMMDD?: string;
  CREATED_BY?: string;
  CREATION_DATE?: string;
  MONTHLY_ROLLING_FCST?: string;
  EDITABLE?: string;
  EDIT_YN?: string;
}

interface Props {
  open: boolean;
  modalClose: () => void;
  defaultDivision: string;
  onApply: (versionIds: string) => void;
}

const DIVISION_FALLBACK: Array<{ value: string; label: string }> = [
  { value: '40', label: '40 (Mobility & IT Battery)' },
  { value: '81', label: '81 (ESS Battery)' },
  { value: '82', label: '82 (Power Tool)' },
];

// 사용자 요구 — 이 6 컬럼만 순서대로 표기 (YYYYMMDD/EDITABLE 등 비표기).
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

export const SalesPriceVersionModal = ({ open, modalClose, defaultDivision, onApply }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore(s => s.setAlert);
  const gridRef = useRef<FlexGridType<VersionPopupRow> | null>(null);
  // ResultArea 가 F4/헤더 필터 적용 후 실제 표시 건수를 "총 N건"에 반영하려면 이 ref 가 필요하다.
  const gridFilterRef = useRef<FlexGridFilter | undefined>();

  // 사용자 권한 기반 Division lookup (자매 화면 ContributeVersionModal 패턴)
  const [myDivisions] = useTabComboQueries({ filters: ['MyDivision'] });
  const divisionOptions = useMemo<Array<{ value: string; label: string }>>(() => {
    const arr = (myDivisions ?? []) as Array<{ CODE?: string; NAME?: string }>;
    if (arr.length === 0) return DIVISION_FALLBACK;
    return arr.map(r => {
      const code = String(r.CODE ?? '');
      const name = String(r.NAME ?? code);
      const label = code === name || name === '' ? code : `${code} (${name})`;
      return { value: code, label };
    });
  }, [myDivisions]);

  // AS-IS Period (-3M ~ +3M) — 표준 PeriodField (YYYYMMDD string)
  // ⭐ Division = 메인 화면 조회 division 고정 — 수정 불가 (사용자 요구 2026-07-02)
  const { divisionId, periodFrom, periodTo, description } = useSalesPriceVersionModalStore(
    state => state.searchParams
  );
  const setSearchParams = useSalesPriceVersionModalStore(state => state.setSearchParams);
  const resetSearchParams = useSalesPriceVersionModalStore(state => state.resetSearchParams);

  // popup open 시 default value reset
  useEffect(() => {
    if (open) resetSearchParams(defaultDivision);
  }, [open, defaultDivision, resetSearchParams]);

  // SP filter — DB SP signature 정확 매핑 (DMF0073_GET_VERSION_SALESPRICE 9 인자):
  //   P_START_YYYYMMDD / P_END_YYYYMMDD / P_CREATED_BY / P_DIVISION_ID
  //   P_VERSION_TYPE / P_DESCRIPTION / P_USER_ID / P_MENU_ID / O_RC1
  //   (sesUserId / mnuId 는 BE 자동 채움)
  // ⭐ 체크박스 삭제 → versionType 'SP_W' 고정 (Sales Price Week — SP default 동일)
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

  // useTabProcQuery — enabled 가드 + isLoading 노출
  // ⭐ 자동조회 (2026-07-07 사용자 요구): enabled=!!filters (filters 는 open 시에만 정의) →
  //   modal open 시 react-query 가 자동 fetch. Find 버튼은 재조회용 유지.
  const { data, refetch, isLoading, isFetching } = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: SHEETS.VERSION,
    tabId: MENU_ID,
    filters,
    enabled: !!filters, // open 시 자동조회 (filters=open?{...}:undefined)
  });

  const rows = useMemo<VersionPopupRow[]>(() => (data?.o_rc1 ?? []) as VersionPopupRow[], [data]);

  const loading = isLoading || isFetching;

  const handleFind = () => {
    void refetch?.();
  };

  // 선택 — DMF0043_01 ContributeVersionModal 패턴 (selectedItems 직접 사용)
  //   single row click 으로 grid 자체 선택 → Apply 클릭 시 selectedItems 사용
  //   selectionMode='ListBox' (2) — multiple selection 가능 (Ctrl/Shift)
  //   AS-IS MSG00255: Sales Price Version 최대 2개
  const handleApply = () => {
    const g = gridRef.current;
    if (!g) {
      void setAlert({ type: 'alert', content: t('MSG00284', '_Grid 가 준비되지 않았습니다.') });
      return;
    }
    const selectedItems = g.selectedItems as VersionPopupRow[];
    if (!selectedItems || selectedItems.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00113', '_Version 을 선택해 주세요.') });
      return;
    }
    if (selectedItems.length > 2) {
      void setAlert({
        type: 'alert',
        content: t('MSG00255', '_Sales Price Version 은 최대 2개까지 선택할 수 있습니다.'),
      });
      return;
    }
    const versionNos = selectedItems.map(r => String(r.VERSION_NO ?? r.CODE ?? '')).filter(Boolean);
    if (versionNos.length === 0) {
      void setAlert({
        type: 'alert',
        content: t('MSG00113', '_유효한 Version 이 선택되지 않았습니다.'),
      });
      return;
    }
    onApply(versionNos.join(','));
    modalClose();
  };

  // ⭐ #70 — DataGrid `initialized` prop deprecated → useEffect + gridRef. isReadOnly/다중선택/더블클릭 적용.
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
      disableButtonCancel
      // 컬럼 필터 팝업(FlexGridFilter)이 MuiDialog-container 밖에 append 돼 MUI FocusTrap 과
      // 충돌한다 — 필터 팝업의 Search 입력이 클릭/타이핑해도 반응 없어 보이는 원인. CustomDialog.tsx
      // 상단 주석(DMF0082 ExchangeRateModal) 과 동일 원인.
      disableEnforceFocus
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t('LBL00739', 'Sales Price Version')}</h2>
        </div>
      }
      customContentArea={
        <div className={styles.dialogContent}>
          {/* 조회 조건 — 표준 SearchArea (Div disabled + Period + Description) */}
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
                        disabled
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

          {/* Grid — Version / Details / Type / Monthly Rolling Forecast / Create By / Create Date */}
          <div className={styles.gridWrapper}>
            <ProgressIndicator
              shape='circular'
              apprearance='infinite'
              open={loading}
              placement='parent'
            />
            <ResultArea
              title=''
              count={rows.length}
              gridRef={gridRef as never}
              gridFilterRef={gridFilterRef}
            >
              <DataGrid
                gridRef={gridRef as never}
                gridFilterRef={gridFilterRef}
                isReadOnly
                itemsSource={rows as unknown as WijmoRowItem[]}
                staticColumns={VERSION_COLUMNS}
                autoGenerateColumns={false}
                className={styles.grid}
              />
            </ResultArea>
          </div>

          {/* Action — 표준 buttonWrapper (하단 우측 정렬, @shared/lges Button) */}
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
