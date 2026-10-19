import {
  CascadeFields,
  ItemField,
  OwnerField,
  PeriodField,
  ProjectField,
  useCascadeFields,
} from 'features/master/src/components';
import { useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Checkbox, FormItem } from '@shared/lges';
import { Grid, Stack } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import {
  BIZ_TYPE_CASCADE_COMBO_ID,
  BUCKET_TYPE,
  DIVISION,
  MSG,
  PLANT_SITE_CASCADE_COMBO_ID,
  SEARCH_CASCADE_COMBO_ID,
  SENDER_CASCADE_COMBO_ID,
} from '../mkt-fcst.constants';
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

  // cascade 조회조건 셋팅법(prop 설명 포함)은 CascadeFields.tsx 파일 헤더에 정리돼 있다.
  // 이 화면에는 그 4벌(CascadeFields 1 + useCascadeFields 3)이 다 들어 있어 예시로 보기 좋다.

  // Division / Team / End Customer / Sales Site 는 아래 CascadeFields 가 조인 콤보 1건으로 받는다.
  //   Plant Site / Sender Code 는 그 갈래가 아니라 각기 다른 콤보의 마지막 단계다
  //   (plantSiteCascade / senderCascade 참조).
  const [itemType, bucketTypeCombo] = useTabComboQueries({
    filters: ['ItemType', 'BucketType'],
  });

  // Plant Site 는 Sales Site 의 하위가 아니라 Div - Team - End Customer 에서 갈라지는 별개 가지다.
  // 콤보도 따로 등록돼 있고(4단 조인 형태는 같다) 상위 3단 값만 공유한다.
  //   - 상위 3단은 필터로만 쓰고 렌더하지 않는다. 화면에는 마지막 단계만 꽂는다.
  //   - 활성 기준은 81 계열 전용 (AS-IS 정합 — 종전 PlantSiteField 기본 게이트와 동일).
  //   - 콤보 컬럼은 표준 규약(DIVISION_CODE / TEAM_CODE / END_CUSTOMER / PLANT_SITE_CODE)이라
  //     columns 를 따로 지정하지 않는다.
  const plantSiteEnabled = sc.divisionId.startsWith('81');
  const plantSiteCascade = useCascadeFields({
    comboId: PLANT_SITE_CASCADE_COMBO_ID,
    // 임시 로컬 디버그 - 콤보 실제 컬럼명과 단계별 잔여 행 수를 콘솔에 찍는다.
    // 컬럼명이 규약과 맞는지 확인되면 이 줄을 지운다.
    debugLabel: 'MktFcst-PlantSite',
    gridSize: 3,
    enabled: plantSiteEnabled,
    levels: [
      { key: 'division', field: 'divisionId' },
      { key: 'team', field: 'deptIds' },
      { key: 'endCustomer', field: 'endCustomers' },
      { key: 'plantSite', field: 'plantSiteIds', disabled: !plantSiteEnabled, sortBy: 'label' },
    ],
    value: sc,
    onChange: next => set(next),
  });

  // Sender Code 도 Plant Site 와 같은 별개 가지다. 단 3단(Div - Team - Sender)이다.
  //   - 상위 2단은 필터로만 쓰고 렌더하지 않는다. 화면에는 마지막 단계만 꽂는다.
  //   - 활성 기준은 81 계열 전용 (AS-IS clbEDISender Division==81 만 활성, .cs L469~).
  //   - 콤보 컬럼은 표준 규약(DIVISION_CODE / TEAM_CODE / SENDER_CODE / SENDER_NAME)이라
  //     columns 를 따로 지정하지 않는다. 종전 DIVISION_ID / DEPT_ID / SENDER_CODE_NAME 지정은
  //     콤보 SQL 이 풀네임으로 개정되면서 오히려 목록을 비우는 원인이 됐다.
  const senderEnabled = sc.divisionId.startsWith('81');
  const senderCascade = useCascadeFields({
    comboId: SENDER_CASCADE_COMBO_ID,
    gridSize: 3,
    enabled: senderEnabled,
    levels: [
      { key: 'division', field: 'divisionId' },
      { key: 'team', field: 'deptIds' },
      { key: 'senderCode', field: 'senderCodes', disabled: !senderEnabled },
    ],
    value: sc,
    onChange: next => set(next),
  });

  // Biz Type 도 Division 에서 갈라지는 별개 가지다. 2단(Div - Biz Type)이라 단계는 짧지만
  // 구조는 위 둘과 같다.
  //   - division 은 필터로만 쓰고 렌더하지 않는다. 화면에는 마지막 단계만 꽂는다.
  //   - 종전 BizTypeField(comboId='BizTypebyDivision') 가 DIVISION_ID 를 클라이언트에서 걸던
  //     것과 동작이 같다. 콤보만 조인 형태로 바뀌었다.
  //   - 콤보 컬럼은 표준 규약(DIVISION_CODE / DIVISION_NAME + BIZ_TYPE_CODE / BIZ_TYPE_NAME)이라
  //     columns 를 따로 지정하지 않는다.
  const bizTypeCascade = useCascadeFields({
    comboId: BIZ_TYPE_CASCADE_COMBO_ID,
    gridSize: 3,
    levels: [
      { key: 'division', field: 'divisionId' },
      { key: 'bizType', field: 'bizTypes' },
    ],
    value: sc,
    onChange: next => set(next),
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

  return (
    <SearchArea
      isHidden={!openSearchArea}
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division - Team - End Customer - Sales Site 는 조인 콤보 1건에서 뽑는다.
              단계 옵션은 상위 선택으로 좁힌 행에서 나오고, 하위 단계 값 초기화도 컴포넌트가 한다.
              한 SQL 결과라 모든 행에 4단 컬럼이 다 차 있어 strict / 관대 분기 자체가 없다
              (종전 EndCustomer 콤보의 DEPT_ID 공란 행 문제 — 2026-08-18 원복 건).
              화면 고유 조회조건 초기화만 아래 onChange 에서 얹는다. */}
          <CascadeFields
            comboId={SEARCH_CASCADE_COMBO_ID}
            gridSize={3}
            levels={[
              { key: 'division', field: 'divisionId' },
              { key: 'team', field: 'deptIds', sortBy: 'label' },
              { key: 'endCustomer', field: 'endCustomers', sortBy: 'label' },
              { key: 'salesSite', field: 'scmSiteIds', sortBy: 'label' },
            ]}
            value={sc}
            onChange={(next, changed) => {
              if (changed === 'division') {
                const division = next.divisionId ?? '';
                set({
                  ...next,
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
                  ...(division !== DIVISION.MOBILITY ? { cellQtyYn: false } : {}),
                  // Invalid(MKT FCST 미등록 제외)는 Div82 전용 — 82 진입 시 기본 checked (AS-IS L469~477).
                  invalidYn: division === DIVISION.ESS,
                  // G4 — Bucket 기본값: 82(ESS)=Daily / 그 외=Weekly (v1.7 3장, AS-IS OnShown).
                  bucketType: BUCKET_TYPE.WEEKLY,
                  sumYn: false,
                  qtyOverZero: false,
                  asYn: false,
                });
                return;
              }
              if (changed === 'team') {
                set({
                  ...next,
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
                });
                return;
              }
              // Plant Site 는 별개 콤보(plantSiteCascade)라 이 cascade 가 하위로 안 비운다.
              // End Customer 가 바뀌면 여기서 직접 비운다.
              if (changed === 'endCustomer') {
                set({ ...next, plantSiteIds: [] });
                return;
              }
              set(next);
            }}
          />

          {/* Row 2 — Biz Type / Sender Code (각기 별개 cascade) / Period*(카탈로그) / Bucket*(인라인) */}
          {/* Biz Type — Division 에서 갈라지는 별개 조인 콤보의 마지막 단계다.
              Division 변경 시 clear 는 위 CascadeFields onChange 가 이미 하고 있다. */}
          {bizTypeCascade.field('bizType')}
          {/* Sender Code — Div - Team 에서 갈라지는 별개 조인 콤보의 마지막 단계다.
              81 계열 전용 활성은 senderCascade 의 disabled / enabled 가 맡고,
              Division / Team 변경 시 clear 는 위 CascadeFields onChange 가 이미 하고 있다. */}
          {senderCascade.field('senderCode')}
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
          {/* Plant Site — 위 4단과 같은 조인 콤보 형태지만 등록 ID 가 다른 별개 가지다.
              Div - Team - End Customer 선택으로 좁히고, Sales Site 선택과는 무관하다. */}
          {plantSiteCascade.field('plantSite')}
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
