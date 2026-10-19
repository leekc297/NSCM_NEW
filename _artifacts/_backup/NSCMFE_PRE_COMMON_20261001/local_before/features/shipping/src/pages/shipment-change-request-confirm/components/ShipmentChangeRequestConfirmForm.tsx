import { PeriodField } from 'features/master/src/components';

import type { ComboParam, ComboResponse, LookupResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { ALL, COMBO, LOOKUP } from '../shipment-change-request-confirm.constants';
import { useShipmentChangeRequestConfirmStore } from '../useShipmentChangeRequestConfirmStore';

interface Props {
  onSearch: () => void;
  onRequestorSearch: () => void;
  onItemSearch: () => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: (ComboResponse | LookupResponse)[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// design 02 (02_search-combo.md) 조회조건 7건 — 2단(6) 초과라 extraConditions 접기(hook #52/#83):
//   메인(6): Division(40고정 disabled) / From Site(다중+ALL) / Status(ALL선두,기본 Q) / Change Type(ALL선두,기본 ALL)
//            / Requestor(입력+SsoUser 팝업) / Item(입력+ItemByDivision 팝업)
//   확장(1): Period(D-14 기본)
export const ShipmentChangeRequestConfirmForm = ({ onSearch, onRequestorSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useShipmentChangeRequestConfirmStore(s => s.searchCondition);
  const set = useShipmentChangeRequestConfirmStore(s => s.setSearchCondition);
  const setPeriod = useShipmentChangeRequestConfirmStore(s => s.setPeriod);
  const openSearchArea = useShipmentChangeRequestConfirmStore(s => s.openSearchArea);

  // From Site = FromSiteByDivisionOspPack @divisionId(='40'). Division 40 고정이라 param 변경 없으나 규약상 실음.
  const fromSiteFilter: ComboParam = { comboId: COMBO.FROM_SITE, divisionId: sc.divisionId };
  const [fromSites] = useTabComboQueries({ filters: [fromSiteFilter] });
  const [changeStatus] = useTabLookupQueries({ filters: [{ lookupType: LOOKUP.CHANGE_REQ_STATUS }] });
  const [changeTypes] = useTabLookupQueries({ filters: [{ lookupType: LOOKUP.CHANGE_REQ_TYPE }] });

  const fromSiteOptions = toOptions(fromSites);
  const statusOptions = toOptions(changeStatus);
  const changeTypeOptions = toOptions(changeTypes);
  // Division 은 '40' 고정 단일값 — 콤보 조회 없이 상수 옵션만.
  const divisionOptions: Option[] = [{ label: sc.divisionId, value: sc.divisionId }];

  return (
    <SearchArea
      searchButtonLabel={t('LBL00664', { defaultValue: 'Search' })}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division — C1 '40' 고정 + disabled(콤보 조회 없음, 상수). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00641', { defaultValue: 'Division' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown value={sc.divisionId} options={divisionOptions} disabled />
              )}
            />
          </Grid>

          {/* From Site (다중 + ALL) — FromSiteByDivisionOspPack(divisionId='40'). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00022', { defaultValue: 'From Site' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  value={sc.fromSiteIds.join(',')}
                  options={fromSiteOptions}
                  onChange={(_, picked) =>
                    set({
                      fromSiteIds: String(picked ?? '')
                        .split(',')
                        .filter(v => v && v !== ALL),
                    })
                  }
                />
              )}
            />
          </Grid>

          {/* Status — CHANGE_REQ_STATUS, ALL 선두, 기본 Q(Requested). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00014', { defaultValue: 'Status' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  value={sc.status}
                  options={statusOptions}
                  onChange={(_, picked) => set({ status: String(picked ?? ALL) })}
                />
              )}
            />
          </Grid>

          {/* Change Type — CHANGE_REQ_TYPE(P/C/N/A), ALL 선두, 기본 ALL. 'P'=컬럼분기 트리거. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL01061', { defaultValue: 'Change Type' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  value={sc.changeType}
                  options={changeTypeOptions}
                  onChange={(_, picked) => set({ changeType: String(picked ?? ALL) })}
                />
              )}
            />
          </Grid>

          {/* Requestor — 입력 + 돋보기(SsoUserModal, 단일선택), 다건(개행/콤마). design 02 §4.6. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL01108', { defaultValue: 'Requestor' })}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.requestId}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={
                          <FunctionSearchIcon appearance='lined' onClick={onRequestorSearch} />
                        }
                      />
                    ),
                  }}
                  onChange={e => set({ requestId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* Item — 입력 + 돋보기(ItemByDivisionModal, division='40'/scmSite=fromSite), 다건. design 02 §4.6. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL01142', { defaultValue: 'Item' })}
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
      extraConditions={
        // Period — 기본 D-14(from=오늘-14, to=오늘). SCM0001_GET_SCP_DAY_PERIOD offset -14.
        <PeriodField
          gridSize={3}
          start={sc.fromYyyymmdd}
          end={sc.toYyyymmdd}
          onChange={(start, end) => setPeriod(start, end)}
        />
      }
    />
  );
};
