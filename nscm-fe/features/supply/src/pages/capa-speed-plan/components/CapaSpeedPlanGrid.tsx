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
  HEADER_TOTAL_HEIGHT,
  MEASURE_COLOR_TARGETS,
  MENU_ID,
  PERIOD_MAX_INT_DIGITS,
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

/**
 * 기간 칸 정수부 입력 자릿수 제한 헬퍼(SCP0105 테스트 자릿수 조치, `PERIOD_MAX_INT_DIGITS`).
 * 부호·소수부는 보존하고 정수부만 센다/자른다. 콤마(표시 포맷)는 숫자가 아니므로 무시한다.
 */
const integerDigitCount = (value: string): number =>
  value.replace(/[^\d.]/g, '').split('.')[0].length;

/** 정수부를 `limit` 자리로 자른다(부호·소수부 유지). `'12345678901234'`→(10)→`'1234567890'`. */
const clampIntegerDigits = (value: string, limit: number): string => {
  const sign = value.trimStart().startsWith('-') ? '-' : '';
  const digits = value.replace(/[^\d.]/g, '');
  const dot = digits.indexOf('.');
  if (dot === -1) return sign + digits.slice(0, limit);
  return sign + digits.slice(0, dot).slice(0, limit) + digits.slice(dot);
};

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
  /** 편집권한은 있으나 버전 진행상태가 읽기전용(마감/과거)인 상태 — 편집 시도 시 MSG00109 안내(L-11). */
  isReadOnlyVersion: boolean;
  /** 읽기전용 버전에서 편집 가능했을 셀을 건드렸을 때 호출 — Page 가 MSG00109 를 띄운다. */
  onReadOnlyEditBlocked: () => void;
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
  isReadOnlyVersion,
  onReadOnlyEditBlocked,
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
  const readOnlyVersionRef = useRef(isReadOnlyVersion);
  readOnlyVersionRef.current = isReadOnlyVersion;
  const readOnlyBlockedRef = useRef(onReadOnlyEditBlocked);
  readOnlyBlockedRef.current = onReadOnlyEditBlocked;
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

    // 편집 시작 시 그 셀의 이전 값을 담아둔다 — 커밋된 값이 숫자가 아니면 cellEditEnded 가 이 값으로 되돌린다.
    let lastEditOldValue: unknown;

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
        // 편집 중인 셀(에디터 input 이 든 셀)은 textContent 를 덮지 않는다 — 덮으면 편집기 input 이
        //   날아가 재편집이 안 된다. 숫자 값만 이 블록을 타므로(문자 값은 Number(raw)=NaN 이라 skip)
        //   "숫자 셀만 재편집 안 됨"으로 나타났다(사용자 지적 2026-10-28).
        const isEditingThisCell = !!event.cell.querySelector('input, select, textarea');
        if (
          !isEditingThisCell &&
          scale !== null &&
          raw !== null &&
          raw !== undefined &&
          raw !== ''
        ) {
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

      // 버전 진행상태가 읽기전용(마감/과거)인데 편집권한 보유자가 **편집 가능했을** 셀을 건드리면
      //   AS-IS Edit 클릭 차단과 동일하게 MSG00109 안내 후 차단한다(L-11/V-07). `isEditMode:true` 로
      //   "Current 버전이면 열렸을 셀" 인지 판정해 고정열·우선순위 없는 셀 등 원래부터 잠긴 셀에는
      //   안내를 띄우지 않는다(조용히 유지).
      if (
        readOnlyVersionRef.current &&
        isCellEditable({ sheetName: sheetRef.current, binding, row, isEditMode: true })
      ) {
        event.cancel = true;
        readOnlyBlockedRef.current();
        return;
      }

      const editable = isCellEditable({
        sheetName: sheetRef.current,
        binding,
        row,
        isEditMode: editModeRef.current,
      });
      event.cancel = !editable;
      if (!editable) return;
      lastEditOldValue = row?.[binding]; // 되돌림용 이전 값

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
      event: { cancel: boolean; row: number; col: number; data: unknown }
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
        return;
      }
      // Wijmo 기본 붙여넣기는 setCellData(coerce=true) 로 값을 쓰는데, 런타임 조립된 동적 기간 컬럼
      //   (dataType 미지정)에는 coerce=true 가 값을 못 쓴다(2026-10-28 실측: 같은 셀에 coerce=false 는
      //   써지고 coerce=true 는 NULL 로 남음 → 붙여넣기 무동작의 근본원인). 그래서 기본 paste 를 막고
      //   숫자로 파싱해 직접 쓴다. 이 경로가 타이핑과 동일한 숫자검증(문자 붙여넣기 차단)도 겸한다.
      const numericCol =
        binding === COLUMN.PFRSLT_QTY ||
        binding === COLUMN.BASE_QTY ||
        isEditablePeriodColumn(binding);
      if (!numericCol) return; // 숫자 컬럼이 아니면 Wijmo 기본 동작에 맡긴다
      const raw = toStr(event.data).replaceAll(',', '').trim();
      event.cancel = true; // 기본 paste 억제 — 아래에서 직접 적용
      let wrote = false;
      if (raw === '') {
        sender.setCellData(event.row, event.col, null, false, true); // 빈값 = 클리어
        wrote = true;
      } else if (Number.isFinite(Number(raw))) {
        // 기간 칸은 정수부 자릿수 상한(시트별 10/14)으로 자른 뒤 쓴다 — 붙여넣기도 타이핑과 동일 제한.
        const capped = isEditablePeriodColumn(binding)
          ? clampIntegerDigits(raw, PERIOD_MAX_INT_DIGITS[sheetRef.current])
          : raw;
        sender.setCellData(event.row, event.col, Number(capped), false, true);
        wrote = true;
      }
      // 숫자 아님 → 아무것도 쓰지 않음(문자 붙여넣기 차단)
      // 붙여넣기도 타이핑 편집과 동일하게 자동계산(PPM 등 RecalcSheet)을 돈다 — 기본 paste 를 막아
      //   cellEditEnded 가 안 불리므로 여기서 직접 재계산을 트리거한다(사용자 지적 2026-10-28).
      if (wrote) editEndedRef.current(event.row, binding);
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
      // 숫자 셀에 숫자 아닌 값이 커밋됐으면 편집 전 값으로 되돌린다(문자 등록 차단, 사용자 요청 2026-10-28).
      //   cellEditEnding 1차 방어가 놓친 경로(활성 에디터 null·blur 커밋 등)의 2차 안전망이다. 재계산 skip.
      const numericCol =
        binding === COLUMN.PFRSLT_QTY ||
        binding === COLUMN.BASE_QTY ||
        isEditablePeriodColumn(binding);
      if (numericCol) {
        const committed = row?.[binding];
        if (
          committed !== null &&
          committed !== undefined &&
          committed !== '' &&
          !Number.isFinite(Number(toStr(committed).replaceAll(',', '')))
        ) {
          sender.setCellData(event.row, event.col, lastEditOldValue ?? null, false, true);
          return;
        }
      }
      editEndedRef.current(event.row, binding);
    };
    grid.cellEditEnded.addHandler(cellEditEndedHandler);

    // 숫자 셀 커밋 검증 — 문자·"1.2.3" 등 숫자로 변환 안 되는 값은 확정 직전에 취소해 등록을 막는다
    //   (사용자 요청 2026-10-28). dataType:Number 는 재편집을 깨서(formatItem textContent 클로버 사고)
    //   안 쓰고, cellEditEnding 으로 값만 검사한다 — 컬럼 타입/렌더를 안 건드려 편집에 영향 없다.
    //   빈값은 클리어로 허용. 콤마(표시 포맷)는 제거 후 판정.
    const cellEditEndingHandler = (
      sender: FlexGridType,
      event: { cancel: boolean; row: number; col: number }
    ) => {
      if (event.cancel) return;
      const binding = sender.columns[event.col]?.binding ?? '';
      const isNumericCol =
        binding === COLUMN.PFRSLT_QTY ||
        binding === COLUMN.BASE_QTY ||
        isEditablePeriodColumn(binding);
      if (!isNumericCol) return;
      const editor = sender.activeEditor as HTMLInputElement | null;
      if (!editor) return;
      const raw = String(editor.value ?? '').replaceAll(',', '').trim();
      if (raw === '') return; // 빈값 = 클리어 허용
      if (!Number.isFinite(Number(raw))) event.cancel = true; // 숫자 아님 → 커밋 취소(이전 값 유지)
    };
    grid.cellEditEnding.addHandler(cellEditEndingHandler);

    // 입력 단계 차단 — 숫자 셀 편집기에 숫자(음수·소수점 1개) 외 입력을 막는다(사용자 요청 2026-10-28:
    //   문자는 입력조차 안 되게). formatItem 가드로 편집기가 보존되므로 리스너가 유지된다(이전 편집깨짐은
    //   dataType·formatItem 클로버였고 지금은 해소). beforeinput 이 Latin·다중소수점을 입력 전에 막고,
    //   input 핸들러가 IME(한글) 등으로 들어온 숫자 외 문자를 즉시 제거한다. 그래도 샌 값은 cellEditEnding/
    //   cellEditEnded 가 2차로 거른다(3중 방어).
    const prepareCellForEditHandler = (sender: FlexGridType, event: { col: number }) => {
      const binding = sender.columns[event.col]?.binding ?? '';
      const isNumericCol =
        binding === COLUMN.PFRSLT_QTY ||
        binding === COLUMN.BASE_QTY ||
        isEditablePeriodColumn(binding);
      if (!isNumericCol) return;
      // 기간 칸(동적 컬럼)은 Operation group(시트)별 정수부 자릿수 상한을 둔다 — Cell/Module=10,
      //   Electrode=14(SCP0105 테스트 자릿수 조치, PERIOD_MAX_INT_DIGITS). 정적 수량 컬럼엔 미적용.
      const periodDigitLimit = isEditablePeriodColumn(binding)
        ? PERIOD_MAX_INT_DIGITS[sheetRef.current]
        : undefined;
      const editor = sender.activeEditor as HTMLInputElement | null;
      if (!editor) return;
      editor.addEventListener('beforeinput', (inputEvent: InputEvent) => {
        // 타이핑(insertText)만 즉시 차단한다. 붙여넣기(insertFromPaste)·IME(insertCompositionText)는
        //   아래 input 핸들러가 숫자 외를 걸러낸다 — 여기서 막으면 개행·탭이 섞인 클립보드(셀/범위 복사)로
        //   붙여넣기가 통째로 막힌다(사용자 지적 2026-10-28).
        if (inputEvent.inputType !== 'insertText') return;
        if (inputEvent.data == null) return; // 삭제·커서이동 등 통과
        const start = editor.selectionStart ?? editor.value.length;
        const end = editor.selectionEnd ?? editor.value.length;
        const next = (
          editor.value.slice(0, start) +
          inputEvent.data +
          editor.value.slice(end)
        ).replaceAll(',', '');
        if (!/^-?\d*\.?\d*$/.test(next)) {
          inputEvent.preventDefault();
          return;
        }
        // 기간 칸 정수부 자릿수 상한 초과 입력은 타이핑 단계에서 막는다(AS-IS MaxLength 체감 동일).
        if (periodDigitLimit !== undefined && integerDigitCount(next) > periodDigitLimit) {
          inputEvent.preventDefault();
        }
      });
      editor.addEventListener('input', () => {
        let cleaned = editor.value.replace(/[^\d.,-]/g, ''); // 숫자·소수점·콤마·마이너스만 남긴다
        // IME 등 beforeinput 을 우회해 들어온 초과 자릿수는 정수부를 상한으로 자른다(2차 방어).
        if (periodDigitLimit !== undefined && integerDigitCount(cleaned) > periodDigitLimit) {
          cleaned = clampIntegerDigits(cleaned, periodDigitLimit);
        }
        if (cleaned !== editor.value) editor.value = cleaned;
      });
    };
    grid.prepareCellForEdit.addHandler(prepareCellForEditHandler);

    return () => {
      try {
        grid.formatItem?.removeHandler(formatItemHandler);
        grid.beginningEdit?.removeHandler(beginningEditHandler);
        grid.pastingCell?.removeHandler(pastingCellHandler);
        grid.cellEditEnded?.removeHandler(cellEditEndedHandler);
        grid.cellEditEnding?.removeHandler(cellEditEndingHandler);
        grid.prepareCellForEdit?.removeHandler(prepareCellForEditHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns, periodColumns]);

  /**
   * (b) 병합 토글 — **데이터 셀 병합은 끈다(비병합)**. AS-IS `SetSheetMerge`(cs:2147~2154)는 `!IsEditMode`
   * (읽기모드)일 때만 `ToggleMerge`+`SmartColMerge` 로 병합하고 **편집 진입 시 `SetToggleMerge(false)` 로
   * 해제**한다. TO-BE 는 편집 토글을 이식하지 않아(convert-core §2.4) `editMode=canEdit` 가 EDIT 권한자에게
   * 항상 true = **항상 편집모드**이므로, AS-IS 수정모드와 동일하게 **처음부터 병합이 풀린 상태**가 파리티다
   * (사용자 확정 2026-10-28: AS-IS 수정모드 캡처가 전부 비병합). 헤더 머지(ColumnHeaders)는 유지. 기간
   * (동적) 컬럼은 `buildPeriodColumns` 의 `allowMerging:false` 로도 별도 차단된다.
   */
  const allowMerging = isEditMode
    ? AllowMerging.ColumnHeaders // 데이터 셀 병합 해제, 3단 헤더 머지만 유지
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

  // 헤더 총높이 48px 고정 — `headerRowHeight` prop(공용 DataGrid 가 columnHeaders.rows.defaultSize 만
  //   세팅)만으로는 정적 컬럼 baked height 가 defaultSize 를 이겨 tier 마다 벌어진다. 형제 capa-line-assign
  //   applyHeaderHeight 정본대로, 렌더된 tier 수로 48 을 균등배분해 각 header row.height·defaultSize 에 직접
  //   박는다. 목표값과 같으면 skip → 무한루프 방지.
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const applyHeaderHeight = () => {
      const headerRows = grid.columnHeaders?.rows;
      if (!headerRows || headerRows.length === 0) return;
      const target = HEADER_TOTAL_HEIGHT / headerRows.length;
      let changed = false;
      for (let i = 0; i < headerRows.length; i += 1) {
        if (Math.round(headerRows[i].height ?? headerRows.defaultSize) !== Math.round(target)) {
          headerRows[i].height = target;
          changed = true;
        }
      }
      if (Math.round(headerRows.defaultSize) !== Math.round(target)) {
        headerRows.defaultSize = target;
        changed = true;
      }
      if (changed) grid.invalidate(true);
    };
    grid.updatedLayout.addHandler(applyHeaderHeight);
    applyHeaderHeight();
    return () => {
      try {
        grid.updatedLayout?.removeHandler(applyHeaderHeight);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns, periodColumns]);

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
      // headerRowHeight 정적 prop 제거(SCP0100 류 무한 header-height 루프 방지) — 공용 DataGrid 가 정적
      //   prop 으로 defaultSize 를 되돌리는 것과 자체 applyHeaderHeight 의 동적 tier 보정이 충돌해 무한
      //   invalidate 가 됐다. 총높이 48px 고정은 위 applyHeaderHeight 가 tier 수로 균등배분해 박는 단일 출처다.
      allowMerging={allowMerging}
      // 메타(`FIXED_FLAG`)가 경계를 표현하면 prop 을 **넘기지 않는다**(위 주석). 키 자체를 빼야
      //   공용 DataGrid 의 산출값이 `{...gridProps}` 에 덮이지 않는다.
      {...(frozenColumnsOverride === undefined ? {} : { frozenColumns: frozenColumnsOverride })}
    />
  );
};
