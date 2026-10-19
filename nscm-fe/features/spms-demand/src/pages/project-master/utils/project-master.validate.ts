// ⭐ SDM5010 — 조회 FE 검증 + 파라미터·날짜 순수함수 (테스트 대상 — project-list validate 골격 승계).
import dayjs from '@foundation/dayjs';

import { isYmd, toSopDateParam, ymdToDay } from '../../../lib/date';
import { MSG, TAB_INDEX } from '../project-master.constants';
import type { SearchCondition, Tab1Row, Tab2Row, ValidationResult } from '../project-master.types';

import type { CancelTab1Payload, ConfirmTab1Payload, SaveTab2Payload } from './project-master.api';
import { toText } from './project-master.value';

// 날짜 순수함수 — SDM 공통(lib/date) 재노출 (기존 화면 내 import 경로 유지.
//   P_SOP_DATE = CONFIRM TO_DATE(SUBSTR(p,1,10),'YYYY-MM-DD') — 02_PKG L725 실측 /
//   조회 = GET_TAB2 TO_DATE(SUBSTR(p,1,10),'YYYY-MM-DD') 계약 — 02_PKG L884 실측)
export { toDisplayDate, toSopDateParam, ymdToDash } from '../../../lib/date';

// 멀티 콤보 → SP 파라미터 (UC-06 — 콤마 연결. 빈 선택 = 'ALL' 무필터 센티널 — SP OR 단락, CF-09)
export const toMultiParam = (values: string[]): string => {
  const arr = values.filter(v => v !== '');
  return arr.length === 0 ? 'ALL' : arr.join(',');
};

// ⭐ 등록 완료일 기본 구간 M-1 ~ Today (개요 F18 — E01-2).
//   fr = 오늘의 한 달 전 같은 날 / to = Today — SDM1010/SDM1020 과 동일 기준.
//   (구 defaultRegCompRange 의 period 시트 YMD_FR 앵커 → 전월 1일 방식은 폐기 — FE dayjs 단독 산출)
export const defaultRegCompDates = (): { fr: string; to: string } => ({
  fr: dayjs().subtract(1, 'month').format('YYYYMMDD'),
  to: dayjs().format('YYYYMMDD'),
});

// 조회 검증 — TAB1 = 조회조건 미소비(F-3 — 검증 대상 없음) / TAB2 = Division 필수(P-01 MSG00097) →
//   기간 필수·형식·역전(P-02 MSG00108 — 개요 E18 필수 Y: 빈 값도 차단) → 3년 초과(P-03 MSG00164)
export const validateSearch = (sc: SearchCondition, tab: TAB_INDEX): ValidationResult => {
  if (tab === TAB_INDEX.TAB1) return { ok: true };
  if (!sc.divisionId) return { ok: false, msgId: MSG.DIVISION_REQUIRED };
  const fr = sc.regCompDateFr;
  const to = sc.regCompDateTo;
  if (!isYmd(fr) || !isYmd(to) || fr > to) {
    return { ok: false, msgId: MSG.DATE_INVERTED };
  }
  if (ymdToDay(fr).add(3, 'year').isBefore(ymdToDay(to))) {
    return { ok: false, msgId: MSG.RANGE_OVER_3Y };
  }
  return { ok: true };
};

// ⭐ 행 → 승인(CONFIRM) 단건 payload (PROC_M COL_NM 14키 — sesUserId BE주입 제외. 계약 ①):
//   ① 키 4종(dpjtKey/dpjtCode/dpjtSeq/dpjtKeyParent) = 커서 수신 실값 ('수정' Case 는 SP 가
//      PARENT 유무로 분기 — D3/D4 정정분)
//   ② 편집값 9종 = 현재 셀 값 그대로 (E05 수정 항목 → 승인 파라미터 반영 — TAB1 저장 버튼 없음)
//   ③ sopDate = 'YYYY-MM-DD 00:00:00' 변환 / 빈 값 ''
//   ④ 9자리 D-PJT Code 는 호출부 FE 선검증 (P-08/D12 — editLock.isDpjtCodeValid)
export const toConfirmPayload = (row: Tab1Row): ConfirmTab1Payload => ({
  dpjtKey: toText(row.DPJT_KEY),
  dpjtCode: toText(row.DPJT_CODE),
  dpjtSeq: toText(row.DPJT_SEQ),
  dpjtKeyParent: toText(row.DPJT_KEY_PARENT),
  divisionId: toText(row.DIVISION_ID),
  dpjtClass: toText(row.DPJT_CLASS),
  endCustomer: toText(row.END_CUSTOMER),
  dpjtName: toText(row.DPJT_NAME),
  cellType: toText(row.CELL_TYPE),
  stackMethod: toText(row.STACK_METHOD),
  bizType: toText(row.BIZ_TYPE),
  sopDate: toSopDateParam(row.SOP_DATE),
  sopPlantId: toText(row.SOP_PLANT_ID),
  note: toText(row.NOTE),
});

// 행 → 반려(CANCEL) 단건 payload (PROC_M COL_NM 4키 — 계약 ①. note = 현재 행 내용 전달 P-10)
export const toCancelPayload = (row: Tab1Row): CancelTab1Payload => ({
  divisionId: toText(row.DIVISION_ID),
  dpjtKey: toText(row.DPJT_KEY),
  dpjtKeyParent: toText(row.DPJT_KEY_PARENT),
  note: toText(row.NOTE),
});

// ⭐ 행 → TAB2 SAVE 단건 payload (PROC_M COL_NM 4키 — 계약 ①):
//   ① activeFlag = 'M' 고정 (P-13 — SP 는 'M' 단건만 유효, 그 외 CODE '1'. 호출부가 'M' 행만 filter)
//   ② disabled = DISABLE_YN 서버 문자열 그대로 (계약 ⑥ — 'CHECKED' 정확 일치만 DISABLED)
export const toSaveTab2Payload = (row: Tab2Row): SaveTab2Payload => ({
  activeFlag: 'M',
  dpjtKey: toText(row.DPJT_KEY),
  dpjtDevelopStatus: toText(row.DPJT_DEVELOP_STATUS),
  disabled: toText(row.DISABLE_YN),
});
