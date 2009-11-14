use strict;
use warnings;

use Test::More;

plan 'no_plan';

use lib 't/lib';

use Test::Markdent;

{
    my $text = <<'EOF';
* one line
EOF

    my $expect = [
        {
            type => 'unordered_list',
        },
        [
            { type => 'list_item' },
            [
                {
                    type => 'text',
                    text => "one line\n",
                }
            ],
        ],
    ];

    parse_ok( $text, $expect, 'one line unordered list' );
}

{
    my $text = <<'EOF';
* l1
* l2
EOF

    my $expect = [
        {
            type => 'unordered_list',
        },
        [
            { type => 'list_item' },
            [
                {
                    type => 'text',
                    text => "l1\n",
                }
            ],
            { type => 'list_item' },
            [
                {
                    type => 'text',
                    text => "l2\n",
                }
            ],
        ],
    ];

    parse_ok( $text, $expect, 'two line unordered list' );
}

{
    my $text = <<'EOF';
* l1
   * l2
EOF

    my $expect = [
        {
            type => 'unordered_list',
        },
        [
            { type => 'list_item' },
            [
                {
                    type => 'text',
                    text => "l1\n",
                }
            ],
            { type => 'list_item' },
            [
                {
                    type => 'text',
                    text => "l2\n",
                }
            ],
        ],
    ];

    parse_ok( $text, $expect, 'two line unordered list, second list item has 3 space indent' );
}

{
    my $text = <<'EOF';
* l1
    * l2
* l3
EOF

    my $expect = [
        {
            type => 'unordered_list',
        },
        [
            { type => 'list_item' },
            [
                {
                    type => 'text',
                    text => "l1\n",
                }, {
                    type => 'unordered_list',
                },
                [
                    { type => 'list_item' },
                    [
                        {
                            type => 'text',
                            text => "l2\n",
                        }
                    ],
                ]
            ],
            { type => 'list_item' },
            [
                {
                    type => 'text',
                    text => "l3\n",
                }
            ],
        ],
    ];

    parse_ok( $text, $expect, 'unordered list with nested list as second item' );
}

{
    my $text = <<'EOF';
* l1
  continues
* l3
EOF

    my $expect = [
        {
            type => 'unordered_list',
        },
        [
            { type => 'list_item' },
            [
                {
                    type => 'text',
                    text => "l1\n  continues\n",
                },
            ],
            { type => 'list_item' },
            [
                {
                    type => 'text',
                    text => "l3\n",
                }
            ],
        ],
    ];

    parse_ok( $text, $expect, 'unordered list with multi-line single list item' );
}

{
    my $text = <<'EOF';
* l1
continues
* l3
EOF

    my $expect = [
        {
            type => 'unordered_list',
        },
        [
            { type => 'list_item' },
            [
                {
                    type => 'text',
                    text => "l1\ncontinues\n",
                },
            ],
            { type => 'list_item' },
            [
                {
                    type => 'text',
                    text => "l3\n",
                }
            ],
        ],
    ];

    parse_ok( $text, $expect, 'unordered list with multi-line single list item (no indent for continuation)' );
}

{
    my $text = <<'EOF';
* l1

  para

* l3
EOF

    my $expect = [
        {
            type => 'unordered_list',
        },
        [
            { type => 'list_item' },
            [
                { type => 'paragraph' },
                [
                    {
                        type => 'text',
                        text => "l1\n",
                    },
                ],
                { type => 'paragraph' },
                [
                    {
                        type => 'text',
                        text => "  para\n",
                    },
                ],
            ],
            { type => 'list_item' },
            [
                {
                    type => 'text',
                    text => "l3\n",
                }
            ],
        ],
    ];

    parse_ok( $text, $expect, 'unordered list with first item having two paragraphs' );
}

{
    my $text = <<'EOF';
* l1

  para

straight para
EOF

    my $expect = [
        {
            type => 'unordered_list',
        },
        [
            { type => 'list_item' },
            [
                { type => 'paragraph' },
                [
                    {
                        type => 'text',
                        text => "l1\n",
                    },
                ],
                { type => 'paragraph' },
                [
                    {
                        type => 'text',
                        text => "  para\n",
                    },
                ],
            ],
        ],
        { type => 'paragraph' },
        [
            {
                type => 'text',
                text => "straight para\n",
            }
        ],
    ];

    parse_ok( $text, $expect, 'unordered list with first item having two paragraphs followed by regular paragraph' );
}