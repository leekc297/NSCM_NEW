using FarPoint.Win.Spread;
using FarPoint.Win.Spread.CellType;
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
using System.Windows.Forms;

using GSCM.SCM.Popup.UIL;
using GSCM.DM.Plan.UIL;
using GSCM.DM.Plan.UIL.POPUP;
using System.Diagnostics;

using GSCM.Windows.Forms.Service;
using GSCM.FP.Common.UIL.Service;

                                                                                                                            
                  
                  
                                                  
                  
                  
                                                                                                                           
                                            
                                                                                                                           
                                                
                                                                                                                               
                                                                                 
                                                                               
                                                                                                                           
                                                                                                              
                                                                                               
                                                                                                                                        
                                                                   
                                                                             
                                                                 
                                                                                                    
                                                                                                 
                                                                 
                                                                      
                                                                               
                                                                                                         
                                                                                                           
                                                                                                                 
                                                                                                 
                                                     
                                                      
                                                                 
                                                                     
                                                                                  
                                                             
                                                      
                                                                        
                                                          
                                                                                              
                                                                                           
                                                                                               
                                                                         
                                                                                         
                                                                                                     
                                                                   
                                                             
                                                                                                                 
                                                                                                
                                                                              
                                                                                                               
                                                                                             
                                                                                         
                                                                                                 
                                                                                                                            

namespace GSCM.DM.Master.UIL
{
    public partial class DMF0005_SaleSite_PjtModelMapping : BaseForm
    {
        #region 1. Setting
        CControl clsCtrl = null;

                          
        private DataSet saveDS = null;
        private DataSet saveDSSub = null;
        private DataTable dtTitle = null;

        private DataTable dtDivision = null;
        private DataTable dtTeam = null;
        private DataTable dtEndCustomer = null;
        private DataTable dtSalesSite = null;
        private DataTable dtSalesSiteInfo = null;
        private DataTable dtItemType = null;
        private DataTable dtYesOrNo = Data.Common(Data.Type.YesOrNo);
                                    
        private DataTable dtCellName = null;

        private DataTable dtInvSite = null;

                                                           
        private DataTable dtSalesCompany = null;
        private DataTable dtSalesPlant = null;

                                                                              
        private DataTable dtProductionProcess = null;

                                                                                               
        private DataTable dtCRGE_ORG_NM = null;                                            
        private DataTable dtCUST_ENG_NM = null;                                                  
                                                                                             

                            
        private string projectCode = string.Empty;
        private string division = string.Empty;
        private string site_ID = string.Empty;

                 
        SpreadInfo siMain = null;
        SpreadInfo siSub = null;

        TextCellType cellTypeImage = null;

                      
                       
                       
        private struct SpdSheet
        {
            public static string shtMain = "Production";
            public static string shtSub = "Purchase";
        }

                      
                  
                       
        private struct DefColumns
        {
                   
            public static string DIVISION_ID = "DIVISION_ID";
            public static string DIVISION_NAME = "DIVISION_NAME";
            public static string DEPT_ID = "DEPT_ID";
            public static string DEPT_NAME = "DEPT_NAME_KO";
            public static string TEAM_ID = "DEPT_ID";
            public static string TEAM_NAME = "TEAM_NAME_KO";
            public static string END_CUSTOMER = "END_CUSTOMER";
            public static string SOLDTO_CODE = "SOLDTO_CODE";
            public static string SOLDTO_DESCRIPTION = "SOLDTO_DESCRIPTION";
            public static string SHIPTO_CODE = "SHIPTO_CODE";
            public static string SHIPTO_DESCRIPTION = "SHIPTO_DESCRIPTION";
            public static string SCM_SITE_ID = "SCM_SITE_ID";
            public static string PROJECT_CODE = "PROJECT_CODE";
            public static string PROJECT_NAME = "PROJECT_NAME";
            public static string PROJECT_STATUS = "PROJECT_STATUS";
            public static string PROJECT_OWNER = "PROJECT_OWNER";
            public static string SALES_PLAN_ADJUST_YN = "SALES_PLAN_ADJUST_YN";
            public static string ITEM_TYPE = "ITEM_TYPE";
            public static string ITEM_CLASS_NAME = "ITEM_CLASS_NAME";
            public static string ITEM_ID = "ITEM_ID";
            public static string ITEM_NAME = "ITEM_NAME";
            public static string CELL_PER_CAR = "CELL_PER_CAR";
            public static string CELL_PER_MODULE = "CELL_PER_MODULE";
            public static string MODULE_PER_CAR = "MODULE_PER_CAR";
            public static string CUSTOMER_MODEL = "CUSTOMER_MODEL";

                                                                
            public static string CONSENSUS_MKT = "CONSENSUS_MKT";
            public static string CONSENSUS_ESS = "CONSENSUS_ESS";
            public static string CONSENSUS_SCM = "CONSENSUS_SCM";
            public static string INVENTORY_DAY = "INVENTORY_DAY";
            public static string CHANGE_REASON = "CHANGE_REASON";

                                                                  
            public static string SALES_COMPANY = "SALES_COMPANY";
            public static string SALES_PLANT = "SALES_PLANT";

            public static string NICK_NAME = "NICK_NAME";
            public static string BPMS_EXIST = "BPMS_EXIST";

            public static string ALT_SIM_YN = "ALT_SIM_YN";                                          
            public static string DESCRIPTION = "DESCRIPTION";                                 
            public static string PROJECT_INFO = "PROJECT_INFO";                                           

            public static string LIABILITY_PERIOD = "LIABILITY_PERIOD";
            public static string CURRENCY = "CURRENCY";
            public static string VALID_YN = "VALID_YN";
            public static string LAST_UPDATE_DATE = "LAST_UPDATE_DATE";
            public static string LAST_UPDATED_BY = "LAST_UPDATED_BY";
            public static string VMI_LT = "VMI_LT";

            public static string EditFlag = "EDIT_FLAG";
                                                                                              
            public static string EditFlag3 = "EDIT_FLAG3";                          

                                        
            public static string CellName = "CELL_NAME";

                                                                    
            public static string KWH = "KWH";

                                                          
            public static string CELL_TYPE_81 = "CELL_TYPE_81";
            public static string CELL_TYPE_82 = "CELL_TYPE_82";

                    
            public static string DEPT_ID2 = "DEPT_ID2";
            public static string END_CUSTOMER40 = "END_CUSTOMER40";
            public static string SOLDTO_CUSTOMER = "SOLDTO_CUSTOMER";
            public static string SCM_SITE_ID40 = "SCM_SITE_ID40";

            public static string CUST_GROUP = "CUST_GROUP";
            public static string CUST_GROUP_DTL = "CUST_GROUP_DTL";
            public static string OWNER = "OWNER";
            public static string APPLICATION = "APPLICATION";
            public static string ROUTE = "ROUTE";
            public static string ATTRIBUTE1 = "ATTRIBUTE1";
            public static string ATTRIBUTE2 = "ATTRIBUTE2";
            public static string ATTRIBUTE4 = "ATTRIBUTE4";
                                                             
            public static string ATTRIBUTE5 = "ATTRIBUTE5";

            public static string USER_ID = "USER_ID";
            public static string EDI = "EDI";

            public static string REPORT_GROUP1 = "REPORT_GROUP1";
            public static string REPORT_GROUP2 = "REPORT_GROUP2";
            public static string REPORT_GROUP3 = "REPORT_GROUP3";
            public static string REPORT_GROUP4 = "REPORT_GROUP4";
            public static string REPORT_GROUP5 = "REPORT_GROUP5";
            public static string REPORT_GROUP6 = "REPORT_GROUP6";
            public static string REPORT_GROUP7 = "REPORT_GROUP7";
            public static string REPORT_GROUP8 = "REPORT_GROUP8";

            public static string OS_CORP = "OS_CORP";
            public static string CONTRIBUTION_TYPE = "CONTRIBUTION_TYPE";
            public static string CELL_TYPE = "CELL_TYPE";
            public static string EDI_LT = "EDI_LT";

                                                                             
            public static string PARTIAL_PLAN_YN = "PARTIAL_PLAN_YN";

                                                                                  
            public static string PRODUCTION_PROCESS = "PRODUCTION_PROCESS";
                                                                                       
            public static string MODULE_VARIANT = "MODULE_VARIANT";
                                                                               
            public static string CATHODE_MATERIALS = "CATHODE_MATERIALS";

            public static string ColumnName = "COLUMN_NAME";
            public static string ColumnLabel = "COLUMN_LABEL_NAME";
            public static string SmallLabelName = "SMALL_CLASS_LABEL_NAME";
            public static string LargeLabelName = "LARGE_CLASS_LABEL_NAME";

                                                                             
            public static string ENERGE_WH = "ENERGE_WH";

                                                                              
            public static string PROJECT_S_OP_REPORT = "PROJECT_S_OP_REPORT";

                                                                                                 
            public static string CELL_S_OP_REPORT = "CELL_S_OP_REPORT";
            public static string ACTIVE_FLAG = "ACTIVE_FLAG";
                                                                                               

                                                             
            public static string PRJ_OWNR_ID = "PRJ_OWNR_ID";
            public static string DEPT_ID_82 = "DEPT_ID_82";
            public static string USER_ID_82 = "USER_ID_82";
                                                           

                                                                                                  
            public static string CRGE_ORG_NM = "CRGE_ORG_NM";                                            
            public static string CUST_ENG_NM = "CUST_ENG_NM";                                                  
                                                                                                

        }
        private struct DefColumnsLabel
        {
            public static string DIVISION_ID = "Divsion";
            public static string DIVISION_NAME = "Divsion";
            public static string DEPT_ID = "Department";
            public static string DEPT_NAME = "Department";
            public static string TEAM_ID = "Team";
            public static string TEAM_NAME = "Team";
            public static string END_CUSTOMER = "End Customer";
            public static string SOLDTO_CODE = "Rep. Sold To Code";
            public static string SOLDTO_DESCRIPTION = "Rep. Sold To Code";
            public static string SHIPTO_CODE = "Rep. Ship To";
            public static string SHIPTO_DESCRIPTION = "Rep. Ship To";
            public static string SCM_SITE_ID = "Sales Site";
            public static string PROJECT_CODE = "Project Code";
            public static string PROJECT_NAME = "Project";
            public static string PROJECT_STATUS = "Project Status";
            public static string PROJECT_OWNER = "Project Owner";
            public static string SALES_PLAN_ADJUST_YN = "Sales Plan Sync";
            public static string ITEM_TYPE = "Item Type";
            public static string ITEM_CLASS_NAME = "Model Type";
            public static string ITEM_ID = "Model";
            public static string ITEM_NAME = "Model Name";
            public static string CELL_PER_CAR = "Cell/Car";
            public static string CELL_PER_MODULE = "Cell/Module";
            public static string MODULE_PER_CAR = "Module/Car";
            public static string CUSTOMER_MODEL = "Customer Model";
            public static string NICK_NAME = "Nick Name";
            public static string BPMS_EXIST = "BPMS Exist";
            public static string LIABILITY_PERIOD = "Liablity";
            public static string CURRENCY = "Currency";
            public static string VALID_YN = "Active";
            public static string LAST_UPDATE_DAT = "Update Date";
            public static string LAST_UPDATED_BY = "Update User";

                                                                                            
            public static string SALES_COMPANY = "SALES_COMPANY";
            public static string SALES_PLANT = "SALES_PLANT";

                                                                      
            public static string KWH = "Kwh";
                                                          
            public static string CELL_TYPE_81 = "Celltype";
            public static string CELL_TYPE_82 = "Celltype";

                                                                                  
            public static string PRODUCTION_PROCESS = "Production Process";
        }

        private string sBinding = "GSCM.DM.Master.WSL/FoxDataService.svc";
        private string sScmBinding = "GSCM.SCM.Master.WSL/FoxDataService.svc";

        private string sMyDeptID = string.Empty;

        #endregion

        #region 2. Construct

        public DMF0005_SaleSite_PjtModelMapping()
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
            InitEvent();
            DefineProperty();
            ActiveCell();
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

                    dtSalesSite = DataService.GetDMInnerTable("UserSiteByEndCustomer", Filter);

