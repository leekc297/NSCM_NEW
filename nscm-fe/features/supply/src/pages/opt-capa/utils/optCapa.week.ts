import dayjs from '@foundation/dayjs';
import isoWeek from '@foundation/isoWeek';

// ISO-8601 주차 — No Work(Week) 모드의 WEEK_NAME 포맷이 SCM_SYS_CALENDAR_M.ISO_YYYYWW(ISO 표준)에
//   맞춰져 있어 dayjs isoWeek 플러그인을 쓴다(선례 forecast-price·capa-mobility-it 동일 패턴).
dayjs.extend(isoWeek);

const pad2 = (n: number): string => String(n).padStart(2, '0');

/**
 * ISO 주차 표시 라벨 '2026-W40' — No Work(Week) `WEEK_NAME` 컬럼 표시값.
 * GET SP 표시식 `SUBSTR(B.ISO_YYYYWW,1,4) || '-' || B.WEEK_NAME`(PKG_SCP0126 BODY:802-803,
 * `SCM_SYS_CALENDAR_M` 실측: ISO_YYYYWW '202640' / WEEK_NAME 'W40' → '2026-W40')와 동일.
 */
const weekLabelOf = (d: ReturnType<typeof dayjs>): string =>
  `${d.isoWeekYear()}-W${pad2(d.isoWeek())}`;

/** 날짜(YYYY-MM-DD) → ISO 주차 표시 라벨 — Week 칸 달력 팝업 반환값. */
export const weekLabelOfDate = (date: string): string => {
  const parsed = dayjs(date);
  return parsed.isValid() ? weekLabelOf(parsed) : '';
};

/**
 * 표시 라벨 '2026-W40' → 저장 키 ISO_YYYYWW '202640'(= '-W' 제거).
 * SAVE SP 는 `WHERE ISO_YYYYWW = V_WEEK_NAME`(PKG_SCP0126 BODY:3761) 로 조회하므로, 저장 payload
 * 의 `weekName` 은 표시 라벨이 아니라 이 키로 보내야 한다(Phase 2 Week 저장 라우팅에서 사용).
 */
export const weekNameToIsoYyyyww = (label: string): string => label.replace('-W', '');
