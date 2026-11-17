import { PeriodField } from 'features/master/src/components';
import { useEffect } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useMessageStore, useTabid } from '@shared/stores';

import { useWaterfallShipmentPlanFgStore } from '../useWaterfallShipmentPlanFgStore';
import type { BUCKET_TYPE } from '../waterfall-shipment-plan-fg.constants';
import {
  BUCKET_TYPE as BUCKET,
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
  // SUM 체크박스 표시 (design 01 D1) — BucketType==WeeklyISO 면 숨김(주(ISO)단위라 합산 불필요).
  const showSum = sc.bucket !== BUCKET.WEEKLY_ISO;

  // 콤보 — 부모값 파라미터 재조회(cascade). isEe 로 opGroup SQL_ID 스왑(별개 코드셋, 이름 대조 금지).
  const [divisions, operationGroups, versions, buckets] = useTabComboQueries({
    filters: [
      { comboId: COMBO.DIVISION, mnuId: MENU_ID },
      isEe ? COMBO.OP_GROUP_EE : COMBO.OP_GROUP,
      { comboId: COMBO.VERSION, divisionId: sc.divisionId },
      COMBO.BUCKET,
    ],
  });
  const [electrodes] = useTabLookupQueries({ filters: [ELECTRODE_LOOKUP] });

  const divisionOptions = toOptions(divisions);
  const operationGroupOptions = toOptions(operationGroups);
  const versionOptions = toOptions(versions);
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
    required?: boolean,
    // placeholder: 미선택일 때 필드에 보일 문구. 인자를 주지 않으면(undefined) CustomDropdown 다중선택
    //   기본('ALL')이 그대로 쓰여 "All" 로 보인다(Electrode 등 전체=ALL 이 정상인 조건).
    //   빈값('')을 주면 미선택이 공백으로 보인다(Version 처럼 AS-IS 초기값이 빈값인 조건).
    //   주의: placeholder 는 '값이 있을 때만' 넘긴다(아래 조건부 스프레드). undefined 를 prop 으로 그대로
    //   넘기면 CustomDropdown 내부의 {...props} 재스프레드가 기본 'ALL' 을 undefined 로 덮어써 Electrode
    //   까지 공백이 된다 — 키 자체를 빼야 기본값이 유지된다.
    placeholder?: string
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
            allOption
            useClearIcon
            limitTags={1}
            sortBy='label'
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
          {/* AS-IS SCP0016 조회조건 순서 그대로(사용자 지시 2026-10-20, AS-IS 화면 캡처 기준):
              1행 Div·Operation Group·Project·Model / 2행 Electrode·Ver.·Bucket·Period. Sum 만 접기 영역. */}
          {/* Division 변경 = 검색조건(Div·기간 제외) + 그리드 초기화(store setDivision, TO-BE 공통 요건). 편집중(dirty)이면
              MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가 이전 Div 로 복귀(commit 51d4e9fa 패턴).
              조회전용 화면이라 실제 dirty 는 없어 no-op 가드지만 공통 패턴을 동일하게 둔다(정본 SCP0025). */}
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
          {single(
            t(LBL.OPERATION_GROUP, '_Operation Group'),
            sc.operationGroupId,
            operationGroupOptions,
            v => set({ operationGroupId: v }),
            true
          )}
          {popupField(t(LBL.PROJECT, '_PJT'), sc.projectCode, onProjectSearch, v =>
            set({ projectCode: v })
          )}
          {popupField(t(LBL.MODEL, '_Model/Nickname'), sc.itemId, onModelSearch, v => set({ itemId: v }))}
          {/* Electrode — enable=isEe(division), 비EE 면 disable+clear(design 01 D2). */}
          {multi(
            t(LBL.ELECTRODE, '_Electrode'),
            sc.electrodeTypes,
            electrodeOptions,
            v => set({ electrodeTypes: v }),
            !isEe
          )}
          {/* Version — 다중선택 CheckedList(필수). 변경 시 Period 재산정(AS-IS ClbVersion → GetDayRange).
              라벨 'Ver.' 는 하드코딩(사용자 지시 2026-10-20) — DB/번들 미등록 약어, KO/EN/CN 동일 표기라 i18n 불요.
              AS-IS 초기값이 빈값(setListBox blnAllFlag=false, SCP0016.cs L239)이므로 placeholder='' 로 미선택을
              공백 표시한다(자매 SCP0017 동일 패턴 — 다중선택 기본 'ALL' 표시 억제). 미선택 조회는 필수값 게이트로
              차단되므로 공백 초기값과 양립한다. */}
          {multi(
            'Ver.',
            sc.versionNos,
            versionOptions,
            v => setVersions(v),
            false,
            true,
            ''
          )}
          {single(t(LBL.BUCKET, '_Bucket'), sc.bucket, bucketOptions, v =>
            set({ bucket: v as BUCKET_TYPE })
          )}
          <PeriodField
            gridSize={3}
            start={sc.fromYyyymmdd}
            end={sc.toYyyymmdd}
            onChange={(start, end) => set({ fromYyyymmdd: start, toYyyymmdd: end })}
            label={t(LBL.PERIOD, '_Period')}
          />
        </>
      }
      extraConditions={
        <>
          {/* Sum — W_/M_ 합계칼럼 표시 토글. WeeklyISO 면 숨김(design 01 D1). 접기 펼침 시 Electrode(2행 1열)
              아래 1열에 노출(사용자 지시 2026-10-20). 라벨 우측정렬 FormItem 으로 세로 정렬. */}
          {showSum && (
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={' '}
                labelAlign='right'
                render={() => (
                  <Checkbox
                    labelText={t(LBL.SUM, '_Sum')}
                    checked={sc.chkSum}
                    onChange={checked => set({ chkSum: checked })}
                  />
                )}
              />
            </Grid>
          )}
        </>
      }
    />
  );
};
