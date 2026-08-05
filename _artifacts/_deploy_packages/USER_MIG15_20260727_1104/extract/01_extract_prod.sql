-- ============================================================================
-- (참고 동봉) 운영 MSSQL(LGCE_SCMPROD) 재추출용 SELECT 5본
-- 이번 1차 이관은 DEV(LGCE_SCMDEV)의 운영 스냅샷 TB_FX_User_20260715_PROD 를 사용했음.
-- 추후 운영 원본에서 재추출이 필요할 때 사용자가 운영 DB에서 직접 실행.
-- 결과를 탭/파이프 구분 텍스트 또는 xlsx 로 저장 → extract/ 에 두고 10_build_sql.py 재실행.
-- ============================================================================

-- 1) 사용자 프로필 (14명)
SELECT UserID, UserName, UserName_E, Email, Dept_ID, OfficePhoneNum, CellPhoneNum,
       Language, DefaultGroupID, TimeZone, LastLoginDateTime, UseYN,
       Attribute1, Attribute2, Attribute3, Attribute4, Attribute5,
       Attribute6, Attribute7, Attribute8, Attribute9, Attribute10
  FROM dbo.TB_FX_User
 WHERE UserID IN (N'hongjae.kim',N'eunah.koo',N'yooah.chung',N'dodae',
                  N'jiwon.park',N'bpark416',N'jaehyeok',N'park6151',N'bottle',
                  N'wonqthanq',N'ys_cho',N'miyeong.lee',N'yeonjusung',N'coeogus')
 ORDER BY UserID;

-- 2) 그룹-사용자 매핑 (참고 — TO-BE 매핑 정본은 지정 역할 목록)
SELECT UserID, GroupID, UseYN FROM dbo.TB_FX_UserGroupInfo
 WHERE UserID IN (N'hongjae.kim',N'eunah.koo',N'yooah.chung',N'dodae',
                  N'jiwon.park',N'bpark416',N'jaehyeok',N'park6151',N'bottle',
                  N'wonqthanq',N'ys_cho',N'miyeong.lee',N'yeonjusung',N'coeogus')
 ORDER BY UserID, GroupID;

-- 3) 단위(Division 등) 권한
SELECT UserID, GroupID, AuthType, Code, PrntCode, JV_PLANT_ID
  FROM dbo.TB_FX_UserGroupAuthExtention
 WHERE UserID IN (N'hongjae.kim',N'eunah.koo',N'yooah.chung',N'dodae',
                  N'jiwon.park',N'bpark416',N'jaehyeok',N'park6151',N'bottle',
                  N'wonqthanq',N'ys_cho',N'miyeong.lee',N'yeonjusung',N'coeogus')
 ORDER BY UserID, GroupID, AuthType, Code;

-- 4) 그룹 마스터
SELECT GroupID, GrpName, UseYN FROM dbo.TB_FX_GroupInfo ORDER BY GroupID;

-- 5) 5개 그룹의 메뉴 권한 (권한 gap 진단 근거)
SELECT A.GroupID, A.MenuID, M.ProgramID,
       A.BasicACLC, A.BasicACLR, A.BasicACLU, A.BasicACLD, A.UseYN
  FROM dbo.TB_FX_GroupMenuAuth A
  LEFT JOIN dbo.TB_FX_MenuItemInfo M ON M.MenuID = A.MenuID
 WHERE A.GroupID IN (N'DM ADMIN',N'DM Planner',N'DM Planner (W/S)',N'DM Viewer',N'SCP Planner')
 ORDER BY A.GroupID, A.MenuID;
