# DMF0082 UP_FX 콤보 정합 이관 패키지 (2026-08-08)

> **왜 이 작업을 했나**: 사용자 지적 — "AS-IS 는 BigFilter 와 `UP_FX_GetCommonDataList` 를 같이 쓰는데
> TO-BE 는 UP_FX 쪽을 놓친 것 같다." 실측 결과 **정확한 지적**이었고, DMF0082 에서 결함 9건이 확인됐다.
> ⚠️ **클라우드 DB 적용물은 QA·DEV 2곳 동시 적용 의무** (feedback_cloud_be_build_out_of_sync_diagnosis)

## 0. 무엇이 문제였나 (구조)

AS-IS 는 콤보 데이터를 **3계통**으로 얻는다:

| 계통 | 형태 | 용도 |
|---|---|---|
| `BigFilter.xml` | 선언형 XML, 화면 로드 1회 배치(`@GROUP_ID`/`@USER_ID` 2개 고정) | 조회조건 |
| `UP_FX_GetCommonDataList_DM` | `FoxDataRequest` 직접 호출, `@CODE`+PARAM1~5, **이벤트마다** | 그리드 셀 콤보 |
| `UP_FX_GetCommonDataList`(기본판) | `Data.Common(Data.Type.X,…)` 로 **은닉** 호출 | 그리드 셀 콤보 |

`UP_FX_` 문자열 grep 은 6건만 잡지만 DMF0082 실제 소비는 **14 CODE** 다(기본판이 헬퍼 뒤에 숨음).
BigFilter 키는 TO-BE CMBO 와 1:1 이라 눈에 보이는 반면, **UP_FX 키 1개는 TO-BE 산출물 3개로 쪼개진다** —
①CMBO 등록 ②소비지점 배선 ③FE 파라미터 전달·스왑. 종전 점검은 ①만 세고 "누락 0"을 선언했다.

**은폐 메커니즘 3종** — 이게 없었으면 즉시 발각됐다:
1. **조용한 폴백** — BE `BaseService.makeComboQuery` 는 미전달 `@토큰`을 예외 없이 `''` 로 치환한다.
   비관대형(`COL = @t`)은 **0행**(콤보는 열리는데 목록만 빔), 관대형(`@t IS NULL OR …`)은 **무필터**
   (후보가 더 많이 나와서 "잘 된다"로 읽힘).
2. **예외 삼킴** — `.catch(() => {})` 가 ORA-00904 를 사용자·콘솔·게이트 어디에도 남기지 않았다.
3. **게이트 맹점** — E2E 시나리오의 콤보 목록이 조회조건 8종뿐이고 셀 콤보가 0건이었다.

## 1. 조치 내역 (DMF0082)

| # | 결함 | 조치 |
|---|---|---|
| D1 | `<DataGrid>` `comboParams` 미전달 → `Measure`(`WHERE PROGRAM_ID=@mnuId`) **0행** → measure 14종을 **코드 raw 표시** | `comboParams={{ mnuId: '\'DMF0082\'' }}`. ⚠️ divisionId 는 의도적 제외(전 셀 콤보 일괄 spread 부작용) |
| D2 | `applySalesBucket`·`applyEditMeasures` 파라미터 **미따옴표** → ORA-00904, 빈 catch 로 은폐 = 두 캐스케이드 **무동작** | `q()` 헬퍼(`utils/forecast-price.combo.ts`) + `console.error` 폴백 로깅 |
| D3 | INCOTERMS 편집 후보가 폐지 코드 포함 (AS-IS 는 `ATTRIBUTE2='Y'` 10종 한정) | `GRID_EDIT_COMBO` 스왑 `IncotermsEdit` — **div 40 한정**(§2) |
| D4 | DOM_EXP 편집 후보가 AS-IS(`DM_CUSTOMS_HANDBOOK_40`='E' 1종)보다 넓음 | `CustomsHandbook` 스왑 — **div 40 한정**(§2) |
| D5 | TEAM_ID 무권한 전체 | **해당없음 판정** — SAVE IN 17종에 `teamId` 없음(표시 전용). §2 참조 |
| D6 | AS 사이트 행 Incoterms 제한 미이식 | `AS_FROM_SITE` + `AsIncotermsEdit` 프리페치 → AS 사이트 행이면 스왑(0행이면 생략) |
| D7 | MEASURE≠PRICE 인데 CURRENCY 입력 가능 (AS-IS `NO_DATA` 분기 미이식) | 편집 진입 시 빈 DataMap 스왑 + `validate.ts` 역방향 정리 |
| D8 | 기본 배분요일이 FE 상수(40=MON/그 외=FRI) 하드코딩 + 주배분 분기 버그 + LOC 월 기준일 일요일 | CMBO `DefaultBucketDay` 신규 등록 → 마스터 조회. 분기식 통일, LOC 월 기준일 MON 정정 |
| D9 | ITEM_ID 변경 시 CELL_PROD_SITE_ID 재조회 없음 (매핑표엔 "구현" **오기재**) | `applyCellProdSites` 신규(행별 서버 재조회 + WeakMap) + 매핑표 정정 |
| 추가 | END_CUSTOMER 변경 시 SCM_SITE_ID 재조회 없음 (SAVE IN `scmSiteId`) | `applySalesSites` 신규 |

