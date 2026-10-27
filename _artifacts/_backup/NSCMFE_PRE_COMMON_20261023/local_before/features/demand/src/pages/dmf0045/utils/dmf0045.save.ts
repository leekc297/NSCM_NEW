// DMF0045 — SAVE payload 구성 ('^' bulk, AS-IS SaveData cs 1922~2048 SetSaveData/dtSave 1:1).
//   근거(design 03 §2.4/§4.3 + AS-IS DMF0045_ShipmentRequest.cs):
//     · 저장 대상   : 신규/수정행(action I/M) 중 변경된 "D_ 셀"만 (§4.3 — dtSave 는 항상 D_ 단위 정규화).
//       W_/M_ 입력은 그리드 편집 시점에 dispatchRecalc 로 D_ 로 이미 전개된다(§2.4, ShipmentRequestGrid).
//       그래서 저장 수집은 버킷과 무관하게 EditTracker 가 잡은 D_ 셀(신규는 값 존재 D_)만 본다.
//     · 값 '0' → 'D': 수량 0 은 셀 단위 삭제(action 'D' 전환) — sales-plan/DMF0021 동일 규약.
//     · 정수 정규화 : qty 는 정수(§2.4 Convert.ToInt32) — 그리드 cellEditEnded 에서 이미 절삭되나
//       저장 단계에서도 방어적으로 정수화(붙여넣기·파생 경로 누락 대비).
//   SAVE SP = P_DMF0045_SAVE_SHIPMENT_REQUEST — IN CLOB 13(콤마 아님 '^' delim 다행) + P_CREATED_BY.
//     P_CREATED_BY(VARCHAR2 단일) 는 BE 세션 자동주입(useShipmentRequestStore GET 규약과 동일 —
//     SCM_ADM_PROC_M.COL_NM positional, sesUserId BE 주입). 그래서 '^' bulk 13키만 조립한다.
//   '^' bulk 다건 = apiClient.post 직접 (useProcMutation array unfold 회피 표준 —
//   memory feedback_save_sp_bulk_payload_apiclient_post).
import type { ShipmentRequestRow } from '../dmf0045.types';

import { dynKindOf } from './dmf0045.editLock';

// SAVE 한 row(= 행 × D_ 기간셀) 의 업무 데이터 13키 (SP IN CLOB 13 — design 03 §4.3).
//   SP 파라미터 ↔ 그리드 컬럼 매핑(design 03 §1):
//     P_ACTIVE_FLAG=activeFlag('I'/'M'/'D') / P_DIVISION_ID=DIVISION_ID / P_ITEM_ID=ITEM_ID /
//     P_FROM_SITE=FROM_SITE / P_TO_SITE=TO_SITE / P_PROJECT_CODE=PROJECT_CODE / P_INCOTERMS=INCOTERMS /
//     P_FCST_TYPE=FCST_TYPE / P_TRANSPORT_MODE=TR_MODE(그리드 binding) / P_BOD_ID=BOD_ID /
//     P_MEASURE=MEASURE / P_YYYYMMDD=D_ 태그(yyyymmdd) / P_QTY=정수 수량.
export interface SaveUnfoldRow {
  activeFlag: string; // 'I'(신규) / 'M'(수정) / 'D'(0값 — 셀 단위 삭제)
  divisionId: string;
  itemId: string;
  fromSite: string;
  toSite: string;
  projectCode: string;
  incoterms: string;
  fcstType: string;
  transportMode: string; // 그리드 TR_MODE → SP P_TRANSPORT_MODE
  bodId: string;
  measure: string;
  yyyymmdd: string; // D_ 태그의 yyyymmdd (D_ 접두 제거)
  qty: string; // 정수 문자열
}

type Rec = Record<string, unknown>;

const str = (v: unknown): string =>
  typeof v === 'string' ? v.trim() : typeof v === 'number' ? String(v) : '';

// 수량 정규화 — 빈값 '0', 콤마 제거, 숫자 아님 '0', 정수 절삭(§2.4). 소수 미허용(출하요청은 정수 수량).
const qtyOf = (v: unknown): string => {
  if (v == null || v === '') return '0';
  const n = typeof v === 'number' ? v : Number(str(v).replace(/,/g, ''));
  return Number.isFinite(n) ? String(Math.trunc(n)) : '0';
};

