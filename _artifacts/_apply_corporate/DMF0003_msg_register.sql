-- =====================================================================
-- DMF0003 — 신규 MSG 등록 (MSG00660~00666, KO/EN/CN)
-- 배경: 직전 "MSG00631~646 신규채번"은 stale MAX(630) 근거의 오류.
--       사내 실재분은 원 ID 로 재사용(FE constants 교정 완료), 사내 부재분만 여기서 신규 채번.
-- 채번: 등록 직전 재실측 MAX(MSG)=MSG00659 → MSG00660 부터.
-- 멱등: MERGE (MSG_ID + LANG_CD). 감사 'admin', MSG_TP_CD='MSG', USE_YN='Y'.
-- =====================================================================

MERGE INTO SCM_MGR.SCM_ADM_MSG_M t
USING (
  SELECT 'MSG00660' MSG_ID, 'KO' LANG_CD, 'MKT FCST 수량이 입력된 일자가 없습니다.' MSG_NM FROM DUAL
  UNION ALL SELECT 'MSG00660', 'EN', 'No date has MKT FCST quantity entered.' FROM DUAL
  UNION ALL SELECT 'MSG00660', 'CN', '没有输入 MKT FCST 数量的日期.' FROM DUAL
  UNION ALL SELECT 'MSG00661', 'KO', '복사할 데이터를 선택하세요.' FROM DUAL
  UNION ALL SELECT 'MSG00661', 'EN', 'Please select data to copy.' FROM DUAL
  UNION ALL SELECT 'MSG00661', 'CN', '请选择要复制的数据.' FROM DUAL
  UNION ALL SELECT 'MSG00662', 'KO', '조회 후 수정모드로 가능합니다.' FROM DUAL
  UNION ALL SELECT 'MSG00662', 'EN', 'Edit mode is available after search.' FROM DUAL
  UNION ALL SELECT 'MSG00662', 'CN', '查询后方可进入编辑模式.' FROM DUAL
  UNION ALL SELECT 'MSG00663', 'KO', 'AS From-Site 를 ALL 로 저장할 수 없습니다.' FROM DUAL
  UNION ALL SELECT 'MSG00663', 'EN', 'AS From-Site cannot be saved as ALL.' FROM DUAL
  UNION ALL SELECT 'MSG00663', 'CN', 'AS From-Site 不能保存为 ALL.' FROM DUAL
  UNION ALL SELECT 'MSG00664', 'KO', 'FcstType 코드가 유효하지 않습니다.' FROM DUAL
  UNION ALL SELECT 'MSG00664', 'EN', 'FcstType code is invalid.' FROM DUAL
  UNION ALL SELECT 'MSG00664', 'CN', 'FcstType 代码无效.' FROM DUAL
  UNION ALL SELECT 'MSG00665', 'KO', '조회 기간을 입력하세요.' FROM DUAL
  UNION ALL SELECT 'MSG00665', 'EN', 'Please enter the search period.' FROM DUAL
  UNION ALL SELECT 'MSG00665', 'CN', '请输入查询期间.' FROM DUAL
  UNION ALL SELECT 'MSG00666', 'KO', '실적 수량보다 작은 숫자를 넣을 수 없습니다.' FROM DUAL
  UNION ALL SELECT 'MSG00666', 'EN', 'A value smaller than the actual quantity cannot be entered.' FROM DUAL
  UNION ALL SELECT 'MSG00666', 'CN', '不能输入小于实绩数量的数字.' FROM DUAL
) s
ON (t.MSG_ID = s.MSG_ID AND t.LANG_CD = s.LANG_CD)
WHEN MATCHED THEN UPDATE SET t.MSG_NM = s.MSG_NM, t.MSG_TP_CD = 'MSG', t.USE_YN = 'Y',
  t.LAST_UPDATED_BY = 'admin', t.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES (s.MSG_ID, s.LANG_CD, s.MSG_NM, NULL, 'MSG', 'Y',
  'admin', SYSDATE, 'admin', SYSDATE);

COMMIT;

-- 원복 (ROLLBACK SCRIPT — 필요 시 수동 실행)
-- DELETE FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID BETWEEN 'MSG00660' AND 'MSG00666';
-- COMMIT;
