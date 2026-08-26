// ⭐ SDM1010 — 조회/저장 FE 검증 + 저장 payload·날짜 순수함수 (테스트 대상 — etc-sales-reports validate 골격).
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { safeString } from '@foundation/utils';

import { DUP_KEY_COLUMNS, MSG, TAB_INDEX } from '../project-reg.constants';
import type { SearchCondition, Tab1Row, ValidationResult } from '../project-reg.types';

import type { SaveTab1Payload } from './project-reg.api';

const YMD = /^\d{8}$/;
const toDay = (s: string) => dayjs(`${s.slice(0, 4)}-${s.slice(4, 6)}-${s.slice(6, 8)}`);

// 임의 날짜 표현(YYYYMMDD / ISO 직렬화 / wijmo 에디터 표시 포맷 'M/D/YYYY' 실측 / Date) → dayjs
const parseAnyDate = (v: unknown): dayjs.Dayjs | null => {
  if (v == null || v === '') return null;
  if (v instanceof Date) return dayjs(v);
  const s = safeString(v).trim();
  if (s === '') return null;
  const d = YMD.test(s) ? toDay(s) : dayjs(s);
  if (d.isValid()) return d;
  const fallback = dayjs(new Date(s)); // 'M/D/YYYY' 등 로캘 문자열 — Date 파서 폴백
  return fallback.isValid() ? fallback : null;
};

// ⭐ 그리드 날짜 표시 — DATE 원형(ISO 직렬화) 커서 컬럼(SOP_DATE/REG_REQ_DATE/REG_COMP_DATE/
//   SAMPLE_*) → 'YYYY.MM.DD' (계약 결정 8 — formatItem 경로에서 소비. 파싱 불가 값은 원문 유지)
export const toDisplayDate = (v: unknown): string => {
  const d = parseAnyDate(v);
  return d ? d.format('YYYY.MM.DD') : safeString(v);
};

// ⭐ P_SOP_DATE 입력 변환 — 'YYYY-MM-DD 00:00:00' (§2 TO_DATE 고정 마스크). 빈 값 = ''
//   (행별 단건 호출이라 빈 토큰 행밀림 없음 — '-' 센티널 금지: TO_DATE 파싱 오류)
export const toSopDateParam = (v: unknown): string => {
  const d = parseAnyDate(v);
  return d ? `${d.format('YYYY-MM-DD')} 00:00:00` : '';
};

// 조회 검증 — division 필수(MSG00097) / 기간 형식·역전·한쪽만 입력(MSG00108) / TAB2 3년 초과(MSG00715)
//   TAB1 = 조회조건 비노출(§1 본인 필터 — 조건 전무) → 검증 대상 없음 (2026-08-13)
//   기간 둘 다 빈 값 = 허용 (§5 REG_COMP_DATE NULL 미완료 행 포함 전체 — 2026-08-13 실측 계약.
//   한쪽만 빈 값 = BETWEEN 전멸 0행 → 차단)
export const validateSearch = (sc: SearchCondition, tab: TAB_INDEX): ValidationResult => {
  if (tab === TAB_INDEX.TAB1) return { ok: true };
  if (!sc.divisionId) return { ok: false, msgId: MSG.DIVISION_REQUIRED };
  const fr = sc.regCompDateFr;
  const to = sc.regCompDateTo;
  if (fr === '' && to === '') return { ok: true }; // 전체 조회 (미완료 포함)
  if (!YMD.test(fr) || !YMD.test(to) || fr > to) {
    return { ok: false, msgId: MSG.DATE_INVERTED };
  }
  if (toDay(fr).add(3, 'year').isBefore(toDay(to))) {
    return { ok: false, msgId: MSG.RANGE_OVER_3Y };
  }
  return { ok: true };
};

// 신규행 IM 필수 컬럼 검증 (MSG00113 — detail = 컬럼 라벨. 메타 단일 원천)
export const validateRequiredInsert = (
  insertedRows: Tab1Row[],
  requiredColumns: RawFlexGridColumnConfig[]
): ValidationResult => {
  for (const row of insertedRows) {
    for (const col of requiredColumns) {
      const v = (row as Record<string, unknown>)[col.colNm];
      if (v == null || safeString(v).trim() === '') {
        return { ok: false, msgId: MSG.REQUIRED_COLUMN, detail: col.colLblNm ?? col.colNm };
      }
    }
  }
  return { ok: true };
};

// payload 내 중복 검증 — division+class+customer+name (삭제 'D' 행 제외. MSG00043)
export const validateDuplicate = (dirtyRows: Tab1Row[]): ValidationResult => {
  const keys = new Set<string>();
  for (const row of dirtyRows.filter(r => r.CRUD_TYPE !== 'D')) {
    const key = DUP_KEY_COLUMNS.map(c => safeString((row as Record<string, unknown>)[c])).join('|');
    if (keys.has(key)) return { ok: false, msgId: MSG.DUPLICATE };
    keys.add(key);
  }
  return { ok: true };
};

// ⭐ 행 → §2 SAVE 단건 payload (PROC_M COL_NM camelCase 13키 — sesUserId BE주입):
//   ① CRUD_TYPE 'C'(신규) → activeFlag 'I' — 'C' 그대로면 SP I/M/D 분기 불참(허위성공 계보)
//   ② I = 서버 TEMP_* 채번 — dpjtKey/dpjtCode 빈 값('')·dpjtSeq '1' (FE 전달값 무시 §2)
//   ③ M/D = 커서 수신 DPJT_KEY·DPJT_CODE·DPJT_SEQ **실값 필수** — 가드 = 3값 전부 IS NOT NULL,
//      빈 값이면 조용히 EVENT=0 미처리 (2026-08-13 CRUD 왕복 실측)
//   ④ sopDate = 'YYYY-MM-DD 00:00:00' 변환 / 빈 값 '' ('-' 금지 — TO_DATE 파싱 오류)
export const toSavePayload = (row: Tab1Row): SaveTab1Payload => {
  const isInsert = row.CRUD_TYPE === 'C';
  return {
    activeFlag: isInsert ? 'I' : String(row.CRUD_TYPE ?? ''),
    dpjtKey: isInsert ? '' : String(row.DPJT_KEY ?? ''),
    dpjtCode: isInsert ? '' : String(row.DPJT_CODE ?? ''),
    dpjtSeq: isInsert ? '1' : String(row.DPJT_SEQ ?? ''),
    divisionId: String(row.DIVISION_ID ?? ''),
    dpjtClass: String(row.DPJT_CLASS ?? ''),
    endCustomer: String(row.END_CUSTOMER ?? ''),
    dpjtName: String(row.DPJT_NAME ?? ''),
    cellType: String(row.CELL_TYPE ?? ''),
    stackMethod: String(row.STACK_METHOD ?? ''),
    bizType: String(row.BIZ_TYPE ?? ''),
    sopDate: toSopDateParam(row.SOP_DATE),
    sopPlantId: String(row.SOP_PLANT_ID ?? ''),
  };
};
