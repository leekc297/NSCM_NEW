# PKG_SCP0096 이식 메모

프로시저 3개. 각 프로시저 끝의 /* ASIS … */ 원문을 Oracle 로 옮기고 블록을 지운다. O_RC 수는 As-is 최상위 SELECT 수에서 추정 — FE 플랜(e2e_plan.json procs)과 맞춘다.

- P_DM0003_GET_BUCKET_TYPE_CODE: 첫 결과셋 컬럼(As-is 실측 2): CODE(nvarchar(100)), NAME(nvarchar(100))
- P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP: 임시테이블 #TBLDYNAMICPIVOT_SCP0096 → GTT(03_GTT) 또는 WITH 절/컬렉션으로 / 동적 SQL(sp_executesql) → EXECUTE IMMEDIATE 또는 정적 분기
- P_SCP0009_GET_SHEET_CALENDAR_3SPAN: 첫 결과셋 컬럼(As-is 실측 6): COLUMN_NAME(nvarchar(10)), COLUMN_LABEL_NAME(nvarchar(30)), SMALL_CLASS_LABEL_NAME(nvarchar(30)), LARGE_CLASS_LABEL_NAME(nvarchar(30)), DAY_CODE(nvarchar(3)), SORT_ORDER_NO(nvarchar(10))

## 2026-10-20 복원 메모 (하네스 골격 → 사내 현행 미러)

- 2026-10-19 23:36 파이프라인 골격 재생성이 사내 적용본(22:53)을 TODO 골격으로 덮어 check-pkg BLOCK 7(P00·P20×3·P21×3)이 났다.
- `SCP0096_PKG.sql` 은 사내오라클 ALL_SOURCE 재덤프(`_artifacts/_diagnostics/SCP0096_SUPP2_20261020/dump_pkg.py`, FETCHED 2026-10-20 09:48:01,
  LAST_DDL 2026-10-19 22:53:27, VALID) 를 1바이트 무변경으로 미러한 것이다 — 프로시저 4: P_DM0003_GET_BUCKET_TYPE_CODE · P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP
  · P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP · P_SCP0009_GET_SHEET_CALENDAR_3SPAN. 직전 골격은 `_backup/SCP0096_PKG_skeleton_20261020.sql.bak`.
- `SCP0096_GTT.sql` 신설 — GT_SCP0096_PIVOT DDL(DBMS_METADATA, ON COMMIT PRESERVE ROWS) 멱등 생성. 클라우드 이관 시 PKG 보다 먼저 실행.
- check-pkg 2026-10-20: BLOCK 0 / WARN 5 (P37 REGEXP_SUBSTR 콤마 분해 — ZIONEX 변환 본문 그대로, 성능 이슈 신고 없음 → 미변경).
- `SCP0096_PKG.sha256` 는 골격 해시 그대로 둔다(불일치 = 사람 작업본으로 판정되어 pipeline 이 보존).
- gen-pkg.js / pipeline.js 로 재생성 금지(메모리 project_scp0096_pkg_live_zionex_base_20261019).
