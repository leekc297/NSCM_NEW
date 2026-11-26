/* SSP 흐름 뷰어 탐색 (2026-11-11 사용자 요청)
   - 그림의 노드·문서 안의 이름(화면 ID · PI Seq · 통합테스트 단계/ID · 업무 단계 · 배치 잡/그룹 · 프로시저 · 테이블 · 엔터티)을 클릭하면 오른쪽 상세 창에 해당 상세를 띄운다.
   - 상세 창: ◀ 이전(창 안 이력) · 본문에서 보기 ↗(해당 탭·위치로 이동) · ✕ 닫기(Esc).  Ctrl+클릭 = 창 없이 바로 이동.
   - 이동하면 화면 오른쪽 아래 「◀ 이전 위치」 버튼으로 보던 탭·화면 선택·스크롤 위치로 돌아간다(여러 번 이동하면 차례로 되돌아감).
   ssp_flow.py 가 HTML 에 그대로 끼워 넣는다. 섹션에는 data-file(원본 md 이름)이 있다. */
(function () {
  'use strict';
  var reg = new Map();          // key → {el, kind:'scr'|'head'|'row', label}
  var navStack = [];            // 이동 전 위치
  var popStack = [];            // 상세 창 안 이력
  var STAGES = ['ChangeConfirm', 'Master', 'Request', 'Plan', 'Confirm', 'Change', 'Analysis', 'Etc'];
  var groups = [];
  var RX = /JOB\.[A-Za-z0-9_]+|SYSTEMEXE:[A-Za-z0-9_]+|\b[SP]\d{2}-\d{2}\b|\bP-\d{2}\b|\b[A-Z][A-Z0-9_]{5,}\b|\b[A-Z]{3}\d{4}\b/g;

  function $(s, r) { return (r || document).querySelector(s); }
  function $$(s, r) { return Array.prototype.slice.call((r || document).querySelectorAll(s)); }
  function tabs() { return $$('section.tab'); }
  function tabOf(el) { return el.closest('section.tab'); }
  function fileOf(el) { var t = tabOf(el); return t ? (t.getAttribute('data-file') || '') : ''; }
  function txt(el) { return (el.textContent || '').replace(/\s+/g, ' ').trim(); }
  function headBefore(el, rx) {            // el 앞쪽에서 가장 가까운 제목(h3~h6)
    var e = el;
    while (e) { var p = e.previousElementSibling; while (p) { if (/^H[2-6]$/.test(p.tagName)) return p; p = p.previousElementSibling; } e = e.parentElement; if (e && e.classList && e.classList.contains('tab')) break; }
    return null;
  }
  function add(key, el, kind, label, force) { if (key && (force || !reg.has(key))) reg.set(key, { el: el, kind: kind, label: label || key }); }

  function buildRegistry() {
    $$('.scr').forEach(function (d) { var h = $('h3,h4', d); add(d.dataset.id, d, 'scr', h ? txt(h) : d.dataset.id); });
    var order = ['SSP_REF_PROCESS.md', 'SSP_BATCH_ANALYSIS.md', 'SSP_DATA_FLOW.md', 'SSP_PROCESS_FLOW.md', 'SSP_BATCH_FLOW.md', 'SSP_SHIPPLAN_FLOW.md', 'SSP_DATA_FLOW_DETAIL.md'];
    order.forEach(function (file) {
      var sec = tabs().filter(function (t) { return t.getAttribute('data-file') === file; })[0]; if (!sec) return;
      var cur3 = '', cur4 = '';
      $$('h3,h4,h5,h6,table', sec).forEach(function (el) {
        var t = txt(el);
        if (el.tagName === 'H3') { cur3 = t; cur4 = ''; return; }
        if (el.tagName === 'H4') {
          cur4 = t;
          if (file === 'SSP_BATCH_ANALYSIS.md' && /^3\. 잡별 상세/.test(cur3)) { add('JOB:' + t, el, 'head', t); if (/^JOB\./.test(t)) add('JOB:' + t.slice(4), el, 'head', t); }
          if (file === 'SSP_BATCH_ANALYSIS.md' && /^2\. 배치 인벤토리/.test(cur3)) { var m = t.match(/^(.+?) \((\d+)\)$/); if (m) { add('GRP:' + m[1], el, 'head', t); groups.push(m[1]); } }
          if (file === 'SSP_REF_PROCESS.md' && /^[①-⑳]/.test(t)) add('IT:' + t.split(/\s/)[0], el, 'head', t);   // 2026-11-16 V2 단계 ⑤-1~⑤-4: 첫 글자 대신 첫 단어
          if (file === 'SSP_SHIPPLAN_FLOW.md' && /^4\. 사업부별 산출 흐름/.test(cur3)) {   // Shipment Plan 산출 흐름: 사업부 절
            var dk = /^40 /.test(t) ? 'DIV_40' : (/^81 계열/.test(t) ? 'DIV_8X' : (/^전극/.test(t) ? 'DIV_EE' : (/^Packer/.test(t) ? 'DIV_P' : null)));
            if (dk) add('DIV:' + dk, el, 'head', t);
          }
          return;
        }
        if (el.tagName === 'H5') {
          var ms = t.match(/^([A-Za-z]+) \(\d+화면\)$/);
          if (ms && (file === 'SSP_DATA_FLOW.md' || file === 'SSP_PROCESS_FLOW.md')) add('ST:' + file + ':' + ms[1], el, 'head', t + (file === 'SSP_DATA_FLOW.md' ? ' — 데이터 흐름' : ' — 화면 의존'));
          return;
        }
        if (el.tagName !== 'TABLE') return;
        var kind = null;
        if (file === 'SSP_REF_PROCESS.md' && /^1-1\. Seq 별 대응/.test(cur4)) kind = 'PI:';
        else if (file === 'SSP_REF_PROCESS.md' && (/^[①-⑳]/.test(cur4) || /^사전 점검/.test(cur4))) kind = '';
        else if (file === 'SSP_BATCH_ANALYSIS.md' && /^5\. PR_SSP/.test(cur3)) kind = 'P:';
        else if (file === 'SSP_DATA_FLOW.md' && /^3\. SSP 테이블별/.test(cur3)) kind = 'T:';
        else if (file === 'SSP_DATA_FLOW.md' && /^2-2\. 엔터티 군/.test(cur4)) kind = 'E:';
        else if (file === 'SSP_DATA_FLOW_DETAIL.md') kind = 'P:';
        if (kind === null) return;
        $$('tbody tr', el).forEach(function (tr) {
          var c = tr.cells[0]; if (!c) return; var k = txt(c); if (!k) return;
          if (kind === '' && !/^[SP]\d{2}-\d{2}$|^P-\d{2}$/.test(k)) return;
          var lab = kind === 'PI:' ? 'PI Seq ' + k : (kind === 'P:' ? '프로시저 ' + k : (kind === 'T:' ? '테이블 ' + k : (kind === 'E:' ? '엔터티 ' + k : '통합테스트 ' + k)));
          add(kind + k, tr, 'row', lab);
        });
      });
    });
  }

  function resolve(w) {                     // 문서 안 낱말 → 등록 키
    if (reg.has(w) && /^[A-Z]{3}\d{4}$/.test(w)) return w;
    if (/^[SP]\d{2}-\d{2}$|^P-\d{2}$/.test(w)) return reg.has(w) ? w : null;
    if (/^JOB\.|^SYSTEMEXE:/.test(w)) return reg.has('JOB:' + w) ? 'JOB:' + w : null;
    if (reg.has('P:' + w)) return 'P:' + w;
    if (reg.has('T:' + w)) return 'T:' + w;
    if (/_SN$/.test(w) && reg.has('T:' + w.slice(0, -3))) return 'T:' + w.slice(0, -3);
    if (reg.has('T:' + w + '_SN')) return 'T:' + w + '_SN';
    if (reg.has('JOB:' + w)) return 'JOB:' + w;
    return null;
  }

  function linkify(root) {                  // 글자 안의 이름을 클릭 가능한 표시로 감싼다(한 번만)
    if (!root || root.getAttribute('data-lk')) return; root.setAttribute('data-lk', '1');
    var walker = document.createTreeWalker(root, NodeFilter.SHOW_TEXT, {
      acceptNode: function (n) {
        var p = n.parentNode; if (!p || !n.nodeValue || n.nodeValue.length < 5) return NodeFilter.FILTER_REJECT;
        if (p.closest('script,style,select,option,.lnk,.scrbar,h2')) return NodeFilter.FILTER_REJECT;
        if (p.closest('svg') && !p.closest('foreignObject')) return NodeFilter.FILTER_REJECT;
        return NodeFilter.FILTER_ACCEPT;
      }
    });
    var nodes = []; var n; while ((n = walker.nextNode())) nodes.push(n);
    nodes.forEach(function (node) {
      var s = node.nodeValue; RX.lastIndex = 0; var m, last = 0, frag = null;
      while ((m = RX.exec(s))) {
        var key = resolve(m[0]); if (!key) continue;
        var tgt = reg.get(key).el;
        if (tgt.contains(node) && (reg.get(key).kind !== 'head')) continue;       // 자기 자신(같은 화면 상세·같은 행)으로 가는 링크는 만들지 않는다
        if (reg.get(key).kind === 'head' && tgt === node.parentNode.closest('h3,h4,h5,h6')) continue;
        if (!frag) frag = document.createDocumentFragment();
        if (m.index > last) frag.appendChild(document.createTextNode(s.slice(last, m.index)));
        var a = document.createElement('span'); a.className = 'lnk'; a.setAttribute('data-k', key); a.textContent = m[0]; a.title = '클릭: 상세 보기 · Ctrl+클릭: 본문 위치로 이동';
        frag.appendChild(a); last = m.index + m[0].length;
      }
      if (frag) { if (last < s.length) frag.appendChild(document.createTextNode(s.slice(last))); node.parentNode.replaceChild(frag, node); }
    });
  }

  function tagNodes() {                     // 그림의 노드 전체를 클릭 대상으로(이름이 글자로 안 잡히는 것: PI Seq · 통합테스트 단계 · 업무 단계 · 배치 그룹 · 잡)
    $$('pre.mermaid g.node').forEach(function (g) {
      var lab = txt(g), file = fileOf(g), key = null, m;
      // 종류별 기본 색(그림이 색을 따로 정하지 않은 노드만 CSS 로 칠해진다): 화면 · 프로시저 · 테이블 · 잡
      var kd = (g.id || '').indexOf('-J_') >= 0 ? 'JOB' : (/^(?:◀\s*)?[A-Z]{3}\d{4}(?![0-9A-Z_])/.test(lab) ? 'scr' : (/^(?:PR|SP|USP|FN|UF)_[A-Z0-9_]+/.test(lab) ? 'P' : (/^[A-Z][A-Z0-9]*(?:_[A-Z0-9]+)+(?![a-z])/.test(lab) ? 'T' : null)));
      if (kd) g.classList.add('k-' + kd);
      if (file === 'SSP_REF_PROCESS.md' && (m = lab.match(/^(\d+(?:-\d+)?)\.\s/)) && reg.has('PI:' + m[1])) key = 'PI:' + m[1];
      else if (/^[①-⑳]/.test(lab) && reg.has('IT:' + lab.split(/\s/)[0])) key = 'IT:' + lab.split(/\s/)[0];
      else if ((m = (g.id || '').match(/-(DIV_[A-Z0-9]+)-/)) && reg.has('DIV:' + m[1])) key = 'DIV:' + m[1];   // Shipment Plan 전체 흐름의 사업부 상자 → 그 사업부 산출 흐름
      else if ((g.id || '').indexOf('-J_') >= 0) {
        var first = lab.replace(/\s*\(off\)\s*$/, '');
        var cands = Array.from(reg.keys()).filter(function (k) { return k.indexOf('JOB:') === 0; });
        var hit = cands.filter(function (k) { var nm = k.slice(4).replace(/^JOB\./, '').replace(/^SYSTEMEXE:/, '⏱'); return first.indexOf(nm) === 0; }).sort(function (a, b) { return b.length - a.length; })[0];
        if (hit) key = hit;
      }
      if (!key) {
        var st = STAGES.filter(function (s) { return new RegExp('^(?:◀\\s*)?' + s + '(?![A-Za-z])').test(lab); })[0];
        if (st) {
          var pref = (file === 'SSP_DATA_FLOW.md' || file === 'SSP_PROCESS_FLOW.md') ? file : 'SSP_PROCESS_FLOW.md';
          key = reg.has('ST:' + pref + ':' + st) ? 'ST:' + pref + ':' + st : (reg.has('ST:SSP_DATA_FLOW.md:' + st) ? 'ST:SSP_DATA_FLOW.md:' + st : null);
        }
      }
      if (!key) { var gp = groups.filter(function (x) { return lab.indexOf(x) === 0; })[0]; if (gp) key = 'GRP:' + gp; }
      if (!key && (m = lab.match(/^([A-Z]{3}\d{4})(?![0-9A-Z_])/)) && reg.has(m[1])) key = m[1];
      if (!key) { var ek = Array.from(reg.keys()).filter(function (k) { return k.indexOf('E:') === 0 && lab.indexOf(k.slice(2)) === 0; }).sort(function (x, y) { return y.length - x.length; })[0]; if (ek) key = ek; }
      if (key) {
        var tgt = reg.get(key).el; if (tgt.contains(g) && reg.get(key).kind === 'scr') return;
        g.setAttribute('data-k', key); g.classList.add('nlnk');
        if (!kd && /^(ST|GRP|E):/.test(key)) g.classList.add('k-' + key.split(':')[0]);
        var tt = document.createElementNS('http://www.w3.org/2000/svg', 'title'); tt.textContent = '클릭: ' + reg.get(key).label + ' 상세 보기 · Ctrl+클릭: 본문 위치로 이동'; g.appendChild(tt);
      }
    });
  }

  /* ── 상세 창 ─────────────────────────────────────────── */
  var pop, popBody, popTitle, popBack, backBtn;
  function buildUi() {
    pop = document.createElement('div'); pop.id = 'navpop';
    pop.innerHTML = '<div class="np-bar"><button class="np-back" title="상세 창에서 바로 전에 보던 항목">◀ 이전</button><span class="np-title"></span>' +
      '<button class="np-jump" title="이 항목이 있는 탭·위치로 이동(돌아올 때는 오른쪽 아래 「이전 위치」)">본문에서 보기 ↗</button><button class="np-close" title="닫기(Esc)">✕</button></div><div class="np-body"></div>';
    document.body.appendChild(pop);
    popBody = $('.np-body', pop); popTitle = $('.np-title', pop); popBack = $('.np-back', pop);
    $('.np-close', pop).onclick = closePop;
    popBack.onclick = function () { if (popStack.length > 1) { popStack.pop(); renderPop(popStack[popStack.length - 1]); } };
    $('.np-jump', pop).onclick = function () { var k = popStack[popStack.length - 1]; closePop(); jump(k); };
    backBtn = document.createElement('button'); backBtn.id = 'navback'; backBtn.onclick = goBack; document.body.appendChild(backBtn);
    document.addEventListener('keydown', function (e) { if (e.key === 'Escape' && pop.classList.contains('on')) closePop(); });
    document.addEventListener('click', function (e) {
      var t = e.target.closest ? e.target.closest('[data-k]') : null; if (!t) return;
      var dv = t.closest('[data-k^="DIV:"],.spf-card[data-k]'); if (dv) t = dv;   // 사업부 상자는 안의 테이블 이름을 눌러도 사업부 상세를 연다
      var k = t.getAttribute('data-k'); if (!reg.has(k)) return;
      e.preventDefault(); e.stopPropagation();
      if (e.ctrlKey || e.metaKey) { closePop(); jump(k); } else openPop(k);
    }, true);
    refreshBack();
  }
  function sectionClone(h) {                // 제목 + 다음 같은/상위 제목 전까지
    var lv = parseInt(h.tagName.slice(1), 10), box = document.createElement('div'), e = h;
    while (e) { box.appendChild(e.cloneNode(true)); e = e.nextElementSibling; if (e && /^H[2-6]$/.test(e.tagName) && parseInt(e.tagName.slice(1), 10) <= lv) break; }
    return box;
  }
  function rowCard(tr) {                    // 표의 한 행 → 항목/내용 세로 표
    var tb = tr.closest('table'), heads = $$('thead th', tb).map(txt), t = document.createElement('table'); t.className = 'np-card';
    Array.prototype.forEach.call(tr.cells, function (c, i) {
      var r = t.insertRow(), th = document.createElement('th'); th.textContent = heads[i] || ('칸' + (i + 1)); r.appendChild(th);
      var td = r.insertCell(); td.innerHTML = c.innerHTML;
    });
    var box = document.createElement('div'), hb = headBefore(tb);
    if (hb) { var p = document.createElement('p'); p.className = 'np-src'; p.textContent = '출처: ' + (tabOf(tr) ? txt($('h2', tabOf(tr))) : '') + ' › ' + txt(hb); box.appendChild(p); }
    box.appendChild(t); return box;
  }
  function renderPop(k) {
    var it = reg.get(k); popTitle.textContent = it.label; popBody.innerHTML = '';
    var c = it.kind === 'scr' ? it.el.cloneNode(true) : (it.kind === 'head' ? sectionClone(it.el) : rowCard(it.el));
    if (k.indexOf('JOB:') === 0) {         // 잡 = 분석서 상세 + 배치 흐름 탭의 그 잡 그림(스텝 → SP → 엔터티)
      var jt = txt(it.el), fh = $$('section.tab[data-file="SSP_BATCH_FLOW.md"] h4').filter(function (h) { return txt(h) === jt; })[0];
      if (fh) { var cap = document.createElement('p'); cap.className = 'np-src'; cap.textContent = '아래 그림 = 배치 흐름 탭의 같은 잡'; c.appendChild(cap); c.appendChild(sectionClone(fh)); }
    }
    if (c.classList) c.classList.remove('off');
    $$('[id]', c).forEach(function (x) { if (!x.closest('svg')) x.removeAttribute('id'); });
    c.removeAttribute && c.removeAttribute('data-lk'); $$('[data-lk]', c).forEach(function (x) { x.removeAttribute('data-lk'); });
    popBody.appendChild(c); linkify(popBody); popBody.removeAttribute('data-lk'); popBody.scrollTop = 0;
    $$('.lnk', popBody).forEach(function (a) { if (a.getAttribute('data-k') === k) a.replaceWith(document.createTextNode(a.textContent)); });   // 지금 보고 있는 항목 자신으로 가는 링크는 푼다
    $$('g.nlnk', popBody).forEach(function (g) { if (g.getAttribute('data-k') === k) { g.removeAttribute('data-k'); g.classList.remove('nlnk'); } });
    popBack.disabled = popStack.length < 2; popBack.textContent = '◀ 이전' + (popStack.length > 1 ? ' (' + (popStack.length - 1) + ')' : '');
  }
  function openPop(k) { if (popStack[popStack.length - 1] !== k) popStack.push(k); pop.classList.add('on'); renderPop(k); }
  function closePop() { pop.classList.remove('on'); popStack = []; }

  /* ── 이동 · 이전 위치 ─────────────────────────────────── */
  function state() { var s = $('#scrSel'); return { tab: tabs().findIndex(function (t) { return t.classList.contains('on'); }), scr: s ? s.value : null, y: window.scrollY, x: window.scrollX }; }
  function refreshBack() { backBtn.style.display = navStack.length ? 'block' : 'none'; backBtn.textContent = '◀ 이전 위치' + (navStack.length > 1 ? ' (' + navStack.length + ')' : ''); backBtn.title = '이동하기 전에 보던 탭·위치로 돌아갑니다'; }
  function flash(el) { el.classList.add('navflash'); setTimeout(function () { el.classList.remove('navflash'); }, 2200); }
  function jump(k) {
    var it = reg.get(k); if (!it) return;
    navStack.push(state()); refreshBack();
    var sec = tabOf(it.el), idx = tabs().indexOf(sec); if (idx >= 0) window.show(idx);
    var scr = it.el.closest('.scr'); if (scr && window.pickScr) window.pickScr(scr.dataset.id);
    var tgt = it.kind === 'scr' ? it.el : it.el;
    setTimeout(function () { var bar = $('.scrbar', sec), off = (bar ? bar.offsetHeight : 0) + 12; var y = tgt.getBoundingClientRect().top + window.scrollY - off; window.scrollTo(0, Math.max(0, y)); flash(tgt); }, 30);
  }
  function goBack() {
    var s = navStack.pop(); refreshBack(); if (!s) return;
    if (s.tab >= 0) window.show(s.tab);
    if (s.scr !== null && window.pickScr) window.pickScr(s.scr, 1);
    setTimeout(function () { window.scrollTo(s.x, s.y); }, 30);
  }

  window.SSPNav = {
    init: function () {
      buildRegistry(); buildUi(); tagNodes();
      var show0 = window.show;
      window.show = function (i) { show0(i); var t = tabs()[i]; if (t) linkify(t); };
      var cur = tabs().findIndex(function (t) { return t.classList.contains('on'); }); if (cur >= 0) linkify(tabs()[cur]);
      window.SSPNav.size = reg.size;
    },
    open: openPop, jump: jump, back: goBack, reg: reg
  };
})();
