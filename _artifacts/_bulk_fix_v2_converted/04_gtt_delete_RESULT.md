# Stage 3d — GTT DELETE 누락 audit 결과

작성: 2026-06-01
관련 Plan: `C:\Users\ejene\.claude\plans\hashed-fluttering-seahorse.md`

## 결과 (audit only — bulk fix 적용 금지)

| 통계 | 수 |
|---|---:|
| SP 파일 | **10** |
| 영향 procedure | **38** (중복 포함, forward-declaration 영향) |
| GT_* INSERT (선행 DELETE 없음) | **203** |

상세: `04_gtt_delete_audit.txt`

영향 SP:
- `PKG_DMF0003.sql` — 3 proc (popup 패턴)
- `PKG_DMF0021.sql` — 2 proc (sales plan)
- `PKG_DMF0035.sql` — 2 proc (waterfall)
- `PKG_DMF0042.sql` — 2 proc (business plan)
- **`PKG_DMF0043.sql` — 5 proc** (contribute main + sales list) ⭐ 이미 검증된 사고 화면
- `PKG_DMF0044.sql` — 3 proc (sales report)
- `PKG_DMF0048.sql` — 1 proc (monitoring)
- `PKG_DMF0049.sql` — 1 proc (etc reports)
- `PKG_DMF0081.sql` — 3 proc (mkt psi)
- `PKG_DMF0005.sql` — (다른 패턴, 별도)

## ⚠️ Bulk fix 적용 금지 (Anti-Simplification)

이번 audit 만으로는 GTT scope 가 안전 fix 대상이 아님을 확인:

| 위험 요소 | 영향 |
|---|---|
| **chained / 재귀 호출** | 한 proc 의 GTT 가 다른 proc 의 입력일 수 있음. 무조건 BEGIN DELETE 시 데이터 손실 |
| **forward declaration** | parser 가 PROCEDURE 키워드 매번 새 proc 으로 인식 — 동일 proc 이 중복 카운트 |
| **이미 다른 위치에 DELETE 존재** | proc 중간/끝 또는 외부 SP 에 DELETE 있을 수 있음 |
| **DML order matters** | INSERT 직전 vs BEGIN 직후 시점 차이 |

## 권고 절차

1. **신규 화면 진입 시** 룰 25 §0.5 (또는 Stage 4 의 _diagnostics/ hook) 가 해당 SP 의 GTT audit 자동 실행
2. **결과 빨간 행 (선행 DELETE 없음)** 에 대해 caller (BE / 화면) 의 호출 횟수 + chained 호출 여부 cross-check
3. **2회 이상 호출되는 proc 우선 fix** — 1회 호출은 risk 낮음
4. **DMF0043 (이미 검증)** — 5 proc 중 caller 호출 패턴 확인 후 BEGIN 직후 DELETE 추가 결정

## 후속 룰 보강

룰 21 §12 또는 룰 10 §SP 패턴 에 추가:
> GTT 사용 SP 는 procedure BEGIN 직후 `DELETE FROM GT_<table>;` 의무. 동일 session 2회 호출 시 row 누적. forward declaration 또는 chained 호출 케이스는 caller 분석 후 결정.

## 다음 단계

Stage 3d 의 "audit only" 결정에 따라 **자동 bulk fix 미적용**. 룰 보강은 Stage 5 에서 처리.
