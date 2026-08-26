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

using FarPoint.Win.Spread.CellType;

using GSCM.Windows.Forms.Service;
using GSCM.FP.Common.UIL.Service;

                                                                                                                            
                               
                                                                                                                            
                                    
                                
                  
                                                                                                                            
                                    
                                                                     
                                                      
                                                                                             
                                                                                                                           

namespace GSCM.DM.Plan.UIL
{
    public partial class DMF0014_CustFcstUpload : BaseForm
    {
        #region 1. Setting
        CControl clsCtrl = null;
                           
        private DataSet dsMain = null;
        private DataTable dtSave = null;
        private DataTable dtTitle = null;
        private DataTable dtDivision = null;
        private DataTable dtSprDivision = null;
        private DataTable dtTeam = null;
        private DataTable dtEndCustomer = null;
        private DataTable dtScmSite = null;
        private DataTable dtPlantSite = null;
        private DataTable dtBucketType = null;
        private DataTable dtIncoterms = null;
        private DataTable dtSalesType = null;
        private DataTable dtDomExp = null;
        private DataTable dtUploadUOM = null;
        private DataTable dtYesOrNo = Data.Common(Data.Type.YesOrNo);
        private DataTable dtMeasure = null;

        TextCellType cellTypeImage = null;

                  
        SpreadInfo siMain = null;

                      
                       
                       
        private struct SpdSheet
        {
            public static string shtMain = "FCST Upload";
        }

                      
                  
                       
        private struct DefColumns
        {
            public const string DivisionId = "DIVISION_ID";
            public const string ScmSite = "SCM_SITE_ID";
            public const string PlantSite = "PLANT_SITE_ID";
            public const string CustomerProject = "CUSTOMER_PROJECT_CODE";
            public const string CustomerModel = "CUSTOMER_MODEL";
            public const string Incoterms = "INCOTERMS";
            public const string FcstType = "FCST_TYPE";
            public const string DomExp = "DOM_EXP";
            public const string MeasureGroup = "MEASURE_GROUP";
            public const string Measure = "MEASURE";
            public const string UploadUOM = "UPLOAD_UOM";
            public const string ProjectCode = "PROJECT_CODE";
            public const string ItemId = "ITEM_ID";

            public const string YYYYMMDD = "YYYYMMDD";
            public const string Qty = "QTY";
            public const string UserId = "USER_ID";

            public static string EditFlag = "EDIT_FLAG";
        }

        private struct DefColumnsLabel
        {
            public const string DivisionId = "Division*";
            public const string ScmSite = "Sales Site*";
            public const string PlantSite = "Plant Site*";
            public const string CustomerProject = "Customer Project*";
            public const string CustomerModel = "Customer Model*";
            public const string Incoterms = "Incoterms*";
            public const string FcstType = "FCST Type*";
            public const string DomExp = "Customs Handbook*";
            public const string MeasureGroup = "Measure Group*";
            public const string Measure = "Measure*";
            public const string UploadUOM = "Upload UOM*";
            public const string ProjectCode = "Project";
            public const string ItemId = "Model";

            public static string Saturday = "SAT";
            public static string Sunday = "SUN";

            public static string EditFlag = "EDIT_FLAG";
        }

        private struct BucketType
        {
            public static string Daily = "DAILY";
            public static string Weekly = "WEEKLY";
            public static string Monthly = "MONTHLY";
        }

        private string sBinding = "GSCM.DM.Master.WSL/FoxDataService.svc";
        private string sScmBinding = "GSCM.SCM.Master.WSL/FoxDataService.svc";

        #endregion

        #region 2. Construct

        public DMF0014_CustFcstUpload()
        {
            InitializeComponent();

                      
            this.Load += Form_Load;
        }

        private void Form_Load(object sender, EventArgs e)
        {
            clsCtrl = new CControl(this);
            InitForm();
            InitControls();
            DefineProperty();
            CreateSpread();
            InitEvent();
            InitSaveDataTable();
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
                                  

                                                         

                                                                                  

                             
                case "UserSiteByEndCustomer":

                    Filter["DIVISION_ID"] = sDivision;
                    Filter["DEPT_ID"] = sTeam;
                    Filter["END_CUSTOMER"] = sEndCustomer;

                    dtScmSite = DataService.GetDMInnerTable("UserSiteByEndCustomer", Filter);

                    break;
                case "UserPlantSiteByDivision":

                    Filter["DIVISION_ID"] = sDivision;

                    dtPlantSite = DataService.GetDMInnerTable("UserPlantSiteByDivision", Filter);

                    break;
                                                         

                                                             
                                                                 

                                                                                                           

                                 
                                        

                                                                                          

                                 
                                                     

                                                                                                         

                                 
            }
        }

        #endregion               
                                               

        private void InitControls()
        {
            dtSprDivision = Data.Common(Data.Type.Division, false);

                                                                       
                                                                                                                                            

            SetChangeControl("MyDivision");
            clsCtrl.setListBox(dtDivision, cboDivision, false, "CODE", "NAME");

            string sDivision = cboDivision.ControlValues;

                                                                       
                                                                                                                                  

            SetChangeControl("UserTeamByDivision", sDivision);
            clsCtrl.setListBox(dtTeam, clbTeam, true);

            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);

            if (sDivision == "40")
            {
                                                                           
                                                                                                                                                                                  

                SetChangeControl("EndCustomerByDivision", sDivision, sTeam);
            }
            else
            {
                                                                           
                                                                                                                                                               

                SetChangeControl("EndCustomerByDivision", sDivision, sTeam);
            }

            clsCtrl.setListBox(dtEndCustomer, clbEndCustomer, true);

