import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import { COMBO, LBL } from '../constraint-mgmt.constants';
import { useConstraintMgmtStore } from '../useConstraintMgmtStore';

interface ConstraintMgmtFormProps {
  onSearch: () => void;
}

/**
 * 조회조건 3건 (design 02 §1) — 좌->우 Lookup Type / Plan Group / Active.
 * 3필드 < 6 이라 extraConditions(2단 접기)는 쓰지 않는다. 필수 조회조건 0건이고
 * cascade 도 0건이라 useCascadeFields 도 쓰지 않는다(조건 3개가 상호 독립).
 */
export const ConstraintMgmtForm = ({ onSearch }: ConstraintMgmtFormProps) => {
  const { t } = useTranslation();

  const searchParams = useConstraintMgmtStore(state => state.searchParams);
  const setSearchParams = useConstraintMgmtStore(state => state.setSearchParams);
  const isOpenSearchArea = useConstraintMgmtStore(state => state.isOpenSearchArea);

  const [planGroups, yesOrNo] = useTabComboQueries({
    filters: [COMBO.PLAN_GROUP, COMBO.YES_OR_NO],
  });

  return (
    <SearchArea
      searchButtonLabel={t(LBL.SEARCH, '_Search(F5)')}
      isHidden={!isOpenSearchArea}
      onSearch={onSearch}
      conditions={
        <>
          {/* 1. Lookup Type — 자유 입력. SP 가 LIKE '%'||UPPER(v)||'%' 로 받는 부분일치다.
                빈 값이 곧 전건이므로 'ALL' 로 치환하면 리터럴 매칭이 되어 0행이 된다. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.LOOKUP_TYPE, '_Lookup Type')}
              labelAlign='right'
              render={() => (
                <InputField
                  // 화면 오픈 시 첫 포커스 — AS-IS 는 실사용 컨트롤 최소 tabIndex 가
                  // txtLookupType(4) 이라 열자마자 여기에 커서가 들어간다.
                  autoFocus
                  fullWidth
                  value={searchParams.lookupType}
                  onChange={event =>
                    setSearchParams({ lookupType: String(event.target.value ?? '') })
                  }
                />
              )}
            />
          </Grid>
          {/* 2. Plan Group — AS-IS UsrCheckedList2(내장 ALL 체크박스 + 검색박스 + 다중 체크) 등가.
                값 축이 CODE 가 아니라 NAME 이다: 이 값은 SP 로 나가지 않고 Sub 결과 필터의
                비교값으로만 쓰이는데, 원장 컬럼에 들어 있는 값이 OPMZ_PLAN_GR_NAME 이다.
                CODE 로 담으면 매칭 0건이 되어 비관리자 그리드가 통째로 빈다. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.PLAN_GROUP, '_Plan Group')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  value={searchParams.planGroupNames.join(',')}
                  options={
                    planGroups?.map(item => ({
                      label: String(item.NAME ?? ''),
                      value: String(item.NAME ?? ''),
                    })) ?? []
                  }
                  onChange={(_, picked) =>
                    setSearchParams({
                      planGroupNames: String(picked ?? '')
                        .split(',')
                        .filter(value => value !== '' && value.toUpperCase() !== 'ALL'),
                    })
                  }
                />
              )}
            />
          </Grid>
          {/* 3. Active — AS-IS Valid. 명칭만 카탈로그 지시로 개명했다(LBL00639 -> LBL00007).
                후보는 콤보 경유로만 만든다(['Y','N'] 리터럴 배열 금지). ALL 은 allOption 이 얹는다. */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.ACTIVE, '_Active')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  allOption
                  value={searchParams.validYn}
                  options={
                    yesOrNo?.map(item => ({
                      label: String(item.NAME ?? ''),
                      value: String(item.CODE ?? ''),
                    })) ?? []
                  }
                  // 단일 allOption 의 ALL 값은 공용 컴포넌트가 ''(SINGLE_ALL_OPTION.value)로 내보낸다.
                  //   화면 전역(store·handleSearch·setFilters·CustomDropdown singleValue)은 ALL 을
                  //   'ALL' sentinel 로 가정하므로 빈값을 'ALL' 로 정규화해 저장한다. 이렇게 해야
                  //   Condition(F6) 저장 payload 에 validYn='ALL' 이 실려(빈값은 personalizeCondition
                  //   이 drop) 저장·복원이 되고, 드롭다운도 ALL 로 다시 표시된다. Yes/No 콤보는
                  //   'Y'/'N' 만 내보내 ''가 ALL 외 경로로 오지 않는다.
                  onChange={(_, option) =>
                    setSearchParams({ validYn: String(option ?? '') || 'ALL' })
                  }
                />
              )}
            />
          </Grid>
        </>
      }
    />
  );
};
