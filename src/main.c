#define uint32_t int

__asm__attribute( (noreturn) ) void BootJumpASM( uint32_t SP, uint32_t RH) {
    MSR     MSP,r0
    BS      r1
}

int main() {
    return 0;
}
