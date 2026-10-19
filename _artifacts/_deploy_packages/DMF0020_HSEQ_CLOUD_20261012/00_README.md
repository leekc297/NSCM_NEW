# DMF0020 저장(INSERT 후 SAVE) 클라우드 SQL ERROR — ORA-00001 PK_SCM_MST_FUTURE_PRICE_H(HISTORY_SEQ) 검증 쿼리

> 2026-10-12 · 범위 = **검증 쿼리(00) + 확인 쿼리(02)**. 시퀀스 보정은 **사용자 별도 진행**(지시 2026-10-12) — 01 은 참고용으로만 동봉, 실행 체인에 포함하지 않음.
> DB 객체·데이터·메타·FE·BE 변경 없음. 사내 ZIOUI1 변경 없음(리허설 임시 시퀀스 생성·DROP 만, §5).

## 1. 증상 (사용자 보고 원문)

```
NCommonDAO.selectList: ORA-20001: [PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL] SQLCODE=-1
/ SQLERRM=ORA-00001: unique constraint (SCM_MGR.PK_SCM_MST_FUTURE_PRICE_H) violated on table SCM_MGR.SCM_MST_FUTURE_PRICE_H columns (HISTORY_SEQ)
/ BACKTRACE=ORA-06512: at "SCM_MGR.PKG_DMF0020", line 7044
ORA-06512: at "SCM_MGR.PKG_DMF0020", line 7269
```

## 2. 원문 대조 결과 (사내 ZIOUI1 2026-10-12 재조회 · 클라우드 09-30 적용본 `DMF0020_FXZERO_CLOUD_20260930/A_DB/11_PKG_DMF0020_BODY.sql`)

| 항목 | 값 |
|---|---|
| line 7044 (클라우드 09-30 본) | `INSERT INTO SCM_MGR.SCM_MST_FUTURE_PRICE_H` — 저장 SP 의 이력 INSERT 시작 줄 (사내 현재 본 L7067, SLASHOBJ·GRPBYFIX 로 23줄 밀림) |
| line 7269 | `RAISE_APPLICATION_ERROR(-20001, …)` — EXCEPTION 핸들러 |
| HISTORY_SEQ 채번 | `SCM_MGR.SEQ1_SCM_MST_FUTURE_PRICE_H.NEXTVAL` (클라우드 본 L7066 · 사내 L7089) |
| `SCM_MST_FUTURE_PRICE_H` PK | **`HISTORY_SEQ` 단일** (`PK_SCM_MST_FUTURE_PRICE_H`) · 트리거 0 · IDENTITY 없음 · HISTORY_SEQ DEFAULT 없음 |
| 이력 INSERT 전 경로 (사내 USER_SOURCE 전수) | PKG_DMF0020 3(Excel L2217 · 저장 L7067 · Batch L7980) + PKG_DMF0082 2(L6565 · L15151) + 단독 래퍼 `DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL` L908 · `_POPUP` L666 = **7 경로 전부 같은 시퀀스 NEXTVAL** · `MAX(HISTORY_SEQ)+1` 식 채번 0 |
| 사내 시퀀스 vs 테이블 | LAST_NUMBER **25,893,410** > MAX(HISTORY_SEQ) **25,893,391** (3,239,614 행, 마지막 10-07 18:19 qjastar) — 사내 정상 |
| 사내 PKG_DMF0020 BODY | 10-12 08:57:55 VALID, 10200줄/491863 (10-11 AJS '-'→'/' 변경 포함) — 이번 오류와 무관 |

**판정**: PK 가 HISTORY_SEQ 하나이고 모든 경로가 시퀀스로만 채번하므로, ORA-00001 은 **클라우드 시퀀스의 NEXTVAL 이 이미 테이블에 있는 HISTORY_SEQ 와 같을 때**(시퀀스가 테이블 MAX 보다 뒤처진 상태) 만 날 수 있다. 전형 원인 = 이력 테이블 데이터를 복사(이관)해 넣었는데 시퀀스는 전진하지 않음. 코드 결함 아님. `00_DIAG_CLOUD.sql [D2]` 가 이를 수치로 확정하고, `[D4]` 가 시퀀스보다 앞선 행을 누가·언제 넣었는지(재발 여부) 보여준다.

## 3. 파일 ↔ 작업 대조표 (SCM_MGR · BE 가 붙는 클라우드 DB — QA / DEV 각각 · 전체 F5)

