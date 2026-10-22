














do

local _zLviIv = 4294967296
local _oWzZ = 65536
local _GkRq = (bit32 and bit32.bxor) or function(a, b)
  local r, p = 0, 1
  for _ = 1, 32 do
    local x, y = a % 2, b % 2
    if x ~= y then r = r + p end
    a = (a - x) / 2
    b = (b - y) / 2
    p = p * 2
  end
  return r
end
local _lYrusv = (bit32 and bit32.rshift) or function(x, n)
  return math.floor((x % 4294967296) / (2 ^ n))
end
local _QBlF = function(x, n)
  n = n % 32
  x = x % 4294967296
  if n == 0 then return x end
  local p = 2 ^ n
  return ((x * p) % 4294967296) + math.floor(x / (2 ^ (32 - n)))
end
local _pknN = function(a, b)
  a = a % 4294967296
  b = b % 4294967296
  local al = a % 65536
  local ah = (a - al) / 65536
  local bl = b % 65536
  local bh = (b - bl) / 65536
  return ((al * bl) + ((ah * bl + al * bh) % 65536) * 65536) % 4294967296
end
local _UXVPEV = function(x)
  x = x % 4294967296
  x = _GkRq(x, _lYrusv(x, 16)) % 4294967296
  x = _pknN(x, 2246822507)
  x = _GkRq(x, _lYrusv(x, 13)) % 4294967296
  x = _pknN(x, 3266489909)
  x = _GkRq(x, _lYrusv(x, 16)) % 4294967296
  return x
end
local _tUGhWv = function(k0, k1, counter)
  local c = counter % 4294967296
  local s = _GkRq(c, _pknN(k0, 2654435761)) % 4294967296
  s = (s + _pknN(k1, 2135587861)) % 4294967296
  s = _GkRq(s, _QBlF(k0, (c % 16) + 1)) % 4294967296
  s = _UXVPEV(s)
  s = _GkRq(s, _QBlF(k1, 32 - (((_lYrusv(c, 5)) % 16) + 1))) % 4294967296
  s = _pknN(s, (k0 % 2 == 0) and (k0 + 1) or k0)
  return _UXVPEV(s)
