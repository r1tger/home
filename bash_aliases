# Keep decrypted contents in memory only, use :WriteEncrypted from vim to save file
vimdecrypt() {
    openssl enc -d -aes-256-cbc -a -in "$1" | vim - -n -i "NONE" "+set filetype=$2";
}
alias vd="vimdecrypt"
# Transmission
alias trr='transmission-remote --auth="transmission:transmission"'
# Start an HTTP web server on localhost:8080 for current working directory
alias http='python -m SimpleHTTPServer 8080'
# Convert a FLAC file to MP3, stripping any non-alphanumeric characters
function flac2mp3() {
    # Strip & clean filename
    filename="${1##*/}"
    filename=$(echo ${filename%.*} | tr -cd "a-zA-Z0-9.\-& ")
    filename=$(python -c "l='$filename'.split(' - '); print('{a:.10} - {t:.10}'.format(a=l[0], t=l[2]))")
    # Decode flac and create MP3
    flac -c -d "$1" | lame -b160 - "$filename.mp3"
}
# Allow GNU Parallel to work with the flac2mp3 bash function
export -f flac2mp3
alias mixtape='find /media/storage/Music/ -iname *.flac | /home/ritger/Workspace/Shuffle/scripts/shuffle --size=4400 | parallel -u "flac2mp3 {}"'
