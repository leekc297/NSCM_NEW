# DMF0014 클라우드 이관 — 회색(입력불가) 주차 값 **0 적재** 1건 (2026-08-23 취합)

> **상태: 취합 완료 / 클라우드 미적용.** 사내는 2026-08-23 18:42 적용·컴파일 VALID.
> **이관 대상 = `PKG_DMF0014` BODY 1본이 전부다.** 메타·GTT·FE·권한 변경 없음.

## 담긴 정정 (1건)

| 마커 | 내용 |
|---|---|
| `[E20260823-BUCKETNLS]` | 헤더 일자 파싱을 **숫자 8자리 추출**로 전환 — 셀 서식·NLS 무관. 클라우드 전건 `Invalid Measure Upload Bucket.` 해소 |
| `[E20260823-GRAYZERO]` | Customer Fcst Master 가 `VALID_YN='Y'` 로 열어둔 주차가 아닌 칸(Excel Form 의 **Gray** 구간)에 값이 있으면 **0 으로 적재**. 종전 `[E20260818-GRAYWEEK]` 은 그 경우 업로드 전체를 **반려**했다 — 정책 전환(사용자 지시). |

변경 지점 2곳 (모두 `P_DMF0014_CUST_FCST_EXCEL_UPLOAD` 안):
1. 회색 주차 검증 블록 → `ERROR` 상태변경·즉시 `RETURN` 제거, **집계·로그(175)** 만.
2. `DM_PLN_CUSTOMER_PSI` 적재 값 → `CASE WHEN EXISTS(마스터 VALID_YN='Y' + division/site/measure/bucket) THEN TO_NUMBER(V.VALUE) ELSE 0 END`
   (헤더 셀 숫자서식 `'20260803.0'` 정규화 포함 — 없으면 정상 주차가 0 으로 뒤집힌다)

## 왜 BODY 전체가 실리나 / 무엇이 같이 딸려가나 (실측)

PL/SQL 패키지는 부분 패치가 불가능해 BODY 전체를 교체한다. 그래서 **직전 클라우드 패키지 대비 실제
delta 를 계산해 동봉 축을 은폐하지 않는다**:

| 항목 | 실측 |
|---|---|
| 사내 라이브 BODY | 7,325줄 / STATUS VALID / LAST_DDL 2026-08-23 18:42:51 |
| 직전 패키지 `DMF0014_CLOUD_20260818` 대비 | **+33 / −21 줄** |
| 그 delta 에 포함된 마커 | `E20260818-GRAYWEEK`(주석 헤더 유지) · `E20260823-GRAYZERO` — **오늘 정정 외 동반 변경 없음** |
| `PKG_DMF0014` SPEC | 사내 라이브 == 직전 패키지 **동일** → **미동봉** |

원문 diff = `_survey/delta_vs_20260818.diff`, 요약 = `_survey/delta_summary.txt`.

## ⛔ 선행 조건 — 0818 패키지

BODY 전체 교체이므로, 클라우드가 아직 `DMF0014_CLOUD_20260818` 을 적용하지 않았다면 **그 패키지를 먼저**
적용해야 한다. 그 패키지가 함께 싣는 **GTT 35종 · `PR_DM_PLN_CUST_FCST_TO_MKT_FCST(_40)` 2본 · 메타**가
없으면 이 BODY 는 컴파일 INVALID 또는 런타임 ORA-00942 가 된다. 판정 = `00_CLOUD_PRECHECK.sql` **C2**.


## ⛔ 클라우드 실오류 대응 추가 (2026-08-23) — `00A_FIX_EXCEL_WIRING.sql`

클라우드 업로드에서 아래 오류가 보고됐다(사내는 정상):

```
Error excelFileUplad: ORA-06550 / PLS-00201:
identifier 'DMF0014_CUST_FCST_EXCEL_UPLOAD' must be declared
```

**원인 = DB 객체가 아니라 배선 메타다.** BE 는 프로시저명을 코드에 박지 않고 메타에서 읽어 그대로 부른다:

