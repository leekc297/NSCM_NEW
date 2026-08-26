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
using GSCM.SCM.Popup.UIL;
using System.Windows.Forms;

using GSCM.Windows.Forms.Service;
using GSCM.FP.Common.UIL.Service;

                                                                                                                            
                                
                                                                                                                            
                               
                                 
                  
                                                                                                                            
                                        
                                                                          
                                                                                 
                                                                                         
                                                                        
                                                                                   
                                                                           
                                                                                     
                                                                  
                                                     
                                                                 
                                                                     
                                                     
                                                                                               
                                                                          
                                                                                           
                                                                                                                           

namespace GSCM.DM.Master.UIL
{
    public partial class DMF0004_SalesSite : BaseForm
    {
        #region 1. Setting

        CControl clsCtrl = null;

                           
        private DataSet saveDS = null;
        private DataTable dtTitle = null;
        private DataTable dtSubBucket = null;

        private DataTable dtDivision = null;
        private DataTable dtSalesSite = null;
        private DataTable dtDetailSalesSite = null;
        private DataTable dtSoldTo = null;
        private DataTable dtSiteType = null;
        private DataTable dtPlant = null;
        private DataTable dtCity = null;
        private DataTable dtCountry = null;
        private DataTable dtIncoterms = Data.Common(Data.Type.Incoterms);
        private DataTable dtYesOrNo = Data.Common(Data.Type.YesOrNo);
        private DataTable dtEndCustomer = null;
        private DataTable dtCustomer = null;
        private DataTable dtTeam = null;
        private DataTable dtTeamAll = null;

        private DataTable dtSoldToCustomer = null;

        private DataTable dtCompany = null;

                                               
        private DataTable dtDistributionChannel = null;

                             
        private string mainID = string.Empty;

                  
        private string msScmSite = string.Empty;
        private bool mbScmSite = false;

                  
        SpreadInfo siMain = null;
        SpreadInfo siSub = null;

        TextCellType cellTypeImage = null;
                      
                       
                       
        private struct SpdSheet
        {
            public static string shtMain = "Sales Site";
                                                                   
            public static string shtSubCustomer = "Sales Customer";
            public static string shtSubLocation = "Sales Location";
            public static string shtSubBucket = "Sales Bucket";
        }

                      
                  
                       
        private struct DefColumns
        {
                              
            public static string Division = "DIVISION_ID";
            public static string Department = "DEPT_ID";
            public static string DepartmentName = "DEPT_NAME_KO";
            public static string Team = "TEAM_ID";
            public static string TeamName = "TEAM_NAME";
            public static string EndCustomer = "END_CUSTOMER";
            public static string SoldTo = "SOLDTO_CUSTOMER";
            public static string SoldToName = "SOLDTO_DESCRIPTION";
            public static string SiteId = "SCM_SITE_ID";
            public static string CompanyId = "COMPANY_ID";
            public static string RepSoldToCode = "REP_SOLDTO_CODE";
            public static string RepShipToCode = "REP_SHIPTO_CODE";
            public static string City = "CITY";
            public static string CityName = "CITY_NAME";
            public static string Country = "COUNTRY";
            public static string CountryName = "COUNTRY_NAME";
            public static string VmiYn = "VMI_YN";          
            public static string ValidYn = "VALID_YN";
            public static string UpdateUser = "LAST_UPDATED_BY";
            public static string UpdateDate = "LAST_UPDATE_DATE";
            public static string EditFlag = "EDIT_FLAG";
            public static string SHIP_PLAN_AUTO = "SHIP_PLAN_AUTO";
                                                   
            public static string DistributionChannel = "DISTRIBUTION_CHANNEL";
                                                                       
            public static string TeamEditFlag = "TEAM_EDIT_FLAG";

                             
            public static string PtojectCode = "PTOJECT_CODE";
            public static string ItemId = "ITEM_ID";
            public static string Currency = "Currency";
            public static string LiabilityPeriod = "LIABILITY_PERIOD";
            public static string SalesPlanAdjustYn = "SALES_PLAN_ADJUST_YN";

                                 
            public static string SoldToCode = "SOLDTO_CODE";
            public static string SoldToDescription = "SOLDTO_DESCRIPTION";
            public static string ShipToCode = "SHIPTO_CODE";
            public static string ShipToDescription = "SHIPTO_DESCRIPTION";
            public static string ShiptoRegionName = "SHIPTO_REGION_NAME";
            public static string ShiptoCityName = "SHIPTO_CITY_NAME";
            public static string RepYn = "REP_YN";
            public static string SoldToAddress = "SOLDTO_ADDRESS";
            public static string Contry = "CONTRY";

                                 
            public static string LocationSeq = "LOCATION_SEQ";
            public static string LocationCode = "LOCATION_CODE";
            public static string LocationDescription = "LOCATION_DESCRIPTION";
            public static string StorageId = "STORAGE_ID";
            public static string PlantId = "PLANT_ID";
            public static string Operation = "OPERATION";

            public static string Incoterms = "INCOTERMS";
            public static string YYYYMMDD = "YYYYMMDD";
            public static string Monday = "D_MON";
            public static string Tuesday = "D_TUE";
            public static string Wednesday = "D_WED";
            public static string Thursday = "D_THU";
            public static string Friday = "D_FRI";
            public static string Saturday = "D_SAT";
            public static string Sunday = "D_SUN";

            public static string BucketPer = "BUCKET_PER";
            public static string ConversionType = "CONVERSION_TYPE";
            public static string Attribute5 = "ATTRIBUTE5";
        }

        private struct DefColumnLabels
        {
            public static string Division = "Division";
            public static string Department = "Department";
            public static string DepartmentName = "Department";
            public static string Team = "Team";
            public static string TeamName = "Team";
            public static string EndCustomer = "End Customer";
            public static string SoldTo = "Sold To Customer";
            public static string SoldToName = "Sold To Name";
            public static string SiteId = "Sales Site";
            public static string CompanyId = "COMPANY";
            public static string RepSoldToCode = "Rep Sold To Code";
            public static string RepShipToCode = "Rep Ship To Code";
            public static string City = "City";
            public static string CityName = "City";
            public static string Country = "Country";
            public static string CountryName = "Country";
            public static string VmiYn = "VMI YN";          
            public static string ValidYn = "Active";
            public static string UpdateUser = "Update By";
            public static string UpdateDate = "Update Date";
            public static string SHIP_PLAN_AUTO = "Ship Plan Auto";

                             
            public static string PtojectCode = "Ptoject";
            public static string ItemId = "Item";
            public static string Currency = "Currency";
            public static string LiabilityPeriod = "Liability Period";
            public static string SalesPlanAdjustYn = "Sales Plan Adjust Yn";

                                 
            public static string SoldToCode = "Sold To";
            public static string SoldToDescription = "Sold to Name";
            public static string ShipToCode = "Ship To";
            public static string ShipToDescription = "Ship to Name";
            public static string RepYn = "Rep Yn";
            public static string SoldToAddress = "Sold To Address";
            public static string ShiptoRegionName = "Ship-To Region";
            public static string ShiptoCityName = "Ship-To City";

                                 
            public static string LocationCode = "Location";
            public static string LocationDescription = "Location Name";
            public static string StorageId = "Storage";
            public static string PlantId = "Plant";
            public static string Operation = "Operation";

            public static string Incoterms = "Incoterms";
            public static string Monday = "Mon";
            public static string Tuesday = "Tue";
            public static string Wednesday = "Wed";
            public static string Thursday = "Thu";
            public static string Friday = "Fri";
            public static string Saturday = "Sat";
            public static string Sunday = "Sun";
        }

        private string sBinding = "GSCM.DM.Master.WSL/FoxDataService.svc";
        private string sScmBinding = "GSCM.SCM.Master.WSL/FoxDataService.svc";

        private string sMyDeptID = string.Empty;

        #endregion

        #region 2. Construct

        public DMF0004_SalesSite()
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

                    dtSalesSite = DataService.GetDMInnerTable("UserSiteByEndCustomer", Filter);

                    break;
                case "ScmSitebyEndCustomer40":

                    dtSalesSite = DataService.GetDMInnerTable("ScmSitebyEndCustomer40", Filter);

