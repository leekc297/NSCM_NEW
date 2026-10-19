# DMF0014_NLSDATE_REAPPLY_20260915 — DMF0014 원복분 재반영

## 요구 (사용자 2026-09-15)
Atlas 경유 UI 보완 중 DB 객체가 수정되어 DMF0014 보완분이 원복됨 → PKG_DMF0014 수정이력 확인 후 수정분 재적용.

## 조사 결과 (사내 ZIOUI1, 2026-09-15)
DB 감사·DDL 트리거 없음 → LAST_DDL_TIME + 본문 마커 + 산출물 원문 대조로 판정.

| 객체 | 마지막 DDL | 판정 |
|---|---|---|
| PKG_DMF0014 SPEC | 08-25 20:17 | 최신 이관본 마커 전부 존재 |
| PKG_DMF0014 BODY | 09-11 17:53:55 | = 내 마지막 적용본(`DMF0014_MSGACC_20260911/01`) **완전 일치** · 마커 누락 0 |
| PR_DM_PLN_CUST_FCST_TO_MKT_FCST | 09-02 17:30 | [E20260818-MKT*] 5종 존재 |
| **PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40** | **09-11 09:29:58** | **[E20260827-NLSDATE] 소실 — 본문 = 08-27 적용 전 백업과 완전 일치(원복)** |
| PKG_NSCM_UI_EXCEL BODY | 09-14 10:00 | = 09-14 적용본 일치 |
| FN_SCM_GET_WHERE_SQL / PR_*_SYS_LOG_BATCH | 09-02 17:30 | 이관본 마커 없음(대상 변경분 없음) |
| SCM_ADM_EXCEL_COLUMNS (DMF0014/FCST Upload) | — | 이관본 값 일치 (수정자 표기만 admin) |
| SCM_ADM_EXCEL_UPLOAD 테이블 | 09-11 21:40:38 | 테이블+인덱스 동시각·구조 불변 → TRUNCATE 흔적(구조 변경 아님) |

원복 출처 단서: 원복 본문과 동일한 코드가 공통소스 `_artifacts/_deploy_packages/DMF0014_CLOUD_20260818/A_DB/04_...40.sql`,
`_artifacts/_diagnostics/db_object_census_20260728/sources/...40.PROCEDURE.sql` 에 존재(09-01 jai jun,Lee "NSCM_297 전환 작업 자산 이관" 커밋으로 유입된 구 사본). 실행자는 DB 기록 부재로 미확정.

## 조치 [E20260827-NLSDATE] 재반영 (1줄)
```
- TO_CHAR(FN_NEXT_DAY(CAST(A.SUMMARY_BUCKET_VALUE AS DATE), 'SUN') + (0), 'YYYYMMDD')
+ TO_CHAR(FN_NEXT_DAY(TO_DATE(A.SUMMARY_BUCKET_VALUE, 'YYYYMMDD') /*[E20260827-NLSDATE]*/, 'SUN') + (0), 'YYYYMMDD')
```
## 적용·검증 (2026-09-15 15:13:29)
- 게이트(현재 본문 == 00_BACKUP) 통과 → VALID · ERRORS 0 · 마커 1 · 의존 INVALID 0
- NLS 시험(세션 NLS_DATE_FORMAT='DD-MON-RR'): 원복본 CAST 식 **ORA-01861** / 정정본 TO_DATE 식 **OK 20260920**

## 파일
`00_BACKUP_ASIS/` 원복용 · `01_APPLY/` 적용본(사내 전체본) · `apply_nlsdate.py` (backup/apply/nlstest)

## 클라우드
08-31 이관 패키지 `DMF0014_CLOUD_20260831/A_DB/14_...40.sql` 에 동일 정정 포함. 클라우드 현재 본문 확인 후 1줄 치환 권장.