| 지점 | 내용 |
|---|---|
| `FileServiceImpl.excelFileUplad` | `validProc = excelInfo.get("STORAGE_SQL_ID")` |
| `Excel.xml / excelUploadValid` | `{ CALL ${validProc}(mode, sesUserId, mnuId, shtNm, O_RESULT_CURSOR) }` — **5-arg** |
| `Excel.xml / selectExcelInfo` | `SELECT * FROM SCM_ADM_EXCEL_COLUMNS WHERE PROGRAM_ID=:mnuId AND SHEET_NAME=:shtNm` |

즉 오류 메시지의 식별자 = **그 DB 의 `SCM_ADM_EXCEL_COLUMNS.STORAGE_SQL_ID` 값**이다.

| | STORAGE_SQL_ID | 결과 |
|---|---|---|
| 사내 (실측) | `PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD` | 정상 (PKG 멤버 = 5-arg) |
| 클라우드 (오류 메시지 역산) | `DMF0014_CUST_FCST_EXCEL_UPLOAD` | 그 이름의 객체가 없어 PLS-00201 |

⚠ 구 단독 SP 를 되살리는 방향은 **오답**이다 — 사내에 남아 있는 동명 SP 는 **3-arg 이고 INVALID** 라,
설령 클라우드에 만들어도 5-arg CALL 과 안 맞아 PLS-00306 으로 다시 실패한다.

`00A_FIX_EXCEL_WIRING.sql` = 그 메타 1행을 PKG 멤버로 교정(멱등) + 전후 검증 + 횡전개 점검 쿼리.
직전 패키지 `DMF0014_CLOUD_20260818/A_DB/10_META_DMF0014_ALL_AXES.sql` 이 같은 값을 이미 싣고 있으므로,
0818 을 통째로 적용할 계획이면 00A 는 생략 가능(중복 무해).

### 파생 발견 — 같은 함정이 다른 화면에도 (사내 실측, 이번 범위 밖)
`STORAGE_SQL_ID` 가 PKG 멤버가 아닌 단독 SP 이름인데 **그 객체가 사내에도 없는** 화면 5건:
`DMF0003 Car Fcst` · `DMF0013 PSI Upload` · `SCP0113` · `SCP0115` · `SSP0018`.
해당 화면에서 Excel Upload 를 누르면 동일한 PLS-00201 이 난다. 점검 쿼리 = 00A 파일 **[5]**.


## ⛔ 클라우드 실오류 대응 ② (2026-08-23) — `[E20260823-BUCKETNLS]` + `00B_DIAG_BUCKET.sql`

파일 선택(mode=0 검증) 단계에서 **전건** `Invalid Measure Upload Bucket.` 로 분류되는 증상(사내 정상).

**원인 = 헤더 일자 파싱이 셀 서식·NLS 에 의존.** 버킷 주기는 헤더 4칸 간격으로 정하는데:

| 갈래 | 종전 코드 | 깨지는 조건 |
|---|---|---|
| ① 행 채택 | `REGEXP_LIKE(Z.ATTRIBUTE15,'^[0-9.eE+-]+$')` | 셀이 `'2026-08-10'` 같은 날짜서식이면 채택 0건 → `IN (빈 집합)` → **전건 반려** |
| ② 값 변환 | `TO_DATE(TO_CHAR(TO_NUMBER(x)),'YYYYMMDD')` | `TO_NUMBER` 가 **NLS_NUMERIC_CHARACTERS** 의존 — `'20260803.0'` × 소수점 `','` DB = ORA-01722 |

사내 실측: `NLS_NUMERIC_CHARACTERS='.,'` + 헤더 `'20260803'` 순수 8자리 → 그래서 사내만 정상이었다.

