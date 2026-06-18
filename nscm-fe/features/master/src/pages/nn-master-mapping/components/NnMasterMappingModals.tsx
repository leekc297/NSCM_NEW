import { CustomerModal, ItemByDivisionModal, ProjectByDivisionModal } from '../../../components';

interface Props {
  divisionId: string;
  deptId: string;
  endCustomer: string;
  scmSiteId: string;
  clickedBinding: string | null;
  openCustomerModal: boolean;
  openProjectModal: boolean;
  openItemModal: boolean;
  setOpenCustomerModal: (open: boolean) => void;
  setOpenProjectModal: (open: boolean) => void;
  setOpenItemModal: (open: boolean) => void;
  onCustomerSelect: (soldTo: string, soldDesc: string, shipTo: string) => void;
  onProjectSelect: (projects: string) => void;
  onItemSelect: (items: string) => void;
}

// ⭐ 룰 12 §1.5 — Modal 영역 컴포넌트 분리 (2026-06-17 monolithic split).
//   Customer/Project/Item 3개 popup modal 통합. dblClick state 는 본체가 관리.
export const NnMasterMappingModals = ({
  divisionId,
  deptId,
  endCustomer,
  scmSiteId,
  clickedBinding,
  openCustomerModal,
  openProjectModal,
  openItemModal,
  setOpenCustomerModal,
  setOpenProjectModal,
  setOpenItemModal,
  onCustomerSelect,
  onProjectSelect,
  onItemSelect,
}: Props) => (
  <>
    <CustomerModal
      open={openCustomerModal}
      modalClose={() => setOpenCustomerModal(false)}
      setSelectedValue={onCustomerSelect}
      divisionId={divisionId}
    />
    <ProjectByDivisionModal
      open={openProjectModal}
      modalClose={() => setOpenProjectModal(false)}
      setSelectedValue={onProjectSelect}
      preSearchParams={
        {
          divisionId,
          deptId,
          endCustomer,
          salesSite: scmSiteId,
          projectCode: '',
          etc: 'N',
        } as never
      }
      callFromCell={true}
    />
    <ItemByDivisionModal
      open={openItemModal}
      modalClose={() => setOpenItemModal(false)}
      setSelectedValue={onItemSelect}
      preSearchParams={
        {
          divisionId,
          deptId,
          endCustomer,
          salesSite: scmSiteId,
          projectCode: '',
          itemId: '',
        } as never
      }
      callFromCell={true}
      headerTitle={
        clickedBinding === 'MAPPING_ITEM_ID' ? 'Mapping Item Popup' : 'Model/Nickname Popup'
      }
    />
  </>
);