## 2. ⭐ 설계 판단 2건 (실측 근거 — 그대로 따르지 말고 이유를 읽을 것)

**(a) 메타 `CELL_COMBO_DATA_TYPE` 를 바꾸지 않았다.**
편집 후보 ⊊ 표시 후보인 축에서 메타를 편집판으로 바꾸면 원장에 남은 코드의 NAME 변환이 깨져
**raw 코드로 표시**된다(= D1 과 같은 사고를 자초). 정본 DMF0003 이 이원화한 이유가 이것이다.
부수 효과로 공유 CMBO 소비 화면(`Incoterms` 36시트 / `DOM_EXP` 12시트 / `DeptId` 10시트) **회귀 0**,
DB 변경분이 **CMBO 1건**으로 축소됐다.

**(b) AS-IS 큐레이션은 AS-IS 가 적용하던 범위(div 40)에만 걸었다.**
AS-IS DMF0082 는 40 전용 화면이었고 `INCOTERMS` EDIT_YN·`DM_CUSTOMS_HANDBOOK_40` 은 40 전제다.
TO-BE 확장분(81/82)에 그대로 걸면 **실제로 쓰는 코드가 막힌다** — 원장 실측:
- 81 INCOTERMS 76.9만 행 중 **14.9만(19%)이 EDIT_YN='N'** (Z02 14.4만 · Z01 · Z04 · A01 · DAT)
- DOM_EXP: 40 은 'E' 뿐이지만 **81 'D' 1.7만 · 82 'D' 2,034 행**

**(c) TEAM_ID 는 편집판 대상에서 제외했다.** `SCM_ADM_PROC_M` 실측상 SAVE IN 17종에 `teamId` 가 없다
(= 조회 결과에서 파생되는 표시 전용). 저장되지 않는 컬럼에 권한 필터를 걸면 이득 없이 위험만 생긴다 —
`TeambyDivisionAuth` 실측 행수 hongjae.kim 0 / jiwon.park 3 / wonqthanq 0 / bpark416 0 / minyonglee1 29.

## 3. 적용 순서

| # | 파일 | 내용 |
|---|---|---|
| 1 | `00_PRECHECK.sql` | baseline 채집 — 특히 **[3] 소비자 시트 수**(적용 후 동일해야 함) |
| 2 | `01_CMBO_MERGE.sql` | CMBO `DefaultBucketDay` 신규 등록 (멱등 NOT EXISTS, 공유 CMBO 본문 무수정) |
| 2-1 | `02_CMBO_GET_ADMIN_GROUP_PARITY.sql` | ⭐ **AS-IS combo SP 프롤로그 '권한 변형' 이식** — §9 참조. ⚠️ **소비 화면 = DMF0003** (DMF0082 아님). 적용 전 CTAS 백업 의무 |
| 3 | `fe/forecast-price/` | ⚠️ **폴더 통째 교체**(파일 단위 덮어쓰기 금지 — 클라우드 셸 세대 혼재 함정) |
| 4 | `90_VERIFY.sql` | 검증 — [3] 이 PRECHECK 와 다르면 즉시 원복 |

**DB 변경 = CMBO 1행 INSERT 뿐.** 메타·PKG·PROC_M 무변경.

## 4. MSG / LBL / MNU / BTN 4분류 감사 (동봉 의무)

| 분류 | 신규/변경 | 판정 근거 |
|---|---|---|
| MSG_M | **0** | 신규 메시지 없음 — D7 역방향 정리는 조용한 값 정리(기존 `CURRENCY_REQUIRED` 유지) |
| LBL_M / locales | **0** | 신규 라벨 없음 (콤보 후보 변경만) |
| MNU_M | **0** | 메뉴·라우팅 무변경 |
| BTN_MPG / API_M | **0** | 버튼·API 배선 무변경 (콤보는 기존 `/admin/combo` 경로) |

## 5. 원복

```sql
DELETE FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = 'DefaultBucketDay';
COMMIT;
```
FE 는 `fe/forecast-price/` 교체 전 폴더를 백업해 두고 되돌린다.
CMBO 만 지우고 FE 를 되돌리지 않으면 `DefaultBucketDay` 조회가 0행 → `bucketBitsOfDay(undefined)`
= **MON 폴백**(AS-IS switch 의 default 와 동일)이라 치명적이지는 않으나, 81/82 는 FRI 가 정답이므로 동시 원복 권장.

