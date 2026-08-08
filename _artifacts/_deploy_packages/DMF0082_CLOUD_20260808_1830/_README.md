# DMF0082 클라우드 통합 이관 패키지 (2026-08-08)

> **무엇인가**: DMF0082 관련 **클라우드 미적용분 전체**를 하나의 순서로 묶은 통합 패키지.
> 2026-08-07 UICATEGORY(미적용) + 2026-08-08 UP_FX 정합 2건이 들어 있다.
> ⚠️ **QA·DEV 2곳 동시 적용 의무** (feedback_cloud_be_build_out_of_sync_diagnosis)
> ⚠️ **`00_PRECHECK.sql` [0] 을 먼저 실행**하라 — 무엇을 적용해야 하는지 스스로 판정한다.

## 0. 한눈에

| 블록 | 내용 | DB 변경 | 사내 적용 |
|---|---|---|---|
| **선행** | `DMF0082_20260804_1032` (GTT 58종·PKG 취합·AUTHUNION 등) | — | 완료 |
| **A** | UICATEGORY — 81 편집/82 조회 확장 (2026-08-07) | GTT·PKG·PROC_M·SHEET_COLUMNS·TITLESET·CMBO 2 | 완료 · **클라우드 미적용** |
| **B** | UP_FX 계통 정합 (2026-08-08) | CMBO 1 신규 + CMBO 3 수정 | 완료 · **클라우드 미적용** |
| **C** | 공용 라벨 LBL00764/765 등록 (2026-08-09) | MSG_M 6행 INSERT | 미적용 · **선택** |
| **FE** | `forecast-price` 폴더 + `procedures.d.ts` | — | 완료 |

**B 블록만 다른 화면에 영향**: `B_UPFX_20260808/02_CMBO_GET_ADMIN_GROUP_PARITY.sql` 이 수정하는 3 CMBO 의
소비 화면은 **DMF0003 (Mkt Fcst) 단독**이다(전수 grep). DMF0082 는 무영향.

## 1. 적용 순서

```
00_PRECHECK.sql                            ← [0] 판정부터 읽고, [2] 백업 CTAS 실행
A_UICATEGORY_20260807/  00 → 01 → 02 → 03 → 04 → 05 → 06 → 07   (PRECHECK [0] 이 '적용 필요' 일 때만)
B_UPFX_20260808/        01 → 02
C_I18N_20260809/        01                                  (선택 — §3 참조)
fe/                     폴더 통째 교체
90_VERIFY.sql                              ← QA·DEV 각각, [3] 은 PRECHECK [1-1] 과 동일해야 함
```

### A. UICATEGORY (2026-08-07) — `A_UICATEGORY_20260807/`

