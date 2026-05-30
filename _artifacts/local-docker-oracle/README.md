# 로컬 Docker Oracle 셋업 — `_artifacts/local-docker-oracle/`

NSCM 로컬 개발 환경용 Oracle 23c Free 컨테이너 + `To-be_v2_converted/` 일괄 적재 산출물.

## 결정된 범위 (이번 페이즈)

| 항목 | 결정 |
|---|---|
| DDL 적재 | `To-be_v2_converted/` 만 (As-Is MSSQL 변환은 화면 단위 점진) |
| MSSQL datasource | 현 `config-local.yml` 설정 유지 (사용자 환경에서 연결 가능) |
| SSO | 처리 불필요 (BE 코드 이미 주석 — `SsoController.java` L1-2) |
| Oracle 이미지 | `gvenzl/oracle-free:23-slim-faststart` |
| DB 비밀번호 | `!SCMroqkf2026` (As-Is 와 동일, 로컬 한정) |
| 호스트 포트 | `1521` 고정 |
| BE 접속 계정 | `SCM_MGR` 로 직접 (로컬은 app/mgr 분리 생략) |

## 알려진 한계 (사용자 합의)

`To-be_v2_converted` 에는 다음 Admin/Menu/SSO 테이블 DDL 이 없음 → 의존 PKG 가 INVALID:

| 미존재 테이블 | 영향 받는 PKG |
|---|---|
| `SCM_ADM_USER_M` | `PKG_NSCM_UI_COM_USER` |
| `SCM_MST_SSO_USER_INFO` | `PKG_NSCM_UI_COM_USER` |
| `SCM_ADM_USER_GR_M`, `SCM_ADM_USER_GR_MPG_M` | `PKG_NSCM_UI_COM_USER`, `PKG_NSCM_UI_COM_AUTH` |
| `SCM_ADM_MNU_M` | `PKG_NSCM_UI_COM_MENU` |
| `SCM_ADM_USER_GR_MNU_MPG_M`, `SCM_ADM_USER_GR_MNU_BTN_MPG_M` | `PKG_NSCM_UI_COM_MENU` |

→ **이번 페이즈에서 로그인은 작동하지 않음.** BE 기동까지만 검증.
→ 화면 작업 시점에 해당 화면이 의존하는 테이블만 점진적으로 MSSQL → Oracle 변환·적재.

## 파일 목록

| 파일 | 용도 |
|---|---|
| `docker-compose.yml` | 컨테이너 정의 (포트/볼륨/헬스체크) |
| `00_create_schema.sql` | SYS DBA 로 SCM_MGR + 역할 3개 생성 (SQL*Plus) |
| `00_create_schema_DBeaver.sql` | 위와 동일, DBeaver 호환 |
| `00_create_schema_Verify.sql` | DBeaver Verify (단일 SELECT UNION ALL) |
| `00_create_schema_Diagnose.sql` | DBeaver Diagnose (개별 SELECT) |
| `01_create_tablespaces.sql` | SYS DBA 로 `TS_SCM_D01`/`TS_SCM_X01` 생성 + SCM_MGR quota |
| `99_verify_compile.sql` | 적재 후 컴파일 결과 검증 (SQL*Plus) |
| `99_verify_compile_DBeaver.sql` | DBeaver 호환 |
| `99_verify_compile_Verify.sql` | DBeaver Verify (단일 SELECT) |
| `99_verify_compile_Diagnose.sql` | DBeaver Diagnose (INVALID 추적) |
| `load_all.ps1` | 자동 적재 wrapper (PowerShell 5.1) |
| `logs_*.txt` | sqlplus 실행 로그 (자동 생성) |

## ⚠️ 알려진 환경 의존성 — Tablespace

To-be_v2_converted DDL 들은 사내 클라우드 Oracle 의 tablespace 이름 (`TS_SCM_D01`, `TS_SCM_X01`) 을
하드코딩하고 있습니다. 로컬 컨테이너에는 이 두 tablespace 를 **반드시 먼저 생성**해야
`SCM_SYS_LOG` / `DM_SYS_LOG` 등의 테이블이 정상 생성되고, 모든 PACKAGE BODY 의
`PR_SCM_SYS_LOG_BATCH` 의존 cascade INVALID 가 풀립니다.

→ `01_create_tablespaces.sql` 을 `00_create_schema.sql` 직후, `01_compile_order.sql` 적재 전에 실행.

## 사용 절차

### 1. Docker Desktop 기동
PC 의 Docker Desktop 을 띄우고 다음으로 데몬 정상 확인:
```powershell
docker info
```

### 2. 컨테이너 기동
```powershell
cd C:\Projects\NSCM\_artifacts\local-docker-oracle
docker compose up -d
docker compose logs -f oracle    # "DATABASE IS READY TO USE!" 까지 대기 (5~10분)
```

### 3. 일괄 적재
```powershell
.\load_all.ps1
```
대략 15~30분 소요. 진행 상황은 `logs_*.txt` 로 확인.

