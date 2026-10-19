import { useMessageStore } from '@shared/stores';

import { DATE_FINISH_COLUMN, DATE_START_COLUMN, MSG } from '../stock-osp.constants';

type Row = Record<string, unknown>;

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';
// 날짜 비교용 숫자키 'YYYYMMDD'(구분자 제거 앞 8자). 빈 값은 '' → 비교 스킵.
const ymd = (v: unknown): string => s(v).replace(/[^0-9]/g, '').slice(0, 8);

// SCP0041 Pack Hold Stock 날짜역전 검증 (design 03 §3):
//   R3(셀 편집 종료 시): DATE_FORECAST_START > DATE_FORECAST_FINISH 면 경고(MSG00108) 후 원복.
//   R4(저장 직전 재검증): 같은 규칙으로 dirty 행 전수 검사 — 위반행 존재 시 저장 중단(색상은 그리드에서).
export const useStockOspValidation = () => {
  const { t } = useTranslation();
  const setAlert = useMessageStore.getState().setAlert;

  // 한 행의 start/finish 역전 여부(둘 다 값이 있고 start>finish 일 때만 true). 빈 값은 위반 아님.
  const isReversed = (row: Row): boolean => {
    const start = ymd(row[DATE_START_COLUMN]);
    const finish = ymd(row[DATE_FINISH_COLUMN]);
    if (!start || !finish) return false;
    return start > finish;
  };

  // R4 — 저장 직전 재검증. 위반행이 하나라도 있으면 alert 후 false(저장 중단).
  const validateBeforeSave = (dirty: Row[]): boolean => {
    const hasReversed = dirty.some(isReversed);
    if (hasReversed) {
      void setAlert({
        type: 'alert',
        content: t(MSG.DATE_REVERSAL, '_시작일이 종료일보다 클 수 없습니다.'),
      });
      return false;
    }
    return true;
  };

  return { isReversed, validateBeforeSave };
};
