import {
  AllowMerging,
  CellType,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, type MutableRefObject } from 'react';

import { CELL_CONTROL_TYPE } from '@foundation/constants';
import { GridUtils, paintNegativeText, toGridNumber } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import {
  AGING_COLUMNS,
  CELL_CF_YELLOW,
  CELL_CF_YELLOW_COLUMNS,
  COL,
  DETAIL_COLUMNS,
  EXCEL_SHOW_COLUMNS,
  SEARCH_MODE,
  type SearchMode,
} from '../ending-inventory.constants';
import type { EndingInventoryRow } from '../ending-inventory.types';
import { useEndingInventoryStore } from '../useEndingInventoryStore';

interface Props {
  gridRef: MutableRefObject<FlexGrid<EndingInventoryRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: EndingInventoryRow[];
  mode: SearchMode;
  divisionId: string;
  devaluationAge: boolean;
  isHeaderViewDetail: boolean;
  // QUANTITY 헤더 더블클릭 → 상세 3컬럼 토글(AS-IS SpdMain_CellDoubleClick, cs:456~468).
  onToggleDetail: () => void;
}

// cboDivision 값에 '40' 포함(또는 All) 시 CELL_TYPE_GR 표시 — AS-IS SetHeaderDivision(cs:578~596).
const excelShowSet: ReadonlySet<string> = new Set(EXCEL_SHOW_COLUMNS);

const hasDivision40 =(divisionId: string): boolean =>
  divisionId === 'ALL' || divisionId.split(',').includes('40');

