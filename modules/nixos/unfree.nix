{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "aseprite"
      "nvidia-x11"
      "nvidia-settings"

      "cuda-merged"
      "cuda_cuobjdump"
      "cuda_cudart"
      "cuda_cuxxfilt"
      "cuda_cupti"
      "libcublas"
      "libcufft"
      "libcurand"
      "libcusolver"
      "libcusparse"
      "libnvjitlink"
      "libnpp"
      "cuda_nvcc"
      "cuda_profiler_api"
      "cuda_nvrtc"
      "cuda_nvtx"
      "cuda_nvml_dev"
      "cuda_sanitizer_api"
      "cuda_cccl"
      "cuda_gdb"
      "cuda_nvdisasm"
      "cuda_nvprune"

      "corefonts"
      "vista-fonts"
      "claude-code"
      "vscode-extension-anthropic-claude-code"
      "obsidian"
      "reaper"
      "steam"
      "steam-unwrapped"
    ];
}
