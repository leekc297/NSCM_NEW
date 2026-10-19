import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef, useState } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useSaveWithValidation, useTabBtnPermissions, useTabComboQueries, useTabProcQuery } from '@shared/hooks';
import { Panel, PanelGroup, PanelSeparator } from '@shared/panel';
import { useMessageStore } from '@shared/stores';

import { DemandGroupMasterForm } from './components/DemandGroupMasterForm';
import { GroupMasterGrid } from './components/GroupMasterGrid';
import { ModelListGrid } from './components/ModelListGrid';
import {
  ACTIVE_GRID,
  COMBO_ID,
  MAIN_EDITABLE_COLUMNS,
  MENU_ID,
  MSG,
  SHEETS,
} from './demand-group-master.constants';
import type { GroupMasterRow, ModelListRow } from './demand-group-master.types';
import styles from './DemandGroupMaster.module.scss';
import { useDemandGroupMasterValidation } from './hooks/useDemandGroupMasterValidation';
import { useDemandGroupMasterStore } from './useDemandGroupMasterStore';
import { buildGridColumns } from './utils/demand-group-master.columns';
import {
  buildGroupMasterPayload,
  buildModelListPayload,
  callSaveGroupMaster,
  callSaveModelList,
} from './utils/demand-group-master.save';

