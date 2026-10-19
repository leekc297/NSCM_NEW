import { type FlexGrid as TFlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useMemo, useRef, useState } from 'react';

import { CELL_CONTROL_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, DataGrid, ResultArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Button, Checkbox, DatePickerCalendar, FormItem, InputField } from '@shared/lges';
import { Grid, Stack } from '@shared/mui';

import { LBL, MENU_ID, SHEETS, VERSION_TYPE_LABELS } from '../../capa.constants';

interface Props {
  open: boolean;
  tabId: string;
  onClose: () => void;
}

type InfoRow = WijmoRowItem;
type SearchFilters = ProcRequest<MENU_ID, SHEETS.NEW_VERSION>;

/** Version Info 그리드 10컬럼(Roslyn siMain 실측). BP/RP/SCP = 체크 컬럼, 전체 read-only(LockColumn). */
const INFO_COLUMNS: RawFlexGridColumnConfig[] = [
  { colNm: 'VERSION_ID', colLblNm: 'Version Id', horzAlgnCd: 'C', colWth: 90, visible: true },
  { colNm: 'DIVISION_ID', colLblNm: 'Div', horzAlgnCd: 'C', colWth: 60, visible: true },
  { colNm: 'VERSION_WEEK', colLblNm: 'Week', horzAlgnCd: 'C', colWth: 60, visible: true },
  { colNm: 'VERSION_DATE', colLblNm: 'Date', horzAlgnCd: 'C', colWth: 90, visible: true },
  { colNm: 'VERSION_TIME', colLblNm: 'Time', horzAlgnCd: 'C', colWth: 70, visible: true },
  { colNm: 'VERSION_NAME', colLblNm: 'Version Name', horzAlgnCd: 'L', colWth: 150, visible: true },
  {
    colNm: 'BP_USE_FLAG',
    colLblNm: 'BP',
    horzAlgnCd: 'C',
    colWth: 40,
    cellCtrlObjTpCd: CELL_CONTROL_TYPE.CHECKBOX,
    visible: true,
  },
  {
    colNm: 'RP_USE_FLAG',
    colLblNm: 'RP',
    horzAlgnCd: 'C',
    colWth: 40,
    cellCtrlObjTpCd: CELL_CONTROL_TYPE.CHECKBOX,
    visible: true,
  },
  {
    colNm: 'SCP_USE_FLAG',
    colLblNm: 'SCP',
    horzAlgnCd: 'C',
    colWth: 40,
    cellCtrlObjTpCd: CELL_CONTROL_TYPE.CHECKBOX,
    visible: true,
  },
  { colNm: 'CONFIRMED_BY', colLblNm: 'Confirmed By', horzAlgnCd: 'L', colWth: 270, visible: true },
];

/**
 * SCP0049 Version Info 팝업(01 R9 §3.2-8 · Roslyn SCP0049_CAPANewVersionInfoPopup).
 * 자체 검색폼(Period from/to · Version Name · BP/RP/SCP) → FindData → newVersion SEARCH
 *   (P_GET_NEW_VERSION_INFO, PROC_M COL_NM 실측: fromDate/toDate/versionName/chkBp/chkRp/chkScp).
 * AS-IS 는 LoadData(userId) 로 팝업만 열고 검색폼이 조회하는 구조 — 이전 iter 의 {userId} 전송은
 *   SP 계약 불일치(NEW-01)라 검색폼 기반으로 재정합. 그리드 전체 read-only(LockColumn 등가).
 */
export const VersionInfoModal = ({ open, tabId, onClose }: Props) => {
  const { t } = useTranslation();
  const gridRef = useRef<TFlexGrid<InfoRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const [fromDate, setFromDate] = useState(() => dayjs().subtract(1, 'month'));
  const [toDate, setToDate] = useState(() => dayjs());
  const [versionName, setVersionName] = useState('');
  const [chkBp, setChkBp] = useState(false);
  const [chkRp, setChkRp] = useState(false);
  const [chkScp, setChkScp] = useState(false);
  const [filters, setFilters] = useState<SearchFilters | undefined>(undefined);

  const yn = (b: boolean): string => (b ? 'Y' : 'N');
  const handleSearch = (): void => {
    setFilters({
      fromDate: fromDate.format('YYYYMMDD'),
      toDate: toDate.format('YYYYMMDD'),
      versionName: versionName.trim(),
      chkBp: yn(chkBp),
      chkRp: yn(chkRp),
      chkScp: yn(chkScp),
    });
  };

  const { data } = useTabProcQuery<MENU_ID, SHEETS.NEW_VERSION>({
    menuId: MENU_ID,
    sheetName: SHEETS.NEW_VERSION,
    tabId,
    filters: open ? filters : undefined,
    enabled: open && filters !== undefined,
  });
  const rows = useMemo<InfoRow[]>(
    () => ((data as { o_rc?: InfoRow[] } | undefined)?.o_rc ?? []),
    [data]
  );

  return (
    <CustomDialog
      open={open}
      size={930}
      type='modal'
      position='basic'
      handleClose={onClose}
      disableButtonCancel
      customHeaderTitle={
        <div className='headerContainer'>
          <div className='headerDot' />
          <h2 className='headerTitle'>{t(LBL.VERSION_INFO, 'Version Info')}</h2>
        </div>
      }
      customContentArea={
        <>
          <Grid container spacing={1} alignItems='center'>
            <Grid size={4}>
              <FormItem
                label={t(LBL.PERIOD, 'Period')}
                labelAlign='right'
                render={() => (
                  <Stack direction='row' spacing={1} alignItems='center'>
                    <DatePickerCalendar
                      usecase='date'
                      size='small'
                      elevation
                      value={fromDate}
                      onChange={((date: ReturnType<typeof dayjs>) => {
                        if (date) setFromDate(date);
                      }) as never}
                    />
                    <span>~</span>
                    <DatePickerCalendar
                      usecase='date'
                      size='small'
                      elevation
                      value={toDate}
                      onChange={((date: ReturnType<typeof dayjs>) => {
                        if (date) setToDate(date);
                      }) as never}
                    />
                  </Stack>
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                label={t(LBL.NAME, 'Name')}
                labelAlign='right'
                render={() => (
                  <InputField
                    fullWidth
                    value={versionName}
                    onChange={e => setVersionName(e.target.value)}
                    onKeyDown={e => {
                      if (e.key === 'Enter') handleSearch();
                    }}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <Stack direction='row' spacing={1} alignItems='center'>
                <Checkbox
                  labelText={VERSION_TYPE_LABELS.bp}
                  checked={chkBp}
                  onChange={checked => setChkBp(checked)}
                />
                <Checkbox
                  labelText={VERSION_TYPE_LABELS.rp}
                  checked={chkRp}
                  onChange={checked => setChkRp(checked)}
                />
                <Checkbox
                  labelText={VERSION_TYPE_LABELS.scp}
                  checked={chkScp}
                  onChange={checked => setChkScp(checked)}
                />
              </Stack>
            </Grid>
            <Grid size={2}>
              <Button onClick={handleSearch}>{t(LBL.SEARCH, 'Search')}</Button>
            </Grid>
          </Grid>
          <ResultArea count={rows.length} gridRef={gridRef} gridFilterRef={gridFilterRef}>
            <DataGrid<InfoRow>
              gridRef={gridRef}
              gridFilterRef={gridFilterRef}
              itemsSource={rows}
              staticColumns={INFO_COLUMNS}
            />
          </ResultArea>
        </>
      }
    />
  );
};
