import { PeriodField } from 'features/master/src/components';
import { useEffect } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid, Stack } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useMessageStore, useTabid } from '@shared/stores';

import type {
  BUCKET_TYPE} from '../production-plan-waterfall.constants';
import {
  COMBO,
  ELECTRODE_LOOKUP,
  isEeDivision,
  LBL,
  MENU_ID,
  MSG,
  UOM_OPTIONS,
  UOM_VISIBLE_OPERATION_GROUP,
} from '../production-plan-waterfall.constants';
import { useProductionPlanWaterfallStore } from '../useProductionPlanWaterfallStore';

interface Props {
  onSearch: () => void;
  onModelSearch: () => void; // Material 팝업(MaterialByDivisionModal) 오픈 — 페이지 소유
  onNickNameSearch: () => void; // Nick Name 팝업(Material 과 동일 MaterialByDivisionModal, NICK_NAME 저장) 오픈 — 페이지 소유
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// design 02 (02_search-combo.md) 조회조건 12 컨트롤 + cascade 재조회(§3).
//   cboDivision(최상위) → opGroup(EE 스왑) / plantSite / line / version + electrode(enable). 부모값을 콤보
//   파라미터로 실어 하위 콤보 재조회(react-query 키에 부모값 포함, convert-core §2.6 의미 패리티).
//   PlantSite 수동변경 시 Line 재조회 안 함(design 02 §3 파리티 — Line 재조회 키 = {division, opGroup}).
export const ProductionPlanWaterfallForm = ({ onSearch, onModelSearch, onNickNameSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useProductionPlanWaterfallStore(s => s.searchParams);
  const set = useProductionPlanWaterfallStore(s => s.setSearchParams);
  const setDivision = useProductionPlanWaterfallStore(s => s.setDivision);
  const setOperationGroup = useProductionPlanWaterfallStore(s => s.setOperationGroup);
  const setVersions = useProductionPlanWaterfallStore(s => s.setVersions);
  const setChkAll = useProductionPlanWaterfallStore(s => s.setChkAll);
  const setBucket = useProductionPlanWaterfallStore(s => s.setBucket);
  const openSearchArea = useProductionPlanWaterfallStore(s => s.openSearchArea);
  const setNoDivisionAuth = useProductionPlanWaterfallStore(s => s.setNoDivisionAuth);
  const setAlert = useMessageStore.getState().setAlert;

  const tabId = useTabid();

  const isEe = isEeDivision(sc.divisionId);

  // 콤보 — 부모값 파라미터 재조회(cascade). isEe 로 opGroup/plantSite/line SQL_ID 스왑(별개 코드셋, 이름 대조 금지).
  //   Line 파라미터에 plantSite 미포함(design 02 §3 파리티 — 수동 plantSite 변경 시 Line 재조회 금지).
  const [divisions, operationGroups, plantSites, lines, versions, buckets] = useTabComboQueries({
    filters: [
      { comboId: COMBO.DIVISION, mnuId: MENU_ID },
      isEe ? COMBO.OP_GROUP_EE : COMBO.OP_GROUP,
      isEe
        ? { comboId: COMBO.PLANT_SITE_EE, attribute2: sc.divisionId, segment2: sc.operationGroupId }
        : { comboId: COMBO.PLANT_SITE, divisionId: sc.divisionId, operationGroup: sc.operationGroupId },
      isEe
        ? { comboId: COMBO.LINE_EE, attribute2: sc.divisionId, operationGroup: sc.operationGroupId }
        : { comboId: COMBO.LINE, divisionId: sc.divisionId },
      { comboId: COMBO.VERSION, divisionId: sc.divisionId },
      COMBO.BUCKET,
    ],
  });
  const [electrodes] = useTabLookupQueries({ filters: [ELECTRODE_LOOKUP] });

  const divisionOptions = toOptions(divisions);
  const operationGroupOptions = toOptions(operationGroups);
  const plantSiteOptions = toOptions(plantSites);
  // Line 옵션 — '-' sentinel 제외(조회 파라미터에서 '' 치환은 store, design 02 §2 #4).
  const lineOptions = toOptions((lines ?? []).filter(r => str(r.CODE) !== '-'));
  const versionOptions = toOptions(versions);
  const bucketOptions = toOptions(buckets);
  // electrode 는 lookup(LookupResponse — index signature) — CODE/NAME 직접 매핑.
  const electrodeOptions: Option[] = (electrodes ?? []).map(r => {
    const rec = r as Record<string, unknown>;
    return { label: str(rec.NAME) || str(rec.CODE), value: str(rec.CODE) };
  });

  // Division 권한 게이트(design 01 L1, SetDivisionAuthCheck cs:211~212) — 권한 Division 0건이면 조회영역
  //   입력 disable + 조회 미발사 + 권한없음 안내 1회. divisions 로드 완료(undefined 아님) 후에만 판정해
  //   콤보 조회 중 오차단 방지. 메시지 = MSG00667('No authority assigned.', AS-IS MSG00097 의도 매칭 TO-BE
  //   코드, Hook #114 — 자매 inventory-trend 선례). MyDivisionInEE_SCP 는 EE 미제외라 클라 추가 필터 없음.
  const noDivisionAuth = divisions !== undefined && divisionOptions.length === 0;
  useEffect(() => {
    if (noDivisionAuth) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRE_DIVISION, '_No authority assigned.') });
    }
  }, [noDivisionAuth, setAlert, t]);
  // 조회영역 입력 disable(아래 render)뿐 아니라 조회 액션(SubTitle/Search)도 막도록 store 로 승계.
  useEffect(() => {
    setNoDivisionAuth(noDivisionAuth);
  }, [noDivisionAuth, setNoDivisionAuth]);

  // division 기본값 교정 — 현재 값이 옵션에 없으면 첫 옵션(권한 division 첫 행, design 02 §4.4).
  const firstDivision = divisionOptions[0]?.value ?? '';
  const hasDivision = divisionOptions.some(o => o.value === sc.divisionId);
  useEffect(() => {
    if (firstDivision && !hasDivision) setDivision(firstDivision);
  }, [firstDivision, hasDivision, setDivision]);

  // operationGroup 기본값 — 옵션 로드 후 미선택이면 첫 옵션(AS-IS SetChangedControl 기본 구성).
  //   setOperationGroup 경유로 설정해 RefreshUOM(EE+E→'M', 그 외 'EA') 기본이 이 경로에서도 함께 적용되게 한다.
  const firstOpGroup = operationGroupOptions[0]?.value ?? '';
  const hasOpGroup = operationGroupOptions.some(o => o.value === sc.operationGroupId);
  useEffect(() => {
    if (firstOpGroup && !hasOpGroup) setOperationGroup(firstOpGroup);
  }, [firstOpGroup, hasOpGroup, setOperationGroup]);

  // 비EE division → Electrode 값 clear + disable (design 01 L8 / 02 §4.5).
  useEffect(() => {
    if (!isEe && sc.electrodeTypes.length > 0) set({ electrodeTypes: [] });
  }, [isEe, sc.electrodeTypes.length, set]);

  // UOM 가시성 — AS-IS RefreshUOM(cs:474~510): EE Division + OperationGroup='E' 일 때만 clbUOM 노출(체크 'M'),
  //   그 외는 숨김(암묵 체크 'EA'). 노출 시 기본 'M' 전환은 setOperationGroup 이 담당(OperationGroup 변경 핸들러).
  //   여기선 숨김일 때 UOM 값을 'EA' 로 고정만 한다 — 노출→숨김 전환(Division 비EE화 등) 시 잔류 'M' 을 되돌린다.
  const uomVisible = isEe && sc.operationGroupId === UOM_VISIBLE_OPERATION_GROUP;
  useEffect(() => {
    if (!uomVisible && sc.uom !== 'EA') set({ uom: 'EA' });
  }, [uomVisible, sc.uom, set]);

  // allOption=false 면 목록에 SELECT ALL 항목을 빼 다중선택만 허용한다(기본 true).
  //   빈 선택을 'ALL' sentinel 로 내보내는 것은 스토어 규약(빈 배열 → 필터 없음)이라 유지한다 —
  //   이는 선택 가능한 항목이 아니라 미선택 표현이므로 SELECT ALL 노출과 무관하다.
  // placeholder: 미선택일 때 필드에 보일 문구. 인자를 주지 않으면(undefined) CustomDropdown 다중선택
  //   기본('ALL')이 그대로 쓰여 "All" 로 보인다(PlantSite/Electrode 등 전체=ALL 이 정상인 조건).
  //   빈값('')을 주면 미선택이 공백으로 보인다(Version 처럼 AS-IS 초기값이 빈값인 조건).
  //   주의: placeholder 는 '값이 있을 때만' 넘긴다(아래 조건부 스프레드). undefined 를 prop 으로 그대로
  //   넘기면 CustomDropdown 내부의 {...props} 재스프레드가 기본 'ALL' 을 undefined 로 덮어써 PlantSite/
  //   Electrode 까지 공백이 된다 — 키 자체를 빼야 기본값이 유지된다.
  const multi = (
    labelText: string,
    value: string[],
    options: Option[],
    onPick: (codes: string[]) => void,
    disabled?: boolean,
    allOption = true,
    required?: boolean,
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
            allOption={allOption}
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

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Row0 — Division* / Operation Group* / Plant Site / Electrode (사용자 지정 배치) */}
          {single(
            t(LBL.DIVISION, '_Div'),
            sc.divisionId,
            divisionOptions,
            // Division 변경 = 검색조건(Div·기간 제외) + 그리드 초기화(store setDivision, TO-BE 공통 요건). 편집중(dirty)이면
            //   MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가 이전 Div 로 복귀(commit 51d4e9fa 패턴).
            //   이 화면은 read-only 라 실제 dirty 는 없지만 공통 패턴을 동일하게 둔다(SCP0025 선례).
            v => {
              void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                if (ok) setDivision(v);
              });
            },
            true
          )}
          {/* OperationGroup 변경 = 하위(plantSite/line) 초기화 + 그리드 clear(store setOperationGroup,
              AS-IS cboOperationGroup_SelectedIndexChanged → RefreshPlantSite/Line + InitSpread). */}
          {single(
            t(LBL.OPERATION_GROUP, '_Operation Group'),
            sc.operationGroupId,
            operationGroupOptions,
            v => setOperationGroup(v),
            true
          )}
          {multi(t(LBL.PLANT_SITE, '_Plant Site'), sc.plantSiteIds, plantSiteOptions, v =>
            set({ plantSiteIds: v })
          )}
          {/* Electrode — enable=isEe(division), 비EE 면 disable+clear(design 01 L8). */}
          {multi(
            t(LBL.ELECTRODE, '_Electrode'),
            sc.electrodeTypes,
            electrodeOptions,
            v => set({ electrodeTypes: v }),
            !isEe
          )}

          {/* Row1 — Material(팝업) / Model/Nickname(팝업) / Version* / Period* */}
          {/* Material(txtItemId) — 팝업 검색(btnItemId → MaterialByDivisionModal). AS-IS lblItemId.Text="Material". */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MATERIAL, '_Material')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.modelId}
                  disabled={noDivisionAuth}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={<FunctionSearchIcon appearance='lined' />}
                        onClick={onModelSearch}
                      />
                    ),
                  }}
                  onChange={e => set({ modelId: e.target.value })}
                />
              )}
            />
          </Grid>
          {/* Model/Nickname — TO-BE 변경: 텍스트 입력 → Material 과 동일 MaterialByDivisionModal 팝업(선택 NICK_NAME 저장).
              자매 GlobalPsi 패턴 이식. onChange 수기 입력도 병행 허용. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL_NICKNAME, '_Model/Nickname')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.nickName}
                  disabled={noDivisionAuth}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={<FunctionSearchIcon appearance='lined' />}
                        onClick={onNickNameSearch}
                      />
                    ),
                  }}
                  onChange={e => set({ nickName: e.target.value })}
                />
              )}
            />
          </Grid>
          {/* Version — AS-IS 체크리스트 단일 UI 이나 Gap 시 2건 필요(design 02 §7-3) → 다중 허용.
              변경 시 Period 재산정(AS-IS CboVersion_SelectedIndexChanged → GetDayRange, G2) — setVersions 경유.
              표시 규약(사용자 결정 2026-11-02): ALL 은 선택 가능(allOption=true, SELECT ALL 선택 시 전 항목 =
              표준 SRCH-06)하되, AS-IS 초기값이 빈값(setListBox blnAllFlag=false, SCP0017.cs L1302)이므로
              placeholder='' 로 미선택을 공백 표시한다(자매 SCP0018 과 동일 패턴 — 다중선택 기본 'ALL' 표시 억제).
              미선택 조회는 필수값 게이트(versionNos.length===0)로 차단되므로 공백 초기값과 양립한다. */}
          {/* 라벨 'Ver.' 는 하드코딩(사용자 지시 2026-11-02, SCP0016 패턴 일치) — DB/번들 미등록 약어, KO/EN/CN 동일 표기라 i18n 불요. */}
          {multi('Ver.', sc.versionNos, versionOptions, setVersions, undefined, true, true, '')}
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
          {/* 접기 영역 — Row2(Bucket / Line / 체크박스 Sum·All·Gap) + UOM(조건부).
              SRCH-02(size 3 기준 8칸 초과 → extraConditions 분리) · 설계 02 §5 / 05 runtime-parity 근거.
              필수값(Division·OpGroup·Version·Period)과 자주 쓰는 조건은 위 conditions 에 상시 노출. */}
          {/* Bucket 변경 = AS-IS InitSpread_2 → InitSheet: 그리드(데이터+헤더) 비우고 재조회 요구(setBucket). */}
          {single(t(LBL.BUCKET, '_Bucket'), sc.bucket, bucketOptions, v =>
            setBucket(v as BUCKET_TYPE)
          )}
          {multi(t(LBL.LINE, '_Line'), sc.lineIds, lineOptions, v =>
            set({ lineIds: v })
          )}
          <Grid size={3} className={commonStyles.customGrid}>
            <div className={commonStyles.customCheckbox} style={{ width: '100%' }}>
              {/* 체크박스를 size=3 셀 가로 중앙에 배치(사용자 지정). */}
              <Stack
                direction='row'
                spacing={2}
                alignItems='center'
                justifyContent='center'
                sx={{ width: '100%' }}
              >
                <Checkbox
                  labelText={t(LBL.SUM, '_Sum')}
                  checked={sc.chkSum}
                  onChange={checked => set({ chkSum: checked })}
                />
                {/* All(전체기간) — 토글 시 AS-IS ChkAll_CheckedChanged 등가로 그리드 비움(재조회 요구, G1). */}
                <Checkbox
                  labelText={t(LBL.ALL, '_All')}
                  checked={sc.chkAll}
                  onChange={checked => setChkAll(checked)}
                />
                <Checkbox
                  labelText={t(LBL.GAP, '_Gap')}
                  checked={sc.chkGap}
                  onChange={checked => set({ chkGap: checked })}
                />
              </Stack>
            </div>
          </Grid>

          {/* UOM(조건부) — AS-IS RefreshUOM: EE Division + OperationGroup='E' 일 때만 노출(lciUOM.Visibility).
              clbUOM(CheckedListBox 단일선택) → single 콤보. 선택값은 조회결과 UOM 컬럼 클라 필터(ApplyUOM, 재조회 없음).
              Row2 에 Bucket/Line/체크박스와 같은 Grid size={3} 셀로 정렬(사용자 지정 — 체크박스 size 3 축소로 자리 확보). */}
          {uomVisible &&
            single(t(LBL.UOM, '_UOM'), sc.uom, [...UOM_OPTIONS], v => set({ uom: v }))}
        </>
      }
    />
  );
};

