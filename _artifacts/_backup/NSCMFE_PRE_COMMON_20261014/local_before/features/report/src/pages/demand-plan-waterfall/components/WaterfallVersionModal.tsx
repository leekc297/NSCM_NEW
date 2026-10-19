import { CellType, SelectionMode, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { PeriodField } from 'features/master/src/components';
import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { CustomDialog, CustomDropdown, DataGrid, ResultArea, SearchArea } from '@shared/components';
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
  // SALES 전용(DMF0073_GET_VERSION_SALESPRICE) — MONTHLY_ROLLING_FCST 는 'Y'/'N' 원본 그대로
  // (AS-IS VersionBySalesPricePopup 이 콤보로 편집하는 컬럼 — 체크박스 아님, 스크린샷 확인 2026-09-22).
  // EDIT_FLAG='N' 이면 이 행은 OPTIONAL/MANDATORY 컬럼이라도 편집 불가(GridUtils.isEditableCell
  //   행단위 게이트 — 공용 DataGrid 의 setEditableColumns 가 자동으로 참조한다). index 시그니처로
  //   선택적으로 실린다.
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

const VERSION_COLUMNS_BASE: RawFlexGridColumnConfig[] = [
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

// AS-IS VersionBySalesPricePopup 스크린샷(2026-09-22) 확인 — Monthly Rolling Forecast 는
//   체크박스가 아니라 Y/N 콤보(값 목록)로 편집한다. TO-BE 'YesOrNo' 콤보(SCM_ADM_CMBO_SQL_M,
//   파라미터 없음 — CODE/NAME 'Y'/'N', project-route VALID_YN 컬럼과 동일 선례)를 그대로 재사용한다.
const COMBO_YES_OR_NO = 'YesOrNo';

// SALES 전용 — DB 실측(2026-09-22) DMF0073_GET_VERSION_SALESPRICE 반환 컬럼(DM_MST_VERSION.ATTRIBUTE7).
//   사용자 편집 가능(Y/N 콤보), 저장은 PKG_DMF0035.P_DMF0035_SAVE_VERSION_MRF(admin 등록 완료).
//   행별 편집 가능 여부는 rows 매핑에서 EDITABLE(당주)·EDIT_YN(사업부 권한) 을 EDIT_FLAG 로 접는다.
const MONTHLY_ROLLING_FCST_COLUMN: RawFlexGridColumnConfig = {
  colNm: 'MONTHLY_ROLLING_FCST',
  colLblNm: 'Monthly Rolling Forecast',
  colWth: 170,
  horzAlgnCd: 'C',
  fixed: false,
  visible: true,
  display: true,
  inputTpCd: CELL_INPUT_EDIT_TYPE.OPTIONAL,
  cellCtrlObjTpCd: CELL_CONTROL_TYPE.COMBO,
  cellCboDataTp: COMBO_YES_OR_NO,
} as RawFlexGridColumnConfig;

const buildVersionColumns = (isSalesSheet: boolean): RawFlexGridColumnConfig[] =>
  isSalesSheet
    ? [
        ...VERSION_COLUMNS_BASE.slice(0, 3),
        MONTHLY_ROLLING_FCST_COLUMN,
        ...VERSION_COLUMNS_BASE.slice(3),
      ]
    : VERSION_COLUMNS_BASE;

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
  // MONTHLY_ROLLING_FCST 콤보 변경 추적(SALES 전용) — Save 시 dirty 행만 payload 로 묶는다.
  const editTrackerRef = useRef<EditTracker<VersionPopupRow> | undefined>();
  const savingRef = useRef(false);

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

  const versionColumns = useMemo(() => buildVersionColumns(isSalesSheet), [isSalesSheet]);

  const rows = useMemo<VersionPopupRow[]>(() => {
    const raw = (active.data?.o_rc1 ?? []) as Array<Record<string, string | number>>;
    if (!isSalesSheet) return raw as VersionPopupRow[];
    // MONTHLY_ROLLING_FCST 는 'Y'/'N' 원본 그대로 (Y/N 콤보 바인딩). EDITABLE(당주)·EDIT_YN(사업부
    //   권한) 둘 다 'Y' 일 때만 편집 가능 — 아니면 EDIT_FLAG='N' 으로 행 자체를 잠근다(SP 서버검증과
    //   이중 방어).
    return raw.map(r => ({
      ...r,
      ...(String(r.EDITABLE) === 'Y' && String(r.EDIT_YN) === 'Y' ? {} : { EDIT_FLAG: 'N' }),
    })) as VersionPopupRow[];
  }, [active.data, isSalesSheet]);
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

  // MONTHLY_ROLLING_FCST 저장 — DB 실측 확인된 PKG_DMF0035.P_DMF0035_SAVE_VERSION_MRF
  //   (P_DIVISION_ID/P_VERSION_NO/P_MONTHLY_ROLLING_FCST '^' 조인 배치 1콜, AS-IS SaveData 1:1).
  //   ContributeVersionModal/CapaNewModelPopup 과 같은 저수준 apiClient.post 패턴(useProcMutation 은
  //   행 단위 배열 계약이라 이 SP 의 '^' 조인 배치 계약과 맞지 않는다).
  const handleSave = async () => {
    // 재진입 가드를 dirty 체크보다 먼저 건다 — 한 클릭에서 핸들러가 중복 호출되면(예: HMR 잔여
    //   리스너) 두 번째 호출이 이미 저장·clearChanges 된 뒤의 빈 Map 을 읽어 "수정 없음" 을 잘못
    //   띄우면서도 첫 번째 호출은 정상 저장돼버려 "저장은 됐는데 알림은 실패로 뜬다"는 혼란을 낳는다.
    if (savingRef.current) return;
    savingRef.current = true;
    try {
      const g = gridRef.current;
      if (!g) return;
      g.finishEditing();

      const originals = editTrackerRef.current?.getOriginalValues();
      const dirtyRows = Array.from(originals?.keys() ?? []);
      if (dirtyRows.length === 0) {
        void setAlert({ type: 'alert', content: t('MSG00133', '_수정한 내용이 없습니다.') });
        return;
      }

      const res = await apiClient.post<{
        o_result_cursor?: Array<{ CODE?: string; MSG?: string; EVENT?: string }>;
      }>(`/${MENU_ID}/${SHEETS.VERSION}/SAVE/call-proc`, {
        divisionId,
        versionNo: dirtyRows.map(r => String(r.CODE ?? r.VERSION_NO ?? '')).join('^'),
        monthlyRollingFcst: dirtyRows.map(r => String(r.MONTHLY_ROLLING_FCST ?? 'N')).join('^'),
      });
      const result = res.data?.result?.o_result_cursor?.[0];
      if (result?.CODE === '0') {
        editTrackerRef.current?.clearChanges();
        // MSG00004 는 실제 등록 번역이 "수정한 내용이 없습니다."(MSG00133 과 동일 텍스트) 라
        //   여기 쓰면 성공 토스트에 그 문구가 그대로 새어 나간다(실사고 2026-09-22, KO.json 실측
        //   확인) — 사용자 지정(2026-09-22)으로 MSG00606("저장되었습니다.") 사용.
        void setToast({ type: 'success', message: t('MSG00606', '_저장되었습니다.') });
        void active.refetch?.();
      } else {
        void setAlert({
          type: 'alert',
          content: result?.MSG ?? t('MSG01288', '_실행중 에러가 발생했습니다.'),
        });
      }
    } catch {
      void setAlert({ type: 'alert', content: t('MSG01288', '_실행중 에러가 발생했습니다.') });
    } finally {
      savingRef.current = false;
    }
  };

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    g.isReadOnly = !isSalesSheet; // SALES 만 MONTHLY_ROLLING_FCST 콤보 편집 허용
    g.selectionMode = SelectionMode.ListBox; // Ctrl/Shift 비연속 행 다중선택 (enum 값 5 — 2는 CellRange)
    // MONTHLY_ROLLING_FCST 셀은 더블클릭이 콤보 편집 진입 트리거라 handleApply(선택확정+팝업닫기)를
    //   가로채면 안 된다 — 그대로 두면 편집기가 뜨기 전에 팝업이 닫혀 값 변경이 커밋되지 않는다.
    const onDbl = (e: MouseEvent) => {
      const ht = g.hitTest(e);
      if (ht.panel?.cellType === CellType.Cell && g.columns[ht.col]?.binding === 'MONTHLY_ROLLING_FCST') {
        return;
      }
      handleApply();
    };
    g.hostElement?.addEventListener('dblclick', onDbl);
    return () => g.hostElement?.removeEventListener('dblclick', onDbl);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [rows, isSalesSheet]);

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
                editTrackerRef={editTrackerRef}
                itemsSource={rows}
                staticColumns={versionColumns}
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
            {isSalesSheet && (
              <Button
                appearance='contained'
                priority='primary'
                size='medium'
                buttonLabel={t('LBL00111', 'Save')}
                iconComponent={<ControlConfirmIcon size='small' />}
                iconPosition='leading'
                disabled={loading}
                onClick={() => void handleSave()}
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
