local script_ver = '1.4.0'

script_name('Miku Project Reborn')
script_version(script_ver)
script_author('@arz_run')
script_description('MultiCheat named *Miku* for Arizona Mobile. Type /miku to open menu. Our channeI: t.me/arz_run')

local getName = thisScript().path
local targetName = getWorkingDirectory()..'/MikuProjectReborn.lua'
if getName ~= targetName then
    os.rename(getName, targetName)
    thisScript():reload()
end

local success, jniUtil = pcall(require, "android.jnienv-util")
local success2, env = pcall(require, "android.jnienv")
local imgui = require 'mimgui'
local fa = require 'fAwesome6_solid'
local faicons = require 'fAwesome6'
local mem = require 'memory'
local events = require 'samp.events'
local ffi = require 'ffi'
local sf = require 'sampfuncs'
local inicfg = require 'inicfg'
local Vector3D = require 'vector3d'
local widgets = require 'widgets'
local memory = require 'memory'
local samem = require 'SAMemory'
local raknet = require 'samp.raknet'
local ltn12 = require 'ltn12'
local http = require 'socket.http'
samem.require 'CPed'
local FontFlags = require 'lib.moonloader'.font_flag

local encoding = require 'encoding'
encoding.default = 'CP1251'
local u8 = encoding.UTF8

local directIni = 'MikuProject.ini'
local ini = inicfg.load({
    silent = {
        salo = (false),
        canSee = (true),
        radius = (100),
        ignoreCars = (true),
        distance = (500),
        useWeaponRadius = (true),
        useWeaponDistance = (true),
        ignoreObj = (true),
        line = (true),
        circle = (true),
        fpscircle = (true),
        printString = (true),
        misses = (false),
        miss_ratio = (3),
        removeAmmo = (false),
        doubledamage = (false),
        tripledamage = (false),
        offsetx = (0.0),
        offsety = (0.0)
    },
    cfg = {
        autosave = (true)
    },
    ESP = {
        drawing = (false),
        enabled_boxes = (false),
        enabled_bones = (false),
        enabled_nicks = (false),
        enabled_lines = (false),
        enabled_health = (false),
        enabled_armor = (false),
        enabled_fillgradient = (false),
        boxthinkness = (3),
        skeletonthinkness = (3),
        nicknamesize = (0.0180),
        lineposition = (0),
        linethinkness = (2),
        fillboxvalue = (0.3)
    },
    main = {
        airbrakewidget = (false),
        clickwarpcoord = (false),
        antimask = (false),
        timeblockserv = (false),
        weatherblockserv = (false),
        autocaptcha = (false),
        antiFreeze = (false)
    },
    ped = {
        godmode_enabled = (false),
        noreload = (false),
        setskills = (false),
        animspeed = (false),
        speedint = (1),
        rapidfire = (false),
        rapidint = (1),
        skinid = (0),
        autoplusc = (false),
        infiniterun = (false),
        killbots1hit = (false),
        sbiv = (false),
        autoscroll = (false),
        pt = (1),
        wait = (200),
        nofall = (false),
        changefov = (false),
        fovvalue = (101)
    },
    car = {
        godmode2_enabled = (false),
        flycar = (false),
        nobike = (false),
        atrradius = (150),
        atractive = (false),
        speedhack = (false),
        limit = (1.25),
	    mult = (1.02),
		timestep = (0.03),
		safe_train_speed = (true),
		fastenter = (false),
		infinitefuel = (false),
		fastexit = (false),
		fastbrake = (false),
        jumpcar = (false),
        anticarskill = (false)
    },
    render = {
        ruda = (false),
        deer = (false),
        narkotiki = (false),
        podarok = (false),
        musortsr = (false),
        kladrender = (false),
        yabloki = (false),
        slivu = (false),
        kokosi = (false),
        derevovishkac = (false),
        semena = (false),
        graffiti = (false)
    },
    menu = {
        slideropenbuttonwidth = (100),
        slideropenbuttonheight = (95),
        openbutton = (true),
        openbutton2 = (false),
        sendalt = (false),
        sendaltwidth = (180),
        sendaltheight = (50),
        showinfo = (true),
        window_scale = (1.0),
        draweffects = (true),
        watermark = (true)
    },
    dgun = {
        gunsList = (0),
        ammo = (500)
    },
    objects = {
        autormlsa = (false),
        autormsfa = (false),
        autormblockpost = (false),
        autormlampposts = (false),
        autormroadrem = (false)
    },
    tsr = {
        tsrbotwait = (1200),
        autormcell = (false),
        autormdoors = (false),
        autormfence = (false)
    },
    battery = {
        notifyLowCharge = (false),
        lowBatteryLevel = (15)
    }
}, directIni)
inicfg.save(ini, directIni)

