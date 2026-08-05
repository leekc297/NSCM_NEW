# SYS0017 Mail Setup — 클라우드 이관 패키지 (2026-07-29)

> AS-IS `SCM0006_Mail_Setup` → TO-BE **SYS0017** (admin / `features/admin/src/pages/mail-setup`)
> 사내 OCGSCMD_P01 **적용·검증 완료**, **클라우드 미적용**.
> 설계 근거: `Doc/화면설계서/SYS0017_MailSetup_화면설계서_v1.0.xlsx` + `Doc/화면분석서/SYS0017_MailSetup_UI분석서_v1.0.xlsx`
> 범위(사용자 확정): Mail 만(SMS=SCM0007 스키마 공유 보존) / PopSQL AS-IS 유지 / 격차 3건 권장안 적용.

## 폴더 구성

```
SYS0017_MAILSETUP_20260729/
├ 00_PRECHECK_CLOUD.sql        ← ★ 가장 먼저 실행 (read-only 선판정 8섹션)
├ 02_DB_DDL/                   ← 클라우드 미존재 시에만 실행 (자급용)
│  ├ 01_tables.sql             RECIPIENT 4 + 이력 _H 3 (인덱스·제약·코멘트 포함)
│  ├ 02_sequence.sql           SEQ1_SCM_ADM_RECIPIENT_LIST (CATEGORY_ID 채번)
│  └ 03_dependent_objects.sql  이력 SP 3 + 함수 3(FN_GET_SOURCE_CODE / SCM_ARR_SPL_CNT / _VAL)
├ sp/
│  ├ PKG_SYS0017_SPEC.sql      9 멤버 스펙 (ALL_ARGUMENTS 실측 positional)
│  ├ PKG_SYS0017_BODY.sql      본문 — 사내 VALID 7본 **무수정 승계** + INVALID 2본 재변환
│  ├ 03_GRANT_SYNONYM.sql      GRANT EXECUTE (SCM_MGR 세션 / 어휈 계정 자동 판별)
│  ├ 04_APP_SYNONYM_ONLY.sql   ⛔ SYNONYM — **어휈(BE 접속) 계정 세션 전용** (클라우드=SCMP_APP)
│  ├ 05_DIAG_9994.sql          -9994 원인 판별 (SCM_MGR)
│  ├ _orig/                    사내 standalone 9본 원문 덤프(승계 대조용)
│  └ build_pkg.py              PKG 재생성기
├ sql/                         메타 (전 문장 멱등)
│  ├ 01_P1_meta_wiring.sql     MNU 1 + MSG_M(MNU 1 + MSG 9 + LBL 9)×3언어 + API_M 9 + BTN_MPG 14
│  ├ 02_P2_proc_m.sql          PROC_M 9 SP (camelCase COL_NM, OUT=PROC_RESULT)
│  ├ 03_sheet_columns.sql      SHEET_COLUMNS 4시트 32컬럼 (align C/L/R, INPUT_TP_CD 'IM', 셀콤보 8)
│  ├ 04_P4_user_gr.sql         권한 2테이블 (SYS0014 그룹 미러링)
│  ├ 05_P5_cmbo.sql            CMBO 5종 (종속 콤보는 PARENT_CODE 동봉)
│  ├ 06_P6_verify.sql          검증 SELECT (기대값 주석)
│  ├ 99_route_path.sql         ROUTE_PATH ← ★ 반드시 마지막
│  └ gen_meta.py               메타 SQL 재생성기
├ fe/features/admin/src/pages/mail-setup/   화면 소스 17파일 (그대로 복사)
└ fe-common/
   ├ barrel.PATCH.md           공통 파일 3곳 수동 patch 안내 (통째 교체 금지)
   ├ procedures.d.ts.SYS0017_BLOCK.ts
   └ locales.SYS0017_PATCH.json  KO/EN/CN × 19키
```

## ⭐ 계정별 실행 구분 (2026-07-30 분리)

