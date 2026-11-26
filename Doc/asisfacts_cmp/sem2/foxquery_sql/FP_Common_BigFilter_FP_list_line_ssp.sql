-- Temp Table
			DECLARE @TResult TABLE(
				Code NVARCHAR(MAX),
				NAME NVARCHAR(MAX)
			)
			
			DECLARE @TResultDIV TABLE(
				Code NVARCHAR(MAX),
				NAME NVARCHAR(MAX),
				DIVISION_ID NVARCHAR(MAX)
			)
			
			DECLARE @TResultVALUE TABLE(
				Code NVARCHAR(MAX),
				VALUE NVARCHAR(MAX),
				Diff_VALUE NVARCHAR(MAX)
			)

			DECLARE @TResultBuilding TABLE(
				Code NVARCHAR(MAX),
				NAME NVARCHAR(MAX),
				DIVISION_ID NVARCHAR(MAX),
				PLANT_ID NVARCHAR(MAX),
				COMPANY_ID NVARCHAR(MAX),
				SCM_SITE_ID NVARCHAR(MAX)
			)

			DECLARE @TResultCOMPANYID TABLE(
				COMPANY_ID NVARCHAR(MAX)
			)


		 BEGIN
			-- run UP_FX_GetCommonDataList_SCP 
			INSERT @TResult EXEC [UP_FX_GetCommonDataList_SCP]
			   @Code = 'MyDivisionInEE'
			 , @Param1 = @GROUP_ID
			 , @Param2 = @USER_ID
			 , @Param3 = ''
			 , @Param4 = ''
			 , @Param5 = ''
			 -- Result : MyDivisionInEE 
			SELECT	* FROM @TResult
		 END

		 BEGIN
			-- run UP_FX_GetCommonDataList_SCP 
			INSERT @TResultDIV EXEC [UP_FX_GetCommonDataList_SCP]
			   @Code = 'Div_Company'
			 , @Param1 = ''
			 , @Param2 = ''
			 , @Param3 = ''
			 , @Param4 = ''
			 , @Param5 = ''
			 -- Result : Div_Company 
			SELECT	* FROM @TResultDIV
		 END

		 BEGIN
			--	INIT Temp
			DELETE @TResult

			-- run UP_FX_GetCommonDataList_SCP 
			INSERT @TResult EXEC [UP_FX_GetCommonDataList_SCP]
			   @Code = 'MyCompanyID'
			 , @Param1 = @USER_ID
			 , @Param2 = ''
			 , @Param3 = ''
			 , @Param4 = ''
			 , @Param5 = ''
			 -- Result : MyCompanyID 
			SELECT	* FROM @TResult
		 END

		 BEGIN
			--	INIT Temp
			DELETE @TResult

			-- run UP_FX_GetCommonDataList_SCP 
			INSERT @TResult EXEC [UP_FX_GetCommonDataList_SCP]
			   @Code = 'CellTypeGr'
			 , @Param1 = ''
			 , @Param2 = ''
			 , @Param3 = ''
			 , @Param4 = ''
			 , @Param5 = ''
			 -- Result : CellTypeGr 
			SELECT	* FROM @TResult
		 END

		 BEGIN
			--	INIT Temp
			DELETE @TResult

			-- run UP_FX_GetCommonDataList
			INSERT @TResult EXEC [UP_FX_GetCommonDataList]
			   @Code = 'LookupCommon'
			 , @Param1 = 'MY_MODEL_DEFAULT_CHECK'
			 , @Param2 = ''
			 , @Param3 = ''
			 , @Param4 = ''
			 , @Param5 = ''
			 -- Result : LookupCommon MY_MODEL_DEFAULT_CHECK
			SELECT	* FROM @TResult
		 END

		 BEGIN
			-- run UP_FX_GetCommonDataList_SCP 
			INSERT @TResultVALUE EXEC [UP_FX_GetCommonDataList_SCP]
			   @Code = 'SHIPMENT_PERIOD_DAY'
			 , @Param1 = ''
			 , @Param2 = ''
			 , @Param3 = ''
			 , @Param4 = ''
			 , @Param5 = ''
			 -- Result : SHIPMENT_PERIOD_DAY 
			SELECT	* FROM @TResultVALUE
		 END

		 BEGIN
			--	INIT Temp
			DELETE @TResult

			-- run UP_FX_GetCommonDataList
			INSERT @TResult EXEC [UP_FX_GetCommonDataList]
			   @Code = 'LookupCommon'
			 , @Param1 = 'PGM_AUTH_ID'
			 , @Param2 = ''
			 , @Param3 = ''
			 , @Param4 = ''
			 , @Param5 = ''
			 -- Result : LookupCommon PGM_AUTH_ID
			SELECT	* FROM @TResult
		 END

		 BEGIN
			--	INIT Temp
			DELETE @TResult

			-- run UP_FX_GetCommonDataList_SCP 
			INSERT @TResult EXEC [UP_FX_GetCommonDataList_SCP]
			   @Code = 'MyDivisionOut40'
			 , @Param1 = @GROUP_ID
			 , @Param2 = @USER_ID
			 , @Param3 = ''
			 , @Param4 = ''
			 , @Param5 = ''
			 -- Result : MyDivisionOut40 
			SELECT	* FROM @TResult
		 END

		 BEGIN
			--	INIT Temp
			DELETE @TResult

			-- run UP_FX_GetCommonDataList
			INSERT @TResult EXEC [UP_FX_GetCommonDataList]
			   @Code = 'CHANGE_REASON_CODE_ALL'
			 , @Param1 = 'CHANGE_REASON_CODE'
			 , @Param2 = @USER_ID
			 , @Param3 = ''
			 , @Param4 = ''
			 , @Param5 = ''
			 -- Result : CHANGE_REASON_CODE_ALL
			SELECT	* FROM @TResult
		 END

		 BEGIN
			--	INIT Temp
			DELETE @TResult

			-- run UP_FX_GetCommonDataList
			INSERT @TResult EXEC [UP_FX_GetCommonDataList]
			   @Code = 'LookupCommon3'
			 , @Param1 = 'OWMS_STOCK_STATUS'
			 , @Param2 = @USER_ID
			 , @Param3 = ''
			 , @Param4 = ''
			 , @Param5 = ''
			 -- Result : LookupCommon3 OWMS_STOCK_STATUS
			SELECT	* FROM @TResult
		 END

		 BEGIN
			--	INIT Temp
			DELETE @TResult

			-- run UP_FX_GetCommonDataList
			INSERT @TResult EXEC [UP_FX_GetCommonDataList]
			   @Code = 'LookupCommon'
			 , @Param1 = 'SSP_SHIPMENT_RESULT_TYPE'
			 , @Param2 = ''
			 , @Param3 = ''
			 , @Param4 = ''
			 , @Param5 = ''
			 -- Result : LookupCommon SSP_SHIPMENT_RESULT_TYPE
			SELECT	* FROM @TResult
		 END

		 BEGIN
			--	INIT Temp
			DELETE @TResult

			-- run UP_FX_GetCommonDataList
			INSERT @TResult EXEC [UP_FX_GetCommonDataList]
			   @Code = 'LookupCommon'
			 , @Param1 = 'CHANGE_REQ_DAY'
			 , @Param2 = ''
			 , @Param3 = ''
			 , @Param4 = ''
			 , @Param5 = ''
			 -- Result : LookupCommon CHANGE_REQ_DAY
			SELECT	* FROM @TResult
		 END

		 BEGIN
			--	INIT Temp
			DELETE @TResultDIV

			-- run UP_FX_GetCommonDataList_SCP 
			INSERT @TResultDIV EXEC [UP_FX_GetCommonDataList_SCP]
			   @Code = 'Div_CompanyEE'
			 , @Param1 = ''
			 , @Param2 = ''
			 , @Param3 = ''
			 , @Param4 = ''
			 , @Param5 = ''
			 -- Result : Div_Company 
			SELECT	* FROM @TResultDIV
		 END

		 BEGIN
			--	INIT Temp
			DELETE @TResult

			-- run UP_FX_GetCommonDataList
			INSERT @TResult EXEC [UP_FX_GetCommonDataList]
			   @Code = 'DomExpTypeCode'
			 , @Param1 = ''
			 , @Param2 = ''
			 , @Param3 = ''
			 , @Param4 = ''
			 , @Param5 = ''
			 -- Result : DomExpTypeCode 
			SELECT	* FROM @TResult
		 END

		 BEGIN
			--	INIT Temp
			DELETE @TResult

			-- run UP_FX_GetCommonDataList
			INSERT @TResult EXEC [UP_FX_GetCommonDataList]
			   @Code = 'ElectrodePackageType'
			 , @Param1 = ''
			 , @Param2 = ''
			 , @Param3 = ''
			 , @Param4 = ''
			 , @Param5 = ''
			 -- Result : ElectrodePackageType 
			SELECT	* FROM @TResult
		 END

		 BEGIN
			-- run UP_FX_GetCommonDataList
			INSERT @TResultBuilding EXEC [UP_FX_GetCommonDataList]
			   @Code = 'BuildingForShipMasterElec'
			 , @Param1 = ''
			 , @Param2 = ''
			 , @Param3 = ''
			 , @Param4 = ''
			 , @Param5 = ''
			 -- Result : BuildingForShipMasterElec 
			SELECT	* FROM @TResultBuilding
		 END

		 BEGIN
			--	INIT Temp
			DELETE @TResult

			-- run UP_FX_GetCommonDataList
			INSERT @TResult EXEC [UP_FX_GetCommonDataList]
			   @Code = 'LookupCommon'
			 , @Param1 = 'SALES_TYPE_CODE'
			 , @Param2 = ''
			 , @Param3 = ''
			 , @Param4 = ''
			 , @Param5 = ''
			 -- Result : LookupCommon SALES_TYPE_CODE
			SELECT	* FROM @TResult
		 END

		 BEGIN
			-- run UP_FX_GetCommonDataList_SCP 
			INSERT @TResultCOMPANYID EXEC [UP_FX_GetCommonDataList_SCP]
			   @Code = 'CompanyID'
			 , @Param1 = @USER_ID
			 , @Param2 = ''
			 , @Param3 = ''
			 , @Param4 = ''
			 , @Param5 = ''
			 -- Result : CompanyID 
			SELECT	* FROM @TResultCOMPANYID
		 END

		 BEGIN
			--	INIT Temp
			DELETE @TResult

			-- run UP_FX_GetCommonDataList
			INSERT @TResult EXEC [UP_FX_GetCommonDataList]
			   @Code = 'LookupCommon'
			 , @Param1 = 'SHIPMENT_STATUS'
			 , @Param2 = ''
			 , @Param3 = ''
			 , @Param4 = ''
			 , @Param5 = ''
			 -- Result : LookupCommon SHIPMENT_STATUS
			SELECT	* FROM @TResult
		 END

		 BEGIN
			--	INIT Temp
			DELETE @TResult

			-- run UP_FX_GetCommonDataList
			INSERT @TResult EXEC [UP_FX_GetCommonDataList]
			   @Code = 'LookupCommon'
			 , @Param1 = 'CHANGE_REQ_TYPE'
			 , @Param2 = ''
			 , @Param3 = ''
			 , @Param4 = ''
			 , @Param5 = ''
			 -- Result : LookupCommon CHANGE_REQ_TYPE
			SELECT	* FROM @TResult
		 END

		 BEGIN
			--	INIT Temp
			DELETE @TResult

			-- run UP_FX_GetCommonDataList_SCP 
			INSERT @TResult EXEC [UP_FX_GetCommonDataList_SCP]
			   @Code = 'AllDivision'
			 , @Param1 = ''
			 , @Param2 = ''
			 , @Param3 = ''
			 , @Param4 = ''
			 , @Param5 = ''
			 -- Result : AllDivision 
			SELECT	* FROM @TResult
		 END

		 BEGIN
			--	INIT Temp
			DELETE @TResult

			-- run UP_FX_GetCommonDataList
			INSERT @TResult EXEC [UP_FX_GetCommonDataList]
			   @Code = 'LookupCommon'
			 , @Param1 = 'ESS_STOCK_STORAGE_ID'
			 , @Param2 = ''
			 , @Param3 = ''
			 , @Param4 = ''
			 , @Param5 = ''
			 -- Result : LookupCommon ESS_STOCK_STORAGE_ID
			SELECT	* FROM @TResult
		 END

		 BEGIN
			--	INIT Temp
			DELETE @TResult

			-- run UP_FX_GetCommonDataList
			INSERT @TResult EXEC [UP_FX_GetCommonDataList]
			   @Code = 'Dept'
			 , @Param1 = @LANGUAGE_CODE
			 , @Param2 = ''
			 , @Param3 = ''
			 , @Param4 = ''
			 , @Param5 = ''
			 -- Result : Dept
			SELECT	* FROM @TResult
		 END

		 BEGIN
			--	INIT Temp
			DELETE @TResult

			-- run UP_FX_GetCommonDataList
			INSERT @TResult EXEC [UP_FX_GetCommonDataList]
			   @Code = 'LookupCommon'
			 , @Param1 = 'CHANGE_REQ_APP_DAY'
			 , @Param2 = ''
			 , @Param3 = ''
			 , @Param4 = ''
			 , @Param5 = ''
			 -- Result : LookupCommon CHANGE_REQ_APP_DAY
			SELECT	* FROM @TResult
		 END

		 BEGIN
			--	INIT Temp
			DELETE @TResult

			-- run UP_FX_GetCommonDataList
			INSERT @TResult EXEC [UP_FX_GetCommonDataList]
			   @Code = 'LookupCommon'
			 , @Param1 = 'CHANGE_REQ_STATUS'
			 , @Param2 = ''
			 , @Param3 = ''
			 , @Param4 = ''
			 , @Param5 = ''
			 -- Result : LookupCommon CHANGE_REQ_STATUS
			SELECT	* FROM @TResult
		 END

		 BEGIN
			--	INIT Temp
			DELETE @TResult

			-- run UP_FX_GetCommonDataList
			INSERT @TResult EXEC [UP_FX_GetCommonDataList]
			   @Code = 'MyDivision'
			 , @Param1 = @GROUP_ID
			 , @Param2 = @USER_ID
			 , @Param3 = ''
			 , @Param4 = ''
			 , @Param5 = ''
			 -- Result : MyDivision 
			SELECT	* FROM @TResult
		 END

		 BEGIN
			--	INIT Temp
			DELETE @TResult

			-- run UP_FX_GetCommonDataList
			INSERT @TResult EXEC [UP_FX_GetCommonDataList]
			   @Code = 'LookupCommon'
			 , @Param1 = 'OPERATION_GROUP'
			 , @Param2 = ''
			 , @Param3 = ''
			 , @Param4 = ''
			 , @Param5 = ''
			 -- Result : LookupCommon CHANGE_REQ_STATUS
			SELECT	* FROM @TResult
		 END