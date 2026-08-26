import {
  BizTypeField,
  DivisionField,
  EndCustomerField,
  ItemField,
  OwnerField,
  PeriodField,
  PlantSiteField,
  ProjectField,
  SalesSiteField,
  TeamField,
  VersionField,
} from 'features/master/src/components';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Checkbox, FormItem } from '@shared/lges';
import { Grid, Stack } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { BUCKET_FALLBACK } from '../forecast-price.constants';
import { useForecastPriceStore } from '../useForecastPriceStore';

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
//   Figma 1단 4필드 = gridSize 3 (hook #94 — 높이 36px 은 카탈로그/CustomDropdown 자동).
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
  // 2026-08-22 콤보 통일 — End Customer 는 카탈로그 EndCustomerField 가 직접 조회한다
  //   (콤보 'EndCustomer'). 카탈로그가 cascade prop 을 지원하면서 인라인 CustomDropdown 으로
  //   팀(DEPT_ID) 필터를 직접 짠던 종전 방식은 필요 없어졌다.
  // Sender Code 콤보 = CMBO 'SenderCode' (DMF0003 동일 등록명 — lookup EDI_SENDER_CODE,
  //   DIVISION_ID 컬럼 반환 → 클라 필터). 81 계열 전용 enable (AS-IS clbEDISender 파리티).
  const [bucketTypeCombo, senderCodeCombo] = useTabComboQueries({
    filters: ['BucketType', 'SenderCode'],
  });

  // ⭐ [2026-08-22] `'ALL'` 센티널 정규화 — 하위 콤보 판정 전에 반드시 걸러낸다.
  //   `CustomDropdown` 은 선택을 **모두 지우면** `'ALL'` 을 내보낸다(`CustomDropdown.tsx:182-184`
  //   `if (value.length === 0) onChange(event, 'ALL')`). 그대로 두면 `deptIds = ['ALL']` 이 되어
  //   `length === 0` 판정을 빠져나가고 어떤 `DEPT_ID` 와도 안 맞아 **End Customer 목록이 통째로 빈다**
  //   (사용자 신고: "TEAM 삭제 후 END CUSTOMER 가 보이지 않음").
  //   정본 = DMF0003 `MktFcstForm.tsx:87` 의 동일 정규화 1:1.
  const deptIds = searchParams.deptIds.filter(v => v !== 'ALL');
  const endCustomers = searchParams.endCustomers.filter(v => v !== 'ALL');
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
          {/* Row 1 — Division* / Team / End Customer / Sales Site (DMF0003 파리티, Figma 1단 4필드) */}
          <DivisionField
            gridSize={3}
            value={searchParams.divisionId}
            onChange={v =>
              setSearchParams({
                divisionId: v,
                deptIds: [],
                endCustomers: [],
                salesSites: [],
                // [CASCADE 2026-08-07] DMF0003 파리티 — Division 변경 시 bizTypes 도 reset (MktFcstForm L155 1:1)
                bizTypes: [],
                itemIds: [],
                // [UICATEGORY 2026-08-07] 신규 종속 조회조건 — Division 변경 시 clear (cascade reset 의무)
                plantSiteIds: [],
                projectCodes: [],
                owners: [],
                senderCodes: [],
                bucketType: 'W',
                versionType: 'Current',
                sumYn: false,
                qtyYn: false,
              })
            }
          />
          {/* ⭐ [2026-08-20 AS-IS 정합 — 사용자 확정] Team = 'UserTeamByDivision' (AS-IS DMF0082.cs L347
              SetChangeControl('UserTeamByDivision') 의 BigFilter 'TeambyDivision' 결과셋은 E20260211-001049 로
              비40 분기가 주석 — owner 1토큰 방식 전 division 통일 = 본 CMBO 1:1. 기본 'TeambyDivision' CMBO 는
              UP_FX 판(2분기 생존)이라 조회조건 경로와 다름 — 주석 분기 부활 금지, hook #138). */}
          <TeamField
            gridSize={3}
            division={searchParams.divisionId}
            value={searchParams.deptIds}
            onChange={v =>
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
              })
            }
          />
          {/* cascade = division-team-endCustomer. division 은 카탈로그 필드가 항상 먼저 걸므로
              여기엔 Team(DEPT_ID) 단계만 넘긴다.
              필수: strict. 'EndCustomer' 콤보는 DEPT_ID 공란 행이 대다수라(SITE_ITEM LEFT OUTER
                JOIN) 관대 매칭이면 Team 을 골라도 목록이 그대로 보인다. 종전 인라인 필터는
                관대(`!item.DEPT_ID ||`)라 Team 이 목록을 못 좁혔다 — 통일 규칙대로 엄격으로 바꿈.
              팀 변경 시 하위(Sales Site) clear 는 TeamField onChange 가 이미 맡는다. */}
          <EndCustomerField
            gridSize={3}
            division={searchParams.divisionId}
            cascade={{ DEPT_ID: { values: searchParams.deptIds, strict: true } }}
            debugLabel='DMF0082 forecast-price / End Customer'
            value={searchParams.endCustomers}
            onChange={v => setSearchParams({ endCustomers: v, salesSites: [] })}
          />
          {/* 2026-08-22 콤보 통일 — 'SalesSite' 단일. 종전 division/선택여부에 따른
              'ScmSitebyEndCustomer40' · 'UserSiteByEndCustomer' 동적 스왑은 폐지했다.
              cascade = division-team-endCustomer-salesSite ('SalesSite' 콤보 반환 컬럼 기준).
              End Customer 는 이 콤보의 PROJECT_CODE 자리로 본다 — 콤보가 END_CUSTOMER 컬럼을
                내려주지 않기 때문이다. DMF0014 / DMF0044 와 동일한 매핑이다.
              DEPT_ID 는 엄격 — 종전 서버 바인드 @deptId 가 하던 축소를 여기서 대신한다.
              PROJECT_CODE 는 관대 — NULL 인 행이 정상적으로 존재해 자르면 목록이 빈다. */}
          <SalesSiteField
            gridSize={3}
            division={searchParams.divisionId}
            cascade={{
              DEPT_ID: { values: searchParams.deptIds, strict: true },
              PROJECT_CODE: searchParams.endCustomers,
            }}
            debugLabel='DMF0082 forecast-price / Sales Site'
            value={searchParams.salesSites}
            onChange={v => setSearchParams({ salesSites: v })}
          />

          {/* Row 2 — Biz Type / Sender Code(81 전용) / Period / Bucket (DMF0003 파리티 — Model 은 Row3) */}
          <BizTypeField
            gridSize={3}
            value={searchParams.bizTypes}
            onChange={v => setSearchParams({ bizTypes: v })}
          />
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
          {/* Plant Site — 표준 카탈로그 PlantSiteField (PlantSitebyEndCustomer, 81 계열 전용 enable,
              Division+EndCustomer 클라이언트 cascade). 40/82 비활성. (MktFcstForm 1:1) */}
          <PlantSiteField
            gridSize={3}
            value={searchParams.plantSiteIds}
            onChange={v => setSearchParams({ plantSiteIds: v })}
            division={searchParams.divisionId}
            endCustomer={
              searchParams.endCustomers.length > 0 ? searchParams.endCustomers.join(',') : undefined
            }
          />

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
