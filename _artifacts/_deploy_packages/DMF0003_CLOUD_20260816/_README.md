# DMF0003 (MKT FCST) 클라우드 이관 패키지 — 2026-08-16

> 원천 = **사내 SCM_MGR 적용본**(2026-08-16 시점). 생성기 = `_artifacts/_diagnostics/_dmf0003_cloud_package.py`
> 사내 검증: 9섹션 게이트 FAIL 0 / E2E 15계정 FAIL 0 / 대사표 312-312 PASS / 단위테스트 213 PASS

---

## 1. 실행 순서 (SCM_MGR 계정)

| # | 파일 | 내용 | 비고 |
|---:|---|---|---|
| 1 | `A_DB/01_PKG_DMF0003_SPEC.sql` | 패키지 스펙 | 72 lines |
| 2 | `A_DB/02_PKG_DMF0003_BODY.sql` | 패키지 본문 (**정정 5종 포함**) | 15,187 lines |
| 3 | `A_DB/10_META_DMF0003_ALL_AXES.sql` | 메타 11축 521행 (DELETE→INSERT 멱등) | |
| 4 | `A_DB/11_LOOKUP_MKT_FCST_MEASURE_82.sql` | 82 Measure 후보 제외 마킹 | 통합테스트 1st No.52 |
| 5 | `A_DB/12_GRANT_TB_FX_USER.sql` | 앱 계정 SELECT 권한 | **누락 시 셀 콤보 5종 -9994** |
| 6 | `A_DB/90_VERIFY.sql` | 검증 (6개 섹션) | 마지막 실행 |
| 7 | `B_FE/mkt-fcst/` | FE 화면 폴더 **전체** 덮어쓰기 | 27 files |
| 8 | `B_FE/foundation-utils/` | 공용 유틸 폴더 **전체** 덮어쓰기 | 12 files |
| 9 | `B_FE/shared-customDropdown/` | **공용 드롭다운** 폴더 **전체** 덮어쓰기 | 6 files · ⚠ 전 화면 영향 |

FE 반영 후 **빌드/배포**, DB 반영 후 **WAS 재기동**(MyBatis/JDBC statement 캐시).

---

## 2. 패키지 본문에 담긴 정정 5종 (마커로 검증 가능)

| 마커 | 내용 | 사내 실측 효과 |
|---|---|---|
| `E20260815-SAVEPERF` | 저장 DELETE — 날짜 조건을 EXISTS 밖으로 승격 + `HASH_SJ` | buffer gets/실행 2,016,609 → **7** |
| `E20260815-SAVEPERF2` | BOM 검증 probe — `LEADING(A)` 로 작은 GTT 드라이빙 고정 | 45.66s → 2.36s (표본 200행) |
| `E20260815-ASFROMNULL` | AS From Site 빈 값 = **NULL** (구본은 `'-'`) | 저장 왕복 후 `'-'` 행 **0** |
| `E20260815-SENTINEL` | 조회 PK 센티널 `' '`/`'-'`/`'--'` → `'-'` 정규화 + dedup(QTY MAX) | 스테이징 `[--]` 전량 소멸 |
| `E20260815-PIVOTDATE` | PIVOT 조인 **날짜 키 누락** 정정 (`A.YYYYMMDD = D.YYYYMMDD`) | 표시값 42 → **7** (6배 부풀림 해소) |

**저장 SP 전체: 12.62초 → 2.0~3.1초**

