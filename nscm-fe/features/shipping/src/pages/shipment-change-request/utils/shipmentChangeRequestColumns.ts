import { CELL_CONTROL_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';

import {
  CELL_COMBO_COLUMNS,
  PLAN_TYPE_PLAN,
  SUB_COLUMN,
  SUB_GROUP_LABEL,
} from '../shipment-change-request.constants';

// 화면이 dataMap 을 부착하는 셀 콤보 2열. 여기서는 **콤보 셀 유형만** 지정하고 dataMap 은 굽지 않는다 —
//   dataMap 을 컬럼 config 에 구우면 조회(division 재조회)마다 columns 배열 참조가 바뀌어 공용 DataGrid 가
//   columnGroups 를 통째로 다시 그리고, 컬럼이 "사라졌다 생기는" 깜빡임이 난다. 실제 dataMap 은
//   MainGrid 의 updatedLayout effect 가 `col.dataMap =` 한 줄로 붙인다(자매 SSP0200 과 동일 처방).
const CELL_COMBO_ATTACHED = new Set<string>(Object.values(CELL_COMBO_COLUMNS));

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
  // 단일 헤더 — 클래스 라벨 제거(스트레이 라벨로 인한 다단화 방지). 컬럼 폭/표시는 메타
  //   (SCM_MST_SHEET_COLUMNS)가 단일 진실이다 — FE 는 visible 축을 뒤집지 않는다(CLAUDE.md §2 체크4).
  //   Change Reason/Reason Detail/Building/Remarks 의 AS-IS 미표시는 메타 VISIBLE_FLAG='N'
  //   (30_fix_main_hide_reason_remarks_asis_parity.sql)이 담당한다 — 종전 FE 최소폭 보정·07_register 의
  //   VIS 'Y' 드리프트를 되돌린 것(사용자 확인 2026-10-23).
  return adminCols.map(c => {
    let col: RawFlexGridColumnConfig = { ...c, sClsLblNm: undefined, lClsLblNm: undefined };
    if (CELL_COMBO_ATTACHED.has(col.colNm)) {
      // 콤보 자리만 만든다(dataMap 은 MainGrid effect 가 부착).
      //   `cellCboDataTp: undefined` 필수 — 비우지 않으면 공용 DataGrid 자동 콤보가 덮어쓴다.
      col = { ...col, cellCboDataTp: undefined, cellCtrlObjTpCd: CELL_CONTROL_TYPE.COMBO };
    }
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
