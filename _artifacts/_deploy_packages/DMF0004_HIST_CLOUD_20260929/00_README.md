# DMF0004 — 저장 이력(_H) 복원 (클라우드 이관)

| 항목 | 값 |
|---|---|
| 패키지 | `DMF0004_HIST_CLOUD_20260929` |
| 대상 화면 | **DMF0004 — Sales Site** (Site / Customer / Sales Location / Bucket 저장) |
| 범위 | **DB 전용** (FE / BE 변경 없음 · PROC_M/API_M/BTN_MPG 변경 없음 · 신규 MSG/LBL/MNU 없음) |
| 사내 적용 | **완료 · 검증 PASS** (222.110.191.243:2521/ZIOUI1 / SCM_MGR, 2026-09-28) |
| 클라우드 | **미적용** |
| 원문 | 사내 USER_SOURCE 재추출 2026-09-29 08:59 (각 파일 1행 `SOURCE-FRESH` · 24h 초과 시 재빌드) |
| 사내 적용 산출물 | `_artifacts/_apply_corporate/DMF0004_HIST_20260928/` |
| 관계 | **이 패키지가 DMF0004 정본.** `DMF0082_EXRATE_DMF0004_HIST_CLOUD_20260928` 의 21~25 는 구판(고정 컬럼) — DMF0004 는 이 패키지로 적용 |
| 개정 | **rev2 (2026-09-29 09:xx)** — 클라우드 23 컴파일 오류 `ORA-00904 "S"."DEPT_ID"`(1511행) 조치. 아래 §0 |

---

## 0. rev2 — 클라우드 컴파일 오류 조치 (2026-09-29)

| 항목 | 내용 |
|---|---|
| 증상 | 클라우드 `23_PKG_DMF0004_BODY.sql` 적용 시 `1430/7 SQL Statement ignored` · `1511/14 ORA-00904 "S"."DEPT_ID"` |
| 원인 | 클라우드 `SCM_MST_SITE` 는 **DEPT_ID 삭제 완료**(영향도 분석·적용 완료 — 사용자 확인). 1차본 `P_PR_DM_MST_SITE_HIST` 가 사내 SITE 39컬럼을 **고정 목록**으로 박아 `S.DEPT_ID` 참조 |
| 조치 | `P_PR_DM_MST_SITE_HIST` = 실행 시점 **SCM_MST_SITE ∩ SCM_MST_SITE_H 공통 컬럼 동적 INSERT** (`[E20260929-D4HISTDYN]`) — DEPT_ID 유무와 무관하게 컴파일·동작. 사내 선적용·검증 PASS (컴파일 오류 0 · 멤버 +1/ROLLBACK 0) |
| 21 보강 | `_H`/SITE 에 DEPT_ID 가 없어도 SKIP (있으면 NULL 허용·기본값 없음으로만 정리 — 비파괴) |
| PKG_DMF0004 잔여 DEPT_ID | 주석 블록(L292·294) + FN 인자 `P_DEPT_ID`(SITE 컬럼 아님) 뿐 — SITE.DEPT_ID 정적 참조 **0** |
| 클라우드 재적용 | 00 [H3] = **`MATCH_PREV_0929_1ST`** (클라우드에 오류본 적재 상태) 확인 → **23 만 재실행** → 24 → 90. 22(SPEC)는 1차에 정상 적용됐으면 [H2] `MATCH_AFTER` → SKIP |

---

## 1. 결함 · 변경

AS-IS 는 저장 SP 4종이 저장마다 이력 SP(`*_HIST`)를 호출해 `_H` 테이블에 기록했으나, TO-BE `PKG_DMF0004` 는 호출이 전부 주석/누락이었다.

| 저장 SP | 이력 | 위치 | AS-IS 근거 |
|---|---|---|---|
| `P_DMF0004_SAVE_SALES_SITE_DATA` | `P_PR_DM_MST_SITE_HIST` (저장 후 SITE 행 복사) · 공용 `PR_DM_MST_SITE_CUSTOMER_HIST('ALL','ALL','N')` (Modify·Active=N) | DML 직후 / COMMIT 후 | L349·L367·L546 |
| `P_DMF0004_SAVE_SALES_SITE_CUSTOMER_DATA` | 공용 `PR_DM_MST_SITE_CUSTOMER_HIST` (행 값) | COMMIT 후 | L166·L457 |
| `P_DMF0004_SAVE_SALES_SITE_LOCATION_DATA` | `P_PR_DM_MST_SITE_SLOC_MAPPING_HIST` (AS-IS 인자 1:1) | UPSERT 직전 | L222·L305 |
| `P_DMF0004_SAVE_SALES_SITE_BUCKET_DATA` | `P_PR_DM_MST_BUCKET_CONVERSION_HIST` (AS-IS 인자 1:1) | UPDATE/INSERT 직전 | L179·L288 |