local settings = {
    silent = {
        salo = imgui.new.bool(ini.silent.salo),
        canSee = imgui.new.bool(ini.silent.canSee),
        radius = imgui.new.int(ini.silent.radius),
        ignoreCars = imgui.new.bool(ini.silent.ignoreCars),
        distance = imgui.new.int(ini.silent.distance),
        useWeaponRadius = imgui.new.bool(ini.silent.useWeaponRadius),
        useWeaponDistance = imgui.new.bool(ini.silent.useWeaponDistance),
        ignoreObj = imgui.new.bool(ini.silent.ignoreObj),
        line = imgui.new.bool(ini.silent.line),
        circle = imgui.new.bool(ini.silent.circle),
        fpscircle = imgui.new.bool(ini.silent.fpscircle),
        printString = imgui.new.bool(ini.silent.printString),
        misses = imgui.new.bool(ini.silent.misses),
        miss_ratio = imgui.new.int(ini.silent.miss_ratio),
        removeAmmo = imgui.new.bool(ini.silent.removeAmmo),
        doubledamage = imgui.new.bool(ini.silent.doubledamage),
        tripledamage = imgui.new.bool(ini.silent.tripledamage),
        offsetx = imgui.new.float(ini.silent.offsetx),
        offsety = imgui.new.float(ini.silent.offsety)
    },
    ESP = {
        drawing = imgui.new.bool(ini.ESP.drawing),
        enabled_bones = imgui.new.bool(ini.ESP.enabled_bones),
        enabled_boxes = imgui.new.bool(ini.ESP.enabled_boxes),
        enabled_nicks = imgui.new.bool(ini.ESP.enabled_nicks),
        enabled_lines = imgui.new.bool(ini.ESP.enabled_lines),
        enabled_health = imgui.new.bool(ini.ESP.enabled_health),
        enabled_armor = imgui.new.bool(ini.ESP.enabled_armor),
        enabled_fillgradient = imgui.new.bool(ini.ESP.enabled_fillgradient),
        boxthinkness = imgui.new.int(ini.ESP.boxthinkness),
        skeletonthinkness = imgui.new.int(ini.ESP.skeletonthinkness),
        nicknamesize = imgui.new.float(ini.ESP.nicknamesize),
        lineposition = imgui.new.int(ini.ESP.lineposition),
        linethinkness = imgui.new.int(ini.ESP.linethinkness),
        fillboxvalue = imgui.new.float(ini.ESP.fillboxvalue)
    },
    main = {
        airbrakewidget = imgui.new.bool(ini.main.airbrakewidget),
        clickwarpcoord = imgui.new.bool(ini.main.clickwarpcoord),
        antimask = imgui.new.bool(ini.main.antimask),
        timeblockserv = imgui.new.bool(ini.main.timeblockserv),
        weatherblockserv = imgui.new.bool(ini.main.weatherblockserv),
        autocaptcha = imgui.new.bool(ini.main.autocaptcha),
        antiFreeze = imgui.new.bool(ini.main.antiFreeze)
    },
    ped = {
        godmode_enabled = imgui.new.bool(ini.ped.godmode_enabled),
        noreload = imgui.new.bool(ini.ped.noreload),
        setskills = imgui.new.bool(ini.ped.setskills),
        animspeed = imgui.new.bool(ini.ped.animspeed),
        speedint = imgui.new.int(ini.ped.speedint),
        rapidfire = imgui.new.bool(ini.ped.rapidfire),
        rapidint = imgui.new.int(ini.ped.rapidint),
        skinid = imgui.new.int(ini.ped.skinid),
        autoplusc = imgui.new.bool(ini.ped.autoplusc),
        infiniterun = imgui.new.bool(ini.ped.infiniterun),
        killbots1hit = imgui.new.bool(ini.ped.killbots1hit),
        sbiv = imgui.new.bool(ini.ped.sbiv),
        autoscroll = imgui.new.bool(ini.ped.autoscroll),
        pt = imgui.new.int(ini.ped.pt),
        wait = imgui.new.int(ini.ped.wait),
        nofall = imgui.new.bool(ini.ped.nofall),
        changefov = imgui.new.bool(ini.ped.changefov),
        fovvalue = imgui.new.int(ini.ped.fovvalue)
    },
    car = {
        godmode2_enabled = imgui.new.bool(ini.car.godmode2_enabled),
        flycar = imgui.new.bool(ini.car.flycar),
        nobike = imgui.new.bool(ini.car.nobike),
        atrradius = imgui.new.int(ini.car.atrradius),
        atractive = imgui.new.bool(ini.car.atractive),
        speedhack = imgui.new.bool(ini.car.speedhack),
        slider_mult = imgui.new.float(ini.car.mult),
        slider_limit = imgui.new.float(ini.car.limit),
        slider_timestep = imgui.new.float(ini.car.timestep),
        safe_train_speed = imgui.new.bool(ini.car.safe_train_speed),
        fastenter = imgui.new.bool(ini.car.fastenter),
        infinitefuel = imgui.new.bool(ini.car.infinitefuel),
        fastexit = imgui.new.bool(ini.car.fastexit),
        fastbrake = imgui.new.bool(ini.car.fastbrake),
        jumpcar = imgui.new.bool(ini.car.jumpcar),
        anticarskill = imgui.new.bool(ini.car.anticarskill)
    },
    render = {
        ruda = imgui.new.bool(ini.render.ruda),
        deer = imgui.new.bool(ini.render.deer),
        narkotiki = imgui.new.bool(ini.render.narkotiki),
        podarok = imgui.new.bool(ini.render.podarok),
        musortsr = imgui.new.bool(ini.render.musortsr),
        kladrender = imgui.new.bool(ini.render.kladrender),
        yabloki = imgui.new.bool(ini.render.yabloki),
        slivu = imgui.new.bool(ini.render.slivu),
        kokosi = imgui.new.bool(ini.render.kokosi),
        derevovishkac = imgui.new.bool(ini.render.derevovishkac),
        semena = imgui.new.bool(ini.render.semena),
        graffiti = imgui.new.bool(ini.render.graffiti)
    },
    menu = {
        slideropenbuttonwidth = imgui.new.int(ini.menu.slideropenbuttonwidth),
        slideropenbuttonheight = imgui.new.int(ini.menu.slideropenbuttonheight),
        openbutton = imgui.new.bool(ini.menu.openbutton),
        openbutton2 = imgui.new.bool(ini.menu.openbutton2),
        sendalt = imgui.new.bool(ini.menu.sendalt),
        sendaltwidth = imgui.new.int(ini.menu.sendaltwidth),
        sendaltheight = imgui.new.int(ini.menu.sendaltheight),
        showinfo = imgui.new.bool(ini.menu.showinfo),
        window_scale = imgui.new.float(ini.menu.window_scale),
        draweffects = imgui.new.bool(ini.menu.draweffects),
        watermark = imgui.new.bool(ini.menu.watermark)
    },
    dgun = {
        gunsList = imgui.new.int(ini.dgun.gunsList),
        ammo = imgui.new.int(ini.dgun.ammo)
    },
    objects = {
        autormlsa = imgui.new.bool(ini.objects.autormlsa),
        autormsfa = imgui.new.bool(ini.objects.autormsfa),
        autormblockpost = imgui.new.bool(ini.objects.autormblockpost),
        autormlampposts = imgui.new.bool(ini.objects.autormlampposts),
        autormroadrem = imgui.new.bool(ini.objects.autormroadrem)
    },
    tsr = {
        tsrbotwait = imgui.new.int(ini.tsr.tsrbotwait),
        autormcell = imgui.new.bool(ini.tsr.autormcell),
        autormdoors = imgui.new.bool(ini.tsr.autormdoors),
        autormfence = imgui.new.bool(ini.tsr.autormfence)
    },
    battery = {
        notifyLowCharge = imgui.new.bool(ini.battery.notifyLowCharge),
        lowBatteryLevel = imgui.new.int(ini.battery.lowBatteryLevel),
        stopMessage = false
    },
    cfg = {
        autosave = imgui.new.bool(ini.cfg.autosave)
    }
}
-- /* xyu official variables */ --
-- Ìåíþ
local tab = 1
local activetab = 1
local subtab_1 = 1
local subtab_2 = 1
local subtab_3 = 1
local subtab_4 = 1
local subtab_5 = 1
local subtab_6 = 1
local subtab_7 = 1
local SCREEN_W, SCREEN_H = getScreenResolution()
local new = imgui.new
local window_scale = imgui.new.float(1.0)
local window_state = new.bool()
local custommimguiStyle = new.bool()
local menusettings = new.bool()
local found_update = new.bool()
-- battery manager
local BATTERY_PROPERTY_CAPACITY = 4
local BATTERY_PROPERTY_CHARGE_COUNTER = 1
local BATTERY_PROPERTY_ENERGY_COUNTER = 5
local BATTERY_PROPERTY_CURRENT_NOW = 5
-- AirBrake
local was_doubletapped = false
local enabledair = false
local speed = 0.3
local was_in_car = false
local last_car
-- notify
Notifications = {
  _version = '0.2',
  _list = {},
  _COLORS = {
    [0] = {back = {0.26, 0.71, 0.81, 1},    text = {1, 1, 1, 1}, icon = {1, 1, 1, 1}, border = {1, 0, 0, 0}},
    [1] = {back = {0.26, 0.81, 0.31, 1},    text = {1, 1, 1, 1}, icon = {1, 1, 1, 1}, border = {1, 0, 0, 0}},
    [2] = {back = {1, 0.39, 0.39, 1},       text = {1, 1, 1, 1}, icon = {1, 1, 1, 1}, border = {1, 0, 0, 0}},
    [3] = {back = {0.97, 0.57, 0.28, 1},    text = {1, 1, 1, 1}, icon = {1, 1, 1, 1}, border = {1, 0, 0, 0}},
    [4] = {back = {0, 0, 0, 1},             text = {1, 1, 1, 1}, icon = {1, 1, 1, 1}, border = {1, 0, 0, 0}},
  },

  TYPE = {
      INFO = 0,
      OK = 1,
      ERROR = 2,
      WARN = 3,
      DEBUG = 4
  },
  ICON = {
      [0] = faicons('CIRCLE_INFO'),
      [1] = faicons('CHECK'),
      [2] = faicons('XMARK'),
      [3] = faicons('EXCLAMATION'),
      [4] = faicons('WRENCH')
  }
}
-- speedhack
local player_vehicle = samem.cast('CVehicle **', samem.player_vehicle)
-- auto updates
local lmPath = "MikuProjectReborn.lua"
local lmUrl = "https://raw.githubusercontent.com/Wrexhams/Mikus/main/MikuProjectReborn.lua"
local betaUrl = "https://s"
local betaPath = "MikuProjectReborn.lua"
local updfont = {}
-- togglebutton
local AI_TOGGLE = {}
local ToU32 = imgui.ColorConvertFloat4ToU32
-- tsr rage bot
local tsrragebot = imgui.new.bool(false)
local botstep = -1
local box = 0
-- attach trailer
atrtrailer = nil
-- dgun combo
local item_list = {u8'Êóëàê', u8'Êàñòåò', u8'Êëþøêà äëÿ ãîëüôà', u8'Ïîëèöåéñêàÿ äóáèíêà', u8'Íîæ', u8'Áåéñáîëüíàÿ áèòà', u8'Ëîïàòà', u8'Êàëüÿí', u8'Ñèãàðà', u8'Îðóæèå òåêñòóðà'}
local ImItems = imgui.new['const char*'][#item_list](item_list)
-- clickwarp coordmaster
local chooseActive, pointMarker, renderInfo
local tpclick, sync = false, false
local packets = 0
-- alt
local floodalt = imgui.new.bool(false)
-- gmcar lastcar buffer
local GodModeCar = {
    last_car = nil
}
-- Ðåêînnåêò
local Reconnect = {
    delay = new.float(0),
    abort = false,
    waiting = false,
    remaining = 0,
    reconnecting = true
}
-- Âðåìÿ è ïîãîäà
local WeatherAndTime = {
    weather = new.int(0),
    time = new.int(0),
    locked_time = 0,
    new_time = false,
    thread = nil
}
-- Ôëàé÷àð
local FlyCar = {
    cars = 0
}
local wwwflycar = false
-- Ðåíäåð font
local font = renderCreateFont('NAMU PRO', 25, FontFlags.BORDER)
-- esp fonts, bones
function updateFont()
    if font then
        renderReleaseFont(font)
    end
    FONTESP = renderCreateFont('Arial', SCREEN_H * settings.ESP.nicknamesize[0], 1 + 4)
end
updateFont()
local ESP2 = {
  BONES = { 3, 4, 5, 51, 52, 41, 42, 31, 32, 33, 21, 22, 23, 2 },
}
-- silent
local targetId = -1

local miss = false

local ped = nil
local fakemode = imgui.new.bool(false)

math.randomseed(os.time())

local w, h = getScreenResolution()

function getpx()
	return ((w / 2) / getCameraFov()) * settings.silent.radius[0]
end

local silentfovcolor = {
    colornew = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
}

local animSpeed = {'RUN_CIVI', 'RUN_1ARMED', 'RUN_ARMED', 'RUN_CSAW', 'RUN_FAT', 'RUN_FATOLD', 'RUN_GANG1', 'RUN_LEFT', 'RUN_OLD', 'RUN_PLAYER', 'RUN_RIGHT', 'RUN_ROCKET', 'RUN_WUZI', 'RUN_STOP', 'WALK_CIVI', 'WALK_ARMED', 'WALK_CSAW', 'WALK_ROCKET', 'WALK_WUZI', 'JOG_CIVI', 'JOG_1ARMED', 'JOG_ARMED'}
local rapidAnimations = {"PYTHON_CROUCHFIRE", "PYTHON_FIRE", "PYTHON_FIRE_POOR", "PYTHON_CROCUCHRELOAD", "RIFLE_CROUCHFIRE", "RIFLE_CROUCHLOAD", "RIFLE_FIRE", "RIFLE_FIRE_POOR", "RIFLE_LOAD", "SHOTGUN_CROUCHFIRE", "SHOTGUN_CROUCHLOAD", "SHOTGUN_FIRE", "SHOTGUN_LOAD", "SNIPER_CROUCHFIRE", "SNIPER_FIRE", "SNIPER_CROUCHLOAD"}

local guns = {16, 17, 18, 25, 33, 34, 35, 36, 39, 40}
local ruda1 = {
	[854] = 'Ðóäà',
}

local narko = {
	[1575] = 'Çàêëàäêà',
	[1580] = 'Çàêëàäêà',
	[1576] = 'Çàêëàäêà',
	[1577] = 'Çàêëàäêà',
	[1578] = 'Çàêëàäêà',
	[1579] = 'Çàêëàäêà',
}

local gift = {
    [19054] = 'Ïîäàðîê',
    [19055] = 'Ïîäàðîê',
    [19056] = 'Ïîäàðîê',
    [19057] = 'Ïîäàðîê',
    [19058] = 'Ïîäàðîê',
}

local musor = {
    [2670] = 'Ìóñîð',
    [2673] = 'Ìóñîð',
    [2674] = 'Ìóñîð',
    [2677] = 'Ìóñîð',
}

local klad = {
    [2680] = 'Êëàä',
    [16317] = 'Êëàä',
    [1271] = 'Êëàä',
    [16302] = 'Êëàä',
}

local semenanarko = {
	[859] = 'Ñåìåíà íàðêî',
}

local derevovish = {
	[729] = 'Äåðåâî âûñøåãî êà÷åñòâà',
}

local apple = {
	[19576] = 'ßáëîêî (èëè ñëèâà)',
    [895] = 'ßáëî÷íîå äåðåâî'
}

local sliva = {
	[19576] = "Apple-Sliva",
    [883] = "Sliva Tree"
}

local kokos = {
	[19344] = 'Êîêîñ',
    [674] = 'Êîêîñîâîå äåðåâî'
}

local graffity = {
    [1490] = 'Ãðàôôèòè',
    [1524] = 'Ãðàôôèòè',
    [1525] = 'Ãðàôôèòè',
    [1526] = 'Ãðàôôèòè',
    [1527] = 'Ãðàôôèòè',
    [1528] = 'Ãðàôôèòè',
    [1529] = 'Ãðàôôèòè',
    [1530] = 'Ãðàôôèòè',
    [1531] = 'Ãðàôôèòè',
    [14840] = 'Ãðàôôèòè',
    [17969] = 'Ãðàôôèòè',
    [18659] = 'Ãðàôôèòè',
    [18660] = 'Ãðàôôèòè',
    [18661] = 'Ãðàôôèòè',
    [18662] = 'Ãðàôôèòè',
    [18663] = 'Ãðàôôèòè',
    [18664] = 'Ãðàôôèòè',
    [18665] = 'Ãðàôôèòè',
    [18666] = 'Ãðàôôèòè',
    [18667] = 'Ãðàôôèòè'
}

-- ffi get ped bones position
local gta = ffi.load('GTASA')
ffi.cdef[[
    typedef struct RwV3d {
        float x, y, z;
    } RwV3d;
    void _ZN4CPed15GetBonePositionER5RwV3djb(void* thiz, RwV3d* posn, uint32_t bone, bool calledFromCam);
]]

function getBonePosition(ped, bone)
    local pedptr = ffi.cast('void*', getCharPointer(ped))
    local posn = ffi.new('RwV3d[1]')
    gta._ZN4CPed15GetBonePositionER5RwV3djb(pedptr, posn, bone, false)
    return posn[0].x, posn[0].y, posn[0].z
end

----ImGui OnInitialize----
imgui.OnInitialize(function()
    ThemeMenu()
    Icons_Init()
    Fonts_Init()
end)

function Fonts_Init()
    local path = getWorkingDirectory()..'/resource/Zekton-Font.ttf'
    local path2 = getWorkingDirectory()..'/resource/Gotham_Pro.ttf'
    updfont[20] = imgui.GetIO().Fonts:AddFontFromFileTTF(path, 20.0, nil, glyph_ranges)
    updfont[25] = imgui.GetIO().Fonts:AddFontFromFileTTF(path, 25.0, nil, glyph_ranges)
    updfont[33] = imgui.GetIO().Fonts:AddFontFromFileTTF(path, 33.0, nil, glyph_ranges)
    updfont[40] = imgui.GetIO().Fonts:AddFontFromFileTTF(path, 40.0, nil, glyph_ranges)
    updfont[30] = imgui.GetIO().Fonts:AddFontFromFileTTF(path, 30.0, nil, glyph_ranges)
    waterfont = imgui.GetIO().Fonts:AddFontFromFileTTF(path2, 27.0 * MONET_DPI_SCALE, nil, glyph_ranges)
    upd1 = imgui.GetIO().Fonts:AddFontFromFileTTF(path2, 33.0, nil, glyph_ranges)
    upd2 = imgui.GetIO().Fonts:AddFontFromFileTTF(path2, 25.0, nil, glyph_ranges)
end

function Icons_Init()
    local config = imgui.ImFontConfig()
    config.MergeMode = true
    config.PixelSnapH = true
    iconRanges = imgui.new.ImWchar[3](faicons.min_range, faicons.max_range, 0)
    imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(faicons.get_font_data_base85('solid'), 20, config, iconRanges)
end
-- Reconnect
Reconnect.activate = function()
    lua_thread.create(function()
        local ms = 500 + Reconnect.delay[0] * 1000
        if ms <= 0 then
            ms = 100
        end
        notf4(u8'Ðåêînnåêòèìñÿ...')
        Reconnect.waiting = true
        while ms > 0 do
            if ms <= 500 then
                Reconnect.waiting = false
                local bs = raknetNewBitStream()
                raknetBitStreamWriteInt8(bs, sf.PACKET_DISCONNECTION_NOTIFICATION)
                raknetSendBitStreamEx(bs, sf.SYSTEM_PRIORITY, sf.RELIABLE, 0)
                raknetDeleteBitStream(bs)
            end
            if Reconnect.waiting and Reconnect.abort then
                Reconnect.waiting = false
                Reconnect.abort = false
                return
            end
            Reconnect.abort = false
            Reconnect.remaining = ms
            wait(100)
            ms = ms - 100
        end
        Reconnect.waiting = false
        Reconnect.reconnecting = true
        bs = raknetNewBitStream()
        raknetEmulPacketReceiveBitStream(sf.PACKET_CONNECTION_LOST, bs)
        raknetDeleteBitStream(bs)
    end)
end
  
-- FlyCar
FlyCar.processFlyCar = function()
    local car = storeCarCharIsInNoSave(PLAYER_PED)
    local speed = getCarSpeed(car)
    local result, var_1, var_2 = isWidgetPressedEx(WIDGET_VEHICLE_STEER_ANALOG, 0)
    if result then
        local var_1 = var_1 / -64.0
        local var_2 = var_2 / 64.0
        setCarRotationVelocity(car, var_2, 0.0, var_1)
    end
    if isWidgetPressed(WIDGET_ACCELERATE) and speed <= 200.0 then
        FlyCar.cars = FlyCar.cars + 0.4
    end
    if isWidgetPressed(WIDGET_BRAKE) then
        FlyCar.cars = FlyCar.cars - 0.3
        if FlyCar.cars < 0 then FlyCar.cars = 0 end
    end
    if isWidgetPressed(WIDGET_HANDBRAKE) then
        FlyCar.cars = 0
        setCarRotationVelocity(car, 0.0, 0.0, 0.0)
        setCarRoll(car, 0.0)
    end
    setCarForwardSpeed(car, FlyCar.cars)
end
  
-- SetSkin by forget
setskin_activate = function()
    local bs = raknetNewBitStream()
    raknetBitStreamWriteInt32(bs, select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
    raknetBitStreamWriteInt32(bs, settings.ped.skinid[0])
    raknetEmulRpcReceiveBitStream(153, bs)
    raknetDeleteBitStream(bs)
end