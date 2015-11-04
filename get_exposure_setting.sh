# A mapper for v4l2-ctl's exposure probe
# Automatic exposure = 3
# Manual exposure = 1

test=`v4l2-ctl -d $CAMERA -C exposure_auto`
  if [ "$test" == "exposure_auto: 3" ];
    then
      return 3
  elif [ "$test" == "exposure_auto: 1" ];
    then
      return 1
  fi
return -1
