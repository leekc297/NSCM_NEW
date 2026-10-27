import { EDIT_MAIN_FLAG, FIXED_DIVISION } from '../shipment-change-request.constants';

/**
 * 신규행 초기값 — **경로가 둘이고 서로 다르다**(자매 SSP0200 과 동일 규약, 사용자 지시 2026-10-13).
 *
 *  - `InsertButton`(툴바 Insert) : 선택행 복사 + `RowCount>0` 가드  -> `buildCopiedRow`
 *  - `btnNew`(New 버튼)          : `DIVISION_ID` 만 + div 분기 `'-'`, **가드 없음** -> `buildNewRow`
 *
 * 종전에는 New 도 `buildCopiedRow` 를 재사용해 두 버튼이 같은 동작이었다. SSP0200 과 맞추라는
 * 지시로 경로를 분리했다 — 2026-10-08 "New 가 선택 행을 복사하지 않는다" 신고로 복사를 붙였던
 * 결정을 뒤집은 것이다(그 신고의 복사 요구는 **Insert** 쪽에서 계속 충족된다).
 */

/**
 * Insert 신규행 초기값 — **선택(활성) 행의 값을 복사**한다.
 *
 * AS-IS: GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0201_ShipmentChangeRequest.cs
 *   `InsertButton()`(L683) -> `InsertRow()`(L2428~2530).
 *   복사원은 `siMain.Insert()` 로 행을 끼워 넣은 **뒤**의 `ActiveRowIndex + 1`(L2438) —
 *   삽입으로 한 칸 밀린 **원래 활성 행**이다. 즉 "누르기 직전에 선택돼 있던 행"이 원본이다.
 *
 * 복사 14키 — AS-IS L2493~2516 `defaultData` 12키 + 자매 SSP0200 이 추가로 복사하는 2키:
 *   DIVISION_ID · ITEM_ID · FROM_SITE_DESCRIPTION · TO_SITE_DESCRIPTION · TO_SITE_SHIPTO_CODE ·
 *   PROJECT_CODE/END_CUSTOMER(div 분기) · SHIPMENT_CONFIRM_QTY · SHIPMENT_DATE · INCOTERMS ·
 *   TRANSPORT_MODE · FCST_TYPE · **NICK_NAME · MTK_OWNER**
 *
 * `NICK_NAME`/`MTK_OWNER` 는 SSP0201 AS-IS `defaultData` 에는 없고 SSP0200 `buildCopiedRow` 에만
 * 있던 키다. 두 화면의 Insert 를 같게 하라는 지시(2026-10-13)로 추가했다 — DB 실측상 SSP0201
 * 'Shipment Change Request' 시트에도 두 컬럼이 실재하므로 넣을 자리가 있다.
 * `TO_SITE_SHIPTO_CODE` 는 반대로 SSP0201 AS-IS 에만 있는 키인데 **유지**한다(SSP0200 이 복사하는
 * 것은 전부 복사하면서 자체 AS-IS 도 보존 — 사용자 결정).
 *
 * 함정 2개 — 자매 SSP0200 이 같은 지점에서 이미 겪은 것이다:
 *
 *  (1) **site 2열은 코드값에서 읽어 description 열에 넣는다.**
 *      AS-IS L2443~2444 는 `GetValue(DefColumns.FROM_SITE)` / `GetValue(DefColumns.TO_SITE)` 로
 *      읽어 `FROM_SITE_DESCRIPTION` / `TO_SITE_DESCRIPTION` 키에 담는다(변수명만 DESCRIPTION 이다).
 *      두 description 열은 셀 콤보이고 그 CODE 가 site_id 라, 화면에 보이는 description 문자열을
 *      그대로 넣으면 콤보가 매칭되지 않아 빈 칸으로 보인다.
 *      DB 실측(2026-10-08): SSP0201 'Shipment Change Request' 시트에 FROM_SITE·TO_SITE 두 코드
 *      컬럼이 실재한다(SORT_ORDER_NO 9·10) — 복사원이 있다.
 *
 *  (2) **PROJECT_CODE 와 END_CUSTOMER 는 상호배타다.**
 *      AS-IS L2448~2462 + L2500~2510: 조회조건 division 이 '40' 이면 복사원의 **END_CUSTOMER** 를
 *      END_CUSTOMER 로 옮기고 `PROJECT_CODE='-'`, 아니면 복사원 **PROJECT_CODE** 를 옮기고
 *      `END_CUSTOMER='-'`. 두 열을 그대로 복사하면 AS-IS 가 비우는 쪽에 값이 남는다.
 *      판정 기준은 **조회조건 division**(`clbDivision_ID.ControlValues`)이지 행 값이 아니다.
 *      SSP0201 은 Division 이 '40' 고정(R3)이라 실질적으로 END_CUSTOMER 분기만 타지만,
 *      AS-IS 와 같은 식을 남겨 둔다(고정값이 풀리면 그대로 따라간다).
 *
 * 미이식(의도): AS-IS 는 복사와 함께 셀 콤보 재조회(ShipToCodeByDivision/FromSite/ToSite/MyDivision),
 *   이미지 셀타입, `LockRange` 5구간을 건다. TO-BE 에서 콤보는 컬럼 메타(PARAM10='D') 구동이고
 *   잠금은 `NEW_ROW_EDIT_COLUMNS` 화이트리스트가 담당하므로 여기서는 **값만** 만든다.
 */