**정정** — 숫자만 뽑아 앞 8자리로 판정(서식·NLS 무관), 행 채택도 같은 기준(digits ≥ 8)으로 전환:
```sql
TO_DATE(CASE WHEN LENGTH(REGEXP_REPLACE(TRIM(x),'[^0-9]','')) >= 8
             THEN SUBSTR(REGEXP_REPLACE(TRIM(x),'[^0-9]',''),1,8) END,'YYYYMMDD')
```
내성 실측(같은 식에 5형 투입 → 전부 `2026-08-03`): `20260803` · `20260803.0` · `2026-08-03` · `' 2026/08/03 00:00:00'` · `2.0260803E7`.
사내 회귀 확인: 최신 배치 판정 = **WEEKLY**(종전과 동일).

`A_DB/00B_DIAG_BUCKET.sql` = 클라우드에서 원인을 가르는 read-only 진단 6단계(D0 세션 NLS → D1 헤더 실값 →
D2 구 조건 통과 여부 → D3 정정식 판정 → D4 마스터 기대값 → D5 축 대조 → D6 BODY 세대).
**적용 전에 D0~D2 를 먼저 떠 두면** 클라우드 실제 원인이 ①인지 ②인지 증적으로 남는다.

> 재발 방지 룰로 승격: **hook #147 `excel-upload-nls-safe-parsing`** (RULESET_MASTER §4 / 00_INDEX §B.3 /
> 카테고리 맵 3곳 등재). 엑셀 업로드 SP 전체에 R1~R5 + 스윕 3종 적용.

## 파일 / 적용 순서

```
00_CLOUD_PRECHECK.sql            C1 객체상태 / C2 ⛔선행패키지 의존 / C3 현재 마커세대 / C4 마스터 원천 / C5 원장 기준선
A_DB/00A_FIX_EXCEL_WIRING.sql    ⛔ 업로드 PLS-00201 해소 — STORAGE_SQL_ID → PKG 멤버 (멱등)
A_DB/00B_DIAG_BUCKET.sql         진단(read-only) — 'Invalid Measure Upload Bucket' 원인 가르기 D0~D6
A_DB/01_PKG_DMF0014_BODY.sql     PKG BODY 전체 교체 (7,325줄 + 헤더 3줄)
A_DB/90_VERIFY.sql               V1 컴파일 / V2 기대값 단언 3종 / V3 규모 / V4 런타임 스모크 4단계
```

1. `00_CLOUD_PRECHECK.sql` (QA·DEV 각각) — **C2 가 하나라도 0 이면 0818 먼저**
2. `A_DB/00A_FIX_EXCEL_WIRING.sql` — 업로드가 지금 막혀 있으면 **이것부터**. [2] 의 정본 ARG_CNT 가 0 이면 3번 먼저
3. `A_DB/01_PKG_DMF0014_BODY.sql` 단독 실행
4. `A_DB/90_VERIFY.sql` — 기대: 마커 2 / 적재 CASE 1 / 구 반려문구 **0**
5. 화면 스모크 — 회색 칸에 값을 넣어 업로드 → 반려되지 않고, 그 버킷만 `QTY=0`, 같은 행 노란 칸은 입력값 유지

## 범위 밖 (이번 패키지에 없음)

- FE 변경 없음 (사용자 지시 "UI 수정 없이 PKG 만") — `B_FE` 폴더 자체가 없다.
- 메타 변경은 `00A` 의 **`SCM_ADM_EXCEL_COLUMNS.STORAGE_SQL_ID` 1행뿐**. `SCM_MST_SHEET_COLUMNS`·CMBO·MSG·권한 변경 없음.
- `P_DMF0014_CUST_FCST_EXCEL_UPLOAD_SM`(3-arg)은 **배선 제외 SP** 라 사내에서도 미적용 — 같은 적재 로직을
  갖고 있으므로 배선이 살아나면 동일 정정을 옮겨야 한다.
- 사내 적용 산출물(백업·apply 스크립트) = `_artifacts/_apply_corporate/DMF0014_GRAYWEEK_ZERO_20260823/`
