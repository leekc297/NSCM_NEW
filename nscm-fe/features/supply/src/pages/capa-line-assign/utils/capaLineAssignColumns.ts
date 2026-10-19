import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';

import {
  ASSIGN_HEADER_ROW_HEIGHT,
  DATE_PRE_COLUMN,
  EDIT_MODE_ONLY_COLUMNS,
  EDIT_MODE_WIDTH_RESTORE_COLUMNS,
  WIDTH_RESTORE_ATTRIBUTE3,
} from '../capa-line-assign.constants';
import type { ComboOption, SpreadTitleRow } from '../capa-line-assign.types';
import type { ColumnLayoutOverride } from '../useCapaLineAssignStore';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

/**
 * 동적 기간컬럼 3단 헤더 (design 03 §2.3 / §5.2 D-1~D-5).
 *
 * `P_SCP0104_GET_SPREAD_TITLE` 이 컬럼명·3레벨 라벨·정렬순서를 통째로 공급한다 —
 * 화면이 라벨을 만들지 않는다(hook #87 §D, 임의 라벨 생성 금지).
 *   1단 `LARGE_CLASS_LABEL_NAME` : SCP0104 는 `SCP_CAPA_RPT_CODE` 에 행이 0건이라 **항상 공백**이다.
 *   2단 `SMALL_CLASS_LABEL_NAME` : 연도
 *   3단 `COLUMN_LABEL_NAME`      : 월명(연 컬럼은 연도)
 * 총높이 48px 고정(hook #93) → 단당 {@link ASSIGN_HEADER_ROW_HEIGHT}px.
 *
 * 삽입 위치(`DUMMY_YN` 바로 뒤)는 공용 DataGrid 가 `dynamicColumns` 를 staticColumns 뒤에 붙이는
 * 것으로 충족된다 — `DUMMY_YN` 이 Assign 두 시트 모두 `SORT_ORDER_NO` 최댓값(1000)이라 정적 블록의
 * 마지막이다(design 03 §1.1·§1.2 실측).
 */
export const buildDateColumns = (titleRows: SpreadTitleRow[]): FlexGridColumnConfig[] => {
  if (titleRows.length === 0) return [];

  const sorted = [...titleRows].sort(
    (a, b) => Number(str(a.SORT_ORDER_NO)) - Number(str(b.SORT_ORDER_NO))
  );

  // 1단 → 2단 → leaf 중첩. Map 은 삽입 순서를 보존하므로 SORT_ORDER_NO 순서가 그대로 유지된다.
  const largeGroups = new Map<string, Map<string, FlexGridColumnConfig[]>>();
  for (const row of sorted) {
    const binding = str(row.COLUMN_NAME);
    if (!binding) continue;
    const largeLabel = str(row.LARGE_CLASS_LABEL_NAME);
    const smallLabel = str(row.SMALL_CLASS_LABEL_NAME);
    const leafLabel = str(row.COLUMN_LABEL_NAME) || binding;

    const smallGroups = largeGroups.get(largeLabel) ?? new Map<string, FlexGridColumnConfig[]>();
    const leaves = smallGroups.get(smallLabel) ?? [];
    leaves.push({
      binding,
      header: leafLabel,
      // 동적 컬럼은 `RefreshSpreadDateColumn(..., width=40, ...)`(cs:2165-2180) 그대로 40px.
      width: 40,
      align: 'right',
      allowMerging: false,
      allowSorting: false,
      visible: true,
      height: ASSIGN_HEADER_ROW_HEIGHT,
      // 동적 기간컬럼은 admin 메타가 없다 — 행 상태 무관 편집 허용(G21)이 기본이고
      //   최종 차단은 `beginningEdit` 이 한다(hook #70).
      _inputEditType: CELL_INPUT_EDIT_TYPE.OPTIONAL,
      _display: true,
      _dynamic: true,
    });
    smallGroups.set(smallLabel, leaves);
    largeGroups.set(largeLabel, smallGroups);
  }

  return [...largeGroups.entries()].map(([largeLabel, smallGroups]) => ({
    header: largeLabel,
    align: 'center',
    height: ASSIGN_HEADER_ROW_HEIGHT,
    allowMerging: false,
    allowSorting: false,
    columns: [...smallGroups.entries()].map(([smallLabel, leaves]) => ({
      header: smallLabel,
      align: 'center',
      height: ASSIGN_HEADER_ROW_HEIGHT,
      allowMerging: false,
      allowSorting: false,
      columns: leaves,
    })),
  }));
};