## 6. 재발 방지 (동반 반영분)

- **hook #117 §5.5~§5.10 신설** — UP_FX 3분할 완결 의무 / 토큰 대사표 / quoting / 빈 catch 금지 /
  분기 재현 대사 / 편집·조회 이원화 판정식(+적용 범위·SAVE 파라미터 선확인).
- **실행 hook `check-ui-gates.ps1` G-F·G-G 추가** — 빈 `.catch`, quoting 누락을 **작성 시점에 차단**.
  (위반/정상 샘플로 발화·비발화 대조 검증 완료)
- **`ui_gate_runner.py` 섹션 7 신설** — 셀 콤보 토큰 대사 자동 검사. 수정 전 리포트
  `_gate_reports/DMF0082_upfx_section7_BEFORE_*.md`(FAIL 9) ↔ 수정 후 `..._AFTER_*.md`(FAIL 0) 대조 보관.
- **`ui_http_e2e.py` D2 축 신설** — 셀 콤보를 메타에서 자동 수집해 FE 실전달 파라미터로 호출하고
  무전달 호출과 행수를 비교(셀 콤보 0행 = FAIL).
- **`diagnostics/upfx_combo_sweep.py`** — 전 화면 스윕(읽기 전용). §7 참조.

## 7. ⭐ 전 화면 스윕 결과 — **다른 화면에도 같은 결함이 있다**

`_artifacts/_gate_reports/UPFX_COMBO_PARITY_SWEEP_20260808_0952.md`
(화면 17개 · 파라미터 보유 셀 콤보 75건 → **FAIL 6 / WARN 60 / PASS 9** + quoting 누락 3)

| 화면 | 결함 | 영향 |
|---|---|---|
| DMF0021 / DMF0022 / DMF0035 / DMF0048 | `Measure` 콤보 `@mnuId` 미전달 (D1 과 **동일 결함**) | SHEET_MEASURE 43 / 27 / 23 / 36 행이 dataMap 에서 누락 → measure **코드 raw 표시** |
| DMF0042 / DMF0044 | `DM_LOOKUP_DIV` `@param1`,`@param2` 미전달 | 비관대형 → 0행 |
| DMF0048 / DMF0049 | 콤보 파라미터 quoting 누락 3건 | ORA-00904/01722 (조용한 실패) |

> **이번 패키지 범위 밖**이다(사용자 확정: 전 화면은 진단만, 수정은 각 화면 작업 시점 T01M).
> 해당 화면 작업 시 이 리포트를 먼저 열고 hook #117 §5.5~§5.10 을 적용할 것.

## 8. 추가 조치 (2026-08-08 오후 — 사용자 요청분)

### 8-1. Sales Site 특성 기반 Measure 필터 — 트리거 커버리지 보완 ⭐

사이트 특성 필터 자체는 CMBO `FcstPriceEditMeasure` 안에 있다(`SCM_MST_SITE.VMI_YN` 분기 + bucket='D' → LOC 제외).
문제는 **호출 시점**이었다. AS-IS 는 6지점에서 재조회하는데(.cs L2621 InsertRow / L5841 셀변경 /
L7922·L8027 Paste / L8261 Division / L8308 SalesSite·Incoterms) TO-BE 는 `SCM_SITE_ID` 변경 1곳뿐이었다.

가장 큰 구멍은 **InsertRow** — 시드 복사로 만든 행을 그대로 저장하는 정상 흐름에서는 사이트를 다시
바꾸지 않으므로 **사이트 특성 필터가 한 번도 적용되지 않았다**(D2 quoting 결함과 겹쳐 이중으로 죽어 있었음).

조치: 캐스케이드 4종을 컴포넌트 스코프로 이동 + **Insert 행 프라이밍 effect**(`CRUD_TYPE='I'` 신규 행을
WeakSet 으로 1회 조회) + `DIVISION_ID`·`INCOTERMS` 트리거 추가.

### 8-2. `CELL_PROD_SITE_ID` — 조치 불요 (§7 이전 기재 정정)

AS-IS SP 전문을 확보해 대조한 결과 **TO-BE CMBO 는 이미 AS-IS 와 동등**하다(핵심 = `AND @BIZ_TYPE <> 'CELL'`,
주석 *"CELL이 맞다면 Common은 사용하지 않는다"*). 실데이터 3케이스 검증:
itemId 없음/ALL → 4행('-' 포함) / CELL 품목 → 2행('-' 제외) / 비CELL 품목 → 1행('-' 만). **변경 없음.**

### 8-3. 배선 체인 WARN 3건 → 전부 해소 (DMF0082 [PASS] WARN 0)

