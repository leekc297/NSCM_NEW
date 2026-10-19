import type { ComboParam, ComboResponse, LookupResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { COMBO, LOOKUP, PLAN_DATE_COMBO_UNRESOLVED } from '../inventory-raw.constants';
import { useInventoryRawStore } from '../useInventoryRawStore';

interface Props {
  onSearch: () => void;
  onItemSearch: () => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | LookupResponse[] | undefined) =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// design 02 (02_search-combo.md) §1 조회조건 5항목:
//   Division(고정 "40"+disabled) / Plant Site(다중, Division EE 분기 SQL_ID 2종) /
//   Inventory Type(단일 lookup INV_TYPE) / Plan-date*(단일, SQL_ID 확인 필요) /
//   Model(=Item ID, 입력+팝업).
export const InventoryRawForm = ({ onSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useInventoryRawStore(s => s.searchParams);
  const set = useInventoryRawStore(s => s.setSearchParams);
  const isOpenSearchArea = useInventoryRawStore(s => s.isOpenSearchArea);

  // Plant Site: Division 값의 'EE' 포함 여부로 SQL_ID 2종 상호배타 스위칭(design 02 §3#1) —
  //   콤보 UI 슬롯은 1개지만 공급 SQL_ID 는 2개(convert-core §2.6, 단일값으로 뭉뚱그리지 않음).
  const plantSiteFilter: ComboParam = {
    comboId: sc.divisionId.includes('EE') ? COMBO.PLANT_SITE_EE : COMBO.PLANT_SITE_NON_EE,
    divisionId: sc.divisionId,
  };

  const [divisions, plantSites] = useTabComboQueries({
    filters: [COMBO.DIVISION, plantSiteFilter],
  });
  // Inventory Type = LookupCommon(LOOKUP_TYPE='INV_TYPE') — useTabLookupQueries 직접 조회
  //   (shipment-model-pic OPERATION_GROUP 선례와 동일, 콤보 브리지 원천과 동일 테이블).
  const [inventoryTypes] = useTabLookupQueries({ filters: [{ lookupType: LOOKUP.INVENTORY_TYPE }] });

  const divisionOptions = toOptions(divisions);
  const plantSiteOptions = toOptions(plantSites);
  const inventoryTypeOptions = toOptions(inventoryTypes);

  return (
    <SearchArea
      searchButtonLabel={t('LBL00664', { defaultValue: 'Search' })}
      onSearch={onSearch}
      isHidden={!isOpenSearchArea}
      conditions={
        <>
          {/* Division — clbDivision.ControlValues="40" 고정 + Enabled=false(design 02 §4). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00641', { defaultValue: 'Division' })}
              labelAlign='right'
              render={() => <CustomDropdown disabled value={sc.divisionId} options={divisionOptions} />}
            />
          </Grid>

          {/* Plant Site — 다중선택, Division cascade 재조회(design 02 §3#1). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00005', { defaultValue: 'Plant Site' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  limitTags={1}
                  sortBy='label'
                  value={sc.plantSiteIds.join(',')}
                  options={plantSiteOptions}
                  onChange={(_, picked) =>
                    set({
                      plantSiteIds: String(picked ?? '')
                        .split(',')
                        .filter(v => v && v !== 'ALL'),
                    })
                  }
                />
              )}
            />
          </Grid>

          {/* Inventory Type — 단일선택, 기본선택 없음(design 02 §4). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL01087', { defaultValue: 'Inventory Type' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  value={sc.inventoryType}
                  options={inventoryTypeOptions}
                  onChange={(_, picked) => set({ inventoryType: String(picked ?? 'ALL') })}
                />
              )}
            />
          </Grid>

          {/* Model(=Item ID) — 텍스트 + 팝업(ItemByDivisionModal, design 02 §4.6). */}
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
                        iconComponent={<FunctionSearchIcon appearance='lined' onClick={onItemSearch} />}
                      />
                    ),
                  }}
                  onChange={e => set({ itemId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* Plan-date* — 필수(design 02 §4). 확인 필요(FAIL 후보): PLAN_DATE_COMBO_UNRESOLVED
              (inventory-raw.constants.ts 참조) — AS-IS `PlanDateShip` 콤보의 TO-BE SQL_ID 미확정이라
              데이터 소스를 연결하지 못했다. 빈 목록 슬롯만 렌더(임의 SQL_ID 대체 금지). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00039', { defaultValue: 'Plan Date' })}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  disabled={PLAN_DATE_COMBO_UNRESOLVED}
                  value={sc.planStartYyyymmdd}
                  options={[]}
                  onChange={(_, picked) => set({ planStartYyyymmdd: String(picked ?? '') })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
