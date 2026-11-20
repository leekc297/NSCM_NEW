import { useCallback } from 'react';

import dayjs from '@foundation/dayjs';
import { useMessageStore } from '@shared/stores';

import { MAX_PERIOD_LABEL_DAYS, MSG } from '../shipment-plan-fix.constants';
import type { SearchCondition } from '../shipment-plan-fix.types';

// 'YYYYMMDD' → dayjs. 공용 dayjs 에는 customParseFormat 플러그인이 없어 포맷 인자 파싱이 Invalid 가 되므로
//   ISO 문자열로 바꿔 넘긴다(자매 shipment-request-semi 검증 훅 계보).
const toDay = (ymd: string) => dayjs(`${ymd.slice(0, 4)}-${ymd.slice(4, 6)}-${ymd.slice(6, 8)}`);

interface Result {
  ok: boolean;
}

// SCP0025 조회 전 검증 (design 02 §6 / 01 §2.6). read-only 화면이라 편집 저장 검증은 없다 —
//   Unfix 대상 유무(셀 선택)는 페이지 handleUnfix 가드가 담당(design 01 R4, MSG00134).
export const useShipmentPlanFixValidation = () => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const alert = useCallback(
    (msgId: string, fallback: string): Result => {
      void setAlert({ type: 'alert', content: t(msgId, `_${fallback}`) });
      return { ok: false };
    },
    [setAlert, t]
  );

  // 조회 전 검증 — AS-IS FindData_Main 의 Check_PeriodDate_New(dCalendar, "1", "7")(DateUtil.cs:236) 재현.
  //   ① from > to 금지(MSG00108) ② 최대조회기간 초과 금지(MSG01187). YYYYMMDD 문자열 사전순 비교(zero-pad 전제).
  const validateSearch = useCallback(
    (sc: SearchCondition): Result => {
      const from = sc.fromYyyymmdd.replace(/\D/g, '');
      const to = sc.toYyyymmdd.replace(/\D/g, '');
      if (from && to && from > to)
        return alert(MSG.PERIOD_RANGE, 'The end date must be on or after the start date.');
      // AS-IS Check_PeriodDate_New ③ — to >= from + 1년 + 7개월 + 7일 이면 차단(경계 포함, DateUtil.cs:244-267).
      //   캘린더 단위 가산(AddYears/AddMonths/AddDays)이라 dayjs 로 동형 재현한다(고정 일수 가산 금지 — 윤년·월말 보정).
      if (from && to) {
        const limit = toDay(from).add(1, 'year').add(7, 'month').add(7, 'day').format('YYYYMMDD');
        if (to >= limit) {
          const content = t(MSG.PERIOD_MAX, '_Maximum Period is From Date + {0}.').replace(
            '{0}',
            String(MAX_PERIOD_LABEL_DAYS)
          );
          void setAlert({ type: 'alert', content });
          return { ok: false };
        }
      }
      return { ok: true };
    },
    [alert, setAlert, t]
  );

  return { validateSearch };
};
