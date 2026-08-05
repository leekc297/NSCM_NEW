# CLOUD_DDL_FETCH_20260729 — 클라우드 DDL 추출 패키지 (최종 범위 = C4 단독)

> 근거: `Doc/화면분석서/TOBE_UI_DB객체_전수취합_v1.1.xlsx` 시트0 + `CLOUD_IMPORT_LIST.md`
> **2026-07-29 범위 확정 이력**: 최초 5객체(C1~C5) → 클라우드 PRECHECK 실측 + 사용자 확정으로 **C4 만 유지**.

## 클라우드 PRECHECK 실측 결과 (2026-07-29 사용자 실행)

| # | 객체 | 클라우드 실측 | 처리 |
|---|---|---|---|
| C1~C3 | P_SCM0008_ADD/REQUEST/DELETE_MY_AUTH | **실체 없음** — SCMD_APP/SCMP_APP **SYNONYM 만 존재**(dangling), ALL_ARGUMENTS 0행 | **제외 (사용자 확정: 불필요)** — SYS0011 버튼 3종(Add/Request/Delete) 배선은 별도 정리 대상 |
| C4 | PKG_SYS0014 | SPEC+BODY **VALID 존재** — 멤버 P_SYS0014_GET_DIVISION_DATA 1개, SCMD_APP/SCMP_APP EXECUTE GRANT | ✅ **추출 완료** → `C4_PKG_SYS0014.sql` (원문 보존) |
| C5 | SCM_SYS_FILE | **클라우드에도 미존재** | **제외 (사용자 확정)** — 필요 시 리포 baseline `_artifacts/G5_file_transfer_metadata.sql` 사용 가능 |

## 파일 구성

| 파일 | 상태 |
|---|---|
| `01_PRECHECK_CLOUD.sql` | 실행 완료 (결과 위 표) |
| `02_EXTRACT_DDL_sqlplus.sql` | 실행 완료 — C4 만 산출 성공 (C1~C3/C5 의 ORA-31603/31608 = 클라우드 미존재로 정상 판독) |
| `C4_PKG_SYS0014.sql` | ⭐ 산출물 — 사내 등록 원본 |

## 사내(OCGSCMD_P01) 적용 절차 — C4

1. `C4_PKG_SYS0014.sql` 실행 (SCM_MGR) — SPEC → BODY 순서 (파일 내 순서 그대로)
   - 사내 기존 상태 = 스펙만 INVALID → CREATE OR REPLACE 로 안전 덮어쓰기
2. VALID 확인: `python _artifacts/_diagnostics/ora.py query "SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_SYS0014'"` → PACKAGE/PACKAGE BODY 2행 VALID
3. `GRANT EXECUTE ON SCM_MGR.PKG_SYS0014 TO SCMD_APP;` + SYNONYM 확인(사내 SCMD_APP synonym 기존재 여부 실측 후) — 클라우드 GRANT 실측(SCMD_APP/SCMP_APP EXECUTE) 재현. 사내는 SCMP_APP 없음 → SCMD_APP 만
4. PROC_M 대조: PKG_SYS0014 3행(기존재) ↔ `ora.py args PKG_SYS0014` positional 일치 확인
5. 화면 검증: SYS0014(group-user) Division 콤보 동작 + API `SYS0014_GET_DIVISION_DATA` 정상

## 잔여 이슈 (본 패키지 범위 외 — 기록)

- SYS0011 BTN_MPG 3건(API_SCM0008_ADD/REQUEST/DELETE_MY_AUTH)은 **양쪽 DB 모두 SP 실체 없음**(dangling synonym) — 사용자 확정으로 SP 등록은 하지 않음. 해당 버튼 배선의 정리(제거 또는 PKG_SYS0011 멤버 재배선)는 별도 결정 필요.
- SCM_SYS_FILE 미존재 → BE `general/File.xml` 파일 기능(G5)은 사내에서 미동작 상태 유지.
