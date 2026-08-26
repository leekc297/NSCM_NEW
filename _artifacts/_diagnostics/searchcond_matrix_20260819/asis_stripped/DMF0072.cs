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
using GSCM.Windows.Forms.Service;

                                                                                                                            
                                          
                         
                   
                                                                                                                            
                                           
                                                                                                                            
                                                          
                                                                                           
                                                                  
                                                                    
                                                                                                    
                                                                                                                           

namespace GSCM.DM.Master.UIL
{
    public partial class DMF0072_NNMasterMapping : BaseForm
    {
                      
                   
                       
        #region 1. Setting
        CControl clsCtrl = null;
        private DataTable dtDivision = null;
        private DataTable dtSalesSite = null;
        private DataTable dtTeam = null;
        private DataTable dtEndCustomer = null;
        private DataTable dtCUST_FCST_TYPE = null;
        private DataTable dtITEM_ID = null;
        private DataTable dtDM_EDI_DATA_TYPE_CODE = null;

        private DataTable dtTitle = null;                                                       

        private bool blnWork = false;

        private string sBinding = "GSCM.DM.Master.WSL/FoxDataService.svc";

                        
        IFoxLog log = FoxLogManager.GetLogger("DMF0006_CustomerModelMapping.Log");
                  
        SpreadInfo siMain = null;

        TextCellType cellTypeImage = null;

                    
        FarPoint.Win.Spread.Model.DefaultSheetDataModel dsdm;                                                                                                  

                                                                                                                   
        private int VALID_RANGE_COUNT = 0;                  

                      
                       
                       
        private struct SpdSheet
        {
            public static string shtMain = "NNMasterMapping";
        }

                      
                  
                       
        private struct DefColumns
        {
            public static string DATA_TYPE_CODE = "DATA_TYPE_CODE";
            public static string DIVISION_ID = "DIVISION_ID";
            public static string COMPANY_ID = "COMPANY_ID";
            public static string SOLDTO_CODE = "SOLDTO_CODE";
            public static string SHIPTO_CODE = "SHIPTO_CODE";
            public static string UNLOADING_POINT = "UNLOADING_POINT";
            public static string CUSTOMER_PLANT = "CUSTOMER_PLANT";
            public static string CUSTOMER_ITEM_ID = "CUSTOMER_ITEM_ID";
            public static string END_CUSTOMER = "END_CUSTOMER";
            public static string SCM_SITE_ID = "SCM_SITE_ID";
            public static string PROJECT_CODE = "PROJECT_CODE";
            public static string FCST_TYPE = "FCST_TYPE";
            public static string INCOTERMS = "INCOTERMS";
            public static string DOM_EXP = "DOM_EXP";
            public static string ITEM_ID = "ITEM_ID";
            public static string MAPPING_ITEM_ID = "MAPPING_ITEM_ID";
            public static string MAPPING_ITEM_ID_ORIGINAL = "MAPPING_ITEM_ID_ORIGINAL";
            public static string VALID_START_DATE = "VALID_START_DATE";
            public static string VALID_END_DATE = "VALID_END_DATE";
            public static string ACTIVE_YN = "ACTIVE_YN";
            public static string LAST_UPDATED_BY = "LAST_UPDATED_BY";
            public static string LAST_UPDATE_DATE = "LAST_UPDATE_DATE";
        }

        private struct DefColumnsLabel
        {
            public static string DATA_TYPE_CODE = "Excel/RPA";
            public static string UNLOADING_POINT = "CUST_UNLOAD";
            public static string CUSTOMER_PLANT = "CUST_PLANT";
            public static string SOLDTO_CODE = "SOLDTO";
            public static string SHIPTO_CODE = "SHIPTO";
            public static string CUSTOMER_ITEM_ID = "CUST_ITEM_ID";
            public static string ITEM_ID = "MDM_CODE";
            public static string ACTIVE_YN = "ACTIVE_FLAG";
        }
        #endregion

        #region 2. Construct

        public DMF0072_NNMasterMapping()
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

                                                      
                                                                                                                                  
            SetChangeControl("UserTeamByDivision", sDivision);
                                                    
            clsCtrl.setListBox(dtTeam, clbTeam, true);

            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);

            if (sDivision == "40")
            {
                                                          
                                                                                                                                                                                  
                SetChangeControl("EndCustomerByDivision", clbDivisions.ControlValues, clbTeam.ControlValues);
                                                        
            }
            else
            {
                                                          
                                                                                                                                                               
                SetChangeControl("EndCustomerByDivision", sDivision, sTeam);
                                                        
            }

            clsCtrl.setListBox(dtEndCustomer, clbEndCustomer, true);

