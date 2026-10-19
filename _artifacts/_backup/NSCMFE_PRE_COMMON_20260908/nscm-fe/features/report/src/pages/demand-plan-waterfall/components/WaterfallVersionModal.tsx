import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import { PeriodField } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, CustomDropdown, DataGrid, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField, ProgressIndicator } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid, Stack } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import {
  GUBUN,
  MENU_ID,
  SHEETS,
  VERSION_AXIS,
  type Gubun,
} from '../demand-plan-waterfall.constants';

import styles from './WaterfallVersionModal.module.scss';

// DMF0035 통합 Waterfall Version 선택 — DMF0082 VersionSelectModal 선례 1:1(공유 SP 9-arg 계약).
//   AS-IS 팝업 3종을 GUBUN 축으로 통합:
//   - MKT  : SCM0002_VersionByWaterfallPopup("MF_SF") — MF/SF 접두 + 'ME_S' 무조건 부가 (.cs L229 1:1)
//   - SALES: DMF0073_VersionBySalesPricePopup("SP")   — SP 접두 (2024-06-18 팝업 교체 실측)
//   - BIZ  : SCM0002_VersionByWaterfallPopup("BP")    — BP 접두, Month 기본 체크(monthChecked(true))
//   조회 SP = DMF0073_GET_VERSION_SALESPRICE (정확 토큰 IN 매칭 — FE 가 축→토큰 확장, DMF0082 선례).
//   AS-IS 대비 결손(문서화): 팝업 확정 시 sPeriod(조회기간 덮어쓰기)는 공유 계약에 버전 기준일
//   컬럼이 없어 미구현 — __asis-mapping__.md §Version 참조. 다중 선택 CSV 는 AS-IS 그대로(최대수 제한 없음).

type VersionPopupRow = {
  CODE: string;
  VERSION_NO: string;
  VERSION_DESCRIPTION: string;
  VERSION_TYPE: string;
  CREATED_BY: string;
  CREATION_DATE: string;
  [key: string]: string | number;
};

interface WaterfallVersionModalProps {
  open: boolean;
  modalClose: () => void;
  gubun: Gubun;
  defaultDivision: string;
  defaultPeriod?: { start: string; end: string };
  onApply: (versionIds: string) => void;
}

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

/**
 * 체크박스(Day/Week/Manual) → VERSION_TYPE 축 문자열.
 * SALES='SP_D,SP_W,SP_M'(DMF0073 정확 토큰) / MKT='MF_SF_*'·BIZ='BP_*'(SCM0002 축 — SP 내부 분기)
 */
const buildVersionType = (gubun: Gubun, day: boolean, week: boolean, manual: boolean): string =>
  [day ? 'D' : '', week ? 'W' : '', manual ? 'M' : '']
    .filter(Boolean)
    .map(suffix => `${VERSION_AXIS[gubun]}_${suffix}`)
    .join(',');

export const WaterfallVersionModal = ({
  open,
  modalClose,
  gubun,
  defaultDivision,
  defaultPeriod,
  onApply,
}: WaterfallVersionModalProps) => {
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

  const defaultFrom = defaultPeriod?.start || dayjs().subtract(3, 'month').format('YYYYMMDD');
  const defaultTo = defaultPeriod?.end || dayjs().add(3, 'month').format('YYYYMMDD');
  const [periodFrom, setPeriodFrom] = useState<string>(defaultFrom);
  const [periodTo, setPeriodTo] = useState<string>(defaultTo);
  const [divisionId, setDivisionId] = useState<string>(defaultDivision);
  const [description, setDescription] = useState<string>('');

  // Day/Week/Manual 기본값 — BIZ 는 Month(Manual)만(AS-IS monthChecked(true)), 그 외 Week (Designer 실측)
  const isBiz = gubun === GUBUN.BIZ_PLAN;
  const [chkDay, setChkDay] = useState<boolean>(false);
  const [chkWeek, setChkWeek] = useState<boolean>(!isBiz);
  const [chkManual, setChkManual] = useState<boolean>(isBiz);

  useEffect(() => {
    if (open) {
      setDivisionId(defaultDivision);
      setPeriodFrom(defaultFrom);
      setPeriodTo(defaultTo);
      setDescription('');
      setChkDay(false);
      setChkWeek(!isBiz);
      setChkManual(isBiz);
    }
  }, [open, defaultDivision, defaultFrom, defaultTo, isBiz]);

  const versionType = buildVersionType(gubun, chkDay, chkWeek, chkManual);
  const isSalesSheet = gubun === GUBUN.SALES_PLAN;

  // SALES = 'version'(DMF0073) / MKT·BIZ = 'versionWf'(SCM0002 — versionNo 가 설명 검색어)
  const salesFilters = useMemo(
    () =>
      open && isSalesSheet
        ? {
            startYyyymmdd: periodFrom,
            endYyyymmdd: periodTo,
            createdBy: '',
            divisionId,
            versionType,
            description,
          }
        : undefined,
    [open, isSalesSheet, divisionId, periodFrom, periodTo, versionType, description]
  );
  const wfFilters = useMemo(
    () =>
      open && !isSalesSheet
        ? {
            startYyyymmdd: periodFrom,
            endYyyymmdd: periodTo,
            createdBy: '',
            divisionId,
            versionType,
            versionNo: description,
          }
        : undefined,
    [open, isSalesSheet, divisionId, periodFrom, periodTo, versionType, description]
  );

  const salesQuery = useTabProcQuery<MENU_ID, SHEETS.VERSION>({
    menuId: MENU_ID,
    sheetName: SHEETS.VERSION,
    tabId: MENU_ID,
    filters: salesFilters,
    enabled: !!salesFilters,
  });
  const wfQuery = useTabProcQuery<MENU_ID, SHEETS.VERSION_WF>({
    menuId: MENU_ID,
    sheetName: SHEETS.VERSION_WF,
    tabId: MENU_ID,
    filters: wfFilters,
    enabled: !!wfFilters,
  });
  const active = isSalesSheet ? salesQuery : wfQuery;

  const rows = useMemo<VersionPopupRow[]>(
    () => (active.data?.o_rc1 ?? []) as VersionPopupRow[],
    [active.data]
  );
  const loading = active.isLoading || active.isFetching;

  const handleFind = () => {
    void active.refetch?.();
  };

  // waterfall 3화면 공통 — 다중 선택 CSV (AS-IS sVersions 그대로, 최대수 제한 없음)
  const handleApply = () => {
    const g = gridRef.current;
    if (!g) return;
    const selectedItems = (g.selectedItems as VersionPopupRow[]) ?? [];
    const versionNos = selectedItems.map(r => String(r.VERSION_NO ?? r.CODE ?? '')).filter(Boolean);
    if (versionNos.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00013', '_Please select Version.') });
      return;
    }
    onApply(versionNos.join(','));
    modalClose();
  };

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    g.isReadOnly = true;
    g.selectionMode = 2; // SelectionMode.ListBox — Ctrl/Shift 다중선택
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
          {/* AS-IS SCM0002_VersionByWaterfallPopup.Designer this.Text = "Version Popup" (MNU00179) */}
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
                    {/* LBL00852~854 신규 채번(2026-08-06) — LBL00774~776 은 SYS0017 점유(오라벨) */}
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
            <ProgressIndicator
              shape='circular'
              apprearance='infinite'
              open={loading}
              placement='parent'
            />
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
