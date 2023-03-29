(function(){const t=document.createElement("link").relList;if(t&&t.supports&&t.supports("modulepreload"))return;for(const i of document.querySelectorAll('link[rel="modulepreload"]'))r(i);new MutationObserver(i=>{for(const s of i)if(s.type==="childList")for(const u of s.addedNodes)u.tagName==="LINK"&&u.rel==="modulepreload"&&r(u)}).observe(document,{childList:!0,subtree:!0});function n(i){const s={};return i.integrity&&(s.integrity=i.integrity),i.referrerpolicy&&(s.referrerPolicy=i.referrerpolicy),i.crossorigin==="use-credentials"?s.credentials="include":i.crossorigin==="anonymous"?s.credentials="omit":s.credentials="same-origin",s}function r(i){if(i.ep)return;i.ep=!0;const s=n(i);fetch(i.href,s)}})();function I(){}function me(e){return e()}function le(){return Object.create(null)}function K(e){e.forEach(me)}function pe(e){return typeof e=="function"}function _e(e,t){return e!=e?t==t:e!==t||e&&typeof e=="object"||typeof e=="function"}function ve(e){return Object.keys(e).length===0}function d(e,t){e.appendChild(t)}function W(e,t,n){e.insertBefore(t,n||null)}function b(e){e.parentNode.removeChild(e)}function y(e){return document.createElement(e)}function O(e){return document.createElementNS("http://www.w3.org/2000/svg",e)}function S(e){return document.createTextNode(e)}function E(){return S(" ")}function se(e,t,n,r){return e.addEventListener(t,n,r),()=>e.removeEventListener(t,n,r)}function o(e,t,n){n==null?e.removeAttribute(t):e.getAttribute(t)!==n&&e.setAttribute(t,n)}function $e(e){return Array.from(e.childNodes)}function fe(e,t){t=""+t,e.wholeText!==t&&(e.data=t)}let j;function Se(){if(j===void 0){j=!1;try{typeof window<"u"&&window.parent&&window.parent.document}catch{j=!0}}return j}function Ae(e,t){getComputedStyle(e).position==="static"&&(e.style.position="relative");const r=y("iframe");r.setAttribute("style","display: block; position: absolute; top: 0; left: 0; width: 100%; height: 100%; overflow: hidden; border: 0; opacity: 0; pointer-events: none; z-index: -1;"),r.setAttribute("aria-hidden","true"),r.tabIndex=-1;const i=Se();let s;return i?(r.src="data:text/html,<script>onresize=function(){parent.postMessage(0,'*')}<\/script>",s=se(window,"message",u=>{u.source===r.contentWindow&&t()})):(r.src="about:blank",r.onload=()=>{s=se(r.contentWindow,"resize",t)}),d(e,r),()=>{(i||s&&r.contentWindow)&&s(),b(r)}}let V;function D(e){V=e}const N=[],ue=[],B=[],de=[],Ce=Promise.resolve();let J=!1;function Ee(){J||(J=!0,Ce.then(ye))}function G(e){B.push(e)}const Y=new Set;let F=0;function ye(){const e=V;do{for(;F<N.length;){const t=N[F];F++,D(t),We(t.$$)}for(D(null),N.length=0,F=0;ue.length;)ue.pop()();for(let t=0;t<B.length;t+=1){const n=B[t];Y.has(n)||(Y.add(n),n())}B.length=0}while(N.length);for(;de.length;)de.pop()();J=!1,Y.clear(),D(e)}function We(e){if(e.fragment!==null){e.update(),K(e.before_update);const t=e.dirty;e.dirty=[-1],e.fragment&&e.fragment.p(e.ctx,t),e.after_update.forEach(G)}}const q=new Set;let He;function Q(e,t){e&&e.i&&(q.delete(e),e.i(t))}function ce(e,t,n,r){if(e&&e.o){if(q.has(e))return;q.add(e),He.c.push(()=>{q.delete(e),r&&(n&&e.d(1),r())}),e.o(t)}else r&&r()}function ae(e){e&&e.c()}function R(e,t,n,r){const{fragment:i,after_update:s}=e.$$;i&&i.m(t,n),r||G(()=>{const u=e.$$.on_mount.map(me).filter(pe);e.$$.on_destroy?e.$$.on_destroy.push(...u):K(u),e.$$.on_mount=[]}),s.forEach(G)}function U(e,t){const n=e.$$;n.fragment!==null&&(K(n.on_destroy),n.fragment&&n.fragment.d(t),n.on_destroy=n.fragment=null,n.ctx=[])}function Le(e,t){e.$$.dirty[0]===-1&&(N.push(e),Ee(),e.$$.dirty.fill(0)),e.$$.dirty[t/31|0]|=1<<t%31}function we(e,t,n,r,i,s,u,w=[-1]){const _=V;D(e);const c=e.$$={fragment:null,ctx:[],props:s,update:I,not_equal:i,bound:le(),on_mount:[],on_destroy:[],on_disconnect:[],before_update:[],after_update:[],context:new Map(t.context||(_?_.$$.context:[])),callbacks:le(),dirty:w,skip_bound:!1,root:t.target||_.$$.root};u&&u(c.root);let p=!1;if(c.ctx=n?n(e,t.props||{},(g,A,...H)=>{const f=H.length?H[0]:A;return c.ctx&&i(c.ctx[g],c.ctx[g]=f)&&(!c.skip_bound&&c.bound[g]&&c.bound[g](f),p&&Le(e,g)),A}):[],c.update(),p=!0,K(c.before_update),c.fragment=r?r(c.ctx):!1,t.target){if(t.hydrate){const g=$e(t.target);c.fragment&&c.fragment.l(g),g.forEach(b)}else c.fragment&&c.fragment.c();t.intro&&Q(e.$$.fragment),R(e,t.target,t.anchor,t.customElement),ye()}D(_)}class be{$destroy(){U(this,1),this.$destroy=I}$on(t,n){if(!pe(n))return I;const r=this.$$.callbacks[t]||(this.$$.callbacks[t]=[]);return r.push(n),()=>{const i=r.indexOf(n);i!==-1&&r.splice(i,1)}}$set(t){this.$$set&&!ve(t)&&(this.$$.skip_bound=!0,this.$$set(t),this.$$.skip_bound=!1)}}function ke(e){let t,n;return{c(){t=O("svg"),n=O("rect"),o(n,"width",e[0]),o(n,"height",e[1]),o(n,"style",e[2]),o(t,"width",e[0]),o(t,"height",e[1])},m(r,i){W(r,t,i),d(t,n)},p(r,[i]){i&1&&o(n,"width",r[0]),i&2&&o(n,"height",r[1]),i&4&&o(n,"style",r[2]),i&1&&o(t,"width",r[0]),i&2&&o(t,"height",r[1])},i:I,o:I,d(r){r&&b(t)}}}function ze(e,t,n){let{legendWidth:r}=t,{legendHeight:i}=t,{legendStyle:s}=t;return e.$$set=u=>{"legendWidth"in u&&n(0,r=u.legendWidth),"legendHeight"in u&&n(1,i=u.legendHeight),"legendStyle"in u&&n(2,s=u.legendStyle)},[r,i,s]}class he extends be{constructor(t){super(),we(this,t,ze,ke,_e,{legendWidth:0,legendHeight:1,legendStyle:2})}}function Me(e){let t,n,r,i,s,u,w,_,c,p,g,A,H,f,L,M,v,k,X,Z,x,z,ee,te,ne,re,C,$,m,P,ie,T,oe,h;return k=new he({props:{legendWidth:20,legendHeight:12,legendStyle:"fill:#32408F;"}}),z=new he({props:{legendWidth:20,legendHeight:12,legendStyle:"fill:gray;"}}),{c(){t=y("h1"),n=y("span"),r=S("You completed "),i=S(e[0]),s=S("%"),u=S(" out of a 24 hour day"),w=E(),_=y("br"),c=E(),p=y("h2"),g=S("\u231A "),A=S(e[3]),H=E(),f=y("div"),L=y("br"),M=E(),v=y("div"),ae(k.$$.fragment),X=S(`
    Part of the day completed
    `),Z=y("br"),x=E(),ae(z.$$.fragment),ee=S(`
    What's left of the day`),te=E(),ne=y("br"),re=E(),C=O("svg"),$=O("circle"),m=O("circle"),ie=E(),T=y("div"),T.innerHTML='<a href="https://twitter.com/Amit_Levinson">Amit Grinson</a> \u2022 <a href="https://twitter.com/30DayChartChall">#30DayChartChallenge</a>',o(n,"id","percentage"),o(v,"class","legend"),o($,"r",e[2]),o($,"cx",e[2]),o($,"cy",e[2]),o($,"fill",ge),o(m,"r",P=e[2]/2),o(m,"cx",e[2]),o(m,"cy",e[2]),o(m,"fill",ge),o(m,"stroke",Ne),o(m,"stroke-width",e[2]),o(m,"stroke-dasharray",e[4]),o(C,"width",e[1]),o(C,"height",e[1]),o(T,"class","footer"),o(f,"class","chart"),G(()=>e[8].call(f))},m(l,a){W(l,t,a),d(t,n),d(n,r),d(n,i),d(n,s),d(t,u),W(l,w,a),W(l,_,a),W(l,c,a),W(l,p,a),d(p,g),d(p,A),W(l,H,a),W(l,f,a),d(f,L),d(f,M),d(f,v),R(k,v,null),d(v,X),d(v,Z),d(v,x),R(z,v,null),d(v,ee),d(f,te),d(f,ne),d(f,re),d(f,C),d(C,$),d(C,m),d(f,ie),d(f,T),oe=Ae(f,e[8].bind(f)),h=!0},p(l,[a]){(!h||a&1)&&fe(i,l[0]),(!h||a&8)&&fe(A,l[3]),(!h||a&4)&&o($,"r",l[2]),(!h||a&4)&&o($,"cx",l[2]),(!h||a&4)&&o($,"cy",l[2]),(!h||a&4&&P!==(P=l[2]/2))&&o(m,"r",P),(!h||a&4)&&o(m,"cx",l[2]),(!h||a&4)&&o(m,"cy",l[2]),(!h||a&4)&&o(m,"stroke-width",l[2]),(!h||a&16)&&o(m,"stroke-dasharray",l[4]),(!h||a&2)&&o(C,"width",l[1]),(!h||a&2)&&o(C,"height",l[1])},i(l){h||(Q(k.$$.fragment,l),Q(z.$$.fragment,l),h=!0)},o(l){ce(k.$$.fragment,l),ce(z.$$.fragment,l),h=!1},d(l){l&&b(t),l&&b(w),l&&b(_),l&&b(c),l&&b(p),l&&b(H),l&&b(f),U(k),U(z),oe()}}}let ge="gray",Ne="#32408F";function Oe(e,t,n){let r,i,s,u,w=0,_=0,c,p=500;function g(){let f=new Date;const L=new Date;L.setHours(0,0,0,0);const M=new Date;M.setHours(23,59,59,999),n(3,c=f.getHours()+":"+(f.getMinutes()<10?"0"+f.getMinutes():f.getMinutes())+":"+(f.getSeconds()<10?"0"+f.getSeconds():f.getSeconds())),n(5,w=(f-L)/(M-L)),n(0,_=(w*100).toFixed(1))}g(),window.setInterval(function(){g()},1e3);function A(){p=this.clientWidth,n(1,p)}return e.$$.update=()=>{e.$$.dirty&2&&n(2,r=p/2),e.$$.dirty&4&&n(7,i=Math.PI*r),e.$$.dirty&160&&n(6,s=i*w),e.$$.dirty&192&&n(4,u=`0 ${i-s} ${s}`),e.$$.dirty&33},[_,p,r,c,u,w,s,i,A]}class De extends be{constructor(t){super(),we(this,t,Oe,Me,_e,{})}}new De({target:document.getElementById("app")});