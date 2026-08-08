# SYS0017 Mail Setup — 증분 패치 이관 패키지 MANIFEST (2026-08-06)

취합: **2026-08-06** | 대상 화면: **SYS0017 Mail Setup** (AS-IS SCM0006)

> **2026-08-07 추가 반영 (P4 — 근본원인 감사 후속)**: 문서 대비 잔여 2건 구현분 동기 —
> ① **B1** Category 저장 전 중복검사 (키 = CATEGORY_ID 단독, 제약매트릭스 B1 / AS-IS L1454~1493 1:1,
> 삭제 'D' 행 제외 전 행 대비, 위반 시 MSG00060 중단) → `MailSetup.tsx` handleSaveCategory
> ② **E02-3** 마스터(Category) 재조회 시 하위 영역(Message/Sel_Receiver/All_Receiver) 데이터·선택·
> ▶ 이동 백업 클리어 (AS-IS FindData_Main L391~393 1:1) → `MailSetup.tsx` handleSearch +
> `useMailSetupStore.ts` setFilters. 변경 2파일의 §4 인벤토리 갱신 완료 (diff 0 재확인).

> ⭐⭐ **선행 전제 (필수)**: 본 패키지는 `SYS0017_MAILSETUP_20260729` 패키지(43파일 — PKG_SYS0017
> SPEC/BODY + DDL 자급 + 메타 전세트 + FE 초판)가 **먼저 적용된 환경에만** 적용하는 **증분 패치**다.
> `00_PRECHECK.sql` [A] 섹션이 기대값 미달이면 선행 패키지부터 적용할 것.
>
> ⭐⭐ **QA·DEV 2 DB 동시 적용 의무**: 클라우드 DB 적용물은 항상 QA(BE 계정 SCMQ_APP)와
> DEV(BE 계정 SCMP_APP) 두 DB 에 **같은 날 동시 적용**한다 (한쪽만 적용 시 "클라우드만 실패"
> 진단 소음의 1순위 원인 — `feedback_cloud_be_build_out_of_sync_diagnosis` 계보).
> 본 패치는 신규 객체가 없어(UPDATE 메타 + FE 만) GRANT/SYNONYM 추가 작업은 **불요** —
> 선행 패키지의 `sp/03_GRANT_SYNONYM.sql`·`04_APP_SYNONYM_ONLY.sql` 이 이미 적용된 상태를 전제.

## 1. 무엇을 고치는 패치인가 — 검증 피드백 13건 (2026-08-06)

13건 중 9건이 아래 **구조 결함 3개(S1~S3)** 로 수렴 (플랜: `sys0017-mailsetup-feedback-13.md`):

