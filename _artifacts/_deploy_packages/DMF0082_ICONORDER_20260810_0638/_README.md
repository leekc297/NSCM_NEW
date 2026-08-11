# DMF0082 (Fcst&Price MGMT) 클라우드 이관 — 아이콘 버튼 순서 정렬 (2026-08-10)

> **목적**: hook #120 개정(2026-08-10 사용자 지시)에 따른 **FE 단독 변경**.
> **DB 변경 없음.**

---

## 1. 변경 내용

타이틀 아이콘 버튼 순서를 **왼쪽부터 `환율 → Grid Column Set → Measure`** 로 통일(hook #120 최종 확정).

| 화면 | 변경 전 | 변경 후 |
|---|---|---|
| DMF0082 Forecast&Price | Excel Form / Price Batch Input → **환율 / Measure / Column** | Excel Form / Price Batch Input → **환율 / Column / Measure** |

- 대상 파일: `features/demand/src/pages/forecast-price/ForecastPrice.tsx` (`customButtons` 배열 순서만)
- 동작·권한·핸들러 무변경 — **배열 선언 순서**만 바꿨다.

> 같은 배치의 DMF0044 / DMF0042 / DMF0049 도 동일 정렬됐다(각 패키지 `fe/` 에 포함).
> DMF0020(2026-07-01 확정 순서)은 **본 룰과 일치**하므로 무변경.

---

## 2. 적용

| # | 대상 | 반영 위치 |
|---|---|---|
| 1 | `fe/forecast-price/` (28파일) | `nscm-fe/features/demand/src/pages/forecast-price/` |

> ⚠️ **폴더 통째 교체 의무** — 파일 단위 덮어쓰기 금지 (`feedback_cloud_shell_generation_mismatch`).
> ⚠️ 이 폴더에는 2026-08-07 UICATEGORY 이후의 사내 최신본이 들어 있다. 더 최신 DMF0082 패키지가 있으면
> 그쪽을 기준으로 하고 **아이콘 순서 변경분만** 반영할 것.

---

## 3. 검증

```bash
# 파일 내 3 아이콘 등장 라인이 오름차순이어야 통과 (환율 < Column < Measure)
grep -n "IcMeasureSelect />"   features/demand/src/pages/forecast-price/ForecastPrice.tsx
grep -n "IcGridColumnSetup />" features/demand/src/pages/forecast-price/ForecastPrice.tsx
grep -n "IcExchangeRate />"    features/demand/src/pages/forecast-price/ForecastPrice.tsx
```

사내 실측(2026-08-10): `exchange=436 / column=443 / measure=450` — 오름차순 ✅

화면 육안: 타이틀 우측 아이콘이 **환율 → 컬럼설정 → 메저** 순으로 보이는지 확인.

⚠️ **lint·type-check 는 클라우드 셸에서 사용자가 실행**(로컬 실행 금지 룰).

---

## 4. MSG / LBL / MNU / BTN·API·CMBO 감사

| 분류 | 신규/변경 |
|---|---|
| 전 분류 | **0** — 배열 순서만 변경(라벨·권한·핸들러 무변경) |
