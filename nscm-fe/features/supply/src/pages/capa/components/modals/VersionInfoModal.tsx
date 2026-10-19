import { type FlexGrid as TFlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { PeriodField } from 'features/master/src/components';
import { useMemo, useRef, useState } from 'react';

import { CELL_CONTROL_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDialog, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { Checkbox, FormItem, InputField } from '@shared/lges';
import { Grid, Stack } from '@shared/mui';

import { LBL, MENU_ID, SHEETS, VERSION_NAME_LABEL, VERSION_TYPE_LABELS } from '../../capa.constants';

interface Props {
  open: boolean;
  tabId: string;
  onClose: () => void;
}

type InfoRow = WijmoRowItem;
type SearchFilters = ProcRequest<MENU_ID, SHEETS.NEW_VERSION>;

/** Version Info 그리드 10컬럼(Roslyn siMain 실측). BP/RP/SCP = 체크 컬럼, 전체 read-only(LockColumn). */
const INFO_COLUMN_DEFS: RawFlexGridColumnConfig[] = [
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
  { colNm: 'CONFIRMED_BY', colLblNm: 'Confirmed By', horzAlgnCd: 'L', colWth: 535, visible: true },
];

// DataGrid 는 display 가 true 인 컬럼만 그린다(없으면 컬럼 0개 — 행 번호 열만 보인다).
const INFO_COLUMNS: RawFlexGridColumnConfig[] = INFO_COLUMN_DEFS.map(column => ({ ...column, display: true }));

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

  // PeriodField 규약 = YYYYMMDD 문자열(조회 파라미터 형식과 같다).
  const [fromDate, setFromDate] = useState(() => dayjs().subtract(7, 'day').format('YYYYMMDD'));
  const [toDate, setToDate] = useState(() => dayjs().format('YYYYMMDD'));
  const [versionName, setVersionName] = useState('');
  const [chkBp, setChkBp] = useState(false);
  const [chkRp, setChkRp] = useState(false);
  const [chkScp, setChkScp] = useState(false);
  const [filters, setFilters] = useState<SearchFilters | undefined>(undefined);

  // 해제는 빈 값이어야 한다. SP 가 BP/RP/SCP 셋 다 NULL 일 때만 "전체 조회"로 보고, 'N' 이 오면 필터가 어긋난다.
  const yn = (b: boolean): string => (b ? 'Y' : '');
  const handleSearch = (): void => {
    setFilters({
      fromDate,
      toDate,
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
  // SP 가 BP/RP/SCP 를 'True'/'False' 문자열로 준다. 그대로 두면 Boolean 체크 컬럼이 'False' 도 체크로 그린다.
  const rows = useMemo<InfoRow[]>(
    () =>
      ((data as { o_rc?: InfoRow[] } | undefined)?.o_rc ?? []).map(row => ({
        ...row,
        BP_USE_FLAG: row.BP_USE_FLAG === 'True',
        RP_USE_FLAG: row.RP_USE_FLAG === 'True',
        SCP_USE_FLAG: row.SCP_USE_FLAG === 'True',
      })),
    [data]
  );

  return (
    <CustomDialog
      open={open}
      // CustomDialog 는 size 를 1.5배(DIALOG_SCALE)로 그린다. 조회조건을 AS-IS 처럼 한 줄에 두려면 실폭 약 1280px 이
      //   필요하다(Period 5칸 + Version Name 4칸 + 체크박스 3칸 + Search 버튼) → 850. 그리드 폭은 Confirmed By 로 맞춘다.
      //   AS-IS 는 930x500(SCP0049_CAPA.cs:2510-2511), 높이는 행이 적어 400 으로 줄였다.
      size={850}
      height={400}
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
          {/* 다른 modal(MaterialByDivisionModal 등)과 같은 공용 SearchArea — Search 버튼은 우측, F5·Enter 조회 연결. */}
          <SearchArea searchButtonLabel={t(LBL.SEARCH, 'Search')} onSearch={handleSearch} conditions={
            <>
              <PeriodField
                gridSize={5}
                label={t(LBL.PERIOD, 'Period')}
                start={fromDate}
                end={toDate}
                onChange={(start, end) => {
                  setFromDate(start);
                  setToDate(end);
                }}
              />
              <Grid size={4}>
                <FormItem
                  className={commonStyles.formItem}
                  label={VERSION_NAME_LABEL}
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
              <Grid size={3} className={commonStyles.customGrid}>
                <div className={commonStyles.customCheckbox}>
                  <Stack direction='row' spacing={2} alignItems='center'>
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
                </div>
              </Grid>
            </>
          } />
          <ResultArea count={rows.length} gridRef={gridRef} gridFilterRef={gridFilterRef}>
            <DataGrid<InfoRow>
              gridRef={gridRef}
              gridFilterRef={gridFilterRef}
              itemsSource={rows}
              staticColumns={INFO_COLUMNS}
              isReadOnly
            />
          </ResultArea>
        </>
      }
    />
  );
};
