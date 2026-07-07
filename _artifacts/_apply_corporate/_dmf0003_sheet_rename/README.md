# DMF0003 (mkt-fcst) Grid SHEET_NAME 마이그레이션 handoff — 'main' → 'Mkt Fcst'

> ⚠️ **사내 DB 쓰기 금지 — 본 폴더는 handoff 전용. 사용자가 직접 적용한다.**
> 사내 READ 만 수행하여 작성됨. 모든 값은 실측 기반(추측 0).

## 목표
DMF0003 그리드의 SHEET_NAME 식별자를 **전 계층** `'main'` → `'Mkt Fcst'` 로 통일.
(사용자 확정: measure 충돌 시 기존 `'Mkt Fcst'`(47) 채택 + `'main'`(12) 삭제 / 라우팅까지 전부 `'Mkt Fcst'`)

## 선행조사 결과 (anti-simplification — 누락 방지)

### 조사1: 다른 SHEET_NAME 보유 테이블의 DMF0003 'main' 잔존
SHEET_NAME / SHT_NM 컬럼 보유 live 테이블 전수 점검 결과, **당초 4개 외 2개 추가** 발견:

| 테이블 | 키 | DMF0003 'main' | 처리 |
|---|---|---:|---|
| SCM_MST_SHEET_COLUMNS | PROGRAM_ID+SHEET_NAME | **67** | 42 (rename) |
| SCM_MST_SHEET_MEASURE | PROGRAM_ID+SHEET_NAME | **12** | 43 (drop, 'Mkt Fcst' 47 채택) |
| SCM_ADM_MNU_BTN_MPG_M | MNU_ID+SHT_NM | **10** | 45 (rename, titleSet 1 불변) |
| **SCM_ADM_USER_GR_MNU_BTN_MPG_M** | USER_GR_ID+MNU_ID+SHT_NM | **30** | **46-A (rename, 추가 발견)** |
| **SCM_MST_TITLESET_USER** | USER_ID+PROGRAM_ID+SHEET_NAME+TYPE+COLUMN | **84** | **46-B (collision-safe rename, 추가 발견)** |
| SCM_ADM_EXCEL_COLUMNS | — | 0 ('Car Fcst' 1행만, 무관) | 없음 |
| SCM_ADM_EXCEL_UPLOAD | — | 0 | 없음 |

- `SCM_MST_TITLESET_USER` 는 3 변형 보유: `main`(84/3유저), `Mkt Fcst`(48/4유저), `mktFcst`(1203/54유저, camelCase).
  - `mktFcst`(camelCase 1203행)는 **어떤 DMF0003 SP 도 읽지 않음**(조사2) → 마이그레이션 대상 아님. 레거시로 보존.
  - `Mkt Fcst`(48) 와 `main`(84) 는 **admin, minyonglee1 2유저가 양쪽 보유 → PK 충돌** → 46-B 가 twin DELETE 후 UPDATE.

### 조사2: 다른 SP 본문의 DMF0003 'main' 시트 리터럴
- `USER_SOURCE WHERE NAME LIKE 'DMF0003%' AND TEXT LIKE '%''main''%'` → **DMF0003_GET_MKT_FCST_DATA 9곳뿐** (추가 SP 없음).
- `DMF0003_GET_SPREAD_TITLE` 는 이미 `v_sheet_name := 'Mkt Fcst'` 사용 (line 16) + 미저장 유저 default INSERT(line 41) 도 'Mkt Fcst'. → 42 의 SHEET_COLUMNS rename 으로 비로소 정합(현재 'Mkt Fcst' 컬럼 0행이라 깨져있음).
- 'mktFcst' 매칭 SP = DMF0040 / PKG_DMF0035 의 **'mktFcstWaterfall'** — 다른 화면, 무관.

### 조사3: API_M / PK 구성
- BTN_MPG `API_ID`(예 `DMF0003_main_SEARCH`)는 opaque 식별자 → **SHT_NM 만 변경, API_ID 유지**(불필요 cascade 회피, API_M 무변경).
- `SHT_NM` 은 BTN_MPG PK 2번째 / USER_GR PK 3번째 → UPDATE 가능. 양 테이블 'Mkt Fcst' 0행 = 충돌 없음.

