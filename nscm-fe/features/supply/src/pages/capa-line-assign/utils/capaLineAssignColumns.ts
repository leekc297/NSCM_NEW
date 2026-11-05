import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';

import {
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
 * 동적 기간컬럼 2단 헤더 (design 03 §2.3 / §5.2 D-1~D-5).
 *
 * `P_SCP0104_GET_SPREAD_TITLE` 이 컬럼명·라벨·정렬순서를 통째로 공급한다 —
 * 화면이 라벨을 만들지 않는다(hook #87 §D, 임의 라벨 생성 금지).
 *   1단 `LARGE_CLASS_LABEL_NAME` : SCP0104 는 `SCP_CAPA_RPT_CODE` 에 행이 0건이라 **항상 공백**이다.
 *   2단 `SMALL_CLASS_LABEL_NAME` : 연도
 *   3단 `COLUMN_LABEL_NAME`      : 월명(연 컬럼은 연도)
 *
 * **AS-IS 는 1단을 숨겨 실제 2단이다.** `RefreshSpreadDateColumn` 호출이 `isVisibleRow0=false`
 * (cs:2173) 로 최상위 행을 통짜로 감춘다(SheetUtils.cs:772-774 `ColumnHeaderVisible(0,false)`).
 * 1단 라벨이 전건 공백이라 그릴 것도 없으므로, 빈 최상위 밴드를 만들지 않고 2단(연/월)으로 조립한다.
 *
 * 월 라벨은 AS-IS `HeaderDateFormatType.MM`(cs:2171, SheetUtils.cs:691-697) 그대로 —
 * `COLUMN_LABEL_NAME` 이 7자 이상(`2026-01`)이면 월 2자(`01`)만 쓴다. 연 컬럼(`2026`, 4자)은 그대로.
 *
 * 주의: 컬럼 정의에 `height` 를 넣지 않는다 — wijmo 가 각 헤더 row 에 명시 height 를 박으면 헤더가
 * tier 마다 벌어진다(형제 capaLobReport.dateColumns 동일). 헤더 총높이는 CapaLineAssignGrid 의
 * applyHeaderHeight 가 단일 출처로 관리한다(hook #93).
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

  // 2단 → leaf 중첩. Map 은 삽입 순서를 보존하므로 SORT_ORDER_NO 순서가 그대로 유지된다.
  const smallGroups = new Map<string, FlexGridColumnConfig[]>();
  for (const row of sorted) {
    const binding = str(row.COLUMN_NAME);
    if (!binding) continue;
    const smallLabel = str(row.SMALL_CLASS_LABEL_NAME);
    const rawLeafLabel = str(row.COLUMN_LABEL_NAME) || binding;
    // AS-IS HeaderDateFormatType.MM: 7자 이상(연-월)이면 월 2자만. 연 컬럼(4자)은 그대로.
    const leafLabel = rawLeafLabel.length >= 7 ? rawLeafLabel.substring(5, 7) : rawLeafLabel;

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
      // 동적 기간컬럼은 admin 메타가 없다 — 행 상태 무관 편집 허용(G21)이 기본이고
      //   최종 차단은 `beginningEdit` 이 한다(hook #70).
      _inputEditType: CELL_INPUT_EDIT_TYPE.OPTIONAL,
      _display: true,
      _dynamic: true,
    });
    smallGroups.set(smallLabel, leaves);
  }

  return [...smallGroups.entries()].map(([smallLabel, leaves]) => ({
    header: smallLabel,
    align: 'center',
    allowMerging: false,
    allowSorting: false,
    columns: leaves,
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
 * 단 이 토글은 Assign 탭에만 걸려 있다 — `EditButton()` 의 Assign 분기만 `SetVisibleSheetColumns`
 * 를 호출(cs:4123)하고 SOP 분기는 호출하지 않아(cs:4080-4100) SOP 8컬럼은 항상 숨김이다. TO-BE 에는
 * Edit 이벤트가 없으므로 이 탭별 실동작을 `isAssign` 으로 고정한다: Assign=항상 노출, SOP=항상 숨김.
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
      // AS-IS 는 편집모드 토글에 묶였으나 TO-BE 에는 Edit 이벤트가 없다. AS-IS 실동작을 탭별로 고정
      // 재현한다: Assign 탭은 `EditButton()`(cs:4123)이 8컬럼을 드러내므로 항상 노출, SOP 탭은
      // `EditButton()` SOP 분기가 `SetVisibleSheetColumns` 를 호출하지 않아(cs:4080-4100) 항상 숨김.
      const shown = isAssign && column.visible !== false;
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

/**
 * 정적 컬럼 헤더를 AS-IS 처럼 2단으로 접는다 (design 03 §2.3 / 사용자 결정 2026-10-21).
 *
 * AS-IS 는 다단 헤더 최상위 행(row 0)을 통짜로 숨긴다 — `RefreshSpreadDateColumn(..., isVisibleRow0=false)`
 * (cs:2173, SheetUtils.cs:772-774). FarPoint Spread 는 헤더 행이 그리드 전역 공유라, 동적 컬럼의 1단
 * 숨김이 정적 컬럼(Site/Plant...)의 1단 밴드까지 함께 지운다 → 그리드 전체가 2단으로 보인다.
 *
 * TO-BE 공용 `mapRawColumnsToWijmoColumns` 는 `getColumnDepth` 가 `lClsLblNm !== sClsLblNm` 인 행을
 * 하나라도 보면 THREE_DEPTH 로 1단 밴드를 그린다. 공용 매핑은 다른 화면이 공유하므로 건드리지 않고,
 * 이 화면에서만 `lClsLblNm` 을 `sClsLblNm` 으로 내려 전건 `lClsLblNm === sClsLblNm` 를 만들어 TWO_DEPTH
 * 로 떨어뜨린다 — 1단이 사라져 AS-IS 와 같은 2단(상위라벨/leaf)이 된다.
 *
 * admin 메타의 `sClsLblNm`·`colLblNm` 은 건드리지 않는다(CLAUDE.md §2 체크4) — 지우는 건 숨겨질 1단뿐.
 */
export const collapseStaticLargeTier = (
  columns: RawFlexGridColumnConfig[]
): RawFlexGridColumnConfig[] =>
  columns.map(column =>
    column.lClsLblNm === column.sClsLblNm
      ? column
      : { ...column, lClsLblNm: column.sClsLblNm }
  );

/**
 * 관리 비노출(`visible === false` = VISIBLE_FLAG 'N') 컬럼을 그리드 구조에서도 뺀다
 * (SOP 그리드 헤더 "SOP / SOP" 중복 교정 · DB 실측 2026-10-26).
 *
 * 공용 DataGrid 는 `display` 로만 Wijmo 투입을 거른다(DataGrid.tsx `filter(c => c.display)`).
 * SCP0104 메타는 비노출 컬럼(SOP_YM·SOP_DDN 등)도 `DEFAULT_FLAG='Y'`(→ `display:true`) 라
 * 투입에 살아남아, `mapRawColumnsToWijmoColumns` 의 그룹 매칭에서 **같은 `SMALL_CLASS_LABEL_NAME`**
 * ('SOP') 를 가진 보이는 형제(SOP_DT)와 한 그룹에 묶인다. 그러면 그 그룹은 자식이 3개(2개 숨김)라
 * Wijmo 가 1자식 그룹처럼 세로병합하지 못하고 "상위 SOP / leaf SOP" 2단으로 그린다.
 *
 * AS-IS 는 헤더 조립(SpreadInfo.cs:1729-1755) 전에 비노출 컬럼을 이미 걸러, SOP 그룹의 가시 자식이
 * SOP_DT 하나뿐이고 `sColumnLabel == sSmallLabelName` 이라 `ColumnHeaderSpan(..., rowSpan=2, ...)`
 * 세로병합으로 "SOP" 를 한 번만 보인다. 그 전처리를 TO-BE 화면에서 재현한다 —
 * `visible === false` 면 `display` 도 `false` 로 내려 공용 필터가 구조에서 빼게 한다.
 *
 * admin 메타 원값(`visible`)은 건드리지 않는다(CLAUDE.md §2 체크4) — 바꾸는 건 투입 판정용 `display`
 * 뿐이고, 이미 비노출인 컬럼을 추가로 노출하지 않으므로 표시 결과는 불변이다.
 */
export const hideInvisibleColumns = (
  columns: RawFlexGridColumnConfig[]
): RawFlexGridColumnConfig[] =>
  columns.map(column =>
    column.visible === false && column.display !== false
      ? { ...column, display: false }
      : column
  );

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
