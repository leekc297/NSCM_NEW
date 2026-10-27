import type { RawFlexGridColumnConfig } from '@foundation/models';

import {
  MIN_WIDTH_OVERRIDE,
  PLAN_TYPE_PLAN,
  SUB_COLUMN,
  SUB_GROUP_LABEL,
} from '../shipment-change-request.constants';

// admin(SCM_MST_SHEET_COLUMNS) 등록본 -> DataGrid staticColumns(RawFlexGridColumnConfig).
//   SSP0201 은 컬럼메타가 DB 에 실측 배포돼 있다(design 03 §0: "Shipment Change Request" 65 /
//   "Change Request" 58, 총 123행). 따라서 admin 메타가 authoritative — constants 하드코딩 컬럼
//   fallback 을 두지 않는다(123행 수기 전사 = anti-simplification 위반 위험. DB 가 SSOT).
//   미등록/fetch 실패 시 빈 배열(그리드 공백) — 05_register.sql 로 셀콤보 B 6종 PARAM 보강.
//
//   메인: 단일 헤더(ONE_DEPTH) — 클래스 라벨 제거(model-pic/outsourcing-capacity 동일 이슈 회피).
//   서브: 2단 헤더(Confirmed/Change, SMALL_CLASS_LABEL_NAME) 유지 — hook #93 48px 다단헤더.
export const buildColumns = (
  adminCols: RawFlexGridColumnConfig[] | undefined,
  twoTierHeader: boolean
): RawFlexGridColumnConfig[] => {
  if (!adminCols || adminCols.length === 0) return [];
  if (twoTierHeader) return adminCols;
  // 단일 헤더 — 클래스 라벨 제거(스트레이 라벨로 인한 다단화 방지).
  //   + 폭 0 인 핵심 편집 2열(CHANGE_REASON_CODE/DETAIL)에 최소폭 보정 — 자매 SSP0200 buildMainColumns
  //     와 동일 처방. 메타 폭이 이미 있으면(0 아님) 건드리지 않는다(admin 관리 축 보존).
  return adminCols.map(c => {
    const col = { ...c, sClsLblNm: undefined, lClsLblNm: undefined };
    const minWidth = MIN_WIDTH_OVERRIDE[col.colNm];
    if (minWidth && !col.colWth) return { ...col, colWth: minWidth };
    return col;
  });
};

/**
 * spdSub "Change Request" 런타임 파생 — AS-IS `InitSpread(shtSub)`(cs:597~653) 실측 재현.
 *
 *  - `REMARKS` 런타임 폭 0 — AS-IS 주석 그대로 "화면에서만 제거함"(cs:622). 메타는 VISIBLE_FLAG='Y',
 *    COLUMN_WIDTH=150 이라(ora.py 실측) 폭만 0 으로 덮는다. `visible:false` 로 숨기지 않는 이유:
 *    메타 축(admin 에서 관리)을 FE 가 뒤집지 않는다(CLAUDE.md §2 체크4) + autoFit 이 폭 0 을 건너뛴다.
 *  - `ERP_SO_NO` — changeType='P' 면 숨김(cs:627), 그 외 표시(cs:649). 메타가 이미 VIS='N'/W=0 이라
 *    else 분기에서도 보이지 않는다 → **메타 정정이 선결**이고 여기서 되살리지 않는다(확인필요).
 *  - 2단 헤더 그룹라벨 — 메타 `SMALL_CLASS_LABEL_NAME` 이 원천(Confirmed 7 / Change 7, 실측)이고
 *    이것이 AS-IS else 분기(cs:651~652)와 일치한다. changeType='P' 일 때만 Plan/Confirm 으로
 *    덮어쓴다(cs:629~630). 라벨 문구는 화면이 i18n 으로 만들어 넘긴다 — 영문 하드코딩 금지(hook #114).
 *
 *  금지: 수량 2열 `scale` 보정. 자매 SSP0200 은 소수 3자리를 강제하지만 AS-IS SSP0201 은
 *    `SetReNumerCellType(..., NEW_SHIPMENT_CONFIRM_QTY, 0)`(cs:603) 로 **0 자리**다. 메타도
 *    FPNumberText(= 공용 매핑이 'd0' 정수 포맷)라 현 동작이 이미 AS-IS 와 같다. 3 을 베끼면 결함이 된다.
 */
export const buildSubColumns = (
  adminCols: RawFlexGridColumnConfig[] | undefined,
  changeType: string,
  /** changeType='P' 분기 그룹라벨(i18n 해석본). 미지정 시 메타 기본값(Confirmed/Change) 유지. */
  planLabels?: { plan: string; confirm: string }
): RawFlexGridColumnConfig[] => {
  if (!adminCols || adminCols.length === 0) return [];
  const isPlan = changeType === PLAN_TYPE_PLAN;

  return adminCols.map(raw => {
    let col: RawFlexGridColumnConfig = raw;
    if (col.colNm === SUB_COLUMN.REMARKS) col = { ...col, colWth: 0 };
    if (isPlan && col.colNm === SUB_COLUMN.ERP_SO_NO) col = { ...col, visible: false };
    if (isPlan && planLabels && col.sClsLblNm) {
      if (col.sClsLblNm === SUB_GROUP_LABEL.DEFAULT.confirmed) {
        col = { ...col, sClsLblNm: planLabels.plan };
      } else if (col.sClsLblNm === SUB_GROUP_LABEL.DEFAULT.change) {
        col = { ...col, sClsLblNm: planLabels.confirm };
      }
    }
    return col;
  });
};
