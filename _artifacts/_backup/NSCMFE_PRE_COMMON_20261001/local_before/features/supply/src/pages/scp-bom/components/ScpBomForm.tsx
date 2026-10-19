import { useEffect } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

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

// design 02 조회조건 7행(1단): Division('81' 고정+disabled) / Plant Site(다중) /
//   Model/Nickname(텍스트+MaterialByDivisionModal 돋보기) / Parent Item / Child Item(텍스트) / Alter BOM(체크박스).
//   6필드 ≤2단 → extraConditions 불요(§5).
export const ScpBomForm = ({ onSearch, onModelSearch, onDivisionAuth }: Props) => {
  const { t } = useTranslation();

  const sc = useScpBomStore(s => s.searchCondition);
  const set = useScpBomStore(s => s.setSearchCondition);
  const openSearchArea = useScpBomStore(s => s.openSearchArea);

  // Division 은 '81' 고정이라 PlantSite 콤보 파라미터도 고정('81'). MyDivision 은 표시명·권한 판정용.
  const [divisions, plantSites] = useTabComboQueries({
    filters: [COMBO.DIVISION, { comboId: COMBO.PLANT_SITE, divisionId: sc.divisionId }],
  });

  const divisionOptions = toOptions(divisions);
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

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', { defaultValue: 'Search' })}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division — '81'(Automotive Battery) 고정 + disabled (design 01 R7) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, { defaultValue: 'Div.' })}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  disabled
                  value={sc.divisionId}
                  options={divisionOptions}
                  onChange={() => undefined}
                />
              )}
            />
          </Grid>
          {/* Plant Site — 다중선택 + 검색 + ALL (PlantByDivisionAll_SCP, design 02 §2.2) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PLANT_SITE, { defaultValue: 'Plant Site' })}
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
              label={t(LBL.MODEL, { defaultValue: 'Model/Nickname' })}
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
              label={t(LBL.PARENT_ITEM, { defaultValue: 'Parent Item' })}
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
              label={t(LBL.CHILD_ITEM, { defaultValue: 'Child Item' })}
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
              label={t(LBL.ALTER_BOM, { defaultValue: 'Alter BOM' })}
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
