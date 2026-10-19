import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';

import { COMBO, DIVISION_COLUMN, MERGE_COLUMN, type ColumnMeta } from '../shipment-semi-dept-day.constants';

// constants ColumnMeta -> DataGrid staticColumns(RawFlexGridColumnConfig).
//   admin(SCM_MST_SHEET_COLUMNS) 등록본이 있으면 authoritative(design 03 §0: 11행 배포됨) — 셀콤보 3종
//   (OPERATION_GROUP/DEPARTURE_DAY=LookupCommon, VALID_YN=YesOrNo)도 admin 메타가 원천. 미등록/실패 시 이 fallback.
//   INPUT_TP_CD 는 전건 'S'(design 03 §1) — 편집 판정은 화면 editLock(모드×행상태)이 beginningEdit 에서 최종 결정.
//
// 두 경로 공통 후처리(augmentScreenCombos):
//   - 신규행 DIVISION_ID 셀 콤보 = Division_SCP (admin 메타에 없음 — FE 신규행 한정 셀콤보, design 03 §1.2).
//     cellCboDataTp + attribute9(신규행 전용 후보)로 배선. 기존행은 editLock 이 잠금(표시 전용).
//   - 세로 머지 대상 DIVISION_ID allowMerging=true (design 03 §3.3, 신규행 제외는 CustomMergeManager).
const augmentScreenCombos = (cols: RawFlexGridColumnConfig[]): RawFlexGridColumnConfig[] =>
  cols.map(c => {
    if (c.colNm === DIVISION_COLUMN) {
      return {
        ...c,
        cellCtrlObjTpCd: CELL_CONTROL_TYPE.COMBO,
        cellCboDataTp: COMBO.DIVISION,
        attribute9: COMBO.DIVISION, // 신규행 전용 후보(PARAM9) — design 03 §1.2
        allowMerging: c.colNm === MERGE_COLUMN ? true : c.allowMerging,
      };
    }
    return c;
  });

export const buildColumns = (
  meta: ColumnMeta[],
  adminCols?: RawFlexGridColumnConfig[]
): RawFlexGridColumnConfig[] => {
  if (adminCols && adminCols.length > 0) {
    // 단일 헤더 화면 — 클래스 라벨 제거해 ONE_DEPTH 유지(shipment-master-electrode/shipment-requestor-pic 동일).
    const stripped = adminCols.map(c => ({ ...c, sClsLblNm: undefined, lClsLblNm: undefined }));
    return augmentScreenCombos(stripped);
  }
  const fallback = meta.map<RawFlexGridColumnConfig>(c => {
    const col: RawFlexGridColumnConfig = {
      colNm: c.key,
      colLblNm: c.header,
      horzAlgnCd: c.align ?? 'C',
      colWth: c.width ?? 100,
      dataMaxLength: c.maxLength,
      visible: c.visible !== false,
      display: c.visible !== false,
      // 전건 SEARCH_ONLY — 화면 editLock 이 beginningEdit 에서 모드×행상태로 최종 판정(design 03 §3.1).
      inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
      allowMerging: c.key === MERGE_COLUMN,
    };
    if (c._cell === 'combo' && c._comboId) {
      col.cellCtrlObjTpCd = CELL_CONTROL_TYPE.COMBO;
      col.cellCboDataTp = c._comboId;
      // LookupCommon @lookupType = attribute1 (OPERATION_GROUP/DEPARTURE_DAY, design 03 §1.1).
      if (c._lookupType) col.attribute1 = c._lookupType;
    } else if (c._cell === 'date') {
      col.cellCtrlObjTpCd = CELL_CONTROL_TYPE.DATE_TIME;
    }
    // ITEM_ID(팝업)은 셀타입 미지정 — 클릭/더블클릭 팝업(화면)으로만 열고 beginningEdit 이 인라인 편집 취소.
    return col;
  });
  return augmentScreenCombos(fallback);
};
