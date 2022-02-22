#!/bin/bash


addKey(){
  wget -O- $1 | sudo apt-key add -
}


basePackages() {

  sudo apt install -y net-tools       \
                      wget            \
                      curl            \
                      ca-certificates \
                      gnupg           \
                      lsb-release     \
                      librecad        \
                      git

}



openSSH() {
  sudo apt install -y openssh-server
  sudo systemctl enable ssh
  sudo systemctl start ssh
}


virtualBox() {
  sudo apt -y install virtualbox
  sudo apt -y install virtualbox—ext–pack
}


addChromeExtension () {
  preferences_dir_path="/opt/google/chrome/extensions"
  pref_file_path="$preferences_dir_path/$1.json"
  upd_url="https://clients2.google.com/service/update2/crx"
  mkdir -p "$preferences_dir_path"
  echo "{" > "$pref_file_path"
  echo "  \"external_update_url\": \"$upd_url\"" >> "$pref_file_path"
  echo "}" >> "$pref_file_path"
  echo Added \""$pref_file_path"\" ["$2"]
}



chrome() {

  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt install ./google-chrome-stable_current_amd64.deb

  sudo mkdir -p /opt/google/chrome/extensions
  sudo chown nphillips:nphillips /opt/google/chrome/extensions

  addChromeExtension "cjpalhdlnbpafiamejdnhcphjbkeiagm" "ublock origin"
  addChromeExtension "bmnlcjabgnpnenekpadlanbbkooimhnj" "Honey"
  addChromeExtension "kgeglempfkhalebjlogemlmeakondflc" "Twitch ad block"
  addChromeExtension "hdokiejnpimakedhajhdlcegeplioahd" "LastPass"

  rm google-chrome-stable_current_amd64.deb
}


vscode() {

  sudo apt install -y software-properties-common apt-transport-https

  wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | \
       sudo apt-key add -
                    
  sudo add-apt-repository "deb                                         \
                           [arch=amd64]                                \
                           https://packages.microsoft.com/repos/vscode \
                           stable                                      \
                           main"


  sudo apt install code

}



discord() {
  sudo snap install discord
}



spotify() {

  addKey https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg

  echo "deb http://repository.spotify.com stable non-free" | \
    sudo tee /etc/apt/sources.list.d/spotify.list

  sudo apt update
  sudo apt install -y spotify-client

}



docker() {

   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
     sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt update
  sudo apt install -y docker-ce     \
                      docker-ce-cli \
                      containerd.io \
                      docker-compose

}


minecraft() {
  wget https://launcher.mojang.com/download/Minecraft.deb
  sudo dpkg -i Minecraft.deb
  rm Minecraft.deb
}




signal() {

  sudo snap install signal-desktop
  return

  addKey https://updates.signal.org/desktop/apt/keys.asc

  echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | \
    sudo tee -a /etc/apt/sources.list.d/signal-xenial.list

  sudo apt update
  sudo apt install -y signal-desktop

}



kicad() {
  sudo add-apt-repository --yes ppa:kicad/kicad-6.0-releases
  sudo apt update
  sudo apt install -y --install-recommends kicad
}



arduino() {

  local ver='1.8.15'
  local arduino="arduino-$ver-linux64.tar.xz"

  wget https://downloads.arduino.cc/$arduino
  tar -xvf $arduino

  pushd arduino-$ver >> /dev/null
    sudo ./install.sh
    sudo usermod -a -G dialout $(whoami)
  popd >> /dev/null

}



bluetooth() {

  wget https://raw.githubusercontent.com/Realtek-OpenSource/android_hardware_realtek/rtk1395/bt/rtkbt/Firmware/BT/rtl8761b_config
  wget https://raw.githubusercontent.com/Realtek-OpenSource/android_hardware_realtek/rtk1395/bt/rtkbt/Firmware/BT/rtl8761b_fw

  sudo mv rtl8761b_config /usr/lib/firmware/rtl_bt/rtl8761b_config.bin
  sudo mv rtl8761b_fw     /usr/lib/firmware/rtl_bt/rtl8761b_fw.bin

  sudo systemctl enable bluetooth
  sudo systemctl restart bluetooth

}



profile() {

  mkdir $HOME/Repos
  ssh-keygen -P "" -f $HOME/.ssh/id_rsa
  git config --global user.email "hello@ironbasement.com"
  git config --global user.name "Iron Basement"



}

basePackages
#openSSH
#virtualBox
#chrome
#vscode
#discord
#spotify
#docker
#minecraft
#signal
#kicad
#arduino
bluetooth
#profile
