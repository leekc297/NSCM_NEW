# 공통소스 반영 백업 — 2026-08-31 (기준선 08326f42 → 76a1cffd)

## 개요
- 원천: `https://github.com/eunjoo-hwang/nscm-fe.git` (remote `common`, 다운로드 전용·push=no_push)
- 공통 HEAD: **`76a1cffd`** (2026-08-30 22:18 "297 -> atlas 적용") — 직전 기준선 `08326f42`(08-27 적용) 의 직계 후손 (force-push 없음, 신규 커밋 8건)
- 대상 축: apps/features/packages/public 4폴더 diff 120파일 + `configs/types/procedures.d.ts` (블록 병합)
- 판정법: 메모리 `reference-repo-upload-download-commands` §"내 것이 더 최신이면 내걸로" (2026-08-25 확립) — mtime 금지·내용 대조(개행 정규화 + 공통 전 이력 + rename 추적), Python 바이너리 I/O 적용
- 사용자 지시: **"내가 가진 소스가 더 최신이면 내 것 유지"**

## 분류 결과 (120 + d.ts)
| 분류 | 건수 | 처리 |
|---|---:|---|
| SAME (로컬==공통) | 19 | no-op |
| ADD (로컬 부재 신규) | 28 | 공통본 작성 — cust-psi-upload 화면 11파일 + 모달 store 분리 17파일 |
| ADOPT_COMMON (로컬==기준선) | 45 | 공통본 덮어쓰기 (내 편집 없음 확인) |
| BOTH_CHANGED (양쪽 수정) | 2 | PriceBatchInputModal.tsx = 3-way 깨끗한 병합(내 08-23 수정 + 공통 store 분리 공존) / OlapPivotGrid.tsx = 공통 델타가 로컬에 이미 포함 → **로컬 유지(변경 0)** |
| CONFLICT_ADD (공통 신규 = 내 소스 역수입) | 25 | **전부 로컬 유지** — 공통 08-28 "이규철이사 소스 동기화 1/2" 는 내 08-27 상태 스냅샷, 로컬은 08-28 이후 작업(UM-01 Division 기본선택·UM-07/08·RAIL 후속) 포함으로 엄밀히 최신. 대상 화면 3본 = cust-fcst-waterfall / mkt-fcst-comparison / demand-plan-waterfall(DMF0035) |
| DELETE (공통 삭제·로컬==기준선) | 1 | `packages/shared/src/stores/useDirtyRegistry.test.ts` 삭제 |
| KEEP_LOCAL_ON_DELETE / LOCAL_IS_OLD_COMMON_COPY | 0 | — |

## procedures.d.ts (범위 외 — 별도 블록 병합)
- 공통 +473줄 (DMF0013/0035/0040/0053 4블록). 로컬도 수정 상태 → 3-way 충돌 → **블록 단위 판정**:
  - DMF0013 (CustPsiUpload — 로컬 부재) → 공통 블록 87줄 발췌, 로컬 DMF0014 블록 뒤 삽입
  - DMF0035/0040/0053 → 로컬 보유 — 본문은 공백 정규화 기준 공통과 동일(0035 는 doc 주석만 상이) → 로컬 유지
- 전체본 덮어쓰기 ⛔ 준수 (hook #148 d.ts 블록 경계)

## 검증
- `fe-check.ps1 type-check` (넥서스 미접속·pnpm 10.28.2 고정): **13/13 패키지 통과** (2026-08-31)
- gen:i18n 은 API 미접속으로 locales 보존 중단 — 정상 가드 (목데이터 덮어쓰기 금지)

## 원복 자료
- `nscm-fe/` 하위 = 덮어쓰기·삭제·병합 대상 로컬 원본 48파일 (ADOPT_COMMON 45 + DELETE 1 + PriceBatchInputModal 1 + procedures.d.ts 1)
- `classify_result.json` = 120파일 분류 전량
- 원복 = 해당 경로에 그대로 복사 + ADD 28파일 삭제 + DMF0013 블록 제거
