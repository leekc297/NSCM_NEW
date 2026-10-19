import { CELL_CONTROL_TYPE } from '@foundation/constants';
import type { ComboResponse, RawFlexGridColumnConfig } from '@foundation/models';

import {
  CHANGE_TYPE_PLAN,
  COLUMN,
  DIVISION_TOGGLE,
  END_CUSTOMER_DIVISIONS,
  MIN_WIDTH_OVERRIDE,
  PLAN_HIDDEN_COLUMNS,
  SUB_QTY_SCALE,
} from '../shipment-change-request-plan.constants';

// admin(SCM_MST_SHEET_COLUMNS) 등록본이 컬럼의 SSOT 다 — 68/56 행이 이미 배포돼 있어(ora.py 실측)
//   constants 하드코딩 fallback 을 두지 않는다. 여기서는 메타로 표현되지 않는 축만 파생한다.
//   금지: fixed/visible/inputTpCd 처럼 admin 이 관리하는 속성을 리터럴로 덮어쓰기(CLAUDE.md §2 체크 4항).

const PLAN_HIDDEN = new Set<string>(PLAN_HIDDEN_COLUMNS);
const END_CUSTOMER_ONLY = new Set<string>(DIVISION_TOGGLE.END_CUSTOMER_ONLY);
const PROJECT_ONLY = new Set<string>(DIVISION_TOGGLE.PROJECT_ONLY);

export const isEndCustomerDivision = (divisionId: string): boolean =>
  (END_CUSTOMER_DIVISIONS as readonly string[]).includes(divisionId);

interface MainColumnOptions {
  divisionId: string;
  changeType: string;
  /** 화면 주입 dataMap — 컬럼ID -> 후보행. 주입 컬럼은 cellCboDataTp 를 비워야 자동 콤보가 안 덮는다. */
  dataMaps: Record<string, ComboResponse[] | undefined>;
}

// 주입 콤보 적용 — cellCboDataTp 를 반드시 비운다.
//   메타 콤보(LookupCommon/CHANGE_REASON_CODE_ALL)는 @lookupType/@sesUserId 파라미터를 그리드 단위로만
//   받을 수 있어 한 시트에 3종 lookupType 을 공급할 수 없다(D-1/D-2). 그래서 화면이 직접 주입한다.
const applyDataMap = (
  col: RawFlexGridColumnConfig,
  rows: ComboResponse[] | undefined
): RawFlexGridColumnConfig =>
  rows === undefined
    ? col
    : {
        ...col,
        cellCboDataTp: undefined,
        cellCtrlObjTpCd: CELL_CONTROL_TYPE.COMBO,
        dataMap: rows,
      };

/**
 * shtMain 컬럼 파생.
 *  - ChangeType='P' -> ERP_SO_NO/CONFIRM_ID 폭 0(§2.1 P1·P2). AS-IS 도달 불가지만 분기는 보존한다.
 *  - div 40/EE -> END_CUSTOMER·ERP_ATTR1~3 표시 / PROJECT_CODE·PROJECT_NAME 숨김, 그 외 반대(§2.4).
 *    AS-IS 는 셀 DIVISION_ID 변경으로 컬럼 표시를 전역으로 흔들지만(혼합 division 결함),
 *    TO-BE 는 조회조건 division 기준으로만 잡는다 — 의도적 차이(04/__asis-mapping__ 기록).
 *  - 폭 0 + display='Y' 인 핵심 편집 2열은 최소폭 보정(§6 #7). 메타 UPDATE 는 사용자 결정 사항.
 */
