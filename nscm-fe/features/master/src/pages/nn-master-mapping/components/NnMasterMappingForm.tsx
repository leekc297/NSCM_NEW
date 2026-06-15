import { useEffect, useMemo, useState } from 'react';

import { CustomDropdown } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';

import { ItemByDivisionModal, ProjectByDivisionModal } from '../../../components';
import { FALLBACK_ALL, MENU_ID, SHEETS } from '../nn-master-mapping.constants';
import { useNnMasterMappingStore } from '../useNnMasterMappingStore';

import styles from '../NnMasterMapping.module.scss';

interface Props {
  onSearch: () => void;
}

interface LookupRow {
  CODE?: string | number;
  NAME?: string | number;
}

// 표시 형식: ${CODE} (${NAME}) — 단 CODE==NAME 이면 CODE 만 (e.g. 'Excel')
// 패턴 원천: features/master/src/pages/erp-edi-master/components/ErpEdiMasterForm.tsx (DMF0008)
// SP 가 prepend 하는 `'ALL' AS CODE` 행은 제외 — CustomDropdown 의 `allOption` 으로 위임 (중복 회피)
const toOptions = (rows: LookupRow[] | undefined): Array<{ value: string; label: string }> => {
  const arr = (rows ?? []) as LookupRow[];
  if (arr.length === 0) return [];
  // NUMBER → String 강제 (메모리 feedback_no_type_cast_around_runtime)
  return arr
    .map(r => {
      const code = String(r.CODE ?? '');
      const name = String(r.NAME ?? code);
      const label = code === name || name === '' ? code : `${code} (${name})`;
      return { value: code, label };
    })
    .filter(o => o.value !== 'ALL' && o.value !== '');
};

