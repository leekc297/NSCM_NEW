// ====================================================================================
// CustomerFcstMasterForm - DMF0007 조회조건
// ====================================================================================
// 콤보 구성 (Doc/Combo/DMF0007_콤보구성.md 기준)
//
//   조회조건       콤보                              방식    목록 구성 조건
//   Division       FilterMyDivision              필터    없음
//   Bucket Type    BucketType                        단순    없음
//   End Customer   FilterEndCustomerByDivision   필터    Division
//   Sales Site     FilterSiteByEndCustomer       필터    Division + End Customer
//   Active         YesOrNo                           단순    없음
//
// AS-IS 는 화면 진입 시 재조회, 조회조건 변경 시 BigFilter 로 서로 다른 경로를 탄다. 속도개선
// 과제([E20241112-000596])가 기존 코드를 지우지 않고 신식을 덧붙였기 때문인데, 진입 시 재조회
// 결과는 곧바로 신식 결과에 덮어써져 전부 낭비다. 여기서는 신식(BigFilter) 경로만 옮긴다.
//
// Team 은 옮기지 않는다. [PJ2024-50461] 로 화면에서 숨긴 뒤 목록 채우기와 변경 핸들러만 남아
// 있어 보이지 않는 콤보를 매번 조회하고 있었다. 조회조건이 아니므로 End Customer 의
// "Division + Team" 에서 Team 단계는 선택값이 없어 미적용된다.
//
// 정렬은 이 화면만 켠 것이다. End Customer / Sales Site 는 코드 목록이라 콤보가 준 순서에
// 업무 의미가 없어서 사용자가 눈으로 찾기 쉬운 표시명 순(숫자-영어-한글)으로 바꿨다.
// 같은 콤보를 쓰는 다른 화면은 손대지 않았다 - 정렬은 칸마다 켜는 옵트인이다.
// ====================================================================================

import { useEffect } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useSessionStore, useTabid } from '@shared/stores';

import { buildComboOptions } from '../../../components';
import { useCustomerFcstMasterStore } from '../useCustomerFcstMasterStore';

interface CustomerFcstMasterFormProps {
  onSubmit: () => void;
}

export const CustomerFcstMasterForm = ({ onSubmit }: CustomerFcstMasterFormProps) => {
  const { t } = useTranslation();

  const openSearchArea = useCustomerFcstMasterStore(state => state.openSearchArea);
  const searchParams = useCustomerFcstMasterStore(state => state.searchParams);
  const setSearchParams = useCustomerFcstMasterStore(state => state.setSearchParams);
  const userId = useSessionStore(state => state.session.userId);

  // Division 변경은 그리드를 통째로 비운다(CustomerFcstMaster.tsx rows useMemo deps 에
  //   searchParams.divisionId). 편집중(dirty)이면 MSG00704 confirm 후에만 바꾼다 — 조회 공통 가드
  //   confirmIfDirtyKey(..., 'search')를 콤보 변경에도 동일 적용. controlled 콤보라 취소 시 자동 복귀.
  const tabId = useTabid();

  // Filter 접두는 필터 방식이라는 표시다 - 파라미터 없이 전량을 한 번 받고 좁히는 일은
  //   아래 options 에서 화면이 한다. 파라미터가 없으니 쿼리 키가 고정이라 조회조건을 바꿔도
  //   서버를 다시 치지 않는다(AS-IS GetDMInnerTable 이 세션 캐시를 LINQ 로 거르던 것과 같다).
  const [divisions, endCustomers, salesSites, buckets, yesOrNo] = useTabComboQueries({
    filters: [
      'FilterMyDivision',
      'FilterEndCustomerByDivision',
      'FilterSiteByEndCustomer',
      'BucketType',
      'YesOrNo',
    ],
  });

  // 좁히는 규칙은 공용 모듈에 있다 - AS-IS GetDMInnerTable 재현(축별 엄격 매칭 + CODE 중복
  //   제거 + CODE 순). components/searchFields/bigFilterCombo 참조.
  const endCustomerOptions = buildComboOptions(endCustomers, {
    division: searchParams.divisionId,
  });

  /**
   * Sales Site 를 좁힐 End Customer 코드 집합.
   *
   * AS-IS 는 Sales Site 콤보에 팀 자리를 비워 넘기고(SetChangeControl("UserSiteByEndCustomer",
   * sDivision, string.Empty, sEndCustomer)), End Customer 자리에는 CString.GetCheckedListValue
   * 를 거친 값을 넘긴다. 그 함수가 'ALL' 을 그 시점 End Customer 목록의 전체 CODE 로 펼치므로,
   * 미선택이어도 Division 으로 좁혀진 고객 집합이 Sales Site 를 좁힌다.
   *
   * 목록이 비면 빈 배열이 되어 그 단계가 미적용된다 - AS-IS 도 펼친 결과가 공란이면
   * Count == 0 분기로 떨어져 전량이 흐른다.
   */
  const endCustomerCodes =
    searchParams.endCustomer === 'ALL'
      ? endCustomerOptions.map(option => option.value)
      : searchParams.endCustomer.split(',').filter(Boolean);

  useEffect(() => {
    setSearchParams({
      userId: userId,
    });
  }, [userId]);

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSubmit}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              label={t('LBL00001', '_Div.')}
              labelAlign='right'
              required
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  value={searchParams.divisionId}
                  options={buildComboOptions(divisions)}
                  onChange={(_, option) => {
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (!ok) return;
                      // division 이 바뀌면 하위 두 목록이 다시 만들어진다. 선택을 안 풀면 옵션에서
                      //   사라진 값이 조회조건에 남아 그대로 서버로 나간다.
                      setSearchParams({
                        divisionId: option,
                        endCustomer: 'ALL',
                        scmSiteId: 'ALL',
                      });
                    });
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00032', '_Bucket Type')}
              labelAlign='right'
              required
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  value={searchParams.bucketType}
                  options={buckets?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => {
                    setSearchParams({
                      bucketType: option,
                    });
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00080', '_End Customer')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  value={searchParams.endCustomer}
                  options={endCustomerOptions}
                  onChange={(_, options) => {
                    setSearchParams({ endCustomer: options, scmSiteId: 'ALL' });
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00011', '_Sales Site')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  value={searchParams.scmSiteId}
                  options={buildComboOptions(salesSites, {
                    division: searchParams.divisionId,
                    narrow: { column: 'END_CUSTOMER', codes: endCustomerCodes },
                  })}
                  onChange={(_, options) => {
                    setSearchParams({ scmSiteId: options });
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00007', '_Active')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  allOption
                  limitTags={1}
                  value={searchParams.validYn}
                  options={
                    yesOrNo?.map(item => ({
                      label: item.NAME,
                      value: item.CODE,
                    })) ?? []
                  }
                  onChange={(_, options) => {
                    setSearchParams({
                      validYn: options,
                    });
                  }}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
