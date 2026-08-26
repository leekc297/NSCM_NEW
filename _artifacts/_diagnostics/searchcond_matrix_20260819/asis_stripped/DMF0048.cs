using GSCM.App.Core.Security;
using GSCM.App.Core.Text;
using GSCM.SCM.Popup.UIL;
using GSCM.Windows.Forms.Class;
using GSCM.Windows.Forms.UI;
using GSCM.Windows.Forms.Utility;
using System;
using System.Data;
using TheOne.ServiceModel.Data;
using TheOne.Windows.Forms;
using FarPoint.Win.Spread;
using System.Windows.Forms;
using System.Collections.Specialized;

using FarPoint.Win.Spread.CellType;
using System.Drawing;
using GSCM.DM.Plan.UIL.POPUP;
using System.Globalization;

using GSCM.Windows.Forms.Service;
using GSCM.FP.Common.UIL.Service;

                                                                                                                            
                   
                   
                    
                                                                                                                            
                                           
                                                                                                                            
                                                                           
                                                             
                                                                       
                                                                                      
                                                 
                                                             
                                                      
                                 
                                                                                             
                                                                                                                           


namespace GSCM.DM.Plan.UIL
{
    public partial class DMF0048_SalesMonitoring : BaseForm
    {
        #region 1. Setting

                           
        private DataTable dtSave = null;


                  
        SpreadInfo siMain = null;

        CControl clsCtrl = null;
        private DataTable dtDivision = null;
                                               
        private DataTable dtTeam = null;
        private DataTable dtCustomer = null;
        private DataTable dtBizType = null;
                                               
        private DataTable dtSalesSite = null;
        private DataTable dtBucketType = null;
        private DataTable dtItemType = null;
        private DataSet dsSpdTitle = null;
        private DataTable dtEndCustomer = null;
        private DataTable dtMearsure = null;
        private DataTable dtMearsure2 = null;
        private DataTable dtPlantSite = null;
        private DataTable dtITEM_ID = null;
                                               

        private readonly object objLock = new object();
        private DataTable dtCurrencyList = null;
        private string fBucket = "";
        private string sBucket = "";
        private int weekNumber = 0;
        private DateTime weekDate;
        private string this_YYYYMMWW = "";
        private string pre_YYYYMMWW = "";
        private string sResult_YYYYMMWW = "";
        private string sResult_YYYYMMDD = "";
        private string sPre_YYYYMMDD = "";

        TextCellType cellTypeImage = null;

        private bool blnWork = false;

        private DateTime dtStartPeriod;
        private DateTime dtEndPeriod;

                      
                       
                       
        private struct SpdSheet
        {
            public static string shtMain = "Sales Monitoring";
        }

                      
                  
                       
        private struct DefColumns
        {
            public static string Column1 = "Column1";
            public static string Column2 = "Column2";
            public static string Column3 = "Column3";

            public static string DIVISION_ID = "DIVISION_ID";
            public static string DEPT_ID = "DEPT_ID";
            public static string DEPT_NAME = "DEPT_NAME_KO";
            public static string TEAM_ID = "TEAM_ID";
            public static string TEAM_NAME = "TEAM_NAME_KO";
            public static string END_CUSTOMER = "END_CUSTOMER";
            public static string BizType = "BIZ_TYPE";
            public static string BizTypeName = "BIZ_TYPE_NAME";
            public static string SCM_SITE_ID = "SCM_SITE_ID";
            public static string PLANT_SITE_ID = "PLANT_SITE_ID";
            public static string PLANT_SITE_ID2 = "PLANT_SITE_ID2";

            public static string PROJECT_CODE = "PROJECT_CODE";
            public static string PROJECT_NAME = "PROJECT_NAME";
            public static string ITEM_ID = "ITEM_ID";
            public static string ITEM_CLASS_NAME = "ITEM_CLASS_NAME";
            public static string ITEM_NAME = "ITEM_NAME";


                                                                 
            public static string SALES_COMPANY = "SALES_COMPANY";
            public static string SALES_PLANT = "SALES_PLANT";

            public static string NickName = "NICK_NAME";
            public static string INCOTERMS = "INCOTERMS";
            public static string ItemType = "ITEM_TYPE";
            public static string FcstType = "FCST_TYPE";
            public static string DomExp = "DOM_EXP";
            public static string ProjectStatus = "PROJECT_STATUS";
            public static string PROJECT_OWNER = "PROJECT_OWNER";
            public static string MeasureGroup = "MEASURE_GROUP";
            public static string MEASURE = "MEASURE";
            public static string YYYYMMDD = "YYYYMMDD";
            public static string Qty = "QTY";

            public static string CURRENCY = "CURRENCY";
            public static string SALES_PLAN_ADJUST_YN = "SALES_PLAN_ADJUST_YN";
            public static string TEAM_INCHARGE = "TEAM_INCHARGE";
                            
            public static string UPPER_DEPT_ID = "UPPER_DEPT_ID";

                                                                                      
            public static string ProjectName = "PROJECT_NAME";
            public static string DistributionChannel = "DISTRIBUTION_CHANNEL";
            public static string CellName = "CELL_NAME";
            public static string ShipmentSite = "SHIPMENT_SITE";

                           
            public static string END_CUSTOMER40 = "END_CUSTOMER40";
            public static string OWNER = "OWNER";

            public static string COUNTRY_NAME = "COUNTRY_NAME";
            public static string CITY_NAME = "CITY_NAME";
            public static string FORECAST_INFO_PRODUCT_GROUP = "FORECAST_INFO_PRODUCT_GROUP";
            public static string VMI_YN = "VMI_YN";

            public static string ColumnName = "COLUMN_NAME";
            public static string ColumnLabel = "COLUMN_LABEL_NAME";
            public static string SmallLabelName = "SMALL_CLASS_LABEL_NAME";
            public static string LargeLabelName = "LARGE_CLASS_LABEL_NAME";
            public static string DayCode = "DAY_CODE";
        }

        private struct DefColumnsLabel
        {
            public static string Division = "Division";
            public static string Department = "Department";
            public static string DepartmentName = "Department";
            public static string Team = "Team";
            public static string TeamName = "Team";
            public static string Customer = "Customer";
            public static string BizType = "Biz.Type Code";
            public static string BizTypeName = "Biz.Type";
            public static string ScmSiteId = "Sales Site";
            public static string Project = "Project";
            public static string ProjectName = "Project Name";
            public static string ItemId = "Model";
            public static string NickName = "Nick Name";
            public static string Incoterms = "Incoterms";
            public static string ItemType = "Item Type";
            public static string FcstType = "Fcst Type";
            public static string DomExp = "DOM/EXP";
            public static string ProjectStatus = "Project Status";

            public static string MeasureGroup = "Measure";
            public static string Measure = "Measure";

            public static string Saturday = "SAT";
            public static string Sunday = "SUN";
            public static string CURRENCY = "CURRENCY";
        }

        private struct BucketType
        {
            public static string Daily = "DAILY";
            public static string Weekly = "WEEKLY";
            public static string Monthly = "MONTHLY";
        }

