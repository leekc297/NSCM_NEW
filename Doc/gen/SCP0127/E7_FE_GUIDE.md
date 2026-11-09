# SCP0127 E7 — 팝업 셀(ITEM_ID) Key-in 잘못된 값 검증 · FE 보완 가이드 (DB MODE · 직접 수정 없음)

- 판정: CheckList SCP0127 v12 조치필요 `EG-629cff83`(E7 · EG176) — 사용자 판정 3-b 오류(2026-11-06)
- AS-IS 사실: `SCP0127_PrecedeSafetyStockDay.cs:726-735` SaveData — `dtItemAll = dsSearchInfo.Tables[5]`(SEARCH_INFO 6번 커서 = `SCM_MST_ITEM_SN ∪ SCP_OPMZ_VIRTUAL_BOM.ITEM_ID_CHILD`) 에서 `DBUtils.Filter(dtItemAll, "ITEM_ID = '<값>'")` 0행이면 `MessageHelper.GMessageBox("MSG00458", v_item_id)` 후 `return`(저장 요청 없음). 셀 자체는 TEXT 라 Key-in 은 허용(EditChange 는 TO_YYYYMMDD 만 처리).
- TO-BE 현황(2026-11-06 23:0x 실측): `nscm-fe/features/supply/src/pages/precede-safety-stock-day/utils/precedeSafetyStockDaySaveValidation.ts:65-69` 는 "실제 존재 검증은 SP 응답으로만 최종 확정" 이라 공백만 검사 → SP 에도 검증 없음 → 잘못된 값이 저장됨.
- DB 보완(적용 완료 · `_artifacts/_apply_corporate/SCP0127_SAVE_ITEM_VALID_20261106/`): `PKG_SCP0127.P_SCP0127_SAVE_PRECEDE_SAFETY_STOCK_DAY` 행 루프(삭제 제외)에서 ITEM_ID 가 그 사업부의 `SCM_MST_ITEM_SN ∪ SCP_OPMZ_VIRTUAL_BOM` 에 없으면 `RAISE_APPLICATION_ERROR(-20010, 'MODEL: <ITEM_ID>' || CHR(10) || '유효하지 않은 모델입니다!')`(MSG00458 KO 문구). → 서버가 저장을 거부하고 화면에 오류 알림이 뜬다.

## 실측(2026-11-06 23:38:13 · BE 직접 호출 `POST /SCP0127/main/SAVE/call-proc` 잘못된 ITEM_ID 1행)
- 응답 `HTTP 200 · code 0 · message success` · `result.o_result_cursor = [{RESULT_CODE:'1', RESULT_MESSAGE:'ORA-20010: MODEL: ZZ_E2E_BAD_KEY\n유효하지 않은 모델입니다!'}]` · `o_rc1 = [{RESULT_CODE:'F', …}]` · 테이블 미변경(23:33 `ITEM_ID='ZZ_E2E_BAD_KEY'` 0행).
- FE `precedeSafetyStockDaySaveRequest.ts:113` 은 `res.status >= 400 || Number(res.data?.code)` 만 보므로 `ok:true` → 화면은 "성공적으로 저장되었습니다!" 토스트(MSG00002) — **DB 는 거부했는데 화면은 성공으로 표시**(E7 재측정 23:28 "알림 ''"). BE(`GeneralServiceImpl.execBtn`)·FE 공용(`packages/*`) 어디에도 `RESULT_CODE` 판독 없음(grep 0건 · 23:3x). 같은 패턴의 SP = PKG_SCP0127~0133(EXCEPTION 에서 `'1' AS RESULT_CODE` 커서 반환 · 재RAISE 없음).

## FE 보완 1(필수 · 저장 응답의 SP 결과코드 판독 — 이 화면 몫)

