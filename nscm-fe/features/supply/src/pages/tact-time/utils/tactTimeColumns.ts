import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';

import type { MainColumnMeta } from '../tact-time.constants';

// constants 의 MainColumnMeta -> DataGrid staticColumns(RawFlexGridColumnConfig).
//   admin(SCM_MST_SHEET_COLUMNS) 등록본이 있으면 그걸 authoritative 로 쓰고, 없으면(미등록)
//   이 constants 를 fallback 으로 쓴다(sales-future-price MAIN_COLUMNS 패턴).
export const buildColumns = (
  meta: MainColumnMeta[],
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
      inputTpCd:
        c._inputEditType === 'S'
          ? CELL_INPUT_EDIT_TYPE.SEARCH_ONLY
          : CELL_INPUT_EDIT_TYPE.OPTIONAL,
      // 콤보 셀만 cellCtrlObjTpCd 를 싣는다 — 그 외 타입까지 넘기면 공용 매핑의 editor/format 가
      //   붙어 정적 표시가 바뀐다(SalesFuturePriceGrid 주석 동일 규약).
      cellCtrlObjTpCd:
        c._ctrlType === CELL_CONTROL_TYPE.COMBO ? CELL_CONTROL_TYPE.COMBO : undefined,
      cellCboDataTp: c._ctrlType === CELL_CONTROL_TYPE.COMBO ? c._comboKey : undefined,
    }));
};
