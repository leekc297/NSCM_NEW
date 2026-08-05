# USER_MIG15 — Division별 15계정 USER/GROUP_USER + 권한 정합 이관 패키지

> 생성: 2026-07-27 | 1차 적용: 사내 Oracle SCM_MGR@100.65.143.121:1521/OCGSCMD_P01 **완료·검증 PASS**
> 2차: 사용자가 sql/ 을 클라우드 개발 Oracle에서 직접 실행 (아래 §3)

## 1. 개요

| 항목 | 내용 |
|---|---|
| 대상 계정 | 14명 (40: hongjae.kim/eunah.koo/yooah.chung/dodae, 81: jiwon.park/bpark416/jaehyeok/park6151/bottle, 82: wonqthanq/ys_cho/miyeong.lee/yeonjusung/coeogus) — minyonglee1 제외 기존재 |
| 소스 | DEV MSSQL LGCE_SCMDEV — 프로필 정본 `TB_FX_User_20260715_PROD`(운영 스냅샷) + miyeong.lee 만 `TB_FX_User`(DEV) 폴백 |
| 그룹매핑·Division권한 정본 | **사용자 지정 역할 목록** (2026-07-27 확정 — DEV TB_FX_UserGroupInfo 는 구버전이라 미채택, 참고 덤프만 보존) |
| 권한(메뉴/버튼) | AS-IS TB_FX_GroupMenuAuth(UseYN='Y') 근거 × **실행 시점 SCM_ADM_MNU_M 등재 메뉴 교집합 + 조상 메뉴** gap 만 보충. TO-BE 미생성 UI 는 제외 (사용자 지시) |
| 충돌 정책 | USER_M=MERGE(단 LOGN_DTM/ACNT_LOK_YN 불변) / 매핑·권한=NOT EXISTS (기존 row 무변경) |
| titleset | **이관 제외** (사용자 지시 2026-07-27) |
| 감사컬럼 | 'admin' / SYSDATE |

## 2. 파일 구성 / 실행 순서 (사내 = 완료)

```
extract/00_extract_dev.py      DEV 추출기 (asis.py 재사용) → asis_*.txt 5종
extract/01_extract_prod.sql    (참고) 운영 재추출용 SELECT 5본
build/group_map.csv            지정 역할 → TO-BE 그룹/EDIT_YN 매핑 (정본)
build/program_mnu_map.csv      AS-IS ProgramID → TO-BE MNU_ID 검토표 (581쌍 중 IN_TOBE=N 446 제외)
build/10_build_sql.py          SQL 생성기 (검증 assert: USER_ID≤30, GR≤20, ATR≤300)
sql/19_user_gr_seed.sql        'SCP Planner' 그룹 신설 (TO-BE 부재 — 사용자 확정)
sql/20_user_m_merge.sql        SCM_ADM_USER_M 14행 MERGE
sql/21_user_gr_mpg_insert.sql  SCM_ADM_USER_GR_MPG_M 14행 (NOT EXISTS + 그룹존재 방어)
sql/22_unit_auth_insert.sql    SCM_ADM_USER_GR_UNIT_AUTH_MPG_M 14행 ('D'/40·81·82/UPPR='-'/Viewer만 EDIT_YN='N')
sql/30_auth_gap_diagnose.sql   권한 gap 진단 5종 (읽기 전용)
sql/31_gr_mnu_mpg_merge.sql    메뉴권한 보충 (조상 포함, NOT EXISTS)
sql/32_gr_mnu_btn_mpg_merge.sql 버튼권한 보충 (조회성=항상 / INSERT·NEW=C / DELETE=D / 그 외=U 비트)
sql/90_VERIFY.sql              검증 5종 (건수/14조합/DEPT/한글/권한카운트)
verify/91_verify_sp.py         UI SP 직접 콜 자동판정 (PKG_SYS0002 + P_SYS0014_*)
verify/92_run_diagnose.py      30번 진단 실행기 (fetch 출력)
```

실행 순서: **19 → 20 → 21 → 22 → (30 진단) → 31 → 32 → 90 검증**. 전 파일 멱등 (재실행 무변화 확인 완료).

## 3. 클라우드 개발 Oracle 적용 절차 (사용자 직접 실행)

1. 사전 확인 (권장): `SELECT USER_GR_ID FROM SCM_ADM_USER_GR_M;` — 그룹 16종 존재 대조
2. DBeaver/sqlplus 에서 `sql/19 → 20 → 21 → 22` 순서대로 실행 (각 파일 말미 COMMIT 포함)
3. `sql/30` 실행 (SELECT 만 — 진단 1·2 gap 목록 확인, 진단 3 = TO-BE 미구현 제외 목록)
4. `sql/31 → 32` 실행 → `sql/30` 재실행하여 진단 1·2 = 0 rows 확인
5. `sql/90_VERIFY.sql` — [1] USER_M=14/GR_MPG=14/SCP Planner=1, [2] 14행 전부 OK/OK 확인
6. 주의: 31/32 는 **실행 시점 클라우드 SCM_ADM_MNU_M / SCM_ADM_MNU_BTN_MPG_M 기준**으로 교집합 계산 — 클라우드 메뉴 구성이 사내와 달라도 안전 (미등재 메뉴는 자동 제외)

## 4. 사내 적용 결과 (2026-07-27)

- 건수: USER_M 14 / GR_MPG 14 / UNIT_AUTH 신규 10 (+기존재 4 skip) / SCP Planner 그룹 1 신설
- 권한 보충 후: MNU 249 / BTN 854 (5그룹 합) — gap 진단 1·2 = **0 rows**, 멱등 재실행 무변화
- SP 검증 (`91_verify_sp.py`) **PASS**: SYS0002 GET 14계정 전원 노출 / SYS0014 그룹목록 SCP Planner 포함 / 그룹별 기대 인원 전원 / AUTH_LIST 3표본 정상
- 비차단 리포트: ① DEPT 미존재 2명 (ys_cho 71050265, yeonjusung 71059519 — SCM_MST_SSO_DEPT_INFO 부재 → 화면 부서명 '-' 표시) ② API 배선 부재 버튼 7건 (DMF0020 main INSERT/DELETE, DMF0043 main VERSION_MGT, DMF0072 main INSERT/DELETE, DMF0082 futurePriceInfo EDIT/INSERT — 권한 아님, 별도 배선 과제)

## 5. 제외/보류

- titleset (사용자별 그리드 설정) — 사용자 지시로 제외
- TO-BE 미생성 UI 446 (group,menu) 쌍 — 제외 (`build/program_mnu_map.csv` IN_TOBE=N 목록)
- JV Planner 계열 (TB_FX_USERGROUPAUTHEXTENTION JV_PLANT_ID) — 15명 범위 밖
- SYS0002/SYS0014 화면 자체 접근권한: ADMIN/SCM PI Admin 만 보유 (AS-IS 에서도 15명 그룹에 권한 없음 — 현행 유지)
