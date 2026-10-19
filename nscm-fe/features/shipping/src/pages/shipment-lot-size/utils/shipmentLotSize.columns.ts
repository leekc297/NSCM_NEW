import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';

import { EDITABLE_COLUMNS, type LotSizeColumnMeta } from '../shipment-lot-size.constants';

const EDITABLE = new Set<string>(EDITABLE_COLUMNS);

// constants 의 LotSizeColumnMeta -> DataGrid staticColumns(RawFlexGridColumnConfig).
//   admin(SCM_MST_SHEET_COLUMNS PROGRAM_ID='SCP0028' SHEET_NAME='Shipment Lot Size') 등록본이 있으면
//   그걸 authoritative 로 쓰고(design 03 §0 실측 18행), 없으면(미등록/fetch 실패) 이 constants fallback.
//   편집가부는 여기 inputTpCd 로 baseline 만 잡고, 편집모드(isEditMode) 게이팅은 Grid beginningEdit 에서
//   최종 판정한다(design 01 R2 — 조회 직후 전잠금, Edit 진입 시만 4컬럼 해제). hook #130.
export const buildColumns = (
  meta: LotSizeColumnMeta[],
  adminCols?: RawFlexGridColumnConfig[]
): RawFlexGridColumnConfig[] => {
  if (adminCols && adminCols.length > 0) return adminCols;
  return meta.map<RawFlexGridColumnConfig>(c => ({
    colNm: c.key,
    colLblNm: c.header,
    horzAlgnCd: c.align ?? 'C',
    colWth: c.width ?? 100,
    visible: c.visible !== false,
    display: c.visible !== false,
    // 편집 4컬럼(LOT_SIZE/INCREMENT/VALID_YN/SPLIT_YN)은 필수(M, 라벨 '*'), 나머지는 표시전용(S).
    //   design 03 §6 B1: 05_register.sql 이 admin 메타를 'M'으로 정비 → admin fetch 시 동일.
    inputTpCd: EDITABLE.has(c.key)
      ? CELL_INPUT_EDIT_TYPE.MANDATORY
      : CELL_INPUT_EDIT_TYPE.SEARCH_ONLY,
    // 특수 렌더(콤보)만 cellCtrlObjTpCd 를 싣는다 — number/date 까지 넘기면 공용 매핑 editor/format 가
    //   붙어 정적 표시가 바뀐다(DistributionRoute/tactTime 동일 규약). 정수/우측정렬은 horzAlgnCd + derive.
    cellCtrlObjTpCd:
      c._ctrlType === CELL_CONTROL_TYPE.COMBO ? (c._ctrlType as CELL_CONTROL_TYPE) : undefined,
    cellCboDataTp: c._ctrlType === CELL_CONTROL_TYPE.COMBO ? c._comboKey : undefined,
    // 정수 셀(LOT_SIZE/INCREMENT) 소수 0자리 명시 배선 — AS-IS SetReNumerCellType(...,0) 파리티(G8).
    //   admin 메타 DATA_SCALE_NUMBER 미등록(공란) fallback 에서도 정수 표시가 유지되도록 FE 에서 방출한다.
    scale: c.scale,
  }));
};
