import { PeriodField } from 'features/master/src/components';
import { useMemo } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries, useTabLookupQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { LBL, LOOKUP } from '../project-master.constants';
import { useProjectMasterStore } from '../useProjectMasterStore';

interface ProjectMasterFormProps {
  hidden: boolean;
  onSearch: () => void;
  // ⭐ Division 변경 (E02/CF-07) = 종속 콤보 reset + 양 탭 그리드 비움 + CRUD pending reset +
  //   컬럼 메타 재조회 (memory feedback_division_change_grid_reset — 자동 재조회 금지, Search 버튼만)
  onDivisionChange: () => void;
}

// SDM5010 조회조건 6종 (hook #112/#94/#120 — 1단 4개 · 높이 36px · Search 라벨 = LBL00112 고정):
//   ⭐ TAB2(프로젝트 Master 관리) 전용 소비 — TAB1 에서는 비노출 (F-3 — 렌더 게이트 = ProjectMaster.tsx.
//     사업부 기본값 보정은 페이지 레벨 — 본 폼은 표시·입력만 담당).
//   Row1: 사업부*(MyDivision Single — 첫 값 기본, LBL00001, CF-01) /
//         고객(EndCustomerByDivision Multi 검색+ALL — 사업부 종속, LBL00643, CF-02) /
//         Cell 유형(lookup SPMS_CELL_TYPE Multi, LBL00046, CF-03 — 설계 원문 비종속 F-17) /
//         Biz Type(DmBizType Multi, LBL00607, CF-04 — 조회조건은 설계서 기재·그리드 셀만 BizTypeByDivision)
//   Row2: 개발 현황(lookup SPMS_DPJT_DEVELOP_STATUS Multi, LBL00863 신규, CF-05) /
//         등록 완료일*(From~To — 기본 M-1~Today, LBL00857, CF-06. PeriodField 표준 — yyyymmdd)
//   멀티 = 빈 배열 = ALL (store setFilter 가 콤마 연결 — UC-06). 계약 ③ LBL 재사용 8 + 신규 1
export const ProjectMasterForm = ({
  hidden,
  onSearch,
  onDivisionChange,
}: ProjectMasterFormProps) => {
  const { t } = useTranslation();

  const sc = useProjectMasterStore(s => s.searchCondition);
  const set = useProjectMasterStore(s => s.setSearchCondition);
  const openSearchArea = useProjectMasterStore(s => s.openSearchArea);

  const [divisions] = useTabComboQueries({ filters: ['MyDivision'] });
  // ⭐ 고객 콤보 — division 종속(CF-02). BE makeComboQuery 는 raw 치환이라 **따옴표 포함 전달** 계약
  //   (미따옴표 = 식별자 해석 ORA 오류. division 변경 = 쿼리키 변경 = 자동 재적재).
  //   Biz Type = DmBizType (무토큰 — 비종속. 그리드 셀 콤보 BizTypeByDivision 과 별개 축)
  const [endCustomers, bizTypes] = useTabComboQueries({
    filters: [{ comboId: 'EndCustomerByDivision', divisionId: `'${sc.divisionId}'` }, 'DmBizType'],
  });
  const [cellTypes, developStatuses] = useTabLookupQueries({
    filters: [{ lookupType: LOOKUP.CELL_TYPE }, { lookupType: LOOKUP.DEVELOP_STATUS }],
  });

  const divisionOptions = useMemo(
    () => (divisions ?? []).map(item => ({ label: String(item.NAME), value: String(item.CODE) })),
    [divisions]
  );

  const toOptions = (rows: Array<Record<string, string>> | undefined) =>
    (rows ?? []).map(r => ({ label: String(r.NAME ?? r.CODE ?? ''), value: String(r.CODE ?? '') }));
  const toMulti = (v: string | undefined): string[] =>
    String(v ?? '')
      .split(',')
      .filter(Boolean);

  return (
    <SearchArea
      isHidden={hidden || !openSearchArea}
      searchButtonLabel={t(LBL.SEARCH, '_Search')}
      onSearch={onSearch}
      conditions={
        <>
          {/* Row1 — 사업부* / 고객 / Cell 유형 / Biz Type */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DIV, '_Div.')}
              labelAlign='right'
              required
              render={() => (
                <CustomDropdown
                  value={sc.divisionId}
                  options={divisionOptions}
                  onChange={(_, option) => {
                    // 고객·Biz Type 은 ALL reset (E02 — 그리드 비움/메타 재조회는 onDivisionChange)
                    set({ divisionId: String(option ?? ''), endCustomers: [], bizTypes: [] });
                    onDivisionChange();
                  }}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.CUSTOMER, '_Customer')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  value={sc.endCustomers.join(',')}
                  options={toOptions(endCustomers as never)}
                  onChange={(_, options) => set({ endCustomers: toMulti(String(options ?? '')) })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.CELL_TYPE, '_Cell Type')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  value={sc.cellTypes.join(',')}
                  options={toOptions(cellTypes as never)}
                  onChange={(_, options) => set({ cellTypes: toMulti(String(options ?? '')) })}
                />
              )}
            />
          </Grid>
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.BIZ_TYPE, '_Biz Type')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  value={sc.bizTypes.join(',')}
                  options={toOptions(bizTypes as never)}
                  onChange={(_, options) => set({ bizTypes: toMulti(String(options ?? '')) })}
                />
              )}
            />
          </Grid>

          {/* Row2 — 개발 현황 / 등록 완료일* (기본 M-1~Today — 페이지 레벨 주입 E01-2.
              필수·역전 = MSG00108 / 3년 초과 = MSG00164 (P-02/P-03, validate 차단)) */}
          <Grid size={3}>
            <FormItem
              className={commonStyles.formItem}
              label={t(LBL.DEVELOP_STATUS, '_Development Status')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  value={sc.developStatuses.join(',')}
                  options={toOptions(developStatuses as never)}
                  onChange={(_, options) =>
                    set({ developStatuses: toMulti(String(options ?? '')) })
                  }
                />
              )}
            />
          </Grid>
          <PeriodField
            gridSize={6}
            label={t(LBL.REG_COMP_DATE, '_Reg Complete Date')}
            start={sc.regCompDateFr}
            end={sc.regCompDateTo}
            onChange={(start, end) => set({ regCompDateFr: start, regCompDateTo: end })}
          />
        </>
      }
    />
  );
};
