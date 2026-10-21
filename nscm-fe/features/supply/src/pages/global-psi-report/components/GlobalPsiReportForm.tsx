import { PeriodField } from 'features/master/src/components';
import { useEffect, useMemo, useRef } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries, useTabProcQuery } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useMessageStore } from '@shared/stores';

import {
  AUX_SHEET,
  BUCKET_CODE,
  COMBO,
  DIVISION_EE_EXCLUDE,
  DIVISION_EXCLUDE_CODES,
  LBL,
  LOOKUP,
  MENU_ID,
  MSG,
  PLAN_DATE_PROGRAM_ID,
  PLAN_END_COL,
  PLAN_END_COMBO_ID,
  PLAN_END_DIVISION,
  SEARCH_MODE,
  SEARCH_MODE_OPTIONS,
  SITE_TYPE,
} from '../global-psi-report.constants';
import { divisionParam, useGlobalPsiReportStore } from '../useGlobalPsiReportStore';
import { isStartAfterPlan } from '../utils/globalPsiReportCalendar';

interface Props {
  // 보조 SP(Site/PlanDate) useTabProcQuery 의 per-tab 쿼리키 — 페이지에서 PageProps.tabId 를 내려준다.
  tabId: string;
  onSearch: () => void;
  // 팝업 오픈 — btnItemId(Model/Nickname, MaterialByDivisionModal) / btnProject(ProjectByDivisionModal) (design 02 §4.6).
  onItemSearch: () => void;
  onProjectSearch: () => void;
}

interface Option {
  label: string;
  value: string;
}

// design 02 §5 조회조건 combo 상세 (칸-콤보 대응표 — 검색조건 Form 상단 상시 유지 규칙):
//   Div.*        → COMBO.DIVISION('Division_SCP', 공유콤보) + FE 3중 제외(EE/'40'/'82', §2.7 부록 B-1/B-2).
//                  AS-IS clbDivision = UsrCheckedList2 다중(카탈로그 'Global PSI New' Div. 선택·다중+ALL버튼)
//   From/To Site → AUX_SHEET.SITE(SP P_SCP0100_GET_SITE) useTabProcQuery — p_site_tpye 로 From/To 분기.
//                  division/bucket 을 파라미터로 조회(Division 미선택 = '' 전 Division, AS-IS Shown 시점 동일)
//   Plan Date    → AUX_SHEET.PLAN_DATE(SP P_SCP0100_GET_PLAN_DATE) — AS-IS GetPlanDate 는 Load 1회 _division=''
//                  (.cs:592-597) 로만 호출 → division '' 고정 · bucket · program_id='SCP0100'(§2.3)
//   Period*      → 공용 PeriodField(AS-IS dCalendar UsrDateRangePicker3 "Period*", 카탈로그 Period·달력)
//   Bucket       → 정적 select(MONTHLY 기본/WEEKLY — SP 계약값). M_/W_ pivot visible 토글(design 03 §2.5)
//   Display      → AS-IS layDisplay.Visibility=Never(designer:1180) — 화면 미노출. 값은 store 기본 GRID 유지
//   Search Level → useTabLookupQueries('PRODUCT_LEVEL') — idx0=CELL_GROUP(§2.6)
//   Plan Type    → useTabLookupQueries('PLAN_TYPE') — 기본 'FN'. AS-IS PlanType.Enabled=false(designer:1159) 비활성
//   Unit         → useTabLookupQueries('SCP_UNIT_QTY')(AS-IS ScpUtils.GetUnitQty) — 로컬 표시배율, 서버 재조회 없음
//   Graph Type   → AS-IS lblGraphType.Visibility=Never + NO-OP(.cs:1773) — 미배선
//   A/S / Cell Qty→ 체크박스(P_CHK_AS/P_CHK_CELL_QTY). 변경 핸들러 NO-OP(.cs:1915·1924) — 조회 파라미터로만 반영
//   Cell Group   → Text 입력(P_CELL_GROUP)
//   Model/Nickname / PJT → Text + 팝업(§4.6). division 파라미터 cascade(preSearchParams)
// From/To Site·Plan Date SP 는 SCM_ADM_CMBO_SQL_M 미등록(부록 B-1) → 콤보 아닌 보조 proc(§5.2). 05_register 등록(Task#5).

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// GET SP 응답에서 표준 커서(O_RC1 = key 'o_rc1') 행만 뽑는다(부록 B-3). 상태봉투(O_RESULT_CURSOR)는 무시.
const pickRows = (data: unknown): ComboResponse[] =>
  ((data as { o_rc1?: ComboResponse[] } | undefined)?.o_rc1 ?? []);