| 계정 | 파일 | 비고 |
|---|---|---|
| **SCM_MGR** (스키마 소유자) | `00_PRECHECK_CLOUD.sql` · `02_DB_DDL/*` · `sp/PKG_SYS0017_{SPEC,BODY}.sql` · `sp/03_GRANT_SYNONYM.sql` · `sp/05_DIAG_9994.sql` · `sql/*` 전부 | 본 패키지의 **거의 전부** |
| ⛔ **BE(WAS) 접속 계정** | **`sp/04_APP_SYNONYM_ONLY.sql`** — **이 1개 파일뿐** | SYNONYM 1건. **없으면 조회 시 PLS-00201 → -9994** |
| (DBA) | 없음 | 해당 계정 세션으로 돌리면 **DBA 불필요** |

⚠️ **계정 이름을 가정하지 말 것** (2026-07-30 실사고). 환경마다 애플리케이션 계정이 다르다 —
사내 실측 `PKG_%` SYNONYM 소유자 = **SCMP_APP 57개 / SCMD_APP 56개** 두 계정 공존.
엉뚱한 계정에 만들면 **SP 직접 호출은 성공하는데 화면만 PLS-00201** 이 계속 난다.
→ `04_APP_SYNONYM_ONLY.sql` **§[0]** 으로 먼저 확정한다 (정상 동작 화면 `PKG_DMF0044` 의 SYNONYM OWNER = BE 계정).
`03_GRANT_SYNONYM.sql` 은 **SCMP_APP / SCMD_APP 중 실제 생성된 계정에만 동적 GRANT** 하도록 보완됨(2026-07-30).

⛔ `04_APP_SYNONYM_ONLY.sql` 을 SCM_MGR 로 실행하지 말 것 — **ORA-01031**.
반대로 애플리케이션 계정 세션에서 다른 파일을 실행하지 말 것 — 객체 소유자가 어긋난다.

## 적용 순서

| 순서 | 계정 | 파일 | 내용 |
|---:|---|---|---|
| 1 | SCM_MGR | `00_PRECHECK_CLOUD.sql` | 결과로 아래 분기 판정 |
| | | | · [1][2][3] 누락 객체 → `02_DB_DDL/` 해당 스크립트 실행 |
| | | | · **[6] 채번 충돌 ≠ 0 → `sql/gen_meta.py` 재채번 후 `sql/` 재생성** (그대로 적용 금지) |
| | | | · [8] = 0 → `04_P4_user_gr.sql` 의 미러링 원본 메뉴를 클라우드 실측값으로 변경 |
| 2 | SCM_MGR | `sp/PKG_SYS0017_SPEC.sql` → `sp/PKG_SYS0017_BODY.sql` | 순서 고정 → VALID 확인 |
| 3 | SCM_MGR | `sp/03_GRANT_SYNONYM.sql` | GRANT EXECUTE (SYNONYM 문장 제외됨) |
| **4** | ⛔ **어휈 계정**<br>클라우드=**SCMP_APP**<br>사내=SCMD_APP | **`sp/04_APP_SYNONYM_ONLY.sql`** | **SYNONYM 생성 — 누락 시 조회 -9994** |
| 5 | SCM_MGR | `sql/01 → 02 → 03 → 04 → 05` → `sql/06_P6_verify.sql` | 메타 배선 + 카운트 검증 |
| 6 | — | FE: `fe/` → `nscm-fe/features/admin/src/pages/mail-setup/` 복사 + `fe-common/barrel.PATCH.md` **4개 항목** 반영 | ⚠️ §4 세대 판별 필수 |
| 7 | SCM_MGR | `sql/99_route_path.sql` (**반드시 마지막**) | 재로그인 후 System > Mail Setup 진입 확인 |

> 문제 발생 시: 진입 안 됨 → `sql/00_DIAG_page_not_found.sql` / 조회 -9994 → `sp/05_DIAG_9994.sql`.

## ⛔ 메뉴 클릭 시 "Page Not Found" 가 나는 경우 (2026-07-30 추가)

