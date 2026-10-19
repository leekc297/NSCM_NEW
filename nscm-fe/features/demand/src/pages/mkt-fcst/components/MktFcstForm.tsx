import {
  ItemField,
  OwnerField,
  PeriodField,
  ProjectField,
  buildComboOptions,
} from 'features/master/src/components';
import { useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Checkbox, FormItem } from '@shared/lges';
import { Grid, Stack } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useMessageStore, useTabid } from '@shared/stores';

import { BUCKET_TYPE, DIVISION, MSG } from '../mkt-fcst.constants';
import { useMktFcstStore } from '../useMktFcstStore';
import { SEARCH_COMBO, buildSalesSiteComboParam } from '../utils/mkt-fcst.searchCombos';

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

  // Division 변경은 그리드를 비운다(MktFcst.tsx division 변경 effect — clearChanges/clearFilters/
  //   removeQueries). 편집중(dirty)이면 MSG00704 confirm 후에만 바꾼다 — 조회 공통 가드
  //   confirmIfDirtyKey(..., 'search')를 콤보 변경에도 동일 적용. controlled 콤보라 취소 시 자동 복귀.
  const tabId = useTabid();

  /**
   * 조회조건 콤보는 8종이 필터다 (문서 §1). 이 화면이 BigFilter 적용 범위가 가장 넓다 -
   * list_line_dm 결과셋 9개 중 8개를 쓴다. 파라미터 없이 전량을 한 번 받고 좁히는 일은 화면이
   * 한다. 원천·축·AS-IS 라인은 utils/mkt-fcst.searchCombos 참조.
   *
   * Item Type 과 Bucket 만 그 밖의 재조회이며 현행 콤보 ID 를 그대로 쓴다.
   */
  const [
    divisions,
    teams,
    endCustomerRows,
    bizType,
    plantSites,
    senderCodeRows,
    itemType,
    bucketTypeCombo,
  ] = useTabComboQueries({
    filters: [
      SEARCH_COMBO.division,
      SEARCH_COMBO.team,
      SEARCH_COMBO.endCustomer,
      SEARCH_COMBO.bizType,
      SEARCH_COMBO.plantSite,
      SEARCH_COMBO.senderCode,
      'ItemType',
      'BucketType',
    ],
  });

  // 전체선택 해제 결과가 ['ALL'] 로 내려올 수 있어 하위 판정 전에 걸러낸다.
  const deptIds = sc.deptIds.filter(v => v !== 'ALL');
  const endCustomers = sc.endCustomers.filter(v => v !== 'ALL');

  const divisionOptions = buildComboOptions(divisions);
  const teamOptions = buildComboOptions(teams, { division: sc.divisionId });
  const bizTypeOptions = buildComboOptions(bizType, { division: sc.divisionId });

  // End Customer 목록 = Division + Team. DEPT_ID 는 엄격 매칭이다 - 이 콤보는 공란 행이 많아
  //   관대하게 두면 Team 을 골라도 목록이 그대로다. 40 은 실제 값이 Project Code 다(문서 §4-1).
  const endCustomerOptions = buildComboOptions(endCustomerRows, {
    division: sc.divisionId,
    narrow: { column: 'DEPT_ID', codes: deptIds },
  });

  /**
   * Sales Site 는 재조회다 - 사업부로 두 갈래(81 계열·82 / 40 등)이며 목록 구성 조건을 전부
   * 파라미터로 실으므로 하나라도 바뀌면 SQL 이 다시 나간다.
   *
   * AS-IS 는 조작 경로별로 필터/재조회가 다섯 갈래로 갈리지만 필터 원천의 DEPT_ID 가 사내
   * 데이터에서 NULL 이 대부분이라 클라이언트 축으로는 목록을 만들지 못한다 - 근거와 잃는 것은
   * utils/mkt-fcst.searchCombos 헤더 참조(2026-08-29 사용자 확정).
   */
  const [salesSiteRows] = useTabComboQueries({
    filters: [buildSalesSiteComboParam({ divisionId: sc.divisionId, deptIds, endCustomers })],
  });
  // 재조회 응답은 서버가 이미 좁혀 CODE / NAME 만 내려준다 - 축을 걸면 전 행이 잘린다.
  const salesSiteOptions = buildComboOptions(salesSiteRows);

  /**
   * Plant Site 는 Division 으로만 좁힌다. End Customer 는 걸지 않는다.
   *
   * 문서 §1 은 "Division + End Customer" 로 적혀 있으나 그건 SetChangeControl 시그니처상의
   * 자리일 뿐, AS-IS 에서 실제로 고객 값이 실리는 경로가 없다.
   *   - End Customer 변경 핸들러(:3204-3215)는 Sales Site 만 다시 만든다. Plant Site 는 안 만든다.
   *   - 다시 만드는 두 곳(진입 :527 / Division 변경 :3124)은 직전에 고객 목록을 전체선택으로
   *     새로 채운 직후라 ControlValues 가 'ALL' 이고, GetDMInnerTable 진입부가 ''로 치환해
   *     END_CUSTOMER 축이 꺼진다.
   *
   * 데이터도 같은 결론이다 - FilterPlantSiteByEndCustomer(#6)는 SITE_TYPE='PLANT' 행이라
   * END_CUSTOMER 가 대부분 NULL 이다. 엄격 매칭으로 걸면 목록이 통째로 빈다(2026-08-29 실측).
   *
   * 81 계열 전용이며 그 밖에는 잠근다.
   */
  const plantSiteEnabled = sc.divisionId.startsWith('81');
  const plantSiteOptions = buildComboOptions(plantSites, { division: sc.divisionId });

  // Sender Code 는 단순 호출이다 - FilterEdiSender(#7)는 CODE / NAME 만 내려주고 SQL 자체가
  //   81 사업부로 고정돼 있어 걸 축이 없다. 활성 기준만 화면이 판단한다.
  //   AS-IS 정합: Division 이 정확히 "81" 일 때만 활성(:479/:2188). Division 변경 시 목록 자체는
  //   사업부 무관하게 채워지지만(:2093~) 활성화는 == "81" 에서만 켠다. 81 계열(81_HD 등)은 비활성.
  const senderEnabled = sc.divisionId === DIVISION.AUTOMOTIVE;
  const senderCodeOptions = buildComboOptions(senderCodeRows);

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
          {/* Division 변경 = 종속 조회조건 전면 reset (AS-IS cboDivision_SelectedIndexChanged :3019~). */}
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
                  onChange={(_, picked) => {
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (!ok) return;
                      const division = String(picked ?? '');
                      set({
                        divisionId: division,
                        deptIds: [],
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
                        // Cell Qty 는 Div 40 전용 (AS-IS L2107/2140: 비40 = Enabled=false + Checked=false).
                        ...(division !== DIVISION.MOBILITY ? { cellQtyYn: false } : {}),
                        // Invalid(MKT FCST 미등록 제외)는 Div82 전용 — 82 진입 시 기본 checked (AS-IS L469~477).
                        invalidYn: division === DIVISION.ESS,
                        // G4 — Bucket 기본값: 82(ESS)=Daily / 그 외=Weekly (v1.7 3장, AS-IS OnShown).
                        bucketType: BUCKET_TYPE.WEEKLY,
                        // Sum / Qty ≥ 0 은 division 변경 시 초기화하지 않는다
                        // (AS-IS cboDivision_SelectedIndexChanged :3019~3164 도 chkSum/chkQty 를 건드리지 않는다).
                        asYn: false,
                      });
                    });
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
            v =>
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
                // Sum / Qty ≥ 0 은 Team 변경 시 초기화하지 않는다
                // (AS-IS clbTeam_SelectedIndexChanged :3166~3202 도 chkSum/chkQty 를 건드리지 않는다).
                cellQtyYn: false,
                // Invalid(MKT FCST 미등록 제외)는 Div82 전용 기본 checked — Team 변경 시에도
                //   82 면 유지한다(82 는 항상 checked). 그 외 division 은 초기화.
                invalidYn: sc.divisionId === DIVISION.ESS,
                asYn: false,
                bucketType: BUCKET_TYPE.WEEKLY,
              }),
            { sortBy: 'label' }
          )}
          {/* 40 은 이 칸의 실제 값이 Project Code 다 - FilterEndCustomerByDivision(#2)의 40 분기가
              PROJECT_CODE 를 CODE 로 쓴다(문서 §4-1).
              AS-IS clbCustomer_SelectedIndexChanged (:3186) — 변경 시 Sales Site 를 재조회한다. */}
          {multiField(
            'LBL00080',
            'End Customer',
            sc.endCustomers,
            endCustomerOptions,
            v => set({ endCustomers: v, scmSiteIds: [], plantSiteIds: [] }),
            { sortBy: 'label' }
          )}
          {multiField(
            'LBL00011',
            'Sales Site',
            sc.scmSiteIds,
            salesSiteOptions,
            v => set({ scmSiteIds: v }),
            { sortBy: 'label' }
          )}

          {/* Row 2 — Biz Type / Sender Code(81 계열 전용) / Period*(카탈로그) / Bucket*(인라인) */}
          {/* Biz Type — FilterBizType(#3). 40 lookup 과 사업부별 목록을 UNION 으로 합쳐 내려주고
              40 행에 DIVISION_ID='40' 이 박혀 있어 한 축으로 좁히면 된다 (AS-IS :3052 · :3070). */}
          {multiField(
            'LBL00085',
            'Biz. Type',
            sc.bizTypes,
            bizTypeOptions,
            v => set({ bizTypes: v }),
            { sortBy: 'label' }
          )}
          {/* Sender Code — FilterEdiSender(#7). 단순 호출이라 걸 축이 없다(위 주석 참조).
              Division / Team 변경 시 clear 는 위 onChange 가 이미 하고 있다. */}
          {multiField(
            'LBL00090',
            'Sender Code',
            sc.senderCodes,
            senderCodeOptions,
            v => set({ senderCodes: v }),
            { sortBy: 'label', disabled: !senderEnabled }
          )}
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
          {/* Plant Site — FilterPlantSiteByEndCustomer(#6). Sales Site 의 하위가 아니라
              End Customer 에서 나란히 갈라진다. 팀은 걸지 않는다(AS-IS :526 · :3074 팀 자리 빈 값). */}
          {multiField(
            'LBL00005',
            'Plant Site',
            sc.plantSiteIds,
            plantSiteOptions,
            v => set({ plantSiteIds: v }),
            { sortBy: 'label', disabled: !plantSiteEnabled }
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
