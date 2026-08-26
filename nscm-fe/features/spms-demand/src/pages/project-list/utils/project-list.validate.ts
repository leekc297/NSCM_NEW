// ⭐ SDM1020 — 조회 FE 검증 + 파라미터·날짜 순수함수 (테스트 대상 — project-reg validate 골격 승계).
import dayjs from '@foundation/dayjs';

import { MSG } from '../project-list.constants';
import type { MainRow, SearchCondition, ValidationResult } from '../project-list.types';

import type { ReqPjtRegPayload } from './project-list.api';
import { toText } from './project-list.value';

const YMD = /^\d{8}$/;
const toDay = (s: string) => dayjs(`${s.slice(0, 4)}-${s.slice(4, 6)}-${s.slice(6, 8)}`);

// 임의 날짜 표현(YYYYMMDD / ISO 직렬화 / wijmo 에디터 표시 포맷 'M/D/YYYY' 실측 / Date) → dayjs
const parseAnyDate = (v: unknown): dayjs.Dayjs | null => {
  if (v == null || v === '') return null;
  if (v instanceof Date) return dayjs(v);
  const s = toText(v).trim();
  if (s === '') return null;
  const d = YMD.test(s) ? toDay(s) : dayjs(s);
  if (d.isValid()) return d;
  const fallback = dayjs(new Date(s)); // 'M/D/YYYY' 등 로캘 문자열 — Date 파서 폴백
  return fallback.isValid() ? fallback : null;
};

// ⭐ 그리드 날짜 표시 — DATE 원형(ISO 직렬화) 커서 컬럼(SOP_DATE/REG_COMP_DATE — FPDateText 메타)
//   → 'YYYY.MM.DD' (formatItem 경로 소비. 파싱 불가 값은 원문 유지 — SDM1010 관례 동일)
export const toDisplayDate = (v: unknown): string => {
  const d = parseAnyDate(v);
  return d ? d.format('YYYY.MM.DD') : toText(v);
};

// ⭐ P_SOP_DATE 입력 변환 — SP 파서 TO_DATE(…, 'YYYY-MM-DD HH24:MI:SS') 고정 마스크 (PKG L622 실측).
//   빈 값 = '' (행별 단건 호출 — REGEXP_SUBSTR 단건 파싱이라 빈 토큰 행밀림 없음. '-' 센티널 금지)
export const toSopDateParam = (v: unknown): string => {
  const d = parseAnyDate(v);
  return d ? `${d.format('YYYY-MM-DD')} 00:00:00` : '';
};

// yyyymmdd → 'YYYY-MM-DD' (§조회 SP TO_DATE(SUBSTR(p,1,10),'YYYY-MM-DD') 계약 — PKG L113 실측)
export const ymdToDash = (ymd: string): string =>
  YMD.test(ymd) ? `${ymd.slice(0, 4)}-${ymd.slice(4, 6)}-${ymd.slice(6, 8)}` : '';

// 멀티 콤보 → SP 파라미터 (UC-06 — 콤마 연결. 빈 선택 = 'ALL' 무필터 센티널, SP OR 단락 실측)
export const toMultiParam = (value: string): string => value.trim() || 'ALL';

// ⭐ 등록 완료일 기본 구간 M-1 ~ Today (개요 F17 — 계약 ⑤ dayjs 병행 승인).
//   anchor = period 시트(PR_GET_DAY_RANGE o_rc2 DAY_RANGE 'YYYYMMDD:YYYYMMDD')의 시작값(당월 1일 —
//   서버 기준일) 이 있으면 그것을, 없으면 클라이언트 오늘을 사용. fr = anchor-1개월(전월 1일) /
//   to = Today (SP 는 당월 1일~+N개월 말일만 산출 — M-1~Today 직접 산출 불가라 FE 계산 병행)
export const defaultRegCompRange = (dayRange: unknown): { fr: string; to: string } => {
  const s = toText(dayRange);
  const anchor = /^\d{8}:\d{8}$/.test(s) ? toDay(s.slice(0, 8)) : dayjs().startOf('month');
  return {
    fr: anchor.subtract(1, 'month').format('YYYYMMDD'),
    to: dayjs().format('YYYYMMDD'),
  };
};

// 조회 검증 — Division 필수(P-09 MSG00097) → 등록 완료일 필수·형식·역전(P-10 MSG00108).
//   ⚠ SDM1010 TAB2 와 달리 기간 빈 값 허용 없음 (개요 E17 필수 Y — 빈 값도 MSG00108)
export const validateSearch = (sc: SearchCondition): ValidationResult => {
  if (!sc.divisionId) return { ok: false, msgId: MSG.DIVISION_REQUIRED };
  const fr = sc.regCompDateFr;
  const to = sc.regCompDateTo;
  if (!YMD.test(fr) || !YMD.test(to) || fr > to) {
    return { ok: false, msgId: MSG.DATE_INVERTED };
  }
  return { ok: true };
};

// ⭐ 행 → 등록요청 단건 payload (PROC_M COL_NM 13키 — sesUserId BE주입 제외. 계약 ①):
//   ① 대상 = CRUD_TYPE 'M' 행만 (D4 — SP 는 P_ACTIVE_FLAG 분기 부재·항상 변경본 INSERT 경로.
//      신규/삭제 성 행 전송 금지는 호출부 filter 가 보장, activeFlag 는 행 값 승계)
//   ② 키 3종(dpjtKey/dpjtCode/dpjtSeq) = 커서 수신 실값 (SP 가 DPJT_CODE 단위 MAX(SEQ)+1 재채번)
//   ③ sopDate = 'YYYY-MM-DD 00:00:00' 변환 / 빈 값 ''
//   ④ 행별 단건 호출 — SP 는 '^' 파서지만 1행 문자열 호환 ('^' join 금지 — 확정 결정)
export const toReqPayload = (row: MainRow): ReqPjtRegPayload => ({
  activeFlag: toText(row.CRUD_TYPE),
  dpjtKey: toText(row.DPJT_KEY),
  dpjtCode: toText(row.DPJT_CODE),
  dpjtSeq: toText(row.DPJT_SEQ),
  divisionId: toText(row.DIVISION_ID),
  dpjtClass: toText(row.DPJT_CLASS),
  endCustomer: toText(row.END_CUSTOMER),
  dpjtName: toText(row.DPJT_NAME),
  cellType: toText(row.CELL_TYPE),
  stackMethod: toText(row.STACK_METHOD),
  bizType: toText(row.BIZ_TYPE),
  sopDate: toSopDateParam(row.SOP_DATE),
  sopPlantId: toText(row.SOP_PLANT_ID),
});
