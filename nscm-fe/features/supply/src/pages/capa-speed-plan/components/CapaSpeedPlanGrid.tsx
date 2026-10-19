import { AllowMerging, DataMap, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import {
  ASSEMBLY_SCALE_EDIT,
  ASSEMBLY_SCALE_VIEW,
  COLUMN,
  DIVISION_TYPE,
  HEADER_ROW_HEIGHT,
  MEASURE_COLOR_TARGETS,
  MENU_ID,
  SHEETS,
  type GridSheet,
} from '../capa-speed-plan.constants';
import type { ComboRow, Scp0105Row } from '../capa-speed-plan.types';
import type { MeasureMeta } from '../useCapaSpeedPlanStore';
import {
  matchesElectrodeOperationPrefix,
  toStr,
} from '../utils/capaSpeedPlan.combos';
import { isEditablePeriodColumn } from '../utils/capaSpeedPlan.dateColumns';
import { isCellEditable } from '../utils/capaSpeedPlan.editLock';

import styles from './CapaSpeedPlanGrid.module.scss';

interface Props {
  sheetName: GridSheet;
  rows: Scp0105Row[];
  staticColumns: RawFlexGridColumnConfig[];
  /** admin `SCM_MST_SHEET_MEASURE` 시트분 — Measure 행 배경색 대상의 원천(아래 measureColorTargets). */
  staticMeasures: MeasureMeta[];
  periodColumns: FlexGridColumnConfig[];
  /** ELTR 셀 콤보 후보 원천 — `OperationElectrodeType_SCP_ALL` 전량(행 기준으로 좁혀 쓴다). */
  electrodeTypeRows: ComboRow[] | undefined;
  isEditMode: boolean;
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  onCellEditEnded: (rowIndex: number, binding: string) => void;
}

/**
 * AS-IS `spdMain`(FpSpread, 2시트) -> 공용 DataGrid 1개 + `sheetName` 스위치(03 R-01).
 * 탭이 아니라 스위치라 두 시트 데이터를 동시에 들고 있지 않는다.
 *
 * 화면이 직접 담당하는 것:
 *  (a) 조건부 편집잠금 `beginningEdit`/`pastingCell`  — utils/capaSpeedPlan.editLock (R-05~R-09)
 *  (b) 병합 토글 — 조회모드 ON / 편집모드 OFF (R-13/R-14, L-25)
 *  (c) Measure 행 배경색 — ASSEMBLY 만, `MEASURE_NAME` 열부터 우측 끝까지 (R-12)
 *  (d) measure 별 숫자 소수자릿수 — 메타 `DATA_SCALE_NUMBER` 가 63행 전건 NULL 이라 코드 맵 (R-28)
 *  (e) ELTR `ELTR_LN_TP_CD` 셀 콤보 — 행의 DIVISION_ID+OPERATION_ID 로 후보를 좁힌다 (§1.3)
 * 컬럼 목록·머지헤더·컨텍스트메뉴·EditTracker 는 공용 DataGrid 소관이다.
 */
export const CapaSpeedPlanGrid = ({
  sheetName,
  rows,
  staticColumns,
  staticMeasures,
  periodColumns,
  electrodeTypeRows,
  isEditMode,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  onCellEditEnded,
}: Props) => {
  // 셀 콤보 @토큰(@mnuId) 해소 — 인용은 getCombo funnel 이 처리한다(nscm-patterns §3.3).
  const comboParams = useMemo(() => ({ mnuId: `'${MENU_ID}'` }), []);

  /**
   * Measure 행 배경색 **대상 집합**은 admin 메타가 원천이다 — `SCM_MST_SHEET_MEASURE.ATTRIBUTE3`
   * (=`MEASURE_COLOR`)가 채워진 measure 만 칠한다. 실측(2026-09-23)상 ASSEMBLY 의
   * MMS/PPM_AVG/TTT/CPM 4행만 `192,192,192` 를 갖고 EQP_NBU/PPM/ELTR 의 EQP_SPED 는 공란이라,
   * AS-IS `Set_MeasureColor`(cs:2111~2145)의 하드코딩 4종과 집합이 정확히 일치한다.
   * admin 이 measure 를 늘리거나 색 대상을 바꾸면 화면이 따라간다(CLAUDE.md §2 체크3·4).
   *
   * **색값 자체는 메타를 쓰지 않는다** — 메타는 `192,192,192` 지만 AS-IS 코드가 220 으로 덮어써
   * 런타임 표시색이 220 이고, 사용자 확정(BLK-7)이 코드값이다. 값은 `.measureRow`(SCSS)가 갖는다.
   * 메타 fetch 가 실패해 0행이면 상수 fallback — 색이 통째로 사라지는 쪽보다 낫다.
   */
  const measureColorTargets = useMemo(() => {
    const fromMeta = staticMeasures
      .filter(measure => (measure.attribute3 ?? '').trim() !== '')
      .map(measure => measure.colNm);
    return fromMeta.length > 0 ? fromMeta : MEASURE_COLOR_TARGETS;
  }, [staticMeasures]);

  // 핸들러는 mount 후 1회 등록이라 최신값을 ref 로 본다(stale closure 방지).
  const sheetRef = useRef(sheetName);
  sheetRef.current = sheetName;
  const editModeRef = useRef(isEditMode);
  editModeRef.current = isEditMode;
  const electrodeRef = useRef(electrodeTypeRows);
  electrodeRef.current = electrodeTypeRows;
  const editEndedRef = useRef(onCellEditEnded);
  editEndedRef.current = onCellEditEnded;
  const measureTargetsRef = useRef(measureColorTargets);
  measureTargetsRef.current = measureColorTargets;

  /**
   * 행의 `DIVISION_ID`+`OPERATION_ID` 로 좁힌 설비유형 후보 — AS-IS `RefreshElectrodeTypeSpread`
   * (cs:1444~1449) + `GetFilterElectrodeType`(ScpCapaBL.cs:370~403).
   * 행 `OPERATION_ID` 가 공백이면 DivisionType 별 접두 필터로 대체한다(ELTR 이면 `E2000`).
   * 행 `DIVISION_ID` 가 공백이면 필터 없음 = 전량.
   * 메타(`CELL_COMBO_DATA_TYPE`)가 63행 전건 공란이라 AS-IS 와 동일하게 코드가 행마다 꽂는다(§1.3).
   */
  const buildRowCandidates = (row: Scp0105Row | undefined): string[] => {
    const source = electrodeRef.current ?? [];
    if (!row) return [];
    const divisionId = toStr(row[COLUMN.DIVISION_ID]);
    const operationId = toStr(row[COLUMN.OPERATION_ID]);
    const narrowed = source.filter(candidate => {
      if (divisionId && toStr(candidate.DIVISION_ID) !== divisionId) return false;
      if (!divisionId) return true;
      if (operationId) return toStr(candidate.OPERATION_ID) === operationId;
      // 행 OPERATION_ID 공백 -> DivisionType 접두 필터. 이 그리드는 ELTR 시트에서만 콤보를 띄운다.
      return matchesElectrodeOperationPrefix(
        toStr(candidate.OPERATION_ID),
        DIVISION_TYPE.ELTR
      );
    });
    const seen = new Set<string>();
    const codes: string[] = [];
    for (const candidate of narrowed) {
      const code = toStr(candidate.CODE);
      if (!code || seen.has(code)) continue;
      seen.add(code);
      codes.push(code);
    }
    return codes;
  };

  /** measure 별 소수자릿수 — ELTR 은 AS-IS 키 오타(`EQP_QTY`)로 사실상 미적용이라 맵이 없다(C-06). */
  const scaleOf = (row: Scp0105Row | undefined): number | null => {
    if (!row || sheetRef.current !== SHEETS.ASSEMBLY) return null;
    const measure = toStr(row[COLUMN.MSR_TP_CD]);
    const map = editModeRef.current ? ASSEMBLY_SCALE_EDIT : ASSEMBLY_SCALE_VIEW;
    return measure in map ? map[measure] : null;
  };

  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    const formatItemHandler = (
      sender: FlexGridType,
      event: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (event.panel !== sender.cells) return;
      const binding = sender.columns[event.col]?.binding ?? '';
      const row = sender.rows[event.row]?.dataItem as Scp0105Row | undefined;
      if (!row) return;

      // (c) Measure 행 배경색 — 대상 measure 행을 MEASURE_NAME 열부터 끝까지 칠한다.
      //   대상 집합은 admin 메타(`ATTRIBUTE3` 보유 measure)에서 온다 — 위 measureColorTargets 주석.
      //   색값 `220,220,220` 은 SCSS 클래스가 갖는다(사용자 확정 BLK-7).
      //   ELTR 시트 가드는 메타(ELTR measure 는 ATTRIBUTE3 공란)와 별개로 유지한다 — AS-IS
      //   `Set_MeasureColor` 가 `_sheet_idx==0` 으로 먼저 막으므로(cs:2104) 그 순서까지 재현한다.
      //   Wijmo 는 셀 DOM 을 재사용하므로 미해당 시에도 반드시 클래스를 해제한다(hook #95 §1-4).
      const measureNameIndex = sender.columns.findIndex(
        column => column.binding === COLUMN.MEASURE_NAME
      );
      const isMeasureRow =
        sheetRef.current === SHEETS.ASSEMBLY &&
        measureTargetsRef.current.includes(toStr(row[COLUMN.MSR_TP_CD]));
      const inMeasureRange = measureNameIndex >= 0 && event.col >= measureNameIndex;
      event.cell.classList.toggle(styles.measureRow, isMeasureRow && inMeasureRange);

      // 편집 가능 셀 표시 — Wijmo 는 셀 DOM 을 재사용하므로 미해당 시에도 항상 클래스를 해제한다.
      const editable = isCellEditable({
        sheetName: sheetRef.current,
        binding,
        row,
        isEditMode: editModeRef.current,
      });
      event.cell.classList.toggle('wj-cell-editable', editable);

      // (d) measure 별 소수자릿수 — 공용 numberFormat 은 컬럼 단위라 행마다 다른 자릿수를 못 준다.
      if (binding === COLUMN.PFRSLT_QTY || binding === COLUMN.BASE_QTY || isEditablePeriodColumn(binding)) {
        const scale = scaleOf(row);
        const raw = row[binding];
        if (scale !== null && raw !== null && raw !== undefined && raw !== '') {
          const numeric = Number(raw);
          if (Number.isFinite(numeric)) {
            event.cell.textContent = numeric.toLocaleString(undefined, {
              minimumFractionDigits: scale,
              maximumFractionDigits: scale,
            });
          }
        }
      }
    };
    grid.formatItem.addHandler(formatItemHandler);

    // (a) 편집 게이트 — 공용 DataGrid 기본 핸들러(INPUT_TP_CD)가 먼저 판정하고 화면이 최종 재지정한다.
    //   주의: 메타가 `INPUT_TP_CD='S'` 63행 전건이라 공용 판정만으로는 전 셀이 잠긴다. 그 상태가
    //   AS-IS 와 다르므로(기간셀/설비유형은 편집 가능) 여기서 조건부로 연다. 필수검증이 이 메타 때문에
    //   무발동인 것은 AS-IS 결함으로 유지한다(사용자 확정 BLK-10).
    const beginningEditHandler = (
      sender: FlexGridType,
      event: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[event.col]?.binding ?? '';
      const row = sender.rows[event.row]?.dataItem as Scp0105Row | undefined;
      const editable = isCellEditable({
        sheetName: sheetRef.current,
        binding,
        row,
        isEditMode: editModeRef.current,
      });
      event.cancel = !editable;
      if (!editable) return;

      // (e) 잠금 셀이 아닐 때만 콤보를 꽂는다(R-04). 행마다 후보가 달라야 정상이다(V-36).
      if (sheetRef.current === SHEETS.ELTR && binding === COLUMN.ELTR_LN_TP_CD) {
        const column = sender.columns[event.col];
        const candidates = buildRowCandidates(row);
        column.dataMap = candidates.length > 0 ? new DataMap(candidates) : null;
      }
    };
    grid.beginningEdit.addHandler(beginningEditHandler);

    const pastingCellHandler = (
      sender: FlexGridType,
      event: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[event.col]?.binding ?? '';
      const row = sender.rows[event.row]?.dataItem as Scp0105Row | undefined;
      if (
        !isCellEditable({
          sheetName: sheetRef.current,
          binding,
          row,
          isEditMode: editModeRef.current,
        })
      ) {
        event.cancel = true;
      }
    };
    grid.pastingCell.addHandler(pastingCellHandler);

    /**
     * AS-IS `_defaultDataModel_Changed`(cs:3085~3119) 의 가드 6건을 **그 순서 그대로** 통과한 뒤
     * `CheckEltrEquipmentType` -> `RecalcSheet` 를 부른다. 순서를 바꾸면 잠금 셀에도 자동계산이 돈다.
     * 공용 EditTracker 가 먼저 변경을 기록하므로 이 핸들러는 그 뒤에 등록된다.
     */
    const cellEditEndedHandler = (
      sender: FlexGridType,
      event: { row: number; col: number }
    ) => {
      if (sender.rows.length === 0) return; // GetMaxRowIndex() == -1
      if (event.row === -1 || event.col === -1) return;
      if (!editModeRef.current) return; // IsLock(sheet) / !IsEditMode
      const binding = sender.columns[event.col]?.binding ?? '';
      const row = sender.rows[event.row]?.dataItem as Scp0105Row | undefined;
      // IsLockCell — 잠금 셀은 자동계산 대상이라 재계산하지 않는다.
      if (
        !isCellEditable({
          sheetName: sheetRef.current,
          binding,
          row,
          isEditMode: editModeRef.current,
        })
      ) {
        return;
      }
      editEndedRef.current(event.row, binding);
    };
    grid.cellEditEnded.addHandler(cellEditEndedHandler);

    return () => {
      try {
        grid.formatItem?.removeHandler(formatItemHandler);
        grid.beginningEdit?.removeHandler(beginningEditHandler);
        grid.pastingCell?.removeHandler(pastingCellHandler);
        grid.cellEditEnded?.removeHandler(cellEditEndedHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns, periodColumns]);

  /**
   * (b) 병합 토글 — AS-IS `SetSheetMerge`(cs:2147~2154) 가 `!IsEditMode` 일 때만
   * `ToggleMerge(sheet,true)` + `SmartColMerge()` 를 돌리고, 편집 진입 시 `SetToggleMerge(_si,false)`
   * (cs:1483·1578) 로 해제한다. **조회 직후(`AfterFindData`)에도 병합이 걸린다** — "Edit 토글 시에만"
   * 처리하면 누락되므로 `isEditMode` 파생값으로 항상 계산한다(L-25, R-13/R-14, hook #69).
   * 기간(동적) 컬럼은 `buildPeriodColumns` 에서 `allowMerging:false` 라 수치가 묶이지 않는다.
   */
  const allowMerging = isEditMode
    ? AllowMerging.ColumnHeaders // 3단 헤더 머지는 유지하고 데이터 셀 병합만 해제
    : AllowMerging.All;

  /**
   * 좌측 고정(frozen) 경계 = **admin 메타가 원천**이다(03 V-04).
   *
   * 이 화면은 AS-IS `.cs` 에 `Freeze(` 직접 호출이 **0건**이고 `SetSheetHeaderColumnSCP` 만 부른다 =
   * 프레임워크가 메타 `FIXED_FLAG='Y'` 마지막 컬럼까지 자동 freeze 하는 경로다(메모리
   * `grid-freeze-parity-fixed-flag-vs-prop` §3). 그 경로 화면은 **메타가 곧 AS-IS 사양**이므로 화면이
   * `frozenColumns` prop 을 넘겨 덮어쓰면 안 된다 — 공용 DataGrid 가 `frozenColumns` 를 먼저 주고
   * `{...gridProps}` 를 뒤에 전개하므로 화면 값이 조용히 메타를 이긴다(같은 메모리 §2,
   * CLAUDE.md §2 체크4). DB 실측: `FIXED_FLAG='Y'` 는 시트당 1건(`IDX`, `SORT_ORDER_NO=1000` =
   * 정적 마지막, `VISIBLE_FLAG='Y'`) → 메타 경로도 "정적 표시컬럼 전부" 라는 같은 값을 낸다.
   *
   * 단 공용 wrapper 는 `display=false` 컬럼을 컬럼셋에서 제외하므로, BE 가 폭0 컬럼의 `display` 를
   * 내리면 `IDX` 가 빠져 경계가 0 이 된다. **그 경우에만** 정적 표시컬럼 개수로 보정한다 — 메타가
   * 경계를 표현할 수 있으면 언제나 메타가 이긴다. (`display` 산출은 BE 소관이라 정적으로 확정할 수
   * 없다 — `PKG_SCP0105` 배포 후 런타임에서 `metaFrozenBoundary > 0` 을 확인할 것.)
   */
  const displayStaticColumns = useMemo(
    () => staticColumns.filter(column => column.display),
    [staticColumns]
  );
  const metaFrozenBoundary = useMemo(
    () => displayStaticColumns.findLastIndex(column => column.fixed) + 1,
    [displayStaticColumns]
  );
  const frozenColumnsOverride =
    metaFrozenBoundary > 0 ? undefined : displayStaticColumns.length || undefined;

  // 편집모드가 바뀌면 배경색/자릿수/잠금 표시를 다시 그린다.
  //   Measure 색 대상은 admin 메타에서 오므로 메타가 늦게 도착(또는 변경)해도 다시 칠해야 한다.
  useEffect(() => {
    gridRef.current?.invalidate(true);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isEditMode, measureColorTargets]);

  // 주의: DataGrid 를 래퍼 div 로 감싸지 않는다(hook #132). 공용 DataGrid 가 height:100% / flex:1 1 0 /
  //   min-height:0 을 이미 갖고 있어 래퍼는 중복이고, 선례 화면(SalesPlan/SalesFuturePrice/MktFcst/
  //   DemandManager)도 전부 해당 div 를 제거한 상태다.
  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={staticColumns}
      dynamicColumns={periodColumns}
      comboParams={comboParams}
      sheetName={sheetName}
      // 3단 헤더 총높이 48px — 컬럼 정의의 height 가 아니라 이 prop 이 단일 출처다(hook #93).
      headerRowHeight={HEADER_ROW_HEIGHT}
      allowMerging={allowMerging}
      // 메타(`FIXED_FLAG`)가 경계를 표현하면 prop 을 **넘기지 않는다**(위 주석). 키 자체를 빼야
      //   공용 DataGrid 의 산출값이 `{...gridProps}` 에 덮이지 않는다.
      {...(frozenColumnsOverride === undefined ? {} : { frozenColumns: frozenColumnsOverride })}
    />
  );
};
