// 저장 payload 조립 (design 03 §4.3) — 순수 함수.
//   siMain 시뮬레이션 저장: 편집 마킹된 활성 span 의 D_ 셀(P_SHIP_PLAN_SIMU_ETD 측정치 행)만
//     (row 식별키 + YYYYMMDD + 값) flat 리스트로 조립 — 그리드 전체 전송 금지.
//   siDetail 저장: action∈{I,M} 행의 편집 화이트리스트 컬럼 전송.
//   dirty 판정은 AS-IS ForeColor=Red 대신 EditTracker 원본값 비교(CRUD_TYPE 'M' + 셀/컬럼 diff)로 재현.
//   payload 키 = SCM_ADM_PROC_M COL_NM 실측(2026-09-27 메인세션 ora.py):
//     PKG_SSP0023.P_SSP0023_SAVE_SHIPMENT_PLAN_SIMU IN 14키 =
//       activeFlag / divisionId / companyId / plantId / scmSiteId / modelId / itemId /
//       npcItemId / yyyymmdd / qty / planStartYyyymmdd / measure / lastUpdatedBy / electrodeType.
//     SP 본문(ALL_SOURCE PACKAGE BODY:3468~3494) UPDATE/INSERT WHERE 식별키 9개 =
//       DIVISION_ID·COMPANY_ID·PLANT_ID·SCM_SITE_ID·MODEL_ID·ITEM_ID·MEASURE·YYYYMMDD·PLAN_START_YYYYMMDD.
//     필수: plantId/scmSiteId/modelId 누락 시 WHERE 불일치로 UPDATE ROWCOUNT=0·INSERT 0행 =
//       조용한 no-op 저장(저장은 성공처럼 보이나 미반영). 세 컬럼 모두 main 시트 행에 존재(SHEET_COLUMNS 실측).
//     npcItemId 는 INSERT 시 기존 행에서 SELECT(파라미터로 필터 안 함) → 공백 전송 안전(키 정렬용).
//     electrodeType 은 QTY_TO_PCM 환산 조회(:3414)에 쓰이므로 행값 전송.

import { PLAN_DETAIL_EDITABLE_COLUMNS } from '../shipment-plan-electrode.constants';

import { parseDynTag, type DynSpan } from './shipment-plan-electrode.editLock';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
const num = (v: unknown): number => {
  const n = Number(v);
  return Number.isFinite(n) ? n : 0;
};

export interface MainSaveContext {
  divisionId: string;
  companyId: string;
  planStartYyyymmdd: string; // 선택 Plan Date
  userId: string; // lastUpdatedBy 로 전송
  activeSpan: DynSpan; // 활성 radio span(X/Y/Z) — 이 span 의 D_ 셀만 저장 대상
}

export type MainSaveRow = Record<string, string>;

/**
 * siMain 시뮬레이션 저장 대상 수집 — 편집된 (활성 span) D_ 셀만 flat 행으로.
 *   originalOf: EditTracker 가 보관한 행별 "변경된 컬럼 원본값" 맵(그 키 중 활성 span D_ 만 diff).
 *   음수(MSG00225)는 negatives 로 분리 — 호출부가 저장 자체를 abort 한다.
 */
export const collectMainSaveRows = (
  rows: Record<string, unknown>[],
  originalOf: (row: Record<string, unknown>) => Record<string, unknown> | undefined,
  ctx: MainSaveContext
): { payload: MainSaveRow[]; negatives: { row: Record<string, unknown>; day: string }[] } => {
  const payload: MainSaveRow[] = [];
  const negatives: { row: Record<string, unknown>; day: string }[] = [];

  rows.forEach(row => {
    if (str(row.CRUD_TYPE) !== 'M') return;
    const original = originalOf(row);
    if (!original) return;
    Object.keys(original).forEach(binding => {
      const tag = parseDynTag(binding);
      // 활성 span 의 일자(D_) 셀만 — W_/M_(Sum)·비활성 span 은 저장 대상 아님(03 §2.2)
      if (!tag || tag.span !== ctx.activeSpan || tag.bucket !== 'D') return;
      const current = num(row[binding]);
      const before = num(original[binding]);
      if (current === before) return;
      if (current < 0) {
        negatives.push({ row, day: binding });
        return;
      }
      payload.push({
        // PROC_M COL_NM 14키 (순서·키명 SP 계약 일치). 식별 9키는 SP WHERE 대상.
        activeFlag: 'M',
        divisionId: ctx.divisionId,
        companyId: ctx.companyId,
        plantId: str(row.PLANT_ID),
        scmSiteId: str(row.SCM_SITE_ID),
        modelId: str(row.MODEL_ID),
        itemId: str(row.ITEM_ID),
        npcItemId: str(row.NPC_ITEM_ID), // 기존 행 SELECT — 공백이면 SP 가 원본 값 유지
        yyyymmdd: tag.ymd, // '[X|Y|Z]_D_20260901' → '20260901'
        qty: String(current),
        planStartYyyymmdd: ctx.planStartYyyymmdd,
        measure: str(row.MEASURE), // P_SHIP_PLAN_SIMU_ETD
        lastUpdatedBy: ctx.userId,
        electrodeType: str(row.ELECTRODE_TYPE), // QTY_TO_PCM 환산 조회 키
      });
    });
  });

  return { payload, negatives };
};

export interface DetailSaveContext {
  userId: string;
  userDeptId: string;
  planStartYyyymmdd: string;
}

/**
 * siDetail(shtPlanDetail) 저장 대상 수집 — action∈{I,M} 행의 편집 화이트리스트 컬럼 전송(03 §4.3).
 *   신규행(I)은 전 화이트리스트 컬럼, 수정행(M)은 변경분 포함 전 화이트리스트 컬럼을 실어 보낸다
 *   (AS-IS 는 변경 여부와 무관히 편집칼럼 전건 전송 — SaveData 매핑 재현).
 */
export const collectDetailSaveRows = (
  rows: Record<string, unknown>[],
  ctx: DetailSaveContext
): Record<string, string>[] => {
  const payload: Record<string, string>[] = [];
  rows.forEach(row => {
    const crud = str(row.CRUD_TYPE);
    if (crud !== 'I' && crud !== 'M') return;
    const entry: Record<string, string> = {
      activeFlag: crud, // I(신규)/M(수정)
      divisionId: str(row.DIVISION_ID),
      itemId: str(row.ITEM_ID),
      fromSite: str(row.FROM_SITE),
      toSite: str(row.TO_SITE),
      shipmentStatus: str(row.SHIPMENT_STATUS),
      erpSoNo: str(row.ERP_SO_NO),
      changeReqNo: str(row.CHANGE_REQ_NO),
      planStartYyyymmdd: ctx.planStartYyyymmdd,
      userId: ctx.userId,
      userDeptId: ctx.userDeptId,
      debugMode: 'F',
    };
    // 편집 화이트리스트 컬럼 값 부착 (03 §3.1 PLAN_DETAIL_EDITABLE_COLUMNS)
    PLAN_DETAIL_EDITABLE_COLUMNS.forEach(col => {
      entry[col] = str(row[col]);
    });
    payload.push(entry);
  });
  return payload;
};
