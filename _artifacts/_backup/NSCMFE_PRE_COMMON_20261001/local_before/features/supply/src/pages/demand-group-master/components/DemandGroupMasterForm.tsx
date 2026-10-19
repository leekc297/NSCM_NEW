import { ItemByDivisionModal, ProjectByDivisionModal } from 'features/master/src/components';
import { useMemo, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';

import {
  COMBO_ID,
  LABEL,
  MENU_ID,
  OPERATION_GROUP_LOOKUP_TYPE,
} from '../demand-group-master.constants';
import { useDemandGroupMasterStore } from '../useDemandGroupMasterStore';
import {
  buildDivisionOptions,
  buildOperationGroupOptions,
} from '../utils/demand-group-master.combos';

interface DemandGroupMasterFormProps {
  onSearch: () => void;
}

export const DemandGroupMasterForm = ({ onSearch }: DemandGroupMasterFormProps) => {
  const { t } = useTranslation();

  const openSearchArea = useDemandGroupMasterStore(state => state.openSearchArea);
  const searchParams = useDemandGroupMasterStore(state => state.searchParams);
  const setSearchParams = useDemandGroupMasterStore(state => state.setSearchParams);

  const [openProjectModal, setOpenProjectModal] = useState<boolean>(false);
  const [openItemModal, setOpenItemModal] = useState<boolean>(false);

  // Division_SCP(권한필터 동일) + LookupCommon(@lookupType='OPERATION_GROUP'). @sesUserId 는 BE 자동 주입.
  const [divisionRows, operationGroupRows] = useTabComboQueries({
    filters: [
      { comboId: COMBO_ID.DIVISION, mnuId: MENU_ID },
      { comboId: COMBO_ID.LOOKUP_COMMON, lookupType: OPERATION_GROUP_LOOKUP_TYPE, mnuId: MENU_ID },
    ],
  });

  const divisionOptions = useMemo(() => buildDivisionOptions(divisionRows), [divisionRows]);
  const operationGroupOptions = useMemo(
    () => buildOperationGroupOptions(operationGroupRows),
    [operationGroupRows]
  );

  // L1: 조회가능 Division 권한 0건이면 조회영역 비활성(AS-IS SetDivisionAuthCheck cs L194-195).
  const isAuthDenied = divisionOptions.length === 0;

  // 팝업 선필터 — 다중 체크 division 의 첫 코드(모달 divisionId 는 단일). Item 은 project 도 전달.
  const firstDivision = searchParams.divisionId.split(',')[0] ?? '';

  return (
    <>
      <SearchArea
        searchButtonLabel={t(LABEL.SEARCH, '_Search')}
        isHidden={!openSearchArea}
        onSearch={onSearch}
        conditions={
          <>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LABEL.DIVISION, '_Division')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    multiple
                    useClearIcon
                    limitTags={1}
                    disabled={isAuthDenied}
                    value={searchParams.divisionId}
                    options={divisionOptions}
                    onChange={(_, value) => setSearchParams({ divisionId: value })}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LABEL.OPERATION_GROUP, '_Operation Group')}
                labelAlign='right'
                labelSize='middle'
                render={() => (
                  <CustomDropdown
                    disabled={isAuthDenied}
                    value={searchParams.operationGroup}
                    options={operationGroupOptions}
                    onChange={(_, value) => setSearchParams({ operationGroup: value })}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LABEL.GROUP_NAME, '_Group Name')}
                labelAlign='right'
                labelSize='middle'
                render={() => (
                  <InputField
                    fullWidth
                    disabled={isAuthDenied}
                    value={searchParams.groupName}
                    onChange={e => setSearchParams({ groupName: e.target.value })}
                    onKeyDown={e => e.key === 'Enter' && onSearch()}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LABEL.PROJECT, '_Project')}
                labelAlign='right'
                render={() => (
                  <div className={commonStyles.customGrid}>
                    <InputField
                      fullWidth
                      value={searchParams.projectId}
                      disabled={isAuthDenied}
                      onChange={e => setSearchParams({ projectId: e.target.value })}
                    />
                    <Button
                      appearance='outlined'
                      priority='normal'
                      size='medium'
                      buttonLabel='...'
                      disabled={isAuthDenied}
                      onClick={() => setOpenProjectModal(true)}
                    />
                  </div>
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LABEL.MODEL, '_Model')}
                labelAlign='right'
                render={() => (
                  <div className={commonStyles.customGrid}>
                    <InputField
                      fullWidth
                      value={searchParams.itemId}
                      disabled={isAuthDenied}
                      onChange={e => setSearchParams({ itemId: e.target.value })}
                    />
                    <Button
                      appearance='outlined'
                      priority='normal'
                      size='medium'
                      buttonLabel='...'
                      disabled={isAuthDenied}
                      onClick={() => setOpenItemModal(true)}
                    />
                  </div>
                )}
              />
            </Grid>
          </>
        }
      />
      {/* Project/Item 팝업 — division 선필터 전달. 반환 빈값이면 미덮어쓰기(AS-IS cs L984-988/1006-1010). */}
      <ProjectByDivisionModal
        open={openProjectModal}
        modalClose={() => setOpenProjectModal(false)}
        callFromCell={false}
        preSearchParams={{ divisionId: firstDivision, projectCode: searchParams.projectId || 'ALL' }}
        setSelectedValue={projects => {
          if (projects) setSearchParams({ projectId: projects });
        }}
      />
      <ItemByDivisionModal
        open={openItemModal}
        modalClose={() => setOpenItemModal(false)}
        callFromCell={false}
        preSearchParams={{
          divisionId: firstDivision,
          projectCode: searchParams.projectId || 'ALL',
          itemId: searchParams.itemId || '',
        }}
        setSelectedValue={items => {
          if (items) setSearchParams({ itemId: items });
        }}
      />
    </>
  );
};
