// SCP0125 조회조건 — 6필드 1행(좌→우 = AS-IS x좌표·TabIndex 순서, design 01_layout.md §1.1).
//   6필드라 2단 초과 접기(hook #52)는 미해당 → `extraConditions` 불요.
//
// AS-IS 근거: Designer.cs:281~401(레이아웃) · cs:203·276·289(setListBox) · cs:254~279(R04 ①) ·
//             cs:2007~2046(R03·R04 ②) · cs:190~191(R01 권한 게이트)

import dayjs from 'dayjs';
import { useEffect, useMemo, useRef } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { DatePickerCalendar, FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { useWorkbenchStore } from '../useWorkbenchStore';
import { filterPlanDates, filterVersions, stripTimeFromLabel } from '../utils/workbench.cascade';
import {
  COMBO,
  LBL,
  MSG,
  resolvePlanDateMode,
  usesVersion,
} from '../workbench.constants';
import type { WorkbenchInitData } from '../workbench.types';

interface Props {
  init: WorkbenchInitData;
  isGmDivision: boolean;
  onSearch: () => void;
  /** Division 변경(E01) — 하위 콤보 재계산 + 5탭 그리드 비움(R05). 페이지가 소유한다. */
  onDivisionChange: (divisionId: string) => void;
  /** Plan Date(주) 변경(E02) — Version 만 재계산 + 그리드 비움(R06). */
  onPlanDateChange: (planStartYyyymmdd: string) => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (value: unknown): string =>
  typeof value === 'string' ? value : typeof value === 'number' ? String(value) : '';

export const WorkbenchForm = ({
  init,
  isGmDivision,
  onSearch,
  onDivisionChange,
  onPlanDateChange,
}: Props) => {
  const { t } = useTranslation();

  const searchParams = useWorkbenchStore(state => state.searchParams);
  const setSearchParams = useWorkbenchStore(state => state.setSearchParams);
  const openSearchArea = useWorkbenchStore(state => state.openSearchArea);
  const activeTab = useWorkbenchStore(state => state.activeTab);
  const authAlerted = useWorkbenchStore(state => state.authAlerted);
  const markAuthAlerted = useWorkbenchStore(state => state.markAuthAlerted);
  const setAlert = useMessageStore(state => state.setAlert);

  // Q1 Division — `Division_SCP_NoEE`(EE 제외를 WHERE 에 흡수한 등록본).
  //   주의(2026-09-26 정정): 여기서 `mnuId` 를 안 넘긴다고 **미전달이 되지 않는다**. 공용 훅
  //   `packages/shared/src/hooks/useCustomQueryClient.ts` 의 `withMenuId` 가 `MenuIdContext` 값을
  //   **기본 주입**하므로 실제로는 `@mnuId='SCP0125'` 가 실려, 이 SQL 의
  //   `NVL(TRIM(@mnuId),'ALL')='ALL' OR U.USER_GR_ID IN (SCP0125 grant 그룹)` 분기가 활성화된다 —
  //   AS-IS `FN_GET_DIVISION(groupId,userId)` 에는 없던 축이다.
  //   실측(2026-09-26, 등록 SQL 본문을 사용자별로 그대로 실행): 이 화면을 **열 수 있는** 사용자 22명 중
  //   주입 때문에 division 후보를 잃는 사용자가 **2명**(`loveidea`·`test001`: 1건 → 0건)이다.
  //   원인은 division 권한을 `SPMS ADMIN` 그룹에서 받고 메뉴 권한은 `ADMIN` 그룹에서 받아 교차에서
  //   탈락하는 것. 0건이 되면 아래 `noAuthority` 로 조회영역 전체가 비활성된다(= 화면 사용 불가).
  //   두 계정 모두 `SCM_ADM_USER_M.LOGN_DTM` 이 NULL(미로그인)이라 **현재 실사용 피해는 없으나**,
  //   앞으로 같은 그룹 조합의 계정이 생기면 즉시 재현된다.
  //   되돌리려면 리포 전역 규범(콤보 mnuId 기본 주입)을 이 화면만 무력화해야 하므로 사용자 결정 대상.
  // Q2 Plan Date(주) — 전건 반환 콤보. division 필터는 아래 filterPlanDates(F02)가 재현한다.
  const [divisionRows, planDateRows] = useTabComboQueries({
    filters: [COMBO.DIVISION, COMBO.PLAN_DATE_WEEKLY],
  });

  const divisionOptions = useMemo<Option[]>(
    () =>
      (divisionRows ?? []).map(row => ({
        // 표시값은 NAME(= '{DIVISION_ID} {DIVISION_NAME}') — 코드만 뜨는 콤보 재사용 금지(W03).
        label: str(row.NAME) || str(row.CODE),
        value: str(row.CODE),
      })),
    [divisionRows]
  );

  const planDateOptions = useMemo<Option[]>(
    () =>
      filterPlanDates(planDateRows, searchParams.divisionId).map(row => ({
        label: stripTimeFromLabel(str(row.NAME) || str(row.CODE)),
        value: str(row.CODE),
      })),
    [planDateRows, searchParams.divisionId]
  );

  const versionOptions = useMemo<Option[]>(
    () =>
      filterVersions(
        init.versionAll,
        searchParams.divisionId,
        searchParams.planStartYyyymmdd
      ).map(row => ({ label: str(row.NAME) || str(row.CODE), value: str(row.CODE) })),
    [init.versionAll, searchParams.divisionId, searchParams.planStartYyyymmdd]
  );

  // R01 — 권한 Division 0건이면 조회조건 전 필드 비활성 + alert 1회.
  //   판정은 USER_ID 기준 서버 조회 결과의 **행수 0 여부**만 본다(hook #128, FE 그룹 선택 금지).
  const noAuthority = divisionRows !== undefined && divisionOptions.length === 0;
  useEffect(() => {
    if (!noAuthority || authAlerted) return;
    markAuthAlerted();
    void setAlert({
      type: 'alert',
      content: t(MSG.NO_AUTHORITY, '_No authority assigned.'),
    });
  }, [noAuthority, authAlerted, markAuthAlerted, setAlert, t]);

  // 기본 선택값 = 목록 첫 행(AS-IS WinForms DataSource 바인딩의 index 0 자동선택, §4.2 W04·W07).
  //   세션 division 을 끼워넣지 않는다.
  useEffect(() => {
    if (divisionOptions.length === 0) return;
    if (divisionOptions.some(option => option.value === searchParams.divisionId)) return;
    onDivisionChange(divisionOptions[0].value);
  }, [divisionOptions, searchParams.divisionId, onDivisionChange]);

  useEffect(() => {
    if (planDateOptions.length === 0) return;
    if (planDateOptions.some(option => option.value === searchParams.planStartYyyymmdd)) return;
    onPlanDateChange(planDateOptions[0].value);
  }, [planDateOptions, searchParams.planStartYyyymmdd, onPlanDateChange]);

  useEffect(() => {
    if (versionOptions.some(option => option.value === searchParams.versionNo)) return;
    setSearchParams({ versionNo: versionOptions[0]?.value ?? '' });
  }, [versionOptions, searchParams.versionNo, setSearchParams]);

  // R04 / V05 — Plan Date 위젯 배타 노출(항상 정확히 1개) + `daily` **진입마다** 값을 오늘로 재설정.
  //   AS-IS 는 위젯이 노출될 때마다 `DateTime.Now` 로 덮어쓴다(cs:268 최초 진입 · cs:2039
  //   ActiveSheetChanged). "비어 있을 때만 채우기" 로 두면 설계 V05("값=오늘")와 어긋난다.
  //   재설정은 weekly→daily **전이 시점**에만 한다 — 매 렌더로 덮으면 daily 안에서 사용자가 고른
  //   날짜를 지워 조회 자체가 불가능해진다. B2 결정(표시일 = 조회일 = CUTOFF 기준일 일치)은
  //   `planStartYyyymmdd` 단일 원천이 보장하므로 이 재설정과 충돌하지 않는다.
  const planDateMode = resolvePlanDateMode(activeTab, isGmDivision);
  const prevPlanDateModeRef = useRef(planDateMode);
  useEffect(() => {
    const entered = prevPlanDateModeRef.current !== 'daily' && planDateMode === 'daily';
    prevPlanDateModeRef.current = planDateMode;
    if (planDateMode !== 'daily') return;
    // 진입 전이 또는 값 부재(최초 mount 가 이미 daily 인 경우) → 오늘로 설정.
    if (entered || !searchParams.planDateDaily)
      setSearchParams({ planDateDaily: dayjs().format('YYYYMMDD') });
  }, [planDateMode, searchParams.planDateDaily, setSearchParams]);

  const dailyValue = useMemo(() => {
    if (!searchParams.planDateDaily) return null;
    const parsed = dayjs(searchParams.planDateDaily, 'YYYYMMDD');
    return parsed.isValid() ? parsed : null;
  }, [searchParams.planDateDaily]);

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, 'Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* 1 Division (단일, ALL 옵션 없음 — setListBox(blnAllFlag:false) cs:203). 기본 포커스. */}
          <Grid size={2}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, 'Division')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  autoFocus
                  value={searchParams.divisionId}
                  options={divisionOptions}
                  disabled={noAuthority}
                  onChange={(_, picked) => onDivisionChange(String(picked ?? ''))}
                />
              )}
            />
          </Grid>

          {/* 2 Plan Date(주단위) — R04 배타 노출. 표시명에서 시각을 떼어 AS-IS 표기로 맞춘다(U2). */}
          {planDateMode === 'weekly' && (
            <Grid size={2}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.PLAN_DATE, 'Plan Date')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    value={searchParams.planStartYyyymmdd}
                    options={planDateOptions}
                    disabled={noAuthority}
                    onChange={(_, picked) => onPlanDateChange(String(picked ?? ''))}
                  />
                )}
              />
            </Grid>
          )}

          {/* 3 Plan Date(일단위) — GM 사업부 + Stock 계열 3탭에서만 노출. MinDate/MaxDate = Designer:144~145. */}
          {planDateMode === 'daily' && (
            <Grid size={2}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.PLAN_DATE, 'Plan Date')}
                labelAlign='right'
                render={() => (
                  <DatePickerCalendar
                    usecase='date'
                    elevation
                    size='small'
                    format='YYYY.MM.DD'
                    disabled={noAuthority}
                    mindate={dayjs('19990101', 'YYYYMMDD')}
                    maxdate={dayjs('20991231', 'YYYYMMDD')}
                    value={dailyValue}
                    onChange={
                      ((date: dayjs.Dayjs | null) => {
                        setSearchParams({ planDateDaily: date?.format('YYYYMMDD') ?? '' });
                      }) as never
                    }
                  />
                )}
              />
            </Grid>
          )}

          {/* 4 MKT FCST Ver. — MKT FCST 탭에서만 노출(R03). 숨김 시 versionNo 는 '' 로 전송(W12). */}
          {usesVersion(activeTab) && (
            <Grid size={2}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.VERSION, 'MKT FCST Ver.')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    value={searchParams.versionNo}
                    options={versionOptions}
                    disabled={noAuthority}
                    onChange={(_, picked) => setSearchParams({ versionNo: String(picked ?? '') })}
                  />
                )}
              />
            </Grid>
          )}

          {/* 5 Nick Name — 자유입력. Trim 만 적용(대소문자 변환·와일드카드 부착 없음, W20). */}
          <Grid size={2}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.NICK_NAME, 'Nick Name')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={searchParams.nickName}
                  disabled={noAuthority}
                  onChange={event => setSearchParams({ nickName: event.target.value })}
                />
              )}
            />
          </Grid>

          {/* 6 Model */}
          <Grid size={2}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL, 'Model')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={searchParams.itemId}
                  disabled={noAuthority}
                  onChange={event => setSearchParams({ itemId: event.target.value })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};

// 조회조건에 필수(`*`) 표시는 0건이다 — AS-IS LayoutControlItem Text 6개 중 `*` 로 끝나는 것이
//   없어 `DataUtil.checkRequiredOfSearch` 의 필수 분기가 미발동한다(R02 / V02 / W17).
