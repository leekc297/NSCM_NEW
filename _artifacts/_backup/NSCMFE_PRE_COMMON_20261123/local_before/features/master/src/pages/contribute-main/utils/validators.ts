import { VALIDATION_MSG } from '../contribute-main.constants';
import type { MainRow } from '../types';

export interface ValidationResult {
  ok: boolean;
  msgCode: string;
  /** 실패한 period (YYYYMM 또는 YYYY) — 알림에 "어느 달이 틀렸는지" 를 붙이기 위한 값 */
  period?: string;
  /** 실패한 period 의 실제 합계 */
  sum?: number;
  /** 월별 모드 12개월 검사 실패 시 — 수정 행에서 값이 있는 달 수 */
  monthCount?: number;
}

/** AS-IS ValidChk L767 `ValidChkCol.Count != 12` — 월별 모드 수정 행은 12개월 전부 값이 있어야 저장한다. */
const MONTHS_PER_YEAR = 12;

// 동적 PIVOT 셀 key = `${tag}#${period}#${osCorpCd}` (예: `M#202601#RBU_0001`).
const parseCellKey = (key: string, tag: 'Y' | 'M'): { period: string; osCorpCd: string } | null => {
  if (!key.startsWith(`${tag}#`)) return null;
  const parts = key.split('#');
  if (parts.length !== 3) return null;
  return { period: parts[1], osCorpCd: parts[2] };
};

// RBU_0999 = 구분(문자) 컬럼 — 기여율 합계 대상이 아니다.
const isDivisionCode = (osCorpCd: string) => osCorpCd.indexOf('999') >= 0;

// 행에서 값이 있는 period 수 — AS-IS ValidChkCol(빈 칸 continue, 구분(999) 제외) 과 같은 기준.
const countPeriodsWithValue = (row: MainRow, tag: 'Y' | 'M'): number => {
  const periods = new Set<string>();
  for (const [key, value] of Object.entries(row)) {
    const cell = parseCellKey(key, tag);
    if (!cell || isDivisionCode(cell.osCorpCd)) continue;
    if (value == null || value === '' || Number.isNaN(Number(value))) continue;
    periods.add(cell.period);
  }
  return periods.size;
};

// AS-IS .cs ValidChk() L722~ — 각 row 의 동적 컬럼 합 = 100% 검증
//   - chkYear=true : 같은 row 의 Y# 셀들 (RBU_0999 제외) sum == 100 또는 0
//   - chkYear=false: 같은 row × 같은 YYYYMM 의 M# 셀들 (RBU_0999 제외) sum == 100 또는 0
//
//   - chkYear=false 추가 조건: 수정 행에서 값이 있는 달 수 == 12 (AS-IS L767 `ValidChkCol.Count != 12` → 실패)
//
// 이력:
//   2026-08-11 — "한 달만 입력한 행이 합계 100 인데도 MSG00303 이 뜬다" 지적으로 12개월 개수 검사를 없앴다.
//     당시 근거는 "AS-IS 스프레드는 빈 셀을 0 으로 읽어 count 가 항상 12" 였다.
//   2026-10-16 — 갭분석(월별 저장 검사, 12개월 전부 입력 요구 폐지)으로 개수 검사를 AS-IS 와 같게 복원.
//     AS-IS ValidChk 월 모드(.cs L726~771)는 `String.IsNullOrEmpty(GetText)==true` 인 빈 칸을 continue 로
//     건너뛰므로 ValidChkCol 에는 값이 있는 달만 쌓이고, 그 수가 12 가 아니면 실패다. 즉 AS-IS 는 한 달만 입력한
//     행을 저장하지 못하게 막는 것이 설계이고 2026-08-11 의 전제(빈 칸=0)는 실제 동작과 달랐다.
//     폐지 요청 PI 와 DM 업무 결정 기록이 없어 AS-IS 파리티를 따른다. 폐지로 결정되면 PI 번호를 적고 아래
//     monthCount 검사만 걷어낸다.
//   period 합계 검사는 2026-08-11 방식(컬럼 존재 기준 period, 빈 칸 0)을 유지한다. 편집으로 지운 칸은 그리드가
//     '0' 으로 채우므로(emptyCellAsZero) AS-IS 와 같이 "값이 있는 달" 로 센다.
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

    // 월별 모드 — 값이 있는 달 수 != 12 이면 실패 (AS-IS L767). 메시지는 합계 검사와 같은 MSG01306.
    if (!chkYear) {
      const monthCount = countPeriodsWithValue(row, tag);
      if (monthCount !== MONTHS_PER_YEAR) {
        return { ok: false, msgCode: VALIDATION_MSG.RATIO_OUT_OF_RANGE, monthCount };
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