> ⚠ `SENTINEL` 블록은 반드시 **분기 위 공통 구간**에 있어야 한다. 1차 시도에서 ELSE 분기 안에 두었다가
> 82 경로(PIVOT #1)가 통째로 건너뛰어 무효화된 이력이 있다. 본 패키지 본문은 정정본이다.

---

## 3. 메타 축 — 딕셔너리 전수 스윕 산출 (손나열 아님)

`ALL_TAB_COLUMNS` 로 `SCM_ADM_*` **66 테이블 / 1,648 문자형 컬럼**을 전수 훑어 `'DMF0003'` 을 담은 축을 기계 수집.

| 축 | 행수 | 축 | 행수 |
|---|---:|---|---:|
| SCM_ADM_USER_GR_MNU_BTN_MPG_M | 203 | SCM_ADM_MSG_M | 33 |
| SCM_ADM_PROC_M | 186 | SCM_ADM_API_M | 26 |
| SCM_ADM_MNU_BTN_MPG_M | 26 | SCM_ADM_CMBO_SQL_M | 17 |
| SCM_ADM_USER_GR_MNU_MPG_M | 9 | SCM_ADM_LOOKUP_MASTER_DETAIL | 7 |
| SCM_ADM_PROGRAM | 3 | SCM_ADM_MNU_M | 2 |
| SCM_ADM_EXCEL_COLUMNS | 1 | **합계** | **521** |

버튼 표시는 **배선(`MNU_BTN_MPG_M`) + 권한(`USER_GR_MNU_BTN_MPG_M`) 둘 다** 필요하며 양쪽 모두 포함됐다.

### 제외한 축 (사유 명시 — 조용한 누락 아님)

| 테이블 | 제외 사유 |
|---|---|
| `SCM_ADM_BTNMPG_BAK_DMF0003_RENAME` | 백업 테이블 — 클라우드 미존재 |
| `SCM_ADM_UGBTN_BAK_DMF0003_RENAME` | 백업 테이블 — 클라우드 미존재 |
| `SCM_ADM_PROC_M_BAK_20260612_153917` | 백업 테이블(일자 스냅샷) |
| `SCM_ADM_LOOKUP_MASTER_DETAIL_H` | 이력 테이블 (원장 아님) |
| `SCM_ADM_SMS_MAIL_SEND_LOG` | 발송 로그 (런타임 산출물) |
| `SCM_ADM_USER_MNU_SRCH_COND_M` | **사용자 개인화** 조회조건 — 환경 간 이관 금지 |

### ⚠ 확인 필요 — 파생 메뉴 동반

`LIKE '%DMF0003%'` 매칭이라 **`DMF0003_1`** 행이 함께 포함된다(`SCM_ADM_MNU_M` 2행).
삭제범위 = 삽입범위라 정합은 깨지지 않지만 `DMF0003_1` 은 이번 작업 범위 밖 메뉴다.
클라우드의 `DMF0003_1` 메타를 사내본으로 덮어쓰는 것이 의도와 다르면 `10_META` 에서 해당 행만 제외할 것.

---

## 4. 스윕으로는 못 잡는 축 (별도 파일 동봉)

화면 ID 문자열을 담지 않아 기계 스윕에 안 걸리는 것 — **누락하면 화면이 조용히 깨진다**.

- `11_LOOKUP_MKT_FCST_MEASURE_82.sql` — `LOOKUP_TYPE='MKT_FCST_MEASURE'` 에 'DMF0003' 문자열이 없다.
  82 제외 마킹 4종(`BNPIn`/`RTF_SYS_RP`/`VMI_In_Plan`/`VMI_Inv`) → 선택가능 3종만 남김.
- `12_GRANT_TB_FX_USER.sql` — 권한은 딕셔너리 스윕 대상이 아니다.
  환경별 앱 계정이 다르므로(`SCMD_APP`/`SCMQ_APP`/`SCMP_APP`) **존재하는 계정 전부**에 부여한다.

---

## 5. FE — 폴더 전체 (부분 이관 금지)

2026-08-14 "Page Not Found" 사고 계보: 변경분만 담아 `pages/<화면>/index.ts` 가 빠지면
`viewRegistry` glob 의 **유일한 등록 키**가 소실돼 탭 안에서 화면이 안 뜬다.
→ 생성기가 `index.ts` 포함을 **ASSERT** 로 강제한다(통과 확인됨).

- `B_FE/mkt-fcst/` (27 files) — 셀 콤보 2종 신설(SCM_SITE_ID40 `@endCustomer` / PLANT_SITE_ID `PlantSiteByItem`),
  공통 UC-01·02·07, 미배선 export 정리
- `B_FE/foundation-utils/` (12 files) — `rebindFilterColumns` / `keepRowVisibleUnderFilter` / `flatExcelDownload(cellFill)`
- `B_FE/shared-customDropdown/` (6 files) — **조회조건 콤보 옵션 중복 제거 일괄 적용** (2026-08-16)

### ⚠ shared-customDropdown 은 공용 컴포넌트 — 영향 범위가 DMF0003 을 넘는다

**증상**: 클라우드 DMF0003 조회조건 End Customer 에 `LGE` 가 2회 표시(로컬은 3개 정상).

**원인**: CMBO SQL 이 화면 표시용 CODE/NAME 외에 **cascade 용 부가 컬럼**(DIVISION_ID·DEPT_ID …)을
함께 반환해 **같은 CODE 가 부가 컬럼 값마다 여러 행**으로 온다.
사내 실측 — `SCM_MST_SITE.END_CUSTOMER`: `LGESMI` 8행/5부서, `LGESWA` 4행/3부서, `LGESAU` 5행/3부서.
LOOKUP `END_CUSTOMER` 1,698행 자체는 `(div,code)` 전부 고유 — **데이터 오류가 아니라 구조**다.
화면별로 dedupe 가 있으면 1개, 없으면 N개로 갈렸다.

**조치**: `CustomDropdown` 이 **표시 직전**에 `value`(TRIM) 기준 first-wins 로 옵션을 합친다.
- 데이터 계층(`useTabComboQueries`/`apiClient`)에서 지우지 **않는다** — 부가 컬럼 행이 하위 콤보
  cascade 의 근거라 거기서 지우면 cascade 가 깨진다.
- 중복이 없으면 원본 배열 참조를 그대로 반환한다(리렌더 부담 없음).

**적용 후 회귀 확인 권장** — 이 컴포넌트를 쓰는 전 화면 조회조건이 대상이다.
사내 검증: type-check(demand/master) 통과 · 단위테스트 14파일 **213 PASS**.

---

## 6. 적용 후 확인

1. `90_VERIFY.sql` — 객체 VALID / 오류 0 / **마커 5종 전부 존재** / 축별 건수 / 82 Measure 3종 / GRANT 행
2. 화면 — 82 조회 → 저장값이 **입력한 값 그대로** 표시(배수 부풀림 없음)
3. 화면 — Insert 시 Team/End Customer/Sales Site 콤보에 값이 나오는지(GRANT 확인)
4. 화면 — 저장 후 AS From Site 에 `'-'` 행이 새로 생기지 않는지
5. 화면 — **조회조건 End Customer 에 같은 값이 1회만** 표시되는지 (+ 타 화면 조회조건 콤보 회귀)

> ⚠ 기존 클라우드 원장에 `ATTRIBUTE10='-'` 로 저장된 행이 있으면 화면에서 행이 갈라져 보인다.
> 사내에서는 11행을 NULL 로 보정했다. 클라우드도 필요하면:
> ```sql
> UPDATE SCM_MGR.DM_PLN_MKT_FCST SET ATTRIBUTE10 = NULL WHERE ATTRIBUTE10 = '-';
> COMMIT;
> ```
> (`ATTRIBUTE10` 은 PK 구성 컬럼이 아니고 NULLABLE='Y' — 사내 실행 시 형제행 0 확인)
