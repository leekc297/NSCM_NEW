import { useEffect } from 'react';

import dayjs from '@foundation/dayjs';
import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import {
  Button,
  Checkbox,
  DatePickerCalendar,
  FormItem,
  InputField,
  Radio,
} from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import {
  COMBO,
  DEVALUATION_AGE_LABEL,
  LBL,
  MONTH_MIN_YEAR,
  MSG,
  SEARCH_MODE,
} from '../ending-inventory.constants';
import { useEndingInventoryStore } from '../useEndingInventoryStore';

interface Props {
  onSearch: () => void;
  // btnItem_Id → MaterialByDivisionModal(page 소유). AS-IS BtnItem_Id_Click(cs:429).
  onItemSearch: () => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): { label: string; value: string }[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// YYYYMM/YYYYMMDD → Dayjs (ISO 문자열 조립 — customParseFormat 플러그인 비의존, demand-manager 선례).
const ymToDayjs = (ym: string): ReturnType<typeof dayjs> | null =>
  /^\d{6}$/.test(ym) ? dayjs(`${ym.slice(0, 4)}-${ym.slice(4, 6)}-01`) : null;
const ymdToDayjs = (ymd: string): ReturnType<typeof dayjs> | null =>
  /^\d{8}$/.test(ymd) ? dayjs(`${ymd.slice(0, 4)}-${ymd.slice(4, 6)}-${ymd.slice(6, 8)}`) : null;

export const EndingInventoryForm = ({ onSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore(state => state.setAlert);

  // 조회모드 2옵션(AS-IS RdoMonth/RdoDate). 라벨은 다국어 없이 하드코딩한다.
  const MODE_OPTIONS = [
    { label: '월마감 기준', value: SEARCH_MODE.MONTH },
    { label: '일별 기준', value: SEARCH_MODE.DAILY },
  ];

  const sc = useEndingInventoryStore(state => state.searchParams);
  const set = useEndingInventoryStore(state => state.setSearchParams);
  const openSearchArea = useEndingInventoryStore(state => state.isOpenSearchArea);
  const setNoDivisionAuth = useEndingInventoryStore(state => state.setNoDivisionAuth);

  // Division=ALL 이면 Plant 콤보에 빈값 전달 → @divisionId IS NULL → 전체(design 02 §2.1-(2)).
  const divisionParam = sc.divisionId === 'ALL' ? '' : sc.divisionId;

  const [divisions, plants, itemTypes] = useTabComboQueries({
    filters: [
      COMBO.DIVISION,
      { comboId: COMBO.PLANT, divisionId: divisionParam },
      COMBO.ITEM_TYPE,
    ],
  });

  // Division 권한 게이트(R1, 01_layout §2) — MyDivision 결과 0건이면 조회영역 disable + MSG00097.
  const divisionOptions = toOptions(divisions);
  const noDivisionAuth = divisions !== undefined && divisionOptions.length === 0;
  useEffect(() => {
    if (noDivisionAuth) {
      void setAlert({ type: 'alert', content: t(MSG.REQUIRE_DIVISION, 'Please select Division.') });
    }
  }, [noDivisionAuth, setAlert, t]);
  // 조회영역 입력 disable(아래 render)뿐 아니라 조회 액션(SubTitle search)도 함께 막도록 store 로 승계.
  //   page 가 이 값으로 hotkeyConfig.search 를 차단한다(R1 usrLayoutControl2 전체 Enabled=false 대응).
  useEffect(() => {
    setNoDivisionAuth(noDivisionAuth);
  }, [noDivisionAuth, setNoDivisionAuth]);

  const isDaily = sc.mode === SEARCH_MODE.DAILY;

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* 조회모드 라디오 1행 — AS-IS RdoMonth. 라디오마다 Grid 한 칸씩 배정해 행을 나눈다 */}
          <Grid size={2} className={commonStyles.customGrid}>
            <Radio
              name='ending-inventory-mode'
              value={MODE_OPTIONS[0].value}
              labelText={MODE_OPTIONS[0].label}
              checked={sc.mode === MODE_OPTIONS[0].value}
              disabled={noDivisionAuth}
              onChange={() => set({ mode: MODE_OPTIONS[0].value })}
            />
          </Grid>

          {/* 기간 — MONTH 모드=monthPicker / DAILY 모드=datePicker(조건부 렌더, 01_layout R2/R3) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={isDaily ? t(LBL.DATE, '_Date') : t(LBL.MONTH, '_Month')}
              labelAlign='right'
              render={() =>
                isDaily ? (
                  <DatePickerCalendar
                    usecase='date'
                    size='small'
                    elevation
                    value={ymdToDayjs(sc.date)}
                    disabled={noDivisionAuth}
                    onChange={
                      ((date: ReturnType<typeof dayjs> | null) => {
                        // datePicker 변경 → month 동기화(AS-IS DatePicker_ValueChanged, cs:511~515:
                        //   monthPicker.Text = date.Substring(0,4)). AS-IS 는 연(YYYY)만 동기화한다.
                        const ymd = date?.format('YYYYMMDD') ?? '';
                        set({ date: ymd, month: ymd.slice(0, 4) });
                      }) as never
                    }
                  />
                ) : (
                  <DatePickerCalendar
                    usecase='month'
                    size='small'
                    elevation
                    minYear={MONTH_MIN_YEAR}
                    value={ymToDayjs(sc.month)}
                    disabled={noDivisionAuth}
                    onChange={
                      ((date: ReturnType<typeof dayjs>) => {
                        // monthPicker 변경 → date 동기화(AS-IS MonthPicker_ValueChanged, cs:499~503:
                        //   datePicker.Text = month + "01").
                        const ym = date?.format('YYYYMM') ?? '';
                        set({ month: ym, date: ym ? `${ym}01` : '' });
                      }) as never
                    }
                  />
                )
              }
            />
          </Grid>

          {/* Division — 다중선택, EE 제외+권한필터 SQL 내장(MyDivision). 값 전체=ALL */}
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

          {/* 조회모드 라디오 2행 — AS-IS RdoDate */}
          <Grid size={2} className={commonStyles.customGrid}>
            <Radio
              name='ending-inventory-mode'
              value={MODE_OPTIONS[1].value}
              labelText={MODE_OPTIONS[1].label}
              checked={sc.mode === MODE_OPTIONS[1].value}
              disabled={noDivisionAuth}
              onChange={() => set({ mode: MODE_OPTIONS[1].value })}
            />
          </Grid>

          {/* Item Type — 다중선택, 값 전체=ALL */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.ITEM_TYPE, '_Item Type')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  value={sc.itemType}
                  options={toOptions(itemTypes)}
                  disabled={noDivisionAuth}
                  onChange={(_, option) => set({ itemType: option })}
                />
              )}
            />
          </Grid>

          {/* Material(Item ID) — 텍스트 + 팝업버튼(MaterialByDivisionModal). 빈 반환 시 기존값 유지 */}
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

          {/* 재고월령 컬럼 표시 토글 — AS-IS chkDetail("Devaluation Age") */}
          <Grid size={3} className={commonStyles.customGrid}>
            <Checkbox
              labelText={DEVALUATION_AGE_LABEL}
              checked={sc.devaluationAge}
              disabled={noDivisionAuth}
              onChange={checked => set({ devaluationAge: checked })}
            />
          </Grid>

          {/* 일별 ERP 안내문(MSG00378) — DAILY 모드만 노출(01_layout R2, cs:541~545). TO-BE MSG 미등록 fallback.
              FormItem 라벨 영역에 넣으면 좁은 폭에서 세로로 줄바꿈되므로 전체 폭 한 줄로 둔다. */}
          {/* {isDaily && (
            <Grid size={12}>
              <span>{t(MSG.DAILY_ERP_NOTICE, DAILY_ERP_NOTICE_FALLBACK)}</span>
            </Grid>
          )} */}
        </>
      }
    />
  );
};
