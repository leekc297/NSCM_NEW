import {
  AllowMerging,
  CellRange,
  CellType,
  DataMap,
  type CellRangeEventArgs,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type {
  FlexGridColumnConfig,
  RawFlexGridColumnConfig,
} from '@foundation/models';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';

import {
  ADMIN_SHEET_NAME,
  BUCKET_TYPE,
  CELL_PLANT_SITE_DIVISIONS,
  COLUMN,
  COMBO,
  GROUP_HEAD_MEASURE,
  HEADER_TOTAL_HEIGHT,
  MEASURE_BG_FROM_TO_SITE,
  MENU_ID,
  PIVOT_PREFIX,
  PIVOT_QTY_MAX,
  PIVOT_QTY_MIN,
} from '../shipment-request-semi.constants';
import type { ShipmentRequestRow } from '../shipment-request-semi.types';
import {
  buildDrilldownPatch,
  buildPivotColumns,
  isPivotVisible,
  type PivotCol,
} from '../utils/shipmentRequestSemi.columns';
import {
  frozenPastBoundary,
  isEditableDayCell,
  isInsertRow,
  isPivotBinding,
  isSumBinding,
} from '../utils/shipmentRequestSemi.editLock';

import styles from './ShipmentRequestSemiGrid.module.scss';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

/**
 * 셀 콤보 `@토큰` 해소용 공통 파라미터 — 렌더마다 새 참조를 만들지 않도록 모듈 상수로 고정한다.
 *   값은 raw 로 넘긴다(`apiClient.getCombo` → `quoteComboParams` 가 일괄 인용, idempotent).
 *   `divisionId` = AS-IS cs:299 리터럴 `"40,81,82"` — 메타 콤보 `PlantSiteByDivision` 의 `@divisionId` 를
 *   이 값으로 해소해 FROM_SITE/TO_SITE 후보집합을 AS-IS 와 일치시킨다(U2).
 *   금지: 선택 division 을 싣는 것 — 후보집합이 조용히 좁아진다.
 *   주의: 이 grid 의 메타 콤보 전체에 함께 실린다. 현재 메타 콤보는 `PlantSiteByDivision`(사용)과
 *   `FcstType`(파라미터 없음 — 무해) 둘뿐이다. 선택 division 이 필요한 신규행 ITEM_ID 콤보는
 *   메타 경로가 아니라 아래 `useTabComboQueries` 로 따로 조회한다(05_register.sql 6-5).
 */
const COMBO_PARAMS = { mnuId: MENU_ID, divisionId: CELL_PLANT_SITE_DIVISIONS } as const;

/** `MEASURE_COLOR` "R,G,B" → CSS rgb(). 빈값/형식 불일치면 배경 미적용(AS-IS `SCP_PLAN` 동등). */
const toRgb = (measureColor: string): string => {
  const parts = measureColor.split(',').map(v => Number(v.trim()));
  if (parts.length !== 3 || parts.some(n => !Number.isFinite(n))) return '';
  return `rgb(${parts[0]}, ${parts[1]}, ${parts[2]})`;
};

interface Props {
  rows: ShipmentRequestRow[];
  /**
   * 동적 기간칼럼 메타 — **페이지가 `resolvePivotCols` 로 1벌 계산해 내린다**(K2).
   *   금지: 이 컴포넌트가 `toPivotCols`/`pivotColsFromRows` 로 다시 판정하는 것. 페이지와 판정식이
   *   갈리면 BOH SUM 치환(R16/K14)이 한쪽에서만 도는 잠복 결함이 된다(iter-3 N-09).
   */
  pivotCols: PivotCol[];
  /** admin SCM_MST_SHEET_COLUMNS 18행. */
  adminColumns: RawFlexGridColumnConfig[];
  bucketType: BUCKET_TYPE;
  showSum: boolean;
  /** 조회 시작일(YYYYMMDD) — BOD×Frozen 3케이스의 frozen 승격 기준. */
  startPeriod: string;
  /** 신규행 ITEM_ID 셀 콤보(`BODItemProjectRoute_SCP`) 파라미터. */
  divisionId: string;
  operationGroup: string;
  /** 저장 시 음수로 판정된 셀 — 행 객체 → binding 집합(R13/S37). 저장 재시도 전까지 배경으로 남는다. */
  negativeCells: ReadonlyMap<object, ReadonlySet<string>>;
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  /** TR_MODE 셀 클릭 → BOD 팝업(PU04). 진입 가드를 전부 통과한 뒤에만 호출된다. */
  onBodCellClick: (row: ShipmentRequestRow) => void;
  /** TR_MODE 클릭 시 ITEM_ID 가 비어 있으면 안내(V08). */
  onModelRequired: () => void;
  /** ITEM_ID(Model) 재선택 — 페이지가 종속 5칸 클리어 + 재잠금을 수행한다(R11). */
  onModelChanged: (row: ShipmentRequestRow) => void;
  onFocus: () => void;
}

// AS-IS spdMain "Shipment Request" — 고정 19칼럼(Action 1 + 메타 18) + SP 구동 동적 기간칼럼 PIVOT.
//   이 컴포넌트가 담당하는 것:
//     (a) 동적 기간칼럼 3단 헤더 구성 + Bucket×Sum 가시성 + 헤더 더블클릭 드릴다운
//     (b) 편집 게이트 — `isEditableDayCell` 1벌을 beginningEdit / formatItem / pastingCell 이 공유(K2)
//     (c) 음영 4종(measure 배경 / SCP_PLAN 경계선 / Frozen 이전 회색 / 음수 셀) + 토·일 헤더 글자색
//         + TR_MODE edit 어포던스
//     (d) 셀 콤보 — FROM_SITE/TO_SITE/FCST_TYPE 는 admin 메타 구동(화면 개입 없음),
//         신규행 전용 ITEM_ID 만 화면이 dataMap 을 주입한다(design 03 §1.4 / 05_register.sql 6-5)
//     (e) TR_MODE 셀 클릭 → BOD 팝업 진입 가드(BG08~BG12)
export const ShipmentRequestSemiGrid = ({
  rows,
  pivotCols,
  adminColumns,
  bucketType,
  showSum,
  startPeriod,
  divisionId,
  operationGroup,
  negativeCells,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  onBodCellClick,
  onModelRequired,
  onModelChanged,
  onFocus,
}: Props) => {
  // 동적 기간칼럼 base 가시성(Bucket×Sum 매트릭스, 1벌 — design 03 §2.5 R07).
  //   드릴다운 override 는 여기(config)에 넣지 않는다 — config 가 바뀌면 Wijmo 가 columnGroups 를
  //   재대입하며 전 컬럼을 clear/재생성해 그리드가 깜빡인다. config 는 base 로만 만들고, 드릴 override 는
  //   아래 applyDrillVisibility 가 살아있는 col.visible 을 토글해 반영한다(자매 ProductionPlanWaterfallGrid 동형).
  const baseVisible = useMemo(() => {
    const kindOf = new Map(pivotCols.map(c => [c.binding, c.kind]));
    return (binding: string): boolean => {
      const kind = kindOf.get(binding);
      return kind ? isPivotVisible(kind, bucketType, showSum) : false;
    };
  }, [pivotCols, bucketType, showSum]);

  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(
    () => buildPivotColumns(pivotCols, baseVisible),
    [pivotCols, baseVisible]
  );

  // AS-IS SetSpreadColumn Monthly 분기(cs:1159-1166) 파리티 — bucket=Monthly 일 때 D_/W_ 를 숨기고
  //   **MEASURE 이후의 비-pivot 메타 컬럼을 켠다**. 그 범위에 실제로 걸리는 숨김 컬럼은 메타 순서상
  //   MEASURE(16) 뒤의 `BOD_FROM_YYYYMMDD`/`BOD_TO_YYYYMMDD`(30) 둘뿐이다(SCM_MST_SHEET_COLUMNS 실측).
  //   필수: AS-IS 의 Monthly `else` 는 이 두 칸을 `Visible=true` 로 켜지만, Daily/Weekly 분기는
  //   D_/W_/M_ 접두만 토글하고 BOD 메타컬럼은 **전혀 건드리지 않는다**. 그래서 한 번 Monthly 로
  //   켜진 두 칸은 Daily/Weekly 로 되돌려도 다시 숨지 않고 **계속 보인다**(사용자 확인 2026-11-05).
  //   따라서 `bucketType === MONTHLY` 조건이 아니라 "조회 이후 Monthly 가 한 번이라도 선택됐는가"
  //   래치로 유지한다. 래치는 새 조회(pivotCols 교체)에서 초기화 — AS-IS 가 재조회 시 시트를
  //   designer 기본(숨김)으로 다시 세우는 것과 등가.
  //   필수: `display`·`visible` **둘 다** true 로 켠다. admin 메타는 이 두 칸을 `display:false`,
  //   `visible:false` 로 내리는데, 공용 DataGrid 의 최종 렌더 필터가
  //   `Boolean(column.display) && column.visible !== false`(DataGrid.tsx:902)라 `visible` 만
  //   올리면 `display:false` 에서 그대로 걸러져 안 나온다(2026-11-04 네트워크 실측).
  const bodShownRef = useRef(false);
  useEffect(() => {
    bodShownRef.current = false; // 새 조회 = 시트 재구성 → 래치 초기화
  }, [pivotCols]);
  if (bucketType === BUCKET_TYPE.MONTHLY) bodShownRef.current = true;
  const resolvedStaticColumns = useMemo<RawFlexGridColumnConfig[]>(() => {
    if (!bodShownRef.current) return adminColumns;
    const bodCols: readonly string[] = [COLUMN.BOD_FROM_YYYYMMDD, COLUMN.BOD_TO_YYYYMMDD];
    return adminColumns.map(col =>
      bodCols.includes(col.colNm ?? '') ? { ...col, visible: true, display: true } : col
    );
    // bodShownRef 는 ref 라 deps 에서 빠지지만, bucketType 변화가 리렌더를 유발해 래치 최신값으로 재평가된다.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [adminColumns, bucketType]);

  // 드릴다운 override(binding → visible). Bucket/Sum/조회 변경 시 초기화 = base 로 복귀(design 03 §2.6
  //   "SetSpreadColumn 재실행이 드릴다운을 덮는다"). State 가 아니라 Ref 다 — setState 로 바꾸면
  //   dynamicColumns 가 재생성돼 깜빡이므로, override 는 렌더 밖에서 들고 col.visible 로만 반영한다.
  const drillVisRef = useRef<Map<string, boolean>>(new Map());
  const applyDrillVisibilityRef = useRef<(() => void) | null>(null);
  useEffect(() => {
    drillVisRef.current.clear();
  }, [bucketType, showSum, pivotCols]);

  // ── 셀 콤보 (design 03 §1.4) ──
  //   FROM_SITE / TO_SITE / FCST_TYPE 3건은 **admin 컬럼 메타가 단일 원천**이다(dev-manual 04 §4).
  //     · FROM_SITE/TO_SITE = `PlantSiteByDivision`, `@divisionId` 는 위 `COMBO_PARAMS` 로 해소(U1/U2).
  //     · FCST_TYPE = `FcstType`(K18 — 메타값 `FCST_TYPE` 은 SQL 이 달라 WS/WSF 2건이 조용히 빠진다).
  //     둘 다 05_register.sql 6-3/6-4 로 메타에 반영했다.
  //   금지: 이 3건을 화면에서 `col.dataMap` 으로 덮어쓰는 것 — 공용 DataGrid 가 cellEditEnded/pastedCell
  //     직후 `setTimeout(applyComboDataMaps)` 로 **마지막에** 메타 dataMap 을 다시 얹기 때문에
  //     (DataGrid.tsx:1305-1311) 한 번 편집하면 화면 override 가 통째로 대체된다(iter-1 G-02 결함).
  //   ITEM_ID : 신규행 전용 `BODItemProjectRoute_SCP`. 메타 PARAM9 경로를 쓰지 않는 이유는
  //     05_register.sql 6-5 에 기록했다(ATTRIBUTE9 는 CELL_COMBO_DATA_TYPE 없이는 동작하지 않고,
  //     조회행에 콤보를 붙이면 AS-IS 와 달라진다). 메타에 `cellCtrlObjTpCd` 가 없어 공용 applyComboDataMaps
  //     대상에서 빠지므로 이 컬럼만은 화면 주입이 최종값으로 남는다.
  //     AS-IS 의 `bChgDiv` 지연로딩 플래그(G18)는 react-query 키 (division, operationGroup) 로 등가 재현된다.
  const [bodItemRows] = useTabComboQueries({
    filters: [{ comboId: COMBO.CELL_BOD_ITEM, divisionId, operationGroup }],
    enabled: !!divisionId && !!operationGroup,
  });

  const comboSignature = `${bodItemRows?.length ?? 0}`;

  // 최신 값을 stale 없이 참조 — 핸들러는 컬럼 구성 변화 시에만 재등록한다.
  const startPeriodRef = useRef(startPeriod);
  startPeriodRef.current = startPeriod;
  const onBodCellClickRef = useRef(onBodCellClick);
  onBodCellClickRef.current = onBodCellClick;
  const onModelRequiredRef = useRef(onModelRequired);
  onModelRequiredRef.current = onModelRequired;
  const onModelChangedRef = useRef(onModelChanged);
  onModelChangedRef.current = onModelChanged;
  const pivotColsRef = useRef(pivotCols);
  pivotColsRef.current = pivotCols;
  const baseVisibleRef = useRef(baseVisible);
  baseVisibleRef.current = baseVisible;
  // 토/일 헤더 글자색(R04) — binding → DAY_CODE.
  const dayCodeRef = useRef<Map<string, string>>(new Map());
  dayCodeRef.current = useMemo(
    () => new Map(pivotCols.map(c => [c.binding, c.dayCode])),
    [pivotCols]
  );

  // 신규행 ITEM_ID 셀 콤보 dataMap 주입 — 컬럼 재생성(columnGroups 재구성) 후에도 다시 붙도록
  //   컬럼 변화에 반응한다. 콤보가 0건이면 **덮어쓰지 않는다** — 빈 맵으로 갈아끼우면 조회행의
  //   ITEM_ID 표시가 코드 원문으로 떨어진다.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const rows = bodItemRows ?? [];
    if (rows.length === 0) return;
    const col = g.columns.getColumn(COLUMN.ITEM_ID);
    if (!col) return;
    col.dataMap = new DataMap(rows, 'CODE', 'NAME');
    g.invalidate();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [comboSignature, adminColumns, dynamicColumns]);

  // 음수 셀 집합은 상태지만 formatItem 은 ref 로 읽는다(핸들러 재등록 없이 최신값 반영).
  //   상태가 바뀌면 재도색만 트리거한다.
  const negativeCellsRef = useRef(negativeCells);
  negativeCellsRef.current = negativeCells;
  useEffect(() => {
    gridRef.current?.invalidate();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [negativeCells]);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // ── 음영·색 (design 03 §3.2 R14·R15·R15-b / R04 / G10) ──
    const formatItemHandler = (_sender: FlexGridType, ev: FormatItemEventArgs) => {
      const binding = ev.panel.columns[ev.col]?.binding ?? '';

      // 3단 헤더 일자 글자색 — DAY_CODE 'SAT'=Blue / 'SUN'=Red. SCSS Module 클래스로만 적용한다.
      if (ev.panel.cellType === CellType.ColumnHeader) {
        const dayCode = dayCodeRef.current.get(binding) ?? '';
        ev.cell.classList.toggle(styles.satHeader, dayCode === 'SAT');
        ev.cell.classList.toggle(styles.sunHeader, dayCode === 'SUN');
        return;
      }
      if (ev.panel.cellType !== CellType.Cell) return;
      const row = ev.panel.rows[ev.row]?.dataItem as ShipmentRequestRow | undefined;
      if (!row) return;

      // 셀 DOM 은 재사용되므로 조건 미해당 시 항상 해제한다.
      ev.cell.style.backgroundColor = '';
      const setClass = (name: string, on: boolean) => ev.cell.classList.toggle(name, on);

      const indexOf = (columnName: string) => ev.panel.columns.getColumn(columnName)?.index ?? -1;
      const itemIdIndex = indexOf(COLUMN.ITEM_ID);
      const labelIndex = indexOf(COLUMN.MEASURE_LABEL);

      // R15 — `SCP_PLAN` 행에서 직전 행과 모델/공장이 달라지면 그룹 상단 경계선(AS-IS BevelBorder).
      //   AS-IS 범위는 `ITEM_ID ~ 마지막 컬럼`(cs:1073-1075)이라 첫 칸 `DIVISION_ID` 는 제외된다.
      const prevRow = ev.row > 0 ? (ev.panel.rows[ev.row - 1]?.dataItem as ShipmentRequestRow) : undefined;
      const isGroupHead =
        str(row[COLUMN.MEASURE]) === GROUP_HEAD_MEASURE &&
        !!prevRow &&
        (str(prevRow[COLUMN.ITEM_ID]) !== str(row[COLUMN.ITEM_ID]) ||
          str(prevRow[COLUMN.FROM_SITE]) !== str(row[COLUMN.FROM_SITE]));
      setClass(styles.groupBoundary, isGroupHead && itemIdIndex >= 0 && ev.col >= itemIdIndex);

      // R18 / G13 — 신규행 `TR_MODE` 셀의 edit 어포던스. BOD 팝업 진입의 유일한 시각 단서다.
      setClass(styles.trModeEditable, binding === COLUMN.TR_MODE && isInsertRow(row));

      // R14 — measure 배경. 시작열은 기본 `MEASURE_LABEL`, measure 6종은 `TO_SITE` 부터 `MEASURE_LABEL` 까지.
      //   `MEASURE_LABEL` 은 서버 반환값 그대로 쓴다(division 40 CASE 는 SP 몫 — FE 재계산 금지).
      //   RGB 가 행마다 달라 클래스로 표현할 수 없는 유일한 배경이다(SCSS Module 로는 불가).
      //   설계 U6(AS-IS RGB ↔ hook #95 3색 규약) 해소: AS-IS 원본 RGB 유지(사용자 결정 2026-10-20).
      const bg = toRgb(str(row[COLUMN.MEASURE_COLOR]));
      if (bg) {
        const startIndex = MEASURE_BG_FROM_TO_SITE.includes(str(row[COLUMN.MEASURE]))
          ? indexOf(COLUMN.TO_SITE)
          : labelIndex;
        if (startIndex >= 0 && labelIndex >= 0 && ev.col >= startIndex && ev.col <= labelIndex) {
          ev.cell.style.backgroundColor = bg;
        }
      }

      // R15-b — Frozen 이전(확정) 구간 회색. AS-IS cs:1090 은 `MEASURE_LABEL+1 ~ D_(frozen)-1` 을
      //   **컬럼 인덱스 범위**로 칠하므로 그 사이에 낀 `M_`/`W_` SUM 칸도 함께 회색이 된다.
      const frozen = frozenPastBoundary(row, startPeriodRef.current);
      const frozenIndex = frozen ? indexOf(`${PIVOT_PREFIX.DAY}${frozen}`) : -1;
      const isFrozenPast =
        frozenIndex > 0 && labelIndex >= 0 && ev.col > labelIndex && ev.col < frozenIndex;

      const isEditable = isPivotBinding(binding)
        ? isEditableDayCell(row, binding, startPeriodRef.current)
        : false;
      // R13 / S37 — 저장 시 음수로 판정된 셀. 편집가능/확정구간보다 **우선**해 보여야 사용자가 찾는다.
      const isNegative = !!negativeCellsRef.current.get(row)?.has(binding);

      setClass(styles.negativeCell, isNegative);
      // 편집 가능 셀 = 연노랑(hook #95 Yellow). 판정은 beginningEdit 과 **같은 함수**를 쓴다(K2).
      setClass(styles.editableCell, !isNegative && isEditable);
      setClass(styles.frozenPastCell, !isNegative && !isEditable && isFrozenPast);

      // N-04 — 기간셀 음수 **글자색**(AS-IS `NumberCellType.NegativeRed`, SpreadInfo.cs:11013).
      //   저장 시점 배경(negativeCell)과 달리 입력 즉시 상시 적용된다. 값 원천은 행 객체이며
      //   `ev.cell.textContent` 는 'n0' 포맷의 천단위 구분·괄호 표기가 섞여 신뢰하지 않는다.
      const cellValue = isPivotBinding(binding) ? Number(row[binding]) : NaN;
      setClass(styles.negativeValue, Number.isFinite(cellValue) && cellValue < 0);
    };
    g.formatItem.addHandler(formatItemHandler);

    // ── 편집 게이트 — 마지막 override 로 e.cancel 을 재지정한다(hook #70).
    //   공용 DataGrid 의 기본 핸들러가 `INPUT_TP_CD='S'` 로 먼저 cancel 하지만, 동적 `D_` 컬럼은
    //   메타에 행 자체가 없어 메타로 표현할 수 없다 — 화면 판정이 최종이다(design 01 §2.5 말미).
    const beginningEditHandler = (sender: FlexGridType, ev: CellRangeEventArgs) => {
      const binding = sender.columns[ev.col]?.binding ?? '';
      const row = sender.rows[ev.row]?.dataItem as ShipmentRequestRow | undefined;
      if (!row) return;
      if (!isPivotBinding(binding)) {
        // 고정 컬럼은 메타(`INPUT_TP_CD`)에 맡긴다. 예외 1건 — 신규행의 `ITEM_ID` 는 셀 콤보로 열린다(L-G).
        if (binding === COLUMN.ITEM_ID && isInsertRow(row)) ev.cancel = false;
        return;
      }
      ev.cancel = !isEditableDayCell(row, binding, startPeriodRef.current);
    };
    g.beginningEdit.addHandler(beginningEditHandler);
    // 붙여넣기도 같은 함수로 막는다(nscm-patterns §5-16 인접 규약 / design 01 §4.3 V29).
    g.pastingCell.addHandler(beginningEditHandler as never);

    // ── 기간셀 입력 클램프(N-05) — AS-IS `NumberCellType.MinimumValue/MaximumValue` 대응 ──
    //   AS-IS 는 셀타입이 ±9,999,999,999 를 넘는 입력 자체를 받지 않는다(SpreadInfo.cs:11014-11015).
    //   Wijmo Column 에는 상·하한 속성이 없으므로 커밋 시점에 에디터 값을 잘라 등가로 만든다
    //   (자매 선례 `mkt-fcst/components/MktFcstGrid.tsx:1777-1784` 의 소수 절단과 같은 기법).
    //   `activeEditor.value` 를 고쳐야 EditTracker 가 클램프 전 값을 '수정' 으로 잡지 않는다.
    const clampQtyOnCommit = (sender: FlexGridType, ev: CellRangeEventArgs) => {
      const binding = sender.columns[ev.col]?.binding ?? '';
      if (!isPivotBinding(binding)) return;
      const editor = sender.activeEditor;
      if (!editor) return;
      const raw = Number(String(editor.value).replace(/,/g, ''));
      if (!Number.isFinite(raw)) return;
      const clamped = Math.min(PIVOT_QTY_MAX, Math.max(PIVOT_QTY_MIN, raw));
      if (clamped !== raw) editor.value = String(clamped);
    };
    g.cellEditEnding.addHandler(clampQtyOnCommit);

    // ── ITEM_ID(Model) 재선택 → 종속 5칸 클리어 + BOD 재선택 강제(R11 / S58~S63) ──
    //   AS-IS 는 신규행·편집모드에서만 반응한다(BG15~BG17). TO-BE 는 모드가 없어 신규행 조건만 남는다.
    //   BOD 팝업의 프로그램적 대입은 이 이벤트를 발화시키지 않으므로 AS-IS 의 재진입 차단
    //   (`ComboSelChange -= / +=`, G19)에 해당하는 별도 플래그가 필요 없다.
    const cellEditEndedHandler = (sender: FlexGridType, ev: CellRangeEventArgs) => {
      const binding = sender.columns[ev.col]?.binding ?? '';
      if (binding !== COLUMN.ITEM_ID) return;
      const row = sender.rows[ev.row]?.dataItem as ShipmentRequestRow | undefined;
      if (!row || !isInsertRow(row)) return;
      onModelChangedRef.current(row);
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);

    // ── TR_MODE 셀 클릭 → BOD 팝업(R10, 진입 가드 BG08~BG12) ──
    const clickHandler = (mouseEvent: MouseEvent) => {
      const ht = g.hitTest(mouseEvent);
      if (ht.cellType !== CellType.Cell) return; // BG08 — 헤더 클릭 무시
      if (g.rows.length === 0) return; // BG09
      const binding = g.columns[ht.col]?.binding ?? '';
      if (binding !== COLUMN.TR_MODE) return; // BG12 — TR_MODE 컬럼일 때만
      const row = GridUtils.getRow(g, ht.row) as ShipmentRequestRow | undefined;
      if (!row) return;
      if (!isInsertRow(row)) return; // BG11 — 신규행('I')에서만 BOD 선택 가능
      // S45 — AS-IS cs:1215 는 팝업을 열기 **전에** 활성셀을 ITEM_ID 로 옮긴다(Model 미선택 안내 경로 포함).
      //   팝업이 닫힌 뒤 사용자가 바로 Model 을 고칠 수 있게 하는 동작이라 안내 분기보다 먼저 수행한다.
      const itemIdIndex = g.columns.getColumn(COLUMN.ITEM_ID)?.index ?? -1;
      if (itemIdIndex >= 0) g.select(new CellRange(ht.row, itemIdIndex), true);
      if (!str(row[COLUMN.ITEM_ID])) {
        onModelRequiredRef.current(); // V08 — Model 미선택 안내 후 차단
        return;
      }
      onBodCellClickRef.current(row);
    };
    g.hostElement.addEventListener('click', clickHandler);

    // ── 헤더 더블클릭 드릴다운(R06 / S15) — 컬럼 add/remove 없이 표시 rank 만 바꾼다(hook #103) ──
    //   override 를 drillVisRef 에 쌓고 applyDrillVisibility 가 살아있는 col.visible 만 토글한다
    //   — setState/config 재생성이 없어 columnGroups 가 유지되므로 펼칠 때 그리드가 깜빡이지 않는다.
    const dblClickHandler = (mouseEvent: MouseEvent) => {
      const ht = g.hitTest(mouseEvent);
      if (ht.cellType !== CellType.ColumnHeader) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      if (!isSumBinding(binding)) return; // SUM 헤더(M_/W_)에서만 동작
      const currentVisible = (b: string): boolean =>
        drillVisRef.current.get(b) ?? baseVisibleRef.current(b);
      const patch = buildDrilldownPatch(pivotColsRef.current, binding, currentVisible);
      if (patch.size === 0) return;
      patch.forEach((v, k) => drillVisRef.current.set(k, v));
      applyDrillVisibilityRef.current?.();
    };
    g.hostElement.addEventListener('dblclick', dblClickHandler);

    // ── 컬럼 자동 병합(R05 / S01·S16·S25) — 고정 컬럼만 대상. 동적 기간칼럼은 병합하지 않는다.
    //   공용 `CustomMergeManager` 가 좌측 누적 키로 계층 병합하고 신규행(CRUD_TYPE='I')은 제외한다
    //   → "입력 중인 신규행이 기존행과 병합되지 않는다"(CommonCheckList) 가 자동 충족된다.
    for (let i = 0; i < g.columns.length; i += 1) {
      const col = g.columns[i];
      const binding = col.binding ?? '';
      col.allowMerging = !!binding && !isPivotBinding(binding);
    }
    g.invalidate(true);

    return () => {
      try {
        g.formatItem?.removeHandler(formatItemHandler);
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.pastingCell?.removeHandler(beginningEditHandler as never);
        g.cellEditEnding?.removeHandler(clampQtyOnCommit);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.hostElement?.removeEventListener('click', clickHandler);
        g.hostElement?.removeEventListener('dblclick', dblClickHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [adminColumns, dynamicColumns]);

  // ── 드릴다운 가시성 반영 — config 재생성 없이 살아있는 col.visible 만 토글(깜빡임 제거) ──
  //   updatedLayout 마다 재적용해 columnGroups 재대입(조회·버킷·Sum 변경) 후에도 override 를 유지한다.
  //   want = drillVisRef(override) ?? baseVisible. 목표값과 같으면 skip → invalidate 루프 방지.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const applyDrillVisibility = () => {
      let changed = false;
      for (let i = 0; i < g.columns.length; i += 1) {
        const col = g.columns[i];
        const binding = col.binding ?? '';
        if (!isPivotBinding(binding)) continue;
        const want = drillVisRef.current.get(binding) ?? baseVisibleRef.current(binding);
        if (col.visible !== want) {
          col.visible = want;
          changed = true;
        }
      }
      if (changed) g.invalidate(true);
    };
    applyDrillVisibilityRef.current = applyDrillVisibility;
    g.updatedLayout.addHandler(applyDrillVisibility);
    applyDrillVisibility();
    return () => {
      try {
        g.updatedLayout?.removeHandler(applyDrillVisibility);
        applyDrillVisibilityRef.current = null;
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, pivotCols, bucketType, showSum]);

  // ── 헤더 높이 자급 (#93 총 48px) ──
  //   공용 DataGrid 의 `headerRowHeight` prop 은 `columnHeaders.rows.defaultSize` 만 세팅하는데,
  //   공용 컬럼 매퍼가 정적 컬럼을 1단으로 판정해 각 헤더 row 에 명시 `height:48` 을 박아 넣어
  //   defaultSize 를 무시한다 → 조회 후 동적 기간칼럼으로 3단 헤더가 생기면 48×3=144px 로 벌어진다.
  //   자매 DemandPlanWaterfallGrid 와 동일하게 updatedLayout 에서 "실제 렌더된 tier 수"로 나눠
  //   각 row.height 를 직접 강제한다(예측 tier 가 아닌 rows.length 로 나눠야 전이 중 어긋남을 흡수).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const applyHeaderHeight = () => {
      const headerRows = g.columnHeaders?.rows;
      if (!headerRows || headerRows.length === 0) return;
      const targetHeight = HEADER_TOTAL_HEIGHT / headerRows.length;
      let changed = false;
      for (let i = 0; i < headerRows.length; i += 1) {
        if (Math.round(headerRows[i].height ?? headerRows.defaultSize) !== targetHeight) {
          headerRows[i].height = targetHeight;
          changed = true;
        }
      }
      if (Math.round(headerRows.defaultSize) !== targetHeight) {
        headerRows.defaultSize = targetHeight;
        changed = true;
      }
      if (changed) g.invalidate(true);
    };
    applyHeaderHeight();
    g.updatedLayout.addHandler(applyHeaderHeight);
    return () => {
      try {
        g.updatedLayout?.removeHandler(applyHeaderHeight);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, adminColumns, dynamicColumns]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      // 행 타입은 동적 기간칼럼(M_/W_/D_) 때문에 `Record<string, unknown>` 확장이라
      //   `WijmoRowItem`(= Record<string, WijmoPrimitive>) 제약을 만족하지 못한다 — 자매 화면과 동일하게
      //   itemsSource 에서만 변환한다(구조 변환이 정당한 경우의 `as unknown as`, convert-core §2.4).
      itemsSource={rows as unknown as WijmoRowItem[]}
      // 열고정은 공용 DataGrid 가 메타 `FIXED_FLAG='Y'`(=MEASURE)를 읽어 산출한다 —
      //   `frozenColumns` 리터럴 지정 금지(design 01 §2.1 R01 / hook #66).
      staticColumns={resolvedStaticColumns}
      dynamicColumns={dynamicColumns}
      // 메타 셀 콤보의 `@mnuId` / `@divisionId` 해소 — 값·근거는 위 COMBO_PARAMS 주석 참조.
      comboParams={COMBO_PARAMS}
      sheetName={ADMIN_SHEET_NAME}
      allowMerging={AllowMerging.All}
      // headerRowHeight 정적 prop 제거(SCP0100 류 무한 header-height 루프 방지) — 공용 DataGrid 가 정적
      //   prop 으로 defaultSize 를 되돌리는 것과 자체 applyHeaderHeight 의 동적 tier(rows.length) 보정이
      //   충돌해 무한 invalidate 가 됐다. HEADER_TOTAL_HEIGHT 은 applyHeaderHeight 에서 계속 쓰인다.
      gotFocus={onFocus}
    />
  );
};
