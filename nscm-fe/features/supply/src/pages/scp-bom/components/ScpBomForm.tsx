import { useEffect, useMemo } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import { COMBO, LBL } from '../scp-bom.constants';
import { useScpBomStore } from '../useScpBomStore';

interface Props {
  onSearch: () => void;
  onModelSearch: () => void;
  // R8 — MyDivision 0건(권한 없음) 여부를 페이지로 전달(조회 차단 게이트, design 01 R8).
  onDivisionAuth: (hasAuth: boolean) => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// 다중 콤보 'ALL'/공백 정규화 → 실코드 배열(전체선택 = 빈 배열, 부분선택만 유지).
const pickMulti = (picked: unknown): string[] =>
  str(picked)
    .split(',')
    .filter(v => v !== '' && v.toUpperCase() !== 'ALL');

// design 02 조회조건 7행(1단): Division(권한 콤보 첫 항목 기본선택) / Plant Site(다중) /
//   Model/Nickname(텍스트+MaterialByDivisionModal 돋보기) / Parent Item / Child Item(텍스트) / Alter BOM(체크박스).
//   6필드 ≤2단 → extraConditions 불요(§5).
export const ScpBomForm = ({ onSearch, onModelSearch, onDivisionAuth }: Props) => {
  const { t } = useTranslation();

  const sc = useScpBomStore(s => s.searchCondition);
  const set = useScpBomStore(s => s.setSearchCondition);
  const setDivision = useScpBomStore(s => s.setDivision);
  const openSearchArea = useScpBomStore(s => s.openSearchArea);

  const tabId = useTabid();

  // Division 은 권한 콤보(MyDivision) 배열 첫 항목이 기본선택이라, PlantSite 콤보 파라미터도 선택 Division 으로 cascade 된다.
  const [divisions, plantSites] = useTabComboQueries({
    filters: [COMBO.DIVISION, { comboId: COMBO.PLANT_SITE, divisionId: sc.divisionId }],
  });

  const divisionOptions = useMemo(() => toOptions(divisions), [divisions]);
  const plantSiteOptions = toOptions(plantSites);

  // R8 권한 게이트 — MyDivision 응답이 왔고(≠undefined) 0건이면 권한 없음(design 01 R8, cs:121~122
  //   SetDivisionAuthCheck). 로딩 중(undefined)엔 판정 보류. AS-IS 는 조회영역(usrLayoutControl2)
  //   전체 Enabled=false 라 아래 입력 컨트롤도 함께 비활성한다(validation-shipment-result 선례).
  const noDivisionAuth = divisions !== undefined && divisionOptions.length === 0;
  useEffect(() => {
    if (divisions === undefined) return;
    onDivisionAuth(!noDivisionAuth);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisions]);

  // Division 기본값 — 현재값이 옵션에 없으면 목록 첫 항목으로(사용자 지시 2026-10-22, AS-IS R7 '81' 고정 폐기).
  //   권한 콤보(MyDivision, @mnuId 게이트)가 반환하는 배열의 첫 항목(권한목록 최상위)을 기본 선택한다.
  //   개인화 복원(restoreSearchConditions)으로 들어온 유효 divisionId 는 그대로 둔다(옵션에 있으면 early return).
  useEffect(() => {
    if (sc.divisionId && divisionOptions.some(o => o.value === sc.divisionId)) return;
    const first = String(divisionOptions[0]?.value ?? '');
    if (first) setDivision(first);
  }, [divisionOptions, sc.divisionId, setDivision]);

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division — 권한 콤보(MyDivision) 배열 첫 항목 기본선택 (사용자 지시 2026-10-22, R7 '81' 고정 폐기) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Div')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  // 사용자 선택 가능(enabled) — AS-IS OnShown 의 '81' 고정+disabled(R7)는 폐기(2026-10-22).
                  //   권한 콤보 배열 첫 항목이 기본선택이고, 사용자가 자유롭게 Division 을 바꿀 수 있다.
                  value={sc.divisionId}
                  options={divisionOptions}
                  // Division 변경(싱글 콤보) = Division 제외 검색조건 전부 + 그리드 초기화(store setDivision, TO-BE 공통 요건).
                  //   PlantSite cascade 초기화도 setDivision(initSearch)에 포함된다(design 02 §3). 편집중(dirty)이면
                  //   MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가 이전 Div 로 복귀(commit 51d4e9fa 패턴).
                  onChange={(_, picked) => {
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (ok) setDivision(String(picked ?? ''));
                    });
                  }}
                />
              )}
            />
          </Grid>
          {/* Plant Site — 다중선택 + 검색 + ALL (PlantByDivisionAll_SCP, design 02 §2.2) */}
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
                  disabled={noDivisionAuth}
                  value={sc.plantSiteIds.join(',')}
                  options={plantSiteOptions}
                  onChange={(_, picked) => set({ plantSiteIds: pickMulti(picked) })}
                />
              )}
            />
          </Grid>
          {/* Model/Nickname — 텍스트 + 돋보기(MaterialByDivisionModal COM0013, design 02 §4.6) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL, '_Model/Nickname')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  value={sc.modelId}
                  disabled={noDivisionAuth}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        disabled={noDivisionAuth}
                        iconComponent={
                          <FunctionSearchIcon appearance='lined' onClick={onModelSearch} />
                        }
                      />
                    ),
                  }}
                  onChange={e => set({ modelId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>
          {/* Parent Item — 텍스트 단일값 (design 02 §1#5) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PARENT_ITEM, '_Parent Item')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sc.parentId}
                  disabled={noDivisionAuth}
                  onChange={e => set({ parentId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>
          {/* Child Item — 텍스트 단일값 (design 02 §1#6) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.CHILD_ITEM, '_Child Item')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  value={sc.childId}
                  disabled={noDivisionAuth}
                  onChange={e => set({ childId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>
          {/* Alter BOM — 체크박스(기본 미체크 = 'ALL', 체크 = 'ALTER', design 02 §1#7) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.ALTER_BOM, '_Alter BOM')}
              labelAlign='right'
              render={() => (
                <Checkbox
                  labelText=''
                  checked={sc.alterBom}
                  disabled={noDivisionAuth}
                  onChange={checked => set({ alterBom: checked })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