화면 해석은 **`ROUTE_PATH` 가 아니라 `MNU_URL` 의 마지막 세그먼트 = 페이지 폴더명** 으로 매칭된다.
(`ROUTE_PATH` 는 `'<도메인>/<폴더>'` **2단만** 유효한데, 사내·본 패키지 값은 자매 화면과 같은 3단
`admin/system/mail-setup` 이라 매칭에 쓰이지 않는다 — 실제로는 전부 `MNU_URL` leaf 로 붙고 있다.)

1. `sql/00_DIAG_page_not_found.sql` 실행 → [1] 의 `VERDICT` 확인
2. `NG` 면 `sql/98_mnu_url_align.sql` 실행 (MNU_URL → `mail-setup` 강제 정렬)
   - ⚠️ `01_P1_meta_wiring.sql` 의 MNU INSERT 는 `NOT EXISTS` 멱등이라 **기존 SYS0017 행이 있으면 건너뛴다**.
     `99_route_path.sql` 은 ROUTE_PATH 만 고치므로 **MNU_URL 은 정정되지 않는다** (이 패키지의 구멍이었다)
3. DB 가 `OK` 인데도 404 면 원인은 FE → `fe-common/barrel.PATCH.md §4` 의 **viewRegistry 세대 판별**
   - 신판(`import.meta.glob`) → 폴더만 넣으면 되지만 glob 은 빌드타임 → **재기동/재빌드 필수**
   - 구판(`VIEW_REGISTRY` 정적 맵, **MNU_ID 키**) → `SYS0017: view(() => import('@admin/mail-setup')...)` **1줄 등록 필수**
4. 조치 후에도 재현되면 sessionStorage `MDI-store` 삭제(깨진 탭이 영속됨)

## 사내 검증 실측 (2026-07-29, 06_P6_verify 기준)

MNU 1 / MSG 27 / LBL 27 / API 9 / BTN 14 / PROC_M 9 SP / SHEET_COLUMNS 32 / 권한 메뉴 2·버튼 28 / CMBO 5 / ROUTE 1 / PKG SPEC+BODY VALID.

## 완전성 체크리스트 (deploy-package-completeness)

| 항목 | 상태 |
|---|---|
| FE 전 sheetName ↔ SP 1:1 | 5시트(main/message/allReceiver/selReceiver/sqlText) ↔ API 9 ↔ PKG 멤버 9 정합 |
| POPUP modal ↔ BTN_MPG | MailContentDialog(값 전달 전용, SP 없음) / MailSqlDialog ↔ sqlText SEARCH·SAVE 등록됨 |
| 모든 SP body 동봉 | `sp/PKG_SYS0017_BODY.sql` 9 멤버 전량 + `_orig/` 원문 9본 |
| SP 참조 테이블·시퀀스 DDL 동봉 | `02_DB_DDL/` 7테이블 + SEQ + 이력SP 3 + 함수 3 (자급) |
| MSG/LBL/MNU 동봉 | `01_P1` 에 MNU 1 + MSG 9 + LBL 9 × 3언어 = 57행 INSERT |
| PROC_M 등록 | `02_P2` 9 SP positional (verify 에 ALL_ARGUMENTS FULL OUTER JOIN 대조 포함) |
| 권한 2테이블 | `04_P4` 메뉴 + 버튼(전 시트 CROSS JOIN) |
| barrel 통째 교체 금지 | `fe-common/barrel.PATCH.md` 로 대체 |
| GTT / NUMBER(30,10) | 해당 없음(GTT 미사용, 수량·금액 컬럼 없음) |

## 재사용 자원 (신규 등록 대상 아님 — 클라우드 존재 확인만)

- MSG: `MSG00060`(중복) / `MSG00429`(필수) / `MSG00672`(저장 완료) — 사내 3언어 등록 확인됨
- LBL: `LBL00007/00109/00112/00339/00378/00379/00383/00407/00615/00780/00782` — locales 기준 사용
  - 참고: `LBL00378/00379/00383` 은 사내 `SCM_ADM_MSG_M` 미등록이나 `locales/*.json` 에 존재해 표시 정상(기존 notice-setup 과 동일 상태). `LBL00109` 는 CN 로케일 미등록 → fallback 표시.
