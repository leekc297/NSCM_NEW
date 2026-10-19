# 공통소스 다운로드 적용 보고 — 2026-09-17 (2차)

| 항목 | 값 |
|---|---|
| 원천 | `eunjoo-hwang/nscm-fe.git` (remote `common`, push=`no_push` 유지) |
| 직전 기준선 | `410bd38b` (2026-09-17 09:37) — 같은 날 1차 |
| **신규 기준선** | **`a53fe246` (2026-09-17 13:24 "fix: demand plan waterfall 231 235 236 237")** |
| fetch 유형 | fast-forward (`410bd38b..a53fe246`) — force-push 아님 |
| 범위 | `apps` · `features` · `packages` · `public` 4폴더 (+ d.ts 동반 1, §4) |
| 변경 파일 | 20 (M 3 / A 17) · 공통 커밋 18건 |
| 정적검증 | **미수행** (사용자 상시 지시 2026-09-02 — 요청 시 `fe-check.ps1`) |

## 1. 분류

| 분류 | 건수 | 처리 |
|---|---:|---|
| 공통 채택 (로컬 = 직전기준선) | 3 | 공통본 그대로 덮어쓰기 |
| 이미 동일 | 0 | — |
| **3-way 병합 (로컬 편집본)** | **0** | 1차 이후 대상 파일 로컬 무편집 |
| 신규 파일 | 17 | 추가 |
| 로컬 구버전 충돌 | 0 | — |

## 2. 공통 채택 3건

```
apps/web/src/pages/Templates.tsx
features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx
features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx
```

공통 커밋 `a53fe246` "fix: demand plan waterfall 231 235 236 237" 반영분.

## 3. 신규 파일 17건 — SCM0002 팝업 세트 + Supply 팝업 갤러리

공통 커밋 `a91ff82a`(SCM0002 팝업 추가 — ElecMaterial/CapaItem/Project by Division) ·
`7ad0b157`(SCM0002 Model by Division 팝업, SCP0016 모1) 반영분.

```
features/supply/src/components/CapaItemPopup.tsx
features/supply/src/components/ElecMaterialPopup.tsx
features/supply/src/components/ModelByDivisionPopup.tsx
features/supply/src/components/ModelByDivisionPopup.module.scss
features/supply/src/components/OwnerByDivisionPopup.tsx
features/supply/src/components/PlaceholderPopup.tsx
features/supply/src/components/PlaceholderPopup.module.scss
features/supply/src/components/ProjectByDivisionPopup.tsx
features/supply/src/components/SalesReportPopup.tsx
features/supply/src/components/SupplyPopupGallery.tsx
features/supply/src/components/VersionPopup.tsx
features/supply/src/components/capaItemPopupStore.ts
features/supply/src/components/elecMaterialPopupStore.ts
features/supply/src/components/modelByDivisionPopupStore.ts
features/supply/src/components/projectByDivisionPopupStore.ts
features/supply/src/components/index.ts
features/supply/src/pages/popup-gallery/index.ts
```

## 4. ⭐ 동반 조치 — `configs/types/procedures.d.ts` SCM0002 블록 삽입

신규 팝업 4본이 로컬 d.ts 에 없는 `ProcedureMap` 키를 요구했다. **공통에 발췌 원본이 있어** 종전 방식
(COM0008 / DMF0013 회차와 동일)대로 블록을 원문 그대로 동반 삽입했다.

| 항목 | 값 |
|---|---|
| 요구 키 | `SCM0002.ModelPopup` · `.ElecPopup` · `.ProjectByDivPopup` · `.CapaItemPopup` |
| 호출 지점 | `ModelByDivisionPopup.tsx:118` · `ElecMaterialPopup.tsx:111` · `ProjectByDivisionPopup.tsx:94` · `CapaItemPopup.tsx:92` |
| 삽입 전 로컬 | `SCM0002` 블록 **0건** |
| 공통 원본 | `configs/types/procedures.d.ts` L2510, 84행, 시트 키 4개 — 필요 키와 정확히 일치 |
| 삽입 위치 | 로컬 L5445 (`RawProcedureMap` 닫힘 직전) |
| 삽입 방식 | Python 바이너리 I/O · 개행 LF 유지(로컬 실측 CRLF 0 / LF 5,497) · 원문 verbatim |

블록 말미가 `  }`(세미콜론 없음)인 것은 **공통 원문 그대로**다(공통 L2593 실측 대조 완료).

> ⚠️ 1차(오전) 회차의 미해소 건(SCP0013 `main`/`load` 키)과는 **다른 사안**이다.
> 그쪽은 공통에 SCM0013 d.ts 원본이 0건이라 발췌가 불가능해 여전히 미해소 상태다 —
> `_artifacts/_backup/NSCMFE_PRE_COMMON_20260917/README.md` §5 참조.

## 5. 무결성 점검

| 점검 | 결과 |
|---|---|
| 대상 20파일 공통본 바이트 일치 (개행 정규화) | **20/20** |
| 충돌 마커 | **0** |
| 값 import 중복 | **0** |
| 신규파일 상대 import 해소 | **0 미해소** |
| 신규파일 외부 alias | `@shared/*` · `@foundation/*` · `@mescius/*` 만 — Feature 간 직접 import **0** |
| d.ts 중괄호 균형 | **0** (증감 없음) |
| d.ts 최상위 MENU 키 중복 | **0** (61키) |
| d.ts 요구 시트 키 정합 | 4/4 |

## 6. 범위 밖 (미반영)

공통 커밋 18건 중 아래는 4폴더 밖(분석기·문서·스킬)이라 받지 않았다.

- `0fad96ea` roslyn 정적분석기 1.2 · `b8afe869` roslyn 분석 수정
- `8bc802db` / `9430e462` / `64ba756a` / `469347ed` / `70e95f3c` / `83f9a57b` convert-* 문서·툴
- `bfca7aaf` SCP0013 analyze_menu 상세설계 · `e8d1cd45` 화면 QA 체크리스트 · `05f479fe` screen-modification-checklist
- `6bd3b412` skill.md · `2f90162a` 경로 수정 · `da3aa466` merge

## 7. 원복 자료

- `local_before/` — 적용 직전 로컬 원본 **4파일** (공통 채택 3 + `configs/types/procedures.d.ts` 1). 신규 17은 원본 없음 → 삭제로 원복
- `local_worktree.patch` / `local_git_head.txt` / `local_git_status.txt` (506행)
- `adopted_files.txt` — 기록한 20파일 목록
