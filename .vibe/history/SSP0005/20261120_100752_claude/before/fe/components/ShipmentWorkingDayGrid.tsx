import { toggleClass } from '@mescius/wijmo';
import {
  AllowMerging,
  type CellRangeEventArgs,
  CellType,
  type FlexGrid,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import {
  DAY_BINDING_RE,
  DAY_CODE,
  HEADER_TOTAL_HEIGHT,
  MENU_ID,
  WEEKEND_HEADER_COLOR,
} from '../shipment-working-day.constants';
import type { DayColumn, ShipmentWorkingDayRow } from '../shipment-working-day.types';
import { buildDayColumnTree, toDayCodeMap } from '../utils/shipmentWorkingDayColumns';

interface Props {
  rows: ShipmentWorkingDayRow[];
  gridRef: MutableRefObject<FlexGrid<ShipmentWorkingDayRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  // 저장 payload 의 단일 진실원 — 페이지가 handleSave 에서 변경맵을 읽는다.
  editTrackerRef: MutableRefObject<EditTracker<ShipmentWorkingDayRow> | undefined>;
  // admin SCM_MST_SHEET_COLUMNS 응답 그대로. 리터럴 하드코딩 0 — 폭/정렬/FIXED/편집 전부 메타 위임.
  staticColumns: RawFlexGridColumnConfig[];
  // 3SPAN 응답에서 추린 동적 일자 컬럼(월/주차/일 + DAY_CODE).
  dayColumns: DayColumn[];
  // EDIT 권한 ∧ 컬럼 메타 신뢰 가능. AS-IS 편집모드 토글은 미이식이라 이 한 축만 본다.
  canEdit: boolean;
}

// AS-IS spdMain 시트 "Shipment Working Day" — 정적 2열(메타) + 동적 D_YYYYMMDD N열.
//   편집 가능 셀 <=> /^D_\d{8}$/.test(binding) AND canEdit (03 §3-a).
//   정적 2열은 메타 INPUT_TP_CD='S' 가 이미 잠그므로 화면에 컬럼명 배열을 하드코딩하지 않는다
//   (AS-IS LockColumn(COMPANY, DIVISION) 의 등가는 메타다 — hook #130 전형 함정).
export const ShipmentWorkingDayGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  staticColumns,
  dayColumns,
  canEdit,
}: Props) => {
  // 핸들러는 등록 시점 클로저라 prop 을 직접 읽으면 stale 된다 — 렌더마다 ref 동기화.
  const canEditRef = useRef(canEdit);
  canEditRef.current = canEdit;

  const dynamicColumns = useMemo(() => buildDayColumnTree(dayColumns), [dayColumns]);
  // 주말 헤더 색 판정 — binding -> DAY_CODE. 라벨 파싱·dayjs 요일 재계산 금지(03 §2-c).
  const dayCodeByBinding = useMemo(() => toDayCodeMap(dayColumns), [dayColumns]);

  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    const formatHandler = (
      _sender: FlexGrid<ShipmentWorkingDayRow>,
      event: FormatItemEventArgs
    ) => {
      const binding = event.panel.columns[event.col]?.binding ?? '';

      if (event.panel.cellType === CellType.ColumnHeader) {
        // AS-IS .cs:265-268 — `ColumnHeader.Cells[2, col].ForeColor` 로 **3단(일) 행만** 칠한다.
        //   tier 를 구분하지 않으면 월/주차 그룹 헤더까지 물든다 — 공용 헤더 패널은 모든 tier 행에서
        //   leaf binding 을 돌려주므로, 그룹 앵커 컬럼이 토·일이면 그 라벨 블록 전체가 빨강/파랑이 된다.
        //   깊이는 패널에서 파생한다(리터럴 3 금지 — depth 는 3SPAN 응답이 결정한다).
        const leafRow = event.panel.rows.length - 1;
        if (event.row !== leafRow) return;
        const code = dayCodeByBinding.get(binding);
        if (code === DAY_CODE.SAT) event.cell.style.color = WEEKEND_HEADER_COLOR.SAT;
        else if (code === DAY_CODE.SUN) event.cell.style.color = WEEKEND_HEADER_COLOR.SUN;
        return;
      }
      if (event.panel.cellType !== CellType.Cell || !binding) return;

      // 편집 가능 셀만 강조한다. 정적 2열은 메타가 잠그므로 여기서 다시 판정하지 않는다.
      if (DAY_BINDING_RE.test(binding)) {
        toggleClass(event.cell, 'wj-cell-editable', canEditRef.current);
        toggleClass(event.cell, 'wj-cell-non-editable', !canEditRef.current);
      }
    };
    grid.formatItem.addHandler(formatHandler);

    // 동적 컬럼은 메타에 없어 공용 편집 판정이 닿지 않는다 — beginningEdit 이 마지막 게이트다(hook #70).
    const beginningEditHandler = (
      sender: FlexGrid<ShipmentWorkingDayRow>,
      event: CellRangeEventArgs & { cancel: boolean }
    ) => {
      const binding = sender.columns[event.col]?.binding ?? '';
      if (!canEditRef.current || !DAY_BINDING_RE.test(binding)) event.cancel = true;
    };
    grid.beginningEdit.addHandler(beginningEditHandler);

    // 붙여넣기는 beginningEdit 을 발화하지 않는다 — 공용 DataGrid 는 pastingCell 에서
    //   GridUtils.isEditableCell(= column._inputEditType 단독 판정)만 본다(dataGridUtils.ts:385).
    //   동적 D_ 컬럼은 _inputEditType 을 OPTIONAL 로 무조건 선언하므로, 이 핸들러가 없으면
    //   EDIT 권한이 없는(canEdit=false) 사용자도 Ctrl+V 로 셀을 채워 EditTracker 에 변경이 쌓인다.
    //   AS-IS 는 조회 직후 전열을 잠갔으므로(cs:420) 붙여넣기도 막혔다 — 권한 축으로 등가를 만든다.
    //   memory `datagrid-paste-editability-pastingcell-gap`.
    const pastingCellHandler = (
      sender: FlexGrid<ShipmentWorkingDayRow>,
      event: CellRangeEventArgs & { cancel: boolean }
    ) => {
      const binding = sender.columns[event.col]?.binding ?? '';
      if (!canEditRef.current || !DAY_BINDING_RE.test(binding)) event.cancel = true;
    };
    grid.pastingCell.addHandler(pastingCellHandler);

    return () => {
      try {
        grid.formatItem?.removeHandler(formatHandler);
      } catch {
        /* unmount race */
      }
      try {
        grid.beginningEdit?.removeHandler(beginningEditHandler);
      } catch {
        /* unmount race */
      }
      try {
        grid.pastingCell?.removeHandler(pastingCellHandler);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, dayCodeByBinding, staticColumns]);

  // 다단 헤더 총높이 48px 정규화 — hook #93 P-B (자매 cust-fcst-waterfall·DemandPlanWaterfall 동형).
  //   이 화면의 정적 2열은 메타 실측이 colLblNm=sClsLblNm=lClsLblNm 로 셋 다 같아
  //   foundation getColumnDepth 가 **1단**으로 판정하고 명시 height:48 을 박는다(columnMapping.ts).
  //   동적 일자열은 height 미지정(3단)이라, Wijmo 의 "헤더 행 높이 = 그 행 컬럼 height 의 max"
  //   규칙 때문에 첫 행만 48 로 벌어져 총 48+16+16=80px 이 된다(hook #93 §6.4 전형).
  //   공용 DataGrid 의 headerRowHeight prop 은 rows.defaultSize 만 세팅해 이 명시 48 잔여를
  //   덮지 못하므로(hook #93 §3 말미에 명시) 그 prop 을 쓰지 않고 각 rows[i].height 까지 강제한다.
  //   금지: 높이 조작을 이 effect 밖(동적 컬럼 정의·다른 effect·CSS)으로 퍼뜨리지 않는다 — 값/타이밍
  //   경쟁으로 높이가 무효화되고 merge·formatItem 핸들러까지 풀린 회귀가 있다(hook #93 §6.6).
  //   위 merge/formatItem effect **뒤에** 둔다(§3 원칙 5 — 핸들러 세팅 후 높이 정규화).
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    const applyHeaderHeight = () => {
      const headerRows = grid.columnHeaders?.rows;
      if (!headerRows || headerRows.length === 0) return;
      // tier 수를 dayColumns 로 추정하지 않고 실제 렌더된 행 수로 나눈다(§3 원칙 2) —
      //   조회 전 1단 -> 3SPAN 수신 후 3단으로 전이하는 동안에도 총합 48px 이 유지된다.
      const targetHeight = HEADER_TOTAL_HEIGHT / headerRows.length;
      let changed = false;
      for (let i = 0; i < headerRows.length; i += 1) {
        if (
          Math.round(headerRows[i].height ?? headerRows.defaultSize) !== Math.round(targetHeight)
        ) {
          headerRows[i].height = targetHeight;
          changed = true;
        }
      }
      if (Math.round(headerRows.defaultSize) !== Math.round(targetHeight)) {
        headerRows.defaultSize = targetHeight;
        changed = true;
      }
      // changed 가드 필수 — updatedLayout 은 매 레이아웃마다 발화하므로 무조건 invalidate 하면
      //   invalidate -> updatedLayout -> invalidate 로 되돌아오는 무한 루프가 된다.
      if (changed) grid.invalidate(true);
    };

    applyHeaderHeight();
    // wrapper 의 비동기 columnGroups 재구성이 헤더를 다시 만들 때마다 재적용한다 — rAF 1회는
    //   조회(3SPAN 수신)로 헤더가 재빌드되는 순간을 놓친다.
    grid.updatedLayout.addHandler(applyHeaderHeight);
    return () => {
      try {
        grid.updatedLayout?.removeHandler(applyHeaderHeight);
      } catch {
        /* unmount race */
      }
    };
  }, [gridRef, staticColumns, dynamicColumns]);

  // canEdit 이 바뀌면 잠금 표기를 다시 칠한다 — 핸들러는 ref 로 최신값을 읽지만 재도색 트리거가 필요하다.
  useEffect(() => {
    gridRef.current?.invalidate(true);
  }, [canEdit, gridRef]);

  return (
    <DataGrid<ShipmentWorkingDayRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      staticColumns={staticColumns}
      dynamicColumns={dynamicColumns}
      itemsSource={rows}
      // 자동 콤보 셀(COMPANY_ID -> SQL_ID 'Company') 의 @토큰 해소. 인용은 getCombo funnel 이 처리한다.
      comboParams={{ mnuId: `'${MENU_ID}'` }}
      // AS-IS SmartColMerge(.cs:201·322·424) 등가 — 공용 CustomMergeManager 가 헤더 3단 span 과
      //   정적 2열 세로 병합을 함께 처리한다. 화면 전용 MergeManager 는 nested 헤더 span 을 깬다.
      allowMerging={AllowMerging.All}
      // headerRowHeight prop 은 쓰지 않는다 — rows.defaultSize 만 세팅해서 정적 1단 컬럼의
      //   명시 height:48 잔여를 못 덮는다(hook #93 §3). 총높이 48px 는 위 정규화 effect 가 책임진다.
      autoGenerateColumns={false}
    />
  );
};
