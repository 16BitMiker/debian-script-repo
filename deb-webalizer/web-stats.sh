#!/bin/bash

# To install webalizer:
# sudo apt update
# sudo apt install apache2-utils -y
# sudo apt install webalizer

perl -MTerm::ANSIColor=:constants -nE '

    chomp;
    next if m~^$|^\#~;
    print RESET q|> |;
    print GREEN BOLD q||;

    s~(WEBY)|OUTPUT~

        $1
        ? $ENV{WEBALIZER_CONF}
        : $ENV{WEBALIZER_OUTPUT}

    ~ge;

    type( $_ );
    say RESET q||;

    system $_;

    BEGIN
    {
        $|++;

        do {

            print q|> Missing: |;
            print RED BOLD q|$WEBALIZER_CONF|;
            print RESET q| and |;
            print RED BOLD q|$WEBALIZER_OUTPUT|;
            say RESET q||;
            exit 69;

        } unless $ENV{WEBALIZER_CONF} and $ENV{WEBALIZER_OUTPUT};
    }

    sub type
    {
        chomp( my $text = shift );
        $text =~ s~.~select(undef, undef, undef, rand(0.03)); print $&~sger;
    }

    END
    {
        print q|> |;
        say GREEN BOLD q|Bye bye!|, RESET;
    }

' <<'WEBALIZER'
/usr/bin/webalizer -c WEBY
cd OUTPUT && /usr/bin/perl -i -ple 's`(\d{1,3})\.\K(?1)\.(?1)\.(?1)`XXX.XXX.XXX`g' *.html
cd OUTPUT && /usr/bin/perl -i -ple 's`</H2>`$&<p>[ <a href="../">BACK...</a> ]</p>`' *.html
cd OUTPUT && /usr/bin/perl -i -ple 's`<HEAD>\K`<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=yes">`' *.html
sudo chown -vR $USER:www-data OUTPUT
sudo chmod -vR 775 OUTPUT
# cd -
WEBALIZER
