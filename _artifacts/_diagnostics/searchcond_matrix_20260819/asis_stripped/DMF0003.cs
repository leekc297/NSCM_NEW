using GSCM.App.Core.Security;
using GSCM.App.Core.Text;
using GSCM.Windows.Forms.Class;
using GSCM.Windows.Forms.UI;
using GSCM.Windows.Forms.Utility;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using TheOne.ServiceModel.Data;
using TheOne.Windows.Forms;
using GSCM.SCM.Popup.UIL;
using System.Windows.Forms;
using FarPoint.Win.Spread;
using GSCM.DM.Plan.UIL.POPUP;

using FarPoint.Win.Spread.CellType;
using System.Globalization;

using System.Collections;

using System.Collections.Specialized;
using System.Threading.Tasks;
using GSCM.DM.Plan.UIL;


using GSCM.Windows.Forms.Service;
using GSCM.FP.Common.UIL.Service;

                                                                                                                                                                                             
                              
                   
                   
                                                                                                                                                                                             
                                             
                                                                                                                                                                                             
                                                   
                                                                                
                                                                                               
                                                                                                      
                                                                                                 
                                                                           
                                                                                        
                                                                                                                  
                                                                                  
                                                                      
                                                                                     
                                                                                                                                      
                                                                                       
                                                                                                     
                                                                                  
                                                                                         
                                                                          
                                                                 
                                                         
                                                                                                
                                                                                    
                                                       
                                                                         
                                                                         
                                                                         
                                                                 
                                                                           
                                                                                                         
                                                                              
                                                     
                                                      
                                                                                
                                                                 
                                                                                                
                                           
                                                                     
                                        
                                                                                    
                                                       
                                                                                                  
                                                                                                 
                                                                                            
                                                                                                            
                                                                                               
                                                                                          
                                                                             
                                                                            
                                                                                                               
                                                                                   
                                                                                        
                                                                                  
                                                                                  
                                                             
                                                                                                            
                                                                                                                                                                                            

namespace GSCM.DM.Plan.UIL
{
    public partial class DMF0003_MktFcst : BaseForm
    {
        #region 1. Setting
        CControl clsCtrl = null;
                           
        private DataTable dtSave = null;
        private DataTable dtSaveFinal = null;

        private DataSet dsSpdTitle = null;

        private DataTable dtTitle = null;
        private DataTable dtDivision = null;
                                               
        private DataTable dtTeam = null;
        private DataTable dtTeamSpr = null;
        private DataTable dtCustomer = null;
        private DataTable dtEndCustomer = null;
        private DataTable dtBizType = null;
        private DataTable dtSalesSite = null;
        private DataTable dtPlantSite = null;
        private DataTable dtBucketType = null;
        private DataTable dtItemType = null;
        private DataTable dtMeasure = null;

        private DataTable dtCustomer40 = null;
        private DataTable dtSalesSite40 = null;
        private DataTable dt8Week = null;                
        private DataTable dt_VMI_YN = null;          

        private DataTable dtEdiSender = null;

        private DataTable dtDM_UI_EDITABLE_DIVISION = null;                                                                    

        private DataTable dtincotermsEditType = null;                                                                                    

        private DataTable dtAsFromSite = null;                                                      

        private string this_YYYYMMWW = "";
        private string sResultYYYYMMDD = "";
        private string sResult_YYYYMMWW = "";
        private string iso_week = "";
        private int count = 0;

                  
        SpreadInfo siMain = null;

        TextCellType cellTypeImage = null;


                      
                       
                       
        private struct SpdSheet
        {
            public static string shtMain = "Mkt Fcst";
        }

                      
                  
                       
        private struct DefColumns
        {
            public static string Division = "DIVISION_ID";
            public static string Department = "DEPT_ID";
            public static string DepartmentName = "DEPT_NAME_KO";
            public static string Team = "TEAM_ID";
            public static string TeamName = "TEAM_NAME_KO";
            public static string Customer = "END_CUSTOMER";
            public static string BizType = "BIZ_TYPE";
            public static string ScmSiteId = "SCM_SITE_ID";
            public static string PlantSiteId = "PLANT_SITE_ID";
            public static string Project = "PROJECT_CODE";

            public static string ProjectName = "PROJECT_NAME";
            public static string ItemId = "ITEM_ID";
            public static string ItemName = "ITEM_NAME";
            public static string NickName = "NICK_NAME";
            public static string Incoterms = "INCOTERMS";
            public static string ItemType = "ITEM_TYPE";
            public static string FcstType = "FCST_TYPE";
            public static string DomExp = "DOM_EXP";
            public static string ProjectStatus = "PROJECT_STATUS";
            public static string ProjectOwner = "PROJECT_OWNER";

            public static string Owner = "OWNER";
            public static string SoldToCustomer = "SOLDTO_CUSTOMER";
            public static string CellType = "CELL_TYPE";
            public static string City = "CITY";
            public static string CityName = "CITY_NAME";
            public static string Country = "COUNTRY";
            public static string CountryName = "COUNTRY_NAME";
            public static string EditFlag = "EDIT_FLAG";
            public static string MeasureGroup = "MEASURE_GROUP";
            public static string Measure = "MEASURE";

            public static string YYYYMMDD = "YYYYMMDD";
            public static string Qty = "QTY";
            public static string ColumnName = "COLUMN_NAME";
            public static string ColumnLabel = "COLUMN_LABEL_NAME";
            public static string SmallLabelName = "SMALL_CLASS_LABEL_NAME";
            public static string LargeLabelName = "LARGE_CLASS_LABEL_NAME";
            public static string DayCode = "DAY_CODE";
                                                           
            public static string Division40 = "DIVISION_ID40";
            public static string Customer40 = "END_CUSTOMER40";

            public static string ScmSiteId40 = "SCM_SITE_ID40";
            public static string ItemId40 = "ITEM_ID40";
            public static string VMI_YN = "VMI_YN";
                                   
            public static string CUST_GROUP = "CUST_GROUP";
            public static string CUST_GROUP_DTL = "CUST_GROUP_DTL";
            public static string APPLICATION = "APPLICATION";
            public static string ROUTE = "ROUTE";
            public static string MDM_PROJECT_NAME = "MDM_PROJECT_NAME";
            public static string MIN_CAPACITY = "MIN_CAPACITY";
            public static string FORECAST_INFO_BIZ_TYPE = "FORECAST_INFO_BIZ_TYPE";

            public static string FORECAST_INFO_PRODUCT_GROUP = "FORECAST_INFO_PRODUCT_GROUP";
            public static string CELL_TYPE = "CELL_TYPE";
            public static string FORECAST_INFO_CELL_MODEL = "FORECAST_INFO_CELL_MODEL";
            public static string FORECAST_INFO_CELL_PACK_COUNT = "FORECAST_INFO_CELL_PACK_COUNT";
            public static string FORECAST_INFO_SPEC = "FORECAST_INFO_SPEC";
            public static string DMS_SALES = "DMS_SALES";
            public static string DMS_CUSTOMER = "DMS_CUSTOMER";
                                                       
            public static string NewFlag = "NEW_FLAG";
            public static string VMI_STD_DIO = "VMI_STD_DIO";
            public static string BUCKET = "BUCKET";

            public static string AS_FROM_SITE = "AS_FROM_SITE";
            public static string LAST_UPDATE_DATE = "LAST_UPDATE_DATE";
            public static string LAST_UPDATED_BY = "LAST_UPDATED_BY";
            public static string SENDER_CODE = "SENDER_CODE";
            public static string SENDER_NAME = "SENDER_NAME";
            public static string PROJECT_S_OP_REPORT = "PROJECT_S_OP_REPORT";                                                 
            public static string CELL_PER_MODULE = "CELL_PER_MODULE";                                                    
        }


        private struct DefColumnsLabel
        {
            public static string Division = "Division";
            public static string Department = "Department";
            public static string DepartmentName = "Department";
            public static string Team = "Team";
            public static string TeamName = "Team";
            public static string Customer = "Customer";
            public static string BizType = "Biz. Type";
            public static string ScmSiteId = "Sales Site";
            public static string PlantSiteId = "Plant Site";
            public static string Project = "Project";

            public static string ProjectName = "Project Name";
            public static string ItemId = "Model";
            public static string ItemName = "Model Name";
            public static string NickName = "Nick Name";
            public static string Incoterms = "Incoterms";
            public static string ItemType = "Item Type";
            public static string FcstType = "Fcst Type";
            public static string DomExp = "DOM/EXP";
            public static string ProjectStatus = "Project Status";
            public static string ProjectOwner = "Project Owner";

            public static string City = "City";
            public static string CityName = "City";
            public static string Country = "Country";
            public static string CountryName = "Country";
            public static string MeasureGroup = "Measure";
            public static string Measure = "Measure";
            public static string Saturday = "SAT";
            public static string Sunday = "SUN";
                                                       
            public static string Division40 = "DIVISION_ID40";

            public static string Customer40 = "Customer40";
            public static string ScmSiteId40 = "Sales Site40";
            public static string ItemId40 = "Model40";
        }

        private struct BucketType
        {
            public static string Daily = "DAILY";
            public static string Weekly = "WEEKLY";
            public static string Monthly = "MONTHLY";
        }

        private string sBinding = "GSCM.DM.Master.WSL/FoxDataService.svc";
        private string sScmBinding = "GSCM.SCM.Master.WSL/FoxDataService.svc";

        private string sDefaultDay = string.Empty;
        private bool bPasteContinue = true;
        #endregion

        #region 2. Construct

        public DMF0003_MktFcst()
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
            InitSaveDataTable();

                                                            

            if ((clbDivision.ControlValues.Substring(0, 2) == "81") || (clbDivision.ControlValues == "82"))
            {
                dtMeasure = Data.Common(Data.Type.MktFcstEditMeasure);
                                                                                                            
                if (UserInfoContext.Current["NowGroupID"] != "DM Planner (W/S)")
                {
                    foreach (DataRow row in dtMeasure.Rows)
                    {
                        if (row["Code"].ToString() != "MKT_FCST_RP")
                        {
                            row.Delete();
                        }
                    }
                    dtMeasure.AcceptChanges();
                }
                                                                                                          
            }
        }

        protected override void OnShown(EventArgs e)
        {
            base.OnShown(e);

                                                                   
               
                                                                             
              
                                      
                                       
              
              
                                                                 

            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);

