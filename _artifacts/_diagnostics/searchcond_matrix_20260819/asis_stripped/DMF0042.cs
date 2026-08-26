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
using System.Windows.Forms;
using System.Collections.Specialized;

using FarPoint.Win.Spread.CellType;
using System.Threading.Tasks;
using System.Drawing;
using GSCM.DM.Plan.UIL.POPUP;
using GSCM.FP.Common.UIL.Service;

                                                                                                                            
                   
                   
                   
                                                                                                                            
                                           
                                                                                                                            
                                                                             
                                                                                     
                                                                                                           
                                                                                                                         
                                                                             
                                      
                                                                        
                                                 
                                                                                              
                                                                                                                            
                                                                                                  
                                                                                                    
                                                                                                      
                                                                                             
                                                                                                                           

namespace GSCM.DM.Plan.UIL
{
    public partial class DMF0042_BizPlan : BaseForm
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

        private DataTable dtFuturePrice = null;
        private DataTable dtCurrencyList = null;

        private String valid_YN = "";
        private String start_YYYYQQ = "";
        private String end_YYYYQQ = "";
        private String start_YYYYMM = "";
        private String end_YYYYMM = "";
        private String start_YYYY = "";
        private String end_YYYY = "";

                  
        SpreadInfo siMain = null;

        TextCellType cellTypeImage = null;


                      
                       
                       
        private struct SpdSheet
        {
            public static string shtMain = "Biz Plan";
        }

                      
                  
                       
        private struct DefColumns
        {
            public static string DIVISION_ID = "DIVISION_ID";
            public static string DEPT_ID = "DEPT_ID";
            public static string END_CUSTOMER = "END_CUSTOMER";
            public static string END_CUSTOMER40 = "END_CUSTOMER40";
                                                                
            public static string PROJECT_CODE = "PROJECT_CODE";
            public static string CUST_GROUP = "CUST_GROUP";
            public static string CUST_GROUP_DTL = "CUST_GROUP_DTL";
            public static string OWNER = "OWNER";
            public static string APPLICATION = "APPLICATION";
            public static string ROUTE = "ROUTE";
            public static string PROJECT_NAME = "PROJECT_NAME";
                                                                    
            public static string BIZ_TYPE_NAME40 = "BIZ_TYPE_NAME40";
            public static string ITEM_ID = "ITEM_ID";
            public static string ITEM_CLASS_NAME = "ITEM_CLASS_NAME";
            public static string ITEM_NAME = "ITEM_NAME";
            public static string ITEM_TYPE = "ITEM_TYPE";
            public static string NICK_NAME = "NICK_NAME";
            public static string INCOTERMS = "INCOTERMS";
            public static string FCST_TYPE = "FCST_TYPE";
                                                        
            public static string PLANT_SITE_ID = "PLANT_SITE_ID";
            public static string CURRENCY = "CURRENCY";
            public static string VERSION_NO = "VERSION_NO";
            public static string FORECAST_INFO_PRODUCT_GROUP = "FORECAST_INFO_PRODUCT_GROUP";
            public static string FORECAST_INFO_CELL_PACK_COUNT = "FORECAST_INFO_CELL_PACK_COUNT";
            public static string PRODUCT_GROUP_NAME = "PRODUCT_GROUP_NAME";
            public static string SHIPTO_DESCRIPTION = "SHIPTO_DESCRIPTION";
            public static string CELL_TYPE = "CELL_TYPE";
            public static string INTERNAL_YN = "INTERNAL_YN";
            public static string COUNTRY_NAME = "COUNTRY_NAME";
            public static string CITY_NAME = "CITY_NAME";
            public static string FORECAST_INFO_CELL_MODEL = "FORECAST_INFO_CELL_MODEL";
            public static string FORECAST_INFO_SPEC = "FORECAST_INFO_SPEC";
            public static string MDM_PROJECT_NAME = "MDM_PROJECT_NAME";
            public static string MIN_CAPACITY = "MIN_CAPACITY";
            public static string VMI_YN = "VMI_YN";
            public static string CELL_PROD_SITE = "CELL_PROD_SITE";

            public static string PRIORITY = "PRIORITY";
            public static string DMS_SALES = "DMS_SALES";
            public static string DMS_CUSTOMER = "DMS_CUSTOMER";
            public static string REPORT_GROUP1 = "REPORT_GROUP1";
            public static string REPORT_GROUP2 = "REPORT_GROUP2";
            public static string REPORT_GROUP3 = "REPORT_GROUP3";
            public static string REPORT_GROUP4 = "REPORT_GROUP4";
            public static string REPORT_GROUP5 = "REPORT_GROUP5";
            public static string REPORT_GROUP6 = "REPORT_GROUP6";
            public static string REPORT_GROUP7 = "REPORT_GROUP7";
            public static string REPORT_GROUP8 = "REPORT_GROUP8";
            public static string EDIT_FLAG = "EDIT_FLAG";
            public static string MEASURE = "MEASURE";

            public static string COLUMN_NAME = "COLUMN_NAME";
            public static string COLUMN_LABEL_NAME = "COLUMN_LABEL_NAME";
            public static string SMALL_CLASS_LABEL_NAME = "SMALL_CLASS_LABEL_NAME";
            public static string LARGE_CLASS_LABEL_NAME = "LARGE_CLASS_LABEL_NAME";

            public static string INCOTERMS40 = "INCOTERMS40";
            public static string FCST_TYPE40 = "FCST_TYPE40";
                                                            

                           
            public static string PROJECT_CODE82 = "PROJECT_CODE82";
            public static string BIZ_TYPE_NAME82 = "BIZ_TYPE_NAME82";
            public static string ITEM_ID40 = "ITEM_ID40";
            public static string SCM_SITE_ID40 = "SCM_SITE_ID40";
            public static string SCM_SITE_ID81 = "SCM_SITE_ID81";
            public static string SCM_SITE_ID82 = "SCM_SITE_ID82";
                                                                    
                                                                        
                                                                        
            public static string CELL_PER_CAR = "CELL_PER_CAR";
            public static string MODULE_PER_CAR = "MODULE_PER_CAR";
            public static string BIZ_TYPE_NAME81 = "BIZ_TYPE_NAME81";
            public static string DEPT_ID40 = "DEPT_ID40";
            public static string INCOTERMS82 = "INCOTERMS82";

                                                     
            public static string ITEM_USE = "ITEM_USE";
            public static string UNIT_ENERGY = "UNIT_ENERGY";


        }

        private struct DefColumnsLabel
        {
            public static string Saturday = "SAT";
            public static string Sunday = "SUN";
        }

        private struct BucketType
        {
            public static string Monthly = "MONTHLY";
            public static string Quarterly = "QUARTERLY";
            public static string Yearly = "YEARLY";
        }

        private string sBinding = "GSCM.DM.Master.WSL/FoxDataService.svc";
        private string sScmBinding = "GSCM.SCM.Master.WSL/FoxDataService.svc";

        private string sDefaultDay = string.Empty;

        private bool bPasteContinue = true;
        #endregion

        #region 2. Construct

