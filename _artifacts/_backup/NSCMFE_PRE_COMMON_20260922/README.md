# 공통소스 다운로드 적용 보고 — 2026-09-22

| 항목 | 값 |
|---|---|
| 원천 | `eunjoo-hwang/nscm-fe.git` (remote `common`, push=`no_push` 유지 확인) |
| 직전 기준선 | `03dfab78` (2026-09-21) |
| **신규 기준선** | **`77d024d4` (2026-09-22 "fix(SCP0006): Project Route F4 필터를 포커스된 그리드에 걸리도록 수정")** |
| fetch 유형 | fast-forward (`03dfab78..77d024d4`, is-ancestor 확인) — force-push 아님 |
| 범위 | `apps` · `features` · `packages` · `public` 4폴더 (+ d.ts 동반 1) |
| 변경 파일 | **86** (M 51 / A 31 / R 4) · 공통 커밋 107건 |
| 정적검증 | **미수행** (사용자 상시 지시 — 요청 시 `fe-check.ps1`) |

## 1. 분류·처리

| 분류 | 건수 | 처리 |
|---|---:|---|
| 공통 채택 (로컬 = 직전기준선) | 44 | 공통본 덮어쓰기 |
| 신규 파일 | 31 | 추가 — SCP0007 BOD 화면 세트 · SCP0023 Outsourcing Capacity 화면 세트 · master CapaNewModel 팝업 등 |
| 이름변경 | 4 | supply/components → master/components (ModelByDivision·ProjectByDivision 팝업+스토어) — 구 경로 삭제 |
| 3-way 자동병합 | 1 | `packages/foundation/src/utils/gridAction.ts` (base `996e4104`, 충돌 0) — 로컬 2단 헤더 Excel Form + 공통 개선 |
| locales 키 병합 | 2 | EN 999→1474 / KO 1053→1525 — 09-15 원칙(공통 키 추가 + **로컬이 바꾼 값 유지**) |
| **충돌 — 로컬 유지(결정 대기)** | **4** | 아래 §2. 공통판은 `common_conflict/` 에 보관 |
| d.ts 동반 | 1 | `configs/types/procedures.d.ts` **SCP0023 블록 35줄** 공통 원문 verbatim 삽입(SCP0022 뒤, 로컬 L5451) — 신규 Outsourcing Capacity 화면용 |

전체 목록 = `adopted_files.txt` · 적용 전 원본 = `local_before/` · 작업트리 패치 = `local_worktree.patch`

## 2. ⚠ 충돌 4건 — 로컬 유지, 사용자 결정 대기

| 파일 | 로컬 | 공통 | 비고 |
|---|---|---|---|
| `features/demand/.../etc-sales-reports/utils/etc-sales-reports.editLock.ts` | 2026-09-22 DMF0049 "BIZ×RESULT 동적 컬럼 편집" — AS-IS L414~460 1:1 (BP 전 메저 편집 · SP_W 당해 외 연도 AS-IS 동작) | `39fc1695` Jeongyun Park 09-22 "etc sales report BP result 입력허용" — BP 는 Result 도 Plan 규칙(81/82 허용 메저만), 커밋 주석 "사용자 확정" | 같은 요구를 양쪽이 각자 구현 |
| `features/demand/.../forecast-price/utils/forecast-price.excelForm.ts` | 09-21 DMF0082 Excel Form 메타 주도(`pruneEmptyInfoColumns` 포함) | `93631587` BeomJu 09-22 "109번 수정사항 반영" — 같은 기능(메타 주도·19컬럼 fallback) + 요청 경합 방지·로딩 상태, `TEMPLATE_META_SHEET` constants 이동 | 3파일 한 세트 — 같이 결정 |
| `features/demand/.../forecast-price/useForecastPriceStore.ts` | 〃 | 〃 | 〃 |
| `features/demand/.../forecast-price/components/modals/ForecastTemplateModal.tsx` | 〃 | 〃 | 〃 |

- 로컬 유지 상태에서 짝 정합: 이번 공통채택 중 forecast-price 는 `forecast-price.constants.ts` 1건뿐(`TEMPLATE_META_SHEET` export 추가)이라 로컬 3파일과 충돌 없음.

## 3. locales 참고

EN 의 로컬 유지 70키는 **영어 파일에 한국어 값**(예 MSG00606 '저장되었습니다.'), KO 의 11키는 **한국어 파일에 영어 값**이다.
어떤 공통 이력본과도 일치하지 않는 로컬 전용 값이라 원칙상 유지했으나, 과거 DB 동기화/생성 도구 흔적일 가능성이 있다 — 검토 필요.
충돌 1키(EN `MSG00025`: 공통 삭제 / 로컬 '_Please enter all required values.')도 로컬 유지.

## 4. 사후 점검

- 공통채택·신규·이름변경 79건 = 공통 blob 과 내용 동일(개행 정규화) 79/79
- 이름변경 구 경로 잔존 0 · 구 경로 import 잔존 0
- `gridAction.ts` 병합: 충돌 마커 0 · 최상위/메서드 중복 선언 0
- d.ts 중괄호 876/876 · SCP0023 1블록
