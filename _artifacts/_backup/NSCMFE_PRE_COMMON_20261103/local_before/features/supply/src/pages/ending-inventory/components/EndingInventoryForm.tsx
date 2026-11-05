import { useEffect } from 'react';

import dayjs from '@foundation/dayjs';
import type { ComboResponse, LookupResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
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
  LOOKUP,
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

const toOptions = (
  rows: ComboResponse[] | LookupResponse[] | undefined
): { label: string; value: string }[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// YYYYMM/YYYYMMDD → Dayjs (ISO 문자열 조립 — customParseFormat 플러그인 비의존, demand-manager 선례).
const ymToDayjs = (ym: string): ReturnType<typeof dayjs> | null =>
  /^\d{6}$/.test(ym) ? dayjs(`${ym.slice(0, 4)}-${ym.slice(4, 6)}-01`) : null;
const ymdToDayjs = (ymd: string): ReturnType<typeof dayjs> | null =>
  /^\d{8}$/.test(ymd) ? dayjs(`${ymd.slice(0, 4)}-${ymd.slice(4, 6)}-${ymd.slice(6, 8)}`) : null;

export const EndingInventoryForm = ({ onSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore(state => state.setAlert);

  // 조회모드 2옵션(AS-IS RdoMonth/RdoDate) — LBL01137/LBL01138 다국어.
  const MODE_OPTIONS = [
    { label: t(LBL.MONTHLY_BASIS, '월마감 기준'), value: SEARCH_MODE.MONTH },
    { label: t(LBL.DAILY_BASIS, '일별 기준'), value: SEARCH_MODE.DAILY },
  ];

  const sc = useEndingInventoryStore(state => state.searchParams);
  const set = useEndingInventoryStore(state => state.setSearchParams);
  const openSearchArea = useEndingInventoryStore(state => state.isOpenSearchArea);
  const setNoDivisionAuth = useEndingInventoryStore(state => state.setNoDivisionAuth);

  // ALL(전체)=빈값 전달 → 콤보 SQL '@x IS NULL'(Oracle 에서 '' IS NULL=TRUE) → 무필터(design 02 §2.1-(2)).
  const divisionParam = sc.divisionId === 'ALL' ? '' : sc.divisionId;
  const plantParam = sc.plantId === 'ALL' ? '' : sc.plantId;
  // Profit Center 콤보 = AS-IS SCP0085_GET_SEARCH_INFO 이관 — 선택 기간 + Division/Plant 로 스코프(AS-IS 완전 동일).
  //   AS-IS SP 는 @P_YYYYMMDD 만 받고 DIVISION_ID/PLANT_ID 를 함께 내려 C# 클라가 선택 Division/Plant 로 걸렀다.
  //   TO-BE 는 그 필터를 CMBO_SQL @divisionId/@plantId(콤마 다중 INSTR)로 서버측 재현(design 02 §8(2)).
  //   @yyyymmdd 길이로 월/일 테이블 분기(6=_R.YYYYMM, 8=_R_D.CUTOFF_DATE). 기간·Division·Plant 변경 시 재조회.
  const periodParam = sc.mode === SEARCH_MODE.DAILY ? sc.date : sc.month;

  const [divisions, plants, profitCenters] = useTabComboQueries({
    filters: [
      COMBO.DIVISION,
      { comboId: COMBO.PLANT, divisionId: divisionParam },
      {
        comboId: COMBO.PROFIT_CENTER,
        yyyymmdd: periodParam,
        divisionId: divisionParam,
        plantId: plantParam,
      },
    ],
  });

  // Item Type — 옵션집합·표시명 모두 DB LOOKUP 'ITEM_TYPE'에서 가져온다(사용자 결정 2026-10-21).
  //   품목데이터 DISTINCT(ITEM_MASTER_ITEM_TYPE)는 실재 코드(H/P/Q/R·'-')만이라 '기타'·'저장품' 등 미사용
  //   코드가 빠지므로, LOOKUP 정의 7종 전체(기타/반제품/상품/원부자재/저장품/제품/(Blanks))를 쓴다.
  //   LOOKUP 이 CODE(코드)/NAME(한글)을 그대로 내려줘 변환 불필요. 전송값(value)은 CODE 그대로(p_item_type).
  const [itemTypeLookup] = useTabLookupQueries({ filters: [{ lookupType: LOOKUP.ITEM_TYPE }] });
  const itemTypeOptions = toOptions(itemTypeLookup);

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
                        // Date 는 독립 컴포넌트 — month 와 값을 서로 참조하지 않는다(사용자 결정 2026-10-21,
                        //   AS-IS DatePicker_ValueChanged 의 month 동기화는 미이식). date 만 갱신.
                        set({ date: date?.format('YYYYMMDD') ?? '' });
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
                        // Month 는 독립 컴포넌트 — date 와 값을 서로 참조하지 않는다(사용자 결정 2026-10-21,
                        //   AS-IS MonthPicker_ValueChanged 의 date 동기화는 미이식). month 만 갱신.
                        set({ month: date?.format('YYYYMM') ?? '' });
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
                  options={itemTypeOptions}
                  disabled={noDivisionAuth}
                  onChange={(_, option) => set({ itemType: option })}
                />
              )}
            />
          </Grid>

          {/* Profit Center — 다중선택, 값 전체=ALL. AS-IS ATTRIBUTE3 필터(p_profit_center) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PROFIT_CENTER, '_Profit Center')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  value={sc.profitCenter}
                  options={toOptions(profitCenters)}
                  disabled={noDivisionAuth}
                  onChange={(_, option) => set({ profitCenter: option })}
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
                        iconComponent={<FunctionSearchIcon appearance='lined' />}
                        onClick={onItemSearch}
                      />
                    ),
                  }}
                  onChange={e => set({ itemId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* 좌측 라디오 칼럼(일별 아래) 비움 — Devaluation Age 를 Item Type 아래로 정렬하기 위한 스페이서(size 2) */}
          <Grid size={2} className={commonStyles.customGrid} />

          {/* 재고월령 컬럼 표시 토글 — AS-IS chkDetail("Devaluation Age"). Item Type(col2~) 아래 배치.
              FormItem 라벨을 공백(truthy)으로 둬 140px 라벨칼럼을 유지(빈 문자열 ''는 칼럼이 접혀
              체크박스가 라벨영역에 남음) → 체크박스를 Item Type 입력열(모든 입력의 좌측 경계)에 정렬 */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={' '}
              labelAlign='right'
              render={() => (
                <Checkbox
                  labelText={DEVALUATION_AGE_LABEL}
                  checked={sc.devaluationAge}
                  disabled={noDivisionAuth}
                  onChange={checked => set({ devaluationAge: checked })}
                />
              )}
            />
          </Grid>

          {/* ERP 집계 안내문 — Devaluation Age 오른쪽(같은 행). 모드별(월마감 MSG01371 / 일별 MSG01370).
              AS-IS 조회조건 우측 안내문(cs:541~545). */}
          <Grid size={7} className={commonStyles.customGrid}>
            <span>
              {isDaily
                ? t(
                    MSG.DAILY_ERP_NOTICE,
                    '_일별 기준 데이터는 매일 각 법인별 시업시간 기준 ERP(ZMMCMR6014) 재고를 가져옵니다.'
                  )
                : t(
                    MSG.MONTH_ERP_NOTICE,
                    '_월마감 기준 데이터는 매월 본사 4 영업일에 집계하며, ERP(ZMMCMR6014) 전월말 재고를 가져옵니다.'
                  )}
            </span>
          </Grid>
        </>
      }
    />
  );
};
