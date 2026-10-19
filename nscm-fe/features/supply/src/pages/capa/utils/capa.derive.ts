import { CAL_LOSS_CODES } from '../capa.constants';
import type { CapaRow } from '../capa.types';

/**
 * 파생 재계산(03 §3 V — Set_Calculator 산식표, cs:1562~1721).
 *
 * 칼럼(기간칼럼 binding) 단위로 행을 위→아래 순회하며 손실행을 누적하고, 계산행(arrayCalLoss 7종)의
 * 셀을 산식으로 덮어쓴다. XA001 행에서 누적 리셋(블록 경계). D_ 칼럼은 파생 제외(cs:1589) —
 * M_/Y_/BEF 칼럼만 재계산. AS-IS 등가 클라 즉시 재계산(저장 후 재조회 없음).
 *
 * 주의(정직 보고): 산식은 design 03 §3 실측 표를 그대로 옮겼으나, 다중 블록·소수 자리·엣지값의
 * 런타임 수치 파리티는 브라우저/데이터 축에서 확인해야 한다(04 리포트 "미확인").
 */

const NON_OP = new Set(['EL001', 'EL002']);
const NO_LOAD = new Set(['EL003', 'EL004', 'EL005', 'EL006', 'EL007', 'EL008']);
const NO_RUN = new Set([
  'EL009',
  'EL010',
  'EL011',
  'EL012',
  'EL013',
  'EL014',
  'EL015',
  'EL016',
  'EL017',
  'EL018',
  'EL019',
  'EL020',
  'EL021',
  'EL022',
  'EL023',
  'EL024',
]);
const PM_CODE = 'EL011';
const CAL_SET = new Set<string>(CAL_LOSS_CODES);

const num = (v: unknown): number => {
  // 문자/숫자만 파싱(객체는 '[object Object]' 문자화 방지 — no-base-to-string). 그 외 = 0(기존 NaN→0 동일).
  if (typeof v !== 'string' && typeof v !== 'number') return 0;
  const n = Number(String(v).replace(/,/g, ''));
  return Number.isFinite(n) ? n : 0;
};
const round2 = (n: number): number => Math.round(n * 100) / 100;

interface Acc {
  a: number; // XA001 × 1440
  nonOp: number;
  noLoad: number;
  noRunNotPm: number; // No-Run 16종 − EL011 (값 그대로)
  pm: number; // EL011
  m10: number;
  m12: number;
}

const emptyAcc = (): Acc => ({ a: 0, nonOp: 0, noLoad: 0, noRunNotPm: 0, pm: 0, m10: 0, m12: 0 });

const computeCalc = (loss: string, acc: Acc): number => {
  const aSafe = acc.a === 0 ? 1 : acc.a;
  const loadTime = round2(acc.a - (acc.nonOp + acc.noLoad));
  const loadSafe = loadTime === 0 ? 1 : loadTime;
  const availSafe = acc.a - acc.nonOp === 0 ? 1 : acc.a - acc.nonOp;
  switch (loss) {
    case 'XB020': // Available
      return acc.a - acc.nonOp;
    case 'XB021': // Available(%)
      return round2(((acc.a - acc.nonOp) / aSafe) * 100);
    case 'XC041': // Loading
      return loadTime;
    case 'XC042': // Loading(%)
      return round2((loadTime / availSafe) * 100);
    case 'XE500': // Operating
      return (acc.a - acc.nonOp - acc.noLoad) * (1 - acc.noRunNotPm / 100) - acc.pm;
    case 'M08': // Operating(%) — round 없음(Report 정합 cs:1706)
      return 100 - (acc.noRunNotPm + (acc.pm / loadSafe) * 100);
    case 'XD101': // OEE(%)
      return round2((computeCalc('M08', acc) * acc.m10 * acc.m12) / 10000);
    default:
      return 0;
  }
};

/** 한 기간칼럼(binding)에 대해 계산행 셀을 재계산해 mutate. D_ 칼럼은 호출측에서 제외. */
export const recalcColumn = (rows: CapaRow[], binding: string): void => {
  let acc = emptyAcc();
  for (const row of rows) {
    const loss = String(row.LOSS_CODE ?? '');
    if (loss === 'XA001') {
      acc = emptyAcc();
      acc.a = num(row[binding]) * 1440;
      continue;
    }
    if (NON_OP.has(loss)) acc.nonOp += num(row[binding]);
    else if (NO_LOAD.has(loss)) acc.noLoad += num(row[binding]);
    else if (NO_RUN.has(loss)) {
      if (loss === PM_CODE) acc.pm += num(row[binding]);
      else acc.noRunNotPm += num(row[binding]);
    } else if (loss === 'M10') acc.m10 = num(row[binding]);
    else if (loss === 'M12') acc.m12 = num(row[binding]);

    if (CAL_SET.has(loss)) row[binding] = String(computeCalc(loss, acc));
  }
};

/** M_/Y_ 칼럼 전건 재계산(D_ 제외) — 조회 직후·셀 편집 후 호출(cs:924). */
export const recalcAll = (rows: CapaRow[], periodBindings: string[]): void => {
  for (const b of periodBindings) {
    if (b.startsWith('D_')) continue;
    recalcColumn(rows, b);
  }
};

/**
 * Best/Worst 재산출(03 §3 V10 — Set_CalculatorBestWorst cs:1723~1798).
 * 계산행의 BEF_M6~M1 중 값>0 이며 헤더월 ≥ From월 인 값들의 Max/Min 을 BEF_BEST/WORST 에 채운다.
 *
 * GAP-08 해소: BEF_Mk binding 은 그 자체로 월(yyyymm)이 아니므로(리터럴 'BEF_M6'), 헤더월 비교가
 *   사문화됐었다. 호출측이 각 binding → 실제 yyyymm(당월-k) 매핑을 넘겨 정상 비교한다.
 */
export const recalcBestWorst = (
  rows: CapaRow[],
  befMonthYyyymm: Readonly<Record<string, string>>,
  fromYyyymm: string
): void => {
  const entries = Object.entries(befMonthYyyymm);
  for (const row of rows) {
    if (!CAL_SET.has(String(row.LOSS_CODE ?? ''))) continue;
    const vals = entries
      .map(([binding, ym]) => ({ ym, v: num(row[binding]) }))
      .filter(x => x.v > 0 && x.ym >= fromYyyymm)
      .map(x => x.v);
    if (vals.length === 0) continue;
    row.BEF_BEST = String(Math.max(...vals));
    row.BEF_WORST = String(Math.min(...vals));
  }
};
