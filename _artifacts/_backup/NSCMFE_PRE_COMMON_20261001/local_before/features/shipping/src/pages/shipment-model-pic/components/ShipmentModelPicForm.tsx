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

  // AS-IS MyDivisionCMM 등가 — 콤보 SQL_ID 'MyDivision'(권한 division, EE 제외).
  //   AS-IS 별칭 "MyDivisionCMM" 의 실체는 BigFilter list_line_ssp 결과셋 25번 =
  //   `UP_FX_GetCommonDataList @Code='MyDivision'`(DataService.cs:5178, BigFilter.xml). 별칭명이
  //   달라 보이지만 실제 콤보 코드는 같다. AS-IS SP 원문(asis.py 실측 2026-09-28)의 WHERE 는
  //   `ATTRIBUTE3<>'EE' + 권한 division + VALID_YN='Y'` 로 TO-BE CMBO SQL 과 일치한다(design 02 §2.1).
  //   아래 ATTRIBUTE3 필터는 방어용 — CMBO SQL 이 CODE/NAME 만 반환해 실제로는 no-op 이다.
  //
  // 정렬: AS-IS 최종 순서는 CODE(=DIVISION_ID) 오름차순이다.
  //   SP 자체는 AS-IS·TO-BE 모두 `ORDER BY ATTRIBUTE1` 인데, AS-IS 는 그 뒤 C# 이
  //   `.OrderBy(row => row.Field<string>("CODE"))` 로 덮어쓴다(DataService.cs:5210).
  //   TO-BE 는 이 후처리가 없어 ATTRIBUTE1 순서가 노출된다 — 원인은 CMBO SQL 이 아니라 누락된 후처리다.
  //   (DB 실측: AS-IS 40,81,81_HD,81_HG,81_HM,81_ST,81_UC,82 vs CMBO 81,40,82,81_UC,...)
  //   영향 범위는 드롭다운 표시 순서다 — 기본 divisionId 는 세션 division(store: session.div)이고
  //   첫 항목 자동선택 effect 가 없어 기본 선택값은 바뀌지 않는다.
  //   MyDivision 은 타 화면(auth-approval·business-plan·cust-fcst-waterfall 등)이 공유하므로 공용 SQL 을
  //   고치지 않고 화면에서 재현한다(convert-core §2.6 ②). 자매 SSP0045 도 동일하게 화면 재정렬한다.
  const divisionOptions = toOptions((divisions ?? []).filter(r => str(r.ATTRIBUTE3) !== 'EE')).sort(
    (a, b) => a.value.localeCompare(b.value)
  );
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
