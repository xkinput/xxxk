/* 键盘布局文件 */
function layout2(num){
/* key code */
var KEYCODE_SHIFT=-1,
	KEYCODE_STATE=-2,
	KEYCODE_MENU=-3,
	KEYCODE_SWITCH_number=-10,
	KEYCODE_SWITCH_english=-11,
	KEYCODE_SWITCH_number2=-12,
	KEYCODE_SWITCH_cands=-33,
	KEYCODE_Select_Index1=-101,
	KEYCODE_Select_Index2=-102,
	KEYCODE_Select_Index3=-103,
	KEYCODE_SWITCH_ENG=-110,
	KEYCODE_FanCha=0x1002F,
	KEYCODE_CTRL_1=0x10031,
	KEYCODE_CTRL_2=0x10032;

var KEYCODE_DEL=0x08,
	KEYCODE_TAB=0x09,
	KEYCODE_ENTER=0x0d,
	KEYCODE_ESC=0x1b,
	KEYCODE_SPACE=0x20,
	KEYCODE_DEL_F=0xff,
	KEYCODE_SHIFT_KEY = 0x20000;

var KEYCODE_a = 0x61, KEYCODE_b = 0x62, KEYCODE_c = 0x63, KEYCODE_d = 0x64, KEYCODE_e = 0x65, KEYCODE_f = 0x66, KEYCODE_g = 0x67, KEYCODE_h = 0x68, KEYCODE_i = 0x69, KEYCODE_j = 0x6a, KEYCODE_k = 0x6b, KEYCODE_l = 0x6c, KEYCODE_m = 0x6d, KEYCODE_n = 0x6e, KEYCODE_o = 0x6f, KEYCODE_p = 0x70, KEYCODE_q = 0x71, KEYCODE_r = 0x72, KEYCODE_s = 0x73, KEYCODE_t = 0x74, KEYCODE_u = 0x75, KEYCODE_v = 0x76, KEYCODE_w = 0x77, KEYCODE_x = 0x78, KEYCODE_y = 0x79, KEYCODE_z = 0x7a;

var KEYCODE_HOME=0xff50,
	KEYCODE_END=0xff57,
	KEYCODE_LEFT=0xff51,
	KEYCODE_UP=0xff52,
	KEYCODE_RIGHT=0xff53,
	KEYCODE_DOWN=0xff54;

var KEYCODE_YK_VIRT_ADD=0x0800002,
	KEYCODE_YK_VIRT_DEL=0x0800003;

var KEYCODE_CTRL_UP=0x1ff52,
	KEYCODE_CTRL_DOWN=0x1ff54;

	if(!num) return;
	switch(num){
/* 26/36键布局(无;分号键) --------------------------- */
	case 1:
		var English = {
		name: "无分号",
		hii : {
			q:'!', w:'@', e:'#', r:'$', t:'%', 
			y:'^', u:'&', i:'*', o:'(', p:')', 
			a:'_', s:'-', d:'+', f:'☘', g:'=', 
			h:'|', j:'频', k:'{', l:'}',
			z:'↶', x:'注', c:'⚝', v:'译', b:'☂', n:'报', m:'字'
		},
		shifted : false,
		alt : {
			q:'1', w:'2', e:'3', r:'4', t:'5',
			y:'6', u:'7', i:'8', o:'9', p:'0',
			a:'☑', s:'|←', d:'→|', f:'?', g:'反',
			h:'➠', j:'✓', k:'[', l:']', ";":':',
			"⇪":'ᵀᴬᴮ', z:'`', x:'✂', c:'❏', v:'▣',
			b:'~', n:'"', m:'\'', "⌫":'行',
			"中/En":'M', "数":'符', "/":'\\',
			",":'<', ".":'>', "➥":'☆'
		},
		upper: {
			q:'Q', w:'W', e:'E', r:'R', t:'T',
			y:'Y', u:'U', i:'I', o:'O', p:'P',
			a:'A', s:'S', d:'D', f:'F', g:'G',
			h:'H', j:'J', k:'K', l:'L',
			z:'Z', x:'X', c:'C', v:'V', b:'B',
			n:'N', m:'M'
		},
		key : [
			[{v:'1',sa: true},{v:'2',sa: true},{v:'3',sa: true},{v:'4',sa: true},{v:'5',sa: true},
			{ v: '_', h: true, sa: true }, { v: '_', h: true, sa: true }, { v: '_', h: true, sa: true }, { v: '_', h: true, sa: true },
			 {v:'6',sa: true},{v:'7',sa: true},{v:'8',sa: true},{v:'9',sa: true},{v:'0',sa: true}],
			[{v:'q'},{v:'w'},{v:'e'},{v:'r'},{v:'t'},
			{v:'7',h:true,s:true},{v:'8',h:true,s:true},{v:'9',h:true,s:true},{v:'⇤',c:KEYCODE_HOME,h:true,s:true},
			 {v:'y'},{v:'u'},{v:'i'},{v:'o'},{v:'p'}],
			[{v:'a'},{v:'s'},{v:'d'},{v:'f'},{v:'g'},
			{v:'4',h:true,s:true},{v:'5',h:true,s:true},{v:'6',h:true,s:true},{v:'⇥',c:KEYCODE_END,h:true,s:true},
			 {v:'h'},{v:'j'},{v:'k'},{v:'l'},{v:';',s:true}],
			[{v:'⇪',c:KEYCODE_SHIFT,r:1.5,s:true},
			 {v:'z'},{v:'x'},{v:'c'},{v:'v'},
			{v:'1',h:true,s:true},{v:'2',h:true,s:true},{v:'3',h:true,s:true},{v:'↑',c:KEYCODE_UP,h:true,s:true},
			 {v:'b'},{v:'n'},{v:'m'},
			 {v:'⌫',c:KEYCODE_DEL,r:1.5,s:true}],
			[
			 {v:'中/En',r:1.5,c:KEYCODE_STATE,s:true},
			 {v:'数',c:KEYCODE_SWITCH_number2,s:true},
			 {v:'/',s:true},
			 {v:'𝐒𝐏𝐀𝐂𝐄',r:3,c:KEYCODE_SPACE},
			{v:'0',h:true,s:true},{v:'←',c:KEYCODE_LEFT,h:true,s:true},{v:'↓',c:KEYCODE_DOWN,h:true,s:true},{v:'→',c:KEYCODE_RIGHT,h:true,s:true},
			 {v:',',s:true},{v:'.',s:true},
			 {v:'➥',r: 1.5,c:KEYCODE_ENTER,s:true}]
				]
			}; break;
/* 14键布局 ------------------------------------------ */
	case 2:
		var English = {
		name: "14键",
		hii : {
			qw:'', er:'', ty:'', ui:'', op:'',
			as:'', df:'', gh:'☘', jk:'', l:'',
			zx:'', cv:'⚝', bn:'', m:''
		},
		shifted : false,
		alt : {
			'qw':'1','er':'2','ty':'3','ui':'4','op':'5',
			'as':'6','df':'7','gh':'8','jk':'9','l':'0',
		    '⇪':'ᵀᴬᴮ','zx':'`','cv':'✂','bn':'\\','m':'☑',"⌫":'行',
			'☯':'M','中/En':'反','12':'符',',':'❏','.':'▣','➥':"☆"
		},
		upper: {
			'qw':'w','er':'r','ty':'y','ui':'i','op':'p',
			'as':'s','df':'f','gh':'h','jk':'k','l':'l',
			'zx':'x','cv':'v','bn':'n','m':'m'
		},
		key : [
			[{v:'1',sa: true},{v:'2',sa: true},{v:'3',sa: true},{v:'4',sa: true},{v:'5',sa: true},
			 {v:'6',sa: true},{v:'7',sa: true},{v:'8',sa: true},{v:'9',sa: true},{v:'0',sa: true}],
			[{v:'qw',r:2,c:KEYCODE_q},{v:'er',r:2,c:KEYCODE_e},{v:'ty',r:2,c:KEYCODE_t},
			{v:'ui',r:2,c:KEYCODE_u},{v:'op',r:2,c:KEYCODE_o}],
			
			[{v:'as',r:2,c:KEYCODE_a},{v:'df',r:2,c:KEYCODE_d},{v:'gh',r:2,c:KEYCODE_g},
			{v:'jk',r:2,c:KEYCODE_j},{v:'l',r:2,c:KEYCODE_l}],
			
			[{v:'⇪',c:KEYCODE_SHIFT,r:1,s:true},{v:'zx',r:2,c:KEYCODE_z},{v:'cv',r:2,c:KEYCODE_c},
			{v:'bn',r:2,c:KEYCODE_b},{v:'m',r:2,c:KEYCODE_m},{v:'⌫',r:1,c:KEYCODE_DEL,s:true}],
			
			[{v:'☯',r:1.5,c:KEYCODE_SWITCH_ENG,s:true},
			 {v:'中/En',r:1,c:KEYCODE_STATE,s:true},
			 {v:'12',r:1,c:KEYCODE_SWITCH_number2,s:true},
			 {v:'SPACE',r:3,c:KEYCODE_SPACE,s:false},
			 {v:',',s:true},
			 {v:'.',s:true},
			{v:'➥',r:1.5,c:KEYCODE_ENTER,s:true}]
		]}; break;
/* 小鹤形助记 ----------------------------------------- */
	case 4:
		var English = {
		name: "小鹤助记",
		hii : {
		q:'具其▲', w:'亠夂文', e:'卩阝见', r:'亻', t:'田', y:'讠𧘇', u:'上饣矢', i:'彳亍虫', o:'日月目', p:'礻衤', a:'鱼', s:'纟厶龴', d:'刂⺈', f:'寿带▲', g:'艮既左', h:'余▼', j:'龹钅金', k:'匚冂凵', l:'耂立龙', z:'⻊廴辶', x:'下⺌⺗', c:'艹廾', v:'止⺮豸', b:'丷疒匕', n:'乀牜⺧', m:'门朩皿'
		}, 
		shifted : false, 
		alt : {
		q:'犭求', w:'-', e:'山彐', r:'?', t:'', y:'⺷⺶羊', u:'龵𠂇氺', i:'[', o:']', p:'丿', a:'一', s:'罒', d:'丶冫氵', f:'扌龶缶', g:'鬼骨革', h:'灬虍黑', j:'', k:'口㠯', l:'丨', z:'`', x:'忄乂', c:'', v:'乛', b:'宀冖勹', n:'"', m:'\'', 
		"⇪":'ᵀᴬᴮ', "⌫":'行',
		"中/En":'M', "符":'数', "/":'\\',
		",":'<', ".":'>', "➥":'☆'
		},
		upper: {
			q:'Q', w:'W', e:'E', r:'R', t:'T',
			y:'Y', u:'U', i:'I', o:'O', p:'P',
			a:'A', s:'S', d:'D', f:'F', g:'G',
			h:'H', j:'J', k:'K', l:'L',
			z:'Z', x:'X', c:'C', v:'V', b:'B',
			n:'N', m:'M'
		},
		key : [
			[{v:'1',sa: true},{v:'2',sa: true},{v:'3',sa: true},{v:'4',sa: true},{v:'5',sa: true},
			 {v:'6',sa: true},{v:'7',sa: true},{v:'8',sa: true},{v:'9',sa: true},{v:'0',sa: true}],
			[{v:'q'},{v:'w'},{v:'e'},{v:'r'},{v:'t'},
			 {v:'y'},{v:'u'},{v:'i'},{v:'o'},{v:'p'}],
			[{v:'a'},{v:'s'},{v:'d'},{v:'f'},{v:'g'},
			 {v:'h'},{v:'j'},{v:'k'},{v:'l'}],
			[{v:'⇪',c:KEYCODE_SHIFT,r:1.5,s:true},
			 {v:'z'},{v:'x'},{v:'c'},{v:'v'},{v:'b'},{v:'n'},{v:'m'},
			 {v:'⌫',c:KEYCODE_DEL,r:1.5,s:true}],
			[
			 {v:'中/En',r:1.5,c:KEYCODE_STATE,s:true},
			 {v:'符',c:KEYCODE_SWITCH_number,s:true},
			 {v:'/',s:true},
			 {v:'SPACE',r:3,c:KEYCODE_SPACE},
			 {v:',',s:true},{v:'.',s:true},
			 {v:'➥',r: 1.5,c:KEYCODE_ENTER,s:true}]
		]}; break;
/* 大空格 ------------------------------------------- */
	case 5:
		var English = {
		name: "大空格",
		hii : {
			q:'!', w:'@', e:'#', r:'$', t:'%', 
			y:'^', u:'&', i:'*', o:'(', p:')', 
			a:'_', s:'-', d:'+', f:'/', g:'=', 
			h:'|', j:':', k:'{', l:'}',
			z:'↶', x:"ღ", c:'⚝', v:'译', b:'☂', n:'报', m:'字'
		},
		shifted : false,
		alt : {
			q:'1', w:'2', e:'3', r:'4', t:'5',
			y:'6', u:'7', i:'8', o:'9', p:'0',
			a:'☑', s:'|←', d:'→|', f:'?', g:'反',
			h:'➠', j:'✓', k:'[', l:']', ";":':',
			"⇪":'ᵀᴬᴮ', z:'`', x:'✂', c:'❏', v:'▣',
			b:'~', n:'"', m:'\'', "⌫":'行',
			"中/En":'', "符":'M',
			",":'\\', ".":';', "➥":'☆'
		},
		upper: {
			q:'Q', w:'W', e:'E', r:'R', t:'T',
			y:'Y', u:'U', i:'I', o:'O', p:'P',
			a:'A', s:'S', d:'D', f:'F', g:'G',
			h:'H', j:'J', k:'K', l:'L',
			z:'Z', x:'X', c:'C', v:'V', b:'B',
			n:'N', m:'M'
		},
		key : [
			[{v:'1',sa: true},{v:'2',sa: true},{v:'3',sa: true},{v:'4',sa: true},{v:'5',sa: true},
			 {v:'6',sa: true},{v:'7',sa: true},{v:'8',sa: true},{v:'9',sa: true},{v:'0',sa: true}],
			[{v:'q'},{v:'w'},{v:'e'},{v:'r'},{v:'t'},
			 {v:'y'},{v:'u'},{v:'i'},{v:'o'},{v:'p'}],
			[{v:'a'},{v:'s'},{v:'d'},{v:'f'},{v:'g'},
			 {v:'h'},{v:'j'},{v:'k'},{v:'l'}],
			[{v:'⇪',c:KEYCODE_SHIFT,r:1.5,s:true},
			 {v:'z'},{v:'x'},{v:'c'},{v:'v'},{v:'b'},{v:'n'},{v:'m'},
			 {v:'⌫',c:KEYCODE_DEL,r:1.5,s:true}],
			[
			 {v:'符',r:1.5,c:KEYCODE_SWITCH_number,s:true},
			 {v:',',r:1.5,s:true},
			 {v:'SPACE',r:4,c:KEYCODE_SPACE},
			 {v:'.',r:1.5,s:true},
			 {v:'➥',r: 1.5,c:KEYCODE_ENTER,s:true}]
		]}; break;
/* 布局2 ------------------------------------------- */
	case 6:
		var English = {
		name: "布局2",
		hii : {
			q:'!', w:'@', e:'#', r:'$', t:'%', 
			y:'^', u:'&', i:'*', o:'(', p:')', 
			a:'_', s:'-', d:'+', f:'/', g:'=', 
			h:'|', j:':', k:'{', l:'}',
			z:'↶', x:"ღ", c:'⚝', v:'译', b:'☂', n:'报', m:'字'
		},
		shifted : false,
		alt : {
			q:'1', w:'2', e:'3', r:'4', t:'5',
			y:'6', u:'7', i:'8', o:'9', p:'0',
			a:'☑', s:'|←', d:'→|', f:'?', g:'反',
			h:'➠', j:'✓', k:'[', l:']', ";":':',
			"⇪":'ᵀᴬᴮ', z:'`', x:'✂', c:'❏', v:'▣',
			b:'~', n:'"', m:'\'', "⌫":'行',
			"中/En":'', "符":'M',
			",":'\\', ".":';', "➥":'☆'
		},
		upper: {
			q:'Q', w:'W', e:'E', r:'R', t:'T',
			y:'Y', u:'U', i:'I', o:'O', p:'P',
			a:'A', s:'S', d:'D', f:'F', g:'G',
			h:'H', j:'J', k:'K', l:'L',
			z:'Z', x:'X', c:'C', v:'V', b:'B',
			n:'N', m:'M'
		},
		key : [
			[{v:'1',sa: true},{v:'2',sa: true},{v:'3',sa: true},{v:'4',sa: true},{v:'5',sa: true},
			 {v:'6',sa: true},{v:'7',sa: true},{v:'8',sa: true},{v:'9',sa: true},{v:'0',sa: true}],
			[{v:'q'},{v:'w'},{v:'e'},{v:'r'},{v:'t'},
			 {v:'y'},{v:'u'},{v:'i'},{v:'o'},{v:'p'}],
			[{v:'a'},{v:'s'},{v:'d'},{v:'f'},{v:'g'},
			 {v:'h'},{v:'j'},{v:'k'},{v:'l'},{v:';'}],
			[{v:'z'},{v:'x'},{v:'c'},{v:'v'},{v:'b'},{v:'n'},{v:'m'},
			{v:',',s:false},{v:'.',s:false},{v:'/'}],
			[{v:'中/En',c:KEYCODE_STATE,s:true},
			{v:'⇪',c:KEYCODE_SHIFT,s:true},
			 {v:'&#x1f310;',c:KEYCODE_SWITCH_number,s:true},
			 {v:'&nbsp',r:4,c:KEYCODE_SPACE,s:false},
			 {v:'⌫',r: 1.5,c:KEYCODE_DEL,s:true},
			{v:'➥',r: 1.5,c:KEYCODE_ENTER,s:true}]
		]}; break;

/* 特殊17键布局 ------------------------------------------ */
	case 3:
		var English = {
		name: "17键",
		hii : {
			𝐐𝐖:':', 𝐄𝐑:'*', 𝐓:'(', 𝐘:')', 𝐔𝐈:'{', 𝐎𝐏:'}',
			𝐀𝐒:'?', 𝐃𝐅:'_', 𝐆:'☘', 𝐇:'-', 𝐉𝐊:'+', 𝐋:'=',
			𝐙:'|', 𝐗𝐂:'⚝', 𝐕𝐁:'ღ', 𝐍:'☂', 𝐌:'⁽²⁶⁾'
		},
		shifted : false,
		alt : {
			𝐐𝐖:'1', 𝐄𝐑:'2', 𝐓:'3', 𝐘:'4', 𝐔𝐈:'5', 𝐎𝐏:'6',
			𝐀𝐒:'7', 𝐃𝐅:'8', 𝐆:'9', 𝐇:'0', 𝐉𝐊:'[', 𝐋:']',
			𝐙:'☑', 𝐗𝐂:'✂', 𝐕𝐁:'▣', 𝐍:"'", 𝐌:'"',
			";":'ᵀᴬᴮ', "⌫":'行', "12":'符',
			'☯':'M', '中/En':'', '➥':"☆", '/':'\\', ',':'反', '.':'`'
		},
		upper: {},
		key : [
			[{v:'1',sa: true},{v:'2',sa: true},{v:'3',sa: true},{v:'4',sa: true},{v:'5',sa: true},
			 {v:'6',sa: true},{v:'7',sa: true},{v:'8',sa: true},{v:'9',sa: true},{v:'0',sa: true}],
[{v:'𝐐𝐖',r:10/6,c:KEYCODE_q},{v:'𝐄𝐑',r:10/6,c:KEYCODE_e},{v:'𝐓',r:10/6,c:KEYCODE_t},{v:'𝐘',r:10/6,c:KEYCODE_y},{v:'𝐔𝐈',r:10/6,c:KEYCODE_u},{v:'𝐎𝐏',r:10/6,c:KEYCODE_o}],
			
			[{v:'𝐀𝐒',r:10/6,c:KEYCODE_a},{v:'𝐃𝐅',r:10/6,c:KEYCODE_d},{v:'𝐆',r:10/6,c:KEYCODE_g},{v:'𝐇',r:10/6,c:KEYCODE_h},{v:'𝐉𝐊',r:10/6,c:KEYCODE_j},{v:'𝐋',r:10/6,c:KEYCODE_l}],
			
			[{v:'12',c:KEYCODE_SWITCH_number2,s:true},{v:'𝐙',r:1.5,c:KEYCODE_z},{v:'𝐗𝐂',r:1.5,c:KEYCODE_x},{v:'𝐕𝐁',r:1.5,c:KEYCODE_v},
            {v:'𝐍',r:1.5,c:KEYCODE_n},{v:'𝐌',r:1.5,c:KEYCODE_m},{v:'⌫',r:1.5,c:KEYCODE_DEL,s:true}],
			
			[{v:'☯',r:1.5,c:KEYCODE_SWITCH_ENG,s:true},
			 {v:';',s:true},
			 {v:'/',s:true},
			 {v:'𝐒𝐏𝐀𝐂𝐄',r:3,c:KEYCODE_SPACE,s:false},
			 {v:',',s:true},
			 {v:'.',s:true},
			{v:'➥',r:1.5,c:KEYCODE_ENTER,s:true}]
		]}; break;
	case 99:
		var English = {
		name: "模板",
		hii : { //下标
		},
		shifted : false,
		alt : { //上标
		},
		upper: { //大写键
		},
		key : [ //按键布局
			[{v:'1',sa: true},{v:'2',sa: true},{v:'3',sa: true},{v:'4',sa: true},{v:'5',sa: true},
			 {v:'6',sa: true},{v:'7',sa: true},{v:'8',sa: true},{v:'9',sa: true},{v:'0',sa: true}]
		]}; break;
	default:
	    return;
		break;
	}
	return English;
}

/*因为css隐藏了第1行(皮肤数字行开关所需), 所以全部布局第1行要为数字行*/