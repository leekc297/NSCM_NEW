import { PeriodField } from 'features/master/src/components';
import { useMemo } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown } from '@shared/components';
import { useTabLookupQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid, Stack } from '@shared/mui';

import { ALL, LBL, LOOKUP, RESULT_TYPE_BY_SHEET } from '../shipment-plan-mobility-it.constants';
import { useShipmentPlanMobilityItStore } from '../useShipmentPlanMobilityItStore';
import { fieldSetOf, INITIAL_FIELDSET } from '../utils/shipment-plan-mobility-it.detailSheets';

import styles from './ShipmentPsiDetailBar.module.scss';

interface Props {
  onDetailSearch: () => void; // btnSearch — 활성 detail sheet 재조회
  onModelSearch: () => void; // btnItemID2 — 2차 Model 팝업
  onRequestorSearch: () => void; // btnRequestor — UserInfoPopup
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: { CODE?: unknown; NAME?: unknown }[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// 2차 조회조건 (usrLayoutControl3 — design 02 §4.2): 활성 detail sheet 별 필드셋 전환.
export const ShipmentPsiDetailBar = ({ onDetailSearch, onModelSearch, onRequestorSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useShipmentPlanMobilityItStore(s => s.searchCondition);
  const set = useShipmentPlanMobilityItStore(s => s.setSearchCondition);
  const activeDetailSheet = useShipmentPlanMobilityItStore(s => s.activeDetailSheet);
  const mainSheet = useShipmentPlanMobilityItStore(s => s.mainSheet);

  const fieldSet = fieldSetOf(activeDetailSheet, INITIAL_FIELDSET);

  // Result Type — lookup(SSP_SHIPMENT_RESULT_TYPE) + 시트별 클라 행제거(design 02 §2.6).
  const [resultTypes] = useTabLookupQueries({ filters: [LOOKUP.SHIPMENT_RESULT_TYPE] });
  const resultTypeOptions = useMemo(() => {
    const allowed = new Set<string>(
      mainSheet === 'packer' ? RESULT_TYPE_BY_SHEET.PACKER : RESULT_TYPE_BY_SHEET.MAIN
    );
    return toOptions(resultTypes).filter(o => allowed.has(o.value));
  }, [resultTypes, mainSheet]);

  return (
    <Stack direction='row' alignItems='center' className={styles.detailBar}>
      <Grid container columns={12} className={styles.detailBarFields}>
        {fieldSet.period2 && (
          <PeriodField
            gridSize={3}
            label={t(LBL.SHIPMENT_DATE, '_Shipment Date')}
            start={sc.period2From}
            end={sc.period2To}
            onChange={(start, end) => set({ period2From: start, period2To: end })}
          />
        )}
        {fieldSet.period3 && (
          <PeriodField
            gridSize={3}
            label={t(LBL.SHIPMENT_DATE, '_Shipment Date')}
            start={sc.period3From}
            end={sc.period3To}
            onChange={(start, end) => set({ period3From: start, period3To: end })}
          />
        )}
        {fieldSet.model && (
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL, '_Model')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.model}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={<FunctionSearchIcon appearance='lined' onClick={onModelSearch} />}
                      />
                    ),
                  }}
                  onChange={e => set({ model: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onDetailSearch()}
                />
              )}
            />
          </Grid>
        )}
        {fieldSet.lotId && (
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.LOT_ID, '_Lot ID')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sc.lotId}
                  onChange={e => set({ lotId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onDetailSearch()}
                />
              )}
            />
          </Grid>
        )}
        {fieldSet.requestor && (
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.REQUESTOR, '_Requestor')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.requestorName || sc.requestorId}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={<FunctionSearchIcon appearance='lined' onClick={onRequestorSearch} />}
                      />
                    ),
                  }}
                  onChange={e => set({ requestorId: e.target.value, requestorName: '' })}
                  onKeyDown={e => e.key === 'Enter' && onDetailSearch()}
                />
              )}
            />
          </Grid>
        )}
        {fieldSet.resultType && (
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.RESULT_TYPE, '_Result Type')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  value={sc.resultTypes.join(',')}
                  options={resultTypeOptions}
                  onChange={(_, picked) =>
                    set({ resultTypes: str(picked).split(',').filter(v => v && v !== ALL) })
                  }
                />
              )}
            />
          </Grid>
        )}
      </Grid>

      <Stack direction='row' className={styles.detailBarButtons}>
        <Button appearance='contained' priority='primary' onClick={onDetailSearch}>
          {t(LBL.SEARCH_GRID, '_Search')}
        </Button>
      </Stack>
    </Stack>
  );
};
