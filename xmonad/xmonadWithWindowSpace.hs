--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--IMPORTS
{-# OPTIONS_GHC -Wno-deprecations #-}
{-# LANGUAGE TupleSections #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE FlexibleContexts #-}
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
      xK_b,
      xK_c,
      xK_comma,
      xK_e,
      xK_f,
      xK_g,
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
      xK_F7,
      xK_Left,
      xK_Up,
      xK_Right,
      xK_Down,
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
      stringProperty,
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
      Tall(Tall), doShift, gets, XState (windowset), xK_Print, (<+>), doF )
--Actions
--Actions
--Actions
--Actions
import XMonad.Actions.CycleWS (nextWS, prevWS)
import XMonad.Actions.SpawnOn (manageSpawn)
import XMonad.Actions.MouseResize

--Hooks
import XMonad.Hooks.DynamicLog
    ( dynamicLogWithPP,
      xmobarColor,
      xmobarPP,
      PP(ppSep, ppCurrent, ppLayout, ppTitle, ppOutput, ppVisible, ppHidden, ppHiddenNoWindows, ppUrgent, ppExtras, ppOrder), wrap, shorten )
import XMonad.Hooks.EwmhDesktops as E ()
import XMonad.Hooks.FadeInactive ( fadeInactiveLogHook )
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, doCenterFloat)
import XMonad.Hooks.Place ()
import XMonad.Hooks.SetWMName (setWMName)
import XMonad.Hooks.ManageDocks ( docks, avoidStruts, ToggleStruts (ToggleStruts) )

--Layouts
import XMonad.Layout.Fullscreen ()
import XMonad.Layout.IndependentScreens ()
import XMonad.Layout.ResizableTile( ResizableTall(..)
                                    , MirrorResize(MirrorShrink, MirrorExpand) )
import XMonad.Layout.Spacing ()
import XMonad.Layout.Accordion
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns


--Layout Modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import XMonad.Layout.WindowNavigation
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))




--Utils
import XMonad.Util.SpawnOnce (spawnOnOnce, spawnOnce)
import XMonad.Util.Run (spawnPipe)
-- import XMonad.Wallpaper ()
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import Data.Monoid ()
import XMonad.Prompt.XMonad ( xmonadPromptC )
import XMonad.Operations (restart)
import XMonad.Prompt (defaultXPConfig)
import Distribution.Simple.Setup (programConfigurationOptions)


-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal :: String
myTerminal = "x-terminal-emulator"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = True


-- Width of the window border in pixels.
--
-- myBorderWidth :: Dimension
myBorderWidth   = 2 

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
               $ [" \xf269 ", " \xf113 ", " \xf2d0 ", " \xf27a ", " \xf25b "]
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
myNormalBorderColor  = "#282c34"

