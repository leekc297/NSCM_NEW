import { toggleClass } from '@mescius/wijmo';
import { AllowMerging, CellType } from '@mescius/wijmo.grid';
import type { CellRangeEventArgs, FlexGrid as FlexGridType, FormatItemEventArgs } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import styles from 'features/shipping/src/pages/shipment-request-pack/ShipmentRequestPack.module.scss';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, paintNegativeText, toGridNumber, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import { ADMIN_SHEET_NAME, MEASURE_COLOR, SHEETS } from '../shipment-request-pack.constants';
import type { CellRow, PackRow, SearchParamProps } from '../shipment-request-pack.types';
import {
  dailyKeysOfMonth,
  dailyKeysOfWeek,
  distributeToDaily,
  monthKeyOfDaily,
  splitMonthlyByDefaultDay,
  splitWeeklyByDefaultDay,
  sumValues,
  weekKeyOfDaily,
  weekKeysOfMonth,
} from '../utils/shipment-request-pack.autoSync';
import { parseDynamicColumnTag } from '../utils/shipment-request-pack.dynamicColumn';
import { isMainGridCellEditable, isMainGridDateConfirmed } from '../utils/shipment-request-pack.editLock';
import {
  buildDynamicColumns,
  buildDynColMetas,
  buildWeekendColorByBinding,
  BUCKET_PREFIX,
  DYN_RANK,
  dynKindOf,
  SpreadHeaderMergeManager,
  type SpreadTitleRow,
} from '../utils/shipment-request-pack.spreadHeader';

// design 01 R18 — Measure 행 배경 4색 팔레트(RGB). MEASURE_COLOR 상수(측정값 그룹)를 코드→색으로
//   역매핑. DMF0045 ShipmentRequestGrid 와 동일하게 MEASURE 셀 배경으로 칠한다(formatItem + .sp-cell-bg).
//   주의: MEASURE 셀은 combo(dataMap)라 표시는 명칭이지만 row.MEASURE raw 값은 코드(PACK_FP 등, design 03 §1.1 #16).
const MEASURE_BLUE_BG = 'rgb(219, 229, 241)';
const MEASURE_BG: Record<string, string> = {
  ...Object.fromEntries(MEASURE_COLOR.BLUE.map(m => [m, MEASURE_BLUE_BG])),
  ...Object.fromEntries(MEASURE_COLOR.ORANGE.map(m => [m, 'rgb(255, 193, 158)'])),
  ...Object.fromEntries(MEASURE_COLOR.GREEN.map(m => [m, 'rgb(228, 247, 186)'])),
};

// SP 응답 hidden 컬럼 MEASURE_COLOR('r,g,b', design 03 §1.1 #17) → CSS rgb(). DMF0045 measureColorToCss 동일.
//   'r,g,b' 3요소·0~255 만 인정, 그 외 '' 로 무시(잘못된 색 방지).
const measureColorToCss = (raw: string | undefined): string => {
  const parts = (raw ?? '')
    .split(',')
    .map(p => p.trim());
  if (parts.length !== 3) return '';
  if (parts.some(p => !/^\d{1,3}$/.test(p) || Number(p) > 255)) return '';
  return `rgb(${parts[0]}, ${parts[1]}, ${parts[2]})`;
};

// ── [ROLLBACK:ssp0026-measure-requestor-swap · 2026-11-09] ─────────────────────────────────
//   사용자 지시(2026-11-09): 메인 그리드에서 Measure 와 Requestor(LAST_UPDATED_BY)의 좌우 위치를
//   교체한다(AS-IS SSP0026 순서 = Measure, Requestor). DMF0045 swapMeasureBeforeRequestor 파리티 —
//   데이터/개인화/머지는 건드리지 않는 **표시(display) 전용** 교체다.
//
//   왜 '표시만' 바꾸고 머지(SpreadHeaderMergeManager)는 원본 순서로 두나:
//     · 좌측 정적 컬럼 세로병합은 fixedBindings 순서로 leftBindings 계층을 만든다(spreadHeader.ts:196).
//       원본 순서(Requestor 가 Measure 앞)에서 Requestor 는 같은 레코드의 measure 행들에서 세로병합되고
//       MEASURE 는 행마다 값이 달라 병합되지 않는다. 표시만 Measure 를 앞으로 옮기면 병합은 binding
//       이름·세로 범위 기준이라 그대로 유지된다(DMF0045 동일 논리).
//
//   왜 fixed 재부여가 필요한가:
//     · MEASURE 가 frozen 앵커(공용 DataGrid frozenColumns=findLastIndex(_fixed)+1)인데 Measure 를 앞으로
//       옮기면 뒤로 간 Requestor 가 고정영역 밖으로 빠진다 → 새 마지막(Requestor)에 fixed:true 를 부여해
//       정적 블록 전체 frozen 을 유지한다.
//
//   롤백: 이 함수 호출(displayStaticColumns)을 벗겨 DataGrid staticColumns 를 원본 staticColumns 로 되돌린다.
const swapMeasureBeforeRequestor = (
  cols: RawFlexGridColumnConfig[]
): RawFlexGridColumnConfig[] => {
  const mi = cols.findIndex(c => c.colNm === 'MEASURE');
  const ri = cols.findIndex(c => c.colNm === 'LAST_UPDATED_BY');
  // 둘 다 존재하고 아직 '원래 순서'(Requestor 가 Measure 앞)일 때만 교체 — 멱등(이미 바뀐 상태/부재 시 무변경).
  if (mi < 0 || ri < 0 || ri > mi) return cols;
  const next = cols.slice();
  const [measure] = next.splice(mi, 1); // Measure 추출
  next.splice(ri, 0, measure); // Requestor 자리(앞)에 삽입 → [..., Measure, Requestor]
  // 고정경계 유지: 새 마지막(Requestor)도 frozen. Measure 의 fixed:true 는 그대로 둔다.
  return next.map(c => (c.colNm === 'LAST_UPDATED_BY' ? { ...c, fixed: true } : c));
};

