import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import { PeriodField } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, CustomDropdown, DataGrid, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid, Stack } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { MENU_ID, MSG, SHEETS, VERSION_AXIS, VERSION_MAX_SELECT } from '../mkt-fcst-comparison.constants';

import styles from './ComparisonVersionModal.module.scss';

// DMF0040 Version 선택 — AS-IS DMF0000_VersionByWaterfallPopup (368행 전량 분석, 4영역 md §E) 1:1.
//   DMF0035 WaterfallVersionModal(features/report — feature 간 직접 import 금지라 이식) 동형 + DMF0040 고유 2축:
//   ① 선택 최대 2 (MSG00255 — AS-IS SetItem iCnt>2 차단·선택 초기화. DMF0035 판은 제한 없음)
//   ② OK 시 모달의 조회기간을 부모 Period 에 반영 (AS-IS sPeriod = drpPeriod.ControlValues → 부모 drpPeriod.InitValue)
//   버전 축 = 'MF' 고정 (AS-IS 부모 Form_Load(true, "MF", ...) — chkDay/Week/Month → MF_D/MF_W/MF_M).

type VersionPopupRow = {
  CODE: string;
  VERSION_NO: string;
  VERSION_DESCRIPTION: string;
  VERSION_TYPE: string;
  CREATED_BY: string;
  CREATION_DATE: string;
  [key: string]: string | number;
};

interface ComparisonVersionModalProps {
  open: boolean;
  modalClose: () => void;
  defaultDivision: string;
  defaultPeriod?: { start: string; end: string };
  onApply: (versionIds: string, period: { start: string; end: string }) => void;
}

// AS-IS 팝업 그리드 표시 5컬럼 (InitSpread_X — Division/Seq/Date 는 숨김)
const VERSION_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'VERSION_NO', colLblNm: 'Version', colWth: 240 },
  { colNm: 'VERSION_DESCRIPTION', colLblNm: 'Description', colWth: 300 },
  { colNm: 'VERSION_TYPE', colLblNm: 'Type', colWth: 90 },
  { colNm: 'CREATED_BY', colLblNm: 'Create By', colWth: 110 },
  { colNm: 'CREATION_DATE', colLblNm: 'Create Date', colWth: 150 },
].map(c => ({
  ...c,
  fixed: false,
  visible: true,
  display: true,
  inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
})) as RawFlexGridColumnConfig[];

/** 체크박스(Day/Week/Manual) → 'MF_D,MF_W,MF_M' 조합 (AS-IS 팝업 FindData p_version_type 조립 1:1) */
const buildVersionType = (day: boolean, week: boolean, manual: boolean): string =>
  [day ? 'D' : '', week ? 'W' : '', manual ? 'M' : '']
    .filter(Boolean)
    .map(suffix => `${VERSION_AXIS}_${suffix}`)
    .join(',');

export const ComparisonVersionModal = ({
  open,
  modalClose,
  defaultDivision,
  defaultPeriod,
  onApply,
}: ComparisonVersionModalProps) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore(s => s.setAlert);
  const gridRef = useRef<FlexGridType<VersionPopupRow>>(undefined);

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

  const defaultFrom = defaultPeriod?.start || dayjs().startOf('month').format('YYYYMMDD');
  const defaultTo = defaultPeriod?.end || dayjs().add(6, 'month').endOf('month').format('YYYYMMDD');
  const [periodFrom, setPeriodFrom] = useState<string>(defaultFrom);
  const [periodTo, setPeriodTo] = useState<string>(defaultTo);
  const [divisionId, setDivisionId] = useState<string>(defaultDivision);
  const [description, setDescription] = useState<string>('');
  // 기본 = Week 만 (AS-IS 부모 기본 버전이 MF_W 계열 — GetDefaultVersion)
  const [chkDay, setChkDay] = useState<boolean>(false);
  const [chkWeek, setChkWeek] = useState<boolean>(true);
  const [chkManual, setChkManual] = useState<boolean>(false);

  useEffect(() => {
    if (open) {
      setDivisionId(defaultDivision);
      setPeriodFrom(defaultFrom);
      setPeriodTo(defaultTo);
      setDescription('');
      setChkDay(false);
      setChkWeek(true);
      setChkManual(false);
    }
  }, [open, defaultDivision, defaultFrom, defaultTo]);

  const versionType = buildVersionType(chkDay, chkWeek, chkManual);

  const filters = useMemo(
    () =>
      open
        ? {
            startYyyymmdd: periodFrom,
            endYyyymmdd: periodTo,
            createdBy: '',
            divisionId,
            versionType,
            versionNo: description,
          }
        : undefined,
    [open, divisionId, periodFrom, periodTo, versionType, description]
  );

  const query = useTabProcQuery<MENU_ID, SHEETS.VERSION>({
    menuId: MENU_ID,
    sheetName: SHEETS.VERSION,
    tabId: MENU_ID,
    filters,
    enabled: !!filters,
  });

  const rows = useMemo<VersionPopupRow[]>(
    () => (query.data?.o_rc1 ?? []) as VersionPopupRow[],
    [query.data]
  );
  const loading = query.isLoading || query.isFetching;

  const handleFind = () => {
    void query.refetch?.();
  };

  // OK — 최대 2 (MSG00255, AS-IS SetItem iCnt>2 = 차단·선택 유지 재시도) + 기간 반영 (AS-IS sPeriod)
  const handleApply = () => {
    const g = gridRef.current;
    if (!g) return;
    const selectedItems = (g.selectedItems as VersionPopupRow[]) ?? [];
    const versionNos = selectedItems.map(r => String(r.VERSION_NO ?? r.CODE ?? '')).filter(Boolean);
    if (versionNos.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00283', '_Please select Version.') });
      return;
    }
    if (versionNos.length > VERSION_MAX_SELECT) {
      void setAlert({
        type: 'alert',
        content: t(MSG.VERSION_MAX, '_You can select up to 2 versions.'),
      });
      return;
    }
    onApply(versionNos.join(','), { start: periodFrom, end: periodTo });
    modalClose();
  };

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    g.isReadOnly = true;
    g.selectionMode = 2; // SelectionMode.ListBox — Ctrl/Shift 다중선택 (최대 2 는 OK 시 검증)
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
          {/* AS-IS DMF0000_VersionByWaterfallPopup this.Text = "Version Popup" (MNU00179 재사용) */}
          <h2 className='headerTitle'>{t('MNU00179', 'Version Popup')}</h2>
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
                      // AS-IS 팝업은 division 다중 체크(부모값 초기) — TO-BE 는 부모 division 고정 표시
                      <CustomDropdown
                        disabled
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
                <Grid size={2} sx={{ display: 'flex', alignItems: 'center' }}>
                  <Stack direction='row' spacing={1} alignItems='center' sx={{ width: '100%' }}>
                    {/* chkDay/chkWeek/chkMonth (AS-IS Designer) — LBL00852~854 (DMF0035 채번 재사용) */}
                    <Checkbox
                      labelText={t('LBL00852', '_Day')}
                      checked={chkDay}
                      onChange={(checked: boolean) => setChkDay(checked)}
                    />
                    <Checkbox
                      labelText={t('LBL00853', '_Week')}
                      checked={chkWeek}
                      onChange={(checked: boolean) => setChkWeek(checked)}
                    />
                    <Checkbox
                      labelText={t('LBL00854', '_Manual')}
                      checked={chkManual}
                      onChange={(checked: boolean) => setChkManual(checked)}
                    />
                  </Stack>
                </Grid>
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
            <DataGrid<VersionPopupRow>
              gridRef={gridRef}
              itemsSource={rows}
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
