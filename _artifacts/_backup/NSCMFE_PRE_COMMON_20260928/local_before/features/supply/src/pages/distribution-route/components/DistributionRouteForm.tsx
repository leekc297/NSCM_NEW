import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { COMBO, TRANS_MODE_LOOKUP_TYPE, VALID_OPTIONS } from '../distribution-route.constants';
import { useDistributionRouteStore } from '../useDistributionRouteStore';

interface Props {
  onSearch: () => void;
  onFromSearch: () => void;
  onToSearch: () => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

const ALL_OPTION: Option = { label: 'ALL', value: 'ALL' };

// design 02 (02_search-combo.md) 조회조건:
//   실 콤보 2 — Trans Mode(LookupCommon @lookupType='TRANSPORT_MODE_CODE', 단일 + ALL) / Valid(정적 Y/N).
//   From/To Country·City 4 = 텍스트 입력 + 도시검색 버튼(SCM0002 → RegionModal). cascade 없음(§3).
//   dead 콤보(Division/Site/BodType) 신설 금지(design 02 §2.4).
export const DistributionRouteForm = ({ onSearch, onFromSearch, onToSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useDistributionRouteStore(s => s.searchCondition);
  const set = useDistributionRouteStore(s => s.setSearchCondition);
  const openSearchArea = useDistributionRouteStore(s => s.openSearchArea);

  // Trans Mode 후보 — LookupCommon(@lookupType='TRANSPORT_MODE_CODE'). 값은 raw, 인용은 getCombo funnel.
  const [transModes] = useTabComboQueries({
    filters: [{ comboId: COMBO.TRANS_MODE, lookupType: TRANS_MODE_LOOKUP_TYPE }],
  });
  const transModeOptions: Option[] = [ALL_OPTION, ...toOptions(transModes)];

  return (
    <SearchArea
      searchButtonLabel={t('LBL00664', { defaultValue: 'Search' })}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* From Country / From City — 텍스트 입력 + 도시검색 (design 02 §2.3/§4.6, LBL00074/LBL00070) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00074', { defaultValue: 'From Country' })}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sc.fromCountry}
                  onChange={e => set({ fromCountry: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00070', { defaultValue: 'From City' })}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.fromCity}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={
                          <FunctionSearchIcon appearance='lined' onClick={onFromSearch} />
                        }
                      />
                    ),
                  }}
                  onChange={e => set({ fromCity: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* To Country / To City — 텍스트 입력 + 도시검색 (LBL00075/LBL00071) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00075', { defaultValue: 'To Country' })}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sc.toCountry}
                  onChange={e => set({ toCountry: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00071', { defaultValue: 'To City' })}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.toCity}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={
                          <FunctionSearchIcon appearance='lined' onClick={onToSearch} />
                        }
                      />
                    ),
                  }}
                  onChange={e => set({ toCity: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* Trans Mode — 단일 select + ALL (design 02 §2.1, SelectionMode.One / LBL00025) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00025', { defaultValue: 'Trans Mode' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={sc.transportMode}
                  options={transModeOptions}
                  onChange={(_, picked) => set({ transportMode: String(picked ?? 'ALL') })}
                />
              )}
            />
          </Grid>

          {/* Valid — 정적 ALL/Y/N (design 02 §2.2 / LBL00639) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00639', { defaultValue: 'Valid' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={sc.validYn}
                  options={VALID_OPTIONS}
                  onChange={(_, picked) => set({ validYn: String(picked ?? 'ALL') })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
