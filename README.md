# sec-freebsd

secure freebsd

wget https://github.com/tusharxoxoxo/sec-freebsd/archive/refs/heads/main.zip

mkdir setup

mv main.zip setup/

cd setup

unzip main.zip

cd sec-freebsd-main

chmod +x setup_pf_lan_only.sh
chmod +x remove_pf_lan_only.sh

./setup_pf_lan_only.sh

./remove_pf_lan_only.sh
