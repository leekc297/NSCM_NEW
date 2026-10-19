# [E20260928-D4HIST] DMF0004 저장 이력(_H) 복원 — 사내 ZIOUI1 적용 2026-09-28

## 요구
1. DMF0004 저장 시 `_H` 미저장 → AS-IS 이력 복원
2. `_H` 저장 SP: 타 호출처 있으면 standalone 유지 / 없으면 PKG_DMF0004 합류 후 호출
3. `SCM_MST_SITE_H` = 변경된 `SCM_MST_SITE` 컬럼 + HISTORY 컬럼만 추가

## 호출처 판정 (AS-IS sys.sql_modules·msdb JOB·C# / TO-BE ALL_SOURCE·DEPENDENCIES·SCHEDULER_JOBS·PROC_M·API_M·nscm-be)
| HIST | 호출처 | 처리 |
|---|---|---|
| PR_DM_MST_SITE_HIST | DMF0004 전용 (AS-IS PR_DM_PLN_MKT_FCST_HIST 의 동명 문자열 = 트랜잭션명, 호출 아님) | PKG 합류 + standalone 삭제 |
| PR_DM_MST_SITE_CUSTOMER_HIST | DMF0004 + DMF0008(PKG_DMF0008·DMF0008_SAVE_SALES_SITE_EDI_REPAIR) + SCP0001(PKG_SCP0001) | **standalone 유지(본문 무수정)** |
| PR_DM_MST_SITE_SLOC_MAPPING_HIST | DMF0004 전용 | PKG 합류 + standalone 삭제 |
| PR_DM_MST_BUCKET_CONVERSION_HIST | DMF0004 전용 | PKG 합류 + standalone 삭제 |

## 사용자 결정 (2026-09-28)
1. SITE 이력 = **저장 후 행 복사** (TO-BE Site 저장은 일부 컬럼만 UPDATE → AS-IS 인자 방식은 미저장 입력값 기록)
2. 합류 멤버의 내부 **COMMIT/ROLLBACK 제거** (호출자 원자 커밋 — 루프 중 부분 저장 방지). 그 외 본문 무수정
3. 공용 CUSTOMER_HIST(내부 COMMIT·SCP0001 이 의존) = **저장 COMMIT 후 호출**

## SCM_MST_SITE_H 정합
| 항목 | 전 | 후 (= SCM_MST_SITE) |
|---|---|---|
| SCM_SITE_ID | VARCHAR2(30 CHAR) | VARCHAR2(60 CHAR) |
| DEPT_ID | 10번째 · NOT NULL · DEFAULT ON NULL '-' | 맨 끝(ATTRIBUTE10 뒤) · NULL 허용 · 기본값 없음 |
| VALID_YN | DEFAULT ON NULL '-' | DEFAULT 'N' · NOT NULL |
| 순서 | — | HISTORY_SEQ + SITE 39컬럼(동일 순서) + HISTORY_CREATION_DATE |
| 감사 4컬럼 NULL | 허용 | **허용 유지** — AS-IS _H 도 허용 + SCP0001(PR_SCM_MST_SITE_HIST)이 화면 JSON CREATION_DATE 를 그대로 전달 |
- INVISIBLE→VISIBLE 재배치(데이터 이동 없음) — PK·권한·시노님·주석 보존. 6,681건 백업 대비 차이 0.
- 백업: `SCM_MGR.SCM_MST_SITE_H_BAK20260928` (6,681건)

## 저장 SP 배선 (AS-IS 파리티)
| 저장 SP | 이력 호출 | 위치 |
|---|---|---|
| P_DMF0004_SAVE_SALES_SITE_DATA | P_PR_DM_MST_SITE_HIST(행 복사) / PR_DM_MST_SITE_CUSTOMER_HIST('ALL','ALL','N') (M·VALID_YN=N) | 저장 DML 직후 / COMMIT 후 |
| P_DMF0004_SAVE_SALES_SITE_CUSTOMER_DATA | PR_DM_MST_SITE_CUSTOMER_HIST(행 값) | COMMIT 후 |
| P_DMF0004_SAVE_SALES_SITE_LOCATION_DATA | P_PR_DM_MST_SITE_SLOC_MAPPING_HIST(AS-IS 인자 1:1) | UPSERT 직전 |
| P_DMF0004_SAVE_SALES_SITE_BUCKET_DATA | P_PR_DM_MST_BUCKET_CONVERSION_HIST(AS-IS 인자 1:1) | UPDATE/INSERT 직전 |

## 작업 ↔ 파일 대조표
| # | 작업 | 파일 | 결과 |
|---|---|---|---|
| 0 | 적용 전 원문 (spec/body/standalone 3종) | `00_before_*.sql` | 원복용 |
| 1 | _H 백업 CTAS + 정합 DDL | `01_SCM_MST_SITE_H_align.sql` | 적용 (1차 실행 중단 이력: ON NULL 내포 NOT NULL → 순서 교정 후 완료) |
| 2 | PKG spec 멤버 3종 선언 | `02_PKG_DMF0004_SPEC.sql` | VALID |
| 3 | PKG body 배선 + 멤버 3종 | `03_PKG_DMF0004_BODY.sql` | VALID, USER_ERRORS 0 |
| 4 | _H 참조 객체 재컴파일 | `05_recompile.sql` | 4종 VALID |
| 5 | standalone 3종 + SCMP_APP 시노님 DROP | `04_drop_standalone.sql` | 잔존 0 · INVALID 의존 0 |

## 검증
- 멤버 단위 (호출 후 ROLLBACK): SITE_H/LOCATION_H/BUCKET_H 각 +1, SITE_H 값 = 원행 일치, ROLLBACK 후 증감 0 (내부 COMMIT 없음)
- **저장 SP E2E (실데이터, 사용자 승인 2026-09-28)** — 기존 값 그대로 재저장(USER=CLAUDE_TEST) → _H 확인 → 감사컬럼 원복 + 테스트 이력 삭제
  | 저장 SP | 샘플 | 결과 | _H 추가 |
  |---|---|---|---|
  | SITE | 40 / Dualtron_CN_JHA | SUCCESS 1 | SCM_MST_SITE_H 1 |
  | CUSTOMER | 40 / Dualtron_CN_JHA | SUCCESS 1 | SCM_MST_SITE_CUSTOMER_H 1 (COMMIT 후 호출) |
  | LOCATION | 40 / HP_CN_CKG / 6200 | SUCCESS 1 | SCM_MST_LOCATION_H 1 |
  | BUCKET | 40 / Dualtron_CN_JHA (7요일) | SUCCESS 7 | DM_MST_BUCKET_CONVERSION_H 7 |
  원복 후 잔여 테스트 이력 0 · 감사컬럼 CLAUDE_TEST 잔존 0.
  (1차 Location 샘플 Dualtron_CN_JHA/6000 은 기존 검증 "존재하지 않는 Storage" 로 -1 — SLOC 미등록 데이터 문제, 본 변경 무관)

## 잔여
- 클라우드 DB 미적용 (이관 시 01→02→03→05→04 순서, SOURCE-FRESH 24h 초과 시 재빌드)
