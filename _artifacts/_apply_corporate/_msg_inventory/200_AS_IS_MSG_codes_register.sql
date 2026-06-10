--==============================================================================
-- 200_AS_IS_MSG_codes_register.sql
--
-- 목적:
--   AS-IS GSCM (C#.NET WinForms) 에서 사용된 MSG[숫자] 패턴 중
--   To-Be (Docker DB) 의 SCM_ADM_MSG_M 에 미등록인 29개 MSG ID 를
--   사내 클라우드 DB 의 SCM_ADM_MSG_M 에 등록.
--
-- 추출 출처: 11 화면의 __asis-mapping__.md 파일들 (정규식 grep)
-- 인벤토리: ./INVENTORY.md
--
-- 등록 row: 29 MSG × 3 LANG (KO/EN/CN) = 87 row
-- MSG_TP_CD: 'MSG' (Docker 표준 — validation/일반 메시지)
-- 멱등성: NOT EXISTS (MSG_ID + LANG_CD)
-- NOT NULL 보강: MSG_TP_CD/USE_YN/CREATED_BY/LAST_UPDATED_BY 모두 명시 (사내 schema 호환)
--
-- ⚠️ 주의 (Anti-simplification 명시):
--   1) KO 본문은 매핑 문서에서 추출 — AS-IS 원본 카탈로그 정확 본문 보장 안 함
--   2) EN/CN 은 KO 영문 fallback — 정확한 다국어 번역은 후속 사용자 검수 필요
--   3) TODO 4건 (MSG00085/00146/00361/00428) 은 본문 미상 placeholder
--   4) 적용 시 사내 USERS tablespace quota 부족 시 ORA-01653 발생 — DBA 확장 후 재실행
--
-- 작성: 2026-06-10
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON

PROMPT === BLOCK 1 : 29 MSG x 3 LANG = 87 row INSERT (idempotent) ===

