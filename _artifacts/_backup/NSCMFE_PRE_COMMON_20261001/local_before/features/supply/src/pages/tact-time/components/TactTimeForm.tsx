import { useEffect } from 'react';

import type { ComboParam, ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import {
  COMBO,
  OPERATION_GROUP_LOOKUP,
  PACKER_PLANT_DIVISIONS,
  TACT_MODE,
} from '../tact-time.constants';
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
//   콤보 본문 등록 확인(2026-09-25 ora.py 실측, SCM_ADM_CMBO_SQL_M). 잘못된 id 는 조용히 0행.
export const TactTimeForm = ({ onSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useTactTimeStore(s => s.searchCondition);
  const set = useTactTimeStore(s => s.setSearchCondition);
  const openSearchArea = useTactTimeStore(s => s.openSearchArea);

  const isPlant = sc.mode === TACT_MODE.PLANT;

  // Packer Plant Site = PlantByDivisionOperOsp3_SCP 고정 파라미터로 전량 조회
  //   (@divisionId=40,81,82 / @operationGroup=P / @param3=Y — OSP·전극 제외). 값은 raw, 인용은 getCombo funnel.
  const plantSitePackerFilter: ComboParam = {
    comboId: COMBO.PLANT_SITE_PACKER,
    divisionId: PACKER_PLANT_DIVISIONS,
    operationGroup: 'P',
    param3: 'Y',
  };

  // 콤보 — 전량 조회 후 client-side cascade 필터(AS-IS CommonAll + DBUtils.Filter, design 02 §3).
  const [divisions, plantSites, lines] = useTabComboQueries({
    filters: [
      COMBO.DIVISION,
      isPlant ? COMBO.PLANT_SITE_PLANT : plantSitePackerFilter,
      isPlant ? COMBO.LINE_PLANT : COMBO.LINE_PACKER,
    ],
  });
  const [operationGroups] = useTabLookupQueries({ filters: [OPERATION_GROUP_LOOKUP] });

  // AS-IS GetDivisionESS 재현 — Division_SCP 전량 중 ESS 사업부(ATTRIBUTE3='82')만 노출
  //   (combo-semantic-parity-no-name-reuse: 프로시저 이관 SQL 엔 소스 필터가 없어 화면에서 재현).
  const divisionOptions = toOptions(
    (divisions ?? []).filter(r => str(r.ATTRIBUTE3) === '82')
  );

  // division 기본값 = 첫 옵션 자동 선택. store 초기값은 session.div(비어있지 않음)이라 옵션 목록에
  //   없을 수 있는데(ESS 단일 옵션 82만 노출), 그러면 드롭다운이 빈칸으로 뜬다 — 현재 값이 옵션에
  //   없으면 첫 옵션으로 교정한다(유효한 사용자 선택은 유지). 실질 82 고정.
  const firstDivision = divisionOptions[0]?.value ?? '';
  const hasCurrentDivision = divisionOptions.some(o => o.value === sc.divisionId);
  useEffect(() => {
    if (firstDivision && !hasCurrentDivision) {
      set({ divisionId: firstDivision, plantSiteIds: [], lineIds: [] });
    }
  }, [firstDivision, hasCurrentDivision, set]);
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
              // CustomDropdown 은 전체해제/전체선택을 'ALL' sentinel(= 필터 없음, 빈 값과 동치)로
              //   내보낸다. 'ALL' 을 실제 코드로 담으면 하위 cascade(예: line by plantSite)가
              //   'ALL' 을 사이트 코드로 매칭해 0건이 된다(Plant 선택 후 해제 시 Line 빈값 사고).
              //   빈 배열로 정규화 — SearchFields 표준 필터와 동일 규약.
              onPick(String(picked ?? '').split(',').filter(v => v !== '' && v.toUpperCase() !== 'ALL'))
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
