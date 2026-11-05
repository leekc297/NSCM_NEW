import { PeriodField } from 'features/master/src/components';
import { useEffect } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid, Stack } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import { ALL, BOH_RADIO_ITEMS, BUCKET_TYPE, COMBO, LBL, MENU_ID } from '../shipment-plan-electrode.constants';
import { useShipmentPlanElectrodeStore } from '../useShipmentPlanElectrodeStore';

import styles from './ShipmentPlanElectrodeForm.module.scss';

interface Props {
  onSearch: () => void;
  // btnItemId → MaterialByDivisionModal(page 소유). AS-IS btnItemId_Click(cs:2273~2292).
  onItemSearch: () => void;
  // Model/Nickname 돋보기 → MaterialByDivisionModal(page 소유, 사용자 지시 2026-10-22).
  onModelSearch: () => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// Plan_InforElectrode 콤보의 FROM_DATE/TO_DATE1 은 YYYY-MM-DD(하이픈 10자리)로 온다.
//   Period 필드(PeriodField.toDayjs)는 길이 8(YYYYMMDD)만 해석하므로 하이픈을 제거해 8자리로 정규화한다.
//   미정규화 시 Plan Date 선택에도 Period 가 채워지지 않는다(실측 2026-10-14).
const ymd8 = (v: unknown): string => str(v).replace(/-/g, '');

const toOptions = (rows: { CODE?: unknown; NAME?: unknown }[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// 1차 조회조건 (usrConditionPanel1 — design 01 §1 / 02 §2). 칸-콤보 대응표(memory search-condition-combo-header):
//   ┌ 칸 ─────────┬ 콤보ID ──────────────┬ cascade 축 ─────────────┬ FE 후필터 ─────────────┐
//   │ Division*   │ MyDivisionInEE       │ @groupId @userId         │ CODE != 'EE' 제거        │
//   │ Company*    │ Div_Company          │ +DIVISION_ID(클라)        │ 선택 Division 으로 좁힘   │
//   │ From Site   │ Com_FromSitePlantEE  │ @divisionId @companyId    │ -                        │
//   │ Plan Date*  │ Plan_InforElectrode  │ @companyId (재조회)        │ index0=최신(realFlag)    │
//   │ Period*     │ (표시전용)            │ PlanDate 파생 FROM~TO     │ -                        │
//   │ Bucket      │ BUCKET_TYPE_CODE     │ 정적 lookup(DAILY/W/M)    │ -                        │
//   └─────────────┴──────────────────────┴──────────────────────────┴──────────────────────────┘
//   BOH 3-radio(UOM Type)·체크박스 6종(Sum/Past Period/My Model/Part/Team/Delegatee). UOM Type 은
//   3줄에 한 칸(라디오 한 줄 유지), 체크박스 6종은 접이식 4줄에 한 칸으로 묶는다(사용자 지시 2026-10-12).
//   레이아웃: 1~3줄(Division/Company/FromSite/Bucket · PlanDate/Period/Model/Material · NickName/UOM Type)은
//     항상 표시, 4줄(체크박스 6종)만 접이식 extraConditions 로 둬 펼침/접힘 토글
//     (SearchArea 가 chevron 버튼 자동 노출, 사용자 지시 2026-10-12). 토글은 모두 재조회 없음(03 §2.2).
export const ShipmentPlanElectrodeForm = ({ onSearch, onItemSearch, onModelSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useShipmentPlanElectrodeStore(s => s.searchCondition);
  const set = useShipmentPlanElectrodeStore(s => s.setSearchCondition);
  const setDivision = useShipmentPlanElectrodeStore(s => s.setDivision);
  const setCompany = useShipmentPlanElectrodeStore(s => s.setCompany);
  const setPlanDate = useShipmentPlanElectrodeStore(s => s.setPlanDate);
  const setBohRadio = useShipmentPlanElectrodeStore(s => s.setBohRadio);
  const setChkSum = useShipmentPlanElectrodeStore(s => s.setChkSum);
  const setChkPastPeriod = useShipmentPlanElectrodeStore(s => s.setChkPastPeriod);
  const openSearchArea = useShipmentPlanElectrodeStore(s => s.openSearchArea);

  const tabId = useTabid();

  // cascade 콤보 (02 §2): Division / Company(전량 → 클라 Division 필터) / FromSite / PlanDate / Bucket.
  //   Division 은 @groupId @userId 가 콤보 레지스트리 내부 축이라 별도 파라미터 불요(02 §2-A).
  const [divisionRows, companyRows, fromSites, planDates, bucketRows] = useTabComboQueries({
    filters: [
      { comboId: COMBO.DIVISION, mnuId: MENU_ID },
      { comboId: COMBO.COMPANY, mnuId: MENU_ID, divisionId: sc.divisionId },
      { comboId: COMBO.FROM_SITE, mnuId: MENU_ID, divisionId: sc.divisionId, companyId: sc.companyId },
      { comboId: COMBO.PLAN_INFOR, mnuId: MENU_ID, companyId: sc.companyId },
      { comboId: COMBO.BUCKET_TYPE, mnuId: MENU_ID },
    ],
  });

  // FE 후필터 1: Division CODE!='EE' 제거 (02 §2 — EE 는 전극 화면 노출 대상 아님).
  const divisionOptions = toOptions((divisionRows ?? []).filter(r => str(r.CODE) !== 'EE'));
  // FE 후필터 2: Company 를 선택 Division 으로 좁힘 (Div_Company 는 전량 반환, DIVISION_ID 축 실측).
  const companyOptions = toOptions(
    (companyRows ?? []).filter(r => !sc.divisionId || str(r.DIVISION_ID) === sc.divisionId)
  );
  const fromSiteOptions = toOptions(fromSites);
  const planDateOptions = toOptions(planDates);
  const bucketOptions: Option[] =
    bucketRows && bucketRows.length > 0
      ? toOptions(bucketRows)
      : [
          { label: 'DAILY', value: BUCKET_TYPE.DAILY },
          { label: 'WEEKLY', value: BUCKET_TYPE.WEEKLY },
          { label: 'MONTHLY', value: BUCKET_TYPE.MONTHLY },
        ];

  // Division 기본값 — 첫 행 선택(02 §4 — AS-IS 는 권한 기반 세팅 후 CODE!='EE' 필터, 세션 권한축
  //   부재로 index0 재현). cascade 시작점이라 이게 있어야 Company 이하가 연쇄로 채워진다.
  //   리셋 후 재셋팅까지 커버하려면 현재값이 옵션에 있는지(hasDivision)를 deps 에 둬야 한다
  //   (옵션 불변+값만 비워지는 F10 류 — [[f10-reset-default-reselect-needs-has-value-flag-in-deps]]).
  const hasDivision = divisionOptions.some(o => o.value === sc.divisionId);
  useEffect(() => {
    if (hasDivision || divisionOptions.length === 0) return;
    setDivision(divisionOptions[0].value);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [hasDivision, divisionOptions]);

  // Company 기본값 — 첫 행 선택(02 §4). 세션에 Company 필드 부재로 사용자회사 매칭 대신 index0 재현
  //   (SSP0060 과 동일 제약 — gap-audit I7, 04_react-gap.md 확인필요). Division 과 같은 hasCompany
  //   플래그 방식이라 Division 변경으로 setDivision 이 companyId 를 비우면(새 옵션 로드 후) 다시
  //   첫 값으로 재셋팅된다 — 사용자 요청. [[f10-reset-default-reselect-needs-has-value-flag-in-deps]].
  const hasCompany = companyOptions.some(o => o.value === sc.companyId);
  useEffect(() => {
    if (!sc.divisionId || hasCompany || companyOptions.length === 0) return;
    setCompany(companyOptions[0].value);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.divisionId, hasCompany, companyOptions]);

  // PlanDate 기본값 — 재조회 결과 index0(최신 Plan) 강제 선택 → realFlag=true (AS-IS L7226~7268).
  useEffect(() => {
    if (!sc.companyId || sc.planDateYyyymmdd || !planDates || planDates.length === 0) return;
    const first = planDates[0];
    setPlanDate(str(first.CODE), ymd8(first.FROM_DATE), ymd8(first.TO_DATE1), true);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sc.companyId, sc.planDateYyyymmdd, planDates]);

  const handlePlanDateChange = (code: string) => {
    const idx = (planDates ?? []).findIndex(r => str(r.CODE) === code);
    const row = (planDates ?? [])[idx] as ComboResponse | undefined;
    setPlanDate(code, ymd8(row?.FROM_DATE), ymd8(row?.TO_DATE1), idx === 0);
  };

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division* — MyDivisionInEE, 단일선택(사용자 직접 선택 후 cascade 시작) */}
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
                  // Division 변경 = 검색조건(Division 제외) + 그리드 초기화(store setDivision, TO-BE 공통 요건).
                  //   편집중(dirty)이면 MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가 이전 Division 으로
                  //   복귀(commit 51d4e9fa 패턴). cascade 는 리셋 후 Form effect 가 Company→PlanDate→Period 재파생.
                  onChange={(_, picked) => {
                    const v = str(picked);
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (ok) setDivision(v);
                    });
                  }}
                />
              )}
            />
          </Grid>