        public DMF0042_BizPlan()
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


        }

        #endregion

        #region 3. Define
        private void InitControls()
        {
                              
            this.ConditionNotUseList.Add(cboClosed);

            dtDivision = Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
            clsCtrl.setListBox(dtDivision, clbDivision, false, "CODE", "NAME");
            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);

            dtTeam = Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision);
            clsCtrl.setListBox(dtTeam, clbTeam, true);

            DataTable dtYn = GetLookupData("DM_YN");
            clsCtrl.setListBox(dtYn, cboClosed, false, "CODE", "NAME");

            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);
            string sEndCustomer = string.Empty;


            if (sDivision != null && sDivision != "")
            {
                if (sDivision == "40")
                {
                    dtBizType = Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "");
                    clsCtrl.setListBox(dtBizType, clbBizType, true);

                    dtCustomer = Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);

                    lblProject.Enabled = false;
                    lblPlantSite.Enabled = false;
                    btnProject.Enabled = false;
                    dtMeasure = Data.Common(Data.Type.DMF0042_BP_Measure, false, "40", "", "", "");
                }
                else if (sDivision.Substring(0, 2) == "81")
                {
                    dtBizType = GetBizTypebyDivision(sDivision);
                    clsCtrl.setListBox(dtBizType, clbBizType, true);

                    dtCustomer = Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam);

                    lblProject.Enabled = true;
                    lblPlantSite.Enabled = true;
                    btnProject.Enabled = true;

                    dtMeasure = Data.Common(Data.Type.DMF0042_BP_Measure, false, sDivision, "", "", "");

                }
                else
                {
                    dtBizType = GetBizTypebyDivision(sDivision);
                    clsCtrl.setListBox(dtBizType, clbBizType, true);

                    dtCustomer = Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam);

                    lblProject.Enabled = true;
                    lblPlantSite.Enabled = true;
                    btnProject.Enabled = true;

                    dtMeasure = Data.Common(Data.Type.DMF0042_BP_Measure, false, "82", "", "", "");
                }
            }

            lblBizType.Enabled = true;

            clsCtrl.setListBox(dtCustomer, clbCustomer, true);
            sEndCustomer = CString.GetCheckedListValue(dtCustomer, clbCustomer.ControlValues);

            dtSalesSite = Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
            clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);

                                                                                                                                                             
            dtPlantSite = Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision);
            clsCtrl.setListBox(dtPlantSite, clbPlantSite, true);

            dtBucketType = GetLookupData("BUCKET2_TYPE_CODE");
            clsCtrl.setListBox(dtBucketType, cboBucketType, false, "CODE", "NAME");

            drpPeriod.InitValue = GetDayRange();

            dtItemType = GetLookupData("ITEM_TYPE_CODE");
            clsCtrl.setListBox(dtItemType, clbItemType, true);

            System.Windows.Forms.ToolTip toolTip1 = new System.Windows.Forms.ToolTip();
            toolTip1.SetToolTip(btnColumn, "Column Show");
            toolTip1.SetToolTip(btnMeasure, "Measure");

            dtCurrencyList = Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);

            layoutControlItem4.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;

            lblBucket1.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
            cboClosed.Enabled = false;
        }

        private void DefineProperty()
        {
            usrConditionPanel2.Height = 105;

            siMain.ImagePopUp = imageList1.Images[0];

            cellTypeImage = new TextCellType();
            cellTypeImage.BackgroundImage = new FarPoint.Win.Picture(siMain.ImagePopUp);
            cellTypeImage.BackgroundImage.AlignHorz = FarPoint.Win.HorizontalAlignment.Right;
            cellTypeImage.CharacterCasing = CharacterCasing.Upper;

            CanModelChange = true;

                                                                                                   
                                   
            switch (UserInfoContext.Current["NowGroupID"])
            {
                case "ADMIN":
                case "DM ADMIN":
                    btnCutOff.Enabled = true;
                    btnCutOff.Visible = true;
                                                                                                            
                    break;
                default:
                    btnCutOff.Enabled = false;
                    btnCutOff.Visible = false;
                                                                                                           
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

            InitSpread();
        }

        private void InitSpread()
        {
            GetSpdTitle();
                                                                  
            siMain.CreateSheetHeaderColumnDtDiv(siMain, 1, dtTitle, clbDivision.SelectedValue.ToString());                               

                                                                             
            if (clbDivision.ControlValues.Equals("40") && siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE) >= 0)
            {
                DataTable dt;
                dt = GetCellProdSite("DM_CELL_PROD_SITE", "ALL");
                this.SetComboCol(siMain, "CELL_PROD_SITE", dt);
            }
                                                                           

            if (dtTitle != null && dtTitle.Rows.Count > 0)
            {
                SetSpreadHeaderSpan(dtTitle);
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

                sColumnName = dr[DefColumns.COLUMN_NAME].ToString();
                sColumnLabel = dr[DefColumns.COLUMN_LABEL_NAME].ToString();
                sSmallLabelName = dr[DefColumns.SMALL_CLASS_LABEL_NAME].ToString();
                sLargeLabelName = dr[DefColumns.LARGE_CLASS_LABEL_NAME].ToString();

                if (iCellCnt <= iSmallStartCol)
                {
                    siMain.ColumnHeaderSpan(0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center);
                    sSmallSpanName = dr[DefColumns.SMALL_CLASS_LABEL_NAME].ToString();
                    sLargeSpanName = dr[DefColumns.LARGE_CLASS_LABEL_NAME].ToString();
                }
                else
                {
                    if (dr[DefColumns.COLUMN_NAME].ToString().IndexOf("B_") > 0)
                    {
                        siMain.VisibleColumns(iCellCnt, false);
                    }
                    else
                    {
                        sColumnName = dr[DefColumns.COLUMN_NAME].ToString();
                        sColumnLabel = dr[DefColumns.COLUMN_LABEL_NAME].ToString();
                        sLargeLabelName = dr[DefColumns.LARGE_CLASS_LABEL_NAME].ToString();
                        sSmallLabelName = dr[DefColumns.SMALL_CLASS_LABEL_NAME].ToString();
                    }

                    if (sLargeSpanName != sLargeLabelName)
                    {
                        siMain.ColumnHeaderSpan(0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center);
                        siMain.ColumnHeaderSpan(1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center);
                        sLargeSpanName = dr[DefColumns.LARGE_CLASS_LABEL_NAME].ToString();
                        iLargeStartCol = iLargeStartCol + iLargeSpanCnt;
                        iLargeSpanCnt = 0;

                        siMain.ColumnHeaderSpan(1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center);
                        siMain.ColumnHeaderSpan(2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center);
                        sSmallSpanName = dr[DefColumns.SMALL_CLASS_LABEL_NAME].ToString();
                        iSmallStartCol = iSmallStartCol + iSmallSpanCnt;
                        iSmallSpanCnt = 0;
                    }
                    else if (sSmallSpanName != sSmallLabelName)
                    {
                        siMain.ColumnHeaderSpan(1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center);
                        siMain.ColumnHeaderSpan(2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center);
                        sSmallSpanName = dr[DefColumns.SMALL_CLASS_LABEL_NAME].ToString();
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

        private void SetSpreadColumn()
        {
            int iStartCol = siMain.GetColumnIndex(DefColumns.MEASURE) + 1;

            for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
            {
                if (cboBucketType.ControlValues == BucketType.Monthly)
                {
                    if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 || siMain.GetColumnTag(iCol).IndexOf("Q_") == 0)
                        siMain.ActiveSheet.Columns[iCol].Visible = true;

                    if (siMain.GetColumnTag(iCol).IndexOf("Y_") == 0 || siMain.GetColumnTag(iCol).IndexOf("Q_") == 0)
                        siMain.ActiveSheet.Columns[iCol].Visible = chkSum.Checked;
                }
                else if (cboBucketType.ControlValues == BucketType.Quarterly)
                {
                    if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                        siMain.ActiveSheet.Columns[iCol].Visible = false;
                    else if (siMain.GetColumnTag(iCol).IndexOf("Q_") == 0)
                        siMain.ActiveSheet.Columns[iCol].Visible = true;

                    if (siMain.GetColumnTag(iCol).IndexOf("Y_") == 0)
                        siMain.ActiveSheet.Columns[iCol].Visible = chkSum.Checked;
                }
                else if (cboBucketType.ControlValues == BucketType.Yearly)
                {
                    if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 || siMain.GetColumnTag(iCol).IndexOf("Q_") == 0)
                        siMain.ActiveSheet.Columns[iCol].Visible = false;
                    else if (siMain.GetColumnTag(iCol).IndexOf("Y_") == 0)
                        siMain.ActiveSheet.Columns[iCol].Visible = true;
                }
            }
        }

        private void InitSaveDataTable()
        {
            dtSave = new DataTable("MktFcstSave");
            dtSave.Columns.Add(CAppSetting.StringAction, typeof(string));
            dtSave.Columns.Add(DefColumns.DIVISION_ID, typeof(string));


            dtSaveFinal = new DataTable("MktFcstSave");
            dtSaveFinal.Columns.Add(DefColumns.DIVISION_ID, typeof(string));

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
            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);

            if (this.fps != null)
            {
                                  
                                               
                    
                                                             
                              
                    

                siMain = GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex);
                siMain.SwitchLock();

                               
                for (int iCol = siMain.GetColumnIndex(DefColumns.MEASURE); iCol <= siMain.GetMaxColumnIndex(); iCol++)
                {
                    if (cboBucketType.ControlValues == BucketType.Monthly)
                    {
                        if (siMain.GetColumnTag(iCol).IndexOf("M_") != 0)
                            siMain.LockColumn(iCol, iCol, true);
                        else
                        {
                            if (sDivision == "40" && valid_YN == "Y")
                            {
                                if (int.Parse(start_YYYYMM) > int.Parse(siMain.GetColumnTag(iCol).Replace("M_", ""))
                                    || int.Parse(end_YYYYMM) < int.Parse(siMain.GetColumnTag(iCol).Replace("M_", "")))
                                {
                                    siMain.LockColumn(iCol, iCol, true);
                                }
                            }
                        }
                    }
                    else if (cboBucketType.ControlValues == BucketType.Quarterly)
                    {
                        if (siMain.GetColumnTag(iCol).IndexOf("Q_") != 0)
                            siMain.LockColumn(iCol, iCol, true);
                        else
                        {
                            if (sDivision == "40" && valid_YN == "Y" && start_YYYYQQ != "" && end_YYYYQQ != "")
                            {
                                if (int.Parse(start_YYYYQQ) > int.Parse(siMain.GetColumnTag(iCol).Replace("Q_", "").Replace("_", ""))
                                    || int.Parse(end_YYYYQQ) < int.Parse(siMain.GetColumnTag(iCol).Replace("Q_", "").Replace("_", "")))
                                {
                                    siMain.LockColumn(iCol, iCol, true);
                                }
                            }
                            else
                            {
                                siMain.LockColumn(iCol, iCol, true);
                            }
                        }
                    }
                    else if (cboBucketType.ControlValues == BucketType.Yearly)
                    {
                        if (siMain.GetColumnTag(iCol).IndexOf("Y_") != 0)
                            siMain.LockColumn(iCol, iCol, true);
                        else
                        {
                            if (sDivision == "40" && valid_YN == "Y" && start_YYYY != "" && end_YYYY != "")
                            {
                                if (int.Parse(start_YYYY) > int.Parse(siMain.GetColumnTag(iCol).Replace("Y_", ""))
                                    || int.Parse(end_YYYY) < int.Parse(siMain.GetColumnTag(iCol).Replace("Y_", "")))
                                {
                                    siMain.LockColumn(iCol, iCol, true);
                                }
                            }
                            else
                            {
                                siMain.LockColumn(iCol, iCol, true);
                            }
                        }
                    }
                }

                for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
                {
                                                                                                                    
                                                                                                                     
                                                                                                          

                    string sEdit = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EDIT_FLAG)).ToString();
                    string sMeasure = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString();

                    siMain.LockRange(iRow, 0, iRow, siMain.GetColumnIndex(DefColumns.MEASURE), true);

                                                                  
                                                                                                             
                                                                                                                 
                                                                                                                 
                                                                                                                 
                                
                        
                                                                                                                                                         
                                                                                                                                                         
                        
                           
                        
                                                                                 
                                                                                                                                                            
                                                                                 
                                                                                                                                                            
                        


                    if ((sEdit == CAppSetting.StringY) && ((sMeasure == "Business_Plan") || (sMeasure == "LOC")))
                    {
                        for (int iColumn = siMain.GetColumnIndex(DefColumns.MEASURE) + 1; iColumn <= siMain.GetMaxColumnIndex(); iColumn++)
                        {
                                                                            
                            Int32 iValue = Convert.ToInt32(siMain.GetColumnTag(iColumn).Substring(2, 4));
                            Int32 iThisYear = DateTime.Now.Year;
                                                                   
                            if (iThisYear > iValue)
                                    
                                siMain.LockRange(iRow, iColumn, iRow, iColumn, true);
                                
                                   
                                                                                    
                        }
                    }
                    else
                    {
                        siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetMaxColumnIndex(), true);
                    }


                                                  
                    if (!IsEditMode)
                        siMain.LockRange(iRow, 0, iRow, siMain.GetColumnIndex(DefColumns.MEASURE), true);
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

                string[] sPeriod = drpPeriod.ControlValues.Split(':');

                if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1]))
                {
                    MessageHelper.GMessageBox("MSG00108");
                    return;
                }

                if (drpPeriod.Value1.AddYears(6) < drpPeriod.Value2)
                {
                    MessageHelper.GMessageBox("MSG00276");
                    drpPeriod.Value2 = drpPeriod.Value1.AddYears(6);
                    return;
                }

                System.DateTime thisWeekDate;
                string sNowDate = GetThisWeekMonday(out thisWeekDate);
                if (drpPeriod.Value1.CompareTo(thisWeekDate) >= 0)
                    sNowDate = sPeriod[0];
                if (drpPeriod.Value2.CompareTo(thisWeekDate) <= 0)
                    sNowDate = Convert.ToDateTime(drpPeriod.Value2).AddDays(1).ToString("yyyyMMdd");

                InitSpread();

                prg.Show();

                var asyncProxy = new FoxAsyncProxy(this);
                asyncProxy.ShowProgress = false;

                                 
                SearchStartTime();

                                     

                var ds = await asyncProxy.ExecuteAsync<DataSet>(() =>
                {
                    using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
                    {
                        var request = new FoxDataRequest("DM.DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA");

                        request.CommandTimeout = 30 * 60;

                        request.Parameters["p_division_id"] = sDivision;
                        request.Parameters["p_dept_id"] = clbTeam.ControlValues;
                        request.Parameters["p_end_customer"] = clbCustomer.ControlValues;
                        request.Parameters["p_scm_site_id"] = clbSalesSite.ControlValues;
                        request.Parameters["p_project_code"] = txtProject.Text;
                        request.Parameters["p_item_id"] = txtItemId.Text;
                        request.Parameters["p_item_type"] = clbItemType.ControlValues;
                        request.Parameters["p_from_yyyymmdd"] = sPeriod[0];
                        request.Parameters["p_now_yyyymmdd"] = sNowDate;
                        request.Parameters["p_to_yyyymmdd"] = sPeriod[1];
                        request.Parameters["p_created_by"] = base.UserInfo.UserId;
                        request.Parameters["p_plant_site_id"] = clbPlantSite.ControlValues;
                        request.Parameters["p_biztype"] = clbBizType.ControlValues;
                        request.Parameters["p_userinfo"] = UserInfoContext.Current["NowGroupID"].ToString();
                        request.Parameters["p_owner"] = txtOwner.Text.Trim();
                        request.Parameters["p_qty_yn"] = (cboQty.Checked == true) ? "Y" : "N";

                        var response = client.ExecuteDataSet(request);

                        return response.DataSet;
                                                 
                    }
                });

                siMain.Query(ds.Tables[0].DataSet);
                siMain.LockColumn(0, siMain.GetMaxColumnIndex(), true);

                if (ds.Tables[1].Rows.Count > 0)
                {
                    valid_YN = ds.Tables[1].Rows[0]["VALID_YN"].ToString();
                    start_YYYYQQ = ds.Tables[1].Rows[0]["START_YYYYQQ"].ToString();
                    end_YYYYQQ = ds.Tables[1].Rows[0]["END_YYYYQQ"].ToString();
                    start_YYYYMM = ds.Tables[1].Rows[0]["START_YYYYMM"].ToString();
                    end_YYYYMM = ds.Tables[1].Rows[0]["END_YYYYMM"].ToString();
                    start_YYYY = ds.Tables[1].Rows[0]["START_YYYY"].ToString();
                    end_YYYY = ds.Tables[1].Rows[0]["END_YYYY"].ToString();
                }

                siMain.SmartColMerge();

                                              
                SearchEndTime();

                siMain.SpreadObject.SuspendLayout();
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

        private async void SaveData()
        {
            if (siMain != null && siMain.IsLock(siMain.SheetName) == false)
            {
                if (siMain.SheetName == SpdSheet.shtMain)
                {
                                      
                    if (MinColumnChk() == false)
                    {
                        MessageHelper.GMessageBox("MSG00113");
                        return;
                    }

                    string pAction = "";
                    string pDivision = "";
                    string pProjectCode = "";
                    string pProjectName = "";
                    string pScm_Site_Id = "";
                    string pItem_Id = "";
                                            
                    string pFcst_Type = "";
                    string pIncoterms = "";
                    string pCurrency = "";
                    string pMeasure = "";
                    string pPlant_Site_Id = "";
                    string pYyyyMM = "";
                    string pInput = "";
                    string pUserID = "";
                    string pCell_Prod_Site = "";

                                      
                    string p_DEPT_ID = "";
                    string p_END_CUSTOMER = "";
                    string p_BIZ_TYPE = "";
                                                   
                                                     
                                                     

                                         
                    string p_ITEM_USE = "";
                    string p_UNIT_ENERGY = "";

                    int iCount = 0;
                    int iLOCRow = 0;                               

                    for (int i = 0; i < siMain.GetMaxRowIndex() - 1; i += dtMeasure.Rows.Count)
                    {
                                            
                        for (int k = i; k < i + dtMeasure.Rows.Count; k++)
                        {
                            if ((string)siMain.GetValue(k, siMain.GetColumnIndex(DefColumns.MEASURE)) == "LOC")
                            {
                                iLOCRow = k;
                                break;
                            }
                        }

                        string action = siMain.GetText(i, siMain.GetColumnIndex(CAppSetting.StringAction));
                        string action2 = siMain.GetText(iLOCRow, siMain.GetColumnIndex(CAppSetting.StringAction));

                        string sMeasure = (string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MEASURE));

                        if ((action != CAppSetting.FlagI) && (action != CAppSetting.FlagM) && (action2 != CAppSetting.FlagI) && (action2 != CAppSetting.FlagM))
                            continue;

                        if ((sMeasure != "Business_Plan") && (sMeasure != "LOC") && (sMeasure != "MKT_FCST"))
                            continue;
                        string strYYMM = "";
                        string strQty = "";

                                                                                         
                        for (int j = siMain.GetColumnIndex(DefColumns.MEASURE) + 1; j <= siMain.GetMaxColumnIndex(); j++)
                        {
                            if (siMain.GetColumnTag(j).IndexOf("Q_") >= 0 || siMain.GetColumnTag(j).IndexOf("Y_") >= 0)
                                continue;

                            if ((siMain.GetText(i, j) == "") && (siMain.GetText(iLOCRow, j) == ""))
                                continue;

                            var vColor = GetCellColor(siMain, i, j, i, j);
                            var vColor2 = GetCellColor(siMain, iLOCRow, j, iLOCRow, j);
                            if ((vColor != System.Drawing.Color.Red) && (vColor2 != System.Drawing.Color.Red)
                                && strYYMM != "")
                                continue;

                                                  
                            if (i != iLOCRow)
                            {
                                pAction = pAction + "^" + ((action == "") ? action2 : action);
                                pDivision = ParameterString(DefColumns.DIVISION_ID, pDivision, i);
                                pMeasure = ParameterString(DefColumns.MEASURE, pMeasure, i);
                                pCurrency = ParameterString(DefColumns.CURRENCY, pCurrency, i);

                                                                               
                                pPlant_Site_Id = ParameterString(DefColumns.PLANT_SITE_ID, pPlant_Site_Id, i);

                                if ((string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)) == "40")
                                {
                                                    
                                    if ((siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)).ToString() == "")
                                                                                                                                                                       
                                        || (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)).ToString() == "")
                                        || (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40)).ToString() == "")
                                        || (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_ID40)).ToString() == "")
                                        || (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CURRENCY)).ToString() == "")
                                        || (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.FCST_TYPE)).ToString() == "")
                                        || (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.INCOTERMS)).ToString() == "")
                                        || (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE)).ToString() == "")
                                                                                                                              
                                        )
                                    {
                                        MessageHelper.GMessageBox("MSG00310");
                                        return;
                                    }

                                    pProjectCode = ParameterString(DefColumns.END_CUSTOMER40, pProjectCode, i);
                                                                                                   
                                    pFcst_Type = ParameterString(DefColumns.FCST_TYPE, pFcst_Type, i);
                                    pIncoterms = ParameterString(DefColumns.INCOTERMS, pIncoterms, i);
                                    pScm_Site_Id = ParameterString(DefColumns.SCM_SITE_ID40, pScm_Site_Id, i);
                                    pItem_Id = ParameterString(DefColumns.ITEM_ID40, pItem_Id, i);

                                    p_DEPT_ID = ParameterString(DefColumns.DEPT_ID40, p_DEPT_ID, i);
                                    p_END_CUSTOMER = ParameterString(DefColumns.END_CUSTOMER40, p_END_CUSTOMER, i);
                                    p_BIZ_TYPE = ParameterString(DefColumns.BIZ_TYPE_NAME40, p_BIZ_TYPE, i);
                                }
                                else if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString().Substring(0, 2) == "81")
                                {
                                                    
                                    if ((siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString() == "")
                                        || (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DEPT_ID)).ToString() == "")
                                        || (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID81)).ToString() == "")
                                        || (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID)).ToString() == "")
                                        || (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() == "")
                                        || (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.END_CUSTOMER)).ToString() == "")
                                        || (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.FCST_TYPE)).ToString() == "")
                                        || (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.INCOTERMS)).ToString() == "")
                                                                                                                              
                                        || (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CURRENCY)).ToString() == "")
                                        )

                                    {
                                        MessageHelper.GMessageBox("MSG00310");
                                        return;
                                    }

                                    pProjectCode = ParameterString(DefColumns.PROJECT_CODE, pProjectCode, i);
                                    p_DEPT_ID = ParameterString(DefColumns.DEPT_ID, p_DEPT_ID, i);
                                    pScm_Site_Id = ParameterString(DefColumns.SCM_SITE_ID81, pScm_Site_Id, i);
                                    pItem_Id = ParameterString(DefColumns.ITEM_ID, pItem_Id, i);
                                    p_END_CUSTOMER = ParameterString(DefColumns.END_CUSTOMER, p_END_CUSTOMER, i);
                                    pFcst_Type = ParameterString(DefColumns.FCST_TYPE, pFcst_Type, i);
                                    pIncoterms = ParameterString(DefColumns.INCOTERMS, pIncoterms, i);
                                                                                                   


                                                                                                      
                                    p_BIZ_TYPE = ParameterString(DefColumns.BIZ_TYPE_NAME81, p_BIZ_TYPE, i);
                                }
                                else
                                {
                                                    
                                    if ((siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DEPT_ID)).ToString() == "")
                                        || (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CURRENCY)).ToString() == "")
                                        || (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.UNIT_ENERGY)).ToString() == ""))
                                    {
                                        MessageHelper.GMessageBox("MSG00310");
                                        return;
                                    }


                                    pProjectCode = ParameterString(DefColumns.PROJECT_CODE82, pProjectCode, i);
                                                                                                   
                                    pFcst_Type = ParameterString(DefColumns.FCST_TYPE, pFcst_Type, i);
                                                                                                           
                                    pScm_Site_Id = ParameterString(DefColumns.SCM_SITE_ID82, pScm_Site_Id, i);
                                    pItem_Id = ParameterString(DefColumns.ITEM_ID, pItem_Id, i);

                                    p_DEPT_ID = ParameterString(DefColumns.DEPT_ID, p_DEPT_ID, i);
                                    p_END_CUSTOMER = ParameterString(DefColumns.END_CUSTOMER, p_END_CUSTOMER, i);

                                    p_BIZ_TYPE = ParameterString(DefColumns.BIZ_TYPE_NAME82, p_BIZ_TYPE, i);
                                }

                                if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME) >= 0)
                                {
                                    pProjectName = ParameterString(DefColumns.PROJECT_NAME, pProjectName, i);
                                }
                                if (siMain.GetColumnIndex(DefColumns.ITEM_USE) >= 0)
                                {
                                    p_ITEM_USE = ParameterString(DefColumns.ITEM_USE, p_ITEM_USE, i);
                                }
                                if (siMain.GetColumnIndex(DefColumns.UNIT_ENERGY) >= 0)
                                {
                                    p_UNIT_ENERGY = ParameterString(DefColumns.UNIT_ENERGY, p_UNIT_ENERGY, i);
                                }
                                if (siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE) >= 0)
                                {
                                    pCell_Prod_Site = ParameterString(DefColumns.CELL_PROD_SITE, pCell_Prod_Site, i);
                                }

                                pYyyyMM = pYyyyMM + "^" + siMain.GetColumnTag(j).Replace("M_", "");
                                strQty = (Convert.ToString(siMain.GetValue(i, j)) == "") ? "0" : Convert.ToString(siMain.GetValue(i, j));
                                pInput = pInput + "^" + strQty;
                                pUserID = pUserID + "^" + base.UserInfo.UserId;
                            }

                                       
                            pAction = pAction + "^" + ((action == "") ? action2 : action);
                            pDivision = ParameterString(DefColumns.DIVISION_ID, pDivision, i);
                            pMeasure = ParameterString(DefColumns.MEASURE, pMeasure, iLOCRow);
                            pCurrency = ParameterString(DefColumns.CURRENCY, pCurrency, i);

                            if ((string)siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)) == "40")
                            {
                                pProjectCode = ParameterString(DefColumns.END_CUSTOMER40, pProjectCode, i);
                                                                                               
                                pFcst_Type = ParameterString(DefColumns.FCST_TYPE, pFcst_Type, i);
                                pIncoterms = ParameterString(DefColumns.INCOTERMS, pIncoterms, i);
                                pScm_Site_Id = ParameterString(DefColumns.SCM_SITE_ID40, pScm_Site_Id, i);
                                pItem_Id = ParameterString(DefColumns.ITEM_ID40, pItem_Id, i);

                                p_DEPT_ID = ParameterString(DefColumns.DEPT_ID40, p_DEPT_ID, i);
                                p_END_CUSTOMER = ParameterString(DefColumns.END_CUSTOMER40, p_END_CUSTOMER, i);
                                p_BIZ_TYPE = ParameterString(DefColumns.BIZ_TYPE_NAME40, p_BIZ_TYPE, i);
                            }
                            else if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString().Substring(0, 2) == "81")
                            {
                                pProjectCode = ParameterString(DefColumns.PROJECT_CODE, pProjectCode, i);
                                p_DEPT_ID = ParameterString(DefColumns.DEPT_ID, p_DEPT_ID, i);
                                pScm_Site_Id = ParameterString(DefColumns.SCM_SITE_ID81, pScm_Site_Id, i);
                                pPlant_Site_Id = ParameterString(DefColumns.PLANT_SITE_ID, pPlant_Site_Id, i);
                                pItem_Id = ParameterString(DefColumns.ITEM_ID, pItem_Id, i);
                                p_END_CUSTOMER = ParameterString(DefColumns.END_CUSTOMER, p_END_CUSTOMER, i);
                                pFcst_Type = ParameterString(DefColumns.FCST_TYPE, pFcst_Type, i);
                                pIncoterms = ParameterString(DefColumns.INCOTERMS, pIncoterms, i);
                                                                                               

                                p_BIZ_TYPE = ParameterString(DefColumns.BIZ_TYPE_NAME81, p_BIZ_TYPE, i);
                            }
                            else
                            {

                                pProjectCode = ParameterString(DefColumns.PROJECT_CODE82, pProjectCode, i);
                                                                                               
                                pFcst_Type = ParameterString(DefColumns.FCST_TYPE, pFcst_Type, i);
                                                                                                       
                                pScm_Site_Id = ParameterString(DefColumns.SCM_SITE_ID82, pScm_Site_Id, i);
                                pItem_Id = ParameterString(DefColumns.ITEM_ID, pItem_Id, i);

                                p_END_CUSTOMER = ParameterString(DefColumns.END_CUSTOMER, p_END_CUSTOMER, i);

                                p_BIZ_TYPE = ParameterString(DefColumns.BIZ_TYPE_NAME82, p_BIZ_TYPE, i);

                                p_DEPT_ID = ParameterString(DefColumns.DEPT_ID, p_DEPT_ID, i);

                            }

                            pProjectName = ParameterString(DefColumns.PROJECT_NAME, pProjectName, i);
                                                                                                              

                                                                                                               
                                                                                                                     
                                                                                                                     

                                                                     
                            p_ITEM_USE = ParameterString(DefColumns.ITEM_USE, p_ITEM_USE, i);
                            p_UNIT_ENERGY = ParameterString(DefColumns.UNIT_ENERGY, p_UNIT_ENERGY, i);
                            pPlant_Site_Id = ParameterString(DefColumns.PLANT_SITE_ID, pPlant_Site_Id, i);
                            pCell_Prod_Site = ParameterString(DefColumns.CELL_PROD_SITE, pCell_Prod_Site, i);

                            pYyyyMM = pYyyyMM + "^" + siMain.GetColumnTag(j).Replace("M_", "");
                            strQty = (Convert.ToString(siMain.GetValue(iLOCRow, j)) == "") ? "0" : Convert.ToString(siMain.GetValue(iLOCRow, j));
                            pInput = pInput + "^" + strQty;
                            pUserID = pUserID + "^" + base.UserInfo.UserId;

                                          
                            strYYMM = siMain.GetColumnTag(j).Replace("M_", "");

                            iCount++;
                        }
                        iLOCRow = 0;
                    }

                    if (iCount == 0)
                    {
                        MessageHelper.GMessageBox("MSG00275");
                        return;
                    }

                    if (fnValidation() == false)
                    {
                        MessageHelper.GMessageBox("MSG00043");                          
                        return;
                    }

                    string sRet = string.Empty;

                    using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
                    {
                        var request = new FoxDataRequest("DM.DMF0042_SAVE_DM_PLN_BP_FCST");
                        request.Parameters["p_active_flag"] = pAction.Remove(0, 1);
                        request.Parameters["p_DIVISION_ID"] = pDivision.Remove(0, 1);
                        request.Parameters["p_PROJECT_CODE"] = pProjectCode.Remove(0, 1);
                        request.Parameters["p_PROJECT_NAME"] = pProjectName.Remove(0, 1);
                        request.Parameters["p_SCM_SITE_ID"] = pScm_Site_Id.Remove(0, 1);
                        request.Parameters["p_PLANT_SITE_ID"] = pPlant_Site_Id.Remove(0, 1);
                        request.Parameters["p_ITEM_ID"] = pItem_Id.Remove(0, 1);
                                                                                   
                        request.Parameters["p_FCST_TYPE"] = pFcst_Type.Remove(0, 1);
                        request.Parameters["p_INCOTERMS"] = pIncoterms.Remove(0, 1);
                        request.Parameters["p_MEASURE"] = pMeasure.Remove(0, 1);
                        request.Parameters["p_YYYYMM"] = pYyyyMM.Remove(0, 1);
                        request.Parameters["p_QTY"] = pInput.Remove(0, 1);
                        request.Parameters["p_CURRENCY"] = pCurrency.Remove(0, 1);

                                          
                        request.Parameters["p_DEPT_ID"] = p_DEPT_ID.Remove(0, 1);
                        request.Parameters["p_END_CUSTOMER"] = p_END_CUSTOMER.Remove(0, 1);
                        request.Parameters["p_BIZ_TYPE"] = p_BIZ_TYPE.Remove(0, 1);
                                                                                                
                                                                                                    
                                                                                                    

                                                                 
                        request.Parameters["p_ITEM_USE"] = p_ITEM_USE.Remove(0, 1);
                        request.Parameters["p_UNIT_ENERGY"] = p_UNIT_ENERGY.Remove(0, 1);
                        request.Parameters["p_CELL_PROD_SITE"] = pCell_Prod_Site.Remove(0, 1);

                        request.Parameters["p_CREATED_BY"] = pUserID.Remove(0, 1);
                        request.Parameters["p_LAST_UPDATED_BY"] = pUserID.Remove(0, 1);

                        sRet = client.ExecuteDataSet(request).DataSet.Tables[0].Rows[0][0].ToString();
                    }

                    if (sRet != "success")
                    {
                        MessageBox.Show(sRet, "Error!");
                        return;
                    }
                    else
                    {
                        MessageHelper.GMessageBox("MSG00004", new object[] { iCount });
                    }
                    FindData();
                }
            }
        }

        private void InsertRow()
        {
            if (siMain != null && siMain.IsLock(siMain.SheetName) == false)
            {
                if (siMain.SheetName == SpdSheet.shtMain)
                {
                    int[] iArray = GetCellNumbersByRow(siMain.ActiveRowIndex);
                    siMain.SpreadObject.ActiveSheet.SetActiveCell(iArray[0], 2);

                    FarPoint.Win.Spread.Cell insCell = siMain.Insert(dtMeasure.Rows.Count);

                    string sDivision = clbDivision.SelectedValue.ToString();
                    string sTeam = "";
                    DataTable dtBizType81 = GetLookupData("DM_BIZ_TYPE_81");

                    if (sDivision == "40")
                    {
                                    
                                                                                                                                  
                                                                                                                                                                                
                    }
                    else
                        dtCustomer = Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "");

                                   
                    if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) != -1)
                        siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType = cellTypeImage;
                    if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE82) != -1)
                        siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)].CellType = cellTypeImage;
                    if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                        siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType = cellTypeImage;
                    if (siMain.GetColumnIndex(DefColumns.ITEM_ID40) != -1)
                        siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID40)].CellType = cellTypeImage;
                    if (siMain.GetColumnIndex(DefColumns.CURRENCY) != -1)
                        siMain.SetCellTypeCombo(insCell.Row.Index, siMain.GetColumnIndex(DefColumns.CURRENCY), dtCurrencyList);

                                 
                    DataTable dtSalesSiteAuth = (sDivision == "40") ? Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "")
                        : Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "");

                    DataTable dtTeamAuth = null;
                    dtTeamAuth = Data.UserTeamByDivisionAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision);

                    if (sDivision == "40" && siMain.GetColumnIndex(DefColumns.DEPT_ID40) != -1)
                        siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DEPT_ID40), dtTeamAuth);
                    if (sDivision != "40" && siMain.GetColumnIndex(DefColumns.DEPT_ID) != -1)
                        siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeamAuth);
                    if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER) != -1)
                        siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtCustomer);
                    if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER40) != -1)
                        siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), dtCustomer);
                    if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40) != -1)
                        siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40), dtSalesSiteAuth);
                    if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID81) != -1)
                        siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID81), dtSalesSiteAuth);
                    if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID82) != -1)
                        siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID82), dtSalesSiteAuth);
                    if (siMain.GetColumnIndex(DefColumns.CURRENCY) != -1)
                        siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CURRENCY), dtCurrencyList);
                    if (siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME81) != -1)
                        siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME81), dtBizType81);

                                                                                                            
                    if (sDivision == "40" && siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE) != -1)
                    {
                                                                        
                        siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE), GetCellProdSite("DM_CELL_PROD_SITE", "Y"));
                    }

                                 
                    for (int i = 0; i <= dtMeasure.Rows.Count - 1; i++)
                    {
                        int iRowNo = siMain.ActiveRowIndex + i;

                        siMain.SetText(iRowNo, siMain.GetColumnIndex(DefColumns.DIVISION_ID), clbDivision.ControlValues);
                        siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRowNo, siMain.GetColumnIndex(DefColumns.DIVISION_ID), true);

                                                 
                            
                                                                               
                                                                                                                                                           
                        if ((sDivision == "40") && (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) != -1))
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), iRowNo, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), true);
                                                                                    
                                                                                                                                                                      
                        if (siMain.GetColumnIndex(DefColumns.CUST_GROUP) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.CUST_GROUP), iRowNo, siMain.GetColumnIndex(DefColumns.CUST_GROUP), true);
                        if (siMain.GetColumnIndex(DefColumns.CUST_GROUP_DTL) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.CUST_GROUP_DTL), iRowNo, siMain.GetColumnIndex(DefColumns.CUST_GROUP_DTL), true);
                        if (siMain.GetColumnIndex(DefColumns.OWNER) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.OWNER), iRowNo, siMain.GetColumnIndex(DefColumns.OWNER), true);
                        if (siMain.GetColumnIndex(DefColumns.APPLICATION) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.APPLICATION), iRowNo, siMain.GetColumnIndex(DefColumns.APPLICATION), true);
                        if (siMain.GetColumnIndex(DefColumns.ROUTE) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.ROUTE), iRowNo, siMain.GetColumnIndex(DefColumns.ROUTE), true);
                                                                                       
                                                                                                                                                                            
                        if (siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME82) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME82), iRowNo, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME82), true);
                        if (siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME40) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME40), iRowNo, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME40), true);
                        if (siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), iRowNo, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), true);
                        if (siMain.GetColumnIndex(DefColumns.ITEM_NAME) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.ITEM_NAME), iRowNo, siMain.GetColumnIndex(DefColumns.ITEM_NAME), true);
                        if (siMain.GetColumnIndex(DefColumns.ITEM_TYPE) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), iRowNo, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), true);
                        if (siMain.GetColumnIndex(DefColumns.NICK_NAME) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.NICK_NAME), iRowNo, siMain.GetColumnIndex(DefColumns.NICK_NAME), true);
                        if (sDivision != null && sDivision != "")
                        {
                            if ((sDivision.Substring(0, 2) != "81") && (siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID) != -1))
                                siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), iRowNo, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), true);
                        }
                        if (siMain.GetColumnIndex(DefColumns.VERSION_NO) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.VERSION_NO), iRowNo, siMain.GetColumnIndex(DefColumns.VERSION_NO), true);
                        if (siMain.GetColumnIndex(DefColumns.FORECAST_INFO_PRODUCT_GROUP) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_PRODUCT_GROUP), iRowNo, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_PRODUCT_GROUP), true);
                        if (siMain.GetColumnIndex(DefColumns.FORECAST_INFO_CELL_PACK_COUNT) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_CELL_PACK_COUNT), iRowNo, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_CELL_PACK_COUNT), true);
                        if (siMain.GetColumnIndex(DefColumns.PRODUCT_GROUP_NAME) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.PRODUCT_GROUP_NAME), iRowNo, siMain.GetColumnIndex(DefColumns.PRODUCT_GROUP_NAME), true);
                        if (siMain.GetColumnIndex(DefColumns.SHIPTO_DESCRIPTION) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.SHIPTO_DESCRIPTION), iRowNo, siMain.GetColumnIndex(DefColumns.SHIPTO_DESCRIPTION), true);
                        if (siMain.GetColumnIndex(DefColumns.CELL_TYPE) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.CELL_TYPE), iRowNo, siMain.GetColumnIndex(DefColumns.CELL_TYPE), true);
                        if (siMain.GetColumnIndex(DefColumns.INTERNAL_YN) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.INTERNAL_YN), iRowNo, siMain.GetColumnIndex(DefColumns.INTERNAL_YN), true);
                        if (siMain.GetColumnIndex(DefColumns.COUNTRY_NAME) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.COUNTRY_NAME), iRowNo, siMain.GetColumnIndex(DefColumns.COUNTRY_NAME), true);
                        if (siMain.GetColumnIndex(DefColumns.CITY_NAME) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.CITY_NAME), iRowNo, siMain.GetColumnIndex(DefColumns.CITY_NAME), true);
                        if (siMain.GetColumnIndex(DefColumns.FORECAST_INFO_CELL_MODEL) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_CELL_MODEL), iRowNo, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_CELL_MODEL), true);
                        if (siMain.GetColumnIndex(DefColumns.FORECAST_INFO_SPEC) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_SPEC), iRowNo, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_SPEC), true);
                        if (siMain.GetColumnIndex(DefColumns.MDM_PROJECT_NAME) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.MDM_PROJECT_NAME), iRowNo, siMain.GetColumnIndex(DefColumns.MDM_PROJECT_NAME), true);
                        if (siMain.GetColumnIndex(DefColumns.MIN_CAPACITY) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.MIN_CAPACITY), iRowNo, siMain.GetColumnIndex(DefColumns.MIN_CAPACITY), true);
                        if (siMain.GetColumnIndex(DefColumns.VMI_YN) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.VMI_YN), iRowNo, siMain.GetColumnIndex(DefColumns.VMI_YN), true);
                                                                                     
                                                                                                                                                                        
                                                                                       
                                                                                                                                                                            
                                                                                       
                                                                                                                                                                            
                        if (siMain.GetColumnIndex(DefColumns.PRIORITY) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.PRIORITY), iRowNo, siMain.GetColumnIndex(DefColumns.PRIORITY), true);
                        if (siMain.GetColumnIndex(DefColumns.DMS_SALES) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.DMS_SALES), iRowNo, siMain.GetColumnIndex(DefColumns.DMS_SALES), true);
                        if (siMain.GetColumnIndex(DefColumns.DMS_CUSTOMER) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.DMS_CUSTOMER), iRowNo, siMain.GetColumnIndex(DefColumns.DMS_CUSTOMER), true);
                        if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP1) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP1), iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP1), true);
                        if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP2) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP2), iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP2), true);
                        if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP3) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP3), iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP3), true);
                        if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP4) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP4), iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP4), true);
                        if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP5) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP5), iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP5), true);
                        if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP6) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP6), iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP6), true);
                        if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP7) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP7), iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP7), true);
                        if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP8) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP8), iRowNo, siMain.GetColumnIndex(DefColumns.REPORT_GROUP8), true);
                        if (siMain.GetColumnIndex(DefColumns.EDIT_FLAG) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.EDIT_FLAG), iRowNo, siMain.GetColumnIndex(DefColumns.EDIT_FLAG), true);

                                                                            
                        if (siMain.GetColumnIndex(DefColumns.CELL_PER_CAR) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.CELL_PER_CAR), iRowNo, siMain.GetColumnIndex(DefColumns.CELL_PER_CAR), true);
                        if (siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR) != -1)
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), iRowNo, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), true);

                        string sMeasure = dtMeasure.Rows[i]["CODE"].ToString();
                        siMain.SetText(iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE), dtMeasure.Rows[i]["NAME"].ToString());
                        siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE), iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE), true);
                        SetCellColor(siMain, iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE), iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE));

                        if ((sMeasure == "KRW") || (sMeasure == "USD")
                            || (sMeasure == "SalesAmt_KRW") || (sMeasure == "SalesAmt_USD") || (sMeasure == "SalesAmt_LOC")
                            || (sMeasure == "CAR_QTY"))
                        {
                            siMain.LockRange(iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRowNo, siMain.GetMaxColumnIndex(), true);
                        }
                        else
                        {
                                           
                            for (int iCol = siMain.GetColumnIndex(DefColumns.MEASURE); iCol <= siMain.GetMaxColumnIndex(); iCol++)
                            {
                                if (cboBucketType.ControlValues == BucketType.Monthly)
                                {
                                    if (siMain.GetColumnTag(iCol).IndexOf("M_") != 0)
                                        siMain.LockRange(iRowNo, iCol, iRowNo, iCol, true);
                                    else
                                    {
                                        if (sDivision == "40" && valid_YN == "Y")
                                        {
                                            if (int.Parse(start_YYYYMM) > int.Parse(siMain.GetColumnTag(iCol).Replace("M_", ""))
                                                || int.Parse(end_YYYYMM) < int.Parse(siMain.GetColumnTag(iCol).Replace("M_", "")))
                                            {
                                                siMain.LockRange(iRowNo, iCol, iRowNo, iCol, true);
                                            }
                                        }
                                    }
                                }
                                else if (cboBucketType.ControlValues == BucketType.Quarterly)
                                {
                                    if (siMain.GetColumnTag(iCol).IndexOf("Q_") != 0)
                                        siMain.LockRange(iRowNo, iCol, iRowNo, iCol, true);
                                    else
                                    {
                                        if (sDivision == "40" && valid_YN == "Y" && start_YYYYQQ != "" && end_YYYYQQ != "")
                                        {
                                            if (int.Parse(start_YYYYQQ) > int.Parse(siMain.GetColumnTag(iCol).Replace("Q_", "").Replace("_", ""))
                                                || int.Parse(end_YYYYQQ) < int.Parse(siMain.GetColumnTag(iCol).Replace("Q_", "").Replace("_", "")))
                                            {
                                                siMain.LockRange(iRowNo, iCol, iRowNo, iCol, true);
                                            }
                                        }
                                        else
                                        {
                                            siMain.LockRange(iRowNo, iCol, iRowNo, iCol, true);
                                        }
                                    }
                                }
                                else if (cboBucketType.ControlValues == BucketType.Yearly)
                                {
                                    if (siMain.GetColumnTag(iCol).IndexOf("Y_") != 0)
                                        siMain.LockRange(iRowNo, iCol, iRowNo, iCol, true);
                                    else
                                    {
                                        if (sDivision == "40" && valid_YN == "Y" && start_YYYY != "" && end_YYYY != "")
                                        {
                                            if (int.Parse(start_YYYY) > int.Parse(siMain.GetColumnTag(iCol).Replace("Y_", ""))
                                                || int.Parse(end_YYYY) < int.Parse(siMain.GetColumnTag(iCol).Replace("Y_", "")))
                                            {
                                                siMain.LockRange(iRowNo, iCol, iRowNo, iCol, true);
                                            }
                                        }
                                        else
                                        {
                                            siMain.LockRange(iRowNo, iCol, iRowNo, iCol, true);
                                        }
                                    }
                                }

                                if (iCol >= siMain.GetColumnIndex(DefColumns.MEASURE) + 1)
                                {
                                    Int32 iValue = Convert.ToInt32(siMain.GetColumnTag(iCol).Substring(2, 4));
                                    Int32 iThisYear = DateTime.Now.Year;

                                    if (iThisYear > iValue)
                                        siMain.LockRange(iRowNo, iCol, iRowNo, iCol, true);
                                }
                            }
                        }
                    }

                    CUIControl.SetRowSpanFuc(siMain, siMain.ActiveRowIndex, dtMeasure.Rows.Count - 1, 1, siMain.GetColumnIndex(DefColumns.MEASURE), FarPoint.Win.Spread.CellHorizontalAlignment.Left, FarPoint.Win.Spread.CellVerticalAlignment.Center);


                }
            }
        }

        #endregion

        #region 6. Event
        private void cboDivision_SelectedIndexChanged(object sender, EventArgs e)
        {
            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);
            string sEndCustomer = string.Empty;

            InitSpread();
            InitSaveDataTable();

            dtTeam = Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision);
            clsCtrl.setListBox(dtTeam, clbTeam, true);

            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);

            if (sDivision != null & sDivision != "")
            {
                if (sDivision == "40")
                {
                    dtBizType = Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "");
                    clsCtrl.setListBox(dtBizType, clbBizType, true);

                    dtCustomer = Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);

                    lblProject.Enabled = false;
                    lblPlantSite.Enabled = false;
                    btnProject.Enabled = false;
                    dtMeasure = Data.Common(Data.Type.DMF0042_BP_Measure, false, "40", "", "", "");
                }
                else if (sDivision.Substring(0, 2) == "81")
                {
                    dtBizType = GetBizTypebyDivision(sDivision);
                    clsCtrl.setListBox(dtBizType, clbBizType, true);

                    dtCustomer = Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam);

                    lblProject.Enabled = true;
                    lblPlantSite.Enabled = true;
                    btnProject.Enabled = true;

                    dtMeasure = Data.Common(Data.Type.DMF0042_BP_Measure, false, sDivision, "", "", "");
                }
                else
                {
                    dtBizType = GetBizTypebyDivision(sDivision);
                    clsCtrl.setListBox(dtBizType, clbBizType, true);

                    dtCustomer = Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam);

                    lblProject.Enabled = true;
                    lblPlantSite.Enabled = true;
                    btnProject.Enabled = true;

                    dtMeasure = Data.Common(Data.Type.DMF0042_BP_Measure, false, "82", "", "", "");
                }
            }

            lblBizType.Enabled = true;

            clsCtrl.setListBox(dtCustomer, clbCustomer, true);
            sEndCustomer = CString.GetCheckedListValue(dtCustomer, clbCustomer.ControlValues);

            dtSalesSite = Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
            clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);

            dtPlantSite = Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision);
            clsCtrl.setListBox(dtPlantSite, clbPlantSite, true);

            dtBucketType = GetLookupData("BUCKET2_TYPE_CODE");
            clsCtrl.setListBox(dtBucketType, cboBucketType, false, "CODE", "NAME");

            drpPeriod.InitValue = GetDayRange();

            dtItemType = GetLookupData("ITEM_TYPE_CODE");
            clsCtrl.setListBox(dtItemType, clbItemType, true);

            System.Windows.Forms.ToolTip toolTip1 = new System.Windows.Forms.ToolTip();
            toolTip1.SetToolTip(btnColumn, "Column Show");
            toolTip1.SetToolTip(btnMeasure, "Measure");

            dtCurrencyList = Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);

            layoutControlItem4.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;

            this.txtProject.Text = "";
            this.txtItemId.Text = "";
            this.txtOwner.Text = "";
        }

        private void clbTeam_SelectedIndexChanged(object sender, EventArgs e)
        {
            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);
            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);

            if (sDivision != null && sDivision != "")
            {
                if ((sDivision.Substring(0, 2) == "81") || (sDivision == "82"))
                {
                    dtCustomer = Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam);
                    clsCtrl.setListBox(dtCustomer, clbCustomer, true);
                    string sEndCustomer = CString.GetCheckedListValue(dtCustomer, clbCustomer.ControlValues);
                    dtSalesSite = Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
                }
                else
                {
                    dtCustomer = Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
                    clsCtrl.setListBox(dtCustomer, clbCustomer, true);

                    dtSalesSite = Data.Common(Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam.ControlValues, clbCustomer.ControlValues, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
                }
            }

            clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);
        }

        private void clbCustomer_SelectedIndexChanged(object sender, EventArgs e)
        {

            if ((clbDivision.ControlValues.Substring(0, 2) == "81") || (clbDivision.ControlValues == "82"))
            {
                dtSalesSite = Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.ControlValues, clbCustomer.ControlValues);
            }
            else
            {
                dtSalesSite = Data.Common(Data.Type.SiteByEndCustomer40, false, clbDivision.ControlValues, clbTeam.ControlValues, clbCustomer.ControlValues, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
            }
            clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);
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

        private void spdMain_ComboSelChange(object sender, FarPoint.Win.Spread.EditorNotifyEventArgs e)
        {
            string sDivision = clbDivision.ControlValues;
            if (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40))
            {
                if (sDivision == "40")
                {
                    string sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)).ToString();
                    DataTable dtSalesSite = Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40), dtSalesSite);
                }
            }
            else if (sDivision == "40" && e.Column == siMain.GetColumnIndex(DefColumns.DEPT_ID40))
            {
                if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER40) > 0)
                {
                    string sTeam = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID40)).ToString();
                    if (sTeam == "")
                    {
                        sTeam = clbTeam.ControlValues;
                    }
                    DataTable dtCustomer = Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);


                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), dtCustomer);

                    string sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)).ToString();
                    dtSalesSite = Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40), dtSalesSite);
                }
            }
        }

        private void spdMain_CellDoubleClick(object sender, FarPoint.Win.Spread.CellClickEventArgs e)
        {
            if (e.ColumnHeader)
            {
                if (siMain.GetColumnTag(e.Column).IndexOf("Y_") == 0)
                {
                    for (int iCol = e.Column; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                    {
                        if (siMain.GetColumnTag(iCol).IndexOf("Q_") == 0)
                        {
                            siMain.ActiveSheet.Columns[iCol].Visible = !siMain.ActiveSheet.Columns[iCol].Visible;
                        }
                        else if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                        {
                            if (siMain.ActiveSheet.Columns[iCol].Visible)
                            {
                                siMain.ActiveSheet.Columns[iCol].Visible = !siMain.ActiveSheet.Columns[iCol].Visible;
                            }
                        }

                        if ((siMain.GetMaxColumnIndex() == iCol) || (siMain.GetColumnTag(iCol + 1).IndexOf("Y_") == 0))
                        {
                            break;
                        }
                    }
                }
                else if (siMain.GetColumnTag(e.Column).IndexOf("Q_") == 0)
                {
                    for (int iCol = e.Column; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                    {
                        if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                        {
                            siMain.ActiveSheet.Columns[iCol].Visible = !siMain.ActiveSheet.Columns[iCol].Visible;
                        }

                        if ((siMain.GetMaxColumnIndex() == iCol) || (siMain.GetColumnTag(iCol + 1).IndexOf("Q_") == 0))
                        {
                            break;
                        }
                    }
                }
            }
            else if ((e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))
                || (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID40)))
            {
                if (siMain.IsLock(siMain.SheetName) || siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting.StringI)
                {
                    return;
                }

                string sDivision = "", sTeam = "", sEndCustomer = "", sScmSite = "", sProject = "";
                string sScmSiteId = "", sItemId = "", sItemName = "", sItemType = "", sNickName = "";
                sDivision = clbDivision.ControlValues;                                                                                 
                sTeam = "ALL";                                                                               
                sEndCustomer = "ALL";                                                                                   

                if (siMain.GetColumnIndex(DefColumns.DEPT_ID) > 0)
                    sTeam = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID)).ToString();

                if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) > 0)
                    sProject = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString();
                if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE82) > 0)
                    sProject = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)).ToString();
                if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40) > 0)
                    sScmSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40)).ToString();
                if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID81) > 0)
                    sScmSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID81)).ToString();
                if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID82) > 0)
                    sScmSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID82)).ToString();

                if (siMain.GetColumnIndex(DefColumns.ITEM_ID) > 0)
                    sItemId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString();

                if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER) > 0)
                    sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER)).ToString();
                if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER40) > 0)
                    sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)).ToString();

                DM0002_ItembyDivisionPopupEx popItem = new DM0002_ItembyDivisionPopupEx();

                popItem.Form_Load(false, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId);
                popItem.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                popItem.ShowDialog();

                sItemId = popItem.ItemID;
                sItemName = popItem.ItemName;
                sItemType = popItem.ItemType;
                sNickName = popItem.NickName;

                if (sItemId != "")
                {
                    siMain.SetText(e.Row, e.Column, sItemId);

                    if (siMain.GetColumnIndex(DefColumns.ITEM_ID) > 0)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), sItemId);
                    if (siMain.GetColumnIndex(DefColumns.ITEM_ID40) > 0)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID40), sItemId);
                    if (siMain.GetColumnIndex(DefColumns.ITEM_NAME) > 0)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_NAME), sItemName);
                }
            }
            if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE))
                                                                                 
            {
                string sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                string sTeam = "ALL";
                string sEndCustomer = "ALL";
                string sScmSite = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID81)).ToString();
                string sProject = "";
                if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) > 0)
                    sProject = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString();
                if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE82) > 0)
                    sProject = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)).ToString();
                string sProjectName = string.Empty;
                string sProjectStatus = string.Empty;
                string sBizType = string.Empty;
                string sProjectOwner = string.Empty;

                if (siMain.GetColumnIndex(DefColumns.DEPT_ID) > 0)
                {
                    sTeam = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID)).ToString();
                }

                if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER) > 0)
                {
                    sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER)).ToString();
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

                    if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME) > 0)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), sProjectName);
                    if (siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME81) > 0)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME81), sBizType);

                                                                              
                        
                                                                                                                
                        
                }

            }
            if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE82))
            {
                string sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                string sTeam = "ALL";
                string sEndCustomer = "ALL";
                string sScmSite = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID82)).ToString();
                string sProject = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE82)).ToString();
                string sProjectName = string.Empty;
                string sProjectStatus = string.Empty;
                string sBizType = string.Empty;
                string sProjectOwner = string.Empty;

                if (siMain.GetColumnIndex(DefColumns.DEPT_ID) > 0)
                {
                    sTeam = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID)).ToString();
                }

                if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER) > 0)
                {
                    sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER)).ToString();
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

                    if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME) > 0)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), sProjectName);
                    if (siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME82) > 0)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME82), sBizType);
                }
            }
        }

        protected void spdMain_Changed(object sender, FarPoint.Win.Spread.Model.SheetDataModelEventArgs e)
        {
            if (!this.CanModelChange) return;

                                                                     
            if (e.Column < 0) return;
            if (e.Row < 0) return;

            if (siMain.GetValue(e.Row, e.Column).ToString() == "")
            {
                siMain.SetValue(e.Row, e.Column, "0");
            }

            switch (e.Type)
            {
                case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated:
                    string sBucketType = cboBucketType.ControlValues;
                    string sColName = siMain.GetColumnTag(e.Column);
                    int iStartCol = 0;

                    string sDivision = string.Empty;
                    string sProjectCode = string.Empty;
                    string sSiteId = string.Empty;
                    string sItemId = string.Empty;
                    string sDomExp = string.Empty;
                    string sFcstType = string.Empty;
                                                        
                    string sMeasure = string.Empty;
                    string sPlantSiteId = string.Empty;

                    string sEndCustomer40 = string.Empty;
                    string sScmSiteId40 = string.Empty;
                    string sItem40 = string.Empty;

                    string sAction = string.Empty;

                    if ((e.Row == -1) || (e.Column == -1))
                        return;

                    string[] strValue = siMain.GetValue(e.Row, e.Column).ToString().Split('.');
                    string strCheckMeasure = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString();

                                                             
                    if ((siMain.GetColumnIndex(DefColumns.MEASURE) < e.Column) || (siMain.GetColumnIndex(DefColumns.UNIT_ENERGY) == e.Column))
                    {
                                         
                        var vColor = GetCellColor(siMain, e.Row, e.Column, e.Row, e.Column);
                        if (vColor != System.Drawing.Color.Red)
                            return;

                        if ((strValue.Length > 1) && (strValue[1] != "000") && (strCheckMeasure == "Business_Plan"))
                        {
                            siMain.SetValue(e.Row, e.Column, strValue[0] + ".000");
                            MessageHelper.GMessageBox("MSG00289");
                        }
                    }

                    if (strCheckMeasure == "Business_Plan")
                    {
                        long iQuarterlySum = 0;
                        long iYearlySum = 0;

                        if (sBucketType == BucketType.Monthly && sColName.IndexOf("M_") == 0)
                        {
                                            
                            for (int iCol = e.Column; iCol > 0; iCol--)
                            {
                                if (siMain.GetColumnTag(iCol).IndexOf("Q_") == 0)
                                {
                                    iStartCol = iCol + 1;
                                    break;
                                }
                            }

                            for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                            {
                                if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 && siMain.GetText(e.Row, iCol) != "")
                                {
                                    if (strCheckMeasure == "Business_Plan")
                                        iQuarterlySum = iQuarterlySum + Convert.ToInt64(siMain.GetValue(e.Row, iCol));
                                    else
                                        iQuarterlySum = Convert.ToInt64(siMain.GetValue(e.Row, e.Column));
                                }

                                if (siMain.GetColumnTag(iCol).IndexOf("Y_") == 0 || siMain.GetColumnTag(iCol).IndexOf("Q_") == 0
                                    || siMain.GetMaxColumnIndex() == iCol)
                                {
                                    siMain.SetText(e.Row, iStartCol - 1, iQuarterlySum.ToString());
                                    break;
                                }
                            }

                                         
                            for (int iCol = e.Column; iCol > 0; iCol--)
                            {
                                if (siMain.GetColumnTag(iCol).IndexOf("Y_") == 0)
                                {
                                    iStartCol = iCol + 1;
                                    break;
                                }
                            }

                            for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                            {
                                if (siMain.GetColumnTag(iCol).IndexOf("Q_") == 0 && siMain.GetText(e.Row, iCol) != "")
                                {
                                    if (strCheckMeasure == "Business_Plan")
                                        iYearlySum = iYearlySum + Convert.ToInt64(siMain.GetValue(e.Row, iCol));
                                    else
                                        iYearlySum = 0;                                                                      
                                }

                                if (siMain.GetColumnTag(iCol).IndexOf("Y_") == 0 || siMain.GetMaxColumnIndex() == iCol)
                                {
                                    siMain.SetText(e.Row, iStartCol - 1, iYearlySum.ToString());
                                    break;
                                }
                            }
                        }
                        else if ((sBucketType == BucketType.Quarterly) && sColName.IndexOf("Q_") == 0)
                        {
                            iStartCol = e.Column + 1;
                            if (siMain.GetText(e.Row, e.Column) == "")
                            {
                                iQuarterlySum = 0;
                            }
                            else
                            {
                                iQuarterlySum = Convert.ToInt64(siMain.GetValue(e.Row, e.Column));
                            }

                            long dDaycnt = 0;
                                                     
                                                    

                            long dDailyQty = 0;
                            long dRemnant = 0;
                            bool bWeekAll = false;

                                          
                            for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                            {
                                                                                                                          
                                if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                                {
                                    dDaycnt = dDaycnt + 1;                                                 
                                }

                                if (siMain.GetColumnTag(iCol).IndexOf("Y_") == 0 || siMain.GetColumnTag(iCol).IndexOf("Q_") == 0 || iCol == siMain.GetMaxColumnIndex())
                                {
                                    if (dDaycnt == 0)
                                    {
                                        bWeekAll = true;

                                                                         
                                                              

                                                                                      
                                        dDaycnt = 1;
                                                        
                                    }
                                                                                          
                                    if (strCheckMeasure == "Business_Plan")
                                    {
                                        dDailyQty = iQuarterlySum / dDaycnt;
                                        dRemnant = iQuarterlySum % dDaycnt;
                                    }
                                    else
                                    {
                                        dDailyQty = Convert.ToInt64(iQuarterlySum);
                                        dRemnant = 0;
                                    }
                                    break;
                                }
                            }

                            long iCheck = 0;
                            string sYYYYMMDD = sColName.Replace("M_", "");

                            if (!bWeekAll)
                            {
                                for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                                {
                                    if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                                    {
                                        iCheck++;

                                        if (dDaycnt == iCheck)
                                        {
                                            if (dRemnant > 0)
                                            {
                                                dDailyQty = dDailyQty + dRemnant;
                                            }

                                            siMain.SetText(e.Row, iCol, dDailyQty.ToString());
                                            SetCellColor(siMain, e.Row, iCol, e.Row, iCol);
                                            sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("M_", "");
                                        }
                                        else
                                        {
                                            siMain.SetText(e.Row, iCol, dDailyQty.ToString());
                                            SetCellColor(siMain, e.Row, iCol, e.Row, iCol);
                                            sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("M_", "");
                                        }
                                    }
                                    else if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 && (siMain.GetValue(e.Row, iCol + 1).ToString() == ""))
                                    {
                                        if (dDaycnt == iCheck)
                                        {
                                            if (dRemnant > 0)
                                            {
                                                dDailyQty = dDailyQty + dRemnant;
                                            }

                                            siMain.SetValue(e.Row, iCol, "");
                                            SetCellColor(siMain, e.Row, iCol, e.Row, iCol);
                                            sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("M_", "");
                                        }
                                        else
                                        {
                                            siMain.SetValue(e.Row, iCol, "");
                                            SetCellColor(siMain, e.Row, iCol, e.Row, iCol);
                                            sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("M_", "");
                                        }
                                    }

                                    if (siMain.GetColumnTag(iCol).IndexOf("M") != 0)
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
                                    if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 && siMain.GetText(e.Row, iCol) != "")
                                    {
                                        siMain.SetText(e.Row, iCol, "");
                                        SetCellColor(siMain, e.Row, iCol, e.Row, iCol);
                                        sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("M_", "");
                                    }

                                    if (siMain.GetColumnTag(iCol).IndexOf("M") != 0)
                                    {
                                        break;
                                    }
                                }
                            }

                                         
                            for (int iCol = e.Column; iCol > 0; iCol--)
                            {
                                if (siMain.GetColumnTag(iCol).IndexOf("Y_") == 0)
                                {
                                    iStartCol = iCol + 1;
                                    break;
                                }
                            }

                            for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                            {
                                if (siMain.GetColumnTag(iCol).IndexOf("Q_") == 0 && siMain.GetText(e.Row, iCol) != "")
                                {
                                                                                          
                                    if (strCheckMeasure == "Business_Plan")
                                        iYearlySum = iYearlySum + Convert.ToInt64(siMain.GetValue(e.Row, iCol));
                                    else
                                        iYearlySum = 0;
                                                                                                                       
                                }

                                if (siMain.GetColumnTag(iCol).IndexOf("Y_") == 0 || siMain.GetMaxColumnIndex() == iCol)
                                {
                                    siMain.SetText(e.Row, iStartCol - 1, iYearlySum.ToString());
                                    SetCellColor(siMain, e.Row, iCol, e.Row, iCol);
                                    break;
                                }
                            }
                        }
                        else if (sBucketType == BucketType.Yearly && sColName.IndexOf("Y_") == 0)
                        {
                                          
                            iStartCol = e.Column + 1;
                            string sYYYYMMDD = string.Empty;

                            if (siMain.GetText(e.Row, e.Column) == "")
                            {
                                iYearlySum = 0;
                            }
                            else
                            {
                                iYearlySum = Convert.ToInt64(Convert.ToDecimal(siMain.GetValue(e.Row, e.Column)));
                            }

                            long dDaycnt = 0;
                            decimal dDailyQty = 0;
                            decimal dRemnant = 0;
                            long dMonthCnt = 0;
                            bool bMonthAll = false;

                            DateTime dateTime = DateTime.Today.AddDays(Convert.ToInt64(DayOfWeek.Monday) - Convert.ToInt64(DateTime.Today.DayOfWeek));
                            string sResultDate = dateTime.ToString("yyyyMMdd");

                            long iCheck = 0;
                                          
                            for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                            {
                                iCheck++;
                                if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                                {
                                    dDaycnt = dDaycnt + 1;
                                }

                                if (siMain.GetColumnTag(iCol).IndexOf("Y_") == 0 || iCol == siMain.GetMaxColumnIndex())
                                {
                                    if (dDaycnt == 0)
                                    {
                                        bMonthAll = true;

                                                                                      
                                        dDaycnt = 1;
                                    }

                                                                                          
                                    if (strCheckMeasure == "Business_Plan")
                                    {
                                                                            
                                        dDailyQty = iYearlySum / dDaycnt;
                                        dRemnant = iYearlySum % dDaycnt;
                                    }
                                    else
                                    {
                                        dDailyQty = iYearlySum;
                                        dRemnant = 0;
                                    }

                                    break;
                                }
                            }

                            iCheck = 0;

                            if (!bMonthAll)
                            {
                                for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                                {
                                    if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                                    {
                                        iCheck++;
                                        if (dDaycnt < iCheck)
                                            continue;

                                        if (dDaycnt == iCheck)
                                        {
                                            if (dRemnant > 0)
                                            {
                                                dDailyQty = dDailyQty + dRemnant;
                                            }
                                            siMain.SetText(e.Row, iCol, dDailyQty.ToString());
                                            SetCellColor(siMain, e.Row, iCol, e.Row, iCol);
                                            sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("M_", "");
                                        }
                                        else
                                        {
                                            siMain.SetText(e.Row, iCol, dDailyQty.ToString());
                                            SetCellColor(siMain, e.Row, iCol, e.Row, iCol);
                                            sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("M_", "");
                                        }
                                    }
                                    else if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 && (siMain.GetText(e.Row, iCol + 1) == ""))
                                    {
                                        if (dDaycnt < iCheck)
                                            continue;

                                        if (dDaycnt == iCheck)
                                        {
                                            if (dRemnant > 0)
                                            {
                                                dDailyQty = dDailyQty + dRemnant;
                                            }
                                            siMain.SetText(e.Row, iCol, "");
                                            SetCellColor(siMain, e.Row, iCol, e.Row, iCol);
                                            sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("M_", "");
                                        }
                                        else
                                        {
                                            siMain.SetText(e.Row, iCol, "");
                                            SetCellColor(siMain, e.Row, iCol, e.Row, iCol);
                                            sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("M_", "");
                                        }
                                    }
                                }
                            }
                            else
                            {
                                int iSetCol = 0;

                                                     
                                for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                                {
                                    if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                                    {
                                        if (int.Parse(sResultDate) > int.Parse(siMain.GetColumnTag(iCol).Substring(siMain.GetColumnTag(iCol).Length - 8)))
                                        {
                                            continue;
                                        }
                                        if (siMain.GetText(e.Row, iCol) != "")
                                        {
                                            siMain.SetText(e.Row, iCol, "");
                                            SetCellColor(siMain, e.Row, iCol, e.Row, iCol);
                                            sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("M_", "");
                                        }
                                    }

                                    if (siMain.GetColumnTag(iCol).IndexOf("Y_") == 0 || iCol == siMain.GetMaxColumnIndex())
                                    {
                                        break;
                                    }
                                }


                                iCheck = 0;
                                for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                                {

                                                    
                                    if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                                    {
                                        if (int.Parse(sResultDate) > int.Parse(siMain.GetColumnTag(iCol).Substring(siMain.GetColumnTag(iCol).Length - 8)))
                                        {
                                            continue;
                                        }
                                        sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("M_", "");
                                        DateTime dtMonth = DateTime.ParseExact(sYYYYMMDD, "yyyyMMdd", System.Globalization.CultureInfo.InvariantCulture);

                                        string sDayofWeek = dtMonth.ToString("ddd", new System.Globalization.CultureInfo("en-US")).ToUpper();

                                        if (sDefaultDay == sDayofWeek)
                                        {
                                            iCheck++;
                                            if (dDaycnt == iCheck)
                                            {
                                                dDailyQty = dDailyQty + dRemnant;
                                                siMain.SetText(e.Row, iCol, dDailyQty.ToString());
                                                SetCellColor(siMain, e.Row, iCol, e.Row, iCol);
                                            }
                                            else
                                            {
                                                siMain.SetText(e.Row, iCol, dDailyQty.ToString());
                                                SetCellColor(siMain, e.Row, iCol, e.Row, iCol);
                                            }
                                        }
                                    }

                                    if (siMain.GetColumnTag(iCol).IndexOf("Y_") == 0 || iCol == siMain.GetMaxColumnIndex())
                                    {
                                        break;
                                    }
                                }
                            }

                                            
                            iQuarterlySum = 0;
                            int iQuarterCol = iStartCol;
                            for (int iCol = iStartCol + 1; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                            {
                                if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 && siMain.GetText(e.Row, iCol) != "")
                                {
                                                                                          
                                    if (strCheckMeasure == "Business_Plan")
                                        iQuarterlySum = iQuarterlySum + Convert.ToInt64(siMain.GetValue(e.Row, iCol));
                                    else
                                        iQuarterlySum = 0;                                                                      
                                }

                                if (siMain.GetColumnTag(iCol).IndexOf("Q_") == 0 || iCol == siMain.GetMaxColumnIndex())
                                {
                                    siMain.SetText(e.Row, iQuarterCol, iQuarterlySum.ToString().Replace(",", ""));
                                    SetCellColor(siMain, e.Row, iCol, e.Row, iCol);
                                    iQuarterCol = iCol;
                                    iQuarterlySum = 0;
                                }
                            }
                        }
                    }
                    else
                    {
                        double dQuarterlySum = 0;
                        double dYearlySum = 0;

                        if (sBucketType == BucketType.Monthly && sColName.IndexOf("M_") == 0)
                        {
                                            
                            for (int iCol = e.Column; iCol > 0; iCol--)
                            {
                                if (siMain.GetColumnTag(iCol).IndexOf("Q_") == 0)
                                {
                                    iStartCol = iCol + 1;
                                    break;
                                }
                            }

                            for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                            {
                                if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 && siMain.GetText(e.Row, iCol) != "")
                                {
                                    if (strCheckMeasure == "Business_Plan")
                                        dQuarterlySum = dQuarterlySum + Convert.ToDouble(siMain.GetValue(e.Row, iCol));
                                    else
                                        dQuarterlySum = Convert.ToInt32(siMain.GetValue(e.Row, e.Column));
                                }

                                if (siMain.GetColumnTag(iCol).IndexOf("Y_") == 0 || siMain.GetColumnTag(iCol).IndexOf("Q_") == 0
                                    || siMain.GetMaxColumnIndex() == iCol)
                                {
                                    siMain.SetText(e.Row, iStartCol - 1, dQuarterlySum.ToString());
                                    break;
                                }
                            }

                                         
                            for (int iCol = e.Column; iCol > 0; iCol--)
                            {
                                if (siMain.GetColumnTag(iCol).IndexOf("Y_") == 0)
                                {
                                    iStartCol = iCol + 1;
                                    break;
                                }
                            }

                            for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                            {
                                if (siMain.GetColumnTag(iCol).IndexOf("Q_") == 0 && siMain.GetText(e.Row, iCol) != "")
                                {
                                    if (strCheckMeasure == "Business_Plan")
                                        dYearlySum = dYearlySum + Convert.ToDouble(siMain.GetValue(e.Row, iCol));
                                    else
                                        dYearlySum = 0;                                                                      
                                }

                                if (siMain.GetColumnTag(iCol).IndexOf("Y_") == 0 || siMain.GetMaxColumnIndex() == iCol)
                                {
                                    siMain.SetText(e.Row, iStartCol - 1, dYearlySum.ToString());
                                    break;
                                }
                            }
                        }
                        else if ((sBucketType == BucketType.Quarterly) && sColName.IndexOf("Q_") == 0)
                        {
                            iStartCol = e.Column + 1;
                            if (siMain.GetText(e.Row, e.Column) == "")
                            {
                                dQuarterlySum = 0;
                            }
                            else
                            {
                                dQuarterlySum = Convert.ToDouble(siMain.GetValue(e.Row, e.Column));
                            }

                            long dDaycnt = 0;
                                                     
                                                    

                            double dDailyQty = 0;
                            double dRemnant = 0;
                            bool bWeekAll = false;

                                          
                            for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                            {
                                                                                                                          
                                if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                                {
                                    dDaycnt = dDaycnt + 1;                                                 
                                }

                                if (siMain.GetColumnTag(iCol).IndexOf("Y_") == 0 || siMain.GetColumnTag(iCol).IndexOf("Q_") == 0 || iCol == siMain.GetMaxColumnIndex())
                                {
                                    if (dDaycnt == 0)
                                    {
                                        bWeekAll = true;

                                                                         
                                                              

                                                                                      
                                        dDaycnt = 1;
                                                        
                                    }
                                                                                          
                                    if (strCheckMeasure == "Business_Plan")
                                    {
                                        dDailyQty = dQuarterlySum / dDaycnt;
                                        dRemnant = dQuarterlySum % dDaycnt;
                                    }
                                    else
                                    {
                                        dDailyQty = Convert.ToDouble(dQuarterlySum);
                                        dRemnant = 0;
                                    }
                                    break;
                                }
                            }

                            long iCheck = 0;
                            string sYYYYMMDD = sColName.Replace("M_", "");

                            if (!bWeekAll)
                            {
                                for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                                {
                                    if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                                    {
                                        iCheck++;

                                        if (dDaycnt == iCheck)
                                        {
                                            if (dRemnant > 0)
                                            {
                                                dDailyQty = dDailyQty + dRemnant;
                                            }

                                            siMain.SetText(e.Row, iCol, dDailyQty.ToString());
                                            SetCellColor(siMain, e.Row, iCol, e.Row, iCol);
                                            sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("M_", "");
                                        }
                                        else
                                        {
                                            siMain.SetText(e.Row, iCol, dDailyQty.ToString());
                                            SetCellColor(siMain, e.Row, iCol, e.Row, iCol);
                                            sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("M_", "");
                                        }
                                    }
                                    else if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 && (siMain.GetValue(e.Row, iCol + 1).ToString() == ""))
                                    {
                                        if (dDaycnt == iCheck)
                                        {
                                            if (dRemnant > 0)
                                            {
                                                dDailyQty = dDailyQty + dRemnant;
                                            }

                                            siMain.SetValue(e.Row, iCol, "");
                                            SetCellColor(siMain, e.Row, iCol, e.Row, iCol);
                                            sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("M_", "");
                                        }
                                        else
                                        {
                                            siMain.SetValue(e.Row, iCol, "");
                                            SetCellColor(siMain, e.Row, iCol, e.Row, iCol);
                                            sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("M_", "");
                                        }
                                    }

                                    if (siMain.GetColumnTag(iCol).IndexOf("M") != 0)
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
                                    if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 && siMain.GetText(e.Row, iCol) != "")
                                    {
                                        siMain.SetText(e.Row, iCol, "");
                                        SetCellColor(siMain, e.Row, iCol, e.Row, iCol);
                                        sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("M_", "");
                                    }

                                    if (siMain.GetColumnTag(iCol).IndexOf("M") != 0)
                                    {
                                        break;
                                    }
                                }
                            }

                                         
                            for (int iCol = e.Column; iCol > 0; iCol--)
                            {
                                if (siMain.GetColumnTag(iCol).IndexOf("Y_") == 0)
                                {
                                    iStartCol = iCol + 1;
                                    break;
                                }
                            }

                            for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                            {
                                if (siMain.GetColumnTag(iCol).IndexOf("Q_") == 0 && siMain.GetText(e.Row, iCol) != "")
                                {
                                                                                          
                                    if (strCheckMeasure == "Business_Plan")
                                        dYearlySum = dYearlySum + Convert.ToInt32(siMain.GetValue(e.Row, iCol));
                                    else
                                        dYearlySum = 0;
                                                                                                                       
                                }

                                if (siMain.GetColumnTag(iCol).IndexOf("Y_") == 0 || siMain.GetMaxColumnIndex() == iCol)
                                {
                                    siMain.SetText(e.Row, iStartCol - 1, dYearlySum.ToString());
                                    SetCellColor(siMain, e.Row, iCol, e.Row, iCol);
                                    break;
                                }
                            }
                        }
                        else if (sBucketType == BucketType.Yearly && sColName.IndexOf("Y_") == 0)
                        {
                                          
                            iStartCol = e.Column + 1;
                            string sYYYYMMDD = string.Empty;

                            if (siMain.GetText(e.Row, e.Column) == "")
                            {
                                dYearlySum = 0;
                            }
                            else
                            {
                                dYearlySum = Convert.ToDouble(siMain.GetValue(e.Row, e.Column));
                            }

                            long dDaycnt = 0;
                            double dDailyQty = 0;
                            double dRemnant = 0;
                            long dMonthCnt = 0;
                            bool bMonthAll = false;

                            DateTime dateTime = DateTime.Today.AddDays(Convert.ToInt32(DayOfWeek.Monday) - Convert.ToInt32(DateTime.Today.DayOfWeek));
                            string sResultDate = dateTime.ToString("yyyyMMdd");

                            long iCheck = 0;
                                          
                            for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                            {
                                iCheck++;
                                if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                                {
                                    dDaycnt = dDaycnt + 1;
                                }

                                if (siMain.GetColumnTag(iCol).IndexOf("Y_") == 0 || iCol == siMain.GetMaxColumnIndex())
                                {
                                    if (dDaycnt == 0)
                                    {
                                        bMonthAll = true;

                                                                                      
                                        dDaycnt = 1;
                                    }

                                                                                          
                                    if (strCheckMeasure == "Business_Plan")
                                    {
                                                                            
                                        dDailyQty = dYearlySum / dDaycnt;
                                        dRemnant = dYearlySum % dDaycnt;
                                    }
                                    else
                                    {
                                        dDailyQty = dYearlySum;
                                        dRemnant = 0;
                                    }

                                    break;
                                }
                            }

                            iCheck = 0;

                            if (!bMonthAll)
                            {
                                for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                                {
                                    if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                                    {
                                        iCheck++;
                                        if (dDaycnt < iCheck)
                                            continue;

                                        if (dDaycnt == iCheck)
                                        {
                                            if (dRemnant > 0)
                                            {
                                                dDailyQty = dDailyQty + dRemnant;
                                            }
                                            siMain.SetText(e.Row, iCol, dDailyQty.ToString());
                                            SetCellColor(siMain, e.Row, iCol, e.Row, iCol);
                                            sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("M_", "");
                                        }
                                        else
                                        {
                                            siMain.SetText(e.Row, iCol, dDailyQty.ToString());
                                            SetCellColor(siMain, e.Row, iCol, e.Row, iCol);
                                            sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("M_", "");
                                        }
                                    }
                                    else if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 && (siMain.GetText(e.Row, iCol + 1) == ""))
                                    {
                                        if (dDaycnt < iCheck)
                                            continue;

                                        if (dDaycnt == iCheck)
                                        {
                                            if (dRemnant > 0)
                                            {
                                                dDailyQty = dDailyQty + dRemnant;
                                            }
                                            siMain.SetText(e.Row, iCol, "");
                                            SetCellColor(siMain, e.Row, iCol, e.Row, iCol);
                                            sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("M_", "");
                                        }
                                        else
                                        {
                                            siMain.SetText(e.Row, iCol, "");
                                            SetCellColor(siMain, e.Row, iCol, e.Row, iCol);
                                            sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("M_", "");
                                        }
                                    }
                                }
                            }
                            else
                            {
                                int iSetCol = 0;

                                                     
                                for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                                {
                                    if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                                    {
                                        if (int.Parse(sResultDate) > int.Parse(siMain.GetColumnTag(iCol).Substring(siMain.GetColumnTag(iCol).Length - 8)))
                                        {
                                            continue;
                                        }
                                        if (siMain.GetText(e.Row, iCol) != "")
                                        {
                                            siMain.SetText(e.Row, iCol, "");
                                            SetCellColor(siMain, e.Row, iCol, e.Row, iCol);
                                            sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("M_", "");
                                        }
                                    }

                                    if (siMain.GetColumnTag(iCol).IndexOf("Y_") == 0 || iCol == siMain.GetMaxColumnIndex())
                                    {
                                        break;
                                    }
                                }


                                iCheck = 0;
                                for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                                {

                                                    
                                    if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0)
                                    {
                                        if (int.Parse(sResultDate) > int.Parse(siMain.GetColumnTag(iCol).Substring(siMain.GetColumnTag(iCol).Length - 8)))
                                        {
                                            continue;
                                        }
                                        sYYYYMMDD = siMain.GetColumnTag(iCol).Replace("M_", "");
                                        DateTime dtMonth = DateTime.ParseExact(sYYYYMMDD, "yyyyMMdd", System.Globalization.CultureInfo.InvariantCulture);

                                        string sDayofWeek = dtMonth.ToString("ddd", new System.Globalization.CultureInfo("en-US")).ToUpper();

                                        if (sDefaultDay == sDayofWeek)
                                        {
                                            iCheck++;
                                            if (dDaycnt == iCheck)
                                            {
                                                dDailyQty = dDailyQty + dRemnant;
                                                siMain.SetText(e.Row, iCol, dDailyQty.ToString());
                                                SetCellColor(siMain, e.Row, iCol, e.Row, iCol);
                                            }
                                            else
                                            {
                                                siMain.SetText(e.Row, iCol, dDailyQty.ToString());
                                                SetCellColor(siMain, e.Row, iCol, e.Row, iCol);
                                            }
                                        }
                                    }

                                    if (siMain.GetColumnTag(iCol).IndexOf("Y_") == 0 || iCol == siMain.GetMaxColumnIndex())
                                    {
                                        break;
                                    }
                                }
                            }

                                            
                            dQuarterlySum = 0;
                            int iQuarterCol = iStartCol;
                            for (int iCol = iStartCol + 1; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                            {
                                if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 && siMain.GetText(e.Row, iCol) != "")
                                {
                                                                                          
                                    if (strCheckMeasure == "Business_Plan")
                                        dQuarterlySum = dQuarterlySum + Convert.ToInt32(siMain.GetValue(e.Row, iCol));
                                    else
                                        dQuarterlySum = 0;                                                                      
                                }

                                if (siMain.GetColumnTag(iCol).IndexOf("Q_") == 0 || iCol == siMain.GetMaxColumnIndex())
                                {
                                    siMain.SetText(e.Row, iQuarterCol, dQuarterlySum.ToString().Replace(",", ""));
                                    SetCellColor(siMain, e.Row, iCol, e.Row, iCol);
                                    iQuarterCol = iCol;
                                    dQuarterlySum = 0;
                                }
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

        private void spdMain_TopChange(object sender, FarPoint.Win.Spread.TopChangeEventArgs e)
        {
            CanModelChange = false;
            siMain.SmartColMerge();
            CanModelChange = true;
        }

        private void spdMain_KeyUp(object sender, System.Windows.Forms.KeyEventArgs e)
        {
                                                                                                 

                                                                                                         
                
                                                                                                
                                                                   
                                         
                

                                                                                                         
                
                                     
                                                                                            
                                                                 
                
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
            DM0002_TitleSetForm_Popup frm = new DM0002_TitleSetForm_Popup("DMF0042", SpdSheet.shtMain, true, clbDivision.ControlValues);
            frm.StartPosition = FormStartPosition.CenterParent;
            frm.ShowDialog();

            if (frm.DialogResult == DialogResult.OK)
            {
                InitSpread();
            }
        }

        private void btnMeasure_Click(object sender, EventArgs e)
        {
            DM0002_TitleSetForm_Popup frm = new DM0002_TitleSetForm_Popup("DMF0042", SpdSheet.shtMain, false, clbDivision.ControlValues);

            frm.StartPosition = FormStartPosition.CenterParent;
            frm.ShowDialog();

            if (frm.DialogResult == DialogResult.OK)
            {
                InitSpread();
            }
        }

        private void chkSum_CheckedChanged(object sender, EventArgs e)
        {
            if (siMain != null)
            {
                SetSpreadColumn();
            }
        }

        private void btnCutOff_Click(object sender, EventArgs e)
        {
            if (!siMain.IsLock(siMain.SheetName))
            {
                MessageBox.Show("Edit Mode is not allowed.");
                return;
            }

                                                    
            string sVersion_Type = "BP_M";
            string sFoxData = "DM.DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF";                                           

            GSCM.DM.Plan.UIL.POPUP.VersionCutOffPopUp popup = new GSCM.DM.Plan.UIL.POPUP.VersionCutOffPopUp();

                                       
            string sDivisionId = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);                               

            popup.LoadDataDiv(sVersion_Type, sFoxData, sDivisionId);

            popup.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            popup.ShowDialog();

            if (popup.blnOK)
            {

            }
        }

        private string GetDayRange()
        {
            string sDayRange = string.Empty;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                var request = new FoxDataRequest("DM.PR_GET_DAY_RANGE");
                request.Parameters["p_created_by"] = base.UserInfo.UserId;
                request.Parameters["p_month"] = 7;                  

                sDayRange = client.ExecuteDataSet(request).DataSet.Tables[1].Rows[0][0].ToString();                                                    
            }

            return sDayRange;
        }

        private void GetSpdTitle()
        {
            string[] sMonth = drpPeriod.ControlValues.Split(':');

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                var request = new FoxDataRequest("DM.DMF0042_GET_SPREAD_TITLE");

                request.Parameters["p_start_yyyymmdd"] = sMonth[0];
                request.Parameters["p_end_yyyymmdd"] = sMonth[1];
                request.Parameters["p_created_by"] = base.UserInfo.UserId;
                request.Parameters["p_division_id"] = clbDivision.ControlValues;

                dtTitle = client.ExecuteDataSet(request).DataSet.Tables[0];
            }
        }

        private DataTable GetLookupData(string strType)
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sScmBinding))
            {
                var request = new FoxDataRequest("SCM.SCM0001_GET_LOOKUP_VALUES");
                request.Parameters["p_lookup_type"] = strType;
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
            if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) >= siMain.ActiveColumnIndex) return;

            bPasteContinue = true;


        }
                                                  

        private void btnExchangeRate_Click(object sender, EventArgs e)
        {
            if (!siMain.IsLock(siMain.SheetName))
            {
                MessageHelper.GMessageBox("MSG00142");
                return;
            }

            POPUP.DMF0042_ExchangeRatePopup popup = new POPUP.DMF0042_ExchangeRatePopup();
            popup.LoadData(drpPeriod.Value1.ToString("yyyyMM"), drpPeriod.Value2.ToString("yyyyMM"), "BP", clbDivision.ControlValues);

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
            DataTable dt = null;
            string sStartDate = drpPeriod.Value1.ToString("yyyyMM") + "01";
            string sEndDate = drpPeriod.Value2.ToString("yyyyMM") + "01";

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sScmBinding))
            {
                var request = new FoxDataRequest("DM.DMF0042_GET_EXCHANGE_PRICE");
                request.Parameters["p_start_yyyymmdd"] = sStartDate;
                request.Parameters["p_end_yyyymmdd"] = sEndDate;
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

        private int[] GetCellNumbersByRow(int iRow)
        {
                        
            int multiful = dtMeasure.Rows.Count;
                                                    
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

        private int GetCellIndexBySpanRowCells(int iActiveRow)
        {
            long div;
            int multiful = dtMeasure.Rows.Count;
            Math.DivRem(iActiveRow, multiful, out div);
            return Convert.ToInt32(iActiveRow - div);
        }

        public string ParameterString(string strColumn, string strParameter, int iRow)
        {
            if (siMain.GetColumnIndex(strColumn) != -1)
            {
                if ((strColumn == "INCOTERMS") || (strColumn == "FCST_TYPE")                                )
                {
                    string strValue = (string)siMain.GetValue(iRow, siMain.GetColumnIndex(strColumn));
                    strValue = (strValue == "") ? " " : strValue;
                    strParameter = strParameter + "^" + strValue;
                }                                          
                else if ((strColumn == "CELL_PER_PACK") || (strColumn == "CELL_PER_MODULE") || (strColumn == "MODULE_PER_PACK") || (strColumn == "UNIT_ENERGY"))
                {
                    string strValue = siMain.GetValue(iRow, siMain.GetColumnIndex(strColumn)).ToString();
                    strValue = (strValue == "") ? "0" : strValue;
                    strParameter = strParameter + "^" + strValue;
                }
                else
                    strParameter = strParameter + "^" + (string)siMain.GetValue(iRow, siMain.GetColumnIndex(strColumn));
            }
            else
            {                                             
                if ((strColumn == "CELL_PER_PACK") || (strColumn == "CELL_PER_MODULE") || (strColumn == "MODULE_PER_PACK") || (strColumn == "UNIT_ENERGY"))
                {
                    string strValue = "";
                    strValue = (strValue == "") ? "0" : strValue;
                    strParameter = strParameter + "^" + strValue;
                }
                else
                    strParameter = strParameter + "^";
            }

            return strParameter;
        }

        private void btnSetPrice_Click(object sender, EventArgs e)
        {
            if (MessageHelper.GMessageBox("MSG00282") == DialogResult.No)
                return;

            DataSet ds = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                var request = new FoxDataRequest("DM.DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV");

                request.CommandTimeout = 30 * 60;

                request.Parameters["s_flag"] = "";
                request.Parameters["s_division_id"] = clbDivision.ControlValues;
                ds = client.ExecuteDataSet(request).DataSet;
            }

            MessageHelper.GMessageBox(ds.Tables[0].Rows[0][0].ToString());

            FindData();
        }

        private bool fnValidation()
        {
            bool bValidation = true;
            int iValidation = 0;
            string sProjectCode = string.Empty;
            string sSiteId = string.Empty;
            string sItemId = string.Empty;
            string sCurrency = string.Empty;

            for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow += dtMeasure.Rows.Count)
            {
                if (siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI)
                {
                    string sDivision = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                    string sCellProd = "", sFcstType = "",                      sMeasure = "", sPlantSiteId = "";

                                                                                                      
                    if (clbDivision.ControlValues.Substring(0, 2) == "81")
                    {
                        sProjectCode = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString();
                    }   
                                                                
                      
                                                                                                                           
                       
                    else if (clbDivision.ControlValues == "40")
                    {
                        sDivision = "40";
                        sProjectCode = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)).ToString();
                    }

                    if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40) != -1)
                        sSiteId = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID81) != -1)
                        sSiteId = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID81)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID82) != -1)
                        sSiteId = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID82)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                        sItemId = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE) != -1)
                        sCellProd = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.FCST_TYPE) != -1)
                        sFcstType = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FCST_TYPE)).ToString();
                                                                             
                                                                                                                      
                    if (siMain.GetColumnIndex(DefColumns.CURRENCY) != -1)
                        sCurrency = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.CURRENCY)).ToString();
                                                                                                     
                                                                                                                            
                    if (siMain.GetColumnIndex(DefColumns.MEASURE) != -1)
                        sMeasure = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString();

                    for (int iRow2 = 0; iRow2 <= siMain.GetMaxRowIndex(); iRow2 += dtMeasure.Rows.Count)
                    {
                        if (clbDivision.ControlValues.Substring(0, 2) == "81")
                        {
                                                                                                                                 
                                                                                                                                    
                                                                                                                                
                                                                                                                          
                                                                                                                          
                                                                                                                              
                                                                                                                               
                                                                                                                             
                                                                                                                           
                                                                                                                                     
                                
                            if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) == -1
                             || siMain.GetColumnIndex(DefColumns.PROJECT_CODE) == -1
                                                                                    
                             || siMain.GetColumnIndex(DefColumns.DEPT_ID) == -1
                             || siMain.GetColumnIndex(DefColumns.END_CUSTOMER) == -1
                                                                                          
                             || siMain.GetColumnIndex(DefColumns.CURRENCY) == -1
                             || siMain.GetColumnIndex(DefColumns.MEASURE) == -1
                             )
                            {
                                iValidation++;
                            }
                        }
                        else if (clbDivision.ControlValues == "82")
                        {
                                                                                                                                 
                                                                                                                                      
                                                                                                                                
                                                                                                                          
                                                                                                                          
                                                                                                                              
                                                                                                                               
                                                                                                                             
                                                                                                                           
                                
                            if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) == -1
                             || siMain.GetColumnIndex(DefColumns.DEPT_ID) == -1
                                                                                       
                             || siMain.GetColumnIndex(DefColumns.MEASURE) == -1
                             || siMain.GetColumnIndex(DefColumns.CURRENCY) == -1
                             )
                            {
                                iValidation++;
                            }
                        }
                        else
                        {
                                                                                                                                 
                                                                                                                                      
                                                                                                                                
                                                                                                                            
                                                                                                                            
                                                                                                                                
                                                                                                                                 
                                                                                                                             
                                                                                                                           
                                
                            if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) == -1
                             || siMain.GetColumnIndex(DefColumns.END_CUSTOMER40) == -1
                             || siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40) == -1
                             || siMain.GetColumnIndex(DefColumns.ITEM_ID40) == -1
                             || siMain.GetColumnIndex(DefColumns.MEASURE) == -1
                             || siMain.GetColumnIndex(DefColumns.CURRENCY) == -1
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

        public void SetCellColor(SpreadInfo siInfo, int iRow1, int iCol1, int iRow2, int iCol2)
        {
            FpSpread fpSpread = siInfo.SpreadObject;
                                                           
            FarPoint.Win.Spread.Cell range1;
            range1 = fpSpread.ActiveSheet.Cells[iRow1, iCol1, iRow2, iCol2];
            range1.ForeColor = System.Drawing.Color.Red;
        }

                                                                         
        private void SetComboCol(SpreadInfo spread, string columnName, DataTable dt)
        {
            System.Collections.ArrayList arrCode = new System.Collections.ArrayList();
            System.Collections.ArrayList arrName = new System.Collections.ArrayList();
            for (int i = 0; i <= dt.Rows.Count - 1; i++)
            {
                DataRow dr = dt.Rows[i];
                arrCode.Add(dr["CODE"].ToString());
                arrName.Add(dr["NAME"].ToString());
            }

            ComboBoxCellType cb = new ComboBoxCellType();
            cb.ItemData = (String[])arrCode.ToArray(typeof(string));
            cb.Items = (String[])arrName.ToArray(typeof(string));
            cb.EditorValue = FarPoint.Win.Spread.CellType.EditorValue.ItemData;
            cb.Editable = true;

            int columnIndex = spread.GetColumnIndex(columnName);
            Column column = spread.Sheet().Columns[columnIndex];
            column.CellType = cb;
        }
                                                                         


        public bool MinColumnChk()
        {
                               
                                           
            if (clbDivision.SelectedValue.ToString().Substring(0, 2) == "81")
            {
                if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) == -1
                    || siMain.GetColumnIndex(DefColumns.PROJECT_CODE) == -1
                    || siMain.GetColumnIndex(DefColumns.INCOTERMS) == -1
                    || siMain.GetColumnIndex(DefColumns.SCM_SITE_ID81) == -1
                    || siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID) == -1
                    || siMain.GetColumnIndex(DefColumns.ITEM_ID) == -1
                    || siMain.GetColumnIndex(DefColumns.DEPT_ID) == -1
                    || siMain.GetColumnIndex(DefColumns.END_CUSTOMER) == -1
                    || siMain.GetColumnIndex(DefColumns.FCST_TYPE) == -1
                                                                                 
                    || siMain.GetColumnIndex(DefColumns.CURRENCY) == -1
                    || siMain.GetColumnIndex(DefColumns.MEASURE) == -1
                    )
                {
                                                             
                    return false;
                }
            }
            else if (clbDivision.SelectedValue.ToString() == "82")
            {
                if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) == -1
                                                                                
                                                                               
                                                                         
                    || siMain.GetColumnIndex(DefColumns.DEPT_ID) == -1
                    || siMain.GetColumnIndex(DefColumns.UNIT_ENERGY) == -1
                                                                              
                    || siMain.GetColumnIndex(DefColumns.CURRENCY) == -1
                    || siMain.GetColumnIndex(DefColumns.MEASURE) == -1
                    )
                {
                                                             
                    return false;
                }
            }
            else
            {
                if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) == -1
                                                                                                  
                    || siMain.GetColumnIndex(DefColumns.END_CUSTOMER40) == -1
                    || siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40) == -1
                    || siMain.GetColumnIndex(DefColumns.ITEM_ID40) == -1
                    || siMain.GetColumnIndex(DefColumns.MEASURE) == -1
                    || siMain.GetColumnIndex(DefColumns.INCOTERMS) == -1
                    || siMain.GetColumnIndex(DefColumns.FCST_TYPE) == -1
                                                                         
                    || siMain.GetColumnIndex(DefColumns.CURRENCY) == -1
                    || siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE) == -1
                    )
                {
                                                             
                    return false;
                }
            }
            return true;
        }
                                                        
        private DataTable GetCellProdSite(string sCode, string sValidYN)
        {

            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                var request = new FoxDataRequest("DM.UP_FX_GetCommonDataList_DM");
                request.Parameters["CODE"] = sCode;
                request.Parameters["PARAM1"] = sValidYN;
                request.Parameters["PARAM2"] = "";
                request.Parameters["PARAM3"] = "";
                request.Parameters["PARAM4"] = "";
                request.Parameters["PARAM5"] = "";
                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }
            return dt;
        }
        #endregion

        private void btnReplace_Click(object sender, EventArgs e)
        {
            if (!siMain.IsLock(siMain.SheetName))
            {
                MessageBox.Show("Edit Mode is not allowed.");
                return;
            }

            string GroupId = string.Empty;
            GroupId = UserInfoContext.Current["NowGroupID"].ToString();
            if (GroupId != "ADMIN" && GroupId != "DM ADMIN")
            {
                MessageBox.Show("Edit Mode is not allowed.");
                return;
            }


            FarPoint.Win.Spread.Model.CellRange cr;
            cr = spdMain.Sheets[0].GetSelection(0);


            DataTable dt = new DataTable();
            dt.Columns.Add("YYYYMM", typeof(string));

            if (spdMain.Sheets[0].RowCount == 0)
            {
                MessageBox.Show("데이터 조회 후 다시 시도해 주시기 바랍니다.");
                return;
            }

            string StartDate = string.Empty;
            string EndDate = string.Empty;

            if (cr == null)
            {
                StartDate = drpPeriod.Value1.ToString().Substring(0, 7).Replace("-", "");
                EndDate = drpPeriod.Value2.ToString().Substring(0, 7).Replace("-", "");
            }
            else
            {
                int ColStart = cr.Column;
                int ColEnd = cr.Column - 1 + cr.ColumnCount;

                for (int i = ColStart; i <= ColEnd; i++)
                {
                    string colTag = siMain.GetColumnTag(i).ToString();
                    DataRow row = dt.NewRow();

                    if (colTag.Substring(0, 2) == "M_")
                    {
                        row["YYYYMM"] = colTag.Substring(2, 6).ToString();
                        dt.Rows.Add(row);
                    }
                }

                int z = dt.Rows.Count - 1;



                if (dt.Rows.Count > 0)
                {
                    StartDate = dt.Rows[0]["YYYYMM"].ToString();
                    EndDate = dt.Rows[z]["YYYYMM"].ToString();
                }
                else
                {
                    StartDate = drpPeriod.Value1.ToString("yyyyMMdd");
                    EndDate = drpPeriod.Value2.ToString("yyyyMMdd");
                }
            }




            string sVersion_Type = "BP_M";
            string sYYYYMM_from = StartDate;
            string sYYYYMM_to = EndDate;
            string sFoxData = "DM.DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF";                                           

            GSCM.DM.Plan.UIL.POPUP.ReplaceByCutOffPopUp popup = new GSCM.DM.Plan.UIL.POPUP.ReplaceByCutOffPopUp();

            string sDivisionId = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);                               

            popup.LoadDataDiv(sVersion_Type, sYYYYMM_from, sYYYYMM_to, sFoxData, sDivisionId);

            popup.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            popup.ShowDialog();

            if (popup.blnOK)
            {

            }
        }
    }
}