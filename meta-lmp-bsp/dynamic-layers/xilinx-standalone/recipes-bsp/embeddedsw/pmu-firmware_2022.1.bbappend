# Allow EFUSE access, used by OP-TEE
YAML_COMPILER_FLAGS:append:zynqmp = " -DENABLE_EFUSE_ACCESS"

# Options set via meta-som at the BSP release
YAML_COMPILER_FLAGS:append:k26 = " -DBOARD_SHUTDOWN_PIN=2 -DBOARD_SHUTDOWN_PIN_STATE=0 -DENABLE_EM -DENABLE_MOD_OVERTEMP -DOVERTEMP_DEGC=90.0 -DCONNECT_PMU_GPO_2_VAL=0 -DENABLE_IOCTL"
# YAML_COMPILER_FLAGS:append:k26 = " -DENABLE_DYNAMIC_MIO_CONFIG" # Disabled as with ENABLE_EFUSE_ACCESS there is not enough PMU_RAM
