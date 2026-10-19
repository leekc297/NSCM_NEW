import { useEffect, useMemo } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Checkbox, FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useSessionStore } from '@shared/stores';

import { SEARCH_COMBO, SEARCH_LABEL } from '../group-code-management.constants';
import { useGroupCodeManagementStore } from '../useGroupCodeManagementStore';

interface Props {
  onSearch: () => void;
}

// 조회조건(02_search-combo.md §1 정본, 좌→우 8실조건):
//   Division*(Division_SCP_NoEE 단일 필수, 권한+EE제외 내장, cascade 최상위) /
//   Operation(OperationForPlanDivisionId1_SCP_ALL 다중, 파라미터 없이 전량 로드 후
//     row.DIVISION_ID===divisionId 클라 필터 — 재조회 아님, useCascadeFields 사용 금지) /
//   Model / NickName(UsrMultiLineEditor 자유입력 다중행 텍스트 — SP 파라미터 그대로 전달) /
//   FCST / Production / Active / BOM (Y/N 체크박스, 초기 전부 false, Active/BOM 기본 숨김).
export const GroupCodeManagementForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useGroupCodeManagementStore(s => s.searchCondition);
  const set = useGroupCodeManagementStore(s => s.setSearchCondition);
  const openSearchArea = useGroupCodeManagementStore(s => s.openSearchArea);

  // Division 소스풀 — Division_SCP_NoEE 는 권한 auth + ATTRIBUTE3<>'EE' 를 CMBO SQL 에 내장(§2 #1).
  //   FE 후처리 제외 불필요(Division_SCP + BLUtils 조합과 다름) — 콤보 결과 그대로 사용.
  const [divisions] = useTabComboQueries({ filters: [SEARCH_COMBO.division] });
  const noDivisionAuth = divisions !== undefined && divisions.length === 0;

  const divisionOptions = useMemo(
    () => (divisions ?? []).map(row => ({ label: row.NAME, value: row.CODE })),
    [divisions]
  );

  // Operation 전량 로드 — 파라미터 없이 1회 조회 후 선택 Division 의 DIVISION_ID 로 클라 필터(§2 #2, cascade=필터형).
  //   OperationForPlanDivisionId1_SCP_ALL 는 DIVISION_ID 를 반환한다(_SCP 버전은 미반환 — 사용 금지).
  const [operationsRaw] = useTabComboQueries({ filters: [SEARCH_COMBO.operation] });
  const operationOptions = useMemo(
    () =>
      (operationsRaw ?? [])
        .filter(row => !sc.divisionId || String(row.DIVISION_ID ?? '') === sc.divisionId)
        .map(row => ({ label: row.NAME, value: row.CODE })),
    [operationsRaw, sc.divisionId]
  );

  // Division 기본값 교정 — 권한목록에 session.div 있으면 그 값, 없으면 첫 행(AS-IS 단일 강제선택).
  const session = useSessionStore(s => s.session);
  useEffect(() => {
    if (sc.divisionId && divisionOptions.some(o => o.value === sc.divisionId)) return;
    const codes = divisionOptions.map(o => String(o.value ?? '')).filter(Boolean);
    if (codes.length === 0) return;
    const sessionDiv = String(session.div ?? '');
    set({ divisionId: codes.includes(sessionDiv) ? sessionDiv : codes[0] });
  }, [divisionOptions, sc.divisionId, session.div, set]);

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', { defaultValue: '_Search' })}
      isHidden={!openSearchArea}
      onSearch={noDivisionAuth ? undefined : onSearch}
      conditions={
        <>
          {/* Division* — 단일 필수, ALL 없음. 변경 시 setSearchCondition 이 operation 초기화 + 컬럼 재조회(§1). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(SEARCH_LABEL.division, { defaultValue: '_Division' })}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  disabled={noDivisionAuth}
                  value={sc.divisionId}
                  options={divisionOptions}
                  onChange={(_, option) => set({ divisionId: String(option ?? '') })}
                />
              )}
            />
          </Grid>

          {/* Operation — 다중선택, 선택 Division 하위만(클라 필터). 미선택=전체('ALL', setFilter 에서 정규화). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(SEARCH_LABEL.operation, { defaultValue: '_Operation' })}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  sortBy='label'
                  disabled={noDivisionAuth}
                  value={sc.operationIds.join(',')}
                  options={operationOptions}
                  onChange={(_, picked) =>
                    set({
                      operationIds: String(picked ?? '')
                        .split(',')
                        .filter(v => v !== '' && v.toUpperCase() !== 'ALL'),
                    })
                  }
                />
              )}
            />
          </Grid>

          {/* Model — UsrMultiLineEditor 자유입력 다중행(개행=여러 값). p_model_id 로 그대로 전달(§2-3). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(SEARCH_LABEL.model, { defaultValue: '_Model' })}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  multiline
                  minRows={1}
                  maxRows={4}
                  disabled={noDivisionAuth}
                  value={sc.model}
                  onChange={event => set({ model: event.target.value })}
                />
              )}
            />
          </Grid>

          {/* NickName — UsrMultiLineEditor 자유입력 다중행. 라벨 LBL 은 확인필요 #1 미해소 → defaultValue 만.
              주의: 임시 LBL 하드코딩 금지(convert-core §2.3) — 해소 후 SEARCH_LABEL 에 추가. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('', { defaultValue: 'NickName' })}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  multiline
                  minRows={1}
                  maxRows={4}
                  disabled={noDivisionAuth}
                  value={sc.nickName}
                  onChange={event => set({ nickName: event.target.value })}
                />
              )}
            />
          </Grid>

          {/* FCST / Production — Y/N 체크박스(초기 false). AS-IS chkFCST/chkProduction(§1). */}
          <Grid size={3} className={commonStyles.customGrid}>
            <div className={commonStyles.customCheckbox}>
              <Checkbox
                labelText={t(SEARCH_LABEL.checkFcst, { defaultValue: '_FCST' })}
                checked={sc.checkFcst}
                disabled={noDivisionAuth}
                onChange={checked => set({ checkFcst: checked })}
              />
            </div>
          </Grid>
          <Grid size={3} className={commonStyles.customGrid}>
            <div className={commonStyles.customCheckbox}>
              <Checkbox
                labelText={t(SEARCH_LABEL.checkProduction, { defaultValue: '_Production' })}
                checked={sc.checkProduction}
                disabled={noDivisionAuth}
                onChange={checked => set({ checkProduction: checked })}
              />
            </div>
          </Grid>

          {/* Active / BOM — AS-IS 기본 숨김(chkActive.Visible=false / chkBOM.Visible=false, §1).
              파리티: 화면에 노출하지 않는다(렌더 자체 생략). 필터값은 초기 false 로 유지. */}
        </>
      }
    />
  );
};
