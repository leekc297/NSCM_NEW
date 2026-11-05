// SCP0125 Workbench — 타입. 컬럼셋은 admin 메타(102행) 구동이라 행 타입은 procedures.d.ts 의
//   index signature 를 정본으로 쓰고, 화면 로직이 읽는 컬럼만 이름으로 노출한다.

import type { ComboResponse } from '@foundation/models';

import type { DataSheet, MENU_ID, SHEETS, TABS } from './workbench.constants';

/**
 * 데이터 시트(GET 7종) 행 — 시트가 달라도 공용 컬럼(CHG_QTY·CHG_RSN·CHG_TYPE·PRE_CHG_*)이 같다.
 *
 * 7 시트 **유니온**이다. 한 시트(`SHEETS.MKT_FCST`)로 고정하면 STOCK 계열·Elec. Demand 행을
 * `rowsByTab` 에 담을 때 구조가 달라 대입이 막힌다 — 시트마다 컬럼셋이 실제로 다르다
 * (`stock` 20 / `stockUc` 22 / `stockElec`·`stockElecUc` 21 / `elecDemand` 18 / `stock2ndOcv` 19,
 * `procedures.d.ts` SCP0125 블록 = PKG BODY 커서 SELECT 실측).
 *
 * 시트별 Row 별칭(`MktFcstRow` 등 5종)은 두지 않는다 — 그리드·저장·검증이 모두 이 공용 타입 1개로
 * 동작하고, 정의만 있고 참조가 0건인 별칭은 미배선 신호라 오히려 해롭다(convert-core §4.2
 * util 정의-참조 게이트 — iter-1 GAP-11).
 */
export type WorkbenchRow = ResponseData<MENU_ID, DataSheet>;

/**
 * `init`(GET_SEARCH_INFO) 커서 행 — 존재검증용 커서(o_rc5·o_rc6)는 `CODE`/`NAME` 규약이 아니라
 * 업무 컬럼명(`DIVISION_ID`/`ITEM_ID`/`PROJECT_CODE`)으로 내려온다. 컬럼 부분집합을 손으로 적은
 * 약한 타입(all-optional)에 대입하면 index signature 행과 공통 속성이 없어 TS2322 가 난다 —
 * 행 타입은 `procedures.d.ts` index signature 를 정본으로 쓰고 읽는 쪽에서 `str()` 로 좁힌다.
 */
export type WorkbenchInitRow = ResponseData<MENU_ID, SHEETS.INIT>;

/** `init`(GET_SEARCH_INFO) 9커서 — 셀 콤보 원천 6종 + 존재검증 2종 + cboVersion 1종. */
export interface WorkbenchInitData {
  /** O_RC1 — cboVersion 후보 + 신규행 CUTOFF(F10) */
  versionAll: ComboResponse[];
  /** O_RC2 — MKT FCST Sales Site */
  salesSiteAll: ComboResponse[];
  /** O_RC3 — Plant Site(+PLANT_ID) */
  plantSiteAll: ComboResponse[];
  /** O_RC4 — STOCK 계열 SCM Site */
  scmSiteAll: ComboResponse[];
  /** O_RC5 — Item 존재검증(CODE/NAME 아님 — `DIVISION_ID`/`ITEM_ID`) */
  itemAll: WorkbenchInitRow[];
  /** O_RC6 — Project Code 존재검증(`DIVISION_ID`/`PROJECT_CODE`) */
  projectAll: WorkbenchInitRow[];
  /** O_RC7 — 소형(40) End Customer */
  projectCode40All: ComboResponse[];
  /** O_RC8 — Stock(Elec. Plant) Location */
  locationAll: ComboResponse[];
  /** O_RC9 — Line(+PLANT_ID/OPERATION_ID) */
  lineAll: ComboResponse[];
}

/** 조회조건 입력값(searchParams). filters 와 분리 — 조회 버튼을 눌러야 filters 로 커밋된다. */
export interface WorkbenchSearchParams {
  divisionId: string;
  /** 주단위 Plan Date 콤보 선택값(`PLAN_NAME` = YYYYMMDD) */
  planStartYyyymmdd: string;
  /** 일단위 DatePicker 값(YYYYMMDD) — GM 사업부 3탭에서만 노출 */
  planDateDaily: string;
  versionNo: string;
  nickName: string;
  itemId: string;
}

/** 탭별 그리드 행 묶음. */
export type RowsByTab = Record<TABS, WorkbenchRow[]>;
