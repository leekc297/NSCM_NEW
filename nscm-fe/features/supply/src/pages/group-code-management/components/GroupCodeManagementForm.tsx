import { useEffect, useMemo } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import { LBL, SEARCH_COMBO } from '../group-code-management.constants';
import { useGroupCodeManagementStore } from '../useGroupCodeManagementStore';

interface Props {
  onSearch: () => void;
  // Model/Nickname 돋보기 → MaterialByDivisionModal 오픈(모달은 페이지가 소유).
  onItemSearch: () => void;
}

// 조회조건(02_search-combo.md §1 정본, 좌→우 8실조건):
//   Division*(Division_SCP_NoEE 단일 필수, 권한+EE제외 내장, cascade 최상위) /
//   Operation(OperationForPlanDivisionId1_SCP_ALL 다중, 파라미터 없이 전량 로드 후
//     row.DIVISION_ID===divisionId 클라 필터 — 재조회 아님, useCascadeFields 사용 금지) /
//   Model / NickName(UsrMultiLineEditor 자유입력 다중행 텍스트 — SP 파라미터 그대로 전달) /
//   Model Attribute(FCST/Production/Active/BOM 4 Y/N 플래그를 묶은 단일 select — 사용자 요청
//     2026-10-07. 선택값만 'Y', 나머지 'N'. ALL(미선택) 시 전부 'N'. SP 는 여전히 4 Y/N 각각 수신).
export const GroupCodeManagementForm = ({ onSearch, onItemSearch }: Props) => {
  const { t } = useTranslation();

  const sc = useGroupCodeManagementStore(s => s.searchCondition);
  const set = useGroupCodeManagementStore(s => s.setSearchCondition);
  const setDivision = useGroupCodeManagementStore(s => s.setDivision);
  const openSearchArea = useGroupCodeManagementStore(s => s.openSearchArea);

  const tabId = useTabid();

  // Model ATTRIBUTE 다중 select — AS-IS 독립 체크박스 4종(FCST/Production/Active/BOM)을 하나의
  //   다중선택 콤보로 묶는다. 옵션값은 store 의 4 boolean 과 1:1, 여러 개 동시 선택 가능(독립 플래그).
  //   setFilter 가 각 boolean 을 개별 Y/N 으로 SP 에 전달(상호배타 아님).
  const attrOptions = useMemo(
    () => [
      { label: t(LBL.FCST, '_FCST'), value: 'FCST' },
      { label: t(LBL.PRODUCTION, '_Production'), value: 'PRODUCTION' },
      { label: t(LBL.ACTIVE, '_Active'), value: 'ACTIVE' },
      { label: t(LBL.BOM, '_BOM'), value: 'BOM' },
    ],
    [t]
  );
  // 4 boolean -> 선택된 값들의 콤마 결합(옵션 정의 순서 유지). CustomDropdown multiple value 규약.
  const attrValue = [
    sc.checkFcst ? 'FCST' : '',
    sc.checkProduction ? 'PRODUCTION' : '',
    sc.checkActive ? 'ACTIVE' : '',
    sc.checkBom ? 'BOM' : '',
  ]
    .filter(Boolean)
    .join(',');

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

  // Division 기본값 교정 — 현재값이 옵션에 없으면 목록 첫 항목으로(AS-IS cboDivision addAll=false,
  //   명시 선택 없음 → 첫 항목 기본선택, design 02 §2). session.div/'40' 리터럴을 쓰지 않는다 —
  //   AS-IS 는 세션값을 division 기본으로 쓰지 않고 권한목록 첫 항목(ATTRIBUTE1 정렬 최상위)을 쓴다.
  useEffect(() => {
    if (sc.divisionId && divisionOptions.some(o => o.value === sc.divisionId)) return;
    const first = String(divisionOptions[0]?.value ?? '');
    if (first) setDivision(first);
  }, [divisionOptions, sc.divisionId, setDivision]);

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={noDivisionAuth ? undefined : onSearch}
      conditions={
        <>
          {/* Division* — 단일 필수, ALL 없음. 변경 = Div 제외 조건 전부 초기화 + 그리드 초기화(setDivision,
              TO-BE 공통 요건). 편집중(dirty)이면 MSG00704 confirm 후에만 실행, 취소 시 controlled 콤보가
              이전 Div 로 복귀(commit 51d4e9fa 패턴). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Div')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  disabled={noDivisionAuth}
                  value={sc.divisionId}
                  options={divisionOptions}
                  onChange={(_, option) => {
                    const v = String(option ?? '');
                    void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                      if (ok) setDivision(v);
                    });
                  }}
                />
              )}
            />
          </Grid>

          {/* Operation — 다중선택, 선택 Division 하위만(클라 필터). 미선택=전체('ALL', setFilter 에서 정규화). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.OPERATION, '_Operation')}
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

          {/* Model/Nickname — 기존 Model+NickName 두 조건을 MaterialByDivisionModal(COM0013) 한 필드로
              통합(사용자 지시 2026-10-07, 타 화면 공통 패턴 outsourcing-capacity/scp-bom). 팝업 선택 시
              model(ITEM_ID)+nickName(NICK_NAME)을 함께 채운다(GET SP p_model_id/p_nick_name 둘 다 유지).
              표시는 model. 직접 타이핑 = model 수동 입력 + nickName 잔재 제거. 모달은 페이지가 소유. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL_NICKNAME, '_Model/Nickname')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  className={commonStyles.popupSearchField}
                  disabled={noDivisionAuth}
                  value={sc.model}
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
                  onChange={event => set({ model: event.target.value, nickName: '' })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* Model Attribute — FCST/Production/Active/BOM 4 Y/N 플래그를 묶은 단일 select.
              allOption=기본 'ALL'(미선택, value ''). ALL 선택/미선택 시 4종 전부 false(=전부 'N').
              SP 계약(4 Y/N)은 그대로 유지. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL_ATTRIBUTE, '_Model Attribute')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={2}
                  disabled={noDivisionAuth}
                  value={attrValue}
                  options={attrOptions}
                  onChange={(_, picked) => {
                    // CustomDropdown 전체해제/전체선택 = 'ALL' sentinel → 빈 선택으로 정규화(전부 false).
                    const sel = new Set(
                      String(picked ?? '')
                        .split(',')
                        .filter(v => v !== '' && v.toUpperCase() !== 'ALL')
                    );
                    set({
                      checkFcst: sel.has('FCST'),
                      checkProduction: sel.has('PRODUCTION'),
                      checkActive: sel.has('ACTIVE'),
                      checkBom: sel.has('BOM'),
                    });
                  }}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
