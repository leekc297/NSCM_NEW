import { DAY_BINDING_RE, SUM_BINDING_RE } from './shipment-working-day-osp.constants';
import type { CalendarColumnRow, DynDayColumn, DynSumColumn } from './shipment-working-day-osp.types';

// 3SPAN 타이틀 SP(PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN — SHEETS.CALENDAR) 응답 o_rc1 행에서
//   동적 기간 컬럼을 만든다 — AS-IS InitSpreadDateColumn(.cs:169-245) `foreach (DataRow dr in dsSpdTitle.Tables[0].Rows)` 1:1.
//   AS-IS 는 응답 행 전부를 컬럼으로 추가한다(B_ 포함 시 AddTextColumn 폭 0 :196, 그 외 AddComboColumn dtValidYN :203).
//   그중 사용자에게 보이는 것은 D_ 뿐이다 — W_/M_ 은 SetSpreadColumn(.cs:353-356)이 chkSum.Checked(=false, Designer Visible=false
//   :346)로 숨기므로 합계 열(buildDynSumColumns, visible=showSum)로 분리한다. 3SPAN 은 B_ 행을 만들지 않는다(사내 원문 L2981~ 실측).
//   헤더 라벨(월/주차/일)·요일코드는 서버 달력 값을 그대로 쓴다 — 클라 재계산 금지(2026-10-20 정정: 이전 o_rc1_columns 사이드카 +
//   dayjs 주차 계산은 일반 call-proc 응답에 사이드카가 없어 항상 0컬럼이었고 주차 라벨도 AS-IS 'W43' 과 달랐다, DoD B26/B27).

// D_ 일자열 → 3단 머지헤더(월/주차/일) 파생. 응답 순서(SORT_ORDER_NO)를 그대로 보존한다(AS-IS 루프 순서 = 컬럼 순서).
export const buildDynDayColumns = (rows: CalendarColumnRow[]): DynDayColumn[] =>
  (rows ?? [])
    .filter(r => DAY_BINDING_RE.test(String(r?.COLUMN_NAME ?? '')))
    .map(r => {
      const binding = String(r.COLUMN_NAME);
      return {
        binding,
        yyyymmdd: binding.slice(2),
        dayLabel: String(r.COLUMN_LABEL_NAME ?? ''), //              AS-IS sColumnLabelname(:191) — leaf 헤더
        weekLabel: String(r.SMALL_CLASS_LABEL_NAME ?? ''), //        AS-IS sSmallLabelName(:189) — 주차 span(:221,230)
        monthLabel: String(r.LARGE_CLASS_LABEL_NAME ?? ''), //       AS-IS sLargeLabelName(:190) — 월 span(:215)
        // AS-IS sDayCode(:192) — 요일색(:206-208)·GetDayOfWeek(:811-818) 원천. 미매칭(NULL)은 빈 문자(색만 기본색).
        dayCode: String(r.DAY_CODE ?? '').toUpperCase(),
      };
    });

// W_/M_ SUM 열 목록 — chkSum 토글 대상(AS-IS SetSpreadColumn :353 / SetLockSumColumn 잠금 :406). 라벨 = COLUMN_LABEL_NAME.
export const buildDynSumColumns = (rows: CalendarColumnRow[]): DynSumColumn[] =>
  (rows ?? [])
    .filter(r => SUM_BINDING_RE.test(String(r?.COLUMN_NAME ?? '')))
    .map(r => {
      const binding = String(r.COLUMN_NAME);
      return {
        binding,
        kind: binding.startsWith('W_') ? ('W' as const) : ('M' as const),
        header: String(r.COLUMN_LABEL_NAME ?? '') || binding.slice(2),
      };
    });
