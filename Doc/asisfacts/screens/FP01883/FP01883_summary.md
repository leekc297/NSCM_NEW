# FP01883 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01883_Instance_Authority.UIL\FP01883_Instance_Authority_NewFolder.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01883_Instance_Authority.UIL\FP01883_Instance_Authority.UIL.csproj | 207 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01883_Instance_Authority.UIL\FP01883_Instance_Authority_NewFolder.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01883_Instance_Authority.UIL\FP01883_Instance_Authority.UIL.csproj | 639 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01883_Instance_Authority.UIL\FP01883_Instance_Authority.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01883_Instance_Authority.UIL\FP01883_Instance_Authority.UIL.csproj | 1845 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01883_Instance_Authority.UIL\FP01883_Instance_Authority.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01883_Instance_Authority.UIL\FP01883_Instance_Authority.UIL.csproj | 1213 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01883_Instance_Authority.UIL\FP01883_NewInstancePop.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01883_Instance_Authority.UIL\FP01883_Instance_Authority.UIL.csproj | 499 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01883_Instance_Authority.UIL\FP01883_NewInstancePop.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01883_Instance_Authority.UIL\FP01883_Instance_Authority.UIL.csproj | 284 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01883_Instance_Authority.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01883_Instance_Authority.UIL\FP01883_Instance_Authority.UIL.csproj | 37 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData > Find_Data_Line | 374 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_newInstance] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > Find_Data_Line | 374 | FP\Admin\FP01883_Instance_Authority#find_newInstance | MATCH | [sql] foxquery_sql\FP_Admin_FP01883_Instance_Authority_find_newInstance.sql |
| button:FindButton | FindButton > FindData_Main | 539 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_authority] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main | 539 | FP\Admin\FP01883_Instance_Authority#get_instance_authority | MATCH | [sql] foxquery_sql\FP_Admin_FP01883_Instance_Authority_get_instance_authority.sql |
| button:FindButton | FindButton > FindData_Main > ReadSelection > Find_Detail > Find_Detail_Instance | 612 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_InstanceInfo_admin] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main > ReadSelection > Find_Detail > Find_Detail_Instance | 612 | FP\ADMIN\FP01883_Instance_Authority#find_InstanceInfo_admin | MATCH | [sql] foxquery_sql\FP_Admin_FP01883_Instance_Authority_find_InstanceInfo_admin.sql |
| button:FindButton | FindButton > FindData_Main > ReadSelection > Find_Detail > Find_Detail_User | 636 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UserList_admin] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main > ReadSelection > Find_Detail > Find_Detail_User | 636 | FP\ADMIN\FP01883_Instance_Authority#find_UserList_admin | MATCH | [sql] foxquery_sql\FP_Admin_FP01883_Instance_Authority_find_UserList_admin.sql |
| event:this.btn_AuthFolder.Click | btn_AuthFolder_Click > FindData_Main | 539 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_authority] | BIZ_MATCH |  |
| event:this.btn_AuthFolder.Click | btn_AuthFolder_Click > FindData_Main | 539 | FP\Admin\FP01883_Instance_Authority#get_instance_authority | MATCH | [sql] foxquery_sql\FP_Admin_FP01883_Instance_Authority_get_instance_authority.sql |
| event:this.btn_AuthFolder.Click | btn_AuthFolder_Click > FindData_Main > ReadSelection > Find_Detail > Find_Detail_Instance | 612 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_InstanceInfo_admin] | BIZ_MATCH |  |
| event:this.btn_AuthFolder.Click | btn_AuthFolder_Click > FindData_Main > ReadSelection > Find_Detail > Find_Detail_Instance | 612 | FP\ADMIN\FP01883_Instance_Authority#find_InstanceInfo_admin | MATCH | [sql] foxquery_sql\FP_Admin_FP01883_Instance_Authority_find_InstanceInfo_admin.sql |
| event:this.btn_AuthFolder.Click | btn_AuthFolder_Click > FindData_Main > ReadSelection > Find_Detail > Find_Detail_User | 636 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UserList_admin] | BIZ_MATCH |  |
| event:this.btn_AuthFolder.Click | btn_AuthFolder_Click > FindData_Main > ReadSelection > Find_Detail > Find_Detail_User | 636 | FP\ADMIN\FP01883_Instance_Authority#find_UserList_admin | MATCH | [sql] foxquery_sql\FP_Admin_FP01883_Instance_Authority_find_UserList_admin.sql |
| event:this.btn_Del.Click | btn_Del_Click > DeleteData_Main > FindData_Main | 539 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_authority] | BIZ_MATCH |  |
| event:this.btn_Del.Click | btn_Del_Click > DeleteData_Main > FindData_Main | 539 | FP\Admin\FP01883_Instance_Authority#get_instance_authority | MATCH | [sql] foxquery_sql\FP_Admin_FP01883_Instance_Authority_get_instance_authority.sql |
| event:this.btn_Del.Click | btn_Del_Click > DeleteData_Main > FindData_Main > ReadSelection > Find_Detail > Find_Detail_Instance | 612 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_InstanceInfo_admin] | BIZ_MATCH |  |
| event:this.btn_Del.Click | btn_Del_Click > DeleteData_Main > FindData_Main > ReadSelection > Find_Detail > Find_Detail_Instance | 612 | FP\ADMIN\FP01883_Instance_Authority#find_InstanceInfo_admin | MATCH | [sql] foxquery_sql\FP_Admin_FP01883_Instance_Authority_find_InstanceInfo_admin.sql |
| event:this.btn_Del.Click | btn_Del_Click > DeleteData_Main > FindData_Main > ReadSelection > Find_Detail > Find_Detail_User | 636 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UserList_admin] | BIZ_MATCH |  |
| event:this.btn_Del.Click | btn_Del_Click > DeleteData_Main > FindData_Main > ReadSelection > Find_Detail > Find_Detail_User | 636 | FP\ADMIN\FP01883_Instance_Authority#find_UserList_admin | MATCH | [sql] foxquery_sql\FP_Admin_FP01883_Instance_Authority_find_UserList_admin.sql |
| event:this.btn_Del.Click | btn_Del_Click > DeleteData_Main > Delete_Data | 837 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_data] | BIZ_MATCH |  |
| event:this.btn_Del.Click | btn_Del_Click > DeleteData_Main > Delete_Data | 837 | FP\Admin\FP01883_Instance_Authority#delete_data | MATCH | [update-batch]  |
| event:this.btn_Save.Click | btn_Save_Click > SaveData_Main > FindData_Main | 539 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_authority] | BIZ_MATCH |  |
| event:this.btn_Save.Click | btn_Save_Click > SaveData_Main > FindData_Main | 539 | FP\Admin\FP01883_Instance_Authority#get_instance_authority | MATCH | [sql] foxquery_sql\FP_Admin_FP01883_Instance_Authority_get_instance_authority.sql |
| event:this.btn_Save.Click | btn_Save_Click > SaveData_Main > FindData_Main > ReadSelection > Find_Detail > Find_Detail_Instance | 612 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_InstanceInfo_admin] | BIZ_MATCH |  |
| event:this.btn_Save.Click | btn_Save_Click > SaveData_Main > FindData_Main > ReadSelection > Find_Detail > Find_Detail_Instance | 612 | FP\ADMIN\FP01883_Instance_Authority#find_InstanceInfo_admin | MATCH | [sql] foxquery_sql\FP_Admin_FP01883_Instance_Authority_find_InstanceInfo_admin.sql |
| event:this.btn_Save.Click | btn_Save_Click > SaveData_Main > FindData_Main > ReadSelection > Find_Detail > Find_Detail_User | 636 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UserList_admin] | BIZ_MATCH |  |
| event:this.btn_Save.Click | btn_Save_Click > SaveData_Main > FindData_Main > ReadSelection > Find_Detail > Find_Detail_User | 636 | FP\ADMIN\FP01883_Instance_Authority#find_UserList_admin | MATCH | [sql] foxquery_sql\FP_Admin_FP01883_Instance_Authority_find_UserList_admin.sql |
| event:this.btn_Save.Click | btn_Save_Click > SaveData_Main > Save_Data | 717 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=merge_data] | BIZ_MATCH |  |
| event:this.btn_Save.Click | btn_Save_Click > SaveData_Main > Save_Data | 717 | FP\Admin\FP01883_Instance_Authority#merge_data | MATCH | [update-batch]  |
| event:this.btn_SaveDetail.Click | btn_SaveDetail_Click > Find_Detail > Find_Detail_Instance | 612 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_InstanceInfo_admin] | BIZ_MATCH |  |
| event:this.btn_SaveDetail.Click | btn_SaveDetail_Click > Find_Detail > Find_Detail_Instance | 612 | FP\ADMIN\FP01883_Instance_Authority#find_InstanceInfo_admin | MATCH | [sql] foxquery_sql\FP_Admin_FP01883_Instance_Authority_find_InstanceInfo_admin.sql |
| event:this.btn_SaveDetail.Click | btn_SaveDetail_Click > Find_Detail > Find_Detail_User | 636 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UserList_admin] | BIZ_MATCH |  |
| event:this.btn_SaveDetail.Click | btn_SaveDetail_Click > Find_Detail > Find_Detail_User | 636 | FP\ADMIN\FP01883_Instance_Authority#find_UserList_admin | MATCH | [sql] foxquery_sql\FP_Admin_FP01883_Instance_Authority_find_UserList_admin.sql |
| event:this.btn_SaveDetail.Click | btn_SaveDetail_Click > Save_Data_Execute | 1683 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_InstanceInfo] | BIZ_MATCH |  |
| event:this.btn_SaveDetail.Click | btn_SaveDetail_Click > Save_Data_Execute | 1683 | FP\ADMIN\FP01883_Instance_Authority#saveAll_InstanceInfo | MATCH | [update-batch]  |
| event:this.btn_SaveDetail.Click | btn_SaveDetail_Click > Save_Data_Execute | 1687 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=delete_InstanceInfo] | BIZ_MATCH |  |
| event:this.btn_SaveDetail.Click | btn_SaveDetail_Click > Save_Data_Execute | 1687 | FP\ADMIN\FP01883_Instance_Authority#delete_InstanceInfo | MATCH | [update-batch]  |
| event:this.btn_SaveDetail.Click | btn_SaveDetail_Click > Save_Data_Execute | 1694 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_UserInfo] | BIZ_MATCH |  |
| event:this.btn_SaveDetail.Click | btn_SaveDetail_Click > Save_Data_Execute | 1694 | FP\ADMIN\FP01883_Instance_Authority#saveAll_UserInfo | MATCH | [update-batch]  |
| event:this.btn_SaveDetail.Click | btn_SaveDetail_Click > Save_Data_Execute | 1698 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=delete_UserInfo] | BIZ_MATCH |  |
| event:this.btn_SaveDetail.Click | btn_SaveDetail_Click > Save_Data_Execute | 1698 | FP\ADMIN\FP01883_Instance_Authority#delete_UserInfo | MATCH | [update-batch]  |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData > Find_Data_Line | 374 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_newInstance] | BIZ_MATCH |  |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > FindData > Find_Data_Line | 374 | FP\Admin\FP01883_Instance_Authority#find_newInstance | MATCH | [sql] foxquery_sql\FP_Admin_FP01883_Instance_Authority_find_newInstance.sql |
| event:this.btnSave.Click | btnSave_Click > Save_Data | 162 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_folder] | BIZ_MATCH |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data | 162 | FP\Admin\FP01883_Instance_Authority#insert_folder | MATCH | [update-batch]  |
| event:this.Load | Form_Load > FindData > Find_Data_Line | 374 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_newInstance] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > Find_Data_Line | 374 | FP\Admin\FP01883_Instance_Authority#find_newInstance | MATCH | [sql] foxquery_sql\FP_Admin_FP01883_Instance_Authority_find_newInstance.sql |
| event:this.Load | Form_Load > FindData_Main | 539 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_authority] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData_Main | 539 | FP\Admin\FP01883_Instance_Authority#get_instance_authority | MATCH | [sql] foxquery_sql\FP_Admin_FP01883_Instance_Authority_get_instance_authority.sql |
| event:this.Load | Form_Load > FindData_Main > ReadSelection > Find_Detail > Find_Detail_Instance | 612 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_InstanceInfo_admin] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData_Main > ReadSelection > Find_Detail > Find_Detail_Instance | 612 | FP\ADMIN\FP01883_Instance_Authority#find_InstanceInfo_admin | MATCH | [sql] foxquery_sql\FP_Admin_FP01883_Instance_Authority_find_InstanceInfo_admin.sql |
| event:this.Load | Form_Load > FindData_Main > ReadSelection > Find_Detail > Find_Detail_User | 636 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UserList_admin] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData_Main > ReadSelection > Find_Detail > Find_Detail_User | 636 | FP\ADMIN\FP01883_Instance_Authority#find_UserList_admin | MATCH | [sql] foxquery_sql\FP_Admin_FP01883_Instance_Authority_find_UserList_admin.sql |
| event:utriMain.AfterSelect | UtriMain_AfterSelect > ReadSelection > Find_Detail > Find_Detail_Instance | 612 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_InstanceInfo_admin] | BIZ_MATCH |  |
| event:utriMain.AfterSelect | UtriMain_AfterSelect > ReadSelection > Find_Detail > Find_Detail_Instance | 612 | FP\ADMIN\FP01883_Instance_Authority#find_InstanceInfo_admin | MATCH | [sql] foxquery_sql\FP_Admin_FP01883_Instance_Authority_find_InstanceInfo_admin.sql |
| event:utriMain.AfterSelect | UtriMain_AfterSelect > ReadSelection > Find_Detail > Find_Detail_User | 636 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UserList_admin] | BIZ_MATCH |  |
| event:utriMain.AfterSelect | UtriMain_AfterSelect > ReadSelection > Find_Detail > Find_Detail_User | 636 | FP\ADMIN\FP01883_Instance_Authority#find_UserList_admin | MATCH | [sql] foxquery_sql\FP_Admin_FP01883_Instance_Authority_find_UserList_admin.sql |
| unreached:(진입점 미연결) | <field:dtMyDivision> | 46 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetUserTitle | 856 | SCP.SCP0049_GET_SHEET_USER_TITLE | MATCH | SP SCP0049_GET_SHEET_USER_TITLE |
| unreached:(진입점 미연결) | GetDayRange | 934 | SCP.SCP0049_GET_DAY_RANGE | MATCH | SP SCP0049_GET_DAY_RANGE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_InstanceInfo_admin] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_newInstance] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UserList_admin] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_authority] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_data] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_folder] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=merge_data] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=delete_InstanceInfo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=delete_UserInfo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_InstanceInfo] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_UserInfo] | BIZ_MATCH | 1 |  |  |  |
| FP\Admin\FP01883_Instance_Authority#delete_data | MATCH | 1 | [update-batch]  |  |  |
| FP\ADMIN\FP01883_Instance_Authority#delete_InstanceInfo | MATCH | 1 | [update-batch]  |  |  |
| FP\ADMIN\FP01883_Instance_Authority#delete_UserInfo | MATCH | 1 | [update-batch]  |  |  |
| FP\ADMIN\FP01883_Instance_Authority#find_InstanceInfo_admin | MATCH | 1 | [sql] foxquery_sql\FP_Admin_FP01883_Instance_Authority_find_InstanceInfo_admin.sql | REF:FN_GETNAME_FACTORY_ID, SELECT:TH_UIS_ROLE_INSTANCE_RELATE |  |
| FP\Admin\FP01883_Instance_Authority#find_newInstance | MATCH | 1 | [sql] foxquery_sql\FP_Admin_FP01883_Instance_Authority_find_newInstance.sql | SELECT:SCM_SYS_LOOKUP_VALUE, SELECT:FP_INSTANCE_FACTORY_M, SELECT:SCM_FACTORY_M |  |
| FP\ADMIN\FP01883_Instance_Authority#find_UserList_admin | MATCH | 1 | [sql] foxquery_sql\FP_Admin_FP01883_Instance_Authority_find_UserList_admin.sql | SELECT:TH_UIS_USER_INSTANCE_RELATE, SELECT:TH_UIS_USER_DETAIL |  |
| FP\Admin\FP01883_Instance_Authority#get_instance_authority | MATCH | 1 | [sql] foxquery_sql\FP_Admin_FP01883_Instance_Authority_get_instance_authority.sql | SELECT:TH_UIS_ROLE_INSTANCE, SELECT:WITH_ROLE_FACTORY |  |
| FP\Admin\FP01883_Instance_Authority#insert_folder | MATCH | 1 | [update-batch]  |  |  |
| FP\Admin\FP01883_Instance_Authority#merge_data | MATCH | 1 | [update-batch]  |  |  |
| FP\ADMIN\FP01883_Instance_Authority#saveAll_InstanceInfo | MATCH | 1 | [update-batch]  |  |  |
| FP\ADMIN\FP01883_Instance_Authority#saveAll_UserInfo | MATCH | 1 | [update-batch]  |  |  |
| SCP.SCP0049_GET_DAY_RANGE | MATCH | 1 | SP SCP0049_GET_DAY_RANGE | EXEC:SCP0049_GET_DAY_RANGE, SELECT:TB_FX_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCP.SCP0049_GET_SHEET_USER_TITLE | MATCH | 1 | SP SCP0049_GET_SHEET_USER_TITLE | EXEC:SCP0049_GET_SHEET_USER_TITLE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| .ctor | filterDs | ROLE_ID, ROLE_NAME, USER_ID |
| <field:dtMyDivision> | UserInfoContext.Current | NowGroupID |
| btn_AddDetail_Click | treeRow | LVL |
| btn_AddDetail_Click | newRow | ROLE_ID, USE_AT_FLAG |
| btn_AuthFolder_Click | row | LVL, ROLE_ID, ROLE_NAME |
| btn_AuthFolder_Click | FilterTmp | ROLE_ID, ROLE_NAME, USER_ID |
| btn_DelDetail_Click | treeRow | LVL |
| Delete_Data | dtsave.Rows[0] | ROLE_ID |
| DeleteData_Main | row | LVL |
| FindData_Main | Filter | USER_ID, DIVISION_ID, SITE_ID, OPERATION_ID, PLANT_ID, FACTORY_ID |
| InsertData_Main | row | LVL, ROLE_ID |
| InsertData_Main | newRow | ROLE_NAME, ROLE_DESCR, INSERT_DTTM, UPDATE_DTTM, INSERT_ID, UPDATE_ID, ROLE_ID, UPPER_ROLE_ID, LVL, APPROVAL_EXCEPTION_FLAG, _STATUS |
| ReadSelection | row | ROLE_ID, ROLE_NAME, ROLE_DESCR, UPPER_ROLE_NAME, APPROVAL_EXCEPTION_FLAG, INSERT_ID, UPDATE_ID, INSERT_DTTM, UPDATE_DTTM |
| Save_Data | dtsave.Rows[0] | USER_ID, ROLE_ID, ROLE_NAME, UPPER_ROLE_ID, ROLE_DESCR, APPROVAL_EXCEPTION_FLAG |
| Save_Data | row | UPPER_ROLE_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSpdTitle | SetSpreadInit:320 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | SetSpreadInit:323 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | SetSpreadInit:332 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| FP_PseudoBatch2 | Save_Data:717, Delete_Data:837, Save_Data:162 | DataService.FP_PseudoBatch2 | COUNT, EXCEPTION, RESULT |
| GetChanges | Save_Data_Execute:1674 | FPExtensions.GetChanges | ROW_ID |
| FP_UpdateBatch2 | Save_Data_Execute:1683, Save_Data_Execute:1687, Save_Data_Execute:1694, Save_Data_Execute:1698 | DataService.FP_UpdateBatch2 | COUNT, EXCEPTION, RESULT |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:142 |
| this.spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:341 |
| this.spdMain | CellClick | SpdMain_CellClick | InitEvent:342 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitEvent:343 |
| dsdm | Changed | shtMain_Changed | InitEvent:346 |
| utriMain | AfterSelect | UtriMain_AfterSelect | InitEvent:349 |
| utriMain | AfterSelect | UtriMain_AfterSelect | FP01883_Instance_Authority_FormClosing:1840 |
| this.btn_Save | Click | btn_Save_Click | InitializeComponent:209 |
| this.btn_Del | Click | btn_Del_Click | InitializeComponent:246 |
| this.btn_SaveDetail | Click | btn_SaveDetail_Click | InitializeComponent:283 |
| this.btn_AuthFolder | Click | btn_AuthFolder_Click | InitializeComponent:320 |
| this.btn_DelDetail | Click | btn_DelDetail_Click | InitializeComponent:357 |
| this.btn_AddDetail | Click | btn_AddDetail_Click | InitializeComponent:394 |
| this.btn_Add | Click | btn_Add_Click | InitializeComponent:741 |
| this | FormClosing | FP01883_Instance_Authority_FormClosing | InitializeComponent:1114 |
| this | Load | Form_Load | .ctor:71 |
| popSql | OnSql | RunSqlSource | btnSql_Click:121 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:361 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:399 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:154 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:189 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:190 |
| this | Load | Form_Load | .ctor:153 |