### 이력 SP 처리 — 호출처 전수 조사 (AS-IS sys.sql_modules·msdb JOB·C# / TO-BE ALL_SOURCE·DEPENDENCIES·SCHEDULER_JOBS·PROC_M·API_M·nscm-be)
| HIST | 호출처 | 처리 |
|---|---|---|
| `PR_DM_MST_SITE_HIST` | DMF0004 전용 | PKG 합류 + standalone 삭제 |
| `PR_DM_MST_SITE_SLOC_MAPPING_HIST` | DMF0004 전용 | PKG 합류 + standalone 삭제 |
| `PR_DM_MST_BUCKET_CONVERSION_HIST` | DMF0004 전용 | PKG 합류 + standalone 삭제 |
| `PR_DM_MST_SITE_CUSTOMER_HIST` | DMF0004 + DMF0008 + SCP0001 | **standalone 유지 · 본문 무수정** |

### 설계 결정 (사용자 확정 2026-09-28)
1. **SITE 이력 = 저장 후 행 복사** — TO-BE Site 저장은 기존 행에 일부 컬럼만 UPDATE 하므로, AS-IS 처럼 입력값을 인자로 넘기면 저장되지 않은 값이 이력에 남는다.
2. **합류 멤버의 내부 COMMIT/ROLLBACK 제거** — 저장 루프 안 중간 커밋(부분 저장) 방지. 그 외 본문 무수정.
3. **공용 CUSTOMER_HIST 는 저장 COMMIT 후 호출** — 내부 COMMIT 보유 + SCP0001 이 그 COMMIT 에 의존해 본문 수정 불가.

### SCM_MST_SITE_H = SCM_MST_SITE 컬럼 + 이력 컬럼 2개
| 항목 | 적용 전 | 적용 후 (= SCM_MST_SITE) |
|---|---|---|
| 구성 | — | `HISTORY_SEQ` + SITE 39컬럼(동일 순서·타입) + `HISTORY_CREATION_DATE` |
| SCM_SITE_ID | VARCHAR2(30 CHAR) | VARCHAR2(60 CHAR) |
| DEPT_ID | 10번째 · NOT NULL · DEFAULT ON NULL '-' | 맨 끝 · NULL 허용 · 기본값 없음 |
| VALID_YN | DEFAULT ON NULL '-' | DEFAULT 'N' · NOT NULL |
| 감사 4컬럼 | NULL 허용 | **NULL 허용 유지** (AS-IS _H 동일 · SCP0001 `PR_SCM_MST_SITE_HIST` 가 화면 CREATION_DATE 를 그대로 전달) |

- 순서 재배치 = INVISIBLE→VISIBLE (데이터 이동 없음 · PK/권한/시노님/주석 보존).
- ⚠ `DEFAULT ON NULL` 은 NOT NULL 을 내포 — 기본값 변경으로 ON NULL 을 풀면 NOT NULL 도 같이 풀린다(사내 실측). 21 이 VALID_YN NOT NULL 을 재설정한다.

---

## 2. 작업 ↔ 파일 대조표 (적용 순서)

| 순서 | 파일 | 내용 | 전제 / 멱등 |
|---|---|---|---|
| 1 | [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) | READ-ONLY 선판정 | — |
| 2 | [A_DB/21_SCM_MST_SITE_H_ALIGN.sql](A_DB/21_SCM_MST_SITE_H_ALIGN.sql) | _H 백업 CTAS(`SCM_MST_SITE_H_BAK20260928`) + 정합 DDL (조건부 PL/SQL) | [C1] MISSING=0 · [C3] NULL_VALID_YN=0 · 멱등(SKIP) |
| 3 | [A_DB/22_PKG_DMF0004_SPEC.sql](A_DB/22_PKG_DMF0004_SPEC.sql) | SPEC — 이력 멤버 3종 선언 | **[H2]=MATCH_BEFORE** · CREATE OR REPLACE |
| 4 | [A_DB/23_PKG_DMF0004_BODY.sql](A_DB/23_PKG_DMF0004_BODY.sql) | BODY — 저장 SP 4종 배선 + 멤버 3종 | **[H3]=MATCH_BEFORE** · 2 선적용 필수 |
| 5 | [A_DB/24_RECOMPILE_INVALID.sql](A_DB/24_RECOMPILE_INVALID.sql) | _H·PKG 의존 INVALID 동적 재컴파일 | 멱등 |
| 6 | [A_DB/25_DROP_STANDALONE_HIST.sql](A_DB/25_DROP_STANDALONE_HIST.sql) | standalone 3종 + SCMP_APP 시노님 DROP (시노님 먼저) | [E] 외부 호출처 0 · 멱등(SKIP) |
| 7 | [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) | 값 단언 V1·V3·V4·V5 (드라이런 ROLLBACK) | 조회 전용 |

