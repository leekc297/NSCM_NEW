import { PlantSiteField } from 'features/master/src/components';
import type { Dispatch, SetStateAction } from 'react';

import dayjs from '@foundation/dayjs';
import { clsx } from '@shared/clsx';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, DatePickerCalendar, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { useMetalLinkPriceStore } from '../useMetalLinkPriceStore';

import styles from './MetalLinkPriceForm.module.scss';

interface MetalLinkPriceFormProps {
  onSubmit: () => void;
  setOpenPrjByDivisionModal: Dispatch<SetStateAction<boolean>>;
  setOpenModelByDivisionModal: Dispatch<SetStateAction<boolean>>;
  setOpenVersionModal: Dispatch<SetStateAction<boolean>>;
}

// AS-IS DMF0074_MetalLinkPrice 조회조건 9 (SetChangeControl L100~159 + Designer 1:1):
//   Division(단일 필수) / Team / End Customer / Sales Site / Plant Site(81* 전용) /
//   Project(text+modal — 40 비활성) / Model(text+modal) / Plan Date(월 범위, 필수) /
//   Version(text+modal, 기본 'Current' — Division 변경 시 clear .cs L574)
export const MetalLinkPriceForm = ({
  onSubmit,
  setOpenPrjByDivisionModal,
  setOpenModelByDivisionModal,
  setOpenVersionModal,
}: MetalLinkPriceFormProps) => {
  const { t } = useTranslation();

  const searchParams = useMetalLinkPriceStore(state => state.searchParams);
  const setSearchParams = useMetalLinkPriceStore(state => state.setSearchParams);
  const isOpenSearchArea = useMetalLinkPriceStore(state => state.isOpenSearchArea);

  // ComboId — SCM_ADM_CMBO_SQL_M 등록명 (DMF0014 형제 화면 파리티. DMF0074 자체 CMBO 등록 0 —
  //   AS-IS GetDMInnerTable 7종 chain 을 공용 콤보로 대체). Plant Site 는 카탈로그 PlantSiteField 사용.
  const [myDivision, teambyDivision, endCustomer, salesSite] = useTabComboQueries({
    filters: ['MyDivision', 'TeambyDivision', 'EndCustomer', 'SalesSite'],
  });

  // cascade 하위 필터 기준 — 선택된 Team(멀티, 콤마조인)
  const selTeams = searchParams.team ? searchParams.team.split(',').filter(Boolean) : [];
  // AS-IS SetChangeControl 분기: Project = 81*/82 만 활성 (40 비활성)
  const isProjectDisabled = !(
    searchParams.divisionId.startsWith('81') || searchParams.divisionId === '82'
  );

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={onSubmit}
      isHidden={!isOpenSearchArea}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              label={t('LBL00001', '_Div.')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  defaultValue='ALL'
                  value={searchParams.divisionId}
                  options={myDivision?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => {
                    // AS-IS clbDivisions SIC (.cs L249) — 하위 콤보 5종 reset + Project/PlantSite
                    //   활성 분기 + ⭐ Version clear (.cs L574 — 버전은 division 종속)
                    setSearchParams({
                      divisionId: option,
                      team: '',
                      endCustomer: '',
                      salesSite: '',
                      plantSite: '',
                      project: '',
                      version: '',
                    });
                  }}
                  className={styles.input}
                />
              )}
              labelSize='long'
              className={styles.formItem}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00044', '_Team')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={searchParams.team}
                  defaultValue='ALL'
                  allOption
                  useClearIcon
                  multiple
                  options={
                    teambyDivision
                      ?.filter(item => item.DIVISION_ID === searchParams.divisionId)
                      ?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, option) => {
                    // AS-IS clbTeam SIC (.cs L238) — 하위(End Customer/Sales Site) cascade clear
                    setSearchParams({ team: option, endCustomer: '', salesSite: '' });
                  }}
                  className={styles.input}
                />
              )}
              labelSize='long'
              className={styles.formItem}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00080', '_End Customer')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={searchParams.endCustomer}
                  defaultValue='ALL'
                  multiple
                  allOption
                  useClearIcon
                  options={
                    endCustomer
                      ?.filter(
                        item =>
                          item.DIVISION_ID === searchParams.divisionId &&
                          (selTeams.length === 0 || !item.DEPT_ID || selTeams.includes(item.DEPT_ID))
                      )
                      ?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, options) => {
                    // AS-IS clbEndCustomer SIC (.cs L198) — 하위(Sales Site) cascade clear
                    setSearchParams({ endCustomer: options, salesSite: '' });
                  }}
                  className={styles.input}
                />
              )}
              labelSize='long'
              className={styles.formItem}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00011', '_Sales Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={searchParams.salesSite}
                  defaultValue='ALL'
                  multiple
                  allOption
                  useClearIcon
                  options={
                    salesSite
                      ?.filter(
                        item =>
                          item.DIVISION_ID === searchParams.divisionId &&
                          (selTeams.length === 0 || !item.DEPT_ID || selTeams.includes(item.DEPT_ID))
                      )
                      ?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, options) => {
                    setSearchParams({ salesSite: options });
                  }}
                  className={styles.input}
                />
              )}
              labelSize='long'
              className={styles.formItem}
            />
          </Grid>
          {/* ⭐ Plant Site — 카탈로그 PlantSiteField (combo PlantSitebyEndCustomer · Division+EndCustomer
              바인드 cascade · Enable=81 계열만). AS-IS UserPlantSiteByEndCustomer 1:1 */}
          <PlantSiteField
            gridSize={3}
            value={searchParams.plantSite ? searchParams.plantSite.split(',').filter(Boolean) : []}
            onChange={v => setSearchParams({ plantSite: v.join(',') })}
            division={searchParams.divisionId}
            endCustomer={searchParams.endCustomer || undefined}
          />
          <Grid size={3}>
            <FormItem
              label={t('LBL00617', 'Project')}
              labelAlign='right'
              render={() => (
                <div className={clsx(styles.inputWithSearch, styles.input)}>
                  <InputField
                    fullWidth
                    // AS-IS — Project 는 81*/82 만 활성 (40 비활성) — 입력/팝업 버튼 모두 잠금
                    disabled={isProjectDisabled}
                    value={searchParams.project}
                    onChange={event => setSearchParams({ project: event.target.value })}
                  />
                  <Button
                    appearance='outlined'
                    priority='normal'
                    disabled={isProjectDisabled}
                    iconComponent={<FunctionSearchIcon appearance='lined' />}
                    onClick={() => {
                      if (!isProjectDisabled) setOpenPrjByDivisionModal(true);
                    }}
                  />
                </div>
              )}
              labelSize='long'
              className={styles.formItem}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00003', '_Model/Nickname')}
              labelAlign='right'
              render={() => (
                <div className={clsx(styles.inputWithSearch, styles.input)}>
                  <InputField
                    fullWidth
                    value={searchParams.modelNickname}
                    onChange={event => setSearchParams({ modelNickname: event.target.value })}
                  />
                  <Button
                    appearance='outlined'
                    priority='normal'
                    iconComponent={<FunctionSearchIcon appearance='lined' />}
                    onClick={() => setOpenModelByDivisionModal(true)}
                  />
                </div>
              )}
              labelSize='long'
              className={styles.formItem}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00013', '_Plan Date')}
              labelAlign='right'
              required
              render={() => (
                // AS-IS UsrMonthRangePicker 1:1 — 월 피커 From~To (기본 당월~+6개월 .cs L167)
                <div className={clsx(styles.monthRange, styles.input)}>
                  <DatePickerCalendar
                    usecase='month'
                    elevation
                    size='large'
                    locale='ko'
                    value={dayjs(searchParams.fromYyyymm, 'YYYYMM')}
                    onChange={date => {
                      if (date) setSearchParams({ fromYyyymm: dayjs(date).format('YYYYMM') });
                    }}
                  />
                  <span>~</span>
                  <DatePickerCalendar
                    usecase='month'
                    elevation
                    size='large'
                    locale='ko'
                    value={dayjs(searchParams.toYyyymm, 'YYYYMM')}
                    onChange={date => {
                      if (date) setSearchParams({ toYyyymm: dayjs(date).format('YYYYMM') });
                    }}
                  />
                </div>
              )}
              labelSize='long'
              className={styles.formItem}
            />
          </Grid>
        </>
      }
      extraConditions={
        <Grid size={3}>
          <FormItem
            label={t('LBL00739', 'Version')}
            labelAlign='right'
            required
            render={() => (
              <div className={clsx(styles.inputWithSearch, styles.input)}>
                <InputField
                  fullWidth
                  // AS-IS txtVersion — 'Current' 수동 입력 유효 + 팝업 반환 (기본 'Current' .cs L222)
                  value={searchParams.version}
                  onChange={event => setSearchParams({ version: event.target.value })}
                />
                <Button
                  appearance='outlined'
                  priority='normal'
                  iconComponent={<FunctionSearchIcon appearance='lined' />}
                  onClick={() => setOpenVersionModal(true)}
                />
              </div>
            )}
            labelSize='long'
            className={styles.formItem}
          />
        </Grid>
      }
    />
  );
};