// 업무 데이터 13키 중 기간 무관 11키(activeFlag/yyyymmdd/qty 제외) — 행 컬럼 → SP 슬롯 추출.
const identityOf = (
  row: Rec,
  divisionId: string
): Omit<SaveUnfoldRow, 'activeFlag' | 'yyyymmdd' | 'qty'> => ({
  divisionId: str(row.DIVISION_ID) || divisionId,
  itemId: str(row.ITEM_ID),
  fromSite: str(row.FROM_SITE),
  toSite: str(row.TO_SITE),
  projectCode: str(row.PROJECT_CODE),
  incoterms: str(row.INCOTERMS),
  fcstType: str(row.FCST_TYPE),
  transportMode: str(row.TR_MODE),
  bodId: str(row.BOD_ID),
  measure: str(row.MEASURE),
});

/**
 * 변경된 모든 행/셀 → SaveUnfoldRow 목록 (design 03 §4.3 — D_ 단위 정규화).
 *   - 신규 행(insertedRows): 값 존재 D_ 셀 전량 → 'I' (0값 → 'D').
 *   - 수정 행(editedChanges): EditTracker 추적 셀 중 D_ 만 → 'M' (빈값→'0'→'D').
 *   - D_ 외(W_/M_/정적) 셀 제외 — W_/M_ 은 그리드 편집 시점에 D_ 로 전개됨(§2.4).
 *   음수 qty 차단은 검증 단계(dmf0045.validate)에서 수행 — 여기서는 형상 조립만.
 */
export const buildUnfoldRows = (params: {
  insertedRows: ShipmentRequestRow[];
  editedChanges: Map<ShipmentRequestRow, Record<string, unknown>>;
  divisionId: string;
}): SaveUnfoldRow[] => {
  const { insertedRows, editedChanges, divisionId } = params;
  const out: SaveUnfoldRow[] = [];

  const pushDayCell = (row: Rec, binding: string, rowFlag: 'I' | 'M'): void => {
    if (dynKindOf(binding) !== 'D') return; // D_ 셀만 저장 (§4.3)
    const qty = qtyOf(row[binding]);
    out.push({
      activeFlag: qty === '0' ? 'D' : rowFlag, // 값 '0' → 'D' 전환
      ...identityOf(row, divisionId),
      yyyymmdd: binding.slice(2), // 'D_' 제거 → yyyymmdd
      qty,
    });
  };

  // (1) 신규 행 — 값 존재 D_ 셀 전량
  for (const row of insertedRows) {
    const rec = row as Rec;
    for (const key of Object.keys(rec)) {
      if (dynKindOf(key) !== 'D') continue;
      const v = rec[key];
      if (v == null || v === '') continue; // 신규는 입력분만
      pushDayCell(rec, key, 'I');
    }
  }

  // (2) 수정 행 — EditTracker 변경 셀 중 D_ 만 (현재 값 전송 — 빈 셀 '0'→'D' 포함)
  for (const [row, changedBindings] of editedChanges) {
    if (row.CRUD_TYPE === 'I') continue; // 신규는 (1) 에서 처리
    const rec = row as Rec;
    for (const key of Object.keys(changedBindings)) {
      if (dynKindOf(key) !== 'D') continue;
      pushDayCell(rec, key, 'M');
    }
  }

  return out;
};

// SaveUnfoldRow[] → 13키 '^'delim payload (camelCase = SCM_ADM_PROC_M COL_NM).
//   P_CREATED_BY 는 BE 세션 자동주입이라 payload 미포함(GET 규약과 동일 — 확인필요: 최초 실저장 대조).
export const buildSavePayload = (rows: SaveUnfoldRow[]): Record<string, string> | null => {
  if (rows.length === 0) return null;
  const join = (sel: (r: SaveUnfoldRow) => string): string => rows.map(sel).join('^');
  return {
    activeFlag: join(r => r.activeFlag),
    divisionId: join(r => r.divisionId),
    itemId: join(r => r.itemId),
    fromSite: join(r => r.fromSite),
    toSite: join(r => r.toSite),
    projectCode: join(r => r.projectCode),
    incoterms: join(r => r.incoterms),
    fcstType: join(r => r.fcstType),
    transportMode: join(r => r.transportMode),
    bodId: join(r => r.bodId),
    measure: join(r => r.measure),
    yyyymmdd: join(r => r.yyyymmdd),
    qty: join(r => r.qty),
  };
};
