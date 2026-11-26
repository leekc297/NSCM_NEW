// forecastInfo 위젯 — P_DMD0001_GET_FORECAST_INFO 의 o_rc1(GBN/LABEL/VALUE)을
//   컴포넌트가 쓰는 { logic: 글머리 목록, info: 라벨-값 표 }로 변환한다.
//   GBN='logic' → VALUE 만(LABEL null), GBN='info' → {LABEL, VALUE}. 정렬은 SP(SORT_ORD)가 보장.

// o_rc1 행 — 컬럼은 GBN('logic'|'info') · LABEL · VALUE (대문자, DB 커서 그대로).
//   proc 응답 행 타입(인덱스 시그니처)을 그대로 받도록 Record 로 둔다.
export type ForecastInfoRow = Record<string, string | number | null | undefined>;

export interface ForecastInfoVm {
  logic: string[];
  info: { label: string; value: string }[];
}

const str = (v: string | number | null | undefined): string => (v == null ? '' : String(v));

export const mapForecastInfo = (rows: ForecastInfoRow[]): ForecastInfoVm => ({
  logic: rows.filter(r => r.GBN === 'logic').map(r => str(r.VALUE)),
  info: rows
    .filter(r => r.GBN === 'info')
    .map(r => ({ label: str(r.LABEL), value: str(r.VALUE) })),
});
