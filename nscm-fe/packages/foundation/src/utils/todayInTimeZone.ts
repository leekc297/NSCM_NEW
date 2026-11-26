import dayjs, { type Dayjs } from 'dayjs';

// 주의: dayjs utc/timezone 플러그인을 전역 extend 하지 않는다(2026-11-22 변경).
//   이 파일은 @foundation/utils 로 앱 전체에 로드돼, extend 하면 앱 dayjs 에 utc 플러그인이 항상 붙는다.
//   그러면 MUI AdapterDayjs 가 value.isUTC() 를 호출하기 시작하는데, @lges/design-system 이 번들에 따로
//   넣은 dayjs 사본(플러그인 없음)의 날짜가 넘어오면 'value.isUTC is not a function' 으로 화면이 깨진다
//   (달력 연도 선택 — DMF0003·DMF0048 등). 그래서 대상 존의 날짜는 브라우저 기본 Intl 로 계산한다.

/**
 * 사용자 타임존 코드(`UserSession.tmzCd` = `SCM_ADM_LOOKUP_MASTER_DETAIL.SEGMENT1`,
 *   `LOOKUP_TYPE='TIME_ZONE'`) → IANA 존.
 *
 * DB 실측(2026-11-19) — 등록 코드 4개 전수. 전부 표준 지역 존이고 offset·서머타임이 IANA 와 일치한다.
 *   서버 `FN_MULTY_TIME` 은 offset(ATTRIBUTE2)+서머타임 규칙(ATTRIBUTE3~11)을 같은 lookup 에서 읽어
 *   계산하는데, 이 4개는 표준 DST 라 IANA(dayjs-tz)로 같은 결과가 나온다
 *   (AM073=US 동부 3월 2주 일요일, EU042=CET 3월 마지막 주 일요일 — 둘 다 표준과 동일).
 *     AM073 US -5  DST   AS054 KR +9   AS055 CN +8   EU042 PL +1 DST
 */
const TMZ_TO_IANA: Record<string, string> = {
  AM073: 'America/New_York',
  AS054: 'Asia/Seoul',
  AS055: 'Asia/Shanghai',
  EU042: 'Europe/Warsaw',
};

/**
 * 사용자 타임존(`tmzCd`)의 **오늘** 을 플레인 로컬 `Dayjs`(그 달력일의 자정)로 돌려준다.
 *
 * 달력(PeriodRangePicker)의 Today·W 버튼·"오늘" 강조가 PC 시계가 아니라 사용자 타임존 기준으로 날짜를
 *   잡도록, 화면 최초 오픈 시 Period 기본값(서버 SP + FN_MULTY_TIME)과 같은 날짜를 FE 에서 재현한다.
 *   대상 존의 현재 달력일(YYYY-MM-DD)만 취해 플레인 로컬 Dayjs 로 재구성하므로, 달력 로직
 *   (`isSame(_, 'day')`, `startOf('isoWeek')`, `add`)과 타임존 오프셋 섞임 없이 일관되게 쓰인다.
 *
 * 매핑에 없는 코드(신규 등록)·빈 값은 브라우저 시계(`dayjs()`)로 폴백한다 — 종전 동작과 동일한
 *   graceful degradation(막지 않는다). 새 타임존이 추가되면 위 `TMZ_TO_IANA` 에 한 줄 더한다.
 */
export const todayInTimeZone = (tmzCd: string | undefined): Dayjs => {
  const zone = tmzCd ? TMZ_TO_IANA[tmzCd] : undefined;
  if (!zone) return dayjs();
  // Intl 로 대상 존의 현재 연·월·일만 뽑는다(서머타임 포함 — IANA 규칙은 브라우저가 적용).
  //   formatToParts 로 각 부분을 이름으로 꺼내 로케일별 구분자·순서 차이에 영향받지 않게 한다.
  const parts = new Intl.DateTimeFormat('en-US', {
    timeZone: zone,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  }).formatToParts(new Date());
  const part = (type: Intl.DateTimeFormatPartTypes) =>
    parts.find(p => p.type === type)?.value ?? '';
  const ymd = `${part('year')}-${part('month')}-${part('day')}`;
  const today = dayjs(ymd);
  // 혹시 Intl 이 존을 모르는 환경이면(구형 런타임) 종전 폴백과 같게 브라우저 시계로 돌아간다.
  return today.isValid() ? today : dayjs();
};
