from subprocess import Popen, PIPE

with open("/sys/class/power_supply/BAT0/charge_now") as f:
    charge_now = float(f.read())
with open("/sys/class/power_supply/BAT0/charge_full") as f:
    charge_full = float(f.read())

percent = 100 * charge_now/charge_full

if percent < 20:
    p = Popen(['osd_cat', '-A', 'center', '-p', 'middle', '-f', '-*-*-bold-*-*-*-36-120-*-*-*-*-*-*', '-cred', '-s', '5'], stdin=PIPE)
    p.communicate(input="Battery Low!")
    p.wait()

