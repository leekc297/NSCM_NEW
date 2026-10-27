import { useEffect, useRef } from 'react';

import type { ComboResponse } from '@foundation/models';
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useMessageStore } from '@shared/stores';

import { COMBO, LBL, MENU_ID, MSG } from '../shipment-semi-dept-day.constants';
import { useShipmentSemiDeptDayStore } from '../useShipmentSemiDeptDayStore';

interface Props {
  onSearch: () => void;
}

interface Option {
  label: string;
  value: string;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const toOptions = (rows: ComboResponse[] | undefined): Option[] =>
  (rows ?? []).map(r => ({ label: str(r.NAME) || str(r.CODE), value: str(r.CODE) }));

// design 02 (02_search-combo.md) 조회조건 1단 3필드(좌->우, 동일 y=12행):
//   Division*(다중 체크리스트 Division_SCP, mnuId 필수·EE 미제외) / Model(단일 텍스트 prefix, 팝업 없음) /
//   Valid(단일 드롭다운 YesOrNo + ALL). cascade 없음. 기본포커스 = Division. 3필드(2단 미만)라 extraConditions 미배선(#52).
export const ShipmentSemiDeptDayForm = ({ onSearch }: Props) => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const sc = useShipmentSemiDeptDayStore(s => s.searchCondition);
  const set = useShipmentSemiDeptDayStore(s => s.setSearchCondition);
  const openSearchArea = useShipmentSemiDeptDayStore(s => s.openSearchArea);
  const setDivisionAuth = useShipmentSemiDeptDayStore(s => s.setDivisionAuth);
  const resetDivisionAuth = useShipmentSemiDeptDayStore(s => s.resetDivisionAuth);
  const divisionAuthLoaded = useShipmentSemiDeptDayStore(s => s.divisionAuthLoaded);

  // Division = MyDivisionInEE (AS-IS cs:42 실측, 권한게이트+EE 미제외). mnuId='SCP0033' 필수 — 미전달 시 권한군 ALL.
  //   Valid = YesOrNo (파라미터 없음). 값 raw, 인용은 getCombo funnel(nscm-patterns §3.3).
  const [divisions, validYn] = useTabComboQueries({
    filters: [{ comboId: COMBO.DIVISION, mnuId: MENU_ID }, COMBO.VALID],
  });

  const divisionOptions = toOptions(divisions);
  const validOptions = toOptions(validYn);

  // L1 Division 권한 게이트(design 01 §2 L1 — AS-IS SetDivisionAuthCheck cs:128~129): 권한 division 0건이면
  //   MSG00667("No authority assigned.") alert + 조회영역 3컨트롤 disable. 콤보 로드 완료(divisions !== undefined)
  //   후에만 판정(로딩 깜빡임 방지). 신규행/팝업 Division 미선택 안내(MSG00097)와 용도 분리(iter-2 G8, hook #114).
  const noDivisionAuth = divisions !== undefined && divisionOptions.length === 0;
  const alertedRef = useRef(false);
  useEffect(() => {
    if (noDivisionAuth && !alertedRef.current) {
      alertedRef.current = true;
      void setAlert({
        type: 'alert',
        content: t(MSG.NO_DIVISION_AUTH, '_No authority assigned.'),
      });
    }
  }, [noDivisionAuth, setAlert, t]);

  // 권한 division 후보를 store 로 올린다 — 조회 payload 가 미선택일 때 이 목록으로 전개된다(AS-IS 'ALL' 전개
  //   파리티, store.setFilter 주석). 콤보 미도착(undefined) 동안은 reset 상태라 페이지가 조회를 막는다.
  //
  // 주의: reset 과 set 을 반드시 "이 효과 하나"에서만 한다. 페이지(부모) 효과에서 reset 하고 여기(자식)서
  //   set 하면 React 가 자식 효과를 먼저 커밋하므로 순서가 set -> reset 으로 뒤집힌다. 콤보가 캐시에서
  //   즉시 오는 재진입(gcTime 내)에서는 divisions 참조가 그대로라 이 효과가 다시 돌지 않아 조회가 영구히
  //   막힌 채 남는다 — 단일 writer 로 두어 그 경합을 없앤다.
  const divisionCodesKey = divisionOptions.map(o => o.value).join(',');
  useEffect(() => {
    if (divisions === undefined) {
      resetDivisionAuth();
      return;
    }
    setDivisionAuth(divisionCodesKey ? divisionCodesKey.split(',') : []);
  }, [divisions, divisionCodesKey, setDivisionAuth, resetDivisionAuth]);

  // F10(검색조건 초기화) 자가복구. F10 은 store.reset()->set(initState)로 authDivisionIds/divisionAuthLoaded
  //   까지 비우는데(둘 다 MotherStore PRESERVED_ON_CONDITION_RESET 밖), 위 시드 효과의 deps(divisions 참조)는
  //   F10 으로 바뀌지 않아(콤보는 캐시 유지) 재실행되지 않는다 -> 권한 게이트가 닫힌 채 남아 조회(handleSearch
  //   의 !divisionAuthLoaded 가드)가 영구히 막힌다. 콤보가 이미 로드돼 있는데 권한이 비워졌으면(= F10 리셋)
  //   여기서 기본값(권한 division 전체) 상태로 재시드한다. set 만 하고 reset 은 안 하며(위 단일 reset 라이터
  //   불변) divisions 미도착 중에는 guard 로 no-op 라 초기 로드 경합을 만들지 않는다.
  useEffect(() => {
    if (divisions !== undefined && !divisionAuthLoaded) {
      setDivisionAuth(divisionCodesKey ? divisionCodesKey.split(',') : []);
    }
  }, [divisions, divisionCodesKey, divisionAuthLoaded, setDivisionAuth]);

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      isHidden={!openSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* Division* (다중 체크리스트, 기본포커스 — design 02 §1 #1 / 01 §4). LBL00641. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIVISION, '_Div')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  autoFocus
                  multiple
                  allOption
                  useClearIcon
                  disabled={noDivisionAuth}
                  limitTags={1}
                  // 정렬 지정 없음 — Division_SCP 등록 SQL 이 ORDER BY A.ATTRIBUTE1 로 끝나고 AS-IS 도
                  //   UP_FX_GetCommonDataList_SCP 의 ATTRIBUTE1 순서를 그대로 쓴다. 클라에서 label 로 다시
                  //   정렬하면 그 순서가 버려진다.
                  value={sc.divisionIds.join(',')}
                  options={divisionOptions}
                  onChange={(_, picked) =>
                    set({
                      divisionIds: String(picked ?? '')
                        .split(',')
                        .filter(v => v && v !== 'ALL'),
                    })
                  }
                />
              )}
            />
          </Grid>

          {/* Model (단일 텍스트 직접입력, 팝업 없음 — design 02 §1 #2). prefix 검색. LBL00669(라벨 "Model", 키 ITEM_ID). */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.MODEL, '_Model')}
              labelAlign='right'
              render={() => (
                <InputField
                  fullWidth
                  disabled={noDivisionAuth}
                  value={sc.itemId}
                  onChange={e => set({ itemId: e.target.value })}
                  onKeyDown={e => e.key === 'Enter' && onSearch()}
                />
              )}
            />
          </Grid>

          {/* Valid (단일 드롭다운 YesOrNo + ALL 빈값=전체 — design 02 §1 #3). LBL00639. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.VALID, '_Valid')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  disabled={noDivisionAuth}
                  value={sc.valid}
                  options={validOptions}
                  onChange={(_, picked) => set({ valid: String(picked ?? '') })}
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
