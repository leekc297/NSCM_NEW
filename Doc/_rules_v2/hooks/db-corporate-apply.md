# Hook — 사내 Oracle DB 적용 절차 (Docker DB → 사내)

> 작성: 2026-06-10 (Docker → 사내 11 화면 일괄 적용 작업 후)
> 상위 룰: `anti-simplification.md`
> 관련 메모리: `feedback_corporate_db_apply_pattern.md` / `feedback_corporate_schema_8_diffs.md` / `reference_corporate_oracle_connection.md`

---

## §0. 트리거

- "사내 DB 적용해줘 / 클라우드 적용 / cloud apply / corporate apply"
- "Docker 적용분을 사내에 / 양쪽 DB 동기화"
- 사내 DB (`121.162.245.167:2521/OCGSCMD_P01`, 2026-06-15 IP 변경 · 2026-06-17 Service Name 전환) 에 SQL 실행 요청
- Docker 와 사내 DB row count 차이 검토 후 patch 작업

---

## §1. 접속 도구 — Docker exec sqlplus (사내 Oracle Instant Client 미설치 우회)

### 1.1 패턴 (의무)
```bash
# 단일 SQL 실행
tr -d '\r' < script.sql | docker exec -i nscm-oracle bash -c \
  "sqlplus -L -S 'SCM_MGR/\"!SCMroqkf2026\"@121.162.245.167:2521/OCGSCMD_P01'" > log.log 2>&1
```

### 1.2 핵심 요소
| 요소 | 이유 |
|---|---|
| `tr -d '\r'` | Windows CRLF → Linux LF — 미적용 시 sqlplus 가 멀티라인 SELECT 잘못 파싱 (SP2-0734) |
| `docker exec -i` | stdin pipe 로 SQL 전달 (file copy 시 권한 + CRLF 추가 문제) |
| `-L -S` | -L: login attempt 1회만 (실패 시 즉시 종료) / -S: silent (배너 제거, 깔끔한 log) |
| `bash -c "sqlplus ..."` | 비밀번호의 `!` 문자 보호 (bash 내 single-quote) |
| `> log.log 2>&1` | stdout + stderr 모두 캡쳐 — 진단 의무 |

### 1.3 SQL 파일 작성 시 anti-pattern
| 안 됨 | 이유 |
|---|---|
| `--- 한글 텍스트 ---` PROMPT 사용 | sqlplus 가 multi-line SELECT 와 혼동 → SP2-0734 |
| Inline comment 다음줄 SELECT | comment 가 SELECT 흡수 가능 |
| 연속 빈 줄 | sqlplus 가 statement 분리 |
| `WHENEVER SQLERROR EXIT FAILURE` | 첫 known error (ORA-01400 등) 에 즉시 종료 |

---

## §2. 적용 wrapper (`apply.sh`)

### 2.1 핵심 사양
1. 각 SQL 파일별 timestamp 로그 archive (`_logs/YYYYMMDD_HHMMSS_{LABEL}.log`)
2. `tr -d '\r'` 자동 + trailing `EXIT;` 보장
3. ALL_ERR / KNOWN_ERR / REAL_ERR 분류
4. REAL_ERR 0 = exit 0, 1+ = exit 2 (chain stop)

### 2.2 Known-acceptable error 패턴 (분류 의무)
| 패턴 | 원인 | 처리 |
|---|---|---|
| `ORA-01400 .* "(MSG_TP_CD|USE_YN|CREATED_BY|LAST_UPDATED_BY)"` | 사내 SCM_ADM_MSG_M NOT NULL (Docker NULLABLE) | KNOWN — 후속 patch |
| `ORA-00942` + `SCM_COM_MSG_M` | 양쪽 DB 미존재 | KNOWN — i18n MSG 별 테이블 사용 |
| `ORA-00904 .* "BMK_YN"` | 사내 SCM_ADM_MNU_M 미존재 컬럼 (Docker 추가) | KNOWN — DDL 동기화 작업 별도 |
| `ORA-01653` | USERS tablespace quota 부족 | KNOWN — DBA 확장 필요 |
| `DBMS_METADATA` / `UTL_XML` / `LPX-00210` / `bad stylesheet` + `ORA-01001` / `ORA-06502` | 사내 Oracle 19c DBMS_METADATA 버그 (audit-only backup block) | KNOWN — 실제 SP recreation 은 정상 |
| `^SP2-[0-9]+` | sqlplus 클라이언트 parse error (VERIFY-only SELECT) | KNOWN — 실제 SQL semantic 은 ORA-/PLS- 로 잡힘 |

