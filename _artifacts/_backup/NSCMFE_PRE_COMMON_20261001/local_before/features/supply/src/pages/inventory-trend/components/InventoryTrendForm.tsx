import { useEffect } from 'react';

import dayjs from '@foundation/dayjs';
import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, DatePickerCalendar, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { COMBO, EE_ATTRIBUTE, MSG } from '../inventory-trend.constants';
import { useInventoryTrendStore } from '../useInventoryTrendStore';

interface Props {
  onSearch: () => void;
  // btnItem_Id → ItemByDivisionModal(page 소유). AS-IS BtnItem_Id_Click(cs:970~989).
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

  // Division=ALL 이면 Plant 콤보에 빈값 전달 → @divisionId IS NULL → 전체(design 02 §2-2).
  const divisionParam = sc.divisionId === 'ALL' ? '' : sc.divisionId;

  const [divisions, plants] = useTabComboQueries({
    filters: [COMBO.DIVISION, { comboId: COMBO.PLANT, divisionId: divisionParam }],
  });

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

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Month — monthPicker(기본=최신월). 헤더 relabel 기준(focus 월). AS-IS SCP0084 월범위 미배포 폴백 */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00066', '_Month')}
              labelAlign='right'
              render={() => (
                <DatePickerCalendar
                  usecase='month'
                  size='small'
                  elevation
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

          {/* Division — 다중선택, 권한필터 SQL 내장(Division_SCP) + EE 클라 제외. 값 전체=ALL */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00641', '_Division')}
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
              label={t('LBL00030', '_Plant')}
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

          {/* Material(Item ID) — 텍스트 + 팝업버튼(ItemByDivisionModal). 빈 반환 시 기존값 유지. AS-IS 캡션 'Material' */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00021', '_Material')}
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
                        iconComponent={
                          <FunctionSearchIcon appearance='lined' onClick={onItemSearch} />
                        }
                      />
                    ),
                  }}
                  onChange={e => set({ itemId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
