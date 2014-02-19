# Copyright 2014 Nikita Pichugin
#
# This file is part of My Game Library 2.
# 
# My Game Library 2 is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# My Game Library 2 is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with My Game Library 2.  If not, see <http://www.gnu.org/licenses/>.

package MGDB;

use autodie;

sub load_db
{
    my $dirname = shift;
    my @answer;

    opendir my ($dirhandle), $dirname;
    my @files = sort readdir $dirhandle;
    closedir $dirhandle;

    foreach my $file (@files)
    {
        next if $file eq ".";
        next if $file eq "..";
        open my $handle, "<", "$dirname/$file";
        my %entry;
        while (<$handle>)
        {
            my ($k, $v) = /^(.*?): (.*)$/;
            $entry{$k} = $v;
        }
        $entry{"_PATH"} = $file;
        push @answer, \%entry;
        close $handle;
    }

    return @answer;
}

sub lookup_db
{
    my ($dbref, $query) = @_;
    my ($query_tag, $query_val, @result);

    if ($query =~ /^(.*?): (.*)$/)
    {
        ($query_tag, $query_val) = ($1, $2);
    }
    else
    {
        ($query_tag, $query_val) = ("Title", $query);
    }
    $query_val = ".*" if $query_val eq "";

    foreach my $entry (@{$dbref})
    {
        next if not exists $entry->{$query_tag};
        if ($entry->{$query_tag} =~ /$query_val/i)
        {
            push @result, $entry;
        }
    }

    return @result;
}

sub display_db
{
    my $dbref = shift;
    my $counter = 1;

    foreach my $entry (@{$dbref})
    {
        my $indent = " " x length "[$counter]";
        print "[$counter] $entry->{'Title'}\n";
        foreach my $tag (sort keys %{$entry})
        {
            if($tag !~ /^(Title|Command|_PATH)$/)
            {
                print "$indent $tag: $entry->{$tag}\n";
            }
        }
        print "\n";
        $counter++;
    }

    return 1;
}

1;