myFocusedBorderColor :: String
myFocusedBorderColor = "46d9ff"

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
    
    -- google chrome
    , ((modm,               xK_g    ), spawn "google-chrome")
    -- firefox
    , ((modm,               xK_f    ), spawn "firefox")
    -- nemo (file explorer in mint)
    , ((modm .|. shiftMask, xK_n    ), spawn "nemo")

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
    , ((0, xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
    , ((0, xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")


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
    --Resize windows height
    , ((modm,               xK_Left),   sendMessage MirrorExpand)
    , ((modm,               xK_Up),     sendMessage MirrorExpand)
    , ((modm,               xK_Right),  sendMessage MirrorShrink)
    , ((modm,               xK_Down),   sendMessage MirrorShrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    --Switch to next workspace using arrow keys
    , ((modm              , xK_Right), nextWS)

    , ((modm             , xK_Left), prevWS)

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    , ((modm              , xK_b     ), sendMessage ToggleStruts)

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
-- * new setting pt.2 begins here *

myWindowGap = 4  :: Integer -- this determines distance between two windows

mySpacing :: Integer -> l a -> ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

tall =
  renamed [Replace "Tall"] $
    mySpacing myWindowGap $
        ResizableTall 1 (3/100) (1/2) []

wide =
  renamed [Replace "Wide"] $
    mySpacing myWindowGap $
        Mirror (Tall 1 (3 / 100) (1 / 2))

full =
  renamed [Replace "Full"] $
    mySpacing myWindowGap $
        Full

myLayout =
  avoidStruts $ smartBorders myDefaultLayout
  --smartBorders myDefaultLayout
  where
    myDefaultLayout = full ||| tall ||| Mirror tall ||| Full 

-- * new settings pt.2 ends here

-- * old settings begin here
-- myLayout = avoidStruts (tiled ||| Mirror tiled ||| Full)
  -- where
    --  default tiling algorithm partitions the screen into two panes
    --  tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
    --  nmaster = 1

     -- Default proportion of screen occupied by master pane
    --  ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
    --  delta   = 3/100
-- * old setting ends here *

-- *dt window setting start here *
--Makes setting the spacingRaw simpler to write. The spacingRaw module adds a configurable amount of space around windows.
-- mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
-- mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
-- mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
-- mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- setting colors for tabs layout and tabs sublayout.
-- myTabTheme = def { fontName            = myFont
--                  , activeColor         = color15
--                  , inactiveColor       = color08
--                  , activeBorderColor   = color15
--                  , inactiveBorderColor = colorBack
--                  , activeTextColor     = colorBack
--                  , inactiveTextColor   = color16
--                  }

-- Defining a bunch of layouts, many that I don't use.
-- limitWindows n sets maximum number of windows displayed for layout.
-- mySpacing n sets the gap size around the windows.
-- tall     = renamed [Replace "Tall"]
          --  $ smartBorders
          --  $ windowNavigation
          --  $ addTabs shrinkText
          --  $ subLayout [] (smartBorders Simplest)
          --  $ limitWindows 12
          --  $ mySpacing 8
          --  $ ResizableTall 1 (3/100) (1/2) []
-- magnify  = renamed [Replace "magnify"]
          --  $ smartBorders
          --  $ windowNavigation
          --  $ addTabs shrinkText
          --  $ subLayout [] (smartBorders Simplest)
          --  $ magnifier
          --  $ limitWindows 12
          --  $ mySpacing 8
          --  $ ResizableTall 1 (3/100) (1/2) []
-- monocle  = renamed [Replace "monocle"]
          --  $ smartBorders
          --  $ windowNavigation
          --  $ addTabs shrinkText
          --  $ subLayout [] (smartBorders Simplest)
          --  $ limitWindows 20 Full
-- floats   = renamed [Replace "floats"]
          --  $ smartBorders
          --  $ limitWindows 20 simplestFloat
-- grid     = renamed [Replace "grid"]
          --  $ smartBorders
          --  $ windowNavigation
          --  $ addTabs shrinkText
          --  $ subLayout [] (smartBorders Simplest)
          --  $ limitWindows 12
          --  $ mySpacing 8
          --  $ mkToggle (single MIRROR)
          --  $ Grid (16/10)
-- spirals  = renamed [Replace "spirals"]
          --  $ smartBorders
          --  $ windowNavigation
          --  $ addTabs shrinkText
          --  $ subLayout [] (smartBorders Simplest)
          --  $ mySpacing' 8
          --  $ spiral (6/7)
-- threeCol = renamed [Replace "threeCol"]
          --  $ smartBorders
          --  $ windowNavigation
          --  $ addTabs shrinkText
          --  $ subLayout [] (smartBorders Simplest)
          --  $ limitWindows 7
          --  $ ThreeCol 1 (3/100) (1/2)
-- threeRow = renamed [Replace "threeRow"]
          --  $ smartBorders
          --  $ windowNavigation
          --  $ addTabs shrinkText
          --  $ subLayout [] (smartBorders Simplest)
          --  $ limitWindows 7
           -- Mirror takes a layout and rotates it by 90 degrees.
           -- So we are applying Mirror to the ThreeCol layout.
          --  $ Mirror
          --  $ ThreeCol 1 (3/100) (1/2)
-- tabs     = renamed [Replace "tabs"]
           -- I cannot add spacing to this layout because it will
           -- add spacing between window and tabs which looks bad.
          --  $ tabbed shrinkText myTabTheme
-- tallAccordion  = renamed [Replace "tallAccordion"]
          --  $ Accordion
-- wideAccordion  = renamed [Replace "wideAccordion"]
          --  $ Mirror Accordion



-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:Ubuntu:bold:size=60"
    , swn_fade              = 1.0
    , swn_bgcolor           = "#1c1f24"
    , swn_color             = "#ffffff"
    }

-- The layout hook
-- myLayoutHook = avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts floats
              --  $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
            --  where
              --  myDefaultLayout =     withBorder myBorderWidth tall
                                --  ||| magnify
                                --  ||| noBorders monocle
                                --  ||| floats
                                --  ||| noBorders tabs
                                --  ||| grid
                                --  ||| spirals
                                --  ||| threeCol
                                --  ||| threeRow
                                --  ||| tallAccordion
                                --  ||| wideAccordion

-- * dt window settings end here

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
    , className =? "Gnome-terminal"          --> doShift (myWorkspaces !! 2) -- 'sh'
    , className =? "Spotify"        --> doF (W.shift "fun") -- 'fun'
    , className =? "firefox" --> doShift (myWorkspaces !! 0)
    , className =? "Google-chrome" --> doShift (myWorkspaces !! 0)
    , className =? "Code" --> doShift (myWorkspaces !! 1) -- code
    , className =? "Gimp"           --> doFloat
    , stringProperty "_NET_WM_NAME" =? "Emulator" --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource =? "brave-browser" --> doF (W.shift "web") --web
    
    , resource  =? "kdesktop"       --> doIgnore
    , isFullscreen --> doFullFloat
    ]


newManageHook = myManageHook <+> manageHook def




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
  spawnOnce "picom -b --experimental-backend --backend glx" -- https://stackoverflow.com/a/61691596/7116645 refer this answer for doing this
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
        manageHook         = newManageHook,
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
