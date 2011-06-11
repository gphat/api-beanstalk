package API::Beanstalk;
use Moose;

use Data::Dumper;
use LWP::UserAgent;
use URI;
use XML::Simple qw(XMLin);

# ABSTRACT: Profile based data verification with Moose type constraints.

=head1 SYNOPSIS

    use API::Beanstalk;

=head1 DESCRIPTION

Beanstalk XXX

=attr account_name

The account name to use when sending requests in.

=cut

has 'account_name' => (
    is => 'ro',
    isa => 'Str',
    required => 1
);

has '_client' => (
    is => 'ro',
    isa => 'LWP::UserAgent',
    lazy => 1,
    default => sub {
        my $self = shift;
        my $ua = LWP::UserAgent->new();
        $ua->credentials(
            $self->account_name.'.beanstalkapp.com:443', 'Web Password',
            $self->username, $self->password
        );
        return $ua;
    }
);

=attr password

The password to use when logging in.

=cut

has 'password' => (
    is => 'ro',
    isa => 'Str',
    required => 1
);

=attr url

The URL to use when working with the api.  Defaults to

  https://$accountname.beanstalkapp.com
  
=cut

has 'url' => (
    is => 'ro',
    isa => 'URI',
    lazy => 1,
    default => sub {
        my $self = shift;
        return URI->new('https://'.$self->account_name.'.beanstalkapp.com/');
    }
);

=attr username

The username to use when logging in.

=cut

has 'username' => (
    is => 'ro',
    isa => 'Str',
    required => 1
);

=method get_account

Get Account information.

=cut

sub get_account {
    my ($self) = @_;

    my $resp = $self->_client->get($self->url."api/account.xml");
    my $data = XMLin($resp->decoded_content);

    return {
        'third-level-domain' => $data->{'third-level-domain'},
        'name' => $data->{name},
        'plan-id' => $data->{'plan-id'}->{content},
        'time-zone' => $data->{'time-zone'},
        'owner-id' => $data->{'owner-id'}->{content},
        'suspended' => $data->{suspended}->{content} eq 'true' ? 1 : 0,
        'id' => $data->{id}->{content},
        'updated-at' => $data->{'updated-at'}->{content}
    };
}

__PACKAGE__->meta->make_immutable;

1;

__END__


=begin :postlude

=head1 CONTRIBUTORS

Me

=end :postlude

