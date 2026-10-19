import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { COMBO, OPERATION_GROUP_LOOKUP, TACT_MODE } from '../tact-time.constants';
import { useTactTimeStore } from '../useTactTimeStore';

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

// design 02 (02_search-combo.md) 조회조건 combo:
//   cascade cboDivision -> clbPlantSite(다중) -> clbLine(다중), 모드(Plant/Packer) 공급 경로 분기(§3).
//   cboOperationGroup(lookup), cboValid(D-2 정적 숨김 — 렌더 안 함, 기본 'ALL' 파라미터만 유지),
//   btnItemId -> SCM0002 Item 검색 팝업, txtItemId 다건.
//   콤보 ID 는 확인 필요(design 02 §7 ERROR — DB 미실측). 잘못된 id 는 조용히 0행.
export const TactTimeForm = ({ onSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useTactTimeStore(s => s.searchCondition);
  const set = useTactTimeStore(s => s.setSearchCondition);
  const openSearchArea = useTactTimeStore(s => s.openSearchArea);

  const isPlant = sc.mode === TACT_MODE.PLANT;

  // 콤보 — 전량 조회 후 client-side cascade 필터(AS-IS CommonAll + DBUtils.Filter, design 02 §3).
  const [divisions, plantSites, lines] = useTabComboQueries({
    filters: [
      COMBO.DIVISION,
      isPlant ? COMBO.PLANT_SITE_PLANT : COMBO.PLANT_SITE_PACKER,
      isPlant ? COMBO.LINE_PLANT : COMBO.LINE_PACKER,
    ],
  });
  const [operationGroups] = useTabLookupQueries({ filters: [OPERATION_GROUP_LOOKUP] });

  const divisionOptions = toOptions(divisions);
  // clbPlantSite = division 하위 (DBUtils.Filter DIVISION_ID = division, design 02 §2.2)
  const plantSiteOptions = toOptions(
    (plantSites ?? []).filter(r => !sc.divisionId || str(r.DIVISION_ID) === sc.divisionId)
  );
  // clbLine = division + 선택 plantSite 하위 (design 02 §2.3)
  const lineOptions = toOptions(
    (lines ?? []).filter(
      r =>
        (!sc.divisionId || str(r.DIVISION_ID) === sc.divisionId) &&
        (sc.plantSiteIds.length === 0 || sc.plantSiteIds.includes(str(r.SCM_SITE_ID)))
    )
  );
  // AS-IS: Operation Group 은 P(Packer) default, ALL 옵션 없음 (cs:221 setListBox false). lookup 값(P/E/W)만.
  const operationGroupOptions: Option[] = (operationGroups ?? []).map(r => {
    const rec = r as Record<string, unknown>;
    return { label: str(rec.NAME) || str(rec.CODE), value: str(rec.CODE) };
  });

  const multi = (
    labelCode: string,
    labelEn: string,
    value: string[],
    options: Option[],
    onPick: (codes: string[]) => void,
    disabled?: boolean
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(labelCode, { defaultValue: labelEn })}
        labelAlign='right'
        render={() => (
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            limitTags={1}
            sortBy='label'
            disabled={disabled}
            value={value.join(',')}
            options={options}
            onChange={(_, picked) =>
              onPick(String(picked ?? '').split(',').filter(Boolean))
            }
          />
        )}
      />
    </Grid>
  );

  return (
    <SearchArea
      searchButtonLabel={t('LBL00664', { defaultValue: 'Search' })}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* AS-IS 는 Packer 탭만 사용 — View(Plant/Packer) 검색조건 없음(사용자 확인 2026-09-10). mode 는 Packer 고정. */}
          {/* Division* (cascade 최상위, 필수 — design 02 §2.1) */}
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
                    // division 변경 = 하위(plantSite/line) cascade 초기화 (design 02 §3)
                    set({ divisionId: String(picked ?? ''), plantSiteIds: [], lineIds: [] })
                  }
                />
              )}
            />
          </Grid>
          {multi('LBL00005', 'Plant Site', sc.plantSiteIds, plantSiteOptions, plantSiteIds =>
            // plantSite 변경 = line 초기화 (design 02 §3)
            set({ plantSiteIds, lineIds: [] })
          )}

          {/* Operation Group* (lookup — design 02 §2.4). AS-IS 배치: Plant Site 다음(cs Designer X=714, Row1). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00027', { defaultValue: 'Operation Group' })}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={sc.operationGroupId}
                  options={operationGroupOptions}
                  onChange={(_, picked) => set({ operationGroupId: String(picked ?? 'P') })}
                />
              )}
            />
          </Grid>

          {multi('LBL00010', 'Line', sc.lineIds, lineOptions, lineIds => set({ lineIds }))}

          {/* Model / Nickname — 표준 검색필드(입력 + 돋보기 → ItemByDivisionModal), 참고 SalesSiteProjectModel */}
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
          {/* cboValid: design 01 D-2 정적 숨김(Visibility=Never) — 렌더하지 않음. 기본 'ALL' 파라미터만 유지(D-2b). */}
        </>
      }
    />
  );
};
