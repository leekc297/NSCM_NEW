import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';

import type { RouteColumnMeta } from '../distribution-route.constants';

// constants 의 RouteColumnMeta -> DataGrid staticColumns(RawFlexGridColumnConfig).
//   admin(SCM_MST_SHEET_COLUMNS PROGRAM_ID='SCP0005' SHEET_NAME='Distribution Route') 등록본이 있으면
//   그걸 authoritative 로 쓰고(design 03 §0 실측 39행 존재: 31 'O' + 8 'S'), 없으면(미등록/fetch 실패)
//   이 constants 를 fallback 으로 쓴다(tact-time/sales-future-price 동일 패턴).
export const buildColumns = (
  meta: RouteColumnMeta[],
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
    inputTpCd:
      c._inputEditType === 'S'
        ? CELL_INPUT_EDIT_TYPE.SEARCH_ONLY
        : CELL_INPUT_EDIT_TYPE.OPTIONAL,
    // 특수 렌더가 필요한 셀(콤보/텍스트모달)만 cellCtrlObjTpCd 를 싣는다 — 그 외 타입까지 넘기면
    //   공용 매핑의 editor/format 가 붙어 정적 표시가 바뀐다(SalesFuturePriceGrid/tactTimeColumns 동일 규약).
    //   FPTextModal(FROM/TO COUNTRY·CITY)은 키인+돋보기 모달 셀이라 fallback 에서도 컨트롤을 실어야
    //   admin fetch 실패 시에도 DB 메타(FPTextModal)와 동일하게 돋보기가 노출된다(gap G6).
    cellCtrlObjTpCd:
      c._ctrlType === CELL_CONTROL_TYPE.COMBO || c._ctrlType === CELL_CONTROL_TYPE.TEXT_MODAL
        ? (c._ctrlType as CELL_CONTROL_TYPE)
        : undefined,
    cellCboDataTp: c._ctrlType === CELL_CONTROL_TYPE.COMBO ? c._comboKey : undefined,
  }));
};