## 6. 컨트롤 (81개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 24 | layoutControlItem6, layoutControlItem2, layoutControlItem3, layoutControlItem7, layoutControlItem9, layoutControlItem10, layoutControlItem11, layoutControlItem8, layoutControlItem4, layoutControlItem1, layoutControlItem5, layoutControlItem12, layoutControlItem13, layoutControlItem15, layoutControlItem16 … |
| UsrTextBox | 10 | txtAuthorityName2, txtUpdate, txtInsert, txtAuthDesc, txtUpperAuth, txtAuthority, txt_RoleDesc, txt_RoleName, txt_UpperName, txt_UpperId |
| UsrButton | 9 | btn_Save, btn_Del, btn_SaveDetail, btn_AuthFolder, btn_DelDetail, btn_AddDetail, btn_Add, btnClose, btnSave |
| EmptySpaceItem | 7 | emptySpaceItem3, emptySpaceItem1, emptySpaceItem4, emptySpaceItem5, emptySpaceItem7, emptySpaceItem6, emptySpaceItem1 |
| UsrLayoutControl | 6 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 6 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrConditionPanel | 3 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| SimpleLabelItem | 3 | simpleLabelItem1, simpleLabelItem2, simpleLabelItem3 |
| UsrDatePicker2 | 2 | dtUpdate, dtInsert |
| FpSpread | 2 | spdMain, spdMain |
| SheetView | 2 | spdMain_Sheet1, spdMain_Sheet1 |
| ImageList | 2 | imageList1, imageList1 |
| UsrComboBox | 1 | cbApproval |
| SplitContainer | 1 | dataPanel |
| UsrTriStateTreeView | 1 | utriMain |
| UsrLabel | 1 | usrLabel3 |
| UsrButtonList | 1 | btnButtonList |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 25 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 1 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 2 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP01883 | Instance | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 |
| SCM_MST_SHEET_COLUMNS | FP01883 | NewInstancePop | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 |
| SCM_MST_SHEET_COLUMNS | FP01883 | User | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Instance, User, NewInstancePop
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:289, SetSheetHeaderColumn@SetSpreadInit:323, SetSheetHeaderColumn_FP@SetSpreadInit:274
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadColumn |  | 1142 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Y_") == 0) |
| SetSpreadColumn |  | 1145 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Y_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| InitializeComponent |  | 206 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 207 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 208 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 209 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Instance | META+코드연결 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |
| NewInstancePop | META+코드연결 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 |
| User | META+코드연결 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