          {/* Company* — Div_Company, Division 클라 필터 + 첫 행 기본값.
              폭 고정: 바로 아래 같은 2번째 열에 Period(날짜범위, min-width 388)가 있어, 공용 SearchArea 의
              '같은 세로열=같은 폭' 정렬 때문에 Company 까지 388 로 넓어지던 것(사용자 신고 2026-10-22)을 막는다.
              이 칸만 콤보 기본폭(290px = CONDITIONS_GRID_ITEM_MIN)으로 묶고 왼쪽 정렬 — 트랙은 388 유지되나
              입력칸은 다른 콤보와 같은 크기가 된다(오른쪽에 약간 여백이 생기는 것은 의도된 트레이드오프). */}
          <Grid
            size={3}
            sx={{ width: '290px !important', maxWidth: '290px !important', justifySelf: 'start' }}
          >
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.COMPANY, '_Company')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={sc.companyId}
                  options={companyOptions}
                  onChange={(_, picked) => setCompany(str(picked))}
                />
              )}
            />
          </Grid>

          {/* From Site — Com_FromSitePlantEE, 다중선택(clbFromSite 체크리스트, 02 §2-2 C20). 미선택=전체.
              @divisionId @companyId 재조회. 자매 shipment-plan-mobility-it Plant Site 와 동일 패턴. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.FROM_SITE, '_From Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  value={sc.fromSite.join(',')}
                  options={fromSiteOptions}
                  onChange={(_, picked) =>
                    set({ fromSite: str(picked).split(',').filter(v => v && v !== ALL) })
                  }
                />
              )}
            />
          </Grid>

          {/* Bucket — BUCKET_TYPE_CODE (DAILY/WEEKLY/MONTHLY 완전어). 변경 시 컬럼 표시규칙만 전환(03 §2.2 — 재조회 없음) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.BUCKET, '_Bucket')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={sc.bucketType}
                  options={bucketOptions}
                  onChange={(_, picked) => set({ bucketType: str(picked) as BUCKET_TYPE })}
                />
              )}
            />
          </Grid>

          {/* Plan Date* — Plan_InforElectrode 재조회, index0=최신(realFlag) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PLAN_DATE, '_Plan Date')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={sc.planDateYyyymmdd}
                  options={planDateOptions}
                  onChange={(_, picked) => handlePlanDateChange(str(picked))}
                />
              )}
            />
          </Grid>

          {/* Period* — 분리형 날짜 range(drpPeriod). PlanDate 선택 시 FROM_DATE~TO_DATE1 로 자동채움
              (02 §4, handlePlanDateChange → setPlanDate). 자매 Shipment Plan(Mobility & IT) 동일 패턴.
              PeriodField 는 자체 Grid·required·label 포함(바깥 Grid/FormItem 불필요).
              직접 편집 불가(disabled): AS-IS drpPeriod.Enabled=false(Designer:954) — 값은 Plan Date
              파생(cboPlanDate_SelectedIndexChanged .cs:5763~5764)으로만 채워지는 읽기전용 필드다.
              상세영역 Shipment Date(drpPeriod2/3)는 AS-IS 가 Enabled 를 끄지 않아 편집 가능 유지. */}
          <PeriodField
            gridSize={3}
            label={t(LBL.PERIOD, '_Period')}
            start={sc.periodFrom}
            end={sc.periodTo}
            disabled
            onChange={(start, end) => set({ periodFrom: start, periodTo: end })}
          />

          {/* Material — txtItemId + btnItemId 팝업(MaterialByDivisionModal, page 소유). 빈 반환 시 기존값 유지
              (AS-IS btnItemId_Click cs:2273~2292). 메인조회 SP P_ITEM_ID 로 전달(저장 시 store 조립). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MATERIAL, '_Material')}
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
                        iconComponent={<FunctionSearchIcon appearance='lined' />}
                        onClick={onItemSearch}
                      />
                    ),
                  }}
                  onChange={e => set({ itemId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* Model/Nickname — Model + NickName 조회조건 통합(사용자 지시 2026-10-22). txtModelId + 돋보기
              (MaterialByDivisionModal COM0013, page 소유). 팝업 선택 시 품번(ITEM_ID)→modelId, 닉네임(NICK_NAME)
              →nickName 둘 다 세팅(page onModelSearch)해 메인 GET SP p_model_id + p_nick_name 양쪽을 채운다.
              직접입력은 품번 기준이라 modelId 만, nickName 은 비운다. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL, '_Model/Nickname')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.modelId}
                  InputProps={{
                    endAdornment: (
                      // 클릭을 아이콘이 아닌 버튼 전체에 건다(2026-10-23).
                      // <Button
                      //   appearance='outlined'
                      //   priority='normal'
                      //   iconComponent={
                      //     <FunctionSearchIcon appearance='lined' onClick={onModelSearch} />
                      //   }
                      // />
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={<FunctionSearchIcon appearance='lined' />}
                        onClick={onModelSearch}
                      />
                    ),
                  }}
                  // 직접입력은 품번(modelId) 기준 — 이전 팝업에서 세팅된 nickName 보조조건을 지운다.
                  onChange={e => set({ modelId: e.target.value, nickName: '' })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* UOM Type(BOH 3-radio) — Nick Name 과 같은 3줄에 한 칸(25% 폭). rdButton1/2/3 radio
              폼 재현(@shared RadioGroup 미제공, 정본=admin NoticeSetupDialog) — BOH 3칸 + 활성 기간
              span(X_/Y_/Z_) 동시선택, 컬럼 표시규칙만 전환(재조회 없음 — 03 §2.2). 라디오는 한 줄 유지. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.UOM_TYPE, '_UOM Type')}
              labelAlign='right'
              render={() => (
                <div className={styles.radioGroup}>
                  {BOH_RADIO_ITEMS.map(item => (
                    <label key={item.radio} className={styles.radioOption}>
                      <input
                        type='radio'
                        name='ssp0023-boh-uom-type'
                        value={item.radio}
                        checked={sc.bohRadio === item.radio}
                        onChange={() => setBohRadio(item.radio)}
                      />
                      <span>{t(item.lbl, item.fallback)}</span>
                    </label>
                  ))}
                </div>
              )}
            />
          </Grid>

          {
            // 기존 로직 주석 보존 (2026-10-19) 시작 - Sum/Past Period 를 4줄 체크박스 행으로 이동
            // {/* Sum · Including Past Period — 3줄 UOM Type 다음 남는 칸(size 6)에 둔다. 가로 중앙보다
            //     조금 앞(왼쪽)에 오도록 flex-start + 왼쪽 패딩으로 배치(항상 표시, 사용자 지시 2026-10-12).
            //     둘 다 표시규칙 전환(재조회 없음 — 03 §2.2). */}
            // <Grid size={6}>
            //   <Stack
            //     direction='row'
            //     alignItems='center'
            //     justifyContent='flex-start'
            //     spacing={2}
            //     sx={{
            //       minHeight: '36px',
            //       flexWrap: 'nowrap',
            //       pl: '80px',
            //       '& .MuiFormControlLabel-label': { whiteSpace: 'nowrap' },
            //     }}
            //   >
            //     <Checkbox
            //       labelText={t(LBL.SUM, '_Sum')}
            //       checked={sc.chkSum}
            //       onChange={checked => setChkSum(checked)}
            //     />
            //     <Checkbox
            //       labelText={t(LBL.PAST_PERIOD, 'Including Past Period')}
            //       checked={sc.chkPastPeriod}
            //       onChange={checked => setChkPastPeriod(checked)}
            //     />
            //   </Stack>
            // </Grid>
            // 기존 로직 주석 보존 (2026-10-19) 끝
          }
        </>
      }
      extraConditions={
        <>
          {/* My Model / Part Leader / Team Leader / Delegatee Model — 4줄(접힘). 첫째 칸(Division/NickName)과
              같은 왼쪽 열 기준으로 정렬되도록 extraConditions 그리드의 첫 item 으로 두고 size='auto' 로 내용 폭만
              차지한다(사용자 지시 2026-10-12). 넷 다 메인조회 SP 필터(P_MY_MODEL_CHK 등) — 4개 모두 미선택이면
              파생 P_NON_CHK='Y'(store setMainFilters). chkMyModel 초기 auto-check 는 page R09. */}
          <Grid size='auto' sx={{ flexShrink: 0 }}>
            <Stack
              direction='row'
              alignItems='center'
              spacing={2}
              sx={{
                flexShrink: 0,
                flexWrap: 'nowrap',
                // 다른 조회조건 input 의 시작 위치와 비슷하게 앞을 비운다(사용자 지시 2026-10-12).
                //   Stack 은 display:flex 라 formItem grid 라벨 칸이 적용되지 않아 pl 로 직접 들여쓴다.
                pl: '70px',
                '& .MuiFormControlLabel-label': { whiteSpace: 'nowrap' },
              }}
            >
              {/* Sum · Including Past Period — 3줄에서 이 행으로 이동(2026-10-19). 표시규칙 전환만(재조회 없음). */}
              <Checkbox
                labelText={t(LBL.SUM, '_Sum')}
                checked={sc.chkSum}
                onChange={checked => setChkSum(checked)}
              />
              <Checkbox
                labelText={t(LBL.PAST_PERIOD, 'Including Past Period')}
                checked={sc.chkPastPeriod}
                onChange={checked => setChkPastPeriod(checked)}
              />
              <Checkbox
                labelText={t(LBL.MY_MODEL, '_My Model')}
                checked={sc.chkMyModel}
                onChange={checked => set({ chkMyModel: checked })}
              />
              <Checkbox
                labelText={t(LBL.PART_LEADER, '_Part Leader')}
                checked={sc.chkPartLeader}
                onChange={checked => set({ chkPartLeader: checked })}
              />
              <Checkbox
                labelText={t(LBL.TEAM_LEADER, '_Team Leader')}
                checked={sc.chkTeamLeader}
                onChange={checked => set({ chkTeamLeader: checked })}
              />
              <Checkbox
                labelText={t(LBL.DELEGATEE_MODEL, '_Delegatee Model')}
                checked={sc.chkDelegateeModel}
                onChange={checked => set({ chkDelegateeModel: checked })}
              />
            </Stack>
          </Grid>
        </>
      }
    />
  );
};
