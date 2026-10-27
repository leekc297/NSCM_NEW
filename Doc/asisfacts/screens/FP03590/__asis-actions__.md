# AS-IS 액션 대조표 — FP03590

> 원천: `Doc/asisfacts/screens/FP03590/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 423행 · 메서드 34 · 종류 DATA_OP 251 · RETURN 39 · FLAG 26 · UI_PROP 16 · ENDPOINT 15 · MESSAGE 10 · GRID_INIT 9 · GRID_STYLE 9 · UI_MISC 6 · POPUP 5 · COMBO_DATA 5 · LIST_REBIND 5 · GRID_LOCK 5 · GRID_SET 5 · STATE 4 · VALIDATE 3 · CALL_EXT 2 · CALL_BASE 2 · THROW 2 · STATE_RESET 1 · EXCEL 1 · GRID_BIND 1 · VALUE_SET 1 · ⚠ 의미 확인 필요 4


## FP03590_PDS_Target.btnAdd_Click

진입점: this.btnAdd.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be2102c0 | this.btnAdd.Click | FP03590_PDS_Target.cs:898 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP03590_PDS_Target.btnImport_Click

진입점: this.btnImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f896e9e | this.btnImport.Click | FP03590_PDS_Target.cs:975 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP03590_PDS_Target.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9cc40293 | this.btnSql.Click | FP03590_PDS_Target.cs:964 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-2b148e37 | this.btnSql.Click | FP03590_PDS_Target.cs:965 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-50e611db | this.btnSql.Click | FP03590_PDS_Target.cs:967 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP03590_PDS_TARGET") | 데이터 객체 조작/조회 |  |  |  |
| AC-b6c316e0 | this.btnSql.Click | FP03590_PDS_Target.cs:969 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP03590_PDS_Target.CboSite_SelectedIndexChanged

진입점: cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-997e979f | cboSite.SelectedIndexChanged | FP03590_PDS_Target.cs:1047 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-08527c5a | cboSite.SelectedIndexChanged | FP03590_PDS_Target.cs:1052 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-e92d7740 | cboSite.SelectedIndexChanged | FP03590_PDS_Target.cs:1054 |  | FLAG | dtPlantByDivision | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-d68af72e | cboSite.SelectedIndexChanged | FP03590_PDS_Target.cs:1054 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9da155df | cboSite.SelectedIndexChanged | FP03590_PDS_Target.cs:1055 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByDivision, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## FP03590_PDS_Target.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-279d9898 | (진입점 미연결) | FP03590_PDS_Target.cs:285 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-e48ceb2d | (진입점 미연결) | FP03590_PDS_Target.cs:286 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## FP03590_PDS_Target.CreateExelBufferDataTable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-879135c4 | (진입점 미연결) | FP03590_PDS_Target.cs:1096 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-84aeb70f | (진입점 미연결) | FP03590_PDS_Target.cs:1098 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-cc2b16dd | (진입점 미연결) | FP03590_PDS_Target.cs:1099 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-50b7343c | (진입점 미연결) | FP03590_PDS_Target.cs:1100 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2bb08071 | (진입점 미연결) | FP03590_PDS_Target.cs:1101 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-cf22ade8 | (진입점 미연결) | FP03590_PDS_Target.cs:1102 |  | DATA_OP | dt.Columns.Add | (new DataColumn("TEST_TARGET_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e5d8b3da | (진입점 미연결) | FP03590_PDS_Target.cs:1103 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MODEL", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ae524385 | (진입점 미연결) | FP03590_PDS_Target.cs:1104 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9d568c71 | (진입점 미연결) | FP03590_PDS_Target.cs:1105 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5ffb4d2f | (진입점 미연결) | FP03590_PDS_Target.cs:1106 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-87c91820 | (진입점 미연결) | FP03590_PDS_Target.cs:1107 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-de74a386 | (진입점 미연결) | FP03590_PDS_Target.cs:1108 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-647f6817 | (진입점 미연결) | FP03590_PDS_Target.cs:1109 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea8bdcd5 | (진입점 미연결) | FP03590_PDS_Target.cs:1110 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DUE_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c3593adc | (진입점 미연결) | FP03590_PDS_Target.cs:1111 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MFG_WEEK", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-cb5870f9 | (진입점 미연결) | FP03590_PDS_Target.cs:1112 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MFG_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-47b388e6 | (진입점 미연결) | FP03590_PDS_Target.cs:1113 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DESCRIPTION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-95d87694 | (진입점 미연결) | FP03590_PDS_Target.cs:1114 |  | DATA_OP | dt.Columns.Add | (new DataColumn("NICK_NAME", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ba42b89b | (진입점 미연결) | FP03590_PDS_Target.cs:1115 |  | DATA_OP | dt.Columns.Add | (new DataColumn("IS_PREV_SCHEDULE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-00b61f68 | (진입점 미연결) | FP03590_PDS_Target.cs:1116 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DEMAND_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3c54df34 | (진입점 미연결) | FP03590_PDS_Target.cs:1117 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SCP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0f838fc6 | (진입점 미연결) | FP03590_PDS_Target.cs:1119 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP03590_PDS_Target.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6aaf46ba | this.Load | FP03590_PDS_Target.cs:295 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-882b7160 | this.Load | FP03590_PDS_Target.cs:296 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-6a224d9e | this.Load | FP03590_PDS_Target.cs:298 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP03590_PDS_Target.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c83faf4 | this.Load | FP03590_PDS_Target.cs:207 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-d51c84f4 | this.Load | FP03590_PDS_Target.cs:209 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-c4a0ed2b | this.Load | FP03590_PDS_Target.cs:210 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-d3fbad1a | this.Load | FP03590_PDS_Target.cs:211 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## FP03590_PDS_Target.Delete_Data_Excel_Buffer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3a23927 | (진입점 미연결) | FP03590_PDS_Target.cs:1688 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP03590_PDS_TARGET") ⇒ FP_Master.PR_UI_FP03590_PDS_TARGET | 엔드포인트 요청 생성 |  |  |  |
| AC-b805b945 | (진입점 미연결) | FP03590_PDS_Target.cs:1689 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-3babbd9f | (진입점 미연결) | FP03590_PDS_Target.cs:1691 | try | DATA_OP | req.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-8e050d5f | (진입점 미연결) | FP03590_PDS_Target.cs:1692 | try | DATA_OP | req.Parameters["p_sys_flag"] | "DELETE_BUFFER" | 행/컬럼 값 대입 |  |  |  |
| AC-7d221b29 | (진입점 미연결) | FP03590_PDS_Target.cs:1693 | try | DATA_OP | req.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3a14a46e | (진입점 미연결) | FP03590_PDS_Target.cs:1694 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-43ea95b7 | (진입점 미연결) | FP03590_PDS_Target.cs:1696 | try | DATA_OP | req.Parameters["p_company_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f2b2fb44 | (진입점 미연결) | FP03590_PDS_Target.cs:1697 | try | DATA_OP | req.Parameters["p_division_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c9c40a05 | (진입점 미연결) | FP03590_PDS_Target.cs:1698 | try | DATA_OP | req.Parameters["p_site_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-153a94a1 | (진입점 미연결) | FP03590_PDS_Target.cs:1699 | try | DATA_OP | req.Parameters["p_plant_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-bae1d342 | (진입점 미연결) | FP03590_PDS_Target.cs:1701 | try | DATA_OP | req.Parameters["p_mfg_start_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6cf82db8 | (진입점 미연결) | FP03590_PDS_Target.cs:1702 | try | DATA_OP | req.Parameters["p_mfg_end_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-69e65d8c | (진입점 미연결) | FP03590_PDS_Target.cs:1703 | try | DATA_OP | req.Parameters["p_item_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9ec8e644 | (진입점 미연결) | FP03590_PDS_Target.cs:1704 | try | DATA_OP | req.Parameters["p_model"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a6cf9e9a | (진입점 미연결) | FP03590_PDS_Target.cs:1705 | try | DATA_OP | req.Parameters["p_nick_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-33aa4611 | (진입점 미연결) | FP03590_PDS_Target.cs:1706 | try | DATA_OP | req.Parameters["p_factory_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e90aa743 | (진입점 미연결) | FP03590_PDS_Target.cs:1707 | try | DATA_OP | req.Parameters["p_operation_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-dc70e8b1 | (진입점 미연결) | FP03590_PDS_Target.cs:1708 | try | DATA_OP | req.Parameters["p_line_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0fcba383 | (진입점 미연결) | FP03590_PDS_Target.cs:1709 | try | DATA_OP | req.Parameters["p_line_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b48c6731 | (진입점 미연결) | FP03590_PDS_Target.cs:1710 | try | DATA_OP | req.Parameters["p_market"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c6ef5520 | (진입점 미연결) | FP03590_PDS_Target.cs:1711 | try | DATA_OP | req.Parameters["p_production_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d9de1259 | (진입점 미연결) | FP03590_PDS_Target.cs:1712 | try | DATA_OP | req.Parameters["p_due_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8eb53416 | (진입점 미연결) | FP03590_PDS_Target.cs:1713 | try | DATA_OP | req.Parameters["p_mfg_week"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a063fc59 | (진입점 미연결) | FP03590_PDS_Target.cs:1714 | try | DATA_OP | req.Parameters["p_mfg_qty"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-080b2de8 | (진입점 미연결) | FP03590_PDS_Target.cs:1715 | try | DATA_OP | req.Parameters["p_is_prev_schedule"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-710b332a | (진입점 미연결) | FP03590_PDS_Target.cs:1716 | try | DATA_OP | req.Parameters["p_demand_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-5d436fbe | (진입점 미연결) | FP03590_PDS_Target.cs:1717 | try | DATA_OP | req.Parameters["p_scp_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a88ec316 | (진입점 미연결) | FP03590_PDS_Target.cs:1718 | try | DATA_OP | req.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9b2e0eb2 | (진입점 미연결) | FP03590_PDS_Target.cs:1719 | try | DATA_OP | req.Parameters["p_test_target_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-557d363c | (진입점 미연결) | FP03590_PDS_Target.cs:1720 | try | DATA_OP | req.Parameters["p_electrode_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-cfa07d2c | (진입점 미연결) | FP03590_PDS_Target.cs:1722 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a16c3290 | (진입점 미연결) | FP03590_PDS_Target.cs:1724 | try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-a8e02c4c | (진입점 미연결) | FP03590_PDS_Target.cs:1728 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP03590_PDS_Target.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab9f3a34 | DeleteButton | FP03590_PDS_Target.cs:503 |  | MESSAGE | MessageBox.Show | ("Delete Button can't use.!") | 메시지 표시 |  |  |  |
| AC-57cc7074 | DeleteButton | FP03590_PDS_Target.cs:504 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP03590_PDS_Target.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bae21f43 | Dispose | FP03590_PDS_Target.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP03590_PDS_Target.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50440579 | EditButton | FP03590_PDS_Target.cs:370 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-a6df498f | EditButton | FP03590_PDS_Target.cs:372 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-f9357999 | EditButton | FP03590_PDS_Target.cs:376 | if (spdMain != null) | FLAG | _bAction | !_bAction | 화면 필드/플래그 변경 |  |  |  |
| AC-b896058b | EditButton | FP03590_PDS_Target.cs:378 | if (spdMain != null) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a4fd4e9b | EditButton | FP03590_PDS_Target.cs:383 | if (spdMain != null) ▸ if (_bAction) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex("DUE_DATE")-1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5b58bbb6 | EditButton | FP03590_PDS_Target.cs:384 | if (spdMain != null) ▸ if (_bAction) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex("MFG_WEEK"), siMain.GetColumnIndex("ACTIVE_FLAG") -1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a623cb7a | EditButton | FP03590_PDS_Target.cs:395 | if (spdMain != null) ▸ if (_bAction) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEditYN.Equals("N")) | GRID_SET | siMain.ActiveSheet.Rows[i, i].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-b13d343e | EditButton | FP03590_PDS_Target.cs:399 | if (spdMain != null) ▸ if (_bAction) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEditYN.Equals("N")) ▸ if… | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.AlternatingRow | 그리드 속성/값 설정 |  |  |  |
| AC-6ccfd50f | EditButton | FP03590_PDS_Target.cs:403 | if (spdMain != null) ▸ if (_bAction) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEditYN.Equals("N")) ▸ el… | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-3b63cb19 | EditButton | FP03590_PDS_Target.cs:410 | if (spdMain != null) ▸ if (_bAction) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sEditYN.Equals("N"))… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex("DUE_DATE"), i, siMain.GetColumnIndex("DUE_DATE"), System.Drawin… | 그리드 표시 설정 |  |  |  |
| AC-3311da8d | EditButton | FP03590_PDS_Target.cs:411 | if (spdMain != null) ▸ if (_bAction) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sEditYN.Equals("N"))… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex("ACTIVE_FLAG"), i, siMain.GetColumnIndex("ACTIVE_FLAG"), System.… | 그리드 표시 설정 |  |  |  |
| AC-27aa6ccb | EditButton | FP03590_PDS_Target.cs:415 | if (spdMain != null) ▸ if (_bAction) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sEditYN.Equals("N"))… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex("DUE_DATE"), i, siMain.GetColumnIndex("DUE_DATE"), System.Drawin… | 그리드 표시 설정 |  |  |  |
| AC-e726808a | EditButton | FP03590_PDS_Target.cs:416 | if (spdMain != null) ▸ if (_bAction) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sEditYN.Equals("N"))… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex("ACTIVE_FLAG"), i, siMain.GetColumnIndex("ACTIVE_FLAG"), System.… | 그리드 표시 설정 |  |  |  |
| AC-af1823d2 | EditButton | FP03590_PDS_Target.cs:430 | if (spdMain != null) ▸ else of (_bAction) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (i % 2 == 1) | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex("DUE_DATE"), i, siMain.GetColumnIndex("DUE_DATE"), ControlColor.… | 그리드 표시 설정 |  |  |  |
| AC-4f2baad9 | EditButton | FP03590_PDS_Target.cs:431 | if (spdMain != null) ▸ else of (_bAction) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (i % 2 == 1) | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex("ACTIVE_FLAG"), i, siMain.GetColumnIndex("ACTIVE_FLAG"), Control… | 그리드 표시 설정 |  |  |  |
| AC-8e4b04d7 | EditButton | FP03590_PDS_Target.cs:435 | if (spdMain != null) ▸ else of (_bAction) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (i % 2 == 1) | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex("DUE_DATE"), i, siMain.GetColumnIndex("DUE_DATE"), ControlColor.… | 그리드 표시 설정 |  |  |  |
| AC-293cbd9f | EditButton | FP03590_PDS_Target.cs:436 | if (spdMain != null) ▸ else of (_bAction) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (i % 2 == 1) | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex("ACTIVE_FLAG"), i, siMain.GetColumnIndex("ACTIVE_FLAG"), Control… | 그리드 표시 설정 |  |  |  |
| AC-2a3403ee | EditButton | FP03590_PDS_Target.cs:442 | if (spdMain != null) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP03590_PDS_Target.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5154f791 | ExcelButton | FP03590_PDS_Target.cs:889 |  | EXCEL | ExportExcel2 | () | 엑셀 내보내기/올리기 |  |  |  |

## FP03590_PDS_Target.ExcelPopup_ImportValidation_Data

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2554b4e9 | (진입점 미연결) | FP03590_PDS_Target.cs:1239 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4da0fec9 | (진입점 미연결) | FP03590_PDS_Target.cs:1241 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["COMPANY_ID"] | data.Tables[0].Rows[i]["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-63a19aa8 | (진입점 미연결) | FP03590_PDS_Target.cs:1242 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["DIVISION_ID"] | data.Tables[0].Rows[i]["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a1ee9e83 | (진입점 미연결) | FP03590_PDS_Target.cs:1243 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["SITE_ID"] | data.Tables[0].Rows[i]["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f5fdf046 | (진입점 미연결) | FP03590_PDS_Target.cs:1244 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PLANT_ID"] | data.Tables[0].Rows[i]["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5ea3ea4a | (진입점 미연결) | FP03590_PDS_Target.cs:1245 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["TEST_TARGET_ID"] | data.Tables[0].Rows[i]["TEST_TARGET_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7597d4a6 | (진입점 미연결) | FP03590_PDS_Target.cs:1246 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["MODEL"] | data.Tables[0].Rows[i]["MODEL"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5b35adee | (진입점 미연결) | FP03590_PDS_Target.cs:1247 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["ITEM_ID"] | data.Tables[0].Rows[i]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a529883a | (진입점 미연결) | FP03590_PDS_Target.cs:1248 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["FACTORY_ID"] | data.Tables[0].Rows[i]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-612fef2f | (진입점 미연결) | FP03590_PDS_Target.cs:1249 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["OPERATION_ID"] | data.Tables[0].Rows[i]["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bc42ab15 | (진입점 미연결) | FP03590_PDS_Target.cs:1250 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["LINE_ID"] | data.Tables[0].Rows[i]["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b5ade4e0 | (진입점 미연결) | FP03590_PDS_Target.cs:1251 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["MARKET"] | data.Tables[0].Rows[i]["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-72c42fde | (진입점 미연결) | FP03590_PDS_Target.cs:1252 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["PRODUCTION_TYPE"] | data.Tables[0].Rows[i]["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2fb6f7bf | (진입점 미연결) | FP03590_PDS_Target.cs:1253 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["DUE_DATE"] | data.Tables[0].Rows[i]["DUE_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2ea91455 | (진입점 미연결) | FP03590_PDS_Target.cs:1254 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["MFG_WEEK"] | data.Tables[0].Rows[i]["MFG_WEEK"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d581344e | (진입점 미연결) | FP03590_PDS_Target.cs:1255 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["MFG_QTY"] | data.Tables[0].Rows[i]["MFG_QTY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-36a9c338 | (진입점 미연결) | FP03590_PDS_Target.cs:1256 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["DESCRIPTION"] | data.Tables[0].Rows[i]["DESCRIPTION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c525f178 | (진입점 미연결) | FP03590_PDS_Target.cs:1257 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["NICK_NAME"] | data.Tables[0].Rows[i]["NICK_NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-96e83c57 | (진입점 미연결) | FP03590_PDS_Target.cs:1258 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["IS_PREV_SCHEDULE"] | data.Tables[0].Rows[i]["IS_PREV_SCHEDULE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6a0a8ea9 | (진입점 미연결) | FP03590_PDS_Target.cs:1259 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["DEMAND_TYPE"] | data.Tables[0].Rows[i]["DEMAND_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d584352d | (진입점 미연결) | FP03590_PDS_Target.cs:1260 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | newrow["SCP_PLAN_ID"] | data.Tables[0].Rows[i]["SCP_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-518340ee | (진입점 미연결) | FP03590_PDS_Target.cs:1264 | try ▸ for (i < data.Tables[0].Rows.Count) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-edd5e557 | (진입점 미연결) | FP03590_PDS_Target.cs:1267 | try | DATA_OP | dsSaveData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-57a652cb | (진입점 미연결) | FP03590_PDS_Target.cs:1285 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString().Equals("SUCCESS")) ▸ if (dsValidation.Tables[0].Rows… | DATA_OP | each_row.Field | ("_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-260b7724 | (진입점 미연결) | FP03590_PDS_Target.cs:1290 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString().Equals("SUCCESS")) ▸ if (dsValidation.Tables[0].Rows… | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a0f1f7ed | (진입점 미연결) | FP03590_PDS_Target.cs:1292 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString().Equals("SUCCESS")) ▸ if (dsValidation.Tables[0].Rows… | DATA_OP | dsResult.Tables.Add | (dtVal2) | 데이터 객체 조작/조회 |  |  |  |
| AC-91c9809e | (진입점 미연결) | FP03590_PDS_Target.cs:1295 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString().Equals("SUCCESS")) ▸ if (dsValidation.Tables[0].Rows… | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-ccf17d54 | (진입점 미연결) | FP03590_PDS_Target.cs:1304 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString().Equals("SUCCESS")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-14a4e906 | (진입점 미연결) | FP03590_PDS_Target.cs:1305 | try ▸ if (dsSaveData.Tables[0].Rows.Count > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString().Equals("SUCCESS")) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-87cca391 | (진입점 미연결) | FP03590_PDS_Target.cs:1310 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-5614fdb0 | (진입점 미연결) | FP03590_PDS_Target.cs:1315 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d4a66dc1 | (진입점 미연결) | FP03590_PDS_Target.cs:1316 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03590_PDS_Target.ExcelPopup_SaveExcel_Data

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7aae32f | (진입점 미연결) | FP03590_PDS_Target.cs:1525 | if (data.Tables[0].Rows.Count > 0) ▸ if (data != null) ▸ if (ds1.Tables[0].Rows[0][0].ToString() != "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "SAVE ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-79fbd7dc | (진입점 미연결) | FP03590_PDS_Target.cs:1526 | if (data.Tables[0].Rows.Count > 0) ▸ if (data != null) ▸ if (ds1.Tables[0].Rows[0][0].ToString() != "SUCCESS") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-6ca37e6b | (진입점 미연결) | FP03590_PDS_Target.cs:1531 |  | RETURN | return ds1; |  | 처리 중단/반환 |  |  |  |

## FP03590_PDS_Target.ExcelPopup_Search_Data

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09e85391 | (진입점 미연결) | FP03590_PDS_Target.cs:1131 | if (popup != null) | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |
| AC-1a846137 | (진입점 미연결) | FP03590_PDS_Target.cs:1133 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03590_PDS_Target.Find_Data

진입점: FindButton / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3c379c9 | FindButton 외 1 | FP03590_PDS_Target.cs:527 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ba9cc150 | FindButton 외 1 | FP03590_PDS_Target.cs:532 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b09250d4 | FindButton 외 1 | FP03590_PDS_Target.cs:533 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5e502974 | FindButton 외 1 | FP03590_PDS_Target.cs:536 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-8f9e9dfc | FindButton 외 1 | FP03590_PDS_Target.cs:539 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8979e944 | FindButton 외 1 | FP03590_PDS_Target.cs:542 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-f99adf5c | FindButton 외 1 | FP03590_PDS_Target.cs:542 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9d9cece0 | FindButton 외 1 | FP03590_PDS_Target.cs:548 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-8b10cb59 | FindButton 외 1 | FP03590_PDS_Target.cs:551 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9f4c9206 | FindButton 외 1 | FP03590_PDS_Target.cs:558 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-769a11d5 | FindButton 외 1 | FP03590_PDS_Target.cs:559 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Line("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bc60902d | FindButton 외 1 | FP03590_PDS_Target.cs:569 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-dfbc8904 | FindButton 외 1 | FP03590_PDS_Target.cs:571 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b00d6e1d | FindButton 외 1 | FP03590_PDS_Target.cs:574 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-895472ac | FindButton 외 1 | FP03590_PDS_Target.cs:576 | try | FLAG | _bAction | false | 화면 필드/플래그 변경 |  |  |  |
| AC-da7c2f16 | FindButton 외 1 | FP03590_PDS_Target.cs:579 | try | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5cb8cb30 | FindButton 외 1 | FP03590_PDS_Target.cs:587 | try | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-27a37bdf | FindButton 외 1 | FP03590_PDS_Target.cs:593 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-07845261 | FindButton 외 1 | FP03590_PDS_Target.cs:594 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-73491790 | FindButton 외 1 | FP03590_PDS_Target.cs:595 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-5c41a72e | FindButton 외 1 | FP03590_PDS_Target.cs:596 | finally | GRID_SET | this.spdMain.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-51d491d9 | FindButton 외 1 | FP03590_PDS_Target.cs:596 | finally | CALL_EXT | this.spdMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FP03590_PDS_Target.Find_Data_Excel_Buffer_Valid

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-193c7c14 | (진입점 미연결) | FP03590_PDS_Target.cs:1460 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP03590_PDS_TARGET") ⇒ FP_Master.PR_UI_FP03590_PDS_TARGET | 엔드포인트 요청 생성 |  |  |  |
| AC-22993a52 | (진입점 미연결) | FP03590_PDS_Target.cs:1461 | try | UI_PROP | request.CommandTimeout | 5 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-94ba8fb5 | (진입점 미연결) | FP03590_PDS_Target.cs:1462 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-464373e9 | (진입점 미연결) | FP03590_PDS_Target.cs:1463 | try | DATA_OP | request.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-76ececcd | (진입점 미연결) | FP03590_PDS_Target.cs:1464 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dc2da20a | (진입점 미연결) | FP03590_PDS_Target.cs:1465 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2cde1f60 | (진입점 미연결) | FP03590_PDS_Target.cs:1467 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-32d9a355 | (진입점 미연결) | FP03590_PDS_Target.cs:1468 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f1cc2742 | (진입점 미연결) | FP03590_PDS_Target.cs:1469 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-904c3e92 | (진입점 미연결) | FP03590_PDS_Target.cs:1470 | try | DATA_OP | request.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-52728146 | (진입점 미연결) | FP03590_PDS_Target.cs:1471 | try | DATA_OP | request.Parameters["p_mfg_start_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-89c8c223 | (진입점 미연결) | FP03590_PDS_Target.cs:1472 | try | DATA_OP | request.Parameters["p_mfg_end_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-56970aa8 | (진입점 미연결) | FP03590_PDS_Target.cs:1473 | try | DATA_OP | request.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-719e746a | (진입점 미연결) | FP03590_PDS_Target.cs:1474 | try | DATA_OP | request.Parameters["p_model"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c0e432a8 | (진입점 미연결) | FP03590_PDS_Target.cs:1475 | try | DATA_OP | request.Parameters["p_nick_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a856fdba | (진입점 미연결) | FP03590_PDS_Target.cs:1476 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5f76ec9e | (진입점 미연결) | FP03590_PDS_Target.cs:1477 | try | DATA_OP | request.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-46bf7c99 | (진입점 미연결) | FP03590_PDS_Target.cs:1478 | try | DATA_OP | request.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-edaefe38 | (진입점 미연결) | FP03590_PDS_Target.cs:1479 | try | DATA_OP | request.Parameters["p_line_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ffa6e0ab | (진입점 미연결) | FP03590_PDS_Target.cs:1480 | try | DATA_OP | request.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dbd6def3 | (진입점 미연결) | FP03590_PDS_Target.cs:1481 | try | DATA_OP | request.Parameters["p_production_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b157ff7b | (진입점 미연결) | FP03590_PDS_Target.cs:1482 | try | DATA_OP | request.Parameters["p_due_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-70449b49 | (진입점 미연결) | FP03590_PDS_Target.cs:1483 | try | DATA_OP | request.Parameters["p_mfg_week"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f16b4cfa | (진입점 미연결) | FP03590_PDS_Target.cs:1484 | try | DATA_OP | request.Parameters["p_mfg_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f432aeeb | (진입점 미연결) | FP03590_PDS_Target.cs:1485 | try | DATA_OP | request.Parameters["p_is_prev_schedule"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-395abc47 | (진입점 미연결) | FP03590_PDS_Target.cs:1486 | try | DATA_OP | request.Parameters["p_demand_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1ebc5246 | (진입점 미연결) | FP03590_PDS_Target.cs:1487 | try | DATA_OP | request.Parameters["p_scp_plan_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0627bb41 | (진입점 미연결) | FP03590_PDS_Target.cs:1488 | try | DATA_OP | request.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9a2e7e5b | (진입점 미연결) | FP03590_PDS_Target.cs:1489 | try | DATA_OP | request.Parameters["p_test_target_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3f106b31 | (진입점 미연결) | FP03590_PDS_Target.cs:1490 | try | DATA_OP | request.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6397d4c1 | (진입점 미연결) | FP03590_PDS_Target.cs:1492 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-73fc235f | (진입점 미연결) | FP03590_PDS_Target.cs:1494 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-58c35314 | (진입점 미연결) | FP03590_PDS_Target.cs:1500 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03590_PDS_Target.Find_Data_Import

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc8ced27 | (진입점 미연결) | FP03590_PDS_Target.cs:1147 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { p_division_id = CString.GetCheckedListValue(dtMyDivision,… | ⚠ 의미 확인 필요 |  |  |  |
| AC-13270a86 | (진입점 미연결) | FP03590_PDS_Target.cs:1162 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP03590_PDS_TARGET") ⇒ FP_Master.PR_UI_FP03590_PDS_TARGET | 엔드포인트 요청 생성 |  |  |  |
| AC-5163e1de | (진입점 미연결) | FP03590_PDS_Target.cs:1164 | try | UI_PROP | request.CommandTimeout | 5 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-272e8fae | (진입점 미연결) | FP03590_PDS_Target.cs:1165 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-cd229a21 | (진입점 미연결) | FP03590_PDS_Target.cs:1166 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_IMPORT" | 행/컬럼 값 대입 |  |  |  |
| AC-5b1841c1 | (진입점 미연결) | FP03590_PDS_Target.cs:1167 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7f382099 | (진입점 미연결) | FP03590_PDS_Target.cs:1168 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-157fbcf5 | (진입점 미연결) | FP03590_PDS_Target.cs:1170 | try | DATA_OP | request.Parameters["p_company_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7e3eb5fa | (진입점 미연결) | FP03590_PDS_Target.cs:1171 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-31f64dbf | (진입점 미연결) | FP03590_PDS_Target.cs:1172 | try | DATA_OP | request.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-018c0e7c | (진입점 미연결) | FP03590_PDS_Target.cs:1173 | try | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-cbb67db2 | (진입점 미연결) | FP03590_PDS_Target.cs:1175 | try | DATA_OP | request.Parameters["p_mfg_start_date"] | p_mfg_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-8aa5f0d9 | (진입점 미연결) | FP03590_PDS_Target.cs:1176 | try | DATA_OP | request.Parameters["p_mfg_end_date"] | p_mfg_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-bbce04a3 | (진입점 미연결) | FP03590_PDS_Target.cs:1177 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-a199ae3e | (진입점 미연결) | FP03590_PDS_Target.cs:1178 | try | DATA_OP | request.Parameters["p_model"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e1270b05 | (진입점 미연결) | FP03590_PDS_Target.cs:1179 | try | DATA_OP | request.Parameters["p_nick_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1ad66c8d | (진입점 미연결) | FP03590_PDS_Target.cs:1180 | try | DATA_OP | request.Parameters["p_factory_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-79a442ba | (진입점 미연결) | FP03590_PDS_Target.cs:1181 | try | DATA_OP | request.Parameters["p_operation_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2c16d2e5 | (진입점 미연결) | FP03590_PDS_Target.cs:1182 | try | DATA_OP | request.Parameters["p_line_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1d97b22e | (진입점 미연결) | FP03590_PDS_Target.cs:1183 | try | DATA_OP | request.Parameters["p_line_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-483e2bf7 | (진입점 미연결) | FP03590_PDS_Target.cs:1184 | try | DATA_OP | request.Parameters["p_market"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-360865c2 | (진입점 미연결) | FP03590_PDS_Target.cs:1185 | try | DATA_OP | request.Parameters["p_production_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7bd7b724 | (진입점 미연결) | FP03590_PDS_Target.cs:1186 | try | DATA_OP | request.Parameters["p_due_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-bc0fa875 | (진입점 미연결) | FP03590_PDS_Target.cs:1187 | try | DATA_OP | request.Parameters["p_mfg_week"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-31028558 | (진입점 미연결) | FP03590_PDS_Target.cs:1188 | try | DATA_OP | request.Parameters["p_mfg_qty"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c940751b | (진입점 미연결) | FP03590_PDS_Target.cs:1189 | try | DATA_OP | request.Parameters["p_is_prev_schedule"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8ff10c90 | (진입점 미연결) | FP03590_PDS_Target.cs:1190 | try | DATA_OP | request.Parameters["p_demand_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-18351504 | (진입점 미연결) | FP03590_PDS_Target.cs:1191 | try | DATA_OP | request.Parameters["p_scp_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0e7b9048 | (진입점 미연결) | FP03590_PDS_Target.cs:1192 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f6cee429 | (진입점 미연결) | FP03590_PDS_Target.cs:1193 | try | DATA_OP | request.Parameters["p_test_target_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c072374e | (진입점 미연결) | FP03590_PDS_Target.cs:1194 | try | DATA_OP | request.Parameters["p_electrode_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1b453028 | (진입점 미연결) | FP03590_PDS_Target.cs:1196 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ed24dc32 | (진입점 미연결) | FP03590_PDS_Target.cs:1198 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-addecf9e | (진입점 미연결) | FP03590_PDS_Target.cs:1203 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03590_PDS_Target.Find_Data_Line

진입점: popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] / FindButton [try ▸ lambda] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71fd845c | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:611 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { p_division_id = CString.GetCheckedListValue(dtMyDivision,… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b44055ca | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:626 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP03590_PDS_TARGET") ⇒ FP_Master.PR_UI_FP03590_PDS_TARGET | 엔드포인트 요청 생성 |  |  |  |
| AC-82fb6b46 | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:628 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-cf59069e | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:629 | try | DATA_OP | request.Parameters["p_sys_flag"] | "S" | 행/컬럼 값 대입 |  |  |  |
| AC-79e9a161 | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:630 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a3be8e09 | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:631 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-373a07ff | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:632 | try | DATA_OP | request.Parameters["p_company_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e9ee90e9 | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:633 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-894c0011 | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:634 | try | DATA_OP | request.Parameters["p_site_id"] | p_site_id.Equals("ALL") ? DBNull.Value : p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-d6333e47 | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:635 | try | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id.Equals("ALL") ? DBNull.Value : p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-a3948cab | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:636 | try | DATA_OP | request.Parameters["p_due_start_date"] | p_due_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-83fe9bb0 | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:637 | try | DATA_OP | request.Parameters["p_due_end_date"] | p_due_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-b8298b30 | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:638 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-fe72adb3 | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:639 | try | DATA_OP | request.Parameters["p_model"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-423967c1 | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:640 | try | DATA_OP | request.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-6855b1dc | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:641 | try | DATA_OP | request.Parameters["p_factory_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a2036992 | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:642 | try | DATA_OP | request.Parameters["p_operation_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-10bebd7f | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:643 | try | DATA_OP | request.Parameters["p_line_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7d09cc23 | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:644 | try | DATA_OP | request.Parameters["p_line_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0d4512a5 | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:645 | try | DATA_OP | request.Parameters["p_market"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ab1d8f0b | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:646 | try | DATA_OP | request.Parameters["p_production_type"] | p_production_type | 행/컬럼 값 대입 |  |  |  |
| AC-498c7a42 | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:647 | try | DATA_OP | request.Parameters["p_due_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-55cf73c3 | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:648 | try | DATA_OP | request.Parameters["p_mfg_week"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6b3a7323 | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:649 | try | DATA_OP | request.Parameters["p_mfg_qty"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-52a78d37 | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:650 | try | DATA_OP | request.Parameters["p_is_prev_schedule"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ec2128ed | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:651 | try | DATA_OP | request.Parameters["p_demand_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-14e32637 | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:652 | try | DATA_OP | request.Parameters["p_scp_plan_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f1323bb1 | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:653 | try | DATA_OP | request.Parameters["p_description"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ee4fc995 | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:654 | try | DATA_OP | request.Parameters["p_test_target_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-48f66a31 | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:655 | try | DATA_OP | request.Parameters["p_electrode_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1961356a | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:656 | try | DATA_OP | request.Parameters["p_active_flag"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6897e2f9 | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:658 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-75a3bdfd | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:660 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-af780190 | popSql.OnSql [if (programID == "PR_UI_FP03590_PDS_TARGET")] 외 2 | FP03590_PDS_Target.cs:665 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03590_PDS_Target.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb6fe88d | this.Load | FP03590_PDS_Target.cs:123 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP03590_PDS_Target.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4579532 | this.Load | FP03590_PDS_Target.cs:144 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-7a9dc546 | this.Load | FP03590_PDS_Target.cs:150 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-e49294df | this.Load | FP03590_PDS_Target.cs:151 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-38613dfc | this.Load | FP03590_PDS_Target.cs:156 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-7453f52f | this.Load | FP03590_PDS_Target.cs:158 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-b3ccbfb8 | this.Load | FP03590_PDS_Target.cs:163 | try | FLAG | dtMFGDate | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP03590_findMFGDate") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-0e1ed229 | this.Load | FP03590_PDS_Target.cs:163 | try | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP03590_findMFGDate") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9db04640 | this.Load | FP03590_PDS_Target.cs:166 | try ▸ if (dtMFGDate.Rows.Count > 0) | VALUE_SET | drpPeriod.InitValue | dtMFGDate.Rows[0]["MIN_DATE"].ToString() + ":" + dtMFGDate.Rows[0]["MAX_DATE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-6b87e4a3 | this.Load | FP03590_PDS_Target.cs:170 | try | FLAG | dtMyDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-8c3a2a50 | this.Load | FP03590_PDS_Target.cs:170 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e3497b6b | this.Load | FP03590_PDS_Target.cs:172 | try ▸ if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-1b51cd20 | this.Load | FP03590_PDS_Target.cs:174 | try | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-e2203aaf | this.Load | FP03590_PDS_Target.cs:183 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-d4d72bff | this.Load | FP03590_PDS_Target.cs:184 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-aebe0499 | this.Load | FP03590_PDS_Target.cs:185 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-509bdcab | this.Load | FP03590_PDS_Target.cs:191 | try | STATE | btnImport.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-e11054d5 | this.Load | FP03590_PDS_Target.cs:192 | try | STATE | btnImport.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-40fa5a42 | this.Load | FP03590_PDS_Target.cs:193 | try | UI_PROP | lblExcelImport.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-bd4ce318 | this.Load | FP03590_PDS_Target.cs:200 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP03590_PDS_Target.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab085f80 | this.Load | FP03590_PDS_Target.cs:258 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-6abca568 | this.Load | FP03590_PDS_Target.cs:259 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP03590_PDS_Target.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0925351 | this.Load | FP03590_PDS_Target.cs:310 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4c8b2331 | this.Load | FP03590_PDS_Target.cs:311 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-dd059899 | this.Load | FP03590_PDS_Target.cs:315 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP03590_PDS_Target.Insert_Data_Excel_Buffer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60bccf3f | (진입점 미연결) | FP03590_PDS_Target.cs:1403 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP03590_PDS_TARGET") ⇒ FP_Master.PR_UI_FP03590_PDS_TARGET | 엔드포인트 요청 생성 |  |  |  |
| AC-58e0a87d | (진입점 미연결) | FP03590_PDS_Target.cs:1404 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d9ad8514 | (진입점 미연결) | FP03590_PDS_Target.cs:1406 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-c103108e | (진입점 미연결) | FP03590_PDS_Target.cs:1407 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-891f2f38 | (진입점 미연결) | FP03590_PDS_Target.cs:1408 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-340b42a4 | (진입점 미연결) | FP03590_PDS_Target.cs:1409 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-550ae3dd | (진입점 미연결) | FP03590_PDS_Target.cs:1411 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-1207cd12 | (진입점 미연결) | FP03590_PDS_Target.cs:1412 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-068af4b1 | (진입점 미연결) | FP03590_PDS_Target.cs:1413 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-cc5378ea | (진입점 미연결) | FP03590_PDS_Target.cs:1414 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-cddbcc5a | (진입점 미연결) | FP03590_PDS_Target.cs:1416 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_start_date"] | p_mfg_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-c072d478 | (진입점 미연결) | FP03590_PDS_Target.cs:1417 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_end_date"] | p_mfg_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-b5078911 | (진입점 미연결) | FP03590_PDS_Target.cs:1418 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-cf5349ad | (진입점 미연결) | FP03590_PDS_Target.cs:1419 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_model"] | p_model | 행/컬럼 값 대입 |  |  |  |
| AC-9a5c7afe | (진입점 미연결) | FP03590_PDS_Target.cs:1420 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-e4c23476 | (진입점 미연결) | FP03590_PDS_Target.cs:1421 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-99e0bc3c | (진입점 미연결) | FP03590_PDS_Target.cs:1422 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-62f2450f | (진입점 미연결) | FP03590_PDS_Target.cs:1423 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-333830c3 | (진입점 미연결) | FP03590_PDS_Target.cs:1424 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_name"] | p_line_name | 행/컬럼 값 대입 |  |  |  |
| AC-7e6ef94e | (진입점 미연결) | FP03590_PDS_Target.cs:1425 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-96bcdac8 | (진입점 미연결) | FP03590_PDS_Target.cs:1426 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_production_type"] | p_production_type | 행/컬럼 값 대입 |  |  |  |
| AC-9757f5f2 | (진입점 미연결) | FP03590_PDS_Target.cs:1427 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_due_date"] | p_due_date | 행/컬럼 값 대입 |  |  |  |
| AC-1cc3d493 | (진입점 미연결) | FP03590_PDS_Target.cs:1428 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_week"] | p_mfg_week | 행/컬럼 값 대입 |  |  |  |
| AC-ee7a9e61 | (진입점 미연결) | FP03590_PDS_Target.cs:1429 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_qty"] | p_mfg_qty | 행/컬럼 값 대입 |  |  |  |
| AC-70e4be0d | (진입점 미연결) | FP03590_PDS_Target.cs:1430 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_is_prev_schedule"] | p_is_prev_schedule | 행/컬럼 값 대입 |  |  |  |
| AC-d0ef4a33 | (진입점 미연결) | FP03590_PDS_Target.cs:1431 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_demand_type"] | p_demand_type | 행/컬럼 값 대입 |  |  |  |
| AC-79886a77 | (진입점 미연결) | FP03590_PDS_Target.cs:1432 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_scp_plan_id"] | p_scp_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-7cded812 | (진입점 미연결) | FP03590_PDS_Target.cs:1433 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-e8d5f350 | (진입점 미연결) | FP03590_PDS_Target.cs:1434 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_test_target_id"] | p_test_target_id | 행/컬럼 값 대입 |  |  |  |
| AC-5751a7e2 | (진입점 미연결) | FP03590_PDS_Target.cs:1435 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-5becfc64 | (진입점 미연결) | FP03590_PDS_Target.cs:1437 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bcd63615 | (진입점 미연결) | FP03590_PDS_Target.cs:1443 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-8b77b9b4 | (진입점 미연결) | FP03590_PDS_Target.cs:1447 | catch ((Exception ex)) | POPUP | FoxMessageBox.Show | (ex.Message) | 팝업/폼 열기 |  |  |  |
| AC-ea49ec6f | (진입점 미연결) | FP03590_PDS_Target.cs:1449 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP03590_PDS_Target.Insert_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11cfe859 | (진입점 미연결) | FP03590_PDS_Target.cs:675 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f7698d0c | (진입점 미연결) | FP03590_PDS_Target.cs:684 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.IS_PREV_SCHEDULE, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-ac92a413 | (진입점 미연결) | FP03590_PDS_Target.cs:686 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-808b6d30 | (진입점 미연결) | FP03590_PDS_Target.cs:688 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |

## FP03590_PDS_Target.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48868ff9 | popSql.OnSql | FP03590_PDS_Target.cs:1081 | if (programID == "PR_UI_FP03590_PDS_TARGET") | RETURN | return Find_Data_Line("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-4bde0dd1 | popSql.OnSql | FP03590_PDS_Target.cs:1087 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03590_PDS_Target.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-765d8ee3 | SaveButton | FP03590_PDS_Target.cs:696 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b45cd58c | SaveButton | FP03590_PDS_Target.cs:698 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9c75914a | SaveButton | FP03590_PDS_Target.cs:702 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a875619c | SaveButton | FP03590_PDS_Target.cs:703 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cd175c61 | SaveButton | FP03590_PDS_Target.cs:706 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-4af0bd26 | SaveButton | FP03590_PDS_Target.cs:713 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-fcaf0ccf | SaveButton | FP03590_PDS_Target.cs:715 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5de540e7 | SaveButton | FP03590_PDS_Target.cs:716 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-99d8641e | SaveButton | FP03590_PDS_Target.cs:721 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6fbb09bf | SaveButton | FP03590_PDS_Target.cs:726 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-250a0c1f | SaveButton | FP03590_PDS_Target.cs:735 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-279a6a91 | SaveButton | FP03590_PDS_Target.cs:739 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f99a776b | SaveButton | FP03590_PDS_Target.cs:743 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7fd0beac | SaveButton | FP03590_PDS_Target.cs:744 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-caa9a439 | SaveButton | FP03590_PDS_Target.cs:749 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP03590_PDS_Target.Save_Data_Excel_Import

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74ac3df4 | (진입점 미연결) | FP03590_PDS_Target.cs:1572 | try ▸ if (string.IsNullOrEmpty(pSysFlag)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e4cdcad5 | (진입점 미연결) | FP03590_PDS_Target.cs:1620 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP03590_PDS_TARGET") ⇒ FP_Master.PR_UI_FP03590_PDS_TARGET | 엔드포인트 요청 생성 |  |  |  |
| AC-79d3931c | (진입점 미연결) | FP03590_PDS_Target.cs:1621 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b54bda7f | (진입점 미연결) | FP03590_PDS_Target.cs:1623 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-5ae6963e | (진입점 미연결) | FP03590_PDS_Target.cs:1624 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-5c629ff0 | (진입점 미연결) | FP03590_PDS_Target.cs:1625 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-c3a4c019 | (진입점 미연결) | FP03590_PDS_Target.cs:1626 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-d37fbeca | (진입점 미연결) | FP03590_PDS_Target.cs:1628 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-a96723f1 | (진입점 미연결) | FP03590_PDS_Target.cs:1629 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-23e72755 | (진입점 미연결) | FP03590_PDS_Target.cs:1630 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-58a08891 | (진입점 미연결) | FP03590_PDS_Target.cs:1631 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-97a0c834 | (진입점 미연결) | FP03590_PDS_Target.cs:1633 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_start_date"] | p_mfg_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-b604f0e9 | (진입점 미연결) | FP03590_PDS_Target.cs:1634 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_end_date"] | p_mfg_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-fce58150 | (진입점 미연결) | FP03590_PDS_Target.cs:1635 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-d4850a40 | (진입점 미연결) | FP03590_PDS_Target.cs:1636 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_model"] | p_model | 행/컬럼 값 대입 |  |  |  |
| AC-071c9ed3 | (진입점 미연결) | FP03590_PDS_Target.cs:1637 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-7884cc85 | (진입점 미연결) | FP03590_PDS_Target.cs:1638 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-f5878d6e | (진입점 미연결) | FP03590_PDS_Target.cs:1639 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-dc36e16b | (진입점 미연결) | FP03590_PDS_Target.cs:1640 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-c5bfd9b9 | (진입점 미연결) | FP03590_PDS_Target.cs:1641 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_name"] | p_line_name | 행/컬럼 값 대입 |  |  |  |
| AC-efee2be6 | (진입점 미연결) | FP03590_PDS_Target.cs:1642 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-160579c6 | (진입점 미연결) | FP03590_PDS_Target.cs:1643 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_production_type"] | p_production_type | 행/컬럼 값 대입 |  |  |  |
| AC-7616f89c | (진입점 미연결) | FP03590_PDS_Target.cs:1644 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_due_date"] | p_due_date | 행/컬럼 값 대입 |  |  |  |
| AC-37311964 | (진입점 미연결) | FP03590_PDS_Target.cs:1645 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_week"] | p_mfg_week | 행/컬럼 값 대입 |  |  |  |
| AC-7d535e37 | (진입점 미연결) | FP03590_PDS_Target.cs:1646 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_qty"] | p_mfg_qty | 행/컬럼 값 대입 |  |  |  |
| AC-23d34760 | (진입점 미연결) | FP03590_PDS_Target.cs:1647 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_is_prev_schedule"] | p_is_prev_schedule | 행/컬럼 값 대입 |  |  |  |
| AC-521105b7 | (진입점 미연결) | FP03590_PDS_Target.cs:1648 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_demand_type"] | p_demand_type | 행/컬럼 값 대입 |  |  |  |
| AC-7da2358d | (진입점 미연결) | FP03590_PDS_Target.cs:1649 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_scp_plan_id"] | p_scp_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-eaefeeab | (진입점 미연결) | FP03590_PDS_Target.cs:1650 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-9a891c54 | (진입점 미연결) | FP03590_PDS_Target.cs:1651 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_test_target_id"] | p_test_target_id | 행/컬럼 값 대입 |  |  |  |
| AC-27697d51 | (진입점 미연결) | FP03590_PDS_Target.cs:1652 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-c61eb810 | (진입점 미연결) | FP03590_PDS_Target.cs:1655 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4480e382 | (진입점 미연결) | FP03590_PDS_Target.cs:1656 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-a2fa4acb | (진입점 미연결) | FP03590_PDS_Target.cs:1662 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-ee6ac562 | (진입점 미연결) | FP03590_PDS_Target.cs:1668 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03590_PDS_Target.Save_Data_PDS

진입점: SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b17c515 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:835 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP03590_PDS_TARGET") ⇒ FP_Master.PR_UI_FP03590_PDS_TARGET | 엔드포인트 요청 생성 |  |  |  |
| AC-4a82d2bb | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:836 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-e0c38e57 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:838 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-b1c54364 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:839 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-7278ce15 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:840 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-a92d79c3 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:841 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-7883870c | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:842 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-f727fe1c | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:843 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-adc80682 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:844 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-a1f0eeb8 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:845 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-67f7a5e5 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:846 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_due_start_date"] | p_due_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-86dc9d64 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:847 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_due_end_date"] | p_due_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-a892cfb3 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:848 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-eb632a21 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:849 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_model"] | p_model | 행/컬럼 값 대입 |  |  |  |
| AC-99037c66 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:850 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-b91a6f68 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:851 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-e67a3ca2 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:852 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-988cbbff | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:853 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-79719977 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:854 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_name"] | p_line_name | 행/컬럼 값 대입 |  |  |  |
| AC-78ca14f0 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:855 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-cd56d82d | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:856 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_production_type"] | p_production_type | 행/컬럼 값 대입 |  |  |  |
| AC-a3695569 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:857 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_due_date"] | p_due_date | 행/컬럼 값 대입 |  |  |  |
| AC-1ab58963 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:858 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_week"] | p_mfg_week | 행/컬럼 값 대입 |  |  |  |
| AC-c84245f9 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:859 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_qty"] | p_mfg_qty | 행/컬럼 값 대입 |  |  |  |
| AC-ed2caf69 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:860 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_is_prev_schedule"] | p_is_prev_schedule | 행/컬럼 값 대입 |  |  |  |
| AC-d0bd4140 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:861 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_demand_type"] | p_demand_type | 행/컬럼 값 대입 |  |  |  |
| AC-5378c4e6 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:862 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_scp_plan_id"] | p_scp_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-50e92eb4 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:863 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-8dbeffa8 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:864 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_test_target_id"] | p_test_target_id | 행/컬럼 값 대입 |  |  |  |
| AC-3af21279 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:865 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-304fc113 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:866 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-efda9a6b | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:868 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e413e432 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:869 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-28f6c345 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:875 | try ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00071") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bd631a3e | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:876 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-a5faaa3f | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP03590_PDS_Target.cs:882 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP03590_PDS_Target.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de550ee2 | SaveButton | FP03590_PDS_Target.cs:510 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP03590_PDS_Target.SetChangedControl

진입점: this.Load [try] / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c5ab967 | this.Load [try] 외 1 | FP03590_PDS_Target.cs:236 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-2ba53558 | this.Load [try] 외 1 | FP03590_PDS_Target.cs:238 | try | FLAG | dtSiteByDivision | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, "", "", "", ""… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-044a2bc3 | this.Load [try] 외 1 | FP03590_PDS_Target.cs:238 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, "", "", "", "", "", "", pDivisi… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-52a34bdd | this.Load [try] 외 1 | FP03590_PDS_Target.cs:239 | try | LIST_REBIND | clsCtrl.setListBox | (dtSiteByDivision, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-e3f46a35 | this.Load [try] 외 1 | FP03590_PDS_Target.cs:243 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-65591e6f | this.Load [try] 외 1 | FP03590_PDS_Target.cs:245 | try | FLAG | dtPlantByDivision | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-76497ad6 | this.Load [try] 외 1 | FP03590_PDS_Target.cs:245 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-62c5a127 | this.Load [try] 외 1 | FP03590_PDS_Target.cs:246 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantByDivision, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e45c4c5c | this.Load [try] 외 1 | FP03590_PDS_Target.cs:250 | catch ((Exception ex)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP03590_PDS_Target.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-faebbf0e | this.Load [try] | FP03590_PDS_Target.cs:324 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5aebb794 | this.Load [try] | FP03590_PDS_Target.cs:325 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-761b6959 | this.Load [try] | FP03590_PDS_Target.cs:330 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP03590_PDS_Target.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0efea512 | this.spdMain.CellClick | FP03590_PDS_Target.cs:1065 | if (siMain.GetMaxRowIndex() < 0) | FLAG | iClickRow | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-17643530 | this.spdMain.CellClick | FP03590_PDS_Target.cs:1067 | else of (siMain.GetMaxRowIndex() < 0) | FLAG | iClickRow | e.Row | 화면 필드/플래그 변경 |  |  |  |