                    break;
            }
        }

        #endregion               
                                           

        #region 3. Define
        private void InitControls()
        {
                                                                        
                                                                                                                                            
            SetChangeControl("MyDivision");
            clsCtrl.setListBox(dtDivision, cboDivision, false, "CODE", "NAME");

            string sDivision = CString.GetCheckedListValue(dtDivision, cboDivision.ControlValues);
                                                                        
                                                                                                                                                                                  
            SetChangeControl("UserTeamByDivision", sDivision);
            clsCtrl.setListBox(dtTeam, clbTeam, true);

            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);

                                                                        
                                                                                                                                                           
            SetChangeControl("EndCustomerByDivision", sDivision, sTeam);
            clsCtrl.setListBox(dtEndCustomer, clbEndCustomer, true);

            string sEndCustomer = CString.GetCheckedListValue(dtEndCustomer, clbEndCustomer.ControlValues);

            if ((sDivision.Substring(0, 2) == "81") || (sDivision == "82"))
            {
                                                                            
                                                                                                                                                            
                SetChangeControl("UserSiteByEndCustomer", sDivision, string.Empty, sEndCustomer);
                clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);

                lblTeam.Enabled = true;
                lblEndCustomer.Enabled = true;
            }
            else
            {
                                                                            
                                                                                                                                                   
                SetChangeControl("ScmSitebyEndCustomer40");
                clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);

                lblTeam.Enabled = false;
                lblEndCustomer.Enabled = false;
            }

            dtSoldToCustomer = GetSoldToCustomerData();                                                                                                            
            clsCtrl.setListBox(dtSoldToCustomer, clbSoldToCustomer, true);

            dtSoldTo = Data.Common(Data.Type.MyDivision, false, cboDivision.ControlValues);

            clsCtrl.setListBox(dtYesOrNo, cboActive, true);
        }

        private void DefineProperty()
        {
                         
            usrConditionPanel1.Height = 45;
            usrConditionPanel2.Visible = false;
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
        }

        private void CreateSpread()
        {
            this.AddSheet(spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30);
            siMain = GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex);
            InitSpread(siMain);

                                                             
            this.AddSheet(spdSub, SpdSheet.shtSubCustomer, SpdSheet.shtSubCustomer, 1, 1, 30);
            this.AddSheet(spdSub, SpdSheet.shtSubLocation, SpdSheet.shtSubLocation, 1, 1, 30);
            this.AddSheet(spdSub, SpdSheet.shtSubBucket, SpdSheet.shtSubBucket, 1, 1, 30);

            siSub = GetSheetInfo(spdSub.Name, SpdSheet.shtSubCustomer);
            siSub = GetSheetInfo(spdSub.Name, SpdSheet.shtSubLocation);
            siSub = GetSheetInfo(spdSub.Name, SpdSheet.shtSubBucket);

            siSub.ChangeSheet(SpdSheet.shtSubCustomer);
            InitSpread(siSub);

            siSub.ChangeSheet(SpdSheet.shtSubLocation);
            InitSpread(siSub);

            siSub.ChangeSheet(SpdSheet.shtSubBucket);
            InitSpread(siSub);

            siSub.ChangeSheet(SpdSheet.shtSubCustomer);

            fps = siMain.SpreadObject;

            siMain.ChangeSheet();
        }

        private void InitSpread(SpreadInfo spreadInfo)
        {
            dtTitle = GetSpdTitle(spreadInfo.ActiveSheet.SheetName);
            spreadInfo.CreateSheetHeaderColumn(spreadInfo, 1, dtTitle);
        }

        private void InitEvent()
        {
                                       
            FarPoint.Win.Spread.Model.DefaultSheetDataModel dsdm = (FarPoint.Win.Spread.Model.DefaultSheetDataModel)siMain.Sheet(SpdSheet.shtMain).Models.Data;
            dsdm.Changed += new FarPoint.Win.Spread.Model.SheetDataModelEventHandler(shtMainDataModel_Changed);

            FarPoint.Win.Spread.Model.DefaultSheetDataModel dsdm2 = (FarPoint.Win.Spread.Model.DefaultSheetDataModel)siSub.Sheet(SpdSheet.shtSubCustomer).Models.Data;
            dsdm2.Changed += new FarPoint.Win.Spread.Model.SheetDataModelEventHandler(shtSubCustomerDataModel_Changed);

            FarPoint.Win.Spread.Model.DefaultSheetDataModel dsdm3 = (FarPoint.Win.Spread.Model.DefaultSheetDataModel)siSub.Sheet(SpdSheet.shtSubBucket).Models.Data;
            dsdm3.Changed += new FarPoint.Win.Spread.Model.SheetDataModelEventHandler(shtSubBucketDataModel_Changed);
                                                                       

            cboDivision.SelectedIndexChanged += new System.EventHandler(cboDivision_SelectedIndexChanged);
        }

        private void InitSaveDataTable()
        {
            dtSubBucket = new DataTable("SubSubBucketSave");
            dtSubBucket.Columns.Add(DefColumns.Division, typeof(string));
            dtSubBucket.Columns.Add(DefColumns.SiteId, typeof(string));
            dtSubBucket.Columns.Add(DefColumns.Incoterms, typeof(string));
            dtSubBucket.Columns.Add(DefColumns.YYYYMMDD, typeof(string));
            dtSubBucket.Columns.Add(DefColumns.BucketPer, typeof(string));
            dtSubBucket.Columns.Add(DefColumns.ConversionType, typeof(string));
        }
        #endregion

        #region  4. Button

        protected override void FindButton()
        {
            if (fps != null)
            {
                if (fps.Name == "spdMain")
                {
                    FindData_Main();
                }

                if (fps.Name == "spdSub")
                {
                    if (siMain.ActiveSheet.Rows.Count == 0) return;


                    string sDivision = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                    string sScmSite = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SiteId)).ToString();
                    string sActive = cboActive.Text;

                    if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)
                    {
                        FindData_SubCustomer(sDivision, sScmSite, sActive);
                    }
                    else if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation)
                    {
                        FindData_SubLocation(sDivision, sScmSite, sActive);
                    }
                    else if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubBucket)
                    {
                        FindData_SubBucket(sDivision, sScmSite);
                    }
                }
            }

        }

        protected override void InsertButton()
        {
            InsertRow();
        }

        protected override void DeleteButton()
        {
            if (fps.Name == "spdMain")
            {
                if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI)
                {
                    siMain.DeleteRow();
                }
            }
            else
            {
                if (siSub.GetText(siSub.ActiveRowIndex, siSub.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI)
                {
                    siSub.DeleteRow();
                }
            }
        }

        protected override void EditButton()
        {
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

                    string sDivision = string.Empty;

                    if (siMain.GetColumnIndex(DefColumns.Division) > 0 && siMain.GetMaxRowIndex() >= 0)
                        sDivision = siMain.GetValue(0, siMain.GetColumnIndex(DefColumns.Division)).ToString();

                                                                                                         
                    if (UserInfoContext.Current["NowGroupID"].ToString() == "SCP Planner")
                    {
                        if (sDivision == "82")
                        {
                            siMain.LockRange(0, siMain.GetColumnIndex(DefColumns.Division), siMain.GetMaxRowIndex(), siMain.GetColumnIndex(DefColumns.SHIP_PLAN_AUTO), true);
                            siMain.LockRange(0, siMain.GetColumnIndex(DefColumns.UpdateDate), siMain.GetMaxRowIndex(), siMain.GetMaxColumnIndex(), true);
                        }
                        else
                        {
                            siMain.LockRange(0, siMain.GetColumnIndex(DefColumns.Division), siMain.GetMaxRowIndex(), siMain.GetMaxColumnIndex(), true);
                        }
                    }
                    else
                    {
                        for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
                        {
                            if ((siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToString() == CAppSetting.StringY))                            
                            {

                                                                                                  
                                if ((siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.TeamEditFlag)).ToString() == CAppSetting.StringY)
                                   && sDivision != "40")                            
                                {
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.Division), iRow, siMain.GetColumnIndex(DefColumns.Division), true);
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.EndCustomer), iRow, siMain.GetColumnIndex(DefColumns.SiteId), true);
                                                                                                                                                            

                                }
                                else
                                {
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.Division), iRow, siMain.GetColumnIndex(DefColumns.SiteId), true);
                                }

                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.RepSoldToCode), iRow, siMain.GetColumnIndex(DefColumns.CityName), true);
                                siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.UpdateDate), iRow, siMain.GetColumnIndex(DefColumns.EditFlag), true);

                                                                                       
                                if (UserInfoContext.Current["NowGroupID"].ToString() == "DM Planner" && sDivision == "40")
                                {
                                    siMain.LockColumn(siMain.GetColumnIndex(DefColumns.ValidYn), true);
                                }
                            }
                            else
                            {
                                if (string.IsNullOrEmpty(siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction))))
                                                                
                                    siMain.LockRange(iRow, siMain.GetColumnIndex(DefColumns.Division), iRow, siMain.GetMaxColumnIndex(), true);
                                else if (siMain.GetValue(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)).ToString() == CAppSetting.StringI)
                                {
                                    InsertRowLockRangeMain(iRow);
                                }
                            }
                        }
                    }
                }

                if (fps.Name == "spdSub")
                {
                                                                  
                    if (UserInfoContext.Current["NowGroupID"].ToString() == "SCP Planner")
                    {
                        MessageHelper.GMessageBox("MSG00096");               
                        return;
                    }

                    if (!siMain.IsLock(siMain.ActiveSheet.SheetName))
                    {
                        MessageHelper.GMessageBox("MSG00130", new object[] { siMain.ActiveSheet.SheetName, siSub.ActiveSheet.SheetName });
                        return;
                    }

                                                
                        
                                                                                                                                      
                            
                                      
                            
                        

                    siSub = GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex);
                    siSub.SwitchLock();

                    string subDivision = string.Empty;

                                                    
                    if (siSub.GetColumnIndex(DefColumns.Division) > 0 && siSub.GetMaxRowIndex() >= 0)
                        subDivision = siSub.GetValue(0, siSub.GetColumnIndex(DefColumns.Division)).ToString();

                                                                                                                                  

                    if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)
                    {
                        for (int iRow = 0; iRow <= siSub.GetMaxRowIndex(); iRow++)
                        {
                            if (siSub.GetValue(iRow, siSub.GetColumnIndex(DefColumns.EditFlag)).ToString() == CAppSetting.StringY)
                            {
                                siSub.LockRange(iRow, siSub.GetColumnIndex(DefColumns.Division), iRow, siSub.GetColumnIndex(DefColumns.ShiptoCityName), true);
                                siSub.LockRange(iRow, siSub.GetColumnIndex(DefColumns.UpdateDate), iRow, siSub.GetColumnIndex(DefColumns.EditFlag), true);


                                                                                       
                                if (UserInfoContext.Current["NowGroupID"].ToString() == "DM Planner" && subDivision == "40")
                                {
                                    siSub.LockColumn(siSub.GetColumnIndex(DefColumns.ValidYn), true);
                                }
                            }
                            else
                            {
                                if (string.IsNullOrEmpty(siSub.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction))))
                                    siSub.LockRange(iRow, siSub.GetColumnIndex(DefColumns.Division), iRow, siSub.GetColumnIndex(DefColumns.EditFlag), true);
                                else if (siSub.GetValue(iRow, siSub.GetColumnIndex(CAppSetting.StringAction)).ToString() == CAppSetting.StringI)
                                {
                                    InsertRowLockRangeSubCustomer(iRow);
                                }
                            }
                        }
                    }
                    else if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation)
                    {
                        for (int iRow = 0; iRow <= siSub.GetMaxRowIndex(); iRow++)
                        {
                            if (siSub.GetValue(iRow, siSub.GetColumnIndex(DefColumns.EditFlag)).ToString() == CAppSetting.StringY)
                            {
                                siSub.LockRange(iRow, siSub.GetColumnIndex(DefColumns.Division), iRow, siSub.GetColumnIndex(DefColumns.StorageId), true);
                                siSub.LockRange(iRow, siSub.GetColumnIndex(DefColumns.UpdateDate), iRow, siSub.GetColumnIndex(DefColumns.EditFlag), true);
                            }
                            else
                            {
                                if (string.IsNullOrEmpty(siSub.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction))))
                                    siSub.LockRange(iRow, siSub.GetColumnIndex(DefColumns.Division), iRow, siSub.GetColumnIndex(DefColumns.EditFlag), true);
                                else if (siSub.GetValue(iRow, siSub.GetColumnIndex(CAppSetting.StringAction)).ToString() == CAppSetting.StringI)
                                {
                                    InsertRowLockRangeSubLocation(iRow);
                                }
                            }
                        }
                                                                                                                                       
                                                                                                                                            
                    }
                    else if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubBucket)
                    {
                        for (int iRow = 0; iRow <= siSub.GetMaxRowIndex(); iRow++)
                        {
                            if (siSub.GetValue(iRow, siSub.GetColumnIndex(DefColumns.EditFlag)).ToString() == CAppSetting.StringY)
                            {
                                siSub.LockRange(iRow, siSub.GetColumnIndex(DefColumns.Division), iRow, siSub.GetColumnIndex(DefColumns.Incoterms), true);
                                siSub.LockRange(iRow, siSub.GetColumnIndex(DefColumns.UpdateDate), iRow, siSub.GetColumnIndex(DefColumns.EditFlag), true);
                            }
                            else
                            {
                                if (string.IsNullOrEmpty(siSub.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction))))
                                    siSub.LockRange(iRow, siSub.GetColumnIndex(DefColumns.Division), iRow, siSub.GetColumnIndex(DefColumns.EditFlag), true);
                                else if (siSub.GetValue(iRow, siSub.GetColumnIndex(CAppSetting.StringAction)).ToString() == CAppSetting.StringI)
                                {
                                    InsertRowLockRangeSubBucket(iRow);
                                }
                            }
                        }
                                                                                                                                         
                                                                                                                                            
                    }
                                                                                                                                    
                }
            }
        }

        protected override void SaveButton()
        {
            if (fps != null)
            {
                if (fps.Name == "spdMain")
                {
                    SaveData();
                }

                if (fps.Name == "spdSub")
                {
                    if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)
                    {
                        SaveSubCustomerData();
                    }
                    else if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation)
                    {
                        SaveSubLocationData();
                    }
                    else if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubBucket)
                    {
                        SaveSubBucketData();
                    }
                }
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

            siMain.SpreadObject.SuspendLayout();

            InitSpread(siMain);
            InitSpread(siSub);

            string sActive = cboActive.Text;
            string sDivisionID = CString.GetCheckedListValue(dtDivision, cboDivision.ControlValues);


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
                    var request = new FoxDataRequest("DM.DMF0004_GET_SALES_SITE_DATA");
                    request.CommandTimeout = 10 * 60;
                    request.Parameters["p_division_id"] = sDivisionID;                               
                    request.Parameters["p_dept_id"] = clbTeam.ControlValues;
                    request.Parameters["p_end_customer"] = clbEndCustomer.ControlValues;
                    request.Parameters["p_scm_site_id"] = clbSalesSite.ControlValues;
                    request.Parameters["p_active_flag"] = sActive;
                    request.Parameters["p_created_by"] = base.UserInfo.UserId;
                    request.Parameters["p_userinfo"] = UserInfoContext.Current["NowGroupID"].ToString();
                    request.Parameters["p_soldto_customer"] = clbSoldToCustomer.ControlValues;
                    request.Parameters["p_user_dept_id"] = UserInfoContext.Current["Dept_ID"].ToString();                   

                    var response = client.ExecuteDataSet(request);

                    return response.DataSet;
                }
            });

                                          
            SearchEndTime();

            siMain.Query(ds);
            siMain.LockColumn(0, siMain.GetMaxColumnIndex(), true);

            siMain.SmartColMerge();

                           
            UIEndTime();

            CanModelChange = true;

            siMain.SpreadObject.ResumeLayout();

            prg.Close();
        }

        private async void FindData_SubCustomer(string sDivision, string sScmSite, string sActive)
        {
            GSCM.Windows.Forms.UI.ProgressForm prg = new GSCM.Windows.Forms.UI.ProgressForm();
            prg.Show();

            CanModelChange = false;

            siSub.SpreadObject.SuspendLayout();

            InitSpread(siSub);

            siSub.ChangeSheet(SpdSheet.shtSubCustomer);

                             
            SearchStartTime();

            var asyncProxy = new FoxAsyncProxy(this);
            asyncProxy.ShowProgress = false;
            var ds = await asyncProxy.ExecuteAsync<DataSet>(() =>
            {
                using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
                {
                    var request = new FoxDataRequest("DM.DMF0004_GET_SALES_SITE_CUSTOMER_DATA");

                    request.Parameters["p_division_id"] = sDivision;
                    request.Parameters["p_scm_site_id"] = sScmSite;
                    request.Parameters["p_active_flag"] = sActive;
                    request.Parameters["p_created_by"] = base.UserInfo.UserId;
                    request.Parameters["p_userinfo"] = UserInfoContext.Current["NowGroupID"].ToString();

                    var response = client.ExecuteDataSet(request);

                    return response.DataSet;
                }
            });

                                          
            SearchEndTime();

            siSub.Query(ds);
            siSub.LockColumn(0, siSub.GetMaxColumnIndex(), true);

            for (int iRow = 0; iRow <= siSub.GetMaxRowIndex(); iRow++)
            {
                siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.SoldToCode)].CellType = cellTypeImage;
                siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.ShipToCode)].CellType = cellTypeImage;
            }

                           
            UIEndTime();

            CanModelChange = true;

            siSub.SpreadObject.ResumeLayout();
            prg.Close();
        }

        private async void FindData_SubLocation(string sDivision, string sScmSite, string sActive)
        {
            CanModelChange = false;

            siSub.SpreadObject.SuspendLayout();

            InitSpread(siSub);

            siSub.ChangeSheet(SpdSheet.shtSubLocation);

                             
            SearchStartTime();

            var asyncProxy = new FoxAsyncProxy(this);

            var ds = await asyncProxy.ExecuteAsync<DataSet>(() =>
            {
                using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
                {
                    var request = new FoxDataRequest("DM.DMF0004_GET_SALES_SITE_LOCATION_DATA");

                    request.Parameters["p_division_id"] = sDivision;
                    request.Parameters["p_scm_site_id"] = sScmSite;
                    request.Parameters["p_active_flag"] = sActive;
                    request.Parameters["p_created_by"] = base.UserInfo.UserId;
                    request.Parameters["p_userinfo"] = UserInfoContext.Current["NowGroupID"].ToString();

                    var response = client.ExecuteDataSet(request);

                    return response.DataSet;
                }
            });

                                          
            SearchEndTime();

            siSub.Query(ds);
            siSub.LockColumn(0, siSub.GetMaxColumnIndex(), true);

            for (int iRow = 0; iRow <= siSub.GetMaxRowIndex(); iRow++)
            {
                siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.LocationCode)].CellType = cellTypeImage;
            }

                           
            UIEndTime();

            CanModelChange = true;

            siSub.SpreadObject.ResumeLayout();
        }


        private async void FindData_SubBucket(string sDivision, string sScmSite)
        {
            CanModelChange = false;
            InitSpread(siSub);

            siSub.ChangeSheet(SpdSheet.shtSubBucket);

                             
            SearchStartTime();

            var asyncProxy = new FoxAsyncProxy(this);

            var ds = await asyncProxy.ExecuteAsync<DataSet>(() =>
            {
                using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
                {
                    var request = new FoxDataRequest("DM.DMF0004_GET_SALES_SITE_BUCKET_DATA");

                    request.Parameters["p_division_id"] = sDivision;
                    request.Parameters["p_scm_site_id"] = sScmSite;
                    request.Parameters["p_created_by"] = base.UserInfo.UserId;
                    request.Parameters["p_userinfo"] = UserInfoContext.Current["NowGroupID"].ToString();

                    var response = client.ExecuteDataSet(request);

                    return response.DataSet;
                }
            });

                                          
            SearchEndTime();

            siSub.Query(ds);
            siSub.LockColumn(0, siSub.GetMaxColumnIndex(), true);

            siSub.SmartColMerge();

                           
            UIEndTime();

            CanModelChange = true;

            dtSubBucket.Clear();
        }

        private async void SaveData()
        {
                       
            if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false)
            {
                if (siMain.ActiveSheet.Rows.Count <= 0) return;

                string sAction = string.Empty;
                string sDivisionId = string.Empty;
                string sSalesSiteId = string.Empty;
                string sSalesSiteDesc = string.Empty;
                string sCompanyId = string.Empty;
                string sEndCustomer = string.Empty;
                string sSoldToCode = string.Empty;
                string sCity = string.Empty;
                string sCountry = string.Empty;
                string sDeptId = string.Empty;
                string sVmiYN = string.Empty;
                string sValidYN = string.Empty;
                string sUrserId = string.Empty;
                int iCount = 0;
                string sDivisionChk = string.Empty;
                string sShipPlanAuto = string.Empty;
                                                       
                string sDistributionChannel = string.Empty;
                              
                string sAttribute5 = string.Empty;



                for (int i = 0; i <= siMain.GetMaxRowIndex(); i++)
                {
                    string action = siMain.GetText(i, 0);

                    if (action != CAppSetting.FlagI && action != CAppSetting.FlagM && action != CAppSetting.FlagD)
                        continue;

                    if (sAction == "")
                    {
                        sAction = action;
                        sDivisionId = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.Division) > 0)
                            sDivisionChk = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.SiteId) > 0)
                            sSalesSiteId = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SiteId)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.SiteId) > 0)
                            sSalesSiteDesc = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SiteId)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.CompanyId) > 0)
                            sCompanyId = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CompanyId)).ToString();

                                                                                                          
                        if (sDivisionChk == "40")
                        {
                            sEndCustomer = "-";
                            sDeptId = "-";
                        }
                                                                                     
                            
                                                                                                                           
                                             
                            
                        else
                        {
                            sEndCustomer = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.EndCustomer)).ToString();
                            sDeptId = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Team)).ToString();
                                                                   
                            if (sDivisionChk == "82")
                                sDistributionChannel = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DistributionChannel)).ToString();
                        }
                        if (siMain.GetColumnIndex(DefColumns.SoldTo) > 0)
                            sSoldToCode = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SoldTo)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.City) > 0)
                            sCity = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.City)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.Country) > 0)
                            sCountry = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Country)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.VmiYn) > 0)
                            sVmiYN = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VmiYn)).ToString();            
                        if (siMain.GetColumnIndex(DefColumns.ValidYn) > 0)
                            sValidYN = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ValidYn)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.SHIP_PLAN_AUTO) > 0)
                            sShipPlanAuto = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SHIP_PLAN_AUTO)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.Attribute5) > 0)
                            sAttribute5 = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Attribute5)).ToString();
                        sUrserId = base.UserInfo.UserId;
                    }
                    else
                    {
                        sAction = sAction + "^" + action;
                        sDivisionId = sDivisionId + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                        if (siMain.GetColumnIndex(DefColumns.SiteId) > 0)
                            sSalesSiteId = sSalesSiteId + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SiteId)).ToString();
                        else
                            sSalesSiteId = sSalesSiteId + "^";

                        if (siMain.GetColumnIndex(DefColumns.SiteId) > 0)
                            sSalesSiteDesc = sSalesSiteDesc + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SiteId)).ToString();
                        else
                            sSalesSiteDesc = sSalesSiteDesc + "^";

                        if (siMain.GetColumnIndex(DefColumns.CompanyId) > 0)
                            sCompanyId = sCompanyId + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CompanyId)).ToString();
                        else
                            sCompanyId = sCompanyId + "^";

                                                                                                          
                        if (sDivisionChk == "40")
                        {
                            sEndCustomer = sEndCustomer + "^" + "-";
                            sDeptId = sDeptId + "^" + "-";
                        }
                                                                                     
                            
                                                                                                                                                
                                                             
                            
                        else
                        {
                            sEndCustomer = sEndCustomer + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.EndCustomer)).ToString();
                            sDeptId = sDeptId + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Team)).ToString();

                                                                   
                            if (sDivisionChk == "82")
                                sDistributionChannel = sDistributionChannel + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DistributionChannel)).ToString();

                        }
                        if (siMain.GetColumnIndex(DefColumns.SoldTo) > 0)
                            sSoldToCode = sSoldToCode + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SoldTo)).ToString();
                        else
                            sSoldToCode = sSoldToCode + "^";

                        if (siMain.GetColumnIndex(DefColumns.City) > 0)
                            sCity = sCity + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.City)).ToString();
                        else
                            sCity = sCity + "^";

                        if (siMain.GetColumnIndex(DefColumns.Country) > 0)
                            sCountry = sCountry + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Country)).ToString();
                        else
                            sCountry = sCountry + "^";

                        if (siMain.GetColumnIndex(DefColumns.VmiYn) > 0)
                            sVmiYN = sVmiYN + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VmiYn)).ToString();         
                        else
                            sVmiYN = sVmiYN + "^";

                        if (siMain.GetColumnIndex(DefColumns.ValidYn) > 0)
                            sValidYN = sValidYN + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ValidYn)).ToString();
                        else
                            sValidYN = sValidYN + "^";

                        if (siMain.GetColumnIndex(DefColumns.SHIP_PLAN_AUTO) > 0)
                            sShipPlanAuto = sShipPlanAuto + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SHIP_PLAN_AUTO)).ToString();
                        else
                            sShipPlanAuto = sShipPlanAuto + "^";

                        if (siMain.GetColumnIndex(DefColumns.Attribute5) > 0)
                            sAttribute5 = sAttribute5 + "^" + siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Attribute5)).ToString();
                        else
                            sAttribute5 = sAttribute5 + "^";

                        sUrserId = sUrserId + "^" + base.UserInfo.UserId; ;
                    }

                    string sDivision = siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                    if (sDivision == "")
                    {
                        string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnLabels.Division)
                                            );

                                                               
                        MessageHelper.GMessageBox("MSG00002", new object[] { args });

                        return;
                    }
                                                                                                         
                                                                                  
                                                                                                                                                                            
                    else if (((sDivision.Substring(0, 2) == "81") || (sDivision == "82"))
                           && (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Team)).ToString() == ""))
                    {
                        string args = string.Format("{0}"
                                    , MessageHelper.GetTerm(DefColumnLabels.Team)
                                    );
                                                          
                                                               
                        MessageHelper.GMessageBox("MSG00002", new object[] { args });
                       
                        return;
                    }
                                                                                               
                                                    
                                                                                                                                          
                        
                                                            
                                                                                         
                                         

                                                                 
                                                                                        

                                  
                        

                                                                                                         
                                                                                  
                                                                                                                                                                            
                    else if (((sDivision.Substring(0, 2) == "81") || (sDivision == "82"))
                                                                                                               
                           && (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.EndCustomer)).ToString() == ""))             
                    {
                        string args = string.Format("{0}"
                                    , MessageHelper.GetTerm(DefColumnLabels.EndCustomer)
                                    );
                                                                  
                                                               
                        MessageHelper.GMessageBox("MSG00002", new object[] { args });
                        
                        return;
                    }
                    else if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SoldTo)).ToString() == "")
                    {
                        string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnLabels.SoldTo)
                                            );
                                                             
                                                               
                        MessageHelper.GMessageBox("MSG00002", new object[] { args });
                        

                        return;
                    }
                    else if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SiteId)).ToString().Trim() == "")
                    {
                        string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnLabels.SiteId)
                                            );

                                                               
                        MessageHelper.GMessageBox("MSG00002", new object[] { args });

                        return;
                    }
                                                                                                                                                       
                        
                                                            
                                                                                                 
                                                 

                                                                 
                                                                                        

                                  
                        
                    else if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Country)).ToString() == "")
                    {
                        string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnLabels.Country)
                                            );

                                                               
                        MessageHelper.GMessageBox("MSG00002", new object[] { args });

                        return;
                    }
                    else if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.City)).ToString() == "")
                    {
                        string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnLabels.City)
                                            );

                                                               
                        MessageHelper.GMessageBox("MSG00002", new object[] { args });

                        return;
                    }
                    else if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ValidYn)).ToString() == "")
                    {
                        string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnLabels.ValidYn)
                                            );

                                                               
                        MessageHelper.GMessageBox("MSG00002", new object[] { args });

                        return;
                    }

                                                                                                  
                                                                                                                                                                                      
                    else if (((sDivision.Substring(0, 2) == "81") || (sDivision == "82") || (sDivision.Substring(0, 2) == "40"))
                         && (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SHIP_PLAN_AUTO)).ToString() == ""))
                    {
                        string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnLabels.SHIP_PLAN_AUTO)
                                            );

                                                               
                        MessageHelper.GMessageBox("MSG00002", new object[] { args });

                        return;
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
                            string sProcedureName = "DM.DMF0004_SAVE_SALES_SITE_DATA";
                            var request = new FoxDataRequest(sProcedureName);
                            request.Parameters["p_active_flag"] = sAction;
                            request.Parameters["p_division_id"] = sDivisionId;
                            request.Parameters["p_scm_site_id"] = sSalesSiteId;
                            request.Parameters["p_site_description"] = sSalesSiteDesc;
                            request.Parameters["p_company_id"] = sCompanyId;
                            request.Parameters["p_end_customer"] = sEndCustomer;
                            request.Parameters["p_sold_customer"] = sSoldToCode;
                            request.Parameters["p_city"] = sCity;
                            request.Parameters["p_country"] = sCountry;
                            request.Parameters["p_dept_id"] = sDeptId;
                            request.Parameters["p_distribution_channel"] = sDistributionChannel;                                         
                            request.Parameters["p_vmi_yn"] = sVmiYN;            
                            request.Parameters["p_valid_yn"] = sValidYN;
                            request.Parameters["p_created_by"] = sUrserId;
                            request.Parameters["p_ship_plan_auto"] = sShipPlanAuto;
                            request.Parameters["p_attribute5"] = sAttribute5;

                            var response = client.ExecuteDataSet(request);

                            if (response.DataSet.Tables.Count != 0)
                            {
                                MessageHelper.GMessageBox(response.DataSet.Tables[0].Rows[0][0].ToString());
                            }
                            else
                            {
                                MessageHelper.GMessageBox("MSG00004", new object[] { iCount });

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

        private async void SaveSubCustomerData()
        {
            if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false)
            {
                if (siSub.ActiveSheet.Rows.Count <= 0) return;

                string sProcedureName = "DM.DMF0004_SAVE_SALES_SITE_CUSTOMER_DATA";
                string sAction = string.Empty;
                string sDivisionId = string.Empty;
                string sSalesSiteId = string.Empty;
                string sSoldTo = string.Empty;
                string sSoldToDesc = string.Empty;
                string sShipTo = string.Empty;
                string sShipToDesc = string.Empty;
                string sRepYN = string.Empty;
                string sValidYN = string.Empty;
                string sUrserId = string.Empty;
                int iCount = 0;

                for (int i = 0; i <= siSub.GetMaxRowIndex(); i++)
                {
                    string action = siSub.GetText(i, 0);

                    if (action != CAppSetting.FlagI && action != CAppSetting.FlagM && action != CAppSetting.FlagD)
                        continue;

                                                              
                    if (action == CAppSetting.FlagI
                        && (siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SoldToCode)).ToString() == ""
                            || siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ShipToCode)).ToString() == "")
                        )
                    {
                        MessageHelper.GMessageBox("MSG00120");
                        return;
                    }

                    if (sAction == "")
                    {
                        sAction = action;
                        sDivisionId = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.Division)).ToString();
                        sSalesSiteId = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SiteId)).ToString();
                        sSoldTo = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SoldToCode)).ToString();
                        sSoldToDesc = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SoldToDescription)).ToString();
                        sShipTo = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ShipToCode)).ToString();
                        sShipToDesc = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ShipToDescription)).ToString();
                        sRepYN = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.RepYn)).ToString();
                        sValidYN = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ValidYn)).ToString();
                        sUrserId = base.UserInfo.UserId; ;
                    }
                    else
                    {
                        sAction = sAction + "^" + action;
                        sDivisionId = sDivisionId + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.Division)).ToString();
                        sSalesSiteId = sSalesSiteId + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SiteId)).ToString();
                        sSoldTo = sSoldTo + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SoldToCode)).ToString();
                        sSoldToDesc = sSoldToDesc + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SoldToDescription)).ToString();
                        sShipTo = sShipTo + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ShipToCode)).ToString();
                        sShipToDesc = sShipToDesc + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ShipToDescription)).ToString();
                        sRepYN = sRepYN + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.RepYn)).ToString();
                        sValidYN = sValidYN + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ValidYn)).ToString();
                        sUrserId = sUrserId + "^" + base.UserInfo.UserId; ;
                    }

                    if (siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SoldToCode)).ToString() == "")
                    {
                        string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnLabels.SoldToCode)
                                            );

                                                               
                        MessageHelper.GMessageBox("MSG00002", new object[] { args });

                        return;
                    }
                    else if (siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ShipToCode)).ToString() == "")
                    {
                        string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnLabels.ShipToCode)
                                            );

                                                               
                        MessageHelper.GMessageBox("MSG00002", new object[] { args });

                        return;
                    }
                    else if (siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.RepYn)).ToString() == "")
                    {
                        string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnLabels.RepYn)
                                            );

                                                               
                        MessageHelper.GMessageBox("MSG00002", new object[] { args });

                        return;
                    }
                    else if (siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ValidYn)).ToString() == "")
                    {
                        string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnLabels.ValidYn)
                                            );

                                                               
                        MessageHelper.GMessageBox("MSG00002", new object[] { args });

                        return;
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
                            request.Parameters["p_active_flag"] = sAction;
                            request.Parameters["p_division_id"] = sDivisionId;
                            request.Parameters["p_scm_site_id"] = sSalesSiteId;
                            request.Parameters["p_soldto_code"] = sSoldTo;
                            request.Parameters["p_soldto_description"] = sSoldToDesc;
                            request.Parameters["p_shipto_code"] = sShipTo;
                            request.Parameters["p_shipto_description"] = sShipToDesc;
                            request.Parameters["p_rep_yn"] = sRepYN;
                            request.Parameters["p_valid_yn"] = sValidYN;
                            request.Parameters["p_created_by"] = sUrserId;

                            var response = client.ExecuteDataSet(request);

                            if (response.DataSet.Tables.Count != 0)
                            {
                                if (response.DataSet.Tables[0].Rows[0][0].ToString() == "MSG00179")
                                {
                                    string SalesSiteId = response.DataSet.Tables[0].Rows[0][1].ToString();
                                    string ShipToCode = response.DataSet.Tables[0].Rows[0][2].ToString();

                                    MessageHelper.GMessageBox("MSG00179", new object[] { SalesSiteId, ShipToCode });
                                }
                                else
                                {
                                    MessageHelper.GMessageBox(response.DataSet.Tables[0].Rows[0][0].ToString());
                                }
                            }
                            else
                            {
                                MessageHelper.GMessageBox("MSG00004", new object[] { iCount });

                                string sDivision = siSub.GetValue(siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division)).ToString();
                                string sScmSite = siSub.GetValue(siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.SiteId)).ToString();
                                string sActive = cboActive.Text;

                                FindData_SubCustomer(sDivision, sScmSite, sActive);
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

        private async void SaveSubLocationData()
        {
            if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false)
            {
                if (siSub.ActiveSheet.Rows.Count <= 0) return;

                string sProcedureName = "DM.DMF0004_SAVE_SALES_SITE_LOCATION_DATA";
                string sAction = string.Empty;
                string sLocationSeq = string.Empty;
                string sDivisionId = string.Empty;
                string sLocationCode = string.Empty;
                string sLocationDesc = string.Empty;
                string sSalesSiteId = string.Empty;
                string sStorageId = string.Empty;
                string sPlantId = string.Empty;
                string sValidYN = string.Empty;
                string sUrserId = string.Empty;
                int iCount = 0;
                int iChkCount = 0;

                for (int i = 0; i <= siSub.GetMaxRowIndex(); i++)
                {
                    string action = siSub.GetText(i, 0);

                    if (action != CAppSetting.FlagI && action != CAppSetting.FlagM && action != CAppSetting.FlagD)
                        continue;

                    if (sAction == "")
                    {
                        sAction = action;
                        sLocationSeq = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.LocationSeq)).ToString();
                        sDivisionId = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.Division)).ToString();
                        sLocationCode = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.LocationCode)).ToString();
                        sLocationDesc = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.LocationDescription)).ToString();
                        sSalesSiteId = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SiteId)).ToString();
                        sPlantId = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.PlantId)).ToString();
                        sStorageId = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.StorageId)).ToString();
                        sValidYN = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ValidYn)).ToString();
                        sUrserId = base.UserInfo.UserId; ;
                    }
                    else
                    {
                        sAction = sAction + "^" + action;
                        sLocationSeq = sLocationSeq + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.LocationSeq)).ToString();
                        sDivisionId = sDivisionId + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.Division)).ToString();
                        sLocationCode = sLocationCode + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.LocationCode)).ToString();
                        sLocationDesc = sLocationDesc + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.LocationDescription)).ToString();
                        sSalesSiteId = sSalesSiteId + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SiteId)).ToString();
                        sPlantId = sPlantId + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.PlantId)).ToString();
                        sStorageId = sStorageId + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.StorageId)).ToString();
                        sValidYN = sValidYN + "^" + siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ValidYn)).ToString();
                        sUrserId = sUrserId + "^" + base.UserInfo.UserId; ;
                    }

                    string sDivisionIdChk = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.Division)).ToString();
                    string sSalesSiteIdChk = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SiteId)).ToString();
                    string sLocationCodeChk = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.LocationCode)).ToString();
                    string sPlantIdChk = siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.PlantId)).ToString();

                    if (siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.LocationCode)).ToString() == "")
                    {
                        string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnLabels.LocationCode)
                                            );

                                                               
                        MessageHelper.GMessageBox("MSG00002", new object[] { args });

                        return;
                    }
                    else if (siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ValidYn)).ToString() == "")
                    {
                        string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnLabels.ValidYn)
                                            );

                                                               
                        MessageHelper.GMessageBox("MSG00002", new object[] { args });

                        return;
                    }
                                                                
                    else if (siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.PlantId)).ToString() == "")
                    {
                        string args = string.Format("{0}"
                                            , MessageHelper.GetTerm(DefColumnLabels.PlantId)
                                            );

                                                               
                        MessageHelper.GMessageBox("MSG00002", new object[] { args });

                        return;
                    }



                    for (int iRow = 0; iRow <= siSub.GetMaxRowIndex(); iRow++)
                    {
                        if (sDivisionIdChk == siSub.GetValue(iRow, siSub.GetColumnIndex(DefColumns.Division)).ToString()
                            && sSalesSiteIdChk == siSub.GetValue(iRow, siSub.GetColumnIndex(DefColumns.SiteId)).ToString()
                            && sLocationCodeChk == siSub.GetValue(iRow, siSub.GetColumnIndex(DefColumns.LocationCode)).ToString()
                            && sPlantIdChk == siSub.GetValue(iRow, siSub.GetColumnIndex(DefColumns.PlantId)).ToString())
                        {
                            iChkCount++;

                            if (iChkCount > 1)
                            {
                                string args = string.Format("{0}, {1}, {2}, {3}"
                                    , MessageHelper.GetTerm(DefColumnLabels.Division)
                                    , MessageHelper.GetTerm(DefColumnLabels.SiteId)
                                    , MessageHelper.GetTerm(DefColumnLabels.LocationCode)
                                    , MessageHelper.GetTerm(DefColumnLabels.PlantId)
                                    );

                                                                       
                                MessageHelper.GMessageBox("MSG00060", new object[] { args });

                                siSub.SetValue(i, siSub.GetColumnIndex(DefColumns.LocationCode), "");
                                siSub.SetValue(i, siSub.GetColumnIndex(DefColumns.LocationDescription), "");
                                siSub.SetValue(i, siSub.GetColumnIndex(DefColumns.PlantId), "");
                                iCount = 0;
                                return;
                            }
                        }
                    }

                    iChkCount = 0;
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
                            request.Parameters["p_active_flag"] = sAction;
                            request.Parameters["p_location_seq"] = sLocationSeq;
                            request.Parameters["p_division_id"] = sDivisionId;
                            request.Parameters["p_location_code"] = sLocationCode;
                            request.Parameters["p_location_description"] = sLocationCode;
                            request.Parameters["p_scm_site_id"] = sSalesSiteId;
                            request.Parameters["p_plant_id"] = sPlantId;
                            request.Parameters["p_storage_id"] = sStorageId;
                            request.Parameters["p_valid_yn"] = sValidYN;
                            request.Parameters["p_created_by"] = sUrserId;

                            var response = client.ExecuteDataSet(request);

                            if (response.DataSet.Tables.Count != 0)
                            {
                                MessageHelper.GMessageBox(response.DataSet.Tables[0].Rows[0][0].ToString());
                            }
                            else
                            {
                                MessageHelper.GMessageBox("MSG00004", new object[] { iCount });

                                string sDivision = siSub.GetValue(siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division)).ToString();
                                string sScmSite = siSub.GetValue(siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.SiteId)).ToString();
                                string sActive = cboActive.Text;

                                FindData_SubLocation(sDivision, sScmSite, sActive);
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
        private async void SaveSubBucketData()
        {
            if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false)
            {
                if (siSub.ActiveSheet.Rows.Count <= 0) return;

                string sProcedureName = "DM.DMF0004_SAVE_SALES_SITE_BUCKET_DATA";
                string sAction = string.Empty;
                string sDivisionId = string.Empty;
                string sSalesSiteId = string.Empty;
                string sIncoterms = string.Empty;
                string sYYYYMMDD = string.Empty;
                string sBucketPer = string.Empty;
                string sConversionType = string.Empty;
                                                  
                string sUrserId = string.Empty;
                int iCount = 0;

                foreach (DataRow dr in dtSubBucket.Rows)
                {
                    if (sAction == "")
                    {
                        sAction = CAppSetting.FlagM;
                        sDivisionId = dr[DefColumns.Division].ToString();
                        sSalesSiteId = dr[DefColumns.SiteId].ToString();
                        sIncoterms = dr[DefColumns.Incoterms].ToString();
                        sYYYYMMDD = dr[DefColumns.YYYYMMDD].ToString();
                        sBucketPer = dr[DefColumns.BucketPer].ToString();
                        sConversionType = dr[DefColumns.ConversionType].ToString();
                                                                                                                                       
                        sUrserId = base.UserInfo.UserId; ;
                    }
                    else
                    {
                        sAction = sAction + "^" + CAppSetting.FlagM;
                        sDivisionId = sDivisionId + "^" + dr[DefColumns.Division].ToString();
                        sSalesSiteId = sSalesSiteId + "^" + dr[DefColumns.SiteId].ToString();
                        sIncoterms = sIncoterms + "^" + dr[DefColumns.Incoterms].ToString();
                        sYYYYMMDD = sYYYYMMDD + "^" + dr[DefColumns.YYYYMMDD].ToString();
                        sBucketPer = sBucketPer + "^" + dr[DefColumns.BucketPer].ToString();
                        sConversionType = sConversionType + "^" + dr[DefColumns.ConversionType].ToString();
                                                                                                                                       
                        sUrserId = sUrserId + "^" + base.UserInfo.UserId;
                    }

                    iCount++;
                }

                if (iCount > 0)
                {
                    for (int iRow = 0; iRow <= siSub.GetMaxRowIndex(); iRow++)
                    {
                        string action = siSub.GetText(iRow, 0);

                        if (action != CAppSetting.FlagI && action != CAppSetting.FlagM && action != CAppSetting.FlagD)
                            continue;

                        if (siSub.GetValue(siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division)).ToString() == "")
                        {
                            MessageHelper.GMessageBox("MSG00002", new object[] { DefColumnLabels.Division });
                            return;
                        }

                        if (siSub.GetValue(siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.SiteId)).ToString() == "")
                        {
                            MessageHelper.GMessageBox("MSG00002", new object[] { DefColumnLabels.SiteId });
                            return;
                        }

                        if (siSub.GetValue(siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Incoterms)).ToString() == "")
                        {
                            MessageHelper.GMessageBox("MSG00002", new object[] { DefColumnLabels.Incoterms });
                            return;
                        }
                    }


                    try
                    {
                        var asyncProxy = new FoxAsyncProxy(this);

                                                                                
                            
                        using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
                        {
                            var request = new FoxDataRequest(sProcedureName);
                            request.Parameters["p_active_flag"] = sAction;
                            request.Parameters["p_division_id"] = sDivisionId;
                            request.Parameters["p_scm_site_id"] = sSalesSiteId;
                            request.Parameters["p_Incoterms"] = sIncoterms;
                            request.Parameters["p_yyyymmdd"] = sYYYYMMDD;
                            request.Parameters["p_bucket_per"] = sBucketPer;
                            request.Parameters["p_conversion_type"] = sConversionType;
                                                                           
                            request.Parameters["p_created_by"] = sUrserId;

                            var response = client.ExecuteDataSet(request);

                            if (response.DataSet.Tables.Count != 0)
                            {
                                MessageHelper.GMessageBox(response.DataSet.Tables[0].Rows[0][0].ToString());
                            }
                            else
                            {
                                MessageHelper.GMessageBox("MSG00004", new object[] { iCount });

                                string sDivision = siSub.GetValue(siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division)).ToString();
                                string sScmSite = siSub.GetValue(siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.SiteId)).ToString();

                                FindData_SubBucket(sDivision, sScmSite);
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

        private void InsertRow()
        {
                                                           
            if (UserInfoContext.Current["NowGroupID"].ToString() == "SCP Planner")
            {
                MessageHelper.GMessageBox("MSG00096");               
                return;
            }


            if (fps.Name == "spdMain")
            {
                if (siMain != null && siMain.IsLock(siMain.SheetName) == false)
                {
                    if (siMain.SheetName == SpdSheet.shtMain)
                    {
                        siMain.SpreadObject.SuspendLayout();

                        FarPoint.Win.Spread.Cell insCell = siMain.Insert();
                        Dictionary<object, object> defaultData = new Dictionary<object, object>();

                        InsertRowLockRangeMain(siMain.ActiveRowIndex);

                        if (siMain.GetColumnIndex(DefColumns.CountryName) > 0)
                            siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CountryName)].CellType = cellTypeImage;
                        if (siMain.GetColumnIndex(DefColumns.CityName) > 0)
                            siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CityName)].CellType = cellTypeImage;
                        if (siMain.GetColumnIndex(DefColumns.ValidYn) > 0)
                            siMain.SetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ValidYn), CAppSetting.StringY);
                        if (siMain.GetColumnIndex(DefColumns.VmiYn) > 0)
                            siMain.SetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.VmiYn), CAppSetting.StringN);
                        if (siMain.GetColumnIndex(DefColumns.Division) > 0)
                            siMain.SetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division), cboDivision.ControlValues);

                        string sDivisionID = siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division)).ToString();

                        dtCustomer = Data.Common(Data.Type.EndCustomer, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division)).ToString());
                        if (siMain.GetColumnIndex(DefColumns.TeamName) != -1)
                            siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TeamName)].CellType = cellTypeImage;

                        dtSoldTo = Data.Common(Data.Type.SoldCustomer, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division)).ToString());

                        if (siMain.GetColumnIndex(DefColumns.EndCustomer) != -1)
                            siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.EndCustomer), dtCustomer);
                        siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SoldTo), dtSoldTo);

                        dtCompany = Data.Common(Data.Type.COMPANY_ID_INTERNAL_TXN, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CompanyId)).ToString());
                        if (siMain.GetColumnIndex(DefColumns.CompanyId) != -1)
                            siMain.SetCellTypeCombo(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CompanyId), dtCompany);

                        siMain.SpreadObject.ResumeLayout();
                    }
                }
            }
            else
            {
                if (siMain.ActiveSheet.Rows.Count == 0) return;

                if (siSub != null && siSub.IsLock(siSub.SheetName) == false)
                {
                    siSub.SpreadObject.SuspendLayout();

                    FarPoint.Win.Spread.Cell insCell = siSub.Insert();
                    Dictionary<object, object> defaultData = new Dictionary<object, object>();

                    siSub.SetCellTypeCombo(siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), dtDivision);

                                                                                                         
                    siSub.SetValue(siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division)));
                    siSub.SetValue(siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.SiteId), siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SiteId)));

                    if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)
                    {
                        InsertRowLockRangeSubCustomer(siSub.ActiveRowIndex);

                        siSub.ActiveSheet.Cells[siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.SoldToCode)].CellType = cellTypeImage;
                        siSub.ActiveSheet.Cells[siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.ShipToCode)].CellType = cellTypeImage;

                        siSub.SetValue(siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.RepYn), CAppSetting.StringY);
                        siSub.SetValue(siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.ValidYn), CAppSetting.StringY);
                        siSub.SetValue(siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), cboDivision.ControlValues);
                    }
                    else if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation)
                    {
                        InsertRowLockRangeSubLocation(siSub.ActiveRowIndex);

                        siSub.ActiveSheet.Cells[siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.LocationCode)].CellType = cellTypeImage;
                                      
                        siSub.SetValue(siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.ValidYn), CAppSetting.StringY);
                        siSub.SetValue(siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), cboDivision.ControlValues);
                    }
                    else if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubBucket)
                    {
                        InsertRowLockRangeSubBucket(siSub.ActiveRowIndex);

                                                                                                                                                 
                        siSub.SetValue(siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), cboDivision.ControlValues);
                    }

                    siSub.LockRange(siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), true);
                    siSub.SpreadObject.ResumeLayout();
                }
            }
        }
        private void InsertRowLockRangeMain(int rowIndex)
        {
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.SiteId), rowIndex, siMain.GetColumnIndex(DefColumns.SiteId), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.RepSoldToCode), rowIndex, siMain.GetColumnIndex(DefColumns.RepShipToCode), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.UpdateDate), rowIndex, siMain.GetColumnIndex(DefColumns.UpdateUser), true);
            siMain.LockRange(rowIndex, siMain.GetColumnIndex(DefColumns.Division), rowIndex, siMain.GetColumnIndex(DefColumns.Division), true);
        }

        private void InsertRowLockRangeSubCustomer(int rowIndex)
        {
            siSub.LockRange(rowIndex, siSub.GetColumnIndex(DefColumns.Division), rowIndex, siSub.GetColumnIndex(DefColumns.SiteId), true);
            siSub.LockRange(rowIndex, siSub.GetColumnIndex(DefColumns.SoldToDescription), rowIndex, siSub.GetColumnIndex(DefColumns.SoldToDescription), true);
            siSub.LockRange(rowIndex, siSub.GetColumnIndex(DefColumns.ShipToDescription), rowIndex, siSub.GetColumnIndex(DefColumns.ShiptoCityName), true);
            siSub.LockRange(rowIndex, siSub.GetColumnIndex(DefColumns.UpdateDate), rowIndex, siSub.GetColumnIndex(DefColumns.UpdateUser), true);
        }
        private void InsertRowLockRangeSubLocation(int rowIndex)
        {
            siSub.LockRange(rowIndex, siSub.GetColumnIndex(DefColumns.Division), rowIndex, siSub.GetColumnIndex(DefColumns.PlantId), true);
            siSub.LockRange(rowIndex, siSub.GetColumnIndex(DefColumns.LocationDescription), rowIndex, siSub.GetColumnIndex(DefColumns.LocationDescription), true);
            siSub.LockRange(rowIndex, siSub.GetColumnIndex(DefColumns.UpdateDate), rowIndex, siSub.GetColumnIndex(DefColumns.UpdateUser), true);
        }
        private void InsertRowLockRangeSubBucket(int rowIndex)
        {
            siSub.LockRange(rowIndex, siSub.GetColumnIndex(DefColumns.Division), rowIndex, siSub.GetColumnIndex(DefColumns.SiteId), true);
            siSub.LockRange(rowIndex, siSub.GetColumnIndex(DefColumns.UpdateDate), rowIndex, siSub.GetColumnIndex(DefColumns.UpdateUser), true);
        }

        #endregion

        #region 6. Event

        private void spdMain_CellDoubleClick(object sender, CellClickEventArgs e)
        {

            if (siMain.ActiveSheet.Rows.Count <= 0)
                return;

            if (siMain.IsLock(siMain.SheetName))
            {
                if (!siSub.IsLock(siSub.ActiveSheet.SheetName))
                {
                    MessageHelper.GMessageBox("MSG00128", new object[] { siSub.ActiveSheet.SheetName });
                    return;
                }

                string sDivision = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                string sScmSite = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SiteId)).ToString();
                string sActive = cboActive.Text;

                siSub.ChangeSheet();

                if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)
                {
                    FindData_SubCustomer(sDivision, sScmSite, sActive);
                }
                else if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation)
                {
                    FindData_SubLocation(sDivision, sScmSite, sActive);
                }
                else if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubBucket)
                {
                    FindData_SubBucket(sDivision, sScmSite);
                }
            }
            else
            {
                                                                           
                                                                                                                             
                if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldToName)))
                {
                    string sDivisionId = string.Empty;
                    string sSoldToCode = string.Empty;
                    string sSoldToName = string.Empty;

                    if (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.Division)) != "")
                    {
                        sDivisionId = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Division)).ToString();
                    }

                    if (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.SoldToName)) != "")
                    {
                        sSoldToName = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SoldToName)).ToString();
                    }


                    siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.SoldTo), "");

                    SCM.PopUp.UIL.SCM0002_SoldtobyDivisionPopup popSoldto = new SCM.PopUp.UIL.SCM0002_SoldtobyDivisionPopup();

                    popSoldto.Form_Load(false, sDivisionId, sSoldToName);
                    popSoldto.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                    popSoldto.ShowDialog();

                    sSoldToCode = popSoldto.SoldtoCode;
                    sSoldToName = popSoldto.SoldtoName;

                    if (popSoldto.SoldtoCode != "")
                    {
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.SoldTo), sSoldToCode.TrimEnd());
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.SoldToName), sSoldToName.TrimEnd());
                    }
                }
                else if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.CountryName))
                        || siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.CityName)))
                {
                    string sCountry = string.Empty;
                    string sCity = string.Empty;
                    string sCountryName = string.Empty;
                    string sCityName = string.Empty;

                    if (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.CountryName)) != "")
                    {
                        sCountry = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.CountryName)).ToString();
                    }

                    if (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.CountryName)) != "")
                    {
                        sCity = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.CityName)).ToString();
                    }

                    SCM0002_CitybyCountry popCity = new SCM0002_CitybyCountry();
                    popCity.Form_Load(false, sCountry, sCity);
                    popCity.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                    popCity.ShowDialog();

                    sCountry = popCity.Country;
                    sCountryName = popCity.CountryName;
                    sCity = popCity.City;
                    sCityName = popCity.CityName;

                    if (popCity.Country != "")
                    {
                        msScmSite = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.SoldTo)) + "_" + sCity.Substring(0, 2) + "_" + sCity.Substring(2, 3);
                        if (msScmSite != "")
                        {
                            mbScmSite = true;
                        }

                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.Country), sCountry);
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.CountryName), sCountryName);
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.City), sCity);
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.CityName), sCityName);
                    }
                }
                else if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.TeamName)))
                {

                    string sTeamID = string.Empty;
                    string sTeamName = string.Empty;
                    string sDivisionID = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Division)).ToString();

                    if (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.Team)) != "")
                    {
                        sTeamID = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.Team)).ToString();
                    }

                    if (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.TeamName)) != "")
                    {
                        sTeamName = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.TeamName)).ToString();
                    }

                    SCM0002_TeamPopup popTeam = new SCM0002_TeamPopup();

                    popTeam.Form_Load(false, sTeamID, sTeamName);
                    popTeam.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                    popTeam.ShowDialog();

                    sTeamID = popTeam.TeamId;
                    sTeamName = popTeam.TeamtName;

                    if (popTeam.TeamId != "")
                    {
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.Team), sTeamID);
                        siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.TeamName), sTeamName);
                    }
                }
            }
        }

        private void cboDivision_SelectedIndexChanged(object sender, EventArgs e)
        {
                                                                        
            DataService.FP_Log2("SpeedUp", "DMF0004", "division_id_changed", "start");
            string sDivision = CString.GetCheckedListValue(dtDivision, cboDivision.ControlValues);
            string sTeam = string.Empty;                                                                   
            string sEndCustomer = string.Empty;

                                                                        
                                                                                                                                  
            SetChangeControl("UserTeamByDivision", sDivision);
            clsCtrl.setListBox(dtTeam, clbTeam, true);

            sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);

                                                                        
                                                                                                                                                           
            SetChangeControl("EndCustomerByDivision", sDivision, sTeam);
            clsCtrl.setListBox(dtEndCustomer, clbEndCustomer, true);

            sEndCustomer = CString.GetCheckedListValue(dtEndCustomer, clbEndCustomer.ControlValues);

            if ((sDivision.Substring(0, 2) == "81") || (sDivision == "82"))
            {
                                                                            
                                                                                                                                                            
                SetChangeControl("UserSiteByEndCustomer", sDivision, string.Empty, sEndCustomer);
                clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);

                lblTeam.Enabled = true;
                lblEndCustomer.Enabled = true;
            }
            else
            {
                                                                            
                                                                                                                                                   

                SetChangeControl("ScmSitebyEndCustomer40");
                clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);

                lblTeam.Enabled = false;
                lblEndCustomer.Enabled = false;
            }

                                                                        
            DataService.FP_Log2("SpeedUp", "DMF0004", "division_id_changed", "end");

            dtSoldToCustomer = GetSoldToCustomerData();                                                                                                            
            clsCtrl.setListBox(dtSoldToCustomer, clbSoldToCustomer, true);

            dtSoldTo = Data.Common(Data.Type.MyDivision, false, cboDivision.ControlValues);

            siMain.ActiveSheet.RowCount = 0;

            InitSpread(siMain);
        }

        private void SetGridHeader()
        {
                                                                                                                
            DataTable dt = Data.Common(Data.Type.SpreadTitle, false, "DMF0004", siMain.ActiveSheet.SheetName);
            string sDivGbn = string.Empty;

            if (cboDivision.ControlValues == "40")
            {
                for (int i = 0; i < dt.Rows.Count - 1; i++)
                {
                    sDivGbn = dt.Rows[i]["ATTRIBUTE1"].ToString();

                    if (sDivGbn == "81,82")
                    {
                        siMain.ActiveSheet.Columns[DefColumns.Team].Visible = false;
                        siMain.ActiveSheet.Columns[DefColumns.TeamName].Visible = false;
                        siMain.ActiveSheet.Columns[DefColumns.EndCustomer].Visible = false;
                    }
                }

                lblTeam.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
                lblEndCustomer.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
            }
            else
            {
                siMain.ActiveSheet.Columns[DefColumns.Team].Visible = true;
                siMain.ActiveSheet.Columns[DefColumns.TeamName].Visible = true;
                siMain.ActiveSheet.Columns[DefColumns.EndCustomer].Visible = true;

                lblTeam.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Always;
                lblEndCustomer.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Always;
            }
        }

        private void clbTeam_SelectedIndexChanged(object sender, EventArgs e)
        {
            string sDivision = CString.GetCheckedListValue(dtDivision, cboDivision.ControlValues);
            string sTeam = CString.GetCheckedListValue(dtTeam, clbTeam.ControlValues);

                                                                        
                                                                                                                                                           

            SetChangeControl("EndCustomerByDivision", sDivision, sTeam);
            clsCtrl.setListBox(dtEndCustomer, clbEndCustomer, true);

            string sEndCustomer = CString.GetCheckedListValue(dtEndCustomer, clbEndCustomer.ControlValues);

                                                                        
                                                                                                                                                        

            SetChangeControl("UserSiteByEndCustomer", sDivision, string.Empty, sEndCustomer);
            clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);

            dtSoldToCustomer = GetSoldToCustomerData();                                                                                                            
            clsCtrl.setListBox(dtSoldToCustomer, clbSoldToCustomer, true);
        }

        private void clbEndCustomer_SelectedIndexChanged(object sender, EventArgs e)
        {
            string sDivision = CString.GetCheckedListValue(dtDivision, cboDivision.ControlValues);
            string sEndCustomer = CString.GetCheckedListValue(dtEndCustomer, clbEndCustomer.ControlValues);

                                                                        
                                                                                                                                                        

            SetChangeControl("UserSiteByEndCustomer", sDivision, string.Empty, sEndCustomer);
            clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);
        }

        private void clbSoldToCustomer_SelectedIndexChanged(object sender, EventArgs e)
        {
            string sDivision = cboDivision.ControlValues;
                                                                  
            string sSoldToCustomer = clbSoldToCustomer.ControlValues;
            DataTable dtSalesSite = Data.SiteByEndCustomerSold(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sSoldToCustomer, clbSoldToCustomer.ControlValues);
            clsCtrl.setListBox(dtSalesSite, clbSalesSite, true);
        }
        private void spdMain_ComboSelChange(object sender, EditorNotifyEventArgs e)
        {
            string sDivision = CAppSetting.StringALL;
            string sTeam = CAppSetting.StringALL;
            string sEndCustomer = CAppSetting.StringALL;

            if (e.Column == siMain.GetColumnIndex(DefColumns.Division))
            {
                sDivision = siMain.GetValue(e.Row, e.Column).ToString();

                dtCustomer = Data.Common(Data.Type.EndCustomer, false, sDivision);

                siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.EndCustomer), dtCustomer);

                dtSoldTo = Data.Common(Data.Type.SoldCustomer, false, sDivision);
                siMain.SetCellTypeCombo(e.Row, siMain.GetColumnIndex(DefColumns.SoldTo), dtSoldTo);
            }
        }

        private void spdSub_ComboSelChange(object sender, EditorNotifyEventArgs e)
        {
            if (e.Column == siSub.GetColumnIndex(DefColumns.Division))
            {
                string sDivision = siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.Division)).ToString();

                dtDetailSalesSite = Data.Common(Data.Type.SaleSiteByDivision, false, sDivision);

                                                                                                                                  
                siSub.SetCellTypeCombo(e.Row, siSub.GetColumnIndex(DefColumns.SiteId), dtDetailSalesSite);
            }
        }
        private void spdSub_CellDoubleClick(object sender, CellClickEventArgs e)
        {
            if (!siSub.IsLock(siSub.SheetName))
            {
                if (siSub.GetText(e.Row, siSub.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting.StringI) return;

                siSub.ChangeSheet();
                if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)
                {
                    if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.SoldToCode))
                        || siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.ShipToCode)))
                    {
                        string sDivisionId = siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.Division)).ToString();
                        string sSoldToCode = siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.SoldToCode)).ToString();
                        string sShipToCode = siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.ShipToCode)).ToString();
                        string sShiptoRegion = siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.ShiptoRegionName)).ToString();
                        string sShiptoCity = siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.ShiptoCityName)).ToString();
                                                             
                                                             

                        SCM0002_CustomerbyDivisionPopup popCustomer = new SCM0002_CustomerbyDivisionPopup();

                        popCustomer.Form_Load(false, sDivisionId, sSoldToCode, sShipToCode);
                        popCustomer.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                        popCustomer.ShowDialog();

                                                                
                                                                
                                                                
                                                                

                        if (popCustomer.SoldToCode != "")
                        {
                            siSub.SetText(e.Row, siSub.GetColumnIndex(DefColumns.SoldToCode), popCustomer.SoldToCode);
                            siSub.SetText(e.Row, siSub.GetColumnIndex(DefColumns.SoldToDescription), popCustomer.SoldToDesc);
                            siSub.SetText(e.Row, siSub.GetColumnIndex(DefColumns.ShipToCode), popCustomer.ShipToCode);
                            siSub.SetText(e.Row, siSub.GetColumnIndex(DefColumns.ShipToDescription), popCustomer.ShipToDesc);
                            siSub.SetText(e.Row, siSub.GetColumnIndex(DefColumns.ShiptoRegionName), popCustomer.ShiptoRegion);
                            siSub.SetText(e.Row, siSub.GetColumnIndex(DefColumns.ShiptoCityName), popCustomer.ShiptoCity);
                        }
                    }
                }
                else if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation)
                {
                    if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.LocationCode)))
                    {
                        string sDivisionId = siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.Division)).ToString();
                        string sLocationCode = siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.LocationCode)).ToString();

                        SCM0002_StoragebyDivisionPopup popLocation = new SCM0002_StoragebyDivisionPopup();
                                                  
                        popLocation.Form_Load(false, sDivisionId, sLocationCode);
                        popLocation.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
                        popLocation.ShowDialog();

                                                                    
                                                                    

                        if (popLocation.StorageId != "")
                        {
                            siSub.SetText(e.Row, siSub.GetColumnIndex(DefColumns.LocationCode), popLocation.StorageId);
                            siSub.SetText(e.Row, siSub.GetColumnIndex(DefColumns.LocationDescription), popLocation.StorageDesc);

                            siSub.SetText(e.Row, siSub.GetColumnIndex(DefColumns.StorageId), popLocation.StorageId);
                            siSub.SetText(e.Row, siSub.GetColumnIndex(DefColumns.PlantId), popLocation.PlantId);
                        }
                    }
                }

            }
        }

        private void spdMain_EditChange(object sender, EditorNotifyEventArgs e)
        {
            if (e.Column == siMain.GetColumnIndex(DefColumns.TeamName))
            {
                siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.Team), "");
            }
            else if (e.Column == siMain.GetColumnIndex(DefColumns.CountryName))
            {
                siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.Country), "");
            }
            else if (e.Column == siMain.GetColumnIndex(DefColumns.CityName))
            {
                siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.City), "");
            }
        }

        private void spdSub_EditChange(object sender, EditorNotifyEventArgs e)
        {
            if (e.Column == siSub.GetColumnIndex(DefColumns.SoldToCode))
            {
                siSub.SetText(e.Row, siSub.GetColumnIndex(DefColumns.ShipToCode), "");
            }
        }

        private void spdSub_ActiveSheetChanging(object sender, ActiveSheetChangingEventArgs e)
        {
            if (!siSub.IsLock(siSub.ActiveSheet.SheetName))
            {
                e.ActivatedSheetIndex = siSub.ActiveSheetIndex;

                MessageHelper.GMessageBox("MSG00129", new object[] { siSub.ActiveSheet.SheetName });
                return;
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

        protected void shtSubCustomerDataModel_Changed(object sender, FarPoint.Win.Spread.Model.SheetDataModelEventArgs e)
        {
            switch (e.Type)
            {
                case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated:
                    string sColName = siSub.GetColumnTag(e.Column);

                    if (sColName == DefColumns.RepYn)
                    {
                        int iRepYnCnt = 0;
                        for (int iRow = 0; iRow <= siSub.GetMaxRowIndex(); iRow++)
                        {
                            if (siSub.GetText(iRow, e.Column) == CAppSetting.StringY)
                            {
                                iRepYnCnt++;
                            }
                        }

                        if (iRepYnCnt > 1)
                        {
                                                                                                        
                            MessageHelper.GMessageBox("MSG00149");
                            siSub.SetValue(e.Row, e.Column, "N");
                        }
                    }
                    else if (sColName == DefColumns.SoldToCode || sColName == DefColumns.ShipToCode)
                    {
                        string sSoldTo = siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.SoldToCode)).ToString();
                        string sShipTo = siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.ShipToCode)).ToString();
                        int iChkCnt = 0;

                        for (int iRow = 0; iRow <= siSub.GetMaxRowIndex(); iRow++)
                        {
                            if (sShipTo == siSub.GetValue(iRow, siSub.GetColumnIndex(DefColumns.ShipToCode)).ToString() &&
                                sSoldTo == siSub.GetValue(iRow, siSub.GetColumnIndex(DefColumns.SoldToCode)).ToString())
                            {
                                iChkCnt++;
                            }

                            if ((iChkCnt > 1) && (siSub.GetValue(iRow, siSub.GetColumnIndex(DefColumns.ValidYn)).ToString() == "Y"))
                            {
                                string args = string.Format("{0}", MessageHelper.GetTerm(DefColumnLabels.SoldToCode) + ", " + MessageHelper.GetTerm(DefColumnLabels.ShipToCode));

                                                      
                                MessageHelper.GMessageBox("MSG00060", new object[] { args });

                                siSub.SetValue(e.Row, siSub.GetColumnIndex(DefColumns.SoldToCode), "");
                                siSub.SetValue(e.Row, siSub.GetColumnIndex(DefColumns.SoldToDescription), "");
                                siSub.SetValue(e.Row, siSub.GetColumnIndex(DefColumns.ShipToCode), "");
                                siSub.SetValue(e.Row, siSub.GetColumnIndex(DefColumns.ShipToDescription), "");

                                break;
                            }
                        }
                    }
                    break;
            }
        }

        protected void shtSubBucketDataModel_Changed(object sender, FarPoint.Win.Spread.Model.SheetDataModelEventArgs e)
        {
            switch (e.Type)
            {
                case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated:
                    string sColName = siSub.GetColumnTag(e.Column);

                    if (sColName.IndexOf("D_") == 0)
                    {
                        string sDivisionId = string.Empty; siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.Division)).ToString();
                        string sSalesSiteId = string.Empty;
                        string sIncoterms = string.Empty;
                        string sYYYYMMDD = string.Empty;
                        string sBucketPer = string.Empty;
                        string sConversionType = "WTOD";

                        if (siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.Division)) != "")
                        {
                            sDivisionId = siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.Division)).ToString();
                        }

                        if (siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.SiteId)) != "")
                        {
                            sSalesSiteId = siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.SiteId)).ToString();
                        }

                        if (siSub.GetText(e.Row, siSub.GetColumnIndex(DefColumns.Incoterms)) != "")
                        {
                            sIncoterms = siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.Incoterms)).ToString();
                        }

                        sYYYYMMDD = sColName.Replace("D_", "");
                        sBucketPer = siSub.GetText(e.Row, e.Column);

                        if (sDivisionId == "")
                        {
                            MessageHelper.GMessageBox("MSG00002", new object[] { DefColumnLabels.Division });
                            return;
                        }

                        if (sSalesSiteId == "")
                        {
                            MessageHelper.GMessageBox("MSG00002", new object[] { DefColumnLabels.SiteId });
                            return;
                        }

                        if (sIncoterms == "")
                        {
                            MessageHelper.GMessageBox("MSG00002", new object[] { DefColumnLabels.Incoterms });
                            return;
                        }

                                          
                        SetSubBucketData(sDivisionId, sSalesSiteId, sIncoterms, sYYYYMMDD, sBucketPer, sConversionType);
                    }
                    else if (sColName == DefColumns.Incoterms)
                    {
                        string sDivisionID = siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.Division)).ToString();
                        string sScmSiteID = siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.SiteId)).ToString();
                        string sIncoterms = siSub.GetValue(e.Row, siSub.GetColumnIndex(DefColumns.Incoterms)).ToString();
                        int iChkCnt = 0;

                        for (int iRow = 0; iRow <= siSub.GetMaxRowIndex(); iRow++)
                        {
                            if (sDivisionID == siSub.GetValue(iRow, siSub.GetColumnIndex(DefColumns.Division)).ToString()
                                && sScmSiteID == siSub.GetValue(iRow, siSub.GetColumnIndex(DefColumns.SiteId)).ToString()
                                && sIncoterms == siSub.GetValue(iRow, siSub.GetColumnIndex(DefColumns.Incoterms)).ToString())
                            {
                                iChkCnt++;
                            }

                            if (iChkCnt > 1)
                            {
                                string args = string.Format("{0}, {1}, {2}"
                                        , MessageHelper.GetTerm(DefColumnLabels.Division)
                                        , MessageHelper.GetTerm(DefColumnLabels.SiteId)
                                        , MessageHelper.GetTerm(DefColumnLabels.Incoterms)
                                        );

                                                                       
                                MessageHelper.GMessageBox("MSG00060", new object[] { args });

                                siSub.SetValue(e.Row, siSub.GetColumnIndex(DefColumns.Incoterms), "");

                                break;
                            }
                        }
                    }

                    break;
            }
        }

        private void SetSubBucketData(string sDivisionId, string sSalesSiteId, string sIncoterms, string sYYYYMMDD, string sBucketPer, string sConversionType)
        {
            string sFilter = DefColumns.Division + "= '" + sDivisionId + "'";
            sFilter += " and " + DefColumns.SiteId + " = '" + sSalesSiteId + "'";
            sFilter += " and " + DefColumns.Incoterms + " = '" + sIncoterms + "'";
            sFilter += " and " + DefColumns.YYYYMMDD + " = '" + sYYYYMMDD + "'";
            ;

            DataRow[] drFind = dtSubBucket.Select(sFilter);

            if (drFind.Length == 0)
            {
                DataRow drNew = dtSubBucket.NewRow();
                drNew[DefColumns.Division] = sDivisionId;
                drNew[DefColumns.SiteId] = sSalesSiteId;
                drNew[DefColumns.Incoterms] = sIncoterms;
                drNew[DefColumns.YYYYMMDD] = sYYYYMMDD;
                drNew[DefColumns.BucketPer] = sBucketPer;
                drNew[DefColumns.ConversionType] = sConversionType;

                dtSubBucket.Rows.Add(drNew);
                dtSubBucket.AcceptChanges();
            }
            else
            {
                drFind[0][DefColumns.BucketPer] = sBucketPer;
                dtSubBucket.AcceptChanges();
            }
        }

        protected void shtMainDataModel_Changed(object sender, FarPoint.Win.Spread.Model.SheetDataModelEventArgs e)
        {
            switch (e.Type)
            {
                case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated:
                                                                      

                    if (e.Column == siMain.GetColumnIndex(DefColumns.SoldTo)
                       || e.Column == siMain.GetColumnIndex(DefColumns.Country)
                       || e.Column == siMain.GetColumnIndex(DefColumns.City))
                    {
                        if (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.SoldTo)) != ""
                            && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.Country)).ToString() != ""
                            && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.City)).ToString() != "")
                        {
                            string sScmSite = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.SoldTo))
                                              + "_" + siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.City)).Substring(0, 2)
                                              + "_" + siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.City)).Substring(2, 3);

                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.SiteId), sScmSite);
                        }
                    }
                    else if (e.Column == siMain.GetColumnIndex(DefColumns.SiteId))
                    {
                        int iChkCount = 0;

                        string sScmSite = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.SiteId));

                        if (mbScmSite == true)
                        {
                            sScmSite = msScmSite;
                            mbScmSite = false;
                        }

                        for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++)
                        {
                            if (sScmSite == siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.SiteId)))
                            {
                                iChkCount++;

                                if (iChkCount > 1)
                                {
                                    string args = string.Format("{0}, {1}"
                                        , MessageHelper.GetTerm(DefColumnLabels.Division)
                                        , MessageHelper.GetTerm(DefColumnLabels.SiteId)
                                        );

                                                                           
                                    MessageHelper.GMessageBox("MSG00060", new object[] { args });

                                    siMain.SetValue(e.Row, siMain.GetColumnIndex(DefColumns.SiteId), "");

                                    break;
                                }
                            }
                        }
                    }
                    else if (e.Column == siMain.GetColumnIndex(DefColumns.CountryName))
                    {
                        if (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.CountryName)) == "")
                        {
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.Country), "");
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.SiteId), "");
                        }
                    }
                    else if (e.Column == siMain.GetColumnIndex(DefColumns.CityName))
                    {
                        if (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.CityName)) == "")
                        {
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.City), "");
                            siMain.SetText(e.Row, siMain.GetColumnIndex(DefColumns.SiteId), "");
                        }
                    }
                    else if (e.Column == siMain.GetColumnIndex(DefColumns.Attribute5)
                         && siMain.GetColumnIndex(DefColumns.Attribute5) != -1)
                    {
                        if (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.VmiYn)).ToUpper() != "Y"
                            && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.Attribute5)) != "")
                        {
                            MessageHelper.GMessageBox("VMI Site 에만 입력할 수 있습니다.");
                            siMain.SetValue(e.Row, siMain.GetColumnIndex(DefColumns.Attribute5), "");
                            break;
                        }
                    }
                    break;
            }
        }

        private void chkDetail_CheckedChanged(object sender, EventArgs e)
        {
            splitContainer1.Panel2Collapsed = !chkDetail.Checked;
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

                        
        private DataTable GetSpdTitle(string sheetname)
        {
            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                DataTable dt = null;

                var request = new FoxDataRequest("DM.DMF0000_GET_COMMON_SPREAD_TITLE");
                request.Parameters["p_start_yyyymmdd"] = "";
                request.Parameters["p_end_yyyymmdd"] = "";
                request.Parameters["p_created_by"] = base.UserInfo.UserId;
                                                                       
                request.Parameters["p_program_id"] = "DMF0004";
                request.Parameters["p_sheet_name"] = sheetname;
                request.Parameters["p_division_id"] = cboDivision.SelectedValue;               

                dt = client.ExecuteDataSet(request).DataSet.Tables[0];

                return dt;
            }
        }

        private DataTable GetPlantbyDivision(string sDivision)
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sScmBinding))
            {
                var request = new FoxDataRequest("SCM.SCM0001_GET_PLANT_BY_DIVISION");
                request.Parameters["p_division_id"] = sDivision;
                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }

            return dt;
        }

        private DataTable GetSoldToCustomerData()
        {
            DataTable dt = null;

            using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding))
            {
                var request = new FoxDataRequest("DM.DMF0004_GET_SOLDTO_CUSTOMER_DATA");
                request.Parameters["p_division_id"] = cboDivision.ControlValues;
                request.Parameters["p_dept_id"] = clbTeam.ControlValues;
                dt = client.ExecuteDataSet(request).DataSet.Tables[0];
            }

            return dt;
        }

        private void DM0004_SalesSiteTest99_Load(object sender, EventArgs e)
        {

        }

    }
}
