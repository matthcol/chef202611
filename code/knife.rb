# Config utilisée depuis le container "workstation" (docker-compose), où ce
# dossier est monté sur /workdir. Le self-signed cert de chef-server (démo
# locale) n'est pas vérifié : ssl_verify_mode :verify_none.
chef_server_url 'https://chef-server/organizations/formation'
node_name 'admin'
client_key '/workdir/keys/admin.pem'
ssl_verify_mode :verify_none

