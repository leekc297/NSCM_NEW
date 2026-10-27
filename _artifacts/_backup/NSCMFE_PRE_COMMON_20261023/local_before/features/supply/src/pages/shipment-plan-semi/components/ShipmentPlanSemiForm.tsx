import { PlanVersionCascade, type PlanVersionLevel } from 'features/supply/src/components';
import { useEffect, useMemo } from 'react';

import dayjs from '@foundation/dayjs';
import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, PeriodRangePicker, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem, InputField, Button, Checkbox } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import { type BUCKET_TYPE, COMBO, ELECTRODE_LOOKUP_TYPE, LBL, OPERATION_GROUP_LOOKUP_TYPE, PRESET_W52 } from '../shipment-plan-semi.constants';
import { useShipmentPlanSemiStore } from '../useShipmentPlanSemiStore';

interface Props {
  onSearch: () => void;
  onItemSearch: () => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// design 02 (02_search-combo.md) 조회조건 combo — 14개 상호작용 컨트롤, 12 comboCalls 전건.
//   모든 콤보가 "화면 전용 필터"(SP 전량 반환 + 클라 필터, design 02 §3) — BigFilter 미적용.
export const ShipmentPlanSemiForm = ({ onSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useShipmentPlanSemiStore(s => s.searchCondition);
  const set = useShipmentPlanSemiStore(s => s.setSearchCondition);
  const setDivision = useShipmentPlanSemiStore(s => s.setDivision);
  const openSearchArea = useShipmentPlanSemiStore(s => s.openSearchArea);

  const tabId = useTabid();

  const isEE = sc.divisionId.startsWith('EE');
  const isEEUC = sc.divisionId === 'EE_UC';

  // OperationGroup — division EE 여부로 lookupType 자체가 분기(design 02 §2.2, base LookupCommon 공용 SQL).
  const operationGroupLookupType = isEE ? OPERATION_GROUP_LOOKUP_TYPE.EE : OPERATION_GROUP_LOOKUP_TYPE.NORMAL;

  // ToSite 2원천 분기(design 02 §2.4): EE_UC 또는 그 외(81/82/40 등) -> TO_SITE_ALL,
  //   EE(UC 제외) -> TO_SITE_EE_LOOKUP. SCP0009 유사이름 콤보와 절대 혼동 금지(convert-core §2.6).
  const toSiteComboId = isEE && !isEEUC ? COMBO.TO_SITE_EE_LOOKUP : COMBO.TO_SITE_ALL;

  const [divisions, operationGroups, fromSites, toSites] = useTabComboQueries({
    filters: [
      COMBO.DIVISION,
      { comboId: COMBO.OPERATION_GROUP, lookupType: operationGroupLookupType },
      COMBO.FROM_SITE,
      toSiteComboId,
    ],
  });
  // Electrode — 초기 1회 로드, division EE 여부로 Enabled 만 토글(값 재조회 없음, design 02 §2.5).
  const [electrodes] = useTabComboQueries({
    filters: [{ comboId: COMBO.ELECTRODE, lookupType: ELECTRODE_LOOKUP_TYPE }],
  });
  // PlanDate->PlanType->PlanSeq 3단 cascade(design 02 §2.6, 전량+클라 필터)
  const [planDates] = useTabComboQueries({ filters: [COMBO.PLAN_DATE] });
  const [planTypes] = useTabComboQueries({ filters: [COMBO.PLAN_TYPE] });
  const [planSeqs] = useTabComboQueries({ filters: [COMBO.PLAN_SEQ] });
  // Bucket(cboBucketType) — DAILY/WEEKLY/MONTHLY 고정 룩업(SCP0013 공용 BucketType 콤보).
  const [buckets] = useTabComboQueries({ filters: [COMBO.BUCKET] });

  const divisionOptions = toOptions(divisions);
  const operationGroupOptions = toOptions(operationGroups);
  const bucketOptions = toOptions(buckets);

  // Division 기본 선택 — 진입 시 콤보 첫 항목을 자동선택한다(AS-IS 콤보 첫 항목 자동선택 파리티,
  //   사용자 결정 2026-10-13: 세션 division 우선 제거). sc.divisionId 가 비어 있을 때만 채운다 —
  //   사용자 선택·복원값은 덮지 않는다.
  useEffect(() => {
    if (sc.divisionId) return;
    const codes = divisionOptions.map(o => o.value).filter(Boolean);
    if (codes.length === 0) return;
    set({ divisionId: codes[0] });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisions, sc.divisionId]);

  // Operation Group 기본 선택 — 세션 값이 없는 콤보이므로 목록 로드 후 현재 선택이 목록에 없으면
  //   첫 행(AS-IS SetChangedControl 기본 구성, SCP0013 동일). division 변경 시 cascade 로 '' 초기화된
  //   뒤 새 목록의 첫 행으로 재선택된다.
  const firstOpGroup = operationGroupOptions[0]?.value ?? '';
  const hasOpGroup = operationGroupOptions.some(o => o.value === sc.operationGroupId);
  useEffect(() => {
    if (firstOpGroup && !hasOpGroup) set({ operationGroupId: firstOpGroup });
  }, [firstOpGroup, hasOpGroup, set]);

  // FromSite 클라 필터(design 02 §2.3, 3갈래: EE_UC/EE(UC제외)/그외)
  const fromSiteFilterDivisionIds = (): string[] => {
    if (isEEUC) return ['81_UC'];
    if (isEE) return divisionOptions.map(o => o.value).filter(v => !v.startsWith('EE'));
    return [sc.divisionId];
  };
  const fromSiteDivisionIds = new Set(fromSiteFilterDivisionIds());
  const fromSiteOptions = toOptions(
    (fromSites ?? []).filter(
      r =>
        fromSiteDivisionIds.has(str(r.DIVISION_ID)) &&
        (!sc.operationGroupId || str(r.OPERATION_GROUP) === sc.operationGroupId)
    )
  );
  // ToSite 클라 필터(design 02 §2.4) — EE_UC 는 '81_UC' 고정, 그 외는 division 그대로.
  const toSiteFilterDivisionIds = (): string[] => (isEEUC ? ['81_UC'] : [sc.divisionId]);
  const toSiteDivisionIds = new Set(toSiteFilterDivisionIds());
  const toSiteOptions = toOptions(
    (toSites ?? []).filter(
      r =>
        toSiteDivisionIds.has(str(r.DIVISION_ID)) &&
        (!sc.operationGroupId || str(r.OPERATION_GROUP) === sc.operationGroupId)
    )
  );
  const electrodeOptions = toOptions(electrodes);
  // Plan Date/Type/Seq 자동선택 전용 필터 옵션(PlanVersionCascade 입력은 raw planDates/Types/Seqs 사용).
  //   PlanDate 클라 필터(division, DATE_WEEKLY1_SCP_ALL ORDER BY DESC → idx0=최신, DB 실측),
  //   PlanType(division+planDate, PlanType1_SCP_ALL ORDER BY PLAN_TYPE_ORDER → 마지막=최신),
  //   PlanSeq(+planType, PlanSeq1_SCP_ALL ORDER BY plan_seq DESC → idx0=최댓값). design 02 §2.6.
  const planDateOptions = toOptions(
    // division 이 비어 있을 때는 후보를 만들지 않는다(자동선택 차단). 리셋(reset→initState)으로 division 이
    //   '' 가 되는 찰나에 `!divisionId` 로 전 division 날짜가 통과하면, 아래 자동선택 effect 가 첫 행(타 division
    //   날짜)을 planStartYyyymmdd 에 박고 → division 이 확정되면 그 날짜가 해당 division 목록에 없어 Plan
    //   Date/Type/Seq 가 빈칸으로 남는 레이스가 난다(planDates 가 이미 로드된 리셋 경로에서만 드러남).
    (planDates ?? []).filter(r => !!sc.divisionId && str(r.DIVISION_ID) === sc.divisionId)
  );
  const planTypeOptions = toOptions(
    (planTypes ?? []).filter(
      r =>
        (!sc.divisionId || str(r.DIVISION_ID) === sc.divisionId) &&
        (!sc.planStartYyyymmdd || str(r.PLANDATE) === sc.planStartYyyymmdd)
    )
  );
  const planSeqOptions = toOptions(
    (planSeqs ?? []).filter(
      r =>
        (!sc.divisionId || str(r.DIVISION_ID) === sc.divisionId) &&
        (!sc.planStartYyyymmdd || str(r.PLANDATE) === sc.planStartYyyymmdd) &&
        (!sc.planType || str(r.PLANTYPE) === sc.planType)
    )
  );
  // 기본값 자동선택 3단(AS-IS RefreshPlanDate→Type→Seq 자동선택 파리티, SCP0013 동일 parent-ready 게이트).
  //   planDate 가 확정된 뒤에만 type, type 확정 뒤에만 seq 를 채운다 — division 변경 직후 같은 커밋에서
  //   아직 좁혀지지 않은 union 목록의 값을 잘못 집는 것을 막는다. division/상위 변경 시 setDivision·cascade
  //   초기화로 해당 필드가 '' 가 되면 이 effect 들이 새 상위 기준으로 다시 채운다.
  const latestPlanDate = planDateOptions[0]?.value ?? ''; // DESC → 최신
  useEffect(() => {
    if (latestPlanDate && !sc.planStartYyyymmdd) set({ planStartYyyymmdd: latestPlanDate });
  }, [latestPlanDate, sc.planStartYyyymmdd, set]);
  const latestPlanType = planTypeOptions[planTypeOptions.length - 1]?.value ?? ''; // 마지막 행 = 최신
  useEffect(() => {
    if (latestPlanType && !sc.planType && sc.planStartYyyymmdd) set({ planType: latestPlanType });
  }, [latestPlanType, sc.planType, sc.planStartYyyymmdd, set]);
  const maxPlanSeq = planSeqOptions[0]?.value ?? ''; // DESC → 최댓값
  useEffect(() => {
    if (maxPlanSeq && !sc.planSeq && sc.planType) set({ planSeq: maxPlanSeq });
  }, [maxPlanSeq, sc.planSeq, sc.planType, set]);

  // Plan Date → Type → Seq 종속 콤보를 공유 PlanVersionCascade 로 재구성 — 반환컬럼(PLANDATE/PLANTYPE)으로
  //   date→type→seq 를 잇는다(division 필터·트리화는 컴포넌트가 수행, SCP0013 동일). 선택값은 기존 단일
  //   문자열 store 필드에 그대로 보존(필터 옵션/자동선택 effect 호환). 참조 안정화를 위해 useMemo.
  const planVersionLevels = useMemo<PlanVersionLevel[]>(
    () => [
      { name: 'planDate', label: t(LBL.PLAN_DATE, '_Plan Date'), rows: planDates, required: true },
      {
        name: 'planType',
        label: t(LBL.PLAN_TYPE, '_Plan Type'),
        rows: planTypes,
        parentKeys: ['PLANDATE'],
        required: true,
      },
      {
        name: 'planSeq',
        label: t(LBL.SEQ, '_Seq'),
        rows: planSeqs,
        parentKeys: ['PLANDATE', 'PLANTYPE'],
        required: true,
      },
    ],
    [t, planDates, planTypes, planSeqs]
  );
  const planVersionValue = useMemo(
    () => ({ planDate: sc.planStartYyyymmdd, planType: sc.planType, planSeq: sc.planSeq }),
    [sc.planStartYyyymmdd, sc.planType, sc.planSeq]
  );

  // Period = AS-IS GetDayRange(W52): from = 선택 Plan date, to = from + (52*7-1)일
  //   (cs L345 CboPlanDate_SelectedIndexChanged → L4662 GetDayRange, p_offset_day = 주차*7-1 "일요일
  //   계산을 위한 하루를 뺀다"). SCP0013 과 동치 — planStartYyyymmdd 가 바뀔 때만 세팅하므로 그 사이
  //   사용자의 Period 수동 편집은 보존된다. plan date CODE 는 'YYYYMMDD' char → slice 로 ISO 변환 후 가산.
  const planDate = sc.planStartYyyymmdd;
  useEffect(() => {
    if (planDate.length !== 8) return;
    const iso = `${planDate.slice(0, 4)}-${planDate.slice(4, 6)}-${planDate.slice(6, 8)}`;
    set({
      fromYyyymmdd: planDate,
      toYyyymmdd: dayjs(iso).add(PRESET_W52 * 7 - 1, 'day').format('YYYYMMDD'),
    });
  }, [planDate, set]);

  const multi = (
    labelCode: string,
    labelEn: string,
    value: string[],
    options: Option[],
    onPick: (codes: string[]) => void,
    disabled?: boolean
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
            disabled={disabled}
            value={value.join(',')}
            options={options}
            onChange={(_, picked) =>
              onPick(String(picked ?? '').split(',').filter(v => v !== '' && v.toUpperCase() !== 'ALL'))
            }
          />
        )}
      />
    </Grid>
  );

