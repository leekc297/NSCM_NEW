import { useEffect, useMemo } from 'react';

import dayjs from '@foundation/dayjs';
import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { DatePickerCalendar, FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import {
  COMBO,
  DIVISION_EXCLUDE_ATTRIBUTE3,
  LBL,
  LONG_TERM_TYPE_OPTIONS,
  MENU_ID,
  MONTH_MIN_YEAR,
  MSG,
} from '../long-term-stock.constants';
import { useLongTermStockStore } from '../useLongTermStockStore';

interface Props {
  onSearch: () => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): { label: string; value: string }[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// YYYYMM → Dayjs (ISO 문자열 조립 — customParseFormat 플러그인 비의존, ending-inventory 선례).
const ymToDayjs = (ym: string): ReturnType<typeof dayjs> | null =>
  /^\d{6}$/.test(ym) ? dayjs(`${ym.slice(0, 4)}-${ym.slice(4, 6)}-01`) : null;

// 콤마 다중값 → 선택 코드 집합(ALL/빈값 = 전체). Division cascade 필터 판정용.
const toSelectedSet = (csv: string): Set<string> => {
  const codes = csv
    .split(',')
    .map(c => c.trim())
    .filter(c => c !== '' && c.toUpperCase() !== 'ALL');
  return new Set(codes);
};

export const LongTermStockForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore(state => state.setAlert);

  const sc = useLongTermStockStore(state => state.searchParams);
  const set = useLongTermStockStore(state => state.setSearchParams);
  const openSearchArea = useLongTermStockStore(state => state.isOpenSearchArea);
  const setNoDivisionAuth = useLongTermStockStore(state => state.setNoDivisionAuth);

  // Division = Division_SCP(권한필터 SQL 내장, @mnuId='SCP0084') / Plant = PlantByGroup1_SCP_ALL
  //   (권한무시 전체, 파라미터 없음). Plant 는 서버 재조회형이 아니라 전체를 1회 받아 클라 필터한다
  //   (design 02 §2-2/§3, convert-core §2.6).
  const [divisionsRaw, plantsAllRaw] = useTabComboQueries({
    filters: [{ comboId: COMBO.DIVISION, mnuId: MENU_ID }, COMBO.PLANT],
  });

  // Division 전극(EE) 제외 클라필터 — CMBO SQL 엔 없어 FE 재현(design 02 §2-1, convert-core §2.6).
  const divisionOptions = useMemo(
    () =>
      toOptions(
        (divisionsRaw ?? []).filter(
          r => str(r.ATTRIBUTE3) !== DIVISION_EXCLUDE_ATTRIBUTE3
        )
      ),
    [divisionsRaw]
  );

  // Plant 클라 cascade 필터 — 선택 division 의 DIVISION_ID 만 남긴다(재조회 없음). Division
  //   미선택(ALL) 이면 전체 노출(AS-IS 빈 IN → 전체 재현, design 02 §4 상위 미선택 정책).
  const plantOptions = useMemo(() => {
    const selected = toSelectedSet(sc.divisionId);
    const filtered = (plantsAllRaw ?? []).filter(r => {
      if (str(r.CODE).trim() === '') return false;
      if (selected.size === 0) return true;
      return selected.has(str(r.DIVISION_ID));
    });
    return toOptions(filtered);
  }, [plantsAllRaw, sc.divisionId]);

  // Division 권한 게이트(R8, cs:146~147) — Division_SCP 결과 0건이면 조회영역 disable + MSG00097.
  const noDivisionAuth = divisionsRaw !== undefined && divisionOptions.length === 0;
  useEffect(() => {
    if (noDivisionAuth) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRE_DIVISION, 'Please select Division.') });
    }
  }, [noDivisionAuth, setAlert, t]);
  // 조회영역 입력 disable(아래 render)뿐 아니라 조회 액션(SubTitle search)도 함께 막도록 store 승계.
  useEffect(() => {
    setNoDivisionAuth(noDivisionAuth);
  }, [noDivisionAuth, setNoDivisionAuth]);

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Month — monthPicker 단일. 기본 최신월, 하한 2021(SCP0084_GET_MONTH_RANGE 미배포 폴백) */}
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
                  minYear={MONTH_MIN_YEAR}
                  value={ymToDayjs(sc.month)}
                  disabled={noDivisionAuth}
                  onChange={
                    ((date: ReturnType<typeof dayjs>) => {
                      set({ month: date?.format('YYYYMM') ?? '' });
                    }) as never
                  }
                />
              )}
            />
          </Grid>

          {/* Division — 다중선택, EE 제외 클라필터. 값 전체=ALL. MyDivision 재사용 금지 */}
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

          {/* Plant — 다중선택, Division 클라 cascade 필터(재조회 없음). 값 전체=ALL */}
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
                  options={plantOptions}
                  disabled={noDivisionAuth}
                  onChange={(_, option) => set({ plantId: option })}
                />
              )}
            />
          </Grid>

          {/* Long Term Type — 다중선택, 정적 3옵션(CODE_2/5/6). 값 전체=ALL */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.LONG_TERM_TYPE, '_Long Term Type')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  value={sc.longTermTypeCode}
                  options={LONG_TERM_TYPE_OPTIONS.map(o => ({ label: o.name, value: o.code }))}
                  disabled={noDivisionAuth}
                  onChange={(_, option) => set({ longTermTypeCode: option })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
