#!/bin/bash


runFunc() {
  echo "RUNNING $1" >> $LOG
  $1 2>&1 | tee -a $LOG
  echo "DONE RUNNING $1" >> $LOG
  for i in {0..4}; do echo "" >> $LOG; done
}


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
                      python3-pip     \
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
  sudo chown $(whoami):$(whoami) /opt/google/chrome/extensions

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

  code --install-extension ms-vscode.cpptools
  code --install-extension vsciot-vscode.vscode-arduino
  code --install-extension platformio.platformio-ide

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



gimp() {
  sudo add-apt-repository ppa:otto-kesselgulasch/gimp
  sudo apt update
  sudo apt install -y gimp
}



lutris(){
  sudo add-apt-repository -y ppa:lutris-team/lutris
  sudo apt install -y lutris
}



network(){

  local conf="/etc/NetworkManager/system-connections/Wired\ connection\ 2.nmconnection"

cat <<'EOF' >> "$conf"
[connection]
id=Internal Netowrk
uuid=f0aef0cd-e68e-3a3c-9785-80e703b3ade2
type=ethernet
autoconnect-priority=-999
interface-name=enx20aa4b45a7a0
permissions=
timestamp=1646606541


[ipv4]
address1=128.34.1.10/8,128.34.1.1
dns-search=
method=manual

EOF

  sudo chown root:root "$conf"
  sudo chmod 600 "$conf"
}



profile() {

  mkdir -p $HOME/Repos
  ssh-keygen -P "" -f $HOME/.ssh/id_rsa
  git config --global user.email "hello@ironbasement.com"
  git config --global user.name "Iron Basement"

cat <<'EOF' >> $HOME/.bashrc

. $HOME/Repos/seaworth/Docker/httpd/php-apache/src/spotifyUtils.sh

alias cda="cd $HOME/Repos/seaworth/Docker/httpd/"
alias cdr="cd $HOME/Repos

alias add-ip='sudo ip addr add 128.34.1.12/24 dev wlp1s0 label wlp1s0:1'
alias single='xrandr --output HDMI-A-0 --off; xrandr --output HDMI-A-1 --off'
alias monitors='xrandr --output HDMI-A-0 --auto;xrandr --output HDMI-A-1 --auto'
alias fix-routes='sudo route del -net 0.0.0.0/0 gw 192.168.50.1 dev wlp1s0; \
                  sudo route del -net 192.168.50.0/24 gw 0.0.0.0 dev wlp1s0'

alias temp="echo $(( $(sensors | \
                       sed -n '/edge/s/^.*+//p' | \
                       sed 's/\.[0-9]*.C//g') \
                  * 9 / 5 + 32))"


alias fix-route2='sudo route del             \
                            -net 0.0.0.0    \
                            gw 128.34.1.1   \
                            netmask 0.0.0.0 \
                            dev enx20aa4b45a7a0'


EOF

}

# NOTE: Have to reboot for this change to take effect
realtekWifi(){
  sudo apt update -y
  sudo apt install rtl8821ce-dkms -y
}

LOG=$(pwd)/log_$(date +%s)

funcs='basePackages
            #openSSH
            #virtualBox
            #chrome
            #arduino
            #vscode
            #discord
            #spotify
            #docker
            #minecraft
            #signal
            #kicad
            #bluetooth
            #gimp
            #lutris
            #network
            #realtekWifi
            profile'

for func in $funcs; do
  echo "$func"
  runFunc $func
done
