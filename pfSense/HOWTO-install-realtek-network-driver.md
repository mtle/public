## From root console:
```
# pkg rquery -e '%n~realtek-r*' '[%R] %n %v' | column -t
# pkg inf -D realtek-rge-kmod
# pkg install realtek-re-kmod
```

## Create or edit `/boot/loader.conf.local` and add:
```
if_re_load="YES"
if_re_name="/boot/modules/if_re.ko"
```

## Reboot the system and verify the driver is loaded using `kldstat`

