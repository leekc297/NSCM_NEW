/* SSP 흐름 뷰어 화면 틀 (2026-11-23 사용자 요청 '보기가 쉽지 않다 · 분석하기 쉽게 다시 정리')
   - 왼쪽 목차(묶음 → 항목) · 본문에는 고른 항목의 절만 보인다. 절 상자(div.sx4[data-b])와 목차(window.SSP_NAV)는 ssp_shell.py 가 만든다.
   - 목차 위 검색: 절 제목 + 탐색 등록 이름(화면 ID · 잡 · 프로시저 · 테이블 · 테스트 ID)
   - 항목에 pick 이 있으면 소절(잡 · 사업부)을 드롭다운으로 1개씩 본다. fold 가 있으면 30행 넘는 표를 접어서 시작한다.
   - 주소 #i=<항목> · #<화면ID> 로 바로 열기. 탐색(ssp_flow_nav.js)의 이동 · 이전 위치는 SSPShell.reveal / cur / go 를 쓴다. */
(function () {
  'use strict';
  var NAV = window.SSP_NAV || [], items = [], byId = {}, blockItem = {}, cur = null, curPick = null;
  function $(s, r) { return (r || document).querySelector(s); }
  function $$(s, r) { return Array.prototype.slice.call((r || document).querySelectorAll(s)); }
  function esc(s) { return String(s).replace(/[&<>"]/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]; }); }

  function buildTree() {
    var box = $('#sdtree'), h = '';
    NAV.forEach(function (g, gi) {
      h += '<div class="sd-g" data-g="' + gi + '"><button class="sd-gh"><span class="sd-n">' + (gi + 1) + '</span>' + esc(g.g) + '<i>' + g.items.length + '</i></button><div class="sd-gi">';
      g.items.forEach(function (it) {
        it.g = g.g; it.gi = gi; items.push(it); byId[it.id] = it;
        it.b.forEach(function (b) { if (!blockItem[b]) blockItem[b] = it.id; });
        h += '<button class="sd-i" data-i="' + it.id + '" title="' + esc(it.d || '') + '">' + esc(it.t) + '</button>';
      });
      h += '</div></div>';
    });
    box.innerHTML = h;
    box.addEventListener('click', function (e) {
      var gh = e.target.closest('.sd-gh'); if (gh) { gh.parentNode.classList.toggle('shut'); return; }
      var b = e.target.closest('.sd-i'); if (b) go(b.getAttribute('data-i'));
    });
  }

  var ALL = '전체';
  function picks(it) {                       // pick 항목의 소절 제목(문서 순서 · 중복 제거) · pick 5 = 소절 안 h5 상자
    var seen = {}, out = [];
    it.b.forEach(function (b) {
      var el = $('.sx4[data-b="' + b + '"]'); if (!el) return;
      (it.pick === 5 ? $$('.sx5', el) : [el]).forEach(function (x) { var t = x.getAttribute('data-t'); if (t && !seen[t]) { seen[t] = 1; out.push(t); } });
    });
    if (it.pickAll && out.length) out.push(ALL);   // 처음에는 첫 소절 1개 · 맨 끝에 전체
    return out;
  }
  function foldTables(root) {                // 근거 표: 30행 넘으면 접어서 시작(제목 + 행 수)
    $$('table', root).forEach(function (t) {
      if (t.closest('details.fold') || !t.tBodies[0] || t.tBodies[0].rows.length <= 30) return;
      var w = t.closest('.tbl-scroll') || t, cap = w.previousElementSibling && w.previousElementSibling.classList.contains('tbl-cap') ? w.previousElementSibling : null;
      var d = document.createElement('details'); d.className = 'fold';
      var s = document.createElement('summary'); s.textContent = '표 ' + t.tBodies[0].rows.length + '행 펼치기'; d.appendChild(s);
      w.parentNode.insertBefore(d, cap || w); if (cap) d.appendChild(cap); d.appendChild(w);
    });
  }

  function apply(it) {
    var on = {}; it.b.forEach(function (b) { on[b] = 1; });
    $$('.sx4').forEach(function (el) {
      var show = !!on[el.getAttribute('data-b')];
      if (show && it.pick === 1 && curPick && curPick !== ALL && el.getAttribute('data-t') && el.getAttribute('data-t') !== curPick) show = false;
      el.classList.toggle('off', !show);
      if (show) $$('.sx5', el).forEach(function (x) { x.classList.toggle('off', it.pick === 5 && !!curPick && x.getAttribute('data-t') !== curPick); });
    });
    $$('.sx').forEach(function (el) { el.classList.toggle('off', !$('.sx4:not(.off)', el)); });
    $$('section.tab').forEach(function (el) { el.classList.toggle('on', !!$('.sx:not(.off)', el)); });
  }

  function go(id, opt) {
    var it = byId[id]; if (!it) return; opt = opt || {};
    cur = id;
    var pk = it.pick ? picks(it) : [];
    curPick = it.pick ? (opt.pick && pk.indexOf(opt.pick) >= 0 ? opt.pick : (pk[0] || null)) : null;
    apply(it);
    $$('.sd-i').forEach(function (b) { b.classList.toggle('on', b.getAttribute('data-i') === id); });
    var g = $('.sd-g[data-g="' + it.gi + '"]'); if (g) g.classList.remove('shut');
    var ab = $('.sd-i.on'); if (ab && ab.scrollIntoViewIfNeeded) ab.scrollIntoViewIfNeeded(false);
    $('#crumbtxt').innerHTML = '<b>' + esc(it.g) + '</b> › ' + esc(it.t);
    $('#itemhead').innerHTML = '<h2>' + esc(it.t) + '</h2><p>' + esc(it.d || '') + ' <small>원문: ' + esc((it.src || []).join(', ')) + '</small></p>';
    var pb = $('#pickbar');
    if (pk.length) {
      pb.innerHTML = '<label>' + esc(it.pickLabel || '선택') + ' <select id="pickSel">' + pk.map(function (t) { return '<option' + (t === curPick ? ' selected' : '') + '>' + esc(t) + '</option>'; }).join('') + '</select></label> <small>' + pk.length + '개 중 1개씩 표시</small>';
      $('#pickSel').onchange = function () { curPick = this.value; apply(it); after(it); };
      pb.style.display = '';
    } else { pb.innerHTML = ''; pb.style.display = 'none'; }
    after(it);
    var i = items.indexOf(it); $('#prevI').disabled = i <= 0; $('#nextI').disabled = i >= items.length - 1;
    if (!opt.keep) window.scrollTo(0, 0);
    if (!opt.noHash) { try { history.replaceState(null, '', '#i=' + id); } catch (e) { } }
  }
  function after(it) {
    var m = $('#main');
    if (it.fold) foldTables(m);
    if (window.SSPNav && window.SSPNav.linkify) $$('section.tab.on').forEach(function (s) { window.SSPNav.linkify(s); });
    if (window.SSPView && window.SSPView.refit) window.SSPView.refit(m);
  }

  function reveal(el) {                      // el 이 든 절을 연다(탐색의 「본문에서 보기」)
    var b = el.closest ? el.closest('.sx4') : null; if (!b) return false;
    var id = blockItem[b.getAttribute('data-b')]; if (!id) return false;
    var b5 = el.closest('.sx5'), it = byId[id];
    go(id, { keep: 1, pick: (it.pick === 5 ? (b5 && b5.getAttribute('data-t')) : b.getAttribute('data-t')) || null });   // 대상이 든 소절을 고른다(머리글 쪽이면 첫 소절)
    return true;
  }

  function search(q) {
    var box = $('#sdres'); q = q.trim().toLowerCase();
    if (q.length < 2) { box.innerHTML = ''; box.style.display = 'none'; return; }
    var h = '', n = 0;
    items.forEach(function (it) { if ((it.t + ' ' + (it.d || '')).toLowerCase().indexOf(q) >= 0) { h += '<button data-i="' + it.id + '"><b>절</b> ' + esc(it.g) + ' › ' + esc(it.t) + '</button>'; n++; } });
    $$('.sx4').forEach(function (el) {       // 소절 제목(잡 이름 · 사업부 · 슬라이드 등)
      var t = el.getAttribute('data-t'); if (!t || n > 60 || t.toLowerCase().indexOf(q) < 0) return;
      var id = blockItem[el.getAttribute('data-b')]; if (!id) return;
      h += '<button data-i="' + id + '" data-p="' + esc(t) + '" data-b="' + el.getAttribute('data-b') + '"><b>소절</b> ' + esc(byId[id].t) + ' › ' + esc(t) + '</button>'; n++;
    });
    if (window.SSPNav && window.SSPNav.reg) window.SSPNav.reg.forEach(function (v, k) {
      if (n > 60) return; if ((k + ' ' + v.label).toLowerCase().indexOf(q) < 0) return;
      h += '<button data-k="' + esc(k) + '"><b>이름</b> ' + esc(v.label) + '</button>'; n++;
    });
    box.innerHTML = h || '<div class="sd-none">찾는 이름 없음</div>'; box.style.display = 'block';
  }

  function fromHash() {
    var h = decodeURIComponent((location.hash || '').slice(1)), s = $('#scrSel');
    if (/^i=/.test(h) && byId[h.slice(2)]) { go(h.slice(2), { noHash: 1 }); return true; }
    if (h && s && Array.prototype.some.call(s.options, function (o) { return o.value === h; })) {
      var d = $('.scr[data-id="' + h + '"]'); if (d && reveal(d)) { window.pickScr(h); return true; }
    }
    return false;
  }

  window.SSPShell = {
    init: function () {
      buildTree();
      $$('.spf-fold').forEach(function (m) {     // 새 그림 아래의 옛 자동 배치 그래프는 접어 둔다(ssp_svg.fold_next)
        var nx = m.nextElementSibling; if (!nx || !nx.matches('pre.mermaid')) return;
        var d = document.createElement('details'); d.className = 'fold'; var sm = document.createElement('summary'); sm.textContent = m.getAttribute('data-label') || '그래프로 보기'; d.appendChild(sm);
        m.parentNode.insertBefore(d, m); d.appendChild(nx); m.style.display = 'none';
        d.addEventListener('toggle', function () { if (d.open && window.SSPView) window.SSPView.refit(d); });
      });
      $('#sdq').addEventListener('input', function () { search(this.value); });
      $('#sdres').addEventListener('click', function (e) {
        var b = e.target.closest('button'); if (!b) return;
        if (b.getAttribute('data-k')) { window.SSPNav.open(b.getAttribute('data-k')); return; }
        go(b.getAttribute('data-i'), { pick: b.getAttribute('data-p') });
        var el = b.getAttribute('data-b') && $('.sx4[data-b="' + b.getAttribute('data-b') + '"]');
        if (el && !byId[b.getAttribute('data-i')].pick) setTimeout(function () { el.scrollIntoView({ block: 'start' }); window.scrollBy(0, -60); }, 30);
      });
      $('#prevI').onclick = function () { var i = items.indexOf(byId[cur]); if (i > 0) go(items[i - 1].id); };
      $('#nextI').onclick = function () { var i = items.indexOf(byId[cur]); if (i < items.length - 1) go(items[i + 1].id); };
      $('#sdtoggle').onclick = function () { document.body.classList.toggle('noside'); if (window.SSPView) setTimeout(function () { window.SSPView.refit($('#main')); }, 50); };
      document.documentElement.style.setProperty('--navh', $('#crumb').offsetHeight + 'px');
      if (!fromHash() && items.length) go(items[0].id, { noHash: 1 });
      window.addEventListener('hashchange', fromHash);
      document.body.classList.add('ready');
    },
    go: go, reveal: reveal, cur: function () { return { id: cur, pick: curPick }; }, items: items
  };
})();
