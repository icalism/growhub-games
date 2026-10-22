


























do

local _xdFNtab = 4294967296
local _ZjYD = 65536
local _kyHWaNv = (bit32 and bit32.bxor) or function(a, b)
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
local _yVRAfi = (bit32 and bit32.rshift) or function(x, n)
  return math.floor((x % 4294967296) / (2 ^ n))
end
local _HSSj = function(x, n)
  n = n % 32
  x = x % 4294967296
  if n == 0 then return x end
  local p = 2 ^ n
  return ((x * p) % 4294967296) + math.floor(x / (2 ^ (32 - n)))
end
local _kbiG = function(a, b)
  a = a % 4294967296
  b = b % 4294967296
  local al = a % 65536
  local ah = (a - al) / 65536
  local bl = b % 65536
  local bh = (b - bl) / 65536
  return ((al * bl) + ((ah * bl + al * bh) % 65536) * 65536) % 4294967296
end
local _iirTLWS = function(x)
  x = x % 4294967296
  x = _kyHWaNv(x, _yVRAfi(x, 16)) % 4294967296
  x = _kbiG(x, 2246822507)
  x = _kyHWaNv(x, _yVRAfi(x, 13)) % 4294967296
  x = _kbiG(x, 3266489909)
  x = _kyHWaNv(x, _yVRAfi(x, 16)) % 4294967296
  return x
end
local _zFav = function(k0, k1, counter)
  local c = counter % 4294967296
  local s = _kyHWaNv(c, _kbiG(k0, 2654435761)) % 4294967296
  s = (s + _kbiG(k1, 2135587861)) % 4294967296
  s = _kyHWaNv(s, _HSSj(k0, (c % 16) + 1)) % 4294967296
  s = _iirTLWS(s)
  s = _kyHWaNv(s, _HSSj(k1, 32 - (((_yVRAfi(c, 5)) % 16) + 1))) % 4294967296
  s = _kbiG(s, (k0 % 2 == 0) and (k0 + 1) or k0)
  return _iirTLWS(s)
