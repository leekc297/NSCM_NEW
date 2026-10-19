// 저장(P_SCP0010_SAVE_SEMI_DATASET / _FIX_DS / _WEEKLY) — CLOB(JSON 배열) payload 조립.
//   근거: .atlas/gscm-design/SCP0010/design/03_grid-columns.md §4.4(24필드 JSON_TABLE 목록) +
//   ora.py all_arguments 실측(PKG_SCP0010, 2026-09-24) — 3개 SP 전부 (P_DATA CLOB, P_USER_ID
//   VARCHAR2 -> O_RC1, O_RESULT_CURSOR) 동일 시그니처. SCP0009(TVP) 와 저장 payload 형식이 다르다
//   — TVP 문자열 접기(^-delim) 방식을 그대로 복붙하지 않는다.
//
// "행 단위 = 변경된 D_ 셀 1개"(design §4.4) — Weekly 입력은 shipment-plan-semi.deptDayDistribute.ts 로
//   이미 D_ 로 분배된 뒤 저장 대상이 된다(W_ 자체는 저장하지 않는다).
//
// 정직 기록(iter-2 갱신): PKG_SCP0010 의 SCM_ADM_PROC_M 파라미터 메타는 iter-1 시점 0행이었으나
//   이번 회차(ora.py 재확인) GET/SAVE_DATASET/SAVE_FIX_DS/SAVE_WEEKLY 4개 프로시저 전건 등록 완료
//   상태로 바뀌어 있었다(convert-sp 진행분, 이 activity 소관 아님). 등록된 COL_NM 은 P_DATA->data,
//   P_USER_ID->sesUserId(SORT_ORD 1/2, ora.py all_arguments 위치와 1:1 일치 확인) — 호출부가 기존에
//   pData/pUserId 로 보내던 것을 iter-2 에서 data/sesUserId 로 수정(ShipmentPlanSemi.tsx 2곳).
import type { EditTracker } from '@foundation/utils';

import { dynColKindOf } from './shipment-plan-semi.editLock';

// design 03 §4.4 24필드 순서 그대로(A 포함) — JSON_TABLE COLUMNS 절과 1:1 대응.
//
// 필드 의미 확정(iter-3, PKG_SCP0010 PACKAGE BODY DBMS_METADATA.GET_DDL 전문 실측, ora.py):
// - `a`(JSON_TABLE PATH '$.A'/'$.a') — P_LOAD_INPUT 이 GT_SCP0010_INPUT.A 로 그대로 적재하지만,
//   P_SCP0010_SAVE_SEMI_DATASET 의 UPDATE/INSERT/DELETE 3개 구간(L696-832) 어디에도 A 컬럼을 쓰는
//   WHERE/JOIN/SET 절이 없다 — GT_SCP0010_DYNAMIC.A 로 한 번 더 복사되지만(L644-689) 그 이후
//   전혀 참조되지 않는 dead 필드로 확정(iter-2 gap-audit SCP0010-G-11 해소). 빈 문자열 유지가 맞다.
// - `bizType`(p_biz_type) — GT_SCP0010_INPUT 단계까지는 값이 실리지만 GT_SCP0010_DYNAMIC INSERT
//   컬럼 목록(L644-666)에 P_BIZ_TYPE 자체가 없어 P_SCP0010_SAVE_SEMI_DATASET 경로에서는 조용히
//   드롭된다. 반면 P_SEMI_FIX_HIST_DS(Fix/Unfix 이력, L399-457)는 B.P_BIZ_TYPE 을
//   SCP_ANL_SHIPMENT_PLAN_FIX.BIZ_TYPE 조인키로 실제 사용(L427,449) — 이 화면 도메인에서
//   BIZ_TYPE 은 AS-IS 그대로 "OPERATION_GROUP 값"이 맞다(AS-IS BtnFix_Click 계열이 같은 값을
//   n_operation_group/biz_type 양쪽에 싣던 관례와 일치) — operationGroup 과 동일 값 유지가 맞다.
export interface SaveCellRow {
  a: string; // A — 저장 SP 전 경로에서 미사용 확정(dead field). 빈 문자열로 전송.
  activeFlag: string; // p_active_flag(I/M) — 이 화면은 SHIP_PLAN_AMEND 기존행 수정만 가능하므로 'M' 고정
  divisionId: string;
  planStartYyyymmdd: string;
  planType: string;
  seq: string;
  bizType: string; // p_biz_type — SAVE_DATASET 경로는 미사용(GT_SCP0010_DYNAMIC 미포함), FIX_HIST 경로는 BIZ_TYPE 조인키로 사용. operationGroup 과 동일 값.
  operationGroup: string;
  itemId: string;
  fromSite: string;
  bodId: string;
  measure: string;
  yyyymmdd: string; // D_ 대표일(8자리) — W_ 입력은 저장 전 D_ 로 분배됨
  qty: string;
  toSite: string;
  originFromDivisionId: string;
  originToDivisionId: string;
  electrodeType: string;
  fixReason: string; // Fix 저장 시에만 값 채움, 일반 저장은 빈 문자열
  createdBy: string;
  lastUpdatedBy: string;
  timeZone: string;
  bucketType: string;
  transMode: string;
  debugMode: string;
}

