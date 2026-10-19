import { PeriodField } from 'features/master/src/components';
import { useEffect } from 'react';

import dayjs from '@foundation/dayjs';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid, Stack } from '@shared/mui';

import {
  ALL,
  BUCKET_TYPE,
  COMBO,
  FIXED_DIVISION,
  LBL,
  MENU_ID,
  PERIOD_OFFSET_DAY,
} from '../shipment-plan-mobility-it.constants';
import { useShipmentPlanMobilityItStore } from '../useShipmentPlanMobilityItStore';

interface Props {
  onSearch: () => void;
  onItemSearch: () => void; // btnItemId (1차 Item 팝업)
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// Plan Date 표시형식 yyyy-MM-dd (값=CODE YYYYMMDD 유지, 라벨만 포맷)
const fmtYmd = (v: string): string =>
  /^\d{8}$/.test(v) ? `${v.slice(0, 4)}-${v.slice(4, 6)}-${v.slice(6, 8)}` : v;

const toOptions = (rows: { CODE?: unknown; NAME?: unknown }[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// 1차 조회조건 (usrLayoutControl2 — design 01 §1 / 02 §1):
//   Division('40' 고정 disabled) / Plant Site(다중, 활성시트별 comboId 스왑) / Bucket / Plan Date* /
//   Period(표시전용) / Item(txtItemId+btnItemId) / 체크박스 5.
//   PSI Type(master 활성시트)는 상단 그리드 시트 탭으로 이동(AS-IS spdMain 2 시트 탭).
export const ShipmentPsiForm = ({ onSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useShipmentPlanMobilityItStore(s => s.searchCondition);
  const set = useShipmentPlanMobilityItStore(s => s.setSearchCondition);
  const setPlanDate = useShipmentPlanMobilityItStore(s => s.setSearchCondition);
  const setLatestPlanDate = useShipmentPlanMobilityItStore(s => s.setLatestPlanDate);
  const mainSheet = useShipmentPlanMobilityItStore(s => s.mainSheet);
  const openSearchArea = useShipmentPlanMobilityItStore(s => s.openSearchArea);

  // Plant Site — 활성시트별 comboId 스왑(design 02 §2.2). 이름유사 재사용 아님(convert-core §2.6 — 실 SQL_ID).
  //   Main=ShipmentRequestPlantSite_SCP(@divisionId @operationGroup='P' @param3='E') /
  //   Packer=FromSiteByDivisionOspPack(@divisionId @__GROUP__ @sesUserId BE주입).
  const plantSiteComboId = mainSheet === 'packer' ? COMBO.PLANT_SITE_PACKER : COMBO.PLANT_SITE_MAIN;

  // Period 조회구간 fromDate — AS-IS GetDayRange("A"/"P") (.cs L9198-9215): Plan Date 값 기준,
  //   Packer("P")만 -1일 보정. Main("A")은 그대로.
  const periodFromDate =
    sc.planDate && mainSheet === 'packer'
      ? dayjs(
          sc.planDate.length === 8
            ? `${sc.planDate.slice(0, 4)}-${sc.planDate.slice(4, 6)}-${sc.planDate.slice(6, 8)}`
            : sc.planDate
        )
          .subtract(1, 'day')
          .format('YYYYMMDD')
      : sc.planDate;

  const [divisions, plantSites, planDates, buckets, dayPeriod] = useTabComboQueries({
    filters: [
      // Division — 옵션만 콤보(MyDivisionInEE: @sesUserId BE주입 @mnuId). 값은 FIXED_DIVISION 고정(아래 disabled).
      { comboId: COMBO.DIVISION, mnuId: MENU_ID },
      mainSheet === 'packer'
        ? { comboId: COMBO.PLANT_SITE_PACKER, mnuId: MENU_ID, divisionId: FIXED_DIVISION }
        : {
            comboId: COMBO.PLANT_SITE_MAIN,
            mnuId: MENU_ID,
            divisionId: FIXED_DIVISION,
            operationGroup: 'P',
            param3: 'E',
          },
      // Plan Date(PlanDateShip) — @shipPlanType 로 Main/Packer 분기(AS-IS PlanDateShip "A"/"P").
      //   'P'=Packer(SSP_ANL_SHIP_PLAN_P) / 그 외='A'=Main(SSP_PLAN_VERSION_V). @divisionId.
      {
        comboId: COMBO.PLAN_DATE,
        mnuId: MENU_ID,
        divisionId: FIXED_DIVISION,
        shipPlanType: mainSheet === 'packer' ? 'P' : 'A',
      },
      COMBO.BUCKET,
      // Period 조회구간(SCM0001_GET_SCP_DAY_PERIOD) — AS-IS GetDayRange(.cs L9224-9229): p_from_date=Plan Date
      //   (Packer -1일), p_offset_day="31", p_timezone=사용자TZ(TO-BE 세션 미보유 → '').
      {
        comboId: COMBO.DAY_PERIOD,
        mnuId: MENU_ID,
        fromDate: periodFromDate,
        offsetDay: String(PERIOD_OFFSET_DAY),
        timeZone: '',
      },
    ],
  });

  const divisionOptions = toOptions(divisions);
  const plantSiteOptions = toOptions(plantSites);
  const planDateOptions = toOptions(planDates).map(o => ({ ...o, label: fmtYmd(o.value) }));
  const bucketOptions: Option[] =
    buckets && buckets.length > 0
      ? toOptions(buckets)
      : [
          { label: 'Daily', value: BUCKET_TYPE.DAILY },
          { label: 'Weekly', value: BUCKET_TYPE.WEEKLY },
          { label: 'Monthly', value: BUCKET_TYPE.MONTHLY },
        ];

  // Plan Date 선택 — 값만 설정. Period/Period2 는 SCM0001_GET_SCP_DAY_PERIOD 콤보가 도출(아래 effect,
  //   AS-IS GetDayRange). planDate 변경이 periodFromDate→콤보 refetch→period 재설정을 유발한다.
  const handlePlanDateChange = (code: string) => {
    setPlanDate({ planDate: code });
  };

  // I17 — Plan Date 기본 선택값: AS-IS Form_Load 는 최신 Plan(목록 첫 행 [0]) 자동 선택.
  //   미선택(빈 값)일 때만 [0] 선택 → 한 번 채워지면 재실행돼도 건너뛰어 루프/깜빡임 없음.
  //   dep 은 목록 '값 시그니처' — 탭 전환으로 시트별 목록이 교체(+setMainSheet 가 planDate 를 비움)되면
  //   재실행돼 새 목록 [0] 을 선택한다(length 만 보면 길이가 같은 시트 전환에서 재선택이 안 됨).
  const planDateValueSig = planDateOptions.map(o => o.value).join('|');
  useEffect(() => {
    if (planDateOptions.length > 0) {
      // 최신 Plan = 목록 첫 행 [0](AS-IS 정렬 최신순). 편집 가능 판정(MSG00170 이전 Plan 편집차단)에 쓴다.
      setLatestPlanDate(planDateOptions[0].value);
      if (!sc.planDate) handlePlanDateChange(planDateOptions[0].value);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [planDateValueSig]);

  // Period/Period2 조회구간 — SCM0001_GET_SCP_DAY_PERIOD 결과("from:to")로 재설정(AS-IS GetDayRange,
  //   .cs L2146-2155: drpPeriod·drpPeriod2 둘 다). fromDate 가 시트별로 다르므로(Main=Plan Date /
  //   Packer=-1일) Packer 도 값은 도출된다 — 단 Period 필드는 Packer 에서 비활성(L1500). 콤보 refetch
  //   (planDate·시트 변경) 시에만 발화하므로 사용자 수동 편집은 유지된다.
  useEffect(() => {
    const [from, to] = str(dayPeriod?.[0]?.CODE).split(':');
    if (from && to) set({ periodFrom: from, periodTo: to, period2From: from, period2To: to });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [dayPeriod]);

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division — '40' 고정 disabled (design 02 §2.1) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Div')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={FIXED_DIVISION}
                  options={
                    divisionOptions.length > 0
                      ? divisionOptions
                      : [{ label: FIXED_DIVISION, value: FIXED_DIVISION }]
                  }
                  disabled
                  onChange={() => undefined}
                />
              )}
            />
          </Grid>

          {/* PSI Type(master 활성시트 토글)는 상단 그리드 시트 탭으로 이동 — AS-IS spdMain 2 시트 탭 재현 */}

          {/* Plant Site — 다중, 활성시트별 comboId 스왑 */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PLANT_SITE, '_Plant Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  value={sc.plantSiteIds.join(',')}
                  options={plantSiteOptions}
                  key={plantSiteComboId}
                  onChange={(_, picked) =>
                    set({ plantSiteIds: str(picked).split(',').filter(v => v && v !== ALL) })
                  }
                />
              )}
            />
          </Grid>

          {/* Bucket — cboBucketType (기본 Daily) */}
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

          {/* Plan Date* — PlanDate 재조회 */}
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

          {/* Period* — 분리형 날짜필드. Main=편집가능(Plan Date로 재설정), Packer=비활성(drpPeriod) */}
          <PeriodField
            gridSize={3}
            label={`${t(LBL.PERIOD, '_Period')}*`}
            start={sc.periodFrom}
            end={sc.periodTo}
            disabled={mainSheet === 'packer'}
            onChange={(start, end) => set({ periodFrom: start, periodTo: end })}
          />

          {/* Item — txtItemId + btnItemId (SCM0002_ItembyDivisionPopup) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.ITEM, '_Item')}
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
                        iconComponent={<FunctionSearchIcon appearance='lined' onClick={onItemSearch} />}
                      />
                    ),
                  }}
                  onChange={e => set({ itemId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* Sum — chkSum (W_/M_ 집계 컬럼 표시 토글). Model 옆 윗줄 배치 */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.SUM, '_Sum')}
              labelAlign='right'
              render={() => <Checkbox checked={sc.chkSum} onChange={c => set({ chkSum: c })} />}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
          {/* 모델 필터 체크박스 4종 (design 02 §2.7) → 검색 SP p_*Chk(Y/N). 접이식(3번째 줄) 한 줄 그룹 */}
          <Grid size={12}>
            <Stack direction='row' alignItems='center' spacing={2} className={commonStyles.formItem}>
              <Checkbox
                labelText={t(LBL.MY_MODEL, '_My Model')}
                checked={sc.chkMyModel}
                onChange={c => set({ chkMyModel: c })}
              />
              <Checkbox
                labelText={t(LBL.PART_LEADER, '_Part Leader')}
                checked={sc.chkPartLeader}
                onChange={c => set({ chkPartLeader: c })}
              />
              <Checkbox
                labelText={t(LBL.TEAM_LEADER, '_Team Leader')}
                checked={sc.chkTeamLeader}
                onChange={c => set({ chkTeamLeader: c })}
              />
              <Checkbox
                labelText={t(LBL.DELEGATEE, '_Delegatee Model')}
                checked={sc.chkDelegatee}
                onChange={c => set({ chkDelegatee: c })}
              />
            </Stack>
          </Grid>
        </>
      }
    />
  );
};