INSERT INTO SCM_MGR.SCM_ADM_MSG_M
  (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.MSG_ID, NEW.LANG_CD, NEW.MSG_NM, NEW.MSG_DESC, 'MSG', 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    -- MSG00034 : 일자 입력 검증 (YYYYMMDD 8자리)
    SELECT 'MSG00034' AS MSG_ID, 'KO' AS LANG_CD, '일자 형식이 잘못되었습니다 (YYYYMMDD 8자리).' AS MSG_NM, '일자 형식이 잘못되었습니다 (YYYYMMDD 8자리).' AS MSG_DESC FROM DUAL UNION ALL
    SELECT 'MSG00034', 'EN', 'Invalid date format (YYYYMMDD 8 digits).', 'Invalid date format (YYYYMMDD 8 digits).' FROM DUAL UNION ALL
    SELECT 'MSG00034', 'CN', '日期格式无效 (YYYYMMDD 8位).', '日期格式无效 (YYYYMMDD 8位).' FROM DUAL UNION ALL
    -- MSG00043 : 저장시 중복 오류 (PK 위반)
    SELECT 'MSG00043', 'KO', '저장시 중복 오류가 발생하였습니다. {0}', '저장시 중복 오류가 발생하였습니다. {0}' FROM DUAL UNION ALL
    SELECT 'MSG00043', 'EN', 'Duplicate error on save. {0}', 'Duplicate error on save. {0}' FROM DUAL UNION ALL
    SELECT 'MSG00043', 'CN', '保存时发生重复错误. {0}', '保存时发生重复错误. {0}' FROM DUAL UNION ALL
    -- MSG00060 : 중복 키 (예: SCM_SITE_ID)
    SELECT 'MSG00060', 'KO', '중복된 키가 존재합니다.', '중복된 키가 존재합니다.' FROM DUAL UNION ALL
    SELECT 'MSG00060', 'EN', 'Duplicate key exists.', 'Duplicate key exists.' FROM DUAL UNION ALL
    SELECT 'MSG00060', 'CN', '存在重复键.', '存在重复键.' FROM DUAL UNION ALL
    -- MSG00085 : 본문 미상 (TODO)
    SELECT 'MSG00085', 'KO', '[TODO] MSG00085 본문 결정 필요', '[TODO] MSG00085 본문 결정 필요' FROM DUAL UNION ALL
    SELECT 'MSG00085', 'EN', '[TODO] MSG00085 body undecided', '[TODO] MSG00085 body undecided' FROM DUAL UNION ALL
    SELECT 'MSG00085', 'CN', '[TODO] MSG00085 内容待定', '[TODO] MSG00085 内容待定' FROM DUAL UNION ALL
    -- MSG00096 : 권한 없음
    SELECT 'MSG00096', 'KO', '권한이 없습니다.', '권한이 없습니다.' FROM DUAL UNION ALL
    SELECT 'MSG00096', 'EN', 'No permission.', 'No permission.' FROM DUAL UNION ALL
    SELECT 'MSG00096', 'CN', '没有权限.', '没有权限.' FROM DUAL UNION ALL
    -- MSG00097 : Division 선택 필수
    SELECT 'MSG00097', 'KO', 'Division 을 선택하세요.', 'Division 을 선택하세요.' FROM DUAL UNION ALL
    SELECT 'MSG00097', 'EN', 'Please select Division.', 'Please select Division.' FROM DUAL UNION ALL
    SELECT 'MSG00097', 'CN', '请选择 Division.', '请选择 Division.' FROM DUAL UNION ALL
    -- MSG00108 : 기간 시작 > 종료 / 조회 데이터 없음
    SELECT 'MSG00108', 'KO', '조회 기간이 잘못되었습니다 (시작일 > 종료일).', '조회 기간이 잘못되었습니다 (시작일 > 종료일).' FROM DUAL UNION ALL
    SELECT 'MSG00108', 'EN', 'Invalid period (start > end).', 'Invalid period (start > end).' FROM DUAL UNION ALL
    SELECT 'MSG00108', 'CN', '查询期间无效 (开始 > 结束).', '查询期间无效 (开始 > 结束).' FROM DUAL UNION ALL
    -- MSG00109 : 읽기전용
    SELECT 'MSG00109', 'KO', '읽기전용 상태입니다.', '읽기전용 상태입니다.' FROM DUAL UNION ALL
    SELECT 'MSG00109', 'EN', 'Read-only mode.', 'Read-only mode.' FROM DUAL UNION ALL
    SELECT 'MSG00109', 'CN', '只读模式.', '只读模式.' FROM DUAL UNION ALL
    -- MSG00113 : 필수 입력 컬럼 없음
    SELECT 'MSG00113', 'KO', '필수 입력 컬럼이 없습니다.', '필수 입력 컬럼이 없습니다.' FROM DUAL UNION ALL
    SELECT 'MSG00113', 'EN', 'Required column not found.', 'Required column not found.' FROM DUAL UNION ALL
    SELECT 'MSG00113', 'CN', '未找到必填列.', '未找到必填列.' FROM DUAL UNION ALL
    -- MSG00128 : sheet 별 Insert/Delete 안내
    SELECT 'MSG00128', 'KO', '시트 별 Insert/Delete 처리 안내.', '시트 별 Insert/Delete 처리 안내.' FROM DUAL UNION ALL
    SELECT 'MSG00128', 'EN', 'Sheet-specific Insert/Delete notice.', 'Sheet-specific Insert/Delete notice.' FROM DUAL UNION ALL
    SELECT 'MSG00128', 'CN', '工作表特定 Insert/Delete 通知.', '工作表特定 Insert/Delete 通知.' FROM DUAL UNION ALL
    -- MSG00129 : sheet 별 안내 (Edit toggle)
    SELECT 'MSG00129', 'KO', '시트 별 편집 모드 안내.', '시트 별 편집 모드 안내.' FROM DUAL UNION ALL
    SELECT 'MSG00129', 'EN', 'Sheet-specific edit mode notice.', 'Sheet-specific edit mode notice.' FROM DUAL UNION ALL
    SELECT 'MSG00129', 'CN', '工作表特定编辑模式通知.', '工作表特定编辑模式通知.' FROM DUAL UNION ALL
    -- MSG00130 : sheet 변경 안내 (Tab 전환 dirty)
    SELECT 'MSG00130', 'KO', '변경된 내용이 있습니다. 시트를 변경하시겠습니까?', '변경된 내용이 있습니다. 시트를 변경하시겠습니까?' FROM DUAL UNION ALL
    SELECT 'MSG00130', 'EN', 'You have unsaved changes. Switch sheet?', 'You have unsaved changes. Switch sheet?' FROM DUAL UNION ALL
    SELECT 'MSG00130', 'CN', '您有未保存的更改。是否切换工作表?', '您有未保存的更改。是否切换工作表?' FROM DUAL UNION ALL
    -- MSG00135 : Lock 가드 (Edit 모드)
    SELECT 'MSG00135', 'KO', '편집 모드에서는 이 기능을 사용할 수 없습니다.', '편집 모드에서는 이 기능을 사용할 수 없습니다.' FROM DUAL UNION ALL
    SELECT 'MSG00135', 'EN', 'This function is locked in edit mode.', 'This function is locked in edit mode.' FROM DUAL UNION ALL
    SELECT 'MSG00135', 'CN', '在编辑模式下此功能被锁定.', '在编辑模式下此功能被锁定.' FROM DUAL UNION ALL
    -- MSG00137 : 전 작업이 실행 중
    SELECT 'MSG00137', 'KO', '이전 작업이 아직 실행 중입니다. 잠시 후 다시 시도해주세요.', '이전 작업이 아직 실행 중입니다. 잠시 후 다시 시도해주세요.' FROM DUAL UNION ALL
    SELECT 'MSG00137', 'EN', 'Previous task is still running. Please try again later.', 'Previous task is still running. Please try again later.' FROM DUAL UNION ALL
    SELECT 'MSG00137', 'CN', '前一个任务仍在运行。请稍后再试.', '前一个任务仍在运行。请稍后再试.' FROM DUAL UNION ALL
    -- MSG00142 : ExchangeRate Lock 가드
    SELECT 'MSG00142', 'KO', '환율 정보가 잠겨있어 변경할 수 없습니다.', '환율 정보가 잠겨있어 변경할 수 없습니다.' FROM DUAL UNION ALL
    SELECT 'MSG00142', 'EN', 'Exchange rate is locked and cannot be modified.', 'Exchange rate is locked and cannot be modified.' FROM DUAL UNION ALL
    SELECT 'MSG00142', 'CN', '汇率已锁定无法修改.', '汇率已锁定无法修改.' FROM DUAL UNION ALL
    -- MSG00146 : 본문 미상 (TODO)
    SELECT 'MSG00146', 'KO', '[TODO] MSG00146 본문 결정 필요', '[TODO] MSG00146 본문 결정 필요' FROM DUAL UNION ALL
    SELECT 'MSG00146', 'EN', '[TODO] MSG00146 body undecided', '[TODO] MSG00146 body undecided' FROM DUAL UNION ALL
    SELECT 'MSG00146', 'CN', '[TODO] MSG00146 内容待定', '[TODO] MSG00146 内容待定' FROM DUAL UNION ALL
    -- MSG00152 : 저장할 데이터 없음
    SELECT 'MSG00152', 'KO', '저장할 데이터가 없습니다.', '저장할 데이터가 없습니다.' FROM DUAL UNION ALL
    SELECT 'MSG00152', 'EN', 'No data to save.', 'No data to save.' FROM DUAL UNION ALL
    SELECT 'MSG00152', 'CN', '没有要保存的数据.', '没有要保存的数据.' FROM DUAL UNION ALL
    -- MSG00164 : 조회기간 3년 이내
    SELECT 'MSG00164', 'KO', '조회 기간은 3년 이내로 입력해주세요.', '조회 기간은 3년 이내로 입력해주세요.' FROM DUAL UNION ALL
    SELECT 'MSG00164', 'EN', 'Please enter a period within 3 years.', 'Please enter a period within 3 years.' FROM DUAL UNION ALL
    SELECT 'MSG00164', 'CN', '请输入3年以内的查询期间.', '请输入3年以内的查询期间.' FROM DUAL UNION ALL
    -- MSG00225 : Div 40 MKT_FCST_RP QTY < 0 검증
    SELECT 'MSG00225', 'KO', '수량은 0 이상의 값이어야 합니다.', '수량은 0 이상의 값이어야 합니다.' FROM DUAL UNION ALL
    SELECT 'MSG00225', 'EN', 'Quantity must be 0 or greater.', 'Quantity must be 0 or greater.' FROM DUAL UNION ALL
    SELECT 'MSG00225', 'CN', '数量必须为0或以上.', '数量必须为0或以上.' FROM DUAL UNION ALL
    -- MSG00227 : Insert 행 있음 → Bucket 변경 불가
    SELECT 'MSG00227', 'KO', 'Insert 된 행이 있어 Bucket 을 변경할 수 없습니다.', 'Insert 된 행이 있어 Bucket 을 변경할 수 없습니다.' FROM DUAL UNION ALL
    SELECT 'MSG00227', 'EN', 'Cannot change Bucket while Insert rows exist.', 'Cannot change Bucket while Insert rows exist.' FROM DUAL UNION ALL
    SELECT 'MSG00227', 'CN', '存在 Insert 行时无法更改 Bucket.', '存在 Insert 行时无法更改 Bucket.' FROM DUAL UNION ALL
    -- MSG00255 : Version 2개 초과 선택
    SELECT 'MSG00255', 'KO', '버전은 최대 2개까지 선택할 수 있습니다.', '버전은 최대 2개까지 선택할 수 있습니다.' FROM DUAL UNION ALL
    SELECT 'MSG00255', 'EN', 'You can select up to 2 versions.', 'You can select up to 2 versions.' FROM DUAL UNION ALL
    SELECT 'MSG00255', 'CN', '最多可选择2个版本.', '最多可选择2个版本.' FROM DUAL UNION ALL
    -- MSG00260 : Division/Project/Item/YYYYMMDD/Measure unique 검증
    SELECT 'MSG00260', 'KO', '중복된 조합이 존재합니다 (Division/Project/Item/일자/Measure).', '중복된 조합이 존재합니다 (Division/Project/Item/일자/Measure).' FROM DUAL UNION ALL
    SELECT 'MSG00260', 'EN', 'Duplicate combination (Division/Project/Item/Date/Measure).', 'Duplicate combination (Division/Project/Item/Date/Measure).' FROM DUAL UNION ALL
    SELECT 'MSG00260', 'CN', '存在重复组合 (Division/Project/Item/日期/Measure).', '存在重复组合 (Division/Project/Item/日期/Measure).' FROM DUAL UNION ALL
    -- MSG00265 : Excel Upload 결과 재조회 안내
    SELECT 'MSG00265', 'KO', 'Excel 업로드가 완료되었습니다. 재조회합니다.', 'Excel 업로드가 완료되었습니다. 재조회합니다.' FROM DUAL UNION ALL
    SELECT 'MSG00265', 'EN', 'Excel upload completed. Reloading data.', 'Excel upload completed. Reloading data.' FROM DUAL UNION ALL
    SELECT 'MSG00265', 'CN', 'Excel 上传已完成。正在重新加载.', 'Excel 上传已完成。正在重新加载.' FROM DUAL UNION ALL
    -- MSG00283 : 버전 선택 가드
    SELECT 'MSG00283', 'KO', '버전을 선택하세요.', '버전을 선택하세요.' FROM DUAL UNION ALL
    SELECT 'MSG00283', 'EN', 'Please select a version.', 'Please select a version.' FROM DUAL UNION ALL
    SELECT 'MSG00283', 'CN', '请选择版本.', '请选择版本.' FROM DUAL UNION ALL
    -- MSG00361 : 본문 미상 (TODO)
    SELECT 'MSG00361', 'KO', '[TODO] MSG00361 본문 결정 필요', '[TODO] MSG00361 본문 결정 필요' FROM DUAL UNION ALL
    SELECT 'MSG00361', 'EN', '[TODO] MSG00361 body undecided', '[TODO] MSG00361 body undecided' FROM DUAL UNION ALL
    SELECT 'MSG00361', 'CN', '[TODO] MSG00361 内容待定', '[TODO] MSG00361 内容待定' FROM DUAL UNION ALL
    -- MSG00380 : insert 사용 불가 (Excel Upload 사용 권장)
    SELECT 'MSG00380', 'KO', '직접 Insert 는 사용할 수 없습니다. Excel Upload 를 이용하세요.', '직접 Insert 는 사용할 수 없습니다. Excel Upload 를 이용하세요.' FROM DUAL UNION ALL
    SELECT 'MSG00380', 'EN', 'Direct Insert is not allowed. Please use Excel Upload.', 'Direct Insert is not allowed. Please use Excel Upload.' FROM DUAL UNION ALL
    SELECT 'MSG00380', 'CN', '不允许直接 Insert。请使用 Excel 上传.', '不允许直接 Insert。请使用 Excel 上传.' FROM DUAL UNION ALL
    -- MSG00408 : PriceBatch 추가 가드
    SELECT 'MSG00408', 'KO', 'Price 일괄 입력 조건이 충족되지 않았습니다.', 'Price 일괄 입력 조건이 충족되지 않았습니다.' FROM DUAL UNION ALL
    SELECT 'MSG00408', 'EN', 'Price batch input conditions not met.', 'Price batch input conditions not met.' FROM DUAL UNION ALL
    SELECT 'MSG00408', 'CN', '价格批量输入条件不满足.', '价格批量输入条件不满足.' FROM DUAL UNION ALL
    -- MSG00428 : 본문 미상 (TODO)
    SELECT 'MSG00428', 'KO', '[TODO] MSG00428 본문 결정 필요', '[TODO] MSG00428 본문 결정 필요' FROM DUAL UNION ALL
    SELECT 'MSG00428', 'EN', '[TODO] MSG00428 body undecided', '[TODO] MSG00428 body undecided' FROM DUAL UNION ALL
    SELECT 'MSG00428', 'CN', '[TODO] MSG00428 内容待定', '[TODO] MSG00428 内容待定' FROM DUAL UNION ALL
    -- MSG00429 : 필수 입력 (with parameter)
    SELECT 'MSG00429', 'KO', '{0} 값은 필수 입력 항목입니다.', '{0} 값은 필수 입력 항목입니다.' FROM DUAL UNION ALL
    SELECT 'MSG00429', 'EN', '{0} value is required.', '{0} value is required.' FROM DUAL UNION ALL
    SELECT 'MSG00429', 'CN', '{0} 值为必填项.', '{0} 值为必填项.' FROM DUAL
  ) NEW
