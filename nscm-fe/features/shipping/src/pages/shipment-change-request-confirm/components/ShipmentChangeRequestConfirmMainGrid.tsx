import {
  AllowMerging,
  DataMap,
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
  // 그리드 포커스 획득 시 — 공통 툴바 Sort(F3)/Filter(F4) 타깃을 이 그리드로(페이지가 추적).
  onGridFocus?: () => void;
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
  onGridFocus,
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
  // 엑셀 export 용 dataMap 원천(lookup 배열) ref — handleInitialized 의 updatedLayout 핸들러가 최신값을 읽는다.
  const changeTypeLookupRef = useRef(changeTypeLookup);
  changeTypeLookupRef.current = changeTypeLookup;
  const changeStatusLookupRef = useRef(changeStatusLookup);
  changeStatusLookupRef.current = changeStatusLookup;
  // mousedown 더블클릭 판정 핸들러(handleInitialized 1회 등록)가 최신 콜백을 참조하도록 ref 보관.
  const onRowDblClickRef = useRef(onRowDblClick);
  onRowDblClickRef.current = onRowDblClick;

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

    // 엑셀 다운로드용 dataMap(CHANGE_TYPE/STATUS) — 화면 표시는 위 formatItem(DOM textContent)만 하고
    //   Wijmo dataMap 이 없어, 엑셀 export 가 표시명(Name) 대신 코드값(C/Q 등)을 내보냈다(사용자 요청
    //   2026-11-06). excelDownload 는 live 컬럼의 dataMap 을 승계해 export 하므로(gridAction.ts No.60-①),
    //   두 컬럼에 dataMap 을 달면 엑셀에도 이름이 나온다. columnGroups 재빌드마다 dataMap 이 지워지므로
    //   grid 생성 시점(여기)에 updatedLayout 핸들러로 등록해 **매 layout 갱신마다 재부착**한다 — 별도
    //   useEffect 보다 확실하다(grid 가 항상 유효, lookup 은 ref 로 최신값). 콤보 메타가 벗겨진 두 컬럼은
    //   공용 DataGrid 가 건드리지 않아(buildColumns 주석) 재부착이 덮이지 않는다.
    const attachDataMaps = () => {
      const ct = changeTypeLookupRef.current;
      const ctCol = grid.getColumn(MASTER_USER_COLUMNS.CHANGE_TYPE);
      if (ctCol) ctCol.dataMap = ct?.length ? new DataMap(ct, 'CODE', 'NAME') : null;
      const st = changeStatusLookupRef.current;
      const stCol = grid.getColumn(MASTER_USER_COLUMNS.STATUS);
      if (stCol) stCol.dataMap = st?.length ? new DataMap(st, 'CODE', 'NAME') : null;
    };
    grid.updatedLayout.addHandler(attachDataMaps);
    attachDataMaps();

    // 마스터행 더블클릭 -> 디테일 로드. AS-IS SpdMain_CellDoubleClick 은 e.Row(컬럼 무관)로 고정열 포함
    //   전열에서 디테일을 연다. TO-BE 는 고정(frozen) 컬럼(Div~Status)에서 네이티브 dblclick 이 아예
    //   발생하지 않았다 — Wijmo 가 셀 선택 시 .wj-frozen-clone 패널의 고정 셀 DOM 을 다시 그려, 더블클릭
    //   두 클릭의 타깃 노드가 달라져 브라우저가 dblclick 을 합성하지 않기 때문(사용자 확인 2026-11-09:
    //   고정열 dblclick 미발생, 비고정열만 발생). 그래서 재렌더와 무관하게 매번 발생하는 capture 단계
    //   mousedown 으로 직접 더블클릭을 판정한다 — 좌표 기반 hitTest.row(Y축)는 고정/비고정 공통으로 행을
    //   집으므로 전열에서 동작한다.
    let lastRow = -1;
    let lastTime = 0;
    grid.hostElement.addEventListener(
      'mousedown',
      (e: MouseEvent) => {
        if (e.button !== 0) return; // 좌클릭만
        const target = e.target as HTMLElement | null;
        // .wj-cells 는 본 셀 패널 + 고정 클론(.wj-cells.wj-frozen-clone) 둘 다 매칭, 헤더(.wj-header)는 제외.
        if (!target?.closest('.wj-cells')) return;
        const row = grid.hitTest(e).row;
        if (row < 0) return;
        if (row === lastRow && e.timeStamp - lastTime < 500) {
          lastRow = -1; // 트리플클릭 중복발사 방지(다음 클릭부터 새로 카운트)
          const data = GridUtils.getRow(grid, row) as Record<string, unknown> | undefined;
          if (data) onRowDblClickRef.current(data);
        } else {
          lastRow = row;
          lastTime = e.timeStamp;
        }
      },
      true
    );
  }, []);

  // lookup 이 늦게 도착하면 셀을 다시 그린다 — formatItem(표시명) 재실행 + grid.invalidate() 가
  //   updatedLayout 을 유발해 handleInitialized 의 attachDataMaps(엑셀용 dataMap)도 최신 lookup 으로 재부착된다.
  useEffect(() => {
    gridRef.current?.invalidate();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [changeTypeMap, changeStatusMap, columns]);

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
      gotFocus={onGridFocus}
    />
  );
};