  const single = (
    labelCode: string,
    labelEn: string,
    value: string,
    options: Option[],
    onPick: (v: string) => void,
    required?: boolean
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(labelCode, labelEn)}
        labelAlign='right'
        required={required}
        render={() => (
          <CustomDropdown value={value} options={options} onChange={(_, picked) => onPick(String(picked ?? ''))} />
        )}
      />
    </Grid>
  );

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      // 필드 배치 — AS-IS SCP0010 조회조건 순서(화면 대조, 사용자 지시 2026-10-12)를 그대로 따른다.
      //   상시: Div*/OperationGroup*/FromSite/ToSite/Model/Electrode/Bucket (AS-IS row1~2).
      //   접힘(extraConditions): PlanDate*/PlanType*/Seq*/Period*/Sum (AS-IS row3) — 2줄 초과분을
      //   접고펼침으로 분리(SCP0013 ProductionPlanLineForm 동일 패턴). ALL/W26/W52 는 SP 미배포로 범위 밖.
      conditions={
        <>
          {/* Division* — 무필터, EE 제외 없음(design 02 §2.1) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Div')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={sc.divisionId}
                  options={divisionOptions}
                  // Division 변경 = 검색조건(Div·기간 제외) + 그리드 초기화(store setDivision, TO-BE 공통 요건 —
                  //   AS-IS 하위콤보 cascade 초기화(design 02 §6)를 포함하는 더 넓은 초기화). 편집중(dirty)이면
                  //   MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가 이전 Div 로 복귀(commit 51d4e9fa 패턴).
                  onChange={(_, picked) => {
                    const v = String(picked ?? '');
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (ok) setDivision(v);
                    });
                  }}
                />
              )}
            />
          </Grid>
          {single(LBL.OPERATION_GROUP, '_Operation Group', sc.operationGroupId, operationGroupOptions, v =>
            set({ operationGroupId: v })
          , true)}
          {multi(LBL.FROM_SITE, '_From Site', sc.fromSiteIds, fromSiteOptions, fromSiteIds => set({ fromSiteIds }))}
          {multi(LBL.TO_SITE, '_To Site', sc.toSiteIds, toSiteOptions, toSiteIds => set({ toSiteIds }))}

          {/* Model/Nickname — txtItemId + btnItem_Id -> 메1 MaterialByDivisionModal(모3 ItemByDivisionModal
              에서 교체, 사용자 지시 2026-10-12 · SCP0013 동일 공통 패턴). 표시값은 itemId. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL_NICKNAME, '_Model/Nickname')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.itemId}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={<FunctionSearchIcon appearance='lined' onClick={onItemSearch} />}
                      />
                    ),
                  }}
                  onChange={e => set({ itemId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>
          {multi(
            LBL.ELECTRODE,
            '_Electrode',
            sc.electrodeTypeIds,
            electrodeOptions,
            electrodeTypeIds => set({ electrodeTypeIds }),
            !isEE // division EE 여부로 Enabled 만 토글(design 02 §2.5) — 비활성 시 선택값 미유지
          )}
          {/* Bucket(cboBucketType) — AS-IS row2. GET SP 엔 bucket 파라미터 없음(항상 D_/W_/M_ 전부 반환) —
              Bucket 은 그리드 표시 visible 토글 전용이다. 재조회·그리드 초기화 없이 선택 즉시 컬럼 가시성만
              바뀐다(ShipmentPlanSemiGrid isDynVisible, dynamicColumns deps=bucketType). SCP0011
              (production-plan) 동일 구조 — 사용자 지시 2026-10-13(설계 §0.2/§2.4 '매번 재조회' 파리티 대신
              SCP0011 토글 방식 채택. chkSum 토글과 동일 경로). */}
          {single(LBL.BUCKET, '_Bucket', sc.bucketType, bucketOptions, v =>
            set({ bucketType: v as BUCKET_TYPE })
          )}
        </>
      }
      extraConditions={
        <>
          {/* Plan Date → Type → Seq — AS-IS UsrCombo 단일선택 필수 종속 콤보(design 02 §2.6). 공용
              PlanVersionCascade(종속 콤보 + 공유 캐스케이더)로 교체 — 아무 필드나 눌러도 같은 컬럼 팝업이
              열려 date→type→seq 경로를 고르고 상위 변경 시 하위 초기화. 자동선택(최신 type·최대 seq)은
              위 effect 가 그대로 채운다. 3필드 = 기존 폭(size 3×3) 유지로 size=9 래퍼. */}
          <Grid size={9}>
            <PlanVersionCascade
              gridSize={4}
              variant='horizontal'
              labelAlign='right'
              formItemClassName={commonStyles.formItem}
              levels={planVersionLevels}
              divisionId={sc.divisionId}
              value={planVersionValue}
              onChange={v =>
                set({
                  planStartYyyymmdd: v.planDate ?? '',
                  planType: v.planType ?? '',
                  planSeq: v.planSeq ?? '',
                })
              }
            />
          </Grid>
          {/* Period* — SCP0013 과 동일 PeriodRangePicker(Today/W26/W52/W82 전부 클라 계산). Plan Date
              변경 시 위 effect 가 W52 구간(from=Plan date, to=+52*7-1일)으로 자동 세팅(AS-IS GetDayRange(W52) 파리티). */}
          <Grid size={3}>
            <PeriodRangePicker
              className={commonStyles.formItem}
              start={sc.fromYyyymmdd}
              end={sc.toYyyymmdd}
              onChange={(start, end) => set({ fromYyyymmdd: start, toYyyymmdd: end })}
              label={t(LBL.PERIOD, '_Period')}
            />
          </Grid>

          {/* Sum(chkSum) — AS-IS row3 끝. SUM(M_) 컬럼 visible 토글 전용(design 03 §2.4, 재조회 불요).
              Plan Date 라벨과 같은 선에 맞춘다(SCP0011 동일). @lges FormItem 은 label='' 이면 라벨 박스를
              안 그려 체크박스가 1열 맨 왼쪽에 붙으므로, 라벨 컬럼 안에서 오른쪽 정렬(flex-end)하되 캡처처럼
              Plan Date 라벨 글자 시작선에 오도록 우측선보다 ≈16px 안쪽으로 paddingRight 로 당긴다. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label=''
              labelAlign='right'
              render={() => (
                <div style={{ display: 'flex', justifyContent: 'flex-end', paddingRight: '16px' }}>
                  <Checkbox
                    labelText={t(LBL.SUM, '_Sum')}
                    checked={sc.chkSum}
                    onChange={checked => set({ chkSum: checked })}
                  />
                </div>
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