interface Props<Row extends PackRow | CellRow> {
  sheet: SHEETS.PACK | SHEETS.CELL;
  rows: Row[];
  gridRef: MutableRefObject<FlexGridType<Row> | undefined>;
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef?: MutableRefObject<EditTracker<Row> | undefined>;
  staticColumns: RawFlexGridColumnConfig[];
  bucketType: SearchParamProps['bucketType'];
  isEditMode: boolean;
  onFocus: () => void;
  // Measure 배경색 매핑용 — SCM_MST_SHEET_MEASURE(colNm=코드, colLblNm=표시명). MEASURE 셀 raw 값이
  //   코드/표시명 어느 쪽이든 매칭되도록 둘 다 키로 색맵을 만든다(design 01 R18).
  measures?: { colNm: string; colLblNm?: string }[];
  // GET_SPREAD_TITLE(배포됨) 동적 pivot 헤더 메타 — 3단 병합 헤더(년월/주차/일) 라벨 소스(R17).
  //   동적 부분은 sheetName 무관 캘린더 기반이라 Pack/Cell 공용 1건을 받는다.
  spreadTitle?: SpreadTitleRow[];
  // SHIP_REQ 행 Measure/날짜 셀 더블클릭 → 하단 Request Detail 재조회(AS-IS FindData_Detail_DblClick).
  //   Pack 시트·읽기전용(isEditMode=false)에서만 발동. date=null 이면 상단 Period 전체.
  onDrillDetail?: (modelId: string, scmSiteId: string, date: string | null) => void;
  // Cell Biz 신규행 Model 셀 더블클릭 → Item 팝업(AS-IS SpdMain_CellDoubleClick Cell 분기 cs:3848-3909,
  //   cellTypeImage). Cell 시트 전용 — 페이지가 From/To Site 선검증 후 팝업을 연다.
  onCellModelDblClick?: (row: Row) => void;
  // Cell Biz 신규행 Trans Mode 셀 더블클릭 → BOD 팝업(DMF0045 파리티, 사용자 결정 2026-11-04). Cell 시트
  //   전용 — 페이지가 Model(MODEL_ID) 선검증 후 팝업을 연다. 선택 시 From/To/Incoterms/TrMode/BOD_ID 세팅.
  onBodCellDblClick?: (row: Row) => void;
  // 확정일(yyyymmdd) — Pack=Plan_InforPacker_SCP NAME / Cell=CONFIRM_DAY. 확정구간(D_ ≤ confirmDay)
  //   회색+잠금, 그 이후 SHIP_REQ 날짜셀만 편집(design 01 R7/R18). 미전달이면 확정구간 미표시.
  confirmDay?: string;
  // 셀 콤보(@divisionId/@mnuId) 바인드 해소용 — Cell Biz FromSite/ToSite 콤보 SQL @키 치환.
  comboParams?: Record<string, string>;
  // 기본요일 코드(MON/TUE/.../SUN) — W→D/M→D 배분 기준(AS-IS DefaultBucketDay). 미확보('')면 균등분배 폴백.
  defaultBucketDay?: string;
}

