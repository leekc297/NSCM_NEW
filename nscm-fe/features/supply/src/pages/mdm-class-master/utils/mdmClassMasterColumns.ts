import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';

import type { MainColumnMeta } from '../mdm-class-master.constants';

// constants 의 MainColumnMeta -> DataGrid staticColumns(RawFlexGridColumnConfig).
//   admin(SCM_MST_SHEET_COLUMNS) 등록본이 있으면 그걸 authoritative 로 쓰고(SCP0087 23행 등록확인),
//   없으면(미등록/실패) 이 constants 를 fallback 으로 쓴다(tact-time/sales-future-price 패턴).
//   2단 헤더는 sClsLblNm(SMALL_CLASS_LABEL_NAME)으로 구동 — columnMapping TWO_DEPTH 가 Level 1~4 그룹핑(design 03 §2).
export const buildColumns = (
  meta: MainColumnMeta[],
  adminCols?: RawFlexGridColumnConfig[]
): RawFlexGridColumnConfig[] => {
  if (adminCols && adminCols.length > 0) return adminCols;
  return meta.map<RawFlexGridColumnConfig>(c => ({
    colNm: c.key,
    colLblNm: c.header,
    sClsLblNm: c.sClsLblNm,
    horzAlgnCd: c.align,
    colWth: c.width,
    fixed: c.fixed ?? false,
    visible: true,
    display: true,
    // 편집가능 3컬럼만 OPTIONAL, 그 외 SEARCH_ONLY(읽기전용). 편집모드 게이트는 화면 beginningEdit(isEditing)이 추가.
    inputTpCd:
      c._inputEditType === 'O'
        ? CELL_INPUT_EDIT_TYPE.OPTIONAL
        : CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
    // 셀유형은 FPNumber(LEVEL)/FPDateTime(INSERT/UPDATE_TIME)만 싣는다 — 그 외 일반 텍스트(design 03 §1).
    cellCtrlObjTpCd:
      c._ctrlType === 'FPNumber'
        ? CELL_CONTROL_TYPE.NUMBER
        : c._ctrlType === 'FPDateTime'
          ? CELL_CONTROL_TYPE.DATE_TIME
          : undefined,
  }));
};
