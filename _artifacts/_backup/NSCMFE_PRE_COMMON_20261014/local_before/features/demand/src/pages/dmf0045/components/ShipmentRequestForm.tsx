import {
  ItemField,
  PeriodField,
  ProjectField,
  buildComboOptions,
} from 'features/master/src/components';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { BUCKET_TYPE } from '../dmf0045.constants';
import { useShipmentRequestStore } from '../useShipmentRequestStore';
import { isDiv40 } from '../utils/dmf0045.division';
import {
  BUCKET_LOOKUP_TYPE,
  SEARCH_COMBO,
  resolveSalesSiteDeptIds,
} from '../utils/dmf0045.searchCombos';

// AS-IS DMF0045_ShipmentRequest 조회조건 (design 02 §1 영역2 인벤토리 — cs OnShown/InitCombo 실측).
//   칸-콤보 대응표 (SCM_ADM_CMBO_SQL_M / LOOKUP 등록 SQL_ID — memory search-condition-combo-header):
//     Div*        MyDivision                    권한조인 사업부 (단일, 필수) — cascade root
//     Team        UserTeamByDivision            Division
//     End Customer UserEndCustomerByDivisionDept Division + Team
//     Sales Site  UserSiteByEndCustomer         Division + End Customer (+40 팀변경 시 DEPT_ID)
//     Plant Site  UserPlantSiteByDivision       Division (40 비활성)
//     Period*     -                             오늘~오늘+55일(8주). AS-IS drpPeriod readOnly 였으나
//                                               TO-BE 표준(DM 자매화면 DMF0040)은 편집 가능 PeriodField.
//                                               readOnly 재현은 shared 컴포넌트 개변이 필요해 미이식
//                                               (__asis-mapping__ 기록). 기본값은 store init 이 고정.
//     Bucket*     BUCKET_TYPE_CODE (LOOKUP)      D/W/M (기본 Daily). 변경 가드는 페이지가 담당.
//     Project     팝업 ProjectByDivisionModal    40 비활성 (design 02 §3)
//     Model/Item  팝업 ItemByDivisionModal       상시 활성
//   원천·축·AS-IS 라인의 상세는 utils/dmf0045.searchCombos 참조.
interface ShipmentRequestFormProps {
  onSearch: () => void;
  // Division 변경 = Grid 초기화(비움) + CRUD reset 의무 — 부모(ShipmentRequest.tsx)가 수행.
  //   재조회는 Search 버튼이며 여기서는 하위 종속필드만 clear 한다.
  onDivisionChange: () => void;
  // Bucket 변경 가드 = 페이지가 담당(위 헤더표 Bucket* 주석). 변경분(pending) 존재 시 MSG00227 차단.
  //   Form 은 후보 버킷만 넘기고 실제 store 반영/차단 판정은 부모(ShipmentRequest.tsx)가 수행한다.
  onBucketChange: (next: BUCKET_TYPE) => void;
}

// 전체선택('ALL')·전체해제·빈값은 필터상 같다 — 실제 코드만 남기고 나머지는 '미선택'([])으로 통일.
const normalizeCodes = (values: string[]): string[] =>
  values
    .map(value => String(value).trim())
    .filter(value => value !== '' && value.toUpperCase() !== 'ALL');

