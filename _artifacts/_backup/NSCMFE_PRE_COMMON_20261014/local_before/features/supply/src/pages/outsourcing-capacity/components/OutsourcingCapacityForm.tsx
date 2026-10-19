import { useEffect, useMemo } from 'react';

import type { ComboParam, ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { COMBO, DIVISION_EXCLUDE_ATTRIBUTE3, LBL } from '../outsourcing-capacity.constants';
import { useOutsourcingCapacityStore } from '../useOutsourcingCapacityStore';

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
//   Division*(단일·필수, EE 제외) -> Plant Site(다중, OSP cascade 재조회), Model(팝업)/Nick Name(LIKE).
export const OutsourcingCapacityForm = ({ onSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useOutsourcingCapacityStore(s => s.searchCondition);
  const set = useOutsourcingCapacityStore(s => s.setSearchCondition);
  const openSearchArea = useOutsourcingCapacityStore(s => s.openSearchArea);

  // Plant Site = PlantByDivisionOperOsp_SCP @divisionId cascade 재조회(design 02 §3 — 필터 방식 아님).
  //   divisionId 가 바뀌면 ComboParam 이 바뀌어 react-query key 가 갈려 서버 재조회된다(@operationGroup=null).
  const plantSiteFilter = useMemo<ComboParam>(
    () => ({ comboId: COMBO.PLANT_SITE, divisionId: sc.divisionId || 'ALL' }),
    [sc.divisionId]
  );

  const [divisions, plantSites] = useTabComboQueries({
    filters: [COMBO.DIVISION, plantSiteFilter],
  });

  // AS-IS BLUtils.GetDivisionWithoutEE 재현 — Division_SCP 전량 중 전극(EE) 사업부 제외(ATTRIBUTE3<>'EE').
  //   프로시저 이관 SQL 엔 소스 필터가 없어 화면에서 재현(combo-semantic-parity, AGENT.md §3, design 02 §2.1).
  const divisionOptions = useMemo(
    () => toOptions((divisions ?? []).filter(r => str(r.ATTRIBUTE3) !== DIVISION_EXCLUDE_ATTRIBUTE3)),
    [divisions]
  );

  // division 기본값 = 첫 옵션 자동 선택. store 초기값(session.div)이 옵션에 없으면 첫 옵션으로 교정.
  const firstDivision = divisionOptions[0]?.value ?? '';
  const hasCurrentDivision = divisionOptions.some(o => o.value === sc.divisionId);
  useEffect(() => {
    if (firstDivision && !hasCurrentDivision) {
      set({ divisionId: firstDivision, plantSiteIds: [] });
    }
  }, [firstDivision, hasCurrentDivision, set]);

  // Plant Site = 선택 division 소속 OSP 플랜트(서버 재조회 결과 그대로). CODE/NAME 기본 바인딩.
  const plantSiteOptions = toOptions(plantSites);

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division* (필수 — design 02 §2.1) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Div')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={sc.divisionId}
                  options={divisionOptions}
                  onChange={(_, picked) =>
                    // division 변경 = Plant Site cascade 초기화 (design 02 §3)
                    set({ divisionId: String(picked ?? ''), plantSiteIds: [] })
                  }
                />
              )}
            />
          </Grid>

          {/* Plant Site (다중, OSP cascade — design 02 §2.2) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PLANT_SITE, '_Plant Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  value={sc.plantSiteIds.join(',')}
                  options={plantSiteOptions}
                  onChange={(_, picked) =>
                    // CustomDropdown 전체해제/전체선택 = 'ALL' sentinel → 빈 배열로 정규화(SearchFields 규약).
                    set({
                      plantSiteIds: String(picked ?? '')
                        .split(',')
                        .filter(v => v !== '' && v.toUpperCase() !== 'ALL'),
                    })
                  }
                />
              )}
            />
          </Grid>

          {/* Model — 표준 검색필드(입력 + 돋보기 → ItemByDivisionModal, 다건). design 02 §4.6 */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL, '_Model')}
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

          {/* Nick Name — LIKE 검색(p_nick_name). design 02 §1 */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.NICK_NAME, '_Nick Name')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sc.nickName}
                  onChange={e => set({ nickName: e.target.value })}
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
