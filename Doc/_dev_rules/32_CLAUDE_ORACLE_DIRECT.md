# 32. Claude(Code) Oracle 직결 가이드 ⭐ 2026-06-11 신설

> **목적**: Claude Code 가 Oracle DB 작업(변환·컴파일·검증·진단) 시 DB 에 **직접** 질의할 수 있게 하여,
> "SQL 작성 → 사용자가 DBeaver 실행 → 결과 복사 → Claude 해석" 왕복을 제거한다.
> 진입 hook: `Doc/_rules_v2/hooks/oracle-db-workflow.md` §0-H

## 대상 DB

| 환경 | 접속 | 비고 |
|---|---|---|
| 사내 Oracle (기본, 2026-06-10 전환 / 2026-06-15 IP 변경) | `121.162.245.167:2521/ESSCMD`, user `SCM_MGR` | 검증 기준 DB |
| 로컬 Docker | `localhost:1521/FREEPDB1` (container `nscm-oracle`) | 보조/실험용 |

⚠️ **비밀번호 하드코딩 금지** — 환경변수 또는 `.env.asis`(gitignore) 사용. 신규 스크립트에 접속 문자열 literal 작성 금지.

---

## 옵션 A — SQLcl MCP Server (권장 ⭐ — Claude Code 네이티브 연동)

Oracle 공식 SQLcl(25.2+) 에 내장된 MCP 서버. Claude Code 가 자연어 → SQL 실행 → 결과 해석까지 도구 호출로 직접 수행.

```bash
# 1) SQLcl 설치 (Java 17+ 필요) — https://www.oracle.com/database/sqldeveloper/technologies/sqlcl/
# 2) 저장 접속 생성 (비밀번호는 SQLcl secure store 에 저장됨)
sql /nolog
SQL> connect -save nscm_corp -savepwd SCM_MGR@121.162.245.167:2521/ESSCMD

# 3) Claude Code 에 MCP 등록 (프로젝트 루트에서)
claude mcp add sqlcl -- <SQLcl경로>/bin/sql -mcp
```

- 제공 도구: 접속 목록/connect, `run-sql` (SELECT·DML·DDL), `run-sqlcl` (SQLcl 명령) 등
- 장점: 세션 유지(연속 질의), Claude Code 가 결과를 즉시 보고 다음 판단. PKG 컴파일 → USER_ERRORS 조회 → fix → 재컴파일 루프를 Claude 가 자율 수행 가능
- 주의: DML/DDL 실행 권한이 그대로 노출됨 — **운영성 DB 인 만큼 SAVE/DDL 은 사용자 확인 후 실행** 원칙을 CLAUDE.md 룰로 유지 (destructive-git-ops 와 동일한 사전 승인 정신)

## 옵션 B — python-oracledb thin CLI (`ora.py`) — 클라이언트 설치 불필요

Windows 에 Oracle Instant Client 가 없어도 동작 (thin 모드). MCP 없이 어떤 환경에서도 1줄로 실행.

```powershell
pip install oracledb
$env:NSCM_ORA_USER="SCM_MGR"; $env:NSCM_ORA_PASS="..."; $env:NSCM_ORA_DSN="121.162.245.167:2521/ESSCMD"

python _artifacts/_diagnostics/ora.py invalid                  # INVALID 목록
python _artifacts/_diagnostics/ora.py compile PKG_DMF0043      # 컴파일 + USER_ERRORS
python _artifacts/_diagnostics/ora.py args P_DMF0043_GET_...   # ALL_ARGUMENTS (PROC_M 대조)
python _artifacts/_diagnostics/ora.py query "SELECT COUNT(*) FROM DM_MST_CONTRIBUTE_RATIO_DTL"
python _artifacts/_diagnostics/ora.py exec _artifacts/52_xxx/01_sp_body.sql
```

- 용도: 파이프라인 Stage 2/3/5 의 기계적 검증, PROC_M ↔ SP 대조, row count, 빠른 SELECT
- `exec` 는 단순 분할 실행기 — 복잡한 sqlplus 스크립트(SPOOL/DEFINE 등)는 옵션 C 사용

## 옵션 C — docker exec sqlplus (기존 검증된 경로 — 대량 적용용)

Windows Instant Client 미설치 우회책으로 이미 운용 중. 사내 일괄 적용(82 SQL)에 실적 보유.

```bash
_artifacts/_diagnostics/run_sql.sh file.sql            # 1회 실행 (CRLF 자동 제거)
_artifacts/_diagnostics/compile_check.sh --all-invalid # Stage 2
_artifacts/_apply_corporate/apply.sh ...               # 사내 적용 (Known error 분류 + 로그)
```

- 전제: Docker Desktop + `nscm-oracle` container 기동 (사내 직결 전환 후에도 **sqlplus client 용도**로만 사용)
- 필수 규칙: `tr -d '\r'` CRLF 제거 / bash single-quote 로 `!` 보호 — hook `db-corporate-apply.md` §1

---

## 사용 구분 (요약)

| 상황 | 옵션 |
|---|---|
| Claude Code 대화형 DB 작업 전반 (조회·진단·컴파일 루프) | **A (SQLcl MCP)** |
| 스크립트화된 검증 (파이프라인 Stage 2/3/5, CI성 반복) | **B (ora.py)** |
| 대량 SQL 파일 일괄 적용 + Known error 분류 + 로그 archive | **C (apply.sh)** |
| sqlplus 전용 문법 (SPOOL/DEFINE/PROMPT) 스크립트 | **C (run_sql.sh)** |

## 안전 수칙 (의무)

1. SELECT/조회성 메타 질의 = 자유 / **INSERT·UPDATE·DELETE·DDL = 실행 전 사용자에게 대상·건수 보고 후 승인** (사내 DB 는 공유 환경)
2. 모든 변경성 SQL 은 `_artifacts/` 에 멱등 파일로 보존 후 실행 (재실행 안전 — NOT EXISTS/MERGE)
3. 실행 로그는 `_artifacts/_apply_corporate/_logs/` 규약 준수
4. 접속 정보는 환경변수/.env.asis/SQLcl secure store — 문서·코드에 평문 금지 (기존 평문 잔존분은 점진 제거 대상)

> 참고: SQLcl MCP 공식 문서 — https://docs.oracle.com/en/database/oracle/sql-developer-command-line/25.2/sqcug/starting-and-managing-sqlcl-mcp-server.html
