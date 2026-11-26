import { describe, expect, test } from 'vitest';

import { mapForecastInfo } from './forecastInfo.map';

// 실제 o_rc1 컬럼(PKG_DMD0001.P_DMD0001_GET_FORECAST_INFO, DB 실측):
//   GBN('logic'|'info') · LABEL(logic 은 null) · VALUE. SORT_ORD 로 정렬된 순서로 내려온다.
const ROWS = [
  { GBN: 'logic', LABEL: null, VALUE: '최근 24개월 판매 이력 기반 예측' },
  { GBN: 'logic', LABEL: null, VALUE: '계절성(Seasonality) 반영' },
  { GBN: 'info', LABEL: '모델', VALUE: 'ETS + Seasonality' },
  { GBN: 'info', LABEL: '예측 단위', VALUE: '월 (Monthly)' },
];

describe('mapForecastInfo', () => {
  test('GBN 으로 logic 글머리(string[]) / info 라벨-값 분리', () => {
    expect(mapForecastInfo(ROWS)).toEqual({
      logic: ['최근 24개월 판매 이력 기반 예측', '계절성(Seasonality) 반영'],
      info: [
        { label: '모델', value: 'ETS + Seasonality' },
        { label: '예측 단위', value: '월 (Monthly)' },
      ],
    });
  });

  test('빈 응답 → 빈 logic/info (로딩·빈 상태)', () => {
    expect(mapForecastInfo([])).toEqual({ logic: [], info: [] });
  });
});
