# DMF0074 (Metal Link Price) 클라우드 이관 패키지 — 2026-08-18 취합 (**rev.2**)

> **상태: 취합 완료 / 클라우드 미적용.** 적용은 별도 지시 후 수행.

## rev 이력

| rev | 시각 | 내용 |
|---|---|---|
| rev.1 | 2026-08-18 초기 | 최초 취합 — NULLFIX(2026-08-16) 반영본 기준 |
| rev.2 | 2026-08-18 재취합 | **4축 점검(대사표→기능검증→테스트→권한별) 결과 반영** — 아래 3건 추가 |
| **rev.3** | 2026-08-18 보완 | ① `A_DB/05_FIX_HISTORY_SEQ_RESEED.sql` **이관 결함 정정 추가**(다건 업로드 ORA-00001 차단 해소) ② `90_VERIFY.sql` 축 ⑥⑦ 추가 + NULLFIX 기대값 오기 정정(10→**9**, 본문 실측) ③ `D_SAMPLE/` **업로드 스모크용 샘플 3건** 동봉 ④ 운영 주의 2건(§7) 명문화 |

> rev.3 드리프트 점검 실측(2026-08-18): B_FE 13파일 **해시 전건 일치** · locales 3본 일치 ·
> `02_PKG_DMF0074_BODY.sql` ↔ 사내 `ALL_SOURCE` **본문 동일(3,975행)** · 메타 8축 행수 전건 일치.

**rev.2 에 새로 담긴 것**

1. **A_DB/02_PKG_DMF0074_BODY.sql** — `[E20260818-GTTDEL]` 반영본으로 교체.
   `EXECUTE IMMEDIATE 'TRUNCATE TABLE …'` **17개소 전량 → `DELETE FROM`** (GTT DDL 경합 제거,
   DMF0014 Excel Upload Lock 동형 사고 예방). 사내 적용·회귀 실측 완료:
   업로드 26케이스 PASS 23/FAIL 3(전환 전과 동일·원장 Δ0·5.2s) / E2E 조회 5·3,771·368행 동일(13.2s).
   패키지 본문 실측 = NULLFIX 마커 10 · GTTDEL 마커 17 · **TRUNCATE 잔존 0**.
2. **B_FE/metal-link-price/components/MetalLinkPriceGrid.tsx** — 공통 **UC-07(재조회 시 필터 유지)**
   보완. `rebindFilterColumns` 적용(정본 DMF0042 `BusinessPlanGrid.tsx:715` 동형). 이 화면은 조회마다
   DataGrid 를 재마운트하고 메탈 42열을 재생성해 FlexGridFilter 가 죽은 Column 을 붙들었다.
   type-check 0.
3. **B_FE/metal-link-price/__asis-mapping__.md** — 구양식(85줄) → **정본 대사표 167행**으로 교체.
   `asis_mapping_gate.py --check` **167/167 PASS**. 축 = E/CRUD/MODAL(23) + HANDLER(18) +
   COMMON UC-01~07 + IT 21/BT 8/CT 9/PU 5/VA 10+XP/ED 7/GP 9 + **EV 49**(Excel Upload SP Validation).

**A_DB/90_VERIFY.sql** 에 정정 반영 확인 축 2개(④ NULLFIX / ⑤ GTTDEL)가 포함돼, 클라우드 적용 후
사내와 동일 상태인지 SQL 로 대조할 수 있다.
> **DMF0074 는 `_deploy_packages` 에 기존 패키지가 없다 = 최초 이관**이므로 델타가 아니라
> **화면 전량**(DB 객체 + 메타 8축 + FE 폴더 전체)을 담았다.

## 1. 왜 이 범위인가 — 축은 기계 스윕으로 도출

`_artifacts/_diagnostics/_dmf0074_deploy_axis_sweep.py` (hook `deploy-axis-sweep-mandatory`)
- `SCM_ADM_%` / `SCM_MST_%` / `DM_ADM_%` **156 테이블 전수** 스캔 → 문자열 컬럼에 `DMF0074` 보유 13 테이블 도출
- 쿼리 실패 = **즉시 중단**(SKIP 금지). 실제로 `"2LEVEL_DEPT_ID"` 같은 숫자 시작 식별자에서
  실패해 중단됐고, 컬럼명 인용으로 정정한 뒤 전수 완주했다.

