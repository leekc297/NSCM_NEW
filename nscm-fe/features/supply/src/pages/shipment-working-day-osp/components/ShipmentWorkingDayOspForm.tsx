import { useEffect, useMemo, useRef } from 'react';

import type { ComboParam, ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { sessionTimeZone } from '@foundation/utils';
import { CustomDropdown, PeriodRangePicker, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useSessionStore, useTabid } from '@shared/stores';

import {
  COMBO,
  DAY_RANGE_PARAMS,
  LBL,
  MENU_ID,
  RESPONSE_SET,
  SHEETS,
} from '../shipment-working-day-osp.constants';
import { useShipmentWorkingDayOspStore } from '../useShipmentWorkingDayOspStore';

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

// 02_search-combo.md 조회조건 콤보 5(영역2).
//   #1 Division(Division_SCP_NoEE 권한 @sesUserId+@mnuId + ATTRIBUTE3<>'EE' 서버필터) — 필수, cascade 상위.
//      AS-IS GetDivisionWithoutEE 재현(gap-resolve iter-2 G9 — 이전 'MyDivisionInEE_SCP' 는 ATTRIBUTE3 를
//      반환하지 않아 클라필터가 무동작이었음. 서버 필터를 가진 자매 등록행으로 교체).
//   #2 PlantSite(PlantByDivisionOperOsp3_SCP, OSP_YN='Y' 고정) — cascade 재조회형: 선택 division 을
//      ComboParam.divisionId 로 실어 react-query 키를 바꿔 자동 재조회(TactTime 필터형과 달리 §3 재조회).
//   #3 Period(dCalendar). (DayWeek·InputValue·Input 버튼은 조회조건에서 분리 — 버튼영역 '입력' 버튼이 여는
//   ShipmentWorkingDayOspInputModal 로 이동, 2026-10-15 사용자 지시.)
export const ShipmentWorkingDayOspForm = ({ onSubmit, onDivisionChange }: Props) => {
  const { t } = useTranslation();

  const searchParams = useShipmentWorkingDayOspStore(state => state.searchParams);
  const setSearchParams = useShipmentWorkingDayOspStore(state => state.setSearchParams);
  const setDivision = useShipmentWorkingDayOspStore(state => state.setDivision);
  const isOpenSearchArea = useShipmentWorkingDayOspStore(state => state.isOpenSearchArea);

  const tabId = useTabid();

  // PlantSite 재조회 파라미터 — 선택 division 을 실어 키를 바꾼다. OSP 전용(operationGroup 무관, OSP_YN='Y'는
  //   SQL 본문 고정). divisionId 미선택이면 빈 파라미터로 0건(조회 전 상태). 값은 raw, 인용은 getCombo funnel.
  const plantSiteFilter: ComboParam = {
    comboId: COMBO.PLANT_SITE,
    divisionId: searchParams.divisionId,
  };

  // 콤보 — Division 전량 로드 + PlantSite 는 division 키로 재조회(§3).
  const [divisions, plantSites] = useTabComboQueries({
    filters: [COMBO.DIVISION, plantSiteFilter],
  });

  // Division — EE 제외는 COMBO.DIVISION(Division_SCP_NoEE) SQL 의 ATTRIBUTE3<>'EE' 서버 필터로 처리된다.
  const divisionOptions = toOptions(divisions);

  // WLast 프리셋(PeriodRangePicker)용 사업부 기본기간 주차 — SCM_MST_DIVISION.DAILY_PLAN_PERIOD.
  //   Division_SCP_NoEE 콤보가 이 컬럼을 함께 반환(DB 실측)하므로 선택행에서 읽는다. 조회기간 "기본값"은
  //   아래 dayRange SP 가 산정하고, 이 값은 WLast 프리셋 버튼에만 쓴다(production-plan-line 동형).
  const divisionPeriod =
    Number(
      (divisions ?? []).find(r => str(r.CODE) === searchParams.divisionId)?.DAILY_PLAN_PERIOD
    ) || 0;

  // AS-IS DateUtil.GetDayRange(division,"DAILY") 재현 — 조회기간 기본값은 서버 SP(dayRange)가 산정한다
  //   (SCP0096.cs:837 → DateUtil.cs:156 → PKG_COM0000.P_SCM0001_GET_SCP_MONTH_PERIOD). 클라 계산 아님.
  //   필터는 divisionId 가 바뀔 때만 새 참조가 되도록 useMemo 로 고정한다(useTabProcQuery 참조고정 규약).
  //   timeZone 은 사용자 등록 timezone(session.tmzCd) — SP 가 FN_MULTY_TIME 으로 사용자 기준 '오늘'을 잡는다.
  const tmzCd = sessionTimeZone(useSessionStore(state => state.session));
  const periodFilter = useMemo(
    () => ({ divisionId: searchParams.divisionId, ...DAY_RANGE_PARAMS, timeZone: tmzCd }),
    [searchParams.divisionId, tmzCd]
  );
  const { data: periodData } = useTabProcQuery<MENU_ID, SHEETS.PERIOD>({
    menuId: MENU_ID,
    sheetName: SHEETS.PERIOD,
    tabId,
    filters: periodFilter,
    enabled: !!searchParams.divisionId,
  });

  // SP 결과 O_RC1.PERIOD='YYYYMMDD:YYYYMMDD' 를 조회기간에 적용 — division 이 바뀌어 새 결과가 올 때만 1회
  //   적용(appliedPeriodDivisionRef 가드)해, 그 사이 사용자의 기간 수동 편집은 보존한다(AS-IS 는 division 종속).
  //   PERIOD 가 NULL/형식불량이면 skip(store 기본기간 유지). 컬럼키는 PERIOD, 안전하게 positional fallback.
  const appliedPeriodDivisionRef = useRef<string>('');
  useEffect(() => {
    const rows = (periodData as { o_rc1?: Record<string, unknown>[] })?.[RESPONSE_SET.PERIOD];
    const first = rows?.[0];
    if (!first) return;
    const raw = first.PERIOD ?? Object.values(first)[0];
    const [from, to] = str(raw).split(':');
    if (!/^\d{8}$/.test(from ?? '') || !/^\d{8}$/.test(to ?? '')) return;
    if (appliedPeriodDivisionRef.current === searchParams.divisionId) return;
    appliedPeriodDivisionRef.current = searchParams.divisionId;
    setSearchParams({ startYyyymmdd: from, endYyyymmdd: to });
  }, [periodData, searchParams.divisionId, setSearchParams]);

  // PlantSite — 재조회 결과 그대로(server @divisionId 바인딩). 클라 재필터 불필요(§3 재조회형).
  const plantSiteOptions = toOptions(plantSites);

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
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!isOpenSearchArea}
      onSearch={onSubmit}
      conditions={
        <>
          {/* Division* (cascade 최상위, 필수 — 02 §2 #1) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Div.')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={searchParams.divisionId}
                  options={divisionOptions}
                  onChange={(_, picked) => {
                    // Division 변경 = 검색조건(Div·기간 제외) + 그리드 초기화(store setDivision, TO-BE 공통 요건).
                    //   편집중(dirty)이면 MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가 이전 Div 로
                    //   복귀(commit 51d4e9fa 패턴). setDivision 이 plantSite cascade 도 초기화 → PlantSite 재조회(§3).
                    const v = String(picked ?? '');
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (!ok) return;
                      setDivision(v);
                      // 미저장 편집 폐기·hasSearched 리셋 — 부모 resetGrid(이전 division 결과도 폐기).
                      onDivisionChange();
                    });
                  }}
                />
              )}
            />
          </Grid>
          {multi(LBL.PLANT_SITE, '_Plant Site', searchParams.plantSiteIds, plantSiteOptions, plantSiteIds =>
            setSearchParams({ plantSiteIds })
          )}
          {/* 조회기간 — 공용 PeriodRangePicker(2개월 달력 팝업 + 프리셋 내장, 값 YYYYMMDD).
              사용자 지시 2026-10-13: features/master PeriodField → shared PeriodRangePicker 로 교체. */}
          <Grid size={3}>
            <PeriodRangePicker
              start={searchParams.startYyyymmdd}
              end={searchParams.endYyyymmdd}
              onChange={(start, end) => setSearchParams({ startYyyymmdd: start, endYyyymmdd: end })}
              label={t(LBL.PERIOD, '_Period')}
              // AS-IS 필수값(checkRequiredOfSearch .cs:435 — Division/기간) — Division 과 동일하게 필수 표시.
              required
              className={commonStyles.formItem}
              // WLast 프리셋 = 사업부 DAILY_PLAN_PERIOD(주). 52면 W52와 중복이라 내부에서 자동 숨김.
              lastWeeks={divisionPeriod || undefined}
            />
          </Grid>
          {/* Day of the week · Input Value · Input 버튼은 버튼영역 '입력' 버튼이 여는
              ShipmentWorkingDayOspInputModal 로 이동했다(2026-10-15 사용자 지시). */}
        </>
      }
    />
  );
};
