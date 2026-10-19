import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';

import type { ColumnMeta } from '../shipment-model-pic.constants';

// constants ColumnMeta -> DataGrid staticColumns(RawFlexGridColumnConfig).
//   admin(SCM_MST_SHEET_COLUMNS) 등록본이 있으면 authoritative(design 03 §0: 21행 배포됨),
//   없으면(미등록/실패) 이 constants fallback (outsourcing-capacity/tact-time buildColumns 패턴).
//   콤보 셀(FROM_SITE/VALID_YN)은 cellCtrlObjTpCd=COMBO + cellCboDataTp 로 DataGrid 자동 콤보 배선.
//   OPERATION_GROUP(opGroup)은 W->Warranty 표시 파생이라 텍스트로 두고 formatItem 에서 매핑(Grid).
export const buildColumns = (
  meta: ColumnMeta[],
  adminCols?: RawFlexGridColumnConfig[]
): RawFlexGridColumnConfig[] => {
  if (adminCols && adminCols.length > 0) {
    // 단일 헤더 화면 — 클래스 라벨 제거해 ONE_DEPTH 유지(outsourcing-capacity 동일 이슈 회피).
    return adminCols.map(c => ({ ...c, sClsLblNm: undefined, lClsLblNm: undefined }));
  }
  return meta
    .filter(c => c.visible !== false)
    .map<RawFlexGridColumnConfig>(c => {
      const col: RawFlexGridColumnConfig = {
        colNm: c.key,
        colLblNm: c.header,
        horzAlgnCd: c.align ?? 'C',
        colWth: c.width ?? 100,
        visible: true,
        display: true,
        inputTpCd:
          c._inputEditType === 'O'
            ? CELL_INPUT_EDIT_TYPE.OPTIONAL
            : CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
      };
      if (c._cell === 'combo' && c._comboId) {
        col.cellCtrlObjTpCd = CELL_CONTROL_TYPE.COMBO;
        col.cellCboDataTp = c._comboId;
      } else if (c._cell === 'date') {
        col.cellCtrlObjTpCd = CELL_CONTROL_TYPE.DATE_TIME;
      } else if (c._cell === 'popup') {
        // 이미지셀(UserInfoPopup) — DB 메타 실측(SCM_MST_SHEET_COLUMNS)이 FPTextModal 이라 fallback 도
        //   동일하게 맞춘다. 공용 DataGrid 가 wj-cell-popup 아이콘을 붙이고, 인라인 편집은 화면
        //   beginningEdit(isInlineEditable=false)이 취소한다(팝업 전용, 더블클릭 오픈).
        col.cellCtrlObjTpCd = CELL_CONTROL_TYPE.TEXT_MODAL;
      }
      return col;
    });
};
