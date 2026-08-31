#include "../../libc-baremetal/include/led.h"
int fac(int n) {
    if (n == 1 || n == 0) {
        return 1;
    }
    if (n == 2 || n == 2) {
        return 2;
    }
    return n*fac(n-1);
}
int main() {
    seg_write_hex(fac(5));
}