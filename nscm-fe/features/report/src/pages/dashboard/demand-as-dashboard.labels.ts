// DMD0001 대시보드 — 화면 표시 라벨의 i18n 코드·fallback.
//   컴포넌트가 t(...LBL.key) 로 해석한다(t(code, '_fallback') 2인자). 라벨 텍스트를 FE 에 하드코딩하지
//   않는다(사용자 결정 2026-11-23). 코드 등록 SQL: .atlas/gscm-design/DMD0001/design/05_register_msg.sql.
//   단위/기호(EA·억원·%·개월·12M·(MAPE)·›)는 표시 토큰이라 i18n 대상에서 제외한다.
//   fallback 은 MSG-03 '_' 접두(미등록 식별) — 코드 등록 후 '_' 가 사라지고 실문구가 보인다.

export const LBL = {
  // 패널 타이틀·서브타이틀
  productStatusTitle: ['LBL01290', '_제품별 현황'],
  riskTitle: ['LBL01291', '_리스크 Heat Map'],
  riskSubtitle: ['LBL01292', '_부족 위험도'],
  demandTitle: ['LBL01293', '_수요 예측 추이'],
  demandSubtitle: ['LBL01294', '_실적 vs 예측'],
  inventoryTitle: ['LBL01295', '_재고 전망'],
  inventorySubtitle: ['LBL01296', '_Inventory Projection'],
  coverTitle: ['LBL01297', '_Cover Month 추이'],
  excessTitle: ['LBL01298', '_Excess / 과재고 현황'],
  mapeTitle: ['LBL01299', '_예측 정확도'],
  forecastInfoTitle: ['LBL01300', '_Forecast Logic & Info'],
  // 리스크 범례·표 헤더
  riskLow: ['LBL01301', '_Low'],
  riskMedium: ['LBL01302', '_Medium'],
  riskHigh: ['LBL01303', '_High'],
  product: ['LBL01304', '_제품'],
  m3: ['LBL01305', '_3개월'],
  m6: ['LBL01306', '_6개월'],
  m12: ['LBL01307', '_12개월'],
  // 차트 시리즈·경계
  seriesActual: ['LBL01308', '_실적 (Actual)'],
  seriesMkt: ['LBL01309', '_MKT FCST'],
  seriesAi: ['LBL01310', '_AI FCST'],
  forecastBoundary: ['LBL01311', '_Forecast'],
  seriesOnHand: ['LBL01312', '_재고 (On Hand)'],
  seriesDemand: ['LBL01313', '_예상 수요'],
  seriesInbound: ['LBL01314', '_예상 입고'],
  seriesSafety: ['LBL01315', '_안전재고'],
  // 정적 라벨
  mapeAvg: ['LBL01316', '_전체 평균'],
  mapeNote: ['LBL01317', '_MAPE (Mean Absolute Percentage Error)'],
  excessTotal: ['LBL01318', '_합계'],
  excessRiskLabel: ['LBL01319', '_예상 폐기 위험 금액'],
  productStatusFootNote: ['LBL01320', '_Inventory Cover = 현재 재고 / 월평균 수요(예측)'],
  more: ['LBL01321', '_더보기'],
  // 조회조건 헤더 필드
  div: ['LBL00001', '_Div'], // 재사용(기존 코드)
  baseMonth: ['LBL01322', '_기준월'],
  bizType: ['LBL01323', '_Biz Type'],
  oem: ['LBL01324', '_OEM'],
  lastUpdated: ['LBL01325', '_최근 업데이트'],
  all: ['LBL01326', '_전체'], // 콤보 선두 '전체'(ALL) 옵션
  refresh: ['LBL01327', '_새로고침'], // 조회조건 새로고침 버튼 aria-label
} as const satisfies Record<string, readonly [string, string]>;
