import { useEffect } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import { COMBO, LBL, LT_OPERATION_LOOKUP, VALID_ALL } from '../operation-lt.constants';
import { useOperationLTStore } from '../useOperationLTStore';
import { buildSearchPlantSiteOptions, toPlantSiteSource } from '../utils/operation-lt.plantSite';

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

// 다중해제/전체선택 'ALL' sentinel 정규화(= 필터 없음, 빈 배열과 동치) — SearchFields 표준 규약.
//   str() 경유(no-base-to-string) — picked 는 콤마 문자열, 비문자열은 공백 처리.
const pickMulti = (picked: unknown): string[] =>
  str(picked)
    .split(',')
    .filter(v => v !== '' && v.toUpperCase() !== 'ALL');

// design 02 조회조건 5(6컨트롤): LT Operation(다중) / Division(다중, EE제외) / Plant Site(다중, cascade) /
//   Material(텍스트+MaterialByDivisionModal) / Site Item Valid(단일+ALL). 5필드 ≤6 -> 2단 내 수용, 접기 불필요(§5).
export const OperationLTForm = ({ onSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useOperationLTStore(s => s.searchCondition);
  const set = useOperationLTStore(s => s.setSearchCondition);
  const setDivision = useOperationLTStore(s => s.setDivision);
  const clearFilters = useOperationLTStore(s => s.clearFilters);
  const openSearchArea = useOperationLTStore(s => s.openSearchArea);

  const tabId = useTabid();

  // 콤보 전량 조회 후 client-side cascade 필터(AS-IS CommonAll + DBUtils.Filter, design 02 §2-3/§3).
  const [divisions, plantNonOsp, plantOsp, validYn] = useTabComboQueries({
    filters: [COMBO.DIVISION, COMBO.PLANT_NONOSP, COMBO.PLANT_OSP, COMBO.VALID],
  });
  const [ltOperations] = useTabLookupQueries({ filters: [LT_OPERATION_LOOKUP] });

  // Division — AS-IS GetDivisionWithoutEE 재현: ATTRIBUTE3<>'EE'(전극 제외) 클라 필터
  //   (combo-semantic-parity: Division_SCP CMBO WHERE 에 이 필터 없음, design 02 §2-1/§7#1).
  const divisionOptions = toOptions(
    (divisions ?? []).filter(r => str(r.ATTRIBUTE3) !== 'EE')
  );
  // LT Operation — lookup 노출분(useTabLookupQueries 는 VALID_YN='Y' 만 반환, 4건).
  const ltOperationOptions: Option[] = (ltOperations ?? []).map(r => {
    const rec = r as Record<string, unknown>;
    return { label: str(rec.NAME) || str(rec.CODE), value: str(rec.CODE) };
  });
  // Plant Site — LT Operation 값별 OPERATION_GROUP 좁힘 + division 필터 (design 02 §3).
  const plantSiteOptions = buildSearchPlantSiteOptions(
    toPlantSiteSource(plantNonOsp),
    toPlantSiteSource(plantOsp),
    sc.divisionIds,
    sc.ltOperationIds
  );
  // Site Item Valid — YesOrNo + ALL 선두, 기본 ALL (design 02 §2-5).
  const validOptions: Option[] = [{ label: 'ALL', value: VALID_ALL }, ...toOptions(validYn)];

  // 콤보 기본값 = 각 콤보 첫 항목 (AS-IS UsrCombo DataSource 바인드가 index 0 을 자동선택하는 동작 재현,
  //   SCP0037_OperationLT.cs InitControls setListBox). Division=첫 옵션(권한 division ATTRIBUTE1 순),
  //   LT Operation=첫 옵션(lookup DISPLAY_SEQ 순=SLITTING). 미선택(값이 옵션에 없음) 상태일 때만 적용.
  //
  //   필수: ref 가드가 아니라 "현재값이 옵션에 있는가(hasX)" 를 deps 에 둔다 — F10(Reset Condition)이
  //     값(sc.*)만 비우고 옵션은 그대로 두므로, ref/옵션개수 deps 로는 리셋을 감지 못 해 재셋팅이 안 된다.
  //     hasX 가 true->false 로 바뀌면 effect 가 재발화해 첫 항목을 다시 넣는다
  //     ([[f10-reset-default-reselect-needs-has-value-flag-in-deps]], 형제 SCP0031/SCP0100 공통 패턴).
  const firstDivision = divisionOptions[0]?.value ?? '';
  const hasDivision = divisionOptions.some(o => o.value === sc.divisionIds[0]);
  const firstLtOp = ltOperationOptions[0]?.value ?? '';
  const hasLtOp = ltOperationOptions.some(o => o.value === sc.ltOperationIds[0]);
  useEffect(() => {
    if (firstDivision && !hasDivision) set({ divisionIds: [firstDivision] });
  }, [firstDivision, hasDivision, set]);
  useEffect(() => {
    if (firstLtOp && !hasLtOp) set({ ltOperationIds: [firstLtOp] });
  }, [firstLtOp, hasLtOp, set]);

  // 단일 선택 콤보 (Division·LT Operation) — AS-IS setListBox addAll=false (design 02 §4):
  //   ALL 옵션 없음. 미선택(clear) 시 SP 파라미터는 'ALL'(무필터)로 전달(store joinOrAll).
  const single = (
    labelCode: string,
    labelEn: string,
    value: string,
    options: Option[],
    onPick: (code: string) => void,
    clearable = true
  ) => (
    <Grid size={3}>
      <FormItem
        className={commonStyles.formItem}
        label={t(labelCode, labelEn)}
        labelAlign='right'
        render={() => (
          <CustomDropdown
            useClearIcon={clearable}
            sortBy='label'
            value={value}
            options={options}
            onChange={(_, picked) => onPick(str(picked))}
          />
        )}
      />
    </Grid>
  );

  // 다중 선택 콤보 (Plant Site) — cascade 하위, ALL 옵션 유지.
  const multi = (
    labelCode: string,
    labelEn: string,
    value: string[],
    options: Option[],
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
            onChange={(_, picked) => onPick(pickMulti(picked))}
          />
        )}
      />
    </Grid>
  );

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* LT Operation (단일, cascade 트리거 + INV_FLAG visible 트리거 — design 02 §3 / 01 R6).
              필수값: clear(X) 미노출 + 빈 선택 무시(사용자 지시 2026-10-12). */}
          {single(
            LBL.LT_OPERATION,
            '_Operation',
            sc.ltOperationIds[0] ?? '',
            ltOperationOptions,
            code => {
              // 빈 code(선택 해제)는 무시한다 — Operation 은 항상 하나 선택된 상태를 유지한다.
              if (!code) return;
              // LT Operation 변경 = Plant Site cascade 초기화 + 그리드 비움 (design 02 §3 R7,
              //   AS-IS ClearDataSource cs L220~223 / nscm-patterns §5-5 — 재조회 전 stale 방지)
              set({ ltOperationIds: [code], plantSiteIds: [] });
              clearFilters();
            },
            false
          )}
          {/* Division (단일, cascade 트리거, EE 제외 — design 02 §2-1).
              Division 변경 = Division 제외 검색조건 전부 초기화 + 그리드 비움(store setDivision, TO-BE 공통 요건).
              편집중(dirty)이면 MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가 이전 Div 로 복귀(commit 51d4e9fa 패턴). */}
          {single(LBL.DIVISION, '_Div', sc.divisionIds[0] ?? '', divisionOptions, code => {
            void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
              if (ok) setDivision(code);
            });
          })}
          {/* Plant Site (다중, cascade 하위 — design 02 §2-3). ALL 옵션 유지 */}
          {multi(LBL.PLANT_SITE, '_Plant Site', sc.plantSiteIds, plantSiteOptions, ids =>
            set({ plantSiteIds: ids })
          )}
          {/* Material — 텍스트 + 돋보기(MaterialByDivisionModal COM0013, design 02 §4.6) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MATERIAL, '_Material')}
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
          {/* Site Item Valid (단일 + ALL, 기본 ALL — design 02 §2-5) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.SITE_ITEM_VALID, '_Active')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={sc.validYn}
                  options={validOptions}
                  onChange={(_, picked) => set({ validYn: String(picked ?? VALID_ALL) })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
