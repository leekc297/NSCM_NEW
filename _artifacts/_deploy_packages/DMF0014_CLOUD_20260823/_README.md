# DMF0014 (Customer FCST Upload) 클라우드 이관 — 전 축 취합 (2026-08-23)

> **상태: 취합 완료 / 클라우드 미적용.** 사내 기준 2026-08-23 19:24 (PKG BODY VALID).
> 축 도출 = `_artifacts/_tools/make_cloud_package_full.py --menu DMF0014` (기계 전수 스윕, 31초).
> 원자료 = `_survey/collect_report.json` · BODY delta = `_survey/delta_vs_DMF0014_CLOUD_20260818.diff`.
> ⚠ 델타 패키지 `DMF0014_GRAYZERO_CLOUD_20260823` 은 **본 패키지에 흡수**됨(BODY 동일 세대 + 메타 축 추가).

## 1. 이관 대상 (기계 스윕 실측)

| 축 | 대상 | 실측 | 파일 | 방식 |
|---|---|---:|---|---|
| DB 객체 | `PKG_DMF0014` SPEC | 106줄 | `A_DB/01_PKG_DMF0014_SPEC.sql` | 전체 교체 |
| DB 객체 | `PKG_DMF0014` BODY | 7,325줄 | `A_DB/02_PKG_DMF0014_BODY.sql` | 전체 교체 |
| 메타 | `SCM_MST_SHEET_COLUMNS` | 15행 (1시트) | `A_DB/10_SHEET_COLUMNS.sql` | 시트 단위 삭제 후 전량 재적재 |
| 메타 | `SCM_ADM_EXCEL_COLUMNS` | 1행 | `A_DB/12_EXCEL_COLUMNS.sql` | 범위 삭제 후 재적재 ⭐ |
| 배선 | `PROGRAM` 1 · `MNU_M` 1 · `API_M` 12 · `PROC_M` 64 · `BTN_MPG` 12 | 90행 | `A_DB/20_WIRING_AUTH.sql` | MERGE (PK 기준) |
| 권한 | `USER_GR_MNU_MPG` 6 · `USER_GR_MNU_BTN_MPG` 60 | 66행 | `A_DB/20_WIRING_AUTH.sql` | MERGE ⚠ 그룹 실존 확인 |
| MSG/LBL/MNU | 소비 코드 → `SCM_ADM_MSG_M` | **81행** | `A_DB/30_MSG_LBL_MNU.sql` | **INSERT-only (NOT EXISTS)** |

⭐ `12_EXCEL_COLUMNS.sql` 이 오늘 클라우드 실오류 **2건의 근본 해소**다 — `STORAGE_SQL_ID`(PLS-00201)와
`HEADER_CONTENT`(전건 `Invalid Measure Upload Bucket.`) 가 같은 1행에 들어 있다.

## 2. 담긴 정정 (BODY — 직전 패키지 0818 대비 +35행)

| 마커 | 내용 |
|---|---|
| `[E20260823-GRAYZERO]` | Customer Fcst Master 가 `VALID_YN='Y'` 로 열지 않은 주차(화면 Gray)에 값이 있으면 **0 으로 적재**. 종전 `[E20260818-GRAYWEEK]` 은 업로드 전체를 반려했다 |
| `[E20260823-BUCKETNLS]` | 헤더 일자 파싱을 **숫자 8자리 추출**로 전환(서식·NLS 무관). ⚠ **이번 클라우드 오류의 원인은 아니었다**(진단으로 기각) — 재발 방지용 방어 코드다 |

delta 마커 3종 중 `E20260818-GRAYWEEK` 는 주석 헤더 잔존분이고, **오늘 정정 외 동반 변경 없음**을 diff 로 확인했다.

## 3. 이관 제외 (스윕에는 잡혔으나 대상 아님 — 사유 명시)

