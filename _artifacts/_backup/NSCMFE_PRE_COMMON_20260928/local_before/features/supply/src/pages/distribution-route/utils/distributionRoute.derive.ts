// SCP0005 파생 Auto-Sync 산식 (design 03 R9/R10/R13 — cs:1004/1040/1045-1061).
//   순수 함수로 분리해 단위 테스트로 산식을 검증한다(그리드 cellEditEnded 핸들러가 호출).

import { DAYS_COLUMNS, LT_SEGMENT_COLUMNS, TRK_DASH_COLUMNS } from '../distribution-route.constants';

type Row = Record<string, unknown>;

// 숫자 파싱 — 공백/빈값/파싱실패 = 0 (AS-IS ISNULL/NVL 0, LT 합계용).
export const toNum0 = (v: unknown): number => {
  if (v === undefined || v === null || v === '') return 0;
  const n = typeof v === 'number' ? v : typeof v === 'string' ? Number(v.replace(/,/g, '')) : NaN;
  return Number.isFinite(n) ? n : 0;
};

// L/T 합계 = 5 LT 컬럼 합 (design 03 R13 — LT_SUM 파생).
export const sumLeadTime = (row: Row): number =>
  LT_SEGMENT_COLUMNS.reduce((acc, key) => acc + toNum0(row[key]), 0);

// TRANSPORT_MODE 변경 시 요일 자동 'Y' (design 03 R9 — TRK/AIR → DAYS 7개 전부 'Y').
export const daysAllYes = (): Record<string, string> =>
  DAYS_COLUMNS.reduce<Record<string, string>>((acc, key) => {
    acc[key] = 'Y';
    return acc;
  }, {});

// TRANSPORT_MODE='TRK' 시 港/Forwarder 7개 '-' (design 03 R10).
export const portsDash = (): Record<string, string> =>
  TRK_DASH_COLUMNS.reduce<Record<string, string>>((acc, key) => {
    acc[key] = '-';
    return acc;
  }, {});
