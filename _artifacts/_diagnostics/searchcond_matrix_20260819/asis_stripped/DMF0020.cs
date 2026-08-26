using GSCM.App.Core.Security;
using GSCM.App.Core.Text;
using GSCM.SCM.Popup.UIL;
using GSCM.Windows.Forms.Class;
using GSCM.Windows.Forms.UI;
using GSCM.Windows.Forms.Utility;

using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using TheOne.ServiceModel.Data;
using TheOne.Windows.Forms;
using FarPoint.Win.Spread;
using GSCM.DM.Plan.UIL.POPUP;
using System.Windows.Forms;
using System.Collections.Specialized;

using FarPoint.Win.Spread.CellType;
using System.Threading.Tasks;
using System.Drawing;
using GSCM.DM.Plan.UIL;
using System.Diagnostics;

using GSCM.Windows.Forms.Service;
using GSCM.FP.Common.UIL.Service;

                                                                                                                            
                   
                   
                   
                                                                                                                            
                                           
                                                                                                                            
                                                                                
                                                                             
                                                                                                         
                                                                                             
                                                                          
                                                                                         
                                                                                         
                                                                                 
                                                                                 
                                                                
                                                    
                                                                                       
                                            
                                                                
                                                   
                                                         
                                                                                 
                                            
                                                                                                        
                                                                                          
                                                               
                                                                                                       
                                                                           
                                                                                                                           

namespace GSCM.DM.Master.UIL
{
    public partial class DMF0020_SalesFuturePrice : BaseForm
    {
        #region 1. Setting

                           
        private DataSet saveDS = null;
        string sStartDate = "";
        string sEndDate = "";
        int sTempRow = 0;                                             
        CControl clsCtrl = null;
        private DataTable dtDivision = null;
        private DataTable dtSalesSite = null;
        private string sScmBinding = "GSCM.SCM.Master.WSL/FoxDataService.svc";
                                                                                 
        private string sBinding = "GSCM.DM.Master.WSL/FoxDataService.svc";

                  
        public SpreadInfo siMain = null;

        DataTable dtMeasureCount = null;
        DataTable dtFuturePrice = null;
        private DataTable dtTeam = null;
        private DataTable dtEndCustomer = null;
        private DataTable dtWeek = null;
        private DataTable dtPlantSite = null;
        private DataTable dtDepartment = null;
        private DataSet dsSpdTitle = null;
        private DataTable dtBizType = null;
        private DataTable dtCustomer = null;
        private DataTable dtCurrencyList = null;
        private DataTable dtBucketType = null;
        private DataTable dtDM_UI_EDITABLE_DIVISION = null;                                                                    
        
        private DataTable dtincotermsEditType = null;                                                                                    


                                                                                     
        public string org_currency = null;

        TextCellType cellTypeImage = null;

        private bool blnWork = false;

        private DateTime dtStartPeriod;
        private DateTime dtEndPeriod;

        private bool isCurVersion = false;                           

                      
                       
                       
        private struct SpdSheet
        {
            public static string shtMain = "Sales Price";
        }

        private struct BucketType
        {
                                                    
            public static string Weekly = "WEEKLY";
            public static string Monthly = "MONTHLY";
        }

                      
                  
                       
        private struct DefColumns
        {
            public static string Column1 = "Column1";
            public static string Column2 = "Column2";
            public static string Column3 = "Column3";

            public static string DIVISION_ID = "DIVISION_ID";
            public static string SCM_SITE_ID = "SCM_SITE_ID";
            public static string PLANT_SITE_ID = "PLANT_SITE_ID";

            public static string DEPT_ID = "DEPT_ID";
            public static string TEAM_INCHARGE = "TEAM_INCHARGE";
            public static string UPPER_DEPT_ID = "UPPER_DEPT_ID";
            public static string DEPT_NAME = "DEPT_NAME_KO";
            public static string END_CUSTOMER = "END_CUSTOMER";
            public static string END_CUSTOMER40 = "END_CUSTOMER40";            

            public static string PROJECT_CODE = "PROJECT_CODE";
            public static string PROJECT_NAME = "PROJECT_NAME";
            public static string ITEM_NAME = "ITEM_NAME";
            public static string ITEM_CLASS_NAME = "ITEM_CLASS_NAME";
            public static string ITEM_ID = "ITEM_ID";
            public static string INCOTERMS = "INCOTERMS";
            public static string CURRENCY = "CURRENCY";
            public static string MEASURE = "MEASURE";
            public static string FcstType = "FCST_TYPE";
            public static string DomExp = "DOM_EXP";

            public static string ProjectStatus = "PROJECT_STATUS";
            public static string BizType = "BIZ_TYPE";
            public static string BizTypeName = "BIZ_TYPE_NAME";
            public static string AUTHORITY_YN = "AUTHORITY_YN";
            public static string NICK_NAME = "NICK_NAME";

            public static string ColumnName = "COLUMN_NAME";
            public static string ColumnLabel = "COLUMN_LABEL_NAME";
            public static string SmallLabelName = "SMALL_CLASS_LABEL_NAME";
            public static string LargeLabelName = "LARGE_CLASS_LABEL_NAME";

            public static string ColList = "COL_LIST";

                                                       
            public static string NewFlag = "NEW_FLAG";

            public static string PRICE_EXIST = "PRICE_EXIST";

            public static string GROUP_ID = "GROUP_ID";
            public static string DISPLAY_SEQ = "DISPLAY_SEQ";

        }

        #endregion

        #region 2. Construct

        public DMF0020_SalesFuturePrice()
        {
            InitializeComponent();

                      
            this.Load += Form_Load;
            UnFilterInsertRow = true;
        }

        private void Form_Load(object sender, EventArgs e)
        {
            clsCtrl = new CControl(this);

            InitForm();
            InitControls();
            CreateSpread();
            DefineProperty();
            InitEvent();

                                           
            if (clbDivisions.ControlValues.Substring(0, 2) == "81")
            {
                btnExcelUpload.Visible = btnTemplate.Visible = true;
                layoutControlItem12.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Always;
                layoutControlItem29.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Always;
            }
            else
            {
                btnExcelUpload.Visible = btnTemplate.Visible = false;
                layoutControlItem12.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
                layoutControlItem29.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
            }
        }

        #endregion
                                            
        #region FILTER_PART

        private DataTable dtPlantSiteByEndCustomer = null;

        #region LocalDataSet
        private GSCM.FP.Common.UIL.FilterDataSet Filter = new GSCM.FP.Common.UIL.FilterDataSet();
        #endregion

        private void SetChangeControl(string triggerControl, string sDivision = "", string sTeam = "", string sEndCustomer = "")
        {
            Filter["GROUP_ID"] = UserInfoContext.Current["NowGroupID"];
            Filter["USER_ID"] = UserInfoContext.Current.UserId;

            switch (triggerControl)
            {
                case "MyDivision":

                    dtDivision = DataService.GetDMInnerTable("MyDivision", Filter);

                    break;
                case "UserTeamByDivision":

                    Filter["DIVISION_ID"] = sDivision;

                    dtTeam = DataService.GetDMInnerTable("UserTeamByDivision", Filter);

                    break;
                case "EndCustomerByDivision":

                    Filter["DIVISION_ID"] = sDivision;
                    Filter["DEPT_ID"] = sTeam;

                    dtEndCustomer = DataService.GetDMInnerTable("EndCustomerByDivision", Filter);

                    break;
                case "BizType":

                    Filter["DIVISION_ID"] = sDivision;

                    dtBizType = DataService.GetDMInnerTable("BizType", Filter);

                    break;
                case "UserSiteByEndCustomer":

                    Filter["DIVISION_ID"] = sDivision;
                    Filter["DEPT_ID"] = sTeam;
                    Filter["END_CUSTOMER"] = sEndCustomer;

                    dtSalesSite = DataService.GetDMInnerTable("UserSiteByEndCustomer", Filter);

                    break;
                case "UserPlantSiteByDivision":

                    Filter["DIVISION_ID"] = sDivision;

                    dtPlantSite = DataService.GetDMInnerTable("UserPlantSiteByDivision", Filter);

                    break;
                case "UserPlantSiteByEndCustomer":

                    Filter["DIVISION_ID"] = sDivision;
                    Filter["END_CUSTOMER"] = sEndCustomer;

                    dtPlantSiteByEndCustomer = DataService.GetDMInnerTable("UserPlantSiteByEndCustomer", Filter);

                    break;
            }
        }

        #endregion               
                                          

        #region 3. Define

        private void InitControls()
        {
            drpDateTime.InitValue = GetDayRange();
            string sStartDate = drpDateTime.Value1.ToString("yyyyMMdd");
            string sEndDate = drpDateTime.Value2.ToString("yyyyMMdd");

            dtDivision = null;
                                                                        
                                                                                                                                                                 
            SetChangeControl("MyDivision");
                                                                  
            clsCtrl.setListBox(dtDivision, clbDivisions, false, "CODE", "NAME");

            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues);

                                                                                                    

            dtDepartment = Data.Common(Data.Type.UpperDeptId, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);

                                                                        
                                                                                                                                                                                                    
            SetChangeControl("UserTeamByDivision", sDivision);
            clsCtrl.setListBox(dtTeam, clbTeam, true);

            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);

                          
            if ((sDivision.Substring(0, 2) == "81") || (sDivision == "82"))
            {
                                                                            
                                                                                                                                                               
                SetChangeControl("EndCustomerByDivision", sDivision, sTeam);
                clsCtrl.setListBox(dtEndCustomer, clbEndCustomer, true);

                                                                            
                                                                                
                SetChangeControl("BizType", clbDivisions.ControlValues);
                clsCtrl.setListBox(dtBizType, clbBizType, true);

                lblProject.Enabled = true;
                lblPlantSite.Enabled = true;
                                             
                layoutControlItem6.Enabled = true;


                                                                    
                if (sDivision == "82")
                {
                    checkInvalidExec.Enabled = true;
                }
                else
                {
                    checkInvalidExec.Enabled = false;
                }
            }
            else
            {
                                                                            
                                                                                                                                                                                           
                SetChangeControl("EndCustomerByDivision", clbDivisions.ControlValues, clbTeam.ControlValues);
                clsCtrl.setListBox(dtEndCustomer, clbEndCustomer, true);

                                                                            
                                                                                         
                SetChangeControl("BizType", clbDivisions.ControlValues);
                clsCtrl.setListBox(dtBizType, clbBizType, true);

                lblProject.Enabled = false;
                lblPlantSite.Enabled = false;
                                              
                layoutControlItem6.Enabled = false;

                umltProject.Text = "";
                clbPlantSite.ControlValues = "";

                                                        
                checkInvalidExec.Enabled = false;
            }

                                                              
                                              
                   
            lblBizType.Enabled = true;

            string sEndCustomer = CString.GetCheckedListValue(dtEndCustomer, clbEndCustomer.ControlValues);

                                                                        
                                                                                                                                                                         