            string sEndCustomer = CString.GetCheckedListValue(dtEndCustomer, clbEndCustomer.ControlValues);

                                                      
                                                                                                                                                                         
            SetChangeControl("UserSiteByEndCustomer", clbDivisions.ControlValues, string.Empty, sEndCustomer);
                                                    

            clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);

                          
            dtITEM_ID = Data.Common(Data.Type.SALES_PLAN_ITEM_ID, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);

                                 
                                                                                                    

                                                   
                                                                                             
                                  
            dtDM_EDI_DATA_TYPE_CODE = GSCM.Utils.CommonUtils.GetLookupValues("DM_EDI_DATA_TYPE_CODE");
            clsCtrl.setListBox(dtDM_EDI_DATA_TYPE_CODE, clbDataTypeCode, true, "CODE", "CODE");
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
            this.AddSheet(spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30);
            siMain = GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex);
            siMain.ChangeSheet();

            InitSpread();

            clbDivisions.SelectedIndexChanged += new System.EventHandler(clbDivision_SelectedIndexChanged);
        }

        private void InitSpread()
        {
                                                                   
                                                      
            dtTitle = GetSpdTitle(siMain.SheetName);
            siMain.CreateSheetHeaderColumn(siMain, 2, dtTitle);

        }

        private DataTable dtYesOrNo = Data.Common(Data.Type.YesOrNo);

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

                                                       
                                                                       
                                                                                            

                                             
                siMain.LockColumn(1, siMain.GetColumnIndex(DefColumns.ITEM_ID), true);

                                             
                siMain.LockColumn(siMain.GetColumnIndex(DefColumns.MAPPING_ITEM_ID_ORIGINAL), siMain.GetColumnIndex(DefColumns.MAPPING_ITEM_ID_ORIGINAL), true);

                                                 
                siMain.LockColumn(siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), true);

                                                                                                                 
                                                                                                                                                    

                                                    
                                                                                                                                                              

                SetLockRow();

                #region 주석
                   
                                                                                            
                  
                                                                       
                      
                                                            
                          
                                       
                                                                                                                                                                            
                                                                                                                                                                            
                                                                                                                                                                            
                                                                                                                                                                            
                                                                                                                                                                            
                                       
                                       
                                                                                                                                                                            
                                                                                                                                                                            
                                                                                                                                                                            
                                                                                                                                                                            
                                                                                                                                                                            
                                       
                                     
                                                                                                                                                                            
                                                                                                                                                                            
                                                                                                                                                                            
                                                                                                                                                                            
                                                                                                                                                                            
                                       
 
                          
                      
                  
                  
                                 

                                                                              
                    
                                                               
                        
                                               
                            
                                     
                                                                                                                                   
                            
                               
                            
                                     
                                                                                                                                            
                            
                        

                                           
                        
                                 
                                                                                                                         
                                                                                                                         
                        
                           
                        
                                 
                                                                                                                                  
                                                                                                                                  
                        
                                
                         
                                                                                                                               
                                                                                                                               
                                                                                                                               
                                                                                                                               
                                                                                                                               
                         

                                             
                                              
                    
                #endregion
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
                                                                                     
            exportOption.AmendDecimalFormat = "#,###;[Red]-#,###";
                                                          
                                                                            
                                                           
                                                                               
                                     
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
            try
            {
                         
                string p_data_type_code = clbDataTypeCode.ControlValues;                                                                                                     
                string p_division_id = clbDivisions.ControlValues;                               
                string p_scm_site_id = clbSalesSite.ControlValues;
                string p_project_code = umltProject.Text;                                                                
                string p_item_id = umltModel.Text;                                                                    

                if (p_division_id == "")
                {
                    MessageHelper.GMessageBox("MSG00097");
                    return;
                }

                CanModelChange = false;
                InitSpread();
                siMain.RemoveRowAll();
                                           

                var asyncProxy = new FoxAsyncProxy(this);

                var ds = await asyncProxy.ExecuteAsync<DataSet>(() =>
                {
                    using (var client = new FoxDataClient("GSCM", "GSCM.DM.Master.WSL/FoxDataService.svc"))
                    {
                        var request = new FoxDataRequest("DM.DMF0072_GET_NNMASTER_MAPPING");

                        request.Parameters["p_data_type_code"] = p_data_type_code;
                        request.Parameters["p_division_id"] = p_division_id;
                        request.Parameters["p_dept_id"] = clbTeam.ControlValues;
                        request.Parameters["p_end_customer"] = clbEndCustomer.ControlValues;
                        request.Parameters["p_scm_site_id"] = p_scm_site_id;
                        request.Parameters["p_project_code"] = p_project_code;
                        request.Parameters["p_item_id"] = p_item_id;

                        var response = client.ExecuteDataSet(request);

                        return response.DataSet;
                    }
                });

                siMain.Query(ds);
                siMain.LockColumn(0, siMain.GetMaxColumnIndex(), true);


                siMain.SpreadObject.SuspendLayout();
                           
                for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
                {
                                                                   
                        
                                                                                                                                        
                        
                    siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.MAPPING_ITEM_ID)].CellType = cellTypeImage;
                                                                                                                              
                                                                                                                              

                    if ((iRow % 100) == 0)
                        Application.DoEvents();
                }

                siMain.SpreadObject.SuspendLayout();

                siMain.SmartColMerge();

                                                       
                                                                                         
                             
                siMain.VisibleColumns(siMain.GetColumnIndex(DefColumns.MAPPING_ITEM_ID_ORIGINAL), false);

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

                    siMain.SetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DATA_TYPE_CODE), "SCM");
                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.DATA_TYPE_CODE), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DATA_TYPE_CODE), true);

                    siMain.SetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), sDivision);

                                                           
                                              
                    DataTable dtCOMPANY_ID;
                    dtCOMPANY_ID = GSCM.Utils.CommonUtils.GetLookupValues("DM_EDI_COMPANY_LIST");
                    siMain.SetCellTypeCombo(iRow, siMain.GetColumnIndex(DefColumns.COMPANY_ID), dtCOMPANY_ID);

                    siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE)].CellType = cellTypeImage;
                    siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE)].CellType = cellTypeImage;
                    DataTable dtEndCustomerAuth;

                    if (sDivision == "40")
                    {
                        dtEndCustomerAuth = Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, "", UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);
                        siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), true);
                    }
                    else
                    {
                        dtEndCustomerAuth = Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "");
                        siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), false);
                    }
                    siMain.SetCellTypeCombo(iRow, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomerAuth);

                    string sEndCustomer = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.END_CUSTOMER)).ToString();
                    DataTable dtSalesSiteAuth = Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
                    siMain.SetCellTypeCombo(iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSiteAuth);
                    siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType = cellTypeImage;
                                                                                                                                                   
                    siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType = cellTypeImage;
                    siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.MAPPING_ITEM_ID)].CellType = cellTypeImage;

                                         
                    siMain.SetText(iRow, siMain.GetColumnIndex(DefColumns.ACTIVE_YN), "Y");

                                                              
                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), true);
                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), true);

                                                          
                                                                   
                        
                                                                                                                                        
                        

                                             
                                                                                                                         
                }
            }
        }

        private async void SaveData()
        {
            if (siMain != null && siMain.IsLock(siMain.SheetName) == false)
            {
                if (siMain.SheetName == SpdSheet.shtMain)
                {
                    string sProcedureName = "DM.DMF0072_SAVE_NNMASTER_MAPPING";

                    string sACT_TYPE = string.Empty;             

                    string sDIVISION_ID = clbDivisions.ControlValues;
                    string sDATA_TYPE_CODE = string.Empty;
                    string sCOMPANY_ID = string.Empty;
                    string sEND_CUSTOMER = string.Empty;
                    string sCUST_UNLOAD = string.Empty;
                    string sCUST_PLANT = string.Empty;
                    string sSOLDTO = string.Empty;
                    string sSHIPTO = string.Empty;
                    string sPROJECT_CODE = string.Empty;
                    string sSCM_SITE_ID = string.Empty;
                    string sFCST_TYPE = string.Empty;
                    string sINCOTERMS = string.Empty;
                    string sDOM_EXP = string.Empty;
                    string sCUST_ITEM_ID = string.Empty;
                    string sITEM_ID = string.Empty;
                    string sMAPPING_ITEM_ID = string.Empty;
                    string sMAPPING_ITEM_ID_ORIGINAL = string.Empty;
                    string sACTIVE_FLAG = string.Empty;

                    string sVALID_FROM = string.Empty;                         
                    string sVALID_TO = string.Empty;                        
                    string sMODEL_CODE = string.Empty;                       

                    string cellVALID_FROM = string.Empty;                               
                    string cellVALID_TO = string.Empty;                              
                    string cellMODEL_CODE = string.Empty;                             


                    string sPrevVALID_FROM = string.Empty;              
                    string sPrevVALID_TO = string.Empty;              

                    DateTime dtFrom = new DateTime();
                    DateTime dtTo = new DateTime();
                    DateTime dtPrevTo = new DateTime();
                       
                                                        
                                                                               
                                                                              
                                                                              
 
                                                                                             
 
                                                     
                       

                    int intVALID_FROM_1 = siMain.GetColumnIndex(DefColumns.VALID_START_DATE);

                    int intAllEmptyCnt = 0;                                             

                    for (int i = 0; i <= siMain.GetMaxRowIndex(); i++)
                    {
                        if (siMain.Sheet().Cells[i, 0].Text == "I" || siMain.Sheet().Cells[i, 0].Text == "M")                 
                        {
                            #region Validation
                                       
                            sPrevVALID_FROM = "";
                            sPrevVALID_TO = "";

                            cellVALID_FROM = "";
                            cellVALID_TO = "";
                            cellMODEL_CODE = "";

                            intAllEmptyCnt = 0;

                                            
                            if (
                                siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() == "" &&
                                siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VALID_START_DATE)).ToString() == "" &&
                                siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VALID_END_DATE)).ToString() == ""
                                )
                            {
                                intAllEmptyCnt++;              
                                continue;
                            }

                                                                                     
                            if (
                                siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() == "" ||
                                siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VALID_START_DATE)).ToString() == "" ||
                                siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VALID_END_DATE)).ToString() == ""
                                )
                            {
                                MessageHelper.GMessageBox("MSG00002", new object[] { "Valid From, Valid To, Model Code" });                   

                                if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() == "")
                                {
                                    siMain.ActiveSheet.SetActiveCell(i, siMain.GetColumnIndex(DefColumns.ITEM_ID));
                                }
                                else if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VALID_START_DATE)).ToString() == "")
                                {
                                    siMain.ActiveSheet.SetActiveCell(i, siMain.GetColumnIndex(DefColumns.VALID_START_DATE));
                                }
                                else if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VALID_END_DATE)).ToString() == "")
                                {
                                    siMain.ActiveSheet.SetActiveCell(i, siMain.GetColumnIndex(DefColumns.VALID_END_DATE));
                                }

                                return;
                            }
                            else
                            {
                                              
                                try
                                {
                                    dtFrom = Convert.ToDateTime(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VALID_START_DATE)).ToString().Substring(0, 4) + "-"
                                        + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VALID_START_DATE)).ToString().Substring(4, 2) + "-"
                                        + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VALID_START_DATE)).ToString().Substring(6, 2));
                                    dtTo = Convert.ToDateTime(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VALID_END_DATE)).ToString().Substring(0, 4) + "-"
                                        + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VALID_END_DATE)).ToString().Substring(4, 2) + "-"
                                        + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VALID_END_DATE)).ToString().Substring(6, 2));

                                    if (dtFrom > dtTo)
                                    {
                                        MessageHelper.GMessageBox("MSG00108");                           
                                        siMain.ActiveSheet.SetActiveCell(i, siMain.GetColumnIndex(DefColumns.VALID_START_DATE));
                                        return;
                                    }
                                }
                                catch
                                {
                                    MessageHelper.GMessageBox("MSG00049", new object[] { "" });                        
                                    siMain.ActiveSheet.SetActiveCell(i, siMain.GetColumnIndex(DefColumns.VALID_START_DATE));
                                    return;
                                }

                                if (sPrevVALID_TO != "")
                                {
                                                
                                    dtPrevTo = Convert.ToDateTime(sPrevVALID_TO.Substring(0, 4) + "-"
                                        + sPrevVALID_TO.Substring(4, 2) + "-"
                                        + sPrevVALID_TO.Substring(6, 2));

                                                    
                                                                  
                                    if (Convert.ToInt32(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VALID_START_DATE))) <= Convert.ToInt32(sPrevVALID_TO))
                                    {
                                        MessageHelper.GMessageBox("MSG00105");                
                                        siMain.ActiveSheet.SetActiveCell(i, siMain.GetColumnIndex(DefColumns.VALID_START_DATE));
                                        return;
                                    }
                                                 
                                                                    
                                    else if ((dtFrom - dtPrevTo).Days > 1)
                                    {
                                        MessageHelper.GMessageBox("MSG00106");                       
                                        siMain.ActiveSheet.SetActiveCell(i, siMain.GetColumnIndex(DefColumns.VALID_START_DATE));
                                        return;
                                    }
                                }

                                              
                                cellVALID_FROM += (cellVALID_FROM == "" ? "" : "$") + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VALID_START_DATE)).ToString();
                                cellVALID_TO += (cellVALID_TO == "" ? "" : "$") + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VALID_END_DATE)).ToString();
                                cellMODEL_CODE += (cellMODEL_CODE == "" ? "" : "$") + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString();

                                                
                                sPrevVALID_FROM = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VALID_START_DATE)).ToString();
                                sPrevVALID_TO = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VALID_END_DATE)).ToString();
                            }

                                                     
                                                                          
                                
                                                                           
                                    
                                                                                                    
                                        
                                                  
                                        
                                    
                                

                                            
                            if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DATA_TYPE_CODE)).ToString() == "")
                            {
                                MessageHelper.GMessageBox("MSG00002", new object[] { DefColumnsLabel.DATA_TYPE_CODE });                   
                                siMain.ActiveSheet.SetActiveCell(i, siMain.GetColumnIndex(DefColumns.DATA_TYPE_CODE));
                                return;
                            }
                            if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.END_CUSTOMER)).ToString() == "")
                            {
                                MessageHelper.GMessageBox("MSG00002", new object[] { DefColumns.END_CUSTOMER });                   
                                siMain.ActiveSheet.SetActiveCell(i, siMain.GetColumnIndex(DefColumns.END_CUSTOMER));
                                return;
                            }

                                                            
                                                                                                                                     
                                                                                                                            
                              
                                                                                                                            
                                  
                                                                                                                                               
                                                                                                                            
                                            
                                  
                                                                                                                             
                                  
                                                                                                                                                
                                                                                                                             
                                            
                                  
                                                                                                                           
                                  
                                                                                                                                              
                                                                                                                           
                                            
                                  
                              
                              
                                                                                                                                  
                                             
                            if (siMain.Sheet().Cells[i, 0].Text == "I")
                            {
                                if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE)).ToString() == "")
                                {
                                    MessageHelper.GMessageBox("MSG00002", new object[] { DefColumnsLabel.SOLDTO_CODE });                   
                                    siMain.ActiveSheet.SetActiveCell(i, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE));
                                    return;
                                }
                                if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE)).ToString() == "")
                                {
                                    MessageHelper.GMessageBox("MSG00002", new object[] { DefColumnsLabel.SHIPTO_CODE });                   
                                    siMain.ActiveSheet.SetActiveCell(i, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE));
                                    return;
                                }
                                if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString() == "")
                                {
                                    MessageHelper.GMessageBox("MSG00002", new object[] { DefColumns.PROJECT_CODE });                   
                                    siMain.ActiveSheet.SetActiveCell(i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE));
                                    return;
                                }
                                if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString() == "")
                                {
                                    MessageHelper.GMessageBox("MSG00002", new object[] { DefColumns.SCM_SITE_ID });                   
                                    siMain.ActiveSheet.SetActiveCell(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID));
                                    return;
                                }
                                if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.FCST_TYPE)).ToString() == "")
                                {
                                    MessageHelper.GMessageBox("MSG00002", new object[] { DefColumns.FCST_TYPE });                   
                                    siMain.ActiveSheet.SetActiveCell(i, siMain.GetColumnIndex(DefColumns.FCST_TYPE));
                                    return;
                                }
                                if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.INCOTERMS)).ToString() == "")
                                {
                                    MessageHelper.GMessageBox("MSG00002", new object[] { DefColumns.INCOTERMS });                   
                                    siMain.ActiveSheet.SetActiveCell(i, siMain.GetColumnIndex(DefColumns.INCOTERMS));
                                    return;
                                }
                                if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DOM_EXP)).ToString() == "")
                                {
                                    MessageHelper.GMessageBox("MSG00002", new object[] { DefColumns.DOM_EXP });                   
                                    siMain.ActiveSheet.SetActiveCell(i, siMain.GetColumnIndex(DefColumns.DOM_EXP));
                                    return;
                                }
                                if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() == "")
                                {
                                    MessageHelper.GMessageBox("MSG00002", new object[] { DefColumnsLabel.ITEM_ID });                   
                                    siMain.ActiveSheet.SetActiveCell(i, siMain.GetColumnIndex(DefColumns.ITEM_ID));
                                    return;
                                }
                            }

                            if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ACTIVE_YN)).ToString() == "")
                            {
                                MessageHelper.GMessageBox("MSG00002", new object[] { DefColumnsLabel.ACTIVE_YN });                   
                                siMain.ActiveSheet.SetActiveCell(i, siMain.GetColumnIndex(DefColumns.ACTIVE_YN));
                                return;
                            }

                                                                                   
                                                             
                            if (
                                (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.UNLOADING_POINT)).ToString().Length > 35)
                                || (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CUSTOMER_PLANT)).ToString().Length > 10)
                                || (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CUSTOMER_ITEM_ID)).ToString().Length > 50)

                                )
                            {
                                MessageBox.Show("최대 입력길이 초과");
                                return;
                            }
                                                                                                           

                            #endregion

                            sACT_TYPE += (sACT_TYPE == "" ? "" : "^") + siMain.GetValue(i, 0).ToString();
                            sDATA_TYPE_CODE += (sDATA_TYPE_CODE == "" ? "" : "^") + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DATA_TYPE_CODE)).ToString();
                            sCOMPANY_ID += (sCOMPANY_ID == "" ? "" : "^") + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.COMPANY_ID)).ToString();
                            sEND_CUSTOMER += (sEND_CUSTOMER == "" ? "" : "^") + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.END_CUSTOMER)).ToString();
                            sCUST_UNLOAD += (sCUST_UNLOAD == "" ? " " : "^") + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.UNLOADING_POINT)).ToString();                                       
                            sCUST_PLANT += (sCUST_PLANT == "" ? " " : "^") + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CUSTOMER_PLANT)).ToString();                                       
                            sSOLDTO += (sSOLDTO == "" ? "" : "^") + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE)).ToString();
                            sSHIPTO += (sSHIPTO == "" ? "" : "^") + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE)).ToString();
                            sPROJECT_CODE += (sPROJECT_CODE == "" ? "" : "^") + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString();
                            sSCM_SITE_ID += (sSCM_SITE_ID == "" ? "" : "^") + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString();
                            sFCST_TYPE += (sFCST_TYPE == "" ? "" : "^") + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.FCST_TYPE)).ToString();
                            sINCOTERMS += (sINCOTERMS == "" ? "" : "^") + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.INCOTERMS)).ToString();
                            sDOM_EXP += (sDOM_EXP == "" ? "" : "^") + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DOM_EXP)).ToString();
                            sCUST_ITEM_ID += (sCUST_ITEM_ID == "" ? " " : "^") + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CUSTOMER_ITEM_ID)).ToString();                                       
                            sITEM_ID += (sITEM_ID == "" ? "" : "^") + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString();
                            sMAPPING_ITEM_ID += (sMAPPING_ITEM_ID == "" ? "" : "^") + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MAPPING_ITEM_ID)).ToString();

                            if (siMain.Sheet().Cells[i, 0].Text == "I")
                            {
                                sMAPPING_ITEM_ID_ORIGINAL += (sMAPPING_ITEM_ID_ORIGINAL == "" ? "" : "^") + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MAPPING_ITEM_ID)).ToString();
                            }
                            else
                            {
                                sMAPPING_ITEM_ID_ORIGINAL += (sMAPPING_ITEM_ID_ORIGINAL == "" ? "" : "^") + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MAPPING_ITEM_ID_ORIGINAL)).ToString();
                            }

                                                                       
                                                                                                                   
                                
                                                                                         
                                
                                   
                                
                                                                                                                                                                
                                
                            sACTIVE_FLAG += (sACTIVE_FLAG == "" ? "" : "^") + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ACTIVE_YN)).ToString();
                            sVALID_FROM += (sVALID_FROM == "" ? "" : "^") + cellVALID_FROM;
                            sVALID_TO += (sVALID_TO == "" ? "" : "^") + cellVALID_TO;
                            sMODEL_CODE += (sMODEL_CODE == "" ? "" : "^") + cellMODEL_CODE;
                        }
                    }

                    if (sDATA_TYPE_CODE != "")
                    {
                        try
                        {
                            var asyncProxy = new FoxAsyncProxy(this);

                            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
                            {
                                var request = new FoxDataRequest(sProcedureName);
                                request.Parameters["P_DIVISION_ID"] = sDIVISION_ID;
                                request.Parameters["P_COMPANY_ID"] = sCOMPANY_ID;
                                request.Parameters["P_ACT_TYPE"] = sACT_TYPE;
                                request.Parameters["P_CUST_FCST_TYPE"] = sDATA_TYPE_CODE;
                                request.Parameters["P_END_CUSTOMER"] = sEND_CUSTOMER;
                                request.Parameters["P_CUST_UNLOAD"] = sCUST_UNLOAD;
                                request.Parameters["P_CUST_PLANT"] = sCUST_PLANT;
                                request.Parameters["P_SOLDTO"] = sSOLDTO;
                                request.Parameters["P_SHIPTO"] = sSHIPTO;
                                request.Parameters["P_PROJECT_CODE"] = sPROJECT_CODE;
                                request.Parameters["P_SCM_SITE_ID"] = sSCM_SITE_ID;
                                request.Parameters["P_FCST_TYPE"] = sFCST_TYPE;
                                request.Parameters["P_INCOTERMS"] = sINCOTERMS;
                                request.Parameters["P_DOM_EXP"] = sDOM_EXP;
                                request.Parameters["P_CUST_ITEM_ID"] = sCUST_ITEM_ID;
                                request.Parameters["P_MDM_CODE"] = sITEM_ID;
                                request.Parameters["P_MAPPING_ITEM_ID"] = sMAPPING_ITEM_ID;
                                request.Parameters["P_MAPPING_ITEM_ID_ORIGINAL"] = sMAPPING_ITEM_ID_ORIGINAL;
                                request.Parameters["P_ACTIVE_FLAG"] = sACTIVE_FLAG;
                                request.Parameters["P_VALID_FROM"] = sVALID_FROM;
                                request.Parameters["P_VALID_TO"] = sVALID_TO;
                                request.Parameters["P_USER_ID"] = UserInfoContext.Current.UserId;

                                var response = client.ExecuteDataSet(request);

                                if (response.DataSet.Tables[0].Rows[0]["result_code"].ToString() == "S")
                                {
                                                                                                                                                                     
                                    MessageHelper.GMessageBox("MSG00020");
                                    siMain.SpreadObject.ResumeLayout();
                                }
                                else if (response.DataSet.Tables[0].Rows[0]["result_code"].ToString() == "F")
                                {
                                                                                                   
                                                       
                                    MessageBox.Show(response.DataSet.Tables[0].Rows[0]["result_msg"].ToString());
                                    return;
                                }
                                else
                                {
                                                                             
                                    MessageHelper.GMessageBox("MSG00284", null);                   
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
                        MessageHelper.GMessageBox("MSG00017");                
                    }
                }
            }
        }

        #endregion

        #region 6. Event


                                                                      
            
                            
                                                               
                                      
                                  
            
        private void btnModelType_Click(object sender, EventArgs e)
        {
                          
            string sDivision = clbDivisions.ControlValues;                               
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

            string sDivision = clbDivisions.ControlValues;          
            string sEndCustomer = string.Empty;

            InitSpread();

            if (sDivision == "40")
            {
                siMain.VisibleColumns(siMain.GetColumnIndex(DefColumns.PROJECT_CODE), false);
                layoutControlItem9.Enabled = false;
                btnProject.Enabled = false;
            }
            else
            {
                siMain.VisibleColumns(siMain.GetColumnIndex(DefColumns.PROJECT_CODE), true);
                layoutControlItem9.Enabled = true;
                btnProject.Enabled = true;
            }

                                                      
                                                                                                                                  
            SetChangeControl("UserTeamByDivision", sDivision);
                                                    

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

                                     
                    if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), "");
                    if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "");
                    if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "");
                    if (siMain.GetColumnIndex(DefColumns.CUSTOMER_ITEM_ID) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.CUSTOMER_ITEM_ID), "");
                    if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "");

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
                    if (siMain.GetColumnIndex(DefColumns.CUSTOMER_ITEM_ID) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.CUSTOMER_ITEM_ID), "");
                    if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "");

                }
                else if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID))
                {
                    if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "");
                    if (siMain.GetColumnIndex(DefColumns.CUSTOMER_ITEM_ID) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.CUSTOMER_ITEM_ID), "");
                    if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "");
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
                                                   
                              

                string sDivision = clbDivisions.ControlValues;                                                                                     
                string sProject = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString();
                string sScmSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString();

                string sTeam = "";                                                                                 
                string sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER)).ToString();
                string sScmSite = "";                                                                                     


                string sItemId = "";

                if (
                    siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.MAPPING_ITEM_ID))
                    ||
                    (
                    siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.ITEM_ID))
                    &&
                    siMain.Sheet().Cells[e.Row, 0].Text == "I"
                    )
                   )
                {
                    DM0002_ItembyDivisionPopupEx popItem = new DM0002_ItembyDivisionPopupEx();

                                                                                                                 

                    popItem.Form_Load(false, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, "", "");                                                
                    popItem.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                    popItem.ShowDialog();

                    sItemId = popItem.ItemID;
                    if (sItemId != "" && sItemId != null)
                    {
                        siMain.SetText(e.Row, e.Column, sItemId);

                           
                                                                            
                                                                                                          
 
                                                                            
                                                                                                          
 
                                                                            
                                                                                                          
                              
                    }
                }
                                                      
                                             
                else if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) && siMain.Sheet().Cells[e.Row,0].Text =="I")
                {
                    SCM0002_ProjectbyDivisionPopupEx popProject = new SCM0002_ProjectbyDivisionPopupEx();
                    popProject.Form_Load(false, sDivision, sTeam, sEndCustomer, sScmSite, sProject);
                    popProject.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                    popProject.ShowDialog();

                    sProject = popProject.ProjectCode;

                    if (popProject.ProjectCode != "" && popProject.ProjectCode != null)
                    {
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), popProject.ProjectCode);
                    }
                }
                                                      
                                                           
                else if ( (   
                              siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SOLDTO_CODE))
                          ||  
                              siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SHIPTO_CODE))
                          ) 
                          &&
                              siMain.Sheet().Cells[e.Row, 0].Text == "I"
                       )
                {
                    string sSoldToCode = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE)).ToString();
                    string sShipToCode = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE)).ToString();

                    SCM0002_CustomerbyDivisionPopup popCustomer = new SCM0002_CustomerbyDivisionPopup();

                    popCustomer.Form_Load(false, sDivision, sSoldToCode, sShipToCode);
                    popCustomer.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                    popCustomer.ShowDialog();

                    if (popCustomer.SoldToCode != "" && popCustomer.SoldToCode != null)
                    {
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE), popCustomer.SoldToCode);
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE), popCustomer.ShipToCode);
                    }
                }
            }
        }

        #endregion

                                                  
        #region 7. Filter
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

                                                                                                       

                    break;
                case "ScmSitebyEndCustomer40":

                                                                                                     

                    break;

                case "UserPlantSiteByDivision":

                    Filter["DIVISION_ID"] = sDivision;

                                                                                                    

                    break;
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
                                                      
                                                                                                                                                                                         
            SetChangeControl("UserSiteByEndCustomer", clbDivisions.ControlValues, string.Empty, clbEndCustomer.ControlValues);
                                                    
            clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);
        }

        private void clbTeam_SelectedIndexChanged(object sender, EventArgs e)
        {
            string sDivision = clbDivisions.ControlValues;
            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);

                                                      
                                                                                                                                                           
            SetChangeControl("EndCustomerByDivision", sDivision, sTeam);
                                                    

            clsCtrl.setListBox(dtEndCustomer, clbEndCustomer, true);

            string sEndCustomer = CString.GetCheckedListValue(dtEndCustomer, clbEndCustomer.ControlValues);

                                                      
                                                                                                                                                        
            SetChangeControl("UserSiteByEndCustomer", clbDivisions.ControlValues, string.Empty, sEndCustomer);
                                                    
            clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);
        }

                                               
                                                                 
                                                                
        private void SetLockRow()
        {
            for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
            {
                string sDATA_TYPE_CODE = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DATA_TYPE_CODE)).ToString();

                if (!sDATA_TYPE_CODE.Equals("SCM"))
                {
                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.DATA_TYPE_CODE) + 1, iRow, siMain.GetMaxColumnIndex(), true, false);
                }
            }
        }



        private DataTable GetSpdTitle(string sheetname)
        {
            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                DataTable dt = null;

                var request = new FoxDataRequest("DM.DMF0000_GET_COMMON_SPREAD_TITLE");
                request.Parameters["p_start_yyyymmdd"] = "";
                request.Parameters["p_end_yyyymmdd"] = "";
                request.Parameters["p_created_by"] = base.UserInfo.UserId;
                request.Parameters["p_program_id"] = "DMF0072";
                request.Parameters["p_sheet_name"] = sheetname;
                request.Parameters["p_division_id"] = CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues);

                dt = client.ExecuteDataSet(request).DataSet.Tables[0];

                return dt;
            }
        }


                                  
                                       
                                     
                                     
                                                
            
                                                                 
                
                                                                                                        
                    
                                                                                                                                
                                                                                                                          
                                                                                                                        
                                                                                                                          
                                                                                                                          
                                                                                                                                  
                                                                                                                                
                                                                                                                                    
                                                                                                                          
                                                                                                                            
                                                                                                                      
                                                                                                                      
                                                                                                                  
                                                                                                                  
                                                                                                                                  

                                                                                                   
                        
                                                                                                    
                                                                                    
                                                                              
                                                                            
                                                                              
                                                                              
                                                                                      
                                                                                    
                                                                                        
                                                                              
                                                                                
                                                                          
                                                                          
                                                                      
                                                                      
                                                                                      

                                             
                            
                                                                                        
                            
                               
                            
                                                                                             

                                                                    
                                
                                                        
                                
                            
                        
                    
                
                      
                                                       

                                                                 
                
                                                                                                        
                    
                                                                                                                                
                                                                                                                          
                                                                                                                        
                                                                                                                          
                                                                                                                          
                                                                                                                                  
                                                                                                                                
                                                                                                                                    
                                                                                                                          
                                                                                                                            
                                                                                                                      
                                                                                                                      
                                                                                                                  
                                                                                                                  
                                                                                                                                  

                                                                                                                                             
                                                                                                                                     
                                                                                                                                   
                                                                                                                                     
                                                                                                                                     
                                                                                                                                             
                                                                                                                                           
                                                                                                                                               
                                                                                                                                     
                                                                                                                                       
                                                                                                                                 
                                                                                                                                 
                                                                                                                             
                                                                                                                             
                                                                                                             
                    
                

                                     
                                       
            
    }
}
