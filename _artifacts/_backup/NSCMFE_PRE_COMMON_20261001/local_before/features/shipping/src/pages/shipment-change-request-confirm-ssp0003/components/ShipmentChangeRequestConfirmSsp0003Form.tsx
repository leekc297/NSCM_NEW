import { PeriodField } from 'features/master/src/components';

import type { ComboParam, ComboResponse, LookupResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import {
  ALL,
  COMBO,
  EXCLUDE_DIVISION,
  LOOKUP,
} from '../shipment-change-request-confirm-ssp0003.constants';
import { useShipmentChangeRequestConfirmSsp0003Store } from '../useShipmentChangeRequestConfirmSsp0003Store';

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

// design 02 §5(02_search-combo.md) 조회조건 7건 — 6필드 초과라 extraConditions 접기(hook #52/#83):
//   메인(5): Division(다중+ALL, EE제외) / From Site(다중+ALL, division cascade) / Request Date(Period, D-14 기본)
//            / Status(ALL선두,기본 Q) / Change Type(ALL선두,기본 ALL)
//   확장(2): Model(입력+ItemByDivision 팝업) / Requestor(입력+SsoUser 팝업)
//   주의: gap-resolve iter-1 에서 design 02 §5 정합화 — Request Date 는 D-14 기본값을 갖는 1차 조건이라
//     메인 노출, 보조 팝업 입력(Model/Requestor)을 접힘으로(직전 배치는 반대였음, runtime-parity B-1 해소).
export const ShipmentChangeRequestConfirmSsp0003Form = ({
  onSearch,
  onRequestorSearch,
  onItemSearch,
}: Props) => {
  const { t } = useTranslation();

  const sc = useShipmentChangeRequestConfirmSsp0003Store(s => s.searchCondition);
  const set = useShipmentChangeRequestConfirmSsp0003Store(s => s.setSearchCondition);
  const setPeriod = useShipmentChangeRequestConfirmSsp0003Store(s => s.setPeriod);
  const openSearchArea = useShipmentChangeRequestConfirmSsp0003Store(s => s.openSearchArea);

  // Division = MyDivisionInEE_SCP (권한범위 EE 포함) -> FE 클라 EE 제거(design 02 §2.1).
  const [divisions] = useTabComboQueries({ filters: [COMBO.DIVISION] });
  // From Site = PlantSiteByDivision_SCP @divisionId(=선택 division 콤마조인). Division 변경 시 키 변경 -> 자동 재조회(design 02 §3).
  const fromSiteFilter: ComboParam = {
    comboId: COMBO.FROM_SITE,
    divisionId: sc.divisionIds.join(','),
  };
  const [fromSites] = useTabComboQueries({ filters: [fromSiteFilter] });
  const [changeStatus] = useTabLookupQueries({ filters: [{ lookupType: LOOKUP.CHANGE_REQ_STATUS }] });
  const [changeTypes] = useTabLookupQueries({ filters: [{ lookupType: LOOKUP.CHANGE_REQ_TYPE }] });

  // Division: AS-IS 클라 필터 CODE!=='EE' 재현(design 02 §2.1). 안 하면 AS-IS 보다 넓어짐.
  const divisionOptions = toOptions(divisions).filter(o => o.value !== EXCLUDE_DIVISION);
  // PlantSiteByDivision_SCP 는 선두 더미행('-')을 반환(ora.py 실측) — ALL 과 별개로 노출되므로 제외(design 02 §6).
  const fromSiteOptions = toOptions(fromSites).filter(o => o.value !== '-');
  const statusOptions = toOptions(changeStatus);
  const changeTypeOptions = toOptions(changeTypes);

  return (
    <SearchArea
      searchButtonLabel={t('LBL00664', { defaultValue: 'Search' })}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division (다중 + ALL) — MyDivisionInEE_SCP + 클라 EE 제거. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00641', { defaultValue: 'Division' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  value={sc.divisionIds.join(',')}
                  options={divisionOptions}
                  onChange={(_, picked) =>
                    set({
                      divisionIds: String(picked ?? '')
                        .split(',')
                        .filter(v => v && v !== ALL),
                    })
                  }
                />
              )}
            />
          </Grid>

          {/* From Site (다중 + ALL) — PlantSiteByDivision_SCP(divisionIds cascade). */}
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

          {/* Request Date (Period) — 기본 D-14(from=오늘-14, to=오늘). SCM0001_GET_SCP_DAY_PERIOD offset -14.
              1차 조건이므로 메인 노출(design 02 §5). */}
          <PeriodField
            gridSize={3}
            start={sc.fromYyyymmdd}
            end={sc.toYyyymmdd}
            onChange={(start, end) => setPeriod(start, end)}
          />

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

        </>
      }
      extraConditions={
        <>
          {/* Model — 입력 + 돋보기(ItemByDivisionModal, division/scmSite cascade), 다건. design 02 §4.6/§5. */}
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

          {/* Requestor — 입력 + 돋보기(SsoUserModal, 단일선택), 다건(개행/콤마). design 02 §4.6/§5. */}
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
        </>
      }
    />
  );
};
