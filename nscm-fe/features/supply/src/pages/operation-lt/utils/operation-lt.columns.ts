import { CELL_CONTROL_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';

import type { ColumnMeta } from '../operation-lt.constants';

// constants 의 ColumnMeta -> DataGrid staticColumns(RawFlexGridColumnConfig).
//   admin(SCM_MST_SHEET_COLUMNS PROGRAM_ID='SCP0037', 실측 13행)이 authoritative — 있으면 그대로 쓰고
//   없으면(미등록/fetch 실패) 이 constants 를 fallback 으로 쓴다(sales-future-price / tact-time 패턴).
//   편집가능 여부는 정적 메타가 아니라 operation-lt.editLock 의 white-list 로 판정(INPUT_TP_CD 전 'S').
export const buildColumns = (
  meta: ColumnMeta[],
  adminCols?: RawFlexGridColumnConfig[]
): RawFlexGridColumnConfig[] => {
  if (adminCols && adminCols.length > 0) return adminCols;
  return meta.map<RawFlexGridColumnConfig>(c => ({
    colNm: c.key,
    colLblNm: c.header,
    horzAlgnCd: c.align ?? 'C',
    colWth: c.width ?? 100,
    visible: true,
    display: true,
    // 콤보 셀만 cellCtrlObjTpCd/cellCboDataTp 를 싣는다 — 그 외 타입까지 넘기면 공용 매핑 editor 가 붙어
    //   정적 표시가 바뀐다(SalesFuturePriceGrid / tact-time 동일 규약).
    cellCtrlObjTpCd:
      c._ctrlType === CELL_CONTROL_TYPE.COMBO ? CELL_CONTROL_TYPE.COMBO : undefined,
    cellCboDataTp: c._ctrlType === CELL_CONTROL_TYPE.COMBO ? c._comboKey : undefined,
  }));
};

// INV_FLAG 조건부 컬럼 Visible (design 01 R6 / 03 §2) — LT Operation=PRE_INSP 아닐 때 컬럼 제거.
export const applyInvFlagVisible = (
  cols: RawFlexGridColumnConfig[],
  showInvFlag: boolean
): RawFlexGridColumnConfig[] =>
  showInvFlag ? cols : cols.filter(c => c.colNm !== 'INV_FLAG');
