import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';

import type { ColumnMeta } from '../shipment-requestor-pic.constants';

// constants ColumnMeta -> DataGrid staticColumns(RawFlexGridColumnConfig).
//   admin(SCM_MST_SHEET_COLUMNS) 등록본이 있으면 authoritative(design 03 §0: 19행 배포됨) — 셀콤보 좁힘
//   PARAM2/9/10 도 admin 메타가 원천이라(05_register.sql) fallback 은 좁힘 없는 전량 콤보다(화면 최소 보루).
//   콤보 셀(FPComboBox)은 cellCtrlObjTpCd=COMBO + cellCboDataTp 로 공용 DataGrid 자동 콤보 배선.
//   편집 판정은 admin INPUT_TP_CD 가 아니라 화면 editLock(모드×행상태)이 beginningEdit 에서 최종 결정한다
//   (design 03 §3.1). admin INPUT_TP_CD 는 공용 useSaveWithValidation 의 필수검증 대상 판정에만 쓰인다.
export const buildColumns = (
  meta: ColumnMeta[],
  adminCols?: RawFlexGridColumnConfig[]
): RawFlexGridColumnConfig[] => {
  if (adminCols && adminCols.length > 0) {
    // 단일 헤더 화면 — 클래스 라벨 제거해 ONE_DEPTH 유지(shipment-model-pic/shipment-master-electrode 동일).
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
        // fallback 은 SEARCH_ONLY 고정 — 편집 허용은 화면 editLock 이 beginningEdit 에서 모드×행상태로
        //   최종 판정한다(design 03 §3.1). 이 경로에서는 공용 필수검증이 비므로 화면 handleSave 의
        //   REQUIRED_COLUMNS 사전검사가 필수값을 막는다.
        inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
      };
      if (c._cell === 'combo' && c._comboId) {
        col.cellCtrlObjTpCd = CELL_CONTROL_TYPE.COMBO;
        col.cellCboDataTp = c._comboId;
      } else if (c._cell === 'date') {
        col.cellCtrlObjTpCd = CELL_CONTROL_TYPE.DATE_TIME;
      } else if (c._cell === 'popup') {
        // 이미지셀(UserInfoPopup) — DB 메타 실측이 FPTextModal 이라 fallback 도 동일하게 맞춘다.
        //   공용 DataGrid 가 팝업 아이콘을 붙이고, 인라인 편집은 화면 beginningEdit(isInlineEditable=false)이
        //   취소한다(팝업 전용, 더블클릭 오픈, nscm-patterns §5-16).
        col.cellCtrlObjTpCd = CELL_CONTROL_TYPE.TEXT_MODAL;
      }
      // ITEM_ID(팝업)은 셀타입 미지정 — 더블클릭 팝업(화면 dblClick)으로만 열고,
      //   beginningEdit 이 인라인 편집을 취소한다(팝업 전용, design 03 §3 R12).
      return col;
    });
};
