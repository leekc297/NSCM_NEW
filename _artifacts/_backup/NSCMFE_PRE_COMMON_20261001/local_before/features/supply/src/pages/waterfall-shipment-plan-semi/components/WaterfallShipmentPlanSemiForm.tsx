import { ItemByDivisionModal, PeriodField } from 'features/master/src/components';
import { useEffect, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { useWaterfallShipmentPlanSemiStore } from '../useWaterfallShipmentPlanSemiStore';
import { BUCKET_TYPE, LBL, MSG } from '../waterfall-shipment-plan-semi.constants';

// SCP0018 조회조건 — 02_search-combo.md §5 TO-BE 매핑 그대로.
//   conditions(메인 6): Division/OperationGroup/Model/Bucket/Version/Period
//   extraConditions(F6 펼침 2): ElectrodeType/Sum — 사용빈도 낮은 보조조건 판단(§5, 확인 필요 §7#8).
//   OperationGroup 은 useCascadeFields 미사용 — 트리거별 SQL_ID 자체가 다르다(§2.3 이중 데이터소스,
//   초기 LookupCommon(OPERATION_GROUP_SEMI[_EE]) → division onChange 시 OperationGroup[EE]_SCP 로 전환).

interface WaterfallShipmentPlanSemiFormProps {
  onSubmit: () => void;
  /** Division 변경 = 그리드 초기화(nscm-patterns.md §5-5). */
  onDivisionChange?: () => void;
}

export const WaterfallShipmentPlanSemiForm = ({
  onSubmit,
  onDivisionChange,
}: WaterfallShipmentPlanSemiFormProps) => {
  const { t } = useTranslation();

  const searchParams = useWaterfallShipmentPlanSemiStore(state => state.searchParams);
  const setSearchParams = useWaterfallShipmentPlanSemiStore(state => state.setSearchParams);
  const isOpenSearchArea = useWaterfallShipmentPlanSemiStore(state => state.isOpenSearchArea);
  const hasDivisionAuth = useWaterfallShipmentPlanSemiStore(state => state.hasDivisionAuth);
  const divisionAuthChecked = useWaterfallShipmentPlanSemiStore(state => state.divisionAuthChecked);
  const setDivisionAuth = useWaterfallShipmentPlanSemiStore(state => state.setDivisionAuth);
  const { setAlert } = useMessageStore();

  const [itemModalOpen, setItemModalOpen] = useState(false);

  const isEE = searchParams.divisionId.trim().toUpperCase().startsWith('EE');

  // Division — MyDivisionInEE_SCP(cascade 루트, EE 포함 — 02_search-combo.md §2.1).
  const [divisions, bucketTypes, versions, electrodeTypes] = useTabComboQueries({
    filters: [
      'MyDivisionInEE_SCP',
      'BucketISO_SCP',
      { comboId: 'WaterfallVer_FG2_SCP', divisionId: searchParams.divisionId },
      { comboId: 'LookupCommon', lookupType: 'ELECTRODE_TYPE' },
    ],
  });

  // OperationGroup — 이중 SQL_ID(§2.3). 초기 로드(division 미변경)는 LookupCommon(division 접두
  //   기준 SEMI/SEMI_EE 코드 분기), division 변경 이벤트는 OperationGroup[EE]_SCP 로 전환한다.
  //   이 화면 전용 개별 훅 배선 — useCascadeFields 는 "조인된 평면 콤보 1건" 전제라 안 맞는다(§5).
  const [initialOperGroup, cascadeOperGroup] = useTabComboQueries({
    filters: [
      { comboId: 'LookupCommon', lookupType: isEE ? 'OPERATION_GROUP_SEMI_EE' : 'OPERATION_GROUP_SEMI' },
      { comboId: isEE ? 'OperationGroupEE_SCP' : 'OperationGroup_SCP', divisionId: searchParams.divisionId },
    ],
  });
  // 최초 진입(division 값이 아직 한 번도 안 바뀐 상태)은 LookupCommon 후보, division 변경 이후는
  //   재조회 SQL_ID 후보로 전환 — divisionTouched 로 두 트리거를 구분한다(§2.3 실측 비등가 재현).
  const [divisionTouched, setDivisionTouched] = useState(false);
  const operGroupOptions = (divisionTouched ? cascadeOperGroup : initialOperGroup ?? cascadeOperGroup)?.map(
    item => ({ label: item.NAME, value: item.CODE })
  ) ?? [];

  // 01_layout.md §2 트리거C — dtDivision.Rows.Count==0(조회 가능 Division 0건) 이면 조회조건
  //   영역 전체 비활성 + MSG00097 안내. divisions 콤보 응답이 처음 도착한 시점에 1회 판정한다.
  useEffect(() => {
    if (divisions === undefined || divisionAuthChecked) return;
    const hasAuth = divisions.length > 0;
    setDivisionAuth(hasAuth);
    if (!hasAuth) {
      void setAlert({ type: 'alert', content: t(MSG.DIVISION_NO_AUTH, '_No Division available.') });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisions, divisionAuthChecked]);

  const divisionOptions = (divisions ?? []).map(item => ({ label: item.NAME, value: item.CODE }));
  const bucketOptions = (bucketTypes ?? []).map(item => ({ label: item.NAME, value: item.CODE }));
  const versionOptions = (versions ?? []).map(item => ({ label: item.NAME, value: item.CODE }));
  const electrodeOptions = (electrodeTypes ?? []).map(item => ({ label: item.NAME, value: item.CODE }));

  // Version 선택 변경 시 Period 파생 재계산 — GetDayRange() 서버 재조회 없음(§3). 확인 필요(§7#5 필수값 기준)
  //   — 잠정: 최근 선택 버전의 'SP_W_YYYYMMDD' 접두 8자리를 기간 시작값으로 파생.
  useEffect(() => {
    const last = searchParams.versionNos[searchParams.versionNos.length - 1];
    if (!last) return;
    const match = /SP_W_(\d{8})/.exec(last);
    if (!match) return;
    setSearchParams({ startYyyymmdd: match[1] });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [searchParams.versionNos]);

  // 01_layout.md §2 트리거C — 조회 가능 Division 0건이면 조회조건 영역 전체 비활성.
  //   SearchArea 자체는 disabled prop 이 없어 필드 단위로 게이트한다.
  const areaDisabled = !hasDivisionAuth;

  return (
    <>
      <SearchArea
        searchButtonLabel={t('LBL00112', '_Search')}
        isHidden={!isOpenSearchArea}
        onSearch={onSubmit}
        sx={{ flexShrink: 0 }}
        conditions={
          <>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.DIVISION, 'Division')}
                labelAlign='right'
                required
                render={() => (
                  <CustomDropdown
                    isInput={false}
                    disabled={areaDisabled}
                    value={searchParams.divisionId}
                    options={divisionOptions}
                    onChange={(_, option) => {
                      const picked = String(option ?? '');
                      if (picked === searchParams.divisionId) return;
                      setDivisionTouched(true);
                      setSearchParams({ divisionId: picked, operationGroup: '' });
                      onDivisionChange?.();
                    }}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.OPERATION_GROUP, 'Operation group')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    isInput={false}
                    disabled={areaDisabled}
                    value={searchParams.operationGroup}
                    options={operGroupOptions}
                    onChange={(_, option) => setSearchParams({ operationGroup: String(option ?? '') })}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.MODEL, 'Model')}
                labelAlign='right'
                render={() => (
                  <InputField
                    fullWidth
                    className={commonStyles.popupSearchField}
                    disabled={areaDisabled}
                    value={searchParams.itemId}
                    onChange={e => setSearchParams({ itemId: e.target.value })}
                    InputProps={{
                      endAdornment: (
                        <Button
                          appearance='outlined'
                          priority='normal'
                          disabled={areaDisabled}
                          iconComponent={
                            <FunctionSearchIcon appearance='lined' onClick={() => setItemModalOpen(true)} />
                          }
                        />
                      ),
                    }}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.BUCKET, 'Bucket')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    isInput={false}
                    disabled={areaDisabled}
                    value={searchParams.bucket}
                    options={bucketOptions}
                    onChange={(_, option) => setSearchParams({ bucket: String(option ?? BUCKET_TYPE.DAILY) })}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.VERSION, 'Version')}
                labelAlign='right'
                required
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    useClearIcon
                    limitTags={1}
                    disabled={areaDisabled}
                    value={searchParams.versionNos.join(',')}
                    options={versionOptions}
                    onChange={(_, picked) =>
                      setSearchParams({
                        versionNos: String(picked ?? '')
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
              label={t(LBL.PERIOD, 'Period')}
              start={searchParams.startYyyymmdd}
              end={searchParams.endYyyymmdd}
              onChange={(start, end) => setSearchParams({ startYyyymmdd: start, endYyyymmdd: end })}
            />
          </>
        }
        extraConditions={
          <>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.ELECTRODE, 'Electrode')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    allOption
                    useClearIcon
                    limitTags={1}
                    // division=EE 초기값 기준 활성 — division 변경으로 재평가되지 않는다(AS-IS 그대로,
                    //   02_search-combo.md §3/§7#2 사용자 확인 대상 — __asis-mapping__.md 참조).
                    disabled={areaDisabled || !isEE}
                    value={searchParams.electrodeTypes.join(',')}
                    options={electrodeOptions}
                    onChange={(_, picked) =>
                      setSearchParams({
                        electrodeTypes: String(picked ?? '')
                          .split(',')
                          .filter(Boolean),
                      })
                    }
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={' '}
                labelAlign='right'
                // 01_layout.md §2 트리거D — WEEKLY_ISO 면 완전 숨김(Never), 그 외 Always.
                render={() =>
                  searchParams.bucket === BUCKET_TYPE.WEEKLY_ISO ? (
                    <></>
                  ) : (
                    <Checkbox
                      labelText={t(LBL.SUM, 'Sum')}
                      disabled={areaDisabled}
                      checked={searchParams.isSumChecked}
                      onChange={checked => setSearchParams({ isSumChecked: checked })}
                    />
                  )
                }
              />
            </Grid>
          </>
        }
      />
      {itemModalOpen && (
        <ItemByDivisionModal
          open={itemModalOpen}
          modalClose={() => setItemModalOpen(false)}
          setSelectedValue={items => setSearchParams({ itemId: items })}
          preSearchParams={{ divisionId: searchParams.divisionId }}
          callFromCell={false}
        />
      )}
    </>
  );
};
