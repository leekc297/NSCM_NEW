-- ============================================================
-- 200_AS_IS_MSG_codes_register_DBeaver.sql
--
-- DBeaver 실행용 — sqlplus 토큰 제거.
-- 본문 / 사양은 200_AS_IS_MSG_codes_register.sql 와 동일.
-- 인벤토리: ./INVENTORY.md
--
-- 사용법 (DBeaver):
--   1. 사내 DB 접속 (SCM_MGR / 10.20.100.153:2521:ESSCMD)
--   2. 본 SQL 전체 선택 + Alt+X
--   3. _Verify.sql 로 등록 결과 검증
-- ============================================================

INSERT INTO SCM_MGR.SCM_ADM_MSG_M
  (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.MSG_ID, NEW.LANG_CD, NEW.MSG_NM, NEW.MSG_DESC, 'MSG', 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'MSG00034' AS MSG_ID, 'KO' AS LANG_CD, '일자 형식이 잘못되었습니다 (YYYYMMDD 8자리).' AS MSG_NM, '일자 형식이 잘못되었습니다 (YYYYMMDD 8자리).' AS MSG_DESC FROM DUAL UNION ALL
    SELECT 'MSG00034', 'EN', 'Invalid date format (YYYYMMDD 8 digits).', 'Invalid date format (YYYYMMDD 8 digits).' FROM DUAL UNION ALL
    SELECT 'MSG00034', 'CN', '日期格式无效 (YYYYMMDD 8位).', '日期格式无效 (YYYYMMDD 8位).' FROM DUAL UNION ALL
    SELECT 'MSG00043', 'KO', '저장시 중복 오류가 발생하였습니다. {0}', '저장시 중복 오류가 발생하였습니다. {0}' FROM DUAL UNION ALL
    SELECT 'MSG00043', 'EN', 'Duplicate error on save. {0}', 'Duplicate error on save. {0}' FROM DUAL UNION ALL
    SELECT 'MSG00043', 'CN', '保存时发生重复错误. {0}', '保存时发生重复错误. {0}' FROM DUAL UNION ALL
    SELECT 'MSG00060', 'KO', '중복된 키가 존재합니다.', '중복된 키가 존재합니다.' FROM DUAL UNION ALL
    SELECT 'MSG00060', 'EN', 'Duplicate key exists.', 'Duplicate key exists.' FROM DUAL UNION ALL
    SELECT 'MSG00060', 'CN', '存在重复键.', '存在重复键.' FROM DUAL UNION ALL
    SELECT 'MSG00085', 'KO', '[TODO] MSG00085 본문 결정 필요', '[TODO] MSG00085 본문 결정 필요' FROM DUAL UNION ALL
    SELECT 'MSG00085', 'EN', '[TODO] MSG00085 body undecided', '[TODO] MSG00085 body undecided' FROM DUAL UNION ALL
    SELECT 'MSG00085', 'CN', '[TODO] MSG00085 内容待定', '[TODO] MSG00085 内容待定' FROM DUAL UNION ALL
    SELECT 'MSG00096', 'KO', '권한이 없습니다.', '권한이 없습니다.' FROM DUAL UNION ALL
    SELECT 'MSG00096', 'EN', 'No permission.', 'No permission.' FROM DUAL UNION ALL
    SELECT 'MSG00096', 'CN', '没有权限.', '没有权限.' FROM DUAL UNION ALL
    SELECT 'MSG00097', 'KO', 'Division 을 선택하세요.', 'Division 을 선택하세요.' FROM DUAL UNION ALL
    SELECT 'MSG00097', 'EN', 'Please select Division.', 'Please select Division.' FROM DUAL UNION ALL
    SELECT 'MSG00097', 'CN', '请选择 Division.', '请选择 Division.' FROM DUAL UNION ALL
    SELECT 'MSG00108', 'KO', '조회 기간이 잘못되었습니다 (시작일 > 종료일).', '조회 기간이 잘못되었습니다 (시작일 > 종료일).' FROM DUAL UNION ALL
    SELECT 'MSG00108', 'EN', 'Invalid period (start > end).', 'Invalid period (start > end).' FROM DUAL UNION ALL
    SELECT 'MSG00108', 'CN', '查询期间无效 (开始 > 结束).', '查询期间无效 (开始 > 结束).' FROM DUAL UNION ALL
    SELECT 'MSG00109', 'KO', '읽기전용 상태입니다.', '읽기전용 상태입니다.' FROM DUAL UNION ALL
    SELECT 'MSG00109', 'EN', 'Read-only mode.', 'Read-only mode.' FROM DUAL UNION ALL
    SELECT 'MSG00109', 'CN', '只读模式.', '只读模式.' FROM DUAL UNION ALL
    SELECT 'MSG00113', 'KO', '필수 입력 컬럼이 없습니다.', '필수 입력 컬럼이 없습니다.' FROM DUAL UNION ALL
    SELECT 'MSG00113', 'EN', 'Required column not found.', 'Required column not found.' FROM DUAL UNION ALL
    SELECT 'MSG00113', 'CN', '未找到必填列.', '未找到必填列.' FROM DUAL UNION ALL
    SELECT 'MSG00128', 'KO', '시트 별 Insert/Delete 처리 안내.', '시트 별 Insert/Delete 처리 안내.' FROM DUAL UNION ALL
    SELECT 'MSG00128', 'EN', 'Sheet-specific Insert/Delete notice.', 'Sheet-specific Insert/Delete notice.' FROM DUAL UNION ALL
    SELECT 'MSG00128', 'CN', '工作表特定 Insert/Delete 通知.', '工作表特定 Insert/Delete 通知.' FROM DUAL UNION ALL
    SELECT 'MSG00129', 'KO', '시트 별 편집 모드 안내.', '시트 별 편집 모드 안내.' FROM DUAL UNION ALL
    SELECT 'MSG00129', 'EN', 'Sheet-specific edit mode notice.', 'Sheet-specific edit mode notice.' FROM DUAL UNION ALL
    SELECT 'MSG00129', 'CN', '工作表特定编辑模式通知.', '工作表特定编辑模式通知.' FROM DUAL UNION ALL
    SELECT 'MSG00130', 'KO', '변경된 내용이 있습니다. 시트를 변경하시겠습니까?', '변경된 내용이 있습니다. 시트를 변경하시겠습니까?' FROM DUAL UNION ALL
    SELECT 'MSG00130', 'EN', 'You have unsaved changes. Switch sheet?', 'You have unsaved changes. Switch sheet?' FROM DUAL UNION ALL
    SELECT 'MSG00130', 'CN', '您有未保存的更改。是否切换工作表?', '您有未保存的更改。是否切换工作表?' FROM DUAL UNION ALL
    SELECT 'MSG00135', 'KO', '편집 모드에서는 이 기능을 사용할 수 없습니다.', '편집 모드에서는 이 기능을 사용할 수 없습니다.' FROM DUAL UNION ALL
    SELECT 'MSG00135', 'EN', 'This function is locked in edit mode.', 'This function is locked in edit mode.' FROM DUAL UNION ALL
    SELECT 'MSG00135', 'CN', '在编辑模式下此功能被锁定.', '在编辑模式下此功能被锁定.' FROM DUAL UNION ALL
    SELECT 'MSG00137', 'KO', '이전 작업이 아직 실행 중입니다. 잠시 후 다시 시도해주세요.', '이전 작업이 아직 실행 중입니다. 잠시 후 다시 시도해주세요.' FROM DUAL UNION ALL
    SELECT 'MSG00137', 'EN', 'Previous task is still running. Please try again later.', 'Previous task is still running. Please try again later.' FROM DUAL UNION ALL
    SELECT 'MSG00137', 'CN', '前一个任务仍在运行。请稍后再试.', '前一个任务仍在运行。请稍后再试.' FROM DUAL UNION ALL
    SELECT 'MSG00142', 'KO', '환율 정보가 잠겨있어 변경할 수 없습니다.', '환율 정보가 잠겨있어 변경할 수 없습니다.' FROM DUAL UNION ALL
    SELECT 'MSG00142', 'EN', 'Exchange rate is locked and cannot be modified.', 'Exchange rate is locked and cannot be modified.' FROM DUAL UNION ALL
    SELECT 'MSG00142', 'CN', '汇率已锁定无法修改.', '汇率已锁定无法修改.' FROM DUAL UNION ALL
    SELECT 'MSG00146', 'KO', '[TODO] MSG00146 본문 결정 필요', '[TODO] MSG00146 본문 결정 필요' FROM DUAL UNION ALL
    SELECT 'MSG00146', 'EN', '[TODO] MSG00146 body undecided', '[TODO] MSG00146 body undecided' FROM DUAL UNION ALL
    SELECT 'MSG00146', 'CN', '[TODO] MSG00146 内容待定', '[TODO] MSG00146 内容待定' FROM DUAL UNION ALL
    SELECT 'MSG00152', 'KO', '저장할 데이터가 없습니다.', '저장할 데이터가 없습니다.' FROM DUAL UNION ALL
    SELECT 'MSG00152', 'EN', 'No data to save.', 'No data to save.' FROM DUAL UNION ALL
    SELECT 'MSG00152', 'CN', '没有要保存的数据.', '没有要保存的数据.' FROM DUAL UNION ALL
    SELECT 'MSG00164', 'KO', '조회 기간은 3년 이내로 입력해주세요.', '조회 기간은 3년 이내로 입력해주세요.' FROM DUAL UNION ALL
    SELECT 'MSG00164', 'EN', 'Please enter a period within 3 years.', 'Please enter a period within 3 years.' FROM DUAL UNION ALL
    SELECT 'MSG00164', 'CN', '请输入3年以内的查询期间.', '请输入3年以内的查询期间.' FROM DUAL UNION ALL
    SELECT 'MSG00225', 'KO', '수량은 0 이상의 값이어야 합니다.', '수량은 0 이상의 값이어야 합니다.' FROM DUAL UNION ALL
    SELECT 'MSG00225', 'EN', 'Quantity must be 0 or greater.', 'Quantity must be 0 or greater.' FROM DUAL UNION ALL
    SELECT 'MSG00225', 'CN', '数量必须为0或以上.', '数量必须为0或以上.' FROM DUAL UNION ALL
    SELECT 'MSG00227', 'KO', 'Insert 된 행이 있어 Bucket 을 변경할 수 없습니다.', 'Insert 된 행이 있어 Bucket 을 변경할 수 없습니다.' FROM DUAL UNION ALL
    SELECT 'MSG00227', 'EN', 'Cannot change Bucket while Insert rows exist.', 'Cannot change Bucket while Insert rows exist.' FROM DUAL UNION ALL
    SELECT 'MSG00227', 'CN', '存在 Insert 行时无法更改 Bucket.', '存在 Insert 行时无法更改 Bucket.' FROM DUAL UNION ALL
    SELECT 'MSG00255', 'KO', '버전은 최대 2개까지 선택할 수 있습니다.', '버전은 최대 2개까지 선택할 수 있습니다.' FROM DUAL UNION ALL
    SELECT 'MSG00255', 'EN', 'You can select up to 2 versions.', 'You can select up to 2 versions.' FROM DUAL UNION ALL
    SELECT 'MSG00255', 'CN', '最多可选择2个版本.', '最多可选择2个版本.' FROM DUAL UNION ALL
    SELECT 'MSG00260', 'KO', '중복된 조합이 존재합니다 (Division/Project/Item/일자/Measure).', '중복된 조합이 존재합니다 (Division/Project/Item/일자/Measure).' FROM DUAL UNION ALL
    SELECT 'MSG00260', 'EN', 'Duplicate combination (Division/Project/Item/Date/Measure).', 'Duplicate combination (Division/Project/Item/Date/Measure).' FROM DUAL UNION ALL
    SELECT 'MSG00260', 'CN', '存在重复组合 (Division/Project/Item/日期/Measure).', '存在重复组合 (Division/Project/Item/日期/Measure).' FROM DUAL UNION ALL
    SELECT 'MSG00265', 'KO', 'Excel 업로드가 완료되었습니다. 재조회합니다.', 'Excel 업로드가 완료되었습니다. 재조회합니다.' FROM DUAL UNION ALL
    SELECT 'MSG00265', 'EN', 'Excel upload completed. Reloading data.', 'Excel upload completed. Reloading data.' FROM DUAL UNION ALL
    SELECT 'MSG00265', 'CN', 'Excel 上传已完成。正在重新加载.', 'Excel 上传已完成。正在重新加载.' FROM DUAL UNION ALL
    SELECT 'MSG00283', 'KO', '버전을 선택하세요.', '버전을 선택하세요.' FROM DUAL UNION ALL
    SELECT 'MSG00283', 'EN', 'Please select a version.', 'Please select a version.' FROM DUAL UNION ALL
    SELECT 'MSG00283', 'CN', '请选择版本.', '请选择版本.' FROM DUAL UNION ALL
    SELECT 'MSG00361', 'KO', '[TODO] MSG00361 본문 결정 필요', '[TODO] MSG00361 본문 결정 필요' FROM DUAL UNION ALL
    SELECT 'MSG00361', 'EN', '[TODO] MSG00361 body undecided', '[TODO] MSG00361 body undecided' FROM DUAL UNION ALL
    SELECT 'MSG00361', 'CN', '[TODO] MSG00361 内容待定', '[TODO] MSG00361 内容待定' FROM DUAL UNION ALL
    SELECT 'MSG00380', 'KO', '직접 Insert 는 사용할 수 없습니다. Excel Upload 를 이용하세요.', '직접 Insert 는 사용할 수 없습니다. Excel Upload 를 이용하세요.' FROM DUAL UNION ALL
    SELECT 'MSG00380', 'EN', 'Direct Insert is not allowed. Please use Excel Upload.', 'Direct Insert is not allowed. Please use Excel Upload.' FROM DUAL UNION ALL
    SELECT 'MSG00380', 'CN', '不允许直接 Insert。请使用 Excel 上传.', '不允许直接 Insert。请使用 Excel 上传.' FROM DUAL UNION ALL
    SELECT 'MSG00408', 'KO', 'Price 일괄 입력 조건이 충족되지 않았습니다.', 'Price 일괄 입력 조건이 충족되지 않았습니다.' FROM DUAL UNION ALL
    SELECT 'MSG00408', 'EN', 'Price batch input conditions not met.', 'Price batch input conditions not met.' FROM DUAL UNION ALL
    SELECT 'MSG00408', 'CN', '价格批量输入条件不满足.', '价格批量输入条件不满足.' FROM DUAL UNION ALL
    SELECT 'MSG00428', 'KO', '[TODO] MSG00428 본문 결정 필요', '[TODO] MSG00428 본문 결정 필요' FROM DUAL UNION ALL
    SELECT 'MSG00428', 'EN', '[TODO] MSG00428 body undecided', '[TODO] MSG00428 body undecided' FROM DUAL UNION ALL
    SELECT 'MSG00428', 'CN', '[TODO] MSG00428 内容待定', '[TODO] MSG00428 内容待定' FROM DUAL UNION ALL
    SELECT 'MSG00429', 'KO', '{0} 값은 필수 입력 항목입니다.', '{0} 값은 필수 입력 항목입니다.' FROM DUAL UNION ALL
    SELECT 'MSG00429', 'EN', '{0} value is required.', '{0} value is required.' FROM DUAL UNION ALL
    SELECT 'MSG00429', 'CN', '{0} 值为必填项.', '{0} 值为必填项.' FROM DUAL
  ) NEW
WHERE NOT EXISTS (
  SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M X
   WHERE X.MSG_ID = NEW.MSG_ID AND X.LANG_CD = NEW.LANG_CD
);

COMMIT;
