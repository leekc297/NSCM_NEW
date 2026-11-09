# 사내오라클(ZIOUI1) 적용 기록 — PKG_SCP0127 SAVE 품목(ITEM_ID) 유효성 검증 (2026-11-06)

| 항목 | 값 |
|---|---|
| 대상 DB | 59.19.252.148:2521/ZIOUI1 · SERVER_HOST=localhost · 접속 system(CURRENT_SCHEMA=SCM_MGR) |
| 발견 경로 | CheckList SCP0127 v12 조치필요 `EG-629cff83`(E7 · EG176 팝업 셀 Key-in 잘못된 값) → 사용자 판정 3-b 오류(2026-11-06 22:13) |
| 원인(실측) | AS-IS `SCP0127_PrecedeSafetyStockDay.cs:726-735` 는 SaveData 에서 SEARCH_INFO 6번 커서(`SCM_MST_ITEM_SN ∪ SCP_OPMZ_VIRTUAL_BOM`) 로 ITEM_ID 를 검증해 MSG00458 후 중단. TO-BE FE `precedeSafetyStockDaySaveValidation.ts:65-69` 는 "존재 검증은 SP 응답으로" 라고 두고 공백만 검사 · `PKG_SCP0127.P_SCP0127_SAVE_PRECEDE_SAFETY_STOCK_DAY`(LAST_DDL 2026-11-05 10:22:22) 에는 중복 검사만 있고 품목 검증 없음(23:0x ALL_SOURCE) |
| 변경 | SAVE 행 루프 `IF V_ACTIVE_FLAG <> 'D'` 직후: ITEM_ID 가 그 사업부의 `SCM_MST_ITEM_SN` 또는 `SCP_OPMZ_VIRTUAL_BOM.ITEM_ID_CHILD` 에 없으면 `RAISE_APPLICATION_ERROR(-20010, 'MODEL: ' || V_ITEM_ID || CHR(10) || '유효하지 않은 모델입니다!')`(SCM_ADM_MSG_M MSG00458 KO 문구 · 같은 SP 의 기존 -20010 한글 리터럴 방식) · 선언 `V_ITEM_CNT` 추가. 서명·PROC_M 변경 없음 |
| 절차 | hook #152: ALL_SOURCE 착수 기준본 조회·백업(`00_BACKUP/PKG_SCP0127_BODY.ASIS.sql`) → OLD 2곳 각 1회 매칭 assert → FRESH-GATE 재조회 일치 → CREATE OR REPLACE PACKAGE BODY |
| 적용 시각 | 2026-11-06 23:16:32 (ALL_OBJECTS.LAST_DDL_TIME) |
| 검증 | STATUS VALID · ALL_ERRORS 0 · 적용본 == DB 원문 · 의존 객체 0(INVALID 0) · 검증 호출(잘못된 ITEM_ID `ZZ_E2E_BAD_KEY` 1행 'I') → SP 예외 처리부가 `O_RESULT_CURSOR ('1','ORA-20010: MODEL: ZZ_E2E_BAD_KEY\n유효하지 않은 모델입니다!')` 반환(DML 전 RAISE · ROLLBACK) · 테이블 행수 전/후 2105/2105 |
| 파일 | `apply_item_valid.py` · `01_PKG_SCP0127_BODY.sql`(SOURCE-FRESH 스탬프) · `00_BACKUP/` 원복본 · FE 가이드 `Doc/gen/SCP0127/E7_FE_GUIDE.md`(DB MODE — AS-IS 와 같은 저장 전 FE 검증은 가이드만) |
| 원복 | `00_BACKUP/PKG_SCP0127_BODY.ASIS.sql` 실행 |
| 클라우드 | cloud_pkg SCP0127 --mode db 패키지(아래 REPORT 참조) |
| 한계 | AS-IS 는 조회조건 Division(복수 가능) 기준 품목 목록으로 검증하나 DB 검증은 행의 DIVISION_ID 기준(행이 속한 사업부 품목만 허용) — 더 엄격 · 정상 데이터는 동일 |
