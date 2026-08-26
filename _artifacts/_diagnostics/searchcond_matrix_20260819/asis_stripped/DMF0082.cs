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
using GSCM.DM.Master.UIL;

                                                                                                                            
                                             
                   
                   
                                                                                                                            
                                             
                                                                                                                            
                                                                     
                                                                             
                                                                                         
                                                                                                                                     
                                                                             
                                                                                            
                                                                                                                                   
                                                                                                                                        
                                                                                      
                                                                 
                                                                                           
                                                                                       
                                                                                   
                                                                     
                                                                          
                                                                                                         
                                                                           
                                                                                                                     
                                                                                                                     
                                                          
                                                                            
                                                                                     
                                                                 
                                                                                                                           

namespace GSCM.DM.Plan.UIL
{
    public partial class DMF0082_FcstNPrice_Mgmt : BaseForm
    {
        #region 1. Setting
        CControl clsCtrl = null;

        DataTable dtFuturePrice = null;

                           
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
        private DataTable dtCurrency = null;
        private DataTable dtCellProdSiteID = null;

        private DataTable dtCustomsHandbook = null;                                           
        private DataTable dtWarrType = null;                                          

        private DataTable dtCustomer40 = null;
        private DataTable dtSalesSite40 = null;
        private DataTable dtWeek = null;                                           
        private DataTable dtCalendarDetail = null;                                                                        
        private DataTable dt_VMI_YN = null;          

        private DataTable dtSalesBucket = null;                                                                                           

        private DataTable dtEdiSender = null;
        private DataTable dtincotermsEditType = null;                                                                                    

        private string this_YYYYMMWW = "";
        private string this_YYYYMM = "";
        private string sResultYYYYMMDD = "";
        private string sResult_YYYYMMWW = "";
        private string iso_week = "";
        private int count = 0;

        private bool isCurVersion = false;                           

                                                                  
        private bool bEDIT_AUTH_SCM_FCST = false;
        private bool bEDIT_AUTH_MKT_FCST = false;
        private bool bEDIT_AUTH_LOC = false;
        private bool bEDIT_AUTH_VMI_IN_REQ = false;
        private int iResultCol = -1;
        private string sBfBucket = "";
                                                                  

                                                           
        List<int> list_EDIT_Week = new List<int>();
        List<int> list_EDIT_Month = new List<int>();
        List<int> list_EDIT_Day = new List<int>();
        List<int> list_EDIT_Month_M4 = new List<int>();                                           
        FarPoint.Win.Spread.Model.CellRange range = null;                                                            


                  
        SpreadInfo siMain = null;
        TextCellType cellTypeImage = null;
        SheetView sv = null;

                      
                       
                       
        private struct SpdSheet
        {
            public static string shtMain = "FcstNPrice";
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
            public static string CURRENCY = "CURRENCY";
            public static string MEASURE = "MEASURE";

                                   
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

            public static string CELL_PROD_SITE_ID = "CELL_PROD_SITE_ID";

            public static string VERSION_NO = "VERSION_NO";
            public static string FORECAST_INFO_ALL = "FORECAST_INFO_ALL";
            public static string FORECAST_INFOR_VERSION = "FORECAST_INFOR_VERSION";
            public static string CELL_MODEL_NICK_NAME = "CELL_MODEL_NICK_NAME";
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

            public static string VERSION_NO = "Version";
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

        public DMF0082_FcstNPrice_Mgmt()
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
        }

        protected override void OnShown(EventArgs e)
        {
            base.OnShown(e);

            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);

            if (sDivision == "40")
            {
                cboBucketType.ControlValues = BucketType.Weekly;
            }
        }

        #endregion

