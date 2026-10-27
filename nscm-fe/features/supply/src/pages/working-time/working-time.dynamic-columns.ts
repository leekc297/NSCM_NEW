import dayjs from '@foundation/dayjs';

import type { DynColumnMeta, DynDayColumn } from './working-time.types';

// GET SP O_RC1 데이터 커서 컬럼 중 동적 기간 컬럼만 골라 2단 헤더 파생물을 만든다.
//   근거(04_impl-gap-audit #1): SP 는 SUM(CASE WHEN YYYYMMDD='D_yyyymmdd' THEN QTY END) AS D_yyyymmdd
//   로 일자마다 칸을 만든다. 이 SP 에 타이틀-메타 커서가 없어 요일(그룹 span)은 커서가 주지 않으므로
//   yyyymmdd 로 클라이언트에서 계산한다(SP "칸 펼치기" 주석과 동일하게 캘린더 파생).
//   o_rc1_columns 는 BE ResultSetMetaData 사이드카({name,type}) — SELECT 순서를 보존하므로 재정렬 불필요.

// 동적 컬럼 alias 규칙 — SP 가 'D_' || BASIS_YYYYMMDD 로 만든다(D_ + 8자리). 정적 14컬럼과 구분.
const DAY_COLUMN_PATTERN = /^D_(\d{8})$/;

// 요일 3글자(월~일) — SP 데이터가 캘린더(SCM_SYS_CALENDAR_M) 기반이므로 로컬 파싱으로 재현한다.
//   dayjs().day(): 0=일 ~ 6=토. formatItem 일자 leaf 색(SAT=blue/SUN=red)이 이 라벨을 읽는다.
const WEEKDAY_LABEL = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'] as const;

// ISO-8601 주차(월요일 시작) — AS-IS 소분류 라벨(W42 등)은 SCM_SYS_CALENDAR_M 주차지만 GET SP 가
//   타이틀 커서를 주지 않아(03_grid §6 #1) yyyymmdd 로 ISO 주차를 재현한다. 해당 주 목요일 기준 표준
//   알고리즘 — 플러그인 미등록 환경(@foundation/dayjs 순수 재export)이라 dayjs().isoWeek() 대신 직접 계산.
const isoWeekNumber = (yyyy: number, mm: number, dd: number): number => {
  const d = new Date(Date.UTC(yyyy, mm - 1, dd));
  d.setUTCDate(d.getUTCDate() - ((d.getUTCDay() + 6) % 7) + 3); // 해당 주의 목요일로 이동(ISO 기준점)
  const firstThursday = new Date(Date.UTC(d.getUTCFullYear(), 0, 4)); // 1월 4일이 속한 주 = ISO 1주차
  firstThursday.setUTCDate(firstThursday.getUTCDate() - ((firstThursday.getUTCDay() + 6) % 7) + 3);
  return 1 + Math.round((d.getTime() - firstThursday.getTime()) / (7 * 86400000));
};

export const buildDynDayColumns = (columnMeta: DynColumnMeta[]): DynDayColumn[] => {
  const out: DynDayColumn[] = [];
  for (const col of columnMeta) {
    const match = DAY_COLUMN_PATTERN.exec(col.name ?? '');
    if (!match) continue;
    const yyyymmdd = match[1];
    // customParseFormat plugin 미등록 환경 — 하이픈 ISO 로 변환해 파싱한다(VersionModal §67 /
    //   ForecastPriceGrid:1540 동일 규약). dayjs(str,'YYYYMMDD') 는 이 리포에서 동작하지 않는다.
    const iso = `${yyyymmdd.slice(0, 4)}-${yyyymmdd.slice(4, 6)}-${yyyymmdd.slice(6, 8)}`;
    const d = dayjs(iso);
    // 파싱 불가(비정상 alias)면 건너뛴다 — 단정 금지, 미발견 처리.
    if (!d.isValid()) continue;
    const yyyy = Number(yyyymmdd.slice(0, 4));
    const mm = Number(yyyymmdd.slice(4, 6));
    const dd = Number(yyyymmdd.slice(6, 8));
    out.push({
      binding: col.name,
      yyyymmdd,
      dayLabel: String(d.date()), // 일(DD, 앞 0 제거) — leaf(3단) 헤더
      weekday: WEEKDAY_LABEL[d.day()], // 요일 3글자 — 일자 leaf 색상 키
      monthLabel: `${yyyymmdd.slice(0, 4)}-${yyyymmdd.slice(4, 6)}`, // 대분류(1단) = 연-월
      weekLabel: `W${isoWeekNumber(yyyy, mm, dd)}`, // 소분류(2단) = 주차
    });
  }
  // 날짜순 정렬 — 행 키에서 파생하면(deriveDayColumnMeta) JSON 키 순서가 캘린더 순이 아닐 수 있다.
  //   사이드카 경로는 이미 정렬돼 있어 영향 없음(yyyymmdd 8자리 문자열 비교 = 연대순).
  out.sort((a, b) => a.yyyymmdd.localeCompare(b.yyyymmdd));
  return out;
};

// 표준 call-proc 응답에는 o_rc1_columns 사이드카가 없다 — 그 사이드카는 DynamicQuery 경로 전용이라
//   이 화면(표준 call-proc)에는 오지 않는다. 그래서 데이터 행(o_rc1)의 키에서 D_yyyymmdd 컬럼명을
//   직접 수집해 컬럼 메타를 파생한다.
//   필수: 첫 행만 보면 안 된다 — 근무시간 데이터가 없는 행은 pivot(SUM(CASE...)) 결과가 전부 null 이라
//   BE 가 그 D_ 키를 JSON 에서 생략한다(div 82 실측: C1P13 등 앞쪽 OSP 행에 D_ 키 전무, 뒤쪽 PLS01 행에만
//   기간 전체 날짜). 첫 행에 데이터가 없으면 날짜 컬럼이 0개가 되어 "뒤 날짜가 안 나옴"이 된다. 그래서 전체
//   행에서 D_yyyymmdd 키의 합집합을 모은다 — SP 는 데이터 있는 행에 기간 전체 날짜를 주므로 합집합이 완전한
//   컬럼 집합이 되고, buildDynDayColumns 가 yyyymmdd 로 정렬한다.
export const deriveDayColumnMeta = (rows: Array<Record<string, unknown>>): DynColumnMeta[] => {
  const names = new Set<string>();
  for (const row of rows) {
    if (!row) continue;
    for (const name of Object.keys(row)) {
      if (DAY_COLUMN_PATTERN.test(name)) names.add(name);
    }
  }
  return Array.from(names, (name) => ({ name, type: '' }));
};

// 조회 기간 전체 날짜의 D_yyyymmdd 메타. 데이터 없는 날도 입력할 수 있게 칸을 만든다(AS-IS 캘린더 기준 파리티).
export const buildPeriodDayColumnMeta = (from: string, to: string): DynColumnMeta[] => {
  if (!/^\d{8}$/.test(from) || !/^\d{8}$/.test(to) || from > to) return [];
  const toIso = (s: string) => `${s.slice(0, 4)}-${s.slice(4, 6)}-${s.slice(6, 8)}`;
  const end = dayjs(toIso(to));
  const out: DynColumnMeta[] = [];
  for (let d = dayjs(toIso(from)); d.isValid() && !d.isAfter(end, 'day'); d = d.add(1, 'day')) {
    out.push({ name: `D_${d.format('YYYYMMDD')}`, type: '' });
  }
  return out;
};
