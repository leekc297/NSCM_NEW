import type { FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import { PeriodField } from 'features/master/src/components';
import { useEffect, useMemo, useRef } from 'react';

import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { CustomDialog, CustomDropdown, DataGrid, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid, Stack } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { MENU_ID, MSG, SHEETS } from '../../forecast-price.constants';

import styles from './VersionSelectModal.module.scss';
import { useVersionSelectModalStore } from './versionSelectModalStore';

// AS-IS DMF0082 Version 선택 — ⭐ 2026-07-24 원본 재실측 정정:
//   실제 AS-IS 팝업 = **SCM0002_VersionByWaterfallPopup** (제목 "Version Popup", MNU00179).
//   호출 = DMF0082_FcstNPrice_Mgmt.cs btnVersion_Click L3755~3759
//          popVersion.Form_Load(true, "MF_SP_SF", division, 조회 Period.start, 조회 Period.end)
//          — [PJ2025-50188] 로 축 "MF_SP" → "MF_SP_SF" 변경 (SF 도 노출 요구).
//   반환 콤마연결 버전 — 3개+ = MSG00255 미반영 / 1~2개 = txtVersion 반영. 'Current' 수동 입력 유효.
//   (구 주석의 DMF0073_VersionBySalesPricePopup 은 오기 — 그쪽은 Monthly Rolling Forecast 편집 팝업이며
//    DMF0082 가 여는 팝업이 아니다. 컬럼/체크박스/제목이 달랐던 원인.)
//
//   ⭐ 조회 SP — 원 SP `SCM0002_GET_VERSIONBYWATERFALLPOPUP` 는 사내 INVALID(ORA-01790 4곳) 라
//     **DMF0073_GET_VERSION_SALESPRICE (9-arg 공유 계약)** 로 대체 배선됨 (__asis-mapping__ §7-3).
//     두 SP 모두 `VERSION_TYPE IN (분해(P_VERSION_TYPE, ','))` 정확 토큰 매칭이라,
//     AS-IS SP 가 내부에서 하던 축→토큰 확장(PKG_SCM0002 L3759~3766)을 **FE 가 그대로 수행**한다.
//       MF_SP_SF_D → SP_D,MF_D,SF_D / MF_SP_SF_W → SP_W,MF_W,SF_W / MF_SP_SF_M → SP_M,MF_M,SF_M
//     ※ AS-IS .cs L229 가 덧붙이는 'ME_S' 는 SP 의 MF_SP_SF 분기가 V_VERSION_TYPE 만 사용해
//        **버려지므로**(L3757~3770) TO-BE 도 붙이지 않는다.

type VersionPopupRow = {
  CODE: string;
  VERSION_NO: string;
  VERSION_DESCRIPTION: string;
  VERSION_TYPE: string;
  MONTHLY_ROLLING_FCST: string;
  CREATED_BY: string;
  CREATION_DATE: string;
  EDIT_YN: string;
  [key: string]: string | number;
};

interface VersionSelectModalProps {
  open: boolean;
  modalClose: () => void;
  defaultDivision: string;
  // 부모(메인 화면) 조회 기간 — 팝업 Period 기본값으로 그대로 승계. 미지정 시 오늘 ±3개월 fallback.
  defaultPeriod?: { start: string; end: string };
  onApply: (versionIds: string) => void;
}

// AS-IS SCM0002_VersionByWaterfallPopup.InitSpread_X L166~177 — 표시 컬럼 1:1.
//   DIVISION_ID / VER_CRE_SEQ / YYYYMMDD 는 AS-IS 도 visible=false. EDI_APPLY 는 sCode=='MF' 전용이라
//   DMF0082(축 'MF_SP_SF') 에서는 미표시. MONTHLY_ROLLING_FCST 는 DMF0073 팝업 전용 컬럼이라 제거.
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
 * AS-IS 축 'MF_SP_SF' 가 SP 내부에서 확장되는 실제 VERSION_TYPE 접두 3종
 * (PKG_SCM0002.P_SCM0002_GET_VERSIONBYWATERFALLPOPUP L3759~3766 — 순서까지 원본 그대로).
 */
const VERSION_TYPE_PREFIXES = ['SP', 'MF', 'SF'] as const;

/** 체크박스 → VERSION_TYPE 콤마 토큰. AS-IS SP 확장 순서(D 그룹 → W 그룹) 유지.
 *  ⭐ Manual(M 그룹) 축은 2026-08-11 제거 — 통합테스트 1st No.33 사용자 요구
 *  "Manual 버튼은 삭제하고 Day, Week 버튼만 필요함" (AS-IS chkMonth 는 존재했으나 요구가 우선). */
const buildVersionType = (day: boolean, week: boolean): string =>
  [day ? 'D' : '', week ? 'W' : '']
    .filter(Boolean)
    .flatMap(suffix => VERSION_TYPE_PREFIXES.map(prefix => `${prefix}_${suffix}`))
    .join(',');

export const VersionSelectModal = ({
  open,
  modalClose,
  defaultDivision,
  defaultPeriod,
  onApply,
}: VersionSelectModalProps) => {
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

  // Period 기본값 — 부모(메인) 조회 기간을 그대로 승계. 미지정 시 오늘 ±3개월 fallback
  //   (MetalLinkVersionModal MultiTimeZone 동일 규칙).
  const defaultFrom = defaultPeriod?.start || dayjs().subtract(3, 'month').format('YYYYMMDD');
  const defaultTo = defaultPeriod?.end || dayjs().add(3, 'month').format('YYYYMMDD');
  // Day / Week — AS-IS Designer 기본값 = Week 만 Checked (chkWeek.Checked = true L149~150).
  //   ⭐ Manual(chkMonth) 은 2026-08-11 제거 — 통합테스트 No.33 "Day, Week 버튼만 필요"(사용자 요구).
  const { divisionId, periodFrom, periodTo, description, chkDay, chkWeek } =
    useVersionSelectModalStore(state => state.searchParams);
  const setSearchParams = useVersionSelectModalStore(state => state.setSearchParams);

  useEffect(() => {
    if (open) {
      setSearchParams({
        divisionId: defaultDivision,
        periodFrom: defaultFrom,
        periodTo: defaultTo,
        description: '',
        chkDay: false,
        chkWeek: true,
      });
    }
  }, [open, defaultDivision, defaultFrom, defaultTo, setSearchParams]);

  // DMF0073_GET_VERSION_SALESPRICE (9-arg — sesUserId/mnuId BE 자동. DB 배선 P1-7 SQL 참조).
  // ⭐ versionType = Day/Week/Manual 체크박스 → AS-IS SP 축 확장 결과 토큰 (파일 상단 주석 참조).
  //   기본 Week = 'SP_W,MF_W,SF_W' (구 하드코딩 'SP_W' 는 MF_W/SF_W 누락 상태였음 — 원본 대비 결손).
  //   전부 해제 = '' → VERSION_TYPE IN (빈 집합) 이라 실버전 0행. 'Current' 행은 SP 가 DUAL UNION 으로
  //   항상 emit 하므로 AS-IS 와 동일하게 남는다.
  const versionType = buildVersionType(chkDay, chkWeek);

  const filters = useMemo(
    () =>
      open
        ? {
            startYyyymmdd: periodFrom,
            endYyyymmdd: periodTo,
            createdBy: '',
            divisionId,
            versionType,
            description,
          }
        : undefined,
    [open, divisionId, periodFrom, periodTo, versionType, description]
  );

  const { data, refetch, isLoading, isFetching } = useTabProcQuery<MENU_ID, SHEETS.VERSION>({
    menuId: MENU_ID,
    sheetName: SHEETS.VERSION,
    tabId: MENU_ID,
    filters,
    enabled: !!filters, // open 시 자동조회 (SalesPriceVersionModal 선례)
  });

  const rows = useMemo<VersionPopupRow[]>(() => data?.o_rc1 ?? [], [data]);
  const loading = isLoading || isFetching;

  const handleFind = () => {
    void refetch?.();
  };

  // AS-IS 반환 규칙 (MetalLinkVersionModal 동일) — 3개+ = MSG00255 미반영 / 1~2개 반영
  const handleApply = () => {
    const g = gridRef.current;
    if (!g) return;
    const selectedItems = g.selectedItems as VersionPopupRow[];
    if (!selectedItems || selectedItems.length === 0) {
      void setAlert({ type: 'alert', content: t(MSG.VERSION_REQUIRED, '_Please select Version.') });
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
      void setAlert({ type: 'alert', content: t(MSG.VERSION_REQUIRED, '_Please select Version.') });
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
          {/* AS-IS SCM0002_VersionByWaterfallPopup.Designer L503 this.Text = "Version Popup" (MNU00179) */}
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
                {/* AS-IS chkDay / chkWeek — Designer L140~165 배치 순서 그대로.
                    ⭐ Manual(chkMonth) 체크박스는 2026-08-11 제거(통합테스트 No.33 사용자 요구).
                    ForecastPriceForm Sum/Qty 체크박스와 동일 패턴 (Checkbox labelText + Stack row). */}
                <Grid size={2} sx={{ display: 'flex', alignItems: 'center' }}>
                  <Stack direction='row' spacing={1} alignItems='center' sx={{ width: '100%' }}>
                    <Checkbox
                      labelText='Day'
                      checked={chkDay}
                      onChange={(checked: boolean) => setSearchParams({ chkDay: checked })}
                    />
                    <Checkbox
                      labelText='Week'
                      checked={chkWeek}
                      onChange={(checked: boolean) => setSearchParams({ chkWeek: checked })}
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
                        onChange={e => setSearchParams({ description: e.target.value })}
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
