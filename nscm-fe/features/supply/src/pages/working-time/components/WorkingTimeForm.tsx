import { PeriodField } from 'features/master/src/components';
import { useEffect } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import { useWorkingTimeStore } from '../useWorkingTimeStore';
import { COMBO, LBL } from '../working-time.constants';

interface Props {
  onSubmit: () => void;
  // Division 변경 = Grid 초기화 (부모 resetGrid — 조회 결과·미저장 편집 폐기)
  onDivisionChange: () => void;
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
export const WorkingTimeForm = ({ onSubmit, onDivisionChange }: Props) => {
  const { t } = useTranslation();

  const searchParams = useWorkingTimeStore(state => state.searchParams);
  const setSearchParams = useWorkingTimeStore(state => state.setSearchParams);
  const setDivision = useWorkingTimeStore(state => state.setDivision);
  const isOpenSearchArea = useWorkingTimeStore(state => state.isOpenSearchArea);

  const tabId = useTabid();

  // 콤보 — 전량 조회 후 client-side cascade 필터(§3 필터형).
  //   cboDivision(MyDivision, 권한 @sesUserId+@mnuId 내장) / clbPlantSite(Osp4_ALL) / clbOperation(WT_SCP) /
  //   clbLine(AddOSP2_ALL). Building(hidden)은 렌더 안 하나 Line 다중키 필터를 위해 데이터소스는 로드한다.
  const [divisions, plantSites, buildings, operations, lines] = useTabComboQueries({
    filters: [COMBO.DIVISION, COMBO.PLANT_SITE, COMBO.BUILDING, COMBO.OPERATION, COMBO.LINE],
  });

  const divisionOptions = toOptions(divisions);

  // Division 기본값 교정 — 현재값이 옵션에 없으면(초기 '' 포함) 권한목록 첫 항목을 선택한다. AS-IS cboDivision
  //   addAll=false, 명시 선택 없음 → 권한목록 첫 항목 기본선택(design 02 §2). session.div/'40' 을 기본으로
  //   쓰지 않는다 — AS-IS 는 세션값이 아니라 목록 첫 항목을 쓴다(사용자 지시 2026-10-15, global-psi-report 선례).
  const firstDivision = divisionOptions[0]?.value ?? '';
  const hasDivision = divisionOptions.some(o => o.value === searchParams.divisionId);
  useEffect(() => {
    if (firstDivision && !hasDivision) setDivision(firstDivision);
  }, [firstDivision, hasDivision, setDivision]);

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
                    const v = String(picked ?? '');
                    // Division 변경 = 검색조건(Div·기간 제외) + 그리드 초기화(store setDivision, TO-BE 공통 요건).
                    //   편집중(dirty)이면 MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가 이전 Div 로
                    //   복귀(commit 51d4e9fa 패턴). ok 후 setDivision 이 조회조건+filters 를 비우고,
                    //   onDivisionChange(부모 resetGrid)가 EditTracker·hasSearched 를 되돌린다.
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (!ok) return;
                      setDivision(v);
                      onDivisionChange();
                    });
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
          {/* Day of the week · Input Value · Input 버튼은 조회조건에서 분리 — 버튼영역 '입력' 버튼이 여는
              WorkingTimeInputModal 로 이동했다(2026-10-15 사용자 지시, 자매 SCP0096 shipment-working-day-osp 선례). */}
        </>
      }
    />
  );
};