const s = (v: unknown): string => (typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '');

// 변경된 D_ 셀만 순회해 24필드 행으로 변환한다. row 는 정보컬럼(design 03 §1)을 그대로 갖고
//   있으므로 Division/BizType/OperGroup 등은 그 행에서 읽는다 — 단 PlanType/Seq 는 MAIN_COLUMNS
//   27건 어디에도 없는 필드다(행별로 다를 수 없는 값 — 한 조회결과는 항상 단일 Plan). 조회조건
//   스냅샷(useShipmentPlanSemiStore appliedPlanType/appliedPlanSeq)에서 받는다(호출측 책임).
export const buildSaveRows = (
  tracker: EditTracker | undefined,
  userId: string,
  timeZone: string,
  planType: string,
  seq: string,
  fixReason = ''
): SaveCellRow[] => {
  if (!tracker) return [];
  const rows: SaveCellRow[] = [];
  tracker.getOriginalValues().forEach((changed, row) => {
    const r = row as unknown as Record<string, unknown>;
    Object.keys(changed).forEach(binding => {
      const kind = dynColKindOf(binding);
      if (kind !== 'D') return; // 저장 대상은 D_ 셀뿐(W_ 입력은 deptDayDistribute 로 이미 D_ 로 분배됨)
      const yyyymmdd = binding.slice(2, 10);
      rows.push({
        a: '', // dead field(SP 미사용 확정) — SaveCellRow 주석 참조
        activeFlag: 'M',
        divisionId: s(r.division_id),
        planStartYyyymmdd: s(r.from_yyyymmdd),
        planType,
        seq,
        bizType: s(r.operation_group),
        operationGroup: s(r.operation_group),
        itemId: s(r.item_id),
        fromSite: s(r.from_site),
        bodId: s(r.bod_id),
        measure: s(r.measure),
        yyyymmdd,
        qty: s(r[binding]),
        toSite: s(r.to_site),
        originFromDivisionId: s(r.ORIGIN_FROM_DIVISION_ID),
        originToDivisionId: s(r.ORIGIN_TO_DIVISION_ID),
        electrodeType: s(r.ELECTRODE_TYPE),
        fixReason,
        createdBy: userId,
        lastUpdatedBy: userId,
        timeZone,
        bucketType: 'DAILY',
        transMode: s(r.transport_mode),
        debugMode: 'F',
      });
    });
  });
  return rows;
};

// P_DATA(CLOB) — JSON 배열 문자열로 직렬화. SCP0009 의 '^'-delim TVP 방식과 다르다(§4.4 주석 참조).
export const buildSavePayloadJson = (rows: SaveCellRow[]): string => JSON.stringify(rows);

export const isSaveResultFailure = (res: { status: number; data?: { code?: unknown } }): boolean =>
  res.status >= 400 || Number(res.data?.code ?? 0) !== 0;