| # | 파일 | 성격 | 판정 |
|---|---|---|---|
| 1 | [A_DB/00_DIAG_CLOUD.sql](A_DB/00_DIAG_CLOUD.sql) | **검증 (READ-ONLY)** | [D0] QA/DEV 식별 · [D1] BODY 지문 `10165/485652`(09-30 본) + 7044 줄에 `SCM_MST_FUTURE_PRICE_H`·`NEXTVAL`, 마커 H_NEXTVAL=3·H_MAXPLUS=0 · **[D2] JUDGE ❌ = 원인 확정(BEHIND_BY = 몇 번째 값부터 충돌)** · [D3]/[D3b] PK·트리거·시퀀스 소유자·권한 동형 · **[D4] 시퀀스보다 앞선 행의 CREATED_BY/시각(일괄 복사면 DISTINCT_MINUTES 1~2)** · [D5] SYS_LOG/배치로그 오류 원문 · [D6] 이력 INSERT 객체·채번 방식 전수(❌ MAX+1 0건) · [D7] 실패 저장의 본 테이블 잔존(부분 반영) 여부 |
| 2 | [A_DB/01_FIX_SEQUENCE_REFERENCE.sql](A_DB/01_FIX_SEQUENCE_REFERENCE.sql) | **참고 (사용자 별도 진행)** | 살아 있는 문장 = BEFORE/AFTER 조회 2건. 보정 블록은 `/* */` 안 — `ALTER SEQUENCE … RESTART START WITH MAX+1`(멱등·뒤처졌을 때만), RESTART 미지원 시 INCREMENT 점프 대체 |
| 3 | [A_DB/02_VERIFY_CLOUD.sql](A_DB/02_VERIFY_CLOUD.sql) | **확인 (READ-ONLY)** | [V1] LAST_NUMBER−CACHE > MAX = PASS · [V2] INCREMENT 1·CACHE 20·NOCYCLE · [V3] PK/트리거 동형 · [V4] 보정 뒤 저장 호출에 `PK_SCM_MST_FUTURE_PRICE_H` 오류 0 · [V5] 새 이력 행 |

화면 확인: DMF0020 Sales Price → 행 INSERT → 저장 → 성공, 02 [V4] ok · [V5] 에 새 HISTORY_SEQ 행.

## 4. 재발 조건 (00 [D4] 로 판정)

- [D4] 에 **최근 날짜·반복 작업자(또는 이관/복사 계정)** 가 시퀀스보다 앞선 HISTORY_SEQ 를 계속 넣고 있으면, 보정 뒤에도 그 복사가 다시 돌 때 재발한다 → 복사 절차에 "복사 후 시퀀스를 MAX+1 로 전진" 을 넣어야 한다.
- [D4] 가 0 rows 인데 [D2] 가 ❌ 라면 시퀀스 자체가 재생성(낮은 START WITH)된 경우 — 일회성.
- [D6] 에 `❌ MAX+1 채번` 이 있으면 코드 원인(클라우드 전용 변형) — 별건 회신.

## 5. 사내(ZIOUI1) 실행 기록

| 시각 | 작업 | 결과 |
|---|---|---|
| 2026-10-12 | 사내 조회 전용 대조(USER_SOURCE·USER_SEQUENCES·_H 통계·SYS_LOG) | §2 표 |
| 2026-10-12 | 리허설: 임시 시퀀스 `ZZ_HSEQ_REHEARSAL_20261012` CREATE → RESTART 경로(120→5001) → INCREMENT 대체 경로(→9002) → **DROP (잔여 0)** | 두 경로 정상 — 사내 운영 객체 변경 없음 |
| 2026-10-12 | 00 / 02 를 사내에서 전체 실행 (1차 → 판정식 오탐 2곳 수정 → 2차) | `_corp_check/_corp_*_out.txt` — 오류 0 · [D2]/[V1] PASS(사내 정상) · [D4] 0 rows · [D6] insert 7/seq 7/❌ 0 |
| 2026-10-12 | 01 사내 실행 | 살아 있는 BEFORE 조회 OK("정상 — 보정 불필요"). 러너 출력의 오류 9건은 러너가 `/* */` 블록을 문장으로 쪼개는 도구 한계 — SQL Developer 전체 F5 에서는 주석으로 건너뜀 |

1차 오탐 교정 내용: [D2]/[V1] 의 "LAST_NUMBER−CACHE ≤ MAX ⚠" 규칙은 정상 상태(사내 LAST_NUMBER 25,893,410 vs MAX 25,893,391, 차 19 = 캐시 안)에서도 켜져 폐기 → `LAST_NUMBER > MAX` 만 PASS. [D4] 기준도 `≥ LAST_NUMBER`(시퀀스 미발급 값) 로. [D6] 은 다른 이력 테이블의 `MAX(HISTORY_SEQ)`(PKG_SSP0019) 를 ❌ 로 잡아 "이력 테이블에 INSERT 하는 객체" 로 한정.

롤백: 없음(변경 없음). 시퀀스를 낮추는 원복은 하지 않는다(다시 충돌).
