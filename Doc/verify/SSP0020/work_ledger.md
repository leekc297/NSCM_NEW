# 작업 원장 — SSP0020 · 2026-11-17 10:07

> 검사 인스턴스 224건 중 PASS·NA 219건 외 **5건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 5 | 재판정 PASS |

- 담당: DB 객체 2 · 화면 FE 2 · FE 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| E4 | EDIT |  |  | 2 |  |  |  |  |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| X-ROW | GEN |  |  | 2 |  |  |  |  |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| G4 | DESIGN |  |  | 1 |  |  |  |  |  |  | 조회조건 표시·라벨·활성 |

## W3 동작 수정 (5)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0020-0001 | G4 | chkAll / All / ALL | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — chkAll / All / ALL: 원장 V-ba650253 SEARCH / E2E smoke labels — 누락 라벨 |  | 4 (ACT:SSP0020_Delegate.InitControls ACT:SS) |
| WK-SSP0020-0002 | E4 | MSG00219 | DB 객체(PKG/SP)(적용 예정) | E4 FAIL 수정 — MSG00219: 원장 V-3e374103 ASIS / 실측[T-c95c4dc6]: [폼 저장형 시나리오 1건] FAIL: F04 MSG00219(cs:393) Period From > To → 화면 문구 'T |  | 1 (ACT:SSP0020_Delegate.Validation_Check:39) |
| WK-SSP0020-0003 | E4 | MSG00219 | DB 객체(PKG/SP)(적용 예정) | E4 FAIL 수정 — MSG00219: 원장 V-3e374103 / 실측[T-3e6ff1ff]: [폼 저장형 시나리오 1건] FAIL: F04 MSG00219(cs:393) Period From > To → 화면 문구 'The st |  | 1 (ACT:SSP0020_Delegate.Validation_Check:39) |
| WK-SSP0020-0004 | X-ROW | SSP0020_Delegate.InitControls | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0020_Delegate.InitControls: 진입점 집계 10검사 — PASS:6 · NA:3 · FAIL:1 (FX-SSP0020-006) |  | 9 (ACT:SSP0020_Delegate.InitControls:141:6 ) |
| WK-SSP0020-0005 | X-ROW | SSP0020_Delegate.Validation_Check | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SSP0020_Delegate.Validation_Check: 진입점 집계 19검사 — PASS:10 · NA:7 · FAIL:2 (FX-SSP0020-007) |  | 60 (ACT:SSP0020_Delegate.Validation_Check AC) |
