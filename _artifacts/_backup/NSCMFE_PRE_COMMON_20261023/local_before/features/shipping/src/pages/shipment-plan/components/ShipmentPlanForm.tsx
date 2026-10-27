import { PeriodField } from 'features/master/src/components';
import { useEffect, useMemo, useRef } from 'react';

import dayjs from '@foundation/dayjs';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useSessionStore } from '@shared/stores';

import { ALL, BUCKET_TYPE, COMBO, LBL, MENU_ID, SHEETS } from '../shipment-plan.constants';
import { useShipmentPlanStore } from '../useShipmentPlanStore';

interface Props {
  tabId: string;
  onSearch: () => void;
  onItemSearch: () => void; // btnItemId (1차 Model 팝업)
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// yyyymmdd(또는 yyyy-mm-dd) → 'yyyy-mm-dd'. Plan Date 라벨·Period 표시를 AS-IS 와 동일한 대시 포맷으로.
const toDashYmd = (v: string): string => {
  const d = str(v).replace(/-/g, '');
  return d.length === 8 ? `${d.slice(0, 4)}-${d.slice(4, 6)}-${d.slice(6, 8)}` : str(v);
};
// 'yyyy-mm-dd'(또는 yyyymmdd) → 'yyyymmdd'. PeriodField(start/end) 는 YYYYMMDD 8자를 받는다.
const toYmd8 = (v: string): string => str(v).replace(/-/g, '');

// Bucket 콤보 CODE(BUCKET_TYPE_CODE: DAILY/WEEKLY/MONTHLY) → store·그리드가 쓰는 BUCKET_TYPE(D/W/M).
const BUCKET_CODE_TO_TYPE: Record<string, BUCKET_TYPE> = {
  DAILY: BUCKET_TYPE.DAILY,
  WEEKLY: BUCKET_TYPE.WEEKLY,
  MONTHLY: BUCKET_TYPE.MONTHLY,
};

// Plan Date(CODE=yyyymmdd) → Period [from, to]. 둘 다 YYYYMMDD 8자로 돌려준다 —
//   store 의 period/period2 는 전부 8자로 저장한다(SP 파라미터 fromYyyymmdd·PeriodField·clampPeriod2
//   가 모두 YYYYMMDD 네이티브다. 대시로 저장하면 PeriodField 의 toDayjs(s.length!==8)가 오늘로
//   폴백해 상세 Shipment Date 가 오늘에 고정되고, SP 로도 대시가 흘러간다 — 실측 2026-10-02).
//   콤보 Plan_Infor_SCP 의 FROM_DATE/TO_DATE1 은 NLS 버그로 신뢰 불가(FROM_DATE='18-SEP-26',
//   TO_DATE1 이 연도 0018 쓰레기)라 쓰지 않고, 깨끗한 CODE 로 직접 계산한다:
//   from = plan start, to = +14일(AS-IS drpPeriod 구간 동일).
const planPeriodOf = (code: string): { from: string; to: string } => {
  const from = toYmd8(code);
  return {
    from,
    to:
      from.length === 8
        ? dayjs(`${from.slice(0, 4)}-${from.slice(4, 6)}-${from.slice(6, 8)}`)
            .add(14, 'day')
            .format('YYYYMMDD')
        : '',
  };
};

// 콤보 응답 배열에는 null 원소가 섞일 수 있다 — MyBatis 는 '모든 컬럼이 NULL 인 행'을 객체가 아니라
//   null 로 매핑한다. CellGroup_SCP 는 CODE/NAME 이 같은 컬럼(GROUP_CODE1)이라 그 값이 NULL 인 품목이
//   있으면 SELECT DISTINCT 가 전 컬럼 NULL 인 행을 만든다(실측 2026-10-01: 옵션 1065건 중 1건,
//   SCP_MST_FINAL_ITEM 의 GROUP_CODE1 IS NULL 11,421행에서 비롯). 가드 없이 r.NAME 을 읽으면
//   "Cannot read properties of null (reading 'NAME')" 로 화면 전체가 렌더에 실패한다(사용자 신고 2026-10-01).
const toOptions = (
  rows: ({ CODE?: unknown; NAME?: unknown } | null)[] | undefined
): Option[] =>
  (rows ?? [])
    .filter((r): r is { CODE?: unknown; NAME?: unknown } => r != null)
    // 빈 CODE('') 행 제외 — CellGroup_SCP 의 GROUP_CODE1 IS NULL 행은 BE 가 전 컬럼 null 을 안 담아
    //   {} 로 와서 위 null 가드를 통과한다. 그대로 두면 value='' 옵션이 되어 다중선택의 allOption(값 '')과
    //   충돌해 Product Level1 등이 오동작한다(사용자 신고 2026-10-02). 코드가 비면 옵션에서 뺀다.
    .filter(r => str(r.CODE) !== '')
    .map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// 1차 조회조건 (usrLayoutControl2 — design 01 §1 / 02 §1):
//   1단: Division* / Company* / From Site(다중) / Bucket
//   2단: Plan Date* / Period(표시전용) / Model(txtItemId+btnItemId) / Product Level1(clbProductLevel11)
//   3단(extraConditions — hook #52 2단 초과 접기): Sum / Tot PSI 체크박스
//   Division/Company = 전용 SP 2-cursor(P_SSP0060_GET_SHIPMENT_DIVISION — 콤보 레지스트리 아님, 02 §2-A),
//   Company 는 O_RC2 를 선택 Division 으로 클라 필터(AS-IS LINQ L528-531 등가 — SP 결과에 DIVISION_ID 포함 실측).
export const ShipmentPlanForm = ({ tabId, onSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();
  const session = useSessionStore(s => s.session);

  const sc = useShipmentPlanStore(s => s.searchCondition);
  const set = useShipmentPlanStore(s => s.setSearchCondition);
  const setDivision = useShipmentPlanStore(s => s.setDivision);
  const setCompany = useShipmentPlanStore(s => s.setCompany);
  const setPlanDate = useShipmentPlanStore(s => s.setPlanDate);
  const openSearchArea = useShipmentPlanStore(s => s.openSearchArea);

  // Division/Company — 화면 mount 시 1회 조회(Form_Load SetChangedControl 재현, 02 §4.1-1).
  //   진입 자동 "Main 조회"는 금지 게이트 유지(np §5-7) — 콤보 공급용 전용 SP 만 발사한다.
  const divisionFilters = useMemo(
    () => ({ param1: session.groupId ?? '', param2: session.userId ?? '' }),
    [session.groupId, session.userId]
  );
  const { data: divisionData } = useTabProcQuery<MENU_ID, SHEETS.DIVISION>({
    menuId: MENU_ID,
    sheetName: SHEETS.DIVISION,
    tabId,
    filters: divisionFilters,
    enabled: !!session.userId,
  });
  const divisionOptions = useMemo(() => toOptions(divisionData?.o_rc1), [divisionData]);
  // Company = O_RC2 전체를 선택 Division 으로 클라 필터 (AS-IS dtCompany LINQ 등가).
  //   주의: GetNERPCode ×4 재필터 경로(02 §2-B)는 PKG_SSP0002 미배포 — 구현 보류.
  //   goal.md 백로그 참조: convert-sp 또는 대체 SQL_ID 등록(사용자 확인) 후 이 필터에 ERP 코드 축 추가.
  const companyOptions = useMemo(
    () =>
      toOptions(
        (divisionData?.o_rc2 ?? []).filter(r => !sc.divisionId || str(r.DIVISION_ID) === sc.divisionId)
      ),
    [divisionData, sc.divisionId]
  );

  // cascade 재조회 콤보 3종 (02 §2-C — 전량 재조회 방식, 응답에 클라 축 필터 금지):
  //   FromSite(@divisionId @companyId) / PlanDate(@companyId) / Bucket.
  //   Bucket = 'BucketType' 재사용 — AS-IS 동일 SP(DM0003_GET_BUCKET_TYPE_CODE) 원천(DMF0021 §1 실측, core §2.6 의미 일치).
  const [fromSites, planDates, bucketRows] = useTabComboQueries({
    filters: [
      { comboId: COMBO.FROM_SITE, mnuId: MENU_ID, divisionId: sc.divisionId, companyId: sc.companyId },
      { comboId: COMBO.PLAN_INFOR, mnuId: MENU_ID, companyId: sc.companyId },
      'BucketType',
    ],
  });

  // Product Level1 (CellGroup_SCP) — division 이 확정된 뒤에만 조회한다(AS-IS 는 clbCompanyID 변경
  //   이벤트에서만 clbProductLevel11/12 를 바인딩 — division/company 가 정해진 뒤에만 채운다, cs L7258).
  //   divisionId 가 비면 콤보 SQL 의 '@divisionId IS NULL' 이 TRUE 가 돼(Oracle 은 ''=NULL) 전 division
  //   품목 1064건이 쏟아진다(DB 실측 2026-10-02: div 81_UC = 3건 vs 미전달 = 1064건, AS-IS 동일 쿼리·데이터).
  //   enabled 게이트로 미선택 조회 자체를 막아, 선택된 division 의 셋(AS-IS 와 동일 3건)만 받는다.
  //   (사용자 신고 2026-10-02: "ASIS 3개 vs 현재 많이 — Change Event 바인딩 문제" → division 게이트가 그 Change Event 등가.)
  const [cellGroups] = useTabComboQueries({
    filters: [{ comboId: COMBO.CELL_GROUP, mnuId: MENU_ID, divisionId: sc.divisionId }],
    enabled: !!sc.divisionId,
  });

  const fromSiteOptions = toOptions(fromSites);
  const productLevelOptions = toOptions(cellGroups);
  // Plan Date 라벨 = yyyy-mm-dd (AS-IS drpPeriod 표기 동일). CODE(yyyymmdd)로 포맷 — 콤보 NAME 은 NLS 의존.
  const planDateOptions: Option[] = (planDates ?? [])
    .filter((r): r is NonNullable<typeof r> => r != null)
    .map(r => ({ label: toDashYmd(str(r.CODE)), value: str(r.CODE) }));
  // Bucket — 콤보(BUCKET_TYPE_CODE)는 CODE 가 'DAILY/WEEKLY/MONTHLY' 풀워드지만, store 기본값·그리드
  //   표시로직(isDynVisible)은 D/W/M(BUCKET_TYPE)을 쓴다. value 를 D/W/M 로 매핑해 기본값 'D'(=첫 항목 Daily)가
  //   매칭되게 한다(미매핑 시 콤보 빈 표시 + 컬럼 토글 오작동 — 실측 2026-10-02). 라벨은 NAME(Daily 등) 유지.
  const bucketOptions: Option[] =
    bucketRows && bucketRows.length > 0
      ? bucketRows
          .filter((r): r is NonNullable<typeof r> => r != null)
          .map(r => ({
            label: str(r.NAME) || str(r.CODE),
            value: (BUCKET_CODE_TO_TYPE[str(r.CODE)] ?? str(r.CODE)) as string,
          }))
      : [
          { label: 'Daily', value: BUCKET_TYPE.DAILY },
          { label: 'Weekly', value: BUCKET_TYPE.WEEKLY },
          { label: 'Monthly', value: BUCKET_TYPE.MONTHLY },
        ];

  // Division 기본값 — 최초 로드 시 첫 번째 division 자동 선택(사용자 결정 2026-10-02).
  //   미선택 상태에서 Company 가 전 division 회사(ESWA+ESUC 등)를 다 보여주던 문제 해소:
  //   첫 division 을 잡으면 setDivision cascade 로 Company 가 그 division 기준으로 필터된다
  //   (이어서 아래 companyDefaulted → PlanDate 기본값까지 1회 cascade). Search 는 여전히 수동.
  const divisionDefaulted = useRef(false);
  useEffect(() => {
    if (divisionDefaulted.current) return;
    if (sc.divisionId || divisionOptions.length === 0) return;
    divisionDefaulted.current = true;
    setDivision(divisionOptions[0].value);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId, divisionOptions]);

  // Company 기본값 — AS-IS 는 세션 사용자 Company 이름(sUserCompany_NM, SSP InnerTable MyCompanyID)
  //   FindString 매칭 후 실패 시 index0(02 §4.1-3). TO-BE 세션(UserSession)에 company 필드가 없어
  //   (실측 — groupId/langCd/userId/div 뿐) 매칭 원천이 없으므로 **첫 행 선택만 재현**한다.
  //   사용자 회사 매칭 재현 수단(세션 확장 또는 MyCompanyID 콤보 등록)은 확인필요(사용자 축,
  //   gap-audit I7 — 04_react-gap.md). 이 대입이 cascade 최초 1회 자동 실행을 유발한다(Form_Load parity).
  //   Company 가 비어 있고 옵션이 있으면 항상 첫 행(=옵션 1개면 그 1개)을 자동 선택한다. 1회성(ref) 아님 —
  //   division 을 바꾸면 setDivision 이 company 를 비우므로, 바뀐 division 의 회사(단일이면 그 1개)가
  //   매번 자동 선택돼야 한다(사용자 요청 2026-10-02: "콤보 1개면 바로 선택"). 선택 후엔 sc.companyId 가
  //   채워져 early-return — 루프 없음.
  useEffect(() => {
    if (!sc.divisionId || sc.companyId || companyOptions.length === 0) return;
    setCompany(companyOptions[0].value);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId, sc.companyId, companyOptions]);

  // PlanDate 기본값 — 재조회 결과 index0(최신 Plan) 강제 선택 → realFlag=true (AS-IS L7226~7268).
  //   재바인딩 무한루프 방지: planDate 가 비었을 때만 1회 대입(이펙트 dep 게이트 = AS-IS detach/attach 등가).
  useEffect(() => {
    if (!sc.companyId || sc.planDate || !planDates || planDates.length === 0) return;
    const code = str(planDates[0].CODE);
    const { from, to } = planPeriodOf(code);
    setPlanDate(code, from, to, true);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.companyId, sc.planDate, planDates]);

  // PlanDate 변경 → Period(From/To) 자동 재세팅 (AS-IS drpPeriod 파생, 사용자 요청 2026-10-02).
  const handlePlanDateChange = (code: string) => {
    const idx = (planDates ?? []).findIndex(r => str(r?.CODE) === code);
    const { from, to } = planPeriodOf(code);
    setPlanDate(code, from, to, idx === 0);
  };

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division* — 단일선택, 자동선택 없음(사용자 직접 선택 후 cascade 시작 — 02 §4.3) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={`${t(LBL.DIVISION, '_Div')}*`}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  useClearIcon
                  value={sc.divisionId}
                  options={divisionOptions}
                  // Division 변경 = 검색조건(Div·기간/날짜 제외) + 그리드 초기화(store setDivision, TO-BE 공통 요건).
                  //   편집중(dirty)이면 MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가 이전 Div 로 복귀(commit 51d4e9fa).
                  //   dirty 판정은 Main/Detail DataGrid 가 tabDirtyKey 레지스트리에 자동 등록한 편집분을 집계한다.
                  onChange={(_, picked) => {
                    const v = str(picked);
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (ok) setDivision(v);
                    });
                  }}
                />
              )}
            />
          </Grid>

          {/* Company* — Division 클라 필터 + 세션 Company 기본값 */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={`${t(LBL.COMPANY, '_Company')}*`}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  useClearIcon
                  value={sc.companyId}
                  options={companyOptions}
                  // Company 변경도 그리드·편집분을 초기화하므로 Division 과 동일하게 미저장 가드(gap-audit G11).
                  //   편집중이면 MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가 이전 값으로 복귀.
                  onChange={(_, picked) => {
                    const v = str(picked);
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (ok) setCompany(v);
                    });
                  }}
                />
              )}
            />
          </Grid>

          {/* From Site — 다중선택(clbPlantSite), Com_FromSite_SCP 재조회 */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.FROM_SITE, '_From Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  value={sc.plantSiteIds.join(',')}
                  options={fromSiteOptions}
                  onChange={(_, picked) =>
                    set({
                      plantSiteIds: str(picked)
                        .split(',')
                        .filter(v => v && v !== ALL),
                    })
                  }
                />
              )}
            />
          </Grid>

          {/* Bucket — cboBucketType (Daily/Weekly/Monthly). 변경 시 컬럼 표시 규칙만 전환(03 §2.3 — 재조회 없음) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.BUCKET, '_Bucket')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={sc.bucketType}
                  options={bucketOptions}
                  onChange={(_, picked) => set({ bucketType: str(picked) as BUCKET_TYPE })}
                />
              )}
            />
          </Grid>

          {/* Plan Date* — Plan_Infor_SCP 재조회, index0=최신(realFlag) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={`${t(LBL.PLAN_DATE, '_Plan Date')}*`}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={sc.planDate}
                  options={planDateOptions}
                  onChange={(_, picked) => handlePlanDateChange(str(picked))}
                />
              )}
            />
          </Grid>

          {/* Period* — PlanDate 선택 시 plan 구간(from~+14일)으로 자동 세팅되지만, AS-IS drpPeriod 처럼
              사용자가 달력으로 변경 가능하다(사용자 요청 2026-10-02 — 종전 disabled InputField 는 변경 불가였음).
              store periodFrom/To 는 YYYYMMDD 8자로 저장(PeriodField·SP 네이티브)하므로 변환 없이 주고받는다. */}
          <PeriodField
            gridSize={3}
            label={t(LBL.PERIOD, '_Period')}
            start={sc.periodFrom}
            end={sc.periodTo}
            onChange={(s, e) => set({ periodFrom: s, periodTo: e })}
          />

          {/* Model/Nickname — txtItemId + btnItemId (Main 조회 P_ITEM_ID).
              팝업은 ModelByDivisionPopup(= AS-IS SCM0002_ItembyDivisionPopup, 기준 화면 SSP0015 와 동일).
              라벨 근거는 ShipmentPlan.tsx 모달 주석 참조(2026.10.08 SP Model/Nickname 검색 지원). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL_NICKNAME, '_Model/Nickname')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.itemId}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={
                          <FunctionSearchIcon appearance='lined' onClick={onItemSearch} />
                        }
                      />
                    ),
                  }}
                  onChange={e => set({ itemId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* Product Level1 — clbProductLevel11 (CellGroup_SCP), 다중선택. LBL 신규 등록(05_register.sql) 전 영문 fallback */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PRODUCT_LEVEL1, '_Product Level1')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  value={sc.productLevel11.join(',')}
                  options={productLevelOptions}
                  onChange={(_, picked) =>
                    set({
                      productLevel11: str(picked)
                        .split(',')
                        .filter(v => v && v !== ALL),
                    })
                  }
                />
              )}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
          {/* Sum — chkSum (W_/M_ 집계 컬럼 표시 토글, 01 R9 / 03 §2.3) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.SUM, '_Sum')}
              labelAlign='right'
              render={() => (
                <Checkbox checked={sc.chkSum} onChange={checked => set({ chkSum: checked })} />
              )}
            />
          </Grid>

          {/* Tot PSI — chkTotPSI (SEQ<12/21 행 필터 + 재조회 트리거, 03 §2.3). LBL 신규(05_register.sql) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.TOT_PSI, '_Tot PSI')}
              labelAlign='right'
              render={() => (
                <Checkbox
                  checked={sc.chkTotPsi}
                  onChange={checked => set({ chkTotPsi: checked })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
