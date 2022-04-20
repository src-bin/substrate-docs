# Accessing the AWS Console

Sometimes there's no substitute for the AWS Console. When you have lots of AWS accounts, getting into the AWS Console in the right account can be a challenge. Substrate's here to help.

Visit <https://example.com/accounts> (substituting your Intranet DNS domain name) to see a listing of all your AWS accounts with links to launch the AWS Console. (Note well: A regrettable known issue with this mechanism for getting in is that you must affirmatively logout of the AWS Console before returning to this page and choosing a different account.)

In your terminal, you can use the `-console` option to any normal invocation of `substrate assume-role` to open the AWS Console in your browser right from there.

You may also be interested in [accessing AWS in your terminal](../accessing-aws-in-your-terminal/).
