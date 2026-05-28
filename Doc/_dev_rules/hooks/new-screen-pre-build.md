# Hook: 신규 화면 생성 직전 자기 점검 (new-screen-pre-build)

> 사용자가 화면 신규 생성을 요청한 직후, To-Be 코드 작성 **첫 줄을 쓰기 전에** 본 hook 을 자기 실행한다.
> 모항목 ✅ 가 아니면 코드 작성 중단.
>
> 작성: 2026-05-22
> 관련 룰: 25_NEW_SCREEN_MANDATORY_CHECKLIST.md / 17_NEW_SCREEN_QUICKSTART.md / hooks/anti-simplification.md

---

## 적용 시점

다음 트리거 키워드 감지 시 첫 응답 작성 전:
- 한국어: "화면 생성", "화면 추가", "신규 화면", "화면 만들어", "화면 개발", "화면 작성", "to-be 화면"
- 영어: "create screen", "new screen", "add screen", "build page", "new page"
- 화면 ID 단독 + 생성 동사 (예: "DMF0099 만들어줘")

---

## 자기 점검 9 항목

```
[ ] 1. SCREEN_ID 확인 — 사용자가 명시? 또는 docs/_analysis 에 폴더 존재?
[ ] 2. 도메인 추정 — DM / Common / SCM / SCP / SSP / FP 중 어느 것?
[ ] 3. AS-IS .cs / .Designer.cs 위치 식별 — Doc/_legacy_source 하 검색 (변종 여러 개 있을 수 있음)
[ ] 4. AS-IS .cs Read 완료 — Validation / Expression / 동적 배치 / 호출 POPUP 전부 추출
[ ] 5. AS-IS .Designer.cs Read 완료 — 컨트롤 Location/Size 추출
[ ] 6. 화면별 8 MD Read 완료 — validation.md / expressions.md / popups.md 필수
[ ] 7. 화면 xlsx (12 시트) Read 또는 PowerShell 추출 완료
[ ] 8. 호출 POPUP 목록 작성 + 신규 생성 vs 기존 활용 분기 결정
[ ] 9. 룰 25 §2 의 사전 확인 결과 표 사용자에게 출력
```

위 9항목 중 1건이라도 ❌ → **사용자에게 보고 + 보강 후 재진행**.

---

## 핵심 의문 (자기 점검 후 답변할 것)

### Q1. AS-IS 가 없는 신규 화면 (마이그레이션 아님) 이면?

→ §1.1 AS-IS 자료 Read 생략. 다만 사용자에게 "AS-IS 없음을 확인" 명시 보고. 화면 분석서 xlsx + 8 MD 는 To-Be 단독 분석서가 있을 수 있으므로 우선 확인.

### Q2. 화면 분석서가 미작성된 신규 SCREEN_ID 이면?

→ **즉시 사용자에게 보고**. 화면 분석서 작성이 선행되어야 함 (룰 20). 화면 분석서 작성을 사용자가 별도 요청하지 않는 한 임의로 화면 코드 작성 금지.

### Q3. AS-IS `.cs` 가 여러 변종 (Master.UIL / Plan.UIL / Forms.UIL) 으로 존재?

→ `__asis-mapping__.md` (있으면) 의 "As-Is 소스" 라인 1차 신뢰. 없으면 가장 큰 파일 (line count) 을 canonical 로 가정하되 사용자에게 변종 목록 보고 후 확인.

### Q4. POPUP 신규 생성이 트리거되었는데 POPUP 의 AS-IS `.cs` 가 별도 SCREEN_ID 인 경우?

→ 해당 POPUP 의 SCREEN_ID (예: `DMF0020_POPUP_ExchangeRate`) 에 대해 본 hook 재귀 적용. 단 사용자 별도 승인 필요 — 임의로 N 개 화면 동시 작성 금지.

### Q5. 동적 배치 (`.Visible = ...`) 가 발견됐는데 JSX 조건부 표현이 어색한 경우?

→ AS-IS 의도 보존 우선. 조건부 렌더 (`{cond && <X>}`) 또는 disabled prop 중 AS-IS 가 `Visible = false` 이면 조건부 렌더, `Enabled = false` 이면 disabled. 임의 변환 금지.

---

## 위반 시 결과

본 hook 누락으로 발생한 사고 사례:

| 일자 | 화면 | 사고 | 원인 |
|---|---|---|---|
| 2026-05-22 | DMF0020 | `Sales Price Template` 버튼이 모든 사업부에 표시 (AS-IS 는 ESS only) | AS-IS `.cs` L205, 2581 의 `btnTemplate.Visible = (div==81)` 누락 |
| 2026-05-22 | DMF0020 | Popup 버튼 5개 모두 default size 로 spread | AS-IS Designer.cs 의 119~136×25~26 px compact 사이즈 미반영 |

---

## 함께 읽을 자료

- `Doc/_dev_rules/25_NEW_SCREEN_MANDATORY_CHECKLIST.md` (본 hook 의 상위 룰)
- `Doc/_dev_rules/hooks/anti-simplification.md` (자료 누락 = 단순화 = 위반)
- `Doc/_dev_rules/24_ASIS_CROSSCHECK.md` (4축 매핑 — Event/API/Validation/Expression)
- `Doc/_dev_rules/17_NEW_SCREEN_QUICKSTART.md` (9-step 진행)
- `Doc/_dev_rules/20_SCREEN_ANALYSIS_PIPELINE.md` (분석서 미작성 시)