- LOOKUP: `SMS_MAIL_SEND_SYSTEM` / `MAIL_SEND_CYCLE` / `MAIL_SEND_CYCLE_DETAIL` / `LANGUAGE` (콤보 원천)

## ⛔ 조회 시 -9994 / PLS-00201 이 나는 경우 (2026-07-30 실사고)

**원인 = 어휈(BE 접속) 계정에 `PKG_SYS0017` SYNONYM 이 없었다.**
무엇보다 **계정 이름을 가정하면 안 된다** — 클라우드는 **SCMP_APP** 로 변경되었고(2026-07-30 확인),
사내는 SCMD_APP 이다. 사내 실상 `PKG_%` SYNONYM 소유자 = SCMP_APP 57 / SCMD_APP 56 — **두 계정 공존**.

진단 = `sp/05_DIAG_9994.sql` (SCM_MGR) / 조처 = `sp/03_GRANT_SYNONYM.sql`(SCM_MGR) + `sp/04_APP_SYNONYM_ONLY.sql`(어휈 계정).

- BE 는 스키마 없는 `PKG_SYS0017.P_...` 로 호출한다
  (`SCM_ADM_PROC_M.PROC_NM` 240건 **전부 스키마 미표기** = 이 시스템의 관례 → **PROC_M 에 `SCM_MGR.` 붙이는 우회 금지**)
- SYNONYM 이 없으면 `ORA-06550 / PLS-00201` → BE 래프가 **-9994 / `InvocationTargetException:null`** 로 감싸다
- ⚠️ **`PLS-00201` 은 이름 부재와 권한 부재 둘 다 같은 문구** → GRANT 와 SYNONYM 을 **모두** 확인
- ⭐ **통과 기준**: SP 직접 호출 성공 ≠ BE 성공.
  직접 호출은 되는데 화면만 PLS-00201 이면 **1순위 = 계정 불일치** (권한·객체 문제 아니다)
- 어휈 계정 실측법: 정상 동작 화면(`PKG_DMF0044` 등)의 SYNONYM **OWNER** = 어휈 계정
- 어휈 계정 세션에서 자기 스키마에 만들면 **DBA 불필요**(이미 수십 건 소유 → CREATE SYNONYM 보유).
  SCM_MGR 로 `<계정>.` 접두 생성은 **ORA-01031**
- SYNONYM 1건으로 **9개 API 전부** 해소 (모든 멤버가 같은 패키지, 정의자 권한 실행)
- 조치 후에도 재현 → JDBC/MyBatis statement 캐시 → **WAS 재기동** / 적용 DB 토폴로지 재확인
- 원인이 다를 때 실오류 확보: `SCM_COM_SYS_LOG.EXCT_MSG_CTN` (MNU_ID='SYS0017') / BE 콘솔 `Caused by:`

## 잔여 이슈

1. ~~**SYNONYM 미생성**~~ → **위 -9994 절 참조**. 사내에서 `CREATE OR REPLACE SYNONYM SCMD_APP.PKG_SYS0017 …` 이 ORA-01031(SCM_MGR 권한 부족)이었고, **사내도 아직 미생성**이다(로컬 BE 는 SCM_MGR 접속이라 우연히 동작). 사내·클라우드 **양쪽 모두** 생성 필요.
2. 구 standalone `SCM0006_*` 9본(사내 INVALID 2 포함) 존치 — 배선은 PKG 한정이라 무해하나 정리 대상.
3. lint 는 로컬 차단 정책(클라우드 전용) — 클라우드 반영 시 `pnpm lint` 결과 확인 필요. type-check 는 mail-setup 오류 0 확인됨.
4. 데이터 이관: 사내 `SCM_ADM_RECIPIENT_LIST` 는 MAIL 52행/SMS 34행 보유. 클라우드에 업무 데이터가 필요하면 **별도 데이터 이관 SQL 이 추가로 필요**(본 패키지는 구조·메타·화면만 포함).