export const buildMainColumns = (
  adminCols: RawFlexGridColumnConfig[] | undefined,
  { divisionId, changeType, dataMaps }: MainColumnOptions
): RawFlexGridColumnConfig[] => {
  if (!adminCols || adminCols.length === 0) return [];
  const isPlan = changeType === CHANGE_TYPE_PLAN;
  const endCustomerDiv = isEndCustomerDivision(divisionId);

  return adminCols.map(raw => {
    let col: RawFlexGridColumnConfig = raw;
    const minWidth = MIN_WIDTH_OVERRIDE[col.colNm];
    if (minWidth && !col.colWth) col = { ...col, colWth: minWidth };
    if (isPlan && PLAN_HIDDEN.has(col.colNm)) col = { ...col, colWth: 0 };
    if (END_CUSTOMER_ONLY.has(col.colNm) && !endCustomerDiv) col = { ...col, visible: false };
    if (PROJECT_ONLY.has(col.colNm) && endCustomerDiv) col = { ...col, visible: false };
    col = applyDataMap(col, dataMaps[col.colNm]);
    // 단일 헤더 — shtMain 은 SMALL_CLASS 그룹 라벨을 쓰지 않는다(스트레이 라벨로 인한 다단화 방지).
    return { ...col, sClsLblNm: undefined, lClsLblNm: undefined };
  });
};

/**
 * shtSub 컬럼 파생.
 *  - 2단 헤더는 메타 SMALL_CLASS_LABEL_NAME(`Confirmed`/`Change`)이 원천이다 — 하드코딩 금지(hook #87§D).
 *    ChangeType='P' 일 때만 좌/우 블록 라벨을 `Plan`/`Confirm` 으로 덮어쓴다(§2.1 P5·P6).
 *  - 수량 2열은 무조건 소수 3자리(§2.3 S6·S7).
 *  - REMARKS 는 런타임 폭 0(cs:697 "화면에서만 제거").
 *  - CHK `allowMerging:false` 는 두지 않는다: 공용 DataGrid 가 `mappedStaticColumns` 에서 전 컬럼의
 *    allowMerging 을 그리드 prop 기준으로 덮어써 죽은 설정이 된다(DataGrid.tsx:921~930). 그리드 기본
 *    allowMerging=ColumnHeaders 라 데이터 셀 병합 자체가 없어 CP-19(D9 MergePolicy=None) 결과는 충족된다.
 */
export const buildSubColumns = (
  adminCols: RawFlexGridColumnConfig[] | undefined,
  changeType: string,
  dataMaps: Record<string, ComboResponse[] | undefined>,
  /** ChangeType='P' 분기 그룹 라벨. 화면이 i18n 으로 만들어 넘긴다(영문 하드코딩 금지). */
  planLabels: { plan: string; confirm: string }
): RawFlexGridColumnConfig[] => {
  if (!adminCols || adminCols.length === 0) return [];
  const isPlan = changeType === CHANGE_TYPE_PLAN;

  return adminCols.map(raw => {
    let col: RawFlexGridColumnConfig = raw;
    // 수량 2열 소수 3자리(§2.3 S6·S7). 메타 DATA_SCALE_NUMBER 가 두 열 모두 NULL 인 실측 상태를 보정한다.
    //   주의: `NEW_SHIPMENT_CONFIRM_QTY` 는 메타 셀유형이 FPNumberText 라 공용 매핑이 scale 을 버리고
    //   'd0'(정수) 포맷을 쓴다 — 표시 3자리는 메타 정정(FPNumber + SCALE 3)이 선결이다.
    //   메타 UPDATE 는 사용자 결정 사항이라 `design/05_register_column-meta.sql` 로 분리 산출했다(미적용).
    if (col.colNm === COLUMN.SHIPMENT_CONFIRM_QTY || col.colNm === COLUMN.NEW_SHIPMENT_CONFIRM_QTY) {
      col = { ...col, scale: SUB_QTY_SCALE };
    }
    if (col.colNm === COLUMN.REMARKS) col = { ...col, colWth: 0 };
    if (isPlan && col.colNm === COLUMN.ERP_SO_NO) col = { ...col, visible: false };
    if (isPlan && col.sClsLblNm) {
      // 메타 기본값이 ChangeType!='P' 상태(Confirmed/Change)라 'P' 일 때만 교체한다.
      if (col.sClsLblNm === 'Confirmed') col = { ...col, sClsLblNm: planLabels.plan };
      else if (col.sClsLblNm === 'Change') col = { ...col, sClsLblNm: planLabels.confirm };
    }
    return applyDataMap(col, dataMaps[col.colNm]);
  });
};