## 적용 순서 (의존순서)

```
42 (SHEET_COLUMNS rename 67)   ┐
43 (SHEET_MEASURE drop main 12)├─ 메타 정합 (이 셋이 'Mkt Fcst' 로 모여야 SP 가 데이터 반환)
46 (TITLESET_USER 84 + USER_GR 30)┘
44 (SP rewrite 9 lit)          ─ 위 메타가 'Mkt Fcst' 가 된 뒤 SP 가 'Mkt Fcst' 로 읽어야 정합
45 (BTN_MPG routing 10)        ─ 라우팅(독립적이나 함께 적용)
```

**권고: 42 → 43 → 46 → 44 → 45 순서로 한 트랜잭션 묶음처럼 연속 적용.**
- 이유: 44(SP)가 `TITLESET_USER`(46-B) ⨝ `SHEET_MEASURE`(43) on SHEET_NAME='Mkt Fcst' 를 수행.
  44 를 먼저 적용하면 메타가 아직 'main' 이라 grid 데이터 0 위험. 메타(42/43/46) 선행 필수.
- 42·43·45·46 은 상호 독립(테이블 분리)이라 내부 순서 무관. 단 **44 는 반드시 마지막 직전**(메타 이후).

## 각 스크립트
| 파일 | 대상 | 영향행수 | 백업 테이블 |
|---|---|---:|---|
| `42_dmf0003_sheet_columns_rename_mktfcst.sql` | SHEET_COLUMNS UPDATE | 67 | SCM_MST_SHC_BAK_DMF0003_RENAME |
| `43_dmf0003_sheet_measure_drop_main.sql` | SHEET_MEASURE DELETE | 12 | SCM_MST_SHM_BAK_DMF0003_DROPMAIN |
| `44_dmf0003_get_data_sp_sheetname.sql` | SP CREATE OR REPLACE | 9 리터럴 | (별도 .ORIG.bak.sql) |
| `44_..._get_data_sp_sheetname.ORIG.bak.sql` | **원본 무손상 DDL** (원복용) | 4344행 | — |
| `45_dmf0003_btn_mpg_routing_mktfcst.sql` | BTN_MPG UPDATE | 10 (titleSet 불변) | SCM_ADM_BTNMPG_BAK_DMF0003_RENAME |
| `46_dmf0003_usergr_and_titleset_mktfcst.sql` | USER_GR UPDATE 30 + TITLESET twin-del+update 84 | 30 + 84 | SCM_ADM_UGBTN_BAK_DMF0003_RENAME / SCM_MST_TSU_BAK_DMF0003_RENAME |

모든 스크립트: `WHENEVER SQLERROR EXIT FAILURE ROLLBACK` / 멱등(재실행 안전) / CTAS 백업 선행 / BEFORE·AFTER 근거 SELECT / 원복 블록 포함.

## SP 44 원본보존 검증법 (sp-body-no-rewrite 룰)
1. 원본 = `SELECT TEXT FROM USER_SOURCE WHERE NAME='DMF0003_GET_MKT_FCST_DATA' ORDER BY LINE` (4344행) verbatim 추출.
2. Python `raw.replace("'main'","'Mkt Fcst'")` — 정확히 9건 치환(assert), 그 외 1바이트 무변경.
3. 검증: `splitlines` 비교 시 **변경 라인 = [177,881,903,926,938,949,957,967,978] 9개뿐**, 라인수 불변(4344), 바이트델타 = +36 (=9×4).
4. 적용 후: 스크립트 말미 USER_SOURCE 재조회로 `'main'` 잔존 0 / `'Mkt Fcst'` 9 + USER_ERRORS 0 + STATUS=VALID 확인.

## 미해결/위험
- 본 handoff 는 **DB 계층만**. FE(SHEET_NAME 송신값 'main'→'Mkt Fcst')는 사용자가 별도 처리(범위 외).
  FE 가 여전히 'main' 을 보내면 BTN_MPG/SHEET_COLUMNS 라우팅 미스 → FE 동반 변경 필수.
- `mktFcst`(camelCase 1203행) 유저들은 본 main-path 와 무관했으므로 영향 없음. 단 추후 통합 시 별도 검토 권장.
