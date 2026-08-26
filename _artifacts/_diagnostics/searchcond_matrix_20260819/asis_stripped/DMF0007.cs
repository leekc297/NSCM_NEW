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
using GSCM.FP.Common.UIL.Service;
using GSCM.Windows.Forms.Service;
using GSCM.SCM.Popup.UIL;

using System.Windows.Forms;

                                                                                                                            
                         
                                                                                                                            
                              
                                  
                  
                                                                                                                            
                                        
                                                                         
                                                                                           
                                                                      
                                                                  
                                                                                                                           

namespace GSCM.DM.Master.UIL
{
    public partial class DMF0007_CustFcstMaster : BaseForm
    {
        #region 1. Setting
        CControl clsCtrl = null;

                                   
        private DataSet dsMain = null;
        private DataTable dtSave = null;
        private DataTable dtTitle = null;
        private DataTable dtDivision = null;
        private DataTable dtTeam = null;
        private DataTable dtEndCustomer = null;
        private DataTable dtScmSite = null;
        private DataTable dtBucketType = null;
        private DataTable dtUploadUOM = null;
        private DataTable dtYesOrNo = Data.Common(Data.Type.YesOrNo);

                  
        SpreadInfo siMain = null;


                      
                       
                       
        private struct SpdSheet
        {
            public static string shtMainFCST = "Customer FCST";
            public static string shtMainPSI = "Customer PSI";
        }

                      
                  
                       
        private struct DefColumns
        {
            public const string PlanWeek = "PLAN_WEEK";
            public const string DivisionId = "DIVISION_ID";
            public const string DeptId = "DEPT_ID";
            public const string CustomerCode = "CUSTOMER_CODE";
            public const string ScmSite = "SCM_SITE_ID";
            public const string BucketType = "SUMMARY_BUCKET_TYPE";
            public const string MeasureGroup = "MEASURE_GROUP";
            public const string Measure = "MEASURE";
            public const string EDIFCSTFlag = "EDI_FCST_YN";
            public const string CustomerPSI = "CUSTOMER_PSI";
            public const string UploadUOM = "UPLOAD_UOM";
            public const string ActiveFlag = "VALID_YN";
            public const string UploadBucketType = "UPLOAD_BUCKET_TYPE";

            public const string BucketValue = "SUMMARY_BUCKET_VALUE";
            public const string BucketYn = "SUMMARY_BUCKET_YN";
            public const string UserId = "USER_ID";

            public static string UpdateUser = "LAST_UPDATED_BY";
            public static string UpdateDate = "LAST_UPDATE_DATE";

            public static string UploadOrder = "UPLOAD_ORDER";

            public static string EditFlag = "EDIT_FLAG";
        }

        private struct DefColumnsLabel
        {
            public const string PlanWeek = "Plan Week";
            public const string DivisionId = "Division";
            public const string DeptId = "Team";
            public const string CustomerCode = "End Customer";
            public const string ScmSite = "Sales Site";
            public const string BucketType = "Bucket Type";
            public const string MeasureGroup = "Measure Group";
            public const string Measure = "Measure";
            public const string FcstSeq = "Seq";
            public const string EDIFCSTFlag = "EDI FCST Y/N";
            public const string CustomerPSI = "Customer PSI";
            public const string UploadUOM = "Upload UOM";
            public const string ActiveFlag = "Active";
            public const string UploadBucketType = "Upload Bucket Type";

            public static string UpdateUser = "Update By";
            public static string UpdateDate = "Update Date";

            public static string Saturday = "SAT";
            public static string Sunday = "SUN";
        }

        private struct BucketType
        {
            public static string Daily = "DAILY";
            public static string Weekly = "WEEKLY";
            public static string Monthly = "MONTHLY";
        }


        private string sBinding = "GSCM.DM.Master.WSL/FoxDataService.svc";
        private string sScmBinding = "GSCM.SCM.Master.WSL/FoxDataService.svc";

        private string sMyDeptID = string.Empty;

        #endregion

                                                  
        private static string sTeamAll = CAppSetting.StringALL;
        private static string sEndCustomerAll = CAppSetting.StringALL;
        private DataTable dtEndCustomer40 = Data.Common(Data.Type.EndCustomerByDivision40, false, "40", sTeamAll, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
                                                


        #region 2. Construct

        public DMF0007_CustFcstMaster()
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

                                                    
            lblTeam.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
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
                                                 
                    Filter["END_CUSTOMER"] = sEndCustomer;

                    dtScmSite = DataService.GetDMInnerTable("UserSiteByEndCustomer", Filter);

                    break;

            }
        }
        #endregion               
                                                

