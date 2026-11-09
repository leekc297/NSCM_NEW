# SCP0131 Sales Site Priority — SAVE 품목(ITEM_ID) 유효성 검증 추가 · PRIO_RANK 소수 자릿수 메타 (사내 ZIOUI1 적용 2026-11-07)

| 항목 | 내용 |
|---|---|
| 근거 | CheckList v6(2026-11-07 04:14 실측) 조치필요 E7 V-2bcf7fcf / EG-8044996f — ITEM_ID 셀 Key-in 'ZZ_E2E_BAD_KEY' 가 메시지 없이 Save 요청에 실려 응답 200 · SCP0127 3-b(사용자 판정 오류)와 같은 패턴 |
| AS-IS | `SCP0131_SalesSitePriority.cs:681-697` SaveData — dsSearchInfo.Tables[5](SCP0128_GET_SEARCH_INFO 6번 커서 = SCM_MST_ITEM_SN ∪ SCP_OPMZ_VIRTUAL_BOM.ITEM_ID_CHILD)에 없는 ITEM_ID 면 MSG00458 '{0} 유효하지 않은 모델입니다!' 후 저장 중단 |
| TO-BE(적용 전) | PKG_SCP0131 BODY LAST_DDL 2026-10-09 13:39:34 (ALL_SOURCE 07:32:05 조회) — SAVE 루프에 중복·날짜 중복 검사만(199-241행) · FE `salesSitePriority.saveRequest.ts:76-93` 은 o_result_cursor RESULT_CODE≠'0' 을 실패로 읽음(FE 가이드 불필요) |
| 변경 | `P_SCP0131_SAVE_SALES_SITE_PRIORITY` 선언 `V_ITEM_CNT NUMBER(10)` + 삭제 아닌 행마다 (SCM_MST_ITEM_SN ∪ SCP_OPMZ_VIRTUAL_BOM) 미존재 시 `RAISE_APPLICATION_ERROR(-20010, 'MODEL: <ITEM_ID>'||CHR(10)||'유효하지 않은 모델입니다!')` — PKG_SCP0127(11-06 23:16) 과 동일 블록 |
| 절차 | hook #152: ALL_SOURCE 재조회(07:32·07:38 두 번) → OLD 1회 매칭 → FRESH-GATE 통과 → CREATE OR REPLACE → VALID · ALL_ERRORS 0 · 의존 0 · 적용본 == DB 원문 |
| 적용 결과 | LAST_DDL **2026-11-07 07:38:34** VALID · 검증 호출(잘못된 ITEM_ID 1행 'I') → O_RESULT_CURSOR ('1','ORA-20010: MODEL: ZZ_E2E_BAD_KEY …') · ROLLBACK · SCP_OPMZ_SALES_SITE_PRIORITY 행수 전/후 212/212 |
| 메타 | `_artifacts/_apply_corporate/SCP0131_PRIO_RANK_SCALE_20261107` — SCM_MST_SHEET_COLUMNS SCP0131/Sales Site Priority/PRIO_RANK DATA_SCALE_NUMBER NULL→'0' (07:40:05 · E1 V-637991ac '1.5' 허용 → AS-IS 정수만) · 원복 99_RESTORE_PRIO_RANK_scale.sql |
| 백업 | `00_BACKUP/PKG_SCP0131_BODY.ASIS.sql` (SOURCE-FRESH 스탬프 · 원복용) |
| 클라우드 패키지 | `_artifacts/_deploy_packages/SCP0131_CLOUD_DB_MOD_20261107_0740` (리허설 OK · 경고 0 · 20_PKG + 30_META PRIO_RANK `0 DATA_SCALE_NUMBER`) — 0739 패키지는 메타 변경 전 빌드라 폐기 대상 |
| 형제 화면 | 같은 패턴 후보 PKG_SCP0128·0129·0130·0132·0133 — 이번 6화면 PoC 범위 밖이라 미적용(CheckList 실측 후 적용) |
| 남는 것 | FE 사전 검증(AS-IS 동일 동작 · MSG00458 저장 전 표시)은 DB MODE 라 가이드만 — SCP0127 `Doc/gen/SCP0127/E7_FE_GUIDE.md` 보완2 와 같은 방식 |