            if (sDivision == "82")
            {
                cboBucketType.ControlValues = BucketType.Daily;
            }
            else
            {
                cboBucketType.ControlValues = BucketType.Weekly;
            }
        }

        #endregion

                                             
        #region FILTER_PART


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

                case "EdiSender":
                    dtEdiSender = DataService.GetDMInnerTable("EdiSender", Filter);
                    break;

                case "ScmSitebyEndCustomer40":
                    dtSalesSite40 = DataService.GetDMInnerTable("ScmSitebyEndCustomer40", Filter);
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

                                                                        
                                                                                                                                  

            SetChangeControl("UserTeamByDivision", sDivision);
            clsCtrl.setListBox(dtTeam, clbTeam, true);

            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);
            string sEndCustomer = string.Empty;

            lblEDISender.Enabled = false;

                                                                                     
            if (sDivision == "40")
            {
                                                                            
                                                                                         

                SetChangeControl("BizType", sDivision);
                clsCtrl.setListBox(dtBizType, clbBizType, true);

                                                                            
                                                                                                                                                                                  

                SetChangeControl("EndCustomerByDivision", sDivision, sTeam);

                lblProject.Enabled = false;
                lblPlantSite.Enabled = false;
                btnProject.Enabled = false;
                cboCellQty.Enabled = true;
                                                        
                checkInvalidExec.Enabled = false;
            }
            else
            {
                                                                            
                                                               

                SetChangeControl("BizType", sDivision);
                clsCtrl.setListBox(dtBizType, clbBizType, true);

                                                                            
                                                                                                                                                               

                SetChangeControl("EndCustomerByDivision", sDivision, sTeam);

                lblProject.Enabled = true;
                lblPlantSite.Enabled = true;
                btnProject.Enabled = true;
                cboCellQty.Enabled = false;
                cboCellQty.Checked = false;

                                                                    
                if (sDivision == "82")
                {
                    checkInvalidExec.Enabled = true;
                    checkInvalidExec.Checked = true;
                }
                else
                {
                    checkInvalidExec.Enabled = false;
                    checkInvalidExec.Checked = false;

                    if (sDivision == "81")
                    {
                        lblEDISender.Enabled = true;

                                                                                    
                                                        

                        SetChangeControl("EdiSender", sDivision, sTeam);
                        clsCtrl.setListBox(dtEdiSender, clbEDISender, true);
                    }
                }
            }

                                                              
                                              
                   
            lblBizType.Enabled = true;
            chkColor.Checked = false;
            chkSum.Checked = false;

            clsCtrl.setListBox(dtEndCustomer, clbCustomer, true);
            sEndCustomer = CString.GetCheckedListValue(dtCustomer, clbCustomer.ControlValues);

                                                                        
                                                                                                                                                        

            SetChangeControl("UserSiteByEndCustomer", sDivision, string.Empty, sEndCustomer);
            clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);

            if (sDivision.IndexOf("81") != -1)
            {
                                                                            
                                                                                                                                                                 

                SetChangeControl("UserPlantSiteByEndCustomer", sDivision, string.Empty, sEndCustomer);
                clsCtrl.setListBox(dtPlantSite, clbPlantSite, true);
            }

            dtBucketType = GetBucketType();
            clsCtrl.setListBox(dtBucketType, cboBucketType, false, "CODE", "NAME");

            drpPeriod.InitValue = GetDayRange();

            dtItemType = GetItemType();
            clsCtrl.setListBox(dtItemType, clbItemType, true);

            System.Windows.Forms.ToolTip toolTip1 = new System.Windows.Forms.ToolTip();
            toolTip1.SetToolTip(btnColumn, "Column Show");
            toolTip1.SetToolTip(btnMeasure, "Measure");

                                                                                                   
                                                                                    
                                                                            
            layoutControlItem7.ContentVisible = false;
                                                                          
                                                                                  
                                                                                            
                                                                                                 
                                       
            lciASCheck.ContentVisible = false;

            if ((clbDivision.ControlValues.Substring(0, 2) == "81") || (clbDivision.ControlValues == "82"))
            {
                dtSalesSite = GetSalesSite(clbDivision.ControlValues, clbCustomer.ControlValues, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
            }
            else
            {
                dtSalesSite = GetSalesSite40(clbTeam.ControlValues, clbCustomer.ControlValues, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
            }
                                                                                          
        }

        private void DefineProperty()
        {
            usrConditionPanel1.Height = 108;
            cboBucketType.ControlValues = BucketType.Weekly;
            siMain.ImagePopUp = imageList1.Images[0];

            cellTypeImage = new TextCellType();
            cellTypeImage.BackgroundImage = new FarPoint.Win.Picture(siMain.ImagePopUp);
            cellTypeImage.BackgroundImage.AlignHorz = FarPoint.Win.HorizontalAlignment.Right;
            cellTypeImage.CharacterCasing = CharacterCasing.Upper;

            CanModelChange = true;

            layoutControlItem6.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
                                   
            switch (UserInfoContext.Current["NowGroupID"])
            {
                case "ADMIN":
                case "DM ADMIN":
                    btnIncotermsChg.Enabled = true;
                    btnIncotermsChg.Visible = true;
                    layoutControlItem6.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Always;
                    layoutControlItem7.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Always;
                    break;
                case "DM Planner":
                    btnIncotermsChg.Enabled = true;
                    btnIncotermsChg.Visible = true;
                    layoutControlItem7.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Always;
                    break;
                default:
                    btnIncotermsChg.Enabled = false;
                    btnIncotermsChg.Visible = false;
                    layoutControlItem6.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
                    layoutControlItem7.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
                    break;
            }

            FarPoint.Win.Spread.Model.DefaultSheetDataModel dsdm = (FarPoint.Win.Spread.Model.DefaultSheetDataModel)siMain.Sheet(SpdSheet.shtMain).Models.Data;
            dsdm.Changed += new FarPoint.Win.Spread.Model.SheetDataModelEventHandler(spdMain_Changed);

            clbDivision.SelectedIndexChanged += new System.EventHandler(cboDivision_SelectedIndexChanged);
            cboBucketType.SelectedIndexChanged += new System.EventHandler(cboBucketType_SelectedIndexChanged);
        }

        private void CreateSpread()
        {
            this.AddSheet(spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20);
            siMain = GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex);
            siMain.ChangeSheet();

                                                                                        
            string stype = "LOAD";
            InitSpread(stype);
                                                                                      
        }

                                                                                                
        private void InitSpread(string sType)
        {
                                                                                          
            string stype = sType;
            GetSpdTitle(stype);
                                                                                         
            siMain.CreateSheetHeaderColumn(siMain, 3, dtTitle);

            if (dtTitle != null && dtTitle.Rows.Count > 0)
            {
                SetSpreadHeaderSpan(dtTitle);
                SetSpreadColumn();
                InitSpreadFooterSum();
            }
        }

        private void InitSpreadFooterSum()
        {
            int iStCol = siMain.GetColumnIndex(DefColumns.Measure) + 1;
            siMain.ActiveSheet.ColumnFooter.Visible = true;
            siMain.ActiveSheet.ColumnFooter.Cells[0, 1].Value = "Sum";
            FarPoint.Win.BevelBorder bevelbrdr = new FarPoint.Win.BevelBorder(FarPoint.Win.BevelBorderType.Raised, Color.FromArgb(158, 182, 206), Color.FromArgb(158, 182, 206), 1, false, false, true, false);

            for (int iCol = iStCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
            {
                                                                                                                                                                    
                if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 || siMain.GetColumnTag(iCol).IndexOf("M_") == 0 || siMain.GetColumnTag(iCol).IndexOf("W_") != -1)
                {
                    siMain.ActiveSheet.ColumnFooter.SetAggregationFormat(0, iCol, "{0:#,##0.###}");
                    siMain.ActiveSheet.ColumnFooter.SetAggregationType(0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden);
                    siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor = Color.LightGray;
                    siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].Border = bevelbrdr;
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
            int iSmallStartCol = siMain.GetColumnIndex(DefColumns.Measure) + 1;
            int iLargeStartCol = siMain.GetColumnIndex(DefColumns.Measure) + 1;
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

            siMain.Freeze(0, siMain.GetColumnIndex(DefColumns.Measure) + 1);

            siMain.SmartColMerge();
        }

        private void InitSaveDataTable()
        {
            dtSave = new DataTable("MktFcstSave");
            dtSave.Columns.Add(CAppSetting.StringAction, typeof(string));
            dtSave.Columns.Add(DefColumns.Division, typeof(string));
            dtSave.Columns.Add(DefColumns.Project, typeof(string));
            dtSave.Columns.Add(DefColumns.ScmSiteId, typeof(string));
            dtSave.Columns.Add(DefColumns.ItemId, typeof(string));
            dtSave.Columns.Add(DefColumns.DomExp, typeof(string));
            dtSave.Columns.Add(DefColumns.Incoterms, typeof(string));
            dtSave.Columns.Add(DefColumns.FcstType, typeof(string));
            dtSave.Columns.Add(DefColumns.Measure, typeof(string));
            dtSave.Columns.Add(DefColumns.PlantSiteId, typeof(string));

            dtSave.Columns.Add(DefColumns.YYYYMMDD, typeof(string));
            dtSave.Columns.Add(DefColumns.Qty, typeof(int));
            dtSave.Columns.Add(DefColumns.Customer40, typeof(string));
            dtSave.Columns.Add(DefColumns.ScmSiteId40, typeof(string));
            dtSave.Columns.Add(DefColumns.ItemId40, typeof(string));
                                                             
            dtSave.Columns.Add(DefColumns.AS_FROM_SITE, typeof(string));

            dtSaveFinal = new DataTable("MktFcstSave");
            dtSaveFinal.Columns.Add(DefColumns.Division, typeof(string));
            dtSaveFinal.Columns.Add(DefColumns.Project, typeof(string));
            dtSaveFinal.Columns.Add(DefColumns.ScmSiteId, typeof(string));
            dtSaveFinal.Columns.Add(DefColumns.ItemId, typeof(string));
            dtSaveFinal.Columns.Add(DefColumns.DomExp, typeof(string));
            dtSaveFinal.Columns.Add(DefColumns.Incoterms, typeof(string));
            dtSaveFinal.Columns.Add(DefColumns.FcstType, typeof(string));
            dtSaveFinal.Columns.Add(DefColumns.Measure, typeof(string));
            dtSaveFinal.Columns.Add(DefColumns.PlantSiteId, typeof(string));
            dtSaveFinal.Columns.Add(DefColumns.YYYYMMDD, typeof(string));

            dtSaveFinal.Columns.Add(DefColumns.Qty, typeof(int));
            dtSaveFinal.Columns.Add(DefColumns.Customer40, typeof(string));
            dtSaveFinal.Columns.Add(DefColumns.ScmSiteId40, typeof(string));
            dtSaveFinal.Columns.Add(DefColumns.ItemId40, typeof(string));

                                                             
            dtSaveFinal.Columns.Add(DefColumns.AS_FROM_SITE, typeof(string));
                                                           
        }
        #endregion

        #region  4. Button

        protected override void FindButton()
        {
                                                        
            FindData();
        }

        protected override void InsertButton()
        {
            InsertRow();
        }

        protected override void DeleteButton()
        {
            if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI)
            {
                siMain.DeleteRow();
            }
        }

        protected override void EditButton()
        {
            if (this.fps != null)
            {               
                                                                                                                                              
                if (UserInfoContext.Current["NowGroupID"] == "SCP Planner" && ((clbDivision.ControlValues.Substring(0, 2) == "82") || (clbDivision.ControlValues.Substring(0, 2) == "40")))
                {
                    MessageHelper.GMessageBox("MSG00096");                 
                    return;
                }
                                                                                                                                      

                                                              
                                                                                                          
                dtDM_UI_EDITABLE_DIVISION = GetLookupValues("DM_UI_EDITABLE_DIVISION", "DMF0003", clbDivision.ControlValues, "", "", "");
                if (dtDM_UI_EDITABLE_DIVISION != null
                    && dtDM_UI_EDITABLE_DIVISION.Rows.Count > 0
                    && dtDM_UI_EDITABLE_DIVISION.Columns.Contains("EDIT_YN")
                    && dtDM_UI_EDITABLE_DIVISION.Rows[0]["EDIT_YN"].String() == "N")
                {
                    MessageHelper.GMessageBox("MSG00448");
                    return;
                }     

                                                                                                                                         
                if (UserInfoContext.Current["NowGroupID"] == "SCP Planner" && clbDivision.ControlValues.Substring(0, 2) == "81")
                {
                    DataTable dtMktFcstEditFlag = null;
                    dtMktFcstEditFlag = GetLookupValues("SCP_PLANNER_EDIT_FLAG", "DMF0003", clbDivision.ControlValues, UserInfoContext.Current["NowGroupID"].ToString(), "", "");

                    if ((dtMktFcstEditFlag == null) || (dtMktFcstEditFlag.Rows.Count == 0))
                    {
                        MessageHelper.GMessageBox("MSG00477");                                        
                        return;
                    }
                }
                                                                                                                                

                                                                                                                       
                if (UserInfoContext.Current["NowGroupID"] == "DM Planner" || UserInfoContext.Current["NowGroupID"] == "DM Planner (W/S)" || UserInfoContext.Current["NowGroupID"] == "DM ADMIN" && clbDivision.ControlValues.Substring(0, 2) == "81")
                {
                    DataTable dtPlannerFcstEditFlag = null;
                    dtPlannerFcstEditFlag = GetLookupValues("DM_PLANNER_EDIT_FLAG", "DMF0003", clbDivision.ControlValues, UserInfoContext.Current["NowGroupID"].ToString(), "", "");

                    if (dtPlannerFcstEditFlag.Rows.Count > 0)
                    {
                        MessageHelper.GMessageBox("MSG00478", new object[] { dtPlannerFcstEditFlag.Rows[0]["LIMIT_AUTH"].ToString(), dtPlannerFcstEditFlag.Rows[0]["EDIT_DAYS"].ToString(), dtPlannerFcstEditFlag.Rows[0]["FROM_TIME"].ToString(), dtPlannerFcstEditFlag.Rows[0]["TO_TIME"].ToString(), dtPlannerFcstEditFlag.Rows[0]["AUTH"].ToString() });
                        return;
                    }
                }
                                                                                                                                

                                                                                                                                     
                if (UserInfoContext.Current["NowGroupID"] == "DM Planner" || UserInfoContext.Current["NowGroupID"] == "DM Planner (W/S)" || UserInfoContext.Current["NowGroupID"] == "DM ADMIN")
                {
                    if (clbDivision.ControlValues.Substring(0, 2) == "81" || clbDivision.ControlValues == "82")
                    {
                        if (siMain.GetColumnIndex(DefColumns.AS_FROM_SITE) < 0)
                        {
                            MessageHelper.GMessageBox("MSG00113");                   
                            return;
                        }
                    }
                }
                                                                                                                                   

                                   
                if (clbDivision.ControlValues.Substring(0, 2) == "81")
                {
                    if (siMain.GetColumnIndex(DefColumns.Division) < 0 || siMain.GetColumnIndex(DefColumns.Project) < 0
                    || siMain.GetColumnIndex(DefColumns.ScmSiteId) < 0 || siMain.GetColumnIndex(DefColumns.ItemId) < 0
                    || siMain.GetColumnIndex(DefColumns.DomExp) < 0 || siMain.GetColumnIndex(DefColumns.FcstType) < 0
                    || siMain.GetColumnIndex(DefColumns.Incoterms) < 0 || siMain.GetColumnIndex(DefColumns.Measure) < 0
                    || siMain.GetColumnIndex(DefColumns.PlantSiteId) < 0)
                    {
                        MessageHelper.GMessageBox("MSG00113");
                        return;
                    }
                }
                if (clbDivision.ControlValues == "82")
                {
                    if (siMain.GetColumnIndex(DefColumns.Division) < 0 || siMain.GetColumnIndex(DefColumns.Project) < 0
                    || siMain.GetColumnIndex(DefColumns.ScmSiteId) < 0 || siMain.GetColumnIndex(DefColumns.ItemId) < 0
                    || siMain.GetColumnIndex(DefColumns.DomExp) < 0 || siMain.GetColumnIndex(DefColumns.FcstType) < 0
                    || siMain.GetColumnIndex(DefColumns.Incoterms) < 0 || siMain.GetColumnIndex(DefColumns.Measure) < 0)
                    {
                        MessageHelper.GMessageBox("MSG00113");
                        return;
                    }
                }
                else if (clbDivision.ControlValues == "40")
                {
                    if (siMain.GetColumnIndex(DefColumns.Division40) < 0 || siMain.GetColumnIndex(DefColumns.Customer40) < 0
                    || siMain.GetColumnIndex(DefColumns.ScmSiteId40) < 0 || siMain.GetColumnIndex(DefColumns.ItemId40) < 0
                    || siMain.GetColumnIndex(DefColumns.DomExp) < 0 || siMain.GetColumnIndex(DefColumns.FcstType) < 0
                    || siMain.GetColumnIndex(DefColumns.Incoterms) < 0 || siMain.GetColumnIndex(DefColumns.Measure) < 0)
                    {
                        MessageHelper.GMessageBox("MSG00113");
                        return;
                    }
                }

                                                                                                       
                       
                                                                                                                               
                                                                                                                             
                                                                        
                                                                                                                          
                        
                        
                                                                 
                                  
                        
                    

                           
                                                   
                if ((dt8Week == null) || (dt8Week.Rows.Count == 0))
                {
                    MessageHelper.GMessageBox("MSG00259");
                    return;
                }

                siMain = GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex);
                siMain.SwitchLock();

                                                                          
                                                                                         

                DateTime dateTime = DateTime.Today.AddDays(Convert.ToInt32(DayOfWeek.Monday) - Convert.ToInt32(DateTime.Today.DayOfWeek));
                string sYYYYMMDD = dateTime.ToString("yyyyMMdd");
                int iResultCol = siMain.GetColumnIndex(DefColumns.Measure) + 1;
                int iResultMonth = siMain.GetColumnIndex(DefColumns.Measure) + 1;
                                                                                
                string[] sPeriod = drpPeriod.ControlValues.Split(':');               

                for (int iCol = siMain.GetColumnIndex(DefColumns.Measure) + 1; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                {
                    if (cboBucketType.ControlValues == BucketType.Daily)
                    {
                        if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0)
                        {
                            if (!siMain.IsLock(siMain.SheetName))
                            {
                                if (int.Parse(sYYYYMMDD) > int.Parse(siMain.GetColumnTag(iCol).Replace("D_", "")))
                                    siMain.LockColumn(iCol, iCol, true);
                            }
                            else
                                siMain.LockColumn(iCol, iCol, true);

                            if (int.Parse(sYYYYMMDD) > int.Parse(siMain.GetColumnTag(iCol).Replace("D_", "")))
                                iResultCol = iCol;
                        }
                        else
                        {
                            siMain.LockColumn(iCol, iCol, true);

                            if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                            {
                                if (int.Parse(sYYYYMMDD.Substring(0, 6)) == int.Parse(siMain.GetColumnTag(iCol).Replace("M_", "")))
                                    iResultMonth = iCol;
                            }
                        }
                    }
                    else if (cboBucketType.ControlValues == BucketType.Weekly)
                    {
                        if (siMain.GetColumnTag(iCol).IndexOf("W_") != -1)
                        {
                            if (!siMain.IsLock(siMain.SheetName))
                            {
                                                                                      
                                if (int.Parse(sYYYYMMDD) > int.Parse(siMain.GetColumnTag(iCol + 1).Replace("D_", "")))
                                    siMain.LockColumn(iCol, iCol, true);

                                                                                                 
                                                                        
                                  
                                                              
                                                                                                                                 
                                                                                                                                    
                                                                                                                                                   
                                                                                                                
                                                                                                           
 
                                                               
                                                                             
                                                                                              
                                                                             
                                   
                            }
                            else
                                siMain.LockColumn(iCol, iCol, true);
                        }
                        else
                        {
                            if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0)
                            {
                                if (int.Parse(sYYYYMMDD) > int.Parse(siMain.GetColumnTag(iCol).Replace("D_", "")))
                                {
                                    iResultCol = iCol;

                                                                                                     
                                                       
                                                                           
                                                                              
                                }

                                                                                                 
                                                                       
                                  
                                                              
                                                                                                                                 
                                                                                                                                                   
                                                                                                                
                                                                                                           
                                                                                             
                                                                             
                                   
                            }

                            if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                            {
                                if (int.Parse(sYYYYMMDD.Substring(0, 6)) == int.Parse(siMain.GetColumnTag(iCol).Replace("M_", "")))
                                    iResultMonth = iCol;

                                                                                                 
                                                   
                                                                       
                                                                          
                            }
                                                                                             
                                                                     
                            siMain.LockColumn(iCol, iCol, true);

                        }
                    }
                    else if (cboBucketType.ControlValues == BucketType.Monthly)
                    {
                        if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                        {
                            if (!siMain.IsLock(siMain.SheetName))
                            {
                                if (int.Parse(sYYYYMMDD.Substring(0, 6)) > int.Parse(siMain.GetColumnTag(iCol).Replace("M_", "")))
                                    siMain.LockColumn(iCol, iCol, true);

                                if (int.Parse(sYYYYMMDD.Substring(0, 6)) == int.Parse(siMain.GetColumnTag(iCol).Replace("M_", "")))
                                    iResultMonth = iCol;

                                if (clbDivision.ControlValues == "40")
                                {
                                                       
                                    DateTime thisColDt = Convert.ToDateTime(siMain.GetColumnText(0, iCol) + "-01");
                                    DateTime stdDT = Convert.ToDateTime(dt8Week.Rows[0]["MONTH_NAME"].ToString() + "-01");
                                    if (stdDT >= thisColDt)
                                        siMain.LockColumn(iCol, iCol, true);
                                }
                            }
                            else
                            {
                                siMain.LockColumn(iCol, iCol, true);
                            }
                        }
                        else
                        {
                            if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0)
                            {
                                if (int.Parse(sYYYYMMDD) > int.Parse(siMain.GetColumnTag(iCol).Replace("D_", "")))
                                {
                                    iResultCol = iCol;

                                                       
                                    if (clbDivision.ControlValues == "40")
                                        siMain.LockColumn(iCol, iCol, true);
                                }
                                if (clbDivision.ControlValues == "40")
                                {
                                    DateTime thisColDt = Convert.ToDateTime(siMain.GetColumnText(0, iCol) + "-01");
                                    DateTime stdDT = Convert.ToDateTime(dt8Week.Rows[0]["MONTH_NAME"].ToString() + "-01");
                                    if (stdDT < thisColDt)
                                        siMain.LockColumn(iCol, iCol, true);
                                }
                            }

                                                       
                            if ((clbDivision.ControlValues == "40") && (siMain.GetColumnTag(iCol).IndexOf("W_") != -1))
                            {
                                siMain.LockColumn(iCol, iCol, true);
                            }

                            if (clbDivision.ControlValues != "40")
                                siMain.LockColumn(iCol, iCol, true);
                        }
                    }
                }

                for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
                {
                                                                              
                                                                                                
                    siMain.LockRange(iRow, 0, iRow, siMain.GetColumnIndex(DefColumns.Measure), true);

                       
                                                     
                                                                                                                                    
                                                                      
                      

                                                                                                                                                                                                                 
                    if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToString() != CAppSetting.StringY)
                    {
                        if (string.IsNullOrEmpty(siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction))))
                            siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.Measure) + 1, iRow, siMain.GetMaxColumnIndex(), true);
                        else if (siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI && IsEditMode == true)
                        {
                            #region 칼럼 정보 확인  이 코드 왜 있을까???
                            if (siMain.GetMaxRowIndex() > 0)
                            {
                                if (siMain.GetColumnIndex(DefColumns.SoldToCustomer) > 0)
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.SoldToCustomer), iRow, siMain.GetColumnIndex(DefColumns.SoldToCustomer), true);
                            }

                            if (siMain.GetColumnIndex(DefColumns.Project) > 0)
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.Project), iRow, siMain.GetColumnIndex(DefColumns.Project), false);
                            if (siMain.GetColumnIndex(DefColumns.ProjectName) > 0)
                                siMain.LockRange(0, siMain.GetColumnIndex(DefColumns.ProjectName), siMain.GetMaxRowIndex(), siMain.GetColumnIndex(DefColumns.ProjectName), true);
                            if (siMain.GetColumnIndex(DefColumns.ProjectStatus) > 0)
                                siMain.LockRange(0, siMain.GetColumnIndex(DefColumns.ProjectStatus), siMain.GetMaxRowIndex(), siMain.GetColumnIndex(DefColumns.ProjectStatus), true);
                            if (siMain.GetColumnIndex(DefColumns.CellType) > 0)
                                siMain.LockRange(0, siMain.GetColumnIndex(DefColumns.CellType), siMain.GetMaxRowIndex(), siMain.GetColumnIndex(DefColumns.CellType), true);
                            if (siMain.GetColumnIndex(DefColumns.BizType) > 0)
                                siMain.LockRange(0, siMain.GetColumnIndex(DefColumns.BizType), siMain.GetMaxRowIndex(), siMain.GetColumnIndex(DefColumns.BizType), true);
                            if (siMain.GetColumnIndex(DefColumns.Country) > 0)
                                siMain.LockRange(0, siMain.GetColumnIndex(DefColumns.Country), siMain.GetMaxRowIndex(), siMain.GetColumnIndex(DefColumns.Country), true);
                            if (siMain.GetColumnIndex(DefColumns.CountryName) > 0)
                                siMain.LockRange(0, siMain.GetColumnIndex(DefColumns.CountryName), siMain.GetMaxRowIndex(), siMain.GetColumnIndex(DefColumns.CountryName), true);
                            if (siMain.GetColumnIndex(DefColumns.City) > 0)
                                siMain.LockRange(0, siMain.GetColumnIndex(DefColumns.City), siMain.GetMaxRowIndex(), siMain.GetColumnIndex(DefColumns.City), true);
                            if (siMain.GetColumnIndex(DefColumns.CityName) > 0)
                                siMain.LockRange(0, siMain.GetColumnIndex(DefColumns.CityName), siMain.GetMaxRowIndex(), siMain.GetColumnIndex(DefColumns.CityName), true);
                            if (siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting.StringI)
                                siMain.LockRange(0, siMain.GetColumnIndex(DefColumns.Measure), siMain.GetMaxRowIndex(), siMain.GetColumnIndex(DefColumns.Measure), true);
                            if (siMain.GetColumnIndex(DefColumns.ItemId) > 0)
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.ItemId), iRow, siMain.GetColumnIndex(DefColumns.ItemId), false);
                            if (siMain.GetColumnIndex(DefColumns.ItemId40) > 0)
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.ItemId40), iRow, siMain.GetColumnIndex(DefColumns.ItemId40), false);
                            if (siMain.GetColumnIndex(DefColumns.ItemName) > 0)
                                siMain.LockRange(0, siMain.GetColumnIndex(DefColumns.ItemName), siMain.GetMaxRowIndex(), siMain.GetColumnIndex(DefColumns.ItemName), true);
                            if (siMain.GetColumnIndex(DefColumns.ItemType) > 0)
                                siMain.LockRange(0, siMain.GetColumnIndex(DefColumns.ItemType), siMain.GetMaxRowIndex(), siMain.GetColumnIndex(DefColumns.ItemType), true);
                            if (siMain.GetColumnIndex(DefColumns.NickName) > 0)
                                siMain.LockRange(0, siMain.GetColumnIndex(DefColumns.NickName), siMain.GetMaxRowIndex(), siMain.GetColumnIndex(DefColumns.NickName), true);
                            if (siMain.GetColumnIndex(DefColumns.ProjectOwner) > 0)
                                siMain.LockRange(0, siMain.GetColumnIndex(DefColumns.ProjectOwner), siMain.GetMaxRowIndex(), siMain.GetColumnIndex(DefColumns.ProjectOwner), true);
                            if (siMain.GetColumnIndex(DefColumns.VMI_YN) > 0)
                                siMain.LockRange(0, siMain.GetColumnIndex(DefColumns.VMI_YN), siMain.GetMaxRowIndex(), siMain.GetColumnIndex(DefColumns.VMI_YN), true);
                            if (siMain.GetColumnIndex(DefColumns.Owner) != -1)
                                siMain.LockRange(0, siMain.GetColumnIndex(DefColumns.Owner), siMain.GetMaxRowIndex(), siMain.GetColumnIndex(DefColumns.Owner), true);

                            siMain.LockRange(0, siMain.GetColumnIndex(DefColumns.MeasureGroup), siMain.GetMaxRowIndex(), siMain.GetColumnIndex(DefColumns.MeasureGroup), true);
                            #endregion

                            int iStartCol = siMain.GetColumnIndex(DefColumns.Measure) + 1;

                            int iResultCol2 = iStartCol;
                            int iResultMonth2 = iStartCol;

                            for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                            {
                                if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 && int.Parse(sResultYYYYMMDD) > int.Parse(siMain.GetColumnTag(iCol).Replace("D_", "")))
                                    iResultCol2 = iCol;

                                if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 && int.Parse(sResultYYYYMMDD.Substring(0, 6)) == int.Parse(siMain.GetColumnTag(iCol).Replace("M_", "")))
                                    iResultMonth2 = iCol;
                            }

                            if (iResultCol2 > iStartCol)
                            {
                                siMain.LockRange(iRow, iStartCol, iRow, iResultCol2, true);

                                if (chkColor.Checked == true)
                                {
                                    siMain.SetBGColor(0, iStartCol, siMain.GetMaxRowIndex(), iResultCol2, Color.Gainsboro);
                                    siMain.SetBGColor(0, iResultMonth2, siMain.GetMaxRowIndex(), iResultMonth2, Color.White);
                                }
                                else if (chkColor.Checked == false)
                                {
                                    FarPoint.Win.BevelBorder bevelbrdr = new FarPoint.Win.BevelBorder(FarPoint.Win.BevelBorderType.Raised, Color.Green, Color.Green, 3, true, false, false, false);
                                    if (siMain.GetColumnIndex(this_YYYYMMWW) > 0)
                                    {
                                        if (count >= 2)
                                        {
                                                                                          
                                                                                                              
                                               
                                                                                                                
                                                                                                                                    
                                         

                                                                      
                                                                       
                                                                                                         
                                                                                                                             
                                                                                   
                                                    
                                                       
              
                                                                       
                                         

                                            if (int.Parse(sPeriod[0]) > int.Parse(sResultYYYYMMDD))
                                            {
                                                siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border = bevelbrdr;
                                            }
                                            else
                                            {
                                                sResult_YYYYMMWW = "W_" + sResultYYYYMMDD.Substring(0, 6) + iso_week;
                                                siMain.ActiveSheet.Columns[siMain.GetColumnIndex(sResult_YYYYMMWW)].Border = bevelbrdr;
                                            }
                                                                                        
                                        }
                                        else
                                        {
                                            siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border = bevelbrdr;
                                        }
                                    }
                                    if (siMain.GetColumnIndex("D_" + sResultYYYYMMDD) > 0)
                                        siMain.ActiveSheet.Columns[siMain.GetColumnIndex("D_" + sResultYYYYMMDD)].Border = bevelbrdr;
                                }
                                iStartCol = iResultCol2;
                            }

                                          
                            for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                            {
                                if (cboBucketType.ControlValues == BucketType.Daily)
                                {
                                    if (siMain.GetColumnTag(iCol).IndexOf("D_") != 0)
                                        siMain.LockRange(iRow, iCol, iRow, iCol, true);
                                }
                                else if (cboBucketType.ControlValues == BucketType.Weekly)
                                {
                                    if (siMain.GetColumnTag(iCol).IndexOf("W_") != 0)
                                        siMain.LockRange(iRow, iCol, iRow, iCol, true);
                                }
                                else if (cboBucketType.ControlValues == BucketType.Monthly)
                                {
                                    if (siMain.GetColumnTag(iCol).IndexOf("M_") != 0)
                                        siMain.LockRange(iRow, iCol, iRow, iCol, true);
                                }
                            }

                            if ((clbDivision.ControlValues.Substring(0, 2) == "81") || (clbDivision.ControlValues == "82"))
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.Division), siMain.GetMaxRowIndex(), siMain.GetColumnIndex(DefColumns.Division), true);
                            else
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.Division40), siMain.GetMaxRowIndex(), siMain.GetColumnIndex(DefColumns.Division40), true);
                        }
                    }
                }

                if (chkColor.Checked == true)
                {
                    if (siMain.GetMaxRowIndex() >= 0)
                        siMain.SetBGColor(0, siMain.GetColumnIndex(DefColumns.Measure) + 1, siMain.GetMaxRowIndex(), iResultCol, Color.Gainsboro);

                    if (siMain.GetMaxRowIndex() >= 0)
                        siMain.SetBGColor(0, iResultMonth, siMain.GetMaxRowIndex(), iResultMonth, Color.White);
                }
                else if (chkColor.Checked == false)
                {
                    FarPoint.Win.BevelBorder bevelbrdr = new FarPoint.Win.BevelBorder(FarPoint.Win.BevelBorderType.Raised, Color.Green, Color.Green, 3, true, false, false, false);
                    if (siMain.GetColumnIndex(this_YYYYMMWW) > 0)
                    {
                        if (count >= 2)
                        {
                            {
                                                                              
                                                                                                  
                                   
                                                                                                      
                                                                                                                        
                                  

                                                          
                                                             
                                                                                                                                
                                                                                                                                                    
                                                                                                          
                                                                           
                                                                              
 
                                                                                              
                                  

                                if (int.Parse(sPeriod[0]) > int.Parse(sResultYYYYMMDD))
                                {
                                    siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border = bevelbrdr;
                                }
                                else
                                {
                                    sResult_YYYYMMWW = "W_" + sResultYYYYMMDD.Substring(0, 6) + iso_week;
                                    siMain.ActiveSheet.Columns[siMain.GetColumnIndex(sResult_YYYYMMWW)].Border = bevelbrdr;
                                }
                                                                            
                            }
                        }
                        else
                        {
                            siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border = bevelbrdr;
                        }
                    }
                    if (siMain.GetColumnIndex("D_" + sResultYYYYMMDD) > 0)
                        siMain.ActiveSheet.Columns[siMain.GetColumnIndex("D_" + sResultYYYYMMDD)].Border = bevelbrdr;
                }
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
                                                                                
           
 
                                                                                  
                                              
          
                                  
          
 
                      
                          
             
                       
                                                                              
                                                                                                                               
          
 
                                                            
                                                                                               
                
              
                                         
                                                                
                                                                                      
 
                                          
 
                            
                                                                 
 
                                
                                                  
 
                             
                                                                      
                                                    
 
                                         
                  
                                 
                            
                  
 
                                              
                                   
 
                                     
                                           
                                                            
                                                    
 
                                                                        
                                           
                                                                  
                                                          
                                                                                 
                  
                                                                                    
                  
                     
                                                                                
 
                                                         
 
                                                                                 
                  
                                                                                                              
                  
                     
                  
                                                                                                        
                  
 
                                           
 
                                                                                              
                  
                                                                                                                 
                                                          
 
                                            
                      
                                             
                      
                                                                                                                                
 
                                                                                                                                                                                                                
                                             
                                                                         
 
                                                    
                                                 
                                                                                           
 
                                          
                                                                        
                      
                                                                       
                                      
                                                                              
                                                                              
                                                               
                                                                             
                                                   
                                                                  
                          
                                                           
                          
                                                                                                                            
                          
                                                           
                          
                                                                                        
                          
                                                           
                          
                             
                          
                                                                      
                              
                                                                                                                                        
                                  
                                                                       
                                      
                                                                                   
 
                                                                                                                                 
                                                                                   
                                      
                                  
                                                                                                                                                        
                                  
                                                                       
                                      
                                                                                   
 
                                                                                                                                 
                                                                                   
                                      
                                  
                                     
                                  
                                                                                     
                                                                          
                                  
                              
                          
                      
 
                                       
                                                                     
                      
                                                                                                       
                          
                                                        
                          
                      
 
                                                                                           
 
                                                       
                                         
                      
                                                                    
                          
                                                             
                              
                                                                                                                        
                                                                       
                              
                          
                      
 
                                                                                 
                      
                                                                
                          
                                                                                                  
                              
                                                                   
                                                     
                                       
                              
                          
                             
                          
                                                                                            
                              
                                                                       
                                                     
                                       
                              
                          
                      
 
                                             
 
                                    
                      
                                             
                          
                                                              
                                                                    
                                                                                   
                                                         
                                                        
                                       
                                                                  
                                     
                                                         
                                                      
                                       
                          
                      
                  
                                                        
                                                                     
                  
                                                                                                        
                  
                                                                           
                  
                                                                                                        
                  
                                                                            
                  
                                                                                                           
                  
 
                                               
 
                                                                          
 
                                                                                                             
 
                                                                     
 
                                   
                                                    
 
                                                           
 
                            
                                                                                        
                  
                                                            
                  
 
                                                        
                                                 
                                                                                                       
                                                                                                                                                                                           
                                                                                                                                                                                          
                                                                                                             
                                                                                                                                             
                                                                                                                 
 
                                       
                                                                  
 
                                                             
 
              
                                
              
                                           
                                                                                   
              
                    
              
                             
              
          
          
                                                                                
        #endregion

        #region 5. Logic

                                                                            
        DataSet dsMain = null;

        private async void FindData()
        {
            CanModelChange = false;

            GSCM.Windows.Forms.UI.ProgressForm prg = new GSCM.Windows.Forms.UI.ProgressForm();
            try
            {
                string sDivision = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);
                string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);

                string sInvalidExec = (checkInvalidExec.Checked == true) ? "Y" : "N";                                                     

                if (sDivision == "")
                {
                    MessageHelper.GMessageBox("MSG00097");

                    return;
                }

                var asyncProxy = new FoxAsyncProxy(this);

                string[] sPeriod = drpPeriod.ControlValues.Split(':');

                if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1]))
                {
                    MessageHelper.GMessageBox("MSG00108");
                    return;
                }

                if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2)
                {
                    MessageHelper.GMessageBox("MSG00164");

                    drpPeriod.Value2 = drpPeriod.Value1.AddYears(2);

                    return;
                }

                prg.Show();

                                                                                            
                string stype = ""; 
                InitSpread(stype);
                                                                                          

                                 
                SearchStartTime();

                                     

                asyncProxy.ShowProgress = false;

                var ds = await asyncProxy.ExecuteAsync<DataSet>(() =>
                {
                    using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
                    {
                        var request = new FoxDataRequest("DM.DMF0003_GET_MKT_FCST_DATA");
                                                                                             

                        request.CommandTimeout = 30 * 60;

                        request.Parameters["p_division_id"] = sDivision;                                 
                        request.Parameters["p_scm_site_id"] = clbSalesSite.ControlValues;
                        request.Parameters["p_plant_site_id"] = clbPlantSite.ControlValues;
                        request.Parameters["p_team_id"] = clbTeam.ControlValues;
                        request.Parameters["p_customer"] = clbCustomer.ControlValues;
                        request.Parameters["p_biz_type"] = clbBizType.ControlValues;
                        request.Parameters["p_project_code"] = txtProject.Text;
                        request.Parameters["p_item_id"] = txtItemId.Text;
                        request.Parameters["p_from_yyyymmdd"] = sPeriod[0];
                        request.Parameters["p_to_yyyymmdd"] = sPeriod[1];
                        request.Parameters["p_created_by"] = base.UserInfo.UserId;
                        request.Parameters["p_user_group"] = UserInfoContext.Current["NowGroupID"].ToString();
                        request.Parameters["p_item_type"] = clbItemType.ControlValues;
                        request.Parameters["p_owner"] = txtOwner.Text.Trim();
                        request.Parameters["p_qty_yn"] = (cboQty.Checked == true) ? "Y" : "N";
                        request.Parameters["p_cell_yn"] = (cboCellQty.Checked == true) ? "Y" : "N";
                        request.Parameters["p_invalid_exec"] = sInvalidExec;                                                     
                                                                                                                
                                                                                                                                                   
                        request.Parameters["p_as_yn"] = UserInfoContext.Current["NowGroupID"] == "DM Planner (W/S)" ? "Y" : "N";
                                                                                                              
                        request.Parameters["p_user_dept_id"] = UserInfoContext.Current["Dept_ID"].ToString();                   
                        request.Parameters["p_sender_code"] = clbEDISender.ControlValues;                    

                        var response = client.ExecuteDataSet(request);

                        return response.DataSet;
                                                 
                    }
                });

                if (ds.Tables.Count >= 2)
                    dt8Week = ds.Tables[1];

                                              
                SearchEndTime();

                                                                                          
                dsMain = ds;
                Draw();
                                                                                        
                                   
                   
                                                     
 
                                          
                  
                                                      
 
                                                
                        
                                                               
                                                                            
                            
                                                                                                 
                                
                                                                                   
 
                                         
                                
 
                                                  
                                                                                                                                                              
                                   
                                                                                                                                                                               
                            
 
                        
                           
                        
                                                                                        
                            
                                                                                        
                                
                                                                                   
 
                                         
                                
 
                                                  
                                                                                             
                                   
                                                                                                              
                            
                        
 
                                                      
                                                              
 
                                          
                                                       
 
                                            
                                                        
                                                                                                
                                            
                                                       
                                                         
                                                                             
                  
 
                                                 
                  
                                                                                      
                                                                            
                  
 
                                                  
                  
                                       
                                    
                                         
 
                                                                                   
 
                                                
                                                  
                               
 
                                                                                           
                      
                                                                                                                                                                 
                                               
 
                                                                                                                                                                                  
                                                 
 
                                                                                                                                
                                     
                      
 
                                                  
                      
                                                    
                          
                                                                                                                   
                                                                                                                    
                          
                      
                                                        
                      
                                                                                                                                                                                        
                                                                             
                          
                                                                          
                              
                                                
                                  
                                                                                                          
                                                                                                                            
                                  
                                     
                                  
                                                                                                                         
                                  
                              
                          
                                                                                  
                          
                                                                                   
                                                                                                                              
                          
                      
                  
 
                                                                                                           
                                                            
                  
                                                                                
                      
                                                                                                                        
                                          
                          
                                                                   
                                                                      
                              
                                                       
                                  
                                                                                   
                                                                                                       
 
                                                                                         
                                                                                                        
 
                                                  
                                      
                                                                                       
                                      
                                  
                              
                          
                      
                  
                  
                                                      
                               
                UIEndTime();

                CanModelChange = true;

                sDefaultDay = Data.Common(Data.Type.DefaultBucketDay, false, sDivision, cboBucketType.ControlValues).Rows[0][0].ToString();
            }
            catch (Exception ex)
            {
                MessageHelper.GMessageBoxForException(ex);
            }
            finally
            {
                prg.Close();

                siMain.SpreadObject.ResumeLayout();
            }

        }
                                                                                  
        void Draw()
        {
            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);
            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);
            string[] sPeriod = drpPeriod.ControlValues.Split(':');

            DataSet ds = dsMain;
            if (ds.Tables[1] != null)
                this_YYYYMMWW = "W_" + DateTime.Today.ToString("yyyyMM") + ds.Tables[1].Rows[0]["ISO_WEEK"].ToString();

            if (ds.Tables[0] != null)
            {
                siMain.Query(ds.Tables[0].DataSet);
                siMain.SmartColMerge();
                siMain.SpreadObject.SuspendLayout();
                siMain.LockColumn2(0, siMain.GetMaxColumnIndex(), true);
            }

            if (ds.Tables[2].Rows.Count > 0)
            {
                this_YYYYMMWW = ds.Tables[2].Rows[0]["THIS_YYYYMMWW"].ToString();
                iso_week = ds.Tables[2].Rows[0]["ISO_WEEK"].ToString();
            }

            if (siMain.GetMaxRowIndex() > 0)
            {
                                              
                siMain.SmartColMerge();

                SetSearchCount(ds);
            }

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

            if (siMain.GetMaxRowIndex() >= 0)
            {
                SetSpreadColumn();
                dtSave.Clear();
                dtSaveFinal.Clear();

                int iStartCol = siMain.GetColumnIndex(DefColumns.Measure) + 1;

                int iResultCol = iStartCol;
                int iResultMonth = iStartCol;
                count = 0;

                for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                {
                    if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 && int.Parse(sResultYYYYMMDD) > int.Parse(siMain.GetColumnTag(iCol).Replace("D_", "")))
                        iResultCol = iCol;

                    if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 && int.Parse(sResultYYYYMMDD.Substring(0, 6)) == int.Parse(siMain.GetColumnTag(iCol).Replace("M_", "")))
                        iResultMonth = iCol;

                    if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0 && iso_week == siMain.GetColumnTag(iCol).Substring(8))
                        count++;
                }

                if (chkColor.Checked == true)
                {
                    if (iResultCol > iStartCol)
                    {
                        siMain.SetBGColor(0, iStartCol, siMain.GetMaxRowIndex(), iResultCol, Color.Gainsboro);
                        siMain.SetBGColor(0, iResultMonth, siMain.GetMaxRowIndex(), iResultMonth, Color.White);
                    }
                }
                else if (chkColor.Checked == false)
                {
                    FarPoint.Win.BevelBorder bevelbrdr = new FarPoint.Win.BevelBorder(FarPoint.Win.BevelBorderType.Raised, Color.Green, Color.Green, 3, true, false, false, false);
                    if (cboBucketType.ControlValues != BucketType.Daily)
                    {
                        if (siMain.GetColumnIndex(this_YYYYMMWW) > 0)
                        {
                            if (count >= 2)
                            {
                                                                              
                                                                                                  
                                   
                                                                                                    
                                                                                                                        
                             

                                                          
                                                           
                                                                                                                              
                                                                                                                                                  
                                                                                                        
                                                                         
                                                                            
 
                                                                                            
                                  

                                if (int.Parse(sPeriod[0]) > int.Parse(sResultYYYYMMDD))
                                {
                                    siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border = bevelbrdr;
                                }
                                else
                                {
                                    sResult_YYYYMMWW = "W_" + sResultYYYYMMDD.Substring(0, 6) + iso_week;
                                    siMain.ActiveSheet.Columns[siMain.GetColumnIndex(sResult_YYYYMMWW)].Border = bevelbrdr;
                                }
                                                                            
                            }
                            else
                            {
                                siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border = bevelbrdr;
                            }
                        }
                    }
                    else if (cboBucketType.ControlValues == BucketType.Daily)
                    {
                        if (siMain.GetColumnIndex("D_" + sResultYYYYMMDD) > 0)
                            siMain.ActiveSheet.Columns[siMain.GetColumnIndex("D_" + sResultYYYYMMDD)].Border = bevelbrdr;
                    }
                }
            }

                                                                                                       
            if (sDivision == "40" || sDivision == "82")
            {
                for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
                {
                    string sAttr1 = siMain.GetText(iRow, siMain.GetColumnIndex("ATTR1"));                           
                    if (sAttr1 != "")
                    {
                        string[] sarAttr1 = sAttr1.Split('^');
                        for (int i = 0; i < sarAttr1.Length; i++)
                        {
                            if (sarAttr1[i] != "")
                            {
                                string sAttr1_YMD = sarAttr1[i].Split('/')[0];
                                string sAttr1_AP = sarAttr1[i].Split('/')[1];                      

                                int iCol = siMain.GetColumnIndex("D_" + sAttr1_YMD);
                                Color cA = (sAttr1_AP == "A") ? Color.PaleGreen : Color.PapayaWhip;

                                if (iCol > 0)
                                {
                                    siMain.SetBGColor(iRow, iCol, iRow, iCol, cA);
                                }
                            }
                        }
                    }
                }
            }

            SetSpreadColumn();
            siMain.SpreadObject.ResumeLayout();
        }
                                                                                

        private async void SaveData()
        {
            if (siMain != null && siMain.IsLock(siMain.SheetName) == false)
            {
                if (siMain.SheetName == SpdSheet.shtMain)
                {
                                                                                                                                                                      
                    string sProcedureName = "DM.DMF0003_SAVE_MKT_FCST";

                    string sActionFlag = string.Empty;
                    string sDivision = string.Empty;
                    string sProjectCode = string.Empty;
                    string sSiteId = string.Empty;
                    string sItemId = string.Empty;
                    string sDomExp = string.Empty;
                    string sFcstType = string.Empty;
                    string sIncoterms = string.Empty;
                    string sMeasure = string.Empty;
                    string sPlantSiteId = string.Empty;
                    string sYYYYMMDD = string.Empty;
                    string sQty = string.Empty;
                    string sUserId = string.Empty;
                    string sASFromSite = string.Empty;
                    string sAuthority = string.Empty;                                          
                    sAuthority = UserInfoContext.Current["NowGroupID"].ToString();                                          

                    int iCount = 0;

                    bool bInputCheck = false;

                                                                         
                    string sBucket = cboBucketType.ControlValues;

                                            
                    if (!fnValidation(out bInputCheck))
                    {
                        MessageHelper.GMessageBox("MSG00043");
                        return;
                    }

                    if (!bInputCheck)
                    {
                        MessageHelper.GMessageBox("MSG00034");
                        return;
                    }

                                                          
                    foreach (DataRow dr in dtSaveFinal.Rows)
                    {
                        if (iCount == 0)
                        {
                            sActionFlag = CAppSetting.StringM;
                            if ((clbDivision.ControlValues.Substring(0, 2) == "81") || (clbDivision.ControlValues == "82"))
                            {
                                sDivision = dr[DefColumns.Division].ToString();
                                sProjectCode = dr[DefColumns.Project].ToString();
                                sSiteId = dr[DefColumns.ScmSiteId].ToString();
                                sItemId = dr[DefColumns.ItemId].ToString();
                            }
                            else
                            {
                                sDivision = dr[DefColumns.Division].ToString();
                                sProjectCode = dr[DefColumns.Customer40].ToString();
                                sSiteId = dr[DefColumns.ScmSiteId40].ToString();
                                sItemId = dr[DefColumns.ItemId40].ToString();
                            }

                            sDomExp = dr[DefColumns.DomExp].ToString();
                            sFcstType = dr[DefColumns.FcstType].ToString();
                            sIncoterms = dr[DefColumns.Incoterms].ToString();
                            sMeasure = dr[DefColumns.Measure].ToString();
                            sPlantSiteId = dr[DefColumns.PlantSiteId].ToString();
                            sYYYYMMDD = dr[DefColumns.YYYYMMDD].ToString();
                            sQty = dr[DefColumns.Qty].ToString();
                            sUserId = base.UserInfo.UserId;
                                                                                              
                                                                               
                            sASFromSite = dr[DefColumns.AS_FROM_SITE].ToString();
                                                                             

                                                                                                                                                                                
                            if (UserInfoContext.Current["NowGroupID"] == "DM Planner (W/S)")
                            {
                                if (clbDivision.ControlValues.Substring(0, 2) == "81" || clbDivision.ControlValues == "82")
                                {
                                                                                               
                                    DataTable dtAsSalesSite = null;
                                    dtAsSalesSite = Data.Common(Data.Type.AS_FROM_SITE, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division)).ToString(), "", "", "", "");

                                                                                     
                                    DataTable dtAsFcstType = null;
                                    dtAsFcstType = GetFcstType();

                                                                                 
                                    if (dtAsSalesSite.Select("Name = '" + (sSiteId) + "'").Length == 0)
                                    {
                                                                                          
                                        if (dtAsFcstType.Select("Code = '" + (sFcstType) + "'").Length > 0)
                                        {
                                                                                              
                                            if (sASFromSite == "")
                                            {
                                                MessageHelper.GMessageBox("MSG00476");                                                                       
                                                return;
                                            }
                                        }
                                    }
                                }
                            } 
                                                                                                                                                                              
                        }
                        else
                        {
                            sActionFlag = sActionFlag + "^" + CAppSetting.StringM;
                            if ((clbDivision.ControlValues.Substring(0, 2) == "81") || (clbDivision.ControlValues == "82"))
                            {
                                sDivision = sDivision + "^" + dr[DefColumns.Division].ToString();
                                sProjectCode = sProjectCode + "^" + dr[DefColumns.Project].ToString();
                                sSiteId = sSiteId + "^" + dr[DefColumns.ScmSiteId].ToString();
                                sItemId = sItemId + "^" + dr[DefColumns.ItemId].ToString();
                            }
                            else
                            {
                                sDivision = sDivision + "^" + dr[DefColumns.Division].ToString();
                                sProjectCode = sProjectCode + "^" + dr[DefColumns.Customer40].ToString();
                                sSiteId = sSiteId + "^" + dr[DefColumns.ScmSiteId40].ToString();
                                sItemId = sItemId + "^" + dr[DefColumns.ItemId40].ToString();
                            }

                            sDomExp = sDomExp + "^" + dr[DefColumns.DomExp].ToString();
                            sFcstType = sFcstType + "^" + dr[DefColumns.FcstType].ToString();
                            sIncoterms = sIncoterms + "^" + dr[DefColumns.Incoterms].ToString();
                            sMeasure = sMeasure + "^" + dr[DefColumns.Measure].ToString();
                            sPlantSiteId = sPlantSiteId + "^" + dr[DefColumns.PlantSiteId].ToString();
                            sYYYYMMDD = sYYYYMMDD + "^" + dr[DefColumns.YYYYMMDD].ToString();
                            sQty = sQty + "^" + dr[DefColumns.Qty].ToString();
                            sUserId = sUserId + "^" + base.UserInfo.UserId;
                                                                                                                    
                                                                               
                            sASFromSite = sASFromSite + "^" + dr[DefColumns.AS_FROM_SITE].ToString();
                                                                             

                                                                                                                                                                                
                            if (UserInfoContext.Current["NowGroupID"] == "DM Planner (W/S)")
                            {
                                if (clbDivision.ControlValues.Substring(0, 2) == "81" || clbDivision.ControlValues == "82")
                                {
                                                                                               
                                    DataTable dtAsSalesSite = null;
                                    dtAsSalesSite = Data.Common(Data.Type.AS_FROM_SITE, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division)).ToString(), "", "", "", "");

                                                                                     
                                    DataTable dtAsFcstType = null;
                                    dtAsFcstType = GetFcstType();

                                                                                 
                                    if (dtAsSalesSite.Select("Name = '" + (sSiteId) + "'").Length == 0)
                                    {
                                                                                          
                                        if (dtAsFcstType.Select("Code = '" + (sFcstType) + "'").Length > 0)
                                        {
                                                                                              
                                            if (sASFromSite == "")
                                            {
                                                MessageHelper.GMessageBox("MSG00476");                                                                       
                                                return;
                                            }
                                        }
                                    }
                                }
                            }
                                                                                                                                                                              
                        }
                        iCount++;
                    }

                                                                                
                       
                                                                                   
                      
                                                                              
                    sASFromSite = sASFromSite.Replace(",", "^");

                                                                                
                       
                                                                       
                      
                                                               
                                
                      
                      
                                                                              

                    if (iCount > 0)
                    {
                        try
                        {
                            var asyncProxy = new FoxAsyncProxy(this);

                                                                                    
                                
                            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
                            {
                                var request = new FoxDataRequest(sProcedureName);
                                request.Parameters["p_active_flag"] = sActionFlag;
                                request.Parameters["p_division_id"] = sDivision;
                                request.Parameters["p_project_code"] = sProjectCode;
                                request.Parameters["p_scm_site_id"] = sSiteId;
                                request.Parameters["p_item_id"] = sItemId;
                                request.Parameters["p_dom_exp"] = sDomExp;
                                request.Parameters["p_fcst_type"] = sFcstType;
                                request.Parameters["p_incoterms"] = sIncoterms;
                                request.Parameters["p_measure"] = sMeasure;
                                request.Parameters["p_plant_site_id"] = sPlantSiteId;
                                request.Parameters["p_yyyymmdd"] = sYYYYMMDD;
                                request.Parameters["p_qty"] = sQty;
                                request.Parameters["p_created_by"] = sUserId;
                                request.Parameters["p_as_from_site"] = sASFromSite;                                               
                                request.Parameters["p_bucket"] = sBucket;                                                                
                                request.Parameters["p_authority"] = sAuthority;                                              

                                request.CommandTimeout = 10 * 60;

                                var response = client.ExecuteDataSet(request);

                                                               
                                                     
                                if (response.DataSet.Tables.Count != 0)
                                {
                                    MessageHelper.GMessageBox(response.DataSet.Tables[0].Rows[0][0].ToString());

                                                                                               
                                    if (response.DataSet.Tables.Count > 1 && response.DataSet.Tables[1].Rows.Count > 0)
                                    {
                                        DMF0003_SspSyncPopUp popup = new DMF0003_SspSyncPopUp();
                                        popup.LoadData(response.DataSet.Tables[1], "40");
                                        popup.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                                        popup.ShowDialog();

                                    }
                                }
                                else
                                {
                                    MessageHelper.GMessageBox("MSG00004", new object[] { iCount });
                                    int iTopRow = siMain.SpreadObject.GetViewportTopRow(0);
                                    FindData();
                                    siMain.SpreadObject.SetViewportTopRow(0, iTopRow);
                                    base.IsChange = false;
                                }
                                                            

                                   
                                                                        
                                  
                                                                                                                 
                                  
                                     
                                  
                                                                                                    
 
                                                                                            
 
                                                
 
                                                                                       
 
                                                           
                                  
                                  
                            };
                        }
                        catch (Exception ex)
                        {
                            MessageHelper.GMessageBoxForException(ex);
                        }
                        finally
                        {
                            dtSaveFinal.Clear();
                        }
                    }
                    else
                    {
                        MessageHelper.GMessageBox("MSG00034");
                    }
                }
            }
        }

        private void SetSaveSheetColor()
        {
                                                   

            for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
            {
                if (siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringM
                    || siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI)
                {
                    siMain.SetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction), "");
                    siMain.SetBGColor(iRow, siMain.GetColumnIndex(CAppSetting.StringAction), iRow, siMain.GetColumnIndex(CAppSetting.StringAction), ControlColor.UnLockColor);
                    siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.Measure) + 1, iRow, siMain.GetMaxColumnIndex(), true, Color.Red, ControlColor.UnLockColor);
                                                                                                                    
                                                                                                                    
                    break;
                }
            }

                                                  
        }

        private void InsertRow()
        {
                                                                                                      
            if (UserInfoContext.Current["NowGroupID"] == "SCP Planner" && (clbDivision.ControlValues.Substring(0, 2) == "81"))
            {
                MessageHelper.GMessageBox("MSG00096");                 
                return;
            }
                                                                                                    

            if (siMain != null && siMain.IsLock(siMain.SheetName) == false)
            {
                if (siMain.SheetName == SpdSheet.shtMain)
                {
                    siMain.SpreadObject.SuspendLayout();
                    FarPoint.Win.Spread.Cell insCell = siMain.Insert();
                    Dictionary<object, object> defaultData = new Dictionary<object, object>();

                    #region 칼럼 세팅
                    int iActRow = siMain.ActiveRowIndex;
                    int iRowCount = siMain.GetMaxRowIndex();

                    if ((clbDivision.ControlValues.Substring(0, 2) == "81") || (clbDivision.ControlValues == "82"))
                                                             
                    {
                        if (siMain.GetColumnIndex(DefColumns.Project) != -1)
                            siMain.ActiveSheet.Cells[iActRow, siMain.GetColumnIndex(DefColumns.Project)].CellType = cellTypeImage;
                        if (siMain.GetColumnIndex(DefColumns.ItemId) != -1)
                            siMain.ActiveSheet.Cells[iActRow, siMain.GetColumnIndex(DefColumns.ItemId)].CellType = cellTypeImage;
                        if (siMain.GetColumnIndex(DefColumns.Division) != -1)
                            siMain.SetValue(iActRow, siMain.GetColumnIndex(DefColumns.Division), clbDivision.ControlValues);
                    }
                    else
                    {
                        if (siMain.GetColumnIndex(DefColumns.ItemId40) != -1)
                            siMain.ActiveSheet.Cells[iActRow, siMain.GetColumnIndex(DefColumns.ItemId40)].CellType = cellTypeImage;
                        if (siMain.GetColumnIndex(DefColumns.Division40) != -1)
                            siMain.SetValue(iActRow, siMain.GetColumnIndex(DefColumns.Division40), clbDivision.ControlValues);

                                                                           
                        DataTable dtCustomsHandbook = GetCustomsHandbook();
                        siMain.SetCellTypeCombo(iActRow, siMain.GetColumnIndex(DefColumns.DomExp), dtCustomsHandbook);
                    }

                    if (siMain.GetColumnIndex(DefColumns.PlantSiteId) >= 0)
                        siMain.SetCellTypeCombo(iActRow, siMain.GetColumnIndex(DefColumns.PlantSiteId), dtPlantSite);         

                    string sTeam = "ALL";
                    string sDivision = clbDivision.ControlValues;
                    string sEndCustomer = string.Empty;

                    if (siMain.GetColumnIndex(DefColumns.Team) != -1)
                        sTeam = siMain.GetValue(iActRow, siMain.GetColumnIndex(DefColumns.Team)).ToString();

                                                                                        
                    DataTable dtTeamAuth, dtEndCustomerAuth, dtSalesSiteAuth = null;
                    dtTeamAuth = Data.UserTeamByDivisionAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision);

                                                                                                    
                                                                                
                                                                                          
                                                                                                                                              

                                                                                
                    DataTable dtWarrType = null;
                    if (UserInfoContext.Current["NowGroupID"].ToString() == "DM Planner (W/S)")
                    {
                        dtWarrType = GetLookupValues("FCST_TYPE", "EDIT_MODE", "", "", "", "");
                        siMain.SetCellTypeCombo(iActRow, siMain.GetColumnIndex(DefColumns.FcstType), dtWarrType);
                    }
                    else
                    {
                        dtWarrType = GetFcstType();
                        siMain.SetCellTypeCombo(iActRow, siMain.GetColumnIndex(DefColumns.FcstType), dtWarrType);
                    }

                                                                              

                                                                                
                    dtincotermsEditType = GetLookupValues("INCOTERMS", "ALL", "Y", "", "", "");
                    siMain.SetCellTypeCombo(iActRow, siMain.GetColumnIndex(DefColumns.Incoterms), dtincotermsEditType);
                                                                              

                                                                              
                    if (siMain.GetColumnIndex(DefColumns.AS_FROM_SITE) > 0)
                    {
                        dtAsFromSite = Data.Common(Data.Type.AS_FROM_SITE, false, sDivision, "", "", "", "");
                        siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE), dtAsFromSite);
                    }
                                                                            

                                   
                                                                               
                                                                                                   
                                                                                 
                                                                                                                    

                                                                                             
                    if (sDivision == "40")
                    {
                        dtEndCustomerAuth = Data.Common(Data.Type.EndCustomerByDivision40, false, "", sTeam, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
                        dtSalesSiteAuth = Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);

                        if (siMain.GetColumnIndex(DefColumns.Division40) != -1)
                            sDivision = siMain.GetValue(iActRow, siMain.GetColumnIndex(DefColumns.Division40)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.Customer40) != -1)
                            sEndCustomer = siMain.GetValue(iActRow, siMain.GetColumnIndex(DefColumns.Customer40)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.Team) != -1)
                            siMain.SetCellTypeCombo(iActRow, siMain.GetColumnIndex(DefColumns.Team), dtTeamAuth);
                        if (siMain.GetColumnIndex(DefColumns.Customer40) != -1)
                            siMain.SetCellTypeCombo(iActRow, siMain.GetColumnIndex(DefColumns.Customer40), dtEndCustomerAuth);
                        if (siMain.GetColumnIndex(DefColumns.ScmSiteId40) != -1)
                            siMain.SetCellTypeCombo(iActRow, siMain.GetColumnIndex(DefColumns.ScmSiteId40), dtSalesSiteAuth);

                        string sDivisionID = siMain.GetValue(iActRow, siMain.GetColumnIndex(DefColumns.Division40)).ToString();
                        string sScmSiteID = siMain.GetValue(iActRow, siMain.GetColumnIndex(DefColumns.ScmSiteId40)).ToString();

                        dtMeasure = Data.Common(Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, "", UserInfoContext.Current.UserId, "");
                        siMain.SetCellTypeCombo(iActRow, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure);
                    }
                    else
                    {
                        dtEndCustomerAuth = Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "");

                                                                                    
                                                                                                                                                                                                 
                        dtSalesSiteAuth = GetSalesSite(clbDivision.ControlValues, clbCustomer.ControlValues, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
                                                                                  

                        if (siMain.GetColumnIndex(DefColumns.Division) != -1)
                            sDivision = siMain.GetValue(iActRow, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.Customer) != -1)
                            sEndCustomer = siMain.GetValue(iActRow, siMain.GetColumnIndex(DefColumns.Customer)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.Team) != -1)
                            siMain.SetCellTypeCombo(iActRow, siMain.GetColumnIndex(DefColumns.Team), dtTeamAuth);
                        if (siMain.GetColumnIndex(DefColumns.Customer) != -1)
                            siMain.SetCellTypeCombo(iActRow, siMain.GetColumnIndex(DefColumns.Customer), dtEndCustomerAuth);
                        if (siMain.GetColumnIndex(DefColumns.ScmSiteId) != -1)
                            siMain.SetCellTypeCombo(iActRow, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSiteAuth);

                        string sDivisionID = siMain.GetValue(iActRow, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                        string sScmSiteID = siMain.GetValue(iActRow, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                        string sProjectCode = siMain.GetValue(iActRow, siMain.GetColumnIndex(DefColumns.Project)).ToString();

                        dtMeasure = Data.Common(Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, sProjectCode, UserInfoContext.Current.UserId, "");

                        if ((clbDivision.ControlValues.Substring(0, 2) == "81") || (clbDivision.ControlValues == "82"))
                        {
                                                                                                                        
                            if (UserInfoContext.Current["NowGroupID"] != "DM Planner (W/S)")
                            {
                                foreach (DataRow row in dtMeasure.Rows)
                                {
                                    if (row["Code"].ToString() == "AS_In_Req")
                                    {
                                        row.Delete();
                                    }
                                }
                                dtMeasure.AcceptChanges();
                            }
                                                                                                                      
                        }
                        siMain.SetCellTypeCombo(iActRow, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure);
                    }

                    siMain.SetValue(iActRow, siMain.GetColumnIndex(DefColumns.Measure), "MKT_FCST_RP");
                    #endregion

                    #region Measure 까지 칼럼 존재 확인 후 잠금
                    if (siMain.GetColumnIndex(DefColumns.Division) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.Division), iRowCount, siMain.GetColumnIndex(DefColumns.Division), true);
                    if (siMain.GetColumnIndex(DefColumns.Division40) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.Division40), iRowCount, siMain.GetColumnIndex(DefColumns.Division40), true);
                    if (siMain.GetColumnIndex(DefColumns.BizType) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.BizType), iRowCount, siMain.GetColumnIndex(DefColumns.BizType), true);
                    if (siMain.GetColumnIndex(DefColumns.SoldToCustomer) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.SoldToCustomer), iRowCount, siMain.GetColumnIndex(DefColumns.SoldToCustomer), true);
                    if (siMain.GetColumnIndex(DefColumns.CountryName) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.CountryName), iRowCount, siMain.GetColumnIndex(DefColumns.CountryName), true);
                    if (siMain.GetColumnIndex(DefColumns.CityName) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.CityName), iRowCount, siMain.GetColumnIndex(DefColumns.CityName), true);
                    if (siMain.GetColumnIndex(DefColumns.ProjectName) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.ProjectName), iRowCount, siMain.GetColumnIndex(DefColumns.ProjectName), true);
                    if (siMain.GetColumnIndex(DefColumns.ProjectStatus) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.ProjectStatus), iRowCount, siMain.GetColumnIndex(DefColumns.ProjectStatus), true);
                    if (siMain.GetColumnIndex(DefColumns.ProjectOwner) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.ProjectOwner), iRowCount, siMain.GetColumnIndex(DefColumns.ProjectOwner), true);
                    if (siMain.GetColumnIndex(DefColumns.ItemName) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.ItemName), iRowCount, siMain.GetColumnIndex(DefColumns.ItemName), true);
                    if (siMain.GetColumnIndex(DefColumns.NickName) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.NickName), iRowCount, siMain.GetColumnIndex(DefColumns.NickName), true);
                    if (siMain.GetColumnIndex(DefColumns.ItemType) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.ItemType), iRowCount, siMain.GetColumnIndex(DefColumns.ItemType), true);
                    if (siMain.GetColumnIndex(DefColumns.CUST_GROUP) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.CUST_GROUP), iRowCount, siMain.GetColumnIndex(DefColumns.CUST_GROUP), true);
                    if (siMain.GetColumnIndex(DefColumns.CUST_GROUP_DTL) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.CUST_GROUP_DTL), iRowCount, siMain.GetColumnIndex(DefColumns.CUST_GROUP_DTL), true);
                    if (siMain.GetColumnIndex(DefColumns.Owner) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.Owner), iRowCount, siMain.GetColumnIndex(DefColumns.Owner), true);
                    if (siMain.GetColumnIndex(DefColumns.APPLICATION) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.APPLICATION), iRowCount, siMain.GetColumnIndex(DefColumns.APPLICATION), true);
                    if (siMain.GetColumnIndex(DefColumns.ROUTE) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.ROUTE), iRowCount, siMain.GetColumnIndex(DefColumns.ROUTE), true);
                    if (siMain.GetColumnIndex(DefColumns.MDM_PROJECT_NAME) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.MDM_PROJECT_NAME), iRowCount, siMain.GetColumnIndex(DefColumns.MDM_PROJECT_NAME), true);
                    if (siMain.GetColumnIndex(DefColumns.MIN_CAPACITY) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.MIN_CAPACITY), iRowCount, siMain.GetColumnIndex(DefColumns.MIN_CAPACITY), true);
                    if (siMain.GetColumnIndex(DefColumns.FORECAST_INFO_BIZ_TYPE) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_BIZ_TYPE), iRowCount, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_BIZ_TYPE), true);
                    if (siMain.GetColumnIndex(DefColumns.CellType) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.CellType), iRowCount, siMain.GetColumnIndex(DefColumns.CellType), true);
                    if (siMain.GetColumnIndex(DefColumns.FORECAST_INFO_CELL_MODEL) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_CELL_MODEL), iRowCount, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_CELL_MODEL), true);
                    if (siMain.GetColumnIndex(DefColumns.FORECAST_INFO_CELL_PACK_COUNT) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_CELL_PACK_COUNT), iRowCount, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_CELL_PACK_COUNT), true);
                    if (siMain.GetColumnIndex(DefColumns.FORECAST_INFO_SPEC) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_SPEC), iRowCount, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_SPEC), true);
                    if (siMain.GetColumnIndex(DefColumns.VMI_YN) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.VMI_YN), iRowCount, siMain.GetColumnIndex(DefColumns.VMI_YN), true);
                    if (siMain.GetColumnIndex(DefColumns.DMS_SALES) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.DMS_SALES), iRowCount, siMain.GetColumnIndex(DefColumns.DMS_SALES), true);
                    if (siMain.GetColumnIndex(DefColumns.DMS_CUSTOMER) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.DMS_CUSTOMER), iRowCount, siMain.GetColumnIndex(DefColumns.DMS_CUSTOMER), true);
                    if (siMain.GetColumnIndex(DefColumns.AS_FROM_SITE) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE), iRowCount, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE), true);
                    if (siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), iRowCount, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), true);
                    if (siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), iRowCount, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), true);
                    if (siMain.GetColumnIndex(DefColumns.SENDER_CODE) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.SENDER_CODE), iRowCount, siMain.GetColumnIndex(DefColumns.SENDER_CODE), true);
                    if (siMain.GetColumnIndex(DefColumns.SENDER_NAME) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.SENDER_NAME), iRowCount, siMain.GetColumnIndex(DefColumns.SENDER_NAME), true);

                                                                                             
                                                                                           
                    if (siMain.GetColumnIndex(DefColumns.PROJECT_S_OP_REPORT) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.PROJECT_S_OP_REPORT), iRowCount, siMain.GetColumnIndex(DefColumns.PROJECT_S_OP_REPORT), true);
                                                                                           

                                                                                                                
                                                                                                              
                    if (siMain.GetColumnIndex(DefColumns.CELL_PER_MODULE) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.CELL_PER_MODULE), iRowCount, siMain.GetColumnIndex(DefColumns.CELL_PER_MODULE), true);
                                                                                                              

                    if (siMain.GetText(iActRow, siMain.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting.StringI)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.Measure), siMain.GetMaxRowIndex(), siMain.GetColumnIndex(DefColumns.Measure), true);

                                                                                 
                    if (siMain.GetColumnIndex(DefColumns.Team) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.Team), iRowCount, siMain.GetColumnIndex(DefColumns.Team), true);
                    if (siMain.GetColumnIndex(DefColumns.TeamName) > 0)
                        siMain.LockRange(iActRow, siMain.GetColumnIndex(DefColumns.TeamName), iRowCount, siMain.GetColumnIndex(DefColumns.TeamName), true);
                                                                               

                    #endregion Measure 까지 칼럼 존재 확인 후 잠금

                    #region Measure 이후 칼럼 잠금
                    DateTime dateTime = DateTime.Today.AddDays(Convert.ToInt32(DayOfWeek.Monday) - Convert.ToInt32(DateTime.Today.DayOfWeek));
                    string sResultYYYYMMDD = dateTime.ToString("yyyyMMdd");
                    int iStartCol = siMain.GetColumnIndex(DefColumns.Measure) + 1;
                    int iResultCol = iStartCol;
                    int iResultMonth = iStartCol;
                    int iRow = siMain.ActiveRowIndex;

                    if (chkColor.Checked == true)
                    {
                        for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                        {
                            if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 && int.Parse(sResultYYYYMMDD) > int.Parse(siMain.GetColumnTag(iCol).Replace("D_", "")))
                                iResultCol = iCol;

                            if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 && int.Parse(sResultYYYYMMDD.Substring(0, 6)) == int.Parse(siMain.GetColumnTag(iCol).Replace("M_", "")))
                                iResultMonth = iCol;
                        }

                        if (iResultCol > iStartCol)
                        {
                            siMain.LockRange(iRow, iStartCol, iRow, iResultCol, true);

                            siMain.SetBGColor(0, iStartCol, siMain.GetMaxRowIndex(), iResultCol, Color.Gainsboro);
                            siMain.SetBGColor(0, iResultMonth, siMain.GetMaxRowIndex(), iResultMonth, Color.White);

                            iStartCol = iResultCol;
                        }
                    }
                    else if (chkColor.Checked == false)
                    {
                        FarPoint.Win.BevelBorder bevelbrdr = new FarPoint.Win.BevelBorder(FarPoint.Win.BevelBorderType.Raised, Color.Green, Color.Green, 3, true, false, false, false);

                                                                                        
                        string[] sPeriod = drpPeriod.ControlValues.Split(':');
                        if (siMain.GetColumnIndex(this_YYYYMMWW) > 0)
                        {
                            if (count >= 2)
                            {
                                                                              
                                                                                                  
                                   
                                                                                                      
                                                                                                                        
                                  

                                                          
                                                           
                                                                                                                              
                                                                                                                                                  
                                                                                                        
                                                                         
                                                                            
 
                                                                                            
                                  

                                if (int.Parse(sPeriod[0]) > int.Parse(sResultYYYYMMDD))
                                {
                                    siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border = bevelbrdr;
                                }
                                else
                                {
                                    sResult_YYYYMMWW = "W_" + sResultYYYYMMDD.Substring(0, 6) + iso_week;
                                    siMain.ActiveSheet.Columns[siMain.GetColumnIndex(sResult_YYYYMMWW)].Border = bevelbrdr;
                                }
                                                                            
                            }
                            else
                            {
                                siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border = bevelbrdr;
                            }

                            if (cboBucketType.ControlValues == BucketType.Daily)
                                if (siMain.GetColumnIndex("D_" + sResultYYYYMMDD) > 0)
                                    siMain.ActiveSheet.Columns[siMain.GetColumnIndex("D_" + sResultYYYYMMDD)].Border = bevelbrdr;
                        }
                    }

                                  
                                    
                                                                                                 
                                                                                                     
                    for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                    {
                        if (cboBucketType.ControlValues == BucketType.Daily)
                        {
                            if (siMain.GetColumnTag(iCol).IndexOf("D_") != 0)
                                siMain.LockRange(iRow, iCol, iRow, iCol, true);
                        }
                        else if (cboBucketType.ControlValues == BucketType.Weekly)
                        {
                            if (siMain.GetColumnTag(iCol).IndexOf("W_") != -1)
                            {
                                if (!siMain.IsLock(siMain.SheetName))
                                {
                                                                                          
                                    if (int.Parse(sResultYYYYMMDD) > int.Parse(siMain.GetColumnTag(iCol + 1).Replace("D_", "")))
                                    {
                                        siMain.LockRange(iRow, iCol, iRow, iCol, true);
                                                             
                                    }

                                                                                                     
                                                              
                                                                                                                                 
                                                                                                                                                   
                                                                                                                
                                                                                                           
                                                                           
                                      
                                                                   
                                                                                            
                                                                                                  
                                                                                            
                                       
                                }
                                else
                                {
                                    siMain.LockRange(iRow, iCol, iRow, iCol, true);
                                }
                            }
                            else
                            {
                                if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0)
                                {
                                    if (int.Parse(sResultYYYYMMDD) > int.Parse(siMain.GetColumnTag(iCol).Replace("D_", "")))
                                    {
                                        iResultCol = iCol;

                                                                                                         
                                                           
                                                                               
                                                                                             
                                    }

                                                                                                     
                                                              
                                                                                                                                 
                                                                                                                                                   
                                                                                                                
                                                                                                           
                                                                                                                                    
                                                                                         
                                }

                                if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                                {
                                    if (int.Parse(sResultYYYYMMDD.Substring(0, 6)) == int.Parse(siMain.GetColumnTag(iCol).Replace("M_", "")))
                                    {
                                        iResultMonth = iCol;
                                    }

                                                                                                     
                                                       
                                                                           
                                                                                         
                                }

                                                                                                 
                                                                         
                                siMain.LockRange(iRow, iCol, iRow, iCol, true);

                            }
                        }
                        else if (cboBucketType.ControlValues == BucketType.Monthly)
                        {
                            if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                            {
                                if (!siMain.IsLock(siMain.SheetName))
                                {
                                    if (int.Parse(sResultYYYYMMDD.Substring(0, 6)) > int.Parse(siMain.GetColumnTag(iCol).Replace("M_", "")))
                                    {
                                        siMain.LockRange(iRow, iCol, iRow, iCol, true);
                                    }

                                    if (int.Parse(sResultYYYYMMDD.Substring(0, 6)) == int.Parse(siMain.GetColumnTag(iCol).Replace("M_", "")))
                                    {
                                        iResultMonth = iCol;
                                    }

                                                       
                                    DateTime thisColDt = Convert.ToDateTime(siMain.GetColumnText(0, iCol) + "-01");
                                    DateTime stdDT = Convert.ToDateTime(dt8Week.Rows[0]["MONTH_NAME"].ToString() + "-01");
                                    if ((clbDivision.ControlValues == "40") && (stdDT >= thisColDt))
                                        siMain.LockRange(iRow, iCol, iRow, iCol, true);
                                }
                                else
                                {
                                    siMain.LockRange(iRow, iCol, iRow, iCol, true);
                                }
                            }
                            else
                            {
                                if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0)
                                {
                                    if (int.Parse(sResultYYYYMMDD) > int.Parse(siMain.GetColumnTag(iCol).Replace("D_", "")))
                                    {
                                        iResultCol = iCol;

                                                           
                                        if (clbDivision.ControlValues == "40")
                                            siMain.LockRange(iRow, iCol, iRow, iCol, true);
                                    }

                                    DateTime thisColDt = Convert.ToDateTime(siMain.GetColumnText(0, iCol) + "-01");
                                    DateTime stdDT = Convert.ToDateTime(dt8Week.Rows[0]["MONTH_NAME"].ToString() + "-01");
                                    if ((clbDivision.ControlValues == "40") && (stdDT < thisColDt))
                                        siMain.LockRange(iRow, iCol, iRow, iCol, true);
                                }

                                                          
                                if ((clbDivision.ControlValues == "40") && (siMain.GetColumnTag(iCol).IndexOf("W_") != -1))
                                {
                                    siMain.LockRange(iRow, iCol, iRow, iCol, true);
                                }

                                if (clbDivision.ControlValues != "40")
                                    siMain.LockRange(iRow, iCol, iRow, iCol, true);
                            }
                        }
                    }
                    #endregion Measure 이후 칼럼 잠금

                    siMain.SpreadObject.ResumeLayout();
                }
            }
        }

        #endregion

        #region 6. Event
        private void cboDivision_SelectedIndexChanged(object sender, EventArgs e)
        {
            DataService.FP_Log2("SpeedUp", "DMF0003", "division_id_changed", "start");

            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);          
            string sEndCustomer = string.Empty;

                                                                                        
            string stype = "LOAD";
            InitSpread(stype);
                                                                                      
            InitSaveDataTable();

                                                                        
                                                                                                                                  

            SetChangeControl("UserTeamByDivision", sDivision);
            clsCtrl.setListBox(dtTeam, clbTeam, true);

            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);

            lblEDISender.Enabled = false;

                                                                        
                                            

            SetChangeControl("EdiSender", sDivision, sTeam);
            clsCtrl.setListBox(dtEdiSender, clbEDISender, true);

                                                                                     
            if (sDivision == "40")
            {
                lblProject.Enabled = false;
                lblPlantSite.Enabled = false;
                btnProject.Enabled = false;
                cboCellQty.Enabled = true;
                clbPlantSite.ControlValues = "";

                                                                            
                                                                                                                                                                                                 
                                                                       

                SetChangeControl("EndCustomerByDivision", sDivision, clbTeam.ControlValues);
                clsCtrl.setListBox(dtEndCustomer, clbCustomer, true);

                sEndCustomer = CString.GetCheckedListValue(dtCustomer40, clbCustomer.ControlValues);

                                                                            
                                                                                                                                                                                                                         
                                                                                                                                                     

                SetChangeControl("ScmSitebyEndCustomer40");
                clsCtrl.setListBox(dtSalesSite40, clbSalesSite, true);

                                                                            
                                                                                         

                SetChangeControl("BizType", clbDivision.ControlValues);
                clsCtrl.setListBox(dtBizType, clbBizType, true);

                                                                    
                checkInvalidExec.Enabled = false;
            }
            else
            {
                lblProject.Enabled = true;

                btnProject.Enabled = true;
                cboCellQty.Enabled = false;
                cboCellQty.Checked = false;

                                                                            
                                                                                                                                                            
                                                                     

                SetChangeControl("EndCustomerByDivision", sDivision, sTeam);

                clsCtrl.setListBox(dtEndCustomer, clbCustomer, true);

                sEndCustomer = CString.GetCheckedListValue(dtCustomer, clbCustomer.ControlValues);

                                                                            
                                                                                                                                                            

                                                                            
                   
                                                                                                  
                                                                     
                  

                dtSalesSite = GetSalesSite(clbDivision.ControlValues, clbCustomer.ControlValues, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
                clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);
                                                                          

                                                                            
                                                                               

                SetChangeControl("BizType", clbDivision.ControlValues);
                clsCtrl.setListBox(dtBizType, clbBizType, true);

                if (sDivision.IndexOf("81") != -1)
                {
                                                                                
                                                                                                                                                                                                            

                    SetChangeControl("UserPlantSiteByEndCustomer", sDivision, string.Empty, clbCustomer.ControlValues);
                    clsCtrl.setListBox(dtPlantSite, clbPlantSite, true);
                }

                                                                    
                if (sDivision == "82")
                {
                    checkInvalidExec.Enabled = true;
                    checkInvalidExec.Checked = true;
                    lblPlantSite.Enabled = false;
                    clbPlantSite.ControlValues = "";
                }
                else
                {
                    checkInvalidExec.Enabled = false;
                    checkInvalidExec.Checked = false;
                    lblPlantSite.Enabled = true;

                    if (sDivision == "81")
                    {
                        lblEDISender.Enabled = true;
                    }
                }
            }

                                                              
                                              
                   
            lblBizType.Enabled = true;

                                                                            
               
                                                                                                                                          
                                                                 
              
            this.txtProject.Text = "";
            this.txtItemId.Text = "";
            this.txtOwner.Text = "";

            DataService.FP_Log2("SpeedUp", "DMF0003", "division_id_changed", "end");
        }

        private void clbTeam_SelectedIndexChanged(object sender, EventArgs e)
        {
            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);
            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);

            if ((sDivision.Substring(0, 2) == "81") || (sDivision == "82"))
            {
                                                                            
                                                                                                                                                            
                                                                     

                SetChangeControl("EndCustomerByDivision", sDivision, sTeam);

                clsCtrl.setListBox(dtEndCustomer, clbCustomer, true);
                string sEndCustomer = CString.GetCheckedListValue(dtCustomer, clbCustomer.ControlValues);
                                                                            
                                                                                                                                                            

                SetChangeControl("UserSiteByEndCustomer", sDivision, string.Empty, sEndCustomer);
            }
            else
            {
                                                                            
                                                                                                                                                                                               
                                                                     

                SetChangeControl("EndCustomerByDivision", sDivision, clbTeam.ControlValues);
                clsCtrl.setListBox(dtEndCustomer, clbCustomer, true);

                                                                            
                                                                                                                                                                                                                       

                SetChangeControl("UserSiteByEndCustomer", sDivision, clbTeam.ControlValues, clbCustomer.ControlValues);
            }

            clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);
        }

        private void clbCustomer_SelectedIndexChanged(object sender, EventArgs e)
        {
            if ((clbDivision.ControlValues.Substring(0, 2) == "81") || (clbDivision.ControlValues == "82"))
            {
                dtSalesSite = GetSalesSite(clbDivision.ControlValues, clbCustomer.ControlValues, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
            }
            else
            {
                dtSalesSite = GetSalesSite40(clbTeam.ControlValues, clbCustomer.ControlValues, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
            }
            clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);
        }

        private void cboBucketType_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (siMain != null)
            {
                SetSpreadColumn();

                if (chkColor.Checked == false)
                {
                    FarPoint.Win.BevelBorder bevelbrdr = new FarPoint.Win.BevelBorder(FarPoint.Win.BevelBorderType.Raised, Color.Green, Color.Green, 3, true, false, false, false);
                    if (siMain.GetColumnIndex(this_YYYYMMWW) > 0)
                    {
                        if (cboBucketType.ControlValues == BucketType.Daily)
                        {
                            if (siMain.GetColumnIndex("D_" + sResultYYYYMMDD) > 0)
                                siMain.ActiveSheet.Columns[siMain.GetColumnIndex("D_" + sResultYYYYMMDD)].Border = bevelbrdr;
                            siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].ResetBorder();
                        }
                        else if (cboBucketType.ControlValues != BucketType.Daily)
                        {
                            if (siMain.GetColumnIndex(this_YYYYMMWW) > 0)
                            {
                                if (count >= 2)
                                {
                                                                                  
                                                                                                      
                                       
                                                                                                          
                                                                                                                            
                                      

                                                              
                                                               
                                                                                                                                  
                                                                                                                                                      
                                                                                                            
                                                                             
                                                                                
 
                                                                                                
                                      

                                                                                                    
                                    string[] sPeriod = drpPeriod.ControlValues.Split(':');
                                    if (int.Parse(sPeriod[0]) > int.Parse(sResultYYYYMMDD))
                                    {
                                        siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border = bevelbrdr;
                                    }
                                    else
                                    {
                                        sResult_YYYYMMWW = "W_" + sResultYYYYMMDD.Substring(0, 6) + iso_week;
                                        siMain.ActiveSheet.Columns[siMain.GetColumnIndex(sResult_YYYYMMWW)].Border = bevelbrdr;
                                    }
                                                                                
                                }
                                else
                                {
                                    siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border = bevelbrdr;
                                }
                            }
                            if (siMain.GetColumnIndex("D_" + sResultYYYYMMDD) > 0)
                                siMain.ActiveSheet.Columns[siMain.GetColumnIndex("D_" + sResultYYYYMMDD)].ResetBorder();
                        }
                    }
                }

                if (!siMain.IsLock(siMain.SheetName))
                {
                                                                   
                    EditButton();
                    EditButton();
                }
            }
        }

        private void spdMain_ComboSelChange(object sender, FarPoint.Win.Spread.EditorNotifyEventArgs e)
        {
            string sDivision = CAppSetting.StringALL;
            string sTeam = CAppSetting.StringALL;
            string sEndCustomer = CAppSetting.StringALL;

            if (e.Column == siMain.GetColumnIndex(DefColumns.Division))
            {
                sDivision = siMain.GetValue(e.Row, e.Column).ToString();

                if (siMain.GetColumnIndex(DefColumns.Team) > 0)
                {
                    dtTeamSpr = Data.UserTeamByDivisionAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision);

                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.Team), dtTeamSpr);

                    sTeam = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Team)).ToString();
                }

                if (siMain.GetColumnIndex(DefColumns.Customer) > 0)
                {
                    dtCustomer = Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam);
                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.Customer), dtCustomer);

                    sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Customer)).ToString();
                }

                if (siMain.GetColumnIndex(DefColumns.Customer40) > 0)
                {
                    if (sTeam == "")
                    {
                        sTeam = clbTeam.ControlValues;
                    }
                    dtCustomer40 = Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.Customer40), dtCustomer40);
                    sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Customer40)).ToString();
                }

                if ((clbDivision.ControlValues.Substring(0, 2) == "81") || (clbDivision.ControlValues == "82"))
                {
                    dtSalesSite = Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSite);
                }
                else
                {
                    dtSalesSite40 = Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId40), dtSalesSite40);
                }

                                                                                
                   
                                                                                                                                              
                                                                                                             

                dtBizType = GetBizTypebyDivision(clbDivision.ControlValues);
                clsCtrl.setListBox(dtBizType, clbBizType, true);

                if (sDivision != null && sDivision != "" && sDivision.Substring(0, 2) == "81")
                    siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PlantSiteId), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PlantSiteId), false);
                else
                    siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PlantSiteId), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PlantSiteId), true);

                if (siMain.GetColumnIndex(DefColumns.Division) != -1 && siMain.GetColumnIndex(DefColumns.ScmSiteId) != -1)
                {
                    string sDivisionID = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                    string sScmSiteID = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                    string sProjectCode = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Project)).ToString();

                    sScmSiteID = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                    dtMeasure = Data.Common(Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, sProjectCode, UserInfoContext.Current.UserId, "");
                    siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure);
                }
                if (siMain.GetColumnIndex(DefColumns.Division40) != -1 && siMain.GetColumnIndex(DefColumns.ScmSiteId40) != -1)
                {
                    string sDivisionID = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division40)).ToString();
                    string sScmSiteID = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ScmSiteId40)).ToString();

                    sScmSiteID = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ScmSiteId40)).ToString();
                    dtMeasure = Data.Common(Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, "", UserInfoContext.Current.UserId, "");
                    siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure);
                }

            }
            else if (e.Column == siMain.GetColumnIndex(DefColumns.Team))
            {
                if (siMain.GetColumnIndex(DefColumns.Customer) > 0)
                {
                    sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                    sTeam = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Team)).ToString();
                    dtCustomer = Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam);
                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.Customer), dtCustomer);

                    sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Customer)).ToString();
                    dtSalesSite = Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSite);
                }

                if (siMain.GetColumnIndex(DefColumns.Customer40) > 0)
                {
                    sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Division40)).ToString();
                    sTeam = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Team)).ToString();
                                                                                                                                                          
                    if (sTeam == "")
                    {
                        sTeam = clbTeam.ControlValues;
                    }
                    dtCustomer = Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);

                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.Customer40), dtCustomer);

                    sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Customer40)).ToString();
                    dtSalesSite = Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId40), dtSalesSite);
                }
            }
            else if (e.Column == siMain.GetColumnIndex(DefColumns.Customer))
            {
                sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Customer)).ToString();
                dtSalesSite = Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
                siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSite);
            }
            else if (e.Column == siMain.GetColumnIndex(DefColumns.Customer40))
            {
                sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Division40)).ToString();
                sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Customer40)).ToString();
                                                                                                                                                                
                dtSalesSite = Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
                siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId40), dtSalesSite);
            }
            else if (e.Column == siMain.GetColumnIndex(DefColumns.ScmSiteId))
            {
                if (siMain.GetColumnIndex(DefColumns.Project) > 0)
                    siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.Project), "");
                if (siMain.GetColumnIndex(DefColumns.ProjectName) > 0)
                    siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ProjectName), "");
                if (siMain.GetColumnIndex(DefColumns.ProjectStatus) > 0)
                    siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ProjectStatus), "");
                if (siMain.GetColumnIndex(DefColumns.BizType) > 0)
                    siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.BizType), "");

                if (siMain.GetColumnIndex(DefColumns.Division) != -1 && siMain.GetColumnIndex(DefColumns.ScmSiteId) != -1)
                {
                    string sDivisionID = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                    string sScmSiteID = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                    string sProjectCode = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Project)).ToString();

                    dtMeasure = Data.Common(Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, sProjectCode, UserInfoContext.Current.UserId, "");
                    siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure);

                    DataTable dtIncotermsType = GetIncotermsType(sDivisionID, sScmSiteID);
                    siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Incoterms), dtIncotermsType);
                }

                                                                                       
                if ((clbDivision.ControlValues.Substring(0, 2) == "81") || (clbDivision.ControlValues == "82"))
                {
                                                               
                    if (siMain.GetColumnIndex(DefColumns.AS_FROM_SITE) > 0)
                    {
                                                                                                 
                        DataTable dtAsSalesSite = null;
                        dtAsSalesSite = Data.Common(Data.Type.AS_FROM_SITE, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division)).ToString(), "", "", "", "");

                        DataTable dtAsFcstType = null;
                        dtAsFcstType = GetLookupValues("FCST_TYPE","DM Planner (W/S)", "", "", "", "");

                        string sDivisionID = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                        string sScmSiteID = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                        string sProjectCode = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Project)).ToString();

                        sScmSiteID = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                        dtMeasure = Data.Common(Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, sProjectCode, UserInfoContext.Current.UserId, "");

                        if (dtAsSalesSite.Select("Name = '" + (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString()) + "'").Length > 0)
                        {
                                                                                   
                            dtMeasure.AcceptChanges();
                            foreach (DataRow row in dtMeasure.Rows)
                            {
                                if (row["Code"].ToString() != "AS_In_Req")
                                {
                                    row.Delete();
                                }
                            }
                            dtMeasure.AcceptChanges();
                            siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure);
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.Measure), "");

                                                                                                   
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE), "");
                            siMain.LockRange(e.Row, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE), e.Row, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE), true);
                                                                                                 
                        }
                        else
                        {
                                                                                     
                            dtMeasure.AcceptChanges();
                            foreach (DataRow row in dtMeasure.Rows)
                            {
                                if (row["Code"].ToString() != "MKT_FCST_RP")
                                {
                                    row.Delete();
                                }
                            }
                            dtMeasure.AcceptChanges();
                            siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure);

                                                                                                             
                            if (dtAsFcstType.Select("Code = '" + (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FcstType)).ToString()) + "'").Length > 0)
                            {
                                siMain.LockRange(e.Row, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE), e.Row, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE), false);
                            }
                            else
                            {
                                siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE), "");
                                siMain.LockRange(e.Row, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE), e.Row, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE), true);
                            }
                                                                                                           
                        }
                                                                                                
                    }
                                                                                         
                }

            }
            else if (e.Column == siMain.GetColumnIndex(DefColumns.ScmSiteId40))
            {
                if (siMain.GetColumnIndex(DefColumns.Division40) != -1 && siMain.GetColumnIndex(DefColumns.ScmSiteId40) != -1)
                {
                    string sDivisionID = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division40)).ToString();
                    string sScmSiteID = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ScmSiteId40)).ToString();

                    dtMeasure = Data.Common(Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, "", UserInfoContext.Current.UserId, "");
                    siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure);
                }
            }

                                    
                                                                                        
            else if (e.Column == siMain.GetColumnIndex(DefColumns.Measure))
            {
                string item_Reset_Measure = string.Empty;
                item_Reset_Measure = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure)).ToString();
                                                                                                                              
                if (siMain.GetValue(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)).ToString() == "I")
                {
                    if (item_Reset_Measure != "AS_In_Req" && item_Reset_Measure != "BNPIn")
                    {
                                                                                        
                                                                                                     
                        if (siMain.GetColumnIndex(DefColumns.ItemId40) > 0)
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ItemId40), "");
                        if (siMain.GetColumnIndex(DefColumns.ItemId) > 0)
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ItemId), "");
                        if (siMain.GetColumnIndex(DefColumns.ItemName) > 0)
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ItemName), "");
                        if (siMain.GetColumnIndex(DefColumns.ItemType) > 0)
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ItemType), "");
                        if (siMain.GetColumnIndex(DefColumns.NickName) > 0)
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.NickName), "");
                    }
                }
            }
                                                                                              
            else if (e.Column == siMain.GetColumnIndex(DefColumns.FcstType))
            {
                DataTable dtAsFcstType = null;
                dtAsFcstType = GetLookupValues("FCST_TYPE", "DM Planner (W/S)", "", "", "", "");

                DataTable dtAsSalesSite = null;
                dtAsSalesSite = Data.Common(Data.Type.AS_FROM_SITE, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division)).ToString(), "", "", "", "");

                                                                                                          
                if (dtAsSalesSite.Select("Name = '" + (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString()) + "'").Length < 1)
                {
                                                                                      
                    if (dtAsFcstType.Select("Code = '" + (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FcstType)).ToString()) + "'").Length > 0)
                    {
                                                                                                                                      
                        if (siMain.GetColumnIndex(DefColumns.AS_FROM_SITE) > 0)
                        {
                            siMain.LockRange(e.Row, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE), e.Row, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE), false);
                        }
                        else
                        {
                                                                                                                                                                                                       
                            MessageHelper.GMessageBox("MSG00472");
                            return;
                        }
                    }
                    else
                    {
                                                                                                                                      
                        if (siMain.GetColumnIndex(DefColumns.AS_FROM_SITE) > 0)
                        {
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE), "");
                            siMain.LockRange(e.Row, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE), e.Row, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE), true);
                        }
                    }
                }
                else
                {
                                                                                                                                  
                    if (siMain.GetColumnIndex(DefColumns.AS_FROM_SITE) > 0)
                    {
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE), "");
                        siMain.LockRange(e.Row, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE), e.Row, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE), true);
                    }
                }
            }
                                                                                            
        }
        private void spdMain_CellDoubleClick(object sender, FarPoint.Win.Spread.CellClickEventArgs e)
        {
            if (e.ColumnHeader)
            {
                if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0)
                {
                    for (int iCol = e.Column; iCol < siMain.GetMaxColumnIndex(); iCol++)
                    {
                        if (siMain.GetColumnTag(iCol).IndexOf("W_") != -1)
                        {
                            siMain.ActiveSheet.Columns[iCol].Visible = !siMain.ActiveSheet.Columns[iCol].Visible;
                        }
                        else if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0)
                        {
                            if (siMain.ActiveSheet.Columns[iCol].Visible)
                            {
                                siMain.ActiveSheet.Columns[iCol].Visible = !siMain.ActiveSheet.Columns[iCol].Visible;
                            }
                        }

                        if (siMain.GetColumnTag(iCol + 1).IndexOf("M_") == 0)
                        {
                            break;
                        }
                    }
                }
                else if (siMain.GetColumnTag(e.Column).IndexOf("W_") != -1)
                {
                    for (int iCol = e.Column; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                    {
                        if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0)
                        {
                            siMain.ActiveSheet.Columns[iCol].Visible = !siMain.ActiveSheet.Columns[iCol].Visible;
                        }

                        if ((iCol <= siMain.GetMaxColumnIndex() - 1) && (siMain.GetColumnTag(iCol + 1).IndexOf("W_") == 0))
                        {
                            break;
                        }
                    }
                }
            }
            else
            {
                string sBucketType = cboBucketType.ControlValues;
                string sColName = siMain.GetColumnTag(e.Column);

                #region  [C20210112-000446].S : 동기화된 수량 내역 보여주는 팝업 창(MKT FCST, SSP수량)

                if ((sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0)
                    || (sBucketType == BucketType.Weekly && sColName.IndexOf("W_") != -1)
                    || (sBucketType == BucketType.Monthly && sColName.IndexOf("M_") == 0)
                    || ((sBucketType == BucketType.Weekly || sBucketType == BucketType.Monthly) && sColName.IndexOf("D_") == 0)
                    )
                {
                    string sMeasure = string.Empty;
                    string sAction = string.Empty;
                    string sDivision = clbDivision.ControlValues;
                    string sItemId = string.Empty;
                    string ScmSiteId = string.Empty;
                    string Team = string.Empty;
                    string Customer = string.Empty;
                    string Project = "ALL";                
                                                                         
                    string sDomExp = string.Empty;
                    string sFcstType = string.Empty;
                    string sIncoterms = string.Empty;
                    string sYyyymmdd = string.Empty;

                    sYyyymmdd = sColName.Substring(2, 8);

                    int iCol = e.Column;               

                    sAction = siMain.GetValue(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)).ToString();


                    if (siMain.GetColumnIndex(DefColumns.ScmSiteId40) >= 0)
                        ScmSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId40)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.Team) >= 0)
                        Team = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Team)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.Customer40) >= 0)
                        Customer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Customer40)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.Measure) >= 0)
                        sMeasure = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Measure)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.Project) >= 0)
                        Project = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Project)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.ItemId) > 0)
                        sItemId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ItemId)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.ItemId40) > 0)
                        sItemId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ItemId40)).ToString();

                                                                         
                    if (siMain.GetColumnIndex(DefColumns.DomExp) > 0)
                        sDomExp = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DomExp)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.FcstType) > 0)
                        sFcstType = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FcstType)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.Incoterms) > 0)
                        sIncoterms = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Incoterms)).ToString();

                    if (sDivision == "40" && sMeasure == "MKT_FCST_RP"
                            && (siMain.ActiveSheet.Cells[e.Row, iCol].BackColor == Color.PaleGreen
                                || siMain.ActiveSheet.Cells[e.Row, iCol].BackColor == Color.PapayaWhip))
                    {
                                                                                                                         
                            
                                                                            
                        using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
                        {
                            var request = new FoxDataRequest("DM.DMF0003_GET_MKT_FCST_COMPARE_POPUP");

                            request.CommandTimeout = 30 * 60;

                            string[] sPeriod = drpPeriod.ControlValues.Split(':');
                            string sInvalidExec = (checkInvalidExec.Checked == true) ? "Y" : "N";                                                     

                                                  
                            DateTime sMonday = DateTime.Today.AddDays(Convert.ToInt32(DayOfWeek.Monday) - Convert.ToInt32(DateTime.Today.DayOfWeek));
                            sPeriod[0] = sMonday.ToString("yyyyMMdd");
                            sPeriod[1] = sMonday.AddDays(20).ToString("yyyyMMdd");

                                                                           

                            request.Parameters["p_division_id"] = sDivision;                                 
                            request.Parameters["p_scm_site_id"] = ScmSiteId;                                   
                                                                                                                                                  
                                                                                                                                 
                                                                                                                                                           
                                                                                                                                           
                            request.Parameters["p_project_code"] = Customer;                
                            request.Parameters["p_item_id"] = sItemId;                    
                                                                                                                                      
                            request.Parameters["p_dom_exp"] = sDomExp;
                            request.Parameters["p_fcst_type"] = sFcstType;
                            request.Parameters["p_incoterms"] = sIncoterms;
                            request.Parameters["p_yyyymmdd"] = sYyyymmdd;
                                                                                  
                                                                                
                                                                                         
                                                                                                                     
                                                                                             
                                                                                    
                                                                                                     
                                                                                                          
                                                                                                                                       

                            var response = client.ExecuteDataSet(request);

                            DMF0003_SspSyncComparePopUp popup = new DMF0003_SspSyncComparePopUp();
                            popup.LoadData(response.DataSet.Tables[0], sDivision);
                            popup.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                            popup.ShowDialog();
                                
                        }
                    }
                }
                #endregion

                if (siMain.IsLock(siMain.SheetName) || siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting.StringI)
                {
                    return;
                }

                if (e.Column == siMain.GetColumnIndex(DefColumns.Project))
                {
                    string sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                    string sTeam = "ALL";                                                                               
                    string sEndCustomer = "ALL";                                                                                   
                    string sScmSite = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                    string sProject = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Project)).ToString();
                    string sProjectName = string.Empty;
                    string sProjectStatus = string.Empty;
                    string sBizType = string.Empty;
                    string sProjectOwner = string.Empty;

                    if (siMain.GetColumnIndex(DefColumns.Team) > 0)
                    {
                        sTeam = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Team)).ToString();
                    }

                    if (siMain.GetColumnIndex(DefColumns.Customer) > 0)
                    {
                        sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Customer)).ToString();
                    }

                    SCM0002_ProjectbyDivisionPopupEx popProject = new SCM0002_ProjectbyDivisionPopupEx();
                                              
                    popProject.Form_Load(false, sDivision, sTeam, sEndCustomer, sScmSite, sProject);
                    popProject.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                    popProject.ShowDialog();

                    sProject = popProject.ProjectCode;
                    sProjectName = popProject.ProjectName;
                    sProjectStatus = popProject.ProjectStatus;
                    sBizType = popProject.BizType;
                    sProjectOwner = popProject.ProjectOwner;

                    if (sProject != "")
                    {
                        siMain.SetText(e.Row, e.Column, sProject);

                        if (siMain.GetColumnIndex(DefColumns.ProjectName) > 0)
                        {
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ProjectName), sProjectName);
                        }

                        if (siMain.GetColumnIndex(DefColumns.ProjectStatus) > 0)
                        {
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ProjectStatus), sProjectStatus);
                        }

                        if (siMain.GetColumnIndex(DefColumns.BizType) > 0)
                        {
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.BizType), sBizType);
                        }

                        if (siMain.GetColumnIndex(DefColumns.ProjectOwner) > 0)
                        {
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ProjectOwner), sProjectOwner);
                        }
                    }
                }
                else if (e.Column == siMain.GetColumnIndex(DefColumns.ItemId))
                {
                    string sDivision = "", sTeam = "", sEndCustomer = "",                    sProject = "";
                    string sScmSiteId = "", sItemId = "", sItemName = "", sItemType = "", sNickName = "";

                    sDivision = clbDivision.ControlValues;                                                                                 
                    sTeam = "ALL";                                                                               
                    sEndCustomer = "ALL";                                                                                   

                                                                         
                    string sMdmActive_Sw = string.Empty;
                    sMdmActive_Sw = "Y";                                                                             

                    string sMeasure_info = string.Empty;                         

                    if (siMain.GetColumnIndex(DefColumns.Measure) > 0)
                        sMeasure_info = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Measure)).ToString();
                                                                              
                                                                                         

                    if (siMain.GetColumnIndex(DefColumns.Team) > 0)
                        sTeam = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Team)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.Project) > 0)
                        sProject = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Project)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.ScmSiteId) > 0)
                        sScmSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.ScmSiteId40) > 0)
                        sScmSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId40)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.ItemId) > 0)
                        sItemId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ItemId)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.ItemId40) > 0)
                        sItemId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ItemId40)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.Customer) > 0)
                        sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Customer)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.Customer40) > 0)
                        sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Customer40)).ToString();

                                                                                                   
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

                        if (siMain.GetColumnIndex(DefColumns.ItemName) > 0)
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ItemName), sItemName);
                        if (siMain.GetColumnIndex(DefColumns.ItemType) > 0)
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ItemType), sItemType);
                        if (siMain.GetColumnIndex(DefColumns.NickName) > 0)
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.NickName), sNickName);
                    }
                }
                else if (e.Column == siMain.GetColumnIndex(DefColumns.ItemId40))
                {

                    string sDivision = "", sTeam = "", sEndCustomer = "", sScmSite = "", sProject = "", sItemId = "";
                    string sItemName = "", sItemType = "", sNickName = "";
                    sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Division40)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.Team) > 0)
                        sTeam = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Team)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.Customer40) > 0)
                        sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Customer40)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.ScmSiteId40) > 0)
                        sScmSite = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId40)).ToString();
                    sProject = "";                                                                                    
                    if (siMain.GetColumnIndex(DefColumns.ItemId40) > 0)
                        sItemId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ItemId40)).ToString();

                                                                         
                    string sMdmActive_Sw = string.Empty;
                    string sMeasure_info = string.Empty;

                    sMdmActive_Sw = "Y";                                                                            

                    if (siMain.GetColumnIndex(DefColumns.Measure) > 0)
                        sMeasure_info = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Measure)).ToString();
                                                                              
                                                                                         

                    DM0002_ItembyDivisionPopupEx popItem = new DM0002_ItembyDivisionPopupEx();

                                           
                                                                                                             
                    popItem.Form_Load(false, sDivision, sTeam, sEndCustomer, sScmSite, sProject, sItemId, sMdmActive_Sw, sMeasure_info);                                                

                    popItem.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                    popItem.ShowDialog();

                    sItemId = popItem.ItemID;
                    sItemName = popItem.ItemName;
                    sItemType = popItem.ItemType;
                    sNickName = popItem.NickName;

                    if (sItemId != "")
                    {
                        siMain.SetText(e.Row, e.Column, sItemId);

                        if (siMain.GetColumnIndex(DefColumns.ItemName) > 0)
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ItemName), sItemName);
                        if (siMain.GetColumnIndex(DefColumns.ItemType) > 0)
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ItemType), sItemType);
                        if (siMain.GetColumnIndex(DefColumns.NickName) > 0)
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.NickName), sNickName);
                    }
                }
            }
        }

        protected void spdMain_Changed(object sender, FarPoint.Win.Spread.Model.SheetDataModelEventArgs e)
        {
            if (!this.CanModelChange) return;

            switch (e.Type)
            {
                case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated:
                    string sBucketType = cboBucketType.ControlValues;
                    string sColName = siMain.GetColumnTag(e.Column);
                    int iStartCol = 0;
                    int iWeeklySum = 0;
                    int iMonthlySum = 0;
                    int iWkSum_Sync = 0;                      

                    string sDivision = string.Empty;
                    string sProjectCode = string.Empty;
                    string sSiteId = string.Empty;
                    string sItemId = string.Empty;
                    string sDomExp = string.Empty;
                    string sFcstType = string.Empty;
                    string sIncoterms = string.Empty;
                    string sMeasure = string.Empty;
                    string sPlantSiteId = string.Empty;

                    string sEndCustomer40 = string.Empty;
                    string sScmSiteId40 = string.Empty;
                    string sItem40 = string.Empty;

                    string sAction = string.Empty;
                                                                     
                    string sAsFromSite = string.Empty;
                    if (siMain.GetColumnIndex(DefColumns.AS_FROM_SITE) >= 0)
                    {
                        sAsFromSite = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE)).ToString();
                    }

                    #region Validation 확인
                    if ((sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0)
                        || (sBucketType == BucketType.Weekly && sColName.IndexOf("W_") != -1)
                        || (sBucketType == BucketType.Monthly && sColName.IndexOf("M_") == 0)
                        || ((sBucketType == BucketType.Weekly || sBucketType == BucketType.Monthly) && sColName.IndexOf("D_") == 0))
                    {
                        sAction = siMain.GetValue(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)).ToString();

                        if ((clbDivision.ControlValues.Substring(0, 2) == "81") || (clbDivision.ControlValues == "82"))
                        {
                            sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                            if (siMain.GetColumnIndex(DefColumns.Project) >= 0)
                                sProjectCode = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.Project));
                            if (siMain.GetColumnIndex(DefColumns.ScmSiteId) >= 0)
                                sSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                            if (siMain.GetColumnIndex(DefColumns.ItemId) >= 0)
                                sItemId = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.ItemId));
                        }
                        else
                        {
                            sDivision = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.Division40));
                            if (siMain.GetColumnIndex(DefColumns.Customer40) >= 0)
                                sEndCustomer40 = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.Customer40));
                            if (siMain.GetColumnIndex(DefColumns.ScmSiteId40) >= 0)
                                sScmSiteId40 = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId40)).ToString();
                            if (siMain.GetColumnIndex(DefColumns.ItemId40) >= 0)
                                sItem40 = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.ItemId40));
                        }

                        if (siMain.GetColumnIndex(DefColumns.DomExp) >= 0)
                            sDomExp = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DomExp)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.FcstType) >= 0)
                            sFcstType = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FcstType)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.Incoterms) >= 0)
                            sIncoterms = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Incoterms)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.Measure) >= 0)
                            sMeasure = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Measure)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.PlantSiteId) >= 0)
                            sPlantSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PlantSiteId)).ToString();

                        if (sDivision == "")
                        {
                            ValidationCheck(e, "Division ID");
                            return;
                        }
                        if ((siMain.GetColumnIndex(DefColumns.Project) > 0) && (sProjectCode == ""))
                        {
                            if ((sDivision.Substring(0, 2) == "81") || (sDivision == "82"))
                            {
                                ValidationCheck(e, "Project Code");
                                return;
                            }
                        }
                        if ((siMain.GetColumnIndex(DefColumns.Customer40) > 0) && (sEndCustomer40 == ""))
                        {
                                                                                                     
                            if (sDivision == "40")
                            {
                                ValidationCheck(e, "End Customer");
                                return;
                            }
                        }
                        if (((siMain.GetColumnIndex(DefColumns.ScmSiteId) > 0)) && (sSiteId == ""))
                        {
                            ValidationCheck(e, "Sales Site ID");
                            return;
                        }
                        if (((siMain.GetColumnIndex(DefColumns.ScmSiteId40) > 0)) && (sScmSiteId40 == ""))
                        {
                            ValidationCheck(e, "Sales Site ID");
                            return;
                        }
                        if ((siMain.GetColumnIndex(DefColumns.ItemId) > 0) && (sItemId == ""))
                        {
                            ValidationCheck(e, "Item ID");
                            return;
                        }
                        if ((siMain.GetColumnIndex(DefColumns.ItemId40) > 0) && (sItem40 == ""))
                        {
                            ValidationCheck(e, "Item ID");
                            return;
                        }
                                                                          
                        if ((siMain.GetColumnIndex(DefColumns.DomExp) > 0) && (sDomExp == ""))
                        {
                            ValidationCheck(e, "Customs Handbook(D: Domestic, E : Export)");
                            return;
                        }
                        if ((siMain.GetColumnIndex(DefColumns.FcstType) > 0) && (sFcstType == ""))
                        {
                            ValidationCheck(e, "FCST Type");
                            return;
                        }
                        if (sIncoterms == "")
                        {
                            ValidationCheck(e, "Incoterms");
                            return;
                        }
                        if (sMeasure == "")
                        {
                            ValidationCheck(e, "Measure");
                            return;
                        }
                        if (sDivision.Substring(0, 2) == "81" && sPlantSiteId == "")
                        {
                            ValidationCheck(e, "Plant Site ID");
                            return;
                        }
                    }
                    else if (sColName == DefColumns.Division || sColName == DefColumns.ScmSiteId || sColName == DefColumns.Division40 || sColName == DefColumns.Project)
                    {
                        if ((clbDivision.ControlValues.Substring(0, 2) == "81") || (clbDivision.ControlValues == "82"))
                        {
                            sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                            sSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                            sProjectCode = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Project)).ToString();
                        }
                        else
                        {
                            sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Division40)).ToString();
                            sSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId40)).ToString();
                        }

                        if (sDivision != "" && sSiteId != "")
                        {
                                                                                                     
                            if (sDivision == "40")
                                dtMeasure = Data.Common(Data.Type.MktFcstEditMeasure, false, sDivision, sSiteId, "", UserInfoContext.Current.UserId, "");
                            else
                                dtMeasure = Data.Common(Data.Type.MktFcstEditMeasure, false, sDivision, sSiteId, sProjectCode, UserInfoContext.Current.UserId, "");
                            siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure);
                        }

                                              
                        if (clbDivision.ControlValues == "82" && sColName == DefColumns.ScmSiteId)
                        {
                            string sVmiYn = "N";
                            string sVmi_std_dio = "";

                            if (sSiteId != "")
                            {
                                dt_VMI_YN = Data.Common(Data.Type.DM_VMI_YN, false, sDivision, sSiteId, "", "", "");
                                if (dt_VMI_YN != null && dt_VMI_YN.Rows.Count > 0 && dt_VMI_YN.Columns.IndexOf("VMI_VAL") > -1)
                                {
                                    sVmiYn = dt_VMI_YN.Rows[0]["VMI_VAL"].ToString().Split('^')[0];
                                    sVmi_std_dio = dt_VMI_YN.Rows[0]["VMI_VAL"].ToString();
                                }
                            }
                            if (siMain.GetColumnIndex(DefColumns.VMI_YN) > -1)
                            {
                                siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.VMI_YN), sVmiYn);
                            }
                            if (siMain.GetColumnIndex(DefColumns.VMI_STD_DIO) > -1)
                            {
                                siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.VMI_STD_DIO), sVmi_std_dio);
                            }
                        }
                    }
                    #endregion

                    if (siMain.GetColumnIndex(DefColumns.Division) >= 0)
                    {
                        sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                    }
                    else
                    {
                        sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Division40)).ToString();
                    }

                    if (sDivision != null && sDivision != "")
                    {
                                                                                        
                        if (sDivision.Substring(0, 2) == "81" && e.Column == siMain.GetColumnIndex(DefColumns.Project))
                        {
                            sProjectCode = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Project)).ToString();
                            sItemId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ItemId)).ToString();

                            dtPlantSite = Data.Common(Data.Type.SalesPlant, false, "", sDivision, sProjectCode, sItemId);
                            siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.PlantSiteId), dtPlantSite);

                        }
                        else if (sDivision.Substring(0, 2) == "81" && e.Column == siMain.GetColumnIndex(DefColumns.ItemId))
                        {
                            sProjectCode = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Project)).ToString();
                            sItemId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ItemId)).ToString();

                            dtPlantSite = Data.Common(Data.Type.SalesPlant, false, "", sDivision, sProjectCode, sItemId);
                            siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.PlantSiteId), dtPlantSite);

                        }
                    }

                    #region 여러행 신규 입력 로우를 생성했을 경우 신규 로우 중에서 중복되지 않게.
                    if (siMain.GetValue(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)).ToString() == "I")
                    {
                        if (siMain.GetColumnIndex(DefColumns.Project) > 0)
                            sProjectCode = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Project)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.ScmSiteId) > 0)
                            sSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.ItemId) > 0)
                            sItemId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ItemId)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.DomExp) > 0)
                            sDomExp = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DomExp)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.FcstType) > 0)
                            sFcstType = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FcstType)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.Incoterms) > 0)
                            sIncoterms = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Incoterms)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.Measure) > 0)
                            sMeasure = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Measure)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.PlantSiteId) > 0)
                            sPlantSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PlantSiteId)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.Customer40) > 0)
                            sEndCustomer40 = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Customer40)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.ScmSiteId40) > 0)
                            sScmSiteId40 = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId40)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.ItemId40) > 0)
                            sItem40 = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ItemId40)).ToString();

                        string sProjectCode2 = string.Empty;
                        string sSiteId2 = string.Empty;
                        string sItemId2 = string.Empty;
                        string sDomExp2 = string.Empty;
                        string sFcstType2 = string.Empty;
                        string sIncoterms2 = string.Empty;
                        string sMeasure2 = string.Empty;
                        string sPlantSiteId2 = string.Empty;

                        string sEndCustomer40_2 = string.Empty;
                        string sScmSiteId40_2 = string.Empty;
                        string sItem40_2 = string.Empty;

                        int iDouble = 0;           

                        for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
                        {
                            if (siMain.GetValue(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)).ToString() == "I")
                            {
                                if (siMain.GetColumnIndex(DefColumns.Project) > 0)
                                    sProjectCode2 = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Project)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.ScmSiteId) > 0)
                                    sSiteId2 = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.ItemId) > 0)
                                    sItemId2 = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ItemId)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.DomExp) > 0)
                                    sDomExp2 = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DomExp)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.FcstType) > 0)
                                    sFcstType2 = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FcstType)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.Incoterms) > 0)
                                    sIncoterms2 = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Incoterms)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.Measure) > 0)
                                    sMeasure2 = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Measure)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.PlantSiteId) > 0)
                                    sPlantSiteId2 = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.PlantSiteId)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.Customer40) > 0)
                                    sEndCustomer40_2 = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Customer40)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.ScmSiteId40) > 0)
                                    sScmSiteId40_2 = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ScmSiteId40)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.ItemId40) > 0)
                                    sItem40_2 = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ItemId40)).ToString();

                                                                                                                                                         
                                if (clbDivision.ControlValues == "40")
                                {
                                    if ((sEndCustomer40 == "") || (sScmSiteId40 == "") || (sItem40 == "") || (sDomExp == "")
                                        || (sFcstType == "") || (sIncoterms == "") || (sMeasure == ""))
                                        continue;

                                    if ((sEndCustomer40_2 == "") || (sScmSiteId40_2 == "") || (sItem40_2 == "") || (sDomExp2 == "")
                                        || (sFcstType2 == "") || (sIncoterms2 == "") || (sMeasure2 == ""))
                                        continue;

                                    if ((sEndCustomer40 == sEndCustomer40_2)
                                        && (sScmSiteId40 == sScmSiteId40_2)
                                        && (sItem40 == sItem40_2)
                                        && (sDomExp == sDomExp2)
                                        && (sFcstType == sFcstType2)
                                        && (sIncoterms == sIncoterms2)
                                        && (sMeasure == sMeasure2))
                                    {
                                        iDouble++;
                                    }
                                }
                                else if (clbDivision.ControlValues.Substring(0, 2) == "81")
                                {
                                    if ((sProjectCode == "") || (sSiteId == "") || (sItemId == "") || (sDomExp == "")
                                        || (sFcstType == "") || (sIncoterms == "") || (sMeasure == "") || (sPlantSiteId == ""))
                                        continue;
                                    if ((sProjectCode2 == "") || (sSiteId2 == "") || (sItemId2 == "") || (sDomExp2 == "")
                                        || (sFcstType2 == "") || (sIncoterms2 == "") || (sMeasure2 == "") || (sPlantSiteId2 == ""))
                                        continue;

                                    if ((sProjectCode == sProjectCode2)
                                        && (sSiteId == sSiteId2)
                                        && (sItemId == sItemId2)
                                        && (sDomExp == sDomExp2)
                                        && (sFcstType == sFcstType2)
                                        && (sIncoterms == sIncoterms2)
                                        && (sMeasure == sMeasure2)
                                        && (sPlantSiteId == sPlantSiteId2))
                                    {
                                        iDouble++;
                                    }
                                }
                                else if (clbDivision.ControlValues == "82")
                                {
                                    if ((sProjectCode == "") || (sSiteId == "") || (sItemId == "") || (sDomExp == "")
                                        || (sFcstType == "") || (sIncoterms == "") || (sMeasure == ""))
                                        continue;
                                    if ((sProjectCode2 == "") || (sSiteId2 == "") || (sItemId2 == "") || (sDomExp2 == "")
                                        || (sFcstType2 == "") || (sIncoterms2 == "") || (sMeasure2 == ""))
                                        continue;

                                    if ((sProjectCode == sProjectCode2)
                                        && (sSiteId == sSiteId2)
                                        && (sItemId == sItemId2)
                                        && (sDomExp == sDomExp2)
                                        && (sFcstType == sFcstType2)
                                        && (sIncoterms == sIncoterms2)
                                        && (sMeasure == sMeasure2))
                                    {
                                        iDouble++;
                                    }
                                }
                            }
                        }

                        if (iDouble >= 2)
                        {
                            CanModelChange = false;
                            siMain.SetText(e.Row, e.Column, "");
                            CanModelChange = true;
                            MessageHelper.GMessageBox("MSG00260");
                            return;
                        }
                        iDouble = 0;
                    }
                    #endregion

                    var dBucket = new Dictionary<int, bool>();
                    string strBucket = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.BUCKET));
                                                      
                    if (strBucket == "")
                    {
                        strBucket = "0000010";
                    }

                    char[] sarBucket = strBucket.ToCharArray();
                    for (int i = 0; i < 7; i++)
                    {
                        dBucket.Add(i, sarBucket[i].ToString() == "1" ? true : false);
                    }

                                                    
                       
                                     
                                     
                                     
                                       
                             
                      
                    if (sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0)
                    {

                                                 
                                                           
                        #region
                           
                                                                                                                         
                                                                                 
                          
                                                                                                            
                              
                                              
                                                                                                                              
                                              
                                                                           
                                  
                                                                                                              
                                  
                                                                
 
                                                   
                                                     
                                                                          
                                  
                                                                                                                        
                                                                                                                                           
                                                                                                                                
                                                                                                                       
                                                                                                                                 
                                                                                                                                     
                                                                                                                                       
                                                                                                                                         
                                      
                                                          
                                                       
                                               
                                      
                                  
                                                             
                                             
                                  
                                                                                                    
                                      
                                                                                                                            
                                                                                                                                               
                                                                                                                                    
                                                                                                                           
                                                                                                                                     
                                                                                                                                         
                                                                                                                                           
                                                                                                                                             
                                          
                                                              
                                                           
                                                   
                                          
                                      
                                  
 
                                                                     
                                            
                                  
                                                                                                                                                                                       
                                                                                                         
 
                                                                                                              
                                      
                                                                                                   
                                          
                                                                                                         
                                                   
                                          
                                      
                                  
                              
                          
                          
                        #endregion

                                     
                        for (int iCol = e.Column; iCol > 0; iCol--)
                        {
                            if (siMain.GetColumnTag(iCol).IndexOf("W_") != -1)
                            {
                                                                                      
                                iStartCol = iCol + 1;
                                break;
                            }
                        }

                        for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                        {
                            if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 && siMain.GetText(e.Row, iCol) != "")
                            {
                                iWeeklySum = iWeeklySum + Convert.ToInt32(siMain.GetText(e.Row, iCol).Replace(",", ""));
                            }

                            if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 || siMain.GetColumnTag(iCol).IndexOf("W_") != -1)
                            {
                                                                                      
                                siMain.SetText(e.Row, iStartCol - 1, iWeeklySum.ToString());
                                break;
                            }
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
                            if (siMain.GetColumnTag(iCol).IndexOf("W_") != -1 && siMain.GetText(e.Row, iCol) != "")
                            {
                                iMonthlySum = iMonthlySum + Convert.ToInt32(siMain.GetText(e.Row, iCol).Replace(",", ""));
                            }

                            if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                            {
                                siMain.SetText(e.Row, iStartCol - 1, iMonthlySum.ToString());
                                break;
                            }
                        }

                        string sYYYYMMDD = sColName.Replace("D_", "");
                        int iQty = 0;

                        if (siMain.GetText(e.Row, e.Column) != "")
                        {
                            iQty = Convert.ToInt32(siMain.GetText(e.Row, e.Column).Replace(",", ""));
                        }

                        SetSaveData(sAction, sDivision, sProjectCode, sSiteId, sItemId, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sYYYYMMDD, iQty, sEndCustomer40, sScmSiteId40, sItem40, sAsFromSite);
                    }
                                                                 
                    else if ((sBucketType == BucketType.Weekly) && sColName.IndexOf("W_") == 0)
                    {
                        iStartCol = e.Column + 1;
                        if (siMain.GetText(e.Row, e.Column) == "")
                        {
                            iWeeklySum = 0;
                        }
                        else
                        {
                            iWeeklySum = Convert.ToInt32(siMain.GetText(e.Row, e.Column).Replace(",", ""));
                        }

                                          
                                                                                                            
                                                                              
                        if ((sDivision == "40" && sMeasure == "MKT_FCST_RP") && sFcstType != "RMA")
                        {
                            for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                            {
                                if (siMain.ActiveSheet.Cells[e.Row, iCol].BackColor == Color.PaleGreen)
                                {
                                    iWkSum_Sync = iWkSum_Sync + Convert.ToInt32(siMain.GetText(e.Row, iCol).Replace(",", ""));
                                }

                                if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 || siMain.GetColumnTag(iCol).IndexOf("W_") != -1 || iCol == siMain.GetMaxColumnIndex())
                                {
                                    break;
                                }
                            }

                            if (iWeeklySum < iWkSum_Sync)
                            {
                                siMain.SetText(e.Row, e.Column, iWkSum_Sync.ToString());
                                return;                                                                  
                            }
                        }

                        int iDaycnt = 0;
                        int iDailyQty = 0;
                        int iRemnant = 0;
                                            
                        bool bWeekAll = false;
                        int iDaySyncCnt = 0;                                      

                                      
                        for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                        {
                                                                 
                            if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0
                                                                             
                                && dBucket[getDayOfWeek(iCol)]
                                && siMain.ActiveSheet.Cells[e.Row, iCol].BackColor == Color.PaleGreen)
                            {
                                iDaySyncCnt = iDaySyncCnt + 1;
                            }

                            if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0
                                && dBucket[getDayOfWeek(iCol)])
                            {
                                iDaycnt = iDaycnt + 1;                                                 
                            }

                            if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 || siMain.GetColumnTag(iCol).IndexOf("W_") != -1 || iCol == siMain.GetMaxColumnIndex())
                            {
                                if (iDaycnt == 0)
                                {
                                    bWeekAll = true;

                                                                     
                                                          

                                                                                  
                                    iDaycnt = 1;
                                                    
                                }

                                iDailyQty = iWeeklySum / iDaycnt;
                                iRemnant = iWeeklySum % iDaycnt;

                                                   
                                if (sDivision == "40" && sMeasure == "MKT_FCST_RP" && iWkSum_Sync != 0)
                                {
                                                                      
                                    iDaycnt = iDaycnt - iDaySyncCnt;

                                    if (iWeeklySum > iWkSum_Sync)
                                    {
                                        iWeeklySum = iWeeklySum - iWkSum_Sync;
                                        iDailyQty = iWeeklySum / iDaycnt;
                                        iRemnant = iWeeklySum % iDaycnt;
                                    }
                                    else
                                    {
                                        iWeeklySum = 0;
                                        iDailyQty = iWeeklySum / iDaycnt;
                                        iRemnant = 0;
                                    }
                                }

                                break;
                            }
                        }

                        int iCheck = 0;
                        string sYYYYMMDD = sColName.Replace("D_", "");

                        #region Bucket 이 없으면 일별로 Split한다. 삭제
                                                                                                 
                            
                                             
                                
                                                                                                                              
                                    
                                                

                                                             
                                        
                                                            
                                            
                                                                                
                                            

                                                                                             
                                                                                                   

                                                                                                                                                                                
                                                   
                                        
                                           
                                        
                                                                                             
                                                                                                   

                                                                                                                                                                                
                                        
                                    
                                                                                                                                              
                                                                        
                                                             
                                        
                                                            
                                            
                                                                                
                                            

                                                                            
                                                                                                   

                                                                                                                                                                        
                                                   
                                        
                                           
                                        
                                                                            
                                                                                                   

                                                                                                                                                                        
                                        
                                    

                                                                                   
                                    
                                             
                                    
                                
                                   
                                
                                                                                    
                                    
                                                

                                                             
                                        
                                                            
                                            
                                                                                
                                            

                                                                                             
                                                                                                   

                                                                                                                                                                                
                                                 
                                        
                                           
                                        
                                                                                             
                                                                                                   

                                                                                                                                                                                
                                        
                                    
                                
                            
                        #endregion

                        if (!bWeekAll)
                        {
                            for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                            {
                                if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0
                                                                                 
                                    && dBucket[getDayOfWeek(iCol)]
                                    && siMain.ActiveSheet.Cells[e.Row, iCol].BackColor != Color.PaleGreen)                                 
                                {
                                    iCheck++;

                                    if (iDaycnt <= iCheck)
                                    {
                                        if (iRemnant > 0)
                                        {
                                            iDailyQty = iDailyQty + iRemnant;
                                        }

                                        siMain.SetText(e.Row, iCol, iDailyQty.ToString());
                                        sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("D_", "");

                                                                                                                                                                                
                                        SetSaveData(sAction, sDivision, sProjectCode, sSiteId, sItemId, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sYYYYMMDD, iDailyQty, sEndCustomer40, sScmSiteId40, sItem40, sAsFromSite);
                                                 
                                    }
                                    else
                                    {
                                        siMain.SetText(e.Row, iCol, iDailyQty.ToString());
                                        sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("D_", "");

                                                                                                                                                                                
                                        SetSaveData(sAction, sDivision, sProjectCode, sSiteId, sItemId, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sYYYYMMDD, iDailyQty, sEndCustomer40, sScmSiteId40, sItem40, sAsFromSite);
                                    }
                                }
                                else if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 && !dBucket[getDayOfWeek(iCol)]
                                        && siMain.ActiveSheet.Cells[e.Row, iCol].BackColor != Color.PaleGreen             
                                        )
                                {
                                    if (iDaycnt <= iCheck)
                                    {
                                        if (iRemnant > 0)
                                        {
                                            iDailyQty = iDailyQty + iRemnant;
                                        }

                                        siMain.SetValue(e.Row, iCol, "");
                                        sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("D_", "");

                                                                                                                                                                        
                                        SetSaveData(sAction, sDivision, sProjectCode, sSiteId, sItemId, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sYYYYMMDD, 0, sEndCustomer40, sScmSiteId40, sItem40, sAsFromSite);
                                                 
                                    }
                                    else
                                    {
                                        siMain.SetValue(e.Row, iCol, "");
                                        sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("D_", "");

                                                                                                                                                                        
                                        SetSaveData(sAction, sDivision, sProjectCode, sSiteId, sItemId, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sYYYYMMDD, 0, sEndCustomer40, sScmSiteId40, sItem40, sAsFromSite);
                                    }
                                }

                                if (siMain.GetColumnTag(iCol).IndexOf("D") != 0)
                                {
                                    break;
                                }
                            }
                        }
                        else
                        {
                            int iSetCol = 0;

                                                 
                            for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                            {
                                if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 && siMain.GetText(e.Row, iCol) != ""
                                    && siMain.ActiveSheet.Cells[e.Row, iCol].BackColor != Color.PaleGreen)           
                                {
                                    siMain.SetText(e.Row, iCol, "");
                                    sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("D_", "");
                                                                                                                                                                    
                                    SetSaveData(sAction, sDivision, sProjectCode, sSiteId, sItemId, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sYYYYMMDD, 0, sEndCustomer40, sScmSiteId40, sItem40, sAsFromSite);
                                }

                                if (siMain.GetColumnTag(iCol).IndexOf("D") != 0)
                                {
                                    break;
                                }
                            }

                            for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                            {
                                            

                                                
                                if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0
                                    && siMain.ActiveSheet.Cells[e.Row, iCol].BackColor != Color.PaleGreen)           
                                {
                                                                                                                                                                 
                                    sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("D_", "");
                                    DateTime dtWekk = DateTime.ParseExact(sYYYYMMDD, "yyyyMMdd", System.Globalization.CultureInfo.InvariantCulture);

                                    string sDayofWeek = dtWekk.ToString("ddd", new System.Globalization.CultureInfo("en-US")).ToUpper();

                                    if (sDefaultDay == sDayofWeek)
                                    {
                                        siMain.SetText(e.Row, iCol, iDailyQty.ToString());

                                                                                                                                                                                
                                        SetSaveData(sAction, sDivision, sProjectCode, sSiteId, sItemId, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sYYYYMMDD, iDailyQty, sEndCustomer40, sScmSiteId40, sItem40, sAsFromSite);
                                        break;
                                    }
                                }


                                if (siMain.GetColumnTag(iCol).IndexOf("D") != 0)
                                {
                                    iSetCol = iCol - 1;
                                    siMain.SetText(e.Row, iSetCol, iDailyQty.ToString());
                                    sYYYYMMDD = siMain.GetColumnTag(iSetCol).Replace("D_", "");

                                                                                                                                                                            
                                    SetSaveData(sAction, sDivision, sProjectCode, sSiteId, sItemId, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sYYYYMMDD, iDailyQty, sEndCustomer40, sScmSiteId40, sItem40, sAsFromSite);
                                    break;
                                }
                            }
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
                            if (siMain.GetColumnTag(iCol).IndexOf("W_") != -1 && siMain.GetText(e.Row, iCol) != "")
                            {
                                iMonthlySum = iMonthlySum + Convert.ToInt32(siMain.GetText(e.Row, iCol).Replace(",", ""));
                            }

                            if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                            {
                                siMain.SetText(e.Row, iStartCol - 1, iMonthlySum.ToString());
                                break;
                            }
                        }
                    }
                    else if (sBucketType == BucketType.Monthly && sColName.IndexOf("M_") == 0)
                    {
                                      
                        iStartCol = e.Column + 2;
                        string sYYYYMMDD = string.Empty;
                                                                                                                                             

                        if (siMain.GetText(e.Row, e.Column) == "")
                        {
                            iMonthlySum = 0;
                        }
                        else
                        {
                            iMonthlySum = Convert.ToInt32(siMain.GetText(e.Row, e.Column).Replace(",", ""));
                        }
                        int iDaycnt = 0;
                        int iDailyQty = 0;
                        int iRemnant = 0;
                        int iMonthCnt = 0;
                        bool bMonthAll = false;
                        int iLastWeeklySum = 0;

                        DateTime dateTime = DateTime.Today.AddDays(Convert.ToInt32(DayOfWeek.Monday) - Convert.ToInt32(DateTime.Today.DayOfWeek));
                        string sResultDate = dateTime.ToString("yyyyMMdd");

                        int iCheck = 0;
                                      
                        for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                        {
                            iCheck++;
                            if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0)
                            {
                                if (int.Parse(sResultDate) > int.Parse(siMain.GetColumnTag(iCol).Substring(siMain.GetColumnTag(iCol).Length - 8)))
                                {
                                    if (siMain.GetText(e.Row, iCol) != "")
                                    {
                                        iLastWeeklySum = iLastWeeklySum + Convert.ToInt32(siMain.GetText(e.Row, iCol).Replace(",", ""));
                                    }
                                    continue;
                                }

                                sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("D_", "");
                                DateTime dtMonth = DateTime.ParseExact(sYYYYMMDD, "yyyyMMdd", System.Globalization.CultureInfo.InvariantCulture);

                                string sDayofWeek = dtMonth.ToString("ddd", new System.Globalization.CultureInfo("en-US")).ToUpper();

                                if (sDefaultDay == sDayofWeek)
                                {
                                    iMonthCnt++;
                                }
                            }
                            if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0
                                && dBucket[getDayOfWeek(iCol)])
                            {
                                if (int.Parse(sResultDate) <= int.Parse(siMain.GetColumnTag(iCol).Substring(siMain.GetColumnTag(iCol).Length - 8)))
                                {
                                    iDaycnt = iDaycnt + 1;                                                                   
                                }
                            }

                            if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 || iCol == siMain.GetMaxColumnIndex())
                            {
                                if (iDaycnt == 0)
                                {
                                    iDaycnt = iMonthCnt;
                                    iMonthCnt = 0;
                                    bMonthAll = true;
                                }

                                if (iLastWeeklySum > 0)
                                {
                                    if (iMonthlySum - iLastWeeklySum <= 0)
                                    {
                                        MessageHelper.GMessageBox("MSG00225");                              
                                        return;
                                    }
                                }

                                iDailyQty = (iMonthlySum - iLastWeeklySum) / iDaycnt;
                                iRemnant = (iMonthlySum - iLastWeeklySum) % iDaycnt;
                                break;
                            }
                        }

                        iCheck = 0;

                        #region Bucket 이 없으면 일별로 Split한다. 삭제
                                                                                                 
                            
                                              
                                
                                                                                                                              
                                    
                                                                                                                                                         
                                        
                                                    
                                        

                                                

                                                             
                                        
                                                            
                                            
                                                                                
                                            
                                                                                             
                                                                                                   

                                                                                                                                                                                
                                                 
                                        
                                           
                                        
                                                                                             
                                                                                                   

                                                                                                                                                                                
                                        
                                    
                                                                                                                                   
                                    
                                                             
                                        
                                                            
                                            
                                                                                
                                            
                                                                           
                                                                                                   

                                                                                                                                                                        
                                                 
                                        
                                           
                                        
                                                                           
                                                                                                   

                                                                                                                                                                        
                                        
                                    
                                
                                   
                                
                                                                                     
                                    
                                                                                                                                                         
                                        
                                                    
                                        

                                                

                                                             
                                        
                                                            
                                            
                                                                                
                                            
                                                                                             
                                                                                                   

                                                                                                                                                                                
                                                 
                                        
                                           
                                                   
                                                                                             
                                                                                                   

                                                                                                                                                                                
                                        
                                    
                                
                            
                        #endregion

                        if (!bMonthAll)
                        {
                            for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                            {
                                if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0
                                    && dBucket[getDayOfWeek(iCol)])
                                {
                                    if (int.Parse(sResultDate) > int.Parse(siMain.GetColumnTag(iCol).Substring(siMain.GetColumnTag(iCol).Length - 8)))
                                    {
                                        continue;
                                    }

                                    iCheck++;

                                    if (iDaycnt == iCheck)
                                    {
                                        if (iRemnant > 0)
                                        {
                                            iDailyQty = iDailyQty + iRemnant;
                                        }
                                        siMain.SetText(e.Row, iCol, iDailyQty.ToString());
                                        sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("D_", "");

                                                                                                                                                                                
                                        SetSaveData(sAction, sDivision, sProjectCode, sSiteId, sItemId, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sYYYYMMDD, iDailyQty, sEndCustomer40, sScmSiteId40, sItem40, sAsFromSite);
                                                 
                                    }
                                    else
                                    {
                                        siMain.SetText(e.Row, iCol, iDailyQty.ToString());
                                        sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("D_", "");

                                                                                                                                                                                
                                        SetSaveData(sAction, sDivision, sProjectCode, sSiteId, sItemId, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sYYYYMMDD, iDailyQty, sEndCustomer40, sScmSiteId40, sItem40, sAsFromSite);
                                    }
                                }
                                else if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0
                                    && !dBucket[getDayOfWeek(iCol)])
                                {
                                    if (int.Parse(sResultDate) > int.Parse(siMain.GetColumnTag(iCol).Substring(siMain.GetColumnTag(iCol).Length - 8)))
                                    {
                                        continue;
                                    }

                                    if (iDaycnt == iCheck)
                                    {
                                        if (iRemnant > 0)
                                        {
                                            iDailyQty = iDailyQty + iRemnant;
                                        }
                                        siMain.SetText(e.Row, iCol, "");
                                        sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("D_", "");

                                                                                                                                                                        
                                        SetSaveData(sAction, sDivision, sProjectCode, sSiteId, sItemId, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sYYYYMMDD, 0, sEndCustomer40, sScmSiteId40, sItem40, sAsFromSite);
                                                 
                                    }
                                    else
                                    {
                                        siMain.SetText(e.Row, iCol, "");
                                        sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("D_", "");

                                                                                                                                                                        
                                        SetSaveData(sAction, sDivision, sProjectCode, sSiteId, sItemId, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sYYYYMMDD, 0, sEndCustomer40, sScmSiteId40, sItem40, sAsFromSite);
                                    }
                                }
                                if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 || iCol == siMain.GetMaxColumnIndex())
                                {
                                    break;
                                }
                            }
                        }
                        else
                        {
                                               

                                                 
                            for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                            {
                                if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0)
                                {
                                    if (int.Parse(sResultDate) > int.Parse(siMain.GetColumnTag(iCol).Substring(siMain.GetColumnTag(iCol).Length - 8)))
                                    {
                                        continue;
                                    }
                                    if (siMain.GetText(e.Row, iCol) != "")
                                    {
                                        siMain.SetText(e.Row, iCol, "");
                                        sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("D_", "");
                                                                                                                                                                        
                                        SetSaveData(sAction, sDivision, sProjectCode, sSiteId, sItemId, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sYYYYMMDD, 0, sEndCustomer40, sScmSiteId40, sItem40, sAsFromSite);
                                    }
                                }

                                if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 || iCol == siMain.GetMaxColumnIndex())
                                {
                                    break;
                                }
                            }

                            iCheck = 0;
                            for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                            {
                                                
                                if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0)
                                {
                                    if (int.Parse(sResultDate) > int.Parse(siMain.GetColumnTag(iCol).Substring(siMain.GetColumnTag(iCol).Length - 8)))
                                    {
                                        continue;
                                    }
                                                                                                                                                                 
                                    sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("D_", "");
                                    DateTime dtMonth = DateTime.ParseExact(sYYYYMMDD, "yyyyMMdd", System.Globalization.CultureInfo.InvariantCulture);

                                    string sDayofWeek = dtMonth.ToString("ddd", new System.Globalization.CultureInfo("en-US")).ToUpper();

                                    if (sDefaultDay == sDayofWeek)
                                    {
                                        iCheck++;
                                        if (iDaycnt == iCheck)
                                        {
                                            iDailyQty = iDailyQty + iRemnant;
                                            siMain.SetText(e.Row, iCol, iDailyQty.ToString());
                                                                                                                                                                                    
                                            SetSaveData(sAction, sDivision, sProjectCode, sSiteId, sItemId, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sYYYYMMDD, iDailyQty, sEndCustomer40, sScmSiteId40, sItem40, sAsFromSite);
                                        }
                                        else
                                        {
                                            siMain.SetText(e.Row, iCol, iDailyQty.ToString());

                                                                                                                                                                                    
                                            SetSaveData(sAction, sDivision, sProjectCode, sSiteId, sItemId, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sYYYYMMDD, iDailyQty, sEndCustomer40, sScmSiteId40, sItem40, sAsFromSite);
                                        }
                                    }
                                }

                                if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 || iCol == siMain.GetMaxColumnIndex())
                                {
                                    break;
                                }
                            }
                        }

                                     
                        iWeeklySum = 0;
                        int iWeekCol = iStartCol - 1;
                        for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                        {
                            if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 && siMain.GetText(e.Row, iCol) != "")
                            {
                                iWeeklySum = iWeeklySum + Convert.ToInt32(siMain.GetText(e.Row, iCol).Replace(",", ""));
                            }

                            if (siMain.GetColumnTag(iCol).IndexOf("W_") != -1 || iCol == siMain.GetMaxColumnIndex())
                            {
                                siMain.SetText(e.Row, iWeekCol, iWeeklySum.ToString().Replace(",", ""));
                                iWeekCol = iCol;
                                iWeeklySum = 0;
                            }
                        }
                    }
                                                                                                     
                    else if ((sBucketType == BucketType.Weekly || sBucketType == BucketType.Monthly) && (sColName.IndexOf("D_") == 0))
                    {
                        if (clbDivision.ControlValues == "40")
                        {
                                         
                            for (int iCol = e.Column; iCol > 0; iCol--)
                            {
                                if (siMain.GetColumnTag(iCol).IndexOf("W_") != -1)
                                {
                                                                                          
                                    iStartCol = iCol + 1;
                                    break;
                                }
                            }

                            for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                            {
                                if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 && siMain.GetText(e.Row, iCol) != "")
                                {
                                    iWeeklySum = iWeeklySum + Convert.ToInt32(siMain.GetText(e.Row, iCol).Replace(",", ""));
                                }

                                if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 || siMain.GetColumnTag(iCol).IndexOf("W_") != -1)
                                {
                                    FarPoint.Win.Spread.Model.DefaultSheetDataModel dsdm = (FarPoint.Win.Spread.Model.DefaultSheetDataModel)siMain.Sheet(SpdSheet.shtMain).Models.Data;
                                    dsdm.Changed -= new FarPoint.Win.Spread.Model.SheetDataModelEventHandler(spdMain_Changed);
                                                                                          
                                    siMain.SetText(e.Row, iStartCol - 1, iWeeklySum.ToString());
                                    dsdm.Changed += new FarPoint.Win.Spread.Model.SheetDataModelEventHandler(spdMain_Changed);
                                    break;
                                }
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
                                if (siMain.GetColumnTag(iCol).IndexOf("W_") != -1 && siMain.GetText(e.Row, iCol) != "")
                                {
                                    iMonthlySum = iMonthlySum + Convert.ToInt32(siMain.GetText(e.Row, iCol).Replace(",", ""));
                                }

                                if ((siMain.GetColumnTag(iCol).IndexOf("M_") == 0) || (siMain.GetMaxColumnIndex() == iCol))
                                {
                                    FarPoint.Win.Spread.Model.DefaultSheetDataModel dsdm = (FarPoint.Win.Spread.Model.DefaultSheetDataModel)siMain.Sheet(SpdSheet.shtMain).Models.Data;
                                    dsdm.Changed -= new FarPoint.Win.Spread.Model.SheetDataModelEventHandler(spdMain_Changed);
                                    siMain.SetText(e.Row, iStartCol - 1, iMonthlySum.ToString());
                                    dsdm.Changed += new FarPoint.Win.Spread.Model.SheetDataModelEventHandler(spdMain_Changed);
                                    break;
                                }
                            }

                            sAction = siMain.GetValue(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)).ToString();
                            string sYYYYMMDD = sColName.Replace("D_", "");
                            int iQty = 0;

                            if (siMain.GetText(e.Row, e.Column) != "")
                            {
                                iQty = Convert.ToInt32(siMain.GetText(e.Row, e.Column).Replace(",", ""));
                            }

                            SetSaveData(sAction, sDivision, sProjectCode, sSiteId, sItemId, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sYYYYMMDD, iQty, sEndCustomer40, sScmSiteId40, sItem40, sAsFromSite);

                                                     
                                                               
                            #region
                               
                                                                                                                             
                                                                                      
                              
                                                                                                                    
                                                                                                                
                                  
                                                  
                                                                                                                                  
                                                  
                                                                                 
                                                                                                                  
                                      
                                                                    
 
                                                       
                                                         
                                                                              
                                      
                                                                                                                            
                                                                                                                                               
                                                                                                                                    
                                                                                                                           
                                                                                                                                     
                                                                                                                                         
                                                                                                                                           
                                                                                                                                             
                                          
                                                              
                                                           
                                                   
                                          
                                      
                                                                 
                                                 
                                      
                                                                                                        
                                          
                                                                                                                                
                                                                                                                                                   
                                                                                                                                        
                                                                                                                               
                                                                                                                                         
                                                                                                                                             
                                                                                                                                               
                                                                                                                                                 
                                              
                                                                  
                                                               
                                                       
                                              
                                          
                                      
 
                                                                         
                                                
                                      
                                                                                                                                                                                           
                                                                                                             
 
                                                                                                                   
                                          
                                                                                                    
                                              
                                                                                                             
                                                       
                                              
                                          
                                      
                                  
                              
                              
                            #endregion
                        }
                    }
                    else                                                                                                                 
                    {
                        if (sColName.IndexOf("D_") != 0 && sColName.IndexOf("W_") != 0 && sColName.IndexOf("M_") != 0 && sColName.Trim() != "COLMERGE"
                            && sColName.Trim() != "" && sColName.Trim() != CAppSetting.StringAction)
                                                                                                                                                                                                             
                                                                   
                        {
                            if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI)
                            {
                                sAction = siMain.GetValue(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)).ToString();

                                                                                                                                                         
                                if (clbDivision.ControlValues == "40")
                                {
                                    sDivision = "40";
                                    if (siMain.GetColumnIndex(DefColumns.Customer40) > 0)
                                        sEndCustomer40 = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.Customer40));
                                    if (siMain.GetColumnIndex(DefColumns.ScmSiteId40) > 0)
                                        sScmSiteId40 = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId40)).ToString();
                                    if (siMain.GetColumnIndex(DefColumns.ItemId40) > 0)
                                        sItem40 = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.ItemId40));
                                }
                                else
                                {
                                    sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                                    if (siMain.GetColumnIndex(DefColumns.Project) > 0)
                                        sProjectCode = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.Project));
                                    if (siMain.GetColumnIndex(DefColumns.ScmSiteId) > 0)
                                        sSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                                    if (siMain.GetColumnIndex(DefColumns.ItemId) > 0)
                                        sItemId = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.ItemId));
                                }

                                if (siMain.GetColumnIndex(DefColumns.DomExp) > 0)
                                    sDomExp = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DomExp)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.FcstType) > 0)
                                    sFcstType = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FcstType)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.Incoterms) > 0)
                                    sIncoterms = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Incoterms)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.Measure) > 0)
                                    sMeasure = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Measure)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.PlantSiteId) >= 0)
                                    sPlantSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PlantSiteId)).ToString();

                                iStartCol = siMain.GetColumnIndex(DefColumns.Measure) + 1;
                                string sYYYYMMDD = string.Empty;

                                for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                                {
                                    if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 || siMain.GetColumnTag(iCol).IndexOf("W_") != -1 || siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                                    {
                                        if (siMain.GetText(e.Row, iCol) != "")
                                        {
                                            siMain.SetText(e.Row, iCol, "");
                                        }
                                    }
                                }
                                SetSaveDataRemove(sAction, sDivision, sProjectCode, sSiteId, sItemId, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sEndCustomer40, sScmSiteId40, sItem40);
                            }
                        }
                    }
                    break;
            }
        }

        private void ValidationCheck(FarPoint.Win.Spread.Model.SheetDataModelEventArgs e, string col)
        {
            if (bPasteContinue)
                MessageHelper.GMessageBox("MSG00002", new object[] { col });

            CanModelChange = false;
            siMain.SetText(e.Row, e.Column, "");
            CanModelChange = true;
            bPasteContinue = false;
        }

        private void SetSaveData(string sAction, string sDivision, string sProjectCode, string sSiteId, string sItemId, string sDomExp
                                , string sFcstType, string sIncoterms, string sMeasure, string sPlantSiteId, string sYYYYMMDD, int iQty
                                , string sEndCustomer40, string sScmSiteId40, string sItemId40, string sAsFromSite)
        {
            if (sDivision == "")
            {
                                                                                                     
                return;
            }

            if ((sDivision.Substring(0, 2) == "81") || (sDivision == "82"))
            {
                if (sSiteId == "")
                {
                                                                                            
                    return;
                }
                if (sItemId == "")
                {
                                                                                       
                    return;
                }
                if (sDivision.Substring(0, 2) == "81" && sPlantSiteId == "")                
                {
                                                                                            
                    return;
                }
            }
            else
            {
                if (sEndCustomer40 == "")
                {
                                                                                              
                    return;
                }
                if (sScmSiteId40 == "")
                {
                                                                                            
                    return;
                }
                if (sItemId40 == "")
                {
                                                                                       
                    return;
                }
            }

            if (sIncoterms == "")
            {
                                                                                       
                return;
            }
            if (sFcstType == "")
            {
                                                                                       
                return;
            }
            if (((sDivision == "40") || (sDivision.Substring(0, 2) == "81") || (sDivision == "82")) && (sDomExp == ""))
            {
                                                                                              
                return;
            }
            if (sMeasure == "")
            {
                                                                                     
                return;
            }
            if (sYYYYMMDD.Length != 8)
            {
                MessageBox.Show("YYYYMMDD형식이 맞지 않습니다.");
                return;
            }

            string sFilter = "Action" + "= '" + sAction + "'";
            sFilter += " and " + DefColumns.Division + "= '" + sDivision + "'";
            sFilter += " and " + DefColumns.Project + " = '" + sProjectCode + "'";
            sFilter += " and " + DefColumns.ScmSiteId + " = '" + sSiteId + "'";
            sFilter += " and " + DefColumns.ItemId + " = '" + sItemId + "'";
            sFilter += " and " + DefColumns.DomExp + " = '" + sDomExp + "'";
            sFilter += " and " + DefColumns.FcstType + " = '" + sFcstType + "'";
            sFilter += " and " + DefColumns.Incoterms + " = '" + sIncoterms + "'";
            sFilter += " and " + DefColumns.Measure + " = '" + sMeasure + "'";
            sFilter += " and " + DefColumns.PlantSiteId + " = '" + sPlantSiteId + "'";
            sFilter += " and " + DefColumns.YYYYMMDD + "= '" + sYYYYMMDD + "'";

            sFilter += " and " + DefColumns.Customer40 + " = '" + sEndCustomer40 + "'";
            sFilter += " and " + DefColumns.ScmSiteId40 + " = '" + sScmSiteId40 + "'";
            sFilter += " and " + DefColumns.ItemId40 + "= '" + sItemId40 + "'";
                                                             
            if (!string.IsNullOrEmpty(sAsFromSite))
            {
                sFilter += " and " + DefColumns.AS_FROM_SITE + "= '" + sAsFromSite + "'";
            }

            DataRow[] drFind = dtSave.Select(sFilter);

            if (drFind.Length == 0)
            {
                DataRow drNew = dtSave.NewRow();
                drNew["Action"] = sAction;
                drNew[DefColumns.Division] = sDivision;
                drNew[DefColumns.Project] = sProjectCode;
                drNew[DefColumns.ScmSiteId] = sSiteId;
                drNew[DefColumns.ItemId] = sItemId;
                drNew[DefColumns.DomExp] = sDomExp;
                drNew[DefColumns.FcstType] = sFcstType;
                drNew[DefColumns.Incoterms] = sIncoterms;
                drNew[DefColumns.Measure] = sMeasure;
                drNew[DefColumns.PlantSiteId] = sPlantSiteId;
                drNew[DefColumns.YYYYMMDD] = sYYYYMMDD;
                drNew[DefColumns.Qty] = iQty;

                drNew[DefColumns.Customer40] = sEndCustomer40;
                drNew[DefColumns.ScmSiteId40] = sScmSiteId40;
                drNew[DefColumns.ItemId40] = sItemId40;
                                                                 
                drNew[DefColumns.AS_FROM_SITE] = sAsFromSite;


                dtSave.Rows.Add(drNew);
                dtSave.AcceptChanges();
            }
            else
            {
                drFind[0][DefColumns.Qty] = iQty;
                dtSave.AcceptChanges();
            }
        }

        private void SetSaveDataRemove(string sAction, string sDivision, string sProjectCode, string sSiteId, string sItemId, string sDomExp
                                , string sFcstType, string sIncoterms, string sMeasure, string sPlantSiteId
                                , string sEndCustomer40, string sScmSiteId40, string sItemId40)
        {
            if (sDivision == "")
            {
                                                                                                     
                return;
            }

            if (sDivision != "40")
            {
                if (sSiteId == "")
                {
                                                                                            
                    return;
                }
                if (sItemId == "")
                {
                                                                                       
                    return;
                }
                if (sDivision.Substring(0, 2) == "81" && sPlantSiteId == "")                
                {
                                                                                            
                    return;
                }
            }
            else
            {
                if (sEndCustomer40 == "")
                {
                                                                                              
                    return;
                }
                if (sScmSiteId40 == "")
                {
                                                                                            
                    return;
                }
                if (sItemId40 == "")
                {
                                                                                       
                    return;
                }
            }

            if (sIncoterms == "")
            {
                                                                                       
                return;
            }
            if (sFcstType == "")
            {
                                                                                       
                return;
            }
            if (sDomExp == "")
            {
                                                                                              
                return;
            }
            if (sMeasure == "")
            {
                                                                                     
                return;
            }

            string sFilter = "Action" + "= '" + sAction + "'";
            sFilter += " and " + DefColumns.Division + "= '" + sDivision + "'";
            sFilter += " and " + DefColumns.Project + " = '" + sProjectCode + "'";
            sFilter += " and " + DefColumns.ScmSiteId + " = '" + sSiteId + "'";
            sFilter += " and " + DefColumns.ItemId + " = '" + sItemId + "'";
            sFilter += " and " + DefColumns.DomExp + " = '" + sDomExp + "'";
            sFilter += " and " + DefColumns.FcstType + " = '" + sFcstType + "'";
            sFilter += " and " + DefColumns.Incoterms + " = '" + sIncoterms + "'";
            sFilter += " and " + DefColumns.Measure + " = '" + sMeasure + "'";
            sFilter += " and " + DefColumns.PlantSiteId + " = '" + sPlantSiteId + "'";
                                                                                  

            sFilter += " and " + DefColumns.Customer40 + " = '" + sEndCustomer40 + "'";
            sFilter += " and " + DefColumns.ScmSiteId40 + " = '" + sScmSiteId40 + "'";
            sFilter += " and " + DefColumns.ItemId40 + "= '" + sItemId40 + "'";

            DataRow[] drFind = dtSave.Select(sFilter);

            if (drFind.Length > 0)
            {
                for (int i = 0; i < drFind.Length; i++)
                {
                    dtSave.Rows.Remove(drFind[i]);
                    dtSave.AcceptChanges();
                }
            }

        }

        private void spdMain_TopChange(object sender, FarPoint.Win.Spread.TopChangeEventArgs e)
        {
            CanModelChange = false;
            siMain.SmartColMerge();
            CanModelChange = true;
        }

        private void chkColor_CheckedChanged(object sender, EventArgs e)
        {
            if (siMain != null)
            {
                SetSpreadColumn();
            }
        }

        private void spdMain_KeyUp(object sender, System.Windows.Forms.KeyEventArgs e)
        {
                                                                           
            string sdivision = clbDivision.ControlValues;
            string sTeam = clbTeam.ControlValues;
            string sEndCustomer = clbCustomer.ControlValues;
            string sScmSite = clbSalesSite.ControlValues;
            string sProject = txtProject.Text;

            string sItemId = "";                                                     
            int sActiveRow = 0;
            int sActiveCol = 0;                                   

            if (siMain.GetColumnIndex(DefColumns.ItemId) == siMain.ActiveColumnIndex
                || siMain.GetColumnIndex(DefColumns.ItemId40) == siMain.ActiveColumnIndex)
            {
                if (e.Control == true && e.KeyCode == Keys.V || e.Control == false && e.KeyCode == Keys.V)
                {
                    spdMain.ActiveSheet.ClipboardPaste(ClipboardPasteOptions.AsStringSkipHidden);
                    bPasteContinue = true;

                    sActiveRow = siMain.ActiveRowIndex;
                    if (sdivision == "40")
                    {
                        sActiveCol = siMain.GetColumnIndex(DefColumns.ItemId40);
                        sItemId = siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemId40));
                                                                        
                    }
                    else
                    {
                        sActiveCol = siMain.GetColumnIndex(DefColumns.ItemId);
                        sItemId = siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemId));
                                                                         
                    }


                                                                                                                                                                                                                    
                    spdMain_CellDoubleClick(sender, new CellClickEventArgs(spdMain.ActiveSheet.ContainingViews[0], sActiveRow, sActiveCol, 0, 0, MouseButtons.Left, false, false));
                }

                if (e.Control == true && e.KeyCode == Keys.C || e.Control == false && e.KeyCode == Keys.C)
                {
                    Clipboard.Clear();
                    spdMain.Sheets[0].ClipboardCopy(ClipboardCopyOptions.AsStringSkipHidden);
                }
            }
                                                                                             


            if (siMain.GetColumnIndex(DefColumns.Measure) >= siMain.ActiveColumnIndex) return;

            if (e.Control == true && e.KeyCode == Keys.V || e.Control == false && e.KeyCode == Keys.V)
            {
                spdMain.ActiveSheet.ClipboardPaste(ClipboardPasteOptions.AsStringSkipHidden);
                                                                 
                bPasteContinue = true;
            }

            if (e.Control == true && e.KeyCode == Keys.C || e.Control == false && e.KeyCode == Keys.C)
            {
                Clipboard.Clear();
                spdMain.Sheets[0].ClipboardCopy(ClipboardCopyOptions.AsStringSkipHidden);
                                                               
            }
        }

        private void btnProject_Click(object sender, EventArgs e)
        {
            string sDivision = clbDivision.ControlValues;
            string sTeam = clbTeam.ControlValues;
            string sEndCustomer = clbCustomer.ControlValues;
            string sScmSiteID = clbSalesSite.ControlValues;
            string sProject = txtProject.Text;
            string sProjectCode = "";

            SCM0002_ProjectbyDivisionPopupEx popProject = new SCM0002_ProjectbyDivisionPopupEx();
                                      
            popProject.Form_Load(true, sDivision, sTeam, sEndCustomer, sScmSiteID, sProject);
            popProject.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            popProject.ShowDialog();

            sProjectCode = popProject.ProjectCode;

            if (popProject.ProjectCode != "")
            {
                txtProject.Text = sProjectCode;
            }
        }

        private void btnItemId_Click(object sender, EventArgs e)
        {
            string sdivision = clbDivision.ControlValues;
            string sTeam = clbTeam.ControlValues;
            string sEndCustomer = clbCustomer.ControlValues;
            string sScmSite = clbSalesSite.ControlValues;
            string sProject = txtProject.Text;
            string sItemId = txtItemId.Text;

                                                                                           
            DM0002_ItembyDivisionPopupEx popItem = new DM0002_ItembyDivisionPopupEx();

            popItem.Form_Load(true, sdivision, sTeam, sEndCustomer, sScmSite, sProject, sItemId);
            popItem.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            popItem.ShowDialog();

            sItemId = popItem.ItemID;

            if (popItem.ItemID != "")
            {
                txtItemId.Text = sItemId;
            }
        }

        private void btnColumn_Click(object sender, EventArgs e)
        {
                                                                                                                 
            DM0002_TitleSetForm_Popup frm = new DM0002_TitleSetForm_Popup("DMF0003", SpdSheet.shtMain, true, clbDivision.ControlValues);
            frm.StartPosition = FormStartPosition.CenterParent;
            frm.ShowDialog();

            if (frm.DialogResult == DialogResult.OK)
            {
                                                                                            
                string stype = "";
                InitSpread(stype);
                                                                                          
            }
        }

        private void btnMeasure_Click(object sender, EventArgs e)
        {
            DM0002_TitleSetForm_Popup frm = new DM0002_TitleSetForm_Popup("DMF0003", SpdSheet.shtMain, false, clbDivision.ControlValues);

            frm.StartPosition = FormStartPosition.CenterParent;
            frm.ShowDialog();

            if (frm.DialogResult == DialogResult.OK)
            {
                                                                                            
                string stype = "";
                InitSpread(stype);
                                                                                          
            }
        }

        private void chkSum_CheckedChanged(object sender, EventArgs e)
        {
            if (siMain != null)
            {
                SetSpreadColumn();
            }
        }

                                                                   
            
                                                    
                
                                                                
                          
                


                                             
                                                                        

                                                                                 
                                                                                                                 

                                                       
                                                                                         
                                  

                               
                

                
            
        #endregion

        private void SetSpreadColumn()
        {
            int iStartCol = siMain.GetColumnIndex(DefColumns.Measure) + 1;
            DateTime dateTime2 = DateTime.Today.AddDays(Convert.ToInt32(DayOfWeek.Monday) - Convert.ToInt32(DateTime.Today.DayOfWeek));
            sResultYYYYMMDD = dateTime2.ToString("yyyyMMdd");
            bool check = false;

            for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
            {
                if (cboBucketType.ControlValues == BucketType.Daily)
                {
                    if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 || siMain.GetColumnTag(iCol).IndexOf("W_") != -1)
                        siMain.ActiveSheet.Columns[iCol].Visible = true;

                    if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 || siMain.GetColumnTag(iCol).IndexOf("W_") != -1)
                        siMain.ActiveSheet.Columns[iCol].Visible = chkSum.Checked;
                }
                else if (cboBucketType.ControlValues == BucketType.Weekly)
                {
                    if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0)
                        siMain.ActiveSheet.Columns[iCol].Visible = false;
                    else if (siMain.GetColumnTag(iCol).IndexOf("W_") != -1)
                        siMain.ActiveSheet.Columns[iCol].Visible = true;

                    if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                        siMain.ActiveSheet.Columns[iCol].Visible = chkSum.Checked;
                }
                else if (cboBucketType.ControlValues == BucketType.Monthly)
                {
                    if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 || siMain.GetColumnTag(iCol).IndexOf("W_") != -1)
                        siMain.ActiveSheet.Columns[iCol].Visible = false;
                    else if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                        siMain.ActiveSheet.Columns[iCol].Visible = true;
                }

                if (chkColor.Checked == false)
                {
                    if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                    {
                        if (siMain.GetColumnTag(iCol).Substring(2) == sResultYYYYMMDD.Substring(0, 6))
                        {
                            siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor = Color.Green;
                            siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font = new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
                            siMain.ActiveSheet.ColumnHeader.Columns[iCol].Width = 60;
                        }
                    }
                    else if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0)
                    {
                        if (iso_week == siMain.GetColumnTag(iCol).ToString().Substring(8) && siMain.GetColumnTag(iCol).ToString().Substring(2, 6) == sResultYYYYMMDD.Substring(0, 6))
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

        private bool fnValidation(out bool bInputCheck)
        {
            dtSaveFinal.Clear();
            bool bValidation = true;
            int iValidation = 0;
            string sProjectCode = string.Empty;
            string sSiteId = string.Empty;
            string sItemId = string.Empty;

            int iInsertRowCount = 0;
            for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
            {
                if (siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI)
                {
                    iInsertRowCount++;
                }
            }

            int iStartCol = 0;
            int[] bInputCnt = new int[iInsertRowCount];
            int iIdex = 0;
            int iCnt = 0;

            for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
            {
                if (siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI)
                {
                    iCnt = 0;

                    string sDivision = string.Empty;
                    string sDomExp = "", sFcstType = "", sIncoterms = "", sMeasure = "", sPlantSiteId = "";
                                                                                                                                             
                    if (clbDivision.ControlValues == "40")
                    {
                        sDivision = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Division40)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.Customer40) > 0)
                            sProjectCode = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Customer40)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.ScmSiteId40) > 0)
                            sSiteId = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ScmSiteId40)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.ItemId40) > 0)
                            sItemId = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ItemId40)).ToString();
                    }
                    else
                    {
                        if (siMain.GetColumnIndex(DefColumns.Division) > 0)
                            sDivision = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.Project) > 0)
                            sProjectCode = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Project)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.ScmSiteId) > 0)
                            sSiteId = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.ItemId) > 0)
                            sItemId = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ItemId)).ToString();
                    }

                    if (siMain.GetColumnIndex(DefColumns.DomExp) > 0)
                        sDomExp = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DomExp)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.FcstType) > 0)
                        sFcstType = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FcstType)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.Incoterms) > 0)
                        sIncoterms = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Incoterms)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.Measure) > 0)
                        sMeasure = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Measure)).ToString();

                    if (clbDivision.ControlValues.Substring(0, 2) == "81")
                        sPlantSiteId = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.PlantSiteId)).ToString();

                    for (int iRow2 = 0; iRow2 <= siMain.GetMaxRowIndex(); iRow2++)
                    {
                        if (clbDivision.ControlValues.Substring(0, 2) == "81")
                        {
                            if (sDivision == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.Division)).ToString()
                            && sProjectCode == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.Project)).ToString()
                            && sSiteId == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString()
                            && sItemId == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.ItemId)).ToString()
                            && sDomExp == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.DomExp)).ToString()
                            && sFcstType == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.FcstType)).ToString()
                            && sIncoterms == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.Incoterms)).ToString()
                            && sMeasure == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.Measure)).ToString()
                            && sPlantSiteId == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.PlantSiteId)).ToString()
                            )
                            {
                                iValidation++;
                            }
                        }
                        else if (clbDivision.ControlValues == "82")
                        {
                            if (sDivision == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.Division)).ToString()
                            && sProjectCode == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.Project)).ToString()
                            && sSiteId == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString()
                            && sItemId == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.ItemId)).ToString()
                            && sDomExp == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.DomExp)).ToString()
                            && sFcstType == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.FcstType)).ToString()
                            && sIncoterms == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.Incoterms)).ToString()
                            && sMeasure == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.Measure)).ToString()
                            )
                            {
                                iValidation++;
                            }
                        }
                                                                                                               
                            
                                                                                                                               
                                                                                                                                 
                                                                                                                             
                                                                                                                          
                                                                                                                            
                                                                                                                              
                                                                                                                          
                               
                                
                                                 
                                
                            
                        else
                        {
                            if (sDivision == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.Division40)).ToString()
                            && sProjectCode == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.Customer40)).ToString()
                            && sSiteId == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.ScmSiteId40)).ToString()
                            && sItemId == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.ItemId40)).ToString()
                            && sDomExp == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.DomExp)).ToString()
                            && sFcstType == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.FcstType)).ToString()
                            && sIncoterms == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.Incoterms)).ToString()
                            && sMeasure == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.Measure)).ToString()
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

                                   
                    iStartCol = siMain.GetColumnIndex(DefColumns.Measure) + 1;
                    for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                    {
                        if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 && siMain.GetText(iRow, iCol) != "")
                        {
                            iCnt++;
                        }
                    }
                    bInputCnt[iIdex] = iCnt;
                    iIdex++;
                }
            }

            bInputCheck = true;
            for (int i = 0; i < bInputCnt.Length; i++)
            {
                if (bInputCnt[i] == 0)
                    bInputCheck = false;
            }

            if (iValidation > 1)
            {
                bValidation = false;
                return bValidation;
            }
            else if (!bInputCheck)
            {
                return bValidation;
            }
            else                    
            {
                                                                                      
                                                                 
                foreach (DataRow dr in dtSave.Rows)
                {
                    string sAction = string.Empty;
                    sAction = dr["Action"].ToString();

                    string sDivision = string.Empty;            
                    if ((clbDivision.ControlValues.Substring(0, 2) == "81") || (clbDivision.ControlValues == "82"))
                    {
                        sDivision = dr[DefColumns.Division].ToString();
                        sProjectCode = dr[DefColumns.Project].ToString();
                        sSiteId = dr[DefColumns.ScmSiteId].ToString();
                        sItemId = dr[DefColumns.ItemId].ToString();
                    }
                    else
                    {
                        sDivision = dr[DefColumns.Division].ToString();
                        sProjectCode = dr[DefColumns.Customer40].ToString();
                        sSiteId = dr[DefColumns.ScmSiteId40].ToString();
                        sItemId = dr[DefColumns.ItemId40].ToString();
                    }
                    string sDomExp = dr[DefColumns.DomExp].ToString();
                    string sFcstType = dr[DefColumns.FcstType].ToString();
                    string sIncoterms = dr[DefColumns.Incoterms].ToString();
                    string sMeasure = dr[DefColumns.Measure].ToString();

                    string sPlantSiteId = string.Empty;
                                                                     
                    string sAsFromSite = string.Empty;
                    if (siMain.GetColumnIndex(DefColumns.AS_FROM_SITE) >= 0)
                    {
                        sAsFromSite = dr[DefColumns.AS_FROM_SITE].ToString();
                    }

                    if (clbDivision.ControlValues.Substring(0, 2) == "81")
                    {
                        sPlantSiteId = dr[DefColumns.PlantSiteId].ToString();
                    }

                    for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
                    {

                                                                          
                        Boolean bAsCompare = false;
                        if (siMain.GetColumnIndex(DefColumns.AS_FROM_SITE) >= 0)
                        {
                            if (sAsFromSite == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE)).ToString())
                            {
                                bAsCompare = true;
                            }
                        }
                        else
                        {
                            bAsCompare = true;
                        }

                        if (clbDivision.ControlValues.Substring(0, 2) == "81")
                        {
                            if (sDivision == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Division)).ToString()
                            && sProjectCode == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Project)).ToString()
                            && sSiteId == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString()
                            && sItemId == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ItemId)).ToString()
                            && sDomExp == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DomExp)).ToString()
                            && sFcstType == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FcstType)).ToString()
                            && sIncoterms == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Incoterms)).ToString()
                            && sMeasure == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Measure)).ToString()
                            && sPlantSiteId == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.PlantSiteId)).ToString()
                            && bAsCompare
                            )
                            {
                                if (sAction == "I" && siMain.GetValue(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)).ToString() != "I")                                                  
                                    continue;

                                DataRow drNew = dtSaveFinal.NewRow();
                                drNew[DefColumns.Division] = dr[DefColumns.Division].ToString();
                                drNew[DefColumns.Project] = dr[DefColumns.Project].ToString();
                                drNew[DefColumns.ScmSiteId] = dr[DefColumns.ScmSiteId].ToString();
                                drNew[DefColumns.ItemId] = dr[DefColumns.ItemId].ToString();
                                drNew[DefColumns.DomExp] = dr[DefColumns.DomExp].ToString();
                                drNew[DefColumns.FcstType] = dr[DefColumns.FcstType].ToString();
                                drNew[DefColumns.Incoterms] = dr[DefColumns.Incoterms].ToString();
                                drNew[DefColumns.Measure] = dr[DefColumns.Measure].ToString();
                                drNew[DefColumns.PlantSiteId] = dr[DefColumns.PlantSiteId].ToString();
                                drNew[DefColumns.YYYYMMDD] = dr[DefColumns.YYYYMMDD].ToString();
                                drNew[DefColumns.Qty] = dr[DefColumns.Qty].ToString();

                                drNew[DefColumns.Customer40] = dr[DefColumns.Customer40].ToString();
                                drNew[DefColumns.ScmSiteId40] = dr[DefColumns.ScmSiteId40].ToString();
                                drNew[DefColumns.ItemId40] = dr[DefColumns.ItemId40].ToString();

                                                                           
                                drNew[DefColumns.AS_FROM_SITE] = dr[DefColumns.AS_FROM_SITE].ToString();
                                                                         

                                dtSaveFinal.Rows.Add(drNew);
                                dtSaveFinal.AcceptChanges();
                            }
                        }
                        else if (clbDivision.ControlValues == "82")
                        {
                            if (sDivision == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Division)).ToString()
                            && sProjectCode == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Project)).ToString()
                            && sSiteId == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString()
                            && sItemId == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ItemId)).ToString()
                            && sDomExp == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DomExp)).ToString()
                            && sFcstType == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FcstType)).ToString()
                            && sIncoterms == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Incoterms)).ToString()
                            && sMeasure == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Measure)).ToString()
                            && bAsCompare
                            )
                            {
                                if (sAction == "I" && siMain.GetValue(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)).ToString() != "I")                                                  
                                    continue;

                                DataRow drNew = dtSaveFinal.NewRow();
                                drNew[DefColumns.Division] = dr[DefColumns.Division].ToString();
                                drNew[DefColumns.Project] = dr[DefColumns.Project].ToString();
                                drNew[DefColumns.ScmSiteId] = dr[DefColumns.ScmSiteId].ToString();
                                drNew[DefColumns.ItemId] = dr[DefColumns.ItemId].ToString();
                                drNew[DefColumns.DomExp] = dr[DefColumns.DomExp].ToString();
                                drNew[DefColumns.FcstType] = dr[DefColumns.FcstType].ToString();
                                drNew[DefColumns.Incoterms] = dr[DefColumns.Incoterms].ToString();
                                drNew[DefColumns.Measure] = dr[DefColumns.Measure].ToString();
                                drNew[DefColumns.YYYYMMDD] = dr[DefColumns.YYYYMMDD].ToString();
                                drNew[DefColumns.Qty] = dr[DefColumns.Qty].ToString();

                                drNew[DefColumns.Customer40] = dr[DefColumns.Customer40].ToString();
                                drNew[DefColumns.ScmSiteId40] = dr[DefColumns.ScmSiteId40].ToString();
                                drNew[DefColumns.ItemId40] = dr[DefColumns.ItemId40].ToString();

                                                                           
                                drNew[DefColumns.AS_FROM_SITE] = dr[DefColumns.AS_FROM_SITE].ToString();
                                                                         

                                dtSaveFinal.Rows.Add(drNew);
                                dtSaveFinal.AcceptChanges();
                            }
                        }
                                                                                                               
                            
                                                                                                                              
                                                                                                                                
                                                                                                                            
                                                                                                                         
                                                                                                                           
                                                                                                                             
                                                                                                                         
                                
                                
                                                                                                                                                  
                                                

                                                                        
                                                                                                   
                                                                                                    
                                                                                                     
                                                                                               
                                                                                               
                                                                                                   
                                                                                                     
                                                                                                 
                                                                                                         
                                                                                                   
                                                                                         

                                                                                                       
                                                                                                         
                                                                                                   

                                                               
                                                               
                                
                            
                        else
                        {
                            if (sDivision == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Division40)).ToString()
                            && sProjectCode == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Customer40)).ToString()
                            && sSiteId == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ScmSiteId40)).ToString()
                            && sItemId == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ItemId40)).ToString()
                            && sDomExp == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DomExp)).ToString()
                            && sFcstType == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FcstType)).ToString()
                            && sIncoterms == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Incoterms)).ToString()
                            && sMeasure == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Measure)).ToString()
                            && bAsCompare
                            )
                            {
                                if (sAction == "I" && siMain.GetValue(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)).ToString() != "I")
                                    continue;

                                DataRow drNew = dtSaveFinal.NewRow();
                                drNew[DefColumns.Division] = dr[DefColumns.Division].ToString();
                                drNew[DefColumns.Project] = dr[DefColumns.Customer40].ToString();
                                drNew[DefColumns.ScmSiteId] = dr[DefColumns.ScmSiteId].ToString();
                                drNew[DefColumns.ItemId] = dr[DefColumns.ItemId].ToString();
                                drNew[DefColumns.DomExp] = dr[DefColumns.DomExp].ToString();
                                drNew[DefColumns.FcstType] = dr[DefColumns.FcstType].ToString();
                                drNew[DefColumns.Incoterms] = dr[DefColumns.Incoterms].ToString();
                                drNew[DefColumns.Measure] = dr[DefColumns.Measure].ToString();
                                drNew[DefColumns.PlantSiteId] = dr[DefColumns.PlantSiteId].ToString();
                                drNew[DefColumns.YYYYMMDD] = dr[DefColumns.YYYYMMDD].ToString();
                                drNew[DefColumns.Qty] = dr[DefColumns.Qty].ToString();

                                drNew[DefColumns.Customer40] = dr[DefColumns.Customer40].ToString();
                                drNew[DefColumns.ScmSiteId40] = dr[DefColumns.ScmSiteId40].ToString();
                                drNew[DefColumns.ItemId40] = dr[DefColumns.ItemId40].ToString();

                                                                           
                                drNew[DefColumns.AS_FROM_SITE] = dr[DefColumns.AS_FROM_SITE].ToString();
                                                                         

                                dtSaveFinal.Rows.Add(drNew);
                                dtSaveFinal.AcceptChanges();
                            }
                        }
                    }
                }
            }
            return bValidation;
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

                                                                               
        private void GetSpdTitle(string stype)
        {
            string[] sMonth = drpPeriod.ControlValues.Split(':');

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                var request = new FoxDataRequest("DM.DMF0003_GET_SPREAD_TITLE");

                request.Parameters["p_start_yyyymmdd"] = sMonth[0];              
                request.Parameters["p_end_yyyymmdd"] = sMonth[1];
                request.Parameters["p_created_by"] = base.UserInfo.UserId;
                request.Parameters["p_division_id"] = clbDivision.ControlValues;

                                                                                                                  
                request.Parameters["p_user_group"] = UserInfoContext.Current["NowGroupID"].ToString();                     
                request.Parameters["p_type"] = stype;                                                                                     
                                                                                                                
                dtTitle = client.ExecuteDataSet(request).DataSet.Tables[0];
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

        private DataTable GetItemType2(string strCode)
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sScmBinding))
            {
                var request = new FoxDataRequest("SCM.SCM0001_GET_LOOKUP_VALUES");
                request.Parameters["p_lookup_type"] = strCode;
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

        private void btnIncotermsChg_Click(object sender, EventArgs e)
        {
            string sDivision = clbDivision.ControlValues;
            string sTeam = clbTeam.ControlValues;
            string sEndCustomer = clbCustomer.ControlValues;
            string sScmSiteID = clbSalesSite.ControlValues;
            string sProject = txtProject.Text;

            DMF0003_MatsterChgPopup popAdjst = new DMF0003_MatsterChgPopup();
            popAdjst.Form_Load(true, sDivision, sTeam, sEndCustomer, sScmSiteID, sProject);

            popAdjst.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            popAdjst.ShowDialog();
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

        private void spdMain_EditChange(object sender, EditorNotifyEventArgs e)
        {
            if (siMain.GetColumnIndex(DefColumns.Measure) >= siMain.ActiveColumnIndex) return;

            bPasteContinue = true;

        }

                                                                               
        private void spdMain_ClipboardPasted(object sender, ClipboardPastedEventArgs e)
        {
                                                            

            for (int iRow = e.CellRange.Row; iRow < e.CellRange.Row + e.CellRange.RowCount; iRow++)
            {
                for (int iCol = e.CellRange.Column; iCol < e.CellRange.Column + e.CellRange.ColumnCount; iCol++)
                {
                    if (iCol == siMain.GetColumnIndex(DefColumns.ScmSiteId40))
                    {
                        if (siMain.GetColumnIndex(DefColumns.Division40) != -1 && siMain.GetColumnIndex(DefColumns.ScmSiteId40) != -1)
                        {
                            string sDivisionID = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Division40)).ToString();
                            string sScmSiteID = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ScmSiteId40)).ToString();

                            dtMeasure = Data.Common(Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, "", UserInfoContext.Current.UserId, "");
                            siMain.SetCellTypeCombo(iRow, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure);
                        }
                    }
                    else if (iCol == siMain.GetColumnIndex(DefColumns.ScmSiteId))
                    {
                        if (siMain.GetColumnIndex(DefColumns.Division) != -1 && siMain.GetColumnIndex(DefColumns.ScmSiteId) != -1)
                        {
                            string sDivisionID = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                            string sScmSiteID = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();

                            DataTable dtIncotermsType = GetIncotermsType(sDivisionID, sScmSiteID);
                            siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Incoterms), dtIncotermsType);
                        }
                                                                                               
                        if ((clbDivision.ControlValues.Substring(0, 2) == "81") || (clbDivision.ControlValues == "82"))
                        {
                            if (siMain.GetColumnIndex(DefColumns.AS_FROM_SITE) > 0)
                            {
                                                                                                         
                                DataTable dtAsSalesSite = null;
                                dtAsSalesSite = Data.Common(Data.Type.AS_FROM_SITE, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division)).ToString(), "", "", "", "");

                                DataTable dtAsFcstType = null;
                                dtAsFcstType = GetLookupValues("FCST_TYPE", "EDIT_MODE", "", "", "", "");

                                string sDivisionID = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                                string sScmSiteID = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                                string sProjectCode = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Project)).ToString();

                                sScmSiteID = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                                dtMeasure = Data.Common(Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, sProjectCode, UserInfoContext.Current.UserId, "");

                                if (dtAsSalesSite.Select("Name = '" + (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString()) + "'").Length > 0)
                                {
                                                                                           
                                    dtMeasure.AcceptChanges();
                                    foreach (DataRow row in dtMeasure.Rows)
                                    {
                                        if (row["Code"].ToString() != "AS_In_Req")
                                        {
                                            row.Delete();
                                        }
                                    }
                                    dtMeasure.AcceptChanges();
                                    siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure);
                                    siMain.SetText(iRow, siMain.GetColumnIndex(DefColumns.Measure), "");

                                                                                                           
                                    siMain.SetText(iRow, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE), "");
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE), iRow, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE), true);
                                                                                                         

                                }
                                else
                                {
                                                                                             
                                    dtMeasure.AcceptChanges();
                                    foreach (DataRow row in dtMeasure.Rows)
                                    {
                                        if (row["Code"].ToString() != "MKT_FCST_RP")
                                        {
                                            row.Delete();
                                        }
                                    }
                                    dtMeasure.AcceptChanges();
                                    siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure);

                                                                                                                     
                                    if (dtAsFcstType.Select("Code = '" + (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FcstType)).ToString()) + "'").Length > 0)
                                    {
                                        siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE), iRow, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE), false);
                                    }
                                    else
                                    {
                                        siMain.SetText(iRow, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE), "");
                                        siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE), iRow, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE), true);
                                    }
                                                                                                                   
                                }
                                                                                                        
                            }
                                                                                                 
                        }
                    }
                }
            }
        }

                                                                                               
        private void spdMain_CellClick(object sender, CellClickEventArgs e)
        {
            string sDivision = clbDivision.ControlValues;
            string sProject = "";
            string sItem = "";
            string sScmSite = "";                                                           

            if (!siMain.IsLock(siMain.ActiveSheet.SheetName))
            {
                if (e.Column == siMain.GetColumnIndex(DefColumns.PlantSiteId) || sDivision.Substring(0, 2) == "81")
                {
                    sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                    sProject = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Project)).ToString();
                    sItem = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ItemId)).ToString();

                                                          
                    if (siMain.GetValue(e.Row, 0).ToString() != "")
                    {
                        dtPlantSite = Data.Common(Data.Type.PlantSiteByItem, false, "", sDivision, sProject, sItem);
                        siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.PlantSiteId), dtPlantSite);
                    }

                }
                                                                          
                if (sDivision == "82")
                {
                    if (e.Column == siMain.GetColumnIndex(DefColumns.Measure) && siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.NewFlag)).ToString() == CAppSetting.StringY)
                    {
                        sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                        sScmSite = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                        sProject = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Project)).ToString();

                        dtMeasure = Data.Common(Data.Type.MktFcstEditMeasure, false, sDivision, sScmSite, sProject, UserInfoContext.Current.UserId, "");
                        siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure);
                    }
                }
                                                                                       
                else if (e.Column == siMain.GetColumnIndex(DefColumns.Measure))
                {
                    if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI)
                    {
                                                                                               
                        if ((clbDivision.ControlValues.Substring(0, 2) == "81") || (clbDivision.ControlValues == "82"))
                        {
                            string sDivisionID = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                            string sScmSiteID = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                            string sProjectCode = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Project)).ToString();

                            sScmSiteID = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                            dtMeasure = Data.Common(Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, sProjectCode, UserInfoContext.Current.UserId, "");

                                                                                                     
                            DataTable dtAsSalesSite = null;
                            dtAsSalesSite = Data.Common(Data.Type.AS_FROM_SITE, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division)).ToString(), "", "", "", "");

                            if (dtAsSalesSite.Select("Name = '" + (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString()) + "'").Length > 0)
                            {

                                                                                       
                                dtMeasure.AcceptChanges();
                                foreach (DataRow row in dtMeasure.Rows)
                                {
                                    if (row["Code"].ToString() != "AS_In_Req")
                                    {
                                        row.Delete();
                                    }
                                }
                                dtMeasure.AcceptChanges();
                                siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure);
                                siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.Measure), "");
                            }
                            else
                            {
                                                                                         
                                dtMeasure.AcceptChanges();
                                foreach (DataRow row in dtMeasure.Rows)
                                {
                                    if (row["Code"].ToString() != "MKT_FCST_RP")
                                    {
                                        row.Delete();
                                    }
                                }
                                dtMeasure.AcceptChanges();
                                siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure);
                            }
                                                                                                    
                        }
                                                                                             
                    }
                                                                                         
                }
            }
        }

                      
                     
                       
                                             
                                
        public static int GetWeekNumber(string sYYYYMMDD)
        {
            int year = Convert.ToInt16(sYYYYMMDD.Substring(0, 4));
            int month = Convert.ToInt16(sYYYYMMDD.Substring(4, 2));
            int day = Convert.ToInt16(sYYYYMMDD.Substring(6, 2));

            DateTime calculationDate = new DateTime(year, month, day);             
            DateTime standardDate = new DateTime(year, 1, 1);         
            Calendar calendarCalc = CultureInfo.CurrentCulture.Calendar;
            int weekNumber = calendarCalc.GetWeekOfYear(calculationDate, CalendarWeekRule.FirstDay, DayOfWeek.Monday)

                    - calendarCalc.GetWeekOfYear(standardDate, CalendarWeekRule.FirstDay, DayOfWeek.Monday) + 1;
            return weekNumber;
        }

        private void contextMenuStrip1_ItemClicked(object sender, ToolStripItemClickedEventArgs e)
        {
            FarPoint.Win.Spread.Model.CellRange[] cellRanges = siMain.ActiveSheet.GetSelections();
            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);

                                     

            if (cellRanges.Length == 0)
            {
                MessageBox.Show("선택된 셀이 없습니다.");
                return;
            }


                                      
                                                                                                          
                                                                                                                         
                                                                                   
                
                                   
                

            List<string> liItemId = new List<string>();
            ArrayList arScmSiteId = new ArrayList();
            ArrayList arDomExp = new ArrayList();
            ArrayList arFcstType = new ArrayList();
            ArrayList arIncoterms = new ArrayList();
            ArrayList arPlantSiteId = new ArrayList();
            ArrayList arQty = new ArrayList();
            ArrayList arProjectCode = new ArrayList();
            ArrayList arYYYYMMDD = new ArrayList();

            string sItemId = "", sScmSiteId = "", sDomExp = "", sFcstType = "", sIncoterms = "", sPlantSiteId = "", sProjectCode = "", sYYYYMMDD = "", sQty = "";
                                                                  
            DateTime sMonday = DateTime.Today.AddDays(Convert.ToInt32(DayOfWeek.Monday) - Convert.ToInt32(DateTime.Today.DayOfWeek));
            string checkYYYYMMDD = sMonday.ToString("yyyyMMdd");

            bool bExit = false;                  
            bool bValue = false;                           

            if (e.ClickedItem.Name == "Request_PR")
            {
                           
                                                                          
                for (int i = 0; i < cellRanges.Length; i++)
                {
                    for (int c = 0; c < cellRanges[i].ColumnCount; c++)
                    {
                                                                               
                        if (siMain.GetColumnTag(cellRanges[i].Column + c).IndexOf("D_") == 0)
                        {
                            for (int r = 0; r < cellRanges[i].RowCount; r++)
                            {
                                                     
                                if (siMain.GetValue(cellRanges[i].Row + r, siMain.GetColumnIndex(DefColumns.Measure)).ToString() != "BNPIn"
                                    || siMain.GetValue(cellRanges[i].Row + r, cellRanges[i].Column + c).ToString() == "0"
                                    || siMain.GetValue(cellRanges[i].Row + r, cellRanges[i].Column + c).ToString() == ""
                                    )
                                {
                                    continue;
                                }
                                if (sDivision == "40")
                                {
                                    liItemId.Add(siMain.GetValue(cellRanges[i].Row + r, siMain.GetColumnIndex(DefColumns.ItemId40)).ToString());
                                    arScmSiteId.Add(siMain.GetValue(cellRanges[i].Row + r, siMain.GetColumnIndex(DefColumns.ScmSiteId40)).ToString());
                                }
                                else
                                {
                                    liItemId.Add(siMain.GetValue(cellRanges[i].Row + r, siMain.GetColumnIndex(DefColumns.ItemId)).ToString());
                                    arScmSiteId.Add(siMain.GetValue(cellRanges[i].Row + r, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString());
                                }

                                arDomExp.Add(siMain.GetValue(cellRanges[i].Row + r, siMain.GetColumnIndex(DefColumns.DomExp)).ToString());
                                arFcstType.Add(siMain.GetValue(cellRanges[i].Row + r, siMain.GetColumnIndex(DefColumns.FcstType)).ToString());
                                arIncoterms.Add(siMain.GetValue(cellRanges[i].Row + r, siMain.GetColumnIndex(DefColumns.Incoterms)).ToString());
                                if (siMain.GetColumnIndex(DefColumns.PlantSiteId) > 0)
                                {
                                    arPlantSiteId.Add(siMain.GetValue(cellRanges[i].Row + r, siMain.GetColumnIndex(DefColumns.PlantSiteId)).ToString());
                                }
                                arProjectCode.Add(siMain.GetValue(cellRanges[i].Row + r, siMain.GetColumnIndex(DefColumns.Project)).ToString());
                                                                                      
                                if (int.Parse(checkYYYYMMDD) > int.Parse(siMain.GetColumnTag(cellRanges[i].Column + c).Replace("D_", "")))
                                {
                                    bExit = true;
                                    MessageBox.Show("실적 구간이 포함되어 있습니다.");
                                    return;
                                }
                                arYYYYMMDD.Add(siMain.GetColumnTag(cellRanges[i].Column + c).Replace("D_", ""));
                                arQty.Add(siMain.GetValue(cellRanges[i].Row + r, cellRanges[i].Column + c).ToString());
                            }
                        }
                                                                              
                                           
                        if (cboBucketType.ControlValues != BucketType.Daily || siMain.ActiveSheet.Columns[cellRanges[i].Column + c].Visible == true)
                        {
                            if (siMain.GetColumnTag(cellRanges[i].Column + c).IndexOf("D_") != 0)
                            {
                                for (int r = 0; r < cellRanges[i].RowCount; r++)
                                {
                                    if (siMain.GetValue(cellRanges[i].Row + r, cellRanges[i].Column + c).ToString() != "")
                                    {
                                        bValue = true;
                                        break;
                                    }
                                }

                                if (bValue)
                                {

                                    bExit = true;
                                    MessageBox.Show("일자컬럼에서만 사용가능합니다.");
                                    return;
                                }
                            }
                        }

                        if (bExit)
                        {
                            break;
                        }
                    }
                    if (bExit)
                    {
                        break;
                    }
                                                                          
                    if (arQty.Count == 0)
                    {
                        MessageBox.Show("Request 할 내용이 없습니다.");
                        return;
                    }
                }
                if (liItemId.Distinct<string>().ToList<string>().Count() != liItemId.Count())
                {
                    MessageBox.Show("Model 은 중복될 수 없습니다.");
                    return;
                }

                for (int i = 0; i < arProjectCode.Count; i++)
                {
                    if (i < arProjectCode.Count - 1 && arProjectCode[i].ToString() != arProjectCode[i + 1].ToString())
                    {
                        MessageBox.Show("Project 는 동일해야 합니다.");
                        return;
                    }
                }

                                                                       
                                                             
                    
                                                                                                                
                        
                                                            
                                  
                        
                    

                for (int i = 0; i < liItemId.Count(); i++)
                {
                    sProjectCode = arProjectCode[0].ToString();                 

                    sItemId += ((i == 0) ? "" : "^") + liItemId[i].ToString();
                    sScmSiteId += ((i == 0) ? "" : "^") + arScmSiteId[i].ToString();
                    sDomExp += ((i == 0) ? "" : "^") + arDomExp[i].ToString();
                    sFcstType += ((i == 0) ? "" : "^") + arFcstType[i].ToString();
                    sIncoterms += ((i == 0) ? "" : "^") + arIncoterms[i].ToString();
                    if (siMain.GetColumnIndex(DefColumns.PlantSiteId) > 0)
                    {
                        sPlantSiteId += ((i == 0) ? "" : "^") + arPlantSiteId[i].ToString();
                    }
                    sYYYYMMDD += ((i == 0) ? "" : "^") + arYYYYMMDD[i].ToString();
                    sQty += ((i == 0) ? "" : "^") + arQty[i].ToString();
                }

                if (bExit)
                {
                    return;
                }

                DMF0003_PRPopup popup = new DMF0003_PRPopup();
                popup.Form_Load(e.ClickedItem.Name, "", sDivision, sProjectCode, sScmSiteId, sItemId, sDomExp, sFcstType, sIncoterms, sPlantSiteId, sYYYYMMDD, sQty);
                popup.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                popup.ShowDialog();

            }
            else if (e.ClickedItem.Name == "View_PR" || e.ClickedItem.Name == "Add_History" || e.ClickedItem.Name == "View_History")
            {
                if (cellRanges.Length != 1 || cellRanges[0].ColumnCount != 1 || cellRanges[0].RowCount != 1)
                {
                    MessageBox.Show(e.ClickedItem.Text + "버튼은 한 개의 셀만 선택할 수 있습니다. ");
                    return;
                }
                                                       
                if (siMain.GetValue(cellRanges[0].Row, siMain.GetColumnIndex(DefColumns.Measure)).ToString() != "BNPIn")
                {
                    bExit = true;
                    MessageBox.Show("BNP In 메저행에서만 사용가능합니다.");
                    return;
                }
                                   
                if (siMain.GetColumnTag(cellRanges[0].Column).IndexOf("D_") != 0)
                {
                    bExit = true;
                    MessageBox.Show("일자컬럼에서만 사용가능합니다.");
                    return;
                }
                if (sDivision == "40")
                {
                    sItemId = siMain.GetValue(cellRanges[0].Row, siMain.GetColumnIndex(DefColumns.ItemId40)).ToString();
                    sScmSiteId = siMain.GetValue(cellRanges[0].Row, siMain.GetColumnIndex(DefColumns.ScmSiteId40)).ToString();
                }
                else
                {
                    sItemId = siMain.GetValue(cellRanges[0].Row, siMain.GetColumnIndex(DefColumns.ItemId)).ToString();
                    sScmSiteId = siMain.GetValue(cellRanges[0].Row, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                }
                sProjectCode = siMain.GetValue(cellRanges[0].Row, siMain.GetColumnIndex(DefColumns.Project)).ToString();
                sDomExp = siMain.GetValue(cellRanges[0].Row, siMain.GetColumnIndex(DefColumns.DomExp)).ToString();
                sFcstType = siMain.GetValue(cellRanges[0].Row, siMain.GetColumnIndex(DefColumns.FcstType)).ToString();
                sIncoterms = siMain.GetValue(cellRanges[0].Row, siMain.GetColumnIndex(DefColumns.Incoterms)).ToString();
                if (siMain.GetColumnIndex(DefColumns.PlantSiteId) > 0)
                {
                    sPlantSiteId = siMain.GetValue(cellRanges[0].Row, siMain.GetColumnIndex(DefColumns.PlantSiteId)).ToString();
                }
                sYYYYMMDD = siMain.GetColumnTag(cellRanges[0].Column).Replace("D_", "");
                sQty = siMain.GetValue(cellRanges[0].Row, cellRanges[0].Column).ToString();

                if (e.ClickedItem.Name == "View_History")
                {
                    DMF0003_PRHistoryPopup popup = new DMF0003_PRHistoryPopup();
                    popup.Form_Load(e.ClickedItem.Name, "", sDivision, sProjectCode, sScmSiteId, sItemId, sDomExp, sFcstType, sIncoterms, sPlantSiteId, sYYYYMMDD, sQty);
                    popup.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                    popup.ShowDialog();
                }
                else
                {
                    DMF0003_PRPopup popup = new DMF0003_PRPopup();
                    popup.Form_Load(e.ClickedItem.Name, "", sDivision, sProjectCode, sScmSiteId, sItemId, sDomExp, sFcstType, sIncoterms, sPlantSiteId, sYYYYMMDD, sQty);
                    popup.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                    popup.ShowDialog();
                }

            }
        }

                                                                                            
            
                                                                                                     
                                                 

                                          
                
                                                     
                
            

        private int getDayOfWeek(int iCol)
        {
            string strD = siMain.GetColumnTag(iCol).Replace("D_", "");
            string strD2 = strD.Substring(0, 4) + "-" + strD.Substring(4, 2) + "-" + strD.Substring(6, 2);

            return (int)Convert.ToDateTime(strD2).DayOfWeek;
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

                      
                                                                                        
                       
                                
        private DataTable GetSalesSite(string sDivisionID, string sCustomer, string groupID, string userId)
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                var request = new FoxDataRequest("DM.UP_FX_GetCommonDataList_DM");
                request.Parameters["CODE"] = "SiteByEndCustomer";
                request.Parameters["PARAM1"] = sDivisionID;
                request.Parameters["PARAM2"] = sCustomer;
                request.Parameters["PARAM3"] = groupID;
                request.Parameters["PARAM4"] = userId;
                                                                                          
                                                                             
                request.Parameters["PARAM5"] = UserInfoContext.Current["NowGroupID"] == "DM Planner (W/S)" ? "Y" : "N";
                                                                                        
                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }
            return dt;
        }

                      
                                                                                     
                       
                                
        private DataTable GetSalesSite40(string sTeamID, string sCustomer, string groupID, string userId)
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                var request = new FoxDataRequest("DM.UP_FX_GetCommonDataList_DM");
                request.Parameters["CODE"] = "SiteByEndCustomer40";
                request.Parameters["PARAM1"] = sTeamID;
                request.Parameters["PARAM2"] = sCustomer;
                request.Parameters["PARAM3"] = groupID;
                request.Parameters["PARAM4"] = userId;
                                                                                          
                                                                            
                request.Parameters["PARAM5"] = UserInfoContext.Current["NowGroupID"] == "DM Planner (W/S)" ? "Y" : "N";
                                                                                        
                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }
            return dt;
        }

        private void cboAS_CheckedChanged(object sender, EventArgs e)
        {
            if ((clbDivision.ControlValues.Substring(0, 2) == "81") || (clbDivision.ControlValues == "82"))
            {
                dtSalesSite = GetSalesSite(clbDivision.ControlValues, clbCustomer.ControlValues, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
            }
            else
            {
                dtSalesSite = GetSalesSite40(clbTeam.ControlValues, clbCustomer.ControlValues, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
            }
            clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);
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

        private DataTable GetEdiSender()
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                var request = new FoxDataRequest("DM.UP_FX_GetCommonDataList_DM");
                request.Parameters["CODE"] = "EDI_SENDER_CODE";
                request.Parameters["PARAM1"] = "";
                request.Parameters["PARAM2"] = "";
                request.Parameters["PARAM3"] = "";
                request.Parameters["PARAM4"] = "";
                request.Parameters["PARAM5"] = "";
                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }
            return dt;
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
