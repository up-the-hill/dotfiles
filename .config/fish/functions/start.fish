function start
    make
    sudo insmod recur.ko
    sudo dmesg
    sudo mknod /dev/recur/ c 237 0
end
