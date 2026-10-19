import {
  ItemField,
  OwnerField,
  PeriodField,
  ProjectField,
  VersionField,
  buildComboOptions,
} from 'features/master/src/components';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Checkbox, FormItem } from '@shared/lges';
import { Grid, Stack } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useMessageStore, useTabid } from '@shared/stores';

import { BUCKET_FALLBACK } from '../forecast-price.constants';
import { useForecastPriceStore } from '../useForecastPriceStore';
import { SEARCH_COMBO, buildSalesSiteComboParam } from '../utils/forecast-price.searchCombos';

interface ForecastPriceFormProps {
  onSubmit: () => void;
  onOpenVersionLookup: () => void;
  // #13 — Bucket 전환은 페이지가 가드(Insert 행 존재 시 MSG00227). 미지정 시 직접 setSearchParams fallback.
  onBucketChange?: (bucket: string) => void;
}

// ⭐ 조회조건 = 표준 카탈로그(@master/searchFields) 전면 사용 (T05 messaging-api-and-search-fields).
//   [UICATEGORY 2026-08-07] 배치 = DMF0003(MktFcstForm) 파리티 + 맨 뒤 Version/체크박스 (사용자 지정):
//   Row1 Division*/Team/End Customer/Sales Site · Row2 Biz Type/Sender Code(81 전용)/Period*/Bucket
//   Row3(extra) Project🔍(40 비활성)/Model·Nickname🔍/Plant Site(81 전용) · Row4(extra) Owner🔍/Version*/체크박스.
//   Item Type 은 미이식 (사용자 미지정 + DMF0082 SP 파라미터 부재 — 한계 명시).
//   화면 설계 1단 4필드 = gridSize 3 (높이 36px 은 카탈로그/CustomDropdown 자동).
export const ForecastPriceForm = ({
  onSubmit,
  onOpenVersionLookup,
  onBucketChange,
}: ForecastPriceFormProps) => {
  const { t } = useTranslation();

  const searchParams = useForecastPriceStore(state => state.searchParams);
  const setSearchParams = useForecastPriceStore(state => state.setSearchParams);
  const resetSearchParams = useForecastPriceStore(state => state.resetSearchParams);
  const isOpenSearchArea = useForecastPriceStore(state => state.isOpenSearchArea);

  // Division 변경은 그리드를 비운다(ForecastPrice.tsx division 변경 effect — clearChanges/clearFilters).
  //   편집중(dirty)이면 MSG00704 confirm 후에만 바꾼다 — 조회 공통 가드 confirmIfDirtyKey(..., 'search')를
  //   콤보 변경에도 동일 적용. controlled 콤보라 취소 시 자동 복귀.
  const tabId = useTabid();

  // [RESET 2026-08-26] AS-IS 공통 [Reset Condition](F10) 파리티 — MSG00009 confirm 후 조회조건
  //   전체 초기화, 완료 안내 MSG00011 (둘 다 기존 메시지 재사용 — 신규 채번 불필요 실측).
  //   공용 SearchArea 의 onResetCondition 슬롯 첫 적용 화면.
  const handleResetCondition = async () => {
    const setAlert = useMessageStore.getState().setAlert;
    const confirmed = await setAlert({
      type: 'confirm',
      content: t('MSG00009', '_저장된 검색조건을 초기화 하겠습니까?'),
    });
    if (!confirmed) return;
    resetSearchParams();
    void setAlert({ type: 'alert', content: t('MSG00011', '_검색조건이 초기화 되었습니다.') });
  };

  // Bucket 옵션 = CMBO 'BucketType' 동적 fetch (DMF0003_GET_BUCKET_TYPE_CODE 1:1 — CMBO 등록명).
  //   CODE 풀워드(DAILY/WEEKLY/MONTHLY) → 첫 글자 enum 매핑. 빈 응답 시 정적 fallback 3종.
  // Sender Code 콤보 = CMBO 'SenderCode' (DMF0003 동일 등록명 — lookup EDI_SENDER_CODE,
  //   DIVISION_ID 컬럼 반환 → 클라 필터). 81 계열 전용 enable (AS-IS clbEDISender 파리티).
  /**
   * 조회조건 콤보는 Division / Team / End Customer / Biz Type 이 필터다 (문서 §1).
   * 파라미터 없이 전량을 한 번 받고 좁히는 일은 화면이 한다 - 원천·축·AS-IS 라인은
   * utils/forecast-price.searchCombos 참조. Bucket 과 Sender Code 는 재조회로 남긴다.
   */
  const [divisions, teams, endCustomerRows, bizType, plantSites, bucketTypeCombo, senderCodeCombo] =
    useTabComboQueries({
      filters: [
        SEARCH_COMBO.division,
        SEARCH_COMBO.team,
        SEARCH_COMBO.endCustomer,
        SEARCH_COMBO.bizType,
        SEARCH_COMBO.plantSite,
        'BucketType',
        'SenderCode',
      ],
    });

  // ⭐ [2026-08-22] `'ALL'` 센티널 정규화 — 하위 콤보 판정 전에 반드시 걸러낸다.
  //   `CustomDropdown` 은 선택을 **모두 지우면** `'ALL'` 을 내보낸다(`CustomDropdown.tsx:182-184`
  //   `if (value.length === 0) onChange(event, 'ALL')`). 그대로 두면 `deptIds = ['ALL']` 이 되어
  //   `length === 0` 판정을 빠져나가고 어떤 `DEPT_ID` 와도 안 맞아 **End Customer 목록이 통째로 빈다**
  //   (사용자 신고: "TEAM 삭제 후 END CUSTOMER 가 보이지 않음").
  //   정본 = DMF0003 `MktFcstForm.tsx:87` 의 동일 정규화 1:1.
  const deptIds = searchParams.deptIds.filter(v => v !== 'ALL');
  const endCustomers = searchParams.endCustomers.filter(v => v !== 'ALL');

  const teamOptions = buildComboOptions(teams, { division: searchParams.divisionId });
  const bizTypeOptions = buildComboOptions(bizType, { division: searchParams.divisionId });

  /**
   * End Customer 목록 = Division + Team. DEPT_ID 는 엄격 매칭이다.
   *
   * 이 화면의 실제 값은 Project Code 다 - 40 전용 화면이고 FilterEndCustomerByDivision(#2)의
   * 40 분기가 PROJECT_CODE 를 CODE 로 쓴다(문서 §4-1). 그 분기는 SSO_DEPT_INFO 와 INNER JOIN
   * 이라 DEPT_ID 가 항상 채워져 있어, AS-IS 진입부(:352)가 팀 전체선택을 펼쳐 넘기는 것과
   * 선택값만 쓰는 것의 결과가 같다 - 그래서 펼치기를 옮기지 않는다.
   */
  const endCustomerOptions = buildComboOptions(endCustomerRows, {
    division: searchParams.divisionId,
    narrow: { column: 'DEPT_ID', codes: deptIds },
  });

  /**
   * Sales Site 는 재조회다 - 사업부로 두 갈래(81 계열·82 / 40 등)이며 목록 구성 조건을 전부
   * 파라미터로 실으므로 하나라도 바뀌면 SQL 이 다시 나간다.
   *
   * AS-IS 는 조작 경로별로 필터/재조회가 셋으로 갈리지만 필터 원천의 DEPT_ID 가 사내 데이터에서
   * NULL 이 대부분이라 클라이언트 축으로는 목록을 만들지 못한다 - 근거와 잃는 것은
   * utils/forecast-price.searchCombos 헤더 참조. DMF0003 과 같은 결정이다.
   */
  const [salesSiteRows] = useTabComboQueries({
    filters: [
      buildSalesSiteComboParam({ divisionId: searchParams.divisionId, deptIds, endCustomers }),
    ],
  });
  // 재조회 응답은 서버가 이미 좁혀 CODE / NAME 만 내려준다 - 축을 걸면 전 행이 잘린다.
  const salesSiteOptions = buildComboOptions(salesSiteRows);

  /**
   * Plant Site 는 Division 으로만 좁힌다. End Customer 는 걸지 않는다 - DMF0003 과 같은 결정이다.
   *
   * AS-IS 에서 고객 값이 실리는 경로가 없고(고객 변경 핸들러가 Plant Site 를 다시 만들지 않는다),
   * FilterPlantSiteByEndCustomer(#6)는 SITE_TYPE='PLANT' 행이라 END_CUSTOMER 가 대부분 NULL 이다.
   * 엄격 매칭으로 걸면 목록이 통째로 빈다 - 근거는 MktFcstForm 의 plantSiteOptions 주석 참조.
   *
   * 81 계열 전용이며 그 밖에는 잠근다.
   */
  const plantSiteEnabled = searchParams.divisionId.startsWith('81');
  const plantSiteOptions = buildComboOptions(plantSites, { division: searchParams.divisionId });

  /**
   * 다중선택 조회조건 한 벌.
   *
   * sortBy 는 칸마다 켜는 옵트인이라 호출부가 직접 넘긴다. 조회조건 드롭다운은 전부
   * 표시명 순(숫자-영문-한글)으로 둔다 - 눈으로 찾는 목록이라 콤보 SQL 의 ORDER BY 보다
   * 이쪽이 낫다는 사용자 확정(2026-08-28). Division 만 단일선택이다.
   */
  const multiField = (
    labelCode: string,
    labelEn: string,
    value: string[],
    options: { label: string; value: string }[],
    onPick: (codes: string[]) => void,
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
            value={value.join(',')}
            options={options}
            onChange={(_, picked) =>
              onPick(
                String(picked ?? '')
                  .split(',')
                  .filter(Boolean)
              )
            }
          />
        )}
      />
    </Grid>
  );
  const bucketOptions =
    bucketTypeCombo && bucketTypeCombo.length > 0
      ? bucketTypeCombo
          .map(item => {
            const code = String(item.CODE ?? '').charAt(0);
            const fb = BUCKET_FALLBACK.find(b => b.value === code);
            return { label: fb ? t(fb.lblKey, fb.label) : String(item.NAME ?? code), value: code };
          })
          .filter(o => ['D', 'W', 'M'].includes(o.value))
      : BUCKET_FALLBACK.map(b => ({ label: t(b.lblKey, b.label), value: b.value }));

  return (
    <SearchArea
      isHidden={!isOpenSearchArea}
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={onSubmit}
      onResetCondition={() => void handleResetCondition()}
      conditions={
        <>
          {/* Row 1 — Division* / Team / End Customer / Sales Site (DMF0003 파리티, 화면 설계 1단 4필드) */}
          {/* AS-IS 는 Division 목록에서 40 만 남기고(:342) 변경 핸들러도 빈 몸체다(:3039) —
              40 전용 화면이기 때문이다. 이 화면 TO-BE 는 81 전용 필드(Sender Code · Plant Site)를
              갖춘 다중 사업부 화면이라 그 제한을 옮기지 않는다. 문서 §4-3 도 그 줄을 결함으로
              지목한다(0건이면 CopyToDataTable 예외 → 40 권한 없는 계정은 화면이 안 열린다).
              대신 사업부를 바꾸면 콤보 경로를 진입 상태로 되돌린다. */}
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
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (!ok) return;
                      const v = String(picked ?? '');
                      setSearchParams({
                        divisionId: v,
                        deptIds: [],
                        endCustomers: [],
                        salesSites: [],
                        // [CASCADE 2026-08-07] DMF0003 파리티 — Division 변경 시 bizTypes 도 reset
                        bizTypes: [],
                        itemIds: [],
                        // [UICATEGORY 2026-08-07] 신규 종속 조회조건 — Division 변경 시 clear
                        plantSiteIds: [],
                        projectCodes: [],
                        owners: [],
                        senderCodes: [],
                        bucketType: 'W',
                        versionType: 'Current',
                        sumYn: false,
                        qtyYn: false,
                      });
                    });
                  }}
                />
              )}
            />
          </Grid>
          {/* Team — FilterTeambyDivision. AS-IS 는 SetChangeControl('UserTeamByDivision') 로
              BigFilter #1 을 쓴다(:348). 종전 UP_FX 판 'TeambyDivision' CMBO 와는 다른 결과셋이라
              필터 원천으로 통일한다(hook #138 의 취지 그대로). */}
          {multiField(
            'LBL00044',
            'Team',
            searchParams.deptIds,
            teamOptions,
            v =>
              setSearchParams({
                deptIds: v,
                endCustomers: [],
                salesSites: [],
                bizTypes: [],
                itemIds: [],
                plantSiteIds: [],
                projectCodes: [],
                owners: [],
                senderCodes: [],
                bucketType: 'W',
                versionType: 'Current',
                sumYn: false,
                qtyYn: false,
              }),
            { sortBy: 'label' }
          )}
          {/* End Customer — 이 화면의 실제 값은 Project Code 다 (문서 §4-1). 규칙은 위
              endCustomerOptions 주석 참조. AS-IS clbCustomer_SelectedIndexChanged (:3063) —
              변경 시 Sales Site 를 재조회로 다시 만든다. */}
          {multiField(
            'LBL00080',
            'End Customer',
            searchParams.endCustomers,
            endCustomerOptions,
            v => setSearchParams({ endCustomers: v, salesSites: [] }),
            { sortBy: 'label' }
          )}
          {multiField(
            'LBL00011',
            'Sales Site',
            searchParams.salesSites,
            salesSiteOptions,
            v => setSearchParams({ salesSites: v }),
            { sortBy: 'label' }
          )}

          {/* Row 2 — Biz Type / Sender Code(81 전용) / Period / Bucket (DMF0003 파리티 — Model 은 Row3) */}
          {/* Biz Type — FilterBizType(#3). 40 lookup 과 사업부별 목록을 UNION 으로 합쳐 내려주고
              40 행에 DIVISION_ID='40' 이 박혀 있어 한 축으로 좁히면 된다 (AS-IS :357). */}
          {multiField(
            'LBL00085',
            'Biz. Type',
            searchParams.bizTypes,
            bizTypeOptions,
            v => setSearchParams({ bizTypes: v }),
            { sortBy: 'label' }
          )}
          <Grid size={3}>
            {/* ⭐ Sender Code — 81 계열 전용 enable (AS-IS clbEDISender Division==81 만 활성 — MktFcstForm 1:1).
                40/82 비활성 + Division 변경 시 clear(DivisionField onChange 종속 reset). */}
            <FormItem
              label={t('LBL00090', '_Sender Code')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  disabled={!searchParams.divisionId.startsWith('81')}
                  value={searchParams.senderCodes.join(',')}
                  options={
                    senderCodeCombo
                      ?.filter(
                        (item: ComboResponse) =>
                          !item.DIVISION_ID || item.DIVISION_ID === searchParams.divisionId
                      )
                      .map((item: ComboResponse) => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, selected) =>
                    setSearchParams({
                      senderCodes: String(selected ?? '')
                        .split(',')
                        .filter(Boolean),
                    })
                  }
                />
              )}
            />
          </Grid>
          <PeriodField
            gridSize={3}
            start={searchParams.startYyyymmdd}
            end={searchParams.endYyyymmdd}
            onChange={(start, end) => setSearchParams({ startYyyymmdd: start, endYyyymmdd: end })}
          />
          <Grid size={3}>
            <FormItem
              label={t('LBL00710', '_bucket')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={searchParams.bucketType}
                  options={bucketOptions}
                  onChange={(_, option) =>
                    onBucketChange
                      ? onBucketChange(option)
                      : setSearchParams({ bucketType: option })
                  }
                />
              )}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
          {/* Row 3 — Project🔍 / Model·Nickname🔍 / Plant Site (DMF0003 파리티. Item Type 미이식) */}
          {/* ⭐ Project — Division==='40' 비활성 (AS-IS btnProject Division==40 disabled — MktFcstForm 1:1). */}
          <ProjectField
            gridSize={3}
            value={searchParams.projectCodes}
            onChange={v => setSearchParams({ projectCodes: v })}
            division={searchParams.divisionId}
            deptIds={searchParams.deptIds}
            endCustomers={searchParams.endCustomers}
            scmSiteIds={searchParams.salesSites}
            projectCodes={searchParams.projectCodes}
            disabled={searchParams.divisionId === '40'}
            multiCheckbox
          />
          <ItemField
            gridSize={3}
            division={searchParams.divisionId}
            deptIds={searchParams.deptIds}
            endCustomers={searchParams.endCustomers}
            scmSiteIds={searchParams.salesSites}
            projectCodes={searchParams.projectCodes}
            itemIds={searchParams.itemIds}
            value={searchParams.itemIds}
            onChange={v => setSearchParams({ itemIds: v })}
          />
          {/* Plant Site — FilterPlantSiteByEndCustomer(#6). Division 으로만 좁힌다(위 주석 참조).
              81 계열 전용이며 40/82 는 잠근다. MktFcstForm 과 같은 배선이다. */}
          {multiField(
            'LBL00005',
            'Plant Site',
            searchParams.plantSiteIds,
            plantSiteOptions,
            v => setSearchParams({ plantSiteIds: v }),
            { sortBy: 'label', disabled: !plantSiteEnabled }
          )}

          {/* Row 4 — Owner🔍 / Version*(팝업 전용) / Sum·Qty ≥ 0 체크박스 (사용자 지정 — 맨 뒤 Version+체크박스) */}
          <OwnerField
            gridSize={3}
            value={searchParams.owners}
            onChange={v => setSearchParams({ owners: v })}
            division={searchParams.divisionId}
            deptIds={searchParams.deptIds}
            endCustomers={searchParams.endCustomers}
            scmSiteIds={searchParams.salesSites}
            projectCodes={searchParams.projectCodes}
            owners={searchParams.owners}
            multiCheckbox
          />
          <VersionField
            gridSize={3}
            value={searchParams.versionType}
            onOpenPopup={onOpenVersionLookup}
          />
          <Grid size={6} className={commonStyles.customGrid}>
            <div className={commonStyles.customCheckbox}>
              <Stack direction='row' spacing={2} alignItems='center'>
                <Checkbox
                  labelText={t('LBL00687', '_Sum')}
                  checked={searchParams.sumYn}
                  onChange={checked => setSearchParams({ sumYn: checked })}
                />
                <Checkbox
                  labelText={t('LBL00689', '_Qty ≥ 0')}
                  checked={searchParams.qtyYn}
                  onChange={checked => setSearchParams({ qtyYn: checked })}
                />
              </Stack>
            </div>
          </Grid>
        </>
      }
    />
  );
};
