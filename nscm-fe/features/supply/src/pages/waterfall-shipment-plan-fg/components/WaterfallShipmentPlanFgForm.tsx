import { PeriodField } from 'features/master/src/components';
import { useEffect, useMemo } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useMessageStore, useTabid } from '@shared/stores';

import { useWaterfallShipmentPlanFgStore } from '../useWaterfallShipmentPlanFgStore';
import type { BUCKET_TYPE } from '../waterfall-shipment-plan-fg.constants';
import {
  COMBO,
  ELECTRODE_LOOKUP,
  isEeDivision,
  LBL,
  MENU_ID,
  MSG,
} from '../waterfall-shipment-plan-fg.constants';

interface Props {
  onSearch: () => void;
  onModelSearch: () => void; // Model/Nickname 팝업(메1 MaterialByDivisionModal) 오픈 — 페이지 소유
  onProjectSearch: () => void; // Project 팝업(ProjectByDivisionModal) 오픈 — 페이지 소유
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// design 02 (02_search-combo.md) 조회조건 9 + cascade 재조회(§3).
//   cboDivision(최상위) → opGroup(EE 스왑) / version + electrode(enable). 부모값을 콤보 파라미터로 실어
//   하위 콤보 재조회(react-query 키에 부모값 포함, convert-core §2.6 의미 패리티).
export const WaterfallShipmentPlanFgForm = ({ onSearch, onModelSearch, onProjectSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useWaterfallShipmentPlanFgStore(s => s.searchParams);
  const set = useWaterfallShipmentPlanFgStore(s => s.setSearchParams);
  const setDivision = useWaterfallShipmentPlanFgStore(s => s.setDivision);
  const setVersions = useWaterfallShipmentPlanFgStore(s => s.setVersions);
  const openSearchArea = useWaterfallShipmentPlanFgStore(s => s.openSearchArea);
  const setNoDivisionAuth = useWaterfallShipmentPlanFgStore(s => s.setNoDivisionAuth);
  const setAlert = useMessageStore.getState().setAlert;

  const tabId = useTabid();

  const isEe = isEeDivision(sc.divisionId);

  // 콤보 — 부모값 파라미터 재조회(cascade). isEe 로 opGroup SQL_ID 스왑(별개 코드셋, 이름 대조 금지).
  //   Version 은 _ALL 콤보(WaterfallVer_FG21_SCP_ALL) — 파라미터 없이 전 사업부 1회 로드 후 아래에서
  //   DIVISION_ID 로 클라 필터(AS-IS CommonAll + DBUtils.Filter 재현, convert-core §2.6). 재조회 아님.
  const [divisions, operationGroups, versions, buckets] = useTabComboQueries({
    filters: [
      { comboId: COMBO.DIVISION, mnuId: MENU_ID },
      isEe ? COMBO.OP_GROUP_EE : COMBO.OP_GROUP,
      COMBO.VERSION,
      COMBO.BUCKET,
    ],
  });
  const [electrodes] = useTabLookupQueries({ filters: [ELECTRODE_LOOKUP] });

  const divisionOptions = toOptions(divisions);
  const operationGroupOptions = toOptions(operationGroups);
  // Version — _ALL 콤보가 전 사업부 행(DIVISION_ID 컬럼 포함)을 반환 → 선택 division 으로 클라 필터
  //   (AS-IS .cs:237 DBUtils.Filter(dtVersionAll,"DIVISION_ID='"+division+"'") 1:1). 단순 동등비교 —
  //   버전은 사업부별 독립이라 warehouse-capacity 의 EE 특수분기(matchSiteByDivision) 같은 보정 불필요.
  const versionOptions = useMemo(
    () => toOptions((versions ?? []).filter(r => str(r.DIVISION_ID) === sc.divisionId)),
    [versions, sc.divisionId]
  );
  const bucketOptions = toOptions(buckets);
  // electrode 는 lookup(LookupResponse — index signature) — CODE/NAME 직접 매핑.
  const electrodeOptions: Option[] = (electrodes ?? []).map(r => {
    const rec = r as Record<string, unknown>;
    return { label: str(rec.NAME) || str(rec.CODE), value: str(rec.CODE) };
  });

  // Division 권한 게이트(design 01 D9, SetDivisionAuthCheck) — 권한 Division 0건이면 조회영역 disable +
  //   조회 미발사 + 권한없음 안내 1회. divisions 로드 완료(undefined 아님) 후에만 판정해 조회 중 오차단 방지.
  //   메시지 = MSG00667('No authority assigned.', AS-IS MSG00097 의도 매칭 TO-BE 코드, Hook #114 — 자매
  //   inventory-trend/production-plan-waterfall 선례). Division_SCP 는 EE 미제외라 클라 추가 필터 없음.
  const noDivisionAuth = divisions !== undefined && divisionOptions.length === 0;
  useEffect(() => {
    if (noDivisionAuth) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRE_DIVISION, '_No authority assigned.') });
    }
  }, [noDivisionAuth, setAlert, t]);
  useEffect(() => {
    setNoDivisionAuth(noDivisionAuth);
  }, [noDivisionAuth, setNoDivisionAuth]);

  // division 기본값 교정 — 현재 값이 옵션에 없으면 첫 옵션(권한 division 첫 행, design 02 §4.4).
  const firstDivision = divisionOptions[0]?.value ?? '';
  const hasDivision = divisionOptions.some(o => o.value === sc.divisionId);
  useEffect(() => {
    if (firstDivision && !hasDivision) setDivision(firstDivision);
  }, [firstDivision, hasDivision, setDivision]);

  // operationGroup 기본값 — 옵션 로드 후 미선택이면 첫 옵션(AS-IS SetOperationGroupByDivision 기본 구성).
  const firstOpGroup = operationGroupOptions[0]?.value ?? '';
  const hasOpGroup = operationGroupOptions.some(o => o.value === sc.operationGroupId);
  useEffect(() => {
    if (firstOpGroup && !hasOpGroup) set({ operationGroupId: firstOpGroup });
  }, [firstOpGroup, hasOpGroup, set]);

  // 비EE division → Electrode 값 clear + disable (design 01 D2 / 02 §4).
  useEffect(() => {
    if (!isEe && sc.electrodeTypes.length > 0) set({ electrodeTypes: [] });
  }, [isEe, sc.electrodeTypes.length, set]);

  const multi = (
    labelText: string,
    value: string[],
    options: Option[],
    onPick: (codes: string[]) => void,
    disabled?: boolean,
    // allOption=false 면 목록에서 SELECT ALL 항목을 뺀다(기본 true). 빈 선택을 'ALL' sentinel 로
    //   내보내는 것은 스토어 규약(빈 배열 → 필터 없음)이라 유지한다 — 미선택 표현이지 선택 항목이
    //   아니므로 SELECT ALL 노출과 무관하다. Version 은 AS-IS 에 전체선택이 없어 false(사용자 지시).
    allOption = true,
    required?: boolean,
    // placeholder: 미선택일 때 필드에 보일 문구. 인자를 주지 않으면(undefined) CustomDropdown 다중선택
    //   기본('ALL')이 그대로 쓰여 "All" 로 보인다(Electrode 등 전체=ALL 이 정상인 조건).
    //   빈값('')을 주면 미선택이 공백으로 보인다(Version 처럼 AS-IS 초기값이 빈값인 조건).
    //   주의: placeholder 는 '값이 있을 때만' 넘긴다(아래 조건부 스프레드). undefined 를 prop 으로 그대로
    //   넘기면 CustomDropdown 내부의 {...props} 재스프레드가 기본 'ALL' 을 undefined 로 덮어써 Electrode
    //   까지 공백이 된다 — 키 자체를 빼야 기본값이 유지된다.
    placeholder?: string,
    // sortByLabel: 목록을 라벨 오름차순으로 재정렬할지. Electrode 처럼 순서가 무의미한 코드 목록은 true.
    //   Version 은 콤보 SQL 이 `ORDER BY PLAN_START_YYYYMMDD DESC`(최신순 내림차순)로 내려주는데 라벨
    //   오름차순 정렬을 켜면 그 의미 있는 순서를 덮어써 오래된 버전이 위로 온다(AS-IS 는 최신이 위) —
    //   그런 콤보는 false 로 서버 순서를 보존한다(CustomDropdown sortBy 설계 주석과 동일 취지).
    sortByLabel = true
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={labelText}
        labelAlign='right'
        required={required}
        render={() => (
          <CustomDropdown
            multiple
            allOption={allOption}
            useClearIcon
            limitTags={1}
            {...(sortByLabel ? { sortBy: 'label' as const } : {})}
            disabled={disabled || noDivisionAuth}
            value={value.length ? value.join(',') : 'ALL'}
            options={options}
            {...(placeholder !== undefined ? { placeholder } : {})}
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
    required?: boolean
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
            disabled={noDivisionAuth}
            onChange={(_, picked) => onPick(String(picked ?? ''))}
          />
        )}
      />
    </Grid>
  );

  const popupField = (labelText: string, value: string, onOpen: () => void, onChange: (v: string) => void) => (
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
            disabled={noDivisionAuth}
            InputProps={{
              endAdornment: (
                <Button
                  appearance='outlined'
                  priority='normal'
                  iconComponent={<FunctionSearchIcon appearance='lined' />}
                  onClick={onOpen}
                />
              ),
            }}
            onChange={e => onChange(e.target.value)}
          />
        )}
      />
    </Grid>
  );

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* 조회조건 순서 — 기준표(2026-11-18) 5그룹 정렬: [1]데이터기준(Div·Ver) → [2]조직·거점·공정
              (Operation Group) → [3]제품·대상(PJT·Model/Nickname·Electrode) → [4]기간·집계(Period·Bucket).
              [5]상태·표시(Sum)는 접기 영역. 종전 2026-10-20 AS-IS 캡처 순서를 표준 기준으로 교체. */}
          {/* [1] Div — Division 변경 = 검색조건(Div·기간 제외) + 그리드 초기화(store setDivision, TO-BE 공통 요건).
              편집중(dirty)이면 MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가 이전 Div 로 복귀(commit
              51d4e9fa 패턴). 조회전용 화면이라 실제 dirty 는 없어 no-op 가드지만 공통 패턴을 동일하게 둔다(정본 SCP0025). */}
          {single(
            t(LBL.DIVISION, '_Div'),
            sc.divisionId,
            divisionOptions,
            v => {
              void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                if (ok) setDivision(v);
              });
            },
            true
          )}
          {/* [1] Version — 다중선택 CheckedList(필수). 변경 시 Period 재산정(AS-IS ClbVersion → GetDayRange).
              라벨 'Ver.' = LBL01275(KO/EN/CN 'Ver.', DB 등록 2026-11-12). 과거 하드코딩은 다국어 미처리라 교체.
              AS-IS 초기값이 빈값(setListBox blnAllFlag=false, SCP0016.cs L239)이므로 placeholder='' 로 미선택을
              공백 표시한다(자매 SCP0017 동일 패턴 — 다중선택 기본 'ALL' 표시 억제). 미선택 조회는 필수값 게이트로
              차단되므로 공백 초기값과 양립한다. sortByLabel=false — 콤보 SQL 이 최신순(PLAN_START_YYYYMMDD DESC)
              으로 내려주므로 라벨 오름차순 재정렬을 끄고 서버 내림차순을 보존한다(AS-IS 최신 버전이 위). */}
          {multi(
            t('LBL01275', '_Ver.'),
            sc.versionNos,
            versionOptions,
            v => setVersions(v),
            false, // disabled
            false, // allOption — Ver. 는 전체선택(Select All) 미노출(사용자 지시)
            true, // required
            '', // placeholder — 미선택 공백
            false // sortByLabel — 서버 최신순 유지
          )}
          {/* [2] Operation Group */}
          {single(
            t(LBL.OPERATION_GROUP, '_Operation Group'),
            sc.operationGroupId,
            operationGroupOptions,
            v => set({ operationGroupId: v }),
            true
          )}
          {/* [3] PJT / Model/Nickname(팝업) */}
          {popupField(t(LBL.PROJECT, '_PJT'), sc.projectCode, onProjectSearch, v =>
            set({ projectCode: v })
          )}
          {popupField(t(LBL.MODEL, '_Model/Nickname'), sc.itemId, onModelSearch, v => set({ itemId: v }))}
          {/* [3] Electrode — enable=isEe(division), 비EE 면 disable+clear(design 01 D2). */}
          {multi(
            t(LBL.ELECTRODE, '_Electrode'),
            sc.electrodeTypes,
            electrodeOptions,
            v => set({ electrodeTypes: v }),
            !isEe
          )}
          {/* [4] Period */}
          <PeriodField
            gridSize={3}
            start={sc.fromYyyymmdd}
            end={sc.toYyyymmdd}
            onChange={(start, end) => set({ fromYyyymmdd: start, toYyyymmdd: end })}
            label={t(LBL.PERIOD, '_Period')}
          />
          {/* [4] Bucket */}
          {single(t(LBL.BUCKET, '_Bucket'), sc.bucket, bucketOptions, v =>
            set({ bucket: v as BUCKET_TYPE })
          )}
        </>
      }
    />
  );
};
