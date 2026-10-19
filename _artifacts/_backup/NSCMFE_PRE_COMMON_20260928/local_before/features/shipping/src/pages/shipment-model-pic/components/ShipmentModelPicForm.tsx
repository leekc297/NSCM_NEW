import type { ComboParam, ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import {
  COMBO,
  LOOKUP,
  OPERATION_GROUP_WARRANTY_CODE,
  OPERATION_GROUP_WARRANTY_NAME,
} from '../shipment-model-pic.constants';
import { useShipmentModelPicStore } from '../useShipmentModelPicStore';

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

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// design 02 (02_search-combo.md) 조회조건 2행 6조건:
//   Row1 Division*(단일,필수,EE 제외) / Operation Group(단일+ALL, P/A/E + 클라 W) / From Site(다중+ALL) / Valid(단일+ALL)
//   Row2 Model(입력+SCM0002 팝업, 다건) / User ID(Name)(LIKE 텍스트)
export const ShipmentModelPicForm = ({ onSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useShipmentModelPicStore(s => s.searchCondition);
  const set = useShipmentModelPicStore(s => s.setSearchCondition);
  const openSearchArea = useShipmentModelPicStore(s => s.openSearchArea);

  // From Site = PlantSiteByDivision @divisionId. 선택 division 을 넘겨 서버 cascade(design 02 §3
  //   재조회 방식). division 변경 시 param 이 바뀌어 자동 재조회. 값 raw, 인용은 getCombo funnel.
  const fromSiteFilter: ComboParam = { comboId: COMBO.FROM_SITE, divisionId: sc.divisionId };

  const [divisions, fromSites, validYnRows] = useTabComboQueries({
    filters: [COMBO.DIVISION, fromSiteFilter, COMBO.VALID],
  });
  // Operation Group = LookupCommon lookupType='OPERATION_GROUP'(P/A/E). W 는 lookup 에 없어 클라 추가.
  const [operationGroupData] = useTabLookupQueries({
    filters: [{ lookupType: LOOKUP.OPERATION_GROUP }],
  });

  // AS-IS MyDivisionCMM 등가 — MyDivision 콤보(권한 division). EE 제외는 CMBO WHERE 에 이미 있으나
  //   combo-semantic-parity(convert-core §2.6) 상 화면에서도 ATTRIBUTE3!=='EE' 재현(방어적).
  const divisionOptions = toOptions((divisions ?? []).filter(r => str(r.ATTRIBUTE3) !== 'EE'));
  const fromSiteOptions = toOptions(fromSites);
  const validOptions = toOptions(validYnRows);
  // P/A/E(lookup NAME) + 클라 W=Warranty (design 02 §2.2 — 코드/표시 그리드와 일치).
  const operationGroupOptions: Option[] = [
    ...(operationGroupData ?? []).map(r => ({ label: str(r.NAME), value: str(r.CODE) })),
    { label: OPERATION_GROUP_WARRANTY_NAME, value: OPERATION_GROUP_WARRANTY_CODE },
  ];

  return (
    <SearchArea
      searchButtonLabel={t('LBL00664', { defaultValue: 'Search' })}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division* (필수, 기본포커스 — design 02 §2.1). 변경 시 From Site cascade 초기화(§3). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00641', { defaultValue: 'Division' })}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={sc.divisionId}
                  options={divisionOptions}
                  onChange={(_, picked) =>
                    set({ divisionId: String(picked ?? ''), fromSiteIds: [] })
                  }
                />
              )}
            />
          </Grid>

          {/* Operation Group (단일 + ALL) — P/A/E + 클라 W. AS-IS OperationGroup cascade 는 주석처리(부활 금지). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00027', { defaultValue: 'Operation group' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  value={sc.operationGroup}
                  options={operationGroupOptions}
                  onChange={(_, picked) => set({ operationGroup: String(picked ?? 'ALL') })}
                />
              )}
            />
          </Grid>

          {/* From Site (다중 + ALL) — division 하위 PLANT (서버 @divisionId cascade). */}
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
                        .filter(v => v && v !== 'ALL'),
                    })
                  }
                />
              )}
            />
          </Grid>

          {/* Valid (단일 + ALL) — YesOrNo. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00639', { defaultValue: 'Valid' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  value={sc.validYn}
                  options={validOptions}
                  onChange={(_, picked) => set({ validYn: String(picked ?? 'ALL') })}
                />
              )}
            />
          </Grid>

          {/* Model — 입력 + 돋보기(SCM0002 ItemByDivisionModal), 다건(콤마). design 02 §4.6. */}
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

          {/* User ID(Name) — LIKE 텍스트(GET SP 6필드 OR, design 02 §2.5). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00339', { defaultValue: 'User ID(Name)' })}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sc.userId}
                  onChange={e => set({ userId: e.target.value })}
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