---

## §3. PRE-CHECK 의무 (적용 전)

### 3.1 사내 DB baseline 캡쳐
- 전체 row count (MNU/API/PROC/SHEET/BTN/GR_MNU/GR_BTN/MSG)
- 대상 화면별 row count (MNU_ID/PROGRAM_ID/PROC_NM LIKE)
- 메타 테이블 owner 확인 (SCM_MGR 본인 schema vs SCMC vs SCMD_APP SYNONYM)

### 3.2 객체 owner 3-tier 패턴
| Owner | 역할 |
|---|---|
| **SCM_MGR** | 메타 등록 + 본인 schema TABLE (INSERT/UPDATE 대상) |
| **SCMD_APP** | application user — SCM_MGR.* 의 SYNONYM 보유 (DML 권한만) |
| **SCMC** | 별도 schema (legacy/cross-system) — 직접 수정 금지 |

### 3.3 적용 전 사용자 결정 의무
- 사내 DB 의 현재 상태 (미적용 / 일부 / 완전 적용 여부)
- 04_GRANT_SYNONYM 적용 여부 (공유 DB 권한 변경 — 별도 명시 승인)
- USERS tablespace quota 상태 (DBA 협업 필요 여부)
- DMF0020 같은 미완성 산출물 처리 방향 (메타만 / 보강 / skip)

---

## §4. POST-WRITE 검증

### 4.1 row count diff (BEFORE vs AFTER)
- Phase 1 의 `01_pre_check.sql` 재실행
- diff 로 Δ 산출 → expected vs actual 비교

### 4.2 SP VALID/INVALID 상태
```sql
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM USER_OBJECTS
 WHERE STATUS='INVALID' AND OBJECT_TYPE IN ('PROCEDURE','PACKAGE','PACKAGE BODY')
   AND (OBJECT_NAME LIKE '%{MENU_ID}%' OR ...);
```

### 4.3 일괄 ALTER COMPILE 의무
```sql
BEGIN
  FOR r IN (SELECT OBJECT_NAME, OBJECT_TYPE FROM USER_OBJECTS WHERE STATUS='INVALID' AND OBJECT_TYPE IN ('PROCEDURE','FUNCTION','PACKAGE','PACKAGE BODY','TRIGGER','VIEW')) LOOP
    EXECUTE IMMEDIATE 'ALTER '||CASE WHEN r.OBJECT_TYPE='PACKAGE BODY' THEN 'PACKAGE "'||r.OBJECT_NAME||'" COMPILE BODY' ELSE r.OBJECT_TYPE||' "'||r.OBJECT_NAME||'" COMPILE' END;
  END LOOP;
END;
/
```

---

## §5. 적용 순서 (anti-simplification — 단순 일괄 금지)

화면별 순차:
1. **00_DDL** (CHECK SQL — 객체 존재만 검증, INSERT/CREATE 없음 가정)
2. **03_META** (7-BLOCK — 005/010/020/030/.../110)
3. **01_SP_BODY** (CREATE OR REPLACE — 멱등 + 의존 SP 순서)
4. **04_GRANT_SYNONYM** (별도 사용자 명시 승인 후 — 공유 DB 영향)

화면 간 순서 (의존 cross-ref):
- SYS 화면 먼저 (단순) → DMF 화면 (사고 cross-ref 깊음)
- DMF 안에서: DMF0008 → DMF0072 → DMF0043 → DMF0043_01 → DMF0020

---

## §6. 보고서 의무

적용 종료 시 `_artifacts/_apply_corporate/REPORT.md` 작성:
- 적용 파일 수 / 결과 (OK / WARN / FAIL)
- 변경량 표 (BEFORE / AFTER / Δ)
- SP VALID/INVALID 상태
- Known 이슈 목록 + Phase 5 보완 작업 대상
- 사용자 수동 검증 단계 (BE 재기동 / 재로그인 / 화면 진입)
