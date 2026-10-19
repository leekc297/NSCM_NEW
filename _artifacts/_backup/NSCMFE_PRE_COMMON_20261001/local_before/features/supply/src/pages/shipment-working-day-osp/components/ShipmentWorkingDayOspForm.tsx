import { PeriodField } from 'features/master/src/components';

import type { ComboParam, ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { COMBO, DAY_WEEK, DAY_WEEK_LOOKUP } from '../shipment-working-day-osp.constants';
import { useShipmentWorkingDayOspStore } from '../useShipmentWorkingDayOspStore';

interface Props {
  onSubmit: () => void;
  // Division 변경 = Grid 초기화 (부모 resetGrid — 조회 결과·미저장 편집 폐기)
  onDivisionChange: () => void;
  // btnInput 값입력 — 부모(ShipmentWorkingDayOsp)가 가드(조회 전/SelectDay/셀 미선택/형식) 후 선택 D_ 셀에 write.
  onInput: () => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// 02_search-combo.md 조회조건 콤보 5(영역2).
//   #1 Division(MyDivisionInEE_SCP 권한 @sesUserId+@mnuId) — 필수, cascade 상위. AS-IS GetDivisionWithoutEE
//      (ATTRIBUTE3<>'EE') 재현을 위해 EE 사업부는 FE 클라필터로 제외한다(02 §7-1 확인1 — SQL 미제외).
//   #2 PlantSite(PlantByDivisionOperOsp3_SCP, OSP_YN='Y' 고정) — cascade 재조회형: 선택 division 을
//      ComboParam.divisionId 로 실어 react-query 키를 바꿔 자동 재조회(TactTime 필터형과 달리 §3 재조회).
//   #3 Period(dCalendar) · #4 DayWeek(lookup WEEK_WORK_TIME) · #5 InputValue(YesOrNo — 셀콤보와 공유).
//   DayWeek→InputValue enable 토글(§2 #4): DayWeek 값 없으면 InputValue 비활성, 있으면(SelectDay 포함) 활성.
export const ShipmentWorkingDayOspForm = ({ onSubmit, onDivisionChange, onInput }: Props) => {
  const { t } = useTranslation();

  const searchParams = useShipmentWorkingDayOspStore(state => state.searchParams);
  const setSearchParams = useShipmentWorkingDayOspStore(state => state.setSearchParams);
  const isOpenSearchArea = useShipmentWorkingDayOspStore(state => state.isOpenSearchArea);

  // PlantSite 재조회 파라미터 — 선택 division 을 실어 키를 바꾼다. OSP 전용(operationGroup 무관, OSP_YN='Y'는
  //   SQL 본문 고정). divisionId 미선택이면 빈 파라미터로 0건(조회 전 상태). 값은 raw, 인용은 getCombo funnel.
  const plantSiteFilter: ComboParam = {
    comboId: COMBO.PLANT_SITE,
    divisionId: searchParams.divisionId,
  };

  // 콤보 — Division 전량 로드 + PlantSite 는 division 키로 재조회(§3). InputValue(YesOrNo) 는 셀콤보와 공유.
  const [divisions, plantSites, inputValues] = useTabComboQueries({
    filters: [COMBO.DIVISION, plantSiteFilter, COMBO.INPUT_VALUE],
  });
  const [dayWeeks] = useTabLookupQueries({ filters: [DAY_WEEK_LOOKUP] });

  // Division — AS-IS GetDivisionWithoutEE 재현(ATTRIBUTE3<>'EE'). MyDivisionInEE_SCP SQL 은 EE 미제외라
  //   화면에서 제외한다(02 §7-1). ATTRIBUTE3 미제공 응답이면 필터가 전량 통과(방어적, 회귀 없음).
  const divisionOptions = toOptions(
    (divisions ?? []).filter(r => str(r.ATTRIBUTE3).toUpperCase() !== 'EE')
  );

  // PlantSite — 재조회 결과 그대로(server @divisionId 바인딩). 클라 재필터 불필요(§3 재조회형).
  const plantSiteOptions = toOptions(plantSites);

  // InputValue(YesOrNo) — Y/N. cboDayWeek 값이 없으면 비활성(§2 #4). SelectDay 포함 값이 있으면 활성.
  const inputValueOptions = toOptions(inputValues);

  // cboDayWeek = lookup WEEK_WORK_TIME (SEGMENT1=CODE/SEGMENT2=NAME → 공용 lookup 훅 정규화). 기본 SelectDay.
  const dayWeekOptions: Option[] = (dayWeeks ?? []).map(r => {
    const rec = r as Record<string, unknown>;
    return { label: str(rec.NAME) || str(rec.CODE), value: str(rec.CODE) };
  });

  // cboDayWeek→cboInputValue enable 토글(02 §2 #4, AS-IS CboDayWeek_SelectedIndexChanged .cs:669-681):
  //   DayWeek 값이 없으면 InputValue 비활성, 값이 있으면(SelectDay 포함) 활성. SelectDay 는 선택 D_ 셀에
  //   InputValue 값을 일괄 SetText 하는 경로이므로(AS-IS BtnInput_Click .cs:698-707) 활성이어야 한다.
  const isDayWeekEmpty = !searchParams.dayWeekCode;

  const multi = (
    labelCode: string,
    labelEn: string,
    value: string[],
    options: Option[],
    onPick: (codes: string[]) => void
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(labelCode, { defaultValue: labelEn })}
        labelAlign='right'
        render={() => (
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            limitTags={1}
            sortBy='label'
            value={value.join(',')}
            options={options}
            onChange={(_, picked) =>
              // CustomDropdown 전체선택/해제 'ALL' sentinel → 빈 배열 정규화(store orAll 이 'ALL' 로 전송).
              onPick(
                String(picked ?? '')
                  .split(',')
                  .filter(v => v !== '' && v.toUpperCase() !== 'ALL')
              )
            }
          />
        )}
      />
    </Grid>
  );

  return (
    <SearchArea
      searchButtonLabel={t('LBL00664', { defaultValue: 'Search' })}
      isHidden={!isOpenSearchArea}
      onSearch={onSubmit}
      conditions={
        <>
          {/* Division* (cascade 최상위, 필수 — 02 §2 #1) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00641', { defaultValue: 'Division' })}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={searchParams.divisionId}
                  options={divisionOptions}
                  onChange={(_, picked) => {
                    // Division 변경 = 하위(plantSite) cascade 초기화 → PlantSite 콤보 재조회 트리거(§3).
                    setSearchParams({ divisionId: String(picked ?? ''), plantSiteIds: [] });
                    // 조회조건뿐 아니라 Grid 도 비운다 — 이전 division 결과·미저장 편집 폐기(nscm-patterns §5).
                    onDivisionChange();
                  }}
                />
              )}
            />
          </Grid>
          {multi('LBL00005', 'Plant Site', searchParams.plantSiteIds, plantSiteOptions, plantSiteIds =>
            setSearchParams({ plantSiteIds })
          )}
          {/* dCalendar 조회기간 — 공용 PeriodField(features/master 카탈로그, 타 supply 화면 1:1). */}
          <PeriodField
            gridSize={3}
            start={searchParams.startYyyymmdd}
            end={searchParams.endYyyymmdd}
            onChange={(start, end) => setSearchParams({ startYyyymmdd: start, endYyyymmdd: end })}
            label={t('LBL00013', { defaultValue: 'Period' })}
          />
          {/* Day of the week (lookup WEEK_WORK_TIME, 기본 SelectDay — 02 §2 #4). btnInput 값입력 대상 요일 결정. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00666', { defaultValue: 'Day of the week' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={searchParams.dayWeekCode}
                  options={dayWeekOptions}
                  onChange={(_, picked) =>
                    setSearchParams({ dayWeekCode: String(picked ?? DAY_WEEK.SELECT_DAY) })
                  }
                />
              )}
            />
          </Grid>
          {/* Input Value(cboInputValue YesOrNo) — 선택 D_ 셀에 요일단위 Y/N write(02 §2 #5). SelectDay 면 비활성(§5). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00665', { defaultValue: 'Input Value' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={isDayWeekEmpty}
                  value={searchParams.inputValue}
                  options={inputValueOptions}
                  onChange={(_, picked) => setSearchParams({ inputValue: String(picked ?? '') })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <Button
              appearance='outlined'
              priority='normal'
              // btnInput 가드(조회 전/SelectDay 셀 미선택/형식)는 onInput(부모)에서 순서대로 판정.
              //   버튼 자체는 DayWeek 값이 있으면 활성(값 없을 때만 비활성 — AS-IS BtnInput 가드 #4 :710-713).
              disabled={isDayWeekEmpty}
              onClick={onInput}
            >
              {t('LBL00667', { defaultValue: 'Input' })}
            </Button>
          </Grid>
        </>
      }
    />
  );
};