export type GridRowData = Record<string, unknown>;

/** 상호배타 열을 비울 때 쓰는 AS-IS 센티널(빈 문자열이 아니라 '-' 다). */
const EXCLUSIVE_NONE = '-';

export const buildCopiedRow = (base: GridRowData, divisionId: string): GridRowData => {
  const endCustomerDiv = divisionId === FIXED_DIVISION;
  return {
    DIVISION_ID: base.DIVISION_ID,
    ITEM_ID: base.ITEM_ID,
    // (1) 코드값 -> description 열. 변수명에 속지 말 것.
    FROM_SITE_DESCRIPTION: base.FROM_SITE,
    TO_SITE_DESCRIPTION: base.TO_SITE,
    TO_SITE_SHIPTO_CODE: base.TO_SITE_SHIPTO_CODE,
    // (2) 상호배타
    PROJECT_CODE: endCustomerDiv ? EXCLUSIVE_NONE : base.PROJECT_CODE,
    END_CUSTOMER: endCustomerDiv ? base.END_CUSTOMER : EXCLUSIVE_NONE,
    SHIPMENT_CONFIRM_QTY: base.SHIPMENT_CONFIRM_QTY,
    SHIPMENT_DATE: base.SHIPMENT_DATE,
    INCOTERMS: base.INCOTERMS,
    TRANSPORT_MODE: base.TRANSPORT_MODE,
    FCST_TYPE: base.FCST_TYPE,
    // SSP0200 패리티 2키 — ITEM_ID 를 복사하므로 그에 딸린 표시값도 함께 가져온다.
    //   둘 중 하나만 복사하면 Model 은 채워졌는데 Nick Name 은 빈 행이 된다.
    NICK_NAME: base.NICK_NAME,
    MTK_OWNER: base.MTK_OWNER,
    // 변경검지 플래그 — 신규행은 '수정됨' 이 아니다(design 03 §3.2). AS-IS defaultData 에는 없고
    //   TO-BE 저장 판정(EDIT_MAIN)이 쓰는 값이라 종전 handleInsert 와 동일하게 'N' 으로 둔다.
    [EDIT_MAIN_FLAG]: 'N',
  };
};

/**
 * `btnNew` — 조회조건 division + div 분기 `'-'` 뿐이다(자매 SSP0200 `buildNewRow` 와 동일).
 *
 * AS-IS 가 **의도적으로** `RowCount>0` 가드를 뺀 경로다 — 빈 그리드(조회 전)에서도 행이 추가된다.
 * 복사원을 읽지 않으므로 가드가 필요 없다.
 *
 * `CHANGE_REASON_CODE` 는 **넣지 않는다** — `'T07'` 은 `SSP_Main_Validation`(cs:3130~3221)이
 * 저장 직전에 **수정행**을 상대로 자동 세팅하는 값이다(미구현, 04 GAP-VALCHK). 신규행 기본값으로
 * 넣으면 사용자가 사유를 고르지 않아도 채워진 것처럼 보여 그 규칙의 판정 자체를 흐린다.
 */
export const buildNewRow = (divisionId: string): GridRowData => {
  const endCustomerDiv = divisionId === FIXED_DIVISION;
  return {
    DIVISION_ID: divisionId,
    PROJECT_CODE: endCustomerDiv ? EXCLUSIVE_NONE : '',
    END_CUSTOMER: endCustomerDiv ? '' : EXCLUSIVE_NONE,
    [EDIT_MAIN_FLAG]: 'N',
  };
};
