import {
  BizTypeField,
  DivisionField,
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
  const isOpenSearchArea = useForecastPriceStore(state => state.isOpenSearchArea);

  // Bucket 옵션 = CMBO 'BucketType' 동적 fetch (DMF0003_GET_BUCKET_TYPE_CODE 1:1 — CMBO 등록명).
  //   CODE 풀워드(DAILY/WEEKLY/MONTHLY) → 첫 글자 enum 매핑. 빈 응답 시 정적 fallback 3종.
  // ⭐ [2026-08-20 AS-IS 정합 — 사용자 확정] End Customer 콤보 = 'EndCustomerByDivision'
  //   (AS-IS DMF0082.cs L352 SetChangeControl('EndCustomerByDivision') = BigFilter 결과셋 1:1 등록본 —
  //   40: SITE_ITEM owner PROJECT_CODE ∪ LOOKUP / 비40: SITE.END_CUSTOMER + DEPT_ID, 권한 division).
  //   구 'EndCustomer'(공유 CMBO)는 40 분기 산식이 BigFilter 원문과 다름(owner 미필터·LOOKUP 미합집합).
  //   division + 선택 팀(DEPT_ID) cascade 는 종전과 동일하게 클라 필터 (결과셋 컬럼 계약 동일).
  // ⭐ Sender Code 콤보 = CMBO 'SenderCode' (DMF0003 동일 등록명 — lookup EDI_SENDER_CODE,
  //   DIVISION_ID 컬럼 반환 → 클라 필터). 81 계열 전용 enable (AS-IS clbEDISender 파리티).
  const [bucketTypeCombo, endCustomerCombo, senderCodeCombo] = useTabComboQueries({
    filters: ['BucketType', 'EndCustomerByDivision', 'SenderCode'],
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
            onChange={v => setSearchParams({ deptIds: v, endCustomers: [], salesSites: [] })}
            comboId='UserTeamByDivision'
          />
          {/* End Customer — division + 선택 팀(DEPT_ID) cascade 필터 (MetalLinkPriceForm L118~143 1:1).
              팀 변경 시 옵션 재조회 + 하위(Sales Site) clear. */}
          <Grid size={3}>
            <FormItem
              label={t('LBL00080', '_End Customer')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  value={searchParams.endCustomers.join(',')}
                  options={
                    endCustomerCombo
                      ?.filter(
                        (item: ComboResponse) =>
                          item.DIVISION_ID === searchParams.divisionId &&
                          // ⭐ [2026-08-22] `|| !item.DEPT_ID` 제거 — Team 을 골라도 필터가 안 걸리던 원인.
                          //   AS-IS 는 `Filter["DEPT_ID"] = sTeam` 으로 **서버에서** 거르고
                          //   (`DMF0082_FcstNPrice_Mgmt.cs:8751-8754`, Team 변경 시 재조회 `:3052`),
                          //   TO-BE 등록본 `EndCustomerByDivision` 은 그 축을 결과 컬럼(DEPT_ID)으로만
                          //   내려주므로 **화면이 서버 술어를 그대로 재현**해야 한다.
                          //   우회가 있으면 div 40 에서 DEPT_ID 가 빈 행 **1,073건(53%)** 이 팀 선택을
                          //   통째로 빠져나간다(실측). 81/82 는 빈 행이 0이라 무증상이었다.
                          //   판정식은 형제 화면 DMF0003 `MktFcstForm` 과 동일하게 맞춘다.
                          (deptIds.length === 0 || deptIds.includes(item.DEPT_ID ?? ''))
                      )
                      ?.map((item: ComboResponse) => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, selected) =>
                    setSearchParams({
                      endCustomers: String(selected ?? '')
                        .split(',')
                        .filter(Boolean),
                      salesSites: [],
                    })
                  }
                />
              )}
            />
          </Grid>
          {/* ⭐ [CASCADE 2026-08-07] Sales Site = DMF0003 방식 이식 (MktFcstForm L70~86 1:1) —
              Div40 + Team/Customer 미선택(=Division 변경 직후) = BigFilter 'ScmSitebyEndCustomer40'(전체 40) /
              그 외 = 'UserSiteByEndCustomer'(div/dept/endCustomer 서버 바인드 — 81/82 고객 종속 + 권한 D + W 제외 + AS 포함).
              기존 'SalesSite'(division 클라 필터 단독)는 81/82 고객 cascade 부재 — DMF0003 파리티로 교체. */}
          <SalesSiteField
            gridSize={3}
            division={searchParams.divisionId}
            comboId={
              searchParams.divisionId === '40' &&
              deptIds.length === 0 &&
              endCustomers.length === 0
                ? 'ScmSitebyEndCustomer40'
                : 'UserSiteByEndCustomer'
            }
            deptId={deptIds.join(',')}
            endCustomer={endCustomers.join(',')}
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
          {/* ⭐ Plant Site — 표준 카탈로그 PlantSiteField (PlantSitebyEndCustomer, 81 계열 전용 enable,
              Division+EndCustomer 서버 바인드). 40/82 비활성. (MktFcstForm 1:1) */}
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
