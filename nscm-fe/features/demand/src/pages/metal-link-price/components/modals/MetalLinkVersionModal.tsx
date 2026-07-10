import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import { PeriodField } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, CustomDropdown, DataGrid, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { MENU_ID, MSG, SHEETS } from '../../metal-link-price.constants';

import styles from './MetalLinkVersionModal.module.scss';

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
  onApply: (versionIds: string) => void;
}

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
  onApply,
}: MetalLinkVersionModalProps) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore(s => s.setAlert);
  const gridRef = useRef<FlexGridType<VersionPopupRow> | null>(null);

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

  // AS-IS Period — 오늘 ±3개월 (.cs L676 MultiTimeZone)
  const [periodFrom, setPeriodFrom] = useState<string>(() =>
    dayjs().subtract(3, 'month').format('YYYYMMDD')
  );
  const [periodTo, setPeriodTo] = useState<string>(() => dayjs().add(3, 'month').format('YYYYMMDD'));
  const [divisionId, setDivisionId] = useState<string>(defaultDivision);
  const [description, setDescription] = useState<string>('');

  useEffect(() => {
    if (open) {
      setDivisionId(defaultDivision);
      setPeriodFrom(dayjs().subtract(3, 'month').format('YYYYMMDD'));
      setPeriodTo(dayjs().add(3, 'month').format('YYYYMMDD'));
      setDescription('');
    }
  }, [open, defaultDivision]);

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
    g.selectionMode = 2; // SelectionMode.ListBox — Ctrl/Shift 다중선택 (최대 2 는 Apply 가드)
    const onDbl = () => handleApply();
    g.hostElement?.addEventListener('dblclick', onDbl);
    return () => g.hostElement?.removeEventListener('dblclick', onDbl);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [rows]);

  return (
    <CustomDialog
      open={open}
      size={1200}
      type='modal'
      position='basic'
      handleClose={modalClose}
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
            searchButtonLabel={loading ? t('LBL00665', 'Loading...') : t('LBL00664', 'Search')}
            onSearch={handleFind}
            conditions={
              <>
                <Grid size={3}>
                  <FormItem
                    label={t('LBL00001', 'Div.')}
                    labelAlign='right'
                    render={() => (
                      <CustomDropdown
                        disabled // 메인 화면 조회 division 고정 (AS-IS ctor division 1:1)
                        value={divisionId}
                        options={divisionOptions}
                        onChange={(_, option) => setDivisionId(String(option))}
                      />
                    )}
                  />
                </Grid>
                <PeriodField
                  gridSize={4}
                  start={periodFrom}
                  end={periodTo}
                  onChange={(start, end) => {
                    setPeriodFrom(start);
                    setPeriodTo(end);
                  }}
                />
                <Grid size={3}>
                  <FormItem
                    label={t('LBL00608', 'Description')}
                    labelAlign='right'
                    render={() => (
                      <InputField
                        fullWidth
                        value={description}
                        onChange={e => setDescription(e.target.value)}
                      />
                    )}
                  />
                </Grid>
              </>
            }
          />
          <div className={styles.gridWrapper}>
            <DataGrid
              gridRef={gridRef as never}
              itemsSource={rows as unknown as WijmoRowItem[]}
              staticColumns={VERSION_COLUMNS}
              autoGenerateColumns={false}
              className={styles.grid}
            />
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('LBL00627', 'Close')}
              onClick={modalClose}
            />
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
          </div>
        </div>
      }
    />
  );
};