end
local _gBTOGW = function(s)
  local o = {}
  for i = 1, #s, 2 do
    o[#o + 1] = string.char(tonumber(s:sub(i, i + 1), 16))
  end
  return table.concat(o)
end
local _aHTE = {}
_aHTE[0x5e7483]={"f7875e8c3dc5b224717c33bd891a740cec9308a54e",3268605224,1184386315}
_aHTE[0xe367ee]={"a1140142316729a9d46e765f1143",1487336669,1256144646}
_aHTE[0xedb23]={"c16227a388dfbe208038",102506477,1675709780}
_aHTE[0x327db8]={"b0c1fa933dd8563fc759",3259132512,906744108}
_aHTE[0xcd6350]={"29b627aa17",2194350439,92605170}
_aHTE[0xb5efd6]={"c9cc71cb7dde36f4a066ea",2002329937,4042242343}
_aHTE[0xbba31e]={"46af6a5afb7e684be0ab562e",331444877,1519695829}
_aHTE[0xbbc73]={"83cdac0f4d88c3a52ede8c",1265823118,3050810702}
_aHTE[0xcfcfab]={"e236dfd61400",2586518030,2290732060}
_aHTE[0xc54104]={"a7be54a4f50d",1057893502,656895013}
_aHTE[0x270f02]={"8dd5669bc5f7e7f30820",1031834044,3489565075}
_aHTE[0xc73702]={"49ab7cb17e73509dac",938328515,2149558884}
_aHTE[0xd1e3ea]={"e9b5b6de6f63",1244453643,737895391}
_aHTE[0x1e5907]={"f85664afd05e",3279757555,1160002835}
_aHTE[0x616bae]={"4612e748f621f4f13806ca",1919154513,2007549752}
_aHTE[0x26eeb5]={"e64829376dfbbd18c31c334dee6005f4",2315833301,2438970935}
_aHTE[0x85a5cf]={"c669b8d5",72515234,306933773}
_aHTE[0x32281e]={"1c3897",4044507433,1098920342}
_aHTE[0xf2c553]={"14f5a05dd004",2364051537,2450624960}
_aHTE[0x16a93e]={"4650130815e435",2614441704,2426563766}
_aHTE[0x666064]={"bb0be67da8523dd267",1814916628,2661098157}
_aHTE[0x44b13]={"d67cd28124cc62419ec9",1019391794,1338945149}
_aHTE[0xe0e6e9]={"b8f5f6353dcbec8448ed4d33c7b172a3459b",973408454,147741328}
_aHTE[0xdfe1d2]={"a2d7064b4f",813627199,3331690820}
_aHTE[0xa1c69d]={"3c9a302bea821d71",3029174671,3179687890}
_aHTE[0xf43902]={"d2d7be92d04fa6782d059638b54f1584",2377925008,1886428002}
_aHTE[0x298613]={"fd46e68e4b65b6ba07a6",2903291179,1820287819}
_aHTE[0xcf86ec]={"b43dba3dae14898494",3515627729,3013814941}
_aHTE[0x8bd733]={"bd216b94ec64790191",2015699826,3336936545}
_aHTE[0xafd158]={"87cf5da9dea462d8122382da",4092170387,558394024}
_aHTE[0xa926fa]={"3ae6b7e556736dad2a095c0a50",2569219239,3823907794}
_aHTE[0x69528f]={"926a33c7b0",3680531307,3644500025}
_aHTE[0x96a2d8]={"3c5a8b",1010671581,2843679800}
_aHTE[0x1f8e9b]={"c142111a",1237034861,1476997248}
_aHTE[0xf8ac21]={"103bd8dfcf0903",3713715418,1119964505}
_aHTE[0xcba1cb]={"4315b6fc",301090133,1630571748}
_aHTE[0x51e6c2]={"63e03ec82b4b5b2464",3124018708,520388021}
_aHTE[0xf31a0c]={"5ae9ebd3a677d685f95360a7",3384411410,4034568196}
_aHTE[0x28ce66]={"1456338deccaa620",98020127,1066848040}
_aHTE[0xdaf5f5]={"edd8b9e030440d96e8ae64",1046098977,430959838}
_aHTE[0xdbaa4a]={"7cf71d9f5572",4219593289,2318938836}
_aHTE[0x7d0e95]={"1b83e9271df2859b5843",3711950414,1699423856}
_aHTE[0x60eec4]={"d53ba12ce321b50a6e4d6f",587704837,2638425825}
_aHTE[0x1489a7]={"4c747a147624d356577d793f9b70",2280449335,483463574}
_aHTE[0x9fc619]={"4630263b70",2435827458,1558517410}
_aHTE[0x7f4a0]={"6150365302",812588924,18090974}
_aHTE[0x32e748]={"e29b",3828839292,2309714133}
_aHTE[0xb15feb]={"201ca0a04b26c7927aa48ac6",3722455708,955974703}
_aHTE[0x7691d]={"e6635af0f2b886269f72",3858355984,780032932}
_aHTE[0x8b3409]={"d000c786985cd2",1185582832,1600764036}
_aHTE[0x3ef986]={"e571ee03b532",2520221384,417861004}
_aHTE[0xc4c985]={"7d77020113f1878afe",399885415,1128150271}
_aHTE[0xc3b288]={"94dc8dc8cb7d",1686540431,636574297}
_aHTE[0xd6578d]={"96eefaaa1b97",889295958,3704346420}
_aHTE[0xe07b1c]={"b797f2b7e35b9f0f",616084553,2268674833}
_aHTE[0xfc1ca7]={"3f50592ebcc381",64523943,1511236727}
_aHTE[0xc3876b]={"bbf5b2f9e3852232d5",2448154510,581802619}
_aHTE[0xab48ed]={"0c4bd64af4",1662529439,72711030}
_aHTE[0x96dce7]={"ae8258a478e5736979f9b729a86ad4",4147208552,2054812793}
_aHTE[0x3a7ca5]={"bbbb12b43f8c6b",3091603454,127274347}
_aHTE[0xdfd267]={"a4e7ab86e835d98c80cd",4055891148,1819762952}
_aHTE[0x2b908d]={"44dd3e8476",4038770343,3914801433}
_aHTE[0x7d0625]={"3b37",3968161858,158920558}
_aHTE[0x165026]={"79ab1b87667ffebd8a",1958342962,521990807}
_aHTE[0x9fa40d]={"6bb24ae1ed",3317237126,2336321600}
_aHTE[0xb6ad1a]={"35d0147578a187",4045606214,1659957119}
_aHTE[0x56946b]={"4be3c68d1479dacc34",800739353,2095440751}
_aHTE[0xb8c15d]={"713d4b0e03cc9d",4257981340,222842689}
_aHTE[0x67f481]={"bd6e67fccea0",3956723633,1860264997}
_aHTE[0xabad28]={"7f5699c5",1999792703,3312716303}
_aHTE[0xdf5be1]={"05eb1bc9",4046296573,1739689065}
_aHTE[0xd97a36]={"ae4fb0e21bd92e83fbad1d40092945",3692860581,1648261446}
_aHTE[0xcceb04]={"0674872a33ac67e035",1608842784,1428784813}
_aHTE[0x331679]={"6e3999a6bcf083b75d4918f615ceddc0",1478737027,2343705419}
_aHTE[0x5a2098]={"efed20e80c992326aa",2744420535,1329296865}
_aHTE[0x8344be]={"ec",3254991073,1907475541}
_aHTE[0x53faca]={"3b0977026fc282f6f6ce",3018641592,1155553445}
_aHTE[0x4ce59a]={"56b2de45b629b5e72f12a5",4279731516,1830957783}
_aHTE[0xb96a48]={"0125ec",1533580235,3627195290}
_aHTE[0xfb40b9]={"1d",3109461723,1137667646}
_aHTE[0x9179e8]={"79bcd95ff44ebcb5c7e0",775066035,3885160836}
_aHTE[0x439a5c]={"7261e36433",2796715616,478907744}
_aHTE[0xbbd78e]={"7d520e5af3f07968",2876280614,3541609577}
_aHTE[0x43eaba]={"91b2457a085758ca15",2193203038,2208972388}
_aHTE[0x9ff210]={"8f8c24a128c1dd92eb2a",2421363841,606314770}
_aHTE[0x7e58bc]={"5a9214c33cc389bf6f",460033786,124104323}
_aHTE[0xe21ca0]={"3c778d0c",1339781303,706867518}
_aHTE[0x386cb3]={"5d3eea497b7a050f6f",3468439661,2203412900}
_aHTE[0x2c70f1]={"fcf077a70a95d145",176366506,47641833}
_aHTE[0xfac5c3]={"0e3d67d88d4bd66bd2",1043524951,717107287}
_aHTE[0xf8472]={"b583a8c8",827522852,1312864326}
_aHTE[0xe804ea]={"df0ed57c9bca",3120461016,960003766}
_aHTE[0x49f838]={"df69454b29",773681807,4079120367}
_aHTE[0x53fbd3]={"3ff5b6fcc7d1",1497992582,3132890949}
_aHTE[0x8060b9]={"49575cfa",4277725499,919177334}
_aHTE[0x1d903]={"190f2e499a4ff0",2018809842,730598080}
_aHTE[0x6f0a8a]={"79abbbe58bfe",804240564,2080929990}
_aHTE[0xa6486c]={"56f26640c7a8",3128200299,1180852635}
_aHTE[0x892732]={"8e2849998a1de1a70086",3596456839,3701588748}
_aHTE[0x9e47dd]={"5f0dff",452494263,1031435102}
_aHTE[0xcf7032]={"ea808eeec82f",3089891149,3069662680}
_aHTE[0xe4f419]={"2d333457564b8df6fb85",3188459799,3379735922}
_aHTE[0xfffb66]={"0f45df3955d5c6",3095992194,1358489507}
_aHTE[0xee5d56]={"e8392b0d47f717",4279450345,561494642}
_aHTE[0x92c6fb]={"44ebc62f6929216665af",935733098,3496228093}
_aHTE[0xf2304b]={"08ae42849d",4281728287,2622084205}
_aHTE[0xbdfa40]={"6172506dbccac96b",1301685188,472080712}
_aHTE[0x21d9d6]={"20",3818423625,2773798825}
_aHTE[0xdc3d5b]={"b30395f519db",148396091,3160951363}
_aHTE[0x564bd9]={"cf20e960fe",1713143879,2699853515}
_aHTE[0x3e0972]={"036fd2b7ac98",4135547785,2645601191}
_aHTE[0xf585c]={"c9839c1709a9",2171117424,147512376}
_aHTE[0xb4f29b]={"0920a1fd",2610321684,341724894}
_aHTE[0xda29fa]={"0e18f981df3a",1285555373,1489950759}
_aHTE[0x9c4173]={"dff552d8a941922a66",370334196,614944811}
_aHTE[0xfe4858]={"7076a1f68db43947544b",2445055969,3843959944}
_aHTE[0x52e46c]={"b83a61",3187644386,3754521367}
_aHTE[0xec6a93]={"00f231bc530bee3f",3225389368,4069133417}
_aHTE[0x2d6eaa]={"92fea2226b5b97c830ce5b",2901082120,2612528976}
_aHTE[0x349d03]={"19",2620497589,634577280}
_aHTE[0xc296eb]={"612e9bb5",3685275421,2573019920}
_aHTE[0x4512d2]={"058a31a6f7dc04",2071662471,1939436733}
_aHTE[0x6c7efa]={"df75d9ce8d4c0beedc14b9d6b167bb",2379148807,1049456911}
_aHTE[0xa0b185]={"65c198d2",3702826193,3018717520}
_aHTE[0xd90f62]={"48fe1f927902e3be61",1983745590,2362016293}
_aHTE[0x3cc945]={"861181f1cc9e97407dcc",3731177983,2173784582}
_aHTE[0xd1872e]={"3fa5afbe38e1ca6560c7c3",2612148956,3213452762}
_aHTE[0xbfc795]={"3826a325c4f7c02edf24",1197450103,4163102546}
_aHTE[0x6aa348]={"1085de454399",2754456536,208604454}
_aHTE[0xb8973f]={"3b2bf0898552",2467362213,2514623527}
_aHTE[0xa1440c]={"871a9646a40471a7b04f801e",3769899181,2950599015}
_aHTE[0x93bd0c]={"a423cdfc5450f55823",3770818939,1046904319}
_aHTE[0x374e8]={"ab7e09e4f84e18a4",2759069391,42414087}
_aHTE[0x257716]={"81a409916c5513",3727708255,695313679}
_aHTE[0x8a02de]={"09d93bdc3e6ebad5b645",113955832,742723287}
_aHTE[0xfbde8f]={"ac3fe90a1aa036f9e68b2f",2504609498,413227174}
_aHTE[0x7e89b8]={"f9661ba98a7d7513bff4",1727349998,3711633906}
_aHTE[0x7fa37b]={"094af8bcc01e1afccc9135a0a7",3066647736,2534661051}
_aHTE[0x141569]={"0a2f301efff190ec8367",880611592,3410000077}
_aHTE[0x8e2897]={"5f68ba65c7bc8a78c82e528a2d2cf37e",3535453421,3364444985}
_aHTE[0x5208b0]={"000ba30c4f72b513e2984aba2d",2254675341,605170114}
_aHTE[0x177349]={"73338b4cf9e8dd",3056505982,3499665566}
_aHTE[0x694533]={"0339ef98",1762752920,2147285626}
_aHTE[0xe923d6]={"77cda375",2469781351,812343835}
_aHTE[0xe3e153]={"6e471f831c2a7fcaa284",2963906234,2045744748}
_aHTE[0x913687]={"9e",3984887488,3666863431}
_aHTE[0xc751d8]={"7523a8c4199ac205e46c929791a0",2350927345,4073167744}
_aHTE[0xf28fd2]={"267837b9fbad26",2879918900,191802979}
_aHTE[0xe0eab7]={"25e5168f1e846989a1b2ef12",3741925504,3277800344}
_aHTE[0x9b8c76]={"d0b1583fb7bd",2865261077,1501197358}
_aHTE[0x3dd5ce]={"250e6913d5e59c7e60db14f15127",3877799765,2731267586}
_aHTE[0xb2037e]={"fbdbd3",1799601945,3830514925}
_aHTE[0xea176f]={"99e161dde46fa8d4722fd1",2110526608,2162069867}
_aHTE[0xf875bf]={"9789ee6c4690a3b4fb",4161166784,1144881261}
_aHTE[0xb3304]={"675290c03ea7464e7b59bf0a562a47c4a1af6a081ce20df6565ac3a7f06b19684ea4a44dad2ea61d80352649db54edb6914644a7f237799566344d",3964404679,856131571}
_aHTE[0x854d8f]={"34f4fa243420db",577515414,3580833731}
_aHTE[0xed290b]={"11815ce8c0caa5a45329",213786155,2367632009}
_aHTE[0x5e9899]={"8fcf0e1999edf7",3144332056,3737924450}
_aHTE[0xeae16]={"d2b7b2867a3eece19760",3764258902,2381256656}
_aHTE[0x292041]={"1510a038728a3caad64dce",1516354178,1470598743}
_aHTE[0x6339ba]={"a8a1c15ab300a0d946f133ff",771316408,1562217051}
_aHTE[0x7df2ec]={"9c3df1529a",3409915953,815369504}
_aHTE[0x3f901b]={"28",1206583066,470436919}
_aHTE[0xe30928]={"fe68b24782",1806753199,1453079084}
_aHTE[0xed4854]={"9d24575850a666de4b595480a61dc70e811817ea",4135055089,521476969}
_aHTE[0x21f2f9]={"f909bf5bf6",656188583,1316691976}
_aHTE[0x144050]={"6e30f000ca",4026894352,3914686241}
_aHTE[0x2ba98c]={"a7a84a4d9a97",4067066791,1641578861}
_aHTE[0xcbfd55]={"d8bc5d24423400c81b10",3595471255,128186090}
_aHTE[0xb3ac80]={"03",3006359311,3888304371}
_aHTE[0x56954e]={"82feee13ccfe06d673",800430359,217626406}
_aHTE[0x81bbd6]={"a1a1de755d489171",521362445,2158513520}
_aHTE[0xa947b1]={"467ca265bb219045a452260252",443250947,513005125}
_aHTE[0x92b506]={"04b883",2581505276,3572598922}
_aHTE[0x297ab]={"3097f7",694332250,1384481573}
_aHTE[0x5d20da]={"7faef4bb95be58cb7160b9",947528603,2059860793}
_aHTE[0x93f86a]={"72bcc101",3402305581,842194067}
_aHTE[0x211255]={"d25c64f4208fbdc29688",3442273963,1311165143}
_aHTE[0x73eaae]={"ab2129ff242434",2064392632,3664766434}
_aHTE[0x1e0821]={"49cdfdaac7c0ea9f4b",178299824,563616312}
_aHTE[0x130da6]={"0c4558224f8c7eaf",261594991,2333784170}
_aHTE[0x369d69]={"02aad9aba7f4e3ac16a6",18807541,746612208}
_aHTE[0x53cd95]={"4efe2b",591503136,1444188443}
_aHTE[0x89a546]={"551ab39250ef2686",3672982924,1198208010}
_aHTE[0xdeb879]={"069b67c16ed3",2732893235,3475631508}
_aHTE[0x7f7708]={"0776f85b",2387973670,1410843034}
_aHTE[0x29e685]={"b8c94fd9038218d4b0fe68fb71d503",2715768450,728420185}
_aHTE[0xd867d2]={"088363371448e974e9",3217605768,633306912}
_aHTE[0x4ce0ba]={"c39d7e",1991338764,2495779580}
_aHTE[0xaebd20]={"02f4f3fdac94cf0ad78d",3699918792,2334552316}
_aHTE[0x74a3f4]={"c50d1455d3aaac7e52",587633528,1387191985}
_aHTE[0x7dfd3a]={"54e81a9fbda3ed",2623474884,3821812820}
_aHTE[0x12b840]={"769fb9e4c0f3c108ad314e",1397897190,3746227913}
_aHTE[0x2483ad]={"b922791b8162d69c2b0c",2054791489,2637382040}
_aHTE[0x21d980]={"e07f5caa5b",814722823,2140989986}
_aHTE[0x28813e]={"5946c00d392178dbf48d",3876863630,2060114426}
_aHTE[0x851019]={"2b0feaaeb8641b8fd443",1441764548,3735397258}
_aHTE[0x3723bc]={"48e545",1199644815,3521680467}
_aHTE[0x95173b]={"cf001285",3281915737,900719668}
_aHTE[0x8bfc6a]={"8c1b",1771941588,650170911}
_aHTE[0x5bc9f0]={"2ad7",458203622,1198695125}
_aHTE[0x650837]={"52e74b",3183657327,3116911589}
_aHTE[0x26ec2d]={"a8e5c2ef3e",2461676928,1410424377}
_aHTE[0x1ea3a5]={"39b4ff93",435552426,3691730863}
_aHTE[0xfda65f]={"f2eae64d2af069",3436964297,3318015039}
_aHTE[0x5fc342]={"c664df9563d723b745757d3b11",1823337649,271991012}
_aHTE[0xe143dd]={"dfa6ead82f43e24007",3772141741,2207432830}
_aHTE[0x6db64b]={"1ca734efd25e39f509",4038337149,2446268531}
_aHTE[0x9177d1]={"0b5000bd07c8",4028467194,2285779386}
_aHTE[0x3f8b16]={"6ee31c07",2289436977,2554258263}
_aHTE[0x4e823]={"56593ce971a393fbeb4246",523876588,4018410590}
_aHTE[0xa44f66]={"69ba49b68d700fdd0f1f",216608171,3510675583}
_aHTE[0x9fb7c]={"e9411170421f25aa",51253946,1317840670}
_aHTE[0x87f5df]={"b0f674f07e3b3a1236ff",366500323,962480624}
_aHTE[0xe4a62a]={"7c7915",738427033,1106467494}
_aHTE[0x766ff6]={"4974eea7d650",3899285257,4036916824}
_aHTE[0xc548dc]={"6d38eb317b9d7e84047cc5",159388673,4010656294}
_aHTE[0x687afb]={"251d",3151429409,686495025}
_aHTE[0xca1b25]={"2bb8b2a6",3053887227,3376370487}
_aHTE[0x3118ab]={"48fe3a16",4050375616,1754552601}
_aHTE[0xdaa612]={"0f8ff3acb236115fd2",2667245832,3837498422}
_aHTE[0x3569ed]={"1eab8339",3129388908,1964059854}
_aHTE[0x8d65f4]={"547d7739afcf11b718ab5d",4096632715,1205126557}
_aHTE[0x7e3c4c]={"06db2be96b",2897564903,3652827004}
_aHTE[0x718d38]={"eb65821982fa804d",1845479877,4033770467}
_aHTE[0x6562c9]={"b050a37c776318d69f",552522519,2081520499}
_aHTE[0x17456b]={"ecbcd7919d674bde9b64",3327181367,3615388746}
_aHTE[0xeb210]={"26",2245396205,1138124938}
_aHTE[0x2bc9bd]={"014a4d50c26ccd06",1502231285,702541245}
_aHTE[0xf20549]={"0ba687e4930686",3879940669,3408790240}
_aHTE[0x9692cc]={"59e3663345d0c8f419",1962418756,1486647369}
_aHTE[0xea6509]={"cdd682143ab5f020bb8a",1081423129,1401404552}
_aHTE[0xab1991]={"e53c1962e38e4e3777b0",193879941,811875283}
_aHTE[0x198650]={"b10385fa",2668121457,1397903732}
_aHTE[0x3184ba]={"8a6ab92315db09a938d3447d",1779980558,608471293}
_aHTE[0x282069]={"8383b005b89935bc9545a084",1156126536,1793200634}
_aHTE[0xa66e2e]={"",3237212717,2158025282}
_aHTE[0x2f6273]={"ad6d02fbace299a2f59d",4265275117,2871181159}
_aHTE[0x553766]={"b4ac",2599641713,1009893771}
_aHTE[0x94402e]={"dfc506d480e5f0",3915946433,3771154776}
_aHTE[0xc66e04]={"988f60bec36238",3059405118,178393488}
_aHTE[0x93fac7]={"d698c974238bd839024a",3629736695,520014061}
_aHTE[0x6d0f3e]={"4c66104ead41080d9446b8",3091363610,2176199421}
_aHTE[0xf5607b]={"119b7e83712a5d94a805",2260125030,4225012789}
_aHTE[0x239e19]={"a883544ac5a10902a333adf1abbdc03bc035",2004751715,3404496012}
_aHTE[0x8c385c]={"c85f94d06c3518",2786518299,1781673424}
_aHTE[0xcf33b]={"b6246c62b954189d6779",855863552,3346117594}
_aHTE[0xafcffc]={"8fb061bb9cdef6ac86",1672779051,1565906861}
_aHTE[0x9d8f7]={"2d0c44e842ccad6aea76a0",1982348575,2267801839}
_aHTE[0x8a7f3c]={"7d",350524108,1714300984}
_aHTE[0xeb045d]={"79dd1a3d27",2802506015,888521907}
_aHTE[0x156f4]={"67229e333340ef88c07e",3786094979,1434682412}
_aHTE[0x4cc9fa]={"2f1874228803872f38",2180323785,2366727944}
_aHTE[0xf5d1c1]={"82493ca82b09",1133817012,3600570405}
_aHTE[0x1bc808]={"d351e497b27c6630ae78b86c56801109de1e82",1264425851,4262887937}
_aHTE[0xf4c456]={"36df57819def76",4281744213,1615592883}
_aHTE[0xa3d2d9]={"25b2529de341b8ff48",1308382328,4022448217}
_aHTE[0x450617]={"0b65a4bd3558091e780a6d",1486543710,835655586}
_aHTE[0xc5dac7]={"a1c589a9483b",3262035051,1276983597}
_aHTE[0x1073b6]={"e9407c79f1d04534b480",1127812716,1471274970}
_aHTE[0xf87278]={"777c9507aa3bf4",3125581723,443863705}
_aHTE[0x88e72]={"b7de5f139da85ad0b4",2911766107,3910250774}
_aHTE[0x9f8922]={"650d9afbf19bbaf5",2206118757,612551239}
_aHTE[0x812f8e]={"aecc97920ab589",2422685067,168827425}
_aHTE[0x18464f]={"87d76be60f51d879",166845494,1130883178}
_aHTE[0x7ddfbb]={"fec85632e39a46d1dca8",1574915284,3561808618}
_aHTE[0x105b45]={"012bd2f09adcdb1c5c4dff39",2552597836,952239634}
_aHTE[0x5c52]={"e88e32",3288220886,2156765323}
_aHTE[0xe013cf]={"ffc4d3ff6e0d7014",1775256781,2915187837}
_aHTE[0x7b866b]={"50711cda67130f",331557910,3619580304}
_aHTE[0x63a0d8]={"a75c84649f6f",1101093813,4081991177}
_aHTE[0x6c81b8]={"9cda74956faa23",3494203412,1887645259}
_aHTE[0x7efdad]={"5ef1bd34a7ba",2936255540,2853838960}
_aHTE[0xef2d9f]={"fbbc24c7",1907343387,3456017785}
_aHTE[0xd86290]={"221340d191e95f",3071797130,3940989392}
_aHTE[0xa15807]={"18c4aa031bd634302a",4158655075,3970079523}
_aHTE[0x58f4d7]={"33412ddc4fdbced045",1173982244,2085513466}
_aHTE[0xd53094]={"d2817df83f65566030db",2780468458,1405914414}
_aHTE[0xb13e94]={"2e5b7c88d811ef1c",2585893166,1093365780}
_aHTE[0x8f194f]={"215140a11ede8f2aac30a2",2333252715,3627798917}
_aHTE[0x4b3365]={"77597d",3288081053,2882991253}
_aHTE[0xbc6b55]={"e66da127b6",2797671485,3482501055}
_aHTE[0xc913e9]={"5e92ae63ef4f3a20ab7100213d",1053933878,2969276335}
_aHTE[0xb4f5df]={"77af487656e9ae",2824344043,2544013478}
_aHTE[0xe3f40c]={"57d5629cb5a907de30bdc0f6492cc2",3446484763,420779660}
_aHTE[0x50198b]={"cb7f4509",2321437319,1769047111}
_aHTE[0xc987a5]={"be01d7522fc79870",1232030471,4228982539}
_aHTE[0x9706ce]={"76bbe6025d62ffa2b550e7",257254948,3671320662}
_aHTE[0xa6525e]={"604c25bd4a2e7e",2768016172,427463211}
_aHTE[0xee228e]={"e8f4ef14ade4",1126699791,2429737302}
_aHTE[0x17704d]={"9fa8e73d6d52581db98877",4108509157,711807990}
_aHTE[0xeadc03]={"10",251614533,4134966742}
_aHTE[0x3cfaaa]={"efda6ff3f27734",491767729,4036522091}
_aHTE[0x1342c9]={"faae9526c9",2002167520,3947335816}
_aHTE[0xc4c6a7]={"1f9b257eed62db99c46a",2165656459,2708014657}
_aHTE[0xff7964]={"7a8d2385",3981432911,2286051766}
local _CqgyQch = 0
for i, e in pairs(_aHTE) do
  _CqgyQch = (_CqgyQch + i * 31 + #e[1] * 17 + e[2] * 13 + e[3] * 7 + (tonumber(e[1]:sub(1, 2), 16) or 0)) % 2147483647
end
if _CqgyQch ~= ((0x1db57ffc) - (0x5ccc)) then return end
local _osIiFnN = {}
local _gBkJjT = function(i)
  local e = _aHTE[i]
  local s = _gBTOGW(e[1])
  local k0, k1 = e[2], e[3]
  local o = {}
  for j = 1, #s do
    local p = j - 1
    local w = _tUGhWv(k0, k1, math.floor(p / 4))
    local kb = math.floor(w / (2 ^ (((p % 4)) * 8))) % 256
    o[j] = string.char(_GkRq(string.byte(s, j), kb) % 256)
  end
  return table.concat(o)
end
local _VFGm = function(i)
  local v = _osIiFnN[i]
  if v == nil then
    v = _gBkJjT(i)
    _osIiFnN[i] = v
  end
  return v
end
local _vVdNDy = {_VFGm(0x8c385c),_VFGm(0xf2c553),_VFGm(0x89a546),_VFGm(0xe07b1c),_VFGm(0x5a2098),_VFGm(0xca1b25),_VFGm(0x1f8e9b),_VFGm(0x17456b),_VFGm(0xa1440c),_VFGm(0xb13e94),_VFGm(0x5e9899),_VFGm(0xdfd267)}
local _XoZwUKE = function(...)
local _PLXpF = game:GetService((_VFGm(0x3a7ca5)))
local _CpqXesA = game:GetService((_VFGm(0xa44f66) .. _VFGm(0xd86290)))
local _iqDgFf = game:GetService((_VFGm(0xc751d8) .. _VFGm(0x9e47dd)))
local _btaAlGg = game:GetService((_VFGm(0x9f8922)))

local _AYpOh = _PLXpF[(_VFGm(0xb5efd6))]
local _EtDEmR = (_VFGm(0x7d0e95))

local _MNuoelK = getgenv()[(_VFGm(0x718d38))]
if type(_MNuoelK) ~= (_VFGm(0xdfe1d2)) then
    if #_vVdNDy[3] == 8 then
_MNuoelK = {}
    getgenv()[(_VFGm(0x718d38))] = _MNuoelK
end
end

if type(_MNuoelK[(_VFGm(0x73eaae))]) == (_VFGm(0x18464f)) then
    if #_vVdNDy[4] >= 8 then
if #_vVdNDy[3] ~= 8 then string.byte(_vVdNDy[3], 1) end
pcall(_MNuoelK[(_VFGm(0x73eaae))])
end
end

_MNuoelK[(_VFGm(0xe3e153))] = (_MNuoelK[(_VFGm(0xe3e153))] or ((0x0) + (0x0))) + ((0x1) + (0x0))
local _NtEi = _MNuoelK[(_VFGm(0xe3e153))]
local _wAGB = true

_MNuoelK[(_VFGm(0x49f838))] = {}
_MNuoelK[(_VFGm(0xfac5c3))] = {}
_MNuoelK[(_VFGm(0x812f8e))] = {}
_MNuoelK[(_VFGm(0x4512d2))] = {}

if type(_MNuoelK[(_VFGm(0xbdfa40))]) ~= (_VFGm(0xdfe1d2)) then
    if #_vVdNDy[9] == 12 then
if #_vVdNDy[12] ~= 10 then string.byte(_vVdNDy[12], 1) end
_MNuoelK[(_VFGm(0xbdfa40))] = {
        instaCheck = false,
        autoParry = false,
        parryEquip = true,
        parryReach = ((0xe) + (0x2)),
        autoRepair = false,
        autoHeal = false,
        healOthers = false,
        autoUnhook = false,
        selfUnhook = false,
        autoEscape = false,
        autoPalletDrop = false,
        esp = false,
        fullbright = false,
        noClip = false,
        speed = false,
        speedValue = ((0x11) + (0x5)),
        checkMode = (_VFGm(0x53cd95)),
        instantValue = ((0x51) + (0x13)),
    }
end
end
local _YofYq = _MNuoelK[(_VFGm(0xbdfa40))]
if _YofYq[(_VFGm(0x56954e))] == nil then
    if #_vVdNDy[1] >= 7 then
_YofYq[(_VFGm(0x56954e))] = _YofYq[(_VFGm(0x369d69))] and (_VFGm(0x7b866b)) or (_VFGm(0x53cd95))
end
end
_YofYq[(_VFGm(0x369d69))] = _YofYq[(_VFGm(0x56954e))] ~= (_VFGm(0x53cd95))

local function _GwFf(...)
    if #_vVdNDy[6] >= 4 then
if #_vVdNDy[6] ~= 4 then string.byte(_vVdNDy[6], 1) end
local _dvoSlw = {}
    for _ODEj = ((0x0) + (0x1)), select((_VFGm(0x8344be)), ...) do
        if #_vVdNDy[8] >= 10 then
_dvoSlw[#_dvoSlw + ((0x0) + (0x1))] = tostring(select(_ODEj, ...))
end
    end
    local _hzZhave = string[(_VFGm(0xd1e3ea))]((_VFGm(0xf8ac21)), os[(_VFGm(0xe923d6))]((_VFGm(0x81bbd6))), table[(_VFGm(0x3ef986))](_dvoSlw, (_VFGm(0xb3ac80))))
    local _LxrW = (_VFGm(0xa66e2e))
    local _LwwD, _rmeXe = pcall(readfile, _EtDEmR)
    if _LwwD and type(_rmeXe) == (_VFGm(0xf5d1c1)) then
        if #_vVdNDy[11] ~= 8 then
_LxrW = _rmeXe
end
    end
    if #_LxrW > ((0x4371) + (0x58cf)) then
        if #_vVdNDy[1] <= 7 then
_LxrW = _LxrW:sub(-((0x29db) + (0x505)))
end
    end
    pcall(writefile, _EtDEmR, _LxrW .. _hzZhave .. (_VFGm(0xeb210)))
end
end

local function _TtqxhYb(_hKGawQ)
    if #_vVdNDy[9] >= 12 then
if #_vVdNDy[1] ~= 7 then string.byte(_vVdNDy[1], 1) end
if _hKGawQ then
        if #_vVdNDy[3] ~= 9 then
if #_vVdNDy[10] ~= 8 then string.byte(_vVdNDy[10], 1) end
table[(_VFGm(0xee228e))](_MNuoelK[(_VFGm(0x49f838))], _hKGawQ)
end
    end
    return _hKGawQ
end
end

local function _wKrpM()
    if #_vVdNDy[7] >= 4 then
for _GHwQc, _lrBrmC in ipairs(_MNuoelK[(_VFGm(0x49f838))]) do
        if #_vVdNDy[3] ~= 9 then
pcall(function()
            if #_vVdNDy[10] ~= 9 then
if #_vVdNDy[12] ~= 10 then string.byte(_vVdNDy[12], 1) end
_lrBrmC:Disconnect()
end
        end)
end
    end
    table[(_VFGm(0xbc6b55))](_MNuoelK[(_VFGm(0x49f838))])
end
end



local _ykQUrhF = _CpqXesA:WaitForChild((_VFGm(0x1d903)), ((0x18) + (0x6)))
local _hFjTeUs = _ykQUrhF and _ykQUrhF[(_VFGm(0x51e6c2))]
local _ZYkazyZ = _ykQUrhF and _ykQUrhF[(_VFGm(0x7dfd3a))]
local _Rzuj = _ykQUrhF and _ykQUrhF[(_VFGm(0x144050))]
local _kfTc = _ykQUrhF and _ykQUrhF[(_VFGm(0xe21ca0))]
local _jnpc = _ykQUrhF and _ykQUrhF[(_VFGm(0xb8973f))]
local _wjDgzF = _ykQUrhF and _ykQUrhF[(_VFGm(0x26ec2d))]

local function _YKNJs(_FXfgqGR, _yHpys)
    if #_vVdNDy[1] == 7 then
if #_vVdNDy[1] ~= 7 then string.byte(_vVdNDy[1], 1) end
local _ARDHzTE = _ykQUrhF and _ykQUrhF[_FXfgqGR]
    return _ARDHzTE and _ARDHzTE[_yHpys]
end
end

local _GbjCOXA = _hFjTeUs and _hFjTeUs[(_VFGm(0xd1872e))]
local _tcWIqD = _hFjTeUs and _hFjTeUs[(_VFGm(0x93fac7) .. _VFGm(0x69528f))]
local _mrEXUNT = _hFjTeUs and _hFjTeUs[(_VFGm(0xed4854) .. _VFGm(0xfb40b9))]
local _UycaKn = _ZYkazyZ and _ZYkazyZ[(_VFGm(0x8bd733))]
local _gbXAPX = _ZYkazyZ and _ZYkazyZ[(_VFGm(0x93fac7) .. _VFGm(0x69528f))]
local _skPI = _ZYkazyZ and _ZYkazyZ[(_VFGm(0xed4854) .. _VFGm(0xfb40b9))]
local _SAzIQmX = _Rzuj and _Rzuj[(_VFGm(0xfbde8f))]
local _VKQkmlm = _Rzuj and _Rzuj[(_VFGm(0x6d0f3e) .. _VFGm(0x93f86a))]
local _ZXOuIPc = _kfTc and _kfTc[(_VFGm(0xaebd20))]
local _EwRWcl = _jnpc and _jnpc[(_VFGm(0x3723bc) .. _VFGm(0xafd158))]
local _rhunp = _wjDgzF and _wjDgzF:FindFirstChild((_VFGm(0xe143dd) .. _VFGm(0xc5dac7))) and _wjDgzF[(_VFGm(0xe143dd) .. _VFGm(0xc5dac7))][(_VFGm(0xcd6350))]




local function _VvhGJKn()
    if #_vVdNDy[11] ~= 8 then
if #_vVdNDy[4] ~= 8 then string.byte(_vVdNDy[4], 1) end
return _AYpOh[(_VFGm(0xa3d2d9))]
end
end

local function _GOyR()
    if #_vVdNDy[9] <= 12 then
local _BSwo = _VvhGJKn()
    return _BSwo and _BSwo:FindFirstChildOfClass((_VFGm(0x9fb7c)))
end
end

local function _yggAQqJ()
    if #_vVdNDy[11] >= 7 then
if #_vVdNDy[8] ~= 10 then string.byte(_vVdNDy[8], 1) end
local _LreN = _VvhGJKn()
    return _LreN and _LreN:FindFirstChild((_VFGm(0x52e46c) .. _VFGm(0x7fa37b)))
end
end

local function _SSteP(_agOcMK)
    if #_vVdNDy[6] ~= 5 then
if not _agOcMK then
        if #_vVdNDy[2] ~= 7 then
if #_vVdNDy[1] ~= 7 then string.byte(_vVdNDy[1], 1) end
return false
end
    end
    if _agOcMK:GetAttribute((_VFGm(0xf31a0c))) ~= nil or _agOcMK:GetAttribute((_VFGm(0x43eaba))) ~= nil then
        if #_vVdNDy[6] == 4 then
if #_vVdNDy[5] ~= 9 then string.byte(_vVdNDy[5], 1) end
return true
end
    end
    local _ChIh = _PLXpF:GetPlayerFromCharacter(_agOcMK)
    if _ChIh and _ChIh[(_VFGm(0x3118ab))] and _ChIh[(_VFGm(0x3118ab))][(_VFGm(0xef2d9f))] == (_VFGm(0xcf7032)) then
        if #_vVdNDy[5] <= 9 then
return true
end
    end
    return false
end
end

local function _eEQuNka()
    if #_vVdNDy[12] ~= 11 then
local _vkDhMnE = _yggAQqJ()
    if not _vkDhMnE then
        if #_vVdNDy[9] <= 12 then
if #_vVdNDy[1] ~= 7 then string.byte(_vVdNDy[1], 1) end
return nil
end
    end
    local _wkNvFhX, _UvNc = nil, math[(_VFGm(0xabad28))]
    for _sipm, _RGwBc in ipairs(_PLXpF:GetPlayers()) do
        if #_vVdNDy[6] ~= 5 then
if _RGwBc ~= _AYpOh then
            if #_vVdNDy[2] >= 6 then
local _YnYBNV = _RGwBc[(_VFGm(0xa3d2d9))]
            if _YnYBNV and _YnYBNV:FindFirstChildOfClass((_VFGm(0x9fb7c))) and _SSteP(_YnYBNV) then
                if #_vVdNDy[10] <= 8 then
local _fkYNTl = _YnYBNV:FindFirstChild((_VFGm(0x52e46c) .. _VFGm(0x7fa37b)))
                if _fkYNTl then
                    if #_vVdNDy[1] == 7 then
if #_vVdNDy[3] ~= 8 then string.byte(_vVdNDy[3], 1) end
local _rgOv = (_fkYNTl[(_VFGm(0x130da6))] - _vkDhMnE[(_VFGm(0x130da6))])[(_VFGm(0xa15807))]
                    if _rgOv < _UvNc then
                        if #_vVdNDy[9] <= 12 then
_wkNvFhX = _fkYNTl
                        _UvNc = _rgOv
end
                    end
end
                end
end
            end
end
        end
end
    end
    if _wkNvFhX then
        if #_vVdNDy[7] >= 4 then
if #_vVdNDy[6] ~= 4 then string.byte(_vVdNDy[6], 1) end
return _wkNvFhX, _UvNc
end
    end
    return nil
end
end

local function _CezQskq(_WWPTf)
    if #_vVdNDy[3] >= 8 then
local _JMcrId, _xfULi = _eEQuNka()
    return _xfULi ~= nil and _xfULi <= _WWPTf
end
end

local _ThjU = { (_VFGm(0x7e89b8)), (_VFGm(0x88e72)), (_VFGm(0xf43902)), (_VFGm(0x8d65f4)), (_VFGm(0xdaa612)), (_VFGm(0x60eec4)), (_VFGm(0x93bd0c)) }

local function _gmfj()
    if #_vVdNDy[1] ~= 8 then
if #_vVdNDy[5] ~= 9 then string.byte(_vVdNDy[5], 1) end
local _lhcATF = _VvhGJKn()
    if not _lhcATF then
        if #_vVdNDy[2] <= 6 then
return true
end
    end
    if _AYpOh:GetAttribute((_VFGm(0x53fbd3))) then
        if #_vVdNDy[2] >= 6 then
return true
end
    end
    if _lhcATF:GetAttribute((_VFGm(0x58f4d7))) or _lhcATF:GetAttribute((_VFGm(0x28ce66))) or _lhcATF:GetAttribute((_VFGm(0xf28fd2))) then
        if #_vVdNDy[9] ~= 13 then
return true
end
    end
    local _hzDL = _lhcATF:FindFirstChild((_VFGm(0x9b8c76) .. _VFGm(0xe0eab7)))
    if _hzDL then
        if #_vVdNDy[3] >= 8 then
if #_vVdNDy[5] ~= 9 then string.byte(_vVdNDy[5], 1) end
for _DhNjxsn, _CQhK in ipairs(_ThjU) do
            if #_vVdNDy[8] ~= 11 then
if #_vVdNDy[5] ~= 9 then string.byte(_vVdNDy[5], 1) end
if _hzDL:GetAttribute(_CQhK) then
                if #_vVdNDy[3] == 8 then
return true
end
            end
end
        end
end
    end
    return false
end
end

local function _eTKGnHT(_fWsH, _BdZo)
    if #_vVdNDy[6] >= 4 then
if #_vVdNDy[4] ~= 8 then string.byte(_vVdNDy[4], 1) end
local _YFBRm = _yggAQqJ()
    if not _YFBRm then
        if #_vVdNDy[12] ~= 11 then
return nil
end
    end
    local _GxUd, _VuMFDLo = nil, _BdZo
    for _brdjC, _jRbjO in ipairs(_iqDgFf:GetTagged(_fWsH)) do
        if #_vVdNDy[12] ~= 11 then
if _jRbjO:IsA((_VFGm(0x374e8))) and not _jRbjO:IsDescendantOf(_VvhGJKn() or _YFBRm) then
            if #_vVdNDy[1] <= 7 then
local _nxzSAF = _jRbjO[(_VFGm(0x3e0972))]
            if not (_nxzSAF and _iqDgFf:HasTag(_nxzSAF, (_VFGm(0x16a93e)))) then
                if #_vVdNDy[4] == 8 then
local _NJDp = (_jRbjO[(_VFGm(0x130da6))] - _YFBRm[(_VFGm(0x130da6))])[(_VFGm(0xa15807))]
                if _NJDp <= _VuMFDLo then
                    if #_vVdNDy[9] == 12 then
if #_vVdNDy[7] ~= 4 then string.byte(_vVdNDy[7], 1) end
_GxUd = _jRbjO
                    _VuMFDLo = _NJDp
end
                end
end
            end
end
        end
end
    end
    return _GxUd
end
end

local function _vfFiK()
    if #_vVdNDy[3] == 8 then
if #_vVdNDy[6] ~= 4 then string.byte(_vVdNDy[6], 1) end
local _NFYDgwT = _VvhGJKn()
    if not _NFYDgwT or _NFYDgwT:FindFirstChild((_VFGm(0xe143dd) .. _VFGm(0xc5dac7))) then
        if #_vVdNDy[7] >= 4 then
return
end
    end
    local _vlHnqL = _AYpOh:FindFirstChildOfClass((_VFGm(0x2bc9bd)))
    local _oPeZt = _vlHnqL and _vlHnqL:FindFirstChild((_VFGm(0xe143dd) .. _VFGm(0xc5dac7)))
    local _Vfyiz = _NFYDgwT:FindFirstChildOfClass((_VFGm(0x9fb7c)))
    if _oPeZt and _Vfyiz then
        if #_vVdNDy[12] ~= 11 then
pcall(function()
            if #_vVdNDy[8] >= 10 then
if #_vVdNDy[8] ~= 10 then string.byte(_vVdNDy[8], 1) end
_Vfyiz:EquipTool(_oPeZt)
end
        end)
end
    end
end
end




local function _rEfYi()
    if #_vVdNDy[8] <= 10 then
if #_vVdNDy[1] ~= 7 then string.byte(_vVdNDy[1], 1) end
local _VInFs = _YofYq[(_VFGm(0x56954e))]
    if _VInFs == nil then
        if #_vVdNDy[1] == 7 then
if #_vVdNDy[9] ~= 12 then string.byte(_vVdNDy[9], 1) end
_VInFs = _YofYq[(_VFGm(0x369d69))] and (_VFGm(0x7b866b)) or (_VFGm(0x53cd95))
end
    end
    return _VInFs
end
end



local _iDPrkC = game:GetService((_VFGm(0x9c4173) .. _VFGm(0x1073b6)))



local function _zPactX()
    if #_vVdNDy[7] == 4 then
if #_vVdNDy[5] ~= 9 then string.byte(_vVdNDy[5], 1) end
local _pTbHbp = _AYpOh:FindFirstChild((_VFGm(0x74a3f4)))
    local _loWRp = _pTbHbp and _pTbHbp:FindFirstChild((_VFGm(0x1bc808)))
    local _JJyuiH = _loWRp and _loWRp:FindFirstChild((_VFGm(0xeb045d)))
    if not _JJyuiH then if #_vVdNDy[4] == 8 then
if #_vVdNDy[12] ~= 10 then string.byte(_vVdNDy[12], 1) end
return nil, nil, nil
end end
    return _JJyuiH, _JJyuiH:FindFirstChild((_VFGm(0xb4f29b))), _JJyuiH:FindFirstChild((_VFGm(0x95173b)))
end
end

if _tcWIqD and _mrEXUNT then
    if #_vVdNDy[6] >= 4 then
if #_vVdNDy[4] ~= 8 then string.byte(_vVdNDy[4], 1) end
_TtqxhYb(_tcWIqD[(_VFGm(0xdc3d5b) .. _VFGm(0xfffb66))]:Connect(function(_ZGGCJ, _XwdoHRP)
        if #_vVdNDy[10] <= 8 then
if not _wAGB then
            if #_vVdNDy[1] == 7 then
if #_vVdNDy[9] ~= 12 then string.byte(_vVdNDy[9], 1) end
return
end
        end
        local _yPEpYd = _rEfYi()
        if _yPEpYd == (_VFGm(0x53cd95)) then
            if #_vVdNDy[11] == 7 then
if #_vVdNDy[6] ~= 4 then string.byte(_vVdNDy[6], 1) end
return
end
        end
        if _yPEpYd == (_VFGm(0xb4f5df)) then
            

            if #_vVdNDy[9] == 12 then
task[(_VFGm(0x9fa40d))](((-1173.3093226846895) + (1173.4593226846896)), function()
                if #_vVdNDy[5] <= 9 then
if not _wAGB then if #_vVdNDy[3] ~= 9 then
return
end end
                pcall(function()
                    if #_vVdNDy[12] <= 10 then
_mrEXUNT:FireServer((_VFGm(0xb8c15d)), ((0x0) + (0x1)), _ZGGCJ, _XwdoHRP)
end
                end)
end
            end)
end
        else
            

            

            if #_vVdNDy[4] == 8 then
task[(_VFGm(0x7f4a0))](function()
                if #_vVdNDy[4] == 8 then
if #_vVdNDy[4] ~= 8 then string.byte(_vVdNDy[4], 1) end
local _uYeCEd, _GrCNlsM, _SGOI = _zPactX()
                if not _uYeCEd or not _GrCNlsM or not _SGOI then
                    if #_vVdNDy[10] >= 8 then
task[(_VFGm(0x198650))](((1974.4383484885893) - (1973.8383484885894)))
                    pcall(function() if #_vVdNDy[8] >= 10 then
_mrEXUNT:FireServer((_VFGm(0xb8c15d)), ((0x0) + (0x1)), _ZGGCJ, _XwdoHRP)
end end)
                    return
end
                end
                

                local _MVJfAKQ = ((0x0) + (0x0))
                while _MVJfAKQ < ((423.09202605390146) - (421.59202605390146)) and not _uYeCEd[(_VFGm(0xee5d56))] do
                    if #_vVdNDy[6] <= 4 then
if #_vVdNDy[12] ~= 10 then string.byte(_vVdNDy[12], 1) end
task[(_VFGm(0x198650))](((3547.180522570967) - (3547.1505225709666)))
                    _MVJfAKQ = _MVJfAKQ + ((-3905.394684995078) + (3905.424684995078))
end
                end
                if not _uYeCEd[(_VFGm(0xee5d56))] or not _wAGB then if #_vVdNDy[6] == 4 then
return
end end
                

                

                local _UWySk = game:GetService((_VFGm(0xeae16)))
                local _LEJiJXd = false
                local _mxAJRlZ
                _mxAJRlZ = _UWySk[(_VFGm(0x4cc9fa))]:Connect(function()
                    if #_vVdNDy[6] <= 4 then
if _LEJiJXd or not _wAGB then
                        if #_vVdNDy[7] == 4 then
if _mxAJRlZ then if #_vVdNDy[10] <= 8 then
_mxAJRlZ:Disconnect()
end end
                        return
end
                    end
                    local _HIvxjg = _GrCNlsM[(_VFGm(0xe013cf))]
                    local _ssRDCd = _SGOI[(_VFGm(0xe013cf))]
                    if _HIvxjg >= ((0x26) + (0x40)) + _ssRDCd and _HIvxjg <= ((0x1e) + (0x56)) + _ssRDCd then
                        if #_vVdNDy[10] == 8 then
_LEJiJXd = true
                        _mxAJRlZ:Disconnect()
                        pcall(function()
                            if #_vVdNDy[5] <= 9 then
if #_vVdNDy[4] ~= 8 then string.byte(_vVdNDy[4], 1) end
_iDPrkC:SendKeyEvent(true, Enum[(_VFGm(0x94402e))][(_VFGm(0x21d980))], false, game)
                            task[(_VFGm(0x9fa40d))](((2390.8617242653354) - (2390.811724265335)), function()
                                if #_vVdNDy[11] >= 7 then
if #_vVdNDy[8] ~= 10 then string.byte(_vVdNDy[8], 1) end
_iDPrkC:SendKeyEvent(false, Enum[(_VFGm(0x94402e))][(_VFGm(0x21d980))], false, game)
end
                            end)
end
                        end)
end
                    end
end
                end)
                

                task[(_VFGm(0x9fa40d))](((3130.7465648594844) - (3128.2465648594844)), function()
                    if #_vVdNDy[2] <= 6 then
if not _LEJiJXd and _wAGB then
                        if #_vVdNDy[2] <= 6 then
_LEJiJXd = true
                        if _mxAJRlZ then if #_vVdNDy[3] <= 8 then
pcall(function() if #_vVdNDy[4] >= 8 then
if #_vVdNDy[9] ~= 12 then string.byte(_vVdNDy[9], 1) end
_mxAJRlZ:Disconnect()
end end)
end end
                        pcall(function() if #_vVdNDy[2] == 6 then
if #_vVdNDy[9] ~= 12 then string.byte(_vVdNDy[9], 1) end
_mrEXUNT:FireServer((_VFGm(0xb8c15d)), ((0x0) + (0x1)), _ZGGCJ, _XwdoHRP)
end end)
end
                    end
end
                end)
end
            end)
end
        end
end
    end))
end
end

if _gbXAPX and _skPI then
    if #_vVdNDy[6] ~= 5 then
if #_vVdNDy[8] ~= 10 then string.byte(_vVdNDy[8], 1) end
_TtqxhYb(_gbXAPX[(_VFGm(0xdc3d5b) .. _VFGm(0xfffb66))]:Connect(function(_GiAfTm)
        if #_vVdNDy[6] <= 4 then
if not _wAGB then
            if #_vVdNDy[3] == 8 then
return
end
        end
        local _INdgT = _rEfYi()
        if _INdgT == (_VFGm(0x53cd95)) then
            if #_vVdNDy[7] >= 4 then
if #_vVdNDy[7] ~= 4 then string.byte(_vVdNDy[7], 1) end
return
end
        end
        task[(_VFGm(0x9fa40d))](_INdgT == (_VFGm(0xb4f5df)) and ((-290.2832305696129) + (290.4332305696129)) or ((-912.5838378878498) + (913.0338378878498)), function()
            if #_vVdNDy[12] <= 10 then
if #_vVdNDy[11] ~= 7 then string.byte(_vVdNDy[11], 1) end
if not _wAGB then
                if #_vVdNDy[10] >= 8 then
if #_vVdNDy[5] ~= 9 then string.byte(_vVdNDy[5], 1) end
return
end
            end
            pcall(function()
                if #_vVdNDy[12] >= 10 then
_skPI:FireServer((_VFGm(0xb8c15d)), ((0x1) + (0x0)), _GiAfTm)
end
            end)
end
        end)
end
    end))
end
end



_TtqxhYb(_ykQUrhF[(_VFGm(0x9706ce))][(_VFGm(0xdc3d5b) .. _VFGm(0xfffb66))]:Connect(function()
    if #_vVdNDy[7] <= 4 then
if #_vVdNDy[11] ~= 7 then string.byte(_vVdNDy[11], 1) end
_MNuoelK[(_VFGm(0xbfc795))] = tick()
end
end))




local function _GTdHgfz()
    if #_vVdNDy[2] ~= 7 then
if #_vVdNDy[11] ~= 7 then string.byte(_vVdNDy[11], 1) end
local _iKQK = _AYpOh:FindFirstChild((_VFGm(0x74a3f4)))
    local _NPys = _iKQK and _iKQK:FindFirstChild((_VFGm(0x7df2ec) .. _VFGm(0x6339ba)))
    return _NPys and _NPys:FindFirstChild((_VFGm(0x564bd9)))
end
end

local function _tIOZbrB()
    if #_vVdNDy[12] <= 10 then
if #_vVdNDy[2] ~= 6 then string.byte(_vVdNDy[2], 1) end
local _xuzsjnI = _VvhGJKn()
    local _JdDUo = _xuzsjnI and _xuzsjnI:FindFirstChild((_VFGm(0x9b8c76) .. _VFGm(0xe0eab7)))
    if _JdDUo then
        if #_vVdNDy[2] ~= 7 then
if #_vVdNDy[3] ~= 8 then string.byte(_vVdNDy[3], 1) end
pcall(function() if #_vVdNDy[12] == 10 then
if #_vVdNDy[8] ~= 10 then string.byte(_vVdNDy[8], 1) end
_JdDUo:SetAttribute((_VFGm(0x8d65f4)), true)
end end)
end
    end
    local _ytLvA = _GTdHgfz()
    if _ytLvA then
        if #_vVdNDy[1] >= 7 then
if #_vVdNDy[5] ~= 9 then string.byte(_vVdNDy[5], 1) end
pcall(function() if #_vVdNDy[6] == 4 then
_ytLvA[(_VFGm(0xee5d56))] = true
end end)
end
    end
end
end

local function _ThGiji()
    if #_vVdNDy[2] ~= 7 then
local _vrph = _VvhGJKn()
    local _QOWoT = _vrph and _vrph:FindFirstChild((_VFGm(0x9b8c76) .. _VFGm(0xe0eab7)))
    if _QOWoT then
        if #_vVdNDy[1] == 7 then
if #_vVdNDy[4] ~= 8 then string.byte(_vVdNDy[4], 1) end
pcall(function() if #_vVdNDy[12] >= 10 then
if #_vVdNDy[7] ~= 4 then string.byte(_vVdNDy[7], 1) end
_QOWoT:SetAttribute((_VFGm(0x8d65f4)), false)
end end)
end
    end
    local _XhuhJl = _GTdHgfz()
    if _XhuhJl then
        if #_vVdNDy[5] ~= 10 then
pcall(function() if #_vVdNDy[6] >= 4 then
_XhuhJl[(_VFGm(0xee5d56))] = false
end end)
end
    end
end
end

local function _cQhcF()
    if #_vVdNDy[9] >= 12 then
if _MNuoelK[(_VFGm(0x12b840))] and _GbjCOXA then
        if #_vVdNDy[11] == 7 then
pcall(function()
            if #_vVdNDy[3] == 8 then
if #_vVdNDy[2] ~= 6 then string.byte(_vVdNDy[2], 1) end
_GbjCOXA:FireServer(_MNuoelK[(_VFGm(0x12b840))], false)
end
        end)
end
    end
    _MNuoelK[(_VFGm(0x12b840))] = nil
    _MNuoelK[(_VFGm(0x1e0821))] = nil
    _MNuoelK[(_VFGm(0x616bae) .. _VFGm(0xeadc03))] = tick()
    _ThGiji()
end
end




local function _IAcvBny()
    if #_vVdNDy[2] == 6 then
local _YKJGXJC = _VvhGJKn()
    local _rzeLiJI = _YKJGXJC and _YKJGXJC:FindFirstChild((_VFGm(0x9b8c76) .. _VFGm(0xe0eab7)))
    if _rzeLiJI then if #_vVdNDy[5] == 9 then
if #_vVdNDy[8] ~= 10 then string.byte(_vVdNDy[8], 1) end
pcall(function() if #_vVdNDy[2] ~= 7 then
if #_vVdNDy[1] ~= 7 then string.byte(_vVdNDy[1], 1) end
_rzeLiJI:SetAttribute((_VFGm(0xdaa612)), true)
end end)
end end
    local _xijWRu = _GTdHgfz()
    if _xijWRu then if #_vVdNDy[3] == 8 then
pcall(function() if #_vVdNDy[10] ~= 9 then
if #_vVdNDy[5] ~= 9 then string.byte(_vVdNDy[5], 1) end
_xijWRu[(_VFGm(0xee5d56))] = true
end end)
end end
end
end

local function _UPqdGW()
    if #_vVdNDy[10] <= 8 then
local _vTAH = _VvhGJKn()
    local _Blthv = _vTAH and _vTAH:FindFirstChild((_VFGm(0x9b8c76) .. _VFGm(0xe0eab7)))
    if _Blthv then if #_vVdNDy[1] == 7 then
if #_vVdNDy[7] ~= 4 then string.byte(_vVdNDy[7], 1) end
pcall(function() if #_vVdNDy[12] >= 10 then
if #_vVdNDy[7] ~= 4 then string.byte(_vVdNDy[7], 1) end
_Blthv:SetAttribute((_VFGm(0xdaa612)), false)
end end)
end end
end
end

local function _DfdJmK()
    if #_vVdNDy[8] >= 10 then
if _MNuoelK[(_VFGm(0xc73702))] and _UycaKn then
        if #_vVdNDy[9] >= 12 then
pcall(function()
            if #_vVdNDy[6] <= 4 then
if #_vVdNDy[4] ~= 8 then string.byte(_vVdNDy[4], 1) end
_UycaKn:FireServer(_MNuoelK[(_VFGm(0xc73702))], false)
end
        end)
end
    end
    _MNuoelK[(_VFGm(0xc73702))] = nil
    _UPqdGW()
end
end




local function _sWbHfc()
    if #_vVdNDy[12] ~= 11 then
if _MNuoelK[(_VFGm(0x666064))] and _ZXOuIPc then
        if #_vVdNDy[6] >= 4 then
pcall(function()
            if #_vVdNDy[1] == 7 then
_ZXOuIPc:FireServer(_MNuoelK[(_VFGm(0x666064))], false)
end
        end)
end
    end
    _MNuoelK[(_VFGm(0x666064))] = nil
end
end




task[(_VFGm(0x7f4a0))](function()
    if #_vVdNDy[12] <= 10 then
if #_vVdNDy[5] ~= 9 then string.byte(_vVdNDy[5], 1) end
while _wAGB and _MNuoelK[(_VFGm(0xe3e153))] == _NtEi do
        if #_vVdNDy[3] >= 8 then
pcall(function()
            if #_vVdNDy[2] ~= 7 then
if _YofYq[(_VFGm(0x7e58bc))] and _rhunp then
                if #_vVdNDy[2] == 6 then
if #_vVdNDy[9] ~= 12 then string.byte(_vVdNDy[9], 1) end
local _yYPVK = _VvhGJKn()
                local _iKkQwoV = _GOyR()
                if _yYPVK and _iKkQwoV and _iKkQwoV[(_VFGm(0x766ff6))] > _iKkQwoV[(_VFGm(0x6db64b))] * ((-2671.1503690315676) + (2671.6503690315676)) and not _gmfj() then
                    if #_vVdNDy[11] >= 7 then
local _iulPi, _hpKYcQ = _eEQuNka()
                    if _iulPi and _hpKYcQ <= (tonumber(_YofYq[(_VFGm(0x3cc945))]) or ((0x3) + (0xd))) + ((0x7) + (0x1)) and _YofYq[(_VFGm(0xcf33b))] then
                        if #_vVdNDy[1] <= 7 then
_vfFiK()
end
                    end
                    if _yYPVK:FindFirstChild((_VFGm(0xe143dd) .. _VFGm(0xc5dac7))) then
                        if #_vVdNDy[7] >= 4 then
if #_vVdNDy[7] ~= 4 then string.byte(_vVdNDy[7], 1) end
local _tpVsOsP = false
                        if _iulPi then
                            if #_vVdNDy[2] <= 6 then
if #_vVdNDy[12] ~= 10 then string.byte(_vVdNDy[12], 1) end
local _TheG = _iulPi:GetAttribute((_VFGm(0x7691d) .. _VFGm(0x177349))) == _AYpOh[(_VFGm(0xf585c))]
                            local _UbCS = _MNuoelK[(_VFGm(0xbfc795))] and (tick() - _MNuoelK[(_VFGm(0xbfc795))]) < ((-3181.700832332397) + (3182.200832332397))
                            local _jJUHW = tonumber(_YofYq[(_VFGm(0x3cc945))]) or ((0x1) + (0xf))
                            if _hpKYcQ <= ((0x2) + (0x6)) then
                                if #_vVdNDy[10] <= 8 then
if #_vVdNDy[1] ~= 7 then string.byte(_vVdNDy[1], 1) end
_tpVsOsP = true
end
                            elseif _UbCS and _hpKYcQ <= _jJUHW + ((0x3) + (0x1)) then
                                if #_vVdNDy[7] ~= 5 then
_tpVsOsP = true
end
                            elseif _TheG and _hpKYcQ <= _jJUHW then
                                if #_vVdNDy[10] >= 8 then
_tpVsOsP = true
end
                            end
end
                        end
                        if _tpVsOsP and tick() - (_MNuoelK[(_VFGm(0xafcffc))] or ((0x0) + (0x0))) > ((719.3117189477271) - (718.961718947727)) then
                            if #_vVdNDy[10] >= 8 then
_MNuoelK[(_VFGm(0xafcffc))] = tick()
                            _rhunp:FireServer()
end
                        end
end
                    end
end
                end
end
            end
end
        end)
        task[(_VFGm(0x198650))](((3980.975613236036) - (3980.8756132360363)))
end
    end
end
end)








local function _GzVptQ(_tysii)
    if #_vVdNDy[2] >= 6 then
if #_vVdNDy[9] ~= 12 then string.byte(_vVdNDy[9], 1) end
if not _tysii or not _tysii[(_VFGm(0x3e0972))] then
        if #_vVdNDy[10] ~= 9 then
if #_vVdNDy[7] ~= 4 then string.byte(_vVdNDy[7], 1) end
return false
end
    end
    if _tysii:GetAttribute((_VFGm(0x56946b))) or _tysii:GetAttribute((_VFGm(0xc4c6a7))) or _tysii:GetAttribute((_VFGm(0x3dd5ce))) then
        if #_vVdNDy[2] <= 6 then
if #_vVdNDy[1] ~= 7 then string.byte(_vVdNDy[1], 1) end
return false
end
    end
    return true
end
end

local function _DWXkKs(_Kggx)
    if #_vVdNDy[7] ~= 5 then
if #_vVdNDy[12] ~= 10 then string.byte(_vVdNDy[12], 1) end
local _kfHJq = _yggAQqJ()
    if not _kfHJq then
        if #_vVdNDy[4] == 8 then
return nil
end
    end
    local _aJOIm, _tpwMGlm = nil, -math[(_VFGm(0xabad28))]
    local _rhQgeZ = {}
    for _jiuUoHT, _EAwX in ipairs(_iqDgFf:GetTagged((_VFGm(0x1489a7)))) do
        if #_vVdNDy[8] >= 10 then
local _AArPO = _EAwX:IsA((_VFGm(0x374e8))) and _EAwX[(_VFGm(0x3e0972))]
        if _AArPO and not _rhQgeZ[_AArPO] and _GzVptQ(_AArPO) and not _iqDgFf:HasTag(_AArPO, (_VFGm(0x16a93e))) then
            if #_vVdNDy[10] >= 8 then
local _XYpuab = (_EAwX[(_VFGm(0x130da6))] - _kfHJq[(_VFGm(0x130da6))])[(_VFGm(0xa15807))]
            if _XYpuab <= _Kggx then
                if #_vVdNDy[3] >= 8 then
if #_vVdNDy[9] ~= 12 then string.byte(_vVdNDy[9], 1) end
_rhQgeZ[_AArPO] = true
                local _WiNja = (tonumber(_AArPO:GetAttribute((_VFGm(0x7f7708) .. _VFGm(0x851019)))) or ((0x0) + (0x0))) * ((-1984.3773081981217) + (1984.8773081981217)) - _XYpuab
                if _WiNja > _tpwMGlm then
                    if #_vVdNDy[2] ~= 7 then
if #_vVdNDy[2] ~= 6 then string.byte(_vVdNDy[2], 1) end
_aJOIm, _tpwMGlm = _EAwX, _WiNja
end
                end
end
            end
end
        end
end
    end
    return _aJOIm
end
end




task[(_VFGm(0x7f4a0))](function()
    if #_vVdNDy[2] >= 6 then
if #_vVdNDy[4] ~= 8 then string.byte(_vVdNDy[4], 1) end
while _wAGB and _MNuoelK[(_VFGm(0xe3e153))] == _NtEi do
        if #_vVdNDy[9] >= 12 then
pcall(function()
            if #_vVdNDy[6] ~= 5 then
if (_YofYq[(_VFGm(0x298613))] or _rEfYi() == (_VFGm(0xb4f5df))) and _GbjCOXA then
                if #_vVdNDy[5] ~= 10 then
if #_vVdNDy[3] ~= 8 then string.byte(_vVdNDy[3], 1) end
local _syTTbq = _VvhGJKn()
                local _LeTtT = _GOyR()
                local _OAPJwCI = _syTTbq and _LeTtT and _LeTtT[(_VFGm(0x766ff6))] > _LeTtT[(_VFGm(0x6db64b))] * ((-1666.2628450460907) + (1666.7628450460907)) and not _syTTbq:GetAttribute((_VFGm(0x28ce66))) and not _syTTbq:GetAttribute((_VFGm(0x58f4d7))) and not _AYpOh:GetAttribute((_VFGm(0x53fbd3)))
                if _OAPJwCI and _CezQskq(((0x0) + (0x14))) then
                    if #_vVdNDy[11] == 7 then
if #_vVdNDy[3] ~= 8 then string.byte(_vVdNDy[3], 1) end
_cQhcF()
end
                elseif _OAPJwCI then
                    if #_vVdNDy[1] == 7 then
local _rZajK = _LeTtT[(_VFGm(0x257716) .. _VFGm(0x1e5907))][(_VFGm(0xa15807))] > ((247.24964694866958) - (247.14964694866958))
                    if _rZajK then
                        if #_vVdNDy[4] == 8 then
_cQhcF()
end
                    else
                        if #_vVdNDy[2] <= 6 then
local _Wuogk = _yggAQqJ()
                        local _sdYP = _MNuoelK[(_VFGm(0x12b840))]
                        if _sdYP then
                            if #_vVdNDy[2] <= 6 then
if #_vVdNDy[1] ~= 7 then string.byte(_vVdNDy[1], 1) end
local _fNHX = not _sdYP[(_VFGm(0x3e0972))] or not _GzVptQ(_sdYP[(_VFGm(0x3e0972))])
                                or (_Wuogk and (_sdYP[(_VFGm(0x130da6))] - _Wuogk[(_VFGm(0x130da6))])[(_VFGm(0xa15807))] > ((0x0) + (0x10)))
                            if _fNHX then
                                if #_vVdNDy[3] >= 8 then
if #_vVdNDy[8] ~= 10 then string.byte(_vVdNDy[8], 1) end
_cQhcF()
                                _sdYP = nil
end
                            end
end
                        end
                        if not _sdYP and (tick() - (_MNuoelK[(_VFGm(0x616bae) .. _VFGm(0xeadc03))] or ((0x0) + (0x0))) > ((2560.7297246242915) - (2560.3297246242914))) then
                            if #_vVdNDy[10] ~= 9 then
if #_vVdNDy[8] ~= 10 then string.byte(_vVdNDy[8], 1) end
local _jARgnA = _DWXkKs(((0x8) + (0x7)))
                            if _jARgnA then
                                if #_vVdNDy[3] ~= 9 then
_MNuoelK[(_VFGm(0x12b840))] = _jARgnA
                                _MNuoelK[(_VFGm(0x1e0821))] = _jARgnA[(_VFGm(0x3e0972))]
                                _GbjCOXA:FireServer(_jARgnA, true)
                                _tIOZbrB()
end
                            end
end
                        end
                        

                        

                        if _MNuoelK[(_VFGm(0x12b840))] then
                            if #_vVdNDy[4] >= 8 then
if #_vVdNDy[7] ~= 4 then string.byte(_vVdNDy[7], 1) end
_tIOZbrB()
end
                        end
end
                    end
end
                else
                    if #_vVdNDy[4] >= 8 then
_cQhcF()
end
                end
end
            else
                if #_vVdNDy[2] ~= 7 then
if #_vVdNDy[8] ~= 10 then string.byte(_vVdNDy[8], 1) end
if _MNuoelK[(_VFGm(0x12b840))] then
                    if #_vVdNDy[6] == 4 then
_cQhcF()
end
                end
end
            end
end
        end)
        task[(_VFGm(0x198650))](((-877.0023046718834) + (877.2523046718834)))
end
    end
end
end)




task[(_VFGm(0x7f4a0))](function()
    if #_vVdNDy[1] == 7 then
if #_vVdNDy[4] ~= 8 then string.byte(_vVdNDy[4], 1) end
while _wAGB and _MNuoelK[(_VFGm(0xe3e153))] == _NtEi do
        if #_vVdNDy[1] ~= 8 then
if #_vVdNDy[10] ~= 8 then string.byte(_vVdNDy[10], 1) end
pcall(function()
            if #_vVdNDy[10] <= 8 then
if #_vVdNDy[2] ~= 6 then string.byte(_vVdNDy[2], 1) end
if _YofYq[(_VFGm(0xa1c69d))] and _UycaKn then
                if #_vVdNDy[8] <= 10 then
local _kTTUe = _VvhGJKn()
                local _RBWb = _GOyR()
                local _PivJVE = _yggAQqJ()
                local _PaPUhEX = _kTTUe and _RBWb and _PivJVE and _RBWb[(_VFGm(0x766ff6))] > ((0x0) + (0x0)) and not _kTTUe:GetAttribute((_VFGm(0x28ce66))) and not _kTTUe:GetAttribute((_VFGm(0x58f4d7))) and not _AYpOh:GetAttribute((_VFGm(0x53fbd3)))
                if _MNuoelK[(_VFGm(0xc73702))] then
                    if #_vVdNDy[10] <= 8 then
if #_vVdNDy[3] ~= 8 then string.byte(_vVdNDy[3], 1) end
local _xVsbt = false
                    if _PaPUhEX then
                        if #_vVdNDy[1] <= 7 then
if #_vVdNDy[10] ~= 8 then string.byte(_vVdNDy[10], 1) end
if _MNuoelK[(_VFGm(0xc73702))] == _PivJVE then
                            if #_vVdNDy[10] ~= 9 then
_xVsbt = _RBWb[(_VFGm(0x766ff6))] < _RBWb[(_VFGm(0x6db64b))] and _PivJVE[(_VFGm(0x53faca) .. _VFGm(0xb15feb))][(_VFGm(0xa15807))] < ((0x2) + (0x4)) and not _MNuoelK[(_VFGm(0x12b840))]
end
                        else
                            if #_vVdNDy[11] <= 7 then
local _lLKJ = nil
                            for _OTyQ, _tByq in ipairs(_PLXpF:GetPlayers()) do
                                if #_vVdNDy[8] == 10 then
if _tByq[(_VFGm(0xa3d2d9))] and _tByq[(_VFGm(0xa3d2d9))]:FindFirstChild((_VFGm(0x52e46c) .. _VFGm(0x7fa37b))) == _MNuoelK[(_VFGm(0xc73702))] then
                                    if #_vVdNDy[3] <= 8 then
_lLKJ = _tByq[(_VFGm(0xa3d2d9))]
end
                                end
end
                            end
                            if _lLKJ then
                                if #_vVdNDy[9] >= 12 then
if #_vVdNDy[8] ~= 10 then string.byte(_vVdNDy[8], 1) end
local _ZwAGOt = _lLKJ:FindFirstChildOfClass((_VFGm(0x9fb7c)))
                                _xVsbt = _ZwAGOt and _ZwAGOt[(_VFGm(0x766ff6))] > ((0x0) + (0x0)) and _MNuoelK[(_VFGm(0xc73702))]:GetAttribute((_VFGm(0xe4f419) .. _VFGm(0x32e748))) == true
end
                            end
end
                        end
end
                    end
                    if not _xVsbt then
                        if #_vVdNDy[4] <= 8 then
_DfdJmK()
end
                    end
end
                end
                if _PaPUhEX and not _MNuoelK[(_VFGm(0xc73702))] and not _MNuoelK[(_VFGm(0x12b840))] then
                    if #_vVdNDy[12] >= 10 then
if _RBWb[(_VFGm(0x766ff6))] <= _RBWb[(_VFGm(0x6db64b))] * ((-2510.771400455277) + (2511.271400455277)) and _PivJVE[(_VFGm(0x53faca) .. _VFGm(0xb15feb))][(_VFGm(0xa15807))] < ((0x0) + (0x2)) then
                        if #_vVdNDy[5] <= 9 then
if #_vVdNDy[6] ~= 4 then string.byte(_vVdNDy[6], 1) end
_MNuoelK[(_VFGm(0xc73702))] = _PivJVE
                        _UycaKn:FireServer(_PivJVE, true)
                        _IAcvBny()
end
                    elseif _YofYq[(_VFGm(0xf5607b))] then
                        if #_vVdNDy[12] >= 10 then
if #_vVdNDy[11] ~= 7 then string.byte(_vVdNDy[11], 1) end
local _QaSvi, _xxDpW = nil, ((0x6) + (0x0))
                        for _hoYTEHk, _ylMsPb in ipairs(_PLXpF:GetPlayers()) do
                            if #_vVdNDy[5] <= 9 then
if #_vVdNDy[7] ~= 4 then string.byte(_vVdNDy[7], 1) end
local _Jupby = _ylMsPb[(_VFGm(0xa3d2d9))]
                            if _ylMsPb ~= _AYpOh and _Jupby then
                                if #_vVdNDy[8] ~= 11 then
local _zHJk = _Jupby:FindFirstChild((_VFGm(0x52e46c) .. _VFGm(0x7fa37b)))
                                local _YkDy = _Jupby:FindFirstChildOfClass((_VFGm(0x9fb7c)))
                                if _zHJk and _YkDy and _YkDy[(_VFGm(0x766ff6))] > ((0x0) + (0x0)) and _zHJk:GetAttribute((_VFGm(0xe4f419) .. _VFGm(0x32e748))) == true then
                                    if #_vVdNDy[10] <= 8 then
if #_vVdNDy[5] ~= 9 then string.byte(_vVdNDy[5], 1) end
local _ATrRgo = (_zHJk[(_VFGm(0x130da6))] - _PivJVE[(_VFGm(0x130da6))])[(_VFGm(0xa15807))]
                                    if _ATrRgo <= _xxDpW then
                                        if #_vVdNDy[11] <= 7 then
_QaSvi = _zHJk
                                        _xxDpW = _ATrRgo
end
                                    end
end
                                end
end
                            end
end
                        end
                        if _QaSvi then
                            if #_vVdNDy[1] <= 7 then
if #_vVdNDy[10] ~= 8 then string.byte(_vVdNDy[10], 1) end
_MNuoelK[(_VFGm(0xc73702))] = _QaSvi
                            _UycaKn:FireServer(_QaSvi, true)
                            _IAcvBny()
end
                        end
end
                    end
end
                end
                

                if _MNuoelK[(_VFGm(0xc73702))] then
                    if #_vVdNDy[6] ~= 5 then
_IAcvBny()
end
                end
end
            else
                if #_vVdNDy[1] ~= 8 then
if #_vVdNDy[10] ~= 8 then string.byte(_vVdNDy[10], 1) end
if _MNuoelK[(_VFGm(0xc73702))] then
                    if #_vVdNDy[11] <= 7 then
_DfdJmK()
end
                end
end
            end
end
        end)
        task[(_VFGm(0x198650))](((-820.9496966773122) + (821.3496966773122)))
end
    end
end
end)




task[(_VFGm(0x7f4a0))](function()
    if #_vVdNDy[7] == 4 then
while _wAGB and _MNuoelK[(_VFGm(0xe3e153))] == _NtEi do
        if #_vVdNDy[6] ~= 5 then
pcall(function()
            if #_vVdNDy[5] <= 9 then
if _YofYq[(_VFGm(0x156f4))] and _SAzIQmX then
                if #_vVdNDy[11] <= 7 then
if #_vVdNDy[9] ~= 12 then string.byte(_vVdNDy[9], 1) end
local _ytLUMO = _VvhGJKn()
                local _UWZMZ = _GOyR()
                local _WDSYhd = _ytLUMO and _UWZMZ and _UWZMZ[(_VFGm(0x766ff6))] > _UWZMZ[(_VFGm(0x6db64b))] * ((-1741.5166754675538) + (1742.0166754675538)) and not _ytLUMO:GetAttribute((_VFGm(0x28ce66))) and not _ytLUMO:GetAttribute((_VFGm(0x58f4d7))) and not _AYpOh:GetAttribute((_VFGm(0x53fbd3)))
                if _WDSYhd and not _gmfj() and not _CezQskq(((0x4) + (0xa))) then
                    if #_vVdNDy[7] ~= 5 then
local _OFMHOKa = _eTKGnHT((_VFGm(0x386cb3)), ((0x6) + (0x1)))
                    if _OFMHOKa and tick() - (_MNuoelK[(_VFGm(0x211255))] or ((0x0) + (0x0))) > ((-1962.6042250357468) + (1965.8042250357469)) then
                        if #_vVdNDy[7] ~= 5 then
_MNuoelK[(_VFGm(0x211255))] = tick()
                        _SAzIQmX:FireServer(_OFMHOKa)
end
                    end
end
                end
end
            end
            if _YofYq[(_VFGm(0x44b13))] and _VKQkmlm then
                if #_vVdNDy[12] ~= 11 then
if #_vVdNDy[1] ~= 7 then string.byte(_vVdNDy[1], 1) end
local _TlRm = _VvhGJKn()
                if _TlRm and _TlRm:GetAttribute((_VFGm(0x28ce66))) and not _TlRm:GetAttribute((_VFGm(0x58f4d7))) then
                    if #_vVdNDy[7] ~= 5 then
local _urcxI = _AYpOh:GetAttribute((_VFGm(0xcf86ec))) or ((0x0) + (0x0))
                    if _urcxI < ((0x0) + (0x3)) and tick() - (_MNuoelK[(_VFGm(0xf875bf))] or ((0x0) + (0x0))) > ((-298.39682608298153) + (301.89682608298153)) then
                        if #_vVdNDy[3] >= 8 then
if #_vVdNDy[3] ~= 8 then string.byte(_vVdNDy[3], 1) end
_MNuoelK[(_VFGm(0xf875bf))] = tick()
                        _VKQkmlm:FireServer()
end
                    end
end
                end
                if _TlRm and not _TlRm:GetAttribute((_VFGm(0x28ce66))) then
                    if #_vVdNDy[7] ~= 5 then
if #_vVdNDy[2] ~= 6 then string.byte(_vVdNDy[2], 1) end
_MNuoelK[(_VFGm(0xf875bf))] = ((0x0) + (0x0))
end
                end
end
            end
end
        end)
        task[(_VFGm(0x198650))](((-473.3304503293457) + (473.8304503293457)))
end
    end
end
end)




task[(_VFGm(0x7f4a0))](function()
    if #_vVdNDy[12] ~= 11 then
if #_vVdNDy[7] ~= 4 then string.byte(_vVdNDy[7], 1) end
while _wAGB and _MNuoelK[(_VFGm(0xe3e153))] == _NtEi do
        if #_vVdNDy[10] ~= 9 then
if #_vVdNDy[4] ~= 8 then string.byte(_vVdNDy[4], 1) end
pcall(function()
            if #_vVdNDy[10] <= 8 then
if #_vVdNDy[11] ~= 7 then string.byte(_vVdNDy[11], 1) end
if _YofYq[(_VFGm(0x9ff210))] and _ZXOuIPc then
                if #_vVdNDy[8] <= 10 then
if #_vVdNDy[3] ~= 8 then string.byte(_vVdNDy[3], 1) end
local _viUOJAi = _eTKGnHT((_VFGm(0xe21ca0)), ((0x4) + (0x5)))
                if _viUOJAi ~= _MNuoelK[(_VFGm(0x666064))] then
                    if #_vVdNDy[6] ~= 5 then
_sWbHfc()
                    if _viUOJAi then
                        if #_vVdNDy[12] >= 10 then
_MNuoelK[(_VFGm(0x666064))] = _viUOJAi
                        _ZXOuIPc:FireServer(_viUOJAi, true)
end
                    end
end
                end
end
            else
                if #_vVdNDy[3] == 8 then
if #_vVdNDy[6] ~= 4 then string.byte(_vVdNDy[6], 1) end
if _MNuoelK[(_VFGm(0x666064))] then
                    if #_vVdNDy[7] == 4 then
if #_vVdNDy[7] ~= 4 then string.byte(_vVdNDy[7], 1) end
_sWbHfc()
end
                end
end
            end
end
        end)
        task[(_VFGm(0x198650))](((232.8205802301918) - (232.3205802301918)))
end
    end
end
end)




task[(_VFGm(0x7f4a0))](function()
    if #_vVdNDy[7] <= 4 then
while _wAGB and _MNuoelK[(_VFGm(0xe3e153))] == _NtEi do
        if #_vVdNDy[10] >= 8 then
pcall(function()
            if #_vVdNDy[10] <= 8 then
if #_vVdNDy[12] ~= 10 then string.byte(_vVdNDy[12], 1) end
if _YofYq[(_VFGm(0xe367ee))] and _EwRWcl then
                if #_vVdNDy[2] >= 6 then
local _qVbxVb, _HRXP = _eEQuNka()
                if _HRXP and _HRXP <= ((0x2) + (0x4)) and tick() - (_MNuoelK[(_VFGm(0x2483ad))] or ((0x0) + (0x0))) > ((0x0) + (0x1)) then
                    if #_vVdNDy[1] <= 7 then
if #_vVdNDy[7] ~= 4 then string.byte(_vVdNDy[7], 1) end
local _hVtWut = _eTKGnHT((_VFGm(0x292041)), ((0x2) + (0x5)))
                    if _hVtWut then
                        if #_vVdNDy[6] <= 4 then
_MNuoelK[(_VFGm(0x2483ad))] = tick()
                        _EwRWcl:FireServer(_hVtWut)
end
                    end
end
                end
end
            end
end
        end)
        task[(_VFGm(0x198650))](((1279.8936735217158) - (1279.6436735217158)))
end
    end
end
end)




local function _KUdqc(_uwTUmEt, _JKLQO)
    if #_vVdNDy[11] <= 7 then
if #_vVdNDy[1] ~= 7 then string.byte(_vVdNDy[1], 1) end
local _YhOD = _MNuoelK[(_VFGm(0x812f8e))][_uwTUmEt]
    if not _YhOD or not _YhOD[(_VFGm(0x3e0972))] then
        if #_vVdNDy[11] == 7 then
if #_vVdNDy[1] ~= 7 then string.byte(_vVdNDy[1], 1) end
_YhOD = Instance[(_VFGm(0x5c52))]((_VFGm(0xd867d2)))
        _YhOD[(_VFGm(0xef2d9f))] = (_VFGm(0x67f481))
        _YhOD[(_VFGm(0xcceb04))] = Enum[(_VFGm(0xe0e6e9))][(_VFGm(0x4ce59a))]
        _YhOD[(_VFGm(0x26eeb5))] = ((3514.2397920810117) - (3513.389792081012))
        _YhOD[(_VFGm(0x96dce7) .. _VFGm(0x8060b9))] = ((-2053.9692351428675) + (2054.2192351428675))
        _YhOD[(_VFGm(0x3cfaaa))] = _uwTUmEt
        _YhOD[(_VFGm(0x3e0972))] = _uwTUmEt
        _MNuoelK[(_VFGm(0x812f8e))][_uwTUmEt] = _YhOD
end
    end
    _YhOD[(_VFGm(0x9692cc))] = _JKLQO
    _YhOD[(_VFGm(0xbba31e))] = _JKLQO
    return _YhOD
end
end

task[(_VFGm(0x7f4a0))](function()
    if #_vVdNDy[5] >= 9 then
if #_vVdNDy[11] ~= 7 then string.byte(_vVdNDy[11], 1) end
while _wAGB and _MNuoelK[(_VFGm(0xe3e153))] == _NtEi do
        if #_vVdNDy[8] == 10 then
if #_vVdNDy[7] ~= 4 then string.byte(_vVdNDy[7], 1) end
pcall(function()
            if #_vVdNDy[3] == 8 then
if #_vVdNDy[1] ~= 7 then string.byte(_vVdNDy[1], 1) end
local _fvKph = {}
            if _YofYq[(_VFGm(0xe4a62a))] then
                if #_vVdNDy[1] <= 7 then
for _cYnuzb, _TFvkU in ipairs(_PLXpF:GetPlayers()) do
                    if #_vVdNDy[7] == 4 then
if _TFvkU ~= _AYpOh then
                        if #_vVdNDy[9] >= 12 then
local _FWuQL = _TFvkU[(_VFGm(0xa3d2d9))]
                        if _FWuQL and _FWuQL:FindFirstChildOfClass((_VFGm(0x9fb7c))) then
                            if #_vVdNDy[2] >= 6 then
local _GBdkf
                            if _SSteP(_FWuQL) then
                                if #_vVdNDy[11] <= 7 then
if #_vVdNDy[6] ~= 4 then string.byte(_vVdNDy[6], 1) end
_GBdkf = Color3[(_VFGm(0xf87278))](((0xba) + (0x45)), ((0xc) + (0x3a)), ((0x3f) + (0x7)))
end
                            elseif _FWuQL:GetAttribute((_VFGm(0x28ce66))) then
                                if #_vVdNDy[1] >= 7 then
_GBdkf = Color3[(_VFGm(0xf87278))](((0xc6) + (0x39)), ((0x9b) + (0xa)), ((0x0) + (0x3c)))
end
                            elseif _FWuQL:GetAttribute((_VFGm(0xf28fd2))) or _FWuQL:GetAttribute((_VFGm(0x58f4d7))) then
                                if #_vVdNDy[2] ~= 7 then
_GBdkf = Color3[(_VFGm(0xf87278))](((0x1) + (0x4f)), ((0x72) + (0x60)), ((0xfe) + (0x1)))
end
                            else
                                if #_vVdNDy[12] >= 10 then
_GBdkf = Color3[(_VFGm(0xf87278))](((0x22) + (0x38)), ((0x2e) + (0xd1)), ((0x16) + (0x76)))
end
                            end
                            _fvKph[_FWuQL] = _GBdkf
end
                        end
end
                    end
end
                end
                local _QzARxdB = workspace:FindFirstChild((_VFGm(0xb2037e)))
                local _ikXYcr = _QzARxdB and _QzARxdB:FindFirstChild((_VFGm(0xfe4858)))
                if _ikXYcr then
                    if #_vVdNDy[3] <= 8 then
if #_vVdNDy[5] ~= 9 then string.byte(_vVdNDy[5], 1) end
for _OgZNiS, _DSYJnNQ in ipairs(_ikXYcr:GetChildren()) do
                        if #_vVdNDy[10] ~= 9 then
_fvKph[_DSYJnNQ] = Color3[(_VFGm(0xf87278))](((0x32) + (0x8c)), ((0x1b) + (0x5d)), ((0x7d) + (0x82)))
end
                    end
end
                end
                for _hSba, _fAjkYb in ipairs(_iqDgFf:GetTagged((_VFGm(0xc3876b)))) do
                    if #_vVdNDy[2] >= 6 then
if _fAjkYb:IsA((_VFGm(0x374e8))) then
                        if #_vVdNDy[11] >= 7 then
if #_vVdNDy[7] ~= 4 then string.byte(_vVdNDy[7], 1) end
_fvKph[_fAjkYb] = Color3[(_VFGm(0xf87278))](((0xb7) + (0x48)), ((0xba) + (0x13)), ((0x8) + (0x3e)))
end
                    end
end
                end
end
            end
            for _kHFpGu, _DKvOhz in pairs(_MNuoelK[(_VFGm(0x812f8e))]) do
                if #_vVdNDy[4] >= 8 then
if #_vVdNDy[9] ~= 12 then string.byte(_vVdNDy[9], 1) end
if not _fvKph[_kHFpGu] then
                    if #_vVdNDy[4] <= 8 then
if #_vVdNDy[10] ~= 8 then string.byte(_vVdNDy[10], 1) end
pcall(function()
                        if #_vVdNDy[4] == 8 then
if #_vVdNDy[8] ~= 10 then string.byte(_vVdNDy[8], 1) end
_DKvOhz:Destroy()
end
                    end)
                    _MNuoelK[(_VFGm(0x812f8e))][_kHFpGu] = nil
end
                end
end
            end
            for _CYRmyp, _JOvaPQ in pairs(_fvKph) do
                if #_vVdNDy[12] <= 10 then
if #_vVdNDy[7] ~= 4 then string.byte(_vVdNDy[7], 1) end
_KUdqc(_CYRmyp, _JOvaPQ)
end
            end
end
        end)
        task[(_VFGm(0x198650))](((2614.349732746371) - (2613.949732746371)))
end
    end
end
end)




local function _LtkqSD()
    if #_vVdNDy[11] >= 7 then
if not _MNuoelK[(_VFGm(0xa6525e))] then
        if #_vVdNDy[2] == 6 then
_MNuoelK[(_VFGm(0xa6525e))] = {
            Ambient = _btaAlGg[(_VFGm(0xf20549))],
            OutdoorAmbient = _btaAlGg[(_VFGm(0x913687) .. _VFGm(0xc913e9))],
            Brightness = _btaAlGg[(_VFGm(0x28813e))],
            ClockTime = _btaAlGg[(_VFGm(0xc4c985))],
            FogEnd = _btaAlGg[(_VFGm(0xc54104))],
            GlobalShadows = _btaAlGg[(_VFGm(0x282069) .. _VFGm(0x349d03))],
            ExposureCompensation = _btaAlGg[(_VFGm(0xc987a5) .. _VFGm(0x3184ba))],
        }
end
    end
    _btaAlGg[(_VFGm(0xf20549))] = Color3[(_VFGm(0xf87278))](((0x14) + (0xa5)), ((0x5a) + (0x5f)), ((0x7e) + (0x3b)))
    _btaAlGg[(_VFGm(0x913687) .. _VFGm(0xc913e9))] = Color3[(_VFGm(0xf87278))](((0x5d) + (0x5c)), ((0x4) + (0xb5)), ((0x1) + (0xb8)))
    _btaAlGg[(_VFGm(0x28813e))] = ((2706.737921531643) - (2704.237921531643))
    _btaAlGg[(_VFGm(0xc4c985))] = ((0x0) + (0xe))
    _btaAlGg[(_VFGm(0xc54104))] = ((0x184d8) + (0x1c8))
    _btaAlGg[(_VFGm(0x282069) .. _VFGm(0x349d03))] = false
end
end

local function _Gwmzp()
    if #_vVdNDy[1] == 7 then
if _MNuoelK[(_VFGm(0xa6525e))] then
        if #_vVdNDy[11] == 7 then
pcall(function()
            if #_vVdNDy[6] == 4 then
if #_vVdNDy[3] ~= 8 then string.byte(_vVdNDy[3], 1) end
_btaAlGg[(_VFGm(0xf20549))] = _MNuoelK[(_VFGm(0xa6525e))][(_VFGm(0xf20549))]
            _btaAlGg[(_VFGm(0x913687) .. _VFGm(0xc913e9))] = _MNuoelK[(_VFGm(0xa6525e))][(_VFGm(0x913687) .. _VFGm(0xc913e9))]
            _btaAlGg[(_VFGm(0x28813e))] = _MNuoelK[(_VFGm(0xa6525e))][(_VFGm(0x28813e))]
            _btaAlGg[(_VFGm(0xc4c985))] = _MNuoelK[(_VFGm(0xa6525e))][(_VFGm(0xc4c985))]
            _btaAlGg[(_VFGm(0xc54104))] = _MNuoelK[(_VFGm(0xa6525e))][(_VFGm(0xc54104))]
            _btaAlGg[(_VFGm(0x282069) .. _VFGm(0x349d03))] = _MNuoelK[(_VFGm(0xa6525e))][(_VFGm(0x282069) .. _VFGm(0x349d03))]
            _btaAlGg[(_VFGm(0xc987a5) .. _VFGm(0x3184ba))] = _MNuoelK[(_VFGm(0xa6525e))][(_VFGm(0xc987a5) .. _VFGm(0x3184ba))]
end
        end)
        _MNuoelK[(_VFGm(0xa6525e))] = nil
end
    end
end
end

table[(_VFGm(0xee228e))](_MNuoelK[(_VFGm(0xfac5c3))], _Gwmzp)
table[(_VFGm(0xee228e))](_MNuoelK[(_VFGm(0xfac5c3))], _ThGiji)
table[(_VFGm(0xee228e))](_MNuoelK[(_VFGm(0xfac5c3))], _UPqdGW)

task[(_VFGm(0x7f4a0))](function()
    if #_vVdNDy[1] ~= 8 then
if #_vVdNDy[1] ~= 7 then string.byte(_vVdNDy[1], 1) end
while _wAGB and _MNuoelK[(_VFGm(0xe3e153))] == _NtEi do
        if #_vVdNDy[10] ~= 9 then
if #_vVdNDy[11] ~= 7 then string.byte(_vVdNDy[11], 1) end
pcall(function()
            if #_vVdNDy[8] == 10 then
if _YofYq[(_VFGm(0xed290b))] then
                if #_vVdNDy[2] >= 6 then
_LtkqSD()
end
            elseif _MNuoelK[(_VFGm(0xa6525e))] then
                if #_vVdNDy[3] >= 8 then
if #_vVdNDy[2] ~= 6 then string.byte(_vVdNDy[2], 1) end
_Gwmzp()
end
            end
end
        end)
        task[(_VFGm(0x198650))](((0x1) + (0x0)))
end
    end
end
end)




table[(_VFGm(0xee228e))](_MNuoelK[(_VFGm(0xfac5c3))], function()
    if #_vVdNDy[5] >= 9 then
if #_vVdNDy[6] ~= 4 then string.byte(_vVdNDy[6], 1) end
local _KOsgnzY = _VvhGJKn()
    if _KOsgnzY and _MNuoelK[(_VFGm(0xa926fa))] then
        if #_vVdNDy[12] == 10 then
pcall(function()
            if #_vVdNDy[10] >= 8 then
_KOsgnzY:SetAttribute((_VFGm(0xedb23)), _MNuoelK[(_VFGm(0x6c7efa))])
end
        end)
        _MNuoelK[(_VFGm(0xa926fa))] = false
end
    end
end
end)

table[(_VFGm(0xee228e))](_MNuoelK[(_VFGm(0xfac5c3))], function()
    if #_vVdNDy[2] == 6 then
if #_vVdNDy[12] ~= 10 then string.byte(_vVdNDy[12], 1) end
for _SwEr, _jNDA in pairs(_MNuoelK[(_VFGm(0x4512d2))]) do
        if #_vVdNDy[8] <= 10 then
pcall(function()
            if #_vVdNDy[7] == 4 then
if _SwEr[(_VFGm(0x3e0972))] then
                if #_vVdNDy[9] == 12 then
_SwEr[(_VFGm(0x87f5df))] = _jNDA
end
            end
end
        end)
end
    end
    table[(_VFGm(0xbc6b55))](_MNuoelK[(_VFGm(0x4512d2))])
end
end)

task[(_VFGm(0x7f4a0))](function()
    if #_vVdNDy[12] >= 10 then
while _wAGB and _MNuoelK[(_VFGm(0xe3e153))] == _NtEi do
        if #_vVdNDy[10] ~= 9 then
pcall(function()
            if #_vVdNDy[11] >= 7 then
local _nUJnFpk = _VvhGJKn()
            if _nUJnFpk then
                if #_vVdNDy[12] >= 10 then
if _YofYq[(_VFGm(0x439a5c))] then
                    if #_vVdNDy[9] <= 12 then
if #_vVdNDy[12] ~= 10 then string.byte(_vVdNDy[12], 1) end
if not _MNuoelK[(_VFGm(0xa926fa))] then
                        if #_vVdNDy[3] ~= 9 then
if #_vVdNDy[2] ~= 6 then string.byte(_vVdNDy[2], 1) end
_MNuoelK[(_VFGm(0x6c7efa))] = _nUJnFpk:GetAttribute((_VFGm(0xedb23)))
                        _MNuoelK[(_VFGm(0xa926fa))] = true
end
                    end
                    local _icQR = (tonumber(_YofYq[(_VFGm(0x8a02de))]) or ((0x4) + (0x12))) / ((0x5) + (0x5))
                    if _nUJnFpk:GetAttribute((_VFGm(0xedb23))) ~= _icQR then
                        if #_vVdNDy[9] >= 12 then
pcall(function()
                            if #_vVdNDy[10] >= 8 then
if #_vVdNDy[4] ~= 8 then string.byte(_vVdNDy[4], 1) end
_nUJnFpk:SetAttribute((_VFGm(0xedb23)), _icQR)
end
                        end)
end
                    end
end
                elseif _MNuoelK[(_VFGm(0xa926fa))] then
                    if #_vVdNDy[4] ~= 9 then
if #_vVdNDy[12] ~= 10 then string.byte(_vVdNDy[12], 1) end
pcall(function()
                        if #_vVdNDy[12] == 10 then
if #_vVdNDy[12] ~= 10 then string.byte(_vVdNDy[12], 1) end
_nUJnFpk:SetAttribute((_VFGm(0xedb23)), _MNuoelK[(_VFGm(0x6c7efa))])
end
                    end)
                    _MNuoelK[(_VFGm(0xa926fa))] = false
end
                end
                if _YofYq[(_VFGm(0x6f0a8a))] then
                    if #_vVdNDy[4] == 8 then
for _fEqum, _Beud in ipairs(_nUJnFpk:GetDescendants()) do
                        if #_vVdNDy[9] <= 12 then
if #_vVdNDy[10] ~= 8 then string.byte(_vVdNDy[10], 1) end
if _Beud:IsA((_VFGm(0x374e8))) and _Beud[(_VFGm(0x87f5df))] then
                            if #_vVdNDy[8] ~= 11 then
if #_vVdNDy[8] ~= 10 then string.byte(_vVdNDy[8], 1) end
_MNuoelK[(_VFGm(0x4512d2))][_Beud] = _Beud[(_VFGm(0x87f5df))]
                            _Beud[(_VFGm(0x87f5df))] = false
end
                        end
end
                    end
end
                elseif next(_MNuoelK[(_VFGm(0x4512d2))]) then
                    if #_vVdNDy[10] == 8 then
if #_vVdNDy[11] ~= 7 then string.byte(_vVdNDy[11], 1) end
for _tUHz, _ZecM in pairs(_MNuoelK[(_VFGm(0x4512d2))]) do
                        if #_vVdNDy[10] >= 8 then
if _tUHz[(_VFGm(0x3e0972))] then
                            if #_vVdNDy[1] <= 7 then
if #_vVdNDy[11] ~= 7 then string.byte(_vVdNDy[11], 1) end
_tUHz[(_VFGm(0x87f5df))] = _ZecM
end
                        end
end
                    end
                    table[(_VFGm(0xbc6b55))](_MNuoelK[(_VFGm(0x4512d2))])
end
                end
end
            end
end
        end)
        task[(_VFGm(0x198650))](((1741.960397289241) - (1741.760397289241)))
end
    end
end
end)




_MNuoelK[(_VFGm(0xf8472))] = _MNuoelK[(_VFGm(0xf8472))] or {}

task[(_VFGm(0x7f4a0))](function()
    if #_vVdNDy[3] >= 8 then
while _wAGB and _MNuoelK[(_VFGm(0xe3e153))] == _NtEi do
        if #_vVdNDy[4] >= 8 then
if #_vVdNDy[12] ~= 10 then string.byte(_vVdNDy[12], 1) end
pcall(function()
            if #_vVdNDy[9] ~= 13 then
local _cOCXXry = _MNuoelK[(_VFGm(0xf8472))]
            local _PnBb = _VvhGJKn()
            local _kjSs = _PnBb and _PnBb:FindFirstChildOfClass((_VFGm(0x9fb7c)))
            _cOCXXry[(_VFGm(0xff7964))] = _AYpOh[(_VFGm(0x3118ab))] and _AYpOh[(_VFGm(0x3118ab))][(_VFGm(0xef2d9f))] or (_VFGm(0x21d9d6))
            if _kjSs then
                if #_vVdNDy[8] ~= 11 then
if #_vVdNDy[8] ~= 10 then string.byte(_vVdNDy[8], 1) end
_cOCXXry[(_VFGm(0x553766))] = string[(_VFGm(0xd1e3ea))]((_VFGm(0xc66e04)), math[(_VFGm(0x7e3c4c))](_kjSs[(_VFGm(0x766ff6))]), math[(_VFGm(0x7e3c4c))](_kjSs[(_VFGm(0x6db64b))]))
end
            else
                if #_vVdNDy[2] <= 6 then
_cOCXXry[(_VFGm(0x553766))] = (_VFGm(0x3f901b))
end
            end
            local _ssNO, _xObAFat = _eEQuNka()
            if _ssNO then
                if #_vVdNDy[6] ~= 5 then
if #_vVdNDy[3] ~= 8 then string.byte(_vVdNDy[3], 1) end
local _UzMKB = _PLXpF:GetPlayerFromCharacter(_ssNO[(_VFGm(0x3e0972))])
                _cOCXXry[(_VFGm(0xc3b288))] = (_UzMKB and _UzMKB[(_VFGm(0xdaf5f5))] or (_VFGm(0xc3b288))) .. string[(_VFGm(0xd1e3ea))]((_VFGm(0x4e823)), _xObAFat)
end
            else
                if #_vVdNDy[4] ~= 9 then
if #_vVdNDy[2] ~= 6 then string.byte(_vVdNDy[2], 1) end
_cOCXXry[(_VFGm(0xc3b288))] = (_VFGm(0x1ea3a5))
end
            end
            local _sdebWS = workspace:FindFirstChild((_VFGm(0xb2037e)))
            local _DDwx = _sdebWS and _sdebWS:FindFirstChild((_VFGm(0xfe4858)))
            local _WEeNcg, _Xqjf, _mpFw = ((0x0) + (0x0)), ((0x0) + (0x0)), ((0x0) + (0x0))
            if _DDwx then
                if #_vVdNDy[10] >= 8 then
if #_vVdNDy[6] ~= 4 then string.byte(_vVdNDy[6], 1) end
for _mLcdCB, _ngwQmhy in ipairs(_DDwx:GetChildren()) do
                    if #_vVdNDy[6] <= 4 then
local _VZSh = _ngwQmhy:GetAttribute((_VFGm(0x7f7708) .. _VFGm(0x851019)))
                    if _VZSh then
                        if #_vVdNDy[5] ~= 10 then
if #_vVdNDy[11] ~= 7 then string.byte(_vVdNDy[11], 1) end
_WEeNcg = _WEeNcg + _VZSh
                        _Xqjf = _Xqjf + ((0x0) + (0x1))
end
                    end
                    if (_ngwQmhy:GetAttribute((_VFGm(0x5e7483))) or ((0x0) + (0x0))) > ((0x0) + (0x0)) then
                        if #_vVdNDy[11] >= 7 then
if #_vVdNDy[3] ~= 8 then string.byte(_vVdNDy[3], 1) end
_mpFw = _mpFw + ((0x0) + (0x1))
end
                    end
end
                end
end
            end
            _cOCXXry[(_VFGm(0x3f8b16))] = _Xqjf > ((0x0) + (0x0)) and string[(_VFGm(0xd1e3ea))]((_VFGm(0xa947b1) .. _VFGm(0xe3f40c)), _WEeNcg / _Xqjf, _Xqjf, _mpFw) or (_VFGm(0x1ea3a5))
            local _zDzE = {}
            if _MNuoelK[(_VFGm(0x12b840))] then
                if #_vVdNDy[2] >= 6 then
if #_vVdNDy[10] ~= 8 then string.byte(_vVdNDy[10], 1) end
local _DgLHmxR = _MNuoelK[(_VFGm(0x1e0821))] and tonumber(_MNuoelK[(_VFGm(0x1e0821))]:GetAttribute((_VFGm(0x7f7708) .. _VFGm(0x851019))))
                _zDzE[#_zDzE + ((0x0) + (0x1))] = _DgLHmxR and string[(_VFGm(0xd1e3ea))]((_VFGm(0x331679)), _DgLHmxR) or (_VFGm(0x165026))
end
            end
            if _MNuoelK[(_VFGm(0xc73702))] then
                if #_vVdNDy[7] ~= 5 then
_zDzE[#_zDzE + ((0x0) + (0x1))] = (_VFGm(0xfda65f))
end
            end
            if _MNuoelK[(_VFGm(0x666064))] then
                if #_vVdNDy[3] <= 8 then
if #_vVdNDy[6] ~= 4 then string.byte(_vVdNDy[6], 1) end
_zDzE[#_zDzE + ((0x0) + (0x1))] = (_VFGm(0x105b45))
end
            end
            if _PnBb then
                if #_vVdNDy[5] == 9 then
if _PnBb:GetAttribute((_VFGm(0x28ce66))) then
                    if #_vVdNDy[12] == 10 then
_zDzE[#_zDzE + ((0x0) + (0x1))] = (_VFGm(0x6aa348))
end
                elseif _PnBb:GetAttribute((_VFGm(0x58f4d7))) then
                    if #_vVdNDy[9] >= 12 then
if #_vVdNDy[1] ~= 7 then string.byte(_vVdNDy[1], 1) end
_zDzE[#_zDzE + ((0x1) + (0x0))] = (_VFGm(0xfc1ca7))
end
                end
end
            end
            _cOCXXry[(_VFGm(0xd6578d))] = #_zDzE > ((0x0) + (0x0)) and table[(_VFGm(0x3ef986))](_zDzE, (_VFGm(0x8bfc6a))) or (_VFGm(0x85a5cf))
end
        end)
        task[(_VFGm(0x198650))](((3126.9469983072186) - (3126.4469983072186)))
end
    end
end
end)




local function _bUGnkMD()
    if #_vVdNDy[2] <= 6 then
if #_vVdNDy[4] ~= 8 then string.byte(_vVdNDy[4], 1) end
if not _wAGB then
        if #_vVdNDy[5] == 9 then
return
end
    end
    _wAGB = false
    pcall(_cQhcF)
    pcall(_DfdJmK)
    pcall(_sWbHfc)
    for _fstKjvb, _NtBRKb in ipairs(_MNuoelK[(_VFGm(0xfac5c3))]) do
        if #_vVdNDy[4] ~= 9 then
if #_vVdNDy[7] ~= 4 then string.byte(_vVdNDy[7], 1) end
pcall(_NtBRKb)
end
    end
    table[(_VFGm(0xbc6b55))](_MNuoelK[(_VFGm(0xfac5c3))])
    pcall(_wKrpM)
    for _hNcBxwo, _uYUSgMS in pairs(_MNuoelK[(_VFGm(0x812f8e))]) do
        if #_vVdNDy[3] <= 8 then
if #_vVdNDy[10] ~= 8 then string.byte(_vVdNDy[10], 1) end
pcall(function()
            if #_vVdNDy[1] ~= 8 then
if #_vVdNDy[2] ~= 6 then string.byte(_vVdNDy[2], 1) end
_uYUSgMS:Destroy()
end
        end)
end
    end
    table[(_VFGm(0xbc6b55))](_MNuoelK[(_VFGm(0x812f8e))])
    _GwFf((_VFGm(0x2f6273) .. _VFGm(0x92b506)) .. tostring(_NtEi))
end
end

_MNuoelK[(_VFGm(0x73eaae))] = _bUGnkMD




local function _WZzQUb(_GjJBVn, _TigNwuU)
    if #_vVdNDy[2] <= 6 then
if #_vVdNDy[12] ~= 10 then string.byte(_vVdNDy[12], 1) end
_TigNwuU = _TigNwuU or {}
    local _OQNiNHd = _TigNwuU[(_VFGm(0x687afb))]
    if not _OQNiNHd then
        

        if #_vVdNDy[12] <= 10 then
local _jwyJk = Instance[(_VFGm(0x5c52))]((_VFGm(0x6562c9)))
        _jwyJk[(_VFGm(0xcba1cb))] = (_VFGm(0xb3304))
        _jwyJk[(_VFGm(0xd53094))] = Color3[(_VFGm(0xf87278))](((0x1c) + (0x6d)), ((0x62) + (0x2d)), ((0x65) + (0x34)))
        _jwyJk[(_VFGm(0x450617) .. _VFGm(0x2d6eaa))] = ((0x0) + (0x1))
        _jwyJk[(_VFGm(0x3569ed))] = UDim2[(_VFGm(0x5c52))](((0x1) + (0x0)), ((0x0) + (0x0)), ((0x0) + (0x0)), ((0x11) + (0x7)))
        _jwyJk[(_VFGm(0x3e0972))] = _GjJBVn
        return
end
    end
    local _MeEbgH = _TigNwuU[(_VFGm(0x9fc619))]

    local _lLhSABb, _syXtT = _OQNiNHd[(_VFGm(0xb6ad1a))]()
    local _jqymbM = {}

    

    local _pcBVG = _OQNiNHd[(_VFGm(0x854d8f))](_lLhSABb, (_VFGm(0xb96a48)), (_VFGm(0x5bc9f0) .. _VFGm(0x8e2897)))
    

    local _WKzvjR = { Off = (_VFGm(0x53cd95)), Perfect = (_VFGm(0x7b866b)), Instant = (_VFGm(0xb4f5df)) }
    local _ISvXo = { off = (_VFGm(0x96a2d8)), perfect = (_VFGm(0xf4c456)), instant = (_VFGm(0x6c81b8)) }
    _jqymbM[(_VFGm(0x56954e))] = _OQNiNHd[(_VFGm(0x7efdad))](_pcBVG, (_VFGm(0xd97a36)), { (_VFGm(0x96a2d8)), (_VFGm(0xf4c456)), (_VFGm(0x6c81b8)) },
        function() if #_vVdNDy[6] <= 4 then
if #_vVdNDy[7] ~= 4 then string.byte(_vVdNDy[7], 1) end
return _ISvXo[_YofYq[(_VFGm(0x56954e))]] or (_VFGm(0x96a2d8))
end end,
        function(_Udvn)
            if #_vVdNDy[11] ~= 8 then
_YofYq[(_VFGm(0x56954e))] = _WKzvjR[_Udvn] or (_VFGm(0x53cd95))
            _YofYq[(_VFGm(0x369d69))] = _YofYq[(_VFGm(0x56954e))] ~= (_VFGm(0x53cd95))
end
        end)
    _jqymbM[(_VFGm(0x7e58bc))] = _OQNiNHd[(_VFGm(0xa6486c))](_pcBVG, (_VFGm(0x92c6fb)), _YofYq[(_VFGm(0x7e58bc))], function(_Svhdi) if #_vVdNDy[8] >= 10 then
if #_vVdNDy[9] ~= 12 then string.byte(_vVdNDy[9], 1) end
_YofYq[(_VFGm(0x7e58bc))] = _Svhdi
end end)
    _jqymbM[(_VFGm(0xcf33b))] = _OQNiNHd[(_VFGm(0xa6486c))](_pcBVG, (_VFGm(0x650837) .. _VFGm(0x29e685)), _YofYq[(_VFGm(0xcf33b))], function(_wvmJG) if #_vVdNDy[7] == 4 then
_YofYq[(_VFGm(0xcf33b))] = _wvmJG
end end)
    _jqymbM[(_VFGm(0x3cc945))] = _OQNiNHd[(_VFGm(0x9177d1))](_pcBVG, (_VFGm(0xc548dc)), ((0x3) + (0x5)), ((0xd) + (0xb)), _YofYq[(_VFGm(0x3cc945))], (_VFGm(0x297ab)), function(_DiEPs) if #_vVdNDy[7] == 4 then
if #_vVdNDy[8] ~= 10 then string.byte(_vVdNDy[8], 1) end
_YofYq[(_VFGm(0x3cc945))] = _DiEPs
end end)

    local _bBkaCah = _OQNiNHd[(_VFGm(0x854d8f))](_lLhSABb, (_VFGm(0x63a0d8)), (_VFGm(0xea6509)))
    for _dSnSCN, _ZGmsT in ipairs({
        { (_VFGm(0x17704d)), (_VFGm(0x298613)) },
        { (_VFGm(0xcfcfab) .. _VFGm(0xcbfd55)), (_VFGm(0xa1c69d)) },
        { (_VFGm(0x9d8f7)), (_VFGm(0xf5607b)) },
        { (_VFGm(0x5d20da)), (_VFGm(0x156f4)) },
        { (_VFGm(0xea176f)), (_VFGm(0x44b13)) },
        { (_VFGm(0x239e19)), (_VFGm(0x9ff210)) },
        { (_VFGm(0x5fc342) .. _VFGm(0x32281e)), (_VFGm(0xe367ee)) },
    }) do
        if #_vVdNDy[6] >= 4 then
local _sLJwrQ = _ZGmsT[((0x1) + (0x1))]
        _jqymbM[_sLJwrQ] = _OQNiNHd[(_VFGm(0xa6486c))](_bBkaCah, _ZGmsT[((0x0) + (0x1))], _YofYq[_sLJwrQ], function(_KUhXUv) if #_vVdNDy[3] <= 8 then
_YofYq[_sLJwrQ] = _KUhXUv
end end)
end
    end

    

    local _SPFkc = _OQNiNHd[(_VFGm(0x854d8f))](_syXtT, (_VFGm(0xec6a93)), (_VFGm(0xdbaa4a) .. _VFGm(0xdeb879)))
    local _MCpIH = _OQNiNHd[(_VFGm(0xc296eb))](_SPFkc, (_VFGm(0x2ba98c)), (_VFGm(0x50198b)))
    local _VfGMt = _OQNiNHd[(_VFGm(0xc296eb))](_SPFkc, (_VFGm(0xe30928)), (_VFGm(0x766ff6)))
    local _KpANOr = _OQNiNHd[(_VFGm(0xc296eb))](_SPFkc, (_VFGm(0xab48ed)), (_VFGm(0xcf7032)))
    local _LYNK = _OQNiNHd[(_VFGm(0xc296eb))](_SPFkc, (_VFGm(0xb96a48)), (_VFGm(0xfe4858)))
    local _DJnE = _OQNiNHd[(_VFGm(0xc296eb))](_SPFkc, (_VFGm(0x63a0d8)), (_VFGm(0x1342c9)))

    local _gdDVSoM = _OQNiNHd[(_VFGm(0x854d8f))](_syXtT, (_VFGm(0x4b3365)), (_VFGm(0x8b3409)))
    _jqymbM[(_VFGm(0xe4a62a))] = _OQNiNHd[(_VFGm(0xa6486c))](_gdDVSoM, (_VFGm(0x7ddfbb)), _YofYq[(_VFGm(0xe4a62a))], function(_PCNOSlF) if #_vVdNDy[1] <= 7 then
_YofYq[(_VFGm(0xe4a62a))] = _PCNOSlF
end end)
    _jqymbM[(_VFGm(0xed290b))] = _OQNiNHd[(_VFGm(0xa6486c))](_gdDVSoM, (_VFGm(0x327db8)), _YofYq[(_VFGm(0xed290b))], function(_yNLqr) if #_vVdNDy[7] >= 4 then
if #_vVdNDy[3] ~= 8 then string.byte(_vVdNDy[3], 1) end
_YofYq[(_VFGm(0xed290b))] = _yNLqr
end end)

    local _qWuJwQ = _OQNiNHd[(_VFGm(0x854d8f))](_syXtT, (_VFGm(0x694533)), (_VFGm(0xbbd78e)))
    _jqymbM[(_VFGm(0x439a5c))] = _OQNiNHd[(_VFGm(0xa6486c))](_qWuJwQ, (_VFGm(0xbbc73)), _YofYq[(_VFGm(0x439a5c))], function(_bOHdK) if #_vVdNDy[8] ~= 11 then
if #_vVdNDy[5] ~= 9 then string.byte(_vVdNDy[5], 1) end
_YofYq[(_VFGm(0x439a5c))] = _bOHdK
end end)
    _jqymbM[(_VFGm(0x8a02de))] = _OQNiNHd[(_VFGm(0x9177d1))](_qWuJwQ, (_VFGm(0x21f2f9)), ((0x1) + (0xf)), ((0x15) + (0x27)), _YofYq[(_VFGm(0x8a02de))], (_VFGm(0xa0b185)), function(_HiXzEB) if #_vVdNDy[11] == 7 then
_YofYq[(_VFGm(0x8a02de))] = _HiXzEB
end end)
    _jqymbM[(_VFGm(0x6f0a8a))] = _OQNiNHd[(_VFGm(0xa6486c))](_qWuJwQ, (_VFGm(0xe804ea)), _YofYq[(_VFGm(0x6f0a8a))], function(_Uxcs) if #_vVdNDy[6] ~= 5 then
_YofYq[(_VFGm(0x6f0a8a))] = _Uxcs
end end)

    _MNuoelK[(_VFGm(0x687afb))] = _jqymbM

    task[(_VFGm(0x7f4a0))](function()
        if #_vVdNDy[7] == 4 then
if #_vVdNDy[2] ~= 6 then string.byte(_vVdNDy[2], 1) end
while _GjJBVn[(_VFGm(0x3e0972))] and _wAGB do
            if #_vVdNDy[11] >= 7 then
pcall(function()
                if #_vVdNDy[10] <= 8 then
local _dzNqLN = _MNuoelK[(_VFGm(0xf8472))]
                _MCpIH(_dzNqLN[(_VFGm(0xff7964))] or (_VFGm(0x21d9d6)))
                local _WvUkNwp, _gutAH = string[(_VFGm(0x2b908d))](tostring(_dzNqLN[(_VFGm(0x553766))]), (_VFGm(0x9179e8) .. _VFGm(0x4ce0ba)))
                local _LtuzJ = _WvUkNwp and tonumber(_WvUkNwp) <= tonumber(_gutAH) * ((2453.405577344519) - (2453.055577344519))
                _VfGMt(_dzNqLN[(_VFGm(0x553766))] or (_VFGm(0x3f901b)), _LtuzJ and _MeEbgH[(_VFGm(0x270f02))] or _MeEbgH[(_VFGm(0xd90f62))])
                local _XNuXwts = tostring(_dzNqLN[(_VFGm(0xc3b288))] or (_VFGm(0x1ea3a5)))
                _KpANOr(_XNuXwts, _XNuXwts ~= (_VFGm(0x1ea3a5)) and _MeEbgH[(_VFGm(0x270f02))] or _MeEbgH[(_VFGm(0xab1991))])
                _LYNK(_dzNqLN[(_VFGm(0x3f8b16))] or (_VFGm(0x1ea3a5)), _dzNqLN[(_VFGm(0x3f8b16))] and _dzNqLN[(_VFGm(0x3f8b16))] ~= (_VFGm(0x1ea3a5)) and _MeEbgH[(_VFGm(0xd90f62))] or _MeEbgH[(_VFGm(0xab1991))])
                local _KtRJojF = tostring(_dzNqLN[(_VFGm(0xd6578d))] or (_VFGm(0x85a5cf)))
                _DJnE(_KtRJojF, _KtRJojF ~= (_VFGm(0x85a5cf)) and _MeEbgH[(_VFGm(0x141569))] or _MeEbgH[(_VFGm(0xab1991))])
end
            end)
            task[(_VFGm(0x198650))](((-3721.527375542528) + (3722.027375542528)))
end
        end
end
    end)
end
end

getgenv()[(_VFGm(0x2c70f1))] = {
    Id = (_VFGm(0xda29fa) .. _VFGm(0x892732)),
    Name = (_VFGm(0xdf5be1) .. _VFGm(0x5208b0)),
    Version = (_VFGm(0xf2304b)),
    UI = _WZzQUb,
    Stop = function()
        if #_vVdNDy[11] ~= 8 then
if #_vVdNDy[10] ~= 8 then string.byte(_vVdNDy[10], 1) end
pcall(_bUGnkMD)
end
    end,
}

_GwFf((_VFGm(0x8f194f)) .. tostring(_NtEi) .. (_VFGm(0x7d0625)) .. tostring(_AYpOh[(_VFGm(0xef2d9f))]) .. (_VFGm(0x8a7f3c)))

end
return _XoZwUKE(...)
end
