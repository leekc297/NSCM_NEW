



-- *===================================================================================================
-- Author:       P.C.I
-- Create date:  2024-06-13
-- Description: XLS to DEV db conversion table - PR_NERP_XLS_TO_CONVERTER 참조수정(ZNERP_TOBE_CODE_INFO)
-- EXEC PR_SCM_SYS_RFC_CALL_NERP 'ZCMCM_AS_TOBE_CODE_INFO'--,'HQ00'
-- EXEC PR_NERP_XLS_TOBE_CONVERTER @p_rollin='2ND',@p_sys_type='ALL'
-- *===================================================================================================
-- *   Date       In Charge      Description
-- *===================================================================================================
-- * 2025.04.08   김준규          SCP용 추가 work_site, work_site_desc, work_cost_center, ROLLIN 차수 재정의
--                               본프로그램으로 1차(한국,WA) 작업되는 부분 운영 값으로 대체(1차데이터 비정상)
-- * 2025.04.17   김준규          입력 변수로 ROLLIN 차수 입력받음(VENDOR_ID, END_CUSTOMER_ID는 이전차수 제외 하고 처리)
-- * 2025.05.13   김준규          IF @p_sys_type='ALL'  backup 하고 truncate 하고 merge 한다
--                                없어지는 CODE도 존재하여 기존 MERGE로만 작업시 사라진 코드를 그대로 사용하고 있는 문제 있음
-- * 2025.05.23   김준규          QA서버에 테이블 전체 컬럼에 UK 만들어 놓음. 현재 중복 INSERT되는데 원인 파악필요.
-- * 2025.05.25   김준규          1차 오펀시 백업데이터는 QA 및 운영에 통일 테이블 명(BACKUP_NERP_CONV_MASTER_PROD_250417)으로
--                               동일하게 데이터 존재해서 프로그램 수정함(운영이관시 즉시 변경없이 사용가능)
-- * 2025.07.10   김준규          2차 오펀시 백업데이터는 QA 및 운영에 통일 테이블 명(BACKUP_NERP_CONV_MASTER_PROD_250710)으로
--                               동일하게 데이터 존재해서 프로그램 수정함(운영이관시 즉시 변경없이 사용가능)
-- * 2025.09.11   김준규          DM용 CURRENCY RMB TO CNY 변경 추가, 기존 WAERS를 사용했으나 금번에 3RD에 DM한정으로 사용 별도 CODETYPE으로 만듦.
-- * 2025.10.14   김준규          3차 오펀시 백업데이터는 QA 및 운영에 통일 테이블 명(BACKUP_NERP_CONV_MASTER_PROD_251010)으로
--                               동일하게 데이터 존재해서 프로그램 수정함(운영이관시 즉시 변경없이 사용가능)
-- * 2025.10.20   김준규          @P_ROLLIN의 차수 "4N5"는 여기서는 입력 하면 안됨,교체식 제외처리 값으로 X4N5X@ 추가
-- * 2025.11.14   김준규          DM용 G670,G671 PLANT_ID,SCP_SITE_ID 강제 수작업 추가
-- * 2025.11.17   김준규          4TH 백업하고 BACKUP_NERP_CONV_MASTER_4TH_251117을 5TH에 사용(NERP QA에서만 사용해야 됨,운영없음)
-- * 2025.11.18   김준규          기존 운영에서 사용하고 있는 SCP_SITE_ID가 누락되지 않게 해달라는 요청 적용
--                               운영환경일 경우 백업테이블명: @NewTableName 에서 SCP_SITE_ID 신규 값으로 설정되지 않은 것 INSERT 처리
-- * 2025.12.11   김준규          4TH BACKUP_NERP_CONV_MASTER_PROD_251204을 5TH에 사용
-- * 2025.12.17   김준규          기존 운영에서 사용하고 있는 SCP_SITE_ID가 누락되지 않게 할때, 차수를 ''9TH'' ATTRIBUTE5 -- 9TH로 강제로 변경
-- *===================================================================================================
CREATE PROCEDURE [dbo].[PR_NERP_XLS_TOBE_CONVERTER]
    @p_rollin NVARCHAR(30), --1ST 2ND 3RD 4TH
    @p_sys_type NVARCHAR(max)='USAGE',
    @p_sys_flag NVARCHAR(max)='',
    @p_sys_gubun NVARCHAR(max)='MERGE',
    @p_user_id NVARCHAR(max)='AUTO',
    @p_option NVARCHAR(max)='N'
AS
BEGIN
    --2025.04.17 김준규 롤인차수 추가 시작
    IF @P_ROLLIN NOT IN ('1ST','2ND','3RD','4TH','5TH','X4N5X@')  --교체식 제외처리 값으로 X4N5X@ 추가
    BEGIN
        PRINT CONVERT(NVARCHAR(MAX), N'@P_ROLLIN: '''+ISNULL(@P_ROLLIN,'Value is null ')+''' Please, Input Defined ROLLIN, Stop Procedure!!.');
        RETURN 1; -- 오류 코드를 반환하며 프로시저 종료
    END
    --2025.04.17 김준규 롤인차수 추가 종료

    DECLARE @CREATED_BY NVARCHAR(128)='NERP_CONV_'+@P_ROLLIN;

    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    print @p_sys_type

    IF @p_sys_type = 'USAGE'
    begin
        print ' usage '
        print ' EXEC    [dbo].[PR_NERP_XLS_TOBE_CONVERTER] @p_rollin, @p_sys_type, @p_sys_flag, @p_sys_gubun, @p_user_id, @p_option'
        print N' @p_rollin    : 적용할 Rollin 차수 - VENDOR_ID, END_CUSTOMER_ID는 이전차수 제외'
        print ' @p_sys_type  : USAGE (default) - this info '
        print '              : ALL - all CODE TYPE '
        print '              : COMPANY_ID - apply to CODE TYPE company_id '

        print ' @p_sys_flag  : N/A'

        print ' @p_sys_gubun : Operation to execute'
        print '              : MERGE - merge (default) '
        print '              : UPSERT - merge '
        print '              : INSERT - insert'
        print ''

        print ' @p_user_id   : Specify UserID (defautl string AUTO)'
        print ''

        print ' @p_option    : Running Option'
        print '              : ''C%'' : clear first '
        print N'              : ''%M'' : 매핑완료 적용'
        print ''

        print ' EXEC    [dbo].[PR_NERP_XLS_TOBE_CONVERTER] ''PLANT'','''',''INSERT'',''AUTO'',''CM'' '
        print N'    run to convert PLANT for insert operation with id ''AUTO'', with option clear then only for ''확정'''

        -- TODO

        RETURN
    END

    --2025-05-13 김준규 추가 시작
    --backup 하고 truncate 하고 merge 한다
    IF @p_sys_type='ALL'
    BEGIN
        DECLARE @BaseTableName NVARCHAR(254) = 'NERP_CONV_MASTER'; -- 기본 테이블 이름
        DECLARE @DatePart NVARCHAR(8) = FORMAT(GETDATE(), 'yyyyMMdd'); -- 오늘 날짜 (예: 20250513)
        DECLARE @NewTableName NVARCHAR(254);
        DECLARE @Counter INT = 1;
        DECLARE @SQL_TBL NVARCHAR(MAX);
        DECLARE @DropDateThreshold NVARCHAR(8);

        -- 2개월 전 날짜 계산
        SET @DropDateThreshold = FORMAT(DATEADD(month, -2, GETDATE()), 'yyyyMMdd');

        -- 테이블이 존재하는지 확인하고, 존재하면 숫자를 증가시켜 새로운 테이블 이름 생성
        WHILE EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @BaseTableName + '_' + @DatePart + '_' + CAST(@Counter AS NVARCHAR))
        BEGIN
            SET @Counter = @Counter + 1;
        END

        -- 최종 새로운 테이블 이름 설정
        SET @NewTableName = @BaseTableName + '_' + @DatePart + '_' + CAST(@Counter AS NVARCHAR);

        -- SELECT INTO 구문을 동적으로 생성
        SET @SQL_TBL = 'SELECT * INTO ' + @NewTableName + ' FROM ' + @BaseTableName + ';';

        -- 동적 SQL 실행
        EXEC sp_executesql @SQL_TBL;

        --테이터 삭제하고 작업처리
--##############################################################################
        TRUNCATE TABLE NERP_CONV_MASTER;
