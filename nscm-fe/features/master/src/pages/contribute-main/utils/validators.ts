import { VALIDATION_MSG } from '../contribute-main.constants';
import type { MainRow } from '../types';

export interface ValidationResult {
  ok: boolean;
  msgCode: string;
  /** 실패한 period (YYYYMM 또는 YYYY) — 알림에 "어느 달이 틀렸는지" 를 붙이기 위한 값 */
  period?: string;
  /** 실패한 period 의 실제 합계 */
  sum?: number;
}

// 동적 PIVOT 셀 key = `${tag}#${period}#${osCorpCd}` (예: `M#202601#RBU_0001`).
const parseCellKey = (key: string, tag: 'Y' | 'M'): { period: string; osCorpCd: string } | null => {
  if (!key.startsWith(`${tag}#`)) return null;
  const parts = key.split('#');
  if (parts.length !== 3) return null;
  return { period: parts[1], osCorpCd: parts[2] };
};

// RBU_0999 = 구분(문자) 컬럼 — 기여율 합계 대상이 아니다.
const isDivisionCode = (osCorpCd: string) => osCorpCd.indexOf('999') >= 0;

// AS-IS .cs ValidChk() L722~ — 각 row 의 동적 컬럼 합 = 100% 검증
//   - chkYear=true : 같은 row 의 Y# 셀들 (RBU_0999 제외) sum == 100 또는 0
//   - chkYear=false: 같은 row × 같은 YYYYMM 의 M# 셀들 (RBU_0999 제외) sum == 100 또는 0
//
// ⭐ 2026-08-11 — "한 달만 입력한 행이 합계 100 인데도 MSG00303 이 뜬다" 수정.
//   원인: 검증 대상 period 를 "값이 들어 있는 셀" 에서 모으고, 그 개수가 12 가 아니면 실패로
//   보던 구현(구 `sumByPeriod.size !== 12`). AS-IS 스프레드는 12개 월 컬럼이 늘 존재하고 빈 셀은
//   0 으로 읽혀 count 가 항상 12 였지만, TO-BE 는 SP 응답의 NULL 셀이 목록에서 통째로 빠져
//   1월만 채운 행은 size=1 → 무조건 실패였다.
//   → period 목록은 **값이 아니라 컬럼(key) 존재** 기준으로 뽑고, 빈 셀은 AS-IS 와 같이 0 으로
//     본다. 그러면 미입력 달은 sum 0 (허용) 으로 통과하므로 개수 검사 자체가 불필요해진다.
export const validChk = (rows: MainRow[], chkYear: boolean): ValidationResult => {
  const tag = chkYear ? 'Y' : 'M';

  // 검증 대상 period universe — 전체 행의 key 합집합 (그리드 동적 컬럼과 같은 방식).
  const periods = new Set<string>();
  for (const row of rows) {
    for (const key of Object.keys(row)) {
      const cell = parseCellKey(key, tag);
      if (cell && !isDivisionCode(cell.osCorpCd)) periods.add(cell.period);
    }
  }
  const orderedPeriods = [...periods].sort();

  for (const row of rows) {
    // 빈 셀 = 0 — 미입력 달은 합계 0 으로 통과한다 (AS-IS 와 동일).
    const sumByPeriod = new Map<string, number>(orderedPeriods.map(period => [period, 0]));
    for (const [key, value] of Object.entries(row)) {
      const cell = parseCellKey(key, tag);
      if (!cell || isDivisionCode(cell.osCorpCd)) continue;
      if (!sumByPeriod.has(cell.period)) continue;
      const n = Number(value);
      if (value == null || value === '' || Number.isNaN(n)) continue;
      sumByPeriod.set(cell.period, (sumByPeriod.get(cell.period) ?? 0) + n);
    }

    for (const [period, sum] of sumByPeriod) {
      if (Math.abs(sum - 100) > 0.001 && Math.abs(sum) > 0.001) {
        return { ok: false, msgCode: VALIDATION_MSG.RATIO_OUT_OF_RANGE, period, sum };
      }
    }
  }
  return { ok: true, msgCode: '' };
};

// 알림 문구용 — 'YYYYMM' → 'YYYY-MM' (그리드 헤더 라벨과 같은 표기), 'YYYY' 는 그대로.
export const formatPeriodLabel = (period: string) =>
  period.length === 6 ? `${period.slice(0, 4)}-${period.slice(4)}` : period;

// AS-IS .cs ValidChk2() L816~ 1:1 매핑 — 셀에 값이 있는데 같은 period 의 RBU_0999 가 비어 있으면 false
//   (구분값 미입력 차단)
export const validChk2 = (rows: MainRow[], chkYear: boolean): { ok: boolean; msgCode: string } => {
  const tag = chkYear ? 'Y' : 'M';
  for (const row of rows) {
    for (const [k, v] of Object.entries(row)) {
      if (!k.startsWith(`${tag}#`)) continue;
      const parts = k.split('#');
      if (parts.length !== 3) continue;
      const [, period, osCorpCd] = parts;
      if (osCorpCd.indexOf('999') >= 0) continue; // RBU_0999 자체는 검사 대상 X (다른 셀의 동반)
      if (v == null || v === '') continue;
      // 같은 period 의 RBU_0999 셀 값 확인
      const conTypeKey = `${tag}#${period}#RBU_0999`;
      const conType = (row as Record<string, unknown>)[conTypeKey];
      if (conType == null || conType === '') {
        return { ok: false, msgCode: VALIDATION_MSG.REQUIRED_DIVISION };
      }
    }
  }
  return { ok: true, msgCode: '' };
};

// AS-IS .cs FindData — 버전 필수 선택
export const findDataGuard = (verSeq: string): { ok: boolean; msgCode: string } => {
  if (!verSeq) return { ok: false, msgCode: VALIDATION_MSG.VERSION_REQUIRED };
  return { ok: true, msgCode: '' };
};
