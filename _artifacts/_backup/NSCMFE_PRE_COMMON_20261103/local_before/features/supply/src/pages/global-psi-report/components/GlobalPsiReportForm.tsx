import { useEffect, useMemo, useRef, useState } from 'react';

import { apiClient } from '@foundation/apis';
import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, PeriodRangePicker, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries, useTabProcQuery } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField, Radio, RadioGroup } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import {
  AUX_SHEET,
  BUCKET_CODE,
  CASCADE_COL,
  COMBO,
  DIVISION_ALL,
  DIVISION_EE_EXCLUDE,
  DIVISION_EXCLUDE_CODES,
  LBL,
  LOOKUP,
  MENU_ID,
  MSG,
  normalizeDivision,
  PLAN_DATE_PROGRAM_ID,
  PLAN_END_DATE_COL,
  PLAN_END_DATE_COMBO_ID,
  PLAN_END_DATE_DIVISION,
  PLAN_END_DATE_PLAN_CYCLE,
  SEARCH_MODE,
  SEARCH_MODE_OPTIONS,
  SITE_TYPE,
  UNIT_QTY_OPTIONS,
} from '../global-psi-report.constants';
import { useGlobalPsiReportStore } from '../useGlobalPsiReportStore';

import styles from './GlobalPsiReportForm.module.scss';

interface Props {
  // 보조 SP(Site/PlanDate) useTabProcQuery 의 per-tab 쿼리키 — 페이지에서 PageProps.tabId 를 내려준다.
  tabId: string;
  onSearch: () => void;
  // 팝업 오픈 — btnItemId(ItemByDivisionModal) / btnProject(ProjectByDivisionModal) (design 02 §4.6).
  onItemSearch: () => void;
  onProjectSearch: () => void;
}

interface Option {
  label: string;
  value: string;
}

// design 02 §5 조회조건 combo 상세 (칸-콤보 대응표 — 검색조건 Form 상단 상시 유지 규칙):
//   Division*    → COMBO.DIVISION('Division_SCP', 공유콤보) + FE 3중 제외(EE/'40'/'82', §2.7 부록 B-1/B-2)
//   From/To Site → AUX_SHEET.SITE(SP P_SCP0100_GET_SITE) useTabProcQuery — p_site_tpye 로 From/To 분기.
//                  load-once(Division 변경 cascade 아님, §2.2/§3) — division/bucket 을 파라미터로 조회
//   Plan Date    → AUX_SHEET.PLAN_DATE(SP P_SCP0100_GET_PLAN_DATE) — division·bucket·program_id='SCP0100'(§2.3)
//   Bucket       → 정적 select(MONTHLY 기본/WEEKLY). M_/W_ pivot visible 토글(design 03 §2.5)
//   Display      → AS-IS layDisplay.Visibility=Never(designer.cs:1180) 숨김 → 조회조건 미노출. 값만 store 기본 GRID 유지(§2.6)
//   Search Level → useTabLookupQueries('PRODUCT_LEVEL') — idx0=CELL_GROUP(§2.6)
//   Plan Type    → COMBO.PLAN_TYPE('PlanType1_SCP_ALL' 공유콤보) — Division+Plan Date 종속 필터(AS-IS SCP0031
//                  RefreshPlanType 등가, 2026-10-26). 실존 plan version 만 노출(TE/PR/MA/FN…), 기본=필터 첫 항목
//                  (FN 고정·정적 lookup 폐기). SCP0100 자체 AS-IS 는 정적 lookup 이나 사용자 실동작 기준 전환
//   Unit(Qty)    → 정적 select(로컬 표시배율 0/1e3/1e6/1e8). 서버 재조회 없음(§2.5)
//   Graph Type   → AS-IS NO-OP(§3, 본문 공백) — 미배선(design 01 §2). LBL 미등록(부록 B-5)
//   AS / Cell Qty→ 체크박스(P_CHK_AS/P_CHK_CELL_QTY). AS-IS NO-OP(§3) — 조회 파라미터로만 반영
//   Cell Group   → Text 입력(P_CELL_GROUP)
//   Model/NickNm → Text + SCM0002_ItembyDivisionPopup(§4.6, AS-IS layModel 라벨 'Model / Nick Name') → P_ITEM_ID
//   Project      → Text + SCM0002_ProjectbyDivisionPopup(§4.6). division cascade(preSearchParams) → P_PROJECT
//   (AS-IS Roslyn 실측: 조회조건 text 컨트롤 = txtCellGroup/txtItemId/txtProject 3개뿐. txtNickName 컨트롤
//    부재 → 별도 plain Nick Name 필드 미노출, P_NICK_NAME 은 빈값 전송. SCP0100 roslyn JSON controls 근거)
// From/To Site·Plan Date SP 는 SCM_ADM_CMBO_SQL_M 미등록(부록 B-1) → 콤보 아닌 보조 proc(§5.2). 05_register 등록(Task#5).

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// GET SP 응답에서 표준 커서(O_RC1 = key 'o_rc1') 행만 뽑는다(부록 B-3). 상태봉투(O_RESULT_CURSOR)는 무시.
const pickRows = (data: unknown): ComboResponse[] =>
  ((data as { o_rc1?: ComboResponse[] } | undefined)?.o_rc1 ?? []);

