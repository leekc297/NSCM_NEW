# DMF0052 소스 링크 표

## 1. 엔드포인트 호출 지점
| 파일 | 메서드 | 줄 | 엔드포인트 | SP |
|---|---|---:|---|---|
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs | FindData_Main | 312 | DM.DMF0052_GET_SUMMARY_DATA | DMF0052_GET_SUMMARY_DATA |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs | FindData_Pjt | 355 | DM.DMF0052_GET_PJT_DATA | DMF0052_GET_PJT_DATA |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs | FindData_Status | 418 | DM.DMF0052_GET_STATUS_DATA | DMF0052_GET_STATUS_DATA |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs | FindData_GSCMData | 460 | DM.DMF0052_GET_DETAIL_DATA | DMF0052_GET_DETAIL_DATA |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs | FindData_ERPData | 529 | DM.DMF0052_GET_ERP_DATA | DMF0052_GET_ERP_DATA |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs | GetSpdTitle | 696 | DM.DMF0052_GET_SPREAD_TITLE | DMF0052_GET_SPREAD_TITLE |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs | GetEdiSender | 783 | DM.UP_FX_GetCommonDataList_DM | UP_FX_GETCOMMONDATALIST_DM |

## 2. 이벤트 핸들러 정의
| 파일 | 이벤트 | 핸들러 | 등록 줄 |
|---|---|---|---:|
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | this.spdSummaryPJT.CellDoubleClick | spdPjt_CellDoubleClick | 171 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | this.btnRefresh.Click | BtnRefresh_Click | 218 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | this.chkToday.CheckedChanged | chkToday_CheckedChanged | 255 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | this.btnProject.Click | btnProject_Click | 362 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | this.btnItemId.Click | btnItemId_Click | 399 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | this.spdData.ActiveSheetChanging | spdData_ActiveSheetChanging | 657 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | this.spdData.CellDoubleClick | spdData_CellDoubleClick | 658 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs | this.Load | Form_Load | 123 |

## 3. Grid 시트 생성
| 파일 | 메서드 | 줄 | 시트명 | API |
|---|---|---:|---|---|
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs | CreateSpread | 158 | SUMMARY | AddSheet |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs | CreateSpread | 162 | Summary Pjt | AddSheet |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs | CreateSpread | 166 | Summary Status | AddSheet |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs | CreateSpread | 170 | GSCM Data | AddSheet |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.cs | CreateSpread | 171 | ERP Data | AddSheet |
| 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs | CreateSpread | 129 | EDI Summary GSCM DATA Popup | AddSheet |

## 4. Grid 컬럼 하드코딩 (Popup)
| 파일 | 메서드 | 줄 | 컬럼명 | 필드 |
|---|---|---:|---|---|
| 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs | InitSpread | 144 | (ERP) EDI Sender | SENDER_NAME |
| 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs | InitSpread | 145 | (ERP) Company | COMPANY_ID |
| 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs | InitSpread | 146 | (ERP) Sold to | SOLDTO_CODE |
| 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs | InitSpread | 147 | (ERP) Ship to | SHIPTO_CODE |
| 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs | InitSpread | 150 | (GSCM) Sales Site | SCM_SITE_ID |
| 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs | InitSpread | 151 | Active | VALID_YN |
| 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs | InitSpread | 152 | (GSCM) Sold to / Ship to | GSCM_CODE |
| 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs | InitSpread | 153 | Active | CODE_VALID_YN |
| 06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0052_GSCMDataPopup.cs | InitSpread | 155 | Message | Message |

## 5. 컨트롤 정의
| 파일 | 컨트롤명 | 타입 | 줄 |
|---|---|---|---:|
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | spdSummary | FarPoint.Win.Spread.FpSpread | 37 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | spdSummaryPJT | FarPoint.Win.Spread.FpSpread | 39 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | spdSummaryStatus | FarPoint.Win.Spread.FpSpread | 62 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | spdData | FarPoint.Win.Spread.FpSpread | 64 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | btnRefresh | DevExpress.XtraEditors.SimpleButton | 43 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | chkToday | GSCM.Windows.Forms.Controls.UsrCheckBox | 44 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | txtItemId | GSCM.Windows.Forms.Controls.UsrMultiLineEditor | 45 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | txtProject | GSCM.Windows.Forms.Controls.UsrMultiLineEditor | 46 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | btnProject | GSCM.Windows.Forms.Controls.UsrButton | 47 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | btnItemId | GSCM.Windows.Forms.Controls.UsrButton | 48 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | drpPeriod | GSCM.Windows.Forms.Controls.UsrDateRangePicker | 49 |
| 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0052_EDISummary\DMF0052_EDISummary.Designer.cs | clbEDISender | GSCM.Windows.Forms.Controls.UsrCheckedList | 50 |

---
