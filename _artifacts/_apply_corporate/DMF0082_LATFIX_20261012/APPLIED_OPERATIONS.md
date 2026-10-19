# DMF0082 조회 MF_SP INSERT lateral 해소 `[E20261012-DMF0082LATFIX]` — 사내 ZIOUI1 실행 작업 대조표

| 시각 (2026-10-12) | 계정 | 작업 | 대상 | SQL / 스크립트 |
|---|---|---|---|---|
| 10:08 | SCM_MGR | 기준본 새로 조회(#152) — BODY LAST_DDL **09:52:19**(당일 AJS 수정본, 17039줄) · `src_PKG_DMF0082_BODY_fresh.ASIS.sql` | `PKG_DMF0082` BODY | `_diagnostics/DMF0082_LATFIX_20261012/` |
| 10:16 | SCM_MGR | 실험용 복제 패키지 생성 (검증 전용 — 운영 무영향, FRESH-GATE 통과) | `PKG_DMF0082_LFT` SPEC/BODY | `_diagnostics/DMF0082_LATFIX_20261012/build_lft.py latfix` |
| 10:16~10:30 | SCM_MGR | 동등성·시간 비교 — 원본 vs 복제본, 40/81/82 × minyonglee1(1메저)/k0101(9메저) 6조건 · 6커서 행수·정렬해시·컬럼수 + 행 순서 **전부 PASS** | GTT 만 사용·ROLLBACK | `v01_compare_user.py` → `_v01_results.txt` |
| **10:31:26** | SCM_MGR | **PKG BODY 적용** (FRESH-GATE: 적용 직전 재조회 = 09:52:19 기준본 일치 · VALID · ERR 0 · 의존 INVALID 0 · 적용본 == DB 원문) | `PKG_DMF0082` BODY | [01_PKG_DMF0082_BODY_LATFIX.sql](01_PKG_DMF0082_BODY_LATFIX.sql) (`apply_latfix.py apply`) |
| 10:3x | SCM_MGR | 적용 후 검증 — 적용본 PKG_DMF0082 vs 복제본 81·k0101 6커서 PASS · MF_SP INSERT 새 커서 `b9hn6zvmrhkhu`(PHV 4272580446, VW_LAT 0) 사용 | — | `_v02_post_apply_81_k0101.txt` |
| 10:3x | SCM_MGR | 실험용 복제 패키지 삭제 | `PKG_DMF0082_LFT` | `build_lft.py drop` (클라우드 이관 대상 아님 — 사내 임시 객체) |

- 변경 내용 (GET_MAIN_DATA 1곳 + History 2줄, 타 프로시저 1바이트 불변): MF_SP INSERT(L4182 부근)의 VD 인라인뷰(`SCM_MST_SITE` 82 `VMI_STD_DIO` 선집계) ON 절에 있던 `AND p_division_id = '82'` 를 뷰 WHERE 안으로 이동. ON 절 바인드 상수조건이 집계 뷰를 lateral(`VW_LAT_…`)로 전개시켜 F(`GT_DMF0082_TEMP_FCST_N_PRICE`) 행마다 `MERGE JOIN OUTER`+`BUFFER SORT` 재평가(hook #129 1순위). 등가: 비82 = 뷰 0행 → LEFT JOIN 미매칭 → NULL(기존 ON 거짓과 동일) / 82 = 동일.
- 실측(사내, 타 작업자 인덱스 재생성 부하 중 — 문장 CPU 로 비교): MF_SP INSERT 1회 CPU 40 1.14s→0.47s · 81 1.15s→0.61s · 82 1.18s→0.64s · k0101 40 1.33s→0.95s · 81 1.47s→1.26s · 82 1.70s→1.51s. 계획: `VW_LAT`·`MERGE JOIN OUTER` 소멸, `SORT GROUP BY` 는 잔존(1-b 대상).
- 적용 전 원문 백업: [00_BACKUP_PKG_DMF0082_BODY.sql](00_BACKUP_PKG_DMF0082_BODY.sql) (LAST_DDL 2026-10-12 09:52:19) · 원복: [99_ROLLBACK_PKG_DMF0082_BODY.sql](99_ROLLBACK_PKG_DMF0082_BODY.sql)
- SPEC · PROC_M · GRANT · 시노님 · 인덱스 · GTT 통계 변경 **없음** (BODY 교체만 — GRANT 는 CREATE OR REPLACE 로 보존)
- ⚠ 사내 BODY 에는 AJS 10-08/10-11/10-12 수정(CELL_PROD_SITE_ID '-' 회귀 등)이 들어 있어 클라우드 BODY(10-09 12:08 본)와 다르다 → 클라우드 패키지는 전체본 교체가 아닌 **패치형**(클라우드 USER_SOURCE 를 읽어 앵커 1곳 치환): `_deploy_packages/DMF0082_LATFIX_CLOUD_20261012/`
