--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--IMPORTS
{-# OPTIONS_GHC -Wno-deprecations #-}
import Graphics.X11.ExtraTypes ()
import Graphics.X11.ExtraTypes.XF86
import System.Exit ( exitWith, ExitCode(ExitSuccess), exitSuccess )
import System.IO ( hPutStrLn, Handle )

import XMonad
    ( (.|.),
      button1,
      button2,
      button3,
      mod4Mask,
      shiftMask,
      xK_1,
      xK_9,
      xK_Return,
      xK_Tab,
      xK_c,
      xK_comma,
      xK_e,
      xK_h,
      xK_j,
      xK_k,
      xK_l,
      xK_m,
      xK_n,
      xK_p,
      xK_period,
      xK_q,
      xK_r,
      xK_slash,
      xK_space,
      xK_t,
      xK_w,
      xK_F4,
      io,
      spawn,
      whenJust,
      (|||),
      xmonad,
      (-->),
      (=?),
      className,
      composeAll,
      doFloat,
      doIgnore,
      resource,
      focus,
      kill,
      mouseMoveWindow,
      mouseResizeWindow,
      refresh,
      screenWorkspace,
      sendMessage,
      setLayout,
      windows,
      withFocused,
      Default(def),
      ManageHook,
      X,
      XConfig(XConfig, startupHook, handleEventHook, manageHook,
              mouseBindings, keys, focusedBorderColor, normalBorderColor,
              borderWidth, clickJustFocuses, focusFollowsMouse, logHook,
              workspaces, layoutHook, terminal, modMask),
      ChangeLayout(NextLayout),
      Full(Full),
      IncMasterN(IncMasterN),
      Mirror(Mirror),
      Resize(Expand, Shrink),
      Tall(Tall), doShift, gets, XState (windowset), xK_Print )
--Actions
import XMonad.Actions.CycleWS ()
import XMonad.Actions.SpawnOn ()
--Hooks
import XMonad.Hooks.DynamicLog
    ( dynamicLogWithPP,
      xmobarColor,
      xmobarPP,
      PP(ppSep, ppCurrent, ppLayout, ppTitle, ppOutput, ppVisible, ppHidden, ppHiddenNoWindows, ppUrgent, ppExtras, ppOrder), wrap, shorten )
import XMonad.Hooks.EwmhDesktops as E ()
import XMonad.Hooks.FadeInactive ( fadeInactiveLogHook )
import XMonad.Hooks.ManageHelpers ()
import XMonad.Hooks.Place ()
import XMonad.Hooks.SetWMName (setWMName)
import XMonad.Hooks.ManageDocks ( docks, avoidStruts )
--Layouts
import XMonad.Layout.Fullscreen ()
import XMonad.Layout.IndependentScreens ()
import XMonad.Layout.Spacing ()
--Utils
import XMonad.Util.SpawnOnce (spawnOnOnce)
import XMonad.Util.Run (spawnPipe)
import XMonad.Wallpaper ()
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import Data.Monoid ()
import XMonad.Prompt.XMonad ( xmonadPromptC )
import XMonad.Operations (restart)
import XMonad.Prompt (defaultXPConfig)
-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal :: String
myTerminal = "Alacritty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 3

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask = mod4Mask --Here I changed the mod key to windows key from alt

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
-- ["1","2","3","4","5","6","7","8","9"]

-- Making workspaces clickable
-- Reference https://github1s.com/qiUip/dotfiles/blob/opensuse/xmonad/xmonad.hs
xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
  where
        doubleLts '<' = "<<"
        doubleLts x   = [x]

myWorkspaces :: [String]
myWorkspaces = clickable . map xmobarEscape
               $ ["web", "code", "sh", "chat", "fun"]
  where
        clickable l = [ "<action= xdotool key super+" ++ show n ++ " button=1>" ++ ws ++ "</action>" |
                      (i,ws) <- zip [1..9] l,
                      let n = i ]

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset
-- where
--  clickable l =
--  [ "<action=xdotool key super+"
--   ++ show i
--     ++ " button=1>"
--     ++ ws
--     ++ "</action"
--    | (i, ws) <- zip ([1 .. 9] ++ [0 :: Int]) l
--
-- ]
--  workspaceLabels = zipWith makeLabel [1 .. 10 :: Int] icons
--  makeLabel index (fontIndex, icon) = show index ++ ":<fn="++show fontIndex ++ ">" ++ icon: "</fn>"
--  icons =
{--   [ (2, '\xf269')
   , (1, '\xf120')
   , (1, '\xf121')
   , (1, '\xf03d')
   , (1, '\xf128')
   , (1, '\xf128')
   , (1, '\xf128')
   , (1, '\xf128')
   , (2, '\xf1b6')
   , (2, '\xf1bc')
   ]

--}
-- Border colors for unfocused and focused windows, respectively.
--
--
myNormalBorderColor :: String
myNormalBorderColor  = "#292d3e"

myFocusedBorderColor :: String
myFocusedBorderColor = "#c3a583"

--Color of current workspace in xmobar
xmobarCurrentWorkspaceColor :: String
xmobarCurrentWorkspaceColor = "#Af745f"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--

systemPromptCmds = [
  ("shutdown", spawn "sudo poweroff"),
  ("Reboot", spawn "sudo reboot"),
  ("Exit", io exitSuccess),
  ("Lock", spawn "xtrlock -b"),
  ("Restart", restart "xmonad" True )
  ]
myKeys conf@XConfig {XMonad.modMask = modm} = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    , ((modm, xK_F4 ), xmonadPromptC systemPromptCmds defaultXPConfig)

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "dmenu_run")

    -- launch gmrun
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)
    -- take screenshot
    , ((0, xK_Print), spawn "flameshot gui")


    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)
    --Volume Controls
    , ((0, xF86XK_AudioMute), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
    , ((0, xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ -10%")
    , ((0, xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +10%")
    --Brightness Control
    , ((0, xF86XK_MonBrightnessUp), spawn "lux -a 10%")
    , ((0, xF86XK_MonBrightnessDown), spawn "lux -s 10%")

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io exitSuccess)

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings XConfig {XMonad.modMask = modm} = M.fromList

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), \w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster)

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), \w -> focus w >> windows W.shiftMaster)

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), \w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster)

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = avoidStruts (tiled ||| Mirror tiled ||| Full)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook :: ManageHook
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "vlc"            --> doShift(  myWorkspaces !! 5) -- 'fun'
    , className =? "kitty"          --> doShift(  myWorkspaces !! 3) -- 'sh'
    , className =? "Spotify"        --> doShift(  myWorkspaces !! 5) -- 'fun'
    , className =? "Visual Studio Code" --> doShift (myWorkspaces !! 2) -- code
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
--myLogHook=return()

