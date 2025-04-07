#!/bin/bash
#
#          _nnnn_
#         dGGGGMMb
#        @p~qp~~qMb
#        M|@||@) M|
#        @,----.JM|
#       JS^\__/  qKL
#      dZP        qKRb
#     dZP          qKKb
#    fZP            SMMb
#    HZM            MMMM
#    FqM            MMMM
#  __| ".        |\dS"qML
#  |    `.       | `' \Zq
# _)      \.___.,|     .'
# \____   )MMMMMP|   .'
#      `-'       `--'
#
# Numen Installer
# By: 16BitMiker (v2024-11-03)
#
# ~~~~~~~~~~~~~~~~ BEGIN

# Enable debugging output
set -x

# Exit on error
set -e

# ~~~~~~~~~~~~~~~~ UPDATES

sudo DEBIAN_FRONTEND=noninteractive apt update -y
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
sudo DEBIAN_FRONTEND=noninteractive apt dist-upgrade -y

# ~~~~~~~~~~~~~~~~ PERL INSTALLER

perl -Mutf8 -M'open qw(:std :utf8 :encoding(UTF-8))' -MTerm::ANSIColor=':constants' -nE'

$|++;

sub type
{
    my $cmd = shift;
    $cmd =~ s~.~select(undef, undef, undef, rand(0.03)); print $&~sger
}

sub run
{
	no warnings;
	my $cmd = shift; # cmd
	print q(> ), GREEN q();
	type( $cmd );
	say RESET q();
	system $cmd;
	if ( $? != 0 )
	{
	    print q(> );
	    print BOLD UNDERLINE RED;
	    type qq(Fail: Command "$_" exited with status @{[$? >> 8]}\n);
	    say RESET qq();
	    # sleep 1;
	    exit 69;
	}
	use warnings;
}

chomp;

s~^(?!\#|$)(.*)$~run($1)~merg unless m~^$~;

END
{
    print q(> RUN: );
    say YELLOW BOLD UNDERLINE q|source $HOME/.bashrc|, RESET;
}

' <<'END_OF_INPUT'
# will be installed in $HOME/git
sudo apt update
sudo apt install python3-pip -y
sudo apt install python-is-python3 -y

sudo apt install python3.12-venv -y || (sudo apt install python3.11-venv -y || sudo apt install python3.10-venv -y) && (python3.12 -m venv testenv && echo "Python 3.12 venv installed correctly." || (python3.11 -m venv testenv && echo "Python 3.11 venv installed correctly." || (python3.10 -m venv testenv && echo "Python 3.10 venv installed correctly." || echo "Neither venv is installed correctly.")))

# Try to install Python 3.11 venv
# sudo apt install python3.11-venv -y || true

# If 3.11 fails, try 3.10 (this was successful)
# command -v python3.11 >/dev/null 2>&1 || sudo apt install python3.10-venv -y || true

# If both fail, try 3.9 (not needed, commenting out)
# command -v python3.10 >/dev/null 2>&1 || sudo apt install python3.9-venv -y || true

# Check if any venv was installed (not needed since 3.10 was successful, commenting out)
# command -v python3.9 >/dev/null 2>&1 || echo "Unable to install Python venv. Please check your system's available Python versions."

python3 -m venv $HOME/python
bash -c "source $HOME/python/bin/activate && pip install vosk"
# To deactivate the virtual environment, you can use: deactivate

mkdir -p $HOME/git
cd $HOME/git && git clone https://git.sr.ht/~geb/numen

cd $HOME/git/numen && ./get-vosk.sh
cd $HOME/git/numen && sudo ./get-vosk.sh install
cd $HOME/git/numen && ./get-model.sh
cd $HOME/git/numen && sudo ./get-model.sh install

sudo apt install -y golang scdoc libxkbcommon-dev

cd $HOME/git/numen && ./get-dotool.sh
cd $HOME/git/numen && sudo ./get-dotool.sh install
cd $HOME/git/numen && ./build.sh
cd $HOME/git/numen && sudo ./build.sh install

sudo groupadd -f input
sudo usermod -a -G input $USER

# start
# screen -dmS numen numen
# stop
# screen -S numen -X quit

echo "alias numb='screen -dmS numen numen'" | tee -a $HOME/.bashrc
echo "alias numx='screen -S numen -X quit'" | tee -a $HOME/.bashrc

# reboot
# sudo reboot
# echo "> reboot for changes to take effect! "

END_OF_INPUT

# Disable debugging output
set +x

echo ""
# Check if a reboot is needed
if [ -f /var/run/reboot-required ]; then
    echo "A reboot is required"
    # Uncomment the next line if you want to automatically reboot
    # sudo reboot
fi
