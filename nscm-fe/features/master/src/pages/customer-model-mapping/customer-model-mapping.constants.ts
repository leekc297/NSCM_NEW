export const MENU_ID = 'DMF0006' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  CUSTOMER_MODEL_MAPPING = 'customerModelMapping',
}

export enum RESPONSE_SET {
  DATA = 'o_rc1',
}

/**
 * Model Type(ITEM_CLASS_NAME) 별 Convert Qty 편집제어 대상 컬럼 바인딩.
 * AS-IS DM0006_CustomerModelMapping.cs 의 CONVERT_QTY_PACK/MODULE/CELL 과 1:1.
 */
export const CONVERT_QTY_BINDINGS = {
  PACK: 'CONVERT_QTY_PACK',
  MODULE: 'CONVERT_QTY_MODULE',
  CELL: 'CONVERT_QTY_CELL',
} as const;

/** Model Type 필드 바인딩 (AS-IS ITEM_CLASS_NAME). */
export const MODEL_TYPE_BINDING = 'ITEM_CLASS_NAME';

/** PJT Code 필드 바인딩. */
export const PROJECT_CODE_BINDING = 'PROJECT_CODE';

/**
 * Project 개념이 없는 Division (Mobility) — 조회조건 Project 입력/팝업 비활성 대상.
 * MKT FCST(DMF0043) ProjectField 의 `disabled={sc.divisionId === DIVISION.MOBILITY}` 와 동일 규칙.
 */
export const DIVISION_NO_PROJECT = '40';

/** Division 필드 바인딩. */
export const DIVISION_BINDING = 'DIVISION_ID';

/**
 * 컬럼 메타 Param1(SCM_MST_SHEET_COLUMNS.ATTRIBUTE1) 의 허용 Division 목록 판정.
 *
 * 관리자 UI Category Setup 에서 해당 컬럼 Param1 에 콤마 목록을 넣으면 그 Division 에서만
 * 편집/팝업이 열린다 (예: PROJECT_CODE 에 '81,81_UC,81_HM,81_ST,81_HD,81_HG,82' → 40 은 잠김).
 * 값이 비어 있으면 제한 없음 — 메타 미등록 화면/컬럼은 종전대로 동작한다.
 *
 * 판정은 콤마 토큰 정확 일치다(substring 금지, 룰 #92 — sales-monitoring _divisionAllow 와 동일 규약).
 * 그래서 81 하위 코드(81_HM 등)를 허용하려면 그 코드까지 목록에 적어야 한다.
 */
export const isDivisionAllowed = (allowList?: string, divisionId?: string): boolean => {
  const allow = allowList?.trim();
  if (!allow) return true;
  if (!divisionId) return true;
  return allow
    .split(',')
    .map(token => token.trim())
    .includes(divisionId);
};

export interface ConvertQtyEditable {
  pack: boolean;
  module: boolean;
  cell: boolean;
}

/**
 * Model Type(ITEM_CLASS_NAME) 값에 따라 Convert Qty(Pack/Module/Cell) 편집 가능 여부를 반환.
 *
 * AS-IS DM0006_CustomerModelMapping.cs L289~307(EditButton) / L1075~1089(CellDoubleClick) 재현:
 *   대소문자 무시 substring 매칭, 판정 순서 MODULE → CELL → PACK → 그 외.
 *   - MODULE 포함 : Pack ✅ / Module ✅ / Cell 🔒
 *   - CELL   포함 : Pack ✅ / Module ✅ / Cell ✅
 *   - PACK   포함 : Pack ✅ / Module 🔒 / Cell 🔒
 *   - 그 외       : Pack ✅ / Module ✅ / Cell ✅
 */
export const getConvertQtyEditable = (itemClassName?: string): ConvertQtyEditable => {
  const type = (itemClassName ?? '').toUpperCase();

  if (type.indexOf('MODULE') >= 0) {
    return { pack: true, module: true, cell: false };
  }
  if (type.indexOf('CELL') >= 0) {
    return { pack: true, module: true, cell: true };
  }
  if (type.indexOf('PACK') >= 0) {
    return { pack: true, module: false, cell: false };
  }
  return { pack: true, module: true, cell: true };
};
