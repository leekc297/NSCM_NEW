import { MaterialByDivisionModal } from 'features/master/src/components';
import { useEffect, useRef, useState } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, PeriodRangePicker, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { COMBO, FIXED_DIVISION, LBL, MENU_ID, PERIOD_OFFSET_DAY } from '../capa-mobility-it.constants';
import { useCapaMobilityItStore } from '../useCapaMobilityItStore';

/** AS-IS GetDayRange 월경계 보정 — 시작=월1일, 종료=월말일(2월은 28 고정, AS-IS .cs:3110~3135 파리티). */
const snapRangeToMonth = (from: string, to: string): { start: string; end: string } => {
  const start = `${from.slice(0, 6)}01`;
  const mm = to.slice(4, 6);
  const day = ['01', '03', '05', '07', '08', '10', '12'].includes(mm)
    ? '31'
    : mm === '02'
      ? '28'
      : '30';
  return { start, end: `${to.slice(0, 6)}${day}` };
};

interface Props {
  onSearch: () => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? [])
    .filter(r => str(r.CODE) !== '-') // '-' 미선택 sentinel 은 옵션에서 제외
    .map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

/**
 * 조회조건 (SCP0098 To-Be 문서 순서): Division, Plant Site, Line, Model/Nickname, Period.
 * 5개라 extraConditions 없이 1행 4개(size 3) + 2행 Period 로 배치된다.
 * Category/Day Type 은 조회조건이 아니라 그리드 일괄입력 UI(페이지 배치).
 */
