import {
  DivisionField,
  EndCustomerField,
  PeriodField,
  PlantSiteField,
  SalesSiteField,
  TeamField,
} from 'features/master/src/components';
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

  // ComboId — SCM_ADM_CMBO_SQL_M 등록명 사용 (2026-07-02 전수 대조).
  //   Bucket → BucketType (BUCKET_TYPE_CODE lookup) / Customs Handbook → DOM_EXP
  // Division / Team / End Customer / Sales Site / Plant Site 는 카탈로그 필드가 같은 comboId 로
  // 직접 조회한다. react-query 키가 동일해 캐시를 공유하므로 네트워크 호출은 늘지 않는다.
  const [customsHandbook, bucket] = useTabComboQueries({
    filters: ['DOM_EXP', 'BucketType'],
  });
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
          <DivisionField
            gridSize={3}
            value={searchParams.divisionId}
            onChange={option => {
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
          {/* 주의: 'ALL' 을 빈 배열로 바꿔 내려보내지 않는다.
              CustomDropdown 은 SELECT ALL 을 'ALL' sentinel 로 내보내고, 그 값이 그대로
              돌아와야 전체 체크 표시를 유지한다(isAllSentinel). 스토어 setFilters 의 orAll 이
              빈 문자열도 'ALL' 로 바꿔 보내므로 필터 의미는 양쪽 다 '조건 없음' 으로 같다. */}
          <TeamField
            gridSize={3}
            division={searchParams.divisionId}
            value={toList(searchParams.team)}
            onChange={v => {
              // 임시 로컬 디버그 — CustomDropdown 이 실제로 무엇을 내보내는지(전체선택='ALL',
              // 전체해제='', 개별선택=콤마 조인) 확인용.
              logSearchReset({
                label: 'DMF0014 customer-fcst-upload',
                changed: {
                  field: 'team (= End Customer / Sales Site 콤보의 DEPT_ID)',
                  from: searchParams.team,
                  to: v.join(','),
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
                team: v.join(','),
                endCustomer: '',
                salesSite: '',
                plantSite: '',
                project: '',
                modelNickname: '',
                customsHandbook: '',
                bucket: BUCKET_TYPE.WEEKLY,
              });
            }}
          />
          {/* cascade = division-team-endCustomer. division 은 카탈로그 필드가 항상 먼저 걸므로
              여기엔 Team(DEPT_ID) 단계만 넘긴다.
              필수: strict. 'EndCustomer' 콤보는 DEPT_ID 가 공란인 행이 대다수라(SITE_ITEM LEFT
                OUTER JOIN) 관대 매칭이면 Team 을 골라도 목록이 그대로 보인다 — 필터가 통째로
                무력화된다. 종전 인라인 필터의 !item.DEPT_ID 통과 조건이 이 경우였다. */}
          <EndCustomerField
            gridSize={3}
            division={searchParams.divisionId}
            cascade={{ DEPT_ID: { values: toList(searchParams.team), strict: true } }}
            debugLabel='DMF0014 customer-fcst-upload / End Customer'
            value={toList(searchParams.endCustomer)}
            onChange={values => {
              // 임시 로컬 디버그 — End Customer 는 'SalesSite' 콤보의 PROJECT_CODE 자리로도 쓰인다.
              logSearchReset({
                label: 'DMF0014 customer-fcst-upload',
                changed: {
                  field: 'endCustomer (= SalesSite 콤보의 PROJECT_CODE)',
                  from: searchParams.endCustomer,
                  to: values.join(','),
                },
                resets: [{ field: 'salesSite', from: searchParams.salesSite, to: '' }],
              });
              // AS-IS clbCustomer_SelectedIndexChanged — 하위(Sales Site) cascade clear
              setSearchParams({ endCustomer: values.join(','), salesSite: '' });
            }}
          />
          {/* cascade = division-team-endCustomer-salesSite ('SalesSite' 콤보 반환 컬럼 기준).
              End Customer 는 이 콤보의 PROJECT_CODE 자리로 본다 — 콤보가 END_CUSTOMER 컬럼을
                내려주지 않기 때문이다. DMF0044 sales-site-project-model 과 동일.
              콤보를 바꾸면 컬럼명도 달라지므로 어느 조회조건이 어느 컬럼에 대응하는지는 화면이 든다. */}
          <SalesSiteField
            gridSize={3}
            division={searchParams.divisionId}
            cascade={{
              // DEPT_ID 는 strict — End Customer 와 같은 이유로 관대로 두면 Team 이 목록을 못 좁힌다.
              DEPT_ID: { values: toList(searchParams.team), strict: true },
              // PROJECT_CODE 는 관대 — 'SalesSite' 콤보는 이 컬럼이 NULL 인 행이 정상적으로
              // 존재한다. 자르면 목록이 비어버린다.
              PROJECT_CODE: toList(searchParams.endCustomer),
            }}
            debugLabel='DMF0014 customer-fcst-upload / Sales Site'
            value={toList(searchParams.salesSite)}
            onChange={values => {
              // 임시 로컬 디버그 — cascade 최하위라 같이 재세팅되는 항목은 없다.
              logSearchReset({
                label: 'DMF0014 customer-fcst-upload',
                changed: {
                  field: 'salesSite',
                  from: searchParams.salesSite,
                  to: values.join(','),
                },
                resets: [],
              });
              setSearchParams({ salesSite: values.join(',') });
            }}
          />
          {/* Plant Site — 카탈로그 PlantSiteField (combo PlantSitebyEndCustomer · Division+EndCustomer
              클라이언트 cascade · Enable=81 계열만 40/82 비활성). 2026-07-10 사용자 요구 (AS-IS 정합) */}
          <PlantSiteField
            gridSize={3}
            value={toList(searchParams.plantSite)}
            onChange={v => setSearchParams({ plantSite: v.join(',') })}
            division={searchParams.divisionId}
            endCustomer={searchParams.endCustomer || undefined}
          />
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
