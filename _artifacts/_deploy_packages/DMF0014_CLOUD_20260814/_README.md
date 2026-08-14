# DMF0014 (Customer FCST Upload) 클라우드 이관 패키지 — 2026-08-14

## 적용 순서

```
A_DB/01_PKG_DMF0014_SPEC.sql
A_DB/02_PKG_DMF0014_BODY.sql
A_DB/03_PR_DM_PLN_CUST_FCST_TO_MKT_FCST.sql
A_DB/10_META_DMF0014_ALL_AXES.sql       (COMMIT 포함)
A_DB/90_VERIFY.sql                       ← 적용 후 실행, 전 항목 확인
C_BE/FileServiceImpl.java                ← 덮어쓰기 후 BE 재빌드·재기동
B_FE/customer-fcst-upload/               ← features/demand/src/pages/ 하위 폴더 전체 교체
B_FE/foundation-utils/gridAction.ts      ← packages/foundation/src/utils/ 아래 **변경 파일만** 교체
```

## 이번 이관 내용

| 구분 | 변경 |
|---|---|
| Excel Form | **실제 키 조합 생성** — DMF0007 마스터(`DM_MST_CUSTOMER_MODEL` 5키 + `DM_MST_CUSTOMER_FCST` measure) 기준, 직교축 4종은 원장 실사용 조합(정확일치→site→division) |
| Excel Form | 값 컬럼 = **조회구간 버킷 일자 동적 생성**(기본구간 26주). 구 `W27~W31` 5칸 고정 폐기 |
| Excel Form | 업로드 가능 주차 = 노랑 / 불가 = 회색, **다운로드 파일에도 배경색 유지** |
| Excel Upload | **1단 헤더** 지원 — 헤더의 `YYYYMMDD` 가 곧 버킷. BE 매핑 + 검증 SP 버킷 산출 양쪽 정정 |
| 결함 정정 | 후속 SP `PR_DM_PLN_CUST_FCST_TO_MKT_FCST` — `ORA-01422`(GTT 초기화 누락) / `ORA-01403`(핸들러 부재) |
| 안전장치 | **허위 성공 차단** — 적재 0건 또는 롤백으로 소실 시 `CODE='-1'` 반환 |

## 사내 검증 실측

```
Excel Form  : div 81 → 71행 · 기간 26칸 · 센티널 '-' 잔존 0
Excel Upload: HTTP 실파일 업로드 → TOTAL 71 / SUCCESS 71 / ERROR 0
저장(mode=1): PSI 50 → 1249 (delta +1,199 = 입력 값칸 수와 일치)
```

## 메타 축 — 딕셔너리 전수 스윕 산출 (손나열 아님)

`SCM_ADM_*` **66 테이블 / 1,648 문자형 컬럼**을 기계 스캔해 `DMF0014` 를 담은 축을 찾았습니다.
각 행은 **실측 PK 기준 DELETE+INSERT** 라 재적용해도 안전합니다(멱등).

| 축 | 행수 | 키 |
|---|---:|---|
| SCM_ADM_API_M | 13 | API_ID |
| SCM_ADM_EXCEL_COLUMNS | 1 | PROGRAM_ID+SHEET_NAME (논리키 — 전체 20행/20조합 유일 실측) |
| SCM_ADM_MNU_BTN_MPG_M | 12 | MNU_ID+SHT_NM+MNU_BTN_CD |
| SCM_ADM_MNU_M | 1 | MNU_ID |
| SCM_ADM_PROC_M | 64 | PROC_NM+COL_NM+COL_TP_CD |
| SCM_ADM_PROGRAM | 1 | PROGRAM_ID |
| SCM_ADM_USER_GR_MNU_BTN_MPG_M | 60 | USER_GR_ID+MNU_ID+SHT_NM+MNU_BTN_CD |
| SCM_ADM_USER_GR_MNU_MPG_M | 6 | USER_GR_ID+MNU_ID |

**이관 제외 3축** (스윕에는 잡히나 대상 아님)
- `SCM_ADM_EXCEL_UPLOAD` — 업로드 스테이징 작업데이터
- `SCM_ADM_USER_MNU_SRCH_COND_M` — 사용자 개인 조회조건
- `SCM_ADM_MSG_M` — **LBL/MSG 기존 코드 재사용** (아래 참조)

## LBL/MSG — 신규 채번 0건, 이관 제외

> 사용자 확정 (2026-08-14): "LBL, MSG 는 신규가 아니면 기존 코드에 명칭을 변경하면
> **기존 프로그램에 다른 TEXT 로 보이는 치명적인 오류**가 발생합니다."

클라우드 등록내역과 사내 `MSG_NM` 을 코드별로 1:1 대조했습니다 — **6종 전부 동일**.

| 코드 | 클라우드 | 사내 | 판정 |
|---|---|---|---|
| LBL00754 | Upload Result | Upload Result | 동일 |
| LBL00755 | Success | Success | 동일 |
| LBL00756 | Error | Error | 동일 |
| LBL00757 | Total | Total | 동일 |
| LBL00758 | Error Detail | Error Detail | 동일 |
| LBL00759 | Excel File | Excel File | 동일 |

기존 코드 재사용이므로 **META INSERT 자체가 불요**이고, 덮어쓰면 위험만 남습니다.
`SCM_ADM_MSG_M` 축을 패키지에서 제외했습니다. **신규 채번 0건** (채번했다면 `LBL01001` 부터 — 01001+ 대역 현재 MAX 없음).

## FE 이관 단위 — 둘로 나뉜다

| 대상 | 단위 | 이유 |
|---|---|---|
| `customer-fcst-upload/` | **폴더 전체** (13 파일) | 화면 폴더는 `index.ts` 가 `viewRegistry` glob 의 **유일한 등록키**다. 변경분만 담으면 화면이 "Page Not Found" 가 된다(2026-08-14 사고). 생성 시 ASSERT 로 포함을 강제. |
| `packages/foundation/src/utils/` | **변경 파일만** (`gridAction.ts` 1개) | 사용자 지시 2026-08-14. 공용 utils 는 등록키 개념이 없고, 미변경 파일까지 덮으면 클라우드의 다른 화면 변경분을 되돌릴 위험이 있다. |

`gridAction.ts` 변경 = `flatExcelDownload` 에 **선택 인자** `cellFill` 추가(Excel Form 배경색 유지).
선택 인자라 기존 호출부(공용 F11 `excelDownload`, DMF0082 `ForecastTemplateModal`)는 동작이 동일하다.

## 미포함

- 사내 테스트로 적재된 `DM_PLN_CUSTOMER_PSI` 1,199행 — **데이터라 이관 대상 아님**
