import { PeriodField } from 'features/master/src/components';
import { useEffect, useMemo, useRef } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CascadeDropdown, CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useMessageStore, useTabid } from '@shared/stores';

import {
  BUCKET_CODE,
  CASCADE_COL,
  COMBO,
  DIVISION_EE_EXCLUDE,
  DIVISION_EXCLUDE_CODE,
  LBL,
  MSG,
  PERIOD_W52_OFFSET_DAYS,
  SITE_SENTINEL,
} from '../global-psi.constants';
import { useGlobalPsiStore } from '../useGlobalPsiStore';
import { buildPlanVersionTree } from '../utils/globalPsiPlanVersion';

interface Props {
  onSearch: () => void;
  // Material 팝업(MaterialByDivisionModal) 오픈 — 페이지가 open state 소유(design 02 §4.6).
  onItemSearch: () => void;
  // Nick Name 팝업(TO-BE 변경: Material 과 동일 MaterialByDivisionModal) 오픈 — 페이지가 open state 소유.
  //   선택 결과에서 NICK_NAME(콜백 4번째 인자)을 nickName 에 저장한다.
  onNickNameSearch: () => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// AS-IS GetDayRange 근사(design 02 §4.2/§7 N4) — from=planDate, to=planDate+363일(52주-1). 로컬 Date 로 tz 무영향.
const addDaysYmd = (ymd: string, days: number): string => {
  if (!ymd || ymd.length !== 8) return '';
  const d = new Date(Number(ymd.slice(0, 4)), Number(ymd.slice(4, 6)) - 1, Number(ymd.slice(6, 8)));
  d.setDate(d.getDate() + days);
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, '0');
  const dd = String(d.getDate()).padStart(2, '0');
  return `${y}${m}${dd}`;
};

// Site 결과에 미선택 센티넬('-') prepend(design 02 §4.2). 값=CODE, 표시=NAME(=CODE).
const withSiteSentinel = (rows: ComboResponse[] | undefined): Option[] => [
  { label: SITE_SENTINEL, value: SITE_SENTINEL },
  ...toOptions(rows),
];

