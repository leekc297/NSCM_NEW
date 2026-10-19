using System;
namespace Trap
{
    public class TRP0001_Trap : BaseForm
    {
        private const string NS = "DM.";
        private static string sheet = "SUMMARY";
        void A()
        {
            var u1 = "http://x//y";                                   // 문자열 안의 // 는 주석 아님
            var r1 = new FoxDataRequest("DM.T_ACTIVE_1");              // ACTIVE
            var s2 = "/* not a comment */"; var r2 = new FoxDataRequest(NS + "T_ACTIVE_2"); // ACTIVE (상수 연결)
            var v = @"C:\a\b"" // still string"; var r3 = new FoxDataRequest($"{NS}T_ACTIVE_3"); // ACTIVE (보간)
            // var c1 = new FoxDataRequest("DM.T_COMMENT_1");          COMMENTED
            //    // var c2 = new FoxDataRequest("DM.T_COMMENT_2");    COMMENTED (중첩)
            ////var c3 = new FoxDataRequest("DM.T_COMMENT_3");          COMMENTED (////)
            /* var c4 = new FoxDataRequest("DM.T_COMMENT_4");
               var c5 = new FoxDataRequest("DM.T_COMMENT_5"); */
#if DEBUG
            var d1 = new FoxDataRequest("DM.T_INACTIVE_1");           // INACTIVE (Release 기준)
#else
            var d2 = new FoxDataRequest("DM.T_ACTIVE_4");             // ACTIVE (#else)
#endif
            string p = "DM.T_ACTIVE_5"; if (sheet == "X") p = "DM.T_ACTIVE_6";
            var r5 = new FoxDataRequest(p);                            // ACTIVE 2 후보
            Run("T_ACTIVE_7");
        }
        void Run(string id) { var r = new FoxDataRequest("DM." + id); } // TEMPLATE → 호출지점에서 ACTIVE_7

        // 이벤트 배선 vs 산술 복합대입 함정
        int sum_week; int i;
        void Wire()
        {
            this.btnOk.Click += new System.EventHandler(this.btnOk_Click);   // EVENT_1: 델리게이트 생성 → 이벤트
            this.spdMain.CellClick += spdMain_CellClick;                      // EVENT_2: 메서드 그룹 → 이벤트
            sum_week += 3;                                                    // NOT_EVENT_1: 산술
            i += dtMeasure.Rows.Count;                                        // NOT_EVENT_2: 산술
            this.Total += i;                                                  // NOT_EVENT_3: 멤버 산술 (RHS 가 메서드 아님)
        }
        void btnOk_Click(object s, System.EventArgs e) { }
        void spdMain_CellClick(object s, object e) { }
    }
}
