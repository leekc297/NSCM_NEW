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
using System.Collections.Generic;

                                                                                                                                             
                                    
                                                     
                    
                                                                                                                                             
                                           
                                                                                                                                             
                                                                             
                                                                     
                                                                                                                   
                                                                                                     
                                                                 
                                                     
                                                                           
                                             
                                                                   
                                                             
                                                                       
                                                                                      
                                                 
                                                  
                                                             
                                                                                                                       
                                                      
                                                   
                                                                                       
                                                                                             
                                                                      
                                                                          
                                                                
                                                                     
                                                                                                          
                                                                                     
                                                                                            
                                                                               
                                                                                                             
                                                                       
                                                                                                 
                                                                         
                                                                                                                                            

namespace GSCM.DM.Plan.UIL
{
    public partial class DMF0021_SalesPlan : BaseForm
    {
        #region 1. Setting
                  
        private SpreadInfo siMain = null;

        private CControl clsCtrl = null;

                           
        private DataTable dtSave = null;
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
        private DataTable dtPlantSite = null;
        private DataTable dtITEM_ID = null;
                                               
        private DataTable dtCurrencyList = null;
        private DataTable dtCellProdSiteID = null;                                                 
                                                                         
                                   
        private DataTable dtCustomsHandbook = null;
        private DataTable dtIncotermsType = null;
        private DataTable dtFcstType = null;
                                 

                 
        private string fBucket = "";
        private string sBucket = "";
                                       
        private DateTime weekDate;
        private string this_YYYYMM = "";
        private string this_YYYYMMWW = "";
        private string pre_YYYYMM = "";
        private string pre_YYYYMMWW = "";
        private string iso_week = "";
        private string sResult_YYYYMMWW = "";
        private string basis_YYYYMM = "";
        private string sResult_YYYYMMDD = "";
        private string ssQty = "";
        private string sMeasure = "";
                                          

        private readonly object objLock = new object();

        private TextCellType cellTypeImage = null;

                                                  
                                        

        private DateTime dtStartPeriod;
        private DateTime dtEndPeriod;

                                                                                                            
        List<int> list_EDIT_Week = new List<int>();                                                         
        List<int> list_EDIT_Month = new List<int>();                                                         
                                                                                                          

                      
                       
                       
        private struct SpdSheet
        {
            public static string shtMain = "Sales Plan";
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
            public static string TEXT = "TEXT";
            public static string TEXT4082 = "TEXT4082";                                 
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
            public static string KwhCell = "KWH_CELL";
            public static string KwhModule = "KWH_MODULE";
            public static string KwhPack = "KWH_PACK";
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
                                    
            public static string COMPANY_ID = "COMPANY_ID";
            public static string CUST_GROUP = "CUST_GROUP";
            public static string CUST_GROUP_DTL = "CUST_GROUP_DTL";
            public static string APPLICATION = "APPLICATION";

            public static string ROUTE = "ROUTE";
            public static string BIZ_TYPE_NAME40 = "BIZ_TYPE_NAME40";
            public static string GROUP_ID = "GROUP_ID";
            public static string INTERNAL_YN = "INTERNAL_YN";
            public static string CELL_TYPE = "CELL_TYPE";
            public static string FORECAST_INFO_CELL_PACK_COUNT = "FORECAST_INFO_CELL_PACK_COUNT";
            public static string CELL_MODEL_INFO = "CELL_MODEL_INFO";
            public static string CELL_MODEL = "CELL_MODEL";
            public static string FORECAST_INFO_ALL = "FORECAST_INFO_ALL";
            public static string FORECAST_INFO_SPEC = "FORECAST_INFO_SPEC";

            public static string FORECAST_INFOR_VERSION = "FORECAST_INFOR_VERSION";
            public static string CELL_MODEL_NICK_NAME = "CELL_MODEL_NICK_NAME";
            public static string MDM_PROJECT_NAME = "MDM_PROJECT_NAME";
            public static string MIN_CAPACITY = "MIN_CAPACITY";
            public static string CELL_PER_CAR = "CELL_PER_CAR";
            public static string CELL_PER_MODULE = "CELL_PER_MODULE";
            public static string MODULE_PER_CAR = "MODULE_PER_CAR";
            public static string ENERGE = "ENERGE";
            public static string ENERGE_WH = "ENERGE_WH";
            public static string CELL_QUANTITY = "CELL_QUANTITY";

            public static string DMS_SALES = "DMS_SALES";
            public static string DMS_CUSTOMER = "DMS_CUSTOMER";
                                                                     
            public static string CELL_PROD_SITE_ID = "CELL_PROD_SITE_ID";
                                                                   
                                                                                      
            public static string SCP_USE_YN = "SCP_USE_YN";
                                                                                    
                                                                  
            public static string FromSiteId = "FROM_SITE_ID";
                                                                
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
            public static string Text = "Text";
            public static string TEXT4082 = "TEXT4082";                                 
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

        private string sProgram_Id = "DMF0021";

        #endregion

        #region 2. Construct

        public DMF0021_SalesPlan()
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

                                                                                                                     
                                                                                                                       
                                                                                                                                                                                  

                SetChangeControl("EndCustomerByDivision", sDivision, sTeam);

                                                                                                                     
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

                                  
            dtMearsure = GetSALESPLAN_MEASUREInfo();
                                                                                   

                                        
            dtCustomsHandbook = GetCustomsHandbook();          
            dtFcstType = GetFcstType();           
                                      
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
                if (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd")
                    && dtEndPeriod.ToString("yyyyMMdd") == drpPeriod.Value2.ToString("yyyyMMdd") && !isChangeHeader)
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
                                                                                    
                var request = new FoxDataRequest("DM.DMF0021_GET_SPREAD_TITLE");
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

        protected override void InsertButton()
        {
            InsertRow();
        }

        protected override void DeleteButton()
        {
            if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI)
            {
                siMain.Delete();
            }
        }

