import dayjs from '@foundation/dayjs';
import { useMessageStore } from '@shared/stores';

import { MAX_PERIOD_LABEL_DAYS, MSG } from '../shipment-request-semi.constants';
import type { SearchCondition } from '../shipment-request-semi.types';

/**
 * 조회 사전 검증 — **단일 지점**(design 02 §5.7 / G04).
 *
 * AS-IS 는 `DataUtil.checkRequired(usrConditionPanel1)`(패널 일괄 검증)와
 * `DateUtil.Check_PeriodDate(drpPeriod)` 두 호출로 조회를 차단한다(cs:559-560).
 * 필드별 `if` 를 화면 곳곳에 흩뿌리지 말고 이 훅 하나에서 판정한다.
 *
 *   V-F1 필수(`*`) 3종: Division / Operation Group / Period → `MSG00429`
 *   V-F2 기간 3분기   : 공백 `MSG00665` / from>to `MSG00108` / 371일 초과 `MSG01187`
 *
 * i18n: AS-IS 번호(`MSG00002`/`MSG00049`/`MSG00172`)는 TO-BE 에서 뜻이 다르거나 미등록이다 —
 *   문구 기준 역조회로 확정한 코드만 쓴다(hook #114, design 02 §4.5.1).
 */
// 'YYYYMMDD' → dayjs. 공용 dayjs 에는 `customParseFormat` 플러그인이 없어 포맷 인자 파싱이 항상
//   Invalid 가 된다(forecast-price.editLock 주석의 실측 계보) — ISO 문자열로 바꿔 넘긴다.
const toDay = (ymd: string) => dayjs(`${ymd.slice(0, 4)}-${ymd.slice(4, 6)}-${ymd.slice(6, 8)}`);

export const useShipmentRequestSemiValidation = () => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  const alert = (content: string) => {
    void setAlert({ type: 'alert', content });
  };

  const required = (label: string) =>
    t(MSG.REQUIRED, { defaultValue: '{0} value is required.' }).replace('{0}', `[${label}]`);

  const validateSearch = (sc: SearchCondition, labels: Record<string, string>): boolean => {
    if (!sc.divisionId.trim()) {
      alert(required(labels.division));
      return false;
    }
    if (!sc.operationGroup.trim()) {
      alert(required(labels.operationGroup));
      return false;
    }
    if (!sc.fromYyyymmdd || !sc.toYyyymmdd) {
      alert(t(MSG.PERIOD_EMPTY, { defaultValue: 'Please enter the search period.' }));
      return false;
    }
    if (sc.fromYyyymmdd > sc.toYyyymmdd) {
      alert(t(MSG.PERIOD_ORDER, { defaultValue: 'Invalid period (start > end).' }));
      return false;
    }
    // AS-IS `Check_PeriodDate` ③ — `to >= from + 1 캘린더 연도 + 7일`이면 차단. 경계 포함이다.
    //   필수: 371일 고정 가산이 아니라 **연 단위 가산 후 7일**이다(DateUtil.cs:122 → :140).
    //   윤년 2/29 를 포함하는 from~to 조합에서 실경계가 373일이 되므로 고정 371 로 계산하면
    //   AS-IS 보다 2일 더 엄격해진다. 메시지 인자(`{0}`)만 AS-IS 문구대로 371 을 유지한다(:144).
    const limit = toDay(sc.fromYyyymmdd).add(1, 'year').add(7, 'day').format('YYYYMMDD');
    if (sc.toYyyymmdd >= limit) {
      alert(
        t(MSG.PERIOD_MAX, { defaultValue: 'Maximum Period is From Date + {0}.' }).replace(
          '{0}',
          String(MAX_PERIOD_LABEL_DAYS)
        )
      );
      return false;
    }
    return true;
  };

  return { validateSearch };
};
