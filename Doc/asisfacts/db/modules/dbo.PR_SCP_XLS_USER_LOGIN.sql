/*          
 * Program ID   : PR_SCP_XLS_USER_LOGIN            
 * Description  : EXCEL SIMULATION LOGIN         
 * OutTable     :          
 * Execute      :        
 * Program History          
 *===================================================================================================          
 *   Date       In Charge      Description          
 *===================================================================================================          
 * 2019.01.04   YYDOK         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트     
 * 2019.08.13   KSW           전극 시뮬레이터 추가 - EE 사업부 추가  
 * 2020.06.22   KSW           GROUP_ID 반환값 추가 - Import 기능(관리자 기능)을 사용할 수 있는 권한확인
 * 2022.03.21	KSW			  GM JV 반영 :: 81_UC, EE_UC 추가 
 * 2023.05.08	KSK			  [PJ20230691] SCM 역량 강화 위한 SCP 개선과제 이행 (ESHM JV 사업부 지원)
 */ 

CREATE PROCEDURE [dbo].[PR_SCP_XLS_USER_LOGIN]
( 
 @P_DIVISION_ID      VARCHAR(100) = NULL,
 @P_USER_ID          VARCHAR(100) = NULL,
 @P_ASIS_PASSWD      VARCHAR(100) = NULL,
 @P_PASSWD_CHANGE_YN CHAR(1) = 'N',
 @P_TOBE_PASSWD      VARCHAR(100) = NULL
 )

AS

BEGIN

    DECLARE @P_RESULT_CODE   VARCHAR(10)
    DECLARE @P_RESULT_MSG    NVARCHAR(200)
--    DECLARE @P_PLANNER_YN    CHAR(1)

    SET NOCOUNT ON;
    SET @P_RESULT_CODE    = NULL
    SET @P_RESULT_MSG     = NULL;

  DECLARE @X_ASIS_PASSWD VARCHAR(255) = NULL

    IF  @P_USER_ID IS NULL
     BEGIN
         SET @P_RESULT_CODE='NG'
         SET @P_RESULT_MSG =N'Enter User ID.'
     END

    IF  @P_ASIS_PASSWD  IS NULL
     BEGIN
         SET @P_RESULT_CODE='NG'
         SET @P_RESULT_MSG =N'Enter User Passwd'
     END

    OPEN SYMMETRIC KEY XLS_SECKEY01
         DECRYPTION BY PASSWORD ='Pa$$w0rdPa$$w0rd'
    ;

    -- USER 권한 확인

SELECT TOP 1 @X_ASIS_PASSWD   =
       CONVERT(VARCHAR,DECRYPTBYKEY(A.XLS_PASSWD)) --암호화한 값
  FROM TB_FX_User          A WITH(NOLOCK),
       TB_FX_GroupInfo     G WITH(NOLOCK),
       TB_FX_UserGroupinfo U WITH(NOLOCK),
       TB_FX_UserGroupAuthExtention D WITH(NOLOCK)
 WHERE A.USERID = @P_USER_ID
   AND G.UseYN  = 'Y' 
   AND U.UseYN  = 'Y' 
   AND G.GroupID = U.GroupID  
   AND U.UserID  = A.USERID
   AND G.GroupID <> 'Guest'
   AND G.GroupID = D.GROUPID
   AND D.UserID  = A.USERID
   AND D.AuthType = 'D'
   AND D.CODE  IN (SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE VALID_YN = 'Y')
   AND G.GROUPID IN ('ADMIN','SCP Planner','SCM PI Admin','SCP Tester')
   AND D.CODE     = @P_DIVISION_ID
   ;      

   --PRINT 'P_ASIS_PASSWD :' +@P_ASIS_PASSWD 
   --PRINT 'X_ASIS_PASSWD :' +@X_ASIS_PASSWD 

   -- 암호비교는 대소문자 구분이 없음.
   IF ( @X_ASIS_PASSWD IS NULL OR @X_ASIS_PASSWD <> @P_ASIS_PASSWD )
      BEGIN
        SET @P_RESULT_CODE='NG'
        SET @P_RESULT_MSG =N'Unregistered User ID or Wrong Passwd.'
      END
   ELSE -- PASSWD 점검통과시
      BEGIN

      SET @P_RESULT_CODE= 'OK'
      SET @P_RESULT_MSG = NULL

      IF @P_PASSWD_CHANGE_YN='Y' 
         BEGIN
          IF @P_TOBE_PASSWD IS NOT NULL
           BEGIN

            OPEN SYMMETRIC KEY XLS_SECKEY01
               DECRYPTION BY PASSWORD ='Pa$$w0rdPa$$w0rd'
            ;

             UPDATE DBO.TB_FX_User
              SET XLS_PASSWD = ENCRYPTBYKEY(KEY_GUID('XLS_SECKEY01'),@P_TOBE_PASSWD),
                  XLS_PASSWD_CHANGE_DATE = GETDATE()
            WHERE 1=1
              AND USERID = @P_USER_ID;
          

           END
          ELSE
             BEGIN
              SET @P_RESULT_CODE='NG'
              SET @P_RESULT_MSG =N'Enter New Passwd.'  
             END           

          END

      -- 사용자 접속로그 생성
      INSERT DBO.SCP_XLS_USER_ACCESS_LOG ( USER_ID,ACCESS_DATE )
      VALUES ( LOWER(@P_USER_ID), GETDATE());

    END

    SELECT  @P_RESULT_CODE   AS RESULT_CODE,
            @P_RESULT_MSG    AS RESULT_MSG;

    IF @P_RESULT_CODE ='OK'
       BEGIN
            SELECT DISTINCT
                   A.USERID   AS USER_ID,
                   A.USERNAME AS USER_NAME,
                   D.CODE     AS DIVISION_ID,
                   G.GROUPID  AS GROUP_ID
              FROM TB_FX_User          A WITH(NOLOCK),
                   TB_FX_GroupInfo     G WITH(NOLOCK),
                   TB_FX_UserGroupinfo U WITH(NOLOCK),
                   TB_FX_UserGroupAuthExtention D WITH(NOLOCK)
             WHERE A.USERID = @P_USER_ID
               AND G.UseYN  = 'Y' 
               AND U.UseYN  = 'Y' 
               AND G.GroupID = U.GroupID  
               AND U.UserID  = A.USERID
               AND G.GroupID <> 'Guest'
               AND G.GroupID = D.GROUPID
               AND D.UserID  = A.USERID
               AND D.AuthType = 'D'
			   AND D.CODE  IN (SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE VALID_YN = 'Y')
               AND G.GROUPID IN ('ADMIN','SCP Planner','SCM PI Admin','SCP Tester')
               AND D.CODE     = @P_DIVISION_ID;

       END
     

END