        #region 3. Define
        private void InitControls()
        {
            #region 조회조건 컨트롤 세팅
                                 
            SetChangeControl("MyDivision");
            dtDivision = dtDivision.Select("CODE = '40'").CopyToDataTable();
            clsCtrl.setListBox(dtDivision, clbDivision, false, "CODE", "NAME");

                                  
            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);
            SetChangeControl("UserTeamByDivision", sDivision);
            clsCtrl.setListBox(dtTeam, clbTeam, true);

                           
            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);
            SetChangeControl("EndCustomerByDivision", sDivision, sTeam);
            clsCtrl.setListBox(dtEndCustomer, clbCustomer, true);

                       
            SetChangeControl("BizType", sDivision);
            clsCtrl.setListBox(dtBizType, clbBizType, true);
            lblBizType.Enabled = true;

                     
            drpPeriod.InitValue = GetDayRange();

                                        
            SetChangeControl("ScmSitebyEndCustomer40");
            clsCtrl.setListBox(dtSalesSite40, clbSalesSite, true);

                     
            dtBucketType = GetBucketType();
            clsCtrl.setListBox(dtBucketType, cboBucketType, false, "CODE", "NAME");

                                       
            txtVersion.Text = "Current";

                                       
            System.Windows.Forms.ToolTip toolTip1 = new System.Windows.Forms.ToolTip();
            toolTip1.SetToolTip(btnColumn, "Column Show");
            toolTip1.SetToolTip(btnMeasure, "Measure");

                                 
            dtFuturePrice = GetFuturePriceInfo();

            chkSum.Checked = false;                                                                                                         
            #endregion
        }

        private void CreateSpread()
        {
            this.AddSheet(spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20);
            siMain = GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex);
            siMain.ChangeSheet();
            sv = siMain.Sheet(siMain.SpreadObject.ActiveSheet.SheetName);
            InitSpread();
        }

        private void DefineProperty()
        {
            usrConditionPanel1.Height = 108;

            cboBucketType.ControlValues = BucketType.Weekly;
            sBfBucket = cboBucketType.ControlValues;                                           

            siMain.ImagePopUp = imageList1.Images[0];

            cellTypeImage = new TextCellType();
            cellTypeImage.BackgroundImage = new FarPoint.Win.Picture(siMain.ImagePopUp);
            cellTypeImage.BackgroundImage.AlignHorz = FarPoint.Win.HorizontalAlignment.Right;
            cellTypeImage.CharacterCasing = CharacterCasing.Upper;

            CanModelChange = true;

            FarPoint.Win.Spread.Model.DefaultSheetDataModel dsdm = (FarPoint.Win.Spread.Model.DefaultSheetDataModel)siMain.Sheet(SpdSheet.shtMain).Models.Data;
            dsdm.Changed += new FarPoint.Win.Spread.Model.SheetDataModelEventHandler(spdMain_Changed);

                                                            
            this.spdMain.KeyUp -= new System.Windows.Forms.KeyEventHandler(base.BaseForm_KeyUp);
        }

        private void InitSpread()
        {
            GetSpdTitle();
            siMain.CreateSheetHeaderColumn(siMain, 3, dtTitle);

            if (dtTitle != null && dtTitle.Rows.Count > 0)
            {
                SetSpreadHeaderSpan(dtTitle);
                SetSpreadColumn();
                InitSpreadFooterSum();
            }
        }

        private void GetSpdTitle()
        {
            string[] sMonth = drpPeriod.ControlValues.Split(':');

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                                                                                   
                var request = new FoxDataRequest("DM.DMF0082_GET_SPREAD_TITLE");

                request.Parameters["p_start_yyyymmdd"] = sMonth[0];              
                request.Parameters["p_end_yyyymmdd"] = sMonth[1];
                request.Parameters["p_created_by"] = base.UserInfo.UserId;
                request.Parameters["p_division_id"] = clbDivision.ControlValues;

                dtTitle = client.ExecuteDataSet(request).DataSet.Tables[0];
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

                if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                {
                    if (siMain.GetColumnTag(iCol).Substring(2) == sResultYYYYMMDD.Substring(0, 6))
                    {
                        siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor = Color.Green;
                        siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font = new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
                                                                                                                 
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

        private void InitSaveDataTable()
        {
            dtSave = new DataTable("MktFcstSave");
            dtSave.Columns.Add(CAppSetting.StringAction, typeof(string));
            dtSave.Columns.Add(DefColumns.Division, typeof(string));
            dtSave.Columns.Add(DefColumns.Project, typeof(string));
            dtSave.Columns.Add(DefColumns.Customer, typeof(string));
            dtSave.Columns.Add(DefColumns.ScmSiteId, typeof(string));
            dtSave.Columns.Add(DefColumns.ItemId, typeof(string));
            dtSave.Columns.Add(DefColumns.DomExp, typeof(string));
            dtSave.Columns.Add(DefColumns.FcstType, typeof(string));
            dtSave.Columns.Add(DefColumns.Incoterms, typeof(string));
            dtSave.Columns.Add(DefColumns.Measure, typeof(string));
            dtSave.Columns.Add(DefColumns.PlantSiteId, typeof(string));
            dtSave.Columns.Add(DefColumns.CELL_PROD_SITE_ID, typeof(string));
            dtSave.Columns.Add(DefColumns.YYYYMMDD, typeof(string));
            dtSave.Columns.Add(DefColumns.CURRENCY, typeof(string));
            dtSave.Columns.Add(DefColumns.Qty, typeof(decimal));

            dtSaveFinal = new DataTable("MktFcstSave");
            dtSaveFinal.Columns.Add(CAppSetting.StringAction, typeof(string));
            dtSaveFinal.Columns.Add(DefColumns.Division, typeof(string));
            dtSaveFinal.Columns.Add(DefColumns.Project, typeof(string));
            dtSaveFinal.Columns.Add(DefColumns.Customer, typeof(string));
            dtSaveFinal.Columns.Add(DefColumns.ScmSiteId, typeof(string));
            dtSaveFinal.Columns.Add(DefColumns.ItemId, typeof(string));
            dtSaveFinal.Columns.Add(DefColumns.DomExp, typeof(string));
            dtSaveFinal.Columns.Add(DefColumns.FcstType, typeof(string));
            dtSaveFinal.Columns.Add(DefColumns.Incoterms, typeof(string));
            dtSaveFinal.Columns.Add(DefColumns.Measure, typeof(string));
            dtSaveFinal.Columns.Add(DefColumns.PlantSiteId, typeof(string));
            dtSaveFinal.Columns.Add(DefColumns.CELL_PROD_SITE_ID, typeof(string));
            dtSaveFinal.Columns.Add(DefColumns.YYYYMMDD, typeof(string));
            dtSaveFinal.Columns.Add(DefColumns.CURRENCY, typeof(string));
            dtSaveFinal.Columns.Add(DefColumns.Qty, typeof(decimal));
        }
        #endregion

        #region  4. Button

        protected override void FindButton()
        {
                                                        

            FindData();
        }

        protected override void InsertButton()
        {
                                      
            if (!isCurVersion) return;

            InsertRow();
        }

        protected override void DeleteButton()
        {
            FarPoint.Win.Spread.Model.CellRange cr = sv.GetSelection(0);

            if (sv.ActiveRow == null) return;

                                                                                                
                                                                                               
                                     
            if (cr is null)
            {
                sv.SetActiveCell(sv.ActiveRowIndex, sv.ActiveColumnIndex);
            }
            else
            {
                siMain.SetSelection(sv.ActiveRowIndex, sv.ActiveColumnIndex, 1, 1);
            }
                                                                                              

                                                                                                              
                               
                                                                                                                               
              
                                                             
              
              

                                                                                      
                             
                                                                                                                                                                      
                                                          
                                                                            
                                                                                                   
                                                                                                                       
              

                               
                 
                           
                                                                                                            


            if (list_EDIT_Day.Count == 0)
            {
                return;
            }

            string sAction = string.Empty;
            string sDivision = string.Empty;
            string sProjectCode = string.Empty;
            string sEndCustomer = string.Empty;
            string sScmSiteId = string.Empty;
            string sItemId = string.Empty;
            string sDomExp = string.Empty;
            string sFcstType = string.Empty;
            string sIncoterms = string.Empty;
            string sMeasure = string.Empty;
            string sPlantSiteId = string.Empty;
            string sCellProdSiteID = string.Empty;
            string sYYYYMMDD = string.Empty;
            string sCurrency = string.Empty;
            decimal iQty = 0;
            string sQty = "";

            ArrayList alDelDayList = new ArrayList();

            int iActRow = siMain.ActiveRowIndex;

            if (siMain.GetColumnIndex(CAppSetting.StringAction) >= 0)
                sAction = siMain.GetValue(iActRow, siMain.GetColumnIndex(CAppSetting.StringAction)).ToString();
            if (siMain.GetColumnIndex(DefColumns.Division) >= 0)
                sDivision = siMain.GetText(iActRow, siMain.GetColumnIndex(DefColumns.Division));
            if (siMain.GetColumnIndex(DefColumns.Customer) >= 0)
                sProjectCode = siMain.GetValue(iActRow, siMain.GetColumnIndex(DefColumns.Customer)).ToString();
            if (siMain.GetColumnIndex(DefColumns.Customer) >= 0)
                sEndCustomer = siMain.GetText(iActRow, siMain.GetColumnIndex(DefColumns.Customer));
            if (siMain.GetColumnIndex(DefColumns.ScmSiteId) >= 0)
                sScmSiteId = siMain.GetValue(iActRow, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
            if (siMain.GetColumnIndex(DefColumns.ItemId) >= 0)
                sItemId = siMain.GetText(iActRow, siMain.GetColumnIndex(DefColumns.ItemId));
            if (siMain.GetColumnIndex(DefColumns.DomExp) >= 0)
                sDomExp = siMain.GetValue(iActRow, siMain.GetColumnIndex(DefColumns.DomExp)).ToString();
            if (siMain.GetColumnIndex(DefColumns.FcstType) >= 0)
                sFcstType = siMain.GetValue(iActRow, siMain.GetColumnIndex(DefColumns.FcstType)).ToString();
            if (siMain.GetColumnIndex(DefColumns.Incoterms) >= 0)
                sIncoterms = siMain.GetValue(iActRow, siMain.GetColumnIndex(DefColumns.Incoterms)).ToString();
            if (siMain.GetColumnIndex(DefColumns.Measure) >= 0)
                sMeasure = siMain.GetValue(iActRow, siMain.GetColumnIndex(DefColumns.Measure)).ToString();
            if (siMain.GetColumnIndex(DefColumns.PlantSiteId) >= 0)
                sPlantSiteId = siMain.GetValue(iActRow, siMain.GetColumnIndex(DefColumns.PlantSiteId)).ToString();
            if (siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID) >= 0)
                sCellProdSiteID = siMain.GetValue(iActRow, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID)).ToString();
            if (siMain.GetColumnIndex(DefColumns.CURRENCY) >= 0)
                sCurrency = siMain.GetValue(iActRow, siMain.GetColumnIndex(DefColumns.CURRENCY)).ToString();

            if (sAction == "D")                                                                       
            {                                                                                                 
                SetSaveDataRemove(sAction, sDivision, sProjectCode, sEndCustomer, sScmSiteId, sItemId, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sCellProdSiteID);
                siMain.Delete();                                                                             
            }
                                                                                                            
                                                                         
            else if (sAction == "I")
            {
                                                      
                SetSaveDataRemove(sAction, sDivision, sProjectCode, sEndCustomer, sScmSiteId, sItemId, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sCellProdSiteID);

                              
                siMain.DeleteRow();                          
            }
                                                                                                          
            else                                
            {
                if (sMeasure == "MKT_FCST" || sMeasure == "VMI_In_Req" || sMeasure == "SCM_FCST" || sMeasure == "LOC")                                     
                {
                                                                                                       
                    if (sMeasure == "SCM_FCST" && bEDIT_AUTH_SCM_FCST == false)
                    {
                        MessageHelper.GMessageBox("MSG00464");                    
                        return;
                    }

                    if (sMeasure == "MKT_FCST" && bEDIT_AUTH_MKT_FCST == false)
                    {
                        MessageHelper.GMessageBox("MSG00464");                    
                        return;
                    }

                    if (sMeasure == "LOC" && bEDIT_AUTH_LOC == false)
                    {
                        MessageHelper.GMessageBox("MSG00464");                    
                        return;
                    }

                    if (sMeasure == "VMI_In_Req" && bEDIT_AUTH_VMI_IN_REQ == false)
                    {
                        MessageHelper.GMessageBox("MSG00464");                    
                        return;
                    }
                                                                                                     

                    if (sAction == "M")                                                                                   
                    {
                                                                                                                      
                        SetSaveDataRemove(sAction, sDivision, sProjectCode, sEndCustomer, sScmSiteId, sItemId, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sCellProdSiteID);
                    }

                    siMain.Delete();                                                                                 
                    sAction = "D";

                    bool isWeekSumExists = false;                    
                    bool isDayValExists = false;                

                    for (int iCol = siMain.GetColumnIndex(DefColumns.Measure) + 1; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                    {
                        sQty = siMain.GetValue(iActRow, iCol).ToString().Replace(",", "");

                                    
                                                                                               
                                                                                                  
                                                                              
                        if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0)
                        {
                                             
                            if (alDelDayList.Count > 0)
                            {
                                if (!isDayValExists)                                                 
                                {
                                    foreach (int iDayCol in alDelDayList)
                                    {
                                        sYYYYMMDD = siMain.GetColumnTag(iDayCol).Replace("D_", "");
                                        iQty = 0;                    
                                        siMain.SetValue(iActRow, iDayCol, iQty);                   
                                        SetSaveData(sAction, sDivision, sProjectCode, sEndCustomer, sScmSiteId, sItemId, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sCellProdSiteID, sYYYYMMDD, sCurrency, iQty);
                                    }
                                }
                            }
                            if (sQty != "" && sQty != "0.000" && sQty != "0")
                            {
                                isWeekSumExists = true;
                            }
                            else
                            {
                                isWeekSumExists = false;
                            }

                                  
                            alDelDayList = new ArrayList();
                            isDayValExists = false;
                        }
                        else if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0)
                        {
                                         
                            if (siMain.GetColumnIndex("D_" + sResultYYYYMMDD) > iCol)
                            {
                                continue;
                            }

                            sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("D_", "");

                                              
                            if (isWeekSumExists)
                            {
                                alDelDayList.Add(iCol);

                                if (sQty != "" && sQty != "0.000" && sQty != "0")
                                {
                                    isDayValExists = true;

                                    iQty = 0;                    
                                    siMain.SetValue(iActRow, iCol, iQty);                   
                                    SetSaveData(sAction, sDivision, sProjectCode, sEndCustomer, sScmSiteId, sItemId, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sCellProdSiteID, sYYYYMMDD, sCurrency, iQty);
                                }
                            }

                                           
                            if (siMain.GetMaxColumnIndex() == iCol)
                            {
                                                    
                                if (alDelDayList.Count > 0)
                                {
                                    if (!isDayValExists)                                                 
                                    {
                                        foreach (int iDayCol in alDelDayList)
                                        {
                                            sYYYYMMDD = siMain.GetColumnTag(iDayCol).Replace("D_", "");
                                            iQty = 0;                    
                                            siMain.SetValue(iActRow, iDayCol, iQty);                   
                                            SetSaveData(sAction, sDivision, sProjectCode, sEndCustomer, sScmSiteId, sItemId, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sCellProdSiteID, sYYYYMMDD, sCurrency, iQty);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

                                                                  
                                                                                    

                                                       
                                                            
            siMain.SpreadObject.Refresh();
        }

                                                                          
                                               
            
                                        
                                         

                                    
                
                                                         

                                     
                                                         
                    
                                                                                                                           
                                                                                                                         
                                                                                                                        
                                                                                                                          
                                                                                 
                        
                        
                                                                                   
                                  
                        
                    

                             
                                                     
                                                                    
                    
                                                                                 
                              
                    

                                                                             
                                       

                                                                                                                                             
                                                                    
                                                  

                                                                                  
                                                                                    
                                                                                  
                                                                         

                                                     
                                                                                         

                                     
                                         
                                                   

                                                                             

                                          
                                            
                                                                                          

                                                              
                                                                
                                                            

                                                                                         
                    
                                                                                                                                                               
                                             

                                                                                                                                                                                
                                               

                                                                                                                              
                                   

                                       
                                                                                                                                                                                 
                                                                                                              

                                                                       
                                                                                                                                 
                                                                                                                                           
                                                                                                                                                                  
                                                                        
                        
                                                                                                                                 
                            
                                                         

                                                                
                                  
                                                                                
                                                                                                 
                                  
                                     
                                  
                                                                    
                                                                   
                                  
                            
                        

                                                         
                                                                                                                                
                                                                                                                                           
                                                                                                                          
                                                                        
                        
                                                                                                                                    
                            
                                                        
                            
                                                                          
                                                          
                        

                                                         
                                                                                                              
                                                                                                                                                 
                                                                                                                                 
                                                                        
                        
                                                                                                                                         
                                                                                                                    
                            
                                                       
                            
                                                                                 
                                                         
                        

                    

                                                                    
                                                                                   
                    
                                                                                                             
                                                                                                              
                    

                                                                                
                                                                                                                             
                    
                                                                           
                        
                                                                            
                            
                                                                    
                                
                                                                                                                     
                                                                           
                                
                                   
                                                                       

                                                                                                                 
                                                     
                            
                               
                            
                                                                   
                                                                                
                                
                                                                                                                                      
                                                           
                                
                            
                        
                                                                                 
                        
                                                                             
                            
                                                                    
                                
                                                                                                                         
                                                                           
                                
                                   
                                                                       
                            
                               
                            
                                                                                
                                
                                                                                                                     
                                    
                                                         
                                    
                                

                                                                                
                                
                                                                                                                                      
                                                           
                                

                                                                   

                            
                        
                                                                                  
                        
                                                                            
                            
                                                                    
                                
                                                                                                                                     
                                                                           

                                                                                                                                      
                                                           

                                                                         
                                    
                                                                                                             
                                                                                             
                                                                                                              
                                                                             
                                                                                           
                                                                                                               
                                                                                                                      
                                                                                                                            
                                                              
                                                                               
                                    
                                
                                   
                                
                                                                       
                                
                            
                               
                            
                                                                                
                                
                                                                     
                                                                                     
                                                                                                                       
                                      
                                                           

                                                                               
                                                                                 
                                      
                                                                           
                                      
                                                                                                                        
                                                                                                                              
                                                               
                                                                                 
                                      
                                         
                                      
                                                                             
                                      
                                                                       
                                

                                                                                                                          
                                
                                                                       
                                

                                                                     
                                                                       
                            
                        
                    

                                                                                                             
                                
                                                      
                                                      
                                                      
                                                      

                                                                  
                    
                                                    
                                                                     
                        
                                                                                                                   
                        
                                                                     
                        
                                                                                                                   
                        
                                                                
                        
                                                                                                         
                        
                                                                       
                        
                                                                                                                       
                        
                    
                                                                                                           

                                                                           
                                                   
                                                 
                                                                              
                    
                                                                                                                                                    
                                                                                 
                                                                                                                
                                                                                                              
                                                                                                                   

                                                                              
                                                                          
                                                                                                                    

                                                                              
                        
                                                       
                        
                                                                            

                                                                                          
                        
                                                                                                                                                                                           
                        
                                                                                               
                        
                                                                               
                            
                                                                                                                      
                                                                          
                                
                                                                                    
                                                          
                                    
                                                                                                                      
                                        
                                                                                                                                                                                                           
                                        
                                                                                                      
                                        
                                                                                                                                                                                                            
                                        
                                    
                                                                                               
                                    
                                                                                                                                                                                                       
                                    
                                

                                                                               
                                
                                                          
                                    
                                                                                                                                
                                        
                                                                                                                                                                                                           
                                        
                                                                                                           
                                        
                                                                                                                                                                                                            
                                        
                                    
                                                                                               
                                    
                                                                                                                                                                                                       
                                    
                                

                                                                               
                                
                                                          
                                    
                                                                                                                                
                                        
                                                                                                                                                                                                           
                                        
                                                                                                            
                                        
                                                                                                                                                                                                            
                                        
                                    
                                                                                               
                                    
                                                                                                                                                                                                       
                                    
                                

                                                                                 
                                
                                                          
                                    
                                                                                                                                    
                                        
                                                                                                                                                                                                           
                                        
                                                                                                             
                                        
                                                                                                                                                                                                            
                                        
                                    
                                                                                               
                                    
                                                                                                                                                                                                       
                                    
                                
                            

                                                                                
                            
                                                                                                                      
                                                                          
                                
                                                                                    
                                                          
                                    
                                                                                                                      
                                        
                                                                                                                                                                                                           
                                        
                                                                                                      
                                        
                                                                                                                                                                                                            
                                        
                                    
                                                                                               
                                    
                                                                                                                                                                                                        
                                    
                                

                                                                               
                                
                                                          
                                    
                                                                                                                                
                                        
                                                                                                                                                                                                           
                                        
                                                                                                           
                                        
                                                                                                                                                                                                            
                                        
                                    
                                                                                               
                                    
                                                                                                                                                                                                       
                                    
                                

                                                                                         
                                                                               
                                
                                                          
                                    
                                                                                                                                
                                        
                                                                                                                                                                                                           
                                        
                                                                                                           
                                        
                                                                                                                                                                                                            
                                        
                                    
                                                                                               
                                    
                                                                                                                                                                                                       
                                    
                                

                                                                                         
                                                                                 
                                
                                                          
                                    
                                                                                                                                    
                                        
                                                                                                                                                                                                           
                                        
                                                                                                             
                                        
                                                                                                                                                                                                            
                                        
                                    
                                                                                               
                                    
                                                                                                                                                                                                       
                                    
                                
                            

                                                                                 
                            
                                                                                                                      
                                                                          
                                
                                                                                     

                                                          
                                    
                                                                                                                             
                                        
                                                                                                                                                                                                           
                                                                                                                     
                                        
                                                                                                             
                                        
                                                                                                                                                                                                            
                                                                                                                  
                                        
                                    
                                                                                               
                                    
                                                                                                                                                                                                       
                                                                                                                
                                    
                                

                                                                                         
                                                                               
                                
                                                          
                                    
                                                                                                                                
                                        
                                                                                                                                                                                                           
                                                                                                                    
                                        
                                                                                                           
                                        
                                                                                                                                                                                                            
                                                                                                                   
                                        
                                    
                                                                                               
                                    
                                                                                                                                                                                                       
                                                                                                                
                                    
                                

                                                                                         
                                                                               
                                
                                                          
                                    
                                                                                                                                
                                        
                                                                                                                                                                                                           
                                                                                                                    
                                        
                                                                                                           
                                        
                                                                                                                                                                                                            
                                                                                                                   
                                        
                                    
                                                                                               
                                    
                                                                                                                                                                                                       
                                                                                                                
                                    
                                

                                                                                         
                                                                                 
                                
                                                          
                                    
                                                                                                                                    
                                        
                                                                                                                                                                                                           
                                                                                                                     
                                        
                                                                                                             
                                        
                                                                                                                                                                                                            
                                                                                                                  
                                        
                                    
                                                                                               
                                    
                                                                                                                                                                                                       
                                                                                                                
                                    
                                
                            
                        
                    
                                                      
                
            

                      
                                                          
                             
                                                                           
                                                                                                    
                                                                                               
                                                   
                                                          
                                                                                 
                       
        protected override void EditButton()
        {
                                      
            if (!isCurVersion) return;

            if (this.fps != null)
            {
                siMain.SpreadObject.SuspendLayout();

                try
                {
                                       
                    if (clbDivision.ControlValues == "40")
                    {
                        if (siMain.GetColumnIndex(DefColumns.Division) < 0 || siMain.GetColumnIndex(DefColumns.Customer) < 0
                        || siMain.GetColumnIndex(DefColumns.ScmSiteId) < 0 || siMain.GetColumnIndex(DefColumns.ItemId) < 0
                        || siMain.GetColumnIndex(DefColumns.DomExp) < 0 || siMain.GetColumnIndex(DefColumns.FcstType) < 0
                        || siMain.GetColumnIndex(DefColumns.Incoterms) < 0 || siMain.GetColumnIndex(DefColumns.Measure) < 0
                        || siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID) < 0
                        )
                        {
                            MessageHelper.GMessageBox("MSG00113");                   
                            return;
                        }
                    }

                               
                                                       
                    if ((dtWeek == null) || (dtWeek.Rows.Count == 0))
                    {
                        MessageHelper.GMessageBox("MSG00259");                     
                        return;
                    }

                    siMain = GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex);

                                                        
                    int xCol1 = sv.Columns[CAppSetting.StringAction].Index;

                    if (sv.Columns[xCol1].Visible == false)
                    {
                        sv.Columns[xCol1].Visible = true;
                        siMain.SetLockFlag(sv.SheetName, false);
                        IsEditMode = true;
                    }
                    else
                    {
                        sv.Columns[xCol1].Visible = false;
                        siMain.LockColumn2(xCol1 + 1, sv.Columns.Count - 1, true);

                        siMain.SetLockFlag(sv.SheetName, true);
                        IsEditMode = false;
                    }

                    int iStartCol = siMain.GetColumnIndex(DefColumns.Measure) + 1;


                                                                              
                    if (siMain.GetMaxRowIndex() != -1 && iResultCol != -1 && iResultCol != iStartCol)
                    {
                        siMain.SetBGColor2(0, iStartCol, siMain.GetMaxRowIndex(), iResultCol, Color.Gainsboro);

                                               
                        if (siMain.GetColumnIndex(this_YYYYMM) > 0)
                        {
                            siMain.SetBGColor2(0, siMain.GetColumnIndex(this_YYYYMM), siMain.GetMaxRowIndex(), siMain.GetColumnIndex(this_YYYYMM), Color.White);
                        }
                    }

                    SetLockRange(0, siMain.GetMaxRowIndex(), !IsEditMode);

                }
                finally
                {
                    siMain.SpreadObject.ResumeLayout(true);

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

                if (sDivision == "")
                {
                    MessageHelper.GMessageBox("MSG00097");

                    return;
                }

                               
                if (txtVersion.Text.Trim() == "")
                {
                    MessageHelper.GMessageBox("MSG00283");                       
                    return;
                }

                                      
                isCurVersion = false;

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

                InitSpread();

                                 
                SearchStartTime();

                string p_version_type = txtVersion.Text;

                asyncProxy.ShowProgress = false;

                var ds = await asyncProxy.ExecuteAsync<DataSet>(() =>
                {
                    using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
                    {
                        var request = new FoxDataRequest("DM.DMF0082_GET_MAIN_DATA");

                        request.CommandTimeout = 30 * 60;

                        request.Parameters["p_division_id"] = sDivision;
                        request.Parameters["p_team_id"] = clbTeam.ControlValues;
                        request.Parameters["p_customer"] = clbCustomer.ControlValues;
                        request.Parameters["p_biz_type"] = clbBizType.ControlValues;
                        request.Parameters["p_from_yyyymmdd"] = sPeriod[0];
                        request.Parameters["p_to_yyyymmdd"] = sPeriod[1];
                        request.Parameters["p_scm_site_id"] = clbSalesSite.ControlValues;
                        request.Parameters["p_item_id"] = txtItemId.Text;
                        request.Parameters["p_version_type"] = p_version_type;
                        request.Parameters["p_qty_yn"] = (cboQty.Checked == true) ? "Y" : "N";
                        request.Parameters["p_created_by"] = base.UserInfo.UserId;
                        request.Parameters["p_user_group"] = UserInfoContext.Current["NowGroupID"].ToString();

                        var response = client.ExecuteDataSet(request);

                        return response.DataSet;
                                                 
                    }
                });

                if (ds.Tables.Count >= 2)
                    dtWeek = ds.Tables[1];

                                                                                          
                if (ds.Tables.Count >= 5)
                    dtCalendarDetail = ds.Tables[4];

                                              
                SearchEndTime();

                                                                                          
                dsMain = ds;
                Draw();
                                                                                        
                                   

                SetEditList();                                           

                dtCustomsHandbook = GetCustomsHandbook();                                           
                dtWarrType = GetFcstType();                                          

                UIEndTime();

                CanModelChange = true;

                                                                                                                                                
                sDefaultDay = Data.Common(Data.Type.DefaultBucketDay, false, sDivision, cboBucketType.ControlValues).Rows[0][0].ToString();

                                  
                if (txtVersion.Text.Trim() == "Current")
                {
                    isCurVersion = true;
                }
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
            {
                this_YYYYMMWW = "W_" + DateTime.Today.ToString("yyyyMM") + ds.Tables[1].Rows[0]["ISO_WEEK"].ToString();
                this_YYYYMM = "M_" + this_YYYYMMWW.Substring(2, 6);
            }

            if (ds.Tables[0] != null)
            {
                siMain.SpreadObject.SuspendLayout();

                siMain.Query(ds.Tables[0].DataSet);
                siMain.SmartColMerge();
                siMain.LockColumn(0, siMain.GetMaxColumnIndex(), true);

                siMain.SpreadObject.ResumeLayout();
            }

            if (ds.Tables[2].Rows.Count > 0)
            {
                this_YYYYMMWW = ds.Tables[2].Rows[0]["THIS_YYYYMMWW"].ToString();
                iso_week = ds.Tables[2].Rows[0]["ISO_WEEK"].ToString();
            }

            if (siMain.GetMaxRowIndex() > 0)
            {
                                              
                                          
                siMain.SpreadObject.SuspendLayout();
                SetSearchCount(ds);
                siMain.SpreadObject.ResumeLayout();
            }

            siMain.SpreadObject.SuspendLayout();

            Boolean flag = false;
            if (iso_week == "")
                flag = true;

            try
            {
                                                                          

                                                                  
                                                                                                    
                                                                                              

                                                                                                                  
                                                                                                                              
                                                                                                           

                                                                                                                
                                                                                                                        

                int colidx = ds.Tables[0].Columns["SORT_ORDER_NO"].Ordinal;
                string column_data_start = ds.Tables[0].Columns[colidx + 1].ColumnName;
                int a_col_pos = siMain.GetColumnIndex("SORT_ORDER_NO");
                int b_col_pos = siMain.GetColumnIndex(column_data_start);

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
                string Val = string.Empty;
                string sMeasure = string.Empty;

                CustomCell gc = new CustomCell();
                gc.NegativeRed = true;
                                                     
                gc.FormatString = "###,###,###,##0.000";
                gc.NullDisplay = "";
                gc.OmitZero = false;
                int iStartCol = siMain.GetColumnIndex(DefColumns.Measure) + 1;

                for (int i = 0; i < maxRow; i++)
                {
                    rNotation[i] = ds.Tables[0].Rows[i]["NOTATION"].String().ToUpper();
                    sMeasure = ds.Tables[0].Rows[i]["MEASURE"].String().ToUpper();

                    if (sMeasure == "LOC" || rNotation[i] == "POINT3")                                                                        
                    {
                        continue;
                    }

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
                            siMain.SpreadObject.SuspendLayout();                                                                                                                  
                            gc.FormatString = "###,###,###,###";
                            siMain.ActiveSheet.Cells[i, iStartCol, i, siMain.GetMaxColumnIndex()].CellType = gc;                                 
                            siMain.SpreadObject.ResumeLayout();                                                                                                                  
                            break;
                        case 3:
                            siMain.SpreadObject.SuspendLayout();                                                                                                                  
                            gc.FormatString = "###,###,###,##0.000";
                            siMain.ActiveSheet.Cells[i, iStartCol, i, siMain.GetMaxColumnIndex()].CellType = gc;                                 
                            siMain.SpreadObject.ResumeLayout();                                                                                                                  
                            break;
                                                
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

                                                                                                                                       
                iResultCol = iStartCol;

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

                if ((siMain.GetMaxRowIndex() != -1) && (iResultCol > iStartCol))
                {
                    siMain.SetBGColor(0, iStartCol, siMain.GetMaxRowIndex(), iResultCol, Color.Gainsboro);

                                                       
                                                                                                        
                    if (siMain.GetColumnTag(iResultMonth) == sResultYYYYMMDD.Substring(0, 6))
                    {
                        siMain.SetBGColor(0, iResultMonth, siMain.GetMaxRowIndex(), iResultMonth, Color.White);
                    }
                }

                                   
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

            SetSpreadColumn();
            siMain.SpreadObject.ResumeLayout();
        }
                                                                                

        private async void SaveData()
        {
            if (siMain != null && siMain.IsLock(siMain.SheetName) == false)
            {
                if (siMain.SheetName == SpdSheet.shtMain)
                {
                    string sProcedureName = "DM.DMF0082_SAVE_MAIN_DATA";

                    string sActionFlag = string.Empty;
                    string sDivision = string.Empty;
                    string sProjectCode = string.Empty;
                    string sEndCustomer = string.Empty;
                    string sSiteId = string.Empty;
                    string sItemId = string.Empty;
                    string sDomExp = string.Empty;
                    string sFcstType = string.Empty;
                    string sIncoterms = string.Empty;
                    string sMeasure = string.Empty;
                    string sPlantSiteId = string.Empty;
                    string sCellProdSiteID = string.Empty;
                    string sYYYYMMDD = string.Empty;
                    string sCurrency = string.Empty;
                    string sQty = string.Empty;
                    string sUserId = string.Empty;

                    int iCount = 0;

                    bool bInputCheck = fnValidation(out bInputCheck);

                                            
                    if (bInputCheck2)
                    {
                        MessageHelper.GMessageBox("MSG00002", new object[] { "Currency" });                          
                        return;
                    }

                                            
                    if (!bInputCheck)
                    {
                        MessageHelper.GMessageBox("MSG00043");
                        return;
                    }

                    if (!bInputCheck)
                    {
                        MessageHelper.GMessageBox("MSG00449");                                                                        
                                                                                                                                      
                        return;
                    }

                                                          
                    foreach (DataRow dr in dtSaveFinal.Rows)
                    {
                        string sPRICE = dr[DefColumns.Qty].ToString();

                                          
                        if (sPRICE == "")
                            sPRICE = "0";

                        if (iCount == 0)
                        {
                            sActionFlag = dr[CAppSetting.StringAction].ToString();
                            sDivision = dr[DefColumns.Division].ToString();
                            sProjectCode = dr[DefColumns.Project].ToString();
                            sEndCustomer = dr[DefColumns.Customer].ToString();
                            sSiteId = dr[DefColumns.ScmSiteId].ToString();
                            sItemId = dr[DefColumns.ItemId].ToString();
                            sDomExp = dr[DefColumns.DomExp].ToString();
                            sFcstType = dr[DefColumns.FcstType].ToString();
                            sIncoterms = dr[DefColumns.Incoterms].ToString();
                            sMeasure = dr[DefColumns.Measure].ToString();
                            sPlantSiteId = dr[DefColumns.PlantSiteId].ToString();
                            sCellProdSiteID = dr[DefColumns.CELL_PROD_SITE_ID].ToString();
                            sYYYYMMDD = dr[DefColumns.YYYYMMDD].ToString();
                            sCurrency = dr[DefColumns.CURRENCY].ToString();
                            sQty = sPRICE;                                 
                            sUserId = base.UserInfo.UserId;
                        }
                        else
                        {
                            sActionFlag = sActionFlag + "^" + dr[CAppSetting.StringAction].ToString();
                            sDivision = sDivision + "^" + dr[DefColumns.Division].ToString();
                            sProjectCode = sProjectCode + "^" + dr[DefColumns.Project].ToString();
                            sEndCustomer = sEndCustomer + "^" + dr[DefColumns.Customer].ToString();
                            sSiteId = sSiteId + "^" + dr[DefColumns.ScmSiteId].ToString();
                            sItemId = sItemId + "^" + dr[DefColumns.ItemId].ToString();
                            sDomExp = sDomExp + "^" + dr[DefColumns.DomExp].ToString();
                            sFcstType = sFcstType + "^" + dr[DefColumns.FcstType].ToString();
                            sIncoterms = sIncoterms + "^" + dr[DefColumns.Incoterms].ToString();
                            sMeasure = sMeasure + "^" + dr[DefColumns.Measure].ToString();
                            sPlantSiteId = sPlantSiteId + "^" + dr[DefColumns.PlantSiteId].ToString();
                            sCellProdSiteID = sCellProdSiteID + "^" + dr[DefColumns.CELL_PROD_SITE_ID].ToString();
                            sYYYYMMDD = sYYYYMMDD + "^" + dr[DefColumns.YYYYMMDD].ToString();
                            sCurrency = sCurrency + "^" + dr[DefColumns.CURRENCY].ToString();
                            sQty = sQty + "^" + sPRICE;                                 
                            sUserId = sUserId + "^" + base.UserInfo.UserId;
                        }
                        iCount++;
                    }

                    if (iCount > 0)
                    {
                                                                    
                                     
                        var confirmResult = MessageHelper.GMessageBox("MSG00012");              

                        if (confirmResult != DialogResult.Yes)
                        {
                            return;
                        }
                        GSCM.Windows.Forms.UI.ProgressForm prg = new GSCM.Windows.Forms.UI.ProgressForm();
                        prg.Show();
                        try
                        {
                            var asyncProxy = new FoxAsyncProxy(this);

                                                                                    
                                
                            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
                            {
                                var request = new FoxDataRequest(sProcedureName);
                                request.Parameters["p_active_flag"] = sActionFlag;
                                request.Parameters["p_division_id"] = sDivision;
                                request.Parameters["p_project_code"] = sProjectCode;
                                request.Parameters["p_end_customer"] = sEndCustomer;
                                request.Parameters["p_scm_site_id"] = sSiteId;
                                request.Parameters["p_item_id"] = sItemId;
                                request.Parameters["p_dom_exp"] = sDomExp;
                                request.Parameters["p_fcst_type"] = sFcstType;
                                request.Parameters["p_incoterms"] = sIncoterms;
                                request.Parameters["p_measure"] = sMeasure;
                                request.Parameters["p_plant_site_id"] = sPlantSiteId;
                                request.Parameters["p_cell_prod_site_id"] = sCellProdSiteID;
                                request.Parameters["p_yyyymmdd"] = sYYYYMMDD;
                                request.Parameters["p_currency"] = sCurrency;
                                request.Parameters["p_qty"] = sQty;
                                request.Parameters["p_created_by"] = sUserId;

                                request.CommandTimeout = 10 * 60;

                                var response = client.ExecuteDataSet(request);

                                if (response.DataSet.Tables.Count > 0)
                                {
                                    if (response.DataSet.Tables[0].Columns.Contains("RESULT_CODE")
                                       && response.DataSet.Tables[0].Rows[0]["RESULT_CODE"].ToString() == "S")
                                    {        
                                        MessageHelper.GMessageBox("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0]["RESULT_CNT"].ToString() });
                                        int iTopRow = siMain.SpreadObject.GetViewportTopRow(0);
                                        FindData();
                                        siMain.SpreadObject.SetViewportTopRow(0, iTopRow);
                                        base.IsChange = false;
                                    }
                                    else
                                    {        
                                        if (response.DataSet.Tables[0].Columns.Contains("RESULT_CODE")
                                            && response.DataSet.Tables[0].Rows[0]["RESULT_CODE"].ToString() == "F")
                                        {
                                                                                                       
                                            if (response.DataSet.Tables[0].Columns.Contains("ERR_MESSAGE"))
                                            {
                                                MessageBox.Show(response.DataSet.Tables[0].Rows[0]["ERR_MESSAGE"].ToString());
                                            }

                                                                                        
                                            if (response.DataSet.Tables[0].Columns.Contains("RESULT_MSG"))
                                            {
                                                MessageBox.Show(response.DataSet.Tables[0].Rows[0]["RESULT_MSG"].ToString());
                                            }

                                            IsEditMode = true;                                  
                                        }
                                    }
                                }
                            };
                        }
                        catch (Exception ex)
                        {
                            MessageHelper.GMessageBoxForException(ex);
                        }
                        finally
                        {
                            prg.Close();
                            dtSaveFinal.Clear();
                        }
                    }
                    else
                    {
                        MessageHelper.GMessageBox("MSG00449");                                                                        
                    }
                }
            }
        }

        bool bInputCheck2 = false;
        private bool fnValidation(out bool bInputCheck)
        {
            dtSaveFinal.Clear();
            bInputCheck2 = false;
            bool bValidation = true;
            int iValidation = 0;
            string sProjectCode = string.Empty;
            string sEndCustomer = string.Empty;
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
            string sCurrency = string.Empty;
            string sMeasureGroup = string.Empty;
            string sAction = string.Empty;
            bool bCurrency = true;
            for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
            {
                if (siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI)
                {
                    iCnt = 0;

                    string sDivision = string.Empty;
                    string sDomExp = "", sFcstType = "", sIncoterms = "", sMeasure = "", sCellProdSiteID = "";
                                                                                                                                             
                    if (clbDivision.ControlValues == "40")
                    {
                        sDivision = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.Customer) > 0)
                            sEndCustomer = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Customer)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.ScmSiteId) > 0)
                            sSiteId = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.ItemId) > 0)
                            sItemId = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ItemId)).ToString();
                    }
                    if (siMain.GetColumnIndex(CAppSetting.StringAction) > -1)
                        sAction = siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction));
                    if (siMain.GetColumnIndex(DefColumns.DomExp) > 0)
                        sDomExp = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DomExp)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.FcstType) > 0)
                        sFcstType = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FcstType)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.Incoterms) > 0)
                        sIncoterms = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Incoterms)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.Measure) > 0)
                        sMeasure = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Measure)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID) > 0)
                        sCellProdSiteID = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.CURRENCY) > 0)
                        sCurrency = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.CURRENCY)).ToString();

                    for (int iRow2 = 0; iRow2 <= siMain.GetMaxRowIndex(); iRow2++)
                    {
                        if (clbDivision.ControlValues.Substring(0, 2) == "40")
                        {
                            if (sMeasure == "LOC")                                                         
                            {
                                if (sCurrency == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.CURRENCY)).ToString())
                                {
                                    bCurrency = true;
                                }
                                else
                                {
                                    bCurrency = false;
                                }
                            }
                            else                                         
                            {
                                bCurrency = true;
                            }

                            if (sDivision == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.Division)).ToString()
                            && sEndCustomer == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.Customer)).ToString()
                            && sSiteId == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString()
                            && sItemId == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.ItemId)).ToString()
                            && sDomExp == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.DomExp)).ToString()
                            && sFcstType == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.FcstType)).ToString()
                            && sIncoterms == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.Incoterms)).ToString()
                            && sMeasure == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.Measure)).ToString()
                            && bCurrency
                            )
                            {
                                                                                                                                       
                                       
                                                       
                                                                                                                                                     
                                        
                                                         
                                        
                                    
                                       
                                                               
                                                                                                                                                     
                                        
                                                         
                                        
                                    
                                if (sCellProdSiteID == siMain.GetValue(iRow2, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID)).ToString())
                                {
                                    iValidation++;
                                }
                            }

                            if (sMeasure == "LOC" && sCurrency == "")
                            {
                                bInputCheck2 = true;
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
                                                                        
                for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
                {
                    if (siMain.GetValue(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)).ToString() == "")
                        continue;

                    string filterExpression = $"{DefColumns.Division} = '{siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Division)).ToString()}' " +
                       $"AND {DefColumns.Customer} = '{siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Customer)).ToString()}' " +
                       $"AND {DefColumns.ScmSiteId} = '{siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString()}' " +
                       $"AND {DefColumns.ItemId} = '{siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ItemId)).ToString()}' " +
                       $"AND {DefColumns.DomExp} = '{siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DomExp)).ToString()}' " +
                       $"AND {DefColumns.FcstType} = '{siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FcstType)).ToString()}' " +
                       $"AND {DefColumns.Incoterms} = '{siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Incoterms)).ToString()}' " +
                       $"AND {DefColumns.Measure} = '{siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Measure)).ToString()}' " +
                       $"AND {DefColumns.CELL_PROD_SITE_ID} = '{siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID)).ToString()}' ";

                    DataRow[] filteredRows = dtSave.Select(filterExpression);

                    if (filteredRows.Count() > 0)
                    {
                        foreach (DataRow dr in filteredRows)
                        {
                            dtSaveFinal.ImportRow(dr);
                        }
                    }
                }


                        
                dtSaveFinal = dtSaveFinal.DefaultView.ToTable(true);
                dtSaveFinal.AcceptChanges();

                   
                                                                                      
                                                                 
                                                    
                  
                                            
                                                       
 
                                                                
                                                                             
                      
                                                                        
                                                                           
                                                                       
                                                                    
                      
 
                                                                       
                                                                           
                                                                             
                                                                         
 
                                                        
 
                                                                                          
                                                                 
 
                                                                                
                      
                                                                                                                     
                                      
 
                                                                               
                          
                                                                                                                          
                                                                                                                            
                                                                                                                        
                                                                                                                     
                                                                                                                     
                                                                                                                         
                                                                                                                           
                                                                                                                       
                                                                                                                                        
                              
                              
                                                                                                                                                
                                              
 
                                                  
                                                
 
                                                                      
                                                                                                               
                                                                                                          
                                                                                                         
                                                                                                          
                                                                                                           
                                                                                                        
                                                                                                        
                                                                                                          
                                                                                                           
                                                                                                         
                                                                                                             
                                                                                                                   
                                                                                                          
                                                                                                          
                                                                                                     
 
                                                             
                                                             
                              
                          
                      
                  
                        
                                                                     
                                              
            }
            return bValidation;
        }

        private void InsertRow()
        {
            if (siMain != null && siMain.IsLock(siMain.SheetName) == false)
            {
                if (siMain.SheetName == SpdSheet.shtMain)
                {
                                                    

                    siMain.SpreadObject.SuspendLayout();

                                                                                                                     
                    FarPoint.Win.Spread.Model.CellRange range = spdMain.Sheets[0].GetSelection(0);
                    bool bFocusYN = false;
                    int iFocusRow = 0;
                    if (range != null && range.Row > -1)
                    {
                        bFocusYN = true;
                        if (range.Row < siMain.ActiveRowIndex)
                        {
                            iFocusRow = range.Row;                                                  
                        }
                        else
                        {
                            iFocusRow = range.Row + 1;                             
                        }
                    }
                                                                                                                    

                    FarPoint.Win.Spread.Cell insCell = this.Insert();                                                                              
                                                                                                  

                    #region 칼럼 세팅
                    int iActRow = siMain.ActiveRowIndex;
                    int iRowCount = iActRow;                            

                                                                                 
                    dtincotermsEditType = GetLookupValues("INCOTERMS", "ALL", "Y", "", "", "");
                    if (siMain.GetColumnIndex(DefColumns.Incoterms) != -1)
                    {
                        if (!siMain.SpreadObject.IsLayoutSuspended) siMain.SpreadObject.SuspendLayout();
                        siMain.SetCellTypeCombo(iActRow, siMain.GetColumnIndex(DefColumns.Incoterms), dtincotermsEditType);
                    }
                                                                               

                    if ((clbDivision.ControlValues.Substring(0, 2) == "40"))
                    {
                        if (siMain.GetColumnIndex(DefColumns.ItemId) != -1)
                        {
                            if (!siMain.SpreadObject.IsLayoutSuspended) siMain.SpreadObject.SuspendLayout();
                            siMain.ActiveSheet.Cells[iActRow, siMain.GetColumnIndex(DefColumns.ItemId)].CellType = cellTypeImage;
                        }
                        if (siMain.GetColumnIndex(DefColumns.Division) != -1)
                        {
                            if (!siMain.SpreadObject.IsLayoutSuspended) siMain.SpreadObject.SuspendLayout();
                            siMain.SetValue(iActRow, siMain.GetColumnIndex(DefColumns.Division), clbDivision.ControlValues);
                        }

                                                                           
                                                                                                                                                         
                        if (!siMain.SpreadObject.IsLayoutSuspended) siMain.SpreadObject.SuspendLayout();
                        siMain.SetCellTypeCombo(iActRow, siMain.GetColumnIndex(DefColumns.DomExp), dtCustomsHandbook);
                    }

                    string sTeam = "ALL";
                    string sDivision = clbDivision.ControlValues;
                    string sEndCustomer = string.Empty;
                    string sScmSiteID = string.Empty;
                    string sItemID = string.Empty;

                    if (siMain.GetColumnIndex(DefColumns.Team) != -1)
                        sTeam = siMain.GetValue(iActRow, siMain.GetColumnIndex(DefColumns.Team)).ToString();

                                                                                        
                    DataTable dtTeamAuth, dtEndCustomerAuth, dtSalesSiteAuth = null;
                                                                                                                                                                   

                                                                                                    
                                                                                                                                        

                    if (!siMain.SpreadObject.IsLayoutSuspended) siMain.SpreadObject.SuspendLayout();
                    siMain.SetCellTypeCombo(iActRow, siMain.GetColumnIndex(DefColumns.FcstType), dtWarrType);

                    DataTable dtIncotermsType = null;

                                                                                             
                    if (sDivision == "40")
                    {
                        dtEndCustomerAuth = Data.Common(Data.Type.EndCustomerByDivision40, false, "", sTeam, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
                        dtSalesSiteAuth = Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);

                        if (siMain.GetColumnIndex(DefColumns.Division) != -1)
                            sDivision = siMain.GetValue(iActRow, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.Customer) != -1)
                            sEndCustomer = siMain.GetValue(iActRow, siMain.GetColumnIndex(DefColumns.Customer)).ToString();
                                                                            
                                                                                                                    
                        if (siMain.GetColumnIndex(DefColumns.Customer) != -1)
                        {
                            if (!siMain.SpreadObject.IsLayoutSuspended) siMain.SpreadObject.SuspendLayout();
                            siMain.SetCellTypeCombo(iActRow, siMain.GetColumnIndex(DefColumns.Customer), dtEndCustomerAuth);
                        }
                        if (siMain.GetColumnIndex(DefColumns.ScmSiteId) != -1)
                        {
                            if (!siMain.SpreadObject.IsLayoutSuspended) siMain.SpreadObject.SuspendLayout();
                            siMain.SetCellTypeCombo(iActRow, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSiteAuth);
                        }
                        if (siMain.GetColumnIndex(DefColumns.ScmSiteId) != -1)
                        {
                            if (!siMain.SpreadObject.IsLayoutSuspended) siMain.SpreadObject.SuspendLayout();
                            sScmSiteID = siMain.GetValue(iActRow, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                        }
                        if (siMain.GetColumnIndex(DefColumns.ItemId) != -1)
                        {
                            if (!siMain.SpreadObject.IsLayoutSuspended) siMain.SpreadObject.SuspendLayout();
                            sItemID = siMain.GetValue(iActRow, siMain.GetColumnIndex(DefColumns.ItemId)).ToString();
                        }

                                                                                                                                    


                                                                                     
                                                            
                                                                                     
                                                                                                                          
                        dtincotermsEditType = GetLookupValues("INCOTERMS", "ALL", "Y", "", "", "");
                        siMain.SetCellTypeCombo(iActRow, siMain.GetColumnIndex(DefColumns.Incoterms), dtincotermsEditType);
                                                                                   
                                                                                                                                  

                        dtMeasure = GetLookupValues("FCST_PRICE_EDIT_MEASURE", "DMF0082", sDivision, sScmSiteID, cboBucketType.ControlValues, "");
                        siMain.SetCellTypeCombo(iActRow, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure);

                                                                                                                                     
                        dtCellProdSiteID = Data.Common(Data.Type.CELL_PROD_SITE_ID, false, sDivision, sItemID, "", "", "");
                        siMain.SetCellTypeCombo(iActRow, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID), dtCellProdSiteID);

                                                                                                                               
                        dtCurrency = Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
                        siMain.SetCellTypeCombo(iActRow, siMain.GetColumnIndex(DefColumns.CURRENCY), dtCurrency);
                                                                                                                                  
                    }

                                                                                                                            
                                                                                                                                
                    if (bFocusYN)
                    {
                        if (!siMain.SpreadObject.IsLayoutSuspended) siMain.SpreadObject.SuspendLayout();
                                                               
                        siMain.SetValue(iActRow, siMain.GetColumnIndex(DefColumns.Division), siMain.GetValue(iFocusRow, siMain.GetColumnIndex(DefColumns.Division)).ToString());

                        if (!siMain.SpreadObject.IsLayoutSuspended) siMain.SpreadObject.SuspendLayout();
                        siMain.SetValue(iActRow, siMain.GetColumnIndex(DefColumns.Customer), siMain.GetValue(iFocusRow, siMain.GetColumnIndex(DefColumns.Customer)).ToString());

                        if (!siMain.SpreadObject.IsLayoutSuspended) siMain.SpreadObject.SuspendLayout();
                        siMain.SetValue(iActRow, siMain.GetColumnIndex(DefColumns.ScmSiteId), siMain.GetValue(iFocusRow, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString());

                        if (!siMain.SpreadObject.IsLayoutSuspended) siMain.SpreadObject.SuspendLayout();
                        siMain.SetValue(iActRow, siMain.GetColumnIndex(DefColumns.ItemId), siMain.GetValue(iFocusRow, siMain.GetColumnIndex(DefColumns.ItemId)).ToString());

                        if (!siMain.SpreadObject.IsLayoutSuspended) siMain.SpreadObject.SuspendLayout();
                        siMain.SetValue(iActRow, siMain.GetColumnIndex(DefColumns.Incoterms), siMain.GetValue(iFocusRow, siMain.GetColumnIndex(DefColumns.Incoterms)).ToString());

                        if (!siMain.SpreadObject.IsLayoutSuspended) siMain.SpreadObject.SuspendLayout();
                        siMain.SetValue(iActRow, siMain.GetColumnIndex(DefColumns.FcstType), siMain.GetValue(iFocusRow, siMain.GetColumnIndex(DefColumns.FcstType)).ToString());

                        if (!siMain.SpreadObject.IsLayoutSuspended) siMain.SpreadObject.SuspendLayout();
                        siMain.SetValue(iActRow, siMain.GetColumnIndex(DefColumns.DomExp), siMain.GetValue(iFocusRow, siMain.GetColumnIndex(DefColumns.DomExp)).ToString());

                        if (!siMain.SpreadObject.IsLayoutSuspended) siMain.SpreadObject.SuspendLayout();
                        siMain.SetValue(iActRow, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID), siMain.GetValue(iFocusRow, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID)).ToString());

                        if (!siMain.SpreadObject.IsLayoutSuspended) siMain.SpreadObject.SuspendLayout();
                        siMain.SetValue(iActRow, siMain.GetColumnIndex(DefColumns.CURRENCY), siMain.GetValue(iFocusRow, siMain.GetColumnIndex(DefColumns.CURRENCY)).ToString());

                        if (!siMain.SpreadObject.IsLayoutSuspended) siMain.SpreadObject.SuspendLayout();
                        siMain.SetValue(iActRow, siMain.GetColumnIndex(DefColumns.Measure), siMain.GetValue(iFocusRow, siMain.GetColumnIndex(DefColumns.Measure)).ToString());
                                                              
                    }
                    else
                    {
                                                               
                        if (!siMain.SpreadObject.IsLayoutSuspended) siMain.SpreadObject.SuspendLayout();
                        siMain.SetValue(iActRow, siMain.GetColumnIndex(DefColumns.Measure), "MKT_FCST");
                                                              
                    }
                                                                                                                          

                    DateTime dateTime = DateTime.Today.AddDays(Convert.ToInt32(DayOfWeek.Monday) - Convert.ToInt32(DateTime.Today.DayOfWeek));
                    string sResultYYYYMMDD = dateTime.ToString("yyyyMMdd");
                    int iStartCol = siMain.GetColumnIndex(DefColumns.Measure) + 1;
                    int iResultCol = iStartCol;
                    int iResultMonth = iStartCol;
                                                        

                                       
                    FarPoint.Win.BevelBorder bevelbrdr = new FarPoint.Win.BevelBorder(FarPoint.Win.BevelBorderType.Raised, Color.Green, Color.Green, 3, true, false, false, false);

                    if (!siMain.SpreadObject.IsLayoutSuspended) siMain.SpreadObject.SuspendLayout();

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

                        if (cboBucketType.ControlValues == BucketType.Daily)
                            if (siMain.GetColumnIndex("D_" + sResultYYYYMMDD) > 0)
                                siMain.ActiveSheet.Columns[siMain.GetColumnIndex("D_" + sResultYYYYMMDD)].Border = bevelbrdr;
                    }

                    #endregion

                    #region Measure 까지 칼럼 존재 확인 후 잠금

                                                                                                       
                                  
                                                                                               
                                         
                    string sEditColList = $"{DefColumns.Customer},{DefColumns.ScmSiteId},{DefColumns.ItemId},{DefColumns.Incoterms},{DefColumns.FcstType},{DefColumns.DomExp}" +
                                          $",{DefColumns.CELL_PROD_SITE_ID},{DefColumns.CURRENCY},{DefColumns.MEASURE}";
                    string[] arrEditColList = sEditColList.Split(',');

                    foreach (string sColName in arrEditColList)
                    {
                        if (!siMain.SpreadObject.IsLayoutSuspended) siMain.SpreadObject.SuspendLayout();
                        siMain.LockRange2(iActRow, siMain.GetColumnIndex(sColName), iRowCount, siMain.GetColumnIndex(sColName), false, ControlColor.MarkedForeColor, ControlColor.UnLockColor);
                    }

                                                                      
                                                                          
                                                                                                                                                            
                                                                       
                                                                                                                                                          
                                                                              
                                                                                                                                                                        
                                                                           
                                                                                                                                                                  
                                                                        
                                                                                                                                                            
                                                                           
                                                                                                                                                                  
                                                                             
                                                                                                                                                                      
                                                                            
                                                                                                                                                                    
                                                                        
                                                                                                                                                            
                                                                        
                                                                                                                                                            
                                                                        
                                                                                                                                                            
                                                                          
                                                                                                                                                                
                                                                              
                                                                                                                                                                        
                                                                     
                                                                                                                                                      
                                                                           
                                                                                                                                                                  
                                                                     
                                                                                                                                                      
                                                                                
                                                                                                                                                                            
                                                                            
                                                                                                                                                                    
                                                                                      
                                                                                                                                                                                        
                                                                        
                                                                                                                                                            
                                                                                        
                                                                                                                                                                                            
                                                                                             
                                                                                                                                                                                                      
                                                                                  
                                                                                                                                                                                
                                                                      
                                                                                                                                                        
                                                                         
                                                                                                                                                              
                                                                            
                                                                                                                                                                    
 
                                                                            
                                                                                                                                                                    
 
                                                                                
                                                                                                                                                                            
                                                                               
                                                                                                                                                                          
                                                                           
                                                                                                                                                                  
                                                                           
                                                                                                                                                                  
 
                                                                                             
                                                                                           
                                                                                   
                                                                                                                                                                                  
                                                                                           
 
                                                                                                                
                                                                                                              
                                                                               
                                                                                                                                                                          
                                                                                                              
 
                                                                    
                                                                                                                                                    
 
                                                                          
                                                                                                                                                                
 
                                                                                 
                                                                                                                                                                              
 
                                                                                      
                                                                                                                                                                                        
 
                                                                                    
                                                                                                                                                                                    
 
                                                                                                                         
                                                                                                                                                                        
                      
                    #endregion Measure 까지 칼럼 존재 확인 후 잠금

                    #region Measure 이후 칼럼 잠금

                                                                                                                   
                    SetLockRange(iActRow, iActRow, false);

                                    
                                      
                                                                                                   
                                                                                                       
                                                                                             
                        
                                                                               
                            
                                                                                
                                                                                        

                                                                               
                                                                                                                          
                                
                                                                                        
                                

                                                                                                                                                                       
                                
                                                     
                                
                            
                                                                                     
                            
                                                                                 
                                
                                                                        
                                    
                                                                                            
                                                                                                                                   
                                        
                                                                                                
                                                               
                                        
                                    
                                       
                                    
                                                                                            
                                    
                                
                                   
                                
                                                                                    
                                    
                                                                                                                               
                                        
                                                             

                                                                                                           
                                                             
                                                                                 
                                                                                                
                                        
                                    

                                                                                    
                                    
                                                                                                                                                
                                        
                                                               
                                        
                                    

                                                                                                   
                                                                           
                                                                                        
                                
                            
                                                                                      
                            
                                                                                
                                
                                                                        
                                    
                                                                                                                                               
                                        
                                                                                                
                                        

                                                                                                                                                
                                        
                                                               
                                        

                                                         
                                                                                                                      
                                                                                                                            
                                                                                                                                  
                                        
                                                                                                           
                                                                                                    
                                        
                                                                                                                                        
                                        
                                                                  
                                            
                                                                                                     
                                            
                                        
                                    
                                       
                                    
                                                                                            
                                    
                                
                                   
                                
                                                                                    
                                    
                                                                          
                                                                                            

                                                                                                                                 
                                          
                                                               

                                                               
                                                                                   
                                                                                                      
                                          

                                                                                                                        
                                                                                                                              
                                                                                                        
                                                                                                  
                                    

                                                            
                                                                                                                              
                                    
                                                                                            
                                    

                                                                         
                                                                                            
                                
                            
                        

                                                                                       
                        
                                                                                                       
                                                                                                                      
                            
                                                                                                            
                            
                                                                                                                                                                                
                            
                                                                                                            
                            
                                                                                                                                                                               
                            
                                                                                                            
                            
                                                                                                                                                                                 
                            
                                                                                                                         
                             

                    #endregion Measure 이후 칼럼 잠금

                                                                                                           
                                                                                                                            
                                    
                        
                                                                                                                 
                                                                                                                                    
                                                                                                         
                                                                                                    
                                                                                                                                                                                                    
                                                      
                                                                                                                                   
                        
                                                                                                         
                    siMain.SpreadObject.ResumeLayout(true);
                }
            }
        }

        #endregion

        #region 6. 조회조건 관련 Event 및 함수
        private void clbDivision_SelectedIndexChanged(object sender, EventArgs e)
        {
        }

        private void clbTeam_SelectedIndexChanged(object sender, EventArgs e)
        {
            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);
            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);

                                                                        
                                                                                                                                                                                           
                                                                 

            SetChangeControl("EndCustomerByDivision", sDivision, clbTeam.ControlValues);
            clsCtrl.setListBox(dtEndCustomer, clbCustomer, true);

                                                                        
                                                                                                                                                                                                                   

            SetChangeControl("UserSiteByEndCustomer", sDivision, clbTeam.ControlValues, clbCustomer.ControlValues);

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

        private void btnExchangeRate_Click(object sender, EventArgs e)
        {
                                          
                                   
                                                
                          
            if (!siMain.IsLock(siMain.SheetName))
            {
                                                                
                MessageHelper.GMessageBox("MSG00142");
                return;
            }

                                                                                         
                                                                                                                    
                                                                                         
                                  

                               
                
                                              
                                                        

                                      
                                    
                              
                

                                                                    
            POPUP.DMF0000_ExchangeRatePopup popup = new POPUP.DMF0000_ExchangeRatePopup();
            popup.LoadData(drpPeriod.Value1.ToString("yyyyMM"), drpPeriod.Value2.ToString("yyyyMM"), clbDivision.ControlValues);

            popup.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            popup.ShowDialog();

            if (popup.blnOK)
            {
                dtFuturePrice = GetFuturePriceInfo();

                FindData();
            }
        }

        private DataTable GetFuturePriceInfo()                               
        {
            string sStartDate = drpPeriod.Value1.ToString("yyyyMM") + "01";
            string sEndDate = drpPeriod.Value2.ToString("yyyyMM") + "01";

            DataTable dt;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                                                                                       
                var request = new FoxDataRequest("DM.DMF0082_POPUP_GET_FUTUREPRICE_INFO");
                request.Parameters["p_start_yyyymmdd"] = sStartDate;
                request.Parameters["p_end_yyyymmdd"] = sEndDate;

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
                request.Parameters["PARAM5"] = "";                               
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
                request.Parameters["PARAM5"] = "";                             
                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }
            return dt;
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

                      
                                 
                       
                                
        private int getDayOfWeek(int iCol)
        {
            string strD = siMain.GetColumnTag(iCol).Replace("D_", "");
            string strD2 = strD.Substring(0, 4) + "-" + strD.Substring(4, 2) + "-" + strD.Substring(6, 2);

            return (int)Convert.ToDateTime(strD2).DayOfWeek;
        }

        private void cboBucketType_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (siMain != null)
            {

                try
                {
                                                              
                                                            
                                               
                                                                                  
                    bool isLockBf = true;
                    string sAfBucket = cboBucketType.ControlValues;
                    if (!siMain.IsLock(siMain.SheetName))
                    {
                        isLockBf = siMain.IsLock(siMain.SheetName);
                        this.cboBucketType.SelectedIndexChanged -= new System.EventHandler(this.cboBucketType_SelectedIndexChanged);

                        try
                        {
                            cboBucketType.ControlValues = sBfBucket;
                            EditButton();
                            cboBucketType.ControlValues = sAfBucket;
                        }
                        finally
                        {
                            this.cboBucketType.SelectedIndexChanged += new System.EventHandler(this.cboBucketType_SelectedIndexChanged);
                        }
                    }
                    sBfBucket = cboBucketType.ControlValues;

                    siMain.SpreadObject.SuspendLayout();

                    SetSpreadColumn();

                                       
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

                    siMain.SpreadObject.ResumeLayout(true);

                                                              
                                                               
                    if (!isLockBf)
                    {
                        EditButton();
                    }
                }
                finally
                {
                    if (siMain.SpreadObject.IsLayoutSuspended)
                    {
                        siMain.SpreadObject.ResumeLayout(true);
                    }
                }
            }
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

        private void btnItemId_Click(object sender, EventArgs e)
        {
            string sdivision = clbDivision.ControlValues;
            string sTeam = clbTeam.ControlValues;
            string sEndCustomer = clbCustomer.ControlValues;
            string sScmSite = clbSalesSite.ControlValues;
            string sProject = "";                   
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

        private void btnVersion_Click(object sender, EventArgs e)
        {
                          
            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);

            string sStartTime = drpPeriod.Value1.ToString("yyyyMMdd");
            string sEndTinme = drpPeriod.Value2.ToString("yyyyMMdd");
            SCM0002_VersionByWaterfallPopup popVersion = new SCM0002_VersionByWaterfallPopup();
                                                   
                                                                                                           
                                                                                                         
            popVersion.Form_Load(true, "MF_SP_SF", sDivision, sStartTime, sEndTinme);
            popVersion.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            popVersion.ShowDialog();

            if (popVersion.sVersions != "")
            {
                txtVersion.Text = popVersion.sVersions;
                drpPeriod.InitValue = popVersion.sPeriod;
            }
        }

        private void txtVersion_KeyDown(object sender, KeyEventArgs e)
        {
            btnVersion_Click(sender, null);
        }

        private void btnColumn_Click(object sender, EventArgs e)
        {
            DM0002_TitleSetForm_Popup frm = new DM0002_TitleSetForm_Popup("DMF0082", SpdSheet.shtMain, true, clbDivision.ControlValues);
            frm.StartPosition = FormStartPosition.CenterParent;
            frm.ShowDialog();

            if (frm.DialogResult == DialogResult.OK)
            {
                InitSpread();
            }
        }

        private void btnMeasure_Click(object sender, EventArgs e)
        {
                                                                                                                                            
            DM0002_TitleSetForm_Popup frm = new DM0002_TitleSetForm_Popup("DMF0082", SpdSheet.shtMain, false, clbDivision.ControlValues);

            frm.StartPosition = FormStartPosition.CenterParent;
            frm.ShowDialog();

            if (frm.DialogResult == DialogResult.OK)
            {
                InitSpread();
            }
        }

                      
                                                              
                       
                                          
                                     
        private void btnSavePricePeriod_Click(object sender, EventArgs e)
        {
                                          
                                   
                                                
                          
            if (!siMain.IsLock(siMain.SheetName))
            {
                                                                                 
                MessageHelper.GMessageBox("MSG00408");                       
                return;
            }

                                                                                                   
            DMF0082_SaveSalesFuturePrice_Popup popup = new DMF0082_SaveSalesFuturePrice_Popup();

                         
                                                                                                                                                                            

            popup.LoadData(clbDivision.ControlValues.ToString()
                            , drpPeriod.Value1.ToString("yyyyMMdd"), drpPeriod.Value2.ToString("yyyyMMdd")
                            , clbSalesSite.ControlValues
                            , ""                      
                            , clbCustomer.ControlValues                                                                              
                            );
            popup.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            popup.Size = new Size(1200, 600);                                                             
            popup.ShowDialog();

                                                                                 
                 
                                
                                         
                
        }
        #endregion

        #region 7. Spread Sheet Event 및 관련 함수
                                                                                               
                                                                              
            
                                                            
                                    
                                 
                                                                                              

                                                                
                

                                                                                                                        
                      
                                                                                                                   
                                                                                                                 
                                                                                                             

                                                              
                                                                        
                          
                                                                                                                         
                                                                                                                        
                          

                      
                                                                              
                                           
                      
                                                                                                                                                                                          
                          
                                                                                                                       
                                                                                                                       
                                                                                                                     

                                                                                                                                                             
                                                                                                                  
                          
                      
                
            

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

                    if (sColName.Length >= 10)
                    {
                        sYyyymmdd = sColName.Substring(2, 8);
                    }
                    else
                    {
                        return;
                    }

                    int iCol = e.Column;               

                    sAction = siMain.GetValue(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)).ToString();


                    if (siMain.GetColumnIndex(DefColumns.ScmSiteId) >= 0)
                        ScmSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();

                    if (siMain.GetColumnIndex(DefColumns.Team) >= 0)
                        Team = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Team)).ToString();

                    if (siMain.GetColumnIndex(DefColumns.Customer) >= 0)
                        Customer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Customer)).ToString();

                    if (siMain.GetColumnIndex(DefColumns.Measure) >= 0)
                        sMeasure = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Measure)).ToString();

                    if (siMain.GetColumnIndex(DefColumns.Project) >= 0)
                        Project = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Project)).ToString();

                    if (siMain.GetColumnIndex(DefColumns.ItemId) > 0)
                        sItemId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ItemId)).ToString();

                                                                         
                    if (siMain.GetColumnIndex(DefColumns.DomExp) > 0)
                        sDomExp = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DomExp)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.FcstType) > 0)
                        sFcstType = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FcstType)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.Incoterms) > 0)
                        sIncoterms = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Incoterms)).ToString();


                    if (sDivision == "40" && sMeasure == "MKT_FCST"
                            && (siMain.ActiveSheet.Cells[e.Row, iCol].BackColor == Color.PaleGreen
                                || siMain.ActiveSheet.Cells[e.Row, iCol].BackColor == Color.PapayaWhip)
                        )
                    {


                                                                                                                         
                            
                                                                            
                        using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
                        {
                            var request = new FoxDataRequest("DM.DMF0003_GET_MKT_FCST_COMPARE_POPUP");

                            request.CommandTimeout = 30 * 60;

                            string[] sPeriod = drpPeriod.ControlValues.Split(':');
                            string sInvalidExec = "N";                                                                                                       

                                                  
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

                    string sDivision = "", sTeam = "", sEndCustomer = "", sScmSite = "", sProject = "", sItemId = "";
                    string sItemName = "", sItemType = "", sNickName = "";
                    sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.Team) > 0)
                        sTeam = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Team)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.Customer) > 0)
                        sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Customer)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.ScmSiteId) > 0)
                        sScmSite = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                    sProject = "";                                                                                    
                    if (siMain.GetColumnIndex(DefColumns.ItemId) > 0)
                        sItemId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ItemId)).ToString();

                                                                         
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
                                                                             
                else if (e.Column == siMain.GetColumnIndex(DefColumns.Incoterms))
                {
                    dtincotermsEditType = GetLookupValues("INCOTERMS", "ALL", "Y", "", "", "");
                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.Incoterms), dtincotermsEditType);
                }
                                                                           
            }
        }

                                                                                                             
            
                                                

                                              

                              
                
                                                                                       
                                                                        
                                                                       
                                         
                                            
                                             
                                                                  
                                              
                                               
                                              
                                               
                                                                    

                                                       
                                                          
                                                          
                                                     
                                                     
                                                       
                                                        
                                                      
                                                           
                                                          
                                                       
                                                        
                                                   
                                                             
                                                       

                                                     
                                                                       
                                                         
                                                                               
                        
                                                                                                                           
                        

                                          
                                                                   
                                                                                                                    
                                                                               
                            
                        
                                                                                                                    
                            
                                                                                                                                                               
                                                                                                                                      
                            
                               
                            
                                                                                           
                                                                                                                                      
                            

                                                    
                            
                                                                                                             
                                                                                     
                                
                                                                                             
                                                                                                         
                                    
                                                                                        
                                        
                                                                                                                          
                                                                                                                                

                                                                                                          
                                            
                                                     
                                            

                                                                                    
                                                                                                                                                       
                                                                                                                                            
                                                                                                                                                   
                                                                                      
                                            
                                                                                                                                                                               
                                                                                                             
                                                                                                              
                                                                                                                                              
                                                                                                                                                                          
                                                                                                                                                
                                                
                                                   
                                                
                                                                                                                                     
                                                                                                                                          
                                                

                                            
                                                                                                                                               
                                            
                                                                                                               
                                                                                                                                                   
                                                                                                                                                                          
                                                                                                                                            
                                                
                                                   
                                                
                                                                                                                                     
                                                                                                                                          
                                                
                                            
                                        
                                    
                                
                            
                        
                                 
                                     

                                            
                                                                                           
                                                                                                
                                                                                                
                                                                                                                                      
                            
                        
                                                                                                                        

                                                                               
                                                                                                             
                                                                               
                                                                                                                
                                                                                
                                                                                                                           
                                                                             
                                                                                                       
                                                                             
                                                                                                                     
                                                                               
                                                                                                                         
                                                                                
                                                                                                                           
                                                                              
                                                                                                                       
                                                                                   
                                                                                                                                 
                                                                                  
                                                                                                                               
                                                                                        
                                                                                                                                        
                                                                               
                                                                                                                         

                                               
                            
                                                                 
                                      
                            
                                                                                                       
                            
                                                                                              
                                
                                                                      
                                          
                                
                            
                                                                                                        
                            
                                                                                                       
                                                     
                                
                                                                      
                                          
                                
                            
                                                                                                         
                            
                                                                   
                                      
                            
                                                                                               
                            
                                                             
                                      
                            
                                                                            
                                                                                                 
                            
                                                                                               
                                      
                            
                                                                                                     
                            
                                                               
                                      
                            
                                                
                            
                                                               
                                      
                            
                                              
                            
                                                             
                                      
                            
                                                     
                            
                                                                       
                                      
                            
                                                                    
                            
                                                              
                                      
                            
                        
                                                                                                                                                                                                          
                        

                                                                                                                     
                                                                                                                       

                                                                   
                            
                                                                                                                                                         
                                                                                                                                    
                            

                                                                       
                                                                                    
                                                             
                            
                                                                                                                                     

                                                                                                                                           
                                                                                                                                  
                                                                                                                                                     
                            
                        
                                 

                                                                           
                        
                                                                                                                     
                        
                           
                        
                                                                                                                     
                        

                                                                
                        
                                                                                          
                                                                                                                          
                            
                                                                                                                           
                                                                                                                     

                                                                                                                            
                                                                                                                          

                            
                                                                                                                              
                            
                                                                                                                           
                                                                                                                     

                                                                                                                            
                                                                                                                          

                            
                        

                                                                       
                                                                                                                     
                        
                                                                             
                                                                                                                           
                                                                               
                                                                                                                           
                                                                            
                                                                                                                     
                                                                              
                                                                                                                         
                                                                               
                                                                                                                           
                                                                             
                                                                                                                       
                                                                                 
                                                                                                                               
                                                                              
                                                                                                                            
                                                                               
                                                                                                                           
                                                                            
                                                                                                                   
                                                                                       
                                                                                                                                        

                                                               
                                                          
                                                          
                                                            
                                                             
                                                           
                                                               

                                                                
                                                              
                                                         
                                                                   

                                                     

                                                                                      
                            
                                                                                                                            
                                
                                                                                     
                                                                                                                                   
                                                                                    
                                                                                                                             
                                                                                      
                                                                                                                                 
                                                                                       
                                                                                                                                   
                                                                                     
                                                                                                                               
                                                                                         
                                                                                                                                       
                                                                                      
                                                                                                                                     
                                                                                       
                                                                                                                                    
                                                                                    
                                                                                                                            
                                                                                               
                                                                                                                                                 

                                                                                                                                                           
                                                                         
                                    
                                                                                                                         
                                                                                                                                     
                                                    

                                                                                                                                
                                                                                                                                          
                                                    

                                                                           
                                                                          
                                                                
                                                                   
                                                                       
                                                                         
                                                                     
                                                                                     
                                        
                                                     
                                        
                                    
                                
                            

                                            
                            
                                                      
                                                                   
                                                     
                                                                     
                                      
                            
                                       
                        
                                 

                                                                 
                                                                                                                                                                                           

                                                               
                                                          
                                             
                          
                                                         
                          
                                                             

                                                                                                              
                                                                                                                             
                                                               
                                                                                       
                                                                                             
                                                                     
                        
                                               
                            
                                          
                                                               
                                         
                                          
                                                               
                                         
                                          
                                                               
                                         
                                          
                                                               
                                         
                                          
                                                               
                                         
                                          
                                                               
                                         
                                          
                                                               
                                         
                                       
                                                               
                                         
                            
                        

                                                                           

                                               
                          
                                                         
                          

                                               
                          
                                                         
                          
                                                                                                            

                                                                  
                                                  
                        
                                                                                         
                        

                                                      
                         
                                    
                                    
                                    
                                      
                            
                         
                                                                                          
                        
                                       
                                                                      
                            
                                                                                 
                                
                                                                                        
                                                        
                                         
                                
                            

                                                                                                 
                            
                                                                                                                     
                                
                                                                                                                             
                                                                                                                               
                                                                                                                                         
                                                                                               

                                                                                                                    
                                    
                                                                                                                                                                
                                                                                                                                                           
                                                                         
                                        
                                                     
                                        
                                                                         
                                    
                                

                                                                                                                                 
                                
                                                         
                                                                                                                                               
                                                 
                                                                                                                    
                                    
                                                                               
                                                                          
                                        
                                                     
                                        
                                                                                  
                                    
                                       
                                    
                                                                           
                                                                          
                                        
                                                     
                                        
                                                                                            
                                                                                  
                                    

                                         
                                
                            

                                        
                                                                      
                            
                                                                                
                                
                                                        
                                         
                                
                            

                                                                                                 
                            
                                                                                                                      
                                
                                                                                                                               
                                                                                                                                 
                                                                                                                                           
                                                                                                 

                                                                                                                    
                                    
                                                                                                                                                                
                                                                                                                                                           
                                                                          
                                        
                                                     
                                        
                                                                         
                                    
                                

                                                                                
                                
                                                         
                                                                                                                                               
                                                 
                                                                                                                    
                                    
                                                                                
                                                                          
                                        
                                                     
                                        
                                                                                  
                                    
                                       
                                    
                                                                            
                                                                          
                                        
                                                     
                                        
                                                                                  
                                    

                                         
                                
                            

                                                                         
                                          
                                            

                                                                     
                            
                                                                                                            
                                                                                                                      
                            

                                                                                                                                                                                                               
                        
                                                                   
                                                                                                  
                        
                                                    
                                                                     
                            
                                              
                            
                               
                            
                                                                                                                
                                                                                                                  
                                                                                                                            
                            

                                            
                                                                                                              
                                                                                
                               
                                                                                                    
                                  
                                                                                                    
                               
                            
                                                                                                     
                                
                                                                                                          
                                    
                                                                                                                                   
                                                                                                                                     
                                                                                                                                               
                                    

                                                                                                                                                                           
                                    
                                             
                                    
                                

                                                            
                                
                                                                        
                                                                      
                                    
                                                 
                                    
                                                                         
                                                                                                           
                                
                            

                                           
                                               
                                              
                                                 
                                                
                                                 
                                                
                                              
                                                 
                                                                                    

                                        
                                                                                                 
                            
                                                                   
                                                                               
                                                                               
                                                                 
                                                                                                         
                                
                                                                 
                                

                                                                               
                                                                  
                                
                                                                                                         
                                

                                                                                                                                                                       
                                
                                                    
                                    
                                                       

                                                                       
                                                            

                                                                                    
                                                   
                                                      
                                    

                                                                    
                                                                   

                                                                                                        
                                                                                                       

                                                         
                                                                                                                                               
                                                 
                                                                                                                    
                                    
                                                                                    
                                                                                  
                                    

                                                                              
                                    
                                                                                                                                                   
                                                     
                                                                   
                                                    
                                    

                                         
                                
                            

                                          
                                                                         

                                         
                            
                                                                                                     
                                
                                                                                   
                                                                                   
                                                                     
                                                                                                                                             
                                    
                                                

                                                             
                                        
                                                            
                                            
                                                                                
                                            
                                                                  
                                                                              
                                                                              
                                            
                                                         
                                            
                                                                             
                                                                                                   

                                                                                                                                                                                                                                    
                                                   
                                        
                                           
                                        
                                                                              
                                                                              
                                            
                                                         
                                            
                                                                             
                                                                                                   

                                                                                                                                                                                                                                    
                                        
                                    
                                                                                                                        
                                                                                                                            
                                            
                                    
                                                             
                                        
                                                            
                                            
                                                                                
                                            
                                                                   
                                                                            
                                                                                                   

                                                                                                                                                                                                                            
                                                   
                                        
                                           
                                        
                                                                            
                                                                                                   

                                                                                                                                                                                                                            
                                        
                                    

                                                                                   
                                    
                                             
                                    
                                
                            
                               
                            
                                               

                                                   
                                                                                                     
                                
                                                                                                                        
                                                                                                                       
                                    
                                                                       
                                                                                               

                                                                                                                                                                                                                        
                                    

                                                                                   
                                    
                                             
                                    
                                

                                                                                                     
                                
                                              
                                                  
                                                                                   
                                                                                                                       
                                    
                                                                                                                                                                   
                                                                                               
                                                                                                                                                       

                                                                                                                                           

                                                                     
                                        
                                                                              
                                                                              
                                            
                                                         
                                            
                                                                             

                                                                                                                                                                                                                                    
                                                 
                                        
                                    

                                                                                                    
                                                                                                                                      
                                                                          
                                                                             
                                                                                                                                                               
                                                                                                              
                                                                                                                                        
                                    
                                                                          
                                                                          
                                        
                                                     
                                        
                                                                         
                                                                                                                                                                                                                                
                                             
                                    

                                                                                   
                                    
                                                          
                                                                          
                                                                          
                                        
                                                     
                                        
                                                                            
                                                                                                  

                                                                                                                                                                                                                                
                                             
                                    
                                
                            

                                        
                                                                      
                            
                                                                                
                                
                                                        
                                         
                                
                            

                                                                                                                  
                                                                                                                    
                                                                         
                                                                                                 
                            
                                                                                                                      
                                
                                                                                                                               
                                                                                                                                 
                                                                                                                                           
                                                                                   
                                

                                                                                
                                
                                                         
                                    
                                                                    
                                        
                                                                    
                                        
                                                                                                     
                                                                                         
                                                                          
                                        
                                                     
                                        
                                                                                  
                                    
                                       
                                    
                                                                            
                                                                          
                                        
                                                     
                                        
                                                                                  
                                    
                                         
                                
                            
                        
                                                                                                 
                        
                                        
                                                    
                                                           
                                                                                                                                               

                                                                     
                            
                                               
                            
                               
                            
                                                                                                                 
                                                                                                                   
                                                                                                                             
                            
                                           
                                               
                                              
                                                 
                                                
                                                 
                                                
                                             
                                                  
                                                    
                                                      

                                                                                                                                                     
                                                                              

                                          
                                        
                                                                                                 
                            
                                        
                                                                                
                                
                                                                                                                                                     
                                    
                                                                             
                                        
                                                                                                                                             
                                                                                                                                               
                                                                                                                                                         
                                        

                                                
                                    

                                                                                           
                                                                                                                                                    

                                                                                                                                        

                                                                      
                                                           
                                      
                                                                                   
                                          
                                                         
                                          
                                      
                                         
                                      
                                                                       
                                          
                                                         
                                          
                                      
                                                                    

                                                                 
                                                                 
                                    
                                                   
                                    
                                                                 
                                
                                                                               
                                                                  
                                
                                                                                                                                                      
                                    
                                                                                                                               
                                    
                                

                                                                                                                      
                                
                                                    
                                    
                                                           
                                                     
                                                        
                                    

                                                          
                                    
                                                                                                                                        
                                        
                                                                                 
                                            
                                                                                                                         
                                                
                                                          
                                                
                                                   
                                                
                                                                                                                      
                                                                                       
                                                          
                                                
                                            
                                        
                                    

                                                                                                                                
                                                                                          
                                                                                         

                                                                                                                              
                                                                                                                             

                                                           
                                                                                                                                                 
                                                   
                                                                                                                      
                                      
                                                                                      
                                                                                    
                                      
                                                                                                                              

                                                                  
                                                         
                                    
                                                               
                                                    
                                    
                                         
                                
                            

                                      

                                          
                            
                                                                                                 
                                                                                    
                                                                                               

                                                                                                     
                                

                                                                                   
                                                                      
                                    
                                                                                                                                                         
                                        
                                                    
                                        

                                                

                                             
                                                               
                                          
                                                              
                                              
                                                                                  
                                              
                                                                                
                                                                                
                                              
                                                           
                                              
                                                                               
                                                                                                     

                                                                                                                       
                                                                                                                                                                                                                                        
                                                                                                                     

                                                                                                                  
                                                                   
                                              
                                                                                                                                                                                                                                          
                                              
                                                 
                                              
                                                                                                                                   
                                                                                                              
                                                                                                                       
                                                                                                                     

                                                                            
                                                  
                                                                                                                                                                  
                                                  
                                                     
                                                  
                                                                                                                                                                                   
                                                                                                         
                                                  

                                                                                                                                                                                                                                          
                                              
                                                                                                                
                                          
                                             
                                          
                                                                                
                                                                                
                                              
                                                           
                                              
                                                                               
                                                                                                     

                                                                                                                       
                                                                                                                                                                                                                                        
                                                                                                                     

                                                                                                                  
                                                                   
                                              
                                                                                                                                                                                                                                          
                                              
                                                 
                                              
                                                                                                                                   
                                                                                                              
                                                                                                                       
                                                                                                                     

                                                                            
                                                  
                                                                                                                                                                  
                                                  
                                                     
                                                  
                                                                                                                                                                                   
                                                                                                         
                                                  

                                                                                                                                                                                                                                          
                                              
                                                                                                                
                                          
                                             

                                                             
                                        
                                                            
                                            
                                                                                
                                            
                                                                                                   

                                                                                                                
                                                                 
                                            
                                                                                  
                                                                                  
                                                
                                                             
                                                
                                                                                 
                                                                                                                                                                                                                                        
                                            
                                               
                                            
                                                                                                                                 
                                                                                                            
                                                                                                                     
                                                                                                                   

                                                                          
                                                
                                                                                                                                                                
                                                
                                                   
                                                
                                                                                                                                                                                 
                                                                                                       
                                                
                                                                                  
                                                                                  
                                                
                                                             
                                                
                                                                                 
                                                                                                                                                                                                                                        
                                            
                                                                                                              
                                        
                                           
                                        
                                                                                                   

                                                                                                                
                                                                 
                                            
                                                                                  
                                                                                  
                                                
                                                             
                                                
                                                                                 
                                                                                                                                                                                                                                        
                                            
                                               
                                            
                                                                                                                                 
                                                                                                              
                                                                                                            
                                                                                                                     
                                                                                                                   

                                                                                                                               
                                                
                                                                              
                                                    
                                                                                                                                                                    
                                                    
                                                       
                                                    
                                                                                                                                                                                     
                                                                                                           
                                                    
                                                                                      
                                                                                      
                                                    
                                                                 
                                                    
                                                                                     
                                                                                                                                                                                                                                            
                                                
                                            
                                                                                                              
                                        
                                    
                                                                                        
                                                                       
                                    
                                                                                                                                                         
                                        
                                                    
                                        

                                                             
                                        
                                                            
                                            
                                                                                
                                            
                                                                           
                                                                                                   

                                                                                                                                                                                                                            
                                                   
                                        
                                           
                                        
                                                                           
                                                                                                   

                                                                                                                                                                                                                            
                                        
                                    

                                          
                                                                            
                                                                                
                                                                                                                                                                  
                                                                                                                
                                                                                                                                           
                                      
                                                                            
                                                                            
                                          
                                                       
                                          
                                                                           
                                                                                                 

                                                                                                                                                                                                                                  
                                      
                                          

                                                                          
                                                                              
                                                                                                                                                                
                                                                                                              
                                                                                                                                         
                                    
                                                                                               

                                                                                                            
                                                             
                                        
                                                                              
                                                                              
                                            
                                                         
                                            
                                                                             
                                                                                                                                                                                                                                    
                                        
                                           
                                        
                                                                                                                             
                                                                                                          
                                                                                                        
                                                                                                                 
                                                                                                               

                                                                                                                          
                                            
                                                                          
                                                
                                                                                                                                                                
                                                
                                                   
                                                
                                                                                                                                                                                 
                                                                                                       
                                                

                                                                                  
                                                                                  
                                                
                                                             
                                                
                                                                                 
                                                                                                                                                                                                                                        
                                            
                                        
                                                                                                          
                                    

                                                                                                                          
                                    
                                             
                                    
                                
                            
                               
                            
                                                 

                                                   
                                                                                                     
                                
                                                                                    
                                    
                                                                                                                                                         
                                        
                                                    
                                        
                                                                             
                                        
                                                                           
                                                                                                   

                                                                                                                                                                                                                            
                                        
                                    

                                                                                                                          
                                    
                                             
                                    
                                

                                          
                                                                                                     
                                
                                                  
                                                                                    
                                    
                                                                                                                                                         
                                        
                                                    
                                        
                                                                                                                                                                   
                                                                                               
                                                                                                                                                        

                                                                                                                                            

                                                                     
                                        
                                                    
                                                                 
                                            
                                                                                
                                                                                  
                                                                                  
                                                
                                                             
                                                
                                                                                 
                                                                                                                                                                                                                                        
                                            
                                               
                                            
                                                                                  
                                                                                  
                                                
                                                             
                                                

                                                                                                           
                                                                                                     
                                                                           
                                                                      
                                                                                
                                                                                       
                                                                                                                                                                         
                                                  
                                                                                                                                                               

                                                                                                                          
                                                                                                                                                                                                                                              
                                                  
                                                     
                                                  
                                                                                       
                                                                                                                                                                                                                                              
                                                  
                                                                                                         

                                                                                 
                                                                                                                                                                                                                                        
                                            
                                        
                                    

                                                                                                                          
                                    
                                             
                                    
                                
                            

                                       
                                          
                                                        
                                                                                                 
                            
                                                                                                                     
                                
                                                                                                                             
                                                                                                                               
                                                                                                                                         
                                

                                                                                                                       
                                
                                                                                        
                                                                      
                                    
                                                 
                                    
                                                                         
                                                   
                                                  
                                
                            
                        
                                                                                                       
                                                                                                                                         
                        
                                                                 
                            
                                           
                                                                          
                                
                                                                                     
                                    
                                                                                            
                                                            
                                             
                                    
                                

                                                                                                     
                                
                                                                                                                         
                                    
                                                                                                                                 
                                                                                                                                   
                                                                                                                                             
                                    

                                                                                                                                     
                                    
                                                                                                                                                                                          
                                                                                                                                 
                                                                                            
                                                                           
                                                                          
                                        
                                                     
                                        
                                                                                  
                                                                                                                                 
                                             
                                    
                                

                                            
                                                                          
                                
                                                                                    
                                    
                                                            
                                             
                                    
                                

                                                                                 
                                                                                   
                                                                                                     
                                
                                                                                                                          
                                    
                                                                                                                                   
                                                                                                                                     
                                                                                                                                               

                                                                                                                                                              
                                                                                                                                      
                                                                      
                                                                                                                         
                                                                                                                           
                                                                                                                                       
                                                                                                              
                                                                                                                                             
                                                          
                                            
                                                          
                                            
                                                                                 
                                        
                                    

                                                                                                                              
                                    
                                                                                                                                                                                          
                                                                                                                                 

                                                                  
                                                             
                                        
                                                                                
                                                                              
                                            
                                                         
                                            
                                                                                      
                                        
                                           
                                        
                                                                                
                                                                              
                                            
                                                         
                                            
                                                                                      
                                        

                                                                                                                                 
                                             
                                    
                                

                                                                                                                            
                                                                             
                                              
                                                

                                                                         
                                
                                                                                                              
                                                                                                                
                                                                                                                          
                                

                                                                                           
                                                                                     
                                                                                
                                                         
                                                                 
                                                                        
                                                                                                                                                          
                                  
                                                                   
                                                                        
                                      
                                                   
                                      
                                                                                                                                               
                                                                                                          
                                  
                                                                                         

                                                                                                                                                                                                                   
                            
                        
                                                                                                                                           
                        
                                                                                                                                                         
                                                                                                       
                            
                                                                                                                                 
                                
                                                                                                                                

                                                                         
                                    
                                                        
                                                                                          
                                                                                                                            
                                                                                           
                                                                                                                                       
                                                                                        
                                                                                                                   
                                    

                                                                                    
                                                                                                                             
                                                                                      
                                                                                                                                 
                                                                                       
                                                                                                                                   
                                                                                     
                                                                                                                               
                                                                                          
                                                                                                                                       
                                                                                                
                                                                                                                                                

                                                                                             
                                                                   

                                                                                                         
                                    
                                                                                                                                                                                         
                                        
                                                                                 
                                            
                                                                               
                                                                    
                                                
                                                                                       
                                                                                                                        
                                                                                      
                                                
                                                   
                                                
                                                                                       
                                                                                                               
                                                                                      
                                                
                                            
                                        
                                    
                                                                                                                                                                                                 
                                
                            
                        
                             
                
                                             
            

        protected void spdMain_Changed(object sender, FarPoint.Win.Spread.Model.SheetDataModelEventArgs e)
        {
            if (!this.CanModelChange) return;

            if (e.Column <= 1)
                return;

                                            
                                                                                                             
            FarPoint.Win.Spread.Model.DefaultSheetDataModel dsdm = (FarPoint.Win.Spread.Model.DefaultSheetDataModel)siMain.Sheet(SpdSheet.shtMain).Models.Data;
            dsdm.Changed -= new FarPoint.Win.Spread.Model.SheetDataModelEventHandler(spdMain_Changed);

            try
            {
                switch (e.Type)
                {
                    case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated:
                        string sBucketType = cboBucketType.ControlValues;
                        string sColName = siMain.GetColumnTag(e.Column);
                        int iStartCol = 0;
                                              
                                               
                                                                    
                        decimal iWeeklySum = 0;
                        decimal iMonthlySum = 0;
                        int iWeeklySum_NUM = 0;
                        int iMonthlySum_NUM = 0;
                        decimal iWkSum_Sync = 0;                      

                        string sDivision = string.Empty;
                        string sProjectCode = string.Empty;
                        string sEndCustomer = string.Empty;
                        string sItemId = string.Empty;
                        string sDomExp = string.Empty;
                        string sFcstType = string.Empty;
                        string sIncoterms = string.Empty;
                        string sMeasure = string.Empty;
                        string sMeasureGroup = string.Empty;
                        string sPlantSiteId = string.Empty;
                        string sCustomer = string.Empty;
                        string sScmSiteId = string.Empty;
                        string sItem = string.Empty;
                        string sCellProdSiteID = string.Empty;
                        string sCurrency = string.Empty;

                        string sAction = siMain.GetValue(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)).ToString();

                                                                                    
                        if (siMain.GetColumnIndex(DefColumns.Division) >= 0)
                            sDivision = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.Division)).ToString(); ;
                        if (siMain.GetColumnIndex(DefColumns.Project) > 0)
                            sProjectCode = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Project)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.Customer) >= 0)
                            sEndCustomer = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.Customer)).ToString(); ;
                        if (siMain.GetColumnIndex(DefColumns.ScmSiteId) >= 0)
                            sScmSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.ItemId) >= 0)
                            sItem = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.ItemId)).ToString(); ;
                        if (siMain.GetColumnIndex(DefColumns.DomExp) >= 0)
                            sDomExp = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DomExp)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.FcstType) >= 0)
                            sFcstType = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FcstType)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.Incoterms) >= 0)
                            sIncoterms = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Incoterms)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.Measure) >= 0)
                            sMeasure = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Measure)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.MeasureGroup) >= 0)
                            sMeasureGroup = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.MeasureGroup)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.PlantSiteId) >= 0)
                            sPlantSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PlantSiteId)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID) >= 0)
                            sCellProdSiteID = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.CURRENCY) >= 0)
                            sCurrency = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.CURRENCY)).ToString();


                                                                         
                        string sAsFromSite = string.Empty;
                        if (siMain.GetColumnIndex(DefColumns.AS_FROM_SITE) >= 0)
                        {
                            sAsFromSite = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE)).ToString();
                        }

                        #region CELL 변경 이벤트
                                                                     
                        if (siMain.GetValue(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)).ToString() == "I")
                        {
                            if (sColName == "CURRENCY" || sColName == "MEASURE")
                            {
                                if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString() == "LOC")
                                {
                                    dtCurrency = Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);

                                                                       
                                                                                      
                                                                                                                                              
                                    siMain.SpreadObject.SuspendLayout();
                                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.CURRENCY), dtCurrency);
                                    siMain.SpreadObject.ResumeLayout();
                                }
                                else
                                {
                                    dtCurrency = GetLookupValues("NO_DATA", "", "", "", "", "");
                                                                       
                                                                                      
                                                                                                                                              
                                    siMain.SpreadObject.SuspendLayout();
                                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.CURRENCY), dtCurrency);
                                    siMain.SpreadObject.ResumeLayout();
                                }

                                if (sColName == "MEASURE")
                                {
                                    iStartCol = siMain.GetColumnIndex(DefColumns.Measure) + 1;

                                                                                                                   

                                                                                     
                                    siMain.SpreadObject.SuspendLayout();
                                                                                     
                                    siMain.LockRange2(e.Row, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, e.Row, siMain.GetMaxColumnIndex(), true, true);
                                    SetLockRange(e.Row, e.Row, false);
                                    siMain.SpreadObject.ResumeLayout();

                                                                                             
                                        
                                                                                                                 
                                            
                                                                                                
                                                
                                                                                                                                  
                                                                                                                                        

                                                                                                                  
                                                    
                                                             
                                                    

                                                                                            
                                                                                                                                                               
                                                                                                                                                    
                                                                                                                                                             
                                                                                                                                           

                                                                                              
                                                    
                                                                                                                                                                                       
                                                                                                                     
                                                                                                                        
                                                                                                                                                        
                                                                                                                                                                                    
                                                                                                                                                          
                                                          
                                                             
                                                          
                                                                                                                                               
                                                                                                                                                    
                                                          

                                                                                         
                                                                                                        
                                                                                                                                           
                                                                                                                                                               
                                                                                                                                                             
                                                        
                                                                                                            
                                                                                                                    
                                                        
                                                           
                                                        
                                                                                                             
                                                                                                                                 
                                                        
                                                                                                           
                                                                                                                               
                                                    
                                                                                                                                                       
                                                    
                                                                                                                       
                                                                                                                                                           

                                                                                             
                                                                                                            
                                                                                                                                                                                    
                                                                                                                                                      
                                                                                                                                                  
                                                                                                                    
                                                        
                                                           
                                                        
                                                                                             
                                                                                                            
                                                                                                                                               
                                                                                                                                                                   
                                                                                                             
                                                                                                                                 
                                                        
                                                    
                                                
                                            
                                        
                                                                                   

                                                                       
                                                                                                                                          
                                                                          
                                    sMeasure = siMain.GetValue(e.Row, e.Column).ToString();

                                    siMain.SpreadObject.SuspendLayout();

                                    if (sMeasure == "LOC")           
                                    {
                                        siMain.SetRowFormat(e.Row, iStartCol, -1, "###,###,###,##0.000");
                                    }
                                    else      
                                    {
                                        siMain.SetRowFormat(e.Row, iStartCol, -1, "###,###,###,###");
                                    }

                                    siMain.SpreadObject.ResumeLayout();

                                }
                            }

                                                                                                         
                            #region Validation 확인
                            if ((sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0)
                                || (sBucketType == BucketType.Weekly && sColName.IndexOf("W_") != -1)
                                || (sBucketType == BucketType.Monthly && sColName.IndexOf("M_") == 0)
                                || ((sBucketType == BucketType.Weekly || sBucketType == BucketType.Monthly) && sColName.IndexOf("D_") == 0)
                                )
                            {
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
                                if ((siMain.GetColumnIndex(DefColumns.Customer) > 0) && (sEndCustomer == ""))
                                {
                                                                                                             
                                    if (sDivision == "40")
                                    {
                                        ValidationCheck(e, "End Customer");
                                        return;
                                    }
                                }
                                if (((siMain.GetColumnIndex(DefColumns.ScmSiteId) > 0)) && (sScmSiteId == ""))
                                {
                                    ValidationCheck(e, "Sales Site ID");
                                    return;
                                }
                                if ((siMain.GetColumnIndex(DefColumns.ItemId) > 0) && (sItem == ""))
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
                                if (sCellProdSiteID == "")
                                {
                                    ValidationCheck(e, "Cell Prod Site ID");
                                    return;
                                }
                                if (sMeasure == "LOC" && sCurrency == "")
                                {
                                    ValidationCheck(e, "Currency");
                                    return;
                                }
                            }
                            else if (sColName == DefColumns.Division || sColName == DefColumns.ScmSiteId || sColName == DefColumns.Division || sColName == DefColumns.Project || sColName == DefColumns.ItemId || sColName == DefColumns.Incoterms)                                                                                                           
                            {
                                                                                             
                                                                                                                             
                                                                                                                               

                                if (sDivision != "" && sScmSiteId != "")
                                {
                                    dtMeasure = GetLookupValues("FCST_PRICE_EDIT_MEASURE", "DMF0082", sDivision, sScmSiteId, cboBucketType.ControlValues, "");

                                    siMain.SpreadObject.SuspendLayout();
                                    siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure);
                                    siMain.SpreadObject.ResumeLayout();
                                }

                                                                             
                                                                                          
                                if (sColName == DefColumns.ItemId)
                                {
                                    sItemId = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemId)).ToString();

                                                                                                                                                 
                                    dtCellProdSiteID = Data.Common(Data.Type.CELL_PROD_SITE_ID, false, sDivision, sItemId, "", "", "");

                                    siMain.SpreadObject.SuspendLayout();
                                    siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID), dtCellProdSiteID);
                                    siMain.SpreadObject.ResumeLayout();
                                }
                                                                                                                                                   
                                else if (sColName == DefColumns.ScmSiteId || sColName == DefColumns.Incoterms)
                                {
                                    dtSalesBucket = GetLookupValues("SALES_BUCKET", sDivision, sScmSiteId, sIncoterms, "", "");
                                    if (dtSalesBucket.Rows.Count > 0)
                                    {
                                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.BUCKET), dtSalesBucket.Rows[0]["BUCKET"].ToString());
                                    }
                                    else
                                    {
                                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.BUCKET), "");
                                    }
                                }
                                                                                                                                                 
                            }
                            #endregion

                            #region 여러행 신규 입력 로우를 생성했을 경우 신규 로우 중에서 중복되지 않게.
                                                                                                             
                            if (e.Column <= siMain.GetColumnIndex(DefColumns.MEASURE))
                            {
                                string sProjectCode2 = string.Empty;
                                string sItemId2 = string.Empty;
                                string sDomExp2 = string.Empty;
                                string sFcstType2 = string.Empty;
                                string sIncoterms2 = string.Empty;
                                string sMeasure2 = string.Empty;
                                string sPlantSiteId2 = string.Empty;

                                string sEndCustomer_2 = string.Empty;
                                string sScmSiteId_2 = string.Empty;
                                string sItem_2 = string.Empty;
                                string sCellProdSiteID_2 = string.Empty;

                                int iDouble = 0;           

                                for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
                                {
                                    if (siMain.GetValue(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)).ToString() == "I")
                                    {
                                        if (siMain.GetColumnIndex(DefColumns.Project) > 0)
                                            sProjectCode2 = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Project)).ToString();
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
                                        if (siMain.GetColumnIndex(DefColumns.Customer) > 0)
                                            sEndCustomer_2 = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Customer)).ToString();
                                        if (siMain.GetColumnIndex(DefColumns.ScmSiteId) > 0)
                                            sScmSiteId_2 = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                                        if (siMain.GetColumnIndex(DefColumns.ItemId) > 0)
                                            sItem_2 = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ItemId)).ToString();
                                        if (siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID) > 0)
                                            sCellProdSiteID_2 = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID)).ToString();

                                                                                                                                                                 
                                        if (clbDivision.ControlValues == "40")
                                        {
                                            if ((sEndCustomer == "") || (sScmSiteId == "") || (sItem == "") || (sDomExp == "")
                                                || (sFcstType == "") || (sIncoterms == "") || (sMeasure == "") || (sCellProdSiteID == ""))
                                                continue;

                                            if ((sEndCustomer_2 == "") || (sScmSiteId_2 == "") || (sItem_2 == "") || (sDomExp2 == "")
                                                || (sFcstType2 == "") || (sIncoterms2 == "") || (sMeasure2 == "") || (sCellProdSiteID_2 == ""))
                                                continue;

                                            if ((sEndCustomer == sEndCustomer_2)
                                                && (sScmSiteId == sScmSiteId_2)
                                                && (sItem == sItem_2)
                                                && (sDomExp == sDomExp2)
                                                && (sFcstType == sFcstType2)
                                                && (sIncoterms == sIncoterms2)
                                                && (sMeasure == sMeasure2)
                                                && (sCellProdSiteID == sCellProdSiteID_2))
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
                        }
                        #endregion

                        iStartCol = 0;

                        if (siMain.GetColumnIndex(DefColumns.Division) >= 0)
                        {
                            sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                        }
                        else
                        {
                            sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                        }

                                                                           
                                                                    
                            
                                                                                              
                                                                                                                              
                                
                                                                                                                               
                                                                                                                         

                                                                                                                                
                                                                                                                              

                                
                                                                                                                                  
                                
                                                                                                                               
                                                                                                                         

                                                                                                                                
                                                                                                                              

                                
                            


                        var dBucket = new Dictionary<int, bool>();
                        string strBucket = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.BUCKET));

                                                                                                          
                                                            
                                               
                            
                                                     
                            

                                                   
                        if (sMeasure == "LOC")
                        {
                            strBucket = "0100000";
                        }

                                                                                                                           
                                                                      
                                                      
                            
                                                                                             
                            


                                                                            
                                                          
                        if (strBucket == "" || strBucket == "0000000")
                        {
                            dBucket.Clear();

                            switch (sDefaultDay)
                            {
                                case "MON":
                                    strBucket = "0100000";       
                                    break;
                                case "TUE":
                                    strBucket = "0010000";       
                                    break;
                                case "WED":
                                    strBucket = "0001000";       
                                    break;
                                case "THU":
                                    strBucket = "0000100";       
                                    break;
                                case "FRI":
                                    strBucket = "0000010";       
                                    break;
                                case "SAT":
                                    strBucket = "0000001";       
                                    break;
                                case "SUN":
                                    strBucket = "1000000";       
                                    break;
                                default:
                                    strBucket = "0100000";       
                                    break;
                            }
                        }
                        for (int i = 0; i < 7; i++)
                        {
                            dBucket.Add(i, (strBucket.ToCharArray())[i].ToString() == "1" ? true : false);
                        }
                                                                                                                         


                                                        
                           
                                      
                                      
                                      
                                        
                              
                          

                        if (sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0)
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
                                                                                                                               
                                                                                                                                 
                                    iWeeklySum = iWeeklySum + Convert.ToDecimal(siMain.GetValue(e.Row, iCol).ToString().Replace(",", ""));
                                    iWeeklySum_NUM = Convert.ToInt32(Math.Truncate(iWeeklySum));

                                    if (sMeasure == "MKT_FCST" || sMeasure == "VMI_In_Req" || sMeasure == "SCM_FCST")
                                    {
                                                                                                                                                                  
                                        string data = Math.Truncate(Convert.ToDecimal(siMain.GetValue(e.Row, iCol).ToString().Replace(",", ""))).ToString();
                                        if (data == "0" || data == "0.000")
                                        {
                                            data = "";
                                        }
                                        siMain.SetText(e.Row, iCol, data);
                                    }
                                }

                                if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 || siMain.GetColumnTag(iCol).IndexOf("W_") != -1)
                                {
                                                           
                                                                                                                                                 
                                                   
                                    if (sMeasure == "MKT_FCST" || sMeasure == "VMI_In_Req" || sMeasure == "SCM_FCST")
                                    {
                                        string data = iWeeklySum_NUM.ToString();
                                        if (data == "0" || data == "0.000")
                                        {
                                            data = "";
                                        }
                                        siMain.SetText(e.Row, iStartCol - 1, data);
                                    }
                                    else
                                    {
                                        string data = iWeeklySum.ToString();
                                        if (data == "0" || data == "0.000")
                                        {
                                            data = "";
                                        }
                                                                                              
                                        siMain.SetText(e.Row, iStartCol - 1, data);
                                    }

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
                                                                                                                                 
                                                                                                                                   
                                    iMonthlySum = iMonthlySum + Convert.ToDecimal(siMain.GetValue(e.Row, iCol).ToString().Replace(",", ""));
                                    iMonthlySum_NUM = Convert.ToInt32(Math.Truncate(iMonthlySum));

                                    if (sMeasure == "MKT_FCST" || sMeasure == "VMI_In_Req" || sMeasure == "SCM_FCST")
                                    {
                                                                                                                                                                  
                                        string data = Math.Truncate(Convert.ToDecimal(siMain.GetValue(e.Row, iCol).ToString().Replace(",", ""))).ToString();
                                        if (data == "0" || data == "0.000")
                                        {
                                            data = "";
                                        }
                                        siMain.SetText(e.Row, iCol, data);
                                    }
                                }

                                if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                                {
                                                           
                                                                                                                                                 
                                                   
                                    if (sMeasure == "MKT_FCST" || sMeasure == "VMI_In_Req" || sMeasure == "SCM_FCST")
                                    {
                                        string data = iMonthlySum_NUM.ToString();
                                        if (data == "0" || data == "0.000")
                                        {
                                            data = "";
                                        }
                                        siMain.SetText(e.Row, iStartCol - 1, data);
                                    }
                                    else
                                    {
                                        string data = iMonthlySum.ToString();
                                        if (data == "0" || data == "0.000")
                                        {
                                            data = "";
                                        }
                                        siMain.SetText(e.Row, iStartCol - 1, data);
                                    }

                                    break;
                                }
                            }

                            string sYYYYMMDD = sColName.Replace("D_", "");
                                            
                            decimal iQty = 0;

                            if (siMain.GetText(e.Row, e.Column) != "")
                            {
                                                                                                              
                                iQty = Convert.ToDecimal(siMain.GetValue(e.Row, e.Column).ToString().Replace(",", ""));
                            }

                            SetSaveData(sAction, sDivision, sProjectCode, sEndCustomer, sScmSiteId, sItem, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sCellProdSiteID, sYYYYMMDD, sCurrency, iQty);
                        }
                                                                     
                        #region [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 붙여넣기 속도개선2 - 이전 로직 일괄 주석
                                                                                                      
                            
                                                        
                                                                         
                                
                                                  
                                
                                   
                                
                                                                                                                    
                                                                                                                      
                                                                                                                                
                                

                                                
                                                                                                                  
                                                                                    
                                   
                                                                                                        
                                      
                                                                                                        
                                   
                                
                                                                                                         
                                    
                                                                                                              
                                        
                                                                                                                                       
                                                                                                                                         
                                                                                                                                                   
                                        

                                                                                                                                                                               
                                        
                                                 
                                        
                                    

                                                                
                                    
                                                                            
                                                                          
                                        
                                                     
                                        
                                                                             
                                                                                                               
                                    
                                

                                               
                                                   
                                                  
                                                     
                                                    
                                                     
                                                    
                                                  
                                                     
                                                                                          

                                            
                                                                                                     
                                
                                                                         
                                                                                     
                                                                                     
                                                                       
                                                                                                               
                                      
                                                                       
                                      

                                                                                   
                                                                      
                                    
                                                                                                             
                                    

                                                                                                                                                                           
                                    
                                                        
                                        
                                                           

                                                                           
                                                                

                                                                                        
                                                       
                                                          
                                        

                                                                        
                                                                       

                                                                                                            
                                                                                                           

                                                             
                                                                                                                                                   
                                                     
                                                                                                                        
                                        
                                                                                        
                                                                                      
                                        

                                                                                  
                                        
                                                                                                                                                       
                                                         
                                                                       
                                                        
                                        

                                             
                                    
                                

                                              
                                                                             

                                             
                                
                                                                                                         
                                    
                                                                                       
                                                                                       
                                                                         
                                                                                                                                                 
                                        
                                                    

                                                                 
                                            
                                                                
                                                
                                                                                    
                                                
                                                                      
                                                                                  
                                                                                  
                                                
                                                             
                                                
                                                                                 
                                                                                                       

                                                                                                                                                                                                                                        
                                                       
                                            
                                               
                                            
                                                                                  
                                                                                  
                                                
                                                             
                                                
                                                                                 
                                                                                                       

                                                                                                                                                                                                                                        
                                            
                                        
                                                                                                                            
                                                                                                                                
                                                
                                        
                                                                 
                                            
                                                                
                                                
                                                                                    
                                                
                                                                       
                                                                                
                                                                                                       

                                                                                                                                                                                                                                
                                                       
                                            
                                               
                                            
                                                                                
                                                                                                       

                                                                                                                                                                                                                                
                                            
                                        

                                                                                       
                                        
                                                 
                                        
                                    
                                
                                   
                                
                                                   

                                                       
                                                                                                         
                                    
                                                                                                                            
                                                                                                                           
                                        
                                                                           
                                                                                                   

                                                                                                                                                                                                                            
                                        

                                                                                       
                                        
                                                 
                                        
                                    

                                                                                                         
                                    
                                                  
                                                      
                                                                                       
                                                                                                                           
                                        
                                                                                                                                                                       
                                                                                                   
                                                                                                                                                           

                                                                                                                                               

                                                                         
                                            
                                                                                  
                                                                                  
                                                
                                                             
                                                
                                                                                 

                                                                                                                                                                                                                                        
                                                     
                                            
                                        

                                                                                                        
                                                                                                                                          
                                                                              
                                                                                 
                                                                                                                                                                  
                                                                                                                  
                                                                                                                                              
                                        
                                                                              
                                                                              
                                            
                                                         
                                            
                                                                             
                                                                                                                                                                                                                                    
                                                 
                                        

                                                                                       
                                        
                                                              
                                                                              
                                                                              
                                            
                                                         
                                            
                                                                                
                                                                                                      

                                                                                                                                                                                                                                    
                                                 
                                        
                                    
                                

                                            
                                                                          
                                
                                                                                    
                                    
                                                            
                                             
                                    
                                

                                                                                                                      
                                                                                                                        
                                                                             
                                                                                                     
                                
                                                                                                                          
                                    
                                                                                                                                   
                                                                                                                                     
                                                                                                                                               
                                                                                       
                                    

                                                                                    
                                    
                                                             
                                        
                                                                         
                                            
                                                                        
                                            
                                                                                                         
                                                                                             
                                                                              
                                            
                                                         
                                            
                                                                                      
                                        
                                           
                                        
                                                                                
                                                                              
                                            
                                                         
                                            
                                                                                      
                                        
                                             
                                    
                                
                            
                        #endregion [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 붙여넣기 속도개선2 - 이전 로직 일괄 주석

                        #region [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 붙여넣기 속도개선2 - Weekly 변경 로직 속도개선
                        else if ((sBucketType == BucketType.Weekly) && sColName.IndexOf("W_") == 0)
                        {
                            iStartCol = e.Column + 1;
                            string sYYYYMMDD = string.Empty;

                            if (siMain.GetText(e.Row, e.Column) == "")
                            {
                                iWeeklySum = 0;
                            }
                            else
                            {
                                if (sMeasure != "LOC")
                                {
                                    iWeeklySum = Math.Round(Convert.ToDecimal(siMain.GetValue(e.Row, e.Column).ToString().Replace(",", "")), 0);
                                }
                                else
                                {
                                    iWeeklySum = Convert.ToDecimal(siMain.GetValue(e.Row, e.Column).ToString().Replace(",", ""));
                                }
                            }

                            decimal iDailyQty = 0;

                                      
                            int iWeekBucketCnt = 0;                 
                            decimal iWeeklyQty = 0;                
                            ArrayList arrTargetDayIdx = new ArrayList();                  


                            for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                            {
                                if (sMeasure != "LOC")
                                {
                                                                       
                                    if (siMain.GetColumnTag(iCol).Substring(0, 1) != "D")
                                    {
                                                           
                                        if (arrTargetDayIdx.Count > 0)
                                        {
                                            iWeekBucketCnt = arrTargetDayIdx.Count;

                                            int iLoopCnt = 0;
                                            foreach (int idx in arrTargetDayIdx)
                                            {
                                                iLoopCnt++;
                                                sYYYYMMDD = siMain.GetColumnTag(idx).Replace("D_", "");

                                                if (iLoopCnt == 1)                
                                                {
                                                    iWeeklyQty = iWeeklySum;                                          
                                                    iDailyQty = Math.Truncate(iWeeklyQty / iWeekBucketCnt);
                                                }

                                                if (iLoopCnt == iWeekBucketCnt)                
                                                {
                                                    iDailyQty = iWeeklyQty;                          
                                                }
                                                else
                                                {
                                                    iWeeklyQty -= iDailyQty;                                       
                                                }

                                                string data = iDailyQty.ToString();
                                                if (data == "0" || data == "0.000")
                                                {
                                                    data = "";
                                                }

                                                                                                                                   
                                                siMain.SetText(e.Row, idx, data);

                                                SetSaveData(sAction, sDivision, sProjectCode, sEndCustomer, sScmSiteId, sItem, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sCellProdSiteID, sYYYYMMDD, sCurrency, iDailyQty);
                                            }
                                        }
                                        else                                                    
                                        {
                                            int iLastDayOfWeek = iCol - 1;         
                                            sYYYYMMDD = siMain.GetColumnTag(iLastDayOfWeek).Replace("D_", "");

                                            iDailyQty = iWeeklySum;                                              

                                            string data = iDailyQty.ToString();
                                            if (data == "0" || data == "0.000")
                                            {
                                                data = "";
                                            }

                                            siMain.SetText(e.Row, iLastDayOfWeek, data);

                                            SetSaveData(sAction, sDivision, sProjectCode, sEndCustomer, sScmSiteId, sItem, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sCellProdSiteID, sYYYYMMDD, sCurrency, iDailyQty);
                                        }
                                    }

                                                                                  
                                    if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0)
                                    {
                                                                        
                                        siMain.SetText(e.Row, iCol, "");

                                        sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("D_", "");
                                        SetSaveData(sAction, sDivision, sProjectCode, sEndCustomer, sScmSiteId, sItem, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sCellProdSiteID, sYYYYMMDD, sCurrency, 0);

                                        if (dBucket[getDayOfWeek(iCol)])
                                        {
                                                                  
                                            arrTargetDayIdx.Add(iCol);
                                        }
                                    }
                                }

                                                                        
                                                                           
                                if (sMeasure == "LOC")
                                {
                                    if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0)
                                    {
                                        if (siMain.GetColumnTag(iCol).Substring(8, 2) == "01"
                                       || dBucket[getDayOfWeek(iCol)])                    
                                        {
                                            string data = iWeeklySum.ToString();
                                            if (data == "0" || data == "0.000")
                                            {
                                                data = "";
                                            }
                                                                                                                               
                                            siMain.SetText(e.Row, iCol, data);

                                            sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("D_", "");

                                            SetSaveData(sAction, sDivision, sProjectCode, sEndCustomer, sScmSiteId, sItem, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sCellProdSiteID, sYYYYMMDD, sCurrency, iWeeklySum);
                                        }
                                        else
                                        {
                                                                                                                               
                                            siMain.SetText(e.Row, iCol, "");

                                            sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("D_", "");
                                            SetSaveData(sAction, sDivision, sProjectCode, sEndCustomer, sScmSiteId, sItem, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sCellProdSiteID, sYYYYMMDD, sCurrency, 0);
                                        }

                                    }
                                }

                                        
                                if (siMain.GetColumnTag(iCol).Substring(0, 1) != "D") break;
                            }

                                          
                            for (int iCol = e.Column; iCol > 0; iCol--)
                            {
                                if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                                {
                                    iStartCol = iCol + 1;
                                    break;
                                }
                            }

                                                                                                                    
                            decimal iMonthlySum_WeeklyBucket = 0;                                                     
                            int iDayCnt_WeeklyBucket = 0;                  
                            for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                            {
                                if (siMain.GetColumnTag(iCol).IndexOf("W_") != -1 && siMain.GetText(e.Row, iCol) != "")
                                {
                                                                                                                                 
                                                                                                                                   
                                    iMonthlySum = iMonthlySum + Convert.ToDecimal(siMain.GetValue(e.Row, iCol).ToString().Replace(",", ""));
                                    iDayCnt_WeeklyBucket = iDayCnt_WeeklyBucket + 1;
                                }

                                if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                                {
                                    if (sMeasure == "LOC")
                                    {
                                        if (iDayCnt_WeeklyBucket == 0)
                                        {
                                            iDayCnt_WeeklyBucket = 1;
                                        }
                                        iMonthlySum_WeeklyBucket = iMonthlySum / iDayCnt_WeeklyBucket;
                                        string data = iMonthlySum_WeeklyBucket.ToString();
                                        if (data == "0" || data == "0.000")
                                        {
                                            data = "";
                                        }
                                        siMain.SetText(e.Row, iStartCol - 1, data);
                                    }
                                    else
                                    {
                                        string data = iMonthlySum.ToString();
                                        if (data == "0" || data == "0.000")
                                        {
                                            data = "";
                                        }
                                        siMain.SetText(e.Row, iStartCol - 1, data);
                                    }
                                    break;
                                }
                            }
                        }
                        #endregion [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 붙여넣기 속도개선2 - Weekly 변경 로직 속도개선

                        #region [PJ2025-50188] 고도화 - 월수량 일별로 나누기 반영 -이전 로직 일괄 주석
                                                                                                     
                            
                                            
                                                        
                                                               
                                                                                                                                                   

                                                                         
                                
                                                   
                                
                                   
                                
                                                                                                                     
                                                                                                                       
                                                                                                                                 
                                
                                               
                                                   
                                                  
                                                     
                                                    
                                                     
                                                    
                                                 
                                                      
                                                        
                                                          

                                                                                                                                                         
                                                                                  

                                              
                                            
                                                                                                     
                                
                                            
                                                                                    
                                    
                                                                                                                                                         
                                        
                                                                                 
                                            
                                                                                                                                                 
                                                                                                                                                   
                                                                                                                                                             
                                            

                                                    
                                        

                                                                                               
                                                                                                                                                        

                                                                                                                                            

                                                             
                                        
                                                                                     
                                            
                                                           
                                            
                                        
                                           
                                        
                                                                         
                                            
                                                           
                                            
                                        
                                    
                                                                                   
                                                                      
                                    
                                                                                                                                                          
                                        
                                                                                                                                   
                                        
                                    

                                                                                                                          
                                    
                                                        
                                        
                                                               
                                                         
                                                            
                                        

                                                              
                                        
                                                                                                                                             
                                            
                                                                                     
                                                
                                                                                                                             
                                                    
                                                              
                                                    
                                                       
                                                    
                                                                                                                          
                                                                                           
                                                              
                                                    
                                                
                                            
                                        

                                                                                            
                                                                                           

                                                                                                                                
                                                                                                                               

                                                             
                                                                                                                                                   
                                                     
                                                                                                                        
                                        
                                                                                        
                                                                                      
                                        

                                                                      
                                                             
                                        
                                                                   
                                                        
                                        
                                             
                                    
                                

                                          

                                              
                                
                                                                                                         
                                    

                                                                                       
                                                                          
                                        
                                                                                                                                                             
                                            
                                                        
                                            

                                                    

                                                                 
                                            
                                                                
                                                
                                                                                    
                                                
                                                                                  
                                                                                  
                                                
                                                             
                                                
                                                                                 
                                                                                                       

                                                                                                                                                                                                                                        
                                                       
                                            
                                               
                                            
                                                                                  
                                                                                  
                                                
                                                             
                                                
                                                                                 
                                                                                                       

                                                                                                                                                                                                                                        
                                            
                                        
                                                                                            
                                                                           
                                        
                                                                                                                                                             
                                            
                                                        
                                            

                                                                 
                                            
                                                                
                                                
                                                                                    
                                                
                                                                               
                                                                                                       


                                                                                                                                                                                                                                
                                                       
                                            
                                               
                                            
                                                                               
                                                                                                       


                                                                                                                                                                                                                                
                                            
                                        

                                                                              
                                                                                  
                                                                                                                                                                  
                                        
                                                                              
                                                                              
                                            
                                                         
                                            
                                                                             
                                                                                                   

                                                                                                                                                                                                                                    
                                        

                                                                                                                              
                                        
                                                 
                                        
                                    
                                
                                   
                                
                                                     

                                                       
                                                                                                         
                                    
                                                                                        
                                        
                                                                                                                                                             
                                            
                                                        
                                            
                                                                                 
                                            
                                                                               
                                                                                                       

                                                                                                                                                                                                                                
                                            
                                        

                                                                                                                              
                                        
                                                 
                                        
                                    

                                              
                                                                                                         
                                    
                                                      
                                                                                        
                                        
                                                                                                                                                             
                                            
                                                        
                                            
                                                                                                                                                                       
                                                                                                   
                                                                                                                                                            

                                                                                                                                                

                                                                         
                                            
                                                        
                                                                     
                                                
                                                                                    
                                                                                      
                                                                                      
                                                    
                                                                 
                                                    
                                                                                     
                                                                                                                                                                                                                                            
                                                
                                                   
                                                
                                                                                      
                                                                                      
                                                    
                                                                 
                                                    
                                                                                     
                                                                                                                                                                                                                                            
                                                
                                            
                                        

                                                                                                                              
                                        
                                                 
                                        
                                    
                                

                                           
                                              
                                                            
                                                                                                     
                                
                                                                                                                         
                                    
                                                                                                                                 
                                                                                                                                   
                                                                                                                                             
                                    

                                                                                                                           
                                    
                                                                                            
                                                                          
                                        
                                                     
                                        
                                                                             
                                                       
                                                      
                                    
                                

                                                                                      
                                                          
                                                                       
                                  
                                                                                                           
                                      
                                                                                                                                
                                          
                                                                                                                                         
                                                                                                                                           
                                                                                                                                                       
                                                                                                                                                       
                                          

                                                                                                                                 
                                          
                                                                                                     
                                                                                                    
                                                                                
                                              
                                                           
                                              
                                                                                   
                                                   
                                          
                                      
                                  
                            
                        #endregion

                        #region [PJ2025-50188] 고도화 - 월수량 일별로 나누기 반영 (LOC는 이전과 동일)
                                                                                
                                                                                                   
                                                                                             
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
                                                                                                                           
                                                                                                                                                
                                if (sMeasure != "LOC")
                                {
                                    iMonthlySum = Math.Round(Convert.ToDecimal(siMain.GetValue(e.Row, e.Column).ToString().Replace(",", "")), 0);
                                }
                                else
                                {
                                    iMonthlySum = Convert.ToDecimal(siMain.GetValue(e.Row, e.Column).ToString().Replace(",", ""));
                                }
                            }

                                                                                                                
                                                                                  
                                                                
                                                                             
                                
                                                   

                                                       
                                    
                                                  
                                                                       
                                                 
                                                  
                                                                       
                                                 
                                                  
                                                                       
                                                 
                                                  
                                                                       
                                                 
                                                  
                                                                       
                                                 
                                                  
                                                                       
                                                 
                                                  
                                                                       
                                                 
                                               
                                                                       
                                                 
                                    
                                                              
                                    
                                                                                                                     
                                    
                                

                            decimal iDailyQty = 0;
                            decimal iRemnant = 0;

                            DateTime dateTime = DateTime.Today.AddDays(Convert.ToInt32(DayOfWeek.Monday) - Convert.ToInt32(DateTime.Today.DayOfWeek));
                            string sResultDate = dateTime.ToString("yyyyMMdd");

                                      
                            int iWeekBucketCnt = 0;                 
                            decimal iWeeklyQty = 0;                
                            decimal iWeeklyQtySum = 0;                  
                            ArrayList arrTargetDayIdx = new ArrayList();                  
                            ArrayList arrBfTargetDayIdx = new ArrayList();                                                  

                            for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                            {
                                if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0)
                                {
                                                       
                                    if (int.Parse(sResultDate) > int.Parse(siMain.GetColumnTag(iCol).Substring(siMain.GetColumnTag(iCol).Length - 8)))
                                    {
                                        continue;
                                    }
                                }

                                                                                     
                                if (sMeasure != "LOC")
                                {
                                    if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0)
                                    {
                                                           
                                        if (arrTargetDayIdx.Count > 0)
                                        {
                                            iWeekBucketCnt = arrTargetDayIdx.Count;

                                            int iLoopCnt = 0;
                                            foreach (int idx in arrTargetDayIdx)
                                            {
                                                iLoopCnt++;
                                                sYYYYMMDD = siMain.GetColumnTag(idx).Replace("D_", "");

                                                if (iLoopCnt == 1)                
                                                {
                                                    var drFind = dtCalendarDetail.Select("BASIS_YYYYMMDD = " + "'" + sYYYYMMDD + "'");
                                                    var vMONTH_DAY_CNT = int.Parse(drFind[0]["MONTH_DAY_CNT"].ToString());
                                                    var vWEEK_DAY_CNT = int.Parse(drFind[0]["WEEK_DAY_CNT"].ToString());

                                                    iWeeklyQty = Math.Truncate(iMonthlySum / vMONTH_DAY_CNT) * vWEEK_DAY_CNT;
                                                    iDailyQty = Math.Truncate(iWeeklyQty / iWeekBucketCnt);
                                                }

                                                if (iLoopCnt == iWeekBucketCnt)                
                                                {
                                                    iDailyQty = iWeeklyQty;                          

                                                }
                                                else
                                                {
                                                    iWeeklyQty -= iDailyQty;                                       
                                                }

                                                string data = iDailyQty.ToString();
                                                if (data == "0" || data == "0.000")
                                                {
                                                    data = "";
                                                }

                                                                                                                                   
                                                siMain.SetText(e.Row, idx, data);

                                                SetSaveData(sAction, sDivision, sProjectCode, sEndCustomer, sScmSiteId, sItem, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sCellProdSiteID, sYYYYMMDD, sCurrency, iDailyQty);


                                                iWeeklyQtySum += iDailyQty;
                                                iRemnant = iMonthlySum - iWeeklyQtySum;
                                            }
                                        }

                                                                    
                                        iWeekBucketCnt = 0;
                                        iWeeklyQty = 0;
                                        iDailyQty = 0;
                                        arrBfTargetDayIdx = (ArrayList)arrTargetDayIdx.Clone();
                                        arrTargetDayIdx = new ArrayList();                  
                                    }

                                    if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0)
                                    {
                                                                        
                                                                                                                           
                                        siMain.SetText(e.Row, iCol, "");

                                        sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("D_", "");
                                        SetSaveData(sAction, sDivision, sProjectCode, sEndCustomer, sScmSiteId, sItem, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sCellProdSiteID, sYYYYMMDD, sCurrency, 0);

                                        if (dBucket[getDayOfWeek(iCol)])
                                        {
                                                                                
                                            arrTargetDayIdx.Add(iCol);
                                        }
                                    }
                                }

                                                                        
                                                                            
                                if (sMeasure == "LOC")
                                {
                                    if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0)
                                    {
                                        if (siMain.GetColumnTag(iCol).Substring(8, 2) == "01"
                                       || dBucket[getDayOfWeek(iCol)])                    
                                        {
                                            string data = iMonthlySum.ToString();
                                            if (data == "0" || data == "0.000")
                                            {
                                                data = "";
                                            }
                                                                                                                               
                                            siMain.SetText(e.Row, iCol, data);

                                            sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("D_", "");

                                            SetSaveData(sAction, sDivision, sProjectCode, sEndCustomer, sScmSiteId, sItem, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sCellProdSiteID, sYYYYMMDD, sCurrency, iMonthlySum);
                                        }
                                        else
                                        {
                                                                                                                               
                                            siMain.SetText(e.Row, iCol, "");

                                            sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("D_", "");
                                            SetSaveData(sAction, sDivision, sProjectCode, sEndCustomer, sScmSiteId, sItem, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sCellProdSiteID, sYYYYMMDD, sCurrency, 0);
                                        }

                                    }
                                }

                                if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 || iCol == siMain.GetMaxColumnIndex())
                                {
                                                                               
                                    if (sMeasure != "LOC" && iRemnant > 0)
                                    {
                                                                               
                                                                                      
                                        if (arrTargetDayIdx.Count > 0)
                                        {
                                            arrBfTargetDayIdx = (ArrayList)arrTargetDayIdx.Clone();
                                        }

                                        if (arrBfTargetDayIdx.Count > 0)
                                        {
                                            iWeekBucketCnt = arrBfTargetDayIdx.Count;

                                            int iLoopCnt = 0;
                                            foreach (int idx in arrBfTargetDayIdx)
                                            {
                                                iLoopCnt++;
                                                sYYYYMMDD = siMain.GetColumnTag(idx).Replace("D_", "");

                                                iDailyQty = Math.Truncate(iRemnant / iWeekBucketCnt);

                                                if (iLoopCnt == iWeekBucketCnt)                
                                                {
                                                    iDailyQty = iRemnant;                          

                                                }
                                                else
                                                {
                                                    iRemnant -= iDailyQty;                                       
                                                }

                                                if (siMain.GetValue(e.Row, idx).ToString().Replace(",", "") != "")                                   
                                                {
                                                    iDailyQty += Convert.ToDecimal(siMain.GetValue(e.Row, idx).ToString().Replace(",", ""));
                                                }

                                                Decimal newQty = iDailyQty;

                                                string data = newQty.ToString();
                                                if (data == "0" || data == "0.000")
                                                {
                                                    data = "";
                                                }

                                                                                                                                   
                                                siMain.SetText(e.Row, idx, data);

                                                SetSaveData(sAction, sDivision, sProjectCode, sEndCustomer, sScmSiteId, sItem, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sCellProdSiteID, sYYYYMMDD, sCurrency, newQty);
                                            }
                                        }
                                    }
                                    break;
                                }
                            }

                                         
                            iWeeklySum = 0;
                            int iWeekCol = iStartCol - 1;
                            for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                            {
                                if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 && siMain.GetText(e.Row, iCol) != "")
                                {
                                                                                                                               
                                                                                                                                 
                                    iWeeklySum = iWeeklySum + Convert.ToDecimal(siMain.GetValue(e.Row, iCol).ToString().Replace(",", ""));
                                }

                                if (siMain.GetColumnTag(iCol).IndexOf("W_") != -1 || iCol == siMain.GetMaxColumnIndex())
                                {
                                    string data = iWeeklySum.ToString().Replace(",", "");
                                    if (data == "0" || data == "0.000")
                                    {
                                        data = "";
                                    }
                                                                                                                       
                                    siMain.SetText(e.Row, iWeekCol, data);
                                    iWeekCol = iCol;
                                    iWeeklySum = 0;
                                }
                            }
                        }
                        #endregion [PJ2025-50188] 고도화 - 월수량 일별로 나누기 반영

                        #region 불필요 로직 주석 처리 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선
                                                                                                         
                                                                                                                                             
                            
                                                                     
                                
                                               
                                                                              
                                    
                                                                                         
                                        
                                                                                                
                                                                
                                                 
                                        
                                    

                                                                                                         
                                    
                                                                                                                             
                                        
                                                                                                                                     
                                                                                                                                       
                                                                                                                                                 
                                        

                                                                                                                                                                               
                                        
                                                                                                                                                                                              
                                                                                                                                     
                                                                                                
                                                                               
                                                                              
                                            
                                                         
                                            

                                                                                                                             
                                                                                      
                                                                                                                                     
                                                 
                                        
                                    

                                                
                                                                              
                                    
                                                                                        
                                        
                                                                
                                                 
                                        
                                    

                                                                                     
                                                                                       
                                                                                                         
                                    
                                                                                                                              
                                        
                                                                                                                                       
                                                                                                                                         
                                                                                                                                                   

                                                                                                                                                                  
                                                                                                                                          
                                                                          
                                                                                                                             
                                                                                                                               
                                                                                                                                           
                                                                                                                  
                                                                                                                                                 
                                                              
                                                
                                                              
                                                
                                                                                     
                                            
                                                                                                                                                 
                                              
                                                                                                          
                                                                                    
                                                  
                                                               
                                                  
                                                                                       
                                              
                                        

                                                                                                                                  
                                        
                                                                                                                                                                                              
                                                                                                                                     

                                                                      
                                                                 
                                            
                                                                                    
                                                                                  
                                                
                                                             
                                                

                                                                                                                                 
                                                                                          
                                            
                                               
                                            
                                                                                    
                                                                                  
                                                
                                                             
                                                

                                                                                                                                 
                                                                                          
                                            
                                                 
                                              
                                                                                      
                                                                                    
                                                  
                                                               
                                                  
                                                                                            
                                              

                                                                                                                                     
                                                 
                                        
                                    

                                                                                                                                
                                                                                 
                                                  
                                                    

                                                                             
                                    
                                                                                                                  
                                                                                                                    
                                                                                                                              
                                    

                                                                                                                                                                                                                       
                                
                            
                        #endregion 불필요 로직 주석 처리 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선

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
                                        if (siMain.GetColumnIndex(DefColumns.Customer) > 0)
                                            sEndCustomer = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.Customer));
                                        if (siMain.GetColumnIndex(DefColumns.ScmSiteId) > 0)
                                            sScmSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                                        if (siMain.GetColumnIndex(DefColumns.ItemId) > 0)
                                            sItem = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.ItemId));
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
                                    if (siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID) >= 0)
                                        sCellProdSiteID = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID)).ToString();

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
                                    SetSaveDataRemove(sAction, sDivision, sProjectCode, sEndCustomer, sScmSiteId, sItem, sDomExp, sFcstType, sIncoterms, sMeasure, sPlantSiteId, sCellProdSiteID);
                                }
                            }
                        }
                        break;
                }
                                               
            }
            finally
            {
                                                                                                                 
                dsdm.Changed += new FarPoint.Win.Spread.Model.SheetDataModelEventHandler(spdMain_Changed);
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

        private void SetSaveData(string sAction, string sDivision, string sProjectCode, string sEndCustomer, string sScmSiteId
                               , string sItemId, string sDomExp, string sFcstType, string sIncoterms, string sMeasure
                               , string sPlantSiteId, string sCellProdSiteID, string sYYYYMMDD, string sCurrency, decimal iQty
                               )
        {
                                                          
                                                      

                                                  
                
                                                                   
                
                   
                
                                                                   
                

            if (sDivision == "")
            {
                                                                                                     
                return;
            }

            if (sDivision == "40")
            {
                if (sEndCustomer == "")
                {
                                                                                              
                    return;
                }
                if (sScmSiteId == "")
                {
                                                                                            
                    return;
                }
                if (sItemId == "")
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
            if (sCellProdSiteID == "")
            {
                                                                                     
                return;
            }
            if (sMeasure == "LOC" && sCurrency == "")
            {
                                                                                     
                return;
            }
            string sFilter = "";

            if (sMeasure == "LOC")
            {
                sFilter = "Action" + "= '" + sAction + "'";
                sFilter += " and " + DefColumns.Division + " = '" + sDivision + "'";
                sFilter += " and " + DefColumns.Project + " = '" + sEndCustomer + "'";
                sFilter += " and " + DefColumns.Customer + " = '" + sEndCustomer + "'";
                sFilter += " and " + DefColumns.ScmSiteId + " = '" + sScmSiteId + "'";
                sFilter += " and " + DefColumns.ItemId + " = '" + sItemId + "'";
                sFilter += " and " + DefColumns.DomExp + " = '" + sDomExp + "'";
                sFilter += " and " + DefColumns.FcstType + " = '" + sFcstType + "'";
                sFilter += " and " + DefColumns.Incoterms + " = '" + sIncoterms + "'";
                sFilter += " and " + DefColumns.Measure + " = '" + sMeasure + "'";
                sFilter += " and " + DefColumns.PlantSiteId + " = '" + sPlantSiteId + "'";
                sFilter += " and " + DefColumns.CELL_PROD_SITE_ID + " = '" + sCellProdSiteID + "'";
                sFilter += " and " + DefColumns.YYYYMMDD + " = '" + sYYYYMMDD + "'";
                sFilter += " and " + DefColumns.CURRENCY + " = '" + sCurrency + "'";
            }
            else
            {
                sFilter = "Action" + "= '" + sAction + "'";
                sFilter += " and " + DefColumns.Division + " = '" + sDivision + "'";
                sFilter += " and " + DefColumns.Project + " = '" + sEndCustomer + "'";
                sFilter += " and " + DefColumns.Customer + " = '" + sEndCustomer + "'";
                sFilter += " and " + DefColumns.ScmSiteId + " = '" + sScmSiteId + "'";
                sFilter += " and " + DefColumns.ItemId + " = '" + sItemId + "'";
                sFilter += " and " + DefColumns.DomExp + " = '" + sDomExp + "'";
                sFilter += " and " + DefColumns.FcstType + " = '" + sFcstType + "'";
                sFilter += " and " + DefColumns.Incoterms + " = '" + sIncoterms + "'";
                sFilter += " and " + DefColumns.Measure + " = '" + sMeasure + "'";
                sFilter += " and " + DefColumns.PlantSiteId + " = '" + sPlantSiteId + "'";
                sFilter += " and " + DefColumns.CELL_PROD_SITE_ID + " = '" + sCellProdSiteID + "'";
                sFilter += " and " + DefColumns.YYYYMMDD + " = '" + sYYYYMMDD + "'";
            }

            DataRow[] drFind = dtSave.Select(sFilter);

            if (drFind.Length == 0)
            {
                DataRow drNew = dtSave.NewRow();
                drNew["Action"] = sAction;
                drNew[DefColumns.Division] = sDivision;
                drNew[DefColumns.Project] = sEndCustomer;
                drNew[DefColumns.Customer] = sEndCustomer;
                drNew[DefColumns.ScmSiteId] = sScmSiteId;
                drNew[DefColumns.ItemId] = sItemId;
                drNew[DefColumns.DomExp] = sDomExp;
                drNew[DefColumns.FcstType] = sFcstType;
                drNew[DefColumns.Incoterms] = sIncoterms;
                drNew[DefColumns.Measure] = sMeasure;
                drNew[DefColumns.PlantSiteId] = sPlantSiteId;
                drNew[DefColumns.CELL_PROD_SITE_ID] = sCellProdSiteID;
                drNew[DefColumns.YYYYMMDD] = sYYYYMMDD;
                drNew[DefColumns.CURRENCY] = sCurrency;
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

        private void SetSaveDataRemove(string sAction, string sDivision, string sProjectCode, string sEndCustomer, string sScmSiteId
                                     , string sItemId, string sDomExp, string sFcstType, string sIncoterms, string sMeasure
                                     , string sPlantSiteId, string sCellProdSiteID)
        {
            if (sDivision == "")
            {
                                                                                                     
                return;
            }

            if (sDivision == "40")
            {
                if (sEndCustomer == "")
                {
                                                                                              
                    return;
                }
                if (sScmSiteId == "")
                {
                                                                                            
                    return;
                }
                if (sItemId == "")
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
            if (sCellProdSiteID == "")
            {
                                                                                     
                return;
            }

            string sFilter = "Action" + "= '" + sAction + "'";
            sFilter += " and " + DefColumns.Division + " = '" + sDivision + "'";
            sFilter += " and " + DefColumns.Project + " = '" + sEndCustomer + "'";
            sFilter += " and " + DefColumns.Customer + " = '" + sEndCustomer + "'";
            sFilter += " and " + DefColumns.ScmSiteId + " = '" + sScmSiteId + "'";
            sFilter += " and " + DefColumns.ItemId + " = '" + sItemId + "'";
            sFilter += " and " + DefColumns.DomExp + " = '" + sDomExp + "'";
            sFilter += " and " + DefColumns.FcstType + " = '" + sFcstType + "'";
            sFilter += " and " + DefColumns.Incoterms + " = '" + sIncoterms + "'";
            sFilter += " and " + DefColumns.Measure + " = '" + sMeasure + "'";
            sFilter += " and " + DefColumns.PlantSiteId + " = '" + sPlantSiteId + "'";
            sFilter += " and " + DefColumns.CELL_PROD_SITE_ID + " = '" + sCellProdSiteID + "'";

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

        private void spdMain_ClipboardPasted(object sender, ClipboardPastedEventArgs e)
        {
                                                            
                                                                                                 
                          

                     
                                                                       
                                                                                                              
                                                                                        
                                                                    

                                                                                                                 
                          
                                            
            int iStartRow = e.CellRange.Row;                                                                           
            int iAddRow = range.RowCount - 1;                                                                                                                                                 
            bool bOneRowCopy_MultiRowPaste = (e.CellRange.RowCount == 1) && (range.RowCount > 1) ? true : false;                                         
            string sAction = string.Empty;                                               

            if (range != null && range.Row > -1)                        
            {
                for (int iRow = e.CellRange.Row; iRow < e.CellRange.Row + e.CellRange.RowCount + iAddRow; iRow++)
                                                                                        
                {
                    if (siMain.GetColumnIndex(CAppSetting.StringAction) >= 0)
                        sAction = siMain.GetValue(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)).ToString();

                    if (sAction.Trim() != "M" && sAction.Trim() != "I")                                      
                    {
                        continue;                                               
                    }

                    for (int iCol = e.CellRange.Column; iCol < e.CellRange.Column + e.CellRange.ColumnCount; iCol++)
                                                                                                     
                    {
                        if (siMain.ActiveSheet.Cells[iRow, iCol].BackColor != ControlColor.UnLockColor)                                        
                        {
                            continue;                                                              
                        }

                        if (iCol == siMain.GetColumnIndex(DefColumns.ScmSiteId))
                        {
                            if (siMain.GetColumnIndex(DefColumns.Division) != -1 && siMain.GetColumnIndex(DefColumns.ScmSiteId) != -1)
                            {
                                string sDivisionID = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                                string sScmSiteID = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();

                                                                            
                                if (bOneRowCopy_MultiRowPaste && iStartRow != iRow)
                                {
                                    sDivisionID = siMain.GetValue(iStartRow, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                                    sScmSiteID = siMain.GetValue(iStartRow, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                                    siMain.SpreadObject.SuspendLayout();
                                    siMain.SetValue(iRow, siMain.GetColumnIndex(DefColumns.ScmSiteId), siMain.GetValue(iStartRow, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString());
                                    siMain.SpreadObject.ResumeLayout();
                                }

                                dtMeasure = GetLookupValues("FCST_PRICE_EDIT_MEASURE", "DMF0082", sDivisionID, sScmSiteID, cboBucketType.ControlValues, "");
                                DataTable dtIncotermsType = GetIncotermsType(sDivisionID, sScmSiteID);                                                                                                                       

                                siMain.SpreadObject.SuspendLayout();
                                siMain.SetCellTypeCombo(iRow, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure);
                                siMain.SetCellTypeCombo(iRow, siMain.GetColumnIndex(DefColumns.Incoterms), dtIncotermsType);                                                                                                                        
                                siMain.SpreadObject.ResumeLayout();
                            }
                        }
                                                                                                                                      
                                                                                        
                            
                                                                                                                                         
                                
                                                                                                                                     
                                                                                                                                     

                                                                              
                                                                                      
                                    
                                                                                                                                       
                                                                                                                                       
                                                                           
                                                                                                                                                                                              
                                                                          
                                    

                                                                                                         

                                                                       
                                                                                                                               
                                                                      
                                
                            
                        else if (iCol == siMain.GetColumnIndex(DefColumns.ItemId))
                        {
                            if (siMain.GetColumnIndex(DefColumns.Division) != -1 && siMain.GetColumnIndex(DefColumns.ScmSiteId) != -1)
                            {
                                string sDivision = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                                string sScmSiteID = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                                string sItemID = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ItemId)).ToString();

                                                                            
                                if (bOneRowCopy_MultiRowPaste && iStartRow != iRow)
                                {
                                    sDivision = siMain.GetValue(iStartRow, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                                    sScmSiteID = siMain.GetValue(iStartRow, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                                    sItemID = siMain.GetValue(iStartRow, siMain.GetColumnIndex(DefColumns.ItemId)).ToString();
                                    siMain.SpreadObject.SuspendLayout();
                                    siMain.SetValue(iRow, siMain.GetColumnIndex(DefColumns.ItemId), siMain.GetValue(iStartRow, siMain.GetColumnIndex(DefColumns.ItemId)).ToString());
                                    siMain.SpreadObject.ResumeLayout();
                                }

                                                                                
                                                                                                                                                                                      

                                                                                                                                             
                                dtCellProdSiteID = Data.Common(Data.Type.CELL_PROD_SITE_ID, false, sDivision, sItemID, "", "", "");

                                siMain.SpreadObject.SuspendLayout();
                                siMain.SetCellTypeCombo(iRow, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID), dtCellProdSiteID);
                                siMain.SpreadObject.ResumeLayout();
                            }
                        }
                        else if (iCol == siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID))
                        {
                            string sDivision = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                            string sScmSiteID = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                            string sItemID = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ItemId)).ToString();

                                                                        
                            if (bOneRowCopy_MultiRowPaste && iStartRow != iRow)
                            {
                                sDivision = siMain.GetValue(iStartRow, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                                sScmSiteID = siMain.GetValue(iStartRow, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                                sItemID = siMain.GetValue(iStartRow, siMain.GetColumnIndex(DefColumns.ItemId)).ToString();
                            }

                                                                                                                                         
                            dtCellProdSiteID = Data.Common(Data.Type.CELL_PROD_SITE_ID, false, sDivision, sItemID, "", "", "");

                            siMain.SpreadObject.SuspendLayout();
                            siMain.SetCellTypeCombo(iRow, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID), dtCellProdSiteID);
                            siMain.SpreadObject.ResumeLayout();

                                                               
                            if (bOneRowCopy_MultiRowPaste && iStartRow != iRow)
                            {
                                siMain.SpreadObject.SuspendLayout();
                                siMain.SetValue(iRow, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID), siMain.GetValue(iStartRow, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID)).ToString());
                                siMain.SpreadObject.ResumeLayout();
                            }
                        }
                        else if (iCol == siMain.GetColumnIndex(DefColumns.Measure))
                        {
                            string sDivisionID = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                            string sScmSiteID = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();

                                                                        
                            if (bOneRowCopy_MultiRowPaste && iStartRow != iRow)
                            {
                                sDivisionID = siMain.GetValue(iStartRow, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                                sScmSiteID = siMain.GetValue(iStartRow, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                            }

                            dtMeasure = GetLookupValues("FCST_PRICE_EDIT_MEASURE", "DMF0082", sDivisionID, sScmSiteID, cboBucketType.ControlValues, "");

                            siMain.SpreadObject.SuspendLayout();
                            siMain.SetCellTypeCombo(iRow, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure);
                            siMain.SpreadObject.ResumeLayout();

                                                               
                            if (bOneRowCopy_MultiRowPaste && iStartRow != iRow)
                            {
                                siMain.SpreadObject.SuspendLayout();
                                siMain.SetValue(iRow, siMain.GetColumnIndex(DefColumns.MEASURE), siMain.GetValue(iStartRow, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString());
                                siMain.SpreadObject.ResumeLayout();
                            }
                        }
                        else if (iCol < siMain.GetColumnIndex(DefColumns.Measure))
                        {
                                                                        
                            if (bOneRowCopy_MultiRowPaste && iStartRow != iRow)
                            {
                                siMain.SpreadObject.SuspendLayout();
                                siMain.SetValue(iRow, iCol, siMain.GetValue(iStartRow, iCol).ToString());
                                siMain.SpreadObject.ResumeLayout();
                            }
                        }
                                         
                                                                                                                                                                                   
                                                                                                                

                                                            
                                                                                                                                                      
                                                               
                                                                                                                                   
                                                              

                                                                         
                                                                                                                                  
                                                                                                                                            
                                                                                                                         
                                                                                                                                    
                            
                                                    
                                               
                                                    
                                                    
                                                                        

                                                                           
                                     
                                                                                                                                                
                                          
                                                                                                                                                
                                        
                                                                                    
                                                                        
                                       
                                                                               
                                   
                                  
                                                                                                                          
                                                                                   
                                                                           

                                                                                                   
                                    
                                                        
                                    
                                       
                                    
                                                        
                                    

                                                     
                                                        
                                    
                                            
                                              
                                                                                               
                                            
                                                                               
                                                
                                                                                                                  
                                                    
                                                                                           
                                                                                                                                                               
                                                                                          

                                                                                                        
                                                        
                                                                                                 

                                                                                                   
                                                            
                                                                                               
                                                                
                                                                                                       
                                                                                                                                                    
                                                                                                      
                                                                         
                                                                
                                                            
                                                        
                                                    
                                                
                                            
                                                                                                     
                                            
                                                                               
                                                
                                                                                                                  
                                                    
                                                                                           
                                                                                                                                                               
                                                                                          
                                                    
                                                
                                            
                                                                               
                                                                                                    
                                                                              
                                                 
                                              
                                                                                               
                                            
                                                                               
                                                
                                                                                                                  
                                                    
                                                                                           
                                                                                                                                                                   
                                                                                          

                                                                                                        
                                                        
                                                                                                 

                                                                                                   
                                                            
                                                                                               
                                                                
                                                                                                       
                                                                                                                                                        
                                                                                                      
                                                                         
                                                                
                                                            
                                                        
                                                    
                                                
                                            
                                                                                                     
                                            
                                                                               
                                                
                                                                                                                  
                                                    
                                                                                           
                                                                                                                                                                   
                                                                                          
                                                    
                                                
                                            
                                                                               
                                                                                                        
                                                                              
                                                 
                                                              
                                    
                                  
                            
                    }
                }
            }
        }

        private void spdMain_ComboSelChange(object sender, FarPoint.Win.Spread.EditorNotifyEventArgs e)
        {
            string sDivision = CAppSetting.StringALL;
            string sTeam = CAppSetting.StringALL;
            string sEndCustomer = CAppSetting.StringALL;
            string sItemID = string.Empty;
            string sScmSiteID = string.Empty;
            string sIncoterms = string.Empty;                                                                                           
                                            

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
                    if (sTeam == "")
                    {
                        sTeam = clbTeam.ControlValues;
                    }
                    dtCustomer40 = Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.Customer), dtCustomer40);
                    sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Customer)).ToString();
                }

                if ((clbDivision.ControlValues.Substring(0, 2) == "40"))
                {
                    dtSalesSite40 = Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSite40);
                }

                                                                                
                   
                                                                                                                                              
                                                                                                             

                dtBizType = GetBizTypebyDivision(clbDivision.ControlValues);
                clsCtrl.setListBox(dtBizType, clbBizType, true);

                if (sDivision != null && sDivision != "" && sDivision.Substring(0, 2) == "81")
                    siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PlantSiteId), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PlantSiteId), false);
                else
                    siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PlantSiteId), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PlantSiteId), true);

                if (siMain.GetColumnIndex(DefColumns.Division) != -1 && siMain.GetColumnIndex(DefColumns.ScmSiteId) != -1)
                {
                    sDivision = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                    sScmSiteID = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();

                    sScmSiteID = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();

                    dtMeasure = GetLookupValues("FCST_PRICE_EDIT_MEASURE", "DMF0082", sDivision, sScmSiteID, cboBucketType.ControlValues, "");
                    siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure);
                }

            }
            else if (e.Column == siMain.GetColumnIndex(DefColumns.Team))
            {
                if (siMain.GetColumnIndex(DefColumns.Customer) > 0)
                {
                    sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                    sTeam = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Team)).ToString();
                                                                                                                                                          
                    if (sTeam == "")
                    {
                        sTeam = clbTeam.ControlValues;
                    }
                    dtCustomer = Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);


                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.Customer), dtCustomer);

                    sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Customer)).ToString();
                    dtSalesSite = Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSite);
                }
            }
            else if (e.Column == siMain.GetColumnIndex(DefColumns.Customer))
            {
                sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                sScmSiteID = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Customer)).ToString();
                sItemID = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemId)).ToString();

                dtSalesSite = Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
                siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSite);
            }
            else if (e.Column == siMain.GetColumnIndex(DefColumns.ScmSiteId))
            {
                if (siMain.GetColumnIndex(DefColumns.Division) != -1 && siMain.GetColumnIndex(DefColumns.ScmSiteId) != -1)
                {
                    sDivision = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                    sScmSiteID = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                    sEndCustomer = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Customer)).ToString();
                    sItemID = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemId)).ToString();
                    sIncoterms = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Incoterms)).ToString();                                                                                                 


                    dtMeasure = GetLookupValues("FCST_PRICE_EDIT_MEASURE", "DMF0082", sDivision, sScmSiteID, cboBucketType.ControlValues, "");
                    siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure);

                                                                                                              
                    dtSalesBucket = GetLookupValues("SALES_BUCKET", sDivision, sScmSiteID, sIncoterms, "", "");
                    if (dtSalesBucket.Rows.Count > 0)
                    {
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.BUCKET), dtSalesBucket.Rows[0]["BUCKET"].ToString());
                    }
                    else
                    {
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.BUCKET), "");
                    }
                }
            }
                                                                                                                           
            else if (e.Column == siMain.GetColumnIndex(DefColumns.Incoterms))
            {
                if (siMain.GetColumnIndex(DefColumns.Division) != -1 && siMain.GetColumnIndex(DefColumns.ScmSiteId) != -1)
                {
                    sDivision = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                    sScmSiteID = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToString();
                    sIncoterms = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Incoterms)).ToString();

                    dtSalesBucket = GetLookupValues("SALES_BUCKET", sDivision, sScmSiteID, sIncoterms, "", "");
                    if (dtSalesBucket.Rows.Count > 0)
                    {
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.BUCKET), dtSalesBucket.Rows[0]["BUCKET"].ToString());
                    }
                    else
                    {
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.BUCKET), "");
                    }
                }
            }
                                                                                                                         

                                    
                                                                                     
            else if (e.Column == siMain.GetColumnIndex(DefColumns.Measure))
            {
                                                                                  

                                                            
                                                                                                                                     
                                                                                                                                
                                                                                                                 
                    
                                                                                              
                        
                                                                                          
                                                                                                       
                                                                            
                                                                                                   
                                                                              
                                                                                                     
                                                                              
                                                                                                     
                                                                              
                                                                                                     
                        
                    
            }
                                                                                
                                           
        }

        private void spdMain_EditChange(object sender, EditorNotifyEventArgs e)
        {
            if (siMain.GetColumnIndex(DefColumns.Measure) >= siMain.ActiveColumnIndex) return;

            bPasteContinue = true;

        }

                                                                           
        private void spdMain_KeyUp(object sender, System.Windows.Forms.KeyEventArgs e)
        {
            if (fps == null) return;

                                                                           
            string sdivision = clbDivision.ControlValues;
            string sTeam = clbTeam.ControlValues;
            string sEndCustomer = clbCustomer.ControlValues;
            string sScmSite = clbSalesSite.ControlValues;

            string sItemId = "";                                                     
            int sActiveRow = 0;
            int sActiveCol = 0;                                   

            range = spdMain.Sheets[0].GetSelection(0);                                                            

            try
            {
                this.Cursor = Cursors.WaitCursor;

                if (e.Control == true && e.KeyCode == Keys.V || e.Control == false && e.KeyCode == Keys.V)
                {
                                                                           

                    fps.ActiveSheet.ClipboardPaste(ClipboardPasteOptions.AsStringSkipHidden);
                                                
                    bPasteContinue = true;
                }

                if (e.Control == true && e.KeyCode == Keys.C || e.Control == false && e.KeyCode == Keys.C)
                {
                                                 
                    Clipboard.Clear();
                    fps.ActiveSheet.ClipboardCopy(ClipboardCopyOptions.AsStringSkipHidden);
                }

            }
            finally
            {
                this.Cursor = Cursors.Default;
            }
        }

                                                                      
                                                                                       
          
                                                                           
                                                          
                                                  
                                                             
                                                          
 
                                                                                     
                                
                                                                  
 
                                                                                                                  
 
                                                                                      
              
                                                                                                           
                  
                                                                                                  
                                           
 
                                                        
                                           
                      
                                                                               
                                                                                                                   
                                                                        
                      
 
                                                                                                                                                                                                                    
                                                                                                                                                                                    
                  
 
                                                                                                           
                  
                                       
                                                                                              
                  
              
                                                                                             
 
 
                                                                                               
 
                                                                                                       
              
                                                                                              
                                                                 
                                       
              
 
                                                                                                       
              
                                                                                          
                                                               
              
          
          

                                                                               
        private void spdMain_TopChange(object sender, FarPoint.Win.Spread.TopChangeEventArgs e)
        {
            CanModelChange = false;
            siMain.SmartColMerge();
            CanModelChange = true;
        }

        private void spdMain_LeaveCell(object sender, LeaveCellEventArgs e)
        {
                                               
                                                                 
                                                    

                                    
                               
                                    
                                      
                                            
                                   
                                         
                               
                            
                                    

                              
                                    

                                          
                                                                                   

                   
                               
                                                                                                                                                                         
                                                                                                      

                                                               
                                                                                                                        
                                                                                                                                  

                                                        
                       
                                                              
                                                                                                              
                
                
                                                                                                          
                                                                   
                                                           

                                                                                                                                                                 
                                                                                                                                             
                    
                                        
                    
                       
                    
                                        
                    

                                     
                                        
                    
                            
                              
                                                                               
                            
                                                               
                                
                                                                                                  
                                    
                                                                           
                                                                                                                                               
                                                                          

                                                                                        
                                        
                                                                                 

                                                                                   
                                            
                                                                               
                                                
                                                                                       
                                                                                                                                    
                                                                                      
                                                         
                                                
                                            
                                        
                                    
                                
                            
                                                                                     
                            
                                                               
                                
                                                                                                  
                                    
                                                                           
                                                                                                                                               
                                                                          
                                    
                                
                            
                                                               
                                                                                    
                                                              
                                 

                              
                                                                               
                            
                                                               
                                
                                                                                                  
                                    
                                                                           
                                                                                                                                                   
                                                                          

                                                                                        
                                        
                                                                                 

                                                                                   
                                            
                                                                               
                                                
                                                                                       
                                                                                                                                        
                                                                                      
                                                         
                                                
                                            
                                        
                                    
                                
                            
                                                                                     
                            
                                                               
                                
                                                                                                  
                                    
                                                                           
                                                                                                                                                   
                                                                          
                                    
                                
                            
                                                               
                                                                                        
                                                              
                                 
                                              
                    
                
        }
        #endregion

        #region 8. Spread Sheet의 CELL에 들어가는 콤보박스 DataTable 데이터
                      
                                                                         
                       
                                
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
        #endregion

        #region 9. ETC 기타 함수
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

        #region LocalDataSet
        private GSCM.FP.Common.UIL.FilterDataSet Filter = new GSCM.FP.Common.UIL.FilterDataSet();
        #endregion

                                             
        #region FILTER_PART
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

                                               
                                                                                                                                                                  
            
                                                   
                                               
                                                                                            
                
                                                                                                                              
                                        

                                
                                                                       
                    
                                                                                                   
                                                                 
                    
                       
                    
                                                                                               
                                                                 
                    
                
                                                                           
                
                                                                         
                    
                                                                               
                        
                                                           
                            
                                        
                            

                                           
                                                                                                                                                                                     
                                                                                                                  
                               
                                                                     
                                    
                                                                                                                                                      
                                 
                                                              
                               
                            
                                                                         
                                                                       
                                          
                                                                          

                                                                                                     
                                                                                     
                                                                                                      
                                                                     
                                                                                                                               
                                                                                                                    
                                                      
                                
                                            
                                
                                   
                                
                                                                                                                 
                                                                                                                
                                                         
                                
                                                                                                   
                            
                                          
                               
                                                                                                             
                                                                                                            
                                                     
                            
                        
                    
                                                                            
                    
                                                                             
                        
                                                         
                            
                                        
                            

                                        
                            
                                                                                               
                                                                         
                                                    
                            

                                                                                
                            
                                                                                                         
                                                                                                            
                                                     
                            
                                                                         
                            
                                                                                                         
                                                                         
                                                    
                            
                        
                    
                                
                    
                                                                              
                        
                                                          
                            
                                        
                            
                                                                                                       
                                                                                                        
                                                 
                        
                    
                

                                                  
            


                                                                                                  
                                               
                                                                                                                                                                  
            
                                                   
                                               
                                                                                             
                
                                                                                                                              
                                        

                                
                                                                       
                    
                                                         
                                                                                                                  
                                                                   
                        
                                                                                                       
                                                                     
                        
                    
                       
                    
                                                         
                                                                                                                  
                                                                   
                        
                                                                                                   
                                                                     
                        
                    
                
                                                                           
                
                                                                         
                    
                                                                               
                        
                                                           
                            
                                        
                            

                                           
                                                                                                                                                                                     
                                                                                                                  


                                                                           
                                                                                                                                    
                                                                                    
                                 
                                                                       
                                   
                                                                
                                 
                                                              
                              
                            
                                                                                                     
                                                                                     
                                                                                                      
                                                                     
                                                                                                                               
                                                                                                                    
                                                      
                                
                                            
                                
                                   
                                
                                                                                                                 
                                                                                                                
                                                         
                                
                                                                                                   
                            
                                          
                            
                                                                                                             
                                                                                                            
                                                     
                            
                        
                    
                                                                            
                    
                                                                             
                        
                                                         
                            
                                        
                            

                                         
                            
                                                                 
                                                                                                                          
                                                                           
                                
                                                                                                               
                                                                             
                                                        
                                
                            

                                                                                
                            
                                                                                                         
                                                                                                            
                                                     
                            
                                                                         
                            
                                                                                                         
                                                                         
                                                    
                            
                        
                    
                                
                    
                                                                              
                        
                                                          
                            
                                        
                            
                                                                                                       
                                                                                                        
                                                 
                        
                    
                

                                                  
            
        #endregion

                                                                                                                      
        private void chkSum_CheckedChanged(object sender, EventArgs e)
        {
            if (siMain != null)
            {
                SetSpreadColumn();
            }
        }
                                                                                                                    

                      
                                                    
                                                                                                                  
                       
        private void SetEditList()
        {
                                                            
                               

            list_EDIT_Week.Clear();                     
            list_EDIT_Month.Clear();                      
            list_EDIT_Day.Clear();                    
            list_EDIT_Month_M4.Clear();                                                      

            for (int iCol = siMain.GetColumnIndex(DefColumns.Measure) + 1; iCol <= siMain.GetMaxColumnIndex(); iCol++)
            {
                string sMonthCol = "";
                string sWeekCol = "";
                string sDayCol = "";

                                                                              
                                          
                string[] sPeriod = drpPeriod.ControlValues.Split(':');
                                                                            

                if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                {
                    sMonthCol = siMain.GetColumnTag(iCol);

                                                 
                    if (int.Parse(this_YYYYMM.Replace("M_", "")) <= int.Parse(sMonthCol.Replace("M_", "")))
                    {
                        list_EDIT_Month.Add(iCol);

                                                                                 
                        if (int.Parse(sMonthCol.Replace("M_", "")) > int.Parse(dtWeek.Rows[0]["MONTH_NAME"].ToString().Replace("-", "")))
                        {
                            list_EDIT_Month_M4.Add(iCol);
                        }
                    }
                }

                                                                              
                                
                                                                                                      
                   
                                                                  
                  
                                                          
 
                                               
                                                                                                             
                      
                                                  
                      
                   
                  
                if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0 && siMain.GetColumnIndex(this_YYYYMMWW) > 0 && siMain.GetColumnIndex(this_YYYYMMWW) <= iCol)
                {
                    list_EDIT_Week.Add(iCol);
                }
                else if (int.Parse(sPeriod[0].Substring(0, 6)) >= Convert.ToInt32(this_YYYYMMWW.Replace("W_", "").Substring(0, 6)))
                {
                    if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0)
                    {
                        if (siMain.GetColumnIndex(this_YYYYMMWW) <= iCol)
                        {
                            list_EDIT_Week.Add(iCol);
                        }
                    }
                }
                                                                            

                if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0)
                {
                    sDayCol = siMain.GetColumnTag(iCol);

                                                 
                    if (int.Parse(sResultYYYYMMDD) <= int.Parse(sDayCol.Replace("D_", "")))
                    {
                        list_EDIT_Day.Add(iCol);
                    }
                }
            }

                                                                                                       
            DataTable dt;

            if (dsMain != null && dsMain.Tables.Count >= 3)
            {
                dt = dsMain.Tables[3].Copy();

                                                                                                       
                              
                                                               
                  
                                                                                                             
                  
                                                               
                  
                                                                                                             
                  
                                                          
                  
                                                                                                   
                  
                                                                 
                  
                                                                                                                 
                   

                                                             

                bEDIT_AUTH_SCM_FCST = (from r in dt.AsEnumerable() where r.Field<string>("MEASURE") == "SCM_FCST" select r.Field<string>("EDIT_FLAG")).First() == "Y" ? true : false;

                bEDIT_AUTH_MKT_FCST = (from r in dt.AsEnumerable() where r.Field<string>("MEASURE") == "MKT_FCST" select r.Field<string>("EDIT_FLAG")).First() == "Y" ? true : false;

                bEDIT_AUTH_LOC = (from r in dt.AsEnumerable() where r.Field<string>("MEASURE") == "LOC" select r.Field<string>("EDIT_FLAG")).First() == "Y" ? true : false;

                bEDIT_AUTH_VMI_IN_REQ = (from r in dt.AsEnumerable() where r.Field<string>("MEASURE") == "VMI_In_Req" select r.Field<string>("EDIT_FLAG")).First() == "Y" ? true : false;


                                                                                                     
            }
                                                                                                     
        }

                      
                                                    
                                                                          
                       
        private void SetLockRange(int iStartRow, int iEndRow, bool bLockFlag)
        {
            if (!siMain.SpreadObject.IsLayoutSuspended)
            {
                siMain.SpreadObject.SuspendLayout();
            }

                                                        
            List<int> list_Edit_Target_Idx = new List<int>();

            if (cboBucketType.ControlValues == BucketType.Monthly)
            {
                list_Edit_Target_Idx = list_EDIT_Month.ToList();
            }
            else if (cboBucketType.ControlValues == BucketType.Weekly)
            {
                list_Edit_Target_Idx = list_EDIT_Week.ToList();
            }
            else if (cboBucketType.ControlValues == BucketType.Daily)
            {
                list_Edit_Target_Idx = list_EDIT_Day.ToList();
            }


            string sEditFlag = string.Empty;
            string sMeasure = string.Empty;
            string sFcstType = string.Empty;
            string sAction = string.Empty;

            for (int iRow = iStartRow; iRow <= iEndRow; iRow++)
            {
                sEditFlag = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToString();
                sMeasure = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Measure)).ToString();
                sFcstType = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FcstType)).ToString();
                sAction = siMain.GetValue(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)).ToString();

                                                        
                if (sEditFlag != CAppSetting.StringY && sAction != CAppSetting.StringI) continue;

                                  
                switch (sMeasure)
                {
                    case "LOC":
                        if (!bEDIT_AUTH_LOC) continue;
                        if (cboBucketType.ControlValues == BucketType.Daily) continue;                                                      
                        break;

                    case "MKT_FCST":
                        if (!bEDIT_AUTH_MKT_FCST) continue;
                        break;

                    case "SCM_FCST":
                        if (!bEDIT_AUTH_SCM_FCST) continue;
                        if (sFcstType == "RMA") continue;             
                        break;

                    case "VMI_In_Req":
                        if (!bEDIT_AUTH_VMI_IN_REQ) continue;
                        break;

                    default:
                        break;
                }

                                                                                                 
                if (sAction == CAppSetting.StringI)
                {
                    siMain.LockRange2(iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetMaxColumnIndex(), true, true);
                }

                foreach (int idx in list_Edit_Target_Idx)
                {
                    switch (sMeasure)
                    {
                        case "LOC":
                            siMain.LockRange2(iRow, idx, iRow, idx, bLockFlag, true);
                            break;

                        case "MKT_FCST":
                        case "SCM_FCST":
                        case "VMI_In_Req":
                            if (cboBucketType.ControlValues == BucketType.Monthly)
                            {
                                if (list_EDIT_Month_M4.Contains(idx))                                                  
                                {
                                    siMain.LockRange2(iRow, idx, iRow, idx, bLockFlag, true);
                                }
                            }
                            else
                            {
                                siMain.LockRange2(iRow, idx, iRow, idx, bLockFlag, true);
                            }
                            break;

                        default:
                            break;
                    }
                }
            }
        }

                      
                                                    
                                    
                       
                                
        public FarPoint.Win.Spread.Cell Insert()
        {
            int xCol1 = 0, xRow1 = 0, xCol2 = 0, xRow2 = 0, iIndex = 0;

            FarPoint.Win.Spread.Cell acell;
            FarPoint.Win.Spread.Cell range1;
                                       
            if (siMain.IsLock(sv.SheetName) == true) return null;

            Cell c = sv.ActiveCell;

            if (c == null)
            {
                iIndex = this.sv.Rows.Count;
                this.sv.Rows.Add(iIndex, 1);
                         
                xCol1 = sv.GetColumnFromTag(null, CAppSetting.StringAction).Index;
                range1 = sv.Cells[0, xCol1, 0, xCol1];

                range1.Text = CAppSetting.StringI;
                range1.ForeColor = ControlColor.FGAction;
                range1.BackColor = ControlColor.BGInserted;

                #region 최초 Row 추가시

                                                  
                                 
                xCol1 = sv.GetColumnFromTag(null, CAppSetting.StringAction).Index;
                xCol2 = xCol1;


                range1 = sv.Cells[xRow1, xCol1, xRow2, xCol1];

                range1.Text = CAppSetting.StringI;
                range1.ForeColor = ControlColor.FGAction;
                range1.BackColor = ControlColor.BGInserted;

                xCol2 = sv.ColumnCount - 1;
                FarPoint.Win.Spread.Cell range3;
                range3 = sv.Cells[xRow1, xCol1 + 1, xRow2, xCol2];
                range3.Locked = false;
                range3.BackColor = ControlColor.UnLockColor;

                #endregion

                return range1;
            }

                     
            xCol1 = sv.GetColumnFromTag(null, CAppSetting.StringAction).Index;
            xRow1 = sv.ActiveRow.Index;

                        
            acell = this.sv.Cells[xRow1, xCol1];

                                  
                                                                     

                                      
                                                        
                                                    
                            
 
                                            
              
                                 
                                         
                                   
                                
                                                        
                                                  
              
                 
              
                                                                                   
                               
                                            
                               
              
              

                                                    
            xCol1 = sv.GetColumnFromTag(null, CAppSetting.StringAction).Index;
            xCol2 = xCol1;
            xRow1 = sv.ActiveRow.Index;
            xRow2 = xRow1;

            sv.SetActiveCell(sv.ActiveRowIndex, 0);
                                     
                                                                 
                     

            if (xRow1 < 0) return null;


            sv.Rows.Add(xRow1, xRow2 - xRow1 + 1);

                              
            xCol1 = sv.GetColumnFromTag(null, CAppSetting.StringAction).Index;
            xCol2 = xCol1;


            range1 = sv.Cells[xRow1, xCol1, xRow2, xCol1];

            range1.Text = CAppSetting.StringI;
            range1.ForeColor = ControlColor.FGAction;
            range1.BackColor = ControlColor.BGInserted;

            xCol2 = sv.ColumnCount - 1;
            FarPoint.Win.Spread.Cell range2;
            range2 = sv.Cells[xRow1, xCol1 + 1, xRow2, xCol2];
                                     
                                                           

                                          
            if (this.sv.GetColumnFromTag(null, CAppSetting.StringSelect) != null)
            {
                range2 = sv.Cells[xRow1, this.sv.GetColumnFromTag(null, CAppSetting.StringSelect).Index, xRow2, this.sv.GetColumnFromTag(null, CAppSetting.StringSelect).Index2];
                                         
                                                                    
            }

            base.IsChange = true;
            return range1;

        }
    }
}