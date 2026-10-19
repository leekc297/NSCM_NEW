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
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { BUCKET_TYPE } from '../cust-psi-upload.constant';
import { useCustPsiUploadStore } from '../useCustPsiUploadStore';

// 스토어의 조회조건은 CustomDropdown 이 내보내는 문자열 그대로다 (빈 문자열 또는 콤마 조인,
//   전체선택은 'ALL' sentinel). SearchFields 카탈로그는 string[] 계약이라 이 화면에서만 변환한다.
const toList = (v: string) => v.split(',').filter(Boolean);

interface CustPsiUploadFormProps {
  onSubmit: () => void;
  /** Division 변경 = Grid 초기화 (부모 resetGrid — 조회 결과·미저장 편집 폐기) */
  onDivisionChange: () => void;
  setOpenPrjByDivisionModal: Dispatch<SetStateAction<boolean>>;
  setOpenModelByDivisionModal: Dispatch<SetStateAction<boolean>>;
}
export const CustPsiUploadForm = ({
  onSubmit,
  onDivisionChange,
  setOpenPrjByDivisionModal,
  setOpenModelByDivisionModal,
}: CustPsiUploadFormProps) => {
  const { t } = useTranslation();

  const searchParams = useCustPsiUploadStore(state => state.searchParams);
  const setSearchParams = useCustPsiUploadStore(state => state.setSearchParams);
  const isOpenSearchArea = useCustPsiUploadStore(state => state.isOpenSearchArea);

  // Bucket → BucketType (BUCKET_TYPE_CODE lookup) / Customs Handbook → DOM_EXP.
  //   Division/Team/EndCustomer/SalesSite/PlantSite 는 카탈로그 필드가 같은 comboId 로 직접 조회한다.
  const [customsHandbook, bucket] = useTabComboQueries({
    filters: ['DOM_EXP', 'BucketType'],
  });
  // AS-IS cboDivision_SelectedIndexChanged — division 81*/82 만 활성, 그 외(40 등) 비활성.
  //   Project 팝업/입력 disable 게이트 (원장 §E12·§E17 Division 축).
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
              // AS-IS clbDivision_SelectedIndexChanged (원장 §E02) — 하위 조건 cascade clear
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
          <TeamField
            gridSize={3}
            division={searchParams.divisionId}
            value={toList(searchParams.team)}
            onChange={v => {
              // AS-IS clbTeam_SelectedIndexChanged (원장 §E03) — 하위(End Customer/Sales Site) cascade clear
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
              여기엔 Team(DEPT_ID) 단계만 넘긴다. strict — 관대 매칭이면 필터가 무력화된다. */}
          <EndCustomerField
            gridSize={3}
            division={searchParams.divisionId}
            cascade={{ DEPT_ID: { values: toList(searchParams.team), strict: true } }}
            value={toList(searchParams.endCustomer)}
            onChange={values => {
              // AS-IS clbEndCustomer_SelectedIndexChanged (원장 §E04) — 하위(Sales Site) cascade clear
              setSearchParams({ endCustomer: values.join(','), salesSite: '' });
            }}
          />
          {/* cascade = division-team-endCustomer-salesSite ('SalesSite' 콤보 반환 컬럼 기준).
              End Customer 는 이 콤보의 PROJECT_CODE 자리로 본다 (관대 — NULL 정상 존재). */}
          <SalesSiteField
            gridSize={3}
            division={searchParams.divisionId}
            cascade={{
              DEPT_ID: { values: toList(searchParams.team), strict: true },
              PROJECT_CODE: toList(searchParams.endCustomer),
            }}
            value={toList(searchParams.salesSite)}
            onChange={values => {
              setSearchParams({ salesSite: values.join(',') });
            }}
          />
          {/* Plant Site — 카탈로그 PlantSiteField (Division+EndCustomer 클라이언트 cascade · Enable=81 계열만) */}
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
          {/* 공용 카탈로그 PeriodField(@master/searchFields) — 타 화면과 동일 DateRange. */}
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
                    // AS-IS cboBucketType — 단일 필수 (ALL 없음). CODE = DAILY/WEEKLY/MONTHLY full-word.
                    //   버킷 변경 = 기간 컬럼 체계 변경 → Search 재조회로 그리드 재구성(원장 §E05).
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
