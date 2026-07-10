# DMF0020 환율 Modal — 대상년월 2단 헤더 (증분 이관, 2026-07-08 오후)

> 이번 라운드 변경 = **FE 1 파일** (BE/DB 무변경, 압축 없음). 사용자 적용 확인 완료.
- 화면: DMF0020 SalesFuturePrice > Exchange Rate Modal

## 변경 내용 (`ExchangeRateModal.tsx`)
1. **대상 년월 2단 헤더** (AS-IS 1:1): 1단=년도('2026', 동일 년도 월 수평 span) / 2단=월('07'…)
   - 구 수동 방식(Row push + formatItem 텍스트 치환 + 수동 수평 머지) 제거 → 메인 그리드와 동일한 **표준 nested columnGroups(년→월)** — wrapper columnGroups 재적용에도 안정
2. **헤더 총높이 48px 고정** (2단=24×2 — "2단 기준으로 줄여서"): 1회 설정/updatedLayout 등록만으론 CustomDialog open 애니메이션 중 늦게 build 된 헤더에 기본높이 잔존 → **PriceBatchInputModal 검증 패턴(open 동안 raf 상시 정규화 + 살아있는 인스턴스 재부착)** 적용
3. 고정컬럼(Div/Currency/Unit) 세로 span = 실제 헤더 행수 기준, DIV/CURRENCY 데이터 셀 머지 유지

## 적용
```bash
cp fe/features/master/src/pages/sales-future-price/components/modals/ExchangeRateModal.tsx \
   nscm-fe/features/master/src/pages/sales-future-price/components/modals/
```
> 선행 라운드 미적용 환경이면 `_dmf0020_artifacts`(전체 증분, 본 파일 최신본 포함) 하나로 적용 권장.

## 검증
환율 Modal open → 자동조회 → 1단 '2026' 수평 머지 + 2단 '07 08…' + 헤더 총높이 48px(낮음) + Div/Currency 셀 머지 + KRW 필터.
