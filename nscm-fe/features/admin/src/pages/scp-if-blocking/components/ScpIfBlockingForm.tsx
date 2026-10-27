import { PeriodField } from 'features/master/src/components';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { LBL } from '../scp-if-blocking.constants';
import { useScpIfBlockingStore } from '../useScpIfBlockingStore';

export interface DivisionOption {
  label: string;
  value: string;
}

interface Props {
  onSearch: () => void; // 조회(GET) — SubTitle SEARCH 와 동일 핸들러
  disabled: boolean; // R1 — Division 무권한(콤보 0건) 시 조회영역 전체 disable (design 01 §2 R1)
  divisionOptions: DivisionOption[];
}

const ALL = 'ALL';

// AS-IS usrConditionPanel1 조회영역(design 01 §1·02 §5) — Division(다중 체크, 비필수, EE 포함) +
//   Period(From~To, 필수 `*`). cascade 없음(events=0) → 개별 Field, extraConditions 불요(2칸, SRCH-02 미해당).
export const ScpIfBlockingForm = ({ onSearch, disabled, divisionOptions }: Props) => {
  const { t } = useTranslation();

  const search = useScpIfBlockingStore(s => s.search);
  const setSearch = useScpIfBlockingStore(s => s.setSearch);
  const isOpenSearchArea = useScpIfBlockingStore(s => s.isOpenSearchArea);

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      onSearch={onSearch}
      isHidden={!isOpenSearchArea}
      conditions={
        <>
          {/* Division (다중 체크, 비필수 — AS-IS layoutControlItem4.Text="Division" 별표 없음). EE 포함.
              All 선택 = 전체 선택/해제 토글. 미선택(빈 배열) = 서버 권한 Division 전건 조회. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Division')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  disabled={disabled}
                  value={search.divisionIds.join(',')}
                  options={divisionOptions}
                  onChange={(_, picked) => {
                    const tokens = String(picked ?? '')
                      .split(',')
                      .filter(Boolean);
                    if (tokens.includes(ALL)) {
                      const all = divisionOptions.map(o => o.value);
                      const isAllSelected =
                        all.length > 0 && search.divisionIds.length === all.length;
                      setSearch({ divisionIds: isAllSelected ? [] : all });
                      return;
                    }
                    setSearch({ divisionIds: tokens.filter(v => v !== ALL) });
                  }}
                />
              )}
            />
          </Grid>

          {/* Period* (필수 — AS-IS layoutControlItem6.Text="Period*"). From~To YYYYMMDD. 공백 시 조회 차단(R6).
              공용 PeriodField(features/master SearchFields) — 표준 레이아웃·높이정합(36px) 내장. DMF0003 등 선례.
              PeriodField 가 자체 <Grid> 를 포함하므로 바깥 Grid 로 감싸지 않는다. */}
          <PeriodField
            gridSize={4}
            label={t(LBL.PERIOD, '_Period')}
            start={search.fromYyyymmdd}
            end={search.toYyyymmdd}
            disabled={disabled}
            onChange={(from, to) => setSearch({ fromYyyymmdd: from, toYyyymmdd: to })}
          />
        </>
      }
    />
  );
};
