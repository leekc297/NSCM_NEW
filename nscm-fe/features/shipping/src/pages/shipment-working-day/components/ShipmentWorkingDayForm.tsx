import { PeriodField } from 'features/master/src/components';
import { useEffect, useMemo, useRef } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { ALL, COMBO, DEFAULT_DAY_WEEK, LBL } from '../shipment-working-day.constants';
import { useShipmentWorkingDayStore } from '../useShipmentWorkingDayStore';

interface Props {
  onSearch: () => void;
  // btnInput 일괄입력 — 가드 판정과 write 는 부모가 한다(grid/EditTracker 소유자).
  onInput: () => void;
  // AS-IS SetDivisionAuthCheck(usrLayoutControl2.Enabled=false) 등가 — 권한 Division 0건이면
  //   조회조건 전체를 잠근다(01 R01).
  disabled: boolean;
  // Input 버튼 활성 조건 = EDIT 권한(AS-IS ButtonAccessType=None 이라 전용 버튼코드가 없어
  //   EDIT 를 대리 게이트로 쓴다, 01 R13). 클릭 핸들러만 막으면 살아 보이는 죽은 버튼이 남는다.
  canEdit: boolean;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// 02_search-combo.md 영역2 — 조회조건 5필드 + Input 액션 버튼(AS-IS 2행 3열).
//   F1 Company(Company_SSP0005 — 화면 전용, COMPANY_NAME 표시 + ORDER BY) · F2 Div.(MyDivision,
//   권한 콤보) · F3 Period*(기본값은 SP) · F4 Day of the week(lookup WEEK_WORK_TIME) ·
//   F5 Input Value(YesOrNo) · F6 Input 버튼(조회조건 격자 6번째 칸 — 툴바도 extraButtons 도 아님).
//   cascade 는 0건이다(02 §3.1 7축 실측) — useCascadeFields 를 신설하지 않는다.
export const ShipmentWorkingDayForm = ({ onSearch, onInput, disabled, canEdit }: Props) => {
  const { t } = useTranslation();

  const sc = useShipmentWorkingDayStore(s => s.searchCondition);
  const setSearchCondition = useShipmentWorkingDayStore(s => s.setSearchCondition);
  const openSearchArea = useShipmentWorkingDayStore(s => s.openSearchArea);

  // 콤보 3종 1 라운드트립.
  //   주의: mnuId 는 화면이 지정하지 않아도 공용 withMenuId 가 탭 menuId 를 자동 주입한다 —
  //   "미전송"(02 §2.1 ④-b / V-21)은 화면 코드로 달성할 수 없다. MyDivision SQL 본문에
  //   `NVL(TRIM(@mnuId),'ALL')='ALL' OR ...` 토큰이 실존하므로, 그룹->메뉴 매핑
  //   (SCM_ADM_USER_GR_MNU_MPG_M)이 비면 교집합이 0행이 되어 Division 콤보가 통째로 비고
  //   권한 게이트가 오발동한다. SSP0005 는 그 매핑 2행(ADMIN / SSP Planner)만 등록돼 있어
  //   오픈 가능 19명 중 2명(메뉴는 ADMIN, Division unit auth 는 SPMS ADMIN)이 실제로 콤보 0행이
  //   된다(gap-resolve iter-1 DB 재실측 — iter-2 의 "영향 0건" 서술은 반증됐다). 해소는 admin
  //   권한 등록 축이며 화면 코드로 끌 수 없다(04_react-gap.md Δ7 / 05_runtime-parity.md H1).
  // Day of the week 는 AS-IS Data.Common(LookupCommon,"WEEK_WORK_TIME") 를 그대로 이관한
  //   콤보 COMBO.DAY_WEEK({comboId:'LookupCommon', lookupType:'WEEK_WORK_TIME'})로 받는다 — 그
  //   콤보 SQL 이 ORDER BY B.DISPLAY_SEQ 라 EveryDay/SelectDay/Mon~Sun 순으로 온다. 종전 generic
  //   lookup(useTabLookupQueries) 은 정렬이 빠져 CODE 알파벳순이었다(2026-09-30 담당 확인).
  const [companies, divisions, inputValues, dayWeeks] = useTabComboQueries({
    filters: [COMBO.COMPANY, COMBO.DIVISION, COMBO.INPUT_VALUE, COMBO.DAY_WEEK],
  });

  const companyOptions = useMemo(() => toOptions(companies), [companies]);
  const divisionOptions = useMemo(() => toOptions(divisions), [divisions]);
  const inputValueOptions = useMemo(() => toOptions(inputValues), [inputValues]);
  const dayWeekOptions = useMemo<Option[]>(() => toOptions(dayWeeks), [dayWeeks]);

  // divisionId='ALL' 전개용 코드 목록은 **페이지가 공급한다**(ShipmentWorkingDay.tsx).
  //   금지: 여기서도 setDivisionCodes 를 부르면 두 공급자가 서로 다른 정규화 결과를 번갈아 써
  //   무한 갱신이 된다. 조회조건 영역을 접으면 이 Form 이 언마운트되므로 공급자는 페이지여야 한다.
  // Company 기본값 — AS-IS 는 DataSource 바인딩이 index 0 을 자동 선택한다(CC:362-365).
  //   ALL 옵션이 없으므로 빈값 상태를 두지 않는다.
  //   금지: useRef 1회 가드. F10(조회조건 초기화)은 페이지를 리마운트하지 않고 store.reset() 만
  //   부르므로(useGloablStore.resetSearchCondition), ref 를 쓰면 companyId 가 ''로 돌아온 뒤
  //   영영 다시 채워지지 않아 조회가 "Select Company." 로 영구 차단된다. 조건은 "비어 있으면 채운다"
  //   하나면 충분하다 — 사용자가 고른 값이 있으면 조건이 거짓이라 덮어쓰지 않고, 지우기 아이콘도
  //   꺼 두었으므로 사용자가 스스로 빈값을 만들 수 없다.
  useEffect(() => {
    if (companyOptions.length === 0 || sc.companyId) return;
    setSearchCondition({ companyId: companyOptions[0].value });
  }, [companyOptions, sc.companyId, setSearchCondition]);

  // Day of the week 기본값 — AS-IS 도 index 0(=EveryDay, DISPLAY_SEQ 10) 자동 선택이라
  //   무선택 상태가 구조적으로 존재하지 않는다(02 §3.2). 목록에 없으면 첫 옵션으로 보정한다.
  const dayWeekDefaultedRef = useRef(false);
  useEffect(() => {
    if (dayWeekDefaultedRef.current || dayWeekOptions.length === 0) return;
    dayWeekDefaultedRef.current = true;
    const exists = dayWeekOptions.some(o => o.value === sc.dayWeekCode);
    if (!exists) {
      const fallback =
        dayWeekOptions.find(o => o.value === DEFAULT_DAY_WEEK)?.value ?? dayWeekOptions[0].value;
      setSearchCondition({ dayWeekCode: fallback, inputValue: '' });
    }
  }, [dayWeekOptions, sc.dayWeekCode, setSearchCondition]);

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* F1 Company — ALL 옵션 금지(AS-IS 에 ALL 행이 없다. 주면 전 회사 조회가 새로 생긴다). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.COMPANY, '_Company')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  // AS-IS cboCompany 는 DropDownList + DataSource 바인딩이라 빈 선택이 구조적으로
                  //   존재하지 않는다(index 0 자동선택). 지우기 아이콘을 열어 두면 AS-IS 에 없던
                  //   빈값 상태가 생기고, 빈 companyId 는 SP 에서 회사 필터가 통째로 사라진다.
                  useClearIcon={false}
                  value={sc.companyId}
                  options={companyOptions}
                  onChange={(_, picked) => setSearchCondition({ companyId: str(picked) })}
                />
              )}
            />
          </Grid>
          {/* F2 Div. — 멀티 선택 + ALL. AS-IS clbDivision 은 UsrCheckedList(다중 체크)다
              (setListBox(dtMyDivision, clbDivision, true) + ClearUsrCheckedList(UsrCheckedList control),
              cs:148/164 실측). setFilters 가 'ALL'=권한코드 콤마 전개 / 그 외=선택코드 콤마 그대로 SP
              P_DIVISION_ID(콤마 IN)로 보낸다. 종전 "단일(ItemSelectionMode=One)" 표기는 SSP0014
              clbTransMode 와 같은 오독이라 정정한다(사용자 지시 2026-09-30). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Div')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  multiple
                  allOption
                  limitTags={1}
                  value={sc.divisionId}
                  options={divisionOptions}
                  onChange={(_, picked) =>
                    // 전체 해제(빈 선택)는 ALL 로 되돌린다 — 빈 divisionId 는 SP 필터를 통째로 없앤다.
                    //   Division 변경 시 그리드는 유지한다(사용자 지시 2026-10-06 — hook #5 그리드 비움
                    //   규범 미적용. 재조회는 Search 로만).
                    setSearchCondition({ divisionId: str(picked) || ALL })
                  }
                />
              )}
            />
          </Grid>
          {/* F3 Period* — 기본값은 PKG_COM0000.P_SCM0001_GET_SCP_PERIOD 가 준다(dayjs 근사 금지).
              PeriodField 는 required 를 내장하고 값 형식이 YYYYMMDD 라 payload 와 같은 축이다. */}
          <PeriodField
            gridSize={3}
            label={t(LBL.PERIOD, '_Period')}
            start={sc.fromYyyymmdd}
            end={sc.toYyyymmdd}
            onChange={(start, end) => setSearchCondition({ fromYyyymmdd: start, toYyyymmdd: end })}
          />
          {/* 줄바꿈 스페이서 — 조회조건이 4개가 안 돼도 Day of the week 이하(요일 → Input Value →
              Input 버튼)를 한 행(2행)에 묶어 가독성을 준다. 요일에 설정한 값을 Input Value 로 일괄
              입력하는 흐름이라 세 컨트롤이 인접해야 한다(사용자 지시 2026-09-30). */}
          <Grid size={3} />
          {/* F4 Day of the week — 조회 파라미터가 아니라 btnInput 일괄입력 대상 선택자다. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DAY_OF_WEEK, '_Day of the week')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  useClearIcon={false}
                  value={sc.dayWeekCode}
                  options={dayWeekOptions}
                  onChange={(_, picked) =>
                    // Day of the week 변경 시 Input Value 는 유지한다(사용자 지시 2026-10-06).
                    //   AS-IS(cs:669)는 매번 cboInputValue 를 리셋했으나 사용자 요청으로 미리셋.
                    setSearchCondition({ dayWeekCode: str(picked) || DEFAULT_DAY_WEEK })
                  }
                />
              )}
            />
          </Grid>
          {/* F5 Input Value — 초기값 빈값 + 상시 enabled. AS-IS 의 disable 분기는 요일이 빈값이
              될 수 없어 도달하지 않는다(02 §3.2 실측). 01 R04 의 "처음부터 disabled" 는 오기다. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.INPUT_VALUE, '_Input Value')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  disabled={disabled}
                  value={sc.inputValue}
                  options={inputValueOptions}
                  onChange={(_, picked) => setSearchCondition({ inputValue: str(picked) })}
                />
              )}
            />
          </Grid>
          {/* F6 Input — AS-IS 는 조회영역 안 2행 3열의 버튼이다(Designer Location(504,25) —
              2행 2열 cboInputValue(257,25) 의 바로 옆 칸). SubTitle 11버튼 세트에 없는 동작이라
              툴바로 올리지 않고, SearchArea.extraButtons(조회 버튼 옆)로도 두지 않는다 —
              그 배치는 05_runtime-parity.md L3 에 기록된 드리프트였고 사용자 지시로 AS-IS 로 되돌렸다.
              라벨 없는 단독 컨트롤이라 FormItem 을 쓰지 않는다(자매 shipment-request-semi F8 과 동형). */}
          <Grid size={3} className={commonStyles.customGrid}>
            <Button
              appearance='outlined'
              priority='normal'
              disabled={disabled || !canEdit}
              onClick={onInput}
            >
              {t(LBL.INPUT_BUTTON, '_Input')}
            </Button>
          </Grid>
        </>
      }
    />
  );
};
