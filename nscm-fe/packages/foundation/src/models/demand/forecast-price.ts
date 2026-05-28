/**
 * 수요예측 가격 관련 타입
 */

export interface ForecastPriceData {
  itemCode: string;
  predictedPrice: number;
  confidenceLevel: number;
  forecastDate: string;
}

export interface ForecastPriceRequest {
  startDate: string;
  endDate: string;
  itemCode: string;
}
