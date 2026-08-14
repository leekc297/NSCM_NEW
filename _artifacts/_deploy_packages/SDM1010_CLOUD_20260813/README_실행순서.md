# SDM1010 Project Registration — 클라우드 이관 패키지 (2026-08-13 **v4 — TAB2 정정 + i18n 복구판**)

> **v4 (2026-08-13 오후)**: TAB2(My Project Status) 0행 실사고 정정 — 02 PKG 마커 2계열 추가
> (`[E20260813-TAB2MGMT]` 관리자 본인 프로젝트 포함·ADMIN 표시 / `[E20260813-TAB2COMPNULL]` 등록 미완료 행은
> 완료일 기간 필터 제외 대상 아님). FE 권한 모달 Search 라벨 이중 (F5) 정정.
> ⭐ **fe/scripts/sync-i18n.mjs 동봉** — 구본은 API(구주소) 실패 시 목데이터가 실 locales 를 덮어써
> 전 화면 LBL 이 '_' fallback 표시되는 결함(2026-08-13 실사고). 정정본 반영 후 반드시 `pnpm gen:i18n` 실행.
> 재검증: CRUD 왕복 19/0 · tsc 0 · vitest 53/53.
>
> **v3 (2026-08-13)**: 사용자 지시로 자체 개발 DB 객체(SDM_MST_* 3테이블·시퀀스 2·구 PKG)를 전량 폐기하고,
> 외부 수신 정본(`C:\TRANFILE\RECEIVE\SDM1010` — 작성 KTJ 2026.08.06)으로 교체. FE 도 신 계약으로 전면 재배선.
> 사내 적용·검증 완료(CRUD 왕복 19/0). 전 SQL 멱등.

## 사전조건 (클라우드 SCM_MGR 에 기존재 필수 — 미존재 시 회신)
- `UF_FX_String_Split` FUNCTION + 반환 TYPE (PKG 가 무접두 호출 — 02 컴파일 필수 의존)
- LOOKUP `DM_BIZ_TYPE`(CELL/MODULE/PACK) · 공용 콤보 `MyDivision`/`EndCustomer`/`DmBizType`/`PlantByDivisionCompany`
- `SCM_MST_SITE`(END_CUSTOMER — TAB1/TAB2 INNER 원천)·`SCM_MST_SSO_USER_INFO`/`_DEPT_INFO`·`PR_SCM_SYS_LOG_BATCH`

## A. DB (클라우드 QA·DEV 각각, SCM_MGR — sqlplus/DBeaver 순서 고정)

| # | 파일 | 내용 | VERIFY 기대 (사내 실측) |
|---|---|---|---|
| 1 | `sql/01_DB_OBJECTS.sql` | **수신 테이블 4본** — SPMS_PROJECT_MST(+_BK)/SPMS_PROJECT_USER_MAP(+_BK). 수신 원문 그대로 + 등가조정 1건(PK 자동 인덱스와 중복인 CREATE UNIQUE INDEX 2문 제거) | 테이블 4 |
| 2 | `sql/02_PKG_SDM1010.sql` | **수신 PKG(15 SP) + 최소 정정 패치 17곳** — 마커 3계열(아래 ⚠) | PACKAGE·BODY **VALID** |
| 3 | `sql/03_GRANT_SCMP_APP.sql` | PKG EXECUTE → SCMP_APP | GRANTEE=SCMP_APP 1행 |
| 4 | `sql/04_META.sql` | MSG/LBL/MNU 3계층(유지) + **SHEET_COLUMNS 126행**(신 커서 계약 — TAB1 35/TAB2 36/TREE 6/GRID1 6/GRID2·3 7/GRID4 12/GRID5 17) + **PROC_M 15 SP 93행** + **API_M 23** + **BTN_MPG 23**(period 시트 포함) + 권한그룹 + ROUTE_PATH(말미) | MNU 3 / COLS **126** / PROC **93** / API **23** / BTN **23** / GR 2 / ROUTE 1 |
| 5 | `sql/05_LOOKUP_COMBO.sql` | **LOOKUP 도메인 정비**(REG_STATUS: DRAFT·WRITING·WAITING·COMPLETE·REJECT+색 / AUTH_TYPE: ADMIN·WRITE·READ / AUTH_STATUS·AUTH_REG_STATUS·REG_CAT·CELL_STACK_METHOD 신설 / CELL_TYPE division 종속 재구성) + **콤보 3본**(DpjtClass/CellTypeByDivision/StackMethod — 신 구조) 자급형 | SPMS_* VALID 상세 9종 (DTL 합 33행) |

