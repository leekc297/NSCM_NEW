import { PlanVersionCascade, type PlanVersionLevel } from 'features/supply/src/components';
import { useEffect, useMemo } from 'react';

import dayjs from '@foundation/dayjs';
import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, PeriodRangePicker, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import type {
  BUCKET_TYPE} from '../production-plan.constants';
import {
  BUCKET_OPTIONS,
  COMBO,
  DIVISION_ALL,
  ELECTRODE_LOOKUP_TYPE,
  LBL,
  PRESET_W52,
  QUICK_WEEKS,
} from '../production-plan.constants';
import { useProductionPlanStore } from '../useProductionPlanStore';
import { isEeDivision, isElectrodeEnabled } from '../utils/productionPlanEditLock';

interface Props {
  onSearch: () => void;
  // 어느 필드의 메1 픽커를 열지 — Material(→item_id) / Model/Nickname(→nick_name).
  onItemSearch: (target: 'material' | 'modelNick') => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// design 02 (02_search-combo.md) 조회조건 — cboDivision(최상위) → opGroup(EE 스왑) / plantSite(EE 스왑) /
//   planDate→Type→Seq (전부 서버-파라미터 재조회, design 02 §3). EE 여부로 콤보 SQL_ID 스왑(convert-core §2.6).
export const ProductionPlanForm = ({ onSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useProductionPlanStore(s => s.searchCondition);
  const set = useProductionPlanStore(s => s.setSearchCondition);
  const setDivision = useProductionPlanStore(s => s.setDivision);
  const setLatestPlanDate = useProductionPlanStore(s => s.setLatestPlanDate);
  const openSearchArea = useProductionPlanStore(s => s.openSearchArea);

  const tabId = useTabid();

  const isEe = isEeDivision(sc.divisionId);
  const isAll = sc.divisionId === DIVISION_ALL; // Division=ALL → 하위 plan 콤보 자동선택 스킵(design 02 §4.4)
  const electrodeEnabled = isElectrodeEnabled(sc.divisionId);

  // 서버-파라미터 cascade 콤보(재조회) — 상위값이 바뀌면 param 이 바뀌어 react-query 가 자동 재조회.
  //   @mnuId(Division)·@sesUserId 는 BE/withMenuId 가 주입. EE 여부로 opGroup/plantSite comboId 스왑.
  //   PlantSiteProdPlan_SCP 토큰(segment2/attribute2)은 §2.7 확인필요 — best-effort 주입(04 정직보고).
  const [divisions, operationGroups, plantSites, electrodes, planDates, planTypes, planSeqs] =
    useTabComboQueries({
      filters: [
        { comboId: COMBO.DIVISION },
        isEe ? { comboId: COMBO.OP_GROUP_EE } : { comboId: COMBO.OP_GROUP },
        isEe
          ? // PlantSiteProdPlan_SCP 토큰(DB 실측 SCM_ADM_LOOKUP_MASTER_DETAIL EE_PRODUCTION_PLAN):
            //   SEGMENT2=운영그룹, ATTRIBUTE2=사업부. 이전 회차는 스왑돼 EE Plant Site 가 공집합이었다(M1 해소).
            { comboId: COMBO.PLANT_SITE_EE, segment2: sc.operationGroupId, attribute2: sc.divisionId }
          : { comboId: COMBO.PLANT_SITE, divisionId: sc.divisionId, operationGroup: sc.operationGroupId },
        { comboId: COMBO.ELECTRODE, lookupType: ELECTRODE_LOOKUP_TYPE },
        // Plan Date→Type→Seq 는 _SCP_ALL 전량 콤보라 파라미터 없이 1회 로드하고, 반환 컬럼으로 클라
        //   필터/트리화한다(자매 SCP0013 동일 — 공유 PlanVersionCascade).
        COMBO.PLAN_DATE,
        COMBO.PLAN_TYPE,
        COMBO.PLAN_SEQ,
      ],
    });

  const divisionOptions = toOptions(divisions);
  const operationGroupOptions = toOptions(operationGroups);
  const plantSiteOptions = toOptions(plantSites);
  const electrodeOptions = toOptions(electrodes);

  // Plan Date→Type→Seq 는 _SCP_ALL 전량이라 반환 컬럼으로 클라 필터(자매 SCP0013 동일). division +
  //   상위 선택(PLANDATE/PLANTYPE)으로 좁힌다. 기본값 effect(최신 date·마지막 type·첫 seq)는 이 좁혀진
  //   옵션 목록을 그대로 쓴다.
  const inDivision = (r: ComboResponse): boolean =>
    !sc.divisionId || str(r.DIVISION_ID) === sc.divisionId;
  const planDateOptions = toOptions((planDates ?? []).filter(inDivision));
  const planTypeOptions = toOptions(
    (planTypes ?? []).filter(
      r =>
        inDivision(r) &&
        (sc.planStartYyyymmdds.length === 0 || sc.planStartYyyymmdds.includes(str(r.PLANDATE)))
    )
  );
  const planSeqOptions = toOptions(
    (planSeqs ?? []).filter(
      r =>
        inDivision(r) &&
        (sc.planStartYyyymmdds.length === 0 || sc.planStartYyyymmdds.includes(str(r.PLANDATE))) &&
        (sc.planTypes.length === 0 || sc.planTypes.includes(str(r.PLANTYPE)))
    )
  );

  // Plan Date→Type→Seq 공유 PlanVersionCascade 단계 정의 — 반환 PLANDATE/PLANTYPE 로 상위-하위를 잇는다
  //   (division 필터·트리화는 컴포넌트가 수행, 자매 SCP0013 동일). 참조 안정화를 위해 useMemo.
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
        label: t(LBL.SEQ, '_Seq.'),
        rows: planSeqs,
        parentKeys: ['PLANDATE', 'PLANTYPE'],
        required: true,
      },
    ],
    [t, planDates, planTypes, planSeqs]
  );
  // 선택값은 기존과 동일하게 1-요소 배열로 store 에 보존.
  const planVersionValue = useMemo(
    () => ({
      planDate: sc.planStartYyyymmdds[0] ?? '',
      planType: sc.planTypes[0] ?? '',
      planSeq: sc.planSeqs[0] ?? '',
    }),
    [sc.planStartYyyymmdds, sc.planTypes, sc.planSeqs]
  );

  // division 기본값 교정 — 현재 값이 옵션에 없으면 첫 옵션(권한 division 첫 행, design 02 §4.2).
  const firstDivision = divisionOptions[0]?.value ?? '';
  const hasDivision = divisionOptions.some(o => o.value === sc.divisionId);
  useEffect(() => {
    if (firstDivision && !hasDivision) setDivision(firstDivision);
  }, [firstDivision, hasDivision, setDivision]);

  // operationGroup 기본값 — 옵션 로드 후 미선택이면 첫 옵션(AS-IS SetChangedControl).
  const firstOpGroup = operationGroupOptions[0]?.value ?? '';
  const hasOpGroup = operationGroupOptions.some(o => o.value === sc.operationGroupId);
  useEffect(() => {
    if (firstOpGroup && !hasOpGroup) set({ operationGroupId: firstOpGroup });
  }, [firstOpGroup, hasOpGroup, set]);

  // Plan-date 기본 = 최신(idx0, DESC) — 단일 필수. design 02 §4.2. Division=ALL 이면 자동선택 스킵(§4.4, L3).
  const latestPlanDate = planDateOptions[0]?.value ?? '';
  useEffect(() => {
    if (!isAll && latestPlanDate && sc.planStartYyyymmdds.length === 0)
      set({ planStartYyyymmdds: [latestPlanDate] });
  }, [isAll, latestPlanDate, sc.planStartYyyymmdds.length, set]);
  useEffect(() => {
    setLatestPlanDate(latestPlanDate);
  }, [latestPlanDate, setLatestPlanDate]);

  // Plan-type 기본 = 마지막 행(design 02 §4.2 RefreshPlanType). planDate 확정 후에만.
  const lastPlanType = planTypeOptions[planTypeOptions.length - 1]?.value ?? '';
  useEffect(() => {
    if (!isAll && lastPlanType && sc.planTypes.length === 0 && sc.planStartYyyymmdds.length > 0)
      set({ planTypes: [lastPlanType] });
  }, [isAll, lastPlanType, sc.planTypes.length, sc.planStartYyyymmdds.length, set]);

  // Seq 기본 = 첫 항목(design 02 §4.2 RefreshPlanSeq). planType 확정 후에만. Division=ALL 스킵(§4.4, L3).
  const firstPlanSeq = planSeqOptions[0]?.value ?? '';
  useEffect(() => {
    if (!isAll && firstPlanSeq && sc.planSeqs.length === 0 && sc.planTypes.length > 0)
      set({ planSeqs: [firstPlanSeq] });
  }, [isAll, firstPlanSeq, sc.planSeqs.length, sc.planTypes.length, set]);

  // Period = GetDayRange(W52): from = 선택 Plan date, to = from + (52*7-1)일 (design 02 §2.8).
  const planDate = sc.planStartYyyymmdds[0] ?? '';
  useEffect(() => {
    if (planDate.length !== 8) return;
    const iso = `${planDate.slice(0, 4)}-${planDate.slice(4, 6)}-${planDate.slice(6, 8)}`;
    set({
      fromYyyymmdd: planDate,
      toYyyymmdd: dayjs(iso).add(PRESET_W52 * 7 - 1, 'day').format('YYYYMMDD'),
    });
  }, [planDate, set]);

  // 비EE 사업부 → Electrode 값 clear + disable (design 02 §4.3).
  useEffect(() => {
    if (!electrodeEnabled && sc.electrodeTypes.length > 0) set({ electrodeTypes: [] });
  }, [electrodeEnabled, sc.electrodeTypes.length, set]);

  const multi = (
    labelText: string,
    value: string[],
    options: Option[],
    onPick: (codes: string[]) => void,
    disabled?: boolean
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={labelText}
        labelAlign='right'
        render={() => (
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            limitTags={1}
            sortBy='label'
            disabled={disabled}
            value={value.length ? value.join(',') : 'ALL'}
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
    labelText: string,
    value: string,
    options: Option[],
    onPick: (code: string) => void,
    required?: boolean,
    disabled?: boolean
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={labelText}
        labelAlign='right'
        required={required}
        render={() => (
          <CustomDropdown
            value={value}
            options={options}
            disabled={disabled}
            onChange={(_, picked) => onPick(String(picked ?? ''))}
          />
        )}
      />
    </Grid>
  );

  // 메1(MaterialByDivisionModal) 픽커 텍스트 필드 — Material / Model/Nickname 공통. 🔍 클릭 시 onIconClick,
  //   텍스트 입력은 onChange, Enter 는 조회. AS-IS txtItemId/txtNickName 등가.
  const popupField = (
    labelText: string,
    value: string,
    onChange: (v: string) => void,
    onIconClick: () => void
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={labelText}
        labelAlign='right'
        render={() => (
          <InputField
            fullWidth
            className={commonStyles.popupSearchField}
            value={value}
            InputProps={{
              endAdornment: (
                <Button
                  appearance='outlined'
                  priority='normal'
                  iconComponent={<FunctionSearchIcon appearance='lined' onClick={onIconClick} />}
                />
              ),
            }}
            onChange={e => onChange(e.target.value)}
            onKeyDown={e => e.key === 'Enter' && onSearch()}
          />
        )}
      />
    </Grid>
  );

  // Division 변경은 하위 cascade + 그리드를 통째 초기화한다. 미저장 편집(dirty)이 있으면 confirm 후에만 변경.
  const handleDivisionChange = (code: string) => {
    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
      if (ok) setDivision(code);
    });
  };

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Row0 — Division* / Operation Group* / Electrode / Bucket (AS-IS Designer 배치). Electrode 는
              Operation Group 다음, Bucket 은 최상단 우측(cboBucketType)으로 AS-IS 순서에 맞춘다. */}
          {single(t(LBL.DIVISION, '_Division'), sc.divisionId, divisionOptions, handleDivisionChange, true)}
          {single(
            t(LBL.OPERATION_GROUP, '_Operation Group'),
            sc.operationGroupId,
            operationGroupOptions,
            v => set({ operationGroupId: v }),
            true
          )}
          {multi(t(LBL.ELECTRODE, '_Electrode'), sc.electrodeTypes, electrodeOptions, v =>
            set({ electrodeTypes: v }), !electrodeEnabled
          )}
          {single(t(LBL.BUCKET, '_Bucket'), sc.bucket, BUCKET_OPTIONS, v =>
            set({ bucket: v as BUCKET_TYPE })
          )}

          {/* Row1 — Plant Site / Material(메1→item_id) / Model/Nickname(메1→nick_name). AS-IS Row1 배치.
              두 텍스트 필드 모두 메1(MaterialByDivisionModal COM0013) 픽커를 호출한다(사용자 지시 2026-10-07):
              Material 는 item_id(p_item_id), Model/Nickname 은 nick_name(p_nick_name)으로 조회에 실린다. */}
          {multi(t(LBL.PLANT_SITE, '_Plant Site'), sc.plantSiteIds, plantSiteOptions, v =>
            set({ plantSiteIds: v })
          )}
          {popupField(t(LBL.MATERIAL, '_Material'), sc.itemId, v => set({ itemId: v }), () =>
            onItemSearch('material')
          )}
          {popupField(
            t(LBL.MODEL_NICKNAME, '_Model/Nickname'),
            sc.nickName,
            v => set({ nickName: v }),
            () => onItemSearch('modelNick')
          )}

        </>
      }
      // 조회조건 2줄 초과분(Plan 버전/Period·Sum)은 접고펼침으로 분리 — DMF0014 동일 패턴(SearchArea
      //   extraConditions = 접힘 기본, Search 옆 ^ 버튼으로 토글). 필드 순서는 AS-IS 그대로 유지한다.
      extraConditions={
        <>
          {/* Row2 — Plan-date* / Plan-type* / Seq* — 자매 SCP0013 과 동일 공유 PlanVersionCascade(아무 필드나
              눌러도 같은 컬럼 팝업으로 date→type→seq 경로 선택, 상위 변경 시 하위 초기화). 선택값은 기존과
              동일하게 1-요소 배열로 store 에 보존(기본값 effect·filters 호환). size 3×3 → size=9 래퍼. */}
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
                  planStartYyyymmdds: v.planDate ? [v.planDate] : [],
                  planTypes: v.planType ? [v.planType] : [],
                  planSeqs: v.planSeq ? [v.planSeq] : [],
                })
              }
            />
          </Grid>

          {/* Period — Row2 우측(cascade 와 한 줄). AS-IS dCalendar 기간 피커. */}
          <Grid size={3}>
            <PeriodRangePicker
              className={commonStyles.formItem}
              start={sc.fromYyyymmdd}
              end={sc.toYyyymmdd}
              onChange={(start, end) => set({ fromYyyymmdd: start, toYyyymmdd: end })}
              label={t(LBL.PERIOD, '_Period')}
              quickWeeks={QUICK_WEEKS}
            />
          </Grid>

          {/* Row3 — Sum. Plan-date 바로 아래 줄, Plan Date 라벨과 같은 선에 맞춘다. 디자인: 체크박스 +
              바로 오른쪽 'Sum' 라벨(Checkbox labelText — 박스 다음에 글자). @lges FormItem 은 label=''
              이면 라벨 박스를 아예 안 그려 유일한 자식인 체크박스가 1열(라벨 컬럼) 맨 왼쪽에 붙는다
              — 그래서 Plan Date 라벨보다 왼쪽으로 삐져나왔다. 체크박스를 라벨 컬럼 안에서 오른쪽
              정렬(flex-end)하되, 캡처(목표)는 완전 우측선 정렬이 아니라 체크박스가 Plan Date 라벨
              글자 시작선에 오도록 라벨 컬럼 우측선보다 약간(≈16px) 안쪽이라, paddingRight 로 그만큼
              당겨 맞춘다. ALL(전체보기) 체크박스는 제거 — 항상 ALL 조회(chkAll=true). (사용자 지시 2026-10-07) */}
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
