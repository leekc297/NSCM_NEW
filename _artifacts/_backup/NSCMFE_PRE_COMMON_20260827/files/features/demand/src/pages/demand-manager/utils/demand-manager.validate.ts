import { MSG } from '../demand-manager.constants';
import type { DemandManagerRow } from '../demand-manager.types';

export interface ValidateResult {
  ok: boolean;
  msgId?: string;
  param?: string;
}

const OK: ValidateResult = { ok: true };
const isYm = (s: string): boolean => /^\d{6}$/.test(s);

/** yyyyMM 을 실제 달력상 유효한 월로 볼 수 있는지 (AS-IS 는 날짜 파싱 실패로 판정) */
const isValidYm = (s: string): boolean => {
  if (!isYm(s)) return false;
  const m = Number(s.slice(4, 6));
  return m >= 1 && m <= 12;
};

// AS-IS 의 그룹명 비교 게이트(viewAuth)는 이관하지 않는다.
//   세션에 그룹 ID 가 없고(groupId 는 빈 값) groups 는 표시명이라 화면에서 비교할 수 없으며,
//   TO-BE 는 버튼 권한(MNU_BTN 권한)과 행의 EDIT_YN 으로 판정한다.

/** F5 조회 — 버전 필수 → 기간 필수 → 기간 형식 → 기간 대소 (AS-IS FindData 순서 그대로) */
export const validateFind = (
  versionNo: string,
  periodFrom: string,
  periodTo: string
): ValidateResult => {
  if (!versionNo) return { ok: false, msgId: MSG.VERSION_REQUIRED };
  if (!periodFrom || !periodTo) return { ok: false, msgId: MSG.REQUIRED_FIELD, param: 'Period' };
  if (!isValidYm(periodFrom) || !isValidYm(periodTo)) return { ok: false, msgId: MSG.INVALID_DATE };
  if (periodFrom > periodTo) return { ok: false, msgId: MSG.PERIOD_ORDER };
  return OK;
};

/** 저장 대상 1행 검증 — 하나라도 어긋나면 저장 전체를 중단한다 (AS-IS SaveData 파리티) */
export const validateSaveRow = (row: DemandManagerRow): ValidateResult => {
  const from = String(row.ORDERSTART ?? '').trim();
  const to = String(row.ORDEREND ?? '').trim();
  const project = String(row.PROJECT_NAME ?? '').trim();
  const measure = String(row.MEASURE ?? '').trim();
  const approval = String(row.ORDERAPPROVAL ?? '').trim();
  const now = String(row.ORDERNOW ?? '').trim();

  if (!from || !to) return { ok: false, msgId: MSG.REQUIRED_FIELD, param: 'Period' };
  if (!project) return { ok: false, msgId: MSG.REQUIRED_FIELD, param: 'Project' };
  if (!measure) return { ok: false, msgId: MSG.REQUIRED_FIELD, param: 'Measure' };
  if (!approval || !now) return { ok: false, msgId: MSG.POSITIVE_INT };

  const intPart = (v: string): number => Number(v.replace(/,/g, '').split('.')[0]);
  if (!Number.isFinite(intPart(approval)) || !Number.isFinite(intPart(now))) {
    return { ok: false, msgId: MSG.POSITIVE_INT };
  }
  if (intPart(approval) <= 0 || intPart(now) <= 0) return { ok: false, msgId: MSG.POSITIVE_INT };

  if (!isValidYm(from) || !isValidYm(to)) return { ok: false, msgId: MSG.INVALID_DATE };
  if (from > to) return { ok: false, msgId: MSG.PERIOD_ORDER };
  return OK;
};

/**
 * 신규 행 짝 검증 — 그룹 키가 아직 없는 행들을 (Project, 시작월, 종료월) 로 묶어
 * 2행이 되지 않는 묶음이 하나라도 있으면 막는다 (AS-IS: 신규는 반드시 쌍).
 */
export const validateNewRowPairs = (rows: DemandManagerRow[]): ValidateResult => {
  const groups = new Map<string, number>();
  rows
    .filter(r => !String(r.KEYVALUE2 ?? '').trim())
    .forEach(r => {
      const key = [
        String(r.PROJECT_NAME ?? ''),
        String(r.ORDERSTART ?? ''),
        String(r.ORDEREND ?? ''),
      ].join('');
      groups.set(key, (groups.get(key) ?? 0) + 1);
    });
  for (const cnt of groups.values()) {
    if (cnt < 2) return { ok: false, msgId: MSG.REQUIRED_COLUMN };
  }
  return OK;
};
