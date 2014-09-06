# Install git
sudo apt-get install git

# Create gatewayd directory
mkdir gatewayd
chmod 777 gatewayd

# Clone the required branch/tag of the repo from Github into the gatewayd directory
# git clone https://github.com/ripple/gatewayd.git -b v3.22.1 gatewayd
git clone https://github.com/ripple/gatewayd.git gatewayd

# Now change to gatewayd directory
cd gatewayd

# Node.js and dependencies:
sudo apt-get -y install git python-software-properties python g++ make libpq-dev
sudo add-apt-repository -y ppa:chris-lea/node.js
sudo apt-get -y update
sudo apt-get -y install nodejs postgresql postgresql-client

#  Install gatewayd's dependencies using NPM:
sudo npm install pm2 -g --unsafe-perm
sudo npm install pg -g
sudo npm install grunt -g
sudo npm install grunt-cli -g
sudo npm install forever -g
sudo npm install db-migrate -g 
sudo npm install jshint -g
npm install --save

# Configure Postgres
# First make sure that Postgres is installed:
sudo apt-get install postgresql postgresql-contrib

# Set the master password for postgres:
sudo -u postgres psql -U postgres -d postgres -c "alter user postgres with password 'postgres';"

# Create the postgres user for gatewayd:
sudo -u postgres psql -U postgres -d postgres -c "create user gatewayd_user with password 'password';"

# Create the database and grant the created user as owner:
sudo -u postgres psql -U postgres -d postgres -c "create database gatewayd_db with owner gatewayd_user encoding='utf8';"
