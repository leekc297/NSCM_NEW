import {
  BizTypeField,
  DivisionField,
  ItemField,
  OwnerField,
  PlantSiteField,
  PeriodField,
  ProjectField,
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

import styles from './MktFcstForm.module.scss';

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

  const [
    senderCode,
    itemType,
    bucketTypeCombo,
    endCustomerCombo,
    siteByEndCustomer,
    userSiteByEndCustomer,
  ] = useTabComboQueries({
    filters: [
      'SenderCode',
      'ItemType',
      'BucketType',
      'EndCustomerByDivision',
      'SiteByEndCustomer',
      'UserSiteByEndCustomer',
    ],
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

  const deptIds: string[] = sc.deptIds.filter((v: string) => v !== 'ALL');
  const endCustomers: string[] = sc.endCustomers.filter((v: string) => v !== 'ALL');

  const endCustomerOptions = [
    ...new Map(
      (endCustomerCombo ?? [])
        .filter(
          item =>
            item.DIVISION_ID === sc.divisionId &&
            (deptIds.length === 0 || deptIds.includes(item.DEPT_ID ?? ''))
        )
        .map(item => [item.CODE, item] as const)
    ).values(),
  ].map(item => ({ label: item.NAME, value: item.CODE }));

  const toSiteOptions = (
    rows: Array<Record<string, unknown>> | undefined,
    divisionId?: string,
    deptIds?: string[],
    endCustomers?: string[]
  ) => {
    const arr = (rows ?? []) as unknown as Array<Record<string, string>>;
    const selectedDepts = new Set(deptIds ?? []);
    const selectedCustomers = new Set(endCustomers ?? []);
    const hasEndCustomerColumn = arr.some(r => (r.END_CUSTOMER ?? '').trim() !== '');
    return [
      ...new Map(
        arr
          .filter(r => {
            if (divisionId && r.DIVISION_ID && r.DIVISION_ID !== divisionId) return false;
            if (selectedDepts.size > 0 && r.DEPT_ID && !selectedDepts.has(r.DEPT_ID)) return false;
            if (!hasEndCustomerColumn) return true;
            const endCustomer = (r.END_CUSTOMER ?? '').trim();
            if (endCustomer === '') return false;
            return selectedCustomers.size === 0 || selectedCustomers.has(endCustomer);
          })
          .map(r => [`${r.DIVISION_ID ?? ''}|${r.CODE ?? ''}`, r] as const)
      ).values(),
    ].map(r => ({ label: String(r.NAME ?? r.CODE ?? ''), value: String(r.CODE ?? '') }));
  };

  const siteRows = sc.divisionId === DIVISION.MOBILITY ? userSiteByEndCustomer : siteByEndCustomer;
  const salesSiteOptions = toSiteOptions(siteRows as never, sc.divisionId, deptIds, endCustomers);

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
              })
            }
          />
          <TeamField
            gridSize={3}
            value={sc.deptIds}
            onChange={v => set({ deptIds: v, endCustomers: [], scmSiteIds: [] })}
            division={sc.divisionId}
            comboId='UserTeamByDivision'
          />
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
                  value={sc.endCustomers.join(',')}
                  options={endCustomerOptions}
                  onChange={(_, selected) =>
                    set({
                      endCustomers: String(selected ?? '')
                        .split(',')
                        .filter(Boolean),
                      scmSiteIds: [],
                    })
                  }
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <div className={styles.salesSiteCell}>
              <FormItem
                label={t('LBL00011', '_Sales Site')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    useClearIcon
                    limitTags={1}
                    value={sc.scmSiteIds.join(',')}
                    options={salesSiteOptions}
                    onChange={(_, options) =>
                      set({
                        scmSiteIds: String(options ?? '')
                          .split(',')
                          .filter(Boolean),
                      })
                    }
                  />
                )}
              />
            </div>
          </Grid>

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
          <PlantSiteField
            gridSize={3}
            value={sc.plantSiteIds}
            onChange={v => set({ plantSiteIds: v })}
            division={sc.divisionId}
            endCustomer={sc.endCustomers.length > 0 ? sc.endCustomers.join(',') : undefined}
          />
          <Grid size={3}>
            <FormItem
              label={t('LBL00068', '_Item Type')}
              labelAlign='right'
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
