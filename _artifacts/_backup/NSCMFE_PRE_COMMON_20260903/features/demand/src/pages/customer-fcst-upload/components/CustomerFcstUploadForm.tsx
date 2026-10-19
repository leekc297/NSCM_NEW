import { PeriodField, buildComboOptions, toSelectedCodes } from 'features/master/src/components';
// 임시 로컬 디버그 — 확인 끝나면 이 import 와 logSearchReset 호출, debugLabel prop 을 지운다.
import { logSearchReset } from 'features/master/src/components/searchFields/SearchFields.debug';
import type { Dispatch, SetStateAction } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { BUCKET_TYPE } from '../customer-fcst-upload.constant';
import { useCustomerFcstUploadStore } from '../useCustomerFcstUploadStore';

// 스토어의 조회조건은 CustomDropdown 이 내보내는 문자열 그대로다 (빈 문자열 또는 콤마 조인,
// 전체선택은 'ALL' sentinel). SearchFields 카탈로그는 string[] 계약이라 이 화면에서만 변환한다.
// 스토어 setFilters 의 orAll 이 빈 문자열을 'ALL' 로 바꿔 보내므로 저장 형태는 그대로 둔다.
const toList = (v: string) => v.split(',').filter(Boolean);

interface CustomerFcstUploadProps {
  onSubmit: () => void;
  /** Division 변경 = Grid 초기화 (부모 resetGrid — 조회 결과·미저장 편집 폐기) */
  onDivisionChange: () => void;
  setOpenPrjByDivisionModal: Dispatch<SetStateAction<boolean>>;
  setOpenModelByDivisionModal: Dispatch<SetStateAction<boolean>>;
}
export const CustomerFcstUploadForm = ({
  onSubmit,
  onDivisionChange,
  setOpenPrjByDivisionModal,
  setOpenModelByDivisionModal,
}: CustomerFcstUploadProps) => {
  const { t } = useTranslation();

  const searchParams = useCustomerFcstUploadStore(state => state.searchParams);
  const setSearchParams = useCustomerFcstUploadStore(state => state.setSearchParams);
  const isOpenSearchArea = useCustomerFcstUploadStore(state => state.isOpenSearchArea);

  /**
   * 조회조건 콤보 (Doc/Combo/DMF0014_콤보구성.md §1).
   *
   *   Filter 콤보                     목록 구성 조건            AS-IS 근거
   *   FilterMyDivision                없음                      InitControls :243
   *   FilterTeambyDivision            Division                  :251 / :835
   *   FilterEndCustomerByDivision     Division + Team           :261·:268 / :850·:868 / :899
   *   FilterSiteByEndCustomer         Division + End Customer   :278 / :858·:877 / :907 / :919
   *   FilterFromSiteByDivision        Division                  :284 / :885
   *
   * 파라미터 없이 전량을 한 번 받고 좁히는 일은 화면이 한다 - 규칙은
   * features/master/src/components/searchFields/bigFilterCombo 참조.
   *
   * Plant Site 는 원천이 하나뿐이다(UserPlantSiteByDivision). DMF0048 처럼 경로별 스왑이 없다.
   * Customs Handbook 과 Bucket Type 은 재조회이며 현행 콤보 ID 를 그대로 쓴다.
   */
  const [divisions, teams, endCustomers, salesSites, plantSites, customsHandbook, bucket] =
    useTabComboQueries({
      filters: [
        'FilterMyDivision',
        'FilterTeambyDivision',
        'FilterEndCustomerByDivision',
        'FilterSiteByEndCustomer',
        'FilterFromSiteByDivision',
        'DOM_EXP',
        'BucketType',
      ],
    });

  const teamOptions = buildComboOptions(teams, { division: searchParams.divisionId });

  // End Customer 목록 = Division + Team. DEPT_ID 는 엄격 매칭이다 - 이 콤보는 공란 행이 많아
  //   관대하게 두면 Team 을 골라도 목록이 그대로다.
  const endCustomerOptions = buildComboOptions(endCustomers, {
    division: searchParams.divisionId,
    narrow: { column: 'DEPT_ID', codes: toList(searchParams.team) },
  });

  /**
   * Sales Site 는 팀을 걸지 않는다 - AS-IS 가 :278 · :907 · :919 · :858 에서 팀 자리를 비운다.
   * (:877 만 Division 변경 + 40 경로에서 팀을 넘기는데, 같은 콤보가 조작 경로에 따라 달라지는
   *  AS-IS 결함이라 문서 §4-7 이 확인 대상으로 지목했다. 한 규칙으로 둔다.)
   *
   * 대신 End Customer 미선택은 그 시점 End Customer 목록 전체로 펼친다 - AS-IS
   * CString.GetCheckedListValue 재현이며, 이 경로로 Team 이 Sales Site 까지 반영된다.
   */
  const selectedEndCustomers = toSelectedCodes(toList(searchParams.endCustomer));
  const endCustomerCodes =
    selectedEndCustomers.length > 0
      ? selectedEndCustomers
      : endCustomerOptions.map(option => option.value);
  const salesSiteOptions = buildComboOptions(salesSites, {
    division: searchParams.divisionId,
    narrow: { column: 'END_CUSTOMER', codes: endCustomerCodes },
  });

  // Plant Site 는 Division 으로만 좁힌다 - FilterFromSiteByDivision(#5)은 END_CUSTOMER 컬럼이 없다.
  const plantSiteOptions = buildComboOptions(plantSites, { division: searchParams.divisionId });

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

  // ⭐ AS-IS cboDivision_SelectedIndexChanged (.cs L841~864) — division 81*/82 만 활성, 그 외(40 등) 비활성.
  //   AS-IS 는 Project 만이나, 사용자 요구(2026-07-07)로 Plant Site 도 동일 division 기준 enable 처리.
  const isDivRestricted = !(
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
              required
              render={() => (
                <CustomDropdown
                  value={searchParams.divisionId}
                  options={buildComboOptions(divisions)}
                  onChange={(_, picked) => {
                    const option = String(picked ?? '');
                    // 임시 로컬 디버그 — division 변경 시 하위 조회조건이 어떻게 재세팅되는지.
                    logSearchReset({
                      label: 'DMF0014 customer-fcst-upload',
                      changed: { field: 'divisionId', from: searchParams.divisionId, to: option },
                      resets: [
                        { field: 'team', from: searchParams.team, to: '' },
                        { field: 'endCustomer', from: searchParams.endCustomer, to: '' },
                        { field: 'salesSite', from: searchParams.salesSite, to: '' },
                        { field: 'plantSite', from: searchParams.plantSite, to: '' },
                        { field: 'project', from: searchParams.project, to: '' },
                        { field: 'modelNickname', from: searchParams.modelNickname, to: '' },
                        { field: 'customsHandbook', from: searchParams.customsHandbook, to: '' },
                        { field: 'bucket', from: searchParams.bucket, to: BUCKET_TYPE.WEEKLY },
                      ],
                    });
                    // AS-IS cboDivision_SelectedIndexChanged (.cs L823~889) — 하위 조건 cascade clear
                    setSearchParams({
                      divisionId: option,
                      team: '',
                      endCustomer: '',
                      salesSite: '',
                      plantSite: '',
                      project: '',
                      modelNickname: '',
                      customsHandbook: '',
                      bucket: BUCKET_TYPE.WEEKLY,
                    });
                    // 조회조건뿐 아니라 Grid 도 비운다 — 남은 결과는 이전 Division 으로 조회된 것이라
                    //   새 조회조건과 어긋나고, 미저장 편집이 남으면 바뀐 전제로 저장된다.
                    onDivisionChange();
                  }}
                />
              )}
            />
          </Grid>
          {/* 주의: 'ALL' 을 빈 배열로 바꿔 내려보내지 않는다.
              CustomDropdown 은 SELECT ALL 을 'ALL' sentinel 로 내보내고, 그 값이 그대로
              돌아와야 전체 체크 표시를 유지한다(isAllSentinel). 스토어 setFilters 의 orAll 이
              빈 문자열도 'ALL' 로 바꿔 보내므로 필터 의미는 양쪽 다 '조건 없음' 으로 같다. */}
          {multiField(
            'LBL00044',
            'Team',
            searchParams.team,
            teamOptions,
            team => {
              // 임시 로컬 디버그 — CustomDropdown 이 실제로 무엇을 내보내는지 확인용.
              logSearchReset({
                label: 'DMF0014 customer-fcst-upload',
                changed: {
                  field: 'team (= End Customer / Sales Site 콤보의 DEPT_ID)',
                  from: searchParams.team,
                  to: team,
                },
                resets: [
                  { field: 'endCustomer', from: searchParams.endCustomer, to: '' },
                  { field: 'salesSite', from: searchParams.salesSite, to: '' },
                  { field: 'plantSite', from: searchParams.plantSite, to: '' },
                  { field: 'project', from: searchParams.project, to: '' },
                  { field: 'modelNickname', from: searchParams.modelNickname, to: '' },
                  { field: 'customsHandbook', from: searchParams.customsHandbook, to: '' },
                  { field: 'bucket', from: searchParams.bucket, to: BUCKET_TYPE.WEEKLY },
                ],
              });
              // AS-IS clbTeam_SelectedIndexChanged — 하위(End Customer/Sales Site) cascade clear
              setSearchParams({
                team,
                endCustomer: '',
                salesSite: '',
                plantSite: '',
                project: '',
                modelNickname: '',
                customsHandbook: '',
                bucket: BUCKET_TYPE.WEEKLY,
              });
            },
            { sortBy: 'label' }
          )}
          {multiField(
            'LBL00080',
            'End Customer',
            searchParams.endCustomer,
            endCustomerOptions,
            endCustomer => {
              // 임시 로컬 디버그
              logSearchReset({
                label: 'DMF0014 customer-fcst-upload',
                changed: { field: 'endCustomer', from: searchParams.endCustomer, to: endCustomer },
                resets: [{ field: 'salesSite', from: searchParams.salesSite, to: '' }],
              });
              // AS-IS clbCustomer_SelectedIndexChanged — 하위(Sales Site) cascade clear
              setSearchParams({ endCustomer, salesSite: '' });
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
          {multiField(
            'LBL00005',
            'Plant Site',
            searchParams.plantSite,
            plantSiteOptions,
            plantSite => setSearchParams({ plantSite }),
            { sortBy: 'label', disabled: isDivRestricted }
          )}
          <Grid size={3}>
            <FormItem
              label={t('LBL00617', 'Project')}
              labelAlign='right'
              render={() => (
                // 팝업 검색 입력 표준 — 공용 popupSearchField + endAdornment 버튼
                //   (정본 master/sales-site-project-model SalesSiteProjectModelForm 1:1).
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  // AS-IS: Project 는 division 81*/82 만 활성 (40 등 비활성) — 입력/팝업 버튼 모두 잠금
                  disabled={isDivRestricted}
                  value={searchParams.project}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        disabled={isDivRestricted}
                        iconComponent={
                          <FunctionSearchIcon
                            appearance='lined'
                            onClick={() => {
                              if (!isDivRestricted) setOpenPrjByDivisionModal(true);
                            }}
                          />
                        }
                      />
                    ),
                  }}
                  onChange={event => setSearchParams({ project: event.target.value })}
                />
              )}
              labelSize='long'
              className={commonStyles.formItem}
            />
          </Grid>
          {/* 공용 카탈로그 PeriodField(@master/searchFields) — SalesPrice 등 타 화면과 동일 DateRange. */}
          <PeriodField
            gridSize={3}
            start={searchParams.startYyyymmdd}
            end={searchParams.endYyyymmdd}
            onChange={(start, end) => setSearchParams({ startYyyymmdd: start, endYyyymmdd: end })}
          />
          <Grid size={3}>
            <FormItem
              label={t('LBL00710', '_Bucket')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={searchParams.bucket}
                  options={bucket?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => {
                    // AS-IS cboBucketType — 단일 필수 (ALL 없음). CODE = DAILY/WEEKLY/MONTHLY full-word
                    setSearchParams({ bucket: option as BUCKET_TYPE });
                  }}
                  className={commonStyles.input}
                />
              )}
              labelSize='long'
              className={commonStyles.formItem}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
          <Grid size={3}>
            <FormItem
              label={t('LBL00003', '_Model/Nickname')}
              labelAlign='right'
              render={() => (
                // Project 와 동일한 팝업 검색 입력 표준
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={searchParams.modelNickname}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={
                          <FunctionSearchIcon
                            appearance='lined'
                            onClick={() => setOpenModelByDivisionModal(true)}
                          />
                        }
                      />
                    ),
                  }}
                  onChange={event => setSearchParams({ modelNickname: event.target.value })}
                />
              )}
              labelSize='long'
              className={commonStyles.formItem}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00091', 'Customer Handbook')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={searchParams.customsHandbook}
                  allOption
                  options={
                    customsHandbook?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, option) => {
                    setSearchParams({ customsHandbook: option });
                  }}
                  className={commonStyles.input}
                />
              )}
              labelSize='long'
              className={commonStyles.formItem}
            />
          </Grid>
        </>
      }
    />
  );
};
