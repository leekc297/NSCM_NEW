import { MaterialByDivisionModal,  ProjectByDivisionModal } from 'features/master/src/components';
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

  // AS-IS cboDivision / cboOperationGroup 은 바인딩 후 SelectedIndex 를 -1 로 돌리지 않아 각각 첫 항목이
  // 항상 선택돼 있다(Division='81' cs:166-197 / OperationGroup=Pack cs:201-204). 최초 로드 시 1회 기본값
  // 반영하되, 비어 있는 조건을 **한 번의 setSearchParams 로 함께** 세팅한다.
  //   금지: Division 과 OperationGroup 을 분리된 effect 로 세팅하지 말 것 — 두 콤보가 같은 렌더에서 로드되면
  //   operationGroup effect 가 먼저 'P' 를 넣은 뒤, division effect 의 setSearchParams({divisionId}) 가
  //   store 의 division-변경 리셋을 타 operationGroup 을 '' 로 되돌린다. 그 사이 재렌더가 없어
  //   operationGroup effect 의 dep(searchParams.operationGroup)이 ''→'' 로 불변이라 재실행되지 않고
  //   기본값이 빈 채로 남는다(개발서버 프로덕션 빌드 실사고 2026-10-29. 로컬은 StrictMode/로딩 타이밍에 가려짐).
  //   한 호출에 둘을 넘기면 store 가 그 필드를 리셋에서 보존한다(useDemandGroupMasterStore 참조).
  useEffect(() => {
    if (divisionOptions.length === 0 || operationGroupOptions.length === 0) return;
    const patch: { divisionId?: string; operationGroup?: string } = {};
    if (!searchParams.divisionId) patch.divisionId = String(divisionOptions[0].value ?? '');
    if (!searchParams.operationGroup)
      patch.operationGroup = String(operationGroupOptions[0].value ?? '');
    if (patch.divisionId !== undefined || patch.operationGroup !== undefined) setSearchParams(patch);
  }, [
    divisionOptions,
    operationGroupOptions,
    searchParams.divisionId,
    searchParams.operationGroup,
    setSearchParams,
  ]);

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
                label={t(LBL.PROJECT, '_PJT')}
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
                          iconComponent={<FunctionSearchIcon appearance='lined' />}
                          onClick={() => !isAuthDenied && setOpenProjectModal(true)}
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
                label={t(LBL.MODEL, '_Model/Nickname')}
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
                          iconComponent={<FunctionSearchIcon appearance='lined' />}
                          onClick={() => !isAuthDenied && setOpenItemModal(true)}
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
          SCM0002_ProjectbyDivisionPopup)과 정합. division 선필터 전달.  Project 팝업 — 사용자 지시(2026-10-14)로 프1(ProjectByDivisionPopup, SCM0002 base)에서
          프2(ProjectByDivisionModal, COM0005 = DMF000_ProjectbyDivisionPopupEx 공용)로 교체.
          project-route(SCP) 선례와 동일. division 선필터 전달. */}
      <ProjectByDivisionModal
        open={openProjectModal}
        modalClose={() => setOpenProjectModal(false)}
        setSelectedValue={projects => {
          if (projects) setSearchParams({ projectId: projects });
        }}
        preSearchParams={{
          divisionId: searchParams.divisionId,
          deptId: 'ALL',
          endCustomer: 'ALL',
          salesSite: 'ALL',
          etc: 'N',
          projectCode: searchParams.projectId,
        }}
        callFromCell={false}
      />
      {/* Model(Item) 팝업 — 사용자 지시(2026-10-02)로 ItemByDivisionModal(COM0008, AS-IS
          DM0002_ItembyDivisionPopup)에서 모1(ModelByDivisionPopup, SCM0002 base)로 교체.
          design/02 §4.6(btnItemId AS-IS SCM0002_ItembyDivisionPopup)과 정합.Model 팝업 — 사용자 지시(2026-10-14)로 모1(ModelByDivisionPopup, SCM0002 base)에서
          메1(MaterialByDivisionModal, COM0013 = SCM0002_MaterialByDivisionPopup 공용)로 교체.
          project-route(SCP) 선례와 동일. */}
      <MaterialByDivisionModal
        open={openItemModal}
        modalClose={() => setOpenItemModal(false)}
        setSelectedValue={items => {
          if (items) setSearchParams({ itemId: items });
        }}
        preSearchParams={{
          divisionId: searchParams.divisionId,
          operationGroup: '',
          scpModuleType: MENU_ID,
          itemId: searchParams.itemId,
        }}
      />
    </>
  );
};