WHERE NOT EXISTS (
  SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M X
   WHERE X.MSG_ID = NEW.MSG_ID AND X.LANG_CD = NEW.LANG_CD
);

COMMIT;

PROMPT === BLOCK 2 : VERIFY (87 expected) ===

SELECT 'MSG_TOTAL_29' AS K, COUNT(*) AS C, 87 AS EXPECTED FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID IN ('MSG00034','MSG00043','MSG00060','MSG00085','MSG00096','MSG00097','MSG00108','MSG00109','MSG00113','MSG00128','MSG00129','MSG00130','MSG00135','MSG00137','MSG00142','MSG00146','MSG00152','MSG00164','MSG00225','MSG00227','MSG00255','MSG00260','MSG00265','MSG00283','MSG00361','MSG00380','MSG00408','MSG00428','MSG00429');

PROMPT === BLOCK 3 : TODO 4개 식별 (사용자 본문 결정 필요) ===

SELECT MSG_ID, LANG_CD, SUBSTR(MSG_NM, 1, 60) AS MSG_NM
  FROM SCM_MGR.SCM_ADM_MSG_M
 WHERE MSG_ID IN ('MSG00085', 'MSG00146', 'MSG00361', 'MSG00428') AND LANG_CD = 'KO'
 ORDER BY MSG_ID;

PROMPT === COMPLETE ===
