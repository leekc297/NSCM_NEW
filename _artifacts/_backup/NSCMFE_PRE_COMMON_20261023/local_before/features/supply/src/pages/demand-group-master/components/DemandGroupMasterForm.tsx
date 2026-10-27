import { ModelByDivisionPopup, ProjectByDivisionPopup } from 'features/master/src/components';
import { useEffect, useMemo, useState } from 'react';

import commonStyles from '@foundation/styles/common-styles.module.scss';
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { FunctionSearchIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';
import { confirmIfDirtyKey, tabDirtyKey, useTabid } from '@shared/stores';

import {
  COMBO_ID,
  LBL,
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

  // Division 변경 = 그리드+다른 조회조건 전부 초기화(store.setSearchParams). 편집중(dirty)이면
  //   MSG00704 confirm 후에만 바꾼다 — 조회 공통 가드와 동일 경로(51d4e9fa DM 14개 화면 패턴).
  //   controlled 콤보라 취소 시 자동 복귀.
  const tabId = useTabid();

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

  // AS-IS cboOperationGroup 은 RemoveAt(2) 후 바인딩만 하고 SelectedIndex 를 -1 로 돌리지 않아
  // WinForms 기본 동작대로 첫 항목(Pack)이 항상 선택돼 있다(cs:201-204). 동일하게 최초 로드 시 1회 기본값 반영.
  useEffect(() => {
    if (searchParams.operationGroup || operationGroupOptions.length === 0) return;
    setSearchParams({ operationGroup: String(operationGroupOptions[0].value ?? '') });
  }, [operationGroupOptions, searchParams.operationGroup, setSearchParams]);

  // AS-IS cboDivision 도 동일하게 SelectedIndex 를 -1 로 돌리지 않아, '81' 포함만 남기고
  // CODE Asc 정렬한 리스트의 첫 항목('81')이 항상 선택돼 있다(cs:166-197). 조회를 쏘는 게 아니라
  // 콤보 기본값만 반영 — 최초 로드 시 1회.
  useEffect(() => {
    if (searchParams.divisionId || divisionOptions.length === 0) return;
    setSearchParams({ divisionId: String(divisionOptions[0].value ?? '') });
  }, [divisionOptions, searchParams.divisionId, setSearchParams]);

  // L1: 조회가능 Division 권한 0건이면 조회영역 비활성(AS-IS SetDivisionAuthCheck cs L194-195).
  const isAuthDenied = divisionOptions.length === 0;

  return (
    <>
      <SearchArea
        searchButtonLabel={t(LBL.SEARCH, '_Search')}
        isHidden={!openSearchArea}
        onSearch={onSearch}
        conditions={
          <>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.DIVISION, '_Div')}
                labelAlign='right'
                render={() => (
                  <CustomDropdown
                    disabled={isAuthDenied}
                    value={searchParams.divisionId}
                    options={divisionOptions}
                    onChange={(_, value) => {
                      void confirmIfDirtyKey(tabDirtyKey(tabId), 'search').then(ok => {
                        if (!ok) return;
                        setSearchParams({ divisionId: value });
                      });
                    }}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.OPERATION_GROUP, '_Operation Group')}
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
                label={t(LBL.GROUP_NAME, '_Group Name')}
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
                label={t(LBL.PROJECT, '_Project')}
                labelAlign='right'
                render={() => (
                  <InputField
                    fullWidth
                    className={commonStyles.popupSearchField}
                    value={searchParams.projectId}
                    disabled={isAuthDenied}
                    InputProps={{
                      endAdornment: (
                        <Button
                          appearance='outlined'
                          priority='normal'
                          disabled={isAuthDenied}
                          iconComponent={
                            <FunctionSearchIcon
                              appearance='lined'
                              onClick={() => !isAuthDenied && setOpenProjectModal(true)}
                            />
                          }
                        />
                      ),
                    }}
                    onChange={e => setSearchParams({ projectId: e.target.value })}
                  />
                )}
              />
            </Grid>
            <Grid size={3}>
              <FormItem
                className={commonStyles.formItem}
                label={t(LBL.MODEL, '_Model')}
                labelAlign='right'
                render={() => (
                  <InputField
                    fullWidth
                    className={commonStyles.popupSearchField}
                    value={searchParams.itemId}
                    disabled={isAuthDenied}
                    InputProps={{
                      endAdornment: (
                        <Button
                          appearance='outlined'
                          priority='normal'
                          disabled={isAuthDenied}
                          iconComponent={
                            <FunctionSearchIcon
                              appearance='lined'
                              onClick={() => !isAuthDenied && setOpenItemModal(true)}
                            />
                          }
                        />
                      ),
                    }}
                    onChange={e => setSearchParams({ itemId: e.target.value })}
                  />
                )}
              />
            </Grid>
          </>
        }
      />
      {/* Project 팝업 — 사용자 지시(2026-10-02)로 프2(ProjectByDivisionModal, COM0005 Ex)에서
          프1(ProjectByDivisionPopup, SCM0002 base)로 교체. design/02 §4.6(btnProject AS-IS
          SCM0002_ProjectbyDivisionPopup)과 정합. division 선필터 전달. */}
      <ProjectByDivisionPopup
        open={openProjectModal}
        onClose={() => setOpenProjectModal(false)}
        params={{ divisionId: searchParams.divisionId, projectCode: searchParams.projectId }}
        onSelect={selected => {
          if (selected.projectCode) setSearchParams({ projectId: selected.projectCode });
        }}
      />
      {/* Model(Item) 팝업 — 사용자 지시(2026-10-02)로 ItemByDivisionModal(COM0008, AS-IS
          DM0002_ItembyDivisionPopup)에서 모1(ModelByDivisionPopup, SCM0002 base)로 교체.
          design/02 §4.6(btnItemId AS-IS SCM0002_ItembyDivisionPopup)과 정합. */}
      <ModelByDivisionPopup
        open={openItemModal}
        onClose={() => setOpenItemModal(false)}
        params={{
          divisionId: searchParams.divisionId,
          projectCode: searchParams.projectId,
          itemId: searchParams.itemId,
        }}
        onSelect={selected => {
          if (selected.itemId) setSearchParams({ itemId: selected.itemId });
        }}
      />
    </>
  );
};
