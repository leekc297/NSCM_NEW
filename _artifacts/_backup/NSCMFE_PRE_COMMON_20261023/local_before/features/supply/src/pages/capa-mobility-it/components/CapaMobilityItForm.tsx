import { ItemByDivisionModal } from 'features/master/src/components';
import { useState } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, PeriodRangePicker, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { FIXED_DIVISION, LBL } from '../capa-mobility-it.constants';
import { useCapaMobilityItStore } from '../useCapaMobilityItStore';

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

  // Plant Site / Line — division 40 고정 재조회(design 02 §2). Line 은 AS-IS 가 init 1회만 로드(S1 NO-OP).
  const [plantSites, lines] = useTabComboQueries({
    filters: [
      { comboId: 'PlantByDivisionOperation', divisionId: FIXED_DIVISION },
      { comboId: 'LineByOperation', divisionId: FIXED_DIVISION },
    ],
  });

  const plantOptions = toOptions(plantSites);
  const lineOptions = toOptions(lines);

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
            {/* Division — 고정 '40' 비활성(AS-IS cs L182~183). */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.DIVISION, 'Division')}
                labelAlign='right'
                required
                render={() => <InputField fullWidth readOnly disabled value={FIXED_DIVISION} />}
              />
            </Grid>
            {/* Plant Site — PlantByDivisionOperation 다중. */}
            {multi(t(LBL.PLANT_SITE, 'Plant Site'), sc.plantIds, plantOptions, codes =>
              // PlantSite→Line 재조회는 AS-IS NO-OP(S1) — Line 후보를 재조회하지 않는다.
              setSearchParams({ plantIds: codes })
            )}
            {/* Line — LineByOperation 다중('-'→ 빈값 저장 시 치환). */}
            {multi(t(LBL.LINE, 'Line'), sc.lineIds, lineOptions, codes =>
              setSearchParams({ lineIds: codes })
            )}
            {/* Model/Nickname — 텍스트 + btnItemId(ItemByDivisionModal) 팝업. 확정값은 itemId 로만 전송한다. */}
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
            {/* Material — Item 팝업 트리거(POP-12: endAdornment 검색아이콘 + 더블클릭). */}
            <Grid size={3}>
              <PeriodRangePicker
                start={sc.startYyyymmdd}
                end={sc.endYyyymmdd}
                onChange={(start, end) => setSearchParams({ startYyyymmdd: start, endYyyymmdd: end })}
                label={t(LBL.PERIOD, 'Period')}
                required
                className={commonStyles.formItem}
              />
            </Grid>
          </>
        }
      />

      {/* btnItemId → DM0002_ItembyDivisionPopup(COM0008). AS-IS btnItemId_Click(cs:3391). 확정값은 itemId 로만 반영한다. */}
      <ItemByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={items => {
          if (items) setSearchParams({ itemId: items });
          setOpenItem(false);
        }}
        preSearchParams={{ divisionId: FIXED_DIVISION, itemId: sc.itemId }}
        callFromCell={false}
      />
    </>
  );
};
