import { ItemByDivisionModal, PeriodField } from 'features/master/src/components';
import { useState } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import {
  BUCKET_OPTIONS,
  FIXED_DIVISION,
  LBL,
} from '../capa-report-small.constants';
import { useCapaReportSmallStore } from '../useCapaReportSmallStore';

import styles from './CapaReportSmallForm.module.scss';

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
 * 영역2 조회조건 (design 02 §5). Division 고정 '40'(비활성). 7 필드 → 2단(6) 초과분(Nick Name)은
 * extraConditions 분리(hook #52). Category/Day Type 은 조회조건이 아니라 그리드 일괄입력 UI(페이지 배치).
 */
export const CapaReportSmallForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useCapaReportSmallStore(s => s.searchParams);
  const setSearchParams = useCapaReportSmallStore(s => s.setSearchParams);
  const openSearchArea = useCapaReportSmallStore(s => s.openSearchArea);

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
            {/* Period — 필수(AS-IS DataUtil.checkRequiredOfSearch). */}
            <PeriodField
              gridSize={3}
              start={sc.startYyyymmdd}
              end={sc.endYyyymmdd}
              onChange={(start, end) => setSearchParams({ startYyyymmdd: start, endYyyymmdd: end })}
              label={t(LBL.PERIOD, 'Period')}
            />
            {/* Bucket — 클라 정적 3옵션, 기본 DAILY. 변경 시 그리드 pivot 재구성. */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.BUCKET, 'Bucket')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    value={sc.bucketType}
                    options={BUCKET_OPTIONS.map(o => ({ label: o.label, value: o.value }))}
                    onChange={(_, picked) => setSearchParams({ bucketType: str(picked) })}
                  />
                )}
              />
            </Grid>
            {/* Material — 텍스트 + Item 팝업(ItemByDivisionModal, division 40). */}
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.MATERIAL, 'Material')}
                labelAlign='right'
                render={() => (
                  <div className={styles.itemField}>
                    <InputField
                      fullWidth
                      value={sc.itemId}
                      onChange={event => setSearchParams({ itemId: event.target.value })}
                      onKeyDown={event => event.key === 'Enter' && onSearch()}
                    />
                    <Button
                      className={styles.itemPopupButton}
                      appearance='outlined'
                      priority='normal'
                      size='small'
                      buttonLabel='...'
                      onClick={() => setOpenItem(true)}
                    />
                  </div>
                )}
              />
            </Grid>
          </>
        }
        extraConditions={
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.NICK_NAME, 'Nick Name')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sc.nickName}
                  onChange={event => setSearchParams({ nickName: event.target.value })}
                  onKeyDown={event => event.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>
        }
      />

      {/* Material Item 팝업 — AS-IS SCM0002_ItembyDivisionPopup. division 40 + plantSite 전달. */}
      <ItemByDivisionModal
        open={openItem}
        modalClose={() => setOpenItem(false)}
        setSelectedValue={(itemId: string) => {
          if (itemId) setSearchParams({ itemId });
          setOpenItem(false);
        }}
        preSearchParams={{ divisionId: FIXED_DIVISION, itemId: sc.itemId }}
        callFromCell={false}
      />
    </>
  );
};
