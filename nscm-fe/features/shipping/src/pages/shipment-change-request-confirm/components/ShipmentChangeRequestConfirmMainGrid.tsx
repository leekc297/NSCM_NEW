import {
  AllowMerging,
  CellType,
  type FlexGrid as FlexGridType,
  type FormatItemEventArgs,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useCallback, useEffect, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabLookupQueries } from '@shared/hooks';

import { LOOKUP, MASTER_USER_COLUMNS, MENU_ID } from '../shipment-change-request-confirm.constants';
import type { MainRow } from '../shipment-change-request-confirm.types';
import { buildColumns } from '../utils/shipmentChangeRequestConfirmColumns';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

interface Props {
  rows: MainRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  division: string;
  adminColumns?: RawFlexGridColumnConfig[];
  // 마스터행 더블클릭 -> 디테일/위임자 로드 + 액션버튼 Visibility 판정(design 01 §2 A8/B1, 진입가드 Rows>0).
  onRowDblClick: (row: Record<string, unknown>) => void;
}

// AS-IS spdMain "Shipment Change Request Confirm" (22열). 전열 LockColumn = 조회전용(편집 컬럼 0, design 03 §1.1).
//   셀콤보 4종(CHANGE_TYPE/SHIPMENT_STATUS/CHANGE_REASON_CODE/*_DEPT)은 표시전용 code->label (admin 메타 구동).
export const ShipmentChangeRequestConfirmMainGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  division,
  adminColumns,
  onRowDblClick,
}: Props) => {
  const columns = useMemo(() => buildColumns(adminColumns, false), [adminColumns]);
  const comboParams = useMemo(
    () => ({ mnuId: `'${MENU_ID}'`, divisionId: `'${division}'` }),
    [division]
  );

  // 셀콤보 dataMap 직접 fetch — CHANGE_TYPE/SHIPMENT_STATUS 는 'LookupCommon'(@lookupType 필수)을 쓰는데
  //   공용 DataGrid 가 comboParams 단일값으로 컬럼별 @lookupType 을 못 실어 code 가 그대로 노출된다.
  //   화면이 lookup 을 직접 조회해 표시를 확정한다(buildColumns 가 두 컬럼의 콤보 메타를 벗겨 둔다).
  const [changeTypeLookup, changeStatusLookup] = useTabLookupQueries({
    filters: [{ lookupType: LOOKUP.CHANGE_REQ_TYPE }, { lookupType: LOOKUP.CHANGE_REQ_STATUS }],
  });

  // code -> name 평면 맵. lookup 반환 키는 CODE/NAME(폼 콤보와 동일 계약).
  //   CHANGE_REQ_TYPE: P/C/N/A -> Plan/Confirm/New/Adjustment / CHANGE_REQ_STATUS: D/Q/A/P/R/S/O/E -> Drafting/Requested/...
  const changeTypeMap = useMemo(() => {
    const m: Record<string, string> = {};
    (changeTypeLookup ?? []).forEach(r => {
      m[str(r.CODE)] = str(r.NAME) || str(r.CODE);
    });
    return m;
  }, [changeTypeLookup]);

  const changeStatusMap = useMemo(() => {
    const m: Record<string, string> = {};
    (changeStatusLookup ?? []).forEach(r => {
      m[str(r.CODE)] = str(r.NAME) || str(r.CODE);
    });
    return m;
  }, [changeStatusLookup]);

  // 표시 매핑은 formatItem 으로 '매 셀 페인트마다' 직접 쓴다 — Wijmo dataMap 은 columnGroups 재생성·캐시된
  //   lookup 타이밍에 지워질 수 있어 확정적 경로로 둔다. 최신 맵은 ref 로 참조(핸들러는 1회 등록).
  //   DataGrid 가 자기 formatItem 을 먼저 등록하므로 initialized(셋업 끝 호출)에서 등록한 이 핸들러가 '마지막'에
  //   돌아 textContent 를 최종 확정한다.
  const changeTypeMapRef = useRef(changeTypeMap);
  changeTypeMapRef.current = changeTypeMap;
  const changeStatusMapRef = useRef(changeStatusMap);
  changeStatusMapRef.current = changeStatusMap;

  const handleInitialized = useCallback((grid: FlexGridType) => {
    grid.formatItem.addHandler((s: FlexGridType, e: FormatItemEventArgs) => {
      if (e.panel !== s.cells) return;
      const binding = s.columns[e.col]?.binding;
      const map =
        binding === MASTER_USER_COLUMNS.CHANGE_TYPE
          ? changeTypeMapRef.current
          : binding === MASTER_USER_COLUMNS.STATUS
            ? changeStatusMapRef.current
            : null;
      if (!map) return;
      const code = str(s.getCellData(e.row, e.col, false));
      if (!code) return;
      e.cell.textContent = map[code] ?? code;
    });
  }, []);

  // lookup 이 늦게 도착하면 셀을 다시 그려(formatItem 재실행) 이름으로 교체한다.
  useEffect(() => {
    gridRef.current?.invalidate();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [changeTypeMap, changeStatusMap, columns]);

  // 마스터행 더블클릭 -> 디테일 로드(진입가드: 데이터 셀 + 행 존재). AS-IS IsLock==true 는 조회전용 상시 성립.
  const handleDblClick = (e: MouseEvent) => {
    const g = gridRef.current;
    if (!g) return;
    const ht = g.hitTest(e);
    if (ht.cellType !== CellType.Cell) return;
    const row = GridUtils.getRow(g, ht.row) as Record<string, unknown> | undefined;
    if (!row) return;
    onRowDblClick(row);
  };

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      isReadOnly={true}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      comboParams={comboParams}
      // 그리드 생성 완료 시 code->name formatItem 핸들러를 등록(DataGrid 핸들러 뒤 = 마지막에 실행).
      initialized={handleInitialized}
      /* 자매 SSP0003 메인 그리드와 동일하게 맞춘다(사용자 지시 2026-10-07 "기능이 동일하게").
         이 시트는 단일 헤더(main 메타 SMALL_CLASS_LABEL_NAME 0행 실측)라 헤더 병합 대상이 없어
         **외관상 차이는 없고**, 바뀌는 것은 데이터 셀 세로병합 유무뿐이다.
         트레이드오프: AS-IS `siMain.SmartColMerge()`(cs:640·1276 live) 의 데이터 셀 병합은 포기한다 —
         자매 화면과의 동작 일치를 우선한 사용자 결정이다. 되살리려면 `AllowMerging.Cells` 로 되돌린다. */
      allowMerging={AllowMerging.None}
      dblClick={handleDblClick}
    />
  );
};
