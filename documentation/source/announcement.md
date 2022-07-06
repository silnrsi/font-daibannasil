fontversion: 4.000

The previous weights in two families (Dai Banna SIL Light and Dai Banna SIL Book) are now included in one family (Dai Banna SIL) with an additional weight (Medium).

For the New Tai Lue (Xishuangbanna Dai) characters the weights should be the same as before, just with different font names.
For example, Dai Banna SIL Light (Bold) is now Dai Banna SIL (SemiBold). Note the change in the font name and the (weight).

If there are any differences, the change in build tools (and sources) would probably be the reason.
The build process for the fonts completely changed to using open sources built using open source tools.

Most of the Latin characters have been replaced. In the previous release the Latin characters were the same weight
even if the New Tai Lue (Xishuangbanna Dai) characters were a different weight.
Now a different Latin font was imported (Gentium Plus) at the correct weight (such as Bold) and style (such as Italic).