| 항목 | 내용 |
|---|---|
| 파일 | `nscm-fe/features/supply/src/pages/precede-safety-stock-day/utils/precedeSafetyStockDaySaveRequest.ts` |
| 위치 | 113~117행 |
| 변경 전 | `if (res.status >= 400 \|\| Number(res.data?.code)) { … return { ok: false, message: reason }; } return { ok: true };` |
| 변경 후 | 위 검사 뒤에 SP 상태 커서 판독 추가: `const rc = (res.data?.result as { o_result_cursor?: { RESULT_CODE?: string; RESULT_MESSAGE?: string }[] })?.o_result_cursor?.[0]; if (rc && String(rc.RESULT_CODE ?? '0') !== '0') { return { ok: false, message: String(rc.RESULT_MESSAGE ?? '').replace(/^ORA-\d+:\s*/, '').trim() \|\| undefined }; } return { ok: true };` |
| 이유 | SP 는 검증 실패를 예외로 던지지 않고 `O_RESULT_CURSOR(RESULT_CODE '1', RESULT_MESSAGE)` 로 돌려준다(AS-IS SP CATCH 도 `'[' + ERROR_NUMBER + ']' + ERROR_MESSAGE()` 결과셋 반환). **AS-IS 화면 `SCP0127_PrecedeSafetyStockDay.cs:824-838`** 은 `tran.DataSet.Tables[0].Rows[0][0]=="S"` 면 MSG00004·재조회, 아니면 `"Error!\nMsg : " + 마지막 테이블 Rows[0][0]` 를 GMessageBox — TO-BE 도 같은 분기가 있어야 한다. 응답 코드 0 만 보면 거부된 저장을 성공으로 알린다 |
| 검증법 | ITEM_ID 셀에 `ZZ_E2E_BAD_KEY` 입력 → Save → 알림 "MODEL: ZZ_E2E_BAD_KEY 유효하지 않은 모델입니다!" · 토스트 없음 · 재조회 시 행 없음. CheckList E7(EG176) CELL_BADKEY = "Save 요청 1건 · 서버 검증 거부(저장 안 됨)" PASS |
| 자매 화면 | SCP0128~SCP0133 의 `*SaveRequest.ts` 동일 패턴 확인 필요(같은 SP 계열) |

## FE 보완 2(선택 · AS-IS 와 같은 '저장 요청 전' 검증 — repairScope 가 DB_FE 일 때 적용)

| 항목 | 내용 |
|---|---|
| 파일 | `nscm-fe/features/supply/src/pages/precede-safety-stock-day/utils/precedeSafetyStockDaySaveValidation.ts` |
| 위치 | 65~69행 `// #6 MSG00458 — 품목 미존재 …` 블록 |
| 변경 전 | `if (str(row.ITEM_ID).trim() === '') { return { msgId: MSG.ITEM_NOT_FOUND, message: '_존재하지 않는 품목입니다.' }; }` |
| 변경 후 | 함수에 품목 집합을 넘겨 존재 검사: `validatePrecedeSafetyStockDayRow(row, itemSet?: Set<string>)` → `if (itemSet && !itemSet.has(str(row.ITEM_ID).trim())) { return { msgId: MSG.ITEM_NOT_FOUND, message: '_MODEL: {0}\n유효하지 않은 모델입니다!', field: 'ITEM_ID' }; }` (공백 검사는 #1 필수검증이 이미 담당) |
| 품목 집합 원천 | `PKG_SCP0127.P_SCP0127_GET_SEARCH_INFO` 6번 커서(`O_RC6` DIVISION_ID·ITEM_ID) — 화면이 이미 `useTabComboQueries`/init SEARCH 로 받는 `SCP0127_init_SEARCH` 응답에서 `o_rc6` 를 `Set(ITEM_ID)` 로 만들어 저장 직전 `PrecedeSafetyStockDay.tsx:167` 호출부에 전달(AS-IS `_changeDivision` 시 재적재와 같이 Division 변경 시 갱신) |
| 메시지 | `MSG00458` `{0}` ← ITEM_ID (useMessageStore · `window.alert` 금지) · AS-IS 와 같이 첫 위반 행에서 중단·저장 요청 없음 |
| 이유 | AS-IS 는 저장 요청 전에 막는다(네트워크 왕복 없음) · DB 검증은 안전망으로 유지 |
| 검증법 | CheckList `eg_popup` CELL_BADKEY(EG176): ITEM_ID 셀에 `ZZ_E2E_BAD_KEY` Key-in → Save → 알림 MSG00458 · Save 요청 0건 → PASS. 서버 검증만 있을 때는 "Save 요청 1건 · 서버 검증 거부(저장 안 됨)" 로 PASS |
