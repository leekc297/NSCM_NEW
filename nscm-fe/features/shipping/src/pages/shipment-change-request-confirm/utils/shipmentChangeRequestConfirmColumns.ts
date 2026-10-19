import type { RawFlexGridColumnConfig } from '@foundation/models';

import { MASTER_USER_COLUMNS } from '../shipment-change-request-confirm.constants';

// lookupType 직접주입 대상(메인 그리드) — CHANGE_TYPE(CHANGE_REQ_TYPE) / SHIPMENT_STATUS(CHANGE_REQ_STATUS).
//   admin 메타는 두 컬럼을 FPComboBox + 셀콤보 'LookupCommon' 으로 등록했으나, 'LookupCommon' 은 @lookupType 이
//   필수인데 공용 DataGrid 는 comboId 로만 중복제거해 컬럼별 @lookupType 을 못 싣는다(두 컬럼이 같은
//   'LookupCommon' 공유 -> 한 쿼리로 합쳐지고 @lookupType 미해소 -> 0행 -> dataMap null -> 코드 노출).
//   그래서 두 컬럼의 셀콤보 메타를 벗겨(plain) 공용 auto-combo 가 안 건드리게 하고, Grid 가 lookup 을 직접
//   조회해 formatItem 으로 code->name 을 확정한다(자매 SSP0003 과 동일, 메모리
//   lookupcommon-grid-cell-combo-lookuptype-unbound).
const LOOKUP_INJECTED_COLUMNS = new Set<string>([
  MASTER_USER_COLUMNS.CHANGE_TYPE, // 'CHANGE_TYPE'
  MASTER_USER_COLUMNS.STATUS, // 'SHIPMENT_STATUS' (Status)
]);

// admin(SCM_MST_SHEET_COLUMNS) 등록본 -> DataGrid staticColumns(RawFlexGridColumnConfig).
//   SSP0202 는 컬럼메타가 DB 에 실측 배포돼 있다(design 03 §0: "Shipment Change Request Confirm" 22 /
//   "Shipment Change Request Confirm Detail" 50, 총 72행). admin 메타가 authoritative — constants
//   하드코딩 컬럼 fallback 을 두지 않는다(72행 수기 전사 = anti-simplification 위반, hook #130. DB 가 SSOT).
//   미등록/fetch 실패 시 빈 배열(그리드 공백).
//
//   메인(siMain): 단일 헤더(ONE_DEPTH) — 클래스 라벨 제거(스트레이 라벨 다단화 방지).
//   서브(siSub): 2단 헤더(Confirmed/Change 또는 Plan/Confirm, SMALL_CLASS_LABEL_NAME) — hook #93 48px.
//     _sChangeType='P' 분기(그룹라벨 오버라이드 + ERP_SO_NO hide)는 SubGrid 컴포넌트 effect 에서 재현(design 03 §2).
export const buildColumns = (
  adminCols: RawFlexGridColumnConfig[] | undefined,
  twoTierHeader: boolean
): RawFlexGridColumnConfig[] => {
  if (!adminCols || adminCols.length === 0) return [];
  if (twoTierHeader) return adminCols;
  // 단일 헤더 — 클래스 라벨 제거(스트레이 라벨로 인한 다단화 방지).
  //   lookup 주입 컬럼(CHANGE_TYPE/SHIPMENT_STATUS)은 셀콤보 메타(cellCtrlObjTpCd/cellCboDataTp/attribute1)를
  //   벗겨 공용 auto-combo 가 dataMap 을 null 로 덮지 않게 한다 — Grid 가 lookup 을 직접 조회해 표시를 확정한다.
  return adminCols.map(c => {
    const base = { ...c, sClsLblNm: undefined, lClsLblNm: undefined };
    if (LOOKUP_INJECTED_COLUMNS.has(c.colNm)) {
      const { cellCtrlObjTpCd: _ctrl, cellCboDataTp: _combo, attribute1: _attr1, ...rest } = base;
      return rest;
    }
    return base;
  });
};
