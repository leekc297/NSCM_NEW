import { PeriodField, buildComboOptions, toSelectedCodes } from 'features/master/src/components';
import type { Dispatch, SetStateAction } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { clsx } from '@shared/clsx';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { useMetalLinkPriceStore } from '../useMetalLinkPriceStore';
import { resolveEndCustomerCodes } from '../utils/metal-link-price.searchCombos';

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
  const comboTrigger = useMetalLinkPriceStore(state => state.comboTrigger);
  const setComboTrigger = useMetalLinkPriceStore(state => state.setComboTrigger);

  // Project / Model(Nickname) 입력칸에서 Enter 를 누르면 검색 아이콘 버튼과 같은 팝업을 연다
  //   (AS-IS txtProject_KeyDown .cs:252 / txtItemId_KeyDown .cs:260 1:1 — Sales Plan 과 같은 동작).
  //   SearchArea 의 전역 조회 단축키는 F5 뿐이라 Enter 와 충돌하지 않는다. 한글 조합 중 Enter 는 무시.
  const openModalOnEnter =
    (open: () => void) => (event: { key: string; nativeEvent: KeyboardEvent; preventDefault: () => void }) => {
      if (event.key !== 'Enter' || event.nativeEvent.isComposing) return;
      event.preventDefault();
      open();
    };

  // 스토어는 다중선택을 콤마조인 문자열로 들고 있다. 필터에 넘길 배열로 푼다.
  //   End Customer 는 진입/변경에 따라 푸는 방식이 달라 resolveEndCustomerCodes 가 직접 처리한다.
  const selTeams = toSelectedCodes(searchParams.team.split(','));

  /**
   * 조회조건 콤보 5종 전부 필터 방식이다 (Doc/Combo/DMF0074_콤보구성.md §1).
   *
   *   Filter 콤보                     목록 구성 조건                  AS-IS 근거
   *   FilterMyDivision                없음                            InitControls :171
   *   FilterTeambyDivision            Division                        :178 / :517
   *   FilterEndCustomerByDivision     Division + Team                 :185·:197 / :525·:552 / :613
   *   FilterSiteByEndCustomer         Division + End Customer         :212 / :567 / :622 / :628
   *   FilterPlantSiteByEndCustomer    Division                        :217 / :535
   *
   * 파라미터 없이 전량을 한 번 받고 좁히는 일은 화면이 한다 - 규칙은
   * features/master/src/components/searchFields/bigFilterCombo 참조.
   *
   * 콤보 원천은 진입·변경 구분 없이 다섯 개 그대로다. 다만 Sales Site 에 걸 End Customer 값만
   * 진입과 그 이후가 다르므로(아래 comboTrigger) 그 한 가지를 트리거로 가른다.
   */
  const [divisions, teams, endCustomers, salesSites, plantSites] = useTabComboQueries({
    filters: [
      'FilterMyDivision',
      'FilterTeambyDivision',
      'FilterEndCustomerByDivision',
      'FilterSiteByEndCustomer',
      'FilterPlantSiteByEndCustomer',
    ],
  });

  const teamOptions = buildComboOptions(teams, { division: searchParams.divisionId });

  // End Customer 목록 = Division + Team. DEPT_ID 는 엄격 매칭이다 - 이 콤보는 공란 행이 많아
  //   관대하게 두면 Team 을 골라도 목록이 그대로다.
  const endCustomerOptions = buildComboOptions(endCustomers, {
    division: searchParams.divisionId,
    narrow: { column: 'DEPT_ID', codes: selTeams },
  });

  /**
   * Sales Site 는 팀을 걸지 않는다 - AS-IS 네 호출부 전부 팀 자리에 빈 값을 고정으로 넣는다
   * (:212 · :567 · :622 · :628).
   *
   * End Customer 전체선택을 목록 전체로 펼치는 곳은 진입 한 곳뿐이다. 진입 후에는 축이 통째로
   * 꺼져 END_CUSTOMER 가 비어 있는 사이트 행도 살아남는다 - 근거와 라인은
   * utils/metal-link-price.searchCombos 참조.
   */
  const endCustomerCodes = resolveEndCustomerCodes(
    comboTrigger,
    searchParams.endCustomer,
    endCustomerOptions
  );
  const salesSiteOptions = buildComboOptions(salesSites, {
    division: searchParams.divisionId,
    narrow: { column: 'END_CUSTOMER', codes: endCustomerCodes },
  });

  /**
   * 다중선택 조회조건 한 벌.
   *
   * sortBy 는 칸마다 켜는 옵트인이라 호출부가 직접 넘긴다. 조회조건 드롭다운은 전부
   * 표시명 순(숫자-영문-한글)으로 둔다 - 눈으로 찾는 목록이라 콤보 SQL 의 ORDER BY 보다
   * 이쪽이 낫다는 사용자 확정(2026-08-28). Team 도 예외가 아니다.
   * Division 만 단일선택이다. */
  const multiField = (
    labelCode: string,
    labelEn: string,
    value: string,
    options: { label: string; value: string }[],
    onPick: (codes: string) => void,
    extra?: { sortBy?: 'label'; disabled?: boolean }
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(labelCode, labelEn)}
        labelAlign='right'
        labelSize='long'
        render={() => (
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            limitTags={1}
            sortBy={extra?.sortBy}
            disabled={extra?.disabled}
            value={value}
            options={options}
            onChange={(_, picked) => onPick(String(picked ?? ''))}
          />
        )}
      />
    </Grid>
  );

  /**
   * Plant Site 는 Division 으로만 좁힌다. End Customer 는 걸지 않는다.
   *
   * AS-IS 는 이 목록을 진입(:217)과 Division 변경(:535) 두 곳에서만 다시 만든다. Team 변경
   * (:606-624)과 End Customer 변경(:626-630) 핸들러는 Plant Site 를 건드리지 않는다.
   * 문서 §1 의 "Division + End Customer" 는 Division 을 바꾸는 그 시점 값이라는 뜻이다.
   */
  const plantSiteEnabled = searchParams.divisionId.startsWith('81');
  const plantSiteOptions = buildComboOptions(plantSites, { division: searchParams.divisionId });

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
              className={commonStyles.formItem}
              label={t('LBL00001', '_Div.')}
              labelAlign='right'
              labelSize='long'
              required
              render={() => (
                <CustomDropdown
                  value={searchParams.divisionId}
                  options={buildComboOptions(divisions)}
                  onChange={(_, option) => {
                    // AS-IS clbDivisions SIC (.cs L249) — 하위 콤보 5종 reset + Project/PlantSite
                    //   활성 분기 + Version clear (.cs L574 — 버전은 division 종속)
                    setSearchParams({
                      divisionId: String(option ?? ''),
                      team: '',
                      endCustomer: '',
                      salesSite: '',
                      plantSite: '',
                      project: '',
                      version: '',
                      modelNickname: '',
                    });
                    setComboTrigger('change');
                  }}
                />
              )}
            />
          </Grid>
          {multiField(
            'LBL00044',
            'Team',
            searchParams.team,
            teamOptions,
            team => {
              // AS-IS clbTeam SIC (.cs L238) — 하위(End Customer/Sales Site) cascade clear
              setSearchParams({
                team,
                endCustomer: '',
                salesSite: '',
                plantSite: '',
                project: '',
                version: '',
                modelNickname: '',
              });
              setComboTrigger('change');
            },
            { sortBy: 'label' }
          )}
          {multiField(
            'LBL00080',
            'End Customer',
            searchParams.endCustomer,
            endCustomerOptions,
            endCustomer => {
              // AS-IS clbEndCustomer SIC (.cs L198) — 하위(Sales Site) cascade clear
              setSearchParams({ endCustomer, salesSite: '' });
              setComboTrigger('change');
            },
            { sortBy: 'label' }
          )}
          {multiField(
            'LBL00011',
            'Sales Site',
            searchParams.salesSite,
            salesSiteOptions,
            salesSite => setSearchParams({ salesSite }),
            { sortBy: 'label' }
          )}
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
                    onKeyDown={openModalOnEnter(() => setOpenPrjByDivisionModal(true))}
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
              className={commonStyles.formItem}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00618', '_Model/Nickname')}
              labelAlign='right'
              render={() => (
                <div className={clsx(styles.inputWithSearch, styles.input)}>
                  <InputField
                    fullWidth
                    value={searchParams.modelNickname}
                    onChange={event => setSearchParams({ modelNickname: event.target.value })}
                    onKeyDown={openModalOnEnter(() => setOpenModelByDivisionModal(true))}
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
              className={commonStyles.formItem}
            />
          </Grid>
          <Grid size={3}>
            {/* ⭐ [2026-08-18] 년월 구간 — AS-IS drpPeriodMonth(월 선택기) 1:1. 종전 기본(년월일)
                픽커는 스토어 YYYYMM 계약과 어긋나 8자리를 밀어넣던 드리프트. */}
            <PeriodField
              mode='month'
              start={searchParams.fromYyyymm}
              end={searchParams.toYyyymm}
              onChange={(start, end) => setSearchParams({ fromYyyymm: start, toYyyymm: end })}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00606', 'Version')}
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
              className={commonStyles.formItem}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
          {multiField(
            'LBL00005',
            'Plant Site',
            searchParams.plantSite,
            plantSiteOptions,
            plantSite => setSearchParams({ plantSite }),
            { sortBy: 'label', disabled: !plantSiteEnabled }
          )}
        </>
      }
    />
  );
};