        #region 3. Define
        private void InitControls()
        {
            dtDivision = Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
            clsCtrl.setListBox(dtDivision, clbDivisions, false,"CODE","NAME");

            string sDivision =  clbDivisions.ControlValues;

            dtTeam = Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision);
            clsCtrl.setListBox(dtTeam, clbTeam, true);

            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);

            if (sDivision == "40")
            {
                dtEndCustomer = Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
            }
            else {
                dtEndCustomer = Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam);
            }

            clsCtrl.setListBox(dtEndCustomer, clbEndCustomer, true);

            string sEndCustomer = CString.GetCheckedListValue(dtEndCustomer, clbEndCustomer.ControlValues);

            dtScmSite = Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
            clsCtrl.setListBox(dtScmSite, clbSalesSite, true);

            dtBucketType = Data.Common(Data.Type.BucketType);                        
            clsCtrl.setListBox(dtBucketType, cboBucketType, false, "CODE", "NAME");

                             
            clsCtrl.setListBox(dtYesOrNo, cboActive, true);

            dtUploadUOM = Data.Common(Data.Type.UploadUOM);                   

            System.Windows.Forms.ToolTip toolTip1 = new System.Windows.Forms.ToolTip();
                                                             
                                                          
        }

        private void DefineProperty()
        {
            cboBucketType.ControlValues = BucketType.Weekly;

            if (Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) != null)
            {
                sMyDeptID = Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId, UserInfoContext.Current["NowGroupID"].ToString()).Rows[0][0].ToString();
            }
        }

        private void CreateSpread()
        {
            this.AddSheet(spdMain, SpdSheet.shtMainFCST, SpdSheet.shtMainFCST, 2, 1, 30);
            this.AddSheet(spdMain, SpdSheet.shtMainPSI, SpdSheet.shtMainPSI, 2, 1, 30);

            siMain = GetSheetInfo(spdMain.Name, SpdSheet.shtMainFCST);
            siMain = GetSheetInfo(spdMain.Name, SpdSheet.shtMainPSI);

            siMain.ChangeSheet(SpdSheet.shtMainFCST);
            InitSpread(SpdSheet.shtMainFCST);

            siMain.ChangeSheet(SpdSheet.shtMainPSI);
            InitSpread(SpdSheet.shtMainPSI);

                            
            siMain.ChangeSheet(SpdSheet.shtMainFCST);

            clbDivisions.SelectedIndexChanged += new System.EventHandler(clbDivision_SelectedIndexChanged);
        }

        private void clbDivision_SelectedIndexChanged(object sender, EventArgs e)
        {
            string sDivision = clbDivisions.ControlValues;          
            string sEndCustomer = string.Empty;

                                                     
            InitSpread(SpdSheet.shtMainFCST);
            InitSpread(SpdSheet.shtMainPSI);
            
            InitSaveDataTable();

            dtTeam = Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision);
            clsCtrl.setListBox(dtTeam, clbTeam, true);

            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);

                                                                                     
            if (sDivision == "40")
            {
              

                DataTable dtCustomer40 = Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
                clsCtrl.setListBox(dtCustomer40, clbEndCustomer,  true);

                sEndCustomer = CString.GetCheckedListValue(dtCustomer40, clbEndCustomer.ControlValues);

                                                                                                                                                                                                                         
                DataTable dtSalesSite40 = Data.ScmSitebyEndCustomer40(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "");
                clsCtrl.setListBox(dtSalesSite40, clbSalesSite, true);
            }
            else
            {


                DataTable dtCustomer = Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam);
                clsCtrl.setListBox(dtCustomer, clbEndCustomer, true);

                sEndCustomer = CString.GetCheckedListValue(dtCustomer, clbEndCustomer.ControlValues);

                DataTable dtSalesSite = Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
                clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);


            }

        }

        private void InitSpread(string sSheetName)
        {
            if (sSheetName == SpdSheet.shtMainFCST)
            {
                GetSpdTitle("", cboBucketType.ControlValues);
                siMain.CreateSheetHeaderColumn(siMain, 2, dtTitle);
                SetSpreadColor();
            }
            else
            {
                dtTitle = GetSpdTitle();
                siMain.CreateSheetHeaderColumn(siMain, 2, dtTitle);
            }
        }

        private void InitEvent()
        {            
            clbDivisions.SelectedIndexChanged += new System.EventHandler(clbDivisions_SelectedIndexChanged);                                      

            FarPoint.Win.Spread.Model.DefaultSheetDataModel dsdm = (FarPoint.Win.Spread.Model.DefaultSheetDataModel)siMain.Sheet(SpdSheet.shtMainFCST).Models.Data;
            dsdm.Changed += new FarPoint.Win.Spread.Model.SheetDataModelEventHandler(shtMainFCSTDataModel_Changed);

            FarPoint.Win.Spread.Model.DefaultSheetDataModel dsdm2 = (FarPoint.Win.Spread.Model.DefaultSheetDataModel)siMain.Sheet(SpdSheet.shtMainPSI).Models.Data;
            dsdm2.Changed += new FarPoint.Win.Spread.Model.SheetDataModelEventHandler(shtMainPSIDataModel_Changed);
        }

        private void InitSaveDataTable()
        {
            dtSave = new DataTable("CustomerFcstSave");
            dtSave.Columns.Add(CAppSetting.StringAction, typeof(string));
            dtSave.Columns.Add(DefColumns.DivisionId, typeof(string));
            dtSave.Columns.Add(DefColumns.PlanWeek, typeof(string));
            dtSave.Columns.Add(DefColumns.CustomerCode, typeof(string));
            dtSave.Columns.Add(DefColumns.ScmSite, typeof(string));
            dtSave.Columns.Add(DefColumns.MeasureGroup, typeof(string));
            dtSave.Columns.Add(DefColumns.Measure, typeof(string));
            dtSave.Columns.Add(DefColumns.ActiveFlag, typeof(string));
            dtSave.Columns.Add(DefColumns.CustomerPSI, typeof(string));
            dtSave.Columns.Add(DefColumns.UploadUOM, typeof(string));
            dtSave.Columns.Add(DefColumns.UploadBucketType, typeof(string));
            dtSave.Columns.Add(DefColumns.BucketType, typeof(string));
            dtSave.Columns.Add(DefColumns.BucketValue, typeof(string));
            dtSave.Columns.Add(DefColumns.BucketYn, typeof(string));
            dtSave.Columns.Add(DefColumns.EDIFCSTFlag, typeof(string));
            dtSave.Columns.Add(DefColumns.UserId, typeof(string));
        }

        #endregion

        #region  4. Button

        protected override void FindButton()
        {
            if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST)
            {
                FindDataFCST();
            }
            else
            {
                FindDataPSI();
            }
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
                if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainPSI)
                {
                    if (siMain.GetColumnIndex(DefColumns.DivisionId) < 0 || siMain.GetColumnIndex(DefColumns.CustomerCode) < 0
                        || siMain.GetColumnIndex(DefColumns.ScmSite) < 0 || siMain.GetColumnIndex(DefColumns.BucketType) < 0
                        || siMain.GetColumnIndex(DefColumns.UploadUOM) < 0 || siMain.GetColumnIndex(DefColumns.CustomerPSI) < 0
                        || siMain.GetColumnIndex(DefColumns.MeasureGroup) < 0 || siMain.GetColumnIndex(DefColumns.Measure) < 0
                        || siMain.GetColumnIndex(DefColumns.UploadBucketType) < 0 || siMain.GetColumnIndex(DefColumns.ActiveFlag) < 0)
                    {
                        MessageHelper.GMessageBox("MSG00113");
                        return;
                    }
                }
                else
                {
                    if (siMain.GetColumnIndex(DefColumns.DivisionId) < 0 || siMain.GetColumnIndex(DefColumns.CustomerCode) < 0
                        || siMain.GetColumnIndex(DefColumns.ScmSite) < 0 || siMain.GetColumnIndex(DefColumns.BucketType) < 0
                        || siMain.GetColumnIndex(DefColumns.UploadUOM) < 0 || siMain.GetColumnIndex(DefColumns.MeasureGroup) < 0
                        || siMain.GetColumnIndex(DefColumns.Measure) < 0 || siMain.GetColumnIndex(DefColumns.UploadBucketType) < 0
                        || siMain.GetColumnIndex(DefColumns.ActiveFlag) < 0)
                    {
                        MessageHelper.GMessageBox("MSG00113");
                        return;
                    }
                }
                siMain = GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex);
                siMain.SwitchLock();

                if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST)
                {
                    for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
                    {
                        if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToString() == CAppSetting.StringY)
                        {
                            siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.PlanWeek), iRow, siMain.GetColumnIndex(DefColumns.UploadBucketType), true);
                            siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.UploadOrder), iRow, siMain.GetColumnIndex(DefColumns.EditFlag), true);
                        }
                        else
                        {
                            if (String.IsNullOrEmpty(siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction))) == true)
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.PlanWeek), iRow, siMain.GetColumnIndex(DefColumns.EditFlag), true);
                            else if (siMain.GetValue(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)).ToString() == CAppSetting.StringI)
                            {
                                if (siMain.GetColumnIndex(DefColumns.BucketType) > 0)
                                {                                    
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.BucketType), iRow, siMain.GetColumnIndex(DefColumns.BucketType), true);
                                }

                                if (siMain.GetColumnIndex(DefColumns.MeasureGroup) > 0)
                                {                                    
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.MeasureGroup), iRow, siMain.GetColumnIndex(DefColumns.MeasureGroup), true);                                    
                                }
                                
                                if (siMain.GetColumnIndex(DefColumns.UpdateDate) > 0)
                                {
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.UpdateDate), iRow, siMain.GetColumnIndex(DefColumns.UpdateUser), true);
                                }
                            }
                        }
                    }
                }
                       
                    
                                                                                                  
                    

                                                                                                                                                   

                if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainPSI)
                {
                                                                                                      
                                                                                                                                         

                    for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
                    {
                        if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToString() == CAppSetting.StringY)
                        {
                            siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.PlanWeek), iRow, siMain.GetColumnIndex(DefColumns.UploadBucketType), true);
                            siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.UpdateDate), iRow, siMain.GetColumnIndex(DefColumns.EditFlag), true);
                        }
                        else
                        {
                            if (String.IsNullOrEmpty(siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction))) == true)
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.PlanWeek), iRow, siMain.GetColumnIndex(DefColumns.EditFlag), true);
                            else if (siMain.GetValue(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)).ToString() == CAppSetting.StringI)
                            {
                                if (siMain.GetColumnIndex(DefColumns.BucketType) > 0)
                                {                                    
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.BucketType), iRow, siMain.GetColumnIndex(DefColumns.BucketType), true);
                                }

                                if (siMain.GetColumnIndex(DefColumns.MeasureGroup) > 0)
                                {                                    
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.MeasureGroup), iRow, siMain.GetColumnIndex(DefColumns.MeasureGroup), true);                                    
                                }
                                
                                if (siMain.GetColumnIndex(DefColumns.UpdateDate) > 0)
                                {
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.UpdateDate), iRow, siMain.GetColumnIndex(DefColumns.UpdateUser), true);
                                }
                            }
                        }
                    }
                }

                                   

                                                                                
                    
                                                                        
                        
                                 
                        
                                 
                    

                                                           
            }
        }

        protected override void SaveButton()
        {
            if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST)
            {
                SaveData(SpdSheet.shtMainFCST);
            }
            else
            {
                SaveData(SpdSheet.shtMainPSI);
            }
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
                                                                                     
            exportOption.AmendDecimalFormat = "#,##0;[Red]-#,##0";
                                                          
                                                                            
                                                           
                                                                               
                                     
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

        private async void FindDataFCST()
        {
            CanModelChange = false;

            GSCM.Windows.Forms.UI.ProgressForm prg = new GSCM.Windows.Forms.UI.ProgressForm();

            try
            {
                string sDivision = clbDivisions.ControlValues;
                string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);

                if (sDivision == "")
                {
                    MessageHelper.GMessageBox("MSG00097");

                    return;
                }

                prg.Show();

                siMain.SpreadObject.SuspendLayout();

                InitSpread(SpdSheet.shtMainFCST);

                SetSpreadColor();

                                 
                SearchStartTime();

                using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
                {
                    var request = new FoxDataRequest("DM.DMF0007_GET_CUST_FCST_DATA");

                    request.Parameters["p_plan_week"] = "";
                    request.Parameters["p_division_id"] = sDivision;                               

                                                                                                         
                                                                                        
                    request.Parameters["p_dept_id"] = "";
                                                                                                         

                    request.Parameters["p_end_customer"] = clbEndCustomer.ControlValues;
                    request.Parameters["p_scm_site_id"] = clbSalesSite.ControlValues;
                    request.Parameters["p_bucket_type"] = cboBucketType.SelectedValue.ToString();
                    request.Parameters["p_valid_yn"] = cboActive.Text;
                    request.Parameters["p_created_by"] = base.UserInfo.UserId;

                    request.Parameters["p_user_group"] = UserInfoContext.Current["NowGroupID"].ToString();
                    var response = client.ExecuteDataSet(request);

                    dsMain = response.DataSet;
                };

                                              
                SearchEndTime();



                siMain.Query(dsMain);
                siMain.LockColumn(0, siMain.GetMaxColumnIndex(), true);

                siMain.SmartColMerge();

                               
                UIEndTime();

                                         

                dtSave.Clear();
            }
            catch (Exception ex)
            {
                MessageHelper.GMessageBoxForException(ex);
            }
            finally
            {
                CanModelChange = true;

                prg.Close();

                siMain.SpreadObject.ResumeLayout();
            }
                           
                                   
                                                               
        }

        private async void FindDataPSI()
        {
                          
            CanModelChange = false;
            GSCM.Windows.Forms.UI.ProgressForm prg = new GSCM.Windows.Forms.UI.ProgressForm();
            try
            {
                string sDivision = clbDivisions.ControlValues;

                if (sDivision == "")
                {
                    MessageHelper.GMessageBox("MSG00097");

                    return;
                }

                prg.Show();

                siMain.SpreadObject.SuspendLayout();
                
                InitSpread(SpdSheet.shtMainPSI);

                                 
                SearchStartTime();

                using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
                {
                    var request = new FoxDataRequest("DM.DMF0007_GET_CUST_PSI_DATA");

                    request.Parameters["p_plan_week"] = "";
                    request.Parameters["p_division_id"] = sDivision;                               

                                                                                                         
                                                                               
                    request.Parameters["p_dept_id"] = "";
                                                                                                         

                    request.Parameters["p_end_customer"] = clbEndCustomer.ControlValues;
                    request.Parameters["p_scm_site_id"] = clbSalesSite.ControlValues;
                    request.Parameters["p_bucket_type"] = cboBucketType.SelectedValue.ToString();
                    request.Parameters["p_valid_yn"] = cboActive.Text;
                    request.Parameters["p_created_by"] = base.UserInfo.UserId;

                    request.Parameters["p_user_group"] = UserInfoContext.Current["NowGroupID"].ToString();
                    var response = client.ExecuteDataSet(request);

                    dsMain = response.DataSet;
                };

                                              
                SearchEndTime();

                siMain.Query(dsMain);
                siMain.LockColumn(0, siMain.GetMaxColumnIndex(), true);

                siMain.SmartColMerge();

                               
                UIEndTime();

                dtSave.Clear();

            }
            catch (Exception ex)
            {
                MessageHelper.GMessageBoxForException(ex);
            }
            finally {
                CanModelChange = true;

                prg.Close();

                siMain.SpreadObject.ResumeLayout();
            }

            
        }

        private async void SaveData(string sSheetName)
        {
            if (siMain != null && siMain.IsLock(siMain.SheetName) == false)
            {
                if (sSheetName == SpdSheet.shtMainFCST)
                {
                    int iCount = 0;

                    string sProcedureName = "DM.DMF0007_SAVE_CUST_FCST_DATA";
                    string sActionFlag = string.Empty;
                    string sPlanYYYYYWW = string.Empty;
                    string sDivisionID = string.Empty;
                    string sCustomerCode = string.Empty;
                    string sScmSite = string.Empty;
                    string sMeasureGroup = string.Empty;
                    string sMeasure = string.Empty;
                    string sActiveFlag = string.Empty;
                    string sCustomerPSI = string.Empty;
                    string sUploadUOM = string.Empty;
                    string sUploadBucketType = string.Empty;
                    string sBucketType = string.Empty;
                    string sEDIFCSTFlag = string.Empty;
                    string sBucketValue = string.Empty;
                    string sBucketYn = string.Empty;
                    string sUserId = string.Empty;

                    foreach (DataRow dr in dtSave.Rows)
                    {
                        if (iCount == 0)
                        {
                            sActionFlag = dr[CAppSetting.StringAction].ToString();
                            sDivisionID = dr[DefColumns.DivisionId].ToString();
                            sPlanYYYYYWW = dr[DefColumns.PlanWeek].ToString();
                            sCustomerCode = dr[DefColumns.CustomerCode].ToString();
                            sScmSite = dr[DefColumns.ScmSite].ToString();
                            sMeasureGroup = dr[DefColumns.MeasureGroup].ToString();
                            sMeasure = dr[DefColumns.Measure].ToString();
                            sActiveFlag = dr[DefColumns.ActiveFlag].ToString();
                            sCustomerPSI = dr[DefColumns.CustomerPSI].ToString();
                            sUploadUOM = dr[DefColumns.UploadUOM].ToString();
                            sUploadBucketType = dr[DefColumns.UploadBucketType].ToString();
                            sBucketType = dr[DefColumns.BucketType].ToString();
                            sEDIFCSTFlag = dr[DefColumns.EDIFCSTFlag].ToString();
                            sBucketValue = dr[DefColumns.BucketValue].ToString();
                            sBucketYn = dr[DefColumns.BucketYn].ToString();
                            sUserId = base.UserInfo.UserId;
                        }
                        else
                        {
                            sActionFlag = sActionFlag + "^" + dr[CAppSetting.StringAction].ToString();
                            sDivisionID = sDivisionID + "^" + dr[DefColumns.DivisionId].ToString();
                            sPlanYYYYYWW = sPlanYYYYYWW + "^" + dr[DefColumns.PlanWeek].ToString();
                            sCustomerCode = sCustomerCode + "^" + dr[DefColumns.CustomerCode].ToString();
                            sScmSite = sScmSite + "^" + dr[DefColumns.ScmSite].ToString();
                            sMeasureGroup = sMeasureGroup + "^" + dr[DefColumns.MeasureGroup].ToString();
                            sMeasure = sMeasure + "^" + dr[DefColumns.Measure].ToString();
                            sActiveFlag = sActiveFlag + "^" + dr[DefColumns.ActiveFlag].ToString();
                            sCustomerPSI = sCustomerPSI + "^" + dr[DefColumns.CustomerPSI].ToString();
                            sUploadUOM = sUploadUOM + "^" + dr[DefColumns.UploadUOM].ToString();
                            sUploadBucketType = sUploadBucketType + "^" + dr[DefColumns.UploadBucketType].ToString();
                            sBucketType = sBucketType + "^" + dr[DefColumns.BucketType].ToString();
                            sEDIFCSTFlag = sEDIFCSTFlag + "^" + dr[DefColumns.EDIFCSTFlag].ToString();
                            sBucketValue = sBucketValue + "^" + dr[DefColumns.BucketValue].ToString();
                            sBucketYn = sBucketYn + "^" + dr[DefColumns.BucketYn].ToString();
                            sUserId = sUserId + "^" + base.UserInfo.UserId;
                        }
                        iCount++;
                    }

                    if (iCount > 0)
                    {
                        for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
                        {
                            string action = siMain.GetText(iRow, 0);

                            if (action != CAppSetting.FlagI && action != CAppSetting.FlagM && action != CAppSetting.FlagD)
                                continue;

                            if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DivisionId)).ToString() == "")
                            {
                                string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnsLabel.DivisionId)
                                            );

                                                                       
                                MessageHelper.GMessageBox("MSG00002", new object[] { args });

                                return;
                            }
                            else if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.CustomerCode)).ToString() == "")
                            {
                                string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnsLabel.CustomerCode)
                                            );

                                                                       
                                MessageHelper.GMessageBox("MSG00002", new object[] { args });

                                return;
                            }
                            else if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ScmSite)).ToString() == "")
                            {
                                string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnsLabel.ScmSite)
                                            );

                                                                       
                                MessageHelper.GMessageBox("MSG00002", new object[] { args });

                                return;
                            }
                            else if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.BucketType)).ToString() == "")
                            {
                                string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnsLabel.BucketType)
                                            );

                                                                       
                                MessageHelper.GMessageBox("MSG00002", new object[] { args });

                                return;
                            }
                            else if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.MeasureGroup)).ToString() == "")
                            {
                                string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnsLabel.MeasureGroup)
                                            );

                                                                       
                                MessageHelper.GMessageBox("MSG00002", new object[] { args });

                                return;
                            }
                            else if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Measure)).ToString().Trim() == "")
                            {
                                string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnsLabel.Measure)
                                            );

                                                                       
                                MessageHelper.GMessageBox("MSG00002", new object[] { args });

                                return;
                            }
                            else if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.UploadUOM)).ToString() == "")
                            {
                                string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnsLabel.UploadUOM)
                                            );

                                                                       
                                MessageHelper.GMessageBox("MSG00002", new object[] { args });

                                return;
                            }
                            else if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.UploadBucketType)).ToString() == "")
                            {
                                string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnsLabel.UploadBucketType)
                                            );

                                                                       
                                MessageHelper.GMessageBox("MSG00002", new object[] { args });

                                return;
                            }
                            else if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ActiveFlag)).ToString() == "")
                            {
                                string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnsLabel.ActiveFlag)
                                            );

                                                                       
                                MessageHelper.GMessageBox("MSG00002", new object[] { args });

                                return;
                            }


                        }

                        try
                        {
                            var asyncProxy = new FoxAsyncProxy(this);

                                                                                    
                                
                            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
                            {
                                var request = new FoxDataRequest(sProcedureName);
                                request.Parameters["p_active_flag"] = sActionFlag;
                                request.Parameters["p_division_id"] = sDivisionID;
                                request.Parameters["p_plan_week"] = sPlanYYYYYWW;
                                request.Parameters["p_customer_code"] = sCustomerCode;
                                request.Parameters["p_scm_site_id"] = sScmSite;
                                request.Parameters["p_measure_group"] = sMeasureGroup;
                                request.Parameters["p_measure"] = sMeasure;
                                request.Parameters["p_valid_yn"] = sActiveFlag;
                                request.Parameters["p_customer_psi"] = sCustomerPSI;
                                request.Parameters["p_upload_uom"] = sUploadUOM;
                                request.Parameters["p_upload_bucket_type"] = sUploadBucketType;
                                request.Parameters["p_summary_bucket_type"] = sBucketType;
                                request.Parameters["p_summary_bucket_value"] = sBucketValue;
                                request.Parameters["p_summary_bucket_yn"] = sBucketYn;
                                request.Parameters["p_edi_fcst_yn"] = sEDIFCSTFlag;
                                request.Parameters["p_created_by"] = sUserId;

                                var response = client.ExecuteDataSet(request);

                                if (response.DataSet.Tables.Count != 0)
                                {
                                    if (response.DataSet.Tables[0].Rows[0][0].ToString() == "MSG00166")
                                    {
                                        MessageHelper.GMessageBox("MSG00166");
                                    }
                                    else
                                    {
                                        MessageHelper.GMessageBox(response.DataSet.Tables[0].Rows[0][0].ToString());
                                    }
                                }
                                else
                                {
                                                                             
                                    MessageHelper.GMessageBox("MSG00004", new object[] { iCount });
                                    FindButton();
                                }
                            };
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
                        MessageHelper.GMessageBox("MSG00141");
                    }
                }
                else
                {
                    int iCount = 0;

                    string sProcedureName = "DM.DMF0007_SAVE_CUST_FCST_DATA";
                    string sActionFlag = string.Empty;
                    string sPlanYYYYYWW = string.Empty;
                    string sDivisionID = string.Empty;
                    string sCustomerCode = string.Empty;
                    string sScmSite = string.Empty;
                    string sMeasureGroup = string.Empty;
                    string sMeasure = string.Empty;
                    string sActiveFlag = string.Empty;
                    string sCustomerPSI = string.Empty;
                    string sUploadUOM = string.Empty;
                    string sUploadBucketType = string.Empty;
                    string sBucketType = string.Empty;
                    string sEDIFCSTFlag = string.Empty;
                    string sBucketValue = string.Empty;
                    string sBucketYn = string.Empty;
                    string sUserId = string.Empty;

                    for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
                    {
                        if (siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI
                            || siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringM)
                        {
                            if (iCount == 0)
                            {
                                sActionFlag = siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction));
                                sPlanYYYYYWW = siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.PlanWeek));
                                sDivisionID = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DivisionId)).ToString();
                                sCustomerCode = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.CustomerCode)).ToString();
                                sScmSite = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ScmSite)).ToString();
                                sMeasureGroup = siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.MeasureGroup));
                                sMeasure = siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.Measure));
                                sActiveFlag = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ActiveFlag)).ToString();
                                sCustomerPSI = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.CustomerPSI)).ToString();
                                sUploadUOM = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.UploadUOM)).ToString();
                                sUploadBucketType = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.UploadBucketType)).ToString();
                                sBucketType = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.BucketType)).ToString();
                                sEDIFCSTFlag = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EDIFCSTFlag)).ToString();
                                sBucketValue = "99999999";
                                sBucketYn = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ActiveFlag)).ToString();
                                sUserId = base.UserInfo.UserId;
                            }
                            else
                            {
                                sActionFlag = sActionFlag + "^" + siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction));
                                sPlanYYYYYWW = sPlanYYYYYWW + "^" + siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.PlanWeek));
                                sDivisionID = sDivisionID + "^" + siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DivisionId)).ToString();
                                sCustomerCode = sCustomerCode + "^" + siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.CustomerCode)).ToString();
                                sScmSite = sScmSite + "^" + siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ScmSite)).ToString();
                                sMeasureGroup = sMeasureGroup + "^" + siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.MeasureGroup));
                                sMeasure = sMeasure + "^" + siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.Measure));
                                sActiveFlag = sActiveFlag + "^" + siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ActiveFlag)).ToString();
                                sCustomerPSI = sCustomerPSI + "^" + siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.CustomerPSI)).ToString();
                                sUploadUOM = sUploadUOM + "^" + siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.UploadUOM)).ToString();
                                sUploadBucketType = sUploadBucketType + "^" + siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.UploadBucketType)).ToString();
                                sBucketType = sBucketType + "^" + siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.BucketType)).ToString();
                                sEDIFCSTFlag = sEDIFCSTFlag + "^" + siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EDIFCSTFlag)).ToString();
                                sBucketValue = sBucketValue + "^" + "99999999";
                                sBucketYn = sBucketYn + "^" + siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ActiveFlag)).ToString();
                                sUserId = sUserId + "^" + base.UserInfo.UserId;
                            }

                            if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DivisionId)).ToString() == "")
                            {
                                string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnsLabel.DivisionId)
                                            );

                                                                       
                                MessageHelper.GMessageBox("MSG00002", new object[] { args });

                                return;
                            }
                            else if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.CustomerCode)).ToString() == "")
                            {
                                string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnsLabel.CustomerCode)
                                            );

                                                                       
                                MessageHelper.GMessageBox("MSG00002", new object[] { args });

                                return;
                            }
                            else if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ScmSite)).ToString() == "")
                            {
                                string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnsLabel.ScmSite)
                                            );

                                                                       
                                MessageHelper.GMessageBox("MSG00002", new object[] { args });

                                return;
                            }
                            else if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.BucketType)).ToString() == "")
                            {
                                string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnsLabel.BucketType)
                                            );

                                                                       
                                MessageHelper.GMessageBox("MSG00002", new object[] { args });

                                return;
                            }
                            else if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.MeasureGroup)).ToString() == "")
                            {
                                string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnsLabel.MeasureGroup)
                                            );

                                                                       
                                MessageHelper.GMessageBox("MSG00002", new object[] { args });

                                return;
                            }
                            else if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Measure)).ToString() == "")
                            {
                                string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnsLabel.Measure)
                                            );

                                                                       
                                MessageHelper.GMessageBox("MSG00002", new object[] { args });

                                return;
                            }
                            else if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.CustomerPSI)).ToString() == "")
                            {
                                string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnsLabel.CustomerPSI)
                                            );

                                                                       
                                MessageHelper.GMessageBox("MSG00002", new object[] { args });

                                return;
                            }
                            else if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.UploadUOM)).ToString() == "")
                            {
                                string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnsLabel.UploadUOM)
                                            );

                                                                       
                                MessageHelper.GMessageBox("MSG00002", new object[] { args });

                                return;
                            }
                            else if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.UploadBucketType)).ToString() == "")
                            {
                                string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnsLabel.UploadBucketType)
                                            );

                                                                       
                                MessageHelper.GMessageBox("MSG00002", new object[] { args });

                                return;
                            }
                            else if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ActiveFlag)).ToString() == "")
                            {
                                string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnsLabel.ActiveFlag)
                                            );

                                                                       
                                MessageHelper.GMessageBox("MSG00002", new object[] { args });

                                return;
                            }

                            iCount++;
                        }
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
                                request.Parameters["p_division_id"] = sDivisionID;
                                request.Parameters["p_plan_week"] = sPlanYYYYYWW;
                                request.Parameters["p_customer_code"] = sCustomerCode;
                                request.Parameters["p_scm_site_id"] = sScmSite;
                                request.Parameters["p_measure_group"] = sMeasureGroup;
                                request.Parameters["p_measure"] = sMeasure;
                                request.Parameters["p_valid_yn"] = sActiveFlag;
                                request.Parameters["p_customer_psi"] = sCustomerPSI;
                                request.Parameters["p_upload_uom"] = sUploadUOM;
                                request.Parameters["p_upload_bucket_type"] = sUploadBucketType;
                                request.Parameters["p_summary_bucket_type"] = sBucketType;
                                request.Parameters["p_summary_bucket_value"] = sBucketValue;
                                request.Parameters["p_summary_bucket_yn"] = sBucketYn;
                                request.Parameters["p_edi_fcst_yn"] = sEDIFCSTFlag;
                                request.Parameters["p_created_by"] = sUserId;

                                var response = client.ExecuteDataSet(request);

                                if (response.DataSet.Tables.Count != 0)
                                {
                                    MessageHelper.GMessageBox(response.DataSet.Tables[0].Rows[0][0].ToString());
                                }
                                else
                                {
                                                                             
                                    MessageHelper.GMessageBox("MSG00004", new object[] { iCount });
                                    FindButton();
                                }
                            };
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
                        MessageHelper.GMessageBox("MSG00141");
                    }
                }
            }
        }

        private void InsertRow()
        {
            if (siMain != null && siMain.IsLock(siMain.SheetName) == false)
            {

                FarPoint.Win.Spread.Cell insCell = siMain.Insert();
                Dictionary<object, object> defaultData = new Dictionary<object, object>();

                int iRow = siMain.ActiveRowIndex;
                string sDivision = clbDivisions.ControlValues;

                                      
                siMain.SetValue(iRow, siMain.GetColumnIndex(DefColumns.DivisionId), sDivision);
                                       
                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.DivisionId), iRow, siMain.GetColumnIndex(DefColumns.DivisionId), true);

                DataTable dtTeamAuth, dtEndCustomerAuth,dtScmSiteAuth  = null;

                dtTeamAuth = Data.UserTeamByDivisionAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision);

                                                                                                     
                                                                                                                        
                                                                                                                              
                string sTeam = "";
                                                                                                     


                if (sDivision == "40")
                {
                    dtEndCustomerAuth = Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
                    siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CustomerCode), dtEndCustomerAuth);
                }
                else {
                    dtEndCustomerAuth = Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam);
                    siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CustomerCode), dtEndCustomerAuth);
                }
                    
                string sEndCustomer = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CustomerCode)).ToString();
                dtScmSiteAuth = Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
                siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ScmSite), dtScmSiteAuth);


                                                        
                if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) {
                    if (siMain.GetColumnIndex(DefColumns.Measure) != -1) {
                        siMain.SetCellTypeCombo(iRow, siMain.GetColumnIndex(DefColumns.Measure), GetCustFcstMeasure());
                    }
                }

                if (siMain.GetColumnIndex(DefColumns.BucketType) > 0)
                {
                    siMain.SetValue(iRow, siMain.GetColumnIndex(DefColumns.BucketType), cboBucketType.SelectedValue);
                    siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.BucketType), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.BucketType), true);
                }

                if (siMain.GetColumnIndex(DefColumns.MeasureGroup) > 0)
                {
                    if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST)
                    {
                        siMain.SetValue(iRow, siMain.GetColumnIndex(DefColumns.MeasureGroup), "CUST_FCST");
                        siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.MeasureGroup), iRow, siMain.GetColumnIndex(DefColumns.MeasureGroup), true);
                    }
                    else
                    {
                        siMain.SetValue(iRow, siMain.GetColumnIndex(DefColumns.MeasureGroup), "PSI");
                        siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.MeasureGroup), iRow, siMain.GetColumnIndex(DefColumns.MeasureGroup), true);
                    }
                }
                if (siMain.GetColumnIndex(DefColumns.EDIFCSTFlag) > 0)
                {
                    siMain.SetValue(iRow, siMain.GetColumnIndex(DefColumns.EDIFCSTFlag), CAppSetting.StringY);
                }

                if (siMain.GetColumnIndex(DefColumns.ActiveFlag) > 0)
                {
                    siMain.SetValue(iRow, siMain.GetColumnIndex(DefColumns.ActiveFlag), CAppSetting.StringY);
                }

                if (siMain.GetColumnIndex(DefColumns.UpdateDate) > 0)
                {
                    siMain.LockRange(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.UpdateDate), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.UpdateUser), true);
                }               
            }
        }

        #endregion

        #region 6. Event
        protected void shtMainFCSTDataModel_Changed(object sender, FarPoint.Win.Spread.Model.SheetDataModelEventArgs e)
        {
            if (!this.CanModelChange) return;

            switch (e.Type)
            {
                case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated:
                    if (this.CanModelChange && e.Row > -1 && e.Column > 0 && e.Column <= siMain.GetColumnIndex(DefColumns.Measure))
                    {
                                      
                        if (e.Column == siMain.GetColumnIndex(DefColumns.Measure) 
                            && siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Measure)).ToString()  == "CUST_FCST") {

                            MessageHelper.GMessageBox("MSG00379");
                                                                                      
                            siMain.SetText(e.Row, e.Column, "");

                            return;
                        }
                                 
                        string sActionFlag = siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction));

                        if (sActionFlag == CAppSetting.StringI)
                        {
                            string sDivisionID = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DivisionId)).ToString();
                            string sCustomerCode = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.CustomerCode));
                            string sScmSite = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ScmSite)).ToString();
                            string sMeasureGroup = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.MeasureGroup)).ToString();
                            string sMeasure = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Measure)).ToString();
                            int iCheck = 0;

                            if (sDivisionID != "" && sCustomerCode != "" && sScmSite != "" && sMeasureGroup != "")
                            {
                                for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
                                {
                                    if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DivisionId)).ToString() == sDivisionID
                                        && siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.CustomerCode)) == sCustomerCode
                                        && siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ScmSite)).ToString() == sScmSite
                                        && siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.MeasureGroup)).ToString() == sMeasureGroup
                                        && siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.Measure)).ToString() == sMeasure
                                       )
                                    {
                                        iCheck++;
                                    }

                                }

                                if (iCheck > 1)
                                {
                                                
                                    MessageHelper.GMessageBox("MSG00136");
                                                                                                
                                    siMain.SetText(e.Row, e.Column, "");

                                    return;
                                }
                            }
                        }
                    }
                    else if (this.CanModelChange && e.Row > -1 && e.Column == siMain.GetColumnIndex(DefColumns.ActiveFlag))
                    {
                        string sActionFlag = siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction));

                        if (sActionFlag == CAppSetting.StringM)
                        {
                            string sActiveFlag = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.ActiveFlag));

                            for (int iCOl = siMain.GetColumnIndex(DefColumns.ActiveFlag) + 1; iCOl <= siMain.GetMaxColumnIndex(); iCOl++)
                            {
                                if (sActiveFlag == CAppSetting.StringN)
                                {
                                    if (siMain.GetText(e.Row, iCOl) == CAppSetting.StringY)
                                    {
                                        siMain.SetText(e.Row, iCOl, sActiveFlag);
                                    }
                                }
                            }
                        }
                        else if (sActionFlag == CAppSetting.StringI)
                        {
                            string sDivisionID = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DivisionId)).ToString();
                            string sCustomerCode = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.CustomerCode));
                            string sScmSite = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ScmSite)).ToString();
                            string sMeasureGroup = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.MeasureGroup)).ToString();
                            string sMeasure = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Measure)).ToString();
                            string sActiveFlag = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.ActiveFlag));
                            string sUploadUOM = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.UploadUOM)).ToString();
                            string sUploadBucketType = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.UploadBucketType)).ToString();

                            if (sDivisionID == "" || sCustomerCode == "" || sScmSite == "" || sMeasureGroup == "" || sMeasure == "" || sUploadUOM == "" || sUploadBucketType == "")
                            {
                                return;
                            }

                            for (int iCol = siMain.GetColumnIndex(DefColumns.ActiveFlag) + 1; iCol <= siMain.GetMaxColumnIndex(); iCol++)
                            {
                                if (sActiveFlag == CAppSetting.StringN)
                                {
                                    if (siMain.GetText(e.Row, iCol) == CAppSetting.StringY)
                                    {
                                        siMain.SetText(e.Row, iCol, sActiveFlag);
                                    }
                                }
                            }
                        }
                    }
                    else if (this.CanModelChange && e.Row > -1 && e.Column > siMain.GetColumnIndex(DefColumns.ActiveFlag))
                    {
                        string sActionFlag = siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction));
                        string sPlanYYYYYWW = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.PlanWeek));
                        string sDivisionID = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DivisionId)).ToString();
                        string sCustomerCode = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.CustomerCode));
                        string sScmSite = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ScmSite)).ToString();
                        string sMeasureGroup = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.MeasureGroup)).ToString();
                        string sMeasure = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Measure)).ToString();
                        string sActiveFlag = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.ActiveFlag));

                        string sCustomerPSI = string.Empty;

                        string sUploadUOM = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.UploadUOM)).ToString();
                        string sUploadBucketType = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.UploadBucketType)).ToString();
                        string sBucketType = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.BucketType)).ToString();
                        string sEDIFCSTFlag = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.EDIFCSTFlag));
                        string sBucketValue = siMain.GetColumnTag(e.Column).Replace("D_", "").Substring(0, 8);
                        string sBucketYn = siMain.GetText(e.Row, e.Column);

                        int iCheck = 0;

                        if (sBucketYn == "")
                        {
                            sBucketYn = CAppSetting.StringN;
                            siMain.SetValue(e.Row, e.Column, sBucketYn);
                        }

                        if (sDivisionID == "")
                        {
                            string args = string.Format("{0}"
                                        , MessageHelper.GetTerm(DefColumnsLabel.DivisionId)
                                        );

                                                                   
                            MessageHelper.GMessageBox("MSG00002", new object[] { args });

                            return;
                        }
                        else if (sCustomerCode == "")
                        {
                            string args = string.Format("{0}"
                                        , MessageHelper.GetTerm(DefColumnsLabel.CustomerCode)
                                        );

                                                                   
                            MessageHelper.GMessageBox("MSG00002", new object[] { args });

                            return;
                        }
                        else if (sScmSite == "")
                        {
                            string args = string.Format("{0}"
                                        , MessageHelper.GetTerm(DefColumnsLabel.ScmSite)
                                        );

                                                                   
                            MessageHelper.GMessageBox("MSG00002", new object[] { args });

                            return;
                        }
                        else if (sBucketType == "")
                        {
                            string args = string.Format("{0}"
                                        , MessageHelper.GetTerm(DefColumnsLabel.BucketType)
                                        );

                                                                   
                            MessageHelper.GMessageBox("MSG00002", new object[] { args });

                            return;
                        }
                        else if (sMeasureGroup == "")
                        {
                            string args = string.Format("{0}"
                                        , MessageHelper.GetTerm(DefColumnsLabel.MeasureGroup)
                                        );

                                                                   
                            MessageHelper.GMessageBox("MSG00002", new object[] { args });

                            return;
                        }
                        else if (sMeasure.Trim() == "")
                        {
                            string args = string.Format("{0}"
                                        , MessageHelper.GetTerm(DefColumnsLabel.Measure)
                                        );

                                                                   
                            MessageHelper.GMessageBox("MSG00002", new object[] { args });

                            return;
                        }
                        else if (sUploadUOM == "")
                        {
                            string args = string.Format("{0}"
                                        , MessageHelper.GetTerm(DefColumnsLabel.UploadUOM)
                                        );

                                                                   
                            MessageHelper.GMessageBox("MSG00002", new object[] { args });

                            return;
                        }
                        else if (sUploadBucketType == "")
                        {
                            string args = string.Format("{0}"
                                        , MessageHelper.GetTerm(DefColumnsLabel.UploadBucketType)
                                        );

                                                                   
                            MessageHelper.GMessageBox("MSG00002", new object[] { args });

                            return;
                        }
                        else if (sActiveFlag == "")
                        {
                            string args = string.Format("{0}"
                                        , MessageHelper.GetTerm(DefColumnsLabel.ActiveFlag)
                                        );

                                                                   
                            MessageHelper.GMessageBox("MSG00002", new object[] { args });

                            return;
                        }

                        for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
                        {
                            if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DivisionId)).ToString() == sDivisionID
                                && siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.CustomerCode)) == sCustomerCode
                                && siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ScmSite)).ToString() == sScmSite
                                && siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.MeasureGroup)).ToString() == sMeasureGroup
                                                                                                                             
                                && siMain.GetValue(iRow, e.Column).ToString() == CAppSetting.StringY
                               )
                            {
                                iCheck++;
                            }

                        }

                        if (iCheck > 1)
                        {
                                        
                            MessageHelper.GMessageBox("MSG00136");
                                                                                        
                            siMain.SetText(e.Row, e.Column, "");

                            return;
                        }

                        SetSaveData(sActionFlag, sDivisionID, sPlanYYYYYWW, sCustomerCode, sScmSite, sMeasureGroup
                                    , sMeasure, sActiveFlag, sCustomerPSI, sUploadUOM, sUploadBucketType
                                    , sBucketType, sBucketValue, sBucketYn, sEDIFCSTFlag);
                            
                    }
                    break;
            }
        }

        protected void shtMainPSIDataModel_Changed(object sender, FarPoint.Win.Spread.Model.SheetDataModelEventArgs e)
        {
            if (!this.CanModelChange) return;

            if (e.Column <= 0) return;

            switch (e.Type)
            {
                case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated:
                    if (this.CanModelChange && e.Row > -1 && e.Column <= siMain.GetColumnIndex(DefColumns.ActiveFlag))
                    {
                                                                                      
                            
                        string sActionFlag = siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction));
                        string sPlanYYYYYWW = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.PlanWeek));
                        string sDivisionID = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DivisionId)).ToString();
                        string sCustomerCode = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.CustomerCode));
                        string sScmSite = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ScmSite)).ToString();
                        string sMeasureGroup = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.MeasureGroup)).ToString();
                        string sMeasure = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Measure)).ToString();
                        string sActiveFlag = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.ActiveFlag));
                        string sCustomerPSI = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.CustomerPSI)).ToString();
                        string sUploadUOM = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.UploadUOM)).ToString();
                        string sUploadBucketType = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.UploadBucketType)).ToString();
                        string sBucketType = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.BucketType)).ToString();
                        string sEDIFCSTFlag = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.EDIFCSTFlag));

                        int iCheck = 0;

                        if (sDivisionID == "" || sCustomerCode == "" || sScmSite == "" || sBucketType == ""
                             || sMeasureGroup == "" || sCustomerPSI == "")
                        {
                            return;
                        }

                        for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
                        {
                            if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DivisionId)).ToString() == sDivisionID
                                && siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.CustomerCode)) == sCustomerCode
                                && siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ScmSite)).ToString() == sScmSite
                                && siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.MeasureGroup)).ToString() == sMeasureGroup
                                && siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.CustomerPSI)).ToString() == sCustomerPSI
                               )
                            {
                                iCheck++;
                            }

                            if (iCheck > 1)
                            {
                                                                                            
                                MessageHelper.GMessageBox("MSG00136");
                                siMain.SetText(e.Row, e.Column, "");

                                return;
                            }
                        }
                    }
                    break;
            }
        }

        private void spdMain_ComboSelChange(object sender, FarPoint.Win.Spread.EditorNotifyEventArgs e)
        {
            DataService.FP_Log2("SpeedUp", "DMF0007", "spdMain_id_changed", "start");                                     

                                              
            string sDivision = clbDivisions.ControlValues;
            string sTeam = CAppSetting.StringALL;
            string sEndCustomer = CAppSetting.StringALL;

                                                                                                 
               
                                                                      
              
                                                                                                     
                                       
                  
                                                                                                                                                                                    
                                                                                                                   
                  
                       
                                                                                                                                                                 
                                                                                                                   
                  
                                                                                                                  
                                                                                                                                                        
                                                                                                      
              
                   if (e.Column == siMain.GetColumnIndex(DefColumns.CustomerCode))
            {
                sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.CustomerCode)).ToString();
                                                          
                                                                                                                                                               
                SetChangeControl("UserSiteByEndCustomer", sDivision, string.Empty, sEndCustomer);
                                                        
                siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.ScmSite), dtScmSite);
            }
            DataService.FP_Log2("SpeedUp", "DMF0007", "spdMain_id_changed", "end");                                     
        }

                                                  
        private void clbDivisions_SelectedIndexChanged(object sender, EventArgs e)
        {
            DataService.FP_Log2("SpeedUp", "DMF0007", "division_id_changed", "start");                                     
            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues);

            if (siMain != null)
            {
                InitSpread(siMain.ActiveSheet.SheetName);
                InitSaveDataTable();
            }
            SetChangeControl("UserTeamByDivision", sDivision);
            clsCtrl.setListBox(dtTeam, clbTeam, true);

            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);

            SetChangeControl("EndCustomerByDivision", sDivision, sTeam);
            clsCtrl.setListBox(dtEndCustomer, clbEndCustomer, true);

            string sEndCustomer = CString.GetCheckedListValue(dtEndCustomer, clbEndCustomer.ControlValues);

            SetChangeControl("UserSiteByEndCustomer", sDivision, sTeam, sEndCustomer);
            clsCtrl.setListBox(dtScmSite, clbSalesSite, true);
            DataService.FP_Log2("SpeedUp", "DMF0007", "division_id_changed", "end");                                     
        }
                                                


        private void clbTeam_SelectedIndexChanged(object sender, EventArgs e)
        {
            DataService.FP_Log2("SpeedUp", "DMF0007", "team_id_changed", "start");                                     

            string sDivision = clbDivisions.ControlValues;
            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);
            
                                                      
                                                                                                                                                           
            SetChangeControl("EndCustomerByDivision", sDivision, sTeam);
                                                    
            clsCtrl.setListBox(dtEndCustomer, clbEndCustomer, true);

            string sEndCustomer = CString.GetCheckedListValue(dtEndCustomer, clbEndCustomer.ControlValues);

                                                      
                                                                                                                                                      
            SetChangeControl("UserSiteByEndCustomer", sDivision, string.Empty, sEndCustomer);
                                                    
            clsCtrl.setListBox(dtScmSite, clbSalesSite, true);

            DataService.FP_Log2("SpeedUp", "DMF0007", "team_id_changed", "end");                                     
        }

        private void clbEndCustomer_SelectedIndexChanged(object sender, EventArgs e)
        {
            DataService.FP_Log2("SpeedUp", "DMF0007", "team_id_changed", "start");                                     

            string sDivision =  clbDivisions.ControlValues;
            string sEndCustomer = CString.GetCheckedListValue(dtEndCustomer, clbEndCustomer.ControlValues);

                                                      
                                                                                                                                                      
            SetChangeControl("UserSiteByEndCustomer", sDivision, string.Empty, sEndCustomer);
                                                    

            clsCtrl.setListBox(dtScmSite, clbSalesSite, true);

            DataService.FP_Log2("SpeedUp", "DMF0007", "team_id_changed", "end");                                     
        }

        private void cboBucketType_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (siMain != null)
            {
                if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST)
                {
                    InitSpread(SpdSheet.shtMainFCST);
                }
                else
                {
                    InitSpread(SpdSheet.shtMainPSI);
                }
            }
        }


        private void spdMain_ActiveSheetChanged(object sender, EventArgs e)
        {
            if (siMain == null) return;

            if (spdMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST)
            {
                siMain.ChangeSheet(SpdSheet.shtMainFCST);
            }
            else
            {
                siMain.ChangeSheet(SpdSheet.shtMainPSI);
            }
        }

        #endregion

        private void SetSaveData(string sActionFlag, string sDivision, string sPlanWeek, string sCustomerCode, string sScmSite, string sMeasureGroup
                               , string sMeasure, string sActiveFlag, string sCustomerPSI, string sUploadUOM, string sUploadBucketType
                               , string sBucketType, string sBucketValue, string sBucketYn, string sEDIFCSTFlag)
        {
            string sFilter = DefColumns.DivisionId + "= '" + sDivision + "'";
            sFilter += " and " + DefColumns.PlanWeek + " = '" + sPlanWeek + "'";
            sFilter += " and " + DefColumns.CustomerCode + " = '" + sCustomerCode + "'";
            sFilter += " and " + DefColumns.ScmSite + " = '" + sScmSite + "'";
            sFilter += " and " + DefColumns.BucketValue + " = '" + sBucketValue + "'";
            sFilter += " and " + DefColumns.MeasureGroup + " = '" + sMeasureGroup + "'";
            sFilter += " and " + DefColumns.Measure + " = '" + sMeasure + "'";
                                                                                         

            DataRow[] drFind = dtSave.Select(sFilter);

            if (drFind.Length == 0)
            {
                DataRow drNew = dtSave.NewRow();
                drNew[CAppSetting.StringAction] = sActionFlag;
                drNew[DefColumns.DivisionId] = sDivision;
                drNew[DefColumns.PlanWeek] = sPlanWeek;
                drNew[DefColumns.CustomerCode] = sCustomerCode;
                drNew[DefColumns.ScmSite] = sScmSite;
                drNew[DefColumns.MeasureGroup] = sMeasureGroup;
                drNew[DefColumns.Measure] = sMeasure;
                drNew[DefColumns.ActiveFlag] = sActiveFlag;
                drNew[DefColumns.CustomerPSI] = sCustomerPSI;
                drNew[DefColumns.UploadUOM] = sUploadUOM;
                drNew[DefColumns.UploadBucketType] = sUploadBucketType;
                drNew[DefColumns.BucketType] = sBucketType;
                drNew[DefColumns.BucketValue] = sBucketValue;
                drNew[DefColumns.BucketYn] = sBucketYn;
                drNew[DefColumns.EDIFCSTFlag] = sEDIFCSTFlag;

                dtSave.Rows.Add(drNew);
                dtSave.AcceptChanges();
            }
            else
            {
                drFind[0][DefColumns.UploadUOM] = sUploadUOM;
                drFind[0][DefColumns.UploadBucketType] = sUploadBucketType;
                drFind[0][DefColumns.BucketValue] = sBucketValue;
                drFind[0][DefColumns.BucketYn] = sBucketYn;
                dtSave.AcceptChanges();
            }
        }

        private void GetSpdTitle(string sPlanWeek, string sBucketType)
        {
            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                var request = new FoxDataRequest("DM.DMF0007_GET_SPREAD_TITLE");
                request.Parameters["p_plan_week"] = sPlanWeek;              
                request.Parameters["p_bucket_type"] = sBucketType;              
                request.Parameters["p_created_by"] = base.UserInfo.UserId; ;              

                dtTitle = client.ExecuteDataSet(request).DataSet.Tables[0];
            }
        }

        private DataTable GetSpdTitle()
        {
            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                DataTable dt = null;

                dt = Data.Common(Data.Type.SpreadTitle, false, "DMF0007", SpdSheet.shtMainPSI);

                return dt;
            }
        }

        private void SetSpreadColor()
        {
            if (siMain.ActiveSheet.SheetName != SpdSheet.shtMainFCST) return;

            if (cboBucketType.SelectedValue.ToString() != BucketType.Daily) return;

            siMain.SpreadObject.SuspendLayout();

            int iStartCol = siMain.GetColumnIndex(DefColumns.ActiveFlag) + 1;                               


            for (int iCol = iStartCol; iCol <= siMain.GetMaxColumnIndex(); iCol++)
            {
                if (siMain.GetColumnText(0, iCol) == DefColumnsLabel.Saturday || siMain.GetColumnText(0, iCol) == DefColumnsLabel.Sunday)
                {
                    siMain.ActiveSheet.ColumnHeader.Cells[0, iCol, 1, iCol].ForeColor = siMain.GetColumnText(0, iCol) == DefColumnsLabel.Saturday ? Color.Blue : Color.Red;
                }
            }

            siMain.SpreadObject.ResumeLayout();
        }

        private DataTable GetCustFcstMeasure()
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                var request = new FoxDataRequest("DM.UP_FX_GetCommonDataList_DM");
                request.Parameters["CODE"] = "CUST_FCST_MEASURE";
                request.Parameters["PARAM1"] = clbDivisions.ControlValues;
                request.Parameters["PARAM2"] = "";
                request.Parameters["PARAM3"] = "";
                request.Parameters["PARAM4"] = "";
                request.Parameters["PARAM5"] = "";
                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }
            return dt;
        }

    }
}
