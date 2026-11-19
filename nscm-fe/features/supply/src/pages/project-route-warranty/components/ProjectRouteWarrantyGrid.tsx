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

import { apiClient } from '@foundation/apis';
import type { ComboResponse, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridUtils, safeString } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import {
  ALL_SENTINEL,
  COMBO,
  DEFAULT_CELL_BG_COLOR,
  DIVISION_82,
  INVALID_CELL_BG_COLOR,
  isSalesSitePopupDivision,
  LOCK_ON_NON_WARRANTY,
  LOCK_ON_WARRANTY_EXISTING,
  MENU_ID,
  MSG,
  NO_VALUE_PLACEHOLDER,
  OPERATION_GROUP_WARRANTY,
  POPUP_ONLY_COLUMNS,
  SHEETS,
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
  // 조회조건 division — PLANT_SITE_ID 셀 콤보 base 조회 bind(ALL 이면 권한 division CSV 로 펼침).
  divisionId: string;
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

// 행 타입 조건부 잠금 셀 판정(AS-IS EditButton cs:295-305). beginningEdit(편집 차단)과
//   formatItem(편집 스타일 제거)이 이 술어를 공유해 AS-IS 노랑(편집)/흰색(잠금) 패턴을 맞춘다.
//   비-Warranty 행(opGroup≠'W') → LOCK_ON_NON_WARRANTY(PLANT_SITE_ID~VALID_YN) 잠금.
//   Warranty 기존행(opGroup='W' && PRIORITY_SEQ≠'') → LOCK_ON_WARRANTY_EXISTING(PLANT_SITE_ID~
//   PROJECT_CODE) 잠금. 그래서 Priority/From/To/Active(메타 'M')는 Warranty 행에서만 편집=노랑,
//   비-Warranty 행에서는 잠금=흰색이 된다. 신규행(opGroup='W' && PRIORITY_SEQ='')은 미잠금.
const isRowTypeLockedCell = (binding: string, row: MainRow | undefined): boolean => {
  if (!row) return false;
  const opGroup = String(row.OPERATION_GROUP ?? '');
  if (opGroup !== OPERATION_GROUP_WARRANTY)
    return (LOCK_ON_NON_WARRANTY as readonly string[]).includes(binding);
  const prioritySeq = String(row.PRIORITY_SEQ ?? '');
  if (prioritySeq !== '')
    return (LOCK_ON_WARRANTY_EXISTING as readonly string[]).includes(binding);
  return false;
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
  divisionId,
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

  // PLANT_SITE_ID 셀 콤보 base 조회 bind(자매 SCP0027 R-COMBO-PLANT 준용). 메타는 PARAM10='D' 행
  //   파라미터 콤보지만, 공유 콤보 ElecRoutePlantByOperation_SCP 는 파라미터 없이 호출하면 @divisionId
  //   INSTR 매칭(BE 가 미전달값을 '' 치환)에 걸려 0건이라 base dataMap 이 비어 신규행 셀이 콤보가 아닌
  //   텍스트로 뜬다(2026-11-16 사용자 신고). 조회조건 division 을 base bind 로 실어(comboParams) 셀을
  //   항상 콤보로 만든다. operationGroup 은 이 화면 전용 'W'(Warranty) 고정. ALL 이면 권한 division CSV 로
  //   펼친다(Form.plantSiteDivisionFilter 동일 — SQL 이 @divisionId 를 리터럴 INSTR 매칭, ALL→NULL 치환 없음).
  // div=="82" 행은 AS-IS 가 division="" 로 콤보를 조회해 전체 사이트를 돌려준다(cs:993
  //   `if(division=="82") division="";`). TO-BE 콤보도 divisionId="''"(빈값)이면 전 division 사이트를
  //   돌려준다(ora 실측: ''→40/81/82 전체, '82'→82만). 그래서 div 82 는 권한 CSV 가 아니라 빈값을 bind 한다.
  const plantComboDivision = useCallback(
    (rowDivision: string): string => (rowDivision.trim() === DIVISION_82 ? '' : rowDivision.trim()),
    []
  );
  const comboDivisionId = useMemo(
    () =>
      divisionId && divisionId !== ALL_SENTINEL
        ? divisionId
        : (myDivisionRaw ?? [])
            .filter((r: ComboResponse) => String(r.ATTRIBUTE3 ?? '') !== 'EE')
            .map((r: ComboResponse) => String(r.CODE ?? ''))
            .filter(Boolean)
            .join(','),
    [divisionId, myDivisionRaw]
  );
  const comboParams = useMemo(
    () => ({
      divisionId: `'${comboDivisionId}'`,
      operationGroup: `'${OPERATION_GROUP_WARRANTY}'`,
      itemId: '\'\'',
    }),
    [comboDivisionId]
  );

  // PLANT_SITE_ID 의 Y/N(TACT_TIME_FLAG 소스)은 콤보 SQL 이 @itemId 로 TACT_TIME·OUTSOURCING_CAPA 를
  //   조인해 사이트별로 달라진다. base comboParams 는 itemId='' 고정이라 드롭다운/표시가 전부 'N' 으로
  //   오므로, 편집 진입 시 그 행 division+itemId 로 콤보를 재조회해 셀 dataMap 을 행별 맵으로 스왑해
  //   정확한 Y/N 을 띄우고(AS-IS SetCellTypeCombo 행별 재맵핑, 자매 SCP0027 [F-14] 동형), 편집 종료 시
  //   base 로 복원한다. (div,itemId)별 결과는 캐시한다(성공·실패 모두 — 재조회 폭주 방지).
  const plantComboByItemRef = useRef<Map<string, ComboResponse[]>>(new Map());
  const plantPendingRef = useRef<Set<string>>(new Set());
  const fetchPlantCombo = useCallback((div: string, itemId: string): Promise<ComboResponse[]> => {
    const key = `${div}|${itemId}`;
    const cached = plantComboByItemRef.current.get(key);
    if (cached) return Promise.resolve(cached);
    if (plantPendingRef.current.has(key)) return Promise.resolve([] as ComboResponse[]);
    plantPendingRef.current.add(key);
    return apiClient
      .getCombo(
        {
          comboId: COMBO.CELL_PLANT_SITE,
          mnuId: MENU_ID,
          sheetName: SHEETS.MAIN,
          divisionId: `'${div}'`,
          operationGroup: `'${OPERATION_GROUP_WARRANTY}'`,
          itemId: `'${itemId}'`,
        },
        'grid'
      )
      .then(rows => {
        const arr = rows ?? [];
        plantComboByItemRef.current.set(key, arr);
        return arr;
      })
      .catch(() => {
        plantComboByItemRef.current.set(key, []);
        return [] as ComboResponse[];
      })
      .finally(() => {
        plantPendingRef.current.delete(key);
      });
  }, []);

  const plantBaseDataMapRef = useRef<DataMap | null>(null);
  const plantRowMapsRef = useRef<WeakSet<DataMap>>(new WeakSet());
  const plantRowMapByKeyRef = useRef<Map<string, DataMap>>(new Map());
  const swapPlantCombo = useCallback(
    (grid: FlexGrid<MainRow>, div: string, itemId: string) => {
      // div 는 '' 도 유효하다(div 82 → '' = 전체 조회). itemId 는 선택 아님(공백 가능).
      const key = `${div}|${itemId}`;
      const applyRowMap = (rows: ComboResponse[] | undefined): boolean => {
        const col = grid.getColumn('PLANT_SITE_ID');
        if (!col || !rows || rows.length === 0) return false;
        let rowMap = plantRowMapByKeyRef.current.get(key);
        if (!rowMap) {
          rowMap = new DataMap(rows, 'CODE', 'NAME');
          plantRowMapByKeyRef.current.set(key, rowMap);
          plantRowMapsRef.current.add(rowMap);
        }
        if (col.dataMap === rowMap) return true; // 이미 그 행맵 — 재스왑 금지(루프 차단)
        const cur = col.dataMap;
        if (cur && !plantRowMapsRef.current.has(cur)) plantBaseDataMapRef.current = cur;
        col.dataMap = rowMap;
        return true;
      };
      const cached = plantComboByItemRef.current.get(key);
      if (cached && cached.length > 0) {
        applyRowMap(cached);
        return;
      }
      // 캐시 미스 — 조회 후 그 셀이 아직 편집 중이면 dataMap 을 세운다. 드롭다운은 편집 진입과 동시에
      //   열리지 않고 사용자가 뒤에 여므로, 조회 완료 후 세워도 열 때 새 목록(div 82 → 전체)이 반영된다.
      void fetchPlantCombo(div, itemId).then(rows => {
        const editCol = grid.editRange?.col ?? -1;
        if (editCol >= 0 && grid.columns[editCol]?.binding === 'PLANT_SITE_ID') applyRowMap(rows);
      });
    },
    [fetchPlantCombo]
  );
  const restorePlantCombo = useCallback((grid: FlexGrid<MainRow>) => {
    const col = grid.getColumn('PLANT_SITE_ID');
    if (col && plantBaseDataMapRef.current && col.dataMap !== plantBaseDataMapRef.current)
      col.dataMap = plantBaseDataMapRef.current;
  }, []);

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
    // 행-조건부 잠금 셀(R-L2/R-L3)은 메타 INPUT_TP_CD='M' 라 공용 그리드가 편집 스타일
    //   (wj-cell-editable=#fff8cd 노랑)을 붙인다. beginningEdit 와 동일 술어(isRowTypeLockedCell)로
    //   잠긴 셀의 클래스를 떼고 inline 흰색을 덮어 AS-IS 노랑(편집)/흰색(잠금)을 맞춘다 — 잠금은
    //   되는데 노랑이 남던 증상 교정(2026-11-03, 자매 SCP0027 준용). inline 이 클래스색을 이긴다.
    const locked = isRowTypeLockedCell(binding, dataItem);
    if (locked) e.cell.classList.remove('wj-cell-editable');
    // 매칭 시 배경 강조, 잠금 셀은 기본 흰색, 그 외는 해제(셀 DOM 재사용 대비 항상 재설정).
    const isInvalid = invalidCellsRef.current.some(
      c => c.row === dataItem && c.column === binding
    );
    e.cell.style.backgroundColor = isInvalid
      ? INVALID_CELL_BG_COLOR
      : locked
        ? DEFAULT_CELL_BG_COLOR
        : '';
  }, []);

  // 조건부 편집 잠금(design/03 §3.3)을 beginningEdit 로 배선한다(GAP-4). 단방향(잠그기만)이다 —
  //   공용 DataGrid(setEditableColumns)의 기본 편집게이트가 먼저 메타 INPUT_TP_CD 로 cancel 을 세워
  //   둔다(실측: S 22 / IM 3(DIVISION_ID·ITEM_ID·PLANT_SITE_ID) / IO 2(SCM_SITE_ID·PROJECT_CODE) /
  //   M 4(FROM/TO_YYYYMMDD·PRIORITY·VALID_YN)). 여기서 cancel=false 로 되돌리면 admin 메타를 화면이
  //   덮어쓰는 셈이라(CLAUDE.md §2 속성 단위 덮어쓰기 금지) 절대 하지 않는다 — 이미 막힌 셀(e.cancel)은
  //   그대로 둔다. 화면은 메타로 표현 못하는 "행-조건부/팝업전용" 잠금만 추가로 건다: R-C5(div=82
  //   PLANT_SITE 비움) / 팝업전용(ITEM_ID·SCM_SITE_ID·PROJECT_CODE 키인 금지) / R-L2(opGroup≠"W" →
  //   PLANT_SITE_ID~VALID_YN) / R-L3(W & PRIORITY_SEQ≠"" 기존행 → PLANT_SITE_ID~PROJECT_CODE).
  //   주의: 이 핸들러는 반드시 handleGridInitialized(initialized 콜백)에서 등록한다. 이전엔 useEffect
  //   ([gridRef])로 걸었으나, wijmo 비동기 mount 라 첫 pass 에 gridRef.current===undefined → early-return
  //   하고 deps 불변이라 재실행되지 않아 핸들러가 영영 미등록 → R-L2/R-L3 가 전혀 안 걸려 모든 행이
  //   편집가능해지는 버그가 있었다(2026-11-03 실사고 — DataMap/날짜/formatItem 과 동일 함정, 그 셋은
  //   이미 initialized 로 옮겨져 정상이었다).
  const beginningEditHandler = useCallback(
    (s: FlexGrid<MainRow>, e: { cancel: boolean; row: number; col: number }) => {
      // 공용 게이트가 메타(INPUT_TP_CD)로 이미 막은 셀은 그대로 둔다 — 화면은 추가로 잠그기만.
      if (e.cancel) return;
      const binding = s.columns[e.col]?.binding ?? '';
      const row = s.rows[e.row]?.dataItem as MainRow | undefined;
      // 팝업 전용 셀(ITEM_ID/SCM_SITE_ID/PROJECT_CODE)은 키인 편집기를 열지 않는다 — 값 입력은
      //   더블클릭 팝업(handleDblClick)으로만. 신규행에서 R-L2/R-L3 에 안 걸려도 항상 잠근다.
      if ((POPUP_ONLY_COLUMNS as readonly string[]).includes(binding)) {
        e.cancel = true;
        return;
      }
      // R-L2/R-L3 — 행-조건부 잠금(formatItem 의 노랑 제거와 동일 술어 공유). 비-Warranty 행
      //   PLANT_SITE_ID~VALID_YN / Warranty 기존행 PLANT_SITE_ID~PROJECT_CODE 잠금(AS-IS .cs 295-305).
      if (isRowTypeLockedCell(binding, row)) {
        e.cancel = true;
        return;
      }
      // PLANT_SITE_ID 편집 진입(AS-IS CellClick cs:970~996).
      //   · division 공백이면 편집 취소 + "Division 선택" 안내(AS-IS 빈 콤보 + MSG00093 → TO-BE MSG00097).
      //   · div=="82" 는 AS-IS 가 division="" 로 전체 조회(권한 division 전체 = 40/81/82 등)하므로 권한
      //     division CSV 로 조회한다(cs:993). 그 외는 그 행 division.
      //   · itemId 는 선택 아님(공백 가능) — 콤보 목록은 division+opGroup 'W'로만 나오고 item 은 Y/N 만 좌우.
      //   그 행 콤보로 dataMap 을 스왑(드롭다운 Y/N 재맵핑, 자매 SCP0027 [F-14] 동형). 캐시 미스면 비동기
      //   조회만 걸고 다음 진입에서 반영한다.
      if (binding === 'PLANT_SITE_ID') {
        const rowDiv = String(row?.DIVISION_ID ?? '').trim();
        if (!rowDiv) {
          e.cancel = true;
          void setAlert({
            type: 'alert',
            content: t(MSG.REQUIRE_DIVISION_CELL, '_사업부를 먼저 선택하세요.'),
          });
          return;
        }
        swapPlantCombo(s, plantComboDivision(rowDiv), String(row?.ITEM_ID ?? '').trim());
      }
    },
    [swapPlantCombo, plantComboDivision, setAlert, t]
  );

  // 그리드 생성 시 1회(initialized, grid 확정 보장) — 모든 셀 렌더링 훅을 여기서 건다.
  //   주의: 이들을 useEffect([gridRef])로 걸면 안 된다. gridRef.current 는 wijmo 비동기 mount 라
  //   첫 pass 에서 undefined → early-return 하고, ref deps 는 안 바뀌어 재실행되지 않는다
  //   (DIVISION_ID DataMap·날짜·formatItem 모두 같은 함정 — 2026-10-05/2026-10-16 실사고).
  //   initialized 는 grid 확정 후 1회 호출이 보장돼 여기서 붙여야 확실하다.
  //   (a) DIVISION_ID 신규행 DataMap 재부착(updatedLayout 마다 — columnGroups 재대입이 지움)
  //   (b) FROM/TO dataType=Date + format='yyyy-MM-dd'(updatedLayout 마다 재적용)
  //   (c) formatItem(DIVISION_ID 코드표시 + 저장검증 실패 배경).
  //   (d) beginningEdit(행-조건부 편집잠금 R-L2/R-L3·R-C5·팝업전용). useEffect([gridRef])에서 옮겨왔다
  //       (grid 미확정 early-return 으로 미등록되던 버그, 위 beginningEditHandler 주석 참고).
  const handleGridInitialized = useCallback(
    (grid: FlexGrid<MainRow>) => {
      grid.updatedLayout.addHandler(() => attachDivisionDataMap(grid));
      attachDivisionDataMap(grid);
      grid.updatedLayout.addHandler(applyDateColumnTypes);
      applyDateColumnTypes(grid);
      grid.formatItem.addHandler(formatItemHandler);
      grid.beginningEdit.addHandler(beginningEditHandler);
    },
    [attachDivisionDataMap, formatItemHandler, beginningEditHandler]
  );
  // 콤보가 grid mount 이후 도착하는 경우 — 변경 시 즉시 DataMap 부착.
  useEffect(() => {
    const grid = gridRef.current;
    if (grid && divisionDataMap) attachDivisionDataMap(grid);
  }, [gridRef, divisionDataMap, attachDivisionDataMap]);

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

    // R-D1 — PLANT_SITE_ID 선택 시 표시문자열 마지막문자 = TACT_TIME_FLAG. 편집 중 셀은 swap 된 행별
    //   콤보 dataMap 이 붙어 있어 표시값(getCellData formatted)이 그 Model 의 정확한 Y/N 이다 —
    //   record.PLANT_SITE_ID(CODE)가 아니라 표시값에서 뽑는다. 플래그 확정 후 base 콤보로 복원한다.
    if (binding === 'PLANT_SITE_ID') {
      const applyFlag = (flag: string) => {
        editTrackerRef.current?.storeChange(
          dataItem,
          'TACT_TIME_FLAG',
          record.TACT_TIME_FLAG as string,
          flag
        );
        record.TACT_TIME_FLAG = flag;
        GridUtils.refreshRow(grid, e.row);
      };
      applyFlag(deriveTactTimeFlag(String(grid.getCellData(e.row, e.col, true) ?? '')));
      restorePlantCombo(grid);
      // 안전망 — 스왑 미발생(캐시 미스)이면 그 행 div+itemId 콤보 재조회로 정확 보정. div=="82"는 빈값(전체).
      const rowDiv = safeString(record.DIVISION_ID).trim();
      const comboDiv = plantComboDivision(rowDiv);
      const itemId = safeString(record.ITEM_ID).trim();
      const plantCode = safeString(record.PLANT_SITE_ID).trim();
      if (rowDiv && itemId && plantCode) {
        void fetchPlantCombo(comboDiv, itemId).then(rows => {
          const hit = rows.find(r => String(r.CODE ?? '') === plantCode);
          if (hit) applyFlag(deriveTactTimeFlag(String(hit.NAME ?? '')));
        });
      }
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
      // Plant Site 콤보 선조회 — division 확정 시 그 division(82→빈값=전체) 목록을 미리 당겨 편집 진입
      //   첫 드롭다운이 바로 전체 목록으로 뜨게 한다(itemId='' 목록은 Y/N 무관, 사이트 집합 동일).
      const rowDivTrim = div.trim();
      if (rowDivTrim) void fetchPlantCombo(plantComboDivision(rowDivTrim), '');
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
      comboParams={comboParams}
      initialized={handleGridInitialized}
      cellEditEnded={handleCellEdit}
      pastedCell={handleCellEdit}
      dblClick={handleDblClick}
      gotFocus={gotFocus}
    />
  );
};
