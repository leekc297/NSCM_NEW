import { useEffect } from 'react';

import type { ComboParam, ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { COMBO } from '../shipment-requestor-pic.constants';
import { useShipmentRequestorPicStore } from '../useShipmentRequestorPicStore';

interface Props {
  onSearch: () => void;
  onItemSearch: () => void;
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

// design 02 (02_search-combo.md) 조회조건 1행 5필드 + 팝업버튼 2:
//   Division*(단일,필수,MyDivision EE제외) / Plant Site(다중, PlantCell @divisionId cascade)
//   / Material(입력+팝업, 다건) / Nick Name(단일) / Model(입력+팝업, 다건).
export const ShipmentRequestorPicForm = ({ onSearch, onItemSearch, onModelSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useShipmentRequestorPicStore(s => s.searchCondition);
  const set = useShipmentRequestorPicStore(s => s.setSearchCondition);
  const openSearchArea = useShipmentRequestorPicStore(s => s.openSearchArea);

  // Plant Site = PlantCell @divisionId. 선택 division 을 넘겨 서버 cascade(design 02 §3 재조회 방식).
  //   division 변경 시 param 이 바뀌어 자동 재조회. 값 raw, 인용은 getCombo funnel.
  const plantSiteFilter: ComboParam = { comboId: COMBO.PLANT_SITE, divisionId: sc.divisionId };

  const [divisions, plantSites] = useTabComboQueries({
    filters: [COMBO.DIVISION, plantSiteFilter],
  });

  // MyDivision 콤보(권한 division).
  //   EE 제외(`ATTRIBUTE3 <> 'EE'`)와 권한필터는 CMBO SQL_DTL_CTN 안에 이미 들어 있고(ora.py 실측,
  //   AS-IS UP_FX_GetCommonDataList 'MyDivision' 분기와 1:1) 콤보는 CODE/NAME 2컬럼만 반환한다.
  //   gap-resolve iter-1 A07: 종전의 화면측 `ATTRIBUTE3 !== 'EE'` 재현 필터는 반환에 없는 컬럼을 보므로
  //   상시 참인 죽은 코드였다 — 실효 있는 필터로 오인하지 않도록 제거한다(후보범위 변화 없음).
  const divisionOptions = toOptions(divisions);
  const plantSiteOptions = toOptions(plantSites);

  // Division 기본값 보정 — AS-IS setListBox(dtMyDivision, cboDivision, isAddAll=false, cs:133)는 권한
  //   후보의 첫 행을 자동선택한다. store 초기값은 session.div 라 그 값이 MyDivision 후보(권한필터·EE제외)
  //   밖이면 (a) 드롭다운이 빈 칸으로 보이고 (b) 권한 없는 division 으로 조회가 나간다. 후보에 없으면
  //   첫 후보로 보정하고, 후보가 0건이면 비운다 — AS-IS SetDivisionAuthCheck(cs:130~131, division 권한
  //   0건 시 조회영역 제약)의 등가로 handleSearch 필수검증(MSG00097)이 조회를 막는다.
  //   deps 는 divisions(react-query 결과 참조)만 — 매 렌더 새로 만들어지는 divisionOptions 를 넣으면
  //   무한 재실행이 된다. 값이 이미 같으면 set 을 부르지 않아 루프가 생기지 않는다.
  useEffect(() => {
    if (!divisions) return;
    const codes = divisions.map(r => str(r.CODE));
    if (sc.divisionId && codes.includes(sc.divisionId)) return;
    const next = codes[0] ?? '';
    if (next === sc.divisionId) return;
    set({ divisionId: next, plantSiteIds: [] });
  }, [divisions, sc.divisionId, set]);

  return (
    <SearchArea
      searchButtonLabel={t('LBL00664', { defaultValue: 'Search' })}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division* (필수, 기본포커스 — design 02 §2.1). 변경 시 Plant Site cascade 초기화(§3). */}
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
                    set({ divisionId: String(picked ?? ''), plantSiteIds: [] })
                  }
                />
              )}
            />
          </Grid>

          {/* Plant Site (다중 + ALL) — division 하위 PlantCell (서버 @divisionId cascade). */}
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
                  limitTags={1}
                  sortBy='label'
                  value={sc.plantSiteIds.join(',')}
                  options={plantSiteOptions}
                  onChange={(_, picked) =>
                    set({
                      plantSiteIds: String(picked ?? '')
                        .split(',')
                        .filter(v => v && v !== 'ALL'),
                    })
                  }
                />
              )}
            />
          </Grid>

          {/* Material — 입력 + 돋보기(SSP0025 전용 ItemByDivisionModal, ITEM 모드), 다건(콤마). design 02 §4.6. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00021', { defaultValue: 'Material' })}
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

          {/* Nick Name — 단일 입력(직접입력, design 02 §1 #5). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00767', { defaultValue: 'Nick Name' })}
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

          {/* Model — 입력 + 돋보기(SSP0025 전용 ItemByDivisionModal, MODEL 모드), 다건(콤마). design 02 §4.6. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00669', { defaultValue: 'Model' })}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
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