            SetChangeControl("UserSiteByEndCustomer", clbDivisions.ControlValues, string.Empty, sEndCustomer);
            clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);

                                                                            
            if (sDivision.IndexOf("81") != -1)
            {

                                                                            
                                                                                                                                                                                                                            
                SetChangeControl("UserPlantSiteByEndCustomer", clbDivisions.ControlValues, string.Empty, clbEndCustomer.ControlValues);
                clsCtrl.setListBox(dtPlantSiteByEndCustomer, clbPlantSite, true);
            }

                           
                                                                                   
                                                                                                                                                   

                                 
            dtMeasureCount = GetMeasureCountInfo();
                                  
            dtFuturePrice = GetFuturePriceInfo();

                                                              
                                           
            dtWeek = GetWeekData();

                         
            dtBucketType = GetBucketType();
            dtBucketType.Rows.RemoveAt(0);
            clsCtrl.setListBox(dtBucketType, cboBucketType, false, "CODE", "NAME");



                                       
            txtVersion.Text = "Current";
        }
        private string GetDayRange()
        {
            string sDayRange = string.Empty;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                var request = new FoxDataRequest("DM.PR_GET_DAY_RANGE");
                request.Parameters["p_created_by"] = base.UserInfo.UserId;
                request.Parameters["p_month"] = 6;

                sDayRange = client.ExecuteDataSet(request).DataSet.Tables[1].Rows[0][0].ToString();
            }

            return sDayRange;
        }

                      
                               
                       
        private void DefineProperty()
        {
                     
            dtStartPeriod = drpDateTime.Value1;
            dtEndPeriod = drpDateTime.Value2;

            usrConditionPanel2.Height = 105;

            clbDivisions.ControlValues = "ALL";

            siMain.ImagePopUp = imageList1.Images[0];
            cellTypeImage = new TextCellType();
            cellTypeImage.BackgroundImage = new FarPoint.Win.Picture(siMain.ImagePopUp);
            cellTypeImage.BackgroundImage.AlignHorz = FarPoint.Win.HorizontalAlignment.Right;
            cellTypeImage.CharacterCasing = CharacterCasing.Upper;


                  
            switch (UserInfoContext.Current["NowGroupID"])
            {
                case "ADMIN":
                case "DM ADMIN":
                                                
                                                
                    layoutControlItem5.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Always;
                    break;
                default:
                                                 
                                                 
                    layoutControlItem5.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
                    break;
            }

            this.umltProject.KeyDown += new System.Windows.Forms.KeyEventHandler(this.umltProject_KeyDown);
            this.umltModel.KeyDown += new System.Windows.Forms.KeyEventHandler(this.umltModel_KeyDown);
            this.clbDivisions.SelectedIndexChanged += new System.EventHandler(this.clbDivisions_SelectedIndexChanged);
        }

        private void umltProject_KeyDown(object sender, System.Windows.Forms.KeyEventArgs e)
        {
            if (e.KeyCode == System.Windows.Forms.Keys.Enter)
            {
                usrButton1_Click(null, null);
            }
        }

        private void umltModel_KeyDown(object sender, System.Windows.Forms.KeyEventArgs e)
        {
            if (e.KeyCode == System.Windows.Forms.Keys.Enter)
            {
                btnModelType_Click(null, null);
            }
        }

        private DataTable GetWeekData()
        {
                                                              
                                           
            DataTable dsWeek;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                var request = new FoxDataRequest("DM.DMF0020_GET_WEEKDATA");
                request.Parameters["p_yyyymmdd"] = System.DateTime.Now.ToString("yyyyMMdd");

                dsWeek = client.ExecuteDataSet(request).DataSet.Tables[0];
            }

            return dsWeek;
        }

        private DataTable GetMeasureCountInfo()
        {
                                                              
            DataTable dt;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                var request = new FoxDataRequest("DM.DMF0020_GET_MEASURE_COUNTINFO");

                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }

            return dt;
        }

        private DataTable GetFuturePriceInfo()                               
        {
            string sStartDate = drpDateTime.Value1.ToString("yyyyMM") + "01";
            string sEndDate = drpDateTime.Value2.ToString("yyyyMM") + "01";

            DataTable dt;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                var request = new FoxDataRequest("DM.DMF0020_GET_FUTUREPRICE_INFO");
                request.Parameters["p_start_yyyymmdd"] = sStartDate;
                request.Parameters["p_end_yyyymmdd"] = sEndDate;

                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }

            return dt;
        }

        private void CreateSpread()
        {
            this.AddSheet(spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 45);
            siMain = GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex);
            siMain.ChangeSheet();

            InitSpread(true);
        }

        private void InitEvent()
        {
            FarPoint.Win.Spread.Model.DefaultSheetDataModel dsdm = (FarPoint.Win.Spread.Model.DefaultSheetDataModel)siMain.Sheet(SpdSheet.shtMain).Models.Data;
            dsdm.Changed += new FarPoint.Win.Spread.Model.SheetDataModelEventHandler(Dsdm_Changed);

            cboBucketType.SelectedIndexChanged += new System.EventHandler(cboBucketType_SelectedIndexChanged);
        }

        private void cboBucketType_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (siMain != null)
            {
                SetSpreadColumn();

                if (!siMain.IsLock(siMain.SheetName))
                {
                                                                   
                    EditButton();
                    EditButton();
                }

            }
        }

        private void InitSpread(bool isChangeHeader)
        {

            if (dtStartPeriod.ToString("yyyyMMdd") == drpDateTime.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpDateTime.Value2.ToString("yyyyMMdd") && !isChangeHeader)
            {
                siMain.RemoveRowAll();
            }
            else
            {
                         
                dtStartPeriod = drpDateTime.Value1;
                dtEndPeriod = drpDateTime.Value2;

                                
                DataSet dsTitle = GetSpdTitle();
                siMain.CreateSheetHeaderColumn(siMain, 3, dsTitle.Tables[0]);

                SetSpreadHeaderSpan(dsTitle.Tables[0]);
                SetSpreadColumn();

            }
        }

        private void SetSpreadHeaderSpan(DataTable dt)
        {
            string sColumnName = string.Empty;
            string sColumnLabel = string.Empty;
            string sSmallLabelName = string.Empty;
            string sLargeLabelName = string.Empty;
            string sSmallSpanName = dt.Rows[0][6].ToString();
            string sLargeSpanName = dt.Rows[0][7].ToString();
            int iSmallStartCol = siMain.GetColumnIndex(DefColumns.MEASURE) + 1;
            int iLargeStartCol = siMain.GetColumnIndex(DefColumns.MEASURE) + 1;
            int iSmallSpanCnt = 1;
            int iLargeSpanCnt = 1;
            int iCellCnt = 0;                                                   
            int iColSortOrderNo = 0;

            foreach (DataRow dr in dt.Rows)
            {
                iCellCnt++;

                sColumnName = dr[DefColumns.ColumnName].ToString();
                sColumnLabel = dr[DefColumns.ColumnLabel].ToString();
                sSmallLabelName = dr[DefColumns.SmallLabelName].ToString();
                sLargeLabelName = dr[DefColumns.LargeLabelName].ToString();
                                                                                     

                if (iCellCnt <= iSmallStartCol)
                {
                    siMain.ColumnHeaderSpan(0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center);
                    sSmallSpanName = dr[DefColumns.SmallLabelName].ToString();
                    sLargeSpanName = dr[DefColumns.LargeLabelName].ToString();
                }
                else
                {
                    if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0)
                    {
                        siMain.VisibleColumns(iCellCnt, false);
                    }
                    else
                    {
                        sColumnName = dr[DefColumns.ColumnName].ToString();
                        sColumnLabel = dr[DefColumns.LargeLabelName].ToString();
                        sLargeLabelName = dr[DefColumns.LargeLabelName].ToString();
                        sSmallLabelName = dr[DefColumns.SmallLabelName].ToString();
                    }

                    if (sLargeSpanName != sLargeLabelName)
                    {
                        siMain.ColumnHeaderSpan(0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center);
                        siMain.ColumnHeaderSpan(1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center);
                        sLargeSpanName = dr[DefColumns.LargeLabelName].ToString();
                        iLargeStartCol = iLargeStartCol + iLargeSpanCnt;
                        iLargeSpanCnt = 0;

                        siMain.ColumnHeaderSpan(1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center);
                                                                                                        
                        sSmallSpanName = dr[DefColumns.SmallLabelName].ToString();
                        iSmallStartCol = iSmallStartCol + iSmallSpanCnt;
                        iSmallSpanCnt = 0;
                    }
                    else if (sSmallSpanName != sSmallLabelName)
                    {
                        siMain.ColumnHeaderSpan(1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center);
                                                                                                        
                        sSmallSpanName = dr[DefColumns.SmallLabelName].ToString();
                        iSmallStartCol = iSmallStartCol + iSmallSpanCnt;
                        iSmallSpanCnt = 0;
                    }

                    iLargeSpanCnt++;
                    iSmallSpanCnt++;
                }
            }

            siMain.ColumnHeaderSpan(1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center);
                                                                                            
            siMain.ColumnHeaderSpan(0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center);
            siMain.ColumnHeaderSpan(1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center);

            siMain.Freeze(0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1);

            siMain.SmartColMerge();
        }

        private void SetSpreadColumn()
        {
            int iStartCol = siMain.GetColumnIndex(DefColumns.MEASURE) + 1;

            for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
            {
                if (cboBucketType.ControlValues == BucketType.Weekly)
                {

                                                                        
                        
                                                                            
                        
                            
                    if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0)
                    {
                        siMain.ActiveSheet.Columns[iCol].Visible = true;
                    }
                    else
                    {
                        siMain.ActiveSheet.Columns[iCol].Visible = false;
                        siMain.ActiveSheet.Columns[iCol].BackColor = Color.White;
                    }
                }
                else
                {
                    if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0)
                    {
                        siMain.ActiveSheet.Columns[iCol].Visible = false;
                        siMain.ActiveSheet.Columns[iCol].BackColor = Color.White;

                    }
                    else if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                    {
                        siMain.ActiveSheet.Columns[iCol].Visible = true;
                    }
                }
            }
        }

                      
                                                                 
                       
                                      
        private void SetSpreadColumn(DataTable dt)
        {
            int iWeek = 1;
            int iMergeStart = 1;
            int iMergeCnt = 1;

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                int iMeasureCol = siMain.GetColumnIndex(DefColumns.MEASURE);
                string strTopHeader = dt.Rows[i]["YER"].ToString() + "-" + dt.Rows[i]["MON"].ToString();

                         
                if (dt.Rows[i]["BASIS_START_DATE2"].ToString().IndexOf("M_") != 0)
                {
                    siMain.AddNumColumn(dt.Rows[i]["MMDD"].ToString(), dt.Rows[i]["BASIS_START_DATE"].ToString(), FPMerge.None, 120, true, FPHAlign.Right, FPVAlign.Center, 2, true);
                }
                else
                {
                                       
                    siMain.AddNumColumn("SUM", dt.Rows[i]["BASIS_START_DATE"].ToString(), FPMerge.None, 120, true, FPHAlign.Right, FPVAlign.Center, 2, true);
                }

                                  
                if (i == 0)
                {
                    siMain.ColumnHeaderSpan(0, iMeasureCol + iWeek, 1, 1, 25, strTopHeader, FPHAlign.Center);
                    iMergeStart = iMeasureCol + iWeek;
                }
                else
                {
                    if (dt.Rows[i - 1]["BASIS_YYYYMM"].ToString() == dt.Rows[i]["BASIS_YYYYMM"].ToString())
                    {
                        iMergeCnt++;
                        siMain.ColumnHeaderSpan(0, iMergeStart, 1, iMergeCnt, 25, strTopHeader, FPHAlign.Center);
                    }
                    else
                    {
                        iMergeCnt = 1;
                        iMergeStart = iMeasureCol + iWeek;
                        siMain.ColumnHeaderSpan(0, iMergeStart, 1, iMergeCnt, 25, strTopHeader, FPHAlign.Center);
                    }
                }

                                
                siMain.ColumnHeaderSpan(1, iMeasureCol + iWeek, 1, 1, 25, dt.Rows[i]["WEEK_NAME"].ToString(), FPHAlign.Center);

                iWeek++;
            }
        }

        private void InitSpread_X()
        {
            siMain.ColumnHeaderSpanRow(0, siMain.GetColumnIndex(DefColumns.MEASURE));

            string sStartDate = drpDateTime.Value1.ToString("yyyyMMdd");
            string sEndDate = drpDateTime.Value2.ToString("yyyyMMdd");

            NameValueCollection nvc = new NameValueCollection();
            nvc["p_start_yyyymmdd"] = sStartDate;
            nvc["p_end_yyyymmdd"] = sEndDate;
            nvc["p_created_by"] = UserInfoContext.Current.UserId;
                                                                                                                            
            DataSet ds = (new CUIControl()).GetDataUsingByDBEx("DM.DMF0020_GET_SPREAD_TITLE_DATE", nvc);
            DataTable dt = ds.Tables[0];

                                           
            string sFYear = "";
            int iFRow = siMain.GetColumnIndex(DefColumns.MEASURE) + 1;
            int iLRow = 1;
            int iWeek = 1;
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                                   
                if (i == 0)
                    sFYear = dt.Rows[i]["BASIS_YYYYMM"].ToString();

                                 
                siMain.AddNumColumn(dt.Rows[i]["DATE_SHORT1_NAME"].ToString(), dt.Rows[i]["BASIS_START_DATE"].ToString(), FPMerge.None, 120, true, FPHAlign.Right, FPVAlign.Center, 2, true);
                                                                                                                                                             
                siMain.ColumnHeaderSpan(1, siMain.GetColumnIndex(DefColumns.MEASURE) + iWeek, 1, 1, 25, dt.Rows[i]["WEEK_NAME"].ToString(), FPHAlign.Center);
                iWeek++;
                                                          
                if (sFYear != dt.Rows[i]["BASIS_YYYYMM"].ToString())
                {
                    string sYear = sFYear.Substring(0, 4) + "-" + sFYear.Substring(4);
                    siMain.ColumnHeaderSpan(0, iFRow, 1, iLRow - 1, 25, sYear, FPHAlign.Center);
                                                                                                                              
                    sFYear = dt.Rows[i]["BASIS_YYYYMM"].ToString();
                    iFRow = (iFRow) + (iLRow - 1);
                    iLRow = 1;
                }
                if (i == dt.Rows.Count - 1)
                {
                    string sYear = sFYear.Substring(0, 4) + "-" + sFYear.Substring(4);
                    siMain.ColumnHeaderSpan(0, iFRow, 1, iLRow, 25, sYear, FPHAlign.Center);
                }
                iLRow++;
            }

            fps = siMain.SpreadObject;
            siMain.Freeze(0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1);
        }

        #endregion

        #region  4. Button

        protected override void FindButton()
        {
            FindData(true);
        }

        protected override void InsertButton()
        {
                                      
            if (!isCurVersion) return;

            HaltAutoFilter = true;
            InsertRow();
            HaltAutoFilter = false;
        }

        protected override void DeleteButton()
        {
            if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting.StringI)
                return;

            int[] iResult = GetCellNumbersByRow(siMain.ActiveRowIndex);

            for (int i = iResult.Length - 1; i >= 0; i--)
            {
                                               
                siMain.SpreadObject.ActiveSheet.SetActiveCell(iResult[i], 2);
                siMain.Delete();
            }
        }

        protected override void EditButton()
        {
                                      
            if (!isCurVersion) return;

            if (this.fps != null)
            {
                                                              
                                                                                                          
                dtDM_UI_EDITABLE_DIVISION = GetLookupValues("DM_UI_EDITABLE_DIVISION", "DMF0020", clbDivisions.ControlValues, "", "", "");
                if (dtDM_UI_EDITABLE_DIVISION != null 
                    && dtDM_UI_EDITABLE_DIVISION.Rows.Count > 0
                    && dtDM_UI_EDITABLE_DIVISION.Columns.Contains("EDIT_YN")
                    && dtDM_UI_EDITABLE_DIVISION.Rows[0]["EDIT_YN"].String() == "N")
                {
                    MessageHelper.GMessageBox("MSG00448");
                    return;
                }

                           
                if (clbDivisions.ControlValues == "40")
                {
                    if ((siMain.GetColumnIndex(DefColumns.END_CUSTOMER40) < 0)
                        || (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) < 0)
                        || (siMain.GetColumnIndex(DefColumns.ITEM_ID) < 0)
                        || (siMain.GetColumnIndex(DefColumns.INCOTERMS) < 0)
                        || (siMain.GetColumnIndex(DefColumns.FcstType) < 0)
                        || (siMain.GetColumnIndex(DefColumns.DomExp) < 0)
                        || (siMain.GetColumnIndex(DefColumns.CURRENCY) < 0)
                    )
                    {
                        MessageHelper.GMessageBox("MSG00113");
                        return;
                    }
                }
                                                                                                         
                    
                                                                          
                                                                                    
                                                                                 
                                                                             
                                                                               
                                                                              
                                                                              
                        
                        
                                                                 
                                  
                        
                    
                else if (clbDivisions.ControlValues.Substring(0, 2) == "81")
                {
                    if ((siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) < 0)
                        || (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) < 0)
                        || (siMain.GetColumnIndex(DefColumns.ITEM_ID) < 0)
                        || (siMain.GetColumnIndex(DefColumns.INCOTERMS) < 0)
                        || (siMain.GetColumnIndex(DefColumns.FcstType) < 0)
                        || (siMain.GetColumnIndex(DefColumns.DomExp) < 0)
                        || (siMain.GetColumnIndex(DefColumns.CURRENCY) < 0)
                        || (siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID) < 0)
                    )
                    {
                        MessageHelper.GMessageBox("MSG00113");
                        return;
                    }
                }
                else if (clbDivisions.ControlValues == "82")
                {
                    if ((siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) < 0)
                        || (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) < 0)
                        || (siMain.GetColumnIndex(DefColumns.ITEM_ID) < 0)
                        || (siMain.GetColumnIndex(DefColumns.INCOTERMS) < 0)
                        || (siMain.GetColumnIndex(DefColumns.FcstType) < 0)
                        || (siMain.GetColumnIndex(DefColumns.DomExp) < 0)
                        || (siMain.GetColumnIndex(DefColumns.CURRENCY) < 0)
                    )
                    {
                        MessageHelper.GMessageBox("MSG00113");
                        return;
                    }
                }


                                                                                                 
                if (siMain.GetColumnIndex(DefColumns.PRICE_EXIST) < 0)
                {
                    string args = string.Format("{0}"
                                        , MessageHelper.GetTerm(DefColumns.PRICE_EXIST)
                                        );

                                                           
                    MessageHelper.GMessageBox("MSG00412", new object[] { args });

                    return;
                }
                                                                                               


                siMain = GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex);
                siMain.SwitchLock();
                siMain.SpreadObject.SuspendLayout();
                                                                                         

                DateTime dateTime = DateTime.Today.AddDays(Convert.ToInt32(DayOfWeek.Monday) - Convert.ToInt32(DateTime.Today.DayOfWeek));
                string sYYYYMMDD = dateTime.ToString("yyyyMMdd");
                int iStartCol = siMain.GetColumnIndex(DefColumns.MEASURE) + 1;
                int iResultCol = iStartCol;                                                  
                int iResultMonth = iStartCol;                                                  

                for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                {
                    if (cboBucketType.ControlValues == BucketType.Weekly)
                    {
                        if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0)
                        {
                            if (!siMain.IsLock(siMain.SheetName))
                            {
                                if (int.Parse(sYYYYMMDD) > int.Parse(siMain.GetColumnTag(iCol).Replace("W_", "")))
                                {
                                    siMain.LockColumn2(iCol, iCol, true);
                                                         
                                }
                            }
                            else
                            {
                                siMain.LockColumn2(iCol, iCol, true);
                            }
                        }
                        else
                        {
                            siMain.LockColumn2(iCol, iCol, true);
                        }
                    }
                    else if (cboBucketType.ControlValues == BucketType.Monthly)
                    {
                        if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                        {
                            if (!siMain.IsLock(siMain.SheetName))
                            {
                                if (int.Parse(sYYYYMMDD.Substring(0, 6)) > int.Parse(siMain.GetColumnTag(iCol).Replace("M_", "")))
                                {
                                    siMain.LockColumn2(iCol, iCol, true);
                                }
                            }
                            else
                            {
                                siMain.LockColumn2(iCol, iCol, true);
                            }
                        }
                        else
                        {
                            siMain.LockColumn2(iCol, iCol, true);
                        }
                    }

                    if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0 && int.Parse(sYYYYMMDD) > int.Parse(siMain.GetColumnTag(iCol).Replace("W_", "")))
                    {
                        iResultCol = iCol;
                    }

                    if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 && int.Parse(sYYYYMMDD.Substring(0, 6)) == int.Parse(siMain.GetColumnTag(iCol).Replace("M_", "")))
                    {
                        iResultMonth = iCol;
                    }
                }

                for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
                {
                                                                
                                                                                
                    if (clbDivisions.ControlValues == "82" && siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.NewFlag)).ToString() == CAppSetting.StringY)
                    {
                        if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) > 0)
                            siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), true);
                        if (siMain.GetColumnIndex(DefColumns.DEPT_ID) > 0)
                            siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.DEPT_ID), iRow, siMain.GetColumnIndex(DefColumns.DEPT_ID), true);
                        if (siMain.GetColumnIndex(DefColumns.DEPT_NAME) > 0)
                            siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.DEPT_NAME), iRow, siMain.GetColumnIndex(DefColumns.DEPT_NAME), true);
                        if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER) > 0)
                            siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), iRow, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), true);
                        if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) > 0)
                            siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), true);
                        if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) > 0)
                            siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), true);
                        if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME) > 0)
                            siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), iRow, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), true);
                        if (siMain.GetColumnIndex(DefColumns.ProjectStatus) > 0)
                            siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.ProjectStatus), iRow, siMain.GetColumnIndex(DefColumns.ProjectStatus), true);
                        if (siMain.GetColumnIndex(DefColumns.BizType) > 0)
                            siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.BizType), iRow, siMain.GetColumnIndex(DefColumns.BizType), true);
                        if (siMain.GetColumnIndex(DefColumns.BizTypeName) > 0)
                            siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.BizTypeName), iRow, siMain.GetColumnIndex(DefColumns.BizTypeName), true);
                        if (siMain.GetColumnIndex(DefColumns.ITEM_ID) > 0)
                            siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID), iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID), true);
                        if (siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME) > 0)
                            siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), iRow, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), true);
                        if (siMain.GetColumnIndex(DefColumns.ITEM_NAME) > 0)
                            siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.ITEM_NAME), iRow, siMain.GetColumnIndex(DefColumns.ITEM_NAME), true);
                        if (siMain.GetColumnIndex(DefColumns.NICK_NAME) > 0)
                            siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.NICK_NAME), iRow, siMain.GetColumnIndex(DefColumns.NICK_NAME), true);

                        siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.MEASURE), iRow, siMain.GetColumnIndex(DefColumns.MEASURE), true);
                    }
                    else
                    {
                        siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRow, siMain.GetColumnIndex(DefColumns.MEASURE), true);
                    }
                                                             
                             
                    if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN)).ToString() != CAppSetting.StringY)
                    {

                        if (string.IsNullOrEmpty(siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction))))
                            siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetMaxColumnIndex(), true);
                        else if (siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI && IsEditMode == true)
                        {
                            for (int iCol = siMain.GetColumnIndex(DefColumns.MEASURE) + 1; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                            {
                                if (cboBucketType.ControlValues == BucketType.Weekly)
                                {
                                    if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0)
                                    {
                                                                                                                             
                                                                                   
                                               
                                        siMain.LockRange2(iRow, iCol, iRow, iCol, false);
                                    }
                                    else
                                    {
                                        siMain.LockRange2(iRow, iCol, iRow, iCol, true);
                                    }
                                }
                                else if (cboBucketType.ControlValues == BucketType.Monthly)
                                {
                                                                                        
                                        
                                                                                                                                               
                                                                                     
                                                 
                                    siMain.LockRange2(iRow, iCol, iRow, iCol, false);
                                        
                                           
                                        
                                                                                           
                                        
                                }
                            }
                            siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), true);
                            siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID) + 1, iRow, siMain.GetColumnIndex(DefColumns.MEASURE), false);


                            if (clbDivisions.SelectedValue.ToString() == "40")
                            {
                                                                                                                                                                                                                   
                            }
                            else
                            {
                                if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME) != -1)
                                    siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), iRow, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), true);
                                if (siMain.GetColumnIndex(DefColumns.ProjectStatus) != -1)
                                    siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.ProjectStatus), iRow, siMain.GetColumnIndex(DefColumns.ProjectStatus), true);
                                if (siMain.GetColumnIndex(DefColumns.BizTypeName) != -1)
                                    siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.BizTypeName), iRow, siMain.GetColumnIndex(DefColumns.BizTypeName), true);
                            }

                            if (siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME) != -1)
                                siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), iRow, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), true);
                            if (siMain.GetColumnIndex(DefColumns.ITEM_NAME) != -1)
                                siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.ITEM_NAME), iRow, siMain.GetColumnIndex(DefColumns.ITEM_NAME), true);
                            if (siMain.GetColumnIndex(DefColumns.MEASURE) != -1)
                                siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.MEASURE), iRow, siMain.GetColumnIndex(DefColumns.MEASURE), true);
                            if (siMain.GetColumnIndex(DefColumns.NICK_NAME) != -1)
                                siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.NICK_NAME), iRow, siMain.GetColumnIndex(DefColumns.NICK_NAME), true);


                                                              
                            if (drpDateTime.Value1 < System.DateTime.Now.AddDays(-7))
                            {
                                               
                                string sThisWeek = "";
                                for (int j = 0; j <= dtWeek.Rows.Count; j++)
                                {
                                    if (j == 0)
                                        sThisWeek = dtWeek.Rows[j]["BASIS_START_DATE"].ToString();

                                    string sLastWeek = dtWeek.Rows[j]["BASIS_START_DATE"].ToString();
                                    try
                                    {
                                        if (sThisWeek != sLastWeek)
                                        {
                                            siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.MEASURE), iRow, siMain.GetColumnIndex("W_" + sLastWeek), true);
                                            break;
                                        }
                                    }
                                    catch { break; }
                                }
                            }
                        }

                    }

                                  
                       
                             
                           
                                       
                                       
                                       
                        
                       
                    string sMeasure = siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.MEASURE));

                                                                                                                     
                        
                                                                                                                                          
                        

                                                
                    if (sMeasure.ToUpper().IndexOf("KRW") > -1 || sMeasure.ToUpper().IndexOf("USD") > -1 || sMeasure.ToUpper().IndexOf("RTF") > -1)
                    {
                        siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetMaxColumnIndex(), true);
                    }

                    if (sMeasure.ToUpper() == "LOC")
                                                                                             
                                                                
                    {
                        if (!siMain.IsLock(siMain.SheetName))
                        {
                            if (siMain.GetColumnIndex(DefColumns.CURRENCY) > 0)
                            {
                                siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.CURRENCY), iRow, siMain.GetColumnIndex(DefColumns.CURRENCY), false);
                                siMain.ActiveSheet.Columns[DefColumns.CURRENCY].MergePolicy = FarPoint.Win.Spread.Model.MergePolicy.None;
                                                                                                                    
                            }
                        }
                    }

                       
                                                     
                      
                                                                                                                                        
                      
                                                          
                      
                                                                                                                                        
                      
                      

                }

                if ((siMain.GetMaxRowIndex() != -1) && (iResultCol > iStartCol))
                {
                    siMain.SetBGColor2(0, iStartCol, siMain.GetMaxRowIndex(), iResultCol, Color.Gainsboro);
                    siMain.SetBGColor2(0, iResultMonth, siMain.GetMaxRowIndex(), iResultMonth, Color.White);
                }

                siMain.SpreadObject.ResumeLayout();

            }

        }

        protected override void SaveButton()
        {
                    
            SaveData();
        }

                                                                 
        protected override void ExcelButton()
        {
            SimpleExcelExportOption exportOption = new SimpleExcelExportOption();

            string sFileName = Application.StartupPath + "\\" + this.Name.ToString() + "_" + DateTime.Now.ToString("yyyyMMddHHmmss") + ".xlsx";

            exportOption.Merge = ExcelMergeOption.None;
            exportOption.Border = ExcelBorderOption.All;
            exportOption.AheadZeroOption = ZeroOption.ShowZero;
            exportOption.AmendNullToZero = false;
            exportOption.AheadNullToZero = false;
            exportOption.AmendZeroOption = ZeroOption.ShowZero;
                                        
            exportOption.UserName = UserInfo.UserId;
            exportOption.FileName = sFileName;
                                                                                     
            exportOption.AmendDecimalFormat = "#,##0.000;[Red]-#,##0.000";
            try
            {
                                         
                SimplexelService.ExportFpSpread(fps, exportOption);
                                       
            }
            catch (Exception e)
            {
                throw e;
            }
            finally
            {
                MessageService.CloseProgress();
            }

        }
                                                                

        #endregion

        #region 5. Logic

        private async void FindData(bool blnInsert, int iUpdateRow = 0, int iUpdateCol = 0)
        {
            GSCM.Windows.Forms.UI.ProgressForm prg = new GSCM.Windows.Forms.UI.ProgressForm();

            try
            {
                             
                if (blnWork)
                {
                    MessageHelper.GMessageBox("MSG00137");
                    return;
                }

                               
                if (txtVersion.Text.Trim() == "")
                {
                    MessageHelper.GMessageBox("MSG00283");                       
                    return;
                }

                          
                blnWork = true;

                                      
                isCurVersion = false;

                string[] sMonth = drpDateTime.ControlValues.Split(':');
                string sStartDate = drpDateTime.Value1.ToString("yyyyMMdd");           
                string sEndDate = drpDateTime.Value2.ToString("yyyyMMdd");           

                string[] sPeriod = drpDateTime.ControlValues.Split(':');

                string sOverRange = (usrDiscard.Checked == true) ? "Y" : "N";                         
                string sInvalidExec = (checkInvalidExec.Checked == true) ? "Y" : "N";                                                     

                if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1]))
                {
                    MessageHelper.GMessageBox("MSG00108");
                    return;
                }

                         
                string p_division_id = CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues);                               
                string p_scm_site_id = clbSalesSite.ControlValues;
                string p_plant_site_id = clbPlantSite.ControlValues;
                string p_project_code = umltProject.Text;
                string p_item_id = umltModel.Text;

                string p_dept_id = clbTeam.ControlValues;
                string p_end_customer = clbEndCustomer.ControlValues;
                string p_biztype = clbBizType.ControlValues;
                string p_owner = txtOwner.Text;

                string p_version_type = txtVersion.Text;

                if (p_division_id == "")
                {
                    MessageHelper.GMessageBox("MSG00097");
                    return;
                }

                CanModelChange = false;
                prg.Show();

                InitSpread(false);
                          
                         
                                 
                SearchStartTime();

                                     

                var asyncProxy = new FoxAsyncProxy(this);
                asyncProxy.ShowProgress = false;

                var ds = await asyncProxy.ExecuteAsync<DataSet>(() =>
                {
                    using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
                    {
                        var request = new FoxDataRequest("DM.DMF0020_GET_SCM_MST_FUTURE_PRICE");

                        request.CommandTimeout = 10 * 60;

                        request.Parameters["p_division_id"] = p_division_id;
                        request.Parameters["p_dept_id"] = p_dept_id;
                        request.Parameters["p_end_customer"] = p_end_customer;
                        request.Parameters["p_scm_site_id"] = p_scm_site_id;
                        request.Parameters["p_project_code"] = p_project_code;
                        request.Parameters["p_item_id"] = p_item_id;
                        request.Parameters["p_plant_site_id"] = p_plant_site_id;
                        request.Parameters["p_customer_project_code"] = "";
                        request.Parameters["p_customer_model"] = "";
                        request.Parameters["p_from_yyyymmdd"] = sStartDate;
                        request.Parameters["p_to_yyyymmdd"] = sEndDate;
                        request.Parameters["p_biztype"] = p_biztype;
                        request.Parameters["p_created_by"] = UserInfoContext.Current.UserId;
                        request.Parameters["p_userinfo"] = UserInfoContext.Current["NowGroupID"];
                        request.Parameters["p_owner"] = p_owner;
                        request.Parameters["p_over_range"] = sOverRange;                         
                        request.Parameters["p_invalid_exec"] = sInvalidExec;                                                     
                                                                                                                                 

                        request.Parameters["p_version_type"] = p_version_type;

                        var response = client.ExecuteDataSet(request);

                        return response.DataSet;
                                                 
                    }
                });
                if (ds.Tables[0].Rows.Count <= 0)
                    return;

                                        
                if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "")
                {
                                  
                                                                        
                    ds.Tables[0].Columns.Add("Action", typeof(string));

                                    
                    string sSortList = "";
                    for (int i = 1; i <= siMain.GetColumnIndex(DefColumns.MEASURE) - 1; i++)
                    {
                        if (siMain.GetColumnValue(i).ToUpper() == "COLMERGE" || siMain.GetColumnValue(i).ToUpper() == "ACTION")
                            continue;

                        sSortList += siMain.GetColumnValue(i) + " ASC,";
                    }
                    sSortList = sSortList.TrimEnd(',');

                    DataTable dtResultSort = ds.Tables[0].Select("", sSortList).CopyToDataTable<DataRow>();
                    ds.Tables.Remove(ds.Tables[0]);
                    ds.Tables.Add(dtResultSort);

                    siMain.Query(ds);
                    siMain.LockColumn(0, siMain.GetMaxColumnIndex(), true);
                }

                SearchEndTime();
                siMain.SpreadObject.SuspendLayout();


                                                 


                if (siMain.GetMaxRowIndex() >= 0)
                {
                    SetSpreadColumn();
                                      

                    DateTime dateTime = DateTime.Today.AddDays(Convert.ToInt32(DayOfWeek.Monday) - Convert.ToInt32(DateTime.Today.DayOfWeek));
                    string sResultYYYYMMDD = dateTime.ToString("yyyyMMdd");
                    int iStartCol = siMain.GetColumnIndex(DefColumns.MEASURE) + 1;

                    int iResultCol = iStartCol;
                    int iResultMonth = iStartCol;


                    for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                    {
                        if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0 && int.Parse(sResultYYYYMMDD) > int.Parse(siMain.GetColumnTag(iCol).Replace("W_", "")))
                        {
                            iResultCol = iCol;
                        }
                                                                  
                        if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 && int.Parse(sResultYYYYMMDD.Substring(0, 6)) == int.Parse(siMain.GetColumnTag(iCol).Replace("M_", "").Substring(0, 6)))
                        {
                            iResultMonth = iCol;
                        }
                    }

                    if (iResultCol > iStartCol)
                    {
                        siMain.SetBGColor2(0, iStartCol, siMain.GetMaxRowIndex(), iResultCol, Color.Gainsboro);
                        siMain.SetBGColor2(0, iResultMonth, siMain.GetMaxRowIndex(), iResultMonth, Color.White);
                    }


                                      
                    if (txtVersion.Text.Trim() == "Current")
                    {
                        isCurVersion = true;
                    }
                }

                                              



                try
                {
                                    
                    for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
                    {
                        if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) > 0)
                        {
                            siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType = cellTypeImage;
                        }

                        if (siMain.GetColumnIndex(DefColumns.ITEM_ID) > 0)
                        {
                            siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType = cellTypeImage;
                        }

                                                         
                        string sColList = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ColList)).ToString();
                        string[] result = sColList.Split(new char[] { ',' });

                        if (!sColList.Equals(""))
                        {
                            for (int i = 0; i < result.Length; i++)
                            {
                                int iResultCol = siMain.GetColumnIndex(result[i]);

                                siMain.SetBGColor2(iRow, iResultCol, iRow, iResultCol, Color.Pink);

                            }
                        }

                                                
                                                      
                    }
                }
                catch (Exception exi) { throw exi; }

                                      
                                                  

                                                 

                                                    
                if (!blnInsert)
                {
                    siMain.ActiveSheet.SetActiveCell(iUpdateRow, iUpdateCol);
                    spdMain.ShowActiveCell(FarPoint.Win.Spread.VerticalPosition.Center, FarPoint.Win.Spread.HorizontalPosition.Center);
                }
                siMain.SmartColMerge();

                               
                UIEndTime();

                CanModelChange = true;
                siMain.SpreadObject.ResumeLayout();

                                      
                dtFuturePrice = GetFuturePriceInfo();

                blnWork = false;
            }
            catch (Exception ex)
            {
                MessageHelper.GMessageBoxForException(ex);

                blnWork = false;

                                        
                if (this.Visible)
                    throw ex;
            }
            finally
            {
                CanModelChange = true;
                blnWork = false;
                prg.Close();
            }
        }

        private async void SaveData()
        {
            GSCM.Windows.Forms.UI.ProgressForm prg = new GSCM.Windows.Forms.UI.ProgressForm();

            try
            {
                                    
                bool blnInsert = false;


                             
                if (blnWork)
                {
                    MessageHelper.GMessageBox("MSG00137");
                    return;
                }
                          
                blnWork = true;


                if (siMain != null && siMain.IsLock(siMain.SheetName) == false)
                {
                    DataSet dsSpread = (DataSet)siMain.SpreadObject.DataSource;

                    if (siMain.SheetName == SpdSheet.shtMain)
                    {
                                                      
                                          
                        for (int i = 0; i <= siMain.GetMaxRowIndex(); i += 4)
                        {

                            string action = siMain.GetText(i, siMain.GetColumnIndex(CAppSetting.StringAction));
                                                                    

                                                                                              
                            string sNewFlag = "N";
                            if (siMain.GetColumnIndex(DefColumns.NewFlag) != -1)
                                sNewFlag = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.NewFlag));

                            if (sNewFlag == CAppSetting.StringY && action == CAppSetting.FlagM)
                                action = CAppSetting.FlagI;

                                                                                            
                            if (action != CAppSetting.FlagI)                                                                  
                                continue;
                            string sDIVISION_ID = "";
                            string sPROJECT_CODE = "";
                            string sSCM_SITE_ID = "";
                            string p_plant_site_id = "";
                            string sITEM_ID = "";
                            string sCURRENCY = "";
                            string sMEASURE = "";
                            string sDomExp = "";
                            string sFcstType = "";
                            string sINCOTERMS = "";

                                                  
                                                                                                  
                            int CurrentDataRow = i;
                            if (sDIVISION_ID == "82" && sNewFlag == CAppSetting.StringY)
                                CurrentDataRow = GetCellIndexBySpanRowCells(i);


                            if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) != -1)
                                sDIVISION_ID = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID));
                                                                                        
                                
                                                                                                              
                            if (sDIVISION_ID == "40")
                            {
                                sPROJECT_CODE = siMain.GetText(i, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40));
                            }
                            else if ((sDIVISION_ID.Substring(0, 2) == "81") || (sDIVISION_ID == "82"))
                            {
                                sPROJECT_CODE = siMain.GetText(i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE));
                            }
                                
                            if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) != -1)
                                sSCM_SITE_ID = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID));
                            if (siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID) != -1)
                                p_plant_site_id = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID));
                            if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                                sITEM_ID = siMain.GetText(i, siMain.GetColumnIndex(DefColumns.ITEM_ID));
                            if (siMain.GetColumnIndex(DefColumns.CURRENCY) != -1)
                                sCURRENCY = siMain.GetText(i, siMain.GetColumnIndex(DefColumns.CURRENCY));
                            if (siMain.GetColumnIndex(DefColumns.MEASURE) != -1)
                                sMEASURE = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MEASURE));
                            if (siMain.GetColumnIndex(DefColumns.DomExp) != -1)
                                sDomExp = siMain.GetText(CurrentDataRow, siMain.GetColumnIndex(DefColumns.DomExp));                                                                      
                            if (siMain.GetColumnIndex(DefColumns.FcstType) != -1)
                                sFcstType = (string)siMain.GetValue(CurrentDataRow, siMain.GetColumnIndex(DefColumns.FcstType));                                                                      
                            if (siMain.GetColumnIndex(DefColumns.INCOTERMS) != -1)
                                sINCOTERMS = (string)siMain.GetValue(CurrentDataRow, siMain.GetColumnIndex(DefColumns.INCOTERMS));                                                                      


                                                                      
                            if (sDIVISION_ID == "" ||
                            sPROJECT_CODE == "" ||
                            sSCM_SITE_ID == "" ||
                            (sDIVISION_ID.Substring(0, 2) == "81" && p_plant_site_id == "") ||                                                     
                            sITEM_ID == "" ||
                            sCURRENCY == "" ||
                            sMEASURE == "" ||
                            sDomExp == "" ||
                            sFcstType == "" ||
                                sINCOTERMS == ""
                            )
                            {
                                string sMsg = "";
                                if (sDIVISION_ID == "")
                                    sMsg += "[Division],";
                                else if (sPROJECT_CODE == "")
                                {
                                    if (sDIVISION_ID == "40")
                                    {
                                        sMsg += "[End Customer],";
                                    }
                                    else if ((sDIVISION_ID.Substring(0, 2) == "81") || (sDIVISION_ID == "82"))
                                    {
                                        sMsg += "[Project Code],";
                                    }
                                }
                                else if (sSCM_SITE_ID == "")
                                    sMsg += "[Sales Site]],";
                                else if (sITEM_ID == "")
                                    sMsg += "[Model],";
                                else if (sCURRENCY == "")
                                    sMsg += "[Currency],";
                                else if (sMEASURE == "")
                                    sMsg += "[Measure],";
                                else if (sDomExp == "")
                                    sMsg += "[Customs Handbook],";
                                else if (sFcstType == "")
                                    sMsg += "[FCST Type],";
                                else if (sINCOTERMS == "")
                                    sMsg += "[Incoterms],";
                                                                                    
                                else if (sDIVISION_ID.Substring(0, 2) == "81" && p_plant_site_id == "")
                                    sMsg += "[Plant Site],";
                                sMsg = sMsg.TrimEnd(',');

                                MessageHelper.GMessageBox("MSG00002", new object[] { sMsg });

                                                
                                siMain.SpreadObject.ActiveSheet.SetActiveCell(i, 2);

                                return;
                            }


                                                         
                            if (!fnValidation())
                            {
                                string sMsg = "[Division],";

                                if (sDIVISION_ID == "40")
                                {
                                    sMsg += "[End Customer],";
                                }
                                else
                                {
                                    sMsg += "[Project Code],[PLANT_SITE_ID]";
                                }
                                sMsg += "[Sales Site],[Model],[INCOTERMS],[FcstType],[Customs Handbook],[Currency]";

                                MessageHelper.GMessageBox("MSG00043", new object[] { sMsg });                          
                                return;
                            }
                        }

                                         
                        NameValueCollection nvc = new NameValueCollection();
                        prg.Show();
                        int iCUD_Total = 0;
                        int iCUD_R = 0;
                        int iUpdateRow = 0;
                        int iCUD = 0;

                                                                                     
                                                                         
                        string sScmsiteid = "";
                        string sProjectcode = "";
                        string sItemid = "";
                        string sDivision = "";
                                                                                   

                        for (int i = 0; i <= siMain.GetMaxRowIndex(); i++)
                        {
                            string action = siMain.GetText(i, siMain.GetColumnIndex(CAppSetting.StringAction));
                                                                    

                            string sDIVISION_ID = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID));

                                
                            if (action == CAppSetting.FlagI)
                                blnInsert = true;

                            if (action != CAppSetting.FlagI && action != CAppSetting.FlagM && action != CAppSetting.FlagD)
                            {
                                continue;
                            }
                                                  
                                                                                                  
                            int CurrentDataRow = i;
                            if (action == CAppSetting.FlagI
                                || (sDIVISION_ID == "82" && siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.NewFlag)).ToString() == CAppSetting.StringY && action == CAppSetting.FlagM))
                            {
                                CurrentDataRow = GetCellIndexBySpanRowCells(i);
                            }

                            sDIVISION_ID = (string)siMain.GetValue(CurrentDataRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID));
                            string sSCM_SITE_ID = (string)siMain.GetValue(CurrentDataRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID));
                            string sPROJECT_CODE = "";
                            string p_plant_site_id = "";
                            string sITEM_ID = "";
                            string sINCOTERMS = "";
                            string sCURRENCY = "";
                            string sFcstType = "";
                            string sDomExp = "";
                                                                                                              
                            if (sDIVISION_ID == "40")
                            {
                                sPROJECT_CODE = siMain.GetText(CurrentDataRow, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40));
                            }
                            else if (sDIVISION_ID.Substring(0, 2) == "81")
                            {
                                sPROJECT_CODE = siMain.GetText(CurrentDataRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE));
                                p_plant_site_id = (string)siMain.GetValue(CurrentDataRow, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID));
                            }
                            else if (sDIVISION_ID == "82")
                            {
                                sPROJECT_CODE = siMain.GetText(CurrentDataRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE));
                            }
                            if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                                sITEM_ID = siMain.GetText(CurrentDataRow, siMain.GetColumnIndex(DefColumns.ITEM_ID));
                            if (siMain.GetColumnIndex(DefColumns.INCOTERMS) != -1)
                                sINCOTERMS = (string)siMain.GetValue(CurrentDataRow, siMain.GetColumnIndex(DefColumns.INCOTERMS));
                            if (siMain.GetColumnIndex(DefColumns.CURRENCY) != -1)
                                sCURRENCY = siMain.GetText(CurrentDataRow, siMain.GetColumnIndex(DefColumns.CURRENCY));
                            if (siMain.GetColumnIndex(DefColumns.FcstType) != -1)
                                sFcstType = (string)siMain.GetValue(CurrentDataRow, siMain.GetColumnIndex(DefColumns.FcstType));
                            if (siMain.GetColumnIndex(DefColumns.DomExp) != -1)
                                sDomExp = (string)siMain.GetValue(CurrentDataRow, siMain.GetColumnIndex(DefColumns.DomExp));
                            
                                                                                         
                                                                                 
                            sScmsiteid = sSCM_SITE_ID;
                            sProjectcode = sPROJECT_CODE;
                            sItemid = sITEM_ID;
                            sDivision = sDIVISION_ID;
                                                                                       

                                                         
                            string sMEASURE = siMain.GetText(i, siMain.GetColumnIndex(DefColumns.MEASURE));

                                           
                                                          
                            if (sMEASURE == "RTF" || sMEASURE == "RTF_SYS_RP") continue;


                            iCUD = 0;
                            for (int j = siMain.GetColumnIndex(DefColumns.MEASURE) + 1; j <= siMain.GetMaxColumnIndex(); j++)
                            {
                                
                                                                 
                                int[] iArray = GetCellNumbersByRow(i);
                                                                                                                                 
                                if (siMain.GetForeColor(iArray[iArray.Length - 1], j) != System.Drawing.Color.Red)
                                    continue;

   
                                                                                                                                                                
                                  
                                                                                              
                                              
                                  
                                  

                                    if (siMain.GetColumnTag(j).IndexOf("M_") == 0)
                                    continue;

                                string sYYYYMMDD = siMain.GetColumnTag(j).Replace("W_", "");

                                string sPRICE = Convert.ToString(siMain.GetValue(i, j));

                                                  
                                if (sPRICE == "")
                                    sPRICE = "0";
                                string stempAction = action;

                                                                                       
                                                                          
                                if (action != "D" && sMEASURE == "LOC")
                                {
                                    if (sPRICE == "0")
                                        stempAction = "D";
                                           
                                                            
                                }

                                nvc["p_active_flag"] = CString.AppendStringEx(nvc["p_active_flag"], stempAction, iCUD);
                                nvc["p_DIVISION_ID"] = CString.AppendStringEx(nvc["p_DIVISION_ID"], sDIVISION_ID, iCUD);
                                nvc["p_PROJECT_CODE"] = CString.AppendStringEx(nvc["p_PROJECT_CODE"], sPROJECT_CODE, iCUD);
                                nvc["p_SCM_SITE_ID"] = CString.AppendStringEx(nvc["p_SCM_SITE_ID"], sSCM_SITE_ID, iCUD);
                                nvc["p_PLANT_SITE_ID"] = CString.AppendStringEx(nvc["p_PLANT_SITE_ID"], p_plant_site_id, iCUD);
                                nvc["p_ITEM_ID"] = CString.AppendStringEx(nvc["p_ITEM_ID"], sITEM_ID, iCUD);
                                nvc["p_YYYYMMDD"] = CString.AppendStringEx(nvc["p_YYYYMMDD"], sYYYYMMDD, iCUD);
                                nvc["p_CURRENCY"] = CString.AppendStringEx(nvc["p_CURRENCY"], sCURRENCY, iCUD);

                                nvc["p_MEASURE"] = CString.AppendStringEx(nvc["p_MEASURE"], sMEASURE, iCUD);
                                nvc["p_DOM_EXP"] = CString.AppendStringEx(nvc["p_DOM_EXP"], sDomExp, iCUD);
                                nvc["p_FCST_TYPE"] = CString.AppendStringEx(nvc["p_FCST_TYPE"], sFcstType, iCUD);
                                nvc["p_INCOTERMS"] = CString.AppendStringEx(nvc["p_INCOTERMS"], sINCOTERMS, iCUD);
                                nvc["p_PRICE"] = CString.AppendStringEx(nvc["p_PRICE"], sPRICE, iCUD);
                                nvc["p_CREATED_BY"] = CString.AppendStringEx(nvc["p_CREATED_BY"], UserInfoContext.Current.UserId, iCUD);
                                nvc["p_CREATION_DATE"] = CString.AppendStringEx(nvc["p_CREATION_DATE"], System.DateTime.Now.ToString(), iCUD);
                                nvc["p_LAST_UPDATED_BY"] = CString.AppendStringEx(nvc["p_LAST_UPDATED_BY"], UserInfoContext.Current.UserId, iCUD);
                                nvc["p_ROWNUM"] = CString.AppendStringEx(nvc["p_ROWNUM"], (i + 1).ToString(), iCUD);                                      

                                if ((j % 20) == 0)
                                    Application.DoEvents();

                                iCUD++;
                            }

                            iUpdateRow = i;
                            iCUD_R++;
                            iCUD_Total += iCUD;
                        }
                                          
                        prg.Close();

                                      
                        string sPrice = nvc["p_PRICE"];
                        if (string.IsNullOrEmpty(sPrice) == false)
                        {
                            sPrice = nvc["p_PRICE"].ToString().Replace("0", "").Replace("^", "");
                        }
                                                                                    
                                                                                                      
                        else
                        {
                            string sProjectname = "";
                            if (sDivision == "40")
                            {
                                sProjectname = "END CUSTOMER";
                            }
                            else
                            {
                                sProjectname = "PROJECT_CODE";
                            }

                            MessageHelper.GMessageBox("MSG00414", new object[] { sScmsiteid, sProjectname, sProjectcode, sItemid });
                            return;
                        }
                                                                                  

                                      
                        var asyncProxy = new FoxAsyncProxy(this);

                        DataSet ds = await asyncProxy.ExecuteAsync<DataSet>(() =>
                        {
                            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
                            {
                                var request = new FoxDataRequest("DM.DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL");
                                request.CommandTimeout = 90 * 60;

                                for (int i = 0; i < nvc.Count; i++)
                                    request.Parameters[nvc.GetKey(i)] = nvc[i];

                                var response = client.ExecuteDataSet(request);

                                return response.DataSet;
                            }
                        });

                                    
                        string sResultMsg = ds.Tables[0].Rows[0][0].ToString();
                        if (sResultMsg != "success")
                        {
                            string sErrMsg = "";
                            for (int i = 0; i < ds.Tables[0].Columns.Count; i++)
                            {
                                sErrMsg += ds.Tables[0].Rows[0][i].ToString() + ",";
                            }
                            sErrMsg.TrimEnd(',');
                            MessageBox.Show(sErrMsg, "Error!");
                            return;
                        }

                        if (ds.Tables[3].Rows[0][0].ToString() != "")
                            MessageBox.Show(ds.Tables[3].Rows[0][0].ToString(), "Error!");

                                               
                        panel1.Visible = false;
                        MessageHelper.GMessageBox("MSG00004", new object[] { iCUD_Total });                 


                        string sDivisionId = CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues);                               

                                                           
                        if (ds.Tables[2].Rows.Count > 0)
                        {
                            DMF0020_SalesPriceRangePopUp popup = new DMF0020_SalesPriceRangePopUp();
                            popup.LoadData(ds.Tables[2], sDivisionId);
                            popup.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                            popup.ShowDialog();

                        }
                                
                        blnWork = false;

                                   
                        if (blnInsert)
                            FindData(true);
                        else
                            FindData(false, iUpdateRow, siMain.ActiveSheet.ActiveColumnIndex);
                    }
                }
            }
            catch (Exception ex)
            {
                                   
                throw ex;
            }
            finally
            {
                prg.Close();
                        
                blnWork = false;

            }
        }

        public System.Drawing.Color GetCellColor(SpreadInfo siInfo, int iRow1, int iCol1, int iRow2, int iCol2)
        {
            FpSpread fpSpread = siInfo.SpreadObject;
                                                           
            FarPoint.Win.Spread.Cell range1;
            range1 = fpSpread.ActiveSheet.Cells[iRow1, iCol1, iRow2, iCol2];
            var vCellColor = range1.ForeColor;

            return vCellColor;
        }

        private void InsertRow()
        {
            if (siMain != null && siMain.IsLock(siMain.SheetName) == false)
            {
                if (siMain.SheetName == SpdSheet.shtMain)
                {
                    HaltAutoFilter = true;
                    siMain.SpreadObject.SuspendLayout();
                                                   
                    int[] iArray = GetCellNumbersByRow(siMain.ActiveRowIndex);
                    siMain.SpreadObject.ActiveSheet.SetActiveCell(iArray[0], 2);

                             
                    siMain.SpreadObject.SuspendLayout();
                    FarPoint.Win.Spread.Cell insCell = siMain.Insert2(dtMeasureCount.Rows.Count);
                                             
                                                                                        
                    string sDivision = clbDivisions.SelectedValue.ToString();

                                                                                                                                                           
                    DataTable dtTeamAuth = Data.UserTeamByDivisionAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision);
                    DataTable dtEndCustomerAuth;                                                                                                                                   
                    DataTable dtSalesSiteAuth;                                                                                                                           
                                       
                    if (sDivision == "40")
                    {
                        dtSalesSiteAuth = Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "");
                        dtEndCustomerAuth = Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
                                                             
                        DataTable dtCustomsHandbook = GetCustomsHandbook();
                        siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DomExp), dtCustomsHandbook);

                    }
                                                                           
                        
                                                                                                                                                              
                                                                                                                    
                        
                    else
                    {
                        dtSalesSiteAuth = Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "");
                        dtEndCustomerAuth = Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "");
                    }
                                                                                               
                    dtincotermsEditType = GetLookupValues("INCOTERMS", "ALL", "Y", "", "", "");
                    if (siMain.GetColumnIndex(DefColumns.INCOTERMS) != -1)
                        siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.INCOTERMS), dtincotermsEditType);
                                                                               

                                                                 
                    if (siMain.GetColumnIndex(DefColumns.DEPT_ID) != -1)
                        siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeamAuth);
                    if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) != -1)
                        siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSiteAuth);
                    if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER) != -1)
                        siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomerAuth);
                    if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) != -1)
                        siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType = cellTypeImage;
                    if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER40) != -1)
                        siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), dtEndCustomerAuth);
                    if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                        siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType = cellTypeImage;

                                                                                           
                                                                            
                                                                                                                                     
                    for (int i = 0; i < dtMeasureCount.Rows.Count; i++)
                    {
                        siMain.SetText2(siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.DIVISION_ID), clbDivisions.SelectedValue.ToString());
                        siMain.LockRange2(siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.DIVISION_ID), true);

                                                                                     
                        if (siMain.GetColumnIndex(DefColumns.INCOTERMS) != -1)
                            siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.INCOTERMS), dtincotermsEditType);
                                                                                   
                        if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                            siMain.ActiveSheet.Cells[siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType = cellTypeImage;
                                                                                               
                                                                                
                                                                                                                                             

                                                                                            
                        if (siMain.GetColumnIndex(DefColumns.DEPT_ID) != -1)
                        {
                            siMain.SetCellTypeCombo(siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeamAuth);
                                                                                                                                                                                                    
                        }

                        if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) != -1)
                            siMain.SetCellTypeCombo(siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSiteAuth);
                        if (siMain.GetColumnIndex(DefColumns.MEASURE) != -1)
                            siMain.SetText2(siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.MEASURE), dtMeasureCount.Rows[i]["LOOKUP_CODE"].ToString());

                        siMain.LockRange2(siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.DIVISION_ID) + 1, siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.MEASURE), false);

                        if (clbDivisions.SelectedValue.ToString() == "40")
                        {
                            siMain.SetCellTypeCombo(siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), dtEndCustomerAuth);
                                                                                                                                                                                                               
                        }
                        else
                        {
                            if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER) != -1)
                                siMain.SetCellTypeCombo(siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomerAuth);
                            if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) != -1)
                                siMain.ActiveSheet.Cells[siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType = cellTypeImage;
                            if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME) != -1)
                                siMain.LockRange2(siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), true);
                            if (siMain.GetColumnIndex(DefColumns.ProjectStatus) != -1)
                                siMain.LockRange2(siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.ProjectStatus), siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.ProjectStatus), true);
                            if (siMain.GetColumnIndex(DefColumns.BizTypeName) != -1)
                                siMain.LockRange2(siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.BizTypeName), siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.BizTypeName), true);
                        }


                                                                                                                                                                                               
                        if (siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME) != -1)
                            siMain.LockRange2(siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), true);
                        if (siMain.GetColumnIndex(DefColumns.ITEM_NAME) != -1)
                            siMain.LockRange2(siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.ITEM_NAME), siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.ITEM_NAME), true);
                        if (siMain.GetColumnIndex(DefColumns.MEASURE) != -1)
                            siMain.LockRange2(siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.MEASURE), siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.MEASURE), true);
                        if (siMain.GetColumnIndex(DefColumns.NICK_NAME) != -1)
                            siMain.LockRange2(siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.NICK_NAME), siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.NICK_NAME), true);

                        if (dtMeasureCount.Rows[i]["LOOKUP_CODE"].ToString().ToUpper() != "LOC")
                        {
                            siMain.LockRange2(siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.MEASURE), siMain.ActiveRowIndex + i, siMain.GetMaxColumnIndex(), true);
                        }
                        else
                        {
                                                                                                                      
                                                                                           
                                                                         
                                                                                                                        
                                
                                                                                                                                                       
                                                                                    
                                                                                           
 
                                                        
                                                          
 
 
                                                                                                   
                              
                                                                                                                                                                         
                                  
                                                       
                                  
                                                                          
                                                                                                                                                                                                          
                                  
                                                         
                                  
                              
 
                                                        
                              
                                                                                                                                                                     
                              
                              
                                                                                                                      
                                      
                                                                                                                        


                                                              
                                                                                                                                    
                                
                                               
                                string sThisWeek = "";
                                for (int j = 0; j <= dtWeek.Rows.Count; j++)
                                {
                                    if (j == 0)
                                        sThisWeek = dtWeek.Rows[j]["BASIS_START_DATE"].ToString();

                                    string sLastWeek = dtWeek.Rows[j]["BASIS_START_DATE"].ToString();
                                    try
                                    {
                                        if (sThisWeek != sLastWeek)
                                        {
                                            siMain.LockRange2(siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.MEASURE), siMain.ActiveRowIndex + i, siMain.GetColumnIndex("W_" + sLastWeek), true);
                                            break;
                                        }
                                    }
                                    catch { break; }
                                }
                                
                        }

                                           
                        siMain.LockRange2(siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.PRICE_EXIST), siMain.ActiveRowIndex + i, siMain.GetColumnIndex(DefColumns.PRICE_EXIST), true);
                    }

                                             
                                                                
                    CUIControl.SetRowSpanFuc(siMain, siMain.ActiveRowIndex, dtMeasureCount.Rows.Count - 1, 1, siMain.GetColumnIndex(DefColumns.MEASURE) - 1, FarPoint.Win.Spread.CellHorizontalAlignment.Left, FarPoint.Win.Spread.CellVerticalAlignment.Center);

                                                          
                    HaltAutoFilter = false;

                                              
                                              
                                             
                                              
                                             



                    if (siMain != null && siMain.ActiveSheet.RowFilter != null)
                        siMain.ActiveSheet.RowFilter.UnfilteredRows = null;
                    ManualAutoFilter(siMain.SpreadObject);
                    this.IsChange = true;
                    siMain.SpreadObject.SuspendLayout();
                    siMain.SpreadObject.ResumeLayout();

                                                     
                                                          


                                              
                                                             
                                                                                                                                 
                                       
                                                     
                }
            }
        }

        private bool fnValidation()
        {
            bool bValidation = true;
            int iValidation = 0;
            string sProjectCode = string.Empty;
            string sSiteId = string.Empty;
            string sItemId = string.Empty;
            string sCurrency = string.Empty;

                     
            for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow += 4)
            {
                if (siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI)
                {
                                                         
                    string sDivision = string.Empty;            
                    string sDomExp = "", sFcstType = "", sIncoterms = "", sMeasure = "", sPlantSiteId = "";

                    if ((clbDivisions.ControlValues.Substring(0, 2) == "81") || (clbDivisions.ControlValues == "82"))
                    {
                        sDivision = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                        sProjectCode = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString();
                    }
                                                                                                             
                        
                                                                                                                       
                                                                                                                             
                        
                    else
                    {
                        sDivision = "40";
                        sProjectCode = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)).ToString();
                    }
                    if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) != -1)
                        sSiteId = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                        sItemId = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.DomExp) != -1)
                        sDomExp = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DomExp)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.FcstType) != -1)
                        sFcstType = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FcstType)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.INCOTERMS) != -1)
                        sIncoterms = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.INCOTERMS)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.CURRENCY) != -1)
                        sCurrency = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.CURRENCY)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.MEASURE) != -1)
                        sMeasure = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString();

                    if (clbDivisions.ControlValues.Substring(0, 2) == "81")
                    {
                        sPlantSiteId = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID)).ToString();
                    }

                             
                    for (int iRow2 = 0; iRow2 <= siMain.GetMaxRowIndex(); iRow2 += 4)
                    {
                        if (clbDivisions.ControlValues.Substring(0, 2) == "81")
                        {
                            if (sDivision == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString()
                            && sProjectCode == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString()
                            && sSiteId == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString()
                            && sItemId == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString()
                            && sDomExp == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.DomExp)).ToString()
                            && sFcstType == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.FcstType)).ToString()
                            && sIncoterms == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.INCOTERMS)).ToString()
                            && sCurrency == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.CURRENCY)).ToString()
                            && sMeasure == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString()
                            && sPlantSiteId == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID)).ToString()
                           )
                            {
                                iValidation++;
                            }
                        }
                        else if (clbDivisions.ControlValues == "82")
                        {
                            if (sDivision == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString()
                            && sProjectCode == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString()
                            && sSiteId == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString()
                            && sItemId == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString()
                            && sDomExp == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.DomExp)).ToString()
                            && sFcstType == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.FcstType)).ToString()
                            && sIncoterms == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.INCOTERMS)).ToString()
                            && sCurrency == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.CURRENCY)).ToString()
                            && sMeasure == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString()
                           )
                            {
                                iValidation++;
                            }
                        }
                                                                                                                 
                            
                                                                                                                                
                                                                                                                             
                                                                                                                         
                                                                                                                            
                                                                                                                              
                                                                                                                            
                                                                                                                          
                               
                                
                                                 
                                
                            
                        else
                        {
                            if (sDivision == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString()
                            && sProjectCode == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)).ToString()
                            && sSiteId == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString()
                            && sItemId == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString()
                            && sDomExp == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.DomExp)).ToString()
                            && sFcstType == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.FcstType)).ToString()
                            && sIncoterms == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.INCOTERMS)).ToString()
                            && sCurrency == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.CURRENCY)).ToString()
                            && sMeasure == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString()
                           )
                            {
                                iValidation++;
                            }
                        }
                    }
                    if (iValidation > 1)
                    {
                        break;
                    }
                    iValidation = 0;
                }
            }

            if (iValidation > 1)
            {
                bValidation = false;
                return bValidation;
            }

            return bValidation;
        }
        #endregion

        #region 6. Event
        #endregion


                      
                                                              
                       
                                          
                                     
        private void btnSavePricePeriod_Click(object sender, EventArgs e)
        {
                                          
                                   
                                                
                          
            if (!siMain.IsLock(siMain.SheetName))
            {
                                                                                 
                MessageHelper.GMessageBox("MSG00408");                       
                return;
            }


            DMF0020_SaveSalesFuturePrice_Popup popup = new DMF0020_SaveSalesFuturePrice_Popup();

                         
            string sEndCustomer = CString.GetCheckedListValue(dtEndCustomer, clbEndCustomer.ControlValues);

            popup.LoadData(clbDivisions.ControlValues.ToString()
                            , drpDateTime.Value1.ToString("yyyyMMdd"), drpDateTime.Value2.ToString("yyyyMMdd")
                            , clbSalesSite.ControlValues
                            , umltProject.Text
                            , sEndCustomer
                            );
            popup.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            popup.ShowDialog();

                                                                                 
                 
                                
                                         
                
        }

        private void btnExchangeRate_Click(object sender, EventArgs e)
        {
                                          
                                   
                                                
                          
            if (!siMain.IsLock(siMain.SheetName))
            {
                                                                
                MessageHelper.GMessageBox("MSG00142");
                return;
            }

            DMF0020_SalesFuturePricePopUp popup = new DMF0020_SalesFuturePricePopUp();
            popup.LoadData(drpDateTime.Value1.ToString("yyyyMM"), drpDateTime.Value1.AddYears(1).ToString("yyyyMM"));
            popup.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            popup.ShowDialog();

            if (popup.blnOK)
            {
                                            
                dtFuturePrice = GetFuturePriceInfo();

                                    
                FindData(true);
            }
        }

        private void usrButton1_Click(object sender, EventArgs e)
        {
            if (clbDivisions.SelectedValue.ToString() != "40")
            {
                              
                string sDivision = CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues);                               
                string sTeam = clbTeam.ControlValues;
                string sEndCustomer = clbEndCustomer.ControlValues;
                string sScmSite = clbSalesSite.ControlValues;
                string sProject = umltProject.Text;
                SCM0002_ProjectbyDivisionPopupEx popProject = new SCM0002_ProjectbyDivisionPopupEx();
                popProject.Form_Load(true, sDivision, sTeam, sEndCustomer, sScmSite, sProject);
                popProject.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                popProject.ShowDialog();

                umltProject.Text = popProject.ProjectCode;
            }
        }

        private void btnModelType_Click(object sender, EventArgs e)
        {

                          
            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues);                                
                                                                                         
            string sTeam = clbTeam.ControlValues;
            string sEndCustomer = clbEndCustomer.ControlValues;
            string sProject = umltProject.Text;                                                                  
            string sScmSiteId = clbSalesSite.ControlValues;
            string sItemId = umltModel.Text;

                                                                                           
            DM0002_ItembyDivisionPopupEx popItem = new DM0002_ItembyDivisionPopupEx();

                                   
            popItem.Form_Load(true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId);
            popItem.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            popItem.ShowDialog();

            umltModel.Text = popItem.ItemID;
        }

        private void clbDivisions_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                             
                if (blnWork)
                {
                                                             
                    return;
                }
                          
                blnWork = true;

                                                                            
                DataService.FP_Log2("SpeedUp", "DMF0020", "division_id_changed", "start");
                string sDivision = CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues);

                                                                            
                                                                                                                                      
                SetChangeControl("UserTeamByDivision", sDivision);
                clsCtrl.setListBox(dtTeam, clbTeam, true);

                string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);

                                                                                                      

                if ((sDivision.Substring(0, 2) == "81") || (sDivision == "82"))
                {
                                                                                
                                                                                                                                                                   
                    SetChangeControl("EndCustomerByDivision", sDivision, sTeam);
                    clsCtrl.setListBox(dtEndCustomer, clbEndCustomer, true);

                                                                                
                    dtBizType = GetBizTypebyDivision(clbDivisions.ControlValues);
                    SetChangeControl("BizType", clbDivisions.ControlValues);

                    clsCtrl.setListBox(dtBizType, clbBizType, true);

                    lblProject.Enabled = true;
                                                 
                    layoutControlItem6.Enabled = true;

                    if (sDivision.IndexOf("81") != -1)
                    {
                                                                                    
                                                                                                                                                                                                              
                                                     

                        SetChangeControl("UserPlantSiteByEndCustomer", clbDivisions.ControlValues, string.Empty, clbEndCustomer.ControlValues);
                        clsCtrl.setListBox(dtPlantSiteByEndCustomer, clbPlantSite, true);
                    }

                                                                        
                    if (sDivision == "82")
                    {
                        checkInvalidExec.Enabled = true;
                        lblPlantSite.Enabled = false;
                        clbPlantSite.ControlValues = "";
                    }
                    else
                    {
                        checkInvalidExec.Enabled = false;
                        lblPlantSite.Enabled = true;
                    }
                }
                else
                {
                                                                                
                                                                                                                                                                                                      
                    SetChangeControl("EndCustomerByDivision", sDivision, clbTeam.ControlValues);
                    clsCtrl.setListBox(dtEndCustomer, clbEndCustomer, true);

                                                                                
                                                                                             
                    SetChangeControl("BizType", clbDivisions.ControlValues);

                    clsCtrl.setListBox(dtBizType, clbBizType, true);

                    lblProject.Enabled = false;
                    lblPlantSite.Enabled = false;
                                                  
                    layoutControlItem6.Enabled = false;
                                                                        
                    checkInvalidExec.Enabled = false;

                    clbPlantSite.ControlValues = "";
                }
                                                                  
                                                  
                       
                lblBizType.Enabled = true;

                string sEndCustomer = CString.GetCheckedListValue(dtCustomer, clbEndCustomer.ControlValues);

                                                                            
                                                                                                                                                            
                SetChangeControl("UserSiteByEndCustomer", sDivision, string.Empty, sEndCustomer);
                clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);

                                                                            
                DataService.FP_Log2("SpeedUp", "DMF0020", "division_id_changed", "end");
                                                                                
                   
                                                                                                                                                  
                                                                           

                this.txtOwner.Text = "";
                this.umltProject.Text = "";
                this.umltModel.Text = "";

                InitSpread(true);

                                               
                if (clbDivisions.ControlValues.Substring(0, 2) == "81")
                {
                    btnExcelUpload.Visible = btnTemplate.Visible = true;
                    layoutControlItem12.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Always;
                    layoutControlItem29.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Always;
                }
                else
                {
                    btnExcelUpload.Visible = btnTemplate.Visible = false;
                    layoutControlItem12.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
                    layoutControlItem29.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
                }
            }
            catch (Exception ex)
            {
                blnWork = false;
                throw ex;
            }
            finally
            {
                blnWork = false;
            }
        }

        private void spdMain_ComboSelChange(object sender, FarPoint.Win.Spread.EditorNotifyEventArgs e)
        {
            if (siMain.IsLock(siMain.SheetName) == false)
            {
                string sDivision = CAppSetting.StringALL;
                string sTeam = CAppSetting.StringALL;
                string sEndCustomer = CAppSetting.StringALL;
                string sScmSite = CAppSetting.StringALL;

                if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID))
                {
                    sDivision = siMain.GetValue(e.Row, e.Column).ToString();

                    if (siMain.GetColumnIndex(DefColumns.DEPT_ID) > 0)
                    {
                        dtTeam = Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision);
                                                                                                                                                  
                        siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeam);
                        CUIControl.SetCellRangeAligement(siMain, e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), e.Row + 2, siMain.GetColumnIndex(DefColumns.DEPT_ID), FarPoint.Win.Spread.CellHorizontalAlignment.Left, FarPoint.Win.Spread.CellVerticalAlignment.Center);

                        sTeam = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID)).ToString();
                    }

                    if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER) > 0)
                    {
                                 
                        sTeam = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID)).ToString();
                        dtEndCustomer = Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam);
                        siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer);
                        CUIControl.SetCellRangeAligement(siMain, e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), e.Row + 2, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), FarPoint.Win.Spread.CellHorizontalAlignment.Left, FarPoint.Win.Spread.CellVerticalAlignment.Center);

                        sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER)).ToString();
                    }
                    else if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER40) > 0)
                    {
                             
                        sTeam = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID)).ToString();
                        dtEndCustomer = Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
                        siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), dtEndCustomer);
                        CUIControl.SetCellRangeAligement(siMain, e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), e.Row + 2, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), FarPoint.Win.Spread.CellHorizontalAlignment.Left, FarPoint.Win.Spread.CellVerticalAlignment.Center);

                        sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)).ToString();
                    }

                                                                                                                                                     
                    dtSalesSite = Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
                                                                                                                                                
                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite);
                    CUIControl.SetCellRangeAligement(siMain, e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), e.Row + 2, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), FarPoint.Win.Spread.CellHorizontalAlignment.Left, FarPoint.Win.Spread.CellVerticalAlignment.Center);


                                                                                    
                                                                                                                                                    
                                                                                                                                                     
                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), dtPlantSite);
                    CUIControl.SetCellRangeAligement(siMain, e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), e.Row + 2, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), FarPoint.Win.Spread.CellHorizontalAlignment.Left, FarPoint.Win.Spread.CellVerticalAlignment.Center);

                    if (sDivision.Substring(0, 2) != "81")
                        siMain.LockRange2(e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), true);
                    else
                        siMain.LockRange2(e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), false);

                                     
                    if (siMain.GetColumnIndex(DefColumns.DEPT_ID) != -1)
                        siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), "");
                    if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER) != -1)
                        siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), "");
                    if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) != -1)
                        siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "");
                    if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) != -1)
                        siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "");
                    if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME) != -1)
                        siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "");
                    if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                        siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "");
                    if (siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME) != -1)
                        siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "");
                }
                else if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT_ID))
                {
                    if ((siMain.GetColumnIndex(DefColumns.END_CUSTOMER) > 0) || (siMain.GetColumnIndex(DefColumns.END_CUSTOMER40) > 0))
                    {
                        sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                        sTeam = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID)).ToString();

                        if ((sDivision.Substring(0, 2) == "81") || (sDivision == "82"))
                        {
                            dtEndCustomer = Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam);
                            siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer);
                            sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER)).ToString();
                            CUIControl.SetCellRangeAligement(siMain, e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), e.Row + 2, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), FarPoint.Win.Spread.CellHorizontalAlignment.Left, FarPoint.Win.Spread.CellVerticalAlignment.Center);
                        }
                        else
                        {
                            dtEndCustomer = Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
                            siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), dtEndCustomer);
                            sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)).ToString();
                            CUIControl.SetCellRangeAligement(siMain, e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), e.Row + 2, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), FarPoint.Win.Spread.CellHorizontalAlignment.Left, FarPoint.Win.Spread.CellVerticalAlignment.Center);
                        }
                        dtSalesSite = Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
                        siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite);
                        CUIControl.SetCellRangeAligement(siMain, e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), e.Row + 2, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), FarPoint.Win.Spread.CellHorizontalAlignment.Left, FarPoint.Win.Spread.CellVerticalAlignment.Center);
                    }
                    if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER) != -1)
                        siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), "");
                    if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) != -1)
                        siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "");
                    if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) != -1)
                        siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "");
                    if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME) != -1)
                        siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "");
                    if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                        siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "");
                    if (siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME) != -1)
                        siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "");
                }
                else if (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER))
                {
                    sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER)).ToString();
                    dtSalesSite = Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite);
                    CUIControl.SetCellRangeAligement(siMain, e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), e.Row + 2, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), FarPoint.Win.Spread.CellHorizontalAlignment.Left, FarPoint.Win.Spread.CellVerticalAlignment.Center);
                    CUIControl.SetCellRangeAligement(siMain, e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), e.Row + 2, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), FarPoint.Win.Spread.CellHorizontalAlignment.Left, FarPoint.Win.Spread.CellVerticalAlignment.Center);

                    if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) != -1)
                        siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "");
                    if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) != -1)
                        siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "");
                    if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME) != -1)
                        siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "");
                    if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                        siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "");
                    if (siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME) != -1)
                        siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "");
                }
                else if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID))
                {
                    if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) != -1)
                        siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "");
                    if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME) != -1)
                        siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "");
                    if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                        siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "");
                    if (siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME) != -1)
                        siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "");
                }
                              
                else if (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40))
                {
                    sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                    sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)).ToString();

                    dtSalesSite = Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite);
                    CUIControl.SetCellRangeAligement(siMain, e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), e.Row + 2, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), FarPoint.Win.Spread.CellHorizontalAlignment.Left, FarPoint.Win.Spread.CellVerticalAlignment.Center);
                }
                                                                                     
                                                                             
                else if (e.Column == siMain.GetColumnIndex(DefColumns.INCOTERMS) && siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS)).ToString() == "")
                {
                    siMain.SetValue(e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), siMain.GetValue(sTempRow, siMain.GetColumnIndex(DefColumns.INCOTERMS)).ToString());
                }
                else if (e.Column == siMain.GetColumnIndex(DefColumns.FcstType) && siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FcstType)).ToString() == "")
                {
                    siMain.SetValue(e.Row, siMain.GetColumnIndex(DefColumns.FcstType), siMain.GetValue(sTempRow, siMain.GetColumnIndex(DefColumns.FcstType)).ToString());
                }
                else if (e.Column == siMain.GetColumnIndex(DefColumns.DomExp) && siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DomExp)).ToString() == "")
                {
                    siMain.SetValue(e.Row, siMain.GetColumnIndex(DefColumns.DomExp), siMain.GetValue(sTempRow, siMain.GetColumnIndex(DefColumns.DomExp)).ToString());
                }
                                                                            
                else if (e.Column == siMain.GetColumnIndex(DefColumns.CURRENCY) && siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.CURRENCY)).ToString() == "")
                {
                    siMain.SetValue(e.Row, siMain.GetColumnIndex(DefColumns.CURRENCY), siMain.GetValue(sTempRow, siMain.GetColumnIndex(DefColumns.CURRENCY)).ToString());
                }
                                                                                         
                                                              
                else if (e.Column == siMain.GetColumnIndex(DefColumns.CURRENCY) && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting.StringI)
                {
                                                                                           

                                                             

                                                          

                    int iCurrencyCol = siMain.GetColumnIndex(DefColumns.CURRENCY);

                                   
                    for (int i = dtMeasureCount.Rows.Count - 1; i > 0; i--)
                    {
                        string sCurrency = siMain.GetValue(e.Row, iCurrencyCol).ToString();

                                                                                                     
                        siMain.SetText2(e.Row - i, e.Column, sCurrency);
                        siMain.SetColor(e.Row - i, iCurrencyCol, e.Row - i, iCurrencyCol, System.Drawing.Color.Red, false);
                    }

                                                     
                    DateTime dateTime = DateTime.Today.AddDays(Convert.ToInt32(DayOfWeek.Monday) - Convert.ToInt32(DateTime.Today.DayOfWeek));
                    string sResultYYYYMMDD = dateTime.ToString("yyyyMMdd");
                    int iStartCol = siMain.GetColumnIndex(DefColumns.MEASURE) + 1;

                    int iResultCol = iStartCol;
                    int iResultMonth = iStartCol;


                    for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                    {
                        if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0 && int.Parse(sResultYYYYMMDD) > int.Parse(siMain.GetColumnTag(iCol).Replace("W_", "")))
                        {
                            iResultCol = iCol;
                        }
                                                                  
                        if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 && int.Parse(sResultYYYYMMDD.Substring(0, 6)) == int.Parse(siMain.GetColumnTag(iCol).Replace("M_", "").Substring(0, 6)))
                        {
                            iResultMonth = iCol;
                        }
                    }

                    if (iResultCol > iStartCol)
                    {
                                                                                                                                    
                    }
                    for (int iCCol = iResultCol+1 ; iCCol <= siMain.GetMaxColumnIndex(); iCCol++)
                    {
                                            
                        int iFirstRow = e.Row;
                        int iCol = siMain.GetColumnIndex(DefColumns.CURRENCY);
                        string sCurrency = siMain.GetValue(iFirstRow, iCol).ToString();
                        string sDIVISION_ID = siMain.GetValue(iFirstRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                                                         
                        if (sCurrency == "")
                        {
                            siMain.SetText2(e.Row, e.Column, "");
                            return;
                        }

                                
                        string val = siMain.GetValue(e.Row, iCCol).ToString();

                                                                 
                        if (val.Equals(""))
                            val = "0";

                        if (!string.IsNullOrEmpty(val))
                        {
                                                                                  
                            siMain.SetColor(e.Row, iCCol, e.Row, iCCol, System.Drawing.Color.Red, false);
                            for (int i = dtMeasureCount.Rows.Count - 1; i > 0; i--)
                            {
                                                           
                                string sColumnValue = siMain.GetColumnTag(iCCol);
                                                                                                                                              
                                string sTargetER = siMain.GetValue(e.Row - i, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString();

                                               
                                if (sTargetER == "RTF_SYS_RP") continue;

                                string sTargetValue = siMain.GetValue(e.Row - i, iCCol).ToString();
                                siMain.SetText2(e.Row - i, iCCol, GetExchangeRate(sDIVISION_ID, sCurrency, sTargetER, sColumnValue.Substring(2, 6), val, sTargetValue));                                              
                                siMain.SetColor(e.Row - i, iCCol, e.Row - i, iCCol, System.Drawing.Color.Red, false);

                                                                                                                                                                           
                                var vAction1 = siMain.GetText(e.Row - i, 0);
                                if (vAction1 == "")
                                    (new CUIControl()).SetActionFlagEx(siMain.SpreadObject, e.Row - i, "M");

                            }
                        }
                        else
                        {
                                                                                    
                                
                            for (int i = dtMeasureCount.Rows.Count - 1; i > 0; i--)
                            {
                                siMain.SetText2(e.Row - i, iCCol, "");
                                var vAction1 = siMain.GetText(e.Row - i, 0);
                                if (vAction1 == "")
                                    (new CUIControl()).SetActionFlagEx(siMain.SpreadObject, e.Row - i, "M");
                            }
                                
                        }

                                           
                        if (siMain.GetColumnTag(iCCol).IndexOf("M_") == 0)
                        {
                                                                 
                                                                 
                            string sYYYYMM = siMain.GetColumnTag(iCCol).ToString().Substring(2, 6);
                            for (int i = iCCol + 1; i <= siMain.GetMaxColumnIndex(); i++)
                            {
                                if (siMain.GetColumnTag(i).ToString().Substring(2, 6) == sYYYYMM)
                                {
                                    SetExchangeValues(i, e.Row, val);
                                }
                            }
                        }
                    }
                }
            }

        }
 
                      
                                                                            
                       
                                            
                                        
                                            
                                          
        private void SetTextCellsToRowSpanRange(object objValue, int iActiveRow, string sColName, int iMeasureCount)
        {
            for (int i = 0; i < iMeasureCount; i++)
            {
                siMain.SetValue(iActiveRow + i, siMain.GetColumnIndex(sColName), objValue);
                                                                                  
                if (sColName != "FCST_TYPE")
                    siMain.SetText2(iActiveRow + i, siMain.GetColumnIndex(sColName), objValue.ToString());
            }
        }
                      
                             
                                                                  
                       
                                              
                                
        private int GetCellIndexBySpanRowCells(int iActiveRow)
        {
            long div;
            int multiful = dtMeasureCount.Rows.Count;
            Math.DivRem(iActiveRow, multiful, out div);
            return Convert.ToInt32(iActiveRow - div);
        }

                      
                                           
                                     
                                      
                       
                                              
                                
        private int[] GetCellNumbersByRow(int iRow)
        {
                        
            int multiful = dtMeasureCount.Rows.Count;                         
                                                    
            int iNo = GetCellIndexBySpanRowCells(iRow);

            int[] iResult = new int[multiful];
            int icount = 0;
            int iStart;
            if (iRow - multiful < 0)
                iStart = 0;
            else
                iStart = iRow - multiful;
            for (int i = iStart; i < (iRow + multiful); i++)
            {
                             
                                                      
                int iNo2 = GetCellIndexBySpanRowCells(i);
                if (iNo == iNo2)
                {
                    iResult[icount] = Convert.ToInt32(i);
                    icount++;
                }
            }

            return iResult;
        }

        private void Dsdm_Changed(object sender, FarPoint.Win.Spread.Model.SheetDataModelEventArgs e)
        {
                                   
                                        
                          
                                              
                          
            if (siMain.IsLock(siMain.SheetName) == true)
                return;


                                                                            
            string sDivision = string.Empty;
            string sProjectCode = string.Empty;
            string sSiteId = string.Empty;
            string sItemId = string.Empty;

                                                                          
                                            
            if (e.Column < 0 || e.Row < 0)
                return;
            if (siMain.IsLockCell(e.Row, e.Column))
                return;

            switch (e.Type)
            {
                case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated:
                    if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Column)
                    {
                                            
                        int iFirstRow = GetCellIndexBySpanRowCells(e.Row);
                        int iCol = siMain.GetColumnIndex(DefColumns.CURRENCY);
                        string sCurrency = siMain.GetValue(iFirstRow, iCol).ToString();
                        string sDIVISION_ID = siMain.GetValue(iFirstRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                                                         
                        if (sCurrency == "")
                        {
                            siMain.SetText2(e.Row, e.Column, "");
                            return;
                        }

                                
                        string val = siMain.GetValue(e.Row, e.Column).ToString();

                                                                 
                        if (val.Equals(""))
                            val = "0";

                        if (!string.IsNullOrEmpty(val))
                        {
                                                                                  
                            siMain.SetColor(e.Row, e.Column, e.Row, e.Column, System.Drawing.Color.Red, false);
                            for (int i = dtMeasureCount.Rows.Count - 1; i > 0; i--)
                            {
                                                           
                                string sColumnValue = siMain.GetColumnTag(e.Column);
                                                                                                                                              
                                string sTargetER = siMain.GetValue(e.Row - i, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString();

                                               
                                if (sTargetER == "RTF_SYS_RP") continue;

                                string sTargetValue = siMain.GetValue(e.Row - i, e.Column).ToString();
                                siMain.SetText2(e.Row - i, e.Column, GetExchangeRate(sDIVISION_ID, sCurrency, sTargetER, sColumnValue.Substring(2, 6), val, sTargetValue));                                              
                                siMain.SetColor(e.Row - i, e.Column, e.Row - i, e.Column, System.Drawing.Color.Red, false);

                                                                                                                                                                           
                                var vAction1 = siMain.GetText(e.Row - i, 0);
                                if (vAction1 == "")
                                    (new CUIControl()).SetActionFlagEx(siMain.SpreadObject, e.Row - i, "M");

                            }
                        }
                        else
                        {
                                                                                    
                                
                            for (int i = dtMeasureCount.Rows.Count - 1; i > 0; i--)
                            {
                                siMain.SetText2(e.Row - i, e.Column, "");
                                var vAction1 = siMain.GetText(e.Row - i, 0);
                                if (vAction1 == "")
                                    (new CUIControl()).SetActionFlagEx(siMain.SpreadObject, e.Row - i, "M");
                            }
                                
                        }

                                           
                        if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0)
                        {
                                                                 
                                                                 
                            string sYYYYMM = siMain.GetColumnTag(e.Column).ToString().Substring(2, 6);
                            for (int i = e.Column + 1; i <= siMain.GetMaxColumnIndex(); i++)
                            {
                                if (siMain.GetColumnTag(i).ToString().Substring(2, 6) == sYYYYMM)
                                {
                                    SetExchangeValues(i, e.Row, val);
                                }
                            }
                        }
                    }

                                                                                                                    
                    sDivision = clbDivisions.ControlValues;

                                                                                    
                    if (sDivision.Substring(0, 2) == "81" && e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE))
                    {
                        sProjectCode = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString();
                        sItemId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString();

                        dtPlantSite = Data.Common(Data.Type.SalesPlant, false, "", sDivision, sProjectCode, sItemId);
                        siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), dtPlantSite);

                    }
                    else if (sDivision.Substring(0, 2) == "81" && e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))
                    {
                        sProjectCode = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString();
                        sItemId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString();

                        dtPlantSite = Data.Common(Data.Type.SalesPlant, false, "", sDivision, sProjectCode, sItemId);
                        siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), dtPlantSite);

                    }
                    break;

                default:
                    break;
            }
        }

        private void SetExchangeValues(int iColumn, int iRow, string sVal)
        {
                                
            int iFirstRow = GetCellIndexBySpanRowCells(iRow);
            int iCol = siMain.GetColumnIndex(DefColumns.CURRENCY);
            string sCurrency = siMain.GetValue(iFirstRow, iCol).ToString();
            string sDIVISION_ID = siMain.GetValue(iFirstRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();

            if ((siMain.GetBGColor(iRow, iColumn) == Color.Empty) || (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor))
            {
                                                 
                if (sCurrency == "")
                {
                    siMain.SetText2(iRow, iColumn, "");
                    return;
                }

                        
                string val = sVal;                                              
                siMain.SetText2(iRow, iColumn, val);
                if (!string.IsNullOrEmpty(val))
                {
                                                                          
                    siMain.SetColor(iRow, iColumn, iRow, iColumn, System.Drawing.Color.Red, false);
                    for (int i = dtMeasureCount.Rows.Count - 1; i > 0; i--)
                    {
                                                   
                        string sColumnValue = siMain.GetColumnTag(iColumn);
                                                                                                                                      
                        string sTargetER = siMain.GetValue(iRow - i, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString();
                        string sTargetValue = siMain.GetValue(iRow - i, iColumn).ToString();
                        siMain.SetText2(iRow - i, iColumn, GetExchangeRate(sDIVISION_ID, sCurrency, sTargetER, sColumnValue.Substring(2, 6), val, sTargetValue));                                              
                        siMain.SetColor(iRow - i, iColumn, iRow - i, iColumn, System.Drawing.Color.Red, false);

                                                                                                                                                                   
                        var vAction1 = siMain.GetText(iRow - i, 0);
                        if (vAction1 == "")
                            (new CUIControl()).SetActionFlagEx(siMain.SpreadObject, iRow - i, "M");
                    }
                }
                else
                {
                    for (int i = dtMeasureCount.Rows.Count - 1; i > 0; i--)
                    {
                        siMain.SetText2(iRow - i, iColumn, "");
                        var vAction1 = siMain.GetText(iRow - i, 0);
                        if (vAction1 == "")
                            (new CUIControl()).SetActionFlagEx(siMain.SpreadObject, iRow - i, "M");
                    }
                }
            }
        }

                      
                  
                       
                                                
                                           
                                             
                                           
                                          
                                              
                                
        private string GetExchangeRate(string sDIVISION_ID, string sBaseER, string sTargetER, string sYYYYMM, string sValue, string sTargetVal)
        {
                               
            if (sBaseER == sTargetER)
                return sValue;

                                                                                                          
            DataRow[] row = dtFuturePrice.Select(" CURRENCY = '" + sTargetER + "' AND UNIT_CURRENCY = '" + sBaseER + "' AND YYYYMM = '" + sYYYYMM + "' AND  DIVISION_ID = '" + sDIVISION_ID.Trim() + "' ");
            if (row.Length > 0)
            {
                decimal dblResult = Convert.ToDecimal(row[0]["EXCHANGE_PRICE"]) * Convert.ToDecimal(sValue);
                return dblResult.ToString();
            }

                                                                                                                               
            DataRow[] row1 = dtFuturePrice.Select(" CURRENCY = '" + sBaseER + "' AND UNIT_CURRENCY = '" + sTargetER + "' AND YYYYMM = '" + sYYYYMM + "' AND  DIVISION_ID = '" + sDIVISION_ID.Trim() + "' ");
            if (row1.Length > 0)
            {
                double dblResultKRW = Math.Round(1.0 / Convert.ToDouble(row1[0]["EXCHANGE_PRICE"]), 5);
                double dblResult = dblResultKRW * Convert.ToDouble(sValue);
                return dblResult.ToString();
            }

                                                                                                                                        
            DataRow[] row4 = dtFuturePrice.Select(" CURRENCY = 'KRW' AND UNIT_CURRENCY = '" + sBaseER + "' AND YYYYMM = '" + sYYYYMM + "' AND  DIVISION_ID = '" + sDIVISION_ID.Trim() + "' ");
            if (row4.Length > 0)
            {
                decimal dblKRW = Convert.ToDecimal(row4[0]["EXCHANGE_PRICE"]);
                DataRow[] row5 = dtFuturePrice.Select(" CURRENCY = 'KRW' AND UNIT_CURRENCY = 'USD' AND YYYYMM = '" + sYYYYMM + "' AND  DIVISION_ID = '" + sDIVISION_ID.Trim() + "' ");
                if (row5.Length > 0)
                {
                    decimal dblUSD = Convert.ToDecimal(row5[0]["EXCHANGE_PRICE"]);
                    decimal dblResult = (Convert.ToDecimal(sValue) * dblKRW) / dblUSD;
                    return dblResult.ToString();
                }
            }

            if (sTargetVal == null)
                return "";            
            else
                return "0";
        }

        private void spdMain_CellDoubleClick(object sender, FarPoint.Win.Spread.CellClickEventArgs e)
        {
            if (e.ColumnHeader == false)
            {
                if (siMain.Sheet().Rows.Count <= 0)
                    return;

                if (siMain.IsLock(siMain.SheetName))
                {

                }
                else
                {
                    if (siMain.IsLock(siMain.SheetName) || siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting.StringI)
                    {
                        return;
                    }

                    string sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                    string sScmSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString();
                    string sItemId = "";                                                                               
                    string sTeam = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID)).ToString();

                    string sEndCustomer = "";
                    string sProject = "";
                                                                                             
                    if (sDivision == "40")
                    {
                        sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)).ToString();
                    }
                    else
                    {
                        sProject = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString();
                        sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER)).ToString();
                    }

                    string sScmSite = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString();

                    if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_NAME)) || siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE)))
                    {
                        string sProjectName = string.Empty;
                        string sProjectStatus = string.Empty;
                        string sBizType = string.Empty;
                        string sCurrency = string.Empty;
                        string sProjectVerSeq = string.Empty;
                        string sProjectOwner = string.Empty;


                        SCM0002_ProjectbyDivisionPopupEx popProject = new SCM0002_ProjectbyDivisionPopupEx();
                        popProject.Form_Load(false, sDivision, sTeam, sEndCustomer, sScmSite, sProject);
                        popProject.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                        popProject.ShowDialog();

                        sProject = popProject.ProjectCode;
                        sProjectName = popProject.ProjectName;
                        sProjectStatus = popProject.ProjectStatus;
                        sBizType = popProject.BizType;
                        sCurrency = popProject.Currency;
                        sProjectVerSeq = popProject.ProjectVerSeq;
                        sProjectOwner = popProject.ProjectOwner;

                        if (popProject.ProjectCode != "" || popProject.ProjectCode != null)
                        {
                            if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) != -1)
                                siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), popProject.ProjectCode);
                            if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME) != -1)
                                siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), popProject.ProjectName);
                            if (siMain.GetColumnIndex(DefColumns.ProjectStatus) != -1)
                                siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.ProjectStatus), popProject.ProjectStatus);
                            if (siMain.GetColumnIndex(DefColumns.BizTypeName) != -1)
                                siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.BizTypeName), popProject.BizTypeName);


                                             
                            if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                                siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "");
                            if (siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME) != -1)
                                siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "");
                        }
                    }
                    else if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME)) || siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.ITEM_ID)))
                    {
                        DM0002_ItembyDivisionPopupEx popItem = new DM0002_ItembyDivisionPopupEx();
                        popItem.Form_Load(false, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId);
                        popItem.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                        popItem.ShowDialog();

                        if (popItem.ItemID != "" || popItem.ItemID != null)
                        {
                            if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                                siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), popItem.ItemID);
                            if (siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME) != -1)
                                siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), popItem.ItemClassName);
                            if (siMain.GetColumnIndex(DefColumns.ITEM_NAME) != -1)
                                siMain.SetText2(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_NAME), popItem.ItemName);

                            var vCurrent = popItem.currency;
                            SetTextCellsToRowSpanRange(vCurrent, e.Row, DefColumns.CURRENCY, dtMeasureCount.Rows.Count);
                        }
                    }

                }
            }
            else
            {
                               
                if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0)
                {
                    for (int iCol = e.Column; iCol < siMain.GetMaxColumnIndex(); iCol++)
                    {
                        if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0)
                            siMain.ActiveSheet.Columns[iCol].Visible = !siMain.ActiveSheet.Columns[iCol].Visible;
                        else if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0)
                        {
                            if (siMain.ActiveSheet.Columns[iCol].Visible)
                                siMain.ActiveSheet.Columns[iCol].Visible = !siMain.ActiveSheet.Columns[iCol].Visible;
                        }

                        if (siMain.GetColumnTag(iCol + 1).IndexOf("M_") == 0)
                            break;
                    }
                }
                else if (siMain.GetColumnTag(e.Column).IndexOf("W_") == 0)
                {
                    for (int iCol = e.Column; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                    {
                        if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0)
                            siMain.ActiveSheet.Columns[iCol].Visible = !siMain.ActiveSheet.Columns[iCol].Visible;

                        if (siMain.GetColumnTag(iCol + 1).IndexOf("W_") == 0)
                            break;
                    }
                }
            }
        }

        private void spdMain_TopChange(object sender, TopChangeEventArgs e)
        {
            CanModelChange = false;
            siMain.SmartColMerge();
            CanModelChange = true;
        }

        private DataTable GetDivision()
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sScmBinding))
            {
                var request = new FoxDataRequest("SCM.SCM0001_GET_DIVISION");
                                                                                                   
                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }

            return dt;
        }

        private DataTable GetScmSitebyDivision(string sDivision, string sTeam, string sEdnCustomer)
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sScmBinding))
            {
                var request = new FoxDataRequest("SCM.SCM0001_GET_SITE_BY_DIVISION");
                request.Parameters["p_division_id"] = sDivision;
                request.Parameters["p_dept_id"] = sTeam;
                request.Parameters["p_end_customer"] = sEdnCustomer;
                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }

            return dt;
        }

        private DataTable GetScmSiteInfobyDivision(string sDivision, string sScmSite)
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sScmBinding))
            {
                var request = new FoxDataRequest("SCM.SCM0001_GET_SITE_INFO_BY_DIVISION");
                request.Parameters["p_division_id"] = sDivision;
                request.Parameters["p_scm_site_id"] = sScmSite;
                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }

            return dt;
        }

        private DataTable GetTeambyDivision(string sDivision)
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sScmBinding))
            {
                var request = new FoxDataRequest("SCM.SCM0001_GET_TEAM_BY_DIVISION");
                request.Parameters["p_division_id"] = sDivision;
                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }

            return dt;
        }

        private DataTable GetEndCustomerbyDivision(string sDivision, string sDeptId)
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sScmBinding))
            {
                var request = new FoxDataRequest("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION");
                request.Parameters["p_division_id"] = sDivision;
                request.Parameters["p_dept_id"] = sDeptId;
                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }

            return dt;
        }

        private DataTable GetLookupValues(string sLookupType)
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sScmBinding))
            {
                var request = new FoxDataRequest("SCM.SCM0001_GET_LOOKUP_VALUES");
                request.Parameters["p_lookup_type"] = sLookupType;
                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }

            return dt;
        }

        private DataTable GetPlantSitebyEndCustomer(string sDivision, string sTeam, string sEdnCustomer)
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sScmBinding))
            {
                var request = new FoxDataRequest("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER");
                request.Parameters["p_division_id"] = sDivision;
                request.Parameters["p_dept_id"] = sTeam;
                request.Parameters["p_end_customer"] = sEdnCustomer;
                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }

            return dt;
        }

        private async void btnBatch_Click(object sender, EventArgs e)
        {
            string p_division_id = clbDivisions.ControlValues;
            if (p_division_id.ToUpper() == "ALL")
                p_division_id = CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues);

            p_division_id = p_division_id.Replace(",", "^");

            string p_CREATED_BY = UserInfoContext.Current.UserId; ;
            var asyncProxy = new FoxAsyncProxy(this);

            var ds = await asyncProxy.ExecuteAsync<DataSet>(() =>
            {
                using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
                {
                                                                                             
                    var request = new FoxDataRequest("DM.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW");

                    request.CommandTimeout = 3 * 60;

                    request.Parameters["p_division_id"] = p_division_id;
                    request.Parameters["p_CREATED_BY"] = p_CREATED_BY;
                    var response = client.ExecuteDataSet(request);

                    return response.DataSet;
                }
            });

            string sRMsg = "";
            for (int i = 0; i < ds.Tables.Count; i++)
            {
                sRMsg += ";" + ds.Tables[i].Rows[0][0].ToString();
            }

            p_division_id = p_division_id.Replace("^", ",");
            MessageHelper.GMessageBox("MSG00143", new object[] { p_division_id, sRMsg });
        }

        private string GetThisWeekMonday(DateTime dtStartDate)
        {
                                                                   
            DateTime dtStart = dtStartDate;
            string sYYYYMMDD = "";
            while (true)
            {
                                                                        
                             
                if (dtStart.DayOfWeek == DayOfWeek.Monday)
                {
                    sYYYYMMDD = dtStart.ToString("yyyyMMdd");
                    break;
                }
                dtStart = dtStart.AddDays(-1);
            }

            return sYYYYMMDD;
        }

        private void backgroundWorker1_DoWork(object sender, System.ComponentModel.DoWorkEventArgs e)
        {
            Console.WriteLine("D" + System.DateTime.Now);
        }

        private void backgroundWorker1_ProgressChanged(object sender, System.ComponentModel.ProgressChangedEventArgs e)
        {
        }

        private void backgroundWorker1_RunWorkerCompleted(object sender, System.ComponentModel.RunWorkerCompletedEventArgs e)
        {
            Console.WriteLine("E" + System.DateTime.Now);
        }

        private void DMF0020_SalesFuturePrice_Resize(object sender, EventArgs e)
        {
            if (panel1.Visible == true)
            {
                panel1.Left = (this.ClientSize.Width - panel1.Width) / 2;
                panel1.Top = (this.ClientSize.Height - panel1.Height) / 2;
            }
        }

        private void clbEndCustomer_SelectedIndexChanged(object sender, EventArgs e)
        {
                                                                        
                                                                                                                                                                                         
            SetChangeControl("UserSiteByEndCustomer", clbDivisions.ControlValues, string.Empty, clbEndCustomer.ControlValues);
            clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);
        }
        private DataSet GetSpdTitle()
        {
            string[] sMonth = drpDateTime.ControlValues.Split(':');
            string sStartDate = drpDateTime.Value1.ToString("yyyyMMdd");           
            string sEndDate = drpDateTime.Value2.ToString("yyyyMMdd");           

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                var request = new FoxDataRequest("DM.DMF0020_GET_SPREAD_TITLE");
                request.Parameters["p_start_dt"] = sStartDate;             
                request.Parameters["p_end_dt"] = sEndDate;             
                request.Parameters["p_created_by"] = base.UserInfo.UserId;
                request.Parameters["p_division_id"] = clbDivisions.SelectedValue;               

                dsSpdTitle = client.ExecuteDataSet(request).DataSet;
            }

            return dsSpdTitle;
        }

        private DataTable GetTeambyDivisionAsync(string sDivision)
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sScmBinding))
            {
                var request = new FoxDataRequest("SCM.SCM0001_GET_TEAM_BY_DIVISION");
                request.Parameters["p_division_id"] = sDivision;
                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }
            return dt;
        }

        private DataTable GetCustomerbyDivision(string sDivision, string sTeam)
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sScmBinding))
            {
                var request = new FoxDataRequest("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION");
                request.Parameters["p_division_id"] = sDivision;
                request.Parameters["p_dept_id"] = sTeam;
                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }

            return dt;
        }

        private DataTable GetCustomerbyDivisionAsync(string sDivision, string sTeam)
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sScmBinding))
            {
                var request = new FoxDataRequest("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION");
                request.Parameters["p_division_id"] = sDivision;
                request.Parameters["p_dept_id"] = sTeam;
                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }

            return dt;
        }

        private DataTable GetPlantSitebyEndCustomerAsync(string sDivision, string sTeam, string sEdnCustomer)
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sScmBinding))
            {
                var request = new FoxDataRequest("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER");
                request.Parameters["p_division_id"] = sDivision;
                request.Parameters["p_dept_id"] = sTeam;
                request.Parameters["p_end_customer"] = sEdnCustomer;
                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }

            return dt;
        }

        private DataTable GetBizTypebyDivision(string sDivision)
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sScmBinding))
            {
                var request = new FoxDataRequest("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION");
                request.Parameters["p_division_id"] = sDivision;
                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }

            return dt;
        }

        private DataTable GetScmSitebyDivisionAsync(string sDivision, string sTeam, string sEdnCustomer)
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sScmBinding))
            {
                var request = new FoxDataRequest("SCM.SCM0001_GET_SITE_BY_DIVISION");
                request.Parameters["p_division_id"] = sDivision;
                request.Parameters["p_dept_id"] = sTeam;
                request.Parameters["p_end_customer"] = sEdnCustomer;
                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }

            return dt;
        }

        private void clbTeam_SelectedIndexChanged(object sender, EventArgs e)
        {
            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues);
            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);

                          
            if ((clbDivisions.SelectedValue.ToString().Substring(0, 2) == "81") || (clbDivisions.SelectedValue.ToString() == "82"))
            {
                                                                            
                                                                                                                                                               
                SetChangeControl("EndCustomerByDivision", sDivision, sTeam);
            }
            else
            {
                                                                            
                                                                                                                                                                                                  
                SetChangeControl("EndCustomerByDivision", sDivision, clbTeam.ControlValues);
            }
            clsCtrl.setListBox(dtEndCustomer, clbEndCustomer, true);
            string sEndCustomer = CString.GetCheckedListValue(dtCustomer, clbEndCustomer.ControlValues);

                                                                        
                                                                                                                                                        
            SetChangeControl("UserSiteByEndCustomer", sDivision, string.Empty, sEndCustomer);
            clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);
        }


                                                                                               
        private void spdMain_CellClick(object sender, CellClickEventArgs e)
        {
            if (e.Column == siMain.GetColumnIndex(DefColumns.CURRENCY) && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting.StringI)
            {
                                                                                       

                MessageHelper.GMessageBox("MSG00447");
            }

            if (sender == null || e == null)
                return;
            Raw_CellClick(siMain, e.Column, e.Row);
        }

        private void Raw_CellClick(SpreadInfo spread, int _Column, int _Row)
        {
            string sDivision = clbDivisions.ControlValues;
            string sProject = "";
            string sItem = "";

            if (!spread.IsLock(spread.ActiveSheet.SheetName))
            {
                spread.SpreadObject.SuspendLayout();
                if (_Column == spread.GetColumnIndex(DefColumns.PLANT_SITE_ID) || sDivision.Substring(0, 2) == "81")
                {
                    sDivision = spread.GetValue(_Row, spread.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                    sProject = spread.GetValue(_Row, spread.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString();
                    sItem = spread.GetValue(_Row, spread.GetColumnIndex(DefColumns.ITEM_ID)).ToString();

                    dtPlantSite = Data.Common(Data.Type.PlantSiteByItem, false, "", sDivision, sProject, sItem);
                    spread.SetCellTypeCombo(_Row, spread.GetColumnIndex(DefColumns.PLANT_SITE_ID), dtPlantSite);

                }
                                                                             
                dtincotermsEditType = GetLookupValues("INCOTERMS", "ALL", "Y", "", "", "");
                spread.SetCellTypeCombo(_Row, spread.GetColumnIndex(DefColumns.INCOTERMS), dtincotermsEditType);
                                                                           

                sTempRow = _Row;
                                                                                     

                                                       

                if (sDivision == "82" && (_Column == spread.GetColumnIndex(DefColumns.INCOTERMS)))
                {
                    SetRowSpanFucTwo(spread, GetCellIndexBySpanRowCells(_Row), GetCellIndexBySpanRowCells(_Row) + 3, spread.GetColumnIndex(DefColumns.INCOTERMS), spread.GetColumnIndex(DefColumns.INCOTERMS));
                }
                else if (sDivision == "82" && (_Column == spread.GetColumnIndex(DefColumns.FcstType)))
                {
                    SetRowSpanFucTwo(spread, GetCellIndexBySpanRowCells(_Row), GetCellIndexBySpanRowCells(_Row) + 3, spread.GetColumnIndex(DefColumns.FcstType), spread.GetColumnIndex(DefColumns.FcstType));
                }
                else if (sDivision == "82" && (_Column == spread.GetColumnIndex(DefColumns.DomExp)))
                {
                    SetRowSpanFucTwo(spread, GetCellIndexBySpanRowCells(_Row), GetCellIndexBySpanRowCells(_Row) + 3, spread.GetColumnIndex(DefColumns.DomExp), spread.GetColumnIndex(DefColumns.DomExp));
                }
                                                                            

                                                                                         
                   
                                                                                                       
                  
                                                                                                                                                                                                              
                  
                  
                spread.SpreadObject.ResumeLayout();

            }
        }

        private void spdMain_KeyUp(object sender, KeyEventArgs e)
        {
            if (siMain.GetColumnIndex(DefColumns.MEASURE) >= siMain.ActiveColumnIndex) return;

            if (e.Control == true && e.KeyCode == Keys.V || e.Control == false && e.KeyCode == Keys.V)
            {
                spdMain.ActiveSheet.ClipboardPaste(ClipboardPasteOptions.AsStringSkipHidden);
                                                               
            }

            if (e.Control == true && e.KeyCode == Keys.C || e.Control == false && e.KeyCode == Keys.C)
            {
                Clipboard.Clear();
                spdMain.Sheets[0].ClipboardCopy(ClipboardCopyOptions.AsStringSkipHidden);
                                                               
            }
        }

        private void btnOwner_Click(object sender, EventArgs e)
        {
                          
            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues);                              
            string sTeam = clbTeam.ControlValues;
            string sEndCustomer = clbEndCustomer.ControlValues;
            string sProject = umltProject.Text;                                                                  
            string sScmSiteId = clbSalesSite.ControlValues;
            string sItemId = umltModel.Text;
            string sOwner = txtOwner.Text;

            DM0020_OwnerbyDivisionPopup popItem = new DM0020_OwnerbyDivisionPopup();

                                   
            popItem.Form_Load(true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner);
            popItem.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            popItem.ShowDialog();

            txtOwner.Text = popItem.OwnerID;
        }

        private void btnColumn_Click(object sender, EventArgs e)
        {
            DM0002_TitleSetForm_Popup frm = new DM0002_TitleSetForm_Popup("DMF0020", SpdSheet.shtMain, true, clbDivisions.ControlValues);
            frm.StartPosition = FormStartPosition.CenterParent;
            frm.ShowDialog();

            if (frm.DialogResult == DialogResult.OK)
            {
                InitSpread(true);
            }
        }

        private DataTable GetBucketType()
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                var request = new FoxDataRequest("DM.DMF0003_GET_BUCKET_TYPE_CODE");
                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }

            return dt;
        }

        private void cboBucketType_Click(object sender, EventArgs e)
        {
            for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
            {
                if (siMain.GetText(iRow, 0) == CAppSetting.FlagI)
                {
                    MessageHelper.GMessageBox("MSG00227");
                    return;
                }
            }
        }

        private void usrDiscard_CheckedChanged(object sender, EventArgs e)
        {
                                                                                  
            drpDateTime.Value1 = DateTime.Today.AddDays(Convert.ToInt32(DayOfWeek.Monday) - Convert.ToInt32(DateTime.Today.DayOfWeek) - 7);
            drpDateTime.Value2 = drpDateTime.Value1.AddDays(357);
        }


                                                                             
        public static void SetRowSpanFucTwo(SpreadInfo siSpread, int iStartRow, int iEndRow, int iStartCol, int iEndCol)
        {
            for (int i = iStartCol; i <= iEndCol; i++)
            {
                string sFYear = "";
                int iFRow = iStartRow;                              
                int iLRow = 1;

                for (int j = iStartRow; j <= iEndRow; j++)
                {
                           
                                  
                    sFYear = siSpread.GetText(j, i);

                                       
                    if (sFYear != siSpread.GetText(j, i))
                    {
                                                                                                       
                                                                                                                                  
                        siSpread.SpreadObject.Sheets[0].AddSpanCell(iFRow, i, iLRow - 1, 1);
                        sFYear = siSpread.GetText(j, i);
                        iFRow = (iFRow) + (iLRow - 1);
                        iLRow = 1;
                    }
                    if (j == iEndRow)
                    {
                                                                                                    
                        siSpread.SpreadObject.Sheets[0].AddSpanCell(iFRow, i, iLRow, 1);
                    }
                    iLRow++;
                }

                FarPoint.Win.Spread.Cell cellrange;
                cellrange = siSpread.SpreadObject.ActiveSheet.Cells[iStartRow, i, iEndRow, i];
                cellrange.HorizontalAlignment = FarPoint.Win.Spread.CellHorizontalAlignment.Center;
                cellrange.VerticalAlignment = FarPoint.Win.Spread.CellVerticalAlignment.Center;
            }
        }

        private DataTable GetCustomsHandbook()
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                var request = new FoxDataRequest("DM.UP_FX_GetCommonDataList_DM");
                request.Parameters["CODE"] = "DM_CUSTOMS_HANDBOOK";
                request.Parameters["PARAM1"] = "";
                request.Parameters["PARAM2"] = "";
                request.Parameters["PARAM3"] = "";
                request.Parameters["PARAM4"] = "";
                request.Parameters["PARAM5"] = "";
                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }
            return dt;
        }

        private void btnSPVer_Click(object sender, EventArgs e)
        {
                          
            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues);

            DateTime dtTime = Data.MultiTimeZone(UserInfoContext.Current["TimeZone"]);
            string sStartDate = dtTime.AddMonths(-3).ToString("yyyyMMdd");
            string sEndDate = dtTime.AddMonths(3).ToString("yyyyMMdd");
            DMF0073_VersionBySalesPricePopup popVersion = new DMF0073_VersionBySalesPricePopup();
            popVersion.Form_Load(true, "SP", sDivision, sStartDate, sEndDate);
            popVersion.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            popVersion.ShowDialog();

            if (popVersion.sVersions != "")
            {
                string[] sVersion = popVersion.sVersions.Split(',');
                if (sVersion.Length > 2)
                {
                    MessageHelper.GMessageBox("MSG00255", null);        
                    return;
                }
                else
                {
                    txtVersion.Text = popVersion.sVersions;
                                                                
                }
            }
        }

        private void btnTemplate_Click(object sender, EventArgs e)
        {
                       
                                                                              

                                            
            GSCM.DM.Master.UIL.POPUP.DMF0020_SalesPriceTemplatePopup frm = new GSCM.DM.Master.UIL.POPUP.DMF0020_SalesPriceTemplatePopup(CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues));
            frm.StartPosition = FormStartPosition.CenterParent;
            frm.ShowDialog();
        }

        private void btnExcelUpload_Click(object sender, EventArgs e)
        {
                          
            ExcelUploadForm frm = new ExcelUploadForm("DMF0020", this.spdMain.ActiveSheet.SheetName);
            frm.SaveExceptError = true;
            frm.StartPosition = FormStartPosition.CenterParent;
            frm.ShowDialog();

            if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes)
            {
                FindData(true);
            }
        }

                                                      
                                                             
        private DataTable GetLookupValues(string p_code, string p_param1, string p_param2, string p_param3, string p_param4, string p_param5)
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                var request = new FoxDataRequest("DM.UP_FX_GetCommonDataList_DM");
                request.Parameters["CODE"] = p_code;
                request.Parameters["PARAM1"] = p_param1;
                request.Parameters["PARAM2"] = p_param2;
                request.Parameters["PARAM3"] = p_param3;
                request.Parameters["PARAM4"] = p_param4;
                request.Parameters["PARAM5"] = p_param5;
                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }
            return dt;
        }
    }
}