// AS-IS SCP0100_Global_PSI_Report.cs 조회조건 패널 — design 02 §5.1 SearchArea 매핑.
//   16조건(>6) → nscm-patterns §6 "접기"(Hook #52). 배치는 AS-IS 좌표 좌→우·상→하(design 01_layout §52) 순.
//   항상 표시 2줄(2026-10-14 사용자 지시): 1행 = AS-IS 순서 1~4(Division*/From Site/Cell Group/Search Mode),
//   2행 = 나머지 필수값(Plan Date*/Period* From~To). 그 뒤 나머지 10조건은 extraConditions(접기)에 AS-IS 순서로.
export const GlobalPsiReportForm = ({ tabId, onSearch, onItemSearch, onProjectSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useGlobalPsiReportStore(s => s.searchCondition);
  const set = useGlobalPsiReportStore(s => s.setSearchCondition);
  // Division 변경 시 그리드 초기화용 — AS-IS ClbDivision_SelectedIndexChanged → ClearDataSource(cs:1769).
  const clearFilters = useGlobalPsiReportStore(s => s.clearFilters);
  const setUnitScaleIndex = useGlobalPsiReportStore(s => s.setUnitScaleIndex);
  const unitScaleIndex = useGlobalPsiReportStore(s => s.unitScaleIndex);
  const openSearchArea = useGlobalPsiReportStore(s => s.openSearchArea);
  // rgrpSearchLevel — SEARCH(idx0)/DETAIL(idx1) 토글. Detail 이면 REPORT 시트 라우팅(design 01 R1~R4).
  const searchMode = useGlobalPsiReportStore(s => s.searchMode);
  const setSearchMode = useGlobalPsiReportStore(s => s.setSearchMode);

  // From/To Site·Plan Date 는 Division 변경 cascade 가 아니다(설계 02 §3, AS-IS GetSiteList/GetPlanDate = load-once,
  //   ClbDivision_SelectedIndexChanged 에서 재호출 없음). div 체크 토글(선택)마다 재조회하면 안 되므로, 이 보조
  //   콤보들은 '조회 시점에 확정된 division'(searchedDivision)으로만 로드한다 — 마운트 1회 + Search 때 갱신.
  //   (사용자 신고 2026-10-15 "div 선택 시 조회 발생" 교정. 메인 그리드는 setFilter 로 별도 조회.)
  const [searchedDivision, setSearchedDivision] = useState(sc.divisionId);
  const handleSearch = () => {
    setSearchedDivision(sc.divisionId);
    onSearch();
  };

  // Division 소스풀(공유콤보) — AS-IS BLUtils.GetDivisionWithoutEE + 40/82 dt 필터를 FE 3중 제외로 재현(§2.7).
  // Division + Plan Type 공유콤보. Plan Type(PlanType1_SCP_ALL)은 전량(DIVISION_ID/PLANDATE 포함)으로 받아
  //   FE 에서 Division+Plan Date 로 필터(아래 planTypeOptions) — 자매 global-psi(SCP0031) 동일 소스/규약.
  const [divisions, planTypesAll] = useTabComboQueries({
    filters: [COMBO.DIVISION, COMBO.PLAN_TYPE],
  });

  // Search Level / Bucket — lookup(SCM_ADM_LOOKUP_MASTER_DETAIL). VALID_YN='Y'+DISPLAY_SEQ 순(§2.6).
  //   Display(LOOKUP.DISPLAY)는 AS-IS layDisplay 숨김(designer.cs:1180)이라 필드 미노출 — 콤보 조회도 제거(sc.display 는 store 기본 GRID 유지).
  //   Plan Type 은 정적 lookup 에서 Division/Plan Date 종속 콤보(COMBO.PLAN_TYPE)로 전환(2026-10-26, SCP0031 패턴).
  const [searchLevelRows, bucketRows] = useTabLookupQueries({
    filters: [LOOKUP.SEARCH_LEVEL, LOOKUP.BUCKET],
  });

  // From/To Site — SP P_SCP0100_GET_SITE (p_site_tpye 로 분기). Division 변경 cascade 아님이나(§3),
  //   division/bucket 을 파라미터로 실어 load — 값이 있어야 조회(enabled). 표준 SEARCH proc(05_register API_M).
  // 필수: filters 는 useMemo 로 참조 고정. useTabProcQuery 가 filters 를 참조비교로 "재조회" 판정하므로
  //   렌더 본문 리터럴을 넘기면 removeQueries→refetch→재렌더 무한 루프가 된다(GlobalPsi 기존 수정과 동일).
  const fromSiteFilters = useMemo(
    () => ({ pSiteTpye: SITE_TYPE.FROM, divisionId: normalizeDivision(searchedDivision), bucket: sc.bucket }),
    [searchedDivision, sc.bucket]
  );
  const fromSiteQuery = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: AUX_SHEET.SITE,
    tabId,
    filters: fromSiteFilters,
    enabled: !!searchedDivision,
  });
  const toSiteFilters = useMemo(
    () => ({ pSiteTpye: SITE_TYPE.TO, divisionId: normalizeDivision(searchedDivision), bucket: sc.bucket }),
    [searchedDivision, sc.bucket]
  );
  const toSiteQuery = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: AUX_SHEET.SITE,
    tabId,
    filters: toSiteFilters,
    enabled: !!searchedDivision,
  });

  // Plan Date — SP P_SCP0100_GET_PLAN_DATE. CODE/NAME 명시(§2.3). division=ALL(기본)에서도 조회한다 —
  //   TO-BE 는 이 Plan Date 로 planStart→Period(from/to)→calendar(피벗 날짜 3단헤더)를 최초 오픈 시 시드하는
  //   사용자 요청 옵션이 있어 ALL 에서도 로드가 필수다(AS-IS cs:592 는 ALL 시 미조회지만, TO-BE 피벗-온-오픈 요건
  //   이 우선 — ALL 에서 끊으면 fromYyyymmdd 미시드로 피벗 날짜가 안 뜸). Division 변경 cascade 아님(§3) —
  //   searchedDivision(조회 확정분) 기준(div 선택 토글에 재조회 금지).
  const planDateFilters = useMemo(
    () => ({ divisionId: normalizeDivision(searchedDivision), bucket: sc.bucket, programId: PLAN_DATE_PROGRAM_ID }),
    [searchedDivision, sc.bucket]
  );
  const planDateQuery = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: AUX_SHEET.PLAN_DATE,
    tabId,
    filters: planDateFilters,
    // ALL(기본)에서도 로드 — 위 주석대로 피벗-온-오픈 시드에 필요(normalizeDivision 가드 금지: ALL→''→체인 끊김).
    enabled: !!searchedDivision,
  });

  // 권한 division 선택지(3중 제외 EE/'40'/'82' — 셀 단위 division 만, 부록 B-2). ALL 항목 제외한 실목록.
  const realDivisionOptions = useMemo<Option[]>(() => {
    const excluded = new Set(DIVISION_EXCLUDE_CODES as readonly string[]);
    return toOptions(
      (divisions ?? []).filter(
        r => str(r.ATTRIBUTE3) !== DIVISION_EE_EXCLUDE && !excluded.has(str(r.CODE))
      )
    );
  }, [divisions]);
  // 다중 체크콤보 전환(2026-10-15) — 전체선택 'ALL' 항목은 CustomDropdown allOption 이 자동 추가하므로
  //   별도 ALL 선두항목(divisionOptions) 불필요. 옵션은 realDivisionOptions(3중 제외분) 그대로 쓴다.

  const fromSiteOptions = toOptions(pickRows(fromSiteQuery.data));
  const toSiteOptions = toOptions(pickRows(toSiteQuery.data));
  const planDateOptions = toOptions(pickRows(planDateQuery.data));
  const searchLevelOptions = toOptions(searchLevelRows as ComboResponse[] | undefined);
  // Plan Type — AS-IS SCP0031 RefreshPlanType 등가: 전량 콤보(PlanType1_SCP_ALL)를 Division + Plan Date 로 필터해
  //   그 조합에 실존하는 plan type 만 노출(CODE=NAME 이라 CODE 표시). SCP0100 Division 은 다중/ALL 이라 선택 집합
  //   (ALL=권한 전체 허용)에 속한 DIVISION_ID + 선택 Plan Date(PLANDATE) 행을 모아 CODE 중복 제거 후 PLAN_TYPE_ORDER 순 정렬.
  const planTypeOptions = useMemo<Option[]>(() => {
    const selected =
      sc.divisionId && sc.divisionId !== DIVISION_ALL
        ? new Set(
            sc.divisionId
              .split(',')
              .map(s => s.trim())
              .filter(Boolean)
          )
        : null; // null = ALL(전체) — 권한 division 전부 허용
    const seen = new Map<string, number>(); // CODE → PLAN_TYPE_ORDER(최소)
    for (const r of planTypesAll ?? []) {
      if (selected && !selected.has(str(r[CASCADE_COL.DIVISION_ID]))) continue;
      if (sc.planStartYyyymmdd && str(r[CASCADE_COL.PLANDATE]) !== sc.planStartYyyymmdd) continue;
      const code = str(r.CODE);
      if (!code) continue;
      const order = Number(str(r[CASCADE_COL.PLAN_TYPE_ORDER])) || 0;
      if (!seen.has(code) || order < (seen.get(code) as number)) seen.set(code, order);
    }
    return [...seen.entries()]
      .sort((a, b) => a[1] - b[1])
      .map(([code]) => ({ label: code, value: code }));
  }, [planTypesAll, sc.divisionId, sc.planStartYyyymmdd]);
  // Bucket — AS-IS GetBucketType("CODE='DAILY'")(cs:603) = lookup BUCKET_TYPE_CODE 에서 DAILY 제거.
  //   내용·순서(DISPLAY_SEQ → Weekly, Monthly)·라벨(SEGMENT2) 전부 AS-IS 와 동일하게 lookup 구동(정적 하드코딩 제거).
  const bucketOptions = toOptions(bucketRows as ComboResponse[] | undefined).filter(
    o => o.value !== BUCKET_CODE.DAILY
  );

  // 권한 Division 0 방어 (design 01 A1) — 공유콤보 로드 완료(divisions !== undefined) 후 제외필터 결과가
  //   0건이면 사업부 권한 없음. 부록 B-6 실측상 SCP0100 은 2행 등록으로 실발동 안 하나(저위험) 방어적 배선.
  //   ShipmentSemiDeptDayForm noDivisionAuth 선례 동형. 1회만 alert(alertedRef 가드) + 콤보 disable.
  const setAlert = useMessageStore.getState().setAlert;
  const alertedRef = useRef(false);
  const noDivisionAuth = divisions !== undefined && realDivisionOptions.length === 0;
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

  // Division 기본값 = ALL(store makeInitSearch) — AS-IS 전체선택 기본. 특정 division 미강제(강제 첫선택 제거).
  //   ALL 은 항상 유효 옵션이라 기존 "현재값이 옵션에 없으면 첫 옵션" 교정 useEffect 불필요.

  // Plan Date 기본값 — 목록 첫 항목(design 02 §4.2 OnShown setListBox index0 재바인딩). 단일 콤보.
  const firstPlanDate = planDateOptions[0]?.value ?? '';
  const hasPlanDate = planDateOptions.some(o => o.value === sc.planStartYyyymmdd);
  useEffect(() => {
    if (firstPlanDate && !hasPlanDate) set({ planStartYyyymmdd: firstPlanDate });
  }, [firstPlanDate, hasPlanDate, set]);

  // Plan Type 기본값 — Division+Plan Date 로 좁힌 planTypeOptions 의 첫 항목(자매 global-psi 규약). parent-ready
  //   게이트: Plan Date 확정 후에만 세팅(아직 안 좁혀진 전체 union 의 첫 항목으로 굳는 것 방지). 현재값이 목록에
  //   없을 때만 교정 → 무한루프 방지 + F10 리셋(planType='')에서 재도출. AS-IS 는 마지막 항목이나 global-psi 와
  //   동일하게 첫 항목 기본(사용자 지시). PLAN_TYPE 이 더 이상 FN 고정 아님.
  const firstPlanType = planTypeOptions[0]?.value ?? '';
  const hasPlanType = planTypeOptions.some(o => o.value === sc.planType);
  useEffect(() => {
    if (!sc.planStartYyyymmdd) return; // parent-ready: Plan Date 확정 후
    if (firstPlanType && !hasPlanType) set({ planType: firstPlanType });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [firstPlanType, hasPlanType, sc.planStartYyyymmdd]);

  // 조회기간(Period) 기본값 — AS-IS SetCalendar()→GetDayRange() MONTH 분기(cs:600,1317~1320,1409~1422):
  //   시작일 = Plan Date 월 1일(plan_YYYYMM + "01"), 종료일 = GetPlanEndDate()(PLAN_END_DATE_REPORT 콤보
  //   — division '81' + planName=plan_start + 'WEEKLY' → HORIZON_END_DATE). AS-IS 는 InitControls 및
  //   CboPlanDate 변경(cs:1788)마다 SetCalendar 재실행하므로, planStart 확정/변경 시마다 기간을 재시드한다.
  //   종료일 조회 실패(0행·오류)는 AS-IS GetPlanEndDate try/catch 와 동일 — 시작일만 세팅하고 넘어간다.
  const planStart = sc.planStartYyyymmdd;
  useEffect(() => {
    const ym = planStart.replace(/\D/g, '').slice(0, 6);
    if (ym.length < 6) return;
    const start = `${ym}01`;
    let cancelled = false;
    void apiClient
      .getCombo({
        comboId: PLAN_END_DATE_COMBO_ID,
        divisionId: PLAN_END_DATE_DIVISION,
        planName: planStart,
        planCycle: PLAN_END_DATE_PLAN_CYCLE,
      })
      .then(rows => {
        if (cancelled) return;
        const end = str(rows?.[0]?.[PLAN_END_DATE_COL]).replace(/\D/g, '');
        set(end ? { fromYyyymmdd: start, toYyyymmdd: end } : { fromYyyymmdd: start });
      })
      .catch(() => {
        if (!cancelled) set({ fromYyyymmdd: start });
      });
    return () => {
      cancelled = true;
    };
  }, [planStart, set]);

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

  // 라디오 그룹 렌더 헬퍼 — AS-IS rgrpSearchLevel(RadioGroup) 원형 재현. 공용 @shared/lges RadioGroup/Radio 사용.
  //   value = 선택 코드, options = {label,value} 2지선다(가로 배치 row).
  const radio = (
    labelText: string,
    value: string,
    options: readonly Option[],
    onPick: (code: string) => void,
    required?: boolean
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={labelText}
        labelAlign='right'
        required={required}
        render={() => (
          <RadioGroup
            row
            className={styles.searchModeRadios}
            value={value}
            onChange={(_, v) => onPick(String(v ?? ''))}
          >
            {options.map(o => (
              <Radio key={o.value} value={o.value} labelText={o.label} />
            ))}
          </RadioGroup>
        )}
      />
    </Grid>
  );

  // multi-select 콤보 — AS-IS clbFromSite/clbToSite 는 CheckedListBox(다중). 값은 콤마구분 string(§2.2).
  const multi = (
    labelText: string,
    value: string,
    options: Option[],
    onPick: (codes: string) => void,
    required?: boolean
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
            onChange={(_, picked) => onPick(String(picked ?? ''))}
          />
        )}
      />
    </Grid>
  );

  // 팝업버튼 부착 텍스트 필드 — Model / Nick Name(=txtItemId) / Project(SCM0002 팝업이 채움, design 02 §4.6).
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
                  iconComponent={<FunctionSearchIcon appearance='lined' />}
                  onClick={onPopup}
                />
              ),
            }}
            onChange={e => onChange(e.target.value)}
            onKeyDown={e => e.key === 'Enter' && handleSearch()}
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
            onKeyDown={e => e.key === 'Enter' && handleSearch()}
          />
        )}
      />
    </Grid>
  );

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, 'Search')}
      isHidden={!openSearchArea}
      onSearch={handleSearch}
      conditions={
        <>
          {/* 항상 표시 2줄(한 줄 4개, 2026-10-14 사용자 지시) — 1행: Division* / From Site / Cell Group / Search Mode,
              2행: Project / Bucket / Period* / Plan Date*. 그 뒤 나머지 8조건은 extraConditions(접기). */}
          {/* --- 1행: Division / From Site / Cell Group / Search Mode --- */}
          {/* Division* — AS-IS clbDivision = CheckedList 다중(설계 02 §2.1·체크리스트 §1 #16). 단일 콤보에서
              다중 체크콤보로 전환(2026-10-15, SCP0100.md 조회조건 #1 유형 '선택/다중'). 값 = 선택 코드 CSV
              (allOption 'ALL' 센티널은 normalizeDivision 이 ''=전체로 정규화). 메인 SP P_DIVISION_ID 는
              FN_SPLITSTRING 다건, cascade(GET_SITE/GET_PLAN_DATE)도 CSV 지원(DB 실측). 컬럼/measure 메타는
              전부 공통(DIVISION_ID NULL)이라 다중이어도 store 가 '' 공통 메타로 fetch.
              주의: 단일 때의 '변경 시 조건 초기화'(setDivision)는 다중 토글마다 리셋되면 안 되므로 제거하고
              plain set 으로 둔다 — From/To Site·Plan Date 는 sc.divisionId 종속 cascade 로 자동 재조회된다. */}
          {multi(
            t(LBL.DIVISION, 'Div.'),
            sc.divisionId,
            realDivisionOptions,
            // 그리드만 초기화(ClearDataSource 등가, 조건 리셋 아님) — 재조회(Search) 전까지 빈 상태.
            v => {
              set({ divisionId: v });
              clearFilters();
            },
            true
          )}
          {multi(
            t(LBL.FROM_SITE, 'From Site'),
            sc.fromSite,
            fromSiteOptions,
            v => set({ fromSite: v })
          )}
          {textField(
            t(LBL.CELL_GROUP, 'Cell Group'),
            sc.cellGroup,
            v => set({ cellGroup: v })
          )}
          {/* rgrpSearchLevel(design 01 R1~R4) — SEARCH(idx0)/DETAIL(idx1). AS-IS 라디오그룹 원형 재현.
              'Search Mode' 라벨 재표시(사용자 지시 2026-10-23). 라디오 2개는 RadioGroup nowrap+gap 로 가로 한 줄 유지. LBL 미등록이라 리터럴. */}
          {radio(
            t('', 'Search Mode'),
            searchMode,
            SEARCH_MODE_OPTIONS as unknown as Option[],
            v => setSearchMode((v || SEARCH_MODE.SEARCH) as typeof searchMode)
          )}
          {/* --- 2행: Project / Bucket / Period* / Plan Date* (2026-10-14 사용자 지시 순서) — 항상 표시 --- */}
          {popupField(
            t(LBL.PROJECT, 'Project'),
            sc.project,
            v => set({ project: v }),
            onProjectSearch
          )}
          {single(
            t(LBL.BUCKET, 'Bucket'),
            sc.bucket,
            bucketOptions,
            // Bucket 변경 = AS-IS CboBucketType_SelectedIndexChanged(cs:1798~1813) → SetSpreadColumn + FindData
            //   즉시 재조회. 값만 바꾸면 M_/W_ 컬럼 가시성은 토글되나(buildPivotColumns) 데이터 SP
            //   (dispatcher MONTHLY→_MM_DATAONLY / WEEKLY→_WW_DATAONLY, P_BUCKET)는 재호출되지 않아
            //   전환한 bucket 의 pivot 값이 비어 보인다(2026-10-15 사용자 신고 "재조회는 되는듯한데 파라미터 미반영").
            //   값 설정은 동기(zustand)라 직후 onSearch 의 setFilter 가 새 bucket 을 P_BUCKET 으로 싣는다.
            //   AS-IS 는 화면 오픈 시 자동조회로 _SI 가 세팅돼 있어 조회 전에도 Bucket 변경이 즉시 재조회된다
            //   (cs:1800 `if(_SI != null)` 가 항상 통과) → TO-BE 도 무조건 재조회로 맞춘다.
            v => {
              set({ bucket: v });
              handleSearch();
            }
          )}
          {/* Period*(조회기간 From~To) — AS-IS dCalendar(UsrDateRangePicker3) → 공용 PeriodRangePicker.
              값 계약 YYYYMMDD(sc.fromYyyymmdd/toYyyymmdd 그대로). allowTextInput 으로 AS-IS txtStart/txtEnd
              키인 복원. 기본값(시작=Plan월1일/종료=PLAN_END_DATE)은 위 조회기간 useEffect 가 시드. Grid 1칸. */}
          <Grid size={3}>
            <PeriodRangePicker
              className={commonStyles.formItem}
              label='Period'
              required
              allowTextInput
              start={sc.fromYyyymmdd}
              end={sc.toYyyymmdd}
              onChange={(from, to) => set({ fromYyyymmdd: from, toYyyymmdd: to })}
            />
          </Grid>
          {single(
            t(LBL.PLAN_DATE, 'Plan Date'),
            sc.planStartYyyymmdd,
            planDateOptions,
            // Plan Date 변경 = 조회기간 재시드(위 useEffect, AS-IS SetCalendar cs:1788) + 하위 캘린더/스프레드 파생(§3).
            //   추가: 그리드 데이터 초기화(사용자 지시 2026-10-23) — 재조회(Search) 전까지 빈 상태(Division 변경과 동일 관례).
            v => {
              set({ planStartYyyymmdd: v });
              clearFilters();
            },
            true
          )}
        </>
      }
      extraConditions={
        <>
          {/* 그 뒤 나머지(접기). 배치: To Site / Model·Nick Name / Plan Type / Scale / Search Level / Cell Qty·A/S
              (Search Level ↔ Cell Qty·A/S 자리 교체 2026-10-23). Display 는 숨김(아래 주석). */}
          {multi(
            t(LBL.TO_SITE, 'To Site'),
            sc.toSite,
            toSiteOptions,
            v => set({ toSite: v })
          )}
          {/* AS-IS layModel 라벨 = 'Model / Nick Name'(txtItemId + btnItemId → SCM0002_ItembyDivisionPopup).
              txtNickName 컨트롤 없음 — 별도 plain Nick Name 필드 미노출. LBL 미등록(기존 LBL00021 'Material' 오배선)이라 리터럴. */}
          {popupField(
            t('', 'Model / Nick Name'),
            sc.itemId,
            v => set({ itemId: v }),
            onItemSearch
          )}
          {single(
            t(LBL.PLAN_TYPE, 'Plan Type'),
            sc.planType,
            planTypeOptions,
            v => set({ planType: v })
          )}
          {single(
            t(LBL.SCALE, 'Scale'),
            String(unitScaleIndex),
            UNIT_QTY_OPTIONS as unknown as Option[],
            // Unit(Qty) = 로컬 표시배율(§2.5) — 서버 재조회 없이 그리드 클라 나눗셈. index 저장만.
            v => setUnitScaleIndex(Number(v) || 0)
          )}
          {single(
            t(LBL.SEARCH_LEVEL, 'Search Level'),
            sc.searchLevel,
            searchLevelOptions,
            // Search Level = 활성 그리드 시트 결정(design 01 R1~R3). AS-IS CboSearchLevel_SelectedIndexChanged
            //   (cs:1859 if(isLoadFinish) FindData())처럼 변경 즉시 재조회 — Bucket 과 동일 패턴.
            v => {
              set({ searchLevel: v });
              handleSearch();
            },
            false,
            // R4 — Detail 모드에서는 REPORT 시트 고정이라 Search Level 선택을 잠근다(design 01).
            searchMode === SEARCH_MODE.DETAIL
          )}
          {/* Cell Qty + A/S — 두 체크박스를 한 셀에 나란히 배치. Search Level 과 자리 교체 + 좌측 패딩 제거(2026-10-23).
              각 체크박스 labelText 로 'Cell Qty ☐  A/S ☐' 묶음(customCheckbox = flex gap:4px).
              A/S 라벨 DB 신규 LBL01167, 미싱크 시 fallback 'A/S'. */}
          <Grid size={3} className={commonStyles.customGrid}>
            <FormItem
              className={commonStyles.formItem}
              label=''
              labelAlign='right'
              render={() => (
                <div className={commonStyles.customCheckbox}>
                  <Checkbox
                    labelText={t(LBL.CELL_QTY, 'Cell Qty')}
                    checked={sc.chkCellQty}
                    onChange={checked => set({ chkCellQty: checked })}
                  />
                  <Checkbox
                    labelText={t(LBL.AS, 'A/S')}
                    checked={sc.chkAs}
                    onChange={checked => set({ chkAs: checked })}
                  />
                </div>
              )}
            />
          </Grid>
          {/* Display(cboDisplay) 는 AS-IS designer layDisplay.Visibility=Never(designer.cs:1180)로 숨김 — 조회조건에
              미노출(2026-10-15 사용자 지시). 값(sc.display)은 store 기본 GRID(SelectedIndex=2) 그대로 유지돼
              GlobalPsiReportModals 등 하위 로직은 AS-IS 기본값으로 동작한다(UI 필드만 제거). */}
        </>
      }
    />
  );
};
