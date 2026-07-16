import { DivisionField, PeriodField } from 'features/master/src/components';

import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid, Stack } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { BUCKET_TYPE, MSG, PERIOD_PRESET_WEEKS } from '../production-plan-line.constants';
import { useProductionPlanLineStore } from '../useProductionPlanLineStore';

import styles from './ProductionPlanLineForm.module.scss';

interface ProductionPlanLineFormProps {
  onSearch: () => void;
}

// AS-IS SCP0013 조회조건 15 + 체크박스 3 (.cs InitControls/Designer 실측 2026-07-13).
//   ⭐ 레이아웃(사용자 지시 2026-07-13): 1행 4개(gridSize=3) — conditions 2단 + extraConditions(펼치기/닫기),
//     체크박스 3종(ALL/Line Assign/Sum)은 조회조건 맨 마지막, Bucket 우측에 W26/W52 프리셋 버튼.
//   ⭐ hook #94 — 모든 객체 36px.
//   데이터 소스: Division=표준 카탈로그(MyDivision) / CellTypeGr·Bucket=CMBO 등록분(실측 존재).
//   ⚠️ OperationGroup/Electrode/ExtraSpec/PlantSite/Line/PlanDate/PlanType/PlanSeq 콤보는 사내 CMBO
//     미등록(AS-IS Data_SCP.CommonAll 선캐싱) — SP 변환 단계에서 CMBO 등록 후 filters 키만 연결하면
//     활성화되는 구조로 배선(가짜 옵션 생성 금지 — 등록 전엔 빈 옵션).
//     차단 handoff: _artifacts/_apply_corporate/A5_scp0013_phase0_sp_blocked_handoff.md
export const ProductionPlanLineForm = ({ onSearch }: ProductionPlanLineFormProps) => {
  const { t } = useTranslation();

  const setAlert = useMessageStore.getState().setAlert;

  const sc = useProductionPlanLineStore(s => s.searchCondition);
  const set = useProductionPlanLineStore(s => s.setSearchCondition);
  const openSearchArea = useProductionPlanLineStore(s => s.openSearchArea);

  // 등록 CMBO 실측(2026-07-13): CellType / BucketType 존재. 나머지는 SP 변환 단계 등록 예정.
  const [cellTypeCombo, bucketTypeCombo] = useTabComboQueries({
    filters: ['CellType', 'BucketType'],
  });

  // Bucket 옵션 — CMBO 'BucketType' (CODE=DAILY/WEEKLY/MONTHLY 풀워드, AS-IS p_bucket 1:1).
  const bucketFallback = [
    { label: t('LBL00682', '_Daily'), value: BUCKET_TYPE.DAILY as string },
    { label: t('LBL00683', '_Weekly'), value: BUCKET_TYPE.WEEKLY as string },
    { label: t('LBL00684', '_Monthly'), value: BUCKET_TYPE.MONTHLY as string },
  ];
  const bucketOptions =
    bucketTypeCombo && bucketTypeCombo.length > 0
      ? bucketTypeCombo.map(item => ({ label: String(item.NAME ?? ''), value: String(item.CODE ?? '') }))
      : bucketFallback;

  // W26/W52 — AS-IS GetDayRange 1:1: from = Plan date(미선택 시 오늘), to = from + 주수*7 - 1일.
  //   (AS-IS 는 SP SCM0001_GET_SCP_DAY_PERIOD 경유 — 사내 미이관으로 FE 로컬 산술 동등 구현. A5 handoff §4)
  const applyWeekPreset = (weeks: number) => {
    const base = sc.planDate && sc.planDate.length === 8 ? sc.planDate : undefined;
    const from = base
      ? new Date(Number(base.slice(0, 4)), Number(base.slice(4, 6)) - 1, Number(base.slice(6, 8)))
      : new Date();
    const to = new Date(from.getTime() + (weeks * 7 - 1) * 24 * 3600 * 1000);
    const fmt = (d: Date) =>
      `${d.getFullYear()}${String(d.getMonth() + 1).padStart(2, '0')}${String(d.getDate()).padStart(2, '0')}`;
    set({ fromYyyymmdd: fmt(from), toYyyymmdd: fmt(to) });
  };

  const splitCsv = (v: string): string[] => v.split(',').filter(Boolean);

  // Electrode — AS-IS SetElectrodeEnable(.cs L3886): operationGroup 'A'/'P' 면 'ALL' 고정 + 비활성.
  const electrodeDisabled = sc.operationGroup === 'A' || sc.operationGroup === 'P';
  // Cell Type Gr / Extra Spec — AS-IS division '40' 전용 enable (.cs SetChangedControl).
  const div40Only = sc.divisionId !== '40';

  return (
    <SearchArea
      isHidden={!openSearchArea}
      searchButtonLabel={t('LBL00691', '_Search')}
      onSearch={onSearch}
      conditions={
        <>
          {/* Row 1 — Division* / Operation Group* / Cell Type Gr / Electrode */}
          <DivisionField
            gridSize={3}
            value={sc.divisionId}
            onChange={option =>
              // ⭐ cascade (AS-IS CboDivision_SelectedIndexChanged L3854) — 하위 전면 reset.
              set({
                divisionId: option,
                operationGroup: '',
                cellTypeGrs: [],
                electrodes: [],
                extraSpecs: [],
                plantSiteIds: [],
                lineIds: [],
                planDate: '',
                planType: '',
                planSeq: '',
              })
            }
          />
          <Grid size={3}>
            <FormItem
              label={`${t('LBL00027', '_Operation Group')}*`}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={sc.operationGroup}
                  // CMBO 미등록(AS-IS Data_SCP OperationGroup/EE) — SP 변환 단계 등록 예정. 빈 옵션 유지.
                  options={[]}
                  onChange={(_, option) =>
                    // cascade (AS-IS CboOperationGroup_SelectedIndexChanged L3877) — 하위 reset.
                    set({ operationGroup: option, extraSpecs: [], plantSiteIds: [], lineIds: [] })
                  }
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00042', '_Cell Type Gr')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  disabled={div40Only}
                  value={sc.cellTypeGrs.join(',')}
                  options={cellTypeCombo?.map(item => ({ label: String(item.NAME ?? ''), value: String(item.CODE ?? '') })) ?? []}
                  onChange={(_, options) => set({ cellTypeGrs: splitCsv(String(options ?? '')) })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00038', '_Electrode')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  disabled={electrodeDisabled}
                  value={electrodeDisabled ? '' : sc.electrodes.join(',')}
                  // CMBO 미등록(AS-IS LookupCommon ElectrodeType) — SP 변환 단계 등록 예정.
                  options={[]}
                  onChange={(_, options) => set({ electrodes: splitCsv(String(options ?? '')) })}
                />
              )}
            />
          </Grid>

          {/* Row 2 — Extra Spec / Plant Site / Line / Model */}
          <Grid size={3}>
            <FormItem
              label={t('LBL00043', '_Extra Spec')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  disabled={div40Only}
                  value={sc.extraSpecs.join(',')}
                  // SP SCP0013_GET_EXTRA_SPEC INVALID — 변환 후 콤보 연결 (A5 handoff §5).
                  options={[]}
                  onChange={(_, options) => set({ extraSpecs: splitCsv(String(options ?? '')) })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00005', '_Plant Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  value={sc.plantSiteIds.join(',')}
                  // CMBO 미등록(AS-IS Data_SCP PlantSiteProdPlan/PlantByDivisionOperation) — 변환 단계 등록.
                  options={[]}
                  onChange={(_, options) =>
                    // cascade (AS-IS ClbPlantSite_SelectedIndexChanged L3872) — Line reset.
                    set({ plantSiteIds: splitCsv(String(options ?? '')), lineIds: [] })
                  }
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00010', '_Line')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  value={sc.lineIds.join(',')}
                  // CMBO 미등록(AS-IS Data_SCP LineProdPlanLine/LineByOperationAddOSP + GET_LINE_LIST) — 변환 단계 등록.
                  options={[]}
                  onChange={(_, options) => set({ lineIds: splitCsv(String(options ?? '')) })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00669', '_Model')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sc.modelId}
                  onChange={e => set({ modelId: e.target.value })}
                />
              )}
            />
          </Grid>
        </>
      }
      extraConditions={
        <>
          {/* Row 3 — Material / Nick Name / Plan-date* / Plan-type* */}
          <Grid size={3}>
            {/* ⭐ Material = POPUP 조회조건 (AS-IS txtItemId + btnItemId → SCM0002_MaterialByDivisionPopup).
                2026-07-13 사용자 확정: 돋보기 버튼 UI 만 추가, 팝업 실기능은 Phase C — 클릭 시 MSG00673 안내.
                패턴 = SearchFields.tsx PopupSearchInput (InputField + FunctionSearchIcon Button flex). */}
            <FormItem
              label={t('LBL00021', '_Material')}
              labelAlign='right'
              render={() => (
                <div className={styles.popupCell}>
                  <InputField
                    fullWidth
                    value={sc.itemIds.join(',')}
                    onChange={e => set({ itemIds: splitCsv(e.target.value) })}
                  />
                  <Button
                    appearance='outlined'
                    priority='normal'
                    iconComponent={<FunctionSearchIcon appearance='lined' />}
                    onClick={() =>
                      void setAlert({
                        type: 'alert',
                        content: t(MSG.PHASE_PENDING, '_해당 기능은 후속 단계에서 적용 예정입니다.'),
                      })
                    }
                  />
                </div>
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={t('LBL00767', '_Nick Name')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sc.nickName}
                  onChange={e => set({ nickName: e.target.value })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={`${t('LBL00039', '_Plan date')}*`}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={sc.planDate}
                  // CMBO 미등록(AS-IS Data_SCP DATE_WEEKLY) — 변환 단계 등록 예정.
                  options={[]}
                  onChange={(_, option) =>
                    // cascade (AS-IS CboPlanDate_SelectedIndexChanged L3931) — type/seq reset.
                    set({ planDate: option, planType: '', planSeq: '' })
                  }
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              label={`${t('LBL00040', '_Plan type')}*`}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={sc.planType}
                  // CMBO 미등록(AS-IS Data_SCP PlanType) — 변환 단계 등록 예정. 기본값=목록 마지막(AS-IS L3937).
                  options={[]}
                  onChange={(_, option) => set({ planType: option, planSeq: '' })}
                />
              )}
            />
          </Grid>

          {/* Row 4 — Seq* / Period* / Bucket(+W26/W52) / 체크박스 3종(ALL/Line Assign/Sum) */}
          <Grid size={3}>
            <FormItem
              label={`${t('LBL00768', '_Seq')}*`}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={sc.planSeq}
                  // CMBO 미등록(AS-IS Data_SCP PlanSeq) — 변환 단계 등록 예정. 기본값=첫번째(AS-IS L3956).
                  options={[]}
                  onChange={(_, option) => set({ planSeq: option })}
                />
              )}
            />
          </Grid>
          <PeriodField
            gridSize={3}
            start={sc.fromYyyymmdd}
            end={sc.toYyyymmdd}
            onChange={(start, end) => set({ fromYyyymmdd: start, toYyyymmdd: end })}
          />
          <Grid size={3}>
            {/* ⭐ Bucket + W26/W52 프리셋 (사용자 지시 — Bucket 오른쪽 버튼 배치. AS-IS BtnW26/W52_Click 1:1). */}
            <div className={styles.bucketCell}>
              <FormItem
                label={t('LBL00710', '_Bucket')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    isInput={false}
                    value={sc.bucketType}
                    options={bucketOptions}
                    onChange={(_, option) => set({ bucketType: option })}
                  />
                )}
              />
              <span className={styles.bucketPresets}>
                <Button
                  appearance='outlined'
                  priority='normal'
                  size='medium'
                  buttonLabel='W26'
                  onClick={() => applyWeekPreset(PERIOD_PRESET_WEEKS.W26)}
                />
                <Button
                  appearance='outlined'
                  priority='normal'
                  size='medium'
                  buttonLabel='W52'
                  onClick={() => applyWeekPreset(PERIOD_PRESET_WEEKS.W52)}
                />
              </span>
            </div>
          </Grid>
          <Grid size={3}>
            {/* ⭐ 체크박스 3종 — 조회조건 맨 마지막 (사용자 지시). AS-IS chkAll/chkLineAssign/chkSum 1:1
                (Sum 은 FE 컬럼 토글 전용 — AS-IS chkSum_CheckedChanged L1199, 재조회 아님). */}
            <div className={styles.checkboxRow}>
              <Stack direction='row' spacing={2} alignItems='center'>
                <Checkbox
                  labelText={t('LBL00721', '_ALL')}
                  checked={sc.chkAll}
                  onChange={checked => set({ chkAll: checked })}
                />
                <Checkbox
                  labelText={t('LBL00769', '_Line Assign')}
                  checked={sc.lineAssign}
                  onChange={checked => set({ lineAssign: checked })}
                />
                <Checkbox
                  labelText={t('LBL00687', '_Sum')}
                  checked={sc.sumYn}
                  onChange={checked => set({ sumYn: checked })}
                />
              </Stack>
            </div>
          </Grid>
        </>
      }
    />
  );
};
