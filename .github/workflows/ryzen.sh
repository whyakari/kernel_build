name: Build Kernel (KSU) RyzenKernel

on:
  workflow_dispatch

env:
  TOKEN_GITHUB: ${{ secrets.TOKEN_GITHUB }}

jobs:
  ci:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v2

      - name: Clone Repo Kernel
        uses: whyakari/github-repo-action@v3.1
        with:
          depth: 1
          branch: 'fourteen-ksu'
          owner: 'whyakari'
          repository: 'android_kernel_xiaomi_ginkgo_ryzen'
          access-token: ${{ secrets.TOKEN_GITHUB }}

      - name: Clone Repo Build
        uses: whyakari/github-repo-action@v3.1
        with:
          owner: 'whyakari'
          repository: 'kernel_build'
          access-token: ${{ secrets.TOKEN_GITHUB }}

      - name: Restore Cache
        uses: actions/cache@v3
        with:
          path: /home/runner/tc
          key: ${{ runner.os }}-tc
        id: tc-cache 

      - name: Move Script Clang
        working-directory: kernel_build
        run: |
          chmod +x clang.sh
          cp clang.sh ../android_kernel_xiaomi_ginkgo_ryzen

      - name: Clone Repo Scripts
        uses: whyakari/github-repo-action@v3.1
        with:
          depth: 1
          branch: 'main'
          owner: 'whyakari'
          repository: 'scripts'
          access-token: ${{ secrets.TOKEN_GITHUB }}

      - name: Move Scripts to Kernel
        working-directory: scripts
        run: |
          chmod +x ksu_update.sh
          cp build_counter.txt ksu_update.sh ci_build.py ../android_kernel_xiaomi_ginkgo_ryzen

      - name: Github set Config
        working-directory: ./android_kernel_xiaomi_ginkgo_ryzen
        run: |
          git config --global user.email "akariondev@gmail.com"
          git config --global user.name "ginkgo"
  
      - name: Install Dependencies
        run: |
         sudo apt-get update
         sudo apt-get -y --no-install-recommends install python3 python3-pip git make gcc bc bison flex libssl-dev ccache libelf-dev libncurses-dev bc binutils-dev ca-certificates clang cmake curl file flex git libelf-dev libssl-dev lld make ninja-build python3-dev texinfo u-boot-tools xz-utils zlib1g-dev
      
      - name: Pip Install Packages
        working-directory: ./android_kernel_xiaomi_ginkgo_ryzen
        run: |
          pip install Pyrogram TgCrypto

      - name: Compile Kernel CI
        working-directory: ./android_kernel_xiaomi_ginkgo_ryzen
        run: |
          python3 ci_build.py -t development # release

      - name: Copy File to Scripts
        working-directory: ./android_kernel_xiaomi_ginkgo_ryzen
        run: |
          cp build_counter.txt ../scripts

      - name: Commit Update
        working-directory: ./scripts
        run: |
          git add build_counter.txt
          git commit -m "update build counter"
          git push origin main --force
