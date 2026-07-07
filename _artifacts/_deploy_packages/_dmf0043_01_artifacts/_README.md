# DMF0043_01 (ContributeView) — 클라우드 이관 (Excel 동적컬럼 누락 수정)

- 작성: 2026-07-07
- 화면 ID: **DMF0043_01** (ContributeView) | 도메인: `master` | slug: `contribute-view`
- 범위: **FE 1파일** (BE/DB 무변경)

## 1. 이관 대상

```
fe/features/master/src/pages/contribute-view/components/ContributeViewGrid.tsx   ← 화면 전용
fe/packages/foundation/src/utils/gridAction.ts       ← ⚠️ 공통 (전 화면 Excel/Grid 액션)
fe/packages/foundation/src/utils/mergeManager.ts     ← ⚠️ 공통 (gridAction import 의존)
```

## 2. 변경 내용

### 2.1 `ContributeViewGrid.tsx` (화면 전용) — Excel 헤더 머지 UI 그대로
- 동적 컬럼을 **지역(large)별 group + Commission/Markup(leaf) 2개**로 묶음 (인접 동일 지역 병합).
- + 동적 컬럼 group/leaf 에 `visible: true` 명시(미명시 시 export 에서 hidden → 컬럼 누락).
- 결과: Excel 다운로드 시 **상단(지역)=가로 머지 / 하단(leaf)=미머지 / 정적=세로 머지** — UI 그대로.

### 2.2 `gridAction.ts` (⚠️ 공통) — 다단 헤더 유지 Excel export
- `excelDownload` 의 **다단 헤더 경로(`headerDepth > 1`)** — columnGroups 트리로 Excel 헤더 행을 수동 구성(colSpan/rowSpan 병합). **미커밋 상태 = 클라우드 미배포**였음 → 클라우드에서 머지가 전혀 안 되던 근본 원인.
- ⚠️ **전 화면 공통** — Excel 다운로드/Grid 액션 전반에 영향. depth 1(단일 헤더) 화면은 기존 경로 그대로(회귀 0), 실패 시 평탄화 폴백 내장.

### 2.3 `mergeManager.ts` (⚠️ 공통) — gridAction 의존 (요청 포함)
- `CustomMergeManager` (gridAction 이 import). 함께 이관.

## 3. 적용

```bash
# 화면 전용
cp fe/features/master/src/pages/contribute-view/components/ContributeViewGrid.tsx \
   nscm-fe/features/master/src/pages/contribute-view/components/ContributeViewGrid.tsx
# ⚠️ 공통 (전 화면 영향 — diff 검토 후 반영 권장)
cp fe/packages/foundation/src/utils/gridAction.ts   nscm-fe/packages/foundation/src/utils/gridAction.ts
cp fe/packages/foundation/src/utils/mergeManager.ts nscm-fe/packages/foundation/src/utils/mergeManager.ts
```

## 4. 검증
- 조회 후 Excel Download → 정적 컬럼(세로머지) + 동적 지역(가로머지) + leaf(미머지) 가 **화면과 동일**하게 export.
- ⚠️ `gridAction.ts` 는 공통이므로 **다른 화면 Excel 다운로드**도 함께 정상인지 확인 권장.

## 5. BE/DB
- 무변경.
