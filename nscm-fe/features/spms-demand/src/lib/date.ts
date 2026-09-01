// SDM 공통 — 커서 날짜 값 순수함수 (project-list/project-master validate 사본 통합.
//   defaultRegCompRange·validateSearch 는 화면별 SP 계약이 달라 각 validate 에 남긴다)
import dayjs from '@foundation/dayjs';

import { toText } from './call-proc';

// yyyymmdd 판별 / dayjs 변환 (조회조건 저장 포맷)
export const isYmd = (s: string): boolean => /^\d{8}$/.test(s);
export const ymdToDay = (s: string): dayjs.Dayjs =>
  dayjs(`${s.slice(0, 4)}-${s.slice(4, 6)}-${s.slice(6, 8)}`);

// 임의 날짜 표현(YYYYMMDD / ISO 직렬화 / wijmo 에디터 표시 포맷 'M/D/YYYY' 실측 / Date) → dayjs
export const parseAnyDate = (v: unknown): dayjs.Dayjs | null => {
  if (v == null || v === '') return null;
  if (v instanceof Date) return dayjs(v);
  const s = toText(v).trim();
  if (s === '') return null;
  const d = isYmd(s) ? ymdToDay(s) : dayjs(s);
  if (d.isValid()) return d;
  const fallback = dayjs(new Date(s)); // 'M/D/YYYY' 등 로캘 문자열 — Date 파서 폴백
  return fallback.isValid() ? fallback : null;
};

// ⭐ 그리드 날짜 표시 — DATE 원형(ISO 직렬화) 커서 컬럼(FPDate* 메타) → 'YYYY.MM.DD'
//   (formatItem 경로 소비. 파싱 불가 값은 원문 유지 — SDM1010 관례)
export const toDisplayDate = (v: unknown): string => {
  const d = parseAnyDate(v);
  return d ? d.format('YYYY.MM.DD') : toText(v);
};

// ⭐ P_SOP_DATE 입력 변환 — SP TO_DATE 파서 호환 'YYYY-MM-DD 00:00:00' / 빈 값 ''
//   (행별 단건 호출 — 빈 토큰 행밀림 없음. '-' 센티널 금지: TO_DATE 파싱 오류)
export const toSopDateParam = (v: unknown): string => {
  const d = parseAnyDate(v);
  return d ? `${d.format('YYYY-MM-DD')} 00:00:00` : '';
};

// yyyymmdd → 'YYYY-MM-DD' (조회 SP TO_DATE(SUBSTR(p,1,10),'YYYY-MM-DD') 계약)
export const ymdToDash = (ymd: string): string =>
  isYmd(ymd) ? `${ymd.slice(0, 4)}-${ymd.slice(4, 6)}-${ymd.slice(6, 8)}` : '';