                    break;
            }
        }

        #endregion               
                                            

        #region 3. Define

        private void InitControls()
        {
            dtDivision = null;
                                                                        
                                                                                                                                            

            SetChangeControl("MyDivision");

                                                                 
            clsCtrl.setListBox(dtDivision, clbDivision, false, "CODE", "NAME");

            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);

                                                                        
                                                                                                                                  
            SetChangeControl("UserTeamByDivision", sDivision);
            clsCtrl.setListBox(dtTeam, clbTeam, true);

            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);

                                                                                     
            if (sDivision == "40")
            {
                                                                            
                                                                                                                                                                                           

                SetChangeControl("EndCustomerByDivision", sDivision, clbTeam.ControlValues);
                lblProject.Enabled = false;
                btnProject.Enabled = false;

                      
                switch (UserInfoContext.Current["NowGroupID"])
                {
                    case "ADMIN":
                    case "DM ADMIN":
                    case "SCM PI ADMIN":
                        layoutControlItem11.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Always;
                        layoutControlItem5.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Always;
                                                                    
                        layoutControlItem6.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Always;
                        break;
                    default:
                        layoutControlItem11.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
                        layoutControlItem5.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
                                                                    
                        layoutControlItem6.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
                        break;
                }
            }
            else
            {
                                                                            
                                                                                                                                                               

                SetChangeControl("EndCustomerByDivision", sDivision, sTeam);
                lblProject.Enabled = true;
                btnProject.Enabled = true;
                layoutControlItem11.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
            }
            clsCtrl.setListBox(dtEndCustomer, clbEndCustomer, true);

            string sEndCustomer = CString.GetCheckedListValue(dtEndCustomer, clbEndCustomer.ControlValues);

                                                                        
                                                                                                                                                        

            SetChangeControl("UserSiteByEndCustomer", sDivision, string.Empty, sEndCustomer);
            clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);

            dtItemType = Data.Common(Data.Type.ItemType, false);                                                     
            clsCtrl.setListBox(dtYesOrNo, cboActive, true);

                                                                                    
                                                                            
                                                          
                                                                          
                                                                                  
        }

        private void DefineProperty()
        {
            usrConditionPanel1.Height = 75;
            chkDetail.Checked = true;

            if (Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) != null)
            {
                sMyDeptID = Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId, UserInfoContext.Current["NowGroupID"].ToString()).Rows[0][0].ToString();
            }

            siSub.ImagePopUp = imageList1.Images[0];
            cellTypeImage = new TextCellType();
            cellTypeImage.BackgroundImage = new FarPoint.Win.Picture(siSub.ImagePopUp);
            cellTypeImage.BackgroundImage.AlignHorz = FarPoint.Win.HorizontalAlignment.Right;
            cellTypeImage.CharacterCasing = CharacterCasing.Upper;

            if (clbDivision.ControlValues.ToString() == "40")
            {
                splitContainer1.Panel2Collapsed = true;
                chkDetail.Checked = false;
                layoutControlItem1.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
            }
            else
            {
                splitContainer1.Panel2Collapsed = false;
                chkDetail.Checked = true;
                layoutControlItem1.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Always;
                layoutControlItem5.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
                                                            
                layoutControlItem6.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
            }
                                                                                            
            FarPoint.Win.Spread.Model.DefaultSheetDataModel dsdm = (FarPoint.Win.Spread.Model.DefaultSheetDataModel)siMain.Sheet(SpdSheet.shtMain).Models.Data;
            dsdm.Changed += new FarPoint.Win.Spread.Model.SheetDataModelEventHandler(spdMain_Changed);
        }

        private void ActiveCell()
        {
            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sScmBinding))
            {
                var request = new FoxDataRequest("SCM.SCM0001_GET_LOOKUP_VALUES");
                request.Parameters["p_lookup_type"] = "INVENTORY_DAYS_SETUP_SITE";
                dtInvSite = client.ExecuteDataSet(request).DataSet.Tables[0];
            }
        }

        private void CreateSpread()
        {
            this.AddSheet(spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30);
            siMain = GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex);

            this.AddSheet(spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 1, 1, 30);
            siSub = GetSheetInfo(spdSub.Name, spdSub.ActiveSheetIndex);

            siMain.ChangeSheet();

            InitSpread(siMain);
            InitSpread(siSub);

            fps = siMain.SpreadObject;
        }

        private void InitSpread(SpreadInfo spreadInfo)
        {
            dtTitle = GetSpdTitle(spreadInfo.ActiveSheet.SheetName);
            if (spreadInfo.ActiveSheet.SheetName.ToString() == "Production")
            {
                spreadInfo.CreateSheetHeaderColumn(spreadInfo, 2, dtTitle);
                SetSpreadHeaderSpan(dtTitle);
            }
            else
            {
                spreadInfo.CreateSheetHeaderColumn(spreadInfo, 1, dtTitle);
            }

                                            
            siMain.SmartColMerge();
                                 
            spreadInfo.SetReNumerCellType(spreadInfo, spreadInfo.GetColumnIndex(DefColumns.KWH), 0, 10, 999999999);
        }

        private void InitEvent()
        {
            FarPoint.Win.Spread.Model.DefaultSheetDataModel dsdm = (FarPoint.Win.Spread.Model.DefaultSheetDataModel)siMain.Sheet(SpdSheet.shtMain).Models.Data;
            dsdm.Changed += new FarPoint.Win.Spread.Model.SheetDataModelEventHandler(shtMainDataModel_Changed);

            FarPoint.Win.Spread.Model.DefaultSheetDataModel dsdm2 = (FarPoint.Win.Spread.Model.DefaultSheetDataModel)siSub.Sheet(SpdSheet.shtSub).Models.Data;
            dsdm2.Changed += new FarPoint.Win.Spread.Model.SheetDataModelEventHandler(shtSubDataModel_Changed);

            this.clbDivision.SelectedIndexChanged += new System.EventHandler(this.clbDivision_SelectedIndexChanged);
        }

        #endregion

        #region  4. Button
        protected override void FindButton()
        {
            FindData_Main();
        }

        protected override void InsertButton()
        {
                                                                                                                                   
            if (UserInfoContext.Current["NowGroupID"] == "SCP Planner")
            {
                MessageHelper.GMessageBox("MSG00096", new object[] { siMain.ActiveSheet.SheetName, siSub.ActiveSheet.SheetName });
                               
                return;
            }
                                                                                                                                 

            txtProject.Text = txtProject.Text + " ";
            HaltAutoFilter = true;                 
            InsertRow();
            HaltAutoFilter = false;                
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
                                                                                                                                   
            string sDivisionID = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);
            if (sDivisionID.Substring(0, 2) == "81" || sDivisionID.Substring(0, 2) == "82")
            {
                if (UserInfoContext.Current["NowGroupID"] == "SCP Planner")
                {
                    MessageHelper.GMessageBox("MSG00096", new object[] { siMain.ActiveSheet.SheetName, siSub.ActiveSheet.SheetName });
                                   
                    return;
                }
            }
                                                                                                                                 

            if (fps != null)
            {
                if (fps.Name == "spdMain")
                {
                    if (!siSub.IsLock(siSub.ActiveSheet.SheetName))
                    {
                        MessageHelper.GMessageBox("MSG00130", new object[] { siSub.ActiveSheet.SheetName, siMain.ActiveSheet.SheetName });
                        return;
                    }

                    siMain = GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex);
                    siMain.SwitchLock();

                    if (siMain.GetMaxRowIndex() < 0) return;

                    for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
                                                              
                    {
                        int s = siMain.GetMaxRowIndex();
                        if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToString() == CAppSetting.StringY)
                        {
                            string sDivision = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                                                                                                                 
                                                                                                
                            if (sDivision.Substring(0, 2) == "81")
                            {
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.DEPT_ID), iRow, siMain.GetColumnIndex(DefColumns.DEPT_ID), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), iRow, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.OWNER), iRow, siMain.GetColumnIndex(DefColumns.OWNER), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE), iRow, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.SOLDTO_DESCRIPTION), iRow, siMain.GetColumnIndex(DefColumns.SOLDTO_DESCRIPTION), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE), iRow, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.SHIPTO_DESCRIPTION), iRow, siMain.GetColumnIndex(DefColumns.SHIPTO_DESCRIPTION), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), iRow, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.PROJECT_STATUS), iRow, siMain.GetColumnIndex(DefColumns.PROJECT_STATUS), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.PROJECT_OWNER), iRow, siMain.GetColumnIndex(DefColumns.PROJECT_OWNER), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), iRow, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), iRow, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID), iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.ITEM_NAME), iRow, siMain.GetColumnIndex(DefColumns.ITEM_NAME), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.PROJECT_OWNER), iRow, siMain.GetColumnIndex(DefColumns.PROJECT_OWNER), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), iRow, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.CUSTOMER_MODEL), iRow, siMain.GetColumnIndex(DefColumns.CUSTOMER_MODEL), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.NICK_NAME), iRow, siMain.GetColumnIndex(DefColumns.NICK_NAME), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.BPMS_EXIST), iRow, siMain.GetColumnIndex(DefColumns.BPMS_EXIST), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), iRow, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), iRow, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), true);
                                                                                       
                                                                                                  
                                                                                                                                                                                                      
                                                                                     
                                                                                                                                     
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG), iRow, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG), true);
                                                                                                                                   
                            }
                                                                                                
                            else if (sDivision == "82")
                            {
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), true);
                                                                     
                                                                                                                                                            
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.DEPT_ID_82), iRow, siMain.GetColumnIndex(DefColumns.DEPT_ID_82), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), iRow, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.OWNER), iRow, siMain.GetColumnIndex(DefColumns.OWNER), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE), iRow, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.SOLDTO_DESCRIPTION), iRow, siMain.GetColumnIndex(DefColumns.SOLDTO_DESCRIPTION), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE), iRow, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.SHIPTO_DESCRIPTION), iRow, siMain.GetColumnIndex(DefColumns.SHIPTO_DESCRIPTION), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), iRow, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.PROJECT_STATUS), iRow, siMain.GetColumnIndex(DefColumns.PROJECT_STATUS), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.PROJECT_OWNER), iRow, siMain.GetColumnIndex(DefColumns.PROJECT_OWNER), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), iRow, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), iRow, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID), iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.ITEM_NAME), iRow, siMain.GetColumnIndex(DefColumns.ITEM_NAME), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.CUSTOMER_MODEL), iRow, siMain.GetColumnIndex(DefColumns.CUSTOMER_MODEL), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.NICK_NAME), iRow, siMain.GetColumnIndex(DefColumns.NICK_NAME), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.BPMS_EXIST), iRow, siMain.GetColumnIndex(DefColumns.BPMS_EXIST), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), iRow, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), iRow, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), true);

                                                                                                                                     
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG), iRow, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG), true);
                                                                                                                                   

                                                                                                                                     
                                int iCol = siMain.GetColumnIndex(DefColumns.SCM_SITE_ID);
                                string columnValue = siMain.GetText(iRow, iCol).ToString();
                                int iCol1 = siMain.GetColumnIndex(DefColumns.CONSENSUS_MKT);

                                if (columnValue != "LGCAU_AU_BNE" && columnValue != "LGCEG_DE_MWA" && columnValue != "LGCMI_US_LGB")
                                {
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.CONSENSUS_MKT), iRow, siMain.GetColumnIndex(DefColumns.CONSENSUS_MKT), true);
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.CONSENSUS_ESS), iRow, siMain.GetColumnIndex(DefColumns.CONSENSUS_ESS), true);
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.CONSENSUS_SCM), iRow, siMain.GetColumnIndex(DefColumns.CONSENSUS_SCM), true);
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.INVENTORY_DAY), iRow, siMain.GetColumnIndex(DefColumns.INVENTORY_DAY), true);
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REASON), iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REASON), true);
                                }
                                                                                                                                   
                            }
                                                                                               
                            else if (sDivision == "40")
                            {
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.DEPT_ID2), iRow, siMain.GetColumnIndex(DefColumns.DEPT_ID2), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), iRow, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE), iRow, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.SOLDTO_DESCRIPTION), iRow, siMain.GetColumnIndex(DefColumns.SOLDTO_DESCRIPTION), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE), iRow, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.SHIPTO_DESCRIPTION), iRow, siMain.GetColumnIndex(DefColumns.SHIPTO_DESCRIPTION), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40), iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.OWNER), iRow, siMain.GetColumnIndex(DefColumns.OWNER), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), iRow, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), iRow, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID), iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.ITEM_NAME), iRow, siMain.GetColumnIndex(DefColumns.ITEM_NAME), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.NICK_NAME), iRow, siMain.GetColumnIndex(DefColumns.NICK_NAME), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), iRow, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), iRow, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE4), iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE4), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE5), iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE5), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.SOLDTO_CUSTOMER), iRow, siMain.GetColumnIndex(DefColumns.SOLDTO_CUSTOMER), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.CELL_TYPE), iRow, siMain.GetColumnIndex(DefColumns.CELL_TYPE), true);

                                                                                                 
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.ENERGE_WH), iRow, siMain.GetColumnIndex(DefColumns.ENERGE_WH), true);

                                                                                                                                                
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.CELL_S_OP_REPORT), iRow, siMain.GetColumnIndex(DefColumns.CELL_S_OP_REPORT), true);

                                                                                                                                     
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG), iRow, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG), true);
                                                                                                                                   

                                if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag3)).ToString() == CAppSetting.StringY)
                                {
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.CUST_GROUP), iRow, siMain.GetColumnIndex(DefColumns.CUST_GROUP), true);
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.PRODUCTION_PROCESS), iRow, siMain.GetColumnIndex(DefColumns.PRODUCTION_PROCESS), true);
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.SALES_COMPANY), iRow, siMain.GetColumnIndex(DefColumns.SALES_COMPANY), true);
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.SALES_PLANT), iRow, siMain.GetColumnIndex(DefColumns.SALES_PLANT), true);
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE1), iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE1), true);
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE2), iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE2), true);
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.CUST_GROUP_DTL), iRow, siMain.GetColumnIndex(DefColumns.CUST_GROUP_DTL), true);
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.ROUTE), iRow, siMain.GetColumnIndex(DefColumns.ROUTE), true);
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.APPLICATION), iRow, siMain.GetColumnIndex(DefColumns.APPLICATION), true);
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.LIABILITY_PERIOD), iRow, siMain.GetColumnIndex(DefColumns.LIABILITY_PERIOD), true);
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.CURRENCY), iRow, siMain.GetColumnIndex(DefColumns.CURRENCY), true);
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.REPORT_GROUP1), iRow, siMain.GetColumnIndex(DefColumns.REPORT_GROUP1), true);
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.REPORT_GROUP2), iRow, siMain.GetColumnIndex(DefColumns.REPORT_GROUP2), true);
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.REPORT_GROUP3), iRow, siMain.GetColumnIndex(DefColumns.REPORT_GROUP3), true);
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.REPORT_GROUP4), iRow, siMain.GetColumnIndex(DefColumns.REPORT_GROUP4), true);
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.REPORT_GROUP6), iRow, siMain.GetColumnIndex(DefColumns.REPORT_GROUP6), true);

                                                                       
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.PROJECT_INFO), iRow, siMain.GetColumnIndex(DefColumns.PROJECT_INFO), true);
                                }
                            }
                        }
                        else
                        {
                            if (String.IsNullOrEmpty(siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction))) == true)
                            {
                                                           
                                string sDivision = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();

                                                         
                                if (sDivision == "40" && siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag3)).ToString() == CAppSetting.StringY)
                                {
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRow, siMain.GetColumnIndex(DefColumns.VALID_YN) - 1, true);
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.VALID_YN) + 1, iRow, siMain.GetMaxColumnIndex(), true);
                                }
                                else
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRow, siMain.GetColumnIndex(DefColumns.EditFlag), true);
                            }
                            else if (siMain.GetValue(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)).ToString() == CAppSetting.StringI)
                            {
                                string sDivision = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                                                                                                                     
                                if (sDivision.Substring(0, 2) == "81")
                                {
                                    InsertRowLockRangeMain(iRow);
                                }
                                if (sDivision == "82")
                                {
                                    InsertRowLockRangeMain82(iRow);
                                }
                                else if (sDivision == "40")
                                {
                                    InsertRowLockRangeMain40(iRow);
                                }
                                       
                                    
                                                                      
                                    
                            }
                        }

                                                                           
                        if (IsEditMode)
                        {
                            string sDivision = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                            if (sDivision == "40")
                            {
                                string sACTIVE_FLAG = string.Empty;

                                                                                                                                                       
                                if (UserInfoContext.Current["NowGroupID"] == "SCP Planner")
                                {
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.CELL_S_OP_REPORT), iRow, siMain.GetColumnIndex(DefColumns.CELL_S_OP_REPORT), false);
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG), iRow, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG), true);
                                }
                                                                                                                                                     

                                if (UserInfoContext.Current["NowGroupID"] == "DM ADMIN")
                                { }
                                else
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.ALT_SIM_YN), iRow, siMain.GetColumnIndex(DefColumns.ALT_SIM_YN), true);
                            }
                        }
                    }
                }

                if (fps.Name == "spdSub")
                {
                    if (!siMain.IsLock(siMain.ActiveSheet.SheetName))
                    {
                        MessageHelper.GMessageBox("MSG00130", new object[] { siMain.ActiveSheet.SheetName, siSub.ActiveSheet.SheetName });
                        return;
                    }

                    siSub = GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex);
                    siSub.SwitchLock();

                    for (int iRow = 0; iRow <= siSub.GetMaxRowIndex(); iRow++)
                    {
                        if (siSub.GetValue(iRow, siSub.GetColumnIndex(DefColumns.EditFlag)).ToString() == CAppSetting.StringY)
                        {
                                                                                                                                       
                            string sDivision = siSub.GetValue(iRow, siSub.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                            if (sDivision.Substring(0, 2) == "81")
                            {
                                siSub.LockColumn(siSub.GetColumnIndex(DefColumns.PROJECT_CODE), siSub.GetColumnIndex(DefColumns.PROJECT_STATUS), true);
                                siSub.LockColumn(siSub.GetColumnIndex(DefColumns.ITEM_TYPE), siSub.GetColumnIndex(DefColumns.ITEM_ID), true);
                                siSub.LockColumn(siSub.GetColumnIndex(DefColumns.MODULE_PER_CAR), siSub.GetColumnIndex(DefColumns.CUSTOMER_MODEL), true);
                                siSub.LockColumn(siSub.GetColumnIndex(DefColumns.NICK_NAME), siSub.GetColumnIndex(DefColumns.OWNER), true);
                                siSub.LockColumn(siSub.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), siSub.GetColumnIndex(DefColumns.EditFlag), true);

                                                                                           
                                                                                                  
                                                                                                                                                              
                                                                                         
                            }
                            else
                            {
                                siSub.LockColumn(siSub.GetColumnIndex(DefColumns.PROJECT_CODE), siSub.GetColumnIndex(DefColumns.PROJECT_STATUS), true);

                                                                                         
                                siSub.LockColumn(siSub.GetColumnIndex(DefColumns.ITEM_TYPE), siSub.GetColumnIndex(DefColumns.ITEM_ID), true);
                                siSub.LockColumn(siSub.GetColumnIndex(DefColumns.CUSTOMER_MODEL), siSub.GetColumnIndex(DefColumns.CUSTOMER_MODEL), true);

                                                                                                                                                       
                                siSub.LockColumn(siSub.GetColumnIndex(DefColumns.NICK_NAME), siSub.GetColumnIndex(DefColumns.OWNER), true);
                                siSub.LockColumn(siSub.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), siSub.GetColumnIndex(DefColumns.EditFlag), true);
                            }
                        }
                        else
                        {
                            siSub.LockRange(iRow, 0, iRow, siSub.GetMaxColumnIndex(), true);
                        }
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

        private async void FindData_Main()
        {
            GSCM.Windows.Forms.UI.ProgressForm prg = new GSCM.Windows.Forms.UI.ProgressForm();
            prg.Show();

            CanModelChange = false;
            InitSpread(siMain);
            InitSpread(siSub);

            string sDivisionID = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);
            string sActive = cboActive.Text;
                                                                                         
                                                                                                              
                                                                                                        

            string sEndCustReportYN = "N";
                                                       
            string sProjectInfoYN = "N";

            if (sDivisionID == "40")
            {
                sEndCustReportYN = chkEndCust.Checked == true ? "Y" : "N";
                                                           
                sProjectInfoYN = chkProjectInfo.Checked == true ? "Y" : "N";
            }

            if (sDivisionID == "")
            {
                MessageHelper.GMessageBox("MSG00097");
                return;
            }

                            
            SearchStartTime();

            var asyncProxy = new FoxAsyncProxy(this);
            asyncProxy.ShowProgress = false;

            var ds = await asyncProxy.ExecuteAsync<DataSet>(() =>
            {
                using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
                {
                    var request = new FoxDataRequest("DM.DMF0005_GET_SALES_SITE_MODEL_PRODUCTION");
                    request.CommandTimeout = 10 * 60;
                    request.Parameters["p_division_id"] = sDivisionID;                               
                    request.Parameters["p_dept_id"] = clbTeam.ControlValues;
                    request.Parameters["p_end_customer"] = clbEndCustomer.ControlValues;
                    request.Parameters["p_scm_site_id"] = clbSalesSite.ControlValues;
                    request.Parameters["p_project_code"] = txtProject.Text;
                    request.Parameters["p_item_id"] = txtItemId.Text;
                    request.Parameters["p_valid_yn"] = sActive;
                    request.Parameters["p_created_by"] = base.UserInfo.UserId;
                    request.Parameters["p_userinfo"] = UserInfoContext.Current["NowGroupID"].ToString();
                    request.Parameters["p_owner"] = txtOwner.Text;
                    request.Parameters["p_user_dept_id"] = UserInfoContext.Current["Dept_ID"].ToString();                  

                    request.Parameters["p_end_cust_report_yn"] = sEndCustReportYN;

                                                               
                    request.Parameters["p_project_info_yn"] = sProjectInfoYN;

                    var response = client.ExecuteDataSet(request);

                    return response.DataSet;
                }
            });

                                         
            SearchEndTime();

            siMain.Query(ds);
            siMain.LockColumn(0, siMain.GetMaxColumnIndex(), true);

            siMain.SpreadObject.SuspendLayout();
            bool bProduct = false;
            int nProduct = 0;
            string CellTypeValues = string.Empty;               
            if (sDivisionID != null && sDivisionID != "")
            {
                if (sDivisionID.Substring(0, 2) == "81")
                    CellTypeValues = DefColumns.CELL_TYPE_81;
                else if (sDivisionID == "82")
                    CellTypeValues = DefColumns.CELL_TYPE_82;
                else
                    CellTypeValues = null;
            }
            for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
            {
                                                                            
                                                                                                                               

                if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) != -1)
                {
                    siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType = cellTypeImage;

                    if (bProduct == false && siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ITEM_TYPE)).ToString() == "P" && (siMain.GetValue(iRow, siMain.GetColumnIndex(CellTypeValues)).ToString() == "CELL_TYPE_00"))
                    {
                        bProduct = true;
                        nProduct = iRow;
                    }
                }
            }

                                                                          
                
                                                                            
                                                                                                                               
                
            siMain.SpreadObject.ResumeLayout();
                           
            UIEndTime();

            siMain.SmartColMerge();

            CanModelChange = true;

                           
            saveDS = ds.Clone();
            saveDS.Tables[0].Columns.Add("A", typeof(char));

            prg.Close();

            if (bProduct)
            {
                                                                       
                MessageHelper.GMessageBox("MSG00358");
                siMain.ActiveSheet.ActiveColumnIndex = nProduct;
            }
        }

        private async void FindData_Sub(string projectCode, string sActive, string sDivision, string sSite_ID)
        {
            CanModelChange = false;
            InitSpread(siSub);

                             
            SearchStartTime();

            var asyncProxy = new FoxAsyncProxy(this);

            var ds = await asyncProxy.ExecuteAsync<DataSet>(() =>
            {
                using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
                {
                                                                                                   
                    var request = new FoxDataRequest("DM.DMF0005_GET_SALES_SITE_MODEL_PURCHASE");
                    request.CommandTimeout = 10 * 60;
                    request.Parameters["p_project_code"] = projectCode;
                    request.Parameters["p_active_flag"] = sActive;
                    request.Parameters["p_created_by"] = base.UserInfo.UserId;
                    request.Parameters["p_userinfo"] = UserInfoContext.Current["NowGroupID"].ToString();
                    request.Parameters["p_division"] = sDivision;
                    request.Parameters["p_site_id"] = sSite_ID;

                    var response = client.ExecuteDataSet(request);

                    return response.DataSet;
                }
            });

                                          
            SearchEndTime();

            siSub.Query(ds);
            siSub.LockColumn(0, siSub.GetMaxColumnIndex(), true);

                                  
                                             

                           
            UIEndTime();

            siSub.SmartColMerge();

            CanModelChange = true;

                           
            saveDSSub = ds.Clone();
            saveDSSub.Tables[0].Columns.Add("A", typeof(char));

                                                                                                                   
            FarPoint.Win.Spread.Model.DefaultSheetDataModel dsdm2 = (FarPoint.Win.Spread.Model.DefaultSheetDataModel)siSub.Sheet(SpdSheet.shtSub).Models.Data;
            dsdm2.Changed += new FarPoint.Win.Spread.Model.SheetDataModelEventHandler(spdSub_Changed);
        }

        private async void SaveData()
        {
                                                                      
            if (siMain != null && siMain.IsLock(siMain.SheetName) == false)
            {
                if (siMain.SheetName == SpdSheet.shtMain)
                {
                    int iCount = 0;

                    string sAction = string.Empty;
                    string sDivisionId = string.Empty;
                    string sDiv = string.Empty;
                    string sProjectCode = string.Empty;
                    string sSalesSiteId = string.Empty;
                    string sItemId = string.Empty;
                    string sCurrency = string.Empty;
                    string sCellPerCar = string.Empty;
                    string sCellPerModule = string.Empty;
                    string sLiabilityPeriod = string.Empty;
                    string sSalesPlanAdjustYN = string.Empty;
                    string sItemHrcyId = string.Empty;
                    string sBpmsExist = string.Empty;
                    string sALT_SIM_YN = string.Empty;                                         
                    string sDESCRIPTION = string.Empty;                                 
                    string sPROJECT_INFO = string.Empty;                                          
                    string sValidYN = string.Empty;
                    string sUserId = string.Empty;
                    string sVmiLt = string.Empty;
                                                
                    string sCellName = string.Empty;
                                                                                 
                    string sSalesCompany = string.Empty;
                    string sSalesPlant = string.Empty;
                                                                                     
                    string sPartialPlanYn = string.Empty;

                    string sKwh = string.Empty;                                                                    
                    string sCelltype = string.Empty;                                                                     

                             
                    string sCustGroup = string.Empty;
                    string sCustGroupDtl = string.Empty;
                    string sOwner = string.Empty;
                    string sApplication = string.Empty;
                    string sRoute = string.Empty;

                    string sAttribute1 = string.Empty;
                    string sAttribute2 = string.Empty;
                    string sAttribute4 = string.Empty;

                    string sEDI = string.Empty;

                    string sGroup1 = string.Empty;
                    string sGroup2 = string.Empty;
                    string sGroup3 = string.Empty;
                    string sGroup4 = string.Empty;
                    string sGroup5 = string.Empty;
                    string sGroup6 = string.Empty;
                    string sGroup7 = string.Empty;
                    string sGroup8 = string.Empty;

                    string sEDI_LT = string.Empty;

                                                                                
                    string sConsensus_Mkt = string.Empty;
                    string sConsensus_Ess = string.Empty;
                    string sConsensus_Scm = string.Empty;
                    string sInventory_Day = "0";
                    string sChange_Reason = string.Empty;
                                                                              

                                                                                      
                    string sPROJECT_S_OP_REPORT = string.Empty;

                                                                                                                                           
                    string sCELL_S_OP_REPORT = string.Empty;
                    string sACTIVE_FLAG = string.Empty;
                                                                                                                                         

                                                                                                           
                    string sCRGE_ORG_NM = string.Empty;                                            
                    string sCUST_ENG_NM = string.Empty;                                                  
                                                                                                         

                                                                                           
                    string sProductionProcess = string.Empty;
                                                               
                    string sPrjOwnerId = string.Empty;

                    int iChkCount = 0;

                    for (int i = 0; i <= siMain.GetMaxRowIndex(); i++)
                    {
                        string action = siMain.GetText(i, 0);

                        if (action != CAppSetting.FlagI && action != CAppSetting.FlagM && action != CAppSetting.FlagD)
                            continue;

                        if (sAction == "")
                        {
                            sAction = action;
                            sDivisionId = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                                                                                                                            
                                                                                                                           
                            if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                                sItemId = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString();
                            if (siMain.GetColumnIndex(DefColumns.CURRENCY) != -1)
                                sCurrency = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CURRENCY)).ToString();
                            if (siMain.GetColumnIndex(DefColumns.CELL_PER_CAR) != -1)
                                sCellPerCar = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CELL_PER_CAR)).ToString();
                            if (siMain.GetColumnIndex(DefColumns.CELL_PER_MODULE) != -1)
                                sCellPerModule = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CELL_PER_MODULE)).ToString();
                            if (siMain.GetColumnIndex(DefColumns.LIABILITY_PERIOD) != -1)
                                sLiabilityPeriod = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.LIABILITY_PERIOD)).ToString();
                            if (siMain.GetColumnIndex(DefColumns.SALES_PLAN_ADJUST_YN) != -1)
                                sSalesPlanAdjustYN = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SALES_PLAN_ADJUST_YN)).ToString();
                            sItemHrcyId = "";
                            if (siMain.GetColumnIndex(DefColumns.BPMS_EXIST) != -1)
                                sBpmsExist = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.BPMS_EXIST)).ToString();

                                                                                                
                            if (siMain.GetColumnIndex(DefColumns.ALT_SIM_YN) != -1)
                                sALT_SIM_YN = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ALT_SIM_YN)).ToString();

                                                                                   
                            if (siMain.GetColumnIndex(DefColumns.DESCRIPTION) != -1)
                                sDESCRIPTION = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DESCRIPTION)).ToString();

                            if (siMain.GetColumnIndex(DefColumns.VALID_YN) != -1)
                                sValidYN = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VALID_YN)).ToString();
                            sUserId = base.UserInfo.UserId;
                                                                                 
                                                                                                                   

                                                                                   
                            if (sDivisionId == "82")
                            {
                                if (siMain.GetColumnIndex(DefColumns.USER_ID_82) != -1)
                                    sOwner = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.USER_ID_82)).ToString();
                            }
                            else
                            {
                                if (siMain.GetColumnIndex(DefColumns.USER_ID) != -1)
                                    sOwner = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.USER_ID)).ToString();
                            }
                                                                                 

                            if (siMain.GetColumnIndex(DefColumns.EDI) != -1)
                                sEDI = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.EDI)).ToString();
                            if (siMain.GetColumnIndex(DefColumns.EDI_LT) != -1)
                                sEDI_LT = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.EDI_LT)).ToString();
                            if (siMain.GetColumnIndex(DefColumns.VMI_LT) != -1)
                                sVmiLt = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VMI_LT)).ToString();

                                                                                         
                            if (siMain.GetColumnIndex(DefColumns.SALES_COMPANY) != -1)
                                sSalesCompany = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SALES_COMPANY)).ToString();
                            if (siMain.GetColumnIndex(DefColumns.SALES_PLANT) != -1)
                                sSalesPlant = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SALES_PLANT)).ToString();

                                                                                     
                            if (siMain.GetColumnIndex(DefColumns.KWH) != -1)
                                sKwh = siMain.GetText(i, siMain.GetColumnIndex(DefColumns.KWH)).ToString().Replace(",", "");

                                                                                              
                            if (sDivisionId.Substring(0, 2) == "81")
                            {
                                                                                                  
                                if (siMain.GetColumnIndex(DefColumns.CELL_TYPE_81) != -1)
                                    sCelltype = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CELL_TYPE_81)).ToString();

                                                                                                    
                                if (siMain.GetColumnIndex(DefColumns.CATHODE_MATERIALS) != -1)
                                    sAttribute1 = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CATHODE_MATERIALS)).ToString();

                                                                                                            
                                   
                                                                                        
                                                                                                                               
                                  
                                                                                                            
                                if (siMain.GetColumnIndex(DefColumns.MODULE_VARIANT) != -1)
                                    sAttribute2 = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MODULE_VARIANT)).ToString();

                                                                                                  
                                if (siMain.GetColumnIndex(DefColumns.PROJECT_S_OP_REPORT) != -1)
                                    sPROJECT_S_OP_REPORT = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PROJECT_S_OP_REPORT)).ToString();
                            }
                            else if (sDivisionId == "82")
                            {
                                if (siMain.GetColumnIndex(DefColumns.CELL_TYPE_82) != -1)
                                    sCelltype = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CELL_TYPE_82)).ToString();

                                                                           
                                if (siMain.GetColumnIndex(DefColumns.PRJ_OWNR_ID) != -1)
                                    sPrjOwnerId = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PRJ_OWNR_ID)).ToString();

                                                                                    
                                string cConsensus_Mkt = string.Empty;
                                string cConsensus_Ess = string.Empty;
                                string cConsensus_Scm = string.Empty;
                                string Inventory_Day = string.Empty;
                                int cInventory_Day = 0;

                                if (siMain.GetColumnIndex(DefColumns.INVENTORY_DAY) != -1)
                                    Inventory_Day = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.INVENTORY_DAY)).ToString();

                                if (Inventory_Day == "")
                                {
                                    MessageBox.Show("Inventory Days 를 설정해 주세요.");
                                    sInventory_Day = "0";
                                    if (siMain.GetColumnIndex(DefColumns.INVENTORY_DAY) != -1)
                                        sInventory_Day = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.INVENTORY_DAY)).ToString();

                                    return;
                                }

                                if (siMain.GetColumnIndex(DefColumns.CONSENSUS_MKT) != -1)
                                    cConsensus_Mkt = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONSENSUS_MKT)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.CONSENSUS_ESS) != -1)
                                    cConsensus_Ess = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONSENSUS_ESS)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.CONSENSUS_SCM) != -1)
                                    cConsensus_Scm = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONSENSUS_SCM)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.INVENTORY_DAY) != -1)
                                    cInventory_Day = Convert.ToInt32(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.INVENTORY_DAY)));

                                String checkData = cConsensus_Mkt + cConsensus_Ess + cConsensus_Scm;

                                if (siMain.GetColumnIndex(DefColumns.CONSENSUS_MKT) != -1)
                                    sConsensus_Mkt = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONSENSUS_MKT)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.CONSENSUS_ESS) != -1)
                                    sConsensus_Ess = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONSENSUS_ESS)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.CONSENSUS_SCM) != -1)
                                    sConsensus_Scm = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONSENSUS_SCM)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.CHANGE_REASON) != -1)
                                    sChange_Reason = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHANGE_REASON)).ToString().Trim();
                                if (siMain.GetColumnIndex(DefColumns.INVENTORY_DAY) != -1)
                                    sInventory_Day = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.INVENTORY_DAY)).ToString();

                                if (checkData != "YYY" && cInventory_Day > 0)
                                {
                                    MessageBox.Show("CONSENSUS의 모든 항목이 'Y' 로 선택되어야 합니다.");
                                    sInventory_Day = "0";
                                    if (siMain.GetColumnIndex(DefColumns.INVENTORY_DAY) != -1)
                                        sInventory_Day = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.INVENTORY_DAY)).ToString();

                                    return;
                                }

                                if (checkData == "YYY" && cInventory_Day > 0 && sChange_Reason == "")
                                {
                                    MessageBox.Show("Change Reason 을 입력해야 저장이 가능합니다..");
                                    sInventory_Day = "0";
                                    if (siMain.GetColumnIndex(DefColumns.INVENTORY_DAY) != -1)
                                        sInventory_Day = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.INVENTORY_DAY)).ToString();

                                    return;
                                }
                                                                                    
                            }

                            if (action == "I")
                                sCelltype = "CELL_TYPE_00";

                                     
                                                                                                                         
                                                                                                                            
                                                                                                                             
                            if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() == "40")
                            {
                                if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40) != -1)
                                    sSalesSiteId = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER40) != -1)
                                    sProjectCode = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.CUST_GROUP) != -1)
                                    sCustGroup = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CUST_GROUP)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.CUST_GROUP_DTL) != -1)
                                    sCustGroupDtl = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CUST_GROUP_DTL)).ToString();
                                                                                     
                                                                                                                       
                                if (siMain.GetColumnIndex(DefColumns.APPLICATION) != -1)
                                    sApplication = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.APPLICATION)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.ROUTE) != -1)
                                    sRoute = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ROUTE)).ToString();

                                if (siMain.GetColumnIndex(DefColumns.ATTRIBUTE1) != -1)
                                    sAttribute1 = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE1)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.ATTRIBUTE2) != -1)
                                    sAttribute2 = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE2)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.ATTRIBUTE4) != -1)
                                    sAttribute4 = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE4)).ToString();

                                if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP1) != -1)
                                    sGroup1 = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.REPORT_GROUP1)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP2) != -1)
                                    sGroup2 = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.REPORT_GROUP2)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP3) != -1)
                                    sGroup3 = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.REPORT_GROUP3)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP4) != -1)
                                    sGroup4 = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.REPORT_GROUP4)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP5) != -1)
                                    sGroup5 = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.REPORT_GROUP5)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP6) != -1)
                                    sGroup6 = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.REPORT_GROUP6)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP7) != -1)
                                    sGroup7 = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.REPORT_GROUP7)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP8) != -1)
                                    sGroup8 = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.REPORT_GROUP8)).ToString();
                                                                                                       
                                if (siMain.GetColumnIndex(DefColumns.PRODUCTION_PROCESS) != -1)
                                    sProductionProcess = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PRODUCTION_PROCESS)).ToString();

                                                                                                              
                                if (siMain.GetColumnIndex(DefColumns.PROJECT_INFO) != -1)
                                    sPROJECT_INFO = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PROJECT_INFO)).ToString();

                                                                                                                                                
                                if (siMain.GetColumnIndex(DefColumns.CELL_S_OP_REPORT) != -1)
                                    sCELL_S_OP_REPORT = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CELL_S_OP_REPORT)).ToString();

                                                                                                   
                                   
                                                                                                                
                                                                                         
                                                                                                                                 
 
                                                                                                                
                                                                                         
                                                                                                                                 
                                  
                                                                                                 
                            }
                            else
                            {
                                if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) != -1)
                                    sSalesSiteId = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString();
                                if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) != -1)
                                    sProjectCode = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString();

                                                            
                                if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() == "82")
                                {
                                    if (siMain.GetColumnIndex(DefColumns.CellName) != -1)
                                        sCellName = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CellName)).ToString();

                                                                                                     
                                    if (siMain.GetColumnIndex(DefColumns.PARTIAL_PLAN_YN) != -1)
                                        sPartialPlanYn = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PARTIAL_PLAN_YN)).ToString();

                                                                               
                                    if (siMain.GetColumnIndex(DefColumns.PRJ_OWNR_ID) != -1)
                                        sPrjOwnerId = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PRJ_OWNR_ID)).ToString();
                                }

                                                                                                   
                                                               
                                if (sDivisionId.Substring(0, 2) == "81")
                                {
                                                                                                                   
                                    if (siMain.GetColumnIndex(DefColumns.CRGE_ORG_NM) != -1)
                                        sCRGE_ORG_NM = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CRGE_ORG_NM)).ToString();

                                                                                                                   
                                    if (siMain.GetColumnIndex(DefColumns.CUST_ENG_NM) != -1)
                                        sCUST_ENG_NM = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CUST_ENG_NM)).ToString();
                                }
                                                                                                 
                            }
                        }
                        else
                        {
                            sAction = sAction + "^" + action;
                            if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) != -1)
                            {
                                sDivisionId = sDivisionId + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                                sDiv = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                            }
                                                                                                                                                 
                                                                                                                                                
                            if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                                sItemId = sItemId + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString();
                            if (siMain.GetColumnIndex(DefColumns.CURRENCY) != -1)
                                sCurrency = sCurrency + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CURRENCY)).ToString();

                                                                                                
                            if (siMain.GetColumnIndex(DefColumns.ALT_SIM_YN) != -1)
                                sALT_SIM_YN = sALT_SIM_YN + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ALT_SIM_YN)).ToString();

                                                                                      
                            if (siMain.GetColumnIndex(DefColumns.DESCRIPTION) != -1)
                                sDESCRIPTION = sDESCRIPTION + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DESCRIPTION)).ToString();

                                                                                                        
                            if (sDiv != null && sDiv != "")
                            {
                                if (sDiv.Substring(0, 2) == "81")
                                {
                                                                                                        
                                    if (siMain.GetColumnIndex(DefColumns.CATHODE_MATERIALS) != -1)
                                        sAttribute1 = sAttribute1 + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CATHODE_MATERIALS)).ToString();
                                       
                                                                                            
                                                                                                                                                       
                                      

                                    if (siMain.GetColumnIndex(DefColumns.MODULE_VARIANT) != -1)
                                        sAttribute2 = sAttribute2 + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MODULE_VARIANT)).ToString();
                                }
                            }
                                                                                      
                            if (sDiv == "40")
                            {
                                sCellPerCar = sCellPerCar + "^" + "";
                                sCellPerModule = sCellPerModule + "^" + "";
                                sSalesPlanAdjustYN = sSalesPlanAdjustYN + "^" + "";
                                sBpmsExist = sBpmsExist + "^" + "";

                                if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40) != -1)
                                    sSalesSiteId = sSalesSiteId + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40)).ToString();
                                else
                                    sSalesSiteId = sSalesSiteId + "^";

                                if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER40) != -1)
                                    sProjectCode = sProjectCode + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)).ToString();
                                else
                                    sProjectCode = sProjectCode + "^";

                                if (siMain.GetColumnIndex(DefColumns.CUST_GROUP) != -1)
                                    sCustGroup = sCustGroup + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CUST_GROUP)).ToString();
                                else
                                    sCustGroup = sCustGroup + "^";

                                if (siMain.GetColumnIndex(DefColumns.CUST_GROUP_DTL) != -1)
                                    sCustGroupDtl = sCustGroupDtl + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CUST_GROUP_DTL)).ToString();
                                else
                                    sCustGroupDtl = sCustGroupDtl + "^";

                                                                                     
                                                                                                                                      
                                if (siMain.GetColumnIndex(DefColumns.APPLICATION) != -1)
                                    sApplication = sApplication + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.APPLICATION)).ToString();
                                else
                                    sApplication = sApplication + "^";

                                if (siMain.GetColumnIndex(DefColumns.ROUTE) != -1)
                                    sRoute = sRoute + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ROUTE)).ToString();
                                else
                                    sRoute = sRoute + "^";

                                if (siMain.GetColumnIndex(DefColumns.ATTRIBUTE1) != -1)
                                    sAttribute1 = sAttribute1 + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE1)).ToString();
                                else
                                    sAttribute1 = sAttribute1 + "^";

                                if (siMain.GetColumnIndex(DefColumns.ATTRIBUTE2) != -1)
                                    sAttribute2 = sAttribute2 + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE2)).ToString();
                                else
                                    sAttribute2 = sAttribute2 + "^";

                                if (siMain.GetColumnIndex(DefColumns.ATTRIBUTE4) != -1)
                                    sAttribute4 = sAttribute4 + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE4)).ToString();
                                else
                                    sAttribute4 = sAttribute4 + "^";

                                if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP1) != -1)
                                    sGroup1 = sGroup1 + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.REPORT_GROUP1)).ToString();
                                else
                                    sGroup1 = sGroup1 + "^";
                                if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP2) != -1)
                                    sGroup2 = sGroup2 + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.REPORT_GROUP2)).ToString();
                                else
                                    sGroup2 = sGroup2 + "^";
                                if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP3) != -1)
                                    sGroup3 = sGroup3 + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.REPORT_GROUP3)).ToString();
                                else
                                    sGroup3 = sGroup3 + "^";
                                if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP4) != -1)
                                    sGroup4 = sGroup4 + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.REPORT_GROUP4)).ToString();
                                else
                                    sGroup4 = sGroup4 + "^";
                                if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP5) != -1)
                                    sGroup5 = sGroup5 + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.REPORT_GROUP5)).ToString();
                                else
                                    sGroup5 = sGroup5 + "^";
                                if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP6) != -1)
                                    sGroup6 = sGroup6 + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.REPORT_GROUP6)).ToString();
                                else
                                    sGroup6 = sGroup6 + "^";
                                if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP7) != -1)
                                    sGroup7 = sGroup7 + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.REPORT_GROUP7)).ToString();
                                else
                                    sGroup7 = sGroup7 + "^";
                                if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP8) != -1)
                                    sGroup8 = sGroup8 + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.REPORT_GROUP8)).ToString();
                                else
                                    sGroup8 = sGroup8 + "^";
                                                                                                       
                                if (siMain.GetColumnIndex(DefColumns.PRODUCTION_PROCESS) != -1)
                                    sProductionProcess = sProductionProcess + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PRODUCTION_PROCESS)).ToString();
                                else
                                    sProductionProcess = sProductionProcess + "^";

                                                                           
                                if (siMain.GetColumnIndex(DefColumns.PROJECT_INFO) != -1)
                                    sPROJECT_INFO = sPROJECT_INFO + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PROJECT_INFO)).ToString();
                                else
                                    sPROJECT_INFO = sPROJECT_INFO + "^";

                                                                                                                                                
                                if (siMain.GetColumnIndex(DefColumns.CELL_S_OP_REPORT) != -1)
                                    sCELL_S_OP_REPORT = sCELL_S_OP_REPORT + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CELL_S_OP_REPORT)).ToString();
                                else
                                    sCELL_S_OP_REPORT = sCELL_S_OP_REPORT + "^";

                                                                                                          
                                   
                                                                                                                
                                                                                         
                                                                                                                                                      
                                     
                                                                       
 
                                                                                                                
                                                                                         
                                                                                                                                                      
                                     
                                                                       
                                  
                                                                                                        
                            }
                            else
                            {
                                if (siMain.GetColumnIndex(DefColumns.CELL_PER_CAR) != -1)
                                    sCellPerCar = sCellPerCar + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CELL_PER_CAR)).ToString();
                                else
                                    sCellPerCar = sCellPerCar + "^";

                                if (siMain.GetColumnIndex(DefColumns.CELL_PER_MODULE) != -1)
                                    sCellPerModule = sCellPerModule + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CELL_PER_MODULE)).ToString();
                                else
                                    sCellPerModule = sCellPerModule + "^";

                                if (siMain.GetColumnIndex(DefColumns.SALES_PLAN_ADJUST_YN) != -1)
                                    sSalesPlanAdjustYN = sSalesPlanAdjustYN + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SALES_PLAN_ADJUST_YN)).ToString();
                                else
                                    sSalesPlanAdjustYN = sSalesPlanAdjustYN + "^";

                                if (siMain.GetColumnIndex(DefColumns.BPMS_EXIST) != -1)
                                    sBpmsExist = sBpmsExist + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.BPMS_EXIST)).ToString();
                                else
                                    sBpmsExist = sBpmsExist + "^";

                                if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) != -1)
                                    sSalesSiteId = sSalesSiteId + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString();
                                else
                                    sSalesSiteId = sSalesSiteId + "^";

                                if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) != -1)
                                    sProjectCode = sProjectCode + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString();
                                else
                                    sProjectCode = sProjectCode + "^";

                                                            
                                if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() == "82")
                                {
                                    if (siMain.GetColumnIndex(DefColumns.CellName) != -1)
                                        sCellName = sCellName + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CellName)).ToString();
                                    else
                                        sCellName = sCellName + "^";

                                                                                                     
                                    if (siMain.GetColumnIndex(DefColumns.PARTIAL_PLAN_YN) != -1)
                                        sPartialPlanYn = sPartialPlanYn + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PARTIAL_PLAN_YN)).ToString();
                                    else
                                        sPartialPlanYn = sPartialPlanYn + "^";

                                                                               
                                    if (siMain.GetColumnIndex(DefColumns.PRJ_OWNR_ID) != -1)
                                        sPrjOwnerId = sPrjOwnerId + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PRJ_OWNR_ID)).ToString();
                                    else
                                        sPrjOwnerId = sPrjOwnerId + "^";
                                }
                                                                                                   
                                                               
                                if (sDiv.Substring(0, 2) == "81")
                                {
                                                                                                                    
                                    if (siMain.GetColumnIndex(DefColumns.CRGE_ORG_NM) != -1)
                                        sCRGE_ORG_NM = sCRGE_ORG_NM + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CRGE_ORG_NM)).ToString();
                                    else
                                        sCRGE_ORG_NM = sCRGE_ORG_NM + "^";

                                                                                                                    
                                    if (siMain.GetColumnIndex(DefColumns.CUST_ENG_NM) != -1)
                                        sCUST_ENG_NM = sCUST_ENG_NM + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CUST_ENG_NM)).ToString();
                                    else
                                        sCUST_ENG_NM = sCUST_ENG_NM + "^";
                                }
                                                                                                 
                            }

                            if (siMain.GetColumnIndex(DefColumns.LIABILITY_PERIOD) != -1)
                                sLiabilityPeriod = sLiabilityPeriod + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.LIABILITY_PERIOD)).ToString();
                            else
                                sLiabilityPeriod = sLiabilityPeriod + "^";

                            sItemHrcyId = sItemHrcyId + "^" + "";

                            if (siMain.GetColumnIndex(DefColumns.VALID_YN) != -1)
                                sValidYN = sValidYN + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VALID_YN)).ToString();
                            else
                                sValidYN = sValidYN + "^";

                            sUserId = sUserId + "^" + base.UserInfo.UserId;

                                                                            
                            if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() == "82")
                            {
                                if (siMain.GetColumnIndex(DefColumns.USER_ID_82) != -1)
                                    sOwner = sOwner + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.USER_ID_82)).ToString();
                                else
                                    sOwner = sOwner + "^";
                            }
                            else
                            {
                                                                                     
                                                                                                                                      
                                if (siMain.GetColumnIndex(DefColumns.USER_ID) != -1)
                                    sOwner = sOwner + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.USER_ID)).ToString();
                                else
                                    sOwner = sOwner + "^";
                            }
                            if (siMain.GetColumnIndex(DefColumns.EDI) != -1)
                                sEDI = sEDI + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.EDI)).ToString();
                            else
                                sEDI = sEDI + "^";

                            if (siMain.GetColumnIndex(DefColumns.EDI_LT) != -1)
                                sEDI_LT = sEDI_LT + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.EDI_LT)).ToString();
                            else
                                sEDI_LT = sEDI_LT + "^";

                            if (siMain.GetColumnIndex(DefColumns.VMI_LT) != -1)
                                sVmiLt = sVmiLt + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VMI_LT)).ToString();
                            else
                                sVmiLt = sVmiLt + "^";

                                                                                        
                            if (siMain.GetColumnIndex(DefColumns.SALES_COMPANY) != -1)
                                sSalesCompany = sSalesCompany + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SALES_COMPANY)).ToString();
                            if (siMain.GetColumnIndex(DefColumns.SALES_PLANT) != -1)
                                sSalesPlant = sSalesPlant + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SALES_PLANT)).ToString();

                                                                                     
                            if (siMain.GetColumnIndex(DefColumns.KWH) != -1)
                                sKwh = sKwh + "^" + siMain.GetText(i, siMain.GetColumnIndex(DefColumns.KWH)).ToString().Replace(",", "");

                            if (action == "I")
                            {
                                sCelltype = sCelltype + "^" + "CELL_TYPE_00";
                            }
                            else
                            {
                                if (sDiv != null && sDiv != "")
                                {
                                                                                                      
                                    if (sDiv.Substring(0, 2) == "81")
                                    {
                                                                                                          
                                        if (siMain.GetColumnIndex(DefColumns.CELL_TYPE_81) != -1)
                                            sCelltype = sCelltype + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CELL_TYPE_81)).ToString();
                                    }
                                    else if (sDiv == "82")
                                    {
                                                                                                          
                                        if (siMain.GetColumnIndex(DefColumns.CELL_TYPE_82) != -1)
                                            sCelltype = sCelltype + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CELL_TYPE_82)).ToString();

                                                                                   
                                        if (siMain.GetColumnIndex(DefColumns.PRJ_OWNR_ID) != -1)
                                            sPrjOwnerId = sPrjOwnerId + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PRJ_OWNR_ID)).ToString();
                                        else
                                            sPrjOwnerId = sPrjOwnerId + "^";

                                                                                                    
                                        string cConsensus_Mkt = string.Empty;
                                        string cConsensus_Ess = string.Empty;
                                        string cConsensus_Scm = string.Empty;
                                        string Inventory_Day = string.Empty;
                                        int cInventory_Day = 0;

                                        if (siMain.GetColumnIndex(DefColumns.INVENTORY_DAY) != -1)
                                            Inventory_Day = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.INVENTORY_DAY)).ToString();

                                        if (Inventory_Day == "")
                                        {
                                            MessageBox.Show("Inventory Days 를 설정해 주세요.");
                                            sInventory_Day = "0";
                                            if (siMain.GetColumnIndex(DefColumns.INVENTORY_DAY) != -1)
                                                sInventory_Day = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.INVENTORY_DAY)).ToString();

                                            return;
                                        }

                                        if (siMain.GetColumnIndex(DefColumns.CONSENSUS_MKT) != -1)
                                            cConsensus_Mkt = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONSENSUS_MKT)).ToString();
                                        if (siMain.GetColumnIndex(DefColumns.CONSENSUS_ESS) != -1)
                                            cConsensus_Ess = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONSENSUS_ESS)).ToString();
                                        if (siMain.GetColumnIndex(DefColumns.CONSENSUS_SCM) != -1)
                                            cConsensus_Scm = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONSENSUS_SCM)).ToString();
                                        if (siMain.GetColumnIndex(DefColumns.INVENTORY_DAY) != -1)
                                            cInventory_Day = Convert.ToInt32(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.INVENTORY_DAY)));

                                        String checkData = cConsensus_Mkt + cConsensus_Ess + cConsensus_Scm;

                                        if (siMain.GetColumnIndex(DefColumns.CONSENSUS_MKT) != -1)
                                            sConsensus_Mkt = sConsensus_Mkt + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONSENSUS_MKT)).ToString();
                                        if (siMain.GetColumnIndex(DefColumns.CONSENSUS_ESS) != -1)
                                            sConsensus_Ess = sConsensus_Ess + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONSENSUS_ESS)).ToString();
                                        if (siMain.GetColumnIndex(DefColumns.CONSENSUS_SCM) != -1)
                                            sConsensus_Scm = sConsensus_Scm + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONSENSUS_SCM)).ToString();
                                        if (siMain.GetColumnIndex(DefColumns.CHANGE_REASON) != -1)
                                            sChange_Reason = sChange_Reason + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHANGE_REASON)).ToString();
                                        if (siMain.GetColumnIndex(DefColumns.INVENTORY_DAY) != -1)
                                            sInventory_Day = sInventory_Day + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.INVENTORY_DAY)).ToString();

                                        if (checkData != "YYY" && cInventory_Day > 0)
                                        {
                                            MessageBox.Show("CONSENSUS의 모든 항목이 'Y' 로 선택되어야 합니다.");
                                            sInventory_Day = "0";
                                            if (siMain.GetColumnIndex(DefColumns.INVENTORY_DAY) != -1)
                                                sInventory_Day = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.INVENTORY_DAY)).ToString();

                                            return;
                                        }

                                        if (checkData == "YYY" && cInventory_Day > 0 && sChange_Reason == "")
                                        {
                                            MessageBox.Show("Change Reason 을 입력해야 저장이 가능합니다..");
                                            sInventory_Day = "0";
                                            if (siMain.GetColumnIndex(DefColumns.INVENTORY_DAY) != -1)
                                                sInventory_Day = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.INVENTORY_DAY)).ToString();

                                            return;
                                        }
                                                                                                  
                                    }
                                }
                            }
                        }

                        if ((action == CAppSetting.FlagI) || (action == CAppSetting.FlagM))
                        {
                            for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
                            {
                                string sDivision = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                                if (sDivision == "")
                                {
                                    string args = string.Format("{0}", MessageHelper.GetTerm(DefColumnsLabel.DIVISION_ID));
                                    MessageHelper.GMessageBox("MSG00002", new object[] { args });
                                    return;
                                }
                                if ((sDivision.Substring(0, 2) == "81" || sDivision == "82") && (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString() == ""))
                                {
                                    string args = string.Format("{0}", MessageHelper.GetTerm(DefColumnsLabel.SCM_SITE_ID));
                                    MessageHelper.GMessageBox("MSG00002", new object[] { args });
                                    return;
                                }
                                if ((sDivision.Substring(0, 2) == "81" || sDivision == "82") && (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString() == ""))
                                {
                                    string args = string.Format("{0}", MessageHelper.GetTerm(DefColumnsLabel.PROJECT_CODE));
                                    MessageHelper.GMessageBox("MSG00002", new object[] { args });
                                    return;
                                }
                                                                                                                                                                                 
                                    
                                                                        
                                                                                                            
                                                 
                                                                                                    
                                              
                                    
                                if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VALID_YN)).ToString() == "")
                                {
                                    string args = string.Format("{0}", MessageHelper.GetTerm(DefColumnsLabel.VALID_YN));
                                    MessageHelper.GMessageBox("MSG00002", new object[] { args });
                                    return;
                                }
                                                                                       
                                if (sDivision == "82")
                                {
                                    if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.USER_ID_82)).ToString() == "")
                                    {
                                        string args = string.Format("{0}", MessageHelper.GetTerm(DefColumns.OWNER));
                                        MessageHelper.GMessageBox("MSG00002", new object[] { args });
                                        return;
                                    }
                                }
                                else
                                {
                                    if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.USER_ID)).ToString() == "")
                                    {
                                        string args = string.Format("{0}", MessageHelper.GetTerm(DefColumns.OWNER));
                                        MessageHelper.GMessageBox("MSG00002", new object[] { args });
                                        return;
                                    }
                                }
                                                                                     

                                                                                         
                                if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SALES_COMPANY)).ToString() == "")
                                {
                                    string args = string.Format("{0}", MessageHelper.GetTerm(DefColumnsLabel.SALES_COMPANY));
                                    MessageHelper.GMessageBox("MSG00002", new object[] { args });
                                    return;
                                }
                                if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SALES_PLANT)).ToString() == "")
                                {
                                    string args = string.Format("{0}", MessageHelper.GetTerm(DefColumnsLabel.SALES_PLANT));
                                    MessageHelper.GMessageBox("MSG00002", new object[] { args });
                                    return;
                                }
                                        
                                                                                                         
                                if (sDivision == "40")
                                {
                                    if ((sDivision == "40") && (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CUST_GROUP)).ToString() == ""))
                                    {
                                        string args = string.Format("{0}", MessageHelper.GetTerm(DefColumns.CUST_GROUP));
                                        MessageHelper.GMessageBox("MSG00002", new object[] { args });
                                        return;
                                    }
                                    if ((action == CAppSetting.FlagI) && (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)).ToString() == ""))
                                    {
                                        string args = string.Format("{0}", MessageHelper.GetTerm(DefColumns.END_CUSTOMER));
                                        MessageHelper.GMessageBox("MSG00002", new object[] { args });
                                        return;
                                    }
                                                                                                                        
                                        
                                                                            
                                                                                            
                                                     
                                                                                                        
                                                  
                                        
                                    if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40)).ToString() == "")
                                    {
                                        string args = string.Format("{0}", MessageHelper.GetTerm(DefColumns.SCM_SITE_ID));
                                        MessageHelper.GMessageBox("MSG00002", new object[] { args });
                                        return;
                                    }
                                    if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() == "")
                                    {
                                        string args = string.Format("{0}", MessageHelper.GetTerm(DefColumnsLabel.ITEM_ID));
                                        MessageHelper.GMessageBox("MSG00002", new object[] { args });
                                        return;
                                    }
                                    if ((sDivision == "40") && siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.APPLICATION)).ToString() == "")
                                    {
                                        string args = string.Format("{0}", MessageHelper.GetTerm(DefColumns.APPLICATION));
                                        MessageHelper.GMessageBox("MSG00002", new object[] { args });
                                        return;
                                    }
                                    if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CURRENCY)).ToString() == "")
                                    {
                                        string args = string.Format("{0}", MessageHelper.GetTerm(DefColumnsLabel.CURRENCY));
                                        MessageHelper.GMessageBox("MSG00002", new object[] { args });
                                        return;
                                    }
                                                                                                          
                                    if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PRODUCTION_PROCESS)).ToString() == "")
                                    {
                                        string args = string.Format("{0}", MessageHelper.GetTerm(DefColumnsLabel.PRODUCTION_PROCESS));
                                        MessageHelper.GMessageBox("MSG00002", new object[] { args });
                                        return;
                                    }
                                }

                                if (sDivision.Substring(0, 2) == "81")
                                {                                                
                                    if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.KWH)).ToString() == "")
                                    {
                                        string args = string.Format("{0}", MessageHelper.GetTerm(DefColumns.KWH));
                                        MessageHelper.GMessageBox("MSG00002", new object[] { args });
                                        return;
                                    }
                                }
                                if ((sDivision.Substring(0, 2) == "81") || (sDivision == "82"))
                                {
                                    if (sDivisionId == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString()
                                        && sProjectCode == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString()
                                        && sSalesSiteId == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString()
                                        && (siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI))
                                    {
                                        iChkCount++;

                                        if (iChkCount > 1)
                                        {
                                            string args = string.Format("{0}, {1}, {2}"
                                                , MessageHelper.GetTerm(DefColumnsLabel.DIVISION_ID)
                                                , MessageHelper.GetTerm(DefColumnsLabel.PROJECT_CODE)
                                                , MessageHelper.GetTerm(DefColumnsLabel.SCM_SITE_ID)
                                                );
                                                                                   
                                            MessageHelper.GMessageBox("MSG00060", new object[] { args });

                                            siMain.SetValue(i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "");
                                            iCount = 0;
                                            return;
                                        }
                                    }

                                                                                                                                                       
                                                                                 
                                                                                                                                                       
                                    if (action != "I")
                                    {
                                        string CellTypeValues = string.Empty;               
                                        string msg = string.Empty;                         
                                        if (sDivision.Substring(0, 2) == "81")
                                        {
                                            CellTypeValues = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CELL_TYPE_81)).ToString();
                                            msg = DefColumnsLabel.CELL_TYPE_81;
                                        }
                                        else if (sDivision == "82")
                                        {
                                            CellTypeValues = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CELL_TYPE_82)).ToString();
                                            msg = DefColumnsLabel.CELL_TYPE_82;
                                        }

                                        if (CellTypeValues == "")
                                        {
                                            string args = string.Format("{0}", MessageHelper.GetTerm(msg));
                                            MessageHelper.GMessageBox("MSG00002", new object[] { args });                      
                                            return;
                                        }
                                        else
                                        {
                                                                                                                                                           
                                                                            
                                                                                            
                                                                                                                                                           
                                            if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_TYPE)).ToString() == "P")
                                            {
                                                                       
                                                if (CellTypeValues == "CELL_TYPE_00")
                                                {
                                                                                                      
                                                    MessageHelper.GMessageBox("MSG00357");
                                                    return;
                                                }
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    if (sDivisionId == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString()
                                        && sProjectCode == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)).ToString()
                                        && sSalesSiteId == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40)).ToString()
                                        && sItemId == siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString()
                                        && (siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI))
                                    {
                                        iChkCount++;

                                        if (iChkCount > 1)
                                        {
                                            string args = string.Format("{0}, {1}, {2}, {3}"
                                                , MessageHelper.GetTerm(DefColumns.DIVISION_ID)
                                                , MessageHelper.GetTerm(DefColumns.END_CUSTOMER)
                                                , MessageHelper.GetTerm(DefColumns.SCM_SITE_ID)
                                                , MessageHelper.GetTerm(DefColumns.ITEM_ID)
                                                );

                                                                                   
                                            MessageHelper.GMessageBox("MSG00060", new object[] { args });

                                            iCount = 0;
                                            return;
                                        }
                                    }
                                }
                            }
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
                                string sProcedureName = "DM.DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION";
                                var request = new FoxDataRequest(sProcedureName);
                                request.CommandTimeout = 10 * 60;
                                request.Parameters["p_active_flag"] = sAction;
                                request.Parameters["p_division_id"] = sDivisionId;
                                request.Parameters["p_project_code"] = sProjectCode;
                                request.Parameters["p_scm_site_id"] = sSalesSiteId;
                                request.Parameters["p_item_id"] = sItemId;
                                request.Parameters["p_currency"] = sCurrency;
                                request.Parameters["p_cell_per_car"] = sCellPerCar;
                                request.Parameters["p_cell_per_module"] = sCellPerModule;
                                request.Parameters["p_liability_period"] = sLiabilityPeriod;
                                request.Parameters["p_sales_plan_adjust_yn"] = sSalesPlanAdjustYN;
                                request.Parameters["p_item_hrcy_id"] = sItemHrcyId;
                                request.Parameters["p_bpms_exist"] = sBpmsExist;
                                request.Parameters["p_valid_yn"] = sValidYN;
                                                    
                                request.Parameters["p_cust_group"] = sCustGroup;
                                request.Parameters["p_cust_group_dtl"] = sCustGroupDtl;
                                request.Parameters["p_owner"] = sOwner;
                                request.Parameters["p_application"] = sApplication;
                                request.Parameters["p_route"] = sRoute;

                                request.Parameters["p_cell_name"] = sCellName;                              

                                request.Parameters["p_created_by"] = sUserId;
                                request.Parameters["p_attribute1"] = sAttribute1;
                                request.Parameters["p_attribute2"] = sAttribute2;
                                request.Parameters["p_attribute4"] = sAttribute4;
                                request.Parameters["p_attribute6"] = sEDI;
                                request.Parameters["p_edi_lt"] = sEDI_LT;

                                request.Parameters["report_group1"] = sGroup1;
                                request.Parameters["report_group2"] = sGroup2;
                                request.Parameters["report_group3"] = sGroup3;
                                request.Parameters["report_group4"] = sGroup4;
                                                                                 
                                request.Parameters["report_group6"] = sGroup6;
                                request.Parameters["report_group7"] = sGroup7;
                                request.Parameters["report_group8"] = sGroup8;
                                request.Parameters["p_vmi_lt"] = sVmiLt;

                                                                                             
                                request.Parameters["p_sales_company"] = sSalesCompany;
                                request.Parameters["p_sales_plant"] = sSalesPlant;

                                                                                                 
                                request.Parameters["p_partial_plan_yn"] = sPartialPlanYn;

                                                                                         
                                request.Parameters["p_kwh"] = sKwh;

                                                                                                  
                                request.Parameters["p_celltypeCD"] = sCelltype;

                                                                                                       
                                request.Parameters["p_production_process"] = sProductionProcess;

                                                                                    
                                request.Parameters["p_consensus_Mkt"] = sConsensus_Mkt;
                                request.Parameters["p_consensus_Ess"] = sConsensus_Ess;
                                request.Parameters["p_consensus_Scm"] = sConsensus_Scm;
                                request.Parameters["p_inventory_Day"] = sInventory_Day;
                                request.Parameters["p_change_Reason"] = sChange_Reason;
                                request.Parameters["p_alt_sim_yn"] = sALT_SIM_YN;                                          
                                request.Parameters["p_description"] = sDESCRIPTION;                                 
                                request.Parameters["p_projectinfo"] = sPROJECT_INFO;                                            
                                                                                    

                                                                                                  
                                request.Parameters["p_project_s_op_report"] = sPROJECT_S_OP_REPORT;

                                                                                                                                                
                                request.Parameters["p_cell_s_op_report"] = sCELL_S_OP_REPORT;

                                                                                                           
                                request.Parameters["p_prj_ownr_id"] = sPrjOwnerId;

                                                                                                                     
                                request.Parameters["p_crge_org_nm"] = sCRGE_ORG_NM;
                                request.Parameters["p_cust_eng_nm"] = sCUST_ENG_NM;
                                                                                                                   

                                var response = client.ExecuteDataSet(request);

                                if (response.DataSet.Tables.Count != 0)
                                {
                                    if (response.DataSet.Tables[0].Rows[0][0].ToString() == "MSG00156")
                                    {
                                        MessageHelper.GMessageBox("MSG00156");
                                    }
                                    else
                                    {
                                        MessageHelper.GMessageBox(response.DataSet.Tables[0].Rows[0][0].ToString());
                                    }

                                }
                                else
                                {
                                    MessageHelper.GMessageBox("MSG00004", new object[] { iCount });
                                    siMain.SwitchLock();
                                    FindData_Main();
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
                        MessageHelper.GMessageBox("MSG00005");
                    }
                }
            }

                      
            if (siSub != null && siSub.IsLock(siSub.SheetName) == false)
            {
                if (siSub.SheetName == SpdSheet.shtSub)
                {
                    int iCount = 0;
                    string sProcedureName = "DM.DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION";
                    string sAction = string.Empty;
                    string sDivisionId = string.Empty;
                    string sProjectCode = string.Empty;
                    string sSalesSiteId = string.Empty;
                    string sItemId = string.Empty;
                    string sCurrency = string.Empty;
                    string sLiabilityPeriod = string.Empty;
                    string sSalesPlanAdjustYN = string.Empty;
                    string sItemHrcyId = string.Empty;
                    string sBpmsExist = string.Empty;
                    string sValidYN = string.Empty;
                    string sUserId = string.Empty;

                    string sCellPerCar = string.Empty;
                    string sCellPerModule = string.Empty; ;

                             
                    string sCustGroup = string.Empty;
                    string sCustGroupDtl = string.Empty;
                    string sOwner = string.Empty;
                    string sApplication = string.Empty;
                    string sRoute = string.Empty;

                    string sAttribute1 = string.Empty;
                    string sAttribute2 = string.Empty;
                    string sAttribute4 = string.Empty;
                    string sEDI = string.Empty;

                    string sGroup1 = string.Empty;
                    string sGroup2 = string.Empty;
                    string sGroup3 = string.Empty;
                    string sGroup4 = string.Empty;
                    string sGroup5 = string.Empty;
                    string sGroup6 = string.Empty;
                    string sGroup7 = string.Empty;
                    string sGroup8 = string.Empty;

                    string sEDI_LT = string.Empty;

                    string sVmiLt = string.Empty;
                                                      
                    string sCellName = string.Empty;
                                                                                 
                    string sSalesCompany = string.Empty;
                    string sSalesPlant = string.Empty;
                                                                                     
                    string sPartialPlanYn = string.Empty;
                                                                             
                    string sKwh = string.Empty;
                                                                                      
                    string sCelltype = string.Empty;

                                                                        
                    string sConsensus_Mkt = string.Empty;
                    string sConsensus_Ess = string.Empty;
                    string sConsensus_Scm = string.Empty;
                    string sInventory_Day = "0";
                    string sChange_Reason = string.Empty;
                                                                        
                    string sPrjOwnerId = string.Empty;
                                                                                                         
                    string sCrgeOrgNm = string.Empty;
                    string sCustEngNm = string.Empty;
                                                                                                       

                    for (int i = 0; i <= siSub.GetMaxRowIndex(); i++)
                    {
                        string action = siSub.GetText(i, 0);

                        if (action != CAppSetting.FlagI && action != CAppSetting.FlagM && action != CAppSetting.FlagD)
                            continue;

                        if (sAction == "")
                        {
                            sAction = action;
                            sDivisionId = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                            sProjectCode = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString();
                            sSalesSiteId = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString();
                            sItemId = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ITEM_ID)).ToString();
                            sCurrency = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.CURRENCY)).ToString();
                            sLiabilityPeriod = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.LIABILITY_PERIOD)).ToString();
                            sSalesPlanAdjustYN = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SALES_PLAN_ADJUST_YN)).ToString();
                            sItemHrcyId = "";
                            sBpmsExist = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.BPMS_EXIST)).ToString();
                            sValidYN = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.VALID_YN)).ToString();
                            sUserId = base.UserInfo.UserId;
                            if (siSub.GetColumnIndex(DefColumns.USER_ID) != -1)
                                sOwner = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.USER_ID)).ToString();
                            if (siSub.GetColumnIndex(DefColumns.EDI) != -1)
                                sEDI = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.EDI)).ToString();
                            if (siSub.GetColumnIndex(DefColumns.EDI_LT) != -1)
                                sEDI_LT = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.EDI_LT)).ToString();

                                                                                                                 
                            if (siSub.GetColumnIndex(DefColumns.CELL_PER_CAR) != -1)
                                sCellPerCar = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.CELL_PER_CAR)).ToString();
                            if (siSub.GetColumnIndex(DefColumns.CELL_PER_MODULE) != -1)
                                sCellPerModule = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.CELL_PER_MODULE)).ToString();
                            if (siSub.GetColumnIndex(DefColumns.SALES_COMPANY) != -1)
                                sSalesCompany = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SALES_COMPANY)).ToString();
                            if (siSub.GetColumnIndex(DefColumns.SALES_PLANT) != -1)
                                sSalesPlant = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SALES_PLANT)).ToString();

                                                                                     
                            if (siSub.GetColumnIndex(DefColumns.KWH) != -1)
                                sKwh = siSub.GetText(i, siSub.GetColumnIndex(DefColumns.KWH)).ToString().Replace(",", "");

                                                                                              
                            if (sDivisionId.Substring(0, 2) == "81")
                            {
                                if (siSub.GetColumnIndex(DefColumns.CELL_TYPE_81) != -1)
                                    sCelltype = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.CELL_TYPE_81)).ToString();

                                                                                                            
                                if (siSub.GetColumnIndex(DefColumns.ATTRIBUTE1) != -1)
                                    sAttribute1 = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE1)).ToString();

                                if (siSub.GetColumnIndex(DefColumns.MODULE_VARIANT) != -1)
                                    sAttribute2 = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.MODULE_VARIANT)).ToString();
                            }
                            else if (sDivisionId == "82")
                            {
                                if (siSub.GetColumnIndex(DefColumns.CELL_TYPE_82) != -1)
                                    sCelltype = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.CELL_TYPE_82)).ToString();
                            }
                        }
                        else
                        {
                            sAction = sAction + "^" + action;
                            sDivisionId = sDivisionId + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                            sProjectCode = sProjectCode + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString();
                            sSalesSiteId = sSalesSiteId + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString();
                            sItemId = sItemId + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ITEM_ID)).ToString();
                            sCurrency = sCurrency + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.CURRENCY)).ToString();
                            sLiabilityPeriod = sLiabilityPeriod + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.LIABILITY_PERIOD)).ToString();
                            sSalesPlanAdjustYN = sSalesPlanAdjustYN + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SALES_PLAN_ADJUST_YN)).ToString();
                            sItemHrcyId = sItemHrcyId + "^" + "";
                            sBpmsExist = sBpmsExist + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.BPMS_EXIST)).ToString();
                            sValidYN = sValidYN + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.VALID_YN)).ToString();
                            sUserId = sUserId + "^" + base.UserInfo.UserId;
                            if (siSub.GetColumnIndex(DefColumns.USER_ID) != -1)
                                sOwner = sOwner + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.USER_ID)).ToString();
                            if (siSub.GetColumnIndex(DefColumns.EDI) != -1)
                                sEDI = sEDI + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.EDI)).ToString();
                            if (siSub.GetColumnIndex(DefColumns.EDI_LT) != -1)
                                sEDI_LT = sEDI_LT + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.EDI_LT)).ToString();
                            else
                                sEDI_LT = sEDI_LT + "^";

                                                                                                                 
                            if (siSub.GetColumnIndex(DefColumns.CELL_PER_CAR) != -1)
                                sCellPerCar = sCellPerCar + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.CELL_PER_CAR)).ToString();
                            else
                                sCellPerCar = sCellPerCar + "^";

                            if (siSub.GetColumnIndex(DefColumns.CELL_PER_MODULE) != -1)
                                sCellPerModule = sCellPerModule + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.CELL_PER_MODULE)).ToString();
                            else
                                sCellPerModule = sCellPerModule + "^";

                            if (siSub.GetColumnIndex(DefColumns.SALES_COMPANY) != -1)
                                sSalesCompany = sSalesCompany + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SALES_COMPANY)).ToString();
                            if (siSub.GetColumnIndex(DefColumns.SALES_PLANT) != -1)
                                sSalesPlant = sSalesPlant + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SALES_PLANT)).ToString();

                                                                                                                   
                            if (siSub.GetColumnIndex(DefColumns.KWH) != -1)
                                sKwh = sKwh + "^" + siSub.GetText(i, siSub.GetColumnIndex(DefColumns.KWH)).ToString().Replace(",", "");

                                                                                        
                            if (siMain.GetColumnIndex(DefColumns.CONSENSUS_MKT) != -1)
                                sConsensus_Mkt = sConsensus_Mkt + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONSENSUS_MKT)).ToString();
                            if (siMain.GetColumnIndex(DefColumns.CONSENSUS_ESS) != -1)
                                sConsensus_Ess = sConsensus_Ess + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONSENSUS_ESS)).ToString();
                            if (siMain.GetColumnIndex(DefColumns.CONSENSUS_SCM) != -1)
                                sConsensus_Scm = sConsensus_Scm + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONSENSUS_SCM)).ToString();
                            if (siMain.GetColumnIndex(DefColumns.CHANGE_REASON) != -1)
                                sChange_Reason = sChange_Reason + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHANGE_REASON)).ToString();
                            if (siMain.GetColumnIndex(DefColumns.INVENTORY_DAY) != -1)
                                sInventory_Day = sInventory_Day + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.INVENTORY_DAY)).ToString();
                                                                                      


                                                                                              
                            if (siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.DIVISION_ID)).ToString().Substring(0, 2) == "81")
                            {
                                                                                                  
                                if (siSub.GetColumnIndex(DefColumns.CELL_TYPE_81) != -1)
                                    sCelltype = sCelltype + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.CELL_TYPE_81)).ToString();

                                                                                                            
                                if (siSub.GetColumnIndex(DefColumns.ATTRIBUTE1) != -1)
                                    sAttribute1 = sAttribute1 + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE1)).ToString();

                                if (siSub.GetColumnIndex(DefColumns.MODULE_VARIANT) != -1)
                                    sAttribute2 = sAttribute2 + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.MODULE_VARIANT)).ToString();
                            }
                            else if (siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() == "82")
                            {
                                if (siSub.GetColumnIndex(DefColumns.CELL_TYPE_82) != -1)
                                    sCelltype = sCelltype + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.CELL_TYPE_82)).ToString();
                            }
                        }

                                                                              
                        if (siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SALES_COMPANY)).ToString() == "")
                        {
                            string args = string.Format("{0}", MessageHelper.GetTerm(DefColumnsLabel.SALES_COMPANY));
                            MessageHelper.GMessageBox("MSG00002", new object[] { args });                               
                            return;
                        }
                        if (siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SALES_PLANT)).ToString() == "")
                        {
                            string args = string.Format("{0}", MessageHelper.GetTerm(DefColumnsLabel.SALES_PLANT));
                            MessageHelper.GMessageBox("MSG00002", new object[] { args });                               
                            return;
                        }
                                                                     
                                                   
                        if (siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.DIVISION_ID)).ToString().Substring(0, 2) == "81")
                        {
                            if (siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.KWH)).ToString() == "")
                            {
                                string args = string.Format("{0}", MessageHelper.GetTerm(DefColumns.KWH));
                                MessageHelper.GMessageBox("MSG00002", new object[] { args });                               
                                return;
                            }
                        }
                                                                                                                                           
                                                                     
                                                                                                                                           
                        string CellTypeValues = string.Empty;               
                        string msg = string.Empty;                         

                                                                                                                  

                        if (siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.DIVISION_ID)).ToString().Substring(0, 2) == "81")
                        {
                            CellTypeValues = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.CELL_TYPE_81)).ToString();
                            msg = DefColumnsLabel.CELL_TYPE_81;
                        }
                        else if (siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() == "82")
                        {
                            CellTypeValues = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.CELL_TYPE_82)).ToString();
                            msg = DefColumnsLabel.CELL_TYPE_82;
                        }

                        if (CellTypeValues == "")
                        {
                            string args = string.Format("{0}", MessageHelper.GetTerm(msg));
                            MessageHelper.GMessageBox("MSG00002", new object[] { args });                      
                            return;
                        }
                        else
                        {
                                                                                                                                           
                                                            
                                                                            
                                                                                                                                           
                            if (siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ITEM_TYPE)).ToString() == "P")
                            {
                                                       
                                if (CellTypeValues == "CELL_TYPE_00")
                                {
                                                                                      
                                    MessageHelper.GMessageBox("MSG00357");
                                    return;
                                }
                            }
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
                                request.CommandTimeout = 10 * 60;
                                request.Parameters["p_active_flag"] = sAction;
                                request.Parameters["p_division_id"] = sDivisionId;
                                request.Parameters["p_project_code"] = sProjectCode;
                                request.Parameters["p_scm_site_id"] = sSalesSiteId;
                                request.Parameters["p_item_id"] = sItemId;
                                request.Parameters["p_currency"] = sCurrency;
                                request.Parameters["p_cell_per_car"] = sCellPerCar;
                                request.Parameters["p_cell_per_module"] = sCellPerModule;
                                request.Parameters["p_liability_period"] = sLiabilityPeriod;
                                request.Parameters["p_sales_plan_adjust_yn"] = sSalesPlanAdjustYN;
                                request.Parameters["p_item_hrcy_id"] = sItemHrcyId;
                                request.Parameters["p_bpms_exist"] = sBpmsExist;
                                request.Parameters["p_valid_yn"] = sValidYN;
                                                    
                                request.Parameters["p_cust_group"] = sCustGroup;
                                request.Parameters["p_cust_group_dtl"] = sCustGroupDtl;
                                request.Parameters["p_owner"] = sOwner;
                                request.Parameters["p_application"] = sApplication;
                                request.Parameters["p_route"] = sRoute;

                                request.Parameters["p_cell_name"] = sCellName;                                    
                                request.Parameters["p_created_by"] = sUserId;
                                request.Parameters["p_attribute1"] = sAttribute1;
                                request.Parameters["p_attribute2"] = sAttribute2;
                                request.Parameters["p_attribute4"] = sAttribute4;
                                request.Parameters["p_attribute6"] = sEDI;
                                request.Parameters["p_edi_lt"] = sEDI_LT;

                                request.Parameters["report_group1"] = sGroup1;
                                request.Parameters["report_group2"] = sGroup2;
                                request.Parameters["report_group3"] = sGroup3;
                                request.Parameters["report_group4"] = sGroup4;
                                                                                 
                                request.Parameters["report_group6"] = sGroup6;
                                request.Parameters["report_group7"] = sGroup7;
                                request.Parameters["report_group8"] = sGroup8;

                                request.Parameters["p_vmi_lt"] = sVmiLt;

                                                                                             
                                request.Parameters["p_sales_company"] = sSalesCompany;
                                request.Parameters["p_sales_plant"] = sSalesPlant;

                                                                                                 
                                request.Parameters["p_partial_plan_yn"] = sPartialPlanYn;

                                                                                           
                                request.Parameters["p_kwh"] = sKwh;
                                                                                                  
                                request.Parameters["p_celltypeCD"] = sCelltype;

                                                                                                       
                                request.Parameters["p_production_process"] = "";

                                                                                                        
                                request.Parameters["p_consensus_Mkt"] = "";
                                request.Parameters["p_consensus_Ess"] = "";
                                request.Parameters["p_consensus_Scm"] = "";
                                request.Parameters["p_inventory_Day"] = "";
                                request.Parameters["p_change_Reason"] = "";
                                request.Parameters["p_alt_sim_yn"] = "";                                          
                                request.Parameters["p_description"] = "";                                 
                                request.Parameters["p_projectinfo"] = "";                                            
                                                                                                      

                                                                                                  
                                request.Parameters["p_project_s_op_report"] = "";

                                                                                                                                                
                                request.Parameters["p_cell_s_op_report"] = "";

                                                                               
                                request.Parameters["p_prj_ownr_id"] = "";

                                                                                                                      
                                request.Parameters["p_crge_org_nm"] = "";                                            
                                request.Parameters["p_cust_eng_nm"] = "";                                                  
                                                                                                                    

                                var response = client.ExecuteDataSet(request);

                                if (response.DataSet.Tables.Count != 0)
                                {
                                    MessageHelper.GMessageBox(response.DataSet.Tables[0].Rows[0][0].ToString());
                                }
                                else
                                {
                                    MessageHelper.GMessageBox("MSG00004", new object[] { iCount });

                                    string sActionYN = cboActive.Text;
                                    siSub.SwitchLock();
                                    FindData_Sub(projectCode, sActionYN, division, site_ID);
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
                }
            }
        }

        private void InsertRow()
        {
            if (siMain != null && siMain.IsLock(siMain.SheetName) == false)
            {
                if (siMain.SheetName == SpdSheet.shtMain)
                {
                                        
                    HaltAutoFilter = true;

                    siMain.SpreadObject.SuspendLayout();
                                                                 

                    FarPoint.Win.Spread.Cell insCell = siMain.Insert();
                    Dictionary<object, object> defaultData = new Dictionary<object, object>();

                    string sDivision = clbDivision.SelectedValue.ToString();
                                                                                

                                                                                 
                                                                                                                     
                                                                                                   
                    dtSalesCompany = Data.Common(Data.Type.CompanySalesSite, false, "", "", "", "");
                                                                                                                              
                                                                                               
                                                                                                                            
                                                                                                                                        
                    dtSalesPlant = GetCommonDataList_DM("SALES_PLANT", "", "", "", "", "");
                                                                                                                          
                                                                               

                                                                                                          
                    dtCRGE_ORG_NM = Get_DDL_SSPM_CRGE_ORG_NM();                                            
                    dtCUST_ENG_NM = Get_DDL_SSPM_CUST_ENG_NM(sDivision);                                                  
                                                                                                        

                                                           
                    if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) != -1)
                        siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType = cellTypeImage;
                          

                    if ((sDivision.Substring(0, 2) == "81") || (sDivision == "82"))
                    {
                        siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtDivision);
                                                                                           
                        DataTable dtTeamAuth = Data.UserTeamByDivisionAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision);
                        DataTable dtEndCustomerAuth = Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "");
                        DataTable dtSalesSiteAuth = Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "");
                        siMain.SetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), clbDivision.SelectedValue);

                                                                                  
                        if (sDivision.Substring(0, 2) == "81")
                            siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TEAM_ID), dtTeamAuth);
                        else
                            siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DEPT_ID_82), dtTeamAuth);
                                                                                

                        siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomerAuth);
                        siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSiteAuth);

                                                                                     
                        siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SALES_COMPANY), dtSalesCompany);
                        siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SALES_PLANT), dtSalesPlant);

                                                                                                            
                        if (sDivision.Substring(0, 2) == "81")
                        {
                            InsertRowLockRangeMain(siMain.ActiveRowIndex);
                        }
                        else
                        {
                            InsertRowLockRangeMain82(siMain.ActiveRowIndex);
                        }
                                           
                        if (siMain.GetColumnIndex(DefColumns.SALES_PLAN_ADJUST_YN) != -1)
                        {
                            siMain.SetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SALES_PLAN_ADJUST_YN), "Y");
                        }

                        siMain.SetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.BPMS_EXIST), "Y");
                        siMain.SetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.VALID_YN), "Y");

                                                                                           
                                                       
                        if (sDivision.Substring(0, 2) == "81")
                        {
                                                                                                                 
                            siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CRGE_ORG_NM), dtCRGE_ORG_NM);
                            siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CUST_ENG_NM), dtCUST_ENG_NM);
                                                                                                               
                        }
                                                                                         

                                                                                                                                                          
                                                                                                                                             
                    }
                    else
                    {
                        #region 추가되는 칼럼 세팅
                        if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP1) != -1)
                        {
                            DataTable dt1 = GetItemType("REPORT_GROUP1");
                            siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.REPORT_GROUP1), dt1);
                        }
                        if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP2) != -1)
                        {
                            DataTable dt2 = GetItemType("REPORT_GROUP2");
                            siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.REPORT_GROUP2), dt2);
                        }
                        if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP3) != -1)
                        {
                            DataTable dt3 = GetItemType("REPORT_GROUP3");
                            siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.REPORT_GROUP3), dt3);
                        }
                        if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP4) != -1)
                        {
                            DataTable dt4 = GetItemType("REPORT_GROUP4");
                            siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.REPORT_GROUP4), dt4);
                        }
                        if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP5) != -1)
                        {
                            DataTable dt5 = GetItemType("REPORT_GROUP5");
                            siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.REPORT_GROUP5), dt5);
                        }
                        if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP6) != -1)
                        {
                            DataTable dt6 = GetItemType("REPORT_GROUP6");
                            siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.REPORT_GROUP6), dt6);
                        }
                        if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP7) != -1)
                        {
                            DataTable dt7 = GetItemType("REPORT_GROUP7");
                            siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.REPORT_GROUP7), dt7);
                        }
                        if (siMain.GetColumnIndex(DefColumns.REPORT_GROUP8) != -1)
                        {
                            DataTable dt8 = GetItemType("REPORT_GROUP8");
                            siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.REPORT_GROUP8), dt8);
                        }
                        if (siMain.GetColumnIndex(DefColumns.OS_CORP) != -1)
                            siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.OS_CORP), Data.Common(Data.Type.DMF0005_DM_OS_CORP_CD, false, "", "", "", ""));
                        if (siMain.GetColumnIndex(DefColumns.CONTRIBUTION_TYPE) != -1)
                            siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CONTRIBUTION_TYPE), Data.Common(Data.Type.DMF0005_DM_CONTRIBUTION_TYPE_CD, false, "", "", "", ""));
                        #endregion

                        siMain.SetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), clbDivision.SelectedValue);
                        siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType = cellTypeImage;
                                                                                                                                             

                        InsertRowLockRangeMain40(siMain.ActiveRowIndex);

                                                                                     
                        siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SALES_COMPANY), dtSalesCompany);
                        siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SALES_PLANT), dtSalesPlant);

                                                                                                  
                           
                                                                                                             
                                                                                                                                      
                                                                                                                                      
                                                                                                           
                          
                                                                                                
                    }

                                            
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
        private void InsertRowLockRangeMain(int rowIndex)
        {
                                                                                
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), rowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.OWNER), rowIndex, siMain.GetColumnIndex(DefColumns.OWNER), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE), rowIndex, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.SOLDTO_DESCRIPTION), rowIndex, siMain.GetColumnIndex(DefColumns.SOLDTO_DESCRIPTION), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE), rowIndex, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.SHIPTO_DESCRIPTION), rowIndex, siMain.GetColumnIndex(DefColumns.SHIPTO_DESCRIPTION), true);

            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), rowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_STATUS), rowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_STATUS), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_OWNER), rowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_OWNER), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), rowIndex, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), rowIndex, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID), rowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.ITEM_NAME), rowIndex, siMain.GetColumnIndex(DefColumns.ITEM_NAME), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_OWNER), rowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_OWNER), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), rowIndex, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.CUSTOMER_MODEL), rowIndex, siMain.GetColumnIndex(DefColumns.CUSTOMER_MODEL), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.NICK_NAME), rowIndex, siMain.GetColumnIndex(DefColumns.NICK_NAME), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.BPMS_EXIST), rowIndex, siMain.GetColumnIndex(DefColumns.BPMS_EXIST), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), rowIndex, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), rowIndex, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), true);

                                                                                                                 
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG), rowIndex, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG), true);
                                                                                                               
        }
                                                                                             
        private void InsertRowLockRangeMain82(int rowIndex)
        {
                                                                                
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), rowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.OWNER), rowIndex, siMain.GetColumnIndex(DefColumns.OWNER), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE), rowIndex, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.SOLDTO_DESCRIPTION), rowIndex, siMain.GetColumnIndex(DefColumns.SOLDTO_DESCRIPTION), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE), rowIndex, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.SHIPTO_DESCRIPTION), rowIndex, siMain.GetColumnIndex(DefColumns.SHIPTO_DESCRIPTION), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), rowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_STATUS), rowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_STATUS), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_OWNER), rowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_OWNER), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), rowIndex, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), rowIndex, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID), rowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.ITEM_NAME), rowIndex, siMain.GetColumnIndex(DefColumns.ITEM_NAME), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.CUSTOMER_MODEL), rowIndex, siMain.GetColumnIndex(DefColumns.CUSTOMER_MODEL), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.NICK_NAME), rowIndex, siMain.GetColumnIndex(DefColumns.NICK_NAME), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.BPMS_EXIST), rowIndex, siMain.GetColumnIndex(DefColumns.BPMS_EXIST), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), rowIndex, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), rowIndex, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), true);

                                                                                                                 
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG), rowIndex, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG), true);
                                                                                                               

            int iCol = siMain.GetColumnIndex(DefColumns.SCM_SITE_ID);
            string columnValue = string.Empty;
            if (rowIndex == 0)
            {
                columnValue = siMain.GetText(rowIndex, iCol).ToString();
            }
            else
            {
                columnValue = siMain.GetText(rowIndex - 1, iCol).ToString();
            }

            int iCol1 = siMain.GetColumnIndex(DefColumns.CONSENSUS_MKT);

            if (columnValue != "LGCAU_AU_BNE" && columnValue != "LGCEG_DE_MWA" && columnValue != "LGCMI_US_LGB")
            {
                siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.CONSENSUS_MKT), rowIndex, siMain.GetColumnIndex(DefColumns.CONSENSUS_MKT), true);
                siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.CONSENSUS_ESS), rowIndex, siMain.GetColumnIndex(DefColumns.CONSENSUS_ESS), true);
                siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.CONSENSUS_SCM), rowIndex, siMain.GetColumnIndex(DefColumns.CONSENSUS_SCM), true);
                siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.INVENTORY_DAY), rowIndex, siMain.GetColumnIndex(DefColumns.INVENTORY_DAY), true);
                siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.CHANGE_REASON), rowIndex, siMain.GetColumnIndex(DefColumns.CHANGE_REASON), true);

                string cInventory_Day = string.Empty;
                cInventory_Day = siMain.GetValue(rowIndex, siMain.GetColumnIndex(DefColumns.INVENTORY_DAY)).ToString();
                if (cInventory_Day == "")
                {
                    siMain.SetValue(rowIndex, siMain.GetColumnIndex(DefColumns.INVENTORY_DAY), "0");
                }
            }

        }
        private void InsertRowLockRangeMain40(int rowIndex)
        {
                                                                                
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), rowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.DEPT_ID2), rowIndex, siMain.GetColumnIndex(DefColumns.DEPT_ID2), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE), rowIndex, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.SOLDTO_DESCRIPTION), rowIndex, siMain.GetColumnIndex(DefColumns.SOLDTO_DESCRIPTION), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE), rowIndex, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.SHIPTO_DESCRIPTION), rowIndex, siMain.GetColumnIndex(DefColumns.SHIPTO_DESCRIPTION), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.OWNER), rowIndex, siMain.GetColumnIndex(DefColumns.OWNER), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), rowIndex, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), rowIndex, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.ITEM_NAME), rowIndex, siMain.GetColumnIndex(DefColumns.ITEM_NAME), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.NICK_NAME), rowIndex, siMain.GetColumnIndex(DefColumns.NICK_NAME), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), rowIndex, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), rowIndex, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.ATTRIBUTE4), rowIndex, siMain.GetColumnIndex(DefColumns.ATTRIBUTE4), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.ATTRIBUTE5), rowIndex, siMain.GetColumnIndex(DefColumns.ATTRIBUTE5), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.SOLDTO_CUSTOMER), rowIndex, siMain.GetColumnIndex(DefColumns.SOLDTO_CUSTOMER), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.CELL_TYPE), rowIndex, siMain.GetColumnIndex(DefColumns.CELL_TYPE), true);

                                                                             
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.ENERGE_WH), rowIndex, siMain.GetColumnIndex(DefColumns.ENERGE_WH), true);

                                                                                                                                            
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.CELL_S_OP_REPORT), rowIndex, siMain.GetColumnIndex(DefColumns.CELL_S_OP_REPORT), true);
                                                                                                                               

                                                                                                                 
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG), rowIndex, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG), true);
                                                                                                               

                                                               
            if (UserInfoContext.Current["NowGroupID"] == "DM ADMIN")
            { }
            else
                siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.ALT_SIM_YN), rowIndex, siMain.GetColumnIndex(DefColumns.ALT_SIM_YN), true);

            if (UserInfoContext.Current["NowGroupID"].ToString() == "DM Planner")
            {
                siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.ATTRIBUTE1), rowIndex, siMain.GetColumnIndex(DefColumns.ATTRIBUTE1), true);
                siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.ATTRIBUTE2), rowIndex, siMain.GetColumnIndex(DefColumns.ATTRIBUTE2), true);
                siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.CUST_GROUP_DTL), rowIndex, siMain.GetColumnIndex(DefColumns.CUST_GROUP_DTL), true);
                siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.REPORT_GROUP1), rowIndex, siMain.GetColumnIndex(DefColumns.REPORT_GROUP1), true);
                siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.REPORT_GROUP2), rowIndex, siMain.GetColumnIndex(DefColumns.REPORT_GROUP2), true);
                siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.REPORT_GROUP3), rowIndex, siMain.GetColumnIndex(DefColumns.REPORT_GROUP3), true);
                siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.REPORT_GROUP4), rowIndex, siMain.GetColumnIndex(DefColumns.REPORT_GROUP4), true);
                siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.REPORT_GROUP6), rowIndex, siMain.GetColumnIndex(DefColumns.REPORT_GROUP6), true);
                   
                                                                                                                                          
                                                                                  
                                                                                                                                                            
                  
            }

        }
        #endregion

        #region 6. Event

        private void spdMain_ComboSelChange(object sender, EditorNotifyEventArgs e)
        {
            if (siMain.IsLock(siMain.SheetName) == false)
            {
                string sDivision = CAppSetting.StringALL;
                string sTeam = CAppSetting.StringALL;
                string sEndCustomer = CAppSetting.StringALL;
                string sScmSite = CAppSetting.StringALL;
                                                                    
                string sSalesCompany = "";
                string sSalesPlant = "";
                                                                                                
                string sProject = "";
                string sItem = "";

                if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID))
                {
                    sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                    dtTeam = Data.UserTeamByDivisionAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision);
                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.TEAM_ID), dtTeam);

                    sTeam = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.TEAM_ID)).ToString();
                    dtEndCustomer = Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam);
                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer);

                    sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER)).ToString();
                    dtSalesSite = Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite);
                }
                else if (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_ID))
                {
                    sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                    sTeam = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.TEAM_ID)).ToString();
                    dtEndCustomer = Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam);
                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer);

                    sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER)).ToString();
                    dtSalesSite = Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite);

                }
                else if (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER))
                {
                    sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                    sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER)).ToString();
                    dtSalesSite = Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCustomer);
                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite);
                }
                else if (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40))
                {
                    sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                    sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)).ToString();
                                                                                                                                                                
                                                                                                                    
                }
                else if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID))
                {
                    sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                    sScmSite = siMain.GetValue(e.Row, e.Column).ToString();

                    dtSalesSiteInfo = GetScmSiteInfobyDivision(sDivision, sScmSite);

                    if (dtSalesSiteInfo != null && dtSalesSiteInfo.Rows.Count > 0)
                    {
                                                                                                                                          
                                                                                                                                              
                                                                                                                                          
                                                                                                                                              
                        siMain.SetValue(e.Row, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE), dtSalesSiteInfo.Rows[0][DefColumns.SOLDTO_CODE]);
                        siMain.SetValue(e.Row, siMain.GetColumnIndex(DefColumns.SOLDTO_DESCRIPTION), dtSalesSiteInfo.Rows[0][DefColumns.SOLDTO_DESCRIPTION]);
                        siMain.SetValue(e.Row, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE), dtSalesSiteInfo.Rows[0][DefColumns.SHIPTO_CODE]);
                        siMain.SetValue(e.Row, siMain.GetColumnIndex(DefColumns.SHIPTO_DESCRIPTION), dtSalesSiteInfo.Rows[0][DefColumns.SHIPTO_DESCRIPTION]);
                    }
                    else
                    {
                                                                                                 
                                                                                                   
                                                                                                 
                                                                                                   
                        siMain.SetValue(e.Row, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE), "");
                        siMain.SetValue(e.Row, siMain.GetColumnIndex(DefColumns.SOLDTO_DESCRIPTION), "");
                        siMain.SetValue(e.Row, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE), "");
                        siMain.SetValue(e.Row, siMain.GetColumnIndex(DefColumns.SHIPTO_DESCRIPTION), "");
                    }
                }
                                                                    
                else if (e.Column == siMain.GetColumnIndex(DefColumns.SALES_COMPANY))
                {
                    sSalesCompany = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SALES_COMPANY)).ToString();

                                                                                                    
                    sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                    if ((sDivision.Substring(0, 2) == "81") || (sDivision == "82"))
                        sProject = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString();
                    sItem = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString();

                                                                                                                                                         
                                                                                       
                                                                                                                          
                                                                                                              
                                                                                                                                                            
                    dtSalesPlant = GetCommonDataList_DM("SALES_PLANT", sDivision, sSalesCompany, "", "", "");
                                                                                                            
                    if (dtSalesPlant.Rows.Count > 0)
                        siMain.SetValue(e.Row, siMain.GetColumnIndex(DefColumns.SALES_PLANT), dtSalesPlant.Rows[0]["CODE"].ToString());
                                                                                                                                                       
                }
                                                                                                    
                   
                                                                                    
                  
                                                                                                                    
 
                                                                                                    
                                                                                                                  
                                                                                    
                                                                                                                      
                                                                                                          
 
                                                                                                                          
 
                                                       
                      
                                                                                                                                            
                      
 
                  
                  
                                                                                                  
            }
        }

                                                                                                   
        private void spdSub_ComboSelChange(object sender, EditorNotifyEventArgs e)
        {
            if (siSub.IsLock(siSub.SheetName) == false)
            {
                string sDivision = CAppSetting.StringALL;
                string sSalesCompany = "";
                string sSalesPlant = "";
                string sProject = "";
                string sItem = "";

                if (e.Column == siSub.GetColumnIndex(DefColumns.SALES_COMPANY))
                {
                    sSalesCompany = siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.SALES_COMPANY)).ToString();

                    sDivision = siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                    if ((sDivision.Substring(0, 2) == "81") || (sDivision == "82"))
                        sProject = siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString();
                    sItem = siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.ITEM_ID)).ToString();

                                                                                                                                                         
                                                                                       
                                                                                                                          
                                                                                                              
                                                                                                                                                            
                    dtSalesPlant = GetCommonDataList_DM("SALES_PLANT", sDivision, sSalesCompany, "", "", "");
                                                                                                                               
                    if (dtSalesPlant.Rows.Count > 0)
                        siSub.SetValue(e.Row, siSub.GetColumnIndex(DefColumns.SALES_PLANT), dtSalesPlant.Rows[0]["CODE"].ToString());
                                                                                                                                                       
                }
                                                                                                    
                   
                                                                                   
                  
                                                                                                                  
 
                                                                                                                
                                                                                    
                                                                                                                    
                                                                                                        
 
                                                                                                                          
                                                                                                                                      
                  
                  
                                                                                                  
            }
        }

                                                                                        
        protected void spdMain_Changed(object sender, FarPoint.Win.Spread.Model.SheetDataModelEventArgs e)
        {
            FarPoint.Win.Spread.Cell cellrange;

            string sDivision = "";
                                                                                                                                      
               
                                       
                                     
                                  
                                
                                                                                                                                    
            string sSaleSiteId = "";                                        

            switch (e.Type)
            {
                case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated:

                                                                                                            
                    if ((e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) || (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40)))
                    {
                        sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                        if (sDivision.Substring(0, 2) == "40")
                            sSaleSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40)).ToString();
                        else
                            sSaleSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString();

                                                                                  
                        dtSalesCompany = Data.Common(Data.Type.CompanySalesSite, false, sDivision, sSaleSiteId, "", "", "");
                    }
                    break;
                                                                                                          

                                                                                                                                              
                                      
                                                                                    
                      
                                                                                                                      
                                                                                          
                                                                                  
                          
                                                                                                                          
                          
 
                                                                                                              
 
                                                                                                                            
                                                                                                                            
 
                                                                                                                     
                                                                                                                        
 
                                                                                                                              
                                                                                                                         
                      
                                                                                    
                      
                                                                                                                      
                                                                                                                      
                                                                                                              
 
                                                                                                                        
 
                                                                                                                              
 
                                                                                                                         
                                                                                                                            
 
                                                                                                                            
                                                                                                                          
                      
                               
                      
                                                                                                                                            
            }
        }

                                                                                                   
        protected void spdSub_Changed(object sender, FarPoint.Win.Spread.Model.SheetDataModelEventArgs e)
        {
            FarPoint.Win.Spread.Cell cellrange;

            string sDivision = "";
                                                                                                                                      
                                         
                                     
                                  
                                 
                                                                                                                                    
            string sSaleSiteId = "";                                        

            switch (e.Type)
            {
                case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated:

                                                                                                            
                    if ((e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) || (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40)))
                    {
                        sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                        if (sDivision.Substring(0, 2) == "40")
                            sSaleSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40)).ToString();
                        else
                            sSaleSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString();

                                                                                  
                        dtSalesCompany = Data.Common(Data.Type.CompanySalesSite, false, sDivision, sSaleSiteId, "", "", "");
                    }
                    break;
                                                                                                          

                                                                                                                                              
                       
                                                                                       
                          
                                                                                                                        
                                                                                                                        
                                                                                                                
 
                                                                                                                              
 
                                                                                                                                
                                                                                                                       
                                                                                                                          
 
                                                                                                                                   
                                                                                                                           
                          
                                                                                       
                          
                                                                                                                        
                                                                                                                        
                                                                                                                
 
                                                                                                                          
 
                                                                                                                                  
                                                                                                                           
 
                                                                                                                                                          
 
                                                                                                                                
                                                                                                                       
                          
                               
                      
                                                                                                                                            
            }
        }

        private void spdMain_CellDoubleClick(object sender, CellClickEventArgs e)
        {
            if (siMain.Sheet().Rows.Count <= 0)
                return;

            if (siMain.IsLock(siMain.SheetName))
            {
                if (!siSub.IsLock(siSub.ActiveSheet.SheetName))
                {
                    MessageHelper.GMessageBox("MSG00128", new object[] { siSub.ActiveSheet.SheetName });
                    return;
                }

                if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) != -1)
                    division = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID));
                if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) != -1)
                    projectCode = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE));
                if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) != -1)
                    site_ID = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID));

                string sActionYN = cboActive.Text;

                if ((clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") || (clbDivision.SelectedValue.ToString() == "82"))
                    FindData_Sub(projectCode, sActionYN, division, site_ID);
            }
            else
            {
                if ((siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_CODE))) &&
                    (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI))
                {
                    string sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString().Substring(0, 2) == "81" ? "81" : siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                    string sProject = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString();
                                                          
                    string sProjectName = string.Empty;
                    string sProjectStatus = string.Empty;
                    string sBizType = string.Empty;
                    string sCurrency = string.Empty;
                    string sProjectVerSeq = string.Empty;
                    string sProjectOwner = string.Empty;

                    string sTeam = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.TEAM_ID)).ToString();
                    string sEndCustomer = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER)).ToString(); ;
                    string sScmSite = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString();

                    SCM0002_ProjectbyDivisionPopup popProject = new SCM0002_ProjectbyDivisionPopup();
                    popProject.Form_Load(false, sDivision, sProject);
                    popProject.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                    popProject.ShowDialog();

                    sProject = popProject.ProjectCode;
                    sProjectName = popProject.ProjectName;
                    sProjectStatus = popProject.ProjectStatus;
                    sBizType = popProject.BizType;
                    sCurrency = popProject.Currency;
                    sProjectVerSeq = popProject.ProjectVerSeq;
                    sProjectOwner = popProject.ProjectOwner;

                    if (popProject.ProjectCode != "")
                    {
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), sProject);
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), sProjectName);
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_STATUS), sProjectStatus);
                                                                                              
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.CURRENCY), sCurrency);
                                                                                                     
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_OWNER), sProjectOwner);
                    }
                }

                if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.ITEM_ID)) &&
                    siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI)
                {
                    string sDivision, sItemId = "", sItemName, sItemType, sNickName, sItemclassname, sCurrency, sScmSiteId, sProject;
                    sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                        sItemId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.ITEM_NAME) != -1)
                        sItemName = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_NAME)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.ITEM_TYPE) != -1)
                        sItemType = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_TYPE)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.NICK_NAME) != -1)
                        sNickName = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME) != -1)
                        sItemclassname = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.CURRENCY) != -1)
                        sCurrency = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.CURRENCY)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40) != -1)
                        sScmSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40)).ToString();
                    if (siMain.GetColumnIndex(DefColumns.END_CUSTOMER40) != -1)
                        sProject = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)).ToString();

                    DM0002_ItembySmallDivPopup popItem = new DM0002_ItembySmallDivPopup();
                                                                                                   

                                                                                                         
                    popItem.Form_Load(true, sDivision, "ALL", "ALL", "ALL", "ALL", sItemId);
                    popItem.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                    popItem.ShowDialog();

                    if (popItem.ItemID != "")
                    {
                        sItemId = popItem.ItemID;
                                                                                               
                                                                                                          
                        if (sItemId.Contains(","))
                        {
                                                      
                            MessageHelper.GMessageBox("MSG00471");
                            return;
                        }
                                                                                             
                        sItemName = popItem.ItemName;
                        sItemType = popItem.ItemType;
                        sNickName = popItem.NickName;
                        sItemclassname = popItem.ItemClassName;
                        sCurrency = popItem.currency;
                                                          

                        if (siMain.GetColumnIndex(DefColumns.ITEM_ID) != -1)
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), sItemId);
                        if (siMain.GetColumnIndex(DefColumns.ITEM_NAME) != -1)
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_NAME), sItemName);
                        if (siMain.GetColumnIndex(DefColumns.ITEM_TYPE) != -1)
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), sItemType);
                        if (siMain.GetColumnIndex(DefColumns.NICK_NAME) != -1)
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), sNickName);
                        if (siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME) != -1)
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), sItemclassname);
                        if (siMain.GetColumnIndex(DefColumns.CURRENCY) != -1)
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.CURRENCY), sCurrency);
                                                                                                                  
                    }

                               
                }

                if (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.EditFlag)) == "Y" ||
                    siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI)
                {
                                                                   
                    if (clbDivision.SelectedValue.ToString() == "82")
                    {
                        if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_82))
                        {

                            DMF000_OwnerSet_Popup popOwner = new DMF000_OwnerSet_Popup();

                            string sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                            string sUSER_ID = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.USER_ID_82)).ToString();

                            popOwner.Form_Load(sDivision, sUSER_ID);
                            popOwner.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                            popOwner.ShowDialog();

                            if (popOwner.owner.Contains(","))
                            {
                                                              
                                MessageHelper.GMessageBox("MSG00430");
                                return;
                            }
                            else
                            {
                                if (popOwner.owner != "")
                                {
                                    siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.OWNER), popOwner.userNameEn);
                                    siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.USER_ID_82), popOwner.owner);
                                    if (siMain.GetColumnIndex(DefColumns.DEPT_ID_82) > 0)
                                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID_82), popOwner.DEPT_ID);
                                }
                            }
                        }
                        if (e.Column == siMain.GetColumnIndex(DefColumns.PRJ_OWNR_ID))
                        {
                            DMF000_OwnerSet_Popup popPrjOwner = new DMF000_OwnerSet_Popup();

                            string sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                            string sPRJ_OWNER_ID = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PRJ_OWNR_ID)).ToString();

                            popPrjOwner.Form_Load(sDivision, sPRJ_OWNER_ID);
                            popPrjOwner.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                            popPrjOwner.ShowDialog();

                            if (popPrjOwner.owner != "")
                            {
                                siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.PRJ_OWNR_ID), popPrjOwner.owner);
                            }
                        }
                    }
                                                                     
                    else
                    {
                        if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID))
                        {

                            DMF000_OwnerSet_Popup popOwner = new DMF000_OwnerSet_Popup();

                            string sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                            string sUSER_ID = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.USER_ID)).ToString();

                            popOwner.Form_Load(sDivision, sUSER_ID);
                            popOwner.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                            popOwner.ShowDialog();

                            if (popOwner.owner != "")
                            {
                                siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.OWNER), popOwner.userNameEn);
                                siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.USER_ID), popOwner.owner);
                                if (siMain.GetColumnIndex(DefColumns.DEPT_ID2) > 0)
                                    siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID2), popOwner.DEPT_ID);
                                else if (siMain.GetColumnIndex(DefColumns.DEPT_ID) > 0)
                                    siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), popOwner.DEPT_ID);
                            }
                        }
                    }
                }
            }
        }

        protected void shtMainDataModel_Changed(object sender, FarPoint.Win.Spread.Model.SheetDataModelEventArgs e)
        {
            if (e.Column == -1)
                return;

            switch (e.Type)
            {
                case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated:
                                                                      

                    if (e.Column == siMain.GetColumnIndex(DefColumns.LIABILITY_PERIOD))
                    {
                        if (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.LIABILITY_PERIOD)) != "")
                        {
                            if (int.Parse(siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.LIABILITY_PERIOD))) < 0)
                            {
                                siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.LIABILITY_PERIOD), "");
                            }
                        }
                    }
                    else if (e.Column == siMain.GetColumnIndex(DefColumns.CELL_PER_CAR) || e.Column == siMain.GetColumnIndex(DefColumns.CELL_PER_MODULE))
                    {
                        int iModulePerCar = 0;

                        if (siMain.GetText(e.Row, e.Column) == "0")
                        {
                            siMain.SetText(e.Row, e.Column, "");
                            break;
                        }

                        if (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.CELL_PER_CAR)) != ""
                            && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.CELL_PER_MODULE)) != "")
                        {
                            int iCellPerCar = (int)Convert.ToDouble(siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.CELL_PER_CAR)).ToString());
                            int iCellPerModule = (int)Convert.ToDouble(siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.CELL_PER_MODULE)).ToString());

                                                                                                                               
                                                                                                                                     
                            if (iCellPerCar % iCellPerModule > 0)
                            {
                                                                 
                                                                         
                                MessageHelper.GMessageBox("MSG00177");

                                siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.CELL_PER_CAR), "");
                                siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.CELL_PER_MODULE), "");
                                siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), "");
                                break;
                            }
                            else
                            {
                                                                                                                                               
                                                                                                                                                 
                                iModulePerCar = iCellPerCar / iCellPerModule;
                                siMain.SetValue(e.Row, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), iModulePerCar);
                            }
                        }
                        else if (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.CELL_PER_CAR)) != ""
                            && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.CELL_PER_MODULE)) == "")
                        {
                                                                
                                                                                                                       

                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), "");
                        }
                        else if (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.CELL_PER_CAR)) == ""
                            && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.CELL_PER_MODULE)) != "")
                        {
                                                              
                                                                                                                    
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), "");
                        }

                    }
                    else if (e.Column == siMain.GetColumnIndex(DefColumns.VMI_LT))
                    {
                                                                                                           
                        int iRow = e.Row;
                        int vmi_lt = Convert.ToInt32(siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.VMI_LT)));
                        int iStartRow = e.Row;

                        string scm_site_id, item_id, division_id;
                        string new_site_id, new_item_id;

                        division_id = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                        if (division_id == "40")
                        {
                            scm_site_id = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40)).ToString();
                        }
                        else
                        {
                            scm_site_id = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString();
                        }
                        new_site_id = scm_site_id;
                        item_id = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString();


                                                                            
                        for (int i = e.Row; i >= 0; i--)
                        {
                            if (division_id == "40")
                            {
                                new_site_id = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40)).ToString();
                            }
                            else
                            {
                                new_site_id = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString();
                            }

                            if (scm_site_id == new_site_id)
                            {
                                iStartRow = i;
                            }
                        }

                                                                                
                        for (int i = iStartRow; i <= siMain.GetMaxRowIndex(); i++)
                        {
                            if (division_id == "40")
                            {
                                new_site_id = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40)).ToString();
                            }
                            else
                            {
                                new_site_id = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString();
                            }
                            new_item_id = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString();

                            if (scm_site_id == new_site_id && item_id == new_item_id)
                            {
                                siMain.SetValue(i, siMain.GetColumnIndex(DefColumns.VMI_LT), vmi_lt);
                            }
                            else if (scm_site_id != new_site_id)
                            {
                                break;
                            }

                        }
                    }
                    break;
            }
        }

                                   
        protected void shtSubDataModel_Changed(object sender, FarPoint.Win.Spread.Model.SheetDataModelEventArgs e)
        {
            switch (e.Type)
            {
                case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated:
                                                                      

                    if (e.Column == siSub.GetColumnIndex(DefColumns.LIABILITY_PERIOD))
                    {
                        if (siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.LIABILITY_PERIOD)) != "")
                        {
                            if (int.Parse(siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.LIABILITY_PERIOD))) < 0)
                            {
                                siSub.SetText(e.Row, siSub.GetColumnIndex(DefColumns.LIABILITY_PERIOD), "");
                            }
                        }
                    }
                    break;
            }
        }


        private void clbDivision_SelectedIndexChanged(object sender, EventArgs e)
        {
                                                                                                     

                                                                                                                                  
                                                         

                                                                                         

                                                                                       
                                     
                
                                                                                                                                                                                           
                                              
                                              
                                                          
                                             
                                                                                                      

                                      
                                                  
                                                     
                
                   
                
                                                                                                                                                               
                                             
                                             
                                                           
                                            
                                                                                                       

                                      
                                                    
                                     
                
                                                                       

                                                                                                              

                                                                                                                                                        
                                                                   

                                         
                                        
                                       

                                                                                                                     
                           
                                                                                                                     

                                                      
                

                                                                        
                                                             
                                            

            DataService.FP_Log2("SpeedUp", "DMF0005", "division_id_changed", "start");

            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);

                                                                        
                                                                                                                                  

            SetChangeControl("UserTeamByDivision", sDivision);

            clsCtrl.setListBox(dtTeam, clbTeam, true);

            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);



                                                                                     
            if (sDivision == "40")
            {
                                                                            
                                                                                                                                                                                           

                SetChangeControl("EndCustomerByDivision", sDivision, clbTeam.ControlValues);
                lblProject.Enabled = false;
                btnProject.Enabled = false;
                splitContainer1.Panel2Collapsed = true;
                chkDetail.Checked = false;

                      
                switch (UserInfoContext.Current["NowGroupID"])
                {
                    case "ADMIN":
                    case "DM ADMIN":
                    case "SCM PI ADMIN":
                        layoutControlItem11.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Always;
                        layoutControlItem5.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Always;
                                                                    
                        layoutControlItem6.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Always;
                        break;
                    default:
                        layoutControlItem11.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
                        layoutControlItem5.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
                                                                    
                        layoutControlItem6.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
                        break;
                }

                layoutControlItem1.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;

            }
            else
            {
                                                                            
                                                                                                                                                               

                SetChangeControl("EndCustomerByDivision", sDivision, sTeam);

                lblProject.Enabled = true;
                btnProject.Enabled = true;
                splitContainer1.Panel2Collapsed = false;
                chkDetail.Checked = true;
                layoutControlItem11.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
                layoutControlItem1.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Always;
                layoutControlItem5.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
                                                            
                layoutControlItem6.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
            }
            clsCtrl.setListBox(dtEndCustomer, clbEndCustomer, true);

            string sEndCustomer = CString.GetCheckedListValue(dtEndCustomer, clbEndCustomer.ControlValues);

                                                                        
                                                                                                                                                        
            SetChangeControl("UserSiteByEndCustomer", sDivision, string.Empty, sEndCustomer);

            clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);


                                                                        
            DataService.FP_Log2("SpeedUp", "DMF0005", "division_id_changed", "end");
            InitSpread(siMain);
            InitSpread(siSub);

            this.txtProject.Text = "";
            this.txtItemId.Text = "";
            this.txtOwner.Text = "";

                                                                        
                                         

                                                                                  

                                                    
        }

        private void ClbTeam_SelectedIndexChanged(object sender, EventArgs e)
        {
            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);
            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);

                                                                                     
            if (sDivision == "40")
            {
                                                                            
                                                                                                                                                                                                  

                SetChangeControl("EndCustomerByDivision", sDivision, clbTeam.ControlValues);
            }
            else
            {
                                                                            
                                                                                                                                                               

                SetChangeControl("EndCustomerByDivision", sDivision, sTeam);
            }
            clsCtrl.setListBox(dtEndCustomer, clbEndCustomer, true);

            string sEndCustomer = CString.GetCheckedListValue(dtEndCustomer, clbEndCustomer.ControlValues);

                                                                        
                                                                                                                                                        

            SetChangeControl("UserSiteByEndCustomer", sDivision, string.Empty, sEndCustomer); clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);
        }

        private void clbEndCustomer_SelectedIndexChanged(object sender, EventArgs e)
        {
            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);
            string sEndCustomer = CString.GetCheckedListValue(dtEndCustomer, clbEndCustomer.ControlValues);

                                                                        
                                                                                                                                                        

            SetChangeControl("UserSiteByEndCustomer", sDivision, string.Empty, sEndCustomer);
            clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);
        }

        private void chkDetail_CheckedChanged(object sender, EventArgs e)
        {
            splitContainer1.Panel2Collapsed = !chkDetail.Checked;
        }

        private void spdSub_CellDoubleClick(object sender, CellClickEventArgs e)
        {
            if (!siSub.IsLock(siSub.SheetName))
            {
                if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CODE)))
                {
                    string sDivision = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                    string sProject = siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString();
                                                          
                    string sProjectName = string.Empty;
                    string sProjectStatus = string.Empty;
                    string sBizType = string.Empty;
                    string sCurrency = string.Empty;
                    string sProjectVerSeq = string.Empty;
                    string sProjectOwner = string.Empty;

                    SCM0002_ProjectbyDivisionPopup popProject = new SCM0002_ProjectbyDivisionPopup();
                    popProject.Form_Load(false, sDivision, sProject);
                    popProject.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                    popProject.ShowDialog();

                    sProject = popProject.ProjectCode;
                    sProjectName = popProject.ProjectName;
                    sProjectStatus = popProject.ProjectStatus;
                    sBizType = popProject.BizType;
                    sCurrency = popProject.Currency;
                    sProjectVerSeq = popProject.ProjectVerSeq;
                    sProjectOwner = popProject.ProjectOwner;

                    if (popProject.ProjectCode != null)
                    {
                        siSub.SetText(e.Row, siSub.GetColumnIndex(DefColumns.PROJECT_CODE), sProject);
                        siSub.SetText(e.Row, siSub.GetColumnIndex(DefColumns.PROJECT_NAME), sProjectName);
                        siSub.SetText(e.Row, siSub.GetColumnIndex(DefColumns.PROJECT_STATUS), sProjectStatus);
                                                                                              
                        siSub.SetText(e.Row, siSub.GetColumnIndex(DefColumns.CURRENCY), sCurrency);
                                                                                                     
                                                                                                                
                    }
                }
                else if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.ITEM_ID)))
                {
                    string sDivision = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                    string sProject = siSub.GetValue(siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString();
                    string sScmSiteId = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString();
                    string sItemId = "";
                    string sItemType = "";
                    string sModelType = "";
                    string sNickName = "";

                    SCM0002_ItembyDivisionPopup popItem = new SCM0002_ItembyDivisionPopup();
                                           
                    popItem.Form_Load(true, sDivision, sScmSiteId, sProject, sItemId);
                    popItem.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                    popItem.ShowDialog();

                    sItemId = popItem.ItemID;
                    sItemType = popItem.ItemType;
                    sModelType = popItem.ItemClassName;
                    sNickName = popItem.NickName;

                    if (popItem.ItemID != null)
                    {
                        siSub.SetText(e.Row, siSub.GetColumnIndex(DefColumns.ITEM_ID), sItemId);
                        siSub.SetText(e.Row, siSub.GetColumnIndex(DefColumns.ITEM_TYPE), sItemType);
                        siSub.SetText(e.Row, siSub.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), sModelType);
                        siSub.SetText(e.Row, siSub.GetColumnIndex(DefColumns.NICK_NAME), sNickName);
                    }
                }

                if (siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.EditFlag)) == "Y")
                {
                               
                    if (e.Column == siSub.GetColumnIndex(DefColumns.USER_ID))
                    {
                                                                            
                        if (clbDivision.SelectedValue.ToString() == "82")
                        {
                            DMF000_OwnerSet_Popup popOwner = new DMF000_OwnerSet_Popup();

                            string sDivision = siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                            string sUSER_ID = siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.USER_ID)).ToString();

                            popOwner.Form_Load(sDivision, sUSER_ID);
                            popOwner.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                            popOwner.ShowDialog();

                            if (popOwner.owner.Contains(","))
                            {
                                                              
                                MessageHelper.GMessageBox("MSG00430");
                                return;
                            }
                            else
                            {
                                if (popOwner.owner != "")
                                {
                                    siSub.SetText(e.Row, siSub.GetColumnIndex(DefColumns.OWNER), popOwner.userNameEn);
                                    siSub.SetText(e.Row, siSub.GetColumnIndex(DefColumns.USER_ID), popOwner.owner);
                                }
                            }
                        }
                                                                          
                        else
                        {
                            DMF000_OwnerSet_Popup popOwner = new DMF000_OwnerSet_Popup();

                            string sDivision = siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                            string sUSER_ID = siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.USER_ID)).ToString();

                            popOwner.Form_Load(sDivision, sUSER_ID);
                            popOwner.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                            popOwner.ShowDialog();

                            if (popOwner.owner != "")
                            {
                                siSub.SetText(e.Row, siSub.GetColumnIndex(DefColumns.OWNER), popOwner.userNameEn);
                                siSub.SetText(e.Row, siSub.GetColumnIndex(DefColumns.USER_ID), popOwner.owner);
                                    
                                                                                    
                                                                                                                         
                                                                                        
                                                                                                                        
                                  
                            }
                        }
                    }
                }
            }
        }

        private void btnProject_Click(object sender, EventArgs e)
        {
                                                            
                                                 
            string sProjectCode = "";

                                                                                                
                                        
                                                               
                                                                                              
                                       
            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);                               
            string sTeam = clbTeam.ControlValues;
            string sEndCustomer = clbEndCustomer.ControlValues;
            string sScmSite = clbSalesSite.ControlValues;
            string sProject = txtProject.Text;

            SCM0002_ProjectbyDivisionPopupEx popProject = new SCM0002_ProjectbyDivisionPopupEx();
            popProject.Form_Load(true, sDivision, sTeam, sEndCustomer, sScmSite, sProject);
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
            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);                               
            string sTeam = clbTeam.ControlValues;
            string sEndCustomer = clbEndCustomer.ControlValues;
            string sProject = txtProject.Text;                                                                  
            string sScmSiteId = clbSalesSite.ControlValues;
            string sItemId = txtItemId.Text;

                                                                                           
            DM0002_ItembyDivisionPopupEx popItem = new DM0002_ItembyDivisionPopupEx();

            popItem.Form_Load(true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId);
            popItem.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            popItem.ShowDialog();

            sItemId = popItem.ItemID;

            if (popItem.ItemID != "")
            {
                txtItemId.Text = sItemId;
            }
        }

        private void spdMain_LeaveCell(object sender, LeaveCellEventArgs e)
        {
            if (e.Row != e.NewRow)
            {
                if (!siSub.IsLock(siSub.ActiveSheet.SheetName))
                {
                    int iRow = e.Row;
                    e.NewRow = iRow;
                }
            }
        }

        private void spdMain_TopChange(object sender, TopChangeEventArgs e)
        {
            CanModelChange = false;
            siMain.SmartColMerge();
            CanModelChange = true;
        }

        private void spdSub_TopChange(object sender, TopChangeEventArgs e)
        {
            CanModelChange = false;
            siSub.SmartColMerge();
            CanModelChange = true;
        }

        #endregion

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

        private DataTable GetSpdTitle(string sheetname)
        {
                                                  
                                                                                           
                
                                                                                             
                                                                                            
                                                               
                                                             
                                                                             
                                                                         
                                                                  
                                                                  
                                                                                                 

                                                  
                                                                         

                                                            
                    
                                                  
                    

                             

                

                                                                                                            
                           
                                                                                                            
            DataSet dsSpdTitle = new DataSet();
            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                                                                                           
                var request = new FoxDataRequest("DM.DMF0000_GET_COMMON_SPREAD_TITLE");
                request.Parameters["p_start_yyyymmdd"] = "";
                request.Parameters["p_end_yyyymmdd"] = "";
                request.Parameters["p_created_by"] = base.UserInfo.UserId;
                                                                       
                request.Parameters["p_program_id"] = "DMF0005";
                request.Parameters["p_sheet_name"] = sheetname;
                request.Parameters["p_division_id"] = clbDivision.SelectedValue;               

                dsSpdTitle = client.ExecuteDataSet(request).DataSet;
            }

            return dsSpdTitle.Tables[0];
                                                                                           
                
                                       

                                                                                       

                             
                
        }

        private void txtProject_KeyDown(object sender, System.Windows.Forms.KeyEventArgs e)
        {
            if (e.KeyCode != System.Windows.Forms.Keys.Enter) return;

                                                                                                     
                                                          
                                                    
            string sProjectName = string.Empty;
            string sProjectStatus = string.Empty;
            string sBizType = string.Empty;
            string sCurrency = string.Empty;
            string sProjectVerSeq = string.Empty;
            string sProjectOwner = string.Empty;
            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);
            string sTeam = clbTeam.ControlValues;
            string sEndCustomer = clbEndCustomer.ControlValues;
            string sScmSite = clbSalesSite.ControlValues;
            string sProject = txtProject.ControlValues;

                                                                                                
                                                                
                                                                                              
                                       
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

            if (popProject.ProjectCode != null)
            {
                txtProject.ControlValues = sProjectName;
            }
        }

        private void btnOwner_Click(object sender, EventArgs e)
        {
                          
            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues);                              
            string sTeam = clbTeam.ControlValues;
            string sEndCustomer = clbEndCustomer.ControlValues;
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

        private DataTable GetItemType(string strType)
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

                                                                                         
        private void spdMain_CellClick(object sender, CellClickEventArgs e)
        {
            string sDivision = "";
            string sSalesCompany = "";
                                                                                                                                      
               
                                  
                                
                                                                                                                                    
            string sSalesSiteId = "";                                         

            if (!siMain.IsLock(siMain.ActiveSheet.SheetName))
            {
                if (e.Column == siMain.GetColumnIndex(DefColumns.SALES_COMPANY))
                {
                    sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();

                                                                                    
                       
                                                                                    
                                                                                                                      
                                                                                                           
                                                                                  

                                                                                
                    if (sDivision.Substring(0, 2) == "40")
                        sSalesSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID40)).ToString();
                    else
                        sSalesSiteId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString();
                                                                              

                                                                                                                                              
                       
                                                                                                                  
                    dtSalesCompany = Data.Common(Data.Type.CompanySalesSite, false, sDivision, sSalesSiteId, "", "", "");
                                                                                                                                            

                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.SALES_COMPANY), dtSalesCompany);
                }
                else if (e.Column == siMain.GetColumnIndex(DefColumns.SALES_PLANT))
                {
                    sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();

                                                                                                                                              
                       
                                                                                    
                                                                                                                      
                                                                                                            
                                                                                                                                            

                    sSalesCompany = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SALES_COMPANY)).ToString();

                                                                                                                                                         
                                                                                       
                                                                                                                          
                                                                                                              
                                                                                                                                                            
                    dtSalesPlant = GetCommonDataList_DM("SALES_PLANT", sDivision, sSalesCompany, "", "", "");
                                                                                                              
                                                                                                                                                       

                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.SALES_PLANT), dtSalesPlant);
                }
                else if (e.Column == siMain.GetColumnIndex(DefColumns.CRGE_ORG_NM))
                {
                                                                                                          
                    dtCRGE_ORG_NM = Get_DDL_SSPM_CRGE_ORG_NM();                                            
                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.CRGE_ORG_NM), dtCRGE_ORG_NM);
                                                                                                           
                }
                else if (e.Column == siMain.GetColumnIndex(DefColumns.CUST_ENG_NM))
                {
                                                                                                          
                    sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                    dtCUST_ENG_NM = Get_DDL_SSPM_CUST_ENG_NM(sDivision);                                                  
                    siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.CUST_ENG_NM), dtCUST_ENG_NM);
                                                                                                          
                }
            }
        }

                                                                                                   
        private void spdSub_CellClick(object sender, CellClickEventArgs e)
        {
            string sDivision = "";
            string sSalesCompany = "";
                                                                                                                                      
                                     
                                 
                                                                                                                                    
            string sSalesSiteId = "";                                         

            if (!siSub.IsLock(siSub.ActiveSheet.SheetName))
            {
                if (e.Column == siSub.GetColumnIndex(DefColumns.SALES_COMPANY))
                {
                    sDivision = siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();
                                                                                    
                       
                                                                                    
                                                                                                                    
                                                                                                        
                      
                                                                                  

                                                                                
                    if (sDivision.Substring(0, 2) == "40")
                        sSalesSiteId = siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.SCM_SITE_ID40)).ToString();
                    else
                        sSalesSiteId = siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString();
                                                                              

                                                                                                                                              
                       
                                                                                                                  
                    dtSalesCompany = Data.Common(Data.Type.CompanySalesSite, false, sDivision, sSalesSiteId, "", "", "");
                                                                                                                                            
                    siSub.SetCellTypeCombo(e.Row, siSub.GetColumnIndex(DefColumns.SALES_COMPANY), dtSalesCompany);

                }
                else if (e.Column == siSub.GetColumnIndex(DefColumns.SALES_PLANT))
                {
                    sDivision = siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();

                                                                                                                                              
                                                                                      
                                                                                                                    
                                                                                                         
                                                                                                                                            

                    sSalesCompany = siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.SALES_COMPANY)).ToString();
                                                                                                                                                         
                                                                                       
                                                                                                                          
                    dtSalesPlant = Data.Common(Data.Type.PlantByDivisionCompany, false, sDivision, sSalesCompany, "", "", "");
                                                                                                                                                       

                    siSub.SetCellTypeCombo(e.Row, siSub.GetColumnIndex(DefColumns.SALES_PLANT), dtSalesPlant);
                }
            }
        }

                                                                    
        private void spdMain_ClipboardPasted(object sender, ClipboardPastedEventArgs e)
        {
            string sDivision = "";
            string sSalesCompany = "";
                                                            
               
                                     
                                  
                                
                                                          

            for (int iRow = e.CellRange.Row; iRow < e.CellRange.Row + e.CellRange.RowCount; iRow++)
            {
                for (int iCol = e.CellRange.Column; iCol < e.CellRange.Column + e.CellRange.ColumnCount; iCol++)
                {
                    if (iCol == siMain.GetColumnIndex(DefColumns.SALES_COMPANY))
                    {
                        sSalesCompany = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SALES_COMPANY)).ToString();
                        sDivision = siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();

                                                                        
                           
                                                                                        
                                                                                                                         
                                                                                                              
                                                                      

                                                                                                                                                             
                                                                                           
                                                                                                                              
                                                                                                                  
                                                                                                                                                                
                        dtSalesPlant = GetCommonDataList_DM("SALES_PLANT", sDivision, sSalesCompany, "", "", "");
                                                                                                                
                        if (dtSalesPlant.Rows.Count > 0)
                            siMain.SetValue(iRow, siMain.GetColumnIndex(DefColumns.SALES_PLANT), dtSalesPlant.Rows[0]["CODE"].ToString());
                                                                                                                                                           
                    }
                                                                                                   
                       
                                                                                    
                      
                                                                                                                       
                                                                                                                     
                                                                                        
                                                                                                                         
                                                                                                             
 
                                                                                                                              
                                                                                                                                            
                      
                      
                                                                                                 
                }
            }
        }

                                                                                                   
        private void spdSub_ClipboardPasted(object sender, ClipboardPastedEventArgs e)
        {
            string sDivision = "";
            string sSalesCompany = "";
                                                            
               
                                     
                                  
                                
                                                          

            for (int iRow = e.CellRange.Row; iRow < e.CellRange.Row + e.CellRange.RowCount; iRow++)
            {
                for (int iCol = e.CellRange.Column; iCol < e.CellRange.Column + e.CellRange.ColumnCount; iCol++)
                {
                    if (iCol == siSub.GetColumnIndex(DefColumns.SALES_COMPANY))
                    {
                        sSalesCompany = siSub.GetValue(iRow, siSub.GetColumnIndex(DefColumns.SALES_COMPANY)).ToString();
                        sDivision = siSub.GetValue(iRow, siSub.GetColumnIndex(DefColumns.DIVISION_ID)).ToString();

                                                                        
                           
                                                                                        
                                                                                                                       
                                                                                                            
                                                                      

                                                                                                                                                             
                                                                                           
                                                                                                                              
                                                                                                                  
                                                                                                                                                                
                        dtSalesPlant = GetCommonDataList_DM("SALES_PLANT", sDivision, sSalesCompany, "", "", "");
                                                                                                                
                        if (dtSalesPlant.Rows.Count > 0)
                            siSub.SetValue(iRow, siSub.GetColumnIndex(DefColumns.SALES_PLANT), dtSalesPlant.Rows[0]["CODE"].ToString());
                                                                                                                                                           
                    }
                                                                                                   
                       
                                                                                   
                      
                                                                                                                     
                                                                                                                   
                                                                                        
                                                                                                                       
                                                                                                           
 
                                                                                                                              
                                                                                                                                          
                      
                      
                                                                                                 
                }
            }
        }

        private void btnModelChange_Click(object sender, EventArgs e)
        {
            DMF0005_ModelCodeChange popup = new DMF0005_ModelCodeChange();
            popup.LoadData();
            popup.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            popup.ShowDialog();

            if (popup.DialogResult == DialogResult.OK)
            {
                FindData_Main();
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

                if (iCellCnt <= 20)
                {
                                                                                                       
                                                                                                     
                    siMain.ColumnHeaderSpan(0, iCellCnt, 2, 1, 20, sColumnLabel, FPHAlign.Center);
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

                                                             
                        
                                                                                                                             
                                                                                     
                                                                           
                                             

                                                                                                                             
                                                                                     
                                                                           
                                             
                        
                                                                  
                        
                                                                                                                             
                                                                                     
                                                                           
                                             
                        

                    iLargeSpanCnt++;
                    iSmallSpanCnt++;
                }
            }

            siMain.SmartColMerge();
        }

                                                                                               
        private DataTable Get_DDL_SSPM_CRGE_ORG_NM()
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                var request = new FoxDataRequest("DM.UP_FX_GetCommonDataList_DM");
                request.Parameters["CODE"] = "SSPM_CRGE_ORG_NM";
                request.Parameters["PARAM1"] = "";
                request.Parameters["PARAM2"] = "";
                request.Parameters["PARAM3"] = "";
                request.Parameters["PARAM4"] = "";
                request.Parameters["PARAM5"] = "";
                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }
            return dt;
        }

        private DataTable Get_DDL_SSPM_CUST_ENG_NM(string p_param1)
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                var request = new FoxDataRequest("DM.UP_FX_GetCommonDataList_DM");
                request.Parameters["CODE"] = "SSPM_CUST_ENG_NM";
                request.Parameters["PARAM1"] = p_param1;       
                request.Parameters["PARAM2"] = "";
                request.Parameters["PARAM3"] = "";
                request.Parameters["PARAM4"] = "";
                request.Parameters["PARAM5"] = "";
                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }
            return dt;
        }
                                                                                             

                                                                  
        private DataTable GetCommonDataList_DM (string p_code, string p_param1, string p_param2, string p_param3, string p_param4, string p_param5)
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