/**
 * `SORT_ORDER_NO` 동점 컬럼의 표시 순서 고정 (design 03 §1.3 note · §6-4 / GAP-06).
 *
 * 메타가 같은 `SORT_ORDER_NO` 를 두 컬럼에 주면 서버 정렬만으로는 순서가 비결정적이다. 동점 그룹의
 * **자리(index)는 그대로 두고 그 자리에 들어갈 컬럼만** {@link TIED_COLUMN_ORDER} 순서로 재배치한다 —
 * 다른 컬럼의 위치도, 컬럼 속성값도 건드리지 않는다(CLAUDE.md §2 체크4).
 *
 * 그룹 컬럼이 전부 존재하지 않으면(개인화로 숨김 등) 원본을 그대로 돌려준다.
 */
export const applyTiedColumnOrder = (
  columns: RawFlexGridColumnConfig[],
  tiedOrder: readonly string[] | undefined
): RawFlexGridColumnConfig[] => {
  if (!tiedOrder || tiedOrder.length < 2) return columns;
  const slots: number[] = [];
  const byName = new Map<string, RawFlexGridColumnConfig>();
  columns.forEach((column, index) => {
    if (!tiedOrder.includes(column.colNm)) return;
    slots.push(index);
    byName.set(column.colNm, column);
  });
  if (byName.size !== tiedOrder.length) return columns;
  const next = [...columns];
  tiedOrder.forEach((colNm, index) => {
    const column = byName.get(colNm);
    if (column) next[slots[index]] = column;
  });
  return next;
};

/**
 * 편집모드 컬럼 표시/숨김 오버레이 (AS-IS `SetVisibleSheetColumns` cs:4371-4493 / design 03 §3.6 X-F).
 *
 * AS-IS 는 편집모드에 들어갈 때 코드(ID) 축 8컬럼을 드러내고, 조회모드로 돌아오면 다시 감춘다.
 * Assign 탭은 여기에 더해 메타 `ATTRIBUTE3='N'` 인 명칭 컬럼을 조회모드에서 폭 0 으로 접는다
 * (SOP 분기에는 이 블록이 없다 — cs:4374-4388 은 8컬럼 호출뿐).
 *
 * **admin 메타를 덮어쓰지 않는다**(CLAUDE.md §2 체크4): 노출은 "메타/개인화가 이미 보이기로 한
 * 컬럼"에 한해 편집모드가 추가로 가를 뿐이며(AND), 숨긴 컬럼을 코드가 되살리지 않는다.
 * 복원 폭도 리터럴이 아니라 들어온 `colWth` 원값을 그대로 유지한다.
 *
 * 실측 주의(ora.py 2026-09-23): TO-BE `SCM_MST_SHEET_COLUMNS` 의 SCP0104 43행은 `ATTRIBUTE3` 가
 * 전건 NULL 이라 폭 복원 블록은 현재 무동작이다 — admin 이 `'N'` 을 넣으면 그때 활성화된다.
 *
 * **원천 차이(GAP-24, 현재 잠복)**: AS-IS 는 같은 `ATTRIBUTE3` 를 **사용자 컬럼설정 응답**
 * (`SCM_SYS_GET_SPREAD_TITLE` → `SCM_MST_TITLESET_USER`, design 03 §3.1 G03)에서 읽는데, 여기서는
 * admin 컬럼 메타 행의 값을 읽는다. 지금은 메타가 전건 NULL 이라 동작 차이가 없지만, P04 컬럼설정을
 * 실제로 쓰기 시작하면 두 원천이 갈린다 — 그때는 판정을 titleSet 응답 기준으로 옮겨야 한다.
 */
