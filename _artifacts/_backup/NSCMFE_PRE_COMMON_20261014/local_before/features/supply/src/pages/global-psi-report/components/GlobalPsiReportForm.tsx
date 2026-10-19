import { useEffect, useMemo, useRef } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries, useTabProcQuery } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

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
  SEARCH_MODE,
  SEARCH_MODE_OPTIONS,
  SITE_TYPE,
  UNIT_QTY_OPTIONS,
} from '../global-psi-report.constants';
import { useGlobalPsiReportStore } from '../useGlobalPsiReportStore';

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
//   Display      → useTabLookupQueries('STOCK_TREND_DISPLAY') — 뷰 전환(로컬). 기본 GRID(§2.6)
//   Search Level → useTabLookupQueries('PRODUCT_LEVEL') — idx0=CELL_GROUP(§2.6)
//   Plan Type    → useTabLookupQueries('PLAN_TYPE') — 기본 'FN'(§2.6). AS-IS 자동재조회 NO-OP(§3)
//   Unit(Qty)    → 정적 select(로컬 표시배율 0/1e3/1e6/1e8). 서버 재조회 없음(§2.5)
//   Graph Type   → AS-IS NO-OP(§3, 본문 공백) — 미배선(design 01 §2). LBL 미등록(부록 B-5)
//   AS / Cell Qty→ 체크박스(P_CHK_AS/P_CHK_CELL_QTY). AS-IS NO-OP(§3) — 조회 파라미터로만 반영
//   Cell Group   → Text 입력(P_CELL_GROUP)
//   Item ID/Proj → Text + SCM0002 팝업(§4.6). division 파라미터 cascade(preSearchParams)
// From/To Site·Plan Date SP 는 SCM_ADM_CMBO_SQL_M 미등록(부록 B-1) → 콤보 아닌 보조 proc(§5.2). 05_register 등록(Task#5).

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// GET SP 응답에서 표준 커서(O_RC1 = key 'o_rc1') 행만 뽑는다(부록 B-3). 상태봉투(O_RESULT_CURSOR)는 무시.
const pickRows = (data: unknown): ComboResponse[] =>
  ((data as { o_rc1?: ComboResponse[] } | undefined)?.o_rc1 ?? []);

