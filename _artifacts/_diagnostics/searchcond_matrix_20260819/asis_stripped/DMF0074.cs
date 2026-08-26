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
using GSCM.DM.Plan.UIL.POPUP;
using System.Windows.Forms;
using GSCM.DM.Plan.UIL;
using GSCM.Windows.Forms.Service;
using GSCM.FP.Common.UIL.Service;
   
                   
                   
                   
                                                                                                      
                                           
                                                                                                      
                                              
                                                       
                                                                
                                                                         
   

namespace GSCM.DM.Plan.UIL
{
    public partial class DMF0074_MetalLinkPrice : BaseForm
    {
        #region 1. Setting
        CControl clsCtrl = null;
        private DataTable dtDivision = null;
        private DataTable dtSalesSite = null;
        private string sScmBinding = "GSCM.SCM.Master.WSL/FoxDataService.svc";
        private string sBinding = "GSCM.DM.Master.WSL/FoxDataService.svc";

                  
        public SpreadInfo siMain = null;
        private DataTable dtTeam = null;
        private DataTable dtEndCustomer = null;
        private DataTable dtPlantSite = null;
        private DataTable dtDepartment = null;
        private DataTable dtBizType = null;
        private DataTable dtCustomer = null;
        private DataTable dtPlantSiteByEndCustomer = null;

        private DataTable dtTitle = null;                 


        private bool blnWork = false;

                      
                       
                       
        private struct SpdSheet
        {
            public static string shtMain = "Metal Link Price";
        }

                      
                  
                       
        private struct DefColumns
        {

        }
        #endregion

        #region 2. Construct

        public DMF0074_MetalLinkPrice()
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
            InitEvent();
        }
        #endregion


        #region FILTER_PART

                        
        private GSCM.FP.Common.UIL.FilterDataSet Filter = new GSCM.FP.Common.UIL.FilterDataSet();

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
                case "UserPlantSiteByDivision":

                    Filter["DIVISION_ID"] = sDivision;

                    dtPlantSite = DataService.GetDMInnerTable("UserPlantSiteByDivision", Filter);

                    break;
                case "UserPlantSiteByEndCustomer":

                    Filter["DIVISION_ID"] = sDivision;
                    Filter["END_CUSTOMER"] = sEndCustomer;

                    dtPlantSiteByEndCustomer = DataService.GetDMInnerTable("UserPlantSiteByEndCustomer", Filter);

