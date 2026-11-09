import { MaterialByDivisionModal, PeriodField } from 'features/master/src/components';
import { useEffect, useState } from 'react';

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
 * SCP0049 조회조건(Doc_lgc_bak/rules/domains/scp/SCP0049.md) — 2단 + extra.
 * 1단 Div./Operation group/Plant/Building · 2단 Line/Operation/Model·Nickname/Material ·
 * extra Period/Bucket/Version/체크박스 6종(Loss·Line Assign·Tact Time·Yield·RESULT·Empty Value).
 * 주의: 사용자 지시(2026-11-04)로 Version 을 extra Bucket 다음으로, Material 을 2단 끝으로 이동
 *   (원래 AS-IS 는 Ver.=2단 선두·Material=extra 선두). 그에 맞춰 extra 를 한 칸씩 당김.
 * 체크박스 5종(Loss·Line Assign·Tact Time·Yield·Empty Value) 사용자 값을 p_check_* 로 전송.
 *   Line Assign/Tact Time/Yield 는 2026-11-04 복원(기존 UI 제거·Y 고정에서 전환 — 설계 02 §7-3 승계 권고).
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

  const [divisionRows, groupRows, plantRows, buildingRows] = useTabComboQueries({
    filters: [
      COMBO.DIVISION,
      { comboId: COMBO.GROUP, divisionId: div },
      { comboId: COMBO.PLANT, divisionId: div, shopGroupId: groupParam },
      { comboId: COMBO.BUILDING, divisionId: div, plantId: plantParam, param3: groupParam },
    ],
    enabled: !!div,
  });

  // Division 옵션 = 81→40→기타 재정렬(02 §2 #1 — AS-IS 클라 후처리 재현). 첫 항목 기본선택은 페이지 effect.
  const divisionOptions = sortDivisionOptions(divisionRows);
  const groupOptions = toComboOptions(groupRows);

  // Operation group = 단일 선택 · ALL 없음 · 기본값 목록 첫 항목 — 정본(FP 판)은 Group 목록에 ALL 을 넣지
  //   않아 Division 이 바뀔 때마다 첫 항목(코드순 A Assembly)이 선택된다(cs:5547-5548 setListBox(…, false)).
  //   조회조건 표준(SCP v0.5 CAPA 121행)도 선택·단일(ALL 버튼 표기 없음). 목록에 없는 값(초기 'ALL'·
  //   F6 복원값·이전 Division 값)이면 첫 항목으로 바꾼다.
  const groupCodes = groupOptions.map(o => o.value).join(',');
  useEffect(() => {
    if (!div || groupOptions.length === 0) return;
    if (!groupOptions.some(o => o.value === searchParams.group)) {
      setSearchParams({ group: groupOptions[0].value });
    }
    // groupOptions 는 렌더마다 새 배열이라 코드 목록(groupCodes)으로 변화를 본다.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [div, groupCodes, searchParams.group, setSearchParams]);

  const plantOptions = toComboOptions(plantRows);
  const buildingOptions = toComboOptions(buildingRows);

  // Line·Operation 후보는 Group 으로 거르지 않고 Plant·Building 범위로 거른다 — 정본(FP 판)은 Filter 에
  //   SHOP_GROUP_ID 만 넣어 OPERATION_GROUP_ID 는 비어 있고(cs:5554), PLANT_ID·FACTORY_ID 는 인자 2개
  //   GetCheckedListValue 라 ALL 이면 현재 목록 코드 전체가 들어간다(cs:5562·5571). 그래서 선택한 Group 의
  //   Building 안 라인·공정(Assembly Building 의 Formation 라인 등)까지 나온다.
  const plantScope = plantParam || plantOptions.map(o => o.value).join(',');
  const factoryScope = factoryParam || buildingOptions.map(o => o.value).join(',');
  const [lineRows, operationRows] = useTabComboQueries({
    filters: [
      {
        comboId: COMBO.LINE,
        divisionId: div,
        plantId: plantScope,
        factoryId: factoryScope,
        operationGroupId: '',
      },
      {
        comboId: COMBO.OPERATION,
        divisionId: div,
        plantId: plantScope,
        factoryId: factoryScope,
        lineId: lineParam,
        operationGroupId: '',
      },
    ],
    enabled: !!div && plantRows !== undefined && buildingRows !== undefined,
  });
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
              label={t(LBL.GROUP, '_Operation group')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={searchParams.group}
                  options={groupOptions}
                  onChange={(_, picked) =>
                    setSearchParams({
                      group: String(picked || groupOptions[0]?.value || 'ALL'),
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
          {popupTextField(
            LBL.MATERIAL,
            'Material',
            searchParams.materialId,
            v => setSearchParams({ materialId: v }),
            () => setMaterialPopupOpen(true)
          )}
        </>
      }
      extraConditions={
        <>
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
                // 다중선택(Month/Day, W 없음, 02 §5). 전체선택 = Month+Day('M,D'), Month 만 고르면 'M'.
                //   Day 만 골라도 Month 가 함께 조회되므로(AS-IS SetValues("Month") 재강제) 'M,D' 로 표시된다.
                //   필수: value 는 실제 코드를 열거한다. 'ALL' 센티널을 넘기면 공통 CustomDropdown 이
                //   매칭 0건이라 전체선택 칩이 사라진다(2026-10-23 센티널 표시 로직 폐기).
                <CustomDropdown
                  multiple
                  allOption
                  limitTags={2}
                  value={searchParams.bucketDay ? 'M,D' : 'M'}
                  options={BUCKET_OPTIONS.map(o => ({ ...o }))}
                  onChange={(_, picked) => {
                    // 공통 CustomDropdown 은 선택 0개(SELECT ALL 재클릭=전체 해제)에 'ALL' 토큰을
                    //   보낸다. Bucket 은 Month 가 바닥값('M' 항상 조회)이라 전체 해제는 'Day 제외'로
                    //   수렴한다 → bucketDay=false. 'ALL' 을 true 로 받으면 재해제가 M,D 로 되튄다.
                    const codes = String(picked ?? '').split(',');
                    setSearchParams({ bucketDay: codes.includes('D') });
                  }}
                />
              )}
            />
          </Grid>
          {/* Version — 사용자 지시(2026-11-04)로 Bucket 다음 위치로 이동(기존 2단 Building 다음에서). */}
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
          {/* 체크박스 6종 — Version 오른쪽(같은 행) 배치(사용자 지시 2026-11-04). Version 뒤 남은 폭
              (grow)에 들어가며 넘치면 flexWrap 으로 줄바꿈(1줄 고정 아님 — 사용자 OK).
              AS-IS 순서(Loss·Line Assign·Tact Time·Yield·RESULT·Empty Value). Line Assign/Tact Time/Yield
              는 2026-11-04 복원(기존 UI 제거·Y 고정에서 전환 — 설계 02 §7-3 승계 권고). p_check_* 사용자 값 전송. */}
          <Grid size={3} className={commonStyles.customGrid}>
            <div className={commonStyles.customCheckbox}>
              <Stack direction='row' spacing={2} alignItems='center' useFlexGap flexWrap='wrap'>
                {/* Loss — 체크 시 조회 인자 checkLoss='Y'. AS-IS 기본 N(cs:352). */}
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