-----------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
  setWMName "LG3D"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
main = do
  xmproc <- spawnPipe "xmobar -x 0 ~/.config/xmobar/xmobarrc"
  xmonad $ docks  $ defaults {logHook            = dynamicLogWithPP xmobarPP
                               { ppOutput          = \x ->  hPutStrLn xmproc x
                               , ppCurrent         = xmobarColor "#ddbd94" "" . wrap "[" "]"  -- Current workspace in xmobar
                               , ppVisible         = xmobarColor "#ddbd94" ""                 -- Visible but not current workspace
                               , ppHidden          = xmobarColor "#c15c2e" "" . wrap "*" ""   -- Hidden workspaces in xmobar
                               , ppHiddenNoWindows = xmobarColor "#5a8c93" ""                 -- Hidden workspaces (no windows)
                               , ppTitle           = xmobarColor "#d0d0d0" "" . shorten 20    -- Title of active window in xmobar
                               , ppSep             =  "<fc=#ff6ac1> | </fc>"                  -- Separators in xmobar
                               , ppUrgent          = xmobarColor "#C45500" "" . wrap "!" "!"  -- Urgent workspace
                               , ppExtras          = [windowCount]                            -- # of windows current workspace
                               , ppOrder           = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                               }
  }
-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        startupHook        = myStartupHook
    }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
