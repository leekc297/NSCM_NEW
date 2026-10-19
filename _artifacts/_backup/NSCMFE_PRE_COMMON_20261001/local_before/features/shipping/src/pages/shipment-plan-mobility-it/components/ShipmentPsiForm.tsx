import { useEffect } from 'react';

import dayjs from '@foundation/dayjs';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

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

const toOptions = (rows: { CODE?: unknown; NAME?: unknown }[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// 1차 조회조건 (usrLayoutControl2 — design 01 §1 / 02 §1):
//   Division('40' 고정 disabled) / Plant Site(다중, 활성시트별 comboId 스왑) / Bucket / Plan Date* /
//   Period(표시전용) / Item(txtItemId+btnItemId) / PSI Type(master 시트 토글) / 체크박스 5.
export const ShipmentPsiForm = ({ onSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useShipmentPlanMobilityItStore(s => s.searchCondition);
  const set = useShipmentPlanMobilityItStore(s => s.setSearchCondition);
  const setPlanDate = useShipmentPlanMobilityItStore(s => s.setSearchCondition);
  const mainSheet = useShipmentPlanMobilityItStore(s => s.mainSheet);
  const setMainSheet = useShipmentPlanMobilityItStore(s => s.setMainSheet);
  const openSearchArea = useShipmentPlanMobilityItStore(s => s.openSearchArea);

  // Plant Site — 활성시트별 comboId 스왑(design 02 §2.2). 이름유사 재사용 아님(convert-core §2.6 — 실 SQL_ID).
  //   Main=ShipmentRequestPlantSite_SCP(@divisionId @operationGroup='P' @param3='E') /
  //   Packer=FromSiteByDivisionOspPack(@divisionId @__GROUP__ @sesUserId BE주입).
  const plantSiteComboId = mainSheet === 'packer' ? COMBO.PLANT_SITE_PACKER : COMBO.PLANT_SITE_MAIN;
  const [plantSites, planDates, buckets] = useTabComboQueries({
    filters: [
      mainSheet === 'packer'
        ? { comboId: COMBO.PLANT_SITE_PACKER, mnuId: MENU_ID, divisionId: FIXED_DIVISION }
        : {
            comboId: COMBO.PLANT_SITE_MAIN,
            mnuId: MENU_ID,
            divisionId: FIXED_DIVISION,
            operationGroup: 'P',
            param3: 'E',
          },
      // Plan Date — PlanDate 재사용(Main "A" 등가, design 02 §2.4). Packer(SSP_ANL_SHIP_PLAN_P) 미등록(확인필요).
      { comboId: COMBO.PLAN_DATE, mnuId: MENU_ID, divisionId: FIXED_DIVISION },
      COMBO.BUCKET,
    ],
  });

  const plantSiteOptions = toOptions(plantSites);
  const planDateOptions = toOptions(planDates);
  const bucketOptions: Option[] =
    buckets && buckets.length > 0
      ? toOptions(buckets)
      : [
          { label: 'Daily', value: BUCKET_TYPE.DAILY },
          { label: 'Weekly', value: BUCKET_TYPE.WEEKLY },
          { label: 'Monthly', value: BUCKET_TYPE.MONTHLY },
        ];

  const handlePlanDateChange = (code: string) => {
    const row = (planDates ?? []).find(r => str((r).CODE) === code);
    // Period 파생 — PlanDate 콤보 반환 FROM_DATE/TO_DATE 우선. 없으면 GetDayRange(offset 31일) 근사:
    //   from=Plan Date, to=Plan Date + 31일(design 02 §2.5, iter-1 I08). planDate 단일값 fallback 은
    //   조회범위 붕괴(from=to)라 금지 — SCM0001_GET_SCP_DAY_PERIOD 정밀 재현은 convert-sp/확인필요(04).
    const from = str(row?.FROM_DATE) || code;
    // code(YYYYMMDD) → ISO(YYYY-MM-DD) 로 파싱(customParseFormat 플러그인 비의존) 후 offset 적용.
    const iso = code.length === 8 ? `${code.slice(0, 4)}-${code.slice(4, 6)}-${code.slice(6, 8)}` : '';
    const to =
      str(row?.TO_DATE) ||
      (iso ? dayjs(iso).add(PERIOD_OFFSET_DAY, 'day').format('YYYYMMDD') : code);
    setPlanDate({
      planDate: code,
      periodFrom: from,
      periodTo: to,
      period2From: from,
      period2To: to,
    });
  };

  // I17 — Plan Date 기본 선택값: AS-IS Form_Load 는 최신 Plan(목록 첫 행)을 자동 선택한다.
  //   목록 로드 후 미선택 상태면 최신(첫 옵션)을 자동 선택해 필수 alert 로 조회가 막히지 않게 한다.
  useEffect(() => {
    if (!sc.planDate && planDateOptions.length > 0) {
      handlePlanDateChange(planDateOptions[0].value);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [planDateOptions.length]);

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, { defaultValue: 'Search' })}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division — '40' 고정 disabled (design 02 §2.1) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, { defaultValue: 'Division' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={FIXED_DIVISION}
                  options={[{ label: FIXED_DIVISION, value: FIXED_DIVISION }]}
                  disabled
                  onChange={() => undefined}
                />
              )}
            />
          </Grid>

          {/* PSI Type — master 활성시트 토글(Mobility & IT / Packer). AS-IS spdMain ActiveSheet 등가 트리거 */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label='PSI'
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={mainSheet}
                  options={[
                    { label: 'Mobility & IT', value: 'main' },
                    { label: 'Packer', value: 'packer' },
                  ]}
                  onChange={(_, picked) => setMainSheet(str(picked) === 'packer' ? 'packer' : 'main')}
                />
              )}
            />
          </Grid>

          {/* Plant Site — 다중, 활성시트별 comboId 스왑 */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PLANT_SITE, { defaultValue: 'Plant Site' })}
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
              label={t(LBL.BUCKET, { defaultValue: 'Bucket' })}
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
              label={`${t(LBL.PLAN_DATE, { defaultValue: 'Plan Date' })}*`}
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

          {/* Period* — 표시전용(drpPeriod) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={`${t(LBL.PERIOD, { defaultValue: 'Period' })}*`}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  disabled
                  value={sc.periodFrom ? `${sc.periodFrom} ~ ${sc.periodTo}` : ''}
                />
              )}
            />
          </Grid>

          {/* Item — txtItemId + btnItemId (SCM0002_ItembyDivisionPopup) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.ITEM, { defaultValue: 'Item' })}
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
        </>
      }
      extraConditions={
        <>
          {/* Sum — chkSum (W_/M_ 집계 컬럼 표시 토글) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.SUM, { defaultValue: 'Sum' })}
              labelAlign='right'
              render={() => <Checkbox checked={sc.chkSum} onChange={c => set({ chkSum: c })} />}
            />
          </Grid>
          {/* 모델 필터 체크박스 4종 (design 02 §2.7) → 검색 SP p_*Chk(Y/N) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MY_MODEL, { defaultValue: 'My Model' })}
              labelAlign='right'
              render={() => (
                <Checkbox checked={sc.chkMyModel} onChange={c => set({ chkMyModel: c })} />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PART_LEADER, { defaultValue: 'Part Leader' })}
              labelAlign='right'
              render={() => (
                <Checkbox checked={sc.chkPartLeader} onChange={c => set({ chkPartLeader: c })} />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.TEAM_LEADER, { defaultValue: 'Team Leader' })}
              labelAlign='right'
              render={() => (
                <Checkbox checked={sc.chkTeamLeader} onChange={c => set({ chkTeamLeader: c })} />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DELEGATEE, { defaultValue: 'Delegatee Model' })}
              labelAlign='right'
              render={() => (
                <Checkbox checked={sc.chkDelegatee} onChange={c => set({ chkDelegatee: c })} />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