| # | 결함 | 조치 | 반영 위치 |
|---|---|---|---|
| S1 | 행상태 이원화 — 자체 `rowStatus` ≠ 프레임워크 표준 `CRUD_TYPE` → 공통버튼·셀편집 변경이 저장 페이로드 0건 (#4·#8·#9·#12, SYS_LOG 실증 SAVE 0회) | `rowStatus` 전면 제거 → `CRUD_TYPE('I'/'M'/'D')` 전환 | 02_FE (MailSetup.tsx / types / util / store) |
| S2 | SHEET_COLUMNS 메타 결함 — 전 32행 `INPUT_TP_CD='IM'`(기존 행 편집 전면 불가) + 콤보 8행 CTRL `'C'`(표준 `'FPComboBox'` 아님 → dataMap 자동 배선 불발, 코드 원문 표시) (#4·#5·#6·#8) | CTRL 8행 `'FPComboBox'` + INPUT_TP_CD 시트별 M/O/S/IM 정정 | **01_META** |
| S3 | 저장 결과 무검증 — axios 인터셉터가 오류도 resolve → 실패해도 성공 alert (#3·#12·#13) | `res.status>=400 \|\| Number(res.data.code)` 판정 의무화 | 02_FE (MailSetup.tsx) |

개별 항목 조치 (FE 11파일에 분산):

- 저장 3핸들러 CRUD_TYPE 전환 + 성공 판정 + `sesUserId` 감사키 전달 / 성공 토스트 `setToast`·`{0}` 치환
- Insert/Delete 공통버튼 **활성 그리드 라우팅** (hook #97)
- F5 새로고침 `focusedArea` 분기 (E13)
- ▶/◀ 수신자 이동 + All Receiver **더블클릭 이동** + 취소 시 **백업 스택 복원** (E14·E15)
- Period(Main~Sub) cascade **dataMap 스왑·편집차단(MSG00693)·하위 clear** (hook #59 §5-G)
- Message 4,000바이트 초과 시 MSG00698 + **원복** (E12)
- MailSqlDialog/MailContentDialog — `customContentArea` 는 공통 OK/Cancel footer 미렌더 → **자체 footer** (정본 ExchangeRateModal)
- #1·#2(조회 콤보)·#3(브라우저 팝업)·#10(F5) 은 현 코드·사내 DB 기준 **정상 실측** — 검증 환경(빌드 시점/대상 DB) 대조 항목

검증(사내): tsc mail-setup 0건 / eslint 0건 / 메타 32행 재조회 PASS. 저장 SP 실행은 금지 준수 — 저장 동작은 사용자 화면 검증 몫.

## 2. 실행 순서 (QA·DEV 각각)

```
Step 0. 00_PRECHECK.sql            (SCM_MGR, read-only — [A] 선행 판정 / [B] 기적용 판정)
Step 1. 01_META/SYS0017_META_FEEDBACK_FIX_20260806.sql
        (SCM_MGR — 차이가드 UPDATE 멱등: 재실행 0행. 파일 끝 COMMIT 포함)
Step 2. 02_FE/mail-setup/ → nscm-fe/features/admin/src/pages/mail-setup/ 전체 덮어쓰기 (17파일)
        ⚠ 부분 파일 복사 금지 — 폴더 단위 전체 교체 (클라우드 셸 세대 혼재 방어)
Step 3. cd nscm-fe && pnpm type-check && pnpm build → 브라우저 검증
        (procedures.d.ts / locales / barrel / Router 변경 없음 — 선행 패키지 fe-common 그대로)
```

Step 1 사후 검증 = `00_PRECHECK.sql` [B-1]/[B-2] 재실행: CTRL_C=0·FPComboBox=8, INPUT_TP_CD 목표 분포
(main IM3/M2/O4/S2 · message IM1/M2/S3 · selReceiver S9 · allReceiver S6).

## 3. 원본 대조 (source of truth)

| 구분 | 대조 | 결과 |
|---|---|---|
| `01_META/SYS0017_META_FEEDBACK_FIX_20260806.sql` | `_artifacts/_apply_corporate/` 동일 파일 diff | **0 (동일)** |
| 01_META 목표값 ↔ 사내 DB 현재값 | 사내 OCGSCMD_P01 실측 2026-08-06 22:40 (SCM_MGR@ol9-db) | **일치** — 32행, CTRL FPComboBox 8/'C' 0, INPUT_TP_CD 분포 목표와 정확 일치, PKG_SYS0017 SPEC/BODY VALID |
| `02_FE/mail-setup/` ↔ 로컬 `nscm-fe/features/admin/src/pages/mail-setup/` | `diff -rq` | **0 (17파일 전부 동일)** |
| 선행 패키지(20260729) FE 대비 | `diff -rq` | **11파일 변경 / 6파일 동일** (§4 표의 `변경` 컬럼) |

사내 실측 메타 카운트 (선행+본 패치 적용 완료 상태 = PRECHECK 기대값 근거):
MNU_M 1 / API_M 9 / BTN_MPG 14 / PROC_M 67행(9 SP) / SHEET_COLUMNS 32 /
AUTH_MNU 2그룹(ADMIN·SCM PI Admin) / AUTH_BTN 28(2그룹×14) /
CMBO 6종(Mail* 5 + 공용 YesOrNo).

## 4. 파일 인벤토리 (SHA-256 앞 16자)

| 파일 | bytes | sha256 | 20260729 대비 |
|---|---:|---|---|
| `00_PRECHECK.sql` | 4716 | `46129b18acbb754b` | 신규 (본 패치용) |
| `01_META/SYS0017_META_FEEDBACK_FIX_20260806.sql` | 5284 | `c822207844230bca` | 신규 (S2 정정) |
| `02_FE/mail-setup/MailSetup.tsx` | 25255 | `855983c0d2fb0525` | **변경** (S1/S3·#3,4,8~13 + 8/7 B1·E02-3) |
| `02_FE/mail-setup/MailSetup.module.scss` | 398 | `b6cc07688ccd82d2` | 동일 |
| `02_FE/mail-setup/mail-setup.constants.ts` | 1285 | `fb29190278cc84dc` | **변경** |
| `02_FE/mail-setup/mail-setup.types.ts` | 746 | `718e6df840bbec45` | **변경** (rowStatus 제거) |
| `02_FE/mail-setup/mail-setup.util.ts` | 2772 | `3c8e0d9566921e33` | **변경** (createEmptyCategory 활성화) |
| `02_FE/mail-setup/useMailSetupStore.ts` | 9056 | `61e999504b7865e8` | **변경** (focusedArea·이동 백업 스택 + 8/7 E02-3 하위 클리어) |
| `02_FE/mail-setup/index.ts` | 41 | `7601cef0b8c089dc` | 동일 |
| `02_FE/mail-setup/components/MailCategoryGrid.tsx` | 8589 | `ad4ba27ef713dffa` | **변경** (cascade dataMap 스왑 #59 §5-G) |
| `02_FE/mail-setup/components/MailCategoryGrid.module.scss` | 148 | `293673c9044ba2a6` | 동일 |
| `02_FE/mail-setup/components/MailMessageGrid.tsx` | 3105 | `fa5af2f2c2b80d58` | **변경** (4,000바이트 원복) |
| `02_FE/mail-setup/components/MailReceiverPanel.tsx` | 4653 | `69ebf50fe85530ad` | **변경** (더블클릭 이동) |
| `02_FE/mail-setup/components/MailContentDialog.tsx` | 2777 | `3e81ed0d593badec` | **변경** (자체 footer) |
| `02_FE/mail-setup/components/MailSqlDialog.tsx` | 3008 | `94d67994d07a3e12` | **변경** (자체 footer) |
| `02_FE/mail-setup/components/MailDialog.module.scss` | 722 | `79ea4d2029f633dd` | **변경** (footer 스타일) |
| `02_FE/mail-setup/components/MailSetupForm.tsx` | 3385 | `48a8cc7017d8e35f` | 동일 |
| `02_FE/mail-setup/components/MailSetupForm.module.scss` | 29 | `41fd464a7bf75874` | 동일 |
| `02_FE/mail-setup/components/MailTabGrid.module.scss` | 534 | `de0cad73f0d08d8f` | 동일 |

총 19파일 (PRECHECK 1 + META 1 + FE 17) + 본 MANIFEST.

## 5. 스테일 판정 명령 (다음 재취합 전 실행 — 0건이어야 최신)

```bash
diff -rq _artifacts/_deploy_packages/SYS0017_MAILSETUP_PATCH_20260806/02_FE/mail-setup \
         nscm-fe/features/admin/src/pages/mail-setup
diff -q  _artifacts/_deploy_packages/SYS0017_MAILSETUP_PATCH_20260806/01_META/SYS0017_META_FEEDBACK_FIX_20260806.sql \
         _artifacts/_apply_corporate/SYS0017_META_FEEDBACK_FIX_20260806.sql
```

## 6. 잔여 (본 패치 범위 외 — 인지 필요)

- 선행 패키지의 클라우드 SYNONYM(앱 계정 세션 실행분)·전체 적용 여부는 PRECHECK [A] 로 판정.
- ~~Category CATEGORY_ID 중복검사(B1)·마스터 재조회 시 하위 클리어(E02-3) = 스펙 외 후속 후보 (미포함)~~
  → **2026-08-07 반영 완료** (헤더 추가 반영 블록 참조 — MailSetup.tsx / useMailSetupStore.ts).
- 저장 동작 최종 검증 = 사용자 화면 몫 (저장 SP 실행 금지 정책 준수).
- MSG/LBL/MNU/API 명칭 메타: 본 패치의 FE 는 **기존 등록분만 사용, 신규 채번 0건** —
  FE 사용 코드 28종 전수 추출 후 대사 완료 (2026-08-06 실측):
  - 24종 = 사내 `SCM_ADM_MSG_M` 등록 확인. 그중 SYS0017 신설 19키(MSG00690~698·LBL00774~782·MNU00690)는
    선행 패키지 `sql/01_P1_meta_wiring.sql` + `fe-common/locales.SYS0017_PATCH.json` 에 동봉되어 있음.
  - ⚠ **4종(LBL00378 Sub Module / LBL00379 Module / LBL00383 Message Setup / LBL00407 Remove)은
    사내 MSG_M 미등록·locales JSON 에만 실값 존재** (런타임 원천 = locales 이므로 화면 동작 무영향,
    FE 는 fallback 기본값도 지정). 클라우드 locales 에 이 4키가 있는지 적용 후 화면에서 라벨 확인.
    DB MSG_M 등록(3점 동시 반영, hook #114 §5)은 별도 후속 — 본 패치 범위 외로 목록화만 함.
