import { useEffect, useRef } from 'react';

import type { ComboParam, ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { COMBO, MENU_ID, MSG } from '../shipment-master-electrode.constants';
import { useShipmentMasterElectrodeStore } from '../useShipmentMasterElectrodeStore';

interface Props {
  onSearch: () => void;
  onMaterialSearch: () => void;
  onModelSearch: () => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// design 02 (02_search-combo.md) 조회조건 1단 6컨트롤(좌->우 tabIndex):
//   Division*(단일,필수,EE 제외) / Plant Site(다중 CheckedList) / Material(입력+팝업,다건) /
//   Nick Name(단일) / Model(입력+팝업,다건). 기본포커스 = Division(tab1).
export const ShipmentMasterElectrodeForm = ({ onSearch, onMaterialSearch, onModelSearch }: Props) => {
  const { t } = useTranslation();

  const setAlert = useMessageStore.getState().setAlert;
  const sc = useShipmentMasterElectrodeStore(s => s.searchCondition);
  const set = useShipmentMasterElectrodeStore(s => s.setSearchCondition);
  const clearFilters = useShipmentMasterElectrodeStore(s => s.clearFilters);
  const openSearchArea = useShipmentMasterElectrodeStore(s => s.openSearchArea);

  // Plant Site = PlantSiteByFactoryEEOperation @divisionId (design 02 §2.2/§3 재조회 cascade).
  //   division 변경 시 param 이 바뀌어 자동 재조회. 값 raw, 인용은 getCombo funnel(nscm-patterns §3.3).
  const plantSiteFilter: ComboParam = { comboId: COMBO.PLANT_SITE, mnuId: MENU_ID, divisionId: sc.divisionId };

  const [divisions, plantSites] = useTabComboQueries({
    filters: [{ comboId: COMBO.DIVISION, mnuId: MENU_ID }, plantSiteFilter],
  });

  // MyDivision CMBO 는 ATTRIBUTE3<>'EE' 를 WHERE 에 내장(design 02 §2.1, ora.py 실측) — EE 제외는 서버에서
  //   이미 끝난다. 아래 filter 는 그 계약이 깨졌을 때를 위한 방어선일 뿐이며, 현재 CMBO 는 CODE/NAME 2컬럼만
  //   반환해 ATTRIBUTE3 가 오지 않으므로 실제로는 아무 행도 거르지 않는다(무해, 후보범위 영향 0).
  const divisionOptions = toOptions((divisions ?? []).filter(r => str(r.ATTRIBUTE3) !== 'EE'));
  const plantSiteOptions = toOptions(plantSites);

  // R3(design 01 §5, iter-2 G5 — AS-IS SetDivisionAuthCheck): MyDivision 결과 0건 = 사용자에게
  //   조회 가능한 division 권한이 없음 -> 조회영역 컨트롤 전체 disable(권한 없음 상태).
  //   콤보 로드 완료 후에만 판정: divisions === undefined 는 로딩 중이라 disable 하지 않는다
  //   (로딩 중 잠깐 disable 되는 깜빡임 방지). disable vs 마스킹 시각 세부는 AS-IS BaseForm 미해석 →
  //   사용자 확인 축(04_react-gap §7).
  const noDivisionAuth = divisions !== undefined && divisionOptions.length === 0;

  // AS-IS SetDivisionAuthCheck 는 disable 과 **함께 알림을 띄운다**(BaseForm.cs:5997~6001
  //   `MessageHelper.GMessageBox("MSG00097")` + `usrLayoutControl.Enabled=false`). 직전 구현은 disable 만 해
  //   사용자가 이유를 알 수 없었다(gap-resolve iter-1 G5). 진입당 1회만 표출한다.
  // Division 기본값 보정 — AS-IS `setListBox(dtMyDivision, cboDivision, false, ...)`(cs:173)는 바인딩과
  //   동시에 후보 첫 행을 선택한다. store 초기값은 `session.div`(useShipmentMasterElectrodeStore.ts:37)라
  //   그 값이 MyDivision 후보(권한 + ATTRIBUTE3<>'EE') 밖이면 (a) 드롭다운이 빈 칸으로 보이고
  //   (b) 권한 없는 division 으로 조회가 나간다. EE 계열 division 은 실재한다(ora.py 실측).
  //   후보에 없으면 첫 후보로 보정하고 후보가 0건이면 비운다(그때는 noDivisionAuth 가 조회영역을 막는다).
  //   deps 에 divisionOptions(매 렌더 새 배열)를 넣으면 무한 재실행이라 divisions 참조만 본다.
  //   자매 shipment-requestor-pic/components/ShipmentRequestorPicForm.tsx 동일 패턴.
  useEffect(() => {
    if (!divisions) return;
    const codes = divisionOptions.map(o => o.value);
    if (sc.divisionId && codes.includes(sc.divisionId)) return;
    const next = codes[0] ?? '';
    if (next === sc.divisionId) return;
    set({ divisionId: next, scmSiteIds: [], materialId: '', modelId: '' });
    clearFilters();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisions, sc.divisionId]);

  const authAlertShownRef = useRef(false);
  useEffect(() => {
    if (!noDivisionAuth || authAlertShownRef.current) return;
    authAlertShownRef.current = true;
    void setAlert({
      type: 'alert',
      content: t(MSG.NO_DIVISION_AUTH, { defaultValue: 'No authority assigned.' }),
    });
  }, [noDivisionAuth, setAlert, t]);

  return (
    <SearchArea
      searchButtonLabel={t('LBL00664', { defaultValue: 'Search' })}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division* (필수, 기본포커스 — design 02 §2.1). 변경 시 Plant Site cascade + Material/Model clear(§3). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00641', { defaultValue: 'Division' })}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  // R6(design 01 R6 / 02 §6): 화면 진입 시 Division 콤보 기본 포커스.
                  autoFocus
                  disabled={noDivisionAuth}
                  value={sc.divisionId}
                  options={divisionOptions}
                  onChange={(_, picked) => {
                    set({
                      divisionId: String(picked ?? ''),
                      scmSiteIds: [],
                      materialId: '',
                      modelId: '',
                    });
                    // AS-IS SetChangedControl 은 division 이 바뀌면 그리드 datasource 도 비운다
                    //   (cs:197~200 `SpreadInfo.ClearDataSource`). 직전 구현은 조회조건만 초기화해 이전
                    //   division 의 조회결과가 남았다(gap-resolve iter-1 G8). filters 를 비우면
                    //   useTabProcQuery 가 disabled 되어 그리드가 빈다(refetch 직접호출 아님).
                    clearFilters();
                  }}
                />
              )}
            />
          </Grid>

          {/* Plant Site (다중 CheckedList) — division 하위 EE operation plant(서버 @divisionId cascade). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00005', { defaultValue: 'Plant Site' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  disabled={noDivisionAuth}
                  limitTags={1}
                  sortBy='label'
                  value={sc.scmSiteIds.join(',')}
                  options={plantSiteOptions}
                  onChange={(_, picked) =>
                    set({
                      scmSiteIds: String(picked ?? '')
                        .split(',')
                        .filter(v => v && v !== 'ALL'),
                    })
                  }
                />
              )}
            />
          </Grid>

          {/* Material — 입력 + 돋보기(SSP0024 전용 ItemByDivisionModal), 다건(콤마/개행). design 02 §4.6. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00021', { defaultValue: 'Material' })}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  disabled={noDivisionAuth}
                  className={commonStyles.popupSearchField}
                  value={sc.materialId}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
                        iconComponent={
                          <FunctionSearchIcon appearance='lined' onClick={onMaterialSearch} />
                        }
                      />
                    ),
                  }}
                  onChange={e => set({ materialId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* Nick Name (단일 텍스트). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00767', { defaultValue: 'Nick Name' })}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  disabled={noDivisionAuth}
                  value={sc.nickName}
                  onChange={e => set({ nickName: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* Model — 입력 + 돋보기(SSP0024 전용 ItemByDivisionModal), 다건. design 02 §4.6. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00669', { defaultValue: 'Model' })}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  disabled={noDivisionAuth}
                  className={commonStyles.popupSearchField}
                  value={sc.modelId}
                  InputProps={{
                    endAdornment: (
                      <Button
                        appearance='outlined'
                        priority='normal'
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
        </>
      }
    />
  );
};