export const EndingInventoryGrid = ({
  gridRef,
  gridFilterRef,
  data,
  mode,
  divisionId,
  devaluationAge,
  isHeaderViewDetail,
  onToggleDetail,
}: Props) => {
  const staticColumns = useEndingInventoryStore(state => state.staticColumns);

  const isDaily = mode === SEARCH_MODE.DAILY;
  const showCellTypeGr = hasDivision40(divisionId);

  // 동적 컬럼 가시성 — 공용 DataGrid 가 updatedLayout 마다 columnGroups(메타 visible)를 재적용하므로
  //   그 뒤에 화면 규칙을 다시 씌운다(bod/forecast-price 표준 처방). 명시 규칙 컬럼만 건드리고,
  //   나머지는 admin 메타 visible 을 그대로 둔다.
  //     - 재고월령 39컬럼: Devaluation Age 체크 시만 표시(chkDetail 토글, cs:506 ChkDetail_CheckedChanged)
  //     - 상세 3컬럼      : isHeaderViewDetail (초기 숨김, QUANTITY 헤더 더블클릭 토글)
  //     - YYYYMMDD        : DAILY 모드만 표시(SetHeaderDaily, cs:563~576)
  //     - VALUATION_TYPE  : MONTH 모드만 표시(일별 숨김) — AS-IS RdoMonth.Checked 분기(cs:702~711, E20250214-001628)
  //     - CELL_TYPE_GR    : div∋'40'/All 만 표시(SetHeaderDivision, cs:578~596)
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const agingSet = new Set(AGING_COLUMNS);
    const detailSet = new Set(DETAIL_COLUMNS);
    const apply = () => {
      let changed = false;
      for (const col of g.columns) {
        const b = col.binding ?? '';
        let want: boolean | undefined;
        if (agingSet.has(b)) want = devaluationAge;
        else if (detailSet.has(b)) want = isHeaderViewDetail;
        else if (b === COL.YYYYMMDD) want = isDaily;
        else if (b === COL.VALUATION_TYPE) want = !isDaily;
        else if (b === COL.CELL_TYPE_GR) want = showCellTypeGr;
        if (want !== undefined && col.visible !== want) {
          col.visible = want;
          changed = true;
        }
      }
      if (changed) g.invalidate(true);
    };
    g.updatedLayout.addHandler(apply);
    apply();
    return () => {
      g.updatedLayout?.removeHandler(apply);
    };
  }, [gridRef, staticColumns, data, isHeaderViewDetail, isDaily, showCellTypeGr, devaluationAge]);

  // 정수 표시 — 메타 FPNumber + DATA_SCALE_NUMBER NULL/0 컬럼(Quantity·Amount(KRW)·Amount·재고월령·상세 수량)은
  //   AS-IS SpreadInfo(cs:1434~1439·1497~1500)가 decimalPlaces=0·천단위로 표시한다. 공용 getFormat 은
  //   NULL/0 이면 포맷을 안 걸어 wijmo 기본(소수 2자리)으로 보이므로 화면에서 'n0' 를 건다.
  //   updatedLayout 마다 재적용(columnGroups 재대입 시 포맷 초기화).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const integerBindings = new Set(
      staticColumns
        .filter(c => c.cellCtrlObjTpCd === CELL_CONTROL_TYPE.NUMBER && !c.scale)
        .map(c => c.colNm)
    );
    const apply = () => {
      let changed = false;
      for (const col of g.columns) {
        if (col.binding && integerBindings.has(col.binding) && col.format !== 'n0') {
          col.format = 'n0';
          changed = true;
        }
      }
      if (changed) g.invalidate(true);
    };
    g.updatedLayout.addHandler(apply);
    apply();
    return () => {
      g.updatedLayout?.removeHandler(apply);
    };
  }, [gridRef, staticColumns, data]);

  // 엑셀 숫자 서식 — excelDownload 는 컬럼 format 을 넘기지 않으므로 _excelFormat 으로 준다.
  //   환산계수는 SP 가 문자('1.000000')로 주므로 공용 export 가 _excelFormat 컬럼의 숫자 문자열을 숫자로 바꾼다.
  //   그 밖의 FPNumber 는 화면과 같은 정수 천단위(NULL/0) 또는 메타 자릿수.
  //   CELL_CF 3컬럼은 메타 DEFAULT_FLAG=N 이라 display=false 로 내려와 그리드에 아예 생성되지 않는다 —
  //   엑셀 시점에만 켤 수 있도록 display 를 켜 둔다(메타 visible=N 이라 화면에는 숨김 그대로).
  //   주의: 메타 소분류 '검증 컬럼'(SMALL_CLASS_LABEL_NAME)이 남아 있으면 공용 depth 판정이 전체 헤더를
  //   2단으로 바꾼다 — 분류 라벨을 비워 1단 헤더를 유지한다.
  //   엑셀 자릿수는 짝이 되는 `<컬럼>_XLS` 메타 DATA_SCALE_NUMBER 를 따른다 — AS-IS 엑셀은 화면 컬럼 대신
  //   _XLS 컬럼을 내보내므로(cs:925~953) Quantity·Amount(KRW)·Unit Price(KRW)·Amount·Unit Price 5자리,
  //   환산계수 5자리, 환산수량 7자리가 된다. _XLS 짝이 없는 FPNumber 는 자기 메타 자릿수.
  const gridColumns = useMemo(() => {
    const xlsScale = new Map(
      staticColumns.filter(c => c.colNm.endsWith('_XLS')).map(c => [c.colNm, c.scale])
    );
    const toFormat = (scale: unknown) => {
      const n = Number(scale) || 0;
      return n > 0 ? `#,##0.${'0'.repeat(n)}` : '#,##0';
    };
    return staticColumns.map(c => {
      if (excelShowSet.has(c.colNm))
        return { ...c, display: true, visible: false, sClsLblNm: '', lClsLblNm: '' };
      const xlsKey = `${c.colNm}_XLS`;
      if (xlsScale.has(xlsKey)) return { ...c, _excelFormat: toFormat(xlsScale.get(xlsKey)) };
      if (c.cellCtrlObjTpCd !== CELL_CONTROL_TYPE.NUMBER) return c;
      return { ...c, _excelFormat: toFormat(c.scale) };
    });
  }, [staticColumns]);

  // 세로 병합(allowMerging) — AS-IS 관측(사용자 2026-10-21):
  //   월마감 모드 = YY.MM(YYYYMM) 만.
  //   일별 모드   = YY.MM(YYYYMM)·YY.MM.DD(YYYYMMDD)·DIV(DIVISION_ID)·Plant Site(PLANT_NAME)·
  //                 Plant(PLANT_ID)·Material(ITEM_ID)·Description(ITEM_DESCRIPTION)·Unit(ITEM_UOM) 까지.
  //   CustomMergeManager 가 좌측 누적키(col 0..n 동일값 연쇄) + 빈 셀 미병합이라, 선두 식별 컬럼이
  //   위→아래 계층으로 묶이고 데이터 없는(빈) 셀은 병합되지 않는다("데이터 없으면 병합안함" 충족).
  //   프레임워크 정책은 전 컬럼 MergePolicy.Restricted(SpreadInfo.cs:1295)지만 관측 기준 컬럼으로 고정.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const mergeBindings: ReadonlySet<string> = isDaily
      ? new Set([
          COL.YYYYMM,
          COL.YYYYMMDD,
          COL.DIVISION_ID,
          COL.PLANT_NAME,
          COL.PLANT_ID,
          COL.ITEM_ID,
          COL.ITEM_DESCRIPTION,
          COL.ITEM_UOM,
        ])
      : new Set([COL.YYYYMM]);
    const apply = () => {
      for (const col of g.columns) {
        if (!col.binding) continue;
        col.allowMerging = mergeBindings.has(col.binding);
      }
    };
    g.updatedLayout.addHandler(apply);
    apply();
    return () => {
      g.updatedLayout?.removeHandler(apply);
    };
  }, [gridRef, staticColumns, data, isDaily]);

  // 조건부 셀 서식 — DataGrid 는 formatItem prop 을 노출하지 않아 셀 DOM 에 직접 style 을 세팅한다(bod 선례).
  //   셀 DOM 재사용 대비 미해당 시 반드시 '' 로 해제한다.
  //   1) 배경색 : USE_CELL_CF_BOM='Y' 행의 CELL_CONVER_FACTOR/QUANTITY 셀 Yellow(cs:256/257).
  //   2) 글자색 : 음수 = 빨강 — AS-IS NumberCellType.NegativeRed=true(전 수치 셀 공통) 그리드 공통 규약.
  //              공용 paintNegativeText(해제·!important 처리 포함)로 전 데이터 셀에 적용.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;
    const yellowSet = new Set(CELL_CF_YELLOW_COLUMNS);
    const handler = (s: FlexGrid<EndingInventoryRow>, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = s.columns[e.col]?.binding;
      if (!binding) return;
      const dataItem = GridUtils.getRow(s, e.row) as WijmoRowItem | undefined;
      if (yellowSet.has(binding)) {
        const useBom = String(dataItem?.[COL.USE_CELL_CF_BOM] ?? '') === 'Y';
        e.cell.style.backgroundColor = useBom ? CELL_CF_YELLOW : '';
      }
      paintNegativeText(e.cell, toGridNumber(dataItem?.[binding]));
    };
    g.formatItem.addHandler(handler);
    g.invalidate();
    return () => g.formatItem.removeHandler(handler);
  }, [gridRef, data]);

  // QUANTITY 헤더 더블클릭만 상세 토글(다른 헤더·데이터셀 무반응 — cs:460~465 헤더 가드 + QUANTITY 한정).
  const handleDblClick = (mouseEvent: MouseEvent) => {
    const g = gridRef.current;
    if (!g) return;
    const ht = g.hitTest(mouseEvent);
    if (ht.cellType !== CellType.ColumnHeader) return;
    if (g.columns[ht.col]?.binding !== COL.QUANTITY) return;
    onToggleDetail();
  };

  return (
    <DataGrid<EndingInventoryRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={gridColumns}
      // 전 컬럼 읽기전용 Report — 편집셀 없음(LockColumn, cs:356). staticColumns INPUT_TP_CD 전건 'S'.
      // SmartColMerge(cs:362) → Cells 로 켜 CustomMergeManager 가 선두 누적 동일값을 세로 병합.
      allowMerging={AllowMerging.Cells}
      dblClick={handleDblClick}
      isReadOnly
    />
  );
};
