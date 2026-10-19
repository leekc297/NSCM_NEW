import { PlanVersionCascade, type PlanVersionLevel } from 'features/supply/src/components';
import { useEffect, useMemo } from 'react';

import dayjs from '@foundation/dayjs';
import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, PeriodRangePicker, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries, useTabProcQuery } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid, Stack } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import {
  BUCKET_TYPE,
  COMBO,
  ELECTRODE_LOOKUP,
  LBL,
  MENU_ID,
  PRESET_W52,
  SHEETS,
} from '../production-plan-line.constants';
import { useProductionPlanLineStore } from '../useProductionPlanLineStore';
import {
  isCellTypeExtraSpecEnabled,
  isEeDivision,
  isElectrodeEnabled,
} from '../utils/productionPlanLineEditLock';

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

// Period 고정 프리셋 — AS-IS 원형(W26·W52 + 동적 WLast). W92 하드코딩은 쓰지 않는다(안정 참조용 모듈 상수).
const SCP0013_QUICK_WEEKS = [26, 52];

// design 02 (02_search-combo.md) 조회조건 21 컨트롤 + cascade 그래프(§3).
//   cboDivision(최상위) → opGroup(EE 스왑) / plantSite / line / planDate→Type→Seq / cellTypeGr·extraSpec(div=40).
//   AS-IS CommonAll(전량) + DBUtils.Filter 를 반환컬럼 클라 필터로 재현(convert-core §2.6). 콤보 등록 실측(design 02 §2.4).
export const ProductionPlanLineForm = ({ onSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useProductionPlanLineStore(s => s.searchCondition);
  const set = useProductionPlanLineStore(s => s.setSearchCondition);
  const setDivision = useProductionPlanLineStore(s => s.setDivision);
  const setLatestVersion = useProductionPlanLineStore(s => s.setLatestVersion);
  const openSearchArea = useProductionPlanLineStore(s => s.openSearchArea);

  const tabId = useTabid();

  const isEe = isEeDivision(sc.divisionId);
  const cellTypeEnabled = isCellTypeExtraSpecEnabled(sc.divisionId);
  const electrodeEnabled = isElectrodeEnabled(sc.operationGroupId);

  // 콤보 — 전량 조회 후 client-side cascade 필터(AS-IS CommonAll + DBUtils.Filter, design 02 §3).
  //   operationGroup 은 EE 여부로 콤보 스왑(이름 대조 금지 — 별개 코드셋, convert-core §2.6).
  const [
    divisions,
    operationGroups,
    plantSites,
    lines,
    cellTypeGrs,
    planDates,
    planTypes,
    planSeqs,
    buckets,
  ] = useTabComboQueries({
    filters: [
      COMBO.DIVISION,
      isEe ? COMBO.OP_GROUP_EE : COMBO.OP_GROUP,
      isEe ? COMBO.PLANT_SITE_EE : COMBO.PLANT_SITE, // EE/비EE 소스 교체 (AS-IS RefreshPlantSite cs:1821-1828)
      isEe ? COMBO.LINE_EE : COMBO.LINE, // EE/비EE 소스 교체 (AS-IS RefreshLine cs:1878-1887)
      COMBO.CELL_TYPE_GR,
      COMBO.PLAN_DATE,
      COMBO.PLAN_TYPE,
      COMBO.PLAN_SEQ,
      COMBO.BUCKET,
    ],
  });
  const [electrodes] = useTabLookupQueries({ filters: [ELECTRODE_LOOKUP] });

  // M3 보완 (design 02 §3.1 #7): cellTypeGr 선택 시 clbLine 서버 재조회(P_SCP0013_GET_LINE_LIST, 5 IN).
  //   base LINE 콤보에는 CELL_TYPE_GROUP_CODE 컬럼이 없어 축을 클라필터로 좁힐 수 없다 — 서버 재조회형.
  //   재조회이므로 react-query 키(filters)에 상위값(div/opGroup/plantSite/cellTypeGr/planStart)을 실어 캐시한다.
  //   SP 전제(PKG body 실측): P_PLANT_SITE(STRING_SPLIT)·P_PLAN_START_YYYYMMDD 필수 → 둘 다 있을 때만 enable.
  //   반환 O_RC1 = CODE/NAME(+선두 '-' DUAL 행) — 실동작은 runtime-parity-gate 브라우저 축(미확인).
  const lineListEnabled =
    sc.cellTypeGrs.length > 0 && sc.plantSiteIds.length > 0 && !!sc.planStartYyyymmdds[0];
  //   filters 는 반드시 안정 참조여야 한다 — 매 렌더 새 객체를 넘기면 useTabProcQuery 의 useLayoutEffect 가
  //   "재조회"로 오판해 캐시를 비우고 무한 refetch 루프가 된다(useCustomQueryClient.ts:83-88 경고).
  const lineListFilters = useMemo(
    () =>
      lineListEnabled
        ? {
            divisionId: sc.divisionId,
            operationGroup: sc.operationGroupId,
            plantSite: sc.plantSiteIds.join(','),
            cellTypeGr: sc.cellTypeGrs.join(','),
            planStartYyyymmdd: sc.planStartYyyymmdds[0] ?? '',
          }
        : undefined,
    [
      lineListEnabled,
      sc.divisionId,
      sc.operationGroupId,
      sc.plantSiteIds,
      sc.cellTypeGrs,
      sc.planStartYyyymmdds,
    ]
  );
  const { data: lineListData } = useTabProcQuery<MENU_ID, SHEETS.LINE_LIST>({
    menuId: MENU_ID,
    sheetName: SHEETS.LINE_LIST,
    tabId: MENU_ID,
    filters: lineListFilters,
    enabled: lineListEnabled,
  });
  const serverLines = (lineListData as { o_rc1?: ComboResponse[] })?.o_rc1;

  // Extra Spec — AS-IS SCP0013_GET_EXTRA_SPEC(div=40 전량) → 선택 OperationGroup 으로 OPERATION_GROUP 클라필터
  //   (AS-IS RefreshExtraSpec DBUtils.Filter cs:488). 전용 콤보 미등록이라 SP 직접 배선(design 02 §7, deploy
  //   SCP0013_extraSpec_combo_register_20261002.sql). div=40 에서만 노출되므로 cellTypeEnabled 로 게이트.
  //   filters 는 반드시 안정 참조여야 한다 — 매 렌더 새 객체를 넘기면 useTabProcQuery 의 useLayoutEffect 가
  //   "재조회"로 오판해 캐시를 비우고 무한 refetch 루프가 된다(useCustomQueryClient.ts:83-88 경고).
  const extraSpecFilters = useMemo(
    () => (cellTypeEnabled ? { divisionId: sc.divisionId } : undefined),
    [cellTypeEnabled, sc.divisionId]
  );
  const { data: extraSpecData } = useTabProcQuery<MENU_ID, SHEETS.EXTRA_SPEC>({
    menuId: MENU_ID,
    sheetName: SHEETS.EXTRA_SPEC,
    tabId: MENU_ID,
    filters: extraSpecFilters,
    enabled: cellTypeEnabled,
  });
  const extraSpecRows = (extraSpecData as { o_rc1?: ComboResponse[] })?.o_rc1;

  const divisionOptions = toOptions(divisions);
  // WLast 프리셋(Period) — 현재 division 의 기본기간(SCM_MST_DIVISION.DAILY_PLAN_PERIOD). Division_SCP 콤보가
  //   이미 이 컬럼을 반환하므로(AS-IS GetLastRange=SCM0001_GET_SCP_DAILY_PLAN_PERIOD 와 동일 원천) 별도 호출 없이
  //   로드된 divisions 에서 읽는다. 52(미적용)·미발견이면 undefined → PeriodRangePicker 가 WLast 버튼 숨김.
  const divisionPeriod =
    Number((divisions ?? []).find(r => str(r.CODE) === sc.divisionId)?.DAILY_PLAN_PERIOD) ||
    undefined;
  const operationGroupOptions = toOptions(operationGroups);
  const bucketOptions = toOptions(buckets);
  const cellTypeGrOptions = toOptions(cellTypeGrs);
  // electrode 는 lookup(LookupResponse — index signature) — CODE/NAME 로 직접 매핑(tact-time 규약).
  const electrodeOptions: Option[] = (electrodes ?? []).map(r => {
    const rec = r as Record<string, unknown>;
    return { label: str(rec.NAME) || str(rec.CODE), value: str(rec.CODE) };
  });

  // division 하위 클라 필터 (AS-IS DBUtils.Filter DIVISION_ID, design 02 §2.3).
  const inDivision = (r: ComboResponse): boolean =>
    !sc.divisionId || str(r.DIVISION_ID) === sc.divisionId;
  const plantSiteOptions = toOptions(
    (plantSites ?? []).filter(
      r => inDivision(r) && (!sc.operationGroupId || str(r.OPERATION_GROUP) === sc.operationGroupId)
    )
  );
  // line: cellTypeGr 선택 시 서버 재조회 결과 우선(M3), 아니면 base 콤보 클라필터
  //   (division + 선택 plantSite(SITE_ID) 하위, '-' sentinel 제외 — design 02 §2.1/§3.1 #7).
  const lineOptions =
    lineListEnabled && serverLines
      ? toOptions(serverLines.filter(r => str(r.CODE) !== '-'))
      : toOptions(
          (lines ?? []).filter(
            r =>
              str(r.CODE) !== '-' &&
              inDivision(r) &&
              // EE 는 DIVISION_ID + OPERATION_GROUP + SITE_ID, 비EE 는 DIVISION_ID + SITE_ID (AS-IS RefreshLine cs:1880/1885).
              (!isEe || !sc.operationGroupId || str(r.OPERATION_GROUP) === sc.operationGroupId) &&
              (sc.plantSiteIds.length === 0 || sc.plantSiteIds.includes(str(r.SITE_ID)))
          )
        );
  // Extra Spec: 선택 OperationGroup 과 일치하는 행만 (AS-IS RefreshExtraSpec OPERATION_GROUP 필터).
  //   '-' sentinel 행은 유지(AS-IS 콤보 첫 항목). operationGroup 미선택이면 빈 목록.
  const extraSpecOptions = toOptions(
    (extraSpecRows ?? []).filter(
      r => !!sc.operationGroupId && str(r.OPERATION_GROUP) === sc.operationGroupId
    )
  );
  const planDateOptions = toOptions((planDates ?? []).filter(inDivision));
  const planTypeOptions = toOptions(
    (planTypes ?? []).filter(
      r =>
        inDivision(r) &&
        (sc.planStartYyyymmdds.length === 0 ||
          sc.planStartYyyymmdds.includes(str(r.PLANDATE)))
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

  // Plan Date → Type → Seq 종속 콤보를 공유 PlanVersionCascade 로 재구성 — 반환컬럼(PLANDATE/PLANTYPE)으로
  //   date→type→seq 를 잇는다(division 필터·트리화는 컴포넌트가 수행). 기존 옵션 계산/기본값 effect 는
  //   그대로 두고 입력 UI 만 교체. 참조 안정화를 위해 useMemo.
  const planVersionLevels = useMemo<PlanVersionLevel[]>(
    () => [
      { name: 'planDate', label: t(LBL.PLAN_DATE, '_Plan-date'), rows: planDates, required: true },
      {
        name: 'planType',
        label: t(LBL.PLAN_TYPE, '_Plan-type'),
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
    () => ({
      planDate: sc.planStartYyyymmdds[0] ?? '',
      planType: sc.planTypes[0] ?? '',
      planSeq: sc.planSeqs[0] ?? '',
    }),
    [sc.planStartYyyymmdds, sc.planTypes, sc.planSeqs]
  );

  // division 기본값 교정 — 현재 값이 옵션에 없으면 첫 옵션(권한 division 첫 행 근사, design 02 §4.3).
  const firstDivision = divisionOptions[0]?.value ?? '';
  const hasDivision = divisionOptions.some(o => o.value === sc.divisionId);
  useEffect(() => {
    if (firstDivision && !hasDivision) setDivision(firstDivision);
  }, [firstDivision, hasDivision, setDivision]);

  // operationGroup 기본값 — 옵션 로드 후 미선택이면 첫 옵션(AS-IS SetChangedControl 기본 구성).
  const firstOpGroup = operationGroupOptions[0]?.value ?? '';
  const hasOpGroup = operationGroupOptions.some(o => o.value === sc.operationGroupId);
  useEffect(() => {
    if (firstOpGroup && !hasOpGroup) set({ operationGroupId: firstOpGroup });
  }, [firstOpGroup, hasOpGroup, set]);

  // planType 기본 = 마지막 행(design 02 §4.3 RefreshPlanType), planSeq 기본 = 첫 항목(최신).
  //   부모 선택이 확정된 뒤에만 기본값을 넣는다(parent-ready 게이트). division 변경 직후 cascade
  //   초기화(planStart/type/seq=[])에서 plandate 기본 effect 와 planType 기본 effect 가 같은 커밋에
  //   함께 돌면, planType 기본이 아직 plandate 로 좁혀지지 않은 division 전체(union) 목록의 마지막을
  //   집어 선택 plandate 에 없는 값으로 굳는 문제가 있다(예: EE 최신 plandate 는 PR/MA 뿐인데 union
  //   마지막 FN 이 들어가 빈값 표시). plandate 가 들어온 뒤 좁혀진 목록으로만 기본값을 정한다.
  const lastPlanType = planTypeOptions[planTypeOptions.length - 1]?.value ?? '';
  useEffect(() => {
    if (lastPlanType && sc.planTypes.length === 0 && sc.planStartYyyymmdds.length > 0)
      set({ planTypes: [lastPlanType] });
  }, [lastPlanType, sc.planTypes.length, sc.planStartYyyymmdds.length, set]);
  const firstPlanSeq = planSeqOptions[0]?.value ?? '';
  useEffect(() => {
    if (firstPlanSeq && sc.planSeqs.length === 0 && sc.planTypes.length > 0)
      set({ planSeqs: [firstPlanSeq] });
  }, [firstPlanSeq, sc.planSeqs.length, sc.planTypes.length, set]);
  // Plan-date 기본값 = 최신 버전(AS-IS ORDER BY date DESC idx0 / GetLastPlanVersion 자동선택 등가).
  //   plan-date 는 단일 필수 콤보이고 SP P_PLAN_START_YYYYMMDD 에 그대로 TO_DATE 되므로 반드시 단일
  //   실제 날짜여야 한다(빈값/ALL/다중 = ORA-01841). design 02 §4.3 planDate idx0.
  const latestPlanDate = planDateOptions[0]?.value ?? '';
  useEffect(() => {
    if (latestPlanDate && sc.planStartYyyymmdds.length === 0)
      set({ planStartYyyymmdds: [latestPlanDate] });
  }, [latestPlanDate, sc.planStartYyyymmdds.length, set]);

  // Period = AS-IS GetDayRange(W52): from = 선택 Plan date, to = from + (52*7 - 1)일
  //   (SP SCM0001_GET_SCP_DAY_PERIOD p_offset_day = 주차*7-1, "일요일 계산을 위한 하루를 뺀다" cs:4108/4118).
  //   AS-IS CboPlanDate_SelectedIndexChanged(cs:3931) 가 plan date 변경마다 Period 를 재산정하는 것과 동치 —
  //   planStartYyyymmdds[0] 가 바뀔 때만 세팅하므로 그 사이 사용자의 Period 수동 편집은 보존된다.
  //   plan date CODE 는 'YYYYMMDD' char(DATE_WEEKLY1_SCP_ALL.plan_start_yyyymmdd) — slice 로 ISO 변환 후 가산.
  const planDate = sc.planStartYyyymmdds[0] ?? '';
  useEffect(() => {
    if (planDate.length !== 8) return;
    const iso = `${planDate.slice(0, 4)}-${planDate.slice(4, 6)}-${planDate.slice(6, 8)}`;
    set({
      fromYyyymmdd: planDate,
      toYyyymmdd: dayjs(iso).add(PRESET_W52 * 7 - 1, 'day').format('YYYYMMDD'),
    });
  }, [planDate, set]);
  // Fix/Unfix/New enable 엄밀판정 입력 — 최신 버전 CODE(옵션 idx0)를 스토어로 승격(design 01 R2).
  //   planDate·planSeq 옵션은 division/상위 콤보 변경 시 재계산되므로 그 idx0 만 페이지가 대조한다.
  useEffect(() => {
    setLatestVersion({ latestPlanStart: latestPlanDate, latestPlanSeq: firstPlanSeq });
  }, [latestPlanDate, firstPlanSeq, setLatestVersion]);

  // opGroup A/P → electrode ALL 고정 + disable (design 01 C1).
  useEffect(() => {
    if (!electrodeEnabled && sc.electrodeTypes.length > 0) set({ electrodeTypes: [] });
  }, [electrodeEnabled, sc.electrodeTypes.length, set]);
  // div!=40 → cellTypeGr/extraSpec clear (design 01 B2).
  useEffect(() => {
    if (!cellTypeEnabled && (sc.cellTypeGrs.length > 0 || sc.extraSpecs.length > 0))
      set({ cellTypeGrs: [], extraSpecs: [] });
  }, [cellTypeEnabled, sc.cellTypeGrs.length, sc.extraSpecs.length, set]);
  // chkAll 체크 동안 bucket=Daily 유지 (design 02 §1 row21 / §3.3 — AS-IS ChkAll_CheckedChanged 강제).
  useEffect(() => {
    if (sc.chkAll && sc.bucket !== BUCKET_TYPE.DAILY) set({ bucket: BUCKET_TYPE.DAILY });
  }, [sc.chkAll, sc.bucket, set]);

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
            // 빈 배열(= 필터 없음)은 'ALL' sentinel 로 되돌려 넘긴다. 그래야 CustomDropdown 의
            //   전체선택 상태(isAllSentinel)가 왕복돼 SELECT ALL 체크가 유지된다. '' 로 넘기면
            //   전체선택 직후 체크가 풀려 select-all 이 안 먹는 것처럼 보인다.
            value={value.length ? value.join(',') : 'ALL'}
            options={options}
            onChange={(_, picked) =>
              // 'ALL' sentinel 은 빈 배열로 정규화(하위 cascade 오매칭 방지 — tact-time 규약).
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

  // Material / Model/Nickname 픽커 — 둘 다 같은 MaterialByDivisionModal 팝업을 연다(사용자 지시 2026-10-12).
  //   AS-IS txtItemId(Material, btnItemId 팝업)·txtNickName(Nick Name) 분리 복원. 팝업 행 선택 1회가
  //   Material(itemId←ITEM_ID)·Model/Nickname(nickName←NICK_NAME)을 함께 채운다(ProductionPlanLine.tsx
  //   setSelectedValue). 자유 입력은 각 조건으로 분리(Material→p_item_id, Model/Nickname→p_nick_name).
  const pickerField = (labelText: string, value: string, onPick: (v: string) => void) => (
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
                  iconComponent={<FunctionSearchIcon appearance='lined' onClick={onItemSearch} />}
                />
              ),
            }}
            onChange={e => onPick(e.target.value)}
            onKeyDown={e => e.key === 'Enter' && onSearch()}
          />
        )}
      />
    </Grid>
  );

  // Division 변경은 하위 cascade + 그리드를 통째로 초기화한다(setDivision → filters={}). 미저장 편집(dirty)이
  //   있으면 MSG00704 confirm 후에만 바꾼다 — 조회 공통 가드 confirmIfDirtyKey(..., 'search')를 Div 콤보에도
  //   동일 적용(DataGrid 가 tabDirtyKey 로 dirty 자동 등록). controlled 콤보라 취소 시 이전 Div 로 자동 복귀.
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
          {/* Row0 — Division* / Operation Group* / Cell Type Gr / Electrode / Extra Spec */}
          {single(t(LBL.DIVISION, '_Div'), sc.divisionId, divisionOptions, handleDivisionChange, true)}
          {single(
            t(LBL.OPERATION_GROUP, '_Operation Group'),
            sc.operationGroupId,
            operationGroupOptions,
            v => set({ operationGroupId: v }),
            true
          )}
          {multi(t(LBL.CELL_TYPE_GR, '_Cell Type Gr'), sc.cellTypeGrs, cellTypeGrOptions, v => set({ cellTypeGrs: v }), !cellTypeEnabled)}
          {multi(t(LBL.ELECTRODE, '_Electrode'), sc.electrodeTypes, electrodeOptions, v => set({ electrodeTypes: v }), !electrodeEnabled)}
          {/* Extra Spec — SP P_SCP0013_GET_EXTRA_SPEC(div=40) + OPERATION_GROUP 클라필터. div=40 에서만 enable. */}
          {multi(t(LBL.EXTRA_SPEC, '_Extra Spec'), sc.extraSpecs, extraSpecOptions, v => set({ extraSpecs: v }), !cellTypeEnabled)}

          {/* Row1 — Plant Site / Line / Material / Model/Nickname(픽커 2개, 동일 팝업) */}
          {multi(t(LBL.PLANT_SITE, '_Plant Site'), sc.plantSiteIds, plantSiteOptions, v =>
            set({ plantSiteIds: v, lineIds: [] })
          )}
          {multi(t(LBL.LINE, '_Line'), sc.lineIds, lineOptions, v => set({ lineIds: v }))}
          {/* Material(SCP0024 패리티) + Model/Nickname — 둘 다 MaterialByDivisionModal(COM0013) 픽커.
              AS-IS txtItemId(Material)·txtNickName(Nick Name) 분리 복원(사용자 지시 2026-10-12 — 2026-10-01
              통합 되돌림). Material→itemId(p_item_id), Model/Nickname→nickName(p_nick_name). 팝업 1회 선택이
              둘을 함께 채운다(페이지 setSelectedValue: ITEM_ID→itemId / NICK_NAME→nickName). */}
          {pickerField(t(LBL.MATERIAL, '_Material'), sc.itemId, v => set({ itemId: v }))}
          {pickerField(t(LBL.MODEL_NICKNAME, '_Model/Nickname'), sc.nickName, v => set({ nickName: v }))}

        </>
      }
      // 조회조건 2줄 초과분(Plan 버전/Period·Bucket·Sum)은 접고펼침으로 분리 — DMF0014 동일 패턴(SearchArea
      //   extraConditions = 접힘 기본, Search 옆 ^ 버튼으로 토글). 필드 순서는 AS-IS 그대로 유지한다.
      extraConditions={
        <>
          {/* Row2 — Plan-date* / Plan-type* / Seq* / Period* / Bucket / Sum */}
          {/* Plan-date → Plan-type → Seq 는 AS-IS UsrCombo 단일선택 필수 종속 콤보(design 02 #9/#10). 공용
              PlanVersionCascade(종속 콤보 + 공유 캐스케이더)로 교체 — 아무 필드나 눌러도 같은 컬럼 팝업이 열려
              date→type→seq 경로를 고르고, 상위 변경 시 하위 초기화. 선택값은 기존과 동일하게 1-요소 배열로
              store 에 보존(하위 cascade·기본값 effect 호환). 자동선택(최신 date·마지막 type·첫 seq)은
              기존 effect 가 그대로 채운다. 3필드 = 기존 폭(size 3×3) 유지로 size=9 래퍼. */}
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
          {/* Period — Templates.tsx 의 임시 Period 컴포넌트(PeriodRangePicker)로 교체(사용자 지시 2026-10-01). */}
          <Grid size={3}>
            <PeriodRangePicker
              className={commonStyles.formItem}
              start={sc.fromYyyymmdd}
              end={sc.toYyyymmdd}
              onChange={(start, end) => set({ fromYyyymmdd: start, toYyyymmdd: end })}
              label={t(LBL.PERIOD, '_Period')}
              quickWeeks={SCP0013_QUICK_WEEKS}
              lastWeeks={divisionPeriod}
            />
          </Grid>
          {/* Bucket — chkAll 체크 시 AS-IS ChkAll_CheckedChanged 는 Daily 강제 → 선택 비활성(design 02 §1 row21/§3.3). */}
          {single(
            t(LBL.BUCKET, '_Bucket'),
            sc.bucket,
            bucketOptions,
            v => set({ bucket: v as BUCKET_TYPE }),
            false,
            sc.chkAll
          )}

          {/* 체크박스 — Sum(SUM 컬럼 토글). ALL/Line Assign 은 사용자 지시(2026-10-01)로 제거. */}
          <Grid size={6} className={commonStyles.customGrid}>
            <div className={commonStyles.customCheckbox}>
              <Stack direction='row' spacing={2} alignItems='center'>
                <Checkbox
                  labelText={t(LBL.SUM, '_Sum')}
                  checked={sc.chkSum}
                  onChange={checked => set({ chkSum: checked })}
                />
              </Stack>
            </div>
          </Grid>
        </>
      }
    />
  );
};