| # | 파일 | 내용 | 주의 |
|---|---|---|---|
| 00 | `00_GTT_ALTER.sql` | GT_DMF0082_MF_SP +4 / GTT_MF_SP +14 (멱등, ORA-01430 skip) | **최우선**. ORA-14450 시 저사용 시간대 재시도 |
| 01 | `01_PKG_DMF0082_SPEC.sql` | 사내 live 덤프 | SPEC → BODY 순서 |
| 02 | `02_PKG_DMF0082_BODY.sql` | 13,257행 — UICATEGORY 전 수정 + [SENTINEL3] 판가 검증 변형 정규화 | 컴파일 후 VALID 확인 |
| 03 | `03_PROC_M.sql` | GET 22 / CURRENT 22 / SAVE 18 | ⚠️ **PKG 직후 즉시** (구 PROC_M = PLS-00306 화면 파손 구간) |
| 04 | `04_META_SHEET_COLUMNS.sql` | 5키 토큰 UPDATE + 신규 17컬럼 **MERGE INTO** | ⛔ 시트 메타 **DELETE 절대 금지** (hook #98 §9) |
| 05 | `05_TITLESET_RESEED.sql` | FcstNPrice 개인화 전량 DELETE → 자동 재시드 | ⚠️ 개인화 소실 — 백업 CTAS 선행 |
| 06 | `06_CMBO_USER_AUTH_GROUP.sql` | CMBO `FcstPriceUserAuthGroup` | 멱등 |
| 07 | `07_WS_FCSTTYPE_AUTH.sql` | DM Planner (W/S) A/S·W/S 등록 지원 | 멱등. ⚠️공유 `FCST_TYPE_NOT_ETC` **무변경** |

### B. UP_FX 계통 정합 (2026-08-08) — `B_UPFX_20260808/`

| # | 파일 | 내용 |
|---|---|---|
| 01 | `01_CMBO_DEFAULTBUCKETDAY.sql` | CMBO `DefaultBucketDay` 신규(멱등 NOT EXISTS). AS-IS `sDefaultDay` 원천 — FE 하드코딩(40=MON/그 외=FRI) 제거의 짝 |
| 02 | `02_CMBO_GET_ADMIN_GROUP_PARITY.sql` | ⭐ AS-IS combo SP **프롤로그 권한 변형** 이식 — 3 CMBO 의 리터럴 `USER_GR_ID='ADMIN'` → `GET_ADMIN_GROUP` 룩업. **소비=DMF0003** |

**⚠️ B-02 는 조회 범위를 넓힌다.** 적용 전 `00_PRECHECK [1-3]` 로 대표 계정 행수를 기록해 두라.
사내 실측(적용 전 → 후): `SiteByEndCustomerAuth` hongjae.kim **0 → 1,282** · bpark416 **0 → 1,191** ·
wonqthanq **0 → 730** / `EndCustomerByDivisionDeptAuth` **0 → 4 / 531 / 344** / `TeambyDivisionAuth` **0 → 17**.
**DM Viewer 2계정은 불변** — 권한 확대가 아니라 AS-IS 파리티 복원임이 이걸로 확인된다.

**⛔ 선결 조건**: `00_PRECHECK [1-4]` 의 `GET_ADMIN_GROUP` 등재 목록이 **사내와 같아야** 결과가 같다.
사내 SEGMENT2='ALL' = `ADMIN` / `DM ADMIN` / `DM Planner` / `SCM PI Admin` / `SCP Planner` / `minyonglee1`.
다르면 B-02 적용을 보류하고 룩업 정합부터 맞출 것.

### FE — `fe/`

| 경로 | 반영 위치 | 비고 |
|---|---|---|
| `fe/forecast-price/` (27파일) | `nscm-fe/features/demand/src/pages/forecast-price/` | ⚠️ **폴더 통째 교체**(파일 단위 덮어쓰기 금지 — 클라우드 셸 세대 혼재 함정) |
| `fe/configs-types/procedures.d.ts` | `nscm-fe/configs/types/procedures.d.ts` | ⚠️ **공유 파일** — 아래 주의 |

> ⚠️ **`procedures.d.ts` 는 DMF0082 외 화면(mail-setup·business-plan 등)의 미이관 타입 변경도 포함**한다
> (총 235행 추가분 중 DMF0082 분은 `projectCode`/`owner`/`senderCode` 등 일부).
> 타입 선언은 컴파일 전용이라 해당 SP 가 없어도 런타임 영향은 없지만, **의도치 않은 동반 이관**임을 인지하고
> 적용할 것. 화면별로 분리하려면 DMF0082 관련 필드만 발췌 반영해도 된다.

- 전제: `features/master` searchFields 카탈로그(ProjectField/OwnerField/PlantSiteField)·COM0005/COM0006 공용 모달 =
  클라우드 기존재(DMF0003 이관분). 미존재 시 DMF0003 FE 이관분 선행.
- 검증: `tsc --noEmit` 0 / `eslint` 0 (features/demand, 2026-08-08 사내).

## 2. 이번 이관에서 고친 것 (B 블록 배경)

사용자 지적 — "AS-IS 는 BigFilter 와 `UP_FX_GetCommonDataList` 를 같이 쓰는데 TO-BE 는 UP_FX 를 놓친 것 같다" —
가 **정확했다.** DMF0082 에서 결함 9건 + 추가 2건이 나왔고, 원인은 구조적이다:

**UP_FX 키 1개 = TO-BE 산출물 3개**(①CMBO 등록 ②소비지점 배선 ③FE 파라미터·트리거). 종전 점검이 ①만 세고
"누락 0"을 선언했다. 은폐 3종 — 미전달 토큰의 조용한 폴백(0행 또는 무필터) / 빈 `.catch` 의 ORA 오류 삼킴 /
게이트에 셀 콤보 0건 — 때문에 화면상으로는 정상처럼 보였다.

주요 수정(FE): `comboParams` 미전달로 measure 14종이 **코드 raw 표시**되던 것 / 캐스케이드 2종이 quoting 누락
+ 빈 catch 로 **한 번도 동작한 적 없던** 것 / 편집·조회 콤보 이원화(div40 한정) / AS 사이트 Incoterms /
CURRENCY 차단 / 배분 기본요일 마스터 조회 + 주배분 분기 버그·LOC 월 기준일 정정 /
**행 생성(InsertRow) 시점 캐스케이드 프라이밍**(사이트 특성 VMI_YN measure 필터가 시드복사 정상흐름에서
상시 미적용이던 것) / Sales Site·Cell Prod Site 행 캐스케이드.

⭐ **메타(`CELL_COMBO_DATA_TYPE`)는 바꾸지 않았다.** 편집판으로 교체하면 원장의 폐지 코드가 raw 로 표시된다 —
덕분에 공유 콤보 소비 화면(Incoterms 36시트/DOM_EXP 12/DeptId 10) **회귀 0**, DB 변경이 CMBO 4건으로 축소됐다.

## 3. MSG / LBL / MNU / BTN 4분류 감사

| 분류 | 신규·변경 | 근거 |
|---|---|---|
| MSG_M | **0** | A 블록 V82-00 = SP 인라인 리터럴(기존 관례) / B 블록 신규 메시지 없음 |
| LBL_M | **2** (`LBL00764` Invisible / `LBL00765` Visible) | ⭐ 2026-08-09 감사에서 **발견**. `ForecastPrice.tsx:530-531` 이 참조하는데 **DB·locales 양쪽 부재**. → `C_I18N_20260809/01` |
| locales json | **0** | 이관 제외(2026-07-24 사용자 확정). ⚠️ 본 프로젝트는 KO 라벨도 영문이라 `t()` 폴백과 등록 후 표시가 **동일** — 표시 결함 아님 |
| MNU_M | **0** | 메뉴·라우팅 무변경 |
| BTN_MPG / API_M | **0** | 버튼·API 배선 무변경 (콤보는 기존 `/admin/combo` 경로, 파라미터만 확장) |

> **LBL 2건 판정 근거**: `LBL00760~763` / `LBL00766~770` 은 등재돼 있고 **764·765 만 공백**(연속 블록의 구멍) —
> FE 가 이미 그 번호를 쓰므로 신규 채번이 아니라 **누락된 등록을 채우는 것**이다. 동일 의미 재사용 후보 0행 실측.
> **DMF0082 전용이 아니다** — mkt-fcst·sales-plan·business-plan·sales-reports·etc-sales-reports·
> production-plan-line 등 **8개 이상 화면 공유**. INSERT-only 라 회귀 위험 0이나, 표시가 바뀌지 않으므로
> **적용 여부는 선택**이다(미적용해도 DMF0082 동작·표시 영향 없음).

## 4. 원복

```sql
-- B-2 (권한 변형)
UPDATE SCM_MGR.SCM_ADM_CMBO_SQL_M A
   SET SQL_DTL_CTN = (SELECT B.SQL_DTL_CTN FROM SCM_MGR.CMBO_BAK_CLOUD_20260808 B WHERE B.SQL_ID = A.SQL_ID)
 WHERE A.SQL_ID IN (SELECT SQL_ID FROM SCM_MGR.CMBO_BAK_CLOUD_20260808);
-- B-1
DELETE FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = 'DefaultBucketDay';
COMMIT;
```
A 블록 원복은 적용 전 백업(`SHEETCOL_BAK_*`/`TITLESET_BAK_*` + PKG `USER_SOURCE` 덤프)에서 되돌린다.
FE 는 교체 전 폴더 백업에서 되돌린다.

> B-1 만 지우고 FE 를 되돌리지 않으면 `DefaultBucketDay` 조회가 0행 → FE 는 **MON 폴백**
> (AS-IS switch 의 `default:` 와 동일)이라 치명적이진 않으나 81/82 는 FRI 가 정답이므로 동시 원복 권장.

## 5. 검증 (사내 실측 — 클라우드도 동일 기대)

> 리포트 원본은 이 패키지에 넣지 않는다(이관대상 아님). 저장소 경로: `_artifacts/_gate_reports/`,
> `_artifacts/_apply_corporate/`. 진단 도구는 `_artifacts/_diagnostics/` (git 관리).

| 축 | 결과 | 리포트 |
|---|---|---|
| 게이트 러너 **9섹션** | **8 PASS + WARN 1** (섹션 7 WARN 2 = 관대형·대사표 사유 기재) | `_gate_reports/DMF0082_20260808_2325.md` |
| HTTP E2E **15계정** | **종합 PASS (FAIL 0 / WARN 0)** — 40/81/82 × Admin·Planner·W/S·Viewer·SCP | `_gate_reports/DMF0082_http_e2e_20260808_2342.md` |
| CRUD 왕복 (SP 직접) | div81 **M·I·D·RT 전부 PASS** / div82 저장거부+원장불변 / div40 재시험키 **전부 PASS** · 테스트 잔존 0 | `_apply_corporate/CRUD_ROUNDTRIP_DMF0082_20260809.txt` |
| 단위테스트 | **24/24 PASS** (배분 산식 AS-IS 1:1 — jsdom 복구 후 실측) | — |
| `tsc --noEmit` / `eslint` | 0 / 0 (features/demand) | — |
| 런타임 증명 | `Measure` 36행 vs 파라미터 무전달 22행 · `DefaultBucketDay` 40/W→MON·무전달→`[]` | — |

⚠️ **클라우드 적용 후 90_VERIFY 를 QA·DEV 각각 실행**해 사내와 같은 수치가 나오는지 대조할 것.

## 6. ⚠️ 이 패키지에 **포함하지 않은 것**

- **진단 도구·게이트 리포트** — 이관대상이 아니라 저장소 자산(git)이다. `_artifacts/_diagnostics/`(도구) ·
  `_artifacts/_gate_reports/`(리포트) 참조. 2026-08-09 본 패키지에서 제외했다.
- **타 화면 FE 미이관분** — `mail-setup`(11파일)·`business-plan`(11)·`mkt-fcst`·`nn-master-mapping` 등
  이전 세션 작업분. DMF0082 이관과 무관하므로 **각자의 패키지로 분리**해야 한다
  (단, `procedures.d.ts` 는 공유 파일이라 불가피하게 동반됨 — §1 FE 주의 참조).
- **전 화면 UP_FX 결함 수정** — 스윕에서 나온 DMF0021·0022·0035·0048 `Measure @mnuId` 미전달,
  DMF0042·0044 `DM_LOOKUP_DIV`, DMF0048·0049 quoting 누락 3건. **진단만 했고 미수정**
  (사용자 확정 = 각 화면 작업 시점 T01M 적용). 리포트 = `_artifacts/_gate_reports/UPFX_COMBO_PARITY_SWEEP_*.md`.
