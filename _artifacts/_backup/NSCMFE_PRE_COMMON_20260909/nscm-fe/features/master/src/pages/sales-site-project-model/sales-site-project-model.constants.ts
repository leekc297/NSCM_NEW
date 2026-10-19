import {
  ITEM_MODAL_CONDITION,
  type ItemModalColumn,
  type ItemModalCondition,
} from '../../components/itemByDivisionModal/item-by-division-modal.constants';

export const MENU_ID = 'DMF0005' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  PRODUCTION = 'production',
  PURCHASE = 'purchase',
}

export enum RESPONSE_SET {
  PRODUCTION = 'production',
  PURCHASE = 'purchase',
}

export enum SHEET_INDEX {
  PRODUCTION,
  PURCHASE,
}

/**
 * ⭐ Model 팝업(COM0008 ItemByDivisionModal)에 노출할 검색조건 — AS-IS 'Model by DivisionPopup' 동등.
 *   Div(비활성) / Model / Item Type 만. Team·End Customer·Sales Site 는 화면에서만 감춘다 —
 *   전부 비활성 표시용이었고 실제 조회 값은 preSearchParams 로 그대로 넘어간다(조회 결과 불변).
 */
export const MODEL_POPUP_CONDITIONS: ItemModalCondition[] = [
  ITEM_MODAL_CONDITION.DIVISION,
  ITEM_MODAL_CONDITION.MODEL,
  ITEM_MODAL_CONDITION.ITEM_TYPE,
];

/**
 * ⭐ Model 팝업(COM0008 ItemByDivisionModal) 결과 그리드에 남길 컬럼과 그 순서.
 *   AS-IS 'Model by DivisionPopup' 헤더: Div | Model Code | Type | Nick Name | Module Type.
 *
 * 컬럼 메타는 division 단위라 팝업 자체를 고칠 수 없다 — 이 화면 호출처에서만 좁힌다
 * (visibleColumns prop). 다른 17개 호출처는 미지정이라 기존 전체 컬럼 그대로.
 * 'A|B' 는 후보 나열 — 먼저 잡히는 쪽 하나만 쓴다.
 *
 * Type 은 COM0008 admin 컬럼 메타에 없어서(=문자열로 적으면 그냥 빠진다) 라벨까지 직접 준다.
 *   응답(o_rc1)에는 ITEM_TYPE / ITEM_TYPE_NAME 이 둘 다 실려 오는데 어느 쪽에 값이 있는지는
 *   division 마다 다를 수 있어, 값이 실제로 들어 있는 쪽을 팝업이 골라 바인딩한다(명칭 우선).
 */
export const MODEL_POPUP_COLUMNS: ItemModalColumn[] = [
  'DIVISION_ID|DIVISION_NAME',
  'ITEM_ID',
  { colNm: 'ITEM_TYPE_NAME|ITEM_TYPE', colLblNm: 'Type', colWth: 80 },
  'NICK_NAME',
  'ITEM_CLASS_NAME',
];

/**
 * ⭐ Model 팝업 가로 폭 — CustomDialog 표준 프리셋 값(기본 1000 → 600, 실제 렌더는 ×1.5).
 *   검색조건 3개·컬럼 5개로 좁힌 이 화면에서만 적용(dialogSize prop). 다른 호출처는 1000 유지.
 */
export const MODEL_POPUP_WIDTH = 600;

/**
 * Owner 를 한 명만 등록할 수 있는 division — 2명 이상 선택하고 OK 하면 팝업에서 경고.
 * 상단(Production) 과 하단(Purchase) 의 대상 division 이 다르다.
 * AS-IS DMF0005_SaleSite_PjtModelMapping.cs: division 82 만 Owner(Sales) 콤마 포함 시 차단(MSG00430) —
 *  82: Sales, 83: Sales2, 84: Sales3, 85: Sales4, 86: Sales5, 87: Sales6, 88: Sales7, 89: Sales8상단(siMain L3403)·하단(siSub L3921) 동일. 81 은 else 분기라 제한 없음(콤마 포함 값 그대로 저장)
 */
export const SINGLE_OWNER_DIVISIONS = {
  [SHEETS.PRODUCTION]: ['82'],
  [SHEETS.PURCHASE]: ['82'],
} as Record<SHEETS, readonly string[]>;
