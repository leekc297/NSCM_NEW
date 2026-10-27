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
//   dayjs().day(): 0=일 ~ 6=토. formatItem 헤더 색(SAT=blue/SUN=red)이 이 라벨을 읽는다.
const WEEKDAY_LABEL = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'] as const;

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
    out.push({
      binding: col.name,
      yyyymmdd,
      dayLabel: String(d.date()), // 일(DD, 앞 0 제거) — leaf 헤더
      weekday: WEEKDAY_LABEL[d.day()], // 요일 3글자 — 상단 그룹 span 키
    });
  }
  return out;
};
