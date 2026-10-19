import { PeriodField } from 'features/master/src/components';

import type { ComboParam, ComboResponse, LookupResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { ALL, COMBO, DEFAULT_PLAN_TYPE, LOOKUP } from '../shipment-change-request.constants';
import { useShipmentChangeRequestStore } from '../useShipmentChangeRequestStore';

interface Props {
  onSearch: () => void;
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

// design 02 (02_search-combo.md) 조회조건 9건 — 2단 초과라 3단째부터 extraConditions 접기(hook #52):
//   메인(6): Division*(40고정 disabled) / From Site(다중+ALL) / To Site(다중+ALL) / Plan Type(C기본) / Status(ALL선두,P제외) / Model(입력+SSP0026 팝업)
//   확장(3): Period(30일 기본) / ERP SO No(다건) / Confirm ID(다건)
export const ShipmentChangeRequestForm = ({ onSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useShipmentChangeRequestStore(s => s.searchCondition);
  const set = useShipmentChangeRequestStore(s => s.setSearchCondition);
  const setPeriod = useShipmentChangeRequestStore(s => s.setPeriod);
  const changePlanType = useShipmentChangeRequestStore(s => s.changePlanType);
  const openSearchArea = useShipmentChangeRequestStore(s => s.openSearchArea);

  // To Site = ShipmentPlanToSite_SCP @divisionId. From Site = CN-1 콤보(OSP팩 의미 확인필요).
  //   Division 40 고정이라 param 변경은 없으나 규약상 재조회형(콤보 payload 에 divisionId 실음).
  const fromSiteFilter: ComboParam = { comboId: COMBO.FROM_SITE, divisionId: sc.divisionId };
  const toSiteFilter: ComboParam = { comboId: COMBO.TO_SITE, divisionId: sc.divisionId };

  const [divisions, fromSites, toSites] = useTabComboQueries({
    filters: [COMBO.DIVISION, fromSiteFilter, toSiteFilter],
  });
  const [changeReqTypes] = useTabLookupQueries({ filters: [{ lookupType: LOOKUP.CHANGE_REQ_TYPE }] });
  const [shipmentStatus] = useTabLookupQueries({ filters: [{ lookupType: LOOKUP.SHIPMENT_STATUS }] });

  // Division: MyDivision(EE 제외 WHERE 내장) — combo-semantic-parity 상 화면에서도 EE 방어(§2.6).
  const divisionOptions = toOptions((divisions ?? []).filter(r => str(r.ATTRIBUTE3) !== 'EE'));
  const fromSiteOptions = toOptions(fromSites);
  const toSiteOptions = toOptions(toSites);
  // Plan Type: P/C/N/A (ALL 없음, 기본 C). Status: P(Plan) 제외 + ALL 선두(allOption), 기본 ALL.
  const changeTypeOptions = toOptions(changeReqTypes);
  const statusOptions = toOptions((shipmentStatus ?? []).filter(r => str(r.CODE) !== 'P'));

  return (
    <SearchArea
      searchButtonLabel={t('LBL00664', { defaultValue: 'Search' })}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division* — R3 '40' 고정 + disabled(콤보 표시하되 변경불가). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00641', { defaultValue: 'Division' })}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown value={sc.divisionId} options={divisionOptions} disabled />
              )}
            />
          </Grid>

          {/* From Site (다중 + ALL) — CN-1 콤보(OSP팩 의미 확인필요). */}
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

          {/* To Site (다중 + ALL) — ShipmentPlanToSite_SCP @divisionId. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00023', { defaultValue: 'To Site' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  value={sc.toSiteIds.join(',')}
                  options={toSiteOptions}
                  onChange={(_, picked) =>
                    set({
                      toSiteIds: String(picked ?? '')
                        .split(',')
                        .filter(v => v && v !== ALL),
                    })
                  }
                />
              )}
            />
          </Grid>

          {/* Plan Type — CHANGE_REQ_TYPE(P/C/N/A), ALL 없음, 기본 C. 변경 시 Period 재계산(페이지). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00040', { defaultValue: 'Plan Type' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={sc.changeType}
                  options={changeTypeOptions}
                  onChange={(_, picked) => changePlanType(String(picked ?? DEFAULT_PLAN_TYPE))}
                />
              )}
            />
          </Grid>

          {/* Status — SHIPMENT_STATUS, P(Plan) 제외 + ALL 선두, 기본 ALL. */}
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
                  onChange={(_, picked) => set({ status: String(picked ?? 'ALL') })}
                />
              )}
            />
          </Grid>

          {/* Model — 입력 + 돋보기(SSP0026 ItemByDivisionModal), 다건(개행/콤마). design 02 §4.6. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00669', { defaultValue: 'Model' })}
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
        <>
          {/* Period — 기본 30일(SCM0001_GET_SCP_DAY_PERIOD), Plan Type='P' 시 오늘+9D 재계산(페이지). */}
          <PeriodField
            gridSize={3}
            start={sc.fromYyyymmdd}
            end={sc.toYyyymmdd}
            onChange={(start, end) => setPeriod(start, end)}
          />

          {/* ERP SO No — 다건(개행) 텍스트. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL01111', { defaultValue: 'SO No' })}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  multiline
                  maxRows={3}
                  value={sc.erpSoNo}
                  onChange={e => set({ erpSoNo: e.target.value })}
                />
              )}
            />
          </Grid>

          {/* Confirm ID — 다건(개행) 텍스트. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL01063', { defaultValue: 'Confirm ID' })}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  multiline
                  maxRows={3}
                  value={sc.confirmId}
                  onChange={e => set({ confirmId: e.target.value })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