### ⭐ 손나열로는 빠지는 축이 실재했다
`MNU_ID = 'DMF0074'` 로 짰다면 아래가 **조용히 누락**된다 → div 40 Excel Upload 전멸.

| 테이블 | `= 'DMF0074'` | 실제(`LIKE '%DMF0074%'`) | 누락분 |
|---|---:|---:|---|
| `SCM_ADM_MNU_BTN_MPG_M` | 8 | **9** | `MNU_ID='DMF0074_40'` UPLOAD 배선 1행 |
| `SCM_ADM_USER_GR_MNU_BTN_MPG_M` | 22 | **24** | `MNU_ID='DMF0074_40'` 권한 2행 |

(FE 는 division 40 에서 `/DMF0074_40/{sheet}/UPLOAD/excel-upload` 로 POST 한다.)

## 2. 담긴 것

### A_DB (5 파일) — 적용 순서 = 파일명 순
| 파일 | 내용 | 규모 |
|---|---|---|
| `00_GTT_DDL.sql` | GTT **17개** 자급 DDL. 기존재 시 `SKIP(exists)` 출력 — 멱등 (hook `deploy-package-gtt-type-ddl`: 클라우드 기존재 가정 금지) | 17 객체 |
| `01_PKG_DMF0074_SPEC.sql` | `ALL_SOURCE` 원문 | 51행 |
| `02_PKG_DMF0074_BODY.sql` | `ALL_SOURCE` 원문 — **`[E20260816-NULLFIX]` 5결함 정정 + `[E20260818-GTTDEL]` GTT 17개소 DELETE 전환** 반영본 | 3,975행 |
| `05_FIX_HISTORY_SEQ_RESEED.sql` | ⭐ **이관 결함 정정** — `DM_BPS_METAL_LINK_PRICE_H.HISTORY_SEQ` identity 시퀀스 재시드. 미적용 시 Excel Upload 의 [OK](P_MODE=1)가 **다건 업로드에서 ORA-00001 로 항상 실패**. ①진단 쿼리로 클라우드 상태 확인 후 적용 | — |
| `10_META_DMF0074_ALL_AXES.sql` | 메타 **8축 / 129행** (아래 표) | 129행 |
| `90_VERIFY.sql` | 적용 후 검증 — 객체 VALID / 축별 기대 행수 / `DMF0074_40` 전용 축 / 정정 마커 9개 | — |

**메타 8축 (사내 실측 행수 = 이관 기대값)**

