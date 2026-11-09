import {
  CellType,
  DataMap,
  type CellEditEndingEventArgs,
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
  ALWAYS_LOCKED_COLUMNS,
  COMBO,
  DEFAULT_CELL_BG_COLOR,
  INVALID_CELL_BG_COLOR,
  LOCK_ON_ELECTRODE_EXISTING,
  LOCK_ON_NON_ELECTRODE,
  MENU_ID,
  MSG,
  OPERATION_GROUP_ELECTRODE,
  SHEETS,
} from '../project-route-electrode.constants';
import type { MainRow } from '../project-route-electrode.types';
import {
  deriveOrgDates,
  deriveTactTimeFlag,
  isCalendarYmd8,
  isPartialYmdValid,
} from '../utils/projectRouteElectrode.derive';

// 입력 제한 대상 컬럼(QA I-01/I-02).
const DATE_INPUT_COLUMNS = ['FROM_YYYYMMDD', 'TO_YYYYMMDD'];
const PRIORITY_COLUMN = 'PRIORITY';
const PRIORITY_MAX_DIGITS = 9;

// 마스크(0000-00-00) 편집기에 숫자 하나를 넣은 뒤의 날짜 8칸. 선택 영역은 비우고 커서 이후 첫 숫자칸에 넣는다.
const nextDateSlots = (input: HTMLInputElement, key: string): (string | null)[] => {
  const text = input.value;
  const start = input.selectionStart ?? text.length;
  const end = input.selectionEnd ?? start;
  const slots: (string | null)[] = [];
  const slotPos: number[] = [];
  for (let i = 0; i < 10 && slots.length < 8; i += 1) {
    if (i === 4 || i === 7) continue;
    const c = text.charAt(i);
    slots.push(/\d/.test(c) && !(i >= start && i < end && end > start) ? c : null);
    slotPos.push(i);
  }
  const target = slotPos.findIndex(p => p >= start);
  if (target >= 0) slots[target] = key;
  return slots;
};

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

