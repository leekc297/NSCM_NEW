import { PeriodField } from 'features/master/src/components';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { useWorkingTimeStore } from '../useWorkingTimeStore';
import { COMBO, DAY_WEEK_LOOKUP, DAY_WEEK_SELECT_DAY, LBL } from '../working-time.constants';

interface Props {
  onSubmit: () => void;
  // Division 변경 = Grid 초기화 (부모 resetGrid — 조회 결과·미저장 편집 폐기)
  onDivisionChange: () => void;
  // btnInput 값입력 — 부모(WorkingTime)가 가드(조회 전/SelectDay/셀 미선택/범위) 후 선택 D_ 셀에 write.
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

// 02_search-combo.md 조회조건 콤보(영역2). cascade 는 전부 필터형 — _SCP_ALL 3콤보를 전량 로드 후
//   FE 에서 client-side 필터(AS-IS DBUtils.Filter 재현, §3). Division 변경 = 하위 초기화 + Grid 비움.
//   Building/Bucket/Sum 은 정적 hidden(01_layout §3) — 렌더하지 않는다.
export const WorkingTimeForm = ({ onSubmit, onDivisionChange, onInput }: Props) => {
  const { t } = useTranslation();

  const searchParams = useWorkingTimeStore(state => state.searchParams);
  const setSearchParams = useWorkingTimeStore(state => state.setSearchParams);
  const isOpenSearchArea = useWorkingTimeStore(state => state.isOpenSearchArea);

  // 콤보 — 전량 조회 후 client-side cascade 필터(§3 필터형).
  //   cboDivision(MyDivision, 권한 @sesUserId+@mnuId 내장) / clbPlantSite(Osp4_ALL) / clbOperation(WT_SCP) /
  //   clbLine(AddOSP2_ALL). Building(hidden)은 렌더 안 하나 Line 다중키 필터를 위해 데이터소스는 로드한다.
  const [divisions, plantSites, buildings, operations, lines] = useTabComboQueries({
    filters: [COMBO.DIVISION, COMBO.PLANT_SITE, COMBO.BUILDING, COMBO.OPERATION, COMBO.LINE],
  });
  const [dayWeeks] = useTabLookupQueries({ filters: [DAY_WEEK_LOOKUP] });

  const divisionOptions = toOptions(divisions);

  // clbPlantSite = division 하위 (DBUtils.Filter DIVISION_ID = division, §3 필터 #1)
  const plantSiteOptions = toOptions(
    (plantSites ?? []).filter(r => !searchParams.divisionId || str(r.DIVISION_ID) === searchParams.divisionId)
  );
  // clbOperation = 전체 유지(필터 없음, §3)
  const operationOptions = toOptions(operations);
  // clbLine = division + 선택 plantSite/building/operation 다중키 하위 (§3 RefreshLine 조건식).
  //   미선택 축은 필터하지 않는다(IS NOT NULL 등가). buildings 는 Line 필터축(FACTORY_ID)이므로 로드만.
  const lineOptions = toOptions(
    (lines ?? []).filter(r => {
      if (searchParams.divisionId && str(r.DIVISION_ID) !== searchParams.divisionId) return false;
      if (searchParams.plantSiteIds.length && !searchParams.plantSiteIds.includes(str(r.SITE_ID)))
        return false;
      if (searchParams.buildingIds.length && !searchParams.buildingIds.includes(str(r.FACTORY_ID)))
        return false;
      if (searchParams.operationIds.length && !searchParams.operationIds.includes(str(r.OPERATION_GROUP)))
        return false;
      return true;
    })
  );
  // cboDayWeek = lookup WEEK_WORK_TIME (SEGMENT1=CODE/SEGMENT2=NAME → 공용 lookup 훅이 CODE/NAME 정규화).
  //   기본 SelectDay(값입력 전 미선택 상태, §2-b). ALL 옵션 없음(단일 필수 성격).
  //   LookupResponse 는 ComboResponse 와 별 타입이라 toOptions 를 쓰지 않고 인라인 매핑(TactTime 1:1).
  const dayWeekOptions: Option[] = (dayWeeks ?? []).map(r => {
    const rec = r as Record<string, unknown>;
    return { label: str(rec.NAME) || str(rec.CODE), value: str(rec.CODE) };
  });

  // buildings 는 Line 필터를 위해 쓰이나 UI 는 hidden(01_layout §3) — 참조만 하고 렌더 안 함.
  void buildings;

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
        label={t(labelCode, labelEn)}
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
              // CustomDropdown 은 전체선택/해제를 'ALL' sentinel 로 내보낸다 — 실제 코드로 담으면 하위
              //   cascade 가 'ALL' 을 코드로 매칭해 0건이 된다. 빈 배열로 정규화(TactTime 표준 1:1).
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
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!isOpenSearchArea}
      onSearch={onSubmit}
      conditions={
        <>
          {/* Division* (cascade 최상위, 필수 — §2 #1) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Div')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={searchParams.divisionId}
                  options={divisionOptions}
                  onChange={(_, picked) => {
                    // Division 변경 = 하위(plantSite/building/operation/line) cascade 초기화 (§3)
                    setSearchParams({
                      divisionId: String(picked ?? ''),
                      plantSiteIds: [],
                      buildingIds: [],
                      operationIds: [],
                      lineIds: [],
                    });
                    // 조회조건뿐 아니라 Grid 도 비운다 — 남은 결과는 이전 Division 으로 조회된 것이라
                    //   새 조건과 어긋나고, 미저장 편집이 남으면 바뀐 전제로 저장된다(nscm-patterns §5).
                    onDivisionChange();
                  }}
                />
              )}
            />
          </Grid>
          {multi(LBL.PLANT_SITE, '_Plant Site', searchParams.plantSiteIds, plantSiteOptions, plantSiteIds =>
            // plantSite 변경 = line 초기화 (§3 RefreshLine 재필터)
            setSearchParams({ plantSiteIds, lineIds: [] })
          )}
          {multi(LBL.OPERATION, '_Operation', searchParams.operationIds, operationOptions, operationIds =>
            setSearchParams({ operationIds, lineIds: [] })
          )}
          {multi(LBL.LINE, '_Line', searchParams.lineIds, lineOptions, lineIds =>
            setSearchParams({ lineIds })
          )}
          {/* Day of the week (lookup WEEK_WORK_TIME, 기본 SelectDay — §2-b). btnInput 값입력 대상 요일 결정. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DAY_OF_WEEK, '_Day of the week')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={searchParams.dayWeekCode}
                  options={dayWeekOptions}
                  onChange={(_, picked) =>
                    setSearchParams({ dayWeekCode: String(picked ?? DAY_WEEK_SELECT_DAY) })
                  }
                />
              )}
            />
          </Grid>
          {/* dCalendar 조회기간 — 공용 PeriodField(features/master 카탈로그, 타 supply 화면 1:1). */}
          <PeriodField
            gridSize={3}
            start={searchParams.startYyyymmdd}
            end={searchParams.endYyyymmdd}
            onChange={(start, end) =>
              setSearchParams({ startYyyymmdd: start, endYyyymmdd: end })
            }
            label={t(LBL.PERIOD, '_Period')}
          />
          {/* Input Value(txtInpuValue MaxLength 4) + btnInput — 선택 D_ 셀에 요일단위 값 write(01_layout §1). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.INPUT_VALUE, '_Input Value')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={searchParams.inputValue}
                  inputProps={{ maxLength: 4 }}
                  onChange={e => {
                    // 0~7(요일단위)/0~1440(분단위) 범위는 write 시점(Grid)에서 검증(MSG00203). 여기선 숫자만 수용.
                    const next = e.target.value.replace(/[^\d]/g, '');
                    setSearchParams({ inputValue: next });
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <Button
              appearance='outlined'
              priority='normal'
              // btnInput 가드 #3(SelectDay)/#1(조회 전) 등은 onInput(부모)·Grid 에서 순서대로 판정.
              disabled={searchParams.dayWeekCode === DAY_WEEK_SELECT_DAY}
              onClick={onInput}
            >
              {t(LBL.INPUT, '_Input')}
            </Button>
          </Grid>
        </>
      }
    />
  );
};