/**
 * spdMain(siMain) — Pack Biz / Cell Biz 공용 pivot 그리드(design 03 §1.1/§1.2). 조회 직후
 * 전 컬럼 read-only(design 01 R6), Edit 버튼 클릭 시 기존행은 unlock(R7), 신규행(CRUD_TYPE='I')은
 * Edit 버튼과 무관하게 `INSERT_EDITABLE_COLUMNS_MAIN` 화이트리스트만 unlock 된다(R9,
 * `shipment-request-pack.editLock.isMainGridCellEditable`).
 *
 * Auto-Sync 3방향 배분(D↔W↔M, 03_grid-columns.md R20)은 아래 useEffect(`cellEditEnded`/
 * `pastedCell`)가 처리한다 — production-plan-line(productionPlanLineDerive.ts)의 검증된
 * "균등분배 + 나머지 마지막 셀" 산식을 그대로 확장했다. `DefaultBucketDay`(기본요일 전량배정)
 * 분기는 그 콤보가 DB 실측되지 않아(§6 확인 필요) 구현하지 않는다 — 04_react-gap.md 이월.
 *
 * 미완(04_react-gap.md — 임의 구현 금지, 후속 회차):
 * - Measure=="SHIP_REQ" 행 확정구간(CONFIRM_DAY) 이후만 unlock 하는 행/컬럼 단위 lock 세분화(R7,
 *   신규행 동적 pivot 컬럼 추가 unlock 포함) — CONFIRM_DAY 판정 부재로 기존행은 전체 unlock 으로 남김
 * - Measure 4색 배경 + 확정구간 회색(R18)
 * - Auto-Sync 저장 전 7개 필수값 검증 + 실패 시 입력 롤백(R22)
 * - BOD_ID 자동세팅(Incoterms/TrMode 셀콤보 변경 시 GET_BOD_ITEM 백그라운드 재조회, R10/R14)
 */