// AS-IS SCP0100_Global_PSI_Report.cs 조회조건 패널 — design 02 §5.1 SearchArea 매핑.
//   2단(6필드) 상시: Div.* / From Site / To Site / Plan Date* / Period* / Bucket.
//   나머지는 extraConditions 로 3단째부터 접는다(Hook #52 search-area-extra-conditions).
export const GlobalPsiReportForm = ({ tabId, onSearch, onItemSearch, onProjectSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useGlobalPsiReportStore(s => s.searchCondition);
  const set = useGlobalPsiReportStore(s => s.setSearchCondition);
  const setDivision = useGlobalPsiReportStore(s => s.setDivision);
  const clearFilters = useGlobalPsiReportStore(s => s.clearFilters);
  const setUnitScaleIndex = useGlobalPsiReportStore(s => s.setUnitScaleIndex);
  const unitScaleIndex = useGlobalPsiReportStore(s => s.unitScaleIndex);
  const openSearchArea = useGlobalPsiReportStore(s => s.openSearchArea);
  // rgrpSearchLevel — SEARCH(idx0)/DETAIL(idx1) 토글. Detail 이면 REPORT 시트 라우팅(design 01 R1~R4).
  const searchMode = useGlobalPsiReportStore(s => s.searchMode);
  const setSearchMode = useGlobalPsiReportStore(s => s.setSearchMode);
  const calendarSeedPlan = useGlobalPsiReportStore(s => s.calendarSeedPlan);
  const seedCalendar = useGlobalPsiReportStore(s => s.seedCalendar);

  // Division 소스풀(공유콤보) — AS-IS BLUtils.GetDivisionWithoutEE + 40/82 dt 필터를 FE 3중 제외로 재현(§2.7).
  const [divisions] = useTabComboQueries({ filters: [COMBO.DIVISION] });

  // Search Level / Plan Type / Unit — lookup(SCM_ADM_LOOKUP_MASTER_DETAIL). VALID_YN='Y'+DISPLAY_SEQ 순(§2.6).
  const [searchLevelRows, planTypeRows, unitQtyRows] = useTabLookupQueries({
    filters: [LOOKUP.SEARCH_LEVEL, LOOKUP.PLAN_TYPE, LOOKUP.UNIT_QTY],
  });

  // 다중 Division 정규화값(ALL/미선택 → '') — Site SP·팝업 preSearchParams 공통.
  const divisionId = divisionParam(sc.divisionId);

  // From/To Site — SP P_SCP0100_GET_SITE (p_site_tpye 로 분기). P_DIVISION_ID 는 FN_SPLITSTRING 다중 / '' = 전 Division.
  // 필수: filters 는 useMemo 로 참조 고정. useTabProcQuery 가 filters 를 참조비교로 "재조회" 판정하므로
  //   렌더 본문 리터럴을 넘기면 removeQueries→refetch→재렌더 무한 루프가 된다(GlobalPsi 기존 수정과 동일).
  const fromSiteFilters = useMemo(
    () => ({ pSiteTpye: SITE_TYPE.FROM, divisionId, bucket: sc.bucket }),
    [divisionId, sc.bucket]
  );
  const fromSiteQuery = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: AUX_SHEET.SITE,
    tabId,
    filters: fromSiteFilters,
    // useTabProcQuery 는 enabled 기본 false — AS-IS 는 진입 시 Division ''(전체)로도 조회하므로 항상 조회.
    enabled: true,
  });
  const toSiteFilters = useMemo(
    () => ({ pSiteTpye: SITE_TYPE.TO, divisionId, bucket: sc.bucket }),
    [divisionId, sc.bucket]
  );
  const toSiteQuery = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: AUX_SHEET.SITE,
    tabId,
    filters: toSiteFilters,
    // useTabProcQuery 는 enabled 기본 false — AS-IS 는 진입 시 Division ''(전체)로도 조회하므로 항상 조회.
    enabled: true,
  });

  // Plan Date — SP P_SCP0100_GET_PLAN_DATE. AS-IS GetPlanDate(.cs:1357) 는 InitControls(.cs:592-597)에서 진입 시
  //   _division(체크 0건 = '') 로 1회만 호출된다 → division '' 고정(SP 의 A.DIVISION_ID 단일 등호 조건도 '' 면 skip).
  const planDateFilters = useMemo(
    () => ({ divisionId: '', bucket: sc.bucket, programId: PLAN_DATE_PROGRAM_ID }),
    [sc.bucket]
  );
  const planDateQuery = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: AUX_SHEET.PLAN_DATE,
    tabId,
    filters: planDateFilters,
    // useTabProcQuery 는 enabled 기본 false — AS-IS 는 진입 시 Division ''(전체)로도 조회하므로 항상 조회.
    enabled: true,
  });

  const divisionOptions = useMemo<Option[]>(() => {
    const excluded = new Set(DIVISION_EXCLUDE_CODES as readonly string[]);
    // 3중 제외 = EE(전극, ATTRIBUTE3) + '40'(M&IT) + '82'(ESS) — 셀 단위 division 만(부록 B-2).
    return toOptions(
      (divisions ?? []).filter(
        r => str(r.ATTRIBUTE3) !== DIVISION_EE_EXCLUDE && !excluded.has(str(r.CODE))
      )
    );
  }, [divisions]);

  const fromSiteOptions = toOptions(pickRows(fromSiteQuery.data));
  const toSiteOptions = toOptions(pickRows(toSiteQuery.data));
  const planDateOptions = toOptions(pickRows(planDateQuery.data));
  const searchLevelOptions = toOptions(searchLevelRows as ComboResponse[] | undefined);
  const planTypeOptions = toOptions(planTypeRows as ComboResponse[] | undefined);
  const unitQtyOptions = toOptions(unitQtyRows as ComboResponse[] | undefined);
  const bucketOptions: Option[] = [
    { label: t(LBL.MONTHLY, 'Monthly'), value: BUCKET_CODE.MONTHLY },
    { label: t(LBL.WEEKLY, 'Weekly'), value: BUCKET_CODE.WEEKLY },
  ];
  const searchModeOptions: Option[] = SEARCH_MODE_OPTIONS.map(o => ({
    label: t(o.lbl, o.label),
    value: o.value,
  }));

  // 권한 Division 0 방어 (design 01 A1) — 공유콤보 로드 완료(divisions !== undefined) 후 제외필터 결과가
  //   0건이면 사업부 권한 없음. 부록 B-6 실측상 SCP0100 은 2행 등록으로 실발동 안 하나(저위험) 방어적 배선.
  //   ShipmentSemiDeptDayForm noDivisionAuth 선례 동형. 1회만 alert(alertedRef 가드) + 콤보 disable.
  const setAlert = useMessageStore.getState().setAlert;
  const alertedRef = useRef(false);
  const noDivisionAuth = divisions !== undefined && divisionOptions.length === 0;
  useEffect(() => {
    if (noDivisionAuth && !alertedRef.current) {
      alertedRef.current = true;
      void setAlert({
        type: 'alert',
        content: t(MSG.NO_DIVISION_AUTH, '_No authority assigned.'),
      });
    }
    if (!noDivisionAuth) alertedRef.current = false;
  }, [noDivisionAuth, setAlert, t]);

  // Plan Date 기본값 — 목록 첫 항목(design 02 §4.2 OnShown setListBox index0 재바인딩). 단일 콤보.
  const firstPlanDate = planDateOptions[0]?.value ?? '';
  const hasPlanDate = planDateOptions.some(o => o.value === sc.planStartYyyymmdd);
  useEffect(() => {
    if (firstPlanDate && !hasPlanDate) set({ planStartYyyymmdd: firstPlanDate });
  }, [firstPlanDate, hasPlanDate, set]);

  // 조회기간 초기값 — AS-IS SetCalendar(SCP0100_Global_PSI_Report.cs:1317) = GetDayRange "MONTH"(.cs:1409~1423).
  //   호출 시점: InitControls(.cs:600, Load) + CboPlanDate_SelectedIndexChanged(.cs:1788) = Plan Date 가 정해지거나 바뀔 때.
  //   종료일 = GetPlanEndDate(.cs:2029) — division '81' 고정·WEEKLY(PLAN_END_DIVISION) 의 HORIZON_END_DATE(등록 콤보 SCPPlanPeriod_SCP).
  //   콤보 응답이 오기 전(undefined)에는 기다리고, 이미 시드한 Plan Date 면 건너뛴다(리마운트 시 사용자 기간 보존).
  const planEndFilters = useMemo(
    () => [
      { comboId: PLAN_END_COMBO_ID, planName: sc.planStartYyyymmdd, divisionId: PLAN_END_DIVISION },
    ],
    [sc.planStartYyyymmdd]
  );
  const [planEndRows] = useTabComboQueries({
    filters: planEndFilters,
    enabled: !!sc.planStartYyyymmdd,
  });
  useEffect(() => {
    const plan = sc.planStartYyyymmdd;
    if (!plan || planEndRows === undefined || calendarSeedPlan === plan) return;
    seedCalendar(plan, str(planEndRows[0]?.[PLAN_END_COL]));
  }, [sc.planStartYyyymmdd, planEndRows, calendarSeedPlan, seedCalendar]);

  // 조회기간 변경 — AS-IS DCalendar_ValueChanged(.cs:2006-2021): 시작일 > Plan 시작일이면 경고 후
  //   기간을 plan_start:end 로 되돌린다(dCalendar.InitValue). 기간 변경은 calendar(3SPAN) 헤더 재조회로 이어진다(InitSpread).
  const changePeriod = (start: string, end: string) => {
    if (isStartAfterPlan(start, sc.planStartYyyymmdd)) {
      void setAlert({
        type: 'alert',
        content: t(MSG.PLAN_DATE_RANGE, 'Begin Date is early or equal to Plan Date.'),
      });
      set({ fromYyyymmdd: sc.planStartYyyymmdd, toYyyymmdd: end });
      return;
    }
    set({ fromYyyymmdd: start, toYyyymmdd: end });
  };

  // Unit — 선택 code 의 목록 index 가 배율 index(AS-IS SetUnitQty .cs:1697 SelectedIndex 0~3 → 1/1e3/1e6/1e8).
  const unitQtyValue = unitQtyOptions[unitScaleIndex]?.value ?? '';
  const pickUnitQty = (code: string) => {
    const idx = unitQtyOptions.findIndex(o => o.value === code);
    setUnitScaleIndex(idx < 0 ? 0 : idx);
  };

  // single-select 콤보 렌더 헬퍼(IntegrationPsiForm 동형).
  const single = (
    labelText: string,
    value: string,
    options: Option[],
    onPick: (code: string) => void,
    required?: boolean,
    disabled?: boolean
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={labelText}
        labelAlign='right'
        required={required}
        render={() => (
          <CustomDropdown
            value={value}
            options={options}
            disabled={disabled}
            onChange={(_, picked) => onPick(String(picked ?? ''))}
          />
        )}
      />
    </Grid>
  );

  // multi-select 콤보 — AS-IS clbDivision/clbFromSite/clbToSite 는 UsrCheckedList2(다중). 값은 콤마구분 string(§2.2).
  const multi = (
    labelText: string,
    value: string,
    options: Option[],
    onPick: (codes: string) => void,
    required?: boolean,
    disabled?: boolean
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={labelText}
        labelAlign='right'
        required={required}
        render={() => (
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            limitTags={1}
            value={value}
            options={options}
            disabled={disabled}
            onChange={(_, picked) => onPick(String(picked ?? ''))}
          />
        )}
      />
    </Grid>
  );

  // 팝업버튼 부착 텍스트 필드 — Model/Nickname / PJT(SCM0002 팝업이 채움, design 02 §4.6).
  const popupField = (
    labelText: string,
    value: string,
    onChange: (v: string) => void,
    onPopup: () => void
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={labelText}
        labelAlign='right'
        render={() => (
          <InputField
            fullWidth
            className={commonStyles.popupSearchField}
            value={value}
            InputProps={{
              endAdornment: (
                <Button
                  appearance='outlined'
                  priority='normal'
                  iconComponent={<FunctionSearchIcon appearance='lined' onClick={onPopup} />}
                />
              ),
            }}
            onChange={e => onChange(e.target.value)}
            onKeyDown={e => e.key === 'Enter' && onSearch()}
          />
        )}
      />
    </Grid>
  );

  const textField = (
    labelText: string,
    value: string,
    onChange: (v: string) => void
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={labelText}
        labelAlign='right'
        render={() => (
          <InputField
            fullWidth
            value={value}
            onChange={e => onChange(e.target.value)}
            onKeyDown={e => e.key === 'Enter' && onSearch()}
          />
        )}
      />
    </Grid>
  );

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, 'Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Row0 — Div.* / From Site / To Site / Plan Date* */}
          {multi(
            t(LBL.DIVISION, 'Div.'),
            sc.divisionId,
            divisionOptions,
            // Division 변경 = 검색조건(Div·조회기간 제외) + 그리드 초기화(store setDivision, TO-BE 공통 요건). 편집중(dirty)이면
            //   MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가 이전 Div 로 복귀(commit 51d4e9fa 패턴).
            v => {
              void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                if (ok) setDivision(v);
              });
            },
            true,
            noDivisionAuth
          )}
          {multi(
            t(LBL.FROM_SITE, 'From Site'),
            sc.fromSite,
            fromSiteOptions,
            v => set({ fromSite: v })
          )}
          {multi(
            t(LBL.TO_SITE, 'To Site'),
            sc.toSite,
            toSiteOptions,
            v => set({ toSite: v })
          )}
          {single(
            t(LBL.PLAN_DATE, 'Plan Date'),
            sc.planStartYyyymmdd,
            planDateOptions,
            // AS-IS SCP0100_Global_PSI_Report.cs:1784 CboPlanDate_SelectedIndexChanged — SetCalendar + InitSpread + SetGridClear(:1793).
            //   그리드 초기화 = clearFilters(재조회 전까지 빈 상태). 자동조회 없음(AS-IS 동일). SetCalendar(조회기간 재설정)는
            //   planStartYyyymmdd 변경을 받는 위 seedCalendar effect 가 수행(__asis-mapping__ D00-2-019).
            v => {
              set({ planStartYyyymmdd: v });
              clearFilters();
            },
            true
          )}

          {/* Row1 — Period*(From~To) / Bucket */}
          <PeriodField
            gridSize={3}
            start={sc.fromYyyymmdd}
            end={sc.toYyyymmdd}
            onChange={changePeriod}
            label={t(LBL.PERIOD, 'Period')}
          />
          {single(
            t(LBL.BUCKET, 'Bucket'),
            sc.bucket,
            bucketOptions,
            // AS-IS SCP0100_Global_PSI_Report.cs:1798 CboBucketType_SelectedIndexChanged — SetSpreadColumn + SetGridClear + FindData(:1812).
            //   M_/W_ pivot visible 토글(design 03 §2.5) 후 즉시 재조회(setFilter 는 store 최신값을 읽으므로 set 직후 호출 안전).
            v => {
              set({ bucket: v });
              onSearch();
            }
          )}
        </>
      }
      extraConditions={
        <>
          {/* Row2~ — Search Level/Detail / Search Level / Plan Type / Unit */}
          {/* rgrpSearchLevel(design 01 R1~R4) — SEARCH(idx0)/DETAIL(idx1). Detail 이면 REPORT 시트 라우팅 +
              cboSearchLevel disable(R4). 공용 RadioGroup 부재로 2지선다 CustomDropdown 대체. AS-IS 레이아웃 라벨 없음
              (layoutControlItem3.TextVisible=false designer:1365) → 라벨 공란, 항목 문구만 LBL00050/LBL00316. */}
          {single(
            '',
            searchMode,
            searchModeOptions,
            v => setSearchMode(v === SEARCH_MODE.DETAIL ? SEARCH_MODE.DETAIL : SEARCH_MODE.SEARCH)
          )}
          {single(
            t(LBL.SEARCH_LEVEL, 'Search Level'),
            sc.searchLevel,
            searchLevelOptions,
            // AS-IS SCP0100_Global_PSI_Report.cs:1853 CboSearchLevel_SelectedIndexChanged — VisibleSheet + SetGridClear + FindData(:1861).
            //   활성 그리드 시트 결정(design 01 R1~R3) 후 즉시 재조회(setFilter 가 새 활성 시트 filter 만 세팅 = 나머지 clear).
            v => {
              set({ searchLevel: v });
              onSearch();
            },
            false,
            // R4 — Detail 모드에서는 REPORT 시트 고정이라 Search Level 선택을 잠근다(design 01).
            searchMode === SEARCH_MODE.DETAIL
          )}
          {single(
            t(LBL.PLAN_TYPE, 'Plan Type'),
            sc.planType,
            planTypeOptions,
            v => set({ planType: v }),
            false,
            // AS-IS PlanType.Enabled=false(designer:1159) — 'FN'(Final Plan) 고정, 카탈로그 비고 "비활성화_Final Plan".
            true
          )}
          {single(
            t(LBL.UNIT, 'Unit'),
            unitQtyValue,
            unitQtyOptions,
            // Unit = 로컬 표시배율(§2.5) — 서버 재조회 없이 그리드 클라 나눗셈. index 저장만(CboUnitQty .cs:1864).
            pickUnitQty
          )}

          {/* Row3~ — Cell Group / Model/Nickname(팝업) / PJT(팝업) */}
          {textField(
            t(LBL.CELL_GROUP, 'Cell Group'),
            sc.cellGroup,
            v => set({ cellGroup: v })
          )}
          {/* AS-IS layModel "Model / Nick Name"(designer:1055-1060) = txtItemId + btnItemId. 카탈로그 Model/Nickname(메1). */}
          {popupField(
            t(LBL.MODEL_NICKNAME, 'Model/Nickname'),
            sc.itemId,
            v => set({ itemId: v }),
            onItemSearch
          )}
          {popupField(
            t(LBL.PROJECT, 'PJT'),
            sc.project,
            v => set({ project: v }),
            onProjectSearch
          )}

          {/* Row4~ — A/S / Cell Qty (변경 핸들러 NO-OP — 조회 파라미터로만 반영) */}
          <Grid size={3} className={commonStyles.customGrid}>
            <div className={commonStyles.customCheckbox}>
              <Checkbox
                labelText={t(LBL.AS, 'A/S')}
                checked={sc.chkAs}
                onChange={checked => set({ chkAs: checked })}
              />
            </div>
          </Grid>
          <Grid size={3} className={commonStyles.customGrid}>
            <div className={commonStyles.customCheckbox}>
              <Checkbox
                labelText={t(LBL.CELL_QTY, 'Cell Qty')}
                checked={sc.chkCellQty}
                onChange={checked => set({ chkCellQty: checked })}
              />
            </div>
          </Grid>
        </>
      }
    />
  );
};