end
local _vaahrTa = function(s)
  local o = {}
  for i = 1, #s, 2 do
    o[#o + 1] = string.char(tonumber(s:sub(i, i + 1), 16))
  end
  return table.concat(o)
end
local _kGdfFm = {}
_kGdfFm[0xda7e1]={"352c9ccba21ccd",28244053,3420347094}
_kGdfFm[0x254f4d]={"ffe6d09add2639",961946636,2398729508}
_kGdfFm[0xd7e044]={"9949b8adb1b19b7a08f1db",746577008,2111090980}
_kGdfFm[0xc7df86]={"1b37512724",1010654512,2878001618}
_kGdfFm[0x476ad5]={"fc089c",3701645781,290439328}
_kGdfFm[0x7ba86d]={"61343ce6cf9660",3371606940,534133127}
_kGdfFm[0xb4e017]={"892e522ab9606ef2f5851b62424d",2506643632,2162095625}
_kGdfFm[0xa8021a]={"3f13451a79f1bae9",2924543831,3498444269}
_kGdfFm[0x559e60]={"b5",2807479716,1615270227}
_kGdfFm[0x2f39a8]={"aff179ad",3409823777,1096475574}
_kGdfFm[0x4a7410]={"39c95b556680927ef580f6",2816438622,3039728426}
_kGdfFm[0x49c951]={"77a55a7d",3588425164,1947280543}
_kGdfFm[0x225007]={"952345322eb486cf",1374395713,2112476048}
_kGdfFm[0x4449ea]={"b923058aa7914fd7c155e63b44df",3438285001,4166568691}
_kGdfFm[0x6ffa52]={"0bf4ec9e24d13a",3256481373,1679632897}
_kGdfFm[0xe48041]={"45439d3db8ff",2796208025,4262748458}
_kGdfFm[0x27b7ed]={"31868c302b",3479005675,3593785145}
_kGdfFm[0x8be00d]={"b2b6a7107005e581c717",2246867247,3699687502}
_kGdfFm[0xd5920]={"ada4402c",865861784,2789781388}
_kGdfFm[0xf0c2c6]={"108c9c9d8039fc",3791220390,3424465208}
_kGdfFm[0x30856]={"17400f37766e6f0366c0b1b120752a",4055817136,2402449408}
_kGdfFm[0x9b297f]={"20e0bb741eca698877fc",3458262992,3305861619}
_kGdfFm[0x771f56]={"aa02de280e25eaf1e1",2456506782,3832523921}
_kGdfFm[0x3c0b75]={"92ed569375dec789",806300672,1770955294}
_kGdfFm[0x99c505]={"15ceeab80d7c60",3585305741,885221235}
_kGdfFm[0x3cf662]={"f9d1c1409bb4d5",3365492810,2609748896}
_kGdfFm[0x9b9261]={"ae",347778064,3276232861}
_kGdfFm[0xebf521]={"0a6680427a5b",1238389630,2853395074}
_kGdfFm[0xc02f58]={"44530b3316104de3dbde",3906910353,3653629404}
_kGdfFm[0x98aaf3]={"2fc28b1fd2",557165818,1020528578}
_kGdfFm[0x97293a]={"7e2aeb7e6f932914899a",4150844528,1518784756}
_kGdfFm[0xec07b9]={"09c1c4cdfcd33b78b9",1958387450,3486449893}
_kGdfFm[0x7a9a12]={"b34c5f5b257a67fd1fb61f",147858249,649304134}
_kGdfFm[0x70c2ed]={"9a3f215ced7afcaced3acc",200647594,191879708}
_kGdfFm[0x306b72]={"4c51080f",3565722391,239908618}
_kGdfFm[0xf22552]={"5f1e1c0faa41ff02",2261107063,3589217433}
_kGdfFm[0xad4cf9]={"8e3bbdb9b7f481",4289033738,3445226509}
_kGdfFm[0x9cc30a]={"9a903a0554fbff410cd8206a441524",3622140211,3725744100}
_kGdfFm[0x18e97b]={"04431575e32380",1624310718,2713022689}
_kGdfFm[0xb7dfc1]={"30b685",3209310379,378740852}
_kGdfFm[0xe2a0ee]={"8c4cf052d0fdedaebf4edb1c6e996c",3153453588,3251977837}
_kGdfFm[0x68bb39]={"c78707d67d7110260cf7",3903082338,883532060}
_kGdfFm[0xf1e1d8]={"c27323c88947ed581c",2488772325,1674431563}
_kGdfFm[0xfbdbd8]={"dd9464b0b05fed89c62dbe010d678603ce92dc05",2005059910,3767028005}
_kGdfFm[0xcbca77]={"a6f05ef3e54d9b",1599149932,1602780738}
_kGdfFm[0xb777db]={"9617164c287624",623696598,2328998036}
_kGdfFm[0xad2b69]={"399192ad225103408d5edee8",2843708478,1409862}
_kGdfFm[0xb188bb]={"dd662a9ae43d026b32432ddf23a5725c2b0c",1169481252,1962835831}
_kGdfFm[0x5da6ee]={"5c88bf2f8e9e62",3837610497,4154197872}
_kGdfFm[0x8ed40a]={"60b7caac",3406260020,3460684483}
_kGdfFm[0xccba65]={"ab",151944983,1187207655}
_kGdfFm[0xf5e62a]={"d14f84f281f1a5",708782090,2990116927}
_kGdfFm[0x47fa09]={"547d60",3726949977,3364290117}
_kGdfFm[0xa5e0f1]={"835f562a10",319687513,3969325944}
_kGdfFm[0xcb8c5c]={"5de35d4fe961",672588078,1995391905}
_kGdfFm[0x9935b2]={"1781db4a87b5fcb5cf3adef0c766b2",1659505161,471027128}
_kGdfFm[0x10318a]={"8bc767449b6db8",2345444882,1286431724}
_kGdfFm[0x917d26]={"87596b418828bd237d",3974336685,3866886066}
_kGdfFm[0x6c91e1]={"94e5174995a9",1525784432,846979372}
_kGdfFm[0x8161ff]={"6f72fa",3898317167,2115862518}
_kGdfFm[0x4582f7]={"8ba2c9602fbe",2545248780,250609484}
_kGdfFm[0xef23b6]={"b0072519",3662755080,375711561}
_kGdfFm[0x8cedd8]={"5892ab3bd93a",2112437600,4215495988}
_kGdfFm[0x6d9fb0]={"29ae",2181419539,3552452127}
_kGdfFm[0xf434a4]={"aec3e462a2adbb333c",1193310991,1445254792}
_kGdfFm[0xa1d354]={"f807fb86aa597a",1792958116,2497083178}
_kGdfFm[0x780110]={"70b6792b",324034730,463603184}
_kGdfFm[0x941caf]={"392c9a1cc6ce2fa2e7df",1982065977,3717420022}
_kGdfFm[0x7bb148]={"907410",3664274526,3996044703}
_kGdfFm[0xa28abc]={"27885c97a070325f58ca98",3931320090,3838054116}
_kGdfFm[0xe5c371]={"f64b6a3a205c91cfe5ef",882490023,1983466973}
_kGdfFm[0x5b4c69]={"8a6edf0544",1527536877,672722731}
_kGdfFm[0x77a6fb]={"16",410811849,502044236}
_kGdfFm[0xdd594b]={"e82100477dd7",300311030,2850879381}
_kGdfFm[0x8f2fc7]={"4d09ded4",866612886,421563519}
_kGdfFm[0x1f45d]={"100d175351985a94f68d",2463170039,3869382101}
_kGdfFm[0x54fc3b]={"d93ed1bd36",1532002664,3710733146}
_kGdfFm[0x8d2cda]={"778cce9ef1ff5203c5771672",3213025777,932588595}
_kGdfFm[0x5641cc]={"485dfe9ec78408a4",1125356136,2795610995}
_kGdfFm[0xd02d82]={"affd2f33dfa2747a1a50",3588383618,1358586457}
_kGdfFm[0x267479]={"e5ebb9a86e803760e2",2758812772,1952457151}
_kGdfFm[0x3a3d41]={"58a6df91bfb5cdb9f1f92ce487db",1388515273,1121102875}
_kGdfFm[0x2ee28f]={"136d74bda78721437a",3468562819,3510843202}
_kGdfFm[0xaae057]={"6fb910e1be1be5e3",2890329678,311617989}
_kGdfFm[0x6e3a4b]={"8eb1a63733f860",1151474353,3424631449}
_kGdfFm[0xd232bf]={"66ae19633535659695f82a0d69620039aa5a",2216348907,361004478}
_kGdfFm[0x4adc2d]={"b110e48db763b3c652",3825478595,3427097667}
_kGdfFm[0x6cda4b]={"a1c4e1e18f",1097610142,1307344900}
_kGdfFm[0x73f99b]={"4a51b6706a1eaad0115556",98413189,3480083005}
_kGdfFm[0x5b35a8]={"817fadd87e",1551181927,978815586}
_kGdfFm[0xa8b1b4]={"f4",110799593,359128022}
_kGdfFm[0x32e789]={"04eb83c576f8b585516c3817adb0d6",2820752660,2779806280}
_kGdfFm[0xd8f437]={"1269bec0641f59d1c5a5",219320706,1798087288}
_kGdfFm[0x62b3e5]={"5e04f2f4cf",1243032748,2496092382}
_kGdfFm[0x2dbcdf]={"31a2",300598953,2661215676}
_kGdfFm[0x11072a]={"726e3e0700",3545974799,2600441452}
_kGdfFm[0xd98655]={"a45ecac113c0aa",2268489152,4150105529}
_kGdfFm[0xd991db]={"10065d3f2c07",3580347845,2128605706}
_kGdfFm[0x221e6]={"d47c43971a2b3f67fa",3472322050,1389947704}
_kGdfFm[0x9b0ad2]={"86631cd90c14",697330830,1472473003}
_kGdfFm[0x6a0fe9]={"80701466",965265104,2197959065}
_kGdfFm[0x53014a]={"b662d0a9ff695c59",1621847639,2649752582}
_kGdfFm[0x3c512c]={"904d26edac",62844110,2635294347}
_kGdfFm[0x77a30e]={"53d0f211ca5205cb",1787700006,1931079056}
_kGdfFm[0x5ef2c4]={"8b609cd5",563327767,4226812165}
_kGdfFm[0xab8ccc]={"97340c3b67",972314812,96283385}
_kGdfFm[0x83131]={"1900415d43f44681fc4675",783567097,2069916775}
_kGdfFm[0xe3a606]={"81c9c2c8de17adbb95",1664221303,2718473641}
_kGdfFm[0x7e502]={"736f83491645e8730bb7",2023958723,1462925165}
_kGdfFm[0x4d5521]={"cf9426aed8149486e4d4a015828a4872",1496768178,3282621004}
_kGdfFm[0xa4caac]={"8ca47be145f79463",2192927983,1521338638}
_kGdfFm[0xac334b]={"917e3ee723156b",1229590591,3380315666}
_kGdfFm[0x1bec32]={"dfe5d45ea2707b",3252081931,37802855}
_kGdfFm[0x5a414]={"f2057c529fc5c501d93d3a4b56ec17d639a0271c96cdc88e3a",3112656435,108050463}
_kGdfFm[0x26261e]={"26783058d4256b632b2d",2876081616,3521135836}
_kGdfFm[0xabba7e]={"737f2a",1239893701,42908343}
_kGdfFm[0x27a9e9]={"09407d78",2998898618,3211686433}
_kGdfFm[0x41d636]={"eedba2feca60be68ab4fed46",2094486162,2903834126}
_kGdfFm[0x875276]={"cf99a4341bf6",1044830544,3403733891}
_kGdfFm[0x4c1291]={"f9ff539a2c3435d5f50c",4195619511,2721711553}
_kGdfFm[0x27f07a]={"00fa2739",4216892574,2612519834}
_kGdfFm[0x426ce9]={"62e33b",1357005258,2985521738}
_kGdfFm[0xebdd88]={"27bc",2342829771,4081100962}
_kGdfFm[0x5b7ee]={"ec3dda2ea7fb272785",897423038,2239172755}
_kGdfFm[0x13e4c1]={"59ef181295376a1e56f904",3151500445,2999756275}
_kGdfFm[0x811f2d]={"56822d2dfe84e948d6c5b723e3",2777660410,2686405857}
_kGdfFm[0xe8c77b]={"aa683808e3d9a57c3b",3519100272,2123722406}
_kGdfFm[0xbff755]={"b048e309a4b966e1fc0e3b2cb6170e40",335670025,2822090059}
_kGdfFm[0x7ca8e9]={"713226b10fb6354c9dc0ac",2370079818,1477628231}
_kGdfFm[0x86bb30]={"f068268ad263af98",962805800,4164298940}
_kGdfFm[0x4334eb]={"a379cf1e3d6efd2572a5",396317173,1303510328}
_kGdfFm[0x95915a]={"618ea18e",2735274212,881614612}
_kGdfFm[0x9ca2bc]={"be34fe99eb",2177845978,4095582436}
_kGdfFm[0xf0defa]={"25d3fd2f",4262426262,1863877987}
_kGdfFm[0xcd36d1]={"7d0065a9",461705446,4183945632}
_kGdfFm[0x497826]={"7157e86a1a0b284079ca53711e65ff",3556077433,732283875}
_kGdfFm[0x6f3b9e]={"97",668113458,3730402542}
_kGdfFm[0xce3ea8]={"61ef58537921622101",3443969064,3355500466}
_kGdfFm[0x489cc0]={"0e37052c",3968563150,1868075222}
_kGdfFm[0x22966a]={"d36572ba89f4",3946671714,2774509167}
_kGdfFm[0xb783b1]={"a3db94078c",2709487806,344919985}
_kGdfFm[0x51d3d9]={"bed7390105ee85",1773123592,102808695}
_kGdfFm[0x3809f]={"94f689cdd48d51cd3860ecf3e5",2613547890,1168856512}
_kGdfFm[0xe2d706]={"67da50af37c00a60fe46",1569420540,2764569528}
_kGdfFm[0xbdc793]={"bd4dc348b4",4024953049,357177042}
_kGdfFm[0x3b0f16]={"f5eb5098fe36",1709488662,2678692868}
_kGdfFm[0x456f5b]={"fed6b24693926004668c26",3714522648,551923757}
_kGdfFm[0x4207df]={"9511ed4b1ed2a2bc19c32e",4056335331,4256542083}
_kGdfFm[0x7c2349]={"442bb750a699f90d6e8e3d8616130cf3a35d20ef32f21215eda7f1c64f247f73e1009015b05dc01260fa934b69e798346ac34ae254090c58d4ea1b5a6db91ef3fb01e10d755e12fba32153ba07e4c9d8c77be93b049b40e8501e2090e41f429216c4",3897934876,2691533956}
_kGdfFm[0xfe90b6]={"89187c8caf",409002613,2804183384}
_kGdfFm[0x9b6f02]={"e5a1ddfaf9c5b42e",4036034438,1326758157}
_kGdfFm[0x30d852]={"27",3862410006,1996602278}
_kGdfFm[0x9f7ea2]={"ffbb57991c420008",1795364238,3613284614}
_kGdfFm[0x91a08d]={"e6bbbfbef65b4efbdd",3231220829,2255154030}
_kGdfFm[0xae94a7]={"1d49211881e8af9abe0b0fcedacf687960e57dfbf3bb2e84512224083d9fedda1adf2f424921afa5ae2207b705d1e5de17cd9a8b5889295cd8f39ca2335e",4104613461,1411643000}
_kGdfFm[0xc29dad]={"1ce0af",2898900248,4260080146}
_kGdfFm[0x7fb8b6]={"d9bdd9dd68cc7a",2688586300,4132469419}
_kGdfFm[0xee4f9d]={"08f11a",1128729350,3040348683}
_kGdfFm[0x1621c8]={"58bc296ca68ddcfc",4256589243,3406957604}
_kGdfFm[0x761db8]={"fe2dc0",1872427484,3168023470}
_kGdfFm[0xae02a5]={"31bcf463b0f39219",1204162662,1466287949}
_kGdfFm[0x809c14]={"abfe80fd92",4018754640,1573210652}
_kGdfFm[0xedfe5e]={"a1a6ea7f4b32850d4ce0",1824358935,3081093040}
_kGdfFm[0x38a281]={"ed3e0864824937e940fb",1556794395,2481173644}
_kGdfFm[0x55ceb3]={"83eb30bc182c80c46d125d8c16b0d7e4",3926773371,466890709}
_kGdfFm[0x9f574f]={"773577f1f48197de5ada",3427744065,560818761}
_kGdfFm[0x370c65]={"b00c26afb3db3b20",1655153952,4196201667}
_kGdfFm[0xfdf5af]={"d6",1982021145,4151043962}
_kGdfFm[0x11c414]={"0f793256",3238904358,3634739441}
_kGdfFm[0x6a0a90]={"cfa859",1318136225,2829914468}
_kGdfFm[0x89e788]={"0af87886a370ff",1242261456,4186433980}
_kGdfFm[0x136b32]={"a828ad44cfe0",1515603415,2294514976}
_kGdfFm[0x53ca9e]={"cacaa27b5db48e",1527336866,1739560703}
_kGdfFm[0x4c2059]={"c4d2247c34d6f32a3d7e6e",3543675257,2390328472}
_kGdfFm[0x101278]={"b99f3bbb",3430074550,1454186617}
_kGdfFm[0x421d5a]={"540cdb5f23389a2af8",3141187146,3859789538}
_kGdfFm[0x69e9e2]={"d2496f2d",2238481288,2671233210}
_kGdfFm[0xae433a]={"f4ab7e58cf68ff591c4ef1c8400fa09242170293ab91",3702285870,420916502}
_kGdfFm[0x17a87]={"1d8d94fd32a88f",4284899199,747013030}
_kGdfFm[0xf9c11a]={"d4fa34f75f032527ba5f0a52fa",2064929101,3777325622}
_kGdfFm[0x44bbb4]={"87909baa79fea8f9264a3d",841464101,2929291763}
_kGdfFm[0x731c03]={"734a5998",688658557,1922245292}
_kGdfFm[0x3c3e3c]={"a94628",2529079150,734929796}
_kGdfFm[0xf3500e]={"e2e5c0f7",262825122,40357725}
_kGdfFm[0xc9b5dc]={"db4fdb",869658842,1317836846}
_kGdfFm[0x78c86e]={"2da74093c6df7601e1a26926",1167677964,2943458789}
_kGdfFm[0x94d110]={"8cc752099267084d3d9ebe2ca9",3575700534,3334117952}
_kGdfFm[0xb2f8b2]={"0babd4f49f",3295312185,3384667253}
_kGdfFm[0x31c203]={"a0a570e0a65539c678bb",3831777252,663464898}
_kGdfFm[0x202ef7]={"fd9a75beaf",620750718,3597211098}
_kGdfFm[0x56b3e2]={"d3e266d09305",1432725697,1035854781}
_kGdfFm[0x48e5f1]={"19a960d8aa66ed430e46bb963bd3e282395787a5d8",1636309702,1184542337}
_kGdfFm[0x3c0ea4]={"c12f32161929acf2d9b4923e",646205343,205983570}
_kGdfFm[0x361120]={"5e370fdd97",1730599586,2972122467}
_kGdfFm[0x80e7d6]={"700a81c3b41c68",634307225,3793318895}
_kGdfFm[0x2a2b5f]={"cf94c196dcfe6311e4",1301240091,3883457982}
_kGdfFm[0xa17b74]={"0ebb03b17c537a332fb2b4116992d442437954e998c8064e12309743551363",3602667197,1497764489}
_kGdfFm[0x681723]={"41",379391462,1213010195}
_kGdfFm[0x328e41]={"96aba5a2dcaae9",766030317,1772029415}
_kGdfFm[0xdca843]={"0b8d42fe0b",2952502227,2999603851}
_kGdfFm[0xc6304]={"3c3d",2769271930,2244895465}
_kGdfFm[0x175ccb]={"dd4600039117c3",2207177599,7332556}
_kGdfFm[0x36c0fd]={"187993",2798766817,2800264349}
_kGdfFm[0xdf8c65]={"dbb41b1337",1651919483,3223242446}
_kGdfFm[0x200469]={"9396ddb55664e1944105e81230",2116916116,1010200699}
_kGdfFm[0xf2cab0]={"34cc1821ec51",320235554,3707298856}
_kGdfFm[0x125d8f]={"419de9f48e67b85b5e8994ba",3353988549,1226597320}
_kGdfFm[0xe5d97]={"57",1830433969,3675506539}
_kGdfFm[0x6572ce]={"22ffb881",28067068,3857591951}
_kGdfFm[0xcf0be4]={"0edcd00e6756466ffcb180853943ae394dc4503e",3808929458,3834467476}
_kGdfFm[0x18c031]={"3b4570c5a824d76aedfe",1532373991,2367567563}
_kGdfFm[0x1b3448]={"400948e4",2041451091,1141206197}
_kGdfFm[0xe900f1]={"bed3bffc08ed",3702384843,3574623997}
_kGdfFm[0x8cf7c5]={"41b1b667",3276217344,20384102}
_kGdfFm[0x37cc6c]={"111f207592f86a32",332928952,4163359708}
_kGdfFm[0x440196]={"0eea0acc56be293bb12f",2373936740,2611530412}
_kGdfFm[0x381d47]={"5e734fd908b57e43cd99",1031285222,962881252}
_kGdfFm[0x61d908]={"c38cb7942526c51c33",1574375952,1992337759}
_kGdfFm[0x88d1c2]={"590b",2283599297,2668279679}
_kGdfFm[0x1f5646]={"fb8188bf7b8b6293ad",3654100858,2576607981}
_kGdfFm[0x6b4f95]={"83f3fa281af34129f6adb1",2709656757,4257267018}
_kGdfFm[0xed9af5]={"8b9057",1558946291,1903023639}
_kGdfFm[0x7bb2d7]={"5c1f",3251922095,1378897239}
_kGdfFm[0x127a38]={"7393f5ff8d0e",1691626819,2762592274}
_kGdfFm[0x4a6aff]={"13f8d9f20216",2911353998,1367884027}
_kGdfFm[0x3f5732]={"1b8204527acc09",2505207917,1995809463}
_kGdfFm[0xc70e9c]={"37f996604bc5e8a732c61d68b3d1fa8c",3241328724,374896400}
_kGdfFm[0x389339]={"e3",513891537,1799755806}
_kGdfFm[0xb1ac12]={"b270830e0b47e08062b7",405294879,3391753268}
_kGdfFm[0x3ad9a4]={"7cb4075cc4da383cecb11b4dbce2f5d02ab8",3597854930,3688359821}
_kGdfFm[0xc0d447]={"a832c4830b",690596182,3061200175}
_kGdfFm[0x1d04a]={"c4dc",3872015262,3245193671}
_kGdfFm[0x717eb2]={"eedf4672db4945d6",3736438372,3311914748}
_kGdfFm[0xfbc756]={"bb9aadbff86198ce80",3153158843,3329676707}
_kGdfFm[0x3361f7]={"5f2ddb43a1a0548312417a",868097352,1723011004}
_kGdfFm[0x7e474f]={"16f3db118928f880",2098999078,1546171949}
_kGdfFm[0x80e132]={"bfe51df434850a",3923133628,133278893}
_kGdfFm[0x2cf756]={"3e2f3810f4fe11b3",2183603365,2023381168}
_kGdfFm[0xa1814f]={"f4b757099c",527070268,2297500772}
_kGdfFm[0x45794d]={"992d073d48",561685389,2992587417}
_kGdfFm[0x5982b9]={"3d5b8e1f",3163836525,91485924}
_kGdfFm[0x902232]={"a1e77dec63",1176360702,900610934}
_kGdfFm[0x99deb0]={"cc87b2f01c5f50",2738764921,2139369442}
_kGdfFm[0x9c1583]={"8c06f7110a139cb3c5de23",4060030291,1191234856}
_kGdfFm[0x607c28]={"22f37ba9e57672",3505891970,670965707}
_kGdfFm[0x16824a]={"eb73",2919654543,2520229059}
_kGdfFm[0x301417]={"53ae0388625d6986e0c5",1987998964,401532850}
_kGdfFm[0xe73d21]={"644945f270db24c88ac974",483436244,3456699363}
_kGdfFm[0x568513]={"5bcc58848beeffb21f6a91d77b870f",1600492672,340975704}
_kGdfFm[0xaed3d6]={"c33563d5",2604860864,2161309506}
_kGdfFm[0xf8560d]={"",3037994941,478325415}
_kGdfFm[0x88eb19]={"f4bee6c29b",538548859,2205019398}
_kGdfFm[0x5b6f69]={"cbe635eae4aada1a14873358540b2e",696982,1833867443}
_kGdfFm[0x26f82f]={"17f0638bdc8a",2881966476,1107740059}
_kGdfFm[0x4058a5]={"de12762c18444865f82c",3503288028,3654799143}
_kGdfFm[0x2324b1]={"d026fecf8b46cc74e4bb15",1653626282,1112455029}
_kGdfFm[0x9c8209]={"a28d3b09675b5ff0809e6d",741153073,1358061816}
_kGdfFm[0x3cb5f]={"207128b673b81907a651",1954820823,3535769034}
_kGdfFm[0xd0db61]={"9406b2f3582226",161977786,4082191947}
_kGdfFm[0xeb02ae]={"8f86c4045dd70b82cab1b88e8115be",2348103643,1402813859}
_kGdfFm[0x142f22]={"b6d9f9022f",3354498286,481872021}
_kGdfFm[0xd9c6a6]={"e8fc9d5305f7fb",2031094195,2864169171}
_kGdfFm[0xa898d8]={"c485d044e5f77d5d5b0e",4248555796,2379121731}
_kGdfFm[0x91ad75]={"c4f6fa8f",1739013657,4397554}
_kGdfFm[0xc70c7b]={"c8439db2d28771a7a1c076",1845333541,240162985}
_kGdfFm[0x877d7a]={"c2",1457441142,3582713155}
_kGdfFm[0x4a2298]={"a0ea7e0b45",1892172932,3719363354}
_kGdfFm[0x550aec]={"547fc3d846",3626842715,1235644068}
_kGdfFm[0xe45c82]={"5366d4ab0d20f85fbf",3426070404,2142874007}
_kGdfFm[0xc066a9]={"9b3e74f8705492c4527aab8b40",1966921812,2950100721}
_kGdfFm[0xa89d01]={"d79057d15b07d9f5bfb5223d4682aa15107528",1764200529,3536556299}
_kGdfFm[0xa251ce]={"831e454761",938337195,1315552088}
_kGdfFm[0x50b4ee]={"f8d4b80e37be",2482761198,4193015529}
_kGdfFm[0xc7374b]={"4c402d0cd326edd770422b",450220066,669826380}
_kGdfFm[0xda45b4]={"0c1688",1337634081,3280726414}
_kGdfFm[0x5cdceb]={"2fa6",2896097583,3766733912}
_kGdfFm[0x93b4a7]={"fc51d6e901",4229571885,325534311}
_kGdfFm[0x26d3be]={"4219d641427be4e1548e4d4bf1",2554728291,569532173}
_kGdfFm[0xf2ecc5]={"8a075d656dc5e129b6afb9",1055593141,1067603071}
_kGdfFm[0x304ea2]={"44f867fffcb1af303060292257739507",911446595,2234825655}
_kGdfFm[0x156a01]={"9bb81bb8f60be2",875644967,4076038546}
_kGdfFm[0xca2df1]={"4c0a13550e7314a2",3056336281,3988897468}
_kGdfFm[0xc1e16]={"8e5732b7",2218891990,3360018052}
_kGdfFm[0x1cfe86]={"25bab395df6bf52cc43e4c45b18e88bed85d95c5184700848684cfe4f6cf",2212398855,2359912274}
_kGdfFm[0x8e2f3c]={"78b59cb5bff71e0c3c1e",1408215102,2999724971}
_kGdfFm[0x26a24f]={"4599b171a8e51de9fa88",2576170121,443991463}
_kGdfFm[0xe2a13a]={"ed37ceff10f8",1083945067,3867622158}
_kGdfFm[0xc2a81d]={"501b5164870fde",1966448437,3190684348}
_kGdfFm[0x15b4d9]={"fbc9",269050687,3139277570}
_kGdfFm[0xd8402a]={"5c7f237bbba8a756",1111177206,3435710806}
_kGdfFm[0xc4e9b5]={"3d88831c62",3363612613,2418960838}
_kGdfFm[0xb58783]={"4d36c1bf40",851387671,943796968}
_kGdfFm[0x3f91d6]={"44",455135027,670549165}
_kGdfFm[0x1e3e7]={"79",3849393247,256141479}
_kGdfFm[0xff3971]={"64f54308b04872bb06",753016956,4218605660}
_kGdfFm[0x94c938]={"4e99d0642e4274e6",233381065,1175467562}
_kGdfFm[0x45cfb3]={"f8a182eb6fc4ae6717",420645098,75232392}
_kGdfFm[0x8debed]={"baf6a487214c2dcc2d3c",923869642,3415360970}
_kGdfFm[0xb5b8bb]={"80508d1e60826d",2016904965,2907073121}
_kGdfFm[0x9da538]={"e5a904cf",64853289,2705559627}
_kGdfFm[0xc8f604]={"881845568864",1358422584,1732791092}
_kGdfFm[0xee1853]={"94d3249d24b1a9bf8b9e81",396001454,1463585244}
_kGdfFm[0x2e5e6d]={"53332413",2106438167,380252746}
_kGdfFm[0xa761fc]={"3c59c7",540597238,55557360}
_kGdfFm[0x5ba782]={"d9f07cc0ce",3974124066,515847018}
_kGdfFm[0x9d8867]={"6fe3e265c8fe171d4a11",2370565849,1003746474}
_kGdfFm[0xb8cadc]={"c7659ae1",1120194529,3900401650}
_kGdfFm[0xf97272]={"8909212e850d81cca3",208644544,244994649}
_kGdfFm[0x57da27]={"68c1d16e6ec1",3697915812,1689674098}
_kGdfFm[0x4c3b7a]={"09562d16",1712679191,1478500026}
_kGdfFm[0xb0388d]={"caf04c0d39404f9b7ed31a73f7c73999e5",272210164,4204729821}
_kGdfFm[0x580662]={"ec8bd489a1f35b9847",3074926587,1703714032}
_kGdfFm[0x36f7ca]={"94c6c829bb",1029526656,1479441540}
_kGdfFm[0xf45cf4]={"8ba9f8abc91671a1e1",720256015,1104589703}
_kGdfFm[0x635758]={"dc2800",1420240339,1702246811}
_kGdfFm[0x8d0d78]={"2375802c",2673591604,1622031427}
_kGdfFm[0x375d10]={"a940b98950a27bcc4c12a6f2eb790332c7a2eaa82d10c80506d580",2635701991,2337933038}
_kGdfFm[0xed0d41]={"fe8a5c8b",1793660489,1882864690}
_kGdfFm[0x7b2f23]={"3deeb0340f48",3276281383,3499322457}
_kGdfFm[0x20126a]={"9411",3096158783,1965738603}
_kGdfFm[0x43a0a4]={"d1411ae3f079",4026698610,1461147820}
_kGdfFm[0xc90fe3]={"33f39dbd023ed019c2",3545981861,2606263340}
_kGdfFm[0x546f8c]={"b35c0205",279642220,693904084}
_kGdfFm[0xf6230d]={"92",2853497456,2895416721}
_kGdfFm[0x2651a8]={"4dade3aa",3491304184,716195084}
_kGdfFm[0x3eb328]={"9070829ceb25264433b20f",949113182,4050962210}
_kGdfFm[0xe0b3e7]={"919b453504b927",1538749606,1952840172}
_kGdfFm[0xfd6d5e]={"6167",3927114552,2576262278}
_kGdfFm[0xc65017]={"6cbb19ad",851879929,4115346255}
_kGdfFm[0x533531]={"3502cf73df0c1056",1765932287,2092435222}
_kGdfFm[0x92732]={"bf7fa2d1b593a94a4d316b",1081746145,1740747358}
_kGdfFm[0x5ad651]={"f7708469cc69d12a0319",3459490432,1931478100}
_kGdfFm[0x3434f1]={"45ba68b1071db4",2538643295,667327349}
_kGdfFm[0x9bfcb3]={"978d9cea6a25",3628993931,818891776}
local _gDQl = 0
for i, e in pairs(_kGdfFm) do
  _gDQl = (_gDQl + i * 31 + #e[1] * 17 + e[2] * 13 + e[3] * 7 + (tonumber(e[1]:sub(1, 2), 16) or 0)) % 2147483647
end
if _gDQl ~= ((0x39372e4c) - (0xd5af)) then return end
local _SyBs = {}
local _TZnt = function(i)
  local e = _kGdfFm[i]
  local s = _vaahrTa(e[1])
  local k0, k1 = e[2], e[3]
  local o = {}
  for j = 1, #s do
    local p = j - 1
    local w = _zFav(k0, k1, math.floor(p / 4))
    local kb = math.floor(w / (2 ^ (((p % 4)) * 8))) % 256
    o[j] = string.char(_kyHWaNv(string.byte(s, j), kb) % 256)
  end
  return table.concat(o)
end
local _TZWxN = function(i)
  local v = _SyBs[i]
  if v == nil then
    v = _TZnt(i)
    _SyBs[i] = v
  end
  return v
end
local _qAIo = {_TZWxN(0x809c14),_TZWxN(0x142f22),_TZWxN(0x8be00d),_TZWxN(0x4582f7),_TZWxN(0x7fb8b6),_TZWxN(0x6ffa52),_TZWxN(0x38a281),_TZWxN(0x2a2b5f),_TZWxN(0x9c8209),_TZWxN(0xec07b9),_TZWxN(0x86bb30),_TZWxN(0x6e3a4b)}
local _EFQevd = function(...)
local _YtXGLQ = game:GetService((_TZWxN(0xf5e62a)))
local _nopqDX = game:GetService((_TZWxN(0x304ea2)))

local _rZjlRsZ = _YtXGLQ[(_TZWxN(0x7ca8e9))]
local _jnzv = (_TZWxN(0x9b9261) .. _TZWxN(0x4d5521))

local _IWTnsDX = getgenv()[(_TZWxN(0xc90fe3))]
if type(_IWTnsDX) ~= (_TZWxN(0xb2f8b2)) then
    if #_qAIo[1] <= 5 then
_IWTnsDX = {}
    getgenv()[(_TZWxN(0xc90fe3))] = _IWTnsDX
end
end

_IWTnsDX[(_TZWxN(0x7e502))] = (_IWTnsDX[(_TZWxN(0x7e502))] or ((0x0) + (0x0))) + ((0x0) + (0x1))
local _xUXm = _IWTnsDX[(_TZWxN(0x7e502))]
_IWTnsDX[(_TZWxN(0xda7e1))] = false
_IWTnsDX[(_TZWxN(0xee1853))] = false
_IWTnsDX[(_TZWxN(0xf97272))] = _IWTnsDX[(_TZWxN(0xf97272))] or false
_IWTnsDX[(_TZWxN(0x8ed40a) .. _TZWxN(0x7e474f))] = _IWTnsDX[(_TZWxN(0x8ed40a) .. _TZWxN(0x7e474f))]
_IWTnsDX[(_TZWxN(0x2324b1))] = _IWTnsDX[(_TZWxN(0x2324b1))] or ((0x0) + (0x0))
_IWTnsDX[(_TZWxN(0x9b297f))] = _IWTnsDX[(_TZWxN(0x9b297f))] or ((0x0) + (0x0))
_IWTnsDX[(_TZWxN(0x4c1291))] = _IWTnsDX[(_TZWxN(0x4c1291))] or ((0x0) + (0x0))
_IWTnsDX[(_TZWxN(0x3cb5f))] = _IWTnsDX[(_TZWxN(0x3cb5f))]
_IWTnsDX[(_TZWxN(0x9f7ea2))] = _IWTnsDX[(_TZWxN(0x9f7ea2))]
_IWTnsDX[(_TZWxN(0x917d26))] = _IWTnsDX[(_TZWxN(0x917d26))]
_IWTnsDX[(_TZWxN(0xce3ea8))] = _IWTnsDX[(_TZWxN(0xce3ea8))] or ((0x0) + (0x0))
_IWTnsDX[(_TZWxN(0x8e2f3c))] = _IWTnsDX[(_TZWxN(0x8e2f3c))] or ((0x0) + (0x0))
_IWTnsDX[(_TZWxN(0xf434a4))] = _IWTnsDX[(_TZWxN(0xf434a4))]
_IWTnsDX[(_TZWxN(0x5641cc))] = _IWTnsDX[(_TZWxN(0x5641cc))]
_IWTnsDX[(_TZWxN(0xa4caac))] = false
_IWTnsDX[(_TZWxN(0xad4cf9))] = nil
_IWTnsDX[(_TZWxN(0x780110))] = nil
_IWTnsDX[(_TZWxN(0x27f07a))] = nil

local function _XBAJnj(...)
    if #_qAIo[7] ~= 11 then
local _SfnpxUd = {}
    for _ESFl = ((0x1) + (0x0)), select((_TZWxN(0xa8b1b4)), ...) do
        if #_qAIo[2] <= 5 then
if #_qAIo[11] ~= 8 then string.byte(_qAIo[11], 1) end
_SfnpxUd[#_SfnpxUd + ((0x1) + (0x0))] = tostring(select(_ESFl, ...))
end
    end
    local _BEZv = string[(_TZWxN(0xf2cab0))]((_TZWxN(0xd98655)), os[(_TZWxN(0x8d0d78))]((_TZWxN(0xae02a5))), table[(_TZWxN(0xe2a13a))](_SfnpxUd, (_TZWxN(0x877d7a))))
    local _pDPCFJK = (_TZWxN(0xf8560d))
    local _YXdYJzb, _hStBw = pcall(readfile, _jnzv)
    if _YXdYJzb and type(_hStBw) == (_TZWxN(0x7b2f23)) then
        if #_qAIo[6] >= 7 then
_pDPCFJK = _hStBw
end
    end
    if #_pDPCFJK > ((0x87de) + (0x6282)) then
        if #_qAIo[4] ~= 7 then
_pDPCFJK = _pDPCFJK:sub(-((0x9ea) + (0x4436)))
end
    end
    writefile(_jnzv, _pDPCFJK .. _BEZv .. (_TZWxN(0x681723)))
end
end

local function _jCkqz()
    if #_qAIo[9] >= 11 then
if #_qAIo[8] ~= 9 then string.byte(_qAIo[8], 1) end
local _ZuNzEKP = _rZjlRsZ[(_TZWxN(0x4adc2d))]:FindFirstChild((_TZWxN(0x1bec32)))
    if not _ZuNzEKP then
        if #_qAIo[5] <= 7 then
if #_qAIo[2] ~= 5 then string.byte(_qAIo[2], 1) end
return ((0x0) + (0x0))
end
    end
    local _wOYTYK = _ZuNzEKP:FindFirstChild((_TZWxN(0xb5b8bb)), true)
    if not _wOYTYK or not _wOYTYK:IsA((_TZWxN(0xf45cf4))) then
        if #_qAIo[8] ~= 10 then
if #_qAIo[7] ~= 10 then string.byte(_qAIo[7], 1) end
return ((0x0) + (0x0))
end
    end
    local _YJlDX = _wOYTYK[(_TZWxN(0x8f2fc7))]
    _YJlDX = _YJlDX:gsub((_TZWxN(0xfdf5af)), (_TZWxN(0xf8560d)))
    _YJlDX = _YJlDX:gsub((_TZWxN(0x88d1c2)), (_TZWxN(0xf8560d)))
    local _QhYxeO = _YJlDX:match((_TZWxN(0x99deb0)))
    return tonumber(_QhYxeO) or ((0x0) + (0x0))
end
end

local function _jXoQa()
    if #_qAIo[5] == 7 then
if #_qAIo[10] ~= 9 then string.byte(_qAIo[10], 1) end
local _BYaU = _rZjlRsZ[(_TZWxN(0x580662))]
    if not _BYaU then
        if #_qAIo[6] <= 7 then
return nil
end
    end
    for _nycyPii, _Cgaz in ipairs(_BYaU:GetChildren()) do
        if #_qAIo[10] ~= 10 then
if #_qAIo[8] ~= 9 then string.byte(_qAIo[8], 1) end
if _Cgaz:IsA((_TZWxN(0x2f39a8))) and _Cgaz:GetAttribute((_TZWxN(0x27b7ed))) == true then
            if #_qAIo[6] ~= 8 then
return _Cgaz
end
        end
end
    end
    return nil
end
end

local function _YBUG()
    if #_qAIo[11] <= 8 then
if #_qAIo[5] ~= 7 then string.byte(_qAIo[5], 1) end
local _ayQiLr = _rZjlRsZ[(_TZWxN(0x580662))]
    if not _ayQiLr then
        if #_qAIo[4] >= 6 then
return nil
end
    end
    local _wLumXg = _ayQiLr:FindFirstChildOfClass((_TZWxN(0x3c0b75)))
    if not _wLumXg then
        if #_qAIo[11] == 8 then
if #_qAIo[12] ~= 7 then string.byte(_qAIo[12], 1) end
return nil
end
    end
    local _qnasBB = _jXoQa()
    if _qnasBB then
        if #_qAIo[5] ~= 8 then
return _qnasBB
end
    end
    local _fcUv = _rZjlRsZ:FindFirstChildOfClass((_TZWxN(0x53014a)))
    if _fcUv then
        if #_qAIo[4] >= 6 then
for _DtfErF, _WwyRdKQ in ipairs(_fcUv:GetChildren()) do
            if #_qAIo[10] == 9 then
if #_qAIo[2] ~= 5 then string.byte(_qAIo[2], 1) end
if _WwyRdKQ:IsA((_TZWxN(0x2f39a8))) and _WwyRdKQ:GetAttribute((_TZWxN(0x27b7ed))) == true then
                if #_qAIo[4] >= 6 then
if #_qAIo[7] ~= 10 then string.byte(_qAIo[7], 1) end
_wLumXg:EquipTool(_WwyRdKQ)
                task[(_TZWxN(0x489cc0))](((3393.0390730361432) - (3391.5390730361432)))
                return _jXoQa()
end
            end
end
        end
end
    end
    return nil
end
end

local function _jJyONAd()
    if #_qAIo[2] ~= 6 then
if #_qAIo[3] ~= 10 then string.byte(_qAIo[3], 1) end
if _IWTnsDX[(_TZWxN(0xf97272))] and _IWTnsDX[(_TZWxN(0x8ed40a) .. _TZWxN(0x7e474f))] == _jXoQa() then
        if #_qAIo[1] == 5 then
if #_qAIo[10] ~= 9 then string.byte(_qAIo[10], 1) end
return
end
    end
    local _rDUIq = _jXoQa()
    if not _rDUIq then
        if #_qAIo[2] <= 5 then
if #_qAIo[6] ~= 7 then string.byte(_qAIo[6], 1) end
return
end
    end
    _IWTnsDX[(_TZWxN(0xf97272))] = true
    _IWTnsDX[(_TZWxN(0x8ed40a) .. _TZWxN(0x7e474f))] = _rDUIq
    for _ewlNU, _sYrJ in ipairs(_rDUIq:GetChildren()) do
        if #_qAIo[11] >= 8 then
if #_qAIo[9] ~= 11 then string.byte(_qAIo[9], 1) end
if _sYrJ:IsA((_TZWxN(0xa28abc))) then
            if #_qAIo[9] ~= 12 then
if #_qAIo[10] ~= 9 then string.byte(_qAIo[10], 1) end
_sYrJ[(_TZWxN(0x56b3e2) .. _TZWxN(0x7ba86d))]:Connect(function(...)
                if #_qAIo[6] == 7 then
if #_qAIo[2] ~= 5 then string.byte(_qAIo[2], 1) end
if _sYrJ[(_TZWxN(0x2e5e6d))] == (_TZWxN(0x8debed)) then
                    if #_qAIo[5] <= 7 then
_IWTnsDX[(_TZWxN(0x9b297f))] = _IWTnsDX[(_TZWxN(0x9b297f))] + ((0x1) + (0x0))
end
                elseif _sYrJ[(_TZWxN(0x2e5e6d))] == (_TZWxN(0x1f45d) .. _TZWxN(0xdf8c65)) then
                    if #_qAIo[2] >= 5 then
_IWTnsDX[(_TZWxN(0x2324b1))] = _IWTnsDX[(_TZWxN(0x2324b1))] + ((0x1) + (0x0))
                    _IWTnsDX[(_TZWxN(0x3cb5f))] = tostring((...))
                    _XBAJnj((_TZWxN(0x4a2298)), (_TZWxN(0x1f45d) .. _TZWxN(0xdf8c65)), _IWTnsDX[(_TZWxN(0x3cb5f))])
end
                elseif _sYrJ[(_TZWxN(0x2e5e6d))] == (_TZWxN(0x2cf756) .. _TZWxN(0xa251ce)) then
                    if #_qAIo[6] == 7 then
if #_qAIo[2] ~= 5 then string.byte(_qAIo[2], 1) end
_IWTnsDX[(_TZWxN(0x4c1291))] = _IWTnsDX[(_TZWxN(0x4c1291))] + ((0x1) + (0x0))
                    _IWTnsDX[(_TZWxN(0xce3ea8))] = os[(_TZWxN(0x202ef7))]()
                    local _wDjeVk = select(((0x1) + (0x1)), ...)
                    if type(_wDjeVk) == (_TZWxN(0xb2f8b2)) then
                        if #_qAIo[3] <= 10 then
_IWTnsDX[(_TZWxN(0x9f7ea2))] = _wDjeVk
                        _XBAJnj((_TZWxN(0x4a2298)), (_TZWxN(0x2cf756) .. _TZWxN(0xa251ce)), tostring(_wDjeVk[(_TZWxN(0x225007))]), tostring(_wDjeVk[(_TZWxN(0x875276))]), tostring(_wDjeVk[(_TZWxN(0x127a38))]) .. (_TZWxN(0x15b4d9)), tostring(_wDjeVk[(_TZWxN(0x5b4c69))]))
end
                    end
end
                elseif _sYrJ[(_TZWxN(0x2e5e6d))] == (_TZWxN(0x2ee28f)) then
                    if #_qAIo[2] <= 5 then
if #_qAIo[8] ~= 9 then string.byte(_qAIo[8], 1) end
_IWTnsDX[(_TZWxN(0x917d26))] = select(((0x1) + (0x0)), ...)
                    _XBAJnj((_TZWxN(0x4a2298)), (_TZWxN(0x2ee28f)), tostring(_IWTnsDX[(_TZWxN(0x917d26))]))
end
                elseif _sYrJ[(_TZWxN(0x2e5e6d))] == (_TZWxN(0x3a3d41)) then
                    if #_qAIo[10] >= 9 then
if #_qAIo[9] ~= 11 then string.byte(_qAIo[9], 1) end
_XBAJnj((_TZWxN(0x4a2298)), (_TZWxN(0x3a3d41)))
end
                end
end
            end)
end
        end
end
    end
end
end

local function _IYKgqIJ(_NDzH)
    if #_qAIo[9] ~= 12 then
local _bcwv = {}
    local _IYmu = ((0x0) + (0x0))
    for _CQptQ, _ZBVV in pairs(getgc(true)) do
        if #_qAIo[6] == 7 then
if #_qAIo[9] ~= 11 then string.byte(_qAIo[9], 1) end
_IYmu = _IYmu + ((0x0) + (0x1))
        if type(_ZBVV) == (_TZWxN(0xaae057)) then
            if #_qAIo[6] >= 7 then
local _qIjbqP, _dhNzQfv = pcall(debug[(_TZWxN(0x95915a))], _ZBVV, (_TZWxN(0x77a6fb)))
            if _qIjbqP and type(_dhNzQfv) == (_TZWxN(0x7b2f23)) and _dhNzQfv:find(_NDzH, ((0x0) + (0x1)), true) then
                if #_qAIo[4] == 6 then
local _gVAVXi, _KxkFjxP = pcall(debug[(_TZWxN(0x95915a))], _ZBVV, (_TZWxN(0xf6230d)))
                if _gVAVXi then
                    if #_qAIo[11] == 8 then
if #_qAIo[11] ~= 8 then string.byte(_qAIo[11], 1) end
_bcwv[#_bcwv + ((0x0) + (0x1))] = { fn = _ZBVV, line = _KxkFjxP }
end
                end
end
            end
end
        end
        if _IYmu % ((0xd31) + (0x26f)) == ((0x0) + (0x0)) then
            if #_qAIo[4] == 6 then
task[(_TZWxN(0x489cc0))]()
end
        end
end
    end
    return _bcwv
end
end

local function _LIEOpkN(_GxYw)
    if #_qAIo[3] == 10 then
local _yvPMXm = _jXoQa()
    if not _yvPMXm then
        if #_qAIo[3] ~= 11 then
if #_qAIo[8] ~= 9 then string.byte(_qAIo[8], 1) end
return nil, nil
end
    end
    if not _GxYw and _IWTnsDX[(_TZWxN(0xad4cf9))] == _yvPMXm and _IWTnsDX[(_TZWxN(0x780110))] and _IWTnsDX[(_TZWxN(0x27f07a))] then
        if #_qAIo[7] == 10 then
return _IWTnsDX[(_TZWxN(0x780110))], _IWTnsDX[(_TZWxN(0x27f07a))]
end
    end
    local _PSlGDm = _IYKgqIJ((_TZWxN(0x9da538) .. _TZWxN(0x3361f7)))
    local _HGGrcY = nil
    local _muKOmq = nil
    for _TIXMh, _OnNdRg in ipairs(_PSlGDm) do
        if #_qAIo[11] <= 8 then
if #_qAIo[5] ~= 7 then string.byte(_qAIo[5], 1) end
if _OnNdRg[(_TZWxN(0x27a9e9))] == ((0x26a) + (0x4c)) then
            if #_qAIo[3] >= 10 then
_HGGrcY = _OnNdRg[(_TZWxN(0x20126a))]
end
        elseif _OnNdRg[(_TZWxN(0x27a9e9))] == ((0x187) + (0x153)) then
            if #_qAIo[11] <= 8 then
_muKOmq = _OnNdRg[(_TZWxN(0x20126a))]
end
        end
end
    end
    if not _muKOmq then
        if #_qAIo[11] <= 8 then
local _gLHrXAP = _yvPMXm:FindFirstChild((_TZWxN(0x4c3b7a)))
        for _pivfO, _xXyoXP in ipairs(_PSlGDm) do
            if #_qAIo[2] <= 5 then
local _adIz, _RBTdExE = pcall(debug[(_TZWxN(0xf2ecc5))], _xXyoXP[(_TZWxN(0x20126a))])
            if _adIz then
                if #_qAIo[10] == 9 then
if #_qAIo[5] ~= 7 then string.byte(_qAIo[5], 1) end
for _FsxBbFB, _aTtkKQj in ipairs(_RBTdExE) do
                    if #_qAIo[1] == 5 then
if #_qAIo[1] ~= 5 then string.byte(_qAIo[1], 1) end
if _aTtkKQj == _gLHrXAP then
                        if #_qAIo[8] == 9 then
_muKOmq = _xXyoXP[(_TZWxN(0x20126a))]
                        break
end
                    end
end
                end
end
            end
            if _muKOmq then
                if #_qAIo[6] == 7 then
break
end
            end
end
        end
end
    end
    _IWTnsDX[(_TZWxN(0xad4cf9))] = _yvPMXm
    _IWTnsDX[(_TZWxN(0x780110))] = _HGGrcY
    _IWTnsDX[(_TZWxN(0x27f07a))] = _muKOmq
    return _HGGrcY, _muKOmq
end
end

local function _BQDbhdC(_DKom)
    if #_qAIo[8] == 9 then
return {
        UserInputType = Enum[(_TZWxN(0x902232) .. _TZWxN(0x717eb2))][(_TZWxN(0xb58783) .. _TZWxN(0xe0b3e7))],
        KeyCode = Enum[(_TZWxN(0x10318a))][(_TZWxN(0x53ca9e))],
        UserInputState = _DKom or Enum[(_TZWxN(0x635758) .. _TZWxN(0x4a7410))][(_TZWxN(0x11072a))],
        Position = Vector3[(_TZWxN(0xc9b5dc))](((0x288) + (0x138)), ((0x44) + (0x1d8)), ((0x0) + (0x0))),
        Delta = Vector3[(_TZWxN(0xc9b5dc))](((0x0) + (0x0)), ((0x0) + (0x0)), ((0x0) + (0x0)))
    }
end
end

local function _rFuho(_HWLHo, _tphKjMH)
    if #_qAIo[12] >= 7 then
if #_qAIo[2] ~= 5 then string.byte(_qAIo[2], 1) end
local _KIaNbos = _BQDbhdC(Enum[(_TZWxN(0x635758) .. _TZWxN(0x4a7410))][(_TZWxN(0x11072a))])
    if _HWLHo then
        if #_qAIo[11] ~= 9 then
pcall(_HWLHo, _KIaNbos, false)
end
    else
        if #_qAIo[9] == 11 then
if #_qAIo[3] ~= 10 then string.byte(_qAIo[3], 1) end
pcall(debug[(_TZWxN(0xe5c371))], _tphKjMH, ((0x1) + (0x0)), true)
        pcall(debug[(_TZWxN(0xe5c371))], _tphKjMH, ((0x4) + (0x1)), tick() - ((-569.9951976213624) + (570.3451976213624)))
end
    end
    task[(_TZWxN(0x489cc0))](((-3046.1535905202236) + (3046.5735905202237)))
    _KIaNbos[(_TZWxN(0x635758) .. _TZWxN(0x4a7410))] = Enum[(_TZWxN(0x635758) .. _TZWxN(0x4a7410))][(_TZWxN(0x3c3e3c))]
    local _jNpg, _MLoY = pcall(_tphKjMH, _KIaNbos, false)
    return _jNpg, _MLoY
end
end

local function _nFOFxbJ(_PjWPfVV, _ZfBNvm)
    if #_qAIo[7] <= 10 then
if #_qAIo[10] ~= 9 then string.byte(_qAIo[10], 1) end
if typeof(_ZfBNvm) ~= (_TZWxN(0x37cc6c)) then
        if #_qAIo[4] ~= 7 then
if #_qAIo[3] ~= 10 then string.byte(_qAIo[3], 1) end
return false
end
    end
    local _DFdD, _xajR = pcall(function()
        if #_qAIo[4] >= 6 then
return _ZfBNvm:IsDescendantOf(_PjWPfVV)
end
    end)
    return _DFdD and _xajR
end
end

local function _oEghLdT(_hgwkm)
    if #_qAIo[5] <= 7 then
local _OiymcjR = _IYKgqIJ((_TZWxN(0x267479) .. _TZWxN(0xe2d706)))
    local _WTgxn = nil
    local _nJszWFH = nil
    for _qhAGjc, _RhZHdAB in ipairs(_OiymcjR) do
        if #_qAIo[11] ~= 9 then
local _kzYU, _EoBpQxL = pcall(debug[(_TZWxN(0xf2ecc5))], _RhZHdAB[(_TZWxN(0x20126a))])
        local _FiiWN = false
        if _kzYU then
            if #_qAIo[5] >= 7 then
for _exzNjqt, _XfDepo in ipairs(_EoBpQxL) do
                if #_qAIo[8] <= 9 then
if _nFOFxbJ(_hgwkm, _XfDepo) then
                    if #_qAIo[12] == 7 then
_FiiWN = true
                    break
end
                end
end
            end
end
        end
        if _FiiWN then
            if #_qAIo[9] == 11 then
if #_qAIo[5] ~= 7 then string.byte(_qAIo[5], 1) end
if _RhZHdAB[(_TZWxN(0x27a9e9))] == ((0x1c1) + (0xec)) then
                if #_qAIo[3] == 10 then
_WTgxn = _RhZHdAB[(_TZWxN(0x20126a))]
end
            elseif _RhZHdAB[(_TZWxN(0x27a9e9))] == ((0xe0) + (0xc9)) then
                if #_qAIo[2] <= 5 then
_nJszWFH = _RhZHdAB[(_TZWxN(0x20126a))]
end
            end
end
        end
end
    end
    if not _WTgxn then
        if #_qAIo[5] >= 7 then
if #_qAIo[12] ~= 7 then string.byte(_qAIo[12], 1) end
for _nscp, _aYWBd in ipairs(_OiymcjR) do
            if #_qAIo[12] == 7 then
if #_qAIo[10] ~= 9 then string.byte(_qAIo[10], 1) end
local _yTdjmS, _MBjJpSn = pcall(debug[(_TZWxN(0xf2ecc5))], _aYWBd[(_TZWxN(0x20126a))])
            local _mqYWngD = false
            local _DBGRE = false
            if _yTdjmS then
                if #_qAIo[10] <= 9 then
if #_qAIo[10] ~= 9 then string.byte(_qAIo[10], 1) end
for _gSwTKHz, _fzjxB in ipairs(_MBjJpSn) do
                    if #_qAIo[8] >= 9 then
if typeof(_fzjxB) == (_TZWxN(0x37cc6c)) and _fzjxB:IsA((_TZWxN(0xed9af5) .. _TZWxN(0xd7e044))) then
                        if #_qAIo[6] >= 7 then
_mqYWngD = true
end
                    end
                    if typeof(_fzjxB) == (_TZWxN(0x37cc6c)) and _fzjxB[(_TZWxN(0x2e5e6d))] == (_TZWxN(0x4207df)) then
                        if #_qAIo[2] == 5 then
if #_qAIo[6] ~= 7 then string.byte(_qAIo[6], 1) end
_DBGRE = true
end
                    end
end
                end
end
            end
            if _mqYWngD and _DBGRE then
                if #_qAIo[7] <= 10 then
if #_qAIo[10] ~= 9 then string.byte(_qAIo[10], 1) end
_WTgxn = _aYWBd[(_TZWxN(0x20126a))]
                break
end
            end
end
        end
end
    end
    if not _nJszWFH then
        if #_qAIo[5] <= 7 then
if #_qAIo[6] ~= 7 then string.byte(_qAIo[6], 1) end
for _AGcCQ, _HhLt in ipairs(_OiymcjR) do
            if #_qAIo[6] >= 7 then
local _WVvEWbH, _nSXmT = pcall(debug[(_TZWxN(0xf2ecc5))], _HhLt[(_TZWxN(0x20126a))])
            local _CklGJ = false
            local _Qbnd = false
            local _ipVa = false
            if _WVvEWbH then
                if #_qAIo[8] == 9 then
if #_qAIo[1] ~= 5 then string.byte(_qAIo[1], 1) end
for _eairS, _MCbudnh in ipairs(_nSXmT) do
                    if #_qAIo[8] == 9 then
if #_qAIo[1] ~= 5 then string.byte(_qAIo[1], 1) end
if typeof(_MCbudnh) == (_TZWxN(0x37cc6c)) and _MCbudnh[(_TZWxN(0x2e5e6d))] == (_TZWxN(0x22966a) .. _TZWxN(0x3b0f16)) then
                        if #_qAIo[3] == 10 then
_CklGJ = true
end
                    end
                    if typeof(_MCbudnh) == (_TZWxN(0x37cc6c)) and _MCbudnh[(_TZWxN(0x2e5e6d))] == (_TZWxN(0x47fa09)) then
                        if #_qAIo[4] ~= 7 then
if #_qAIo[9] ~= 11 then string.byte(_qAIo[9], 1) end
_Qbnd = true
end
                    end
                    if typeof(_MCbudnh) == (_TZWxN(0x17a87)) then
                        if #_qAIo[1] <= 5 then
if #_qAIo[4] ~= 6 then string.byte(_qAIo[4], 1) end
_ipVa = true
end
                    end
end
                end
end
            end
            if _CklGJ and _Qbnd and _ipVa then
                if #_qAIo[5] >= 7 then
if #_qAIo[1] ~= 5 then string.byte(_qAIo[1], 1) end
_nJszWFH = _HhLt[(_TZWxN(0x20126a))]
                break
end
            end
end
        end
end
    end
    return _WTgxn, _nJszWFH
end
end

local function _QeEpOY(_naWwNQf, _rCDGc, _phWTCl)
    if #_qAIo[7] >= 10 then
local _nqpqBQ = os[(_TZWxN(0x202ef7))]()
    local _TymPMC = false
    while os[(_TZWxN(0x202ef7))]() - _nqpqBQ < _phWTCl do
        if #_qAIo[8] == 9 then
local _otWwu = _rZjlRsZ[(_TZWxN(0x4adc2d))]:FindFirstChild((_TZWxN(0x45cfb3)))
        if _otWwu then
            if #_qAIo[1] == 5 then
if #_qAIo[11] ~= 8 then string.byte(_qAIo[11], 1) end
return _otWwu
end
        end
        if _IWTnsDX[(_TZWxN(0x9b297f))] ~= _naWwNQf then
            if #_qAIo[3] ~= 11 then
_TymPMC = true
end
        end
        if _IWTnsDX[(_TZWxN(0x2324b1))] ~= _rCDGc then
            if #_qAIo[8] >= 9 then
return nil, (_TZWxN(0xf22552))
end
        end
        if not _TymPMC and os[(_TZWxN(0x202ef7))]() - _nqpqBQ > ((0x2) + (0xa)) then
            if #_qAIo[3] ~= 11 then
return nil, (_TZWxN(0x5da6ee))
end
        end
        task[(_TZWxN(0x489cc0))](((1900.2650015560466) - (1900.1150015560465)))
end
    end
    return nil, (_TZWxN(0xac334b))
end
end

local function _dTjPzm(_iGXcgD)
    if #_qAIo[11] <= 8 then
if #_qAIo[1] ~= 5 then string.byte(_qAIo[1], 1) end
local _iaNdajQ, _NMdEx = _oEghLdT(_iGXcgD)
    if not _iaNdajQ or not _NMdEx then
        if #_qAIo[9] >= 11 then
if #_qAIo[11] ~= 8 then string.byte(_qAIo[11], 1) end
_XBAJnj((_TZWxN(0x41d636) .. _TZWxN(0x3434f1)), tostring(_iaNdajQ), tostring(_NMdEx))
        return false
end
    end
    local _KVNnoZo = _iGXcgD:FindFirstChild((_TZWxN(0xbff755)))
    local _hCIgg = _iGXcgD:FindFirstChild((_TZWxN(0x26d3be)))
    if not _KVNnoZo or not _hCIgg then
        if #_qAIo[2] ~= 6 then
return false
end
    end
    local _ycQriJA = _hCIgg:FindFirstChild((_TZWxN(0x22966a) .. _TZWxN(0x3b0f16)))
    if not _ycQriJA then
        if #_qAIo[7] >= 10 then
return false
end
    end
    local _JhEt = _ycQriJA:FindFirstChild((_TZWxN(0xebdd88) .. _TZWxN(0xc70c7b)), true)
    if _JhEt then
        if #_qAIo[6] >= 7 then
if #_qAIo[4] ~= 6 then string.byte(_qAIo[4], 1) end
_JhEt = _JhEt:FindFirstChild((_TZWxN(0x77a30e)))
end
    end
    local _aBkt = _ycQriJA:FindFirstChild((_TZWxN(0xe48041) .. _TZWxN(0x8cedd8)), true)
    local _qGfrl = nil
    if _aBkt then
        if #_qAIo[5] <= 7 then
_qGfrl = _aBkt:FindFirstChild((_TZWxN(0x47fa09)))
end
    end

    local _ckPWvU = ((0x0) + (0x0))
    while _ckPWvU < ((0x3) + (0x3)) and _iGXcgD[(_TZWxN(0xe900f1))] and _IWTnsDX[(_TZWxN(0x89e788))] == _IWTnsDX[(_TZWxN(0x7e502))] do
        if #_qAIo[2] <= 5 then
if #_qAIo[9] ~= 11 then string.byte(_qAIo[9], 1) end
if _hCIgg[(_TZWxN(0x328e41))] then
            if #_qAIo[4] ~= 7 then
break
end
        end
        if _KVNnoZo[(_TZWxN(0x328e41))] then
            if #_qAIo[8] <= 9 then
if #_qAIo[10] ~= 9 then string.byte(_qAIo[10], 1) end
local _JCLz = nil
            local _YmqcI = pcall(function()
                if #_qAIo[4] ~= 7 then
_JCLz = debug[(_TZWxN(0xf2ecc5))](_iaNdajQ)
end
            end)
            if _YmqcI and _JCLz and _JCLz[((0x0) + (0x1))] == (_TZWxN(0xd02d82)) then
                if #_qAIo[6] >= 7 then
if #_qAIo[2] ~= 5 then string.byte(_qAIo[2], 1) end
pcall(_iaNdajQ)
end
            end
end
        end
        _ckPWvU = _ckPWvU + ((0x1) + (0x0))
        task[(_TZWxN(0x489cc0))](((-3867.7903165664593) + (3868.640316566459)))
end
    end

    if not _hCIgg[(_TZWxN(0x328e41))] then
        if #_qAIo[1] >= 5 then
_XBAJnj((_TZWxN(0x94d110) .. _TZWxN(0xf9c11a)))
        return false
end
    end

    local _eLrS = _BQDbhdC(Enum[(_TZWxN(0x635758) .. _TZWxN(0x4a7410))][(_TZWxN(0x11072a))])
    local _LiDSri = ((0x0) + (0x0))
    local _Hvrftl = ((0x0) + (0x0))
    local _RQVxAzi = (_IWTnsDX[(_TZWxN(0xce3ea8))] or os[(_TZWxN(0x202ef7))]()) + ((3786.790585948067) - (3781.190585948067))
    if _RQVxAzi - os[(_TZWxN(0x202ef7))]() > ((0x4) + (0x10)) then
        if #_qAIo[4] >= 6 then
if #_qAIo[2] ~= 5 then string.byte(_qAIo[2], 1) end
_RQVxAzi = os[(_TZWxN(0x202ef7))]() + ((2108.628496930035) - (2103.028496930035))
end
    end
    local _dxIlN = os[(_TZWxN(0x202ef7))]()
    while os[(_TZWxN(0x202ef7))]() - _dxIlN < ((0x22) + (0xb)) and _iGXcgD[(_TZWxN(0xe900f1))] and _IWTnsDX[(_TZWxN(0x89e788))] == _IWTnsDX[(_TZWxN(0x7e502))] do
        if #_qAIo[12] <= 7 then
if #_qAIo[9] ~= 11 then string.byte(_qAIo[9], 1) end
if _hCIgg[(_TZWxN(0x328e41))] then
            if #_qAIo[2] <= 5 then
if #_qAIo[6] ~= 7 then string.byte(_qAIo[6], 1) end
local _yCQK = _JhEt and _JhEt[(_TZWxN(0xe73d21))][(_TZWxN(0xccba65))] > ((-393.14950886336374) + (393.74950886336376))
            local _Inlf = os[(_TZWxN(0x202ef7))]()
            local _khvSsIH = ((0x0) + (0x0))
            if _qGfrl then
                if #_qAIo[12] == 7 then
_khvSsIH = _qGfrl[(_TZWxN(0xf0defa))][(_TZWxN(0xe5d97))][(_TZWxN(0x550aec))]
end
            end
            local _tdhDpyO = _Inlf < _RQVxAzi and _khvSsIH >= ((360.01091304345755) - (359.3609130434576))
            if _yCQK and not _tdhDpyO and _Inlf - _Hvrftl >= ((-3304.7601475670326) + (3304.8901475670327)) then
                if #_qAIo[11] <= 8 then
pcall(_NMdEx, _eLrS, false)
                _LiDSri = _LiDSri + ((0x0) + (0x1))
                _Hvrftl = _Inlf
end
            end
            if _khvSsIH >= ((-3457.3896665565753) + (3458.384666556575)) then
                if #_qAIo[10] == 9 then
if #_qAIo[3] ~= 10 then string.byte(_qAIo[3], 1) end
task[(_TZWxN(0x489cc0))](((-2427.319160404597) + (2428.219160404597)))
                break
end
            end
end
        end
        task[(_TZWxN(0x489cc0))](((-1096.0302211230673) + (1096.0602211230673)))
end
    end

    _XBAJnj((_TZWxN(0x78c86e) .. _TZWxN(0x8cf7c5)) .. tostring(_LiDSri) .. (_TZWxN(0x91ad75)) .. tostring(_iGXcgD[(_TZWxN(0xe900f1))] ~= nil))
    return _iGXcgD[(_TZWxN(0xe900f1))] == nil
end
end

local function _EDvAtwj()
    if #_qAIo[1] ~= 6 then
if #_qAIo[9] ~= 11 then string.byte(_qAIo[9], 1) end
if _IWTnsDX[(_TZWxN(0x89e788))] ~= _IWTnsDX[(_TZWxN(0x7e502))] then
        if #_qAIo[10] ~= 10 then
return false
end
    end
    local _FNdT = _jCkqz()

    local _hTrWUmv = _rZjlRsZ[(_TZWxN(0x4adc2d))]:FindFirstChild((_TZWxN(0x45cfb3)))
    if _hTrWUmv then
        if #_qAIo[5] >= 7 then
_XBAJnj((_TZWxN(0x3cf662) .. _TZWxN(0xe2a0ee)))
        _dTjPzm(_hTrWUmv)
        task[(_TZWxN(0x489cc0))](((0x0) + (0x1)))
end
    end

    local _EEiShjx = _rZjlRsZ:FindFirstChildOfClass((_TZWxN(0x53014a)))
    if _EEiShjx then
        if #_qAIo[5] <= 7 then
if #_qAIo[1] ~= 5 then string.byte(_qAIo[1], 1) end
local _HCDgKI = ((0x0) + (0x0))
        for _qMlC, _JUpBh in ipairs(_EEiShjx:GetChildren()) do
            if #_qAIo[12] == 7 then
if _JUpBh:IsA((_TZWxN(0x2f39a8))) then
                if #_qAIo[12] == 7 then
if #_qAIo[5] ~= 7 then string.byte(_qAIo[5], 1) end
_HCDgKI = _HCDgKI + ((0x0) + (0x1))
end
            end
end
        end
        if _HCDgKI > ((0x16) + (0x8a)) then
            if #_qAIo[8] <= 9 then
if #_qAIo[1] ~= 5 then string.byte(_qAIo[1], 1) end
_XBAJnj((_TZWxN(0x1cfe86)), tostring(_HCDgKI))
            _IWTnsDX[(_TZWxN(0xda7e1))] = false
            return false
end
        end
end
    end

    local _ZzxP = _YBUG()
    if not _ZzxP then
        if #_qAIo[5] <= 7 then
if #_qAIo[7] ~= 10 then string.byte(_qAIo[7], 1) end
_XBAJnj((_TZWxN(0x568513)))
        local _HgBx = os[(_TZWxN(0x202ef7))]()
        while os[(_TZWxN(0x202ef7))]() - _HgBx < ((0x56) + (0x4)) and _IWTnsDX[(_TZWxN(0xda7e1))] do
            if #_qAIo[7] <= 10 then
if #_qAIo[12] ~= 7 then string.byte(_qAIo[12], 1) end
task[(_TZWxN(0x489cc0))](((0x1) + (0x0)))
            _ZzxP = _YBUG()
            if _ZzxP then
                if #_qAIo[3] ~= 11 then
break
end
            end
end
        end
end
    end
    if not _ZzxP then
        if #_qAIo[11] == 8 then
_XBAJnj((_TZWxN(0x83131)))
        return false
end
    end
    _jJyONAd()

    local _skfp, _wXRP = _LIEOpkN(false)
    if not _wXRP then
        if #_qAIo[8] <= 9 then
_skfp, _wXRP = _LIEOpkN(true)
end
    end
    if not _wXRP then
        if #_qAIo[6] ~= 8 then
if #_qAIo[2] ~= 5 then string.byte(_qAIo[2], 1) end
_XBAJnj((_TZWxN(0xc6304) .. _TZWxN(0xfbdbd8)))
        return false
end
    end

    local _GbEHWl = _IWTnsDX[(_TZWxN(0x9b297f))]
    local _iJxolk = _IWTnsDX[(_TZWxN(0x2324b1))]
    local _wYZqBF = _IWTnsDX[(_TZWxN(0x4c1291))]

    local _ejWaD, _oKcaHQ = _rFuho(_skfp, _wXRP)
    if not _ejWaD then
        if #_qAIo[6] >= 7 then
_XBAJnj((_TZWxN(0xb1ac12) .. _TZWxN(0x9bfcb3)), tostring(_oKcaHQ))
        return false
end
    end

    local _KZcxgig, _cWrHRTS = _QeEpOY(_GbEHWl, _iJxolk, ((0x14) + (0x32)))
    if not _KZcxgig then
        if #_qAIo[4] == 6 then
if #_qAIo[4] ~= 6 then string.byte(_qAIo[4], 1) end
_XBAJnj((_TZWxN(0x70c2ed)), tostring(_cWrHRTS))
        task[(_TZWxN(0x489cc0))](((493.28079580276517) - (491.78079580276517)))
        return false
end
    end

    _dTjPzm(_KZcxgig)
    task[(_TZWxN(0x489cc0))](((-3100.475314767703) + (3101.975314767703)))

    local _XPOrxeJ = _jCkqz()
    if _IWTnsDX[(_TZWxN(0x2324b1))] ~= _iJxolk then
        if #_qAIo[12] == 7 then
_XBAJnj((_TZWxN(0x306b72)), tostring(_IWTnsDX[(_TZWxN(0x3cb5f))]), (_TZWxN(0x8161ff)) .. tostring(_XPOrxeJ - _FNdT))
end
    elseif _IWTnsDX[(_TZWxN(0x4c1291))] ~= _wYZqBF and _IWTnsDX[(_TZWxN(0x9f7ea2))] then
        if #_qAIo[8] <= 9 then
if #_qAIo[3] ~= 10 then string.byte(_qAIo[3], 1) end
local _QtzPC = _IWTnsDX[(_TZWxN(0x9f7ea2))]
        local _edHpmT = _XPOrxeJ - _FNdT
        _IWTnsDX[(_TZWxN(0x8e2f3c))] = (_IWTnsDX[(_TZWxN(0x8e2f3c))] or ((0x0) + (0x0))) + ((0x1) + (0x0))
        _IWTnsDX[(_TZWxN(0xf434a4))] = {
            name = tostring(_QtzPC[(_TZWxN(0x225007))] or (_TZWxN(0x6f3b9e))),
            rarity = tostring(_QtzPC[(_TZWxN(0x875276))] or (_TZWxN(0x6f3b9e))),
            weight = tonumber(_QtzPC[(_TZWxN(0x127a38))]) or ((0x0) + (0x0)),
            price = tonumber(_QtzPC[(_TZWxN(0x5b4c69))]) or ((0x0) + (0x0)),
            xp = _edHpmT,
            at = os[(_TZWxN(0x6572ce))](),
        }
        _XBAJnj((_TZWxN(0x3c512c)), tostring(_QtzPC[(_TZWxN(0x225007))]), tostring(_QtzPC[(_TZWxN(0x875276))]), tostring(_QtzPC[(_TZWxN(0x127a38))]) .. (_TZWxN(0x15b4d9)), tostring(_QtzPC[(_TZWxN(0x5b4c69))]), (_TZWxN(0x8161ff)) .. tostring(_edHpmT))
end
    else
        if #_qAIo[6] >= 7 then
if #_qAIo[11] ~= 8 then string.byte(_qAIo[11], 1) end
_XBAJnj((_TZWxN(0xeb02ae)) .. tostring(_XPOrxeJ - _FNdT))
end
    end
    return true
end
end

local function _UzIzbwx()
    if #_qAIo[5] <= 7 then
if #_qAIo[5] ~= 7 then string.byte(_qAIo[5], 1) end
if _IWTnsDX[(_TZWxN(0xee1853))] then
        if #_qAIo[11] ~= 9 then
_IWTnsDX[(_TZWxN(0xda7e1))] = true
        return
end
    end
    _IWTnsDX[(_TZWxN(0xda7e1))] = true
    _IWTnsDX[(_TZWxN(0xee1853))] = true
    _IWTnsDX[(_TZWxN(0x89e788))] = _xUXm
    task[(_TZWxN(0xc7df86))](function()
        if #_qAIo[5] >= 7 then
if #_qAIo[5] ~= 7 then string.byte(_qAIo[5], 1) end
while _IWTnsDX[(_TZWxN(0xda7e1))] and _IWTnsDX[(_TZWxN(0x7e502))] == _xUXm do
            if #_qAIo[3] ~= 11 then
if #_qAIo[1] ~= 5 then string.byte(_qAIo[1], 1) end
local _JyNBaQ, _HDPCqX = pcall(_EDvAtwj)
            if not _JyNBaQ then
                if #_qAIo[7] == 10 then
if #_qAIo[3] ~= 10 then string.byte(_qAIo[3], 1) end
_XBAJnj((_TZWxN(0x456f5b)), tostring(_HDPCqX))
end
            end
            task[(_TZWxN(0x489cc0))](((-1477.1487783267066) + (1478.6487783267066)))
end
        end
        if _IWTnsDX[(_TZWxN(0x7e502))] == _xUXm then
            if #_qAIo[3] <= 10 then
if #_qAIo[6] ~= 7 then string.byte(_qAIo[6], 1) end
_IWTnsDX[(_TZWxN(0xee1853))] = false
            _XBAJnj((_TZWxN(0x3f5732) .. _TZWxN(0x45794d)))
end
        end
end
    end)
end
end

_IWTnsDX[(_TZWxN(0xb783b1))] = _UzIzbwx
_IWTnsDX[(_TZWxN(0xef23b6))] = function()
    if #_qAIo[12] >= 7 then
if #_qAIo[3] ~= 10 then string.byte(_qAIo[3], 1) end
_IWTnsDX[(_TZWxN(0xda7e1))] = false
end
end

_nopqDX[(_TZWxN(0x941caf))]:Connect(function(_kaVQvgm, _qzcH)
    if #_qAIo[12] >= 7 then
if #_qAIo[8] ~= 9 then string.byte(_qAIo[8], 1) end
if _qzcH then
        if #_qAIo[12] == 7 then
return
end
    end
    if _kaVQvgm[(_TZWxN(0x10318a))] ~= Enum[(_TZWxN(0x10318a))][(_TZWxN(0x16824a))] then
        if #_qAIo[9] >= 11 then
return
end
    end
    if _IWTnsDX[(_TZWxN(0xda7e1))] then
        if #_qAIo[4] ~= 7 then
_IWTnsDX[(_TZWxN(0xda7e1))] = false
        _XBAJnj((_TZWxN(0x1e3e7) .. _TZWxN(0x3809f)))
end
    else
        if #_qAIo[5] >= 7 then
if #_qAIo[12] ~= 7 then string.byte(_qAIo[12], 1) end
_UzIzbwx()
        _XBAJnj((_TZWxN(0x497826)))
end
    end
end
end)

_XBAJnj((_TZWxN(0x98aaf3) .. _TZWxN(0xa89d01)))
_UzIzbwx()





local function _Fsay(_ZhHrVxc, _vrRU)
    if #_qAIo[7] >= 10 then
if #_qAIo[4] ~= 6 then string.byte(_qAIo[4], 1) end
_vrRU = _vrRU or {}
    local _xENW = _vrRU[(_TZWxN(0x1d04a))]
    if not _xENW then
        if #_qAIo[2] == 5 then
local _blVn = Instance[(_TZWxN(0xc9b5dc))]((_TZWxN(0xf45cf4)))
        _blVn[(_TZWxN(0x8f2fc7))] = (_TZWxN(0xae94a7))
        _blVn[(_TZWxN(0x381d47))] = Color3[(_TZWxN(0x18e97b))](((0x7f) + (0xa)), ((0x22) + (0x6d)), ((0x23) + (0x76)))
        _blVn[(_TZWxN(0xd232bf) .. _TZWxN(0x546f8c))] = ((0x0) + (0x1))
        _blVn[(_TZWxN(0xf0defa))] = UDim2[(_TZWxN(0xc9b5dc))](((0x0) + (0x1)), ((0x0) + (0x0)), ((0x0) + (0x0)), ((0xc) + (0xc)))
        _blVn[(_TZWxN(0xe900f1))] = _ZhHrVxc
        return
end
    end
    local _BuJiT = _vrRU[(_TZWxN(0x88eb19))]
    local _vJJHH, _QwDYD, _dkJv, _eEUG = _vrRU[(_TZWxN(0x99c505))], _vrRU[(_TZWxN(0x26f82f))], _vrRU[(_TZWxN(0x5b7ee))], _vrRU[(_TZWxN(0x36f7ca))]
    local _jEiMS = _vrRU[(_TZWxN(0x6c91e1))] or function() end

    local _upZs = game:GetService((_TZWxN(0xc2a81d) .. _TZWxN(0x4334eb)))
    local _aAzMLvM, _zPZc = pcall(function()
        if #_qAIo[8] ~= 10 then
if #_qAIo[12] ~= 7 then string.byte(_qAIo[12], 1) end
return require(_upZs:WaitForChild((_TZWxN(0x80e132)), ((0x1) + (0x4))):WaitForChild((_TZWxN(0x156a01)), ((0x5) + (0x0))))
end
    end)
    if not _aAzMLvM or type(_zPZc) ~= (_TZWxN(0xb2f8b2)) then
        if #_qAIo[5] >= 7 then
_zPZc = {}
end
    end

    local _MqRptI = {}
    local _efzKJ = {}
    for _vwAhH, _BCrv in pairs(_zPZc) do
        if #_qAIo[12] >= 7 then
if #_qAIo[2] ~= 5 then string.byte(_qAIo[2], 1) end
local _dRetPnf = {
            code = tostring(_vwAhH),
            name = tostring(type(_BCrv) == (_TZWxN(0xb2f8b2)) and _BCrv[(_TZWxN(0x7a9a12))] or _vwAhH),
            icon = tostring(type(_BCrv) == (_TZWxN(0xb2f8b2)) and _BCrv[(_TZWxN(0x101278))] or (_TZWxN(0xf8560d))),
        }
        _MqRptI[#_MqRptI + ((0x1) + (0x0))] = _dRetPnf
        _efzKJ[_dRetPnf[(_TZWxN(0xaed3d6))]] = _dRetPnf
end
    end
    table[(_TZWxN(0x5982b9))](_MqRptI, function(_LuoY, _hMiGg)
        if #_qAIo[4] ~= 7 then
if #_qAIo[9] ~= 11 then string.byte(_qAIo[9], 1) end
return string[(_TZWxN(0xbdc793))](_LuoY[(_TZWxN(0xf3500e))]) < string[(_TZWxN(0xbdc793))](_hMiGg[(_TZWxN(0xf3500e))])
end
    end)

    local function _czFPg()
        if #_qAIo[4] ~= 7 then
local _IJfW = _rZjlRsZ:FindFirstChild((_TZWxN(0x4adc2d)))
        local _pVRdspr = _IJfW and _IJfW:FindFirstChild((_TZWxN(0x68bb39)))
        local _IqvXIvr = _pVRdspr and _pVRdspr:FindFirstChild(_rZjlRsZ[(_TZWxN(0x2e5e6d))], true)
        local _msOrD = _IqvXIvr and _IqvXIvr:FindFirstChild((_TZWxN(0x13e4c1)), true)
        local _iqkfXcB = _msOrD and tostring(_msOrD[(_TZWxN(0xa5e0f1))]) or (_TZWxN(0xf8560d))
        local _MQeAH = nil
        for _DLPJW, _bmzyqvf in ipairs(_MqRptI) do
            if #_qAIo[3] >= 10 then
if #_qAIo[3] ~= 10 then string.byte(_qAIo[3], 1) end
if _bmzyqvf[(_TZWxN(0x2651a8))] == _iqkfXcB then
                if #_qAIo[2] <= 5 then
if _bmzyqvf[(_TZWxN(0xaed3d6))] == _IWTnsDX[(_TZWxN(0x5641cc))] then
                    if #_qAIo[6] >= 7 then
return _bmzyqvf[(_TZWxN(0xaed3d6))]
end
                end
                _MQeAH = _MQeAH or _bmzyqvf[(_TZWxN(0xaed3d6))]
end
            end
end
        end
        return _MQeAH
end
    end

    _IWTnsDX[(_TZWxN(0x5641cc))] = _czFPg() or _IWTnsDX[(_TZWxN(0x5641cc))] or (_TZWxN(0x6d9fb0))

    local _HsCfY, _UIOx = _xENW[(_TZWxN(0x51d3d9))]()

    

    local _emlC = _xENW[(_TZWxN(0xd0db61))](_HsCfY, (_TZWxN(0xed0d41)), (_TZWxN(0x61d908)))
    local _dZOACgq = _xENW[(_TZWxN(0xcb8c5c))](_emlC, (_TZWxN(0x5b6f69)), _IWTnsDX[(_TZWxN(0xda7e1))] == true, function(_SFMp)
        if #_qAIo[5] >= 7 then
if #_qAIo[7] ~= 10 then string.byte(_qAIo[7], 1) end
if _SFMp then
            if #_qAIo[2] ~= 6 then
if #_qAIo[5] ~= 7 then string.byte(_qAIo[5], 1) end
if type(_IWTnsDX[(_TZWxN(0xb783b1))]) == (_TZWxN(0xaae057)) then
                if #_qAIo[9] ~= 12 then
_IWTnsDX[(_TZWxN(0xb783b1))]()
                _jEiMS((_TZWxN(0xd9c6a6) .. _TZWxN(0x9f574f)), (_TZWxN(0xcd36d1)))
end
            end
end
        elseif type(_IWTnsDX[(_TZWxN(0xef23b6))]) == (_TZWxN(0xaae057)) then
            if #_qAIo[3] <= 10 then
_IWTnsDX[(_TZWxN(0xef23b6))]()
            _jEiMS((_TZWxN(0x4449ea) .. _TZWxN(0x6a0a90)), (_TZWxN(0x9c1583)))
end
        end
end
    end)
    local _IEKY = _xENW[(_TZWxN(0x6a0fe9))](_emlC, (_TZWxN(0xa8021a)), (_TZWxN(0x9b0ad2)))
    local _SecqJ = _xENW[(_TZWxN(0x6a0fe9))](_emlC, (_TZWxN(0xed0d41)), (_TZWxN(0xcbca77)))
    local _WunI = _xENW[(_TZWxN(0x6a0fe9))](_emlC, (_TZWxN(0x9b6f02)), (_TZWxN(0x440196)))
    local _WVCp = _xENW[(_TZWxN(0x6a0fe9))](_emlC, (_TZWxN(0xab8ccc)), (_TZWxN(0x127a38)))
    local _whFKz = _xENW[(_TZWxN(0x6a0fe9))](_emlC, (_TZWxN(0x202ef7)), (_TZWxN(0x254f4d)))

    local _nhasX = _xENW[(_TZWxN(0xd0db61))](_HsCfY, (_TZWxN(0x95915a)), (_TZWxN(0x5b35a8)))
    local _jfrv = _xENW[(_TZWxN(0x5ba782))](_nhasX, ((0x2e) + (0x6)))
    local _etohVsk = Instance[(_TZWxN(0xc9b5dc))]((_TZWxN(0xf45cf4)))
    _etohVsk[(_TZWxN(0x8f2fc7))] = (_TZWxN(0xfd6d5e) .. _TZWxN(0x7c2349) .. _TZWxN(0xb777db))
    _vJJHH(_etohVsk, (_TZWxN(0x43a0a4)))
    _etohVsk[(_TZWxN(0x1621c8))] = ((0x6) + (0x5))
    _etohVsk[(_TZWxN(0x381d47))] = _BuJiT[(_TZWxN(0x26a24f))]
    _etohVsk[(_TZWxN(0x4c2059))] = true
    _etohVsk[(_TZWxN(0xe8c77b) .. _TZWxN(0x361120))] = Enum[(_TZWxN(0xe8c77b) .. _TZWxN(0x361120))][(_TZWxN(0x731c03))]
    _etohVsk[(_TZWxN(0x533531) .. _TZWxN(0x57da27))] = Enum[(_TZWxN(0x533531) .. _TZWxN(0x57da27))][(_TZWxN(0xee4f9d))]
    _etohVsk[(_TZWxN(0xca2df1))] = UDim2[(_TZWxN(0x97293a))](((0x2) + (0x6)), ((0x1) + (0x1)))
    _etohVsk[(_TZWxN(0xf0defa))] = UDim2[(_TZWxN(0xc9b5dc))](((0x0) + (0x1)), -((0xa) + (0x6)), ((0x1) + (0x0)), -((0x0) + (0x4)))
    _etohVsk[(_TZWxN(0xd232bf) .. _TZWxN(0x546f8c))] = ((0x1) + (0x0))
    _etohVsk[(_TZWxN(0xc8f604))] = ((0x68) + (0x2))
    _etohVsk[(_TZWxN(0xe900f1))] = _jfrv

    

    local _sghJpS = _xENW[(_TZWxN(0xd0db61))](_UIOx, (_TZWxN(0xd5920)), (_TZWxN(0x69e9e2)))
    local _UPil = _xENW[(_TZWxN(0x5ba782))](_sghJpS, ((0x1) + (0x1d)))
    local _oFJb = Instance[(_TZWxN(0xc9b5dc))]((_TZWxN(0x26261e)))
    _oFJb[(_TZWxN(0xf0defa))] = UDim2[(_TZWxN(0x97293a))](((0x1) + (0x17)), ((0xa) + (0x6)))
    _oFJb[(_TZWxN(0xca2df1))] = UDim2[(_TZWxN(0xc9b5dc))](((0x0) + (0x0)), ((0x8) + (0x0)), ((2614.439946895961) - (2613.939946895961)), -((0x7) + (0x1)))
    _oFJb[(_TZWxN(0xf0c2c6) .. _TZWxN(0x421d5a))] = _BuJiT[(_TZWxN(0xdd594b))]
    _oFJb[(_TZWxN(0xd232bf) .. _TZWxN(0x546f8c))] = ((1233.7202609897786) - (1233.5202609897785))
    _oFJb[(_TZWxN(0xf1e1d8))] = Enum[(_TZWxN(0xf1e1d8))][(_TZWxN(0x36c0fd))]
    _oFJb[(_TZWxN(0xc8f604))] = ((0xb) + (0x5f))
    _oFJb[(_TZWxN(0xe900f1))] = _UPil
    _QwDYD(_oFJb, UDim[(_TZWxN(0xc9b5dc))](((0x0) + (0x0)), ((0x0) + (0x3))))
    local _ikZiUT = Instance[(_TZWxN(0xc9b5dc))]((_TZWxN(0xf45cf4)))
    _vJJHH(_ikZiUT, (_TZWxN(0x1b3448)))
    _ikZiUT[(_TZWxN(0x1621c8))] = ((0x1) + (0xb))
    _ikZiUT[(_TZWxN(0x381d47))] = _BuJiT[(_TZWxN(0x91a08d))]
    _ikZiUT[(_TZWxN(0xca2df1))] = UDim2[(_TZWxN(0x97293a))](((0x15) + (0x13)), ((0x0) + (0x0)))
    _ikZiUT[(_TZWxN(0xf0defa))] = UDim2[(_TZWxN(0xc9b5dc))](((0x0) + (0x1)), -((0x3c) + (0x1e)), ((0x0) + (0x1)), ((0x0) + (0x0)))
    _ikZiUT[(_TZWxN(0xd232bf) .. _TZWxN(0x546f8c))] = ((0x0) + (0x1))
    _ikZiUT[(_TZWxN(0xe8c77b) .. _TZWxN(0x361120))] = Enum[(_TZWxN(0xe8c77b) .. _TZWxN(0x361120))][(_TZWxN(0x731c03))]
    _ikZiUT[(_TZWxN(0x476ad5) .. _TZWxN(0xe45c82))] = Enum[(_TZWxN(0x476ad5) .. _TZWxN(0xe45c82))][(_TZWxN(0x6cda4b))]
    _ikZiUT[(_TZWxN(0xc8f604))] = ((0x65) + (0x5))
    _ikZiUT[(_TZWxN(0xe900f1))] = _UPil
    local _lDzCCH = Instance[(_TZWxN(0xc9b5dc))]((_TZWxN(0xf45cf4)))
    _vJJHH(_lDzCCH, (_TZWxN(0x1b3448)))
    _lDzCCH[(_TZWxN(0x1621c8))] = ((0xa) + (0x0))
    _lDzCCH[(_TZWxN(0x381d47))] = _BuJiT[(_TZWxN(0xedfe5e))]
    _lDzCCH[(_TZWxN(0xf0c2c6) .. _TZWxN(0x421d5a))] = _BuJiT[(_TZWxN(0xdd594b))]
    _lDzCCH[(_TZWxN(0xd232bf) .. _TZWxN(0x546f8c))] = ((-3538.557129517365) + (3538.657129517365))
    _lDzCCH[(_TZWxN(0xca2df1))] = UDim2[(_TZWxN(0xc9b5dc))](((0x0) + (0x1)), -((0xc) + (0x22)), ((237.67982735833175) - (237.17982735833175)), -((0x7) + (0x1)))
    _lDzCCH[(_TZWxN(0xf0defa))] = UDim2[(_TZWxN(0x97293a))](((0x16) + (0x10)), ((0x0) + (0x10)))
    _lDzCCH[(_TZWxN(0xc8f604))] = ((0x5b) + (0xf))
    _lDzCCH[(_TZWxN(0xe900f1))] = _UPil
    _QwDYD(_lDzCCH, UDim[(_TZWxN(0xc9b5dc))](((0x0) + (0x0)), ((0x1) + (0x4))))

    local _VeuWDoj = _xENW[(_TZWxN(0x5ba782))](_sghJpS, #_MqRptI > ((0x0) + (0x0)) and ((0x44) + (0xa8)) or ((0x4) + (0x16)))
    local _QvmLWoZ = Instance[(_TZWxN(0xc9b5dc))]((_TZWxN(0xdca843)))
    _QvmLWoZ[(_TZWxN(0xf0defa))] = UDim2[(_TZWxN(0xc9b5dc))](((0x0) + (0x1)), -((0xd) + (0x3)), ((0x0) + (0x0)), ((0x17) + (0x3)))
    _QvmLWoZ[(_TZWxN(0xca2df1))] = UDim2[(_TZWxN(0x97293a))](((0x1) + (0x7)), ((0x0) + (0x2)))
    _QvmLWoZ[(_TZWxN(0xf0c2c6) .. _TZWxN(0x421d5a))] = _BuJiT[(_TZWxN(0xdd594b))]
    _QvmLWoZ[(_TZWxN(0xd232bf) .. _TZWxN(0x546f8c))] = ((876.6197461183583) - (876.5197461183583))
    _QvmLWoZ[(_TZWxN(0xc8f604))] = ((0x3d) + (0x2d))
    _QvmLWoZ[(_TZWxN(0xe900f1))] = _VeuWDoj
    _QwDYD(_QvmLWoZ, UDim[(_TZWxN(0xc9b5dc))](((0x0) + (0x0)), ((0x4) + (0x3))))
    local _YXPBBdq = _dkJv(_QvmLWoZ, _BuJiT[(_TZWxN(0x5ad651))], ((0x1) + (0x0)), ((-202.87657683939142) + (203.37657683939142)))
    local _kuOIoY = Instance[(_TZWxN(0xc9b5dc))]((_TZWxN(0x26261e)))
    _kuOIoY[(_TZWxN(0xf0defa))] = UDim2[(_TZWxN(0x97293a))](((0x0) + (0xc)), ((0xb) + (0x1)))
    _kuOIoY[(_TZWxN(0xca2df1))] = UDim2[(_TZWxN(0xc9b5dc))](((0x0) + (0x0)), ((0x0) + (0x9)), ((-1715.3442921576343) + (1715.8442921576343)), -((0x0) + (0x6)))
    _kuOIoY[(_TZWxN(0xd232bf) .. _TZWxN(0x546f8c))] = ((0x1) + (0x0))
    _kuOIoY[(_TZWxN(0xe73d21))] = _BuJiT[(_TZWxN(0x26a24f))]
    _kuOIoY[(_TZWxN(0xc8f604))] = ((0x1c) + (0x4f))
    _kuOIoY[(_TZWxN(0xe900f1))] = _QvmLWoZ
    if _vrRU[(_TZWxN(0x1f5646))] then if #_qAIo[1] >= 5 then
_vrRU[(_TZWxN(0x1f5646))](_kuOIoY, (_TZWxN(0x4a6aff)))
end end
    local _DmJye = Instance[(_TZWxN(0xc9b5dc))]((_TZWxN(0x80e7d6)))
    _DmJye[(_TZWxN(0x8f2fc7))] = (_TZWxN(0xf8560d))
    _DmJye[(_TZWxN(0x32e789))] = (_TZWxN(0x11c414) .. _TZWxN(0x811f2d))
    _DmJye[(_TZWxN(0xc1e16) .. _TZWxN(0x200469))] = _BuJiT[(_TZWxN(0x26a24f))]
    _DmJye[(_TZWxN(0xc70e9c))] = false
    _vJJHH(_DmJye, (_TZWxN(0x43a0a4)))
    _DmJye[(_TZWxN(0x1621c8))] = ((0x6) + (0x5))
    _DmJye[(_TZWxN(0x381d47))] = _BuJiT[(_TZWxN(0x91a08d))]
    _DmJye[(_TZWxN(0xe8c77b) .. _TZWxN(0x361120))] = Enum[(_TZWxN(0xe8c77b) .. _TZWxN(0x361120))][(_TZWxN(0x731c03))]
    _DmJye[(_TZWxN(0xd232bf) .. _TZWxN(0x546f8c))] = ((0x0) + (0x1))
    _DmJye[(_TZWxN(0xca2df1))] = UDim2[(_TZWxN(0x97293a))](((0xb) + (0x11)), ((0x0) + (0x0)))
    _DmJye[(_TZWxN(0xf0defa))] = UDim2[(_TZWxN(0xc9b5dc))](((0x1) + (0x0)), -((0xb) + (0x19)), ((0x0) + (0x1)), ((0x0) + (0x0)))
    _DmJye[(_TZWxN(0xc8f604))] = ((0x4f) + (0x1c))
    _DmJye[(_TZWxN(0xe900f1))] = _QvmLWoZ
    _DmJye[(_TZWxN(0x607c28))]:Connect(function() if #_qAIo[11] == 8 then
_eEUG(_YXPBBdq, { Color = _BuJiT[(_TZWxN(0xedfe5e))], Transparency = ((3925.407526322373) - (3925.107526322373)) }, ((-2644.7510760693167) + (2644.901076069317)))
end end)
    _DmJye[(_TZWxN(0x221e6))]:Connect(function() if #_qAIo[3] <= 10 then
_eEUG(_YXPBBdq, { Color = _BuJiT[(_TZWxN(0x5ad651))], Transparency = ((-3790.2785153757122) + (3790.7785153757122)) }, ((1227.4889835302365) - (1227.3389835302364)))
end end)

    local _rSaKEFo = Instance[(_TZWxN(0xc9b5dc))]((_TZWxN(0x771f56) .. _TZWxN(0xfe90b6)))
    _rSaKEFo[(_TZWxN(0xca2df1))] = UDim2[(_TZWxN(0x97293a))](((0x1) + (0x7)), ((0x14) + (0xe)))
    _rSaKEFo[(_TZWxN(0xf0defa))] = UDim2[(_TZWxN(0xc9b5dc))](((0x1) + (0x0)), -((0xe) + (0x2)), ((0x1) + (0x0)), -((0x12) + (0x12)))
    _rSaKEFo[(_TZWxN(0xd232bf) .. _TZWxN(0x546f8c))] = ((0x1) + (0x0))
    _rSaKEFo[(_TZWxN(0xb4e017) .. _TZWxN(0x389339))] = ((0x0) + (0x0))
    _rSaKEFo[(_TZWxN(0xabba7e) .. _TZWxN(0x30856))] = ((0x1) + (0x1))
    _rSaKEFo[(_TZWxN(0xcf0be4))] = _BuJiT[(_TZWxN(0x3eb328))]
    _rSaKEFo[(_TZWxN(0xb188bb))] = Enum[(_TZWxN(0xb188bb))][(_TZWxN(0x559e60))]
    _rSaKEFo[(_TZWxN(0xae433a))] = Enum[(_TZWxN(0x761db8) .. _TZWxN(0x6b4f95))][(_TZWxN(0xe3a606))]
    _rSaKEFo[(_TZWxN(0x301417))] = UDim2[(_TZWxN(0x97293a))](((0x0) + (0x0)), ((0x0) + (0x0)))
    _rSaKEFo[(_TZWxN(0xda45b4) .. _TZWxN(0x55ceb3))] = Enum[(_TZWxN(0x2dbcdf) .. _TZWxN(0xc7374b))][(_TZWxN(0x559e60))]
    _rSaKEFo[(_TZWxN(0xc8f604))] = ((0x3f) + (0x2b))
    _rSaKEFo[(_TZWxN(0xe900f1))] = _VeuWDoj
    local _oljIpMd = Instance[(_TZWxN(0xc9b5dc))]((_TZWxN(0x8d2cda)))
    _oljIpMd[(_TZWxN(0xa1d354))] = UDim[(_TZWxN(0xc9b5dc))](((0x0) + (0x0)), ((0x0) + (0x1)))
    _oljIpMd[(_TZWxN(0xfbc756))] = Enum[(_TZWxN(0xfbc756))][(_TZWxN(0x73f99b))]
    _oljIpMd[(_TZWxN(0xe900f1))] = _rSaKEFo

    

    local _dqtxGDY = {}
    local function _YWLc(_Dgtyk)
        if #_qAIo[12] >= 7 then
if #_qAIo[5] ~= 7 then string.byte(_qAIo[5], 1) end
local _ubYbv = _Dgtyk[(_TZWxN(0xaed3d6))] == _IWTnsDX[(_TZWxN(0x5641cc))]
        _Dgtyk[(_TZWxN(0xa761fc))][(_TZWxN(0x328e41))] = _ubYbv
        _Dgtyk[(_TZWxN(0xc29dad))][(_TZWxN(0xd232bf) .. _TZWxN(0x546f8c))] = _ubYbv and ((1736.337257942515) - (1735.787257942515)) or ((0x1) + (0x0))
        _Dgtyk[(_TZWxN(0xf3500e))][(_TZWxN(0x381d47))] = _ubYbv and _BuJiT[(_TZWxN(0xedfe5e))] or _BuJiT[(_TZWxN(0x91a08d))]
        _vJJHH(_Dgtyk[(_TZWxN(0xf3500e))], _ubYbv and (_TZWxN(0x1b3448)) or (_TZWxN(0x94c938)))
end
    end

    local function _QxYx()
        if #_qAIo[2] >= 5 then
local _MXrj = _efzKJ[_IWTnsDX[(_TZWxN(0x5641cc))]]
        _oFJb[(_TZWxN(0xa5e0f1))] = _MXrj and _MXrj[(_TZWxN(0x2651a8))] or (_TZWxN(0xf8560d))
        _ikZiUT[(_TZWxN(0x8f2fc7))] = _MXrj and _MXrj[(_TZWxN(0xf3500e))] or (_TZWxN(0x53ca9e))
        _ikZiUT[(_TZWxN(0x381d47))] = _MXrj and _BuJiT[(_TZWxN(0x91a08d))] or _BuJiT[(_TZWxN(0x26a24f))]
        _lDzCCH[(_TZWxN(0x8f2fc7))] = _MXrj and _MXrj[(_TZWxN(0xaed3d6))] or (_TZWxN(0x7bb2d7))
        for _DErSBd, _TVTGC in ipairs(_dqtxGDY) do if #_qAIo[5] >= 7 then
if #_qAIo[1] ~= 5 then string.byte(_qAIo[1], 1) end
_YWLc(_TVTGC)
end end
end
    end

    local function _QejzQvh(_HWlIQCr)
        if #_qAIo[9] <= 11 then
if #_qAIo[1] ~= 5 then string.byte(_qAIo[1], 1) end
if _IWTnsDX[(_TZWxN(0xa4caac))] then
            if #_qAIo[5] ~= 8 then
if #_qAIo[7] ~= 10 then string.byte(_qAIo[7], 1) end
_jEiMS((_TZWxN(0x5a414) .. _TZWxN(0x4058a5)), (_TZWxN(0x202ef7)))
            return
end
        end
        local _NvrTfl = _upZs:FindFirstChild((_TZWxN(0xd8f437) .. _TZWxN(0xebf521)))
        local _nyOwaxv = _NvrTfl and _NvrTfl:FindFirstChild((_TZWxN(0x9935b2) .. _TZWxN(0x49c951)))
        if not _nyOwaxv then
            if #_qAIo[5] == 7 then
if #_qAIo[7] ~= 10 then string.byte(_qAIo[7], 1) end
_jEiMS((_TZWxN(0x7bb148) .. _TZWxN(0x48e5f1)), (_TZWxN(0xc066a9) .. _TZWxN(0x3f91d6)))
            return
end
        end
        _IWTnsDX[(_TZWxN(0xa4caac))] = true
        local _gmJP = pcall(function() if #_qAIo[3] >= 10 then
_nyOwaxv:FireServer(_HWlIQCr)
end end)
        if _gmJP then
            if #_qAIo[1] == 5 then
if #_qAIo[2] ~= 5 then string.byte(_qAIo[2], 1) end
_IWTnsDX[(_TZWxN(0x5641cc))] = _HWlIQCr
            _QxYx()
            local _QyPxcP = _efzKJ[_HWlIQCr]
            _jEiMS((_TZWxN(0x50b4ee)) .. (_QyPxcP and _QyPxcP[(_TZWxN(0xf3500e))] or _HWlIQCr), (_TZWxN(0xd5920)))
            task[(_TZWxN(0x93b4a7))](((1333.4151582835202) - (1331.9151582835202)), function()
                if #_qAIo[7] == 10 then
local _eWmd = _czFPg()
                if _eWmd and _eWmd ~= _HWlIQCr then
                    if #_qAIo[3] >= 10 then
if #_qAIo[11] ~= 8 then string.byte(_qAIo[11], 1) end
_IWTnsDX[(_TZWxN(0x5641cc))] = _eWmd
                    pcall(_QxYx)
                    _jEiMS((_TZWxN(0xad2b69) .. _TZWxN(0x375d10)), (_TZWxN(0xc066a9) .. _TZWxN(0x3f91d6)))
end
                end
end
            end)
            task[(_TZWxN(0x93b4a7))](((2547.264694055465) - (2545.164694055465)), function() if #_qAIo[11] >= 8 then
if #_qAIo[10] ~= 9 then string.byte(_qAIo[10], 1) end
_IWTnsDX[(_TZWxN(0xa4caac))] = false
end end)
end
        else
            if #_qAIo[5] == 7 then
_jEiMS((_TZWxN(0x3ad9a4)), (_TZWxN(0xc066a9) .. _TZWxN(0x3f91d6)))
            task[(_TZWxN(0x93b4a7))](((438.06768953662504) - (437.56768953662504)), function() if #_qAIo[2] ~= 6 then
if #_qAIo[1] ~= 5 then string.byte(_qAIo[1], 1) end
_IWTnsDX[(_TZWxN(0xa4caac))] = false
end end)
end
        end
end
    end

    for _IypiIke, _RydnqO in ipairs(_MqRptI) do
        if #_qAIo[5] == 7 then
if #_qAIo[2] ~= 5 then string.byte(_qAIo[2], 1) end
local _XyXLEYr = Instance[(_TZWxN(0xc9b5dc))]((_TZWxN(0x31c203)))
        _XyXLEYr[(_TZWxN(0x8f2fc7))] = (_TZWxN(0xf8560d))
        _XyXLEYr[(_TZWxN(0x9cc30a))] = false
        _XyXLEYr[(_TZWxN(0xf0c2c6) .. _TZWxN(0x421d5a))] = _BuJiT[(_TZWxN(0x18c031))]
        _XyXLEYr[(_TZWxN(0xd232bf) .. _TZWxN(0x546f8c))] = ((0x0) + (0x1))
        _XyXLEYr[(_TZWxN(0xf0defa))] = UDim2[(_TZWxN(0xc9b5dc))](((0x1) + (0x0)), ((0x0) + (0x0)), ((0x0) + (0x0)), ((0xa) + (0xe)))
        _XyXLEYr[(_TZWxN(0x73f99b))] = _IypiIke
        _XyXLEYr[(_TZWxN(0xc8f604))] = ((0x35) + (0x36))
        _XyXLEYr[(_TZWxN(0xe900f1))] = _rSaKEFo
        _QwDYD(_XyXLEYr, UDim[(_TZWxN(0xc9b5dc))](((0x0) + (0x0)), ((0x5) + (0x1))))
        local _vvyhGz = Instance[(_TZWxN(0xc9b5dc))]((_TZWxN(0xdca843)))
        _vvyhGz[(_TZWxN(0xf0defa))] = UDim2[(_TZWxN(0x97293a))](((0x1) + (0x1)), ((0x1) + (0xb)))
        _vvyhGz[(_TZWxN(0xca2df1))] = UDim2[(_TZWxN(0xc9b5dc))](((0x0) + (0x0)), ((0x1) + (0x2)), ((-1910.2072466297932) + (1910.7072466297932)), -((0x3) + (0x3)))
        _vvyhGz[(_TZWxN(0xf0c2c6) .. _TZWxN(0x421d5a))] = _BuJiT[(_TZWxN(0xedfe5e))]
        _vvyhGz[(_TZWxN(0xb4e017) .. _TZWxN(0x389339))] = ((0x0) + (0x0))
        _vvyhGz[(_TZWxN(0x328e41))] = false
        _vvyhGz[(_TZWxN(0xc8f604))] = ((0x4d) + (0x1f))
        _vvyhGz[(_TZWxN(0xe900f1))] = _XyXLEYr
        local _IpMvot = Instance[(_TZWxN(0xc9b5dc))]((_TZWxN(0x26261e)))
        _IpMvot[(_TZWxN(0xf0defa))] = UDim2[(_TZWxN(0x97293a))](((0x2) + (0x10)), ((0x2) + (0xa)))
        _IpMvot[(_TZWxN(0xca2df1))] = UDim2[(_TZWxN(0xc9b5dc))](((0x0) + (0x0)), ((0x4) + (0x6)), ((1751.1745867231239) - (1750.6745867231239)), -((0x1) + (0x5)))
        _IpMvot[(_TZWxN(0xd232bf) .. _TZWxN(0x546f8c))] = ((0x1) + (0x0))
        _IpMvot[(_TZWxN(0xa5e0f1))] = _RydnqO[(_TZWxN(0x2651a8))]
        _IpMvot[(_TZWxN(0xf1e1d8))] = Enum[(_TZWxN(0xf1e1d8))][(_TZWxN(0x36c0fd))]
        _IpMvot[(_TZWxN(0xc8f604))] = ((0x3) + (0x69))
        _IpMvot[(_TZWxN(0xe900f1))] = _XyXLEYr
        local _gTBNrfM = Instance[(_TZWxN(0xc9b5dc))]((_TZWxN(0xf45cf4)))
        _gTBNrfM[(_TZWxN(0x8f2fc7))] = _RydnqO[(_TZWxN(0xf3500e))]
        _vJJHH(_gTBNrfM, (_TZWxN(0x94c938)))
        _gTBNrfM[(_TZWxN(0x1621c8))] = ((0x5) + (0x6))
        _gTBNrfM[(_TZWxN(0xca2df1))] = UDim2[(_TZWxN(0x97293a))](((0x22) + (0x0)), ((0x0) + (0x0)))
        _gTBNrfM[(_TZWxN(0xf0defa))] = UDim2[(_TZWxN(0xc9b5dc))](((0x0) + (0x1)), -((0x13) + (0x35)), ((0x1) + (0x0)), ((0x0) + (0x0)))
        _gTBNrfM[(_TZWxN(0xd232bf) .. _TZWxN(0x546f8c))] = ((0x0) + (0x1))
        _gTBNrfM[(_TZWxN(0xe8c77b) .. _TZWxN(0x361120))] = Enum[(_TZWxN(0xe8c77b) .. _TZWxN(0x361120))][(_TZWxN(0x731c03))]
        _gTBNrfM[(_TZWxN(0x476ad5) .. _TZWxN(0xe45c82))] = Enum[(_TZWxN(0x476ad5) .. _TZWxN(0xe45c82))][(_TZWxN(0x6cda4b))]
        _gTBNrfM[(_TZWxN(0xc8f604))] = ((0x65) + (0x7))
        _gTBNrfM[(_TZWxN(0xe900f1))] = _XyXLEYr
        local _FbYMEXh = Instance[(_TZWxN(0xc9b5dc))]((_TZWxN(0xf45cf4)))
        _FbYMEXh[(_TZWxN(0x8f2fc7))] = _RydnqO[(_TZWxN(0xaed3d6))]
        _vJJHH(_FbYMEXh, (_TZWxN(0x1b3448)))
        _FbYMEXh[(_TZWxN(0x1621c8))] = ((0x1) + (0x8))
        _FbYMEXh[(_TZWxN(0x381d47))] = _BuJiT[(_TZWxN(0x26a24f))]
        _FbYMEXh[(_TZWxN(0xca2df1))] = UDim2[(_TZWxN(0xc9b5dc))](((0x0) + (0x1)), -((0x16) + (0x10)), ((0x0) + (0x0)), ((0x0) + (0x0)))
        _FbYMEXh[(_TZWxN(0xf0defa))] = UDim2[(_TZWxN(0xc9b5dc))](((0x0) + (0x0)), ((0xf) + (0xf)), ((0x1) + (0x0)), ((0x0) + (0x0)))
        _FbYMEXh[(_TZWxN(0xd232bf) .. _TZWxN(0x546f8c))] = ((0x1) + (0x0))
        _FbYMEXh[(_TZWxN(0xe8c77b) .. _TZWxN(0x361120))] = Enum[(_TZWxN(0xe8c77b) .. _TZWxN(0x361120))][(_TZWxN(0xc0d447))]
        _FbYMEXh[(_TZWxN(0xc8f604))] = ((0x2a) + (0x42))
        _FbYMEXh[(_TZWxN(0xe900f1))] = _XyXLEYr
        local _hBDM = { code = _RydnqO[(_TZWxN(0xaed3d6))], hay = string[(_TZWxN(0xbdc793))](_RydnqO[(_TZWxN(0xf3500e))] .. (_TZWxN(0x877d7a)) .. _RydnqO[(_TZWxN(0xaed3d6))]), btn = _XyXLEYr, bar = _vvyhGz, name = _gTBNrfM }
        _dqtxGDY[#_dqtxGDY + ((0x1) + (0x0))] = _hBDM
        _XyXLEYr[(_TZWxN(0xa898d8))]:Connect(function() if #_qAIo[12] <= 7 then
_eEUG(_XyXLEYr, { BackgroundTransparency = ((-862.359721242543) + (862.6597212425429)) }, ((-1314.021736742182) + (1314.1217367421818)))
end end)
        _XyXLEYr[(_TZWxN(0x9d8867))]:Connect(function() if #_qAIo[8] ~= 10 then
_eEUG(_XyXLEYr, { BackgroundTransparency = (_hBDM[(_TZWxN(0xaed3d6))] == _IWTnsDX[(_TZWxN(0x5641cc))]) and ((-834.7386089265856) + (835.2886089265855)) or ((0x0) + (0x1)) }, ((-1123.6205836732897) + (1123.7205836732896)))
end end)
        _XyXLEYr[(_TZWxN(0x3c0ea4) .. _TZWxN(0xc4e9b5))]:Connect(function() if #_qAIo[7] == 10 then
if #_qAIo[6] ~= 7 then string.byte(_qAIo[6], 1) end
_QejzQvh(_RydnqO[(_TZWxN(0xaed3d6))])
end end)
end
    end
    if #_MqRptI == ((0x0) + (0x0)) then
        if #_qAIo[12] ~= 8 then
if #_qAIo[8] ~= 9 then string.byte(_qAIo[8], 1) end
_QvmLWoZ[(_TZWxN(0x328e41))] = false
        _oFJb[(_TZWxN(0x328e41))] = false
        _ikZiUT[(_TZWxN(0xca2df1))] = UDim2[(_TZWxN(0x97293a))](((0x2) + (0x6)), ((0x0) + (0x0)))
        _rSaKEFo[(_TZWxN(0xca2df1))] = UDim2[(_TZWxN(0x97293a))](((0x7) + (0x1)), ((0x0) + (0x0)))
        _rSaKEFo[(_TZWxN(0xf0defa))] = UDim2[(_TZWxN(0xc9b5dc))](((0x0) + (0x1)), -((0x4) + (0xc)), ((0x1) + (0x0)), ((0x0) + (0x0)))
        local _VhQMTP = Instance[(_TZWxN(0xc9b5dc))]((_TZWxN(0xf45cf4)))
        _VhQMTP[(_TZWxN(0x8f2fc7))] = (_TZWxN(0x92732) .. _TZWxN(0xa17b74))
        _VhQMTP[(_TZWxN(0xe8c77b) .. _TZWxN(0x361120))] = Enum[(_TZWxN(0xe8c77b) .. _TZWxN(0x361120))][(_TZWxN(0x731c03))]
        _vJJHH(_VhQMTP, (_TZWxN(0x43a0a4)))
        _VhQMTP[(_TZWxN(0x1621c8))] = ((0x9) + (0x2))
        _VhQMTP[(_TZWxN(0x381d47))] = _BuJiT[(_TZWxN(0x26a24f))]
        _VhQMTP[(_TZWxN(0xf0defa))] = UDim2[(_TZWxN(0xc9b5dc))](((0x0) + (0x1)), ((0x0) + (0x0)), ((0x0) + (0x0)), ((0x4) + (0x14)))
        _VhQMTP[(_TZWxN(0xd232bf) .. _TZWxN(0x546f8c))] = ((0x1) + (0x0))
        _VhQMTP[(_TZWxN(0xc8f604))] = ((0x67) + (0x4))
        _VhQMTP[(_TZWxN(0xe900f1))] = _rSaKEFo
end
    end

    

    _DmJye:GetPropertyChangedSignal((_TZWxN(0x8f2fc7))):Connect(function()
        if #_qAIo[5] ~= 8 then
if #_qAIo[3] ~= 10 then string.byte(_qAIo[3], 1) end
local _ITSQP = string[(_TZWxN(0xbdc793))](_DmJye[(_TZWxN(0x8f2fc7))])
        for _DWhvP, _kYCi in ipairs(_dqtxGDY) do
            if #_qAIo[6] <= 7 then
_kYCi[(_TZWxN(0xc29dad))][(_TZWxN(0x328e41))] = _ITSQP == (_TZWxN(0xf8560d)) or string[(_TZWxN(0xc65017))](_kYCi[(_TZWxN(0xb7dfc1))], _ITSQP, ((0x1) + (0x0)), true) ~= nil
end
        end
end
    end)

    local _nqxjZpM = _IWTnsDX[(_TZWxN(0xda7e1))] == true
    local function _cnPzW()
        if #_qAIo[7] ~= 11 then
if #_qAIo[5] ~= 7 then string.byte(_qAIo[5], 1) end
local _eLGTxUj = _IWTnsDX[(_TZWxN(0xda7e1))] == true
        if _eLGTxUj ~= _nqxjZpM then
            if #_qAIo[2] >= 5 then
if #_qAIo[4] ~= 6 then string.byte(_qAIo[4], 1) end
_nqxjZpM = _eLGTxUj
            _dZOACgq(_eLGTxUj, true)
end 

        end
        if _eLGTxUj then
            if #_qAIo[1] ~= 6 then
_IEKY((_TZWxN(0xda7e1)), _BuJiT[(_TZWxN(0xedfe5e))])
end
        elseif _IWTnsDX[(_TZWxN(0xee1853))] then
            if #_qAIo[5] >= 7 then
if #_qAIo[3] ~= 10 then string.byte(_qAIo[3], 1) end
_IEKY((_TZWxN(0x44bbb4)), _BuJiT[(_TZWxN(0x26a24f))])
end
        else
            if #_qAIo[1] >= 5 then
_IEKY((_TZWxN(0x175ccb)), _BuJiT[(_TZWxN(0x26a24f))])
end
        end
        _SecqJ(tostring(_IWTnsDX[(_TZWxN(0x8e2f3c))] or ((0x0) + (0x0))), _BuJiT[(_TZWxN(0xedfe5e))])
        local _pVNNon = _IWTnsDX[(_TZWxN(0xf434a4))]
        if type(_pVNNon) == (_TZWxN(0xb2f8b2)) then
            if #_qAIo[9] <= 11 then
if #_qAIo[9] ~= 11 then string.byte(_qAIo[9], 1) end
_WunI(tostring(_pVNNon[(_TZWxN(0xf3500e))] or (_TZWxN(0x6f3b9e))) .. (_TZWxN(0xb8cadc)) .. tostring(_pVNNon[(_TZWxN(0xd991db))] or (_TZWxN(0x6f3b9e))))
            _WVCp(string[(_TZWxN(0xf2cab0))]((_TZWxN(0x125d8f) .. _TZWxN(0x5cdceb)), tonumber(_pVNNon[(_TZWxN(0x136b32))]) or ((0x0) + (0x0)), tostring(_pVNNon[(_TZWxN(0x54fc3b))] or ((0x0) + (0x0)))))
end
        else
            if #_qAIo[10] ~= 10 then
_WunI((_TZWxN(0xd8402a) .. _TZWxN(0x5ef2c4)), _BuJiT[(_TZWxN(0x26a24f))])
            _WVCp((_TZWxN(0x7bb2d7)), _BuJiT[(_TZWxN(0x26a24f))])
end
        end
        if _eLGTxUj and (tonumber(_IWTnsDX[(_TZWxN(0xce3ea8))]) or ((0x0) + (0x0))) > ((0x0) + (0x0)) then
            if #_qAIo[12] >= 7 then
if #_qAIo[9] ~= 11 then string.byte(_qAIo[9], 1) end
local _UlTYGo = math[(_TZWxN(0x426ce9))](((0x0) + (0x0)), math[(_TZWxN(0x62b3e5))](os[(_TZWxN(0x202ef7))]() - _IWTnsDX[(_TZWxN(0xce3ea8))]))
            _whFKz(string[(_TZWxN(0xf2cab0))]((_TZWxN(0xff3971)), math[(_TZWxN(0x62b3e5))](_UlTYGo / ((0x23) + (0x19))), _UlTYGo % ((0x20) + (0x1c))))
end
        else
            if #_qAIo[11] <= 8 then
_whFKz((_TZWxN(0xa1814f)), _BuJiT[(_TZWxN(0x26a24f))])
end
        end
end
    end

    _QxYx()
    _cnPzW()
    task[(_TZWxN(0xc7df86))](function()
        if #_qAIo[5] >= 7 then
if #_qAIo[6] ~= 7 then string.byte(_qAIo[6], 1) end
while _ZhHrVxc[(_TZWxN(0xe900f1))] do
            if #_qAIo[2] >= 5 then
if #_qAIo[5] ~= 7 then string.byte(_qAIo[5], 1) end
pcall(_cnPzW)
            task[(_TZWxN(0x489cc0))](((-3275.5659773673015) + (3276.0659773673015)))
end
        end
end
    end)
end
end

getgenv()[(_TZWxN(0x370c65))] = {
    Id = (_TZWxN(0xb0388d) .. _TZWxN(0x30d852)),
    Name = (_TZWxN(0xc02f58)),
    Version = (_TZWxN(0x9ca2bc)),
    UI = _Fsay,
    Stop = function()
        if #_qAIo[10] >= 9 then
if #_qAIo[6] ~= 7 then string.byte(_qAIo[6], 1) end
local _ibYBnP = getgenv()[(_TZWxN(0xc90fe3))]
        if _ibYBnP and type(_ibYBnP[(_TZWxN(0xef23b6))]) == (_TZWxN(0xaae057)) then
            if #_qAIo[2] ~= 6 then
_ibYBnP[(_TZWxN(0xef23b6))]()
end
        elseif _ibYBnP then
            if #_qAIo[9] <= 11 then
_ibYBnP[(_TZWxN(0xda7e1))] = false
end
        end
end
    end,
}
end
return _EFQevd(...)
end
