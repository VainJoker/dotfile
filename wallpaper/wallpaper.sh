#!/bin/bash
#                _ _                              
# __      ____ _| | |_ __   __ _ _ __   ___ _ __  
# \ \ /\ / / _` | | | '_ \ / _` | '_ \ / _ \ '__| 
#  \ V  V / (_| | | | |_) | (_| | |_) |  __/ |    
#   \_/\_/ \__,_|_|_| .__/ \__,_| .__/ \___|_|    
#                   |_|         |_|               
#  
# ----------------------------------------------------- 
# Check to use wallpaper cache
# ----------------------------------------------------- 

#if [ -f ~/.cache/wallpaper/wallpaper_cache ]; then
#    use_cache=1
#    echo ":: Using Wallpaper Cache"
#else
#    use_cache=0
#    echo ":: Wallpaper Cache disabled"
#fi

# ----------------------------------------------------- 
# Set defaults
# ----------------------------------------------------- 

force_generate=0
generatedversions="$HOME/.cache/wallpaper"
waypaperrunning=$HOME/.cache/wallpaper/waypaper-running
cachefile="$HOME/.cache/wallpaper/current_wallpaper"
blurredwallpaper="$HOME/.cache/wallpaper/blurred_wallpaper.png"
squarewallpaper="$HOME/.cache/wallpaper/square_wallpaper.png"
rasifile="$HOME/.cache/wallpaper/current_wallpaper.rasi"
blurfile="$HOME/.dotfiles/scripts/blur.sh"
defaultwallpaper="$HOME/Pictures/Wallpapers/wallpaper_1.jpg"
wallpapereffect="$HOME/.dotfiles/scripts/wallpaper-effect.sh"
blur="50x30"
blur=$(cat $blurfile)

# Ensures that the script only run once if wallpaper effect enabled
if [ -f $waypaperrunning ]; then
    rm $waypaperrunning
    exit
fi

# Create folder with generated versions of wallpaper if not exists
if [ ! -d $generatedversions ]; then
    mkdir $generatedversions
fi

# ----------------------------------------------------- 
# Get selected wallpaper
# ----------------------------------------------------- 

if [ -z $1 ]; then
    if [ -f $cachefile ]; then
        wallpaper=$(cat $cachefile)
    else
        wallpaper=$defaultwallpaper
    fi
else
    wallpaper=$1
fi
used_wallpaper=$wallpaper
echo ":: Setting wallpaper with source image $wallpaper"
tmpwallpaper=$wallpaper

# ----------------------------------------------------- 
# Copy path of current wallpaper to cache file
# ----------------------------------------------------- 

if [ ! -f $cachefile ]; then
    touch $cachefile
fi
echo "$wallpaper" > $cachefile
echo ":: Path of current wallpaper copied to $cachefile"

# ----------------------------------------------------- 
# Get wallpaper filename
# ----------------------------------------------------- 
wallpaperfilename=$(basename $wallpaper)
echo ":: Wallpaper Filename: $wallpaperfilename"

# ----------------------------------------------------- 
# Wallpaper Effects
# -----------------------------------------------------

if [ -f $wallpapereffect ]; then
    effect=$(cat $wallpapereffect)
    if [ ! "$effect" == "off" ]; then
	echo $effect
        used_wallpaper=$generatedversions/$effect-$wallpaperfilename
	echo $used_wallpaper
        if [ -f $generatedversions/$effect-$wallpaperfilename ] && [ "$force_generate" == "0" ] && [ "$use_cache" == "1" ]; then
            echo ":: Use cached wallpaper $effect-$wallpaperfilename"
        else
            echo ":: Generate new cached wallpaper $effect-$wallpaperfilename with effect $effect"
            dunstify "Using wallpaper effect $effect..." "with image $wallpaperfilename" -h int:value:33 -h string:x-dunst-stack-tag:wallpaper
            source $HOME/.dotfiles/wallpaper/effects/wallpaper/$effect
        fi
        echo ":: Loading wallpaper $generatedversions/$effect-$wallpaperfilename with effect $effect"
        echo ":: Setting wallpaper with $used_wallpaper"
        touch $waypaperrunning
        waypaper --wallpaper $used_wallpaper
    else
        echo ":: Wallpaper effect is set to off"
    fi
else
    effect="off"
fi

# ----------------------------------------------------- 
# Stop all running waybar instances
# ----------------------------------------------------- 

echo ":: Stop all running waybar instances"
killall waybar
pkill waybar

# ----------------------------------------------------- 
# Execute pywal
# ----------------------------------------------------- 

echo ":: Execute pywal with $used_wallpaper"
wal -q -i $used_wallpaper
source "$HOME/.cache/wal/colors.sh"

# ----------------------------------------------------- 
# Reload AGS
# -----------------------------------------------------

#echo ":: Reload ags"
#killall ags
#ags &

# ----------------------------------------------------- 
# Reload Waybar
# -----------------------------------------------------

~/.config/waybar/launch.sh

# ----------------------------------------------------- 
# Pywalfox
# -----------------------------------------------------

if type pywalfox > /dev/null 2>&1; then
    pywalfox update
fi

# ----------------------------------------------------- 
# Created blurred wallpaper
# -----------------------------------------------------

if [ -f $generatedversions/blur-$blur-$effect-$wallpaperfilename.png ] && [ "$force_generate" == "0" ] && [ "$use_cache" == "1" ]; then
    echo ":: Use cached wallpaper blur-$blur-$effect-$wallpaperfilename"
else
    echo ":: Generate new cached wallpaper blur-$blur-$effect-$wallpaperfilename with blur $blur"
    dunstify "Generate new blurred version" "with blur $blur" -h int:value:66 -h string:x-dunst-stack-tag:wallpaper
    magick $used_wallpaper -resize 75% $blurredwallpaper
    echo ":: Resized to 75%"
    if [ ! "$blur" == "0x0" ]; then
        magick $blurredwallpaper -blur $blur $blurredwallpaper
        cp $blurredwallpaper $generatedversions/blur-$blur-$effect-$wallpaperfilename.png
        echo ":: Blurred"
    fi
fi
cp $generatedversions/blur-$blur-$effect-$wallpaperfilename.png $blurredwallpaper

# ----------------------------------------------------- 
# Create rasi file
# ----------------------------------------------------- 

if [ ! -f $rasifile ]; then
    touch $rasifile
fi
echo "* { current-image: url(\"$blurredwallpaper\", height); }" > "$rasifile"

# ----------------------------------------------------- 
# Created square wallpaper
# -----------------------------------------------------

echo ":: Generate new cached wallpaper square-$wallpaperfilename"
magick $tmpwallpaper -gravity Center -extent 1:1 $squarewallpaper
cp $squarewallpaper $generatedversions/square-$wallpaperfilename.png

