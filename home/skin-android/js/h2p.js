// 小鹤双拼转拼音
var h2p = {
"aa": "a","ah": "ang",
"bd": "bai","bj": "ban","bh": "bang","bc": "bao","bw": "bei","bf": "ben","bg": "beng","bm": "bian","bn": "biao","bp": "bie","bb": "bin","bk": "bing",
"cd": "cai","cj": "can","ch": "cang","cc": "cao","cf": "cen","cg": "ceng","ia": "cha","id": "chai","ij": "chan","ih": "chang","ic": "chao","ie": "che","if": "chen","ig": "cheng","ii": "chi","is": "chong","iz": "chou","iu": "chu","ix": "chua","ik": "chuai","ir": "chuan","il": "chuang","iv": "chui","iy": "chun","io": "chuo","cs": "cong","cz": "cou","cr": "cuan","cv": "cui","cy": "cun","co": "cuo",
"dd": "dai","dj": "dan","dh": "dang","dc": "dao","dw": "dei","df": "den","dg": "deng","dx": "dia","dm": "dian","dn": "diao","dp": "die","dk": "ding","dq": "diu","ds": "dong","dz": "dou","dr": "duan","dv": "dui","dy": "dun","do": "duo",
"ee": "e","eh": "eng",
"fj": "fan","fh": "fang","fw": "fei","ff": "fen","fg": "feng","fn": "fiao","fz": "fou",
"gd": "gai","gj": "gan","gh": "gang","gc": "gao","gw": "gei","gf": "gen","gg": "geng","gs": "gong","gz": "gou","gx": "gua","gk": "guai","gr": "guan","gl": "guang","gv": "gui","gy": "gun","go": "guo",
"hd": "hai","hj": "han","hh": "hang","hc": "hao","hw": "hei","hf": "hen","hg": "heng","hs": "hong","hz": "hou","hx": "hua","hk": "huai","hr": "huan","hl": "huang","hv": "hui","hy": "hun","ho": "huo",
"jx": "jia","jm": "jian","jl": "jiang","jn": "jiao","jp": "jie","jb": "jin","jk": "jing","js": "jiong","jq": "jiu","jr": "juan","jt": "jue","jy": "jun",
"kd": "kai","kj": "kan","kh": "kang","kc": "kao","kw": "kei","kf": "ken","kg": "keng","ks": "kong","kz": "kou","kx": "kua","kk": "kuai","kr": "kuan","kl": "kuang","kv": "kui","ky": "kun","ko": "kuo",
"ld": "lai","lj": "lan","lh": "lang","lc": "lao","lw": "lei","lg": "leng","lx": "lia","lm": "lian","ll": "liang","ln": "liao","lp": "lie","lb": "lin","lk": "ling","lq": "liu","ls": "long","lz": "lou","lr": "luan","ly": "lun","lo": "luo","lv": "lv","lt": "lve",
"md": "mai","mj": "man","mh": "mang","mc": "mao","mw": "mei","mf": "men","mg": "meng","mm": "mian","mn": "miao","mp": "mie","mb": "min","mk": "ming","mq": "miu","mz": "mou",
"nd": "nai","nj": "nan","nh": "nang","nc": "nao","nw": "nei","nf": "nen","ng": "neng","nm": "nian","nl": "niang","nn": "niao","np": "nie","nb": "nin","nk": "ning","nq": "niu","ns": "nong","nz": "nou","nr": "nuan","ny": "nun","no": "nuo","nv": "nv","nt": "nve",
"oo": "o",
"pd": "pai","pj": "pan","ph": "pang","pc": "pao","pw": "pei","pf": "pen","pg": "peng","pm": "pian","pn": "piao","pp": "pie","pb": "pin","pk": "ping","pz": "pou",
"qx": "qia","qm": "qian","ql": "qiang","qn": "qiao","qp": "qie","qb": "qin","qk": "qing","qs": "qiong","qq": "qiu","qr": "quan","qt": "que","qy": "qun",
"rj": "ran","rh": "rang","rc": "rao","rf": "ren","rg": "reng","rs": "rong","rz": "rou","rx": "rua","rr": "ruan","rv": "rui","ry": "run","ro": "ruo",
"sd": "sai","sj": "san","sh": "sang","sc": "sao","sf": "sen","sg": "seng","ua": "sha","ud": "shai","uj": "shan","uh": "shang","uc": "shao","ue": "she","uw": "shei","uf": "shen","ug": "sheng","ui": "shi","uz": "shou","uu": "shu","ux": "shua","uk": "shuai","ur": "shuan","ul": "shuang","uv": "shui","uy": "shun","uo": "shuo","ss": "song","sx": "sou","sr": "suan","sv": "sui","sy": "sun","so": "suo",
"td": "tai","tj": "tan","th": "tang","tc": "tao","tg": "teng","tm": "tian","tn": "tiao","tp": "tie","tk": "ting","ts": "tong","tz": "tou","tr": "tuan","tv": "tui","ty": "tun","to": "tuo",
"wd": "wai","wj": "wan","wh": "wang","ww": "wei","wf": "wen","wg": "weng",
"xx": "xia","xm": "xian","xl": "xiang","xn": "xiao","xp": "xie","xb": "xin","xk": "xing","xs": "xiong","xq": "xiu","xr": "xuan","xt": "xue","xy": "xun",
"yj": "yan","yh": "yang","yc": "yao","yb": "yin","yk": "ying","ys": "yong","yz": "you","yr": "yuan","yt": "yue","yy": "yun",
"zd": "zai","zj": "zan","zh": "zang","zc": "zao","zw": "zei","zf": "zen","zg": "zeng","va": "zha","vd": "zhai","vj": "zhan","vh": "zhang","vc": "zhao","ve": "zhe","vw": "zhei","vf": "zhen","vg": "zheng","vi": "zhi","vs": "zhong","vz": "zhou","vu": "zhu","vx": "zhua","vk": "zhuai","vr": "zhuan","vl": "zhuang","vv": "zhui","vy": "zhun","vo": "zhuo","zs": "zong","zz": "zou","zr": "zuan","zv": "zui","zy": "zun","zo": "zuo",
}

// 转换小鹤编码为拼音编码
function replacePairsHandleOdd(str, map) {
    var result = '';
    for (var i = 0; i < str.length; i += 2) {
        var pair = str.substring(i, i + 2);
        result += map[pair] || pair;
    }
    return result;
}