export const DemandGroupMaster = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const mainGridRef = useRef<FlexGrid<GroupMasterRow>>();
  const subGridRef = useRef<FlexGrid<ModelListRow>>();
  const mainGridFilterRef = useRef<FlexGridFilter>();
  const subGridFilterRef = useRef<FlexGridFilter>();

  const initialized = useDemandGroupMasterStore(state => state.initialized);
  const filters = useDemandGroupMasterStore(state => state.filters);
  const staticColumns = useDemandGroupMasterStore(state => state.staticColumns);
  const searchParams = useDemandGroupMasterStore(state => state.searchParams);
  const openSearchArea = useDemandGroupMasterStore(state => state.openSearchArea);
  const setOpenSearchArea = useDemandGroupMasterStore(state => state.setOpenSearchArea);
  const setFilters = useDemandGroupMasterStore(state => state.setFilters);
  const setModelListFilter = useDemandGroupMasterStore(state => state.setModelListFilter);
  const fetchStaticColumns = useDemandGroupMasterStore(state => state.fetchStaticColumns);

  const [activeGrid, setActiveGrid] = useState<ACTIVE_GRID>(ACTIVE_GRID.MAIN);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const { saveWithValidation } = useSaveWithValidation();
  const { validateGroupMaster, validateModelList } = useDemandGroupMasterValidation();
  const { setToast, setAlert } = useMessageStore.getState();

  // 저장검증용 전체 그룹마스터(GroupMaster_SCP_ALL) — 그룹명 중복(기존대비) 대조 기준셋.
  const [groupMasterComboRows] = useTabComboQueries({
    filters: [{ comboId: COMBO_ID.GROUP_MASTER, mnuId: MENU_ID }],
  });

  const { data: groupData, refetch: refetchGroup } = useTabProcQuery<MENU_ID, SHEETS.GROUP_NAME>({
    menuId: MENU_ID,
    sheetName: SHEETS.GROUP_NAME,
    tabId,
    filters: filters[SHEETS.GROUP_NAME],
    enabled: !!filters[SHEETS.GROUP_NAME],
  });
  const { data: modelData, refetch: refetchModel } = useTabProcQuery<MENU_ID, SHEETS.MODEL_LIST>({
    menuId: MENU_ID,
    sheetName: SHEETS.MODEL_LIST,
    tabId,
    filters: filters[SHEETS.MODEL_LIST],
    enabled: !!filters[SHEETS.MODEL_LIST],
  });

  // itemsSource 참조 안정화 + division 변경 시 리셋(신규행 잔존 방지, SalesSite 선례).
  const groupRows = useMemo(
    () => groupData?.o_rc1 ?? [],
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [groupData, searchParams.divisionId]
  );
  const modelRows = useMemo(
    () => modelData?.o_rc1 ?? [],
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [modelData, searchParams.divisionId]
  );

  // 필수 저장검증용 Group Master 컬럼셋 — 편집범위('O') 재선언 반영본(A-01).
  //   store.staticColumns 는 전열 INPUT_TP_CD='S'(메모리 scp-sheet-columns-input-tp-all-s-edit-dead)라
  //   그대로 saveWithValidation 에 넘기면 isEditableForRow 가 GROUP_NAME* 를 편집불가로 보고 필수검증을
  //   건너뛴다(빈 그룹명 저장 통과 = 데이터 결함). 그리드와 동일하게 편집 컬럼만 'O' 로 재선언해 전달한다
  //   (셀 콤보 dataMap 은 필수검증에 불필요하므로 빈 map).
  const groupValidationColumns = useMemo(
    () => buildGridColumns(staticColumns[SHEETS.GROUP_NAME], MAIN_EDITABLE_COLUMNS, {}),
    [staticColumns]
  );

  const handleSearch = () => {
    setFilters();
    void fetchStaticColumns();
  };

  // Insert — Group Master(main) 에서만. 기본값 = 현재 조회 division/opGroup(searchParams 기준), GROUP_ID
  //   공백(SP 채번). division/opGroup 미선택이면 무시 — AS-IS cboOperationGroup 은 바인딩 후 항상 첫
  //   항목값을 보유하므로 공백 opGroup 신규행이 생기면 안 된다(OPERATION_GROUP 은 lock 컬럼이라 삽입
  //   후 편집 불가). 조회조건 컨텍스트(division+opGroup)를 신규행 필수 전제로 가드한다(C-02).
  const handleInsert = () => {
    if (activeGrid !== ACTIVE_GRID.MAIN) return;
    const grid = mainGridRef.current;
    const { divisionId: division, operationGroup } = searchParams;
    if (!grid || !division || !operationGroup) return;
    // ONLY_STOCK 기본값 미지정 — AS-IS InsertRow(cs:946-953)도 DIVISION_ID/OPERATION_GROUP/GROUP_ID 만
    //   defaultData 에 채우고 ONLY_STOCK 은 건드리지 않아 신규행에서 공란으로 남는다.
    GridAction.addRow(grid, {
      DIVISION_ID: division,
      OPERATION_GROUP: operationGroup,
      GROUP_ID: '',
      GROUP_NAME: '',
    });
  };

  // Delete — main 활성일 때만. 신규행('I') 즉시 제거 / 기존행 'D' 마킹 → SAVE 시 valid_yn='N'.
  //   Model List(sub) 는 삭제 대상 아님(AS-IS).
  const handleDelete = () => {
    if (activeGrid !== ACTIVE_GRID.MAIN) return;
    const grid = mainGridRef.current;
    if (!grid) return;
    GridAction.removeRow(grid);
  };

  const handleSave = () => {
    const mainGrid = mainGridRef.current;
    const subGrid = subGridRef.current;
    mainGrid?.finishEditing();
    subGrid?.finishEditing();

    const mainSrc = (mainGrid?.collectionView?.sourceCollection ?? []);
    const subSrc = (subGrid?.collectionView?.sourceCollection ?? []);
    const mainDirty = mainSrc.filter(r => (r as { CRUD_TYPE?: string }).CRUD_TYPE);
    const subDirty = subSrc.filter(r => (r as { CRUD_TYPE?: string }).CRUD_TYPE === CRUD_TYPE.MODIFY);

    if (mainDirty.length === 0 && subDirty.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_수정한 내용이 없습니다.') });
      return;
    }

    // 저장검증 4종(그룹명 중복 / 복수 Project 동일그룹) — 하나라도 실패면 전체 중단.
    if (mainDirty.length && !validateGroupMaster(mainDirty, groupMasterComboRows ?? [])) return;
    if (subDirty.length && !validateModelList(subDirty, subSrc)) return;

    const persist = async () => {
      let succeeded = false;
      // Group Master 저장(action I/M/D, valid_yn).
      if (mainDirty.length) {
        const payload = buildGroupMasterPayload(mainDirty);
        if (payload) {
          const res = await callSaveGroupMaster(payload);
          if (!res.ok) {
            void setAlert({ type: 'alert', content: res.message || t(MSG.SAVE_FAILED, '_저장에 실패했습니다.') });
            return;
          }
          succeeded = true;
        }
      }
      // Model List 저장(action=M 만).
      if (subDirty.length) {
        const payload = buildModelListPayload(subDirty);
        if (payload) {
          const res = await callSaveModelList(payload);
          if (!res.ok) {
            void setAlert({ type: 'alert', content: res.message || t(MSG.SAVE_FAILED, '_저장에 실패했습니다.') });
            return;
          }
          succeeded = true;
        }
      }
      if (succeeded) {
        setToast({ type: 'success', message: t(MSG.SAVED, '_성공적으로 저장되었습니다.') });
        // 저장 성공 후 재조회 — filters 불변이므로 refetch 직접 호출 허용(nscm-patterns §5-1 예외).
        await Promise.all([refetchGroup(), refetchModel()]);
      }
    };

    // 필수값(GROUP_NAME* 등) 검증 후 저장 — Group Master 대상. sub-only 편집이면 바로 저장.
    //   편집범위('O') 반영 컬럼셋(groupValidationColumns)을 넘겨야 필수검증이 살아난다(A-01).
    if (mainDirty.length) {
      saveWithValidation(mainDirty, groupValidationColumns, () => void persist());
    } else {
      void persist();
    }
  };

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
    save: hasButton('SAVE') ? handleSave : false,
    insert: hasButton('SAVE') ? handleInsert : false,
    delete: hasButton('SAVE') ? handleDelete : false,
    manual: false,
    upload: false,
  };

  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={openSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <DemandGroupMasterForm onSearch={handleSearch} />
      <SubTitle
        menuId={MENU_ID}
        grid={activeGrid === ACTIVE_GRID.MAIN ? mainGridRef : subGridRef}
        gridFilter={activeGrid === ACTIVE_GRID.MAIN ? mainGridFilterRef : subGridFilterRef}
        dataCount={activeGrid === ACTIVE_GRID.MAIN ? groupRows.length : modelRows.length}
        excelFileName='Demand Group Master'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      {/* 좌/우 2분할 — 좌 Group Master(고정폭 성향) / 우 Model List (AS-IS splitContainer Vertical). */}
      <PanelGroup className={styles.tableWrapper} orientation='horizontal'>
        <Panel defaultSize={48} minSize={25}>
          <GroupMasterGrid
            gridRef={mainGridRef}
            gridFilterRef={mainGridFilterRef}
            data={groupRows}
            onFocus={setActiveGrid}
            onRowDblClick={setModelListFilter}
          />
        </Panel>
        <PanelSeparator className={styles.splitBar} />
        <Panel defaultSize={52} minSize={25}>
          <ModelListGrid
            gridRef={subGridRef}
            gridFilterRef={subGridFilterRef}
            data={modelRows}
            onFocus={setActiveGrid}
          />
        </Panel>
      </PanelGroup>
    </>
  );
};