// 행 타입 조건부 잠금 셀 판정(AS-IS EditButton cs:277-290). 비전극행(opGroup≠'E')은 LOCK_ON_NON_ELECTRODE,
//   전극 기존행(opGroup='E' && PRIORITY_SEQ≠'')은 LOCK_ON_ELECTRODE_EXISTING(=PLANT_SITE_ID)이 잠긴다.
//   beginningEdit(편집 차단)과 formatItem(편집 스타일 제거)이 공유해 AS-IS 노랑(편집)/흰색(잠금) 패턴을 맞춘다.
//   Plant Site 는 값 없는 신규/골격행(PRIORITY_SEQ='')에서만 편집, Priority/From/To 는 전극행만, Valid 는 상시.
const isRowTypeLockedCell = (binding: string, row: MainRow | undefined): boolean => {
  if (!row) return false;
  const opGroup = String(row.OPERATION_GROUP ?? '');
  if (opGroup !== OPERATION_GROUP_ELECTRODE)
    return (LOCK_ON_NON_ELECTRODE as readonly string[]).includes(binding);
  const prioritySeq = String(row.PRIORITY_SEQ ?? '');
  if (prioritySeq !== '')
    return (LOCK_ON_ELECTRODE_EXISTING as readonly string[]).includes(binding);
  return false;
};

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

  // [F-14] Plant Site 의 Y/N(TACT_TIME_FLAG 소스)은 콤보 SQL(ElecRoutePlantByOperation_SCP)이 @itemId 로
  //   SCP_MST_TACT_TIME·SCP_MST_OUTSOURCING_CAPA 를 조인해 사이트별로 달라진다(DB 실측). 컬럼 콤보
  //   comboParams 는 itemId='' 고정이라 드롭다운이 전부 'N' 으로 와 TACT_TIME_FLAG 가 항상 'N' 이 되던
  //   결함을, 선택 시 그 행 division+itemId 로 콤보를 재조회해 선택 Plant Site 의 정확한 Y/N 을 세팅해
  //   보정한다(AS-IS cs:807~819 SetCellTypeCombo 행별 재조회의 TACT_TIME_FLAG 파생분). 드롭다운 목록
  //   자체는 itemId 무관이라 동일하다(SQL WHERE 는 division/opGroup 만). (div,itemId) 결과는 캐시한다.
  //   (div,itemId)별 콤보 결과 캐시. 성공·실패 모두 캐시해 재조회 폭주를 막고, 진행중(pending)인 키는
  //   중복 요청하지 않는다(네트워크 트랜잭션 폭주 방지).
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
          operationGroup: `'${OPERATION_GROUP_ELECTRODE}'`,
          itemId: `'${itemId}'`,
        },
        'grid'
      )
      .then(rows => {
        const arr = (rows ?? []);
        plantComboByItemRef.current.set(key, arr); // 성공 캐시
        return arr;
      })
      .catch(() => {
        plantComboByItemRef.current.set(key, []); // 실패도 캐시 — 재조회 폭주 방지
        return [] as ComboResponse[];
      })
      .finally(() => {
        plantPendingRef.current.delete(key);
      });
  }, []);

  // [F-14 완전 AS-IS] PLANT_SITE_ID 셀 편집 진입 시 그 행 division+itemId 콤보로 컬럼 dataMap 을 스왑해
  //   드롭다운이 그 Model 기준 Y/N 으로 뜨게 한다(AS-IS SetCellTypeCombo 행별 재맵핑). 편집 종료 시 base 로
  //   복원한다. (div,itemId)별 DataMap 은 1회만 만들어 재사용하고, 이미 그 맵이 붙어 있으면 재스왑하지
  //   않는다 — dataMap 교체가 재렌더→beginningEdit 를 다시 유발하는 무한 루프를 끊는다. 기존행 PLANT_SITE_ID
  //   는 표시문자("DIV SITE DESC", CODE 아님)라 스왑맵에서 미매칭 → 스왑 중 다른 행 표시는 그대로다.
  const plantBaseDataMapRef = useRef<DataMap | null>(null);
  const plantRowMapsRef = useRef<WeakSet<DataMap>>(new WeakSet());
  const plantRowMapByKeyRef = useRef<Map<string, DataMap>>(new Map());
  const swapPlantCombo = useCallback(
    (grid: FlexGrid<MainRow>, div: string, itemId: string) => {
      const col = grid.getColumn('PLANT_SITE_ID');
      if (!col || !div || !itemId) return;
      const key = `${div}|${itemId}`;
      let rowMap = plantRowMapByKeyRef.current.get(key);
      if (!rowMap) {
        const rows = plantComboByItemRef.current.get(key);
        if (!rows || rows.length === 0) {
          void fetchPlantCombo(div, itemId); // 캐시 미스 — 다음 진입 때 반영
          return;
        }
        rowMap = new DataMap(rows, 'CODE', 'NAME');
        plantRowMapByKeyRef.current.set(key, rowMap);
        plantRowMapsRef.current.add(rowMap);
      }
      if (col.dataMap === rowMap) return; // 이미 그 행맵 — 재스왑 금지(루프 차단)
      const cur = col.dataMap;
      if (cur && !plantRowMapsRef.current.has(cur)) plantBaseDataMapRef.current = cur;
      col.dataMap = rowMap;
    },
    [fetchPlantCombo]
  );
  const restorePlantCombo = useCallback((grid: FlexGrid<MainRow>) => {
    const col = grid.getColumn('PLANT_SITE_ID');
    if (col && plantBaseDataMapRef.current && col.dataMap !== plantBaseDataMapRef.current)
      col.dataMap = plantBaseDataMapRef.current;
  }, []);
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
      // [F-14] 편집 허용된 PLANT_SITE_ID 는 그 행 Model 기준 콤보로 dataMap 을 스왑(드롭다운 Y/N 재맵핑).
      if (!e.cancel && binding === 'PLANT_SITE_ID') {
        swapPlantCombo(s, String(row?.DIVISION_ID ?? '').trim(), String(row?.ITEM_ID ?? '').trim());
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
  }, [gridRef, editMode, swapPlantCombo]);

  // 입력 제한(QA I-01/I-02). 날짜는 달력에 있는 날짜만, Priority 는 숫자만 받는다.
  //   부적합 값은 편집 취소로 이전 값으로 되돌린다. 빈값(지우기)은 허용.
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const cellEditEndingHandler = (s: FlexGrid<MainRow>, e: CellEditEndingEventArgs) => {
      if (e.cancel) return;
      const binding = s.columns[e.col]?.binding ?? '';
      const text = String((s.activeEditor as HTMLInputElement | null)?.value ?? '').trim();
      if (binding === PRIORITY_COLUMN) {
        // 기존 로직 주석 보존 (2026-11-04) 시작
        // if (text !== '' && !/^\d+$/.test(text.replace(/,/g, ''))) e.cancel = true;
        // 기존 로직 주석 보존 (2026-11-04) 끝
        // 정수만, 마이너스 허용, 최대 9자리.
        if (text !== '' && !/^-?\d{1,9}$/.test(text.replace(/,/g, ''))) e.cancel = true;
        return;
      }
      if (DATE_INPUT_COLUMNS.includes(binding)) {
        const digits = text.replace(/\D/g, '');
        if (digits !== '' && !isCalendarYmd8(digits)) e.cancel = true;
      }
    };
    // 기존 로직 주석 보존 (2026-11-04) 시작
    // // Priority 셀에서 숫자 외 문자(소수점 포함) 키 입력을 막는다. 편집 시작 키도 포함.
    // const keydownHandler = (ev: KeyboardEvent) => {
    //   if (ev.ctrlKey || ev.metaKey || ev.altKey || ev.key.length !== 1) return;
    //   const col = grid.activeEditor ? grid.editRange?.col : grid.selection?.col;
    //   if (col == null || grid.columns[col]?.binding !== PRIORITY_COLUMN) return;
    //   if (!/^\d$/.test(ev.key)) {
    //     ev.preventDefault();
    //     ev.stopPropagation();
    //   }
    // };
    // 기존 로직 주석 보존 (2026-11-04) 끝
    // Priority 는 숫자와 맨 앞 마이너스만, 최대 9자리. 날짜는 달력에 없는 값이 되는 키를 무시한다(AS-IS 방식).
    const keydownHandler = (ev: KeyboardEvent) => {
      if (ev.ctrlKey || ev.metaKey || ev.altKey || ev.key.length !== 1) return;
      const col = grid.activeEditor ? grid.editRange?.col : grid.selection?.col;
      const binding = col == null ? '' : (grid.columns[col]?.binding ?? '');
      const input = grid.activeEditor as HTMLInputElement | null;
      const block = () => {
        ev.preventDefault();
        ev.stopPropagation();
      };
      if (binding === PRIORITY_COLUMN) {
        if (!/^[\d-]$/.test(ev.key)) return block();
        if (!input) return;
        const start = input.selectionStart ?? input.value.length;
        const end = input.selectionEnd ?? start;
        const rest = input.value.slice(0, start) + input.value.slice(end);
        if (ev.key === '-') {
          if (start !== 0 || rest.includes('-')) block();
          return;
        }
        if (rest.replace(/\D/g, '').length >= PRIORITY_MAX_DIGITS) block();
        return;
      }
      if (DATE_INPUT_COLUMNS.includes(binding) && input && /^\d$/.test(ev.key)) {
        if (!isPartialYmdValid(nextDateSlots(input, ev.key))) block();
      }
    };
    const host = grid.hostElement;
    grid.cellEditEnding.addHandler(cellEditEndingHandler);
    host?.addEventListener('keydown', keydownHandler, true);
    return () => {
      try {
        grid.cellEditEnding.removeHandler(cellEditEndingHandler);
      } catch {
        /* unmount race */
      }
      host?.removeEventListener('keydown', keydownHandler, true);
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
      // 행 타입 잠금 셀(비전극 Plant Site/Priority~To, 전극 기존행 Plant Site)은 메타 INPUT_TP_CD='M' 라
      //   공용 그리드가 편집 스타일(wj-cell-editable=#fff8cd 노랑)을 붙인다. 클래스를 떼고 inline 흰색을
      //   덮어 그리드 기본 컬럼처럼 보이게 한다 — wj-cell-editable 은 !important 아니라 inline 이 이기므로,
      //   컬럼 재생성으로 공용 formatEditableColumns 가 재등록돼 실행 순서가 뒤집혀도 안전하다(값 없는
      //   신규/골격행 Plant Site 만 편집=노랑 유지). 선택 셀(wj-state-selected)은 !important 라 그대로 강조.
      const locked = isRowTypeLockedCell(binding, dataItem);
      if (locked) e.cell.classList.remove('wj-cell-editable');
      // 매칭 시 배경 강조, 잠금 셀은 기본색, 그 외는 해제(셀 DOM 재사용 대비 항상 재설정).
      const isInvalid = invalidCellsRef.current.some(
        c => c.row === dataItem && c.column === binding
      );
      e.cell.style.backgroundColor = isInvalid
        ? INVALID_CELL_BG_COLOR
        : locked
          ? DEFAULT_CELL_BG_COLOR
          : '';
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
    // editMode 를 deps 에 둬야 grid 준비 후(권한 async 해소 시점) effect 가 재실행돼 핸들러가 확실히
    //   등록된다 — invalidCells 는 검증 실패 때만 바뀌어 첫 렌더에 grid 가 null 이면 영영 미등록된다
    //   (beginningEdit effect 가 editMode 로 재실행돼 등록되는 것과 동일한 grid-ready 트리거).
  }, [gridRef, editMode, invalidCells]);

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
      const opGroup = safeString(record.OPERATION_GROUP);
      const orgValidYn = safeString(record.ORG_VALID_YN);
      if (
        opGroup !== OPERATION_GROUP_ELECTRODE &&
        safeString(record.VALID_YN) === 'Y' &&
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

    // R-TACT — PLANT_SITE_ID 콤보 선택 시 TACT_TIME_FLAG = 그 Plant Site 의 Y/N(cs:814·866). beginningEdit 가
    //   그 행 Model 기준 콤보로 dataMap 을 스왑해 뒀으므로 표시 NAME(getCellData true) 끝글자가 그 Model 기준
    //   정확한 Y/N 이다([F-14]). 플래그 세팅 후 base dataMap 으로 복원한다. 스왑 미발생(캐시 미스) 대비 비동기
    //   재조회 보정도 둔다.
    if (binding === 'PLANT_SITE_ID') {
      const applyFlag = (flag: string) => {
        if (safeString(record.TACT_TIME_FLAG) === flag) return;
        editTrackerRef.current?.storeChange(
          dataItem,
          'TACT_TIME_FLAG',
          record.TACT_TIME_FLAG as string,
          flag
        );
        record.TACT_TIME_FLAG = flag;
        GridUtils.refreshRow(grid, e.row);
      };
      // 스왑된 행맵 기준 표시 NAME 끝글자 = 그 Model 의 정확한 Y/N.
      applyFlag(deriveTactTimeFlag(String(grid.getCellData(e.row, e.col, true) ?? '')));
      restorePlantCombo(grid);
      // 안전망 — 스왑 미발생(캐시 미스)이면 그 행 div+itemId 콤보 재조회로 정확 보정.
      const div = safeString(record.DIVISION_ID).trim();
      const itemId = safeString(record.ITEM_ID).trim();
      const plantCode = safeString(record.PLANT_SITE_ID).trim();
      if (div && itemId && plantCode) {
        void fetchPlantCombo(div, itemId).then(rows => {
          const hit = rows.find(r => String(r.CODE ?? '') === plantCode);
          if (hit) applyFlag(deriveTactTimeFlag(String(hit.NAME ?? '')));
        });
      }
      return;
    }

    // R-ORG — FROM/TO 편집 시 ORG_FROM/ORG_TO/MERGE_DATE 갱신(검증 N1~N6 이 ORG_* 기준, AS-IS cs:749-751/876-893).
    //   TO-BE 는 deriveOrgDates 정의만 있고 호출이 없어 검증이 수정 전 날짜로 돌던 결함을 복구한다. [F-4]
    if (binding === 'FROM_YYYYMMDD' || binding === 'TO_YYYYMMDD') {
      const org = deriveOrgDates(record.FROM_YYYYMMDD, record.TO_YYYYMMDD);
      record.ORG_FROM_YYYYMMDD = org.ORG_FROM_YYYYMMDD;
      record.ORG_TO_YYYYMMDD = org.ORG_TO_YYYYMMDD;
      record.MERGE_DATE = org.MERGE_DATE;
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
