import { DIVISION_40, MEASURE_PAIR } from '../demand-manager.constants';
import type { DemandManagerRow, SaveOrderRow } from '../demand-manager.types';
import { validateNewRowPairs, validateSaveRow, type ValidateResult } from './demand-manager.validate';

export interface BuildSaveResult {
  rows: SaveOrderRow[];
  error?: ValidateResult;
}

const AMT_MEASURE = MEASURE_PAIR[1].code; // 'SalesAmt_KRW'
const QTY_MEASURE = MEASURE_PAIR[0].code; // 'MEA_1'

/**
 * 저장할 Measure 코드를 정한다.
 * AS-IS 규칙: 금액 축(MEASURE2 가 SalesAmt_KRW)이 아니면 언제나 MEA_1 로 기록한다.
 * 첫 번째 Measure 는 화면 표시명이 계열마다 달라도 저장값은 MEA_1 로 고정해야 가변 해석이 가능하다.
 */
const resolveMeasure = (row: DemandManagerRow): string => {
  const m2 = String(row.MEASURE2 ?? '').trim();
  if (m2 === AMT_MEASURE) return AMT_MEASURE;
  if (row.CRUD_TYPE === 'I') {
    // 신규 세트는 화면이 부여한 값(MEA_1 / SalesAmt_KRW)을 그대로 쓴다
    const m = String(row.MEASURE ?? '').trim();
    return m === AMT_MEASURE ? AMT_MEASURE : QTY_MEASURE;
  }
  return QTY_MEASURE;
};

const digitsOnly = (v: unknown): string => String(v ?? '').replace(/,/g, '').trim();

/**
 * 행 고유 키 생성.
 * ⭐ 신규 행에도 반드시 값이 있어야 한다 — 저장 프로시저의 기간 중첩 검사가
 *    "자기 자신을 제외" 하려고 이 키를 비교하는데, 비어 있으면 비교가 성립하지 않아
 *    중첩 검사가 통째로 건너뛰어진다 (AS-IS 도 신규 행에 새 키를 만들어 넣었다).
 */
export const newRowKey = (): string => {
  const c = globalThis.crypto as { randomUUID?: () => string } | undefined;
  if (typeof c?.randomUUID === 'function') return c.randomUUID();
  return `${Date.now().toString(16)}-${Math.floor(Math.random() * 0xffffffff).toString(16)}`;
};

/** 신규 세트에 부여할 그룹 키 — 화면에서 만든 임시 그룹 아이디를 그대로 쓴다(같은 세트는 같은 값) */
const resolveGroupKey = (row: DemandManagerRow): string =>
  String(row.KEYVALUE2 ?? row.INSERT_GROUP_ID ?? '').trim();

/**
 * 변경·신규 행을 저장 payload 로 만든다.
 * 행 단위 검증에서 하나라도 걸리면 즉시 중단하고 오류를 돌려준다(AS-IS 파리티 — 부분 저장 없음).
 */
export const buildSaveRows = (targets: DemandManagerRow[]): BuildSaveResult => {
  const rows: SaveOrderRow[] = [];
  for (const row of targets) {
    const v = validateSaveRow(row);
    if (!v.ok) return { rows: [], error: v };
    rows.push({
      DIVISION_ID: DIVISION_40,
      PROJECT_CODE: String(row.PROJECT_NAME ?? '').trim(),
      YYYYMM_FROM: String(row.ORDERSTART ?? '').trim(),
      YYYYMM_TO: String(row.ORDEREND ?? '').trim(),
      MEASURE: resolveMeasure(row),
      ORDER_APPROVAL: digitsOnly(row.ORDERAPPROVAL),
      ORDER_NOW: digitsOnly(row.ORDERNOW),
      // 기존 행은 자기 키를 그대로, 신규 행은 화면에서 만든 새 키를 보낸다(중첩 검사 성립 조건)
      ATTRIBUTE1:
        row.CRUD_TYPE === 'I'
          ? String(row.KEYVALUE ?? '').trim() || newRowKey()
          : String(row.KEYVALUE ?? '').trim(),
      ATTRIBUTE2: resolveGroupKey(row),
    });
  }
  const pair = validateNewRowPairs(targets);
  if (!pair.ok) return { rows: [], error: pair };
  return { rows };
};

/** 삭제 대상 그룹 키 목록 — 같은 그룹은 한 번만 보낸다(SP 가 그룹 단위로 지운다) */
export const collectDeleteGroupKeys = (rows: DemandManagerRow[]): string[] => {
  const keys = new Set<string>();
  rows.forEach(r => {
    const k = String(r.KEYVALUE2 ?? '').trim();
    if (k) keys.add(k);
  });
  return [...keys];
};