// AS-IS DMF0072_NNMasterMapping.cs 조회조건:
//   - DataType (L200):  clbDataTypeCode  UsrCombo 단일+ALL  → DM_EDI_DATA_TYPE_CODE lookup
//   - Division (L154):  clbDivisions     UsrCombo 단일 필수 → DMF0008_GET_MY_DIVISION_LIST (재사용)
//   - Team (L159):      clbTeam          UsrCheckedList 다중 → DMF0072_GET_TEAM_LIST
//   - EndCustomer (L165~178): clbEndCustomer UsrCheckedList 다중 → DMF0072_GET_END_CUSTOMER_LIST
//   - SalesSite (L186): clbSalesSite     UsrCheckedList 다중 → DMF0072_GET_SALES_SITE_LIST
//   - Project (L457): umltProject text (TODO: popup), Item (L458): umltModel text (TODO: popup)
//
// 다중 선택 패턴 원천: features/demand/src/pages/customer-fcst-upload/components/CustomerFcstUploadForm.tsx
// As-Is `clbXxx.ControlValues` = 콤마 join string → PKG_DMF0072 의 UF_FX_STRING_SPLIT 으로 split (L196~205)
export const NnMasterMappingForm = ({ onSearch }: Props) => {
  const sc = useNnMasterMappingStore(s => s.searchCondition);
  const set = useNnMasterMappingStore(s => s.setSearchCondition);

  // Project / Item 팝업 open 상태 (B-2 격차 — 사용자 요구 2026-06-02)
  // 기존 공용 modal 재사용: features/master/src/components/{projectByDivisionModal,itemByDivisionModal}/
  // ItemByDivisionModal 의 headerTitle prop 으로 'Model/Nickname Popup' 표시
  const [openProjectModal, setOpenProjectModal] = useState(false);
  const [openItemModal, setOpenItemModal] = useState(false);

  const { data: divData } = useTabProcQuery({ menuId: MENU_ID, sheetName: SHEETS.DIVISION, tabId: MENU_ID, filters: {}, enabled: true });
  const { data: dtData } = useTabProcQuery({ menuId: MENU_ID, sheetName: SHEETS.DATA_TYPE, tabId: MENU_ID, filters: {}, enabled: true });
  const { data: teamData } = useTabProcQuery({
    menuId: MENU_ID, sheetName: SHEETS.TEAM, tabId: MENU_ID,
    filters: { divisionId: sc.divisionId },
    enabled: !!sc.divisionId,
  });
  const { data: ecData } = useTabProcQuery({
    menuId: MENU_ID, sheetName: SHEETS.END_CUSTOMER, tabId: MENU_ID,
    filters: { divisionId: sc.divisionId, deptId: sc.deptId },
    enabled: !!sc.divisionId,
  });
  const { data: ssData } = useTabProcQuery({
    menuId: MENU_ID, sheetName: SHEETS.SALES_SITE, tabId: MENU_ID,
    filters: { divisionId: sc.divisionId, endCustomer: sc.endCustomer },
    enabled: !!sc.divisionId,
  });

  const divisionOptions = useMemo(() => toOptions(divData?.o_rc1 as unknown as LookupRow[] | undefined), [divData]);
  const dataTypeOptions = useMemo(() => toOptions(dtData?.o_rc1 as unknown as LookupRow[] | undefined), [dtData]);
  const teamOptions = useMemo(() => toOptions(teamData?.o_rc1 as unknown as LookupRow[] | undefined), [teamData]);
  const endCustomerOptions = useMemo(() => toOptions(ecData?.o_rc1 as unknown as LookupRow[] | undefined), [ecData]);
  const salesSiteOptions = useMemo(() => toOptions(ssData?.o_rc1 as unknown as LookupRow[] | undefined), [ssData]);

  // Division 은 필수 — 첫 옵션 자동 선택 (As-Is .cs L460 의 `if (p_division_id == "") MSG00097` 회피)
  useEffect(() => {
    if (divisionOptions.length === 0) {
      // SP 호출 실패/빈 결과 시 fallback 의 첫 값 적용
      if (!sc.divisionId && FALLBACK_ALL.length > 0) set({ divisionId: FALLBACK_ALL[0].value });
      return;
    }
    if (!divisionOptions.some(o => o.value === sc.divisionId)) {
      set({ divisionId: divisionOptions[0].value });
    }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [divisionOptions]);

  // 2단 배치 (사용자 요구 2026-06-02):
  //   상단: Data Type / Division / Team / End Customer
  //   하단: Project / Model/Nickname (Item) / Sales Site
  //   Team 가로 1.5배 + Project 가로 데이터 충분히 표시
  //   Project/Item input 옆 search button (B-2 commit 에서 popup 연동 예정)
  return (
    <div className={styles.searchBar}>
      <div className={styles.searchRow}>
        <div className={styles.field}>
          <span className={styles.fieldLabel}>Data Type</span>
          <CustomDropdown
            allOption
            options={dataTypeOptions}
            value={sc.dataTypeCode}
            onChange={(_, v) => set({ dataTypeCode: v || 'ALL' })}
            className={styles.dropdown}
          />
        </div>
        <div className={styles.field}>
          <span className={styles.fieldLabel}>Division</span>
          <CustomDropdown
            options={divisionOptions}
            value={sc.divisionId}
            onChange={(_, v) => set({ divisionId: v, deptId: 'ALL', endCustomer: 'ALL', scmSiteId: 'ALL' })}
            className={styles.dropdownDivision}
          />
        </div>
        <div className={styles.field}>
          <span className={styles.fieldLabel}>Team</span>
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            options={teamOptions}
            value={sc.deptId}
            onChange={(_, v) => set({ deptId: v || 'ALL', endCustomer: 'ALL', scmSiteId: 'ALL' })}
            className={styles.dropdownTeam}
          />
        </div>
        <div className={styles.field}>
          <span className={styles.fieldLabel}>End Customer</span>
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            options={endCustomerOptions}
            value={sc.endCustomer}
            onChange={(_, v) => set({ endCustomer: v || 'ALL', scmSiteId: 'ALL' })}
            className={styles.dropdown}
          />
        </div>
      </div>
      <div className={styles.searchRow}>
        <div className={styles.field}>
          <span className={styles.fieldLabel}>Project</span>
          <input
            className={styles.inputProject}
            value={sc.projectCode}
            onChange={e => set({ projectCode: e.target.value })}
            placeholder='Project Code / Name'
          />
          <button
            type='button'
            className={styles.searchIconActive}
            title='Project 검색'
            onClick={() => setOpenProjectModal(true)}
          >
            🔍
          </button>
        </div>
        <div className={styles.field}>
          <span className={styles.fieldLabel}>Model/Nickname</span>
          <input
            className={styles.inputModel}
            value={sc.itemId}
            onChange={e => set({ itemId: e.target.value })}
            placeholder='Model Code / Nickname'
          />
          <button
            type='button'
            className={styles.searchIconActive}
            title='Model/Nickname 검색'
            onClick={() => setOpenItemModal(true)}
          >
            🔍
          </button>
        </div>
        <div className={styles.field}>
          <span className={styles.fieldLabel}>Sales Site</span>
          <CustomDropdown
            multiple
            allOption
            useClearIcon
            options={salesSiteOptions}
            value={sc.scmSiteId}
            onChange={(_, v) => set({ scmSiteId: v || 'ALL' })}
            className={styles.dropdown}
          />
        </div>
        <button type='button' className={styles.searchButton} onClick={onSearch}>조회 (F5)</button>
      </div>

      {/* Project Popup (COM0005 공용 modal 재사용) */}
      <ProjectByDivisionModal
        open={openProjectModal}
        modalClose={() => setOpenProjectModal(false)}
        setSelectedValue={projects => {
          set({ projectCode: projects });
          setOpenProjectModal(false);
        }}
        preSearchParams={{
          divisionId: sc.divisionId,
          deptId: sc.deptId,
          endCustomer: sc.endCustomer,
          salesSite: sc.scmSiteId,
          projectCode: sc.projectCode,
          etc: 'N',
        } as never}
        callFromCell={false}
      />

      {/* Model/Nickname Popup (COM0008 ItemByDivisionModal 재사용, 헤더 명칭 변경 — 사용자 요구 2026-06-02) */}
      <ItemByDivisionModal
        open={openItemModal}
        modalClose={() => setOpenItemModal(false)}
        setSelectedValue={items => {
          set({ itemId: items });
          setOpenItemModal(false);
        }}
        preSearchParams={{
          divisionId: sc.divisionId,
          deptId: sc.deptId,
          endCustomer: sc.endCustomer,
          salesSite: sc.scmSiteId,
          projectCode: sc.projectCode,
          itemId: sc.itemId,
        } as never}
        callFromCell={false}
        headerTitle='Model/Nickname Popup'
      />
    </div>
  );
};
