import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';

import {
  FREEZE_ANCHOR_COLUMN,
  LEVEL_COLUMNS,
  type ColumnMeta,
  type LevelNo,
} from '../capa-line-master.constants';

// constants ColumnMeta -> DataGrid staticColumns(RawFlexGridColumnConfig).
//   admin(SCM_MST_SHEET_COLUMNS PROGRAM_ID='SCP0114', SHEET_NAME='Level1'..'Level5') 등록본이 있으면
//   그걸 authoritative 로 쓰고(ui-dynamic-property-management — 속성 단위 덮어쓰기 금지),
//   미등록/실패 시에만 이 fallback 을 쓴다(design 03 §0: 등록은 05_register.sql 소관).
//
// 주의: 하위 시트의 부모레벨 컬럼은 `visible:false` 로 **컬럼 자체는 유지**한다(제거하지 않는다).
//   AS-IS `AddTextColumn(..., bVisible:false)` 와 동일 — 데이터는 보유하고 화면에만 안 나온다.
//   저장 payload(p_site_id 등)가 이 값을 읽고, 공용 필수검증은 visible=false 컬럼을 대상에서 뺀다.
const INPUT_TP_BY_META: Record<ColumnMeta['inputTp'], CELL_INPUT_EDIT_TYPE> = {
  S: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
  O: CELL_INPUT_EDIT_TYPE.OPTIONAL,
  M: CELL_INPUT_EDIT_TYPE.MANDATORY,
  IM: CELL_INPUT_EDIT_TYPE.MANDATORY_INSERT_ONLY,
};

export const buildColumns = (
  level: LevelNo,
  adminColumns?: RawFlexGridColumnConfig[]
): RawFlexGridColumnConfig[] => {
  if (adminColumns && adminColumns.length > 0) {
    // 단일 헤더 화면 — 클래스 라벨 제거해 ONE_DEPTH 유지(자매 SCP0033 동일 규약).
    return adminColumns.map(column => ({ ...column, sClsLblNm: undefined, lClsLblNm: undefined }));
  }
  return LEVEL_COLUMNS[level].map<RawFlexGridColumnConfig>(meta => {
    const column: RawFlexGridColumnConfig = {
      colNm: meta.key,
      colLblNm: meta.header,
      horzAlgnCd: meta.align,
      colWth: meta.width,
      visible: meta.visible !== false,
      display: meta.visible !== false,
      inputTpCd: INPUT_TP_BY_META[meta.inputTp],
    };
    // 콤보 셀만 cellCtrlObjTpCd 를 싣는다 — 그 외 타입까지 넘기면 공용 매핑의 editor/format 이 붙어
    //   정적 표시가 바뀐다(SalesFuturePriceGrid/tactTimeColumns 동일 규약).
    if (meta.cell === 'combo' && meta.comboId) {
      column.cellCtrlObjTpCd = CELL_CONTROL_TYPE.COMBO;
      column.cellCboDataTp = meta.comboId;
    }
    return column;
  });
};

/**
 * 좌측 고정 컬럼 수 — AS-IS `Freeze(0, GetColumnIndex(앵커))` 재현 (design 03 §3.1 R2).
 *
 * 컬럼 목록에서 레벨별 앵커 컬럼까지를 고정한다(앵커 포함). 앵커를 못 찾으면 0(고정 없음).
 * L2~L5 의 앵커는 그 시트에서 visible=false 라 화면상 보이는 고정열은 없다 — AS-IS 와 동일하다.
 */
export const resolveFrozenColumns = (
  level: LevelNo,
  columns: readonly RawFlexGridColumnConfig[]
): number => {
  const anchor = FREEZE_ANCHOR_COLUMN[level];
  const index = columns.findIndex(column => column.colNm === anchor);
  return index < 0 ? 0 : index + 1;
};