// AS-IS SCP0031_GlobalPSI 조회조건 패널(design 01 §1 2행 + design 02 §5 매핑).
//   상시(conditions, 2단 8칸): Division*(단일) / Material(+팝업) / Nick Name / From Site(다중)
//     / To Site(다중) / Bucket / Sum
//   접힘(extraConditions): Plan Date*(cascade) / Plan Type*(cascade) / Seq*(cascade) / Period*
//   자매 SCP0010(Shipment Plan SEMI) 배열과 정렬(사용자 지시 2026-10-19) — Plan Date/Type/Seq 는
//     Period 와 같은 줄로 내리고, Bucket/Sum 은 To Site 다음 줄로 올린다. 필수(*)가 접힘행에 있어도
//     기본 선택 effect 가 항상 채우므로 기능 영향 없음(§2.2 1순위 예외 — 사용자 명시 배치 지시 우선).
//   cascade(design 02 §3): Division→FromSite/ToSite 재조회 + PlanDate/Type/Seq _ALL 1회 로드 후 FE 클라 필터.
//     좁힘 주체 단일화(CLAUDE.local §5): _ALL 3콤보는 divisionId 미전송(전체 로드) + FE 필터로만 좁힌다.
export const GlobalPsiForm = ({ onSearch, onItemSearch, onNickNameSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useGlobalPsiStore(s => s.searchCondition);
  const set = useGlobalPsiStore(s => s.setSearchCondition);
  const setDivision = useGlobalPsiStore(s => s.setDivision);
  const openSearchArea = useGlobalPsiStore(s => s.openSearchArea);

  const tabId = useTabid();

  // 정적 로드 콤보 — Division(권한 division, ATTRIBUTE3 반환) / PlanDate·Type·Seq _ALL(전체 로드, FE 필터).
  //   divisionId 미전송 = AS-IS 전체 로드 후 클라 필터(design 02 §3.2). Bucket 은 고정 3종 정적 select(아래) —
  //   BucketType lookup 값이 DAILY/WEEKLY/MONTHLY 고정이고 조회 파라미터가 아닌 pivot 표시 토글이라 SP 왕복 불요
  //   (자매 global-psi-elec 동일 규약). 좁힘 주체 단일화(CLAUDE.local §5).
  const [divisions, planDatesAll, planTypesAll, planSeqsAll] = useTabComboQueries({
    filters: [COMBO.DIVISION, COMBO.PLAN_DATE, COMBO.PLAN_TYPE, COMBO.PLAN_SEQ],
  });
  // Site 콤보 — divisionId 종속 재조회(design 02 §3.2). FromSite=PLANT(validYn='Y') / ToSite=전체.
  const [fromSites, toSites] = useTabComboQueries({
    filters: [
      { comboId: COMBO.FROM_SITE, divisionId: sc.divisionId, validYn: 'Y' },
      { comboId: COMBO.TO_SITE, divisionId: sc.divisionId },
    ],
  });

  // Division — EE(전극)·40(소형) 제외(design 02 §2.2 ①②). Division_SCP 가 ATTRIBUTE3/CODE 반환하므로 no-op 아님.
  //   AS-IS 는 40 을 뺀 뒤 코드 오름차순으로 다시 정렬(81 · 81_HD · 81_HG · 81_HM · 81_ST · 81_UC · 82) — 갭분석 F-04.
  const divisionOptions = useMemo<Option[]>(
    () =>
      toOptions(
        (divisions ?? []).filter(
          r => str(r.ATTRIBUTE3) !== DIVISION_EE_EXCLUDE && str(r.CODE) !== DIVISION_EXCLUDE_CODE
        )
      ).sort((a, b) => (a.value < b.value ? -1 : a.value > b.value ? 1 : 0)),
    [divisions]
  );

  // PlanDate — _ALL 전체 로드 후 FE 필터 DIVISION_ID===division(design 02 §3.2, 반환 DIVISION_ID 별칭).
  const planDateOptions = useMemo<Option[]>(
    () =>
      toOptions(
        (planDatesAll ?? []).filter(r => str(r[CASCADE_COL.DIVISION_ID]) === sc.divisionId)
      ),
    [planDatesAll, sc.divisionId]
  );
  // PlanType — FE 필터 DIVISION_ID + PLANDATE(design 02 §3.2, 반환 DIVISION_ID/PLANDATE 별칭).
  const planTypeOptions = useMemo<Option[]>(
    () =>
      toOptions(
        (planTypesAll ?? []).filter(
          r =>
            str(r[CASCADE_COL.DIVISION_ID]) === sc.divisionId &&
            str(r[CASCADE_COL.PLANDATE]) === sc.planStartYyyymmdd
        )
      ),
    [planTypesAll, sc.divisionId, sc.planStartYyyymmdd]
  );
  // Seq — FE 필터 DIVISION_ID + PLANDATE + PLANTYPE(design 02 §3.2, 반환 DIVISION_ID/PLANDATE/PLANTYPE 별칭).
  const planSeqOptions = useMemo<Option[]>(
    () =>
      toOptions(
        (planSeqsAll ?? []).filter(
          r =>
            str(r[CASCADE_COL.DIVISION_ID]) === sc.divisionId &&
            str(r[CASCADE_COL.PLANDATE]) === sc.planStartYyyymmdd &&
            str(r[CASCADE_COL.PLANTYPE]) === sc.planType
        )
      ),
    [planSeqsAll, sc.divisionId, sc.planStartYyyymmdd, sc.planType]
  );

  // Plan Date → Type → Seq 종속 콤보를 CascadeDropdown 트리로 재구성(자매 SCP0013 ProductionPlanLineForm 규약).
  //   _ALL 전량 + divisionId 필터 + 반환컬럼(PLANDATE/PLANTYPE)으로 date→type→seq 중첩(util). 기존 옵션 계산
  //   (planTypeOptions/planSeqOptions)·기본값 effect 는 그대로 두고 입력 UI 만 3-콤보→트리로 교체한다.
  const planVersionTree = useMemo(
    () =>
      buildPlanVersionTree(
        planDatesAll ?? [],
        planTypesAll ?? [],
        planSeqsAll ?? [],
        sc.divisionId
      ),
    [planDatesAll, planTypesAll, planSeqsAll, sc.divisionId]
  );
  // 단일 문자열 store(planStartYyyymmdd/planType/planSeq)를 CascadeDropdown 의 name 키 객체로 투영.
  const planVersionValue = useMemo(
    () => ({
      planDate: sc.planStartYyyymmdd,
      planType: sc.planType,
      planSeq: sc.planSeq,
    }),
    [sc.planStartYyyymmdd, sc.planType, sc.planSeq]
  );

  const fromSiteOptions = useMemo<Option[]>(() => withSiteSentinel(fromSites), [fromSites]);
  const toSiteOptions = useMemo<Option[]>(() => withSiteSentinel(toSites), [toSites]);

  const bucketOptions: Option[] = [
    { label: t(LBL.BUCKET_DAILY, '_Daily'), value: BUCKET_CODE.DAILY },
    { label: t(LBL.BUCKET_WEEKLY, '_Weekly'), value: BUCKET_CODE.WEEKLY },
    { label: t(LBL.BUCKET_MONTHLY, '_Monthly'), value: BUCKET_CODE.MONTHLY },
  ];

  // Plan-date 선택(사용자·자동 프라이밍 공용) — Period 기본 W52 재계산(AS-IS GetDayRange). 조회는 명시 Search.
  //   Plan Type 을 비워 재필터 후 effect 가 항상 첫 항목으로 리셋하게 한다(사용자 지시) — 기존 선택이 새 목록에
  //   남아 있어도 유지하지 않는다. planType 공백 → PlanType/Seq effect 가 연쇄로 첫 항목 재도출.
  const selectPlanDate = (v: string) => {
    set({
      planStartYyyymmdd: v,
      planType: '',
      fromYyyymmdd: v,
      toYyyymmdd: addDaysYmd(v, PERIOD_W52_OFFSET_DAYS),
    });
  };

  // AS-IS SetChangedControl/SIC 기본선택 재현(design 02 §4.2) — 트리거 상태 기반(CLAUDE.local §6).
  //   Division=첫 옵션 / PlanDate=첫 옵션 / PlanType=첫 항목 / Seq=index0. 현재값이 옵션에 없을 때만 교정(무한루프 방지).
  //   parent-ready 게이트(자매 SCP0013 ProductionPlanLineForm 규약) — division 변경 직후 cascade 초기화
  //   (planStart/type/seq='')에서 plandate 기본 effect 와 planType 기본 effect 가 같은 커밋에 함께 돌면,
  //   planType 기본이 아직 plandate 로 좁혀지지 않은 division 전체(union) 목록의 첫 항목을 집어 선택 plandate 에
  //   없는 값으로 굳는 문제가 있다. 부모 선택이 확정된 뒤에만 기본값을 넣는다(planType 은 planDate 확정 후,
  //   planSeq 는 planType 확정 후). 단일 문자열 store 라 PPL 의 .length>0 대신 !!부모값 으로 게이트한다.
  //   필수: "현재값이 옵션에 있는가" 플래그(has*)를 effect 밖에서 계산해 deps 에 넣는다 — F10 리셋
  //   (resetSearchCondition→store reset)으로 값이 빈값이 되면 has*가 true→false 로 바뀌어 effect 가
  //   재발화해 첫 옵션을 다시 채운다. 옵션(divisionOptions 등)만 deps 에 두면 리셋 후 콤보 목록이 그대로라
  //   재발화하지 않아 첫 값이 안 들어온다(자매 SCP0100 global-psi-report·SCP0013 PPL 공통 규약).
  const firstDivision = divisionOptions[0]?.value ?? '';
  const hasDivision = divisionOptions.some(o => o.value === sc.divisionId);
  useEffect(() => {
    if (firstDivision && !hasDivision) setDivision(firstDivision);
  }, [firstDivision, hasDivision, setDivision]);

  const firstPlanDate = planDateOptions[0]?.value ?? '';
  const hasPlanDate = planDateOptions.some(o => o.value === sc.planStartYyyymmdd);
  useEffect(() => {
    if (firstPlanDate && !hasPlanDate) selectPlanDate(firstPlanDate);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [firstPlanDate, hasPlanDate]);

  const firstPlanType = planTypeOptions[0]?.value ?? ''; // 기본=첫 항목(사용자 지시, AS-IS 마지막에서 변경)
  const hasPlanType = planTypeOptions.some(o => o.value === sc.planType);
  useEffect(() => {
    if (!sc.planStartYyyymmdd) return; // parent-ready: planDate 확정 후
    if (firstPlanType && !hasPlanType) set({ planType: firstPlanType });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [firstPlanType, hasPlanType, sc.planStartYyyymmdd]);

  const firstPlanSeq = planSeqOptions[0]?.value ?? ''; // 기본=index0(design 02 §4.2)
  const hasPlanSeq = planSeqOptions.some(o => o.value === sc.planSeq);
  useEffect(() => {
    if (!sc.planType) return; // parent-ready: planType 확정 후
    if (firstPlanSeq && !hasPlanSeq) set({ planSeq: firstPlanSeq });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [firstPlanSeq, hasPlanSeq, sc.planType]);

  // 권한 Division 0 방어(design 01 §2 R1 SetDivisionAuthCheck) — EE/40 필터 결과 0건이면 권한 없음. 1회 alert + disable.
  const setAlert = useMessageStore.getState().setAlert;
  const alertedRef = useRef(false);
  const noDivisionAuth = divisions !== undefined && divisionOptions.length === 0;
  useEffect(() => {
    if (noDivisionAuth && !alertedRef.current) {
      alertedRef.current = true;
      void setAlert({
        type: 'alert',
        content: t(MSG.NO_DIVISION_AUTH, '_Please select Division.'),
      });
    }
    if (!noDivisionAuth) alertedRef.current = false;
  }, [noDivisionAuth, setAlert, t]);

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

  const multi = (
    labelText: string,
    value: string,
    options: Option[],
    onPick: (codes: string) => void,
    disabled?: boolean
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={labelText}
        labelAlign='right'
        render={() => (
          // From/To Site 목록 맨 위 SELECT ALL(조회조건 표준 v0.5 「ALL버튼」). 'ALL' 은 store siteParam 이 빈값으로 바꾼다.
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

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Row1 — Division*(단일) / Material(+팝업) / Nick Name / From Site(다중) */}
          {single(
            t(LBL.DIVISION, '_Div'),
            sc.divisionId,
            divisionOptions,
            // Division 변경 = 검색조건(Div·기간 제외) + 그리드 초기화(store setDivision, TO-BE 공통 요건). 편집중(dirty)이면
            //   MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가 이전 Div 로 복귀(commit 51d4e9fa 패턴).
            //   이 화면은 read-only 라 dirty 는 없지만 공통 패턴을 동일하게 둔다(SCP0025 선례).
            v => {
              void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                if (ok) setDivision(v);
              });
            },
            true,
            noDivisionAuth
          )}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MATERIAL, '_Material')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.itemId}
                  disabled={noDivisionAuth}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={<FunctionSearchIcon appearance='lined' />}
                        onClick={onItemSearch}
                      />
                    ),
                  }}
                  onChange={e => set({ itemId: e.target.value })}
                />
              )}
            />
          </Grid>
          {/* Nick Name — TO-BE 변경: 텍스트 입력 → Material 과 동일 MaterialByDivisionModal 팝업(선택 NICK_NAME 저장). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL, '_Nick Name')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.nickName}
                  disabled={noDivisionAuth}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={<FunctionSearchIcon appearance='lined' />}
                        onClick={onNickNameSearch}
                      />
                    ),
                  }}
                  onChange={e => set({ nickName: e.target.value })}
                />
              )}
            />
          </Grid>
          {multi(
            t(LBL.FROM_SITE, '_From Site'),
            sc.fromSite,
            fromSiteOptions,
            v => set({ fromSite: v }),
            noDivisionAuth
          )}
          {/* Row2 — To Site(다중) / Bucket / Sum (SEMI 배열 정렬, 사용자 지시 2026-10-19) */}
          {multi(
            t(LBL.TO_SITE, '_To Site'),
            sc.toSite,
            toSiteOptions,
            v => set({ toSite: v }),
            noDivisionAuth
          )}
          {single(
            t(LBL.BUCKET, '_Bucket'),
            sc.bucket,
            bucketOptions,
            // Bucket 변경 = D_/W_/M_ pivot visible 토글(design 03 §2.2) — 서버 재조회 없는 클라 전환.
            v => set({ bucket: v || BUCKET_CODE.DAILY }),
            false,
            noDivisionAuth
          )}
          {/* Row2 의 남은 6칸을 비워 그 줄을 유지한다. 아래 Plan 버전이 Bucket 옆으로 올라오지 않게 하는 칸이다. */}
          <Grid size={6} />

          {/* Row3 — Plan Date / Plan Type / Seq(cascade, 모두 필수) / Period(필수) / Sum. 접고펼침 없이 항상 보이게
              둔다(SCP0009·SCP0013 동일, 사용자 지시 2026-11-02). extraConditions 를 넘기지 않아 펼치기 버튼도 없다.
              SEMI 배열 정렬(사용자 지시 2026-10-19).
              공용 CascadeDropdown(종속 콤보 트리) — 자매 SCP0013 과 동일. combined 단일 입력칸(기본) — 클릭하면
              date→type→seq 컬럼 팝업으로 경로 선택, 상위 변경 시 하위 초기화. 입력칸 고정폭을 주지 않아 같은
              commonStyles.formItem 필드 칼럼을 채우는 다른 조회조건과 가로폭을 맞춘다(사용자 지시 2026-10-30).
              size=3 래퍼.
              자동선택(첫 date, 첫 type, 첫 seq), Period W52 재계산은 기존 effect(selectPlanDate 포함)가 그대로 처리한다. */}
          <Grid size={3}>
            <CascadeDropdown
              variant='horizontal'
              labelAlign='right'
              formItemClassName={commonStyles.formItem}
              label={t(LBL.PLAN_VERSION, '_Plan Date/Type/Seq')}
              tree={planVersionTree}
              levels={[
                { name: 'planDate', label: t(LBL.PLAN_DATE, '_Plan Date'), required: true },
                { name: 'planType', label: t(LBL.PLAN_TYPE, '_Plan Type'), required: true },
                { name: 'planSeq', label: t(LBL.SEQ, '_Seq.'), required: true },
              ]}
              value={planVersionValue}
              // planDate 가 바뀌면 selectPlanDate(Period W52 재계산 + planType 리셋)로, 그 외엔 해당 필드만 반영.
              //   단일 문자열 store 라 선택값을 그대로 담는다(PPL 의 1-요소 배열과 다른 지점).
              onChange={v => {
                if (v.planDate !== sc.planStartYyyymmdd) {
                  selectPlanDate(v.planDate);
                  return;
                }
                set({ planType: v.planType, planSeq: v.planSeq });
              }}
            />
          </Grid>
          {/* Period(from~to) — 공용 PeriodField. 기본값은 Plan-date 변경 시 selectPlanDate 가 W52 산식으로 채운다.
              PeriodRangePicker 교체(2026-10-19)는 사용자 지시로 원복 — PeriodField 유지. */}
          <PeriodField
            gridSize={3}
            start={sc.fromYyyymmdd}
            end={sc.toYyyymmdd}
            onChange={(start, end) => set({ fromYyyymmdd: start, toYyyymmdd: end })}
            label={t(LBL.PERIOD, '_Period')}
          />
          {/* ALL 체크박스 숨김 — 조회 시 항상 chkAll='Y'(전체) 고정. store 기본값에서 처리(useGlobalPsiStore makeInitSearch) */}
          {/* {checkbox(t(LBL.ALL, '_All'), sc.chkAll, v => set({ chkAll: v }))} */}
          {/* Sum(chkSum)은 그리드 건수 오른쪽(SubTitle afterCount)으로 이동(사용자 지시 2026-11-18, SCP0013 동형). */}
        </>
      }
    />
  );
};
