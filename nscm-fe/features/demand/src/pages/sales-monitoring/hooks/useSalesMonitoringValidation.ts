import dayjs from 'dayjs';

import { useMessageStore } from '@shared/stores';

import { MSG } from '../sales-monitoring.constants';
import type { SearchCondition, ValidationResult } from '../sales-monitoring.types';

// AS-IS DMF0048_SalesMonitoring.cs FindData (L615~673) — 4 검증:
//   L623~626 : blnWork (concurrency lock) → MSG00137
//   L636~639 : sPeriod[0] > sPeriod[1]    → MSG00108
//   L643~649 : drpPeriod.Value1 + 3년 < Value2 → MSG00164 + 기간 자동 보정
//   L669~672 : p_division_id == ""         → MSG00097
export const useSalesMonitoringValidation = () => {
  const setAlert = useMessageStore.getState().setAlert;

  const validateFind = (sc: SearchCondition): ValidationResult => {
    // 1) Division 필수 (AS-IS L669 — MSG00097)
    if (!sc.divisionId || sc.divisionId === '') {
      void setAlert({ type: 'alert', content: `[${MSG.REQUIRE_DIVISION}] Division 을 선택하세요.` });
      return { ok: false, msgId: MSG.REQUIRE_DIVISION };
    }

    // 2) 기간 역전 (AS-IS L636 — MSG00108)
    const start = dayjs(sc.startYyyymmdd, 'YYYYMMDD');
    const end = dayjs(sc.endYyyymmdd, 'YYYYMMDD');
    if (!start.isValid() || !end.isValid()) {
      void setAlert({ type: 'alert', content: '[기간] 유효한 날짜를 입력하세요.' });
      return { ok: false };
    }
    if (start.isAfter(end)) {
      void setAlert({ type: 'alert', content: `[${MSG.NO_DATA}] 조회된 데이터가 없습니다 (기간 시작 > 종료).` });
      return { ok: false, msgId: MSG.NO_DATA };
    }

    // 3) 3년 초과 (AS-IS L643~649 — MSG00164 + 자동 보정 권장)
    if (start.add(3, 'year').isBefore(end)) {
      void setAlert({
        type: 'alert',
        content: `[${MSG.PERIOD_OVER_3YEARS}] 조회 기간은 최대 3년까지 가능합니다.`,
      });
      return { ok: false, msgId: MSG.PERIOD_OVER_3YEARS };
    }

    return { ok: true };
  };

  return { validateFind };
};
