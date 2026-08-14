import { PeriodField } from 'features/master/src/components';
import { useMemo } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { LOOKUP } from '../project-reg.constants';
import { useProjectRegStore } from '../useProjectRegStore';

interface ProjectRegFormProps {
  onSearch: () => void;
  // ⭐ Division 변경 = 고객 ALL reset + 양 탭 그리드 비움 + CRUD pending reset + 메타 재조회
  //   (memory feedback_division_change_grid_reset — 자동 재조회 금지, 재조회는 Search 버튼만)
  onDivisionChange: () => void;
}

// SDM1010 조회조건 (hook #112/#94/#120 — 1단 4개 · 높이 36px · Search 라벨 = LBL00112 고정):
//   ⭐ TAB2(나의 프로젝트 현황) 전용 — TAB1 에서는 비노출 (사용자 지시 2026-08-13. 렌더 게이트 = ProjectReg.tsx).
//     사업부 기본값 보정도 페이지 레벨(ProjectReg)로 이동 — 본 폼은 표시·입력만 담당.
//   ⭐ 신본 §5 = `= 값 OR 'ALL'` 등호 매칭 (콤마 다중 불가) → 고객/나의 권한/등록 상태는
//     **단일 선택 + 'ALL' 옵션** (전체선택 = 문자열 'ALL' — 빈값 금지, 계약 결정 5).
//   Row1: 사업부*(MyDivision Single — 첫 값 기본) / 고객(SpmsEndCustomer — §5 SITE 도메인 정합 + ALL) /
//         나의 권한(lookup SPMS_DPJT_AUTH_TYPE + ALL) / 등록 상태(lookup SPMS_DPJT_REG_STATUS + ALL)
//   Row2: 등록 완료일(From~To — 기본값 = period 시트 §15 GET_PERIOD 수신. 둘 다 비우면 전체 조회)
export const ProjectRegForm = ({ onSearch, onDivisionChange }: ProjectRegFormProps) => {
  const { t } = useTranslation();

  const sc = useProjectRegStore(s => s.searchCondition);
  const set = useProjectRegStore(s => s.setSearchCondition);
  const openSearchArea = useProjectRegStore(s => s.openSearchArea);

  const [divisions] = useTabComboQueries({ filters: ['MyDivision'] });
  // ⭐ 고객 콤보 — division 종속. BE makeComboQuery 는 raw 치환이라 **따옴표 포함 전달** 계약
  //   (미따옴표 = 식별자 해석 ORA 오류. division 변경 = 쿼리키 변경 = 자동 재조회).
  const [endCustomers] = useTabComboQueries({
    // ⭐ §5 고객 필터 = SPMS_PROJECT_MST.END_CUSTOMER 등호 매칭 — 도메인은 SCM_MST_SITE(div,END_CUSTOMER).
    //   공용 EndCustomer/EndCustomerByDivision 은 div40 에서 PROJECT_CODE 반환(도메인 불일치 실사고) → 전용 콤보
    filters: [{ comboId: 'SpmsEndCustomer', divisionId: `'${sc.divisionId}'` }],
  });
  const [authTypes, regStatuses] = useTabLookupQueries({
    filters: [{ lookupType: LOOKUP.AUTH_TYPE }, { lookupType: LOOKUP.REG_STATUS }],
  });

  const divisionOptions = useMemo(
    () =>
      (divisions ?? []).map(item => ({ label: String(item.NAME), value: String(item.CODE) })),
    [divisions]
  );

  // 'ALL' 옵션 선두 부착 — §5 전체선택 센티널 (라벨은 공용 표기 'ALL')
  const toOptionsWithAll = (rows: Array<Record<string, string>> | undefined) => [
    { label: 'ALL', value: 'ALL' },
    ...(rows ?? []).map(r => ({ label: String(r.NAME ?? r.CODE ?? ''), value: String(r.CODE ?? '') })),
  ];

  return (
    <SearchArea
      isHidden={!openSearchArea}
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={onSearch}
      conditions={
        <>
          {/* Row1 — 사업부* / 고객 / 나의 권한 / 등록 상태 */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00001', '_Div.')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={sc.divisionId}
                  options={divisionOptions}
                  onChange={(_, option) => {
                    // 고객은 division 종속 — 변경 시 ALL reset (AS-IS 파리티)
                    set({ divisionId: String(option ?? ''), endCustomer: 'ALL' });
                    onDivisionChange();
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00643', '_Customer')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={sc.endCustomer}
                  options={toOptionsWithAll(endCustomers as never)}
                  onChange={(_, option) => set({ endCustomer: String(option ?? 'ALL') || 'ALL' })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00855', '_My Auth')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={sc.dpjtAuthType}
                  options={toOptionsWithAll(authTypes as never)}
                  onChange={(_, option) => set({ dpjtAuthType: String(option ?? 'ALL') || 'ALL' })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t('LBL00856', '_Reg. Status')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  value={sc.dpjtRegStatus}
                  options={toOptionsWithAll(regStatuses as never)}
                  onChange={(_, option) => set({ dpjtRegStatus: String(option ?? 'ALL') || 'ALL' })}
                />
              )}
            />
          </Grid>

          {/* Row2 — 등록 완료일 (표준 PeriodField — yyyymmdd. 기본값 = period 시트 §15.
              둘 다 비우면 전체(REG_COMP_DATE NULL 미완료 포함) — 한쪽만 빈 값은 validate 차단) */}
          <PeriodField
            gridSize={6}
            label={t('LBL00857', '_Reg. Complete Date')}
            start={sc.regCompDateFr}
            end={sc.regCompDateTo}
            onChange={(start, end) => set({ regCompDateFr: start, regCompDateTo: end })}
          />
        </>
      }
    />
  );
};
