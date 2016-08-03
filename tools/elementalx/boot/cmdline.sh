#!/sbin/sh

val1=$(cat /tmp/aroma/cpu0.prop | cut -d '=' -f2)

  case $val1 in
	1)
	  cpu_max_c1="cpu_max_c1=1728000"
	  ;;
	2)
	  cpu_max_c1="cpu_max_c1=1593600"
	  ;;
	3)
	  cpu_max_c1="cpu_max_c1=1478400"
	  ;;
	4)
	  cpu_max_c1="cpu_max_c1=1324800"
	  ;;
	5)
	  cpu_max_c1="cpu_max_c1=1228800"
	  ;;
  esac

val2=$(cat /tmp/aroma/cpu2.prop | cut -d '=' -f2)

  case $val2 in
	1)
	  cpu_max_c2="cpu_max_c2=2265600"
	  ;;
	2)
	  cpu_max_c2="cpu_max_c2=2150400"
	  ;;
	3)
	  cpu_max_c2="cpu_max_c2=1996800"
	  ;;
	4)
	  cpu_max_c2="cpu_max_c2=1824000"
	  ;;
	5)
	  cpu_max_c2="cpu_max_c2=1708800"
	  ;;
  	6)
	  cpu_max_c2="cpu_max_c2=1555200"
	  ;;
  esac

echo "cmdline = androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x237 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 cma=32M@0-0xffffffff" $cpu_max_c1 $cpu_max_c2 > /tmp/cmdline.cfg

