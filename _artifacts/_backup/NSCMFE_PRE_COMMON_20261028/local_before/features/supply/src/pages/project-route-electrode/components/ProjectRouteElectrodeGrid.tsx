import {
  CellType,
  DataMap,
  type CellRangeEventArgs,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { ComboResponse, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import {
  ALL_SENTINEL,
  ALWAYS_LOCKED_COLUMNS,
  COMBO,
  INVALID_CELL_BG_COLOR,
  LOCK_ON_ELECTRODE_EXISTING,
  LOCK_ON_NON_ELECTRODE,
  MSG,
  OPERATION_GROUP_ELECTRODE,
} from '../project-route-electrode.constants';
import type { MainRow } from '../project-route-electrode.types';
import { deriveTactTimeFlag } from '../utils/projectRouteElectrode.derive';

interface Props {
  gridRef: MutableRefObject<FlexGrid<MainRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<MainRow> | undefined>;
  data: MainRow[];
  staticColumns: RawFlexGridColumnConfig[];
  // 조회조건 division — 셀 콤보(PLANT_SITE_ID) 재조회 bind + 신규행 DIVISION_ID 기본.
  divisionId: string;
  // Edit 토글(R-EDIT-TOGGLE) — false 면 전 셀 편집 잠금. true 라도 R-LOCK-*·ALWAYS_LOCKED 는 개별 잠금.
  editMode: boolean;
  // 저장검증 실패 셀(design/03 §3-4). dataItem 참조 + 컬럼 binding 으로 식별해 배경 강조.
  invalidCells: { row: MainRow; column: string }[];
  // ITEM_ID 셀 더블클릭 → ElectrodeItembyDivisionPopup(R-DBLCLICK). div=81 SalesSite 셀 팝업은 없음.
  onItemCellDblClick: (row: MainRow) => void;
  gotFocus?: () => void;
}

// SCP0027 단일 그리드(spdMain) — 31 컬럼 DB 메타 구동. 편집은 조건부(R-LOCK-*), 파생 R-DIV-CLEAR 등.
//   셀콤보: VALID_YN(정적 YesOrNo 자동) / PLANT_SITE_ID(ElecRoutePlantByOperation_SCP 3-bind,
//   comboParams re-seat) / DIVISION_ID(신규행 전용 MyDivision, getDisplayValues insert-only).
export const ProjectRouteElectrodeGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
  staticColumns,
  divisionId,
  editMode,
  invalidCells,
  onItemCellDblClick,
  gotFocus,
}: Props) => {
  const { t } = useTranslation();
  const { setAlert } = useMessageStore.getState();

  // DIVISION_ID 신규행 전용 콤보(design/03 §3-3 R-COMBO-DIV) — MyDivision 사전로드. MyDivision SQL 이
  //   ATTRIBUTE3<>'EE'+권한을 내재하나, 셀콤보는 @mnuId 토큰 미주입 경로일 수 있어 화면단에서 EE 를
  //   한번 더 제외해 안전하게 둔다(자매 SCP0048 준용). 메타에 없는 코드 콤보라 FE 가 DataMap 을 만들어
  //   컬럼에 붙인다. getDisplayValues 를 덮어 신규행(CRUD_TYPE='I')에서만 후보를 노출하고 조회행은 빈
  //   후보(편집불가 동등)로 둔다(insert-only 하드코딩 패턴, [[insert-only-combo-hardcode]]). PARAM9 메타 금지.
  const [myDivisionRaw] = useTabComboQueries({ filters: [COMBO.CELL_DIVISION] });

  // PLANT_SITE_ID 셀 콤보(design/03 §3-3 R-COMBO-PLANT). bind @divisionId·@operationGroup·@itemId.
  //   AS-IS 는 셀 진입 시점의 행 DIVISION_ID/ITEM_ID/opGroup 으로 재조회하나(행별), 정적 콤보 메타로는
  //   행별 재조회를 표현할 수 없어(04_react-gap GAP) 조회조건 division 을 공통 bind 로 실어 re-seat 한다.
  //   R-COMBO-PLANT narrow 는 OPERATION_GROUP='E' 고정(전극 전용 화면)이라 operationGroup 은 'E' bind.
  //   값은 홑따옴표 규약([[grid-combo-division-param]], makeComboQuery @토큰 치환).
  //   ElecRoutePlantByOperation_SCP SQL 은 @divisionId 를 리터럴 INSTR 로 매칭(ALL→NULL 치환 없음)하므로,
  //   조회조건 division 이 ALL 이면 권한 division 코드 전체 CSV 로 펼쳐 bind 한다(Form.plantSiteDivisionFilter 와 동일).
  const comboDivisionId = useMemo(() => {
    if (divisionId && divisionId !== ALL_SENTINEL) return divisionId;
    return (myDivisionRaw ?? [])
      .filter((r: ComboResponse) => String(r.ATTRIBUTE3 ?? '') !== 'EE')
      .map((r: ComboResponse) => String(r.CODE ?? ''))
      .filter(Boolean)
      .join(',');
  }, [divisionId, myDivisionRaw]);
  const comboParams = useMemo(
    () => ({
      divisionId: `'${comboDivisionId}'`,
      operationGroup: `'${OPERATION_GROUP_ELECTRODE}'`,
      itemId: '\'\'',
    }),
    [comboDivisionId]
  );
  const divisionDataMap = useMemo(() => {
    const rows = (myDivisionRaw ?? []).filter(
      (r: ComboResponse) => String(r.ATTRIBUTE3 ?? '') !== 'EE'
    );
    if (rows.length === 0) return null;
    const map = new DataMap(rows, 'CODE', 'NAME');
    const allDisplayValues = map.getDisplayValues.bind(map) as (item?: unknown) => string[];
    map.getDisplayValues = (item?: unknown): string[] => {
      const all = [...new Set(allDisplayValues(item))];
      // 행 컨텍스트 없는 호출(필터 패널 등)은 전체 유지 — 비우면 필터가 죽는다.
      if (!item) return all;
      return (item as MainRow).CRUD_TYPE === 'I' ? all : [];
    };
    return map;
  }, [myDivisionRaw]);

  // DIVISION_ID 컬럼에 신규행 전용 DataMap 부착(DataGrid 가 컬럼을 (재)생성할 때마다 재부착).
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid || !divisionDataMap) return;
    const attach = () => {
      const col = grid.getColumn('DIVISION_ID');
      if (col && col.dataMap !== divisionDataMap) col.dataMap = divisionDataMap;
    };
    grid.updatedLayout.addHandler(attach);
    attach();
    return () => {
      try {
        grid.updatedLayout.removeHandler(attach);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, divisionDataMap]);

  // 조건부 편집 잠금(design/03 §3-1). INPUT_TP_CD 전건 'S' 라 메타로 표현 불가 → beginningEdit
  //   override(GAP). R-EDIT-TOGGLE(off → 전잠금) / ALWAYS_LOCKED(감사·파생·키·조회행 DIVISION) /
  //   R-LOCK-EXIST-ROW(opGroup≠"E" → PLANT_SITE_ID·PRIORITY~TO_YYYYMMDD) /
  //   opGroup="E" & PRIORITY_SEQ≠"" 기존행 → PLANT_SITE_ID 잠금. 신규행(CRUD_TYPE='I')은
  //   DIVISION_ID 편집 허용(R-COMBO-DIV).
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const alwaysLocked: readonly string[] = ALWAYS_LOCKED_COLUMNS;
    const lockNonElectrode: readonly string[] = LOCK_ON_NON_ELECTRODE;
    const lockElectrodeExisting: readonly string[] = LOCK_ON_ELECTRODE_EXISTING;
    const beginningEditHandler = (
      s: FlexGrid<MainRow>,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      if (!editMode) {
        e.cancel = true;
        return;
      }
      const binding = s.columns[e.col]?.binding ?? '';
      const row = s.rows[e.row]?.dataItem as MainRow | undefined;
      const isInsert = row?.CRUD_TYPE === 'I';
      // 신규행은 DIVISION_ID 편집 허용, 그 외(조회행)는 ALWAYS_LOCKED 로 항상 잠금.
      if (binding === 'DIVISION_ID') {
        if (!isInsert) e.cancel = true;
        return;
      }
      if (alwaysLocked.includes(binding)) {
        e.cancel = true;
        return;
      }
      const opGroup = String(row?.OPERATION_GROUP ?? '');
      const prioritySeq = String(row?.PRIORITY_SEQ ?? '');
      // R-LOCK-EXIST-ROW — 전극 아닌 행: PLANT_SITE_ID·PRIORITY~TO_YYYYMMDD 잠금.
      if (opGroup !== OPERATION_GROUP_ELECTRODE && lockNonElectrode.includes(binding)) {
        e.cancel = true;
        return;
      }
      // 전극 기존행(PRIORITY_SEQ 존재): PLANT_SITE_ID 잠금(신규행만 PlantSite 편집).
      if (
        opGroup === OPERATION_GROUP_ELECTRODE &&
        prioritySeq !== '' &&
        lockElectrodeExisting.includes(binding)
      ) {
        e.cancel = true;
      }
    };
    grid.beginningEdit.addHandler(beginningEditHandler);
    return () => {
      try {
        grid.beginningEdit.removeHandler(beginningEditHandler);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, editMode]);

  // 저장검증 실패 셀 배경 강조(design/03 §3-4, AS-IS SetBGColor(InvalidColor)).
  //   뷰행 index 로 DOM 을 직접 칠하면 스크롤 시 셀 DOM 이 재활용돼 강조가 어긋난다 → formatItem 이
  //   재도색할 때마다 dataItem 참조 + 컬럼 binding 으로 다시 판정한다.
  //   effect 클로저가 최신 invalidCells 를 보도록 ref 로 보관하고, 값이 바뀌면 invalidate 로 재도색한다.
  const invalidCellsRef = useRef(invalidCells);
  invalidCellsRef.current = invalidCells;
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const handler = (s: FlexGrid<MainRow>, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = s.columns[e.col]?.binding;
      if (!binding) return;
      const dataItem = GridUtils.getRow(s, e.row) as MainRow | undefined;
      if (!dataItem) return;
      // 매칭 시 배경 강조, 아니면 해제(셀 DOM 재사용 대비 항상 재설정).
      const isInvalid = invalidCellsRef.current.some(
        c => c.row === dataItem && c.column === binding
      );
      e.cell.style.backgroundColor = isInvalid ? INVALID_CELL_BG_COLOR : '';
    };
    grid.formatItem.addHandler(handler);
    grid.invalidate();
    return () => {
      try {
        grid.formatItem.removeHandler(handler);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, invalidCells]);

  // 파생(design/03 §3-2). R-TACT(PLANT_SITE_ID→TACT_TIME_FLAG last-char) / R-VALID(되돌림 + alert) /
  //   R-DIV-CLEAR(DIVISION_ID 변경 → PLANT_SITE_ID clear). R-ITEM-NICK(NICK_NAME)은 팝업 반환값이라
  //   page 의 onItemCellDblClick 결과 처리에서 세팅한다.
  const handleCellEdit = (grid: FlexGrid<MainRow>, e: CellRangeEventArgs) => {
    const binding = grid.columns[e.col]?.binding;
    const dataItem = GridUtils.getRow(grid, e.row);
    if (!binding || !dataItem) return;
    const record = dataItem as Record<string, unknown>;

    // R-VALID — VALID_YN 을 opGroup≠E 행에서 'Y' 로 바꾸려 하고 원본(ORG_VALID_YN)이 'N' 이면
    //   수정 불가로 'N' 되돌림 + MSG.VALID_REVERT. 전극(E) 행은 자유 편집.
    if (binding === 'VALID_YN') {
      const opGroup = String(record.OPERATION_GROUP ?? '');
      const orgValidYn = String(record.ORG_VALID_YN ?? '');
      if (
        opGroup !== OPERATION_GROUP_ELECTRODE &&
        String(record.VALID_YN ?? '') === 'Y' &&
        orgValidYn === 'N'
      ) {
        editTrackerRef.current?.storeChange(dataItem, 'VALID_YN', 'Y', 'N');
        record.VALID_YN = 'N';
        GridUtils.refreshRow(grid, e.row);
        void setAlert({
          type: 'alert',
          content: t(MSG.VALID_REVERT, '_Valid 값을 수정할 수 없습니다.'),
        });
      }
      return;
    }

    // R-TACT — PLANT_SITE_ID 선택 시 표시문자열 마지막문자 = TACT_TIME_FLAG.
    if (binding === 'PLANT_SITE_ID') {
      const flag = deriveTactTimeFlag(record.PLANT_SITE_ID);
      editTrackerRef.current?.storeChange(
        dataItem,
        'TACT_TIME_FLAG',
        record.TACT_TIME_FLAG as string,
        flag
      );
      record.TACT_TIME_FLAG = flag;
      GridUtils.refreshRow(grid, e.row);
      return;
    }

    // R-DIV-CLEAR — DIVISION_ID 변경 시 PLANT_SITE_ID clear(design/03 §3-2, cs:777). SCP0048 과 달리
    //   ITEM_ID/NICK_NAME 은 clear 하지 않는다(AS-IS spdMain_Change 가 PlantSite 만 초기화).
    if (binding === 'DIVISION_ID') {
      editTrackerRef.current?.storeChange(
        dataItem,
        'PLANT_SITE_ID',
        record.PLANT_SITE_ID as string,
        ''
      );
      record.PLANT_SITE_ID = '';
      GridUtils.refreshRow(grid, e.row);
    }
  };

  // 더블클릭 팝업(design/03 R-DBLCLICK). ITEM_ID → ElectrodeItembyDivisionPopup. Rows<=0 무반응.
  //   div=81 SalesSite 셀 팝업은 이 화면에 없음(전극 전용).
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid || grid.rows.length <= 0) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell || ht.row < 0) return;
    const binding = grid.columns[ht.col]?.binding ?? '';
    const row = grid.rows[ht.row]?.dataItem as MainRow | undefined;
    if (!row) return;
    if (binding === 'ITEM_ID') onItemCellDblClick(row);
  };

  return (
    <DataGrid<MainRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns}
      comboParams={comboParams}
      cellEditEnded={handleCellEdit}
      dblClick={handleDblClick}
      gotFocus={gotFocus}
    />
  );
};
