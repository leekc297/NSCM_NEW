// DMF0052 EDISummary — TobeGen 생성 골격 (As-is DMF0052_EDISummary, Fact Pack Doc/asisfacts/screens/DMF0052)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
// 조회조건 카탈로그(features/master searchFields — 31개 화면이 같은 경로로 import)
import { ItemField, PeriodField, ProjectField } from 'features/master/src/components';
import { useEffect } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Checkbox, FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { useDmf0052Store } from '../useDmf0052Store';

export const Dmf0052Form = () => {
  const { t } = useTranslation();

  const searchParams = useDmf0052Store(state => state.searchParams);
  const setSearchParams = useDmf0052Store(state => state.setSearchParams);
  const setFilters = useDmf0052Store(state => state.setFilters);
  const isOpenSearchArea = useDmf0052Store(state => state.isOpenSearchArea);

  // As-is 에 Division 조회조건 없음 — 팝업 필드(division 필수)용 기본 사업부 = 공용 콤보 MyDivision 첫 값 (SCM_ADM_CMBO_SQL_M)
  const [myDivision] = useTabComboQueries({ filters: ['MyDivision'] });
  useEffect(() => {
    const first = myDivision?.[0]?.CODE;
    if (!searchParams.divisionId && first) setSearchParams({ divisionId: String(first) });
  }, [myDivision, searchParams.divisionId, setSearchParams]);

  // TODO(이식): 콤보ID 확정 — As-is 콤보 소스(UP_FX_GetCommonDataList_* / LOOKUP) ↔ To-Be 등록 콤보ID. 미등록이면 admin 콤보 등록 선행
  const [senderCodesCombo] = useTabComboQueries({
    filters: ['SenderCode'],
  });

  // 조회조건 컨트롤의 As-is 이벤트 — 값 변경은 setSearchParams 가 맡고, 아래 부수효과만 이식(TODO):
  //   AS-IS this.chkToday.CheckedChanged → chkToday_CheckedChanged (DMF0052_EDISummary.Designer.cs:255) — Checkbox onChange → setSearchParams / 그리드 표시 토글이면 applyDynVisibility

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={setFilters}
      isHidden={!isOpenSearchArea}
      conditions={
        <>
          <Grid size={3}>
            {/* AS-IS chkToday / UsrCheckBox (DMF0052_EDISummary.Designer.cs:44) */}
            <FormItem
              label={t('LBL?????', '_Today')}
              labelAlign='right'
              render={() => (
                <Checkbox checked={searchParams.today} onChange={checked => setSearchParams({ today: checked })} />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          {/* AS-IS txtItemId / UsrMultiLineEditor (DMF0052_EDISummary.Designer.cs:45) + btnItemId 팝업(필드 내장) — 카탈로그 ItemField */}
          <ItemField
            value={searchParams.itemIds}
            onChange={v => setSearchParams({ itemIds: v })}
            division={searchParams.divisionId}
            gridSize={3}
          />
          {/* AS-IS txtProject / UsrMultiLineEditor (DMF0052_EDISummary.Designer.cs:46) + btnProject 팝업(필드 내장) — 카탈로그 ProjectField */}
          <ProjectField
            value={searchParams.projectCodes}
            onChange={v => setSearchParams({ projectCodes: v })}
            division={searchParams.divisionId}
            gridSize={3}
          />
          {/* AS-IS drpPeriod / UsrDateRangePicker (DMF0052_EDISummary.Designer.cs:49) — 카탈로그 PeriodField */}
          <PeriodField
            start={searchParams.periodFrom}
            end={searchParams.periodTo}
            onChange={(start, end) => setSearchParams({ periodFrom: start, periodTo: end })}
            gridSize={3}
          />
          <Grid size={3}>
            {/* AS-IS clbEDISender / UsrCheckedList (DMF0052_EDISummary.Designer.cs:50) */}
            <FormItem
              label={t('LBL?????', '_EDI Sender')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  isInput={false}
                  value={searchParams.senderCodes.join(',')}
                  options={senderCodesCombo?.map(item => ({ label: String(item.NAME ?? item.CODE), value: String(item.CODE) })) ?? []}
                  onChange={(_, picked) => setSearchParams({ senderCodes: String(picked ?? '').split(',').filter(Boolean) })}
                />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
        </>
      }
    />
  );
};