export const applyEditModeVisibility = (
  columns: RawFlexGridColumnConfig[],
  editMode: boolean,
  isAssign: boolean
): RawFlexGridColumnConfig[] =>
  columns.map(column => {
    if (EDIT_MODE_ONLY_COLUMNS.includes(column.colNm)) {
      const shown = editMode && column.visible !== false;
      return { ...column, visible: shown, display: shown };
    }
    if (
      isAssign &&
      EDIT_MODE_WIDTH_RESTORE_COLUMNS.includes(column.colNm) &&
      column.attribute3 === WIDTH_RESTORE_ATTRIBUTE3
    ) {
      // 편집모드면 원 폭 그대로(무변경), 조회모드면 폭 0 + 숨김.
      return editMode ? column : { ...column, colWth: 0, visible: false, display: false };
    }
    return column;
  });

/**
 * 개인화 정렬 키 — `DUMMY_YN` 만 항상 마지막으로 보낸다(design 03 D-1 삽입 위치 계약).
 * 나머지는 사용자 지정 순서, 미지정이면 원래 자리 뒤.
 */
const orderOf = (colNm: string, byName: Map<string, ColumnLayoutOverride>): number => {
  if (colNm === DATE_PRE_COLUMN) return Number.POSITIVE_INFINITY;
  return byName.get(colNm)?.order ?? Number.MAX_SAFE_INTEGER;
};

/**
 * 컬럼 개인화(P04) 오버레이 — admin 메타 위에 사용자 설정만 얹는다.
 *
 * admin 이 관리하는 속성(`visible`/`fixed` 등)을 코드 리터럴로 덮어쓰지 않는다(CLAUDE.md §2 체크4).
 * 여기서 바뀌는 값은 전부 사용자가 모달에서 고른 것이며, 오버레이가 없으면 메타 원본 그대로다.
 */
export const applyLayoutToColumns = (
  columns: RawFlexGridColumnConfig[],
  layout: ColumnLayoutOverride[] | undefined
): RawFlexGridColumnConfig[] => {
  if (!layout || layout.length === 0) return columns;
  const byName = new Map(layout.map(entry => [entry.colNm, entry]));
  const applied = columns.map(column => {
    const override = byName.get(column.colNm);
    if (!override) return column;
    return {
      ...column,
      visible: override.visible,
      display: override.visible,
      colWth: override.width ?? column.colWth,
      cellColor: override.cellColor ?? column.cellColor,
      textColor: override.textColor ?? column.textColor,
    };
  });
  // 사용자 지정 순서 — 미지정 컬럼은 원래 자리 뒤로 유지한다.
  //   단 `DUMMY_YN` 은 개인화 순서와 무관하게 **항상 정적 블록 마지막**이다: 공용 DataGrid 가
  //   `dynamicColumns` 를 staticColumns 뒤에 붙이므로, 이 컬럼이 마지막이어야 "동적 기간컬럼은
  //   `DUMMY_YN` 바로 뒤"라는 삽입 위치 계약(design 03 D-1, cs:2178)이 유지된다.
  return applied.sort((a, b) => orderOf(a.colNm, byName) - orderOf(b.colNm, byName));
};

/** `ColumnLayoutModal` fallback 용 — admin 메타에서 key/header/width 만 뽑는다. */
export const toLayoutFallback = (
  columns: RawFlexGridColumnConfig[]
): { key: string; header: string; width: number }[] =>
  columns.map(column => ({
    key: column.colNm,
    header: column.colLblNm || column.colNm,
    width: column.colWth ?? 100,
  }));

/** 콤보 후보 목록 → 중복 제거 + 원 순서 유지. */
export const uniqueOptions = (options: ComboOption[]): ComboOption[] => {
  const seen = new Set<string>();
  const out: ComboOption[] = [];
  for (const option of options) {
    if (!option.value || seen.has(option.value)) continue;
    seen.add(option.value);
    out.push(option);
  }
  return out;
};