--##############################################################################

        ------------------------------------------------------------------------------------
        -- 2개월 이전 테이블 삭제 로직
        ------------------------------------------------------------------------------------
        DECLARE @DropTableName NVARCHAR(254);
        DECLARE @DropSQL NVARCHAR(MAX);

        DECLARE TableCursor CURSOR FOR
        SELECT TABLE_NAME
        FROM   INFORMATION_SCHEMA.TABLES
        WHERE  TABLE_NAME LIKE @BaseTableName + '_[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_%' -- 날짜 패턴 포함
        AND    SUBSTRING(TABLE_NAME, LEN(@BaseTableName) + 2, 8) < @DropDateThreshold;

        OPEN TableCursor;

        FETCH NEXT FROM TableCursor INTO @DropTableName;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @DropSQL = 'DROP TABLE ' + @DropTableName + ';';
            BEGIN TRY
                EXEC sp_executesql @DropSQL;
                PRINT N'테이블 삭제됨: ' + @DropTableName;
            END TRY
            BEGIN CATCH
                PRINT N'테이블 삭제 실패: ' + @DropTableName;
                PRINT ERROR_MESSAGE();
            END CATCH;

            FETCH NEXT FROM TableCursor INTO @DropTableName;
        END;

        CLOSE TableCursor;
        DEALLOCATE TableCursor;

        --2025-05-13 김준규 추가 종료
    END;

    DECLARE @delete_option nvarchar(1) = 'N'
    DECLARE @matching_option int = 0
    if @p_option LIKE 'C%'  begin
        SET @delete_option = 'Y'
    end

    if @p_option LIKE '%M' begin
        SET @matching_option = 1
    end

    -- DELETE EXISTING DATA
    if @delete_option = 'Y' begin
        DELETE FROM [NERP_CONV_MASTER]
        WHERE 1=1
    end

    DECLARE @work_company int = 0       -- BUKRS
    DECLARE @work_plant int = 0         -- WERKS
    DECLARE @work_storage int = 0       -- LGORT
    DECLARE @work_end_customer int = 0  -- KUNNR
    DECLARE @work_vendor int = 0        -- LIFNR
    DECLARE @work_biz_partner int = 0   -- PARTNER
    DECLARE @work_biz_area int = 0      -- GSBER
    DECLARE @work_material_group int = 0    -- MATKL
    DECLARE @work_indicator_GL int = 0      -- UMSKZ
    DECLARE @work_profit_center int = 0     -- PRCTR
    DECLARE @work_movement_type int = 0     -- BWART
    DECLARE @work_distribute_channel int = 0    -- VTWEG
    DECLARE @work_sales_group int = 0           -- VKGRP
    DECLARE @work_sales_order_type int = 0      -- AUART
    DECLARE @work_incoterms int = 0             -- INCO1(엑셀 별도)
    DECLARE @work_routes int = 0                -- ROUTE
    DECLARE @work_document_type int = 0             -- BLART
    DECLARE @work_vat_code int = 0              -- MWSKZ
    DECLARE @work_site int = 0                  -- 자체 제작 // PLANT+OPERATION_GROUP (EX. A010-A 등)
    --2025.04.08 김준규 SCP용 추가 시작
    --SCP_SITE_DESCRIPTION
    DECLARE @work_site_desc int = 0             -- 자체 제작 // PLANT+성격 (LGESMI Elec MI00,LGESMI Automotive Waranty MI00 등)
    DECLARE @work_cost_center int = 0   -- BKLAS
    --2025.04.08 김준규 SCP용 추가 종료
    DECLARE @work_purchase_group int = 0            -- EKGRP (구매그룹)

    DECLARE @element1  nvarchar(10) = ''
    DECLARE @element2  nvarchar(10) = ''
    DECLARE @element3  nvarchar(10) = ''
    DECLARE @element4  nvarchar(10) = ''


    if @p_sys_type = 'ALL'
    begin
        SET @work_company = 1
        SET @work_plant = 1
        SET @work_storage = 1
        SET @work_end_customer = 1
        SET @work_vendor = 1
        SET @work_biz_partner = 1
        SET @work_biz_area = 1
        SET @work_material_group = 1
        SET @work_indicator_GL = 1
        SET @work_profit_center = 1
        SET @work_movement_type = 1
        SET @work_distribute_channel = 1
        SET @work_sales_group = 1
        SET @work_sales_order_type = 1
        SET @work_incoterms = 1
        SET @work_routes = 1
        SET @work_document_type = 1
        SET @work_vat_code = 1
        SET @work_site = 1
        --2025.04.08 김준규 SCP용 추가 시작
        SET @work_site_desc = 1
        SET @work_cost_center = 1
        --2025.04.08 김준규 SCP용 추가 시작
        SET @work_purchase_group = 1
    end
    else if @p_sys_type= 'COMPANY' OR @p_sys_type= 'COMPANY_ID' OR @p_sys_type= 'BUKRS' begin
        SET @work_company = 1
    end
    else if @p_sys_type= 'PLANT' OR @p_sys_type= 'PLANT_ID' OR @p_sys_type= 'WERKS_D' begin
        SET @work_plant = 1
    end
    else if @p_sys_type= 'STORAGE' OR @p_sys_type= 'STORAGE_ID' OR @p_sys_type= 'LGORT' begin
        SET @work_storage = 1
    end
    else if @p_sys_type= 'CUSTOMER' OR @p_sys_type= 'END_CUSTOMER' OR @p_sys_type= 'KUNNR' begin
        SET @work_end_customer = 1
    end
    else if @p_sys_type= 'VENDOR' OR @p_sys_type= 'VENDOR_ID' OR @p_sys_type= 'LIFNR' begin
        SET @work_vendor = 1
    end
    else if @p_sys_type= 'BIZ' OR @p_sys_type= 'BIZ_PARTNER' OR @p_sys_type= 'PARTNER' begin
        SET @work_biz_partner = 1
    end
    else if @p_sys_type= 'BIZ_AREA' OR @p_sys_type= 'BUSINESS_AREA' OR @p_sys_type= 'GSBER' begin
        SET @work_biz_area = 1
    end
    else if @p_sys_type= 'MATERIAL' OR @p_sys_type= 'MATERIAL_GROUP' OR @p_sys_type= 'MATKL' begin
        SET @work_material_group = 1
    end
    else if @p_sys_type= 'INDICATOR' OR @p_sys_type= 'INDICATOR_GL' OR @p_sys_type= 'UMSKZ' begin
        SET @work_indicator_GL = 1
    end
    else if @p_sys_type= 'PROFIT' OR @p_sys_type= 'PROFIT_CENTER' OR @p_sys_type= 'PRCTR' begin
        SET @work_profit_center = 1
    end
    else if @p_sys_type= 'MOVEMENT' OR @p_sys_type= 'MOVEMENT_TYPE' OR @p_sys_type= 'BWART' begin
        SET @work_movement_type = 1
    end
    else if @p_sys_type= 'DISTRIBUTE' OR @p_sys_type= 'DISTRIBUTE_CHANNERL' OR @p_sys_type= 'VTWEG' begin
        SET @work_distribute_channel = 1
    end
    else if @p_sys_type= 'SALES_GROUP' OR @p_sys_type= 'VKGRP' begin
        SET @work_sales_group = 1
    end
    else if @p_sys_type= 'SALES_ORDER' OR @p_sys_type= 'SALES_ORDER_TYPE' OR @p_sys_type= 'AUART' begin
        SET @work_sales_order_type = 1
    end
    else if @p_sys_type= 'INCOTERMS' OR @p_sys_type= 'INCOTERMS' OR @p_sys_type= 'INCO1' begin
        SET @work_incoterms = 1
    end
    else if @p_sys_type= 'ROUTES' OR @p_sys_type= 'ROUTE' begin
        SET @work_routes = 1
    end
    else if @p_sys_type= 'DOCUMENT_TYPE' OR @p_sys_type= 'BLART' begin
        SET @work_document_type = 1
    end
    else if @p_sys_type= 'VAT_CODE' OR @p_sys_type= 'MWSKZ' begin
        SET @work_vat_code = 1
    end
    --2025.04.08 김준규 SCP용 추가 시작
    else if @p_sys_type= 'SCP_SITE' OR @p_sys_type= 'SCP_SITE_ID' OR @p_sys_type= 'SCP_SITE_ID'  begin
        SET @work_site = 1
    end
    else if @p_sys_type= 'SCP_SITE_DESC' OR @p_sys_type= 'SCP_SITE_DESCRIPTION' OR @p_sys_type= 'SCP_SITE_DESCRIPTION'  begin
        SET @work_site_desc = 1
    end
    else if @p_sys_type= 'BKLAS' OR @p_sys_type= 'BKLAS' OR @p_sys_type= 'BKLAS'  begin
        SET @work_cost_center = 1
    end
    --2025.04.08 김준규 SCP용 추가 종료
    else if @p_sys_type= 'PURCHASE' OR @p_sys_type= 'PURCHASE_ID' OR @p_sys_type= 'PURCHASE_GROUP_ID'  begin
        SET @work_purchase_group = 1
    end

    if @p_sys_gubun = 'DELETE' begin
        if @work_company = 1 begin
            DELETE FROM [NERP_CONV_MASTER]
            WHERE 1=1
            AND CODETYPE = 'COMPANY_ID'
        end
        if @work_plant = 1 begin
            DELETE FROM [NERP_CONV_MASTER]
            WHERE 1=1
            AND CODETYPE = 'PLANT_ID'
        end
        if @work_storage = 1 begin
            DELETE FROM [NERP_CONV_MASTER]
            WHERE 1=1
            AND CODETYPE = 'STORAGE_ID'
        end
        if @work_end_customer = 1 begin
            DELETE FROM [NERP_CONV_MASTER]
            WHERE 1=1
            AND CODETYPE = 'END_CUSTOMER_ID'
        end
        if @work_vendor = 1 begin
            DELETE FROM [NERP_CONV_MASTER]
            WHERE 1=1
            AND CODETYPE = 'VENDOR_ID'
        end
        if @work_biz_partner = 1 begin
            DELETE FROM [NERP_CONV_MASTER]
            WHERE 1=1
            AND CODETYPE = 'BIZ_PARTNER_ID'
        end
        if @work_biz_area = 1 begin
            DELETE FROM [NERP_CONV_MASTER]
            WHERE 1=1
            AND CODETYPE = 'BIZ_AREA_ID'
        end
        if @work_material_group = 1 begin
            DELETE FROM [NERP_CONV_MASTER]
            WHERE 1=1
            AND CODETYPE = 'MATERIAL_GROUP_ID'
        end
        if @work_indicator_GL = 1 begin
            DELETE FROM [NERP_CONV_MASTER]
            WHERE 1=1
            AND CODETYPE = 'INDICATOR_GL_ID'
        end
        if @work_profit_center = 1 begin
            DELETE FROM [NERP_CONV_MASTER]
            WHERE 1=1
            AND CODETYPE = 'PROFIT_CENTER_ID'
        end
        if @work_movement_type = 1 begin
            DELETE FROM [NERP_CONV_MASTER]
            WHERE 1=1
            AND CODETYPE = 'MOVEMENT_TYPE_ID'
        end
        if @work_distribute_channel = 1 begin
            DELETE FROM [NERP_CONV_MASTER]
            WHERE 1=1
            AND CODETYPE = 'DISTRIBUTE_CHANNERL_ID'
        end
        if @work_sales_group = 1 begin
            DELETE FROM [NERP_CONV_MASTER]
            WHERE 1=1
            AND CODETYPE = 'SALES_GROUP_ID'
        end
        if @work_sales_order_type = 1 begin
            DELETE FROM [NERP_CONV_MASTER]
            WHERE 1=1
            AND CODETYPE = 'SALES_ORDER_TYPE_ID'
        end
        if @work_incoterms = 1 begin
            DELETE FROM [NERP_CONV_MASTER]
            WHERE 1=1
            AND CODETYPE = 'INCOTERMS_ID'
        end
        if @work_routes = 1 begin
            DELETE FROM [NERP_CONV_MASTER]
            WHERE 1=1
            AND CODETYPE = 'ROUTE_ID'
        end
        if @work_document_type = 1 begin
            DELETE FROM [NERP_CONV_MASTER]
            WHERE 1=1
            AND CODETYPE = 'DOCUMENT_TYPE_ID'
        end
        if @work_vat_code = 1 begin
            DELETE FROM [NERP_CONV_MASTER]
            WHERE 1=1
            AND CODETYPE = 'VAT_CODE_ID'
        end
        --2025.04.08 김준규 SCP용 추가 시작
        if @work_site = 1 begin
            DELETE FROM [NERP_CONV_MASTER]
            WHERE 1=1
            AND CODETYPE = 'SCP_SITE_ID'
        end
        if @work_site = 1 begin
            DELETE FROM [NERP_CONV_MASTER]
            WHERE 1=1
            AND CODETYPE = 'SCP_SITE_DESCRIPTION'
        end
        if @work_cost_center = 1 begin
            DELETE FROM [NERP_CONV_MASTER]
            WHERE 1=1
            AND CODETYPE = 'BKLAS'
        end
        --2025.04.08 김준규 SCP용 추가 종료
        if @work_purchase_group = 1 begin
            DELETE FROM [NERP_CONV_MASTER]
            WHERE 1=1
            AND CODETYPE = 'PURCHASE_GROUP_ID'
        end
    end
    else if @p_sys_type= 'COMPANY' OR @p_sys_type= 'COMPANY_ID' OR @p_sys_type= 'BUKRS' begin
        SET @work_company = 1
    end
    else if @p_sys_type= 'PLANT' OR @p_sys_type= 'PLANT_ID' OR @p_sys_type= 'WERKS' begin
        SET @work_plant = 1
    end
    else if @p_sys_type= 'STORAGE' OR @p_sys_type= 'STORAGE_ID' OR @p_sys_type= 'LGORT' begin
        SET @work_storage = 1
    end
    else if @p_sys_type= 'CUSTOMER' OR @p_sys_type= 'END_CUSTOMER' OR @p_sys_type= 'KUNNR' begin
        SET @work_end_customer = 1
    end
    else if @p_sys_type= 'VENDOR' OR @p_sys_type= 'VENDOR_ID' OR @p_sys_type= 'LIFNR' begin
        SET @work_vendor = 1
    end
    else if @p_sys_type= 'BIZ' OR @p_sys_type= 'BIZ_PARTNER' OR @p_sys_type= 'PARTNER' begin
        SET @work_biz_partner = 1
    end
    else if @p_sys_type= 'BIZ_AREA' OR @p_sys_type= 'BUSINESS_AREA' OR @p_sys_type= 'GSBER' begin
        SET @work_biz_area = 1
    end
    else if @p_sys_type= 'MATERIAL' OR @p_sys_type= 'MATERIAL_GROUP' OR @p_sys_type= 'MATKL' begin
        SET @work_material_group = 1
    end
    else if @p_sys_type= 'INDICATOR' OR @p_sys_type= 'INDICATOR_GL' OR @p_sys_type= 'UMSKZ' begin
        SET @work_indicator_GL = 1
    end
    else if @p_sys_type= 'PROFIT' OR @p_sys_type= 'PROFIT_CENTER' OR @p_sys_type= 'PRCTR' begin
        SET @work_profit_center = 1
    end
    else if @p_sys_type= 'MOVEMENT' OR @p_sys_type= 'MOVEMENT_TYPE' OR @p_sys_type= 'BWART' begin
        SET @work_movement_type = 1
    end
    else if @p_sys_type= 'DISTRIBUTE' OR @p_sys_type= 'DISTRIBUTE_CHANNERL' OR @p_sys_type= 'VTWEG' begin
        SET @work_distribute_channel = 1
    end
    else if @p_sys_type= 'SALES_GROUP' OR @p_sys_type= 'VKGRP' begin
        SET @work_sales_group = 1
    end
    else if @p_sys_type= 'SALES_ORDER' OR @p_sys_type= 'SALES_ORDER_TYPE' OR @p_sys_type= 'AUART' begin
        SET @work_sales_order_type = 1
    end
    else if @p_sys_type= 'INCOTERMS' OR @p_sys_type= 'INCOTERMS' OR @p_sys_type= 'INCO1' begin
        SET @work_incoterms = 1
    end
    else if @p_sys_type= 'ROUTES' OR @p_sys_type= 'ROUTE' begin
        SET @work_routes = 1
    end
    else if @p_sys_type= 'DOCUMENT_TYPE' OR @p_sys_type= 'BLART' begin
        SET @work_document_type = 1
    end
    else if @p_sys_type= 'VAT_CODE' OR @p_sys_type= 'MWSKZ' begin
        SET @work_vat_code = 1
    end
    --2025.04.08 김준규 SCP용 추가 시작
    else if @p_sys_type= 'SCP_SITE' OR @p_sys_type= 'SCP_SITE_ID'  begin
        SET @work_site = 1
    end
    else if @p_sys_type= 'SCP_SITE_DESC' OR @p_sys_type= 'SCP_SITE_DESCRIPTION'  begin
        SET @work_site_desc = 1
    end
    else if @p_sys_type= 'BKLAS' OR @p_sys_type= 'BKLAS'  begin
        SET @work_cost_center = 1
    end
    --2025.04.08 김준규 SCP용 추가 종료
    else if @p_sys_type= 'PURCHASE_GROUP_ID' OR @p_sys_type= 'PURCHASE'  begin
        SET @work_purchase_group = 1
    END

    --2025.04.17 김준규 롤인차수 추가 시작
    if @p_sys_gubun = 'MERGE' OR @p_sys_gubun = 'UPSERT' begin
        if @work_company = 1 begin
            PRINT @work_company
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'MERGE','BUKRS','COMPANY_ID'
        end
        if @work_plant = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'MERGE', 'WERKS_D', 'PLANT_ID'
        end
        if @work_storage = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'MERGE', 'LGORT_D', 'STORAGE_ID'        -- element2
        end
        if @work_end_customer = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'MERGE', 'KUNNR', 'END_CUSTOMER_ID'
        end
        if @work_vendor = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'MERGE', 'LIFNR', 'VENDOR_ID'
        end
        if @work_biz_partner = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'MERGE', 'PARTNER', 'BIZ_PARTNER_ID'
        end
        if @work_biz_area = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'MERGE', 'GSBER', 'BIZ_AREA_ID'
        end
        if @work_material_group = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'MERGE', 'MATKL', 'MATERIAL_GROUP_ID'
        end
        if @work_indicator_GL = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'MERGE', 'UMSKZ', 'INDICATOR_GL_ID'         -- element2
        end
        if @work_profit_center = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'MERGE', 'PRCTR', 'PROFIT_CENTER_ID'
        end
        if @work_movement_type = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'MERGE', 'BWART', 'MOVEMENT_TYPE_ID'
        end
        if @work_distribute_channel = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'MERGE', 'VTWEG', 'DISTRIBUTE_CHANNERL_ID'          -- element2
        end
        if @work_sales_group = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'MERGE', 'VKGRP', 'SALES_GROUP_ID'
        end
        if @work_sales_order_type = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'MERGE', 'AUART', 'SALES_ORDER_TYPE_ID'
        end
        if @work_incoterms = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'MERGE', 'INCO1', 'INCOTERMS_ID'
        end
        if @work_routes = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'MERGE', 'ROUTE', 'ROUTE_ID'
        end
        if @work_document_type = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'MERGE', 'BLART', 'DOCUMENT_TYPE_ID'
        end
        if @work_vat_code = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'MERGE', 'MWSKZ', 'VAT_CODE_ID'
        end
        --2025.04.08 김준규 SCP용 추가 시작
        if @work_site = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'MERGE', 'SCP_SITE_ID', 'SCP_SITE_ID'
        end
        if @work_site_desc = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'MERGE', 'SCP_SITE_DESCRIPTION', 'SCP_SITE_DESCRIPTION'
        end
        if @work_cost_center = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'MERGE', 'BKLAS', 'BKLAS'
        END
        --2025.04.08 김준규 SCP용 추가 종료
        if @work_purchase_group = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'MERGE', 'EKGRP', 'PURCHASE_GROUP_ID'
        end

    end
    if @p_sys_gubun = 'INSERT' begin
        if @work_company = 1 begin
            PRINT @work_company
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'INSERT','BUKRS','COMPANY_ID'
        end
        if @work_plant = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'INSERT', 'WERKS_D', 'PLANT_ID'
        end
        if @work_storage = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'INSERT', 'LGORT_D', 'STORAGE_ID'       -- element2
        end
        if @work_end_customer = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'INSERT', 'KUNNR', 'END_CUSTOMER_ID'
        end
        if @work_vendor = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'INSERT', 'LIFNR', 'VENDOR_ID'
        end
        if @work_biz_partner = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'INSERT', 'PARTNER', 'BIZ_PARTNER_ID'
        end
        if @work_biz_area = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'INSERT', 'GSBER', 'BIZ_AREA_ID'
        end
        if @work_material_group = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'INSERT', 'MATKL', 'MATERIAL_GROUP_ID'
        end
        if @work_indicator_GL = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'INSERT', 'UMSKZ', 'INDICATOR_GL_ID'            -- element2
        end
        if @work_profit_center = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'INSERT', 'PRCTR', 'PROFIT_CENTER_ID'
        end
        if @work_movement_type = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'INSERT', 'BWART', 'MOVEMENT_TYPE_ID'
        end
        if @work_distribute_channel = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'INSERT', 'VTWEG', 'DISTRIBUTE_CHANNERL_ID'         -- element2
        end
        if @work_sales_group = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'INSERT', 'VKGRP', 'SALES_GROUP_ID'
        end
        if @work_sales_order_type = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'INSERT', 'AUART', 'SALES_ORDER_TYPE_ID'
        end
        if @work_incoterms = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'INSERT', 'INCO1', 'INCOTERMS_ID'
        end
        if @work_routes = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'INSERT', 'ROUTE', 'ROUTE_ID'
        end
        if @work_document_type = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'INSERT', 'BLART', 'DOCUMENT_TYPE_ID'
        end
        if @work_vat_code = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'INSERT', 'MWSKZ', 'VAT_CODE_ID'
        end
        --2025.04.08 김준규 SCP용 추가 시작
        if @work_site = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'INSERT', 'SCP_SITE_ID', 'SCP_SITE_ID'
        end
        if @work_site_desc = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'INSERT', 'SCP_SITE_DESCRIPTION', 'SCP_SITE_DESCRIPTION'
        end
        if @work_cost_center = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'INSERT', 'BKLAS', 'BKLAS'
        END
        --2025.04.08 김준규 SCP용 추가 종료
        if @work_purchase_group = 1 begin
            exec PR_NERP_XLS_TOBE_CONVERTER_SUB @p_rollin, 'INSERT', 'EKGRP', 'PURCHASE_GROUP_ID'
        end
        --2025.04.17 김준규 롤인차수 추가 종료
        /*
        if @work_site = 1 begin

            select distinct  SCM_SITE_ID, plant_id
                  , CASE WHEN PLANT_ID IS NOT NULL THEN 0
                         WHEN LEN(LEFT(SCM_SITE_ID, CHARINDEX('_', SCM_SITE_ID) )) > 0 THEN LEN(LEFT(SCM_SITE_ID, CHARINDEX('_', SCM_SITE_ID) )) -1
                         WHEN LEN(LEFT(SCM_SITE_ID, CHARINDEX('-', SCM_SITE_ID) )) > 0 THEN LEN(LEFT(SCM_SITE_ID, CHARINDEX('-', SCM_SITE_ID) )) -1
                    END as CONV_CODE_LEN
            INTO    #TMP_SITE_MAPPING_DATA
            from    [DBO].SCM_MST_SITE A with(nolock)
            where  1=1
            and  ( ISNUMERIC(SUBSTRING(scm_site_id, 2, 3)) = 1
               or  ISNUMERIC(SUBSTRING(scm_site_id, 3, 4)) = 1 )
            ORDER BY 1

            insert into NERP_CONV_MASTER
            select 'SITE_ID' as CODETYPE
                 , S.SCM_SITE_ID as OLD_VALUE1
                 , c.OLD_VALUE2
                 , c.OLD_VALUE3
                 , c.OLD_VALUE4
                 , replace( scm_site_id, OLD_VALUE1, NEW_VALUE1) as NEW_VALUE1
                 , c.NEW_VALUE2
                 , c.NEW_VALUE3
                 , c.NEW_VALUE4
                 , C.ELEMENT1
                 , C.ELEMENT2
                 , c.ELEMENT3
                 , c.ELEMENT4
                 , c.DESC1
                 , c.DESC2
                 , c.DESC3
                 , c.DESC4
                 , c.COMMENT1
                 , c.COMMENT2
                 , c.COMMENT3
                 , c.COMMENT4
                 , c.COMMENT5
                 , c.COMMENT6
                 , c.COMMENT7
                 , c.ACTIVE_FLAG
                 , c.ATTRIBUTE1
                 , c.ATTRIBUTE2
                 , c.ATTRIBUTE3
                 , c.ATTRIBUTE4
                 , c.ATTRIBUTE5
                 , 'TOBE_CONVERTER' as INSERT_ID
                 , getdate() as INSERT_DATE
                 , 'TOBE_CONVERTER' as UPDATE_ID
                 , getdate() as UPDATE_DATE
            from   #TMP_SITE_MAPPING_DATA S with(nolock)
            inner join NERP_CONV_MASTER C with(nolock)
            ON    iif(plant_id is null, LEFT(SCM_SITE_ID, CONV_CODE_LEN),plant_id)   = c.OLD_VALUE1
            where 1=1
--          and  C.CODETYPE IN ('PLANT_ID', 'END_CUSTOMER_ID')
            and  C.CODETYPE IN ('PLANT_ID', 'VENDOR_ID')        -- 공급업자로 변환
            ;

select * from #TMP_SITE_MAPPING_DATA

        end
        if @work_incoterms = 1 begin


            --국내-----------------------------

            select 'Z01' as OLD_VALUE1
                 , 'D' as OLD_VALUE2
                 , 'EXW' as NEW_VALUE1
                 , 'D' as NEW_VALUE2
            into #tmp_incoterms_mapping

            insert into #tmp_incoterms_mapping
            select 'Z02' as OLD_VALUE1
                 , 'D' as OLD_VALUE2
                 , 'DAP' as NEW_VALUE1
                 , 'D' as NEW_VALUE2

            insert into #tmp_incoterms_mapping
            select 'A01' as OLD_VALUE1
                 , 'D' as OLD_VALUE2
                 , 'DAP' as NEW_VALUE1
                 , 'D' as NEW_VALUE2

            insert into #tmp_incoterms_mapping
            select 'A02' as OLD_VALUE1
                 , 'D' as OLD_VALUE2
                 , 'EXW' as NEW_VALUE1
                 , 'D' as NEW_VALUE2

            insert into #tmp_incoterms_mapping
            select 'FAC' as OLD_VALUE1
                 , 'D' as OLD_VALUE2
                 , 'DAP' as NEW_VALUE1
                 , 'D' as NEW_VALUE2

            insert into #tmp_incoterms_mapping
            select 'ZS3' as OLD_VALUE1
                 , 'D' as OLD_VALUE2
                 , 'DAP' as NEW_VALUE1
                 , 'D' as NEW_VALUE2

            --해외-----------------------------


            insert into #tmp_incoterms_mapping
            select 'Z01' as OLD_VALUE1
                 , 'E' as OLD_VALUE2
                 , 'DAP' as NEW_VALUE1
                 , 'E' as NEW_VALUE2

            insert into #tmp_incoterms_mapping
            select 'Z02' as OLD_VALUE1
                 , 'E' as OLD_VALUE2
                 , 'EXW' as NEW_VALUE1
                 , 'E' as NEW_VALUE2

            insert into #tmp_incoterms_mapping
            select 'S32' as OLD_VALUE1
                 , 'E' as OLD_VALUE2
                 , 'EXW' as NEW_VALUE1
                 , 'E' as NEW_VALUE2

            insert into #tmp_incoterms_mapping
            select 'S33' as OLD_VALUE1
                 , 'E' as OLD_VALUE2
                 , 'EXW' as NEW_VALUE1
                 , 'E' as NEW_VALUE2

            insert into #tmp_incoterms_mapping
            select 'Z03' as OLD_VALUE1
                 , 'E' as OLD_VALUE2
                 , 'DAP' as NEW_VALUE1
                 , 'E' as NEW_VALUE2

            insert into #tmp_incoterms_mapping
            select 'Z04' as OLD_VALUE1
                 , 'E' as OLD_VALUE2
                 , 'DAP' as NEW_VALUE1
                 , 'E' as NEW_VALUE2

            --국내/해외 교차------------------------------------------- 20240417

            insert into #tmp_incoterms_mapping
            select 'A01' as OLD_VALUE1
                 , 'E' as OLD_VALUE2
                 , 'DAP' as NEW_VALUE1
                 , 'E' as NEW_VALUE2

            insert into #tmp_incoterms_mapping
            select 'A02' as OLD_VALUE1
                 , 'E' as OLD_VALUE2
                 , 'EXW' as NEW_VALUE1
                 , 'E' as NEW_VALUE2

            insert into #tmp_incoterms_mapping
            select 'FAC' as OLD_VALUE1
                 , 'E' as OLD_VALUE2
                 , 'DAP' as NEW_VALUE1
                 , 'E' as NEW_VALUE2

            insert into #tmp_incoterms_mapping
            select 'ZS3' as OLD_VALUE1
                 , 'E' as OLD_VALUE2
                 , 'DAP' as NEW_VALUE1
                 , 'E' as NEW_VALUE2


            insert into #tmp_incoterms_mapping
            select 'S32' as OLD_VALUE1
                 , 'D' as OLD_VALUE2
                 , 'EXW' as NEW_VALUE1
                 , 'D' as NEW_VALUE2

            insert into #tmp_incoterms_mapping
            select 'S33' as OLD_VALUE1
                 , 'D' as OLD_VALUE2
                 , 'EXW' as NEW_VALUE1
                 , 'D' as NEW_VALUE2

            insert into #tmp_incoterms_mapping
            select 'Z03' as OLD_VALUE1
                 , 'D' as OLD_VALUE2
                 , 'DAP' as NEW_VALUE1
                 , 'D' as NEW_VALUE2

            insert into #tmp_incoterms_mapping
            select 'Z04' as OLD_VALUE1
                 , 'D' as OLD_VALUE2
                 , 'DAP' as NEW_VALUE1
                 , 'D' as NEW_VALUE2



            insert into #tmp_incoterms_mapping
            select 'DDU' as OLD_VALUE1
                 , 'D' as OLD_VALUE2
                 , 'DAP' as NEW_VALUE1
                 , 'D' as NEW_VALUE2

            insert into #tmp_incoterms_mapping
            select 'DAT' as OLD_VALUE1
                 , 'D' as OLD_VALUE2
                 , 'DPU' as NEW_VALUE1
                 , 'D' as NEW_VALUE2


            insert into #tmp_incoterms_mapping
            select 'DDU' as OLD_VALUE1
                 , 'E' as OLD_VALUE2
                 , 'DAP' as NEW_VALUE1
                 , 'E' as NEW_VALUE2

            insert into #tmp_incoterms_mapping
            select 'DAT' as OLD_VALUE1
                 , 'E' as OLD_VALUE2
                 , 'DPU' as NEW_VALUE1
                 , 'E' as NEW_VALUE2



            insert into NERP_CONV_MASTER
            select 'INCOTERMS_ID' as CODETYPE
                 , OLD_VALUE1
                 , OLD_VALUE2
                 , '' as OLD_VALUE3
                 , '' as OLD_VALUE4
                 , NEW_VALUE1 as NEW_VALUE1
                 , NEW_VALUE2 as NEW_VALUE2
                 , '' as NEW_VALUE3
                 , '' as NEW_VALUE4
                 , '' as ELEMENT1
                 , '' as ELEMENT2
                 , '' as ELEMENT3
                 , '' as ELEMENT4
                 , '' as DESC1
                 , '' as DESC2
                 , '' as DESC3
                 , '' as DESC4
                 , '' as COMMENT1
                 , '' as COMMENT2
                 , '' as COMMENT3
                 , '' as COMMENT4
                 , '' as COMMENT5
                 , '' as COMMENT6
                 , '' as COMMENT7
                 , '' as ACTIVE_FLAG
                 , '' as ATTRIBUTE1
                 , '' as ATTRIBUTE2
                 , '' as ATTRIBUTE3
                 , '' as ATTRIBUTE4
                 , '' as ATTRIBUTE5
                 , 'TOBE_CONVERTER' as INSERT_ID
                 , getdate() as INSERT_DATE
                 , 'TOBE_CONVERTER' as UPDATE_ID
                 , getdate() as UPDATE_DATE
            from   #tmp_incoterms_mapping  with(nolock)

             ;

        end

        */
        /*
        if @work_site = 1 begin

            insert into [NERP_CONV_MASTER]
                       ([CODETYPE]
                        ,[OLD_VALUE1],[OLD_VALUE2],[OLD_VALUE3],[OLD_VALUE4]
                        ,[NEW_VALUE1],[NEW_VALUE2],[NEW_VALUE3],[NEW_VALUE4]
                        ,[ELEMENT1],[ELEMENT2],[ELEMENT3],[ELEMENT4]
                        ,[DESC1],[DESC2],[DESC3],[DESC4]
                        ,ETC1,ETC2,ETC3,ETC4,ETC5,ETC6,[COMMENT7]
                        ,[ACTIVE_FLAG]
                        ,[ATTRIBUTE1],[ATTRIBUTE2],[ATTRIBUTE3],[ATTRIBUTE4],[ATTRIBUTE5]
                        ,[INSERT_ID]
                        ,[INSERT_DATE]
                        ,[UPDATE_ID]
                        ,[UPDATE_DATE])
            select
            'SITE_ID' AS CODETYPE

                        ,SCM_SITE_ID, '', '', ''
                        ,NEW_SCM_SITE_ID, '', '', ''
                        ,ROLL01 AS [ELEMENT1],ROLL02 AS [ELEMENT2],ROLL03 AS [ELEMENT3],ROLL04 AS [ELEMENT4]
                        ,DESC01 AS [DESC1] ,DESC02 AS [DESC2],DESC03 AS [DESC3],DESC04 AS [DESC4]
                        ,ETC1 AS ETC1,ETC2 AS ETC2,ETC3 AS ETC3,ETC4 AS ETC4 ,ETC5 AS ETC5,ETC6 AS ETC6
                        ,'' AS [COMMENT7]
                        ,'Y' AS [ACTIVE_FLAG]
                        ,'-' AS [ATTRIBUTE1],'-' AS [ATTRIBUTE2],'-' AS [ATTRIBUTE3] ,'-' AS [ATTRIBUTE4],'-' AS [ATTRIBUTE5]
                        ,'XLSCONVERTER' AS [INSERT_ID] ,GetDate() AS [INSERT_DATE] ,'XLSCONVERTER' AS [UPDATE_ID] ,GetDate() AS [UPDATE_DATE]
          from (
                  SELECT  A.DIVISION_ID, A.SCM_SITE_ID, A.PLANT_ID, A.OPERATION_GROUP, A.COMPANY_ID, A.SITE_ID
                        , B.CODE_OLD_01, B.CODE_NEW_01
                        , ISNULL(REPLACE (A.SCM_SITE_ID, B.CODE_OLD_01, B.CODE_NEW_01), A.SCM_SITE_ID) AS NEW_SCM_SITE_ID
                        , B.ROLL01,B.ROLL02,B.ROLL03,B.ROLL04
                        , B.DESC01,B.DESC02,B.DESC03,B.DESC04
                        , B.ETC1,B.ETC2,B.ETC3,B.ETC4,B.ETC5,B.ETC6,B.[COMMENT]
                  FROM SCM_MST_SITE A WITH(NOLOCK)
                  LEFT OUTER JOIN ZNERP_TOBE_CODE_INFO_SN B WITH(NOLOCK)
                  ON    B.CODEMAPID IN ('ZMDBP005', 'ZPPCM001')
                  AND   B.ROLL01 IN ('LIFNR', 'WERKS_D')
                  AND   B.ETC6 = N'매핑확정'
                  WHERE A.PLANT_ID = B.CODE_OLD_01
                  AND   A.SITE_TYPE = 'PLANT'
              ) A
        end*/
    end
    /*
    -- OC FP ATTRIBUTE1 ==> 데이터 추가
    UPDATE [NERP_CONV_MASTER]
    SET ATTRIBUTE1 = CASE WHEN SUBSTRING(OLD_VALUE1, 1,1) = 'A' THEN 'A001'
                          WHEN SUBSTRING(OLD_VALUE1, 1,1) = 'F' THEN 'A001'
                          WHEN SUBSTRING(OLD_VALUE1, 1,2) = 'G4' THEN 'A004'
                          WHEN SUBSTRING(OLD_VALUE1, 1,2) = 'G5' THEN 'A005'
                     END
    WHERE CODETYPE IN ('PLANT_ID','STORAGE_ID');

    UPDATE [NERP_CONV_MASTER]
    SET ATTRIBUTE1 = CASE WHEN OLD_VALUE1 = 'C100' THEN 'A001'
                          WHEN (OLD_VALUE1 = 'G180' OR OLD_VALUE1 = 'G450' OR OLD_VALUE1 = 'G630' ) THEN 'A002'
                          WHEN (OLD_VALUE1 = 'G380' OR OLD_VALUE1 = 'G670' ) THEN 'A003'
                          WHEN (OLD_VALUE1 = 'G480' OR OLD_VALUE1 = 'G670' ) THEN 'A004'
                          WHEN OLD_VALUE1 = 'G690'  THEN 'A005'
                          WHEN OLD_VALUE1 = 'G540'  THEN 'A006'
                          WHEN OLD_VALUE1 = 'G740'  THEN 'A007'
                          WHEN OLD_VALUE1 = 'G890'  THEN 'A008'
                          WHEN OLD_VALUE1 = 'G820'  THEN 'A009'
                     END
    WHERE CODETYPE IN ('COMPANY_ID');
    */

    --2025.04.08 김준규 SCP용 추가 시작
    --2025.05.25 김준규 백업테이블로 이름변경하고 운영이관시 개발과 운영에서 동시에 사용가능하도록 함 변경 시작
    --2025.10.14 김준규 3차 오펀시 백업데이터는 QA 및 운영에 통일 테이블 명(BACKUP_NERP_CONV_MASTER_PROD_251010)으로
    --                  동일하게 데이터 존재해서 프로그램 수정함(운영이관시 즉시 변경없이 사용가능)
    if @p_sys_type = 'ALL' BEGIN
        DECLARE @sql nvarchar(max) = ''
        SET @sql = N'
        begin
            DELETE FROM DBO.[NERP_CONV_MASTER]
            WHERE ATTRIBUTE5 <= ''4TH'';
            INSERT INTO DBO.[NERP_CONV_MASTER]
            (
                CODETYPE
               ,OLD_VALUE1
               ,OLD_VALUE2
               ,OLD_VALUE3
               ,OLD_VALUE4
               ,NEW_VALUE1
               ,NEW_VALUE2
               ,NEW_VALUE3
               ,NEW_VALUE4
               ,ELEMENT1
               ,ELEMENT2
               ,ELEMENT3
               ,ELEMENT4
               ,DESC1
               ,DESC2
               ,DESC3
               ,DESC4
               ,COMMENT1
               ,COMMENT2
               ,COMMENT3
               ,COMMENT4
               ,COMMENT5
               ,COMMENT6
               ,COMMENT7
               ,ACTIVE_FLAG
               ,ATTRIBUTE1
               ,ATTRIBUTE2
               ,ATTRIBUTE3
               ,ATTRIBUTE4
               ,ATTRIBUTE5
               ,INSERT_ID
               ,INSERT_DATE
               ,UPDATE_ID
               ,UPDATE_DATE
            )
            SELECT CODETYPE
               ,OLD_VALUE1
               ,OLD_VALUE2
               ,OLD_VALUE3
               ,OLD_VALUE4
               ,NEW_VALUE1
               ,NEW_VALUE2
               ,NEW_VALUE3
               ,NEW_VALUE4
               ,ELEMENT1
               ,ELEMENT2
               ,ELEMENT3
               ,ELEMENT4
               ,DESC1
               ,DESC2
               ,DESC3
               ,DESC4
               ,COMMENT1
               ,COMMENT2
               ,COMMENT3
               ,COMMENT4
               ,COMMENT5
               ,COMMENT6
               ,COMMENT7
               ,ACTIVE_FLAG
               ,ATTRIBUTE1
               ,ATTRIBUTE2
               ,ATTRIBUTE3
               ,ATTRIBUTE4
               ,ATTRIBUTE5
               ,INSERT_ID
               ,INSERT_DATE
               ,UPDATE_ID
               ,UPDATE_DATE
            FROM [BACKUP_NERP_CONV_MASTER_PROD_251204] WHERE ATTRIBUTE5 <= ''4TH'';
        end;';
        EXEC sp_executesql @sql;
    END
    --2025.05.25 김준규 백업테이블로 이름변경하고 운영이관시 개발과 운영에서 동시에 사용가능하도록 함 변경 종료
    --2025.04.08 김준규 SCP용 추가 종료

    --2025.09.11 김준규 DM용 CURRENCY RMB TO CNY 변경 추가 시작
    IF @P_ROLLIN = '3RD'

        BEGIN

        DELETE NERP_CONV_MASTER
        WHERE CODETYPE = 'CURRENCY_ID'
        AND   OLD_VALUE1 = 'RMB'
        AND   NEW_VALUE1 = 'CNY'
        AND   ATTRIBUTE5 = '3RD';

        INSERT INTO NERP_CONV_MASTER
        (
            CODETYPE
           ,OLD_VALUE1
           ,OLD_VALUE2
           ,OLD_VALUE3
           ,OLD_VALUE4
           ,NEW_VALUE1
           ,NEW_VALUE2
           ,NEW_VALUE3
           ,NEW_VALUE4
           ,ELEMENT1
           ,ELEMENT2
           ,ELEMENT3
           ,ELEMENT4
           ,DESC1
           ,DESC2
           ,DESC3
           ,DESC4
           ,COMMENT1
           ,COMMENT2
           ,COMMENT3
           ,COMMENT4
           ,COMMENT5
           ,COMMENT6
           ,COMMENT7
           ,ACTIVE_FLAG
           ,ATTRIBUTE1
           ,ATTRIBUTE2
           ,ATTRIBUTE3
           ,ATTRIBUTE4
           ,ATTRIBUTE5
           ,INSERT_ID
           ,INSERT_DATE
           ,UPDATE_ID
           ,UPDATE_DATE
        )
        SELECT 'CURRENCY_ID' AS CODETYPE
              ,NCM.OLD_VALUE1
              ,NCM.OLD_VALUE2
              ,NCM.OLD_VALUE3
              ,NCM.OLD_VALUE4
              ,NCM.NEW_VALUE1
              ,NCM.NEW_VALUE2
              ,NCM.NEW_VALUE3
              ,NCM.NEW_VALUE4
              ,NCM.ELEMENT1
              ,NCM.ELEMENT2
              ,NCM.ELEMENT3
              ,NCM.ELEMENT4
              ,NCM.DESC1
              ,NCM.DESC2
              ,NCM.DESC3
              ,'' AS DESC4
              ,NCM.COMMENT1
              ,NCM.COMMENT2
              ,NCM.COMMENT3
              ,NCM.COMMENT4
              ,NCM.COMMENT5
              ,NCM.DESC4 AS COMMENT6
              ,'THIS IS FROM 1ST OF WAERS CODETYPE' AS COMMENT7
              ,NCM.ACTIVE_FLAG
              ,NCM.ATTRIBUTE1
              ,NCM.ATTRIBUTE2
              ,NCM.ATTRIBUTE3
              ,NCM.ATTRIBUTE4
              ,'3RD' AS ATTRIBUTE5
              ,NCM.INSERT_ID
              ,NCM.INSERT_DATE
              ,@CREATED_BY AS UPDATE_ID
              ,GETDATE() AS UPDATE_DATE
        FROM   NERP_CONV_MASTER NCM WITH(NOLOCK)
        WHERE  NCM.CODETYPE = 'WAERS'
        AND    NCM.OLD_VALUE1 = 'RMB'
        AND    NCM.NEW_VALUE1 = 'CNY'
        AND    NCM.ATTRIBUTE5 = '1ST'
    END;
    --2025.09.11 김준규 DM용 CURRENCY RMB TO CNY 변경 추가 종료

    --2025.11.14 김준규 DM용 G670,G671 PLANT_ID,SCP_SITE_ID 강제 수작업 추가 시작
    IF @P_ROLLIN IN ( '4TH','5TH' )
    BEGIN

        INSERT INTO NERP_CONV_MASTER
        (
            CODETYPE
           ,OLD_VALUE1
           ,OLD_VALUE2
           ,OLD_VALUE3
           ,OLD_VALUE4
           ,NEW_VALUE1
           ,NEW_VALUE2
           ,NEW_VALUE3
           ,NEW_VALUE4
           ,ELEMENT1
           ,ELEMENT2
           ,ELEMENT3
           ,ELEMENT4
           ,DESC1
           ,DESC2
           ,DESC3
           ,DESC4
           ,COMMENT1
           ,COMMENT2
           ,COMMENT3
           ,COMMENT4
           ,COMMENT5
           ,COMMENT6
           ,COMMENT7
           ,ACTIVE_FLAG
           ,ATTRIBUTE1
           ,ATTRIBUTE2
           ,ATTRIBUTE3
           ,ATTRIBUTE4
           ,ATTRIBUTE5
           ,INSERT_ID
           ,INSERT_DATE
           ,UPDATE_ID
           ,UPDATE_DATE
        )
        SELECT
            X.CODETYPE
           ,X.OLD_VALUE1
           ,X.OLD_VALUE2
           ,X.OLD_VALUE3
           ,X.OLD_VALUE4
           ,X.NEW_VALUE1
           ,X.NEW_VALUE2
           ,X.NEW_VALUE3
           ,X.NEW_VALUE4
           ,X.ELEMENT1
           ,X.ELEMENT2
           ,X.ELEMENT3
           ,X.ELEMENT4
           --,DESC1=(CASE WHEN ISNULL(NRV.DESC1,'') = '' THEN MCV.DESC1 ELSE NRV.DESC1 END)
           ,DESC1=(CASE WHEN ISNULL(NRV1.DESC1,'') <> '' THEN NRV1.DESC1
                        WHEN ISNULL(NRV2.DESC1,'') <> '' THEN NRV2.DESC1
                        WHEN ISNULL(MCV1.DESC1,'') <> '' THEN MCV1.DESC1
                        WHEN ISNULL(MCV2.DESC1,'') <> '' THEN MCV2.DESC1 ELSE X.DESC1 END)
           ,X.DESC2
           ,X.DESC3
           ,X.DESC4
           ,X.COMMENT1
           ,X.COMMENT2
           ,X.COMMENT3
           ,X.COMMENT4
           ,X.COMMENT5
           ,X.COMMENT6
           ,X.COMMENT7
           ,X.ACTIVE_FLAG
           ,X.ATTRIBUTE1
           ,X.ATTRIBUTE2
           ,X.ATTRIBUTE3
           ,X.ATTRIBUTE4
           ,X.ATTRIBUTE5
           ,X.INSERT_ID
           ,X.INSERT_DATE
           ,X.UPDATE_ID
           ,X.UPDATE_DATE
        FROM (
            --SCP_SITE_ID 공장 스타일 값 수작업 강제 추가
            SELECT  NCM.CODETYPE
                   ,CASE WHEN CPT.number = 1 THEN 'G670-A' WHEN CPT.number = 2 THEN 'G690-A' WHEN CPT.number = 3 THEN 'G690-P' END AS OLD_VALUE1
                   ,NCM.OLD_VALUE2
                   ,NCM.OLD_VALUE3
                   ,NCM.OLD_VALUE4
                   ,CASE WHEN CPT.number = 1 THEN 'GM00-A' WHEN CPT.number = 2 THEN 'EG00-A'  WHEN CPT.number = 3 THEN 'EG00-P' END AS NEW_VALUE1
                   ,NCM.NEW_VALUE2
                   ,NCM.NEW_VALUE3
                   ,NCM.NEW_VALUE4
                   ,NCM.ELEMENT1
                   ,NCM.ELEMENT2
                   ,NCM.ELEMENT3
                   ,NCM.ELEMENT4
                   ,NCM.DESC1
                   ,NCM.DESC2
                   ,NCM.DESC3
                   ,NCM.DESC4
                   ,N'수작업강제입력 BASE ON G671-A' AS COMMENT1
                   ,NCM.COMMENT2
                   ,NCM.COMMENT3
                   ,NCM.COMMENT4
                   ,NCM.COMMENT5
                   ,NCM.COMMENT6
                   ,NCM.COMMENT7
                   ,NCM.ACTIVE_FLAG
                   ,NCM.ATTRIBUTE1
                   ,NCM.ATTRIBUTE2
                   ,NCM.ATTRIBUTE3
                   ,NCM.ATTRIBUTE4
                   ,NCM.ATTRIBUTE5
                   ,NCM.INSERT_ID
                   ,NCM.INSERT_DATE
                   ,NCM.UPDATE_ID
                   ,NCM.UPDATE_DATE
            FROM   NERP_CONV_MASTER NCM WITH(NOLOCK)
            JOIN   (SELECT number FROM master.dbo.spt_values WHERE type = 'P' AND number BETWEEN 1 AND 3) CPT ON 1=1
            WHERE  NCM.ATTRIBUTE5 = '5TH'
            AND    NCM.CODETYPE = 'SCP_SITE_ID'
            AND    OLD_VALUE1 = 'G671-A'
            UNION
            --SCP_SITE_ID 회사 스타일 값 수작업 강제 추가
            SELECT  NCM.CODETYPE
                   ,'G671' AS OLD_VALUE1
                   ,NCM.OLD_VALUE2
                   ,NCM.OLD_VALUE3
                   ,NCM.OLD_VALUE4
                   ,'GM00' AS NEW_VALUE1
                   ,NCM.NEW_VALUE2
                   ,NCM.NEW_VALUE3
                   ,NCM.NEW_VALUE4
                   ,NCM.ELEMENT1
                   ,NCM.ELEMENT2
                   ,NCM.ELEMENT3
                   ,NCM.ELEMENT4
                   ,NCM.DESC1
                   ,NCM.DESC2
                   ,NCM.DESC3
                   ,NCM.DESC4
                   ,N'수작업강제입력 BASE ON G690' AS COMMENT1
                   ,NCM.COMMENT2
                   ,NCM.COMMENT3
                   ,NCM.COMMENT4
                   ,NCM.COMMENT5
                   ,NCM.COMMENT6
                   ,NCM.COMMENT7
                   ,NCM.ACTIVE_FLAG
                   ,NCM.ATTRIBUTE1
                   ,NCM.ATTRIBUTE2
                   ,NCM.ATTRIBUTE3
                   ,NCM.ATTRIBUTE4
                   ,NCM.ATTRIBUTE5
                   ,NCM.INSERT_ID
                   ,NCM.INSERT_DATE
                   ,NCM.UPDATE_ID
                   ,NCM.UPDATE_DATE
            FROM   NERP_CONV_MASTER NCM WITH(NOLOCK)
            WHERE  NCM.ATTRIBUTE5 = '5TH'
            AND    NCM.CODETYPE = 'SCP_SITE_ID'
            AND    NCM.OLD_VALUE1 = 'G690'
            UNION
            --PLANT_ID 공장 스타일 수작업 강제 추가
            --PLANT_ID 회사 스티일 없음
            SELECT  NCM.CODETYPE
                   ,CASE WHEN CPT.number = 1 THEN 'G670-A' WHEN CPT.number = 2 THEN 'G671-A' WHEN CPT.number = 3 THEN 'G673-A' WHEN CPT.number = 4 THEN 'G690-A' WHEN CPT.number = 5 THEN 'G690-P' END AS OLD_VALUE1
                   ,NCM.OLD_VALUE2
                   ,NCM.OLD_VALUE3
                   ,NCM.OLD_VALUE4
                   ,CASE WHEN CPT.number = 1 THEN 'GM00-A' WHEN CPT.number = 2 THEN 'GM00-A' WHEN CPT.number = 3 THEN 'GM01-A' WHEN CPT.number = 4 THEN 'EG00-A' WHEN CPT.number = 5 THEN 'EG00-P' END AS NEW_VALUE1
                   ,NCM.NEW_VALUE2
                   ,NCM.NEW_VALUE3
                   ,NCM.NEW_VALUE4
                   ,NCM.ELEMENT1
                   ,NCM.ELEMENT2
                   ,NCM.ELEMENT3
                   ,NCM.ELEMENT4
                   ,NCM.DESC1
                   ,NCM.DESC2
                   ,NCM.DESC3
                   ,NCM.DESC4
                   ,N'수작업강제입력 BASE ON G671' AS COMMENT1
                   ,NCM.COMMENT2
                   ,NCM.COMMENT3
                   ,NCM.COMMENT4
                   ,NCM.COMMENT5
                   ,NCM.COMMENT6
                   ,NCM.COMMENT7
                   ,NCM.ACTIVE_FLAG
                   ,NCM.ATTRIBUTE1
                   ,NCM.ATTRIBUTE2
                   ,NCM.ATTRIBUTE3
                   ,NCM.ATTRIBUTE4
                   ,NCM.ATTRIBUTE5
                   ,NCM.INSERT_ID
                   ,NCM.INSERT_DATE
                   ,NCM.UPDATE_ID
                   ,NCM.UPDATE_DATE
            FROM   NERP_CONV_MASTER NCM WITH(NOLOCK)
            JOIN   (SELECT number FROM master.dbo.spt_values WHERE type = 'P' AND number BETWEEN 1 AND 5) CPT ON 1=1
            WHERE  NCM.ATTRIBUTE5 = '5TH'
            AND    NCM.CODETYPE = 'PLANT_ID'
            AND    OLD_VALUE1 = 'G671'
        ) X
        LEFT JOIN NERP_CONV_OLD_NEW_REF_V NRV1 WITH(NOLOCK)
            ON NRV1.ATTRIBUTE5='5TH' AND NRV1.NEW_VALUE1 = X.NEW_VALUE1 AND NRV1.CODETYPE = 'PLANT_ID'
        LEFT JOIN NERP_CONV_OLD_NEW_REF_V NRV2 WITH(NOLOCK)
            ON NRV2.ATTRIBUTE5='5TH' AND NRV2.NEW_VALUE1 = X.NEW_VALUE1 AND NRV2.CODETYPE = 'SCP_SITE_ID'
        LEFT JOIN NERP_CONV_MASTER_CFM_V MCV1 WITH(NOLOCK)
            ON MCV1.ATTRIBUTE5='5TH' AND MCV1.OLD_VALUE1 = X.OLD_VALUE1 AND MCV1.CODETYPE = 'PLANT_ID'
        LEFT JOIN NERP_CONV_MASTER_CFM_V MCV2 WITH(NOLOCK)
            ON MCV2.ATTRIBUTE5='5TH' AND MCV2.OLD_VALUE1 = X.OLD_VALUE1 AND MCV2.CODETYPE = 'SCP_SITE_ID'
        SELECT
            X.CODETYPE
           ,X.OLD_VALUE1
           ,X.OLD_VALUE2
           ,X.OLD_VALUE3
           ,X.OLD_VALUE4
           ,X.NEW_VALUE1
           ,X.NEW_VALUE2
           ,X.NEW_VALUE3
           ,X.NEW_VALUE4
           ,X.ELEMENT1
           ,X.ELEMENT2
           ,X.ELEMENT3
           ,X.ELEMENT4
           --,NRV.*
           --,DESC1=(CASE WHEN ISNULL(NRV.DESC1,'') = '' THEN MCV.DESC1 ELSE NRV.DESC1 END)
           --,DESC1=(CASE WHEN ISNULL(NRV.DESC1,'') = '' THEN MCV.DESC1 ELSE NRV.DESC1 END)
           ,DESC1=(CASE WHEN ISNULL(NRV1.DESC1,'') <> '' THEN NRV1.DESC1
                        WHEN ISNULL(NRV2.DESC1,'') <> '' THEN NRV2.DESC1
                        WHEN ISNULL(MCV1.DESC1,'') <> '' THEN MCV1.DESC1
                        WHEN ISNULL(MCV2.DESC1,'') <> '' THEN MCV2.DESC1 ELSE X.DESC1 END)
           ,X.DESC2
           ,X.DESC3
           ,X.DESC4
           ,X.COMMENT1
           ,X.COMMENT2
           ,X.COMMENT3
           ,X.COMMENT4
           ,X.COMMENT5
           ,X.COMMENT6
           ,X.COMMENT7
           ,X.ACTIVE_FLAG
           ,X.ATTRIBUTE1
           ,X.ATTRIBUTE2
           ,X.ATTRIBUTE3
           ,X.ATTRIBUTE4
           ,X.ATTRIBUTE5
           ,X.INSERT_ID
           ,X.INSERT_DATE
           ,X.UPDATE_ID
           ,X.UPDATE_DATE
        FROM (
            --SCP_SITE_ID 공장 스타일 값 수작업 강제 추가
            SELECT  NCM.CODETYPE
                   ,CASE WHEN CPT.number = 1 THEN 'G670-A' WHEN CPT.number = 2 THEN 'G690-A' WHEN CPT.number = 3 THEN 'G690-P' END AS OLD_VALUE1
                   ,NCM.OLD_VALUE2
                   ,NCM.OLD_VALUE3
                   ,NCM.OLD_VALUE4
                   ,CASE WHEN CPT.number = 1 THEN 'GM00-A' WHEN CPT.number = 2 THEN 'EG00-A'  WHEN CPT.number = 3 THEN 'EG00-P' END AS NEW_VALUE1
                   ,NCM.NEW_VALUE2
                   ,NCM.NEW_VALUE3
                   ,NCM.NEW_VALUE4
                   ,NCM.ELEMENT1
                   ,NCM.ELEMENT2
                   ,NCM.ELEMENT3
                   ,NCM.ELEMENT4
                   ,NCM.DESC1
                   ,NCM.DESC2
                   ,NCM.DESC3
                   ,NCM.DESC4
                   ,N'수작업강제입력 BASE ON G671-A' AS COMMENT1
                   ,NCM.COMMENT2
                   ,NCM.COMMENT3
                   ,NCM.COMMENT4
                   ,NCM.COMMENT5
                   ,NCM.COMMENT6
                   ,NCM.COMMENT7
                   ,NCM.ACTIVE_FLAG
                   ,NCM.ATTRIBUTE1
                   ,NCM.ATTRIBUTE2
                   ,NCM.ATTRIBUTE3
                   ,NCM.ATTRIBUTE4
                   ,NCM.ATTRIBUTE5
                   ,NCM.INSERT_ID
                   ,NCM.INSERT_DATE
                   ,NCM.UPDATE_ID
                   ,NCM.UPDATE_DATE
            FROM   NERP_CONV_MASTER NCM WITH(NOLOCK)
            JOIN   (SELECT number FROM master.dbo.spt_values WHERE type = 'P' AND number BETWEEN 1 AND 3) CPT ON 1=1
            WHERE  NCM.ATTRIBUTE5 = '5TH'
            AND    NCM.CODETYPE = 'SCP_SITE_ID'
            AND    OLD_VALUE1 = 'G671-A'
            UNION
            --SCP_SITE_ID 회사 스타일 값 수작업 강제 추가
            SELECT  NCM.CODETYPE
                   ,'G671' AS OLD_VALUE1
                   ,NCM.OLD_VALUE2
                   ,NCM.OLD_VALUE3
                   ,NCM.OLD_VALUE4
                   ,'GM00' AS NEW_VALUE1
                   ,NCM.NEW_VALUE2
                   ,NCM.NEW_VALUE3
                   ,NCM.NEW_VALUE4
                   ,NCM.ELEMENT1
                   ,NCM.ELEMENT2
                   ,NCM.ELEMENT3
                   ,NCM.ELEMENT4
                   ,NCM.DESC1
                   ,NCM.DESC2
                   ,NCM.DESC3
                   ,NCM.DESC4
                   ,N'수작업강제입력 BASE ON G690' AS COMMENT1
                   ,NCM.COMMENT2
                   ,NCM.COMMENT3
                   ,NCM.COMMENT4
                   ,NCM.COMMENT5
                   ,NCM.COMMENT6
                   ,NCM.COMMENT7
                   ,NCM.ACTIVE_FLAG
                   ,NCM.ATTRIBUTE1
                   ,NCM.ATTRIBUTE2
                   ,NCM.ATTRIBUTE3
                   ,NCM.ATTRIBUTE4
                   ,NCM.ATTRIBUTE5
                   ,NCM.INSERT_ID
                   ,NCM.INSERT_DATE
                   ,NCM.UPDATE_ID
                   ,NCM.UPDATE_DATE
            FROM   NERP_CONV_MASTER NCM WITH(NOLOCK)
            WHERE  NCM.ATTRIBUTE5 = '5TH'
            AND    NCM.CODETYPE = 'SCP_SITE_ID'
            AND    NCM.OLD_VALUE1 = 'G690'
            UNION
            --PLANT_ID 공장 스타일 수작업 강제 추가
            --PLANT_ID 회사 스티일 없음
            SELECT  NCM.CODETYPE
                   ,CASE WHEN CPT.number = 1 THEN 'G670-A' WHEN CPT.number = 2 THEN 'G671-A' WHEN CPT.number = 3 THEN 'G673-A' WHEN CPT.number = 4 THEN 'G690-A' WHEN CPT.number = 5 THEN 'G690-P' END AS OLD_VALUE1
                   ,NCM.OLD_VALUE2
                   ,NCM.OLD_VALUE3
                   ,NCM.OLD_VALUE4
                   ,CASE WHEN CPT.number = 1 THEN 'GM00-A' WHEN CPT.number = 2 THEN 'GM00-A' WHEN CPT.number = 3 THEN 'GM01-A' WHEN CPT.number = 4 THEN 'EG00-A' WHEN CPT.number = 5 THEN 'EG00-P' END AS NEW_VALUE1
                   ,NCM.NEW_VALUE2
                   ,NCM.NEW_VALUE3
                   ,NCM.NEW_VALUE4
                   ,NCM.ELEMENT1
                   ,NCM.ELEMENT2
                   ,NCM.ELEMENT3
                   ,NCM.ELEMENT4
                   ,NCM.DESC1
                   ,NCM.DESC2
                   ,NCM.DESC3
                   ,NCM.DESC4
                   ,N'수작업강제입력 BASE ON G671' AS COMMENT1
                   ,NCM.COMMENT2
                   ,NCM.COMMENT3
                   ,NCM.COMMENT4
                   ,NCM.COMMENT5
                   ,NCM.COMMENT6
                   ,NCM.COMMENT7
                   ,NCM.ACTIVE_FLAG
                   ,NCM.ATTRIBUTE1
                   ,NCM.ATTRIBUTE2
                   ,NCM.ATTRIBUTE3
                   ,NCM.ATTRIBUTE4
                   ,NCM.ATTRIBUTE5
                   ,NCM.INSERT_ID
                   ,NCM.INSERT_DATE
                   ,NCM.UPDATE_ID
                   ,NCM.UPDATE_DATE
            FROM   NERP_CONV_MASTER NCM WITH(NOLOCK)
            JOIN   (SELECT number FROM master.dbo.spt_values WHERE type = 'P' AND number BETWEEN 1 AND 5) CPT ON 1=1
            WHERE  NCM.ATTRIBUTE5 = '5TH'
            AND    NCM.CODETYPE = 'PLANT_ID'
            AND    OLD_VALUE1 = 'G671'
        ) X
        LEFT JOIN NERP_CONV_OLD_NEW_REF_V NRV1 WITH(NOLOCK)
            ON NRV1.ATTRIBUTE5='5TH' AND NRV1.NEW_VALUE1 = X.NEW_VALUE1 AND NRV1.CODETYPE = 'PLANT_ID'
        LEFT JOIN NERP_CONV_OLD_NEW_REF_V NRV2 WITH(NOLOCK)
            ON NRV2.ATTRIBUTE5='5TH' AND NRV2.NEW_VALUE1 = X.NEW_VALUE1 AND NRV2.CODETYPE = 'SCP_SITE_ID'
        LEFT JOIN NERP_CONV_MASTER_CFM_V MCV1 WITH(NOLOCK)
            ON MCV1.ATTRIBUTE5='5TH' AND MCV1.OLD_VALUE1 = X.OLD_VALUE1 AND MCV1.CODETYPE = 'PLANT_ID'
        LEFT JOIN NERP_CONV_MASTER_CFM_V MCV2 WITH(NOLOCK)
            ON MCV2.ATTRIBUTE5='5TH' AND MCV2.OLD_VALUE1 = X.OLD_VALUE1 AND MCV2.CODETYPE = 'SCP_SITE_ID'
        WHERE 1=1
        AND NOT EXISTS (SELECT 1
                        FROM   NERP_CONV_MASTER NCM
                        WHERE  NCM.CODETYPE = X.CODETYPE
                        AND    NCM.OLD_VALUE1 = X.OLD_VALUE1
                        AND    NCM.OLD_VALUE2 = X.OLD_VALUE2
                        AND    NCM.NEW_VALUE1 = X.NEW_VALUE1
                        AND    NCM.NEW_VALUE2 = X.NEW_VALUE2
                        AND    NCM.ATTRIBUTE5 = X.ATTRIBUTE5
                        )
    END;
    --2025.11.14 김준규 DM용 G670,G671 PLANT_ID,SCP_SITE_ID 강제 수작업 추가 종료

    --2025.11.18 김준규 기존 운영에서 사용하고 있는 SCP_SITE_ID가 누락되지 않게 해달라는 요청 적용
    if @p_sys_type = 'ALL' BEGIN

        --엘지씨이 에스씨엠피알오디 : 운영 -- 뒤가 7자리
        IF DB_NAME()='LGCE_'+dbo.FN_GET_NERP_DECODE_BY_INDEXES('ASDDCMXPFFRCOYD','2,5,6,8,11,13,15') BEGIN

        --프로그램 시작시 BACKUP 해 놓은 테이블을 사용한다.
        --테이블 명은 상단에 @NewTableName로 기록 되어 있다.

        SET @sql = N'
        begin
            INSERT INTO DBO.[NERP_CONV_MASTER]
            (
                CODETYPE
               ,OLD_VALUE1
               ,OLD_VALUE2
               ,OLD_VALUE3
               ,OLD_VALUE4
               ,NEW_VALUE1
               ,NEW_VALUE2
               ,NEW_VALUE3
               ,NEW_VALUE4
               ,ELEMENT1
               ,ELEMENT2
               ,ELEMENT3
               ,ELEMENT4
               ,DESC1
               ,DESC2
               ,DESC3
               ,DESC4
               ,COMMENT1
               ,COMMENT2
               ,COMMENT3
               ,COMMENT4
               ,COMMENT5
               ,COMMENT6
               ,COMMENT7
               ,ACTIVE_FLAG
               ,ATTRIBUTE1
               ,ATTRIBUTE2
               ,ATTRIBUTE3
               ,ATTRIBUTE4
               ,ATTRIBUTE5
               ,INSERT_ID
               ,INSERT_DATE
               ,UPDATE_ID
               ,UPDATE_DATE
            )
            SELECT CODETYPE
               ,OLD_VALUE1
               ,OLD_VALUE2
               ,OLD_VALUE3
               ,OLD_VALUE4
               ,NEW_VALUE1
               ,NEW_VALUE2
               ,NEW_VALUE3
               ,NEW_VALUE4
               ,ELEMENT1
               ,ELEMENT2
               ,ELEMENT3
               ,ELEMENT4
               ,DESC1
               ,DESC2
               ,DESC3
               ,DESC4
               ,COMMENT1
               ,COMMENT2
               ,COMMENT3
               ,COMMENT4
               ,COMMENT5
               ,COMMENT6
               ,COMMENT7
               ,ACTIVE_FLAG
               ,ATTRIBUTE1
               ,ATTRIBUTE2
               ,ATTRIBUTE3
               ,''LOST''ATTRIBUTE4
               ,''9TH'' ATTRIBUTE5 -- 9TH로 강제로 변경
               ,INSERT_ID
               ,INSERT_DATE
               ,UPDATE_ID
               ,UPDATE_DATE
            FROM '+ QUOTENAME(@NewTableName) +N' AS BNCM WITH(NOLOCK)
            WHERE 1=1
            AND   BNCM.CODETYPE IN ( ''SCP_SITE_ID'',''PLANT_ID'' )
            AND   NOT EXISTS (SELECT 1
                              FROM   NERP_CONV_MASTER NCM WITH(NOLOCK)
                              WHERE  NCM.CODETYPE IN ( ''SCP_SITE_ID'',''PLANT_ID'' )
                              AND    NCM.OLD_VALUE1 = BNCM.OLD_VALUE1
                              );
        end;';
        END;

        EXEC sp_executesql @sql;
    END


END
