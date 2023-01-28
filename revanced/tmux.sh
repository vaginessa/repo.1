#!/bin/bash

clear
HOMEDIR="$PWD" ## /data/data/com.termux/files/home/dev/revanced

##########

# This restarts the script.

rerun_script ()
{
echo "Restarting Script"
for zdf in {3..1} ; do
  echo "$zdf"
  sleep 1
done
./$0
}

##########

# This downloads the ReVanced CLI, Integrations, and Patches.

prerequisites ()
{
clear
cd $HOMEDIR/assets/temp
check_rv=$(ls cli/*.jar)
if [[ -z "$check_rv" ]] ; then
  pkg upgrade openjdk-17
  pkg upgrade wget
  pkg upgrade jq
  pkg upgrade aapt
  pkg upgrade zipalign
  chmod +x download.prerequisites.sh && ./download.prerequisites.sh && cd $HOMEDIR
  echo "ReVanced Prerequisites Updated/Installed"
elif [[ -n "$check_rv" ]] ; then
  echo "ReVanced Prerequisites Already Updated/Installed"
fi
cd $HOMEDIR
}

##########

# This patches the packages.

select_apk ()
{
clear

if [ -f "$HOMEDIR/packages/$APKS/output/*.apk" ] ; then
  echo "Already patched, skipping download..."
else
  mkdir $HOMEDIR/packages/$APKS/versions
  cp $HOMEDIR/assets/versions/latest/versions.json $HOMEDIR/packages/$APKS/versions
  cp $HOMEDIR/assets/patches/*.patch $HOMEDIR/packages/$APKS
  cp $HOMEDIR/assets/temp/cli/*.jar $HOMEDIR/packages/$APKS/cli.jar
  cp $HOMEDIR/assets/temp/integrations/*.apk $HOMEDIR/packages/$APKS/integrations.apk
  cp $HOMEDIR/assets/temp/patches/*.jar $HOMEDIR/packages/$APKS/patches.jar
  cd $HOMEDIR/packages/$APKS
  chmod +x download.sh && ./download.sh
  chmod +x compile.sh && ./compile.sh experimental
  rm -rf *.jar *.apk *.patch versions
fi
cd $HOMEDIR
}

##########

# This signs the the packages.

sign_and_move_packages ()
{
clear

echo "Downloading signer..."
if [ -f "$HOMEDIR/signer.jar" ] ; then
  echo "APK Signer already downloaded..."
else
  wget -nv https://github.com/patrickfav/uber-apk-signer/releases/download/v1.2.1/uber-apk-signer-1.2.1.jar
  mv uber-apk-signer-1.2.1.jar signer.jar
fi

if [ -f "$HOMEDIR/release/$APKS.apk" ] ; then
  echo "Already signed, skip signing..."
else
  echo "Making directories..."
  mkdir $HOMEDIR/packages/$APKS/output/release
  mkdir $HOMEDIR/release

  echo "Signing packages..."
  java -jar signer.jar --allowResign -a $HOMEDIR/packages/$APKS/output -o $HOMEDIR/packages/$APKS/output/release
  mv -v $HOMEDIR/packages/$APKS/output/release/*.apk $HOMEDIR/release/$APKS.apk
fi

echo "Moving the packages..."
cd /
mkdir /storage/emulated/0/ReVanced
rm -f /storage/emulated/0/ReVanced/$APKS.apk
mv $HOMEDIR/release/*.apk /storage/emulated/0/ReVanced
cd $HOMEDIR

}

##########

# This is the case function in menu.

uncased ()
{
APKS="$MKMF"
select_apk
sign_and_move_packages
unset APKS
}

##########

# This updates the repo.

update_script ()
{
clear
git reset --hard
git pull
chmod +x tmux.sh
clear
}

##########

# This shows the script info.

script_info ()
{
echo "
THE SCRIPT IS UNDER DEVELOPMENT.

In this script, you can patch the
supported Revanced applications without
even using the official ReVanced Manager.

If you already have Termux,
why do bother installing the
ReVanced Manager when you can
patch it in here?

All the patched packages are
moved in the ReVanced folder in
the internal storage.
"
read -n 1 -s -r -p "Press any key to continue..."
clear
echo "
Please select a number...
"
}

##########

# This is a menu selection.

menu_select()
{
select ZXYX in "Install Prerequisites" "Patch Packages" "Update Script" "Script Info" "Exit Script"
do
  case $ZXYX in
    "Install Prerequisites") prerequisites && rerun_script && break ;;
    "Patch Packages") 
      select MKMF in "backdrops" "citra.emulator" "icon.pack.studio" "nova.launcher" "nyx.music.player/64.v8a" "nyx.music.player/v7a" "nyx.music.player/x86.64" "nyx.music.player/x86" "reddit" "spotify" "ticktick/64.v8a" "ticktick/v7a" "ticktick/x86.64" "ticktick/x86" "tiktok" "twitch" "twitter" "youtube.music/64.v8a" "youtube.music/v7a""youtube.music/x86.64" "youtube.music/x86" "youtube" "Return Back"
      do
        case $MKMF in
          "backdrops") uncased ;;
          "citra.emulator") uncased ;;
          "icon.pack.studio") uncased ;;
          "nova.launcher") uncased ;;
          "nyx.music.player/64.v8a") uncased ;;
          "nyx.music.player/v7a") uncased ;;
          "nyx.music.player/x86.64") uncased ;;
          "nyx.music.player/x86") uncased ;;
          "reddit") uncased ;;
          "spotify") uncased ;;
          "ticktick/64.v8a") uncased ;;
          "ticktick/v7a") uncased ;;
          "ticktick/x86.64") uncased ;;
          "ticktick/x86") uncased ;;
          "tiktok") uncased ;;
          "twitch") uncased ;;
          "twitter") uncased ;;
          "youtube.music/64.v8a") uncased ;;
          "youtube.music/v7a") uncased ;;
          "youtube.music/x86.64") uncased ;;
          "youtube.music/x86") uncased ;;
          "youtube") uncased ;;
          "Return Back") clear && menu_select && break ;;
          *) echo "Command not valid." ;;
        esac
      done ;;
    "Update Script") update_script && rerun_script && break ;;
    "Script Info") script_info ;;
    "Exit Script") clear && break && exit ;;
    *) echo "Command not valid." ;;
  esac
done
}

##########

# This is a welcome message.

wlcmsg ()
{
clear
cat assets/banner/scpf.logo.txt
sleep 2
script_info
}

##########

# This is the main function.

wlcmsg && menu_select

##########
