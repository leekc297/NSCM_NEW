import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';

import {
  CELL_DIVISION_COLUMN,
  CHANGE_REASON_COLUMN,
  COMBO,
  FCST_TYPE_COLUMN,
  type ColumnMeta,
} from '../shipment-change-history.constants';

// lookupType 직접주입 대상(design 03 §6-1) — 공용 DataGrid 의 자동 콤보 apply 이펙트가 col.dataMap 을 null 로
//   덮어쓰므로(comboParams 에 컬럼별 @lookupType 을 못 실어 0행 -> null), 이 2컬럼은 auto-wire 를 벗겨(plain 컬럼)
//   Grid 가 useTabLookupQueries 결과로 col.dataMap 을 직접 주입한다. DIVISION_ID(CODE=NAME)는 auto-wire 유지.
const LOOKUP_INJECTED_COLUMNS = new Set<string>([FCST_TYPE_COLUMN, CHANGE_REASON_COLUMN]);

// admin/fallback 공통 후처리:
//   - lookupType 주입 컬럼(FCST_TYPE/CHANGE_REASON_CODE)의 셀콤보 메타 제거(cellCtrlObjTpCd/cellCboDataTp/attribute1)
//     -> 공용 DataGrid 가 콤보로 인식하지 않아 apply 이펙트가 건드리지 않는다(Grid 가 dataMap 직접 주입).
//   - DIVISION_ID 셀 콤보는 admin 메타에 있으면 그대로, 없으면(fallback) Division CODE=NAME 콤보로 배선.
const augmentScreenCombos = (cols: RawFlexGridColumnConfig[]): RawFlexGridColumnConfig[] =>
  cols.map(c => {
    if (LOOKUP_INJECTED_COLUMNS.has(c.colNm)) {
      const { cellCtrlObjTpCd: _ctrl, cellCboDataTp: _combo, attribute1: _attr1, ...rest } = c;
      return rest;
    }
    if (c.colNm === CELL_DIVISION_COLUMN && !c.cellCboDataTp) {
      return { ...c, cellCtrlObjTpCd: CELL_CONTROL_TYPE.COMBO, cellCboDataTp: COMBO.CELL_DIVISION };
    }
    return c;
  });

const CELL_TYPE_MAP: Record<NonNullable<ColumnMeta['cell']>, CELL_CONTROL_TYPE> = {
  combo: CELL_CONTROL_TYPE.COMBO,
  date: CELL_CONTROL_TYPE.DATE,
  datetime: CELL_CONTROL_TYPE.DATE_TIME,
  number: CELL_CONTROL_TYPE.NUMBER,
};

export const buildColumns = (
  meta: ColumnMeta[],
  adminCols?: RawFlexGridColumnConfig[]
): RawFlexGridColumnConfig[] => {
  if (adminCols && adminCols.length > 0) {
    // 단일 헤더 화면 — 클래스 라벨 제거해 ONE_DEPTH 유지(자매 shipment-master-electrode 동일, design 03 §7 hook93 N/A).
    const stripped = adminCols.map(c => ({ ...c, sClsLblNm: undefined, lClsLblNm: undefined }));
    return augmentScreenCombos(stripped);
  }
  const fallback = meta.map<RawFlexGridColumnConfig>(c => {
    const col: RawFlexGridColumnConfig = {
      colNm: c.key,
      colLblNm: c.header,
      horzAlgnCd: c.align,
      colWth: c.width,
      visible: c.visible !== false,
      display: c.visible !== false,
      // 전열 읽기전용(design 03 §3 #4 LockColumn 전열). INPUT_TP_CD 전건 'S'.
      inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
    };
    // DIVISION_ID 셀 콤보(CODE=NAME) — Division 콤보. FCST_TYPE/CHANGE_REASON_CODE 는 여기서 콤보로 두지 않는다
    //   (augmentScreenCombos 가 어차피 벗겨 Grid dataMap 주입). date/number 셀유형만 반영.
    if (c.cell === 'combo' && c.key === CELL_DIVISION_COLUMN) {
      col.cellCtrlObjTpCd = CELL_CONTROL_TYPE.COMBO;
      col.cellCboDataTp = COMBO.CELL_DIVISION;
    } else if (c.cell && c.cell !== 'combo') {
      col.cellCtrlObjTpCd = CELL_TYPE_MAP[c.cell];
    }
    return col;
  });
  return augmentScreenCombos(fallback);
};
