use Test::More;
use strict;

use API::Beanstalk;

my $api = API::Beanstalk->new(
    account_name => 'testinbeanstalk2g',
    username => 'testbeanstalk',
    password => $ENV{'TEST_BEANSTALK_PASS'}
);

my $data = $api->get_account;
cmp_ok('testinbeanstalk2g', 'eq', $data->{'third-level-domain'}, 'content');

done_testing;