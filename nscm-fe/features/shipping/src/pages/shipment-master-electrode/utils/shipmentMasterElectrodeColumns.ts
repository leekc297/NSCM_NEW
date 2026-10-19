import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';

import type { ColumnMeta } from '../shipment-master-electrode.constants';

// constants ColumnMeta -> DataGrid staticColumns(RawFlexGridColumnConfig).
//   admin(SCM_MST_SHEET_COLUMNS) 등록본이 있으면 authoritative(design 03 §0: 25행 배포됨) — 셀콤보 좁힘
//   PARAM2/9/10 도 admin 메타가 원천이라(05_register.sql) fallback 은 좁힘 없는 전량 콤보다(화면 최소 보루).
//   콤보 셀(FPComboBox)은 cellCtrlObjTpCd=COMBO + cellCboDataTp 로 공용 DataGrid 자동 콤보 배선.
//   INPUT_TP_CD 는 전건 'S'(design 03 §1) — 편집 판정은 화면 editLock(모드×행상태)이 beginningEdit 에서 최종 결정.
export const buildColumns = (
  meta: ColumnMeta[],
  adminCols?: RawFlexGridColumnConfig[]
): RawFlexGridColumnConfig[] => {
  if (adminCols && adminCols.length > 0) {
    // 단일 헤더 화면 — 클래스 라벨 제거해 ONE_DEPTH 유지(outsourcing-capacity/shipment-model-pic 동일).
    return adminCols.map(c => ({ ...c, sClsLblNm: undefined, lClsLblNm: undefined }));
  }
  return meta.map<RawFlexGridColumnConfig>(c => {
    const col: RawFlexGridColumnConfig = {
      colNm: c.key,
      colLblNm: c.header,
      horzAlgnCd: c.align ?? 'C',
      colWth: c.width ?? 100,
      scale: c.scale,
      visible: true,
      display: true,
      // 전건 SEARCH_ONLY — 화면 editLock 이 beginningEdit 에서 모드×행상태로 최종 판정(design 03 §3.1).
      inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
    };
    if (c._cell === 'combo' && c._comboId) {
      col.cellCtrlObjTpCd = CELL_CONTROL_TYPE.COMBO;
      col.cellCboDataTp = c._comboId;
    } else if (c._cell === 'number') {
      col.cellCtrlObjTpCd = CELL_CONTROL_TYPE.NUMBER;
    }
    // 'popup'(MATERIAL_ID)은 셀타입을 지정하지 않는다 — 더블클릭 팝업(화면 dblClick)으로만 열고,
    //   beginningEdit 이 인라인 편집을 취소한다(팝업 전용, design 03 §3.4).
    return col;
  });
};