            string sEndCustomer = CString.GetCheckedListValue(dtEndCustomer, clbEndCustomer.ControlValues);

                                                                       
                                                                                                                                                      

            SetChangeControl("UserSiteByEndCustomer", sDivision, string.Empty, sEndCustomer);
            clsCtrl.setListBox(dtScmSite, clbScmSite, true);

                                                                       
                                                                                                                                            

            SetChangeControl("UserPlantSiteByDivision", sDivision);
            clsCtrl.setListBox(dtPlantSite, clbPlantSite, true);

            drpPeriod.InitValue = GetDayRange();

            dtBucketType = GetLookupValues("BUCKET_TYPE_CODE");
            clsCtrl.setListBox(dtBucketType, cboBucketType, false, "CODE", "NAME");

            dtDomExp = Data.Common(Data.Type.DOM_EXP);                                           
            clsCtrl.setListBox(dtDomExp, clbDomExp, true);

            dtIncoterms = GetLookupValues("INCOTERMS");
            dtSalesType = GetLookupValues("SALES_TYPE_CODE");
            dtUploadUOM = GetLookupValues("UPLOAD_UOM_TYPE_CODE");
                             

            dtMeasure = Data.Common(Data.Type.CustomerMeasure, false, cboDivision.ControlValues, clbEndCustomer.ControlValues, clbScmSite.ControlValues, cboBucketType.SelectedValue.ToString(), "CUST_FCST");

        }

        #region 3. Define

        private void DefineProperty()
        {
            cboBucketType.ControlValues = BucketType.Weekly;

            if (UserInfoContext.Current["NowGroupID"].IndexOf("Viewer") >= 0)
            {
                btnExcelUpload.Enabled = false;
                btnExcelUpload.Visible = false;
            }
        }

        private void CreateSpread()
        {
            this.AddSheet(spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30);
            siMain = GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex);
            siMain.ChangeSheet();

            siMain.ImagePopUp = imageList1.Images[0];
            cellTypeImage = new TextCellType();
            cellTypeImage.BackgroundImage = new FarPoint.Win.Picture(siMain.ImagePopUp);
            cellTypeImage.BackgroundImage.AlignHorz = FarPoint.Win.HorizontalAlignment.Right;
            cellTypeImage.CharacterCasing = CharacterCasing.Upper;

            InitSpread();

            siMain.ColumnHeaderHeight(0, 30);
            siMain.ColumnHeaderHeight(1, 35);
        }

        private void InitSpread()
        {
            siMain.InitSheet(siMain.SheetName);

            siMain.AddActionTextBox();
            siMain.AddComboColumn(DefColumnsLabel.DivisionId, DefColumns.DivisionId, FPMerge.Restricted, 60, true, dtSprDivision, FPHAlign.Left, FPVAlign.Center);
            siMain.AddComboColumn(DefColumnsLabel.ScmSite, DefColumns.ScmSite, FPMerge.Restricted, 60, true, dtScmSite, FPHAlign.Left, FPVAlign.Center);
            siMain.AddComboColumn(DefColumnsLabel.PlantSite, DefColumns.PlantSite, FPMerge.Restricted, 60, true, dtPlantSite, FPHAlign.Left, FPVAlign.Center);
            siMain.AddTextColumn(DefColumnsLabel.CustomerProject, DefColumns.CustomerProject, FPMerge.Restricted, 60, true, FPHAlign.Left, FPVAlign.Center);
            siMain.AddTextColumn(DefColumnsLabel.CustomerModel, DefColumns.CustomerModel, FPMerge.Restricted, 60, true, FPHAlign.Left, FPVAlign.Center);
            siMain.AddComboColumn(DefColumnsLabel.Incoterms, DefColumns.Incoterms, FPMerge.Restricted, 40, true, dtIncoterms, FPHAlign.Left, FPVAlign.Center);
            siMain.AddComboColumn(DefColumnsLabel.FcstType, DefColumns.FcstType, FPMerge.Restricted, 40, true, dtSalesType, FPHAlign.Left, FPVAlign.Center);
            siMain.AddComboColumn(DefColumnsLabel.DomExp, DefColumns.DomExp, FPMerge.Restricted, 60, true, dtDomExp, FPHAlign.Left, FPVAlign.Center);
            siMain.AddTextColumn(DefColumnsLabel.MeasureGroup, DefColumns.MeasureGroup, FPMerge.Restricted, 60, true, FPHAlign.Left, FPVAlign.Center);
            siMain.AddComboColumn(DefColumnsLabel.Measure, DefColumns.Measure, FPMerge.Restricted, 40, true, dtMeasure, FPHAlign.Left, FPVAlign.Center);
            siMain.AddComboColumn(DefColumnsLabel.UploadUOM, DefColumns.UploadUOM, FPMerge.Restricted, 40, true, dtUploadUOM, FPHAlign.Left, FPVAlign.Center);
            siMain.AddTextColumn(DefColumnsLabel.ProjectCode, DefColumns.ProjectCode, FPMerge.Restricted, 80, true, FPHAlign.Left, FPVAlign.Center);
            siMain.AddTextColumn(DefColumnsLabel.ItemId, DefColumns.ItemId, FPMerge.Restricted, 100, true, FPHAlign.Left, FPVAlign.Center);
            siMain.AddTextColumn(DefColumnsLabel.EditFlag, DefColumns.EditFlag, FPMerge.Restricted, 0, true, FPHAlign.Left, FPVAlign.Center);

            siMain.ColumnHeaderSpan(0, siMain.GetColumnIndex(CAppSetting.StringAction), 2, 1, 30, "A", FPHAlign.Center);
            siMain.ColumnHeaderSpan(0, siMain.GetColumnIndex(DefColumns.DivisionId), 2, 1, 30, DefColumnsLabel.DivisionId, FPHAlign.Center);
            siMain.ColumnHeaderSpan(0, siMain.GetColumnIndex(DefColumns.ScmSite), 2, 1, 30, DefColumnsLabel.ScmSite, FPHAlign.Center);
            siMain.ColumnHeaderSpan(0, siMain.GetColumnIndex(DefColumns.PlantSite), 2, 1, 30, DefColumnsLabel.PlantSite, FPHAlign.Center);
            siMain.ColumnHeaderSpan(0, siMain.GetColumnIndex(DefColumns.CustomerProject), 2, 1, 30, DefColumnsLabel.CustomerProject, FPHAlign.Center);
            siMain.ColumnHeaderSpan(0, siMain.GetColumnIndex(DefColumns.CustomerModel), 2, 1, 30, DefColumnsLabel.CustomerModel, FPHAlign.Center);
            siMain.ColumnHeaderSpan(0, siMain.GetColumnIndex(DefColumns.Incoterms), 2, 1, 30, DefColumnsLabel.Incoterms, FPHAlign.Center);
            siMain.ColumnHeaderSpan(0, siMain.GetColumnIndex(DefColumns.FcstType), 2, 1, 30, DefColumnsLabel.FcstType, FPHAlign.Center);
            siMain.ColumnHeaderSpan(0, siMain.GetColumnIndex(DefColumns.DomExp), 2, 1, 30, DefColumnsLabel.DomExp, FPHAlign.Center);
            siMain.ColumnHeaderSpan(0, siMain.GetColumnIndex(DefColumns.MeasureGroup), 2, 1, 30, DefColumnsLabel.MeasureGroup, FPHAlign.Center);
            siMain.ColumnHeaderSpan(0, siMain.GetColumnIndex(DefColumns.Measure), 2, 1, 30, DefColumnsLabel.Measure, FPHAlign.Center);
            siMain.ColumnHeaderSpan(0, siMain.GetColumnIndex(DefColumns.UploadUOM), 2, 1, 30, DefColumnsLabel.UploadUOM, FPHAlign.Center);
            siMain.ColumnHeaderSpan(0, siMain.GetColumnIndex(DefColumns.ProjectCode), 2, 1, 30, DefColumnsLabel.ProjectCode, FPHAlign.Center);
            siMain.ColumnHeaderSpan(0, siMain.GetColumnIndex(DefColumns.ItemId), 2, 1, 30, DefColumnsLabel.ItemId, FPHAlign.Center);
            siMain.ColumnHeaderSpan(0, siMain.GetColumnIndex(DefColumns.EditFlag), 2, 1, 30, DefColumnsLabel.EditFlag, FPHAlign.Center);

            siMain.Freeze(0, siMain.GetColumnIndex(DefColumns.EditFlag));

            GetSpdTitle();
                         
            string sColumnName = string.Empty;
            string sColumnLabel = string.Empty;
            string sSmallLabelName = string.Empty;
            string sSpanLabelName = dtTitle.Rows[0][2].ToString();
            int iStartCol = siMain.GetColumnIndex(DefColumns.EditFlag) + 1;
            int iSpanCnt = 0;

            foreach (DataRow dr in dtTitle.Rows)
            {
                sColumnName = dr["COLUMN_NAME"].ToString();
                sColumnLabel = dr["COLUMN_LABEL"].ToString();
                sSmallLabelName = dr["SMALL_LABEL_NAME"].ToString();

                siMain.AddNumTextColumn(sColumnLabel, sColumnName, FPMerge.Restricted, 50, true, FPHAlign.Right, FPVAlign.Center);

                if (sSpanLabelName != sSmallLabelName)
                {
                    siMain.ColumnHeaderSpan(0, iStartCol, 1, iSpanCnt, 30, sSpanLabelName, FPHAlign.Center);
                    sSpanLabelName = dr["SMALL_LABEL_NAME"].ToString();
                    iStartCol = iStartCol + iSpanCnt;
                    iSpanCnt = 0;
                }
                iSpanCnt++;

                if (sSmallLabelName == DefColumnsLabel.Saturday || sSmallLabelName == DefColumnsLabel.Sunday)
                {
                    siMain.Sheet().ColumnHeader.Cells[0, siMain.GetMaxColumnIndex()].ForeColor = sSmallLabelName == DefColumnsLabel.Saturday ? Color.Blue : Color.Red;
                }
            }

            siMain.ColumnHeaderSpan(0, iStartCol, 1, iSpanCnt, 30, sSpanLabelName, FPHAlign.Center);
        }

        private void InitEvent()
        {
            cboDivision.SelectedIndexChanged += new System.EventHandler(cboDivision_SelectedIndexChanged);
            FarPoint.Win.Spread.Model.DefaultSheetDataModel dsdm = (FarPoint.Win.Spread.Model.DefaultSheetDataModel)siMain.Sheet(SpdSheet.shtMain).Models.Data;
            dsdm.Changed += new FarPoint.Win.Spread.Model.SheetDataModelEventHandler(spdMain_Changed);

            drpPeriod.ValueChanged += new EventHandler(drpPeriod_ValueChanged);

        }

        private void InitSaveDataTable()
        {
            dtSave = new DataTable("CustFcstSave");
            dtSave.Columns.Add(DefColumns.DivisionId, typeof(string));
            dtSave.Columns.Add(DefColumns.ScmSite, typeof(string));
            dtSave.Columns.Add(DefColumns.CustomerProject, typeof(string));
            dtSave.Columns.Add(DefColumns.CustomerModel, typeof(string));
            dtSave.Columns.Add(DefColumns.Incoterms, typeof(string));
            dtSave.Columns.Add(DefColumns.FcstType, typeof(string));
            dtSave.Columns.Add(DefColumns.DomExp, typeof(string));
            dtSave.Columns.Add(DefColumns.MeasureGroup, typeof(string));
            dtSave.Columns.Add(DefColumns.Measure, typeof(string));
            dtSave.Columns.Add(DefColumns.PlantSite, typeof(string));
            dtSave.Columns.Add(DefColumns.UploadUOM, typeof(string));
            dtSave.Columns.Add(DefColumns.ProjectCode, typeof(string));
            dtSave.Columns.Add(DefColumns.ItemId, typeof(string));
            dtSave.Columns.Add(DefColumns.YYYYMMDD, typeof(string));
            dtSave.Columns.Add(DefColumns.Qty, typeof(int));
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
                siMain = GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex);
                siMain.SwitchLock();

                for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
                {
                    if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToString() == CAppSetting.StringY)
                    {
                                                                                                                                           
                        siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.DivisionId), iRow, siMain.GetColumnIndex(DefColumns.EditFlag), true);
                    }
                    else
                    {
                        siMain.LockRange(iRow, 0, iRow, siMain.GetMaxColumnIndex(), true);
                    }
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

        private async void FindData()
        {
            CanModelChange = false;

            GSCM.Windows.Forms.UI.ProgressForm prg = new GSCM.Windows.Forms.UI.ProgressForm();

            try
            {

                string sDivision = CString.GetCheckedListValue(dtDivision, cboDivision.ControlValues);

                if (sDivision == "")
                {
                    MessageHelper.GMessageBox("MSG00097");

                    return;
                }

                dtMeasure = Data.Common(Data.Type.CustomerMeasure, false, sDivision, clbEndCustomer.ControlValues, clbScmSite.ControlValues, cboBucketType.SelectedValue.ToString(), "CUST_FCST");

                string[] sDate = drpPeriod.ControlValues.Split(':');

                if (int.Parse(sDate[0]) > int.Parse(sDate[1]))
                {
                    MessageHelper.GMessageBox("MSG00108");
                    return;
                }

                if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2)
                {
                    MessageHelper.GMessageBox("MSG00164");

                    drpPeriod.Value2 = drpPeriod.Value1.AddYears(2);

                    return;
                }

                prg.Show();

                InitSpread();

                                 
                SearchStartTime();

                var asyncProxy = new FoxAsyncProxy(this);

                using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
                {
                    var request = new FoxDataRequest("DM.DMF0014_GET_CUST_FCST_UPLOAD_DATA");

                    request.Parameters["p_division_id"] = sDivision;                               
                    request.Parameters["p_dept_id"] = clbTeam.ControlValues;
                    request.Parameters["p_end_customer"] = clbEndCustomer.ControlValues;
                    request.Parameters["p_scm_site_id"] = clbScmSite.ControlValues;
                    request.Parameters["p_plant_site_id"] = clbPlantSite.ControlValues;
                    request.Parameters["p_project_code"] = txtProject.Text;
                    request.Parameters["p_item_id"] = txtItemId.Text;
                    request.Parameters["p_start_yyyymmdd"] = sDate[0].ToString();
                    request.Parameters["p_end_yyyymmdd"] = sDate[1].ToString();
                    request.Parameters["p_bucket_type"] = cboBucketType.SelectedValue.ToString();
                    request.Parameters["p_dom_exp"] = clbDomExp.ControlValues;
                    request.Parameters["p_created_by"] = base.UserInfo.UserId;

                    request.Parameters["p_userinfo"] = UserInfoContext.Current["NowGroupID"].ToString();
                    var response = client.ExecuteDataSet(request);

                    dsMain = response.DataSet;
                };

                                              
                SearchEndTime();

                siMain.SpreadObject.SuspendLayout();

                siMain.Query(dsMain);
                siMain.LockColumn(0, siMain.GetMaxColumnIndex(), true);

                dtSave.Clear();

                               
                UIEndTime();

                CanModelChange = true;

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
                    string sProcedureName = "DM.DMF0014_SAVE_CUST_FCST_UPLOAD_DATA";

                    string sActionFlag = string.Empty;
                    string sDivision = string.Empty;
                    string sSiteId = string.Empty;
                    string sCustomerProject = string.Empty;
                    string sCustomerModel = string.Empty;
                    string sIncoterms = string.Empty;
                    string sFcstType = string.Empty;
                    string sDomExp = string.Empty;
                    string sMeasureGroup = string.Empty;
                    string sMeasure = string.Empty;
                    string sPlantSiteId = string.Empty;
                    string sUploadUOM = string.Empty;
                    string sProjectCode = string.Empty;
                    string sItemId = string.Empty;
                    string sYYYYMMDD = string.Empty;
                    string sQty = string.Empty;
                    string sUserId = string.Empty;
                    int iCount = 0;

                    foreach (DataRow dr in dtSave.Rows)
                    {
                        if (iCount == 0)
                        {
                            sActionFlag = CAppSetting.StringM;
                            sDivision = dr[DefColumns.DivisionId].ToString();
                            sSiteId = dr[DefColumns.ScmSite].ToString();
                            sCustomerProject = dr[DefColumns.CustomerProject].ToString();
                            sCustomerModel = dr[DefColumns.CustomerModel].ToString();
                            sIncoterms = dr[DefColumns.Incoterms].ToString();
                            sFcstType = dr[DefColumns.FcstType].ToString();
                            sDomExp = dr[DefColumns.DomExp].ToString();
                            sMeasureGroup = dr[DefColumns.MeasureGroup].ToString();
                            sMeasure = dr[DefColumns.Measure].ToString();
                            sPlantSiteId = dr[DefColumns.PlantSite].ToString();
                            sUploadUOM = dr[DefColumns.UploadUOM].ToString();
                            sProjectCode = dr[DefColumns.ProjectCode].ToString();
                            sItemId = dr[DefColumns.ItemId].ToString();
                            sYYYYMMDD = dr[DefColumns.YYYYMMDD].ToString();
                            sQty = dr[DefColumns.Qty].ToString();
                            sUserId = base.UserInfo.UserId;
                        }
                        else
                        {
                            sActionFlag = sActionFlag + "^" + CAppSetting.StringM;
                            sDivision = sDivision + "^" + dr[DefColumns.DivisionId].ToString();
                            sSiteId = sSiteId + "^" + dr[DefColumns.ScmSite].ToString();
                            sCustomerProject = sCustomerProject + "^" + dr[DefColumns.CustomerProject].ToString();
                            sCustomerModel = sCustomerModel + "^" + dr[DefColumns.CustomerModel].ToString();
                            sIncoterms = sIncoterms + "^" + dr[DefColumns.Incoterms].ToString();
                            sFcstType = sFcstType + "^" + dr[DefColumns.FcstType].ToString();
                            sDomExp = sDomExp + "^" + dr[DefColumns.DomExp].ToString();
                            sMeasureGroup = sMeasureGroup + "^" + dr[DefColumns.MeasureGroup].ToString();
                            sMeasure = sMeasure + "^" + dr[DefColumns.Measure].ToString();
                            sPlantSiteId = sPlantSiteId + "^" + dr[DefColumns.PlantSite].ToString();
                            sUploadUOM = sUploadUOM + "^" + dr[DefColumns.UploadUOM].ToString();
                            sProjectCode = sProjectCode + "^" + dr[DefColumns.ProjectCode].ToString();
                            sItemId = sItemId + "^" + dr[DefColumns.ItemId].ToString();
                            sYYYYMMDD = sYYYYMMDD + "^" + dr[DefColumns.YYYYMMDD].ToString();
                            sQty = sQty + "^" + dr[DefColumns.Qty].ToString();
                            sUserId = sUserId + "^" + base.UserInfo.UserId;
                        }
                        iCount++;
                    }

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
                                request.Parameters["p_scm_site_id"] = sSiteId;
                                request.Parameters["p_customer_project_code"] = sCustomerProject;
                                request.Parameters["p_customer_model"] = sCustomerModel;
                                request.Parameters["p_incoterms"] = sIncoterms;
                                request.Parameters["p_fcst_type"] = sFcstType;
                                request.Parameters["p_dom_exp"] = sDomExp;
                                request.Parameters["p_measure_group"] = sMeasureGroup;
                                request.Parameters["p_measure"] = sMeasure;
                                request.Parameters["p_plant_site_id"] = sPlantSiteId;
                                request.Parameters["p_upload_uom"] = sUploadUOM;
                                request.Parameters["p_project_code"] = sProjectCode;
                                request.Parameters["p_item_id"] = sItemId;
                                request.Parameters["p_yyyymmdd"] = sYYYYMMDD;
                                request.Parameters["p_qty"] = sQty;
                                request.Parameters["p_created_by"] = sUserId;

                                var response = client.ExecuteDataSet(request);

                                if (response.DataSet.Tables.Count != 0)
                                {
                                    MessageHelper.GMessageBox(response.DataSet.Tables[0].Rows[0][0].ToString());
                                }
                                else
                                {
                                                                             
                                    MessageHelper.GMessageBox("MSG00004", new object[] { iCount });
                                }
                            };
                                  

                            FindButton();
                        }
                        catch (Exception ex)
                        {
                            MessageHelper.GMessageBoxForException(ex);
                        }
                        finally
                        {
                                            
                        }
                    }
                    else
                    {
                        MessageHelper.GMessageBox("MSG00152");
                    }
                }
            }
        }

        private void InsertRow()
        {
            if (this.fps != null)
            {
                MessageHelper.GMessageBox("MSG00380", null);                     
                return;
            }

               
                                                                            
              
                                                          
                  
                                                                        
                                                                                               
 
                                                                  
                                                      
 
                                          
                                                                                                    
                                                                                                                                                                      
                                                                                                               
 
                                                                                                       
                                                                                                                    
                  
                                                                                                                                                        
                                                                                                                                               
                  
              
              
        }

        #endregion

        #region 6. Event
        private void cboDivision_SelectedIndexChanged(object sender, EventArgs e)
        {
            string sDivision = CString.GetCheckedListValue(dtDivision, cboDivision.ControlValues);

            InitSpread();
            InitSaveDataTable();

            DataService.FP_Log2("SpeedUp", "DMF0014", "division_id_changed", "start");

                                                                       
                                                                                                                                  

            SetChangeControl("UserTeamByDivision", sDivision);
            clsCtrl.setListBox(dtTeam, clbTeam, true);

            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);

            if (sDivision != null && sDivision != "")
            {
                if ((sDivision.Substring(0, 2) == "81") || (sDivision == "82"))
                {
                    lblProject.Enabled = true;
                    btnProject.Enabled = true;

                                                                               
                                                                                                                                                                   

                    SetChangeControl("EndCustomerByDivision", sDivision, sTeam);
                    clsCtrl.setListBox(dtEndCustomer, clbEndCustomer, true);

                    string sEndCustomer = CString.GetCheckedListValue(dtEndCustomer, clbEndCustomer.ControlValues);

                                                                               
                                                                                                                                                              

                    SetChangeControl("UserSiteByEndCustomer", sDivision, string.Empty, sEndCustomer);
                    clsCtrl.setListBox(dtScmSite, clbScmSite, true);
                }
                else
                {
                    lblProject.Enabled = false;
                    btnProject.Enabled = false;
                                                                               
                                                                                                                                                                                               

                    SetChangeControl("EndCustomerByDivision", sDivision, clbTeam.ControlValues);
                    clsCtrl.setListBox(dtEndCustomer, clbEndCustomer, true);

                    string sEndCustomer = CString.GetCheckedListValue(dtEndCustomer, clbEndCustomer.ControlValues);

                                                                               
                                                                                                                                                                                
                                                                                                                                                                                                                            

                    SetChangeControl("UserSiteByEndCustomer", sDivision, clbTeam.ControlValues, clbEndCustomer.ControlValues);
                    clsCtrl.setListBox(dtScmSite, clbScmSite, true);
                }
            }

                                                                       
                                                                                                                                            

            SetChangeControl("UserPlantSiteByDivision", sDivision);
            clsCtrl.setListBox(dtPlantSite, clbPlantSite, true);

            DataService.FP_Log2("SpeedUp", "DMF0014", "division_id_changed", "end");
        }

        private void clbTeam_SelectedIndexChanged(object sender, EventArgs e)
        {
            string sDivision = CString.GetCheckedListValue(dtDivision, cboDivision.ControlValues);
            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);

                                                                       
                                                                                                                                                           

            SetChangeControl("EndCustomerByDivision", sDivision, sTeam);
            clsCtrl.setListBox(dtEndCustomer, clbEndCustomer, true);

            string sEndCustomer = CString.GetCheckedListValue(dtEndCustomer, clbEndCustomer.ControlValues);

                                                                       
                                                                                                                                                      

            SetChangeControl("UserSiteByEndCustomer", sDivision, string.Empty, sEndCustomer);
            clsCtrl.setListBox(dtScmSite, clbScmSite, true);
        }

        private void clbEndCustomer_SelectedIndexChanged(object sender, EventArgs e)
        {
            string sDivision = CString.GetCheckedListValue(dtDivision, cboDivision.ControlValues);
            string sEndCustomer = CString.GetCheckedListValue(dtEndCustomer, clbEndCustomer.ControlValues);

                                                                       
                                                                                                                                                      

            SetChangeControl("UserSiteByEndCustomer", sDivision, string.Empty, sEndCustomer);
            clsCtrl.setListBox(dtScmSite, clbScmSite, true);
        }

        private void btnProject_Click(object sender, EventArgs e)
        {
            string sDivision = cboDivision.ControlValues;
            string sProject = txtProject.Text;
            string sProjectCode = "";
            string sScmSite = clbScmSite.ControlValues;
            string sEndCustomer = clbEndCustomer.ControlValues;

            SCM0002_ProjectbyDivisionPopupEx popProject = new SCM0002_ProjectbyDivisionPopupEx();
            popProject.Form_Load(true, sDivision, "", sEndCustomer, sScmSite, sProject);
            popProject.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            popProject.ShowDialog();

            sProjectCode = popProject.ProjectCode;

            if (popProject.ProjectCode != "")
            {
                txtProject.Text = sProjectCode;
            }
        }

        private void btmItem_Click(object sender, EventArgs e)
        {
            string sdivision = cboDivision.ControlValues;
            string sScmSite = clbScmSite.ControlValues;
            string sProject = txtProject.Text;
            string sItemId = txtItemId.Text;
            string sEndCustomer = clbEndCustomer.ControlValues;

                                                                                       
                                                                                
                                                                                           
                                    

            DM0002_ItembyDivisionPopupEx popItem = new DM0002_ItembyDivisionPopupEx();
                                   
            popItem.Form_Load(true, sdivision, "", sEndCustomer, sScmSite, sProject, sItemId);
            popItem.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            popItem.ShowDialog();

            sItemId = popItem.ItemID;

            if (popItem.ItemID != "")
            {
                txtItemId.Text = sItemId;
            }
        }

        private void drpPeriod_ValueChanged(object sender, EventArgs e)
        {
            DateTime dtFrom = drpPeriod.Value1;
            DateTime dtTo = drpPeriod.Value2;

            if (dtFrom > dtTo)
            {
                                                       
                                                                                                                                                
                MessageHelper.GMessageBox("MSG00108");

                return;
            }
        }

        protected void spdMain_Changed(object sender, FarPoint.Win.Spread.Model.SheetDataModelEventArgs e)
        {
            switch (e.Type)
            {
                case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated:

                    string sColName = siMain.GetColumnTag(e.Column);
                    int iStartCol = 0;
                    int iWeeklySum = 0;
                    int iMonthlySum = 0;

                    if (sColName.IndexOf("D_") == 0)
                    {
                        string sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DivisionId)).ToString();
                        string sScmSite = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ScmSite)).ToString();
                        string sCustomerProject = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.CustomerProject));
                        string sCustomerModel = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.CustomerModel)).ToString();
                        string sIncoterms = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Incoterms)).ToString();
                        string sFcstType = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FcstType)).ToString();
                        string sDomExp = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DomExp)).ToString();
                        string sMeasureGroup = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.MeasureGroup));
                        string sMeasure = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.Measure));
                        string sPlantSiteId = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.PlantSite));
                        string sUploadUOM = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.UploadUOM)).ToString();
                        string sProjectCode = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.ProjectCode));
                        string sItemId = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.ItemId));
                        string sYYYYMMDD = sColName.Replace("D_", "");


                        int iQty = 0;

                        if (siMain.GetText(e.Row, siMain.GetColumnIndex(sColName)) != "")
                        {
                            iQty = Convert.ToInt32(siMain.GetText(e.Row, siMain.GetColumnIndex(sColName)).Replace(",", ""));
                        }

                        if (sDivision == "")
                        {
                            MessageHelper.GMessageBox("MSG00002", new object[] { DefColumnsLabel.DivisionId });
                            siMain.ActiveSheet.SetActiveCell(e.Row, siMain.GetColumnIndex(DefColumns.DivisionId));
                            return;

                        }
                        else if (sScmSite == "")
                        {
                            MessageHelper.GMessageBox("MSG00002", new object[] { DefColumnsLabel.ScmSite });
                            siMain.ActiveSheet.SetActiveCell(e.Row, siMain.GetColumnIndex(DefColumns.ScmSite));
                            return;
                        }
                        else if (sCustomerProject == "")
                        {
                            MessageHelper.GMessageBox("MSG00002", new object[] { DefColumnsLabel.CustomerProject });
                            siMain.ActiveSheet.SetActiveCell(e.Row, siMain.GetColumnIndex(DefColumns.CustomerProject));
                            return;
                        }
                        else if (sCustomerModel == "")
                        {
                            MessageHelper.GMessageBox("MSG00002", new object[] { DefColumnsLabel.CustomerModel });
                            siMain.ActiveSheet.SetActiveCell(e.Row, siMain.GetColumnIndex(DefColumns.CustomerModel));
                            return;
                        }
                        else if (sIncoterms == "")
                        {
                            MessageHelper.GMessageBox("MSG00002", new object[] { DefColumnsLabel.Incoterms });
                            siMain.ActiveSheet.SetActiveCell(e.Row, siMain.GetColumnIndex(DefColumns.Incoterms));
                            return;
                        }
                        else if (sFcstType == "")
                        {
                            MessageHelper.GMessageBox("MSG00002", new object[] { DefColumnsLabel.FcstType });
                            siMain.ActiveSheet.SetActiveCell(e.Row, siMain.GetColumnIndex(DefColumns.FcstType));
                            return;
                        }
                        else if (sDomExp == "")
                        {
                            MessageHelper.GMessageBox("MSG00002", new object[] { DefColumnsLabel.DomExp });
                            siMain.ActiveSheet.SetActiveCell(e.Row, siMain.GetColumnIndex(DefColumns.DomExp));
                            return;
                        }
                        else if (sMeasureGroup == "")
                        {
                            MessageHelper.GMessageBox("MSG00002", new object[] { DefColumnsLabel.MeasureGroup });
                            siMain.ActiveSheet.SetActiveCell(e.Row, siMain.GetColumnIndex(DefColumns.MeasureGroup));
                            return;
                        }
                        else if (sMeasure == "")
                        {
                            MessageHelper.GMessageBox("MSG00002", new object[] { DefColumnsLabel.Measure });
                            siMain.ActiveSheet.SetActiveCell(e.Row, siMain.GetColumnIndex(DefColumns.Measure));
                            return;
                        }
                        else if (sPlantSiteId == "" && sDivision == "81")
                        {
                            MessageHelper.GMessageBox("MSG00002", new object[] { DefColumnsLabel.PlantSite });
                            siMain.ActiveSheet.SetActiveCell(e.Row, siMain.GetColumnIndex(DefColumns.PlantSite));
                            return;
                        }
                        else if (sUploadUOM == "")
                        {
                            MessageHelper.GMessageBox("MSG00002", new object[] { DefColumnsLabel.UploadUOM });
                            siMain.ActiveSheet.SetActiveCell(e.Row, siMain.GetColumnIndex(DefColumns.Incoterms));
                            return;
                        }

                        SetSaveData(sDivision, sScmSite, sCustomerProject, sCustomerModel, sIncoterms
                                  , sFcstType, sDomExp, sMeasureGroup, sMeasure, sPlantSiteId
                                  , sUploadUOM, sProjectCode, sItemId, sYYYYMMDD, iQty);
                        break;
                    }
                    else if (e.Column <= siMain.GetColumnIndex(DefColumns.Measure))
                    {
                        string sDivisionId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DivisionId)).ToString();
                        string sScmSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ScmSite)).ToString();
                        string sMeasureGroup = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.MeasureGroup)).ToString();
                        string sMeasure = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Measure)).ToString();
                        string sBucketType = cboBucketType.SelectedValue.ToString();

                        if (sDivisionId != "" && sScmSiteId != "" && sMeasureGroup != "" && sMeasure != "" && sBucketType != "")
                        {
                            string sUploadUOM = Data.Common(Data.Type.CUST_FCST_UPLOAD_UOM, false, sDivisionId, sScmSiteId, sMeasureGroup, sMeasure, sBucketType).Rows[0][0].ToString();
                            siMain.SetValue(e.Row, siMain.GetColumnIndex(DefColumns.UploadUOM), sUploadUOM);
                        }
                    }
                    break;
            }
        }

        private void SetSaveData(string sDivision, string sScmSite, string sCustomerProject, string sCustomerModel, string sIncoterms
                               , string sFcstType, string sDomExp, string sMeasureGroup, string sMeasure, string sPlantSiteId
                               , string sUploadUOM, string sProjectCode, string sItemId, string sYYYYMMDD, int iQty)
        {
            string sFilter = DefColumns.DivisionId + "= '" + sDivision + "'";
            sFilter += " and " + DefColumns.ScmSite + " = '" + sScmSite + "'";
            sFilter += " and " + DefColumns.CustomerProject + " = '" + sCustomerProject + "'";
            sFilter += " and " + DefColumns.CustomerModel + " = '" + sCustomerModel + "'";
            sFilter += " and " + DefColumns.Incoterms + " = '" + sIncoterms + "'";
            sFilter += " and " + DefColumns.FcstType + " = '" + sFcstType + "'";
            sFilter += " and " + DefColumns.DomExp + " = '" + sDomExp + "'";
            sFilter += " and " + DefColumns.MeasureGroup + " = '" + sMeasureGroup + "'";
            sFilter += " and " + DefColumns.Measure + " = '" + sMeasure + "'";
            sFilter += " and " + DefColumns.PlantSite + " = '" + sPlantSiteId + "'";
            sFilter += " and " + DefColumns.YYYYMMDD + "= '" + sYYYYMMDD + "'";

            DataRow[] drFind = dtSave.Select(sFilter);

            if (drFind.Length == 0)
            {
                DataRow drNew = dtSave.NewRow();
                drNew[DefColumns.DivisionId] = sDivision;
                drNew[DefColumns.ScmSite] = sScmSite;
                drNew[DefColumns.CustomerProject] = sCustomerProject;
                drNew[DefColumns.CustomerModel] = sCustomerModel;
                drNew[DefColumns.Incoterms] = sIncoterms;
                drNew[DefColumns.FcstType] = sFcstType;
                drNew[DefColumns.DomExp] = sDomExp;
                drNew[DefColumns.MeasureGroup] = sMeasureGroup;
                drNew[DefColumns.Measure] = sMeasure;
                drNew[DefColumns.PlantSite] = sPlantSiteId;
                drNew[DefColumns.UploadUOM] = sUploadUOM;
                drNew[DefColumns.ProjectCode] = sProjectCode;
                drNew[DefColumns.ItemId] = sItemId;
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

        private void btnExcelUpload_Click(object sender, EventArgs e)
        {
            ExcelUploadForm frm = new ExcelUploadForm("DMF0014", this.spdMain.ActiveSheet.SheetName);
            frm.SaveExceptError = true;
            frm.StartPosition = FormStartPosition.CenterParent;
            frm.ShowDialog();

        }

        private void spdMain_ComboSelChange(object sender, FarPoint.Win.Spread.EditorNotifyEventArgs e)
        {
            string sDivision = cboDivision.ControlValues;

            if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId))
            {

                dtScmSite = Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, CAppSetting.StringALL);
                siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.ScmSite), dtScmSite);

                dtPlantSite = Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision);
                siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.PlantSite), dtPlantSite);

                string sScmSite = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ScmSite)).ToString();

                dtMeasure = Data.Common(Data.Type.CustomerMeasure, false, sDivision, clbEndCustomer.ControlValues, sScmSite, cboBucketType.SelectedValue.ToString(), "CUST_FCST");
                siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure);

                if (sDivision != "81")
                    siMain.LockRange(e.Row, siMain.GetColumnIndex(DefColumns.PlantSite), e.Row, siMain.GetColumnIndex(DefColumns.PlantSite), true);
                else
                    siMain.LockRange(e.Row, siMain.GetColumnIndex(DefColumns.PlantSite), e.Row, siMain.GetColumnIndex(DefColumns.PlantSite), false);
            }
            else if (e.Column == siMain.GetColumnIndex(DefColumns.ScmSite))
            {
                sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DivisionId)).ToString();
                string sScmSite = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ScmSite)).ToString();

                dtMeasure = Data.Common(Data.Type.CustomerMeasure, false, sDivision, clbEndCustomer.ControlValues, sScmSite, cboBucketType.SelectedValue.ToString(), "CUST_FCST");
                siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure);
            }
            else if (e.Column == siMain.GetColumnIndex(DefColumns.Measure))
            {
                sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DivisionId)).ToString();
                string sEndCustomer = clbEndCustomer.ControlValues;
                string sScmSite = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ScmSite)).ToString();
                string sBucket = cboBucketType.SelectedValue.ToString();
                string sMeasure = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Measure)).ToString();
            }
        }
        private void spdMain_CellDoubleClick(object sender, FarPoint.Win.Spread.CellClickEventArgs e)
        {
            if (siMain.IsLock(siMain.SheetName) || siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting.StringI)
            {
                return;
            }
        }

        private void cboBucketType_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (siMain != null)
            {
                InitSpread();
                               
            }
        }

        #endregion

        private string GetDayRange()
        {
            string sDayRange = string.Empty;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                var request = new FoxDataRequest("DM.PR_GET_DAY_RANGE");
                request.Parameters["p_created_by"] = base.UserInfo.UserId;
                request.Parameters["p_month"] = 6;

                sDayRange = client.ExecuteDataSet(request).DataSet.Tables[0].Rows[0][0].ToString();
            }

            return sDayRange;
        }

        private void GetSpdTitle()
        {
            string[] sDate = drpPeriod.ControlValues.Split(':');

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                var request = new FoxDataRequest("DM.DMF0014_GET_SPREAD_TITLE");
                request.Parameters["p_start_yyyymmdd"] = sDate[0];
                request.Parameters["p_end_yyyymmdd"] = sDate[1];
                request.Parameters["p_bucket_type"] = cboBucketType.ControlValues;

                dtTitle = client.ExecuteDataSet(request).DataSet.Tables[0];
            }
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

    }
}
