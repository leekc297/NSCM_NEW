import { ItemField, OwnerField, ProjectField } from 'features/master/src/components';

import dayjs from '@foundation/dayjs';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Checkbox, DatePickerCalendar, FormItem } from '@shared/lges';
import { Grid, Stack } from '@shared/mui';

import { BUCKET_TYPE } from '../sales-monitoring.constants';
import { useSalesMonitoringStore } from '../useSalesMonitoringStore';

import styles from './SalesMonitoringForm.module.scss';

interface SalesMonitoringFormProps {
  onSearch: () => void;
}

// AS-IS DMF0048_SalesMonitoring 조회조건 (Figma Doc/_figma/DMF0048/DMF0048.png 1:1):
//   Row1: Div* / Team / End Customer / Sales Site
//   Row2: Period* / Bucket* / 체크박스(Sum·Color·Include Internal Txn) / Search(F5)
//   확장 : Item Type / Biz. Type / PJT🔍 / Model·Nickname🔍 + Plant Site / Owner🔍
//   ⭐ hook #94 — 1단 4개(Grid size={3}) + 모든 객체 36px. DatePicker = .datePickerFix wrapper.
//   콤보 = 사내 CMBO 레지스트리 등록명 (mkt-fcst 검증 완료 ID 재사용 — 임의 발명 금지).
//   (통화 콤보 KRW/USD/LOC 제외 — AS-IS 데드코드, 사용자 확정 2026-07-04)
export const SalesMonitoringForm = ({ onSearch }: SalesMonitoringFormProps) => {
  const { t } = useTranslation();

  const sc = useSalesMonitoringStore(s => s.searchCondition);
  const set = useSalesMonitoringStore(s => s.setSearchCondition);
  const openSearchArea = useSalesMonitoringStore(s => s.openSearchArea);

  // 조회조건 콤보 — 사내 SCM_ADM_CMBO_SQL_M 등록명 (DIVISION_ID/DEPT_ID 반환 콤보는 클라 cascade 필터)
  //   ⭐ Sales Site = 'SalesSite'(DIVISION_ID+DEPT_ID+PROJECT_CODE 반환) 로 교체 (2026-07-07).
  //     구 'ScmSitebyEndCustomer40' 은 div40 하드코딩 + 컬럼 미반환 → cascade 불가(타 division 오조회).
  const [myDivision, teamByDivision, endCustomerByDivision, scmSiteByEndCustomer, bizType, plantSite, itemType] =
    useTabComboQueries({
      filters: [
        'MyDivision',
        { comboId: 'TeambyDivision' },
        { comboId: 'EndCustomer' },
        'SalesSite',
        'BizType',
        { comboId: 'SalesPlant', divisionId: sc.divisionId },
        'ItemType',
      ],
    });

  // ⭐ cascade 하위 필터 기준 — 선택된 Team(단일). deptIds 비어있으면(ALL) Team 필터 미적용.
  const selDept = sc.deptIds[0] ?? '';
  // ⭐ AS-IS L338/1855 — Division '40' 은 Project / Plant Site 비활성 (lblProject/lblPlantSite Enabled=false).
  const isDiv40 = sc.divisionId === '40';

  // Bucket — AS-IS DMF0003_GET_BUCKET_TYPE_CODE 실측 (CODE=DAILY/WEEKLY/MONTHLY, 2026-07-04 스모크)
  const bucketOptions = [
    { label: t('LBL00682', '_Daily'), value: BUCKET_TYPE.DAILY },
    { label: t('LBL00683', '_Weekly'), value: BUCKET_TYPE.WEEKLY },
    { label: t('LBL00684', '_Monthly'), value: BUCKET_TYPE.MONTHLY },
  ];

  // 멀티 select dropdown 값 (콤마 delim string[] ↔ 단일 string). 단일선택 + ALL 패턴 (mkt-fcst 동일)
  const firstOr = (arr: string[]): string => arr[0] ?? '';
  const toArr = (v: string): string[] => (v ? [v] : []);

  return (
    <SearchArea
      isHidden={!openSearchArea}
      searchButtonLabel={t('LBL00691', '_Search')}
      onSearch={onSearch}
      conditions={
        <>
          {/* Row 1 — Div* / Team / End Customer / Sales Site (Figma Row1 1:1) */}
          <Grid size={3}>
            <FormItem
              label={t('LBL00001', '_Div.')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  mandatory
                  value={sc.divisionId}
                  options={myDivision?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => {
                    // AS-IS clbDivision_SelectedIndexChanged(SetChangeControl) — 하위 조건 cascade clear
                    set({
                      divisionId: option,
                      deptIds: [],
                      endCustomers: [],
                      scmSiteIds: [],
                      bizTypes: [],
                      plantSiteIds: [],
                    });
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00044', '_Team')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  useClearIcon
                  value={firstOr(sc.deptIds)}
                  options={
                    teamByDivision
                      ?.filter(item => !item.DIVISION_ID || item.DIVISION_ID === sc.divisionId)
                      .map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, option) =>
                    // AS-IS clbTeam_SelectedIndexChanged — 하위(End Customer/Sales Site) cascade clear
                    set({ deptIds: toArr(option), endCustomers: [], scmSiteIds: [] })
                  }
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00080', '_End Customer')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  useClearIcon
                  value={firstOr(sc.endCustomers)}
                  options={
                    endCustomerByDivision
                      // ⭐ cascade: Division + Team(DEPT_ID). EndCustomer 콤보가 DIVISION_ID/DEPT_ID 반환.
                      ?.filter(
                        item =>
                          (!item.DIVISION_ID || item.DIVISION_ID === sc.divisionId) &&
                          (!selDept || !item.DEPT_ID || item.DEPT_ID === selDept)
                      )
                      .map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, option) =>
                    // AS-IS clbCustomer_SelectedIndexChanged — 하위(Sales Site/Plant Site) cascade clear
                    set({ endCustomers: toArr(option), scmSiteIds: [], plantSiteIds: [] })
                  }
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00011', '_Sales Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  useClearIcon
                  value={firstOr(sc.scmSiteIds)}
                  options={
                    scmSiteByEndCustomer
                      // ⭐ cascade: Division + Team(DEPT_ID). 'SalesSite' 콤보가 DIVISION_ID/DEPT_ID 반환.
                      ?.filter(
                        item =>
                          (!item.DIVISION_ID || item.DIVISION_ID === sc.divisionId) &&
                          (!selDept || !item.DEPT_ID || item.DEPT_ID === selDept)
                      )
                      .map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, option) => set({ scmSiteIds: toArr(option) })}
                />
              )}
            />
          </Grid>

          {/* Row 2 — Period* / Bucket* / 체크박스 3종 (Figma Row2 1:1 — Search 버튼은 SearchArea 자체) */}
          <Grid size={3}>
            <FormItem
              label={t('LBL00013', '_Period')}
              labelAlign='right'
              render={() => (
                <div className={styles.datePickerFix}>
                  <DatePickerCalendar
                    sx={{ width: '100%' }}
                    usecase='date-range-multi'
                    elevation
                    size='large'
                    value={[dayjs(sc.startYyyymmdd, 'YYYYMMDD'), dayjs(sc.endYyyymmdd, 'YYYYMMDD')]}
                    onChange={date => {
                      const start = date?.[0] ? dayjs(date[0]).format('YYYYMMDD') : sc.startYyyymmdd;
                      const end = date?.[1] ? dayjs(date[1]).format('YYYYMMDD') : sc.endYyyymmdd;
                      set({ startYyyymmdd: start, endYyyymmdd: end });
                    }}
                  />
                </div>
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00710', '_Bucket')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={sc.bucketType}
                  options={bucketOptions}
                  onChange={(_, option) => set({ bucketType: option as BUCKET_TYPE })}
                />
              )}
            />
          </Grid>
          <Grid size={6}>
            <div className={styles.checkboxRow}>
              <Stack direction='row' spacing={2} alignItems='center'>
                {/* AS-IS chkSum — 상위 합계(M_/W_) 컬럼 표시 토글 (SetSpreadColumn, 조회 없이 즉시 반영) */}
                <Checkbox
                  labelText={t('LBL00687', '_Sum')}
                  checked={sc.sumYn}
                  onChange={checked => set({ sumYn: checked })}
                />
                {/* AS-IS chkColor — 과거(실적) 구간 회색 표시 (setResultPeriod, 조회 없이 즉시 반영) */}
                <Checkbox
                  labelText={t('LBL00688', '_Color')}
                  checked={sc.colorYn}
                  onChange={checked => set({ colorYn: checked })}
                />
                {/* AS-IS InternalYN — p_internal_yn (내부거래 포함, 조회 조건) */}
                <Checkbox
                  labelText={t('LBL00753', '_Include Internal Txn')}
                  checked={sc.internalYn}
                  onChange={checked => set({ internalYn: checked })}
                />
              </Stack>
            </div>
          </Grid>
        </>
      }
      extraConditions={
        <>
          {/* 확장 Row 3 — Item Type / Biz. Type / PJT🔍 / Model·Nickname🔍 (Figma 확장영역 1:1) */}
          <Grid size={3}>
            <FormItem
              label={t('LBL00068', '_Item Type')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  useClearIcon
                  value={firstOr(sc.itemTypes)}
                  options={itemType?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, option) => set({ itemTypes: toArr(option) })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00085', '_Biz. Type')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  useClearIcon
                  value={firstOr(sc.bizTypes)}
                  options={
                    bizType
                      ?.filter(item => !item.DIVISION_ID || item.DIVISION_ID === sc.divisionId)
                      .map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, option) => set({ bizTypes: toArr(option) })}
                />
              )}
            />
          </Grid>
          {/* PJT / Model·Nickname — 조회조건 표준 카탈로그(@master/searchFields) + 체크박스 멀티선택 popup
              (AS-IS txtProject+btnProject / txtItemId+btnItemId 1:1 — popup 은 카탈로그 필드 자체 관리) */}
          <ProjectField
            gridSize={3}
            value={sc.projectCodes}
            onChange={v => set({ projectCodes: v })}
            division={sc.divisionId}
            deptIds={sc.deptIds}
            endCustomers={sc.endCustomers}
            scmSiteIds={sc.scmSiteIds}
            projectCodes={sc.projectCodes}
            multiCheckbox
            disabled={isDiv40} // ⭐ AS-IS: Division 40 → Project 비활성
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

          {/* 확장 Row 4 — Plant Site / Owner🔍 (AS-IS clbPlantSite / txtOwner+btnOwner 1:1) */}
          <Grid size={3}>
            <FormItem
              label={t('LBL00005', '_Plant Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  useClearIcon
                  disabled={isDiv40} // ⭐ AS-IS: Division 40 → Plant Site 비활성
                  value={firstOr(sc.plantSiteIds)}
                  options={
                    plantSite
                      ?.filter(item => !item.DIVISION_ID || item.DIVISION_ID === sc.divisionId)
                      .map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, option) => set({ plantSiteIds: toArr(option) })}
                />
              )}
            />
          </Grid>
          <OwnerField
            gridSize={3}
            value={sc.owners}
            onChange={v => set({ owners: v })}
            division={sc.divisionId}
            deptIds={sc.deptIds}
            endCustomers={sc.endCustomers}
            scmSiteIds={sc.scmSiteIds}
            projectCodes={sc.projectCodes}
            owners={sc.owners}
            multiCheckbox
          />
        </>
      }
    />
  );
};
