
cd `dirname $0`

echo '-- start watching'

jade -O page/ -wP src/*jade &
stylus -o page/ -w src/*styl &
doodle page/ coffee/ &

read

pkill -f jade
pkill -f stylus
pkill -f doodle

echo '-- stop watching'