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
