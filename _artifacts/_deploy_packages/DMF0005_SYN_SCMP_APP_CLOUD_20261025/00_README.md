# DMF0005_SYN_SCMP_APP_CLOUD_20261025 — Sales Plant·Company 콤보 "Sql Error"(ORA-00942) 보정 (클라우드 패치, DB 만)

- 대상: 앱계정 `SCMP_APP` 시노님 2건 신설 — `SCM_MST_PLANT_SN → FP_MGR.SCM_PLANT_M`, `SCM_MST_COMPANY_SN → FP_MGR.SCM_COMPANY_M`
- 실행 계정: SCM_MGR(CREATE ANY SYNONYM 보유 계정) · 대상: 클라우드 QA → DEV 순
- 사내 ZIOUI1: 적용 완료(2026-10-25) — `_artifacts/_apply_corporate/DMF0005_SYN_SCMP_APP_20261025/`
- **FE 무변경 · BE 무변경·재기동 불필요 · 메타 변경 없음 · PKG 변경 없음.**

## 무엇이 바뀌나
콤보 SQL(`SCM_ADM_CMBO_SQL_M`)은 SCM_MGR 기준 시노님 `SCM_MST_PLANT_SN`·`SCM_MST_COMPANY_SN` 을 쓴다.
SCM_MGR 에는 두 시노님이 있지만 BE 접속 계정 SCMP_APP 에는 없어, BE 가 콤보를 실행하면
`ORA-00942: "SCMP_APP"."SCM_MST_PLANT_SN" 테이블 또는 뷰가 존재하지 않습니다` → HTTP 500 `Sql Error(-9994)`.
DMF0005 그리드 Sales Plant 후보가 0건 → 화면 가드가 입력 Plant 를 지움 → 신규행 저장 불가(`[Sales Plant] value is required`).
SCMP_APP 은 역할 `RL_FP_SEL` 로 두 원본의 SELECT 권한을 이미 가져 시노님만 있으면 된다.

## 사내 검증 (ZIOUI1)
- 적용 전: BE 로그 ORA-00942 · `/api/admin/combo` SALES_PLANT_DM 500 (2026-10-25 02:03)
- 적용 후: 같은 요청 200 · HQ00 → `HQ04, HQ05, HQ06, HQ10` · Sales Site 입력 시 Company=HQ00·Plant=HQ04 자동 설정
- 정합검증 CRUD 실저장(Div 40, Peopleworks_KR_KUM · 385598) `Saved successfully.` → 생성 2행 정리·`SCM_MST_SITE.ETL_DEPT_ID` 원복·잔존 0

## 실행 순서 (전부 전체 F5, 값 입력 없음)
| 순서 | 파일 | 기대 결과 | 다르면 |
|---|---|---|---|
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | L0 권한 CREATE ANY SYNONYM · L1 원본 2 · L3 0행 | L1 원본 없음 → 10 실행 금지·회신. L3 2행 = 이미 적용 |
| 2 | `A_DB/10_APPLY_SYN_SCMP_APP.sql` | `CREATED …` 2줄 (또는 `SKIP (이미 있음)`) | `중단 — …` 이면 회신 |
| 3 | `A_DB/90_VERIFY.sql` | V1 2건 PASS · V2 직접/역할 SELECT 행 존재 · V3 영향 콤보 목록 | 회신 |
| 4 | 화면: DMF0005 Insert → Sales Site 입력 → Sales Plant 드롭다운 | 회사 공장 목록 표시·저장 가능 | 회신 |
| 원복 | `A_DB/99_ROLLBACK_SYN_SCMP_APP.sql` | `ROLLED BACK — DROP …` 2줄 | 회신 |

## 이관 축 점검
| 축 | 해당 |
|---|---|
| GRANT/SYNONYM | ✅ 10_APPLY (시노님 2) |
| PKG · 메타 · MSG/LBL · 데이터 · FE · BE | 해당 없음 |

## 참고 (본 패키지 범위 밖 — 사용자 판단 대기)
사내 ZIOUI1 에서 SCM_MGR 의 외부 스키마 시노님 중 SCMP_APP 에 없는 것이 395건(2026-10-25 DBA_SYNONYMS 대조).
콤보 SQL 이 쓰는 것만도 `SCM_MST_ITEM_SN`·`SCM_MST_LINE_SN`·`SCM_MST_FACTORY_SN`·`SCM_MST_OPERATION_SN` 등 다수 —
같은 ORA-00942 로 실패할 가능성이 크다(화면별 미확인). 본 패키지는 DMF0005 에 필요한 2건만 다룬다.