// AS-IS SCP0100_Global_PSI_Report.cs 조회조건 패널 — design 02 §5.1 SearchArea 매핑.
//   16조건(>6) → nscm-patterns §6 "2줄+ 접기": 메인 6조건(Division/FromSite/ToSite/PlanDate/Bucket/기간),
//   나머지는 extraConditions 로 3단째부터 접는다(Hook #52 search-area-extra-conditions).
export const GlobalPsiReportForm = ({ tabId, onSearch, onItemSearch, onProjectSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useGlobalPsiReportStore(s => s.searchCondition);
  const set = useGlobalPsiReportStore(s => s.setSearchCondition);
  const setDivision = useGlobalPsiReportStore(s => s.setDivision);
  const setUnitScaleIndex = useGlobalPsiReportStore(s => s.setUnitScaleIndex);
  const unitScaleIndex = useGlobalPsiReportStore(s => s.unitScaleIndex);
  const openSearchArea = useGlobalPsiReportStore(s => s.openSearchArea);
  // rgrpSearchLevel — SEARCH(idx0)/DETAIL(idx1) 토글. Detail 이면 REPORT 시트 라우팅(design 01 R1~R4).
  const searchMode = useGlobalPsiReportStore(s => s.searchMode);
  const setSearchMode = useGlobalPsiReportStore(s => s.setSearchMode);

  // Division 소스풀(공유콤보) — AS-IS BLUtils.GetDivisionWithoutEE + 40/82 dt 필터를 FE 3중 제외로 재현(§2.7).
  const [divisions] = useTabComboQueries({ filters: [COMBO.DIVISION] });

  // Display / Search Level / Plan Type — lookup(SCM_ADM_LOOKUP_MASTER_DETAIL). VALID_YN='Y'+DISPLAY_SEQ 순(§2.6).
  const [displayRows, searchLevelRows, planTypeRows] = useTabLookupQueries({
    filters: [LOOKUP.DISPLAY, LOOKUP.SEARCH_LEVEL, LOOKUP.PLAN_TYPE],
  });

  // From/To Site — SP P_SCP0100_GET_SITE (p_site_tpye 로 분기). Division 변경 cascade 아님이나(§3),
  //   division/bucket 을 파라미터로 실어 load — 값이 있어야 조회(enabled). 표준 SEARCH proc(05_register API_M).
  const fromSiteQuery = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: AUX_SHEET.SITE,
    tabId,
    filters: { pSiteTpye: SITE_TYPE.FROM, divisionId: sc.divisionId, bucket: sc.bucket },
    enabled: !!sc.divisionId,
  });
  const toSiteQuery = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: AUX_SHEET.SITE,
    tabId,
    filters: { pSiteTpye: SITE_TYPE.TO, divisionId: sc.divisionId, bucket: sc.bucket },
    enabled: !!sc.divisionId,
  });

  // Plan Date — SP P_SCP0100_GET_PLAN_DATE. division 미선택/ALL 이면 미조회(§4.3 cs:592). CODE/NAME 명시(§2.3).
  const planDateQuery = useTabProcQuery({
    menuId: MENU_ID,
    sheetName: AUX_SHEET.PLAN_DATE,
    tabId,
    filters: {
      divisionId: sc.divisionId,
      bucket: sc.bucket,
      programId: PLAN_DATE_PROGRAM_ID,
    },
    enabled: !!sc.divisionId,
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
  const displayOptions = toOptions(displayRows as ComboResponse[] | undefined);
  const searchLevelOptions = toOptions(searchLevelRows as ComboResponse[] | undefined);
  const planTypeOptions = toOptions(planTypeRows as ComboResponse[] | undefined);
  const bucketOptions: Option[] = [
    { label: t(LBL.MONTHLY, 'Monthly'), value: BUCKET_CODE.MONTHLY },
    { label: t(LBL.WEEKLY, 'Weekly'), value: BUCKET_CODE.WEEKLY },
  ];

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

  // Division 기본값 교정 — 현재 값이 옵션에 없으면 첫 옵션(권한 division 근사, IntegrationPsi §4.3 선례 동일).
  const firstDivision = divisionOptions[0]?.value ?? '';
  const hasDivision = divisionOptions.some(o => o.value === sc.divisionId);
  useEffect(() => {
    if (firstDivision && !hasDivision) setDivision(firstDivision);
  }, [firstDivision, hasDivision, setDivision]);

  // Plan Date 기본값 — 목록 첫 항목(design 02 §4.2 OnShown setListBox index0 재바인딩). 단일 콤보.
  const firstPlanDate = planDateOptions[0]?.value ?? '';
  const hasPlanDate = planDateOptions.some(o => o.value === sc.planStartYyyymmdd);
  useEffect(() => {
    if (firstPlanDate && !hasPlanDate) set({ planStartYyyymmdd: firstPlanDate });
  }, [firstPlanDate, hasPlanDate, set]);

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

  // multi-select 콤보 — AS-IS clbFromSite/clbToSite 는 CheckedListBox(다중). 값은 콤마구분 string(§2.2).
  const multi = (
    labelText: string,
    value: string,
    options: Option[],
    onPick: (codes: string) => void
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={labelText}
        labelAlign='right'
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

  // 팝업버튼 부착 텍스트 필드 — Item ID / Project(SCM0002 팝업이 채움, design 02 §4.6).
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
          {/* Row0 — Division* / From Site / To Site / Plan Date* */}
          {single(
            t(LBL.DIVISION, 'Div.'),
            sc.divisionId,
            divisionOptions,
            setDivision,
            true
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
            // Plan Date 변경 = 하위 캘린더/스프레드 파생(§3 cs:1784) — 조회는 명시 Search 게이트에서 재발사.
            v => set({ planStartYyyymmdd: v }),
            true
          )}

          {/* Row1 — Bucket / 조회 기간(From~To YYYYMMDD) */}
          {single(
            t(LBL.BUCKET, 'Bucket'),
            sc.bucket,
            bucketOptions,
            // Bucket 변경 = M_/W_ pivot visible 토글(design 03 §2.5) + AS-IS 자동조회 — 명시 Search 로 재현.
            v => set({ bucket: v })
          )}
          {/* 확인필요: 조회기간 From — 'From' 단독 LBL 미등록(DB 미매칭)이라 리터럴 유지. 기존 PLAN_DATE 오배선 제거. */}
          {textField('From (YYYYMMDD)', sc.fromYyyymmdd, v => set({ fromYyyymmdd: v }))}
          {textField('To (YYYYMMDD)', sc.toYyyymmdd, v => set({ toYyyymmdd: v }))}
        </>
      }
      extraConditions={
        <>
          {/* Row2~ — Search Mode / Unit / Display / Search Level / Plan Type */}
          {/* rgrpSearchLevel(design 01 R1~R4) — SEARCH(idx0)/DETAIL(idx1). Detail 이면 REPORT 시트 라우팅 +
              cboSearchLevel disable(R4). AS-IS 라디오그룹을 shared RadioGroup 부재로 CustomDropdown 로 대체. */}
          {/* 확인필요: 'Search Mode' LBL 미등록(DB 미매칭 — TO-BE 합성 라벨)이라 리터럴 유지. */}
          {single(
            t('', 'Search Mode'),
            searchMode,
            SEARCH_MODE_OPTIONS as unknown as Option[],
            v => setSearchMode((v || SEARCH_MODE.SEARCH) as typeof searchMode)
          )}
          {single(
            t(LBL.UNIT_QTY, 'Unit (Qty)'),
            String(unitScaleIndex),
            UNIT_QTY_OPTIONS as unknown as Option[],
            // Unit(Qty) = 로컬 표시배율(§2.5) — 서버 재조회 없이 그리드 클라 나눗셈. index 저장만.
            v => setUnitScaleIndex(Number(v) || 0)
          )}
          {single(
            t(LBL.DISPLAY, 'Display'),
            sc.display,
            displayOptions,
            // Display = Grid/Chart 뷰 전환(로컬, §2.6) — 레이아웃 비율만 바꾼다(design 01 D1~D4).
            v => set({ display: v })
          )}
          {single(
            t(LBL.SEARCH_LEVEL, 'Search Level'),
            sc.searchLevel,
            searchLevelOptions,
            // Search Level = 활성 그리드 시트 결정(design 01 R1~R3) + AS-IS 자동조회 — 명시 Search 로 재현.
            v => set({ searchLevel: v }),
            false,
            // R4 — Detail 모드에서는 REPORT 시트 고정이라 Search Level 선택을 잠근다(design 01).
            searchMode === SEARCH_MODE.DETAIL
          )}
          {single(
            t(LBL.PLAN_TYPE, 'Plan Type'),
            sc.planType,
            planTypeOptions,
            v => set({ planType: v })
          )}

          {/* Row3~ — Cell Group / Item ID(팝업) / Project(팝업) / Nick Name */}
          {textField(
            t(LBL.CELL_GROUP, 'Cell Group'),
            sc.cellGroup,
            v => set({ cellGroup: v })
          )}
          {/* 확인필요: 'Item ID' LBL 미등록(DB 미매칭 — 기존 LBL00021 은 'Material' 오배선)이라 리터럴 유지. */}
          {popupField(
            t('', 'Item ID'),
            sc.itemId,
            v => set({ itemId: v }),
            onItemSearch
          )}
          {popupField(
            t(LBL.PROJECT, 'Project'),
            sc.project,
            v => set({ project: v }),
            onProjectSearch
          )}
          {textField(t(LBL.NICK_NAME, 'Nick Name'), sc.nickName, v => set({ nickName: v }))}

          {/* Row4~ — AS 포함 / Cell Qty (AS-IS NO-OP §3 — 조회 파라미터로만 반영) */}
          <Grid size={3} className={commonStyles.customGrid}>
            <div className={commonStyles.customCheckbox}>
              {/* 확인필요: 'AS 포함' LBL 미등록(DB 는 'AS'=LBL00685 뿐, '포함' 접미 불일치)이라 리터럴 유지. */}
              <Checkbox
                labelText={t('', 'AS 포함')}
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
