# DMF0003 (MKT FCST) — 클라우드 전체 이관 패키지

> **신규 이관 기준 전체 취합** — FE 화면 전체 + DB 메타 전량(사내 OCGSCMD_P01 실측) + SP/PKG DDL.
> 클라우드 환경에서 DMF0003 을 **처음부터 배포**할 수 있도록 자급 구성. (2026-07-20 보완분 포함)

- 화면 ID: **DMF0003** (MKT FCST / 시장예측) · 도메인 `demand` · slug `mkt_forecast`
- DM 6단계 중 **②수요예측 입력** 단계 · 원장 테이블 `DM_PLN_MKT_FCST`
- 근거: `Doc/화면분석서/DMF0003_MktFcst_UI분석서_v2.2.xlsx` + FE `__asis-mapping__.md`

---

## 1. 패키지 구성 (fe 25 + sql 8 + sp 25)

> ⭐ **2026-07-20: 저장 SP 를 PKG 로 병합** — standalone `DMF0003_SAVE_MKT_FCST` 를 `PKG_DMF0003.P_DMF0003_SAVE_MKT_FCST` 멤버로 이관(UI별 PKG 원칙, 본문 무수정·p_authority 반영본). 배선 전환 = sql/08. 메인 조회(`PKG_DMF0003.P_DMF0003_GET_MKT_FCST_DATA`)와 동일 규약. standalone 은 패키지에서 제외.


```
DMF0003_20260720_1625/
├── fe/features/demand/src/pages/mkt-fcst/     ← 화면 전체 24파일 + __asis-mapping__.md
│   ├── MktFcst.tsx / index.ts / *.constants.ts / *.types.ts / useMktFcstStore.ts / *.module.scss
│   ├── components/  (MktFcstForm, MktFcstGrid + modals 6종)
│   └── utils/       (division/editLock/merge/prContext/recalc/save/sspSync/validate)
├── sql/                                        ← DB 메타 전량 (멱등 MERGE, 사내 실측)
│   ├── 01_DMF0003_menu_api_button.sql          MNU_M 1 / MNU_BTN_MPG 24 / API_M 24
│   ├── 02_DMF0003_proc_m.sql                   PROC_M 212 (DMF0003 SP 시그니처 배선)
│   ├── 03_DMF0003_sheet_columns_measure.sql    SHEET_COLUMNS 96 / SHEET_MEASURE 47
│   ├── 04_DMF0003_authority.sql                USER_GR_MNU 3 / USER_GR_BTN 72
│   ├── 05_DMF0003_combo.sql                    CMBO_SQL_M 27 (전용+공유 사용분)
│   ├── 06_DMF0003_message.sql                  MSG_M 75 (25 ID × KO/EN/CN)
│   ├── 07_DMF0003_lookup.sql                   LOOKUP_MASTER 13 / DETAIL 269
│   └── 08_DMF0003_save_pkg_wiring.sql          ⭐ 저장 SP PKG 병합 배선(PROC_M PKG 한정 + API_M 전환)
├── sp/                                         ← SP/PKG DDL (CREATE OR REPLACE, 사내 실측)
│   ├── DMF0003_*.sql  (standalone 22종 — GET_MKT_FCST_DATA/GET_SPREAD_TITLE 등, ⚠ SAVE 는 PKG 병합)
│   ├── PKG_DMF0003_SPEC.sql / PKG_DMF0003_BODY.sql  (⭐ P_DMF0003_SAVE_MKT_FCST 멤버 포함)
│   └── _SP_MANIFEST.md
├── _README.md
└── _COMMON_FILES_GUIDE.md                      ← 신규 배포 시 공통 파일 patch
```

> 메타 총 863행 전수 export (12 테이블). SP 25 객체.

## 2. 2026-07-20 보완분 (전체에 이미 반영됨)

AS-IS 최신 결재 2건(E20260402 AS개선 / E20260604 기준수요) 10항목 + 조회 UX 3건. 상세 = `Doc/_archive/work_reports/2026-07-20_DMF0003_asis_latest_reflect.md`. 핵심:
- SAVE SP `P_AUTHORITY`(16번째 IN) — sp/DMF0003_SAVE_MKT_FCST.sql + 02 PROC_M authority(SORT_ORD 16) 반영
- MSG00476/00477/00478 — 06 포함 / CMBO FcstTypeEditMode·FcstTypeWs·시간창 2종·MktFcstUserGroups — 05 포함
- FE: SCP 차단·시간창·AS FROM SITE·FCST_TYPE 콤보·spreadTitle LOAD·Measure 콤보 mnuId·Division 초기화·SUM visible