롤백 전용 (평소 실행 안 함): [99_ROLLBACK_PKG_DMF0004.sql](A_DB/99_ROLLBACK_PKG_DMF0004.sql)(SPEC+BODY 적용 직전본) →
[99_ROLLBACK_STANDALONE_HIST.sql](A_DB/99_ROLLBACK_STANDALONE_HIST.sql)(본문+GRANT+시노님) · [99_ROLLBACK_SCM_MST_SITE_H.sql](A_DB/99_ROLLBACK_SCM_MST_SITE_H.sql)(기본값/NULL 규칙).

---

## 3. PRECHECK 판정표

| 항목 | 기대 | 벗어나면 |
|---|---|---|
| [A] 의존 객체 | 전부 존재·VALID (시퀀스 `SEQ1_SCM_MST_SITE_H`·`SEQ1_SCM_MST_LOCATION_H`·`SEQ1_DM_MST_BUCKET_CONVERSION_H`·`SEQ1_SCM_MST_LOCATION`, `_H` 4테이블, `PR_SCM_SYS_LOG_BATCH`) | 부재 시 23 컴파일 실패 → 선행 이관 필요 |
| [H2] PKG_DMF0004 SPEC 지문 | `MATCH_BEFORE` (71줄 / 2,055자) | `MATCH_AFTER` = 이미 적용 → 3 SKIP · **`MISMATCH` = 3·4 중단**, 클라우드 본문 차이 확인 후 재빌드 |
| [H3] PKG_DMF0004 BODY 지문 | `MATCH_BEFORE` (1,403줄 / 50,884자) 또는 **`MATCH_PREV_0929_1ST`** (1,824줄 / 67,889자 = 1차 오류본) | `MATCH_AFTER`(1,758줄 / 66,725자) = 적용 완료 · 그 외 `MISMATCH` = 중단 |
| [H4] PR_DM_MST_SITE_CUSTOMER_HIST 지문 | `MATCH` (195줄 / 5,859자) | 시그니처(7인자) 동일하면 동작 무관 — 다르면 4 컴파일 오류로 드러남 |
| [C1] SCM_MST_SITE 컬럼 차이 | 참고용 (클라우드 DEPT_ID 부재 = 정상) | rev2 부터 동적 컬럼이라 차단 사유 아님 |
| [C3] _H NULL VALID_YN | 0 | 2 의 NOT NULL 재설정 실패 → 데이터 정리 후 진행 |
| [E] standalone 3종 외부 호출처 | 0행 (시노님은 SCMP_APP.PKG_DMF0004 만) | 6 보류 |

> 지문 = `USER_SOURCE` 줄수 + `SUM(LENGTH(RTRIM(TEXT, CR/LF)))`. 사내 객체에서 파이썬 산출값 = DB 산출값 확인.
> ⚠ PKG_DMF0004 는 이전 이관 패키지 이력이 없다 — 클라우드에 다른 작업자 변경이 있으면 MISMATCH 로 걸러진다.

---

## 4. 사내 사전 실행 결과 (이 패키지를 사내 ZIOUI1 = 적용 후 상태에 그대로 실행, 2026-09-29)
- 00: H2·H3 `MATCH_AFTER` · H4 `MATCH` · C1 0 · C3 0(6,681행) · E 외부 호출처 0
- 21: SKIP ×5 / 24: INVALID 0 / 25: SKIP ×6
- 90: V1 전부 VALID · V3 BAD=0 · V4 6,681=6,681 · V5 +1/+1/+1 → ROLLBACK 후 0/0/0
- 저장 SP 4종 실데이터 E2E (사내 2026-09-28, 사용자 승인 · 재저장 후 원복): SITE_H 1 · CUSTOMER_H 1 · LOCATION_H 1 · BUCKET_H 7 — 원복 후 잔여 0

## 5. 주의
- 데이터 DML 0건 (백업 CTAS 1건 제외). 사내 전값 WHERE 없음.
- 적용 후 `_H` 를 쓰는 타 화면 객체(DMF0008·SCP0001 계열)가 INVALID 로 전이된다 → 5(24) 필수.
- 클라우드 Location 저장은 기존 검증("존재하지 않는 Storage")이 그대로 적용된다 — 사내 실측에서 SLOC 미등록 Storage 행(예: Dualtron_CN_JHA/6000)은 저장 거부됨 (본 변경 무관).
