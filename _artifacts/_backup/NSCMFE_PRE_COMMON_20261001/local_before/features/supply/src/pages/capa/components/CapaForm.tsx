import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Checkbox, FormItem, InputField } from '@shared/lges';
import { Grid, Stack } from '@shared/mui';

import { COMBO, LBL } from '../capa.constants';
import { useCapaStore } from '../useCapaStore';
import { sortDivisionOptions, toComboOptions, monthOptions } from '../utils/capa.combos';

interface CapaFormProps {
  onSearch: () => void;
}

/**
 * SCP0049 조회조건(02 설계) — 3단 + extra. 1단 Div./Operation group/Plant/Building/Ver. ·
 * 2단 Line/Operation/Model·Nickname/Material · extra Period/Bucket/체크박스 5종.
 * cascade 재조회형(useTabComboQueries + onChange 하위 ALL 리셋) — Division 변경은 store.changeDivision.
 */
export const CapaForm = ({ onSearch }: CapaFormProps) => {
  const { t } = useTranslation();
  const searchParams = useCapaStore(state => state.searchParams);
  const setSearchParams = useCapaStore(state => state.setSearchParams);
  const changeDivision = useCapaStore(state => state.changeDivision);
  const changeVersion = useCapaStore(state => state.changeVersion);
  const isOpenSearchArea = useCapaStore(state => state.isOpenSearchArea);
  const versionOptions = useCapaStore(state => state.versionOptions);
  const periodMaxYyyymm = useCapaStore(state => state.periodMaxYyyymm);

  const div = searchParams.divisionId;
  // Division 변경 직후 하위 후보는 '전 그룹' 범위(02 §3 주의) — group 파라미터 미전달(ALL).
  const groupParam = searchParams.group === 'ALL' ? '' : searchParams.group;
  const plantParam = searchParams.plantIds.join(',');
  const factoryParam = searchParams.factoryIds.join(',');
  const lineParam = searchParams.lineIds.join(',');

  const [divisionRows, groupRows, plantRows, buildingRows, lineRows, operationRows] =
    useTabComboQueries({
      filters: [
        COMBO.DIVISION,
        { comboId: COMBO.GROUP, divisionId: div },
        { comboId: COMBO.PLANT, divisionId: div, shopGroupId: groupParam },
        { comboId: COMBO.BUILDING, divisionId: div, plantId: plantParam, param3: groupParam },
        {
          comboId: COMBO.LINE,
          divisionId: div,
          plantId: plantParam,
          factoryId: factoryParam,
          operationGroupId: groupParam,
        },
        {
          comboId: COMBO.OPERATION,
          divisionId: div,
          plantId: plantParam,
          factoryId: factoryParam,
          lineId: lineParam,
          operationGroupId: groupParam,
        },
      ],
      enabled: !!div,
    });

  // Division 옵션 = 81→40→기타 재정렬(02 §2 #1 — AS-IS 클라 후처리 재현). 첫 항목 기본선택은 페이지 effect.
  const divisionOptions = sortDivisionOptions(divisionRows);
  const groupOptions = toComboOptions(groupRows);
  const plantOptions = toComboOptions(plantRows);
  const buildingOptions = toComboOptions(buildingRows);
  const lineOptions = toComboOptions(lineRows);
  const operationOptions = toComboOptions(operationRows);
  const periodOptions = monthOptions(searchParams.fromYyyymm, periodMaxYyyymm);

  const multiField = (
    labelCode: string,
    labelEn: string,
    value: string[],
    options: { label: string; value: string }[],
    onPick: (codes: string[]) => void
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(labelCode, labelEn)}
        labelAlign='right'
        render={() => (
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            limitTags={1}
            sortBy='label'
            value={value.join(',')}
            options={options}
            onChange={(_, picked) =>
              onPick(
                String(picked ?? '')
                  .split(',')
                  .filter(Boolean)
              )
            }
          />
        )}
      />
    </Grid>
  );

  const textField = (
    labelCode: string,
    labelEn: string,
    value: string,
    onChange: (v: string) => void
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(labelCode, labelEn)}
        labelAlign='right'
        render={() => (
          <InputField
            fullWidth
            value={value}
            onChange={e => onChange(e.target.value)}
            onKeyDown={e => {
              if (e.key === 'Enter') onSearch();
            }}
          />
        )}
      />
    </Grid>
  );

  return (
    <SearchArea
      isHidden={!isOpenSearchArea}
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      onSearch={onSearch}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Div.')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={div}
                  options={divisionOptions}
                  onChange={(_, picked) => changeDivision(String(picked ?? ''))}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.GROUP, '_Operation group')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={searchParams.group}
                  options={groupOptions}
                  onChange={(_, picked) =>
                    setSearchParams({
                      group: String(picked ?? 'ALL'),
                      plantIds: [],
                      factoryIds: [],
                      lineIds: [],
                      operationIds: [],
                    })
                  }
                />
              )}
            />
          </Grid>
          {multiField(LBL.PLANT, 'Plant', searchParams.plantIds, plantOptions, v =>
            setSearchParams({ plantIds: v, factoryIds: [], lineIds: [], operationIds: [] })
          )}
          {multiField(LBL.BUILDING, 'Building', searchParams.factoryIds, buildingOptions, v =>
            setSearchParams({ factoryIds: v, lineIds: [], operationIds: [] })
          )}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.VERSION, '_Version')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={searchParams.versionId}
                  options={versionOptions.map(o => ({ label: o.name, value: o.code }))}
                  onChange={(_, picked) => changeVersion(String(picked ?? ''))}
                />
              )}
            />
          </Grid>

          {multiField(LBL.LINE, 'Line', searchParams.lineIds, lineOptions, v =>
            setSearchParams({ lineIds: v, operationIds: [] })
          )}
          {multiField(LBL.OPERATION, 'Operation', searchParams.operationIds, operationOptions, v =>
            setSearchParams({ operationIds: v })
          )}
          {textField(LBL.MODEL, 'Model/Nickname', searchParams.modelId, v =>
            setSearchParams({ modelId: v })
          )}
          {textField(LBL.MATERIAL, 'Material', searchParams.materialId, v =>
            setSearchParams({ materialId: v })
          )}
        </>
      }
      extraConditions={
        <>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PERIOD, '_Period')}
              labelAlign='right'
              render={() => (
                <Stack direction='row' spacing={1} alignItems='center'>
                  <CustomDropdown
                    value={searchParams.fromYyyymm}
                    options={periodOptions}
                    onChange={(_, picked) => setSearchParams({ fromYyyymm: String(picked ?? '') })}
                  />
                  <span>~</span>
                  <CustomDropdown
                    value={searchParams.toYyyymm}
                    options={periodOptions}
                    onChange={(_, picked) => setSearchParams({ toYyyymm: String(picked ?? '') })}
                  />
                </Stack>
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.BUCKET, '_Bucket')}
              labelAlign='right'
              render={() => (
                // Month 고정(항상 포함) + Day 토글(W 없음, 02 §5). p_bucket = 'M' | 'D,M'.
                <Checkbox
                  labelText={t('LBL00852', '_Day')}
                  checked={searchParams.bucketDay}
                  onChange={checked => setSearchParams({ bucketDay: checked })}
                />
              )}
            />
          </Grid>
          <Grid size={6} className={commonStyles.customGrid}>
            <div className={commonStyles.customCheckbox}>
              <Stack direction='row' spacing={2} alignItems='center'>
                <Checkbox
                  labelText={t(LBL.LOSS, '_Loss')}
                  checked={searchParams.checkLoss}
                  onChange={checked => setSearchParams({ checkLoss: checked })}
                />
                <Checkbox
                  labelText={t(LBL.LINE_ASSIGN, '_Line Assign')}
                  checked={searchParams.checkLine}
                  onChange={checked => setSearchParams({ checkLine: checked })}
                />
                <Checkbox
                  labelText={t(LBL.TACT_TIME, '_Tact Time')}
                  checked={searchParams.checkTact}
                  onChange={checked => setSearchParams({ checkTact: checked })}
                />
                <Checkbox
                  labelText={t(LBL.YIELD, '_Yield')}
                  checked={searchParams.checkYield}
                  onChange={checked => setSearchParams({ checkYield: checked })}
                />
                <Checkbox
                  labelText={t(LBL.RESULT, '_RESULT')}
                  checked={searchParams.checkResult}
                  onChange={checked => setSearchParams({ checkResult: checked })}
                />
                <Checkbox
                  labelText={t(LBL.EMPTY_VALUE, '_Empty Value')}
                  checked={searchParams.checkEmpty}
                  onChange={checked => setSearchParams({ checkEmpty: checked })}
                />
              </Stack>
            </div>
          </Grid>
        </>
      }
    />
  );
};