| 대상 | 실측 | 사유 |
|---|---:|---|
| `SCM_ADM_EXCEL_UPLOAD` | 83행 | 엑셀 업로드 **스테이징 실행 데이터** (메타 아님) |
| `SCM_ADM_USER_MNU_SRCH_COND_M` | 4행 | **사용자별 조회조건 개인화**(`USER_ID='minyonglee1'`) — 환경별 사용자 상이 |
| 단독 SP 3본 `DMF0014_CUST_FCST_EXCEL_UPLOAD` / `_SM` / `_SAVE_CUST_FCST_UPLOAD_DATA` | — | 사내에서도 **INVALID** 인 폐기 잔재. 3-arg 라 현재 BE 5-arg 계약과 불일치 — **되살리면 PLS-00306** |
| 공유 CMBO 9종 (`BucketType`·`DOM_EXP`·`EndCustomer`·`FcstType`·`Incoterms`·`Measure`·`MyDivision`·`PlantByDivisionCompany`·`SalesSite`) | — | 전부 타 화면 다수 소비(그리드 메타 소비 1~26). 덮어쓰기 부작용 방지 → **PRECHECK C5 존재확인만** |
| `SCM_MST_SHEET_MEASURE` · `LOOKUP_MASTER_DETAIL` | 0행 | DMF0014 해당 행 없음 |
| FE | — | 이번 정정은 **PKG 만**(사용자 지시). FE 변경 없음 |

## 3-1. 감사컬럼 정규화 (2026-08-23 적용)

메타 SQL 4본(`10`/`12`/`20`/`30`)의 `CREATED_BY`/`LAST_UPDATED_BY` 개인 ID(`minyonglee1` 352+30+33+1 = **416곳**)를
`'admin'` 으로 치환했다. `'system'` 유래 값은 그대로 둔다. 생성기 `make_cloud_package_full.py` 에도
`lit_c()` 로 상시 적용 — 다음 패키지부터는 자동이다.

## FE 검증 (이관 취합의 일부 — 2026-08-23)

이 패키지는 **FE 변경이 없다**(정정은 PKG 만 — 사용자 지시). 그래도 취합 시점 기준선을 남긴다.

| 항목 | 결과 |
|---|---|
| `type-check` | **13/13 성공 · error 0** |
| `lint` | **13/13 성공 · error 0** (warning 193 — 기존분) |

원문 = `_survey/fe_check_20260823.txt` · 도구 = `_artifacts/_tools/fe-check.ps1`(넥서스 미접속, 고정 pnpm 10.28.2).

## 4. 적용 순서

1. `00_CLOUD_PRECHECK.sql` (QA·DEV 각각) — **C2/C3 가 이번 사고의 판별 지점**, C6 로 선행 의존 확인
2. `A_DB/01_PKG_DMF0014_SPEC.sql` → `A_DB/02_PKG_DMF0014_BODY.sql`
3. `A_DB/10_SHEET_COLUMNS.sql` → `12_EXCEL_COLUMNS.sql` → `20_WIRING_AUTH.sql` → `30_MSG_LBL_MNU.sql`
4. `A_DB/90_VERIFY.sql`
5. **Excel Form 을 새로 내려받아** 업로드 스모크 — ①`PLS-00201` 소멸 ②`Invalid Measure Upload Bucket.` 소멸
   ③회색 칸 값 = `QTY 0` 적재 / 노란 칸은 입력값 유지

## 5. 미해결 — 적용 후에도 남을 수 있는 것

- **HEADER_CONTENT 밀림의 원인이 메타인지 BE 빌드인지 아직 확정되지 않았다.** PRECHECK C2/C3 조합으로 갈린다:
  SLOT 이 밀려 있으면 `12_EXCEL_COLUMNS.sql` 로 해소되고, SLOT 은 정상인데 스테이징만 밀려 있으면
  **클라우드 BE 재배포**가 필요하다(`FileServiceImpl.cvtListUploadRows`) — SQL 로 못 고친다.
- 회색 칸 `QTY=0` 은 **런타임 미실증**(원장을 실제로 바꾸는 저장이라 사내에서 임의 실행하지 않음).
- `P_DMF0014_CUST_FCST_EXCEL_UPLOAD_SM`(3-arg, 배선 제외)에는 두 정정 모두 미적용.
