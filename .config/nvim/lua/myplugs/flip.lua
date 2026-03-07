local M = {}

--[[
# TODO

- flip booleans (true -> false)
- flip custom (yes->no (keep the case: Yes -> No))
- flip rotate (north->west->...->north), linear (a:15 -inc(a)-> 16)
    - NOTE: have a iterator functionallity to generate the next for special cases
- flip comparisons ('<' to '=>')
- flip ops ('+' to '-', 'or' to 'and')
- flip num sings ('10' to '-10')
- flip case (fooBar to foo_bar)
- convert numbers to another base (21 -> 0x15 -> 0o25, 16px -> Xrem, 1GB -> 1000MB)
- flip dates (add a month, a day, ...)
- flip versions (mayor, minor, fix)
--]]

return M