- `titleSet` — 공유 모달이 리터럴로 호출하는 시트. SHEETS 에 `TITLE_SET` 등재(타 4화면 동일 규약).
- `hotkey DELETE 0그룹` — **체커 판정이 틀렸다.** FE 는 `hasButton('SAVE')` 로 insert/delete/save 를
  일괄 게이트하므로 버튼은 정상 노출. 체커가 hotkeyConfig 내 `hasButton()` 을 읽도록 보완.
- `futurePriceInfo EDIT·INSERT API_ID NULL` — **설계대로.** UI 전용 권한 게이트이고 실저장은 SAVE 경유
  (권한 실측 각 5그룹, 3계정 `mnuBtnAuth` 에 존재). 체커가 UI 전용 버튼을 INFO 로 판정하도록 보완.

> 체커 보완은 **downgrade 전용**이며 원래 경로는 살아 있다 — 전 37화면 재스윕에서
> L3 FAIL 2·WARN 5·INFO 17 / L2P FAIL 2·WARN 23 로 각 판정이 모두 관측된다.
> 개선된 `wiring_chain_check.py`·`ui_gate_runner.py` 를 `diagnostics/` 에 동봉했다.

### 최종 게이트 (2026-08-08 오후)

- `ui_gate_runner --menu DMF0082` → **섹션 1~6 PASS / 섹션 7 WARN 2**(관대형·사유 기재), **FAIL 0**
- `ui_http_e2e --menu DMF0082` → **종합 PASS (FAIL 0 / WARN 0)**, 15계정 전수


## 9. ⭐ AS-IS combo SP **프롤로그(공통 변형)** 이식 — 사용자 지적 (2026-08-08)

> "asis combo sp 상단에 부서와 권한에 대한 변형을 발생시키는 query 가 있습니다. 공통 적용사항이라 적용이 필요한데 tobe 에 적용되어 있나요."

`UP_FX_GetCommonDataList`(기본판)는 **모든 `@Code` 분기 이전**에 두 변형을 수행한다:

| 변형 | AS-IS | 의미 |
|---|---|---|
| ① `@v_dept_id` | `TB_FX_User.DEPT_ID` (+`PM_TEAM_MAPPING` 후순위 폴백) | 사용자 소속 팀 |
| ② `@v_group_id` | `GET_ADMIN_GROUP`(SEGMENT2 IN 'ALL','DMF0003') 등재 시 `'ADMIN'` | **권한 그룹 승격** |

소비 분기 = 255개 중 3개. 프롤로그 보유 SP = **기본판 뿐**(`_DM`/`_FP`/`_SCP`/`_SCP_ALL`/`_REPORT` 없음).

**TO-BE 결함**: ①은 이식됐으나 ②가 **리터럴 `USER_GR_ID='ADMIN'` 로 축소**돼 있었다.
`GET_ADMIN_GROUP` 실측 등재 = ADMIN·**DM ADMIN·DM Planner·SCM PI Admin·SCP Planner**(+DM Planner (W/S)@DMF0003)
→ 로스터 9계정 중 **6계정이 ADMIN 미인정**.

적용 전후 실측(사내):

| CMBO | hongjae.kim | eunah.koo | bpark416 | wonqthanq | DM Viewer 2명 |
|---|---|---|---|---|---|
| TeambyDivisionAuth | 0 → **17** | 1 → **17** | 0 → 0¹ | 0 → 0¹ | 불변 |
| SiteByEndCustomerAuth | 0 → **1,282** | 0 → **1,282** | 0 → **1,191** | 0 → **730** | 불변 |
| EndCustomerByDivisionDeptAuth | 0 → **4** | 0 → **4** | 0 → **531** | 0 → **344** | 불변 |

¹ 다중팀(`TEAM_CNT>1`) 분기 — AS-IS 도 이 분기엔 **ADMIN 우회가 없다**(MAPSET 로만 필터). 파리티 일치.
DM Viewer 는 등재 대상이 아니라 불변 → **권한 축소가 아닌 파리티 복원**임이 확인된다.

- 사내 적용 완료(사용자 승인). 백업 = `SCM_MGR.CMBO_BAK_GAG_20260808` (CTAS 3행)
- BE 실경로 5계정 재확인 완료
- 원복: `UPDATE ... SET SQL_DTL_CTN = (SELECT SQL_DTL_CTN FROM SCM_MGR.CMBO_BAK_GAG_20260808 B WHERE B.SQL_ID = A.SQL_ID)`
- 탐지 SQL(잔존 0 확인): `USER_GR_ID='ADMIN'` 보유 & `GET_ADMIN_GROUP` 미보유 CMBO = **0건**
- 룰: hook #117 **§5.11**(프롤로그 이식 의무) + **§5.12**(호출 지점 N:N 대사 의무)
