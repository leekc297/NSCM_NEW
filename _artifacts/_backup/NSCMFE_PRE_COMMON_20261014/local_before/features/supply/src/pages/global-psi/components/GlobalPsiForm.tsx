import { PeriodField } from 'features/master/src/components';
import { useEffect, useMemo, useRef } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

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

interface Props {
  onSearch: () => void;
  // Material 팝업(ItemByDivisionModal) 오픈 — 페이지가 open state 소유(design 02 §4.6).
  onItemSearch: () => void;
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
//   Row1(main): Division*(단일) / Material(+팝업) / Nick Name / From Site(다중) / To Site(다중)
//   Row2(extra): Plan Date*(cascade) / Plan Type*(cascade) / Seq*(cascade) / Bucket / All / Period* / Sum
//   13필드>6 → extraConditions 2단 분리(hook #52). 필수(*) 5 = Division/Plan Date/Plan Type/Seq/Period.
//   cascade(design 02 §3): Division→FromSite/ToSite 재조회 + PlanDate/Type/Seq _ALL 1회 로드 후 FE 클라 필터.
//     좁힘 주체 단일화(CLAUDE.local §5): _ALL 3콤보는 divisionId 미전송(전체 로드) + FE 필터로만 좁힌다.
export const GlobalPsiForm = ({ onSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useGlobalPsiStore(s => s.searchCondition);
  const set = useGlobalPsiStore(s => s.setSearchCondition);
  const setDivision = useGlobalPsiStore(s => s.setDivision);
  const openSearchArea = useGlobalPsiStore(s => s.openSearchArea);

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
  const divisionOptions = useMemo<Option[]>(
    () =>
      toOptions(
        (divisions ?? []).filter(
          r => str(r.ATTRIBUTE3) !== DIVISION_EE_EXCLUDE && str(r.CODE) !== DIVISION_EXCLUDE_CODE
        )
      ),
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

  const fromSiteOptions = useMemo<Option[]>(() => withSiteSentinel(fromSites), [fromSites]);
  const toSiteOptions = useMemo<Option[]>(() => withSiteSentinel(toSites), [toSites]);

  const bucketOptions: Option[] = [
    { label: t(LBL.BUCKET_DAILY, '_Daily'), value: BUCKET_CODE.DAILY },
    { label: t(LBL.BUCKET_WEEKLY, '_Weekly'), value: BUCKET_CODE.WEEKLY },
    { label: t(LBL.BUCKET_MONTHLY, '_Monthly'), value: BUCKET_CODE.MONTHLY },
  ];

  // Plan-date 선택(사용자·자동 프라이밍 공용) — Period 기본 W52 재계산(AS-IS GetDayRange). 조회는 명시 Search.
  const selectPlanDate = (v: string) => {
    set({
      planStartYyyymmdd: v,
      fromYyyymmdd: v,
      toYyyymmdd: addDaysYmd(v, PERIOD_W52_OFFSET_DAYS),
    });
  };

  // AS-IS SetChangedControl/SIC 기본선택 재현(design 02 §4.2) — 트리거 상태 기반(CLAUDE.local §6).
  //   Division=첫 옵션 / PlanDate=첫 옵션 / PlanType=마지막 / Seq=index0. 현재값이 옵션에 없을 때만 교정(무한루프 방지).
  useEffect(() => {
    if (divisionOptions.length === 0) return;
    if (!sc.divisionId || !divisionOptions.some(o => o.value === sc.divisionId)) {
      setDivision(divisionOptions[0].value);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisionOptions]);

  useEffect(() => {
    if (planDateOptions.length === 0) return;
    if (!sc.planStartYyyymmdd || !planDateOptions.some(o => o.value === sc.planStartYyyymmdd)) {
      selectPlanDate(planDateOptions[0].value);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [planDateOptions]);

  useEffect(() => {
    if (planTypeOptions.length === 0) return;
    if (!sc.planType || !planTypeOptions.some(o => o.value === sc.planType)) {
      set({ planType: planTypeOptions[planTypeOptions.length - 1].value }); // 기본=마지막(design 02 §4.2)
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [planTypeOptions]);

  useEffect(() => {
    if (planSeqOptions.length === 0) return;
    if (!sc.planSeq || !planSeqOptions.some(o => o.value === sc.planSeq)) {
      set({ planSeq: planSeqOptions[0].value }); // 기본=index0(design 02 §4.2)
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [planSeqOptions]);

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
          <CustomDropdown
            multiple
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

  const checkbox = (labelText: string, checked: boolean, onToggle: (v: boolean) => void) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={labelText}
        labelAlign='right'
        render={() => (
          <div className={commonStyles.customCheckbox}>
            <Checkbox checked={checked} onChange={onToggle} disabled={noDivisionAuth} />
          </div>
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
          {/* Row1(main) — Division*(단일) / Material(+팝업) / Nick Name / From Site(다중) / To Site(다중) */}
          {single(
            t(LBL.DIVISION, '_Div'),
            sc.divisionId,
            divisionOptions,
            setDivision,
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
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.NICK_NAME, '_Nick Name')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sc.nickName}
                  disabled={noDivisionAuth}
                  onChange={e => set({ nickName: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
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
          {multi(
            t(LBL.TO_SITE, '_To Site'),
            sc.toSite,
            toSiteOptions,
            v => set({ toSite: v }),
            noDivisionAuth
          )}
        </>
      }
      extraConditions={
        <>
          {/* Row2(extra) — Plan Date*(cascade) / Plan Type*(cascade) / Seq*(cascade) / Bucket / All / Period* / Sum */}
          {single(
            t(LBL.PLAN_DATE, '_Plan Date'),
            sc.planStartYyyymmdd,
            planDateOptions,
            selectPlanDate,
            true,
            noDivisionAuth
          )}
          {single(
            t(LBL.PLAN_TYPE, '_Plan Type'),
            sc.planType,
            planTypeOptions,
            v => set({ planType: v }),
            true,
            noDivisionAuth
          )}
          {single(
            t(LBL.SEQ, '_Seq'),
            sc.planSeq,
            planSeqOptions,
            v => set({ planSeq: v }),
            true,
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
          {checkbox(t(LBL.ALL, '_All'), sc.chkAll, v => set({ chkAll: v }))}
          {/* Period(from~to) — 공용 PeriodField. 기본값은 Plan-date 변경 시 selectPlanDate 가 W52 산식으로 채운다. */}
          <PeriodField
            gridSize={3}
            start={sc.fromYyyymmdd}
            end={sc.toYyyymmdd}
            onChange={(start, end) => set({ fromYyyymmdd: start, toYyyymmdd: end })}
            label={t(LBL.PERIOD, '_Period')}
          />
          {/* Sum(chkSum) — SUM 컬럼(주계·월계) 표시 토글(design 03 §2.2). 서버 재조회 없는 그리드 가시성 전환. */}
          {checkbox(t(LBL.SUM, '_Sum'), sc.chkSum, v => set({ chkSum: v }))}
        </>
      }
    />
  );
};
