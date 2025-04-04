##=========================================================
## OPTIONS
while [[ ${#@} -gt 0 ]] ; do
        key="${1}"
        case "$key" in
   i)
                shift;
    LWAIT=$1
   ;;
         s)
                shift;
    SWAIT=$1
   ;;
         m)
    DO_GM=1
   ;;
         nom)
    DO_GM=0
   ;;
         mo)
    DO_GM=2
   ;;
  esac;
  shift;
done
# =========================================================

##### if  [ -z "$LWAIT" ] || [ $LWAIT==0 ] ; then LWAIT=10000000   ; fi  #####
##### ## omitting now bc it was persisting overriding value for LWAIT
##### ## .. and therefore not triggering the subroutine.
##### if  [ -z "$SWAIT" ] || [ $SWAIT==0 ] ; then SWAIT=$DEF_SWAIT ; fi
printf " setting LWAIT interval: [cat>> sim.log] : ${LWAIT} \n"

# =========================================================