export const ShipmentRequestForm = ({
  onSearch,
  onDivisionChange,
  onBucketChange,
}: ShipmentRequestFormProps) => {
  const { t } = useTranslation();

  const sc = useShipmentRequestStore(s => s.searchCondition);
  const set = useShipmentRequestStore(s => s.setSearchCondition);
  const openSearchArea = useShipmentRequestStore(s => s.openSearchArea);
  const comboTrigger = useShipmentRequestStore(s => s.comboTrigger);

  const div40 = isDiv40(sc.divisionId);

  // 조회조건 콤보 5종은 전부 CMBO 필터다 — 파라미터 없이 전량을 한 번 받고 화면에서 좁힌다.
  //   원천·축·AS-IS 라인은 utils/dmf0045.searchCombos 참조.
  const [divisions, teams, endCustomers, salesSites, plantSites] = useTabComboQueries({
    filters: [
      SEARCH_COMBO.division,
      SEARCH_COMBO.team,
      SEARCH_COMBO.endCustomer,
      SEARCH_COMBO.salesSite,
      SEARCH_COMBO.plantSite,
    ],
  });

  // Bucket 은 CMBO 가 아니라 LOOKUP 정적 콤보다(design 02 §2-6 — SCM_ADM_LOOKUP_MASTER_DETAIL
  //   LOOKUP_TYPE='BUCKET_TYPE_CODE'). CMBO SQL_ID 로는 미등록이라 CMBO 경로로 조회하면 0행이다.
  const [bucketTypeLookup] = useTabLookupQueries({
    filters: [{ lookupType: BUCKET_LOOKUP_TYPE }],
  });

  // FilterMyDivision 은 DIVISION_ID 컬럼이 없다 — 축을 걸지 않는다.
  const divisionOptions = buildComboOptions(divisions);
  const teamOptions = buildComboOptions(teams, { division: sc.divisionId });

  // End Customer 목록 = Division + Team. DEPT_ID 는 엄격 매칭이다 — 공란 행이 대다수라(SITE_ITEM
  //   LEFT OUTER JOIN) 관대하게 두면 Team 을 골라도 목록이 그대로다.
  const endCustomerOptions = buildComboOptions(endCustomers, {
    division: sc.divisionId,
    narrow: { column: 'DEPT_ID', codes: normalizeCodes(sc.deptIds) },
  });

  // Sales Site = Division + End Customer, 40 팀변경 계기에만 DEPT_ID 축 추가.
  //   근거는 utils/dmf0045.searchCombos.resolveSalesSiteDeptIds.
  const salesSiteOptions = buildComboOptions(salesSites, {
    division: sc.divisionId,
    narrow: [
      { column: 'DEPT_ID', codes: resolveSalesSiteDeptIds(comboTrigger, sc.divisionId, sc.deptIds) },
      { column: 'END_CUSTOMER', codes: normalizeCodes(sc.endCustomers) },
    ],
  });

  // Plant Site = Division 단독 (FilterPlantSiteByDivision 에는 END_CUSTOMER 컬럼이 없다).
  const plantSiteOptions = buildComboOptions(plantSites, { division: sc.divisionId });

  // Bucket 옵션 — CMBO CODE 풀워드(DAILY/WEEKLY/MONTHLY) → 첫 글자 enum 매핑 + 정적 fallback.
  const bucketLabelKey: Record<string, string> = {
    [BUCKET_TYPE.DAILY]: 'LBL00682',
    [BUCKET_TYPE.WEEKLY]: 'LBL00683',
    [BUCKET_TYPE.MONTHLY]: 'LBL00684',
  };
  const bucketFallback = [
    { label: t('LBL00682', '_Daily'), value: BUCKET_TYPE.DAILY },
    { label: t('LBL00683', '_Weekly'), value: BUCKET_TYPE.WEEKLY },
    { label: t('LBL00684', '_Monthly'), value: BUCKET_TYPE.MONTHLY },
  ];
  const bucketOptions =
    bucketTypeLookup && bucketTypeLookup.length > 0
      ? bucketTypeLookup
          .map(item => {
            const code = String(item.CODE ?? '').charAt(0) as BUCKET_TYPE;
            return { label: t(bucketLabelKey[code] ?? '', String(item.NAME ?? code)), value: code };
          })
          .filter(
            o =>
              o.value === BUCKET_TYPE.DAILY ||
              o.value === BUCKET_TYPE.WEEKLY ||
              o.value === BUCKET_TYPE.MONTHLY
          )
      : bucketFallback;

  // 다중선택 조회조건 한 벌. 조회조건 드롭다운은 전부 표시명 순으로 둔다 — 눈으로 찾는 목록이라
  //   콤보 SQL 의 ORDER BY 보다 이쪽이 낫다(DM 자매화면 정본). Division 만 단일선택이다.
  const multiField = (
    labelCode: string,
    labelEn: string,
    value: string[],
    options: { label: string; value: string }[],
    onPick: (codes: string[]) => void,
    extra?: { disabled?: boolean }
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
            sortBy='label'
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

  return (
    <SearchArea
      isHidden={!openSearchArea}
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={onSearch}
      conditions={
        <>
          {/* Row 1 — Division*(단일) / Team / End Customer / Sales Site */}
          {/* Division 변경 — 하위 종속필드 전면 reset (AS-IS clbDivision_SelectedIndexChanged:
              Team/EC/Site/Plant 재조회 + Project/Item 클리어 + InitSpread) + Grid 초기화(onDivisionChange). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00001', '_Div.')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={sc.divisionId}
                  options={divisionOptions}
                  onChange={(_, option) => {
                    set(
                      {
                        divisionId: String(option ?? ''),
                        deptIds: [],
                        endCustomers: [],
                        scmSiteIds: [],
                        plantSiteIds: [],
                        projectCodes: [],
                        itemIds: [],
                      },
                      'division'
                    );
                    onDivisionChange();
                  }}
                />
              )}
            />
          </Grid>
          {multiField(
            'LBL00044',
            'Team',
            sc.deptIds,
            teamOptions,
            v => set({ deptIds: v, endCustomers: [], scmSiteIds: [] }, 'team')
          )}
          {multiField(
            'LBL00080',
            'End Customer',
            sc.endCustomers,
            endCustomerOptions,
            v => set({ endCustomers: v, scmSiteIds: [] }, 'endCustomer')
          )}
          {multiField('LBL00011', 'Sales Site', sc.scmSiteIds, salesSiteOptions, v =>
            set({ scmSiteIds: v })
          )}
          {/* Row 2 — Plant Site(40 비활성) / Project*(40 비활성) / Model·Nickname / Bucket* */}
          {multiField(
            'LBL00005',
            'Plant Site',
            sc.plantSiteIds,
            plantSiteOptions,
            v => set({ plantSiteIds: v }),
            { disabled: div40 }
          )}
          <ProjectField
            gridSize={3}
            value={sc.projectCodes}
            onChange={v => set({ projectCodes: v })}
            division={sc.divisionId}
            deptIds={sc.deptIds}
            endCustomers={sc.endCustomers}
            scmSiteIds={sc.scmSiteIds}
            projectCodes={sc.projectCodes}
            disabled={div40}
            multiCheckbox
          />
          <ItemField
            gridSize={3}
            value={sc.itemIds}
            onChange={v => set({ itemIds: v })}
            division={sc.divisionId}
            deptIds={sc.deptIds}
            endCustomers={sc.endCustomers}
            scmSiteIds={sc.scmSiteIds}
            projectCodes={sc.projectCodes}
            itemIds={sc.itemIds}
            multiCheckbox
          />
          <Grid size={3}>
            <FormItem
              label={t('LBL00710', '_Bucket')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={sc.bucketType}
                  options={bucketOptions}
                  onChange={(_, option) => onBucketChange(option as BUCKET_TYPE)}
                />
              )}
            />
          </Grid>
          {/* Row 3 — Period* (오늘~오늘+55일, store init 고정. AS-IS drpPeriod readOnly 미이식 —
              헤더 주석·__asis-mapping__ 참조). 자매화면(DMF0040) 정본과 동일 편집 가능 PeriodField. */}
          <PeriodField
            gridSize={3}
            start={sc.startYyyymmdd}
            end={sc.endYyyymmdd}
            onChange={(start, end) => set({ startYyyymmdd: start, endYyyymmdd: end })}
          />
        </>
      }
    />
  );
};
