import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';

import { CHK_COLUMN, type ColumnMeta } from '../delegate.constants';

// constants ColumnMeta -> DataGrid staticColumns(RawFlexGridColumnConfig).
//   admin(SCM_MST_SHEET_COLUMNS) 등록본이 있으면 authoritative(design 03 §0: 16행 배포됨),
//   없으면(미등록/실패) 이 constants fallback (shipment-model-pic buildColumns 동일 패턴).
//   CHK 칼럼은 렌더 컬럼에서 제외한다 — 선택 UI 는 공용 DataGrid useCheckbox(Selector, rowHeader
//   체크박스 + 헤더 전체선택)가 대체하므로 이중 체크박스를 만들지 않는다(delegate.constants CHK_COLUMN).
//   전 칼럼 읽기전용(design 03 §3 LockColumn DIVISION_ID~끝열) — inputTpCd=SEARCH_ONLY.
export const buildColumns = (
  meta: ColumnMeta[],
  adminCols?: RawFlexGridColumnConfig[]
): RawFlexGridColumnConfig[] => {
  if (adminCols && adminCols.length > 0) {
    // 단일 헤더 화면 — 클래스 라벨 제거해 ONE_DEPTH 유지. CHK 는 Selector 가 대체하므로 렌더 제외.
    return adminCols
      .filter(c => c.colNm !== CHK_COLUMN)
      .map(c => ({ ...c, sClsLblNm: undefined, lClsLblNm: undefined }));
  }
  return meta
    .filter(c => c.key !== CHK_COLUMN && c.visible !== false)
    .map<RawFlexGridColumnConfig>(c => {
      const col: RawFlexGridColumnConfig = {
        colNm: c.key,
        colLblNm: c.header,
        horzAlgnCd: c.align ?? 'C',
        colWth: c.width ?? 100,
        visible: true,
        display: true,
        inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY, // 전 칼럼 읽기전용(LockColumn 재현)
      };
      if (c._cell === 'date') {
        col.cellCtrlObjTpCd = CELL_CONTROL_TYPE.DATE;
      } else if (c._cell === 'datetime') {
        col.cellCtrlObjTpCd = CELL_CONTROL_TYPE.DATE_TIME;
      }
      return col;
    });
};