        private string sBinding = "GSCM.DM.Master.WSL/FoxDataService.svc";
        private string sScmBinding = "GSCM.SCM.Master.WSL/FoxDataService.svc";

                                                       
        private string sProgram_Id = "DMF0048";

        #endregion

        #region 2. Construct

        public DMF0048_SalesMonitoring()
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


                           
                                   
        }

        #endregion
                                                  
        #region FILTER_PART

        private DataTable dtPlantSiteByDivision = null;

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
                case "UserPlantSiteByEndCustomer":

                    Filter["DIVISION_ID"] = sDivision;
                    Filter["END_CUSTOMER"] = sEndCustomer;

                    dtPlantSite = DataService.GetDMInnerTable("UserPlantSiteByEndCustomer", Filter);

                    break;
                case "UserPlantSiteByDivision":

                    Filter["DIVISION_ID"] = sDivision;

                    dtPlantSiteByDivision = DataService.GetDMInnerTable("UserPlantSiteByDivision", Filter);

                    break;
            }
        }

        #endregion               
                                                
        #region 3. Define
        private void InitControls()
        {
                                                                       
                                                                                                                                                                 

            SetChangeControl("MyDivision");

            clsCtrl.setListBox(dtDivision, clbDivision, false, "CODE", "NAME");
            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);

                                                                       
                                                                                                                                                                                                  

            SetChangeControl("UserTeamByDivision", clbDivision.ControlValues);
            clsCtrl.setListBox(dtTeam, clbTeam, true);

            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);
            string sEndCustomer = string.Empty;

                                                                                     
            if (sDivision == "40")
            {
                                                                           
                                                                                         

                SetChangeControl("BizType", sDivision);
                clsCtrl.setListBox(dtBizType, clbBizType, true);

                                                                           
                                                                                                                                                                                  

                SetChangeControl("EndCustomerByDivision", clbDivision.SelectedValue.ToString(), clbTeam.ControlValues);

                lblProject.Enabled = false;
                layoutControlItem3.Enabled = false;
                lblPlantSite.Enabled = false;

                txtProject.Text = "";
                clbPlantSite.ControlValues = "";
            }
            else
            {
                                                                           
                                                               

                SetChangeControl("BizType", sDivision);
                clsCtrl.setListBox(dtBizType, clbBizType, true);

                                                                           
                                                                                                                                                               

                SetChangeControl("EndCustomerByDivision", sDivision, sTeam);

                lblProject.Enabled = true;
                layoutControlItem3.Enabled = true;
                lblPlantSite.Enabled = true;

            }

                                                              
                                              
                   
            lblBizType.Enabled = true;
            chkColor.Checked = false;
            chkSum.Checked = false;

            layoutControlItem10.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;

            clsCtrl.setListBox(dtEndCustomer, clbCustomer, true);
            sEndCustomer = CString.GetCheckedListValue(dtCustomer, clbCustomer.ControlValues);

                                                                       
                                                                                                                                                        

            SetChangeControl("UserSiteByEndCustomer", sDivision, string.Empty, sEndCustomer);
            clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);

                                                                       
                                                                                                                                                             

            SetChangeControl("UserPlantSiteByEndCustomer", sDivision, string.Empty, sEndCustomer);
            clsCtrl.setListBox(dtPlantSite, clbPlantSite, true);

            dtBucketType = GetBucketType();
            clsCtrl.setListBox(dtBucketType, cboBucketType, false, "CODE", "NAME");

            drpPeriod.InitValue = GetDayRange();

            dtItemType = GetItemType();
            clsCtrl.setListBox(dtItemType, clbItemType, true);

                         
                                                                                                           

            dtITEM_ID = Data.Common(Data.Type.SALES_PLAN_ITEM_ID, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);

                           
            dtCurrencyList = Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);

                                  

        }

        private void DefineProperty()
        {
                     
            dtStartPeriod = drpPeriod.Value1;
            dtEndPeriod = drpPeriod.Value2;

            usrConditionPanel2.Height = 105;

                                              
            cboBucketType.ControlValues = BucketType.Monthly;

            siMain.ImagePopUp = imageList1.Images[0];

            cellTypeImage = new TextCellType();
            cellTypeImage.BackgroundImage = new FarPoint.Win.Picture(siMain.ImagePopUp);
            cellTypeImage.BackgroundImage.AlignHorz = FarPoint.Win.HorizontalAlignment.Right;
            cellTypeImage.CharacterCasing = CharacterCasing.Upper;

            this.txtProject.KeyDown += new System.Windows.Forms.KeyEventHandler(this.txtProject_KeyDown);
            this.txtItemId.KeyDown += new System.Windows.Forms.KeyEventHandler(this.txtItemId_KeyDown);
            this.clbDivision.SelectedIndexChanged += new System.EventHandler(this.clbDivision_SelectedIndexChanged);                                 
        }

        private void txtProject_KeyDown(object sender, System.Windows.Forms.KeyEventArgs e)
        {
            if (e.KeyCode == System.Windows.Forms.Keys.Enter)
            {
                btnProject_Click(null, null);
            }
        }

        private void txtItemId_KeyDown(object sender, System.Windows.Forms.KeyEventArgs e)
        {
            if (e.KeyCode == System.Windows.Forms.Keys.Enter)
            {
                btnItemId_Click(null, null);
            }
        }

        private void CreateSpread()
        {
            this.AddSheet(spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 45);
            siMain = GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex);
            siMain.ChangeSheet();

            InitSpread(true);

                        
            FarPoint.Win.Spread.Model.DefaultSheetDataModel dsdm = (FarPoint.Win.Spread.Model.DefaultSheetDataModel)siMain.Sheet(SpdSheet.shtMain).Models.Data;
            dsdm.Changed += Dsdm_Changed;

        }

        private void InitSpread(bool isChangeHeader)
        {
            try
            {
                                                       

                if (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPeriod.Value2.ToString("yyyyMMdd")
                    && !isChangeHeader
                    )
                {
                    siMain.RemoveRowAll();
                }
                else
                {

                             
                    dtStartPeriod = drpPeriod.Value1;
                    dtEndPeriod = drpPeriod.Value2;

                                    
                    DataTable dtTitle = GetSpdTitle();

                    siMain.CreateSheetHeaderColumn(siMain, 3, dtTitle);

                                      
                    SetSpreadHeaderSpan(dtTitle);
                    SetSpreadColumn();
                    InitSpreadFooterSum();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                                                      
            }
        }
        private void InitSpreadFooterSum()
        {
            int iStCol = siMain.GetColumnIndex(DefColumns.MEASURE) + 1;
            siMain.ActiveSheet.ColumnFooter.Visible = true;
            siMain.ActiveSheet.ColumnFooter.Cells[0, 1].Value = "Sum";
            FarPoint.Win.BevelBorder bevelbrdr = new FarPoint.Win.BevelBorder(FarPoint.Win.BevelBorderType.Raised, Color.FromArgb(158, 182, 206), Color.FromArgb(158, 182, 206), 1, false, false, true, false);

            for (int iCol = iStCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
            {
                if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 || siMain.GetColumnTag(iCol).IndexOf("M_") == 0 || siMain.GetColumnTag(iCol).IndexOf("W_") == 0)
                {
                    siMain.ActiveSheet.ColumnFooter.SetAggregationFormat(0, iCol, "{0:#,##0.###}");
                    siMain.ActiveSheet.ColumnFooter.SetAggregationType(0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden);
                    siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor = Color.LightGray;
                    siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].Border = bevelbrdr;
                }
            }
        }

        private DataTable GetSpdTitle()
        {
            string[] sMonth = drpPeriod.ControlValues.Split(':');
            fBucket = cboBucketType.ControlValues;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                                                                                    
                var request = new FoxDataRequest("DM.DMF0048_GET_SPREAD_TITLE");
                request.Parameters["p_start_yyyymmdd"] = sMonth[0];              
                request.Parameters["p_end_yyyymmdd"] = sMonth[1];
                request.Parameters["p_created_by"] = base.UserInfo.UserId;
                request.Parameters["p_division_id"] = clbDivision.SelectedValue;               
                request.Parameters["p_bucket"] = fBucket;

                dsSpdTitle = client.ExecuteDataSet(request).DataSet;
            }

            return dsSpdTitle.Tables[0];
        }

        #endregion

        #region  4. Button

        protected override void FindButton()
        {
            FindData(true);
        }


                                                                                 
        protected override void ExcelButton()
        {
            SimpleExcelExportOption exportOption = new SimpleExcelExportOption();

            string sFileName = Application.StartupPath + "\\" + this.Name.ToString() + "_" + DateTime.Now.ToString("yyyyMMddHHmmss") + ".xlsx";                                                                                                         

            exportOption.Merge = ExcelMergeOption.None;
            exportOption.Border = ExcelBorderOption.All;
            exportOption.AheadZeroOption = ZeroOption.HideZero;
            exportOption.AmendZeroOption = ZeroOption.ShowZero;
            exportOption.AmendNullToZero = false;
            exportOption.AheadNullToZero = false;
                                        
            exportOption.UserName = UserInfo.UserId;
            exportOption.FileName = sFileName;
                                                                                     
            exportOption.AmendDecimalFormat = "#,##0.##0;[Red]-#,##0.##0";
                                                          
                                                                            
                                                           
                                                                               
                                     
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

        private new async void FindData(bool blnInsert, int iUpdateRow = 0, int iUpdateCol = 0)
        {

            GSCM.Windows.Forms.UI.ProgressForm prg = new GSCM.Windows.Forms.UI.ProgressForm();

            try
            {
                             
                if (blnWork)
                {
                    MessageHelper.GMessageBox("MSG00137");
                    return;
                }
                          
                blnWork = true;

                         
                string sStartDate = drpPeriod.Value1.ToString("yyyyMMdd");
                string sEndDate = drpPeriod.Value2.ToString("yyyyMMdd");
                string[] sPeriod = drpPeriod.ControlValues.Split(':');

                if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1]))
                {
                    MessageHelper.GMessageBox("MSG00108");
                    return;
                }

                              
                if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2)
                {
                    MessageHelper.GMessageBox("MSG00164");

                    drpPeriod.Value2 = drpPeriod.Value1.AddYears(3);

                    return;
                }

                                                      
                string sNowDate = DateTime.Now.ToString("yyyyMMdd");

                         
                string p_division_id = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);                               
                string p_scm_site_id = clbSalesSite.ControlValues;
                string p_project_code = txtProject.Text;
                string p_item_id = txtItemId.Text;
                string p_item_type = clbItemType.ControlValues;

                string p_plant_site_id = clbPlantSite.ControlValues;
                string p_biztype = clbBizType.ControlValues;

                string p_dept_id = clbTeam.ControlValues;
                string p_end_customer = clbCustomer.ControlValues;
                string p_owner = txtOwner.Text;

                if (p_division_id == "")
                {
                    MessageHelper.GMessageBox("MSG00097");
                    return;
                }

                CanModelChange = false;
                prg.Show();
                                  
                                    
                InitSpread(true);

                         
                                 
                SearchStartTime();

                var asyncProxy = new FoxAsyncProxy(this);
                asyncProxy.ShowProgress = false;
                var p_bucket = cboBucketType.ControlValues;
                var ds = await asyncProxy.ExecuteAsync<DataSet>(() =>
                {

                    using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
                    {
                        var request = new FoxDataRequest("DM.DMF0048_GET_DM_PLN_SALES_MONITORING");
                        request.CommandTimeout = 30 * 60;

                        request.Parameters["p_division_id"] = p_division_id;
                        request.Parameters["p_dept_id"] = p_dept_id;
                        request.Parameters["p_end_customer"] = p_end_customer;
                        request.Parameters["p_scm_site_id"] = p_scm_site_id;
                        request.Parameters["p_project_code"] = p_project_code;
                        request.Parameters["p_item_id"] = p_item_id;
                        request.Parameters["p_item_type"] = p_item_type;
                        request.Parameters["p_from_yyyymmdd"] = sStartDate;
                        request.Parameters["p_now_yyyymmdd"] = sNowDate;
                        request.Parameters["p_to_yyyymmdd"] = sEndDate;
                        request.Parameters["p_created_by"] = UserInfoContext.Current.UserId;
                        request.Parameters["p_plant_site_id"] = p_plant_site_id;
                        request.Parameters["p_biztype"] = p_biztype;
                        request.Parameters["p_userinfo"] = UserInfoContext.Current["NowGroupID"];
                        request.Parameters["p_owner"] = p_owner;
                        request.Parameters["p_internal_yn"] = (InternalYN.Checked == true) ? "Y" : "N";
                        request.Parameters["p_bucket"] = p_bucket;
                        request.Parameters["p_user_dept_id"] = UserInfoContext.Current["Dept_ID"].ToString();                  

                        var response = client.ExecuteDataSet(request);

                        return response.DataSet;
                    }
                });

                if (ds.Tables[0].Rows.Count <= 0)
                    return;

                                        
                if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "")
                {
                                  
                    ds.Tables[0].Columns.Add("Action", typeof(string));

                               
                                                           
                    ds.Tables[0].AcceptChanges();

                    siMain.Query(ds);
                    siMain.LockColumn(0, siMain.GetMaxColumnIndex(), true);
                }

                                                 
                siMain.SmartColMerge();

                                                                     

                                              
                SearchEndTime();

                try
                {
                    DateTime dateTime = DateTime.Today.AddDays(Convert.ToInt32(DayOfWeek.Monday) - Convert.ToInt32(DateTime.Today.DayOfWeek));
                    string basis_YYYYMM = "";

                    if (ds.Tables[1].Rows.Count > 0)
                    {
                        weekNumber = Convert.ToInt32(ds.Tables[1].Rows[0]["ISO_WEEK"].ToString());
                        weekDate = Convert.ToDateTime(ds.Tables[1].Rows[0]["BASIS_DATE"].ToString());
                        basis_YYYYMM = ds.Tables[1].Rows[0]["BASIS_YYYYMM"].ToString();
                        this_YYYYMMWW = ds.Tables[1].Rows[0]["THIS_YYYYMMWW"].ToString();
                        pre_YYYYMMWW = ds.Tables[1].Rows[0]["PRE_YYYYMMWW"].ToString();
                    }

                    if (dateTime.ToString("yyyyMM") != basis_YYYYMM)
                    {
                        sResult_YYYYMMWW = "W_" + dateTime.ToString("yyyyMM") + weekNumber;
                    }

                    if (chkColor.Checked == true)
                    {
                        setResultPeriod();
                    }
                    else if (chkColor.Checked == false)
                    {
                        FarPoint.Win.BevelBorder bevelbrdr = new FarPoint.Win.BevelBorder(FarPoint.Win.BevelBorderType.Raised, Color.Green, Color.Green, 3, true, false, false, false);
                        if (cboBucketType.ControlValues != BucketType.Daily)
                        {
                            if (siMain.GetColumnIndex(this_YYYYMMWW) > 0 || siMain.GetColumnIndex(sResult_YYYYMMWW) > 0)
                            {
                                if (siMain.GetColumnIndex(sResult_YYYYMMWW) > 0)
                                    siMain.ActiveSheet.Columns[siMain.GetColumnIndex(sResult_YYYYMMWW)].Border = bevelbrdr;
                                else
                                    siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border = bevelbrdr;
                            }
                        }
                        else if (cboBucketType.ControlValues == BucketType.Daily)
                        {
                            if (siMain.GetColumnIndex("D_" + sPre_YYYYMMDD) > 0)
                                siMain.ActiveSheet.Columns[siMain.GetColumnIndex("D_" + sPre_YYYYMMDD)].Border = bevelbrdr;
                        }
                    }

                    siMain.SpreadObject.SuspendLayout();
                                                                                  
                    int iTotalRowCount = siMain.GetMaxRowIndex();                                        
                    int iTotalColCount = siMain.GetMaxColumnIndex();                                          
                    int iStartColPosition = siMain.GetColumnIndex(DefColumns.MEASURE) + 1;
                                                                         
                    for (int i = 0; i <= iTotalRowCount; i++)
                    {
                        if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) > 0)
                        {
                            siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType = cellTypeImage;
                        }
                    }
                }
                catch (Exception e)
                {
                               
                    MessageHelper.GMessageBoxForException(e);
                }
                finally
                {
                    siMain.SpreadObject.ResumeLayout();
                }

                if (siMain.GetMaxRowIndex() >= 0)
                {
                    SetSpreadColumn();
                    if (dtSave != null)
                        dtSave.Clear();
                }

                                                 
                siMain.SmartColMerge();

                                                    
                if (!blnInsert)
                {
                    siMain.ActiveSheet.SetActiveCell(iUpdateRow, iUpdateCol);
                    spdMain.ShowActiveCell(FarPoint.Win.Spread.VerticalPosition.Center, FarPoint.Win.Spread.HorizontalPosition.Center);
                }

                            
                                          

                               
                UIEndTime();

                CanModelChange = true;
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
                blnWork = false;
                prg.Close();
                siMain.SpreadObject.ResumeLayout();
            }
        }

        private void setResultPeriod()
        {
            int iResultCol = siMain.GetColumnIndex(DefColumns.MEASURE) + 1;
            int iResultMonth = siMain.GetColumnIndex(DefColumns.MEASURE);

            string sStartDate = drpPeriod.Value1.ToString("yyyyMMdd");

                                                          
            if (int.Parse(sStartDate.Substring(0, 6)) >= int.Parse(DateTime.Today.ToString("yyyyMM")))
            {
                iResultMonth = iResultMonth + 1;
            }

            if (siMain.GetMaxRowIndex() >= 0)
                siMain.SetBGColor(0, 0, siMain.GetMaxRowIndex(), siMain.GetMaxColumnIndex(), Color.White);

            for (int iCol = siMain.GetColumnIndex(DefColumns.MEASURE) + 1; iCol <= siMain.GetMaxColumnIndex(); iCol++)
            {
                if (cboBucketType.ControlValues == BucketType.Daily)
                {
                    if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0)
                    {
                        if (int.Parse(sPre_YYYYMMDD) > int.Parse(siMain.GetColumnTag(iCol).Replace("D_", "")))
                            iResultCol = iCol;
                    }
                    else
                    {
                        if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                        {
                            if (int.Parse(sResult_YYYYMMDD.Substring(0, 6)) == int.Parse(siMain.GetColumnTag(iCol).Replace("M_", "")))
                                iResultMonth = iCol;
                        }
                    }
                }
                else if (cboBucketType.ControlValues == BucketType.Weekly)
                {
                    if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0)
                    {
                        if (int.Parse(pre_YYYYMMWW.Replace("W_", "")) == int.Parse(siMain.GetColumnTag(iCol).Replace("W_", "")) ||
                                (pre_YYYYMMWW.Substring(8) == siMain.GetColumnTag(iCol).Substring(8)) && pre_YYYYMMWW.Substring(2, 4) == siMain.GetColumnTag(iCol).Substring(2, 4))
                        {
                            iResultCol = iCol;
                        }
                        else if (pre_YYYYMMWW.Substring(8) == "52" && pre_YYYYMMWW.Substring(8) == siMain.GetColumnTag(iCol).Substring(8))
                        {
                            iResultCol = iCol;
                        }
                    }
                    else
                    {
                        if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0)
                        {
                            if (int.Parse(sResult_YYYYMMDD) > int.Parse(siMain.GetColumnTag(iCol).Replace("D_", "")))
                                iResultCol = iCol;
                        }

                        if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                        {
                            if (int.Parse(sResult_YYYYMMDD.Substring(0, 6)) == int.Parse(siMain.GetColumnTag(iCol).Replace("M_", "")))
                                iResultMonth = iCol;
                        }
                    }
                }
                else if (cboBucketType.ControlValues == BucketType.Monthly)
                {
                    if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                    {
                        if (int.Parse(sResult_YYYYMMDD.Substring(0, 6)) == int.Parse(siMain.GetColumnTag(iCol).Replace("M_", "")))
                            iResultMonth = iCol;
                    }
                    else
                    {
                        if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0)
                        {
                            if (int.Parse(sResult_YYYYMMDD) > int.Parse(siMain.GetColumnTag(iCol).Replace("D_", "")))
                                iResultCol = iCol;
                        }

                        if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0)
                        {
                            if (int.Parse(this_YYYYMMWW.Replace("W_", "")) > int.Parse(siMain.GetColumnTag(iCol).Replace("W_", "")))
                            {
                                iResultCol = iCol;
                            }
                        }
                    }
                }
            }

            if (siMain.GetMaxRowIndex() >= 0)
                siMain.SetBGColor(0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.GetMaxRowIndex(), iResultCol, Color.Gainsboro);
            if (siMain.GetMaxRowIndex() >= 0)
                siMain.SetBGColor(0, iResultMonth, siMain.GetMaxRowIndex(), iResultMonth, Color.White);
        }
        #endregion

        #region 6. Event

        #endregion

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

        private DataTable GetItemType()
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sScmBinding))
            {
                var request = new FoxDataRequest("SCM.SCM0001_GET_LOOKUP_VALUES");
                request.Parameters["p_lookup_type"] = "ITEM_TYPE_CODE";
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

        private void btnProject_Click(object sender, EventArgs e)
        {
            if ((clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") || (clbDivision.SelectedValue.ToString() == "82"))
            {
                              
                string sDivision = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);                              
                string sTeam = clbTeam.ControlValues;
                string sEndCustomer = clbCustomer.ControlValues;
                string sScmSite = clbSalesSite.ControlValues;
                string sProject = txtProject.Text;
                SCM0002_ProjectbyDivisionPopupEx popProject = new SCM0002_ProjectbyDivisionPopupEx();
                popProject.Form_Load(true, sDivision, sTeam, sEndCustomer, sScmSite, sProject);
                popProject.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                popProject.ShowDialog();

                txtProject.Text = popProject.ProjectCode;
            }
        }

        private void btnItemId_Click(object sender, EventArgs e)
        {
                                                
            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);                              
            string sTeam = clbTeam.ControlValues;
            string sEndCustomer = clbCustomer.ControlValues;
            string sProject = txtProject.Text;                                                                  
            string sScmSiteId = clbSalesSite.ControlValues;
            string sItemId = txtItemId.Text;

                                                                                           
            DM0002_ItembyDivisionPopupEx popItem = new DM0002_ItembyDivisionPopupEx();

                                   
            popItem.Form_Load(true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId);
            popItem.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            popItem.ShowDialog();

            txtItemId.Text = popItem.ItemID;
        }

        private void spdMain_TopChange(object sender, FarPoint.Win.Spread.TopChangeEventArgs e)
        {
            CanModelChange = false;
            siMain.SmartColMerge();
            CanModelChange = true;
        }

        private void cboBucketType_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (siMain != null)
            {
                sBucket = cboBucketType.ControlValues;

                if ((fBucket == BucketType.Weekly || fBucket == BucketType.Monthly) && sBucket == BucketType.Daily)
                {
                    InitSpread(true);
                }

                SetSpreadColumn();
                sResult_YYYYMMWW = "W_" + sResult_YYYYMMDD.Substring(0, 6) + weekNumber;

                if (chkColor.Checked == false)
                {
                    FarPoint.Win.BevelBorder bevelbrdr = new FarPoint.Win.BevelBorder(FarPoint.Win.BevelBorderType.Raised, Color.Green, Color.Green, 3, true, false, false, false);

                    if (cboBucketType.ControlValues == BucketType.Daily)
                    {
                        if (siMain.GetColumnIndex("D_" + sPre_YYYYMMDD) > 0)
                            siMain.ActiveSheet.Columns[siMain.GetColumnIndex("D_" + sPre_YYYYMMDD)].Border = bevelbrdr;

                        if (siMain.GetColumnIndex(sResult_YYYYMMWW) > 0)
                        {
                            siMain.ActiveSheet.Columns[siMain.GetColumnIndex(sResult_YYYYMMWW)].ResetBorder();
                        }
                        else if (siMain.GetColumnIndex(this_YYYYMMWW) > 0)
                        {
                            siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].ResetBorder();
                        }
                    }
                    else if (cboBucketType.ControlValues != BucketType.Daily)
                    {
                        if (siMain.GetColumnIndex(sResult_YYYYMMWW) > 0)
                        {
                            siMain.ActiveSheet.Columns[siMain.GetColumnIndex(sResult_YYYYMMWW)].Border = bevelbrdr;
                        }
                        else if (siMain.GetColumnIndex(this_YYYYMMWW) > 0)
                        {
                            siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border = bevelbrdr;
                        }

                        if (siMain.GetColumnIndex("D_" + sPre_YYYYMMDD) > 0)
                            siMain.ActiveSheet.Columns[siMain.GetColumnIndex("D_" + sPre_YYYYMMDD)].ResetBorder();
                    }
                }
                else if (chkColor.Checked == true)
                {
                    setResultPeriod();
                }

                if (!siMain.IsLock(siMain.SheetName))
                {
                    EditButton();
                    EditButton();
                }
            }

        }
        private void SetSpreadColumn()
        {
            int iStartCol = siMain.GetColumnIndex(DefColumns.MEASURE) + 1;
            DateTime dateTime = DateTime.Today.AddDays(Convert.ToInt32(DayOfWeek.Monday) - Convert.ToInt32(DateTime.Today.DayOfWeek));
            sResult_YYYYMMDD = dateTime.ToString("yyyyMMdd");
            sPre_YYYYMMDD = DateTime.Today.ToString("yyyyMMdd");
            bool check = false;

            for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
            {
                if (cboBucketType.ControlValues == BucketType.Daily)
                {
                    if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 || siMain.GetColumnTag(iCol).IndexOf("W_") == 0)
                        siMain.ActiveSheet.Columns[iCol].Visible = true;
                    if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 || siMain.GetColumnTag(iCol).IndexOf("W_") == 0)
                        siMain.ActiveSheet.Columns[iCol].Visible = chkSum.Checked;
                }
                else if (cboBucketType.ControlValues == BucketType.Weekly)
                {
                    if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0)
                        siMain.ActiveSheet.Columns[iCol].Visible = false;
                    else if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0)
                        siMain.ActiveSheet.Columns[iCol].Visible = true;

                    if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                        siMain.ActiveSheet.Columns[iCol].Visible = chkSum.Checked;
                }
                else if (cboBucketType.ControlValues == BucketType.Monthly)
                {
                    if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 || siMain.GetColumnTag(iCol).IndexOf("W_") == 0)
                        siMain.ActiveSheet.Columns[iCol].Visible = false;
                    else if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                        siMain.ActiveSheet.Columns[iCol].Visible = true;
                }

                if (chkColor.Checked == false)
                {
                    siMain.ActiveSheet.ColumnHeader.Columns[siMain.GetColumnTag(iCol)].ResetForeColor();
                    siMain.ActiveSheet.ColumnHeader.Columns[siMain.GetColumnTag(iCol)].ResetFont();
                    if (cboBucketType.ControlValues == BucketType.Daily)
                    {
                        if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                        {
                            if (siMain.GetColumnTag(iCol).Substring(2) == sPre_YYYYMMDD.Substring(0, 6))
                            {
                                siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor = Color.Green;
                                siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font = new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
                                siMain.ActiveSheet.ColumnHeader.Columns[iCol].Width = 60;
                            }
                        }
                        if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0)
                        {
                            if (Convert.ToString(weekNumber) == siMain.GetColumnTag(iCol).ToString().Substring(8) && siMain.GetColumnTag(iCol).ToString().Substring(2, 6) == sPre_YYYYMMDD.Substring(0, 6))
                            {
                                siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor = Color.Green;
                                siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font = new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
                                check = true;
                            }
                            if (check == false)
                            {
                                if (siMain.GetColumnTag(iCol).ToString() == this_YYYYMMWW)
                                {
                                    siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor = Color.Green;
                                    siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font = new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
                                }
                            }
                        }
                    }
                    else
                    {
                        if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                        {
                            if (siMain.GetColumnTag(iCol).Substring(2) == sResult_YYYYMMDD.Substring(0, 6))
                            {
                                siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor = Color.Green;
                                siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font = new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
                                siMain.ActiveSheet.ColumnHeader.Columns[iCol].Width = 60;
                            }
                        }
                        else if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0)
                        {
                            if (Convert.ToString(weekNumber) == siMain.GetColumnTag(iCol).ToString().Substring(8) && siMain.GetColumnTag(iCol).ToString().Substring(2, 6) == sResult_YYYYMMDD.Substring(0, 6))
                            {
                                siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor = Color.Green;
                                siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font = new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
                                check = true;
                            }
                            if (check == false)
                            {
                                if (siMain.GetColumnTag(iCol).ToString() == this_YYYYMMWW)
                                {
                                    siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor = Color.Green;
                                    siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font = new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
                                }
                            }
                        }
                    }
                }
                else if (chkColor.Checked == true)
                {
                    siMain.ActiveSheet.ColumnHeader.Columns[iCol].ResetForeColor();
                    siMain.ActiveSheet.ColumnHeader.Columns[iCol].ResetFont();
                }
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

                                                                                                                                                    

                        if (dr[DefColumns.DayCode].ToString() == DefColumnsLabel.Saturday || dr[DefColumns.DayCode].ToString() == DefColumnsLabel.Sunday)
                        {
                            siMain.Sheet().ColumnHeader.Cells[2, iCellCnt].ForeColor = dr[DefColumns.DayCode].ToString() == DefColumnsLabel.Saturday ? Color.Blue : Color.Red;
                        }

                    }

                    if (sLargeSpanName != sLargeLabelName)
                    {
                        siMain.ColumnHeaderSpan(0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center);
                        siMain.ColumnHeaderSpan(1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center);
                        sLargeSpanName = dr[DefColumns.LargeLabelName].ToString();
                        iLargeStartCol = iLargeStartCol + iLargeSpanCnt;
                        iLargeSpanCnt = 0;

                        siMain.ColumnHeaderSpan(1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center);
                        siMain.ColumnHeaderSpan(2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center);
                        sSmallSpanName = dr[DefColumns.SmallLabelName].ToString();
                        iSmallStartCol = iSmallStartCol + iSmallSpanCnt;
                        iSmallSpanCnt = 0;
                    }
                    else if (sSmallSpanName != sSmallLabelName)
                    {
                        siMain.ColumnHeaderSpan(1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center);
                        siMain.ColumnHeaderSpan(2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center);
                        sSmallSpanName = dr[DefColumns.SmallLabelName].ToString();
                        iSmallStartCol = iSmallStartCol + iSmallSpanCnt;
                        iSmallSpanCnt = 0;
                    }

                    iLargeSpanCnt++;
                    iSmallSpanCnt++;
                }
            }

            siMain.ColumnHeaderSpan(1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center);
            siMain.ColumnHeaderSpan(2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center);
            siMain.ColumnHeaderSpan(0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center);
            siMain.ColumnHeaderSpan(1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center);

            siMain.Freeze(0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1);

            siMain.SmartColMerge();
        }

        private void spdMain_CellDoubleClick(object sender, FarPoint.Win.Spread.CellClickEventArgs e)
        {

        }

        private void Dsdm_Changed(object sender, FarPoint.Win.Spread.Model.SheetDataModelEventArgs e)
        {
                                   
            if (siMain.IsLock(siMain.SheetName) == true)
                return;

                                                                          
                                            
            if (e.Column < 0 || e.Row < 0)
                return;
            if (siMain.IsLockCell(e.Row, e.Column))
                return;

            switch (e.Type)
            {
                case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated:
                    if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Column)
                    {
                                                      
                        if (siMain.GetColumnTag(e.Column).IndexOf("D_") == 0)
                            return;

                        string sChangeMea = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString();
                        if (sChangeMea == "")
                        {
                            siMain.SetText(e.Row, e.Column, "");
                            return;
                        }

                                  
                        siMain.SetColor(e.Row, e.Column, e.Row, e.Column, System.Drawing.Color.Red, false);

                        #region Sum 계산 수정.
                        int iStartCol = 0;
                        decimal iMonthlySum = 0;
                        string sColName = siMain.GetColumnTag(e.Column);

                                     
                        for (int iCol = e.Column; iCol > 0; iCol--)
                        {
                            if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0)
                            {
                                iStartCol = iCol + 1;
                                break;
                            }
                        }

                        if (siMain.GetColumnTag(iStartCol).IndexOf("W_") == 0 && siMain.GetText(e.Row, iStartCol) != "")
                        {
                            siMain.SetText(e.Row, iStartCol, siMain.GetText(e.Row, iStartCol));
                        }

                                      
                        for (int iCol = e.Column; iCol > 0; iCol--)
                        {
                            if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                            {
                                iStartCol = iCol + 1;
                                break;
                            }
                        }

                        for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                        {
                            if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0 && siMain.GetText(e.Row, iCol) != "")
                            {
                                iMonthlySum = iMonthlySum + Convert.ToDecimal(siMain.GetText(e.Row, iCol).Replace(",", ""));
                            }

                            if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                            {
                                siMain.SetText(e.Row, iStartCol - 1, iMonthlySum.ToString());
                                break;
                            }
                        }

                        string sYYYYMMDD = sColName.Replace("D_", "");
                        decimal iQty = 0;

                        if (siMain.GetText(e.Row, e.Column) != "")
                        {
                            iQty = Convert.ToDecimal(siMain.GetText(e.Row, e.Column).Replace(",", ""));
                        }
                        #endregion

                        #region Sum 계산 오류로 주석. 20190306
                                      
                                                                                      
                                                       
                            
                                            
                                                                                   
                                                               
                                
                                                                                             
                                                  
                                    
                                                  
                                                                             
                                    
                                                                                                                        
                                                                                    
                                                                                  
                                                                                                                                                           
                                                                                                     

                                                                                                      

                                                 
                                                          
                                                                                                                            
                                    
                                                           
                                                                                                                             
                                                                                                                                                              
                                                                                                         
                                    
                                       
                                    
                                                           
                                                                                                                                            
                                                                                                                                                              
                                                                                                         
                                    
                                         
                                
                            
                        #endregion

                        try
                        {

                        }
                        catch (Exception erc)
                        {
                                         
                        }
                    }
                    else
                    {
                        try
                        {

                        }
                        catch (Exception erc)
                        {
                                         
                        }
                    }
                    break;

                default:
                    break;
            }
        }

        private void InitSaveDataTable()
        {
            dtSave = new DataTable("MktFcstSave");
            dtSave.Columns.Add(DefColumns.DIVISION_ID, typeof(string));
            dtSave.Columns.Add(DefColumns.PROJECT_CODE, typeof(string));
            dtSave.Columns.Add(DefColumns.SCM_SITE_ID, typeof(string));
            dtSave.Columns.Add(DefColumns.ITEM_ID, typeof(string));
            dtSave.Columns.Add(DefColumns.DomExp, typeof(string));
            dtSave.Columns.Add(DefColumns.INCOTERMS, typeof(string));
            dtSave.Columns.Add(DefColumns.FcstType, typeof(string));
            dtSave.Columns.Add(DefColumns.MEASURE, typeof(string));
            dtSave.Columns.Add(DefColumns.YYYYMMDD, typeof(string));
            dtSave.Columns.Add(DefColumns.Qty, typeof(int));

        }
        private void SetSaveData(string sDivision, string sProjectCode, string sSiteId, string sItemId, string sDomExp
                               , string sFcstType, string sIncoterms, string sMeasure, string sYYYYMMDD, int iQty)
        {
            string sFilter = DefColumns.DIVISION_ID + "= '" + sDivision + "'";
            sFilter += " and " + DefColumns.PROJECT_CODE + " = '" + sProjectCode + "'";
            sFilter += " and " + DefColumns.SCM_SITE_ID + " = '" + sSiteId + "'";
            sFilter += " and " + DefColumns.ITEM_ID + " = '" + sItemId + "'";
            sFilter += " and " + DefColumns.DomExp + " = '" + sDomExp + "'";
            sFilter += " and " + DefColumns.FcstType + " = '" + sFcstType + "'";
            sFilter += " and " + DefColumns.INCOTERMS + " = '" + sIncoterms + "'";
            sFilter += " and " + DefColumns.MEASURE + " = '" + sMeasure + "'";
            sFilter += " and " + DefColumns.YYYYMMDD + "= '" + sYYYYMMDD + "'";

            DataRow[] drFind = dtSave.Select(sFilter);

            if (drFind.Length == 0)
            {
                DataRow drNew = dtSave.NewRow();
                drNew[DefColumns.DIVISION_ID] = sDivision;
                drNew[DefColumns.PROJECT_CODE] = sProjectCode;
                drNew[DefColumns.SCM_SITE_ID] = sSiteId;
                drNew[DefColumns.ITEM_ID] = sItemId;
                drNew[DefColumns.DomExp] = sDomExp;
                drNew[DefColumns.FcstType] = sFcstType;
                drNew[DefColumns.INCOTERMS] = sIncoterms;
                drNew[DefColumns.MEASURE] = sMeasure;
                drNew[DefColumns.YYYYMMDD] = sYYYYMMDD;
                drNew[DefColumns.Qty] = iQty;

                dtSave.Rows.Add(drNew);
                dtSave.AcceptChanges();
            }
            else
            {
                drFind[0][DefColumns.Qty] = iQty;
                dtSave.AcceptChanges();
            }
        }

        private bool fnValidation()
        {
            bool bValidation = true;
            int iValidation = 0;
            string sDivision = string.Empty;
            string sProjectCode = string.Empty;
            string sSiteId = string.Empty;
            string sItemId = string.Empty;
            string sCurrency = string.Empty;
            string sDomExp = "";
            string sFcstType = "";
            string sIncoterms = "";
            string sMeasure = "";
            string sPlantSiteId = string.Empty;

            for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
            {
                if (siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI)
                {
                    if ((clbDivision.ControlValues.Substring(0, 2) == "81") || (clbDivision.ControlValues == "82"))
                    {
                        sDivision = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                        sProjectCode = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString();
                    }
                    else
                    {
                        sDivision = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                        sProjectCode = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)).ToString();
                    }
                    if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) > 0)
                        sSiteId = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.ITEM_ID) > 0)
                        sItemId = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.DomExp) > 0)
                        sDomExp = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DomExp)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.FcstType) > 0)
                        sFcstType = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FcstType)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.INCOTERMS) > 0)
                        sIncoterms = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.INCOTERMS)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.CURRENCY) > 0)
                        sCurrency = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.CURRENCY)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.MEASURE) > 0)
                        sMeasure = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString();

                    if (clbDivision.ControlValues.Substring(0, 2) == "81")
                        sPlantSiteId = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID)).ToString();

                    for (int iRow2 = 0; iRow2 <= siMain.GetMaxRowIndex(); iRow2++)
                    {
                        if (clbDivision.ControlValues.Substring(0, 2) == "81")
                        {
                            if (sDivision == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString()
                            && sProjectCode == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString()
                            && sSiteId == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString()
                            && sItemId == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString()
                            && sDomExp == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.DomExp)).ToString()
                            && sFcstType == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.FcstType)).ToString()
                            && sIncoterms == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.INCOTERMS)).ToString()
                                                                                                                            
                            && sMeasure == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString()
                            && (sPlantSiteId == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID)).ToString())      
                                                                                                                                                                                                                                                                                          
                           )
                            {
                                iValidation++;
                            }
                        }
                        else if (clbDivision.ControlValues == "82")
                        {
                            if (sDivision == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString()
                            && sProjectCode == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString()
                            && sSiteId == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString()
                            && sItemId == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString()
                            && sDomExp == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.DomExp)).ToString()
                            && sFcstType == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.FcstType)).ToString()
                            && sIncoterms == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.INCOTERMS)).ToString()
                                                                                                                            
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
                                                                                                                            
                            && sMeasure == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString()
                           )
                            {
                                iValidation++;
                            }
                        }
                    }
                    if (iValidation > 1)
                        break;
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

        public System.Drawing.Color GetCellColor(SpreadInfo siInfo, int iRow1, int iCol1, int iRow2, int iCol2)
        {
            FpSpread fpSpread = siInfo.SpreadObject;
                                                           
            FarPoint.Win.Spread.Cell range1;
            range1 = fpSpread.ActiveSheet.Cells[iRow1, iCol1, iRow2, iCol2];
            var vCellColor = range1.ForeColor;

            return vCellColor;
        }

        private void chkSum_CheckedChanged(object sender, EventArgs e)
        {
            if (siMain != null)
            {
                SetSpreadColumn();
            }
        }

        private void chkColor_CheckedChanged(object sender, EventArgs e)
        {
            if (siMain != null)
            {
                SetSpreadColumn();
            }
        }

        private void btnColumn_Click(object sender, EventArgs e)
        {
                                                                                                                  
            DM0002_TitleSetForm_Popup frm = new DM0002_TitleSetForm_Popup(sProgram_Id, SpdSheet.shtMain, true, clbDivision.ControlValues);
            frm.StartPosition = FormStartPosition.CenterParent;
            frm.ShowDialog();

            if (frm.DialogResult == DialogResult.OK)
            {
                InitSpread(true);
            }
        }

        private void btnMeasure_Click(object sender, EventArgs e)
        {
                                                                                                                   
            DM0002_TitleSetForm_Popup frm = new DM0002_TitleSetForm_Popup(sProgram_Id, SpdSheet.shtMain, false, clbDivision.ControlValues);
            frm.StartPosition = FormStartPosition.CenterParent;
            frm.ShowDialog();

            if (frm.DialogResult == DialogResult.OK)
            {
                InitSpread(true);
            }
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

        private string GetThisWeekMonday(out System.DateTime thisWeekDate)
        {
                                                                   
            DateTime dtStart = System.DateTime.Now;
            string sYYYYMMDD = "";
            while (true)
            {
                                                                        
                             
                if (dtStart.DayOfWeek == DayOfWeek.Monday)
                {
                    thisWeekDate = dtStart;
                    sYYYYMMDD = dtStart.ToString("yyyyMMdd");
                    break;
                }
                dtStart = dtStart.AddDays(-1);
            }

            return sYYYYMMDD;
        }


        private void clbCustomer_SelectedIndexChanged(object sender, EventArgs e)
        {
                                                                       
                                                                                                                                                                                     

            SetChangeControl("UserSiteByEndCustomer", clbDivision.ControlValues, string.Empty, clbCustomer.ControlValues);
            clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);
        }

        private void clbDivision_SelectedIndexChanged(object sender, EventArgs e)
        {
                                               
            DataService.FP_Log2("SpeedUp", "DMF0048", "division_id_changed", "start");
            try
            {
                             
                if (blnWork)
                {
                                                             
                    return;
                }
                          
                blnWork = true;

                string sDivision = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);

                                                                           
                                                                                                                                      

                SetChangeControl("UserTeamByDivision", sDivision);
                clsCtrl.setListBox(dtTeam, clbTeam, true);

                string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);

                                            
                                                                                         
                if (sDivision == "40")
                {
                                                                               
                                                                                             

                    SetChangeControl("BizType", sDivision);
                    clsCtrl.setListBox(dtBizType, clbBizType, true);

                                                                               
                                                                                                                                                                                                   

                    SetChangeControl("EndCustomerByDivision", sDivision, clbTeam.ControlValues);

                                                  
                    lblProject.Enabled = false;
                    layoutControlItem3.Enabled = false;
                    lblPlantSite.Enabled = false;

                    txtProject.Text = "";
                    clbPlantSite.ControlValues = "";
                }
                else
                {
                                                                               
                                                                                   

                    SetChangeControl("BizType", clbDivision.ControlValues);
                    clsCtrl.setListBox(dtBizType, clbBizType, true);

                                                                               
                                                                                                                                                                

                    SetChangeControl("EndCustomerByDivision", sDivision, sTeam);

                                                 
                    lblProject.Enabled = true;
                    layoutControlItem3.Enabled = true;
                    lblPlantSite.Enabled = true;
                }

                                                                  
                                                  
                       
                lblBizType.Enabled = true;

                                                                           
                                                                     

                clsCtrl.setListBox(dtEndCustomer, clbCustomer, true);

                string sEndCustomer = CString.GetCheckedListValue(dtCustomer, clbCustomer.ControlValues);

                                                                           
                                                                                                                                                            

                SetChangeControl("UserSiteByEndCustomer", sDivision, string.Empty, sEndCustomer);
                clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);

                                                                           
                                                                                                                                                

                SetChangeControl("UserPlantSiteByDivision", sDivision);

                                                                           
                                                                       
                clsCtrl.setListBox(dtPlantSiteByDivision, clbPlantSite, true);

                                                   
                DataService.FP_Log2("SpeedUp", "DMF0048", "division_id_changed", "end");

                this.txtProject.Text = "";
                this.txtItemId.Text = "";
                this.txtOwner.Text = "";

                InitSpread(true);
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
        private DataTable GetBizTypebyDivisionAsync(string sDivision)
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
            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);
            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);
            string sEndCustomer = "";
                          
            if ((clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") || (clbDivision.SelectedValue.ToString() == "82"))
            {
                                                                                                                                                               
                                                                        

                                                                                                     

                                                                                                                                                            

                                                                           
                                                                                                                                                            
                                                                     

                SetChangeControl("EndCustomerByDivision", sDivision, sTeam);
                clsCtrl.setListBox(dtEndCustomer, clbCustomer, true);
                sEndCustomer = CString.GetCheckedListValue(dtCustomer, clbCustomer.ControlValues);

                                                                                         
                                                                                                                                                            

                SetChangeControl("UserSiteByEndCustomer", sDivision, string.Empty, sEndCustomer);
            }
            else
            {
                                                                           
                                                                                                                                                                                                  

                SetChangeControl("EndCustomerByDivision", sDivision, clbTeam.ControlValues);
                clsCtrl.setListBox(dtEndCustomer, clbCustomer, true);

                sEndCustomer = CString.GetCheckedListValue(dtCustomer, clbCustomer.ControlValues);

                                                                           
                                                                                                                                                                                                                       

                SetChangeControl("UserSiteByEndCustomer", sDivision, clbTeam.ControlValues, clbCustomer.ControlValues);
            }

            clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);
        }

        public DataSet GetDataTableMeargeForDate(SpreadInfo sfpInfo)
        {
            lock (objLock)
            {
                DataSet ds = null;
                DataTable dt = null;
                if (sfpInfo.SpreadObject.DataSource == null)
                {
                    ds = new DataSet();
                    dt = new DataTable();
                    ds.Tables.Add(dt);
                }
                else
                    ds = (DataSet)sfpInfo.SpreadObject.DataSource;
                SheetView sv = sfpInfo.Sheet(sfpInfo.SpreadObject.ActiveSheet.SheetName);
                Object[,] objView = sv.GetArray(0, 0, sv.RowCount - 1, sv.ColumnCount - 1);

                DataSet ds2 = new DataSet();
                DataTable table = new DataTable();
                              
                for (int i = 0; i < sv.ColumnCount; i++)
                {
                    string sFieldName = sv.Columns[i].Tag.ToString();

                    if (ds.Tables[0].Columns[sFieldName] != null)
                        continue;
                    if (sFieldName == "COLMERGE")
                        continue;

                                                                                  
                                  
                                                                     
                                                    
                    if (sFieldName.IndexOf("D_2") >= 0
                            || sFieldName.IndexOf("W_2") >= 0
                            || sFieldName.IndexOf("M_2") >= 0
                            )
                    {
                        table.Columns.Add(sFieldName, typeof(decimal));
                    }
                    else
                        table.Columns.Add(sFieldName, typeof(string));

                }
                ds2.Tables.Add(table);

                          
                                                     
                ds.Tables[0].Merge(ds2.Tables[0]);

                return ds;
            }
        }

        private void cboKRW_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (siMain == null)
                return;
                                   
                          

                                      
        }

        private void cboUSD_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (siMain == null)
                return;
                                   
                          

                                      
        }

        private void cboLOC_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (siMain == null)
                return;
                                   
                          

                                      
        }

        private void btnOwner_Click(object sender, EventArgs e)
        {
                          
            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);                              
            string sTeam = clbTeam.ControlValues;
            string sEndCustomer = clbCustomer.ControlValues;
            string sProject = txtProject.Text;                                                                  
            string sScmSiteId = clbSalesSite.ControlValues;
            string sItemId = txtItemId.Text;
            string sOwner = txtOwner.Text;

            DM0020_OwnerbyDivisionPopup popItem = new DM0020_OwnerbyDivisionPopup();

                                   
            popItem.Form_Load(true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner);
            popItem.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            popItem.ShowDialog();

            txtOwner.Text = popItem.OwnerID;
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
    }

}
