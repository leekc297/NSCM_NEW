using GSCM.App.Core.Security;
using GSCM.App.Core.Text;
using GSCM.Windows.Forms.Class;
using GSCM.Windows.Forms.UI;
using GSCM.Windows.Forms.Utility;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using TheOne.ServiceModel.Data;
using TheOne.Windows.Forms;
using TheOne.ServiceModel.Biz;

using System.Collections.Specialized;
using Newtonsoft.Json;
                                   
using GSCM.SCM.Popup.UIL;
using TheOne.Diagnostics;

using FarPoint.Win.Spread;
using System.Windows.Forms;

using FarPoint.Win.Spread.CellType;
using System.Threading.Tasks;
using GSCM.DM.Plan.UIL;
using GSCM.FP.Common.UIL.Service;


                                                                                                                            
                  
                  
                  
                                                                                                                            
                                          
                                                                                                                            
                                                                              
                                                                      
                                                                                        
                                                                                                                           

namespace GCSM.DM.Master.UIL
{
    public partial class DMF0006_CustomerModelMapping : BaseForm
    {
                      
                   
                       
        #region 1. Setting
        CControl clsCtrl = null; 
        private DataTable dtDivision = null;
        private DataTable dtSalesSite = null;
        private DataTable dtTeam = null;
        private DataTable dtEndCustomer = null;
        private DataSet dsSpdTitle = null;
        private DataTable dtCustomer = null;

        private bool blnWork = false;

        private string sBinding = "GSCM.DM.Master.WSL/FoxDataService.svc";
        private string sScmBinding = "GSCM.SCM.Master.WSL/FoxDataService.svc";
                           
        private DataSet saveDS = null;
                        
        IFoxLog log = FoxLogManager.GetLogger("DMF0006_CustomerModelMapping.Log");
                  
        SpreadInfo siMain = null;

        TextCellType cellTypeImage = null;

                    
        FarPoint.Win.Spread.Model.DefaultSheetDataModel dsdm;                                                                                                  

                      
                       
                       
        private struct SpdSheet
        {
            public static string shtMain = "Customer Model Mapping";
        }

                      
                  
                       
        private struct DefColumns
        {
               
            public static string DIVISION_ID = "DIVISION_ID";
            public static string SCM_SITE_ID = "SCM_SITE_ID";
            
            public static string UPPER_DEPT_ID = "UPPER_DEPT_ID";
            public static string DEPT_ID = "DEPT_ID";
            public static string DEPT_NAME = "DEPT_NAME_KO";
            public static string TEAM_ID = "DEPT_ID";
            public static string TEAM_NAME = "TEAM_NAME_KO";
            public static string TEAM_INCHARGE = "TEAM_INCHARGE";

            public static string END_CUSTOMER = "END_CUSTOMER";
            public static string PROJECT_CODE = "PROJECT_CODE";
            public static string PROJECT_NAME = "PROJECT_NAME";
            public static string ITEM_CLASS_NAME = "ITEM_CLASS_NAME";
            public static string ITEM_NAME = "ITEM_NAME";
            public static string ITEM_ID = "ITEM_ID";
            public static string CUSTOMER_PROJECT_CODE = "CUSTOMER_PROJECT_CODE";
            public static string CUSTOMER_MODEL = "CUSTOMER_MODEL";
            public static string CONVERT_QTY_PACK = "CONVERT_QTY_PACK";
            public static string CONVERT_QTY_MODULE = "CONVERT_QTY_MODULE";
            public static string CONVERT_QTY_CELL = "CONVERT_QTY_CELL";
            public static string CAPACITY = "CAPACITY";
            public static string VALID_YN = "VALID_YN";
            public static string LAST_UPDATE_DATE = "LAST_UPDATE_DATE";
            public static string LAST_UPDATED_BY = "LAST_UPDATED_BY";
            public static string AUTHORITY_YN = "AUTHORITY_YN";

        }

        #endregion

        #region 2. Construct

        public DMF0006_CustomerModelMapping()
        {
            InitializeComponent();

                      
            this.Load += Form_Load;
        }

        private void Form_Load(object sender, EventArgs e)
        {
            clsCtrl = new CControl(this);
            InitForm();
                              
            InitControls();
            CreateSpread();
            DefineProperty();
        }

