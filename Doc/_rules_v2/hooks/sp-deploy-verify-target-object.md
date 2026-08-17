# Hook #136 — sp-deploy-verify-target-object ⭐⭐⭐ (2026-08-18 실사고 계기 신설)

> **트리거**: Oracle **PACKAGE / PACKAGE BODY / PROCEDURE / FUNCTION 배포**(사내·클라우드 공통).
> **한 줄**: 배포 직후 **대상 객체 자신의 STATUS 와 컴파일 에러, 그리고 의존 객체 연쇄 INVALID**를
> 실측하지 않은 배포는 **미완료**다. "실행 완료" 는 성공 근거가 아니다.
> **연관**: #99(저장 무결성) · #125(완료 전 셀프 검증) · 룰 32(Oracle 직결) · oracle-db-workflow

---

## §0 사고 원문 (2026-08-18, DMF0014 보완 중)

배포 스크립트가 **다른 객체(`PKG_DMF0074`)의 상태를 하드코딩으로 조회·출력**하고 있었다.
`PR_DM_PLN_CUST_FCST_TO_MKT_FCST` 에 구문 오류(`ORA-00907`)가 있는 패치를 올렸는데 화면에는

```
[배포] ... 실행 완료
  PACKAGE        VALID      ← 엉뚱한 객체의 상태
  PACKAGE BODY   VALID
  컴파일 에러 0건            ← 엉뚱한 객체의 에러 수
```

가 찍혀 **VALID 로 오독하고 다음 작업으로 넘어갔다.** 실제로는 대상 프로시저가 INVALID 가 되었고,
이를 참조하는 `PKG_DMF0014` 까지 연쇄 INVALID(`ORA-04063`) 가 되어 **업로드 화면이 중단**됐다.
같은 실수를 같은 날 **두 번** 반복했다.

## §1 의무 (3축 전부 — 하나라도 빠지면 배포 미완료)

| # | 축 | 확인 |
|---:|---|---|
| 1 | **대상 객체 STATUS** | `ALL_OBJECTS` 에서 **배포한 그 이름**으로 조회. `OBJECT_NAME` 은 배포 SQL 의 `CREATE OR REPLACE <type> <name>` 에서 **파싱**한다 — 상수로 박지 않는다 |
| 2 | **컴파일 에러 전문** | `ALL_ERRORS` 를 **대상 이름으로** 조회해 0건 확인. 1건이라도 있으면 즉시 원복 |
| 3 | **의존 객체 연쇄** | `ALL_DEPENDENCIES` 로 이 객체를 참조하는 객체 중 `STATUS='INVALID'` 조회. PL/SQL 은 참조 객체를 바꾸면 **참조하는 쪽이 INVALID 로 떨어진다** — 재컴파일(`ALTER PACKAGE x COMPILE BODY`) 후 다시 확인 |

> 판정: 위 3축이 모두 깨끗할 때만 "배포 완료". **비정상 시 스크립트는 exit≠0** 으로 끝내
> 다음 단계가 자동으로 이어지지 않게 한다(사람이 로그를 눈으로 읽고 판단하게 두지 않는다).

## §2 오탐 주의 — 기존부터 INVALID 인 레거시

의존 목록에 **원래부터 INVALID 이던 standalone 잔재**가 섞일 수 있다(변환 중간 산출물).
예: `DMF0014_CUST_FCST_EXCEL_UPLOAD`(2026-08-10부터 INVALID), `DMF0014_SAVE_CUST_FCST_UPLOAD_DATA`(07-21부터).
→ `LAST_DDL_TIME` 으로 **이번 배포 이전부터 INVALID 였는지** 가르고, 정본(`PKG_*`)이 VALID 인지로 판정한다.
정본이 INVALID 면 무조건 중단·원복.

## §3 배포 전 의무

1. **백업 먼저** — 배포 직전 `ALL_SOURCE` 원문을 `_artifacts/_apply_corporate/BACKUP_<객체>_pre_<사유>_<날짜>.sql` 로 저장.
2. **치환 건수 가드** — 텍스트 패치 생성기는 기대 출현 건수와 다르면 **즉시 중단**(원문 변경 감지).
3. 실패 시 **즉시 백업본으로 원복 + 의존 재컴파일** 후 상태 3축 재확인.

## §4 실행 도구

정본 = `_artifacts/_diagnostics/` 의 배포 스크립트(대상 파싱 + 3축 검증 + exit code).
구 스크립트처럼 **특정 객체명을 상수로 조회하는 검증기는 폐기**한다.

```sql
-- ① 대상
SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n;
-- ② 에러
SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n ORDER BY SEQUENCE;
-- ③ 의존 연쇄
SELECT OBJECT_TYPE, OBJECT_NAME FROM ALL_OBJECTS
 WHERE OWNER='SCM_MGR' AND STATUS='INVALID'
   AND OBJECT_NAME IN (SELECT NAME FROM ALL_DEPENDENCIES
                        WHERE REFERENCED_OWNER='SCM_MGR' AND REFERENCED_NAME=:n);
```

## §5 자기 점검

```
✅ 검증 쿼리의 객체명이 **배포 SQL 에서 파싱**된 값인가? (상수 아님)
✅ ALL_ERRORS 0건을 대상 이름으로 확인했나?
✅ 의존 INVALID 를 확인하고, 정본 패키지를 재컴파일해 VALID 로 만들었나?
✅ 실패 시 스크립트가 exit≠0 으로 끝나 다음 단계를 막았나?
✅ 백업본 경로를 보고에 명시했나?
```
