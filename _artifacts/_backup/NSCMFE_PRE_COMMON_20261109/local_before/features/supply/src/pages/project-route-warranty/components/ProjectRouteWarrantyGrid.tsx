import { DataType } from '@mescius/wijmo';
import {
  CellType,
  DataMap,
  type CellRangeEventArgs,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useCallback, useEffect, useMemo, useRef } from 'react';

import type { ComboResponse, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import {
  COMBO,
  DIVISION_82,
  INVALID_CELL_BG_COLOR,
  isSalesSitePopupDivision,
  LOCK_ON_NON_WARRANTY,
  LOCK_ON_WARRANTY_EXISTING,
  MSG,
  NO_VALUE_PLACEHOLDER,
  OPERATION_GROUP_WARRANTY,
  POPUP_ONLY_COLUMNS,
} from '../project-route-warranty.constants';
import type { MainRow } from '../project-route-warranty.types';
import { deriveTactTimeFlag } from '../utils/projectRouteWarranty.derive';

interface Props {
  gridRef: MutableRefObject<FlexGrid<MainRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<MainRow> | undefined>;
  data: MainRow[];
  staticColumns: RawFlexGridColumnConfig[];
  // 저장검증 실패 셀(design/03 §3.4 R-B1/R-B2). dataItem 참조 + 컬럼 binding 으로 식별해 배경 강조.
  invalidCells: { row: MainRow; column: string }[];
  // ITEM_ID 셀 더블클릭 → Item 팝업(R-D8). div=81 SCM_SITE_ID/PROJECT_CODE 셀 → SalesSite 팝업(R-D6).
  onItemCellDblClick: (row: MainRow) => void;
  onSalesSiteCellDblClick: (row: MainRow) => void;
  gotFocus?: () => void;
}

// FROM/TO_YYYYMMDD 날짜 컬럼 — 이 화면만 YYYY-MM-DD(설계 03 §표시, AS-IS 는 '-' strip 전 대시 표기).
//   admin 메타가 FPDate 라 columnMapping 이 InputDate(달력) 에디터를 붙이지만 dataType 을 비워 둬
//   달력이 Date 값에 못 묶이고, 공용 getFormat 은 전역 yyyy.MM.dd(점)를 적용해 편집 후 셀이 점
//   구분자로 튄다(2026-10-16 사용자 신고). 공용 수정은 범위가 너무 넓어(전 화면 날짜) 하지 않고,
//   페이지(mainRows)에서 값을 Date 로 변환한 뒤 여기서 두 컬럼의 dataType=Date + format='yyyy-MM-dd'
//   를 명시해 (a) 달력 편집 정상 (b) 조회·편집 모두 YYYY-MM-DD 표시를 함께 해결한다
//   (precede-safety-stock-day 검증 패턴). updatedLayout 마다 재적용(columnGroups 재대입으로
//   리셋될 수 있음, 이미 설정돼 있으면 건너뛰어 재귀 invalidate 방지).
const DATE_COLUMNS = ['FROM_YYYYMMDD', 'TO_YYYYMMDD'];
const applyDateColumnTypes = (g: FlexGrid): void => {
  for (const binding of DATE_COLUMNS) {
    const col = g.getColumn(binding);
    if (!col) continue;
    if (col.dataType !== DataType.Date) col.dataType = DataType.Date;
    if (col.format !== 'yyyy-MM-dd') col.format = 'yyyy-MM-dd';
  }
};

// SCP0048 단일 그리드(spdMain) — 31 컬럼 DB 메타 구동. 편집은 조건부(R-L1~R-L5), 파생 R-D1~D8.
//   셀콤보: VALID_YN(정적 YesOrNo 자동) / PLANT_SITE_ID(ElecRoutePlantByOperation_SCP, 행 파라미터
//   콤보 PARAM10='D' — 행 DIVISION_ID/ITEM_ID/OPERATION_GROUP 으로 행별 재조회) / DIVISION_ID(신규행
//   전용 MyDivision, getDisplayValues insert-only).
export const ProjectRouteWarrantyGrid = ({
  gridRef,
  gridFilterRef,
  editTrackerRef,
  data,
  staticColumns,
  invalidCells,
  onItemCellDblClick,
  onSalesSiteCellDblClick,
  gotFocus,
}: Props) => {
  const { t } = useTranslation();
  const { setAlert } = useMessageStore.getState();

  // DIVISION_ID 신규행 전용 콤보(design/03 §3.1 R-C1) — MyDivision(ATTRIBUTE3<>'EE') 사전로드.
  //   메타에 없는 코드 콤보라 FE 가 DataMap 을 만들어 컬럼에 붙인다. getDisplayValues 를 덮어
  //   신규행(CRUD_TYPE='I')에서만 후보를 노출하고 조회행은 빈 후보(편집불가 동등)로 둔다
  //   (insert-only 하드코딩 패턴, sales-plan.gridCombos 준용). PARAM9 메타 금지.
  const [myDivisionRaw] = useTabComboQueries({ filters: [COMBO.CELL_DIVISION] });

  // PLANT_SITE_ID 셀 콤보(design/03 §3.1 R-C2~C5)는 컬럼 메타 PARAM10='D' 행 파라미터 콤보로 배선한다
  //   (06_plant_site_combo_meta.sql). PARAM2 `DIVISION_ID:divisionId,ITEM_ID:itemId,
  //   OPERATION_GROUP:operationGroup` 로 "그 행" 값을 ElecRoutePlantByOperation_SCP 의
  //   @divisionId·@itemId·@operationGroup 에 실어 행별로 재조회한다(useRowParamCombos). DataGrid 가
  //   staticColumns 메타만으로 구동하므로 여기서 comboParams 를 넘길 필요가 없다.
  //   이 화면은 Warranty 전용이라 편집 가능 행의 OPERATION_GROUP 은 항상 'W'(handleInsert 고정,
  //   P/A insert 차단) → 행 opGroup bind 가 R-C3 의 'W' 고정과 동치다.
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
  //   DIVISION_ID 는 메타상 콤보가 아니므로(CELL_CONTROL_OBJECT_TYPE_CODE 공백) DataGrid 의
  //   applyComboDataMaps 가 손대지 않는다 — 이 DataMap 은 화면만 관리한다.
  //
  //   주의: 이 부착을 divisionDataMap 변경 effect 안에서만 하면 안 된다. 콤보가 캐시(gcTime 8h,
  //   IndexedDB 영속)에서 즉시 resolve 되는 재마운트에선 divisionDataMap 이 첫 렌더부터 non-null 이라
  //   effect 가 grid 생성(비동기 wijmo mount) 전에 1회 돌고 gridRef.current===undefined 로 빠져나간
  //   뒤 deps 불변이라 재실행되지 않는다 — 셀이 코드("81")만 뜨고 드롭다운이 안 열린다(2026-10-05 실사고).
  //   그래서 부착을 (1) DataGrid 의 initialized(내부 셋업 완료 후 1회 호출, grid 확정) + updatedLayout
  //   재부착과 (2) 콤보가 뒤늦게 도착하는 경우를 위한 divisionDataMap 변경 effect 두 경로로 건다.
  //   최신 맵은 ref 로 미러해 두 경로가 같은 값을 본다.
  const divisionDataMapRef = useRef(divisionDataMap);
  divisionDataMapRef.current = divisionDataMap;
  const attachDivisionDataMap = useCallback((grid: FlexGrid<MainRow>) => {
    const map = divisionDataMapRef.current;
    if (!map) return;
    const col = grid.getColumn('DIVISION_ID');
    if (col && col.dataMap !== map) col.dataMap = map;
  }, []);

  // 저장검증 실패 셀 집합(design/03 §3.4 R-B1/R-B2) — formatItem 클로저가 최신값을 보도록 ref 로 보관.
  //   값이 바뀌면 아래 effect 가 invalidate 로 재도색한다.
  const invalidCellsRef = useRef(invalidCells);
  invalidCellsRef.current = invalidCells;

  // formatItem 핸들러 — DIVISION_ID 조회행 코드표시(AS-IS SCP0048.cs:453) + 저장검증 실패 셀 배경강조.
  //   s/e 는 핸들러 호출마다 들어오므로 클로저 캡처는 invalidCellsRef(최신 invalidCells) 뿐이다.
  const formatItemHandler = useCallback((s: FlexGrid<MainRow>, e: FormatItemEventArgs) => {
    if (e.panel.cellType !== CellType.Cell) return;
    const binding = s.columns[e.col]?.binding;
    if (!binding) return;
    const dataItem = GridUtils.getRow(s, e.row) as MainRow | undefined;
    if (!dataItem) return;
    // DIVISION_ID 표시 분기(AS-IS SCP0048.cs:453) — 신규행만 콤보 셀(NAME), 조회행은 코드값.
    //   DataMap 은 신규행 드롭다운/편집용으로 컬럼에 붙어 있어 조회행 셀도 CODE→NAME 으로 그려진다.
    //   AS-IS 는 기존행 DIVISION_ID 를 일반 텍스트 셀로 둬 코드 원문만 보인다 → 조회행은 셀 텍스트를
    //   원본 코드로 되돌린다(신규행은 DataMap 매핑 NAME 그대로).
    if (binding === 'DIVISION_ID' && dataItem.CRUD_TYPE !== 'I') {
      e.cell.textContent = String(dataItem.DIVISION_ID ?? '');
    }
    // 매칭 시 배경 강조, 아니면 해제(셀 DOM 재사용 대비 항상 재설정).
    const isInvalid = invalidCellsRef.current.some(
      c => c.row === dataItem && c.column === binding
    );
    e.cell.style.backgroundColor = isInvalid ? INVALID_CELL_BG_COLOR : '';
  }, []);

  // 그리드 생성 시 1회(initialized, grid 확정 보장) — 모든 셀 렌더링 훅을 여기서 건다.
  //   주의: 이들을 useEffect([gridRef])로 걸면 안 된다. gridRef.current 는 wijmo 비동기 mount 라
  //   첫 pass 에서 undefined → early-return 하고, ref deps 는 안 바뀌어 재실행되지 않는다
  //   (DIVISION_ID DataMap·날짜·formatItem 모두 같은 함정 — 2026-10-05/2026-10-16 실사고).
  //   initialized 는 grid 확정 후 1회 호출이 보장돼 여기서 붙여야 확실하다.
  //   (a) DIVISION_ID 신규행 DataMap 재부착(updatedLayout 마다 — columnGroups 재대입이 지움)
  //   (b) FROM/TO dataType=Date + format='yyyy-MM-dd'(updatedLayout 마다 재적용)
  //   (c) formatItem(DIVISION_ID 코드표시 + 저장검증 실패 배경).
  const handleGridInitialized = useCallback(
    (grid: FlexGrid<MainRow>) => {
      grid.updatedLayout.addHandler(() => attachDivisionDataMap(grid));
      attachDivisionDataMap(grid);
      grid.updatedLayout.addHandler(applyDateColumnTypes);
      applyDateColumnTypes(grid);
      grid.formatItem.addHandler(formatItemHandler);
    },
    [attachDivisionDataMap, formatItemHandler]
  );
  // 콤보가 grid mount 이후 도착하는 경우 — 변경 시 즉시 DataMap 부착.
  useEffect(() => {
    const grid = gridRef.current;
    if (grid && divisionDataMap) attachDivisionDataMap(grid);
  }, [gridRef, divisionDataMap, attachDivisionDataMap]);

  // 조건부 편집 잠금(design/03 §3.3)은 beginningEdit 로 배선한다(GAP-4). 단방향(잠그기만)이다 —
  //   공용 DataGrid(setEditableColumns)의 기본 편집게이트가 이 화면보다 먼저 등록돼 메타
  //   INPUT_TP_CD 로 cancel 을 세워 둔다(SCM_MST_SHEET_COLUMNS 실측: S 22 / IM 3(DIVISION_ID·ITEM_ID·
  //   PLANT_SITE_ID) / IO 2(SCM_SITE_ID·PROJECT_CODE) / M 4(FROM/TO_YYYYMMDD·PRIORITY·VALID_YN)).
  //   S=cancel, IM/IO=insert 행만 허용, M=편집 허용. 여기서 다시 cancel=false 로 되돌리면 admin 메타를
  //   화면이 덮어쓰는 셈이라(CLAUDE.md §2 속성 단위 덮어쓰기 금지) 절대 하지 않는다 — 공용 게이트가
  //   이미 막은 셀(e.cancel===true)은 그대로 둔다. 화면은 메타로 표현 못하는 "행-조건부/팝업전용"
  //   잠금만 추가로 건다: R-C5(div=82 PLANT_SITE 비움) / 팝업전용(ITEM_ID·SCM_SITE_ID·PROJECT_CODE
  //   키인 금지) / R-L2(opGroup≠"W" → PLANT_SITE_ID~VALID_YN) / R-L3(W & PRIORITY_SEQ≠"" 기존행 →
  //   PLANT_SITE_ID~PROJECT_CODE). DIVISION_ID insert-only·S 컬럼 잠금은 메타(IM/S)가 이미 처리한다.
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const lockNonWarranty: readonly string[] = LOCK_ON_NON_WARRANTY;
    const lockWarrantyExisting: readonly string[] = LOCK_ON_WARRANTY_EXISTING;
    const popupOnly: readonly string[] = POPUP_ONLY_COLUMNS;
    const beginningEditHandler = (s: FlexGrid<MainRow>, e: { cancel: boolean; row: number; col: number }) => {
      // 공용 게이트가 메타(INPUT_TP_CD)로 이미 막은 셀은 그대로 둔다 — 화면은 추가로 잠그기만.
      if (e.cancel) return;
      const binding = s.columns[e.col]?.binding ?? '';
      const row = s.rows[e.row]?.dataItem as MainRow | undefined;
      // 팝업 전용 셀(ITEM_ID/SCM_SITE_ID/PROJECT_CODE)은 키인 편집기를 열지 않는다 — 값 입력은
      //   더블클릭 팝업(handleDblClick)으로만. 신규행에서 R-L2/R-L3 에 안 걸려도 항상 잠근다.
      if (popupOnly.includes(binding)) {
        e.cancel = true;
        return;
      }
      // R-C5 — division=="82" 행은 PLANT_SITE_ID 콤보를 비운다(AS-IS .cs 993/994 CellClick).
      //   후보가 비는 것과 동등하게, 82 행에서는 PLANT_SITE_ID 편집기(행 파라미터 콤보) 자체를
      //   열지 않는다. 82 는 SITE 에 PLANT 행이 존재해도(콤보 SQL 은 반환) Warranty plant-site
      //   선택 대상이 아닌 사업부라, 메타 PARAM10='D' 재조회로는 표현되지 않는 FE 업무규칙이다.
      if (binding === 'PLANT_SITE_ID' && String(row?.DIVISION_ID ?? '') === DIVISION_82) {
        e.cancel = true;
        return;
      }
      const opGroup = String(row?.OPERATION_GROUP ?? '');
      const prioritySeq = String(row?.PRIORITY_SEQ ?? '');
      // R-L2 — Warranty 아닌 행: PLANT_SITE_ID~VALID_YN 잠금.
      if (opGroup !== OPERATION_GROUP_WARRANTY && lockNonWarranty.includes(binding)) {
        e.cancel = true;
        return;
      }
      // R-L3 — Warranty 기존행(PRIORITY_SEQ 존재): PLANT_SITE_ID~PROJECT_CODE 잠금.
      if (
        opGroup === OPERATION_GROUP_WARRANTY &&
        prioritySeq !== '' &&
        lockWarrantyExisting.includes(binding)
      ) {
        e.cancel = true;
        return;
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
  }, [gridRef]);

  // 저장검증 실패 셀 집합이 바뀌면 재도색(formatItemHandler 가 invalidCellsRef 로 최신값을 읽어
  //   다시 판정한다 — DOM 직접 칠하기는 스크롤 시 셀 재활용으로 어긋난다, BodGrid saveError 패턴 준용).
  useEffect(() => {
    gridRef.current?.invalidate();
  }, [gridRef, invalidCells]);

  // 파생(design/03 §3.2). PLANT_SITE_ID 변경 → TACT_TIME_FLAG(R-D1, last-char). VALID_YN 되돌림은
  //   MSG.VALID_REVERT alert 를 내야 해 여기서는 값 복원만 하지 않고 파생만 담당한다 —
  //   R-D3(되돌림)·R-D4(DIVISION 변경 clear)는 값 세팅 + alert 조합이라 handleCellEdit 에서 처리한다.
  const handleCellEdit = (grid: FlexGrid<MainRow>, e: CellRangeEventArgs) => {
    const binding = grid.columns[e.col]?.binding;
    const dataItem = GridUtils.getRow(grid, e.row);
    if (!binding || !dataItem) return;
    const record = dataItem as Record<string, unknown>;

    // R-D3 — VALID_YN 을 opGroup≠W 행에서 'Y' 로 바꾸려 하고 원본(ORG_VALID_YN)이 'N' 이면
    //   수정 불가로 'N' 되돌림 + MSG.VALID_REVERT. Warranty(W) 행은 자유 편집.
    if (binding === 'VALID_YN') {
      const opGroup = String(dataItem.OPERATION_GROUP ?? '');
      const orgValidYn = String(dataItem.ORG_VALID_YN ?? '');
      if (opGroup !== OPERATION_GROUP_WARRANTY && String(dataItem.VALID_YN ?? '') === 'Y' && orgValidYn === 'N') {
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

    // R-D1 — PLANT_SITE_ID 선택 시 표시문자열 마지막문자 = TACT_TIME_FLAG.
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

    // R-D4 — DIVISION_ID 변경 시 PLANT_SITE_ID/ITEM_ID/NICK_NAME clear, SCM_SITE_ID/PROJECT_CODE 는
    //   비-81 이면 "없는 값"(NO_VALUE_PLACEHOLDER='/', R-D5). div=81 이면 팝업으로 채우므로 여기선 clear 만.
    if (binding === 'DIVISION_ID') {
      const clears: [string, string][] = [
        ['PLANT_SITE_ID', ''],
        ['ITEM_ID', ''],
        ['NICK_NAME', ''],
      ];
      const div = String(dataItem.DIVISION_ID ?? '');
      if (!isSalesSitePopupDivision(div)) {
        clears.push(
          ['SCM_SITE_ID', NO_VALUE_PLACEHOLDER],
          ['PROJECT_CODE', NO_VALUE_PLACEHOLDER]
        );
      }
      for (const [col, val] of clears) {
        editTrackerRef.current?.storeChange(dataItem, col, record[col] as string, val);
        record[col] = val;
      }
      GridUtils.refreshRow(grid, e.row);
    }
  };

  // 더블클릭 팝업(design/03 R-G3/R-D6~D8). ITEM_ID → Model 팝업, div=81 의 SCM_SITE_ID/PROJECT_CODE
  //   → SalesSite 팝업. Rows<=0(R-G3) 이면 무반응. AS-IS(.cs:733·765)는 두 팝업 모두 신규행
  //   (action==CAppSetting.FlagI, 즉 CRUD_TYPE==='I')에서만 연다 — 조회행에서는 더블클릭해도
  //   팝업을 열지 않는다. 신규행 가드가 없으면 조회행에서도 팝업이 뜨는 오동작이 난다(2026-10-16 교정).
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid || grid.rows.length <= 0) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell || ht.row < 0) return;
    const binding = grid.columns[ht.col]?.binding ?? '';
    const row = grid.rows[ht.row]?.dataItem as MainRow | undefined;
    if (!row) return;
    // 신규행(CRUD_TYPE==='I')에서만 팝업 — AS-IS action==FlagI 가드.
    if (row.CRUD_TYPE !== 'I') return;
    if (binding === 'ITEM_ID') {
      onItemCellDblClick(row);
      return;
    }
    if (binding === 'SCM_SITE_ID' || binding === 'PROJECT_CODE') {
      if (isSalesSitePopupDivision(String(row.DIVISION_ID ?? ''))) onSalesSiteCellDblClick(row);
    }
  };

  return (
    <DataGrid<MainRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={data}
      staticColumns={staticColumns}
      initialized={handleGridInitialized}
      cellEditEnded={handleCellEdit}
      pastedCell={handleCellEdit}
      dblClick={handleDblClick}
      gotFocus={gotFocus}
    />
  );
};
