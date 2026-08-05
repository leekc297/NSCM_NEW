# USER_MIG15_CLOUD — 클라우드 이관용 취합 패키지 (운영 MSSQL 추출 → Oracle 적용 2단)

> 생성: 2026-07-27 | 목적: Division별 15계정(신규 14명) USER/GROUP_USER + 권한 정합을
> **클라우드에서 운영 MSSQL(LGCE_SCMPROD) 기준으로 추출 → 클라우드 개발 Oracle(SCM_MGR)에 적용**
> 선행: 사내 Oracle 1차 적용·검증 PASS 완료 (원본 패키지 `USER_MIG15_20260727_1104`)
> 검증: 본 패키지 M-파일 4종은 DEV MSSQL(동일 스키마)로 생성 테스트 → 생성물 Oracle ROLLBACK 실행 검증 완료 (FAIL 0)

## 1. 구조 — 2단 실행

```
mssql/   ← [1단] 운영 MSSQL 에서 실행. "결과(SQL_TEXT 컬럼) 자체가 Oracle 실행용 SQL"
│  M20_gen_O20_user_m_merge.sql        → 결과를 oracle/O20_user_m_merge.sql 로 저장
│  M30_gen_O30_auth_gap_diagnose.sql   → 결과를 oracle/O30_auth_gap_diagnose.sql 로 저장
│  M31_gen_O31_gr_mnu_mpg_merge.sql    → 결과를 oracle/O31_gr_mnu_mpg_merge.sql 로 저장
│  M32_gen_O32_gr_mnu_btn_mpg_merge.sql→ 결과를 oracle/O32_gr_mnu_btn_mpg_merge.sql 로 저장
oracle/  ← [2단] 클라우드 개발 Oracle 에서 실행
│  O19_user_gr_seed.sql        (정적) 'SCP Planner' 그룹 신설
│  (O20)                       ← M20 결과 저장
│  O21_user_gr_mpg_insert.sql  (정적) 그룹-사용자 매핑 14행 — 지정 역할 목록 정본
│  O22_unit_auth_insert.sql    (정적) Division 권한 14행 (40/81/82, Viewer만 EDIT_YN='N')
│  (O30/O31/O32)               ← M30/M31/M32 결과 저장
│  O90_VERIFY.sql              (정적) 검증 5종
│  _prebuilt_corp/             (예비) 사내 1차본 20/30/31/32 — 운영 MSSQL 접속 불가 시 대체 사용
```

- **M-파일이 있는 대상(프로필·권한)** = 운영 MSSQL 이 데이터 원천 → 추출·생성 2단.
- **정적 O-파일(그룹신설·역할매핑·Division권한)** = 정본이 "사용자 지정 역할 목록"(2026-07-27 확정)이라 MSSQL 추출 불필요.

## 2. [1단] 운영 MSSQL — M-파일 실행 방법

1. DBeaver(또는 SSMS)로 운영 LGCE_SCMPROD 접속
2. `mssql/M20 → M30 → M31 → M32` 각각 실행
3. 결과 그리드의 **SQL_TEXT 컬럼 전체**를 복사해 파일명 그대로 `oracle/` 에 저장
   - DBeaver: 결과 그리드 전체 선택 → 셀 값 복사 (헤더 제외, 따옴표 감싸기 없음 확인)
   - SSMS: Ctrl+T(결과를 텍스트로) 후 실행 → 결과 저장. `SET NOCOUNT ON` 포함되어 행수 메시지 없음
   - 저장 인코딩: **UTF-8** (한글 이름 포함)
4. 저장 후 육안 확인: 파일 첫 줄 = `-- O2x/O3x ...` 주석, 마지막 줄 = `COMMIT;` (O30 제외)

## 3. [2단] 클라우드 개발 Oracle — 실행 순서

```
O19 → O20 → O21 → O22 → O30(적용 전 진단) → O31 → O32 → O30(재실행: 진단1·2 = 0 rows 확인) → O90
```

- 전 파일 **멱등** (MERGE / NOT EXISTS) — 재실행 안전, 기존 row 무변경 (O20 만 프로필 UPDATE, 단 LOGN_DTM/ACNT_LOK_YN 불변)
- O31/O32 는 **실행 시점 클라우드 `SCM_ADM_MNU_M`/`SCM_ADM_MNU_BTN_MPG_M` 과의 교집합**으로 계산
  → **TO-BE 미생성 UI 자동 제외** (사용자 지시 2026-07-27). 미생성 목록은 O30 진단3 으로 확인
- O90 기대값: [1] USER_M=14 / GR_MPG=14 / SCP Planner 그룹=1, [2] 14조합 전부 OK/OK,
  [3] DEPT 미존재 = 비차단 리포트(부서명 '-' 표시 대상), [4] 한글 정상, [5] 권한 카운트

## 4. 대상 계정 (Division / 역할 → TO-BE 그룹)

| Div | DM Admin→DM ADMIN | DM Planner→DM Planner | DM Planner(W/S)→DM Planner (W/S) | DM Viewer→DM Viewer | SCP Planner→SCP Planner(신설) |
|---|---|---|---|---|---|
| 40 | hongjae.kim | eunah.koo | — | yooah.chung | dodae |
| 81 | jiwon.park | bpark416 | jaehyeok | park6151 | bottle |
| 82 | wonqthanq | ys_cho | miyeong.lee | yeonjusung | coeogus |

## 5. 규칙 요약 (생성 SQL 에 내장)

- 감사컬럼 = 'admin' / SYSDATE. NOT NULL 보충: ACNT_LOK_YN='Y', PERM_KEP_CNC_YN='N', TMZ_CD 기본 'AS054', LANG_CD 기본 'KO'
- 버튼권한 규칙(AS-IS ACL 비트): 조회성(SEARCH%/EXCEL/FILTER/SORT/COLUMN_SETUP/MEASURE_SELECT/TITLE 등)=메뉴 부여 시 항상 / INSERT·NEW=C / DELETE=D / 그 외 편집성=U
- 메뉴권한은 조상 메뉴까지 자동 부여 (CONNECT BY NOCYCLE walk-up — 트리 표시 보장)
- titleset 이관 제외 (사용자 지시)

## 6. 제한/참고

- 운영 MSSQL 접속 불가 시: `oracle/_prebuilt_corp/` 의 사내 1차본(운영 0715 스냅샷 근거)을 O20/O30/O31/O32 대신 사용 가능
- 사내 1차 결과: gap 0 / SP 검증 PASS / 비차단 리포트 = DEPT 미존재 2명(ys_cho·yeonjusung), API 배선 부재 버튼 7건 (상세: `USER_MIG15_20260727_1104/_README.md` §4)