| 테이블 | 행 | 적재 방식 | 키 근거 |
|---|---:|---|---|
| `SCM_ADM_MNU_M` | 1 | MERGE | PK `MNU_ID` |
| `SCM_ADM_API_M` | 8 | MERGE | PK `API_ID` |
| `SCM_ADM_PROC_M` | 24 | MERGE | PK `PROC_NM,COL_NM,COL_TP_CD` |
| `SCM_ADM_MNU_BTN_MPG_M` | 9 | MERGE | PK `MNU_ID,SHT_NM,MNU_BTN_CD` |
| `SCM_ADM_USER_GR_MNU_MPG_M` | 3 | MERGE | PK `USER_GR_ID,MNU_ID` |
| `SCM_ADM_USER_GR_MNU_BTN_MPG_M` | 24 | MERGE | PK `USER_GR_ID,MNU_ID,SHT_NM,MNU_BTN_CD` |
| `SCM_ADM_EXCEL_COLUMNS` | 2 | **범위삭제+재적재** | PK 없음 → 논리키 `(PROGRAM_ID,SHEET_NAME)` |
| `SCM_MST_SHEET_COLUMNS` | 58 | **범위삭제+재적재** | PK 없음 (hook #98 §9) |

- PK 는 `ALL_CONSTRAINTS` **실측**(추정 금지 — hook `merge-on-key-must-match-pk`).
- 범위삭제 2축의 삭제 범위 = `PROGRAM_ID LIKE 'DMF0074%'` = **삽입 범위와 동일**(소실 0).
  시트 `'Metal Link Price'` 는 실측 결과 `DMF0074` **전용**(다른 PROGRAM_ID 공유 없음)이라 안전.
- 감사컬럼: `SCM_MST_SHEET_COLUMNS.LAST_UPDATED_BY = 'claude_dmf0074_fe'` 58행을 발견해
  이관 SQL 에서 **`'admin'` 으로 정규화**했다(hook: 메타 감사컬럼 `admin` 만). 생성물 내 `claude` 0건.

### B_FE (16 파일)
- `metal-link-price/` **폴더 전체 13파일** — `index.ts` 포함.
  ⚠ hook `deploy-fe-partial-folder-notfound`: `pages/<화면>/index.ts` 가 viewRegistry glob 의
  **유일한 등록 키**다. "변경분만" 담으면 탭 안에서 *Page Not Found* 가 난다.
- `locales/KO.json · EN.json · CN.json` — 이 화면이 쓰는 LBL 14종 + `MSG00656` 의 런타임 원천.

### C_BE — 없음
`nscm-be/src` 전수 grep `DMF0074` = **0건**. 이 화면은 generic call-proc + 공용 `FileController`
`excel-upload` 체인만 쓴다. BE 이관분 없음.

## 3. 이관 제외 — 판단 근거

| 대상 | 제외 사유 |
|---|---|
| `SCM_ADM_EXCEL_UPLOAD` (548행) | **업로드 스테이징 데이터**. 운영 이력이며 테스트분 포함. 이관 대상 아님 |
| `SCM_ADM_USER_MNU_SRCH_COND_M` (4행) | 사용자 **개인 조회조건** 저장. 이관 시 타 환경 사용자 설정 덮어씀 (`TITLESET_USER` 와 동일 성격) |
| `SCM_ADM_PROGRAM` (1행) | AS-IS WinForms DLL 카탈로그 (`GSCM.DM.Plan.UIL.DMF0074_MetalLinkPrice`) — TO-BE 무관 |
| `SCM_MST_SHEET_COLUMNS_0408` / `_260408` (각 58행) | 백업 사본 테이블 |
| standalone 프로시저 5종 | `DMF0074_EXCEL_UPLOAD`, `..._KJJ_TEST`, `..._TEST2`, `DMF0074_GET_METAL_LINK_TEMPLATE`, `P_DMF0074_GET_METAL_LINK_PRICE` — 변환 잔존물이며 **4종은 사내에서도 INVALID**. 정본은 `PKG_DMF0074` (hook: UI별 PKG 원칙) |
| `MSG00049` / `MSG00427` | FE **주석 내 언급만** — 실사용 0(전자는 TO-BE 월 피커로 도달 불가·격차 명기, 후자는 `MSG00656` 로 대체 채번). 사내 미등록이 정상 |

## 4. 확인 필요 (적용 전 클라우드 실태 점검)

1. **`DMF0073_GET_VERSION_SALESPRICE`** — `API_M`(`DMF0074_version_SEARCH`)이 참조하는 **DMF0073 소속 SP**.
   이 패키지에 본문은 담지 않았다. 클라우드에 없으면 Version 모달이 실패한다 → 존재 확인 필수.
2. **PKG 의존 객체** — `FN_NEXT_DAY`, `PR_SCM_SYS_LOG_BATCH`, 뷰 `DM_MST_ITEM_SINGLE_V`,
   `SCM_ADM_USER_MNU_EDIT_AUTH_V`. 공용이라 미동봉 — 부재 시 컴파일 INVALID.
3. **공용 FE 컴포넌트** `features/demand/src/components/fcst-upload-modal/FcstUploadModal.tsx` —
   DMF0014/0082 와 공유. 클라우드 세대가 `onSave`(2-Step opt-in) 를 지원하는지 확인.
   미지원 세대면 DMF0074 가 조용히 1-Step 으로 동작한다 (hook #135 위반).
4. `MSG00656`(2026-07-10 신규 채번) 클라우드 `SCM_ADM_MSG_M` 등록 여부.
5. **권한 그룹 정책** — AS-IS 실측(`LGCE_SCMDEV.TB_FX_GroupMenuAuth`, 2026-08-18)상 DMF0074 는
   **`System Administrator` 1그룹 전용**(사용자 직접 부여 0행)이었다. 사내 TO-BE 는
   `ADMIN`/`DM ADMIN`/`DM Viewer` 3그룹으로, **AS-IS 보다 넓다**(2026-02-09 SYSADMIN 일괄 이관
   배치 65메뉴/163행의 기본값). `DM Planner` 미부여는 **AS-IS 파리티로 정상**이며 누락이 아니다.
   본 패키지는 사내 현행 3그룹을 그대로 옮긴다 — 정책상 축소가 필요하면 적용 전 결정할 것.

## 5. 적용 순서

```
A_DB/00_GTT_DDL.sql            → GTT 17 (멱등)
A_DB/01_PKG_DMF0074_SPEC.sql
A_DB/02_PKG_DMF0074_BODY.sql   → PACKAGE/BODY VALID 확인
A_DB/05_FIX_HISTORY_SEQ_RESEED.sql → ①진단으로 결함 확인 후 ②재시드 (업로드 [OK] 차단 해소)
A_DB/10_META_DMF0074_ALL_AXES.sql (COMMIT 포함)
A_DB/90_VERIFY.sql             → 기대값 대조
B_FE                           → 폴더 통째 배치 + locales 3본
```

원복: `_artifacts/_apply_corporate/BACKUP_PKG_DMF0074_BODY_pre_nullfix_20260816.sql` (SP 정정 전 본문).

## 6. 적용 후 스모크 테스트 (D_SAMPLE) + ⚠ 운영 주의 2건

`D_SAMPLE/DMF0074_ExcelUpload_Sample_div40_3rows.xlsx` = division 40 업로드 샘플 3건.
사내 실측(2026-08-18): 검증 Total 3 / **Success 3 / Error 0** → 적재 `CODE=0 EVENT=3`
(원장 3행 + 이력 3행) → 검증 후 삭제해 원복. 2번째 시트에 입력 규칙 README 포함.

절차: 화면 division=40 → [Upload] 로 파일 업로드 → 검증 결과 확인 → [OK] → **Version='Current'** 로 조회.

> ⚠ **주의 ①  조회 Version** — 조회 SP 는 Version 값으로 원천이 갈린다.
> `Current` → `DM_BPS_METAL_LINK_PRICE`(현재 마스터) / **그 외 특정 SP 버전 → `DM_BPS_METAL_LINK_PRICE_C`**(버전 스냅샷).
> Excel Upload 는 **현재 마스터에만** 적재하므로, 버전을 지정해 조회하면 방금 올린 데이터가
> **원리상 보이지 않는다**(2026-08-18 실사용 문의 재현: 같은 기간에서 버전 지정 0행 / `Current` 7행).
> AS-IS 동일 구조라 파리티지만, 업로드 직후 Version 이 `Current` 가 아니면 안내하는 보완은 검토 대상.
>
> ⚠ **주의 ②  Period 열 입력 형식** — `Period(Fr)/(To)` 를 엑셀 **숫자**로 입력하면 서버 파서가
> `6.0` 으로 변환하고 검증이 소수점을 오류로 보아 `Invalid INTEGER 0 ~ 12.` 로 탈락한다(실측 재현).
> 샘플은 텍스트로 넣어 두었다. 근본 정정(BE `ExcelUtils` 정수 변환 또는 SP `INSTR('.')` 완화)은 미결.

## 7. 근거 산출물

| 경로 | 내용 |
|---|---|
| `_survey/axis_sweep_result.json` | 축 스윕 원시 결과 (A/B/C 3계열) |
| `_survey/collect_report.json` | 취합 실적 (축별 행수 · GTT 목록 · FE 파일 목록) |
| `_artifacts/_diagnostics/_dmf0074_deploy_axis_sweep.py` | 축 도출 도구 |
| `_artifacts/_diagnostics/_dmf0074_collect_package.py` | 취합 생성기 (재실행 멱등) |
| `Doc/화면분석서/DMF0074_MetalLinkPrice_ExcelUpload_Validation_v1.1.xlsx` | Validation 49판정 / TC 26 / 결함 7 / 정정패치 / 적재왕복 |
| `_artifacts/_gate_reports/DMF0074_http_e2e_20260818_0312.md` | E2E 15계정 실행 리포트(종합 WARN — 잔여는 셀콤보 미사용 정상 경고) |
| `B_FE/metal-link-price/__asis-mapping__.md` | 대사표 167행 (게이트 167/167 PASS) |
| `_artifacts/_apply_corporate/BACKUP_PKG_DMF0074_BODY_pre_gttdel_20260818.sql` | GTT 전환 전 원복본 |
