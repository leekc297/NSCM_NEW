// SCP0007 BOD — TobeGen 생성 골격 (As-is SCP0007_BOD, Fact Pack Doc/asisfacts/screens/SCP0007)
//   생성기: tools/Harness/gen.js · 사전: tools/Harness/rules/ · 수정 지점은 TODO(이식) 주석 — 그 외는 사전 규칙이므로 손대지 말 것
import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem } from '@shared/lges';
import { Grid } from '@shared/mui';

import { useBodStore } from '../useBodStore';

export const BodForm = () => {
  const { t } = useTranslation();

  const searchParams = useBodStore(state => state.searchParams);
  const setSearchParams = useBodStore(state => state.setSearchParams);
  const setFilters = useBodStore(state => state.setFilters);
  const isOpenSearchArea = useBodStore(state => state.isOpenSearchArea);

  // TODO(이식): 콤보ID 확정 — As-is 콤보 소스(UP_FX_GetCommonDataList_* / LOOKUP) ↔ To-Be 등록 콤보ID. 미등록이면 admin 콤보 등록 선행
  const [divisionIdsCombo, fromSiteIdsCombo, toSiteIdsCombo, incotermsCombo, incotermsSspCombo, transModeCombo, inputStatusCombo, validYnCombo] = useTabComboQueries({
    filters: ['MyDivision', 'FromSite', 'ToSite', 'Incoterms', 'SSPIncoterms', 'TransMode', 'Status', 'YesOrNo'],
  });

  // 조회조건 컨트롤의 As-is 이벤트 — 값 변경은 setSearchParams 가 맡고, 아래 부수효과만 이식(TODO):
  //   AS-IS clbDivision.SelectedIndexChanged → cboDivision_SelectedIndexChanged (SCP0007_BOD.cs:176) — CustomDropdown onChange → setSearchParams + cascade(useCascadeFields) / 필요 시 handleXxxChange

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={setFilters}
      isHidden={!isOpenSearchArea}
      conditions={
        <>
          <Grid size={3}>
            {/* AS-IS clbDivision / UsrCheckedList2 (SCP0007_BOD.Designer.cs:37) · 기준표 #1 'Div' */}
            <FormItem
              label={t('LBL00001', '_Div')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  isInput={false}
                  value={searchParams.divisionIds.join(',')}
                  options={divisionIdsCombo?.map(item => ({ label: String(item.NAME ?? item.CODE), value: String(item.CODE) })) ?? []}
                  onChange={(_, picked) => setSearchParams({ divisionIds: String(picked ?? '').split(',').filter(Boolean) })}
                />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          <Grid size={3}>
            {/* AS-IS clbFromSite / UsrCheckedList2 (SCP0007_BOD.Designer.cs:42) · 기준표 #2 'From Site' */}
            <FormItem
              label={t('LBL00022', '_From Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  isInput={false}
                  value={searchParams.fromSiteIds.join(',')}
                  options={fromSiteIdsCombo?.map(item => ({ label: String(item.NAME ?? item.CODE), value: String(item.CODE) })) ?? []}
                  onChange={(_, picked) => setSearchParams({ fromSiteIds: String(picked ?? '').split(',').filter(Boolean) })}
                />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          <Grid size={3}>
            {/* AS-IS clbToSite / UsrCheckedList2 (SCP0007_BOD.Designer.cs:41) · 기준표 #3 'To Site' */}
            <FormItem
              label={t('LBL00023', '_To Site')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  isInput={false}
                  value={searchParams.toSiteIds.join(',')}
                  options={toSiteIdsCombo?.map(item => ({ label: String(item.NAME ?? item.CODE), value: String(item.CODE) })) ?? []}
                  onChange={(_, picked) => setSearchParams({ toSiteIds: String(picked ?? '').split(',').filter(Boolean) })}
                />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          <Grid size={3}>
            {/* AS-IS clbIncoterms / UsrCheckedList2 (SCP0007_BOD.Designer.cs:40) · 기준표 #4 'Incoterms' */}
            <FormItem
              label={t('LBL00024', '_Incoterms')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  isInput={false}
                  value={searchParams.incoterms.join(',')}
                  options={incotermsCombo?.map(item => ({ label: String(item.NAME ?? item.CODE), value: String(item.CODE) })) ?? []}
                  onChange={(_, picked) => setSearchParams({ incoterms: String(picked ?? '').split(',').filter(Boolean) })}
                />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          <Grid size={3}>
            {/* AS-IS clbIncotermsSSP / UsrCheckedList2 (SCP0007_BOD.Designer.cs:38) · 기준표 #5 'SSP Incoterms' */}
            <FormItem
              label={t('LBL00026', '_SSP Incoterms')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  isInput={false}
                  value={searchParams.incotermsSsp.join(',')}
                  options={incotermsSspCombo?.map(item => ({ label: String(item.NAME ?? item.CODE), value: String(item.CODE) })) ?? []}
                  onChange={(_, picked) => setSearchParams({ incotermsSsp: String(picked ?? '').split(',').filter(Boolean) })}
                />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          <Grid size={3}>
            {/* AS-IS clbTransMode / UsrCheckedList2 (SCP0007_BOD.Designer.cs:39) · 기준표 #6 'Trans Mode' */}
            <FormItem
              label={t('LBL00025', '_Trans Mode')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  multiple
                  allOption
                  useClearIcon
                  limitTags={1}
                  isInput={false}
                  value={searchParams.transMode.join(',')}
                  options={transModeCombo?.map(item => ({ label: String(item.NAME ?? item.CODE), value: String(item.CODE) })) ?? []}
                  onChange={(_, picked) => setSearchParams({ transMode: String(picked ?? '').split(',').filter(Boolean) })}
                />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          <Grid size={3}>
            {/* AS-IS cboInputStatus / UsrCombo (SCP0007_BOD.Designer.cs:44) · 기준표 #7 'Status' (AS-IS ' To Country') */}
            <FormItem
              label={t('LBL00014', '_Status')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={searchParams.inputStatus}
                  options={inputStatusCombo?.map(item => ({ label: String(item.NAME ?? item.CODE), value: String(item.CODE) })) ?? []}
                  onChange={(_, option) => setSearchParams({ inputStatus: option })}
                />
              )}
              className={commonStyles.formItem}
            />
          </Grid>
          <Grid size={3}>
            {/* AS-IS cboValidYN / UsrCombo (SCP0007_BOD.Designer.cs:43) · 기준표 #8 'Active' (AS-IS 'Valid') */}
            <FormItem
              label={t('LBL00007', '_Active')}
              labelAlign='right'
              render={() => (
                <CustomDropdown
                  isInput={false}
                  value={searchParams.validYn}
                  options={validYnCombo?.map(item => ({ label: String(item.NAME ?? item.CODE), value: String(item.CODE) })) ?? []}
                  onChange={(_, option) => setSearchParams({ validYn: option })}
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
