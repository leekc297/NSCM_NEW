import {
  DivisionField,
  EndCustomerField,
  PeriodField,
  PlantSiteField,
  SalesSiteField,
  TeamField,
} from 'features/master/src/components';
import type { Dispatch, SetStateAction } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { clsx } from '@shared/clsx';
import { SearchArea } from '@shared/components';
import { Button, FormItem, InputField } from '@shared/lges';
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

  // 2026-08-22 콤보 통일 — Div / Team / End Customer / Sales Site / Plant Site 는 SearchFields
  //   카탈로그 필드가 각자 조회한다 (MyDivision / TeambyDivision / EndCustomer / SalesSite /
  //   PlantSitebyEndCustomer). 종전 인라인 useTabComboQueries + 손으로 짠 cascade 필터는
  //   걷어냈다 — react-query 키가 같아 캐시를 공유하므로 네트워크 호출은 늘지 않는다.

  // cascade 하위 필터 기준 — 선택된 Team(멀티, 스토어는 콤마조인 문자열)
  const selTeams = searchParams.team ? searchParams.team.split(',').filter(Boolean) : [];
  // End Customer / Plant Site cascade 입력 — 스토어 콤마조인 문자열을 배열로 풀다.
  const selEndCustomers = searchParams.endCustomer
    ? searchParams.endCustomer.split(',').filter(Boolean)
    : [];
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
          <DivisionField
            gridSize={3}
            value={searchParams.divisionId}
            onChange={option =>
              // AS-IS clbDivisions SIC (.cs L249) — 하위 콤보 5종 reset + Project/PlantSite
              //   활성 분기 + Version clear (.cs L574 — 버전은 division 종속)
              setSearchParams({
                divisionId: option,
                team: '',
                endCustomer: '',
                salesSite: '',
                plantSite: '',
                project: '',
                version: '',
                modelNickname: '',
              })
            }
          />
          <TeamField
            gridSize={3}
            division={searchParams.divisionId}
            value={selTeams}
            onChange={v =>
              // AS-IS clbTeam SIC (.cs L238) — 하위(End Customer/Sales Site) cascade clear
              setSearchParams({
                team: v.join(','),
                endCustomer: '',
                salesSite: '',
                plantSite: '',
                project: '',
                version: '',
                modelNickname: '',
              })
            }
          />
          {/* cascade = division-team-endCustomer. division 은 카탈로그 필드가 항상 먼저 걸므로
              여기엔 Team(DEPT_ID) 단계만 넘긴다.
              필수: strict. 'EndCustomer' 콤보는 DEPT_ID 공란 행이 대다수라(SITE_ITEM LEFT OUTER
                JOIN) 관대 매칭이면 Team 을 골라도 목록이 그대로 보인다. 종전 인라인 필터는
                관대(`!item.DEPT_ID ||`)라 Team 이 목록을 못 좁혔다 — 통일 규칙대로 엄격으로 바꿈. */}
          <EndCustomerField
            gridSize={3}
            division={searchParams.divisionId}
            cascade={{ DEPT_ID: { values: selTeams, strict: true } }}
            debugLabel='DMF0074 metal-link-price / End Customer'
            value={selEndCustomers}
            onChange={v =>
              // AS-IS clbEndCustomer SIC (.cs L198) — 하위(Sales Site) cascade clear
              setSearchParams({ endCustomer: v.join(','), salesSite: '' })
            }
          />
          {/* cascade = division-team-endCustomer-salesSite ('SalesSite' 콤보 반환 컬럼 기준).
              End Customer 는 이 콤보의 PROJECT_CODE 자리로 본다 — 콤보가 END_CUSTOMER 컬럼을
                내려주지 않기 때문이다. DMF0003 / DMF0014 와 동일한 매핑이다.
              DEPT_ID 는 엄격, PROJECT_CODE 는 관대 — PROJECT_CODE 가 NULL 인 행이 정상적으로
                존재해 자르면 목록이 통째로 비어버린다. */}
          <SalesSiteField
            gridSize={3}
            division={searchParams.divisionId}
            cascade={{
              DEPT_ID: { values: selTeams, strict: true },
              PROJECT_CODE: selEndCustomers,
            }}
            debugLabel='DMF0074 metal-link-price / Sales Site'
            value={searchParams.salesSite ? searchParams.salesSite.split(',').filter(Boolean) : []}
            onChange={v => setSearchParams({ salesSite: v.join(',') })}
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
              className={commonStyles.formItem}
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
              label={t('LBL00653', 'Version')}
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
          {/* <Grid size={3}> */}
          {/* Plant Site — 카탈로그 PlantSiteField (combo PlantSitebyEndCustomer · Division+EndCustomer
              클라이언트 cascade · Enable=81 계열만). AS-IS UserPlantSiteByEndCustomer 1:1 */}
          <PlantSiteField
            gridSize={3}
            value={searchParams.plantSite ? searchParams.plantSite.split(',').filter(Boolean) : []}
            onChange={v => setSearchParams({ plantSite: v.join(',') })}
            division={searchParams.divisionId}
            endCustomer={searchParams.endCustomer || undefined}
            debugLabel='DMF0074 metal-link-price / Plant Site'
          />
          {/* </Grid> */}
        </>
      }
    />
  );
};
