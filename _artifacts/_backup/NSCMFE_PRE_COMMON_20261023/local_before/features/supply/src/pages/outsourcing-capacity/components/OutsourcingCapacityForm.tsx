import { useEffect, useMemo } from 'react';

import type { ComboParam, ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

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
  const setDivision = useOutsourcingCapacityStore(s => s.setDivision);
  const openSearchArea = useOutsourcingCapacityStore(s => s.openSearchArea);

  const tabId = useTabid();

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
  //   교정도 setDivision 경유(정본 SCP0025 Form 동일) — 초기 로드 시점이라 초기화 대상이 없어 사실상 Division 설정만 하고,
  //   공통 "Division 변경 = 조건·그리드 초기화" 규약을 한 액션으로 일원화한다.
  const firstDivision = divisionOptions[0]?.value ?? '';
  const hasCurrentDivision = divisionOptions.some(o => o.value === sc.divisionId);
  useEffect(() => {
    if (firstDivision && !hasCurrentDivision) setDivision(firstDivision);
  }, [firstDivision, hasCurrentDivision, setDivision]);

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
                  onChange={(_, picked) => {
                    // Division 변경 = 검색조건(Div 제외) + 그리드 초기화(store setDivision, TO-BE 공통 요건 — Plant Site
                    //   cascade 초기화 포함). 편집중(dirty)이면 MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가
                    //   이전 Div 로 복귀(commit 51d4e9fa 패턴).
                    const v = String(picked ?? '');
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (ok) setDivision(v);
                    });
                  }}
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

          {/* Model / Nickname — TO-BE 변경: 기존 Model(팝업)+Nick Name(LIKE) 두 조건을
            MaterialByDivisionModal 한 필드로 통합. 팝업 선택 시 itemId(ITEM_ID)+nickName(NICK_NAME)
            을 함께 저장(두 GET SP 파라미터 p_item_id/p_nick_name 유지). 표시는 itemId. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL_NICKNAME, '_Model / Nickname')}
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
                  // 직접 타이핑 = Model(itemId) 수동 입력 — 팝업으로 함께 채워진 nickName 잔재를 비운다.
                  onChange={e => set({ itemId: e.target.value, nickName: '' })}
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
