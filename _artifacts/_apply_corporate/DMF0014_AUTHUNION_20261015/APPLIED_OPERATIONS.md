# DMF0014 AUTHUNION — 사내 ZIOUI1 적용 기록 (2026-10-15)

- 요청: "DMF0014 에서 로그인 그룹이 기준코드 GET_ADMIN_GROUP 목록이면 전행 수정 가능" — AS-IS 동작이 TO-BE 에서 동작하지 않음 → "적용해주세요"
- 방식: DB 객체만 수정. FE·BE 는 수정하지 않음(사용자 상시 지시 2026-10-15).
- 대상 DB: 59.19.252.148:2521/ZIOUI1 · SERVER_HOST=localhost · SCM_MGR

## 원인
| 구분 | AS-IS | TO-BE(수정 전) |
|---|---|---|
| P_USERINFO 전달값 | `NowGroupID` (그룹명) | `session.groupId(유령) \|\| USER_ID` → 실제로는 USER_ID |
| 판정 | `GET_ADMIN_GROUP` · `VALID_YN='Y'` · `SEGMENT2='ALL'` · `SEGMENT1=@p_userinfo` | 동일식 → USER_ID 와 매칭되지 않아 0건 |
| 결과 | ADMIN·DM ADMIN·DM Planner·SCM PI Admin·SCP Planner 그룹이면 EDIT_FLAG 전행 'Y' | 담당 팀 행만 'Y' |

## 작업 ↔ 파일
| # | 작업 | 파일 |
|---|---|---|
| 1 | 최신 원문 조회 (LAST_DDL 2026-10-12 19:18:20, FETCHED 10:59:22) → 원복용 백업 | `PKG_DMF0014_BODY.ASIS.sql` |
| 2 | 판정 WHERE 2곳 치환 (L6422 `P_DMF0014_GET_CUST_FCST_UPLOAD_DATA`, L7230 `P_DMF0014_GET_EXCEL_FORM_DATA`) | `PKG_DMF0014_BODY_AUTHUNION_20261015.sql` |
| 3 | FRESH-GATE PASS → `CREATE OR REPLACE PACKAGE BODY` (10:59:56) | `apply_authunion.py --deploy`, `deploy_20261015.log` |
| 4 | 원복 (필요 시) | `apply_authunion.py --rollback` (현재 원문 == TOBE 일 때만 실행) |

치환 내용 (마커 `[AUTHUNION 2026-10-15]`):
```sql
AND    (SEGMENT1 = P_USERINFO
        OR SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_ADM_USER_GR_MPG_M G
                        WHERE  G.USER_ID IN (P_USERINFO, P_USER_ID, P_CREATED_BY)
                        AND    G.USE_YN = 'Y'));
```

## 검증
- PACKAGE BODY VALID · ALL_ERRORS 0 · 적용본 == DB 원문 · 마커 2/2 · PACKAGE SPEC 무변경(LAST_DDL 2026-10-09 13:38:30)
- SP 실호출 (div 81, 2026-01-01~2026-12-31, WEEKLY):

| P_USERINFO | 사용자 그룹 | 행 | EDIT_FLAG Y | N |
|---|---|---:|---:|---:|
| ahn.hc (USER_ID, 현 FE) | DM ADMIN | 19 | 19 | 0 |
| agabryelczyk (USER_ID) | DM Planner | 19 | 19 | 0 |
| DM ADMIN (그룹명, AS-IS 방식) | — | 19 | 19 | 0 |
| abartkowicz / abartniczak / abednarek | Viewer·GUEST (ADMIN 그룹 없음) | 19 | 0 | 19 |

- 수정 전 판정식으로 USER_ID 를 넣으면 매칭 0건이었음(10:44 실측: ADMIN 대상 그룹 사용자 15명 전원 0).

## 클라우드 패키지 리허설 (2026-10-15 11:16)
- `_deploy_packages/DMF0014_AUTHUNION_CLOUD_20261015/` 의 99(원복) → 00 → 10(적용) → 10(SKIP) → 90 을 사내에서 실행.
- 리허설 후 사내 BODY == 10:59 적용본 (전문 일치) · LAST_DDL 2026-10-15 11:16:15 · VALID.

## 미포함
- 클라우드 이관 패키지: `_deploy_packages/DMF0014_AUTHUNION_CLOUD_20261015/` (클라우드 미적용).
- 로컬 소스 사본 `To-be_v2_converted/06_Packages/04_Package_PKG_DMF0014.sql`: 갱신하지 않음.
