// AsisLive.Host — AS-IS GSCM 런처를 프로세스 안에서 구동하는 호스트 (2026-11-12 · 승인 플랜 velvet-conjuring-lake P0)
//   · Program.Main 과 똑같이 ApplicationStart.Run() 을 부르되, 그 전에 명령 처리 스레드를 띄운다.
//   · AS-IS 소스·csproj 는 수정하지 않는다. 모든 접근은 리플렉션(컴파일 시 GSCM/DevExpress/FarPoint 참조 없음).
//   · 명령: <cmddir>\NNN.req (첫 줄 = 명령, 이후 key=value) → <cmddir>\NNN.res.json
//   · 비밀번호는 읽지도 입력하지도 않는다(login = 로그인 창의 OK 버튼만 누름).
using System;
using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;
using System.Web.Script.Serialization;
using System.Windows.Forms;

static class AsisLiveHost
{
    static string cmdDir;
    static readonly List<Dictionary<string, object>> dialogs = new List<Dictionary<string, object>>();
    static readonly object dlgLock = new object();
    static volatile string dialogPolicy = "default"; // default = 기본 버튼 · hold = 누르지 않고 기록만
    const BindingFlags BF = BindingFlags.Instance | BindingFlags.Static | BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.FlattenHierarchy;

    [STAThread]
    static int Main(string[] args)
    {
        for (int i = 0; i < args.Length - 1; i++) if (args[i] == "--cmddir") cmdDir = args[i + 1];
        if (string.IsNullOrEmpty(cmdDir)) { MessageBox.Show("usage: AsisLive.Host.exe --cmddir <dir>"); return 2; }
        Directory.CreateDirectory(cmdDir);
        new Thread(AgentLoop) { IsBackground = true, Name = "AsisLive.Agent" }.Start();
        new Thread(DialogLoop) { IsBackground = true, Name = "AsisLive.Dialogs" }.Start();
        try
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Assembly asm = Assembly.Load("GSCM.Windows.Forms");
            object start = Activator.CreateInstance(asm.GetType("GSCM.Windows.Forms.ApplicationStart", true));
            start.GetType().GetMethod("Run", Type.EmptyTypes).Invoke(start, null);
        }
        catch (Exception ex)
        {
            File.WriteAllText(Path.Combine(cmdDir, "_host_error.txt"), ex.ToString(), Encoding.UTF8);
            return 1;
        }
        return 0;
    }

    // ───────────────────────── 명령 루프 ─────────────────────────
    static void AgentLoop()
    {
        var js = new JavaScriptSerializer { MaxJsonLength = int.MaxValue, RecursionLimit = 64 };
        File.WriteAllText(Path.Combine(cmdDir, "_ready.txt"), DateTime.Now.ToString("o"));
        while (true)
        {
            try
            {
                string req = Directory.GetFiles(cmdDir, "*.req").OrderBy(f => f).FirstOrDefault();
                if (req == null) { Thread.Sleep(150); continue; }
                string[] lines; try { lines = File.ReadAllLines(req, Encoding.UTF8); } catch { Thread.Sleep(100); continue; }
                var a = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
                foreach (var l in lines.Skip(1)) { int k = l.IndexOf('='); if (k > 0) a[l.Substring(0, k).Trim()] = l.Substring(k + 1); }
                string cmd = lines.Length > 0 ? lines[0].Trim() : "";
                var res = new Dictionary<string, object> { { "cmd", cmd }, { "at", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff") } };
                try { Exec(cmd, a, res); if (!res.ContainsKey("ok")) res["ok"] = true; }
                catch (Exception ex) { var e = ex is TargetInvocationException && ex.InnerException != null ? ex.InnerException : ex; res["ok"] = false; res["error"] = e.GetType().Name + ": " + e.Message; }
                res["done"] = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff");
                string outp = Path.ChangeExtension(req, ".res.json");
                File.WriteAllText(outp + ".tmp", js.Serialize(res), new UTF8Encoding(false));
                File.Delete(req);
                if (File.Exists(outp)) File.Delete(outp);
                File.Move(outp + ".tmp", outp);
                if (cmd == "quit") { Thread.Sleep(200); Environment.Exit(0); }
            }
            catch { Thread.Sleep(300); }
        }
    }

    static int Int(Dictionary<string, string> a, string k, int d) { string v; int n; return a.TryGetValue(k, out v) && int.TryParse(v, out n) ? n : d; }
    static string Str(Dictionary<string, string> a, string k, string d) { string v; return a.TryGetValue(k, out v) ? v : d; }

    static void Exec(string cmd, Dictionary<string, string> a, Dictionary<string, object> res)
    {
        switch (cmd)
        {
            case "ping": res["pid"] = System.Diagnostics.Process.GetCurrentProcess().Id; res["forms"] = FormNames(); break;
            case "policy": dialogPolicy = Str(a, "dialogs", "default"); res["dialogs"] = dialogPolicy; break;
            case "login": Login(a, res); break;
            case "wait_main": WaitMain(a, res); break;
            case "open": Open(a, res); break;
            case "find": Find(a, res); break;
            case "wait_idle": WaitIdle(a, res); break;
            case "dump": Dump(a, res); break;
            case "shot": Shot(a, res); break;
            case "set": SetValue(a, res); break;
            case "popup_pick": PopupPick(a, res); break;
            case "group": Group(a, res); break;
            case "act": Act(a, res); break;
            case "sweep": Sweep(a, res); break;
            case "cell": Cell(a, res); break;
            case "keyinput": KeyInput(a, res); break;
            case "cellstate": CellState(a, res); break;
            case "popup_ok": PopupOk(a, res); break;
            case "maximize": { var mf = MainForm(); if (mf == null) throw new InvalidOperationException("main form not ready"); res["state"] = OnUi(mf, () => { mf.WindowState = FormWindowState.Maximized; return mf.WindowState.ToString(); }); Thread.Sleep(800); res["size"] = OnUi(mf, () => mf.Width + "x" + mf.Height); break; }
            case "dialogs": { int from = Int(a, "from", 0); lock (dlgLock) res["dialogs"] = dialogs.Skip(from).ToList(); break; }
            case "menu": { var mf = MainForm(); if (mf == null) throw new InvalidOperationException("main form not ready");
                res["items"] = OnUi(mf, () => { var l = new List<object>(); var e = Get(mf, "GSCMMenuItem") as IEnumerable; if (e != null) foreach (var x in e) l.Add(new Dictionary<string, object> { { "program_id", S(Get(x, "ProgramId")) }, { "menu_id", S(Get(x, "Id")) }, { "title", S(Get(x, "Title")) }, { "url", S(Get(x, "Url")) }, { "class_name", S(Get(x, "ClassName")) }, { "path", S(Get(x, "NavigatePath")) } }); return l; }); break; }
            case "close_screen": { var mf = MainForm(); if (mf == null) throw new InvalidOperationException("main form not ready");
                bool to; int left = OnUi(mf, () => { foreach (var c in mf.MdiChildren.ToArray()) { try { c.Close(); } catch { } } return mf.MdiChildren.Length; }, Int(a, "timeout", 30) * 1000, out to);
                res["close_timed_out"] = to; Thread.Sleep(500); res["open_screens"] = to ? -1 : OnUi(mf, () => mf.MdiChildren.Length); break; }
            case "quit": break;
            default: throw new ArgumentException("unknown command: " + cmd);
        }
        lock (dlgLock) res["dialog_count"] = dialogs.Count;
    }

    // ───────────────────────── UI 스레드 실행 도우미 ─────────────────────────
    static Form[] OpenFormsSnapshot() { try { return Application.OpenForms.Cast<Form>().ToArray(); } catch { return new Form[0]; } }
    static List<string> FormNames() { return OpenFormsSnapshot().Select(f => f.GetType().Name).ToList(); }
    static Form FindForm(string typeName) { return OpenFormsSnapshot().FirstOrDefault(f => f.GetType().Name == typeName && f.IsHandleCreated); }
    static Form MainForm()
    {
        var t = Type.GetType("GSCM.Windows.Forms.GSCM_MainForm, GSCM.Windows.Forms", false);
        if (t == null) return null;
        var f = t.GetField("Instance", BF); var m = f == null ? null : f.GetValue(null) as Form;
        return m != null && m.IsHandleCreated ? m : null;
    }
    // UI 스레드에서 실행하고 timeoutMs 안에 끝나지 않으면 timedOut=true (모달 대화상자에 막힌 경우)
    static T OnUi<T>(Control c, Func<T> fn, int timeoutMs, out bool timedOut)
    {
        T val = default(T); Exception err = null; var done = new ManualResetEvent(false);
        c.BeginInvoke((MethodInvoker)delegate { try { val = fn(); } catch (Exception ex) { err = ex; } finally { done.Set(); } });
        timedOut = !done.WaitOne(timeoutMs);
        if (err != null) throw err;
        return val;
    }
    static T OnUi<T>(Control c, Func<T> fn) { bool to; var v = OnUi(c, fn, 60000, out to); if (to) throw new TimeoutException("UI thread busy (modal dialog?)"); return v; }
    static object Get(object o, string name)
    {
        if (o == null) return null;
        for (var t = o.GetType(); t != null; t = t.BaseType)
        {
            var p = t.GetProperty(name, BF | BindingFlags.DeclaredOnly, null, null, Type.EmptyTypes, null); if (p != null) { try { return p.GetValue(o, null); } catch { return null; } }
            var f = t.GetField(name, BF | BindingFlags.DeclaredOnly); if (f != null) return f.GetValue(o);
        }
        return null;
    }
    static object Call(object o, string name, params object[] args)
    {
        var ms = o.GetType().GetMethods(BF).Where(m => m.Name == name && m.GetParameters().Length == args.Length).ToArray();
        foreach (var m in ms)
        {
            var ps = m.GetParameters(); bool ok = true;
            for (int i = 0; i < ps.Length; i++) if (args[i] != null && !ps[i].ParameterType.IsInstanceOfType(args[i])) { ok = false; break; }
            if (ok) return m.Invoke(o, args);
        }
        throw new MissingMethodException(o.GetType().Name + "." + name + "/" + args.Length);
    }
    static string S(object o) { return o == null ? null : Convert.ToString(o); }

    // ───────────────────────── 명령 구현 ─────────────────────────
    static void Login(Dictionary<string, string> a, Dictionary<string, object> res)
    {
        int timeout = Int(a, "timeout", 60); var until = DateTime.Now.AddSeconds(timeout); Form lf = null;
        while (DateTime.Now < until && (lf = FindForm("LogInForm")) == null) { if (MainForm() != null) { res["note"] = "main already open"; return; } Thread.Sleep(200); }
        if (lf == null) throw new TimeoutException("LogInForm not shown");
        Thread.Sleep(500);
        // 2026-11-24: 실측 계정 지정(user=). 로그인 창에 남은 마지막 ID(예 WJDF = Guest, 메뉴 5개)로 들어가 실측 대상이 0개가 된 사고 방지
        string want = Str(a, "user", "");
        res["prevUserId"] = OnUi(lf, () => { var c = lf.Controls.Find("txtUserID", true).FirstOrDefault(); return c == null ? null : c.Text; });
        if (want != "") OnUi<object>(lf, () => { var c = lf.Controls.Find("txtUserID", true).FirstOrDefault(); if (c == null) throw new InvalidOperationException("txtUserID not found"); c.Text = want; return null; });
        res["userId"] = OnUi(lf, () => { var c = lf.Controls.Find("txtUserID", true).FirstOrDefault(); return c == null ? null : c.Text; });
        bool to;
        OnUi<object>(lf, () => { var b = lf.Controls.Find("btnOK", true).FirstOrDefault(); if (b == null) throw new InvalidOperationException("btnOK not found"); Call(b, "PerformClick"); return null; }, timeout * 1000, out to);
        res["click_timed_out"] = to;
    }

    static void WaitMain(Dictionary<string, string> a, Dictionary<string, object> res)
    {
        int timeout = Int(a, "timeout", 180); var until = DateTime.Now.AddSeconds(timeout); Form m = null;
        while (DateTime.Now < until) { m = MainForm(); if (m != null && m.Visible) break; m = null; Thread.Sleep(300); }
        if (m == null) throw new TimeoutException("main form not ready; forms=" + string.Join(",", FormNames()));
        Thread.Sleep(Int(a, "settle", 3) * 1000);
        var mm = m;
        res["title"] = OnUi(mm, () => mm.Text);
        res["user"] = OnUi(mm, () => S(Get(Get(mm, "tsLblUser"), "Text")));
        res["menu_count"] = OnUi(mm, () => { var l = Get(mm, "GSCMMenuItem") as IEnumerable; int n = 0; if (l != null) foreach (var x in l) n++; return n; });
    }

    static void Open(Dictionary<string, string> a, Dictionary<string, object> res)
    {
        string id = Str(a, "id", ""); if (id == "") throw new ArgumentException("id required");
        int timeout = Int(a, "timeout", 120); var m = MainForm(); if (m == null) throw new InvalidOperationException("main form not ready");
        bool known = OnUi(m, () => { var l = Get(m, "GSCMMenuItem") as IEnumerable; if (l != null) foreach (var x in l) if (S(Get(x, "ProgramId")) == id) return true; return false; });
        res["in_menu"] = known;
        if (!known) throw new InvalidOperationException("ProgramID not in this user's menu: " + id);
        int before = OnUi(m, () => m.MdiChildren.Length);
        bool to; OnUi<object>(m, () => { Call(m, "OpenUserMenu", id); return null; }, timeout * 1000, out to);
        res["open_timed_out"] = to;
        var until = DateTime.Now.AddSeconds(timeout); Form child = null;
        while (DateTime.Now < until)
        {
            child = OnUi(m, () => m.ActiveMdiChild);
            if (child != null && OnUi(m, () => m.MdiChildren.Length) > before) break;
            if (child != null && before > 0 && OnUi(m, () => child.GetType().Name).StartsWith(id, StringComparison.OrdinalIgnoreCase)) break;
            child = null; Thread.Sleep(300);
        }
        if (child == null) throw new TimeoutException("screen not opened: " + id);
        Thread.Sleep(Int(a, "settle", 3) * 1000);
        var ch = child;
        res["form_type"] = ch.GetType().FullName; res["form_text"] = OnUi(m, () => ch.Text); res["assembly"] = ch.GetType().Assembly.Location;
    }

    static void Find(Dictionary<string, string> a, Dictionary<string, object> res)
    {
        var m = MainForm(); if (m == null) throw new InvalidOperationException("main form not ready");
        var child = OnUi(m, () => m.ActiveMdiChild); if (child == null) throw new InvalidOperationException("no active screen");
        // 완료 신호 = 상태바 tsLblTimeStatus 가 다시 채워짐 (조회 전 비운다)
        OnUi<object>(m, () => { var l = Get(m, "tsLblTimeStatus") as ToolStripItem; if (l != null) l.Text = ""; var s = Get(m, "tsLblSum") as ToolStripItem; if (s != null) s.Text = ""; return null; });
        bool to; OnUi<object>(m, () => { Call(child, "OnClickFindButton"); return null; }, Int(a, "timeout", 30) * 1000, out to);
        res["call_timed_out"] = to;
    }

    static void WaitIdle(Dictionary<string, string> a, Dictionary<string, object> res)
    {
        var m = MainForm(); if (m == null) throw new InvalidOperationException("main form not ready");
        int timeout = Int(a, "wait", Int(a, "timeout", 200)); var until = DateTime.Now.AddSeconds(timeout); string ts = "";
        while (DateTime.Now < until)
        {
            bool to; ts = OnUi(m, () => S(Get(Get(m, "tsLblTimeStatus"), "Text")) ?? "", 2000, out to);
            if (!to && !string.IsNullOrEmpty(ts)) break;
            Thread.Sleep(400);
        }
        res["time_status"] = ts; res["signaled"] = !string.IsNullOrEmpty(ts);
        if (!string.IsNullOrEmpty(ts)) { Thread.Sleep(800); res["total"] = OnUi(m, () => S(Get(Get(m, "tsLblSum"), "Text"))); }
    }

    static void Shot(Dictionary<string, string> a, Dictionary<string, object> res)
    {
        string path = Str(a, "path", ""); if (path == "") throw new ArgumentException("path required");
        var m = MainForm(); Form target = m ?? OpenFormsSnapshot().FirstOrDefault(); if (target == null) throw new InvalidOperationException("no window");
        IntPtr h = OnUi(target, () => target.Handle);
        RECT r; GetWindowRect(h, out r); int w = r.Right - r.Left, hgt = r.Bottom - r.Top; if (w <= 0 || hgt <= 0) throw new InvalidOperationException("window has no size");
        using (var bmp = new Bitmap(w, hgt, PixelFormat.Format32bppArgb))
        {
            bool ok;
            using (var g = Graphics.FromImage(bmp)) { IntPtr dc = g.GetHdc(); ok = PrintWindow(h, dc, 2); g.ReleaseHdc(dc); }
            res["method"] = ok ? "PrintWindow" : "PrintWindow(false)";
            Directory.CreateDirectory(Path.GetDirectoryName(path)); bmp.Save(path, ImageFormat.Png);
        }
        res["path"] = path; res["width"] = w; res["height"] = hgt;
    }

    static void SetValue(Dictionary<string, string> a, Dictionary<string, object> res)
    {
        var m = MainForm(); var child = Target(m, a); if (child == null) throw new InvalidOperationException("no active screen");
        string name = Str(a, "name", ""), value = Str(a, "value", "");
        res["applied"] = OnUi(m, () =>
        {
            var c = child.Controls.Find(name, true).FirstOrDefault(); if (c == null) throw new InvalidOperationException("control not found: " + name);
            // 2026-11-12 2차(필수 조건 채움): prop = 속성 직접 지정 · index = 콤보 순번 · check = 체크 목록 순번 · call = 화면 메서드(sender,e) 호출
            string prop = Str(a, "prop", ""), sIndex = Str(a, "index", ""), sCheck = Str(a, "check", ""), call = Str(a, "call", "");
            if (call != "")
            {
                var mi = child.GetType().GetMethod(call, BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic); if (mi == null) throw new InvalidOperationException("method not found: " + call);
                var ps = mi.GetParameters(); mi.Invoke(child, ps.Length == 0 ? null : ps.Length == 2 ? new object[] { c, EventArgs.Empty } : new object[ps.Length]); return "call:" + call;
            }
            if (prop != "")
            {
                var pi = c.GetType().GetProperty(prop, BindingFlags.Instance | BindingFlags.Public); if (pi == null || !pi.CanWrite) throw new InvalidOperationException("property not writable: " + prop);
                object v; var pt = Nullable.GetUnderlyingType(pi.PropertyType) ?? pi.PropertyType;
                if (pt == typeof(DateTime)) v = DateTime.ParseExact(value, value.Length == 8 ? "yyyyMMdd" : "yyyy-MM-dd", System.Globalization.CultureInfo.InvariantCulture);
                else if (pt == typeof(string) || pt == typeof(object)) v = value;
                else if (pt == typeof(bool)) v = value == "1" || value.Equals("true", StringComparison.OrdinalIgnoreCase);
                else v = Convert.ChangeType(value, pt, System.Globalization.CultureInfo.InvariantCulture);
                pi.SetValue(c, v, null); return "prop:" + prop;
            }
            if (sCheck != "")
            {
                CheckedListBox lb = c as CheckedListBox;
                if (lb == null) { var st = new Stack<Control>(); st.Push(c); while (st.Count > 0 && lb == null) { var x = st.Pop(); foreach (Control k in x.Controls) { lb = k as CheckedListBox; if (lb != null) break; st.Push(k); } } }
                if (lb == null) throw new InvalidOperationException("checked list not found in: " + name);
                int ci = int.Parse(sCheck); if (ci < 0 || ci >= lb.Items.Count) throw new InvalidOperationException("check index out of range: " + ci + "/" + lb.Items.Count);
                if (Str(a, "only", "") == "1") for (int q = 0; q < lb.Items.Count; q++) if (q != ci && lb.GetItemChecked(q)) lb.SetItemChecked(q, false);   // only=1 → 이 항목만 체크
                lb.SetItemChecked(ci, true); return "check:" + ci + ":" + lb.GetItemText(lb.Items[ci]);
            }
            var cb = c as ComboBox;
            if (cb != null && sIndex != "") { int ix = int.Parse(sIndex); if (ix < 0) ix = cb.Items.Count + ix; if (ix < 0 || ix >= cb.Items.Count) throw new InvalidOperationException("combo index out of range: " + sIndex + "/" + cb.Items.Count); cb.SelectedIndex = ix; return "combo:" + ix + ":" + cb.GetItemText(cb.Items[ix]); }
            if (cb != null) { for (int i = 0; i < cb.Items.Count; i++) if (cb.GetItemText(cb.Items[i]) == value) { cb.SelectedIndex = i; return "combo:" + i; } throw new InvalidOperationException("combo item not found: " + value); }
            var chk = c as CheckBox; if (chk != null) { chk.Checked = value == "1" || value.Equals("true", StringComparison.OrdinalIgnoreCase); return "check"; }
            c.Text = value; return "text";
        });
    }

    // 2026-11-12 2차: 선택 팝업(Version 등)을 화면의 여는 메서드로 실제로 띄우고, 팝업이 불러온 목록의 맨 위 행을 선택해 닫는다.
    //   팝업의 조회 조건·정렬은 팝업 기본값 그대로(사용자가 팝업을 열어 첫 행을 고른 것과 같은 경로). 고른 값·위 5행을 돌려준다.
    // 2026-11-15: grid(스프레드 이름)·sheet(시트 번호)를 주면 그 그리드의 그 시트를 활성으로 바꾼다(사용자가 시트 탭을 누른 것과 같은 ActiveSheetIndex 변경). 없으면 첫 그리드·현재 시트
    static Control PickSpread(Control root, Dictionary<string, string> a)
    {
        string gn = Str(a, "grid", ""); Control spd = gn == "" ? FindSpread(root) : root.Controls.Find(gn, true).FirstOrDefault();
        if (spd == null) return null;
        string si = Str(a, "sheet", "");
        if (si != "") { int ix = int.Parse(si); var pi = spd.GetType().GetProperty("ActiveSheetIndex"); if (pi != null && Convert.ToInt32(pi.GetValue(spd, null)) != ix) pi.SetValue(spd, ix, null); }
        return spd;
    }
    static Control FindSpread(Control root)
    {
        foreach (Control k in root.Controls)
        {
            for (var t = k.GetType(); t != null; t = t.BaseType) if (t.Name == "FpSpread") return k;
            var x = FindSpread(k); if (x != null) return x;
        }
        return null;
    }
    // 2026-11-13 P6-3: 메인 화면의 그룹(권한) 콤보를 읽고 바꾼다. 바꾸면 런처가 확인 창(MSG00309)을 띄우고 화면을 모두 닫은 뒤 메뉴를 다시 불러온다
    //   (GSCM_MainForm.UsrCmbMyGroupID_SelectedIndexChanged) — 사용자가 콤보에서 그룹을 바꾼 것과 같은 경로. value 없으면 읽기만.
    // 2026-11-13 P6-2 보정: 팝업이 닫히지 않고 쌓이는 결함(실측 61개 창) — 닫은 뒤 실제로 사라졌는지 확인하고, 남으면 숨긴다.
    static bool ForceClose(Form f)
    {
        try { if (f.Modal) f.DialogResult = DialogResult.Cancel; } catch { }
        try { if (!f.IsDisposed && f.Visible) f.Close(); } catch { }
        try { if (!f.IsDisposed && f.Visible) f.Hide(); } catch { }
        return f.IsDisposed || !f.Visible;
    }
    static List<Form> StrayForms(Form m)
    {
        return OpenFormsSnapshot().Where(f => { try { return f != m && f.IsHandleCreated && !f.IsDisposed && f.Visible && !f.IsMdiChild && f.GetType().Name != "ProgressForm" && !(f.Text == "" && f.FormBorderStyle == FormBorderStyle.None); } catch { return false; } }).ToList();
    }
    static int OpenDialogCount()
    {
        uint pid = (uint)System.Diagnostics.Process.GetCurrentProcess().Id; int n = 0;
        EnumWindows((h, l) => { uint p; GetWindowThreadProcessId(h, out p); if (p == pid && IsWindowVisible(h)) { var cls = new StringBuilder(64); GetClassName(h, cls, 64); if (cls.ToString() == "#32770") n++; } return true; }, IntPtr.Zero);
        return n;
    }
    // sweep: 메인 창·열린 화면(MDI) 말고 떠 있는 창(늦게 뜬 팝업·예외 창 포함)을 새 것부터 기록하고 닫는다. left = 닫지 못한 창 수 · dialogs_open = 남은 메시지 상자 수.
    static void Sweep(Dictionary<string, string> a, Dictionary<string, object> res)
    {
        var m = MainForm(); if (m == null) throw new InvalidOperationException("main form not ready");
        var closed = new List<object>();
        for (int round = 0; round < 6; round++)
        {
            var st = StrayForms(m); if (st.Count == 0) break;
            st.Reverse();
            foreach (var f in st)
            {
                var ff = f;
                try
                {
                    bool to; var d = OnUi(ff, () =>
                    {
                        var spd = FindSpread(ff); int rows = -1; try { if (spd != null) { var sh = Get(spd, "ActiveSheet"); rows = sh == null ? -1 : Convert.ToInt32(Get(sh, "RowCount")); } } catch { }
                        var sb = new StringBuilder(); var stack = new Stack<Control>(); stack.Push(ff);
                        while (stack.Count > 0 && sb.Length < 600) { var x = stack.Pop(); foreach (Control k in x.Controls) { stack.Push(k); if (!(k is Button) && k.Text != null && k.Text.Length > 3 && k.Text.Length < 2000) sb.Append(k.Text.Length > 300 ? k.Text.Substring(0, 300) : k.Text).Append(" | "); } }
                        var e = new Dictionary<string, object> { { "form", ff.GetType().Name }, { "title", ff.Text }, { "modal", ff.Modal }, { "grid_rows", rows }, { "text", sb.ToString() } };
                        e["closed"] = ForceClose(ff); return e;
                    }, 15000, out to);
                    if (to) closed.Add(new Dictionary<string, object> { { "form", ff.GetType().Name }, { "error", "UI thread busy" } }); else closed.Add(d);
                }
                catch (Exception ex) { closed.Add(new Dictionary<string, object> { { "form", ff.GetType().Name }, { "error", ex.Message } }); }
            }
            Thread.Sleep(700);
        }
        Thread.Sleep(Int(a, "settle", 1) * 1000);
        res["closed"] = closed; res["left"] = StrayForms(m).Count; res["dialogs_open"] = OpenDialogCount();
    }
    // 2026-11-13 P6-2 저장 시나리오: 그리드 셀 1개에 값을 넣는다 — 사용자가 셀을 편집한 것과 같은 경로(셀 선택 → 편집 상태 → 값 → 편집 끝)를 먼저 쓰고,
    //   편집 상태에 들어가지 못하면(잠긴 셀 등) 넣지 않는다. mode=value 는 편집 경로 없이 값만 넣는다(변경 이벤트가 나지 않을 수 있음).
    //   row=<행 번호> col=<열 번호 | Tag | Label | DataField> value=<값> [mode=edit|value]  → before·after·action_before·action_after(0번 열 = 변경 표시)·locked·entered
    // 2026-11-13 P6-2 삭제 시나리오: 명령의 대상을 열려 있는 팝업 폼으로 바꾼다 — form=<폼 형식 이름>(없으면 지금 화면). set·cell·act·dump 가 따른다.
    static Form Target(Form m, Dictionary<string, string> a)
    {
        string fn = Str(a, "form", "");
        if (fn == "") return OnUi(m, () => m.ActiveMdiChild);
        var f = FindForm(fn); if (f == null) throw new InvalidOperationException("form not open: " + fn);
        return f;
    }
    static void SetP(object o, string name, object v)
    {
        for (var t = o.GetType(); t != null; t = t.BaseType)
        {
            var pi = t.GetProperty(name, BF | BindingFlags.DeclaredOnly); if (pi != null && pi.CanWrite) { pi.SetValue(o, v, null); return; }
        }
        throw new InvalidOperationException("property not writable: " + name);
    }
    static void Cell(Dictionary<string, string> a, Dictionary<string, object> res)
    {
        var m = MainForm(); if (m == null) throw new InvalidOperationException("main form not ready");
        var child = Target(m, a); if (child == null) throw new InvalidOperationException("no active screen");
        int row = Int(a, "row", 0); string colKey = Str(a, "col", ""), value = Str(a, "value", ""), mode = Str(a, "mode", "edit");
        var d = OnUi(child, () =>
        {
            var o = new Dictionary<string, object>();
            // 11-15: grid=<그리드 이름> sheet=<시트 번호> 를 주면 그 그리드·시트(상세 그리드 분기용). 없으면 첫 그리드 활성 시트
            string gn = Str(a, "grid", ""), sn = Str(a, "sheet", "");
            Control spd = gn == "" ? FindSpread(child) : child.Controls.Find(gn, true).FirstOrDefault();
            if (spd == null) throw new InvalidOperationException(gn == "" ? "no grid on screen" : "grid not found: " + gn);
            int si; if (sn != "" && int.TryParse(sn, out si)) { try { SetP(spd, "ActiveSheetIndex", si); } catch { } }
            var sh = Get(spd, "ActiveSheet"); if (sh == null) throw new InvalidOperationException("no active sheet");
            int rows = Convert.ToInt32(Get(sh, "RowCount")), cols = Convert.ToInt32(Get(sh, "ColumnCount"));
            if (row < 0 || row >= rows) throw new InvalidOperationException("row out of range: " + row + " / " + rows);
            o["grid"] = spd.Name;
            int col; var colsObj = Get(sh, "Columns");
            if (!int.TryParse(colKey, out col))
            {
                col = -1;
                for (int c = 0; c < cols; c++)
                {
                    var co = Item(colsObj, c);
                    if (string.Equals(S(Get(co, "Tag")), colKey, StringComparison.OrdinalIgnoreCase) || string.Equals(S(Get(co, "Label")), colKey, StringComparison.OrdinalIgnoreCase) || string.Equals(S(Get(co, "DataField")), colKey, StringComparison.OrdinalIgnoreCase)) { col = c; break; }
                }
                if (col < 0) throw new InvalidOperationException("column not found: " + colKey);
            }
            o["sheet"] = S(Get(sh, "SheetName")); o["row"] = row; o["col"] = col;
            o["before"] = S(Call(sh, "GetText", row, col)); o["action_before"] = S(Call(sh, "GetText", row, 0));
            var cell = Item2(Get(sh, "Cells"), row, col); bool locked = false;
            try { locked = Convert.ToBoolean(Get(cell, "Locked")); } catch { }
            try { if (!locked) locked = Convert.ToBoolean(Get(Item(colsObj, col), "Locked")) && Get(cell, "Locked") == null; } catch { }
            o["locked"] = locked; o["entered"] = false;
            if (mode == "value")
            {
                object v = value; bool bv;                                   // 체크 상자 열은 참/거짓 값으로 넣는다
                try { var ct = Get(Item(colsObj, col), "CellType"); if (ct != null && ct.GetType().Name.Contains("CheckBox") && bool.TryParse(value, out bv)) v = bv; } catch { }
                try { Call(sh, "SetValue", row, col, v); o["how"] = "SetValue"; }
                catch (Exception ex0)
                {
                    // 11-15: 데이터 바인딩 칸이 숫자형이면 글자 값을 받지 않는다(SCP0005 LT_ARRIVAL_INLAND ArgumentException) → 숫자로 바꿔 다시 넣는다
                    double dv; if (!(v is string) || !double.TryParse(value, System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out dv)) throw;
                    object nv = (Math.Floor(dv) == dv && Math.Abs(dv) < long.MaxValue) ? (object)(long)dv : dv;
                    try { Call(sh, "SetValue", row, col, nv); o["how"] = "SetValue(number)"; }
                    catch { throw ex0; }
                }
            }
            else
            {
                Call(sh, "SetActiveCell", row, col);
                try { SetP(spd, "EditMode", true); } catch (Exception ex) { o["edit_error"] = (ex.InnerException ?? ex).Message; }
                var ec = Get(spd, "EditingControl") as Control;
                if (ec != null) { ec.Text = value; o["entered"] = true; o["how"] = "edit"; }
                try { SetP(spd, "EditMode", false); } catch (Exception ex) { o["edit_error"] = (ex.InnerException ?? ex).Message; }
            }
            o["after"] = S(Call(sh, "GetText", row, col)); o["action_after"] = S(Call(sh, "GetText", row, 0));
            try { o["is_change"] = Convert.ToBoolean(Get(child, "IsChange")); } catch { }
            return o;
        });
        foreach (var kv in d) res[kv.Key] = kv.Value;
    }
    // 2026-11-25 숫자 칸 키 입력 실측(ledger R33 E1·H13 계약 num_input.json): row=<행> col=<열 번호·Tag·DataField> keys=<입력 글자 '|' 구분, 기본 -1|1.5|ab>
    //   글자마다 편집기(EditingControl)에 WM_CHAR 를 보내 사용자가 친 것과 같은 키 처리(KeyPress 거부·자릿수 제한)를 거친다. 편집을 끝내면(EditMode=false) 화면 Change 처리도 돈다.
    //   입력마다 편집기 글자(typed)·편집 끝난 뒤 셀 글자(after)·값(value)을 적고, 입력 전 값으로 되돌린다(SetValue · 변경 표시 열 0 도 되돌림). 저장하지 않는다.
    //   음수 글자색 = 열 CellType.NegativeRed(참이면 Color.Red) · 아니면 값 -1 을 넣은 셀의 합성 스타일 ForeColor(GetStyleInfo) — 넣은 값은 되돌린다
    static void KeyInput(Dictionary<string, string> a, Dictionary<string, object> res)
    {
        var m = MainForm(); if (m == null) throw new InvalidOperationException("main form not ready");
        var child = Target(m, a); if (child == null) throw new InvalidOperationException("no active screen");
        int row = Int(a, "row", 0); string colKey = Str(a, "col", ""); var keys = Str(a, "keys", "-1|1.5|ab").Split('|');
        var d = OnUi(child, () =>
        {
            var o = new Dictionary<string, object>();
            var spd = PickSpread(child, a); if (spd == null) throw new InvalidOperationException("no grid on screen");
            var sh = Get(spd, "ActiveSheet"); if (sh == null) throw new InvalidOperationException("no active sheet");
            int rows = Convert.ToInt32(Get(sh, "RowCount")), cols = Convert.ToInt32(Get(sh, "ColumnCount"));
            if (row < 0 || row >= rows) throw new InvalidOperationException("row out of range: " + row + " / " + rows);
            var colsObj = Get(sh, "Columns"); int col;
            if (!int.TryParse(colKey, out col))
            {
                col = -1;
                for (int c = 0; c < cols; c++) { var co = Item(colsObj, c); if (string.Equals(S(Get(co, "Tag")), colKey, StringComparison.OrdinalIgnoreCase) || string.Equals(S(Get(co, "DataField")), colKey, StringComparison.OrdinalIgnoreCase)) { col = c; break; } }
                if (col < 0) throw new InvalidOperationException("column not found: " + colKey);
            }
            var colO = Item(colsObj, col); var cell = Item2(Get(sh, "Cells"), row, col);
            o["grid"] = spd.Name; o["sheet"] = S(Get(sh, "SheetName")); o["row"] = row; o["col"] = col; o["tag"] = S(Get(colO, "Tag")); o["data_field"] = S(Get(colO, "DataField"));
            object ct = null; try { ct = Get(cell, "CellType"); } catch { } if (ct == null) try { ct = Get(colO, "CellType"); } catch { }
            o["cell_type"] = ct == null ? null : ct.GetType().Name;
            var ctp = new Dictionary<string, object>();
            if (ct != null) foreach (var pn in new[] { "DecimalPlaces", "MinimumValue", "MaximumValue", "NegativeRed", "NegativeFormat", "FixedPoint", "ShowSeparator", "MaximumLength" }) { var pv = SafeS(() => Get(ct, pn)); if (pv != null) ctp[pn] = pv; }
            o["cell_type_props"] = ctp;
            bool locked = false; try { locked = Convert.ToBoolean(Get(cell, "Locked")); } catch { }
            o["locked"] = locked;
            object v0 = null; try { v0 = Call(sh, "GetValue", row, col); } catch { }
            string t0 = SafeS(() => Call(sh, "GetText", row, col)), a0 = SafeS(() => Call(sh, "GetText", row, 0));
            o["before"] = t0; o["action_before"] = a0;
            Action restore = () =>
            {
                try { if (Convert.ToBoolean(Get(spd, "EditMode"))) SetP(spd, "EditMode", false); } catch { }
                try { Call(sh, "SetValue", row, col, v0); } catch { }
                try { Call(sh, "SetValue", row, 0, a0); } catch { }
            };
            var det = new List<object>();
            foreach (var k in keys)
            {
                var e = new Dictionary<string, object> { { "key", k } };
                try
                {
                    Call(sh, "SetActiveCell", row, col);
                    SetP(spd, "EditMode", true);
                    var ec = Get(spd, "EditingControl") as Control;
                    if (ec == null) { e["error"] = "편집기 안 열림"; }
                    else
                    {
                        e["editor"] = ec.GetType().Name;
                        try { var tb = ec as TextBoxBase; if (tb != null) tb.SelectAll(); else ec.Text = ""; } catch { }
                        foreach (char ch in k) SendMessage(ec.Handle, 0x0102 /*WM_CHAR*/, (IntPtr)ch, IntPtr.Zero);
                        e["typed"] = ec.Text;
                        SetP(spd, "EditMode", false);
                        e["after"] = SafeS(() => Call(sh, "GetText", row, col)); e["value"] = SafeS(() => Call(sh, "GetValue", row, col));
                    }
                }
                catch (Exception ex) { e["error"] = (ex.InnerException ?? ex).Message; }
                restore();
                det.Add(e);
            }
            o["inputs"] = det;
            // 음수 글자색
            string nr = ctp.ContainsKey("NegativeRed") ? S(ctp["NegativeRed"]) : null;
            if (string.Equals(nr, "True", StringComparison.OrdinalIgnoreCase)) { o["negative_color"] = "rgb(255, 0, 0)"; o["negative_color_how"] = "CellType.NegativeRed=True(FarPoint 음수 글자 Color.Red)"; }
            else
            {
                try
                {
                    Call(sh, "SetValue", row, col, -1);
                    MethodInfo gsi = sh.GetType().GetMethods(BF).FirstOrDefault(x => x.Name == "GetStyleInfo" && x.GetParameters().Length == 2 && x.GetParameters().All(q => q.ParameterType == typeof(int)));
                    object fc = null; if (gsi != null) { var si = gsi.Invoke(sh, new object[] { row, col }); if (si != null) fc = Get(si, "ForeColor"); }
                    if (fc == null || (fc is System.Drawing.Color && ((System.Drawing.Color)fc).IsEmpty)) { fc = Get(spd, "ForeColor"); o["negative_color_how"] = "NegativeRed=" + (nr ?? "없음") + " · 셀 스타일 글자색 비어 그리드 ForeColor"; }
                    else o["negative_color_how"] = "NegativeRed=" + (nr ?? "없음") + " · 값 -1 셀 합성 스타일 ForeColor(GetStyleInfo)";
                    if (fc is System.Drawing.Color) { var c = (System.Drawing.Color)fc; o["negative_color"] = "rgb(" + c.R + ", " + c.G + ", " + c.B + ")"; o["negative_color_name"] = ColorName(c); }
                }
                catch (Exception ex) { o["negative_color_error"] = (ex.InnerException ?? ex).Message; }
                restore();
            }
            o["after_restore"] = SafeS(() => Call(sh, "GetText", row, col)); o["action_after_restore"] = SafeS(() => Call(sh, "GetText", row, 0));
            return o;
        });
        foreach (var kv in d) res[kv.Key] = kv.Value;
    }
    // 2026-11-13 P6-2: 화면 안의 동작 1개를 사용자와 같은 경로로 일으킨다.
    //   click=<컨트롤 이름>  버튼 누르기(PerformClick · 없으면 OnClick)        method=<화면 메서드>  공통 버튼 재정의 등(인자 0개 또는 (sender,e))
    //   tab=<탭 컨트롤 이름> index=<n>  탭 전환
    //   동작이 모달 창(팝업 폼)을 띄우면 그 창의 이름·제목·그리드 행 수를 기록하고 닫는다(close_popup=0 이면 닫지 않음). 메시지 상자는 기존 대화상자 정책이 처리한다.
    // 이벤트 인자 만들기: 형식의 생성자 인자를 이름·형식으로 채운다(row, column, key, char, index 는 명령 값 · 나머지 수는 0/1 · 참조는 null)
    static object MakeEventArgs(Type pt, Dictionary<string, string> a, Control tc, out string how)
    {
        how = "";
        if (pt == typeof(EventArgs)) { how = "Empty"; return EventArgs.Empty; }
        if (pt == typeof(KeyEventArgs))
        {
            Keys k = Keys.None; foreach (var part in Str(a, "key", "None").Split('+')) k |= (Keys)Enum.Parse(typeof(Keys), part.Trim(), true);
            how = k.ToString(); return new KeyEventArgs(k);
        }
        if (pt == typeof(KeyPressEventArgs)) { string cs = Str(a, "char", "1"); char ch = cs.Length == 1 ? cs[0] : (char)int.Parse(cs); how = "char " + (int)ch; return new KeyPressEventArgs(ch); }
        int row = Int(a, "row", 0), col = Int(a, "col", 0), index = Int(a, "index", 0); Exception last = null;
        foreach (var ci in pt.GetConstructors(BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic).OrderByDescending(c => c.GetParameters().Length))
        {
            try
            {
                var ps = ci.GetParameters(); var args = new object[ps.Length]; var names = new List<string>();
                for (int i = 0; i < ps.Length; i++)
                {
                    var t = ps[i].ParameterType; string n = (ps[i].Name ?? "").ToLowerInvariant(); object v;
                    if (t == typeof(int)) v = n.Contains("count") ? 1 : n.Contains("row") ? row : n.Contains("col") ? col : n.Contains("new") ? Int(a, "new", 1) : n.Contains("index") && !n.Contains("viewport") ? index : 0;
                    else if (t == typeof(bool)) v = false;
                    else if (t == typeof(string)) v = Str(a, "text", "");
                    else if (t.IsEnum) { var ev = Enum.GetValues(t); v = ev.Length > 0 ? ev.GetValue(0) : Activator.CreateInstance(t); }
                    else if (t.Name == "CellRange") v = Activator.CreateInstance(t, row, col, 1, 1);
                    else if (t.Name == "SpreadView") { object rv = null; try { rv = Call(tc, "GetRootWorkbook"); } catch { } v = rv; }
                    else if (t.Name == "SheetView") { object sv = null; try { sv = Get(tc, "ActiveSheet"); } catch { } v = sv; }
                    else if (t.IsInstanceOfType(tc)) v = tc;
                    else if (t.IsValueType) v = Activator.CreateInstance(t);
                    else v = null;
                    args[i] = v; names.Add(ps[i].Name + "=" + (v == null ? "null" : v is Control ? "ctl" : v.ToString()));
                }
                var o = ci.Invoke(args); how = string.Join(",", names); return o;
            }
            catch (Exception ex) { last = ex.InnerException ?? ex; }
        }
        throw new InvalidOperationException("cannot build " + pt.Name + ": " + (last == null ? "no constructor" : last.Message));
    }

    static void Act(Dictionary<string, string> a, Dictionary<string, object> res)
    {
        var m = MainForm(); if (m == null) throw new InvalidOperationException("main form not ready");
        var child = Target(m, a); if (child == null) throw new InvalidOperationException("no active screen");
        string click = Str(a, "click", ""), method = Str(a, "method", ""), tab = Str(a, "tab", ""); int wait = Int(a, "wait", 8);
        string cellAt = Str(a, "cell", ""); bool cellDbl = Str(a, "double", "0") == "1";
        string raise = Str(a, "raise", ""), scroll = Str(a, "scroll", ""); string raised = "";
        string select = Str(a, "select", "");   // 11-16 행 범위 선택 "r0,r1" — 사용자가 Shift 로 여러 행을 고른 것과 같은 선택 영역(다중 선택 팝업의 GetSelections)
        var mdiBefore = OnUi(m, () => m.MdiChildren.ToArray());
        var before = new HashSet<Form>(OpenFormsSnapshot()); Exception err = null; string did = "";
        MethodInvoker work = delegate
        {
            try
            {
                if (click != "")
                {
                    var c = child.Controls.Find(click, true).FirstOrDefault(); if (c == null) throw new InvalidOperationException("control not found: " + click);
                    var pc = c.GetType().GetMethod("PerformClick", BindingFlags.Instance | BindingFlags.Public, null, Type.EmptyTypes, null);
                    if (pc != null) pc.Invoke(c, null);
                    else { var oc = typeof(Control).GetMethod("OnClick", BindingFlags.Instance | BindingFlags.NonPublic); oc.Invoke(c, new object[] { EventArgs.Empty }); }
                }
                else if (method != "")
                {
                    var mi = child.GetType().GetMethod(method, BF); if (mi == null) throw new InvalidOperationException("method not found: " + method);
                    var ps = mi.GetParameters(); mi.Invoke(child, ps.Length == 0 ? null : ps.Length == 2 ? new object[] { child, EventArgs.Empty } : new object[ps.Length]);
                }
                else if (tab != "")
                {
                    var c = child.Controls.Find(tab, true).FirstOrDefault(); if (c == null) throw new InvalidOperationException("tab control not found: " + tab);
                    int ix = Int(a, "index", 0); var tc = c as TabControl;
                    if (tc != null) tc.SelectedIndex = ix;
                    else { var pi = c.GetType().GetProperty("SelectedTabPageIndex") ?? c.GetType().GetProperty("SelectedIndex"); if (pi == null) throw new InvalidOperationException("not a tab control: " + tab); pi.SetValue(c, ix, null); }
                }
                else if (cellAt != "")
                {
                    var spd = PickSpread(child, a); if (spd == null) throw new InvalidOperationException("no grid on screen");
                    var sh = Get(spd, "ActiveSheet"); var pr = cellAt.Split(','); int row = int.Parse(pr[0]), col = int.Parse(pr[1]);
                    // 셀을 보이는 영역으로 옮긴 뒤 화면 좌표를 구한다
                    try { var mShow = spd.GetType().GetMethods(BF).FirstOrDefault(mm => mm.Name == "ShowCell" && mm.GetParameters().Length == 6); if (mShow != null) { var ps = mShow.GetParameters(); mShow.Invoke(spd, new object[] { 0, 0, row, col, Enum.ToObject(ps[4].ParameterType, 3), Enum.ToObject(ps[5].ParameterType, 3) }); } } catch { }
                    Call(sh, "SetActiveCell", row, col);
                    var rc = (System.Drawing.Rectangle)Call(spd, "GetCellRectangle", 0, 0, row, col);
                    // 11-15: 고정 행·열이 있는 그리드는 셀이 다른 화면 영역(viewport)에 있다(SSP0200 ERP_SO_NO 폭 100인데 0,0 영역 사각형 0) → 다른 영역 번호로 다시 구한다
                    if (rc.Width <= 0 || rc.Height <= 0)
                        foreach (var vp in new[] { new[] { 0, -1 }, new[] { -1, 0 }, new[] { -1, -1 }, new[] { 0, 1 }, new[] { 1, 0 }, new[] { 1, 1 } })
                        {
                            try { rc = (System.Drawing.Rectangle)Call(spd, "GetCellRectangle", vp[0], vp[1], row, col); } catch { continue; }
                            if (rc.Width > 0 && rc.Height > 0) break;
                        }
                    if (rc.Width <= 0 || rc.Height <= 0) throw new InvalidOperationException("cell not visible: " + cellAt);
                    int cx = rc.Left + Math.Min(rc.Width / 2, 12), cy = rc.Top + rc.Height / 2; IntPtr lp = (IntPtr)((cy << 16) | (cx & 0xFFFF)); IntPtr h = spd.Handle;
                    PostMessage(h, 0x0201, (IntPtr)1, lp); PostMessage(h, 0x0202, IntPtr.Zero, lp);
                    if (cellDbl) { PostMessage(h, 0x0203, (IntPtr)1, lp); PostMessage(h, 0x0202, IntPtr.Zero, lp); }
                }
                else if (select != "")
                {
                    var spd = PickSpread(child, a); if (spd == null) throw new InvalidOperationException("no grid on screen");
                    var sh = Get(spd, "ActiveSheet"); var pr = select.Split(','); int r0 = int.Parse(pr[0]), r1 = int.Parse(pr[pr.Length - 1]);
                    int nrow = Convert.ToInt32(Get(sh, "RowCount")), ncol = Convert.ToInt32(Get(sh, "ColumnCount"));
                    if (r1 >= nrow) throw new InvalidOperationException("select rows out of range: " + select + " / " + nrow);
                    Call(sh, "SetActiveCell", r0, 0);
                    Call(sh, "ClearSelection"); Call(sh, "AddSelection", r0, -1, r1 - r0 + 1, -1);
                    var sel = Call(sh, "GetSelections") as Array; raised = "selections " + (sel == null ? 0 : sel.Length) + " rows " + r0 + "-" + r1 + " of " + nrow + " cols " + ncol;
                }
                else if (scroll != "")
                {
                    // 스크롤(11-14): 그리드의 보이는 첫 행을 옮긴다. 사용자가 세로 막대를 움직인 것과 같은 속성 변경
                    string tn = Str(a, "target", ""); Control spd = tn == "" ? FindSpread(child) : child.Controls.Find(tn, true).FirstOrDefault();
                    if (spd == null) throw new InvalidOperationException("grid not found: " + tn);
                    int top0 = Convert.ToInt32(Call(spd, "GetViewportTopRow", 0)); Call(spd, "SetViewportTopRow", 0, int.Parse(scroll));
                    raised = "top " + top0 + "->" + Convert.ToInt32(Call(spd, "GetViewportTopRow", 0));
                }
                else if (raise != "")
                {
                    // 이벤트 직접 발생(11-14): 컨트롤의 On<이벤트>(인자) 를 불러 화면이 건 처리기를 실행시킨다. 컨트롤 자체의 기본 동작(실제 붙여넣기·글자 입력)은 일어나지 않는다.
                    string tn = Str(a, "target", ""); Control tc = (tn == "" || tn == "this") ? (Control)child : child.Controls.Find(tn, true).FirstOrDefault();
                    if (tc == null) throw new InvalidOperationException("control not found: " + tn);
                    MethodInfo on = null;
                    for (var t = tc.GetType(); t != null && on == null; t = t.BaseType)
                        on = t.GetMethods(BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.DeclaredOnly).FirstOrDefault(mm => mm.Name == "On" + raise && mm.GetParameters().Length == 1);
                    if (on == null) throw new InvalidOperationException("no On" + raise + " on " + tc.GetType().Name);
                    var pt = on.GetParameters()[0].ParameterType; string how; object ea = MakeEventArgs(pt, a, tc, out how);
                    if (a.ContainsKey("row") && a.ContainsKey("col")) { try { var ash = Get(tc, "ActiveSheet"); if (ash != null) Call(ash, "SetActiveCell", Int(a, "row", 0), Int(a, "col", 0)); } catch { } }
                    raised = pt.Name + "(" + how + ")";
                    on.Invoke(tc, new object[] { ea });
                }
                else throw new InvalidOperationException("act needs click | method | tab | cell | select | scroll | raise");
            }
            catch (Exception ex) { err = ex.InnerException ?? ex; }
        };
        did = select != "" ? "select:" + select : raise != "" ? "raise:" + Str(a, "target", "this") + "." + raise : scroll != "" ? "scroll:" + Str(a, "target", "") + ":" + scroll : click != "" ? "click:" + click : method != "" ? "method:" + method : cellAt != "" ? (cellDbl ? "celldbl:" : "cellclick:") + cellAt : "tab:" + tab + ":" + Str(a, "index", "0");
        m.BeginInvoke(work); res["did"] = did;
        var popups = new List<object>(); var until = DateTime.Now.AddSeconds(wait); bool closePopup = Str(a, "close_popup", "1") != "0";
        while (DateTime.Now < until)
        {
            Thread.Sleep(600);
            if (err != null) break;
            var nf = OpenFormsSnapshot().Where(f => !before.Contains(f) && f.IsHandleCreated && f.Visible).ToList();
            foreach (var f in nf)
            {
                before.Add(f); var ff = f; Thread.Sleep(1500);
                // 팝업은 뜬 뒤에 조회가 끝난다(11-13 품목 팝업 2.4초 · 6만 행인데 행 수 0 으로 기록) → 행이 채워지거나 6초가 지날 때까지 기다렸다가 읽는다
                if (ff.GetType().Name != "ProgressForm")
                {
                    var tEnd = DateTime.Now.AddSeconds(Int(a, "popup_wait", 6));
                    while (DateTime.Now < tEnd)
                    {
                        int rc = -1;
                        try { bool to0; rc = OnUi(ff, () => { var sp0 = FindSpread(ff); if (sp0 == null) return -2; var sh0 = Get(sp0, "ActiveSheet"); return sh0 == null ? -1 : Convert.ToInt32(Get(sh0, "RowCount")); }, 3000, out to0); if (to0) rc = -1; } catch { }
                        if (rc > 0 || rc == -2) break;
                        Thread.Sleep(500);
                    }
                }
                try
                {
                    popups.Add(OnUi(ff, () =>
                    {
                        var spd = FindSpread(ff); int rows = -1; try { if (spd != null) { var sh = Get(spd, "ActiveSheet"); rows = sh == null ? -1 : Convert.ToInt32(Get(sh, "RowCount")); } } catch { }
                        var d = new Dictionary<string, object> { { "form", ff.GetType().Name }, { "title", ff.Text }, { "modal", ff.Modal }, { "grid_rows", rows } };
                        if (closePopup) { d["closed"] = ForceClose(ff); }
                        return d;
                    }));
                }
                catch (Exception ex) { popups.Add(new Dictionary<string, object> { { "form", ff.GetType().Name }, { "error", ex.Message } }); }
                until = DateTime.Now.AddSeconds(3);
            }
        }
        res["popups"] = popups; if (raised != "") res["raised"] = raised;
        try
        {
            var opened = OnUi(m, () =>
            {
                var lst = new List<object>();
                foreach (var c in m.MdiChildren.ToArray())
                {
                    if (mdiBefore.Contains(c)) continue;
                    lst.Add(new Dictionary<string, object> { { "form", c.GetType().Name }, { "title", c.Text } });
                    if (closePopup) { try { c.Close(); } catch { } }
                }
                if (lst.Count > 0 && closePopup) { try { child.Activate(); } catch { } }
                return lst;
            });
            if (opened.Count > 0) res["new_screens"] = opened;
        }
        catch { }
        try { var fi = child.GetType().GetField("IsEditMode", BF); if (fi != null) res["edit_mode"] = OnUi(m, () => Convert.ToBoolean(fi.GetValue(child))); } catch { }
        if (err != null) throw new InvalidOperationException(did + " failed: " + err.GetType().Name + ": " + err.Message);
    }

    static object Item1(object o, int i)
    {
        var pi = o.GetType().GetProperty("Item", new[] { typeof(int) }); return pi == null ? null : pi.GetValue(o, new object[] { i });
    }
    static void Group(Dictionary<string, string> a, Dictionary<string, object> res)
    {
        var m = MainForm(); if (m == null) throw new InvalidOperationException("main form not ready");
        var fi = m.GetType().GetField("usrCmbMyGroupID", BF); if (fi == null) throw new InvalidOperationException("group combo field not found");
        var cb = fi.GetValue(m) as ComboBox; if (cb == null) throw new InvalidOperationException("group combo is not a ComboBox");
        Func<Dictionary<string, object>> read = () => OnUi(m, () =>
        {
            var items = new List<object>();
            for (int i = 0; i < cb.Items.Count; i++) { var it = cb.Items[i]; string code = ""; try { var row = Get(it, "Row"); code = row == null ? "" : S(Item1(row, 0)); } catch { }
                items.Add(new Dictionary<string, object> { { "code", code }, { "name", cb.GetItemText(it) } }); }
            return new Dictionary<string, object> { { "current", S(cb.SelectedValue) }, { "items", items } };
        });
        var before = read(); res["before"] = before["current"]; res["items"] = before["items"];
        string value = Str(a, "value", ""); if (value == "") { res["current"] = before["current"]; return; }
        if (S(before["current"]) == value) { res["current"] = value; res["changed"] = false; return; }
        string old = dialogPolicy; dialogPolicy = "yes";
        try
        {
            m.BeginInvoke((MethodInvoker)delegate { try { cb.SelectedValue = value; } catch { } });
            var until = DateTime.Now.AddSeconds(Int(a, "wait", 120)); bool ok = false; Thread.Sleep(1500);
            while (DateTime.Now < until)
            {
                Thread.Sleep(1000);
                try { var cur = read(); if (S(cur["current"]) == value) { ok = true; Thread.Sleep(2000); break; } } catch { }
            }
            var after = read(); res["current"] = after["current"]; res["changed"] = ok;
            if (!ok) throw new InvalidOperationException("group not changed (current=" + S(after["current"]) + ")");
        }
        finally { dialogPolicy = old; }
    }

    // 2026-11-15 행별 셀 상태 읽기: 조회 뒤 행마다 셀 잠금·배경색·글자색을 읽는다(편집 불가 셀·행 조건 계산 분기의 정답).
    //   form=<팝업 폼>(없으면 지금 화면) from=<첫 행> rows=<행 수, 기본 30> cols=<열 번호 쉼표, 없으면 전부 최대 120>
    //   잠금은 SheetView.GetStyleInfo(행,열) 의 합성 값(행·열·셀 스타일을 합친 값)을 먼저 쓰고, 없으면 셀 → 행 → 열 순서로 읽는다.
    //   돌려주는 값: cols [{index, tag, label}], locked [행별 "0101…" 글자], back/fore [행별 [색 이름…]], text [행별 [글자…]], how(잠금을 읽은 경로)
    static string ColorName(object v)
    {
        if (v == null) return "";
        if (v is System.Drawing.Color) { var c = (System.Drawing.Color)v; if (c.IsEmpty) return ""; return c.IsNamedColor ? c.Name : "#" + c.ToArgb().ToString("X8"); }
        return S(v);
    }
    static void CellState(Dictionary<string, string> a, Dictionary<string, object> res)
    {
        var m = MainForm(); if (m == null) throw new InvalidOperationException("main form not ready");
        var child = Target(m, a); if (child == null) throw new InvalidOperationException("no active screen");
        int from = Int(a, "from", 0), cnt = Int(a, "rows", 30); string colArg = Str(a, "cols", "");
        var d = OnUi(child, () =>
        {
            var o = new Dictionary<string, object>();
            var spd = PickSpread(child, a); if (spd == null) throw new InvalidOperationException("no grid on screen");
            var sh = Get(spd, "ActiveSheet"); if (sh == null) throw new InvalidOperationException("no active sheet");
            o["grid"] = spd.Name; o["sheet_index"] = Get(spd, "ActiveSheetIndex"); o["sheet_name"] = S(Get(sh, "SheetName"));
            int rows = Convert.ToInt32(Get(sh, "RowCount")), ncol = Convert.ToInt32(Get(sh, "ColumnCount"));
            var colsObj = Get(sh, "Columns"); var rowsObj = Get(sh, "Rows"); var cellsObj = Get(sh, "Cells");
            var useCols = new List<int>();
            if (colArg != "") foreach (var p in colArg.Split(',')) { int ci; if (int.TryParse(p.Trim(), out ci) && ci >= 0 && ci < ncol) useCols.Add(ci); }
            else for (int c = 0; c < ncol && c < 120; c++) useCols.Add(c);
            var colInfo = new List<object>();
            foreach (int c in useCols) { var co = Item(colsObj, c); colInfo.Add(new Dictionary<string, object> { { "index", c }, { "tag", SafeS(() => Get(co, "Tag")) }, { "label", SafeS(() => Get(co, "Label")) }, { "data_field", SafeS(() => Get(co, "DataField")) }, { "visible", SafeS(() => Get(co, "Visible")) } }); }
            MethodInfo gsi = sh.GetType().GetMethods(BF).FirstOrDefault(x => x.Name == "GetStyleInfo" && x.GetParameters().Length == 2 && x.GetParameters().All(q => q.ParameterType == typeof(int)));
            var locked = new List<string>(); var back = new List<object>(); var fore = new List<object>(); var text = new List<object>(); var hows = new HashSet<string>();
            int end = Math.Min(rows, from + Math.Max(cnt, 0));
            for (int r = from; r < end; r++)
            {
                var lk = new StringBuilder(); var bk = new List<string>(); var fr = new List<string>(); var tx = new List<string>();
                object rowO = null; try { rowO = Item(rowsObj, r); } catch { }
                foreach (int c in useCols)
                {
                    bool? L = null; string B = "", Fo = "";
                    if (gsi != null)
                    {
                        try
                        {
                            var si = gsi.Invoke(sh, new object[] { r, c });
                            if (si != null) { var lv = Get(si, "Locked"); if (lv != null) { L = Convert.ToBoolean(lv); hows.Add("GetStyleInfo"); } B = ColorName(Get(si, "BackColor")); Fo = ColorName(Get(si, "ForeColor")); }
                        }
                        catch { }
                    }
                    if (L == null)
                    {
                        object cell = null; try { cell = Item2(cellsObj, r, c); } catch { }
                        try { if (cell != null) { L = Convert.ToBoolean(Get(cell, "Locked")); hows.Add("Cell"); } } catch { }
                        if (B == "") { try { if (cell != null) B = ColorName(Get(cell, "BackColor")); } catch { } }
                        if (Fo == "") { try { if (cell != null) Fo = ColorName(Get(cell, "ForeColor")); } catch { } }
                        if (L == null) { try { if (rowO != null) { L = Convert.ToBoolean(Get(rowO, "Locked")); hows.Add("Row"); } } catch { } }
                        if (L == null) { try { L = Convert.ToBoolean(Get(Item(colsObj, c), "Locked")); hows.Add("Column"); } catch { } }
                    }
                    lk.Append(L == null ? '?' : L.Value ? '1' : '0'); bk.Add(B); fr.Add(Fo);
                    int rr = r, cc = c; tx.Add(SafeS(() => Call(sh, "GetText", rr, cc)));
                }
                locked.Add(lk.ToString()); back.Add(bk); fore.Add(fr); text.Add(tx);
            }
            o["sheet"] = S(Get(sh, "SheetName")); o["rows_total"] = rows; o["from"] = from; o["cols"] = colInfo;
            o["locked"] = locked; o["back"] = back; o["fore"] = fore; o["text"] = text; o["how"] = hows.ToList();
            try { o["sheet_locked"] = Convert.ToBoolean(Get(sh, "Protect")); } catch { }
            try { var fi = child.GetType().GetField("IsEditMode", BF); if (fi != null) o["edit_mode"] = Convert.ToBoolean(fi.GetValue(child)); } catch { }
            return o;
        });
        foreach (var kv in d) res[kv.Key] = kv.Value;
    }

    // 2026-11-15 팝업 확인 버튼: form=<팝업 폼> types=<ButtonListType 이름 쉼표, 기본 OK,Confirm> wait=<초>
    //   공통 버튼 묶음(UsrButtonList)의 버튼은 Tag 에 ButtonItem(UserType)을 담는다 → UserType 이 types 에 드는 버튼을 PerformClick(사용자 클릭과 같은 경로).
    //   없으면 이름·글자가 OK·확인·Apply·Select·선택·적용 인 일반 버튼을 누른다. 누른 뒤 팝업이 닫힐 때까지 기다린다.
    static void PopupOk(Dictionary<string, string> a, Dictionary<string, object> res)
    {
        string fn = Str(a, "form", ""); var f = FindForm(fn); if (f == null) throw new InvalidOperationException("form not open: " + fn);
        var types = new HashSet<string>(Str(a, "types", "OK,Confirm").Split(',').Select(x => x.Trim()), StringComparer.OrdinalIgnoreCase);
        var words = new[] { "ok", "확인", "apply", "select", "선택", "적용", "btnok", "btnselect", "btnapply", "btnconfirm" };
        Button target = null; string how = "";
        var found = OnUi(f, () =>
        {
            var all = new List<Button>(); var st = new Stack<Control>(); st.Push(f);
            while (st.Count > 0) { var x = st.Pop(); foreach (Control k in x.Controls) { st.Push(k); var b = k as Button; if (b != null) all.Add(b); } }
            var lst = new List<string>();
            foreach (var b in all)
            {
                string ut = ""; try { if (b.Tag != null && b.Tag.GetType().Name == "ButtonItem") ut = S(Get(b.Tag, "UserType")); } catch { }
                lst.Add(b.Name + "|" + b.Text + "|" + ut + "|" + (b.Visible && b.Enabled ? "on" : "off"));
                if (target == null && ut != "" && types.Contains(ut) && b.Visible && b.Enabled) { target = b; how = "ButtonItem " + ut; }
            }
            if (target == null)
                foreach (var b in all)
                    if (b.Visible && b.Enabled && (words.Contains((b.Name ?? "").ToLowerInvariant()) || words.Contains((b.Text ?? "").Trim().ToLowerInvariant()))) { target = b; how = "button " + b.Name + "|" + b.Text; break; }
            return lst;
        });
        res["buttons"] = found;
        if (target == null) throw new InvalidOperationException("no OK/Confirm button on " + fn);
        res["how"] = how; Exception err = null; var tb = target;
        f.BeginInvoke((MethodInvoker)delegate { try { tb.PerformClick(); } catch (Exception ex) { err = ex; } });
        var until = DateTime.Now.AddSeconds(Int(a, "wait", 10)); bool closed = false;
        while (DateTime.Now < until) { Thread.Sleep(500); if (err != null) break; if (!OpenFormsSnapshot().Contains(f) || !f.Visible) { closed = true; break; } }
        res["closed"] = closed;
        if (err != null) throw new InvalidOperationException("click failed: " + (err.InnerException ?? err).Message);
    }

    static void PopupPick(Dictionary<string, string> a, Dictionary<string, object> res)
    {
        var m = MainForm(); if (m == null) throw new InvalidOperationException("main form not ready");
        var child = OnUi(m, () => m.ActiveMdiChild); if (child == null) throw new InvalidOperationException("no active screen");
        int wait = Int(a, "wait", 60); MethodInfo mi = null;
        foreach (var o in Str(a, "openers", "btnVersion_Click,btnSPVer_Click").Split(',')) { mi = child.GetType().GetMethod(o.Trim(), BF); if (mi != null) break; }
        if (mi == null) throw new InvalidOperationException("popup opener method not found on " + child.GetType().Name);
        res["opener"] = mi.Name;
        var before = new HashSet<Form>(OpenFormsSnapshot()); Exception openErr = null;
        m.BeginInvoke((MethodInvoker)delegate { try { var ps = mi.GetParameters(); mi.Invoke(child, ps.Length == 0 ? null : new object[] { null, EventArgs.Empty }); } catch (Exception ex) { openErr = ex; } });
        Form pop = null; Control spd = null; int rows = -1, stable = 0; var until = DateTime.Now.AddSeconds(wait);
        while (DateTime.Now < until)
        {
            Thread.Sleep(700);
            if (openErr != null) throw new InvalidOperationException("popup opener failed: " + (openErr.InnerException ?? openErr).Message);
            if (pop == null) pop = OpenFormsSnapshot().LastOrDefault(f => !before.Contains(f) && f.IsHandleCreated && f.Visible);
            if (pop == null) continue;
            var p0 = pop;
            int r = OnUi(p0, () => { if (spd == null) spd = FindSpread(p0); if (spd == null) return -1; var sh = Get(spd, "ActiveSheet"); return sh == null ? -1 : Convert.ToInt32(Get(sh, "RowCount")); });
            if (r > 0 && r == rows) { if (++stable >= 2) break; } else stable = 0;
            rows = r;
        }
        if (pop == null) throw new InvalidOperationException("popup did not open");
        var pp = pop; res["popup"] = pp.GetType().Name; res["rows"] = rows;
        if (rows <= 0)
        {
            // 목록이 없는 창(예외 창 등)이면 그 창의 글자를 모아 원인으로 돌려준다
            string txt = OnUi(pp, () => { var sb = new StringBuilder(pp.Text); var st = new Stack<Control>(); st.Push(pp); while (st.Count > 0) { var x = st.Pop(); foreach (Control k in x.Controls) { if (!string.IsNullOrEmpty(k.Text) && sb.Length < 1500) sb.Append(" | ").Append(k.Text); st.Push(k); } } pp.Close(); return sb.ToString(); });
            throw new InvalidOperationException("popup has no rows: " + pp.GetType().Name + " :: " + txt);
        }
        // 2026-11-24 R71: 행 선택 중 예외(SetItem 없음, 열 없음, SetItem 호출 실패)가 나도 팝업을 닫는다(finally ForceClose)
        res["picked"] = OnUi(pp, () =>
        {
          try
          {
            var sh = Get(spd, "ActiveSheet"); int cols = Convert.ToInt32(Get(sh, "ColumnCount"));
            var colHeader = Get(sh, "ColumnHeader"); var hcells = colHeader == null ? null : Get(colHeader, "Cells"); int hrows = colHeader == null ? 0 : Convert.ToInt32(Get(colHeader, "RowCount"));
            int vcol = -1, vloose = -1; var heads = new List<string>();
            for (int c = 0; c < cols && c < 200; c++)
            {
                string h = ""; for (int r = 0; r < hrows; r++) { int rr = r, cc = c; h += " " + (SafeS(() => Get(Item2(hcells, rr, cc), "Text")) ?? ""); }
                h = h.Trim(); heads.Add(h); string hl = h.ToLowerInvariant().Replace("_", " ").Replace(".", "").Trim();
                if (vcol < 0 && (hl == "version" || hl == "version no" || hl == "sp version" || hl == "versionno")) vcol = c;
                if (vloose < 0 && hl.Contains("version") && !hl.Contains("type") && !hl.Contains("desc")) vloose = c;
            }
            if (vcol < 0) vcol = vloose;
            // 2026-11-17: row = 고를 행(기본 0 = 맨 위) · top = 돌려줄 위쪽 행 값 수(기본 5) — 맨 위 값으로 조회가 0행이면 데이터가 나오는 다음 행을 고르기 위함(asis_live_datafind)
            int pick = Int(a, "row", 0), ntop = Int(a, "top", 5);
            if (pick < 0 || pick >= rows) { pp.Close(); throw new InvalidOperationException("popup row out of range: " + pick + "/" + rows); }
            var top = new List<string>(); for (int r = 0; r < rows && r < Math.Max(ntop, pick + 1); r++) { int rr = r; top.Add(vcol >= 0 ? SafeS(() => Call(sh, "GetText", rr, vcol)) : ""); }
            int ac = Math.Max(vcol, 0);
            try { Call(sh, "SetActiveCell", pick, ac); } catch { }
            try { Call(sh, "ClearSelection"); Call(sh, "AddSelection", pick, ac, 1, 1); } catch { }
            string how; var fv = pp.GetType().GetField("sVersions", BF);
            var setItem = pp.GetType().GetMethod("SetItem", BF, null, Type.EmptyTypes, null);
            if (setItem != null) { setItem.Invoke(pp, null); how = "SetItem"; }
            else { if (fv == null || vcol < 0) throw new InvalidOperationException("popup has no SetItem and no version column/field"); fv.SetValue(pp, top[pick]); how = "field"; }
            string val = fv == null ? null : S(fv.GetValue(pp));
            pp.Close();
            return new Dictionary<string, object> { { "how", how }, { "value", val }, { "row", pick }, { "rows", rows }, { "top", top }, { "version_col", vcol }, { "version_header", vcol >= 0 ? heads[vcol] : null } };
          }
          finally { if (!pp.IsDisposed) ForceClose(pp); }
        });
        Thread.Sleep(500);
    }

    // ───────────────────────── 덤프 ─────────────────────────
    static void Dump(Dictionary<string, string> a, Dictionary<string, object> res)
    {
        var m = MainForm(); if (m == null) throw new InvalidOperationException("main form not ready");
        int maxRows = Int(a, "rows", 50); DumpRaw = Str(a, "raw", "0") == "1";
        var data = OnUi(m, () =>
        {
            var d = new Dictionary<string, object>();
            var child = Str(a, "form", "") == "" ? m.ActiveMdiChild : FindForm(Str(a, "form", ""));
            d["main_title"] = m.Text; d["total"] = S(Get(Get(m, "tsLblSum"), "Text")); d["time_status"] = S(Get(Get(m, "tsLblTimeStatus"), "Text")); d["user"] = S(Get(Get(m, "tsLblUser"), "Text"));
            d["open_screens"] = m.MdiChildren.Select(c => c.GetType().Name + "|" + c.Text).ToList();
            if (child == null) { d["screen"] = null; return d; }
            d["screen"] = new Dictionary<string, object> { { "type", child.GetType().FullName }, { "text", child.Text }, { "width", child.Width }, { "height", child.Height } };
            var controls = new List<object>(); var grids = new List<object>(); var layout = new List<object>();
            Walk(child, "", controls, grids, layout, maxRows);
            d["controls"] = controls; d["grids"] = grids; d["layout_items"] = layout;
            return d;
        });
        string path = Str(a, "path", "");
        if (path != "")
        {
            Directory.CreateDirectory(Path.GetDirectoryName(path));
            File.WriteAllText(path, new JavaScriptSerializer { MaxJsonLength = int.MaxValue, RecursionLimit = 64 }.Serialize(data), new UTF8Encoding(false));
            res["path"] = path;
            res["control_count"] = data.ContainsKey("controls") ? ((List<object>)data["controls"]).Count : 0;
            res["grid_count"] = data.ContainsKey("grids") ? ((List<object>)data["grids"]).Count : 0;
            res["total"] = data["total"]; res["time_status"] = data["time_status"];
        }
        else res["data"] = data;
    }

    static void Walk(Control c, string parentPath, List<object> controls, List<object> grids, List<object> layout, int maxRows)
    {
        foreach (Control k in c.Controls)
        {
            string tn = k.GetType().Name, full = k.GetType().FullName;
            string path = parentPath + "/" + (string.IsNullOrEmpty(k.Name) ? tn : k.Name);
            var o = new Dictionary<string, object> { { "name", k.Name }, { "type", full }, { "path", path }, { "visible", k.Visible }, { "enabled", k.Enabled },
                { "x", k.Left }, { "y", k.Top }, { "w", k.Width }, { "h", k.Height }, { "tab", k.TabIndex } };
            bool isGrid = false;
            for (var t = k.GetType(); t != null; t = t.BaseType) if (t.Name == "FpSpread") { isGrid = true; break; }
            if (!isGrid) { try { o["text"] = k.Text; } catch { } }
            var cb = k as ComboBox;
            if (cb != null) { o["selected_index"] = cb.SelectedIndex; o["selected_text"] = cb.SelectedIndex >= 0 ? cb.GetItemText(cb.SelectedItem) : null; o["selected_value"] = SafeS(() => cb.SelectedValue); var items = new List<string>(); for (int i = 0; i < cb.Items.Count && i < 500; i++) items.Add(cb.GetItemText(cb.Items[i])); o["items"] = items; o["item_count"] = cb.Items.Count; }
            var chk = k as CheckBox; if (chk != null) o["checked"] = chk.Checked;
            var rb = k as RadioButton; if (rb != null) o["checked"] = rb.Checked;
            var clb = k as CheckedListBox;
            if (clb != null) { var items = new List<object>(); for (int i = 0; i < clb.Items.Count && i < 500; i++) items.Add(new Dictionary<string, object> { { "text", clb.GetItemText(clb.Items[i]) }, { "checked", clb.GetItemChecked(i) } }); o["items"] = items; }
            var dtp = k as DateTimePicker; if (dtp != null) o["value"] = dtp.Value.ToString("yyyy-MM-dd HH:mm:ss");
            // 사용자 정의 컨트롤이 흔히 내는 값 속성(있을 때만)
            foreach (var pn in new[] { "EditValue", "ControlValues", "ControlValue", "FromDate", "ToDate", "Value", "ReadOnly" })
            { if (o.ContainsKey(ToSnake(pn))) continue; var p = k.GetType().GetProperty(pn, BindingFlags.Instance | BindingFlags.Public, null, null, Type.EmptyTypes, null); if (p == null || !p.CanRead) continue; try { var v = p.GetValue(k, null); if (v != null && (v is string || v.GetType().IsPrimitive || v is DateTime || v is decimal)) o[ToSnake(pn)] = Convert.ToString(v); } catch { } }
            controls.Add(o);
            if (tn == "LayoutControl" || k.GetType().BaseType != null && k.GetType().BaseType.Name == "LayoutControl") DumpLayout(k, layout);
            if (isGrid && maxRows < 0) continue;      // rows=-1 → 그리드 생략(조건 컨트롤만 빠르게)
            if (isGrid) { try { grids.Add(DumpSpread(k, path, maxRows)); } catch (Exception ex) { grids.Add(new Dictionary<string, object> { { "name", k.Name }, { "error", ex.Message } }); } continue; }
            if (k.Controls.Count > 0) Walk(k, path, controls, grids, layout, maxRows);
        }
    }
    static string ToSnake(string s) { var sb = new StringBuilder(); foreach (char ch in s) { if (char.IsUpper(ch) && sb.Length > 0) sb.Append('_'); sb.Append(char.ToLowerInvariant(ch)); } return sb.ToString(); }
    static string SafeS(Func<object> f) { try { return S(f()); } catch { return null; } }

    // DevExpress LayoutControl: 라벨(필수 '*' 포함) ↔ 컨트롤 이름
    static void DumpLayout(Control lc, List<object> layout)
    {
        var items = Get(lc, "Items") as IEnumerable; if (items == null) return;
        foreach (var it in items)
        {
            var ctl = Get(it, "Control") as Control; string text = S(Get(it, "Text"));
            if (ctl == null && string.IsNullOrEmpty(text)) continue;
            layout.Add(new Dictionary<string, object> { { "layout", lc.Name }, { "item", S(Get(it, "Name")) }, { "label", text }, { "control", ctl == null ? null : ctl.Name },
                { "required", text != null && text.TrimEnd().EndsWith("*") }, { "visible", SafeS(() => Get(it, "Visible")) }, { "text_visible", SafeS(() => Get(it, "TextVisible")) } });
        }
    }

    // FarPoint FpSpread: 시트·헤더·컬럼 속성·앞 N행 값
    static bool DumpRaw = false;      // dump raw=1 → 셀의 표시 글자(data) 옆에 원래 값(values)도 낸다(콤보 코드 · 날짜 원값)
    static string RawS(object v)
    {
        if (v == null || v is DBNull) return "";
        if (v is DateTime) return ((DateTime)v).ToString("yyyy-MM-dd HH:mm:ss");
        return Convert.ToString(v, System.Globalization.CultureInfo.InvariantCulture);
    }
    static Dictionary<string, object> DumpSpread(Control spd, string path, int maxRows)
    {
        var g = new Dictionary<string, object> { { "name", spd.Name }, { "path", path }, { "type", spd.GetType().FullName }, { "visible", spd.Visible } };
        var sheets = new List<object>(); var sv = Get(spd, "Sheets") as IEnumerable; g["active_sheet_index"] = SafeS(() => Get(spd, "ActiveSheetIndex"));
        if (sv != null) foreach (var sh in sv)
        {
            var s = new Dictionary<string, object>();
            int rows = Convert.ToInt32(Get(sh, "RowCount")), cols = Convert.ToInt32(Get(sh, "ColumnCount"));
            s["name"] = S(Get(sh, "SheetName")); s["rows"] = rows; s["cols"] = cols; s["visible"] = SafeS(() => Get(sh, "Visible"));
            s["frozen_cols"] = SafeS(() => Get(sh, "FrozenColumnCount")); s["frozen_rows"] = SafeS(() => Get(sh, "FrozenRowCount")); s["operation_mode"] = SafeS(() => Get(sh, "OperationMode"));
            var colHeader = Get(sh, "ColumnHeader"); int hrows = colHeader == null ? 0 : Convert.ToInt32(Get(colHeader, "RowCount")); s["header_rows"] = hrows;
            var hcells = colHeader == null ? null : Get(colHeader, "Cells"); var colsObj = Get(sh, "Columns");
            var colList = new List<object>();
            for (int c = 0; c < cols && c < 400; c++)
            {
                var col = colsObj == null ? null : Item(colsObj, c);
                var cd = new Dictionary<string, object> { { "index", c } };
                var hd = new List<string>(); for (int r = 0; r < hrows; r++) hd.Add(SafeS(() => Get(Item2(hcells, r, c), "Text")));
                cd["header"] = hd;
                if (col != null)
                {
                    cd["label"] = SafeS(() => Get(col, "Label")); cd["tag"] = SafeS(() => Get(col, "Tag")); cd["width"] = SafeS(() => Get(col, "Width")); cd["visible"] = SafeS(() => Get(col, "Visible"));
                    cd["locked"] = SafeS(() => Get(col, "Locked")); cd["h_align"] = SafeS(() => Get(col, "HorizontalAlignment")); cd["data_field"] = SafeS(() => Get(col, "DataField"));
                    var ct = Get(col, "CellType"); cd["cell_type"] = ct == null ? null : ct.GetType().Name; cd["merge_policy"] = SafeS(() => Get(col, "MergePolicy"));
                }
                colList.Add(cd);
            }
            s["columns"] = colList;
            var data = new List<object>(); int take = Math.Min(rows, maxRows);
            for (int r = 0; r < take; r++) { var row = new List<string>(); for (int c = 0; c < cols && c < 400; c++) row.Add(SafeS(() => Call(sh, "GetText", r, c))); data.Add(row); }
            s["data_rows"] = take; s["data"] = data;
            if (DumpRaw)
            {
                var vals = new List<object>();
                for (int r = 0; r < take; r++) { var row = new List<string>(); for (int c = 0; c < cols && c < 400; c++) row.Add(SafeS(() => RawS(Call(sh, "GetValue", r, c)))); vals.Add(row); }
                s["values"] = vals;
            }
            sheets.Add(s);
        }
        g["sheets"] = sheets; return g;
    }
    static object Item(object coll, int i) { var p = coll.GetType().GetProperties(BF).FirstOrDefault(x => x.GetIndexParameters().Length == 1 && x.GetIndexParameters()[0].ParameterType == typeof(int)); return p == null ? null : p.GetValue(coll, new object[] { i }); }
    static object Item2(object coll, int r, int c) { if (coll == null) return null; var p = coll.GetType().GetProperties(BF).FirstOrDefault(x => x.GetIndexParameters().Length == 2 && x.GetIndexParameters().All(q => q.ParameterType == typeof(int))); return p == null ? null : p.GetValue(coll, new object[] { r, c }); }

    // ───────────────────────── 대화상자 감시 (Win32 #32770) ─────────────────────────
    // 2026-11-13 수정 모드 실행용: 정책 "no" = 예/아니오 창이면 아니오(7), 없으면 취소(2), 그것도 없으면 기본 단추 — 저장 확인 창에서 저장하지 않기 위함
    static int WantId(IntPtr h, int defId)
    {
        if (dialogPolicy == "yes") return 6;
        if (dialogPolicy == "close")
        {
            // 화면 닫기용: "…이 화면을 닫으시겠습니까?"(MSG00013 — 예 = 저장 없이 닫기)에만 예. 그 밖의 창(저장 확인 등)은 아래 "no" 와 같게 아니오/취소.
            var sb = new StringBuilder();
            EnumChildWindows(h, (c, l) => { var cls = new StringBuilder(64); GetClassName(c, cls, 64); if (cls.ToString() != "Button") { var t = new StringBuilder(1024); GetWindowText(c, t, 1024); sb.Append(t).Append(' '); } return true; }, IntPtr.Zero);
            string tx = sb.ToString();
            if (tx.Contains("닫으시겠습니까") || tx.IndexOf("close this", StringComparison.OrdinalIgnoreCase) >= 0) return 6;
        }
        if (dialogPolicy == "cancel")
        {
            // 11-16 취소 우선(없으면 아니오): "저장하지 않고 바로 열겠습니까?"(MSG00100 예/아니오/취소) 에서 Excel 을 열지 않기 위함
            bool no2 = false, cancel2 = false;
            EnumChildWindows(h, (c, l) => { var cls = new StringBuilder(64); GetClassName(c, cls, 64); if (cls.ToString() == "Button") { int id = GetDlgCtrlID(c); if (id == 7) no2 = true; if (id == 2) cancel2 = true; } return true; }, IntPtr.Zero);
            if (cancel2) return 2; if (no2) return 7;
        }
        if (dialogPolicy == "no" || dialogPolicy == "close")
        {
            bool no = false, cancel = false;
            EnumChildWindows(h, (c, l) => { var cls = new StringBuilder(64); GetClassName(c, cls, 64); if (cls.ToString() == "Button") { int id = GetDlgCtrlID(c); if (id == 7) no = true; if (id == 2) cancel = true; } return true; }, IntPtr.Zero);
            if (no) return 7; if (cancel) return 2;
        }
        return defId == 0 ? 1 : defId;
    }
    static void DialogLoop()
    {
        uint pid = (uint)System.Diagnostics.Process.GetCurrentProcess().Id; var seen = new HashSet<IntPtr>(); var seenAt = new Dictionary<IntPtr, DateTime>();
        while (true)
        {
            try
            {
                var found = new List<IntPtr>();
                EnumWindows((h, l) => { uint p; GetWindowThreadProcessId(h, out p); if (p == pid && IsWindowVisible(h)) { var cls = new StringBuilder(64); GetClassName(h, cls, 64); if (cls.ToString() == "#32770") found.Add(h); } return true; }, IntPtr.Zero);
                foreach (var h in found)
                {
                    if (seen.Contains(h))
                    {
                        // 눌렀는데 3초 뒤에도 남아 있으면 다시 누른다(11-13 메시지 상자 7개 잔류 실측)
                        if (dialogPolicy != "hold" && seenAt.ContainsKey(h) && (DateTime.Now - seenAt[h]).TotalSeconds > 3)
                        {
                            int di = (int)(SendMessage(h, 0x0400, IntPtr.Zero, IntPtr.Zero).ToInt64() & 0xFFFF);
                            PostMessage(h, 0x0111, (IntPtr)WantId(h, di), IntPtr.Zero); seenAt[h] = DateTime.Now;
                            // 그래도 남는 경우(11-13 실측 7건: 눌렀다고 기록됐는데 창이 남음) — 단추를 직접 누르고, 마지막에 닫기 메시지를 보낸다
                            Thread.Sleep(400);
                            if (IsWindowVisible(h))
                            {
                                IntPtr btn = IntPtr.Zero; int want = WantId(h, di);
                                EnumChildWindows(h, (c, l) => { var cls = new StringBuilder(64); GetClassName(c, cls, 64); if (cls.ToString() == "Button" && (btn == IntPtr.Zero || GetDlgCtrlID(c) == want)) btn = c; return true; }, IntPtr.Zero);
                                if (btn != IntPtr.Zero) PostMessage(btn, 0x00F5 /*BM_CLICK*/, IntPtr.Zero, IntPtr.Zero);
                                Thread.Sleep(400);
                                if (IsWindowVisible(h)) PostMessage(h, 0x0010 /*WM_CLOSE*/, IntPtr.Zero, IntPtr.Zero);
                            }
                        }
                        continue;
                    }
                    seen.Add(h); seenAt[h] = DateTime.Now;
                    Thread.Sleep(250);
                    var cap = new StringBuilder(256); GetWindowText(h, cap, 256); var texts = new List<string>(); var buttons = new List<string>();
                    EnumChildWindows(h, (c, l) => { var cls = new StringBuilder(64); GetClassName(c, cls, 64); var t = new StringBuilder(2048); GetWindowText(c, t, 2048); if (cls.ToString() == "Button") buttons.Add(t.ToString()); else if (t.Length > 0) texts.Add(t.ToString()); return true; }, IntPtr.Zero);
                    int defId = (int)(SendMessage(h, 0x0400 /*DM_GETDEFID*/, IntPtr.Zero, IntPtr.Zero).ToInt64() & 0xFFFF);
                    string action = "held";
                    if (dialogPolicy == "yes") { PostMessage(h, 0x0111 /*WM_COMMAND*/, (IntPtr)6 /*IDYES*/, IntPtr.Zero); action = "yes_button(id=6)"; }
                    else if (dialogPolicy == "no" || dialogPolicy == "close" || dialogPolicy == "cancel") { int w = WantId(h, defId); PostMessage(h, 0x0111 /*WM_COMMAND*/, (IntPtr)w, IntPtr.Zero); action = (w == 6 ? "yes_button(id=6 · 저장 없이 닫기)" : w == 7 ? "no_button(id=7)" : w == 2 ? "cancel_button(id=2)" : "default_button(id=" + w + ")"); }
                    else if (dialogPolicy == "default") { PostMessage(h, 0x0111 /*WM_COMMAND*/, (IntPtr)(defId == 0 ? 1 : defId), IntPtr.Zero); action = "default_button(id=" + (defId == 0 ? 1 : defId) + ")"; }
                    lock (dlgLock) dialogs.Add(new Dictionary<string, object> { { "at", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff") }, { "caption", cap.ToString() }, { "text", string.Join("\n", texts) }, { "buttons", buttons }, { "action", action } });
                }
                seen.RemoveWhere(x => !found.Contains(x));
            }
            catch { }
            Thread.Sleep(300);
        }
    }

    delegate bool EnumProc(IntPtr h, IntPtr l);
    [StructLayout(LayoutKind.Sequential)] struct RECT { public int Left, Top, Right, Bottom; }
    [DllImport("user32.dll")] static extern bool EnumWindows(EnumProc e, IntPtr l);
    [DllImport("user32.dll")] static extern int GetDlgCtrlID(IntPtr h);
    [DllImport("user32.dll")] static extern bool EnumChildWindows(IntPtr p, EnumProc e, IntPtr l);
    [DllImport("user32.dll")] static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
    [DllImport("user32.dll")] static extern bool IsWindowVisible(IntPtr h);
    [DllImport("user32.dll", CharSet = CharSet.Unicode)] static extern int GetWindowText(IntPtr h, StringBuilder s, int n);
    [DllImport("user32.dll", CharSet = CharSet.Unicode)] static extern int GetClassName(IntPtr h, StringBuilder s, int n);
    [DllImport("user32.dll")] static extern IntPtr SendMessage(IntPtr h, int msg, IntPtr w, IntPtr l);
    [DllImport("user32.dll")] static extern bool PostMessage(IntPtr h, int msg, IntPtr w, IntPtr l);
    [DllImport("user32.dll")] static extern bool GetWindowRect(IntPtr h, out RECT r);
    [DllImport("user32.dll")] static extern bool PrintWindow(IntPtr h, IntPtr dc, uint flags);
}
