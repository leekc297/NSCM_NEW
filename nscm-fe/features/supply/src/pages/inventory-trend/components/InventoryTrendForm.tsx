import { useEffect, useMemo, useRef } from 'react';

import dayjs from '@foundation/dayjs';
import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, DatePickerCalendar, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import {
  COMBO,
  EE_ATTRIBUTE,
  LBL,
  MONTH_MIN_YEAR,
  MSG,
} from '../inventory-trend.constants';
import { useInventoryTrendStore } from '../useInventoryTrendStore';

interface Props {
  onSearch: () => void;
  // btnItem_Id → MaterialByDivisionModal(메1, COM0013, page 소유). AS-IS BtnItem_Id_Click(cs:970~989).
  onItemSearch: () => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): { label: string; value: string }[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// YYYYMM → Dayjs (ISO 문자열 조립 — customParseFormat 플러그인 비의존, ending-inventory 선례).
const ymToDayjs = (ym: string): ReturnType<typeof dayjs> | null =>
  /^\d{6}$/.test(ym) ? dayjs(`${ym.slice(0, 4)}-${ym.slice(4, 6)}-01`) : null;

export const InventoryTrendForm = ({ onSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore(state => state.setAlert);

  const sc = useInventoryTrendStore(state => state.searchParams);
  const set = useInventoryTrendStore(state => state.setSearchParams);
  const openSearchArea = useInventoryTrendStore(state => state.isOpenSearchArea);
  const setNoDivisionAuth = useInventoryTrendStore(state => state.setNoDivisionAuth);
  const setAuthDivisions = useInventoryTrendStore(state => state.setAuthDivisions);

  // Division=ALL 이면 Plant 콤보에 빈값 전달 → @divisionId IS NULL → 전체(design 02 §2-2).
  const divisionParam = sc.divisionId === 'ALL' ? '' : sc.divisionId;

  const [divisions, plants, monthRangeRaw] = useTabComboQueries({
    filters: [COMBO.DIVISION, { comboId: COMBO.PLANT, divisionId: divisionParam }, COMBO.MONTH_RANGE],
  });

  // Month 범위·기본값 — COMBO.MONTH_RANGE 단일 행(MIN_YYYYMM/MAX_YYYYMM, AS-IS GetMonthRange/SetMonthRange
  //   cs:150~151, p_month=12). 연 경계(minYear/maxYear)는 picker prop 으로, 월 경계는 아래 DOM 비활성화
  //   effect + onChange 클램프로 건다(MonthPicker 가 월 단위 비활성 prop 미노출). 형제 long-term-stock 동일 처방.
  const monthRange = useMemo(() => {
    const row = ((monthRangeRaw ?? []) as Array<Record<string, unknown>>)[0];
    const min = str(row?.MIN_YYYYMM);
    const max = str(row?.MAX_YYYYMM);
    const yearOf = (ym: string): number | undefined =>
      /^\d{6}$/.test(ym) ? Number(ym.slice(0, 4)) : undefined;
    return {
      minYear: yearOf(min),
      maxYear: yearOf(max),
      minMonth: /^\d{6}$/.test(min) ? min : undefined,
      maxMonth: /^\d{6}$/.test(max) ? max : undefined,
    };
  }, [monthRangeRaw]);

  // 기본값 = 최신월(MAX_YYYYMM) — AS-IS InitValue=MAX(cs:645). 범위 최초 도착 시 1회 적용(사용자 변경 전 초기화).
  const appliedMaxMonthRef = useRef(false);
  useEffect(() => {
    if (appliedMaxMonthRef.current || !monthRange.maxMonth) return;
    appliedMaxMonthRef.current = true;
    set({ month: monthRange.maxMonth });
  }, [monthRange.maxMonth, set]);

  // 범위밖 월 '선택 불가' — 디자인시스템 MonthPicker 는 연 단위(minYear/maxYear)만 비활성화하고 월 그리드엔
  //   min/max 를 안 넘겨, 경계 연의 범위밖 월이 클릭된다. 노출 prop 이 없어 팝오버 월 버튼을 DOM 으로
  //   비활성화한다(portal + 연 이동 재렌더라 MutationObserver 로 재적용). onChange 클램프는 안전망으로 유지.
  useEffect(() => {
    const { minMonth, maxMonth } = monthRange;
    if (!minMonth && !maxMonth) return;
    const lo = minMonth ? Number(minMonth) : -Infinity; // YYYYMM 숫자 비교
    const hi = maxMonth ? Number(maxMonth) : Infinity;

    const applyDisable = () => {
      const buttons = Array.from(
        document.querySelectorAll<HTMLButtonElement>('.MuiPickersMonth-monthButton')
      );
      if (buttons.length === 0) return;
      // 표시 연도 — 팝오버 텍스트의 유일한 4자리(헤더 'YYYY년'/'YYYY'). 월 라벨('N월')은 4자리 아님.
      const paper = buttons[0].closest('[class*="MuiPaper-root"]') ?? document.body;
      const year = Number((paper.textContent ?? '').match(/\d{4}/)?.[0]);
      if (!Number.isInteger(year)) return;
      // MUI MonthCalendar 는 1월..12월 순서 렌더 → index + 1 = 월(locale 무관).
      buttons.forEach((btn, i) => {
        const ym = year * 100 + (i + 1);
        const out = ym < lo || ym > hi;
        btn.disabled = out;
        btn.style.opacity = out ? '0.3' : '';
        btn.style.pointerEvents = out ? 'none' : '';
      });
    };

    const observer = new MutationObserver(applyDisable);
    observer.observe(document.body, { childList: true, subtree: true });
    applyDisable();
    return () => observer.disconnect();
  }, [monthRange]);

  // EE(전극) 사업부 제외 — AS-IS BLUtils.GetDivisionWithoutEE 의 "ATTRIBUTE3 <> 'EE'" 클라 재현
  //   (design 02 §2-1). Division_SCP 는 ATTRIBUTE3 를 반환하므로 여기서 걸러 후보 범위를 AS-IS 와 일치시킨다.
  //   MyDivision 재사용 금지(SCP0006 silent drift, convert-core §2.6).
  const divisionOptions = toOptions(
    (divisions ?? []).filter(r => str(r.ATTRIBUTE3) !== EE_ATTRIBUTE)
  );

  // Division 권한 게이트(R1, cs:153~154) — 권한 Division 0건이면 조회영역 disable + 권한없음 안내.
  //   메시지 = MSG00667('No authority assigned.', AS-IS MSG00097 의도 매칭 TO-BE 코드, Hook #114).
  const noDivisionAuth = divisions !== undefined && divisionOptions.length === 0;
  useEffect(() => {
    if (noDivisionAuth) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRE_DIVISION, 'No authority assigned.') });
    }
  }, [noDivisionAuth, setAlert, t]);
  // 조회영역 입력 disable(아래 render)뿐 아니라 조회 액션(SubTitle search)도 함께 막도록 store 로 승계.
  useEffect(() => {
    setNoDivisionAuth(noDivisionAuth);
  }, [noDivisionAuth, setNoDivisionAuth]);

  // 권한 Division 코드를 스토어에 동기화 — setFilters 가 'ALL' 을 이 코드 열거로 펼쳐 조회한다
  //   (권한 밖 division 누수 차단, useInventoryTrendStore setFilters 주석 참조).
  const authDivisionKey = divisionOptions.map(o => o.value).join(',');
  useEffect(() => {
    setAuthDivisions(authDivisionKey ? authDivisionKey.split(',') : []);
  }, [authDivisionKey, setAuthDivisions]);

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Month — monthPicker(기본=최신월). 헤더 relabel 기준(focus 월). AS-IS SCP0084 월범위 미배포 폴백 */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MONTH, '_Month')}
              labelAlign='right'
              render={() => (
                <DatePickerCalendar
                  usecase='month'
                  size='small'
                  elevation
                  minYear={monthRange.minYear ?? MONTH_MIN_YEAR}
                  maxYear={monthRange.maxYear}
                  value={ymToDayjs(sc.month)}
                  disabled={noDivisionAuth}
                  onChange={
                    ((date: ReturnType<typeof dayjs>) => {
                      const ym = date?.format('YYYYMM') ?? '';
                      // MonthPicker 는 연 경계만 지원 → 경계 연의 범위밖 월이 선택 가능. MIN/MAX_YYYYMM 로
                      //   월 단위 클램프(YYYYMM 문자열 비교 = 시간순). 범위 밖이면 경계월로 보정.
                      const clamped =
                        ym && monthRange.minMonth && ym < monthRange.minMonth
                          ? monthRange.minMonth
                          : ym && monthRange.maxMonth && ym > monthRange.maxMonth
                            ? monthRange.maxMonth
                            : ym;
                      set({ month: clamped });
                    }) as never
                  }
                />
              )}
            />
          </Grid>

          {/* Division — 다중선택, 권한필터 SQL 내장(Division_SCP) + EE 클라 제외. 값 전체=ALL */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Div')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  value={sc.divisionId}
                  options={divisionOptions}
                  disabled={noDivisionAuth}
                  onChange={(_, option) => set({ divisionId: option })}
                />
              )}
            />
          </Grid>

          {/* Plant — 다중선택, Division cascade(재조회형, @divisionId). 값 전체=ALL */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PLANT, '_Plant')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  value={sc.plantId}
                  options={toOptions(plants)}
                  disabled={noDivisionAuth}
                  onChange={(_, option) => set({ plantId: option })}
                />
              )}
            />
          </Grid>

          {/* Material(Item ID) — 텍스트 + 팝업버튼(메1 MaterialByDivisionModal, COM0013). 빈 반환 시 기존값 유지. AS-IS 캡션 'Material' */}
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
                  disabled={noDivisionAuth}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        disabled={noDivisionAuth}
                        iconComponent={<FunctionSearchIcon appearance='lined' />}
                        onClick={onItemSearch}
                      />
                    ),
                  }}
                  onChange={e => set({ itemId: e.target.value })}
                />
              )}
            />
          </Grid>

        </>
      }
    />
  );
};
