import {
  AllowMerging,
  CellRange,
  CellType,
  type CellRangeEventArgs,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import { t } from '@foundation/i18n';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import { ItemByDivisionModal, OwnerModal, TeamModal, ProjectModal } from '../../../components';
import type { MODAL_OWNER } from '../../../components/ownerModal/owner-modal.constants';
import type { RESPONSE_SET } from '../sales-site-project-model.constants';
import {
  DM_PLANNER_LOCKED_BINDINGS_40,
  MAX_OWNER_COUNT,
  MENU_ID,
  MODEL_POPUP_COLUMNS,
  MODEL_POPUP_CONDITIONS,
  MODEL_POPUP_WIDTH,
  SHEETS,
  SHEET_INDEX,
  SINGLE_OWNER_DIVISIONS,
} from '../sales-site-project-model.constants';
import { useEditBaseline } from '../sales-site-project-model.editBaseline';
import { useSalesCompanyGuard } from '../sales-site-project-model.salesCompanyGuard';
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

  // Sales Company 는 그 행 Sales Site 의 후보만 허용 + 회사 커밋 시 Sales Plant 를 첫 후보로 초기화.
  //   상·하단 그리드가 같은 컬럼 메타를 쓰므로 같은 훅을 양쪽에서 부른다.
  useSalesCompanyGuard({
    gridRef,
    editTrackerRef,
    resyncRow,
    staticColumns: staticColumns[SHEETS.PRODUCTION],
    data,
  });

  // Team 셀 복사·붙여넣기 시 표시값(TEAM_NAME)에 짝이 되는 저장 키(DEPT_ID)를 함께 옮긴다.
  //   클립보드에는 셀 표시 문자열(TEAM_NAME)만 실려, 붙여넣기만으로는 DEPT_ID 가 안 따라온다
  //   (팝업 선택은 handleTeamSelected 가 둘 다 세팅하지만 복붙은 표시값만 바뀐다).
  //   복사 시점에 원본 행의 TEAM_NAME→DEPT_ID 를 기억해 두고, 붙여넣은 TEAM_NAME 으로 되찾는다.
  const copiedTeamDeptRef = useRef<Map<string, string>>(new Map());

  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    const handleCopying = (_sender: unknown, event: CellRangeEventArgs) => {
      const range = event.range;
      copiedTeamDeptRef.current.clear();
      for (let col = range.col; col <= range.col2; col += 1) {
        if (GridUtils.getBinding(grid, col) !== 'TEAM_NAME') continue;
        for (let row = range.row; row <= range.row2; row += 1) {
          const sourceRow = GridUtils.getRow(grid, row);
          const teamName = String(sourceRow?.TEAM_NAME ?? '').trim();
          if (!teamName) continue;
          copiedTeamDeptRef.current.set(teamName, String(sourceRow?.DEPT_ID ?? ''));
        }
      }
    };

    const handlePastedTeam = (_sender: unknown, event: CellRangeEventArgs) => {
      if (GridUtils.getBinding(grid, event.col) !== 'TEAM_NAME') return;
      const row = GridUtils.getRow(grid, event.row);
      if (!row) return;

      const teamName = String(row.TEAM_NAME ?? '').trim();
      let deptId = copiedTeamDeptRef.current.get(teamName);
      // 스냅샷에 없으면(외부 복사) 화면에 이미 실린 같은 TEAM_NAME 행의 DEPT_ID 로 폴백.
      if (deptId === undefined && teamName) {
        const match = data.find(item => String(item.TEAM_NAME ?? '').trim() === teamName);
        deptId = match ? String(match.DEPT_ID ?? '') : undefined;
      }
      // 빈 Team 을 붙여넣었으면 DEPT_ID 도 비운다.
      if (deptId === undefined) deptId = teamName ? String(row.DEPT_ID ?? '') : '';
      if (String(row.DEPT_ID ?? '') === deptId) return;

      editTrackerRef.current?.storeChange(row, 'DEPT_ID', row.DEPT_ID, deptId);
      row.DEPT_ID = deptId;
      resyncRow(row);
      grid.refreshRange(new CellRange(event.row, 0, event.row, -1));
    };

    // Team 셀에서 Delete/Backspace 로 값을 지울 때, 표시값(TEAM_NAME)만 지우고 짝 키(DEPT_ID)가
    //   남으면 잘못된 팀 키로 저장된다(붙여넣기와 같은 짝 유실 - handlePastedTeam 주석 참조).
    //   Team 은 표시(TEAM_NAME)와 저장(DEPT_ID)이 짝이라 반드시 둘을 함께 비운다.
    //   wijmo 기본 Delete 는 활성 셀 한 칸(TEAM_NAME)만 지우므로 캡처 단계에서 가로채 직접 처리한다.
    const handleClearTeam = (event: KeyboardEvent) => {
      if (event.key !== 'Delete' && event.key !== 'Backspace') return;
      // 편집 중(네이티브 입력)에는 편집기가 받아야 하므로 건드리지 않는다.
      if (grid.activeEditor) return;

      const selection = grid.selection;
      if (!selection || selection.col < 0) return;
      const binding = GridUtils.getBinding(grid, selection.col);
      if (binding !== 'TEAM_NAME' && binding !== 'DEPT_ID') return;

      // wijmo 기본 삭제(TEAM_NAME 한 칸)를 막는다 - 아래에서 짝을 함께 비운다.
      event.preventDefault();
      event.stopImmediatePropagation();

      const topRow = Math.min(selection.row, selection.row2);
      const bottomRow = Math.max(selection.row, selection.row2);
      for (let rowIndex = topRow; rowIndex <= bottomRow; rowIndex += 1) {
        const row = GridUtils.getRow(grid, rowIndex);
        if (!row) continue;
        if (!row.TEAM_NAME && !row.DEPT_ID) continue;

        editTrackerRef.current?.storeChange(row, 'TEAM_NAME', row.TEAM_NAME, '');
        editTrackerRef.current?.storeChange(row, 'DEPT_ID', row.DEPT_ID, '');
        row.TEAM_NAME = '';
        row.DEPT_ID = '';
        resyncRow(row);
        GridUtils.refreshRow(grid, rowIndex);
      }
    };

    grid.copying.addHandler(handleCopying);
    grid.pastedCell.addHandler(handlePastedTeam);
    grid.hostElement.addEventListener('keydown', handleClearTeam, true);
    return () => {
      grid.copying.removeHandler(handleCopying);
      grid.pastedCell.removeHandler(handlePastedTeam);
      grid.hostElement.removeEventListener('keydown', handleClearTeam, true);
    };
  }, [gridRef, data, resyncRow]);

  // Cell/Car · Cell/Module 편집 시 Module/Car 계산 + 정수 검사 — AS-IS shtMainDataModel_Changed
  //   (DMF0005_SaleSite_PjtModelMapping.cs L2674~2726) 이식. AS-IS 도 상단 그리드에만 있다.
  //   Module/Car 는 원장에 없는 값이라(조회 SP 가 Cell/Car ÷ Cell/Module 로 계산) 화면에서만 채운다.
  //   - 입력값 0 → 빈 값.
  //   - 두 칸이 다 있으면 몫이 0보다 큰 정수여야 한다. 아니면 MSG00177 문구(TO-BE MSG01192) 후 세 칸 비움.
  //     AS-IS 는 소수를 버리고 판정했지만 TO-BE 칸은 소수 입력이 되므로 소수도 정수 아님으로 막는다
  //     (사용자 결정 2026-10-14 — 문구가 "정수이여야만 합니다").
  //   - 한쪽만 있으면 Module/Car 만 비운다.
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    type Row = ResponseData<MENU_ID, SHEETS.PRODUCTION, RESPONSE_SET.PRODUCTION>;
    const toNum = (value: unknown): number | null => {
      if (value === null || value === undefined) return null;
      const text = String(value as string | number).replace(/,/g, '').trim();
      if (text === '') return null;
      const num = Number(text);
      return Number.isFinite(num) ? num : null;
    };
    const setCell = (row: Row, binding: string, value: number | null) => {
      const rec = row as unknown as Record<string, WijmoPrimitive>;
      editTrackerRef.current?.storeChange(row, binding, rec[binding], value);
      rec[binding] = value;
    };

    const applyModulePerCar = (rowIndex: number, editedBinding?: string) => {
      const row = GridUtils.getRow(grid, rowIndex) as Row | undefined;
      if (!row) return;
      const rec = row as unknown as Record<string, unknown>;
      if (editedBinding && toNum(rec[editedBinding]) === 0) setCell(row, editedBinding, null);

      const cellPerCar = toNum(rec.CELL_PER_CAR);
      const cellPerModule = toNum(rec.CELL_PER_MODULE);
      if (cellPerCar !== null && cellPerModule !== null) {
        const valid =
          Number.isInteger(cellPerCar) &&
          Number.isInteger(cellPerModule) &&
          cellPerCar > 0 &&
          cellPerModule > 0 &&
          cellPerCar % cellPerModule === 0;
        if (!valid) {
          void setAlert({
            type: 'alert',
            content: t(
              'MSG01192',
              '_Module/Car는 0보다 큰 정수이여야만 합니다. Cell/Car, Cell/Module 수량을 다시 입력 하십시오.'
            ),
          });
          setCell(row, 'CELL_PER_CAR', null);
          setCell(row, 'CELL_PER_MODULE', null);
          setCell(row, 'MODULE_PER_CAR', null);
        } else {
          setCell(row, 'MODULE_PER_CAR', cellPerCar / cellPerModule);
        }
      } else if (toNum(rec.MODULE_PER_CAR) !== null) {
        setCell(row, 'MODULE_PER_CAR', null);
      }
      resyncRow(row);
      GridUtils.refreshRow(grid, rowIndex);
    };

    const isPerCarBinding = (binding: string | null | undefined) =>
      binding === 'CELL_PER_CAR' || binding === 'CELL_PER_MODULE';

    const handleEditEnded = (_sender: unknown, event: CellRangeEventArgs) => {
      const binding = GridUtils.getBinding(grid, event.col);
      if (!isPerCarBinding(binding)) return;
      applyModulePerCar(event.row, binding as string);
    };

    // 붙여넣기는 영역 단위로 한 번 판정한다 — 두 칸을 함께 붙여넣을 때 첫 칸에서 옛 값과 엇갈려
    //   잘못 경고하지 않도록, 셀 단위(pastedCell)가 아니라 붙여넣기가 끝난 뒤(pasted) 행마다 본다.
    const handlePasted = (_sender: unknown, event: CellRangeEventArgs) => {
      const range = event.range;
      const cols: string[] = [];
      for (let col = range.leftCol; col <= range.rightCol; col += 1) {
        const binding = GridUtils.getBinding(grid, col);
        if (isPerCarBinding(binding)) cols.push(binding as string);
      }
      if (cols.length === 0) return;
      for (let rowIndex = range.topRow; rowIndex <= range.bottomRow; rowIndex += 1) {
        const row = GridUtils.getRow(grid, rowIndex) as Record<string, unknown> | undefined;
        if (!row) continue;
        // 0 정리는 붙여넣은 칸 전부에 적용하고, 경고는 행당 한 번만 나간다(applyModulePerCar 1회).
        cols.slice(1).forEach(binding => {
          if (toNum(row[binding]) === 0) setCell(row as unknown as Row, binding, null);
        });
        applyModulePerCar(rowIndex, cols[0]);
      }
    };

    grid.cellEditEnded.addHandler(handleEditEnded);
    grid.pasted.addHandler(handlePasted);
    return () => {
      grid.cellEditEnded.removeHandler(handleEditEnded);
      grid.pasted.removeHandler(handlePasted);
    };
    // data — 그리드 인스턴스가 첫 렌더 뒤에 생기므로, 위 Team 붙여넣기 핸들러와 같이 조회 때 다시 건다.
  }, [gridRef, data, resyncRow, setAlert]);

  // VMI LT 편집 시 같은 사업부 · Sales Site · Model 의 다른 프로젝트 행에도 같은 값을 넣고 수정 표시한다
  //   — AS-IS shtMainDataModel_Changed (DMF0005_SaleSite_PjtModelMapping.cs L2728~2789) 이식.
  //   VMI LT 는 원장(SCM_MST_SITE_ITEM.SCP_VMI_LT)에서 프로젝트와 무관하게 사이트 · 모델 단위로 맞추는
  //   값이라, 저장 SP 도 사업부 · 사이트 · 모델 기준으로 모든 프로젝트 행을 갱신한다(PKG_DMF0005
  //   BODY 1225~1233행). 화면에서 한 행만 고치면 저장 뒤 재조회해야 다른 행이 맞춰지고, 같은
  //   모델의 다른 행을 함께 고쳐 저장하면 행 순서대로 갱신되다 예전 값으로 되덮일 수 있었다
  //   (통합테스트 지적 2026-10-13). 여기서 같은 묶음 전부를 같은 값으로 맞춰 두면 저장 행끼리
  //   값이 같아 어느 순서로 갱신돼도 결과가 같다.
  //   - 사이트 키: 40 은 SCM_SITE_ID40, 그 외는 SCM_SITE_ID (AS-IS 와 같음). 비교는 저장 SP 와 같이
  //     대소문자 · 앞뒤 공백 무시.
  //   - AS-IS 는 같은 사이트가 이어진 구간만 훑었지만(정렬 전제), 여기서는 필터로 가려진 행까지
  //     그리드 소스 전체를 본다. 정렬 상태와 무관하게 같은 결과를 내기 위해서다.
  //   - 복사된 행은 storeChange 로 기록해 CRUD_TYPE 'M' 이 되고 저장 대상에 들어간다. 값이 이미
  //     같은 행은 건드리지 않는다.
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    type Row = ResponseData<MENU_ID, SHEETS.PRODUCTION, RESPONSE_SET.PRODUCTION>;
    const norm = (value: unknown): string =>
      String((value as string | number | null | undefined) ?? '')
        .trim()
        .toUpperCase();
    const siteOf = (rec: Record<string, unknown>): string =>
      norm(rec.DIVISION_ID) === '40'
        ? norm(rec.SCM_SITE_ID40 ?? rec.SCM_SITE_ID)
        : norm(rec.SCM_SITE_ID);

    const syncVmiLt = (rowIndex: number) => {
      const edited = GridUtils.getRow(grid, rowIndex) as Row | undefined;
      if (!edited) return;
      const editedRec = edited as unknown as Record<string, WijmoPrimitive>;
      const value = editedRec.VMI_LT;
      const division = norm(editedRec.DIVISION_ID);
      const site = siteOf(editedRec);
      const item = norm(editedRec.ITEM_ID);
      if (!site || !item) return;

      const source: Row[] = grid.collectionView?.sourceCollection ?? [];
      let touched = false;
      source.forEach(row => {
        if (row === edited) return;
        const rec = row as unknown as Record<string, WijmoPrimitive>;
        if (norm(rec.DIVISION_ID) !== division || siteOf(rec) !== site || norm(rec.ITEM_ID) !== item)
          return;
        if (String(rec.VMI_LT ?? '') === String(value ?? '')) return;
        editTrackerRef.current?.storeChange(row, 'VMI_LT', rec.VMI_LT, value);
        rec.VMI_LT = value;
        resyncRow(row);
        touched = true;
      });
      if (touched) grid.invalidate();
    };

    const handleVmiEditEnded = (_sender: unknown, event: CellRangeEventArgs) => {
      if (GridUtils.getBinding(grid, event.col) !== 'VMI_LT') return;
      syncVmiLt(event.row);
    };

    // 붙여넣기도 같은 규칙 — VMI LT 열이 포함된 영역이면 붙여넣은 행마다 묶음을 맞춘다.
    const handleVmiPasted = (_sender: unknown, event: CellRangeEventArgs) => {
      const range = event.range;
      let hasVmi = false;
      for (let col = range.leftCol; col <= range.rightCol; col += 1) {
        if (GridUtils.getBinding(grid, col) === 'VMI_LT') hasVmi = true;
      }
      if (!hasVmi) return;
      for (let rowIndex = range.topRow; rowIndex <= range.bottomRow; rowIndex += 1) {
        syncVmiLt(rowIndex);
      }
    };

    grid.cellEditEnded.addHandler(handleVmiEditEnded);
    grid.pasted.addHandler(handleVmiPasted);
    return () => {
      grid.cellEditEnded.removeHandler(handleVmiEditEnded);
      grid.pasted.removeHandler(handleVmiPasted);
    };
  }, [gridRef, data, resyncRow]);

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
    GridUtils.refreshRow(gridRef.current, clickedRow);
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

      // Team(DEPT_ID/TEAM_NAME)은 Owner 선택으로 채우지 않는다(2026-10-26 요청 — AS-IS 는 담당자 소속을
      //   넣었다). Team 은 Team 컬럼 더블클릭(TeamModal)으로만 입력하고, 비어 있으면 저장 시 필수
      //   검증(TEAM_NAME INPUT_TP_CD M)에서 막는다.
    }

    resyncRow(clickedDataItem);
    GridUtils.refreshRow(gridRef.current, clickedRow);
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
    GridUtils.refreshRow(gridRef.current, clickedRow);
  };

  const handleItemSelected = (itemCodes: string, itemName?: string, itemType?: string) => {
    if (!clickedDataItem) return;

    // 공용 Model 팝업(ItemByDivisionModal)은 Shift 범위 선택 시 ITEM_ID 를 쉼표로 이어 보낸다.
    //   이 셀은 Model 한 건만 받는 자리라 맨 위 행(selectedItems[0]) 하나만 쓴다 (2026-10-13 사용자 요청).
    //   이름·타입은 팝업이 이미 첫 행 기준으로 보내므로 그대로 쓴다. Project 팝업 핸들러와 같은 방식.
    const itemCode = itemCodes?.split(',')[0] ?? '';

    editTrackerRef.current?.storeChange(
      clickedDataItem,
      'ITEM_ID',
      clickedDataItem.ITEM_ID,
      itemCode
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
    GridUtils.refreshRow(gridRef.current, clickedRow);
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
        // 갭분석 F-23(2026-10-16): 미등록 임시 키 MSG_PURCHASE_EDITING 대신 같은 뜻으로 KO/EN/CN 등록된
        //   MSG01148 '{0}를 수정 중이어서 조회를 할 수 없습니다.'({0}=Purchase)를 쓴다.
        content: t('MSG01148', '_{0}를 수정 중이어서 조회를 할 수 없습니다.').replace('{0}', 'Purchase'),
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

  // 40 DM Planner 칸 잠금 (갭분석 F-26) — EDIT_FLAG3='Y' 인 기존 행의 10칸(DM_PLANNER_LOCKED_BINDINGS_40)은 편집 · 붙여넣기 · 지우기 불가, 편집색도 뺀다.
  //   공용 판정(GridUtils.isEditableCell)은 행 단위 EDIT_FLAG 만 보므로 칸 단위 잠금은 화면이 맡는다.
  //   필수: 공용 DataGrid 의 편집 판정 핸들러(그리드 생성 시 등록)보다 뒤에 등록돼야 cancel 이 덮이지 않는다 —
  //   그래서 initialized 가 아니라 이 effect 에서 붙인다(NnMasterMappingGrid 와 같은 순서 전제).
  //   신규 행(CRUD_TYPE='I')은 SP 가 EDIT_FLAG3 을 주지 않아 대상이 아니다(AS-IS 도 InsertRowLockRangeMain40 별도).
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const isLocked = (row: number, col: number) => {
      const item = GridUtils.getRow(grid, row) as WijmoRowItem | undefined;
      if (!item || item.DIVISION_ID !== '40' || item.EDIT_FLAG3 !== 'Y') return false;
      if (item.CRUD_TYPE === CRUD_TYPE.INSERT) return false;
      return DM_PLANNER_LOCKED_BINDINGS_40.has(String(GridUtils.getBinding(grid, col) ?? ''));
    };
    const cancelIfLocked = (_: FlexGrid, e: CellRangeEventArgs) => {
      if (isLocked(e.row, e.col)) e.cancel = true;
    };
    const unmarkLocked = (_: FlexGrid, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      if (isLocked(e.row, e.col)) e.cell.classList.remove('wj-cell-editable');
    };
    grid.beginningEdit.addHandler(cancelIfLocked);
    grid.pastingCell.addHandler(cancelIfLocked);
    grid.formatItem.addHandler(unmarkLocked);
    grid.invalidate();
    return () => {
      grid.beginningEdit.removeHandler(cancelIfLocked);
      grid.pastingCell.removeHandler(cancelIfLocked);
      grid.formatItem.removeHandler(unmarkLocked);
    };
  }, [gridRef, data]);

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
        // 인원 상한 10명 — Owner·Owner(PM) 공통. 팝업이 OK 시점에 막고 열어 둔다 (2026-10-13 사용자 요청).
        maxSelect={MAX_OWNER_COUNT}
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
