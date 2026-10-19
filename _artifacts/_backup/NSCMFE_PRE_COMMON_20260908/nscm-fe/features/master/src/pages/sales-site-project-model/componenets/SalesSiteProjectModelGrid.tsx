import { AllowMerging, CellRange, CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, useState, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import { t } from '@foundation/i18n';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import { ItemByDivisionModal, OwnerModal, TeamModal, ProjectModal } from '../../../components';
import type { MODAL_OWNER } from '../../../components/ownerModal/owner-modal.constants';
import type { RESPONSE_SET } from '../sales-site-project-model.constants';
import {
  MENU_ID,
  MODEL_POPUP_COLUMNS,
  MODEL_POPUP_CONDITIONS,
  MODEL_POPUP_WIDTH,
  SHEETS,
  SHEET_INDEX,
  SINGLE_OWNER_DIVISIONS,
} from '../sales-site-project-model.constants';
import { useEditBaseline } from '../sales-site-project-model.editBaseline';
import { useSalesSiteProjectModelStore } from '../useSalesSiteProjectModelStore';

interface SalesSiteProjectModelGridProps {
  gridRef: MutableRefObject<
    FlexGrid<ResponseData<MENU_ID, SHEETS.PRODUCTION, RESPONSE_SET.PRODUCTION>> | undefined
  >;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.PRODUCTION, RESPONSE_SET.PRODUCTION>[];
  setActiveTab: (tab: SHEET_INDEX) => void;
  /**
   * 하단(Purchase) 에 미저장 변경이 있는지 — 더블클릭 조회가 하단을 통째로 갈아끼우므로
   * 그때만 호출해 판정한다. 판정 기준은 저장 대상(CRUD_TYPE)과 동일하게 부모가 가진다.
   */
  hasPurchaseChanges: () => boolean;
}

export const SalesSiteProjectModelGrid = ({
  gridRef,
  gridFilterRef,
  data,
  setActiveTab,
  hasPurchaseChanges,
}: SalesSiteProjectModelGridProps) => {
  const editTrackerRef = useRef<
    EditTracker<ResponseData<MENU_ID, SHEETS.PRODUCTION, RESPONSE_SET.PRODUCTION>> | undefined
  >();

  const filters = useSalesSiteProjectModelStore(state => state.filters);
  const staticColumns = useSalesSiteProjectModelStore(state => state.staticColumns);
  const setPurchaseFilter = useSalesSiteProjectModelStore(state => state.setPurchaseFilter);
  const setAlert = useMessageStore(state => state.setAlert);

  const [openTeamModal, setOpenTeamModal] = useState<boolean>(false);
  const [openOwnerModal, setOpenOwnerModal] = useState<boolean>(false);
  const [openItemModal, setOpenItemModal] = useState<boolean>(false);
  const [openProjectModal, setOpenProjectModal] = useState<boolean>(false);
  const [ownerOpenByPm, setOwnerOpenByPm] = useState<boolean>(false);
  const [clickedRow, setClickedRow] = useState(-1);
  const clickedDataItem = GridUtils.getRow(gridRef.current, clickedRow);

  // 조회 원본 기준선으로 수정상태(M)를 재판정 — 사유는 sales-site-project-model.editBaseline 참조.
  const resyncRow = useEditBaseline({ gridRef, editTrackerRef, data });

  const handleTeamSelected = (teamId: string, teamName?: string) => {
    if (!clickedDataItem) return;

    editTrackerRef.current?.storeChange(
      clickedDataItem,
      'DEPT_ID',
      clickedDataItem.DEPT_ID,
      teamId ?? ''
    );
    editTrackerRef.current?.storeChange(
      clickedDataItem,
      'TEAM_NAME',
      clickedDataItem.TEAM_NAME,
      teamName ?? ''
    );
    clickedDataItem.DEPT_ID = teamId;
    clickedDataItem.TEAM_NAME = teamName ?? '';

    resyncRow(clickedDataItem);
    gridRef.current?.refreshRange(new CellRange(clickedRow, 0, clickedRow, -1));
  };

  const handleOwnerSelected = (selectedUsers: ResponseData<MODAL_OWNER, 'owner', 'o_rc1'>[]) => {
    if (!clickedDataItem || !selectedUsers) return;

    const owners = selectedUsers.map(item => item.USER_ID).join(',');
    const ownersNames = selectedUsers.map(item => item.USER_NAME_EN).join(',');

    if (ownerOpenByPm) {
      editTrackerRef.current?.storeChange(
        clickedDataItem,
        'PRJ_OWNR_ID',
        clickedDataItem.PRJ_OWNR_ID,
        owners
      );
      clickedDataItem.PRJ_OWNR_ID = owners;
    } else {
      editTrackerRef.current?.storeChange(clickedDataItem, 'OWNER', clickedDataItem.OWNER, owners);
      editTrackerRef.current?.storeChange(
        clickedDataItem,
        'OWNER_NAME',
        clickedDataItem.OWNER_NAME,
        ownersNames
      );

      clickedDataItem.OWNER = owners;
      clickedDataItem.OWNER_NAME = ownersNames;

      // Team(DEPT_ID/TEAM_NAME)은 비어 있을 때만 담당자 소속으로 채운다.
      //   COM0004(owner popup) 결과에 담당자 소속(DEPT_ID/DEPT_NAME_KO)이 함께 내려와 별도 조회가
      //   필요없다. 다만 행의 Team 은 담당자 소속과 별개로 관리하는 값이라, 이미 값이 있으면
      //   Owner 만 바꿔도 Team 이 덮어써지는 사고가 났다 - 채워져 있으면 건드리지 않는다.
      //   저장 키인 DEPT_ID 를 기준으로 판정한다(TEAM_NAME 은 표시용).
      //   Team 을 직접 바꾸려면 Team 컬럼 더블클릭(TeamModal)을 쓴다.
      //   다중 선택이면 소속이 있는 첫 담당자 기준 - 소속이 비면 기존 팀 값을 지우지 않는다.
      const ownerWithDept = selectedUsers.find(item => !!item.DEPT_ID);
      if (!clickedDataItem.DEPT_ID && ownerWithDept) {
        const deptId = ownerWithDept.DEPT_ID;
        const deptName = ownerWithDept.DEPT_NAME_KO ?? '';

        editTrackerRef.current?.storeChange(
          clickedDataItem,
          'DEPT_ID',
          clickedDataItem.DEPT_ID,
          deptId
        );
        editTrackerRef.current?.storeChange(
          clickedDataItem,
          'TEAM_NAME',
          clickedDataItem.TEAM_NAME,
          deptName
        );

        clickedDataItem.DEPT_ID = deptId;
        clickedDataItem.TEAM_NAME = deptName;
      }
    }

    resyncRow(clickedDataItem);
    gridRef.current?.refreshRange(new CellRange(clickedRow, 0, clickedRow, -1));
  };

  const handleProjectSelected = (projects: string, projectsNames?: string) => {
    if (!clickedDataItem || !projects) return;

    const projectCode = projects?.split(',')[0] ?? '';
    const projectName = projectsNames?.split(',')[0] ?? '';

    editTrackerRef.current?.storeChange(
      clickedDataItem,
      'PROJECT_CODE',
      clickedDataItem.PROJECT_CODE,
      projectCode
    );
    editTrackerRef.current?.storeChange(
      clickedDataItem,
      'PROJECT_NAME',
      clickedDataItem.PROJECT_NAME,
      projectName
    );

    clickedDataItem.PROJECT_CODE = projectCode;
    clickedDataItem.PROJECT_NAME = projectName;

    resyncRow(clickedDataItem);
    gridRef.current?.refreshRange(new CellRange(clickedRow, 0, clickedRow, -1));
  };

  const handleItemSelected = (itemCode: string, itemName?: string, itemType?: string) => {
    if (!clickedDataItem) return;

    editTrackerRef.current?.storeChange(
      clickedDataItem,
      'ITEM_ID',
      clickedDataItem.ITEM_ID,
      itemCode ?? ''
    );
    editTrackerRef.current?.storeChange(
      clickedDataItem,
      'ITEM_NAME',
      clickedDataItem.ITEM_NAME,
      itemName ?? ''
    );
    editTrackerRef.current?.storeChange(
      clickedDataItem,
      'ITEM_CLASS_NAME',
      clickedDataItem.ITEM_CLASS_NAME,
      itemType ?? ''
    );

    clickedDataItem.ITEM_ID = itemCode;
    clickedDataItem.ITEM_NAME = itemName ?? '';
    clickedDataItem.ITEM_CLASS_NAME = itemType ?? '';

    resyncRow(clickedDataItem);
    gridRef.current?.refreshRange(new CellRange(clickedRow, 0, clickedRow, -1));
  };

  const handleFocus = () => {
    setActiveTab(SHEET_INDEX.PRODUCTION);
  };

  const handleGridDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell) return;

    const dataItem = GridUtils.getRow(grid, ht.row);
    const binding = GridUtils.getBinding(grid, ht.col);

    if (!dataItem || !binding) return;

    if (binding === 'DEPT_ID' || binding === 'TEAM_NAME') {
      setClickedRow(ht.row);
      setOpenTeamModal(true);
      return;
    } else if (binding === 'OWNER' || binding === 'PRJ_OWNR_ID') {
      setClickedRow(ht.row);
      setOwnerOpenByPm(binding === 'PRJ_OWNR_ID');
      setOpenOwnerModal(true);
      return;
    } else if (
      dataItem.DIVISION_ID !== '40' &&
      dataItem.CRUD_TYPE === CRUD_TYPE.INSERT &&
      binding === 'PROJECT_CODE'
    ) {
      setClickedRow(ht.row);
      setOpenProjectModal(true);
      return;
    } else if (
      dataItem.CRUD_TYPE === CRUD_TYPE.INSERT &&
      dataItem.DIVISION_ID === '40' &&
      ['ITEM_ID', 'ITEM_NAME', 'ITEM_CLASS_NAME'].includes(binding)
    ) {
      setClickedRow(ht.row);
      setOpenItemModal(true);
    }

    if (dataItem?.DIVISION_ID === '40' || GridUtils.isEditableCell(grid, ht.row, ht.col)) return;

    // ⭐ 하단(Purchase) 에 미저장 변경이 있으면 조회를 막는다 —
    //   이 더블클릭은 하단 데이터를 통째로 다시 조회하므로 그대로 두면 수정분이 조용히 사라진다.
    //   저장/취소는 사용자가 직접 정하도록 confirm 이 아니라 alert(진행 불가)로 알린다.
    if (hasPurchaseChanges()) {
      void setAlert({
        type: 'alert',
        // 백엔드 메시지 코드가 아직 없어 MSG_NO_CHANGE 처럼 임시 키 + 기본문구로 둔다.
        content: t('MSG_PURCHASE_EDITING', 'Purchase 수정 중이라 조회할 수 없습니다.'),
      });
      return;
    }

    setClickedRow(ht.row);
    setPurchaseFilter({
      divisionId: dataItem.DIVISION_ID,
      salesSite: dataItem.SCM_SITE_ID,
      projectCode: dataItem.PROJECT_CODE,
      activeFlag: dataItem.VALID_YN,
    });
  };

  return (
    <>
      <DataGrid<ResponseData<MENU_ID, SHEETS.PRODUCTION, RESPONSE_SET.PRODUCTION>>
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        itemsSource={data}
        staticColumns={staticColumns[SHEETS.PRODUCTION]}
        allowMerging={AllowMerging.ColumnHeaders}
        gotFocus={handleFocus}
        dblClick={handleGridDblClick}
      />
      <TeamModal
        open={openTeamModal}
        modalClose={() => setOpenTeamModal(false)}
        setSelectedValue={handleTeamSelected}
        teamId={clickedDataItem?.DEPT_ID}
        teamName={clickedDataItem?.TEAM_NAME}
      />
      <OwnerModal
        open={openOwnerModal}
        modalClose={() => setOpenOwnerModal(false)}
        setSelectedValue={handleOwnerSelected}
        divisionId={filters.production?.divisionId ?? '40'}
        ownerId={ownerOpenByPm ? clickedDataItem?.PRJ_OWNR_ID : clickedDataItem?.OWNER}
        // Owner(Sales) 만 제한 대상 — PM 담당자(PRJ_OWNR_ID)는 여러 명 등록 가능.
        // 신규 행은 DIVISION_ID 가 비어있을 수 있어 조회 조건으로 폴백.
        singleSelect={
          !ownerOpenByPm &&
          SINGLE_OWNER_DIVISIONS[SHEETS.PRODUCTION].includes(
            clickedDataItem?.DIVISION_ID || filters.production?.divisionId || ''
          )
        }
      />
      <ItemByDivisionModal
        open={openItemModal}
        modalClose={() => setOpenItemModal(false)}
        setSelectedValue={handleItemSelected}
        // ⭐ 화면에 남긴 3개(Div / Model·Nickname / Item Type) 외에는 클릭한 행 값을 따라가지 않고
        //   전부 기본값으로 연다 — 안 보이는 조건(Team/End Customer/Sales Site/Project)이 조회를
        //   좁히면 사용자는 결과가 왜 비는지 알 수 없다. AS-IS 'Model by DivisionPopup' 과 동일.
        preSearchParams={{
          divisionId: clickedDataItem?.DIVISION_ID ?? 'ALL',
          deptId: 'ALL',
          endCustomer: 'ALL',
          salesSite: 'ALL',
          projectCode: '',
          itemId: clickedDataItem?.ITEM_ID ?? '',
          activeFlag: 'Y',
        }}
        callFromCell={true}
        // ⭐ AS-IS 'Model by DivisionPopup' 동등 — 검색조건 3개 + 컬럼 5개.
        //   둘 다 opt-in prop 이라 COM0008 의 다른 호출처는 영향 없다.
        visibleConditions={MODEL_POPUP_CONDITIONS}
        visibleColumns={MODEL_POPUP_COLUMNS}
        dialogSize={MODEL_POPUP_WIDTH}
        // 그리드 셀 호출은 좁은 조회를 쓴다 - AS-IS 가 셀 팝업만 DM0002_ItembySmallDivPopup
        //   으로 갈랐던 것과 같다(DMF0005 L3413. 조회조건 버튼은 L4076 으로 넓은 쪽).
        //   넓은 쪽은 team/end customer/site 축까지 펼쳐져 있어, 여기처럼 컬럼을 5개로 좁혀
        //   열면 같은 Model 이 여러 줄로 보인다. 좁은 쪽은 아이템 마스터 축이라 그 중복이 없다.
        //   조회조건 버튼(SalesSiteProjectModelForm)은 지정하지 않으므로 넓은 쪽 그대로다.
        smallDivision={{ menuId: MENU_ID }}
      />
      <ProjectModal
        open={openProjectModal}
        modalClose={() => setOpenProjectModal(false)}
        setSelectedValue={handleProjectSelected}
        preSearchParams={{
          divisionId: clickedDataItem?.DIVISION_ID ?? 'ALL',
        }}
        preProject={clickedDataItem?.PROJECT_CODE ?? ''}
      />
    </>
  );
};
