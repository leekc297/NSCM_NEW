import { AllowMerging, CellType, DataMap, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useTabLookupQueries } from '@shared/hooks';
import { useSessionStore } from '@shared/stores';

import {
  CHANGE_REASON_COLUMN,
  CURRENT_ROW_BG,
  FCST_TYPE_COLUMN,
  LAST_SEQ_COLUMN,
  LAST_SEQ_CURRENT,
  LOOKUP_TYPE,
  MAIN_COLUMNS,
  MENU_ID,
  REQUEST_NO_COLUMN,
} from '../shipment-change-history.constants';
import type { MainRow } from '../shipment-change-history.types';
import { buildColumns } from '../utils/shipmentChangeHistoryColumns';

interface Props {
  rows: MainRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  adminColumns?: RawFlexGridColumnConfig[];
  // REQUEST_NO 이미지셀 클릭 -> 페이지가 SCM0002 요청 상세 팝업 오픈(design 03 §3-4, 값 존재 가드는 여기서 선처리).
  onRequestNoClick: (requestNo: string) => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 읽기전용 조회 그리드(design 03) — 전열 LockColumn(편집 없음), SmartColMerge 세로병합, Freeze(FIXED_FLAG 메타),
//   REQUEST_NO 드릴다운, chkCurrent 행강조. 셀콤보 3: DIVISION_ID(auto-wire Division) +
//   FCST_TYPE/CHANGE_REASON_CODE(comboParams 로 못 푸는 lookupType 2종 -> 화면이 직접 fetch 해 col.dataMap 주입,
//   design 03 §6-1 / 메모리 lookupcommon-grid-cell-combo-lookuptype-unbound).
export const ShipmentChangeHistoryGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  adminColumns,
  onRequestNoClick,
}: Props) => {
  const columns = useMemo(() => buildColumns(MAIN_COLUMNS, adminColumns), [adminColumns]);

  // DIVISION_ID 셀 콤보(Division) @토큰(@mnuId) 해소 — 인용은 getCombo funnel(nscm-patterns §3.3).
  const comboParams = useMemo(() => ({ mnuId: `'${MENU_ID}'` }), []);

  const langCd = useSessionStore(s => s.session.langCd);

  // 셀콤보 dataMap 직접 fetch(design 03 §6-1) — lookupType 이 서로 달라 comboParams 단일값으로 못 실어
  //   화면이 lookup 을 직접 조회해 컬럼별 dataMap 을 주입한다(자동 콤보 apply 이펙트가 이 2컬럼은 안 건드리도록
  //   buildColumns 가 콤보 메타를 벗겨 놓았다).
  const [fcstTypeLookup, changeReasonLookup] = useTabLookupQueries({
    filters: [{ lookupType: LOOKUP_TYPE.FCST_TYPE }, { lookupType: LOOKUP_TYPE.CHANGE_REASON }],
  });

  // FCST_TYPE = SALES_TYPE_CODE: CODE=SEGMENT1 / NAME=SEGMENT2(LookupCommon SQL 실측).
  const fcstTypeMap = useMemo(() => {
    const list = (fcstTypeLookup ?? []).map(r => ({ CODE: str(r.SEGMENT1), NAME: str(r.SEGMENT2) }));
    return list.length > 0 ? new DataMap(list, 'CODE', 'NAME') : null;
  }, [fcstTypeLookup]);

  // CHANGE_REASON_CODE: CODE=SEGMENT1 / 표시 'CODE : 명'(KO=SEGMENT2·EN=SEGMENT3, CHANGE_REASON_CODE_ALL SQL 실측).
  const changeReasonMap = useMemo(() => {
    const list = (changeReasonLookup ?? []).map(r => {
      const code = str(r.SEGMENT1);
      const name = langCd === 'KO' ? str(r.SEGMENT2) : str(r.SEGMENT3);
      return { CODE: code, NAME: `${code} : ${name}` };
    });
    return list.length > 0 ? new DataMap(list, 'CODE', 'NAME') : null;
  }, [changeReasonLookup, langCd]);

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 셀콤보 dataMap 직접 주입(design 03 §6-1) — columns/lookup 변경 시 재주입. 컬럼 재생성(columnGroups) 뒤
    //   부모 이펙트라 자동 콤보 apply 보다 나중에 실행돼 최종 반영된다. 읽기전용이라 스왑/원복 불요.
    const fcstCol = g.columns.getColumn(FCST_TYPE_COLUMN);
    if (fcstCol) fcstCol.dataMap = fcstTypeMap;
    const reasonCol = g.columns.getColumn(CHANGE_REASON_COLUMN);
    if (reasonCol) reasonCol.dataMap = changeReasonMap;

    // chkCurrent 행 강조(design 03 §3 #6/#10) — LAST_SEQ='C'(현재값) 행을 SEQ~마지막열 LightSkyBlue.
    //   체크/해제 공통으로 'C' 행을 강조(필터링은 페이지가 displayRows 로 처리). 셀 DOM 재사용 대비 항상 재설정.
    const formatItemHandler = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; cell: HTMLElement }
    ) => {
      if (e.panel !== sender.cells) return;
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      e.cell.style.backgroundColor =
        row && str(row[LAST_SEQ_COLUMN]) === LAST_SEQ_CURRENT ? CURRENT_ROW_BG : '';
    };
    g.formatItem.addHandler(formatItemHandler);

    // REQUEST_NO 이미지셀 클릭 드릴다운(design 03 §3-4, AS-IS SpdMain_CellClick) — 가드 2건:
    //   e.Column==REQUEST_NO && !IsNullOrWhiteSpace(sRequestNo). 값 있는 셀만 SCM0002 요청 상세 팝업.
    const clickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      if (binding !== REQUEST_NO_COLUMN) return;
      const row = GridUtils.getRow(g, ht.row) as Record<string, unknown> | undefined;
      const requestNo = str(row?.[REQUEST_NO_COLUMN]);
      if (!requestNo.trim()) return; // 빈 값 클릭 무동작(가드)
      onRequestNoClick(requestNo);
    };
    g.hostElement.addEventListener('click', clickHandler);

    g.invalidate();

    return () => {
      try {
        g.formatItem?.removeHandler(formatItemHandler);
        g.hostElement?.removeEventListener('click', clickHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns, fcstTypeMap, changeReasonMap]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      isReadOnly
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      comboParams={comboParams}
      // SmartColMerge 세로병합(design 03 §3 #5/#11) — CustomMergeManager 좌측누적 키(알려진 제약: 좌측 동일값
      //   전제, grid-behavior-parity §1.3). 읽기전용이라 신규행 제외 이슈 없음.
      allowMerging={AllowMerging.All}
    />
  );
};
