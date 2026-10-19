import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';

import { FREEZE_ANCHOR, type ColumnMeta } from '../line-master.constants';

// ColumnMeta.inputTp(폴백) -> DataGrid inputTpCd. 값 집합은 CELL_INPUT_EDIT_TYPE 와 동일.
const INPUT_TP_MAP: Record<ColumnMeta['inputTp'], CELL_INPUT_EDIT_TYPE> = {
  S: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
  O: CELL_INPUT_EDIT_TYPE.OPTIONAL,
  M: CELL_INPUT_EDIT_TYPE.MANDATORY,
  IM: CELL_INPUT_EDIT_TYPE.MANDATORY_INSERT_ONLY,
  IO: CELL_INPUT_EDIT_TYPE.OPTIONAL_INSERT_ONLY,
};

// constants 의 ColumnMeta -> DataGrid staticColumns(RawFlexGridColumnConfig).
//   admin(SCM_MST_SHEET_COLUMNS) 등록본이 있으면 그걸 authoritative 로 쓰고, 없으면(미등록)
//   이 constants 를 fallback 으로 쓴다(sales-future-price MAIN_COLUMNS 패턴).
export const buildColumns = (
  meta: ColumnMeta[],
  adminCols?: RawFlexGridColumnConfig[]
): RawFlexGridColumnConfig[] => {
  if (adminCols && adminCols.length > 0) return adminCols;
  return meta
    .filter(c => c.visible !== false)
    .map<RawFlexGridColumnConfig>(c => ({
      colNm: c.key,
      colLblNm: c.header,
      horzAlgnCd: c.align ?? 'C',
      colWth: c.width ?? 100,
      visible: true,
      display: true,
      inputTpCd: INPUT_TP_MAP[c.inputTp],
      // 콤보 셀만 cellCtrlObjTpCd 를 싣는다 — 그 외 타입까지 넘기면 공용 매핑의 editor/format 가
      //   붙어 정적 표시가 바뀐다(SalesFuturePriceGrid 주석 동일 규약).
      cellCtrlObjTpCd: c.cell === 'combo' ? CELL_CONTROL_TYPE.COMBO : undefined,
      cellCboDataTp: c.cell === 'combo' ? c.comboId : undefined,
    }));
};

// Freeze 좌측 고정 컬럼 수 — SITE_DESCRIPTION 까지(포함) 고정 (design 03 §3.4 #24 — cs:244).
//   visible 컬럼 기준 index+1. admin 등록본을 쓰는 경우엔 그 순서 기준으로 재계산한다.
export const resolveFrozenColumns = (cols: RawFlexGridColumnConfig[]): number => {
  const idx = cols.findIndex(c => c.colNm === FREEZE_ANCHOR);
  return idx < 0 ? 0 : idx + 1;
};
