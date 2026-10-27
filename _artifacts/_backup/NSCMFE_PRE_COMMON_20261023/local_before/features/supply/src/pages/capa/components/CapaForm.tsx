import { MaterialByDivisionModal, PeriodField } from 'features/master/src/components';
import { useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, Checkbox, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid, Stack } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import { BUCKET_OPTIONS, COMBO, LBL, MENU_ID } from '../capa.constants';
import { useCapaStore } from '../useCapaStore';
import { sortDivisionOptions, toComboOptions } from '../utils/capa.combos';

interface CapaFormProps {
  onSearch: () => void;
}

/**
 * SCP0049 조회조건(Doc_lgc_bak/rules/domains/scp/SCP0049.md) — 2단 + extra. 1단 Div./Ver./Operation group/Plant ·
 * 2단 Building/Line/Operation/Model·Nickname · extra Material/Period/Bucket/RESULT·Empty Value.
 * Loss/Line Assign/Tact Time/Yield 는 UI 제거(Measure 셋팅 대체), store CHECK_DEFAULTS 값을 그대로 전송한다.
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

  const tabId = useTabid();

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

  // 메1(MaterialByDivisionModal) 픽커 — Model/Nickname, Material 각각 열림 상태. 확정값(ITEM_ID, 다건 콤마)은 해당 입력칸에 반영.
  const [modelPopupOpen, setModelPopupOpen] = useState(false);
  const [materialPopupOpen, setMaterialPopupOpen] = useState(false);

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
            // 'ALL' sentinel 은 빈 배열(필터 없음)로 저장한다. 그대로 저장하면 cascade 콤보 파라미터에 'ALL' 문자열이
            //   실려 하위 콤보가 비게 된다(ShipmentPlanFgForm multi 와 동일 규칙).
            onChange={(_, picked) =>
              onPick(
                String(picked ?? '')
                  .split(',')
                  .filter(v => v !== '' && v.toUpperCase() !== 'ALL')
              )
            }
          />
        )}
      />
    </Grid>
  );

  const popupTextField = (
    labelCode: string,
    labelEn: string,
    value: string,
    onChange: (v: string) => void,
    onOpenPopup: () => void
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(labelCode, labelEn)}
        labelAlign='right'
        render={() => (
          <InputField
            fullWidth
            className={commonStyles.popupSearchField}
            value={value}
            InputProps={{
              endAdornment: (
                <Button
                  appearance='outlined'
                  priority='normal'
                  iconComponent={<FunctionSearchIcon appearance='lined' />}
                  onClick={onOpenPopup}
                />
              ),
            }}
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
    <>
    <SearchArea
      isHidden={!isOpenSearchArea}
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      onSearch={onSearch}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Div')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={div}
                  options={divisionOptions}
                  // Division 변경 = 검색조건(Div·기간 제외) + 그리드 초기화(store changeDivision, TO-BE 공통 요건).
                  //   편집중(dirty)이면 MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가 이전 Div 로 복귀
                  //   (commit 51d4e9fa 패턴).
                  onChange={(_, picked) => {
                    const next = String(picked ?? '');
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (ok) changeDivision(next);
                    });
                  }}
                />
              )}
            />
          </Grid>
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
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.GROUP, '_Operation group')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  value={searchParams.group}
                  options={groupOptions}
                  onChange={(_, picked) =>
                    setSearchParams({
                      group: String(picked || 'ALL'),
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
          {multiField(LBL.LINE, 'Line', searchParams.lineIds, lineOptions, v =>
            setSearchParams({ lineIds: v, operationIds: [] })
          )}
          {multiField(LBL.OPERATION, 'Operation', searchParams.operationIds, operationOptions, v =>
            setSearchParams({ operationIds: v })
          )}
          {popupTextField(
            LBL.MODEL,
            'Model/Nickname',
            searchParams.modelId,
            v => setSearchParams({ modelId: v }),
            () => setModelPopupOpen(true)
          )}
        </>
      }
      extraConditions={
        <>
          {popupTextField(
            LBL.MATERIAL,
            'Material',
            searchParams.materialId,
            v => setSearchParams({ materialId: v }),
            () => setMaterialPopupOpen(true)
          )}
          <PeriodField
            gridSize={3}
            mode='month'
            label={t(LBL.PERIOD, '_Period')}
            start={searchParams.fromYyyymm}
            end={searchParams.toYyyymm}
            onChange={(start, end) => setSearchParams({ fromYyyymm: start, toYyyymm: end })}
          />
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.BUCKET, '_Bucket')}
              labelAlign='right'
              render={() => (
                // 다중선택(Month/Day, W 없음, 02 §5). ALL = Month+Day('D,M'), Month 만 고르면 'M'.
                //   Day 만 골라도 Month 가 함께 조회되므로(AS-IS SetValues("Month") 재강제) ALL 로 표시된다.
                <CustomDropdown
                  multiple
                  allOption
                  limitTags={2}
                  value={searchParams.bucketDay ? 'ALL' : 'M'}
                  options={BUCKET_OPTIONS.map(o => ({ ...o }))}
                  onChange={(_, picked) => {
                    const codes = String(picked ?? '').split(',');
                    setSearchParams({ bucketDay: codes.includes('D') || codes.includes('ALL') });
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={3} className={commonStyles.customGrid}>
            <div className={commonStyles.customCheckbox}>
              <Stack direction='row' spacing={2} alignItems='center'>
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
    <MaterialByDivisionModal
      open={modelPopupOpen}
      modalClose={() => setModelPopupOpen(false)}
      multiCheckbox
      setSelectedValue={items => setSearchParams({ modelId: items })}
      preSearchParams={{
        divisionId: div,
        operationGroup: '',
        scpModuleType: MENU_ID,
        itemId: searchParams.modelId,
      }}
    />
    <MaterialByDivisionModal
      open={materialPopupOpen}
      modalClose={() => setMaterialPopupOpen(false)}
      multiCheckbox
      setSelectedValue={items => setSearchParams({ materialId: items })}
      preSearchParams={{
        divisionId: div,
        operationGroup: '',
        scpModuleType: MENU_ID,
        itemId: searchParams.materialId,
      }}
    />
    </>
  );
};