⚠ **02 패치 마커 (수신본 결함 최소 정정 — 발신처 KTJ 확인 대기, 정오표 상세)**
- `[E20260813-EMPTYCHK]` ×13 — `NVL(x,'') != ''` 는 Oracle ''=NULL 로 **항상 UNKNOWN → SAVE I/M/D 전 분기 사문** → `IS NOT NULL` 등가 정정 (미정정 시 저장 전면 무동작)
- `[E20260813-DRAFTGUARD]` ×2 — INSERT 초기상태 'DRAFT' 가 삭제·등록요청 가드('WRITING' 한정)에 없어 신규행 조작 불가 → `IN ('WRITING','DRAFT')`
- `[E20260813-XTYPE]` ×2 — WRITE 권한 저장(replace-set)이 기존 READ 권한자를 NULL 소거(역도 동일) → 대상 집합을 해당 유형·요청 보유자만 한정
- `[E20260813-TAB2MGMT]` ×3 (v4) — §5 TAB2 는 본인 USER_MAP 권한행 보유 프로젝트만 표시 → **관리자(MGMT_USER_ID=본인)가 등록한 프로젝트가 0행** 실사고. 관리자 본인 포함 + AUTH_TYPE 'ADMIN' 표시(lookup 명칭) + 필터 CASE 동기 + NULL-안전 술어
- `[E20260813-TAB2COMPNULL]` ×1 (v4) — §5 기간 지정 시 `REG_COMP_DATE` NULL(등록 미완료) 행이 BETWEEN 에서 전멸 → 기본 기간(전월~당월말)에서 진행 중 프로젝트 0행. 미완료 행은 완료일 기간 필터 대상에서 제외(항상 표시)
- ⚠ 적용 후 반드시 `SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OBJECT_NAME='PKG_SDM1010';` → **둘 다 VALID** 확인 (spec 조용한 실패 계보)

| 6 | `sql/06_CMBO_SPMS_ENDCUSTOMER.sql` | **SDM1010 전용 고객 콤보** `SpmsEndCustomer` (SCM_MST_SITE div+END_CUSTOMER — §1/§5 INNER 도메인 1:1. 공용 EndCustomer 는 div40 에서 PROJECT_CODE 반환 결함) + TAB1 셀 콤보 교체 | CMBO 1 |

## B. FE (클라우드 리포)
1. `fe/features_sdm/` 전체 → `nscm-fe/features/sdm/` (신 계약 재배선판 — 폐포 단위)
2. 배선 3파일 병합 — `fe/wiring_snippets/README_배선.md` (procedures.d.ts SDM1010 블록 = **신 계약판** 스니펫 동봉)
3. `pnpm install` → `pnpm gen:i18n` → build/deploy

## C. 신 계약 요지 (검수 참고)
- 저장/버튼 = **행별 단건 SP 호출** (activeFlag I/M/D + 컬럼별 파라미터. '^' 다행은 빈 토큰 행밀림 함정으로 미사용). **M/D 는 dpjtKey·dpjtCode·dpjtSeq 실값 필수** (빈 값=조용히 0건)
- 신규 채번 = 서버(TEMP_타임스탬프) — 저장 후 재조회로 실키 수신
- 상태 도메인: 등록 DRAFT→(요청)WAITING→(취소)WRITING / 권한 REQUEST·CONFIRM·REJECT (**REQUEST/CHG_* 구 도메인 폐지**)
- 권한 저장 = replace-set(최종 목록 '^') — 목록 포함=승인(CONFIRM)·요청자 제외=REJECT / 반려 단건 = SAVE_POP_BTN_REJECT
- TAB1 조회 = 본인(MGMT_USER_ID) 관리 프로젝트만·조회조건 없음 / TAB2 = 'ALL' 센티널·기간 지정 시 REG_COMP_DATE NULL(미완료) 행 제외(빈 기간=전체)
- 성공 판정 = CODE '0' + **EVENT 처리건수** (0 = 가드 미충족 무처리 — 성공 토스트 금지)
- 수신본 as-is 특성(미정정·정오표 기록): GET_PERIOD TO-구간 FR_BUCKET 오참조·PW/Y 미구현(FR/TO 동일 bucket D/W/M 만 사용) / MY_WORK SAMPLE_A~D_DATE 하드코딩 placeholder / TAB1 커서 `DPJT_ATUH_*` 오타 alias 4종 = 정본

## D. 적용 후 확인
- CRUD 왕복 러너(`_artifacts/_diagnostics/crud_roundtrip_sdm1010.py` — 신 계약판 19축) 상당 경로를 화면에서: TAB1 행추가(Division 콤보)→저장→재조회(TEMP 키)→등록요청(승인대기)→요청취소→삭제 / 권한관리 팝업(입력·조회 분리 grid, 요청 승인=목록 포함 저장·반려 버튼) / TAB2(기간 기본값=GET_PERIOD) / My Work
