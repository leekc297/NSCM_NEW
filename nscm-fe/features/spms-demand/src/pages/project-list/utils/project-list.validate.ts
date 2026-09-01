// ⭐ SDM1020 — 조회 FE 검증 + 파라미터·날짜 순수함수 (테스트 대상 — project-reg validate 골격 승계).
import dayjs from '@foundation/dayjs';

import { isYmd, toSopDateParam } from '../../../lib/date';
import { MSG } from '../project-list.constants';
import type { MainRow, SearchCondition, ValidationResult } from '../project-list.types';

import type { ReqPjtRegPayload } from './project-list.api';
import { toText } from './project-list.value';

// 날짜 순수함수 — SDM 공통(lib/date) 재노출 (기존 화면 내 import 경로 유지.
//   P_SOP_DATE = TO_DATE 'YYYY-MM-DD HH24:MI:SS' 고정 마스크 — PKG L622 실측 /
//   조회 = TO_DATE(SUBSTR(p,1,10),'YYYY-MM-DD') 계약 — PKG L113 실측)
export { toDisplayDate, toSopDateParam, ymdToDash } from '../../../lib/date';

// 멀티 콤보 → SP 파라미터 (UC-06 — 콤마 연결. 빈 선택 = 'ALL' 무필터 센티널, SP OR 단락 실측)
export const toMultiParam = (value: string): string => value.trim() || 'ALL';

// ⭐ 등록 완료일 기본 구간 M-1 ~ Today (개요 F17).
//   fr = 오늘의 한 달 전 같은 날 / to = Today — SDM1010(project-registration)과 동일 기준.
//   (구 defaultRegCompRange 의 period 시트 앵커 → 전월 1일 방식은 폐기 — FE dayjs 단독 산출)
export const defaultRegCompDates = (): { fr: string; to: string } => ({
  fr: dayjs().subtract(1, 'month').format('YYYYMMDD'),
  to: dayjs().format('YYYYMMDD'),
});

// 조회 검증 — Division 필수(P-09 MSG00097) → 등록 완료일 필수·형식·역전(P-10 MSG00108).
//   ⚠ SDM1010 TAB2 와 달리 기간 빈 값 허용 없음 (개요 E17 필수 Y — 빈 값도 MSG00108)
export const validateSearch = (sc: SearchCondition): ValidationResult => {
  if (!sc.divisionId) return { ok: false, msgId: MSG.DIVISION_REQUIRED };
  const fr = sc.regCompDateFr;
  const to = sc.regCompDateTo;
  if (!isYmd(fr) || !isYmd(to) || fr > to) {
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