export const CapaMobilityItForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useCapaMobilityItStore(s => s.searchParams);
  const setSearchParams = useCapaMobilityItStore(s => s.setSearchParams);
  const openSearchArea = useCapaMobilityItStore(s => s.openSearchArea);

  const [openItem, setOpenItem] = useState(false);

  // Division(고정·비활성) / Plant Site / Line — division 40 고정 재조회(design 02 §2).
  //   Division 은 Division_SCP 권한필터본(@mnuId)로 '40' 표시명을 띄우되 사용자 변경 불가.
  //   Line 은 AS-IS 가 init 1회만 로드(PlantSite→Line cascade NO-OP, S1).
  const [divisions, plantSites, lines] = useTabComboQueries({
    filters: [
      { comboId: COMBO.DIVISION, mnuId: MENU_ID },
      { comboId: COMBO.PLANT_SITE, divisionId: FIXED_DIVISION },
      { comboId: COMBO.LINE, divisionId: FIXED_DIVISION },
    ],
  });

  // Period 초기범위 산출 — AS-IS GetDayRange(W52): p_from_date='' (GetCheckedListValue(dt,'')='' → SP 가
  //   @timeZone 기준 오늘로 default), p_offset_day=363 → SP 가 'from:to'(YYYYMMDD) 반환. dayjs 근사 아님.
  const [dayPeriod] = useTabComboQueries({
    filters: [
      { comboId: COMBO.DAY_PERIOD, mnuId: MENU_ID, fromDate: '', offsetDay: PERIOD_OFFSET_DAY, timeZone: '' },
    ],
  });

  // SP 산출 범위를 초기 Period 로 1회 반영(월경계 보정). fromDate 고정이라 콤보는 1회 로드 → 1회 적용.
  //   이후 사용자 수동 지정은 덮지 않는다(ref 가드). AS-IS Form_Load dCalendar.InitValue = GetDayRange(W52) 등가.
  //   날짜는 F6 개인화 복원 제외라 이 값이 초기 기준(design 02 §2-5 / R5).
  const periodInitRef = useRef(false);
  useEffect(() => {
    if (periodInitRef.current) return;
    const [from, to] = str(dayPeriod?.[0]?.CODE).split(':');
    if (!from || !to) return;
    periodInitRef.current = true;
    const { start, end } = snapRangeToMonth(from, to);
    setSearchParams({ startYyyymmdd: start, endYyyymmdd: end });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [dayPeriod]);

  const divisionOptions = toOptions(divisions);
  const plantOptions = toOptions(plantSites);
  // Plant Site → Line cascade (사용자 지시 2026-11-04 — AS-IS S1 "PlantSite→Line NO-OP" 에서 의도적 deviation).
  //   LineByOperation 이 각 행에 SCM_SITE_ID 를 담아 내리고(SELECT B.SCM_SITE_ID) Plant Site 콤보 값이 곧
  //   SCM_SITE_ID 라, 재조회·SP·콤보 변경 없이 로드된 라인을 선택 Plant 로 클라에서 좁힌다(미선택=전체).
  const lineRowsInScope = (lines ?? []).filter(
    r => sc.plantIds.length === 0 || sc.plantIds.includes(r.SCM_SITE_ID)
  );
  const lineOptions = toOptions(lineRowsInScope);

  const multi = (
    labelText: string,
    value: string[],
    options: Option[],
    onPick: (codes: string[]) => void
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={labelText}
        labelAlign='right'
        render={() => (
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            limitTags={1}
            sortBy='label'
            value={value.length ? value.join(',') : 'ALL'}
            options={options}
            onChange={(_, picked) =>
              onPick(
                str(picked)
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
    <>
      <SearchArea
        searchButtonLabel={t(LBL.SEARCH, 'Search')}
        isHidden={!openSearchArea}
        onSearch={onSearch}
        conditions={
          <>
            {/* Division — Division_SCP 콤보, '40' 고정·비활성(AS-IS cs L182~183). 값 변경 불가. */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.DIVISION, 'Division')}
                labelAlign='right'
                required
                render={() => (
                  <CustomDropdown
                    disabled
                    value={FIXED_DIVISION}
                    options={divisionOptions}
                    onChange={() => undefined}
                  />
                )}
              />
            </Grid>
            {/* Plant Site — PlantByDivisionOperation 다중. Plant 변경 시 Line 선택 리셋(cascade 범위 밖 라인 제거). */}
            {multi(t(LBL.PLANT_SITE, 'Plant Site'), sc.plantIds, plantOptions, codes =>
              setSearchParams({ plantIds: codes, lineIds: [] })
            )}
            {/* Line — LineByOperation 다중('-'→ 빈값 저장 시 치환). */}
            {multi(t(LBL.LINE, 'Line'), sc.lineIds, lineOptions, codes =>
              setSearchParams({ lineIds: codes })
            )}
            {/* Model/Nickname — 텍스트 + btnItemId(MaterialByDivisionModal) 팝업. 확정값은 itemId 로만 전송한다.
                AS-IS 는 ItemByDivisionModal(COM0008)이나 사용자 지시(2026-11-11)로 MaterialByDivisionModal
                (COM0013)로 교체 — 감사가 "AS-IS=Item 팝업"으로 되돌리지 말 것. */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.MODEL_NICKNAME, 'Model/Nickname')}
                labelAlign='right'
                render={() => (
                  <InputField
                    fullWidth
                    className={commonStyles.popupSearchField}
                    value={sc.itemId}
                    InputProps={{
                      endAdornment: (
                        <Button
                          appearance='outlined'
                          priority='normal'
                          iconComponent={<FunctionSearchIcon appearance='lined' />}
                          onClick={() => setOpenItem(true)}
                        />
                      ),
                    }}
                    onChange={event => setSearchParams({ itemId: event.target.value })}
                    onKeyDown={event => event.key === 'Enter' && onSearch()}
                  />
                )}
              />
            </Grid>
            {/* Period — 월 단위 피커(monthOnly). 표기 YYYY-MM, 확정값은 월경계(시작월 1일~종료월 말일)로
                정규화되어 start/end = YYYYMMDD(8자리) 계약 유지. GET SP(PKG_SCP0098.P_GET_CAPA_MOBILITYIT)는
                from/to 를 SUBSTR(...,1,6)=YYYYMM 으로만 쓰므로(일 자리 무시) SP·PROC_M 변경 없이 월 조회 등가. */}
            <Grid size={3}>
              <PeriodRangePicker
                start={sc.startYyyymmdd}
                end={sc.endYyyymmdd}
                onChange={(start, end) => setSearchParams({ startYyyymmdd: start, endYyyymmdd: end })}
                label={t(LBL.PERIOD, 'Period')}
                required
                monthOnly
                className={commonStyles.formItem}
              />
            </Grid>
          </>
        }
      />

      {/* btnItemId → MaterialByDivisionModal(COM0013). AS-IS btnItemId_Click(cs:3391)은 ItemByDivisionModal
          (COM0008)이나 사용자 지시(2026-11-11)로 교체. 확정값은 itemId(ITEM_ID) 로만 반영한다 — SP
          P_GET_CAPA_MOBILITYIT 의 P_ITEM_ID 계약 유지. Division 은 고정 '40'(scpModuleType=MENU_ID 로 SP 분기). */}
      <MaterialByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={items => {
          if (items) setSearchParams({ itemId: items });
          setOpenItem(false);
        }}
        preSearchParams={{ divisionId: FIXED_DIVISION, scpModuleType: MENU_ID, itemId: sc.itemId }}
      />
    </>
  );
};