## 3. 적용 순서 (클라우드 — 신규 배포)

### Step 1. 브랜치
```
git checkout -b feat/dmf0003-full-transfer-20260720
```

### Step 2. SP/PKG 배포 (SCM_MGR) — 의존 인프라 선행
```
# PACKAGE 먼저(SPEC→BODY), 그 다음 standalone. 의존 뷰/공유함수/GTT 는 클라우드 기존재 가정.
sqlplus SCM_MGR/**@{dsn} @sp/PKG_DMF0003_SPEC.sql
sqlplus SCM_MGR/**@{dsn} @sp/PKG_DMF0003_BODY.sql
# standalone (순서 무관, 반복 컴파일 권장)
for f in sp/DMF0003_*.sql; do sqlplus SCM_MGR/**@{dsn} @$f; done
```
- ⚠ SP 재배포 세션 pin hang(hook #107 §4) 주의 — 접속 종료 후 또는 `ALTER SESSION SET DDL_LOCK_TIMEOUT=30`.
- 컴파일 오류 시 의존 객체(SCP_MST_BOD_V 등 뷰, UP_FX_* 공유함수, GT_* GTT) 우선 확인 — 본 패키지 범위 밖(공유 인프라).
- VALID 검증: `SELECT object_name,status FROM all_objects WHERE object_name LIKE 'DMF0003%' OR object_name='PKG_DMF0003';`

### Step 3. DB 메타 등록 (01→08 순서)
```
for n in 01 02 03 04 05 06 07 08; do sqlplus SCM_MGR/**@{dsn} @sql/${n}_DMF0003_*.sql; done
```
- 전부 멱등 MERGE — 재실행 안전, 기존 값은 정합.
- ⚠ **저장 SP 는 PKG 병합** — 02 PROC_M(`PKG_DMF0003.P_DMF0003_SAVE_MKT_FCST` 18행, authority 16) + 08 API_M 배선(`DMF0003_main_SAVE`→PKG 한정명) + sp/PKG_DMF0003_BODY.sql(SAVE 멤버) **3점 정합** 필수. 한쪽만 적용 시 -9994/positional.
- SCP/DM_PLANNER_EDIT_FLAG lookup 은 운영값 협의 대기(디테일 0행 가능) — 07 은 마스터/현존 디테일만 이관.

### Step 4. FE 파일 복사 (전체 폴더)
```
robocopy fe\features\demand\src\pages\mkt-fcst {repo}\nscm-fe\features\demand\src\pages\mkt-fcst /E
```

### Step 5. 공통 파일 patch (`_COMMON_FILES_GUIDE.md`) — 신규 배포 시 Router/라우트 등록 확인

### Step 6. 빌드 (`pnpm type-check && pnpm lint && pnpm build`) → Step 7. 브라우저 동작 검증

## 4. 트러블슈팅
- "빈 결과" → 02 PROC_M 미적용(SP 시그니처 positional 불일치) / SP INVALID
- "No Permission"(-9994) → 04 권한 2테이블 미적용 / 로그인 그룹 미배정
- "API not found" → 01 API_M·BTN_MPG 미적용
- Grid 컬럼 빈 상태 → 03 SHEET_COLUMNS 미적용
- Measure 코드 표시 → 05 CMBO 'Measure' 미적용 또는 FE mnuId 전달 누락(hook column-lookup-meta §1.3.1)
- Model Name 공백 → 사용자 TITLESET_USER 'C' 에 ITEM_NAME 미포함(데이터, 코드 아님) — Column Setting 에서 선택 또는 titleset seed

## 5. 잔여·협의 (상세 보고서 §4)
1. 시간창 LOOKUP 운영값(SCP/DM_PLANNER_EDIT_FLAG) 0행 — 협의 후 등록
2. MSG00478 실문구 잠정 — AS-IS 대사 후 확정
3. SAVE SP 저장 시간창 게이트 본문(AS-IS L597~686) 미이식 — 원문 확보 후
4. 권한 그룹 E2E — SCP Planner 소속자 배정 후 UT(E20260706-000169) 준용

## 6. 메타데이터
- 작성: Claude Fable 5 (2026-07-20) · 룰: 22_PACKAGE_ARTIFACTS / hook #105
- 검증: FE tsc 0 · 사내 메타/SP 전수 실측 export · regression-impact Hard Boundary 0
- ⚠ SP/공유콤보/공유lookup 은 AS-IS 자산 — 클라우드에 이미 있으면 MERGE/CREATE OR REPLACE 가 현행 정합(무해)
