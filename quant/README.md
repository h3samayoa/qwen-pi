nix develop

nix build .#llama-cpp

huggingface-cli download qwen3 0.6B 

llama-quantize to 8/5 bit