`load_all.ps1` 은 다음 순서로 실행:
1. `00_create_schema.sql` (SYS) — SCM_MGR + 역할
2. `01_create_tablespaces.sql` (SYS) — TS_SCM_D01/X01 + SCM_MGR quota
3. `01_compile_order.sql` (SCM_MGR) — To-be_v2_converted 137개 SQL
4. `99_verify_compile.sql` (SCM_MGR) — 결과 검증

### 4. BE 기동 — ⚠️ 빌드 환경 선행 필요

`config/config-local.yml` 의 `datasources[0]` Oracle 블록 변경은 이미 반영됨:
- `jdbc-url` → `jdbc:log4jdbc:oracle:thin:@localhost:1521/FREEPDB1`
- `username` → `SCM_MGR`
- `password` → `!SCMroqkf2026` (그대로)
- `datasources[1]` (MSSQL) 및 `sso:` 블록은 변경 없음 (사용자 요청)

**그러나** `nscm-be/settings.gradle` 이 사내 Nexus (`http://10.94.57.6:8081/repository/maven-public/`) 를
가리키고 있어, **로컬 환경에서 첫 빌드 시 dependency 다운로드가 차단됨** (curl 확인).

대응 옵션 (사용자 선택):
1. 사내 VPN 으로 빌드 한 번 → `~/.gradle/caches` 채우기 → 이후 오프라인 빌드
2. `settings.gradle` 의 Nexus URL 을 `mavenCentral()` 로 교체 (단 사내 전용 jar 가 없을 가능성)
3. 사내 빌드 서버에서 만든 `.jar` 받아서 `java -jar` 로 실행

빌드만 한번 통과하면:
```powershell
cd C:\Projects\NSCM\nscm-be
.\gradlew bootRun
```
로그에서 `HikariPool-1 - Start completed`, `Tomcat started on port 8080` 확인.

### 5. 로그인 시도 금지 (이번 페이즈)
INVALID PKG 로 인해 `POST /user/login` 은 실패함이 명백. **시도하지 말 것.**
화면 작업 시점에 필요한 Admin 테이블 변환 후 시도.

## 적재 결과 (2026-05-26 1회차)

| 객체 종류 | VALID | INVALID |
|---|---:|---:|
| TABLE | 1581 | 0 |
| INDEX | 827 | 0 |
| TYPE | 9 | 0 |
| FUNCTION | 7 | 0 |
| SEQUENCE | 12 | 0 |
| LOB | 23 | 0 |
| VIEW | 5 | 3 |
| PACKAGE | 53 | 2 |
| PACKAGE BODY | 12 | 43 |
| PROCEDURE | 2 | 0 |
| **합계** | **2531** | **48** |

INVALID 48건의 분류:
- **Admin/SSO 의존 (사용자 합의된 한계)**: `PKG_NSCM_UI_COM_USER`, `_MENU`, `_AUTH` 등 — 화면 작업 시 점진 보강
- **타입 의존 부재**: `PKG_DMF0068` ← `T_DMF0068_TAB` 타입 미정의 (To-be 변환 누락)
- **컨버전 잔존 syntax**: 일부 PKG BODY 에서 MSSQL → Oracle 변환 미완성 (e.g. `END = p_active_flag`)

→ 해당 화면 작업 시 해당 PKG/타입만 점진 수정하여 cascade 해소.

## 운영 명령

| 작업 | 명령 |
|---|---|
| 컨테이너 정지 (볼륨 유지) | `docker compose down` |
| 컨테이너 정지 + DB 초기화 | `docker compose down -v` |
| SYS 셸 진입 | `docker exec -it nscm-oracle sqlplus sys/'!SCMroqkf2026'@//localhost:1521/FREEPDB1 as sysdba` |
| SCM_MGR 셸 진입 | `docker exec -it nscm-oracle sqlplus SCM_MGR/'!SCMroqkf2026'@//localhost:1521/FREEPDB1` |
| 볼륨 백업 | `docker run --rm -v nscm-oracle-data:/v -v ${PWD}:/b alpine tar -czf /b/nscm-oracle-data-backup.tgz -C /v .` |
| 볼륨 복원 | `docker run --rm -v nscm-oracle-data:/v -v ${PWD}:/b alpine tar -xzf /b/nscm-oracle-data-backup.tgz -C /v` |

## 다음 페이즈 (Out of Scope)

- Admin/Menu/SSO 테이블 ~10개 As-Is MSSQL → Oracle 변환 + 적재
- `SCM_MST_SSO_USER_INFO` 에 `minyonglee1` 시드
- 메뉴 권한 시드 (`SCM_ADM_USER_GR_MNU_MPG_M`, `SCM_ADM_USER_GR_MNU_BTN_MPG_M`)
- 화면별 As-Is SP/Query 점진 변환 (룰 #10 — MSSQL 키워드 0건)
