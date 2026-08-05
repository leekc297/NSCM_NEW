# DMF0003 — 클라우드 PKG 사내 반영 + 그룹판정 보완 (2026-08-04)

> 순서 (사용자 지시): **① 클라우드 PKG_DMF0003 → 사내 반영** → **② 그 본문 위에 그룹판정 보완(PKG-only, FE 무수정)**
> 배경: DM ADMIN 그룹 사용자(wonqthanq) 82 편집 불가 — TO-BE FE 가 SP `P_USER_GROUP` 에 그룹명 대신
> USER_ID 를 전달(세션 groupId 유령 필드). AS-IS 계약(그룹명, .cs L1745) 위반이나, 사용자 결정 = FE 무수정 —
> **SP 내부에서 USER_ID → 보유 그룹(SCM_ADM_USER_GR_MPG_M) 해석으로 판정 확장**.

## Step 1 — 클라우드에서 실행 (cloud/01_EXTRACT_PKG_DMF0003.sql)

```sql
SQL> @01_EXTRACT_PKG_DMF0003.sql
-- 산출 2파일 회수: DMF0003_PKG_CLOUD.sql (SPEC+BODY 원문) + DMF0003_PROC_M_CLOUD.sql (INSERT-only)
```

## Step 2 — 사내 반영 (파일 회수 후, Claude 수행)

1. 사내 live 백업: `BACKUP_PKG_DMF0003_{SPEC,BODY}_pre_cloud_20260804.sql` (DBMS_METADATA)
2. `DMF0003_PKG_CLOUD.sql` 적용 (DDL_LOCK_TIMEOUT=280 — BE 기동 중 라이브 재배포 표준)
3. `DMF0003_PROC_M_CLOUD.sql` 적용 (INSERT-only 멱등 — 시그니처 변경 시 positional 대조 후 재정렬 별도 판단)
4. 컴파일 VALID + ALL_ERRORS 0 + 사내↔클라우드 시그니처 diff 보고

## Step 3 — 그룹판정 보완 (반영된 본문 위에 최소 diff 2곳, PKG-only)

같은 계열 전수 sweep 결과 판정 지점 2곳 (사내 2026-08-04 실측 — 클라우드 본문에서 앵커 재확인 후 적용):

**① P_DMF0003_GET_MKT_FCST_DATA — ADMIN 판정** (사내 기준 L5895~5900):
```sql
AND  SEGMENT1    = P_USER_GROUP;
→
AND (SEGMENT1 = P_USER_GROUP
     --[AUTHGROUP 2026-08-04] P_USER_GROUP 에 USER_ID 가 오는 경우(TO-BE 세션 그룹 부재)
     --  보유 그룹(SCM_ADM_USER_GR_MPG_M)으로 확장 판정 — AS-IS 그룹명 직전달과 양립
     OR SEGMENT1 IN (SELECT USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M
                     WHERE USER_ID = P_USER_GROUP AND USE_YN = 'Y'));
```

**② P_DMF0003_GET_SPREAD_TITLE — DM Planner 분기 (AS_FROM_SITE 자동추가)** (사내 기준 L469):
```sql
IF ((p_user_group = 'DM Planner (W/S)' OR p_user_group = 'DM Planner')
→
IF ((p_user_group IN ('DM Planner (W/S)','DM Planner')
     OR EXISTS 판정 불가(PL/SQL IF) → 사전 카운트 변수 v_grp_cnt 조회 후 OR v_grp_cnt > 0)
-- v_grp_cnt: SELECT COUNT(*) FROM SCM_ADM_USER_GR_MPG_M
--            WHERE USER_ID = p_user_group AND USE_YN='Y' AND USER_GR_ID IN ('DM Planner (W/S)','DM Planner')
```

- SAVE SP `P_AUTHORITY` 는 DEFAULT NULL + 게이트 본문 미이식 상태 — sweep 결과 이번 대상 아님 (잠재 항목 기록)
- 검증: ⓐ p_user_group='wonqthanq'(USER_ID) div82 호출 → EDIT_FLAG 'Y' 존재 ⓑ 그룹명 직전달('DM ADMIN') 회귀 ⓒ minyonglee1 회귀

## 참고 — 미채택 산출물 회수 완료

- FE 배선 방식(CMBO 'MktFcstUserAuthGroup')·USER_ID lookup 등재 방식 모두 미채택 — CMBO DB 회수(소비자 0 확인 후 DELETE) + 산출물 파일 삭제 (2026-08-04). FE(useMktFcstStore.ts) 수정분 전량 원복 완료 — FE 무변경 상태.