export const ShipmentRequestPackMainGrid = <Row extends PackRow | CellRow>({
  sheet,
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  staticColumns,
  bucketType,
  isEditMode,
  onFocus,
  measures,
  spreadTitle,
  onDrillDetail,
  onCellModelDblClick,
  onBodCellDblClick,
  confirmDay,
  comboParams,
  defaultBucketDay,
}: Props<Row>) => {
  // Auto-Sync 핸들러는 1회 등록(빈 deps)이라 최신 기본요일을 ref 로 읽는다.
  const defaultBucketDayRef = useRef(defaultBucketDay ?? '');
  defaultBucketDayRef.current = defaultBucketDay ?? '';
  // 주말 D_ leaf 헤더 색 맵 ref — 선언은 여기(formatItem useEffect 앞)에 둬 use-before-define 를 없앤다.
  //   실제 값(.current)은 아래 dynColMetas 가 준비된 뒤 할당한다. formatItem 콜백은 렌더 후 실행돼 최신값을 읽는다.
  const weekendColorRef = useRef<Map<string, string>>(new Map());
  // 표시 전용 컬럼 — Measure 를 Requestor 앞으로 교체(item 1, AS-IS/DMF0045 파리티). 머지(mergeManager)·
  //   blueRange·편집가드는 원본 staticColumns 를 그대로 쓴다(병합은 binding·세로 기준이라 표시 위치와 무관).
  const displayStaticColumns = useMemo(
    () => swapMeasureBeforeRequestor(staticColumns),
    [staticColumns]
  );

  // MEASURE 셀 raw 값 → 배경색. 코드(colNm)와 표시명(colLblNm) 둘 다 키로 둬 raw 값이 어느 쪽이든 매칭.
  //   formatItem(빈 deps)이 ref 로 최신 맵을 읽는다 — measures 가 async 로 와도 stale 안 됨.
  const colorMapRef = useRef<Record<string, string>>({});
  colorMapRef.current = useMemo(() => {
    const map: Record<string, string> = { ...MEASURE_BG };
    for (const m of measures ?? []) {
      const color = MEASURE_BG[m.colNm];
      if (color && m.colLblNm) map[m.colLblNm] = color;
    }
    return map;
  }, [measures]);

  // BLUE 그룹(집계/시스템) measure 행에서 연파랑을 칠할 정적 컬럼 범위 — AS-IS cs:734
  //   SetBGColor(FromSite..Requestor). FROM_SITE~LAST_UPDATED_BY 사이 정적 컬럼(MEASURE 는
  //   MEASURE 셀 전담이라 제외)을 admin 메타 순서(DISPLAY_SEQ) 기준으로 뽑는다. Pack/Cell 시트가
  //   컬럼 구성이 달라도 staticColumns 로 자동 적응한다(인덱스 하드코딩 금지).
  const blueRangeBindingsRef = useRef<Set<string>>(new Set());
  blueRangeBindingsRef.current = useMemo(() => {
    const cols = staticColumns.map(c => c.colNm);
    const set = new Set<string>();
    const from = cols.indexOf('FROM_SITE');
    const to = cols.indexOf('LAST_UPDATED_BY');
    if (from === -1 || to === -1 || from > to) return set;
    for (let i = from; i <= to; i++) {
      if (cols[i] !== 'MEASURE') set.add(cols[i]);
    }
    return set;
  }, [staticColumns]);

  // 셀 편집 가드(design 01 R7/R9/R18). 공용 DataGrid 의 setEditableColumns 는 동적(D_/W_/M_) 컬럼에
  //   INPUT_TP_CD 메타가 없어 무조건 편집을 cancel 한다. 그래서 그 핸들러 뒤(useEffect 등록 시점)에
  //   붙여, 동적 셀은 내 판정으로 e.cancel 을 **명시 override**(editable 이면 false 로 되돌려 편집 허용,
  //   아니면 true 로 잠금)한다. 정적 셀은 공용 게이트(INPUT_TP_CD)에 맡기고 추가 잠금만 건다
  //   (FIFO 마지막 핸들러의 cancel 이 공용 read-only 보다 우선 — DMF0045 beginningEdit 동일 패턴).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const guard = (_s: FlexGridType<Row>, e: CellRangeEventArgs) => {
      const binding = g.columns[e.col]?.binding ?? '';
      const dataItem = GridUtils.getRow(g, e.row) as
        | (Row & { CRUD_TYPE?: string; MEASURE?: string })
        | undefined;
      if (!binding || !dataItem) return;
      // Cell Biz 신규행 Model·Trans Mode 셀은 팝업 전용(직접 타이핑/콤보 차단) — DMF0045 모달셀 패턴.
      //   값은 더블클릭 팝업으로만 넣는다(Model=Item 팝업 / Trans Mode=BOD 팝업). 편집 하이라이트(노랑)·
      //   팝업 아이콘은 유지되고 입력 경로만 막는다. Incoterms 는 콤보 유지(DMF0045 동일 — BOD 팝업이 채움).
      if (
        sheet === SHEETS.CELL &&
        (binding === 'MODEL_ID' || binding === 'TR_MODE') &&
        dataItem.CRUD_TYPE === 'I'
      ) {
        e.cancel = true;
        return;
      }
      // Pack Biz 상단은 AS-IS read-only(EditButton 에 Pack 분기 없음, FindData LockColumn2) — 편집 불가.
      //   편집은 Cell Biz 상단에서만(SHIP_REQ 날짜셀). 그래서 Cell 시트로 게이트한다.
      const editable =
        sheet === SHEETS.CELL &&
        isMainGridCellEditable({
          columnBinding: binding,
          crudType: dataItem.CRUD_TYPE,
          isEditMode,
          measure: dataItem.MEASURE,
          bucketType,
          confirmDay,
        });
      if (parseDynamicColumnTag(binding)) e.cancel = !editable;
      else if (!editable) e.cancel = true;
    };
    g.beginningEdit.addHandler(guard);
    g.pastingCell.addHandler(guard);
    return () => {
      try {
        g.beginningEdit?.removeHandler(guard);
        g.pastingCell?.removeHandler(guard);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isEditMode, bucketType, confirmDay, staticColumns, sheet]);

  // Auto-Sync 3방향 배분(design 03 §2-4/R20) — D 입력 시 소속 W/M 재집계, W/M 입력 시 소속 D 균등분배
  //   (+나머지 마지막 셀), 음수 입력은 하위 D 합계로 원복(production-plan-line 선례 그대로 확장).
  //   화면이 직접 cellEditEnded 에 붙이되, DataGrid 의 EditTracker 등록(initialized 시점) 뒤에
  //   mount 되는 이 useEffect 순서를 그대로 따른다(DataGrid.tsx 주석 규약, production-plan-line 동일).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    const handler = (sender: FlexGridType<Row>, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const tag = parseDynamicColumnTag(binding);
      if (!tag) return;
      const row = sender.rows[e.row]?.dataItem as (Row & Record<string, unknown>) | undefined;
      if (!row) return;

      const tracker = editTrackerRef?.current;
      const setCell = (key: string, value: number) => {
        const prev = row[key];
        tracker?.storeChange(row as never, key, prev as never, value as never);
        row[key] = value;
      };
      const rowKeys = Object.keys(row);

      const defaultDay = defaultBucketDayRef.current;
      if (tag.bucket === 'D') {
        const weekKey = weekKeyOfDaily(rowKeys, binding);
        if (weekKey) setCell(weekKey, sumValues(dailyKeysOfWeek(rowKeys, weekKey).map(k => row[k])));
        const monthKey = monthKeyOfDaily(rowKeys, binding);
        if (monthKey) setCell(monthKey, sumValues(dailyKeysOfMonth(rowKeys, monthKey).map(k => row[k])));
      } else if (tag.bucket === 'W') {
        // W→D: AS-IS DefaultBucketDay 배분 — 그 주 기본요일 1일에 전량(나머지 0). 기본요일 미확보 시 균등분배 폴백.
        //   음수는 되돌리지 않고 그대로 배분한다(AS-IS 는 저장검증 V6/MSG00699 에서 차단, validateMainSave).
        const dayKeys = dailyKeysOfWeek(rowKeys, binding);
        const weekVal = Number(String(row[binding]).replace(/,/g, '')) || 0;
        if (dayKeys.length > 0 && defaultDay) {
          splitWeeklyByDefaultDay(dayKeys, weekVal, defaultDay).forEach(({ key, qty }) => setCell(key, qty));
        } else if (dayKeys.length > 0) {
          distributeToDaily(weekVal, dayKeys.length).forEach((v, i) => setCell(dayKeys[i], v));
        }
        const monthKey = dayKeys.length > 0 ? monthKeyOfDaily(rowKeys, dayKeys[0]) : undefined;
        if (monthKey) setCell(monthKey, sumValues(dailyKeysOfMonth(rowKeys, monthKey).map(k => row[k])));
      } else if (tag.bucket === 'M') {
        // M→D: AS-IS DefaultBucketDay 배분 — 그 달 기본요일 날짜들에 균등분배(+나머지 마지막). 폴백 균등분배.
        const dayKeys = dailyKeysOfMonth(rowKeys, binding);
        const monthVal = Number(String(row[binding]).replace(/,/g, '')) || 0;
        if (dayKeys.length > 0 && defaultDay) {
          splitMonthlyByDefaultDay(dayKeys, monthVal, defaultDay).forEach(({ key, qty }) => setCell(key, qty));
        } else if (dayKeys.length > 0) {
          distributeToDaily(monthVal, dayKeys.length).forEach((v, i) => setCell(dayKeys[i], v));
        }
        weekKeysOfMonth(rowKeys, binding).forEach(weekKey => {
          setCell(weekKey, sumValues(dailyKeysOfWeek(rowKeys, weekKey).map(k => row[k])));
        });
      }
      sender.invalidate();
    };

    g.cellEditEnded.addHandler(handler);
    g.pastedCell.addHandler(handler);
    return () => {
      try {
        g.cellEditEnded?.removeHandler(handler);
        g.pastedCell?.removeHandler(handler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // Measure 행 배경색(design 01 R18, AS-IS cs:732-743 — DMF0045 AGG_ROW_BG 패턴). 두 규칙이다:
  //   (1) BLUE 그룹 measure(PACK_FP 등 8종, 집계/시스템 행) → FROM_SITE..LAST_UPDATED_BY 정적 컬럼
  //       전체를 연파랑(cs:734 SetBGColor). MEASURE 셀은 (2)에서 같은 파랑으로 함께 칠해진다.
  //   (2) MEASURE 셀 → MEASURE_COLOR(SP RGB) 우선, 없으면 팔레트. SCP_SHIP_PLAN=주황·SHIP_REQ=연두는
  //       MEASURE 셀만, 정적 블록은 흰색(cs:736-742 measureIdx 단일 셀).
  //   --sp-cell-bg 변수 + .sp-cell-bg 클래스로 적용해 선택 셀엔 미적용(공통 selection 스타일 우선,
  //   ShipmentRequestPack.module.scss 의 :not(.wj-state-selected) 규칙).
  //   같은 핸들러에서 동적 헤더의 주말 leaf(최하단 행) 글자색도 칠한다(토 파랑 / 일 빨강, AS-IS cs:542).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const fmt = (s: FlexGridType<Row>, e: FormatItemEventArgs) => {
      if (e.panel.cellType === CellType.ColumnHeader) {
        const isLeafHeaderRow = e.row === e.panel.rows.length - 1;
        const headerBinding = e.panel.columns[e.col]?.binding;
        const color = isLeafHeaderRow && headerBinding ? weekendColorRef.current.get(headerBinding) : undefined;
        if (color) e.cell.style.setProperty('color', color, 'important');
        return;
      }
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = s.columns[e.col]?.binding ?? '';
      const row = s.rows[e.row]?.dataItem as
        | { MEASURE?: string; MEASURE_COLOR?: string; CRUD_TYPE?: string }
        | undefined;
      if (!row) return;
      const measureKey = String(row.MEASURE ?? '');
      let bg: string | undefined;
      if (binding === 'MEASURE') {
        // SP hidden 컬럼 MEASURE_COLOR(AS-IS SetBGColor 색) 우선, 없으면 FE 팔레트(코드/명칭 맵) 폴백.
        bg = measureColorToCss(row.MEASURE_COLOR) || colorMapRef.current[measureKey];
      } else if (blueRangeBindingsRef.current.has(binding) && colorMapRef.current[measureKey] === MEASURE_BLUE_BG) {
        // BLUE 그룹 measure 행의 정적 블록만 연파랑(주황·연두 measure 는 MEASURE 셀만 칠하므로 흰색 유지).
        bg = MEASURE_BLUE_BG;
      }
      if (bg) {
        e.cell.style.setProperty('--sp-cell-bg', bg);
        e.cell.classList.add('sp-cell-bg');
      } else {
        e.cell.style.removeProperty('--sp-cell-bg');
        e.cell.classList.remove('sp-cell-bg');
      }
      // 편집가능/확정구간 시각표시(design 01 R7/R9/R18, DMF0045 wj-cell-editable/non-editable 동일).
      //   편집 하이라이트는 Cell Biz 상단에서만 — Pack Biz 는 AS-IS read-only(노란셀 없음). 정적·동적
      //   모두 대상: 신규행은 화이트리스트 정적 셀(Model/From/To/FcstType/TrMode/Incoterms)도 편집가능
      //   하이라이트가 떠야 한다(AS-IS InsertRow LockRange(false) 구간, 사용자 신고 2026-11-04 — 종전엔
      //   동적 셀만 칠해 신규행 정적 편집셀이 무색이었다). 회색(확정구간)·음수글자는 동적 셀만.
      const editable =
        sheet === SHEETS.CELL &&
        isMainGridCellEditable({
          columnBinding: binding,
          crudType: row.CRUD_TYPE,
          isEditMode,
          measure: row.MEASURE,
          bucketType,
          confirmDay,
        });
      toggleClass(e.cell, 'wj-cell-editable', editable);
      if (parseDynamicColumnTag(binding)) {
        toggleClass(e.cell, 'wj-cell-non-editable', isMainGridDateConfirmed(binding, confirmDay));
        // 음수 = 빨간 글자(공용 paintNegativeText) — 동적 수량 셀만, 배경/하이라이트와 공존(글자색만).
        paintNegativeText(e.cell, toGridNumber((row as Record<string, unknown>)[binding]));
      } else {
        toggleClass(e.cell, 'wj-cell-non-editable', false);
      }
      // Cell Biz 신규행 Model·Trans Mode 셀 — DMF0045 모달셀 패턴: 팝업 아이콘을 셀에 붙여 "팝업으로 값을
      //   넣는 셀"임을 표시한다(직접 타이핑은 beginningEdit 에서 차단, 값 입력은 더블클릭 팝업 전용 —
      //   Model=Item 팝업 / Trans Mode=BOD 팝업). 그 외 셀/행은 아이콘 제거(querySelector 가드로 멱등).
      const isCellModelPopup =
        sheet === SHEETS.CELL &&
        (binding === 'MODEL_ID' || binding === 'TR_MODE') &&
        row.CRUD_TYPE === 'I';
      if (isCellModelPopup) {
        e.cell.style.cursor = 'pointer';
        e.cell.style.paddingRight = '20px';
        if (!e.cell.querySelector('.popup-icon')) {
          const icon = document.createElement('span');
          icon.className = `popup-icon ${styles.popupIcon}`;
          e.cell.appendChild(icon);
        }
      } else {
        e.cell.querySelector('.popup-icon')?.remove();
      }
    };
    g.formatItem.addHandler(fmt);
    g.invalidate();
    return () => {
      try {
        g.formatItem?.removeHandler(fmt);
      } catch {
        /* unmount race */
      }
    };
    // staticColumns/measures 가 로드되면(초기 [] → 데이터) 재실행 — 그 시점에 gridRef.current 가
    //   채워져 있어 핸들러가 확실히 등록된다(DMF0045 formatItem useEffect 와 동일 — deps 로 grid-ready 보장).
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns, measures, isEditMode, bucketType, confirmDay, sheet]);

  // 동적 pivot 컬럼(design 03 §2, R17) — GET_SPREAD_TITLE 우선, 없으면 조회 row 의 동적 키 집합에서
  //   파생해 3단 병합 헤더(년월/주차/일)를 만든다(AS-IS SetSpreadHeaderSpan, DMF0045 동일 패턴).
  //   fallback 은 rows 배열 참조가 아니라 '동적 키 서명'에만 의존시킨다 — 행추가마다 참조가 바뀌면
  //   columnGroups 가 재생성돼 다단 헤더가 깜빡인다(DMF0045 rowDynKeySig 선례).
  const rowDynKeySig = useMemo(() => {
    if ((spreadTitle?.length ?? 0) > 0) return ''; // spreadTitle 우선 경로 — rows 미참조
    const set = new Set<string>();
    rows.forEach(row => {
      Object.keys(row as Record<string, unknown>).forEach(key => {
        if (parseDynamicColumnTag(key)) set.add(key);
      });
    });
    return [...set].sort().join(',');
  }, [spreadTitle, rows]);
  const dynColMetas = useMemo(
    () => buildDynColMetas(spreadTitle, rowDynKeySig ? rowDynKeySig.split(',') : []),
    [spreadTitle, rowDynKeySig]
  );
  const dynamicColumns = useMemo(() => buildDynamicColumns(dynColMetas), [dynColMetas]);
  // 주말 D_ leaf 헤더 색(토 파랑 / 일 빨강, AS-IS cs:542) — formatItem(헤더)이 ref 로 최신 맵을 읽는다.
  //   weekendColorRef 선언은 위(defaultBucketDayRef 옆)로 올렸고 여기선 값만 할당한다(dynColMetas 준비 후).
  weekendColorRef.current = useMemo(() => buildWeekendColorByBinding(dynColMetas), [dynColMetas]);

  // 버킷 드릴다운(design 01 R16, AS-IS SetSpreadColumn + 더블클릭 — DMF0045 동일). 전 버킷(M/W/D)을
  //   중첩 렌더하되 기본 표시는 활성 버킷만. 상위(summary)는 SSP0026 에 chkSum 이 없어 항상 숨김,
  //   하위(drill)는 숨김 상태로 두고 상위 헤더 더블클릭 시 전개한다.
  const activeRank = DYN_RANK[BUCKET_PREFIX[bucketType]];
  const dynBindings = useMemo(() => dynColMetas.map(m => m.binding), [dynColMetas]);
  const summaryBindings = useMemo(
    () => new Set(dynColMetas.filter(m => DYN_RANK[m.kind] < activeRank).map(m => m.binding)),
    [dynColMetas, activeRank]
  );
  const drillBindings = useMemo(
    () => new Set(dynColMetas.filter(m => DYN_RANK[m.kind] > activeRank).map(m => m.binding)),
    [dynColMetas, activeRank]
  );
  // 드릴 오버라이드(binding → visible). bucket/조회 변경 시 리셋(AS-IS SetSpreadColumn 재실행 1:1).
  const drillVisRef = useRef<Map<string, boolean>>(new Map());
  const applyDynVisibilityRef = useRef<(() => void) | null>(null);
  const dynBindingsRef = useRef<string[]>(dynBindings);
  dynBindingsRef.current = dynBindings;

  // 다단 헤더 총높이 48px 고정 (1단 48 / 2단 24×2 / 3단 16×3) — DMF0045 hook #93 동일. DataGrid 의
  //   headerRowHeight prop(defaultSize 만 설정)은 전역 조밀 행높이에 덮이므로, updatedLayout 에서
  //   각 헤더 row.height 를 명시 강제한다([[grid-two-tier-header-row-height-per-row]]).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const applyHeaderHeight = () => {
      const headerRows = g.columnHeaders?.rows;
      if (!headerRows || headerRows.length === 0) return;
      const per = Math.round(48 / headerRows.length);
      if (
        Math.round(headerRows.defaultSize) === per &&
        Math.round(headerRows[0]?.height ?? 0) === per
      ) {
        return;
      }
      headerRows.defaultSize = per;
      for (let i = 0; i < headerRows.length; i++) headerRows[i].height = per;
    };
    g.updatedLayout.addHandler(applyHeaderHeight);
    applyHeaderHeight();
    return () => {
      try {
        g.updatedLayout?.removeHandler(applyHeaderHeight);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [dynamicColumns, staticColumns]);

  // spdMain 병합(AS-IS SmartColMerge + 헤더 병합) — 커스텀 매니저가 (1)좌측 정적 컬럼 데이터셀 계층
  //   세로병합(아이템 그룹) (2)정적 헤더 세로 span (3)월 SUM 세로병합을 모두 담당. 데이터셀 병합을
  //   켜려면 g.allowMerging=All + 정적 컬럼 allowMerging=true 가 필요하다(동적·MEASURE 는 매니저가 null
  //   반환으로 비병합). columnGroups 재대입이 allowMerging 을 리셋하므로 그리드 준비/컬럼 변경 시 재적용.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const fixed = new Set(staticColumns.map(c => c.colNm));
    g.mergeManager = new SpreadHeaderMergeManager(staticColumns.map(c => c.colNm));
    // 패널 레벨 allowMerging 은 DataGrid prop(AllowMerging.All)이 매 렌더 적용한다. 여기선 정적 컬럼만
    //   컬럼 레벨 allowMerging=true(그 컬럼 데이터셀 병합 허용) — 동적·MEASURE 는 false 로 비병합.
    for (let i = 0; i < g.columns.length; i++) {
      g.columns[i].allowMerging = fixed.has(g.columns[i].binding ?? '');
    }
    g.invalidate();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [dynamicColumns, staticColumns]);

  // 동적 컬럼 visible 적용 — 활성 버킷=표시 / 상위(summary)=숨김(chkSum 없음) / 하위(drill)=숨김,
  //   드릴 오버라이드(drillVisRef) 우선. columnGroups 재대입마다(updatedLayout) 되돌아가므로 매번 재적용.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    drillVisRef.current.clear(); // bucket/조회 변경 = 드릴 상태 리셋
    const dynSet = new Set(dynBindings);
    const applyDynVisibility = () => {
      let changed = false;
      for (let i = 0; i < g.columns.length; i++) {
        const col = g.columns[i];
        const b = col.binding ?? '';
        if (!dynSet.has(b)) continue;
        // 활성 버킷만 기본 표시(상위·하위 전부 숨김), 드릴로 켠 것만 예외.
        const base = !summaryBindings.has(b) && !drillBindings.has(b);
        const want = drillVisRef.current.get(b) ?? base;
        if (col.visible !== want) {
          col.visible = want;
          changed = true;
        }
      }
      if (changed) g.invalidate(true);
    };
    applyDynVisibilityRef.current = applyDynVisibility;
    g.updatedLayout.addHandler(applyDynVisibility);
    applyDynVisibility();
    return () => {
      try {
        g.updatedLayout?.removeHandler(applyDynVisibility);
        applyDynVisibilityRef.current = null;
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [dynBindings, summaryBindings, drillBindings, staticColumns]);

  // 헤더 더블클릭 드릴다운(AS-IS SetSpreadColumn 더블클릭 1:1 — DMF0045 동일). M_ 헤더: 그 달 구간의
  //   W_ 토글(전개/접기) + 보이는 D_ 접기. W_ 헤더: 그 주 구간의 D_ 토글. 활성 버킷보다 하위만 대상.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const dblclickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      // 데이터 셀 더블클릭 → 하단 Request Detail 재조회(AS-IS SpdMain_CellDoubleClick, Pack 시트 +
      //   SHIP_REQ 행). 드릴 대상 셀(AS-IS 파리티, 2026-11-04 사용자 확인):
      //     - Measure 셀 / 정적 셀(Div·Model·From/To-Site·Team·Incoterms·Requestor 등) → 상단 Period 전체.
      //       AS-IS 는 Ship Req 행이면 정적 셀도 vDate 공백으로 드릴한다(cs:3928-3931, else 분기 strDate=
      //       정적컬럼 Tag=공백 → 전체 기간). 종전 TO-BE 는 정적 셀을 제외했으나 사용자 요청으로 복원.
      //     - 동적(D_/W_/M_) 값 셀 → 그 값셀 기준(D_=그 하루, W_/M_=상단 Period). AS-IS 는 값 가드가
      //       없으나, 사용자 확인대로 동적 셀은 **0 아닌 값**일 때만 드릴한다(빈 셀 무의미 조회 방지).
      //   TO-BE 는 읽기전용 토글이 없어 isEditMode 로 막지 않는다.
      if (ht.cellType === CellType.Cell) {
        const binding = g.columns[ht.col]?.binding ?? '';
        const row = g.rows[ht.row]?.dataItem as (Record<string, unknown> & {
          MEASURE?: string;
          MODEL_ID?: string;
          TO_SITE?: string;
          CRUD_TYPE?: string;
        }) | undefined;
        if (!row) return;
        // Cell Biz: 신규행 Model 셀 → Item 팝업 / Trans Mode 셀 → BOD 팝업(DMF0045 파리티). 그 외 Cell
        //   셀은 no-op(드릴은 Pack 전용). Pack 과 배타 — Cell 처리 후 즉시 종료한다.
        if (sheet === SHEETS.CELL) {
          if (String(row.CRUD_TYPE ?? '') === 'I') {
            if (binding === 'MODEL_ID') onCellModelDblClick?.(row as unknown as Row);
            else if (binding === 'TR_MODE') onBodCellDblClick?.(row as unknown as Row);
          }
          return;
        }
        if (!onDrillDetail) return;
        const measure = String(row.MEASURE ?? '');
        if (measure !== 'SHIP_REQ' && measure !== 'Ship Req') return;
        const modelId = String(row.MODEL_ID ?? '');
        const toSite = String(row.TO_SITE ?? '');
        const tag = parseDynamicColumnTag(binding);
        if (!tag) {
          // Measure 셀 + 정적 셀 → 전체 기간 드릴(값 가드 없음 — 정적 셀은 수량이 아니다).
          onDrillDetail(modelId, toSite, null);
          return;
        }
        const rawVal = row[binding] as string | number | null | undefined;
        const num = Number(String(rawVal ?? '').replace(/,/g, ''));
        if (!Number.isFinite(num) || num === 0) return; // 0/빈 값 셀 제외(동적 수량 셀만)
        onDrillDetail(modelId, toSite, tag.bucket === 'D' ? tag.yyyymmdd : null);
        return;
      }
      if (ht.cellType !== CellType.ColumnHeader) return;
      const hb = g.columns[ht.col]?.binding ?? '';
      const hk = dynKindOf(hb);
      if (hk !== 'M' && hk !== 'W') return;
      const bindings = dynBindingsRef.current;
      const idx = bindings.indexOf(hb);
      if (idx < 0) return;
      const flip = (target: string, hideOnly: boolean) => {
        const targetCol = g.getColumn(target);
        if (!targetCol) return;
        if (hideOnly && !targetCol.visible) return; // D_ 는 보이는 경우만 접기(M_ 드릴)
        drillVisRef.current.set(target, hideOnly ? false : !targetCol.visible);
      };
      for (let i = idx + 1; i < bindings.length; i++) {
        const tk = dynKindOf(bindings[i]);
        if (hk === 'M') {
          if (tk === 'M') break; // 다음 달 진입 = 종료
          if (tk === 'W') flip(bindings[i], false);
          else if (tk === 'D') flip(bindings[i], true);
        } else {
          if (tk === 'W' || tk === 'M') break; // 다음 주/달 진입 = 종료
          if (tk === 'D') flip(bindings[i], false);
        }
      }
      applyDynVisibilityRef.current?.();
    };
    g.hostElement.addEventListener('dblclick', dblclickHandler);
    return () => {
      try {
        g.hostElement?.removeEventListener('dblclick', dblclickHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [staticColumns, sheet, onDrillDetail, onCellModelDblClick, onBodCellDblClick]);

  return (
    <DataGrid<Row>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows}
      staticColumns={displayStaticColumns}
      dynamicColumns={dynamicColumns}
      sheetName={ADMIN_SHEET_NAME[sheet]}
      comboParams={comboParams}
      allowMerging={AllowMerging.All}
      gotFocus={onFocus}
      emptyCellAsZero={binding => !!parseDynamicColumnTag(binding)}
    />
  );
};
