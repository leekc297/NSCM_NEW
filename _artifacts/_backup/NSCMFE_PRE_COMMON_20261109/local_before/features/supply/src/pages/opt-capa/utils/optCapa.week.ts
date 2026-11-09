import dayjs from '@foundation/dayjs';
import isoWeek from '@foundation/isoWeek';

// ISO-8601 주차 — No Work(Week) 모드의 WEEK_NAME 포맷이 SCM_SYS_CALENDAR_M.ISO_YYYYWW(ISO 표준)에
//   맞춰져 있어 dayjs isoWeek 플러그인을 쓴다(선례 forecast-price·capa-mobility-it 동일 패턴).
dayjs.extend(isoWeek);

const pad2 = (n: number): string => String(n).padStart(2, '0');

const monthFirstDay = (yyyymm: string) =>
  dayjs(`${yyyymm.slice(0, 4)}-${yyyymm.slice(4, 6)}-01`);

/**
 * ISO 주차 표시 라벨 '2026-W40' — No Work(Week) `WEEK_NAME` 컬럼 표시값.
 * GET SP 표시식 `SUBSTR(B.ISO_YYYYWW,1,4) || '-' || B.WEEK_NAME`(PKG_SCP0126 BODY:802-803,
 * `SCM_SYS_CALENDAR_M` 실측: ISO_YYYYWW '202640' / WEEK_NAME 'W40' → '2026-W40')와 동일.
 */
const weekLabelOf = (d: ReturnType<typeof dayjs>): string =>
  `${d.isoWeekYear()}-W${pad2(d.isoWeek())}`;

/**
 * 표시 라벨 '2026-W40' → 저장 키 ISO_YYYYWW '202640'(= '-W' 제거).
 * SAVE SP 는 `WHERE ISO_YYYYWW = V_WEEK_NAME`(PKG_SCP0126 BODY:3761) 로 조회하므로, 저장 payload
 * 의 `weekName` 은 표시 라벨이 아니라 이 키로 보내야 한다(Phase 2 Week 저장 라우팅에서 사용).
 */
export const weekNameToIsoYyyyww = (label: string): string => label.replace('-W', '');

/**
 * 조회 Period(`YYYYMM`~`YYYYMM`)가 걸치는 ISO 주차 라벨 후보 — Week 모드 `WEEK_NAME` 셀 콤보 후보.
 * 시작월 1일이 속한 ISO 주 시작 ~ 종료월 말일이 속한 ISO 주 끝까지 1주씩 전진하며 중복 없이 모은다.
 */
export const buildWeekCandidates = (fromYyyymm: string, toYyyymm: string): string[] => {
  if (!/^\d{6}$/.test(fromYyyymm) || !/^\d{6}$/.test(toYyyymm)) return [];
  const end = monthFirstDay(toYyyymm).endOf('month').endOf('isoWeek');
  const seen = new Set<string>();
  const out: string[] = [];
  let cur = monthFirstDay(fromYyyymm).startOf('isoWeek');
  // 무한루프 방지 상한(기간 수년 가정 — 520주 ≈ 10년).
  for (let guard = 0; guard < 520 && !cur.isAfter(end, 'day'); guard += 1) {
    const label = weekLabelOf(cur);
    if (!seen.has(label)) {
      seen.add(label);
      out.push(label);
    }
    cur = cur.add(1, 'week');
  }
  return out;
};