        private void InitControls()
        {
            dtDivision = null;

            dtDivision = Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
            clsCtrl.setListBox(dtDivision, clbDivisions, false, "CODE", "NAME");
            string sDivision = clbDivisions.ControlValues;

            dtTeam = Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision);
            clsCtrl.setListBox(dtTeam, clbTeam, true);

            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);

            if (sDivision == "40")
            {
                dtEndCustomer = Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
            }
            else
            {
                dtEndCustomer = Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam);
            }

            clsCtrl.setListBox(dtEndCustomer, clbEndCustomer, true);

            string sEndCustomer = CString.GetCheckedListValue(dtEndCustomer, clbEndCustomer.ControlValues);

            dtSalesSite = Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivisions.ControlValues, sEndCustomer);
            clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);

                             
            clsCtrl.setListBox(dtYesOrNo, cboActive, true,"Y");
        }     

        #endregion

        #region 3. Define

        private void DefineProperty()
        {
            usrConditionPanel1.Height = 70;

            siMain.ImagePopUp = imageList1.Images[0];

            cellTypeImage = new TextCellType();
            cellTypeImage.BackgroundImage = new FarPoint.Win.Picture(siMain.ImagePopUp);
            cellTypeImage.BackgroundImage.AlignHorz = FarPoint.Win.HorizontalAlignment.Right;
            cellTypeImage.CharacterCasing = CharacterCasing.Upper;

            this.umltProject.KeyDown += new System.Windows.Forms.KeyEventHandler(this.umltProject_KeyDown);
            this.umltModel.KeyDown += new System.Windows.Forms.KeyEventHandler(this.umltModel_KeyDown);
        }

        private void umltProject_KeyDown(object sender, System.Windows.Forms.KeyEventArgs e)
        {
            if (e.KeyCode == System.Windows.Forms.Keys.Enter)
            {
                btnProject_Click(null, null);
            }
        }

        private void umltModel_KeyDown(object sender, System.Windows.Forms.KeyEventArgs e)
        {
            if (e.KeyCode == System.Windows.Forms.Keys.Enter)
            {
                btnModelType_Click(null, null);
            }
        }

        

        private void CreateSpread()
        {
            this.AddSheet(spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30);
            siMain = GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex);
            siMain.ChangeSheet();

            InitSpread();

            clbDivisions.SelectedIndexChanged += new System.EventHandler(clbDivision_SelectedIndexChanged);

                        
            dsdm = (FarPoint.Win.Spread.Model.DefaultSheetDataModel)siMain.Sheet(SpdSheet.shtMain).Models.Data;
            dsdm.Changed += Dsdm_Changed;
        }

        private void InitSpread()
        {
                            
            DataTable dtTitle = GetSpdTitle();
            siMain.CreateSheetHeaderColumn(siMain, 1, dtTitle);

            InitSpread_X();
        }

        private DataTable dtYesOrNo = Data.Common(Data.Type.YesOrNo);
        private void InitSpread_X()
        {
                     
            siMain.SetColumnMerge(siMain.GetColumnIndex(DefColumns.PROJECT_CODE), FPMerge.None);

            siMain.Freeze(0, 0);                                               
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
                siMain.Delete();
        }

        protected override void EditButton()
        {
            if (this.fps != null)
            {
                siMain = GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex);
                siMain.SwitchLock();
                                                                                                      
                                 
                siMain.LockColumn(siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), true);
                siMain.LockColumn(siMain.GetColumnIndex(DefColumns.PROJECT_NAME), siMain.GetColumnIndex(DefColumns.CUSTOMER_MODEL), true);
                siMain.LockColumn(siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), siMain.GetColumnIndex(DefColumns.CAPACITY), true);
                siMain.LockColumn(siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), true);
                siMain.LockColumn(siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), true);
                

                for (int i = 0; i <= siMain.GetMaxRowIndex(); i++)
                {
                    if (siMain.GetValue(i, siMain.GetColumnIndex(CAppSetting.StringAction)).ToString() == CAppSetting.StringI)
                    {
                        siMain.LockRange(i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), false);
                        siMain.LockRange(i, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), i, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), true);
                        siMain.LockRange(i, siMain.GetColumnIndex(DefColumns.ITEM_ID), i, siMain.GetColumnIndex(DefColumns.ITEM_ID), false);
                        siMain.LockRange(i, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), i, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), true);
                        siMain.LockRange(i, siMain.GetColumnIndex(DefColumns.ITEM_NAME), i, siMain.GetColumnIndex(DefColumns.ITEM_NAME), true);
                        siMain.LockRange(i, siMain.GetColumnIndex(DefColumns.CAPACITY), i, siMain.GetColumnIndex(DefColumns.CAPACITY), true);
                        siMain.LockRange(i, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), i, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), true);
                        siMain.LockRange(i, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), i, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), true);
                    }
                    else
                    {
                        string sType = siMain.GetText(i, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME));
                        if (sType.ToUpper().IndexOf("MODULE") >= 0)
                        {
                            siMain.LockRange(i, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_CELL), i, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_CELL), true);
                                                                                                                                                                    
                        }
                        else if (sType.ToUpper().IndexOf("CELL") >= 0)
                        {
                                                                                                                                                                        
                                                                                                                                                                    
                        }
                        else if (sType.ToUpper().IndexOf("PACK") >= 0)
                        {
                            siMain.LockRange(i, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_CELL), i, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_CELL), true);
                            siMain.LockRange(i, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_MODULE), i, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_MODULE), true);
                        }
                    }

                                 
                    string AUTHORITY_YN = siMain.GetText(i, siMain.GetColumnIndex(DefColumns.AUTHORITY_YN));
                    if(AUTHORITY_YN == "N")
                        siMain.LockRange(i, 0, i, siMain.GetMaxColumnIndex(), true);
                    
                }

            }
        }

        protected override void SaveButton()
        {
                                 

            SaveData_DataService();
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
            exportOption.AmendZeroOption = ZeroOption.ShowZero;
                                        
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

        private async void FindData(bool blnInsert,int iUpdateRow=0, int iUpdateCol = 0)
        {   
            try
            {
                             
                if (blnWork)
                {
                                                             
                    MessageHelper.GMessageBox("MSG00137");
                    return;
                }
                          
                blnWork = true;

                         
                string p_division_id = clbDivisions.ControlValues;                               
                string p_scm_site_id = clbSalesSite.ControlValues;
                string p_project_code = umltProject.Text;                                                                
                string p_item_id = umltModel.Text;                                                                    
                string p_customer_project_code = umltCustomerPJT.Text;
                string p_customer_model = umltCustomerModel.Text;
                string p_valid_yn = cboActive.Text;

                if (p_division_id == "")
                {
                    MessageHelper.GMessageBox("MSG00097");
                    return;
                }

                CanModelChange = false;
                                
                siMain.RemoveRowAll();
                                           

                var asyncProxy = new FoxAsyncProxy(this);

                var ds = await asyncProxy.ExecuteAsync<DataSet>(() =>
                {
                    using (var client = new FoxDataClient("GSCM", "GSCM.DM.Master.WSL/FoxDataService.svc"))
                    {
                        var request = new FoxDataRequest("DM.DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA");
                        
                        request.Parameters["p_division_id"] = p_division_id;
                        request.Parameters["p_dept_id"] = clbTeam.ControlValues;
                        request.Parameters["p_end_customer"] = clbEndCustomer.ControlValues;
                        request.Parameters["p_scm_site_id"] = p_scm_site_id;
                        request.Parameters["p_project_code"] = p_project_code;
                        request.Parameters["p_item_id"] = p_item_id;
                        request.Parameters["p_customer_project_code"] = p_customer_project_code;
                        request.Parameters["p_customer_model"] = p_customer_model;
                        request.Parameters["p_valid_yn"] = p_valid_yn;
                        request.Parameters["p_created_by"] = UserInfoContext.Current.UserId;
                        request.Parameters["p_userinfo"] = UserInfoContext.Current["NowGroupID"];
                        var response = client.ExecuteDataSet(request);

                        return response.DataSet;
                    }
                });

                siMain.Query(ds);
                siMain.LockColumn(0, siMain.GetMaxColumnIndex(), true);

                                                 
                siMain.SmartColMerge();

                                 
                for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
                {
                    if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME) > 0)
                    {
                        siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType = cellTypeImage;
                    }

                    if (siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME) > 0)
                    {
                        siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType = cellTypeImage;
                    }

                    if ((iRow % 100) == 0)
                        Application.DoEvents();
                }

                                   
                                                                                      

                                      
                                                  

                                                    
                if (!blnInsert)
                {
                    siMain.ActiveSheet.SetActiveCell(iUpdateRow, iUpdateCol);
                    spdMain.ShowActiveCell(FarPoint.Win.Spread.VerticalPosition.Center, FarPoint.Win.Spread.HorizontalPosition.Center);
                }

                CanModelChange = true;

                blnWork = false;
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

        private async void SaveData_DataService()
        {
            try
            {
                                    
                bool blnInsert = false;

                             
                if (blnWork)
                {
                    MessageHelper.GMessageBox("MSG00137");
                    return;
                }
                          
                blnWork = true;

                        
                       
                string sUserId = base.UserInfo.UserId;

                bool blnLock = siMain.IsLock(siMain.SheetName);   

                                      
                                      

                            
                for (int i = 0; i <= siMain.GetMaxRowIndex(); i++)
                {
                    string action = siMain.GetText(i, 0);

                    if (action != CAppSetting.FlagI)
                        continue;

                                
                                                                           
                    string sDivisioin = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                    string sCustomPJT = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CUSTOMER_PROJECT_CODE)).ToString();
                    string sCustomerModel = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CUSTOMER_MODEL)).ToString();
                    string sScmSiteid = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString();
                    string sPROJECT_CODE = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString();
                    string sITEM_ID = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString();

                                                   
                    if (sDivisioin == "40" && (sCustomPJT == "" || sCustomerModel == "" || sScmSiteid == "" || sITEM_ID == ""))
                    {

                        string sMsg = "";
                        if (sCustomPJT == "")
                            sMsg += "[Customer PJT],";
                        else if (sCustomerModel == "")
                            sMsg += "[Customer MODEL]],";
                        else if (sScmSiteid == "")
                            sMsg += "[Currency],";
                        else if (sITEM_ID == "")
                            sMsg += "[Model],";
                        sMsg = sMsg.TrimEnd(',');

                        MessageHelper.GMessageBox("MSG00002", new object[] { sMsg });
                        return;
                    }
                                                    
                    else if(sDivisioin  !=  "40" && (sCustomPJT == "" || sCustomerModel == "" || sScmSiteid == "" || sPROJECT_CODE == "" || sITEM_ID == ""))
                    {
                        string sMsg = "";
                        if (sCustomPJT == "")
                            sMsg += "[Customer PJT],";
                        else if (sCustomerModel == "")
                            sMsg += "[Customer MODEL]],";
                        else if (sScmSiteid == "")
                            sMsg += "[Currency],";
                        else if (sPROJECT_CODE == "")
                            sMsg += "[Project Code],";
                        else if (sITEM_ID == "")
                            sMsg += "[Model],";
                        sMsg = sMsg.TrimEnd(',');

                        MessageHelper.GMessageBox("MSG00002", new object[] { sMsg });
                        return;
                    }
  

                            
                    string sSQL = string.Format(@"                
                        SELECT * 
                        FROM DM_MST_CUSTOMER_MODEL
                        WHERE
                        DIVISION_ID = '{0}'
                        AND CUSTOMER_PROJECT_CODE = '{1}'
                        AND CUSTOMER_MODEL = '{2}'
                        AND SCM_SITE_ID = '{3}'
                    ", sDivisioin, sCustomPJT, sCustomerModel, sScmSiteid);
                    DataSet ds = (new CUIControl()).GetDataUsingSQLByDB2(sSQL);
                    if (ds.Tables[0].Rows.Count != 0)
                    {
                                                                                                                                                         
                                                                         
                        string msg = "[Division], [Sales Site], [Customer PJT], [Customer MODEL]";
                        MessageHelper.GMessageBox("MSG00060", new object[] { msg });
                        return;
                    }
                    

                }

                              
                                                                                         
                                                          
                NameValueCollection nvcCols = new NameValueCollection();
                int iCUD = 0;
                string p_active_flag = "";
                int iUpdateRow = 0;
                for (int i = 0; i <= siMain.GetMaxRowIndex(); i++)
                {
                    string action = siMain.GetText(i, 0);

                        
                    if (action == CAppSetting.FlagI)
                        blnInsert = true;

                    if (action != CAppSetting.FlagI && action != CAppSetting.FlagM && action != CAppSetting.FlagD)
                        continue;


                    nvcCols["A"] += action + "^";
                    CString.AppendString(ref p_active_flag, action, iCUD);
                    nvcCols[DefColumns.DIVISION_ID] += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() + "^";
                    nvcCols[DefColumns.SCM_SITE_ID] += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString() + "^";
                    nvcCols[DefColumns.PROJECT_CODE] += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString() + "^";

                    nvcCols[DefColumns.ITEM_CLASS_NAME] += "^";                                                                                            
                    nvcCols[DefColumns.ITEM_ID] += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() + "^";

                    nvcCols[DefColumns.CUSTOMER_PROJECT_CODE] += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CUSTOMER_PROJECT_CODE)).ToString() + "^";
                    nvcCols[DefColumns.CUSTOMER_MODEL] += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CUSTOMER_MODEL)).ToString() + "^";

                    nvcCols[DefColumns.CONVERT_QTY_PACK] += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_PACK)).ToString() == "" ? "0" : siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_PACK)).ToString() + "^";
                    nvcCols[DefColumns.CONVERT_QTY_MODULE] += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_MODULE)).ToString() == "" ? "0" : siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_MODULE)).ToString() + "^";
                    nvcCols[DefColumns.CONVERT_QTY_CELL] += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_CELL)).ToString() == "" ? "0" : siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_CELL)).ToString() + "^";

                    nvcCols[DefColumns.CAPACITY] += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CAPACITY)).ToString() == "" ? "0" : siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CAPACITY)).ToString() + "^";

                    nvcCols[DefColumns.VALID_YN] += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VALID_YN)).ToString() + "^";

                    nvcCols[DefColumns.LAST_UPDATE_DATE] += System.DateTime.Now.ToString() + "^";
                    nvcCols[DefColumns.LAST_UPDATED_BY] += sUserId + "^";
                    iUpdateRow = i;
                    iCUD++;
                }
                               
                                                 
                                                                                            
                                                    

                            
                                   
                var asyncProxy = new FoxAsyncProxy(this);
                var t = await asyncProxy.ExecuteAsync<FoxDataResponse>(() =>
                {
                    using (var client = new FoxDataClient("GSCM", "GSCM.DM.Master.WSL/FoxDataService.svc"))
                    {
                        var request = new FoxDataRequest("DM.PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA");
                        request.Parameters["p_active_flag"] = nvcCols["A"].Substring(0, nvcCols["A"].Length - 1);
                        request.Parameters["p_division_id"] = nvcCols[DefColumns.DIVISION_ID].Substring(0, nvcCols[DefColumns.DIVISION_ID].Length - 1);
                        request.Parameters["p_customer_project_code"] = nvcCols[DefColumns.CUSTOMER_PROJECT_CODE].Substring(0, nvcCols[DefColumns.CUSTOMER_PROJECT_CODE].Length - 1);
                        request.Parameters["p_customer_model"] = nvcCols[DefColumns.CUSTOMER_MODEL].Substring(0, nvcCols[DefColumns.CUSTOMER_MODEL].Length - 1);
                        request.Parameters["p_scm_site_id"] = nvcCols[DefColumns.SCM_SITE_ID].Substring(0, nvcCols[DefColumns.SCM_SITE_ID].Length - 1);
                        request.Parameters["p_project_code"] = nvcCols[DefColumns.PROJECT_CODE].Substring(0, nvcCols[DefColumns.PROJECT_CODE].Length - 1);
                        request.Parameters["p_item_id"] = nvcCols[DefColumns.ITEM_ID].Substring(0, nvcCols[DefColumns.ITEM_ID].Length - 1);
                        request.Parameters["p_valid_yn"] = nvcCols[DefColumns.VALID_YN].Substring(0, nvcCols[DefColumns.VALID_YN].Length - 1);
                        request.Parameters["p_customer_model_type"] = nvcCols[DefColumns.ITEM_CLASS_NAME].Substring(0, nvcCols[DefColumns.ITEM_CLASS_NAME].Length - 1);
                        request.Parameters["p_convert_qty_pack"] = nvcCols[DefColumns.CONVERT_QTY_PACK].Substring(0, nvcCols[DefColumns.CONVERT_QTY_PACK].Length - 1);
                        request.Parameters["p_convert_qty_module"] = nvcCols[DefColumns.CONVERT_QTY_MODULE].Substring(0, nvcCols[DefColumns.CONVERT_QTY_MODULE].Length - 1);
                        request.Parameters["p_convert_qty_cell"] = nvcCols[DefColumns.CONVERT_QTY_CELL].Substring(0, nvcCols[DefColumns.CONVERT_QTY_CELL].Length - 1);
                        request.Parameters["p_created_by"] = nvcCols[DefColumns.LAST_UPDATED_BY].Substring(0, nvcCols[DefColumns.LAST_UPDATED_BY].Length - 1);
                        request.Parameters["p_creation_date"] = nvcCols[DefColumns.LAST_UPDATE_DATE].Substring(0, nvcCols[DefColumns.LAST_UPDATE_DATE].Length - 1);
                        request.Parameters["p_last_updated_by"] = nvcCols[DefColumns.LAST_UPDATED_BY].Substring(0, nvcCols[DefColumns.LAST_UPDATED_BY].Length - 1);
                        request.Parameters["p_last_update_date"] = nvcCols[DefColumns.LAST_UPDATE_DATE].Substring(0, nvcCols[DefColumns.LAST_UPDATE_DATE].Length - 1);

                                                                                             
                                                   
                        return client.ExecuteDataSet(request);
                    }
                });

                                  
                                                                                                      
                string sRMSG = t.DataSet.Tables[t.DataSet.Tables.Count - 1].Rows[0][0].ToString();

                if (sRMSG.Trim() == "success")                                      
                {
                            
                    blnWork = false;

                                           
                    MessageHelper.GMessageBox("MSG00004", new object[] { iCUD });
                                                                           
                                                                                                                                   

                               
                    if (blnInsert)
                        FindData(true);
                    else
                        FindData(false, iUpdateRow, siMain.ActiveSheet.ActiveColumnIndex);
                }
                else
                {
                            
                    blnWork = false;

                                    
                    log.Write(FoxLogLevel.Error, sRMSG);
                    MessageBox.Show(sRMSG, "Warning!");
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

        private void InsertRow()
        {
            if (siMain != null && siMain.IsLock(siMain.SheetName) == false)
            {
                if (siMain.SheetName == SpdSheet.shtMain)
                {
                    FarPoint.Win.Spread.Cell insCell = siMain.Insert();
                    Dictionary<object, object> defaultData = new Dictionary<object, object>();

                    int iRow = siMain.ActiveRowIndex;
                    string sDivision = clbDivisions.ControlValues;

                    siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType = cellTypeImage;
                    siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType = cellTypeImage;
                                          
                    siMain.SetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), sDivision);
                                           
                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), true);

                   

                                                                                        
                    DataTable dtTeamAuth = Data.UserTeamByDivisionAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision);
                    siMain.SetCellTypeCombo(iRow, siMain.GetColumnIndex(DefColumns.TEAM_ID), dtTeamAuth);

                    string sTeam = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DEPT_ID)).ToString();

                    DataTable dtEndCustomerAuth;

                    if (sDivision == "40")
                    {
                        dtEndCustomerAuth = Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
                        siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), true);
                    }
                    else {
                        dtEndCustomerAuth = Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam);
                        siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), false);
                    }
                    siMain.SetCellTypeCombo(iRow, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomerAuth);
                   


                    string sEndCustomer = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.END_CUSTOMER)).ToString();
                    DataTable dtSalesSiteAuth = Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
                    siMain.SetCellTypeCombo(iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSiteAuth);

                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), iRow, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), true);
                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID), iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID), false);
                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), iRow, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), true);
                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.ITEM_NAME), iRow, siMain.GetColumnIndex(DefColumns.ITEM_NAME), true);
                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.CAPACITY), iRow, siMain.GetColumnIndex(DefColumns.CAPACITY), true);
                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), iRow, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), true);
                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), iRow, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), true);

                    defaultData.Add(DefColumns.CONVERT_QTY_PACK, "0");
                    defaultData.Add(DefColumns.CONVERT_QTY_MODULE, "0");
                    defaultData.Add(DefColumns.CONVERT_QTY_CELL, "0");

                    defaultData.Add(DefColumns.CAPACITY, "0");
                    defaultData.Add(DefColumns.VALID_YN, "Y");
                    defaultData.Add(DefColumns.LAST_UPDATED_BY, base.UserInfo.UserId);
                    defaultData.Add(DefColumns.LAST_UPDATE_DATE, System.DateTime.Now.ToString("yyyy-MM-dd hh:ss"));
                                                               

                    siMain.SetValue(insCell, defaultData);
                }
            }
        }

        #endregion

        #region 6. Event
        

                                                                      
            
                            
                                                               
                                      
                                  
            
        private void btnModelType_Click(object sender, EventArgs e)
        {
                          
            string sDivision =  clbDivisions.ControlValues;                               
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
        private void btnProject_Click(object sender, EventArgs e)
        {
                          
            string sDivision = clbDivisions.ControlValues;                               
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

        private void clbDivision_SelectedIndexChanged(object sender, EventArgs e)
        {

            string sDivision =  clbDivisions.ControlValues;          
            string sEndCustomer = string.Empty;

            InitSpread();

            if (sDivision == "40")
            {
                siMain.VisibleColumns(siMain.GetColumnIndex(DefColumns.PROJECT_CODE), false);
                layoutControlItem9.Enabled = false;
                btnProject.Enabled = false;
            }
            else {
                siMain.VisibleColumns(siMain.GetColumnIndex(DefColumns.PROJECT_CODE), true);
                layoutControlItem9.Enabled = true;
                btnProject.Enabled = true;
            }

            dtTeam = Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision);
            clsCtrl.setListBox(dtTeam, clbTeam, true);

            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);

                                                                                     
            if (sDivision == "40")
            {


                DataTable dtCustomer40 = Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
                clsCtrl.setListBox(dtCustomer40, clbEndCustomer, true);

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

        private void spdMain_ComboSelChange(object sender, FarPoint.Win.Spread.EditorNotifyEventArgs e)
        {
            if (siMain.IsLock(siMain.SheetName) == false)
            {
                string sDivision = clbDivisions.ControlValues;
                string sTeam = CAppSetting.StringALL;
                string sEndCustomer = CAppSetting.StringALL;
                string sScmSite = CAppSetting.StringALL;

                if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID))
                {
                    
                    if (siMain.GetColumnIndex(DefColumns.DEPT_ID) > 0)
                    {
                        dtTeam = Data.UserTeamByDivisionAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision);
                        siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeam);

                        sTeam = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID)).ToString();
                    }

                    if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER) > 0)
                    {

                        if (sDivision == "40")
                        {
                            dtEndCustomer = Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
                        }
                        else
                        {
                            dtEndCustomer = Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam);
                        }

                        sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER)).ToString();
                    }

                    dtSalesSite = Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite);

                                     
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
                    if (siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "");
                }
                else if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT_ID))
                {

                    if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER) > 0)
                    {
                        sTeam = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID)).ToString();

                        if (sDivision == "40")
                        {
                            dtEndCustomer = Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
                        }
                        else {
                            dtEndCustomer = Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam);
                        }
                        siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer);


                        sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER)).ToString();
                                                                                                                                                         
                        dtSalesSite = Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
                        siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite);
                    }

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
                    if (siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "");
                }
                else if (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER))
                {

                    sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER)).ToString();
                    dtSalesSite = Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite);

                    if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "");
                    if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "");
                    if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "");
                    if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "");
                    if (siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "");
                }
                else if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID))
                {
                    if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "");
                    if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "");
                    if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "");
                    if (siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "");
                }

            }
        }

        private void spdMain_CellDoubleClick(object sender, FarPoint.Win.Spread.CellClickEventArgs e)
        {
            if (siMain.Sheet().Rows.Count <= 0)
                return;

            if (siMain.IsLock(siMain.SheetName))
            {

            }
            else
            {
                             
                string action = siMain.GetText(e.Row, 0);
                                                   
                              

                string sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                string sProject = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString();
                string sScmSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString();
                string sItemId = "";                                                                               
                string sTeam = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID)).ToString();
                string sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER)).ToString();
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
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), popProject.ProjectCode);
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), popProject.ProjectName);

                                         
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "");
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "");                        

                                                                                               
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
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), popItem.ItemID);
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), popItem.ItemClassName);
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_NAME), popItem.ItemName);
                        if (popItem.ItemClassName == null)
                            return;

                        if (popItem.ItemClassName.ToUpper().IndexOf("MODULE") >= 0)
                        {
                            siMain.LockRange(e.Row, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_CELL), e.Row, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_CELL), true);
                                                                                                                                                                            
                        }
                        else if (popItem.ItemClassName.ToUpper().IndexOf("CELL") >= 0)
                        {
                                                                                                                                                                                
                                                                                                                                                                            
                        }
                        else if (popItem.ItemClassName.ToUpper().IndexOf("PACK") >= 0)
                        {
                            siMain.LockRange(e.Row, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_CELL), e.Row, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_CELL), true);
                            siMain.LockRange(e.Row, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_MODULE), e.Row, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_MODULE), true);
                        }

                                                                                               
                    }
                }

            }
        }

        #endregion

        private void spdMain_KeyUp(object sender, System.Windows.Forms.KeyEventArgs e)
        {
                                                     
            if (e.Control == true && e.KeyCode == Keys.V)
            {
                spdMain.Sheets[0].ClipboardPaste(ClipboardPasteOptions.AsStringSkipHidden);
                                                               
            }

            if (e.Control == true && e.KeyCode == Keys.C)
            {
                                     
                spdMain.Sheets[0].ClipboardCopy(ClipboardCopyOptions.AsStringSkipHidden);
                                                               


            }
        }

        private void spdMain_TopChange(object sender, TopChangeEventArgs e)
        {
            CanModelChange = false;
            siMain.SmartColMerge();
            CanModelChange = true;
        }

        private void clbEndCustomer_SelectedIndexChanged(object sender, EventArgs e)
        {
            dtSalesSite = Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivisions.ControlValues, clbEndCustomer.ControlValues);
            clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);
        }

        private DataTable GetSpdTitle()
        {        
            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                var request = new FoxDataRequest("DM.DM0000_GET_COMMON_SPREAD_TITLE");
                request.Parameters["p_start_yyyymmdd"] = "";
                request.Parameters["p_end_yyyymmdd"] = "";
                request.Parameters["p_created_by"] = base.UserInfo.UserId;
                request.Parameters["p_program_id"] = "DMF0006";
                request.Parameters["p_sheet_name"] = "Customer Model Mapping";

                dsSpdTitle = client.ExecuteDataSet(request).DataSet;
            }

            return dsSpdTitle.Tables[0];
        }

        private void clbTeam_SelectedIndexChanged(object sender, EventArgs e)
        {
            string sDivision = clbDivisions.ControlValues;
            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);

            dtEndCustomer = Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam);
            clsCtrl.setListBox(dtEndCustomer, clbEndCustomer, true);

            string sEndCustomer = CString.GetCheckedListValue(dtEndCustomer, clbEndCustomer.ControlValues);

            dtSalesSite = Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
            clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);
        }

        private void Dsdm_Changed(object sender, FarPoint.Win.Spread.Model.SheetDataModelEventArgs e)
        {
                                   
                                        
                          
                                              
                          
            if (siMain.IsLock(siMain.SheetName) == true)
                return;

                                                                          
                                            
            if (e.Column < 0 || e.Row < 0)
                return;
            if (siMain.IsLockCell(e.Row, e.Column))
                return;

            try
            {
                dsdm.Changed -= Dsdm_Changed;
                switch (e.Type)
                {
                    case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated:
                        if (siMain.GetColumnIndex(DefColumns.CONVERT_QTY_CELL) == e.Column
                            || siMain.GetColumnIndex(DefColumns.CONVERT_QTY_MODULE) == e.Column
                            || siMain.GetColumnIndex(DefColumns.CONVERT_QTY_PACK) == e.Column
                            )
                        {
                            int iValue = Convert.ToInt32(siMain.GetValue(e.Row, e.Column).ToString());
                            if (iValue < 0)
                                siMain.SetText(e.Row, e.Column, "0");

                        }
                        break;

                    default:
                        break;
                }
                
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dsdm.Changed += Dsdm_Changed;
            }
        }
    }
}
