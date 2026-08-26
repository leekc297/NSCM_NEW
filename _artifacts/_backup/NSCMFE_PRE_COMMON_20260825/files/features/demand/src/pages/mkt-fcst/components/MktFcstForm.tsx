import {
  BizTypeField,
  DivisionField,
  EndCustomerField,
  ItemField,
  OwnerField,
  PlantSiteField,
  PeriodField,
  ProjectField,
  SalesSiteField,
  TeamField,
} from 'features/master/src/components';
import { useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Checkbox, FormItem } from '@shared/lges';
import { Grid, Stack } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { BUCKET_TYPE, DIVISION, MSG } from '../mkt-fcst.constants';
import { useMktFcstStore } from '../useMktFcstStore';

interface MktFcstFormProps {
  onSearch: () => void;
  // ⭐ Insert 된 행 수 — Bucket 변경 가드(MSG00227)용. 신규 행 존재 시 버킷 변경 차단.
  insertedRowCount?: number;
}
export const MktFcstForm = ({ onSearch, insertedRowCount = 0 }: MktFcstFormProps) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const [bucketKey, setBucketKey] = useState(0);

  const sc = useMktFcstStore(s => s.searchCondition);
  const set = useMktFcstStore(s => s.setSearchCondition);
  const openSearchArea = useMktFcstStore(s => s.openSearchArea);

  // Division / Team / End Customer / Sales Site / Plant Site 는 SearchFields 카탈로그 필드가
  //   각자 조회한다 (콤보 통일 — MyDivision / TeambyDivision / EndCustomer / SalesSite /
  //   PlantSitebyEndCustomer). react-query 키가 같아 캐시를 공유하므로 네트워크 호출은 늘지 않는다.
  const [senderCode, itemType, bucketTypeCombo] = useTabComboQueries({
    filters: ['SenderCode', 'ItemType', 'BucketType'],
  });

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
    bucketTypeCombo && bucketTypeCombo.length > 0
      ? bucketTypeCombo
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

  // 멀티 select dropdown 값 (^ delim string[] ↔ 단일 string). 카탈로그 부재로 단일선택 + ALL 패턴 사용.
  const firstOr = (arr: string[]): string => arr[0] ?? '';
  const toArr = (v: string): string[] => (v ? [v] : []);

  return (
    <SearchArea
      isHidden={!openSearchArea}
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={onSearch}
      conditions={
        <>
          <DivisionField
            gridSize={3}
            value={sc.divisionId}
            onChange={option =>
              set({
                divisionId: option,
                deptIds: [],
                endCustomers: [],
                scmSiteIds: [],
                bizTypes: [],
                plantSiteIds: [],
                // Sender Code(81 전용) / Project(40 비활성) — division 변경 시 clear.
                senderCodes: [],
                projectCodes: [],
                itemIds: [],
                nickName: '',
                owners: [],
                itemTypes: [],
                // Cell Qty 는 Div 40 전용 (AS-IS L2107/2140: 비40 = Enabled=false + Checked=false).
                ...(option !== DIVISION.MOBILITY ? { cellQtyYn: false } : {}),
                // Invalid(MKT FCST 미등록 제외)는 Div82 전용 — 82 진입 시 기본 checked (AS-IS L469~477).
                invalidYn: option === DIVISION.ESS,
                // G4 — Bucket 기본값: 82(ESS)=Daily / 그 외=Weekly (v1.7 §3, AS-IS OnShown).
                bucketType: BUCKET_TYPE.WEEKLY,
                sumYn: false,
                qtyOverZero: false,
                asYn: false,
              })
            }
          />
          <TeamField
            gridSize={3}
            value={sc.deptIds}
            onChange={v =>
              set({
                deptIds: v,
                endCustomers: [],
                scmSiteIds: [],
                bizTypes: [],
                plantSiteIds: [],
                senderCodes: [],
                projectCodes: [],
                itemIds: [],
                nickName: '',
                owners: [],
                itemTypes: [],
                sumYn: false,
                qtyOverZero: false,
                cellQtyYn: false,
                invalidYn: false,
                asYn: false,
                bucketType: BUCKET_TYPE.WEEKLY,
              })
            }
            division={sc.divisionId}
          />
          {/* cascade = division-team-endCustomer. division 은 카탈로그 필드가 항상 먼저 걸므로
              여기엔 Team(DEPT_ID) 단계만 넘긴다.
              필수: strict. 'EndCustomer' 콤보는 DEPT_ID 공란 행이 대다수라(SITE_ITEM LEFT OUTER
                JOIN) 관대 매칭이면 Team 을 골라도 목록이 그대로 보인다. 종전 인라인 필터가
                DEPT_ID 를 엄격 비교하던 것과 같은 규칙이다 (2026-08-18 원복 건). */}
          <EndCustomerField
            gridSize={3}
            division={sc.divisionId}
            cascade={{ DEPT_ID: { values: sc.deptIds, strict: true } }}
            debugLabel='DMF0003 mkt-fcst / End Customer'
            value={sc.endCustomers}
            onChange={values =>
              set({
                // 하위 cascade 초기화 — Sales Site 는 PROJECT_CODE 단계로,
                // Plant Site 는 서버 바인드(@endCustomer)로 End Customer 에 종속된다.
                endCustomers: values,
                scmSiteIds: [],
                plantSiteIds: [],
              })
            }
          />
          {/* cascade = division-team-endCustomer-salesSite ('SalesSite' 콤보 반환 컬럼 기준).
              End Customer 는 이 콤보의 PROJECT_CODE 자리로 본다 — 콤보가 END_CUSTOMER 컬럼을
                내려주지 않기 때문이다. DMF0014 / DMF0044 와 동일한 매핑이다.
              DEPT_ID 는 엄격, PROJECT_CODE 는 관대 — PROJECT_CODE 가 NULL 인 행이 정상적으로
                존재해 자르면 목록이 통째로 비어버린다. */}
          <SalesSiteField
            gridSize={3}
            division={sc.divisionId}
            cascade={{
              DEPT_ID: { values: sc.deptIds, strict: true },
              PROJECT_CODE: sc.endCustomers,
            }}
            debugLabel='DMF0003 mkt-fcst / Sales Site'
            value={sc.scmSiteIds}
            onChange={values => set({ scmSiteIds: values })}
          />

          {/* Row 2 — Biz Type*(카탈로그) / Sender Code(81 전용 인라인) / Period*(카탈로그) / Bucket*(D 포함 인라인) */}
          <BizTypeField
            gridSize={3}
            value={sc.bizTypes}
            onChange={v => set({ bizTypes: v })}
            division={sc.divisionId}
            comboId='BizTypebyDivision'
          />
          <Grid size={3}>
            {/* ⭐ Sender Code — 81 계열 전용 enable (AS-IS clbEDISender Division==81 만 활성, .cs L469~).
                40/82 비활성 + Division 변경 시 clear(onChange 종속 reset). */}
            <FormItem
              label={t('LBL00090', '_Sender Code')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  allOption
                  useClearIcon
                  disabled={!sc.divisionId.startsWith('81')}
                  value={firstOr(sc.senderCodes)}
                  options={
                    senderCode
                      ?.filter(item => !item.DIVISION_ID || item.DIVISION_ID === sc.divisionId)
                      .map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                  }
                  onChange={(_, option) => set({ senderCodes: toArr(option) })}
                />
              )}
            />
          </Grid>
          <PeriodField
            gridSize={3}
            start={sc.startYyyymmdd}
            end={sc.endYyyymmdd}
            onChange={(start, end) => set({ startYyyymmdd: start, endYyyymmdd: end })}
          />
          <Grid size={3}>
            <FormItem
              label={t('LBL00710', '_Bucket')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  key={bucketKey}
                  isInput={false}
                  value={sc.bucketType}
                  options={bucketOptions}
                  onChange={(_, option) => {
                    // ⭐ Insert 된 행이 있으면 Bucket 변경 불가 (AS-IS cboBucketType_Click L5397, MSG00227).
                    if (insertedRowCount > 0) {
                      void setAlert({
                        type: 'alert',
                        content: t(
                          MSG.INSERT_ONLY_BUCKET,
                          '_Insert 된 행이 있어 Bucket 을 변경할 수 없습니다.'
                        ),
                      });
                      setBucketKey((k: number) => k + 1);
                      return;
                    }
                    set({ bucketType: option as BUCKET_TYPE });
                  }}
                />
              )}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
          {/* Plant Site — 콤보 'PlantSitebyEndCustomer'. 콤보는 파라미터 없이 전량을 내려주고
              Division + End Customer cascade 는 카탈로그 필드가 클라이언트에서 건다.
              Enable = 81 계열만 (40/82 비활성 — AS-IS 정합, PlantSiteField 기본 게이트). */}
          <PlantSiteField
            gridSize={3}
            division={sc.divisionId}
            endCustomer={sc.endCustomers.length > 0 ? sc.endCustomers.join(',') : undefined}
            debugLabel='DMF0003 mkt-fcst / Plant Site'
            value={sc.plantSiteIds}
            onChange={v => set({ plantSiteIds: v })}
          />
          <ProjectField
            gridSize={3}
            value={sc.projectCodes}
            onChange={v => set({ projectCodes: v })}
            division={sc.divisionId}
            deptIds={sc.deptIds}
            endCustomers={sc.endCustomers}
            scmSiteIds={sc.scmSiteIds}
            projectCodes={sc.projectCodes}
            disabled={sc.divisionId === DIVISION.MOBILITY}
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
              label={t('LBL00068', '_Item Type')}
              labelAlign='right'
              className={commonStyles.formItem}
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  value={sc.itemTypes.join(',')}
                  options={itemType?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                  onChange={(_, options) =>
                    set({
                      itemTypes: String(options ?? '')
                        .split(',')
                        .filter(Boolean),
                    })
                  }
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
          <Grid size={9} className={commonStyles.customGrid}>
            <div className={commonStyles.customCheckbox}>
              <Stack direction='row' spacing={2} alignItems='center'>
                <Checkbox
                  labelText={t('LBL00687', '_Sum')}
                  checked={sc.sumYn}
                  onChange={checked => set({ sumYn: checked })}
                />
                <Checkbox
                  labelText={t('LBL00689', '_Qty ≥ 0')}
                  checked={sc.qtyOverZero}
                  onChange={checked => set({ qtyOverZero: checked })}
                />
                {/* ⭐ B4 — Cell Qty 는 Div 40 전용 (AS-IS cboCellQty.Enabled — L445/2107). */}
                <Checkbox
                  labelText={t('LBL00690', '_Cell Qty')}
                  checked={sc.cellQtyYn}
                  disabled={sc.divisionId !== DIVISION.MOBILITY}
                  onChange={checked => set({ cellQtyYn: checked })}
                />
              </Stack>
            </div>
          </Grid>
        </>
      }
    />
  );
};
