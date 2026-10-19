import { CellType, SelectionMode, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { PeriodField } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE, CRUD_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import { CustomDialog, CustomDropdown, DataGrid, ResultArea, SearchArea } from '@shared/components';
import { useTabBtnPermissions, useTabComboQueries, useTabProcQuery } from '@shared/hooks';
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
//   [E20260922-VERMRF] SALES 만 Monthly Rolling Forecast 컬럼 표시 + 당주 행 Y/N 콤보 편집·저장
//     (AS-IS DMF0073 팝업 GridEdit/SaveData — 저장 = version 시트 SAVE → PKG_DMF0035.P_DMF0035_SAVE_VERSION_MRF).
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

// [E20260922-VERMRF] SALES 전용 Monthly Rolling Forecast — AS-IS DMF0073_VersionBySalesPricePopup
//   GridEdit()(.cs L410~436) "EDITABLE='Y' 행의 MONTHLY_ROLLING_FCST 만 수정" + SaveData()(L231~304) 1:1.
//   값 = DM_MST_VERSION.ATTRIBUTE7 (Y/N). 콤보 = 공용 CMBO 'YesOrNo'(옵션 하드코딩 금지).
const MRF_COLUMN = 'MONTHLY_ROLLING_FCST';
const MRF_COMBO_ID = 'YesOrNo';

/**
 * 버전 기준일이 이번 주(월~일 — 달력 ISO 주차)인가.
 *   조회 SP 의 EDITABLE 은 ISO 주차 번호만 비교해 작년 같은 주차도 'Y' 가 된다(AS-IS 동일 결함) —
 *   "당주" 요구에 맞게 연도까지 같은 주로 한정한다. 저장 SP 도 같은 조건(ISO_YYYYWW)으로 재검증한다.
 */
const isCurrentWeekYmd = (yyyymmdd: string): boolean => {
  if (!/^\d{8}$/.test(yyyymmdd)) return false;
  const today = dayjs().startOf('day');
  const monday = today.subtract((today.day() + 6) % 7, 'day');
  const sunday = monday.add(6, 'day');
  const ymd = (d: typeof today) => d.format('YYYYMMDD');
  return yyyymmdd >= ymd(monday) && yyyymmdd <= ymd(sunday);
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

// SALES 컬럼 = 위 5컬럼 + Type 뒤 MRF (DMF0020 SalesPriceVersionModal 과 같은 위치·라벨·폭).
//   편집 판정 = 공용 GridUtils.isEditableCell — inputTpCd 'O' × 행 EDIT_FLAG (행은 아래 rows 에서 산출).
const SALES_VERSION_COLUMNS: RawFlexGridColumnConfig[] = VERSION_COLUMNS.flatMap(c =>
  c.colNm === 'VERSION_TYPE'
    ? [
        c,
        {
          colNm: MRF_COLUMN,
          colLblNm: 'Monthly Rolling Forecast',
          colWth: 170,
          horzAlgnCd: 'C',
          fixed: false,
          visible: true,
          display: true,
          inputTpCd: CELL_INPUT_EDIT_TYPE.OPTIONAL,
          cellCtrlObjTpCd: CELL_CONTROL_TYPE.COMBO,
          cellCboDataTp: MRF_COMBO_ID,
        } as RawFlexGridColumnConfig,
      ]
    : [c]
);

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
  const setToast = useMessageStore(s => s.setToast);
  const gridRef = useRef<FlexGridType<VersionPopupRow>>(undefined);
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

  // MRF 저장 권한 = 메뉴 버튼 'SAVE'(version 시트 매핑 — ADMIN/DM ADMIN/DM Planner/SCP Planner) × SALES
  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const canSaveMrf = isSalesSheet && hasButton('SAVE');

  // 행 EDIT_FLAG = 저장권한 × SP EDITABLE(당주) × SP EDIT_YN(사업부 편집권한) × 버전 기준일 이번 주.
  //   'Current' 행은 SP 가 EDITABLE='N' 으로 내려 항상 잠김 (AS-IS 동일).
  const rows = useMemo<VersionPopupRow[]>(
    () =>
      ((active.data?.o_rc1 ?? []) as VersionPopupRow[]).map(r => ({
        ...r,
        EDIT_FLAG:
          canSaveMrf &&
          r.EDITABLE === 'Y' &&
          r.EDIT_YN === 'Y' &&
          isCurrentWeekYmd(String(r.YYYYMMDD ?? ''))
            ? 'Y'
            : 'N',
      })),
    [active.data, canSaveMrf]
  );
  const [saving, setSaving] = useState(false);
  const loading = active.isLoading || active.isFetching || saving;

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

  // ⭐ MRF 저장 (AS-IS SaveData .cs L231~304) — 변경 행만 '^' 연결 전송, 저장 후 재조회(FindButton).
  //   SP = PKG_DMF0035.P_DMF0035_SAVE_VERSION_MRF (값 Y/N·당주·사업부 편집권한 서버 재검증).
  const handleSaveMrf = async () => {
    const g = gridRef.current;
    if (!g || saving) return;
    if (g.activeEditor) g.finishEditing();
    const changed = GridUtils.getChangedRows(g, CRUD_TYPE.MODIFY);
    if (changed.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00004', '_No changes to save.') });
      return;
    }
    // AS-IS MSG00002("{0} 값은 필수 입력입니다", 인자 MONTHLY_ROLLING_FCST) — TO-BE 의미 1:1 = MSG00614
    if (changed.some(r => !String(r[MRF_COLUMN] ?? '').trim())) {
      void setAlert({
        type: 'alert',
        content: t('MSG00614', '_The {0} value is required.').replace('{0}', MRF_COLUMN),
      });
      return;
    }
    const ok = await setAlert({ type: 'confirm', content: t('MSG00001', '_Would you like to save it?') });
    if (!ok) return;
    setSaving(true);
    try {
      const join = (sel: (r: VersionPopupRow) => string): string => changed.map(sel).join('^');
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/${SHEETS.VERSION}/SAVE/call-proc`,
        // 사용자 = PROC_M 'sesUserId' (BE 세션 자동 주입 — 요청에 싣지 않는다)
        {
          divisionId,
          versionNo: join(r => String(r.CODE ?? '')),
          monthlyRollingFcst: join(r => String(r[MRF_COLUMN] ?? '')),
        }
      );
      // 결과 = o_result_cursor[0] {CODE, MSG, EVENT} — '0' 성공 / '-1' 검증(EVENT=대상 버전) / '9' 오류
      const inner = (
        res.data?.result as { o_result_cursor?: { CODE?: string; MSG?: string; EVENT?: string }[] }
      )?.o_result_cursor?.[0];
      if (res.status >= 400 || !inner || String(inner.CODE) !== '0') {
        const reason = [inner?.MSG, inner?.EVENT].filter(Boolean).join('\n');
        void setAlert({
          type: 'alert',
          content: reason || t('MSG00618', '_An error occurred while saving.'),
        });
        return;
      }
      setToast({ message: t('MSG00606', '_Saved successfully.'), type: 'success' });
      void active.refetch?.();
    } catch {
      void setAlert({ type: 'alert', content: t('MSG00618', '_An error occurred while saving.') });
    } finally {
      setSaving(false);
    }
  };

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    // SALES × SAVE 권한일 때만 편집 허용 — 실제 편집 셀은 공용 isEditableCell(MRF 'O' × 행 EDIT_FLAG)이 가른다.
    g.isReadOnly = !canSaveMrf;
    g.selectionMode = SelectionMode.ListBox; // Ctrl/Shift 비연속 행 다중선택 (enum 값 5 — 2는 CellRange)
    const onDbl = (e: MouseEvent) => {
      // 편집 가능한 MRF 셀의 더블클릭 = 콤보 편집 — 버전 확정(OK)으로 처리하지 않는다
      const ht = g.hitTest(e);
      if (ht.cellType === CellType.Cell && GridUtils.isEditableCell(g, ht.row, ht.col)) return;
      handleApply();
    };
    g.hostElement?.addEventListener('dblclick', onDbl);
    return () => g.hostElement?.removeEventListener('dblclick', onDbl);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [rows, canSaveMrf]);

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
          {/* AS-IS SCM0002_VersionByWaterfallPopup.Designer this.Text = "Version Popup" (MNU00179) */}
          <h2 className='headerTitle'>{t('MNU00179', 'Version Popup')}</h2>
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
            <ResultArea title='' count={rows.length} gridRef={gridRef} gridFilterRef={gridFilterRef}>
              <DataGrid<VersionPopupRow>
                gridRef={gridRef}
                gridFilterRef={gridFilterRef}
                itemsSource={rows}
                staticColumns={isSalesSheet ? SALES_VERSION_COLUMNS : VERSION_COLUMNS}
                autoGenerateColumns={false}
                className={styles.grid}
              />
            </ResultArea>
          </div>
          <div className={styles.buttonWrapper}>
            <Button
              appearance='outlined'
              priority='normal'
              size='medium'
              buttonLabel={t('LBL00627', 'Close')}
              onClick={modalClose}
            />
            {canSaveMrf && (
              <Button
                appearance='outlined'
                priority='normal'
                size='medium'
                buttonLabel={t('LBL00111', 'Save')}
                disabled={loading}
                onClick={() => void handleSaveMrf()}
              />
            )}
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
