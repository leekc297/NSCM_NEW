# SCM_ADM_MSG_M 권한 복원 — 사내오라클 적용 기록 (2026-10-20)

| 항목 | 값 |
|---|---|
| 대상 DB | 59.19.252.148:2521/ZIOUI1 (SERVER_HOST=localhost · SERVICE_NAME=zioui1) |
| 실행 계정 | SCM_MGR (테이블 소유자) |
| 실행 시각 | 2026-10-20 11:1x KST |
| 실행 방식 | python-oracledb thin (`.env.asis` TOBE_DB_*) — 아래 SQL 과 동일 문장 |
| 파일 | `01_grant_scm_adm_msg_m.sql` (멱등 · 전체 F5 가능) |

## 원인
- `SCM_MGR.SCM_ADM_MSG_M`(다국어 메시지·라벨) 이 2026-10-16 16:22 재생성(`SCM_ADM_MSG_M_BAK20261016_S200` 15:16 생성)되면서
  형제 테이블(`SCM_ADM_USER_M` · `SCM_ADM_MNU_M`)이 가진 `RL_SCM_DML`(DIUS) · `RL_SCM_SEL`(S) · `SCMP_APP`(S) 권한이 **전부 없어짐**(ALL_TAB_PRIVS 0행).
- BE(SCMP_APP) 의 `/admin/message?langCd=KO` 가 `ORA-00942 "SCM_MGR"."SCM_ADM_MSG_M" 존재하지 않음` 으로 실패 — `nscm.20261019.log` 27건 · `nscm.log`(10-20) 113건.
- 결과: FE 라벨/메시지 미표시 → E2E 스모크의 조회조건 탐색 전부 실패.

## 적용 문장 (실행 순서)
```sql
GRANT SELECT, INSERT, UPDATE, DELETE ON SCM_MGR.SCM_ADM_MSG_M TO RL_SCM_DML;
GRANT SELECT ON SCM_MGR.SCM_ADM_MSG_M TO RL_SCM_SEL;
GRANT SELECT ON SCM_MGR.SCM_ADM_MSG_M TO SCMP_APP;
-- 시노님 SCMP_APP.SCM_ADM_MSG_M 은 이미 존재(권한이 없어 ALL_SYNONYMS 에서 안 보였을 뿐) → 생성 건너뜀
```

## 검증
| 검증 | 결과 |
|---|---|
| ALL_TAB_PRIVS(SCM_ADM_MSG_M) | RL_SCM_DML DELETE/INSERT/SELECT/UPDATE · RL_SCM_SEL SELECT · SCMP_APP SELECT (형제 테이블과 동일) |
| SCMP_APP 로 `SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MSG_M` / `FROM SCM_ADM_MSG_M`(시노님) | 4,751 / 4,751 |
| BE `POST /user/login` → `GET /admin/message?langCd=KO` | HTTP 200 · 223,139 bytes |

## 작업 ↔ 파일 대조
| 작업 | 파일 |
|---|---|
| GRANT 3건 (+시노님 존재 시 skip 블록) | `01_grant_scm_adm_msg_m.sql` |

## 클라우드(QA) 이관 여부
- 환경 복구성 권한 작업. QA 에서 같은 증상(`/admin/message` ORA-00942)이 있을 때만 `01_grant_scm_adm_msg_m.sql` 을 그대로 실행(멱등). 데이터 변경 없음.
