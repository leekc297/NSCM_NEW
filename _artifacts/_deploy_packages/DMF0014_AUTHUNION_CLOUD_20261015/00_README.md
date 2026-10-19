# DMF0014 관리자 그룹 전행 수정 (GET_ADMIN_GROUP) 보완 — 클라우드 이관 · 패치형

> 마커 `[AUTHUNION 2026-10-15]` — PKG_DMF0014 BODY 의 관리자 그룹 판정 2줄만 변경. 데이터 · 메타 · 화면(FE) · BE 변경 없음.

| 항목 | 값 |
|---|---|
| 요청 | 로그인 사용자의 권한그룹이 기준코드 `GET_ADMIN_GROUP` 목록이면 DMF0014 전행 수정 가능 (AS-IS 동작) |
| AS-IS | `DMF0014_GET_CUST_FCST_UPLOAD_DATA` 가 `p_userinfo`(=로그인 그룹명) 로 판정 → ADMIN 이면 `EDIT_FLAG` 전행 'Y' |
| 원인 | TO-BE FE 는 `P_USERINFO` 에 USER_ID 를 넘김(세션에 그룹 정보 없음) → `SEGMENT1 = P_USERINFO` 항상 0건 → 담당 팀 행만 수정 가능 |
| 보완 | 판정 2곳(`P_DMF0014_GET_CUST_FCST_UPLOAD_DATA` · `P_DMF0014_GET_EXCEL_FORM_DATA`)을 **사용자가 보유한 그룹** 기준으로 확장 (DMF0082 · DMF0021 · DMF0042 와 같은 방식) |
| 사내 적용 | **완료** (ZIOUI1 2026-10-15 10:59:56) · [APPLIED_OPERATIONS.md](../../_apply_corporate/DMF0014_AUTHUNION_20261015/APPLIED_OPERATIONS.md) |
| 클라우드 | **미적용** |
| BE 재기동 · FE | 불요 |

변경 내용 (2곳 동일):
```sql
-- 전
        AND    SEGMENT1 = P_USERINFO;
-- 후
        AND    (SEGMENT1 = P_USERINFO  --[AUTHUNION 2026-10-15] …
                OR SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_ADM_USER_GR_MPG_M G
                                WHERE  G.USER_ID IN (P_USERINFO, P_USER_ID, P_CREATED_BY)
                                AND    G.USE_YN = 'Y'));
```

## 실행 순서 (SCM_MGR, QA → DEV, 각 파일 전체 F5, 값 입력 없음)

| # | 파일 | 기대 |
|---|---|---|
| 1 | [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) | **검증 쿼리.** L1 에 `AND    SEGMENT1 = P_USERINFO;` 2줄(각각 앞에 GET_ADMIN_GROUP) · L2 마커 0 · L3 6행 · L5 BEFORE_CNT 0 / AFTER_CNT ≥1 |
| 2 | [A_DB/10_APPLY_AUTHUNION_PATCH.sql](A_DB/10_APPLY_AUTHUNION_PATCH.sql) | `APPLIED — PKG_DMF0014 BODY VALID · 관리자 그룹 판정 2곳 합집합` (이미 적용이면 `SKIP`, 구조가 다르면 ORA-20001/20003 로 중단·원문 무변경) |
| 3 | [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) | V1 PASS(2) · V2 VALID/오류 0/의존 INVALID 0 · V3 단독 판정 줄 없음 · V4 AFTER_CNT ≥1 |

롤백: [A_DB/99_ROLLBACK_AUTHUNION_PATCH.sql](A_DB/99_ROLLBACK_AUTHUNION_PATCH.sql) — 되돌리면 관리자 그룹 사용자도 다시 담당 팀 행만 수정 가능.

적용 뒤 화면 확인: 관리자 대상 그룹(예: DM ADMIN · DM Planner) 계정으로 DMF0014 조회 → 다른 팀 행의 기간 셀도 편집 가능한지 확인.
ADMIN 그룹이 없는 계정(Viewer 등)은 기존과 같이 담당 팀 행만 편집 가능해야 한다.

## 주의
- **00 의 결과가 기대와 다르면 10 을 실행하지 않는다.** L1 의 판정 줄이 2개가 아니거나 L3 인자가 6행이 아니면 클라우드 원문이 사내와 다른 것이다 → L1 · L3 결과 회신.
  (10 을 실행해도 구조가 다르면 가드로 중단하고 원문을 건드리지 않는다. 컴파일 오류가 나면 원문을 자동 복원한다.)
- L4 기준코드 목록이 사내와 다르면 판정 대상 그룹이 달라진다(패치 자체는 무관) — 결과 회신.
- 10 은 패키지 BODY 재생성이라 DMF0014 조회 · 저장 · Excel Upload 실행 중이면 대기 — 00 L6 확인 뒤 실행.

## 리허설 (사내 ZIOUI1 2026-10-15 11:16, `_rehearsal_out/`)
99(`ROLLED BACK … 마커 0`) → 00(L1 판정 줄 2 · L2 0 · L5 BEFORE 0) → 10(`APPLIED`) → 10(`SKIP` 멱등) → 90(V1 PASS · V2 VALID · V4 AFTER ≥1).

## 작업 ↔ 파일 대조
| 사내에서 한 일 | 파일 |
|---|---|
| PKG_DMF0014 BODY 관리자 그룹 판정 2곳 변경 | A_DB/10_APPLY_AUTHUNION_PATCH.sql |
| 권한 · 시노님 · 메타 · 데이터 · FE · BE 변경 | 없음 |
