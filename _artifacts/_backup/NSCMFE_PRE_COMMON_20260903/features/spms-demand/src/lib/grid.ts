// SDM 공통 — useCheckbox 그리드에서 체크된 row 를 모은다 (row.isSelected).
//   GridUtils.getSelectedRows(포커스 선택 기준)와 다르다 — 체크 대상 버튼 로직은 이것을 사용한다.
import {
  SelectionMode,
  type DataMap,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';

import { filterComboRowsByRowItem } from '@foundation/utils';

import { toText } from './call-proc';

// ⭐ SPMS 공통 — 셀 콤보 드롭다운을 서버 순서(콤보 SQL ORDER BY, 보통 DISPLAY_SEQ)대로 유지한다.
//   공용 getDataMap(@foundation columnMapping sortComboDisplayNames)이 표시 목록을
//   숫자→영어→한글 사전순으로 재정렬해 서버 순서가 무시되는데, SPMS 화면은 등록 순서가 의미라
//   되돌린다. foundation 은 타 모듈 공용이라 건드리지 않고(SDM 로컬 공통 원칙) 여기서 감싼다.
//   방식: getDisplayValues 결과(좁힘·중복제거는 공용 로직 그대로)를 원본 행 순서
//   (dataMap.collectionView.items — 서버 응답 순서)로만 재정렬한다.
//   ⭐ ATTRIBUTE2 행 필터 콤보는 **그 행으로 좁힌 서버 행**의 순서를 기준으로 삼는다 —
//   전역 첫 등장 기준은 사업부 간 중복 NAME(예: SpmsSopPlantByDiv 의 DESCRIPTION)이
//   타 사업부 블록 인덱스로 당겨져 블록 내 순서가 섞인다. 좁힘은 공용 filterComboRowsByRowItem
//   재사용 — "드롭다운에 뜨는 값" 판정과 같은 함수라 후보 집합과 어긋나지 않는다.
//   dataMap 은 DataGrid 재렌더마다 재생성되므로 initialized 1회 wrap 으로는 부족하다 —
//   편집/붙여넣기 진입 이벤트마다 현재 인스턴스를 wrap 한다(WeakSet 중복 방지). 전 컬럼을
//   한 번에 wrap 해 cascade 첫 후보 자동입력(attachComboCascadeAutoFill)도 같은 순서를 본다.
const serverOrderApplied = new WeakSet<DataMap>();

const applyServerComboOrder = (dataMap: DataMap | null | undefined, attribute2?: string): void => {
  if (!dataMap || serverOrderApplied.has(dataMap)) return;
  serverOrderApplied.add(dataMap);
  const sorted = dataMap.getDisplayValues.bind(dataMap);
  dataMap.getDisplayValues = rowItem => {
    const items = (dataMap.collectionView?.items ?? []) as { NAME?: unknown }[];
    const scoped =
      rowItem && attribute2
        ? (filterComboRowsByRowItem(items as never, attribute2, rowItem as never) as {
            NAME?: unknown;
          }[])
        : items;
    const base = scoped.length > 0 ? scoped : items;
    const orderByName = new Map<string, number>();
    base.forEach((item, index) => {
      const name = toText(item?.NAME);
      if (!orderByName.has(name)) orderByName.set(name, index);
    });
    return [...sorted(rowItem)].sort(
      (a, b) =>
        (orderByName.get(a) ?? Number.MAX_SAFE_INTEGER) -
        (orderByName.get(b) ?? Number.MAX_SAFE_INTEGER)
    );
  };
};

// 콤보가 있는 SDM 그리드의 initialized 에 연결해 쓴다 (restoreMultiRangeSelection 과 동일 사용법).
//   getAttr2: 바인딩 → 컬럼 메타 ATTRIBUTE2 (행 필터 콤보의 좁힘 기준 — 화면 메타 ref 에서 읽는다).
//   생략 시 전역 items 첫 등장 기준(구 동작 — 행 필터 없는 콤보는 결과 동일).
export const keepServerComboOrder = (
  grid: FlexGrid,
  getAttr2?: (binding: string) => string | undefined
): void => {
  const wrapAllColumnDataMaps = (sender: FlexGrid) => {
    for (let i = 0; i < sender.columns.length; i++) {
      const column = sender.columns[i];
      applyServerComboOrder(column.dataMap, getAttr2?.(column.binding ?? ''));
    }
  };
  grid.beginningEdit.addHandler(wrapAllColumnDataMaps as never);
  grid.pastingCell.addHandler(wrapAllColumnDataMaps as never);
};

// ⭐ SPMS 공통 — 사업부 셀은 콤보 dataMap NAME("81 Automotive Battery")이 아니라 코드("81")만
//   표시한다 (2026-08 협의 — 그리드 표시 축만. 편집 드롭다운 후보/조회조건 라벨은 NAME 그대로).
//   formatItem 으로 표시만 덮어쓰므로 저장값·cascade(ATTRIBUTE2)·dataMap 계약에는 영향 없다.
//   편집 중 셀은 건드리지 않는다 — 삽입된 편집기 <input> 이 지워지는 사고 방어 (DMF0044 계보).
//   그리드 인스턴스당 1회 등록(WeakSet) — initialized/effect 어디서 불러도 중복 등록되지 않는다.
const divisionCodeApplied = new WeakSet<FlexGrid>();

export const keepDivisionCodeDisplay = (grid: FlexGrid): void => {
  if (divisionCodeApplied.has(grid)) return;
  divisionCodeApplied.add(grid);
  grid.formatItem.addHandler((sender: FlexGrid, event: FormatItemEventArgs) => {
    if (event.panel !== sender.cells) return;
    const binding = sender.columns[event.col]?.binding;
    if (binding !== 'DIVISION_ID' && binding !== 'DIVISION_NAME') return;
    if (sender.editRange?.contains(event.row, event.col)) return;
    const row = sender.rows[event.row]?.dataItem as { DIVISION_ID?: unknown } | undefined;
    const code = toText(row?.DIVISION_ID);
    if (event.cell.textContent !== code) event.cell.textContent = code;
  });
};

// ⭐ useCheckbox 그리드 드래그 선택 복원 — wijmo Selector 는 unbound 생성 시 grid.selectionMode 를
//   Cell(단일 셀)로 강제해(wijmo.grid.selector column setter) 드래그 범위 선택·범위 복사/붙여넣기가
//   막힌다. DataGrid 는 initialized 를 내부 설정(setCheckbox 포함)이 모두 끝난 뒤 마지막에 호출하므로
//   여기서 MultiRange 로 되돌린다. SDM useCheckbox 그리드의 initialized 에 연결해 쓴다.
export const restoreMultiRangeSelection = (grid: FlexGrid): void => {
  grid.selectionMode = SelectionMode.MultiRange;
};

export const collectCheckedRows = <T>(grid: FlexGrid<T> | null | undefined): T[] => {
  if (!grid) return [];
  const rows: T[] = [];
  for (const element of grid.rows) {
    if (element?.isSelected) rows.push(element.dataItem as T);
  }
  return rows;
};

// ⭐ 3상태 체크박스 서버 문자열 (REQ_CHECK/DISABLE_CHECK 사본 통합 — FE 재파생 금지, 값 그대로 왕복.
//   DISABLED = 편집 잠금 / CHECKED = 진행 중 / UNCHECKED = 선택 가능)
export const CHECK_STATE = {
  DISABLED: 'DISABLED',
  CHECKED: 'CHECKED',
  UNCHECKED: 'UNCHECKED',
} as const;

// 체크 토글 게이트 — 서버 2값(CHECKED/UNCHECKED)만 토글, 그 외(DISABLED 등) 잠금
export const isCheckToggleable = (value: unknown): boolean => {
  const s = toText(value);
  return s === CHECK_STATE.CHECKED || s === CHECK_STATE.UNCHECKED;
};

// INPUT_TP_CD 편집형 판정 (IM/IO/M/O — 'S'/미지정 = 불가. admin UI Category Setup 메타 단일 원천.
//   행 게이트(MOD_ROW_YN 등)는 화면별 editLock 몫 — 여기는 컬럼 축만)
export const isEditableInputTp = (inputTpCd: string | undefined): boolean =>
  inputTpCd === 'IM' || inputTpCd === 'IO' || inputTpCd === 'M' || inputTpCd === 'O';