                    break;
            }
        }

        #endregion               


        private void InitControls()
        {
                                       
            drpPeriodMonth.MonthText1 = DateTime.Now.ToString("yyyyMM");
            drpPeriodMonth.MonthText2 = DateTime.Now.AddMonths(6).ToString("yyyyMM");

            dtDivision = null;
            SetChangeControl("MyDivision");
            clsCtrl.setListBox(dtDivision, clbDivisions, false, "CODE", "NAME");

            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues);

            dtDepartment = Data.Common(Data.Type.UpperDeptId, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId);

            SetChangeControl("UserTeamByDivision", sDivision);
            clsCtrl.setListBox(dtTeam, clbTeam, true);

            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);

            if ((sDivision.Substring(0, 2) == "81") || (sDivision == "82"))
            {
                SetChangeControl("EndCustomerByDivision", sDivision, sTeam);
                clsCtrl.setListBox(dtEndCustomer, clbEndCustomer, true);

                SetChangeControl("BizType", clbDivisions.ControlValues);

                lblProject.Enabled = true;
                lblPlantSite.Enabled = true;
                lblBtnProject.Enabled = true;

            }
            else
            {
                SetChangeControl("EndCustomerByDivision", clbDivisions.ControlValues, clbTeam.ControlValues);
                clsCtrl.setListBox(dtEndCustomer, clbEndCustomer, true);

                SetChangeControl("BizType", clbDivisions.ControlValues);

                lblProject.Enabled = false;
                lblPlantSite.Enabled = false;
                lblBtnProject.Enabled = false;

                txtProject.Text = "";
                clbPlantSite.ControlValues = "";
            }

            string sEndCustomer = CString.GetCheckedListValue(dtEndCustomer, clbEndCustomer.ControlValues);

            SetChangeControl("UserSiteByEndCustomer", clbDivisions.ControlValues, string.Empty, sEndCustomer);
            clsCtrl.setListBox(dtSalesSite, clbScmSite, true);

            if (sDivision.IndexOf("81") != -1)
            {
                SetChangeControl("UserPlantSiteByEndCustomer", clbDivisions.ControlValues, string.Empty, clbEndCustomer.ControlValues);
                clsCtrl.setListBox(dtPlantSiteByEndCustomer, clbPlantSite, true);
            }

                                       
            txtVersion.Text = "Current";
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

        #region 3. Define

        private void DefineProperty()
        {
            clbDivisions.ControlValues = "ALL";

            this.txtProject.KeyDown += new System.Windows.Forms.KeyEventHandler(this.txtProject_KeyDown);
            this.txtItemId.KeyDown += new System.Windows.Forms.KeyEventHandler(this.txtItemId_KeyDown);
            this.clbDivisions.SelectedIndexChanged += new System.EventHandler(this.clbDivisions_SelectedIndexChanged);
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
                btmItem_Click(null, null);
            }
        }

        private void CreateSpread()
        {
            this.AddSheet(spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30);
            siMain = GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex);
            siMain.ChangeSheet();

            InitSpread();
        }

        private void InitSpread()
        {
            dtTitle = GetSpdTitle(siMain.ActiveSheet.SheetName);
            siMain.CreateSheetHeaderColumn(siMain, 2, dtTitle);
                                                      
        }

        private void InitEvent()
        {
        }
        #endregion

        #region  4. Button

        protected override void FindButton()
        {
            FindData();
        }

        protected override void InsertButton()
        {
        }

        protected override void DeleteButton()
        {
        }

        protected override void EditButton()
        {
        }

        protected override void SaveButton()
        {
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

        private async void FindData()
        {
            GSCM.Windows.Forms.UI.ProgressForm prg = new GSCM.Windows.Forms.UI.ProgressForm();

            try
            {
                             
                if (blnWork)
                {
                    MessageHelper.GMessageBox("MSG00137");
                    return;
                }

                               
                if (txtVersion.Text.Trim() == "")
                {
                    MessageHelper.GMessageBox("MSG00283");                       
                    return;
                }

                          
                blnWork = true;

                        
                if (drpPeriodMonth.MonthText1 == "" || drpPeriodMonth.MonthText2 == "")
                {
                    MessageHelper.GMessageBox("MSG00002", new object[] { "Plan Date" });                   
                    return;
                }
                try
                {
                    DateTime dt1 = Convert.ToDateTime(drpPeriodMonth.MonthText1 + "-01");
                    DateTime dt2 = Convert.ToDateTime(drpPeriodMonth.MonthText2 + "-01");
                }
                catch
                {
                    MessageHelper.GMessageBox("MSG00049", new object[] { "" });                        
                    return;
                }

                if (Convert.ToDateTime(drpPeriodMonth.MonthText1 + "-01") > Convert.ToDateTime(drpPeriodMonth.MonthText2 + "-01"))
                {
                    MessageHelper.GMessageBox("MSG00108");                           
                    return;
                }

                         
                string p_division_id = CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues);                               
                string p_scm_site_id = clbScmSite.ControlValues;
                string p_plant_site_id = clbPlantSite.ControlValues;
                string p_project_code = txtProject.Text;
                string p_item_id = txtItemId.Text;

                string p_dept_id = clbTeam.ControlValues;
                string p_end_customer = clbEndCustomer.ControlValues;

                string p_version_type = txtVersion.Text;

                if (p_division_id == "")
                {
                    MessageHelper.GMessageBox("MSG00097");
                    return;
                }

                CanModelChange = false;
                prg.Show();

                InitSpread();
                          
                         
                                 
                SearchStartTime();

                                     

                var asyncProxy = new FoxAsyncProxy(this);
                asyncProxy.ShowProgress = false;

                var ds = await asyncProxy.ExecuteAsync<DataSet>(() =>
                {
                    using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
                    {
                        var request = new FoxDataRequest("DM.DMF0074_GET_METAL_LINK_PRICE");

                        request.CommandTimeout = 10 * 60;

                        request.Parameters["p_division_id"] = p_division_id;
                        request.Parameters["p_dept_id"] = p_dept_id;
                        request.Parameters["p_end_customer"] = p_end_customer;
                        request.Parameters["p_scm_site_id"] = p_scm_site_id;
                        request.Parameters["p_project_code"] = p_project_code;
                        request.Parameters["p_item_id"] = p_item_id;
                        request.Parameters["p_plant_site_id"] = p_plant_site_id;
                        request.Parameters["p_from_yyyymmdd"] = drpPeriodMonth.MonthText1.Replace("-", "");
                        request.Parameters["p_to_yyyymmdd"] = drpPeriodMonth.MonthText2.Replace("-", "");

                        request.Parameters["p_version_type"] = p_version_type;

                        var response = client.ExecuteDataSet(request);

                        return response.DataSet;
                    }
                });

                siMain.Query(ds);
                siMain.LockColumn(0, siMain.GetMaxColumnIndex(), true);
                SearchEndTime();

                siMain.SmartColMerge();

                               
                UIEndTime();

                CanModelChange = true;

                blnWork = false;
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
                CanModelChange = true;
                blnWork = false;
                prg.Close();
            }

        }


        #endregion

        #region 6. Event
        private void clbDivisions_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                             
                if (blnWork)
                {
                                                             
                    return;
                }
                          
                blnWork = true;

                DataService.FP_Log2("SpeedUp", "DMF0020", "division_id_changed", "start");
                string sDivision = CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues);

                SetChangeControl("UserTeamByDivision", sDivision);
                clsCtrl.setListBox(dtTeam, clbTeam, true);

                string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);


                if ((sDivision.Substring(0, 2) == "81") || (sDivision == "82"))
                {
                    SetChangeControl("EndCustomerByDivision", sDivision, sTeam);
                    clsCtrl.setListBox(dtEndCustomer, clbEndCustomer, true);

                    SetChangeControl("BizType", clbDivisions.ControlValues);

                    lblProject.Enabled = true;
                    lblBtnProject.Enabled = true;

                    if (sDivision.IndexOf("81") != -1)
                    {
                        SetChangeControl("UserPlantSiteByEndCustomer", clbDivisions.ControlValues, string.Empty, clbEndCustomer.ControlValues);
                        clsCtrl.setListBox(dtPlantSiteByEndCustomer, clbPlantSite, true);
                    }

                                                                        
                    if (sDivision == "82")
                    {
                        lblPlantSite.Enabled = false;
                        clbPlantSite.ControlValues = "";
                    }
                    else
                    {
                        lblPlantSite.Enabled = true;
                    }
                }
                else
                {
                    SetChangeControl("EndCustomerByDivision", sDivision, clbTeam.ControlValues);
                    clsCtrl.setListBox(dtEndCustomer, clbEndCustomer, true);

                    SetChangeControl("BizType", clbDivisions.ControlValues);


                    lblProject.Enabled = false;
                    lblPlantSite.Enabled = false;
                    lblBtnProject.Enabled = false;

                    clbPlantSite.ControlValues = "";
                }

                string sEndCustomer = CString.GetCheckedListValue(dtCustomer, clbEndCustomer.ControlValues);

                SetChangeControl("UserSiteByEndCustomer", sDivision, string.Empty, sEndCustomer);
                clsCtrl.setListBox(dtSalesSite, clbScmSite, true);

                DataService.FP_Log2("SpeedUp", "DMF0020", "division_id_changed", "end");

                this.txtProject.Text = "";
                this.txtItemId.Text = "";
                this.txtVersion.Text = "";

                InitSpread();

                                               
                           
                   
                                                                        
                  
                                                                         
                                                                                                          
                                                                                                          
                  
                     
                  
                                                                          
                                                                                                         
                                                                                                         
                  
                  
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

        private void clbTeam_SelectedIndexChanged(object sender, EventArgs e)
        {
            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues);
            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);

            if ((clbDivisions.SelectedValue.ToString().Substring(0, 2) == "81") || (clbDivisions.SelectedValue.ToString() == "82"))
            {
                SetChangeControl("EndCustomerByDivision", sDivision, sTeam);
            }
            else
            {
                SetChangeControl("EndCustomerByDivision", sDivision, clbTeam.ControlValues);
            }
            clsCtrl.setListBox(dtEndCustomer, clbEndCustomer, true);
            string sEndCustomer = CString.GetCheckedListValue(dtCustomer, clbEndCustomer.ControlValues);

            SetChangeControl("UserSiteByEndCustomer", sDivision, string.Empty, sEndCustomer);
            clsCtrl.setListBox(dtSalesSite, clbScmSite, true);
        }

        private void clbEndCustomer_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetChangeControl("UserSiteByEndCustomer", clbDivisions.ControlValues, string.Empty, clbEndCustomer.ControlValues);
            clsCtrl.setListBox(dtSalesSite, clbScmSite, true);
        }

        private void btnProject_Click(object sender, EventArgs e)
        {
            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues);                               
            string sTeam = clbTeam.ControlValues;
            string sEndCustomer = clbEndCustomer.ControlValues;
            string sScmSite = clbScmSite.ControlValues;
            string sProject = txtProject.Text;
            SCM0002_ProjectbyDivisionPopupEx popProject = new SCM0002_ProjectbyDivisionPopupEx();
            popProject.Form_Load(true, sDivision, sTeam, sEndCustomer, sScmSite, sProject);
            popProject.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            popProject.ShowDialog();


            sProject = popProject.ProjectCode;

            if (popProject.ProjectCode != "")
            {
                txtProject.Text = sProject;
            }
        }

        private void btmItem_Click(object sender, EventArgs e)
        {
                          
            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues);                                
            string sTeam = clbTeam.ControlValues;
            string sEndCustomer = clbEndCustomer.ControlValues;
            string sProject = txtProject.Text;                                                                  
            string sScmSiteId = clbScmSite.ControlValues;
            string sItemId = txtItemId.Text;

            DM0002_ItembyDivisionPopupEx popItem = new DM0002_ItembyDivisionPopupEx();

                                   
            popItem.Form_Load(true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId);
            popItem.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            popItem.ShowDialog();

            txtItemId.Text = popItem.ItemID;
        }

        private void btnSPVer_Click(object sender, EventArgs e)
        {
                          
            string sDivision = CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues);

            DateTime dtTime = Data.MultiTimeZone(UserInfoContext.Current["TimeZone"]);
            string sStartDate = dtTime.AddMonths(-3).ToString("yyyyMMdd");
            string sEndDate = dtTime.AddMonths(3).ToString("yyyyMMdd");

            GSCM.DM.Master.UIL.DMF0073_VersionBySalesPricePopup popVersion = new GSCM.DM.Master.UIL.DMF0073_VersionBySalesPricePopup();
            popVersion.Form_Load(true, "SP", sDivision, sStartDate, sEndDate);
            popVersion.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            popVersion.ShowDialog();

            if (popVersion.sVersions != "")
            {
                string[] sVersion = popVersion.sVersions.Split(',');
                if (sVersion.Length > 2)
                {
                    MessageHelper.GMessageBox("MSG00255", null);        
                    return;
                }
                else
                {
                    txtVersion.Text = popVersion.sVersions;
                                                                
                }
            }

        }

        private void btnTemplate_Click(object sender, EventArgs e)
        {
                       
                                                                             

                           
            DMF0074_MetalLinkPricePopup frm = new DMF0074_MetalLinkPricePopup(CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues));
            frm.StartPosition = FormStartPosition.CenterParent;
            frm.ShowDialog();
        }

        private void btnExcelUpload_Click(object sender, EventArgs e)
        {
                          

                             
                                            
            string strForm = "DMF0074";
            if (CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues) == "40")
            {
                strForm = "DMF0074_40";
                                       
            }

            ExcelUploadForm frm = new ExcelUploadForm(strForm, this.spdMain.ActiveSheet.SheetName);
            frm.SaveExceptError = true;
            frm.StartPosition = FormStartPosition.CenterParent;
            frm.ShowDialog();

            if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes)
            {
                FindData();
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
                request.Parameters["p_program_id"] = "DMF0074";
                request.Parameters["p_sheet_name"] = sheetname;
                request.Parameters["p_division_id"] = CString.GetCheckedListValue(dtDivision, clbDivisions.ControlValues);

                dt = client.ExecuteDataSet(request).DataSet.Tables[0];

                return dt;
            }
        }
        #endregion
    }
}