        protected override void EditButton()
        {
            if (this.fps != null)
            {                                       
                              

                                                      

                                   
                                                                     
                   
                                  
                                                            
                             
                   
                                                            
                                                                                                                                        
                    

                                  
                                                                                                                                          
                                                                                                
                if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) == -1
                || (CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) != "40" && siMain.GetColumnIndex(DefColumns.PROJECT_CODE) == -1)                             
                || (CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) == "40" && siMain.GetColumnIndex(DefColumns.END_CUSTOMER40) == -1)                                     
                || (CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) != "40" && siMain.GetColumnIndex(DefColumns.END_CUSTOMER) == -1)                                                            
                || siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) == -1
                || siMain.GetColumnIndex(DefColumns.ITEM_ID) == -1
                || (CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues).Substring(0, 2) == "81" && siMain.GetColumnIndex(DefColumns.TEXT) == -1)                                    
                || siMain.GetColumnIndex(DefColumns.DomExp) == -1                                                                                                                                                                                                    
                || siMain.GetColumnIndex(DefColumns.FcstType) == -1
                || siMain.GetColumnIndex(DefColumns.INCOTERMS) == -1
                || siMain.GetColumnIndex(DefColumns.MEASURE) == -1
                || siMain.GetColumnIndex(DefColumns.CURRENCY) == -1
                || (CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) == "40" && siMain.GetColumnIndex(DefColumns.DEPT_ID) == -1)                             
                || (CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) == "40" && siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID) == -1)                                                  
                || (CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues).Substring(0, 2) == "81" && siMain.GetColumnIndex(DefColumns.FromSiteId) == -1)                                               
                || (CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues).Substring(0, 2) == "81" && siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID) == -1)                                               
                )
                {                                                                
                                                                                           
                    if (CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) == "40" && siMain.GetColumnIndex(DefColumns.DEPT_ID) == -1)
                    {
                        MessageHelper.GMessageBox("MSG00429", new object[] { "Team" });                   
                    }
                    else if (CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) == "40" && siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID) == -1)
                    {
                        MessageHelper.GMessageBox("MSG00113");                    
                    }
                    else
                    {
                        MessageHelper.GMessageBox("MSG00113");                    
                    }
                                                                                         
                    return;
                }

                if (cboBucketType.ControlValues == BucketType.Weekly || cboBucketType.ControlValues == BucketType.Monthly)
                {
                    siMain = GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex);
                    siMain.SwitchLock();

                                    
                    siMain.LockColumn(0, siMain.GetMaxColumnIndex(), true);

                    string[] sPeriod = drpPeriod.ControlValues.Split(':');
                    DateTime sStartPeriod = Convert.ToDateTime(sPeriod[0].ToString().Substring(0, 4) + "-" + sPeriod[0].ToString().Substring(4, 2) + "-" + sPeriod[0].ToString().Substring(6, 2));

                                                        
                                    
                                                          
                                                                                                            
                                                                                      

                    int iStartCol = siMain.GetColumnIndex(DefColumns.MEASURE) + 1;
                    list_EDIT_Week.Clear();                     
                    list_EDIT_Month.Clear();                      

                                                                                                                
                                                                                  
                                                                                                                        
                    for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                    {
                                                                                                                        
                        if (clbDivision.SelectedValue.ToString().Substring(0, 2) == "40")
                        {                                        
                                                                                                                                                                       
                            if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 && siMain.GetColumnIndex(this_YYYYMM) > 0 && siMain.GetColumnIndex(this_YYYYMM) <= iCol)
                            {
                                list_EDIT_Month.Add(iCol);
                            }
                                                                                                                  
                                                                                               
                                                                                                               
                            else if (int.Parse(sPeriod[0].Substring(0, 6)) > Convert.ToInt32(this_YYYYMM.Replace("M_", "")))
                            {
                                if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                                    list_EDIT_Month.Add(iCol);
                            }
                        }
                                                                                                                      
                                                                               
                        else
                        {
                            if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 && siMain.GetColumnIndex(this_YYYYMM) > 0 && siMain.GetColumnIndex(this_YYYYMM) < iCol)
                            {
                                list_EDIT_Month.Add(iCol);
                            }
                                                                                                                  
                                                                                               
                                                                                                               
                            else if (int.Parse(sPeriod[0].Substring(0, 6)) > Convert.ToInt32(this_YYYYMM.Replace("M_", "")))
                            {
                                if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                                    list_EDIT_Month.Add(iCol);
                            }
                        }
                                                                                                                    

                        if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0 && siMain.GetColumnIndex(this_YYYYMMWW) > 0 && siMain.GetColumnIndex(this_YYYYMMWW) <= iCol)
                        {
                            list_EDIT_Week.Add(iCol);
                        }
                                                                                                                      
                                                                                    
                                                                                           
                                                                                                                     
                        else if (int.Parse(sPeriod[0].Substring(0, 6)) > Convert.ToInt32(this_YYYYMMWW.Replace("W_", "").Substring(0, 6)))
                        {
                            if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0)
                                list_EDIT_Week.Add(iCol);
                        }
                                                                                                                    
                    }

                    if (siMain.GetMaxRowIndex() >= 0)
                    {
                        if (chkColor.Checked == true)
                        {
                            if (sStartPeriod.CompareTo(weekDate.AddDays(-7)) <= 0 && siMain.GetColumnIndex(pre_YYYYMMWW) >= 0)
                            {
                                siMain.SetBGColor(0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.GetMaxRowIndex(), siMain.GetColumnIndex(pre_YYYYMMWW), Color.Gainsboro);
                            }

                                      
                            if (siMain.GetColumnIndex(this_YYYYMM) > 0)
                            {
                                siMain.SetBGColor(0, siMain.GetColumnIndex(this_YYYYMM), siMain.GetMaxRowIndex(), siMain.GetColumnIndex(this_YYYYMM), Color.White);
                            }
                        }
                        else if (chkColor.Checked == false)
                        {
                            FarPoint.Win.BevelBorder bevelbrdr = new FarPoint.Win.BevelBorder(FarPoint.Win.BevelBorderType.Raised, Color.Green, Color.Green, 3, true, false, false, false);
                                                                            
                                       
                               
                                                                          
                                                                                                                     
                                 
                                                                                                                        
                              
                                                                                                         
                                                                                       

                            if (siMain.GetColumnIndex(this_YYYYMMWW) > 0)
                            {
                                if (int.Parse(sPeriod[0]) > int.Parse(sResult_YYYYMMDD))
                                {
                                    siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border = bevelbrdr;
                                }
                                else
                                {
                                    sResult_YYYYMMWW = "W_" + sResult_YYYYMMDD.Substring(0, 6) + iso_week;
                                    siMain.ActiveSheet.Columns[siMain.GetColumnIndex(sResult_YYYYMMWW)].Border = bevelbrdr;
                                }
                            }
                                                                        
                        }
                    }

                              
                                                        
                        
                                                                                 
                            
                                                                                                                                                                                  
                            
                                                                                                                                                                
                        

                                   
                                                                                              

                    DataTable dtTeamAuth = Data.UserTeamByDivisionAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.SelectedValue.ToString());
                                    
                    try
                    {
                        int i_EditStartCol = siMain.GetColumnIndex(DefColumns.MEASURE) + 1;               

                        if (siMain.GetColumnTag(i_EditStartCol).IndexOf("M_") >= 0)
                        {
                            i_EditStartCol += 1;                        
                        }

                                                      
                        if (siMain.GetColumnTag(siMain.GetMaxColumnIndex()).IndexOf("W_") >= 0)
                        {
                            if (Convert.ToInt32(siMain.GetColumnTag(siMain.GetMaxColumnIndex()).Replace("W_", "")) < Convert.ToInt32(this_YYYYMMWW.Replace("W_", "")))
                            {
                                i_EditStartCol = 0;
                            }
                        }
                        else if (siMain.GetColumnTag(siMain.GetMaxColumnIndex()).IndexOf("D_") >= 0)
                        {
                            if (Convert.ToInt32(siMain.GetColumnTag(siMain.GetMaxColumnIndex()).Replace("D_", "")) < Convert.ToInt32(sResult_YYYYMMDD))
                            {
                                i_EditStartCol = 0;
                            }
                        }

                                                                                                          
                        if (clbDivision.SelectedValue.ToString().Substring(0, 2) == "40" && i_EditStartCol > 0)
                        {
                            if (cboBucketType.ControlValues == BucketType.Monthly)
                            {
                                if (Convert.ToInt32(siMain.GetColumnTag(i_EditStartCol).Replace("W_", "")) < Convert.ToInt32(this_YYYYMMWW.Replace("W_", "")))
                                {
                                    for (int iCol = i_EditStartCol; iCol < siMain.GetColumnIndex(this_YYYYMMWW); iCol++)
                                    {
                                        if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0)
                                            list_EDIT_Week.Add(iCol);
                                    }
                                }
                            }
                        }
                                                                                                        

                        if (siMain.GetColumnIndex(this_YYYYMMWW) >= 0)
                        {
                            i_EditStartCol = siMain.GetColumnIndex(this_YYYYMMWW);
                        }

                                                                                                            
                                                                             
                                          
                                                 
                                           
                                           
                                         

                                                                                   
                        DataTable dt;
                        bool bEDIT_AUTH_SalesAmt_LOC = false;                                                   
                        bool bEDIT_AUTH_RTF_SYS_RP = false;                                                 

                        if (dsMain != null && dsMain.Tables.Count >= 3)
                        {
                            dt = dsMain.Tables[2].Copy();
                            if (dt.Columns.Contains("EDIT_AUTH_SalesAmt_LOC"))
                            {
                                bEDIT_AUTH_SalesAmt_LOC = dt.Rows[0]["EDIT_AUTH_SalesAmt_LOC"].ToString() == "Y" ? true : false;
                            }
                            if (dt.Columns.Contains("EDIT_AUTH_RTF_SYS_RP"))
                            {
                                bEDIT_AUTH_RTF_SYS_RP = dt.Rows[0]["EDIT_AUTH_RTF_SYS_RP"].ToString() == "Y" ? true : false;
                            }
                        }
                                                                                                          

                                                                                                                                      
                                                                                
                        if (i_EditStartCol > 0)                              
                        {
                            for (int i = 0; i <= siMain.GetMaxRowIndex(); i++)
                            {
                                             
                                string sSALES_PLAN_ADJUST_YN = siMain.GetText(i, siMain.GetColumnIndex(DefColumns.SALES_PLAN_ADJUST_YN));
                                if (sSALES_PLAN_ADJUST_YN == "N_Y")
                                {
                                                                                                                             
                                                                                                                                                                                               
                                    if ((siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString() == "SalesAmt_LOC" && bEDIT_AUTH_SalesAmt_LOC && siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.FcstType)).ToString() == "ETC")
                                                                                                                           
                                    || (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString() == "Catch_Up")                                     
                                    || (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString().ToUpper() == "RTF_SYS_RP" && bEDIT_AUTH_RTF_SYS_RP))                                                    
                                    {
                                        string sValue = "";
                                        int j = 0;
                                        if (cboBucketType.ControlValues == BucketType.Monthly)
                                        {
                                            sValue = siMain.GetColumnTag(list_EDIT_Month[0]);                                             
                                            j = list_EDIT_Month[0];
                                        }
                                        else if (cboBucketType.ControlValues == BucketType.Weekly)
                                        {
                                            sValue = siMain.GetColumnTag(list_EDIT_Week[0]);                                            
                                            j = list_EDIT_Week[0];
                                        }

                                        if (sValue.IndexOf("W_") == 0 || sValue.IndexOf("M_") == 0)
                                        {
                                                                               
                                                                                                           
                                            if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() == "40" && siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString() == "Catch_Up")
                                            {
                                                                 
                                                if (Convert.ToUInt32(sValue.Replace("W_", "").Replace("M_", "").Substring(0, 6)) >= Convert.ToUInt32(DateTime.Now.AddMonths(3).ToString("yyyyMM")))
                                                {
                                                                    
                                                    if (cboBucketType.ControlValues == BucketType.Weekly && sValue.IndexOf("W_") == 0 || cboBucketType.ControlValues == BucketType.Monthly && sValue.IndexOf("M_") == 0)
                                                    {
                                                        if (IsEditMode)
                                                        {
                                                                             
                                                                                                                                    
                                                                                                                          

                                                                                    
                                                            siMain.LockRange(i, j, i, siMain.GetMaxColumnIndex(), false);                                                    

                                                            if (cboBucketType.ControlValues == BucketType.Monthly)
                                                            {
                                                                                                   
                                                                for (int x = 0; x < list_EDIT_Week.Count; x++)
                                                                {
                                                                    siMain.LockRange(i, list_EDIT_Week[x], i, list_EDIT_Week[x], true);                          
                                                                }
                                                            }
                                                            else if (cboBucketType.ControlValues == BucketType.Weekly)
                                                            {
                                                                                               
                                                                for (int x = 0; x < list_EDIT_Month.Count; x++)
                                                                {
                                                                    siMain.LockRange(i, list_EDIT_Month[x], i, list_EDIT_Month[x], true);                          
                                                                }
                                                            }
                                                        }
                                                        else
                                                        {
                                                            siMain.LockRange(i, j, i, siMain.GetMaxColumnIndex(), true);
                                                        }
                                                    }
                                                    else
                                                    {
                                                        siMain.LockRange(i, j, i, siMain.GetMaxColumnIndex(), true);
                                                    }
                                                }
                                                else
                                                {
                                                    siMain.LockRange(i, j, i, siMain.GetMaxColumnIndex(), true);
                                                }
                                            }
                                                                                                       
                                                                                                                        
                                            else if (((siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() == "40" || (clbDivision.ControlValues).Substring(0, 2) == "81")                               
                                                   && ((siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString() == "SalesAmt_LOC" && bEDIT_AUTH_SalesAmt_LOC)
                                                  || (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString().ToUpper() == "RTF_SYS_RP" && bEDIT_AUTH_RTF_SYS_RP)))                                                    
                                                  || ((siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() != "40" || (clbDivision.ControlValues).Substring(0, 2) == "81")                               
                                                  && ((siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString() == "SalesAmt_LOC" && bEDIT_AUTH_SalesAmt_LOC))))
                                                                                                     
                                            {                   
                                                if (cboBucketType.ControlValues == BucketType.Weekly && sValue.IndexOf("W_") == 0 || cboBucketType.ControlValues == BucketType.Monthly && sValue.IndexOf("M_") == 0)
                                                {
                                                    if (IsEditMode)
                                                    {                     
                                                                                                                                
                                                                                                                      

                                                                                
                                                        siMain.LockRange(i, j, i, siMain.GetMaxColumnIndex(), false);                                                     

                                                        if (cboBucketType.ControlValues == BucketType.Monthly)
                                                        {
                                                                                               
                                                            for (int x = 0; x < list_EDIT_Week.Count; x++)
                                                            {
                                                                siMain.LockRange(i, list_EDIT_Week[x], i, list_EDIT_Week[x], true);                          
                                                            }

                                                                                                                                               
                                                            if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString().ToUpper() == "RTF_SYS_RP")
                                                            {
                                                                for (int x = 0; x < list_EDIT_Month.Count; x++)
                                                                {                      
                                                                    if (int.Parse(sPeriod[0].Substring(0, 6)) <= Convert.ToUInt32(DateTime.Now.ToString("yyyyMM")))
                                                                    {
                                                                        if (Convert.ToUInt32(siMain.GetColumnTag(list_EDIT_Month[x]).Replace("M_", "").Substring(0, 6)) < Convert.ToUInt32(DateTime.Now.AddMonths(1).ToString("yyyyMM")))
                                                                        {
                                                                            siMain.LockRange(i, list_EDIT_Month[x], i, list_EDIT_Month[x], true);
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                                                                                                             
                                                        }
                                                        else if (cboBucketType.ControlValues == BucketType.Weekly)
                                                        {
                                                                                           
                                                            for (int x = 0; x < list_EDIT_Month.Count; x++)
                                                            {
                                                                siMain.LockRange(i, list_EDIT_Month[x], i, list_EDIT_Month[x], true);                          
                                                            }
                                                        }
                                                        else
                                                        {
                                                            siMain.LockRange(i, j, i, siMain.GetMaxColumnIndex(), true);
                                                        }
                                                    }
                                                    else
                                                        siMain.LockRange(i, j, i, siMain.GetMaxColumnIndex(), true);
                                                }
                                                else
                                                {
                                                    siMain.LockRange(i, j, i, siMain.GetMaxColumnIndex(), true);
                                                }
                                            }
                                                                                                   
                                                                             
                                        }
                                    }
                                }
                            }
                        }
                    }
                    catch (Exception e)
                    {
                        throw e;
                    }
                }
                else if (cboBucketType.ControlValues == BucketType.Daily)
                {
                    MessageHelper.GMessageBox("MSG00361");
                    return;
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
                                                                                 


                      
                          
             
                       
                                                                              
        protected virtual void ExportExcel(int ignoreDepth = 1, bool RemoveActionCell = true, bool RemoveInvisibleCell = true)
        {

            ExcelOptionEx.Border = ExcelBorderOptionEx.All;
            GSCM.Windows.Forms.UI.ProgressForm prg = new GSCM.Windows.Forms.UI.ProgressForm();
            try
            {
                if (fps == null) return;
                StyleInfo siOld = fps.ActiveSheet.DefaultStyle;
                StyleInfo siOldColHeader = fps.ActiveSheet.ColumnHeader.DefaultStyle;

                string tmpSheetName = "";

                prg.Show();
                FpSpread spSpread = new FpSpread();              

                spSpread = fps;
                                                  

                             
                Object[] myarray = new Object[spSpread.Sheets.Count];
                spSpread.Sheets.CopyTo(myarray, 0);

                if (myarray.Length == 0)
                {
                    prg.Close();
                    return;
                }

                FpSpread sp = new FpSpread();
                sp.Sheets.Clear();

                SheetView sv = null;
                SheetView newSheet = null;
                FarPoint.Win.Spread.HideRowFilter f = null;
                SpreadInfo si = new SpreadInfo(sp);

                                                                        
                int FrozenColumnCount = 0;
                if (spSpread.ActiveSheet.FrozenColumnCount > 0 &&
                spSpread.ActiveSheet.Columns.Count > 0 &&
                spSpread.ActiveSheet.Columns[0].DataField.ToUpper() == "ACTION")
                {
                    FrozenColumnCount = spSpread.ActiveSheet.FrozenColumnCount - 1;
                }
                else
                    FrozenColumnCount = spSpread.ActiveSheet.FrozenColumnCount;

                string sFrozenColumnName = string.Empty;

                if (spSpread.ActiveSheet.Columns[FrozenColumnCount].Tag == null)
                {
                    sFrozenColumnName = spSpread.ActiveSheet.Columns[FrozenColumnCount].DataField.ToString();
                }
                else
                {
                    sFrozenColumnName = spSpread.ActiveSheet.Columns[FrozenColumnCount].Tag.ToString();
                }

                bool bFrozenCheck = false;

                for (int iSheetIndex = 0; iSheetIndex < spSpread.Sheets.Count; iSheetIndex++)
                {
                    if (spSpread.ActiveSheet.SheetName != ((SheetView)myarray[iSheetIndex]).SheetName) continue;
                    sv = (SheetView)myarray[iSheetIndex];

                    if (tmpSheetName != "")
                    {
                        tmpSheetName += ",";
                    }
                    tmpSheetName += string.IsNullOrEmpty(spSpread.ActiveSheet.SheetName) ? "" : spSpread.ActiveSheet.SheetName;

                    newSheet = (FarPoint.Win.Spread.SheetView)FarPoint.Win.Serializer.LoadObjectXml(typeof(FarPoint.Win.Spread.SheetView), FarPoint.Win.Serializer.GetObjectXml(sv, "CopySheet"), "CopySheet");
                                             
                    f = (FarPoint.Win.Spread.HideRowFilter)sv.RowFilter;

                                                    
                    string sText = string.Empty;
                    newSheet.ReferenceStyle = FarPoint.Win.Spread.Model.ReferenceStyle.A1;

                                          
                    for (int i = newSheet.ColumnCount - 1; i >= 0; i--)
                    {
                                                                       
                                      
                                                                              
                                                                              
                                                               
                                                                             
                                                   
                        if (newSheet.Columns[i].Visible == false)
                        {
                            newSheet.Columns.Remove(i, 1);
                        }
                        else if (RemoveActionCell == true && i == 0 && newSheet.Columns[i].DataField.ToUpper() == "ACTION")
                        {
                            newSheet.Columns.Remove(i, 1);
                        }
                        else if (RemoveInvisibleCell && newSheet.Columns[i].Width <= 0)
                        {
                            newSheet.Columns.Remove(i, 1);
                        }
                        else
                        {
                            if (newSheet.Columns[i].CellType != null)
                            {
                                if (newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.ComboBoxCellType")
                                {
                                    foreach (Row idx in newSheet.Rows)
                                    {
                                        sText = newSheet.Cells[idx.Index, i].Text;

                                        newSheet.Cells[idx.Index, i].CellType = new FarPoint.Win.Spread.CellType.TextCellType();
                                        newSheet.Cells[idx.Index, i].Text = sText;
                                    }
                                }
                                else if (newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.MultiColumnComboBoxCellType")
                                {
                                    foreach (Row idx in newSheet.Rows)
                                    {
                                        sText = newSheet.Cells[idx.Index, i].Text;

                                        newSheet.Cells[idx.Index, i].CellType = new FarPoint.Win.Spread.CellType.TextCellType();
                                        newSheet.Cells[idx.Index, i].Text = sText;
                                    }
                                }
                                else
                                {
                                    if (newSheet.Columns[i].Formula != string.Empty)
                                        newSheet.Columns[i].Formula = "";
                                }
                            }
                        }
                    }

                                       
                    for (int i = newSheet.RowCount - 1; i >= 0; i--)
                    {
                        if (newSheet.Rows[i].Visible == false || (f != null && f.IsRowFilteredOut(i)))
                        {
                            newSheet.Rows.Remove(i, 1);
                        }
                    }

                    int collen = newSheet.ColumnCount;
                    if (ignoreDepth > 0)
                    {
                        for (int i = 0; i < newSheet.RowCount; i++)
                        {
                            for (int j = 0; j < collen; j++)
                            {
                                if (newSheet.Cells[i, j].Value != null && newSheet.Cells[i, j].Value.ToString() == "-")
                                    newSheet.Cells[i, j].Value = null;
                            }
                        }
                    }

                    for (int iCol = newSheet.ColumnCount - 1; iCol >= 0; iCol--)
                    {
                        if (newSheet.Columns[iCol].Tag == null)
                        {
                            if (newSheet.Columns[iCol].DataField.ToString() == sFrozenColumnName)
                            {
                                newSheet.FrozenColumnCount = iCol;
                                bFrozenCheck = true;
                                break;
                            }
                        }
                        else
                        {
                            if (newSheet.Columns[iCol].Tag.ToString() == sFrozenColumnName)
                            {
                                newSheet.FrozenColumnCount = iCol + 1;
                                bFrozenCheck = true;
                                break;
                            }
                        }
                    }

                    sp.Sheets.Add(newSheet);

                    if (si != null)
                    {
                        switch (ExcelOption)
                        {
                            case ExcelExportOption.Casecaded:
                                if (newSheet.FrozenColumnCount > 0)
                                    si.MaxRightMerge = newSheet.FrozenColumnCount;
                                                         
                                si.RightColMerge(true);
                                break;
                            case ExcelExportOption.SeperatedRows:
                                     
                            case ExcelExportOption.None:
                                si.UnMerge(newSheet);
                                break;
                        }
                    }
                }
                StyleInfo siNew = new StyleInfo(siOld);
                if (ExcelOptionEx.Border == ExcelBorderOptionEx.All)
                {
                    siNew.Border = new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true);
                }
                else if (ExcelOptionEx.Border == ExcelBorderOptionEx.None)
                {
                    siNew.Border = new FarPoint.Win.LineBorder(Color.Black, 0, true, true, true, true);
                }
                else if (ExcelOptionEx.Border == ExcelBorderOptionEx.Right)
                {
                    siNew.Border = new FarPoint.Win.LineBorder(Color.Black, 1, false, false, true, false);
                }

                newSheet.DefaultStyle = siNew;

                StyleInfo siNewColHeader = new StyleInfo(siOldColHeader);

                siNewColHeader.Border = new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true);

                newSheet.ColumnHeader.DefaultStyle = siNewColHeader;

                if (!bFrozenCheck)
                    newSheet.FrozenColumnCount = 0;

                sp.TabStripPolicy = TabStripPolicy.Always;

                            
                for (int iSheetIndex = 0; iSheetIndex < sp.Sheets.Count; iSheetIndex++)
                {
                    sp.Sheets[iSheetIndex].Protect = false;
                }

                string sFrmName = this.Name.ToString();
                string sFileName = string.Empty;
                                                                                                       
                                                                                                                                                                                           
                sFileName = Application.StartupPath + "\\" + this.Name.ToString() + "(" + newSheet.SheetName.Replace("/", "") + ")_" + DateTime.Now.ToString("yyyyMMddHHmmss") + ".xlsx";
                                                                                                             
                                                                                                                                             
                sp.SaveExcel(sFileName, gesfDefaultExeclSaveFlg | FarPoint.Excel.ExcelSaveFlags.UseOOXMLFormat);

                                       
                                                                  

                System.Diagnostics.Process.Start(sFileName);

            }
            catch (Exception e)
            {
                                           
                MessageHelper.GMessageBox("MSG00003", new object[] { e.Message });
            }
            finally
            {
                prg.Close();
            }
        }
                                                                                                                        

        #endregion

        #region 5. Logic

                                                                                                                  
        DataSet dsMain = null;

        private new async void FindData(bool blnInsert, int iUpdateRow = 0, int iUpdateCol = 0)
        {

            GSCM.Windows.Forms.UI.ProgressForm prg = new GSCM.Windows.Forms.UI.ProgressForm();

            try
            {
                                                                 
                             
                               
                    
                                                             
                              
                    
                            
                                  
                                                               

                         
                System.DateTime thisWeekDate;
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

                string sNowDate = GetThisWeekMonday(out thisWeekDate);
                if (drpPeriod.Value1.CompareTo(thisWeekDate) >= 0)
                    sNowDate = sStartDate;
                if (Convert.ToInt32(sEndDate).CompareTo(Convert.ToInt32(sNowDate)) < 0)
                    sNowDate = Convert.ToDateTime(drpPeriod.Value2).AddDays(1).ToString("yyyyMMdd");

                         
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

                                         
                string[][] sQtyFormat2 = new string[300][];

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
                        var request = new FoxDataRequest("DM.DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx");
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
                    DataTable dt = new DataTable();
                    dt = ds.Tables[0];
                    dt.AcceptChanges();
                    siMain.Query(dt);
                    siMain.LockColumn(0, siMain.GetMaxColumnIndex(), true);
                }

                                                 
                siMain.SmartColMerge();

                                                                     

                                              
                SearchEndTime();

                                                                                                                          
                                           
                dsMain = ds;
                Draw();

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
                                                           
                                   

                                        
                if (this.Visible)
                    throw ex;
            }
            finally
            {   
                                                           
                                   
                prg.Close();
                                                      
            }
        }
                                                                                                                          
        void Draw()
        {
            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);
            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);
            string[] sPeriod = drpPeriod.ControlValues.Split(':');
            string sStartDate = drpPeriod.Value1.ToString("yyyyMMdd");

            DataSet ds = dsMain;
            siMain.SpreadObject.SuspendLayout();

            Boolean flag = false;
            if (iso_week == "")
                flag = true;

            int colidx = ds.Tables[0].Columns["SORT_ORDER_NO"].Ordinal;
            string column_data_start = ds.Tables[0].Columns[colidx + 1].ColumnName;
            int a_col_pos = siMain.GetColumnIndex("SORT_ORDER_NO");
            int b_col_pos = siMain.GetColumnIndex(column_data_start);

            try
            {
                int data_start_pos = b_col_pos;
                if (data_start_pos < 0)
                {
                                                                            
                    return;
                }

                                                        
                int maxRow = ds.Tables[0].Rows.Count;
                int maxCol = siMain.GetMaxColumnIndex();

                string[] colnames = new string[maxCol - data_start_pos];
                string[] rNotation = new string[maxRow];

                int[] rMeasureType = new int[maxRow];

                for (int j = data_start_pos; j < maxCol; j++)
                {
                    colnames[j - data_start_pos] = siMain.GetColumnTag(j);

                    for (int i = 0; i < maxRow; i++)
                    {
                        if (siMain.GetColumnIndex(siMain.GetColumnTag(j)) == -1 || !ds.Tables[0].Columns.Contains(siMain.GetColumnTag(j)))
                        {
                                             
                                                                                           
                                                                                                                        
                            continue;
                        }

                        rNotation[i] = ds.Tables[0].Rows[i]["NOTATION"].String().ToUpper();

                                                                 
                        string Val = ds.Tables[0].Rows[i][siMain.GetColumnTag(j)].ToString();

                        if (Val == "" || rNotation[i] == "DEFAULT")
                        {
                                                                                      
                        }
                        else
                        {
                            switch (rNotation[i])
                            {
                                case "INTEGER":
                                    rMeasureType[i] = 1;              
                                    break;
                                case "POINT":
                                    rMeasureType[i] = 2;              
                                    break;
                                case "POINT3":
                                    rMeasureType[i] = 3;                  
                                    break;
                            }

                                               
                            switch (rMeasureType[i])
                            {
                                      
                                case 1:
                                                                       
                                    if (Val.Substring(0, 1) == "0" && Val.IndexOf('.') != 0 && Val.Substring(Val.IndexOf('.') + 1, 3) == "000")
                                        siMain.SetRowFormat(i, j, maxCol - data_start_pos, "###,###,###,##0");
                                    else
                                        siMain.SetRowFormat(i, j, maxCol - data_start_pos, "###,###,###,###");
                                    break;
                                            
                                                                                
                                case 2:
                                                                          
                                    if (Val == "0.000")
                                        siMain.SetRowFormat(i, j, maxCol - data_start_pos, "###,###,###,##0");
                                                                                           
                                    else if (Val.Substring(0, 1) == "0" && (Val.Length - Val.IndexOf('.') + 1 > 0))
                                        siMain.SetRowFormat(i, j, maxCol - data_start_pos, "0.###");
                                                                       
                                    else if (Val.IndexOf('.') + 1 == 0)
                                        siMain.SetRowFormat(i, j, maxCol - data_start_pos, "###,###,###,###");
                                                                           
                                    else if (Val.Length - Val.IndexOf('.') + 1 > 0)
                                        siMain.SetRowFormat(i, j, maxCol - data_start_pos, "###,###,###,###.###");
                                    break;
                                               
                                                                     
                                case 3:
                                                                         
                                    if (Val == "0.000")
                                        siMain.SetRowFormat(i, j, maxCol - data_start_pos, "###,###,###,##0");
                                                                                            
                                    else if (Val.Substring(0, 1) == "0" && (Val.Length - Val.IndexOf('.') + 1 == 1))
                                        siMain.SetRowFormat(i, j, maxCol - data_start_pos, "0.#00");
                                                                                           
                                    else if (Val.Substring(0, 1) == "0" && (Val.Length - Val.IndexOf('.') + 1 == 2))
                                        siMain.SetRowFormat(i, j, maxCol - data_start_pos, "0.##0");
                                                                                 
                                    else if (Val.Substring(0, 1) == "0" && (Val.Length - Val.IndexOf('.') + 1 == 3 || Val.Length - Val.IndexOf('.') + 1 > 3))
                                        siMain.SetRowFormat(i, j, maxCol - data_start_pos, "0.###");
                                                                               
                                    else if (Val.Length - Val.IndexOf('.') + 1 == 1)
                                        siMain.SetRowFormat(i, j, maxCol - data_start_pos, "###,###,###,###.#00");
                                                                              
                                    else if (Val.Length - Val.IndexOf('.') + 1 == 2)
                                        siMain.SetRowFormat(i, j, maxCol - data_start_pos, "###,###,###,###.##0");
                                                                    
                                    else if (Val.Length - Val.IndexOf('.') + 1 == 3 || Val.Length - Val.IndexOf('.') + 1 > 3)
                                        siMain.SetRowFormat(i, j, maxCol - data_start_pos, "###,###,###,###.###");
                                    break;
                                                        
                            }
                        }
                    }
                }
            }
            catch (Exception error)
            {
                int m = 0;
            }

            int iResultCol = siMain.GetColumnIndex(DefColumns.MEASURE) + 1;
            int iResultMonth = siMain.GetColumnIndex(DefColumns.MEASURE);

                          
            if (ds.Tables.Count > 1 && ds.Tables[1].Rows.Count > 0)
            {
                this_YYYYMM = ds.Tables[1].Rows[0]["THIS_YYYYMM"].ToString();
                this_YYYYMMWW = ds.Tables[1].Rows[0]["THIS_YYYYMMWW"].ToString();
                pre_YYYYMM = ds.Tables[1].Rows[0]["PRE_YYYYMM"].ToString();
                pre_YYYYMMWW = ds.Tables[1].Rows[0]["PRE_YYYYMMWW"].ToString();
                weekDate = Convert.ToDateTime(ds.Tables[1].Rows[0]["BASIS_DATE"].ToString());
                basis_YYYYMM = ds.Tables[1].Rows[0]["BASIS_YYYYMM"].ToString();
                iso_week = ds.Tables[1].Rows[0]["ISO_WEEK"].ToString();
            }

            if (sResult_YYYYMMDD.Substring(0, 6) != basis_YYYYMM)
            {
                sResult_YYYYMMWW = "W_" + sResult_YYYYMMDD.Substring(0, 6) + iso_week;
            }

                                                          
            if (int.Parse(sStartDate.Substring(0, 6)) >= int.Parse(this_YYYYMM.Substring(2)))
            {
                iResultMonth = iResultMonth + 1;
            }

                                                                          
            int iTotalRowCount = siMain.GetMaxRowIndex();                                        
            int iTotalColCount = siMain.GetMaxColumnIndex();                                          
            int iStartColPosition = siMain.GetColumnIndex(DefColumns.MEASURE) + 1;

            for (int i = 0; i <= iTotalRowCount; i++)
            {
                if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) > 0)
                {
                    siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType = cellTypeImage;
                }

                if (siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID) != -1)
                {
                    siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID)].VerticalAlignment = CellVerticalAlignment.Center;                                  
                }
            }
            if (chkColor.Checked == true)
            {
                for (int iCol = siMain.GetColumnIndex(DefColumns.MEASURE) + 1; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                {
                    if (cboBucketType.ControlValues == BucketType.Daily)
                    {
                        if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0)
                        {
                            if (int.Parse(sResult_YYYYMMDD) > int.Parse(siMain.GetColumnTag(iCol).Replace("D_", "")))
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
            else if (chkColor.Checked == false)
            {
                FarPoint.Win.BevelBorder bevelbrdr = new FarPoint.Win.BevelBorder(FarPoint.Win.BevelBorderType.Raised, Color.Green, Color.Green, 3, true, false, false, false);
                if (cboBucketType.ControlValues != BucketType.Daily)
                {
                    if (siMain.GetColumnIndex(this_YYYYMMWW) > 0 || siMain.GetColumnIndex(sResult_YYYYMMWW) > 0)
                    {
                                                                                                     
                        if (siMain.GetColumnIndex(this_YYYYMMWW) > 0)
                            siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border = bevelbrdr;
                        else
                            siMain.ActiveSheet.Columns[siMain.GetColumnIndex(sResult_YYYYMMWW)].Border = bevelbrdr;
                    }
                }
                else if (cboBucketType.ControlValues == BucketType.Daily)
                {
                    if (siMain.GetColumnIndex("D_" + sResult_YYYYMMDD) > 0)
                        siMain.ActiveSheet.Columns[siMain.GetColumnIndex("D_" + sResult_YYYYMMDD)].Border = bevelbrdr;
                }
            }


            siMain.SpreadObject.SuspendLayout();
            SetSpreadColumn();
        }
                                                                                                                        
        private async void SaveData()
        {
            try
            {
                                    
                bool blnInsert = false;

                                                                   
                             
                               
                    
                                                               
                                                                                 
                              
                    
                            
                                  
                                                                 

                                   
                if (siMain != null && siMain.IsLock(siMain.SheetName) == true)
                    return;

                if (siMain.SheetName == SpdSheet.shtMain)
                {
                                                                                
                                                                                
                    string sProcedureName = "DM.DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL";

                                                                                            
                                       
                                            
                    string stempAction = string.Empty;                                            
                    string sDivisionId = string.Empty;                   
                    string sProjectCode = string.Empty;                  
                    string sScmSiteId = string.Empty;                     
                    string sPlantSiteId = string.Empty;                     
                    string sItemId = string.Empty;               
                    string sText = string.Empty;            
                    string sCurrency = string.Empty;                
                    string sMeasure = string.Empty;               
                    string sDomExp = string.Empty;               

                    string sFcstType = string.Empty;                 
                    string sIncoterms = string.Empty;                 
                    string sTeamId = string.Empty;            
                    string sDeptId = string.Empty;               
                    string sCellProdSiteId = string.Empty;                         
                    string sYYYYMMDD = string.Empty;               
                    string sPrice = string.Empty;             
                    string sUserId = string.Empty;               
                    string sEndCustomer = string.Empty;                               
                                          
                                              
                    string ptempAction = string.Empty;                                            
                    string pDivisionId = string.Empty;                   
                    string pProjectCode = string.Empty;                  
                    string pScmSiteId = string.Empty;                     
                    string pPlantSiteId = string.Empty;                     
                    string pItemId = string.Empty;               
                    string pText = string.Empty;            
                    string pDomExp = string.Empty;               
                    string pFcstType = string.Empty;                 
                    string pIncoterms = string.Empty;                 

                    string pMeasure = string.Empty;               
                    string pYYYYMMDD = string.Empty;               
                    string pPrice = string.Empty;             
                    string pCurrency = string.Empty;                
                    string pUserId = string.Empty;               
                    string pDeptId = string.Empty;               
                    string pCellProdSiteId = string.Empty;                         
                                            

                    string sMsg = string.Empty;               
                                                                                                                          

                                                                                                                                                      
                                               
                                                                                                                                                      
                                                               
                                                                                           
                                                                                                                                        
                        
                                      
                                                                                                                                              
                                                                                       
                    if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) == -1
                    || (CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) != "40" && siMain.GetColumnIndex(DefColumns.PROJECT_CODE) == -1)                             
                    || (CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) == "40" && siMain.GetColumnIndex(DefColumns.END_CUSTOMER40) == -1)                                     
                    || (CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) != "40" && siMain.GetColumnIndex(DefColumns.END_CUSTOMER) == -1)                                                            
                    || siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) == -1
                    || siMain.GetColumnIndex(DefColumns.ITEM_ID) == -1
                    || (CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues).Substring(0, 2) == "81" && siMain.GetColumnIndex(DefColumns.TEXT) == -1)                                  
                                                                        
                    || siMain.GetColumnIndex(DefColumns.FcstType) == -1
                    || siMain.GetColumnIndex(DefColumns.INCOTERMS) == -1
                    || siMain.GetColumnIndex(DefColumns.MEASURE) == -1
                    || siMain.GetColumnIndex(DefColumns.CURRENCY) == -1
                    || (CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) == "40" && siMain.GetColumnIndex(DefColumns.DEPT_ID) == -1)                             
                                                                         
                                                                                                                                                         
                    || (CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) == "40" && siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID) == -1)                                                
                    || (CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues).Substring(0, 2) == "81" && siMain.GetColumnIndex(DefColumns.FromSiteId) == -1)                                              
                    || (CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues).Substring(0, 2) == "81" && siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID) == -1)                                               
                    )
                    {
                        MessageHelper.GMessageBox("MSG00113");             
                        return;
                    }
                                 
                    for (int i = 0; i <= siMain.GetMaxRowIndex(); i++)
                    {
                        string action = siMain.GetText(i, 0);

                        if (action == CAppSetting.FlagI)
                            blnInsert = true;

                        if (action != CAppSetting.FlagI && action != CAppSetting.FlagM && action != CAppSetting.FlagD)
                            continue;

                                                                                                 
                                                    
                                                   
                                                  
                                                     
                                              
                                           
                                               
                                              
                                             
                                               
                                                
                                                      
                                                                            

                        sEndCustomer = "";
                        sDeptId = "";
                        sDivisionId = "";
                        sProjectCode = "";
                        sScmSiteId = "";
                        sPlantSiteId = "";
                        sItemId = "";
                        sText = "";
                        sCurrency = "";
                        sMeasure = "";

                        sDomExp = "";
                        sFcstType = "";
                        sIncoterms = "";
                        sCellProdSiteId = "";
                        sMsg = "";
                                                                                              

                                                          
                                                                                                                   

                        if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER40) != -1)
                        {                                                                                 
                                                                                                                       
                            sEndCustomer = siMain.GetText(i, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40));
                                                                                                        
                        }
                        if (siMain.GetColumnIndex(DefColumns.DEPT_ID) != -1)
                        {                                                                                           
                                                                                                        
                            sDeptId = siMain.GetText(i, siMain.GetColumnIndex(DefColumns.DEPT_ID));
                                                                                                                  
                        }
                                                        

                        if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) != -1)
                                                                                                    
                                                                                                                        
                            sDivisionId = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID));
                                                                                              

                        if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) != -1)
                        {
                                                                                                      
                                                                                                                 
                                                     
                                                      
                            sProjectCode = siMain.GetText(i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE));
                            if (sProjectCode == "")
                                sProjectCode = "N";
                                                                                                    
                        }

                        if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) != -1)
                                                                                                   
                            sScmSiteId = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID));
                                                                                             
                        if (siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID) != -1)
                                                                                                              
                                                                                                                             
                            sPlantSiteId = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID));
                                                                                                        
                        if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                                                                                            
                                                                                                                
                            sItemId = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_ID));
                                                                                          
                        if (siMain.GetColumnIndex(DefColumns.TEXT) != -1)
                                                                                       
                                                                                                          
                            sText = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.TEXT));
                                                                                 
                        if (siMain.GetColumnIndex(DefColumns.CURRENCY) != -1)
                                                                                               
                                                                                                                                                                 
                            sCurrency = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CURRENCY));                                                
                                                                                                                                                                                
                        if (siMain.GetColumnIndex(DefColumns.MEASURE) != -1)
                                                                                             
                                                                                                                
                            sMeasure = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MEASURE));
                                                                                       
                        if (siMain.GetColumnIndex(DefColumns.DomExp) != -1)
                            sDomExp = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DomExp));                                                
                        if (siMain.GetColumnIndex(DefColumns.FcstType) != -1)
                            sFcstType = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.FcstType));                                                
                        if (siMain.GetColumnIndex(DefColumns.INCOTERMS) != -1)
                                                                                                 
                                                                                                                                                                   
                            sIncoterms = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.INCOTERMS));                                                
                                                                                                                                                                                    
                        if (siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID) != -1)                                                 
                                                                                                      
                                                                                                                                 
                            sCellProdSiteId = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID));
                                                                                                
                                                                             
                        if (siMain.GetColumnIndex(DefColumns.FromSiteId) != -1)  
                            sCellProdSiteId = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.FromSiteId));
                                                                           

                                                                                                
                                                                    
                                                                                                                                  
                                                                                                                 
                                                                                                        
                                                                                                                                                              
                                                                                                                      
                                                                                      
                                                      
                                                                                 
                                                                                                                                              
                                                                                                                                                
                                                                                                                                                 
                                                                                                                             
                              
                          
                                              
                                                    
                                                       
                                                                                                                 
                                                           
                                                      
                                                       
                                                                                            
                                                         
                                                     
                                                    
                                                     
                                                      
                                                                                                                              
                                                    
                                                                                                                       
                                                           
                                                                                                              
                                                                                                                                                                    
                                                   
                                                                                                                                                   
                                                                
                                                                                                                                                     
                                                       
                                                                                                                                                      
                                                        
                                                                                    
                                                            
                                                        

                                      
                                                                  
                        if (sDivisionId == "" || (sDivisionId != "40" && sProjectCode == "") ||                                
                           (sDivisionId == "40" && sEndCustomer == "") ||                                                                                                               
                           (sDivisionId == "40" && sDeptId == "" && sMeasure != "Catch_Up") ||                                                             
                           (sDivisionId.Substring(0, 2) == "81" && sText == "") ||                                    
                            sScmSiteId == "" ||                                                                
                            sItemId == "" || sMeasure == "" || sCurrency == "" ||
                           (sDivisionId == "40" && sMeasure == "Catch_Up" && sDomExp == "") ||                                              
                           (sDivisionId == "40" && sMeasure == "Catch_Up" && sFcstType == "") ||                                              
                           (sDivisionId == "40" && sMeasure == "Catch_Up" && sIncoterms == "") ||                                              
                           (sDivisionId == "40" && sCellProdSiteId == ""))                                                  
                        {
                            if (sDivisionId == "")
                                sMsg += "[Division],";
                            else if (sDivisionId != "40" && sProjectCode == "")                                
                                sMsg += "[Project Code],";
                            else if (sCurrency == "")
                                sMsg += "[Currency],";
                            else if (sScmSiteId == "")                                    
                                sMsg += "[Sales_Site],";
                            else if (sItemId == "")
                                sMsg += "[Model],";
                            else if (sMeasure == "")
                                sMsg += "[Measure],";
                            else if (sDivisionId.Substring(0, 2) == "81" && sText == "")                                     
                                sMsg += "[TEXT],";
                            else if (sDivisionId == "40" && sEndCustomer == "")                                  
                                sMsg += "[END_CUSTOMER],";
                                                                                                              
                            else if (sDivisionId == "40" && sDeptId == "" && sMeasure != "Catch_Up")                                                             
                                sMsg += "[TEAM],";
                            else if (sDivisionId == "40" && sMeasure == "Catch_Up" && sDomExp == "")                                              
                                sMsg += "[Customer Handbook],";
                            else if (sDivisionId == "40" && sMeasure == "Catch_Up" && sFcstType == "")                                              
                                sMsg += "[FcstType],";
                            else if (sDivisionId == "40" && sMeasure == "Catch_Up" && sIncoterms == "")                                              
                                sMsg += "[INCOTERMS],";
                            else if (sDivisionId == "40" && sCellProdSiteId == "")
                                sMsg += "[CellProdSiteID]";
                            sMsg = sMsg.TrimEnd(',');
                                                                                                  

                            MessageHelper.GMessageBox("MSG00002", new object[] { sMsg });                                                                                                                                                         
                                              

                                            
                            siMain.SpreadObject.ActiveSheet.SetActiveCell(i, 2);

                            return;
                        }

                                                     
                                                                                
                                               
                          
                                                                      
 
                                                                                   
                                                      
                              
                                                          
                              
                                 
                              
                                                          
                              
                                                                                   
 
                                                                                                   
 
                                                                                                                   
                                    
                          
                          
                                                                              
                    }
                                                                                                                                                      
                                             
                                                                                                                                                      

                                                                                                                                                      
                                               
                                                                                                                                                      
                                          
                                          
                    int iCUD = 0;
                    int iUpdateRow = 0;
                    int iDateCount = 0;
                    NameValueCollection nvc = new NameValueCollection();
                    for (int i = 0; i <= siMain.GetMaxRowIndex(); i++)
                    {
                        string action = siMain.GetText(i, 0);

                        if (action != CAppSetting.FlagI && action != CAppSetting.FlagM && action != CAppSetting.FlagD)
                            continue;

                                                                                              
                                                                                             
                                                  
                                                   
                                                  
                                                    
                                              
                                           
                                               
                                               
                                               
                                                 
                                                
                                              
                                              
                                                                                                         

                        sDivisionId = "";
                        sProjectCode = "";
                        sScmSiteId = "";
                        sPlantSiteId = "";
                        sItemId = "";
                        sText = "";
                        sCurrency = "";
                        sMeasure = "";
                        sDomExp = "";
                        sIncoterms = "";

                        sTeamId = "";
                        sDeptId = "";
                        sYYYYMMDD = "";
                        sCellProdSiteId = "-";                                                  
                        sPrice = "";
                        stempAction = "";
                        sFcstType = "";
                                                                                              

                        if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) != -1)
                                                                                                    
                                                                                                                        
                            sDivisionId = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID));
                                                                                              

                                                                                                                               
                                                                                   
                          
                                                                                      
                                                                                                                   
                                                     
                                                     
                           
                        if (sDivisionId != "40")                                
                        {
                            if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) != -1)
                                sProjectCode = siMain.GetText(i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE));
                            if (sProjectCode == "")
                                sProjectCode = "N";
                        }
                                                                                                                             
                        else
                        {                                                                             
                                                                                                                                                                    
                            sProjectCode = siMain.GetText(i, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40));                                                  
                                                                                                    
                        }

                        if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) != -1)
                                                                                                   
                                                                                                                        
                            sScmSiteId = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID));
                                                                                             
                        if (siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID) != -1)
                                                                                                       
                                                                                                                            
                            sPlantSiteId = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID));
                                                                                                 
                        if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                                                                                            
                                                                                                                
                            sItemId = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_ID));
                                                                                      

                                                              
                                                                           
                                              
                                                                                                
                                                                    
                        if (sDivisionId.Substring(0, 2) == "81")
                                                                                              
                        {
                            if (siMain.GetColumnIndex(DefColumns.TEXT) != -1)
                            {                                                               
                                                                                                              
                                sText = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.TEXT));
                                                                                          
                            }
                        }
                        else
                        {
                            if (siMain.GetColumnIndex(DefColumns.TEXT4082) != -1)
                            {                                                               
                                                                                                                  
                                sText = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.TEXT4082));
                                                                                          
                            }
                        }

                        if (siMain.GetColumnIndex(DefColumns.CURRENCY) != -1)
                                                                                                
                                                                                                                  
                            sCurrency = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CURRENCY));
                                                                                          
                        if (siMain.GetColumnIndex(DefColumns.MEASURE) != -1)
                                                                                               
                                                                                                                                                                   
                            sMeasure = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString();                                                
                                                                                                                                                                                 
                        if (siMain.GetColumnIndex(DefColumns.DomExp) != -1)
                                                                                              
                                                                                                                
                            sDomExp = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DomExp));
                                                                                        
                        if (siMain.GetColumnIndex(DefColumns.FcstType) != -1)
                                                                                                  
                                                                                                                    
                            sFcstType = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.FcstType));
                                                                                            
                        if (siMain.GetColumnIndex(DefColumns.INCOTERMS) != -1)
                                                                                                  
                                                                                                                    
                            sIncoterms = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.INCOTERMS));
                                                                                            
                        if (siMain.GetColumnIndex(DefColumns.TEAM_ID) != -1)
                                                                                             
                                                                                                                
                            sTeamId = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.TEAM_ID));
                                                                                       

                                                          
                        if (siMain.GetColumnIndex(DefColumns.DEPT_ID) != -1)
                                                                                             
                                                                                                                
                            sDeptId = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DEPT_ID));
                                                                                       
                                                          

                                                                         
                        if (siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID) != -1)
                                                                                                            
                                                                                                                                 
                            sCellProdSiteId = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID));
                                                                                                      

                                                                             
                        if (siMain.GetColumnIndex(DefColumns.FromSiteId) != -1)
                            sCellProdSiteId = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.FromSiteId));
                                                                           

                                                                         
                           
                                                
                          
                                                              
                                                                                       
                                       
                                                                                          
                                    
                          
                                             
                          
                                                              
                                                                                    
                                       
                                                                                          
                                    
                          
                          

                                                                                            
                                               
                        if (sCurrency == "")
                                                                                          
                        {
                            string args = string.Format("{0}", MessageHelper.GetTerm(DefColumnsLabel.CURRENCY));
                            MessageHelper.GMessageBox("MSG00002", new object[] { args });                   
                            return;
                        }

                                                     
                                                                                                          
                        sBucket = cboBucketType.ControlValues;

                        for (int j = siMain.GetColumnIndex(DefColumns.MEASURE) + 1; j <= siMain.GetMaxColumnIndex(); j++)
                        {                                            

                                                                                      
                            if (siMain.GetColumnIndex(DefColumns.DEPT_ID) != -1)
                            {
                                var TeamCellColor = GetCellColor(siMain, i, siMain.GetColumnIndex(DefColumns.DEPT_ID), i, siMain.GetColumnIndex(DefColumns.DEPT_ID));

                                                                          
                                if (TeamCellColor == System.Drawing.Color.Red)
                                {
                                    if (cboBucketType.ControlValues == BucketType.Daily)
                                    {
                                                                             
                                    }
                                    else if (cboBucketType.ControlValues == BucketType.Weekly)
                                    {
                                        if (siMain.GetColumnTag(j).IndexOf("W_") == 0)
                                        {
                                            siMain.SetColor(i, j, i, j, System.Drawing.Color.Red, false);             
                                        }
                                    }
                                    else if (cboBucketType.ControlValues == BucketType.Monthly)
                                    {
                                        if (siMain.GetColumnTag(j).IndexOf("M_") == 0)
                                        {
                                            siMain.SetColor(i, j, i, j, System.Drawing.Color.Red, false);             
                                        }
                                    }
                                }
                            }
                                                                                    

                                                                                     
                            if (siMain.GetColumnTag(j).IndexOf("D_") == 0)
                            {
                                continue;
                            }
                                                                                   

                                                             
                            var vColor = GetCellColor(siMain, i, j, i, j);
                            if (vColor != System.Drawing.Color.Red)
                                continue;

                                                                                                            
                                                                                  
                            if (cboBucketType.ControlValues == BucketType.Weekly && siMain.GetColumnTag(j).IndexOf("M_") == 0)
                            {
                                                           
                                continue;
                            }
                            else if (cboBucketType.ControlValues == BucketType.Monthly && siMain.GetColumnTag(j).IndexOf("W_") == 0)
                            {
                                                            
                                continue;
                            }
                                                                                                           

                                                                                               
                                                                                    
                            sYYYYMMDD = siMain.GetColumnTag(j).ToString();
                                                                                      
                                                                                             

                                                                                               
                                                                                       
                            sPrice = Convert.ToString(siMain.GetValue(i, j));
                                                                                               

                                             
                                                                                          
                                                
                            if (sPrice == "")
                                                                                            
                                                                                     
                                                                  
                                sPrice = "0" ;
                                            
                                                                                   

                                                                                               
                                                           
                            stempAction = action;
                                                                                             
                            if (action != "D")
                            {
                                                                                              
                                                     
                                if (sPrice == "0")
                                                                                                
                                    stempAction = "D";
                            }

                                                                                  
                                                                                                                            
                                                                                   
                            if (sDivisionId == "40" && sMeasure == "Catch_Up")
                                                                                                                          
                            {

                                                                                              
                                                                    
                                if (Convert.ToDouble(sPrice) < 0)
                                                                                            
                                {
                                                           
                                    MessageHelper.GMessageBox("MSG00085", new object[] { "0" });
                                    return;
                                }
                            }
                                                                                  

                                                                                              
                                                                                                                      
                                                                                                                     
                                                                                                                        
                                                                                                                     
                                                                                                                           
                                                                                                         
                                                                                                
                                                                                                          
                                                                                                                
                                                                                                               
                                                                                                          
                                                                                                            
                                                                                               
                                                                                                            
                                                                                                                                     
                                                                                                                                               
                                                              
                                                                                                         
                                                              
                                                                                     
                                                                                                                                    
                                                                                     

                                                                                  
                            if (iDateCount > 0)
                            {
                                ptempAction += "^" + stempAction;
                                pDivisionId += "^" + sDivisionId;
                                pProjectCode += "^" + sProjectCode;
                                pScmSiteId += "^" + sScmSiteId;
                                pPlantSiteId += "^" + sPlantSiteId;
                                pItemId += "^" + sItemId;
                                pText += "^" + sText;
                                pDomExp += "^" + sDomExp;
                                pFcstType += "^" + sFcstType;
                                pIncoterms += "^" + sIncoterms;
                                pMeasure += "^" + sMeasure;
                                pYYYYMMDD += "^" + sYYYYMMDD;
                                pPrice += "^" + sPrice;
                                pCurrency += "^" + sCurrency;
                                pUserId += "^" + UserInfoContext.Current.UserId;
                                pDeptId += "^" + sDeptId;
                                pCellProdSiteId += "^" + sCellProdSiteId;
                            }
                            else
                            {
                                ptempAction = stempAction;
                                pDivisionId = sDivisionId;
                                pProjectCode = sProjectCode;
                                pScmSiteId = sScmSiteId;
                                pPlantSiteId = sPlantSiteId;
                                pItemId = sItemId;
                                pText = sText;
                                pDomExp = sDomExp;
                                pFcstType = sFcstType;
                                pIncoterms = sIncoterms;
                                pMeasure = sMeasure;
                                pYYYYMMDD = sYYYYMMDD;
                                pPrice = sPrice;
                                pCurrency = sCurrency;
                                pUserId = UserInfoContext.Current.UserId;
                                pDeptId = sDeptId;
                                pCellProdSiteId = sCellProdSiteId;
                            }
                                                                                

                            iDateCount++;
                        }

                        if (iDateCount == 0)
                        {
                                                           
                            MessageHelper.GMessageBox("MSG00146", new object[] { i + 1 });
                            return;
                        }
                        else
                        {
                            iUpdateRow = i;
                            iCUD++;
                        }
                    }
                                                                                       
                    if (iCUD > 0)
                    {
                        try
                        {
                            var asyncProxy = new FoxAsyncProxy(this);
                            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
                            {
                                var request = new FoxDataRequest(sProcedureName);

                                request.Parameters["p_active_flag"] = ptempAction;
                                request.Parameters["p_division_id"] = pDivisionId;
                                request.Parameters["p_project_code"] = pProjectCode;
                                request.Parameters["p_scm_site_id"] = pScmSiteId;
                                request.Parameters["p_plant_site_id"] = pPlantSiteId;
                                request.Parameters["p_item_id"] = pItemId;
                                request.Parameters["p_dom_exp"] = pDomExp;
                                request.Parameters["p_fcst_type"] = pFcstType;
                                request.Parameters["p_incoterms"] = pIncoterms;
                                request.Parameters["p_measure"] = pMeasure;
                                request.Parameters["p_yyyymmdd"] = pYYYYMMDD;
                                request.Parameters["p_qty"] = pPrice;
                                request.Parameters["p_currency"] = pCurrency;
                                request.Parameters["p_created_by"] = pUserId;
                                request.Parameters["p_last_updated_by"] = pUserId;
                                request.Parameters["p_text"] = pText;
                                request.Parameters["p_dept_id"] = pDeptId;
                                request.Parameters["p_cell_prod_site_id"] = pCellProdSiteId;

                                request.CommandTimeout = 10 * 60;

                                var response = client.ExecuteDataSet(request);
                                                                                                 

                                                                                             
                                                                                                                                                 
                                                                                                                                               
                                                                                           

                                                                                                                        
                                            
                                                                                          
                                string sResultMsg = response.DataSet.Tables[0].Rows[0][0].ToString();
                                                                                                                      
                                if (sResultMsg != "success")
                                {                                                  
                                       
                                                                 
                                                                                                                                           
                                      
                                                 
                                                                            
                                                                                                    
                                                                                                                                                                         
                                                                                                                                                                             
                                                                                                     
                                                                                            
                                                                                                        
                                                                                                  
                                                                                                  
                                                                                              
                                                                                                       
                                                                                                
                                                                                        
                                                                                                               
                                              
 
                                                                                                                                      
                                                                                                        
                                      
                                                                          
                                      
                                                                  
                                                                                                       
                                      
                                                                       
                                                                                            
                                                                     
 
                                                                               
                                                                                            
                                          
                                                                                                       
                                                                                    
                                              
                                                                                                       
                                              
 
                                                                                        
                                                                                   
                                              
                                                                                                      
                                              
 
                                                                                                
                                          
                                                                                            
                                      
                                      
                                                                                    
                                                                                              
                                    if (sResultMsg.Contains("^"))
                                    {
                                        string[] strMsg = sResultMsg.Split('^');
                                        string messageCode = strMsg[0];
                                        string addmessage = strMsg[1].ToString();

                                        MessageHelper.GMessageBox(messageCode, new object[] { addmessage });
                                    }
                                                                                              
                                    else
                                    {                                                                                           
                                                                                                         
                                        MessageBox.Show(response.DataSet.Tables[0].Rows[0][0].ToString(), "Error!");
                                                                                                                              
                                    }
                                    return;
                                }
                                                       
                                MessageHelper.GMessageBox("MSG00004", new object[] { iCUD });

                                                                           
                                        
                                                   

                                           
                                if (blnInsert)
                                    FindData(true);
                                else
                                    FindData(false, iUpdateRow, siMain.ActiveSheet.ActiveColumnIndex);                                                                                                            
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
                                                           

        private void InsertRow()
        {
            try
            {                                                                              
                           
                                  
                                         
                                   
                                   
                                 

                DataTable dt;
                bool bEDIT_AUTH_SalesAmt_LOC = false;

                if (dsMain != null && dsMain.Tables.Count >= 3)
                {
                    dt = dsMain.Tables[2].Copy();
                    if (dt.Columns.Contains("EDIT_AUTH_SalesAmt_LOC"))
                    {
                        bEDIT_AUTH_SalesAmt_LOC = dt.Rows[0]["EDIT_AUTH_SalesAmt_LOC"].ToString() == "Y" ? true : false;
                    }
                }

                if (!bEDIT_AUTH_SalesAmt_LOC)
                {
                    return;
                }
                                                                                        

                if (siMain != null && siMain.IsLock(siMain.SheetName) == false)
                {
                    if (siMain.SheetName == SpdSheet.shtMain)
                    {
                        siMain.SpreadObject.SuspendLayout();

                                                
                        FarPoint.Win.Spread.Cell insCell = siMain.Insert();
                                              

                                                                                            
                        string sDivision = clbDivision.SelectedValue.ToString();
                        string sEndCustomer = string.Empty;
                        string sScmSiteID = string.Empty;
                        string sItemID = string.Empty;
                        DataTable dtTeamAuth = Data.UserTeamByDivisionAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision);
                        DataTable dtSalesSiteAuth = Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "");
                        DataTable dtEndCustomerAuth;                                                                                                                                   

                        if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) != -1)
                        {
                            siMain.SetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), sDivision);
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), true);
                        }

                        dtEndCustomerAuth = Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "");

                                                                         
                        if (sDivision == "40" && siMain.GetColumnIndex(DefColumns.DEPT_ID) != -1)
                        {
                            siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeamAuth);
                        }
                        else if (siMain.GetColumnIndex(DefColumns.DEPT_ID) != -1)
                        {
                                       
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DEPT_ID), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DEPT_ID), true);
                        }
                                                                       


                        if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER) != -1)
                            sEndCustomer = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) != -1)
                            sScmSiteID = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                            sItemID = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString();

                                                                                                         
                        if (siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID) != -1)
                        {
                                                                                                                                         
                            dtCellProdSiteID = Data.Common(Data.Type.CELL_PROD_SITE_ID, false, sDivision, sItemID, "", "", "");
                            siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID), dtCellProdSiteID);
                        }
                                                                                                       

                        if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER) != -1)
                            siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomerAuth);
                        if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) != -1)
                            siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSiteAuth);

                                         
                        if (siMain.GetColumnIndex(DefColumns.MEASURE) != -1)
                        {
                                                              
                            siMain.SetCellTypeCombo(insCell.Row.Index, siMain.GetColumnIndex(DefColumns.MEASURE), dtMearsure);
                            siMain.SetValue(insCell.Row.Index, siMain.GetColumnIndex(DefColumns.MEASURE), "SalesAmt_LOC");

                                                                                                                                                                                          

                                                                          
                                                            

                            if (sDivision != "40")
                            {
                                siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE), true);
                            }

                        }
                        if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) != -1)
                            siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType = cellTypeImage;

                        if (siMain.GetColumnIndex(DefColumns.FcstType) != -1)
                        {
                            siMain.SetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FcstType), "ETC");
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FcstType), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FcstType), true);
                        }

                                                     
                        if (siMain.GetColumnIndex(DefColumns.TEAM_INCHARGE) != -1)
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TEAM_INCHARGE), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TEAM_INCHARGE), true);
                        if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME) != -1)
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), true);
                        if (siMain.GetColumnIndex(DefColumns.ProjectStatus) != -1)
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ProjectStatus), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ProjectStatus), true);
                        if (siMain.GetColumnIndex(DefColumns.PROJECT_OWNER) != -1)
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_OWNER), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_OWNER), true);

                        if (siMain.GetColumnIndex(DefColumns.BizTypeName) != -1)
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.BizTypeName), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.BizTypeName), true);

                                                                                                                                                                                                           
                        if (siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME) != -1)
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), true);
                        if (siMain.GetColumnIndex(DefColumns.ITEM_NAME) != -1)
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_NAME), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_NAME), true);

                        if (siMain.GetColumnIndex(DefColumns.ItemType) != -1)
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemType), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemType), true);

                                                                           
                        if (siMain.GetColumnIndex(DefColumns.SALES_COMPANY) != -1)
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SALES_COMPANY), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SALES_COMPANY), true);
                        if (siMain.GetColumnIndex(DefColumns.SALES_PLANT) != -1)
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SALES_PLANT), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SALES_PLANT), true);

                        if (siMain.GetColumnIndex(DefColumns.NickName) != -1)
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.NickName), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.NickName), true);

                        if (siMain.GetColumnIndex(DefColumns.KwhCell) != -1)
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.KwhCell), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.KwhCell), true);

                        if (siMain.GetColumnIndex(DefColumns.KwhModule) != -1)
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.KwhModule), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.KwhModule), true);

                        if (siMain.GetColumnIndex(DefColumns.KwhPack) != -1)
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.KwhPack), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.KwhPack), true);

                        if (siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID) != -1)
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), true);

                                                                                   
                                                                                                                                                                                                  

                        if (siMain.GetColumnIndex(DefColumns.DomExp) != -1)
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DomExp), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DomExp), true);

                        if (siMain.GetColumnIndex(DefColumns.CURRENCY) != -1)
                        {
                                                                                                                                                                                            
                            siMain.SetCellTypeCombo(insCell.Row.Index, siMain.GetColumnIndex(DefColumns.CURRENCY), dtCurrencyList);
                        }
                        if (siMain.GetColumnIndex(DefColumns.SALES_PLAN_ADJUST_YN) != -1)
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SALES_PLAN_ADJUST_YN), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SALES_PLAN_ADJUST_YN), true);
                        if (siMain.GetColumnIndex(DefColumns.INCOTERMS) != -1)
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.INCOTERMS), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.INCOTERMS), true);

                                                                   
                                         
                        if (siMain.GetColumnIndex(DefColumns.OWNER) != -1)
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.OWNER), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.OWNER), true);

                        if (siMain.GetColumnIndex(DefColumns.COUNTRY_NAME) != -1)
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.COUNTRY_NAME), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.COUNTRY_NAME), true);
                        if (siMain.GetColumnIndex(DefColumns.CITY_NAME) != -1)
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CITY_NAME), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CITY_NAME), true);
                        if (siMain.GetColumnIndex(DefColumns.FORECAST_INFO_PRODUCT_GROUP) != -1)
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_PRODUCT_GROUP), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_PRODUCT_GROUP), true);
                        if (siMain.GetColumnIndex(DefColumns.VMI_YN) != -1)
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.VMI_YN), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.VMI_YN), true);

                                                                                                  
                        if (siMain.GetColumnIndex(DefColumns.ProjectName) != -1)
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ProjectName), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ProjectName), true);
                        if (siMain.GetColumnIndex(DefColumns.DistributionChannel) != -1)
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DistributionChannel), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DistributionChannel), true);
                        if (siMain.GetColumnIndex(DefColumns.CellName) != -1)
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CellName), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CellName), true);
                        if (siMain.GetColumnIndex(DefColumns.ShipmentSite) != -1)
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ShipmentSite), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ShipmentSite), true);

                                                            
                                                       
                                                    
                                                                                                         
                          
                                                                                                                                                                                                  
                           

                        if (siMain.GetColumnIndex(DefColumns.COMPANY_ID) != -1)
                        {
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.COMPANY_ID), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.COMPANY_ID), true);
                        }
                        if (siMain.GetColumnIndex(DefColumns.CUST_GROUP) != -1)
                        {
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CUST_GROUP), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CUST_GROUP), true);
                        }
                        if (siMain.GetColumnIndex(DefColumns.CUST_GROUP_DTL) != -1)
                        {
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CUST_GROUP_DTL), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CUST_GROUP_DTL), true);
                        }
                        if (siMain.GetColumnIndex(DefColumns.APPLICATION) != -1)
                        {
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.APPLICATION), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.APPLICATION), true);
                        }
                        if (siMain.GetColumnIndex(DefColumns.ROUTE) != -1)
                        {
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ROUTE), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ROUTE), true);
                        }
                        if (siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME40) != -1)
                        {
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME40), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME40), true);
                        }
                        if (siMain.GetColumnIndex(DefColumns.GROUP_ID) != -1)
                        {
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.GROUP_ID), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.GROUP_ID), true);
                        }
                        if (siMain.GetColumnIndex(DefColumns.INTERNAL_YN) != -1)
                        {
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.INTERNAL_YN), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.INTERNAL_YN), true);
                        }
                        if (siMain.GetColumnIndex(DefColumns.CELL_TYPE) != -1)
                        {
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_TYPE), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_TYPE), true);
                        }
                        if (siMain.GetColumnIndex(DefColumns.FORECAST_INFO_CELL_PACK_COUNT) != -1)
                        {
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_CELL_PACK_COUNT), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_CELL_PACK_COUNT), true);
                        }
                        if (siMain.GetColumnIndex(DefColumns.CELL_MODEL_INFO) != -1)
                        {
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_MODEL_INFO), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_MODEL_INFO), true);
                        }
                        if (siMain.GetColumnIndex(DefColumns.CELL_MODEL) != -1)
                        {
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_MODEL), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_MODEL), true);
                        }
                        if (siMain.GetColumnIndex(DefColumns.FORECAST_INFO_ALL) != -1)
                        {
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_ALL), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_ALL), true);
                        }
                        if (siMain.GetColumnIndex(DefColumns.FORECAST_INFO_SPEC) != -1)
                        {
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_SPEC), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_SPEC), true);
                        }
                        if (siMain.GetColumnIndex(DefColumns.FORECAST_INFOR_VERSION) != -1)
                        {
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FORECAST_INFOR_VERSION), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FORECAST_INFOR_VERSION), true);
                        }
                        if (siMain.GetColumnIndex(DefColumns.CELL_MODEL_NICK_NAME) != -1)
                        {
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_MODEL_NICK_NAME), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_MODEL_NICK_NAME), true);
                        }
                        if (siMain.GetColumnIndex(DefColumns.MDM_PROJECT_NAME) != -1)
                        {
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MDM_PROJECT_NAME), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MDM_PROJECT_NAME), true);
                        }
                        if (siMain.GetColumnIndex(DefColumns.MIN_CAPACITY) != -1)
                        {
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MIN_CAPACITY), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MIN_CAPACITY), true);
                        }
                        if (siMain.GetColumnIndex(DefColumns.CELL_PER_CAR) != -1)
                        {
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_PER_CAR), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_PER_CAR), true);
                        }
                        if (siMain.GetColumnIndex(DefColumns.CELL_PER_MODULE) != -1)
                        {
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_PER_MODULE), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_PER_MODULE), true);
                        }
                        if (siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR) != -1)
                        {
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), true);
                        }
                        if (siMain.GetColumnIndex(DefColumns.ENERGE) != -1)
                        {
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ENERGE), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ENERGE), true);
                        }
                        if (siMain.GetColumnIndex(DefColumns.ENERGE_WH) != -1)
                        {
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ENERGE_WH), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ENERGE_WH), true);
                        }
                        if (siMain.GetColumnIndex(DefColumns.CELL_QUANTITY) != -1)
                        {
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_QUANTITY), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_QUANTITY), true);
                        }
                        if (siMain.GetColumnIndex(DefColumns.DMS_SALES) != -1)
                        {
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DMS_SALES), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DMS_SALES), true);
                        }
                        if (siMain.GetColumnIndex(DefColumns.DMS_CUSTOMER) != -1)
                        {
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DMS_CUSTOMER), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DMS_CUSTOMER), true);
                        }

                                                          

                                                                                                         
                        if (siMain.GetColumnIndex(DefColumns.SCP_USE_YN) != -1)
                        {
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCP_USE_YN), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCP_USE_YN), true);
                        }
                                                                                                        
                                                                                                    
                        if (siMain.GetColumnIndex(DefColumns.FromSiteId) != -1)
                        {
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FromSiteId), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FromSiteId), true);
                        }
                                                                                                  
                                               
                                                                                                                        
                            
                                                                                                                              

                                                                                          
                                                                                                               
                                                                  
                                                                                                              
                            

                                                          
                                  
                                      
                                                                                                  
                                                                    
                                                                                                                                                                                     


                                         
                        int i_EditStartCol = siMain.GetColumnIndex(DefColumns.MEASURE) + 1;

                                                                                                 
                           
                                                                                    
                          
                                                                        
                          
                          

                                                        
                        if (cboBucketType.ControlValues == BucketType.Monthly)
                        {                                    
                            if (siMain.GetColumnIndex(this_YYYYMM) >= 0)
                            {
                                i_EditStartCol = siMain.GetColumnIndex(this_YYYYMM);
                            }
                        }

                                                                                            
                                                       
                        if (cboBucketType.ControlValues == BucketType.Weekly)
                        {                                     
                            if (siMain.GetColumnIndex(this_YYYYMMWW) >= 0)
                            {
                                i_EditStartCol = siMain.GetColumnIndex(this_YYYYMMWW);
                            }
                            else
                            {
                                i_EditStartCol += 1;                     
                            }
                        }
                                                                                          

                                                      
                        if (Convert.ToInt32(siMain.GetColumnTag(siMain.GetMaxColumnIndex()).Replace("W_", "")) < Convert.ToInt32(this_YYYYMMWW.Replace("W_", "")))
                        {
                            i_EditStartCol = 0;
                        }

                                                                      
                                               
                                                                        
                           
                                                                                    
                            
                                                                    


                                                                                                       
                           
                                                                                                                  
                                                                                                                                                                     
                             
                                                                                                                                                                               
                                                                    

                                                                                  
                        if (i_EditStartCol > 0 && siMain.GetColumnIndex(DefColumns.MEASURE) + 1 < i_EditStartCol)
                        {
                            if (clbDivision.SelectedValue.ToString().Substring(0, 2) == "40")
                            {                                              
                                siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowIndex, i_EditStartCol - 1, true);
                            }
                            else if ((cboBucketType.ControlValues == BucketType.Monthly) && (clbDivision.SelectedValue.ToString().Substring(0, 2) != "40"))
                            {
                                                                   
                                siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowIndex, i_EditStartCol, true);
                            }
                            else if ((cboBucketType.ControlValues == BucketType.Weekly) && (clbDivision.SelectedValue.ToString().Substring(0, 2) != "40"))
                            {
                                if (siMain.GetColumnIndex(this_YYYYMMWW) >= 0)
                                    siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowIndex, i_EditStartCol - 1, true);
                            }
                        }
                                                                                                
                        else if (i_EditStartCol > 0 && siMain.GetColumnIndex(DefColumns.MEASURE) + 1 == i_EditStartCol)
                        {
                            if (clbDivision.SelectedValue.ToString().Substring(0, 2) == "40")
                                siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowIndex, i_EditStartCol, false);
                            else
                                                                                                                                    
                                                                                                                        
                                                                            
                                if (Convert.ToInt32(siMain.GetColumnTag(i_EditStartCol).Replace("M_", "")) > Convert.ToInt32(this_YYYYMM.Replace("M_", "")))
                                siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowIndex, i_EditStartCol, false);
                                                                                                                               
                            else
                                siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowIndex, i_EditStartCol, true);
                        }
                        else
                        {
                                                          
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowIndex, siMain.GetMaxColumnIndex(), true);
                        }
                                                                    

                        for (int i = siMain.GetColumnIndex(DefColumns.MEASURE); i <= siMain.GetMaxColumnIndex(); i++)
                        {
                            string sValue = siMain.GetColumnTag(i);
                                                                                          
                            if (sValue.IndexOf("D_") >= 0)
                                siMain.LockRange(siMain.ActiveRowIndex, i, siMain.ActiveRowIndex, i, true);

                                                                                                                     
                                                     
                            if (cboBucketType.ControlValues == BucketType.Monthly)
                            {
                                if (siMain.GetColumnTag(i).IndexOf("W_") == 0)
                                {
                                                                       
                                    siMain.LockRange(siMain.ActiveRowIndex, i, siMain.ActiveRowIndex, i, true);                          
                                }
                            }
                            else if (cboBucketType.ControlValues == BucketType.Weekly)
                            {
                                                               
                                if (siMain.GetColumnTag(i).IndexOf("M_") == 0)
                                {
                                                                       
                                    siMain.LockRange(siMain.ActiveRowIndex, i, siMain.ActiveRowIndex, i, true);                          
                                }
                            }
                                                                                                                   
                        }

                                                                           
                                            
                        if (siMain.GetColumnIndex(DefColumns.ITEM_ID) > 0)
                        {
                            if (sDivision != null && sDivision != "")
                            {
                                if (sDivision == "82")
                                    siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '82' ").CopyToDataTable<DataRow>());
                                else if (sDivision.Substring(0, 2) == "81")
                                    siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '81' ").CopyToDataTable<DataRow>());
                                                                                                              
                                else if (sDivision == "40")
                                    siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '40' ").CopyToDataTable<DataRow>());
                            }
                        }
                        siMain.SpreadObject.ResumeLayout();
                    }
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

        private DataTable GetSALESPLAN_MEASUREInfo()
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sScmBinding))
            {
                var request = new FoxDataRequest("DM.DMF0021_GET_SALES_PLAN_MEASUREINFO");
                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }
            return dt;

        }

        private DataTable GetSALESPLAN_MEASUREInfo2()
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sScmBinding))
            {
                var request = new FoxDataRequest("DM.DMF0021_GET_SALES_PLAN_MEASUREINFO2");
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
                sResult_YYYYMMWW = "W_" + sResult_YYYYMMDD.Substring(0, 6) + iso_week;

                if (chkColor.Checked == false)
                {
                    FarPoint.Win.BevelBorder bevelbrdr = new FarPoint.Win.BevelBorder(FarPoint.Win.BevelBorderType.Raised, Color.Green, Color.Green, 3, true, false, false, false);

                    if (cboBucketType.ControlValues == BucketType.Daily)
                    {
                        if (siMain.GetColumnIndex("D_" + sResult_YYYYMMDD) > 0)
                            siMain.ActiveSheet.Columns[siMain.GetColumnIndex("D_" + sResult_YYYYMMDD)].Border = bevelbrdr;
                        siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].ResetBorder();
                    }
                    else if (cboBucketType.ControlValues != BucketType.Daily)
                    {
                                                                           
                            
                                                                                                                      
                            
                                                                             
                            
                                                                                                                   
                            

                                                                                                           
                        if (siMain.GetColumnIndex(this_YYYYMMWW) > 0)
                            siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border = bevelbrdr;
                        else if (siMain.GetColumnIndex(sResult_YYYYMMWW) > 0)
                            siMain.ActiveSheet.Columns[siMain.GetColumnIndex(sResult_YYYYMMWW)].Border = bevelbrdr;

                        if (siMain.GetColumnIndex("D_" + sResult_YYYYMMDD) > 0)
                            siMain.ActiveSheet.Columns[siMain.GetColumnIndex("D_" + sResult_YYYYMMDD)].ResetBorder();
                    }
                }

                if (!siMain.IsLock(siMain.SheetName))
                {
                    EditButton();
                                    
                }
            }

        }
        private void SetSpreadColumn()
        {
            int iStartCol = siMain.GetColumnIndex(DefColumns.MEASURE) + 1;
            DateTime dateTime = DateTime.Today.AddDays(Convert.ToInt32(DayOfWeek.Monday) - Convert.ToInt32(DateTime.Today.DayOfWeek));
            sResult_YYYYMMDD = dateTime.ToString("yyyyMMdd");
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
                        if (iso_week == siMain.GetColumnTag(iCol).ToString().Substring(8) && siMain.GetColumnTag(iCol).ToString().Substring(2, 6) == sResult_YYYYMMDD.Substring(0, 6))
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
            if (e.ColumnHeader)
            {

                if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0)
                {
                    for (int iCol = e.Column; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                    {
                        if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0)
                        {
                            siMain.ActiveSheet.Columns[iCol].Visible = !siMain.ActiveSheet.Columns[iCol].Visible;
                        }
                        else if (fBucket == BucketType.Daily)
                        {
                            if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0)
                            {
                                if (siMain.ActiveSheet.Columns[iCol].Visible)
                                    siMain.ActiveSheet.Columns[iCol].Visible = !siMain.ActiveSheet.Columns[iCol].Visible;
                            }
                        }
                        else if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                        {
                            if (!siMain.ActiveSheet.Columns[iCol].Visible)
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
                        if (fBucket == BucketType.Daily)
                        {
                            if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0)
                                siMain.ActiveSheet.Columns[iCol].Visible = !siMain.ActiveSheet.Columns[iCol].Visible;
                        }

                        if ((iCol <= siMain.GetMaxColumnIndex() - 1) && (siMain.GetColumnTag(iCol + 1).IndexOf("W_") == 0))
                            break;
                    }
                }
            }
            else
            {
                if (siMain.IsLock(siMain.SheetName) || siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting.StringI)
                    return;

                string sDivision = "";
                string sProject = "";
                string sScmSiteId = "";
                string sTeam = "";
                string sEndCustomer = "";
                string sScmSite = "";

                                    
                string sItemId = "";
                string sItemName = "";
                string sItemType = "";
                string sNickName = "";
                string sMeasure = "";

                if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) != -1)
                    sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) != -1)
                    sProject = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString();
                if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) != -1)
                    sScmSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString();
                                                                      
                                                                                                                  
                if (siMain.GetColumnIndex(DefColumns.DEPT_ID) != -1)
                    sTeam = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID)).ToString();
                if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER) != -1)
                    sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER)).ToString();
                if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) != -1)
                    sScmSite = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString();

                                    
                if (siMain.GetColumnIndex(DefColumns.MEASURE) != -1)
                    sMeasure = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString();

                                                                                                                                                                                                                                    
                if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE)))
                {
                    SCM0002_ProjectbyDivisionPopupEx popProject = new SCM0002_ProjectbyDivisionPopupEx();
                    popProject.Form_Load(false, sDivision, sTeam, sEndCustomer, sScmSite, sProject);
                    popProject.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                    popProject.ShowDialog();

                    if (popProject.ProjectCode != "" || popProject.ProjectCode != null)
                    {
                        if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) != -1)
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), popProject.ProjectCode);
                        if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME) != -1)
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), popProject.ProjectName);
                        if (siMain.GetColumnIndex(DefColumns.ProjectStatus) != -1)
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ProjectStatus), popProject.ProjectStatus);
                                                                                                                
                        if (siMain.GetColumnIndex(DefColumns.BizTypeName) != -1)
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.BizTypeName), popProject.BizTypeName);
                        if (siMain.GetColumnIndex(DefColumns.PROJECT_OWNER) != -1)
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_OWNER), popProject.ProjectOwner);

                                         
                        if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "");
                        if (siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME) != -1)
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "");
                    }
                }
                                                                     
                else if (sDivision == "40" && sMeasure == "Catch_Up" && e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))
                {
                    sTeam = "ALL";                                                                               
                    sEndCustomer = "ALL";                                                                                   
                    sProject = "";                   
                                                                         
                    string sMdmActive_Sw = string.Empty;
                    sMdmActive_Sw = "Y";                                                                             

                    string sMeasure_info = string.Empty;

                    if (siMain.GetColumnIndex(DefColumns.MEASURE) > 0)
                        sMeasure_info = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString();


                    if (siMain.GetColumnIndex(DefColumns.DEPT_ID) > 0)
                        sTeam = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID)).ToString();

                    if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) > 0)
                        sScmSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString();

                    if (siMain.GetColumnIndex(DefColumns.ITEM_ID) > 0)
                        sItemId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString();

                    if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER40) > 0)
                        sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)).ToString();

                                                                                                   
                    DM0002_ItembyDivisionPopupEx popItem = new DM0002_ItembyDivisionPopupEx();

                                           
                                                                                                               
                    popItem.Form_Load(false, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sMdmActive_Sw, sMeasure_info);                                                
                    popItem.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                    popItem.ShowDialog();

                    sItemId = popItem.ItemID;
                    sItemName = popItem.ItemName;
                    sItemType = popItem.ItemType;
                    sNickName = popItem.NickName;

                    if (sItemId != "")
                    {
                        siMain.SetText(e.Row, e.Column, sItemId);

                        if (siMain.GetColumnIndex(DefColumns.ItemType) > 0)
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ItemType), sItemType);

                        if (siMain.GetColumnIndex(DefColumns.NickName) > 0)
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.NickName), sNickName);
                    }
                }
            }
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


                        if (siMain.GetColumnTag(iStartCol).IndexOf("M_") == 0 && siMain.GetText(e.Row, iStartCol) != "")
                        {
                            siMain.SetText(e.Row, iStartCol, siMain.GetText(e.Row, iStartCol));
                        }

                        for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                        {
                            if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0 && siMain.GetText(e.Row, iCol) != "")
                            {
                                iMonthlySum = iMonthlySum + Convert.ToDecimal(siMain.GetText(e.Row, iCol).Replace(",", ""));
                            }

                            if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 && siMain.GetText(e.Row, iCol) != "")
                            {
                                iMonthlySum = iMonthlySum + Convert.ToDecimal(siMain.GetText(e.Row, iCol).Replace(",", ""));
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
            dtSave.Columns.Add(DefColumns.TEXT, typeof(string));
            dtSave.Columns.Add(DefColumns.DomExp, typeof(string));
            dtSave.Columns.Add(DefColumns.INCOTERMS, typeof(string));
            dtSave.Columns.Add(DefColumns.FcstType, typeof(string));
            dtSave.Columns.Add(DefColumns.MEASURE, typeof(string));
            dtSave.Columns.Add(DefColumns.YYYYMMDD, typeof(string));
            dtSave.Columns.Add(DefColumns.Qty, typeof(int));
        }
        private void SetSaveData(string sDivision, string sProjectCode, string sSiteId, string sText, string sItemId, string sDomExp
                               , string sFcstType, string sIncoterms, string sMeasure, string sYYYYMMDD, int iQty)
        {
            string sFilter = DefColumns.DIVISION_ID + "= '" + sDivision + "'";
            sFilter += " and " + DefColumns.PROJECT_CODE + " = '" + sProjectCode + "'";
            sFilter += " and " + DefColumns.SCM_SITE_ID + " = '" + sSiteId + "'";
            sFilter += " and " + DefColumns.ITEM_ID + " = '" + sItemId + "'";
            sFilter += " and " + DefColumns.TEXT + " = '" + sText + "'";
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
                drNew[DefColumns.TEXT] = sText;
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
            string sText = string.Empty;
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
                    if (siMain.GetColumnIndex(DefColumns.TEXT) > 0)
                        sText = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.TEXT)).ToString();
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

                    if (clbDivision.ControlValues.Substring(0, 2) == "81" && siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID) > 0)                               
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

        string sOrigianlValue = "";
        private void spdMain_EnterCell(object sender, EnterCellEventArgs e)
        {
            int iRow = e.Row;
            int ICol = e.Column;
            string sText = siMain.GetValue(iRow, ICol).ToString();
            if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Column)
            {
                sOrigianlValue = sText == "" ? "0" : sText;
            }
        }

        #region 이벤트 순서
           
               
                  
            
                
                  
             
               
               
        private void spdMain_EditModeOn(object sender, EventArgs e)
        {
                                                                                        
                                                                     
        }

        private void spdMain_EditModeOff(object sender, EventArgs e)
        {
                                                                                        
                                                                      
        }

        private void spdMain_LeaveCell(object sender, LeaveCellEventArgs e)
        {
                                                                        
                                                                                 
            string sMeasure = "";
            string Val = "";
            int iMeasureType = 0;
            int iNewRow = e.NewRow;
            int iNewColumn = e.NewColumn;
            int iOldRow = e.Row;
            int iOldColumn = e.Column;
            int iColumn = 0;
            int iRow = 0;
            string sColName = "";
            string sFcstType = string.Empty;

            iRow = iOldRow;
            iColumn = iOldColumn;

                                                                                                                                  
            if (siMain.GetBGColor(iRow, iColumn) == ControlColor.UnLockColor && siMain.GetColumnIndex(this_YYYYMM) > 0 && siMain.GetColumnIndex(this_YYYYMM) <= iColumn)
            {
                if (siMain.GetColumnIndex(DefColumns.FcstType) >= 0)
                    sFcstType = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FcstType)).ToString();

                if (siMain.GetColumnIndex(DefColumns.MEASURE) >= 0)
                    sMeasure = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString();

                Val = siMain.GetValue(iRow, iColumn).ToString();
                                                           

                #region FcstType가 RMA 관련
                                 
                                                                                                    
                                                                                                 
                                                                         
                if (sMeasure == "RTF_SYS_RP" && sFcstType != "RMA" && Val != "" && Convert.ToDecimal(Val.Replace(",", "")) < 0)
                {
                    siMain.SetValue(iRow, iColumn, "");
                    return;
                }
                #endregion

                #region Measure별 문자열 포맷
                if (sMeasure == "RTF_SYS_RP")
                {
                    iMeasureType = 1;
                }
                else if (sMeasure == "SalesAmt_LOC")
                {
                    iMeasureType = 3;
                }

                                   
                switch (iMeasureType)
                {
                          
                    case 1:
                        siMain.SetRowFormat(iRow, iColumn, 1, "###,###,###,###");
                        break;

                    case 3:
                        siMain.SetRowFormat(iRow, iColumn, 1, "###,###,###,##0.000");
                        break;
                }

                if (sMeasure == "RTF_SYS_RP")
                {
                    if (Val.Contains("."))
                    {
                        Val = Val.Substring(0, Val.IndexOf('.'));
                        siMain.SetValue(iRow, iColumn, Val);
                    }
                }
                #endregion
            }
        }

        private void spdMain_TextChanged(object sender, EventArgs e)
        {
                                                                                        
                                                                      

        }

        private void spdMain_EditChange(object sender, EditorNotifyEventArgs e)
        {
                                                                                        
                                                                                  
        }
        private void spdMain_EditModeStarting(object sender, EditModeStartingEventArgs e)
        {
                                                                                        
                                                                           
        }
        #endregion

        private void chkSum_CheckedChanged(object sender, EventArgs e)
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

        private void spdMain_ComboSelChange(object sender, EditorNotifyEventArgs e)
        {
            if (siMain.IsLock(siMain.SheetName) == false)
            {
                                                            
                string sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                string sTeam = CAppSetting.StringALL;
                string sEndCustomer = CAppSetting.StringALL;
                string sScmSite = CAppSetting.StringALL;

                if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID))
                {
                    sDivision = siMain.GetValue(e.Row, e.Column).ToString();

                    if (siMain.GetColumnIndex(DefColumns.DEPT_ID) > 0)
                    {
                        dtTeam = Data.UserTeamByDivisionAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision);
                        siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeam);

                        sTeam = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID)).ToString();
                    }

                    if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER) > 0)
                    {
                        dtEndCustomer = Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam);
                        siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer);

                        sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER)).ToString();
                    }

                                  
                    if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER40) > 0)
                    {
                        dtEndCustomer = Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
                        siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), dtEndCustomer);

                        sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)).ToString();
                    }

                    if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) > 0)
                    {
                                                                                                                                                         
                        dtSalesSite = Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
                        siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite);
                    }

                    if (siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID) > 0)
                    {
                        dtPlantSite = Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision);
                        siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), dtPlantSite);

                        if (sDivision != null && sDivision != "")
                        {
                            if (sDivision.Substring(0, 2) != "81")
                                siMain.LockRange(e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), true);
                            else
                                siMain.LockRange(e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), false);
                        }
                    }

                                                                       
                    if (siMain.GetColumnIndex(DefColumns.ITEM_ID) > 0)
                    {
                        if (sDivision != null && sDivision != "")
                        {
                            if (sDivision == "82")
                                siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '82' ").CopyToDataTable<DataRow>());
                            else if (sDivision.Substring(0, 2) == "81")
                                siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '81' ").CopyToDataTable<DataRow>());
                                                                                                          
                            else if (sDivision == "40")
                                siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '40' ").CopyToDataTable<DataRow>());
                        }
                    }

                                     
                    if (siMain.GetColumnIndex(DefColumns.DEPT_ID) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), "");
                    if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), "");
                    if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "");
                    if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "");
                    if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "");
                    if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "");
                    if (siMain.GetColumnIndex(DefColumns.TEXT) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.TEXT), "");
                    if (siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "");
                }
                else if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT_ID))
                {
                                     
                                       
                       
                                                                            
                      
                                                                                                              
                                                                                                                                                                         
                                                                                                                       
 
                                                                                                                          
                                                                                                                                                         
                                                                                                                                                                      
                                                                                                                    
                      
 
                                                                              
                      
                                                                                                              
                                                                                                                                                                           
                                                                                                                                                                                        
                                                                                                                         
 
                                                                                                                            
                                                                                                                                                         
                                                                                                                                                                      
                                                                                                                    
                      
 
                                                                       
                      
                                                                  
                          
                                                   
                                                                                                                                                                           
                                                                        
                                                                                                                                                                           
                                                                                                          
                                                        
                                                                                                                                                                           
                          
                      
 
                                     
                                                                                            
                                                                              
                                                                                                   
                                                                             
                                                                                                  
                                                                              
                                                                                                   
                                                                              
                                                                                                   
                                                                         
                                                                                              
                                                                      
                                                                                           
                                                                                 
                                                                                                      
 
      
                }
                else if (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER))
                {
                    sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER)).ToString();
                                                                                                                                                     
                    dtSalesSite = Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite);

                    if (siMain.GetColumnIndex(DefColumns.ITEM_ID) > 0)
                    {
                        if (sDivision != null && sDivision != "")
                        {
                            if (sDivision == "82")
                                siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '82' ").CopyToDataTable<DataRow>());
                            else if (sDivision.Substring(0, 2) == "81")
                                siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '81' ").CopyToDataTable<DataRow>());
                                                                                                          
                            else if (sDivision == "40")
                                siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '40' ").CopyToDataTable<DataRow>());
                        }
                    }

                                     
                    if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "");
                    if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "");
                    if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "");
                    if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "");
                    if (siMain.GetColumnIndex(DefColumns.TEXT) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.TEXT), "");
                    if (siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "");
                }
                              
                else if (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40))
                {
                    sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                    sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)).ToString();

                    dtSalesSite = Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite);

                    if (siMain.GetColumnIndex(DefColumns.ITEM_ID) > 0)
                    {
                        if (sDivision != null && sDivision != "")
                        {
                            if (sDivision == "82")
                                siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '82' ").CopyToDataTable<DataRow>());
                            else if (sDivision.Substring(0, 2) == "81")
                                siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '81' ").CopyToDataTable<DataRow>());
                                                                                                          
                            else if (sDivision == "40")
                            {
                                                                               
                                if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString() != "Catch_Up")
                                {
                                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '40' ").CopyToDataTable<DataRow>());
                                }
                            }
                        }
                    }
                }
                else if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID))
                {
                    if (siMain.GetColumnIndex(DefColumns.ITEM_ID) > 0)
                    {
                        if (sDivision != null && sDivision != "")
                        {
                            if (sDivision == "82")
                                siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '82' ").CopyToDataTable<DataRow>());
                            else if (sDivision.Substring(0, 2) == "81")
                                siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '81' ").CopyToDataTable<DataRow>());
                                                                                                          
                            else if (sDivision == "40")
                            {
                                                                               
                                if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString() != "Catch_Up")
                                {
                                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '40' ").CopyToDataTable<DataRow>());
                                }
                            }
                        }
                    }
                                     
                    if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "");
                    if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "");
                    if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "");
                    if (siMain.GetColumnIndex(DefColumns.TEXT) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.TEXT), "");
                    if (siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "");
                }
                else if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))
                {
                    string sModelCode = (string)siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID));
                    DataRow[] drs = dtITEM_ID.Select("CODE = '" + sModelCode.Trim() + "' ");
                    if (drs.Length > 0)
                    {
                                                

                        string sModelName = drs[0]["NAME"].ToString();
                        if (siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME) != -1)
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), sModelName);
                    }

                    string sEndCustomer2 = "";
                    string sScmSiteID2 = "";
                    string sItemID2 = "";

                    if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER) != -1)
                        sEndCustomer2 = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) != -1)
                        sScmSiteID2 = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                        sItemID2 = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString();
                                                                   
                    if (siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID) != -1)
                    {
                        dtCellProdSiteID = Data.Common(Data.Type.CELL_PROD_SITE_ID, false, sDivision, sItemID2, "", "", "");
                        siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID), dtCellProdSiteID);
                    }
                }
                                                                                                    
                else if (e.Column == siMain.GetColumnIndex(DefColumns.MEASURE))
                {
                                                                                               
                                       
                                     
                    siMain.SpreadObject.SuspendLayout();


                    int i_EditStartCol = siMain.GetColumnIndex(DefColumns.MEASURE) + 1;               

                                                                        
                       
                                                                                
                      
                                                                    
                      
 
                                                  
                                                                                            
                      
                                                                                                                                                                   
                          
                                                
                          
                      
                                                                                                 
                      
                                                                                                                                                    
                          
                                                
                          
                      
 
                                        
                                                                   
                      
                                                                               
                      
                                                                                             
                      
                                                    
                    if (siMain.GetColumnTag(i_EditStartCol).IndexOf("M_") >= 0)
                    {                                    
                        if (siMain.GetColumnIndex(this_YYYYMM) >= 0)
                        {
                            i_EditStartCol = siMain.GetColumnIndex(this_YYYYMM);
                        }
                    }

                                                   
                    if (siMain.GetColumnTag(i_EditStartCol).IndexOf("W_") >= 0)
                    {                                     
                        if (siMain.GetColumnIndex(this_YYYYMMWW) >= 0)
                        {
                            i_EditStartCol = siMain.GetColumnIndex(this_YYYYMMWW);
                        }

                                                      
                        if (Convert.ToInt32(siMain.GetColumnTag(siMain.GetMaxColumnIndex()).Replace("W_", "")) < Convert.ToInt32(this_YYYYMMWW.Replace("W_", "")))
                        {
                            i_EditStartCol = 0;
                        }
                    }

                                                  
                    if (Convert.ToInt32(siMain.GetColumnTag(siMain.GetMaxColumnIndex()).Replace("W_", "")) < Convert.ToInt32(this_YYYYMMWW.Replace("W_", "")))
                    {
                        i_EditStartCol = 0;
                    }
                                                                      

                                                                                   
                    if ((clbDivision.SelectedValue.ToString().Substring(0, 2) == "40") && (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString() == "SalesAmt_LOC"))
                    {
                                            
                        if (cboBucketType.ControlValues == BucketType.Monthly)
                        {
                            if (siMain.GetColumnIndex(this_YYYYMM) >= 0)
                            {
                                i_EditStartCol = siMain.GetColumnIndex(this_YYYYMM);
                            }
                        }
                        else
                        {
                            if (siMain.GetColumnIndex(this_YYYYMMWW) >= 0)
                            {
                                i_EditStartCol = siMain.GetColumnIndex(this_YYYYMMWW);
                            }
                        }
                    }

                    if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString() == "Catch_Up")
                    {
                        if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                        {
                            siMain.SetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "");
                            siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType = cellTypeImage;
                        }

                        if (siMain.GetColumnIndex(DefColumns.DomExp) != -1)
                        {
                            siMain.SetValue(e.Row, siMain.GetColumnIndex(DefColumns.DomExp), "");
                            siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.DomExp), dtCustomsHandbook);
                            siMain.LockRange(e.Row, siMain.GetColumnIndex(DefColumns.DomExp), e.Row, siMain.GetColumnIndex(DefColumns.DomExp), false);
                        }

                                                                    
                           
                                                                                   
                          
                                                                                                         
                                                                                                                                                          
                                                                                                                          
                                                                                                                                                                     
                          
                          

                        if (siMain.GetColumnIndex(DefColumns.INCOTERMS) != -1)
                        {
                            siMain.SetValue(e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), "");
                            dtIncotermsType = GetIncotermsType(sDivision, sScmSite);
                            siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), dtIncotermsType);
                            siMain.LockRange(e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), false);
                        }

                        if (siMain.GetColumnIndex(DefColumns.FcstType) != -1)
                        {
                            siMain.SetValue(e.Row, siMain.GetColumnIndex(DefColumns.FcstType), "");
                            siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.FcstType), dtFcstType);
                            siMain.LockRange(e.Row, siMain.GetColumnIndex(DefColumns.FcstType), e.Row, siMain.GetColumnIndex(DefColumns.FcstType), false);
                        }

                                                              
                                         
                        if (siMain.GetColumnIndex(DefColumns.DEPT_ID) != -1)
                        {
                            siMain.SetValue(e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), "");
                            siMain.LockRange(e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), true);
                        }

                                                                                
                                           
                        if (i_EditStartCol > 0 && siMain.GetColumnIndex(DefColumns.MEASURE) + 1 < i_EditStartCol)
                        {
                                                                                                                                                                       
                            for (int i = siMain.GetColumnIndex(DefColumns.MEASURE) + 1; i <= siMain.GetMaxColumnIndex(); i++)
                            {
                                string sValue = siMain.GetColumnTag(i);

                                                 
                                if (sValue.IndexOf("D_") < 0 && (Convert.ToUInt32(sValue.Replace("W_", "").Replace("M_", "").Substring(0, 6)) >= Convert.ToUInt32(DateTime.Now.AddMonths(3).ToString("yyyyMM"))))
                                {
                                    siMain.LockRange(siMain.ActiveRowIndex, i, siMain.ActiveRowIndex, i, false);
                                }
                                else
                                {
                                    siMain.LockRange(siMain.ActiveRowIndex, i, siMain.ActiveRowIndex, i, true);
                                }
                            }
                        }
                        else
                        {
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowIndex, siMain.GetMaxColumnIndex(), true);
                        }
                                                                              
                    }
                    else
                    {
                                                       
                        if (siMain.GetColumnIndex(DefColumns.FcstType) != -1)
                        {
                            siMain.SetValue(e.Row, siMain.GetColumnIndex(DefColumns.FcstType), "ETC");
                            siMain.SetCellTypeText(e.Row, siMain.GetColumnIndex(DefColumns.FcstType));                                                           
                            siMain.LockRange(e.Row, siMain.GetColumnIndex(DefColumns.FcstType), e.Row, siMain.GetColumnIndex(DefColumns.FcstType), true);
                        }

                        if (siMain.GetColumnIndex(DefColumns.DomExp) != -1)
                        {
                            siMain.SetValue(e.Row, siMain.GetColumnIndex(DefColumns.DomExp), "");
                            siMain.LockRange(e.Row, siMain.GetColumnIndex(DefColumns.DomExp), e.Row, siMain.GetColumnIndex(DefColumns.DomExp), true);
                        }

                        if (siMain.GetColumnIndex(DefColumns.INCOTERMS) != -1)
                        {
                            siMain.SetValue(e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), "");
                            siMain.LockRange(e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), e.Row, siMain.GetColumnIndex(DefColumns.INCOTERMS), true);
                        }

                                                              
                                         
                        if (siMain.GetColumnIndex(DefColumns.DEPT_ID) != -1)
                        {
                            siMain.SetValue(e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), "");
                            siMain.LockRange(e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), false);
                        }

                        if (siMain.GetColumnIndex(DefColumns.ITEM_ID) > 0)
                        {
                            siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType = null;
                            siMain.SetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "");
                            siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '40' ").CopyToDataTable<DataRow>());
                        }

                        if (siMain.GetColumnIndex(DefColumns.NickName) > 0)
                        {
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.NickName), "");
                        }

                                                                    
                           
                                                                                   
                          
                                                                                                         
                                                                                                                                                                    
                          
                          

                                                                                
                                     
                        siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowIndex, siMain.GetMaxColumnIndex(), false);

                                                                       
                           
                                                                                                                  
                                                                                                                                                                     
                             
                                                                                                                                                                             
                          
                                                                                  
                        if (i_EditStartCol > 0 && siMain.GetColumnIndex(DefColumns.MEASURE) + 1 < i_EditStartCol)
                        {
                            if (clbDivision.SelectedValue.ToString().Substring(0, 2) == "40")
                                                                            
                                siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowIndex, i_EditStartCol - 1, true);
                            else
                                                                   
                                siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowIndex, i_EditStartCol, true);
                        }
                                                                                                
                        else if (i_EditStartCol > 0 && siMain.GetColumnIndex(DefColumns.MEASURE) + 1 == i_EditStartCol)
                        {
                            if (clbDivision.SelectedValue.ToString().Substring(0, 2) == "40")
                                siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowIndex, i_EditStartCol, false);
                            else
                                                                                                                                    
                                                                                                                        
                                                                            
                                if (Convert.ToInt32(siMain.GetColumnTag(i_EditStartCol).Replace("M_", "")) > Convert.ToInt32(this_YYYYMM.Replace("M_", "")))
                                siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowIndex, i_EditStartCol, false);
                                                                                                                               
                            else
                                siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowIndex, i_EditStartCol, true);
                        }
                        else
                        {
                                                          
                            siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowIndex, siMain.GetMaxColumnIndex(), true);
                        }

                                                 
                        for (int i = siMain.GetColumnIndex(DefColumns.MEASURE); i <= siMain.GetMaxColumnIndex(); i++)
                        {
                            string sValue = siMain.GetColumnTag(i);
                                                                                          
                            if (sValue.IndexOf("D_") >= 0)
                                siMain.LockRange(siMain.ActiveRowIndex, i, siMain.ActiveRowIndex, i, true);

                                                     
                            if (cboBucketType.ControlValues == BucketType.Monthly)
                            {
                                if (siMain.GetColumnTag(i).IndexOf("W_") == 0)
                                {
                                                                       
                                    siMain.LockRange(siMain.ActiveRowIndex, i, siMain.ActiveRowIndex, i, true);                          
                                }
                            }
                            else if (cboBucketType.ControlValues == BucketType.Weekly)
                            {
                                                               
                                if (siMain.GetColumnTag(i).IndexOf("M_") == 0)
                                {
                                                                       
                                    siMain.LockRange(siMain.ActiveRowIndex, i, siMain.ActiveRowIndex, i, true);                          
                                }
                            }
                        }
                                                                      

                                                                              
                    }


                                            
                                                                     
                    for (int i = siMain.GetColumnIndex(DefColumns.MEASURE) + 1; i <= siMain.GetMaxColumnIndex(); i++)
                    {
                                                
                        siMain.SetValue(siMain.ActiveRowIndex, i, "");

                        string sValue = siMain.GetColumnTag(i);
                        if (sValue.IndexOf("D_") >= 0)
                            siMain.LockRange(siMain.ActiveRowIndex, i, siMain.ActiveRowIndex, i, true);
                    }

                    siMain.SpreadObject.ResumeLayout();
                }
                                                                                                  
            }
        }

        private void clbCustomer_SelectedIndexChanged(object sender, EventArgs e)
        {
                                                                                                                   
                                                                                                                                                                                     

            SetChangeControl("UserSiteByEndCustomer", clbDivision.ControlValues, string.Empty, clbCustomer.ControlValues);
            clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);
                                                                                                                 

        }

        private void clbDivision_SelectedIndexChanged(object sender, EventArgs e)
        {                                      
            DataService.FP_Log2("SpeedUp", "DMF0021", "division_id_changed", "start");
            try
            {                                                      
                             
                               
                                                               
                              
                    
                            
                                  
                                                                

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
                                                                                                                    

                DataService.FP_Log2("SpeedUp", "DMF0021", "division_id_changed", "end");

                this.txtProject.Text = "";
                this.txtItemId.Text = "";
                this.txtOwner.Text = "";

                InitSpread(true);
            }
            catch (Exception ex)
            {
                                                           
                                   
                throw ex;
            }
            finally
            {   
                                                           
                                   
            }
        }

        private void chkColor_CheckedChanged(object sender, EventArgs e)
        {
            if (siMain != null)
            {
                SetSpreadColumn();
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
                                                       
                                                 
                            
            if (!siMain.IsLock())
            {
                MessageHelper.GMessageBox("MSG00227");
                return;
            }
               
                                                                        
              
                                                                                                                                                      
                  
                                                           
                            
                  
              
              
        }

        private void DMF0021_SalesPlan_Load(object sender, EventArgs e)
        {

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
                                          

                                              
        private DataTable GetIncotermsType(string sDivisionID, string sScmSiteID)
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                var request = new FoxDataRequest("DM.UP_FX_GetCommonDataList_DM");
                request.Parameters["CODE"] = "AS_INCOTERMS";
                request.Parameters["PARAM1"] = sDivisionID;
                request.Parameters["PARAM2"] = sScmSiteID;
                request.Parameters["PARAM3"] = "";
                request.Parameters["PARAM4"] = "";
                request.Parameters["PARAM5"] = "";
                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }
            return dt;
        }
                                            

        private DataTable GetFcstType()
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                var request = new FoxDataRequest("DM.UP_FX_GetCommonDataList_DM");
                request.Parameters["CODE"] = "FCST_TYPE";
                request.Parameters["PARAM1"] = UserInfoContext.Current["NowGroupID"].ToString();
                request.Parameters["PARAM2"] = "";
                request.Parameters["PARAM3"] = "";
                request.Parameters["PARAM4"] = "";
                request.Parameters["PARAM5"] = "";
                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }
                         
            return dt.Select(@" CODE <> 'ETC' ").CopyToDataTable<DataRow>();                                                                      
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

        private void spdMain_ClipboardPasted(object sender, ClipboardPastedEventArgs e)
        {
            for (int iRow = e.CellRange.Row; iRow < e.CellRange.Row + e.CellRange.RowCount; iRow++)
            {
                for (int iCol = e.CellRange.Column; iCol < e.CellRange.Column + e.CellRange.ColumnCount; iCol++)
                {
                    if (iCol == siMain.GetColumnIndex(DefColumns.ITEM_ID))
                    {
                        if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) != -1 && siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) != -1)
                        {
                            string sDivision = siMain.GetColumnIndex(DefColumns.DIVISION_ID) != -1 ? siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() : "";
                            string sScmSiteID = siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) != -1 ? siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString() : "";
                            string sEndCustomer = siMain.GetColumnIndex(DefColumns.END_CUSTOMER) != -1 ? siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.END_CUSTOMER)).ToString() : "";
                            string sItemID = siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1 ? siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() : "";

                            if (siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID) != -1)
                            {                                                                                                                
                                dtCellProdSiteID = Data.Common(Data.Type.CELL_PROD_SITE_ID, false, sDivision, sItemID, "", "", "");
                                siMain.SetCellTypeCombo(iRow, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID), dtCellProdSiteID);
                            }
                        }
                    }
                }
            }
        }
    }

}
